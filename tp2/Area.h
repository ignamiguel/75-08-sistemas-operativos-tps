#ifndef Area_h
#define Area_h
class Area{
	char nombre [40];
	int subida;
	int bajada;

	public:
		Area() {
			strcpy (nombre,"");
			subida=0;
			bajada=0;
			}

		void setPasajero(std::string d){
		  strcpy (nombre,d.c_str());
		}
		
		std::string getPasajero(){return nombre;};

		void setPisoSubida(std::string  pisoSubida){
			subida = std::atoi (pisoSubida.c_str());
		};
		int getPisoSubida(){return subida;};

		void setPisoBajada(std::string pisoBajada){
			bajada = std::atoi (pisoBajada.c_str());
		};
		int getPisoBajada(){return bajada;};
};
#endif