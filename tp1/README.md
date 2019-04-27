# Trabajo Práctico 1
Documentación del TP 1

## Material de referencia
* [Estructuras_y_Datos.xls](https://drive.google.com/file/d/0BxKJAFKQWp8US1pDMFdZRi1TM3JvSmZMSUFYTDBwWjRDMjQw/view?usp=sharing)
* [sotp2019_1C_Grupox.doc](https://drive.google.com/file/d/0BxKJAFKQWp8UaHZHVmdIR2gyLVI5dkV5ZzlQLURxYU5EYnRF/view?usp=sharing)

## Ejecución
Para generar el paquete de instalación contenido en el archivo instalable en formato “.tgz”:

    $ make

El output del make es el archivo `grupo03.tfg`

Para descomprimir:

    $ tar -xzf grupo03.tfg

Para descomprimir en una subcarpeta:

    $ mkdir subcarpeta
    $ tar -xzf grupo03.tfg -C subcarpeta

Para ejecutar el proceso desde cero se debe correr:

    $ ./instalador.sh
    $ ./$DIRECTORIO_EJECUTABLES/inicializacion.sh
    $ ./$DIRECTORIO_EJECUTABLES/start.sh

