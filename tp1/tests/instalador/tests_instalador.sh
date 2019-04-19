#!/bin/bash

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
./instalador.sh < ../inicializador/instalacion_feliz.txt > /dev/null

# 3) Valido la salida
if [ $? -eq 0 ]; then
    echo "Test 01 del inicializador OK."
else
    1>&2 echo "Falló el test 01 del inicializador."
fi
