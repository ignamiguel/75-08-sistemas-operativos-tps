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

function write_to_log(){
    # ---------------------------------------------------------------------
    # Escribe el mensaje en el log y lo comunica al usuario.
    # 
    # Recibe por parámetro:
    # 1) Tipo de error (INF, ALE o ERR)
    # 2) Mensaje de error
    # 3) Mensaje extra para comunicar al usuario
    # 
    # Por último termina la ejecución del script.
    # ---------------------------------------------------------------------
    local fecha=$(date '+%d/%m/%Y %H:%M:%S')
    echo "$fecha-$USER-inicializacion-$1-$2" >> conf/log/inicializacion.log
    echo $2
    if [ $3 ]; then echo $3; fi
    exit 0
}

# Me fijo si ya está inicializado
if [ $inicializado ]; then
    write_to_log "ALE" "El sistema ya está inicializado"
fi

# Cargo los directorios en la variable dirs
declare -A dirs
config=$( cd "$(dirname "$BASH_SOURCE")" >/dev/null 2>&1 && pwd )/../conf/tpconfig.txt
while read -r reg; do # reg=registro
    IFS="-" read -ra campos <<< "$reg"
    # dirs[${campos[0]}]="${campos[1]}"
    dirs[${campos[0]}]="$(sed 's/ /\ /g' <<< "${campos[1]}")"

done < "$config"


# Me fijo que existan los directorios
for dir in "${dirs[@]}"; do
    if [ ! -d "$dir" ]; then
        write_to_log "ERR" "No existe el directorio $dir, el cual es el directorio designado para los ${dirs[$dir]}." "Ejecute ./instalador.sh -r para reparar el sistema"
    fi
done

# # Al finalizar cambio la variable inicializado a true y exporto dirs
# export dirs
# inicializado=true
