generic

max: integer;
type tipus1 is private;
type tipus2 is private;

--	Paquet que servira per enmagatzemar el estat del procesos (gestio), 
-- aixi com el estat a on es troben de la seva feina, i tambe tenim el 
-- index del array a on tenim els punters als procesos en la gestio general
package estatproces is

subtype rang is integer range 1..max;

type aGestio is array (rang) of tipus1;
type aFeina is array (rang) of tipus2;

   protected type estatProces is
      -- Consulta i assignacio del estat al array de la feina
      function feina (i: integer) return tipus2;
      procedure feina (i: integer; estat: tipus2);
      -- Consulta i assignacio del estat al array del proces
      function gestio (i: integer) return tipus1;
      procedure gestio (i:integer; estat: tipus1);
      -- Retorna el num. de procesos d'aquest tipus...
      -- aquest numero tenim el tractament en diferents funcions per q
      -- no hi ha probl. de conc. per q nomes el fa servir la gestio gral.
      function num return integer;
      procedure inc;
      procedure dec;
   private
      gestioA : aGestio;
      feinaA : aFeina;
      total : integer := 0;
   end estatProces;
end estatproces;
