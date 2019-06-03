#include  "lib/sv_sem.h"
#include  "lib/sv_shm.h"
#include  "portada.h"
using namespace std;

int main(){

    portada();

    sv_sem ascensor ("ascensor",0);
    sv_sem pasajero ("pasajero",0);
    sv_shm area("area");
    ascensor.del();
	cout<<"Semaforo ascensor borrado"<<endl;
    pasajero.del();
	cout<<"Semaforo pasajero borrado"<<endl;
    area.del();
	cout<<"Area compartida borrada"<<endl;
}
