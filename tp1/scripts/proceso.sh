#! /bin/bash

CONTADOR=0
operadores="$maestros/Operadores.txt"
sucursales="$maestros/Sucursales.txt"

log () 
{
	# echo "$1 $2 $3"
	echo "$(date '+%d/%m/%Y %H:%M:%S')-$USER-$1-$2-$3" >> "$log/proceso.log" 
}

validarNombreTipo()
{
	
	find "$novedades" -type f -not -name "Entregas_[0-9][0-9].txt" |
		while read nombres
			do
				if [ -f "$nombres" ]
				then
					mv "$nombres" "$rechazados"
					log "validarNombreTipo" "INF" "$nombres es un nombre incorrecto. ha sido movido a rechazados"
				fi
		done
	
	for f in "$novedades"/*
	do

		if ( echo "$f" | grep -c ".*\/\*" ) ; then
			# No hay ningún archivo en el directorio novedades
			continue
		fi

		if [ -f "$procesados/$(basename "$f")" ] 
		then
			log "validarNombreTipo" "INF" "$f fue procesado con anterioridad. Ha sido movido a rechazados"
			mv "$f" "$rechazados"
			
		elif ! [ -s "$f" ] 
		then
			log "validarNombreTipo" "INF" "$f está vacio. Ha sido movido a rechazados"
			mv "$f" "$rechazados"
		
		elif ! [ -f "$f" ] 
		then
			log "validarNombreTipo" "INF" "$f no es un archivo regular. Ha sido movido a rechazados"
			mv "$f" "$rechazados"
	 	else 
	 		log "validarNombreTipo" "INF" "$f ha sido movido a aceptados"
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
		mal_formato=false

	  while IFS=',' read -r  operador pieza nombre tipo_documento numero_documento codigo_postal;
	  do
		
		if [ $lineas -eq -1 ] && [ "$operador" != "Operador" ]; then
			# El archivo no está en el formato adecuado
			# echo $operador
			log "validarTrailer" "INF" "El archivo $f no está en el formato adecuado. Ha sido movido a rechazados."
			mv "$f" "$rechazados"
			mal_formato=true
			break
		fi

		let "lineas=lineas + 1"
			if [ $lineas != 0 ] && [ ! -z "$codigo_postal" ]; then
				# salteo el encabezado y las líneas en blanco
				let "cp_total=cp_total + codigo_postal"
				let "lineas_no_en_blanco=lineas_no_en_blanco + 1"
				trailer_cp=$codigo_postal
				cantidad_lineas=$numero_documento
			fi
		done < "$f"
	  
		if ! $mal_formato; then
			let "cp_total=cp_total -trailer_cp" 
			if [ $lineas_no_en_blanco -eq $cantidad_lineas ] && [ $cp_total -eq $trailer_cp ]
			then
			log "validarTrailer" "INF" "El trailer de $f es correcto."
			else
			log "validarTrailer" "INF" "El trailer de $f es incorrecto. Ha sido movido a rechazados"
			mv "$f" "$rechazados"
			fi
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
		
		if $cabezera || [ -z "$pieza" ]; then
			# Es la primera línea y contiene la cabezera o está vacía
			cabezera=false
			continue
		fi
		bool=1 
		
		if  ! ( grep -q $operador "$operadores" );
		then
			mensaje_log="operador: $operador no se encuentra en el archivo de operadores"
			
			bool=0
		elif ! ( grep -q $operador "$sucursales" );  
		then 
			if ! (grep -q $codigo_postal "$sucursales" ) ;
			then
				mensaje_log="El operador: $operador y Codigo Postal: $codigo_postal no se encuentran en sucursales"
				
				bool=0
				fi
		fi

		
		
		
     	if [ $bool == 1 ]
        then
          	bool=0
						cabezera=true
            while IFS=',' read -r codigo_operacion nombre_operador cuit fecha_inicio fecha_final;
                do

								if $cabezera ; then
									# Es la primera línea y contiene la cabezera
									cabezera=false
									continue
								fi

								# Paso las fechas a segundo spara comparar
								fecha_final_en_seg=$(echo "$fecha_final" | sed "s-\([0-9]\{2\}\)/\([0-9]\{2\}\)/\([0-9]\{4\}\)-\2/\1/\3-" | date -f - +%s)
								fecha_inicio_en_seg=$(echo "$fecha_inicio" | sed "s-\([0-9]\{2\}\)/\([0-9]\{2\}\)/\([0-9]\{4\}\)-\2/\1/\3-" | date -f - +%s)
               	actual_en_seg=$(date +"%s")
								
								if [ "$operador" == "$codigo_operacion" ]; then
									# Encontramos el operador
								  if [ $fecha_final_en_seg -ge $actual_en_seg ] && [ $fecha_inicio_en_seg -le $actual_en_seg ]; then
										# El operador está vigente
										log "generarArchivos" "INF" "el operador: $operador se encuentra en operadores, inicio: $fecha_inicio fin: $fecha_final"
										bool=1
									else
										# El operador no está vigente
										log "generarArchivos" "INF" "el operador: $operador se encuentra en operadores, pero no está vigente: inicio: $fecha_inicio fin: $fecha_final"
										mensaje_log="El operador $operador no se encuentra vigente."
									fi
									break;
                fi
                done < "$operadores"
        fi
                
                
        if [ $bool == 1 ]
        then
            bool=0
						cabezera=true
						sucursal_encontrada=false
            while IFS=',' read -r suc_cod nom_suc dom loc pro cod_pos cod_operador precio;
            do
							if $cabezera ; then
								# Es la primera línea y contiene la cabezera
								cabezera=false
								continue
							fi

                if [ "$operador" == "$cod_operador" ] && [ "$codigo_postal" == "$cod_pos" ]
									then
									log "generarArchivos" "INF" "Se encontraro al operador: $operador y codigo: $codigo_postal en sucursales"
									bool=1
									sucursal_encontrada=true
									break;
								fi
						done < "$sucursales"
						
						# Me fijo si encontré la sucursal
						if ! $sucursal_encontrada ; then
							mensaje_log="No se encontró la sucursal con código postal $codigo_postal y operador $operador."
						fi
        fi

		printf -v pieza '%015d' $pieza
	    printf -v padding '%20s' "$(echo $nombre | awk '$1=$1')"
		printf -v numero_documento '%010d' $numero_documento
		
		cod_destino=$(awk -v codigo=$codigo_postal -F "," '{ if($6 == codigo) {print $1 } }' "$sucursales")
		printf -v cod_destino '%5s' $cod_destino
		
		suc_destino=$(awk -v codigo=$codigo_postal -F "," '{ if($6 == codigo) {print $2 } }' "$sucursales")
		printf -v suc_destino '%20s' "$suc_destino"
	    
	    direc_suc_dest=$(awk -v codigo=$codigo_postal -F "," '{if($6 == codigo) {print $3 } }' "$sucursales")
		
		printf -v direc_suc_dest '%20s' "$direc_suc_dest"
		costo=$(awk -v codigo=$codigo_postal -F "," '{ if($6 == codigo) {print $8 } }' "$sucursales")
		printf -v costo '%02d' $costo

		if [ $bool  == 1 ]
		then
			log "generarArchivos" "INF" "La pieza fue aceptada: $pieza Operador: $operador Codigo Postal: $codigo_postal"
			echo "$pieza$padding$tipo_documento$numero_documento$codigo_postal$cod_destino$suc_destino$direc_suc_dest$costo$(basename $f)" >> "$salidas/Entregas_$operador.txt"
		else
			log "generarArchivos" "INF" "La Pieza fue rechazada: $pieza Operador: $operador Codigo Postal: $codigo_postal mensaje_log: $mensaje_log"
			echo "$operador,$pieza,$nombre,$tipo_documento,$numero_documento,$codigo_postal,$mensaje_log,"$(basename "$f") >> "$salidas/Entregas_Rechazadas.txt"
		fi
		
		done < "$f"
	  
	 mv "$f" "$procesados"

	done
}


main ()
{
	while true 
	do
		CONTADOR=$((CONTADOR+1))
		log "main" "INF" "ciclo: $CONTADOR"
		# echo "ciclo: $CONTADOR"

	
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