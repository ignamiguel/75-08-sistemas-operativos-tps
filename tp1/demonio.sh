#! /bin/bash
TPPATH="$PWD"
CONF="$TPPATH/conf"
LOG="$CONF/log"

NOVEDADES_PATH="$TPPATH/NOVEDADES"
ACEPTADOS_PATH="$TPPATH/ACEPTADOS"
RECHAZADOS_PATH="$TPPATH/RECHAZADOS"
CONTADOR=0

log ()
{
        date +"$USER-%x-%X-$1-$2" >> "$LOG/proceso.log" 
}

validarNombreTipo()
{
	
	find "$NOVEDADES_PATH" -type f -not -name "Entregas_[0-9][0-9]" |
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
	  
	  let "codigo_postal_suma=codigo_postal_suma -trailer_codigo_postal " 
	  if [ $lineas -eq $trailer_cantidad_lineas ] && [ $cp_total -eq $trailer_codigo_postal ];
	  then
		log "El trailer de $f es correcto"
	  else
		log "El trailer de $f es incorrecto"
		mv $f $RECHAZADOS_PATH
	  fi
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

	

	sleep 1m
done
