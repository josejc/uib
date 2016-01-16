import java.lang.*;

/**
 * Classe estàtica que implementa la regió crítica sobre
 * la que actuen tant el muntacarregues com els diferents
 * vehicles.
 */
public  class regio_critica {
	
	/**
	 * On es troba el muntacarregues i nombre de vehicles que s'hi troben.
	 */
	public static Integer estat = constants.planta_muntatge;
	public static int nombrePetits = 0;
	public static int nombreGrans  = 0;
	
	/**
	 * Objectes per bloquejar segons cada possible cas.
	 */	
	protected final static Object entrada_vehicle = new Object();
	protected final static Object sortida_vehicle = new Object();
	protected final static Object muntacarregues_abaix = new Object();
	protected final static Object muntacarregues_adalt = new Object();
	
	/**
	 * Variable per notificar a cada procés si ha d'acabar-se
	 */
	private static boolean acaba = false;
	
	/**
	 * semafor per establir l'accés exclusiu a la regió crítica.
	 */
	private static semafor mutex = new semafor(1);
	
	
	/**
	 * mètode per bloquejar el muntacarregues fins que entri un vehicle.
	 * S'invocarà tantes vegades com sigui precís fins que el 
	 * muntacarregues quedi ple.
	 */
	public static void bloqueja_entrada_vehicle() {
		synchronized (entrada_vehicle) {
			try {
				entrada_vehicle.wait();
			} catch (InterruptedException e) {}
		}
	}
	
	/**
	 * Quan un vehicle entra al muntacarregues, aquest mètode fa que el
	 * muntacarregues s'alliberi del bloqueig de manera que pugui 
	 * actualitza-se adequadament.
	 */
	public static void allibera_entrada_vehicle() {
		synchronized (entrada_vehicle) {
			entrada_vehicle.notify();
		}
	}
	
	
	/**
	 * mètode per bloquejar el muntacarregues fins que surti un vehicle.
	 * Aquest mètode s'utilitzarà per buidar el muntacarregues.
	 */
	public static void bloqueja_sortida_vehicle() {
		synchronized (sortida_vehicle) {
			try {
				sortida_vehicle.wait();
			} catch (InterruptedException e) {}
		}
	}
	
	/**
	 * quan un vehicle surt. el muntacarregues ho detecta perque el vehicle 
	 * invoca aquest mètode.
	 */
	public static void allibera_sortida_vehicle() {
		synchronized (sortida_vehicle) {
			sortida_vehicle.notify();
		}
	}
	
	/**
	 * Els vehicle no poden entrar al muntacarregues fins que aquest no 
	 * arriba a la planta de muntatge. Per això esperen.
	 */
	public static void bloqueja_muntacarregues_abaix() {
		synchronized (muntacarregues_abaix) {
			try {
				muntacarregues_abaix.wait();
			} catch (InterruptedException e) {}
		}
	}
	
	/**
	 * Els vehicles s'activen quan el muntacarregues notifica la seva
	 * arribada.
	 */ 
	public static void allibera_muntacarregues_abaix() {
		synchronized (muntacarregues_abaix) {
			muntacarregues_abaix.notifyAll();
		}
	}
	
	/**
	 * Els vehicles que entren al muntacarregues esperen a que arribi
	 * el moment de sortir.
	 */
	public static void bloqueja_muntacarregues_adalt() {
		synchronized (muntacarregues_adalt) {
			try {
				muntacarregues_adalt.wait();
			} catch (InterruptedException e) {}
		}
	}
	
	/**
	 * El muntacarregues notifica als vehicles que ja poden sortir.
	 */
	public static void allibera_muntacarregues_adalt() {
		synchronized (muntacarregues_adalt) {
			muntacarregues_adalt.notifyAll();
		}
	}
	
	/**
	 * Aquest mètode és invocat quan els vehicles i el muntacarregues
	 * han d'acabar.
	 */
	public static synchronized void finalitzar() {
		acaba = true;
	}
	
	/**
	 * Mètode que fa saber als processos si han d'acabar o no.
	 */
	public static synchronized boolean acabar() {
		return acaba;
	}
	
	/**
	 * Mecanisme per assegurar-se l'accés exclusiu a la regió crítica.
	 * Utilitza un semàfor mutex per establir el bloqueig.
	 */
	public static void entrada_regio_critica() {
		mutex.w();
	}
	
	/**
	 * Sortida de la regió crítica.
	 */
	public static void sortida_regio_critica() {
		mutex.s();
	}
	
	/**
	 * Mètode per calcular l'espai ocupat del muntacarregues.
	 */
	public static int espai_ocupat() {
		return (nombrePetits * constants.dimPetit.intValue() +
			    nombreGrans * constants.dimGran.intValue());
		
	}
	
}
