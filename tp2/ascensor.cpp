const int Npisos = 10;
cond_t Petpisos[Npisos], aviso;
int NpetPiso[Npisos];
mutex_t ctrlme;
int piso_actual=1, piso_nuevo=-1, peticiones=0;

void PulsarBoton(int piso) {
	lock(ctrlme);
	signalc(aviso);
	peticiones = peticiones+1;
	NpetPiso[piso]++;
	waitc(Petpisos[piso],ctrlme);
	NpetPiso[piso]--;
	unlock(ctrlme);
};

void EsperarPeticiones() {
	lock(ctrlme);
	if (peticiones == 0) {
		waitc(aviso,ctrlme);
	}
	unlock(ctrlme);
};

void ElegirMasCercano(int& dist) {
	int i;
	boolean sigue;

	lock(ctrlme);
	i= 0; sigue = TRUE;
	while ((i <= Npisos) && sigue) {
		if ((piso_actual+i <= Npisos) && (NpetPiso[piso_actual+i]>0)) {
			piso_nuevo = piso_actual+i;
			dist = i; sigue = FALSE;
	 	} else if ((piso_actual-i > 0) && (NpetPiso[piso_actual+i]>0)) {
	 		piso_nuevo = piso_actual -i;
	 		dist = -i; sigue = FALSE;
	 	};
	 		i = i + 1;
	 	};

		unlock(ctrlme);
};

void SubirBajar() {
	lock(ctrlme);
	while ((NpetPiso[piso_nuevo])>0) {
		signal(Petpisos[piso_nuevo]);
		peticiones = peticiones-1;
	}; 

	piso_actual = piso_nuevo
	unlock(ctrlme);
}; 