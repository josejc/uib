import java.lang.*;

/**
 * Classe que simula el comportament del muntacarregues.
 */
public final class muntacarregues extends Thread {
    /**
	 * Temps que tarda el muntacarregues en pujar o baixar.
	 */
	private final int millisegons_moviment = 4000;
	//private final AcabamentException fi = new AcabamentException();
	
	/**
	 * Mètode per acabar. Cap altre procés l'invocarà.
	 */
	public void finalitzar() throws AcabamentException {
		System.out.println("\t\tMuntacarregues ha d'acabar.");
		//destroy(); // Acabam
		throw new AcabamentException();
	}
	
	/**
	 * Constructor. No hi ha cap relació guardià-depenent.
	 */
	public muntacarregues() {
		
		System.out.println("\t\tMuntacarregues creat.");
		setDaemon(true);
	}
	
	/**
	 * Mètode d'execució
	 */
	public void run () {
	    
      System.out.println("\t\tInici d'execucio del muntacarregues");
	    	    
	  try {
		while (true) {
			/**
			 * Aquest bucle es repeteix fins que s'acaba el programa.
			 */
			if (regio_critica.acabar()) finalitzar();
				
			/**
			 * Entrada a la regió crítica.
			 */
			regio_critica.entrada_regio_critica();

			/**
			 * Esperar que els vehicle umplin el muntacarregues
			 */
			while (constants.Capacitat.intValue() > 
						regio_critica.espai_ocupat()) {
				regio_critica.sortida_regio_critica();

				regio_critica.bloqueja_entrada_vehicle();

				if (regio_critica.acabar()) finalitzar();

				regio_critica.entrada_regio_critica();

				System.out.println("\t\tEntrada d'un nou vehicle");
        	}

			/**
			 * Tancar portes i partir
			 */
			regio_critica.estat = constants.pujant;

	    	System.out.println("\t\tMuntacarregues puja");

			regio_critica.sortida_regio_critica();
			
			/**
			 * Dixar que puji. Passa un temps.
			 */
			try {
				sleep(millisegons_moviment);
			} 
			catch (InterruptedException e) {}
			
			if (regio_critica.acabar()) finalitzar();
			
			/**
			 * Si no s'ha acabat, es torna a accedir a la regió crítica
			 */
			regio_critica.entrada_regio_critica();
			
			/**
			 * S'Ha arribat al magatzem. Es fa saber als vehicles.
			 */
			regio_critica.estat = constants.planta_magatzem;
			
			System.out.println("\t\tObrir portes i esperar a buidar");
			regio_critica.allibera_muntacarregues_adalt();
			
			/**
			 * Esperar a que es buidi.
			 */
			while (regio_critica.espai_ocupat() > 0) {
				 regio_critica.sortida_regio_critica();
				 regio_critica.bloqueja_sortida_vehicle();
				 if (regio_critica.acabar()) finalitzar();
				 regio_critica.entrada_regio_critica();
	    	}

			/**
			 * ja esta buit, tancar portes i baixar
 			 */
			regio_critica.estat = constants.baixant;
			regio_critica.sortida_regio_critica();

	    	System.out.println("\t\tMuntacarregues baixa");
			
			/**
			 * Per baixar també ha de passar un cert temps.
			 */
			try {
				sleep(millisegons_moviment);
			} 
			catch (InterruptedException e) {}
			
			if (regio_critica.acabar()) finalitzar();
			
			/**
			 * Si no s'ha acabat. S'arriba a la planta de muntatge.
			 * Aquest fet s'ha de donar a conèixer als vehicles.
			 */
			regio_critica.entrada_regio_critica();
			
			
	    	System.out.println(
						"\t\tMuntacarregues arriba a la planta de muntatge");

			regio_critica.estat = constants.planta_muntatge;
			regio_critica.allibera_muntacarregues_abaix();

			System.out.println("\t\tPortes obertes, poden entrar vehicles");
			
			regio_critica.sortida_regio_critica();
			/**
			 * S'acaba el bucle. Aquestes operacions es repeteixen sempre.
			 */
		}
		
			}
			catch (AcabamentException e) {
			    
			}
	}
}
