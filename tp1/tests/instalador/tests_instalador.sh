#!/bin/bash

RED='\033[0;31m'
GREEN='\033[1;32m'
NC='\033[0m' # No Color

printTestOk() {
    echo -e "$1 ${GREEN}OK${NC}"
}

printTestError() {
    echo -e "$1 ${RED}ERROR${NC}"
}

# ---------------------------------------------------------------------
# tests_instalador.sh
# ---------------------------------------------------------------------
# Ejecuta los tests del instalador.
# Ejecutar como tests/instalador/tests_instalador.sh.
# ---------------------------------------------------------------------

echo "---------------------------------------------------------------------"
echo "Comienzan los tests del instalador"
echo "---------------------------------------------------------------------"

# ---------------------------------------------------------------------
# Test 01
# ---------------------------------------------------------------------
# Instalo desde cero
# ---------------------------------------------------------------------

# 1) Ambiente nuevo.
tests/crear_ambiente.sh
cd tests/ambiente_de_testing

# 2) Instalo con un camino feliz. Tiro el stdout porque no me interesa
./instalador.sh < ../instalador/instalacion_feliz.txt > /dev/null

# 3) Valido la salida
if [ $? -eq 0 ]; then
    printTestOk "Test 01: instalación básica con éxito."
else
    1>&2 printTestError "Test 01: instalación básica fallida."
fi

# 4) Valido que la instalación haya sido exitosa
validacion=$(grep -c '.*La instalación se realizo de forma correcta*' conf/log/instalacion.log)
if [ $validacion -eq 1 ]; then
    printTestOk "Test 01, validacion 2: exitosa."
else
    1>&2 printTestError "Test 01, validacion 2: fallida"
fi

# 5) Vuelvo al directorio original
cd ../../



# ---------------------------------------------------------------------
# Test 02
# ---------------------------------------------------------------------
# Instalo con carpetas con espacios
# ---------------------------------------------------------------------

# 1) Ambiente nuevo.
tests/crear_ambiente.sh
cd tests/ambiente_de_testing

# 2) Instalo con un camino feliz. Tiro el stdout porque no me interesa
./instalador.sh < ../instalador/instalacion_con_espacios.txt > /dev/null

# 3) Valido la salida
if [ $? -eq 0 ]; then
    printTestOk "Test 02: instalación con espacios con éxito."
else
    1>&2 printTestError "Test 02: instalación con espacios con fallida."
fi

# 4) Valido que la instalación haya sido exitosa
validacion=$(grep -c '.*La instalación se realizo de forma correcta*' conf/log/instalacion.log)
if [ $validacion -eq 1 ]; then
    printTestOk "Test 02, validacion 2: exitosa."
else
    1>&2 printTestError "Test 02, validacion 2: fallida"
fi

# 5) Vuelvo al directorio original
cd ../../



# ---------------------------------------------------------------------
# Test 03
# ---------------------------------------------------------------------
# Instalo con carpetas duplicadas
# ---------------------------------------------------------------------

# 1) Ambiente nuevo.
tests/crear_ambiente.sh
cd tests/ambiente_de_testing

# 2) Instalo con un camino feliz. Tiro el stdout porque no me interesa
./instalador.sh  < ../instalador/instalacion_con_duplicados.txt > /dev/null

# 3) Valido la salida
if [ $? -eq 0 ]; then
    printTestOk "Test 03, validacion 1: exitosa."
else
    1>&2 printTestError "Test 03, validacion 1: fallida"
fi

# 4) Valido que en el log haya un solo mensaje que refleje esto
validacion=$(grep -c '.*Se han definido directorios iguales para dos o más carpetas.*' conf/log/instalacion.log)
if [ $validacion -eq 1 ]; then
    printTestOk "Test 03, validacion 2: exitosa."
else
    1>&2 printTestError "Test 03, validacion 2: fallida"
fi

# 5) Valido que la instalación haya sido exitosa
validacion=$(grep -c '.*La instalación se realizo de forma correcta*' conf/log/instalacion.log)
if [ $validacion -eq 1 ]; then
    printTestOk "Test 03, validacion 3: exitosa."
else
    1>&2 printTestError "Test 03, validacion 3: fallida"
fi

# 6) Vuelvo al directorio original
cd ../../



# ---------------------------------------------------------------------
# Test 04
# ---------------------------------------------------------------------
# Instalo usando conf como carpeta
# ---------------------------------------------------------------------

# 1) Ambiente nuevo.
tests/crear_ambiente.sh
cd tests/ambiente_de_testing

# 2) Instalo con un camino feliz. Tiro el stdout porque no me interesa
./instalador.sh  < ../instalador/instalacion_usando_conf.txt > /dev/null

# 3) Valido la salida
if [ $? -eq 0 ]; then
    printTestOk "Test 04, validacion 1: exitosa."
else
    1>&2 printTestError "Test 04, validacion 1: fallida"
fi

# 4) Valido que en el log haya un solo mensaje que refleje esto
validacion=$(grep -c '.*se ha utilizado un nombre reservado*' conf/log/instalacion.log)
if [ $validacion -eq 1 ]; then
    printTestOk "Test 04, validacion 2: exitosa."
else
    1>&2 printTestError "Test 04, validacion 2: fallida"
fi

# 5) Valido que la instalación haya sido exitosa
validacion=$(grep -c '.*La instalación se realizo de forma correcta*' conf/log/instalacion.log)
if [ $validacion -eq 1 ]; then
    printTestOk "Test 04, validacion 3: exitosa."
else
    1>&2 printTestError "Test 04, validacion 3: fallida"
fi

# 6) Vuelvo al directorio original
cd ../../



# ---------------------------------------------------------------------
# Test 05
# ---------------------------------------------------------------------
# Instalo usando originales como carpeta
# ---------------------------------------------------------------------

# 1) Ambiente nuevo.
tests/crear_ambiente.sh
cd tests/ambiente_de_testing

# 2) Instalo con un camino feliz. Tiro el stdout porque no me interesa
./instalador.sh  < ../instalador/instalacion_usando_originales.txt > /dev/null

# 3) Valido la salida
if [ $? -eq 0 ]; then
    printTestOk "Test 05, validacion 1: exitosa."
else
    1>&2 printTestError "Test 05, validacion 1: fallida"
fi

# 4) Valido que en el log haya un solo mensaje que refleje esto
validacion=$(grep -c '.*se ha utilizado un nombre reservado*' conf/log/instalacion.log)
if [ $validacion -eq 1 ]; then
    printTestOk "Test 05, validacion 2: exitosa."
else
    1>&2 printTestError "Test 05, validacion 2: fallida"
fi

# 4) Valido que la instalación haya sido exitosa
validacion=$(grep -c '.*La instalación se realizo de forma correcta*' conf/log/instalacion.log)
if [ $validacion -eq 1 ]; then
    printTestOk "Test 05, validacion 3: exitosa."
else
    1>&2 printTestError "Test 05, validacion 3: fallida"
fi


# 5) Vuelvo al directorio original
cd ../../



# ---------------------------------------------------------------------
# Test 06
# ---------------------------------------------------------------------
# Instalo dejando una carpeta vacía (por defecto)
# ---------------------------------------------------------------------

# 1) Ambiente nuevo.
tests/crear_ambiente.sh
cd tests/ambiente_de_testing

# 2) Instalo con un camino feliz. Tiro el stdout porque no me interesa
./instalador.sh  < ../instalador/instalacion_con_rechazados_por_defecto.txt > /dev/null

# 3) Valido la salida
if [ $? -eq 0 ]; then
    printTestOk "Test 06, validacion 1: exitosa."
else
    1>&2 printTestError "Test 06, validacion 1: fallida"
fi

# 4) Valido la carpeta
if [ -d rechazados ]; then
    printTestOk "Test 06, validacion 2: exitosa."
else
    1>&2 printTestError "Test 06, validacion 2: fallida"
fi

# 5) Valido que la instalación haya sido exitosa
validacion=$(grep -c '.*La instalación se realizo de forma correcta*' conf/log/instalacion.log)
if [ $validacion -eq 1 ]; then
    printTestOk "Test 05, validacion 3: exitosa."
else
    1>&2 printTestError "Test 05, validacion 3: fallida"
fi

# 6) Vuelvo al directorio original
cd ../../



# ---------------------------------------------------------------------
# Test 06
# ---------------------------------------------------------------------
# Instalo con todos los directorios por defecto
# ---------------------------------------------------------------------

# 1) Ambiente nuevo.
tests/crear_ambiente.sh
cd tests/ambiente_de_testing

# 2) Instalo con un camino feliz. Tiro el stdout porque no me interesa
./instalador.sh  < ../instalador/instalacion_por_defecto.txt > /dev/null

# 3) Valido la salida
if [ $? -eq 0 ]; then
    printTestOk "Test 06, validacion 1: exitosa."
else
    1>&2 printTestError "Test 06, validacion 1: fallida"
fi

# 4) Valido que la instalación haya sido exitosa
validacion=$(grep -c '.*La instalación se realizo de forma correcta*' conf/log/instalacion.log)
if [ $validacion -eq 1 ]; then
    printTestOk "Test 06, validacion 2: exitosa."
else
    1>&2 printTestError "Test 06, validacion 2: fallida"
fi

# 5) Vuelvo al directorio original
cd ../../



# ---------------------------------------------------------------------
# Test 07
# ---------------------------------------------------------------------
# Reparo con el estado de la instalación OK.
# ---------------------------------------------------------------------

# 1) Ambiente nuevo.
tests/crear_ambiente.sh
cd tests/ambiente_de_testing

# 2) Instalo con un camino feliz. Tiro el stdout porque no me interesa
./instalador.sh  < ../instalador/instalacion_por_defecto.txt > /dev/null

# 3) Reparo
./instalador.sh -r > /dev/null

# 3) Valido la salida
if [ $? -eq 0 ]; then
    printTestOk "Test 07, validacion 1: exitosa."
else
    1>&2 printTestError "Test 07, validacion 1: fallida"
fi

# 4) Valido que existan los 9 directorios
validacion=$(grep -c 'Directorio .* existe.*' conf/log/instalacion.log)
if [ $validacion -eq 9 ]; then
    printTestOk "Test 07, validacion 2: exitosa."
else
    1>&2 printTestError "Test 07, validacion 2: fallida"
fi

# 5) Vuelvo al directorio original
cd ../../



# ---------------------------------------------------------------------
# Test 08
# ---------------------------------------------------------------------
# Reparo luego de borrar el directorio de rechazados.
# ---------------------------------------------------------------------

# 1) Ambiente nuevo.
tests/crear_ambiente.sh
cd tests/ambiente_de_testing

# 2) Instalo con un camino feliz. Tiro el stdout porque no me interesa
./instalador.sh  < ../instalador/instalacion_por_defecto.txt > /dev/null

# 3) Borro el directorio de rechazados
rmdir rechazados

# 4) Reparo
./instalador.sh -r > /dev/null

# 5) Valido que exista el directorio
if [ -d rechazados ]; then
    printTestOk "Test 08: exitoso."
else
    1>&2 printTestError "Test 08: fallido"
fi

# 6) Vuelvo al directorio original
cd ../../



# ---------------------------------------------------------------------
# Test 09
# ---------------------------------------------------------------------
# Reparo luego de borrar el directorio de ejecutables.
# ---------------------------------------------------------------------

# 1) Ambiente nuevo.
tests/crear_ambiente.sh
cd tests/ambiente_de_testing

# 2) Instalo con un camino feliz. Tiro el stdout porque no me interesa
./instalador.sh  < ../instalador/instalacion_por_defecto.txt > /dev/null

# 3) Borro el directorio de ejecutables
rm -R ejecutables

# 4) Reparo
./instalador.sh -r > /dev/null

# 5) Valido que se existan los scripts
error=0
for script in {inicializacion.sh,proceso.sh,start.sh,stop.sh}; do
    if [ ! -f "ejecutables/$script" ]; then
        1>&2 printTestError "Test 09: fallido"
        error=1
    fi
done
if [ $error -eq 0 ]; then
    printTestOk "Test 09: exitoso."
fi

# 6) Vuelvo al directorio original
cd ../../



# ---------------------------------------------------------------------
# Test 10
# ---------------------------------------------------------------------
# Reparo luego de borrar un archivo maestro.
# ---------------------------------------------------------------------

# 1) Ambiente nuevo.
tests/crear_ambiente.sh
cd tests/ambiente_de_testing

# 2) Instalo con un camino feliz. Tiro el stdout porque no me interesa
./instalador.sh  < ../instalador/instalacion_por_defecto.txt > /dev/null

# 3) Borro un archivo maestro
rm  maestros/Operadores.txt

# 4) Reparo
./instalador.sh -r > /dev/null

# 5) Valido que se exista el archivo
if [ -f maestros/Operadores.txt ]; then
    printTestOk "Test 10: exitoso."
else
    1>&2 printTestError "Test 10: fallido"
fi

# 6) Vuelvo al directorio original
cd ../../



# ---------------------------------------------------------------------
# Test 11
# ---------------------------------------------------------------------
# Reparo luego de borrar todo.
# ---------------------------------------------------------------------

# 1) Ambiente nuevo.
tests/crear_ambiente.sh
cd tests/ambiente_de_testing

# 2) Instalo con un camino feliz. Tiro el stdout porque no me interesa
./instalador.sh  < ../instalador/instalacion_por_defecto.txt > /dev/null

# 3) Borro un archivo maestro
rm -r {aceptados,ejecutables,maestros,novedades,procesados,rechazados,salidas}

# 4) Reparo
./instalador.sh -r > /dev/null

# 5) Valido que se existan los directorios
error=0
for dir in {aceptados,ejecutables,maestros,novedades,procesados,rechazados,salidas}; do
    if [ ! -d "$dir" ]; then
        1>&2 printTestError "Test 11, validacion 1: fallido"
        error=1
    fi
done
if [ $error -eq 0 ]; then
    printTestOk "Test 11, validacion 1: exitoso."
fi

# 6) Valido que se existan los scripts
error=0
for script in {inicializacion.sh,proceso.sh,start.sh,stop.sh}; do
    if [ ! -f "ejecutables/$script" ]; then
        1>&2 printTestError "Test 11, validacion 2: fallido"
        error=1
    fi
done
if [ $error -eq 0 ]; then
    printTestOk "Test 11, validacion 2: exitoso."
fi

# 7) Valido que se existan los archivos maestros
error=0
for maestro in {Operadores.txt,Sucursales.txt}; do
    if [ ! -f "maestros/$maestro" ]; then
        1>&2 printTestError "Test 11, validacion 3: fallido"
        error=1
    fi
done
if [ $error -eq 0 ]; then
    printTestOk "Test 11, validacion 3: exitoso."
fi

# 8) Vuelvo al directorio original
cd ../../



# ---------------------------------------------------------------------
# Test 12
# ---------------------------------------------------------------------
# Instalo dos veces
# ---------------------------------------------------------------------

# 1) Ambiente nuevo.
tests/crear_ambiente.sh
cd tests/ambiente_de_testing

# 2) Instalo dos veces. Tiro el stdout porque no me interesa
./instalador.sh < ../instalador/instalacion_por_defecto.txt > /dev/null
./instalador.sh > /dev/null

# 3) Valido el mensaje
validacion=$(grep -c '.*Ejecutar ./instalador.sh -r para reparar la instalación si es necesario*' conf/log/instalacion.log)
if [ $validacion -eq 1 ]; then
    printTestOk "Test 12: exitosa."
else
    1>&2 printTestError "Test 12: fallida"
fi

# 4) Vuelvo al directorio original
cd ../../



# ---------------------------------------------------------------------
# Test 13
# ---------------------------------------------------------------------
# Instalo pero confirmando la segunda vez.
# ---------------------------------------------------------------------

# 1) Ambiente nuevo.
tests/crear_ambiente.sh
cd tests/ambiente_de_testing

# 2) Instalo confirmando la segunda vez.
./instalador.sh < ../instalador/instalacion_confirmando_la_segunda_vez.txt > /dev/null

# 3) Valido que se existan los directorios.
error=0
for dir in {aceptados,procesados,dir_scripts,dir_maestros,dir_novedades,dir_rechazados,dir_salida}; do
    if [ ! -d "$dir" ]; then
        1>&2 printTestError "Test 13: fallido"
        error=1
    fi
done
if [ $error -eq 0 ]; then
    printTestOk "Test 13: exitoso."
fi

# 4) Vuelvo al directorio original
cd ../../
