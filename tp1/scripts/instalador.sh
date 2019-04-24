#!/bin/bash

GRUPO=~/grupo03

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
	clear
	echo '-----------' 
	echo 'Instalación'
	echo '-----------' 
	echo

	echo 'Configuración de Directorios'
	echo '-------------------------------------------------------------' 
	echo
	# Utilizo un array asociativo para después poder iterar los directorios
	declare -A dirs
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

	echo '-------------------------------------------------------------' 
	echo '| ATENCIÓN!                                                 |'
	echo '-------------------------------------------------------------' 
	echo '|Los LOGs del sistema se guardarán en la carpeta /CONF/LOG. |' 
	echo '-------------------------------------------------------------' 
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

	read -p "Está de acuerdo con esta definición de Directorios? S/N: " CONFIRMAR
	if [ $CONFIRMAR == "N" ] || [ $CONFIRMAR == "n" ] ; then
		echo "Instalación CANCELADA"
		configurarDirectorios
	elif [ $CONFIRMAR == "S" ] || [ $CONFIRMAR == "s" ] ; then
		#Validar todos los datos
		echo "Se instalo todo"
		#Instalar
				
		# Guardo dirs y otras carpetas en conf/tpconfig.txt
		grupo=$( cd "$(dirname "$BASH_SOURCE")" >/dev/null 2>&1 && pwd )
		fecha=$(date '+%d/%m/%Y %H:%M:%S')
		echo "grupo-$grupo-$USER-$fecha" > conf/tpconfig.txt
		echo "conf-$grupo/conf-$USER-$fecha" >> conf/tpconfig.txt
		echo "log-$grupo/conf/log-$USER-$fecha" >> conf/tpconfig.txt
		for dir in "${!dirs[@]}"; do
			echo "$dir-$grupo/${dirs[$dir]}-$USER-$fecha" >> conf/tpconfig.txt
		done

		# Creo los directorios
		mkdir ${dirs[@]}

		# Copio los scripts
		cp originales/scripts/* ${dirs[ejecutables]}

		# Copio los archivos maestros
		cp originales/datos/{Operadores.txt,Sucursales.txt} ${dirs[maestros]}

	else 
		echo -e "Error: El parametro ingresado es erroneo"
	fi
}

inicializarVariablesDefault
configurarDirectorios
echo
#Avisar al usuario que se ha terminado de ejecutar el script 