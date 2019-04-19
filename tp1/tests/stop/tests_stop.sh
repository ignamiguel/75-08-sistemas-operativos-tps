#!/bin/bash

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
if [ $? -eq 0 ]; then
    echo "Test 01 de stop OK."
else
    1>&2 echo "Falló el test 01 de stop."
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
if [ $? -eq 1 ]; then
    echo "Test 02 de stop OK."
else
    1>&2 echo "Falló el test 02 de stop."
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
if [ $? -eq 1 ]; then
    echo "Test 03 de stop OK."
else
    1>&2 echo "Falló el test 03 de stop."
fi

# 5) Vuelvo al directorio original
cd ../../
