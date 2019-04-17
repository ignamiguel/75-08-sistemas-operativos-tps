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
# DIRECTORIO_NOV_PROCESADAS
# DIRECTORIO_FALLIDOS
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

if [ ! -f conf/tpconfig.txt ]; then
    echo 'no existe la config'
fi

echo 'done'