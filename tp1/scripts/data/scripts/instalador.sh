#!/bin/bash

GRUPO=~/grupo03
CONF="CONF"
LOG="/LOG/instalacion.log"

inicializarVariablesDefault(){	
	EJECUTABLES_DEFAULT="ejecutables"
	MAESTROS_DEFAULT="maestros"
	NOVEDADES_DEFAULT="novedades"
	ACEPTADOS_DEFAULT="aceptados"
	RECHAZADOS_DEFAULT="rechazados"
	PROCESADOS_DEFAULT="procesados"
	SALIDAS_DEFAULT="salidas"
}

configurarDirectorios(){
	echo '-----------' 
	echo 'Instalación'
	echo '-----------' 
	echo

	echo 'Configuración de Directorios'
	echo '-------------------------------------------------------------' 
	echo
	# Utilizo un array asociativo para después poder iterar los directorios
	#declare -A dirs
	#leer el dato del teclado y guardarlo en la variable de directorio correspondiente
	read -p "Defina el directorio de Ejecutables (${GRUPO}/${EJECUTABLES_DEFAULT}): " EJECUTABLES #dirs[ejecutables]
	EJECUTABLES="${EJECUTABLES:-$EJECUTABLES_DEFAULT}"

	read -p "Defina el directorio de Archivos Maestros (${GRUPO}/${MAESTROS_DEFAULT}): " MAESTROS #dirs[maestros]
	MAESTROS="${MAESTROS:-$MAESTROS_DEFAULT}"

	read -p "Defina el directorio de Novedades (${GRUPO}/${NOVEDADES_DEFAULT}): " NOVEDADES #dirs[novedades]
	NOVEDADES="${NOVEDADES:-$NOVEDADES_DEFAULT}"

	read -p "Defina el directorio de Novedades Aceptadas (${GRUPO}/${ACEPTADOS_DEFAULT}): " ACEPTADOS #dirs[aceptados]
	ACEPTADOS="${ACEPTADOS:-$ACEPTADOS_DEFAULT}"

	read -p "Defina el directorio de Novedades Rechazadas (${GRUPO}/${RECHAZADOS_DEFAULT}): " RECHAZADOS #dirs[rechazados]
	RECHAZADOS="${RECHAZADOS:-$RECHAZADOS_DEFAULT}"

	read -p "Defina el directorio de Novedades Procesadas (${GRUPO}/${PROCESADOS_DEFAULT}): " PROCESADOS #dirs[proesados]
	PROCESADOS="${PROCESADOS:-$PROCESADOS_DEFAULT}"

	read -p "Defina el directorio de Archivos de Salida (${GRUPO}/${SALIDAS_DEFAULT}): " SALIDAS #dirs[salida]
	SALIDAS="${SALIDAS:-$SALIDAS_DEFAULT}"

	echo
	echo

	echo '--------------------------------------------------------------' 
	echo '| ATENCIÓN!                                                   |'
	echo '--------------------------------------------------------------' 
	echo '|Los LOGs del sistema se guardarán en la carpeta /CONF/LOG/   |' 
	echo '--------------------------------------------------------------' 
	echo
	echo

	echo 'Directorios definidos para la Instalación'
	echo '-------------------------------------------------------------' 
	echo
	#Mostrar los directorios configurados
	echo "Directorio de Ejecutables: ${GRUPO}/${EJECUTABLES}"
	echo "Directorio de Archivos Maestros: ${GRUPO}/${MAESTROS}"
	echo "Directorio de las Novedades: ${GRUPO}/${NOVEDADES}"
	echo "Directorio de las Novedades Aceptadas: ${GRUPO}/${ACEPTADOS}"
	echo "Directorio de las Novedades Rechazadas: ${GRUPO}/${RECHAZADOS}"
	echo "Directorio de las Novedades Procesadas: ${GRUPO}/${PROCESADOS}"
	echo "Directorio de las Archivos de Salida: ${GRUPO}/${SALIDAS}"
	echo '-------------------------------------------------------------' 
	echo

	OPCION="n"
	while [ $OPCION != "s" ]; do 
		read -p "Está de acuerdo con esta definición de Directorios? S/N: " OPCION
		if [ $OPCION == "N" ] || [ $OPCION == "n" ] ; then
			echo "Instalación CANCELADA"
			configurarDirectorios
		elif [ $OPCION == "S" ] || [ $OPCION == "s" ] ; then
			#Validar todos los datos
			#Instalar
			dirs=(${CONF} ${EJECUTABLES} ${MAESTROS} ${NOVEDADES} ${ACEPTADOS} ${RECHAZADOS} ${PROCESADOS} ${SALIDAS})
			
			if [ ! -d ${GRUPO} ];
			then
				mkdir "${GRUPO}"
			fi

			for dir in "${!dirs[@]}"; do
				mkdir "${GRUPO}/${dirs[$dir]}"
				#echo "$dir-$grupo/${dirs[$dir]}-$USER-$fecha" >> conf/tpconfig.txt
			done

			echo "La instalación se realizo de forma correcta. Puede revisar los logs de la instalación en ${CONF}${LOG}"

		else 
			echo -e "Error: El parametro ingresado es erroneo"
		fi
	done
}

clear
inicializarVariablesDefault
configurarDirectorios
echo
#Avisar al usuario que se ha terminado de ejecutar el script 