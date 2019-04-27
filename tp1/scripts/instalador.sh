#!/bin/bash

# GRUPO=~/grupo03
GRUPO=$(pwd)/grupo3
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
	# declare -A dirs
	# leer el dato del teclado y guardarlo en la variable de directorio correspondiente
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

	dirs=(${CONF} ${EJECUTABLES} ${MAESTROS} ${NOVEDADES} ${ACEPTADOS} ${RECHAZADOS} ${PROCESADOS} ${SALIDAS})
	validarDirectorios
	
	if [[ $error -eq 1 ]]; then 
		echo -e "\nATENCIÓN!; Se han definido directorios iguales para dos o más carpetas. Recuerden que los mismos"
		echo "son idividuales y no deben repetirse. Tampoco puede usar un directorio llamado /CONF."
		echo -e "Por favor comience la instalación nuevamente......\n"
		configurarDirectorios
	else 
		echo

		echo '---------------------------------------------------------------------'
		echo '| ATENCIÓN!                                                         |'
		echo '---------------------------------------------------------------------'
		echo "|Los LOGs del sistema se guardarán en la carpeta ${GRUPO}/CONF/LOG/ "
		echo
		echo

		echo 'Directorios definidos para la Instalación'
		echo '---------------------------------------------------------------------'
		echo
		# Mostrar los directorios configurados
		echo "Directorio de Ejecutables: ${GRUPO}/${EJECUTABLES}"
		echo "Directorio de Archivos Maestros: ${GRUPO}/${MAESTROS}"
		echo "Directorio de las Novedades: ${GRUPO}/${NOVEDADES}"
		echo "Directorio de las Novedades Aceptadas: ${GRUPO}/${ACEPTADOS}"
		echo "Directorio de las Novedades Rechazadas: ${GRUPO}/${RECHAZADOS}"
		echo "Directorio de las Novedades Procesadas: ${GRUPO}/${PROCESADOS}"
		echo "Directorio de las Archivos de Salida: ${GRUPO}/${SALIDAS}"
		echo '---------------------------------------------------------------------'
		echo

		OPCION="n"
		while [[ $OPCION != "s" ]]; do 
			read -p "Está de acuerdo con esta definición de Directorios? S/N: " OPCION
			if [[ $OPCION == "N" ]] || [[ $OPCION == "n" ]] ; then
				echo "Instalación CANCELADA"
				configurarDirectorios
			elif [[ $OPCION == "S" ]] || [[ $OPCION == "s" ]] ; then
				instalar
			else 
				echo -e "Error: El parametro ingresado es erroneo"
			fi
		done
	fi
}

instalar(){
	# Validar todos los datos
	# Instalar
	if [ ! -d ${GRUPO} ];
	then
		mkdir "${GRUPO}"
	fi

	for dir in "${!dirs[@]}"; do
		mkdir "${GRUPO}/${dirs[$dir]}"
	done

	mkdir ${GRUPO}/${CONF}/LOG

	log "[GRUPO] $GRUPO"
	log "[CONF] $GRUPO/$CONF"
	log "[LOG] $GRUPO/$CONF/LOG"
	for dir in "${!dirs[@]}"; do
		echo "Generando directorio ${dirs[$dir]}......."
		log "[${dirs[$dir]}] $GRUPO/${dirs[$dir]}"
	done

	# Copio los ejecutables
	echo -e "\nCopiando ejecutables....."
	cp 'data/scripts/'* "${GRUPO}/${EJECUTABLES}"

	# Copio los archivos maestros
	echo -e "\nCopiando archivos maestros....."
	cp 'data/datos/'{Operadores.txt,Sucursales.txt} "${GRUPO}/${MAESTROS}"

	echo "La instalación se realizo de forma correcta. Puede revisar los logs de la instalación en ${CONF}${LOG}"
	log "Instalación exitosa"
}

verificarSistema(){
	if [ -d "$GRUPO" ]; then 
		echo -e "\nAplicación ya instalada"
		echo -e "\nArchivo de configuración"
		echo "-----------------------------------------"
		cat ${GRUPO}/${CONF}${LOG};
		echo "-----------------------------------------"
		echo "Coloque ./instalar.sh -r para reparar la instación."
		echo "Se verifico que la aplicación ya estaba instalada" >> ${GRUPO}/${CONF}${LOG}
	else
		inicializarVariablesDefault	
		configurarDirectorios
	fi
}

formatearRutas(){
	# Se encarga de eliminar las barras / colacadas de mas
	MAESTROS=$(echo $MAESTROS | sed "s/\/*//" | sed -r "s/\/+/\//g")
	NOVEDADES=$(echo $NOVEDADES | sed "s/\/*//" | sed -r "s/\/+/\//g")
	ACEPTADOS=$(echo $ACEPTADOS | sed "s/\/*//" | sed -r "s/\/+/\//g")
	RECHAZADOS=$(echo $RECHAZADOS | sed "s/\/*//" | sed -r "s/\/+/\//g")
	PROCESADOS=$(echo $PROCESADOS | sed "s/\/*//" | sed -r "s/\/+/\//g")
	SALIDAS=$(echo $SALIDAS | sed "s/\/*//" | sed -r "s/\/+/\//g")
	LOG=$(echo $LOG | sed "s/\/*//" | sed -r "s/\/+/\//g")
}

validarDirectorios(){
	# La idea es comparar todos los elementos del vector y contar cuando hay una igualdad
	# Este contador debe ser igual a la cantidad de elementos del vector
	# dado que al compararse todos los elementos con todos se comparan los que son iguales

	contador=0 # Primer elemento a comparar
	error=0

	for dir1 in ${dirs[*]}
	do
		for dir2 in ${dirs[*]}
		do 
			if [[ $dir1 = $dir2  || $dir1 = "conf" ]]; then
				let contador=contador+1
			fi
		done
	done

	len=${#dirs[@]}

	if [ $contador -gt $len ]; then
		error=1
	fi
}

reparar() {
	echo "reparado"
}

log() {
	# Chequeo si el archivo existe, si no, lo creo
	LOG_FILE=${GRUPO}/${CONF}${LOG}
  if [ ! -f $LOG_FILE ]; then
    echo "Creando el archivo de log: $LOG_FILE"
    touch ${LOG_FILE}
  fi

	# Obtengo la fecha
  # fecha=$(date +"%Y-%m-%d %H:%M:%S")
	# con milisegundos solo funciona en Linux, no en Mac
	fecha=$(date +"%Y-%m-%d %T.%3N")
	proc="Instalación"
	echo "${fecha} $USER          $proc     $1" >> ${LOG_FILE}
}

clear
echo "-----------------------------------------"
echo -e "Bienvenido al sistema de instalacion"
echo "-----------------------------------------"
log "--- Iniciando instalación ---"
if [ "$1" == "-r" ]; then
	reparar
else
	verificarSistema
fi
echo
log "--- Fin de la instalación ---"
# Avisar al usuario que se ha terminado de ejecutar el script 
