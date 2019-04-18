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
	# Utilizo un array asociativo para después poder iterar los directorios
	declare -A dirs
	#leer el dato del teclado y guardarlo en la variable de directorio correspondiente
	read -p "Defina el directorio de Ejecutables: " dirs[ejecutables]
	read -p "Defina el directorio de Archivos Maestros: " dirs[maestros]
	read -p "Defina el directorio de Novedades: " dirs[novedades]
	read -p "Defina el directorio de Novedades Aceptadas: " dirs[aceptados]
	read -p "Defina el directorio de Novedades Rechazadas: " dirs[rechazados]
	read -p "Defina el directorio de Novedades Procesadas: " dirs[proesados]
	read -p "Defina el directorio de Archivos de Salida: " dirs[salida]


	echo 'Directorios definidos para la Instalación'
	echo '---------------------------------------------' 
	echo
	#Mostrar los directorios configurados
	echo "Directorio de Ejecutables: ${dirs[ejecutables]}"
	echo "Directorio de Archivos Maestros: ${dirs[maestros]}"
	echo "Directorio de las Novedades: ${dirs[novedades]}"
	echo "Directorio de las Novedades Aceptadas: ${dirs[aceptados]}"
	echo "Directorio de las Novedades Rechazadas: ${dirs[rechazados]}"
	echo "Directorio de las Novedades Procesadas: ${dirs[procesados]}"
	echo "Directorio de las Archivos de Salida: ${dirs[salida]}"
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
		
		# Guardo dirs en conf/tpconfig.txt
		echo 'declare -A dirs' > conf/tpconfig.txt
		echo 'dirs=(' >> conf/tpconfig.txt
		for dir in "${!dirs[@]}"; do
			echo -e "\t[$dir]=${dirs[$dir]}" >> conf/tpconfig.txt
		done
		echo ')' >> conf/tpconfig.txt

		# Creo los directorios
		mkdir ${dirs[@]}

		# Copio los scripts
		cp originales/scripts/* ${dirs[ejecutables]}

	else 
		echo -e "Error: El parametro ingresado es erroneo"
	fi
}

configurarDirectorios
echo
#Avisar al usuario que se ha terminado de ejecutar el script 