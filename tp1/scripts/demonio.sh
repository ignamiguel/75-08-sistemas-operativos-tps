#! /bin/bash
TPPATH="${PWD%/*}"
CONF="$TPPATH/conf"
LOG="$CONF/log"

NOVEDADES_PATH="$TPPATH/datos/NOVEDADES"
ACEPTADOS_PATH="$TPPATH/datos/ACEPTADOS"
RECHAZADOS_PATH="$TPPATH/datos/RECHAZADOS"
OPERADORES="$TPPATH/datos/Operadores.txt"
SUCURSALES="$TPPATH/datos/Sucursales.txt"
CONTADOR=0
PROCESADOS_PATH="$TPPATH/datos/PROCESADOS"
PATH_SALIDA=$TPPATH/datos

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
					log "$nombres es un nombre incorrecto. ha sido movido a rechazados"
				fi
		done
	
	
	for f in "$NOVEDADES_PATH"/*
	do
		
		if [ -f "$PROCESADOS_PATH/$(basename "$f")" ] 
		then
			log "$f fue procesado con anterioridad. ha sido movido a rechazados"
			mv $f "$RECHAZADOS_PATH"
			
		elif ! [ -s $f ] 
		then
			log "$f está vacio. ha sido movido a rechazados"
			mv $f "$RECHAZADOS_PATH"
		
		elif ! [ -f $f ] 
		then
			valido=false
			log "$f no es un archivo regular. ha sido movido a rechazados"
			mv $f "$RECHAZADOS_PATH"
	 	else 
	 		log "$f ha sido movido a aceptados"
	 		mv $f "$ACEPTADOS_PATH"
	 fi		

	done
}

validarTrailer()
{
	
	for f in "$ACEPTADOS_PATH"/* 
	do
	  cp_total=0
	  cantidad_lineas=0
	  lineas=-1 
	  trailer_cp=0
	  
	  while IFS=',' read -r  operador pieza nombre doc_tipo doc_numero codigo_postal;
	  do
		let "lineas=lineas + 1"
		let "cp_total=cp_total + codigo_postal"
		trailer_cp=$codigo_postal
		cantidad_lineas=$doc_numero
	  done < $f
	  
	  let "cp_total=cp_total -trailer_cp" 
	  if [ $lineas -eq $cantidad_lineas ] && [ $cp_total -eq $trailer_cp ];
	  then
		log "El trailer de $f es correcto"
	  else
		log "El trailer de $f es incorrecto. ha sido movido a rechazados"
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
		
		if  ! ( grep -q $operador "$OPERADORES" ) ;
		then
			mensaje_log="Su operador no se encuentra en el archivo de operadores"
			valido=false
		fi
		

		if  ! ( grep -q "$operador\|$codigo_postal" "$SUCURSALES" ) ;
		then
			mensaje_log="Operador y Codigo Postal invalidos"
			valido=false
		fi
		
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
               

		if [ $valido  = true ]
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
	    codigo_suc_destino=$(awk -v codigo=$codigo_postal -F ";" '{ if($6 == codigo) {print $1 } }' "$SUCURSALES")
		printf -v codigo_suc_destino '%3s' $codigo_suc_destino
		suc_destino=$(awk -v codigo=$codigo_postal -F ";" '{ if($6 == codigo) {print $2 } }' "$SUCURSALES")
		printf -v suc_destino '%25s' "$suc_destino"
	    direccion_suc_destino=$(awk -v codigo=$codigo_postal -F ";" '{if($6 == codigo) {print $3 } }' "$SUCURSALES")
		printf -v direccion_suc_destino '%25s' "$direccion_suc_destino"
		costo_entrega=$(awk -v codigo=$codigo_postal -F ";" '{ if($6 == codigo) {print $8 } }' "$SUCURSALES")
		printf -v costo_entrega '%06d' $costo_entrega
		
		if [ $valido = true ]
		then
			echo $pieza"$nombre_pad"$doc_tipo$doc_numero$codigo_postal"$codigo_suc_destino""$suc_destino""$direccion_suc_destino"$costo_entrega$archivo >> $PATH_SALIDA/"Entregas_"$operador
		else
			echo $pieza"$nombre_pad"$doc_tipo$doc_numero$codigo_postal"$codigo_suc_destino""$suc_destino""$direccion_suc_destino"$costo_entrega$archivo >> $PATH_SALIDA/"Entregas_Rechazadas"
		fi
		
	  	done < $f
		mv $f $PROCESADOS_PATH
	done
}


main ()
{
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
}
main