package body indcomanda is

   protected body indComanda is
      procedure ind (i: out integer) is
      begin
         total := (total +1) mod max;
         i := total;
      end ind;
   end indComanda;
end indcomanda;
