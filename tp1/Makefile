compressed_file = grupo03

all: mktmp copy_scripts copy_data copy_docs compress clean_tmp

mktmp:
# Crea el directorio donde se van a colocar los archivos a comprimir
	$(MAKE) clean_tmp
	mkdir $(compressed_file)

copy_scripts:
# Copia los scripts a la carpeta donde se va a comprimir
	cp -r scripts/* $(compressed_file)

copy_data:
# Copia los datos a la carpeta donde se va a comprimir
	cp -r datos/* $(compressed_file)

copy_docs:
# Copia la documentacion a la carpeta donde se va a comprimir
	cp -r documentacion/* $(compressed_file)

compress:
# Comprime los archivos
	if [ -f $(compressed_file).tgz ]; then 	\
		rm $(compressed_file).tgz;				\
	fi
	tar -C $(compressed_file)/ -cvzf $(compressed_file).tgz .

clean_tmp:
# Borra los archivos temporales
	if [ -d $(compressed_file) ]; then 	\
		rm -R $(compressed_file);		\
	fi
