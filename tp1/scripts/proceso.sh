#! /bin/bash

CONTADOR=0
operadores="$maestros/Operadores.txt"
sucursales="$maestros/Sucursales.txt"

log () 
{
	echo "$1 $2"
	date +"%x %X $USER $1 $2" >> "$log/proceso.log" 
}

validarNombreTipo()
{
	
	find "$novedades" -type f -not -name "Entregas_[0-9][0-9].txt" |
		while read nombres
			do
				if [ -f "$nombres" ]
				then
					mv "$nombres" "$rechazados"
					log "$nombres es un nombre incorrecto. ha sido movido a rechazados"
				fi
		done
	
	for f in "$novedades"/*
	do
		echo "$f"
		if [ -f "$procesados/$(basename "$f")" ] 
		then
			log "$f fue procesado con anterioridad. ha sido movido a rechazados"
			mv "$f" "$rechazados"
			
		elif ! [ -s "$f" ] 
		then
			log "$f está vacio. ha sido movido a rechazados"
			mv "$f" "$rechazados"
		
		elif ! [ -f "$f" ] 
		then
			log "$f no es un archivo regular. ha sido movido a rechazados"
			mv "$f" "$rechazados"
	 	else 
	 		log "$f ha sido movido a aceptados"
	 		mv "$f" "$aceptados"
	 fi		

	done
}

validarTrailer()
{
	
	for f in "$aceptados"/*
	do
	  cp_total=0
	  cantidad_lineas=0
	  lineas=-1 
	  trailer_cp=0
	  lineas_no_en_blanco=-1

	  while IFS=',' read -r  operador pieza nombre tipo_documento numero_documento codigo_postal;
	  do
		let "lineas=lineas + 1"
			if [ $lineas != 0 ] && [ ! -z "$codigo_postal" ]; then
				# salteo el encabezado y las líneas en blanco
				let "cp_total=cp_total + codigo_postal"
				let "lineas_no_en_blanco=lineas_no_en_blanco + 1"
				trailer_cp=$codigo_postal
				cantidad_lineas=$numero_documento
			fi
		done < "$f"
	  
	  let "cp_total=cp_total -trailer_cp" 
	  if [ $lineas_no_en_blanco -eq $cantidad_lineas ] && [ $cp_total -eq $trailer_cp ]
	  then
		log "El trailer de $f es correcto."
	  else
		log "El trailer de $f es incorrecto. ha sido movido a rechazados"
		mv "$f" "$rechazados"
	  fi
	done
}

generarArchivos()
{
	for f in "$aceptados"/*
	do
		cabezera=true
	  while IFS=',' read -r  operador pieza nombre tipo_documento numero_documento codigo_postal;
	  do
		
		if $cabezera ; then
			# Es la primera línea y contiene la cabezera
			cabezera=false
			continue
		fi
		bool=1 
		
		if  ! ( grep -q $operador "$operadores" );
		then
			mensaje_log="operador: $operador no se encuentra en el archivo de operadores"
			
			bool=0
		fi

		if  ! ( grep -q $operador "$sucursales" );  
		then 
			if ! (grep -q $codigo_postal "$sucursales" ) ;
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
                done < "$operadores"
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
                    done < "$sucursales"
        fi

		printf -v pieza '%015d' $pieza
	    printf -v nombre_pad '%20s' "$(echo $nombre | awk '$1=$1')"
		printf -v numero_documento '%011d' $numero_documento
		
		cod_destino=$(awk -v codigo=$codigo_postal -F "," '{ if($6 == codigo) {print $1 } }' "$sucursales")
		printf -v cod_destino '%3s' $cod_destino
		
		suc_destino=$(awk -v codigo=$codigo_postal -F "," '{ if($6 == codigo) {print $2 } }' "$sucursales")
		printf -v suc_destino '%20s' "$suc_destino"
	    
	    direccion_suc_destino=$(awk -v codigo=$codigo_postal -F "," '{if($6 == codigo) {print $3 } }' "$sucursales")
		
		printf -v direccion_suc_destino '%20s' "$direccion_suc_destino"
		costo=$(awk -v codigo=$codigo_postal -F "," '{ if($6 == codigo) {print $8 } }' "$sucursales")
		printf -v costo '%02d' $costo

		if (( bool  == 1 ))
		then
			log "Pieza aceptada: $pieza Operador: $operador Codigo Postal: $codigo_postal"
			echo $pieza"$nombre_pad" $tipo_documento $numero_documento $codigo_postal"$cod_destino""$suc_destino" "$direccion_suc_destino" $costo "$(basename "$f")" >> "$salidas/Entregas_$operador.txt"
		else
			log "Pieza rechazada: $pieza Operador: $operador Codigo Postal: $codigo_postal mensaje_log: $mensaje_log"
			echo $pieza"$nombre_pad" $tipo_documento $numero_documento $codigo_postal"$cod_destino""$suc_destino" "$direccion_suc_destino" $costo "$(basename "$f")" >> "$salidas/Entregas_Rechazadas.txt"
		fi
		
		done < "$f"
	  #Fin proceso, mover archivo a procesado
	 # mv "$f" $procesados

	done
}


main ()
{
	while true 
	do
		CONTADOR=$((CONTADOR+1))
		log "ciclo:" "$CONTADOR"
		echo "ciclo: $CONTADOR"

	
		if [ "$(ls -A "$novedades")" ] 
		then	
			validarNombreTipo
		fi

		if [ "$(ls -A "$aceptados")" ] 
		then	
			validarTrailer
		fi

		if [ "$(ls -A "$aceptados")" ] 
		then
			
			generarArchivos
			echo "fin"	
		fi
		sleep 1m
	done
}
main