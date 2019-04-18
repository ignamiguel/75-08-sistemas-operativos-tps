# ---------------------------------------------------------------------
# crear_ambiente.sh
# ---------------------------------------------------------------------
# Este script crea una carpeta (tests/ambiente_de_testing) con los 
# mismos archivos que resultarian de descomprimir el programa.
# Sirve para realizar las prubas de integración.
# 
# Nota: Luego de su ejecución es recomendable ejecutar 
# "cd tests/ambiente_de_testing" para correr los tests.
# ---------------------------------------------------------------------


# Borro el ambiente anterior si existe
if [ -d tests/ambiente_de_testing ]; then
    rm -R tests/ambiente_de_testing
fi

# Creo el nuevo ambiente
mkdir tests/ambiente_de_testing
make -s
tar -xzf grupo03.tgz -C tests/ambiente_de_testing