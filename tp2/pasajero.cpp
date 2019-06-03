void pasajero() {
	int origen, destino;
	origen = random(Npisos)+1;

	while (TRUE) {
		PulsarBoton(origen);
		do {
			destino = random(Npisos)+1
			} while (destino == origen);
		
		PulsarBoton(destino);
		origen = destino;
		sleep(random(10));

	}
}

void servidor() {
	integer dist,
	while (TRUE) {
		EsperarPeticiones;
		ElegirMasCercano(dist);
		sleep(ABS(dist));
		SubirBajar;
	}
}

main() {
	cobegin {
		servidor;
		pasajero();
		pasajero();
		pasajero(); 
		...;
	}
} 