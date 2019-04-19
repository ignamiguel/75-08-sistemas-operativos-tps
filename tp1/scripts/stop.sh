#!/bin/bash

# 0: el proceso se detuvo correctamente.
# 1: el proceso no se detuvo porque no estaba en ejecución.

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
    echo "$fecha-$USER-stop-$1-$2" >> "$log/stop.log"
    
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

write_to_log "INF" "Inicia el comando stop.sh."

# Me fijo se existe el proceso y guardo su pid
pid=$(ps -A -o pid,args ww | grep '.*proceso.sh$' | sed 's/^ *\([0-9]*\) .*/\1/')
if [ -z "$pid" ]; then
    write_to_log "ERR" "El proceso no se encuentra en ejecución."
    exit 1
fi

write_to_log "INF" "El proceso se encuentra en ejecución con el pid $pid. Se procede a terminarlo."

# Termino con el proceso
kill $pid

write_to_log "INF" "Se terminó el proceso $pid satisfactoriamente."
exit 0