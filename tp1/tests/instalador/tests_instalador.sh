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

# 4) Vuelvo al directorio original
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

# 4) Vuelvo al directorio original
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

# 5) Vuelvo al directorio original
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

# 5) Vuelvo al directorio original
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

# 5) Vuelvo al directorio original
cd ../../
