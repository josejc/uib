import java.util.*;

/**
 * Definició de les constants i semafors.
 */
 
public  class def{
	
   public static final int NUM_RULETA = 38;
   public static final int FITXAS_JUG = 50;
   public static final int T_ACEPTACIO = 7;
   public static final int CANVIS_SEG[] = {8, 3};

   public static final semafor avisBanca = new semafor(0);
   public static final Vector avisJugador = new Vector();
   public static final semafor bollaMov = new semafor(0);
   public static final semafor iniTemps = new semafor(0);
	
}
