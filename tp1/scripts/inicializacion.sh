#!/bin/bash

# 1) Lee /conf/tpconfig.txt.
# 2) Carga las variables allí establecidas.
# 3) Si faltan las carpetas indicadas por las variables u otros 
# archivos necesarios, el sistema debe reparase por lo cual finaliza la
# inicialización.
# 4) Chequea tener permisos de lectura y escritura sobre los scripts, y
# los corrige en caso de ser necesario.
# 5) Chequea tener permiso de lectura sobre los archivos maestros, y 
# lo corrige en caso de ser necesario.
# 6) Setea las variables de /conf/tpconfig.txt como variables de 
# ambiente.
# 
# Para chequear que el sistema fue inicializado busca la variable de 
# ambiente $inicializado. Si $inicializado == true entonces el sistema
# está inicializado y finaliza la ejecucion. En caso contrario realiza
# los pasos descritos previamente.
# 
# Setea las siguientes variables de ambiente:
# - ejecutables
# - maestros
# - novedades
# - aceptados
# - rechazados
# - proesados
# - salida
# - dir_keys=las variables anteriores separadas por espacios (sirve 
# para iterar por ellas).

# Nota: No debe ejecutarse como un proceso hijo porque de esa forma las
# variables de ambiente no serían accesibles para otros scripts. Se 
# debe ejecutar como . $ejecutables/inicializacion.sh.
# 
# Devuelve los siguientes valores para cada uno de los escenarios:
# 0: el sistema fue inicializado correctamente.
# 1: el sistema ya estaba inicializado.
# 2: no existe algún directorio.
# 3: no existe algún script.
# 4: no existe algún archivo maestro.

conf_dir=$( cd "$(dirname "$BASH_SOURCE")" >/dev/null 2>&1 && pwd )/../conf

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
    echo "$fecha-$USER-inicializacion-$1-$2" >> "$conf_dir/log/inicializacion.log"
    
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

reparar="Ejecute ./instalador.sh -r para reparar el sistema."

# Me fijo si ya está inicializado
if [ $inicializado ]; then
    write_to_log "ERR" "Inicialización cancelada. El sistema ya está inicializado." "Si el proceso no está en ejecución puede iniciarlo con ${dirs[ejecutables]}/start.sh."
    return 1
fi
write_to_log "INF" "El sistema no está inicializado, se procede a inicializarlo."

# Cargo los directorios en la variable dirs
declare -x -A dirs
while read -r reg; do # reg=registro
    IFS="-" read -ra campos <<< "$reg"
    dirs[${campos[0]}]="${campos[1]}"
done < "$conf_dir/tpconfig.txt"

# Me fijo que existan los directorios
for dir_key in "${!dirs[@]}"; do
    if [ ! -d "${dirs[$dir_key]}" ]; then
        write_to_log "ERR" "Inicialización cancelada. No existe el directorio ${dirs[$dir_key]}, el cual es el directorio designado para los archivos $dir_key." "$reparar"
        return 2
    fi
done
write_to_log "INF" "La verificación de directorios es exitosa."

# Me fijo que existan los scripts y tener permiso de lectura y ejecucíon sobre ellos
for script in "${dirs[ejecutables]}"/{inicializacion.sh,instalador.sh,proceso.sh,start.sh,stop.sh}; do
    # Existencia
    if [ ! -f "$script" ]; then
        write_to_log "ERR" "Inicialización cancelada. No existe el ejecutable $script en el directorio de ejecutables ${dirs[ejecutables]}." "$reparar"
        return 3
    fi
    # Permisos
    if [ ! -r "$script" ] || [ ! -x "$script" ]; then
        chmod 500 "$script"
        write_to_log "INF" "Se corrigen los permisos sobre el script $script para poder leerlo y ejecutarlo."
    fi
done
write_to_log "INF" "La verificación de los ejecutables es exitosa."

# Me fijo que existan los archivos maestros
for archivo in "${dirs[maestros]}"/{Operadores.txt,Sucursales.txt}; do
    # Existencia
    if [ ! -f "$archivo" ]; then
        write_to_log "ERR" "Inicialización cancelada. No existe el archivo maestro $archivo en el directorio de archivos maestros ${dirs[maestros]}." "$reparar"
        return 4
    fi
    # Permisos
    if [ ! -r "$archivo" ]; then
        chmod 100 "$archivo"
        write_to_log "INF" "Se corrigen los permisos sobre el archivo maestro $archivo para poder leerlo."
    fi
done
write_to_log "INF" "La verificación de los archivos maestros es exitosa."

# Al finalizar cambio la variable inicializado a true, exporto dirs y escribo el log
export inicializado=true
for dir_key in "${!dirs[@]}"; do
    export "${dir_key}"="${dirs[$dir_key]}"
done
export dir_keys="${!dirs[@]}"

write_to_log "INF" "El sistema fue inicializado correctamente."

# Comenzar el proceso. Se deja que lo haga start.sh.
"${dirs[ejecutables]}/start.sh"

return 0