#!/bin/bash

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
    echo "Test 01 de start OK."
else
    1>&2 echo "Falló el test 01 de start."
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
    echo "Test 02 de start OK."
else
    1>&2 echo "Falló el test 02 de start."
fi

# 5) Vuelvo al directorio original
cd ../../