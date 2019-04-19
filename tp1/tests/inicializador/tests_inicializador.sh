# ---------------------------------------------------------------------
# tests_inicializador.sh
# ---------------------------------------------------------------------
# Ejecuta los tests del inicializador.
# Ejecutar como tests/inicializador/tests_inicializador.sh.
# ---------------------------------------------------------------------

echo "---------------------------------------------------------------------"
echo "Comienzan los tests del inicializador"
echo "---------------------------------------------------------------------"

# ---------------------------------------------------------------------
# Test 01
# ---------------------------------------------------------------------
# Inicializo con el sistema no inicializado
# ---------------------------------------------------------------------

# 1) Ambiente nuevo.
tests/crear_ambiente.sh
cd tests/ambiente_de_testing

# 2) Instalo con un camino feliz. Tiro el stdout porque no me interesa
./instalador.sh < ../inicializador/instalacion_feliz.txt > /dev/null

# 3) Inicializo
(. dir_scripts/inicializacion.sh ) > /dev/null

# 4) Valido la salida
if [ $? -eq 0 ]; then
    echo "Test 01 del inicializador OK."
else
    1>&2 echo "Falló el test 01 del inicializador."
fi

# 5) Vuelvo al directorio original
cd ../../



# ---------------------------------------------------------------------
# Test 02
# ---------------------------------------------------------------------
# Inicializo con el sistema inicializado
# ---------------------------------------------------------------------

# 1) Ambiente nuevo.
tests/crear_ambiente.sh
cd tests/ambiente_de_testing

# 2) Instalo con un camino feliz. Tiro el stdout porque no me interesa
./instalador.sh < ../inicializador/instalacion_feliz.txt > /dev/null

# 3) Inicializo dos veces.
(
        . dir_scripts/inicializacion.sh;
        . dir_scripts/inicializacion.sh;
) > /dev/null

# 4) Valido la salida
if [ $? -eq 1 ]; then
    echo "Test 02 del inicializador OK."
else
    1>&2 echo "Falló el test 02 del inicializador."
fi

# 5) Vuelvo al directorio original
cd ../../



# ---------------------------------------------------------------------
# Test 03
# ---------------------------------------------------------------------
# Inicializo sin el directorio de salida
# ---------------------------------------------------------------------

# 1) Ambiente nuevo.
tests/crear_ambiente.sh
cd tests/ambiente_de_testing

# 2) Instalo con un camino feliz. Tiro el stdout porque no me interesa
./instalador.sh < ../inicializador/instalacion_feliz.txt > /dev/null

# 3) Borro el directorio de ejecutables
rm -R dir_salida

# 4) Inicializo
(. dir_scripts/inicializacion.sh) > /dev/null 2> /dev/null

# 5) Valido la salida
if [ $? -eq 2 ]; then
    echo "Test 03 del inicializador OK."
else
    1>&2 echo "Falló el test 03 del inicializador."
fi

# 6) Vuelvo al directorio original
cd ../../



# ---------------------------------------------------------------------
# Test 04
# ---------------------------------------------------------------------
# Inicializo sin el script stop.sh
# ---------------------------------------------------------------------

# 1) Ambiente nuevo.
tests/crear_ambiente.sh
cd tests/ambiente_de_testing

# 2) Instalo con un camino feliz. Tiro el stdout porque no me interesa
./instalador.sh < ../inicializador/instalacion_feliz.txt > /dev/null

# 3) Borro el script stop.sh
rm dir_scripts/stop.sh

# 4) Inicializo
(. dir_scripts/inicializacion.sh) > /dev/null 2> /dev/null

# 5) Valido la salida
if [ $? -eq 3 ]; then
    echo "Test 04 del inicializador OK."
else
    1>&2 echo "Falló el test 04 del inicializador."
fi

# 6) Vuelvo al directorio original
cd ../../



# ---------------------------------------------------------------------
# Test 05
# ---------------------------------------------------------------------
# Inicializo sin permisos de ejecución para proceso.sh
# ---------------------------------------------------------------------

# 1) Ambiente nuevo.
tests/crear_ambiente.sh
cd tests/ambiente_de_testing

# 2) Instalo con un camino feliz. Tiro el stdout porque no me interesa
./instalador.sh < ../inicializador/instalacion_feliz.txt > /dev/null

# 3) Quito el permiso de ejecución para el proceso
chmod 600 dir_scripts/proceso.sh

# 4) Inicializo
salida=$(. dir_scripts/inicializacion.sh | grep 'Se corrigen los permisos sobre el script .*proceso.sh para poder leerlo y ejecutarlo')

# 5) Valido la salida
if [ ! -z "$salida" ] && [ $? -eq 0 ]; then
    echo "Test 05 del inicializador OK."
else
    1>&2 echo "Falló el test 05 del inicializador."
fi

# 6) Vuelvo al directorio original
cd ../../



# ---------------------------------------------------------------------
# Test 06
# ---------------------------------------------------------------------
# Inicializo sin el archivo maestro Operadores.txt
# ---------------------------------------------------------------------

# 1) Ambiente nuevo.
tests/crear_ambiente.sh
cd tests/ambiente_de_testing

# 2) Instalo con un camino feliz. Tiro el stdout porque no me interesa
./instalador.sh < ../inicializador/instalacion_feliz.txt > /dev/null

# 3) Borro el script stop.sh
rm dir_maestros/Operadores.txt

# 4) Inicializo
(. dir_scripts/inicializacion.sh) 2> /dev/null > /dev/null

# 5) Valido la salida
if [ $? -eq 4 ]; then
    echo "Test 06 del inicializador OK."
else
    1>&2 echo "Falló el test 06 del inicializador."
fi

# 6) Vuelvo al directorio original
cd ../../



# ---------------------------------------------------------------------
# Test 07
# ---------------------------------------------------------------------
# Inicializo sin permisos de lectura para Sucursales.txt
# ---------------------------------------------------------------------

# 1) Ambiente nuevo.
tests/crear_ambiente.sh
cd tests/ambiente_de_testing

# 2) Instalo con un camino feliz. Tiro el stdout porque no me interesa
./instalador.sh < ../inicializador/instalacion_feliz.txt > /dev/null

# 3) Quito el permiso de lectura para Sucursales.txt
chmod 000 dir_maestros/Sucursales.txt

# 4) Inicializo
salida=$(. dir_scripts/inicializacion.sh | grep 'Se corrigen los permisos sobre el archivo maestro .*Sucursales\.txt para poder leerlo')

# 5) Valido la salida
if [ ! -z "$salida" ] && [ $? -eq 0 ]; then
    echo "Test 07 del inicializador OK."
else
    1>&2 echo "Falló el test 07 del inicializador."
fi

# 6) Vuelvo al directorio original
cd ../../