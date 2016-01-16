import java.lang.*;
import java.util.*;

/**
 * Classe que simula el comportament de la banca.
 */
public final class banca extends Thread {

   /**
   * Mètode per acabar. Cap altre procés l'invocarà.
   */
   public void finalitzar() throws acabamentException {
      System.out.println("\t\tBanca ha d'acabar.");
      throw new acabamentException();
   }
	
   /**
   * Constructor. No hi ha cap relació guardià-depenent.
   */
   public banca() {
      System.out.println("\t\tBanca creada.");
      setDaemon(true);
   }
	
   /**
   * Mètode d'execució
   */
   public void run () {
	    
      semafor avisJug;
      aposta apos;
	      
      System.out.println("\t\tInici d'execucio de la banca.");
	    	    
      try {
         while (true) {
            /**
	    * Aquest bucle es repeteix fins que s'acaba el programa.
	    */
	    if (regioCritica.acabar()) finalitzar();

	    // La banca inicialitza el proces q controla l'espai temporal d'aceptacio d'apostas
	    def.iniTemps.s();
	    regioCritica.seccEnt();
	    while (!regioCritica.jugadaMarxa) {
	       regioCritica.seccSal();
	       def.avisBanca.w();	// Esperam per una aposta o el temps
	       regioCritica.seccEnt();
	         if (regioCritica.pendents.isEmpty()) {
	            // No tenim apostas pendents... ens ha donat l'avis el temps
		    // ha finalitzat l'espai temporal i començarem la jugada
		    regioCritica.jugadaMarxa = true;
		    regioCritica.seccSal();
		 } else {
		    // Tenim apostas pendents l'avis pot esser d'un jugador ;)
	            regioCritica.aceptades.add(regioCritica.pendents.lastElement());
                    avisJug = (semafor)def.avisJugador.get( ((aposta)regioCritica.pendents.lastElement()).jug() );      
		    regioCritica.pendents.remove(regioCritica.pendents.lastElement());
	            regioCritica.seccSal();
	            avisJug.s();		// Avisam al jugador per q vegi q la aposta ha estat aceptada 
		}
		regioCritica.seccEnt();
	    }			
	    regioCritica.seccSal();
	    // Ara començarem la jugada, posarem la bolla en marxa, i avisam als
	    // jugadors q tenen alguna aposta aceptada...
	    regioCritica.seccEnt();
	      for (Enumeration e = regioCritica.aceptades.elements(); e.hasMoreElements(); ){
		 regioCritica.seccSal();
	         apos = (aposta)e.nextElement();
                 avisJug = (semafor)def.avisJugador.get(apos.jug());
		 avisJug.s();
		 regioCritica.seccEnt();
	      }
	    regioCritica.seccSal();
	    def.bollaMov.s();		// Bolla en moviment
	    regioCritica.seccEnt();
	    while (regioCritica.jugadaMarxa) {
	       regioCritica.seccSal();
	       // Esperam apostes q seran rebutjades mentre hi ha una jugada en marxa...
	       // o q la bolla s'aturi ;)
	       def.avisBanca.w();
	       regioCritica.seccEnt();
	       if (regioCritica.pendents.isEmpty()) {
	          // La bolla s'aturat i la jugada ha finalitzat
	          regioCritica.jugadaMarxa = false;
	          regioCritica.seccSal();
	       } else {
	          // Les apostes no son aceptades... s'eliminen de pendents
                  avisJug = (semafor)def.avisJugador.get( ((aposta)regioCritica.pendents.lastElement()).jug() );
	          regioCritica.pendents.remove(regioCritica.pendents.lastElement());
	          regioCritica.seccSal();
	          avisJug.s();
	       }
	       regioCritica.seccEnt();
	    }
	    // Ara ja podem mirar el nombre guanyador i els jugadors agraciats ;)
	    System.out.println("EL NOMBRE GUANYADOR: "+regioCritica.bolla);
	    for (Enumeration e = regioCritica.aceptades.elements(); e.hasMoreElements(); ){
	       apos = (aposta)e.nextElement();
               if (apos.num() == regioCritica.bolla) {
	          System.out.println("El jugador "+apos.jug()+" ha guanyat...");
		  System.out.println("...la seva aposta era de "+apos.nfi()+".");
		  // Si el jugador encerta, guanya el doble d l'aposta
		  regioCritica.nFitxasBanca = regioCritica.nFitxasBanca - 2*apos.nfi();
	       } else {
		  // sino la banca se queda les fitxas d l'aposta
		  regioCritica.nFitxasBanca = regioCritica.nFitxasBanca + apos.nfi();
	       }
            }
	    // Hem d mirar si la banca ha "saltado"
	    if (regioCritica.nFitxasBanca <= 0) {
	       regioCritica.finalitzar();
            } else {
	       // Eliminam totes les apostes per començar la proxima jugada
	       regioCritica.aceptades.removeAllElements();
	    }   
	    regioCritica.seccSal();
         }
      } catch (acabamentException e) {}
   }
      
}
