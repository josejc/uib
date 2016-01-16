import java.lang.*;
import java.util.*;

/**
 * Classe estàtica que implementa la regió crítica sobre
 * la que actuen tant la banca, els jugadors com la bolla.
 */
public  class regioCritica {
	
	/**
	 * L'estat del sistema es compon de les següents variables
	 */
	public static int bolla = 0;
	public static Vector mortJug = new Vector();
	public static boolean jugadaMarxa = false;
	public static int nFitxasBanca = 4*def.FITXAS_JUG;
	// i per emmagatzemar les apostes tant aceptades com pendents...
	public static Vector aceptades = new Vector();
	public static Vector pendents = new Vector();
	
	/**
	 * Variable per notificar a cada procés si ha d'acabar-se
	 */
	private static boolean acaba = false;
	
	/**
	 * semafor per establir l'accés exclusiu a la regió crítica.
	 */
	private static semafor mutex = new semafor(1);
	
	
	/**
	 * Aquest mètode és invocat quan els jugadors, bolla i banca
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
	public static void seccEnt() {
		mutex.w();
	}
	
	/**
	 * Sortida de la regió crítica.
	 */
	public static void seccSal() {
		mutex.s();
	}
	
}
