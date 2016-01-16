import java.lang.*;

/**
 * Classe per definir els vehicles.
 *
 * Tant els vehicles gran com els petits son objectes d'aquesta classe.
 * La diferenciació del tipus de vehicle de què es tracta es fa per
 * la parametrització del constructor de la classe.
 */
public class vehicle extends Thread {

	/**
	 * Atributs de la classe:
	 *        el tipus de vehicle
	 *        el valor del comptador corresponent
	 */
	private Integer tipus;
	private Integer codi;
	
	/**
	 * Cosntructor. Invoca al constructor de la classe base, Thread.
	 */
	vehicle(Integer t, int identificador, ThreadGroup grup) {
		super(grup, new String(constants.strTipus(t)+
					 new Integer(identificador)));
		tipus = t;
		codi = new Integer(identificador);
		
		/**
		 * Missatge de feedback.
		 */
		System.out.println("\t\t\t\t"+constants.strTipus(tipus)+" "+codi
									+" Creat.");
		/**
		 * Explícitament es romp la relació guardià-depenent.
		 */
		setDaemon(true);
	}	
	
	/**
	 * metode per acabar.
	 * En principi és public. Però en aquest cas concret no hi ha cap altre
	 * objecte que invoqui aquest mètode.
	 */
	public void finalitzar() throws AcabamentException {
		System.out.println("\t\t\t\t"+constants.strTipus(tipus)+" "+codi
									+" ha d'acabar.");
		//destroy(); // Acabam
		throw new AcabamentException();
	}
	
	/**
	 * Fució que determina si el vehicle cap o no dins del muntacarregues.
	 */
	protected boolean hicap() {
		
		int disponible = constants.Capacitat.intValue() - 
						  regio_critica.espai_ocupat();
						  
		disponible = disponible - 
				((tipus.intValue() == constants.tipusGran.intValue()) ?
					constants.dimGran.intValue() :
					constants.dimPetit.intValue());
					
		return disponible >= 0;
	}
	
	/**
	 * Mètode d'execució.
	 */
	public void run () {

		System.out.println("\t\t\t\t"+constants.strTipus(tipus)+" "+codi
									+" iniciat.");
		boolean acabar = false;
		
		/**
		 * Si s'ha d'acabar, s'acaba.
		 */
		try {
		if (regio_critica.acabar()) finalitzar();
		
									
		/**
		 * El vehicle intenta entrar al muntacarregues.
		 */
		regio_critica.entrada_regio_critica();
									
		/**
		 * Per entar hi ha de caber i el muntacarregues ha de trobar-se
		 * al lloc adequat.
		 */
		while ((regio_critica.estat.intValue() 
				!= constants.planta_muntatge.intValue()) ||
			   ! hicap()) {
			System.out.println("\t\t\t\t"+constants.strTipus(tipus)+" "+codi
									+" no hi cap. Espera");
							
			/**
			 * Si no pot entrar espera.
			 */		
			regio_critica.sortida_regio_critica();
			regio_critica.bloqueja_muntacarregues_abaix();
			if (regio_critica.acabar()) finalitzar();
			regio_critica.entrada_regio_critica();
				
			
			System.out.println("\t\t\t\t"+constants.strTipus(tipus)+" "+codi
									+" no hi cabia. Ho torna a provar");

		}

		/**
		 * El vehicle ja pot entrar
		 */
		System.out.println("\t\t\t\t"+constants.strTipus(tipus)+" "+codi
									+" entra");
			
		/**
		 * El vehicle actualitza les dades de la regió crítica
		 * en funció del tipus de vehicle de que es tracti
		 */						
		if (tipus.intValue() == constants.tipusGran.intValue())
			regio_critica.nombreGrans++;
		else
			regio_critica.nombrePetits++;
		regio_critica.allibera_entrada_vehicle();
		
		System.out.println("\t\t\t\t"+constants.strTipus(tipus)+" "+codi
									+" espera a pujar");
		 
		/**
		 * Ara s'ha d'esperar a que el muntacarregues quedi ple
		 * i pugi al magatzem.
		 */
		regio_critica.sortida_regio_critica();
		regio_critica.bloqueja_muntacarregues_adalt();
		if (regio_critica.acabar()) finalitzar();
		regio_critica.entrada_regio_critica();
		 

		/**
		 * Ara s'ha de sortir. Reduint el nombre de vehicles que resten
		 * al muntacarregues.
		 */
		System.out.println("\t\t\t\t"+constants.strTipus(tipus)+" "+codi
		 						   +" surt");
		   
		if (tipus.intValue() == constants.tipusGran.intValue())
			regio_critica.nombreGrans--;
		else
			regio_critica.nombrePetits--;
		regio_critica.allibera_sortida_vehicle();

		regio_critica.sortida_regio_critica();

		System.out.println("\t\t\t\t"+constants.strTipus(tipus)+" "+codi
		 						   +" aparca");
								   
		/**
		 * Amb això s'acaba la part que interessa del vehicle.
		 */
		}
		catch (AcabamentException e) {
		}
	}
}
