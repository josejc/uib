generic

max: integer;

--	Paquet per definir un tipus protegit i tenir exclusio mutua damunt
-- el index del array a on accedeixen tots els proc. per tractar les comandes
package indcomanda is

   protected type indComanda is
      --    Sempre retorna el index a la següent posicio buida del array de 
      -- comandes, d'aquesta manera no hi ha dos clients fasin feina damunt
      -- la mateixa posicio del array
      procedure ind (i: out integer);
   private
      total : integer := 0;
   end indComanda;
end indcomanda;
