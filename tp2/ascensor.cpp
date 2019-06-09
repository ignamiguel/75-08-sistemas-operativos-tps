#include  "lib/sv_sem.h"
#include  "lib/sv_shm.h"
#include  "Area.h"
#include  "portada.h"
#include <time.h>
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
		cout<<"Esperando pasajero."<<endl;
	    cout<<" "<<endl;

	    pasajero.wait();
	    time_t my_time = time(NULL);
	    cout<<ctime(&my_time)<<a->getPasajero()<<", Pasajero Subiendo "<<endl;

	    printEstado(a->getPisoSubida(), a->getPisoBajada());
	    
		cout<<a->getPasajero()<<", Pasajero Bajando"<<endl;
	    cout<<" "<<endl;

	    cout<<"Ascensor vacio"<<endl;
		cout<<"Buscar proximo pasajero? Presione enter para continuar.."<<endl;
	    cin.ignore();

	    printf("Pasajeros transportados: %i\n", total_pasajeros);
	    total_pasajeros = total_pasajeros + 1;


    }
    
    cout<<"Ultimo pasajero atendido"<<endl;
    cout<<"Ascensor apagado"<<endl;
}

