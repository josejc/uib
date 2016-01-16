with buffer;
with estatproces;
with comanda;
with indcomanda;
with Ada.Text_IO;
with Ada.Numerics.Discrete_Random;

procedure pizzeria is

   maxClients: constant integer := 20;
   maxRepartidors: constant integer := 10;
   maxBuffer: constant integer := 15;  
   -- Aquesta constant tambe se fa servir per obtener els num. aleatoris
   maxPizzas: constant integer := 7; 
   maxCuiners: constant integer := 3;
   maxComandes: constant integer := 100;

   subtype rangAleatori is integer range 1..maxPizzas;

   -- Els diferents error a on se podem produir, fins q arriva la pizza al cli.
   type terror is (ningu, agafar, cuina, entregar);
   -- Un proces esta bloquetjat quan esta esperant... quan termina de fer la
   -- feina q te a mitjes aleshores es morira ;)
   type estatProc is (viu, bloquetjat, mort);
   -- L'estat 'res' es per quan els procesos estan morts :P, q no fan res
   type estatCuin is (esperaComanda, fentComanda, res);
   type estatClie is (esperaComanda, menjant, res);
   type estatRepa is (esperaComanda, repartint, res);

   package random is new Ada.Numerics.Discrete_Random(rangAleatori);
   -- Definim els paquets dels estats dels diferents procesos que interactuan
   -- amb l'usuari (gestio general)
   package estatCuiners is new estatproces(maxCuiners, estatProc, estatCuin);
   package estatClients is new estatproces(maxClients, estatProc, estatClie);
   package estatRepartidors is new estatproces(maxRepartidors, estatProc, estatRepa);
   -- Les pizzas seran enters, q voldra dir el seu tipus (s'hauria pogut fer
   -- un tipus per les pizzes amb les definicions ja fetes, pero aixi tambe funciona)
   package comandas is new comanda(maxPizzas, integer, terror);
   -- Al buffer pasarem l'index del array de comandes a on estan enmagat.,
   -- a mi m'agradaria pasar directament la comanda, pero amb el menu nivell 
   -- d'ada no he conseguit restringuir el tipus q es l'error q dona al compilar
   -- package bufferComanda is new buffer(maxBuffer, comandas.Comanda) ?????
   package bufferComanda is new buffer(maxBuffer, integer);
   -- Tenim exclusio mutua amb tipus protegits per el index i fora problemes, 
   -- es a dir 2 clients no faran servir mai la mateixa posicio a l'array ;) 
   package iComanda is new indcomanda(maxComandes); 

   bComandaAFer, bComandaFeta, bComandaPerDur, bComandaDemanada : bufferComanda.buffer;
   estatC : estatCuiners.estatProces;
   estatCl: estatClients.estatProces;
   estatR : estatRepartidors.estatProces;
   comand: array (0..maxComandes-1) of comandas.Comanda;
   iC : iComanda.indComanda;  
   finalitzar : boolean := false;

   
   procedure imprimir is
   begin
   --Imprimeix dades dels clients
   Ada.Text_IO.Put_Line("Nombre de clients:" & integer'image(estatCl.num));
   for i in 1..estatCl.num loop
      Ada.Text_IO.Put("Client:" & integer'image(i));
      case estatCl.gestio(i) is
         when mort =>
            Ada.Text_IO.Put(" mort,");
         when viu =>
            Ada.Text_IO.Put(" viu,");
         when others =>
            Ada.Text_IO.Put(" bloquetjat,");
      end case;      
      case estatCl.feina(i) is
         when esperaComanda =>
            Ada.Text_IO.Put(" espera una comanda.");
         when menjant =>
            Ada.Text_IO.Put(" esta menjant o espera a tenir gana.");
         when others => 
            Ada.Text_IO.Put(" no fa res...no existeix :P");
      end case;      
      Ada.Text_IO.Put_Line(" ");
   end loop;
   --Imprimeix dades dels cuiners
   Ada.Text_IO.Put_Line("Nombre de cuiners:" & integer'image(estatC.num));
   for i in 1..estatC.num loop
      Ada.Text_IO.Put("Cuiner:" & integer'image(i));
      case estatC.gestio(i) is
         when mort =>
            Ada.Text_IO.Put(" mort,");
         when viu =>
            Ada.Text_IO.Put(" viu,");
         when others =>
            Ada.Text_IO.Put(" bloquetjat,");
      end case;      
      case estatC.feina(i) is
         when esperaComanda =>
            Ada.Text_IO.Put(" espera una comanda.");
         when fentComanda =>
            Ada.Text_IO.Put(" esta fent una comanda.");
         when others => 
            Ada.Text_IO.Put(" no fa res...no existeix :P");
      end case;      
      Ada.Text_IO.Put_Line(" ");
   end loop;
   --Imprimeix dades dels repartidors
   Ada.Text_IO.Put_Line("Nombre de repartidors:" & integer'image(estatR.num));
   for i in 1..estatR.num loop
      Ada.Text_IO.Put("Repartidor:" & integer'image(i));
      case estatR.gestio(i) is
         when mort =>
            Ada.Text_IO.Put(" mort,");
         when viu =>
            Ada.Text_IO.Put(" viu,");
         when others =>
            Ada.Text_IO.Put(" bloquetjat,");
      end case;      
      case estatR.feina(i) is
         when esperaComanda =>
            Ada.Text_IO.Put(" espera una comanda.");
         when repartint =>
            Ada.Text_IO.Put(" esta repartint la comanda.");
         when others => 
            Ada.Text_IO.Put(" no fa res...no existeix :P");
      end case;      
      Ada.Text_IO.Put_Line(" ");
   end loop;
   end imprimir;
					 					     
   -- Un unic dependent q s'encarrega dels moviments de les comandas entre buffers   
   task type dependent;
   task body dependent is
      index: integer; 
      aleator : random.Generator;
   begin
      random.Reset(aleator);
      -- L'encarregat nomes fa
      loop
         -- no espera mai nomes fa feina si te comandes
	 -- dins el buffer comandas q demanen els clients
         if (not bComandaDemanada.empty) then
            bComandaDemanada.receive(index);
            --posam un error al agafar la comanda... si
            if (random.Random(aleator) > (maxPizzas-1)) then
               comand(index).error(agafar);
            end if;
	    Ada.Text_IO.Put("Dependent rep una comanda: ");
            Ada.Text_IO.Put_Line(integer'image(index) & " d'un client i li passa a un cuiner.");
            bComandaAFer.send(index);
         end if;
	 -- dins el buffer comandes que donen els cuiners per donar als repartidors
         if (not bComandaFeta.empty) then
            bComandaFeta.receive(index);
	    Ada.Text_IO.Put("Dependent rep una comanda: ");
            Ada.Text_IO.Put_Line(integer'image(index) & " d'un cuiner i li passa a un repartidor.");
            bComandaPerDur.send(index);
         end if;
      end loop;
   end dependent;

   type ptrDependent is access dependent;
   encarregat : ptrDependent;

   -- Client...
   task type client (nom : character) is
      entry entrega(i: in integer);
   end client;
   task body client is

        temps : random.Generator;
        espera: rangAleatori;
	valor, index, aux: integer;
   begin
      random.Reset(temps);
      index := integer(character'pos(nom));

      -- mentres la gestio no digui res, el proces esta viu
      while (estatCl.gestio(index)=viu) loop
        --espera a tenir gana, per q ja ha menjat ;)
        estatCl.feina(index, menjant);
	espera := random.Random(temps);
	delay Standard.duration(espera);
        --tria Comanda
        --posicio del array a on enmagatzarem la comanda
        iC.ind(valor);
        comand(valor).cliente(index); --asignam el client de la comanda
        comand(valor).error(ningu); --encara no hi ha cap error
        --nombre de pizzas q tindra la comanda i el seu tipus aleatori
        aux := random.Random(temps);
        for i in 1..aux loop
           comand(valor).inc;
           comand(valor).pizza(comand(valor).num, random.Random(temps));
        end loop;
        --pasam el index per el buffer per a l'encarregat
        bComandaDemanada.send(valor);
	Ada.Text_IO.Put("Client:" & integer'image(index));
	Ada.Text_IO.Put(".- Demana la comanda: ");
	Ada.Text_IO.Put_Line(integer'image(valor));
	estatCl.feina(index, esperaComanda);
	-- No feim servir un buffer per q el repartidor ens dura directament
	-- la comanda al client q la ha demanada :P
        accept entrega(i: integer) do
           valor := i;
        end entrega;
	Ada.Text_IO.Put("Client:" & integer'image(index));
	Ada.Text_IO.Put(".- Comanda entregada: ");
	Ada.Text_IO.Put_Line(integer'image(valor));
        --comprovar comanda, mirar el camp error
	Ada.Text_IO.Put("Client:" & integer'image(index));
	Ada.Text_IO.Put(".- Comanda comprovada amb error :");
        case comand(valor).error is
           when ningu =>
              Ada.Text_IO.Put_Line(" ningu.");
           when agafar =>
              Ada.Text_IO.Put_Line(" agafar.");
           when cuina =>
              Ada.Text_IO.Put_Line(" cuina.");
           when others => 
              Ada.Text_IO.Put_Line(" entregar");
        end case;      
      end loop;
      -- si la gestio ha modificat l'estat i el proces a
      -- finalitzat la feina, aleshores pot morir :(
      Ada.Text_IO.Put("Client:" & integer'image(index));
      Ada.Text_IO.Put_Line(". Ha finalitzat");
      estatCl.gestio(index, mort);
      estatCl.feina(index, res); 
      estatCl.dec;
   end client;

   type ptrClient is access client;
   clients : array (1..maxClients) of ptrClient;

   -- Cuiner...
   task type cuiner (nom : character);
   task body cuiner is
        tempsCuinar : random.Generator;
        espera: rangAleatori;
	valor, index: integer;
   begin
      random.Reset(tempsCuinar);
      index := integer(character'pos(nom));

      -- mentres la gestio no digui res, el proces esta viu
      while (estatC.gestio(index)=viu) loop
        -- indicam q l'estat del cuiner es espera una comanda i 
	-- esperam q arrivi la comanda mitjançan el buffer de comandes a fer
        estatC.feina(index, esperaComanda);
        bComandaAFer.receive(valor);
	Ada.Text_IO.Put("Cuiner:" & integer'image(index));
	Ada.Text_IO.Put(".- A fer: ");
	Ada.Text_IO.Put_Line(integer'image(valor));
	-- ara l'estat sera fent la comanda arrivada
	estatC.feina(index, fentComanda);
	-- hem d tenir un temps per ferla
	espera := random.Random(tempsCuinar);
	delay Standard.duration(espera);
        --posam error en la cuina si...
        if (random.Random(tempsCuinar) > (maxPizzas-1)) then
           comand(valor).error(cuina);
        end if;
	-- enviam la comanda mitjançan el buffer de comandas fetas
	bComandaFeta.send(valor);
	Ada.Text_IO.Put("Cuiner:" & integer'image(index));
	Ada.Text_IO.Put(".- Feta: ");
	Ada.Text_IO.Put_Line(integer'image(valor));
      end loop;
      -- si la gestio ha modificat l'estat i el proces a
      -- finalitzat la feina, aleshores pot morir :(
      Ada.Text_IO.Put("Cuiner:" & integer'image(index));
      Ada.Text_IO.Put_Line(". Ha finalitzat");
      estatC.gestio(index, mort);
      estatC.feina(index, res);
      estatC.dec;
   end cuiner;

   type ptrCuiner is access cuiner;
   cuiners : array (1..maxCuiners) of ptrCuiner;

   -- Repartidor...
   task type repartidor (nom : character);
   task body repartidor is
        tempsRepartir : random.Generator;
        espera: rangAleatori;
	valor, index: integer;
   begin
      random.Reset(tempsRepartir);
      index := integer(character'pos(nom));

      -- mentres la gestio no digui res, el proces esta viu
      while (estatR.gestio(index)=viu) loop
        -- indicam l'estat del repartidor i esperam una comanda
        estatR.feina(index, esperaComanda);
        bComandaPerDur.receive(valor);
	Ada.Text_IO.Put("Repartidor:" & integer'image(index));
	Ada.Text_IO.Put(".- A de repartir la comanda: ");
	Ada.Text_IO.Put_Line(integer'image(valor));
	-- un pic arrivada l'hem d repartir i aixo du temps ;)
	estatR.feina(index, repartint);
	espera := random.Random(tempsRepartir);
	delay Standard.duration(espera);
        --posam error en el repartiment si...
        if (random.Random(tempsRepartir) > (maxPizzas-1)) then
           comand(valor).error(entregar);
        end if;
	--envia la comanda directament al client propietari
        clients(comand(valor).cliente).entrega(valor);
	Ada.Text_IO.Put("Repartidor:" & integer'image(index));
	Ada.Text_IO.Put(".- A entregat la comanda: ");
	Ada.Text_IO.Put_Line(integer'image(valor));
      end loop;
      -- si la gestio ha modificat l'estat i el proces a
      -- finalitzat la feina, aleshores pot morir :(
      Ada.Text_IO.Put("Repartidor:" & integer'image(index));
      Ada.Text_IO.Put_Line(". Ha finalitzat");
      estatR.gestio(index, mort);
      estatR.feina(index, res);
      estatR.dec;
   end repartidor;

   type ptrRepartidor is access repartidor;
   repartidors : array (1..maxRepartidors) of ptrRepartidor;

   ordre : character;
begin
   -- Creacio de l'encarregat
   encarregat := new dependent;
   -- Inicialitzacio de l'estat dels clients
   for i in 1..maxClients loop
      estatCl.gestio(i, mort);
      estatCl.feina(i, res);
   end loop;
   -- Creacio d'un client
   estatCl.inc;
   estatCl.gestio(estatCl.num, viu);
   clients(estatCl.num) := new client(character'val(estatCl.num));
   -- Inicialitzacio de l'estat dels cuiners
   for i in 1..maxCuiners loop
      estatC.gestio(i, mort);
      estatC.feina(i, res);
   end loop;
   -- Creacio d'un cuiner
   estatC.inc;
   estatC.gestio(estatC.num, viu);
   cuiners(estatC.num) := new cuiner(character'val(estatC.num));
   -- Inicialitzacio de l'estat dels repartidors
   for i in 1..maxRepartidors loop
      estatR.gestio(i, mort);
      estatR.feina(i, res);
   end loop;
   -- Creacio d'un repartidor
   estatR.inc;
   estatR.gestio(estatR.num, viu);
   repartidors(estatR.num) := new repartidor(character'val(estatR.num));

   while (not finalitzar) loop
      Ada.Text_IO.Put("Ordre:");
      Ada.Text_IO.Get(ordre);
      case ordre is
         --finalitzar
         when 'f' | 'F' => 
	    finalitzar := true;
	 --imprimeix l'estat   
	 when 'e' | 'E' =>
	    imprimir;
	 --ordre per modificar el num. de clients dins el sistema
	 -- i+, i- per anyadir o eliminar un client
	 when 'i' | 'I' =>
	    -- si hi ha un bloquetjat es a dir hem eliminat un pero encara 
	    -- te feines a mitjes i no ha mort, esperam a q estigui mort
            if (estatCl.gestio(estatCl.num) = bloquetjat) then
               Ada.Text_IO.Put_Line("No se pot operar amb els clients, fins que no hagi cap bloquetjat.");
            else
   	       Ada.Text_IO.Get(ordre);
	       case ordre is
	          when '+' =>
	             if (estatCl.num < maxClients) then
		        estatCl.inc;
		        estatCl.gestio(estatCl.num, viu);
		        clients(estatCl.num) := new client(character'val(estatCl.num));
		     else
		        Ada.Text_IO.Put_Line("El nombre maxim de clients es " & integer'image(maxClients)); 
		     end if;
	          when '-' =>
	             if (estatCl.num > 1 ) then
		        estatCl.gestio(estatCl.num, bloquetjat);   
		     else 
		        Ada.Text_IO.Put_Line("El nombre minim de clients es 1.");
		     end if;
	          when others =>
	             Ada.Text_IO.Put_Line("Ordre clIent Incorrecta.");
	       end case;
            end if;
	 --ordre per modificar el num. de cuiners dins el sistema
	 -- c+, c- per anyadir o eliminar un cuiner
	 when 'c' | 'C' =>
	    -- si hi ha un bloquetjat es a dir hem eliminat un pero encara 
	    -- te feines a mitjes i no ha mort, esperam a q estigui mort	    
            if (estatC.gestio(estatC.num) = bloquetjat) then
               Ada.Text_IO.Put_Line("No se pot operar amb els cuiners, fins que no hagi cap bloquetjat.");
            else
   	       Ada.Text_IO.Get(ordre);
	       case ordre is
	          when '+' =>
	             if (estatC.num < maxCuiners) then
		        estatC.inc;
		        estatC.gestio(estatC.num, viu);
		        cuiners(estatC.num) := new cuiner(character'val(estatC.num));
		     else
		        Ada.Text_IO.Put_Line("El nombre mÃ¡xim de cuiners es 3."); 
		     end if;
	          when '-' =>
	             if (estatC.num > 1 ) then
		        estatC.gestio(estatC.num, bloquetjat);   
		     else 
		        Ada.Text_IO.Put_Line("El nombre minim de cuiners es 1.");
		     end if;
	          when others =>
	             Ada.Text_IO.Put_Line("Ordre Cuiner Incorrecta.");
	       end case;
            end if;
	 --ordre per modificar el num. de repartidors dins el sistema
	 -- r+, i- per anyadir o eliminar un repartidor
	 when 'r' | 'R' =>
	    -- si hi ha un bloquetjat es a dir hem eliminat un pero encara 
	    -- te feines a mitjes i no ha mort, esperam a q estigui mort
            if (estatR.gestio(estatR.num) = bloquetjat) then
               Ada.Text_IO.Put_Line("No se pot operar amb els repartidors, fins que no hagi cap bloquetjat.");
            else
   	       Ada.Text_IO.Get(ordre);
	       case ordre is
	          when '+' =>
	             if (estatR.num < maxRepartidors) then
		        estatR.inc;
		        estatR.gestio(estatR.num, viu);
		        repartidors(estatR.num) := new repartidor(character'val(estatR.num));
		     else
		        Ada.Text_IO.Put_Line("El nombre maxim de repartidors es " & integer'image(maxRepartidors)); 
		     end if;
	          when '-' =>
	             if (estatR.num > 1 ) then
		        estatR.gestio(estatR.num, bloquetjat);   
		     else 
		        Ada.Text_IO.Put_Line("El nombre minim de repartidors es 1.");
		     end if;
	          when others =>
	             Ada.Text_IO.Put_Line("Ordre Repartidors Incorrecta.");
	       end case;
            end if;
	 when others =>
	    Ada.Text_IO.Put_Line("Ordre incorrecta.");
      end case;
   end loop;

   -- imprimim l'estat del sistema i 'matam' tots els processos q estn vius
   imprimir;
   for i in 1..estatC.num loop
         abort cuiners(i).all;
   end loop;
   for i in 1..estatR.num loop
         abort repartidors(i).all;
   end loop;
   for i in 1..estatCl.num loop
         abort clients(i).all;
   end loop;
   abort encarregat.all;   
   
   Ada.Text_IO.Put_Line("Ara tot s'ha acabat.");
end pizzeria;
