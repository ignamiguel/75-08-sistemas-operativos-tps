#!/bin/bash

configurarDirectorios(){
	clear
	echo '-----------' 
	echo 'Instalación'
	echo '-----------' 
	echo

	echo 'Configuración de Directorios'
	echo '---------------------------------------------' 
	echo
	#leer el dato del teclado y guardarlo en la variable de directorio correspondiente
	read -p "Defina el directorio de Ejecutables: " DIRECTORIO_EJECUTABLES
	read -p "Defina el directorio de Archivos Maestros: " DIRECTORIO_MAESTROS
	read -p "Defina el directorio de Novedades: " DIRECTORIO_NOVEDADES
	read -p "Defina el directorio de Novedades Aceptadas: " DIRECTORIO_ACEPTADOS
	read -p "Defina el directorio de Novedades Rechazadas: " DIRECTORIO_RECHAZADOS
	read -p "Defina el directorio de Novedades Procesadas: " DIRECTORIO_PROCESADOS
	read -p "Defina el directorio de Archivos de Salida: " DIRECTORIO_SALIDA


	echo 'Directorios definidos para la Instalación'
	echo '---------------------------------------------' 
	echo
	#Mostrar los directorios configurados
	echo "Directorio de Ejecutables: $DIRECTORIO_EJECUTABLES"
	echo "Directorio de Archivos Maestros: $DIRECTORIO_MAESTROS"
	echo "Directorio de las Novedades: $DIRECTORIO_NOVEDADES"
	echo "Directorio de las Novedades Aceptadas: $DIRECTORIO_ACEPTADOS"
	echo "Directorio de las Novedades Rechazadas: $DIRECTORIO_RECHAZADOS"
	echo "Directorio de las Novedades Procesadas: $DIRECTORIO_PROCESADOS"
	echo "Directorio de las Archivos de Salida: $DIRECTORIO_SALIDA"
	echo '---------------------------------------------' 
	echo

	read -p "Está de acuerdo con esta definición de Directorios? S/N: " CONFIRMAR
	if [ $CONFIRMAR == "N" ] || [ $CONFIRMAR == "n" ] ; then
		echo "Instalación CANCELADA"
		configurarDirectorios
	elif [ $CONFIRMAR == "S" ] || [ $CONFIRMAR == "s" ] ; then
		#Validar todos los datos
		echo "Se instalo todo"
		#Instalar
		# Esto definitivamente se puede optimizar y hay que terminarlo,
		# es solo algo rapido para dejar una instalacion medianamente 
		# valida.
		echo DIRECTORIO_EJECUTABLES=$DIRECTORIO_EJECUTABLES >> conf/tpconfig.txt
		echo DIRECTORIO_MAESTROS=$DIRECTORIO_MAESTROS >> conf/tpconfig.txt
		echo DIRECTORIO_NOVEDADES=$DIRECTORIO_NOVEDADES >> conf/tpconfig.txt
		echo DIRECTORIO_ACEPTADOS=$DIRECTORIO_ACEPTADOS >> conf/tpconfig.txt
		echo DIRECTORIO_RECHAZADOS=$DIRECTORIO_RECHAZADOS >> conf/tpconfig.txt
		echo DIRECTORIO_PROCESADOS=$DIRECTORIO_PROCESADOS >> conf/tpconfig.txt
		echo DIRECTORIO_SALIDA=$DIRECTORIO_SALIDA >> conf/tpconfig.txt

		mkdir $DIRECTORIO_EJECUTABLES
		mkdir $DIRECTORIO_MAESTROS
		mkdir $DIRECTORIO_NOVEDADES
		mkdir $DIRECTORIO_ACEPTADOS
		mkdir $DIRECTORIO_RECHAZADOS
		mkdir $DIRECTORIO_PROCESADOS
		mkdir $DIRECTORIO_SALIDA

		cp originales/scripts/* $DIRECTORIO_EJECUTABLES

	else 
		echo -e "Error: El parametro ingresado es erroneo"
	fi
}

configurarDirectorios
echo
#Avisar al usuario que se ha terminado de ejecutar el script 