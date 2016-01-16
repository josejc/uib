import java.lang.*;
import java.util.*;

/**
 * Classe que simula el comportament del jugador.
 */
public final class jugador extends Thread {

   private final int idJugador;
   private Integer mortJug;
   
   /**
   * Que es 1 segon en milisegons.
   */
   private final int segon = 1000;
	
   // Per generar nombres aleatoris
   public final Random rand = new Random();
   
   /**
   * Mètode per acabar. Cap altre procés l'invocarà.
   */
   public void finalitzar() throws acabamentException {
      System.out.println("\t\tJugador "+idJugador+" ha d'acabar.");
      throw new acabamentException();
   }
	
   /**
   * Constructor. No hi ha cap relació guardià-depenent.
   */
   public jugador(int id) {
      System.out.println("\t\tJugador "+id+" creat.");
      idJugador=id;
      setDaemon(true);
   }

   public aposta creaAposta() {
      // Una aposta esta formada per
      //   - El jugador q la fa
      //   - Un v.a. entre 1 i el maxim d fitxas q pot apostar en 1 jugada 1 jugador
      //   - El nombre al q se fa la aposta
      //
      // Se suposa q si un jugador acaba les fitxes s'en va a cercar mes i no pasa pena

      aposta apos = new aposta(idJugador, rand.nextInt(def.FITXAS_JUG)+1, rand.nextInt(def.NUM_RULETA));

      return(apos);
   }
	
   /**
   * Mètode d'execució
   */
   public void run () {
	    
      aposta ap;
      System.out.println("\t\tInici d'execucio del jugador "+idJugador+".");
	    	    
      try {
         while (true) {
            /**
	    * Aquest bucle es repeteix fins que s'acaba el programa....
	    */
	    if (regioCritica.acabar()) finalitzar();
	    
	    // O han mort el jugador :(
	    // aixo es comprova en el vector de jugadors morts
	    regioCritica.seccEnt();
	    for (Enumeration e = regioCritica.morts.elements(); e.hasMoreElements(); ){
	       mortJug = (Integer)e.nextElement();	    
	       if (mortJug.intValue() == idJugador) {
	          regioCritica.morts.remove(mortJug);
		  regioCritica.seccSal();
		  finalitzar();
	       }
            }
	    regioCritica.seccSal();
				
	    // Tindra ganes de jugar var. uniform. entre 0 i 4 segons
	    try {
	       sleep(segon*rand.nextInt(4));
	    } catch (InterruptedException e) {}
	    ap = creaAposta();		// El jugador fa la aposta
	    regioCritica.seccEnt();
	      regioCritica.pendents.add(ap);
	    regioCritica.seccSal();
	    def.avisBanca.s();				// Avisa a la banca d la seva aposta
	    ((semafor)def.avisJugador.get(idJugador)).w();	// Espera per sebre si ha estat aceptada
	    regioCritica.seccEnt();
	      if (regioCritica.aceptades.contains(ap)) {
		 System.out.println("La aposta del jugador "+idJugador+" ha estat aceptada.");
	         regioCritica.seccSal();
		 ((semafor)def.avisJugador.get(idJugador)).w();	// Espera a q la jugada comenci
		 regioCritica.seccEnt();
		   while (regioCritica.jugadaMarxa) {
		      regioCritica.seccSal();
		      try {
		         sleep(segon*rand.nextInt(3));	// Jugador mira la bolla v.a. 0..3
		      } catch (InterruptedException e) {}
		      regioCritica.seccEnt();
		      System.out.println("Jugador "+idJugador+" mira la bolla i veu el "+regioCritica.bolla+".");
	           }
		   // La jugada a finalitzat i podem veure el nombre q ha sortit
                   if (regioCritica.bolla == ap.num()) {
		      System.out.println("Jugador "+idJugador+" ha guanyat esta content :)");
		   } else {
                      System.out.println("Jugador "+idJugador+" ha perdut esta trist :(");
	           }
		 regioCritica.seccSal();
		 
		 regioCritica.seccEnt();
	      } else {
	         System.out.println("La aposta del jugador "+idJugador+" ha estat rebutjada.");
              }
	    regioCritica.seccSal();
         }
      } catch (acabamentException e) {}
   }
      
}
