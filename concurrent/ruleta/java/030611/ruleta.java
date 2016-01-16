import java.lang.*;
import java.util.*;
import java.io.*;

/**
 * Classe principal.
 * 
 * Representa la ruleta del joc i la seva Gestio...
 */
class ruleta{

	public static void  main (String [] args) {

		// Vector a on tindrem els jugadors...
		Vector JUG = new Vector();
		jugador removeJug;	// Jugador a eliminar
		
		/**
		 * continuar indica si s'ha d'acabar o no.
		 */
		boolean continuar = true;
		
		/**
		 * Creació dels objecte bolla, banca, temps i 1 jugador amb el seu semafor associat
		 */
		bolla bola = new bolla();
		banca banc = new banca();
		temps t = new temps();
		JUG.add(new jugador(JUG.size()));
		def.avisJugador.add(new semafor(0));
		
		/**
		 * variables per llegir del teclat.
		 */
		int opc_i;
		char opc;
		
		/**
		 * inici del funcionament de la bolla, banca, temps i 1 jugador
		 */
		t.start();
		bola.start();
		banc.start();
		((jugador)JUG.firstElement()).start();
		
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
			 */
			System.out.println(" Opcions\n =======\n");
			System.out.println(" +.- Afegeix un jugador a la ruleta.");
			System.out.println(" -.- Lleva el darrer jugador a la ruleta.");
			System.out.println(" E.- Estat ruleta (taula i sistema).");
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
				case 'e':
				   System.out.println("Nombre jugadors: "+JUG.size());
				   regioCritica.seccEnt();
				     System.out.println("Nombre Fitxas que te la banca: " + regioCritica.nFitxasBanca);
				     System.out.println("Jugada en Marxa: " + regioCritica.jugadaMarxa);
				     System.out.println("Nº Bolla: " + regioCritica.bolla);
				     System.out.println("Lista apostes aceptades..."+regioCritica.aceptades.size());
				     for (Enumeration e = regioCritica.aceptades.elements(); e.hasMoreElements(); ){
				       ((aposta)e.nextElement()).escriure();
				     }
				     System.out.println("Lista apostes pendents..."+regioCritica.pendents.size());
                                     for (Enumeration e = regioCritica.pendents.elements(); e.hasMoreElements(); ){
					((aposta)e.nextElement()).escriure();
				     }
				   regioCritica.seccSal();
				   break;
				case '+':
				   // Cream el jugador i el seu semafor
                                   JUG.add(new jugador(JUG.size()));
                                   def.avisJugador.add(new semafor(0));
				   // Posam en marxa el jugador 
				   ((jugador)JUG.lastElement()).start();
				   break;
				case '-':
				   // Hem d'esborrar el jugador del vector de jugadors i el seu semafor
				   // per q no hagi problemes feim sempre el darrer jugador...
				   removeJug = (jugador)JUG.lastElement();
				   JUG.remove(removeJug);
				   def.avisJugador.removeElementAt(JUG.size());

//				   removeJug.finalitzar();
//				   removeJug.join();
				   System.out.println("XXXXXXXXXXXXXXXXXXXXXX");
				   break;
				case 's': 
				   continuar = false;
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
		 */
		regioCritica.finalitzar();
		
		/**
		 * Esperar per poder acabar.
		 */
		try {
			bola.join();
			def.iniTemps.s();	// Per si el proces temps se queda a la espera...
			for (Enumeration e = JUG.elements(); e.hasMoreElements(); ){
			   ((jugador)e.nextElement()).join();
			}
			t.join();
			banc.join();
		}
		catch (InterruptedException e) {}
		
		/**
		 * Missatge d'acomiadament.
		 */
		System.out.println( "Tots els processos han acabat. Adeu.");
	}
}
