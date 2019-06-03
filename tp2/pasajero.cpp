#include  "lib/sv_sem.h"
#include  "lib/sv_shm.h"
#include  "Area.h"
#include  "portada.h"
using namespace std;

int main(int argc, char * argv[]){

    portada();
    
    if (argc<4){
        cerr<<"Faltan argumentos, se debe ejecutar ./pasajero NOMBRE PISO_SUBIDA PISO_BAJADA."<<endl;
        exit(1);
    }

    sv_sem pasajero ("pasajero",0);
    sv_sem ascensor ("ascensor",0);
  
	Area * a;
	sv_shm area("area");
	a=reinterpret_cast<Area *> (area.map(BUFSIZ));
    
	cout<<argv[1]<<" esta esperando el ascensor, presione enter para continuar.."<<endl;
    //cin.ignore();
    pasajero.post();
    
    cout<<argv[1]<<" esperando el ascensor"<<endl;
    ascensor.wait();
    cout<<"Ascensor listo, ingresa "<<argv[1]<<endl;

    if (argc>=4){
		a->setUltimo();
    }
}
