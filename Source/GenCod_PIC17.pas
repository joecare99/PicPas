{
Implementación de un compilador sencillo de Pascal para microcontroladores PIC de
rango medio.
Esta implementación no permitirá recursividad, por las limitaciones de recursos de los
dispositivos más pequeños, y por la dificultad adicional en la conmutación de bancos
para los dispositivos más grandes.
El compilador está orientado a uso de registros (solo hay uno) y memoria RAM, pero se
implementa una especie de estructura de pila para la evaluación de expresiones
aritméticas con cierta complejidad y para el paso de parámetros a las funciones.
Solo se manejan datos de tipo bit, boolean, byte y word, y operaciones sencillas.
}
{La arquitectura definida aquí contempla:

Un registro de trabajo W, de 8 bits (el acumulador del PIC).
Dos registros adicionales  H y L de 8 bits cada uno (Creados a demanda).

Los resultados de una expresión se dejarán en:

1. En Bit Z o C, de STATUS -> Si el resultado es de tipo bit o boolean.
2. El acumulador W         -> Si el resultado es de tipo byte o char.
3. Los registros (H,w)     -> Si el resultado es tipo word.
4. Los registros (U,E,H,w) -> Si el resultado es tipo dword.

Opcionalmente, si estos registros ya están ocupados, se guardan primero en la pila, o se
usan otros registros auxiliares.

Despues de ejecutar alguna operación booleana que devuelva una expresión, se
actualizan las banderas: BooleanBit y BooleanInverted, que implican que:
* Si BooleanInverted es TRUE, significa que la lógica de C o Z está invertida.
* La bandera BooleanBit, indica si el resultado se deja en C o Z.

Por normas de Xpres, se debe considerar que:
* Todas las operaciones recibe sus dos parámetros en las variables p1 y p2^.
* El resultado de cualquier expresión se debe dejar indicado en el objeto "res".
* Los valores enteros y enteros sin signo se cargan en valInt
* Los valores booleanos se cargan en "valBool"
* Los valores string se cargan en "valStr"

Las rutinas de operación, deben devolver su resultado en "res".
Para mayor información, consultar la doc. técnica.
 }
unit GenCod_PIC17;
{$mode objfpc}{$H+}
interface
uses
  Classes, SysUtils, Graphics, LCLType, LCLProc,
  SynFacilBasic, XpresTypesPIC, XpresElementsPIC, Pic17Utils, GenCodBas_PIC17,
  CompBase, Globales, MisUtils, XpresBas;
type
    { TGenCod }
    TGenCod = class(TGenCodBas)
    private
      procedure codif_delay_ms2(fun: TxpEleFun);
      procedure DefineArray(etyp: TxpEleType);
      procedure DefinePointer(etyp: TxpEleType);
      procedure ROB_byte_mod_byte(Opt: TxpOperation; SetRes: boolean);
      procedure ROB_byte_mul_word(Opt: TxpOperation; SetRes: boolean);
      procedure ROB_word_mul_byte(Opt: TxpOperation; SetRes: boolean);
      procedure ROB_word_mul_word(Opt: TxpOperation; SetRes: boolean);
      procedure ValidRAMaddr(addr: integer);
    private  //Operaciones con Bit
//      f_byteXbyte_byte: TxpEleFun;  //índice para función
      f_delay_msB: TxpELeFun;
      f_delay_msW: TxpELeFun;
      f_byte_mul_byte_16: TxpEleFun;  //índice para función
      f_byte_div_byte: TxpEleFun;  //índice para función
      f_word_mul_word_16: TxpEleFun;  //índice para función
      procedure byte_div_byte(fun: TxpEleFun);
      procedure mul_byte_16(fun: TxpEleFun);
      procedure CopyInvert_C_to_Z;
      procedure fun_Byte(fun: TxpEleFunBase; out AddrUndef: boolean);
      procedure fun_DWord(fun: TxpEleFunBase; out AddrUndef: boolean);
      procedure ROB_bit_asig_bit(Opt: TxpOperation; SetRes: boolean);
      procedure ROB_bit_asig_byte(Opt: TxpOperation; SetRes: boolean);
      procedure ROB_bit_and_bit(Opt: TxpOperation; SetRes: boolean);
      procedure ROB_bit_and_byte(Opt: TxpOperation; SetRes: boolean);
      procedure ROB_bit_or_bit(Opt: TxpOperation; SetRes: boolean);
      procedure ROB_bit_or_byte(Opt: TxpOperation; SetRes: boolean);
      procedure ROB_bit_xor_bit(Opt: TxpOperation; SetRes: boolean);
      procedure ROB_bit_xor_byte(Opt: TxpOperation; SetRes: boolean);
      procedure ROB_bit_equ_bit(Opt: TxpOperation; SetRes: boolean);
      procedure ROB_bit_equ_byte(Opt: TxpOperation; SetRes: boolean);
      procedure ROB_bit_dif_bit(Opt: TxpOperation; SetRes: boolean);
      procedure ROB_bit_dif_byte(Opt: TxpOperation; SetRes: boolean);
      procedure ROB_byte_div_byte(Opt: TxpOperation; SetRes: boolean);
      procedure ROB_byte_mul_byte(Opt: TxpOperation; SetRes: boolean);
      procedure ROU_not_bit(Opr: TxpOperator; SetRes: boolean);
      procedure ROU_not_byte(Opr: TxpOperator; SetRes: boolean);
      procedure ROU_address(Opr: TxpOperator; SetRes: boolean);

      procedure ROB_word_and_byte(Opt: TxpOperation; SetRes: boolean);
      procedure ROB_word_umulword_word(Opt: TxpOperation; SetRes: boolean);
      procedure word_mul_word_16(fun: TxpEleFun);
    private  //Operaciones con boolean
      procedure ROB_bool_asig_bool(Opt: TxpOperation; SetRes: boolean);
      procedure ROU_not_bool(Opr: TxpOperator; SetRes: boolean);
      procedure ROB_bool_and_bool(Opt: TxpOperation; SetRes: boolean);
      procedure ROB_bool_or_bool(Opt: TxpOperation; SetRes: boolean);
      procedure ROB_bool_xor_bool(Opt: TxpOperation; SetRes: boolean);
      procedure ROB_bool_equ_bool(Opt: TxpOperation; SetRes: boolean);
      procedure ROB_bool_dif_bool(Opt: TxpOperation; SetRes: boolean);
    protected //Operaciones con byte
      procedure ROB_byte_asig_byte(Opt: TxpOperation; SetRes: boolean);
      procedure ROB_byte_aadd_byte(Opt: TxpOperation; SetRes: boolean);
      procedure ROB_byte_asub_byte(Opt: TxpOperation; SetRes: boolean);
      procedure ROB_byte_sub_byte(Opt: TxpOperation; SetRes: boolean);
      procedure ROB_byte_add_byte(Opt: TxpOperation; SetRes: boolean);
      procedure ROB_byte_add_word(Opt: TxpOperation; SetRes: boolean);
      procedure ROB_byte_and_byte(Opt: TxpOperation; SetRes: boolean);
      procedure ROB_byte_and_bit(Opt: TxpOperation; SetRes: boolean);
      procedure ROB_byte_or_byte(Opt: TxpOperation; SetRes: boolean);
      procedure ROB_byte_or_bit(Opt: TxpOperation; SetRes: boolean);
      procedure ROB_byte_xor_byte(Opt: TxpOperation; SetRes: boolean);
      procedure ROB_byte_xor_bit(Opt: TxpOperation; SetRes: boolean);
      procedure ROB_byte_equal_byte(Opt: TxpOperation; SetRes: boolean);
      procedure ROB_byte_difer_byte(Opt: TxpOperation; SetRes: boolean);
      procedure ROB_byte_difer_bit(Opt: TxpOperation; SetRes: boolean);
      procedure ROB_byte_great_byte(Opt: TxpOperation; SetRes: boolean);
      procedure ROB_byte_less_byte(Opt: TxpOperation; SetRes: boolean);
      procedure ROB_byte_gequ_byte(Opt: TxpOperation; SetRes: boolean);
      procedure ROB_byte_lequ_byte(Opt: TxpOperation; SetRes: boolean);
      procedure CodifShift_by_W(target: TPicRegister; toRight: boolean);
      procedure ROB_byte_shr_byte(Opt: TxpOperation; SetRes: boolean);
      procedure ROB_byte_shl_byte(Opt: TxpOperation; SetRes: boolean);
    private  //Operaciones con Word
      procedure ROB_word_asig_word(Opt: TxpOperation; SetRes: boolean);
      procedure ROB_word_asig_byte(Opt: TxpOperation; SetRes: boolean);
      procedure ROB_word_equal_word(Opt: TxpOperation; SetRes: boolean);
      procedure ROB_word_difer_word(Opt: TxpOperation; SetRes: boolean);
      procedure ROB_word_great_word(Opt: TxpOperation; SetRes: boolean);
      procedure ROB_word_add_word(Opt: TxpOperation; SetRes: boolean);
      procedure ROB_word_add_byte(Opt: TxpOperation; SetRes: boolean);
      procedure ROB_word_sub_word(Opt: TxpOperation; SetRes: boolean);
    private  //Operaciones con DWord
      procedure ROB_dword_aadd_dword(Opt: TxpOperation; SetRes: boolean);
      procedure ROB_dword_add_dword(Opt: TxpOperation; SetRes: boolean);
      procedure ROB_dword_asig_byte(Opt: TxpOperation; SetRes: boolean);
      procedure ROB_dword_asig_dword(Opt: TxpOperation; SetRes: boolean);
      procedure ROB_dword_asig_word(Opt: TxpOperation; SetRes: boolean);
      procedure ROB_dword_difer_dword(Opt: TxpOperation; SetRes: boolean);
      procedure ROB_dword_equal_dword(Opt: TxpOperation; SetRes: boolean);
    private  //Operaciones con Char
      procedure ROB_char_asig_char(Opt: TxpOperation; SetRes: boolean);
      procedure ROB_char_equal_char(Opt: TxpOperation; SetRes: boolean);
      procedure ROB_char_difer_char(Opt: TxpOperation; SetRes: boolean);

      procedure ROB_string_add_char(Opt: TxpOperation; SetRes: boolean);
      procedure ROB_string_add_string(Opt: TxpOperation; SetRes: boolean);
    protected //Operaciones con punteros
      procedure ROB_pointer_add_byte(Opt: TxpOperation; SetRes: boolean);
      procedure ROB_pointer_sub_byte(Opt: TxpOperation; SetRes: boolean);
      procedure ROU_derefPointer(Opr: TxpOperator; SetRes: boolean);
    private  //Funciones internas.
      procedure codif_1mseg;
      procedure codif_delay_ms(fun: TxpEleFun);
      procedure expr_end(posExpres: TPosExpres);
      procedure expr_start;
      procedure fun_Exit(fun: TxpEleFunBase; out AddrUndef: boolean);
      procedure fun_Inc(fun: TxpEleFunBase; out AddrUndef: boolean);
      procedure fun_Dec(fun: TxpEleFunBase; out AddrUndef: boolean);
      procedure fun_Ord(fun: TxpEleFunBase; out AddrUndef: boolean);
      procedure fun_Chr(fun: TxpEleFunBase; out AddrUndef: boolean);
      procedure fun_Bit(fun: TxpEleFunBase; out AddrUndef: boolean);
      procedure fun_Bool(fun: TxpEleFunBase; out AddrUndef: boolean);
      procedure fun_SetAsInput(fun: TxpEleFunBase; out AddrUndef: boolean);
      procedure fun_SetAsOutput(fun: TxpEleFunBase; out AddrUndef: boolean);
      procedure fun_Word(fun: TxpEleFunBase; out AddrUndef: boolean);
      procedure fun_SetBank(fun: TxpEleFunBase; out AddrUndef: boolean);
    protected
      procedure Cod_StartProgram;
      procedure Cod_EndProgram;
      procedure CreateSystemElements;
    public
      procedure StartSyntax;
      procedure DefCompiler;
      procedure DefPointerArithmetic(etyp: TxpEleType);
    end;

  procedure SetLanguage;
implementation
var
  MSG_NOT_IMPLEM, MSG_INVAL_PARTYP, MSG_UNSUPPORTED, MSG_CANNOT_COMPL,
  ER_INV_MAD_DEV, ER_INV_MEMADDR: string;

procedure SetLanguage;
begin
  GenCodBas_PIC17.SetLanguage;
  {$I ..\language\tra_GenCod.pas}
end;
procedure TGenCod.CopyInvert_C_to_Z;
begin
  //El resultado está en C (invertido), hay que pasarlo a Z
  kMOVLW($01 << _C);     //carga máscara de C
  _ANDWF(_STATUS, toW);   //el resultado está en Z, corregido en lógica.
  InvertedFromC := true;  //Indica que se ha hecho Z = 'C. para que se pueda optimizar
end;
////////////rutinas obligatorias
procedure TGenCod.Cod_StartProgram;
//Codifica la parte inicial del programa
begin
  //Code('.CODE');   //inicia la sección de código
end;
procedure TGenCod.Cod_EndProgram;
//Codifica la parte inicial del programa
begin
  _SLEEP();   //agrega instrucción final
  //Code('END');   //inicia la sección de código
end;
procedure TGenCod.expr_start;
//Se ejecuta siempre al iniciar el procesamiento de una expresión.
begin
  //Inicia banderas de estado para empezar a calcular una expresión
  W.used := false;        //Su ciclo de vida es de instrucción
  Z.used := false;        //Su ciclo de vida es de instrucción
  //H.used := false;      //Su ciclo de vida es de instrucción
  RTstate := nil;         //Inicia con los RT libres.
  //Limpia tabla de variables temporales
  varFields.Clear;
  //Guarda información de ubicación, en la ubicación actual
  pic.addPosInformation(cIn.curCon.row, cIn.curCon.col, cIn.curCon.idCtx);
end;
procedure TGenCod.expr_end(posExpres: TPosExpres);
//Se ejecuta al final de una expresión, si es que no ha habido error.
begin
  if exprLevel = 1 then begin  //el último nivel
//    Code('  ;fin expres');
  end;
  //Muestra informa
end;
////////////operaciones con Bit y Boolean
{$I .\GenCod.inc}
//////////// Operaciones con Byte
procedure TGenCod.ROB_byte_asig_byte(Opt: TxpOperation; SetRes: boolean);
var
  aux: TPicRegister;
  rVar: TxpEleVar;
begin
  //Simplifcamos el caso en que p2, sea de tipo p2^
  if not ChangePointerToExpres(p2^) then exit;
  //Realiza la asignación
  if p1^.Sto = stVariab then begin
    SetResultNull;  //Fomalmente,  una aisgnación no devuelve valores en Pascal
    //Asignación a una variable
    case p2^.Sto of
    stConst : begin
      if value2=0 then begin
        //caso especial
        kCLRF(byte1);
      end else begin
        kMOVLW(value2);
        kMOVWF(byte1);
      end;
    end;
    stVariab: begin
      kMOVF(byte2, toW);
//      kMOVF(p2^.rVar.addr0, toW);
      kMOVWF(byte1);
    end;
    stExpres: begin  //ya está en w
      kMOVWF(byte1);
    end;
    else
      GenError(MSG_UNSUPPORTED); exit;
    end;
  end else if p1^.Sto = stExpRef then begin
    {Este es un caso especial de asignación a un puntero a byte dereferenciado, pero
    cuando el valor del puntero es una expresión. Algo así como (ptr + 1)^}
    SetResultNull;  //Fomalmente, una aisgnación no devuelve valores en Pascal
    case p2^.Sto of
    stConst : begin
      kMOVWF(FSR.addr);  //direcciona
      //Asignación normal
      if value2=0 then begin
        //caso especial
        kCLRF(INDF.addr);
      end else begin
        kMOVLW(value2);
        kMOVWF(INDF.addr);
      end;
    end;
    stVariab: begin
      kMOVWF(FSR.addr);  //direcciona
      //Asignación normal
      kMOVF(byte2, toW);
      kMOVWF(INDF.addr);
    end;
    stExpres: begin
      //La dirección está en la pila y la expresión en W
      aux := GetAuxRegisterByte;
      kMOVWF(aux.addr);   //Salva W (p2)
      //Apunta con p1
      rVar := GetVarByteFromStk;
      kMOVF(rVar.addr0, toW);  //Opera directamente al dato que había en la pila. Deja en W
      kMOVWF(FSR.addr);  //direcciona
      //Asignación normal
      kMOVF(aux.addr, toW);
      kMOVWF(INDF.addr);
      aux.used := false;
      exit;
    end;
    else
      GenError(MSG_UNSUPPORTED); exit;
    end;
  end else if p1^.Sto = stVarRef then begin
    //Asignación a una variable
    SetResultNull;  //Fomalmente, una aisgnación no devuelve valores en Pascal
    case p2^.Sto of
    stConst : begin
      //Caso especial de asignación a puntero desreferenciado: variable^
      kMOVF(byte1, toW);
      kMOVWF(FSR.addr);  //direcciona
      //Asignación normal
      if value2=0 then begin
        //caso especial
        kCLRF(INDF.addr);
      end else begin
        kMOVLW(value2);
        kMOVWF(INDF.addr);
      end;
    end;
    stVariab: begin
      //Caso especial de asignación a puntero derefrrenciado: variable^
      kMOVF(byte1, toW);
      kMOVWF(FSR.addr);  //direcciona
      //Asignación normal
      kMOVF(byte2, toW);
      kMOVWF(INDF.addr);
    end;
    stExpres: begin  //ya está en w
      //Caso especial de asignación a puntero derefrrenciado: variable^
      aux := GetAuxRegisterByte;
      kMOVWF(aux.addr);   //Salva W (p2)
      //Apunta con p1
      kMOVF(byte1, toW);
      kMOVWF(FSR.addr);  //direcciona
      //Asignación normal
      kMOVF(aux.addr, toW);
      kMOVWF(INDF.addr);
      aux.used := false;
    end;
    else
      GenError(MSG_UNSUPPORTED); exit;
    end;
  end else begin
    GenError('Cannot assign to this Operand.'); exit;
  end;
end;
procedure TGenCod.ROB_byte_aadd_byte(Opt: TxpOperation; SetRes: boolean);
{Operación de asignación suma: +=}
var
  aux: TPicRegister;
  rVar: TxpEleVar;
begin
  //Simplifcamos el caso en que p2, sea de tipo p2^
  if not ChangePointerToExpres(p2^) then exit;
  //Caso especial de asignación
  if p1^.Sto = stVariab then begin
    SetResultNull;  //Fomalmente,  una aisgnación no devuelve valores en Pascal
    //Asignación a una variable
    case p2^.Sto of
    stConst : begin
      if value2=0 then begin
        //Caso especial. No hace nada
      end else begin
        kMOVLW(value2);
        kADDWF(byte1, toF);
      end;
    end;
    stVariab: begin
      kMOVF(byte2, toW);
      kADDWF(byte1, toF);
    end;
    stExpres: begin  //ya está en w
      kADDWF(byte1, toF);
    end;
    else
      GenError(MSG_UNSUPPORTED); exit;
    end;
  end else if p1^.Sto = stExpRef then begin
    {Este es un caso especial de asignación a un puntero a byte dereferenciado, pero
    cuando el valor del puntero es una expresión. Algo así como (ptr + 1)^}
    SetResultNull;  //Fomalmente, una aisgnación no devuelve valores en Pascal
    case p2^.Sto of
    stConst : begin
      //Asignación normal
      if value2=0 then begin
        //Caso especial. No hace nada
      end else begin
        kMOVWF(FSR.addr);  //direcciona
        kMOVLW(value2);
        _ADDWF(0, toF);
      end;
    end;
    stVariab: begin
      kMOVWF(FSR.addr);  //direcciona
      //Asignación normal
      kMOVF(byte2, toW);
      _ADDWF(0, toF);
    end;
    stExpres: begin
      //La dirección está en la pila y la expresión en W
      aux := GetAuxRegisterByte;
      kMOVWF(aux.addr);   //Salva W (p2)
      //Apunta con p1
      rVar := GetVarByteFromStk;
      kMOVF(rVar.addr0, toW);  //opera directamente al dato que había en la pila. Deja en W
      kMOVWF(FSR.addr);  //direcciona
      //Asignación normal
      kMOVF(aux.addr, toW);
      _ADDWF(0, toF);
      aux.used := false;
      exit;
    end;
    else
      GenError(MSG_UNSUPPORTED); exit;
    end;
  end else if p1^.Sto = stVarRef then begin
    //Asignación a una variable
    SetResultNull;  //Fomalmente, una aisgnación no devuelve valores en Pascal
    case p2^.Sto of
    stConst : begin
      //Asignación normal
      if value2=0 then begin
        //Caso especial. No hace nada
      end else begin
        //Caso especial de asignación a puntero dereferenciado: variable^
        kMOVF(byte1, toW);
        kMOVWF(FSR.addr);  //direcciona
        kMOVLW(value2);
        _ADDWF(0, toF);
      end;
    end;
    stVariab: begin
      //Caso especial de asignación a puntero derefrrenciado: variable^
      kMOVF(byte1, toW);
      kMOVWF(FSR.addr);  //direcciona
      //Asignación normal
      kMOVF(byte2, toW);
      _ADDWF(0, toF);
    end;
    stExpres: begin  //ya está en w
      //Caso especial de asignación a puntero derefrrenciado: variable^
      aux := GetAuxRegisterByte;
      kMOVWF(aux.addr);   //Salva W (p2)
      //Apunta con p1
      kMOVF(byte1, toW);
      kMOVWF(FSR.addr);  //direcciona
      //Asignación normal
      kMOVF(aux.addr, toW);
      _ADDWF(0, toF);
      aux.used := false;
    end;
    else
      GenError(MSG_UNSUPPORTED); exit;
    end;
  end else begin
    GenError('Cannot assign to this Operand.'); exit;
  end;
end;
procedure TGenCod.ROB_byte_asub_byte(Opt: TxpOperation; SetRes: boolean);
var
  aux: TPicRegister;
  rVar: TxpEleVar;
begin
  //Simplifcamos el caso en que p2, sea de tipo p2^
  if not ChangePointerToExpres(p2^) then exit;
  //Caso especial de asignación
  if p1^.Sto = stVariab then begin
    SetResultNull;  //Fomalmente,  una aisgnación no devuelve valores en Pascal
    //Asignación a una variable
    case p2^.Sto of
    stConst : begin
      if value2=0 then begin
        //Caso especial. No hace nada
      end else begin
        kMOVLW(value2);
        kSUBWF(byte1, toF);
      end;
    end;
    stVariab: begin
      kMOVF(byte2, toW);
      kSUBWF(byte1, toF);
    end;
    stExpres: begin  //ya está en w
      kSUBWF(byte1, toF);
    end;
    else
      GenError(MSG_UNSUPPORTED); exit;
    end;
  end else if p1^.Sto = stExpRef then begin
    {Este es un caso especial de asignación a un puntero a byte dereferenciado, pero
    cuando el valor del puntero es una expresión. Algo así como (ptr + 1)^}
    SetResultNull;  //Fomalmente, una aisgnación no devuelve valores en Pascal
    case p2^.Sto of
    stConst : begin
      //Asignación normal
      if value2=0 then begin
        //Caso especial. No hace nada
      end else begin
        kMOVWF(FSR.addr);  //direcciona
        kMOVLW(value2);
        _SUBWF(0, toF);
      end;
    end;
    stVariab: begin
      kMOVWF(FSR.addr);  //direcciona
      //Asignación normal
      kMOVF(byte2, toW);
      _SUBWF(0, toF);
    end;
    stExpres: begin
      //La dirección está en la pila y la expresión en W
      aux := GetAuxRegisterByte;
      kMOVWF(aux.addr);   //Salva W (p2)
      //Apunta con p1
      rVar := GetVarByteFromStk;
      kMOVF(rVar.addr0, toW);  //opera directamente al dato que había en la pila. Deja en W
      kMOVWF(FSR.addr);  //direcciona
      //Asignación normal
      kMOVF(aux.addr, toW);
      _SUBWF(0, toF);
      aux.used := false;
      exit;
    end;
    else
      GenError(MSG_UNSUPPORTED); exit;
    end;
  end else if p1^.Sto = stVarRef then begin
    //Asignación a una variable
    SetResultNull;  //Fomalmente, una aisgnación no devuelve valores en Pascal
    case p2^.Sto of
    stConst : begin
      //Asignación normal
      if value2=0 then begin
        //Caso especial. No hace nada
      end else begin
        //Caso especial de asignación a puntero dereferenciado: variable^
        kMOVF(byte1, toW);
        kMOVWF(FSR.addr);  //direcciona
        kMOVLW(value2);
        _SUBWF(0, toF);
      end;
    end;
    stVariab: begin
      //Caso especial de asignación a puntero derefrrenciado: variable^
      kMOVF(byte1, toW);
      kMOVWF(FSR.addr);  //direcciona
      //Asignación normal
      kMOVF(byte2, toW);
      _SUBWF(0, toF);
    end;
    stExpres: begin  //ya está en w
      //Caso especial de asignación a puntero derefrrenciado: variable^
      aux := GetAuxRegisterByte;
      kMOVWF(aux.addr);   //Salva W (p2)
      //Apunta con p1
      kMOVF(byte1, toW);
      kMOVWF(FSR.addr);  //direcciona
      //Asignación normal
      kMOVF(aux.addr, toW);
      _SUBWF(0, toF);
      aux.used := false;
    end;
    else
      GenError(MSG_UNSUPPORTED); exit;
    end;
  end else begin
    GenError('Cannot assign to this Operand.'); exit;
  end;
end;
procedure TGenCod.ROB_byte_add_byte(Opt: TxpOperation; SetRes: boolean);
var
  rVar: TxpEleVar;
begin
  if (p1^.Sto = stExpRef) and (p2^.Sto = stExpRef) then begin
    GenError('Too complex pointer expression.'); exit;
  end;
  if not ChangePointerToExpres(p1^) then exit;
  if not ChangePointerToExpres(p2^) then exit;
  case stoOperation of
  stConst_Const: begin
    SetROBResultConst_byte(value1+value2);  //puede generar error
  end;
  stConst_Variab: begin
    if value1 = 0 then begin
      //Caso especial
      SetROBResultVariab(p2^.rVar);  //devuelve la misma variable
      exit;
    end else if value1 = 1 then begin
      //Caso especial
      SetROBResultExpres_byte(Opt);
      kINCF(byte2, toW);
      exit;
    end;
    SetROBResultExpres_byte(Opt);
    kMOVLW(value1);
    kADDWF(byte2, toW);
  end;
  stConst_Expres: begin  //la expresión p2 se evaluó y esta en W
    SetROBResultExpres_byte(Opt);
    kADDLW(value1);  //deja en W
  end;
  stVariab_Const: begin
    ExchangeP1_P2;
    ROB_byte_add_byte(Opt, true);
  end;
  stVariab_Variab:begin
    SetROBResultExpres_byte(Opt);
    kMOVF(byte2, toW);
    kADDWF(byte1, toW);  //deja en W
  end;
  stVariab_Expres:begin   //la expresión p2 se evaluó y esta en W
    SetROBResultExpres_byte(Opt);
    kADDWF(byte1, toW);  //deja en W
  end;
  stExpres_Const: begin   //la expresión p1 se evaluó y esta en W
    SetROBResultExpres_byte(Opt);
    kADDLW(value2);  //deja en W
  end;
  stExpres_Variab:begin  //la expresión p1 se evaluó y esta en W
    SetROBResultExpres_byte(Opt);
    kADDWF(byte2, toW);  //deja en W
  end;
  stExpres_Expres:begin
    SetROBResultExpres_byte(Opt);
    //La expresión p1 debe estar salvada y p2 en el acumulador
    rVar := GetVarByteFromStk;
    kADDWF(rVar.addr0, toW);  //opera directamente al dato que había en la pila. Deja en W
    FreeStkRegisterByte;   //libera pila porque ya se uso
  end;
  else
    genError(MSG_CANNOT_COMPL, [OperationStr(Opt)]);
  end;
end;
procedure TGenCod.ROB_byte_add_word(Opt: TxpOperation; SetRes: boolean);
begin
  if (p1^.Sto = stExpRef) and (p2^.Sto = stExpRef) then begin
    GenError('Too complex pointer expression.'); exit;
  end;
  if not ChangePointerToExpres(p1^) then exit;
  if not ChangePointerToExpres(p2^) then exit;
  case stoOperation of
  stExpres_Expres:begin
    {Este es el único caso que no se puede invertir, por la posición de los operandos en
     la pila.}
    //la expresión p1 debe estar salvada y p2 en el acumulador
    p1^.SetAsVariab(GetVarByteFromStk);  //Convierte a variable
    //Luego el caso es similar a stVariab_Expres
    ROB_byte_add_word(Opt, SetRes);
    FreeStkRegisterByte;   //libera pila porque ya se usó el dato ahí contenido
  end;
  else
    //Para los otros casos, funciona
    ExchangeP1_P2;   //Invierte los operandos
    ROB_word_add_byte(Opt, SetRes); //Y llama a la función opuesta
  end;
end;
procedure TGenCod.ROB_byte_sub_byte(Opt: TxpOperation; SetRes: boolean);
var
  rVar: TxpEleVar;
begin
  if (p1^.Sto = stExpRef) and (p2^.Sto = stExpRef) then begin
    GenError('Too complex pointer expression.'); exit;
  end;
  if not ChangePointerToExpres(p1^) then exit;
  if not ChangePointerToExpres(p2^) then exit;
  case stoOperation of
  stConst_Const:begin  //suma de dos constantes. Caso especial
    SetROBResultConst_byte(value1-value2);  //puede generar error
    exit;  //sale aquí, porque es un caso particular
  end;
  stConst_Variab: begin
    SetROBResultExpres_byte(Opt);
    kMOVF(byte2, toW);
    kSUBLW(value1);   //K - W -> W
  end;
  stConst_Expres: begin  //la expresión p2 se evaluó y esta en W
    SetROBResultExpres_byte(Opt);
    kSUBLW(value1);   //K - W -> W
  end;
  stVariab_Const: begin
    SetROBResultExpres_byte(Opt);
    kMOVLW(value2);
    kSUBWF(byte1, toW);  //F - W -> W
  end;
  stVariab_Variab:begin
    SetROBResultExpres_byte(Opt);
    kMOVF(byte2, toW);
    kSUBWF(byte1, toW);  //F - W -> W
  end;
  stVariab_Expres:begin   //la expresión p2 se evaluó y esta en W
    SetROBResultExpres_byte(Opt);
    kSUBWF(byte1, toW);  //F - W -> W
  end;
  stExpres_Const: begin   //la expresión p1 se evaluó y esta en W
    SetROBResultExpres_byte(Opt);
    kSUBLW(value2);  //K - W -> W
    kSUBLW(0);  //K - W -> W   //invierte W
  end;
  stExpres_Variab:begin  //la expresión p1 se evaluó y esta en W
    SetROBResultExpres_byte(Opt);
    kSUBWF(byte2, toW);  //F - W -> W
    kSUBLW(0);  //K - W -> W   //invierte W
  end;
  stExpres_Expres:begin
    SetROBResultExpres_byte(Opt);
    //la expresión p1 debe estar salvada y p2 en el acumulador
    rVar := GetVarByteFromStk;
    kSUBWF(rVar.addr0, toW);  //opera directamente al dato que había en la pila. Deja en W
    FreeStkRegisterByte;   //libera pila porque ya se uso
  end;
  else
    genError(MSG_CANNOT_COMPL, [OperationStr(Opt)]);
  end;
end;
procedure TGenCod.mul_byte_16(fun: TxpEleFun);
//E * W -> [H:W]  Usa registros: W,H,E,U
//Basado en código de Andrew Warren http://www.piclist.com
var
  LOOP: Word;
begin
    typDWord.DefineRegister;   //Asegura que exista W,H,E,U
    _CLRF (H.offs);
    _CLRF (U.offs);
    _BSF  (U.offs,3);  //8->U
    _RRF  (E.offs,toF);
LOOP:=_PC;
    _BTFSC (_STATUS,0);
    _ADDWF (H.offs,toF);
    _RRF   (H.offs,toF);
    _RRF   (E.offs,toF);
    _DECFSZ(U.offs, toF);
    _GOTO  (LOOP);
    //Realmente el algortimo es: E*W -> [H:E], pero lo convertimos a: E*W -> [H:W]
    _MOVF(E.offs, toW);
    _RETURN;
end;
procedure TGenCod.ROB_byte_mul_byte(Opt: TxpOperation; SetRes: boolean);
var
  rVar: TxpEleVar;
begin
  if (p1^.Sto = stExpRef) and (p2^.Sto = stExpRef) then begin
    GenError('Too complex pointer expression.'); exit;
  end;
  if not ChangePointerToExpres(p1^) then exit;
  if not ChangePointerToExpres(p2^) then exit;
  case stoOperation of
  stConst_Const:begin  //producto de dos constantes. Caso especial
    if value1*value2 < $100 then begin
      SetROBResultConst_byte((value1*value2) and $FF);  //puede generar error
    end else begin
      SetROBResultConst_word((value1*value2) and $FFFF);  //puede generar error
    end;
    exit;  //sale aquí, porque es un caso particular
  end;
  stConst_Variab: begin
    if value1=0 then begin  //caso especial
      SetROBResultConst_byte(0);
      exit;
    end else if value1=1 then begin  //caso especial
      SetROBResultVariab(p2^.rVar);
      exit;
    end else if value1=2 then begin
      SetROBResultExpres_word(Opt);
      _BANKSEL(H.bank);
      _CLRF(H.offs);
      _BCF(_STATUS, _C);
      kRLF(byte2, toW);
      _BANKSEL(H.bank);
      _RLF(H.offs, toF);
      exit;
    end;
    SetROBResultExpres_word(Opt);
    kMOVF(byte2, toW);
    _BANKSEL(E.bank);
    _MOVWF(E.offs);
    kMOVLW(value1);
    _CALL(f_byte_mul_byte_16.adrr);
    AddCallerTo(f_byte_mul_byte_16);
  end;
  stConst_Expres: begin  //la expresión p2 se evaluó y esta en W
    SetROBResultExpres_word(opt);
    kMOVWF(E.addr);
    kMOVLW(value1);
    _CALL(f_byte_mul_byte_16.adrr);
    AddCallerTo(f_byte_mul_byte_16);
  end;
  stVariab_Const: begin
    SetROBResultExpres_word(opt);
    kMOVF(byte1, toW);
    _BANKSEL(E.bank);
    _MOVWF(E.offs);
    kMOVLW(value2);
    _CALL(f_byte_mul_byte_16.adrr);
    AddCallerTo(f_byte_mul_byte_16);
  end;
  stVariab_Variab:begin
    SetROBResultExpres_word(Opt);
    kMOVF(byte1, toW);
    _BANKSEL(E.bank);
    _MOVWF(E.offs);
    kMOVF(byte2, toW);
    _CALL(f_byte_mul_byte_16.adrr);
    AddCallerTo(f_byte_mul_byte_16);
  end;
  stVariab_Expres:begin   //la expresión p2 se evaluó y esta en W
    SetROBResultExpres_word(Opt);
    _BANKSEL(E.bank);
    _MOVWF(E.offs);  //p2 -> E
    kMOVF(byte1, toW); //p1 -> W
    _CALL(f_byte_mul_byte_16.adrr);
    AddCallerTo(f_byte_mul_byte_16);
  end;
  stExpres_Const: begin   //la expresión p1 se evaluó y esta en W
    SetROBResultExpres_word(Opt);
    _BANKSEL(E.bank);
    _MOVWF(E.offs);  //p1 -> E
    kMOVLW(value2); //p2 -> W
    _CALL(f_byte_mul_byte_16.adrr);
    AddCallerTo(f_byte_mul_byte_16);
  end;
  stExpres_Variab:begin  //la expresión p1 se evaluó y esta en W
    SetROBResultExpres_word(Opt);
    _BANKSEL(E.bank);
    _MOVWF(E.offs);  //p1 -> E
    kMOVF(byte2, toW); //p2 -> W
    _CALL(f_byte_mul_byte_16.adrr);
    AddCallerTo(f_byte_mul_byte_16);
  end;
  stExpres_Expres:begin
    SetROBResultExpres_word(Opt);
    //la expresión p1 debe estar salvada y p2 en el acumulador
    rVar := GetVarByteFromStk;
    _BANKSEL(E.bank);
    _MOVWF(E.offs);  //p2 -> E
    kMOVF(rVar.addr0, toW); //p1 -> W
    _CALL(f_byte_mul_byte_16.adrr);
    FreeStkRegisterByte;   //libera pila porque se usará el dato ahí contenido
    {Se podría ahorrar el paso de mover la variable de la pila a W (y luego a una
    variable) temporal, si se tuviera una rutina de multiplicación que compilara a
    partir de la direccion de una variable (en este caso de la pila, que se puede
    modificar), pero es un caso puntual, y podría no reutilizar el código apropiadamente.}
    AddCallerTo(f_byte_mul_byte_16);
  end;
  else
    genError(MSG_CANNOT_COMPL, [OperationStr(Opt)]);
  end;
end;
procedure TGenCod.ROB_byte_mul_word(Opt: TxpOperation; SetRes: boolean);
begin
  if (p1^.Sto = stExpRef) and (p2^.Sto = stExpRef) then begin
    GenError('Too complex pointer expression.'); exit;
  end;
  if not ChangePointerToExpres(p1^) then exit;
  if not ChangePointerToExpres(p2^) then exit;
  case stoOperation of
  stConst_Const:begin  //producto de dos constantes. Caso especial
    if value1*value2 < $100 then begin
      SetROBResultConst_byte((value1*value2) and $FF);  //puede generar error
    end else if value1*value2 < $10000 then begin
      SetROBResultConst_word((value1*value2) and $FFFF);  //puede generar error
    end else begin
      SetROBResultConst_dword((value1*value2) and $FFFFFFFF);  //puede generar error
    end;
    exit;  //sale aquí, porque es un caso particular
  end;
//  stConst_Variab: begin
//    if value1=0 then begin  //caso especial
//      SetROBResultConst_byte(0);
//      exit;
//    end else if value1=1 then begin  //caso especial
//      SetROBResultVariab(p2^.rVar);
//      exit;
//    end else if value1=2 then begin
//      SetROBResultExpres_word(Opt);
//      _BANKSEL(H.bank);
//      _CLRF(H.offs);
//      _BCF(STATUS, _C);
//      _BANKSEL(P2^.bank);
//      _RLF(p2^.offs, toW);
//      _BANKSEL(H.bank);
//      _RLF(H.offs, toF);
//      exit;
//    end;
//    SetROBResultExpres_word(Opt);
//    _BANKSEL(p2^.bank);
//    _MOVF(p2^.offs, toW);
//    _BANKSEL(E.bank);
//    _MOVWF(E.offs);
//    kMOVLW(value1);
//    _CALL(f_byte_mul_byte_16.adrr);
//    AddCallerTo(f_byte_mul_byte_16);
//  end;
//  stConst_Expres: begin  //la expresión p2 se evaluó y esta en W
//    SetROBResultExpres_word(opt);
//    _BANKSEL(E.bank);
//    _MOVWF(E.offs);
//    kMOVLW(value1);
//    _CALL(f_byte_mul_byte_16.adrr);
//    AddCallerTo(f_byte_mul_byte_16);
//  end;
//  stVariab_Const: begin
//    SetROBResultExpres_word(opt);
//    _BANKSEL(p1^.bank);
//    _MOVF(p1^.offs, toW);
//    _BANKSEL(E.bank);
//    _MOVWF(E.offs);
//    kMOVLW(value2);
//    _CALL(f_byte_mul_byte_16.adrr);
//    AddCallerTo(f_byte_mul_byte_16);
//  end;
//  stVariab_Variab:begin
//    SetROBResultExpres_word(Opt);
//    _BANKSEL(p1^.bank);
//    _MOVF(p1^.offs, toW);
//    _BANKSEL(E.bank);
//    _MOVWF(E.offs);
//    _BANKSEL(p2^.bank);
//    _MOVF(p2^.offs, toW);
//    _CALL(f_byte_mul_byte_16.adrr);
//    AddCallerTo(f_byte_mul_byte_16);
//  end;
//  stVariab_Expres:begin   //la expresión p2 se evaluó y esta en W
//    SetROBResultExpres_word(Opt);
//    _BANKSEL(E.bank);
//    _MOVWF(E.offs);  //p2 -> E
//    _BANKSEL(p1^.bank);
//    _MOVF(p1^.offs, toW); //p1 -> W
//    _CALL(f_byte_mul_byte_16.adrr);
//    AddCallerTo(f_byte_mul_byte_16);
//  end;
//  stExpres_Const: begin   //la expresión p1 se evaluó y esta en W
//    SetROBResultExpres_word(Opt);
//    _BANKSEL(E.bank);
//    _MOVWF(E.offs);  //p1 -> E
//    kMOVLW(value2); //p2 -> W
//    _CALL(f_byte_mul_byte_16.adrr);
//    AddCallerTo(f_byte_mul_byte_16);
//  end;
//  stExpres_Variab:begin  //la expresión p1 se evaluó y esta en W
//    SetROBResultExpres_word(Opt);
//    _BANKSEL(E.bank);
//    _MOVWF(E.offs);  //p1 -> E
//    _BANKSEL(p2^.bank);
//    _MOVF(p2^.offs, toW); //p2 -> W
//    _CALL(f_byte_mul_byte_16.adrr);
//    AddCallerTo(f_byte_mul_byte_16);
//  end;
//  stExpres_Expres:begin
//    SetROBResultExpres_word(Opt);
//    //la expresión p1 debe estar salvada y p2 en el acumulador
//    rVar := GetVarByteFromStk;
//    _BANKSEL(E.bank);
//    _MOVWF(E.offs);  //p2 -> E
//    _BANKSEL(rVar.addr0.bank);
//    _MOVF(rVar.addr0.offs, toW); //p1 -> W
//    _CALL(f_byte_mul_byte_16.adrr);
//    FreeStkRegisterByte;   //libera pila porque se usará el dato ahí contenido
//    {Se podría ahorrar el paso de mover la variable de la pila a W (y luego a una
//    variable) temporal, si se tuviera una rutina de multiplicación que compilara a
//    partir de la direccion de una variable (en este caso de la pila, que se puede
//    modificar), pero es un caso puntual, y podría no reutilizar el código apropiadamente.}
//    AddCallerTo(f_byte_mul_byte_16);
//  end;
  else
    genError(MSG_CANNOT_COMPL, [OperationStr(Opt)]);
  end;
end;
procedure TGenCod.byte_div_byte(fun: TxpEleFun);
//H div W -> E  Usa registros: W,H,E,U
//H mod W -> U  Usa registros: W,H,E,U
//Basado en código del libro "MICROCONTROLADOR PIC16F84. DESARROLLO DE PROYECTOS" E. Palacios, F. Remiro y L.J. López
var
  Arit_DivideBit8: Word;
  aux, aux2: TPicRegister;
begin
    typDWord.DefineRegister;   //Asegura que exista W,H,E,U
    aux := GetAuxRegisterByte;  //Pide registro auxiliar
//    aux2 := GetAuxRegisterByte;  //Pide registro auxiliar
    aux2 := FSR;   //utiliza FSR como registro auxiliar
    _MOVWF (aux.offs);
    _clrf   (E.offs);        //En principio el resultado es cero.
    _clrf   (U.offs);
    kMOVLW  (8);             //Carga el contador.
    _movwf  (aux2.offs);
Arit_DivideBit8 := _PC;
    _rlf    (H.offs,toF);
    _rlf    (U.offs,toF);    // (U.offs) contiene el dividendo parcial.
    _movf   (aux.offs,toW);
    _subwf  (U.offs,toW);    //Compara dividendo parcial y divisor.
    _btfsc  (_STATUS,_C);     //Si (dividendo parcial)>(divisor)
    _movwf  (U.offs);        //(dividendo parcial) - (divisor) --> (dividendo parcial)
    _rlf    (E.offs,toF);    //Desplaza el cociente introduciendo el bit apropiado.
    _decfsz (aux2.offs,toF);
    _goto   (Arit_DivideBit8);
    _movf   (E.offs,toW);    //Devuelve también en (W)
    _RETURN;
//    aux2.used := false;
    aux.used := false;
end;
procedure TGenCod.ROB_byte_div_byte(Opt: TxpOperation; SetRes: boolean);
var
  rVar: TxpEleVar;
begin
  if (p1^.Sto = stExpRef) and (p2^.Sto = stExpRef) then begin
    GenError('Too complex pointer expression.'); exit;
  end;
  if not ChangePointerToExpres(p1^) then exit;
  if not ChangePointerToExpres(p2^) then exit;
  case stoOperation of
  stConst_Const:begin  //producto de dos constantes. Caso especial
    if value2 = 0 then begin
      GenError('Cannot divide by zero');
      exit;
    end;
    SetROBResultConst_byte(value1 div value2);  //puede generar error
    exit;  //sale aquí, porque es un caso particular
  end;
  stConst_Variab: begin
    if value1=0 then begin  //caso especial
      SetROBResultConst_byte(0);
      exit;
    end;
    SetROBResultExpres_byte(Opt);
    kMOVLW(value1);
    _BANKSEL(H.bank);
    _MOVWF(H.offs);
    kMOVF(byte2, toW);
    _CALL(f_byte_div_byte.adrr);
    AddCallerTo(f_byte_div_byte);
  end;
  stConst_Expres: begin  //la expresión p2 se evaluó y esta en W
    if value1=0 then begin  //caso especial
      SetROBResultConst_byte(0);
      exit;
    end;
    SetROBResultExpres_byte(Opt);
    _BANKSEL(E.bank);
    _MOVWF(E.offs);  //guarda divisor

    kMOVLW(value1);
    _BANKSEL(H.bank);
    _MOVWF(H.offs);  //dividendo

    _BANKSEL(E.bank);
    _MOVF(E.offs, toW);  //divisor
    _CALL(f_byte_div_byte.adrr);
    AddCallerTo(f_byte_div_byte);
  end;
  stVariab_Const: begin
    if value2 = 0 then begin
      GenError('Cannot divide by zero');
      exit;
    end;
    SetROBResultExpres_byte(Opt);
    kMOVF(byte1, toW);
    _BANKSEL(H.bank);
    _MOVWF(H.offs);
    kMOVLW(value2);
    _CALL(f_byte_div_byte.adrr);
    AddCallerTo(f_byte_div_byte);
  end;
  stVariab_Variab:begin
    SetROBResultExpres_byte(Opt);
    kMOVF(byte1, toW);
    _BANKSEL(H.bank);
    _MOVWF(H.offs);
    kMOVF(byte2, toW);
    _CALL(f_byte_div_byte.adrr);
    AddCallerTo(f_byte_div_byte);
  end;
  stVariab_Expres:begin   //la expresión p2 se evaluó y esta en W
    SetROBResultExpres_byte(Opt);
    //guarda divisor
    _BANKSEL(E.bank);
    _MOVWF(E.offs);
    //p1 -> H
    kMOVF(byte1, toW); //p1 -> W
    _BANKSEL(H.bank);
    _MOVWF(H.offs);  //dividendo

    _BANKSEL(E.bank);
    _MOVF(E.offs, toW);  //divisor
    _CALL(f_byte_div_byte.adrr);
    AddCallerTo(f_byte_div_byte);
  end;
  stExpres_Const: begin   //la expresión p1 se evaluó y esta en W
    if value2 = 0 then begin
      GenError('Cannot divide by zero');
      exit;
    end;
    SetROBResultExpres_byte(Opt);
    _BANKSEL(H.bank);
    _MOVWF(H.offs);  //p1 -> H
    kMOVLW(value2); //p2 -> W
    _CALL(f_byte_div_byte.adrr);
    AddCallerTo(f_byte_div_byte);
  end;
  stExpres_Variab:begin  //la expresión p1 se evaluó y esta en W
    SetROBResultExpres_byte(Opt);
    _BANKSEL(H.bank);
    _MOVWF(H.offs);  //p1 -> H
    kMOVF(byte2, toW); //p2 -> W
    _CALL(f_byte_div_byte.adrr);
    AddCallerTo(f_byte_div_byte);
  end;
  stExpres_Expres:begin
    SetROBResultExpres_byte(Opt);
    //la expresión p1 debe estar salvada y p2 en el acumulador
    rVar := GetVarByteFromStk;
    //guarda divisor
    _BANKSEL(E.bank);
    _MOVWF(E.offs);
    //pila -> H
    kMOVF(rVar.addr0, toW); //p1 -> W
    _BANKSEL(H.bank);
    _MOVWF(H.offs);  //dividendo
    //divisor -> W
    _BANKSEL(E.bank);
    _MOVF(E.offs, toW);  //p2 -> E

    _CALL(f_byte_div_byte.adrr);
    FreeStkRegisterByte;   //libera pila porque se usará el dato ahí contenido
    {Se podría ahorrar el paso de mover la variable de la pila a W (y luego a una
    variable) temporal, si se tuviera una rutina de multiplicación que compilara a
    partir de la direccion de una variable (en este caso de la pila, que se puede
    modificar), pero es un caso puntual, y podría no reutilizar el código apropiadamente.}
    AddCallerTo(f_byte_div_byte);
  end;
  else
    genError(MSG_CANNOT_COMPL, [OperationStr(Opt)]);
  end;
end;
procedure TGenCod.ROB_byte_mod_byte(Opt: TxpOperation; SetRes: boolean);
var
  rVar: TxpEleVar;
begin
  if (p1^.Sto = stExpRef) and (p2^.Sto = stExpRef) then begin
    GenError('Too complex pointer expression.'); exit;
  end;
  if not ChangePointerToExpres(p1^) then exit;
  if not ChangePointerToExpres(p2^) then exit;
  case stoOperation of
  stConst_Const : begin  //producto de dos constantes. Caso especial
    if value2 = 0 then begin
      GenError('Cannot divide by zero');
      exit;
    end;
    SetROBResultConst_byte(value1 mod value2);  //puede generar error
    exit;  //sale aquí, porque es un caso particular
  end;
  stConst_Variab: begin
    if value1=0 then begin  //caso especial
      SetROBResultConst_byte(0);
      exit;
    end;
    SetROBResultExpres_byte(Opt);
    kMOVLW(value1);
    kMOVWF(H.addr);
    kMOVF(byte2, toW);
    _CALL(f_byte_div_byte.adrr);
    //¿Y el banco de salida?
    kMOVF(U.addr, toW);  //Resultado en W
    AddCallerTo(f_byte_div_byte);
  end;
  stConst_Expres: begin  //la expresión p2 se evaluó y esta en W
    if value1=0 then begin  //caso especial
      SetROBResultConst_byte(0);
      exit;
    end;
    SetROBResultExpres_byte(Opt);
    kMOVWF(E.addr);  //guarda divisor
    kMOVLW(value1);
    kMOVWF(H.addr);  //dividendo

    kMOVF(E.addr, toW);  //divisor
    _CALL(f_byte_div_byte.adrr);
    kMOVF(U.addr, toW);  //Resultado en W
    AddCallerTo(f_byte_div_byte);
  end;
  stVariab_Const: begin
    if value2 = 0 then begin
      GenError('Cannot divide by zero');
      exit;
    end;
    SetROBResultExpres_byte(Opt);
    kMOVF(byte1, toW);
    kMOVWF(H.addr);
    kMOVLW(value2);
    _CALL(f_byte_div_byte.adrr);
    kMOVF(U.addr, toW);  //Resultado en W
    AddCallerTo(f_byte_div_byte);
  end;
  stVariab_Variab:begin
    SetROBResultExpres_byte(Opt);
    kMOVF(byte1, toW);
    kMOVWF(H.addr);
    kMOVF(byte2, toW);
    _CALL(f_byte_div_byte.adrr);
    kMOVF(U.addr, toW);  //Resultado en W
    AddCallerTo(f_byte_div_byte);
  end;
  stVariab_Expres:begin   //la expresión p2 se evaluó y esta en W
    SetROBResultExpres_byte(Opt);
    //guarda divisor
    kMOVWF(E.addr);
    //p1 -> H
    kMOVF(byte1, toW); //p1 -> W
    kMOVWF(H.addr);  //dividendo

    kMOVF(E.addr, toW);  //divisor
    _CALL(f_byte_div_byte.adrr);
    kMOVF(U.addr, toW);  //Resultado en W
    AddCallerTo(f_byte_div_byte);
  end;
  stExpres_Const: begin   //la expresión p1 se evaluó y esta en W
    if value2 = 0 then begin
      GenError('Cannot divide by zero');
      exit;
    end;
    SetROBResultExpres_byte(Opt);
    kMOVWF(H.addr);  //p1 -> H
    kMOVLW(value2); //p2 -> W
    _CALL(f_byte_div_byte.adrr);
    kMOVF(U.addr, toW);  //Resultado en W
    AddCallerTo(f_byte_div_byte);
  end;
  stExpres_Variab:begin  //la expresión p1 se evaluó y esta en W
    SetROBResultExpres_byte(Opt);
    kMOVWF(H.addr);  //p1 -> H
    kMOVF(byte2, toW); //p2 -> W
    _CALL(f_byte_div_byte.adrr);
    kMOVF(U.addr, toW);  //Resultado en W
    AddCallerTo(f_byte_div_byte);
  end;
  stExpres_Expres:begin
    SetROBResultExpres_byte(Opt);
    //la expresión p1 debe estar salvada y p2 en el acumulador
    rVar := GetVarByteFromStk;
    //guarda divisor
    kMOVWF(E.addr);
    //pila -> H
    kMOVF(rVar.addr0, toW); //p1 -> W
    kMOVWF(H.addr);  //dividendo
    //divisor -> W
    kMOVF(E.addr, toW);  //p2 -> E
    _CALL(f_byte_div_byte.adrr);
    kMOVF(U.addr, toW);  //Resultado en W
    FreeStkRegisterByte;   //libera pila porque se usará el dato ahí contenido
    {Se podría ahorrar el paso de mover la variable de la pila a W (y luego a una
    variable) temporal, si se tuviera una rutina de multiplicación que compilara a
    partir de la direccion de una variable (en este caso de la pila, que se puede
    modificar), pero es un caso puntual, y podría no reutilizar el código apropiadamente.}
    AddCallerTo(f_byte_div_byte);
  end;
  else
    genError(MSG_CANNOT_COMPL, [OperationStr(Opt)]);
  end;
end;

procedure TGenCod.ROB_byte_great_byte(Opt: TxpOperation; SetRes: boolean);
var
  tmp: TPicRegister;
begin
  if (p1^.Sto = stExpRef) and (p2^.Sto = stExpRef) then begin
    GenError('Too complex pointer expression.'); exit;
  end;
  if not ChangePointerToExpres(p1^) then exit;
  if not ChangePointerToExpres(p2^) then exit;
  case stoOperation of
  stConst_Const: begin  //compara constantes. Caso especial
    SetROBResultConst_bool(value1 > value2);
  end;
  stConst_Variab: begin
    if value1 = 0 then begin
      //0 es mayor que nada
      SetROBResultConst_bool(false);
//      GenWarn('Expression will always be FALSE.');  //o TRUE si la lógica Está invertida
    end else begin
      SetROBResultExpres_bool(Opt, false);   //Se pide Z para el resultado
      kMOVLW(value1);
      kSUBWF(byte2, toW);  //Si p1 > p2: C=0.
      CopyInvert_C_to_Z; //Pasa C a Z (invirtiendo)
    end;
  end;
  stConst_Expres: begin  //la expresión p2 se evaluó y esta en W
    if value1 = 0 then begin
      //0 es mayor que nada
      SetROBResultConst_bool(false);
//      GenWarn('Expression will always be FALSE.');  //o TRUE si la lógica Está invertida
    end else begin
      //Optimiza rutina, usando: A>B  equiv. NOT (B<=A-1)
      //Se necesita asegurar que p1, es mayo que cero.
      SetROBResultExpres_bool(Opt, true);  //invierte la lógica
      //p2, ya está en W
      kSUBLW(value1-1);  //Si p1 > p2: C=0.
      CopyInvert_C_to_Z; //Pasa C a Z (invirtiendo)
    end;
  end;
  stVariab_Const: begin
    if value2 = 255 then begin
      //Nada es mayor que 255
      SetROBResultConst_bool(false);
      GenWarn('Expression will always be FALSE or TRUE.');
    end else begin
      SetROBResultExpres_bool(Opt, false);   //Se pide Z para el resultado
      kMOVF(byte1, toW);
      kSUBLW(value2);  //Si p1 > p2: C=0.
      CopyInvert_C_to_Z; //Pasa C a Z (invirtiendo)
    end;
  end;
  stVariab_Variab:begin
    SetROBResultExpres_bool(Opt, false);   //Se pide Z para el resultado
    kMOVF(byte1, toW);
    kSUBWF(byte2, toW);  //Si p1 > p2: C=0.
    CopyInvert_C_to_Z; //Pasa C a Z (invirtiendo)
  end;
  stVariab_Expres:begin   //la expresión p2 se evaluó y esta en W
    SetROBResultExpres_bool(Opt, false);   //Se pide Z para el resultado
    tmp := GetAuxRegisterByte;  //Se pide registro auxiliar
    kMOVWF(tmp.addr);    //guarda resultado de expresión
    //Ahora es como stVariab_Variab
    kMOVF(byte1, toW);
    kSUBWF(tmp.addr, toW);  //Si p1 > tmp: C=0.
    CopyInvert_C_to_Z; //Pasa C a Z (invirtiendo)
    tmp.used := false;  //libera
  end;
  stExpres_Const: begin   //la expresión p1 se evaluó y esta en W
    if value2 = 255 then begin
      //Nada es mayor que 255
      SetROBResultConst_bool(false);
//      GenWarn('Expression will always be FALSE.');  //o TRUE si la lógica Está invertida
    end else begin
      SetROBResultExpres_bool(Opt, false);   //Se pide Z para el resultado
  //    p1, ya está en W
      kSUBLW(value2);  //Si p1 > p2: C=0.
      CopyInvert_C_to_Z; //Pasa C a Z (invirtiendo)
    end;
  end;
  stExpres_Variab:begin  //la expresión p1 se evaluó y esta en W
    SetROBResultExpres_bool(Opt, false);   //Se pide Z para el resultado
    kSUBWF(byte2, toW);  //Si p1 > p2: C=0.
    CopyInvert_C_to_Z; //Pasa C a Z (invirtiendo)
  end;
  stExpres_Expres:begin
    //la expresión p1 debe estar salvada y p2 en el acumulador
    p1^.SetAsVariab(GetVarByteFromStk);  //Convierte a variable
    //Luego el caso es similar a stVariab_Expres
    ROB_byte_great_byte(Opt, true);
    FreeStkRegisterByte;   //libera pila porque ya se usó el dato ahí contenido
  end;
  else
    genError(MSG_CANNOT_COMPL, [OperationStr(Opt)]);
  end;
end;
procedure TGenCod.ROB_byte_less_byte(Opt: TxpOperation; SetRes: boolean);
begin
  if (p1^.Sto = stExpRef) and (p2^.Sto = stExpRef) then begin
    GenError('Too complex pointer expression.'); exit;
  end;
  if not ChangePointerToExpres(p1^) then exit;
  if not ChangePointerToExpres(p2^) then exit;
  //A < B es lo mismo que B > A
  case stoOperation of
  stExpres_Expres:begin
    {Este es el único caso que no se puede invertir, por la posición de los operandos en
     la pila.}
    //la expresión p1 debe estar salvada y p2 en el acumulador
    p1^.SetAsVariab(GetVarByteFromStk);  //Convierte a variable
    //Luego el caso es similar a stVariab_Expres
    ROB_byte_less_byte(Opt, SetRes);
    FreeStkRegisterByte;   //libera pila porque ya se usó el dato ahí contenido
  end;
  else
    //Para los otros casos, funciona
    ExchangeP1_P2;
    ROB_byte_great_byte(Opt, SetRes);
  end;
end;
procedure TGenCod.ROB_byte_gequ_byte(Opt: TxpOperation; SetRes: boolean);
begin
  ROB_byte_less_byte(Opt, SetRes);
  res.Invert;
end;
procedure TGenCod.ROB_byte_lequ_byte(Opt: TxpOperation; SetRes: boolean);
begin
  ROB_byte_great_byte(Opt, SetRes);
  res.Invert;
end;
procedure TGenCod.CodifShift_by_W(target: TPicRegister; toRight: boolean);
{Desplaza el registro "aux", las veces indicadas en el registro W.
Deja el resultado en W.
Deja el banco, en el banco de "aux"}
{ TODO : Tal vez se pueda optimizar usando una rutina que rote W, las veces indicadas
en un registro, o se podría generar el código usando la rutina de WHILE. }
var
  loop1: Word;
  dg: integer;
  bnkExp1: Byte;
begin
  bnkExp1 := CurrBank;   //Guarda el banco al entrar la rutina
  _ADDLW(1);   //corrige valor inicial
loop1 := _PC;
  _ADDLW(255);  //W=W-1  (no hay instrucción DECW)
  _BTFSC(Z.offs, Z.bit);
  _GOTO_PEND(dg);     //Dio, cero, termina
  //Desplaza
  if toRight then kSHIFTR(target.addr, toF) else kSHIFTL(target.addr, toF);
  _GOTO(loop1);
  //Terminó el lazo
  pic.codGotoAt(dg, _PC);   //termina de codificar el salto
  {El valor del banco RAM al terminar de ejecutarse esta rutina sería:
  * El mismo banco antes de entrar -> Si el lazo no se ejecuto ninguna vez.
  * El mismo banco de "target"     -> Si el lazo se ejecuta al menos una vez.
  Si en "bnkExp1" almacenamos el banco al inicio de la rutina, se concluye entonces
  que:
  * Si "bnkExp1" es igual al banco de "target", No se generan instrucciones de cambio de
  banco y todo trabaja pues no se altera "CurrBank",
  * Si "bnkExp1" es diferente al banco de "target", entonces se generarán instrucciones
  de cambio de banco en el lazo, pero como no sabemos si se ejecutarán, por seguridad
  generamos código obligatorio para fijar siempre el banco de salida en el de "target".}
  if bnkExp1 <> target.bank then begin
    CurrBank := 255;  //Para forzar a generar cambio de banco
    _BANKSEL(target.bank);  //quedará en este banco
  end;
end;
procedure TGenCod.ROB_byte_shr_byte(Opt: TxpOperation; SetRes: boolean);  //Desplaza a la derecha
var
  aux: TPicRegister;
begin
  if (p1^.Sto = stExpRef) and (p2^.Sto = stExpRef) then begin
    GenError('Too complex pointer expression.'); exit;
  end;
  if not ChangePointerToExpres(p1^) then exit;
  if not ChangePointerToExpres(p2^) then exit;
  case stoOperation of
  stConst_Const: begin  //compara constantes. Caso especial
    SetROBResultConst_byte(value1 >> value2);
  end;
//  stConst_Variab: begin
//  end;
//  stConst_Expres: begin  //la expresión p2 se evaluó y esta en W
//  end;
  stVariab_Const: begin
    SetROBResultExpres_byte(Opt);   //Se pide Z para el resultado
    //Verifica casos simples
    if value2 = 0 then begin
      kMOVF(byte1, toW);  //solo devuelve lo mismo en W
    end else if value2 = 1 then begin
      kSHIFTR(byte1, toW);  //devuelve desplazado en W
    end else if value2 = 2 then begin
      aux := GetAuxRegisterByte;
      //copia p1 a "aux"
      kSHIFTR(byte1, toW);  //desplaza y mueve
      kMOVWF(aux.addr);
      kSHIFTR(aux.addr, toW);  //desplaza y devuelve en W
      aux.used := false;
    end else if value2 = 3 then begin
      aux := GetAuxRegisterByte;
      //copia p1 a "aux"
      kSHIFTR(byte1, toW);  //desplaza y mueve
      kMOVWF(aux.addr);
      kSHIFTR(aux.addr, toF);  //desplaza
      kSHIFTR(aux.addr, toW);  //desplaza y devuelve en W
      aux.used := false;
    end else if value2 = 4 then begin
      aux := GetAuxRegisterByte;
      //copia p1 a "aux"
      kSHIFTR(byte1, toW);  //desplaza y mueve
      kMOVWF(aux.addr);
      kSHIFTR(aux.addr, toF);  //desplaza
      kSHIFTR(aux.addr, toF);  //desplaza
      kSHIFTR(aux.addr, toW);  //desplaza y devuelve en W
      aux.used := false;
    end else begin
      //Caso general
      aux := GetAuxRegisterByte;
      //copia p1 a "aux"
      kMOVF(byte1, toW);
      kMOVWF(aux.addr);
      //copia p2 a W
      kMOVLW(value2);
      //lazo de rotación
      CodifShift_by_W(aux, true);
      kMOVF(aux.addr, toW);  //deja en W
      aux.used := false;
    end;
  end;
  stVariab_Variab:begin
    SetROBResultExpres_byte(Opt);   //Se pide Z para el resultado
    aux := GetAuxRegisterByte;
    //copia p1 a "aux"
    kMOVF(byte1, toW);
    kMOVWF(aux.addr);
    //copia p2 a W
    kMOVF(byte2, toW);
    //lazo de rotación
    CodifShift_by_W(aux, true);
    kMOVF(aux.addr, toW);  //deja en W
    aux.used := false;
  end;
//  stVariab_Expres:begin   //la expresión p2 se evaluó y esta en W
//  end;
  stExpres_Const: begin   //la expresión p1 se evaluó y esta en W
    SetROBResultExpres_byte(Opt);   //Se pide Z para el resultado
    //Verifica casos simples
    if value2 = 0 then begin
      //solo devuelve lo mismo en W
    end else if value2 = 1 then begin
      aux := GetAuxRegisterByte;
      kMOVWF(aux.addr);
      kSHIFTR(aux.addr, toW);  //devuelve desplazado en W
      aux.used := false;
    end else if value2 = 2 then begin
      aux := GetAuxRegisterByte;
      kMOVWF(aux.addr);   //copia p1 a "aux"
      kSHIFTR(aux.addr, toF);  //desplaza
      kSHIFTR(aux.addr, toW);  //desplaza y devuelve en W
      aux.used := false;
    end else if value2 = 3 then begin
      aux := GetAuxRegisterByte;
      kMOVWF(aux.addr);   //copia p1 a "aux"
      kSHIFTR(aux.addr, toF);  //desplaza
      kSHIFTR(aux.addr, toF);  //desplaza
      kSHIFTR(aux.addr, toW);  //desplaza y devuelve en W
      aux.used := false;
    end else if value2 = 4 then begin
      aux := GetAuxRegisterByte;
      kMOVWF(aux.addr);   //copia p1 a "aux"
      kSHIFTR(aux.addr, toF);  //desplaza
      kSHIFTR(aux.addr, toF);  //desplaza
      kSHIFTR(aux.addr, toF);  //desplaza
      kSHIFTR(aux.addr, toW);  //desplaza y devuelve en W
      aux.used := false;
    end else begin
      aux := GetAuxRegisterByte;
      //copia p1 a "aux"
      kMOVWF(aux.addr);
      //copia p2 a W
      kMOVLW(value2);
      //lazo de rotación
      CodifShift_by_W(aux, true);
      kMOVF(aux.addr, toW);  //deja en W
      aux.used := false;
    end;
  end;
//  stExpres_Variab:begin  //la expresión p1 se evaluó y esta en W
//  end;
//  stExpres_Expres:begin
//  end;
  else
    genError(MSG_CANNOT_COMPL, [OperationStr(Opt)]);
  end;
end;
procedure TGenCod.ROB_byte_shl_byte(Opt: TxpOperation; SetRes: boolean);   //Desplaza a la izquierda
var
  aux: TPicRegister;
begin
  if (p1^.Sto = stExpRef) and (p2^.Sto = stExpRef) then begin
    GenError('Too complex pointer expression.'); exit;
  end;
  if not ChangePointerToExpres(p1^) then exit;
  if not ChangePointerToExpres(p2^) then exit;
  case stoOperation of
  stConst_Const: begin  //compara constantes. Caso especial
    SetROBResultConst_byte(value1 << value2);
  end;
//  stConst_Variab: begin
//  end;
//  stConst_Expres: begin  //la expresión p2 se evaluó y esta en W
//  end;
  stVariab_Const: begin
    SetROBResultExpres_byte(Opt);   //Se pide Z para el resultado
    //Verifica casos simples
    if value2 = 0 then begin
      kMOVF(byte1, toW);  //solo devuelve lo mismo en W
    end else if value2 = 1 then begin
      kSHIFTL(byte1, toW);  //devuelve desplazado en W
    end else if value2 = 2 then begin
      aux := GetAuxRegisterByte;
      //copia p1 a "aux"
      kSHIFTL(byte1, toW);  //desplaza y mueve
      kMOVWF(aux.addr);
      kSHIFTL(aux.addr, toW);  //desplaza y devuelve en W
      aux.used := false;
    end else if value2 = 3 then begin
      aux := GetAuxRegisterByte;
      //copia p1 a "aux"
      kSHIFTL(byte1, toW);  //desplaza y mueve
      kMOVWF(aux.addr);
      kSHIFTL(aux.addr, toF);  //desplaza
      kSHIFTL(aux.addr, toW);  //desplaza y devuelve en W
      aux.used := false;
    end else if value2 = 4 then begin
      aux := GetAuxRegisterByte;
      //copia p1 a "aux"
      kSHIFTL(byte1, toW);  //desplaza y mueve
      kMOVWF(aux.addr);
      kSHIFTL(aux.addr, toF);  //desplaza
      kSHIFTL(aux.addr, toF);  //desplaza
      kSHIFTL(aux.addr, toW);  //desplaza y devuelve en W
      aux.used := false;
    end else begin
      aux := GetAuxRegisterByte;
      //copia p1 a "aux"
      kMOVF(byte1, toW);
      kMOVWF(aux.addr);
      //copia p2 a W
      kMOVLW(value2);
      //lazo de rotación
      CodifShift_by_W(aux, false);
      kMOVF(aux.addr, toW);  //deja en W
      aux.used := false;
    end;
  end;
  stVariab_Variab:begin
    SetROBResultExpres_byte(Opt);   //Se pide Z para el resultado
    aux := GetAuxRegisterByte;
    //copia p1 a "aux"
    kMOVF(byte1, toW);
    kMOVWF(aux.addr);
    //copia p2 a W
    kMOVF(byte2, toW);
    //lazo de rotación
    CodifShift_by_W(aux, false);
    kMOVF(aux.addr, toW);  //deja en W
    aux.used := false;
  end;
//  stVariab_Expres:begin   //la expresión p2 se evaluó y esta en W
//  end;
  stExpres_Const: begin   //la expresión p1 se evaluó y esta en W
    SetROBResultExpres_byte(Opt);   //Se pide Z para el resultado
    //Verifica casos simples
    if value2 = 0 then begin
      //solo devuelve lo mismo en W
    end else if value2 = 1 then begin
      aux := GetAuxRegisterByte;
      kMOVWF(aux.addr);
      kSHIFTL(aux.addr, toW);  //devuelve desplazado en W
      aux.used := false;
    end else if value2 = 2 then begin
      aux := GetAuxRegisterByte;
      kMOVWF(aux.addr);   //copia p1 a "aux"
      kSHIFTL(aux.addr, toF);  //desplaza
      kSHIFTL(aux.addr, toW);  //desplaza y devuelve en W
      aux.used := false;
    end else if value2 = 3 then begin
      aux := GetAuxRegisterByte;
      kMOVWF(aux.addr);   //copia p1 a "aux"
      kSHIFTL(aux.addr, toF);  //desplaza
      kSHIFTL(aux.addr, toF);  //desplaza
      kSHIFTL(aux.addr, toW);  //desplaza y devuelve en W
      aux.used := false;
    end else if value2 = 4 then begin
      aux := GetAuxRegisterByte;
      kMOVWF(aux.addr);   //copia p1 a "aux"
      kSHIFTL(aux.addr, toF);  //desplaza
      kSHIFTL(aux.addr, toF);  //desplaza
      kSHIFTL(aux.addr, toF);  //desplaza
      kSHIFTL(aux.addr, toW);  //desplaza y devuelve en W
      aux.used := false;
    end else begin
      aux := GetAuxRegisterByte;
      //copia p1 a "aux"
      kMOVWF(aux.addr);
      //copia p2 a W
      kMOVLW(value2);
      //lazo de rotación
      CodifShift_by_W(aux, false);
      kMOVF(aux.addr, toW);  //deja en W
      aux.used := false;
    end;
  end;
//  stExpres_Variab:begin  //la expresión p1 se evaluó y esta en W
//  end;
//  stExpres_Expres:begin
//  end;
  else
    genError(MSG_CANNOT_COMPL, [OperationStr(Opt)]);
  end;
end;
//////////// Operaciones con Word
procedure TGenCod.ROB_word_great_word(Opt: TxpOperation; SetRes: boolean);
  procedure codVariab_Const;
  {Codifica el caso variable (p1) - constante (p2)}
  var
    sale: integer;
  begin
    if value2 = $FFFF then begin
      //Nada es mayor que $FFFF
      SetROBResultConst_bool(false);
      GenWarn('Expression will always be FALSE or TRUE.');
    end else begin
      //Compara byte alto
      kMOVF(byte1H, toW);
      kSUBLW(value2H); //p2-p1
      _BTFSS(Z.offs, Z.bit);
      _GOTO_PEND(sale);  //no son iguales
      //Son iguales, comparar el byte bajo
      kMOVF(byte1L, toW);
      kSUBLW(value2L);	//p2-p1
  _LABEL(sale); //Si p1=p2 -> Z=1. Si p1>p2 -> C=0.
      CopyInvert_C_to_Z;  //Pasa a Z
    end;
  end;
  procedure codVariab_Variab;
  var
    sale: integer;
  begin
    //Compara byte alto
    kMOVF(byte1H, toW);
    kSUBWF(byte2H, toW); //p2-p1
    _BTFSS(Z.offs, Z.bit);
    _GOTO_PEND(sale);  //no son iguales
    //Son iguales, comparar el byte bajo
    kMOVF(byte1L, toW);
    kSUBWF(byte2L, toW);	//p2-p1
_LABEL(sale); //Si p1=p2 -> Z=1. Si p1>p2 -> C=0.
    CopyInvert_C_to_Z;  //Pasa a Z
  end;
var
  tmp, aux: TPicRegister;
  sale: integer;
  varTmp: TxpEleVar;
begin
  case stoOperation of
  stConst_Const: begin  //compara constantes. Caso especial
    SetROBResultConst_bool(value1 > value2);
  end;
  stConst_Variab: begin
    if value1 = 0 then begin
      //0 es mayor que nada
      SetROBResultConst_bool(false);
      GenWarn('Expression will always be FALSE or TRUE.');
      {No se define realmente el mensaje (si es con TRUE o FALSE), porque
      ROB_word_great_word(), es también llamado, por Oper_word_lequ_word para con
      lógica invertida}
    end else begin
      SetROBResultExpres_bool(Opt, false);   //Se pide Z para el resultado
      //Compara byte alto
      kMOVLW(value1H);
      kSUBWF(byte2H, toW); //p2-p1
      _BTFSS(Z.offs, Z.bit);
      _GOTO_PEND(sale);  //no son iguales
      //Son iguales, comparar el byte bajo
      kMOVLW(value1L);
      kSUBWF(byte2L, toW);	//p2-p1
  _LABEL(sale); //Si p1=p2 -> Z=1. Si p1>p2 -> C=0.
      CopyInvert_C_to_Z;  //Pasa a Z
    end;
  end;
  stConst_Expres: begin  //la expresión p2 se evaluó p2 esta en W
    SetROBResultExpres_bool(Opt, false);   //Se pide Z para el resultado
    tmp := GetAuxRegisterByte;
    _BANKSEL(tmp.bank);
    _MOVWF(tmp.offs);   //salva byte bajo de Expresión
    //Compara byte alto
    kMOVLW(value1H);
    _BANKSEL(H.bank);  //verifica banco destino
    _SUBWF(H.offs, toW); //p2-p1
    _BTFSS(Z.offs, Z.bit);
    _GOTO_PEND(sale);  //no son iguales
    //Son iguales, comparar el byte bajo
    kMOVLW(value1L);
    _BANKSEL(tmp.bank);  //verifica banco destino
    _SUBWF(tmp.offs,toW);	//p2-p1
_LABEL(sale); //Si p1=p2 -> Z=1. Si p1>p2 -> C=0.
    CopyInvert_C_to_Z;  //Pasa a Z
    tmp.used := false;
  end;
  stVariab_Const: begin
    SetROBResultExpres_bool(Opt, false);   //Se pide Z para el resultado
    codVariab_Const;
  end;
  stVariab_Variab:begin
    SetROBResultExpres_bool(Opt, false);   //Se pide Z para el resultado
    codVariab_Variab;
  end;
  stVariab_Expres:begin   //la expresión p2 se evaluó y esta en H,W
    SetROBResultExpres_bool(Opt, false);   //Se pide Z para el resultado
    tmp := GetAuxRegisterByte;
    _BANKSEL(tmp.bank);
    _MOVWF(tmp.offs);   //salva byte bajo de Expresión
    //Compara byte alto
    kMOVF(byte1H, toW);
    _BANKSEL(H.bank);  //verifica banco destino
    _SUBWF(H.offs, toW); //p2-p1
    _BTFSS(Z.offs, Z.bit);
    _GOTO_PEND(sale);  //no son iguales
    //Son iguales, comparar el byte bajo
    kMOVF(byte1L, toW);
    _BANKSEL(tmp.bank);  //verifica banco destino
    _SUBWF(tmp.offs,toW);	//p2-p1
    tmp.used := false;
_LABEL(sale); //Si p1=p2 -> Z=1. Si p1>p2 -> C=0.
    CopyInvert_C_to_Z;  //Pasa a Z
  end;
  stExpres_Const: begin   //la expresión p1 se evaluó y esta en H,W
    SetROBResultExpres_bool(Opt, false);   //Se pide Z para el resultado
    aux := GetAuxRegisterByte;  //Pide un registro libre
    _MOVWF(aux.offs);  //guarda W
    varTmp := NewTmpVarWord(aux.addr, H.addr);  //Crea variable temporal
    p1^.SetAsVariab(varTmp);  //para que se pueda procesar como variable
    codVariab_Const;      //Lo evalúa como stVariab_Const
    varTmp.Destroy;
    aux.used := false;
  end;
  stExpres_Variab:begin  //la expresión p1 se evaluó y esta en H,W
    SetROBResultExpres_bool(Opt, false);   //Se pide Z para el resultado
    aux := GetAuxRegisterByte;  //Pide un registro libre
    _MOVWF(aux.offs);  //guarda W
    varTmp := NewTmpVarWord(aux.addr, H.addr);  //Crea variable temporal
    p1^.SetAsVariab(varTmp);  //para que se pueda procesar como variable
    codVariab_Variab;      //Lo evalúa como stVariab_Variab;
    varTmp.Destroy;
    aux.used := false;
  end;
  stExpres_Expres:begin
    //La expresión p1, debe estar salvada y p2 en (H,W)
    p1^.SetAsVariab(GetVarWordFromStk);
    //Luego el caso es similar a variable-expresión
    ROB_word_great_word(Opt, SetRes);
    FreeStkRegisterWord;
  end;
  else
    genError(MSG_CANNOT_COMPL, [OperationStr(Opt)]);
  end;
end;
procedure TGenCod.ROB_word_add_word(Opt: TxpOperation; SetRes: boolean);
var
  aux: TPicRegister;
begin
  if (p1^.Sto = stExpRef) and (p2^.Sto = stExpRef) then begin
    GenError('Too complex pointer expression.'); exit;
  end;
  if not ChangePointerToExpres(p1^) then exit;
  if not ChangePointerToExpres(p2^) then exit;
  case stoOperation of
  stConst_Const: begin
    if value1+value2 <256 then begin
      //Optimiza
      SetROBResultConst_byte(value1+value2);
    end else begin
      SetROBResultConst_word(value1+value2);
    end;
  end;
  stConst_Variab: begin
    SetROBResultExpres_word(Opt);
{     aux := GetUnusedByteRegister;  //Pide un registro libre
    kMOVLW(value1L);      //Carga menos peso del dato 1
    _addwf(byte2L,toW);  //Suma menos peso del dato 2
    _movwf(aux);             //Almacena el resultado
    kMOVLW(value1H);      //Carga más peso del dato 1
    _btfsc(STATUS,_C);    //Hubo acarreo anterior?
    _addlw(1);             //Si, suma 1 al acumulador
    _addwf(byte2H,toW);  //Suma más peso del dato 2
    _movwf(H);             //Guarda el resultado
    _movf(aux,toW);          //deja byte bajo en W
    aux.Used := false;
}
    //versión más corta que solo usa H, por validar
    kMOVLW(value1H);      //Carga más peso del dato 1
    kADDWF(byte2H, toW);  //Suma más peso del dato 2
    _movwf(H.offs);         //Guarda el resultado
    kMOVLW(value1L);      //Carga menos peso del dato 1
    kADDWF(byte2L, toW);  //Suma menos peso del dato 2, deja en W
    _btfsc(_STATUS,_C);     //Hubo acarreo anterior?
    _incf(H.offs, toF);
  end;
  stConst_Expres: begin  //la expresión p2 se evaluó y esta en (H,W)
    SetROBResultExpres_word(Opt);
    aux := GetAuxRegisterByte;  //Pide un registro libre
    _movwf(aux.offs);             //guarda byte bajo
    kMOVLW(value1H);      //Carga más peso del dato 1
    _addwf(H.offs,toF);         //Suma y guarda
    kMOVLW(value1L);      //Carga menos peso del dato 1
    _addwf(aux.offs,toW);         //Suma menos peso del dato 2, deja en W
    _btfsc(_STATUS,_C);    //Hubo acarreo anterior?
    _incf(H.offs, toF);
    aux.used := false;
  end;
  stVariab_Const: begin
    SetROBResultExpres_word(Opt);
    kMOVLW(value2H);      //Carga más peso del dato 1
    kADDWF(byte1H, toW);  //Suma más peso del dato 2
    _MOVWF(H.offs);         //Guarda el resultado
    kMOVLW(value2L);      //Carga menos peso del dato 1
    kADDWF(byte1L, toW);  //Suma menos peso del dato 2, deja en W
    _BTFSC(_STATUS,_C);     //Hubo acarreo anterior?
    _INCF(H.offs, toF);
  end;
  stVariab_Variab:begin
    SetROBResultExpres_word(Opt);
    kMOVF(byte1H, toW);  //Carga mayor peso del dato 1
    kADDWF(byte2H, toW);  //Suma mayor peso del dato 2
    _MOVWF(H.offs);         //Guarda mayor peso del resultado
    kMOVF(byte1L, toW);  //Carga menos peso del dato 1
    kADDWF(byte2L, toW);  //Suma menos peso del dato 2, deja en W
    _BTFSC(_STATUS,_C);     //Hubo acarreo anterior?
    _INCF(H.offs, toF);
  end;
  stVariab_Expres:begin   //la expresión p2 se evaluó y esta en (H,W)
    SetROBResultExpres_word(Opt);
    aux := GetAuxRegisterByte;  //Pide un registro libre
    _BANKSEL(aux.bank);
    _movwf(aux.offs);        //guarda byte bajo
    kMOVF(byte1H, toW);   //Carga más peso del dato 1
    _BANKSEL(H.bank);
    _addwf(H.offs,toF);      //Suma y guarda
    //Siguiente byte
    kMOVF(byte1L, toW);       //Carga menos peso del dato 1
    _BANKSEL(aux.bank);
    _addwf(aux.offs,toW);    //Suma menos peso del dato 2, deja en W
    _btfsc(_STATUS,_C);      //Hubo acarreo anterior?
    _incf(H.offs, toF);
    aux.used := false;
  end;
  stExpres_Const: begin   //la expresión p1 se evaluó y esta en (H,W)
    SetROBResultExpres_word(Opt);
    aux := GetAuxRegisterByte;  //Pide un registro libre
    _movwf(aux.offs);             //guarda byte bajo
    kMOVLW(value2H);      //Carga más peso del dato 1
    _addwf(H.offs,toF);         //Suma y guarda
    kMOVLW(value2L);      //Carga menos peso del dato 1
    _addwf(aux.offs,toW);         //Suma menos peso del dato 2, deja en W
    _btfsc(_STATUS,_C);    //Hubo acarreo anterior?
    _incf(H.offs, toF);
    aux.used := false;
  end;
  stExpres_Variab:begin  //la expresión p1 se evaluó y esta en (H,W)
    SetROBResultExpres_word(Opt);
    aux := GetAuxRegisterByte;  //Pide un registro libre
    _movwf(aux.offs);      //guarda byte bajo
    kMOVF(byte2H, toW);     //Carga más peso del dato 1
    _BANKSEL(H.bank);
    _addwf(H.offs,toF);    //Suma y guarda
    kMOVF(byte2L, toW);     //Carga menos peso del dato 1
    _BANKSEL(aux.bank);
    _addwf(aux.offs,toW);  //Suma menos peso del dato 2, deja en W
    _BANKSEL(H.bank);
    _btfsc(_STATUS,_C);    //Hubo acarreo anterior?
    _incf(H.offs, toF);
    aux.used := false;
  end;
  stExpres_Expres:begin
    SetROBResultExpres_word(Opt);
    //p1 está salvado en pila y p2 en (_H,W)
    p1^.SetAsVariab(GetVarWordFromStk);  //Convierte a variable
    //Luego el caso es similar a stVariab_Expres
    ROB_word_add_word(Opt, SetRes);
    FreeStkRegisterWord;   //libera pila, obtiene dirección
  end;
  else
    genError(MSG_CANNOT_COMPL, [OperationStr(Opt)]);
  end;
end;
procedure TGenCod.ROB_word_add_byte(Opt: TxpOperation; SetRes: boolean);
var
  aux: TPicRegister;
begin
  case stoOperation of
  stConst_Const: begin
    if value1+value2 <256 then begin
      //Optimiza
      SetROBResultConst_byte(value1+value2);
    end else begin
      SetROBResultConst_word(value1+value2);
    end;
  end;
  stConst_Variab: begin
    SetROBResultExpres_word(Opt);
    //versión más corta que solo usa _H, por validar
    kMOVLW(value1H);      //Carga más peso del dato 1
    _BANKSEL(H.bank);
    _movwf(H.offs);
    kMOVLW(value1L);      //Carga menos peso del dato 1
    kADDWF(byte2L, toW);  //Suma menos peso del dato 2, deja en W
    _btfsc(_STATUS,_C);    //Hubo acarreo anterior?
    _incf(H.offs, toF);
  end;
  stConst_Expres: begin  //la expresión p2 se evaluó y esta en (W)
    SetROBResultExpres_word(Opt);
    aux := GetAuxRegisterByte;  //Pide un registro libre
    _BANKSEL(aux.bank);
    _movwf(aux.offs);      //guarda byte bajo
    kMOVLW(value1H);     //Carga más peso del dato 1
    _BANKSEL(H.bank);
    _movwf(H.offs);
    kMOVLW(value1L);     //Carga menos peso del dato 1
    _BANKSEL(aux.bank);
    _addwf(aux.offs,toW);  //Suma menos peso del dato 2, deja en W
    _BANKSEL(H.bank);      //se cambia primero el banco, por si acaso.
    _btfsc(_STATUS,_C);    //Hubo acarreo anterior?
    _incf(H.offs, toF);
    aux.used := false;
  end;
  stVariab_Const: begin
    SetROBResultExpres_word(Opt);
    kMOVF(byte1H, toW); //Carga más peso del dato 1
    _BANKSEL(H.bank);      //se cambia primero el banco por si acaso
    _MOVWF(H.offs);        //Guarda el resultado
    kMOVLW(value2L);
    kADDWF(byte1L, toW); //Suma menos peso del dato 2, deja en W
    _BANKSEL(H.bank);      //se cambia primero el banco, por si acaso.
    _BTFSC(_STATUS,_C);    //Hubo acarreo anterior?
    _INCF(H.offs, toF);
  end;
  stVariab_Variab:begin
    SetROBResultExpres_word(Opt);
    kMOVF(byte1H, toW);     //Carga más peso del dato 1
    _BANKSEL(H.bank);
    _MOVWF(H.offs);
    kMOVF(byte1L, toW);     //Carga menos peso del dato 1
    kADDWF(byte2L, toW); //Suma menos peso del dato 2, deja en W
    _BANKSEL(H.bank);      //se cambia primero el banco, por si acaso.
    _BTFSC(_STATUS,_C);    //Hubo acarreo anterior?
    _INCF(H.offs, toF);
  end;
  stVariab_Expres:begin   //la expresión p2 se evaluó y esta en (_H,W)
    SetROBResultExpres_word(Opt);
    aux := GetAuxRegisterByte;  //Pide un registro libre
    _BANKSEL(aux.bank);
    _movwf(aux.offs);        //guarda byte de expresión
    kMOVF(byte1H, toW);  //Carga Hbyte del dato 1
    _BANKSEL(H.bank);
    _movwf(H.offs);        //Lo deja para devolver en H
    _BANKSEL(aux.bank);
    _MOVF(aux.offs,toW);   //recupera byte de expresión
    kADDWF(byte1L, toW);  //Suma menos peso del dato 2, deja en W
    _BANKSEL(H.bank);      //se cambia primero el banco, por si acaso.
    _btfsc(_STATUS,_C);    //Hubo acarreo anterior?
    _incf(H.offs, toF);
    aux.used := false;
  end;
  stExpres_Const: begin   //la expresión p1 se evaluó y esta en (H,W)
    SetROBResultExpres_word(Opt);
    kADDLW(value2);     //Suma menos peso del dato 2, deja en W
    _BANKSEL(H.bank);      //se cambia primero el banco, por si acaso.
    _btfsc(_STATUS,_C);    //Hubo acarreo anterior?
    _incf(H.offs, toF);
  end;
  stExpres_Variab:begin  //la expresión p1 se evaluó y esta en (H,W)
    SetROBResultExpres_word(Opt);
    kADDWF(byte2L, toW);         //Suma menos peso del dato 2, deja en W
    _BANKSEL(H.bank);      //se cambia primero el banco, por si acaso.
    _btfsc(_STATUS,_C);    //Hubo acarreo anterior?
    _incf(H.offs, toF);
  end;
  stExpres_Expres:begin
    SetROBResultExpres_word(Opt);
    //p1 está salvado en pila y p2 en (_H,W)
    p1^.SetAsVariab(GetVarWordFromStk);  //Convierte a variable
    //Luego el caso es similar a stVariab_Expres
    ROB_word_add_byte(Opt, SetRes);
    FreeStkRegisterWord;   //libera pila
  end;
  else
    genError(MSG_CANNOT_COMPL, [OperationStr(Opt)]);
  end;
end;
procedure TGenCod.ROB_word_sub_word(Opt: TxpOperation; SetRes: boolean);
var
  aux: TPicRegister;
begin
  if (p1^.Sto = stExpRef) and (p2^.Sto = stExpRef) then begin
    GenError('Too complex pointer expression.'); exit;
  end;
  if not ChangePointerToExpres(p1^) then exit;
  if not ChangePointerToExpres(p2^) then exit;
  case stoOperation of
  stConst_Const: begin
    if value1-value2 < 0 then begin
      genError('Numeric value exceeds a word range.');
      exit;
    end;
    if value1-value2 <256 then begin
      //Optimiza
      SetROBResultConst_byte(value1-value2);
    end else begin
      SetROBResultConst_word(value1-value2);
    end;
  end;
  stConst_Variab: begin
    SetROBResultExpres_word(Opt);
    kMOVF (byte2H, toW); //p2->w
    kSUBLW(value1H);     //p1 - W -W
    kMOVWF(H.addr);
    kMOVF (byte2L, toW); //p2-W
    kSUBLW(value1L);     //p1-W->w
    _BANKSEL(H.bank);    //Para fijar el banco de salida de la condicional
    _BTFSS(_STATUS, _C);
    _DECF (H.offs, toF);
  end;
  stConst_Expres: begin  //la expresión p2 se evaluó y esta en (H,W)
    SetROBResultExpres_word(Opt);
    aux := GetAuxRegisterByte;
    kMOVWF(aux.addr);
    kMOVF(H.addr, toW);    //p2->w
    kSUBLW(value1H);     //p1 - W -W
    kMOVWF(H.addr);
    kMOVF (aux.addr, toW);  //p2-W
    kSUBLW(value1L);     //p1-W->w
    _BANKSEL(H.bank);    //Para fijar el banco de salida de la condicional
    _BTFSS(_STATUS, _C);
    _DECF (H.offs, toF);
    aux.used := false;
  end;
  stVariab_Const: begin
    SetROBResultExpres_word(Opt);
    kMOVLW(value2H);
    kSUBWF(byte1H,toW);
    _movwf(H.offs);
    kMOVLW(value2L);
    kSUBWF(byte1L, toW);
    _btfss(_STATUS, _C);
    _decf(H.offs,toF);
  end;
  stVariab_Variab:begin  //p1 - p2
    SetROBResultExpres_word(Opt);
    kMOVF (byte2H, toW);
    kSUBWF(byte1H,toW);
    _movwf(H.offs);
    kMOVF (byte2L, toW);
    kSUBWF(byte1L,toW);
    _btfss(_STATUS, _C);
    _decf(H.offs,toF);
  end;
  stVariab_Expres:begin   //la expresión p2 se evaluó y esta en (H,W)
    SetROBResultExpres_word(Opt);
    aux := GetAuxRegisterByte;  //Pide un registro libre
    _MOVWF(aux.offs);
    _movf (H.offs,toW);
    kSUBWF(byte1H,toW);
    _movwf(H.offs);
    _movf (aux.offs,toW);
    kSUBWF(byte1L, toW);
    _btfss(_STATUS, _C);
    _decf(H.offs,toF);
    aux.used := false;
  end;
  stExpres_Const: begin   //la expresión p1 se evaluó y esta en (H,W)
    SetROBResultExpres_word(Opt);
    aux := GetAuxRegisterByte;  //Pide un registro libre
    _MOVWF(aux.offs);
    kMOVLW(value2H);
    _subwf(H.offs, toF);
    kMOVLW(value2L);
    _subwf(aux.offs,toW);
    _btfss(_STATUS, _C);
    _decf(H.offs,toF);
    aux.used := false;
  end;
  stExpres_Variab:begin  //la expresión p1 se evaluó y esta en (H,W)
    SetROBResultExpres_word(Opt);
    aux := GetAuxRegisterByte;  //Pide un registro libre
    _MOVWF(aux.offs);
    kMOVF(byte2H, toW);
    _subwf(H.offs, toF);
    kMOVF(byte2L, toW);
    _subwf(aux.offs,toW);
    _btfss(_STATUS, _C);
    _decf(H.offs,toF);
    aux.used := false;
  end;
  stExpres_Expres:begin
    SetROBResultExpres_word(Opt);
    //p1 está salvado en pila y p2 en (_H,W)
    p1^.SetAsVariab(GetVarWordFromStk);  //Convierte a variable
    //Luego el caso es similar a stVariab_Expres
    ROB_word_sub_word(Opt, SetRes);
    FreeStkRegisterWord;   //libera pila, obtiene dirección
  end;
  else
    genError(MSG_CANNOT_COMPL, [OperationStr(Opt)]);
  end;
end;
procedure TGenCod.word_mul_word_16(fun: TxpEleFun);
var
  SYSTMP00, SYSTMP01, SYSTMP02: TPicRegister;
  MUL16LOOP: Word;
begin
   //[H_W] = [H_W] x [E_U]
   // RES  =  OP_A x OP_B
   //SYSTMP00 variable temporal. Contiene RES.LOW (resultado.LOW de la multiplicación)
   //SYSTMP01 variable temporal. Contiene OP_A.LOW  (inicialmente W)
   //SYSTMP02 variable temporal. Contiene OP_A.HIGH (inicialmente _H)
   //_H contine durante todo el bucle de multiplicación la parte alta de resultado (RES.HIGH)
   StartCodeSub(fun);  //inicia codificación
   typWord.DefineRegister;   //Asegura que exista H,W.
   SYSTMP00 := GetAuxRegisterByte;  //Pide un registro libre
   SYSTMP01  := GetAuxRegisterByte;  //Pide un registro libre
   SYSTMP02  := GetAuxRegisterByte;  //Pide un registro libre
   if HayError then exit;
   _CLRF    (SYSTMP00.offs);    //Clear RES.LOW
   _MOVWF   (SYSTMP01.offs);    //OP_A.LOW  := W
   _MOVF    (H.offs,toW    );    //OP_A.HIGH := H.offs
   _MOVWF   (SYSTMP02.offs);
   _CLRF    (H.offs);          //Clear RES.HIGH
MUL16LOOP := _PC;
   _BTFSS   (U.offs,0);   //Si (OP_B.0=1) then RES+=OP_A
   _GOTO    (_PC+7);      //END_IF_1
   _MOVF    (SYSTMP01.offs,toW);
   _ADDWF   (SYSTMP00.offs,toF);
   _MOVF    (SYSTMP02.offs,toW);
   _BTFSC   (_STATUS,0  );
   _ADDLW   (1);
   _ADDWF   (H.offs,toF);
// END_IF_1:
   _BCF     (_STATUS, 0);    //STATUS.C := 0
   _RRF     (E.offs, toF    );    //OP_B>>1
   _RRF     (U.offs, toF    );
   _BCF     (_STATUS, 0);    //STATUS.C := 0
   _RLF     (SYSTMP01.offs,toF);  //OP_A<<1
   _RLF     (SYSTMP02.offs,toF);
   _MOVF    (E.offs, toW);  //Si (OP_B>0) then goto MUL16LOOP
   _IORWF   (U.offs, toW);
   _BTFSS   (_STATUS, 2);
   _GOTO    (MUL16LOOP);  //OP_B>0
   _MOVF    (SYSTMP00.offs, toW);  //i_RETURN RES.LOW to toW
   SYSTMP00.used := false;
   SYSTMP01.used := false;
   SYSTMP02.used := false;
   EndCodeSub;  //termina codificación
end;

//////////// Operaciones con Dword
procedure TGenCod.ROB_dword_add_dword(Opt: TxpOperation; SetRes: boolean);
var
  aux: TPicRegister;
  varTmp: TxpEleVar;
begin
  case stoOperation of
  stConst_Const: begin
    if value1+value2 < $FF then begin
      //Optimiza
      SetROBResultConst_byte(value1+value2);
    end else if value1+value2 < $FFFF then begin
      //Optimiza
      SetROBResultConst_word(value1+value2);
    end else begin
      SetROBResultConst_dword(value1+value2);
    end;
  end;
  stConst_Variab: begin
    SetROBResultExpres_dword(Opt);
    aux := GetAuxRegisterByte;  //Pide un registro libre
    if HayError then exit;
    kMOVF   (byte2L, toW);
    _ADDLW  (value1L);  //Cambia C
    _movwf  (aux.offs);       //Guarda Byte L de resultado

    kMOVF   (byte2H, toW);  //Prepara sumando. Altera Z, pero no toca C
    _btfsc  (_STATUS,_C);      //Mira acarreo de operación anterior
    _incfsz (p2^.Hoffs,toW);
    _ADDLW  (value1H);  //Cambia C
    _movwf  (H.offs);       //Guarda Byte H de resultado

    kMOVF   (byte2E, toW);  //Prepara sumando. Altera Z, pero no toca C
    _btfsc  (_STATUS,_C);      //Mira acarreo de operación anterior
    _incfsz (p2^.Eoffs,toW);
    _ADDLW  (p1^.EByte);  //Cambia C
    _movwf  (E.offs);       //Guarda Byte E de resultado

    kMOVF   (byte2U, toW);  //Prepara sumando. Altera Z, pero no toca C
    _btfsc  (_STATUS,_C);      //Mira acarreo de operación anterior
    _incfsz (p2^.Uoffs,toW);
    _ADDLW  (p1^.UByte);
    _movwf  (U.offs);       //Guarda Byte U de resultado

    _movf (aux.offs, toW);  //Deja L en W

    aux.used := false;
  end;
  stConst_Expres: begin  //la expresión p2 se evaluó y esta en (H,W)
    if SetRes then SetROBResultExpres_dword(Opt); //Se fija aquí el resultado
    //K + WHEU -> WHEU, se puede manejar como asignación con sums
    aux := GetAuxRegisterByte;  //Pide un registro libre
    _MOVWF(aux.offs);  //guarda W
    varTmp := NewTmpVarDword(aux.addr, H.addr, E.addr, U.addr);  //Crea variable temporal, con los RT
    p2^.SetAsVariab(varTmp);  //Convierte p2 a variable
    ExchangeP1_P2;  //Convierte a p1 := p1 + K;
    ROB_dword_aadd_dword(Opt, false);  //compila como autosuma
    _MOVF(aux.offs, toW);  //devuelve byet bajo en W
    aux.used := false;
    varTmp.Destroy;  //Destruye la variable
  end;
  stVariab_Const: begin
    ExchangeP1_P2;  //Convierte a stConst_Variab
    ROB_dword_add_dword(Opt, SetRes);
  end;
  stVariab_Variab:begin
    SetROBResultExpres_dword(Opt);
//  Este algoritmo Falla
//    aux := GetAuxRegisterByte;  //Pide un registro libre
//    if HayError then exit;
//    _movf (byte2L,toW);
//    _addwf(byte1L,toW);
//    _movwf(aux.offs);
//    _movf (byte2H,toW);
//    _btfsc(STATUS, _C);
//    _addlw(1);
//    _addwf(byte1H,toW);
//    _movwf(H.offs);
//    _movf (byte2E,toW);
//    _btfsc(STATUS, _C);
//    _addlw(1);
//    _addwf(byte1E,toW);
//    _movwf(E.offs);
//    _movf (byte2U,toW);
//    _btfsc(STATUS, _C);
//    _addlw(1);
//    _addwf(byte1U,toW);
//    _movwf(U.offs);
//    _movf (aux.offs, toW);
//    aux.used := false;

    aux := GetAuxRegisterByte;  //Pide un registro libre
    if HayError then exit;
    kMOVF   (byte2L, toW);
    kADDWF  (byte1L, toW);  //Cambia C
    _movwf  (aux.offs);       //Guarda Byte L de resultado

    kMOVF   (byte2H, toW);  //Prepara sumando. Altera Z, pero no toca C
    _btfsc  (_STATUS,_C);      //Mira acarreo de operación anterior
    _incfsz (p2^.Hoffs,toW);
    _addwf  (p1^.Hoffs,toW);  //Cambia C
    _movwf  (H.offs);       //Guarda Byte H de resultado

    kMOVF   (byte2E, toW);  //Prepara sumando. Altera Z, pero no toca C
    _btfsc  (_STATUS,_C);      //Mira acarreo de operación anterior
    _incfsz (p2^.Eoffs,toW);
    _addwf  (p1^.Eoffs,toW);  //Cambia C
    _movwf  (E.offs);       //Guarda Byte E de resultado

    kMOVF   (byte2U, toW);  //Prepara sumando. Altera Z, pero no toca C
    _btfsc  (_STATUS,_C);      //Mira acarreo de operación anterior
    _incfsz (p2^.Uoffs,toW);
    _addwf  (p1^.Uoffs,toW);
    _movwf  (U.offs);       //Guarda Byte U de resultado

    _movf (aux.offs, toW);  //Deja L en W

    aux.used := false;

  end;
//  stVariab_Expres:begin   //la expresión p2 se evaluó y esta en (H,W)
//    SetROBResultExpres_word(Opt);
//    aux := GetAuxRegisterByte;  //Pide un registro libre
//    if HayError then exit;
//    _BANKSEL(aux.bank);
//    _movwf(aux.offs);        //guarda byte bajo
//    _BANKSEL(p1^.bank);
//    _MOVF(byte1H, toW);   //Carga más peso del dato 1
//    _BANKSEL(H.bank);
//    _addwf(H.offs,toF);      //Suma y guarda
//    //Siguiente byte
//    _BANKSEL(p1^.bank);
//    _MOVF(byte1L, toW);       //Carga menos peso del dato 1
//    _BANKSEL(aux.bank);
//    _addwf(aux.offs,toW);    //Suma menos peso del dato 2, deja en W
//    _btfsc(STATUS,_C);      //Hubo acarreo anterior?
//    _incf(H.offs, toF);
//    aux.used := false;
//  end;
  stExpres_Const: begin   //la expresión p1 se evaluó y esta en (H,W)
    if SetRes then SetROBResultExpres_dword(Opt); //Se fija aquí el resultado
    //WHEU + K -> WHEU, se puede manejar como asignación con suma
    aux := GetAuxRegisterByte;  //Pide un registro libre
    _MOVWF(aux.offs);  //gaurda W
    varTmp := NewTmpVarDword(aux.addr, H.addr, E.addr, U.addr);  //Crea variable temporal
    p1^.SetAsVariab(varTmp);  //Convierte p1 a variable
    ROB_dword_aadd_dword(Opt, false);  //compila como autosuma
    _MOVF(aux.offs, toW);  //devuelve byet bajo en W
    aux.used := false;
    varTmp.Destroy;  //Destruye la variable
  end;
//  stExpres_Variab:begin  //la expresión p1 se evaluó y esta en (H,W)
//    SetROBResultExpres_word(Opt);
//    aux := GetAuxRegisterByte;  //Pide un registro libre
//    if HayError then exit;
//    _movwf(aux.offs);      //guarda byte bajo
//    _BANKSEL(p2^.bank);
//    _MOVF(byte2H, toW);     //Carga más peso del dato 1
//    _BANKSEL(H.bank);
//    _addwf(H.offs,toF);    //Suma y guarda
//    _BANKSEL(p2^.bank);
//    _MOVF(byte2L, toW);     //Carga menos peso del dato 1
//    _BANKSEL(aux.bank);
//    _addwf(aux.offs,toW);  //Suma menos peso del dato 2, deja en W
//    _BANKSEL(H.bank);
//    _btfsc(STATUS,_C);    //Hubo acarreo anterior?
//    _incf(H.offs, toF);
//    aux.used := false;
//  end;
//  stExpres_Expres:begin
//    SetROBResultExpres_word(Opt);
//    //p1 está salvado en pila y p2 en (_H,W)
//    p1^.Sto := stVariab;  //Convierte a variable
//    p1^.rVar := GetVarWordFromStk;
//    stoOperation := TStoOperandsROB((Ord(p1^.Sto) << 2) or ord(p2^.Sto));
//    //Luego el caso es similar a stVariab_Expres
//    ROB_word_add_word;
//    FreeStkRegisterByte(spH);   //libera pila, obtiene dirección
//    FreeStkRegisterByte(spL);   //libera pila, obtiene dirección
//  end;
  else
    genError(MSG_CANNOT_COMPL, [OperationStr(Opt)]);
  end;
end;
procedure TGenCod.ROB_dword_aadd_dword(Opt: TxpOperation; SetRes: boolean);
begin
  if p1^.Sto <> stVariab then begin  //validación
    GenError('Only variables can be assigned.'); exit;
  end;
  case p2^.Sto of
  stConst : begin
    if SetRes then SetROBResultExpres_dword(Opt);  //Realmente, el resultado no es importante
    if value2 = 0 then begin
      //No cambia
    end else if value2 <= $FF then begin
      kMOVLW (value2L);
      kADDWF (byte1L,toF);
      _btfsc (_STATUS,_C);
      _INCF  (p1^.Hoffs,toF);
      _btfsc (_STATUS,_Z);
      _INCF  (p1^.Eoffs,toF);
      _btfsc (_STATUS,_Z);
      _INCF  (p1^.Uoffs,toF);
    end else if value2 <= $FFFF then begin
      kMOVLW (value2L);
      kADDWF (byte1L,toF);
      kMOVLW (value2H);
      _btfsc (_STATUS,_C);
      _ADDLW (1);
      kADDWF (byte1H, toF);
      _btfsc (_STATUS,_C);
      _INCF  (p1^.Eoffs,toF);
      _btfsc (_STATUS,_Z);
      _INCF  (p1^.Uoffs,toF);
    end else begin
      kMOVLW (value2L);
      kADDWF (byte1L, toF);
      kMOVLW (value2H);
      _btfsc (_STATUS,_C);
      _ADDLW (1);
      kADDWF (byte1H, toF);
      kMOVLW (p2^.EByte);
      _btfsc (_STATUS,_C);
      _ADDLW (1);
      kADDWF (byte1E, toF);
      kMOVLW (p2^.UByte);
      _btfsc (_STATUS,_C);
      _ADDLW (1);
      kADDWF (byte1U,toF);
    end;
  end;
  stVariab: begin
    if SetRes then SetROBResultExpres_dword(Opt);  //Realmente, el resultado no es importante
    kMOVF   (byte2L, toW);
    kADDWF  (byte1L, toF);
    kMOVF   (byte2H, toW);
    _btfsc  (_STATUS,_C);
    _incfsz (p2^.Hoffs,toW);
    _addwf  (p1^.Hoffs,toF);
    kMOVF   (byte2E, toW);
    _btfsc  (_STATUS,_C);
    _incfsz (p2^.Eoffs,toW);
    _addwf  (p1^.Eoffs,toF);
    kMOVF   (byte2U, toW);
    _btfsc  (_STATUS,_C);
    _incfsz (p2^.Uoffs,toW);
    _addwf  (p1^.Uoffs,toF);
  end;
  stExpres: begin   //Se asume que está en U,E,H,w
    if SetRes then SetROBResultExpres_dword(Opt);  //Realmente, el resultado no es importante
    kADDWF  (byte1L, toF);  //p2 ya está en W
    _movf   (H.offs,toW);
    _btfsc  (_STATUS,_C);
    _incfsz (H.offs,toW);
    _addwf  (p1^.Hoffs,toF);
    _movf   (E.offs,toW);
    _btfsc  (_STATUS,_C);
    _incfsz (E.offs,toW);
    _addwf  (p1^.Eoffs,toF);
    _movf   (U.offs,toW);
    _btfsc  (_STATUS,_C);
    _incfsz (U.offs,toW);
    _addwf  (p1^.Uoffs,toF);
  end;
  else
    GenError(MSG_UNSUPPORTED); exit;
  end;
end;
//////////// Operaciones con Char
procedure TGenCod.ROB_char_asig_char(Opt: TxpOperation; SetRes: boolean);
begin
  if p1^.Sto <> stVariab then begin  //validación
    GenError('Only variables can be assigned.'); exit;
  end;
  case p2^.Sto of
  stConst : begin
    SetROBResultExpres_char(Opt);  //Realmente, el resultado no es importante
    if value2=0 then begin
      //caso especial
      kCLRF(byte1);
    end else begin
      kMOVLW(value2);  //Los chars se manejan como números
      kMOVWF(byte1);
    end;
  end;
  stVariab: begin
    SetROBResultExpres_char(Opt);  //Realmente, el resultado no es importante
    kMOVF(byte2, toW);
    kMOVWF(byte1);
  end;
  stExpres: begin  //ya está en w
    SetROBResultExpres_char(Opt);  //Realmente, el resultado no es importante
    kMOVWF(byte1);
  end;
  else
    GenError(MSG_UNSUPPORTED); exit;
  end;
end;
procedure TGenCod.ROB_char_equal_char(Opt: TxpOperation; SetRes: boolean);
begin
  ROB_byte_equal_byte(Opt, SetRes);  //es lo mismo
end;
procedure TGenCod.ROB_char_difer_char(Opt: TxpOperation; SetRes: boolean);
begin
  ROB_byte_difer_byte(Opt, SetRes); //es lo mismo
end;
//////////// Operaciones con punteros
procedure TGenCod.ROB_pointer_add_byte(Opt: TxpOperation; SetRes: boolean);
{Implementa la suma de un puntero (a cualquier tipo) y un byte.}
var
  ptrType: TxpEleType;
begin
  {Guarda la referencia al tipo puntero, porque:
  * Se supone que este tipo lo define el usuario y no se tiene predefinido.
  * Se podrían definir varios tipos de puntero) así que no se tiene una
  referencia estática
  * Conviene manejar esto de forma dinámica para dar flexibilidad al lenguaje}
  ptrType := p1^.Typ;   //Se ahce aquí porque después puede cambiar p1^.
  //La suma de un puntero y un byte, se procesa, como una suma de bytes
  ROB_byte_add_byte(Opt, SetRes);
  //Devuelve byte, oero debe devolver el tipo puntero
  case res.Sto of
  stConst: res.SetAsConst(ptrType);  //Cambia el tipo a la constante
  //stVariab: res.SetAsVariab(res.rVar);
  {Si devuelve variable, solo hay dos posibilidades:
   1. Que sea la variable puntero, por lo que no hay nada que hacer, porque ya tiene
      el tipo puntero.
   2. Que sea la variable byte (y que la otra era constante puntero 0 = nil). En este
      caso devolverá el tipo Byte, lo cual tiene cierto sentido.}
  stExpres: res.SetAsExpres(ptrType);  //Cambia tipo a la expresión
  end;
end;
procedure TGenCod.ROB_pointer_sub_byte(Opt: TxpOperation; SetRes: boolean);
{Implementa la resta de un puntero (a cualquier tipo) y un byte.}
var
  ptrType: TxpEleType;
begin
  //La explicación es la misma que para la rutina ROB_pointer_add_byte
  ptrType := p1^.Typ;
  ROB_byte_sub_byte(Opt, SetRes);
  case res.Sto of
  stConst: res.SetAsConst(ptrType);
  stExpres: res.SetAsExpres(ptrType);
  end;
end;
procedure TGenCod.ROU_derefPointer(Opr: TxpOperator; SetRes: boolean);
{Implementa el operador de desreferencia "^", para Opr que se supone debe ser
 categoria "tctPointer", es decir, puntero a algún tipo de dato.}
var
  tmpVar: TxpEleVar;
begin
  case p1^.Sto of
  stConst : begin
    //Caso especial. Cuando se tenga algo como: TPunteroAByte($FF)^
    //Se asume que devuelve una variable de tipo Byte.
    tmpVar := CreateTmpVar('', typByte);
    tmpVar.addr0 := value1;  //Fija dirección de constante
    SetROUResultVariab(tmpVar);
  end;
  stVariab: begin
    //Caso común: ptrWord^
    //La desreferencia de una variable "tctPointer" es un stVarRefVar.
    SetROUResultVarRef(p1^.rVar);
  end;
  stExpres: begin
    //La expresión Esta en RT, pero es una dirección, no un valor
    SetROUResultExpRef(nil, p1^.Typ);
  end;
  else
    genError('Not implemented: "%s"', [Opr.OperationString]);
  end;
end;
///////////// Funciones del sistema
procedure TGenCod.codif_1mseg;
//Codifica rutina de retardo de 1mseg.
begin
  PutFwdComm(';1 msec routine.');
  if _CLOCK = 1000000 then begin
    kMOVLW(62);  //contador de iteraciones
    _ADDLW(255);  //lazo de 4 ciclos
    _BTFSS(_STATUS,_Z);
    _GOTO(_PC-2); PutComm(';fin rutina 1 mseg a 1MHz.');
  end else if _CLOCK = 2000000 then begin
    kMOVLW(125);  //contador de iteraciones
    _ADDLW(255);  //lazo de 4 ciclos
    _BTFSS(_STATUS,_Z);
    _GOTO(_PC-2); PutComm(';fin rutina 1 mseg a 2MHz.');
  end else if _CLOCK = 4000000 then begin
    //rtuina básica para 4MHz
    kMOVLW(250);  //contador de iteraciones
    _ADDLW(255);  //lazo de 4 ciclos
    _BTFSS(_STATUS,_Z);
    _GOTO(_PC-2); PutComm(';fin rutina 1 mseg a 4MHz.');
  end else if _CLOCK = 8000000 then begin
    kMOVLW(250);
    _ADDLW(255);   //lazo de 8 ciclos
    _GOTO(_PC+1);  //introduce 4 ciclos más de retardo
    _GOTO(_PC+1);
    _BTFSS(_STATUS,_Z);
    _GOTO(_PC-4); PutComm(';fin rutina 1 mseg a 8Mhz.');
  end else if _CLOCK = 10000000 then begin
    kMOVLW(250);
    _ADDLW(255);   //lazo de 10 ciclos
    _GOTO(_PC+1);  //introduce 6 ciclos más de retardo
    _GOTO(_PC+1);
    _GOTO(_PC+1);
    _BTFSS(_STATUS,_Z);
    _GOTO(_PC-5); PutComm(';fin rutina 1 mseg a 10MHz.');
  end else if _CLOCK = 12000000 then begin
    kMOVLW(250);
    _ADDLW(255);   //lazo de 12 ciclos
    _GOTO(_PC+1);  //introduce 8 ciclos más de retardo
    _GOTO(_PC+1);
    _GOTO(_PC+1);
    _GOTO(_PC+1);
    _BTFSS(_STATUS,_Z);
    _GOTO(_PC-6); PutComm(';fin rutina 1 mseg a 12MHz.');
  end else if _CLOCK = 16000000 then begin
    kMOVLW(250);
    _ADDLW(255);   //lazo de 16 ciclos
    _GOTO(_PC+1);  //introduce 12 ciclos más de retardo
    _GOTO(_PC+1);
    _GOTO(_PC+1);
    _GOTO(_PC+1);
    _GOTO(_PC+1);
    _GOTO(_PC+1);
    _BTFSS(_STATUS,_Z);
    _GOTO(_PC-8); PutComm(';fin rutina 1 mseg a 12MHz.');
  end else if _CLOCK = 20000000 then begin
    kMOVLW(250);
    _ADDLW(255);   //lazo de 20 ciclos
    _GOTO(_PC+1);  //introduce 16 ciclos más de retardo
    _GOTO(_PC+1);
    _GOTO(_PC+1);
    _GOTO(_PC+1);
    _GOTO(_PC+1);
    _GOTO(_PC+1);
    _GOTO(_PC+1);
    _GOTO(_PC+1);
    _BTFSS(_STATUS,_Z);
    _GOTO(_PC-10); PutComm(';fin rutina 1 mseg a 12MHz.');
  end else begin
    GenError('Clock frequency %d not supported for delay_ms().', [_CLOCK]);
  end;
end;
procedure TGenCod.codif_delay_ms(fun: TxpEleFun);
//Codifica rutina de retardo en milisegundos
var
  delay: Word;
  aux: TPicRegister;
begin
  StartCodeSub(fun);  //inicia codificación
  PutTopComm('    ;delay routine.');
  //aux := GetAuxRegisterByte;  //Pide un registro libre
  //if HayError then exit;
  aux := FSR;  //Usa el FSR como registro auxiliar
  {Esta rutina recibe los milisegundos en los registros en (H,w) o en (w)
  En cualquier caso, siempre usa el registros H , el acumulador "w" y un reg. auxiliar.
  Se supone que para pasar los parámetros, ya se requirió H, así que no es necesario
  crearlo.}
  _CLRF(H.offs);   PutComm(' ;enter when parameters in (0,w)');
  _MOVWF(aux.offs); PutComm(';enter when parameters in (H,w)');
  _INCF(H.offs,toF);
  _INCF(aux.offs,toF);  //corrección
delay:= _PC;
  _DECFSZ(aux.offs, toF);
  _GOTO(_PC+2);
  _DECFSZ(H.offs, toF);
  _GOTO(_PC+2);
  _RETURN();
  codif_1mseg;   //codifica retardo 1 mseg
  if HayError then exit;
  _GOTO(delay);
  EndCodeSub;  //termina codificación
  //aux.used := false;  //libera registro
end;
procedure TGenCod.codif_delay_ms2(fun: TxpEleFun);
//Code the routine for delay in miliseconds for word parameter.
var
  aux: TPicRegister;
  delay: Word;
begin
  if f_delay_msB.linked THEN begin
    {This is something weird, because we really don't generate code, but point the
    function to an existing code.}
    fun.adrr := f_delay_msB.adrr+1;  //At the entry for word parameter
  end else begin
    //It's not used f_delay_ms(). We use a simplified version of the loop
    StartCodeSub(fun);  //inicia codificación
    PutTopComm('    ;delay routine.');
    aux := FSR;  //Usa el FSR como registro auxiliar


    _MOVWF(aux.offs);
    _INCF(H.offs,toF);
    _INCF(aux.offs,toF);  //corrección
  delay:= _PC;
    _DECFSZ(aux.offs, toF);
    _GOTO(_PC+2);
    _DECFSZ(H.offs, toF);
    _GOTO(_PC+2);
    _RETURN();
    codif_1mseg;   //codifica retardo 1 mseg
    if HayError then exit;
    _GOTO(delay);
    EndCodeSub;  //termina codificación
  end;
end;
procedure TGenCod.fun_Exit(fun: TxpEleFunBase; out AddrUndef: boolean);
{Se debe dejar en los registros de trabajo, el valor del parámetro indicado.}
var
  curFunTyp: TxpEleType;
  parentNod: TxpEleCodeCont;
  curFun: TxpEleFun;
  posExit: TSrcPos;
//  adrReturn: word;
begin
  //TreeElems.curNode, debe ser de tipo "Body".
  parentNod := TreeElems.CurCodeContainer;  //Se supone que nunca debería fallar
  posExit := cIn.ReadSrcPos;  //Guarda para el AddExitCall()
  if parentNod.idClass = eltMain then begin
    //Es el cuerpo del programa principal
    _SLEEP;   //Así se termina un programa en PicPas
  end else if parentNod.idClass = eltFunc then begin
    //Es el caso común, un exit() en procedimientos.
    //"parentNod" debe ser de tipo TxpEleFun
    curFun := TxpEleFun(parentNod);
    if curFun.IsInterrupt then begin
      GenError('Cannot use exit() in an INTERRUPT.');
      exit;
    end;
    //Codifica el retorno
    curFunTyp := curFun.typ;
    if curFunTyp = typNull then begin
      //No retorna valores. Es solo procedimiento
      _RETURN;
      //No hay nada, más que hacer
    end else begin
      //Se espera el valor devuelto
      if not CaptureTok('(') then exit;
      res := GetExpression(0);  //captura parámetro
      if HayError then exit;   //aborta
      //Verifica fin de parámetros
      if not CaptureTok(')') then exit;
      //El resultado de la expresión está en "res".
      if curFunTyp <> res.Typ then begin
        GenError('Expected a "%s" expression.', [curFunTyp.name]);
        exit;
      end;
      LoadToRT(res, true);  //Carga expresión en RT y genera i_RETURN o i_RETLW
    end;
  end else begin
    //Faltaría implementar en cuerpo de TxpEleUni
    GenError('Syntax error.');
  end;
  //Lleva el registro de las llamadas a exit()
  if FirstPass then begin
    //CurrBank debe ser el banco con el que se llamó al i_RETURN.
    parentNod.AddExitCall(posExit, parentNod.CurrBlockID, CurrBank);
  end;
  res.SetAsNull;  //No es función
end;
procedure TGenCod.fun_Inc(fun: TxpEleFunBase; out AddrUndef: boolean);
begin
  if not CaptureTok('(') then exit;
  res := GetExpression(0);  //Captura parámetro. No usa GetExpressionE, para no cambiar RTstate
  if HayError then exit;   //aborta
  case res.Sto of  //el parámetro debe estar en "res"
  stConst : begin
    GenError('Cannot increase a constant.'); exit;
  end;
  stVariab: begin
    if (res.Typ = typByte) or (res.Typ = typChar) then begin
      _BANKSEL(res.bank);
      _INCF(res.offs, toF);
    end else if res.Typ = typWord then begin
      _BANKSEL(res.bank);
      _INCF(res.Loffs, toF);
      _BTFSC(_STATUS, _Z);
      _INCF(res.Hoffs, toF);
    end else if res.Typ = typDWord then begin
      _BANKSEL(res.bank);
      _INCF(res.Loffs, toF);
      _BTFSC(_STATUS, _Z);
      _INCF(res.Hoffs, toF);
      _BTFSC(_STATUS, _Z);
      _INCF(res.Eoffs, toF);
      _BTFSC(_STATUS, _Z);
      _INCF(res.Uoffs, toF);
    end else if res.Typ.catType = tctPointer then begin
      //Es puntero corto
      _BANKSEL(res.bank);
      _INCF(res.offs, toF);
    end else begin
      GenError(MSG_INVAL_PARTYP, [res.Typ.name]);
      exit;
    end;
  end;
//  stVarRefVar: begin
//    if (res.Typ = typByte) or (res.Typ = typChar) then begin
//      _BANKSEL(res.bank);
//      _INCF(res.offs, toF);
//    end else if res.Typ = typWord then begin
//      _BANKSEL(res.bank);
//      _INCF(res.Loffs, toF);
//      _BTFSC(STATUS, _Z);
//      _INCF(res.Hoffs, toF);
//    end else if res.Typ = typDWord then begin
//      _BANKSEL(res.bank);
//      _INCF(res.Loffs, toF);
//      _BTFSC(STATUS, _Z);
//      _INCF(res.Hoffs, toF);
//      _BTFSC(STATUS, _Z);
//      _INCF(res.Eoffs, toF);
//      _BTFSC(STATUS, _Z);
//      _INCF(res.Uoffs, toF);
//    end else if res.Typ.catType = tctPointer then begin
//      //Es puntero corto
//      _BANKSEL(res.bank);
//      _INCF(res.offs, toF);
//    end else begin
//      GenError(MSG_INVAL_PARTYP, [res.Typ.name]);
//      exit;
//    end;
//  end;
  stExpres: begin  //se asume que ya está en (_H,w)
    GenError('Cannot increase an expression.'); exit;
  end;
  else
    genError('Not implemented "%s" for this operand.', [fun.name]);
  end;
  res.SetAsNull;  //No es función
  //Verifica fin de parámetros
  if not CaptureTok(')') then exit;
end;
procedure TGenCod.fun_Dec(fun: TxpEleFunBase; out AddrUndef: boolean);
begin
  if not CaptureTok('(') then exit;
  res := GetExpression(0);  //Captura parámetro. No usa GetExpressionE, para no cambiar RTstate
  if HayError then exit;   //aborta
  case res.Sto of  //el parámetro debe estar en "res"
  stConst : begin
    GenError('Cannot decrease a constant.'); exit;
  end;
  stVariab: begin
    if (res.Typ = typByte) or (res.Typ = typChar) then begin
      _BANKSEL(res.bank);
      _DECF(res.offs, toF);
    end else if res.Typ = typWord then begin
      _BANKSEL(res.bank);
      _MOVF(res.Loffs, toW);
      _BTFSC(_STATUS, _Z);
      _DECF(res.Hoffs, toF);
      _DECF(res.Loffs, toF);
    end else if res.Typ = typDWord then begin
      _BANKSEL(res.bank);
      kMOVLW(1);
      _subwf(res.Loffs, toF);
      _BTFSS(_STATUS, _C);
      _subwf(RES.Hoffs, toF);
      _BTFSS(_STATUS, _C);
      _subwf(RES.Eoffs, toF);
      _BTFSS(_STATUS, _C);
      _subwf(RES.Uoffs, toF);
    end else if res.Typ.catType = tctPointer then begin
      //Es puntero corto
      _BANKSEL(res.bank);
      _DECF(res.offs, toF);
    end else begin
      GenError(MSG_INVAL_PARTYP, [res.Typ.name]);
      exit;
    end;
  end;
  stExpres: begin  //se asume que ya está en (_H,w)
    GenError('Cannot decrease an expression.'); exit;
  end;
  else
    genError('Not implemented "%s" for this operand.', [fun.name]);
  end;
  res.SetAsNull;  //No es función
  //Verifica fin de parámetros
  if not CaptureTok(')') then exit;
end;
procedure TGenCod.fun_Ord(fun: TxpEleFunBase; out AddrUndef: boolean);
var
  tmpVar: TxpEleVar;
begin
  if not CaptureTok('(') then exit;
  res := GetExpression(0);  //Captura parámetro. No usa GetExpressionE, para no cambiar RTstate
  if HayError then exit;   //aborta
  case res.Sto of  //el parámetro debe estar en "res"
  stConst : begin
    if res.Typ = typChar then begin
      SetResultConst(typByte);  //Solo cambia el tipo, no el valor
      //No se usa SetROBResultConst_byte, porque no estamos en ROP
    end else begin
      GenError('Cannot convert to ordinal.'); exit;
    end;
  end;
  stVariab: begin
    if res.Typ = typChar then begin
      //Sigue siendo variable
      tmpVar := CreateTmpVar('', typByte);   //crea variable temporal Byte
      tmpVar.addr0 := res.rVar.addr0; //apunta al mismo byte
      SetResultVariab(tmpVar);  //Actualiza "res"
    end else begin
      GenError('Cannot convert to ordinal.'); exit;
    end;
  end;
  stExpres: begin  //se asume que ya está en (w)
    if res.Typ = typChar then begin
      //Es la misma expresión, solo que ahora es Byte.
      res.SetAsExpres(typByte); //No se puede usar SetROBResultExpres_byte, porque no hay p1 y p2
    end else begin
      GenError('Cannot convert to ordinal.'); exit;
    end;
  end;
  else
    genError('Not implemented "%s" for this operand.', [fun.name]);
  end;
  if not CaptureTok(')') then exit;
end;
procedure TGenCod.fun_Chr(fun: TxpEleFunBase; out AddrUndef: boolean);
var
  tmpVar: TxpEleVar;
begin
  if not CaptureTok('(') then exit;
  res := GetExpression(0);  //Captura parámetro. No usa GetExpressionE, para no cambiar RTstate
  if HayError then exit;   //aborta
  case res.Sto of  //el parámetro debe estar en "res"
  stConst : begin
    if res.Typ = typByte then begin
      SetResultConst(typChar);  //Solo cambia el tipo, no el valor
      //No se usa SetROBResultConst_char, porque no estamos en ROP
    end else begin
      GenError('Cannot convert to char.'); exit;
    end;
  end;
  stVariab: begin
    if res.Typ = typByte then begin
      //Sigue siendo variable
      tmpVar := CreateTmpVar('', typChar);   //crea variable temporal
      tmpVar.addr0 := res.rVar.addr0; //apunta al mismo byte
      SetResultVariab(tmpVar);
    end else begin
      GenError('Cannot convert to char.'); exit;
    end;
  end;
  stExpres: begin  //se asume que ya está en (w)
    if res.Typ = typByte then begin
      //Es la misma expresión, solo que ahora es Char.
      res.SetAsExpres(typChar); //No se puede usar SetROBResultExpres_char, porque no hay p1 y p2;
    end else begin
      GenError('Cannot convert to char.'); exit;
    end;
  end;
  else
    genError('Not implemented "%s" for this operand.', [fun.name]);
  end;
  if not CaptureTok(')') then exit;
end;
procedure TGenCod.fun_Bit(fun: TxpEleFunBase; out AddrUndef: boolean);
{Convierte byte, o boolean a bit}
var
  tmpVar: TxpEleVar;
begin
  if not CaptureTok('(') then exit;
  res := GetExpression(0);  //Captura parámetro. No usa GetExpressionE, para no cambiar RTstate
  if HayError then exit;   //aborta
  case res.Sto of  //el parámetro debe estar en "res"
  stConst : begin
    if res.Typ = typByte then begin
      if res.valInt= 0 then begin
        SetResultConst(typBit);  //No se usa SetROBResultConst_bit, porque no estamos en ROP
        res.valBool := false;
      end else begin
        SetResultConst(typBit);  //No se usa SetROBResultConst_bit, porque no estamos en ROP
        res.valBool := true;
      end;
    end else begin
      GenError('Cannot convert to bit.'); exit;
    end;
  end;
  stVariab: begin
    if res.Typ = typByte then begin
      //No se usa SetROUResultExpres_bit(true), porque no se tiene el operando en p1^
      SetResultExpres(typBit);
      res.Inverted := true;
      //Se asumirá que cualquier valor diferente de cero, devuelve 1
      _MOVF(res.Loffs, toW);    //el resultado aparecerá en Z, invertido
      {Notar que se ha usado res.Loff, para apuntar a la dirección de la variable byte.
      Si se hubeise usado solo res.off, apuntaría a una dirección del tipo bit}
    end else if res.Typ = typBool then begin
      //Sigue siendo variable
      tmpVar := CreateTmpVar('', typBit);   //crea variable temporal
      tmpVar.addr0 := res.rVar.addr0; //Apunta al mismo byte
      tmpVar.bit0  := res.rVar.bit0;  //Apunta al mismo bit
      SetResultVariab(tmpVar, res.Inverted);   //mantiene lógica
    end else begin
      GenError('Cannot convert to bit.'); exit;
    end;
  end;
  stExpres: begin  //se asume que ya está en (w)
    if res.Typ = typByte then begin
      SetResultExpres(typBit); //No se usa SetROUResultExpres_bit, porque no se tiene el operando en p1^
      res.Inverted := true;
      _IORLW(0);   //El resultado aparecerá en Z, invertido
      //Se usa _IORLW en lugar de _ADDLW para poder usar esta rutina en modelos que no cuenten con _ADDLW
    end else begin
      GenError('Cannot convert to bit.'); exit;
    end;
  end;
  else
    genError('Not implemented "%s" for this operand.', [fun.name]);
  end;
  if not CaptureTok(')') then exit;
end;
procedure TGenCod.fun_Bool(fun: TxpEleFunBase; out AddrUndef: boolean);
{Convierte byte, o bit a boolean}
var
  tmpVar: TxpEleVar;
begin
  if not CaptureTok('(') then exit;
  res := GetExpression(0);  //Captura parámetro. No usa GetExpressionE, para no cambiar RTstate
  if HayError then exit;   //aborta
  case res.Sto of  //el parámetro debe estar en "res"
  stConst : begin
    if res.Typ = typByte then begin
      if res.valInt= 0 then begin
        SetResultConst(typBool);  //No se usa SetROBResultConst_bit, porque no estamos en ROP
        res.valBool := false;
      end else begin
        SetResultConst(typBool);  //No se usa SetROBResultConst_bit, porque no estamos en ROP
        res.valBool := true;
      end;
    end else begin
      GenError('Cannot convert to boolean.'); exit;
    end;
  end;
  stVariab: begin
    if res.Typ = typByte then begin
      //No se usa SetROUResultExpres_bool(true), porque no se tiene el operando en p1^
      SetResultExpres(typBool);
      res.Inverted := true;
      //Se asumirá que cualquier valor diferente de cero, devuelve 1
      _MOVF(res.Loffs, toW);    //el resultado aparecerá en Z, invertido
      {Notar que se ha usado res.Loff, para apuntar a la dirección de la variable byte.
      Si se hubeise usado solo res.off, apuntaría a una dirección del tipo bit}
    end else if res.Typ = typBit then begin
      //Sigue siendo variable
      tmpVar := CreateTmpVar('', typBool);   //crea variable temporal
      tmpVar.addr0 := res.rVar.addr0; //Apunta al mismo byte
      tmpVar.bit0  := res.rVar.bit0;  //Apunta al mismo bit
      SetResultVariab(tmpVar, res.Inverted);   //mantiene lógica
    end else begin
      GenError('Cannot convert to boolean.'); exit;
    end;
  end;
  stExpres: begin  //se asume que ya está en (w)
    if res.Typ = typByte then begin
      SetResultExpres(typBool); //No se usa SetROUResultExpres_bit, porque no se tiene el operando en p1^
      res.Inverted := true;
      _IORLW(0);   //El resultado aparecerá en Z, invertido
      //Se usa _IORLW en lugar de _ADDLW para poder usar esta rutina en modelos que no cuenten con _ADDLW
    end else begin
      GenError('Cannot convert to boolean.'); exit;
    end;
  end;
  else
    genError('Not implemented "%s" for this operand.', [fun.name]);
  end;
  if not CaptureTok(')') then exit;
end;
procedure TGenCod.fun_Byte(fun: TxpEleFunBase; out AddrUndef: boolean);
var
  tmpVar: TxpEleVar;
begin
  if not CaptureTok('(') then exit;
  res := GetExpression(0);  //Captura parámetro. No usa GetExpressionE, para no cambiar RTstate
  if HayError then exit;   //aborta
  case res.Sto of  //el parámetro debe estar en "res"
  stConst : begin
    if res.Typ = typByte then begin
      //ya es Byte
    end else if res.Typ = typChar then begin
      res.SetAsConst(typByte);  //Solo cambia el tipo
    end else if res.Typ = typWord then begin
      res.SetAsConst(typByte);  //Cambia el tipo
      res.valInt := res.valInt and $FF;
    end else if res.Typ = typDWord then begin
      res.SetAsConst(typByte);  //Cambia el tipo
      res.valInt := res.valInt and $FF;
    end else if (res.Typ = typBool) or (res.Typ = typBit) then begin
      res.SetAsConst(typByte);  //Cambia el tipo
      if res.valBool then res.valInt := 1 else res.valInt := 0;
    end else begin
      GenError('Cannot convert to byte.'); exit;
    end;
  end;
  stVariab: begin
    if res.Typ = typBit then begin
      SetResultExpres(typByte);
      _CLRW;
      _BTFSC(res.Boffs, res.bit);
      kMOVLW(1);  //devuelve 1
      //Es lo mismo
    end else if res.Typ = typChar then begin
      //Crea varaible que apunte al byte bajo
      tmpVar := CreateTmpVar('', typByte);   //crea variable temporal Byte
      tmpVar.addr0 := res.rVar.addr0;  //apunta al mismo byte
      SetResultVariab(tmpVar);
    end else if res.Typ = typByte then begin
      //Es lo mismo
    end else if res.Typ = typWord then begin
      //Crea varaible que apunte al byte bajo
      tmpVar := CreateTmpVar('', typByte);   //crea variable temporal Byte
      tmpVar.addr0 := res.rVar.addr0;  //apunta al mismo byte
      SetResultVariab(tmpVar);
    end else if res.Typ = typDWord then begin
      //CRea varaible que apunte al byte bajo
      tmpVar := CreateTmpVar('', typByte);   //crea variable temporal Byte
      tmpVar.addr0 := res.rVar.addr0;  //apunta al mismo byte
      SetResultVariab(tmpVar);
    end else begin
      GenError('Cannot convert to byte.'); exit;
    end;
  end;
  stExpres: begin  //se asume que ya está en (w)
    if res.Typ = typByte then begin
      //Ya está en W
      //Ya es Byte
    end else if res.Typ = typChar then begin
      //Ya está en W
      res.SetAsExpres(typByte);  //Solo cambia el tipo
    end else if res.Typ = typWord then begin
      //Ya está en W el byte bajo
      res.SetAsExpres(typByte);  //Cambia el tipo
    end else if res.Typ = typDWord then begin
      //Ya está en W el byet bajo
      res.SetAsExpres(typByte);  //Cambia el tipo
    end else if (res.Typ = typBool) or (res.Typ = typBit) then begin
      kMOVLW(0);    //Z -> W
      _BTFSC(_STATUS, _Z);
      kMOVLW(1);
      res.SetAsExpres(typByte);  //Cambia el tipo
    end else begin
      GenError('Cannot convert to byte.'); exit;
    end;
  end;
  else
    genError('Not implemented "%s" for this operand.', [fun.name]);
  end;
  if not CaptureTok(')') then exit;
end;
procedure TGenCod.fun_Word(fun: TxpEleFunBase; out AddrUndef: boolean);
var
  tmpVar: TxpEleVar;
begin
  if not CaptureTok('(') then exit;
  res := GetExpression(0);  //Captura parámetro. No usa GetExpressionE, para no cambiar RTstate
  if HayError then exit;   //aborta
  case res.Sto of  //el parámetro debe estar en "res"
  stConst : begin
    if res.Typ = typByte then begin
      res.SetAsConst(typWord);  //solo cambia el tipo
    end else if res.Typ = typChar then begin
      res.SetAsConst(typWord);  //solo cambia el tipo
    end else if res.Typ = typWord then begin
      //ya es Word
    end else if res.Typ = typDWord then begin
      res.SetAsConst(typWord);
      res.valInt := res.valInt and $FFFF;
    end else if (res.Typ = typBool) or (res.Typ = typBit) then begin
      res.SetAsConst(typWord);
      if res.valBool then res.valInt := 1 else res.valInt := 0;
    end else begin
      GenError('Cannot convert this constant to word.'); exit;
    end;
  end;
  stVariab: begin
    typWord.DefineRegister;
    if res.Typ = typByte then begin
      SetResultExpres(typWord);  //No podemos devolver variable. Pero sí expresión
      _CLRF(H.offs);
      _MOVF(res.offs, toW);
    end else if res.Typ = typChar then begin
      SetResultExpres(typWord);  //No podemos devolver variable. Pero sí expresión
      _CLRF(H.offs);
      _MOVF(res.offs, toW);
    end else if res.Typ = typWord then begin
      //ya es Word
    end else if res.Typ = typDWord then begin
      //Crea varaible que apunte al word bajo
      tmpVar := CreateTmpVar('', typWord);   //crea variable temporal Word
      tmpVar.addr0 := res.rVar.addr0; //apunta al byte L
      tmpVar.addr1 := res.rVar.addr1; //apunta al byte H
      SetResultVariab(tmpVar);
    end else if (res.Typ = typBool) or (res.Typ = typBit) then begin
      SetResultExpres(typWord);  //Devolvemo expresión
      _CLRF(H.offs);
      kMOVLW(0);
      _BTFSC(_STATUS, _Z);
      kMOVLW(1);
    end else begin
      GenError('Cannot convert this variable to word.'); exit;
    end;
  end;
  stExpres: begin  //se asume que ya está en (w)
    typWord.DefineRegister;
    if res.Typ = typByte then begin
      res.SetAsExpres(typWord);
      //Ya está en W el byte bajo
      _CLRF(H.offs);
    end else if res.Typ = typChar then begin
      res.SetAsExpres(typWord);
      //Ya está en W el byte bajo
      _CLRF(H.offs);
    end else if res.Typ = typWord then begin
//      Ya es word
    end else if res.Typ = typDWord then begin
      res.SetAsExpres(typWord);
      //Ya está en H,W el word bajo
    end else if (res.Typ = typBool) or (res.Typ = typBit) then begin
      res.SetAsExpres(typWord);
      _CLRF(H.offs);
      kMOVLW(0);    //Z -> W
      _BTFSC(_STATUS, _Z);
      kMOVLW(1);
    end else begin
      GenError('Cannot convert expression to word.'); exit;
    end;
  end;
  else
    genError('Not implemented "%s" for this operand.', [fun.name]);
  end;
  if not CaptureTok(')') then exit;
end;
procedure TGenCod.fun_DWord(fun: TxpEleFunBase; out AddrUndef: boolean);
begin
  if not CaptureTok('(') then exit;
  res := GetExpression(0);  //Captura parámetro. No usa GetExpressionE, para no cambiar RTstate
  if HayError then exit;   //aborta
  case res.Sto of  //el parámetro debe estar en "res"
  stConst : begin
    if res.Typ = typByte then begin
      res.SetAsConst(typDWord);  //Solo cambia el tipo
    end else if res.Typ = typChar then begin
      res.SetAsConst(typDWord);  //Solo cambia el tipo
    end else if res.Typ = typWord then begin
      res.SetAsConst(typDWord);  //Solo cambia el tipo
    end else if res.Typ = typDWord then begin
      //ya es DWord
    end else if (res.Typ = typBool) or (res.Typ = typBit) then begin
      res.SetAsConst(typDWord);  //Solo cambia el tipo
      if res.valBool then res.valInt := 1 else res.valInt := 0;
    end else begin
      GenError('Cannot convert this constant to Dword.'); exit;
    end;
  end;
  stVariab: begin
    typDword.DefineRegister;
    if res.Typ = typByte then begin
      SetResultExpres(typDWord);  //No podemos devolver variable. Pero sí expresión
      _CLRF(U.offs);
      _CLRF(E.offs);
      _CLRF(H.offs);
      _MOVF(res.offs, toW);
    end else if res.Typ = typChar then begin
      SetResultExpres(typDWord);  //No podemos devolver variable. Pero sí expresión
      _CLRF(U.offs);
      _CLRF(E.offs);
      _CLRF(H.offs);
      _MOVF(res.offs, toW);
    end else if res.Typ = typWord then begin
      SetResultExpres(typDWord);  //No podemos devolver variable. Pero sí expresión
      _CLRF(U.offs);
      _CLRF(E.offs);
      _MOVF(res.Hoffs, toW);
      _MOVWF(H.offs);
      _MOVF(res.Loffs, toW);
    end else if res.Typ = typDWord then begin
      //ya es Word. Lo deja como varaible DWord
    end else if (res.Typ = typBool) or (res.Typ = typBit) then begin
      SetResultExpres(typDWord);  //No podemos devolver variable. Pero sí expresión
      _CLRF(U.offs);
      _CLRF(E.offs);
      _CLRF(H.offs);
      kMOVLW(0);    //Z -> W
      _BTFSC(_STATUS, _Z);
      kMOVLW(1);
    end else begin
      GenError('Cannot convert this variable to Dword.'); exit;
    end;
  end;
  stExpres: begin  //se asume que ya está en (w)
    typDword.DefineRegister;
    if res.Typ = typByte then begin
      res.SetAsExpres(typDWord);  //No podemos devolver variable. Pero sí expresión
      //Ya está en W el byte bajo
      _CLRF(U.offs);
      _CLRF(E.offs);
      _CLRF(H.offs);
    end else if res.Typ = typChar then begin
      res.SetAsExpres(typDWord);  //No podemos devolver variable. Pero sí expresión
      //Ya está en W el byte bajo
      _CLRF(U.offs);
      _CLRF(E.offs);
      _CLRF(H.offs);
    end else if res.Typ = typWord then begin
      res.SetAsExpres(typDWord);  //No podemos devolver variable. Pero sí expresión
      //Ya está en H,W el word
      _CLRF(U.offs);
      _CLRF(E.offs);
    end else if res.Typ = typDWord then begin
//      Ya es Dword
    end else if (res.Typ = typBool) or (res.Typ = typBit) then begin
      res.SetAsExpres(typDWord);  //No podemos devolver variable. Pero sí expresión
      _CLRF(U.offs);
      _CLRF(E.offs);
      _CLRF(H.offs);
      kMOVLW(0);    //Z -> W
      _BTFSC(_STATUS, _Z);
      kMOVLW(1);
    end else begin
      GenError('Cannot convert expression to Dword.'); exit;
    end;
  end;
  else
    genError('Not implemented "%s" for this operand.', [fun.name]);
  end;
  if not CaptureTok(')') then exit;
end;
procedure TGenCod.fun_SetAsInput(fun: TxpEleFunBase; out AddrUndef: boolean);
begin
  if not CaptureTok('(') then exit;
  res := GetExpression(0);  //captura parámetro
  if HayError then exit;   //aborta
  case res.Sto of  //el parámetro debe estar en "res"
  stConst : begin
    GenError('PORT or BIT variable expected.'); exit;
  end;
  stVariab: begin
    if res.Typ = typByte then begin
      //Se asume que será algo como PORTA, PORTB, ...
      kMOVLW($FF);   //todos como entradas
      _BANKSEL(1);   //los registros TRIS, están en el banco 1
      _MOVWF(res.offs); //escribe en TRIS
    end else if res.Typ = typBit then begin
      //Se asume que será algo como PORTA.0, PORTB.0, ...
      _BANKSEL(1);   //los registros TRIS, están en el banco 1
      _BSF(res.offs, res.bit); //escribe en TRIS
    end else begin
      GenError('Invalid type.'); exit;
    end;
    res.SetAsNull; //No es función así que no es necesario fijar el resultado
  end;
  stExpres: begin  //se asume que ya está en (w)
    GenError('PORT variable expected.'); exit;
  end;
  else
    genError('Not implemented "%s" for this operand.', [fun.name]);
  end;
  if not CaptureTok(')') then exit;
end;
procedure TGenCod.fun_SetAsOutput(fun: TxpEleFunBase; out AddrUndef: boolean);
begin
  if not CaptureTok('(') then exit;
  res := GetExpression(0);  //captura parámetro
  if HayError then exit;   //aborta
  case res.Sto of  //el parámetro debe estar en "res"
  stConst : begin
    GenError('PORT variable expected.'); exit;
  end;
  stVariab: begin
    if res.Typ = typByte then begin
      //Se asume que será algo como PORTA, PORTB, ...
      _BANKSEL(1);   //los registros TRIS, están en el banco 1
      _CLRF(res.offs); //escribe en TRIS
    end else if res.Typ = typBit then begin
      //Se asume que será algo como PORTA.0, PORTB.0, ...
      _BANKSEL(1);   //los registros TRIS, están en el banco 1
      _BCF(res.offs, res.bit); //escribe en TRIS
    end else begin
      GenError('Invalid type.'); exit;
    end;
    res.SetAsNull; //No es función así que no es necesario fijar el resultado
  end;
  stExpres: begin  //se asume que ya está en (w)
    GenError('PORT variable expected.'); exit;
  end;
  else
    genError('Not implemented "%s" for this operand.', [fun.name]);
  end;
  if not CaptureTok(')') then exit;
end;
procedure TGenCod.fun_SetBank(fun: TxpEleFunBase; out AddrUndef: boolean);
{Define el banco actual}
begin
  if not CaptureTok('(') then exit;
  res := GetExpression(0);  //captura parámetro
  if HayError then exit;   //aborta
  case res.Sto of  //el parámetro debe estar en "res"
  stConst : begin
    if (res.Typ = typByte) or (res.Typ = typWord) or (res.Typ = typDWord) then begin
      //ya es Word
      CurrBank := 255;   //para forzar el cambio
      _BANKSEL(res.valInt);
    end else begin
      GenError('Number expected.'); exit;
    end;
  end;
  stVariab, stExpres: begin  //se asume que ya está en (w)
    GenError('A constant expected.'); exit;
  end;
  else
    genError('Not implemented "%s" for this operand.', [fun.name]);
  end;
  if not CaptureTok(')') then exit;
end;
procedure TGenCod.StartSyntax;
//Se ejecuta solo una vez al inicio
begin
  ///////////define la sintaxis del compilador
  //Tipos de tokens personalizados
  tnExpDelim := xLex.NewTokType('ExpDelim');//delimitador de expresión ";"
  tnBlkDelim := xLex.NewTokType('BlkDelim'); //delimitador de bloque
  tnStruct   := xLex.NewTokType('Struct');   //personalizado
  tnDirective:= xLex.NewTokType('Directive'); //personalizado
  tnAsm      := xLex.NewTokType('Asm');      //personalizado
  tnChar     := xLex.NewTokType('Char');     //personalizado
  tnOthers   := xLex.NewTokType('Others');   //personalizado
  //Configura atributos
  tkKeyword.Style := [fsBold];     //en negrita
  xLex.Attrib[tnBlkDelim].Foreground:=clGreen;
  xLex.Attrib[tnBlkDelim].Style := [fsBold];    //en negrita
  xLex.Attrib[tnStruct].Foreground:=clGreen;
  xLex.Attrib[tnStruct].Style := [fsBold];      //en negrita
  //inicia la configuración
  xLex.ClearMethodTables;          //limpia tabla de métodos
  xLex.ClearSpecials;              //para empezar a definir tokens
  //crea tokens por contenido
  xLex.DefTokIdentif('[A-Za-z_]', '[A-Za-z0-9_]*');
  xLex.DefTokContent('[0-9]', '[0-9.]*', tnNumber);
  xLex.DefTokContent('[$]','[0-9A-Fa-f]*', tnNumber);
  xLex.DefTokContent('[%]','[01]*', tnNumber);
  //define palabras claves
  xLex.AddIdentSpecList('THEN var type absolute interrupt', tnKeyword);
  xLex.AddIdentSpecList('program public private method const', tnKeyword);
  xLex.AddIdentSpecList('class create destroy sub do begin', tnKeyword);
  xLex.AddIdentSpecList('END ELSE ELSIF UNTIL', tnBlkDelim);
  xLex.AddIdentSpecList('true false', tnBoolean);
  xLex.AddIdentSpecList('if while repeat for', tnStruct);
  xLex.AddIdentSpecList('and or xor not div mod in', tnOperator);
  xLex.AddIdentSpecList('umulword', tnOperator);
  //tipos predefinidos
  xLex.AddIdentSpecList('bit boolean byte word char dword', tnType);
  //funciones del sistema
  xLex.AddIdentSpecList('exit Inc Dec Ord Chr', tnSysFunct);
  xLex.AddIdentSpecList('SetAsInput SetAsOutput SetBank', tnSysFunct);
  //símbolos especiales
  xLex.AddSymbSpec('+',  tnOperator);
  xLex.AddSymbSpec('+=', tnOperator);
  xLex.AddSymbSpec('-=', tnOperator);
  xLex.AddSymbSpec('-',  tnOperator);
  xLex.AddSymbSpec('*',  tnOperator);
  xLex.AddSymbSpec('/',  tnOperator);
  xLex.AddSymbSpec('\',  tnOperator);
//  xLex.AddSymbSpec('%',  tnOperator);
  xLex.AddSymbSpec('**', tnOperator);
  xLex.AddSymbSpec('=',  tnOperator);
  xLex.AddSymbSpec('>',  tnOperator);
  xLex.AddSymbSpec('<',  tnOperator);
  xLex.AddSymbSpec('>=', tnOperator);
  xLex.AddSymbSpec('<=', tnOperator);
  xLex.AddSymbSpec('<>', tnOperator);
  xLex.AddSymbSpec('<=>',tnOperator);
  xLex.AddSymbSpec(':=', tnOperator);
  xLex.AddSymbSpec('>>', tnOperator);
  xLex.AddSymbSpec('<<', tnOperator);
  xLex.AddSymbSpec('^', tnOperator);
  xLex.AddSymbSpec('@', tnOperator);
  xLex.AddSymbSpec('.', tnOperator);
  xLex.AddSymbSpec(';', tnExpDelim);
  xLex.AddSymbSpec('(',  tnOthers);
  xLex.AddSymbSpec(')',  tnOthers);
  xLex.AddSymbSpec(':',  tnOthers);
  xLex.AddSymbSpec(',',  tnOthers);
  xLex.AddSymbSpec('[',  tnOthers);
  xLex.AddSymbSpec(']',  tnOthers);
  //crea tokens delimitados
  xLex.DefTokDelim('''','''', tnString);
  xLex.DefTokContent('[#]','[0-9]*', tnChar);
//  xLex.DefTokDelim('"','"', tnString);

  xLex.DefTokDelim('//','', xLex.tnComment);
  xLex.DefTokDelim('{','}', xLex.tnComment, tdMulLin);
  xLex.DefTokDelim('(\*','\*)', xLex.tnComment, tdMulLin);
  xLex.DefTokDelim('{$','}', tnDirective, tdUniLin);
  xLex.DefTokDelim('Asm','End', tnAsm, tdMulLin);
  //define bloques de sintaxis
//  xLex.AddBlock('{','}');
  xLex.Rebuild;   //es necesario para terminar la definición
end;
procedure TGenCod.DefCompiler;
var
  opr: TxpOperator;
begin
  //Define métodos a usar
  OnExprStart := @expr_start;
  OnExprEnd := @expr_End;

  ///////////Crea tipos
  ClearSystemTypes;
  ///////////////// Tipo Bit ////////////////
  typBit := CreateSysType('bit', t_uinteger,-1);   //de 1 bit
  typBit.OnLoadToRT  :=  @bit_LoadToRT;
  typBit.OnDefRegister:= @bit_DefineRegisters;
  typBit.OnSaveToStk  := @bit_SaveToStk;
//  opr:=typBit.CreateUnaryPreOperator('@', 6, 'addr', @Oper_addr_bit);

  ///////////////// Tipo Booleano ////////////////
  typBool := CreateSysType('boolean',t_boolean,-1);   //de 1 bit
  typBool.OnLoadToRT   := @bit_LoadToRT;  //es lo mismo
  typBool.OnDefRegister:= @bit_DefineRegisters;  //es lo mismo
  typBool.OnSaveToStk  := @bit_SaveToStk;  //es lo mismo

  //////////////// Tipo Byte /////////////
  typByte := CreateSysType('byte',t_uinteger,1);   //de 1 byte
  typByte.OnLoadToRT   := @byte_LoadToRT;
  typByte.OnDefRegister:= @byte_DefineRegisters;
  typByte.OnSaveToStk  := @byte_SaveToStk;
  //typByte.OnReadFromStk :=
  //Campos de bit
  typByte.CreateField('bit0', @byte_bit0, @byte_bit0);
  typByte.CreateField('bit1', @byte_bit1, @byte_bit1);
  typByte.CreateField('bit2', @byte_bit2, @byte_bit2);
  typByte.CreateField('bit3', @byte_bit3, @byte_bit3);
  typByte.CreateField('bit4', @byte_bit4, @byte_bit4);
  typByte.CreateField('bit5', @byte_bit5, @byte_bit5);
  typByte.CreateField('bit6', @byte_bit6, @byte_bit6);
  typByte.CreateField('bit7', @byte_bit7, @byte_bit7);
  //Campos de bit (se mantienen por compatibilidad)
  typByte.CreateField('0', @byte_bit0, @byte_bit0);
  typByte.CreateField('1', @byte_bit1, @byte_bit1);
  typByte.CreateField('2', @byte_bit2, @byte_bit2);
  typByte.CreateField('3', @byte_bit3, @byte_bit3);
  typByte.CreateField('4', @byte_bit4, @byte_bit4);
  typByte.CreateField('5', @byte_bit5, @byte_bit5);
  typByte.CreateField('6', @byte_bit6, @byte_bit6);
  typByte.CreateField('7', @byte_bit7, @byte_bit7);

  //////////////// Tipo Char /////////////
  //Tipo caracter
  typChar := CreateSysType('char',t_uinteger,1);   //de 1 byte. Se crea como uinteger para leer/escribir su valor como número
  typChar.OnLoadToRT   := @byte_LoadToRT;  //Es lo mismo
  typChar.OnDefRegister:= @byte_DefineRegisters;  //Es lo mismo
  typChar.OnSaveToStk  := @byte_SaveToStk; //Es lo mismo

  //////////////// Tipo Word /////////////
  //Tipo numérico de dos bytes
  typWord := CreateSysType('word',t_uinteger,2);   //de 2 bytes
  typWord.OnLoadToRT   := @word_LoadToRT;
  typWord.OnDefRegister:= @word_DefineRegisters;
  typWord.OnSaveToStk  := @word_SaveToStk;

  typWord.CreateField('Low' , @word_Low , @word_Low );
  typWord.CreateField('High', @word_High, @word_High);

  //////////////// String type /////////////
  {Se crea el tipo String, solo para permitir inicializar arreglos de
  caracteres. Por ahora no se implementan otras funcionalidades.}
  typString := CreateSysType('string', t_string, 0);  //tamaño variable
  { TODO : String debería definirse mejor como un tipo común, no del sistema }

  //////////////// Tipo DWord /////////////
  //Tipo numérico de cuatro bytes
  typDWord := CreateSysType('dword',t_uinteger,4);  //de 4 bytes
  typDWord.OnLoadToRT   := @dword_LoadToRT;
  typDWord.OnDefRegister:= @dword_DefineRegisters;
  typDWord.OnSaveToStk  := @dword_SaveToStk;

  typDWord.CreateField('Low'     , @dword_Low     , @dword_Low     );
  typDWord.CreateField('High'    , @dword_High    , @dword_High    );
  typDWord.CreateField('Extra'   , @dword_Extra   , @dword_Extra   );
  typDWord.CreateField('Ultra'   , @dword_Ultra   , @dword_Ultra   );
  typDWord.CreateField('LowWord' , @dword_LowWord , @dword_LowWord );
  typDWord.CreateField('HighWord', @dword_HighWord, @dword_HighWord);

  {Los operadores deben crearse con su precedencia correcta
  Precedencia de operadores en Pascal:
  6)    ~, not, signo "-"   (mayor precedencia)
  5)    *, /, div, mod, and, shl, shr, &
  4)    |, !, +, -, or, xor
  3)    =, <>, <, <=, >, >=, in
  2)    :=                  (menor precedencia)
  }
  //////////////////////////////////////////
  //////// Operaciones con Bit ////////////

  opr:=typBit.CreateBinaryOperator(':=',2,'asig');  //asignación
  opr.CreateOperation(typBit, @ROB_bit_asig_bit);
  opr.CreateOperation(typByte, @ROB_bit_asig_byte);

  opr:=typBit.CreateUnaryPreOperator('NOT', 6, 'not', @ROU_not_bit);

  opr:=typBit.CreateBinaryOperator('AND',4,'and');
  opr.CreateOperation(typBit,@ROB_bit_and_bit);
  opr.CreateOperation(typByte,@ROB_bit_and_byte);

  opr:=typBit.CreateBinaryOperator('OR',4,'or');
  opr.CreateOperation(typBit,@ROB_bit_or_bit);
  opr.CreateOperation(typByte,@ROB_bit_or_byte);

  opr:=typBit.CreateBinaryOperator('XOR',4,'or');
  opr.CreateOperation(typBit,@ROB_bit_xor_bit);
  opr.CreateOperation(typByte,@ROB_bit_xor_byte);

  opr:=typBit.CreateBinaryOperator('=',4,'equal');
  opr.CreateOperation(typBit,@ROB_bit_equ_bit);
  opr.CreateOperation(typByte,@ROB_bit_equ_byte);

  opr:=typBit.CreateBinaryOperator('<>',4,'difer');
  opr.CreateOperation(typBit,@ROB_bit_dif_bit);
  opr.CreateOperation(typByte,@ROB_bit_dif_byte);

  //////////////////////////////////////////
  //////// Operaciones con Boolean ////////////
  opr:=typBool.CreateBinaryOperator(':=',2,'asig');  //asignación
  opr.CreateOperation(typBool,@ROB_bool_asig_bool);

  opr:=typBool.CreateUnaryPreOperator('NOT', 6, 'not', @ROU_not_bool);

  opr:=typBool.CreateBinaryOperator('AND',4,'and');  //suma
  opr.CreateOperation(typBool,@ROB_bool_and_bool);

  opr:=typBool.CreateBinaryOperator('OR',4,'or');  //suma
  opr.CreateOperation(typBool,@ROB_bool_or_bool);

  opr:=typBool.CreateBinaryOperator('XOR',4,'or');  //suma
  opr.CreateOperation(typBool,@ROB_bool_xor_bool);

  opr:=typBool.CreateBinaryOperator('=',4,'equal');
  opr.CreateOperation(typBool,@ROB_bool_equ_bool);

  opr:=typBool.CreateBinaryOperator('<>',4,'difer');
  opr.CreateOperation(typBool,@ROB_bool_dif_bool);
  //////////////////////////////////////////
  //////// Operaciones con Byte ////////////
  //////////////////////////////////////////
  {Los operadores deben crearse con su precedencia correcta}
  opr:=typByte.CreateBinaryOperator(':=',2,'asig');  //asignación
  opr.CreateOperation(typByte,@ROB_byte_asig_byte);
  opr:=typByte.CreateBinaryOperator('+=',2,'aadd');  //asignación-suma
  opr.CreateOperation(typByte,@ROB_byte_aadd_byte);
  opr:=typByte.CreateBinaryOperator('-=',2,'asub');  //asignación-resta
  opr.CreateOperation(typByte,@ROB_byte_asub_byte);

  opr:=typByte.CreateBinaryOperator('+',4,'add');  //suma
  opr.CreateOperation(typByte,@ROB_byte_add_byte);
  opr.CreateOperation(typWord,@ROB_byte_add_word);
  opr:=typByte.CreateBinaryOperator('-',4,'subs');  //suma
  opr.CreateOperation(typByte,@ROB_byte_sub_byte);
  opr:=typByte.CreateBinaryOperator('*',5,'mult');  //byte*byte -> word
  opr.CreateOperation(typByte,@ROB_byte_mul_byte);
  opr.CreateOperation(typWord,@ROB_byte_mul_word);

  opr:=typByte.CreateBinaryOperator('DIV',5,'div');  //byte / byte ->byte
  opr.CreateOperation(typByte,@ROB_byte_div_byte);
  opr:=typByte.CreateBinaryOperator('MOD',5,'mod');  //byte mod byte ->byte
  opr.CreateOperation(typByte,@ROB_byte_mod_byte);

  opr:=typByte.CreateBinaryOperator('AND',5,'and');  //suma
  opr.CreateOperation(typByte,@ROB_byte_and_byte);
  opr.CreateOperation(typBit ,@ROB_byte_and_bit);
  opr:=typByte.CreateBinaryOperator('OR',4,'or');  //suma
  opr.CreateOperation(typByte,@ROB_byte_or_byte);
  opr.CreateOperation(typBit,@ROB_byte_or_bit);
  opr:=typByte.CreateBinaryOperator('XOR',4,'xor');  //suma
  opr.CreateOperation(typByte,@ROB_byte_xor_byte);
  opr.CreateOperation(typBit,@ROB_byte_xor_bit);

  opr:=typByte.CreateUnaryPreOperator('NOT', 6, 'not', @ROU_not_byte);
  opr:=typByte.CreateUnaryPreOperator('@', 6, 'addr', @ROU_address);

  opr:=typByte.CreateBinaryOperator('=',3,'equal');
  opr.CreateOperation(typByte,@ROB_byte_equal_byte);
  opr:=typByte.CreateBinaryOperator('<>',3,'difer');
  opr.CreateOperation(typByte,@ROB_byte_difer_byte);
  opr.CreateOperation(typBit,@ROB_byte_difer_bit);

  opr:=typByte.CreateBinaryOperator('>',3,'great');
  opr.CreateOperation(typByte,@ROB_byte_great_byte);
  opr:=typByte.CreateBinaryOperator('<',3,'less');
  opr.CreateOperation(typByte,@ROB_byte_less_byte);

  opr:=typByte.CreateBinaryOperator('>=',3,'gequ');
  opr.CreateOperation(typByte,@ROB_byte_gequ_byte);
  opr:=typByte.CreateBinaryOperator('<=',3,'lequ');
  opr.CreateOperation(typByte,@ROB_byte_lequ_byte);

  opr:=typByte.CreateBinaryOperator('>>',5,'shr');  { TODO : Definir bien la precedencia }
  opr.CreateOperation(typByte,@ROB_byte_shr_byte);
  opr:=typByte.CreateBinaryOperator('<<',5,'shl');
  opr.CreateOperation(typByte,@ROB_byte_shl_byte);
  //////////////////////////////////////////
  //////// Operaciones con Char ////////////
  {Los operadores deben crearse con su precedencia correcta}
  opr:=typChar.CreateBinaryOperator(':=',2,'asig');  //asignación
  opr.CreateOperation(typChar,@ROB_char_asig_char);
  opr:=typChar.CreateBinaryOperator('=',3,'equal');  //asignación
  opr.CreateOperation(typChar,@ROB_char_equal_char);
  opr:=typChar.CreateBinaryOperator('<>',3,'difer');  //asignación
  opr.CreateOperation(typChar,@ROB_char_difer_char);

  //////////////////////////////////////////
  //////// Operaciones con Word ////////////
  {Los operadores deben crearse con su precedencia correcta}

  opr:=typWord.CreateBinaryOperator(':=',2,'asig');  //asignación
  opr.CreateOperation(typWord,@ROB_word_asig_word);
  opr.CreateOperation(typByte,@ROB_word_asig_byte);

  opr:=typWord.CreateBinaryOperator('=',3,'equal');  //igualdad
  opr.CreateOperation(typWord,@ROB_word_equal_word);
  opr:=typWord.CreateBinaryOperator('<>',3,'difer');
  opr.CreateOperation(typWord,@ROB_word_difer_word);
  opr:=typWord.CreateBinaryOperator('>',3,'difer');
  opr.CreateOperation(typWord,@ROB_word_great_word);

  opr:=typWord.CreateBinaryOperator('+',4,'suma');  //suma
  opr.CreateOperation(typWord,@ROB_word_add_word);
  opr.CreateOperation(typByte,@ROB_word_add_byte);

  opr:=typWord.CreateBinaryOperator('-',4,'subs');  //suma
  opr.CreateOperation(typWord,@ROB_word_sub_word);

  opr:=typWord.CreateBinaryOperator('*',5,'mult');  //byte*byte -> word
  opr.CreateOperation(typByte,@ROB_word_mul_byte);
  opr.CreateOperation(typWord,@ROB_word_mul_word);

  opr:=typWord.CreateBinaryOperator('AND', 5, 'and');  //AND
  opr.CreateOperation(typByte, @ROB_word_and_byte);

  opr:=typWord.CreateBinaryOperator('UMULWORD',5,'umulword');  //suma
  opr.CreateOperation(typWord,@ROB_word_umulword_word);

  opr:=typWord.CreateUnaryPreOperator('@', 6, 'addr', @ROU_address);

  //////////////////////////////////////////
  //////// Operaciones con DWord ////////////
  {Los operadores deben crearse con su precedencia correcta}
  opr:=typDWord.CreateBinaryOperator(':=',2,'asig');  //asignación
  opr.CreateOperation(typDWord,@ROB_dword_asig_dword);
  opr.CreateOperation(typWord,@ROB_dword_asig_word);
  opr.CreateOperation(typByte,@ROB_dword_asig_byte);

  opr:=typDWord.CreateBinaryOperator('=',3,'equal');  //igualdad
  opr.CreateOperation(typDWord,@ROB_dword_equal_dword);
  opr:=typDWord.CreateBinaryOperator('<>',3,'difer');
  opr.CreateOperation(typDWord,@ROB_dword_difer_dword);

  opr:=typDWord.CreateBinaryOperator('+=',2,'asuma');  //suma
  opr.CreateOperation(typDWord,@ROB_dword_aadd_dword);

  opr:=typDWord.CreateBinaryOperator('+',4,'suma');  //suma
  opr.CreateOperation(typDWord,@ROB_dword_add_dword);
//  opr.CreateOperation(typByte,@ROB_word_add_byte);

  //////// Operaciones con String ////////////
  opr:=typString.CreateUnaryPreOperator('@', 6, 'addr', @ROU_address);
  opr:=typString.CreateBinaryOperator('+',4,'add');  //add
  opr.CreateOperation(typString,@ROB_string_add_string);
  opr.CreateOperation(typChar,@ROB_string_add_char);
end;
procedure TGenCod.DefPointerArithmetic(etyp: TxpEleType);
{Configura ls operaciones que definen la aritmética de punteros.}
var
  opr: TxpOperator;
begin
  //Asignación desde Byte y Puntero
  opr:=etyp.CreateBinaryOperator(':=',2,'asig');
  opr.CreateOperation(typByte, @ROB_byte_asig_byte);
  opr.CreateOperation(etyp   , @ROB_byte_asig_byte);
  //Agrega a los bytes, la posibilidad de ser asignados por punteros
  typByte.operAsign.CreateOperation(etyp, @ROB_byte_asig_byte);

  opr:=etyp.CreateBinaryOperator('=',3,'equal');  //asignación
  opr.CreateOperation(typByte, @ROB_byte_equal_byte);
  opr:=etyp.CreateBinaryOperator('+',4,'add');  //suma
  opr.CreateOperation(typByte, @ROB_pointer_add_byte);
  opr:=etyp.CreateBinaryOperator('-',4,'add');  //resta
  opr.CreateOperation(typByte, @ROB_pointer_sub_byte);
end;
procedure TGenCod.DefinePointer(etyp: TxpEleType);
{Set operations that defines pointers aritmethic.}
var
  opr: TxpOperator;
begin
  //Asignación desde Byte y Puntero
//  opr:=etyp.CreateBinaryOperator(':=',2,'asig');
//  opr.CreateOperation(typWord, @ROB_word_asig_word);
//  opr.CreateOperation(etyp   , @ROB_word_asig_word);
//  //Agrega a los word, la posibilidad de ser asignados por punteros
//  typWord.operAsign.CreateOperation(etyp, @ROB_word_asig_word);
//
//  opr:=etyp.CreateBinaryOperator('=',3,'equal');  //asignación
//  opr.CreateOperation(typWord, @ROB_word_equal_word);
//  opr:=etyp.CreateBinaryOperator('+',4,'add');  //suma
//  opr.CreateOperation(typWord, @ROB_pointer_add_word);
//  opr:=etyp.CreateBinaryOperator('-',4,'add');  //resta
//  opr.CreateOperation(typWord, @ROB_pointer_sub_word);
//
//  etyp.CreateUnaryPreOperator('@', 6, 'addr', @ROU_address); //defined in all types
//  etyp.CreateUnaryPostOperator('^',6, 'deref', @ROU_derefPointer);  //dereferencia
end;
procedure TGenCod.DefineArray(etyp: TxpEleType);
begin
//  etyp.CreateField('length', @arrayLength, nil);
//  etyp.CreateField('high'  , @arrayHigh, nil);
//  etyp.CreateField('low'   , @arrayLow, nil);
//  etyp.CreateField('item'  , @GenCodArrayGetItem, @GenCodArraySetItem);
//  etyp.CreateField('clear' , @GenCodArrayClear, nil);
//  etyp.CreateUnaryPreOperator('@', 6, 'addr', @ROU_address); //defined in all types
end;
procedure TGenCod.ValidRAMaddr(addr: integer);
{Validate a physical RAM address. If error generate error.}
begin
  if (addr<0) or (addr>$ffff) then begin
    //Debe set Word
    GenError(ER_INV_MEMADDR);
    exit;
  end;
  if not pic.ValidRAMaddr(addr) then begin
    GenError(ER_INV_MAD_DEV);
    exit;
  end;
end;
procedure TGenCod.CreateSystemElements;
{Inicia los elementos del sistema. Se ejecuta cada vez que se compila.}
  procedure AddParam(var pars: TxpParFuncArray; parName: string; const srcPos: TSrcPos;
                     typ0: TxpEleType; adicDec: TxpAdicDeclar);
  //Create a new parameter to the function.
  var
    n: Integer;
  begin
    //Add record to the array
    n := high(pars)+1;
    setlength(pars, n+1);
    pars[n].name := parName;  //Name is not important
    pars[n].srcPos := srcPos;
    pars[n].typ  := typ0;  //Agrega referencia
    pars[n].adicVar.hasAdic := adicDec;
    pars[n].adicVar.hasInit := false;
  end;
  function CreateSystemFunction(name: string; retType: TxpEleType; const srcPos: TSrcPos;
                                const pars: TxpParFuncArray;
                                compile: TProcExecFunction): TxpEleFun;
  {Create a new system function in the current element of the Syntax Tree.
   Returns the reference to the function created.}
  var
     fundec: TxpEleFunDec;
     bod: TxpEleBody;
  begin
    //Add declaration
    curLocation := locInterface;
    fundec := AddFunctionDEC(name, retType, srcPos, pars, false);
    //Implementation
    {Note that implementation is added always after declarartion. It's not the usual
    in common units, where all declarations are first}
    curLocation := locImplement;
    Result := AddFunctionIMP(name, retType, srcPos, fundec);
    //Here varaibles can be added
    {Create a body, to be uniform with normal function and for have a space where
    compile code and access to posible variables or other elements.}
    bod := CreateBody;
    bod.srcDec := srcPos;
    TreeElems.AddElement(bod);  //Add Body (not need to open)
    Result.compile := compile;  //Set routine to geenrate code
    TreeElems.CloseElement;  //Close function implementation
  end;
var
  f: TxpEleFun;  //índice para funciones
  uni: TxpEleUnit;
  pars: TxpParFuncArray;  //Array of parameters
  srcPos: TSrcPos;
begin
  //////// Funciones del sistema ////////////
  {Notar que las funciones del sistema no crean espacios de nombres.}
//  f := CreateSysFunction('delay_ms', nil, @fun_delay_ms);
//  f.adrr:=$0;
//  f.compile := @codif_delay_ms;  //rutina de compilación
  //Funciones INLINE
  f := CreateSysFunction('exit'     , nil, @fun_Exit);
  f := CreateSysFunction('Inc'      , nil, @fun_Inc);
  f := CreateSysFunction('Dec'      , nil, @fun_Dec);
  f := CreateSysFunction('Ord'      , @FunctParam, @fun_Ord);
  f := CreateSysFunction('Chr'      , @FunctParam, @fun_Chr);
  f := CreateSysFunction('Bit'      , @FunctParam, @fun_Bit);
  f := CreateSysFunction('Boolean'  , @FunctParam, @fun_Bool);
  f := CreateSysFunction('Byte'     , @FunctParam, @fun_Byte);
  f := CreateSysFunction('Word'     , @FunctParam, @fun_Word);
  f := CreateSysFunction('DWord'    , @FunctParam, @fun_DWord);
  f := CreateSysFunction('SetAsInput' ,nil, @fun_SetAsInput);
  f := CreateSysFunction('SetAsOutput',nil, @fun_SetAsOutput);
  f := CreateSysFunction('SetBank'  , nil, @fun_SetBank);
  //Funciones de sistema para operaciones aritméticas/lógicas complejas
  //Multiplicación byte por byte a word
  f_byte_mul_byte_16 := CreateSysFunction('byte_mul_byte_16', nil, nil);
  f_byte_mul_byte_16.adrr:=$0;
  f_byte_mul_byte_16.compile := @mul_byte_16;
  //Multiplicación byte DIV, MOD byte a byte
  f_byte_div_byte := CreateSysFunction('byte_div_byte', nil, nil);
  f_byte_div_byte.adrr:=$0;
  f_byte_div_byte.compile := @byte_div_byte;
  //Multiplicación word por word a word
  f_word_mul_word_16 := CreateSysFunction('word_mul_word_16', nil, nil);
  f_word_mul_word_16.adrr:=$0;
  f_word_mul_word_16.compile := @word_mul_word_16;
  //Inicializa eventos y funciones del compilador
  callDefinePointer:= @DefinePointer;
  callDefineArray  := @DefineArray;
  callValidRAMaddr := @ValidRAMaddr;
  callStartProgram := @Cod_StartProgram;
  callEndProgram   := @Cod_EndProgram;
  //Create "System" Unit. Must be done once in First Pass
  {Originally system functions were created in a special list and has a special treatment
  but it implied a lot of work for manage the memory, linking, use of variables, and
  optimization. Now we create a "system unit" like a real unit (more less) and we create
  the system fucntion here, so we use the same code for linking, calling and optimization
  that we use in common fucntions. Moreover, we can create private functions.}
  uni := CreateUnit('-');
  TreeElems.AddElementAndOpen(uni);  //Open Unit
  //Create a fictional position
  srcPos.fil := '';
  srcPos.row := 1;
  srcPos.col := 1;
  {Create variables for aditional Working register. Note that this variables are
  accesible (and usable) from the code, because the name assigned is a common variable.}
  //Create register H as variable
  H := AddVariable('__H', typByte, srcPos);
  H.adicPar.hasAdic := decNone;
  H.adicPar.hasInit := false;
  H.location := locInterface;  //make visible
  //Create register E as variable
  E := AddVariable('__E', typByte, srcPos);
  E.adicPar.hasAdic := decNone;
  E.adicPar.hasInit := false;
  E.location := locInterface;  //make visible
  //Create register U as variable
  U := AddVariable('__U', typByte, srcPos);
  U.adicPar.hasAdic := decNone;
  U.adicPar.hasInit := false;
  U.location := locInterface;  //make visible

  //Create system function "delay_ms" with byte parameter
  setlength(pars, 0);  //Reset parameters
  AddParam(pars, 'ms', srcPos, typByte, decRegis);  //Add parameter
  f_delay_msB := CreateSystemFunction('delay_ms', typNull, srcPos,  pars, @codif_delay_ms);
  AddCallerTo(H, f.BodyNode); {Adds this dependency because, like this is a system function,
                           won`t be compiled in the First pass, that is when references are created.
                           As we need to use W. We declare a call.}
  //Create system function "delay_ms" with word parameter
  setlength(pars, 0);  //Reset parameters
  AddParam(pars, 'ms', srcPos, typWord, decRegis);  //Add parameter
  f_delay_msW := CreateSystemFunction('delay_ms', typNull, srcPos,  pars, @codif_delay_ms2);
  AddCallerTo(H, f.BodyNode); //Adds this dependency.
//
//  //Multiply system function
//  setlength(pars, 0);  //Reset parameters
//  AddParam(pars, 'A', srcPos, typByte, decNone);  //Add parameter
//  AddParam(pars, 'B', srcPos, typByte, decNone);  //Add parameter
//  f_byte_mul_byte_16 := CreateSystemFunction('byte_mul_byte_16', typWord, srcPos, pars, @byte_mul_byte_16);
//  AddCallerTo(H, f_byte_mul_byte_16.BodyNode);  //We'll need to return result.
//
//  //Word shift left
//  setlength(pars, 0);  //Reset parameters
//  AddParam(pars, 'n', srcPos, typByte, decRegisX);   //Parameter counter shift
//  f_word_shift_l := CreateSystemFunction('word_shift_l', typWord, srcPos, pars, @word_shift_l);
//  AddCallerTo(H, f_word_shift_l.BodyNode);  //We'll need to return result.
//
  TreeElems.CloseElement; //Close Unit
end;
end.

