import java.lang.*;
import java.util.*;

/**
 * Classe est�tica que implementa la regi� cr�tica sobre
 * la que actuen tant la banca, els jugadors com la bolla.
 */
public  class regioCritica {
	
	/**
	 * L'estat del sistema es compon de les seg�ents variables
	 */
	public static int bolla = 0;
	public static Vector mortJug = new Vector();
	public static boolean jugadaMarxa = false;
	public static int nFitxasBanca = 4*def.FITXAS_JUG;
	// i per emmagatzemar les apostes tant aceptades com pendents...
	public static Vector aceptades = new Vector();
	public static Vector pendents = new Vector();
	
	/**
	 * Variable per notificar a cada proc�s si ha d'acabar-se
	 */
	private static boolean acaba = false;
	
	/**
	 * semafor per establir l'acc�s exclusiu a la regi� cr�tica.
	 */
	private static semafor mutex = new semafor(1);
	
	
	/**
	 * Aquest m�tode �s invocat quan els jugadors, bolla i banca
	 * han d'acabar.
	 */
	public static synchronized void finalitzar() {
		acaba = true;
	}
	
	/**
	 * M�tode que fa saber als processos si han d'acabar o no.
	 */
	public static synchronized boolean acabar() {
		return acaba;
	}
	
	/**
	 * Mecanisme per assegurar-se l'acc�s exclusiu a la regi� cr�tica.
	 * Utilitza un sem�for mutex per establir el bloqueig.
	 */
	public static void seccEnt() {
		mutex.w();
	}
	
	/**
	 * Sortida de la regi� cr�tica.
	 */
	public static void seccSal() {
		mutex.s();
	}
	
}
