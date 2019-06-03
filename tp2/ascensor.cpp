#include  "lib/sv_sem.h"
#include  "lib/sv_shm.h"
#include  "Area.h"
#include  "portada.h"
using namespace std;

int main(){

	//int pisoActual = 0;
    portada();
    
    sv_sem pasajero ("pasajero",0);
    sv_sem ascensor ("ascensor",0);

 
    Area * a;
    sv_shm area("area");
    a=reinterpret_cast<Area *> (area.map(BUFSIZ));

    int total_pasajeros = 1;

	cout<<"Ascensor listo"<<endl;
    while (true){

		ascensor.post();
		cout<<"Esperando pasajero. Presione enter para continuar.."<<endl;
		//cin.ignore();
	    cout<<" "<<endl;


	    pasajero.wait();
	    cout<<"Pasajero Subiendo "<<endl;
	    //cout<<getPasajero()<<endl;
		cout<<"Pasajero Bajando. Presione enter para continuar.."<<endl;
	    cout<<" "<<endl;
	    //cin.ignore();

		//printEstado(getOrigen(), getDestino());

	    cout<<"Ascensor vacio"<<endl;
		cout<<"Buscar proximo pasajero? Presione enter para continuar.."<<endl;
	    cout<<" "<<endl;
	    //cin.ignore();

	    printf("Pasajeros transportados: %i\n", total_pasajeros);
	    total_pasajeros = total_pasajeros + 1;


    }
    
    cout<<"Ultimo pasajero atendido"<<endl;
    cout<<"Ascensor apagado"<<endl;
}

/*void printEstado(int subida, int bajada){
	if (subida < bajada) {
		for (int i = subida; i <= bajada; i = i + 1) {
			printf("PISO: %i\n", i);
		}
		return;
	}

	for (int i = subida; i >= bajada; i = i - 1) {
			printf("PISO: %i\n", i);
	}

}*/