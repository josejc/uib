/**
 * Definició de les constants.
 */
 
public  class constants {
	/**
	 * Capacitat del muntacarregues
	 */
	public static final Integer Capacitat = new Integer(4);
	
	/**
	 * Tipus de vehicles
	 */
	public static final Integer tipusGran  = new Integer(0);
	public static final Integer tipusPetit = new Integer(1);

	/**
	 * Dimensions dels vehicles
	 */
	public static final Integer dimPetit = new Integer(1);
	public static final Integer dimGran  = new Integer(2);
	
	/**
	 * Estats del muntacarregues
	 */
	public final static Integer planta_muntatge = new Integer(1);
	public final static Integer planta_magatzem = new Integer(2);
	public final static Integer pujant  		= new Integer(3);
	public final static Integer baixant 		= new Integer(4);
	
	/**
	 * métode per poder obtenir un string per indicar el tipus de vehicle
	 */
	public static synchronized String strTipus(Integer tipus) {
		if (tipus.intValue() == tipusGran.intValue()) return "Vehicle gran";
		else return "Vehicle petit";
	}

}
