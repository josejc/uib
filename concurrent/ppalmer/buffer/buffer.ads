generic
   tamany: integer := 10;
   type tipus is private;
   
package buffer is

   subtype rang is integer range 0..tamany-1;
   type taula is array(rang) of tipus;
   
   protected type BUFFER is
      entry send(valor:in tipus);
      entry receive(valor:out tipus);
   private
      elements: taula;
      total: integer range 0..tamany := 0;
      cap, coa: rang := 0;
   end BUFFER;
   
end buffer;
   
