{Rutina de verificación del funcionamiento de los procedimientos y
funciones.
Se debe simular el programa en el circuito "Test1.DSN". Se debe 
escuchar, una serie de pitidos cortos. Si se escucha un pitido 
largo, es que hubo algún error en el resultado de alguna operación.}
{$FREQUENCY 8Mhz}
{$OUTPUTHEX 'output.hex'}
uses PIC16F84A;
var
  vbyte: byte;

  pinLed: bit absolute PORTB.0;

  procedure bien;
  begin
    pinLed := 1;
    delay_ms(30);
    pinLed := 0;
    delay_ms(70);
  end;
  procedure Mal;
  begin
    pinLed := 1;
    delay_ms(1500);
    pinLed := 0;
    asm SLEEP end
  end;
  //Procedimientos de prueba
  procedure proc1;
  begin
    vbyte := 5;
  end;

  procedure proc2(par1: byte);
  begin
    if par1 = 0 then 
      exit;
    else
      vbyte := 10;
    end;  
  end;

  //Funciones de prueba
  procedure func1: byte;
  begin
    exit(3);
  end;

  procedure func2(par1: byte): byte;
  begin
    exit(par1+1);
  end;

  procedure func2b(par1: word): word;
  begin
    exit(par1+2);
  end;

  //Prueba de devolución de variable
  procedure func2c(par1: word): word;
  begin
    exit(par1);
  end;

	//Función con varios parámetros word, byte
  procedure func3(par1: word; par2: byte): bit;
  begin
    exit(bit(1));
  end;

  procedure func4(par1: boolean): boolean;
  begin
    exit(not par1);
  end;

  //Funciones sobrecargadas
  procedure fun5(valor1: byte): byte;
  begin
    exit(valor1+1);
  end;

  procedure fun5(valor1: word): word;
  begin
    exit(valor1+2);
  end;

	//Función con acceso a otro banco
  procedure fun6(valor1: byte): byte;
  begin
    TRISA := $FF;
    exit(valor1);
  end;

	//Función con parámetros REGISTER
  procedure fun7(register valor1: byte): byte;
  begin
	  exit(valor1 + 1);
  end; 

var 
  xbyte : byte;
  xword : word;
  xbit  : bit;
  xbool : boolean;
begin
  SetAsOutput(pinLed);
  pinLed := 0;
  //Prueba de procedimiento
  vbyte := 0;
  Proc1;
  if vbyte = 5 then bien else mal end;

  vbyte := 1;
	proc2(0);
  if vbyte = 1 then bien else mal end;

	proc2(1);
  if vbyte = 10 then bien else mal end;

  //Prueba de función
  xbyte := func1;
  if xbyte = 3 then bien else mal end;

  xbyte := func1 + 1;
  if xbyte = 4 then bien else mal end;

  xbyte := 2 + func1 + func1 + 2;
  if xbyte = 10 then bien else mal end;

  xbyte :=  func2(1);
  if xbyte = 2 then bien else mal end;

  xbyte :=  func2(1) + func2(2);
  if xbyte = 5 then bien else mal end;

  xbyte :=  1+func2(1) + (func2(2)+func2(3));
  if xbyte = 10 then bien else mal end;

  xbyte := 10;
  xbyte :=  func2(xbyte);
  if xbyte = 11 then bien else mal end;

  xword :=  func2b(word(1));
  if xword = word(3) then bien else mal end;

  xword := 10;
  xword :=  func2b(xword);
  if xword = word(12) then bien else mal end;

  //Prueba de devolución de variable
  xword := 10;
  xword :=  func2c(xword);
  if xword = word(10) then bien else mal end;

	//Función con varios parámetros word, byte
  xbit := 0;
	xbit := func3(word(1), 2);
  if xbit = 1 then bien else mal end;

  xbool := func4(false);
  if xbool then bien else mal end;

  xbool := func4(true);
  if not xbool then bien else mal end;

  xbool := func4(true) or func4(false);
  if xbool then bien else mal end;

  //Funciones sobrecargadas
  xword := fun5(5) + fun5(word(5));
  if xword = word(13) then bien else mal end;

	//Función con acceso a otro banco
  xbyte := fun6(6) + 1;  //fun6 accede al banco 1
  if xbyte = 7 then bien else mal end;

	TRISA := 1;
  xbyte := func2(6);  //se accede a func2 desde en banco 1
  if xbyte = 7 then bien else mal end;

	//Función con parámetros REGISTER
  xbyte :=  fun7(1);
  if xbyte = 2 then bien else mal end;
  
  //Función con llamada recursiva
  xbyte := func2(func2(200));
  if xbyte = 202 then bien else mal end;
  
end.
