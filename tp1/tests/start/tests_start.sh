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
# tests_start.sh
# ---------------------------------------------------------------------
# Ejecuta los tests de start.
# Ejecutar como tests/start/tests_start.sh.
# ---------------------------------------------------------------------

echo "---------------------------------------------------------------------"
echo "Comienzan los tests de start"
echo "---------------------------------------------------------------------"

# ---------------------------------------------------------------------
# Test 01
# ---------------------------------------------------------------------
# Ejecutar start después de stop
# ---------------------------------------------------------------------

# 1) Ambiente nuevo.
tests/crear_ambiente.sh
cd tests/ambiente_de_testing

# 2) Instalo con un camino feliz. Tiro el stdout porque no me interesa
./instalador.sh < ../inicializador/instalacion_feliz.txt > /dev/null

# 3) Inicializo, stop y start
(
    . dir_scripts/inicializacion.sh
    ./dir_scripts/stop.sh
    ./dir_scripts/start.sh
) > /dev/null

# 4) Valido la salida
if [ $? -eq 0 ]; then
    printTestOk "Test 01: start básico con éxito"
else
    1>&2 printTestError "Test 01: start básico con éxito"
fi

validacion=$(grep -c '.*Se inició el proceso con el pid .*' conf/log/start.log)
if [ $validacion -eq 2 ]; then
    printTestOk "Test 01"
else
    1>&2 printTestError "Test 01"
fi

# 5) Finalizo el proceso
(
    . dir_scripts/inicializacion.sh
    ./dir_scripts/stop.sh
) > /dev/null 2> /dev/null

# 6) Vuelvo al directorio original
cd ../../


# ---------------------------------------------------------------------
# Test 02
# ---------------------------------------------------------------------
# Start se ejecuta después del inicializador
# ---------------------------------------------------------------------

# 1) Ambiente nuevo.
tests/crear_ambiente.sh
cd tests/ambiente_de_testing

# 2) Instalo con un camino feliz. Tiro el stdout porque no me interesa
./instalador.sh < ../inicializador/instalacion_feliz.txt > /dev/null

# 3) Inicializo
salida=$(. dir_scripts/inicializacion.sh | grep -m 1 'Inicia el comando start.sh')

# 4) Valido la salida
if [ ! -z "$salida" ]; then
    printTestOk "Test 02: start"
else
    1>&2 printTestError "Test 02: start"
fi

# 5) Vuelvo al directorio original
cd ../../
