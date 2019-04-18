compressed_file = grupo03

all: mktmp copy_scripts copy_data copy_docs create_conf_folder copy_readme copy_installer compress clean_tmp

mktmp:
# Crea el directorio donde se van a colocar los archivos a comprimir
	$(MAKE) clean_tmp
	mkdir $(compressed_file)
	mkdir $(compressed_file)/originales
	mkdir $(compressed_file)/originales/scripts
	mkdir $(compressed_file)/originales/documentacion
	mkdir $(compressed_file)/originales/datos

copy_scripts:
# Copia los scripts a la carpeta donde se va a comprimir
	cp -r scripts/* $(compressed_file)/originales/scripts

copy_data:
# Copia los datos a la carpeta donde se va a comprimir
	cp -r datos/* $(compressed_file)/originales/datos

copy_docs:
# Copia la documentacion a la carpeta donde se va a comprimir
	cp -r documentacion/* $(compressed_file)/originales/documentacion

create_conf_folder:
# Crea la carpeta /conf y /conf/log
	mkdir $(compressed_file)/conf
	mkdir $(compressed_file)/conf/log

copy_readme:
# Copia el readme a la raiz para que el usuario la pueda ver facilmente
	cp documentacion/Readme.md $(compressed_file)/Readme.md

copy_installer:
# Copia el instalador a la raiz para que el usuario lo encuentre facilmente
	cp scripts/instalador.sh $(compressed_file)/instalador.sh

compress:
# Comprime los archivos
	if [ -f $(compressed_file).tgz ]; then 	\
		rm $(compressed_file).tgz;				\
	fi
	tar -C $(compressed_file)/ -czf $(compressed_file).tgz .

clean_tmp:
# Borra los archivos temporales
	if [ -d $(compressed_file) ]; then 	\
		rm -R $(compressed_file);		\
	fi
