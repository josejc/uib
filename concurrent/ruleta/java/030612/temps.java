import java.lang.*;
import java.util.*;

/**
 * Classe que controlara l'espai temporal mentre la banca acepta apostes.
 */
public final class temps extends Thread {

   /**
   * Que es 1 segon en milisegons.
   */
   private final int segon = 1000;

   // Per generar nombres aleatoris
   private final Random rand = new Random();
	
   /**
   * Mètode per acabar. Cap altre procés l'invocarà.
   */
   public void finalitzar() throws acabamentException {
      System.out.println("\t\tTemps ha d'acabar.");
      throw new acabamentException();
   }
	
   /**
   * Constructor. No hi ha cap relació guardià-depenent.
   */
   public temps() {
      System.out.println("\t\tTemps creat.");
      setDaemon(true);
   }
	
   /**
   * Mètode d'execució
   */
   public void run () {
	    
      System.out.println("\t\tInici d'execucio del temps (control espai temporal).");
	    	    
      try {
         while (true) {
            /**
	    * Aquest bucle es repeteix fins que s'acaba el programa.
	    */
	    if (regioCritica.acabar()) finalitzar();

	    // Esperam per q la banca posi en marxa el temps... ;)
	    def.iniTemps.w();
	    // La banca acepta apostas durant un espai temporal entre 5..10 segons i la darrera aposta
	    try {
	       sleep(segon*(5+rand.nextInt(5)));
	    } catch (InterruptedException e) {}
	    // Avisam a la banca q ha finalitzat el temps...
	    def.avisBanca.s();
         }
      } catch (acabamentException e) {}
   }
      
}
