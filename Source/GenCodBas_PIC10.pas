{Unidad que agrega campos necesarios a la clase TCompilerBase, para la generación de
código con el PIC16F.}
unit GenCodBas_PIC10;
{$mode objfpc}{$H+}
interface
uses
  Classes, SysUtils, XpresElementsPIC, XpresTypesPIC, PicCore, Pic10Utils,
  CompBase, ParserDirec, Globales, CompOperands, MisUtils, LCLType, LCLProc;
const
  STACK_SIZE = 2;      //tamaño de pila para subrutinas en el PIC
  MAX_REGS_AUX_BYTE = 5;   //cantidad máxima de registros a usar
  MAX_REGS_AUX_BIT = 4;    //cantidad máxima de registros bit a usar
  MAX_REGS_STACK_BYTE = 6; //cantidad máxima de registros a usar en la pila
  MAX_REGS_STACK_BIT = 4;  //cantidad máxima de registros a usar en la pila

type
  { TGenCodBas }
  TGenCodBas = class(TParserDirecBase)
  private
    linRep : string;   //línea para generar de reporte
    posFlash: Integer;
    procedure ClearDeviceError;
    procedure Cod_JumpIfTrue;
    procedure CompileFOR;
    procedure CompileIF;
    procedure CompileProcBody(fun: TxpEleFun);
    procedure CompileREPEAT;
    procedure CompileWHILE;
    function CurrFlash(): integer;
    function DeviceError: string;
    procedure GenCodPicReqStartCodeGen;
    procedure GenCodPicReqStopCodeGen;
    function GetIdxParArray(out WithBrack: boolean; out par: TOperand): boolean;
    function GetValueToAssign(WithBrack: boolean; arrVar: TxpEleVar; out
      value: TOperand): boolean;
    procedure ProcByteUsed(offs, bnk: byte; regPtr: TPICRamCellPtr);
    procedure ResetFlashAndRAM;
    function ReturnAttribIn(typ: TxpEleType; const Op: TOperand; offs: integer
      ): boolean;
    procedure SetSharedUnused;
    procedure SetSharedUsed;
    procedure word_ClearItems(const OpPtr: pointer);
    procedure word_GetItem(const OpPtr: pointer);
    procedure word_SetItem(const OpPtr: pointer);
  protected
    procedure StartCodeSub(fun: TxpEleFun);
    procedure EndCodeSub;
    procedure FunctCall(fun: TxpEleFunBase; out AddrUndef: boolean);
    procedure FunctParam(fun: TxpEleFunBase);
  protected
    //Registros de trabajo
    W      : TPicRegister;     //Registro Interno.
    Z      : TPicRegisterBit;  //Registro Interno.
    C      : TPicRegisterBit;  //Registro Interno.
    H      : TxpEleVar;     //Registros de trabajo. Se crean siempre.
    E      : TxpEleVar;     //Registros de trabajo. Se crean siempre.
    //U      : TPicRegister;     //Registros de trabajo. Se crean siempre.
    U      : TxpEleVar;
    //Registros auxiliares
    INDF   : TPicRegister;     //Registro Interno.
    FSR    : TPicRegister;     //Registro Interno.
    procedure PutLabel(lbl: string); inline;
    procedure PutTopComm(cmt: string; replace: boolean = true); inline;
    procedure PutComm(cmt: string); inline;
    procedure PutFwdComm(cmt: string); inline;
    function ReportRAMusage: string;
    function ValidateByteRange(n: integer): boolean;
    function ValidateWordRange(n: integer): boolean;
    function ValidateDWordRange(n: Int64): boolean;
  protected
    procedure GenerateROBdetComment;
    procedure GenerateROUdetComment;
  protected  //Rutinas de gestión de memoria de bajo nivel
    procedure AssignRAM(out addr: word; regName: string; shared: boolean);  //Asigna a una dirección física
    procedure AssignRAMbit(out addr: word; out bit: byte; regName: string;
      shared: boolean);  //Asigna a una dirección física
    function CreateRegisterByte(RegType: TPicRegType): TPicRegister;
    function CreateRegisterBit(RegType: TPicRegType): TPicRegisterBit;
  protected  //Variables temporales
    {Estas variables temporales, se crean como forma de acceder a campos de una variable
     como varbyte.bit o varword.low. Se almacenan en "varFields" y se eliminan al final}
    varFields: TxpEleVars;  //Contenedor
    function CreateTmpVar(nam: string; eleTyp: TxpEleType): TxpEleVar;
    {Estas variables se usan para operaciones en el generador de código.
     No se almacenan en "varFields". Así se definió al principio, pero podrían también
     almacenarse, asumiendo que no importe crear variables dinámicas.}
    function NewTmpVarWord(rL, rH: TxpEleVar): TxpEleVar;
    function NewTmpVarDword(adL, adH, adE, adU: word): TxpEleVar;
  protected  //Rutinas de gestión de memoria para registros
    varStkBit : TxpEleVar;   //variable bit. Usada para trabajar con la pila
    varStkByte: TxpEleVar;   //variable byte. Usada para trabajar con la pila
    varStkWord: TxpEleVar;   //variable word. Usada para trabajar con la pila
    varStkDWord: TxpEleVar;  //variable dword. Usada para trabajar con la pila
    function GetAuxRegisterByte: TPicRegister;
    function GetAuxRegisterBit: TPicRegisterBit;
    //Gestión de la pila
    function GetStkRegisterByte: TPicRegister;
    function GetStkRegisterBit: TPicRegisterBit;
    function GetVarBitFromStk: TxpEleVar;
    function GetVarByteFromStk: TxpEleVar;
    function GetVarWordFromStk: TxpEleVar;
    function GetVarDWordFromStk: TxpEleVar;
    function FreeStkRegisterBit: boolean;
    function FreeStkRegisterByte: boolean;
    function FreeStkRegisterWord: boolean;
    function FreeStkRegisterDWord: boolean;
  protected  //Rutinas de gestión de memoria para variables
    {Estas rutinas estarían mejor ubicadas en TCompilerBase, pero como dependen del
    objeto "pic", se colocan mejor aquí.}
    procedure AssignRAMinBit(absAdd, absBit: integer; var addr: word;
      var bit: byte; regName: string; shared: boolean = false);
    procedure AssignRAMinByte(absAdd: integer; var addr: word; regName: string;
      shared: boolean = false);
    procedure CreateVarInRAM(nVar: TxpEleVar; shared: boolean = false);
  protected  //Métodos para fijar el resultado
    //Métodos básicos
    procedure SetResultNull;
    procedure SetResultConst(typ: TxpEleType);
    procedure SetResultVariab(rVar: TxpEleVar; Inverted: boolean = false);
    procedure SetResultExpres(typ: TxpEleType; ChkRTState: boolean = true);
    procedure SetResultVarRef(rVarBase: TxpEleVar);
    procedure SetResultExpRef(rVarBase: TxpEleVar; typ: TxpEleType; ChkRTState: boolean = true);
    //Fija el resultado de ROB como constante.
    procedure SetROBResultConst_bool(valBool: boolean);
    procedure SetROBResultConst_bit (valBit: boolean);
    procedure SetROBResultConst_byte(valByte: integer);
    procedure SetROBResultConst_char(valByte: integer);
    procedure SetROBResultConst_word(valWord: integer);
    procedure SetROBResultConst_dword(valWord: Int64);
    //Fija el resultado de ROB como variable
    procedure SetROBResultVariab(rVar: TxpEleVar; Inverted: boolean = false);
    //Fija el resultado de ROB como expresión
    {El parámetro "Opt", es más que nada para asegurar que solo se use con Operaciones
     binarias.}
    procedure SetROBResultExpres_bit(Opt: TxpOperation; Inverted: boolean);
    procedure SetROBResultExpres_bool(Opt: TxpOperation; Inverted: boolean);
    procedure SetROBResultExpres_byte(Opt: TxpOperation);
    procedure SetROBResultExpres_char(Opt: TxpOperation);
    procedure SetROBResultExpres_word(Opt: TxpOperation);
    procedure SetROBResultExpres_dword(Opt: TxpOperation);
    //Fija el resultado de ROU
    procedure SetROUResultConst_bit(valBit: boolean);
    procedure SetROUResultConst_byte(valByte: integer);
    procedure SetROUResultVariab(rVar: TxpEleVar; Inverted: boolean = false);
    procedure SetROUResultVarRef(rVarBase: TxpEleVar);
    procedure SetROUResultExpres_bit(Inverted: boolean);
    procedure SetROUResultExpres_byte;
    procedure SetROUResultExpRef(rVarBase: TxpEleVar; typ: TxpEleType);
    //Adicionales
    procedure ChangeResultBitToBool;
    procedure ChangeResultCharToByte;
    function ChangePointerToExpres(var ope: TOperand): boolean;
  protected  //Instrucciones que no manejan el cambio de banco
    procedure CodAsmFD(const inst: TPIC10Inst; const f: byte; d: TPIC10Destin);
    procedure CodAsmK(const inst: TPIC10Inst; const k: byte);
      procedure _BANKSEL(targetBank: byte);
    procedure GenCodBank(targetAdrr: word);
    procedure _BANKRESET;
    function _PC: word;
    function _CLOCK: integer;
    procedure _LABEL(igot: integer);
    //Instrucciones simples
    procedure _ADDWF(const f: byte; d: TPIC10Destin);
    procedure _ANDLW(const k: word);
    procedure _ANDWF(const f: byte; d: TPIC10Destin);
    procedure _BCF(const f, b: byte);
    procedure _BSF(const f, b: byte);
    procedure _BTFSC(const f, b: byte);
    procedure _BTFSS(const f, b: byte);
    procedure _CALL(const a: word);
    procedure _CLRF(const f: byte);
    procedure _CLRW;
    procedure _CLRWDT;
    procedure _COMF(const f: byte; d: TPIC10Destin);
    procedure _DECF(const f: byte; d: TPIC10Destin);
    procedure _DECFSZ(const f: byte; d: TPIC10Destin);
    procedure _GOTO(const a: word);
    procedure _GOTO_PEND(out igot: integer);
    procedure _INCF(const f: byte; d: TPIC10Destin);
    procedure _INCFSZ(const f: byte; d: TPIC10Destin);
    procedure _IORLW(const k: word);
    procedure _IORWF(const f: byte; d: TPIC10Destin);
    procedure _MOVF(const f: byte; d: TPIC10Destin);
    procedure _MOVLW(const k: word);
    procedure _MOVWF(const f: byte);
    procedure _NOP;
    procedure _RETFIE;
    procedure _RETLW(const k: word);
    procedure _RETURN;
    procedure _RLF(const f: byte; d: TPIC10Destin);
    procedure _RRF(const f: byte; d: TPIC10Destin);

    procedure _SLEEP;
    procedure _SUBWF(const f: byte; d: TPIC10Destin);
    procedure _SWAPF(const f: byte; d: TPIC10Destin);
    procedure _XORLW(const k: word);
    procedure _XORWF(const f: byte; d: TPIC10Destin);
    procedure _TRIS(const f: byte);
    //macros
    procedure _IFZERO;
    procedure _IFNZERO;
  protected  //Instrucciones que manejan el cambio de banco
    procedure kADDWF(addr: word; d: TPIC10Destin);
    procedure kANDLW(const k: word);
    procedure kANDWF(addr: word; d: TPIC10Destin);
    procedure kBCF(const f: TPicRegisterBit);
    procedure kBSF(const f: TPicRegisterBit);
    procedure kBTFSC(const f: TPicRegisterBit);
    procedure kBTFSS(const f: TPicRegisterBit);
    procedure kCALL(const a: word);
    procedure kCLRF(addr: word);
    procedure kCLRW;
    procedure kCLRWDT;
    procedure kCOMF(addr: word; d: TPIC10Destin);
    procedure kDECF(addr: word; d: TPIC10Destin);
    procedure kDECFSZ(const f: word; d: TPIC10Destin);
    procedure kGOTO(const a: word);
    procedure kGOTO_PEND(out igot: integer);
    procedure kINCF(addr: word; d: TPIC10Destin);
    procedure kINCFSZ(const f: word; d: TPIC10Destin);
    procedure kIORLW(const k: word);
    procedure kIORWF(addr: word; d: TPIC10Destin);
    procedure kMOVF(addr: word; d: TPIC10Destin);
    procedure kMOVLW(const k: word);
    procedure kMOVWF(addr: word);
    procedure kNOP;
    procedure kRETFIE;
    procedure kRETLW(const k: word);
    procedure kRETURN;
    procedure kRLF(addr: word; d: TPIC10Destin);
    procedure kRRF(addr: word; d: TPIC10Destin);
    procedure kSLEEP;
    procedure kSUBLW_x(const k: word);
    procedure kSUBWF(addr: word; d: TPIC10Destin);
    procedure kSWAPF(addr: word; d: TPIC10Destin);
    procedure kXORLW(const k: word);
    procedure kXORWF(addr: word; d: TPIC10Destin);
    //Instrucciones adicionales
    procedure kSHIFTR(addr: word; d: TPIC10destin);
    procedure kSHIFTL(addr: word; d: TPIC10destin);
    procedure kIF_BSET(const f: TPicRegisterBit; out igot: integer);
    procedure kIF_BSET_END(igot: integer);
    procedure kIF_BCLR(const f: TPicRegisterBit; out igot: integer);
    procedure kIF_BCLR_END(igot: integer);
    procedure kIF_ZERO(out igot: integer);
    procedure kIF_ZERO_END(igot: integer);
    procedure kIF_NZERO(out igot: integer);
    procedure kIF_NZERO_END(igot: integer);
  public  //Acceso a registro de trabajo
//    property H_register: TPicRegister read H;
//    property E_register: TPicRegister read E;
//    property U_register: TPicRegister read U;
  protected  //Funciones de tipos
    ///////////////// Tipo Bit ////////////////
    procedure bit_LoadToRT(const OpPtr: pointer; modReturn: boolean);
    procedure bit_DefineRegisters;
    procedure bit_SaveToStk;
    //////////////// Tipo Byte /////////////
    procedure byte_LoadToRT(const OpPtr: pointer; modReturn: boolean);
    procedure byte_DefineRegisters;
    procedure byte_SaveToStk;
    procedure byte_GetItem(const OpPtr: pointer);
    procedure byte_SetItem(const OpPtr: pointer);
    procedure byte_ClearItems(const OpPtr: pointer);
    procedure byte_bit(const OpPtr: pointer; nbit: byte);
    procedure byte_bit0(const OpPtr: pointer);
    procedure byte_bit1(const OpPtr: pointer);
    procedure byte_bit2(const OpPtr: pointer);
    procedure byte_bit3(const OpPtr: pointer);
    procedure byte_bit4(const OpPtr: pointer);
    procedure byte_bit5(const OpPtr: pointer);
    procedure byte_bit6(const OpPtr: pointer);
    procedure byte_bit7(const OpPtr: pointer);
    //////////////// Tipo Word /////////////
    procedure word_LoadToRT(const OpPtr: pointer; modReturn: boolean);
    procedure word_DefineRegisters;
    procedure word_SaveToStk;
    procedure word_Low(const OpPtr: pointer);
    procedure word_High(const OpPtr: pointer);
    //////////////// Tipo DWord /////////////
    procedure dword_LoadToRT(const OpPtr: pointer; modReturn: boolean);
    procedure dword_DefineRegisters;
    procedure dword_SaveToStk;
    procedure dword_Extra(const OpPtr: pointer);
    procedure dword_High(const OpPtr: pointer);
    procedure dword_HighWord(const OpPtr: pointer);
    procedure dword_Low(const OpPtr: pointer);
    procedure dword_LowWord(const OpPtr: pointer);
    procedure dword_Ultra(const OpPtr: pointer);
  public     //Acceso a campos del PIC
    function PICName: string; override;
    function PICNameShort: string; override;
    function PICnBanks: byte; override; //Number of RAM banks
    function PICCurBank: byte; override; //Current RAM bank
    function PICBank(i: byte): TPICRAMBank; override; //Return a RAM bank
    function PICnPages: byte; override; //Number of FLASH pages
    function PICPage(i: byte): TPICFlashPage; override; //Return a FLASH page
    function RAMmax: integer; override;
  public  //Inicialización
    pic        : TPIC10;       //Objeto PIC de la serie 16.
    procedure StartRegs;
    function CompilerName: string; override;
    constructor Create; override;
    destructor Destroy; override;
  end;

  procedure SetLanguage;
implementation
var
  TXT_SAVE_W, TXT_SAVE_Z, TXT_SAVE_H, MSG_NO_ENOU_RAM, MSG_VER_CMP_EXP,
  MSG_STACK_OVERF, MSG_NOT_IMPLEM, ER_VARIAB_EXPEC, ER_ONL_BYT_WORD,
  ER_ASIG_EXPECT
  : string;

procedure SetLanguage;
begin
  ParserDirec.SetLanguage;
  {$I ..\language\tra_GenCodBas.pas}
end;
{ TGenCodPic }
procedure TGenCodBas.ProcByteUsed(offs, bnk: byte;
  regPtr: TPICRamCellPtr);
begin
  linRep := linRep + regPtr^.name +
            ' DB ' + 'bnk'+ IntToStr(bnk) + ':$' + IntToHex(offs, 3) + LineEnding;
end;
procedure TGenCodBas.PutLabel(lbl: string);
{Agrega uan etiqueta antes de la instrucción. Se recomienda incluir solo el nombre de
la etiqueta, sin ":", ni comentarios, porque este campo se usará para desensamblar.}
begin
  pic.addTopLabel(lbl);  //agrega línea al código ensmblador
end;
procedure TGenCodBas.PutTopComm(cmt: string; replace: boolean = true);
//Agrega comentario al inicio de la posición de memoria
begin
  pic.addTopComm(cmt, replace);  //agrega línea al código ensmblador
end;
procedure TGenCodBas.PutComm(cmt: string);
//Agrega comentario lateral al código. Se llama después de poner la instrucción.
begin
  pic.addSideComm(cmt, true);  //agrega línea al código ensmblador
end;
procedure TGenCodBas.PutFwdComm(cmt: string);
//Agrega comentario lateral al código. Se llama antes de poner la instrucción.
begin
  pic.addSideComm(cmt, false);  //agrega línea al código ensmblador
end;
function TGenCodBas.ReportRAMusage: string;
{Genera un reporte de uso de la memoria RAM}
begin
  linRep := '';
  pic.ExploreUsed(@ProcByteUsed);
  Result := linRep;
end;
function TGenCodBas.ValidateByteRange(n: integer): boolean;
//Verifica que un valor entero, se pueda convertir a byte. Si no, devuelve FALSE.
begin
  if (n>=0) and (n<256) then
     exit(true)
  else begin
    GenError('Numeric value exceeds a byte range.');
    exit(false);
  end;
end;
function TGenCodBas.ValidateWordRange(n: integer): boolean;
//Verifica que un valor entero, se pueda convertir a byte. Si no, devuelve FALSE.
begin
  if (n>=0) and (n<65536) then
     exit(true)
  else begin
    GenError('Numeric value exceeds a word range.');
    exit(false);
  end;
end;
function TGenCodBas.ValidateDWordRange(n: Int64): boolean;
begin
  if (n>=0) and (n<$100000000) then
     exit(true)
  else begin
    GenError('Numeric value exceeds a dword range.');
    exit(false);
  end;
end;
procedure TGenCodBas.GenerateROBdetComment;
{Genera un comentario detallado en el código ASM. Válido solo para
Rutinas de Operación binaria, que es cuando está definido operType, p1, y p2.}
begin
  if incDetComm then begin
    PutTopComm('      ;Oper(' + p1^.StoOpChr + ':' + p1^.Typ.name + ',' +
                                p2^.StoOpChr + ':' + p2^.Typ.name + ')', false);
  end;
end;
procedure TGenCodBas.GenerateROUdetComment;
{Genera un comentario detallado en el código ASM. Válido solo para
Rutinas de Operación unaria, que es cuando está definido operType, y p1.}
begin
  if incDetComm then begin
    PutTopComm('      ;Oper(' + p1^.StoOpChr + ':' + p1^.Typ.name + ')', false);
  end;
end;
//Rutinas de gestión de memoria de bajo nivel
procedure TGenCodBas.AssignRAM(out addr: word; regName: string; shared: boolean);
//Asocia a una dirección física de la memoria del PIC.
//Si encuentra error, devuelve el mensaje de error en "MsjError"
begin
  {Esta dirección física, la mantendrá este registro hasta el final de la compilación
  y en teoría, hasta el final de la ejecución de programa en el PIC.}
  if not pic.GetFreeByte(addr, shared) then begin
    GenError(MSG_NO_ENOU_RAM);
    exit;
  end;
  pic.SetNameRAM(addr, regName);  //pone nombre a registro
end;
procedure TGenCodBas.AssignRAMbit(out addr: word; out bit: byte; regName: string; shared: boolean);
begin
  if not pic.GetFreeBit(addr, bit, shared) then begin
    GenError(MSG_NO_ENOU_RAM);
    exit;
  end;
  pic.SetNameRAMbit(addr, bit, regName);  //pone nombre a bit
end;
function TGenCodBas.CreateRegisterByte(RegType: TPicRegType): TPicRegister;
{Crea una nueva entrada para registro en listRegAux[], pero no le asigna memoria.
 Si encuentra error, devuelve NIL. Este debería ser el único punto de entrada
para agregar un nuevo registro a listRegAux.}
var
  reg: TPicRegister;
begin
  //Agrega un nuevo objeto TPicRegister a la lista;
  reg := TPicRegister.Create;  //Crea objeto
  reg.typ := RegType;    //asigna tipo
  listRegAux.Add(reg);   //agrega a lista
  if listRegAux.Count > MAX_REGS_AUX_BYTE then begin
    //Se asume que se desbordó la memoria evaluando a alguna expresión
    GenError(MSG_VER_CMP_EXP);
    exit(nil);
  end;
  Result := reg;   //devuelve referencia
end;
function TGenCodBas.CreateRegisterBit(RegType: TPicRegType): TPicRegisterBit;
{Crea una nueva entrada para registro en listRegAux[], pero no le asigna memoria.
 Si encuentra error, devuelve NIL. Este debería ser el único punto de entrada
para agregar un nuevo registro a listRegAux.}
var
  reg: TPicRegisterBit;
begin
  //Agrega un nuevo objeto TPicRegister a la lista;
  reg := TPicRegisterBit.Create;  //Crea objeto
  reg.typ := RegType;    //asigna tipo
  listRegAuxBit.Add(reg);   //agrega a lista
  if listRegAuxBit.Count > MAX_REGS_AUX_BIT then begin
    //Se asume que se desbordó la memoria evaluando a alguna expresión
    GenError(MSG_VER_CMP_EXP);
    exit(nil);
  end;
  Result := reg;   //devuelve referencia
end;
function TGenCodBas.CreateTmpVar(nam: string; eleTyp: TxpEleType): TxpEleVar;
{Crea una variable temporal agregándola al contenedor varFields, que es
limpiado al iniciar la compilación. Notar que la variable temporal creada, no tiene
RAM asiganda.}
var
  tmpVar: TxpEleVar;
begin
  tmpVar:= TxpEleVar.Create;
  tmpVar.name := nam;
  tmpVar.typ := eleTyp;
  tmpVar.adicPar.hasAdic := decNone;
  tmpVar.adicPar.hasInit := false;
  tmpVar.IsTmp := true;   //Para que se pueda luego identificar.
  varFields.Add(tmpVar);  //Agrega
  Result := tmpVar;
end;
function TGenCodBas.NewTmpVarWord(rL, rH: TxpEleVar): TxpEleVar;
{Crea una variable temporal Word, con las direcciones de las varaibles indicados, y
devuelve la referencia. La variable se crea sin asignación de memoria.}
begin
  Result := TxpEleVar.Create;
  Result.typ := typWord;
  Result.addr0 := rL.addr;  //asigna direcciones
  Result.addr1 := rH.addr;
end;
//Variables temporales
function TGenCodBas.NewTmpVarDword(adL, adH, adE, adU: word): TxpEleVar;
{Crea una variable temporal DWord, con las direcciones de los registros indicados, y
devuelve la referencia. La variable se crea sin asignación de memoria.}
begin
  Result := TxpEleVar.Create;
  Result.typ := typDWord;
  Result.addr0 := adL;  //asigna direcciones
  Result.addr1 := adH;
  Result.addr2 := adE;
  Result.addr3 := adU;
end;
//Rutinas de Gestión de memoria
function TGenCodBas.GetAuxRegisterByte: TPicRegister;
{Devuelve la dirección de un registro de trabajo libre. Si no encuentra alguno, lo crea.
 Si hay algún error, llama a GenError() y devuelve NIL}
var
  reg: TPicRegister;
  regName: String;
begin
  //Busca en los registros creados
  {Notar que no se incluye en la búsqueda a los registros de trabajo. Esto es por un
  tema de orden, si bien podría ser factible, permitir usar algún registro de trabajo no
  usado, como registro auxiliar.}
  for reg in listRegAux do begin
    //Se supone que todos los registros auxiliares, estarán siempre asignados
    if (reg.typ = prtAuxReg) and not reg.used then begin
      reg.used := true;
      exit(reg);
    end;
  end;
  //No encontró ninguno libre, crea uno en memoria
  reg := CreateRegisterByte(prtAuxReg);
  if reg = nil then exit(nil);  //hubo errir
  regName := 'aux'+IntToSTr(listRegAux.Count);
  AssignRAM(reg.addr, regName, false);   //Asigna memoria. Puede generar error.
  if HayError then exit;
  reg.assigned := true;  //Tiene memoria asiganda
  reg.used := true;  //marca como usado
  Result := reg;   //Devuelve la referencia
end;
function TGenCodBas.GetAuxRegisterBit: TPicRegisterBit;
{Devuelve la dirección de un registro de trabajo libre. Si no encuentra alguno, lo crea.
 Si hay algún error, llama a GenError() y devuelve NIL}
var
  reg: TPicRegisterBit;
  regName: String;
begin
  //Busca en los registros creados
  {Notar que no se incluye en la búsqueda a los registros de trabajo. Esto es por un
  tema de orden, si bien podría ser factible, permitir usar algún registro de trabajo no
  usado, como registro auxiliar.}
  for reg in listRegAuxBit do begin
    //Se supone que todos los registros auxiliares, estarán siempre asignados
    if (reg.typ = prtAuxReg) and not reg.used then
      exit(reg);
  end;
  //No encontró ninguno libre, crea uno en memoria
  reg := CreateRegisterBit(prtAuxReg);
  if reg = nil then exit(nil);  //hubo errir
  regName := 'aux'+IntToSTr(listRegAuxBit.Count);
  AssignRAMbit(reg.addr, reg.bit, regName, false);   //Asigna memoria. Puede generar error.
  if HayError then exit;
  reg.assigned := true;  //Tiene memoria asiganda
  reg.used := true;  //marca como usado
  Result := reg;   //Devuelve la referencia
end;
function TGenCodBas.GetStkRegisterByte: TPicRegister;
{Pone un registro de un byte, en la pila, de modo que se pueda luego acceder con
FreeStkRegisterByte(). Si hay un error, devuelve NIL.
Notar que esta no es una pila de memoria en el PIC, sino una emulación de pila
en el compilador.}
var
  reg0: TPicRegister;
  regName: String;
begin
  //Validación
  if stackTop>MAX_REGS_STACK_BYTE then begin
    //Se asume que se desbordó la memoria evaluando a alguna expresión
    GenError(MSG_VER_CMP_EXP);
    exit(nil);
  end;
  if stackTop>listRegStk.Count-1 then begin
    //Apunta a una posición vacía. hay qie agregar
    //Agrega un nuevo objeto TPicRegister a la lista;
    reg0 := TPicRegister.Create;  //Crea objeto
    reg0.typ := prtStkReg;   //asigna tipo
    listRegStk.Add(reg0);    //agrega a lista
    regName := 'stk'+IntToSTr(listRegStk.Count);
    AssignRAM(reg0.addr, regName, false);   //Asigna memoria. Puede generar error.
    if HayError then exit(nil);
  end;
  Result := listRegStk[stackTop];  //toma registro
  Result.assigned := true;
  Result.used := true;   //lo marca
  inc(stackTop);  //actualiza
end;
function TGenCodBas.GetStkRegisterBit: TPicRegisterBit;
{Pone un registro de un bit, en la pila, de modo que se pueda luego acceder con
FreeStkRegisterBit(). Si hay un error, devuelve NIL.
Notar que esta no es una pila de memoria en el PIC, sino una emulación de pila
en el compilador.}
var
  reg0: TPicRegisterBit;
  regName: String;
begin
  //Validación
  if stackTopBit>MAX_REGS_STACK_BIT then begin
    //Se asume que se desbordó la memoria evaluando a alguna expresión
    GenError(MSG_VER_CMP_EXP);
    exit(nil);
  end;
  if stackTopBit>listRegStkBit.Count-1 then begin
    //Apunta a una posición vacía. hay qie agregar
    //Agrega un nuevo objeto TPicRegister a la lista;
    reg0 := TPicRegisterBit.Create;  //Crea objeto
    reg0.typ := prtStkReg;    //asigna tipo
    listRegStkBit.Add(reg0);  //agrega a lista
    regName := 'stk'+IntToSTr(listRegStkBit.Count);
    AssignRAMbit(reg0.addr, reg0.bit, regName, false);   //Asigna memoria. Puede generar error.
    if HayError then exit(nil);
  end;
  Result := listRegStkBit[stackTopBit];  //toma registro
  Result.assigned := true;
  Result.used := true;   //lo marca
  inc(stackTopBit);  //actualiza
end;
function TGenCodBas.GetVarBitFromStk: TxpEleVar;
{Devuelve la referencia a una variable bit, que representa al último bit agregado en
la pila. Se usa como un medio de trabajar con los datos de la pila.}
var
  topreg: TPicRegisterBit;
begin
  topreg := listRegStkBit[stackTopBit-1];  //toma referecnia de registro de la pila
  //Usamos la variable "varStkBit" que existe siempre, para devolver la referencia.
  //Primero la hacemos apuntar a la dirección física de la pila
  varStkBit.addr0 := topreg.addr;
  varStkBit.bit0 := topreg.bit;
  //Ahora que tenemos ya la variable configurada, devolvemos la referecnia
  Result := varStkBit;
end;
function TGenCodBas.GetVarByteFromStk: TxpEleVar;
{Devuelve la referencia a una variable byte, que representa al último byte agregado en
la pila. Se usa como un medio de trabajar con los datos de la pila.}
var
  topreg: TPicRegister;
begin
  topreg := listRegStk[stackTop-1];  //toma referencia de registro de la pila
  //Usamos la variable "varStkByte" que existe siempre, para devolver la referencia.
  //Primero la hacemos apuntar a la dirección física de la pila
  varStkByte.addr0 := topReg.addr;
  //Ahora que tenemos ya la variable configurada, devolvemos la referecnia
  Result := varStkByte;
end;
function TGenCodBas.GetVarWordFromStk: TxpEleVar;
{Devuelve la referencia a una variable word, que representa al último word agregado en
la pila. Se usa como un medio de trabajar con los datos de la pila.}
var
  topreg: TPicRegister;
begin
  //Usamos la variable "varStkWord" que existe siempre, para devolver la referencia.
  //Primero la hacemos apuntar a la dirección física de la pila
  topreg := listRegStk[stackTop-1];  //toma referencia de registro de la pila
  varStkWord.addr1 := topreg.addr;
  topreg := listRegStk[stackTop-2];  //toma referencia de registro de la pila
  varStkWord.addr0 := topreg.addr;
  //Ahora que tenemos ya la variable configurada, devolvemos la referencia
  Result := varStkWord;
end;
function TGenCodBas.GetVarDWordFromStk: TxpEleVar;
{Devuelve la referencia a una variable Dword, que representa al último Dword agregado en
la pila. Se usa como un medio de trabajar con los datos de la pila.}
var
  topreg: TPicRegister;
begin
  //Usamos la variable "varStkDWord" que existe siempre, para devolver la referencia.
  //Primero la hacemos apuntar a la dirección física de la pila
  topreg := listRegStk[stackTop-1];  //toma referencia de registro de la pila
  varStkDWord.addr3 := topreg.addr;
  topreg := listRegStk[stackTop-2];  //toma referencia de registro de la pila
  varStkDWord.addr2 := topreg.addr;
  topreg := listRegStk[stackTop-3];  //toma referencia de registro de la pila
  varStkDWord.addr1 := topreg.addr;
  topreg := listRegStk[stackTop-4];  //toma referencia de registro de la pila
  varStkDWord.addr0 := topreg.addr;
  //Ahora que tenemos ya la variable configurada, devolvemos la referencia
  Result := varStkDWord;
end;
function TGenCodBas.FreeStkRegisterBit: boolean;
{Libera el último bit, que se pidió a la RAM. Si hubo error, devuelve FALSE.
 Liberarlos significa que estarán disponibles, para la siguiente vez que se pidan}
begin
   if stackTopBit=0 then begin  //Ya está abajo
     GenError(MSG_STACK_OVERF);
     exit(false);
   end;
   dec(stackTopBit);   //Baja puntero
   exit(true);
end;
function TGenCodBas.FreeStkRegisterByte: boolean;
{Libera el último byte, que se pidió a la RAM. Devuelve en "reg", la dirección del último
 byte pedido. Si hubo error, devuelve FALSE.
 Liberarlos significa que estarán disponibles, para la siguiente vez que se pidan}
begin
   if stackTop=0 then begin  //Ya está abajo
     GenError(MSG_STACK_OVERF);
     exit(false);
   end;
   dec(stackTop);   //Baja puntero
   exit(true);
end;
function TGenCodBas.FreeStkRegisterWord: boolean;
{Libera el último word, que se pidió a la RAM. Si hubo error, devuelve FALSE.}
begin
   if stackTop<=1 then begin  //Ya está abajo
     GenError(MSG_STACK_OVERF);
     exit(false);
   end;
   dec(stackTop, 2);   //Baja puntero
   exit(true);
end;
function TGenCodBas.FreeStkRegisterDWord: boolean;
{Libera el último dword, que se pidió a la RAM. Si hubo error, devuelve FALSE.}
begin
   if stackTop<=3 then begin  //Ya está abajo
     GenError(MSG_STACK_OVERF);
     exit(false);
   end;
   dec(stackTop, 4);   //Baja puntero
   exit(true);
end;
////Rutinas de gestión de memoria para variables
procedure TGenCodBas.AssignRAMinBit(absAdd, absBit: integer;
  var addr: word; var bit: byte; regName: string; shared: boolean = false);
{Aeigna RAM a un registro o lo coloca en la dirección indicada.}
begin
  //Obtiene los valores de: offs, bnk, y bit, para el alamacenamiento.
  if absAdd=-1 then begin
    //Caso normal, sin dirección absoluta.
    AssignRAMbit(addr, bit, regName, shared);
    //Puede salir con error
  end else begin
    //Se debe crear en una posición absoluta
    addr := absAdd;
    bit := absBit;  //para los bits no hay transformación
    //Pone nombre a la celda en RAM, para que pueda desensamblarse con detalle
    pic.SetNameRAMbit(addr, bit, regName);
  end;
end;
procedure TGenCodBas.AssignRAMinByte(absAdd: integer;
  var addr: word; regName: string; shared: boolean = false);
{Asigna RAM a un registro o lo coloca en la dirección indicada.}
begin
  //Obtiene los valores de: offs, bnk, y bit, para el alamacenamiento.
  if absAdd=-1 then begin
    //Caso normal, sin dirección absoluta.
    AssignRAM(addr, regName, shared);
    //Puede salir con error
  end else begin
    //Se debe crear en una posición absoluta
    addr := absAdd;
    //Pone nombre a la celda en RAM, para que pueda desensamblarse con detalle
    pic.SetNameRAM(addr, regName);
    if pic.MsjError<>'' then begin
      GenError(pic.MsjError);
      pic.MsjError := '';  //Para evitar generar otra vez el mensaje
      exit;
    end;
  end;
end;
procedure TGenCodBas.CreateVarInRAM(nVar: TxpEleVar; shared: boolean = false);
{Rutina para asignar espacio físico a una variable. La variable, es creada en memoria
con los parámetros que posea en ese momento. Si está definida como ABSOLUTE, se le
creará en la posicón indicada. }
var
  varName: String;
  absAdd: integer;
  absBit, nbytes: integer;
  typ: TxpEleType;
  //offs, bnk: byte;
  addr: word;
begin
  //Valores solicitados. Ya deben estar iniciado este campo.
  varName := nVar.name;
  typ := nVar.typ;
  if nVar.adicPar.hasAdic = decAbsol then begin
    absAdd := nVar.adicPar.absAddr;
    if typ.IsBitSize then begin
      absBit := nVar.adicPar.absBit;
    end else begin
      absBit := -1;
    end;
  end else begin
    absAdd  := -1;  //no aplica
    absBit  := -1;  //no aplica
  end;
  //Asigna espacio, de acuerdo al tipo
  if typ = typBit then begin
    AssignRAMinBit(absAdd, absBit, nVar.addr0, nVar.bit0, varName, shared);
  end else if typ = typBool then begin
    AssignRAMinBit(absAdd, absBit, nVar.addr0, nVar.bit0, varName, shared);
  end else if typ = typByte then begin
    AssignRAMinByte(absAdd, nVar.addr0, varName, shared);
  end else if typ = typChar then begin
    AssignRAMinByte(absAdd, nVar.addr0, varName, shared);
  end else if typ = typWord then begin
    //Registra variable en la tabla
    if absAdd = -1 then begin  //Variable normal
      //Los 2 bytes, no necesariamente serán consecutivos (se toma los que estén libres)}
      AssignRAMinByte(-1, nVar.addr0, varName+'@0', shared);
      AssignRAMinByte(-1, nVar.addr1, varName+'@1', shared);
    end else begin             //Variable absoluta
      //Las variables absolutas se almacenarán siempre consecutivas
      AssignRAMinByte(absAdd  , nVar.addr0, varName+'@0');
      AssignRAMinByte(absAdd+1, nVar.addr1, varName+'@1');
    end;
  end else if typ = typDWord then begin
    //Registra variable en la tabla
    if absAdd = -1 then begin  //Variable normal
      //Los 4 bytes, no necesariamente serán consecutivos (se toma los que estén libres)}
      AssignRAMinByte(-1, nVar.addr0, varName+'@0', shared);
      AssignRAMinByte(-1, nVar.addr1, varName+'@1', shared);
      AssignRAMinByte(-1, nVar.addr2, varName+'@2', shared);
      AssignRAMinByte(-1, nVar.addr3, varName+'@3', shared);
    end else begin             //Variable absoluta
      //Las variables absolutas se almacenarán siempre consecutivas
      AssignRAMinByte(absAdd  , nVar.addr0, varName+'@0');
      AssignRAMinByte(absAdd+1, nVar.addr1, varName+'@1');
      AssignRAMinByte(absAdd+2, nVar.addr2, varName+'@2');
      AssignRAMinByte(absAdd+3, nVar.addr3, varName+'@3');
    end;
  end else if typ.catType = tctArray then begin
    //Es un arreglo de algún tipo
    if absAdd<>-1 then begin
      //Se pide mapearlo de forma absoluta
      GenError(MSG_NOT_IMPLEM, [varName]);
      exit;
    end;
    //Asignamos espacio en RAM
    nbytes := typ.nItems * typ.itmType.size;
    if not pic.GetFreeBytes(nbytes, addr) then begin
      GenError(MSG_NO_ENOU_RAM);
      exit;
    end;
    pic.SetNameRAM(addr, nVar.name);   //Nombre solo al primer byte
    //Fija dirección física. Se usa solamente "addr0", como referencia, porque
    //no se tienen suficientes registros para modelar todo el arreglo.
    nVar.addr0 := addr;
  end else if typ.catType = tctPointer then begin
    //Es un puntero a algún tipo.
    //Los punteros cortos, se manejan como bytes
    AssignRAMinByte(absAdd, nVar.addr0, varName, shared);
  end else begin
    GenError(MSG_NOT_IMPLEM, [varName]);
  end;
  if HayError then  exit;
  if typ.OnGlobalDef<>nil then typ.OnGlobalDef(varName, '');
end;
//Métodos para fijar el resultado
procedure TGenCodBas.SetResultNull;
{Fija el resultado como NULL.}
begin
  res.SetAsNull;
  InvertedFromC:=false;   //para limpiar el estado
  res.Inverted := false;
end;
procedure TGenCodBas.SetResultConst(typ: TxpEleType);
{Fija los parámetros del resultado de una subexpresion. Este método se debe ejcutar,
siempre antes de evaluar cada subexpresión.}
begin
  res.SetAsConst(typ);
  InvertedFromC:=false;   //para limpiar el estado
  {Se asume que no se necesita invertir la lógica, en una constante (booleana o bit), ya
  que en este caso, tenemos control pleno de su valor}
  res.Inverted := false;
end;
procedure TGenCodBas.SetResultVariab(rVar: TxpEleVar; Inverted: boolean = false);
{Fija los parámetros del resultado de una subexpresion. Este método se debe ejcutar,
siempre antes de evaluar cada subexpresión.}
begin
  res.SetAsVariab(rVar);
  InvertedFromC:=false;   //para limpiar el estado
  //"Inverted" solo tiene sentido, para los tipos bit y boolean
  res.Inverted := Inverted;
end;
procedure TGenCodBas.SetResultExpres(typ: TxpEleType; ChkRTState: boolean = true);
{Fija los parámetros del resultado de una subexpresion (en "res"). Este método se debe
ejecutar, siempre antes de evaluar cada subexpresión. Más exactamente, antes de generar
código para ña subexpresión, porque esta rutina puede generar su propio código.}
begin
  if ChkRTState then begin
    //Se pide verificar si se están suando los RT, para salvarlos en la pila.
    if RTstate<>nil then begin
      //Si se usan RT en la operación anterior. Hay que salvar en pila
      RTstate.SaveToStk;  //Se guardan por tipo
    end else begin
      //No se usan. Están libres
    end;
  end;
  //Fija como expresión
  res.SetAsExpres(typ);
  //Limpia el estado. Esto es útil que se haga antes de generar el código para una operación
  InvertedFromC:=false;
  //Actualiza el estado de los registros de trabajo.
  RTstate := typ;
end;
procedure TGenCodBas.SetResultVarRef(rVarBase: TxpEleVar);
begin
  res.SetAsVarRef(rVarBase);
  InvertedFromC:=false;   //para limpiar el estado
  //No se usa "Inverted" en este almacenamiento
  res.Inverted := false;
end;
procedure TGenCodBas.SetResultExpRef(rVarBase: TxpEleVar; typ: TxpEleType; ChkRTState: boolean = true);
begin
  if ChkRTState then begin
    //Se pide verificar si se están suando los RT, para salvarlos en la pila.
    if RTstate<>nil then begin
      //Si se usan RT en la operación anterior. Hay que salvar en pila
      RTstate.SaveToStk;  //Se guardan por tipo
    end else begin
      //No se usan. Están libres
    end;
  end;
  res.SetAsExpRef(rVarBase, typ);
  InvertedFromC:=false;   //para limpiar el estado
  //No se usa "Inverted" en este almacenamiento
  res.Inverted := false;
end;
//Fija el resultado de ROP como constante
procedure TGenCodBas.SetROBResultConst_bool(valBool: boolean);
begin
  GenerateROBdetComment;
  SetResultConst(typBool);
  res.valBool := valBool;
end;
procedure TGenCodBas.SetROBResultConst_bit(valBit: boolean);
begin
  GenerateROBdetComment;
  SetResultConst(typBit);
  res.valBool := valBit;
end;
procedure TGenCodBas.SetROBResultConst_byte(valByte: integer);
begin
  GenerateROBdetComment;
  if not ValidateByteRange(valByte) then
    exit;  //Error de rango
  SetResultConst(typByte);
  res.valInt := valByte;
end;
procedure TGenCodBas.SetROBResultConst_char(valByte: integer);
begin
  GenerateROBdetComment;
  SetResultConst(typChar);
  res.valInt := valByte;
end;
procedure TGenCodBas.SetROBResultConst_word(valWord: integer);
begin
  GenerateROBdetComment;
  if not ValidateWordRange(valWord) then
    exit;  //Error de rango
  SetResultConst(typWord);
  res.valInt := valWord;
end;
procedure TGenCodBas.SetROBResultConst_dword(valWord: Int64);
begin
  GenerateROBdetComment;
  if not ValidateDWordRange(valWord) then
    exit;  //Error de rango
  SetResultConst(typDWord);
  res.valInt := valWord;
end;
//Fija el resultado de ROP como variable
procedure TGenCodBas.SetROBResultVariab(rVar: TxpEleVar; Inverted: boolean);
begin
  GenerateROBdetComment;
  SetResultVariab(rVar, Inverted);
end;
//Fija el resultado de ROP como expresión
procedure TGenCodBas.SetROBResultExpres_bit(Opt: TxpOperation; Inverted: boolean);
{Define el resultado como una expresión de tipo Bit, y se asegura de reservar el registro
Z, para devolver la salida. Debe llamarse cuando se tienen los operandos de
la oepración en p1^ y p2^, porque toma infiormación de allí.}
begin
  GenerateROBdetComment;
  //Se van a usar los RT. Verificar si los RT están ocupadoa
  if (p1^.Sto = stExpres) or (p2^.Sto = stExpres) then begin
    //Alguno de los operandos de la operación actual, está usando algún RT
    SetResultExpres(typBit, false);  //actualiza "RTstate"
  end else begin
    {Los RT no están siendo usados, por la operación actual.
     Pero pueden estar ocupados por la operación anterior (Ver doc. técnica).}
    SetResultExpres(typBit);  //actualiza "RTstate"
  end;
  //Fija la lógica
  res.Inverted := Inverted;
end;
procedure TGenCodBas.SetROBResultExpres_bool(Opt: TxpOperation; Inverted: boolean);
{Define el resultado como una expresión de tipo Boolean, y se asegura de reservar el
registro Z, para devolver la salida. Debe llamarse cuando se tienen los operandos de
la oepración en p1^y p2^, porque toma infiormación de allí.}
begin
  GenerateROBdetComment;
  //Se van a usar los RT. Verificar si los RT están ocupadoa
  if (p1^.Sto = stExpres) or (p2^.Sto = stExpres) then begin
    //Alguno de los operandos de la operación actual, está usando algún RT
    SetResultExpres(typBool, false);  //actualiza "RTstate"
  end else begin
    {Los RT no están siendo usados, por la operación actual.
     Pero pueden estar ocupados por la operación anterior (Ver doc. técnica).}
    SetResultExpres(typBool);  //actualiza "RTstate"
  end;
  //Fija la lógica
  res.Inverted := Inverted;
end;
procedure TGenCodBas.SetROBResultExpres_byte(Opt: TxpOperation);
{Define el resultado como una expresión de tipo Byte, y se asegura de reservar el
registro W, para devolver la salida. Debe llamarse cuando se tienen los operandos de
la oepración en p1^y p2^, porque toma información de allí.}
begin
  GenerateROBdetComment;
  //Se van a usar los RT. Verificar si los RT están ocupadoa
  if (p1^.Sto = stExpres) or (p2^.Sto = stExpres) then begin
    //Alguno de los operandos de la operación actual, está usando algún RT
    SetResultExpres(typByte, false);  //actualiza "RTstate"
  end else begin
    {Los RT no están siendo usados, por la operación actual.
     Pero pueden estar ocupados por la operación anterior (Ver doc. técnica).}
    SetResultExpres(typByte);  //actualiza "RTstate"
  end;
end;
procedure TGenCodBas.SetROBResultExpres_char(Opt: TxpOperation);
{Define el resultado como una expresión de tipo Char, y se asegura de reservar el
registro W, para devolver la salida. Debe llamarse cuando se tienen los operandos de
la oepración en p1^y p2^, porque toma infiormación de allí.}
begin
  GenerateROBdetComment;
  //Se van a usar los RT. Verificar si los RT están ocupadoa
  if (p1^.Sto = stExpres) or (p2^.Sto = stExpres) then begin
    //Alguno de los operandos de la operación actual, está usando algún RT
    SetResultExpres(typChar, false);  //actualiza "RTstate"
  end else begin
    {Los RT no están siendo usados, por la operación actual.
     Pero pueden estar ocupados por la operación anterior (Ver doc. técnica).}
    SetResultExpres(typChar);  //actualiza "RTstate"
  end;
end;
procedure TGenCodBas.SetROBResultExpres_word(Opt: TxpOperation);
{Define el resultado como una expresión de tipo Word, y se asegura de reservar los
registros H,W, para devolver la salida.}
begin
  GenerateROBdetComment;
  //Se van a usar los RT. Verificar si los RT están ocupadoa
  if (p1^.Sto = stExpres) or (p2^.Sto = stExpres) then begin
    //Alguno de los operandos de la operación actual, está usando algún RT
    SetResultExpres(typWord, false);
  end else begin
    {Los RT no están siendo usados, por la operación actual.
     Pero pueden estar ocupados por la operación anterior (Ver doc. técnica).}
    SetResultExpres(typWord);
  end;
end;
procedure TGenCodBas.SetROBResultExpres_dword(Opt: TxpOperation);
{Define el resultado como una expresión de tipo Word, y se asegura de reservar los
registros H,W, para devolver la salida.}
begin
  GenerateROBdetComment;
  //Se van a usar los RT. Verificar si los RT están ocupadoa
  if (p1^.Sto = stExpres) or (p2^.Sto = stExpres) then begin
    //Alguno de los operandos de la operación actual, está usando algún RT
    typDWord.DefineRegister;   //Se asegura que exista H, E y U
    SetResultExpres(typDWord, false);
  end else begin
    {Los RT no están siendo usados, por la operación actual.
     Pero pueden estar ocupados por la operación anterior (Ver doc. técnica).}
    SetResultExpres(typDWord);
  end;
end;
//Fija el resultado de ROU
procedure TGenCodBas.SetROUResultConst_bit(valBit: boolean);
begin
  GenerateROUdetComment;
  SetResultConst(typBit);
  res.valBool := valBit;
end;
procedure TGenCodBas.SetROUResultConst_byte(valByte: integer);
begin
  GenerateROUdetComment;
  if not ValidateByteRange(valByte) then
    exit;  //Error de rango
  SetResultConst(typByte);
  res.valInt := valByte;
end;
procedure TGenCodBas.SetROUResultVariab(rVar: TxpEleVar; Inverted: boolean);
begin
  GenerateROUdetComment;
  SetResultVariab(rVar, Inverted);
end;
procedure TGenCodBas.SetROUResultVarRef(rVarBase: TxpEleVar);
{Fija el resultado como una referencia de tipo stVarRefVar}
begin
  GenerateROUdetComment;
  SetResultVarRef(rVarBase);
end;
procedure TGenCodBas.SetROUResultExpres_bit(Inverted: boolean);
{Define el resultado como una expresión de tipo Bit, y se asegura de reservar el registro
Z, para devolver la salida. Se debe usar solo para operaciones unarias.}
begin
  GenerateROUdetComment;
  //Se van a usar los RT. Verificar si los RT están ocupadoa
  if (p1^.Sto = stExpres) then begin
    //Alguno de los operandos de la operación actual, está usando algún RT
    SetResultExpres(typBit, false);  //actualiza "RTstate"
  end else begin
    {Los RT no están siendo usados, por la operación actual.
     Pero pueden estar ocupados por la operación anterior (Ver doc. técnica).}
    SetResultExpres(typBit);  //actualiza "RTstate"
  end;
  //Fija la lógica
  res.Inverted := Inverted;
end;
procedure TGenCodBas.SetROUResultExpres_byte;
{Define el resultado como una expresión de tipo Byte, y se asegura de reservar el
registro W, para devolver la salida. Se debe usar solo para operaciones unarias.}
begin
  GenerateROUdetComment;
  //Se van a usar los RT. Verificar si los RT están ocupadoa
  if (p1^.Sto = stExpres) then begin
    //Alguno de los operandos de la operación actual, está usando algún RT
    SetResultExpres(typByte, false);  //actualiza "RTstate"
  end else begin
    {Los RT no están siendo usados, por la operación actual.
     Pero pueden estar ocupados por la operación anterior (Ver doc. técnica).}
    SetResultExpres(typByte);  //actualiza "RTstate"
  end;
end;
procedure TGenCodBas.SetROUResultExpRef(rVarBase: TxpEleVar; typ: TxpEleType);
{Define el resultado como una expresión stVarRefExp, protegiendo los RT si es necesario.
Se debe usar solo para operaciones unarias.}
begin
  GenerateROUdetComment;
  //Se van a usar los RT. Verificar si los RT están ocupadoa
  if (p1^.Sto = stExpres) then begin
    //Alguno de los operandos de la operación actual, está usando algún RT
    SetResultExpRef(rVarBase, typ, false);  //actualiza "RTstate"
  end else begin
    {Los RT no están siendo usados, por la operación actual.
     Pero pueden estar ocupados por la operación anterior (Ver doc. técnica).}
    SetResultExpRef(rVarBase, typ);  //actualiza "RTstate"
  end;
end;
//Adicionales
procedure TGenCodBas.ChangeResultBitToBool;
{Cambia el tipo de dato del resultado (que se supone es Bit), a Boolean.}
var
  tmpVar: TxpEleVar;
begin
  {Lo más fácil sería hacer: res.Typ := typBool;
  pero cuando "res", sea una variable, se estaría cambiando el ¡tipo de la variable!  }
  case res.Sto of
  stConst : res.SetAsConst(typBool);
  stExpres: res.SetAsExpres(typBool);
  stVariab: begin
    {Para el caso de variables es más complejo, porque no se puede modificar su tipo
    real, sino que hay que crear una variable temporal.}
    tmpVar := CreateTmpVar('', typBool);   //crea variable temporal Boolean
    tmpVar.addr0 := res.rVar.addr0;  //apunta al mismo bit
    tmpVar.bit0 := res.rVar.bit0;
    res.SetAsVariab(tmpVar);   //Devuelve boolean
  end;
  end;
end;
procedure TGenCodBas.ChangeResultCharToByte;
begin

end;
function TGenCodBas.ChangePointerToExpres(var ope: TOperand): boolean;
{Convierte un operando de tipo puntero dereferenciado (x^), en una expresión en los RT,
para que pueda ser evaluado, sin problemas, por las ROP.
Si hay error devuelve false.}
begin
  Result := true;
  if ope.Sto = stVarRef then begin
    //Se tiene una variable puntero dereferenciada: x^
    {Convierte en expresión, verificando los RT}
    if RTstate<>nil then begin
      //Si se usan RT en la operación anterior. Hay que salvar en pila
      RTstate.SaveToStk;  //Se guardan por tipo
      if HayError then exit(false);
    end;
    //Llama a rutina que mueve el operando a RT
    LoadToRT(ope);
    if HayError then exit(false);  //Por si no está implementado
    //COnfigura después SetAsExpres(), para que LoadToRT(), sepa el almacenamiento de "op"
    ope.SetAsExpres(ope.Typ);  //"ope.Typ" es el tipo al que apunta
    InvertedFromC:=false;
    RTstate := ope.Typ;
  end else if ope.Sto = stExpRef then begin
    //Es una expresión.
    {Se asume que el operando tiene su resultado en los RT. SI estuvieran en la pila
    no se aplicaría.}
    //Llama a rutina que mueve el operando a RT
    LoadToRT(ope);
    if HayError then exit(false);  //Por si no está implementado
    //COnfigura después SetAsExpres(), para que LoadToRT(), sepa el almacenamiento de "op"
    ope.SetAsExpres(ope.Typ);  //"ope.Typ" es el tipo al que apunta
    InvertedFromC:=false;
    RTstate := ope.Typ;
  end;
end;
//Rutinas generales para la codificación
procedure TGenCodBas.CodAsmFD(const inst: TPIC10Inst; const f: byte;
  d: TPIC10Destin);
begin
  pic.codAsmFD(inst, f, d);
end;
procedure TGenCodBas.CodAsmK(const inst: TPIC10Inst; const k: byte);
begin
  pic.codAsmK(inst, k);
end;
{procedure CodAsm(const inst: TPIC16Inst; const f, b: byte); inline;
begin
  pic.codAsmFB(inst, f, b);
end;}
//rutinas que facilitan la codifición de instrucciones
procedure TGenCodBas._BANKRESET;
{Reinicia el banco al banco 0, independientemente de donde se pueda encontrar antes.
Siempre genera dos instrucciones. Se usa cuando no se puede predecir exactamente, en que
banco se encontrará el compilador.}
begin
  if pic.NumBanks > 1 then begin
    _BCF(_STATUS, _RP0); PutComm(';Bank reset.');
  end;
  if pic.NumBanks > 2 then begin
    _BCF(_STATUS, _RP1); PutComm(';Bank reset.');
  end;
  CurrBank:=0;
end;
procedure TGenCodBas._BANKSEL(targetBank: byte);
{Verifica si se está en el banco deseado, de no ser así genera las instrucciones
 para el cambio de banco.
 Devuelve el número de instrucciones generado.}
var
  curRP0: Byte;
  newRP0, curRP1, newRP1: byte;
begin
  if pic.NumBanks = 1 then
    exit;  //Caso especial. ¿Hay un PIC de esta serie con un banco?
  if targetBank = CurrBank then
    exit;  //Ya estamos en el banco pedido
  //Se está en un banco diferente
  ////////// Verifica RP0 ////////////
  curRP0 := CurrBank and $01;
  newRP0 := targetBank and $01;
  if (CurrBank = 255) or (curRP0 <> newRP0) then begin
    //Debe haber cambio
    if curRP0 = 0 then begin
      _BSF(_STATUS, _RP0); PutComm(';Bank set.');
    end else begin
      _BCF(_STATUS, _RP0); PutComm(';Bank set.');
    end;
  end;
  //Verifica si ya no hay más bancos
  if pic.NumBanks <= 2 then begin
    CurrBank := targetBank;
    exit;
  end;
  ////////// Verifica RP1 ////////////
  curRP1 := CurrBank and $02;
  newRP1 := targetBank and $02;
  if (CurrBank = 255) or (curRP1 <> newRP1) then begin
    //Debe haber cambio
    if curRP1 = 0 then begin
      _BSF(_STATUS, _RP1); PutComm(';Bank set.');
    end else begin
      _BCF(_STATUS, _RP1); PutComm(';Bank set.');
    end;
  end;
  //////////////////////////////////////
  CurrBank := targetBank;
  exit;
end;
procedure TGenCodBas.GenCodBank(targetAdrr: word);
{Genera código de cambio de banco para acceder a la dirección indicada.
Se debe usar antes de una instrucción que va a acceder a RAM.}
var
  targetBank: byte;
begin
  if targetAdrr and $03f = $000 then exit;   //Mapeada siempre en los 4 bancos
  if targetAdrr and $03f = $004 then exit;   //Mapeada siempre en los 4 bancos
  targetBank := targetAdrr >> 7;
  { TODO : Se debería ver un medio rápido para detectar si la variable "targetAdrr" está
  mapeada, también, en otros bancos y así evitar cambios innecesarios de banco. }
  _BANKSEL(targetBank);
end;

function TGenCodBas._PC: word; inline;
{Devuelve la dirección actual en Flash}
begin
  Result := pic.iFlash;
end;
function TGenCodBas._CLOCK: integer; inline;
{Devuelve la frecuencia de reloj del PIC}
begin
  Result := pic.frequen;
end;
procedure TGenCodBas._LABEL(igot: integer);
{Termina de codificar el GOTO_PEND}
begin
  pic.codGotoAt(igot, _PC);
end;
//Instrucciones simples
{Estas instrucciones no guardan la instrucción compilada en "lastOpCode".}
procedure TGenCodBas._ANDLW(const k: word); inline;
begin
  pic.flash[pic.iFlash].curBnk := CurrBank;
  pic.codAsmK(i_ANDLW, k);
end;
procedure TGenCodBas._ADDWF(const f: byte; d: TPIC10Destin);
begin
  pic.flash[pic.iFlash].curBnk := CurrBank;
  pic.codAsmFD(i_ADDWF, f,d);
end;
procedure TGenCodBas._ANDWF(const f: byte; d: TPIC10Destin);
begin
  pic.flash[pic.iFlash].curBnk := CurrBank;
  pic.codAsmFD(i_ANDWF, f,d);
end;
procedure TGenCodBas._CLRF(const f: byte); inline;
begin
  pic.flash[pic.iFlash].curBnk := CurrBank;
  pic.codAsmF(i_CLRF, f);
end;
procedure TGenCodBas._CLRW; inline;
begin
  pic.flash[pic.iFlash].curBnk := CurrBank;
  pic.codAsm(i_CLRW);
end;
procedure TGenCodBas._COMF(const f: byte; d: TPIC10Destin);
begin
  pic.flash[pic.iFlash].curBnk := CurrBank;
  pic.codAsmFD(i_COMF, f,d);
end;
procedure TGenCodBas._DECF(const f: byte; d: TPIC10Destin);
begin
  pic.flash[pic.iFlash].curBnk := CurrBank;
  pic.codAsmFD(i_DECF, f,d);
end;
procedure TGenCodBas._DECFSZ(const f: byte; d: TPIC10Destin);
begin
  pic.flash[pic.iFlash].curBnk := CurrBank;
  pic.codAsmFD(i_DECFSZ, f,d);
end;
procedure TGenCodBas._INCF(const f: byte; d: TPIC10Destin);
begin
  pic.flash[pic.iFlash].curBnk := CurrBank;
  pic.codAsmFD(i_INCF, f,d);
end;
procedure TGenCodBas._INCFSZ(const f: byte; d: TPIC10Destin);
begin
  pic.flash[pic.iFlash].curBnk := CurrBank;
  pic.codAsmFD(i_INCFSZ, f,d);
end;
procedure TGenCodBas._IORWF(const f: byte; d: TPIC10Destin);
begin
  pic.flash[pic.iFlash].curBnk := CurrBank;
  pic.codAsmFD(i_IORWF, f,d);
end;
procedure TGenCodBas._MOVF(const f: byte; d: TPIC10Destin);
begin
  pic.flash[pic.iFlash].curBnk := CurrBank;
  pic.codAsmFD(i_MOVF, f,d);
end;
procedure TGenCodBas._MOVWF(const f: byte);
begin
  pic.flash[pic.iFlash].curBnk := CurrBank;
  pic.codAsmF(i_MOVWF, f);
end;
procedure TGenCodBas._NOP; inline;
begin
  pic.flash[pic.iFlash].curBnk := CurrBank;
  pic.codAsm(i_NOP);
end;
procedure TGenCodBas._RLF(const f: byte; d: TPIC10Destin);
begin
  pic.flash[pic.iFlash].curBnk := CurrBank;
  pic.codAsmFD(i_RLF, f,d);
end;
procedure TGenCodBas._RRF(const f: byte; d: TPIC10Destin);
begin
  pic.flash[pic.iFlash].curBnk := CurrBank;
  pic.codAsmFD(i_RRF, f,d);
end;
procedure TGenCodBas._SUBWF(const f: byte; d: TPIC10Destin);
begin
  pic.flash[pic.iFlash].curBnk := CurrBank;
  pic.codAsmFD(i_SUBWF, f,d);
end;
procedure TGenCodBas._SWAPF(const f: byte; d: TPIC10Destin);
begin
  pic.flash[pic.iFlash].curBnk := CurrBank;
  pic.codAsmFD(i_SWAPF, f,d);
end;
procedure TGenCodBas._BCF(const f, b: byte); inline;
begin
  pic.flash[pic.iFlash].curBnk := CurrBank;
  pic.codAsmFB(i_BCF, f, b);
end;
procedure TGenCodBas._BSF(const f, b: byte); //inline;
begin
  pic.flash[pic.iFlash].curBnk := CurrBank;
  pic.codAsmFB(i_BSF, f, b);
end;
procedure TGenCodBas._BTFSC(const f, b: byte); inline;
begin
  pic.flash[pic.iFlash].curBnk := CurrBank;
  pic.codAsmFB(i_BTFSC, f, b);
end;
procedure TGenCodBas._BTFSS(const f, b: byte); inline;
begin
  pic.flash[pic.iFlash].curBnk := CurrBank;
  pic.codAsmFB(i_BTFSS, f, b);
end;
procedure TGenCodBas._CALL(const a: word); inline;
begin
  pic.flash[pic.iFlash].curBnk := CurrBank;
  pic.codAsmA(i_CALL, a);
end;
procedure TGenCodBas._CLRWDT; inline;
begin
  pic.flash[pic.iFlash].curBnk := CurrBank;
  pic.codAsm(i_CLRWDT);
end;
procedure TGenCodBas._GOTO(const a: word); inline;
begin
  pic.flash[pic.iFlash].curBnk := CurrBank;
  pic.codAsmA(i_GOTO, a);
end;
procedure TGenCodBas._GOTO_PEND(out igot: integer);
{Escribe una instrucción GOTO, pero sin precisar el destino aún. Devuelve la dirección
 donde se escribe el GOTO, para poder completarla posteriormente.
}
begin
  igot := pic.iFlash;  //guarda posición de instrucción de salto
  pic.flash[pic.iFlash].curBnk := CurrBank;
  pic.codAsmA(i_GOTO, 0);  //pone salto indefinido
end;
procedure TGenCodBas._IORLW(const k: word); inline;
begin
  pic.flash[pic.iFlash].curBnk := CurrBank;
  pic.codAsmK(i_IORLW, k);
end;
procedure TGenCodBas._MOVLW(const k: word); inline;
begin
  pic.flash[pic.iFlash].curBnk := CurrBank;
  pic.codAsmK(i_MOVLW, k);
end;
procedure TGenCodBas._RETFIE; inline;
begin
  pic.flash[pic.iFlash].curBnk := CurrBank;
  pic.codAsm(i_RETFIE);
end;
procedure TGenCodBas._RETLW(const k: word); inline;
begin
  pic.flash[pic.iFlash].curBnk := CurrBank;
  pic.codAsmK(i_RETLW, k);
end;
procedure TGenCodBas._RETURN;
begin
  pic.flash[pic.iFlash].curBnk := CurrBank;
  pic.codAsm(i_RETURN);
end;
procedure TGenCodBas._SLEEP; inline;
begin
  pic.flash[pic.iFlash].curBnk := CurrBank;
  pic.codAsm(i_SLEEP);
end;
procedure TGenCodBas._XORLW(const k: word); inline;
begin
  pic.flash[pic.iFlash].curBnk := CurrBank;
  pic.codAsmK(i_XORLW, k);
end;
procedure TGenCodBas._XORWF(const f: byte; d: TPIC10Destin);
begin
  pic.flash[pic.iFlash].curBnk := CurrBank;
  pic.codAsmFD(i_XORWF, f,d);
end;
procedure TGenCodBas._TRIS(const f: byte);
begin
  pic.flash[pic.iFlash].curBnk := CurrBank;
  pic.codAsmF(i_TRIS, f);
end;
procedure TGenCodBas._IFZERO;
begin
  _BTFSC(_STATUS, _Z);
end;
procedure TGenCodBas._IFNZERO;
begin
  _BTFSS(_STATUS, _Z);
end;
//Instrucciones que manejan el cambio de banco
{Estas instrucciones guardan la instrucción compilada en "lastOpCode".}
//procedure TGenCodBas.kADDWF(const f: word; d: TPIC10Destin);
//begin
//  GenCodBank(f);
//  pic.flash[pic.iFlash].curBnk := CurrBank;
//  pic.codAsmFD(i_ADDWF, f,d);
//end;
procedure TGenCodBas.kADDWF(addr: word; d: TPIC10Destin);
begin
  GenCodBank(addr);
  pic.flash[pic.iFlash].curBnk := CurrBank;
  pic.codAsmFD(i_ADDWF, addr, d);
end;
procedure TGenCodBas.kANDLW(const k: word); inline;
begin
  pic.flash[pic.iFlash].curBnk := CurrBank;
  pic.codAsmK(i_ANDLW, k);
end;
procedure TGenCodBas.kANDWF(addr: word; d: TPIC10Destin);
begin
  GenCodBank(addr);
  pic.flash[pic.iFlash].curBnk := CurrBank;
  pic.codAsmFD(i_ANDWF, addr, d);
end;
procedure TGenCodBas.kCLRF(addr: word);
begin
  GenCodBank(addr);
  pic.flash[pic.iFlash].curBnk := CurrBank;
  pic.codAsmF(i_CLRF, addr);
end;
procedure TGenCodBas.kCLRW;
begin
  pic.flash[pic.iFlash].curBnk := CurrBank;
  pic.codAsm(i_CLRW);
end;
procedure TGenCodBas.kCOMF(addr: word; d: TPIC10Destin);
begin
  GenCodBank(addr);
  pic.flash[pic.iFlash].curBnk := CurrBank;
  pic.codAsmFD(i_COMF, addr, d);
end;
procedure TGenCodBas.kDECF(addr: word; d: TPIC10Destin);
begin
  GenCodBank(addr);
  pic.flash[pic.iFlash].curBnk := CurrBank;
  pic.codAsmFD(i_DECF, addr, d);
end;
procedure TGenCodBas.kDECFSZ(const f: word; d: TPIC10Destin);
begin
  GenCodBank(f);
  pic.flash[pic.iFlash].curBnk := CurrBank;
  pic.codAsmFD(i_DECFSZ, f,d);
end;
procedure TGenCodBas.kINCF(addr: word; d: TPIC10Destin);
begin
  GenCodBank(addr);
  pic.flash[pic.iFlash].curBnk := CurrBank;
  pic.codAsmFD(i_INCF, addr, d);
end;
procedure TGenCodBas.kINCFSZ(const f: word; d: TPIC10Destin);
begin
  GenCodBank(f);
  pic.flash[pic.iFlash].curBnk := CurrBank;
  pic.codAsmFD(i_INCFSZ, f,d);
end;
//procedure TGenCodBas.kIORWF(const f: word; d: TPIC10Destin);
//begin
//  GenCodBank(f);
//  pic.flash[pic.iFlash].curBnk := CurrBank;
//  pic.codAsmFD(i_IORWF, f,d);
//end;
procedure TGenCodBas.kIORWF(addr: word; d: TPIC10Destin);
begin
  GenCodBank(addr);
  pic.flash[pic.iFlash].curBnk := CurrBank;
  pic.codAsmFD(i_IORWF, addr, d);
end;
procedure TGenCodBas.kMOVF(addr: word; d: TPIC10Destin);
begin
  GenCodBank(addr);
  pic.flash[pic.iFlash].curBnk := CurrBank;
  pic.codAsmFD(i_MOVF, addr, d);
end;
procedure TGenCodBas.kMOVWF(addr: word);
begin
  GenCodBank(addr);
  pic.flash[pic.iFlash].curBnk := CurrBank;
  pic.codAsmF(i_MOVWF, addr);
end;
procedure TGenCodBas.kNOP; inline;
begin
  pic.flash[pic.iFlash].curBnk := CurrBank;
  pic.codAsm(i_NOP);
end;
procedure TGenCodBas.kRLF(addr: word; d: TPIC10Destin);
begin
  GenCodBank(addr);
  pic.flash[pic.iFlash].curBnk := CurrBank;
  pic.codAsmFD(i_RLF, addr, d);
end;
procedure TGenCodBas.kRRF(addr: word; d: TPIC10Destin);
begin
  GenCodBank(addr);
  pic.flash[pic.iFlash].curBnk := CurrBank;
  pic.codAsmFD(i_RRF, addr, d);
end;
//procedure TGenCodBas.kSUBWF(const f: word; d: TPIC10Destin);
//begin
//  GenCodBank(f);
//  pic.flash[pic.iFlash].curBnk := CurrBank;
//  pic.codAsmFD(i_SUBWF, f,d);
//end;
procedure TGenCodBas.kSUBWF(addr: word; d: TPIC10Destin);
begin
  GenCodBank(addr);
  pic.flash[pic.iFlash].curBnk := CurrBank;
  pic.codAsmFD(i_SUBWF, addr, d);
end;
procedure TGenCodBas.kSWAPF(addr: word; d: TPIC10Destin);
begin
  GenCodBank(addr);
  pic.flash[pic.iFlash].curBnk := CurrBank;
  pic.codAsmFD(i_SWAPF, addr, d);
end;
procedure TGenCodBas.kBCF(const f: TPicRegisterBit);
begin
  GenCodBank(f.addr);
  pic.flash[pic.iFlash].curBnk := CurrBank;
  pic.codAsmFB(i_BCF, f.addr, f.bit);
end;
procedure TGenCodBas.kBSF(const f: TPicRegisterBit);
begin
  GenCodBank(f.addr);
  pic.flash[pic.iFlash].curBnk := CurrBank;
  pic.codAsmFB(i_BSF, f.addr, f.bit);
end;
procedure TGenCodBas.kBTFSC(const f: TPicRegisterBit);
begin
  GenCodBank(f.addr);
  pic.flash[pic.iFlash].curBnk := CurrBank;
  pic.codAsmFB(i_BTFSC, f.addr, f.bit);
end;
procedure TGenCodBas.kBTFSS(const f: TPicRegisterBit);
begin
  GenCodBank(f.addr);
  pic.flash[pic.iFlash].curBnk := CurrBank;
  pic.codAsmFB(i_BTFSS, f.addr, f.bit);
end;
procedure TGenCodBas.kCALL(const a: word); inline;
begin
  pic.flash[pic.iFlash].curBnk := CurrBank;
  pic.codAsmA(i_CALL, a);
end;
procedure TGenCodBas.kCLRWDT; inline;
begin
  pic.flash[pic.iFlash].curBnk := CurrBank;
  pic.codAsm(i_CLRWDT);
end;
procedure TGenCodBas.kGOTO(const a: word); inline;
begin
  pic.flash[pic.iFlash].curBnk := CurrBank;
  pic.codAsmA(i_GOTO, a);
end;
procedure TGenCodBas.kGOTO_PEND(out igot: integer);
{Escribe una instrucción GOTO, pero sin precisar el destino aún. Devuelve la dirección
 donde se escribe el GOTO, para poder completarla posteriormente.
}
begin
  igot := pic.iFlash;  //guarda posición de instrucción de salto
  pic.flash[pic.iFlash].curBnk := CurrBank;
  pic.codAsmA(i_GOTO, 0);  //pone salto indefinido
end;
procedure TGenCodBas.kIORLW(const k: word); inline;
begin
  pic.flash[pic.iFlash].curBnk := CurrBank;
  pic.codAsmK(i_IORLW, k);
end;
procedure TGenCodBas.kMOVLW(const k: word); inline;
begin
  pic.flash[pic.iFlash].curBnk := CurrBank;
  pic.codAsmK(i_MOVLW, k);
end;
procedure TGenCodBas.kRETFIE;
begin
  pic.flash[pic.iFlash].curBnk := CurrBank;
  pic.codAsm(i_RETFIE);
end;
procedure TGenCodBas.kRETLW(const k: word); inline;
begin
  pic.flash[pic.iFlash].curBnk := CurrBank;
  pic.codAsmK(i_RETLW, k);
end;
procedure TGenCodBas.kRETURN; inline;
begin
  pic.flash[pic.iFlash].curBnk := CurrBank;
  pic.codAsm(i_RETURN);
end;
procedure TGenCodBas.kSLEEP; inline;
begin
  pic.flash[pic.iFlash].curBnk := CurrBank;
  pic.codAsm(i_SLEEP);
end;
procedure TGenCodBas.kSUBLW_x(const k: word);
{Instrucción simulada, ya que en esta familia, no existe la instrucción SUBLW.}
var
  aux, aux2: TPicRegister;
begin
  aux := GetAuxRegisterByte;
  aux2 := GetAuxRegisterByte;
  kMOVWF(aux.addr);  //Salva W
  kMOVLW(k);
  kMOVWF(aux2.addr);
  kMOVF(aux.addr, toW);
  kSUBWF(aux2.addr, toW);
  aux.used := false;
  aux2.used := false;
////Esta versión es más corta pero no actualiza el bit C de la misma forma
//  aux := GetAuxRegisterByte;
//  kMOVWF(aux);  //Salva W
//  kMOVLW(k+1);
//  kSUBWF(aux, toF); //W - K -> aux
//  kCOMF(aux, toW);
//  aux.used := false;
end;
procedure TGenCodBas.kXORLW(const k: word); inline;
begin
  pic.flash[pic.iFlash].curBnk := CurrBank;
  pic.codAsmK(i_XORLW, k);
end;
procedure TGenCodBas.kXORWF(addr: word; d: TPIC10Destin);
begin
  GenCodBank(addr);
  pic.flash[pic.iFlash].curBnk := CurrBank;
  pic.codAsmFD(i_XORWF, addr, d);
end;
//Instrucciones adicionales
procedure TGenCodBas.kSHIFTR(addr: word; d: TPIC10destin);
begin
  _BCF(_STATUS, _C);
  GenCodBank(addr);
  _RRF(addr, d);
end;
procedure TGenCodBas.kSHIFTL(addr: word; d: TPIC10destin);
begin
  _BCF(_STATUS, _C);
  GenCodBank(addr);
  _RLF(addr, d);
end;
procedure TGenCodBas.kIF_BSET(const f: TPicRegisterBit; out igot: integer);
{Conditional instruction. Test if the specified bit is set. In this case, execute
the following block.
This instruction require to call to kEND_BSET() to define the End of the block.
The strategy here is to generate the sequence:

  <Bank setting>
  i_BTFSS f
  GOTO  <Block end>
  ;--- Block start ---
  <several instructions>
  ;--- Block end ---

This scheme is the worst case (assuming the GOTO instruction is only one word), later
if the body of the IF, is only one word, it will be optimized to:

  <Bank setting>
  i_BTFSC f
  ;--- Block start ---
  <one instruction>
  ;--- Block end ---

It's not used the best case first, because in case it needs to change to the worst case,
it would need to insert and move several words, including, probably, GOTOs and LABELs,
needing to recalculate jumps.
}
begin
  GenCodBank(f.addr);
  _BTFSS(f.addr, f.bit);
  igot := pic.iFlash;     //guarda posición de instrucción de salto
  _GOTO(0); //salto pendiente
end;
procedure TGenCodBas.kIF_BSET_END(igot: integer);
{Define the End of the block, created with kIF_BSET().}
begin
  if _PC = igot+1 then begin
    //No hay instrucciones en en bloque
    pic.iFlash:=pic.iFlash-2 ;  //Elimina hasta el i_BTFSS, porque no tiene sentido
  end else if _PC = igot+2 then begin
    //Es un bloque de una sola instrucción. Se puede optimizar
    pic.BTFSC_sw_BTFSS(igot-1);  //Cambia i_BTFSS por i_BTFSC
    pic.flash[igot] := pic.flash[igot+1];  //Desplaza la instrucción
    pic.flash[igot].used:=false;  //Elimina
  end else begin
    //Bloque de varias instrucciones
    pic.codGotoAt(igot, _PC);   //termina de codificar el salto
  end;
end;
procedure TGenCodBas.kIF_BCLR(const f: TPicRegisterBit; out igot: integer);
{Conditional instruction. Test if the specified bit is zero. In this case, execute
the following block.}
begin
  GenCodBank(f.addr);
  _BTFSC(f.addr, f.bit);
  igot := pic.iFlash;     //guarda posición de instrucción de salto
  _GOTO(0); //salto pendiente
end;
procedure TGenCodBas.kIF_BCLR_END(igot: integer); inline;
{Define the End of the block, created with kIF_BCLR.}
begin
  kIF_BSET_END(igot);
end;
procedure TGenCodBas.kIF_ZERO(out igot: integer); inline;
{Conditional instruction. Test if the STATUS.Z flag is activated. In this case, execute
the following block.}
begin
  kIF_BSET(Z, igot);
end;
procedure TGenCodBas.kIF_ZERO_END(igot: integer); inline;
{Define the End of the block, created with kIF_ZERO.}
begin
  kIF_BSET_END(igot);
end;
procedure TGenCodBas.kIF_NZERO(out igot: integer);
begin
  kIF_BCLR(Z, igot);
end;

procedure TGenCodBas.kIF_NZERO_END(igot: integer);
begin
  kIF_BCLR_END(igot);
end;

function TGenCodBas.PICName: string;
begin
  Result := pic.Model;
end;
function TGenCodBas.PICNameShort: string;
{Genera el nombre del PIC, quitándole la parte inicial "PIC".}
begin
  Result := copy(pic.Model, 4, length(pic.Model));
end;
function TGenCodBas.PICnBanks: byte;
begin
  Result := pic.NumBanks;
end;
function TGenCodBas.PICCurBank: byte;
begin
  Result := pic.BSR;
end;
function TGenCodBas.PICBank(i: byte): TPICRAMBank;
begin
  Result := pic.banks[i];
end;
function TGenCodBas.PICnPages: byte;
begin
  Result := pic.NumPages;
end;
function TGenCodBas.PICPage(i: byte): TPICFlashPage;
begin
  Result := pic.pages[i];
end;
function TGenCodBas.GetIdxParArray(out WithBrack: boolean; out par: TOperand): boolean;
{Extrae el primer parámetro (que corresponde al índice) de las funciones getitem() o
setitem(). También reconoce las formas con corchetes [], y en ese caso pone "WithBrackets"
en TRUE. Si encuentra error, devuelve false.}
begin
  if cIn.tok = '[' then begin
    //Es la sintaxis a[i];
    WithBrack := true;
    cIn.Next;  //Toma "["
  end else begin
    //Es la sintaxis a.item(i);
    WithBrack := false;
    cIn.Next;  //Toma identificador de campo
    //Captura parámetro
    if not CaptureTok('(') then exit(false);
  end;
  par := GetExpression(0);  //Captura parámetro. No usa GetExpressionE, para no cambiar RTstate
  if HayError then exit(false);
  if par.Typ <> typByte then begin
    GenError('Expected byte as index.');
  end;
  if HayError then exit(false);
  exit(true);
end;
function TGenCodBas.GetValueToAssign(WithBrack: boolean; arrVar: TxpEleVar; out value: TOperand): boolean;
{Lee el segundo parámetro de SetItem y devuelve en "value". Valida que sea sel tipo
correcto. Si hay error, devuelve FALSE.}
var
  typItem: TxpEleType;
begin
  if WithBrack then begin
    if not CaptureTok(']') then exit(false);
    cIn.SkipWhites;
    {Legalmente, aquí podría seguir otro operador, o función como ".bit0", y no solo
    ":=". Esto es una implementación algo limitada. Lo que debería hacerse, si no se
    encuentra ":=", sería devolver una referencia a variable, tal vez a un nuevo tipo
    de variable, con dirección "indexada", pero obligaría a crear un atributo más a
    las varaibles. El caso de un índice constante es más sencillo de procesar.}
    if not CaptureTok(':=') then exit(false);
  end else begin
    if not CaptureTok(',') then exit(false);
  end;
  value := GetExpression(0);  //Captura parámetro. No usa GetExpressionE, para no cambiar RTstate
  typItem := arrVar.typ.itmType;
  if value.Typ <> typItem then begin  //Solo debería ser byte o char
    if (value.Typ = typByte) and (typItem = typWord) then begin
      //Son tipos compatibles
      value.SetAsConst(typWord);   //Cmabiamos el tipo
    end else begin
      GenError('%s expression expected.', [typItem.name]);
      exit(false);
    end;
  end;
  exit(true);
end;
///////////////// Tipo Bit ////////////////
procedure TGenCodBas.bit_LoadToRT(const OpPtr: pointer; modReturn: boolean);
{Carga operando a registros Z.}
var
  Op: ^TOperand;
begin
  Op := OpPtr;
  case Op^.Sto of  //el parámetro debe estar en "res"
  stConst : begin
    if Op^.valBool then
      _BSF(Z.offs, Z.bit)
    else
      _BCF(Z.offs, Z.bit);
  end;
  stVariab: begin
    //La lógica en Z, dene ser normal, proque no hay forma de leerla.
    //Como Z, está en todos los bancos, no hay mucho problema.
    if Op^.Inverted then begin
      //No se usa el registro W
      kBCF(Z);
      kBTFSS(Op^.rVar.adrBit);
      kBSF(Z);
    end else begin
      //No se usa el registro W
      kBCF(Z);
      kBTFSC(Op^.rVar.adrBit);
      kBSF(Z);
    end;
  end;
  stExpres: begin  //ya está en w
    if Op^.Inverted then begin
      //Aquí hay un problema, porque hay que corregir la lógica
      _MOVLW($1 << Z.bit);
      _ANDWF(Z.offs, toW);  //invierte Z
    end else begin
      //No hay mada que hacer
    end;
  end;
  else
    //Almacenamiento no implementado
    GenError(MSG_NOT_IMPLEM);
  end;
  if modReturn then _RETURN;  //codifica instrucción
end;
procedure TGenCodBas.bit_DefineRegisters;
begin
  //No es encesario, definir registros adicionales a W
end;
procedure TGenCodBas.bit_SaveToStk;
{Guarda el valor bit, cargado actualmente en Z, a pila.}
var
  stk: TPicRegisterBit;
begin
  stk := GetStkRegisterBit;  //pide memoria
  if stk= nil then exit;   //error
  //Guarda Z
  _BANKSEL(stk.bank);
  _BCF(stk.offs, stk.bit); PutComm(TXT_SAVE_Z);
  _BTFSC(Z.offs, Z.bit); PutComm(TXT_SAVE_Z);
  _BSF(stk.offs, stk.bit); PutComm(TXT_SAVE_Z);
  stk.used := true;
end;
//////////////// Tipo Byte /////////////
procedure TGenCodBas.byte_LoadToRT(const OpPtr: pointer; modReturn: boolean);
{Carga operando a registros de trabajo.}
var
  Op: ^TOperand;
  varPtr: TxpEleVar;
begin
  Op := OpPtr;
  case Op^.Sto of  //el parámetro debe estar en "res"
  stConst : begin
    if modReturn then _RETLW(Op^.valInt)
    else _MOVLW(Op^.valInt);
  end;
  stVariab: begin
    kMOVF(Op^.rVar.addr0, toW);
    if modReturn then _RETURN;
  end;
  stExpres: begin  //ya está en w
    if modReturn then _RETURN;
  end;
  stVarRef: begin
    //Se tiene una variable puntero dereferenciada: x^
    varPtr := Op^.rVar;  //Guarda referencia a la variable puntero
    //Mueve a W
    kMOVF(varPtr.addr0, toW);
    kMOVWF(FSR.addr);  //direcciona
    kMOVF(INDF.addr, toW);  //deje en W
    if modReturn then _RETURN;
  end;
  stExpRef: begin
    //Es una expresión derefernciada (x+a)^.
    {Se asume que el operando tiene su resultado en los RT. Si estuvieran en la pila
    no se aplicaría.}
    //Mueve a W
    _MOVWF(FSR.offs);  //direcciona
    _MOVF(0, toW);  //deje en W
    if modReturn then _RETURN;
  end;
  else
    //Almacenamiento no implementado
    GenError(MSG_NOT_IMPLEM);
  end;
end;
procedure TGenCodBas.byte_DefineRegisters;
begin
  //No es encesario, definir registros adicionales a W
end;
procedure TGenCodBas.byte_SaveToStk;
var
  stk: TPicRegister;
begin
  stk := GetStkRegisterByte;  //pide memoria
  //guarda W
  _BANKSEL(stk.bank);
  _MOVWF(stk.offs);PutComm(TXT_SAVE_W);
  stk.used := true;
end;
procedure TGenCodBas.byte_GetItem(const OpPtr: pointer);
//Función que devuelve el valor indexado
var
  Op: ^TOperand;
  arrVar, tmpVar: TxpEleVar;
  idx: TOperand;
  WithBrack: Boolean;
begin
  if not GetIdxParArray(WithBrack, idx) then exit;
  //Procesa
  Op := OpPtr;
  if Op^.Sto = stVariab then begin
    //Se aplica a una variable array. Lo Normal.
    arrVar := Op^.rVar;  //referencia a la variable.
    //Genera el código de acuerdo al índice
    case idx.Sto of
    stConst: begin  //ïndice constante
        tmpVar := CreateTmpVar('', typByte);
        tmpVar.addr0 := arrVar.addr0 + idx.valInt;  //¿Y si es de otro banco?
        SetResultVariab(tmpVar);
      end;
    stVariab: begin
        SetResultExpres(arrVar.typ.itmType, true);  //Es array de bytes, o Char, devuelve Byte o Char
        LoadToRT(idx);   //Lo deja en W
        _MOVLW(arrVar.addr0);   //agrega OFFSET
        _ADDWF(04, toF);
        _MOVF(0, toW);  //lee indexado en W
    end;
    stExpres: begin
        SetResultExpres(arrVar.typ.itmType, false);  //Es array de bytes, o Char, devuelve Byte o Char
        LoadToRT(idx);   //Lo deja en W
        _MOVLW(arrVar.addr0);   //agrega OFFSET
        _ADDWF(04, toF);
        _MOVF(0, toW);  //lee indexado en W
      end;
    end;
  end else begin
    GenError('Syntax error.');
  end;
  if WithBrack then begin
    if not CaptureTok(']') then exit;
  end else begin
    if not CaptureTok(')') then exit;
  end;
end;
procedure TGenCodBas.byte_SetItem(const OpPtr: pointer);
//Función que fija un valor indexado
var
  WithBrack: Boolean;
var
  Op: ^TOperand;
  arrVar, rVar: TxpEleVar;
  idx, value: TOperand;
  idxTar: word;
begin
  if not GetIdxParArray(WithBrack, idx) then exit;
  //Procesa
  Op := OpPtr;
  if Op^.Sto = stVariab then begin  //Se aplica a una variable
    arrVar := Op^.rVar;  //referencia a la variable.
    res.SetAsNull;  //No devuelve nada
    //Genera el código de acuerdo al índice
    case idx.Sto of
    stConst: begin  //ïndice constante
        //Como el índice es constante, se puede acceder directamente
        idxTar := arrVar.adrByte0.offs+idx.valInt; //índice destino
        if not GetValueToAssign(WithBrack, arrVar, value) then exit;
        if (value.Sto = stConst) and (value.valInt=0) then begin
          //Caso especial, se pone a cero
          _CLRF(idxTar);
        end else begin
          //Sabemos que hay una expresión byte
          LoadToRT(value); //Carga resultado en W
          _MOVWF(idxTar);  //Mueve a arreglo
        end;
      end;
    stVariab: begin
        //El índice es una variable
        //Tenemos la referencia la variable en idx.rvar
        if not GetValueToAssign(WithBrack, arrVar, value) then exit;
        //Sabemos que hay una expresión byte
        if (value.Sto = stConst) and (value.valInt=0) then begin
          //Caso especial, se pide asignar una constante cero
          _MOVF(idx.offs, toW);  //índice
          _MOVLW(arrVar.addr0);
          _ADDWF(04, toF);  //Direcciona
          _CLRF($00);   //Pone a cero
        end else if value.Sto = stConst then begin
          //Es una constante cualquiera
          _MOVF(idx.offs, toW);  //índice
          _MOVLW(arrVar.addr0);
          _ADDWF(04, toF);  //Direcciona
          _MOVLW(value.valInt);
          _MOVWF($00);   //Escribe valor
        end else if value.Sto = stVariab then begin
          //Es una variable
          _MOVLW(arrVar.addr0);
          _ADDWF(04, toF);  //Direcciona
          _MOVWF($04);  //Direcciona
          _MOVF(value.offs, toW);
          _MOVWF($00);   //Escribe valor
        end else begin
          //Es una expresión. El resultado está en W
          //hay que mover value a arrVar[idx.rvar]
          typWord.DefineRegister;   //Para usar H
          _MOVWF(H.offs);  //W->H   salva H
          _MOVF(idx.offs, toW);  //índice
          _MOVLW(arrVar.addr0);
          _ADDWF(04, toF);  //Direcciona
          _MOVF(H.offs, toW);
          _MOVWF($00);   //Escribe valor
        end;
      end;
    stExpres: begin
      //El índice es una expresión y está en W.
      if not GetValueToAssign(WithBrack, arrVar, value) then exit;
      //Sabemos que hay una expresión byte
      if (value.Sto = stConst) and (value.valInt=0) then begin
        //Caso especial, se pide asignar una constante cero
        _MOVLW(arrVar.addr0);
        _ADDWF(04, toF);  //Direcciona
        _CLRF($00);   //Pone a cero
      end else if value.Sto = stConst then begin
        //Es una constante cualquiera
        _MOVLW(arrVar.addr0);
        _ADDWF(04, toF);  //Direcciona
        _MOVLW(value.valInt);
        _MOVWF($00);   //Escribe valor
      end else if value.Sto = stVariab then begin
        //Es una variable
        _MOVLW(arrVar.addr0);
        _ADDWF(FSR.offs, toF);  //Direcciona
        _MOVF(value.offs, toW);
        _MOVWF($00);   //Escribe valor
      end else begin
        //Es una expresión. El valor a asignar está en W, y el índice en la pila
        typWord.DefineRegister;   //Para usar H
        _MOVWF(H.offs);  //W->H   salva valor a H
        rVar := GetVarByteFromStk;  //toma referencia de la pila
        _MOVF(rVar.adrByte0.offs, toW);  //índice
        _MOVLW(arrVar.addr0);
        _ADDWF(04, toF);  //Direcciona
        _MOVF(H.offs, toW);
        _MOVWF($00);   //Escribe valor
        FreeStkRegisterByte;   //Para liberar
      end;
      end;
    end;
  end else begin
    GenError('Syntax error.');
  end;
  if WithBrack then begin
    //En este modo, no se requiere ")"
  end else begin
    if not CaptureTok(')') then exit;
  end;
end;
procedure TGenCodBas.byte_ClearItems(const OpPtr: pointer);
{Limpia el contenido de todo el arreglo}
var
  Op: ^TOperand;
  xvar: TxpEleVar;
  j1: Word;
begin
  cIn.Next;  //Toma identificador de campo
  //Limpia el arreglo
  Op := OpPtr;
  case Op^.Sto of
  stVariab: begin
    xvar := Op^.rVar;  //Se supone que debe ser de tipo ARRAY
    res.SetAsConst(typByte);  //Realmente no es importante devolver un valor
    res.valInt {%H-}:= xvar.typ.nItems;  //Devuelve tamaño
    if xvar.typ.nItems = 0 then exit;  //No hay nada que limpiar
    if xvar.typ.nItems = 1 then begin  //Es de un solo byte
      _BANKSEL(xvar.adrByte0.bank);
      _CLRF(xvar.adrByte0.offs);
    end else if xvar.typ.nItems = 2 then begin  //Es de 2 bytes
      _BANKSEL(xvar.adrByte0.bank);
      _CLRF(xvar.adrByte0.offs);
      _CLRF(xvar.adrByte0.offs+1);
    end else if xvar.typ.nItems = 3 then begin  //Es de 3 bytes
      _BANKSEL(xvar.adrByte0.bank);
      _CLRF(xvar.adrByte0.offs);
      _CLRF(xvar.adrByte0.offs+1);
      _CLRF(xvar.adrByte0.offs+2);
    end else if xvar.typ.nItems = 4 then begin  //Es de 4 bytes
      _BANKSEL(xvar.adrByte0.bank);
      _CLRF(xvar.adrByte0.offs);
      _CLRF(xvar.adrByte0.offs+1);
      _CLRF(xvar.adrByte0.offs+2);
      _CLRF(xvar.adrByte0.offs+3);
    end else if xvar.typ.nItems = 5 then begin  //Es de 5 bytes
      _BANKSEL(xvar.adrByte0.bank);
      _CLRF(xvar.adrByte0.offs);
      _CLRF(xvar.adrByte0.offs+1);
      _CLRF(xvar.adrByte0.offs+2);
      _CLRF(xvar.adrByte0.offs+3);
      _CLRF(xvar.adrByte0.offs+4);
    end else if xvar.typ.nItems = 6 then begin  //Es de 6 bytes
      _BANKSEL(xvar.adrByte0.bank);
      _CLRF(xvar.adrByte0.offs);
      _CLRF(xvar.adrByte0.offs+1);
      _CLRF(xvar.adrByte0.offs+2);
      _CLRF(xvar.adrByte0.offs+3);
      _CLRF(xvar.adrByte0.offs+4);
      _CLRF(xvar.adrByte0.offs+5);
    end else if xvar.typ.nItems = 7 then begin  //Es de 7 bytes
      _BANKSEL(xvar.adrByte0.bank);
      _CLRF(xvar.adrByte0.offs);
      _CLRF(xvar.adrByte0.offs+1);
      _CLRF(xvar.adrByte0.offs+2);
      _CLRF(xvar.adrByte0.offs+3);
      _CLRF(xvar.adrByte0.offs+4);
      _CLRF(xvar.adrByte0.offs+5);
      _CLRF(xvar.adrByte0.offs+6);
    end else begin
      //Implementa lazo, usando W como índice
      _MOVLW(xvar.adrByte0.offs);  //dirección inicial
      _MOVWF($04);   //FSR
      //_MOVLW(256-xvar.typ.arrSize);
j1:= _PC;
      _CLRF($00);    //Limpia [FSR]
      _INCF($04, toF);    //Siguiente
      _MOVLW(xvar.adrByte0.offs+256-xvar.typ.nItems);  //End address
      _SUBWF($04, toW);
      _IFNZERO;
      _GOTO(j1);
    end;
  end;
  else
    GenError('Syntax error.');
  end;
end;
procedure TGenCodBas.byte_bit(const OpPtr: pointer; nbit: byte);
//Implementa la operación del campo <tipo>.bit#
var
  xvar, tmpVar: TxpEleVar;
  msk: byte;
  Op: ^TOperand;
begin
  cIn.Next;       //Toma el identificador de campo
  Op := OpPtr;
  case Op^.Sto of
  stVariab: begin
    xvar := Op^.rVar;
    //Crea una variable temporal que representará al campo
    tmpVar := CreateTmpVar(xvar.name+'.bit' + IntToStr(nbit), typBit);   //crea variable temporal
    tmpVar.addr0 := xvar.addr0;
    tmpVar.bit0  := nbit;
    //Se devuelve una variable, byte
    res.SetAsVariab(tmpVar);   //actualiza la referencia (y actualiza el tipo).
  end;
  stConst: begin
    //Se devuelve una constante bit
    res.SetAsConst(typBit);
    msk := Op^.valInt and ($01 << nbit);
    res.valBool := msk <> 0;
  end;
  else
    GenError('Syntax error.');
  end;
end;
procedure TGenCodBas.byte_bit0(const OpPtr: pointer);
begin
  byte_bit(OpPtr, 0);
end;
procedure TGenCodBas.byte_bit1(const OpPtr: pointer);
begin
  byte_bit(OpPtr, 1);
end;
procedure TGenCodBas.byte_bit2(const OpPtr: pointer);
begin
  byte_bit(OpPtr, 2);
end;
procedure TGenCodBas.byte_bit3(const OpPtr: pointer);
begin
  byte_bit(OpPtr, 3);
end;
procedure TGenCodBas.byte_bit4(const OpPtr: pointer);
begin
  byte_bit(OpPtr, 4);
end;
procedure TGenCodBas.byte_bit5(const OpPtr: pointer);
begin
  byte_bit(OpPtr, 5);
end;
procedure TGenCodBas.byte_bit6(const OpPtr: pointer);
begin
  byte_bit(OpPtr, 6);
end;
procedure TGenCodBas.byte_bit7(const OpPtr: pointer);
begin
  byte_bit(OpPtr, 7);
end;
//////////////// Tipo DWord /////////////
procedure TGenCodBas.word_LoadToRT(const OpPtr: pointer; modReturn: boolean);
{Carga el valor de una expresión a los registros de trabajo.}
var
  Op: ^TOperand;
  varPtr: TxpEleVar;
begin
  Op := OpPtr;
  case Op^.Sto of  //el parámetro debe estar en "Op^"
  stConst : begin
    //byte alto
    if Op^.HByte = 0 then begin
      _BANKSEL(H.bank);
      _CLRF(H.offs);
    end else begin
      _MOVLW(Op^.HByte);
      _BANKSEL(H.bank);
      _MOVWF(H.offs);
    end;
    //byte bajo
    if modReturn then _RETLW(Op^.LByte)
    else _MOVLW(Op^.LByte);
  end;
  stVariab: begin
    kMOVF(Op^.rVar.addr1, toW);
    kMOVWF(H.addr);
    kMOVF(Op^.rVar.addr0, toW);
    if modReturn then _RETURN;
  end;
  stExpres: begin  //se asume que ya está en (H,w)
    if modReturn then _RETURN;
  end;
  stVarRef: begin
    //Se tiene una variable puntero dereferenciada: x^
    varPtr := Op^.rVar;  //Guarda referencia a la variable puntero
    //Mueve a W
    kINCF(varPtr.addr0, toW);  //varPtr.offs+1 -> W  (byte alto)
    _MOVWF(FSR.offs);  //direcciona byte alto
    _MOVF(0, toW);  //deje en W
    _BANKSEL(H.bank);
    _MOVWF(H.offs);  //Guarda byte alto
    _DECF(FSR.offs,toF);
    _MOVF(0, toW);  //deje en W byte bajo
    if modReturn then _RETURN;
  end;
  stExpRef: begin
    //Es una expresión desrefernciada (x+a)^.
    {Se asume que el operando tiene su resultado en los RT. Si estuvieran en la pila
    no se aplicaría.}
    //Mueve a W
    _MOVWF(FSR.offs);  //direcciona byte bajo
    _INCF(FSR.offs,toF);  //apunta a byte alto
    _MOVF(0, toW);  //deje en W
    _BANKSEL(H.bank);
    _MOVWF(H.offs);  //Guarda byte alto
    _DECF(FSR.offs,toF);
    _MOVF(0, toW);  //deje en W byte bajo
    if modReturn then _RETURN;
  end;
  else
    //Almacenamiento no implementado
    GenError(MSG_NOT_IMPLEM);
  end;
end;
procedure TGenCodBas.word_DefineRegisters;
begin
  //Aparte de W, solo se requiere H
  AddCallerTo(H);
end;
procedure TGenCodBas.word_SaveToStk;
var
  stk: TPicRegister;
begin
  //guarda W
  stk := GetStkRegisterByte;  //pide memoria
  if stk = nil then exit;
  _BANKSEL(stk.bank);
  _MOVWF(stk.offs);PutComm(TXT_SAVE_W);
  stk.used := true;
  //guarda H
  stk := GetStkRegisterByte;   //pide memoria
  if stk = nil then exit;
  _BANKSEL(H.bank);
  _MOVF(H.offs, toW);PutComm(TXT_SAVE_H);
  _BANKSEL(stk.bank);
  _MOVWF(stk.offs);
  stk.used := true;   //marca
end;
procedure TGenCodBas.word_GetItem(const OpPtr: pointer);
//Función que devuelve el valor indexado
var
  Op: ^TOperand;
  arrVar, tmpVar: TxpEleVar;
  idx: TOperand;
  WithBrack: Boolean;
begin
  if not GetIdxParArray(WithBrack, idx) then exit;
  //Procesa
  Op := OpPtr;
  if Op^.Sto = stVariab then begin  //Se aplica a una variable
    arrVar := Op^.rVar;  //referencia a la variable.
    typWord.DefineRegister;
    //Genera el código de acuerdo al índice
    case idx.Sto of
    stConst: begin  //ïndice constante
      tmpVar := CreateTmpVar('', typWord);
      tmpVar.addr0 := arrVar.addr0+idx.valInt*2;  //¿Y si es de otro banco?
      tmpVar.addr1 := arrVar.addr0+idx.valInt*2+1;  //¿Y si es de otro banco?
      SetResultVariab(tmpVar);
//        SetResultExpres(arrVar.typ.refType, true);  //Es array de word, devuelve word
//        //Como el índice es constante, se puede acceder directamente
//        add0 := arrVar.adrByte0.offs+idx.valInt*2;
//        _MOVF(add0+1, toW);
//        _MOVWF(H.offs);    //byte alto
//        _MOVF(add0, toW);  //byte bajo
      end;
    stVariab: begin
      SetResultExpres(arrVar.typ.itmType, true);  //Es array de word, devuelve word
      _BCF(_STATUS, _C);
      _RLF(idx.offs, toW);      //Multiplica Idx por 2
      _MOVWF(FSR.offs);     //direcciona con FSR
      _MOVLW(arrVar.addr0+1);   //Agrega OFFSET + 1
      _ADDWF(FSR.offs, toF);

      _MOVF(0, toW);  //lee indexado en W
      _MOVWF(H.offs);    //byte alto
      _DECF(FSR.offs, toF);
      _MOVF(0, toW);  //lee indexado en W
    end;
    stExpres: begin
      SetResultExpres(arrVar.typ.itmType, false);  //Es array de word, devuelve word
      _MOVWF(FSR.offs);     //idx a  FSR (usa como varaib. auxiliar)
      _BCF(_STATUS, _C);
      _RLF(FSR.offs, toW);      //Multiplica Idx por 2
      _MOVWF(FSR.offs);     //direcciona con FSR
      _MOVLW(arrVar.addr0+1);   //Agrega OFFSET + 1
      _ADDWF(FSR.offs, toF);

      _MOVF(0, toW);  //lee indexado en W
      _MOVWF(H.offs);    //byte alto
      _DECF(FSR.offs, toF);
      _MOVF(0, toW);  //lee indexado en W
    end;
    end;
  end else begin
    GenError('Syntax error.');
  end;
  if WithBrack then begin
    if not CaptureTok(']') then exit;
  end else begin
    if not CaptureTok(')') then exit;
  end;
end;
procedure TGenCodBas.word_SetItem(const OpPtr: pointer);
//Función que fija un valor indexado
var
  WithBrack: Boolean;
var
  Op: ^TOperand;
  arrVar, rVar: TxpEleVar;
  idx, value: TOperand;
  idxTar: Int64;
  aux: TPicRegister;
begin
  if not GetIdxParArray(WithBrack, idx) then exit;
  //Procesa
  Op := OpPtr;
  if Op^.Sto = stVariab then begin  //Se aplica a una variable
    arrVar := Op^.rVar;  //referencia a la variable.
    res.SetAsNull;  //No devuelve nada
    //Genera el código de acuerdo al índice
    case idx.Sto of
    stConst: begin  //Indice constante
        //Como el índice es constante, se puede acceder directamente
        idxTar := arrVar.adrByte0.offs+idx.valInt*2; //índice destino
        if not GetValueToAssign(WithBrack, arrVar, value) then exit;
        if value.Sto = stConst then begin
          //Es una constante
          //Byte bajo
          if value.LByte=0 then begin //Caso especial
            _CLRF(idxTar);
          end else begin
            _MOVLW(value.LByte);
            _MOVWF(idxTar);
          end;
          //Byte alto
          if value.HByte=0 then begin //Caso especial
            _CLRF(idxTar+1);
          end else begin
            _MOVLW(value.HByte);
            _MOVWF(idxTar+1);
          end;
        end else begin
          //El valor a asignar es variable o expresión
          typWord.DefineRegister;   //Para usar H
          //Sabemos que hay una expresión word
          LoadToRT(value); //Carga resultado en H,W
          _MOVWF(idxTar);  //Byte bajo
          _MOVF(H.offs, toW);
          _MOVWF(idxTar+1);  //Byte alto
        end;
      end;
    stVariab: begin
        //El índice es una variable
        //Tenemos la referencia la variable en idx.rvar
        if not GetValueToAssign(WithBrack, arrVar, value) then exit;
        //Sabemos que hay una expresión word
        if value.Sto = stConst then begin
          //El valor a escribir, es una constante cualquiera
          _BCF(_STATUS, _C);
          _RLF(idx.offs, toW);  //índice * 2
          _MOVWF(FSR.offs);  //Direcciona
          _MOVLW(arrVar.addr0);  //Dirección de inicio
          _ADDWF(FSR.offs, toF);  //Direcciona
          ////// Byte Bajo
          if value.LByte = 0 then begin
            _CLRF($00);
          end else begin
            _MOVLW(value.LByte);
            _MOVWF($00);   //Escribe
          end;
          ////// Byte Alto
          _INCF(FSR.offs, toF);  //Direcciona a byte ALTO
          if value.HByte = 0 then begin
            _CLRF($00);
          end else begin
            _MOVLW(value.HByte);
            _MOVWF($00);   //Escribe
          end;
        end else if value.Sto = stVariab then begin
          //El valor a escribir, es una variable
          //Calcula dirfección de byte bajo
          _BCF(_STATUS, _C);
          _RLF(idx.offs, toW);  //índice * 2
          _MOVWF(FSR.offs);  //Direcciona
          _MOVLW(arrVar.addr0);  //Dirección de inicio
          _ADDWF(FSR.offs, toF);  //Direcciona
          ////// Byte Bajo
          _MOVF(value.Loffs, toW);
          _MOVWF($00);   //Escribe
          ////// Byte Alto
          _INCF(FSR.offs, toF);  //Direcciona a byte ALTO
          _MOVF(value.Hoffs, toW);
          _MOVWF($00);   //Escribe
        end else begin
          //El valor a escribir, es una expresión y está en H,W
          //hay que mover value a arrVar[idx.rvar]
          aux := GetAuxRegisterByte;
          typWord.DefineRegister;   //Para usar H
          _MOVWF(aux.offs);  //W->   salva W (Valor.H)
          //Calcula dirección de byte bajo
          _BCF(_STATUS, _C);
          _RLF(idx.offs, toW);  //índice * 2
          _MOVWF(FSR.offs);  //Direcciona
          _MOVLW(arrVar.addr0);  //Dirección de inicio
          _ADDWF(FSR.offs, toF);  //Direcciona
          ////// Byte Bajo
          _MOVF(aux.offs, toW);
          _MOVWF($00);   //Escribe
          ////// Byte Alto
          _INCF(FSR.offs, toF);  //Direcciona a byte ALTO
          _MOVF(H.offs, toW);
          _MOVWF($00);   //Escribe
          aux.used := false;
        end;
      end;
    stExpres: begin
      //El índice es una expresión y está en W.
      if not GetValueToAssign(WithBrack, arrVar, value) then exit;
      if value.Sto = stConst then begin
        //El valor a asignar, es una constante
        _MOVWF(FSR.offs);   //Salva W.
        _BCF(_STATUS, _C);
        _RLF(FSR.offs, toF);  //idx * 2
        _MOVLW(arrVar.addr0);
        _ADDWF(FSR.offs, toF);  //Direcciona a byte bajo
        //Byte bajo
        if value.LByte = 0 then begin
          _CLRF($00);   //Pone a cero
        end else begin
          _MOVLW(value.LByte);
          _MOVWF($00);
        end;
        //Byte alto
        _INCF(FSR.offs, toF);
        if value.HByte = 0 then begin
          _CLRF($00);   //Pone a cero
        end else begin
          _MOVLW(value.HByte);
          _MOVWF($00);
        end;
      end else if value.Sto = stVariab then begin
        _MOVWF(FSR.offs);   //Salva W.
        _BCF(_STATUS, _C);
        _RLF(FSR.offs, toF);  //idx * 2
        _MOVLW(arrVar.addr0);  //Dirección de inicio
        _ADDWF(FSR.offs, toF);  //Direcciona a byte bajo
        //Byte bajo
        _MOVF(value.Loffs, toW);
        _MOVWF($00);
        //Byte alto
        _INCF(FSR.offs, toF);
        _MOVF(value.Hoffs, toW);
        _MOVWF($00);
      end else begin
        //El valor a asignar está en H,W, y el índice (byte) en la pila
        typWord.DefineRegister;   //Para usar H
        aux := GetAuxRegisterByte;
        _MOVWF(aux.offs);  //W->aux   salva W
        rVar := GetVarByteFromStk;  //toma referencia de la pila
        //Calcula dirección de byte bajo
        _BCF(_STATUS, _C);
        _RLF(rVar.adrByte0.offs, toF);  //índice * 2
        _MOVLW(arrVar.addr0);  //Dirección de inicio
        _ADDWF(FSR.offs, toF);  //Direcciona
        ////// Byte Bajo
        _MOVF(aux.offs, toW);
        _MOVWF($00);   //Escribe
        ////// Byte Alto
        _INCF(FSR.offs, toF);  //Direcciona a byte ALTO
        _MOVF(H.offs, toW);
        _MOVWF($00);   //Escribe
        aux.used := false;
      end;
    end;
    end;
  end else begin
    GenError('Syntax error.');
  end;
  if WithBrack then begin
    //En este modo, no se requiere ")"
  end else begin
    if not CaptureTok(')') then exit;
  end;
end;
procedure TGenCodBas.word_ClearItems(const OpPtr: pointer);
begin

end;
procedure TGenCodBas.word_Low(const OpPtr: pointer);
{Acceso al byte de menor peso de un word.}
var
  xvar, tmpVar: TxpEleVar;
  Op: ^TOperand;
begin
  cIn.Next;  //Toma identificador de campo
  Op := OpPtr;
  case Op^.Sto of
  stVariab: begin
    xvar := Op^.rVar;
    //Se devuelve una variable, byte
    //Crea una variable temporal que representará al campo
    tmpVar := CreateTmpVar(xvar.name+'.L', typByte);   //crea variable temporal
    tmpVar.addr0 :=  xvar.addr0;  //byte bajo
    res.SetAsVariab(tmpVar);
  end;
  stConst: begin
    //Se devuelve una constante bit
    res.SetAsConst(typByte);
    res.valInt := Op^.ValInt and $ff;
  end;
  else
    GenError('Syntax error.');
  end;
end;
procedure TGenCodBas.word_High(const OpPtr: pointer);
{Acceso al byte de mayor peso de un word.}
var
  xvar, tmpVar: TxpEleVar;
  Op: ^TOperand;
begin
  cIn.Next;  //Toma identificador de campo
  Op := OpPtr;
  case Op^.Sto of
  stVariab: begin
    xvar := Op^.rVar;
    //Se devuelve una variable, byte
    //Crea una variable temporal que representará al campo
    tmpVar := CreateTmpVar(xvar.name+'.H', typByte);
    tmpVar.addr0 := xvar.addr1;  //byte alto
    res.SetAsVariab(tmpVar);
  end;
  stConst: begin
    //Se devuelve una constante bit
    res.SetAsConst(typByte);
    res.valInt := (Op^.ValInt and $ff00)>>8;
  end;
  else
    GenError('Syntax error.');
  end;
end;
//////////////// Tipo DWord /////////////
procedure TGenCodBas.dword_LoadToRT(const OpPtr: pointer; modReturn: boolean);
{Carga el valor de una expresión a los registros de trabajo.}
var
  Op: ^TOperand;
begin
  Op := OpPtr;
  case Op^.Sto of  //el parámetro debe estar en "Op^"
  stConst : begin
    //byte U
    if Op^.UByte = 0 then begin
      _BANKSEL(U.bank);
      _CLRF(U.offs);
    end else begin
      _MOVLW(Op^.UByte);
      _BANKSEL(U.bank);
      _MOVWF(U.offs);
    end;
    //byte E
    if Op^.EByte = 0 then begin
      _BANKSEL(E.bank);
      _CLRF(E.offs);
    end else begin
      _MOVLW(Op^.EByte);
      _BANKSEL(E.bank);
      _MOVWF(E.offs);
    end;
    //byte H
    if Op^.HByte = 0 then begin
      _BANKSEL(H.bank);
      _CLRF(H.offs);
    end else begin
      _MOVLW(Op^.HByte);
      _BANKSEL(H.bank);
      _MOVWF(H.offs);
    end;
    //byte 0
    if modReturn then _RETLW(Op^.LByte)
    else _MOVLW(Op^.LByte);
  end;
  stVariab: begin
    kMOVF(Op^.rVar.addr3, toW);
    kMOVWF(U.addr);

    kMOVF(Op^.rVar.addr2, toW);
    kMOVWF(E.addr);

    kMOVF(Op^.rVar.addr1, toW);
    kMOVWF(H.addr);

    kMOVF(Op^.rVar.addr0, toW);
    if modReturn then _RETURN;
  end;
  stExpres: begin  //se asume que ya está en (U,E,H,w)
    if modReturn then _RETURN;
  end;
  else
    //Almacenamiento no implementado
    GenError(MSG_NOT_IMPLEM);
  end;
end;
procedure TGenCodBas.dword_DefineRegisters;
begin
  //Aparte de W, se requieren H, E y U
  AddCallerTo(H);
  AddCallerTo(E);
  AddCallerTo(U);
end;
procedure TGenCodBas.dword_SaveToStk;
var
  stk: TPicRegister;
begin
  //guarda W
  stk := GetStkRegisterByte;  //pide memoria
  if HayError then exit;
  _BANKSEL(stk.bank);
  _MOVWF(stk.offs);PutComm(TXT_SAVE_W);
  stk.used := true;
  //guarda H
  stk := GetStkRegisterByte;   //pide memoria
  if HayError then exit;
  _BANKSEL(H.bank);
  _MOVF(H.offs, toW);PutComm(TXT_SAVE_H);
  _BANKSEL(stk.bank);
  _MOVWF(stk.offs);
  stk.used := true;   //marca
  //guarda E
  stk := GetStkRegisterByte;   //pide memoria
  if HayError then exit;
  _BANKSEL(E.bank);
  _MOVF(E.offs, toW);PutComm(';save E');
  _BANKSEL(stk.bank);
  _MOVWF(stk.offs);
  stk.used := true;   //marca
  //guarda U
  stk := GetStkRegisterByte;   //pide memoria
  if HayError then exit;
  _BANKSEL(U.bank);
  _MOVF(U.offs, toW);PutComm(';save U');
  _BANKSEL(stk.bank);
  _MOVWF(stk.offs);
  stk.used := true;   //marca
end;
procedure TGenCodBas.dword_Low(const OpPtr: pointer);
{Acceso al byte de menor peso de un Dword.}
var
  xvar, tmpVar: TxpEleVar;
  Op: ^TOperand;
begin
  cIn.Next;  //Toma identificador de campo
  Op := OpPtr;
  case Op^.Sto of
  stVariab: begin
    xvar := Op^.rVar;
    //Se devuelve una variable, byte
    //Crea una variable temporal que representará al campo
    tmpVar := CreateTmpVar(xvar.name+'.Low', typByte);   //crea variable temporal
    tmpVar.addr0 := xvar.addr0;  //byte bajo
    res.SetAsVariab(tmpVar);
  end;
  stConst: begin
    //Se devuelve una constante byte
    res.SetAsConst(typByte);
    res.valInt := Op^.ValInt and $ff;
  end;
  else
    GenError('Syntax error.');
  end;
end;
procedure TGenCodBas.dword_High(const OpPtr: pointer);
{Acceso al byte de mayor peso de un Dword.}
var
  xvar, tmpVar: TxpEleVar;
  Op: ^TOperand;
begin
  cIn.Next;  //Toma identificador de campo
  Op := OpPtr;
  case Op^.Sto of
  stVariab: begin
    xvar := Op^.rVar;
    //Se devuelve una variable, byte
    //Crea una variable temporal que representará al campo
    tmpVar := CreateTmpVar(xvar.name+'.High', typByte);
    tmpVar.addr0 := xvar.addr1;  //byte alto
    res.SetAsVariab(tmpVar);
  end;
  stConst: begin
    //Se devuelve una constante bit
    res.SetAsConst(typByte);
    res.valInt := (Op^.ValInt and $ff00)>>8;
  end;
  else
    GenError('Syntax error.');
  end;
end;
procedure TGenCodBas.dword_Extra(const OpPtr: pointer);
{Acceso al byte 2 de un Dword.}
var
  xvar, tmpVar: TxpEleVar;
  Op: ^TOperand;
begin
  cIn.Next;  //Toma identificador de campo
  Op := OpPtr;
  case Op^.Sto of
  stVariab: begin
    xvar := Op^.rVar;
    //Se devuelve una variable, byte
    //Crea una variable temporal que representará al campo
    tmpVar := CreateTmpVar(xvar.name+'.Extra', typByte);
    tmpVar.addr0 := xvar.addr2;  //byte alto
    res.SetAsVariab(tmpVar);
  end;
  stConst: begin
    //Se devuelve una constante bit
    res.SetAsConst(typByte);
    res.valInt := (Op^.ValInt and $ff0000)>>16;
  end;
  else
    GenError('Syntax error.');
  end;
end;
procedure TGenCodBas.dword_Ultra(const OpPtr: pointer);
{Acceso al byte 3 de un Dword.}
var
  xvar, tmpVar: TxpEleVar;
  Op: ^TOperand;
begin
  cIn.Next;  //Toma identificador de campo
  Op := OpPtr;
  case Op^.Sto of
  stVariab: begin
    xvar := Op^.rVar;
    //Se devuelve una variable, byte
    //Crea una variable temporal que representará al campo
    tmpVar := CreateTmpVar(xvar.name+'.Ultra', typByte);
    tmpVar.addr0 := xvar.addr3;  //byte alto
    res.SetAsVariab(tmpVar);
  end;
  stConst: begin
    //Se devuelve una constante bit
    res.SetAsConst(typByte);
    res.valInt := (Op^.ValInt and $ff000000)>>24;
  end;
  else
    GenError('Syntax error.');
  end;
end;
procedure TGenCodBas.dword_LowWord(const OpPtr: pointer);
{Acceso al word de menor peso de un Dword.}
var
  xvar, tmpVar: TxpEleVar;
  Op: ^TOperand;
begin
  cIn.Next;  //Toma identificador de campo
  Op := OpPtr;
  case Op^.Sto of
  stVariab: begin
    xvar := Op^.rVar;
    //Se devuelve una variable, byte
    //Crea una variable temporal que representará al campo
    tmpVar := CreateTmpVar(xvar.name+'.LowW', typWord);   //crea variable temporal
    tmpVar.addr0 := xvar.addr0;  //byte bajo
    tmpVar.addr1 := xvar.addr1;  //byte alto
    res.SetAsVariab(tmpVar);   //actualiza la referencia
  end;
  stConst: begin
    //Se devuelve una constante bit
    res.SetAsConst(typWord);
    res.valInt := Op^.ValInt and $ffff;
  end;
  else
    GenError('Syntax error.');
  end;
end;
procedure TGenCodBas.dword_HighWord(const OpPtr: pointer);
{Acceso al word de mayor peso de un Dword.}
var
  xvar, tmpVar: TxpEleVar;
  Op: ^TOperand;
begin
  cIn.Next;  //Toma identificador de campo
  Op := OpPtr;
  case Op^.Sto of
  stVariab: begin
    xvar := Op^.rVar;
    //Se devuelve una variable, byte
    //Crea una variable temporal que representará al campo
    tmpVar := CreateTmpVar(xvar.name+'.HighW', typWord);   //crea variable temporal
    tmpVar.addr0 := xvar.addr2;  //byte bajo
    tmpVar.addr1 := xvar.addr3;  //byte alto
    res.SetAsVariab(tmpVar);   //actualiza la referencia
  end;
  stConst: begin
    //Se devuelve una constante bit
    res.SetAsConst(typWord);
    res.valInt := (Op^.ValInt and $ffff0000) >> 16;
  end;
  else
    GenError('Syntax error.');
  end;
end;
procedure TGenCodBas.GenCodPicReqStopCodeGen;
{Required Stop the Code generation}
begin
  posFlash := pic.iFlash; //Probably not the best way.
end;
procedure TGenCodBas.GenCodPicReqStartCodeGen;
{Required Start the Code generation}
begin
  pic.iFlash := posFlash; //Probably not the best way.
end;
//Inicialización
procedure TGenCodBas.StartRegs;
{Inicia los registros de trabajo en la lista.}
begin
  listRegAux.Clear;
  listRegStk.Clear;   //limpia la pila
  stackTop := 0;
  listRegAuxBit.Clear;
  listRegStkBit.Clear;   //limpia la pila
  stackTopBit := 0;
end;
function TGenCodBas.CompilerName: string;
begin
  Result := 'PIC10 Compiler'
end;
function TGenCodBas.RAMmax: integer;
begin
  Result := high(pic.ram);
end;
function TGenCodBas.DeviceError: string;
begin
  exit (pic.MsjError);
end;
procedure TGenCodBas.Cod_JumpIfTrue;
{Codifica una instrucción de salto, si es que el resultado de la última expresión es
verdadera. Se debe asegurar que la expresión es de tipo booleana y de almacenamiento
stVariab o stExpres.}
begin
  if res.Sto = stVariab then begin
    //Las variables booleanas, pueden estar invertidas
    if res.Inverted then begin
      _BANKSEL(res.bank);
      _BTFSC(res.offs, res.bit);  //verifica condición
    end else begin
      _BANKSEL(res.bank);
      _BTFSS(res.offs, res.bit);  //verifica condición
    end;
  end else if res.Sto = stExpres then begin
    //Los resultados de expresión, pueden optimizarse
    if InvertedFromC then begin
      //El resultado de la expresión, está en Z, pero a partir una copia negada de C
      //Se optimiza, eliminando las instrucciones de copia de C a Z
      pic.iFlash := pic.iFlash-2;
      //La lógica se invierte
      if res.Inverted then begin //_Lógica invertida
        _BTFSS(C.offs, C.bit);   //verifica condición
      end else begin
        _BTFSC(C.offs, C.bit);   //verifica condición
      end;
    end else begin
      //El resultado de la expresión, está en Z. Caso normal
      if res.Inverted then begin //Lógica invertida
        _BTFSC(Z.offs, Z.bit);   //verifica condición
      end else begin
        _BTFSS(Z.offs, Z.bit);   //verifica condición
      end;
    end;
  end;
end;
procedure TGenCodBas.ClearDeviceError;
begin
  pic.MsjError := '';
end;
function TGenCodBas.CurrFlash(): integer;
begin
  exit(pic.iFlash);
end;
procedure TGenCodBas.ResetFlashAndRAM;
{Reinicia el dispositivo, para empezar a escribir en la posición $000 de la FLASH, y
en la posición inicial de la RAM.}
begin
  pic.iFlash := 0;  //Ubica puntero al inicio.
  pic.ClearMemRAM;  //Pone las celdas como no usadas y elimina nombres.
  CurrBank := 0;
  StartRegs;        //Limpia registros de trabajo, auxiliares, y de pila.
end;

function TGenCodBas.ReturnAttribIn(typ: TxpEleType; const Op: TOperand;
  offs: integer): boolean;
{Return a temp variable at the specified address.}
var
  tmpVar: TxpEleVar;
begin
  if Op.Sto = stVariab then begin
    tmpVar := CreateTmpVar('?', typ);   //Create temporal variable
    tmpVar.addr0 := Op.addr + offs;  //Set Address
    res.SetAsVariab(tmpVar);
    exit(true);
  end else begin
    GenError('Cannot access to field of this expression.');
    exit(false);
  end;
end;
procedure TGenCodBas.SetSharedUnused;
begin
  pic.SetSharedUnused;
end;
procedure TGenCodBas.SetSharedUsed;
begin
  pic.SetSharedUsed;
end;
procedure TGenCodBas.CompileProcBody(fun: TxpEleFun);
{Compila el cuerpo de un procedimiento}
begin
  StartCodeSub(fun);    //Inicia codificación de subrutina
  CompileInstruction;
  if HayError then exit;
  if fun.IsInterrupt then begin
    //Las interrupciones terminan así
    _RETFIE
  end else begin
    //Para los procedimeintos, podemos terminar siempre con un _RETURN u optimizar,
    if OptRetProc then begin
      //Verifica es que ya se ha incluido exit().
      if fun.ObligatoryExit<>nil then begin
        //Ya tiene un exit() obligatorio y en el final (al menos eso se espera)
        //No es necesario incluir el _RETURN().
      end else begin
        //No hay un exit(), seguro
        _RETLW(0);  //instrucción de salida
      end;
    end else begin
      _RETLW(0);  //instrucción de salida
    end;
  end;
  EndCodeSub;  //termina codificación
  {Fija banco al terminar de codificar. Si no se modificó el banco en la compilación
  (como en un procedimiento vacío) CurrBank, contiene el banco que se fijó antes de
  llamar a CompileProcBody(), que es:
    Siemrpe 0 -> en la primera pasada.
    Un valor calculado -> en la segund pasada.}
  fun.finBnk := CurrBank;  //Banco al terminar de codificar
  //Calcula tamaño
  fun.srcSize := pic.iFlash - fun.adrr;
end;
procedure TGenCodBas.StartCodeSub(fun: TxpEleFun);
{debe ser llamado para iniciar la codificación de una subrutina}
begin
//  iFlashTmp :=  pic.iFlash; //guarda puntero
//  pic.iFlash := curBloSub;  //empieza a codificar aquí
end;
procedure TGenCodBas.EndCodeSub;
{debe ser llamado al terminar la codificaión de una subrutina}
begin
//  curBloSub := pic.iFlash;  //indica siguiente posición libre
//  pic.iFlash := iFlashTmp;  //retorna puntero
end;
procedure TGenCodBas.FunctParam(fun: TxpEleFunBase);
{Rutina genérica, que se usa antes de leer los parámetros de una función.}
begin
  {Haya o no, parámetros se debe proceder como en cualquier expresión, asumiendo que
  vamos a devolver una expresión.}
  SetResultExpres(fun.typ);  //actualiza "RTstate"
end;
procedure TGenCodBas.FunctCall(fun: TxpEleFunBase; out AddrUndef: boolean);
{Rutina genérica para llamar a una función definida por el usuario.}
var
  xfun: TxpEleFun;
  fundec: TxpEleFunDec;
begin
  AddrUndef := false;
  if fun.idClass = eltFunc then begin
    //Is a implemented function
    xfun := TxpEleFun(fun);
    //By now is not implemented the paging
    _CALL(xfun.adrr);  //codifica el salto
    if OptBnkAftPro then begin  //Bank change optimization
      //Se debe optimizar, fijando el banco que deja la función
      CurrBank := xfun.ExitBank;
    end else begin
      //Se debe incluir siempre instrucciones de cambio de banco
      _BANKRESET;
    end;
  end else begin
    //Must be a declaration
    fundec := TxpEleFunDec(fun);
    if fundec.implem <> nil then begin
      //Is implemented
      _CALL(fundec.implem.adrr);
      if OptBnkAftPro then begin  //Bank change optimization
        //Se debe optimizar, fijando el banco que deja la función
        CurrBank := fundec.implem.ExitBank;
      end else begin
        //Se debe incluir siempre instrucciones de cambio de banco
        _BANKRESET;
      end;
    end else begin
      //Not implemented YET
      _CALL($1234);  //Needs to be completed later.
      AddrUndef := true;
    end;
  end;
end;
procedure TGenCodBas.CompileIF;
{Compila una extructura IF}
  procedure SetFinalBank(bnk1, bnk2: byte);
  {Fija el valor de CurrBank, de acuerdo a dos bancos finales.}
  begin
    if OptBnkAftIF then begin
      //Optimizar banking
      if bnk1 = bnk2 then begin
        //Es el mismo banco (aunque sea 255). Lo deja allí.
      end else begin
        CurrBank := 255;  //Indefinido
      end;
    end else begin
      //Sin optimización
      _BANKRESET;
    end;
  end;
var
  jFALSE, jEND_TRUE: integer;
  bnkExp, bnkTHEN, bnkELSE: Byte;
begin
  if not GetExpressionBool then exit;
  bnkExp := CurrBank;   //Guarda el banco inicial
  if not CaptureStr('then') then exit; //toma "then"
  //Aquí debe estar el cuerpo del "if"
  case res.Sto of
  stConst: begin  //la condición es fija
    if res.valBool then begin
      //Es verdadero, siempre se ejecuta
      if not CompileNoConditionBody(true) then exit;
      //Compila los ELSIF que pudieran haber
      while cIn.tokL = 'elsif' do begin
        cIn.Next;   //toma "elsif"
        if not GetExpressionBool then exit;
        if not CaptureStr('then') then exit;  //toma "then"
        //Compila el cuerpo pero sin código
        if not CompileNoConditionBody(false) then exit;
      end;
      //Compila el ELSE final, si existe.
      if cIn.tokL = 'else' then begin
        //Hay bloque ELSE, pero no se ejecutará nunca
        cIn.Next;   //toma "else"
        if not CompileNoConditionBody(false) then exit;
        if not VerifyEND then exit;
      end else begin
        VerifyEND;
      end;
    end else begin
      //Es falso, nunca se ejecuta
      if not CompileNoConditionBody(false) then exit;
      if cIn.tokL = 'else' then begin
        //hay bloque ELSE, que sí se ejecutará
        cIn.Next;   //toma "else"
        if not CompileNoConditionBody(true) then exit;
        VerifyEND;
      end else if cIn.tokL = 'elsif' then begin
        cIn.Next;
        CompileIF;  //más fácil es la forma recursiva
        if HayError then exit;
        //No es necesario verificar el END final.
      end else begin
        VerifyEND;
      end;
    end;
  end;
  stVariab, stExpres:begin
    Cod_JumpIfTrue;
    _GOTO_PEND(jFALSE);  //salto pendiente
    //Compila la parte THEN
    if not CompileConditionalBody(bnkTHEN) then exit;
    //Verifica si sigue el ELSE
    if cIn.tokL = 'else' then begin
      //Es: IF ... THEN ... ELSE ... END
      cIn.Next;   //toma "else"
      _GOTO_PEND(jEND_TRUE);  //llega por aquí si es TRUE
      _LABEL(jFALSE);   //termina de codificar el salto
      CurrBank := bnkExp;  //Fija el banco inicial antes de compilar
      if not CompileConditionalBody(bnkELSE) then exit;
      _LABEL(jEND_TRUE);   //termina de codificar el salto
      SetFinalBank(bnkTHEN, bnkELSE);  //Manejo de bancos
      VerifyEND;   //puede salir con error
    end else if cIn.tokL = 'elsif' then begin
      //Es: IF ... THEN ... ELSIF ...
      cIn.Next;
      _GOTO_PEND(jEND_TRUE);  //llega por aquí si es TRUE
      _LABEL(jFALSE);   //termina de codificar el salto
      CompileIF;  //más fácil es la forma recursiva
      if HayError then exit;
      _LABEL(jEND_TRUE);   //termina de codificar el salto
      SetFinalBank(bnkTHEN, CurrBank);  //Manejo de bancos
      //No es necesario verificar el END final.
    end else begin
      //Es: IF ... THEN ... END. (Puede ser recursivo)
      _LABEL(jFALSE);   //termina de codificar el salto
      SetFinalBank(bnkExp, bnkTHEN);  //Manejo de bancos
      VerifyEND;  //puede salir con error
    end;
  end;
  end;
end;
procedure TGenCodBas.CompileREPEAT;
{Compila uan extructura WHILE}
var
  l1: Word;
begin
  l1 := _PC;        //guarda dirección de inicio
  CompileCurBlock;
  if HayError then exit;
  cIn.SkipWhites;
  if not CaptureStr('until') then exit; //toma "until"
  if not GetExpressionBool then exit;
  case res.Sto of
  stConst: begin  //la condición es fija
    if res.valBool then begin
      //lazo nulo
    end else begin
      //lazo infinito
      _GOTO(l1);
    end;
  end;
  stVariab, stExpres: begin
    Cod_JumpIfTrue;
    _GOTO(l1);
    //sale cuando la condición es verdadera
  end;
  end;
end;
procedure TGenCodBas.CompileWHILE;
{Compila una extructura WHILE}
var
  l1: Word;
  dg: Integer;
  bnkEND, bnkExp1, bnkExp2: byte;
begin
  l1 := _PC;        //guarda dirección de inicio
  bnkExp1 := CurrBank;   //Guarda el banco antes de la expresión
  if not GetExpressionBool then exit;  //Condición
  bnkExp2 := CurrBank;   //Guarda el banco antes de la expresión
  if not CaptureStr('do') then exit;  //toma "do"
  //Aquí debe estar el cuerpo del "while"
  case res.Sto of
  stConst: begin  //la condición es fija
    if res.valBool then begin
      //Lazo infinito
      if not CompileNoConditionBody(true) then exit;
      if not VerifyEND then exit;
      _BANKSEL(bnkExp1);   //asegura que el lazo se ejecutará en el mismo banco de origen
      _GOTO(l1);
    end else begin
      //Lazo nulo. Compila sin generar código.
      if not CompileNoConditionBody(false) then exit;
      if not VerifyEND then exit;
    end;
  end;
  stVariab, stExpres: begin
    Cod_JumpIfTrue;
    _GOTO_PEND(dg);  //salto pendiente
    if not CompileConditionalBody(bnkEND) then exit;
    _BANKSEL(bnkExp1);   //asegura que el lazo se ejecutará en el mismo banco de origen
    _GOTO(l1);   //salta a evaluar la condición
    if not VerifyEND then exit;
    //ya se tiene el destino del salto
    _LABEL(dg);   //termina de codificar el salto
  end;
  end;
  CurrBank := bnkExp2;  //Este es el banco con que se sale del WHILE
end;
procedure TGenCodBas.CompileFOR;
{Compila uan extructura WHILE}
var
  l1: Word;
  dg: Integer;
  Op1, Op2: TOperand;
  opr1: TxpOperator;
  bnkFOR: byte;
begin
  GetOperand(Op1, true);
  if Op1.Sto <> stVariab then begin
    GenError(ER_VARIAB_EXPEC);
    exit;
  end;
  if HayError then exit;
  if (Op1.Typ<>typByte) and (Op1.Typ<>typWord) then begin
    GenError(ER_ONL_BYT_WORD);
    exit;
  end;
  cIn.SkipWhites;
  opr1 := GetOperator(Op1);   //debe ser ":="
  if opr1 = nil then begin  //no sigue operador
    GenError(ER_ASIG_EXPECT);
    exit;  //termina ejecucion
  end;
  if opr1.txt <> ':=' then begin
    GenError(ER_ASIG_EXPECT);
    exit;
  end;
  Op2 := GetExpression(0);
  if HayError then exit;
  //Ya se tiene la asignación inicial
  Oper(Op1, opr1, res);   //codifica asignación
  if HayError then exit;
  if not CaptureStr('to') then exit;
  //Toma expresión Final
  res := GetExpression(0);
  if HayError then exit;
  cIn.SkipWhites;
  if not CaptureStr('do') then exit;  //toma "do"
  //Aquí debe estar el cuerpo del "for"
  if (res.Sto = stConst) or (res.Sto = stVariab) then begin
    //Es un for con valor final de tipo constante
    //Se podría optimizar, si el valor inicial es también constante
    l1 := _PC;        //guarda dirección de inicio
    //Codifica rutina de comparación, para salir
    opr1 := Op1.Typ.FindBinaryOperator('<=');  //Busca operador de comparación
    if opr1 = nullOper then begin
      GenError('Internal: No operator <= defined for %s.', [Op1.Typ.name]);
      exit;
    end;
    Op2 := res;   //Copia porque la operación Oper() modificará res
    Oper(Op1, opr1, Op2);   //"res" mantiene la constante o variable
    Cod_JumpIfTrue;
    _GOTO_PEND(dg);  //salto pendiente
    if not CompileConditionalBody(bnkFOR) then exit;
    if not VerifyEND then exit;
    //Incrementa variable cursor
    if Op1.Typ = typByte then begin
      _INCF(Op1.offs, toF);
    end else if Op1.Typ = typWord then begin
      _BANKSEL(oP1.bank);
      _INCF(Op1.Loffs, toF);
      _BTFSC(_STATUS, _Z);
      _INCF(Op1.Hoffs, toF);
    end;
    _GOTO(l1);  //repite el lazo
    //ya se tiene el destino del salto
    _LABEL(dg);   //termina de codificar el salto
  end else begin
    GenError('Last value must be Constant or Variable');
    exit;
  end;
end;
constructor TGenCodBas.Create;
begin
  inherited Create;
  ID := 10;  //Identifica al compilador PIC10
  devicesPath := patDevices10;
  OnReqStartCodeGen:=@GenCodPicReqStartCodeGen;
  OnReqStopCodeGen:=@GenCodPicReqStopCodeGen;
  pic := TPIC10.Create;
  picCore := pic;   //Referencia picCore

  //Crea variables de trabajo
  varStkBit  := TxpEleVar.Create;
  varStkBit.typ := typBit;
  varStkByte := TxpEleVar.Create;
  varStkByte.typ := typByte;
  varStkWord := TxpEleVar.Create;
  varStkWord.typ := typWord;
  varStkDWord := TxpEleVar.Create;
  varStkDWord.typ := typDWord;
  //Crea lista de variables temporales
  varFields    := TxpEleVars.Create(true);
  //Inicializa contenedores
  listRegAux   := TPicRegister_list.Create(true);
  listRegStk   := TPicRegister_list.Create(true);
  listRegAuxBit:= TPicRegisterBit_list.Create(true);
  listRegStkBit:= TPicRegisterBit_list.Create(true);
  stackTop     := 0;  //Apunta a la siguiente posición libre
  stackTopBit  := 0;  //Apunta a la siguiente posición libre
  {Crea registro de trabajo W. El registro W, es el registro interno del PIC, y no
  necesita un mapeo en RAM. Solo se le crea aquí, para poder usar su propiedad "used"}
  W := TPicRegister.Create;
  W.assigned := false;   //se le marca así, para que no se intente usar
  {Crea registro de trabajo Z. El registro Z, es el registro interno del PIC, y está
  siempre asignado en RAM. }
  Z := TPicRegisterBit.Create;
  Z.addr := _STATUS;
  Z.bit := _Z;
  Z.assigned := true;   //ya está asignado desde el principio
  {Crea registro de trabajo C. El registro C, es el registro interno del PIC, y está
  siempre asignado en RAM. }
  C := TPicRegisterBit.Create;
  C.addr := _STATUS;
  C.bit := _C;
  C.assigned := true;   //ya está asignado desde el principio
  //Crea registro interno INDF
  INDF := TPicRegister.Create;
  INDF.addr := $00;
  INDF.assigned := true;   //ya está asignado desde el principio
  {Crea registro auxiliar FSR. El registro FSR, es un registro interno del PIC, y está
  siempre asignado en RAM. }
  FSR := TPicRegister.Create;
  FSR.addr := $04;
  FSR.assigned := true;   //ya está asignado desde el principio

  callCurrFlash       := @CurrFlash;
  callResetFlashAndRAM:=@ResetFlashAndRAM;
  callCreateVarInRAM   := @CreateVarInRAM;
  callSetSharedUnused := @SetSharedUnused;
  callSetSharedUsed   := @SetSharedUsed;
  callReturnAttribIn := @ReturnAttribIn;
  callDeviceError      := @DeviceError;
  callClearDeviceError := @ClearDeviceError;
  callCompileProcBody := @CompileProcBody;
  callFunctParam      := @FunctParam;
  callFunctCall       := @FunctCall;
  callStartCodeSub    := @StartCodeSub;
  callEndCodeSub      := @EndCodeSub;

  callCompileIF        := @CompileIF;;
  callCompileWHILE     := @CompileWHILE;
  callCompileREPEAT    := @CompileREPEAT;
  callCompileFOR       := @CompileFOR;
end;
destructor TGenCodBas.Destroy;
begin
  INDF.Destroy;
  FSR.Destroy;
  C.Destroy;
  Z.Destroy;
  W.Destroy;
  listRegAuxBit.Destroy;
  listRegStkBit.Destroy;
  listRegStk.Destroy;
  listRegAux.Destroy;
  varFields.Destroy;
  varStkBit.Destroy;
  varStkByte.Destroy;
  varStkWord.Destroy;
  varStkDWord.Destroy;
  pic.Destroy;
  inherited Destroy;
end;

end.

