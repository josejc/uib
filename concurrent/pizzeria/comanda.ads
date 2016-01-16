generic

maxPizzas: integer := 7;
type tipus1 is private;
type tipus2 is private;

--	Paquet per enmagatzemar les dades de les comandas, es un tipus protegit
-- no es necesari per que a les seves dades no hi ha problemas de acces conc. 
package comanda is

subtype rangPizzas is integer range 1..maxPizzas;

type arrayPizzas is array (rangPizzas) of tipus1;

   protected type Comanda is
      -- Consulta el client de la comanda
      function cliente return integer;
      -- Asigna al client de la comanda
      procedure cliente (i: integer);
      -- Consulta y asignacio si hi ha un error
      function error return tipus2;
      procedure error (i: tipus2);
      -- Consulta y asignacio del array e index de pizzas on estan guardades
      function pizza (i: integer) return tipus1;
      procedure pizza (i:integer; nom: tipus1);
      function num return integer;
      procedure inc;
      procedure dec;
   private
      pizzas : arrayPizzas;
      total, cli : integer := 0;
      err : tipus2;
   end Comanda;
end comanda;
