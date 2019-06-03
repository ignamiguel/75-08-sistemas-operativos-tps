#include "lib/sv_sem.h"
#include "lib/sv_shm.h"
#include <iostream>
#include  "portada.h"
using namespace std;

int main(){

    portada();
    
	sv_sem ascensor ("ascensor",0);
	cout<<"Semaforo ascensor inicializado"<<endl;
	sv_sem pasajero ("pasajero",0);
	cout<<"Semaforo pasajero inicializado"<<endl;
    sv_shm area("area");
	cout<<"Area compartida inicializada"<<endl;
}