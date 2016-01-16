import java.lang.*;
import java.util.*;

/**
 * Classe que simula el comportament de la bolla.
 */
public final class bolla extends Thread {

   int i,j;		// Variables auxiliars per fer bucles ;)
	
   // Per generar nombres aleatoris
   private final Random rand = new Random();
   
   /**
   * M�tode per acabar. Cap altre proc�s l'invocar�.
   */
   public void finalitzar() throws acabamentException {
      System.out.println("\t\tBolla ha d'acabar.");
      //destroy(); // Acabam
      throw new acabamentException();
   }
	
   /**
   * Constructor. No hi ha cap relaci� guardi�-depenent.
   */
   public bolla() {
      System.out.println("\t\tBolla creada.");
      setDaemon(true);
   }
	
   /**
   * M�tode d'execuci�
   */
   public void run () {
	    
      System.out.println("\t\tInici d'execucio de la bolla.");
	    	    
      try {
         while (true) {
            /**
	    * Aquest bucle es repeteix fins que s'acaba el programa.
	    */
	    if (regioCritica.acabar()) finalitzar();
				
	    // Esperam a que la Banca posi la bolla en marxa :)
	    def.bollaMov.w();
	    System.out.println("La bolla esta en moviment.");
			
	    for(i=1; i<=2; i++){
	       for(j=1; j<=def.CANVIS_SEG[i-1]; j++){
		  // Esperam un cert temps a q la bolla canvi d nombre
		  try {
		     sleep(def.SEGON*i);
		  } catch (InterruptedException e) {}
		  // Secci� d'entrada a la regi� cr�tica
		  regioCritica.seccEnt();
                  // Canvi de nombre d la bolla
		  regioCritica.bolla = rand.nextInt(def.NUM_RULETA);
		  System.out.println("Bolla N�: "+regioCritica.bolla);
		  // Secci� sortida de la regi� cr�tica
		  regioCritica.seccSal();
               }
            }
	    
	    // Avisam a la banca q la bolla esta aturada
            def.avisBanca.s();
         }
      } catch (acabamentException e) {}
   }
      
}
