program Snd_prac;                               {Nacimiento del programa}
	const
		Ed = 0.1;
	type
		partc = record							{Registro de las particulas}
				part: rect;
				acel: array[1..3] of real;
				velc: array[1..4] of real;
				fuel: array[1..4] of real;
				posn: array[1..4] of real;
			end;
		sist = array[1..5] of partc;		{Max. 5 particulas}
		bot = array[1..4] of rect;
		sld = array[1..2, 1..6] of rect;
		vsld = array[1..6] of real;
	var
		spart: sist;
		boton: bot;								{Rectangulo de los botones}
		slid: sld;									{		"				sliders}
		np: integer;
		mundo, area: rect;
		vsd: vsld;									{Valores de los sliders}


                    {*** Funciones y Procedimientos ***}

	function elev (num: real; pot: integer): real;
		var
			i: integer;
			aux: real;
	begin											{Multiplica un n¼ por si mismo, (eleva)}
	aux := 1;
	for i := 1 to pot do
		aux := aux * num;
	elev := aux;
	end;

	function taman (masa: real; punto: point): rect;
		var
			i: integer;
			z: real;
	begin											{Asigna tama–o particula segun masa}
	i := 0;
	z := masa;
	repeat
		i := i + 1;
		z := z * 10;
	until z >= 1;
	setrect(taman, (punto.h), (punto.v), (punto.h - i + 17), (punto.v - i + 17));
	end;

	procedure inic_sist (var sp: sist);
		var
			i, j: integer;
	begin											{Incializa el sistema de particulas}
	for i := 1 to 5 do
		begin
		with sp[i] do
			begin
			for j := 1 to 4 do
				begin
				acel[j] := 0;
				velc[j] := 0;
				fuel[j] := 0;
				posn[j] := 0;
				end;
			end;
		end;
	end;

	procedure inic_vsld (var sl: vsld);
		var
			i: integer;
	begin										{Inicializa el valor de los sliders}
	for i := 1 to 6 do
		sl[i] := 0.0000000001;
	end;

	procedure inic_bot (var bt: bot);
		var
			i, j, aux, auy: integer;
	begin										{Inic. rectangulos de los botones}
	for i := 1 to 4 do
		begin
		aux := 26;
		auy := 116;
		for j := 1 to (i - 1) do
			begin
			aux := aux + 116;
			auy := auy + 116;
			end;
		setrect(bt[i], aux, 263, auy, 300);
		end;
	end;

	procedure inic_slid (var sd: sld);
		var
			i, j, aux, auy: integer;
	begin										{Inic. rectangulos de los sliders}
	for i := 1 to 6 do
		begin
		aux := 25;
		auy := 47;
		for j := 1 to (i - 1) do
			begin
			aux := aux + 37;
			auy := auy + 37;
			end;
		setrect(sd[1, i], 26, aux, 127, auy);
		setrect(sd[2, i], 26, aux, 26, auy);
		end;
	end;

	procedure nombres;
	begin										{En el nombre de las cosas...}
	textfont(Courier);
	textsize(7);
	moveto(32, 16);
	writedraw('-10');
	moveto(32, 53);
	writedraw('-10');
	moveto(32, 127);
	writedraw('-10');
	moveto(32, 201);
	writedraw('-10');
	textsize(10);
	moveto(26, 24);
	writedraw('10');
	moveto(122, 24);
	writedraw('1');
	moveto(28, 45);
	writedraw('MASA');
	moveto(26, 61);
	writedraw('10');
	moveto(122, 61);
	writedraw('1');
	moveto(28, 82);
	writedraw('I. TIEMPO');
	moveto(26, 98);
	writedraw('1');
	moveto(120, 98);
	writedraw('115');
	moveto(28, 119);
	writedraw('D. EQUILIBRIO');
	moveto(26, 135);
	writedraw('10');
	moveto(122, 135);
	writedraw('1');
	moveto(28, 156);
	writedraw('DESPLAZAMIENTO');
	moveto(26, 172);
	writedraw('0');
	moveto(120, 172);
	writedraw('0.1');
	moveto(28, 193);
	writedraw('E. TERMICA');
	moveto(26, 209);
	writedraw('10');
	moveto(122, 209);
	writedraw('1');
	moveto(28, 230);
	writedraw('VISCOSIDAD');
	moveto(28, 298);
	writedraw('CREAR');
	moveto(144, 298);
	writedraw('MOVER');
	moveto(260, 298);
	writedraw('BORRAR');
	moveto(376, 298);
	writedraw('SALIR');
	end;

	procedure pantalla (bt: bot; sd: sld; md: rect);
		var
			i: integer;
	begin													{Todos tenemos algo de artista...}
	showdrawing;
	setrect(area, 30, 25, 550, 350);
	setdrawingrect(area);
	for i := 1 to 4 do
		begin
		framerect(bt[i]);
		framerect(sd[1, i]);
		end;
	framerect(sd[1, 5]);
	framerect(sd[1, 6]);
	framerect(mundo);
	nombres;
	end;

	procedure calc_fuel (pan, nm: integer; sl: vsld; var sp: sist);
		var
			i: integer;
			f, aux, r, x, y: real;
	begin										{Es como gasolina, pura energia...}
	sp[nm].fuel[1] := 0;
	sp[nm].fuel[2] := 0;
	for i := 1 to pan do					{Para todas las particulas}
		if i <> nm then						{excepto ella misma}
			begin
			x := sp[i].posn[3] - sp[nm].posn[3];
			y := sp[i].posn[4] - sp[nm].posn[4];
			r := sqrt((x * x) + (y * y));
			x := x / r;
			y := y / r;
                                                    {Formula F}
			aux := (elev(sl[3], 12) / elev(r, 13)) - (elev(sl[3], 6) / elev(r, 7));
			f := -12 * (Ed - sl[5]) * aux;
                                                    {Suma de las fuerzas}
			sp[nm].fuel[1] := sp[nm].fuel[1] + (f * x);
			sp[nm].fuel[2] := sp[nm].fuel[2] + (f * y);
			end;
	end;

	procedure calc_acel (num: integer; sl: vsld; var sp: sist);
	begin											{Esas peque–as cosas que mueven el mundo}
	with sp[num] do
		begin
		acel[1] := (fuel[1] / acel[3]);
		acel[2] := (fuel[2] / acel[3]);
		end;
	end;

	procedure calc_velc (num: integer; sl: vsld; var sp: sist);
	begin										{Velocidad, velocidad, siempre velocidad...}
	with sp[num] do
		begin
		velc[3] := velc[1];
		velc[4] := velc[2];
		velc[1] := velc[3] + (sl[2] * acel[1]);
		velc[2] := velc[4] + (sl[2] * acel[2]);
		velc[1] := velc[1] * sl[4];			{Reduccion segun limite de desplazamiento}
		velc[2] := velc[2] * sl[4];
		if velc[1] > 115 then					{No queremos multas, ehhhh}
			velc[1] := 115;
		if velc[1] < -115 then
			velc[1] := -115;
		if velc[2] > 115 then
			velc[2] := 115;
		if velc[2] < -115 then
			velc[2] := -115;
		if fuel[3] = 1 then					{Y si cambiamos de sentido o direccion...}
			begin
			velc[1] := -velc[1];
			end;
		if fuel[4] = 1 then
			begin
			velc[2] := -velc[2];
			end;
		end;
	end;

	procedure calc_visc (num: integer; sl: vsld; var sp: sist);
		var
			x, y: real;
	begin									{Nunca corras sin frenos...}
	with sp[num] do
		begin
		x := sl[6] * velc[1];
		y := sl[6] * velc[2];
		fuel[1] := fuel[1] - x;
		fuel[2] := fuel[2] - y;
		end;
	end;

	procedure calc_posn (num: integer; sl: vsld; var sp: sist);
		var
			x, y: real;
			z, v: integer;
			p: point;
			aur: rect;
	begin								{En donde estamos, que somos???}
	with sp[num] do
		begin
		posn[3] := posn[1];
		posn[4] := posn[2];
		posn[1] := posn[3] + ((sl[2] * (velc[1] + velc[3])) / 2);
		posn[2] := posn[4] + ((sl[2] * (velc[2] + velc[4])) / 2);
		p.h := trunc(posn[1]);
		p.v := trunc(posn[2]);
		setrect(aur, 232, 10, 445, 223);
		if not ptinrect(p, aur) then		{No queremos ser extraterrestres, Àverdad?}
			begin
			if p.h > 445 then
				begin
				if fuel[3] = 1 then
					fuel[3] := 0
				else
					fuel[3] := 1;
				z := p.h - 445;
				posn[1] := 445 - z;
				end;
			if p.h < 232 then
				begin
				if fuel[3] = 1 then
					fuel[3] := 0
				else
					fuel[3] := 1;
				z := 232 - p.h;
				posn[1] := 232 + z;
				end;
			if p.v > 223 then
				begin
				if fuel[4] = 1 then
					fuel[4] := 0
				else
					fuel[4] := 1;
				z := p.v - 223;
				posn[2] := 223 - z;
				end;
			if p.v < 10 then
				begin
				if fuel[4] = 1 then
					fuel[4] := 0
				else
					fuel[4] := 1;
				z := 10 - p.v;
				posn[2] := 10 + z;
				end;
			end;
		end;
	end;

	procedure dibuja (num: integer; var sp: sist);
		var
			p: point;
			aux: rect;
	begin									{Mejor... indicamos nuestras posicion.}
	with sp[num] do
		begin
		p.h := trunc(posn[3]);
		p.v := trunc(posn[4]);
		if ptinrect(p, mundo) then
			begin
			aux := taman(acel[3], p);
			if not equalrect(part, aux) then
				begin
				eraseoval(part);
				part := aux;
				paintoval(part);
				framerect(mundo);
				end;
			end;
		end;
	end;

	procedure sist_part (num: integer; sl: vsld; var sp: sist);
		var
			p: integer;
	begin							{Todas las formulas, para saber que existimos}
	for p := 1 to num do		{Para todas las particulas}
		begin
		calc_fuel(num, p, sl, sp);
		calc_acel(p, sl, sp);
		calc_velc(p, sl, sp);
		calc_visc(p, sl, sp);
		calc_acel(p, sl, sp);
		calc_velc(p, sl, sp);
		calc_posn(p, sl, sp);
		dibuja(p, sp);
		end;
	end;

	procedure crear (bt: bot; md: rect; var num: integer; var sp: sist; sl: vsld);
		var
			p: point;
			fin: boolean;
			r: rect;
			i: integer;
			z: real;
	begin										{La creacion es algo natural,...}
	fin := false;
	repeat
		repeat
			sist_part(num, sl, sp);		{Tendremos que seguir en movimiento}
		until button;
		getmouse(p);
		if ptinrect(p, md) then				{Llamando a la Tierra, Tierra}
			begin
			if (sl[1] <> 0) and (num <> 5) then			{Existen limites}
				begin
				num := num + 1;									{Cuantos somos o seremos}
				setrect(r, 258, 239, 464, 260);
				eraserect(r);
				moveto(258, 248);
				writedraw('Particulas : ');
				writedraw(num);
				sp[num].posn[1] := p.h;						{Nuevas asignaciones}
				sp[num].posn[2] := p.v;
				sp[num].posn[3] := p.h;
				sp[num].posn[4] := p.v;
				sp[num].acel[3] := sl[1];
				sp[num].part := taman(sl[1], p);
				paintoval(sp[num].part);
				end;
			fin := true;
			end;
		if ptinrect(p, bt[4]) then						{Y si queremos salir de otra manera}
			fin := true;
	until fin;
	end;

	procedure mover (bt: bot; md: rect; num: integer; var sp: sist; sl: vsld);
		var
			p, h: point;
			fin: boolean;
			i, x: integer;
	begin								{Existe tambien la capacidad de teletransportacion...}
	fin := false;
	repeat
		repeat														{Seguimos en movimiento}
			sist_part(num, sl, sp);
		until button;
		getmouse(p);
		for i := 1 to num do
			begin
			if ptinrect(p, sp[i].part) then				{Controlamos que sea una particula}
				begin
				h := p;
				repeat
					if not equalpt(p, h) then
						begin
						if ptinrect(p, md) then
							begin
							eraseoval(sp[i].part);
							sp[i].part := taman(sp[i].acel[3], p);
							paintoval(sp[i].part);
							sp[i].posn[1] := p.h;
							sp[i].posn[2] := p.v;
							sp[i].posn[3] := p.h;
							sp[i].posn[4] := p.v;
							sp[i].fuel[1] := 0;
							sp[i].fuel[2] := 0;
							sp[i].fuel[3] := 0;
							sp[i].fuel[4] := 0;
							sp[i].velc[1] := 0;
							sp[i].velc[2] := 0;
							sp[i].velc[3] := 0;
							sp[i].velc[4] := 0;
							sist_part(num, sl, sp);	{La teletransportacion tiene sus influencias}
							end;
						h := p;
						end;
					getmouse(p)
				until not button;
				fin := true;
				end;
			end;
		if ptinrect(p, bt[4]) then				{He aqui, la otra salida}
			fin := true;
	until fin;
	end;


	procedure borrar (bt: bot; md: rect; var num: integer; var sp: sist; sl: vsld);
		var
			p: point;
			fin: boolean;
			r: rect;
			i, j: integer;
	begin								{Y lo que deja de existir tambien es natural}
	fin := false;
	repeat
		repeat
			sist_part(num, sl, sp);				{Cada loco con su locura, he aqui movimiento}
		until button;
		getmouse(p);
		for i := 1 to num do
			begin
			if ptinrect(p, sp[i].part) then
				begin
				eraseoval(sp[i].part);				{El borrar tambien tiene su arte}
				if i <> num then
					for j := i to (num - 1) do
						sp[i] := sp[i + 1];
				for j := 1 to 4 do			{Al dejar de existir, sus valores se han ido con el}
					begin
					sp[num].acel[j] := 0;
					sp[num].velc[j] := 0;
					sp[num].fuel[j] := 0;
					sp[num].posn[j] := 0;
					end;
				num := num - 1;							{Queremos seguir sabiendo cuantos somos}
				setrect(r, 258, 239, 464, 260);
				eraserect(r);
				moveto(258, 248);
				writedraw('Particulas : ');
				writedraw(num);
				fin := true;
				end;
			end;
		if ptinrect(p, bt[4]) then				{Parece ser que siempre hay + salidas}
			fin := true;
	until fin;
	end;

	procedure opciones (bt: bot; sd: sld; sp: sist; md: rect; np: integer; sl: vsld);
		var
			p: point;
			i, j, aux, auy, x, c, rt: integer;
			sol: real;
			fin: boolean;
			r, aur: rect;
	begin									{Siempre hay un jefe, o el cuerpo del programa}
	fin := false;
	repeat
		repeat
			sist_part(np, sl, sp);		{La mente calcula el lugar de todos en nuestro destino}
		until button;
		getmouse(p);					{Ring,...,ring...}
		i := 1;
		repeat							{Preguntamos si es para algun slider}
			if ptinrect(p, sd[1, i]) then
				begin
				aux := 25;
				auy := 47;
				for j := 1 to (i - 1) do
					begin
					aux := aux + 37;
					auy := auy + 37;
					end;
				setrect(aur, 26, aux, p.h, auy);
				setrect(r, 130, aux, 228, auy);
				if not equalrect(aur, sd[2, i]) then		{Ha cambiado algo?}
					begin
					invertrect(sd[2, i]);
					sd[2, i] := aur;
					invertrect(sd[2, i]);
					framerect(sd[1, i]);
					moveto(130, auy);
					eraserect(r);
					x := p.h - 26;
					if i = 3 then							{No todos tienen los mismos valores}
						x := (x * 115) div 100;
					c := x div 10;
					rt := x mod 10;
					if rt = 0 then
						rt := 1;
					case c of								{Desde 10elev10 hasta 10elev0}
					0: 
						sol := rt / 1000000000;
					1: 
						sol := rt / 100000000;
					2: 
						sol := rt / 10000000;
					3: 
						sol := rt / 1000000;
					4: 
						sol := rt / 100000;
					5: 
						sol := rt / 10000;
					6: 
						sol := rt / 1000;
					7: 
						sol := rt / 100;
					8: 
						sol := rt / 10;
					9: 
						sol := rt;
					10: 
						sol := rt * 10;
					11: 
						sol := rt * 100;
					end;
					sol := sol / 10;
					case i of
					1: 						{Es algo llamado masa pero realmente es 'grasa'}
						begin
						sl[1] := sol;
						if x = 100 then
							sl[1] := 1;
						if x = 0 then
							sl[1] := 0.0000000001;
						writedraw(sl[1]);
						writedraw(' Kg.');
						i := 7;
						end;
					2: 						{El tiempo en el nacemos para poder morir}
						begin
						sl[2] := sol;
						if x = 100 then
							sl[2] := 1;
						if x = 0 then
							sl[2] := 0.0000000001;
						writedraw(sl[2]);
						writedraw(' s.');
						i := 7;
						end;
					3: 						{Equilibrio, esa cosa que hace que no nos 'cagamos'}
						begin
						sl[3] := x;
						if x = 0 then
							sl[3] := 1;
						writedraw(sl[3]);
						writedraw(' m.');
						i := 7;
						end;
					4: 						{Limites, normas, siempre existen en el espacio}
						begin
						sl[4] := sol;
						if x = 100 then
							sl[4] := 1;
						if x = 0 then
							sl[4] := 0.0000000001;
						writedraw(sl[4]);
						writedraw(' m.');
						i := 7;
						end;
					5: 					{Energia es lo que hace que estemos unidos o pasemos de todo}
						begin
						sl[5] := (x * Ed) / 100;
						if x = 100 then
							sl[5] := Ed;
						if x = 0 then
							sl[5] := 0;
						writedraw(sl[5]);
						writedraw(' J.');
						i := 7;
						end;
					6: 						{Esa cosa que sirve para parar, ahh si frenos}
						begin
						sl[6] := sol;
						if x = 100 then
							sl[6] := 1;
						if x = 0 then
							sl[6] := 0.0000000001;
						writedraw(sl[6]);
						writedraw(' Kg/s.');
						end;
					end;
					end;
				end;
			i := i + 1;
		until i >= 7;							{Tenemos que preguntar por todos los sliders}
		i := 1;
		repeat									{y si la llamada es para un boton}
			if ptinrect(p, bt[i]) then
				case i of
				1: 									{La creacion no creo que fuera como esto}
					begin
					invertrect(bt[i]);
					setrect(aur, 232, 10, 445, 223);
					crear(bt, aur, np, sp, sl);
					invertrect(bt[i]);
					i := 5;
					end;
				2: 									{Teletrasnsportacion, necesitamos de voluntad}
					begin
					invertrect(bt[i]);
					setrect(aur, 232, 10, 445, 223);
					mover(bt, aur, np, sp, sl);
					invertrect(bt[i]);
					i := 5;
					end;
				3: 									{Dejar de existir, pero es + facil decir 'Borrar'}
					begin
					invertrect(bt[i]);
					borrar(bt, md, np, sp, sl);
					invertrect(bt[i]);
					i := 5;
					end;
				4: 									{Aunque existen + salidas, esta es la correcta}
					begin
					invertrect(bt[i]);
					fin := true;
					end;
				end;
			i := i + 1;
		until i >= 5;								{Hemos preguntado por todos los botones}
	until fin;
	hideall;
	end;

                    {*** Programa Principal ***}
begin
np := 0;														{Inicializaciones}
inic_sist(spart);
inic_vsld(vsd);
inic_bot(boton);
inic_slid(slid);
setrect(mundo, 230, 8, 460, 238);					{Dise–o pantalla}
pantalla(boton, slid, mundo);
opciones(boton, slid, spart, mundo, np, vsd);		{Cuerpo del programa}

end.															{Muerte del programa...}
