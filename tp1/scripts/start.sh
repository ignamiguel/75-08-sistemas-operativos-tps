#!/bin/bash

# 0: el proceso se inició correctamente.
# 1: el proceso no se inició porque ya estaba en ejecución.
# 2: el proceso no se inició porque no está inicializado el sistema.

function write_to_log(){
    # ---------------------------------------------------------------------
    # Escribe el mensaje en el log y lo comunica al usuario.
    # 
    # Recibe por parámetro:
    # 1) Tipo de error (INF, ALE o ERR)
    # 2) Mensaje de error
    # 3) Mensaje extra para comunicar al usuario
    # ---------------------------------------------------------------------
    local fecha=$(date '+%d/%m/%Y %H:%M:%S')
    # Escribir en el log
    echo "$fecha-$USER-start-$1-$2" >> "$log/start.log"
    
    if [ "$1" = "ERR" ]; then
        # Mostrar el mensaje por stderr
        1>&2 echo $2;
        if [ "$3" ]; then 1>&2 echo $3; fi
    else
        # Mostrar el mensaje por stdout
        echo $2;
        if [ "$3" ]; then echo $3; fi
    fi    
}

write_to_log "INF" "Inicia el comando start.sh."

# Me fijo si ya existe el proceso
proceso=$(ps -A -o args ww | grep '.*proceso.sh$')
if [ ! -z "$proceso" ]; then
    echo "$proceso"
    write_to_log "ERR" "No se inicia el proceso dado que ya está en ejecución."
    exit 1
fi

write_to_log "INF" "No existe el proceso en ejecución. Se procederá a ver si el sistema está inicializado."

if [ ! $inicializado ]; then
    write_to_log "ERR" "No se inicia el proceso dado que el sistema no está inicializado." "Puede inicializarlo ejecutando $ejecutables/inicializacion.sh."
    exit 2
fi

write_to_log "INF" "El sistema está inicializado. Se procederá a inicia el proceso."

"$ejecutables/proceso.sh" &

write_to_log "INF" "Se inició el proceso con el pid $!."
exit 0