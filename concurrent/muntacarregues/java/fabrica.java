import java.lang.*;
import java.io.*;

/**
 * Classe principal.
 * 
 * Representa la fabrica on es fabriquen els vehicles.
 */
class fabrica {

	public static void  main (String [] args) {
		/**
		 * continuar indica si s'ha d'acabar o no.
		 */
		boolean continuar = true;
		/**
		 * comptador del nombre de vehicles grans i petits produïts.
		 */
		int comptePetit = 0;
		int compteGran = 0;
		
		/**
		 * Creació de l'objecte muntacarregues
		 */
		muntacarregues munta = new  muntacarregues();
		
		/**
		 * Creació del grup de threads vehicles.
		 */
		ThreadGroup totsElsVehicles = new ThreadGroup("Vehicles");
		
		/**
		 * 'Objecte' per anar creant vehicles
		 */
		vehicle nou;
		
		/**
		 * variables per llegir del teclat.
		 */
		int opc_i;
		char opc;
		
		/**
		 * inici del funcionament del muntacarregues
		 */
		munta.start();
		
		/**
		 * Bucle principal. Es repeteix fins que l'usuari decideix acabar.
		 */
		do {
		
			/**
			 * Missatges amb les opcions disponibles.
			 *
			 * Evidentment la gestió de l'entrada i sortida és incorrecta.
			 * Per fer-ho ben fet s'hauria de gestionar de manera que no hi
			 * hagués dos processos escrivint al mateix temps.
			 *
			 * Les opcions possibles són 
			 *          .- crear un vehicle gran
			 *			.- crear un vehicle petit
			 *          .- acabar
			 */
			System.out.println(" Opcions\n =======\n");
			System.out.println(" P.- Crear vehicle petit");
			System.out.println(" G.- Crear vehicle gran");
			System.out.println(" S.- Acabar.\n");
			System.out.print  (" ==> ");
			
			/**
			 * Llegir del teclat
			 */
			try {
				opc_i = System.in.read();
				System.in.skip(System.in.available());
			} catch (IOException e) {opc_i = 32;}
			
			opc = (char)(opc_i);
			
			/**
			 * Determinar quina ha estat l'opció desitjada
			 */
			switch (Character.toLowerCase(opc) ) {
				/**
				 * opció crear un vehicle petit. S'ha d'incrementar el
				 * comptador de vehicles petits.
				 * També s'ha d'activar el vehicle.
				 */
				case 'p': System.out.println("Creant vehicle petit");
						  nou = new vehicle(constants.tipusPetit,
											++comptePetit,
											totsElsVehicles);
						  nou.start();
						  break;
				
				/**
				 * opció crear un vehicle gran. S'ha d'incrementar el
				 * comptador de vehicles grans. 
				 */
				case 'g': System.out.println("Creant vehicle gran");
						  nou = new vehicle(constants.tipusGran,
											++compteGran,
											totsElsVehicles);
						  nou.start(); /** activar el vehicle **/
						  break;
						  
				/**
				 * Si l'opció es acabar. Aleshores continuar = false.
				 */
				case 's': continuar = false;
						  break;
			}
		} while (continuar);
		
		/**
		 * Si s'ha d'acabar es mostrarà un missatge
		 */
		System.out.println("Acabant");
		
		/**
		 * Acabar tots els processos.
		 *
		 * Per fer-ho s'han d'alliberar tots els processos bloquejats.
		 */
		regio_critica.finalitzar();
		
		regio_critica.entrada_regio_critica();
		
		regio_critica.allibera_entrada_vehicle();
		regio_critica.allibera_sortida_vehicle();
		regio_critica.allibera_muntacarregues_abaix();
		regio_critica.allibera_muntacarregues_adalt();
		
		regio_critica.sortida_regio_critica();
		
		/**
		 * S'acaba l'execució del muntacarregues
		 */		
		munta.interrupt();
		
		/**
		 * Esperar per poder acabar.
		 */
		try {
			munta.join();
		}
		catch (InterruptedException e) {}
		
		/**
		 * Missatge d'acomiadament.
		 */
		System.out.println( "Tots els processos han acabat. Adeu.");
	}
}
