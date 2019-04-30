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

delay_para_procesar=1 # en segundos

# ---------------------------------------------------------------------
# tests_demonio.sh
# ---------------------------------------------------------------------
# Ejecuta los tests del demonio.
# Ejecutar como tests/demonio/tests_demonio.sh.
# ---------------------------------------------------------------------

echo "---------------------------------------------------------------------"
echo "Comienzan los tests del demonio"
echo "---------------------------------------------------------------------"

# ---------------------------------------------------------------------
# Test 01
# ---------------------------------------------------------------------
# Procesar Entregas_07.txt
# ---------------------------------------------------------------------

# 1) Ambiente nuevo.
tests/crear_ambiente.sh
cd tests/ambiente_de_testing

# 2) Instalo con un camino feliz. Tiro el stdout porque no me interesa
./instalador.sh < ../demonio/instalacion_feliz.txt > /dev/null

# 4) Copio Entregas_07.txt para que ya esté una vez arranque el demonio
cp ../demonio/Entregas_07.txt novedades

# 3) Inicializo
(
    . scripts/inicializacion.sh
) > /dev/null

# 5) Como es asincrónico le doy un tiempo al demonio para que procese el archivo
sleep $delay_para_procesar

# 4) Valido la salida
validacion=$(grep -c '.*Entregas_07.txt ha sido movido a aceptados.*' conf/log/proceso.log)
if [ $validacion -eq 1 ]; then
    printTestOk "Test 01"
else
    1>&2 printTestError "Test 01"
fi

# FALTA VALIDAR EL RESULTADO DE LAS ENTREGAS, PERO HACERLO DESPUÉS DE CORREGIR EL FORMATO

# 5) Finalizo el proceso
(
    . scripts/inicializacion.sh
    scripts/stop.sh
) > /dev/null 2> /dev/null

# 6) Vuelvo al directorio original
cd ../../



# ---------------------------------------------------------------------
# Test 02
# ---------------------------------------------------------------------
# Procesar Entregas_08.txt
# ---------------------------------------------------------------------

# 1) Ambiente nuevo.
tests/crear_ambiente.sh
cd tests/ambiente_de_testing

# 2) Instalo con un camino feliz. Tiro el stdout porque no me interesa
./instalador.sh < ../demonio/instalacion_feliz.txt > /dev/null

# 4) Copio Entregas_08.txt para que ya esté una vez arranque el demonio
cp ../demonio/Entregas_08.txt novedades

# 3) Inicializo
(
    . scripts/inicializacion.sh
) > /dev/null

# 5) Como es asincrónico le doy un tiempo al demonio para que procese el archivo
sleep $delay_para_procesar

# 4) Valido la salida
validacion=$(grep -c '.*Entregas_08.txt ha sido movido a aceptados.*' conf/log/proceso.log)
if [ $validacion -eq 1 ]; then
    printTestOk "Test 02"
else
    1>&2 printTestError "Test 02"
fi

# FALTA VALIDAR EL RESULTADO DE LAS ENTREGAS, PERO HACERLO DESPUÉS DE CORREGIR EL FORMATO

# 5) Finalizo el proceso
(
    . scripts/inicializacion.sh
    scripts/stop.sh
) > /dev/null 2> /dev/null

# 6) Vuelvo al directorio original
cd ../../



# ---------------------------------------------------------------------
# Test 03
# ---------------------------------------------------------------------
# Procesar Entregas_09.txt
# ---------------------------------------------------------------------

# 1) Ambiente nuevo.
tests/crear_ambiente.sh
cd tests/ambiente_de_testing

# 2) Instalo con un camino feliz. Tiro el stdout porque no me interesa
./instalador.sh < ../demonio/instalacion_feliz.txt > /dev/null

# 4) Copio Entregas_09.txt para que ya esté una vez arranque el demonio
cp ../demonio/Entregas_09.txt novedades

# 3) Inicializo
(
    . scripts/inicializacion.sh
) > /dev/null

# 5) Como es asincrónico le doy un tiempo al demonio para que procese el archivo
sleep $delay_para_procesar

# 4) Valido la salida
validacion=$(grep -c '.*Entregas_09.txt ha sido movido a aceptados.*' conf/log/proceso.log)
if [ $validacion -eq 1 ]; then
    printTestOk "Test 03"
else
    1>&2 printTestError "Test 03"
fi

# FALTA VALIDAR EL RESULTADO DE LAS ENTREGAS, PERO HACERLO DESPUÉS DE CORREGIR EL FORMATO

# 5) Finalizo el proceso
(
    . scripts/inicializacion.sh
    scripts/stop.sh
) > /dev/null 2> /dev/null

# 6) Vuelvo al directorio original
cd ../../



# ---------------------------------------------------------------------
# Test 04
# ---------------------------------------------------------------------
# Procesar Entregas_10.txt
# ---------------------------------------------------------------------

# 1) Ambiente nuevo.
tests/crear_ambiente.sh
cd tests/ambiente_de_testing

# 2) Instalo con un camino feliz. Tiro el stdout porque no me interesa
./instalador.sh < ../demonio/instalacion_feliz.txt > /dev/null

# 4) Copio Entregas_10.txt para que ya esté una vez arranque el demonio
cp ../demonio/Entregas_10.txt novedades

# 3) Inicializo
(
    . scripts/inicializacion.sh
) > /dev/null

# 5) Como es asincrónico le doy un tiempo al demonio para que procese el archivo
sleep $delay_para_procesar

# 4) Valido la salida
validacion=$(grep -c '.*Entregas_10.txt ha sido movido a aceptados.*' conf/log/proceso.log)
if [ $validacion -eq 1 ]; then
    printTestOk "Test 04"
else
    1>&2 printTestError "Test 04"
fi

# FALTA VALIDAR EL RESULTADO DE LAS ENTREGAS, PERO HACERLO DESPUÉS DE CORREGIR EL FORMATO

# 5) Finalizo el proceso
(
    . scripts/inicializacion.sh
    scripts/stop.sh
) > /dev/null 2> /dev/null

# 6) Vuelvo al directorio original
cd ../../



# ---------------------------------------------------------------------
# Test 05
# ---------------------------------------------------------------------
# Procesar Entregas_11.txt
# ---------------------------------------------------------------------

# 1) Ambiente nuevo.
tests/crear_ambiente.sh
cd tests/ambiente_de_testing

# 2) Instalo con un camino feliz. Tiro el stdout porque no me interesa
./instalador.sh < ../demonio/instalacion_feliz.txt > /dev/null

# 4) Copio Entregas_11.txt para que ya esté una vez arranque el demonio
cp ../demonio/Entregas_11.txt novedades

# 3) Inicializo
(
    . scripts/inicializacion.sh
) > /dev/null

# 5) Como es asincrónico le doy un tiempo al demonio para que procese el archivo
sleep $delay_para_procesar

# 4) Valido la salida
validacion=$(grep -c '.*Entregas_11.txt ha sido movido a aceptados.*' conf/log/proceso.log)
if [ $validacion -eq 1 ]; then
    printTestOk "Test 05"
else
    1>&2 printTestError "Test 05"
fi

# FALTA VALIDAR EL RESULTADO DE LAS ENTREGAS, PERO HACERLO DESPUÉS DE CORREGIR EL FORMATO

# 5) Finalizo el proceso
(
    . scripts/inicializacion.sh
    scripts/stop.sh
) > /dev/null 2> /dev/null

# 6) Vuelvo al directorio original
cd ../../



# ---------------------------------------------------------------------
# Test 06
# ---------------------------------------------------------------------
# Procesar Entregas_nombre_incorrecto.txt
# ---------------------------------------------------------------------

# 1) Ambiente nuevo.
tests/crear_ambiente.sh
cd tests/ambiente_de_testing

# 2) Instalo con un camino feliz. Tiro el stdout porque no me interesa
./instalador.sh < ../demonio/instalacion_feliz.txt > /dev/null

# 4) Copio Entregas_nombre_incorrecto.txt para que ya esté una vez arranque el demonio
cp ../demonio/Entregas_nombre_incorrecto.txt novedades

# 3) Inicializo
(
    . scripts/inicializacion.sh
) > /dev/null

# 5) Como es asincrónico le doy un tiempo al demonio para que procese el archivo
sleep $delay_para_procesar

# 4) Valido la salida
validacion=$(grep -c '.*Entregas_nombre_incorrecto.txt es un nombre incorrecto\. ha sido movido a rechazados.*' conf/log/proceso.log)
if [ $validacion -eq 1 ]; then
    printTestOk "Test 06"
else
    1>&2 printTestError "Test 06"
fi

# 5) Finalizo el proceso
(
    . scripts/inicializacion.sh
    scripts/stop.sh
) > /dev/null 2> /dev/null

# 6) Vuelvo al directorio original
cd ../../