#ifndef Area_h
#define Area_h
class Area{
	bool ultimo;
	char dato [40];
	char pasajero[10];
	//char pisoActual;

	public:
		Area() {
			strcpy (dato,"");
			ultimo=false;
			}
		std::string getDato(){return dato;};
		void setDato(std::string d){
		  strcpy (dato,d.c_str());
		  ultimo=false;
		}
		
		void setUltimo(){ultimo=true;};
		bool esUltimo(){return ultimo;};

		/*char[10] getPasajero(){
			return pasajero;
		}

		void setPasajero(std::string d){
		  strcpy (pasajero,d.c_str());
		}*/

		//char getPisoActual(){return pisoActual;};
		//void setPisoActual(std::char piso){pisoActual=piso}
};
#endif