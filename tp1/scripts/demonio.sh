#! /bin/bash
CONTADOR=0
TPPATH="${PWD%/*}"
CONF="$TPPATH/conf"
LOG="$CONF/log"
NOVEDADES="$TPPATH/datos/NOVEDADES"
ACEPTADOS="$TPPATH/datos/ACEPTADOS"
RECHAZADOS="$TPPATH/datos/RECHAZADOS"
OPERADORES="$TPPATH/datos/Operadores.txt"
SUCURSALES="$TPPATH/datos/Sucursales.txt"
PROCESADOS="$TPPATH/datos/PROCESADOS"
SALIDA=$TPPATH/datos

log () 
{
        date +"%x %X $USER $1 $2" >> "$LOG/proceso.log" 
}

validarNombreTipo()
{
	
	find "$NOVEDADES" -type f -not -name "Entregas_[0-9][0-9].txt" |
		while read nombres
			do
				if [ -f "$nombres" ]
				then
					mv "$nombres" "$RECHAZADOS"
					log "$nombres es un nombre incorrecto. ha sido movido a rechazados"
				fi
		done
	
	for f in "$NOVEDADES"/*
	do
		
		if [ -f "$PROCESADOS/$(basename "$f")" ] 
		then
			log "$f fue procesado con anterioridad. ha sido movido a rechazados"
			mv $f "$RECHAZADOS"
			
		elif ! [ -s $f ] 
		then
			log "$f está vacio. ha sido movido a rechazados"
			mv $f "$RECHAZADOS"
		
		elif ! [ -f $f ] 
		then
			log "$f no es un archivo regular. ha sido movido a rechazados"
			mv $f "$RECHAZADOS"
	 	else 
	 		log "$f ha sido movido a aceptados"
	 		mv $f "$ACEPTADOS"
	 fi		

	done
}

validarTrailer()
{
	
	for f in "$ACEPTADOS"/* 
	do
	  cp_total=0
	  cantidad_lineas=0
	  lineas=-1 
	  trailer_cp=0
	  
	  while IFS=',' read -r  operador pieza nombre tipo_documento numero_documento codigo_postal;
	  do
		let "lineas=lineas + 1"
		let "cp_total=cp_total + codigo_postal"
		trailer_cp=$codigo_postal
		cantidad_lineas=$numero_documento
	   done < $f
	  
	  let "cp_total=cp_total -trailer_cp" 
	  if [ $lineas -eq $cantidad_lineas ] && [ $cp_total -eq $trailer_cp ];
	  then
		log "El trailer de $f es correcto"
	  else
		log "El trailer de $f es incorrecto. ha sido movido a rechazados"
		mv $f $RECHAZADOS
	  fi
	done
}

generarArchivos()
{
	for f in "$ACEPTADOS"/*
	do
	  while IFS=',' read -r  operador pieza nombre tipo_documento numero_documento codigo_postal;
	  do
		
		bool=1 
		
		if  ! ( grep -q $operador "$OPERADORES" );
		then
			mensaje_log="operador: $operador no se encuentra en el archivo de operadores"
			
			bool=0
		fi

		if  ! ( grep -q $operador "$SUCURSALES" );  
		then 
			if ! (grep -q $codigo_postal "$SUCURSALES" ) ;
			then
				mensaje_log="Operador y Codigo Postal invalidos"
				
				bool=0
				fi
		fi

		
		
		
		
     	if [ $bool == 1 ]
        then
          	bool=0
            while IFS=',' read -r codigo_operacion nombre_operador cuit fecha_inicio fecha_final;
                do
                inicio=$(echo "$fecha_inicio" | cut -d'/' -f2)
                final=$(echo "$fecha_final" | cut -d'/' -f2)
                actual=$(date +"%m")
               	if [ "$operador" == "$codigo_operacion" ] && [ $final -ge $actual ] && [ $inicio -le $actual ]
                then
                	bool=1
                	log "Se encontro $operador en operadores.txt, activo desde $inicio hasta $final"
                	break;
                fi
                done < "$OPERADORES"
        fi
                
                
        if [ $bool == 1 ]
        then
            bool=0
            while IFS=',' read -r suc_cod nom_suc dom loc pro cod_pos cod_operador precio;
            do
                if [ "$operador" == "$cod_operador" ] && [ "$codigo_postal" == "$cod_pos" ]
                    then
                        bool=1
                        log "Se encontro dupla $operador-$codigo_postal en sucursales.txt"
                        break;
                    fi
                    done < "$SUCURSALES"
        fi

		printf -v pieza '%015d' $pieza
	    printf -v nombre_pad '%20s' "$(echo $nombre | awk '$1=$1')"
		printf -v numero_documento '%011d' $numero_documento
		
		cod_destino=$(awk -v codigo=$codigo_postal -F "," '{ if($6 == codigo) {print $1 } }' "$SUCURSALES")
		printf -v cod_destino '%3s' $cod_destino
		
		suc_destino=$(awk -v codigo=$codigo_postal -F "," '{ if($6 == codigo) {print $2 } }' "$SUCURSALES")
		printf -v suc_destino '%20s' "$suc_destino"
	    
	    direccion_suc_destino=$(awk -v codigo=$codigo_postal -F "," '{if($6 == codigo) {print $3 } }' "$SUCURSALES")
		
		printf -v direccion_suc_destino '%20s' "$direccion_suc_destino"
		costo=$(awk -v codigo=$codigo_postal -F "," '{ if($6 == codigo) {print $8 } }' "$SUCURSALES")
		printf -v costo '%02d' $costo

		if (( bool  == 1 ))
		then
			log "Pieza aceptada: $pieza Operador: $operador Codigo Postal: $codigo_postal"
			echo $pieza"$nombre_pad" $tipo_documento $numero_documento $codigo_postal"$cod_destino""$suc_destino" "$direccion_suc_destino" $costo "$(basename "$f")" >> $SALIDA/"Entregas_"$operador
		else
			log "Pieza rechazada: $pieza Operador: $operador Codigo Postal: $codigo_postal mensaje_log: $mensaje_log"
			echo $pieza"$nombre_pad" $tipo_documento $numero_documento $codigo_postal"$cod_destino""$suc_destino" "$direccion_suc_destino" $costo "$(basename "$f")" >> $SALIDA/"Entregas_Rechazadas"
		fi
		
		done < $f
	  #Fin proceso, mover archivo a procesado
	 # mv $f $PROCESADOS

	done
}


main ()
{
	while true 
	do
		CONTADOR=$((CONTADOR+1))
		log "ciclo:" "$CONTADOR"
		echo "ciclo: $CONTADOR"

	
		if [ "$(ls -A "$NOVEDADES")" ] 
		then	
			validarNombreTipo
		fi

		if [ "$(ls -A "$ACEPTADOS")" ] 
		then	
			validarTrailer
		fi

		if [ "$(ls -A "$ACEPTADOS")" ] 
		then
			
			generarArchivos
			echo "fin"	
		fi
		sleep 1m
	done
}
main