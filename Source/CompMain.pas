unit CompMain;
{$mode objfpc}{$H+}
interface
uses
  Classes, SysUtils, CompBase, XpresElementsPIC, Globales, CompOperands,
  XpresTypesPIC, XpresBas;
type

  { TCompMain }
  TCompMain = class(TCompilerBase)
  protected
    procedure GetAdicVarDeclar(out IsBit: boolean; out aditVar: TAdicVarDec);
    procedure CompileGlobalConstDeclar;
  end;

procedure SetLanguage;

implementation
var
   ER_INV_MEMADDR, ER_EXP_VAR_IDE, ER_NUM_ADD_EXP, ER_CON_EXP_EXP,
   ER_EQU_EXPECTD, ER_IDEN_EXPECT, ER_NOT_IMPLEM_, ER_SEM_COM_EXP,
   ER_INV_ARR_SIZ, ER_ARR_SIZ_BIG, ER_IDE_TYP_EXP, ER_IDE_CON_EXP,
   ER_EQU_COM_EXP, ER_DUPLIC_IDEN
   : string;

procedure SetLanguage;
begin
  {$I ..\language\tra_CompMain.pas}
end;

procedure TCompMain.GetAdicVarDeclar(out IsBit: boolean; out aditVar: TAdicVarDec);
{Verifica si lo que sigue es la sintaxis ABSOLUTE ... . Si esa así, procesa el texto,
pone "IsAbs" en TRUE y actualiza los valores "absAddr" y "absBit". }
  function ReadAddres(tok: string): word;
  {Lee una dirección de RAM a partir de una cadena numérica.
  Puede generar error.}
  var
    n: LongInt;
  begin
    //COnvierte cadena (soporta binario y hexadecimal)
    if not TryStrToInt(tok, n) then begin
      //Podría fallar si es un número muy grande
      GenError(ER_INV_MEMADDR);
      {%H-}exit;
    end;
    CodValidRAMaddr(n);  //Validate address
    if HayError then exit(0);
    Result := n;
  end;
  function ReadAddresBit(tok: string): byte;
  {Lee la parte del bit de una dirección de RAM a partir de una cadena numérica.
  Puede generar error.}
  var
    n: Longint;
  begin
    if not TryStrToInt(tok, n) then begin
      GenError(ER_INV_MEMADDR);
      {%H-}exit;
    end;
    if (n<0) or (n>7) then begin
      GenError(ER_INV_MEMADDR);
      {%H-}exit;
    end;
    Result := n;   //no debe fallar
  end;
var
  xvar: TxpEleVar;
  n: integer;
  Op: TOperand;
begin
  aditVar.srcDec  := cIn.PosAct;  //Posición de inicio de posibles parámetros adic.
  aditVar.hasAdic := decNone;       //Bandera
  aditVar.hasInit := false;
  aditVar.absVar := nil;          //Por defecto
  if (cIn.tokL = 'absolute') or (cIn.tok = '@') then begin
    //// Hay especificación de dirección absoluta ////
    aditVar.hasAdic := decAbsol;    //marca bandera
    cIn.Next;
    ProcComments;
    if cIn.tokType = tnNumber then begin
      if (cIn.tok[1]<>'$') and ((pos('e', cIn.tok)<>0) or (pos('E', cIn.tok)<>0)) then begin
        //La notación exponencial, no es válida.
        GenError(ER_INV_MEMADDR);
        exit;
      end;
      n := pos('.', cIn.tok);   //no debe fallar
      if n=0 then begin
        //Número entero sin parte decimal
        aditVar.absAddr := ReadAddres(cIn.tok);
        cIn.Next;  //Pasa con o sin error, porque esta rutina es "Pasa siempre."
        //Puede que siga la parte de bit
        if cIn.tok = '.' then begin
          cIn.Next;
          IsBit := true;  //Tiene parte de bit
          aditVar.absBit := ReadAddresBit(cIn.tok);  //Parte decimal
          cIn.Next;  //Pasa con o sin error, porque esta rutina es "Pasa siempre."
        end else begin
          IsBit := false;  //No tiene parte de bit
        end;
      end else begin
        //Puede ser el formato <dirección>.<bit>, en un solo token, que es válido.
        IsBit := true;  //Se deduce que tiene punto decimal
        //Ya sabemos que tiene que ser decimal, con punto
        aditVar.absAddr := ReadAddres(copy(cIn.tok, 1, n-1));
        //Puede haber error
        aditVar.absBit := ReadAddresBit(copy(cIn.tok, n+1, 100));  //Parte decimal
        cIn.Next;  //Pasa con o sin error, porque esta rutina es "Pasa siempre."
      end;
    end else if cIn.tokType = tnIdentif then begin
      //Puede ser variable
      GetOperandIdent(Op); //
      if HayError then exit;
      if Op.Sto <> stVariab then begin
        GenError(ER_EXP_VAR_IDE);
        cIn.Next;  //Pasa con o sin error, porque esta rutina es "Pasa siempre."
        exit;
      end;
      //Mapeado a variable. Notar que puede ser una variable temporal, si se usa: <var_byte>.0
      xvar := Op.rVar;
      if Op.rVarBase=nil then begin
        aditVar.absVar := Op.rVar;  //Guarda referencia
      end else begin
        {Es un caso como "<Variab.Base>.0", conviene devolver la referencia a <Variab.Base>,
        en lugar de a la variable "<Variable Base>.0", considerando que:
        * GetOperandIdent() usa <Variable Base>, para registrar la llamada.
        * Esta referencia se usará luego para ver variables no usadas en
          TCompiler.CompileLinkProgram().}
        aditVar.absVar := Op.rVarBase;  //Guarda referencia
      end;
      //Ya tiene la variable en "xvar".
      if xvar.typ.IsBitSize then begin //boolean o bit
        IsBit := true;  //Es una dirección de bit
        aditVar.absAddr := xvar.addr;  //debe ser absoluta
        aditVar.absBit := xvar.adrBit.bit;
      end else begin
        //Es cualquier otra variable, que no sea bit. Se intentará
        IsBit := false;  //Es una dirección normal (byte)
        aditVar.absAddr := xvar.addr;  //debe ser absoluta
      end;
      if aditVar.absAddr = ADRR_ERROR then begin
        //No se puede obtener la dirección.
        GenError('Cannot locate variable at: %s', [xvar.name]);
  //      GenError('Internal Error: TxpEleVar.AbsAddr.');
        exit;
      end;
    end else begin   //error
      GenError(ER_NUM_ADD_EXP);
      cIn.Next;    //pasa siempre
      exit;
    end;
  end;
end;
procedure TCompMain.CompileGlobalConstDeclar;
var
  consNames: array of string;  //nombre de variables
  cons: TxpEleCon;
  srcPosArray: TSrcPosArray;
  i: integer;
begin
  SetLength(consNames, 0);
  //Procesa lista de constantes a,b,cons ;
  getListOfIdent(consNames, srcPosArray);
  if HayError then begin  //precisa el error
    GenError(ER_IDE_CON_EXP);
    exit;
  end;
  //puede seguir "=" o identificador de tipo
  if cIn.tok = '=' then begin
    cIn.Next;  //pasa al siguiente
    //Debe seguir una expresiócons constante, que no genere consódigo
    GetExpressionE(0);
    if HayError then exit;
    if res.Sto <> stConst then begin
      GenError(ER_CON_EXP_EXP);
    end;
    //Hasta aquí todo bien, crea la(s) constante(s).
    for i:= 0 to high(consNames) do begin
      //crea constante
      cons := CreateCons(consNames[i], res.Typ);
      cons.srcDec := srcPosArray[i];  //guarda punto de declaración
      if not TreeElems.AddElement(cons) then begin
        GenErrorPos(ER_DUPLIC_IDEN, [cons.name], cons.srcDec);
        cons.Destroy;   //hay una constante creada
        exit;
      end;
      res.CopyConsValTo(cons); //asigna valor
    end;
//  end else if cIn.tok = ':' then begin
  end else begin
    GenError(ER_EQU_COM_EXP);
    exit;
  end;
  if not CaptureDelExpres then exit;
  ProcComments;
  //puede salir con error
end;

end.

