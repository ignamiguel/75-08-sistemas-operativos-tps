void portada(){
    cout<<"75.08 Sistemas Operativos"<<endl;
    cout<<"Trabajo Practico N°2"<<endl;
    cout<<"Tema 3 - Ascensor"<<endl;
    cout<<endl;
    cout<<"93965 Mauro Di Pietro"<<endl;
    cout<<"95605 Agustín Zuretti"<<endl;
    cout<<"95050 Ignacio Iglesias"<<endl;
    cout<<endl;
}

void printEstado(int subida, int bajada){
	if (subida < bajada) {
		cout<<"Ascensor Subiendo"<<endl;

		for (int i = subida; i <= bajada; i = i + 1) {
			printf("PISO: %i\n", i);
		}
		return;
	}

	cout<<"Ascensor Bajando"<<endl;
	for (int i = subida; i >= bajada; i = i - 1) {
		printf("PISO: %i\n", i);
	}

}