import java.lang.*;

/**
 * Classe que impementa la funcionalitat d'un semàfor.
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
	 * mètode per donar un valor inicial.
	 */
	public void init(int v) {
		synchronized(this){
			valor = v;
		}
	}
	
	/**
	 * mètode wait.
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
	 * mètode signal.
	 */
	public void s() {
		synchronized(this){
			if (valor == 0)
				this.notify();
			
			valor ++;
		}
	}
}
