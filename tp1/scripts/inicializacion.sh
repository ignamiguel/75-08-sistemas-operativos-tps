# Breve descripción:
# 
# Para chequear que el sistema fue inicializado busca la variable de ambiente $inicializado
# Si $inicializado == true entonces el sistema está inicializado. En caso contrario continúa
# con los siguientes pasos:
# 
# 1) Lee /conf/tpconfig.txt.
# 2) Carga las variables de ambiente.
# 3) Si faltan las carpetas indicadas por las variables de ambiente u otros archivos 
# necesarios, el sistema debe reparase por lo cual finaliza la inicialización.
# 4) Si existen todas las carpetas indicadas en /conf/tpconfig.txt y todos los archivos 
# necesarios, el sistema continúa.
# 
# Variables definidas en /conf/tpconfig.txt:
# DIRECTORIO_EJECUTABLES
# DIRECTORIO_MAESTROS
# DIRECTORIO_NOVEDADES
# DIRECTORIO_ACEPTADOS
# DIRECTORIO_RECHAZADOS
# DIRECTORIO_PROCESADOS
# DIRECTORIO_SALIDA
# 
# Notar:
# 1) Los archivos del directorio maestro deben tener permiso de lectura, si no lo tiene 
# corregirlo.
# 2) Los ejecutables deben tener permiso de lectura y ejecución, si no lo tiene, 
# corregirlo.
# 3) Setear variables de ambiente:
# Todos los identificadores de directorio definidos en /conf/tpconfig.txt deben definirse como
# variables de ambiente con el contenido adecuado.
# Estas variables deben permanecer durante toda la ejecución del sistema y ser accesibles por todos
# los comandos desencadenados a partir de éste.
# El único que lee el archivo de configuración es este script, el resto de los comandos trabajan con
# las variables de ambiente directamente.
# 4) En el caso 3) invocar al script PROCESO e indicar por pantalla y en el log el process id.
# 5) ADVERTENCIA: no invocar el proceso si ya hay uno corriendo
# 6) Grabar log mientras se ejecuta el script. Mostrar lo mismo en pantalla
# 7) Se puede ejecura una vez que el sistema fue instalado
# 8) No debe ejecutarse como un proceso hijo porque de esa forma las variables de ambiente no 
# serían accesibles para otros scripts. Se debe ejecutar como ${dirs[ejecutables]}/inicializacion.sh.
# 
# Devuelve los siguientes valores para cada uno de los escenarios:
# 0: el sistema fue inicializado correctamente
# 1: el sistema ya estaba inicializado
# 2: no existe algún directorio
# 3: no existe algún script
# 4: no existe algún archivo maestro

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
    echo "$fecha-$USER-inicializacion-$1-$2" >> conf/log/inicializacion.log
    
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
    write_to_log "ALE" "Inicialización cancelada. El sistema ya está inicializado." "Si el proceso no está en ejecución puede iniciarlo con ${dirs[ejecutables]}/start.sh."
    return 1
fi
write_to_log "INF" "El sistema no está inicializado, se procede a inicializarlo."

# Cargo los directorios en la variable dirs
declare -A dirs
config=$( cd "$(dirname "$BASH_SOURCE")" >/dev/null 2>&1 && pwd )/../conf/tpconfig.txt
while read -r reg; do # reg=registro
    IFS="-" read -ra campos <<< "$reg"
    dirs[${campos[0]}]="${campos[1]}"
done < "$config"

# Me fijo que existan los directorios
for dir_key in "${!dirs[@]}"; do
    if [ ! -d "${dirs[$dir_key]}" ]; then
        write_to_log "ERR" "No existe el directorio ${dirs[$dir_key]}, el cual es el directorio designado para los archivos \"$dir_key\"." "$reparar"
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
export dirs
export inicializado=true
write_to_log "INF" "El sistema fue inicializado correctamente."

# Comenzar el proceso
"${dirs[ejecutables]}/proceso.sh" &
write_to_log "INF" "El proceso lleva el pid $!."

return 0