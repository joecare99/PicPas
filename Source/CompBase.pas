{Parser

Esta sería la versión de XpresParser (definida en el framework t-Xpres), orientada
a trabajar con microcontroladores PIC.
La idea es tener aquí todas las rutinas que en lo posible sean independientes del
lenguaje y del modelo de PIC.
Para mayor información sobre el uso del framework Xpres, consultar la documentación
técnica.
}
//{$Define LogExpres}
unit CompBase;
interface
uses
  Classes, SysUtils, Types, Forms, LCLType, lclProc, SynFacilHighlighter,
  SynEditHighlighter, XpresBas, XpresTypesPIC, XpresElementsPIC, CompOperands,
  MisUtils, FormConfig, PicCore, Globales;
const
  TIT_BODY_ELE = 'Body';
type
//Tipo de expresión, de acuerdo a la posición en que aparece
TPosExpres = (pexINDEP,  //Expresión independiente
              pexASIG,   //Expresión de asignación
              pexPROC,   //Expresión de procedimiento
              pexSTRUC,  //Expresión de estructura
              pexPARAM,  //Expresión de parámetro de función
              pexPARSY   //Expresión de parámetro de función de sistema
              );
TOperType = (operUnary,  //Operación Unaria
             operBinary  //Operación Binaria
             );

{ TCompilerBase }
{Clase base para crear a los objetos compiladores.
Esta clase debe ser el ancestro común de todos los compialdores a usar en PicPas.
Contiene métodos abstractos que deben ser impleemntados en las clases descendeintes.}
TCompilerBase = class(TCompOperands)
protected  //Variables de expresión.
  {Estas variables, se inician al inicio de cada expresión y su valor es válido
  hasta el final de la expresión.}
  CurrBank  : Byte;    //Banco RAM actual
  //Variables de estado de las expresiones booleanas
  InvertedFromC: boolean; {Indica que el resultado de una expresión Booleana o Bit, se
                           ha obtenido, en la última subexpresion, copaindo el bit C al
                           bit Z, con inversión lógica. Se usa para opciones de
                           optimziación de código.}
protected
  procedure getListOfIdent(out itemList: TStringDynArray; out
    srcPosArray: TSrcPosArray);
  procedure IdentifyField(xOperand: TOperand);
  procedure LogExpLevel(txt: string);
  function IsTheSameBitVar(var1, var2: TxpEleVar): boolean; inline;
  function AddCallerTo(elem: TxpElement): TxpEleCaller;
  function AddCallerTo(elem: TxpElement; callerElem: TxpElement): TxpEleCaller;
  function AddCallerTo(elem: TxpElement; const curPos: TSrcPos): TxpEleCaller;
protected
  ExprLevel  : Integer;  //Nivel de anidamiento de la rutina de evaluación de expresiones
  RTstate    : TxpEleType;    {Estado de los RT. Si es NIL, indica que los RT, no tienen
                         ningún dato cargado, sino indican el tipo cargado en los RT.}
  function CaptureDelExpres: boolean;
  procedure ProcComments; virtual; abstract;
  procedure TipDefecNumber(var Op: TOperand; toknum: string); virtual; abstract;
  procedure TipDefecString(var Op: TOperand; tokcad: string); virtual; abstract;
  procedure TipDefecBoolean(var Op: TOperand; tokcad: string); virtual; abstract;
  function EOExpres: boolean;
  function EOBlock: boolean;
  //Manejo de tipos
  procedure ClearTypes;
  function CreateSysType(nom0: string; cat0: TTypeGroup; siz0: smallint
    ): TxpEleType;
  function FindSysEleType(TypName: string): TxpEleType;
  //Manejo de constantes
  function CreateCons(consName: string; eletyp: TxpEleType): TxpEleCon;
  function CreateVar(varName: string; eleTyp: TxpEleType): TxpEleVar;
  function CreateEleType(typName: string): TxpEleType;
  function CreateFunction(funName: string; typ: TxpEleType; procParam,
    procCall: TProcExecFunction): TxpEleFun;
  function ValidateFunction: boolean;
  function CreateSysFunction(funName: string; procParam,
    procCall: TProcExecFunction): TxpEleFun;
  function AddVariable(varName: string; eleTyp: TxpEleType; srcPos: TSrcPos
    ): TxpEleVar;
//  function AddConstant(conName: string; eleTyp: TxpEleType; srcPos: TSrcPos
//    ): TxpEleCon;
  function AddType(typName: string; srcPos: TSrcPos): TxpEleType;

  procedure CaptureParamsFinal(fun: TxpEleFun);
  function CaptureTok(tok: string): boolean;
  function CaptureStr(str: string): boolean;
  procedure CaptureParams(func0: TxpEleFun);
  //Manejo del cuerpo del programa
  function CreateBody: TxpEleBody;
  //Manejo de Unidades
  function CreateUnit(uniName: string): TxpEleUnit;
  //Manejo de expresiones
  procedure GetOperandIdent(var Op: TOperand);
  function GetOperand: TOperand; virtual;
  function GetOperandPrec(pre: integer): TOperand;
  function GetOperator(const Op: Toperand): TxpOperator;
  procedure GetExpressionE(const prec: Integer; posExpres: TPosExpres = pexINDEP);
public  //Containers
  TreeElems  : TXpTreeElements; //Árbol de sintaxis del lenguaje
  TreeDirec  : TXpTreeElements; //Árbol de sinatxis para directivas
  listFunSys : TxpEleFuns;   //lista de funciones del sistema
  listTypSys : TxpEleTypes;  //lista de tipos del sistema
protected  //Eventos del compilador
  {This is the way the Parser can communicate with the Code Generator, considering this
  unit is independent of Code Generation.}
  OnExprStart: procedure of object;  {Se genera al iniciar la
                                      evaluación de una expresión.}
  OnExprEnd  : procedure(posExpres: TPosExpres) of object;  {Se genera al terminar de
                                                               evaluar una expresión.}
  OnReqStopCodeGen: procedure of object;   //Required stop the Code Generation
  OnReqStartCodeGen: procedure of object;  //Required start the Code Generation
protected //Calls to Code Generator
  {These are routines that must be implemented in Code-generator.}
  //Implement code-generator routines to implemet Arrays.
  CodDefineArray : procedure(etyp: TxpEleType) of object;
  //Implement code-generator routines to implemet Pointers.
  CodDefinePointer : procedure(etyp: TxpEleType) of object;
  //Validate phisycal address
  CodValidRAMaddr : procedure(addr: integer) of object;
  //Create vars
  CodCreateVarInRAM: procedure(xVar: TxpEleVar; shared: boolean = false) of object;
  //Load to register
  procedure LoadToRT(Op: TOperand; modReturn: boolean = false);
  function GetExpression(const prec: Integer): TOperand;
  //LLamadas a las rutinas de operación
  procedure Oper(var Op1: TOperand; opr: TxpOperator; var Op2: TOperand);
  procedure OperPre(var Op1: TOperand; opr: TxpOperator);
  procedure OperPost(var Op1: TOperand; opr: TxpOperator);
public   //Tipos de datos a implementar
  {No es obligatorio implementar todos los tipos de datos, para todos los compiladoreslo }
  typBit  : TxpEleType;
  typBool : TxpEleType;
  typByte : TxpEleType;
  typChar : TxpEleType;
  typWord : TxpEleType;
  typDWord: TxpEleType;
public
  ID       : integer;     //Identificador para el compilador.
  Compiling: boolean;     //Bandera para el compilado
  FirstPass: boolean;     //Indica que está en la primera pasada.
  xLex     : TSynFacilSyn; //Resaltador - lexer
  CompiledUnit: boolean;  //Flag to identify a Unit
  //Variables públicas del compilador
  ejecProg : boolean;     //Indica que se está ejecutando un programa o compilando
  DetEjec  : boolean;     //Para detener la ejecución (en intérpretes)

  procedure Compile(NombArc: string; Link: boolean); virtual; abstract;
public    //Compiling Options
  incDetComm  : boolean; //Incluir Comentarios detallados.
  ConfigWord  : integer; //Bits de configuración
  mode        : (modPascal, modPicPas);
  SetProIniBnk: boolean; //Incluir instrucciones de cambio de banco al inicio de procedimientos
  OptBnkAftPro: boolean; //Incluir instrucciones de cambio de banco al final de procedimientos
  OptBnkAftIF : boolean; //Optimizar instrucciones de cambio de banco al final de IF
  OptReuProVar: boolean; //Optimiza reutilizando variables locales de procedimientos
  OptRetProc  : boolean; //Optimiza el último exit de los procedimeintos.
protected
  mainFile    : string;    //Archivo inicial que se compila
  hexFile     : string;    //Nombre de archivo de salida
  function ExpandRelPathTo(BaseFile, FileName: string): string;
public    //Información y acceso a memoria
  function hexFilePath: string;
  function mainFilePath: string;
  function CompilerName: string; virtual; abstract;  //Name of the compiler
  procedure RAMusage(lins: TStrings; varDecType: TVarDecType; ExcUnused: boolean); virtual; abstract;
  function RAMusedStr: string; virtual; abstract;
  function FLASHusedStr: string; virtual; abstract;
  procedure GetResourcesUsed(out ramUse, romUse, stkUse: single); virtual; abstract;
  procedure DumpCode(lins: TSTrings; incAdrr, incCom, incVarNam: boolean); virtual; abstract;
  procedure GenerateListReport(lins: TStrings); virtual; abstract;
public    //Acceso a campos del objeto PIC
  function PICName: string; virtual; abstract;
  function PICNameShort: string; virtual; abstract;
  function PICnBanks: byte; virtual; abstract; //Number of RAM banks
  function PICCurBank: byte; virtual; abstract; //Current RAM bank
  function PICBank(i: byte): TPICRAMBank; virtual; abstract; //Return a RAM bank
  function PICnPages: byte; virtual; abstract; //Number of FLASH pages
  function PICPage(i: byte): TPICFlashPage; virtual; abstract; //Return a FLASH page
  function RAMmax: integer; virtual; abstract;
protected //Container lists of registers
  listRegAux : TPicRegister_list;  //lista de registros de trabajo y auxiliares
  listRegStk : TPicRegister_list;  //lista de registros de pila
  listRegAuxBit: TPicRegisterBit_list;  //lista de registros de trabajo y auxiliares
  listRegStkBit: TPicRegisterBit_list;
  stackTop   : integer;   //índice al límite superior de la pila
  stackTopBit: integer;   //índice al límite superior de la pila
public
  picCore    : TPicCore;       //Objeto PIC Core
  devicesPath: string; //Ruta de las unidades de dispositivos
  property ProplistRegAux: TPicRegister_list read listRegAux;
  property ProplistRegAuxBit: TPicRegisterBit_list read listRegAuxBit;
protected
  procedure RefreshAllElementLists;
  procedure RemoveUnusedFunc;
  procedure RemoveUnusedVars;
  procedure RemoveUnusedCons;
  procedure RemoveUnusedTypes;
  procedure UpdateCallersToUnits;
public    //Inicialización
  constructor Create; virtual;
  destructor Destroy; override;
end;

implementation
uses Graphics;
var
  ER_NOT_IMPLEM_ , ER_IDEN_EXPECT, ER_DUPLIC_IDEN , ER_UNDEF_TYPE_, ER_IDE_TYP_EXP,
  ER_SEMIC_EXPEC , ER_STR_EXPECTED, ER_TYP_PARM_ER_,
  ER_UNKNOWN_IDE_, ER_IN_EXPRESSI , ER_OPERAN_EXPEC,
  ER_ILLEG_OPERA_, ER_UND_OPER_TY_, ER_CAN_AP_OPER_,
  ER_IN_CHARACTER, ER_INV_COD_CHAR, ER_ONLY_ONE_REG  : string;

procedure SetLanguage;
begin
  {$I ..\language\tra_CompBase.pas}
end;
{TCompilerBase}
function TCompilerBase.EOExpres: boolean; inline;
//Indica si se ha llegado al final de una expresión.
begin
  Result := cIn.tok = ';';  //en este caso de ejemplo, usamos punto y coma
  {En la práctica, puede ser conveniente definir un tipo de token como "tkExpDelim", para
   mejorar el tiempo de respuesta del procesamiento, de modo que la condición sería:
     Result := cIn.tokType = tkExpDelim;
  }
end;
function TCompilerBase.EOBlock: boolean; inline;
//Indica si se ha llegado el final de un bloque
begin
  Result := cIn.tokType = tnBlkDelim;
  {No está implementado aquí, pero en la práctica puede ser conveniente definir un tipo de token
   como "tnBlkDelim", para mejorar el tiempo de respuesta del procesamiento, de modo que la
   condición sería:
  Result := cIn.tokType = tnBlkDelim;}
end;
function TCompilerBase.CaptureDelExpres: boolean;
//Verifica si sigue un delimitador de expresión. Si encuentra devuelve false.
begin
  cIn.SkipWhites;
  if EOExpres then begin //encontró
    cIn.Next;   //pasa al siguiente
    exit(true);
  end else begin   //es un error
    GenError('";" expected.');
    exit(false);  //sale con error
  end;

end;
//Manejo de tipos
procedure TCompilerBase.ClearTypes;  //Limpia los tipos del sistema
begin
  listTypSys.Clear;
end;
function TCompilerBase.CreateSysType(nom0: string; cat0: TTypeGroup; siz0: smallint): TxpEleType;
{Crea un elemento tipo, del sistema. Devuelve referencia al tipo creado.}
var
  eType: TxpEleType;
begin
  //Verifica nombre
  if FindSysEleType(nom0) <> nil then begin
    GenError('Duplicated identifier: "%s"', [nom0]);
    exit(nil);  //Devuelve tipo nulo
  end;
  //Crea elemento de tipo
  eType := TxpEleType.Create;
  eType.name := nom0;
  eType.grp := cat0;
  eType.size := siz0;
  eType.catType := tctAtomic;
  listTypSys.Add(eType);
  //Devuelve referencia al tipo
  Result:=eType;
end;
function TCompilerBase.FindSysEleType(TypName: string): TxpEleType;
{Busca un elemento de tipo por su nombre. Si no encuentra, devuelve NIL.}
var
  etyp: TxpEleType;
begin
  typName := upcase(typName);
  for etyp in listTypSys do begin
    if UpCase(etyp.name) = typName then exit(etyp);  //devuelve referencia
  end;
  exit(nil);
end;
function TCompilerBase.CreateCons(consName: string; eletyp: TxpEleType): TxpEleCon;
{Rutina para crear una constante. Devuelve referencia a la constante creada.}
var
  conx  : TxpEleCon;
begin
  //registra variable en la tabla
  conx := TxpEleCon.Create;
  conx.name:=consName;
  conx.typ := eletyp;   //fija  referencia a tipo
  Result := conx;
end;
//Manejo de variables
function TCompilerBase.CreateVar(varName: string; eleTyp: TxpEleType): TxpEleVar;
{Rutina para crear una variable. Devuelve referencia a la variable creada.}
var
  xVar: TxpEleVar;
begin
  xVar := TxpEleVar.Create;
  xVar.name := varName;
  xVar.typ := eleTyp;
  xVar.adicPar.hasAdic := decNone;
  xVar.adicPar.hasInit := false;
  Result := xVar;
end;
//Manejo de tipos
function TCompilerBase.CreateEleType(typName: string): TxpEleType;
var
  xTyp: TxpEleType;
begin
  xTyp := TxpEleType.Create;
  xTyp.name := typName;
//  xTyp.typ := typ;
  Result := xTyp;
end;
//Manejo de funciones
function TCompilerBase.CreateFunction(funName: string; typ: TxpEleType;
  procParam, procCall: TProcExecFunction): TxpEleFun;
{Crea una nueva función y devuelve la referecnia a la función.}
var
  fun : TxpEleFun;
begin
  fun := TxpEleFun.Create;
  fun.name:= funName;
  fun.typ := typ;
  fun.procParam := procParam;
  fun.procCall:= procCall;
  fun.ClearParams;
  Result := fun;
end;
function TCompilerBase.ValidateFunction: boolean;
{Valida la última función introducida, verificando que no haya otra función con el
 mismo nombre y mismos parámetros. De ser así devuelve FALSE.
 Se debe llamar después de haber leido los parámetros de la función. }
begin
  if not TreeElems.ValidateCurElement then begin
    GenError('Duplicated function: %s',[TreeElems.CurNodeName]);
    exit(false);
  end;
  exit(true);  //validación sin error
end;
function TCompilerBase.CreateSysFunction(funName: string;
  procParam, procCall: TProcExecFunction): TxpEleFun;
{Crea una función del sistema. A diferencia de las funciones definidas por el usuario,
una función del sistema se crea, sin crear espacios de nombre. La idea es poder
crearlas rápidamente. "procParam", solo es necesario, cuando la función del sistema
debe devolver valores (No es procedimiento).}
var
  fun : TxpEleFun;
begin
  fun := TxpEleFun.Create;  //Se crea como una función normal
  fun.name:= funName;
  fun.typ := typNull;
  fun.procParam := procParam;
  fun.procCall:= procCall;
  fun.ClearParams;
  listFunSys.Add(fun);  //Las funciones de sistema son accesibles siempre
  Result := fun;
end;
function TCompilerBase.AddVariable(varName: string; eleTyp: TxpEleType; srcPos: TSrcPos
  ): TxpEleVar;
{Crea un elemento variable y lo agrega en el nodo actual del árbol de sintaxis.
Si no hay errores, devuelve la referencia a la variable. En caso contrario,
devuelve NIL.
Notar que este método, no asigna RAM a la variable. En una creación completa de
variables, se debería llamar a CreateVarInRAM(), después de agregar la variable.}
var
  xvar: TxpEleVar;
begin
  //Inicia parámetros adicionales de declaración
  xvar := CreateVar(varName, eleTyp);
  xvar.srcDec := srcPos;  //Actualiza posición
  Result := xvar;
  if not TreeElems.AddElement(xvar) then begin
    GenErrorPos(ER_DUPLIC_IDEN, [xvar.name], xvar.srcDec);
    xvar.Destroy;   //Hay una variable creada
    exit(nil);
  end;
end;
//function TCompilerBase.AddConstant(conName: string; eleTyp: TxpEleType; srcPos: TSrcPos
//  ): TxpEleCon;
//{Crea un elemento constante y lo agrega en el nodo actual del árbol de sintaxis.
//Si no hay errores, devuelve la referencia a la variable. En caso contrario,
//devuelve NIL. }
//var
//  xcons: TxpEleCon;
//begin
//  xcons := CreateCons(conName, eleTyp);
//  xcons.srcDec := srcPos;
//  if xcons.ExistsIn(TreeElems.curNode.elements) then begin
//    GenErrorPos(ER_DUPLIC_IDEN, [xcons.name], xcons.srcDec);
//    xcons.Destroy;   //hay una constante creada
//    exit;
//  end;
//  TreeElems.AddElement(xcons);
//  Result := xcons;
//end;
function TCompilerBase.AddType(typName: string; srcPos: TSrcPos): TxpEleType;
{Crea un elemento tipo y lo agrega en el nodo actual del árbol de sintaxis.
Si no hay errores, devuelve la referencia al tipo. En caso contrario,
devuelve NIL.}
var
  xtyp: TxpEleType;
begin
  //Inicia parámetros adicionales de declaración
  xtyp := CreateEleType(typName);
  xtyp.srcDec := srcPos;  //Actualiza posición
  Result := xtyp;
  if not TreeElems.AddElement(xtyp) then begin
    GenErrorPos(ER_DUPLIC_IDEN, [xtyp.name], xtyp.srcDec);
    xtyp.Destroy;   //Hay una variable creada
    exit(nil);
  end;
end;

function TCompilerBase.CaptureTok(tok: string): boolean;
{Toma el token indicado del contexto de entrada. Si no lo encuentra, genera error y
devuelve FALSE.}
  procedure GenErrorInLastLine(var p: TSrcPos);
  {Genera error posicionando el punto del error, en una línea anterior, que no esté
  vacía.}
  var
    lin: String;
  begin
    if p.row>1 then begin
      //Hay línea anterior
      repeat
        p.row := p.row - 1;
        lin := cIn.curCon.curLines[p.row - 1];
      until (p.row<=1) or (trim(lin)<>'');
      //Encontró línea anterior no nula o llegó a la primera línea.
//      xlex.ExploreLine(Point(length(lin), p.row), toks, CurTok );
      p.col := length(lin);   //mueve al final (antes del EOL)
      GenErrorPos('"%s" expected.', [tok], p);  //Genera error
    end else begin
      //No hay línea anterior
      p.col := 1;   //mueve al inicio
      GenErrorPos('"%s" expected.', [tok], p);  //Genera error
    end;
  end;

var
  x: integer;
  lin: String;
  p: TSrcPos;
begin
  //Debe haber parámetros
  if cIn.tok<>tok then begin
    //No se encontró el token. Muestra mensaje de error.
    {Pero el error, debe estar antes, así que hacemos la magia de explorar hacia atrás,
    hasta encontrar el token involucrado.}
    p := cIn.ReadSrcPos;   //posición actual
    x := p.col;   //lee posición actual
    if x>1 then begin
      //Hay algo antes del token
      lin := cIn.curCon.CurLine;
      repeat
        dec(x);
      until (x<=1) or (lin[x] <> ' ');
      if x<=1 then begin
        //Está lleno de espacios, hasta el inicio.
        //Es muy probable que el error esté en la línea anterior.
        GenErrorInLastLine(p);
      end else begin
        //Encontró, en la misma línea un caracter diferente de espacio
        GenErrorPos('"%s" expected.', [tok], p);  //Genera error ahí mismo
      end;
    end else begin
      //Está al inicio de la línea. El error debe estar antes
      GenErrorInLastLine(p);
    end;
    exit(false);
  end;
  cin.Next;
  exit(true);
end;
function TCompilerBase.CaptureStr(str: string): boolean;
//Similar a CaptureTok(), pero para cadenas. Se debe dar el texto en minúscula.
begin
  //Debe haber parámetros
  if cIn.tokL<>str then begin
    GenError('"%s" expected.', [str]);
    exit(false);
  end;
  cin.Next;
  exit(true);
end;
procedure TCompilerBase.CaptureParams(func0: TxpEleFun);
//Lee los parámetros de una función en la función interna funcs[0]
begin
  //func0.ClearParams;
  if EOBlock or EOExpres then begin
    //no tiene parámetros
  end else begin
    //Debe haber parámetros
    if cIn.tok <> '(' then begin
      //Si no sigue '(', significa que no hay parámetros.
      exit;
    end;
    cIn.Next;  //Toma paréntesis
    repeat
      GetExpressionE(0, pexPARAM);  //captura parámetro
      if HayError then exit;   //aborta
      //guarda tipo de parámetro
      func0.CreateParam('',res.Typ, nil);
      if cIn.tok = ',' then begin
        cIn.Next;   //toma separador
        cIn.SkipWhites;
      end else begin
        //No sigue separador de parámetros,
        //debe terminar la lista de parámetros
        //¿Verificar EOBlock or EOExpres ?
        break;
      end;
    until false;
    //busca paréntesis final
    if not CaptureTok(')') then exit;
  end;
end;
procedure TCompilerBase.CaptureParamsFinal(fun: TxpEleFun);
{Captura los parámetros asignándolos a las variables de la función que representan a los
parámetros. No hace falta verificar, no debería dar error, porque ya se verificó con
CaptureParams. }
var
  i: Integer;
  par: TxpParFunc;
  Op1, Op2: TOperand;
  op: TxpOperator;
begin
  if EOBlock or EOExpres then exit;  //sin parámetros
  CaptureTok('(');   //No debe dar error porque ya se verificó
  for i := 0 to high(fun.pars) do begin
    par := fun.pars[i];
    {Ya sirvió "RTstate", ahora lo limpiamos, no vaya a pasar que las rutinas de
    asignación, piensen que los RT están ocupados, cuando la verdad es que han sido
    liberados, precisamente para ellas.}
    RTstate := nil;
    //Evalúa parámetro
    Inc(ExprLevel);    //cuenta el anidamiento
    Op2 := GetExpression(0);  //llama como sub-expresión
    Dec(ExprLevel);
    if HayError then exit;   //aborta
    if cIn.tok = ',' then begin
      cIn.Next;
      cIn.SkipWhites;
    end;
    //Genera código para la asignación
    if par.pvar.IsRegister then begin
      {Cuando es parámetro registro, no se asigna, se deja en el registro(s) de
       trabajo.}
      LoadToRT(Op2);
    end else begin
      //Crea un operando-variable para generar código de asignación
      Op1.SetAsVariab(par.pvar); //Apunta a la variable
      AddCallerTo(par.pvar);  //Agrega la llamada
      op := Op1.Typ.operAsign;
      Oper(Op1, op, Op2);   //Codifica la asignación
    end;
  end;
  if not CaptureTok(')') then exit;
end;
function TCompilerBase.CreateBody: TxpEleBody;
var
  body: TxpEleBody;
begin
  body := TxpEleBody.Create;
  body.name := TIT_BODY_ELE;
  Result := body;
end;
function TCompilerBase.CreateUnit(uniName: string): TxpEleUnit;
var
  uni: TxpEleUnit;
begin
  uni := TxpEleUnit.Create;
  uni.name := uniName;
  Result := uni;
end;
procedure TCompilerBase.getListOfIdent(out itemList: TStringDynArray; out
  srcPosArray: TSrcPosArray);
{Lee una lista de identificadores separados por comas, hasta encontra un caracter distinto
de coma. Si el primer elemento no es un identificador o si después de la coma no sigue un
identificador, genera error.
También devuelve una lista de las posiciones de los identificadores, en el código fuente.}
const
  BLOCK_SIZE = 10;  //Tamaño de bloque de memoria inicial
var
  item: String;
  n, curSize: Integer;
begin
  //Se empieza con un tamaño inicial para evitar muchas llamadas a setlength()
  curSize := BLOCK_SIZE;    //Tamaño inicial de bloque
  setlength(itemList   , curSize);  //Tamaño inicial
  setlength(srcPosArray, curSize);  //Tamaño inicial
  n := 0;
  repeat
    ProcComments;
    //ahora debe haber un identificador
    if cIn.tokType <> tnIdentif then begin
      GenError(ER_IDEN_EXPECT);
      exit;
    end;
    //hay un identificador
    item := cIn.tok;
    itemList[n] := item;  //agrega nombre
    srcPosArray[n] := cIn.ReadSrcPos;  //agrega ubicación de declaración
    cIn.Next;  //Toma identificador despues, de guardar ubicación
    ProcComments;
    if cIn.tok <> ',' then break; //sale
    cIn.Next;  //Toma la coma
    //Hay otro ítem, verifica límite de arreglo
    inc(n);
    if n >= curSize then begin
      curSize += BLOCK_SIZE;   //Incrementa tamaño en bloque
      setlength(itemList   , curSize);  //hace espacio
      setlength(srcPosArray, curSize);  //hace espacio
    end;
  until false;
  //Define el tamaño final.
  setlength(itemList   , n+1);
  setlength(srcPosArray, n+1);
end;
procedure TCompilerBase.IdentifyField(xOperand: TOperand);
{Identifica el campo de una variable. Si encuentra algún problema genera error.
Notar que el parámetro es por valor, es decir, se crea una copia, por seguridad.
Puede generar código de evaluación. Devuelve el resultado en "res". }
var
  field: TTypField;
  identif: String;
begin
  if cIn.tok = '[' then begin
    //Caso especial de llamada a Item().
    for field in xOperand.Typ.fields do begin
      if LowerCase(field.Name) = 'item' then begin
        field.proc(@xOperand);  //Devuelve resultado en "res"
        if cIn.tok = '.' then begin
          //Aún hay más campos, seguimos procesando
          //Como "IdentifyField", crea una copia del parámetro, no hay cruce con el resultado
          IdentifyField(res);
        end;
        exit;
      end;
    end;
    //No encontró setitem()
    GenError('Cannot access to index in: %s', [xOperand.txt]);
    exit;
  end;
  cIn.Next;    //Toma el "."
  if (cIn.tokType<>tnIdentif) and (cIn.tokType<>tnNumber) then begin
    GenError('Identifier expected.');
    cIn.Next;    //Pasa siempre
    exit;
  end;
  //Hay un identificador
  identif :=  cIn.tokL;
  //Prueba con campos del tipo
  for field in xOperand.Typ.fields do begin
    if LowerCase(field.Name) = identif then begin
      //Encontró el campo
      field.proc(@xOperand);  //Devuelve resultado en "res"
      //cIn.Next;    //Coge identificador
      if cIn.tok = '.' then begin
        //Aún hay más campos, seguimos procesando
        //Como "IdentifyField", crea una copia del parámetro, no hay cruce con el resultado
        IdentifyField(res);
      end;
      exit;
    end;
  end;
  //No encontró
  GenError('Unknown identifier: %s', [identif]);
end;
//Manejo de expresiones
procedure TCompilerBase.GetOperandIdent(var Op: TOperand);
{Lee un operando de tipo identificador, devuelve en "Op". Esta rutina era inicialmente
parte de GetOperand(), pero se separó porque:
* Es una rutina larga y se piensa agregar más código, aún.
* Porque se piensa usarla también, de forma independiente.
Se declara como procedimiento, en lugar de función, para evitar crear copias del
operando y mejorar así el desempeño. Incluso se espera que GetOperand(), se declare
luego de la misma forma.}
var
  ele     : TxpElement;
  xvar    : TxpEleVar;
  xcon    : TxpEleCon;
  posCall : TSrcPos;
  posPar  : TPosCont;
  RTstate0: TxpEleType;
  xfun    : TxpEleFun;
  Found   : Boolean;
  func0   : TxpEleFun;   //función interna para almacenar parámetros
begin
//cIn.ShowCurContInformat;
//debugln(' ++CurNode:' + TreeElems.curNode.Path);
  ele := TreeElems.FindFirst(cIn.tok);  //identifica elemento
  if ele = nil then begin
    //No identifica a este elemento
    GenError('Unknown identifier: %s', [cIn.tok]);
    exit;
  end;
//debugln(' --Element ' + cIn.tok + ':' + ele.Path);
  if ele.idClass = eltVar then begin
    //Es una variable
    xvar := TxpEleVar(ele);    //Referencia con tipo
    //Lleva la cuenta de la llamada.
    {Notar que se agrega la referencia a la variable, pero que finalmente el operando
    puede apuntar a otra variable, si es que se tiene la forma: <variable>.<campo> }
    AddCallerTo(xvar);
    cIn.Next;    //Pasa al siguiente
    if xvar.IsRegister then begin
      //Es una variables REGISTER
      Op.SetAsExpres(xvar.typ);
      //Faltaría asegurarse de que los registros estén disponibles
      Op.DefineRegister;
    end else begin
      //Es una variable común
      Op.SetAsVariab(xvar);   //Guarda referencia a la variable (y actualiza el tipo).
      {$IFDEF LogExpres} Op.txt:= xvar.name; {$ENDIF}   //toma el texto
      //Verifica si tiene referencia a campos con "."
      if (cIn.tok = '.') or (cIn.tok = '[') then begin
        IdentifyField(Op);
        Op := res;  //notar que se usa "res".
        if HayError then exit;
        {Como este operando es de tipo <variable>.<algo>... , actualizamos el campo
        "rVarBase", y se hace al final porque los métodos Op.SetAsXXXX() }
        Op.rVarBase := xvar;    //Fija referencia a la variable base
      end;
    end;
  end else if ele.idClass = eltCons then begin  //es constante
    //es una constante
    xcon := TxpEleCon(ele);
    AddCallerTo(xcon);//lleva la cuenta
    cIn.Next;    //Pasa al siguiente
    Op.SetAsConst(xcon.typ); //fija como constante
    Op.GetConsValFrom(xcon);  //lee valor
    {$IFDEF LogExpres} Op.txt:= xcon.name; {$ENDIF}   //toma el texto
    //Verifica si tiene referencia a campos con "."
    if (cIn.tok = '.') or (cIn.tok = '[') then begin
      IdentifyField(Op);
      Op := res;  //notar que se usa "res".
      if HayError then exit;;
    end;
  end else if ele.idClass = eltFunc then begin  //es función
    {Se sabe que es función, pero no se tiene la función exacta porque puede haber
     versiones, sobrecargadas de la misma función.}
    posCall := cIn.ReadSrcPos;   //gaurda la posición de llamada.
    cIn.Next;    //Toma identificador
    cIn.SkipWhites;  //Quita posibles blancos
    posPar := cIn.PosAct;   //Guarda porque va a pasar otra vez por aquí
    OnReqStopCodeGen();
    RTstate0 := RTstate;    //Guarda porque se va a alterar con CaptureParams().
    {Crea func0 localmente, para permitir la recursividad en las llamadas a las funciones.
    Adicionalmenet, deberái plantearse otor método en la exploración de parámetros, tal
    vez la creeación de un árbol de funciones sobrecargdas. Y así se podría incluso
    implementar más fácilmente la adpatación de parámetros como byte->word.}
    try
      func0 := TxpEleFun.Create;  //crea la función 0, para uso interno
      CaptureParams(func0);  //primero lee parámetros
      if HayError then begin
        exit;
      end;
      //Aquí se identifica la función exacta, que coincida con sus parámetros
      xfun := TxpEleFun(ele);
      //Primero vemos si la primera función encontrada, coincide:
      if func0.SameParamsType(xfun.pars) then begin
        //Coincide
        Found := true;
      end else begin
        //No es, es una pena. Ahora tenemos que seguir buscando en el árbol de sintaxis.
        repeat
          //Usar FindNextFunc, es la forma es eficiente, porque retoma la búsqueda anterior.
          xfun := TreeElems.FindNextFunc;
        until (xfun = nil) or func0.SameParamsType(xfun.pars);
        Found := (xfun <> nil);
      end;
      if Found then begin
        //Ya se identificó a la función que cuadra con los parámetros
        {$IFDEF LogExpres} Op.txt:= cIn.tok; {$ENDIF}   //toma el texto
        {Ahora que ya sabe cúal es la función referenciada, captura de nuevo los
        parámetros, pero asignándola al parámetro que corresponde.}
        cIn.PosAct := posPar;
        OnReqStartCodeGen();
        RTstate := RTstate0;
        xfun.procParam(xfun);  //Antes de leer los parámetros
        if high(func0.pars)+1>0 then
          CaptureParamsFinal(xfun);  //evalúa y asigna
        //Se hace después de leer parámetros, para tener información del banco.
        AddCallerTo(xfun, posCall);  {Corrige posición de llamada, sino estaría apuntando
                                      al final de los parámetros}
        xfun.procCall(xfun); //codifica el "CALL"
        RTstate := xfun.typ;  //para indicar que los RT están ocupados
        Op.SetAsExpres(xfun.typ);
        exit;
      end else begin
        //Encontró la función, pero no coincidió con los parámetros
        GenError('Type parameters error on %s', [ele.name + '()']);
        exit;
      end;
    finally
      func0.Destroy;
    end;
//  end else if DefinedMacro(cIn.tok) then begin  //verifica macro
//    //Es una macro
  end else begin
    GenError('Not implemented.');
    exit;
  end;
end;
function TCompilerBase.GetOperand: TOperand;
{Parte de la funcion analizadora de expresiones que genera codigo para leer un operando.
Debe devolver el tipo del operando y también el valor. En algunos casos, puede modificar
"res".}
var
  xfun  : TxpEleFun;
  tmp, oprTxt: String;
  Op    : TOperand;
  posAct: TPosCont;
  opr   : TxpOperator;
  cod   : Longint;
begin
  //cIn.SkipWhites;
  ProcComments;
  Result.Inverted := false;   //inicia campo
  if cIn.tokType = tnNumber then begin  //constantes numéricas
    {$IFDEF LogExpres} Result.txt:= cIn.tok; {$ENDIF}   //toma el texto
    TipDefecNumber(Result, cIn.tok); //encuentra tipo de número, tamaño y valor
    if HayError then exit;  //verifica
    cIn.Next;    //Pasa al siguiente
  end else if cIn.tokType = tnChar then begin  //constante caracter
    {$IFDEF LogExpres} Result.txt:= cIn.tok; {$ENDIF}   //toma el texto
    if not TryStrToInt(copy(cIn.tok, 2), cod) then begin
      GenError('Error in character.');   //tal vez, sea muy grande
      exit;
    end;
    if (cod<0) or (cod>255) then begin
      GenError('Invalid code for char.');
      exit;
    end;
    Result.SetAsConst(typChar);
    Result.valInt := cod;
    cIn.Next;    //Pasa al siguiente
  end else if cIn.tokType = tnString then begin  //constante cadena
    if length(cIn.tok)<=2 then begin  //Es ' o ''
      GenError('Char expected.');
      exit;
    end else if length(cIn.tok)>3 then begin  //Es 'aaaa...'
      GenError('Too long string for a Char.');
      exit;
    end;
    {$IFDEF LogExpres} Result.txt:= cIn.tok; {$ENDIF}   //toma el texto
    Result.SetAsConst(typChar);
    Result.valInt := ord(cIn.tok[2]);
    cIn.Next;    //Pasa al siguiente
  end else if (cIn.tokType = tnSysFunct) or //función del sistema
              (cIn.tokL = 'bit') or    //"bit" es de tipo "tnType"
              (cIn.tokL = 'boolean') or //"boolean" es de tipo "tnType"
              (cIn.tokL = 'byte') or    //"byte" es de tipo "tnType"
              (cIn.tokL = 'word') or    //"word" es de tipo "tnType"
              (cIn.tokL = 'dword') then begin  //"dword" es de tipo "tnType"
    {Se sabe que es función, pero no se tiene la función exacta porque puede haber
     versiones, sobrecargadas de la misma función.}
    tmp := UpCase(cIn.tok);  //guarda nombre de función
    cIn.Next;    //Toma identificador
    //Busca la función
    for xfun in listFunSys do begin
      if (Upcase(xfun.name) = tmp) then begin
        {Encontró. Llama a la función de procesamiento, quien se encargará de
        extraer los parámetros y analizar la sintaxis.}
        if xfun.compile<>nil then begin
          {LLeva la cuenta de llamadas, solo cuando hay subrutinas. Para funciones
           INLINE, no vale la pena, gastar recursos.}
          AddCallerTo(xfun);
        end;
        xfun.procCall(xfun);  //Para que devuelva el tipo y codifique el _CALL o lo implemente
        //Puede devolver typNull, si no es una función.
        Result := res;  //copia tipo, almacenamiento y otros campos relevantes
        {$IFDEF LogExpres} Result.txt:= tmp; {$ENDIF}    //toma el texto
        exit;
      end;
    end;
    GenError('Not implemented.');
  end else if cIn.tokType = tnIdentif then begin  //puede ser variable, constante, función
    GetOperandIdent(Result);
    //Puede salir con error.
  end else if cIn.tokType = tnBoolean then begin  //true o false
    {$IFDEF LogExpres} Result.txt:= cIn.tok; {$ENDIF}   //toma el texto
    TipDefecBoolean(Result, cIn.tok); //encuentra tipo y valor
    if HayError then exit;  //verifica
    cIn.Next;    //Pasa al siguiente
  end else if cIn.tok = '(' then begin  //"("
    cIn.Next;
    Inc(ExprLevel);  //cuenta el anidamiento
    Result := GetExpression(0);
    Dec(ExprLevel);
    if HayError then exit;
    If cIn.tok = ')' Then begin
       cIn.Next;  //lo toma
        if (cIn.tok = '.') or (cIn.tok = '[') then begin
         IdentifyField(Result);
         Result := res;  //notar que se usa "res".
         if HayError then exit;;
       end;
    end Else begin
       GenError('Error in expression. ")" expected.');
       Exit;       //error
    end;
{  end else if (cIn.tokType = tkString) then begin  //constante cadena
    Result.Sto:=stConst;     //constante es Mono Operando
    TipDefecString(Result, cIn.tok); //encuentra tipo de número, tamaño y valor
    if pErr.HayError then exit;  //verifica
    if Result.typ = nil then begin
       GenError('No hay tipo definido para albergar a esta constante cadena');
       exit;
     end;
    cIn.Next;    //Pasa al siguiente
}
  end else if cIn.tokType = tnOperator then begin
    {Si sigue un operador puede ser un operador Unario.
    El problema que tenemos, es que no sabemos de antemano el tipo, para saber si el
    operador aplica a ese tipo como operador Unario Pre. Así que asumiremos que es así,
    sino retrocedemos.}
    posAct := cIn.PosAct;   //Esto puede ser pesado en términos de CPU
    oprTxt := cIn.tok;   //guarda el operador
    cIn.Next; //pasa al siguiente
    Op := GetOperand();   //toma el operando. ¡¡¡Importante los peréntesis!!!
    if HayError then exit;
    //Ahora ya tenemos el tipo. Hay que ver si corresponde el operador
    opr := Op.Typ.FindUnaryPreOperator(oprTxt);
    if opr = nullOper then begin
      {Este tipo no permite este operador Unario (a lo mejor ni es unario)}
      cIn.PosAct := posAct;
      GenError('Cannot apply the operator "%s" to type "%s"', [oprTxt, Op.Typ.name]);
      exit;
    end;
    //Sí corresponde. Así que apliquémoslo
    OperPre(Op, opr);
    Result := res;
  end else begin
    //No se reconoce el operador
    GenError('Operand expected.');
  end;
end;
procedure TCompilerBase.LogExpLevel(txt: string);
{Genera una cadena de registro , considerando el valor de "ExprLevel"}
begin
  debugln(space(3*ExprLevel)+ txt );
end;
function TCompilerBase.IsTheSameBitVar(var1, var2: TxpEleVar): boolean; inline;
{Indica si dos variables bit son la misma, es decir que apuntan, a la misma dirección
física}
begin
  Result := (var1.addr0 = var2.addr0) and (var1.bit0 = var2.bit0);
end;
function TCompilerBase.AddCallerTo(elem: TxpElement): TxpEleCaller;
{Agregar una llamada a un elemento de la sintaxis.
Para el elemento llamador, se usa el nodo actual, que debería ser la función/cuerpo
desde donde se hace la llamada.
Devuelve la referencia al elemento llamador, cuando es efectiva la agregación, de otra
forma devuelve NIL.}
var
  fc: TxpEleCaller;
begin
  if not FirstPass then begin
    //Solo se agregan llamadas en la primera pasada
    Result := nil;
    exit;
  end;
  fc := TxpEleCaller.Create;
  //Carga información del estado actual del parser
  fc.caller := TreeElems.curNode;
  fc.curBnk := CurrBank;
  fc.curPos := cIn.ReadSrcPos;
  elem.lstCallers.Add(fc);
  Result := fc;
end;
function TCompilerBase.AddCallerTo(elem: TxpElement; callerElem: TxpElement): TxpEleCaller;
{El elemento llamador es "callerElem". Agrega información sobre el elemento "llamador", es decir, el elemento que hace
referencia a este elemento.}
begin
  Result := AddCallerTo(elem);
  if Result = nil then exit;
  Result.caller := callerElem;
end;
function TCompilerBase.AddCallerTo(elem: TxpElement; const curPos: TSrcPos): TxpEleCaller;
{Versión de AddCallerTo() que agrega además la posición de la llamada, en lugar de usar
la posición actual.}
begin
  Result := AddCallerTo(elem);
  if Result = nil then exit;
  Result.curPos := curPos;  //Corrige posición de llamada
end;
procedure TCompilerBase.Oper(var Op1: TOperand; opr: TxpOperator; var Op2: TOperand);
{Ejecuta una operación con dos operandos y un operador. "opr" es el operador de Op1.
El resultado debe devolverse en "res". En el caso de intérpretes, importa el
resultado de la Operación.
En el caso de compiladores, lo más importante es el tipo del resultado, pero puede
usarse también "res" para cálculo de expresiones constantes.
}
var
  Operation: TxpOperation;
  tmp: String;
begin
   {$IFDEF LogExpres}
   LogExpLevel('-- Op1='+Op1.txt+', Op2='+Op2.txt+' --');
   {$ENDIF}
   //Busca si hay una operación definida para: <tipo de Op1>-opr-<tipo de Op2>
//debugln('Op1: cat=%s, typ=%s',[Op1.StoOpStr, Op1.Typ.name]);
//debugln('Op2: cat=%s, typ=%s',[Op2.StoOpStr, Op2.Typ.name]);
   Operation := opr.FindOperation(Op2.Typ);
   if Operation = nil then begin
      tmp := '(' + Op1.Typ.name + ') '+ opr.txt;
      tmp := tmp +  ' ('+Op2.Typ.name+')';
      GenError('Illegal Operation: %s',
               [tmp]);
      exit;
    end;
   {Llama al evento asociado con p1 y p2 como operandos. }
   p1 := @Op1; p2 := @Op2;  { Se usan punteros por velocidad. De otra forma habría que
                             copiar todo el objeto.}
   {Ejecuta la operación.
   Los parámetros de entrada se dejan en p1 y p2. El resultado debe dejarse en "res"}
   Operation.proc(Operation, true);  //Llama normalmente
   //Completa campos de "res", si es necesario
   {$IFDEF LogExpres}
   LogExpLevel('Oper('+Op1.catOpChr + ' ' + opr.txt + ' ' + Op2.catOpChr+') -> ' +
                res.catOpChr);
   res.txt := Op1.txt + ' ' + opr.txt + ' ' + Op2.txt;   //texto de la expresión
   {$ENDIF}
End;
procedure TCompilerBase.OperPre(var Op1: TOperand; opr: TxpOperator);
{Ejecuta una operación con un operando y un operador unario de tipo Pre. "opr" es el
operador de Op1.
El resultado debe devolverse en "res".}
begin
  {$IFDEF LogExpres}
  LogExpLevel('-- Op1='+Op1.txt+' --');
  {$ENDIF}
   if opr.OperationPre = nil then begin
      GenError('Illegal Operation: %s',
                 [opr.txt + '('+Op1.Typ.name+')']);
      exit;
    end;
   {Llama al evento asociado con p1 como operando. }
   p1 := @Op1; {Solo hay un parámetro}
   {Ejecuta la operación. El resultado debe dejarse en "res"}
   opr.OperationPre(opr, true);  //Llama normalmente
   //Completa campos de "res", si es necesario
   {$IFDEF LogExpres}
   LogExpLevel('Oper('+ opr.txt + ' ' + Op1.catOpChr+ ') -> ' + res.catOpChr);
   res.txt := opr.txt + Op1.txt;
   {$ENDIF}
end;
procedure TCompilerBase.OperPost(var Op1: TOperand; opr: TxpOperator);
{Ejecuta una operación con un operando y un operador unario de tipo Post. "opr" es el
operador de Op1.
El resultado debe devolverse en "res".}
begin
  {$IFDEF LogExpres}
  LogExpLevel('-- Op1='+Op1.txt+' --');
  {$ENDIF}
   if opr.OperationPost = nil then begin
      GenError('Illegal Operation: %s',
                 ['('+Op1.Typ.name+')' + opr.txt]);
      exit;
    end;
   {Llama al evento asociado con p1 como operando. }
   p1 := @Op1; {Solo hay un parámetro}
   {Ejecuta la operación. El resultado debe dejarse en "res"}
   opr.OperationPost(opr, true);  //Llama normalmente
   //Completa campos de "res", si es necesario
   {$IFDEF LogExpres}
   LogExpLevel('Oper('+Op1.catOpChr+ ' ' +opr.txt +') -> ' + res.catOpChr);
   res.txt := Op1.txt + opr.txt;   //indica que es expresión
   {$ENDIF}
end;
function TCompilerBase.GetOperandPrec(pre: integer): TOperand;
//Toma un operando realizando hasta encontrar un operador de precedencia igual o menor
//a la indicada
var
  Op1: TOperand;
  Op2: TOperand;
  opr: TxpOperator;
  pos: TPosCont;
begin
  {$IFDEF LogExpres}
//  LogExpLevel('GetOperandP('+IntToStr(pre)+')');
  {$ENDIF}
  Op1 :=  GetOperand;  //toma el operador
  if HayError then exit;
  //verifica si termina la expresion
  pos := cIn.PosAct;    //Guarda por si lo necesita
  cIn.SkipWhites;
  opr := GetOperator(Op1);
  if opr = nil then begin  //no sigue operador
    Result:=Op1;
  end else if opr=nullOper then begin  //hay operador pero, ..
    //no está definido el operador siguente para el Op1, (no se puede comparar las
    //precedencias) asumimos que aquí termina el operando.
    cIn.PosAct := pos;   //antes de coger el operador
    GenError('Undefined operator: %s for type: %s', [opr.txt, Op1.Typ.name]);
    exit;
//    Result:=Op1;
  end else begin  //si está definido el operador (opr) para Op1, vemos precedencias
    If opr.prec > pre Then begin  //¿Delimitado por precedencia de operador?
      //es de mayor precedencia, se debe Oper antes.
      Op2 := GetOperandPrec(pre);  //toma el siguiente operando (puede ser recursivo)
      if HayError then exit;
      Oper(Op1, opr, Op2);  //devuelve en "res"
      Result:=res;
    End else begin  //la precedencia es menor o igual, debe salir
      cIn.PosAct := pos;   //antes de coger el operador
      Result:=Op1;
    end;
  end;
end;
function TCompilerBase.GetOperator(const Op: Toperand): TxpOperator;
{Busca la referencia a un operador de "Op", leyendo del contexto de entrada
Si no encuentra un operador en el contexto, devuelve NIL, pero no lo toma.
Si el operador encontrado no se aplica al operando, devuelve nullOper.}
begin
  if cIn.tokType <> tnOperator then exit(nil);
  //Hay un operador
  Result := Op.Typ.FindBinaryOperator(cIn.tok);
  if Result = nullOper then begin
    //No lo encontró, puede ser oeprador unario
    Result := Op.Typ.FindUnaryPostOperator(cIn.tok);
  end;
  cIn.Next;   //toma el token
end;
function TCompilerBase.GetExpression(const prec: Integer): TOperand; //inline;
{Analizador de expresiones. Esta es probablemente la función más importante del
 compilador. Procesa una expresión en el contexto de entrada llama a los eventos
 configurados para que la expresión se evalúe (intérpretes) o se compile (compiladores).
 Devuelve un operando con información sobre el resultado de la expresión.}
var
  Op1, Op2  : TOperand;   //Operandos
  opr1: TxpOperator;  //Operadores
  p: TPosCont;
begin
  //----------------coger primer operando------------------
  Op1 := GetOperand;
  if HayError then exit;
  //Verifica si termina la expresion
  cIn.SkipWhites;
  p := cIn.PosAct;  //por si necesita volver
  opr1 := GetOperator(Op1);
  if opr1 = nil then begin  //no sigue operador
    //Expresión de un solo operando. Lo carga por si se necesita
    //Oper(Op1);
    Result:=Op1;
    exit;  //termina ejecucion
  end;
  //------- sigue un operador ---------
  //verifica si el operador aplica al operando
  if opr1 = nullOper then begin
    GenError('Undefined operator: %s for type: %s', [opr1.txt, Op1.Typ.name]);
    exit;
  end;
  //inicia secuencia de lectura: <Operador> <Operando>
  while opr1<>nil do begin
    //¿Delimitada por precedencia?
    If opr1.prec<= prec Then begin  //es menor que la que sigue, expres.
      Result := Op1;  //solo devuelve el único operando que leyó
      cIn.PosAct := p;  //vuelve
      exit;
    End;
    if opr1.OperationPost<>nil then begin  //Verifica si es operación Unaria
      OperPost(Op1, opr1);
      if HayError then exit;
      Op1 := res;
      cIn.SkipWhites;
      //Verificación
      if (cIn.tok = '.') or (cIn.tok = '[') then begin
        IdentifyField(Op1);
        if HayError then exit;;
        Op1 := res;  //notar que se usa "res".
        cIn.SkipWhites;
      end;
      p := cIn.PosAct;  //actualiza por si necesita volver
      //Verifica operador
      opr1 := GetOperator(Op1);
      continue;
    end;
    //--------------------coger segundo operando--------------------
//    Op2 := GetOperandPrec(Opr1.prec);   //toma operando con precedencia
    Op2 := GetExpression(Opr1.prec);   //toma operando con precedencia
    if HayError then exit;
    //prepara siguiente operación
    Oper(Op1, opr1, Op2);    //evalua resultado en "res"
    Op1 := res;
    if HayError then exit;
    cIn.SkipWhites;
    opr1 := GetOperator(Op1);   {lo toma ahora con el tipo de la evaluación Op1 (opr1) Op2
                                porque puede que Op1 (opr1) Op2, haya cambiado de tipo}
  end;  //hasta que ya no siga un operador
  Result := Op1;  //aquí debe haber quedado el resultado
end;
procedure TCompilerBase.GetExpressionE(const prec: Integer;
  posExpres: TPosExpres);
{Se usa para compilar expresiones completas, no subexpresiones.
Toma una expresión del contexto de entrada y devuelve el resultado em "res".
"isParam" indica que la expresión evaluada es el parámetro de una función.}
begin
  Inc(ExprLevel);  //cuenta el anidamiento
  {$IFDEF LogExpres} LogExpLevel('>Inic.expr'); {$ENDIF}
  if OnExprStart<>nil then OnExprStart;  //llama a evento
  res := GetExpression(prec);
  if HayError then exit;
  if OnExprEnd<>nil then OnExprEnd(posExpres);    //llama al evento de salida
  {$IFDEF LogExpres} LogExpLevel('>Fin.expr'); {$ENDIF}
  Dec(ExprLevel);
  {$IFDEF LogExpres}
  if ExprLevel = 0 then debugln('');
  {$ENDIF}
end;
procedure TCompilerBase.LoadToRT(Op: TOperand; modReturn: boolean = false);
{Carga un operando a los Registros de Trabajo (RT).
El parámetrto "modReturn", indica que se quiere generar un RETURN, dejando en ls RT
el valor de la expresión.}
begin
  if Op.Typ.OnLoadToRT=nil then begin
    //No implementado
    GenError('Not implemented.');
  end else begin
    Op.Typ.OnLoadToRT(@Op, modReturn);
  end;
end;

function TCompilerBase.ExpandRelPathTo(BaseFile, FileName: string): string;
{Convierte una ruta relativa (FileName), a una absoluta, usnado como base la ruta de
otro archivo (BaseFile)}
var
  BasePath: RawByteString;
begin
   if pos(DirectorySeparator, FileName)=0 then begin
     //Ruta relativa. Se completa
     BasePath := ExtractFileDir(BaseFile);
     if BasePath = '' then begin
       //No hay de donde completar, usa la ruta actual
       Result := ExpandFileName(FileName);
     end else  begin
       Result := ExtractFileDir(BaseFile) + DirectorySeparator + FileName;
     end;
   end else begin
     //Tiene "DirectorySeparator", se asume que es ruta absoluta, y no se cambia.
     Result := FileName;
   end;
end;

function TCompilerBase.hexFilePath: string;
begin
  Result := ExpandRelPathTo(mainFile, hexfile); //Convierte a ruta absoluta
end;
function TCompilerBase.mainFilePath: string;
begin
  Result := mainFile;
end;
procedure TCompilerBase.RefreshAllElementLists;
begin
  //TreeElems.RefreshAllFuncs;
  //TreeElems.RefreshAllCons;
  //TreeElems.RefreshAllUnits;
  //TreeElems.RefreshAllVars;
  //TreeElems.RefreshAllTypes;

  //Si esta rutina trabaja bien. las anteriores son inenesarias.
  TreeElems.RefreshAllElementLists;
end;
procedure TCompilerBase.RemoveUnusedFunc;
{Explora las funciones, para quitarle las referencias de funciones no usadas.
Para que esta función trabaje bien, debe haberse llamado a RefreshAllElementLists(). }
  function RemoveUnusedFuncReferences: integer;
  {Explora las funciones, para quitarle las referencias de funciones no usadas.
  Devuelve la cantidad de funciones no usadas.
  Para que esta función trabaje bien, debe estar actualizada "TreeElems.AllFuncs". }
  var
    fun, fun2: TxpEleFun;
  begin
    Result := 0;
    for fun in TreeElems.AllFuncs do begin
      if fun.nCalled = 0 then begin
        inc(Result);   //Lleva la cuenta
        //Si no se usa la función, tampoco sus elementos locales
        fun.SetElementsUnused;
        //También se quita las llamadas que hace a otras funciones
        for fun2 in TreeElems.AllFuncs do begin
          fun2.RemoveCallsFrom(fun.BodyNode);
//          debugln('Eliminando %d llamadas desde: %s', [n, fun.name]);
        end;
        //Incluyendo a funciones del sistema
        for fun2 in listFunSys do begin
          fun2.RemoveCallsFrom(fun.BodyNode);
        end;
      end;
    end;
  end;
var
  noUsed, noUsedPrev: Integer;
begin
  //Explora las funciones, para identifcar a las no usadas
  noUsed := 0;
  repeat  //Explora en varios niveles
    noUsedPrev := noUsed;   //valor anterior
    noUsed := RemoveUnusedFuncReferences;
  until noUsed = noUsedPrev;
end;
procedure TCompilerBase.RemoveUnusedVars;
{Explora las variables de todo el programa, para detectar las que no son usadas
(quitando las referencias que se hacen a ellas)).
Para que esta función trabaje bien, debe haberse llamado a RefreshAllElementLists()
y a RemoveUnusedFunc(). }
  function RemoveUnusedVarReferences: integer;
  {Explora las variables de todo el programa, de modo que a cada una:
  * Le quita las referencias hechas por variables no usadas.
  Devuelve la cantidad de variables no usadas.}
  var
    xvar, xvar2: TxpEleVar;
    fun: TxpEleFun;
  begin
    Result := 0;
    {Quita, a las variables, las referencias de variables no usadas.
    Una referencia de una variable a otra se da, por ejemplo, en el caso:
    VAR
      STATUS_IRP: bit absolute STATUS.7;
    En este caso, la variable STATUS_IRP, hace referencia a STATUS.
    Si STATUS_IRP no se usa, esta referencia debe quitarse.
    }
    for xvar in TreeElems.AllVars do begin
      if xvar.nCalled = 0 then begin
        //Esta es una variable no usada
        inc(Result);   //Lleva la cuenta
        //Quita las llamadas que podría estar haciendo a otras variables
        for xvar2 in TreeElems.AllVars do begin
          xvar2.RemoveCallsFrom(xvar);
//            debugln('Eliminando llamada a %s desde: %s', [xvar2.name, xvar.name]);
        end;
      end;
    end;
    //Ahora quita las referencias de funciones no usadas
    for fun in TreeElems.AllFuncs do begin
      if fun.nCalled = 0 then begin
        //Esta es una función no usada
        inc(Result);   //Lleva la cuenta
        for xvar2 in TreeElems.AllVars do begin
          xvar2.RemoveCallsFrom(fun.BodyNode);
//          debugln('Eliminando llamada a %s desde: %s', [xvar2.name, xvar.name]);
        end;
      end;
    end;
  end;
var
  noUsed, noUsedPrev: Integer;
begin
  noUsed := 0;
  repeat  //Explora en varios niveles
    noUsedPrev := noUsed;   //valor anterior
    noUsed := RemoveUnusedVarReferences;
  until noUsed = noUsedPrev;   //Ya no se eliminan más variables
end;
procedure TCompilerBase.RemoveUnusedCons;
{Explora las constantes de todo el programa, para detectar las que no son usadas
(quitando las referencias que se hacen a ellas)).
Para que esta función trabaje bien, debe haberse llamado a RefreshAllElementLists()
y a RemoveUnusedFunc(). }
  function RemoveUnusedConsReferences: integer;
  {Explora las constantes de todo el programa, de modo que a cada una:
  * Le quita las referencias hechas por constantes no usadas.
  Devuelve la cantidad de constantes no usadas.}
  var
    cons, cons2: TxpEleCon;
    xvar: TxpEleVar;
    fun: TxpEleFun;
  begin
    Result := 0;
    {Quita, a las constantes, las referencias de constantes no usadas.
    Una referencia de una constante a otra se da, por ejemplo, en el caso:
    CONST
      CONST_2 = CONST_1 + 1;
    En este caso, la constante CONST_2, hace referencia a CONST_1.
    Si CONST_2 no se usa, esta referencia debe quitarse.
    }
    for cons in TreeElems.AllCons do begin
      if cons.nCalled = 0 then begin
        //Esta es una constante no usada
        inc(Result);   //Lleva la cuenta
        //Quita las llamadas que podría estar haciendo a otras constantes
        for cons2 in TreeElems.AllCons do begin
          cons2.RemoveCallsFrom(cons);
//            debugln('Eliminando llamada a %s desde: %s', [cons2.name, cons.name]);
        end;
      end;
    end;
    {Si se incluye la posibilidad de definir variables a partir de constantes,
    como en:
    VAR mi_var: byte absolute CONST_DIR;
    Entonces es necesario este código:}
    for xvar in TreeElems.AllVars do begin
      if xvar.nCalled = 0 then begin
        //Esta es una variable no usada
        inc(Result);   //Lleva la cuenta
        //Quita las llamadas que podría estar haciendo a constantes
        for cons2 in TreeElems.AllCons do begin
          cons2.RemoveCallsFrom(xvar);
//            debugln('Eliminando llamada a %s desde: %s', [cons2.name, xvar.name]);
        end;
      end;
    end;
    //Ahora quita las referencias de funciones no usadas
    for fun in TreeElems.AllFuncs do begin
      if fun.nCalled = 0 then begin
        //Esta es una función no usada
        inc(Result);   //Lleva la cuenta
        for cons2 in TreeElems.AllCons do begin
          cons2.RemoveCallsFrom(fun.BodyNode);
//          debugln('Eliminando llamada a %s desde: %s', [cons2.name, cons.name]);
        end;
      end;
    end;
  end;
var
  noUsed, noUsedPrev: Integer;
begin
  noUsed := 0;
  repeat  //Explora en varios niveles
    noUsedPrev := noUsed;   //valor anterior
    noUsed := RemoveUnusedConsReferences;
  until noUsed = noUsedPrev;   //Ya no se eliminan más constantes
end;
procedure TCompilerBase.RemoveUnusedTypes;
{Explora los tipos (definidos por el usuario) de todo el programa, para detectar
los que no son usados (quitando las referencias que se hacen a ellos)).
Para que esta función trabaje bien, debe haberse llamado a RefreshAllElementLists()
y a RemoveUnusedFunc(). }
  function RemoveUnusedTypReferences: integer;
  {Explora los tipos de todo el programa, de modo que a cada uno:
  * Le quita las referencias hechas por constantes, variables, tipos y funciones no usadas.
  Devuelve la cantidad de tipos no usados.
  ////////// POR REVISAR ///////////}
  var
    cons: TxpEleCon;
    xvar: TxpEleVar;
    xtyp, xtyp2: TxpEleType;
    fun : TxpEleFun;
  begin
    Result := 0;
    {Quita, a los tipos, las referencias de constantes no usadas (de ese tipo).}
    for cons in TreeElems.AllCons do begin
      if cons.nCalled = 0 then begin
        //Esta es una constante no usada
        inc(Result);   //Lleva la cuenta
        //Quita las llamadas que podría estar haciendo a otras constantes
        for xtyp in TreeElems.AllTypes do begin
          xtyp.RemoveCallsFrom(cons);
//            debugln('Eliminando llamada a %s desde: %s', [xtyp.name, cons.name]);
        end;
      end;
    end;
    {Quita, a los tipos, las referencias de variables no usadas (de ese tipo).}
    for xvar in TreeElems.AllVars do begin
      if xvar.nCalled = 0 then begin
        //Esta es una variable no usada
        inc(Result);   //Lleva la cuenta
        //Quita las llamadas que podría estar haciendo a constantes
        for xtyp in TreeElems.AllTypes do begin
          xtyp.RemoveCallsFrom(xvar);
//            debugln('Eliminando llamada a %s desde: %s', [xtyp.name, xvar.name]);
        end;
      end;
    end;
    {Quita, a los tipos, las referencias de otros tipos no usadas.
    Como en los tipos que se crean a partir de otros tipos}
    for xtyp2 in TreeElems.AllTypes do begin
      if xtyp2.nCalled = 0 then begin
        //Esta es una variable no usada
        inc(Result);   //Lleva la cuenta
        //Quita las llamadas que podría estar haciendo a constantes
        for xtyp in TreeElems.AllTypes do begin
          xtyp.RemoveCallsFrom(xtyp2);
//            debugln('Eliminando llamada a %s desde: %s', [xtyp.name, xtyp2.name]);
        end;
      end;
    end;
    //Ahora quita las referencias de funciones no usadas (de ese tipo)
    for fun in TreeElems.AllFuncs do begin
      if fun.nCalled = 0 then begin
        //Esta es una función no usada
        inc(Result);   //Lleva la cuenta
        for xtyp in TreeElems.AllTypes do begin
          xtyp.RemoveCallsFrom(fun.BodyNode);
//          debugln('Eliminando llamada a %s desde: %s', [xtyp.name, cons.name]);
        end;
      end;
    end;
  end;
var
  noUsed, noUsedPrev: Integer;
begin
  noUsed := 0;
  repeat  //Explora en varios niveles
    noUsedPrev := noUsed;   //valor anterior
    noUsed := RemoveUnusedTypReferences;
  until noUsed = noUsedPrev;   //Ya no se eliminan más constantes
end;
procedure TCompilerBase.UpdateCallersToUnits;
{Explora recursivamente el arbol de sintaxis para encontrar( y agregar) las
llamadas que se hacen a una unidad desde el programa o unidad que la incluye.
El objetivo final es determinar los accesos a las unidades.}
  procedure ScanUnits(nod: TxpElement);
  var
    ele, eleInter , eleUnit: TxpElement;
    uni : TxpEleUnit;
    cal , c: TxpEleCaller;
  begin
debugln('+Scanning in:'+nod.name);
    if nod.elements<>nil then begin
      for ele in nod.elements do begin
        //Solo se explora a las unidades
        if ele.idClass = eltUnit then begin
debugln('  Unit:'+ele.name);
          //"ele" es una unidad de "nod". Verifica si es usada
          uni := TxpEleUnit(ele);    //Accede a la unidad.
          uni.ReadInterfaceElements; //Accede a sus campos
          {Buscamos por los elementos de la interfaz de la unidad para ver si son
           usados}
          for eleInter in uni.InterfaceElements do begin
debugln('    Interface Elem:'+eleInter.name);
            //Explora por los llamadores de este elemento.
            for cal in eleInter.lstCallers do begin
              eleUnit := cal.CallerUnit;   //Unidad o programa
              if eleUnit = nod then begin
                {Este llamador está contenido en "nod". Lo ponemos como llamador de
                la unidad.}
                c := AddCallerTo(uni);
                c.caller := cal.caller;
                c.curBnk := cal.curBnk;
                c.curPos := cal.curPos;
                debugln('      Added caller to %s from %s (%d,%d)',
                        [uni.name, c.curPos.fil, c.curPos.row, c.curPos.col]);
              end;
            end;
          end;
          //Ahora busca recursivamente, por si la unidad incluyea a otras unidades
          ScanUnits(ele);  //recursivo
        end;
      end;
    end;
  end;
begin
  ScanUnits(TreeElems.main);
end;
//Inicialización
constructor TCompilerBase.Create;
begin
  ClearError;   //inicia motor de errores
  //Crea arbol de elementos y listas
  TreeElems  := TXpTreeElements.Create;
  TreeDirec  := TXpTreeElements.Create;
  listFunSys := TxpEleFuns.Create(true);
  listTypSys := TxpEleTypes.Create(true);
  //inicia la sintaxis
  xLex := TSynFacilSyn.Create(nil);   //crea lexer

  cIn := TContexts.Create(xLex); //Crea lista de Contextos
  ejecProg := false;
  //Actualiza las referencias a los tipos de tokens existentes en SynFacilSyn
  tnEol     := xLex.tnEol;
  tnSymbol  := xLex.tnSymbol;
  tnSpace   := xLex.tnSpace;
  tnIdentif := xLex.tnIdentif;
  tnNumber  := xLex.tnNumber;
  tnKeyword := xLex.tnKeyword;
  tnString  := xLex.tnString;
  tnComment := xLex.tnComment;
  //Atributos
  tkEol     := xLex.tkEol;
  tkSymbol  := xLex.tkSymbol;
  tkSpace   := xLex.tkSpace;
  tkIdentif := xLex.tkIdentif;
  tkNumber  := xLex.tkNumber;
  tkKeyword := xLex.tkKeyword;
  tkString  := xLex.tkString;
  tkComment := xLex.tkComment;
  //Crea nuevos tipos necesarios para el Analizador Sintáctico
  tnOperator := xLex.NewTokType('Operator', tkOperator); //necesario para analizar expresiones
  tnBoolean  := xLex.NewTokType('Boolean', tkBoolean);  //constantes booleanas
  tnSysFunct := xLex.NewTokType('SysFunct', tkSysFunct); //funciones del sistema
  tnType     := xLex.NewTokType('Types', tkType);    //tipos de datos
end;
destructor TCompilerBase.Destroy;
begin
  cIn.Destroy; //Limpia lista de Contextos
  xLex.Free;
  listTypSys.Destroy;
  listFunSys.Destroy;
  TreeDirec.Destroy;
  TreeElems.Destroy;
  inherited Destroy;
end;

end.
