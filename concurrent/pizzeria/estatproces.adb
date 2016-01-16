package body estatproces is

   protected body estatProces is
      function feina (i: integer) return tipus2 is
      begin
         return feinaA(i);
      end feina;
      procedure feina (i:integer; estat: tipus2) is
      begin
         feinaA(i) := estat;
      end feina;
      function gestio (i: integer) return tipus1 is
      begin
         return gestioA(i);
      end gestio;
      procedure gestio (i:integer; estat: tipus1) is
      begin
         gestioA(i) := estat;
      end gestio;
      function num return integer is
      begin
         return total;
      end num;
      procedure inc is
      begin
         total := total + 1;
      end inc;
      procedure dec is
      begin
         total := total - 1;
      end dec;
   end estatProces;
end estatproces;
