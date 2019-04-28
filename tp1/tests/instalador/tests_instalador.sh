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
# Instaldo desde cero
# ---------------------------------------------------------------------

# 1) Ambiente nuevo.
tests/crear_ambiente.sh
cd tests/ambiente_de_testing

# 2) Instalo con un camino feliz. Tiro el stdout porque no me interesa
./instalador.sh < ../instalador/instalacion_feliz.txt > /dev/null

# 3) Valido la salida
TEST_NAME="Test 01: instalación básica con éxito"
if [ $? -eq 0 ]; then
    printTestOk "$TEST_NAME"
else
    1>&2 printTestError "$TEST_NAME"
fi
