with buffer;
with Ada.Text_IO;
with Ada.Numerics.Discrete_Random;
with Ada.Real_Time;

use Ada.Real_Time;

procedure prova is


   subtype valors is integer range 1..1000;

   package random is new Ada.Numerics.Discrete_Random(valors);
   package bufferc_int is new buffer(10, integer);
   use bufferC_int;

   protegit : bufferC_int.BUFFER;

   task type proces (nom : character);

   task body proces is
	increment : constant Ada.Real_Time.Time_Span := 
			Ada.Real_Time.To_Time_Span(0.5);

        estat : random.Generator;
        valor : valors;
   begin
      random.Reset(estat);
      init(protegit);

      loop
	delay until Ada.Real_Time.Clock + increment;
	valor := random.Random(estat);

	if valor < 500 then

	     valor := random.Random(estat);
	     send(protegit, valor);
           Ada.Text_IO.Put("P" & integer'image(character'pos(nom)));
           Ada.Text_IO.Put(".- Escric: ");
	     Ada.Text_IO.Put_Line(integer'image(valor));

        else

           receive(protegit, valor);
           Ada.Text_IO.Put("P" & integer'image(character'pos(nom)));
           Ada.Text_IO.Put(".- llegeix: ");
	     Ada.Text_IO.Put_Line(integer'image(valor));

        end if;

      end loop;
   end proces;

   type ptrProces is access proces;
   

   processos : array (1..40) of ptrProces;

begin

   for i in 1..40 loop
	processos(i) := new proces(character'val(i));
   end loop;

   delay 60.0;

   for i in 1..40 loop
         abort processos(i).all;
   end loop;

   Ada.Text_IO.Put_Line("Ara tot s'ha acabat.");
end prova;
