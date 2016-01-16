package body comanda is

   protected body Comanda is
      function cliente return integer is
      begin
         return cli;
      end cliente;
      procedure cliente (i: integer) is
      begin
         cli := i;
      end cliente;
      function error return tipus2 is
      begin
         return err;
      end error;
      procedure error (i: tipus2) is
      begin
         err := i;
      end error;
      function pizza (i: integer) return tipus1 is
      begin
         return pizzas(i);
      end pizza;
      procedure pizza (i:integer; nom: tipus1) is
      begin
         pizzas(i) := nom;
      end pizza;
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
   end Comanda;
end comanda;
