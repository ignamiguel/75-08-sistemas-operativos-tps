# ---------------------------------------------------------------------
# crear_ambiente.sh
# ---------------------------------------------------------------------
# Este script crea una carpeta (tests/ambiente_de_testing) con los 
# mismos archivos que resultarian de descomprimir el programa.
# Sirve para realizar las prubas de integración.
# 
# Nota: Debe llamarse como . tests/crear_ambiente.sh dado que su úlitma 
# acción es cambiar el directorio de trabajo al ambiente de testing y
# esto no es posible si está siendo ejecutado como un proceso hijo.
# ---------------------------------------------------------------------


# Borro el ambiente anterior si existe
if [ -d tests/ambiente_de_testing ]; then
    rm -R tests/ambiente_de_testing
fi

# Creo el nuevo ambiente
mkdir tests/ambiente_de_testing
make -s
tar -xzf grupo03.tgz -C tests/ambiente_de_testing

# Cambio el directorio al nuevo ambiente 
cd tests/ambiente_de_testing
