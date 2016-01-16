import java.lang.*;

/**
 * Classe que impementa la funcionalitat d'un sem�for.
 */
public class semafor {
	/**
	 * enter que acumula el valor del semafor. No pot ser negatiu.
	 */
	private int valor;
	
	/**
	 * Constructor amb un valor inicial.
	 */
	public semafor(int inicial) {
		valor = inicial;
	}
	
	/**
	 * Constructor per defecte.
	 */
	public semafor() {
		valor = 0;
	}
	
	/**
	 * m�tode per donar un valor inicial.
	 */
	public void init(int v) {
		synchronized(this){
			valor = v;
		}
	}
	
	/**
	 * m�tode wait.
	 */
	public void w() {
		synchronized(this){
			
			while (valor == 0)
				try {
					this.wait();
				} catch (InterruptedException e) {}
			
			valor--;
		}
	}
	
	/**
	 * m�tode signal.
	 */
	public void s() {
		synchronized(this){
			if (valor == 0)
				this.notify();
			
			valor ++;
		}
	}
}
