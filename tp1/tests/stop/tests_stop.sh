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
# tests_stop.sh
# ---------------------------------------------------------------------
# Ejecuta los tests de stop.
# Ejecutar como tests/stop/tests_stop.sh.
# ---------------------------------------------------------------------

echo "---------------------------------------------------------------------"
echo "Comienzan los tests de stop"
echo "---------------------------------------------------------------------"

# ---------------------------------------------------------------------
# Test 01
# ---------------------------------------------------------------------
# Se termina el proceso después de ser iniciado
# ---------------------------------------------------------------------

# 1) Ambiente nuevo.
tests/crear_ambiente.sh
cd tests/ambiente_de_testing

# 2) Instalo con un camino feliz. Tiro el stdout porque no me interesa
./instalador.sh < ../inicializador/instalacion_feliz.txt > /dev/null

# 3) Inicializo y termino el proceso
(
    . dir_scripts/inicializacion.sh 
    ./dir_scripts/stop.sh
) > /dev/null

# 4) Valido la salida
TEST_NAME="Test 01: stop con éxito"
if [ $? -eq 0 ]; then
    printTestOk "$TEST_NAME"
else
    1>&2 printTestError "$TEST_NAME"
fi

# 5) Vuelvo al directorio original
cd ../../


# ---------------------------------------------------------------------
# Test 02
# ---------------------------------------------------------------------
# Se termina el proceso dos veces
# ---------------------------------------------------------------------

# 1) Ambiente nuevo.
tests/crear_ambiente.sh
cd tests/ambiente_de_testing

# 2) Instalo con un camino feliz. Tiro el stdout porque no me interesa
./instalador.sh < ../inicializador/instalacion_feliz.txt > /dev/null

# 3) Inicializo y termino el proceso
(
    . dir_scripts/inicializacion.sh 
    ./dir_scripts/stop.sh
    ./dir_scripts/stop.sh
) > /dev/null 2> /dev/null

# 4) Valido la salida
TEST_NAME="Test 02: stop"
if [ $? -eq 1 ]; then
    printTestOk "$TEST_NAME"
else
    1>&2 printTestError "$TEST_NAME"
fi

# 5) Vuelvo al directorio original
cd ../../


# ---------------------------------------------------------------------
# Test 03
# ---------------------------------------------------------------------
# Se termina el proceso sin haberlo iniciado
# ---------------------------------------------------------------------

# 1) Ambiente nuevo.
tests/crear_ambiente.sh
cd tests/ambiente_de_testing

# 2) Instalo con un camino feliz. Tiro el stdout porque no me interesa
./instalador.sh < ../inicializador/instalacion_feliz.txt > /dev/null

# 3) Termino el proceso
(
    ./dir_scripts/stop.sh
) > /dev/null 2> /dev/null

# 4) Valido la salida
TEST_NAME="Test 03: stop"
if [ $? -eq 1 ]; then
    printTestOk "$TEST_NAME"
else
    1>&2 printTestError "$TEST_NAME"
fi

# 5) Vuelvo al directorio original
cd ../../
