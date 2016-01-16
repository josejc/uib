unit Estadist;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, StdCtrls, Math;

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    Principal1: TMenuItem;
    Nuevo1: TMenuItem;
    Salir1: TMenuItem;
    Generacion1: TMenuItem;
    Poisson1: TMenuItem;
    Binomial1: TMenuItem;
    Exponencial1: TMenuItem;
    Normal1: TMenuItem;
    Khicuadrado1: TMenuItem;
    Comprobacion1: TMenuItem;
    Central1: TMenuItem;
    ListBox1: TListBox;
    procedure Salir1Click(Sender: TObject);
    procedure Nuevo1Click(Sender: TObject);
    procedure Poisson1Click(Sender: TObject);
    procedure Binomial1Click(Sender: TObject);
    procedure Exponencial1Click(Sender: TObject);
    procedure Normal1Click(Sender: TObject);
    procedure Comprobacion1Click(Sender: TObject);
    procedure Central1Click(Sender: TObject);
    procedure Khicuadrado1Click(Sender: TObject);
  private
    { Private declarations }
  public

  end;

  fichero = file of char;

  t_pun=^t_node;
  t_node=record
     rX, rK: real;
     seg:t_pun;
  end;
  llista=t_pun;
  posicio=t_pun;

  procedure init (var L:llista);
  function primer (L:llista):posicio;
  function fi (L:llista):posicio;
  function seguent (L:llista;pos:posicio):posicio;
  function recupera(L:llista;pos:posicio):t_node;
  procedure inserta (var L:llista;e:t_node;pos:posicio);
  procedure suprimir (var L:llista;pos:posicio);
  procedure llistar (L:llista);
  procedure anula (var L:llista);

  function Pertenece(rMenor, rElemento, rMayor : real) : boolean;
  function Factorial(eValor: integer) : real;
  function Combinaciones(eN, eM: integer) : real;
  function F_Binomial(eN: integer; rP: real; eK: integer) : real;
  function F_Poisson(rY: real; eK: integer) : real;
  function F_Exponencial(rY, rK: real) : real;
  function Poisson(rY, rX: real) : integer;
  function Binomial(eN: integer; rP, rX: real) : integer;
  function Exponencial(rY, rX: real) : real;
  function Normal(r_e, r_v, rX: real): real;
  function cardinal(rK: real) : real;
  function Lee_fichero: real;

var
  Form1: TForm1;
  rXi, r_p1, r_p2: real;
  e_Nmuestra, e_p1: integer;
  b_Si, b_error, b_check, b_abrir, b_virgen: boolean;
  s_num1, s_num2: string[32];

  buida, cadena: llista;
  nodo: t_node;

  fd: fichero;
  code: integer;

implementation

{$R *.DFM}

uses Unit2, Unit3, Unit4;

                             {Definicion de la lista y operaciones }
procedure init (var L:llista);
begin
  new(L);
  L^.rX:=0;
  L^.rK:=0;
  L^.seg:=nil;
end;

function primer(L:llista):posicio;
begin
  primer:=L;
end;

function fi(L:llista):posicio;
var
  temp:posicio;
begin    {retorna el darrer, no el darrer+1}
  temp:=L;
  while temp^.seg<>nil do
     temp:=temp^.seg;
  fi:=temp;
end;

function seguent(L:llista;pos:posicio):posicio;
var
tmp:posicio;
bol:boolean;
begin
  seguent:=buida;
  bol:=false;
  if (primer(L)=pos) and (primer(L)^.seg=nil) then
  begin {llista buida, retorna cap}
     seguent:=nil;
  end
  else if (fi(L)=pos) then
     begin {darrera posició, retorna darrer}
        seguent:=nil;
     end
  else begin  {mira si pos pertany a la llista}
     tmp:=primer(L);
     while (bol=false) and (tmp^.seg<>nil) do
     begin
        if tmp=pos then
        begin
           bol:=true;
           seguent:=pos^.seg;
        end
        else
           tmp:=tmp^.seg;
     end;
     if bol=false then
     begin     {si pos no pertany, retorna pos}
        seguent:=pos;
     end;
  end;
end;

function recupera(L:llista;pos:posicio):t_node;
var
  tmp:posicio;
  bol:boolean;
begin
  bol:=false;
  if (primer(L)=pos) and (primer(L)^.seg=nil) then
  begin {llista buida, retorna 0}
     recupera:=buida^;
  end
  else if (fi(L)=pos) then
     begin {darrera posició, retorna 0}
       recupera:=buida^;
     end
  else begin   {mira si pos pertany a la llista}
     tmp:=primer(L);
     while (bol=false) and (tmp^.seg<>nil) do
     begin
        if tmp=pos then
        begin
           bol:=true;
           tmp:=pos^.seg;
           recupera:=tmp^;
        end
        else
           tmp:=tmp^.seg;
     end;
     if bol=false then
     begin    {si no pertany, retorna 0}
        recupera:=buida^;
     end;
  end;
end;

procedure inserta(var L:llista;e:t_node;pos:posicio);
var
  temp,nou,tmp:posicio;
  bol:boolean;
begin
  bol:=false;
  tmp:=primer(L);
  while (bol=false) and (tmp^.seg<>nil) do
  begin      {mira si pos pertany a la llista}
     if tmp=pos then
        bol:=true
     else
        tmp:=tmp^.seg;
  end;
  if (bol=true) or (tmp=pos) then
     begin     {pos pertany, inserta}
     temp:=pos^.seg;
     new(nou);
     nou^:=e;
     nou^.seg:=temp;
     pos^.seg:=nou;
     end
  else      {pos no pertany, no inserta}
     ;
end;

procedure suprimir(var L:llista;pos:posicio);
var
  temp,tmp:posicio;
  bol:boolean;
begin
  bol:=false;
  tmp:=primer(L);
  while (bol=false) and (tmp^.seg<>nil) do
  begin
     if tmp=pos then
        bol:=true
     else
        tmp:=tmp^.seg;
  end;
  if (bol=true) and (pos^.seg<>nil) then
     begin
     temp:=pos^.seg;
     pos^.seg:=temp^.seg;
     dispose(temp);
     end
  else     {darrer node i pos no pertany, no borra}
     ;
end;

procedure anula(var L:llista);
var
  temp,temp2:posicio;
begin
  temp2:=buida;
  if primer(L)^.seg=nil then
   {llista buida}
  else begin
     while primer(L)^.seg<>nil do
     begin
        temp:=primer(L);
        while temp^.seg<>nil do
        begin
           temp2:=temp;
           temp:=temp^.seg;
        end;
        if primer(L)<>temp then
        begin
           temp2^.seg:=nil;
           dispose(temp);
        end;
     end;
  end;
end;

procedure llistar(L:llista);
var
   tmp:posicio;
   aux:t_node;
begin
  tmp:=primer(L);
  Form1.ListBox1.Items.Add('');
  Form1.ListBox1.Items.Add('');
  while tmp <> fi(L) do
  begin
     aux := recupera(L, tmp);
     str(aux.rX :6 :6, s_num1);
     str(aux.rK :6 :6, s_num2);
     Form1.ListBox1.Items.Add('X = '+s_num1+' => K = '+s_num2);
     tmp:=seguent(L, tmp);
  end;
end;

function h_khi(k: integer): real;
begin
     if k = 0 then
        h_khi := sqrt(pi)
     else
        h_khi := (2*k - 1)*h_khi(k-1);
end;

function egamma(k: integer): real;
begin
     egamma := factorial(k-1);
end;

function rgamma(k: integer): real;
begin
     rgamma := h_khi(k)/power(2, k);
end;

function f_khi(x: real; n:integer): real;
var
   raux1, raux2: real;
   eaux: integer;
begin
     eaux := n mod 2;
     if eaux = 0 then
         raux2 := power(2, n/2) * egamma(n div 2)
     else
         raux2 := power(2, n/2) * rgamma(n div 2);
     if n = 1 then
         raux1 := (1/sqrt(x)) * exp(-x/2)
     else
         raux1 := power(x, ((n/2)-1)) * exp(-x/2);
     f_khi := raux1 / raux2;
end;

function f_znormal(x: real) : real;
var
   raux: real;
begin
     raux := (exp(-(power(x,2)/2)))/sqrt(2*pi);
     f_znormal := raux;
end;

function Simpson(a,b: real; N, dif, en: integer) : real;
var
   g, i, p, d, o: real;
begin
     p := 0;
     g := a;
     case dif of
          0: p := f_znormal(g);
          1: p := f_khi(g, en);
     end;
     i := p;
     d := (b - a) / N;
     o := N / 2;
     while o <> 0 do
     begin
          g := g + d;
          case dif of
               0: p := f_znormal(g);
               1: p := f_khi(g, en);
          end;
          i := i + 4*p;
	  g := g + d;
          case dif of
               0: p := f_znormal(g);
               1: p := f_khi(g, en);
          end;
          i := i + 2*p;
          o := o - 1;
     end;
     g := g + b;
     case dif of
          0: p := f_znormal(g);
          1: p := f_khi(g, en);
     end;
     i := i - p;
     Simpson := (d*i) / 3;
end;

function Pearson(etipo: integer; rX: real; e_p1: integer): real;
var
   rU, rant, raux1, raux2: real;
begin
     rU := 1;
     rant := 0;
     case etipo of
          0:             {--- Inversa de la Normal ---}
          begin
               while (abs(rant-rU) > 0.000001) and (abs(simpson(-4, rU, 5000, 0, 0)-rX) > 0.000000001) and (f_znormal(rU) <> 0) do
               begin
                    raux1 := simpson(-4, rU, 5000, 0, 0);
                    raux2 := f_znormal(rU);
                    rant := rU;
                    rU := rU - ( (raux1 - rX)/ raux2);
               end;
          end;
          1:              {--- Inversa de la Khi cuadrado ---}
          begin
               while (abs(rant-rU) > 0.000001) and (abs(simpson(0.000001, rU, 2500, 1, e_p1)-rX) > 0.000000001) do
               begin
                    raux1 := simpson(0.000001, rU, 2500, 1, e_p1);
                    raux2 := f_khi(rU, e_p1);
                    rant := rU;
                    rU := rU - ( (raux1 - rX)/ raux2);
                    if rU <= 0 then
                       rU := 0.000001;
               end;
          end;
     end;
     Pearson := rU;
end;



function Pertenece(rMenor, rElemento, rMayor : real) : boolean;
begin
     if ( rElemento > rMenor ) and ( rElemento <= rMayor ) then
   	Pertenece := True
     else
   	Pertenece := False;
end;

function Factorial(eValor: integer) : real;
var
   eContador: integer;
   rAux: real;
begin
     rAux := 1;
     for eContador := 1 to eValor do
         rAux := rAux * eContador;
     Factorial := rAux;
end;

function Combinaciones(eN, eM: integer) : real;
begin
     Combinaciones := Factorial(eN) / ( Factorial(eM) * Factorial(eN - eM) );
end;

function F_Binomial(eN: integer; rP: real; eK: integer) : real;
var
   eContador: integer;
   rAux: real;
begin
     rAux := 0;
     for eContador := 0 to eK do
     begin
          rAux := rAux + Combinaciones(eN, eContador) * power(rP, eContador) * power( (1-rP), (eN-eContador) );
     end;
     F_Binomial := rAux;
end;

function F_Poisson(rY: real; eK: integer) : real;
var
   eContador: integer;
   rAux, rAux2, rAux3, rAux4: real;
begin
     rAux := 0;
     for eContador := 0 to eK do
     begin
          rAux2 := (power(rY, eContador) * exp(-1*rY));
          rAux3 := Factorial(eContador);
          rAux4 := rAux2 / rAux3;
          rAux := rAux + rAux4;
     end;
     F_Poisson := rAux;
end;

function F_Exponencial(rY, rK: real) : real;
begin
     F_Exponencial := 1 - exp(-1 * rY * rK);
end;



function Poisson(rY, rX: real) : integer;
var
   eK: integer;
   rA, rB: real;
begin
     eK := 0;
     rA := 0;
     rB := F_Poisson(rY, eK);
     while not ( Pertenece(rA, rX, rB) ) do
     begin
          eK := eK + 1;
	  rA := rB;
	  rB := F_Poisson(rY, eK);
     end;
     Poisson := eK;
end;

function Binomial(eN: integer; rP, rX: real) : integer;
var
   eK: integer;
   rA, rB: real;
begin
     eK := 0;
     rA := 0;
     rB := F_Binomial(eN, rP, eK);
     while not ( Pertenece(rA, rX, rB) ) do
     begin
          eK := eK + 1;
          rA := rB;
          rB := F_Binomial(eN, rP, eK);
     end;
     Binomial := eK;
end;

function Exponencial(rY, rX: real) : real;
begin
     Exponencial := ln( (-1/(rX - 1) )) / rY;
end;

function Normal(r_e, r_v, rX: real): real;
var
   rAux: real;
begin
     rAux := Pearson(0, rX, 0);
     Normal := rAux * sqrt(r_v)+ r_e;
end;

function Khi(e_n: integer; rX: real): real;
begin
     Khi := Pearson(1, rX, e_n);
end;



function maximo: real;
var
   tmp: posicio;
   nodo: t_node;
   rAux : real;
begin
     rAux := -999999999;
     tmp := primer(cadena);
     tmp := seguent(cadena, tmp);
     while tmp <> fi(cadena) do
     begin
          nodo := recupera(cadena, tmp);
          if nodo.rK > rAux then
             rAux := nodo.rK;
          tmp := seguent(cadena, tmp);
     end;
     maximo := rAux;
end;

function minimo: real;
var
   tmp: posicio;
   nodo: t_node;
   rAux : real;
begin
     rAux := 999999999;
     tmp := primer(cadena);
     tmp := seguent(cadena, tmp);
     while tmp <> fi(cadena) do
     begin
          nodo := recupera(cadena, tmp);
          if nodo.rK < rAux then
             rAux := nodo.rK;
          tmp := seguent(cadena, tmp);
     end;
     minimo := rAux;
end;

function elementos(rMenor, rMayor: real): real;
var
   rAux : real;
   tmp: posicio;
   nodo: t_node;
begin
     rAux := 0;
     tmp := primer(cadena);
     tmp := seguent(cadena, tmp);
     while tmp <> fi(cadena) do
     begin
          nodo := recupera(cadena, tmp);
          if pertenece(rMenor, nodo.rK, rMayor) then
             rAux := rAux + 1;
          tmp := seguent(cadena, tmp);
     end;
     elementos := rAux;
end;

function sum_khi(L: llista; var eint: integer): real;
var
   rAux, rY, rnp, ra, rb: real;
   tmp: posicio;
   nodo: t_node;
begin
     rAux := 0;
     eint := 0;
     tmp := primer(L);
     rY := 0;
     rnp := 0;
     ra := 0;
     rb := 0;
     while tmp <> fi(L) do
     begin
          nodo := recupera(L, tmp);
          rY := rY + nodo.rK;
          rnp := rnp + (e_Nmuestra * nodo.rX);
          if rnp >= 5 then
          begin
               if rb >= 5 then
               begin
                    rAux := rAux + (power(abs(ra-rb), 2) / rb);
                    eint := eint + 1;
               end;
               ra := rY;
               rb := rnp;
               rY := 0;
               rnp := 0;;
          end;
          tmp := seguent(L, tmp);
     end;
     ra := ra + rY;
     rb := rb + rnp;
     rAux := rAux + (power(abs(ra-rb), 2) / rb);
     eint := eint + 1;
     sum_khi := rAux;
end;

function cardinal(rK: real) : real;
var
   eContador: integer;
   tmp: posicio;
   nodo: t_node;
begin
     eContador := 0;
     tmp := primer(cadena);
     tmp := seguent(cadena, tmp);
     while tmp <> fi(cadena) do
     begin
          nodo := recupera(cadena, tmp);
          if nodo.rK <= rK then
             eContador := eContador + 1;
          tmp := seguent(cadena, tmp);
     end;
     cardinal := eContador;
end;

function Z_Normal(re, rv, rx: real): real;
var
   raux: real;
begin
     raux := ((rx-re)/sqrt(rv));
     if pertenece(-4, raux, 4) then
        Z_Normal := Simpson(-4, raux, 5000, 0, 0)
     else
         if raux <= -4 then
            Z_Normal := 0
         else
            Z_Normal := 1;
end;

function F_Khi_(en: integer; rx: real): real;
begin
     F_Khi_ := simpson(0.00001, rx, 5000, 1, en);
end;

function sum_central(e_i: integer): real;
var
   nodo: t_node;
   tmp: posicio;
   eContador: integer;
   rAux: real;
begin
     eContador := 1;
     rAux := 0;
     tmp := primer(cadena);
     tmp := seguent(cadena, tmp);
     while (eContador <= e_i) and (tmp <> fi(cadena)) do
     begin
          eContador := eContador + 1;
          nodo := recupera(cadena, tmp);
          rAux := rAux + nodo.rK;
          tmp := seguent(cadena, tmp);
     end;
     sum_central := (rAux / e_i);
end;

function Numero(cMuestra: char) : boolean;
begin
     if ( ord(cMuestra) >= 48 ) and ( ord(cMuestra) <= 57 ) then
        Numero := true
     else
   	Numero := false;
end;

function Lee_Fichero: real;
var
   berror, bcorrecto : boolean;
   cAux: char;
   rAux: real;
begin
   bError := False;
   bcorrecto := false;
   rAux := -1;
   if not b_virgen then
   begin
   	Read(fd,cAux);
        b_virgen := true;
        if cAux <> '0' then
           berror := true;
   end;
   while ( not eof(fd) ) and ( not bError ) and (not bcorrecto) do
   begin
             rAux := 0;
      	     Read(fd,cAux);
             if cAux = '.' then
             begin                 {Coma flotante}
             	Read(fd,cAux);
            	if Numero(cAux) then
                begin            {D‚cimas}
                   rAux := rAux + (ord(cAux) - ord('0'))*0.1;
                   Read(fd,cAux);
                   if Numero(cAux) then
                   begin         {Cent‚simas}
               		rAux := rAux + (ord(cAux) - ord('0'))*0.01;
                        bcorrecto := true;
                  	Read(fd,cAux);
                   	if Numero(cAux) then
                   	begin         {Milesimas}
                           rAux := rAux + (ord(cAux) - ord('0'))*0.001;
                           bcorrecto := true;
                           Read(fd,cAux);
                           while ((cAux = #13) or (cAux = #10) or (cAux = ' ')) and not(eof(fd)) do
                           begin
                           	Read(fd,cAux);
                             	if cAux <> '0' then
                                   berror := True;
                           end;
                        end;
                   end
                   else
                   	bError := True;
            	 end
                 else
                    bError := True;
             end
             else
             	bError := True;
   end;
   if bcorrecto then
      Lee_Fichero := rAux
   else
      Lee_Fichero := -1;
end;

procedure TForm1.Salir1Click(Sender: TObject);
begin
     close;
end;

procedure TForm1.Nuevo1Click(Sender: TObject);
begin
     ListBox1.Clear;
     anula(cadena);
end;

procedure TForm1.Poisson1Click(Sender: TObject);
var
   eContador: integer;
begin
     Form2.Showmodal;
     if b_Si = True then
     begin
          b_Si := false;
          Val(Form2.Edit1.Text, e_Nmuestra, Code);
          { Error durante la conversión? }
          if code <> 0 then
          begin
             MessageDlg('Error at position: ' + IntToStr(Code), mtWarning, [mbOk], 0);
             b_error := true;
          end;
          Val(Form2.Edit2.Text, r_p1, Code);
          { Error durante la conversión? }
          if code <> 0 then
          begin
             MessageDlg('Error at position: ' + IntToStr(Code), mtWarning, [mbOk], 0);
             b_error := true;
          end;
          if b_error = true then
             b_error := false
          else
          begin
               ListBox1.Clear;
               anula(cadena);

               str(r_p1 :6 :6, s_num1);
               ListBox1.Items.Add('');
               ListBox1.Items.Add('Muestra aleatoria simple de una variable aleatoria de Poisson con parametro ' + s_num1 + '.');
               ListBox1.Items.Add('');
               for eContador := 0 to e_Nmuestra do
               begin
                    str(F_Poisson(r_p1, eContador) :6 :6, s_num1);
                    Listbox1.Items.Add('k = '+IntToStr(eContador)+' => F(k) = '+s_num1);
               end;
               for eContador := 1 to e_Nmuestra do
               begin
               	    if b_check then
                    	nodo.rX := Lee_Fichero
                    else
                    	nodo.rX := random;
                    nodo.rK := Poisson(r_p1, nodo.rX);
                    inserta(cadena, nodo, primer(cadena));
               end;
               llistar(cadena);
               nodo.rX := 1;
               nodo.rK := 0;
               inserta(cadena, nodo, primer(cadena));
          end;
     end;
end;

procedure TForm1.Binomial1Click(Sender: TObject);
var
   eContador: integer;
begin
     Form2.Showmodal;
     if b_Si = True then
     begin
          b_Si := false;
          Val(Form2.Edit1.Text, e_Nmuestra, Code);
          { Error durante la conversión? }
          if code <> 0 then
          begin
             MessageDlg('Error at position: ' + IntToStr(Code), mtWarning, [mbOk], 0);
             b_error := true;
          end;
          Val(Form2.Edit2.Text, e_p1, Code);
          { Error durante la conversión? }
          if code <> 0 then
          begin
             MessageDlg('Error at position: ' + IntToStr(Code), mtWarning, [mbOk], 0);
             b_error := true;
          end;
          Val(Form2.Edit3.Text, r_p2, Code);
          { Error durante la conversión? }
          if code <> 0 then
          begin
             MessageDlg('Error at position: ' + IntToStr(Code), mtWarning, [mbOk], 0);
             b_error := true;
          end;
          if b_error = true then
             b_error := false
          else
          begin
               ListBox1.Clear;
               anula(cadena);

               str(r_p2 :6 :6, s_num2);
               ListBox1.Items.Add('');
               ListBox1.Items.Add('Muestra aleatoria simple de una variable aleatoria Binomial con parametros '+inttostr(e_p1)+', '+s_num2+'.');
               ListBox1.Items.Add('');
               for eContador := 0 to e_p1 do
               begin
                    str(F_Binomial(e_p1, r_p2, eContador) :6 :6, s_num1);
                    Listbox1.Items.Add('k = '+IntToStr(eContador)+' => F(k) = '+s_num1);
               end;
               for eContador := 1 to e_Nmuestra do
               begin
               	    if b_check then
                    	nodo.rX := Lee_Fichero
                    else
                    	nodo.rX := random;
                    nodo.rK := Binomial(e_p1, r_p2, nodo.rX);
                    inserta(cadena, nodo, primer(cadena));
               end;
               llistar(cadena);
               nodo.rX := 2;
               nodo.rK := 0;
               inserta(cadena, nodo, primer(cadena));
          end;
     end;
end;


procedure TForm1.Exponencial1Click(Sender: TObject);
var
   eContador: integer;
begin
     Form2.Showmodal;
     if b_Si = True then
     begin
          b_Si := false;
          Val(Form2.Edit1.Text, e_Nmuestra, Code);
          { Error durante la conversión? }
          if code <> 0 then
          begin
             MessageDlg('Error at position: ' + IntToStr(Code), mtWarning, [mbOk], 0);
             b_error := true;
          end;
          Val(Form2.Edit2.Text, r_p1, Code);
          { Error durante la conversión? }
          if code <> 0 then
          begin
             MessageDlg('Error at position: ' + IntToStr(Code), mtWarning, [mbOk], 0);
             b_error := true;
          end;
          if b_error = true then
             b_error := false
          else
          begin
               ListBox1.Clear;
               anula(cadena);

               str(r_p1 :6 :6, s_num1);
               ListBox1.Items.Add('');
               ListBox1.Items.Add('Muestra aleatoria simple de una variable aleatoria Exponencial con parametro ' + s_num1 + '.');
               ListBox1.Items.Add('');
               for eContador := 0 to e_Nmuestra do
               begin
                    str(F_Exponencial(r_p1, eContador) :6 :6, s_num1);
                    Listbox1.Items.Add('k = '+IntToStr(eContador)+' => F(k) = '+s_num1);
               end;
               for eContador := 1 to e_Nmuestra do
               begin
               	    if b_check then
                    	nodo.rX := Lee_Fichero
                    else
                    	nodo.rX := random;
                    nodo.rK := Exponencial(r_p1, nodo.rX);
                    inserta(cadena, nodo, primer(cadena));
               end;
               llistar(cadena);
               nodo.rX := 3;
               nodo.rK := 0;
               inserta(cadena, nodo, primer(cadena));
          end;
     end;
end;

procedure TForm1.Normal1Click(Sender: TObject);
var
   eContador: integer;
begin
     Form2.Showmodal;
     if b_Si = True then
     begin
          b_Si := false;
          Val(Form2.Edit1.Text, e_Nmuestra, Code);
          { Error durante la conversión? }
          if code <> 0 then
          begin
             MessageDlg('Error at position: ' + IntToStr(Code), mtWarning, [mbOk], 0);
             b_error := true;
          end;
          Val(Form2.Edit2.Text, r_p1, Code);
          { Error durante la conversión? }
          if code <> 0 then
          begin
             MessageDlg('Error at position: ' + IntToStr(Code), mtWarning, [mbOk], 0);
             b_error := true;
          end;
          Val(Form2.Edit3.Text, r_p2, Code);
          { Error durante la conversión? }
          if code <> 0 then
          begin
             MessageDlg('Error at position: ' + IntToStr(Code), mtWarning, [mbOk], 0);
             b_error := true;
          end;
          if b_error = true then
             b_error := false
          else
          begin
               ListBox1.Clear;
               anula(cadena);

               str(r_p1 :6 :6, s_num1);
               str(r_p2 :6 :6, s_num2);
               ListBox1.Items.Add('');
               ListBox1.Items.Add('Muestra aleatoria simple de una variable aleatoria Normal con parametros '+s_num1+', '+s_num2+'.');
               ListBox1.Items.Add('');
               for eContador := 1 to e_Nmuestra do
               begin
               	    if b_check then
                    	nodo.rX := Lee_Fichero
                    else
                    	nodo.rX := random;
                    nodo.rK := Normal(r_p1, r_p2, nodo.rX);
                    inserta(cadena, nodo, primer(cadena));
               end;
               llistar(cadena);
               nodo.rX := 4;
               nodo.rK := 0;
               inserta(cadena, nodo, primer(cadena));
          end;
     end;
end;


procedure TForm1.Khicuadrado1Click(Sender: TObject);
var
   eContador: integer;
begin
     Form2.Showmodal;
     if b_Si = True then
     begin
          b_Si := false;
          Val(Form2.Edit1.Text, e_Nmuestra, Code);
          { Error durante la conversión? }
          if code <> 0 then
          begin
             MessageDlg('Error at position: ' + IntToStr(Code), mtWarning, [mbOk], 0);
             b_error := true;
          end;
          Val(Form2.Edit2.Text, e_p1, Code);
          { Error durante la conversión? }
          if code <> 0 then
          begin
             MessageDlg('Error at position: ' + IntToStr(Code), mtWarning, [mbOk], 0);
             b_error := true;
          end;
          if b_error = true then
             b_error := false
          else
          begin
               ListBox1.Clear;
               anula(cadena);

               ListBox1.Items.Add('');
               ListBox1.Items.Add('Muestra aleatoria simple de una variable aleatoria Khi cuadrado con '+inttostr(e_p1)+' grados de libertad.');
               ListBox1.Items.Add('');
               for eContador := 1 to e_Nmuestra do
               begin
               	    if b_check then
                    	nodo.rX := Lee_Fichero
                    else
                    	nodo.rX := random;
                    nodo.rK := Khi(e_p1, nodo.rX);
                    inserta(cadena, nodo, primer(cadena));
               end;
               llistar(cadena);
               nodo.rX := 5;
               nodo.rK := 0;
               inserta(cadena, nodo, primer(cadena));
          end;
     end;
end;

procedure TForm1.Comprobacion1Click(Sender: TObject);
var
   cad_aux: llista;
   eContador, eaux, eaux2, emax, emin, eintv, e_int: integer;
   rD, rKhi, rmax, rmin, rlong, rA, rB: real;
   nodo1, nodo2: t_node;
   tmp: posicio;
begin
     init(cad_aux);
     rD := 0;
     eintv := 0;
     if primer(cadena) <> fi (cadena) then
     begin
                       { *** Kolmogorov-Smirnov ***}
          tmp := primer(cadena);
          nodo1 := recupera(cadena, tmp);
          str(nodo1.rX :6 :6, s_num1);
          val(s_num1, eaux, code);
          tmp := seguent(cadena, tmp);
          for eContador := 1 to e_Nmuestra do
          begin
               nodo2 := recupera(cadena, tmp);
               str(nodo2.rX :6 :6, s_num1);
               val(s_num1, eaux2, code);
               case eaux of
                    1: nodo1.rX := F_Poisson(r_p1, eaux2);
                    2: nodo1.rX := F_Binomial(e_p1, r_p2, eaux2);
                    3: nodo1.rX := F_Exponencial(r_p1, nodo2.rK);
                    4: nodo1.rX := Z_Normal(r_p1, r_p2, nodo2.rK);
                    5: nodo1.rX := F_Khi_(e_p1, nodo2.rX);
               end;
               nodo1.rK := cardinal(nodo2.rK)/e_Nmuestra;
               inserta(cad_aux, nodo1, primer(cad_aux));
               tmp := seguent(cadena, tmp);
          end;
          tmp := primer(cad_aux);
          while tmp <> fi(cad_aux) do
          begin
               nodo2 := recupera(cad_aux, tmp);
               if rD < abs(nodo2.rX - nodo2.rK) then
                  rD := abs(nodo2.rX - nodo2.rK);
               tmp := seguent(cad_aux, tmp);
          end;
          anula(cad_aux);
          str(rD :6 :6, s_num1);
          Form1.ListBox1.Items.Add('');
          Form1.ListBox1.Items.Add('Mediante el Test de Kolmogorov-Smirnov hemos obtenido:');
          Form1.ListBox1.Items.Add('                 D('+inttostr(e_Nmuestra)+') = '+s_num1);

                        {*** Khi cuadrado ***}
          rmax := maximo;
          rmin := minimo;
          case eaux of
               1, 2:
               begin
                    str(rmax :6 :6, s_num1);
                    val(s_num1, emax, code);
                    str(rmin :6 :6, s_num1);
                    val(s_num1, emin, code);
                    for eContador := emin to emax do
                    begin
                         nodo1.rK := elementos(eContador-0.5, eContador+0.5);
                         if eaux = 1 then
                         begin
                              if eContador = emin then
                                 nodo1.rX := F_Poisson(r_p1, emin)
                              else
                                  if eContador = emax then
                                     nodo1.rX := 1-F_Poisson(r_p1, (emax-1))
                                  else
                                      nodo1.rX := F_Poisson(r_p1, eContador)-F_Poisson(r_p1, eContador-1);
                         end
                         else
                         begin
                              if eContador = emin then
                                 nodo1.rX := F_Binomial(e_p1, r_p2, emin)
                              else
                                  if eContador = emax then
                                     nodo1.rX := 1-F_Binomial(e_p1, r_p2, (emax-1))
                                  else
                                      nodo1.rX := F_Binomial(e_p1, r_p2, eContador)-F_Binomial(e_p1, r_p2, eContador-1);
                         end;
                         inserta(cad_aux, nodo1, primer(cad_aux));
                    end;
                    rKhi := sum_khi(cad_aux, eintv);
                    eintv := eintv - 1;
                    str(rKhi :6 :6, s_num1);
                    Form1.ListBox1.Items.Add('');
                    Form1.ListBox1.Items.Add('Mediante el Test de la Khi cuadrado hemos obtenido:');
                    Form1.ListBox1.Items.Add('                 X^2('+inttostr(eintv)+') = '+s_num1);
               end;
               3, 4, 5:
               begin
                    Form3.ShowModal;
                    if b_si = true then
                    begin
                         b_si := false;
                         Val(Form3.Edit1.Text, e_int, Code);
                         { Error durante la conversión? }
                         if code <> 0 then
                         begin
                              MessageDlg('Error at position: ' + IntToStr(Code), mtWarning, [mbOk], 0);
                              b_error := true;
                         end;
                         if b_error then
                            b_error := false
                         else
                         begin
                              rlong := ((rmax-0.5)-(rmin+0.5))/ (e_int - 2);
                              emin := 1;
                              emax := e_int;
                              rB := 0;
                              for eContador := emin to emax do
                              begin
                                   if eContador = emin then
                                   begin
                                        rA := -999999999;
                                        rB := rmin + 0.5;
                                   end
                                   else
                                   begin
                                        rA := rB;
                                        if eContador = emax then
                                           rB := 999999999
                                        else
                                            rB := rA + rlong;
                                   end;
                                   nodo1.rK := elementos(rA, rB);
                                   if eaux = 3 then
                                   begin
                                        if eContador = emin then
                                           nodo1.rX := F_Exponencial(r_p1, rB)
                                        else
                                            if eContador = emax then
                                               nodo1.rX := 1-F_Exponencial(r_p1, rA)
                                            else
                                                nodo1.rX := F_Exponencial(r_p1, rB)-F_Exponencial(r_p1, rA);
                                   end;
                                   if eaux = 4 then
                                   begin
                                        if eContador = emin then
                                           nodo1.rX := Z_Normal(r_p1, r_p2, rB)
                                        else
                                            if eContador = emax then
                                               nodo1.rX := 1-Z_Normal(r_p1, r_p2, rA)
                                            else
                                                nodo1.rX := Z_Normal(r_p1, r_p2, rB)-Z_Normal(r_p1, r_p2, rA);
                                   end;
                                   if eaux = 5 then
                                   begin
                                        if eContador = emin then
                                           nodo1.rX := F_Khi_(e_p1, rB)
                                        else
                                            if eContador = emax then
                                               nodo1.rX := 1-F_Khi_(e_p1, rA)
                                            else
                                                nodo1.rX := F_Khi_(e_p1, rB)-F_Khi_(e_p1, rA);
                                   end;
                                   inserta(cad_aux, nodo1, primer(cad_aux));
                              end;
                              rKhi := sum_khi(cad_aux, eintv);
                              eintv := eintv - 1;
                              str(rKhi :6 :6, s_num1);
                              Form1.ListBox1.Items.Add('');
                              Form1.ListBox1.Items.Add('Mediante el Test de la Khi cuadrado hemos obtenido:');
                              Form1.ListBox1.Items.Add('                 X^2('+inttostr(eintv)+') = '+s_num1);
                         end;
                    end;
               end;
          end;
          anula(cad_aux);
     end;
end;


procedure TForm1.Central1Click(Sender: TObject);
var
   cad_aux1, cad_aux2: llista;
   eContador, eaux: integer;
   r_e, r_v, r_t, r_Fi: real;
   nodo: t_node;
begin
     init(cad_aux1);
     r_e := 0;
     r_v := 0;
     if primer(cadena) <> fi(cadena) then
     begin
          nodo := recupera(cadena, primer(cadena));
          str(nodo.rX :6 :6, s_num1);
          val(s_num1, eaux, code);
          case eaux of
               1:
               begin
                    r_e := r_p1;
                    r_v := r_p1;
               end;
               2:
               begin
                    r_e := e_p1 * r_p2;
                    r_v := e_p1 * r_p2 * (1-r_p2);
               end;
               3:
               begin
                    r_e := 1 / r_p1;
                    r_v := 1 / power(r_p1, 2);
               end;
               4:
               begin
                    r_e := r_p1;
                    r_v := r_p2;
               end;
               5:
               begin
                    r_e := e_p1;
                    r_v := 2 * e_p1;
               end;
          end;
          for eContador := 1 to e_Nmuestra do
          begin
               nodo.rX := eContador;
               nodo.rK := (sum_central(eContador) - r_e) / (sqrt(r_v)/sqrt(eContador));
               inserta(cad_aux1, nodo, primer(cad_aux1));
          end;
          Form1.ListBox1.Items.Add('');
          Form1.ListBox1.Items.Add('La muestra de la función empirica es:');
          llistar(cad_aux1);
          nodo.rK := -9;
          nodo.rX := -9;
          inserta(cad_aux1, nodo, primer(cad_aux1));
          cad_aux2 := cadena;
          cadena := cad_aux1;
          Form4.ShowModal;
          if b_si = true then
          begin
               b_si := false;
               Val(Form4.Edit1.Text, r_t, Code);
               { Error durante la conversión? }
               if code <> 0 then
               begin
                    MessageDlg('Error at position: ' + IntToStr(Code), mtWarning, [mbOk], 0);
                    b_error := true;
               end;
               if b_error then
                    b_error := false
               else
               begin
                    r_Fi := cardinal(r_t) / e_Nmuestra;
                    anula(cad_aux1);
                    cadena := cad_aux2;
                    str(r_t :6 :6, s_num1);
                    str(r_Fi :6 :6, s_num2);
                    Form1.ListBox1.Items.Add('');
                    Form1.ListBox1.Items.Add('Siendo t: '+s_num1+' hemos obtenido F: '+s_num2);
               end;
          end;
     end;
end;


{------------------------------------------------------------------------}
{		Programa principal	                       		 }
{------------------------------------------------------------------------}
BEGIN
   Randomize;
   init(buida);
   init(cadena);
   b_error := false;
   b_Si := false;
   b_check := false;
   b_virgen := false;

end.
