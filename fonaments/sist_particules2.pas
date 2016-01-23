program particules;
	const
		N = 5;      {total particules que podrem tenir}
		ED = 0.1;   {energía de dissociació}
		RM = 3;	{Uitat món}
	type
		Dadesparticula = record
				Acceleracio: array[1..3] of real;
				Velocitat: array[1..4] of real;
				Forza: array[1..4] of real;         {ESTRUCTURA DE DADES }
				Posicio: array[1..4] of real;
			end;
		NumeroParticules = array[1..N] of Dadesparticula;
	var
		opcio: char;
		m1, dt1, ro1, s1, mu1, b1: real;
		p1: point;
		np1: integer;
		Sistema1: NumeroParticules;
		unitariX, unitariY: integer;

{DINS LA TUPLA Dadesparticula HI GORDAM LES DADES DE CADA PARTICULA}
{Dins Acceleracio[1..2] hi gordam la acceleració de les components x,y respectivamemt, mentre }
{que dins Acceleracio[3] hi ha la massa de cada partícula}
{Dins Velocitat,Forza i Posicio[1..4] hi guardam respectivamemt }
{la velocitat, força i posició de cada particula essent : per a la Posicio i la }
{velocitat de [1..2]:= components x,y de la velocitat i la posicio a l'instat(tk+1)}
{i [3..4]:=components x,y de la velocitat i la posicio a l'instant(tk)}
{mentre que per la força [1..2]:= Fµ i [3..4]:=Fv de x,y}

{les variables globals mes importants son les seguents:}
{opcio=conté la opció que hem triat:crear, moure, borrar o sortir}
{ m1..ro1..b1=son els sliders corresponents, m..ro..b}
{Sistema1: es la matriu on hi posam tots els resultats, calculs i dades de les partícules}


{ EL SEGUENT PROCEDIMENT ENS DIBUIXA LA PANTALLA}
	procedure Dibuixa_pantalla;
		var
			Box: rect;
	begin
	showdrawing;
	Pensize(5, 5);
	Box.top := 0;
	Box.left := 0;
	Box.bottom := 342;
	Box.right := 512;
	SetDrawingRect(Box);			{Definim la finestra de dibuix}
	FrameRect(40, 240, 280, 480);	{Definim el quadrat on ens apareixeràn les partícules}
	Pensize(2, 2);
	TextFont(Courier);
	TextFace([Bold]);
	MoveTo(45, 43);
	WriteDraw('10');			{Posam el rang de valors corresponents als Sliders}
	MoveTo(45, 78);
	WriteDraw('10');
	MoveTo(45, 113);
	WriteDraw('10');
	MoveTo(45, 148);
	WriteDraw('1');
	MoveTo(45, 183);
	WriteDraw('0');
	MoveTo(45, 218);
	WriteDraw('10');
	MoveTo(158, 43);
	WriteDraw('1');
	MoveTo(158, 78);
	WriteDraw('1');
	MoveTo(152, 113);
	WriteDraw('15');
	MoveTo(140, 148);
	WriteDraw('10');
	MoveTo(146, 183);
	WriteDraw('0´1');
	MoveTo(158, 218);
	WriteDraw('1');
	TextSize(18);
	MoveTo(20, 60);
	WriteDraw('m');
	MoveTo(18, 95);
	TextSize(15);
	WriteDraw('∆t');
	MoveTo(18, 130);
	TextSize(18);
	WriteDraw('r');
	MoveTo(28, 132);
	TextSize(9);
	TextFace([Bold]);
	WriteDraw('0');
	TextSize(18);
	MoveTo(20, 165);
	WriteDraw('S');
	MoveTo(20, 200);
	WriteDraw('µ');
	MoveTo(20, 235);
	WriteDraw('b');
	TextSize(8);
	MoveTo(55, 38);
	WriteDraw('-10');
	MoveTo(55, 73);
	WriteDraw('-10');
	MoveTo(55, 108);
	WriteDraw('-10');
	MoveTo(152, 143);
	WriteDraw('-10');
	MoveTo(55, 213);
	WriteDraw('-10');
	FrameRect(45, 45, 65, 165);		{Dibuixam els Sliders}
	FrameRect(80, 45, 100, 165);
	FrameRect(115, 45, 135, 165);
	FrameRect(150, 45, 170, 165);
	FrameRect(185, 45, 205, 165);
	FrameRect(220, 45, 240, 165);
	PenSize(4, 4);
	FrameOval(250, 15, 277, 95);		{Dibuixam els botons}
	FrameOval(287, 15, 314, 95);
	FrameOval(250, 105, 277, 185);
	FrameOval(287, 105, 314, 185);
	Pensize(1, 1);
	FrameRect(295, 350, 320, 495);
	TextSize(10);
	MoveTo(37, 266);
	WriteDraw('Crear');
	MoveTo(37, 303);
	WriteDraw('Moure');
	MoveTo(125, 266);
	WriteDraw('Borrar');
	MoveTo(125, 303);
	WriteDraw('Sortir');
	MoveTo(360, 310);
	WriteDraw('Nº de particules: ');
	end;


{PROCEDIMEMT QUE INICIALITZA LES DADES DE TOTES LES PARTICULES QUE PODREM TENIR}
	procedure Inici_Dades_particules (var Sistema: NumeroParticules);
		var
			i, j: integer;
	begin
	for i := 1 to N do (* per les 8 particules*)
		begin
		with Sistema[i] do
			begin
			for j := 1 to 4 do
				begin
				Acceleracio[j] := 0;
				Velocitat[j] := 0;
				Forza[j] := 0;
				Posicio[j] := 0;
				end;
			end;
		end;
	end;

{EL SEGUENT PROCEDIMENT ENS INICIALITZA EL VALOR DELS SLIDERS}
	procedure Inicialitzacio_Slaiders (var m, dt, ro, s, mu, b: real);
	begin
	TextSize(10);
	TextFace([bold]);
	TextFont(Courier);
	m := 0.018;
	MoveTo(163, 62);
	Writedraw(m);
	FillRect(48, 48, 62, 50, dkgray);
	dt := 1.0e-10;
	MoveTo(163, 97);
	WriteDraw(dt);
	ro := 1.0e-10;
	MoveTo(163, 132);
	WriteDraw(ro);
	s := 1;
	MoveTo(163, 167);
	WriteDraw(s);
	mu := 0;
	MoveTo(163, 202);
	WriteDraw(mu);
	b := 1.0e-10;
	MoveTo(163, 237);
	WriteDraw(b);
	end;



{LA SEGUENT FUNCIO ENS ELEVA UN Nº A UN EXPONENT}
	function elevar (base, exp: real): real;
		var

			cont, product: real;
	begin

	cont := 1;
	product := 1;
	repeat
		product := product * base;
		cont := cont + 1;
	until cont > exp;
	elevar := product;
	end;


{EL SEGUENT PROCEDIMENT CALCULA LA FORÇA Fµ}
	procedure Fmu (Nparticules, PartActual: integer; mu, ro: real; var Sistema: NumeroParticules);
		var
			i: integer;
			f, r, x, y: real;
	begin
	Sistema[PartActual].Forza[1] := 0;     {Inicialitzam les components x,y de la força}
	Sistema[PartActual].Forza[2] := 0;
	for i := 1 to Nparticules do
		begin
		if i <> PartActual then
			begin
			x := Sistema[PartActual].Posicio[3] - Sistema[i].Posicio[3];
			y := Sistema[PartActual].Posicio[4] - Sistema[i].Posicio[4];
			r := sqrt((x * x) + (y * y));
			x := x / r;
			y := y / r;
			f := -12 * (ED - mu) * ((elevar((ro), 12) / elevar((r), 13)) - (elevar((ro), 6) / elevar((r), 7)));
			Sistema[PartActual].forza[1] := Sistema[PartActual].forza[1] + (f * x);
			Sistema[PartActual].forza[2] := Sistema[PartActual].forza[2] + (f * y);
			end;
		end;
	end;


{PROCEDIMENT PER CALCULAR L'ACCELERACIO}
	procedure Acelera (PartActual: integer; var Sistema: NumeroParticules);
	begin

	with Sistema[PartActual] do
		begin
		Acceleracio[1] := Forza[1] / Acceleracio[3];
		Acceleracio[2] := Forza[2] / Acceleracio[3];
		end;
	end;


{PROCEDIMENT PER CALCULA LA VELOCITAT}
	procedure Veloci (PartActual: integer; dt: real; var Sistema: NumeroParticules);

	begin
	with Sistema[PartActual] do
		begin
		Velocitat[3] := Velocitat[1];
		Velocitat[4] := Velocitat[2];
		Velocitat[1] := Velocitat[3] + (dt * Acceleracio[1]);
		Velocitat[2] := Velocitat[4] + (dt * Acceleracio[2]);
		if (Velocitat[1] > 0) and (Velocitat[1] > 50000000000000) then	{Limitació de la velocitat}
			velocitat[1] := 50000000000000;
		if (Velocitat[1] < 0) and (Velocitat[1] < (-50000000000000)) then
			Velocitat[1] := -50000000000000;
		if (Velocitat[2] > 0) and (Velocitat[2] > 50000000000000) then
			velocitat[2] := 50000000000000;
		if (Velocitat[2] < 0) and (Velocitat[2] < (-50000000000000)) then
			Velocitat[2] := -50000000000000;
		end;
	end;


{PROCEDIMENT PER CALCULAR LA VISCOSITAT}
	procedure Viscosi (PartActual: integer; b: real; var Sistema: NumeroParticules);
	begin
	with Sistema[PartActual] do
		begin
		Forza[3] := (-b) * Velocitat[1];
		Forza[4] := (-b) * Velocitat[2];
		Forza[1] := Forza[1] + Forza[3];
		Forza[2] := Forza[2] + Forza[4];
		end;
	end;

{PROCEDIMENT PER PASSAR DEL MON A LA PANTALLA}
	procedure Conversio (PartActual: integer; var E1, E2, E3, E4: integer; var Sistema: NUmeroParticules);
		var
			D1, D2, D3, D4: real;
	begin
	with Sistema[PartActual] do
		begin
		D1 := Posicio[1];
		D2 := Posicio[2];
		D3 := Posicio[3];
		D4 := Posicio[4];
		if (D1 > 0) and (D2 > 0) then			{Miram a quin quadrat del món està la partícula}
			begin							{per després mirar a quin lloc de la pantalla correspòn}
			D1 := trunc(360 + (Posicio[1] * 4));  {El punt (0,0) corresponent a la pantalla es el punt (360,160)}
			D2 := trunc(160 - (Posicio[2] * 4));
			end;
		if (D1 < 0) and (D2 < 0) then
			begin
			D1 := trunc(360 + (Posicio[1] * 4));
			D2 := trunc(160 - ((Posicio[2]) * 4));
			end;
		if (D1 > 0) and (D2 < 0) then
			begin
			D1 := trunc(360 + (Posicio[1] * 4));
			D2 := trunc(160 - ((Posicio[2]) * 4));
			end;
		if (D1 < 0) and (D2 > 0) then
			begin
			D1 := trunc(360 + (Posicio[1] * 4));
			D2 := trunc(160 - (Posicio[2] * 4));
			end;
		if (D3 > 0) and (D4 > 0) then
			begin
			D3 := trunc(360 + (Posicio[3] * 4));
			D4 := trunc(160 - (Posicio[4] * 4));
			end;
		if (D3 < 0) and (D4 < 0) then
			begin
			D3 := trunc(360 + (Posicio[3] * 4));
			D4 := trunc(160 - (Posicio[4] * 4));
			end;
		if (D3 > 0) and (D4 < 0) then
			begin
			D3 := trunc(360 + (Posicio[3] * 4));
			D4 := trunc(160 - (Posicio[4] * 4));
			end;
		if (D3 < 0) and (D4 > 0) then
			begin
			D3 := trunc(360 + (Posicio[3] * 4));
			D4 := trunc(160 - (Posicio[4] * 4));
			end;
		E1 := trunc(D1);
		E2 := trunc(D2);
		E3 := trunc(D3);
		E4 := trunc(D4);
		end;
	end;

{AQUEST PROCEDIMENT ENS PASSA DE LA PANTALLA AL MON}
	procedure ConversioINV (PartActual: integer; X, Y: integer; var Sistema: NumeroParticules);
	begin
	with Sistema[PartActual] do			{Aquest procediment fa la operació inversa de l´anterior}
		begin
		if (X >= 360) and (Y <= 160) then	{Miram el quadran on está la partícula en la pantalla}
			begin						{per després passar aquesta posició al món real}
			Posicio[3] := (X - 360) / 4;
			Posicio[4] := (160 - Y) / 4;
			Posicio[1] := Posicio[3];
			Posicio[2] := Posicio[4];
			end;
		if (X < 360) and (Y > 160) then
			begin
			Posicio[3] := -((360 - X) / 4);
			Posicio[4] := -((Y - 160) / 4);
			Posicio[1] := Posicio[3];
			Posicio[2] := Posicio[4];
			end;
		if (X > 360) and (Y > 160) then
			begin
			Posicio[3] := (X - 360) / 4;
			Posicio[4] := -((Y - 160) / 4);
			Posicio[1] := Posicio[3];
			Posicio[2] := Posicio[4];
			end;
		if (X < 360) and (Y < 160) then
			begin
			Posicio[3] := -((360 - X) / 4);
			Posicio[4] := (160 - Y) / 4;
			Posicio[1] := Posicio[3];
			Posicio[2] := Posicio[4];
			end;
		end;
	end;

{PROCEDIMENT QUE ENS CALCULA LA NOVA POSICIO D'UNA PARTICULA I LA DIBUIXA A AQUESTA NOVA POSICIO}
	procedure Posici (PartActual: integer; dt, s: real; var Sistema: NumeroParticules);
		var
			x1, x2, x3, x4: real;
			D1, D2, D3, D4: real;
			E1, E2, E3, E4: integer;
			aux: integer;
			z: real;
			x, y: real;
			mon: rect;
			w, v: point;
			PX, PY: real;
	begin
	mon.top := 40;
	mon.Left := 240;
	mon.Bottom := 280;
	mon.right := 480;
	with Sistema[PartActual] do
		begin
		if np1 >= 1 then (*SI HI HA UNA O MES PARTICULES*)
			begin
			unitariX := 1;
			unitariY := 1;
			Posicio[3] := Posicio[1];		{Antes de calcular la posició nova, igualam la posició (tk) a la posició (tk+1)}
			Posicio[4] := Posicio[2];
			PX := (dt * (Velocitat[1] + Velocitat[3]) / 2);
			PY := (dt * (Velocitat[2] + Velocitat[4]) / 2);
			if abs(PX) > s then			{Aquí es on feim la limitació de desplaçament}
				begin
				if PX > 0 then
					PX := s;
				if PX < 0 then
					PX := -s;
				end;
			if abs(PY) > s then
				begin
				if PY > 0 then
					PY := s;
				if PY < 0 then
					PY := -s;
				end;
			Posicio[1] := (Posicio[3] + PX);
			Posicio[2] := (Posicio[4] + PY);
			aux := round(Acceleracio[3] * 10);
			x1 := Posicio[1];
			x2 := Posicio[2];
			x3 := Posicio[3];
			x4 := Posicio[4];
			if x2 > (30 - 1.25) then
				begin			     {Controlam que les partícules no surtin de l'espai món}
				z := (x2 - (30 - 1.25));
				Posicio[2] := ((30 - 1.25) - z);
				unitariY := -1;
				Velocitat[2] := Velocitat[2] * unitariY;  {Canviam la direcció de la velocitat perque es produeixi el rebot}
				end;
			if (x2 - 1.25 - (aux / 4)) <= (-30 + 1.25) then
				begin
				z := (x2 - 1.25 - (aux / 4)) - (-30 + 1.25);
				Posicio[2] := ((-30 + 1.25) - z) + (1 + (aux / 4));(*posam +1, en lloc de 1.25 *)
				unitariY := -1;
				Velocitat[2] := Velocitat[2] * unitariY;
				end;
			if x1 < (-30 + 1.25) then
				begin
				z := (X1 - (-30 + 1.25));
				Posicio[1] := ((-30 + 1.25) - z);
				unitariX := -1;
				Velocitat[1] := Velocitat[1] * UnitariX;
				end;
			if (x1 + 1.25 + (aux / 4)) > (30 - 1.25) then
				begin
				z := (x1 + 1.25 + (aux / 4)) - (30 - 1.25);
				Posicio[1] := ((30 - 1.25) - z) - (1 + (aux / 4));
				unitariX := -1;
				Velocitat[1] := Velocitat[1] * UnitariX;
				end;
			Conversio(PartActual, E1, E2, E3, E4, Sistema);
			if (E1 <> E3) or (E2 <> E4) then
				EraseOval(E4, E3, E4 + 5 + aux, E3 + 5 + aux);    {borram la partícula que se mourà a una altre posició}
			w.h := E1;
			w.v := E2;
			v.h := E1 + 5 + aux;
			v.v := E2 + 5 + aux;
			if (PtinRect(w, mon)) and (PtinRect(v, mon)) then	  {si la nova posició està dins la pantalla la dibuixa}
				begin
				if (E1 <> E3) or (E2 <> E4) then
					PaintOval(E2, E1, E2 + 5 + aux, E1 + 5 + aux);
				end;
			Pensize(5, 5);
			FrameRect(40, 240, 280, 480);
			end;
		end;
	end;

{EL SEGUENT PROCEDIMENT ES EL QUE GESTIONA LES FORMULES QUE HEM DE CALCULAR, CRIDANT-LES QUAN TOCA}
	procedure Actualitzacio_Formules (N_Particules: integer; dt, ro, s, mu, b: real; var Sistema: NumeroParticules);
		var
			w: integer;
	begin
	for w := 1 to N_Particules do
		begin
		Fmu(N_Particules, w, mu, ro, Sistema);
		Acelera(w, Sistema);
		Veloci(w, dt, Sistema);
		Viscosi(w, b, Sistema);
		Acelera(w, Sistema);
		Veloci(w, dt, Sistema);
		Posici(w, dt, s, Sistema);
		end;
	end;


{AQUEST PROCEDIMENT ES EL QUE EMPRAM PER CANVIAR ELS VALORS ALS SLIDERS, I PER MIRAR LA OPCIO}
{QUE HEM TRIAT (crear, moure, borrar o sortir) }
	procedure Menu_Sliders (var menu: char; var m, dt, ro, s, mu, b: real);
		var
			x: point;
			j, i, valoraux: integer;
			saux: real;
			valor: real;
	begin
	repeat							{Miram si volem crear particula}
		GetMouse(x);
		if ((Button) and ((x.h >= 15) and (x.v >= 250)) and ((x.h <= 95) and (x.v <= 277))) then
			begin
			InvertOval(250, 15, 277, 95);
			repeat
			until not button;
			menu := 'C';					{mieram si volem moure particula}
			end
		else if ((Button) and ((x.h >= 15) and (x.v >= 287)) and ((x.h <= 95) and (x.v <= 314))) then
			begin
			InvertOval(287, 15, 314, 95);
			repeat
			until not button;
			menu := 'M';					{miram si volem borrar particula}
			end
		else if ((Button) and ((x.h >= 105) and (x.v >= 250)) and ((x.h <= 185) and (x.v <= 277))) then
			begin
			InvertOval(250, 105, 277, 185);
			repeat
			until not button;
			menu := 'B'					{miram si volem sotir del program}
			end
		else if ((Button) and ((x.h >= 105) and (x.v >= 287)) and ((x.h <= 185) and (x.v <= 314))) then
			begin
			InvertOval(287, 105, 314, 185);
			repeat
			until not button;
			for i := 1 to 3 do
				InvertOval(287, 105, 314, 185);
			PenSize(4, 4);
			FrameOval(287, 105, 314, 185);
			TextSize(10);
			TextFace([bold]);
			TextFont(Courier);
			MoveTo(83, 422);
			WriteDraw('Sortir');
			menu := 'S';					{slider m}
			end;
		if ((Button) and ((x.h >= 48) and (x.v >= 48)) and ((x.h <= 162) and (x.v <= 62))) then
			begin
			GetMouse(x);
			EraseRect(48, 48, 62, 162);
			FillRect(48, 48, 62, x.h, dkgray);
			valor := (x.h) - 48;
			if valor = 114 then
				m := 1
			else if valor = 0 then
				m := 0.0000000001
			else
				begin
				valoraux := trunc(valor);
				m := 0;
				for j := 1 to valoraux do
					m := m + 8.771929824e-3;
				end;
			if m < 0.018 then
				begin
				m := 0.018;
				FillRect(48, 48, 62, 50, dkgray);
				end;
			EraseRect(45, 166, 65, 236);
			MoveTo(163, 62);
			WriteDraw(m);				{slider ∆t}
			end;
		if ((Button) and ((x.h >= 48) and (x.v >= 83)) and ((x.h <= 162) and (x.v <= 97))) then
			begin
			GetMouse(x);
			EraseRect(83, 48, 97, 162);
			FillRect(83, 48, 97, x.h, dkgray);
			valor := (x.h) - 48;
			if valor = 114 then
				dt := 1
			else if valor = 0 then
				dt := 0.0000000001
			else
				begin
				valoraux := trunc(valor);
				dt := 0;
				for j := 1 to valoraux do
					dt := dt + 8.771929824e-3;
				end;
			EraseRect(80, 166, 100, 236);
			MoveTo(163, 97);
			WriteDraw(dt);				{slider ro}
			end;
		if ((Button) and ((x.h >= 48) and (x.v >= 118)) and ((x.h <= 162) and (x.v <= 132))) then
			begin
			GetMouse(x);
			EraseRect(118, 48, 132, 162);
			FillRect(118, 48, 132, x.h, dkgray);
			valor := (x.h) - 48;
			if valor = 114 then
				ro := 5 * RM
			else if valor = 0 then
				ro := 0.0000000001
			else
				begin
				valoraux := trunc(valor);
				ro := 0;
				for j := 1 to valoraux do
					ro := ro + 0.1315789474;
				end;
			EraseRect(115, 166, 135, 236);
			MoveTo(163, 132);
			WriteDraw(ro);				{slider s}
			end;
		if ((Button) and ((x.h >= 48) and (x.v >= 153)) and ((x.h <= 162) and (x.v <= 167))) then
			begin
			GetMouse(x);
			EraseRect(153, 48, 167, 162);
			FillRect(153, 48, 167, x.h, dkgray);
			valor := (x.h) - 48;
			if valor = 114 then
				begin
				saux := 1;
				s := 0.0000000001;
				end
			else if valor = 0 then
				begin
				saux := 0.0000000001;
				s := 1;
				end
			else
				begin
				valoraux := trunc(valor);
				saux := 0;
				s := 1;
				for j := 1 to valoraux do
					begin
					s := s - 8.771929824e-3;
					saux := saux + 8.771929824e-3;
					end;
				end;
			EraseRect(150, 166, 170, 236);
			MoveTo(163, 167);
			WriteDraw(s);				{slider µ}
			end;
		if ((Button) and ((x.h >= 48) and (x.v >= 188)) and ((x.h <= 162) and (x.v <= 202))) then
			begin
			GetMouse(x);
			EraseRect(188, 48, 202, 162);
			FillRect(188, 48, 202, x.h, dkgray);
			valor := (x.h) - 48;
			if valor = 114 then
				mu := 0.1
			else if valor = 0 then
				mu := 0
			else
				begin
				valoraux := trunc(valor);
				mu := 0;
				for j := 1 to valoraux do
					mu := mu + 8.771929825e-4;
				end;
			EraseRect(185, 166, 205, 236);
			MoveTo(163, 202);
			WriteDraw(mu);				{slider b}
			end;
		if ((Button) and ((x.h >= 48) and (x.v >= 223)) and ((x.h <= 162) and (x.v <= 237))) then
			begin
			GetMouse(x);
			EraseRect(223, 48, 237, 162);
			FillRect(223, 48, 237, x.h, dkgray);
			valor := (x.h) - 48;
			if valor = 114 then
				b := 1
			else if valor = 0 then
				b := 0.0000000001
			else
				begin
				valoraux := trunc(valor);
				b := 0;
				for j := 1 to valoraux do
					b := b + 8.771929824e-3;
				end;
			EraseRect(220, 166, 240, 236);
			MoveTo(163, 237);
			WriteDraw(b);
			end;
		Actualitzacio_Formules(np1, dt, ro, s, mu, b, Sistema1);
	until (menu = 'C') or (menu = 'M') or (menu = 'B') or (menu = 'S');
	end;


{PROCEDIMENT PER CREAR PARTICULES}
	procedure Crear_Particula (m: real; var p: point; np: integer; var npr: integer; var Sistema: NumeroParticules);
		var

			aux, nparticules: integer;
			ficrear: boolean;
			X, Y: INTEGER;
	begin
	ficrear := false;
	if np1 <= N - 1 then  		{posam N-1, perque aquí el np1, encara no està actualitzat}
		begin
		repeat
			Actualitzacio_Formules(np1, dt1, ro1, s1, mu1, b1, Sistema1);
			Getmouse(p);
			aux := round(m * 10);				{Si hem clickat dins la pantalla llavors pintam la nova partícula}
			if ((Button) and (((p.v - 4) > 40) and ((p.h - 4) > 240)) and (((p.v + 5 + aux + 4) < 280) and ((p.h + 5 + aux + 4) < 480))) then
				begin
				PaintOval(p.v, p.h, p.v + 5 + aux, p.h + 5 + aux);
				nparticules := nparticules + 1;
				EraseRect(300, 475, 310, 490);
				MoveTo(433, 310);
				Textsize(10);
				TextFace([Bold]);
				TextFont(Courier);
				WriteDraw(np + 1);
				npr := np + 1;
				ficrear := true;
				X := p.h;
				Y := p.v;
				with Sistema[npr] do
					begin
					ConversioINV(npr, X, Y, Sistema);
					Acceleracio[3] := m;
					end;
				end;
			EraseRect(280, 240, 290, 510);
		until ficrear;
		end
	else
		begin
		MoveTo(240, 290);
		EraseRect(280, 240, 290, 510);
		WriteDraw('NO ES PODEN CREAR MES PARTICULES');
		end;
	InvertOval(250, 15, 277, 95);
	PenSize(4, 4);
	FrameOval(250, 15, 277, 95);
	TextSize(10);
	TextFace([bold]);
	TextFont(Courier);
	MoveTo(37, 266);
	WriteDraw('Crear');
	end;


{PROCEDIMENT PER BORRAR PARTICILES}
	procedure Borrar_Particula (NParticules: integer; dt, ro, s, mu, b: real; var p: point; var PartBorrada: integer; var Sistema: NumeroParticules);
		var
			D1, D2, D3, D4: real;
			E1, E2, E3, E4: integer;
			i, j, aux: integer;
			Particula, ParticulaFut: Rect;
			Fborrar: boolean;
			Sistemaux: Dadesparticula;
	begin
	Fborrar := false;
	if Nparticules = 0 then
		begin
		EraseRect(280, 240, 290, 510);
		MoveTo(240, 290);
		TextSize(10);
		TextFace([Bold]);
		TextFont(Courier);
		WriteDraw('NO HI HA CAP PARTICULA');
		end;
	if Nparticules >= 1 then
		begin
		PartBorrada := np1;
		repeat
			Getmouse(p);
			for i := 1 to Nparticules do
				begin
				with Sistema[i] do
					begin
					Conversio(i, E1, E2, E3, E4, Sistema);
					aux := round(Acceleracio[3] * 10);
					Particula.Top := E4;
					Particula.Left := E3;
					Particula.Bottom := E4 + 5 + aux;
					Particula.Right := E3 + 5 + aux;
					ParticulaFut.Top := E2;
					ParticulaFut.Left := E1;
					ParticulaFut.Bottom := E2 + 5 + aux;
					ParticulaFut.Right := E1 + 5 + aux;		{Si hem clickat dins una partícula llavors la borram}
					if ((PtInRect(p, Particula) and Button) or (PtInRect(p, ParticulaFut) and Button)) then
						begin
						EraseRect(Particula);
						EraseRect(ParticulaFut);
						Fborrar := true;
						for j := 1 to 4 do
							begin
							Acceleracio[j] := 0;	{Inicialitzam les dades de la partícula borrada}
							Velocitat[j] := 0;
							Forza[j] := 0;
							Posicio[j] := 0;
							end;
						if i = 1 then
							begin					{Feim correr les taules de dades de les partícules}
							Sistemaux := Sistema[1];
							Sistema[1] := Sistema[2];
							Sistema[2] := Sistema[3];
							Sistema[3] := Sistema[4];
							Sistema[4] := Sistema[5];
							Sistema[5] := Sistemaux;
							end;
						if i = 2 then
							begin
							Sistemaux := Sistema[2];
							Sistema[2] := Sistema[3];
							Sistema[3] := Sistema[4];
							Sistema[4] := Sistema[5];
							Sistema[5] := Sistemaux;
							end;
						if i = 3 then
							begin
							Sistemaux := Sistema[3];
							Sistema[3] := Sistema[4];
							Sistema[4] := Sistema[5];
							Sistema[5] := Sistemaux;
							end;
						if i = 4 then
							begin
							Sistemaux := Sistema[4];
							Sistema[4] := Sistema[5];
							Sistema[5] := Sistemaux;
							end;
						PartBorrada := Nparticules - 1;
						EraseRect(300, 475, 310, 490);
						MoveTo(433, 310);
						TextSize(10);
						TextFace([Bold]);
						TextFont(Courier);
						WriteDraw(PartBorrada);
						EraseRect(280, 240, 290, 510);
						end;
					end;
				end;
			Actualitzacio_Formules(PartBorrada, dt, ro, s, mu, b, Sistema1);
		until Fborrar;
		end;
	FrameRect(40, 240, 280, 480);
	InvertOval(250, 105, 277, 185);
	PenSize(4, 4);
	FrameOval(250, 105, 277, 185);
	TextSize(10);
	TextFace([bold]);
	TextFont(Courier);
	MoveTo(125, 266);
	WriteDraw('Borrar');
	end;

{PROCEDIMENT PER MOURE PARTICULES}
	procedure Moure_Particula (NParticules: integer; dt, ro, s, mu, b: real; var p: point; var Sistema: NumeroParticules);
		var
			D1, D2, D3, D4: real;
			E1, E2, E3, E4: integer;
			FMoure: Boolean;
			i, j, aux: integer;
			Particula, Particulafut: Rect;
			Desplaz: Rect;
			X, Y: integer;
	begin
	FMoure := false;
	if Nparticules = 0 then
		begin
		EraseRect(280, 240, 290, 510);
		MoveTo(240, 290);
		TextSize(10);
		TextFace([Bold]);
		TextFont(Courier);
		WriteDraw('NO HI HA CAP PARTICULA');
		end;
	if NParticules >= 1 then
		begin
		repeat
			GetMouse(p);
			for i := 1 to Nparticules do
				begin
				with Sistema[i] do
					begin
					Conversio(i, E1, E2, E3, E4, Sistema);
					aux := round(Acceleracio[3] * 10);
					Particula.Top := E4;
					Particula.Left := E3;
					Particula.Bottom := E4 + 5 + aux;
					Particula.Right := E3 + 5 + aux;
					ParticulaFut.Top := E2;
					ParticulaFut.Left := E1;
					ParticulaFut.Bottom := E2 + 5 + aux;
					ParticulaFut.Right := E1 + 5 + aux;		{Si hem Clickat damunt una particula llavors la podrem moure}
					if ((PtInRect(p, Particula) and Button) or (PtInRect(p, ParticulaFut) and Button)) then
						begin
						EraseRect(Particula);
						EraseRect(ParticulaFut);
						repeat
							Actualitzacio_Formules(NParticules, dt, ro, s, mu, b, Sistema);
							for j := 1 to 4 do
								begin
								Velocitat[j] := 0;
								end;
							for j := 1 to 2 do
								Acceleracio[j] := 0;		{Podrem moure la partícula si el cursor està dins la pantalla}
							if ((Button) and (((p.v - 4) > 40) and ((p.h - 4) > 240)) and (((p.v + 5 + aux + 4) < 280) and ((p.h + 5 + aux + 4) < 480))) then
								begin
								Conversio(i, E1, E2, E3, E4, Sistema);
								EraseRect(E4, E3, E4 + 5 + aux, E3 + 5 + aux);
								EraseRect(E2, E1, E2 + 5 + aux, E1 + 5 + aux);
								EraseRect(p.v, p.h, p.v + 5 + aux, p.h + 5 + aux);
								GetMouse(p);
								SetRect(Desplaz, p.h, p.v, p.h + 5 + aux, p.v + 5 + aux);
								PaintOval(Desplaz);
								X := p.h;
								Y := p.v;
								ConversioInv(i, X, Y, Sistema);
								FMoure := true;
								end;
						until not button;
						end;
					end;
				end;
			Actualitzacio_Formules(NParticules, dt, ro, s, mu, b, Sistema);
		until FMoure;
		FrameRect(40, 240, 280, 480);
		end;
	InvertOval(287, 15, 314, 95);
	PenSize(4, 4);
	FrameOval(287, 15, 314, 95);
	TextSize(10);
	TextFace([bold]);
	TextFont(Courier);
	MoveTo(37, 303);
	WriteDraw('Moure');
	end;



			{PROGRAMA PRINCIPAL}



begin
Dibuixa_Pantalla;
np1 := 0;    			{Inicialitzam el numero de partícules a 0}
InitCursor;
Inici_Dades_Particules(Sistema1);
Inicialitzacio_Slaiders(m1, dt1, ro1, s1, mu1, b1);	{Inicialitzam els sliders}
repeat
	Menu_Sliders(opcio, m1, dt1, ro1, s1, mu1, b1);
	case opcio of
	'C': 
		begin				{canviam l'opcio perque no es quedi dins un bucle, posam W, pero}
		opcio := 'W';		{podriem posar qualsevol cosa distinta de 'C', 'M','B' o 'S' }
		Crear_Particula(m1, p1, np1, np1, Sistema1);
		end;
	'M': 
		begin
		opcio := 'W';
		Moure_Particula(np1, dt1, ro1, s1, mu1, b1, p1, Sistema1);
		end;
	'B': 
		begin
		opcio := 'W';
		Borrar_Particula(np1, dt1, ro1, s1, mu1, b1, p1, np1, Sistema1);
		end;
	'S': 
		HideAll;
	end;
until opcio = 'S';
end.