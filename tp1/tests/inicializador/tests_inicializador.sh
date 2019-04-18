# ---------------------------------------------------------------------
# tests_inicializador.sh
# ---------------------------------------------------------------------
# Ejecuta los tests del inicializador.
# Ejecutar como tests/inicializador/tests_inicializador.sh.
# ---------------------------------------------------------------------


# ---------------------------------------------------------------------
# Test 01
# ---------------------------------------------------------------------
# Inicializo con el sistema no inicializado
# ---------------------------------------------------------------------

# Preparo el ambiente:
# 1) Ambiente nuevo.
. tests/crear_ambiente.sh
# 2) Instalo con un camino feliz. Tiro el stdout porque no me interesa
cat ../inicializador/instalacion_feliz.txt | ./instalador.sh > /dev/null
# 3) Inicializo
dir_scripts/inicializacion.sh