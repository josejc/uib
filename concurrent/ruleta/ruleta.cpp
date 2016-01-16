#include <ctype.h>
#include <iostream.h>
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>


const unsigned int NUM_RULETA = 38;
const unsigned int FITXAS_JUG = 50;
const unsigned int MAX_JUGADORS = 10;
const unsigned int GANES_JUGAR = 4;
const unsigned int MIRAR_BOLLA = 3;
const unsigned int T_ACEPTACIO = 7;
const unsigned int ESPAI_TEMP = 5;
const unsigned int CANVIS_SEG[] = {8, 3};

// continuar: indica si la ruleta(gestio) ha d'acabar o no...
// la faig publica perq si la banca salta pot
// aturar la ruleta i acabar el joc... ;)
bool continuar = true;

typedef struct apo {
	int jugador, nFichas, numero;
} APOSTA;

struct {
	pthread_mutex_t mutex;
	pthread_cond_t avisBanca, bollaMov, iniTemps; 
	pthread_cond_t avisJugador[MAX_JUGADORS];
	
	bool acabar, jugadaMarxa;
        int bolla, nFitxasBanca;
        // i per emmagatzemar les apostes tant aceptades com pendents...
        APOSTA *aceptades[MAX_JUGADORS];
	APOSTA *pendents[MAX_JUGADORS];
	// i el seus indexes
	int iAcep, iPend;
	// i per indicar tambe els jugadors q han mort,
	// ells mateixos en completar una jugada se suicidaran :P
	int morts[MAX_JUGADORS];
	int iMorts;
} regio_critica;

void * jugador(void * j)
{
	unsigned int codi = (int)j;
	APOSTA *nova;
	int i;
	
	// construir jugador...
	cout << "Creat jugador " << codi << endl;
	
	while (true) {
		// Accedir a la regio critica	
		pthread_mutex_lock(&(regio_critica.mutex));
		// Una posible manera d finalitzar del jugador...
		if (regio_critica.acabar) {
			cout << "Jugador " << codi << " mor." << endl;
			pthread_mutex_unlock(&(regio_critica.mutex));
			pthread_exit(NULL);
		}
		// O si han mort el jugador :(
		// i es comprova en el arrai de jugadors morts...
		for (i=0; i<regio_critica.iMorts; i++) {
			if (regio_critica.morts[i] == codi) {
				regio_critica.iMorts--;
				regio_critica.morts[i] = -1;
				cout << "Jugador " << codi << " mor." << endl;
				pthread_mutex_unlock(&(regio_critica.mutex));
				pthread_exit(NULL);		
			}
		}
		// Sortir de la regio critica
		pthread_mutex_unlock(&(regio_critica.mutex));

		// Tindra ganes de jugar var. aleat. unif.. entre 0 i GANES_JUGAR...
		sleep(rand() % GANES_JUGAR);	

		// Accedir a la regio critica
		pthread_mutex_lock(&(regio_critica.mutex));
		// Ara el jugador creara una nova aposta ;)
		nova = (APOSTA *)malloc(sizeof(APOSTA));
		nova->jugador = codi;
		nova->nFichas = 1 + rand() % FITXAS_JUG;	// Como minimo 1 ficha.. ;)
		nova->numero = rand() % (1+NUM_RULETA);
		// Afegim la aposta a les apostas pendents de tractament
		regio_critica.pendents[regio_critica.iPend++] = nova;
		// Avisam a la banca de la aposta
		pthread_cond_signal(&(regio_critica.avisBanca));
		// Esperam la seva resposta
		pthread_cond_wait(&(regio_critica.avisJugador[codi]), &(regio_critica.mutex));	
		// Hem de comprovar si la aposta ha estat aceptada
		i=0;
		while ((i<regio_critica.iAcep) && (i!=-1)) {
			if (regio_critica.aceptades[i] == nova) {
				i = -1;
				cout << "La aposta del jugador " << codi << " ha estat aceptada." << endl;
				// Hem d esperar a q la jugada comenci
				pthread_cond_wait(&(regio_critica.avisJugador[codi]), &(regio_critica.mutex));
				while (regio_critica.jugadaMarxa) {
					// Sortim de la regio critica...
					pthread_mutex_unlock(&(regio_critica.mutex));		
					sleep(rand() % MIRAR_BOLLA);
					// Accedim a la regio critica...
					pthread_mutex_lock(&(regio_critica.mutex));		
					cout << "Jugador " << codi << " mira la bolla i veu el " << regio_critica.bolla << endl;
				}
				// La jugada ha finalitzat i podem veure el nombre q ha sortit...
				if (regio_critica.bolla == nova->numero) {
					cout << "Jugador " << codi << " ha guanyat, esta content :)" << endl;
				} else {
					cout << "Jugador " << codi << " ha perdut, esta trist :(" << endl;
				}
			}
			if (i!=-1) {
				i++;
			}
		}
		// El jugador desfa la aposta...
		free(nova);
		if (i == regio_critica.iAcep) {
			cout << "La aposta del jugador " << codi << " ha estat rebutjada." << endl;
		}
		// Sortir de la regio critica
		pthread_mutex_unlock(&(regio_critica.mutex));
	
	}
	// Jugador surt del joc, s'acabat :(
	cout << "Jugador " << codi << " mort"<< endl;

	return NULL;
}

void * banca(void *) {
	int i;
	
	// construir banca...
	cout << "Creat banca" << endl;
	
	while (true) {
		// Accedir a la regio critica	
		pthread_mutex_lock(&(regio_critica.mutex));
		// Comprovacio si el joc ha finalitzat...
		if (regio_critica.acabar) {
			cout << "Banca mor." << endl;
			pthread_mutex_unlock(&(regio_critica.mutex));
			pthread_exit(NULL);
		}
		// La banca inicialitza el proces q controla l'espai temporal d'aceptacio d'apostas...
		pthread_cond_signal(&(regio_critica.iniTemps));
		// Esperam apostas q seran aceptades... fins q comenci la jugada		
		while (!regio_critica.jugadaMarxa) {
			pthread_cond_wait(&(regio_critica.avisBanca), &(regio_critica.mutex));
			if (regio_critica.iPend == 0) {
				// No tenim apostas pendents... ens ha donat 'avis el temps
				// ha finalitzat l'espai temporal i començarem la jugada
				regio_critica.jugadaMarxa = true;
			} else {				
				// Aceptam la aposta
				regio_critica.iPend--;		
				i = (regio_critica.pendents[regio_critica.iPend])->jugador;	// id. jugador q fa aposta
				regio_critica.aceptades[regio_critica.iAcep++] = regio_critica.pendents[regio_critica.iPend];
				// Eliminam la aposta del arrai d'apostes pendents...
				regio_critica.pendents[regio_critica.iPend] = NULL;
				// Avisam al jugador d q la aposta ha estat aceptada
				pthread_cond_signal(&(regio_critica.avisJugador[i]));
			}
		}		
		// Ara començarem la jugada, posrem la bolla en marxa, i avisam als
		// jugador q tenen alguna aposta aceptada...
		for (i=0; i<regio_critica.iAcep; i++) {
			pthread_cond_signal(&(regio_critica.avisJugador[regio_critica.aceptades[i]->jugador]));
		}
		// Ara posam la bolla en moviment
		pthread_cond_signal(&(regio_critica.bollaMov));
		while (regio_critica.jugadaMarxa) {
			// Esperam apostes q seran rebutjades mentre hi ha una jugada en marxa...
			// o q la bolla s'aturi ;)
			pthread_cond_wait(&(regio_critica.avisBanca), &(regio_critica.mutex));			
			if (regio_critica.iPend == 0) {
				// La bolla s'aturat i la jugada ha finalitzat
				regio_critica.jugadaMarxa = false;
			} else {
				// Les apostes no son aceptades... avisam al jugador
				regio_critica.iPend--;
				i = (regio_critica.pendents[regio_critica.iPend])->jugador;     // id. jugador q fa aposta
				pthread_cond_signal(&(regio_critica.avisJugador[i]));
				// i s'eliminen d pendents...
				regio_critica.pendents[regio_critica.iPend] = NULL;
			}
		}
		// Ara ja podem mirar el nombre guanyador i els jugadors agraciats ;)
		cout << "EL NOMBRE GUANYADOR: " << regio_critica.bolla << endl;
		for (i=0; i<regio_critica.iAcep; i++) {
			if (regio_critica.aceptades[i]->numero == regio_critica.bolla) {
				cout << "El jugador " << regio_critica.aceptades[i]->jugador << " ha guanyat..." << endl;
				cout << "... la seva aposta era de " << regio_critica.aceptades[i]->nFichas << endl;
				// Si el jugador encerta, guanya el doble de la seva aposta
				regio_critica.nFitxasBanca -= 2*regio_critica.aceptades[i]->nFichas;	
			} else {
				// sino la banca se queda les fitxas d l'aposta
				regio_critica.nFitxasBanca += regio_critica.aceptades[i]->nFichas;
			}
		}
		// Hem de comprovar si la banca ha "salta"...
		if (regio_critica.nFitxasBanca <= 0) {
			cout << "La banca ha saltat..." << endl;
			continuar = false;
		} else {
			// Eliminam totes les apostes per començar la proxima jugada
			for (i=0; i<regio_critica.iAcep; i++) {
				regio_critica.aceptades[i] = NULL;
			}
			regio_critica.iAcep = 0;
		}
		// Sortir de la regio critica
		pthread_mutex_unlock(&(regio_critica.mutex));
	
	}
	// Banca surt del joc, s'acabat :(
	cout << "Banca mor"<< endl;

	return NULL;
}

void * temps(void *) {

	cout << "Inici d'execucio del temps (control espai temporal)." << endl;
	
	while (true) {
	
		// Accedir a la regio critica	
		pthread_mutex_lock(&(regio_critica.mutex));
		if (regio_critica.acabar) {
			cout << "Temps mor." << endl;
			pthread_mutex_unlock(&(regio_critica.mutex));
			pthread_exit(NULL);
		}
		// Esperam a que la Banca posi en marxa el temps... :)
		pthread_cond_wait(&(regio_critica.iniTemps), &(regio_critica.mutex));
		// Sortim d la regio critica
		pthread_mutex_unlock(&(regio_critica.mutex));

		cout << "El temps esta en marxa." << endl;
		// Esperam un espai temporal predeterminat
		sleep(ESPAI_TEMP);
		cout << "El temps ha finalitzat." << endl;
		
	    	// Avisam a la banca q el temps a finalitzat
		pthread_mutex_lock(&(regio_critica.mutex));
		pthread_cond_signal(&(regio_critica.avisBanca));
		pthread_mutex_unlock(&(regio_critica.mutex));
	}

	return NULL;
}

void * bolla(void *)
{
	int i,j;		// Variables auxiliars per fer bucles ;

	while (true) {
	
		// Accedir a la regio critica	
		pthread_mutex_lock(&(regio_critica.mutex));
		if (regio_critica.acabar) {
			cout << "Bolla mor." << endl;
			pthread_mutex_unlock(&(regio_critica.mutex));
			pthread_exit(NULL);
		}
		// Esperam a que la Banca posi la bolla en marxa :)
		pthread_cond_wait(&(regio_critica.bollaMov), &(regio_critica.mutex));
		// Sortim d la regio critica
		pthread_mutex_unlock(&(regio_critica.mutex));

		cout << "La bolla esta en moviment." << endl;
	    	for(i=1; i<=2; i++){
	       		for(j=1; j<=CANVIS_SEG[i-1]; j++){
		  		// Esperam un cert temps a q la bolla canvi d nombre
		     		sleep(i);
		    		// Seccio d'entrada a la regio critica
				pthread_mutex_lock(&(regio_critica.mutex));
                  		// Canvi de nombre d la bolla
				regio_critica.bolla = rand() % (1+NUM_RULETA);
				cout << "Bola Nº: " << regio_critica.bolla << endl;
		  		// Seccio sortida de la regio critica
		  		pthread_mutex_unlock(&(regio_critica.mutex));
               		}
            	}
	    
	    	// Avisam a la banca q la bolla esta aturada
		pthread_mutex_lock(&(regio_critica.mutex));
		pthread_cond_signal(&(regio_critica.avisBanca));
		pthread_mutex_unlock(&(regio_critica.mutex));

	}

	return NULL;
}




int main(int, char **)
{
	char opcio;
	int i;
	
	pthread_mutex_init(&(regio_critica.mutex),NULL);
	pthread_cond_init(&(regio_critica.avisBanca),NULL);
	pthread_cond_init(&(regio_critica.bollaMov),NULL);
	pthread_cond_init(&(regio_critica.iniTemps),NULL);
	for (i=0; i<MAX_JUGADORS; i++) {
		pthread_cond_init(&(regio_critica.avisJugador[i]), NULL);
	}

	regio_critica.acabar = false;
	regio_critica.bolla = 0;
	regio_critica.jugadaMarxa = false;
	regio_critica.nFitxasBanca = 2*FITXAS_JUG;
	
	// Arrai a on tindrem els jugadors...
	pthread_t JUG[MAX_JUGADORS];
	int iJUG = 0;
	int darrerMort = -1;

	// Creació de la bolla, banca, temps i 1 jugador...
	pthread_t bola, t, banc;
	
	pthread_create(&bola, NULL, bolla, NULL);
	pthread_create(&t, NULL, temps, NULL);
	pthread_create(&banc, NULL, banca, NULL);
	if (pthread_create(&(JUG[iJUG]), NULL, jugador, (void*)(iJUG)) == 0) {		
		iJUG++;
	} else {
		continuar = false;
		perror("Error creant al jugador...");
	}	
	
	while (continuar) {
		cout << " Opcions\n =======\n\n";
		cout << " +.- Afegeix un jugador a la ruleta.\n";
		cout << " -.- Lleva el darrer jugador a la ruleta.\n";
		cout << " E.- Estat ruleta (taula i sistema).\n";
		cout << " S.- Acabar.\n\n";
		cout << " ==> ";
		cin >> opcio;
		
		switch (tolower(opcio)) {
			case 'e':
				cout << "Nombre de jugadors: " << iJUG << endl;
				pthread_mutex_lock(&(regio_critica.mutex));
				cout << "Jugada en Marxa: " << regio_critica.jugadaMarxa << endl;
				cout << "Nº Bolla: " << regio_critica.bolla << endl;
				cout << "Nombre apostes aceptades: " << regio_critica.iAcep << endl;
				cout << "Nombre apostes pendents: " << regio_critica.iPend << endl;
				pthread_mutex_unlock(&(regio_critica.mutex));
				break;
			case '+': 
				pthread_mutex_lock(&(regio_critica.mutex));
				if (regio_critica.iMorts == 0) {
					// Cream al jugador
					if (pthread_create(&(JUG[iJUG]), NULL, jugador, (void*)(iJUG)) == 0){
						iJUG++;
					} else {
						perror("Error creant al jugador...");
					}
				} else {
					cout << "No podem crear, fins q no hi hagi jugadors q s'han d suicidar :(" << endl;
				}
				pthread_mutex_unlock(&(regio_critica.mutex));
				break;
			case '-':
				pthread_mutex_lock(&(regio_critica.mutex));
				if (regio_critica.iMorts == 0) {
					darrerMort = iJUG;
				}
				if (darrerMort > 1) {
					darrerMort--;
					regio_critica.morts[regio_critica.iMorts++] = darrerMort;
				} else {
					cout << "Com a minim hem de tenir 1 jugador jugant :P" << endl;
				}
				pthread_mutex_unlock(&(regio_critica.mutex));
				break;
			case 's': 
				// Miram si hi ha jugadors q s'han d suicidar
				pthread_mutex_lock(&(regio_critica.mutex));
				cout << "Tenim " << regio_critica.iMorts << " jugadors pendent de suicidi." << endl;
				if (regio_critica.iMorts == 0) {
					continuar = false;
				} else {
					cout << "No podem acabar, fins q no hi hagi jugadors q s'han  suicidar :(" << endl;
				}
				pthread_mutex_unlock(&(regio_critica.mutex));
				break;
		}
				
	} 
	
	cout << "Acabant" << endl;
	
	pthread_mutex_lock(&(regio_critica.mutex));
	regio_critica.acabar = true;
	pthread_mutex_unlock(&(regio_critica.mutex));

    	// esperar que acabi la bolla
	pthread_join(bola, NULL);
	pthread_cond_signal(&(regio_critica.iniTemps));
	for (i=0; i<iJUG; i++) {
		pthread_join(JUG[i], NULL);
	}
	pthread_join(t, NULL);
	pthread_join(banc, NULL);

	cout << "Nombre de fitxas q t la banca: " << regio_critica.nFitxasBanca << endl;
	
	pthread_mutex_destroy(&(regio_critica.mutex));
	pthread_cond_destroy(&(regio_critica.avisBanca));
	pthread_cond_destroy(&(regio_critica.bollaMov));
	pthread_cond_destroy(&(regio_critica.iniTemps));
	for (i=0; i<MAX_JUGADORS; i++) {
		pthread_cond_destroy(&(regio_critica.avisJugador[i]));
	}
	
	cout << "Tots els processos han acabat. Adeu." << endl;
	
}
