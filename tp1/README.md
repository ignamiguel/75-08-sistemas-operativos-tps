# Trabajo Práctico 1
Documentación del TP 1

## Informe
* [sotp2019_1C_Grupo3 INFORME](https://docs.google.com/document/d/17fwBOCXZRLtW0UiFKPMIN38buXLxz6Wy7q4qGKFwdN8/edit?usp=sharing)

## Material de referencia
* [Estructuras_y_Datos.xls](https://drive.google.com/file/d/0BxKJAFKQWp8US1pDMFdZRi1TM3JvSmZMSUFYTDBwWjRDMjQw/view?usp=sharing)
* [sotp2019_1C_Grupox.doc](https://drive.google.com/file/d/0BxKJAFKQWp8UaHZHVmdIR2gyLVI5dkV5ZzlQLURxYU5EYnRF/view?usp=sharing)

## Requisitos del sistema
El sistema está diseñado para correr sobre Linux.
En particular, se agrega el archivo [Vagrantfile](../Vagrantfile) para poder correr en entornos virtuales.

## Tests
Para ejecutar los tests

    $ ./run_tests.sh

## Descargas 
Click en [download/grupo03.tgz](https://github.com/ignamiguel/75-08-sistemas-operativos-tps/blob/master/tp1/download/grupo03.tgz?raw=true) para descargar la última versión del programa.

### Descomprimir

Una vez descargado el archivo tgz se deberá descomprimir el instalador. Para eso posicionarse desde la terminal primero debemos posicionarnos en la carpeta donde se descargo el archivo y luego ejecutar el comando para descomprimir.

Para posicionarse en la carpeta donde descargo el archivo deberá abrir la terminal y colocar:

    $ cd ruta/de/descarga

Luego para descomprimir el sistema:

    $ tar -xzf grupo03.tgz

En el caso se que quiera descomprimir en una subcarpeta, debera ejecutar los comandos que colocamos a continuación.

    $ mkdir subcarpeta
    $ tar -xzf grupo03.tgz -C subcarpeta

## Instalación
Para ejecutar el proceso de instalación desde cero, debemos ubicarnos en la carpeta donde se descomprimió el paquete en el punto anterior y ejecutar el siguiente comando:

    $ ./instalador.sh

Dentro del proceso de instalación se solicitará los directorios de instalación en los cuales se copiaran los archivos y configuraciones.

![Screenshot](/images/instalador1.png)
![Screenshot](/images/installador2.png)

Como comentario adicional, el sistema dispone de una configuración de carpetas por defecto que se sugiere en cada item del instalador.

Una vez completado este paso, el proyecto se encuentra instalado. Deberá por consola ubicarse en la ruta que definio anteriormente donde se instalaron los ejecutables y ejecutar el comando de inicialización.

    $ . ./$ejecutables/inicializacion.sh

Completado este paso el Sistema se encuentra Listo para utilizar.

## Reparar Instalación
En el caso de que un error haya ocurrido con nuestro sistema, el mismo puede ser reparado y será comunicado al usuario con un mensaje por consola o bien, en los logs que mencionaremos en detalle más abajo.

Para poder correr el instalador en modo reparación, debemos ubicarnos en la carpeta donde se descomprimió el paquete y se debe ejecutar el siguiente comando:

    $ ./instalador.sh -r

De esta forma el sistema se actualizará y quedará listo para usar nuevamente.

## Ejecución

El sistema dispone de dos funciones `START` y `STOP`, las cuales explicaremos brevemente a continuación. Es importante aclarar que si el sistema no se encuentra inicializado como se menciono en el apartado de instalación, el mismo no podrá inciar.

### Start

Para comenzar con la ejecución se deberá ingresar al directorio donde se instalaron los ejecutables y ejecutar el comando Start.

    $ . ./$ejecutables/start.sh

### Stop

Para detener con la ejecución se deberá ingresar al directorio donde se instalaron los ejecutables y ejecutar el comando Stop.

    $ . ./$ejecutables/stop.sh
    
Aclaración, no se permitira que el sistema se ejecute más de una vez al mismo tiempo.
    
### Modo de Ejecución

El sistema estará corriendo desde su inicio (START) constantemente hasta que se corra el proceso de STOP. El mismo estará pendiente de los nuevos archivos que se coloquen en la carpeta de NOVEDADES que fue declarada en el instalador.

Los resultados de cada ejecución pueden ser consultados tanto en el LOG como en las carpetas definidas.

    $ . ./$procesados
    
En esta carpeta se ubicarán los archivos colocados en novedades que ya fueron procesados.

    $ . ./$rechazados
    
En esta carpeta se ubicarán los archivos colocados en novedades que fueron rechazados por el sistema por algun motivo. El mismo puede ser leido en los logs.

    $ . ./$salidas
    
Por último en esta carpeta se ubicarán las salidas de las novedades que lograron ser procesadas efectivamente.

## Generación
Para generar el paquete de instalación contenido en el archivo instalable en formato “.tgz” se debe ubicar en la carpeta donde se clono el siguiente repositorio y ejecutar el siguiente comando.

    $ make

El output del make es el archivo `grupo03.tgz` el mismo puede descomprimirse e instalarse como mencionamos más arriba.

## Logs
Un log es un registro oficial de eventos durante un periodo de tiempo en particular. 
Es usado para registrar información sobre cuándo, quién, dónde, qué y por qué un evento ocurre para una aplicación, proceso o dispositivo. 
A estos 5 valores se los llama estándar W5, por su origen en inglés: when, who, where, what and why

En el programa se sigue el siguiente esquema:

```txt
Fecha (when)           | Usuario (who) | Proceso (what)   | Mensaje (why & where)
2019-04-27 21:17:42.476 ignacio         Instalación       --- Iniciando instalación ---
2019-04-27 21:17:42.478 ignacio         Instalación       [GRUPO] /vagrant/tp1/nacho/grupo3
2019-04-27 21:17:42.479 ignacio         Instalación       [CONF] /vagrant/tp1/nacho/grupo3/conf
...

```

Estos logs se pueden revisar en cualquier momento posterior a la instalación dentro de la carpeta  `. ./CONF/LOG` donde cada proceso tendrá su log correspondiente.
