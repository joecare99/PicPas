{Rutina de verificación para operaciones con datos de tipo byte.
Se debe simular el programa en el circuito "Test2.DSN". Se debe 
escuchar, una serie de pitidos cortos. Si se escucha un pitido 
largo, es que hubo algún error en el resultado de alguna operación.
Por: Tito Hinostroza
Modificado: 01/03/2018}
uses PIC10F202, UnitTest;
{$FREQUENCY 4Mhz}
{$OUTPUTHEX 'output.hex'}
var
  a, b: byte;

begin
  SetAsOutput(pinLed);
  pinLed := 0;

  //////////////////////////////////////////////////////////
	////////////////////  Mult 8 bits->16  ///////////////////
  //////////////////////////////////////////////////////////
	//coConst_Const
  if 0 * 0 = 0 then good else bad end;
  if 0 * 1  = 0 then good else bad end;
  if 255 * 0 = 0 then good else bad end;
  if 5 * 5 = 25 then good else bad end;

	//coConst_Variab
  a := 0;
  if 5 * a = word(0) then good else bad end;
  a := 5;
  if word(0 * a) = word(0) then good else bad end;
  if 5 * a = word(25) then good else bad end;
  //coConst_Expres
  a := 5;
  if 0 * (a+1) = word(0) then good else bad end;
  if 5 * (a+1) = word(30) then good else bad end;
  //coVariab_Const
  a := 5;
  if a * 0 = word(0) then good else bad end;
  if a * 5 = word(25) then good else bad end;
  //coVariab_Variab  
  a := 5; b := 0;
  if a * b = word(0) then good else bad end;
  a := 5; b := 100;
  if a * b = 500 then good else bad end;
  //coVariab_Expres
  a := 10; b := 10;
  if a * (b+1) = word(110) then good else bad end;
  //coExpres_Const
  a := 19;
  if (a+1) * 5 = word(100) then good else bad end;
  //coExpres_Variab
  a := 19; b := 100;
  if (a+1) * b = 2000 then good else bad end;
  //coExpres_Expres
  a := 10; b := 10;
  if (a+1) * (b+1) = word(121) then good else bad end;

  //////////////////////////////////////////////////////////
	////////////////////  8 Div 8 -> 8  ///////////////////
  //////////////////////////////////////////////////////////

	//coConst_Const
  if 0 div 1  = 0 then good else bad end;
  if 5 div 255 = 0 then good else bad end;
  if 25 div 5 = 5 then good else bad end;

	//coConst_Variab
  a := 0;
  if 0 div a = 0 then good else bad end;
  a := 1;
  if 1 div a = 1 then good else bad end;
  a := 2;
  if 1 div a = 0 then good else bad end;
  a := 50;
  if 100 div a = 2 then good else bad end;
  a := 0;  //Entre cero
  if 255 div a = 255 then good else bad end;

  //coConst_Expres
  a := 5;
  if 0 div (a+1) = 0 then good else bad end;
  if 6 div (a+1) = 1 then good else bad end;
  //coVariab_Const
  a := 25;
  if a div 5 = 5 then good else bad end;
  if a div 6 = 4 then good else bad end;
  //coVariab_Variab  
  a := 255; b := 50;
  if a DIV b = 5 then good else bad end;
  a := 99; b := 100;
  if a DIV b = 0 then good else bad end;
  //coVariab_Expres
  a := 100; b := 10;
  if a div (b+1) = 9 then good else bad end;
  //coExpres_Const
  a := 19;
  if (a+1) div 5 = 4 then good else bad end;
  //coExpres_Variab
  a := 15; b := 4;
  if (a+1) div b = 4 then good else bad end;
  //coExpres_Expres
  a := 100; b := 5;
  if (a+5) div (b+2) = 15 then good else bad end;

  //////////////////////////////////////////////////////////
	//////////////////// 8 Mod 8 bits-> 8  ///////////////////
  //////////////////////////////////////////////////////////

	//coConst_Const
  if 0 mod 1  = 0 then good else bad end;
  if 5 mod 255 = 5 then good else bad end;
  if 25 mod 5 = 0 then good else bad end;
  if 24 mod 5 = 4 then good else bad end;

	//coConst_Variab
  a := 0;
  if 0 mod a = 0 then good else bad end;
  a := 1;
  if 1 mod a = 0 then good else bad end;
//  a := 2;
//  if 1 mod a = 1 then good else bad end;
  
//Pruebas elimiandas por falta de espacio
//  a := 50;
//  if 100 mod a = 0 then good else bad end;
//  a := 0;  //Entre cero
//  if 255 mod a = 255 then good else bad end;  //Realmente no está definido que se así
//
//  //coConst_Expres
//  a := 5;
//  if 0 mod (a+1) = 0 then good else bad end;
//  if 6 mod (a+1) = 0 then good else bad end;
//  
//  //coVariab_Const
//  a := 25;
//  if a mod 5 = 0 then good else bad end;
//  if a mod 6 = 1 then good else bad end;
//  
//  //coVariab_Variab  
//  a := 255; b := 50;
//  if a mod b = 5 then good else bad end;
//  a := 99; b := 100;
//  if a mod b = 99 then good else bad end;
//  
//  //coVariab_Expres
//  a := 100; b := 10;
//  if a mod (b+1) = 1 then good else bad end;
//  
//  //coExpres_Const
//  a := 19;
//  if (a+1) mod 5 = 0 then good else bad end;
//  
//  //coExpres_Variab
//  a := 18; b := 4;
//  if (a+1) mod b = 3 then good else bad end;
//  
//  //coExpres_Expres
//  a := 100; b := 5;
//  if (a+4) mod (b+2) = 6 then good else bad end;
//  
end.
