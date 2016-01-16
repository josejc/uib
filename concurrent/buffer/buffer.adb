package body buffer is
   
   protected body BUFFER is
   
      entry send(valor: in tipus) when total < tamany is
      begin
         total := total+1;
         elements(coa) := valor;
         coa := (coa + 1) mod tamany;
      end send;
      
      entry receive(valor: out tipus) when total > 0 is
      begin
         total := total-1;
         valor := elements(cap);
         cap := (cap + 1) mod tamany;
      end receive;
   end BUFFER;
   
end buffer;
