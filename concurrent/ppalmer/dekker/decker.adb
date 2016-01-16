with Ada.Text_Io; use Ada.Text_Io;
with Ada.Integer_Text_Io; use Ada.Integer_Text_Io;
with Ada.Numerics.Float_Random; use Ada.Numerics.Float_Random;

procedure Decker is
   type Acceso is (permitido, denegado);

   turno: Integer range 1..2 := 1;
   e1, e2: Acceso := denegado;
   task p1;
   task p2;

   procedure pescar(e: in Integer; G: in Generator) is
      pep: float;
   begin
      pep := Random(G);
      Put_Line("Estoy pescando: Proceso " & Float'Image(pep));
      delay 5.0;
   end pescar;

   procedure pasear(e: in Integer) is
   begin
      Put_Line("Me voy a pasear: Proceso " & Integer'Image(e));
      delay 5.0;
   end pasear;

   procedure otras_cosas(e: in Integer) is
   begin
      Put_Line("Ahora otras cosas... Proceso " & Integer'Image(e));
      delay 5.0;
   end otras_cosas;

   task body p1 is
      G: Generator;
   begin
      Reset(G);
      loop
         e1 := permitido;
	 while e2 = permitido loop
	    if turno = 2 then
	       e1 := denegado;
	       pasear(1);
	       e1 := permitido;
	    else
	       pasear(1);
	    end if;
	 end loop;
	 pescar(1,G);
	 e1 := denegado;
	 turno := 2;
	 otras_cosas(1);
      end loop;
   end p1;
   
   task body p2 is
      G: Generator;
   begin
      reset(G);
      loop
         e2 := permitido;
	 while e1 = permitido loop
	    if turno = 1 then
	       e2 := denegado;
	       pasear(2);
	       e2 := permitido;
	    else
	       pasear(2);
	    end if;
	 end loop;
	 pescar(2, G);
	 e2 := denegado;
	 turno := 1;
	 otras_cosas(2);
      end loop;
   end p2;

begin
   null;
end Decker;
