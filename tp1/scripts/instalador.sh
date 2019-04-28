#!/bin/bash

GRUPO=$(pwd)
CONF="conf"
CONF_DIR="${GRUPO}/${CONF}"
LOG_DIR="${CONF_DIR}/log"
CONFIG_FILE="${CONF_DIR}/tpconfig.txt"
LOG_FILE="${LOG_DIR}/instalacion.log"


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
	echo '-----------' 2>&1 | tee -a $LOG_FILE
	echo 'Instalación' 2>&1 | tee -a $LOG_FILE
	echo '-----------' 2>&1 | tee -a $LOG_FILE
	echo

	echo 'Configuración de Directorios' 2>&1 | tee -a $LOG_FILE
	echo '-------------------------------------------------------------' 2>&1 | tee -a $LOG_FILE
	echo 'Puede cambiar los directorios o bien mantener el default (ejemplo/dir/default)'
	echo
	
	echo "[1/7] Defina el directorio de Ejecutables (${GRUPO}/${EJECUTABLES_DEFAULT}). Para continuar presione [ENTER]" 2>&1 | tee -a $LOG_FILE
	read EJECUTABLES
	EJECUTABLES="${EJECUTABLES:-$EJECUTABLES_DEFAULT}"
	EJECUTABLES_DEFAULT=$EJECUTABLES
	echo "${GRUPO}/${EJECUTABLES}" >> $LOG_FILE

	echo "[2/7] Defina el directorio de Archivos Maestros (${GRUPO}/${MAESTROS_DEFAULT}). Para continuar presione [ENTER]" 2>&1 | tee -a $LOG_FILE
	read MAESTROS 
	MAESTROS="${MAESTROS:-$MAESTROS_DEFAULT}"
	MAESTROS_DEFAULT=$MAESTROS
	echo "${GRUPO}/${MAESTROS}" >> $LOG_FILE

	echo "[3/7] Defina el directorio de Novedades (${GRUPO}/${NOVEDADES_DEFAULT}). Para continuar presione [ENTER]" 2>&1 | tee -a $LOG_FILE
	read NOVEDADES
	NOVEDADES="${NOVEDADES:-$NOVEDADES_DEFAULT}"
	NOVEDADES_DEFAULT=$NOVEDADES
	echo "${GRUPO}/${NOVEDADES}" >> $LOG_FILE

	echo "[4/7] Defina el directorio de Novedades Aceptadas (${GRUPO}/${ACEPTADOS_DEFAULT}). Para continuar presione [ENTER]" 2>&1 | tee -a $LOG_FILE
	read ACEPTADOS
	ACEPTADOS="${ACEPTADOS:-$ACEPTADOS_DEFAULT}"
	ACEPTADOS_DEFAULT=$ACEPTADOS
	echo "${GRUPO}/${ACEPTADOS}" >> $LOG_FILE

	echo "[5/7] Defina el directorio de Novedades Rechazadas (${GRUPO}/${RECHAZADOS_DEFAULT}). Para continuar presione [ENTER]" 2>&1 | tee -a $LOG_FILE
	read RECHAZADOS
	RECHAZADOS="${RECHAZADOS:-$RECHAZADOS_DEFAULT}"
	RECHAZADOS_DEFAULT=$RECHAZADOS
	echo "${GRUPO}/${RECHAZADOS}" >> $LOG_FILE

	echo "[6/7] Defina el directorio de Novedades Procesadas (${GRUPO}/${PROCESADOS_DEFAULT}). Para continuar presione [ENTER]" 2>&1 | tee -a $LOG_FILE
	read PROCESADOS
	PROCESADOS="${PROCESADOS:-$PROCESADOS_DEFAULT}"
	PROCESADOS_DEFAULT=$PROCESADOS
	echo "${GRUPO}/${PROCESADOS}" >> $LOG_FILE

	echo "[7/7] Defina el directorio de Archivos de Salida (${GRUPO}/${SALIDAS_DEFAULT}). Para continuar presione [ENTER]" 2>&1 | tee -a $LOG_FILE 
	read SALIDAS
	SALIDAS="${SALIDAS:-$SALIDAS_DEFAULT}"
	SALIDAS_DEFAULT=$SALIDAS
	echo "${GRUPO}/${SALIDAS}" >> $LOG_FILE

	# Utilizo un array asociativo para después poder iterar los directorios
	# declare -A dirs
	dirs=(${EJECUTABLES} ${MAESTROS} ${NOVEDADES} ${ACEPTADOS} ${RECHAZADOS} ${PROCESADOS} ${SALIDAS})
	validarDirectorios
	
	if [[ $error -eq 1 ]]; then 
		echo '---------------------------------------------------------------------' 2>&1 | tee -a $LOG_FILE
		echo '| ¡ERROR!                                                           |' 2>&1 | tee -a $LOG_FILE
		echo '---------------------------------------------------------------------' 2>&1 | tee -a $LOG_FILE
		echo "Se han definido directorios iguales para dos o más carpetas. Recuerden que los mismos" 2>&1 | tee -a $LOG_FILE
		echo "son idividuales y no deben repetirse. Tampoco puede usar un directorio llamado \"${CONF}\"." 2>&1 | tee -a $LOG_FILE
		echo -e "Por favor comience la instalación nuevamente...\n" 2>&1 | tee -a $LOG_FILE
		configurarDirectorios
	else 
		echo

		echo '---------------------------------------------------------------------' 2>&1 | tee -a $LOG_FILE
		echo '| ¡ATENCIÓN!                                                        |' 2>&1 | tee -a $LOG_FILE
		echo '---------------------------------------------------------------------' 2>&1 | tee -a $LOG_FILE
		echo "Los logs del sistema se guardarán en la carpeta ${LOG_DIR}" 2>&1 | tee -a $LOG_FILE
		echo

		echo 'Directorios definidos para la Instalación' 2>&1 | tee -a $LOG_FILE
		echo '---------------------------------------------------------------------'  2>&1 | tee -a $LOG_FILE
		echo
		# Mostrar los directorios configurados
		echo "[1/7] Librería de ejecutables: [${GRUPO}/${EJECUTABLES}]" 2>&1 | tee -a $LOG_FILE
		echo "[2/7] Repositorio de archivos Maestros: [${GRUPO}/${MAESTROS}]" 2>&1 | tee -a $LOG_FILE
		echo "[3/7] Directorio para el arribo de novedades: [${GRUPO}/${NOVEDADES}]" 2>&1 | tee -a $LOG_FILE
		echo "[4/7] Directorio para las novedades aceptadas: [${GRUPO}/${ACEPTADOS}]" 2>&1 | tee -a $LOG_FILE
		echo "[5/7] Directorio para las novedades rechazadas: [${GRUPO}/${RECHAZADOS}]" 2>&1 | tee -a $LOG_FILE
		echo "[6/7] Directorio para las novedades procesadas: [${GRUPO}/${PROCESADOS}]" 2>&1 | tee -a $LOG_FILE
		echo "[7/7] Directorio para los archivos de salida: [${GRUPO}/${SALIDAS}]" 2>&1 | tee -a $LOG_FILE
		echo '---------------------------------------------------------------------' 2>&1 | tee -a $LOG_FILE
		echo "Estado de la instalación: LISTA" 2>&1 | tee -a $LOG_FILE
		echo

		OPCION="n"
		while [[ $OPCION != "S" ]] && [[ $OPCION != "s" ]]; do
			echo "¿Confirma la instalación? s/n: " 2>&1 | tee -a $LOG_FILE
			read OPCION
			echo $OPCION >> $LOG_FILE
			if [[ $OPCION == "N" ]] || [[ $OPCION == "n" ]] ; then
				echo "Instalación CANCELADA"  2>&1 | tee -a $LOG_FILE
				configurarDirectorios
			elif [[ $OPCION == "S" ]] || [[ $OPCION == "s" ]] ; then
				instalar
			else 
				echo -e "Error: El parametro ingresado es erroneo" 2>&1 | tee -a $LOG_FILE
			fi
		done
	fi
}

instalar(){
	if [ ! -d ${GRUPO} ]; then
		mkdir "${GRUPO}"
	fi

	if [ ! -f $CONFIG_FILE ]; then
    echo "Creando el archivo de configuración: $CONFIG_FILE" 2>&1 | tee -a $LOG_FILE
    touch ${CONFIG_FILE}
		echo "GRUPO=$GRUPO" >> ${CONFIG_FILE}
		echo "CONF_DIR=$CONF_DIR" >> ${CONFIG_FILE}
		echo "LOG_DIR=$LOG_DIR" >> ${CONFIG_FILE}
  fi

	for dir in "${!dirs[@]}"; do
		if [ ! -d "${GRUPO}/${dirs[$dir]}" ]; then
			echo "Generando directorio ${dirs[$dir]}..." 2>&1 | tee -a $LOG_FILE
			mkdir "${GRUPO}/${dirs[$dir]}"
			echo "${dirs[$dir]}=${GRUPO}/${dirs[$dir]}" >> ${CONFIG_FILE}
		else
			echo "¡El directorio ${dirs[$dir]} ya existe!" 2>&1 | tee -a $LOG_FILE
		fi
	done

	if [ ! -d ${LOG_DIR} ]; then
		mkdir "${LOG_DIR}"
	fi

	# Copio los ejecutables
	echo "Copiando ejecutables..." 2>&1 | tee -a $LOG_FILE
	cp 'originales/scripts/'* "${GRUPO}/${EJECUTABLES}" 2>&1 | tee -a $LOG_FILE

	# Copio los archivos maestros
	echo "Copiando archivos maestros..." 2>&1 | tee -a $LOG_FILE
	cp 'originales/datos/'{Operadores.txt,Sucursales.txt} "${GRUPO}/${MAESTROS}" 2>&1 | tee -a $LOG_FILE

	echo  -e "\nLa instalación se realizo de forma correcta. Puede revisar los logs de la instalación en \"${LOG_FILE}\"" 2>&1 | tee -a $LOG_FILE
}

verificarSistema(){
	if [ -f "$CONFIG_FILE" ]; then 
		echo -e "\nAplicación ya instalada" 2>&1 | tee -a $LOG_FILE
		echo -e "\nArchivo de configuración" 2>&1 | tee -a $LOG_FILE
		echo "-----------------------------------------" 2>&1 | tee -a $LOG_FILE
		cat $CONFIG_FILE 2>&1 | tee -a $LOG_FILE
		echo "-----------------------------------------" 2>&1 | tee -a $LOG_FILE
		echo "Ejecutar ./instalador.sh -r para reparar la instación." 2>&1 | tee -a $LOG_FILE
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
	LOG_DIR=$(echo $LOG_DIR | sed "s/\/*//" | sed -r "s/\/+/\//g")
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
			if [[ $dir1 = $dir2  || $dir1 = $CONF ]]; then
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
	echo '-----------' 2>&1 | tee -a $LOG_FILE
	echo 'Reparación' 2>&1 | tee -a $LOG_FILE
	echo '-----------' 2>&1 | tee -a $LOG_FILE
}

log() {
	# Obtengo la fecha
	# con milisegundos solo funciona en Linux, no en Mac
	fecha=$(date +"%Y-%m-%d %T.%3N")
	proc="Instalación"
	echo "${fecha} $USER          $proc     $1" >> ${LOG_FILE}
}

# Chequeo si el archivo existe, si no, se crea
if [ ! -f $LOG_FILE ]; then
    touch ${LOG_FILE}
fi

log "--- Iniciando instalación ---"
clear
echo "-----------------------------------------" 2>&1 | tee -a $LOG_FILE
echo -e "Bienvenido al sistema de instalacion" 2>&1 | tee -a $LOG_FILE
echo "-----------------------------------------" 2>&1 | tee -a $LOG_FILE

if [ "$1" == "-r" ]; then
	reparar
else
	verificarSistema
fi
echo
log "--- Fin de la instalación ---"
# Avisar al usuario que se ha terminado de ejecutar el script 
