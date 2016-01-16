public class aposta {
   
   private int jugador;
   private int nFichas;
   private int numero;

    //********************************************************************************
    //********************************************************************************
    public aposta(int jug, int nFi, int num) {
      jugador = jug;
      nFichas = nFi;
      numero = num;
    }

   //*************************************************************
   //*************************************************************
   public void escriure()
   {
      String valor = new String("El jugador "+jugador+" fa una aposta de "+nFichas+" fitxas al nombre "+numero+".");

      System.out.println(valor);
   }

   public int num() {
      return(numero);
   }

   public int jug() {
      return(jugador);
   }

   public int nfi() {
      return(nFichas);
   }

}

