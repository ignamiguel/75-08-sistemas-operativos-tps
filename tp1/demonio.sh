#! /bin/bash
TPPATH="$PWD"
CONF="$TPPATH/conf"
LOG="$CONF/log"

NOVEDADES_PATH="$TPPATH/NOVEDADES"
ACEPTADOS_PATH="$TPPATH/ACEPTADOS"
RECHAZADOS_PATH="$TPPATH/RECHAZADOS"
OPERADORES="$TPPATH/operadores.txt"
SUCURSALES="$TPPATH/sucursales.txt"
CONTADOR=0
PROCESADOS_PATH="$TPPATH/PROCESADOS"
PATH_SALIDA=$TPPATH/

log ()
{
        date +"$USER-%x-%X-$1-$2" >> "$LOG/proceso.log" 
}

validarNombreTipo()
{
	
	find "$NOVEDADES_PATH" -type f -not -name "Entregas_[0-9][0-9].txt" |
		while read nombres
			do
				if [ -f "$nombres" ]
				then
					mv "$nombres" "$RECHAZADOS_PATH"
					log "$nombres es un nombre incorrecto"
				fi
		done
	
	
	for f in "$NOVEDADES_PATH"/*
	do
		VALIDO=true 

		if ! [ -s $f ] 
		then
			
			log "$f está vacio"
			VALIDO=false
		fi 

		if ! [ -f $f ] 
		then
			VALIDO=false
			log "$f no es un archivo regular"
	 	fi

	  	
		if [ -f "$PROCESADOS_PATH/$(basename "$f")" ] 
		then
			log "$f fue procesado con anterioridad"
			VALIDO=false
		fi
		

		if [ $VALIDO = false ]
		then
			log "$f ha sido movido a rechazados"
			mv $f "$RECHAZADOS_PATH"
			
		
		else
			log "$f ha sido movido a aceptado"	
			mv $f "$ACEPTADOS_PATH"
			
			
	 	fi
	done
}

validarTrailer()
{
	
	for f in "$ACEPTADOS_PATH"/* 
	do
	  lineas=-1 
	  cp_total=0
	  trailer_cantidad_lineas=0
	  trailer_codigo_postal=0
	  
	  while IFS=',' read -r  operador pieza nombre doc_tipo doc_numero codigo_postal;
	  do
		let "lineas=lineas + 1"
		let "cp_total=cp_total + codigo_postal"
		trailer_codigo_postal=$codigo_postal
		trailer_cantidad_lineas=$doc_numero
	  done < $f
	  
	  let "cp_total=cp_total -trailer_codigo_postal" 
	  if [ $lineas -eq $trailer_cantidad_lineas ] && [ $cp_total -eq $trailer_codigo_postal ];
	  then
		log "El trailer de $f es correcto"
	  else
		log "El trailer de $f es incorrecto"
		mv $f $RECHAZADOS_PATH
	  fi
	done
}

generarArchivos()
{
	for f in "$ACEPTADOS_PATH"/*
	do
	  while IFS=',' read -r  operador pieza nombre doc_tipo doc_numero codigo_postal;
	  do
		valido=true	  	
		# operador existe en archivo operadores
		if  ! ( grep -q $operador "$OPERADORES" ) ;
		then
			mensaje_log="Su operador no se encuentra en el archivo de operadores"
			valido=false
		fi
		#perador codigo postal esta en sucursales
		if  ! ( grep -q "$operador\|$codigo_postal" "$SUCURSALES" ) ;
		then
			mensaje_log="Operador y Codigo Postal invalidos"
			valido=false
		fi
		
                #Verifico si existe el OP en operadores.txt y si tiene contrato vigente
                if [ $valido = true ]
                then
                        valido=false
                        while IFS=',' read -r codigo_op nombre_op cuit_op inicio_op fin_op;
                        do
                                mes_actual=$(date +"%m")
                                mes_inicio=$(echo "$inicio_op" | cut -d'/' -f2)
                                mes_final=$(echo "$fin_op" | cut -d'/' -f2)
                                
                                if [ "$operador" == "$codigo_op" ] && [ $mes_inicio -le $mes_actual ] && [ $mes_final -ge $mes_actual ]
                                then
                                        log "$operador se encuentra en operadores.txt, en estado activo "
                                        valido=true
                             			break;
                                fi
                        done < "$OPERADORES"
                fi
                
                # Verifico que la dupla operador-codigo postal exista
                if [ $valido = true ]
                then
                        valido=false
                        while IFS=',' read -r codigo_suc nombre_suc dom loc pro cod_pos cod_op precio;
                        do
                                if [ "$operador" == "cod_op" ] && [ "$codigo_postal" == "$cod_pos" ]
                                then
                                        valido=true
                                        log "$operador-$codigo_postal se encuentra en sucursales.txt"
                                        break;
                                fi
                        done < "$SUCURSALES"
                fi

		if (( $valido  = true ))
		then
			log "La pieza: $pieza del operador: $operador fue aceptada"
		else
			log "La pieza: $pieza del operador: $operador fue rechazada: $mensaje_log"
		fi

		printf -v pieza '%020d' $pieza
	        nombre=$(echo $nombre | awk '$1=$1')
		#completo con espacios
	       	printf -v nombre_pad '%48s' "$nombre"
		printf -v doc_numero '%011d' $doc_numero
		archivo=$(basename "$f")
	        codigo_suc_destino=$(awk -v codigo=$codigo_postal -F ";" '{ if($6 == codigo) {print $1 } }' "$ARCHIVO_SUCURSALES")
		printf -v codigo_suc_destino '%3s' $codigo_suc_destino
		suc_destino=$(awk -v codigo=$codigo_postal -F ";" '{ if($6 == codigo) {print $2 } }' "$ARCHIVO_SUCURSALES")
		printf -v suc_destino '%25s' "$suc_destino"
	        direccion_suc_destino=$(awk -v codigo=$codigo_postal -F ";" '{if($6 == codigo) {print $3 } }' "$ARCHIVO_SUCURSALES")
		printf -v direccion_suc_destino '%25s' "$direccion_suc_destino"
		costo_entrega=$(awk -v codigo=$codigo_postal -F ";" '{ if($6 == codigo) {print $8 } }' "$ARCHIVO_SUCURSALES")
		printf -v costo_entrega '%06d' $costo_entrega
		if (( valido  = true ))
		then
			echo $pieza"$nombre_pad"$doc_tipo$doc_numero$codigo_postal"$codigo_suc_destino""$suc_destino""$direccion_suc_destino"$costo_entrega$archivo >> $PATH_SALIDA/"Entregas_"$operador
		else
			echo $pieza"$nombre_pad"$doc_tipo$doc_numero$codigo_postal"$codigo_suc_destino""$suc_destino""$direccion_suc_destino"$costo_entrega$archivo >> $PATH_SALIDA/"Entregas_Rechazadas"
		fi
	done < $f
	mv $f $PROCESADOS_PATH
done
}



while true
do
	CONTADOR=$((CONTADOR+1))
	log "ciclo:" "$CONTADOR"

	
	if [ "$(ls -A "$NOVEDADES_PATH")" ]
	then	
		validarNombreTipo
	fi

	if [ "$(ls -A "$ACEPTADOS_PATH")" ]
	then	
		validarTrailer
	fi

	if [ "$(ls -A "$ACEPTADOS_PATH")" ]
	then	
		generarArchivos
	fi

	sleep 1m
done
