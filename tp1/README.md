# Trabajo Práctico 1
Documentación del TP 1

## Material de referencia
* [Estructuras_y_Datos.xls](https://drive.google.com/file/d/0BxKJAFKQWp8US1pDMFdZRi1TM3JvSmZMSUFYTDBwWjRDMjQw/view?usp=sharing)
* [sotp2019_1C_Grupox.doc](https://drive.google.com/file/d/0BxKJAFKQWp8UaHZHVmdIR2gyLVI5dkV5ZzlQLURxYU5EYnRF/view?usp=sharing)

## Requisitos del sistema
Completar

## Descargar 
Click [aquí](tp1/download/grupo03.tgz) para descargar la última versión del programa.

### Descomprimir

    $ tar -xzf grupo03.tgz

Para descomprimir en una subcarpeta

    $ mkdir subcarpeta
    $ tar -xzf grupo03.tgz -C subcarpeta

## Ejecución
Para ejecutar el proceso desde cero se debe correr:

    $ ./instalador.sh
    $ ./$DIRECTORIO_EJECUTABLES/inicializacion.sh
    $ ./$DIRECTORIO_EJECUTABLES/start.sh


## Generación
Para generar el paquete de instalación contenido en el archivo instalable en formato “.tgz”:

    $ make

El output del make es el archivo `grupo03.tgz`

## Logs
Un log es un registro oficial de eventos durante un periodo de tiempo en particular. 
Es usado para registrar información sobre cuándo, quién, dónde, qué y por qué un evento ocurre para una aplicación, proceso o dispositivo. 
A estos 5 valores se los llama estándar W5, por su origen en inglés: when, who, where, what and why

En el programa se sigue el siguiente esquema:

```txt
Fecha (when)           | Usuario (who) | Proceso (what)   | Mensaje (why & where)
2019-04-27 21:17:42.476 ignacio         Instalación       --- Iniciando instalación ---
2019-04-27 21:17:42.478 ignacio         Instalación       [GRUPO] /vagrant/tp1/nacho/grupo3 vagrant
2019-04-27 21:17:42.479 ignacio         Instalación       [CONF] /vagrant/tp1/nacho/grupo3/conf-vagrant
...

```
