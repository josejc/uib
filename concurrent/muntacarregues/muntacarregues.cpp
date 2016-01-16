/*******************
 *** Compilacio: g++ muntacarregues.cpp -o muntacarregues -lpthread 
 *******************/

#include <ctype.h>
#include <iostream.h>
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#ifndef WIN32
	#include <unistd.h>
#endif


const unsigned int Capacitat = 4;
const unsigned int dimPetit  = 1;
const unsigned int dimGran   = 2;

typedef enum {
	planta_muntatge,
	planta_magatzem,
	pujant,
	baixant
} t_estat;

struct {
	int nombrePetits, nombreGrans;
	t_estat estat;
	pthread_mutex_t mutex;
	pthread_cond_t entrada_vehicle, 
				   sortida_vehicle,
				   muntacarregues_abaix,
				   muntacarregues_adalt;
	bool acabar;
} regio_critica;

void * vehiclePetit(void * i)
{
	unsigned int codi = (int)i;
	
	// construir vehicle petit

	cout << "Creat vehicle petit " << codi << endl;
	
	// Accedir a la regio critica	
	pthread_mutex_lock(&(regio_critica.mutex));

	if (regio_critica.acabar) {
		cout << "Vehicle petit " << codi << " mor." << endl;
		pthread_mutex_unlock(&(regio_critica.mutex));
		pthread_exit(NULL);
	}
		
	// Intentar entrar al muntacarregues. Si es possible fer-ho
	while ((regio_critica.estat != planta_muntatge) ||
		   (Capacitat - (regio_critica.nombrePetits * dimPetit +
		                 regio_critica.nombreGrans * dimGran) < dimPetit)) {
	   cout << "Vehicle petit " << codi << " no hi cap. Espera" << endl;
	   
	   pthread_cond_wait(&(regio_critica.muntacarregues_abaix),
	   					 &(regio_critica.mutex));
						 
	   // assegurar-se que es pot continuar
	   if (regio_critica.acabar) {
			cout << "Vehile petit " << codi << " mor." << endl;
			pthread_mutex_unlock(&(regio_critica.mutex));
			pthread_exit(NULL);
		}
	   
	   cout << "Vehicle petit " << codi << " no hi cabia.";
	   cout << " Ho torna a provar" << endl;
	}
	
	// Ja es pot entrar
	
	cout << "Vehicle petit " << codi << " entra"<< endl;
	
	regio_critica.nombrePetits++;
	pthread_cond_signal(&(regio_critica.entrada_vehicle));
	
	// Sortir de la regio critica
	//pthread_mutex_unlock(&(regio_critica.mutex));
	
	cout << "Vehicle petit " << codi << " espera a pujar"<< endl;
	
	// Esperar que el muntacarregues vagi adalt
	pthread_cond_wait(&(regio_critica.muntacarregues_adalt),
					  &(regio_critica.mutex));
					  
	// assegurar-se que es pot continuar
	if (regio_critica.acabar) {
		cout << "Vehile petit " << codi << " mor." << endl;
		pthread_mutex_unlock(&(regio_critica.mutex));
		pthread_exit(NULL);
	}
	   
	// Accedir a la regio critica
	//pthread_mutex_lock(&(regio_critica.mutex));
	
	cout << "Vehicle petit " << codi << " surt"<< endl;
	
	// Sortir
	regio_critica.nombrePetits--;
	pthread_cond_signal(&(regio_critica.sortida_vehicle));
	
	// Sortir de la regio critica
	pthread_mutex_unlock(&(regio_critica.mutex));

	// aparcar vehicle petit
	
	cout << "Vehicle petit " << codi << " aparca"<< endl;
	
	return NULL;
}


void * vehicleGran(void * i)
{
	unsigned int codi = (int)i;
	
	// construir vehicle gran

	cout << "Creat vehicle gran " << codi << endl;
	
	// Accedir a la regio critica	
	pthread_mutex_lock(&(regio_critica.mutex));
    
	if (regio_critica.acabar) {
		cout << "Vehicle gran " << codi << " mor." << endl;
		pthread_mutex_unlock(&(regio_critica.mutex));
		pthread_exit(NULL);
	}

	// Intentar entrar al muntacarregues. Si es possible fer-ho
	while ((regio_critica.estat != planta_muntatge) ||
		   (Capacitat - (regio_critica.nombrePetits * dimPetit +
		                 regio_critica.nombreGrans * dimGran) < dimGran)) {
						 
	   cout << "Vehicle gran " << codi << " no hi cap. Espera" << endl;
	   pthread_cond_wait(&(regio_critica.muntacarregues_abaix),
	   					 &(regio_critica.mutex));
						 
	   // assegurar-se que es pot continuar
	   if (regio_critica.acabar) {
			cout << "Vehile gran " << codi << " mor." << endl;
			pthread_mutex_unlock(&(regio_critica.mutex));
			pthread_exit(NULL);
		}
	   
	   cout << "Vehicle gran " << codi << " no hi cabia.";
	   cout << " Ho torna a provar" << endl;
	}
	   
	// Ja es pot entrar
	
	cout << "Vehicle gran " << codi << " entra"<< endl;
	
	regio_critica.nombreGrans++;
	pthread_cond_signal(&(regio_critica.entrada_vehicle));
	
	// Sortir de la regio critica
	//pthread_mutex_unlock(&(regio_critica.mutex));
	
	cout << "Vehicle gran " << codi << " espera a pujar"<< endl;
	
	// Esperar que el muntacarregues vagi adalt
	pthread_cond_wait(&(regio_critica.muntacarregues_adalt),
					  &(regio_critica.mutex));

    // assegurar-se que es pot continuar
	if (regio_critica.acabar) {
		cout << "Vehile gran " << codi << "mor." << endl;
		pthread_mutex_unlock(&(regio_critica.mutex));
		pthread_exit(NULL);
	}
	   
	// Accedir a la regio critica
	//pthread_mutex_lock(&(regio_critica.mutex));
	
	cout << "Vehicle gran " << codi << " surt"<< endl;
	
	// Sortir
	regio_critica.nombreGrans--;
	pthread_cond_signal(&(regio_critica.sortida_vehicle));
	
	// Sortir de la regio critica
	pthread_mutex_unlock(&(regio_critica.mutex));

	// aparcar vehicle gran
	
	cout << "Vehicle gran " << codi << " aparca"<< endl;

	return NULL;
}


void * muntacarregues(void *)
{
	// temps que tardam en pujar o baixar.
#ifndef WIN32
	const unsigned long segons = 6;
#else
	const unsigned long milisegons = 6000;
#endif

	while (true) {
	
		// Accedir a la regio critica	
		pthread_mutex_lock(&(regio_critica.mutex));
		
		
		if (regio_critica.acabar) {
		    cout << "Muntacarregues mor." << endl;
			pthread_mutex_unlock(&(regio_critica.mutex));
			pthread_exit(NULL);
		}
		
		// Esperar a que estigui ple
		while (Capacitat > (regio_critica.nombrePetits * dimPetit +
		                	 regio_critica.nombreGrans * dimGran)) {
			pthread_cond_wait(&(regio_critica.entrada_vehicle), 
						      &(regio_critica.mutex));
			// assegurar-se que es pot continuar
	   		if (regio_critica.acabar) {
			   cout << "Munta carregues mor." << endl;
			   pthread_mutex_unlock(&(regio_critica.mutex));
			   pthread_exit(NULL);
			}
        }
             
		// Tancar portes i partir
		regio_critica.estat = pujant;

	    cout << "Muntacarregues puja"<< endl;

		// Sortir de la regio critica
		pthread_mutex_unlock(&(regio_critica.mutex));

		// durant una estoneta puja.
#ifndef WIN32
		sleep(segons);
#else
		_sleep(milisegons);
#endif

		// indicar que ha arribat adalt
		pthread_mutex_lock(&(regio_critica.mutex));

		
		if (regio_critica.acabar) {
		    cout << "Muntacarregues mor." << endl;
			pthread_mutex_unlock(&(regio_critica.mutex));
			pthread_exit(NULL);
		}
		
	    cout << "Muntacarregues arriba al magatzem"<< endl;

		regio_critica.estat = planta_magatzem;
		pthread_cond_broadcast(&(regio_critica.muntacarregues_adalt));
			
		cout << "Obrir portes i esperar a buidar" << endl;
		// Esperar que es buidi
		
		while ((regio_critica.nombrePetits != 0) &&
		       (regio_critica.nombreGrans != 0)) {
			 pthread_cond_wait(&(regio_critica.sortida_vehicle), 
							   &(regio_critica.mutex));
			 // assegurar-se que es pot continuar
	   		 if (regio_critica.acabar) {
				 cout << "Muntacarregues mor." << endl;
				 pthread_mutex_unlock(&(regio_critica.mutex));
				 pthread_exit(NULL);
			 }
	    }

		// ja esta buit, tancar portes i baixar
		
		regio_critica.estat = baixant;
		pthread_mutex_unlock(&(regio_critica.mutex));

		cout << "Muntacarregues baixa"<< endl;

		// durant una estoneta baixa.
#ifndef WIN32
		sleep(segons);
#else
		_sleep(milisegons);
#endif
		
		// indicar que ha arribat abaix
		pthread_mutex_lock(&(regio_critica.mutex));

		
		if (regio_critica.acabar) {
		    cout << "Muntacarregues mor." << endl;
			pthread_mutex_unlock(&(regio_critica.mutex));
			pthread_exit(NULL);
		}
		
	    cout << "Muntacarregues arriba a la planta de muntatge"<< endl;

		regio_critica.estat = planta_muntatge;
		pthread_cond_broadcast(&(regio_critica.muntacarregues_abaix));
		
		cout << "Portes obertes, poden entrar vehicles" << endl;
			
		pthread_mutex_unlock(&(regio_critica.mutex));
		
	}
	
	return NULL;
}




void main(int, char **)
{
	int compteGran = 0, comptePetit = 0;
	char opcio;
	
    regio_critica.nombrePetits = regio_critica.nombreGrans = 0;
	regio_critica.estat = planta_muntatge;
	pthread_mutex_init(&(regio_critica.mutex),NULL);
	pthread_cond_init(&(regio_critica.entrada_vehicle),NULL);
	pthread_cond_init(&(regio_critica.sortida_vehicle),NULL);
	pthread_cond_init(&(regio_critica.muntacarregues_abaix),NULL);
	pthread_cond_init(&(regio_critica.muntacarregues_adalt),NULL);
	regio_critica.acabar = false;
	
	pthread_t munta, *vehicle;
	
	pthread_create(&munta, NULL, muntacarregues, NULL);
	
	bool continuar = true;
	
	do {
		cout << " Opcions\n =======\n\n";
		cout << " P.- Crear vehicle petit\n";
		cout << " G.- Crear vehicle gran\n";
		cout << " S.- Acabar.\n\n";
		cout << " ==> ";
		cin >> opcio;
		
		switch (tolower(opcio)) {
			case 'p': vehicle = new pthread_t;
					  if (pthread_create(vehicle,NULL,
							vehiclePetit,(void*)(++comptePetit)) != 0)
						perror("Error creant vehicle petit");
					  break;
			case 'g': vehicle = new pthread_t;
					  if (pthread_create(vehicle,NULL,
							vehicleGran,(void*)(++compteGran)) != 0)
						perror("Error creant vehicle gran");
					  break;
			case 's': continuar = false;
					  break;
		}
				
	} while (continuar);
	
	cout << "Acabant" << endl;
	
	pthread_mutex_lock(&(regio_critica.mutex));
	regio_critica.acabar = true;
	
	// alliberar tothom que pugui estar bloquejat
	// cada procés bloquejat és responsable de comprovar el
	// valor de sortir immediatament després de sortir
	// d'un wait.
	pthread_cond_broadcast(&(regio_critica.entrada_vehicle));
	pthread_cond_broadcast(&(regio_critica.sortida_vehicle));
	pthread_cond_broadcast(&(regio_critica.muntacarregues_abaix));
	pthread_cond_broadcast(&(regio_critica.muntacarregues_adalt));
	
	pthread_mutex_unlock(&(regio_critica.mutex));

    // esperar que acabi el muntacarregues
	pthread_join(munta, NULL);
	
	pthread_mutex_destroy(&(regio_critica.mutex));
	pthread_cond_destroy(&(regio_critica.entrada_vehicle));
	pthread_cond_destroy(&(regio_critica.sortida_vehicle));
	pthread_cond_destroy(&(regio_critica.muntacarregues_abaix));
	pthread_cond_destroy(&(regio_critica.muntacarregues_adalt));
	
	
	cout << "Tots els processos han acabat. Adeu." << endl;
	
}
