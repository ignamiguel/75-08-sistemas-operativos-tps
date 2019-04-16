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
	read -p "Defina el directorio de Novedades Procesadas: " DIRECTORIO_NOV_PROCESADAS	
	read -p "Defina el directorio de Novedades Fallidos: " DIRECTORIO_FALLIDOS	
	read -p "Defina el directorio de Archivos Procesados: " DIRECTORIO_PROCESADOS	
	read -p "Defina el directorio de Archivos de Salida: " DIRECTORIO_SALIDA	


	echo 'Directorios definidos para la Instalación'
	echo '---------------------------------------------' 
	echo
	#Mostrar los directorios configurados
	echo "Directorio de Ejecutables: $DIRECTORIO_EJECUTABLES"
	echo "Directorio de Archivos Maestros: $DIRECTORIO_MAESTROS"
	echo "Directorio de las Novedades: $DIRECTORIO_NOVEDADES"
	echo "Directorio de las Novedades Procesadas: $DIRECTORIO_NOV_PROCESADAS"
	echo "Directorio de las Novedades Fallidos: $DIRECTORIO_FALLIDOS"
	echo "Directorio de las Archivos Procesados: $DIRECTORIO_PROCESADOS"
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
	else 
		echo -e "Error: El parametro ingresado es erroneo"
	fi
}

configurarDirectorios
echo
#Avisar al usuario que se ha terminado de ejecutar el script 