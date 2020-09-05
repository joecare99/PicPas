{
XpresElementsPIC
================
Definitions for syntactic elements of the compiler: functions, constants, variables,
types, ...
All these elements are stored in a Tree structure, that represents the syntax Tree.
This unit is based in the unit XpresElements from the framework Xpres, and is adapted
to the PIC architecture and to the Pascal dialect used here.

                                                       By Tito Hinostroza.
}
unit XpresElementsPIC;
{$mode objfpc}{$H+}
interface
uses
  Classes, SysUtils, fgl, XpresTypesPIC, XpresBas, LCLProc;
const
  ADRR_ERROR = $FFFF;

type  //TxpElement y clases previas
  TVarOffs = word;
  TVarBank = byte;

  TxpOperator = class;
  TxpOperation = class;

  {Event to call a ROB. The "Opt" parameter, is used to give aditional information of
  the ROP. }
  TProcBinaryROB = procedure(Opt: TxpOperation; SetRes: boolean) of object;

  {Evento que llama a una Rutina de Operación (ROP).
  El parámetro "SetRes", se usa para cuando se quiere indicar si se usará la ROP, en
  modo normal (TRUE) o si solo se quiere usar la ROP, como generador de código}
  TProcExecOperat = procedure(Opr: TxpOperator; SetRes: boolean) of object;

  TxpEleType= class;

  { TxpOperation }
  //Tipo operación
  TxpOperation = class
    parent    : TxpOperator;     //Referencia al operador que lo contiene
    ToType    : TxpEleType;      //Tipo del Operando, sobre el cual se aplica la operación.
    proc      : TProcBinaryROB;  //Procesamiento de la operación
    function OperationString: string;
  end;

  TxpOperations = specialize TFPGObjectList<TxpOperation>; //lista de operaciones

  { TxpOperator }
  //Operador
  TxpOperator = class
  private
    Operations: TxpOperations;  //operaciones soportadas. Debería haber tantos como
                                //Num. Operadores * Num.Tipos compatibles.
  public
    txt    : string;     //Cadena del operador '+', '-', '++', ...
    parent : TxpEleType; //Referencia al tipo que lo contiene
    prec   : byte;       //Precedencia
    name   : string;     //Nombre de la operación (suma, resta)
    kind   : TxpOperatorKind;   //Tipo de operador
    OperationPre: TProcExecOperat;  {Operación asociada al Operador. Usado cuando es un
                                    operador unario PRE. }
    OperationPost: TProcExecOperat; {Operación asociada al Operador. Usado cuando es un
                                    operador unario POST }
    function CreateOperation(OperandType: TxpEleType; proc: TProcBinaryROB
      ): TxpOperation;  //Crea operación
    function FindOperation(typ0: TxpEleType): TxpOperation;  //Busca una operación para este operador
    function OperationString: string;
    constructor Create;
    destructor Destroy; override;
  end;
  TxpOperators = specialize TFPGObjectList<TxpOperator>; //lista de operadores


  //Tipos de elementos del lenguaje
  TxpIDClass = (eltNone,  //Sin tipo
                eltCodeCont, //Contenedor de código
                eltMain,  //Programa principal
                eltVar,   //Variable
                eltFuncDec, //Declaración de función
                eltFunc,  //Función
                eltInLin, //Función INLINE
                eltCons,  //Constante
                eltType,  //Tipo
                eltUnit,  //Unidad
                eltBody,  //Cuerpo del programa/procedimiento
                eltFinal  //Sección FINALIZATION de unidad
                );
  //Ubicación primaria de un elemento
  TxpEleLocation = (
                locMain,       //En el programa principal.
                locInterface,  //En INTERFACE de una unidad.
                locImplement   //En IMPLEMENTATION de una unidad.
  );
  TxpElement = class;
  TxpElements = specialize TFPGObjectList<TxpElement>;

  TxpEleBody = class;


  { TxpEleCaller }
  //Information about the call to one element from other element.
  TxpEleCaller = class
    curPos: TSrcPos;    //Posición desde donde es llamado
    curBnk: byte;       //banco RAM, desde donde se llama
    caller: TxpElement; //función que llama a esta función
    function CallerUnit: TxpElement;  //Unidad/Programa de donde se llama
  end;
  TxpListCallers = specialize TFPGObjectList<TxpEleCaller>;

  //Datos de las llamadas que se hacen a otro elemento
//  TxpEleCalled = class
//    curPos: TSrcPos;    //Posición desde donde es llamado
//    curBnk: byte;       //banco RAM, desde donde se llama
//    called: TxpElement; //función que llama a esta función
//  end;
  TxpListCalled = specialize TFPGObjectList<TxpElement>;

  //Identificadores para bloques de sintaxis
  TxpSynBlockId = (
    sbiNULL,  //Sin bloque (en el mismo Body)
    sbiIF,    //bloque IF
    sbiFOR,   //bloque FOR
    sbiWHILE, //bloque WHILE
    sbiREPEAT //bloque REPEAT
  );

  { TxpSynBlock }
  //Define un bloque de sintaxis.
  TxpSynBlock = class
    id : TxpSynBlockId;
    function idStr: string;
  end;
  TxpSynBlocks = specialize TFPGObjectList<TxpSynBlock>;

  { TxpExitCall }
  //Clase que representa una llamada a la instrucción exit()
  TxpExitCall = class
    srcPos: TSrcPos;    //Posición en el código fuente
    blkId : TxpSynBlockId; //Identificador del bloque desde donde se hizo la llamada
    curBnk: byte;       //Banco actual al hacer el RETURN
    function IsObligat: boolean;
  end;
  TxpExitCalls = specialize TFPGObjectList<TxpExitCall>; //lista de variables

  TxpEleVar = class;

  { TxpAdicDeclar }
  {Define aditional declaration settings for variable. Depends on target CPU architecture.}
  TxpAdicDeclar = (
    decNone,   //Normal declaration. Will be mapped in free RAM.
    decAbsol,  //Mapped in ABSOLUTE address
    decRegis{,  //Mapped at RT
    decRegisA, //Mapped at A register
    decRegisX, //Mapped at X register
    decRegisY  //Mapped at Y register}
  );

  {Description for aditional information in variables declaration: ABSOLUTE ,
  REGISTER,  or initialization. }
  TAdicVarDec = record
    hasAdic   : TxpAdicDeclar;  //ABSOLUTE, REGISTERA, ...
    absVar    : TxpEleVar; //Referencia a variable, cuando es ABSOLUTE <variable>
    absAddr   : integer;   //dirección ABSOLUTE
    absBit    : byte;      //bit ABSOLUTE
    hasInit   : boolean;   //Indica si tiene valor inicial
    iniVal    : TConsValue; //Initial constant value
    //Posición donde empieza la declaración de parámetros adicionales de la variable
    srcDec    : TPosCont;
  end;

  { TxpElement }
  //Clase base para todos los elementos
  TxpElement = class
  private
    Fname    : string;   //Nombre del elemnto
    Funame   : string;   //Nombre en mayúscula para acelerar las bísquedas.
    procedure Setname(AValue: string);
    function AddElement(elem: TxpElement; AtBegin: boolean): TxpElement;
  public  //Gestion de llamadas al elemento
    //Lista de funciones que llaman a esta función.
    lstCallers: TxpListCallers;
    function nCalled: integer; virtual; //número de llamadas
    function IsCalledBy(callElem: TxpElement): boolean; //Identifica a un llamador
    function IsCalledByChildOf(callElem: TxpElement): boolean; //Identifica a un llamador
    function IsCalledAt(callPos: TSrcPos): boolean;
    function IsDeclaredAt(decPos: TSrcPos): boolean;
    function FindCalling(callElem: TxpElement): TxpEleCaller; //Identifica a un llamada
    function RemoveCallsFrom(callElem: TxpElement): integer; //Elimina llamadas
    procedure RemoveLastCaller; //Elimina la última llamada
    procedure ClearCallers;  //limpia lista de llamantes
    function ExistsIn(list: TxpElements): boolean;
  public  //Gestión de los elementos llamados
    curNesting: Integer;   //Nivel de anidamiento de llamadas
    maxNesting: Integer;   //Máximo nivel de anidamiento
    //Lista de funciones que son llamadas directamente (Se llena en el enlazado)
    lstCalled : TxpListCalled;
    //Lista de funciones que son llamadas dirceta o indirectamente (Se llena en el enlazado)
    lstCalledAll: TxpListCalled;
    //Métodos para el llemado
    procedure AddCalled(elem: TxpElement);
    function UpdateCalledAll: integer;
  public
    Parent: TxpElement;   //Referencia al elemento padre
    idClass: TxpIDClass;  //Para no usar RTTI
    elements: TxpElements; //Referencia a nombres anidados, cuando sea función
    location: TxpEleLocation;  //Ubicación del elemento
    property name: string read Fname write Setname;
    property uname: string read Funame;
    function Path: string;
    function FindIdxElemName(const eName: string; var idx0: integer): boolean;
    function LastNode: TxpElement;
    function Index: integer;
  public  //Ubicación física de la declaración del elmento
    posCtx: TPosCont;  //Ubicación en el código fuente
    {Datos de la ubicación en el código fuente, donde el elemento es declarado. Guardan
    parte de la información de posCtx, pero se mantiene, aún después de cerrar los
    contextos de entrada.}
    srcDec: TSrcPos;
    {Posición final de la declaración. Esto es útil en los elementos que TxpEleBody,
    para delimitar el bloque de código.}
    srcEnd: TSrcPos;
    function posXYin(const posXY: TPoint): boolean;
  public  //Inicialización
    procedure Clear; virtual;
    constructor Create; virtual;
    destructor Destroy; override;
  end;

type //Elements class

  { TxpEleCodeCont }
  {Define a element that can be used as a general code conatiner, like the main program,
  a procedure or a unit.}
  TxpEleCodeCont = class(TxpElement)
  public
    {Banco de RAM, que tiene la función al ejecutar la útlima instrucción. No es
     necesariamente el banco con el que termina siempre, la función, porque puede haber
     instrucciones exit(), antes. Para mejor precisión sobre el banco de salida, se debe
     usar ExitBank()}
    finBnk: byte;
    function BodyNode: TxpEleBody;
  public //Manejo de llamadas a exit()
    lstExitCalls: TxpExitCalls;
    procedure AddExitCall(srcPos: TSrcPos; blkId: TxpSynBlockId; curBnk: byte);
    function ObligatoryExit: TxpExitCall;
    function ExitBank: byte;
  public //Información sobre bloques de sintaxis
    {TxpEleBody, almacena bloques de sintaxis para llevar el control de la ubicación
     de las instrucciones, con respecto a los bloques.}
    blocks : TxpSynBlocks;
    procedure OpenBlock(blkId: TxpSynBlockId);
    procedure CloseBlock;
    function CurrBlock: TxpSynBlock;
    function CurrBlockID: TxpSynBlockId;
  public //Inicialización
    procedure Clear; override;
    constructor Create; override;
    destructor Destroy; override;
  end;

  //Model an attribute of a RECORD or OBJECT
  TTypAttrib = class
    name: string;      //Name od the field
    offs: integer;     //Offset for Physycal address
    typ : TxpEleType;  //Only reference to the type
  end;
  TTypATtributes = specialize TFPGObjectList<TTypAttrib>;

  TxpEleTypes= specialize TFPGObjectList<TxpEleType>; //lista de variables

  { TxpEleType }
  {Clase para modelar a los tipos definidos por el usuario y a los tipos del sistema.
  Es una clase relativamente extensa, debido a la flxibilidad que ofrecen lso tipos en
  Pascal.}
  TxpEleType= class(TxpElement)
  private
    fSize: SmallInt;
    internalTypes: TxpEleTypes;  //Container for types recursively defined.
    function getSize: smallint;
    procedure setSize(AValue: smallint);
  public   //Eventos
    {Estos eventos son llamados automáticamente por el Analizador de expresiones.
    Por seguridad, debe implementarse siempre para cada tipo creado. La implementación
    más simple sería devolver en "res", el operando "p1^".}
    OperationLoad: TProcExecOperat; {Evento. Es llamado cuando se pide evaluar una
                                 expresión de un solo operando de este tipo. Es un caso
                                 especial que debe ser tratado por la implementación}
    {Estos eventos NO se generan automáticamente en TCompilerBase, sino que es la
    implementación del tipo, la que deberá llamarlos. Son como una ayuda para facilitar
    la implementación. OnPush y OnPop, son útiles para cuando la implementación va a
    manejar pila.}
    OnSaveToStk  : procedure of object;  //Salva datos en reg. de Pila
    OnLoadToRT   : TProcLoadOperand; {Se usa cuando se solicita cargar un operando
                                 (de este tipo) en la pila. }
    OnDefRegister: procedure of object; {Se usa cuando se solicita descargar un operando
                                 (de este tipo) de la pila. }
    OnGlobalDef  : TProcDefineVar; {Es llamado cada vez que se encuentra la
                                  declaración de una variable (de este tipo) en el ámbito global.}
  public
    copyOf  : TxpEleType;  //Indica que es una copia de otro tipo
    grp     : TTypeGroup;  //Grupo del tipo (numérico, cadena, etc)
    catType : TxpCatType;
    property size: smallint read getSize write setSize;   //Tamaño en bytes del tipo
  public  //Arrays and pointers
    nItems  : integer;     //Number of items, when is tctArray (-1 if it's dynamic.)
    itmType : TxpEleType;  {Reference to the item type when it's array.
                                TArr = array[255] of byte;  //itemType = byte
                           }
    ptrType : TxpEleType;  {Reference to the type pointed, when it's pointer.
                                TPtr = ^integer;       //ptrType = integer
                           }
  public  //Attributes (When it's used as object: OBJECT ... END; ).
    attribs: TTypATtributes;
  public  //Manejo de campos
    fields: TTypFields;
    procedure CreateField(metName: string; procGet, procSet: TTypFieldProc);
  public  //Campos de operadores
    Operators: TxpOperators;      //Operadores soportados
    operAsign: TxpOperator;       //Se guarda una referencia al operador de aignación
    function CreateBinaryOperator(txt: string; prec: byte; OpName: string): TxpOperator;
    function CreateUnaryPreOperator(txt: string; prec: byte; OpName: string;
      proc: TProcExecOperat): TxpOperator;
    function CreateUnaryPostOperator(txt: string; prec: byte; OpName: string;
      proc: TProcExecOperat): TxpOperator;
    //Funciones de búsqueda
    function FindBinaryOperator(const OprTxt: string): TxpOperator;
    function FindUnaryPreOperator(const OprTxt: string): TxpOperator;
    function FindUnaryPostOperator(const OprTxt: string): TxpOperator;
    procedure SaveToStk;
  public  //Identificación
    function IsBitSize: boolean;
    function IsByteSize: boolean;
    function IsWordSize: boolean;
    function IsDWordSize: boolean;
    procedure DefineRegister;
    function IsArrayOf(itTyp: TxpEleType; numIt: integer): boolean;
    function IsPointerTo(ptTyp: TxpEleType): boolean;
    function IsEquivalent(typ: TxpEleType): boolean;
  public
    constructor Create; override;
    destructor Destroy; override;
  end;

  { TxpEleCon }
  //Clase para modelar a las constantes
  TxpEleCon = class(TxpElement)
    typ: TxpEleType;     //Tipo del elemento, si aplica
    //valores de la constante
    val : TConsValue;
    constructor Create; override;
  end;
  TxpEleCons = specialize TFPGObjectList<TxpEleCon>; //lista de constantes

  { TxpEleVar }
  //Clase para modelar a las variables
  TxpEleVar = class(TxpElement)
  private
    ftyp: TxpEleType;
    function Gettyp: TxpEleType;
    procedure Settyp(AValue: TxpEleType);
  public   //Manejo de parámetros adicionales
    adicPar: TAdicVarDec;  //Parámetros adicionales en la declaración de la variable.
    //Referencia al elemento de tipo
    property typ: TxpEleType read Gettyp write Settyp;
  public
    //Bandera para indicar si la variable, se está usando como parámetro
    IsParameter: boolean;
    {Indica si la variables es temporal, es decir que se ha creado solo para acceder a
    una parte de otra variable, que si tiene almacenamiento físico.}
    IsTmp      : boolean;
  private //Campos para devolver direcciones como TPicRegister y TPicRegisterBit
    adrBitTmp  : TPicRegisterBit; //Dirección física, cuando es de tipo Bit/Boolean
    adrByteTmp : TPicRegister;    //Dirección física, cuando es de tipo Byte/Char/Word/DWord
  public  //Campos para guardar las direcciones físicas asignadas en RAM.
    {Direcciones base. La dirección de inicio de la variable debe ser siempre addr0.
     Se usan addr0 y bit0 para almacenar tipos de 1 bit
     Se usan addr0 y addr1 para almacenar tipos de 2 bytes
     Se usan addr0, addr1, addr2 y addr3 para almacenar tipos de 4 bytes.
     Las direcciones addr0, addr1, addr2 y addr3 son normalmente consecutivas, pero
     hay excepciones.
    }
    addr0: word;   //Dirección base.
    bit0 : byte;   //Posición de bit base
    addr1: word;
    addr2: word;
    addr3: word;
    //Devuelve las direcciones como TPicRegister y TPicRegisterBit
    function adrBit  : TPicRegisterBit; //Dirección física, cuando es de tipo Bit/Boolean
    function adrByte0: TPicRegister;    //Dirección física, cuando es de tipo Byte/Char/Word/DWord
    function adrByte1: TPicRegister;    //Dirección física, cuando es de tipo Word/DWord
    function adrByte2: TPicRegister;    //Dirección física, cuando es de tipo DWord
    function adrByte3: TPicRegister;    //Dirección física, cuando es de tipo DWord
    //Estos campos deberían desaparecer
    function bank: TVarBank;   //Banco de la dirección de la variable
    function offs: TVarOffs;    //Dirección relativa de inicio

    function addr : word;   //Devuelve la dirección absoluta de la variable
    function addrL: word;   //Devuelve la dirección absoluta de la variable (LOW)
    function addrH: word;   //Devuelve la dirección absoluta de la variable (HIGH)
    function addrE: word;   //Devuelve la dirección absoluta de la variable (HIGH)
    function addrU: word;   //Devuelve la dirección absoluta de la variable (HIGH)
    function AddrString: string; //Devuelve la dirección física como cadena
    function BitMask: byte;    //Máscara de bit, de acuerdo al valor del campo "bit".
    procedure ResetAddress;    //Limpia las direcciones físicas
    //procedure SetRAMusedAsShared;
    constructor Create; override;
    destructor Destroy; override;
  end;
  TxpEleVars = specialize TFPGObjectList<TxpEleVar>; //lista de variables

  //Parámetro de una función
  TxpParFunc = record
    name   : string;      //nombre de parámetro
    typ    : TxpEleType;  //Referencia al tipo
    pvar   : TxpEleVar;   //referencia a la variable que se usa para el parámetro
    srcPos : TSrcPos;     //Posición del parámetro.
    adicVar: TAdicVarDec; //Parámetros adicionales
  end;
  TxpParFuncArray = array of TxpParFunc;

  //Parámetro de una función INLINE
  TxpParInlin = record
    name: string;     //nombre de parámetro
    typ : TxpEleType; //Referencia al tipo
    sto : TStoOperand; //Tipo de almacenamiento
    srcPos: TSrcPos;  //Posición del parámetro.
  end;
  TxpParInlinArray = array of TxpParInlin;

  //Clase para modelar al bloque principal
  { TxpEleMain }
  TxpEleMain = class(TxpEleCodeCont)
    //Como este nodo representa al programa principal, se incluye información física
    srcSize: integer;  {Tamaño del código compilado. En la primera pasada, es referencial,
                        porque el tamaño puede variar al reubicarse.}
    constructor Create; override;
  end;

  TxpEleFun = class;
  TxpEleFunBase = class;
  //Clase para almacenar información de las funciones
  TxpProcParam = procedure(fun: TxpEleFunBase) of object;
  TxpProcCall = procedure(fun: TxpEleFunBase; out AddrUndef: boolean) of object;

  { TxpEleFunBase }

  TxpEleFunBase = class(TxpEleCodeCont)
    typ    : TxpEleType;   //Referencia al tipo
    IsInterrupt : boolean;
    IsForward   : boolean; //Identifies a forward declaration.
  public //References
    {Referencia a la función que implemanta, la rutina de porcesamiento que se debe
    hacer, antes de empezar a leer los parámetros de la función.}
    procParam: TxpProcParam;
    {Referencia a la función que implementa, la llamada a la función en ensamblador.
    En funciones del sistema, puede que se implemente INLINE, sin llamada a subrutinas,
    pero en las funciones comunes, siempre usa CALL ... }
    procCall: TxpProcCall;
  public //Parameters manage
    pars   : TxpParFuncArray;  //parámetros de entrada
    procedure ClearParams;
    function SameParamsType(const funpars: TxpParFuncArray): boolean;
    function ParamTypesList: string;
  end;

  TProcExecFunction = procedure(fun: TxpEleFun) of object;

  { TxpEleFunDec }
  {Basic class to represent a function header or declaration (INTERFASE o FORWARD).
  Basically whar we store here is the name, the parameters ante return type.}
  TxpEleFunDec = class(TxpEleFunBase)
  public
    implem      : TxpEleFun;    //Reference to implementation element.
  public //Initialization
    constructor Create; override;
  end;

  { TxpEleFun }
  TxpEleFun = class(TxpEleFunBase)
  public
    adrr   : integer;     //Dirección física, en donde se compila
    srcSize: integer;  {Tamaño del código compilado. En la primera pasada, es referencial,
                        porque el tamaño puede variar al reubicarse.}
    //Banco de RAM, al iniciar la ejecución de la subrutina.
    iniBnk: byte;
    linked : boolean;   //Indicates the function was compiled in its real address
    {Call to routine that generate code for the function, when the function has not body
    like used in system fucntions.}
    compile: TProcExecFunction;
    procedure SetElementsUnused;
  public //Declaration
    {These properties allows to have reference to the function declaration, when there is
    one:  Interface versions or Forward version.
    In other cases there is just a function element without separated declaration.
    According to design:
     Declaration elements -> Contain information about:
        - The parameters and return value.
        - The calls.
     Implementation elements -> Contain information about:
        - The parameters and return value.
        - The calls.
        - Local variables.
        - The body (Calls to other elements.)
     Declaration elements are included too in the Syntax Tree, but they aer used only for
     declaration. All the information must be read in the funtion.
    }
    declar : TxpEleFunDec; //Reference to declaration (When it's FORWARD or in INTERFACE)
    function HasDeclar: boolean; inline;
  public  //Manejo de referencias
    function nCalled: integer; override; //número de llamadas
    function nLocalVars: integer;
    function IsTerminal: boolean;
    function IsTerminal2: boolean;
  private //Manage of pending calls
    curSize: integer;
  public //Manage of pending calls
    {Address of pending calls (JSR) made when the function was not still implemented }
    nAddresPend : integer;
    addrsPend   : array of word;
    procedure AddAddresPend(ad: word);
  public //Inicialización
    constructor Create; override;
    destructor Destroy; override;
  end;
  TxpEleFuns = specialize TFPGObjectList<TxpEleFun>;

  { TxpEleInline }
  //Clase para modelar a las funciones Inline
  TxpEleInlin = class(TxpEleCodeCont)
  public
    typ    : TxpEleType;   //Referencia al tipo
    pars   : TxpParInlinArray;  //parámetros de entrada
    ///////////////
    procedure ClearParams;
    procedure CreateParam(parName: string; typ0: TxpEleType; sto0: TStoOperand);
    function SameParamsType(const funpars: TxpParInlinArray): boolean;
    function Duplicated: boolean;
  public //Inicialización
    constructor Create; override;
    destructor Destroy; override;
  end;
  TxpEleInlins = specialize TFPGObjectList<TxpEleInlin>;

  { TxpEleUnit }
  //Clase para modelar a las constantes
  TxpEleUnit = class(TxpEleCodeCont)
  public
    srcFile: string;   //El archivo en donde está físicamente la unidad.
    InterfaceElements: TxpElements;  //Lista de eleemntos en la sección INTERFACE
    procedure ReadInterfaceElements;
    constructor Create; override;
    destructor Destroy; override;
  end;
  TxpEleUnits = specialize TFPGObjectList<TxpEleUnit>; //lista de constantes

  { TxpEleBody }
  //Clase para modelar al cuerpo principal del programa principal o de un procedimiento
  TxpEleBody = class(TxpElement)
    adrr   : integer;  //dirección física
    constructor Create; override;
    destructor Destroy; override;
  end;

  { TxpEleFinal }
  //Clase para modelar al bloque FINALIZATION de una unidad
  TxpEleFinal = class(TxpElement)
    adrr   : integer;  //dirección física
    constructor Create; override;
    destructor Destroy; override;
  end;

  { TxpEleDIREC }
  //Representa a una directiva. Diseñado para representar a los nodos {$IFDEF}
  TxpEleDIREC = class(TxpElement)
    ifDefResult  : boolean;   //valor booleano, de la expresión $IFDEF
    constructor Create; override;
  end;

  { TXpTreeElements }
  {Árbol de elementos. Se usa para el árbol de sintaxis y de directivas. Aquí es
  donde se guardará la referencia a todas los elementos (variables, constantes, ..)
  creados.
  Este árbol se usa también como para resolver nombres de elementos, en una estructura
  en arbol.}
  TXpTreeElements = class
  private
    //Variables de estado para la búsqueda con FindFirst() - FindNext()
    curFindName: string;
    curFindNode: TxpElement;
    curFindIdx : integer;
    inUnit     : boolean;
  public
    main     : TxpEleMain;  //nodo raiz
    curNode  : TxpElement;  //referencia al nodo actual
    AllCons  : TxpEleCons;
    AllVars  : TxpEleVars;
    AllUnits : TxpEleUnits;
    AllFuncs : TxpEleFuns;
    AllInLns : TxpEleInlins;
    AllTypes : TxpEleTypes;
    OnAddElement: procedure(xpElem: TxpElement) of object;  //Evento
    OnFindElement: procedure(elem: TxpElement) of object;
    procedure Clear;
    procedure RefreshAllUnits;
    function CurNodeName: string;
    function CurCodeContainer: TxpEleCodeCont;
    function LastNode: TxpElement;
    function BodyNode: TxpEleBody;
  public  //Funciones para llenado del arbol
    procedure AddElement(elem: TxpElement; AtBegin: boolean = false);
    procedure AddElementAndOpen(elem: TxpElement);
    procedure AddElementParent(elem: TxpElement; AtBegin: boolean);
    procedure OpenElement(elem: TxpElement);
    procedure CloseElement;
  public  //Métodos para identificación de nombres
    function FindNext: TxpElement;
    function FindFirst(const name: string): TxpElement;
    function FindNextFuncName: TxpEleFun;
    function FindFirstType: TxpEleType;
    function FindNextType: TxpEleType;
    function FindVar(varName: string): TxpEleVar;
    function FindType(typName: string): TxpEleType;
    function ExistsArrayType(itemType: TxpEleType; nEle: integer;
                             out typFound: TxpEleType): boolean;
    function ExistsPointerType(ptrType: TxpEleType;
                             out typFound: TxpEleType): boolean;
    function GetElementBodyAt(posXY: TPoint): TxpEleBody;
    function GetElementAt(posXY: TPoint): TxpElement;
    function GetElementCalledAt(const srcPos: TSrcPos): TxpElement;
    function GetELementDeclaredAt(const srcPos: TSrcPos): TxpElement;
    function FunctionExistInCur(funName: string; const pars: TxpParFuncArray
      ): boolean;
  public  //constructor y destructror
    constructor Create; virtual;
    destructor Destroy; override;
  end;

var
  // Tipo nulo. Usado para elementos sin tipo.
  typNull : TxpEleType;
  // Operador nulo. Usado como valor cero.
  nullOper : TxpOperator;

  function GenArrayTypeName(itTypeName: string; nItems: integer): string; inline;
  function GenPointerTypeName(refTypeName: string): string; inline;

implementation

{Functions to Generates standard names for dinamyc types creation. Have standard
names is important to let the compiler:
 * Reuse types definitions.
 * Implement compatibility for types.
}
function GenArrayTypeName(itTypeName: string; nItems: integer): string; inline;
begin
  if nItems=-1 then begin  //dynamic
    exit(PREFIX_ARR + '-' + itTypeName);
  end else begin          //static
    exit(PREFIX_ARR + IntToSTr(nItems) + '-' + itTypeName);
  end;
end;
function GenPointerTypeName(refTypeName: string): string; inline;
begin
  exit(PREFIX_PTR + '-' +refTypeName);
end;

{ TxpEleCaller }
function TxpEleCaller.CallerUnit: TxpElement;
{Devuelve el elemento unidad o programa principal, desde donde se hace esta llamada.}
var
  container: TxpElement;
begin
  {Se asume que la llamda se puede hacer solo desde dos puntos:
   - Desde una declaración.
   - Desde el cuerpo de una función.
  }
  if caller = nil then exit(nil);
  //La idea es retorceder hasta encontrar una unidad o el programa principal
  container := caller;
  while not (container.idClass in [eltUnit, eltMain]) do begin
    container := container.Parent;  //Go back in the Tree
  end;
  Result := container;
  //No debería haber otro caso
end;

{ TxpExitCall }
function TxpExitCall.IsObligat: boolean;
{Indica si el exit se encuentra dentro de código obligatorio}
begin
  {Para detectar si el exit() está en código obligatorio, se verifica si se enceuntra
  directamente en el Body, y no dentro de bloques de tipo
  IF, WHILE, FOR, REPEAT. Este método no es del todo preciso si se considera que puede
  haber también código obligatorio, también dentro de bloques REPEAT o códigos IF
  definido en tiempo de compialción.}
  Result := (blkId = sbiNULL);
end;
{ TxpSynBlock }
function TxpSynBlock.idStr: string;
begin
  case id of
  sbiIF    : Result := 'sbiIF';
  sbiFOR   : Result := 'sbiFOR';
  sbiWHILE : Result := 'sbiWHILE';
  sbiREPEAT: Result := 'sbiREPEAT';
  else
    Result := '';
  end;
end;
{ TxpOperation }
function TxpOperation.OperationString: string;
{Devuelve una cadena que representa a la operación, sobre los tipos.
 Algo como: byte + byte}
var
  type1: TxpEleType;
begin
  type1 := parent.parent;
  Result := type1.name + ' ' + parent.txt + ' ' + ToType.name;
end;


{ TxpElement }
function TxpElement.AddElement(elem: TxpElement; AtBegin: boolean): TxpElement;
{Agrega un elemento hijo al elemento actual. Devuelve referencia. }
begin
  elem.Parent := self;  //Update reference
  if AtBegin then begin
    elements.Insert(0, elem);   //Add to list of elements
  end else begin
    elements.Add(elem);   //Add to list of elements
  end;
  Result := elem;       //No so useful
end;
procedure TxpElement.Setname(AValue: string);
begin
  if Fname=AValue then Exit;
  Fname:=AValue;
  Funame:=Upcase(AValue);
end;
function TxpElement.FindIdxElemName(const eName: string; var idx0: integer): boolean;
{Busca un nombre en su lista de elementos. Inicia buscando desde idx0, hasta el inicio.
 Si encuentra, devuelve TRUE y deja en idx0, la posición en donde se encuentra.}
var
  i: Integer;
  uEleName: String;
begin
  uEleName := upcase(eName);
  //empieza la búsqueda en "idx0"
  for i := idx0 downto 0 do begin
    if upCase(elements[i].name) = uEleName then begin
      //sale dejando idx0 en la posición encontrada
      idx0 := i;
      exit(true);
    end;
  end;
  exit(false);
end;
function TxpElement.LastNode: TxpElement;
{Devuelve una referencia al último nodo de "elements"}
begin
  if elements = nil then exit(nil);
  if elements.Count = 0 then exit(nil);
  Result := elements[elements.Count-1];
end;
function TxpElement.Index: integer;
{Devuelve la ubicación del elemento, dentro de su nodo padre.}
begin
  Result := Parent.elements.IndexOf(self);  //No es muy rápido
end;
//Gestion de llamadas al elemento
function TxpElement.nCalled: integer;
begin
  Result := lstCallers.Count;
end;
function TxpElement.IsCalledBy(callElem: TxpElement): boolean;
{Indica si el elemento es llamado por "callElem". Puede haber varias llamadas desde
"callElem", pero basta que haya una para devolver TRUE.}
var
  cal : TxpEleCaller;
begin
  for cal in lstCallers do begin
    if cal.caller = callElem then exit(true);
  end;
  exit(false);
end;
function TxpElement.IsCalledByChildOf(callElem: TxpElement): boolean;
{Indica si el elemento es llamado por algún elemento hijo de "callElem".
Puede haber varias llamadas desde "callElem", pero basta que haya una para devolver TRUE.}
var
  cal : TxpEleCaller;
begin
  for cal in lstCallers do begin
    if cal.caller.Parent = callElem then exit(true);
  end;
  exit(false);
end;
function TxpElement.IsCalledAt(callPos: TSrcPos): boolean;
{Indica si el elemento es llamado, desde la posición indicada.}
var
  cal : TxpEleCaller;
begin
  for cal in lstCallers do begin
    if cal.curPos.EqualTo(callPos) then exit(true);
  end;
  exit(false);
end;
function TxpElement.IsDeclaredAt(decPos: TSrcPos): boolean;
begin
  Result := srcDec.EqualTo(decPos);
end;
function TxpElement.FindCalling(callElem: TxpElement): TxpEleCaller;
{Busca la llamada de un elemento. Si no lo encuentra devuelve NIL.}
var
  cal : TxpEleCaller;
begin
  for cal in lstCallers do begin
    if cal.caller = callElem then exit(cal);
  end;
  exit(nil);
end;
function TxpElement.RemoveCallsFrom(callElem: TxpElement): integer;
{Elimina las referencias de llamadas desde un elemento en particular.
Devuelve el número de referencias eliminadas.}
var
  cal : TxpEleCaller;
  n, i: integer;
begin
  {La búsqueda debe hacerse al revés para evitar el problema de borrar múltiples
  elementos}
  n := 0;
  for i := lstCallers.Count-1 downto 0 do begin
    cal := lstCallers[i];
    if cal.caller = callElem then begin
      lstCallers.Delete(i);
      inc(n);
      //debugln('Eliminando llamada a %s desde: %s', [self.name, callElem.name]);
    end;
  end;
  Result := n;
end;
procedure TxpElement.RemoveLastCaller;
//Elimina el último elemento llamador agregado.
begin
  if lstCallers.Count>0 then lstCallers.Delete(lstCallers.Count-1);
end;
procedure TxpElement.ClearCallers;
begin
  lstCallers.Clear;
end;
function TxpElement.ExistsIn(list: TxpElements): boolean;
{Debe indicar si el elemento está duplicado en la lista de elementos proporcionada.}
var
  ele: TxpElement;
begin
  for ele in list do begin
    if ele.uname = uname then begin
      exit(true);
    end;
  end;
  exit(false);
end;
//Gestión de los elementos llamados
procedure TxpElement.AddCalled(elem: TxpElement);
begin
  if lstCalled.IndexOf(elem) = -1 then begin
    lstCalled.Add(elem);
  end;
end;
function TxpElement.UpdateCalledAll: integer;
{Update list "lstCalledAll", using AddCalledAll_FromList().
  The return value is:
  * curNesting -> if not error happens.
  * <0  ->  If found recursion.
}
  function AddCalledAll(elem: TxpElement): boolean;
  {Add reference to lstCalledAll. That is, indicates some element is called from this
  element.
  If reference already exists, retunr FALSE.}
  begin
    //Solo agrega una vez el elemento
    if lstCalledAll.IndexOf(elem) = -1 then begin
      lstCalledAll.Add(elem);
      exit(true);
    end else begin
      exit(false);
    end;
  end;
  function AddCalledAll_FromList(lstCalled0: TxpListCalled): integer;
  {Add the call references (to lstCalledAll) of all elements of the list lstCalled0,
  including its called too (recursive).}
  var
    elem: TxpElement;
    err: Integer;
  begin
    inc(curNesting);    //incrementa el anidamiento
    if curNesting>maxNesting then maxNesting := curNesting;

    if lstCalled0.Count = 0 then exit;
    for elem in lstCalled0 do begin
//      debugln('Call to ' + elem.name + ' from ' + self.name);
//      if elem = self then begin
//        {This is some way to detect circular references like:
//        procedure proc2;
//        begin
//          proc1;
//        end;
//        procedure proc1;
//        begin
//          proc2;
//        end;
//        But fails whe this element is not part of the circualr reference like
//        procedure proc2;   <-- We are proc2
//        begin
//          proc1;
//        end;
//        procedure proc1; <-- Here is the recursion
//        begin
//          proc1;
//        end;
//        In this case, several call to proc1() will be adding.
//        }
//        if curNesting = 1 then begin
//          exit(-1);
//        end else begin
//          exit(-2);
//        end;
//      end;
      //Add element reference
      if not AddCalledAll(elem) then begin
        //This is better way to detect circle references, because lstCalled, doesn't
        //contain duplicated calls.
        exit(-1);
      end;
      if curNesting > 100 then begin
        //This is a secure way (but less elegant) for checking recursion. (If curNesting
        //grows too much). I don't expect this happens, unless exists some case I haven't
        //considered.
        exit(-1);
      end;
      //Verify if this element have other calls to add too.
      if elem.lstCalled.Count <> 0 then begin
        err := AddCalledAll_FromList(elem.lstCalled);
        if err<0 then exit(err);
      end;
    end;
    dec(curNesting);    //incrementa el anidamiento
    exit(curNesting);
  end;
begin
//debugln('UpdateCalledAll' + IntToStr(lstCalledAll.Count));
  lstCalledAll.Clear;  //By security
  curNesting := 0;
  maxNesting := 0;
  Result := AddCalledAll_FromList(lstCalled);
end;

function TxpElement.Path: string;
{Devuelve una cadena, que indica la ruta del elemento, dentro del árbol de sintaxis.}
var
  ele: TxpElement;
begin
  ele := self;
  Result := '';
  while ele<>nil do begin
    Result := '\' + ele.name + Result;
    ele := ele.Parent;
  end;
end;
function TxpElement.posXYin(const posXY: TPoint): boolean;
{Indica si la coordeda del cursor, se encuentra dentro de las coordenadas del elemento.}
var
  y1, y2: integer;
begin
  y1 := srcDec.row;
  y2 := srcEnd.row;
  //Primero verifica la fila
  if (posXY.y >= y1) and (posXY.y<=y2) then begin
    //Está entre las filas. Pero hay que ver también las columnas, si posXY, está
    //en los bordes.
    if y1 = y2 then begin
      //Es rango es de una sola fila
      if (posXY.X >= srcDec.col) and (posXY.X <= srcEnd.col) then begin
        exit(true)
      end else begin
        exit(false);
      end;
    end else if posXY.y = y1 then begin
      //Está en el límite superior
      if posXY.X >= srcDec.col then begin
        exit(true)
      end else begin
        exit(false);
      end;
    end else if posXY.y = y2 then begin
      //Está en el límite inferior
      if posXY.X <= srcEnd.col then begin
        exit(true)
      end else begin
        exit(false);
      end;
    end else begin
      //Está entre los límites
      exit(true);
    end;
  end else begin
    //Esta fuera del rango
    exit(false);
  end;
end;
//Inicialización
procedure TxpElement.Clear;
{Inicializa los campos del objeto. Este método es usado, solamente, para el Nodo Main,
porque los otors nodos son eliminados de la memoria al iniciar el árbol}
begin
  elements.Clear;
  lstCallers.Clear;
  lstCalled.Clear;
  lstCalledAll.Clear;
end;
constructor TxpElement.Create;
begin
  idClass := eltNone;
  lstCallers:= TxpListCallers.Create(true);
  lstCalled := TxpListCalled.Create(false);  //solo guarda referencias
  lstCalledAll:= TxpListCalled.Create(false);
end;
destructor TxpElement.Destroy;
begin
  lstCalledAll.Destroy;
  lstCalled.Destroy;
  lstCallers.Destroy;
  elements.Free;  //por si contenía una lista
  inherited Destroy;
end;
{ TxpEleCodeCont }
function TxpEleCodeCont.BodyNode: TxpEleBody;
{Devuelve la referencia al cuerpo del programa. Si no lo encuentra, devuelve NIL.}
var
  elem: TxpElement;
begin
  elem := LastNode;   //Debe ser el último
  if elem = nil then exit(nil);
  if elem.idClass <> eltBody then begin
    exit(nil);  //No debería pasar
  end;
  //Devuelve referencia
  Result := TxpEleBody(elem);
end;
procedure TxpEleCodeCont.AddExitCall(srcPos: TSrcPos; blkId: TxpSynBlockId; curBnk: byte);
var
  exitCall: TxpExitCall;
begin
  exitCall := TxpExitCall.Create;
  exitCall.srcPos := srcPos;
  {Se guarda el ID, en lugar de la referencia al bloque, porque en el modo de trabajo
   actual, los bloques se crean y destruyen, dinámicamente}
  exitCall.blkId  := blkId;
  exitCall.curBnk := curBnk;
  lstExitCalls.Add(exitCall);
end;
function TxpEleCodeCont.ObligatoryExit: TxpExitCall;
{Devuelve la referencia de una llamada a exit(), dentro de código obligatorio del Body.
Esto ayuda a sabe si ya el usuario incluyó la salida dentro del código y no es necesario
agregar un RETURN al final.
Si no encuentra ninguna llamada a exit() en código obligatorio, devuelve NIL.
Según la docuemnatción, el exit() en código obligatorio, solo debe estar al final del
código del procedimiento. Si estuviera antes, dejaría código "no-ejecutable".}
var
  exitCall: TxpExitCall;
begin
  if lstExitCalls.Count = 0 then exit(nil);  //No incluye exit()
  for exitCall in lstExitCalls do begin
    //Basta detectar un exit(), porque no se espera que haya más.
    if exitCall.IsObligat then begin
      exit(exitCall);  //tiene una llamada en código obligatorio
    end;
  end;
  //No se encontró ningún exit en el mismo "body"
  exit(nil);
end;
function TxpEleCodeCont.ExitBank: byte;
{Devuelve el banco de RAM, que deja el bloque de código, después de ejecutarse.}
var
  exitCall: TxpExitCall;
  bank1: Byte;
begin
  if lstExitCalls.Count = 0 then begin
    //No hay instrucciones exit()
    //Se asume que el banco de salida, será el que deje la última instrucción
    if idClass = eltFunc then begin //Este contenedor es una función
      Result := finBnk;
    end else begin  //Debe ser el bloque Main
      Result := 255;
    end;
  end else if (lstExitCalls.Count = 1) and  lstExitCalls[0].IsObligat then begin
    //Hay una instrucción exit() y está en código obligatorio
    Result := lstExitCalls[0].curBnk;
  end else begin
    //Hay al menos una instrucción exit y no es de ejecución obligatoria
    bank1 := finBnk;  //Es el banco al final
    for exitCall in lstExitCalls do begin
      if exitCall.curBnk <> bank1 then begin
        //No sale en el mismo banco
        Result := 255;
        exit;
      end;
    end;
    //Todos salen por el mismo banco
    Result := bank1;
  end;
end;
procedure TxpEleCodeCont.OpenBlock(blkId: TxpSynBlockId);
{Abre un bloque de sintaxis en este nodo TxpEleCodeCont..
Los bloques de sintaxis se van creando como en una pila LIFO}
var
  blk: TxpSynBlock;
begin
  blk := TxpSynBlock.Create;
  blk.id := blkId;
  blocks.Add(blk);
end;
procedure TxpEleCodeCont.CloseBlock;
{Quita el último bloque de sintaxis agregado.}
begin
  if blocks.Count=0 then exit;
  blocks.Delete(blocks.Count-1);  //quita el último
end;
function TxpEleCodeCont.CurrBlock: TxpSynBlock;
{Devuelve la referencia al último bloque agregado. Si no se ha agregado algún bloque,
devuelve NIL}
begin
  if blocks.Count=0 then exit(nil);
  exit(blocks[blocks.Count-1])
end;
function TxpEleCodeCont.CurrBlockID: TxpSynBlockId;
begin
  if blocks.Count=0 then exit(sbiNULL);
  Result := CurrBlock.id;
end;
//Inicialización
procedure TxpEleCodeCont.Clear;
begin
  inherited Clear;
  blocks.Clear;
  lstExitCalls.Clear;
end;
constructor TxpEleCodeCont.Create;
begin
  inherited Create;
  idClass:=eltCodeCont;
  blocks := TxpSynBlocks.Create(true);
  lstExitCalls:= TxpExitCalls.Create(true);
end;
destructor TxpEleCodeCont.Destroy;
begin
  lstExitCalls.Destroy;
  blocks.Destroy;
  inherited Destroy;
end;
{ TxpEleCon }
constructor TxpEleCon.Create;
begin
  inherited;
  idClass:=eltCons;
end;
{ TxpEleVar }
function TxpEleVar.Gettyp: TxpEleType;
begin
  if ftyp.copyOf<>nil then Result := ftyp.copyOf else Result := ftyp;
end;
procedure TxpEleVar.Settyp(AValue: TxpEleType);
begin
  ftyp := AValue;
end;

function TxpEleVar.adrBit: TPicRegisterBit;
begin
  adrBitTmp.addr := addr0;
  adrBitTmp.bit  := bit0;;
  Result := adrBitTmp;
end;
function TxpEleVar.adrByte0: TPicRegister;
begin
  adrByteTmp.addr := addr0;
  Result := adrByteTmp;
end;
function TxpEleVar.adrByte1: TPicRegister;
begin
  adrByteTmp.addr := addr1;
  Result := adrByteTmp;
end;
function TxpEleVar.adrByte2: TPicRegister;
begin
  adrByteTmp.addr := addr2;
  Result := adrByteTmp;
end;
function TxpEleVar.adrByte3: TPicRegister;
begin
  adrByteTmp.addr := addr3;
  Result := adrByteTmp;
end;

function TxpEleVar.bank: TVarBank;
{Devuelve el banco de memoria en donde se ubica la variable actual. Asumiendo que toda
la variables se ubica en el mismo banco.}
begin
  Result := addr0 >> 7;  //La variable siempre empieza en "addr0"
end;
function TxpEleVar.offs: TVarOffs;
{Devuelve la dirección de inicio, en donde empieza a almacenarse la variable.}
begin
  Result := addr0 and $7F;  //La variable siempre empieza en "addr0"
end;
function TxpEleVar.addr: word;
{Devuelve la dirección absoluta de la variable. Tener en cuenta que la variable, no
siempre tiene un solo byte, así que se trata de devolver siempre la dirección del
byte de menor peso.}
begin
  if typ.catType = tctAtomic then begin
    //Tipo básico
    Result := addr0;
  end else if typ.catType = tctArray then begin
    //Arreglos
    Result := addr0;
  end else if typ.catType = tctPointer then begin
    //Los punteros cortos son como bytes
    Result := addr0;
  end else begin
    //No soportado
    Result := ADRR_ERROR;
  end;
end;
function TxpEleVar.addrL: word;
{Dirección absoluta de la variable de menor pero, cuando es de tipo WORD.}
begin
  if typ.catType = tctAtomic then begin
    Result := addr0;
  end else begin
    //No soportado
    Result := ADRR_ERROR;
  end;
end;
function TxpEleVar.addrH: word;
{Dirección absoluta de la variable de mayor pero, cuando es de tipo WORD.}
begin
  if typ.catType = tctAtomic then begin
    Result := addr1;
  end else begin
    //No soportado
    Result := ADRR_ERROR;
  end;
end;
function TxpEleVar.addrE: word;
begin
  if typ.catType = tctAtomic then begin
    Result := addr2;
  end else begin
    //No soportado
    Result := ADRR_ERROR;
  end;
end;
function TxpEleVar.addrU: word;
begin
  if typ.catType = tctAtomic then begin
    Result := addr3;
  end else begin
    //No soportado
    Result := ADRR_ERROR;
  end;
end;
function TxpEleVar.AddrString: string;
{Devuelve una cadena, que representa a la dirección física.}
begin
  if typ.IsBitSize then begin
    Result := 'bnk'+ IntToStr(adrBit.bank) + ':$' + IntToHex(adrBit.offs, 3) + '.' + IntToStr(adrBit.bit);
  end else if typ.IsByteSize then begin
    Result := 'bnk'+ IntToStr(adrByte0.bank) + ':$' + IntToHex(adrByte0.offs, 3);
  end else if typ.IsWordSize then begin
    Result := 'bnk'+ IntToStr(adrByte0.bank) + ':$' + IntToHex(adrByte0.offs, 3);
  end else if typ.IsDWordSize then begin
    Result := 'bnk'+ IntToStr(adrByte0.bank) + ':$' + IntToHex(adrByte0.offs, 3);
  end else begin
    Result := '';   //Error
  end;
end;
function TxpEleVar.BitMask: byte;
{Devuelve la máscara, de acuerdo a su valor de "bit".}
begin
  Result := 0;
  case adrBit.bit of
  0: Result := %00000001;
  1: Result := %00000010;
  2: Result := %00000100;
  3: Result := %00001000;
  4: Result := %00010000;
  5: Result := %00100000;
  6: Result := %01000000;
  7: Result := %10000000;
  end;
end;
procedure TxpEleVar.ResetAddress;
begin
  addr0 := 0;
  bit0 := 0;

end;
constructor TxpEleVar.Create;
begin
  inherited;
  idClass:=eltVar;
  adrBitTmp  := TPicRegisterBit.Create;  //
  adrByteTmp := TPicRegister.Create;
end;
destructor TxpEleVar.Destroy;
begin
  adrBitTmp.Destroy;
  adrByteTmp.Destroy;
  inherited Destroy;
end;

{ TxpOperator }
function TxpOperator.CreateOperation(OperandType: TxpEleType;
  proc: TProcBinaryROB): TxpOperation;
var
  r: TxpOperation;
begin
  //agrega
    r := TxpOperation.Create;
  r.ToType:=OperandType;
  r.proc:=proc;
  r.parent := self;
  //agrega
  operations.Add(r);
  Result := r;
end;
function TxpOperator.FindOperation(typ0: TxpEleType): TxpOperation;
{Busca, si encuentra definida, alguna operación, de este operador con el tipo indicado.
Si no lo encuentra devuelve NIL}
var
  r: TxpOperation;
begin
  Result := nil;
  for r in Operations do begin
    if r.ToType = typ0 then begin
      exit(r);
    end;
  end;
end;
function TxpOperator.OperationString: string;
begin
  Result := parent.name + ' ' + self.txt;  //Post?
end;
constructor TxpOperator.Create;
begin
  Operations := TxpOperations.Create(true);
end;
destructor TxpOperator.Destroy;
begin
  Operations.Free;
  inherited Destroy;
end;
function TxpEleType.getSize: smallint;
var
  lastAttrib: TTypAttrib;
begin
  if catType = tctArray then begin
    //Array size is calculated
    if nItems = -1 then exit(0) else exit(itmType.size * nItems);
  end else if catType = tctPointer then begin
    exit(1);  //Pointer are like bytes
  end else if catType = tctObject then begin
    if attribs.Count = 0 then exit(0);
    lastAttrib := attribs[attribs.Count-1];
    exit(lastAttrib.offs + lastAttrib.typ.size);  //
  end else begin
    exit(fSize)
  end;
end;
procedure TxpEleType.setSize(AValue: smallint);
begin
  fSize := AValue;
end;
{ TxpEleType }
function TxpEleType.CreateBinaryOperator(txt: string; prec: byte; OpName: string
  ): TxpOperator;
{Permite crear un nuevo ooperador binario soportado por este tipo de datos. Si hubiera
error, devuelve NIL. En caso normal devuelve una referencia al operador creado}
var
  r: TxpOperator;  //operador
begin
  //verifica nombre
  if FindBinaryOperator(txt)<>nullOper then begin
    Result := nil;  //indica que hubo error
    exit;
  end;
  //Crea y configura objeto
  r := TxpOperator.Create;
  r.txt    := txt;
  r.prec   := prec;
  r.name   := OpName;
  r.kind   := opkBinary;
  r.parent := self;;
  //Agrega operador
  Operators.Add(r);
  Result := r;
  //Verifica si es el operador de asignación
  if txt = ':=' then begin
    //Lo guarda porque este operador se usa y no vale la pena buscarlo
    operAsign := r;
  end;
end;
function TxpEleType.CreateUnaryPreOperator(txt: string; prec: byte; OpName: string;
  proc: TProcExecOperat): TxpOperator;
{Crea operador unario de tipo Pre, para este tipo de dato.}
var
  r: TxpOperator;  //operador
begin
  //Crea y configura objeto
  r := TxpOperator.Create;
  r.txt:=txt;
  r.prec:=prec;
  r.name:=OpName;
  r.kind:=opkUnaryPre;
  r.OperationPre:=proc;
  //Agrega operador
  Operators.Add(r);
  Result := r;
end;
function TxpEleType.CreateUnaryPostOperator(txt: string; prec: byte; OpName: string;
  proc: TProcExecOperat): TxpOperator;
{Crea operador binario de tipo Post, para este tipo de dato.}
var
  r: TxpOperator;  //operador
begin
  //Crea y configura objeto
  r := TxpOperator.Create;
  r.txt:=txt;
  r.prec:=prec;
  r.name:=OpName;
  r.kind:=opkUnaryPost;
  r.OperationPost:=proc;
  //Agrega operador
  Operators.Add(r);
  Result := r;
end;
function TxpEleType.FindBinaryOperator(const OprTxt: string): TxpOperator;
{Recibe el texto de un operador y devuelve una referencia a un objeto TxpOperator, del
tipo. Si no está definido el operador para este tipo, devuelve nullOper.}
var
  oper: TxpOperator;
begin
//  if copyOf<>nil then begin  //Es copia, pasa a la copia
//    exit(copyOf.FindBinaryOperator(OprTxt));
//  end;
  /////////////////////////////////////////////////////////
  Result := nullOper;   //valor por defecto
  for oper in Operators do begin
    if (oper.kind = opkBinary) and (oper.txt = upCase(OprTxt)) then begin
      exit(oper); //está definido
    end;
  end;
  //No encontró
  Result.txt := OprTxt;    //para que sepa el operador leído
end;
function TxpEleType.FindUnaryPreOperator(const OprTxt: string): TxpOperator;
{Recibe el texto de un operador unario Pre y devuelve una referencia a un objeto
TxpOperator, del tipo. Si no está definido el operador para este tipo, devuelve nullOper.}
var
  oper: TxpOperator;
begin
//  if copyOf<>nil then begin  //Es copia, pasa a la copia
//    exit(copyOf.FindUnaryPreOperator(OprTxt));
//  end;
  /////////////////////////////////////////////////////////
  Result := nullOper;   //valor por defecto
  for oper in Operators do begin
    if (oper.kind = opkUnaryPre) and (oper.txt = upCase(OprTxt)) then begin
      exit(oper); //está definido
    end;
  end;
  //no encontró
  Result.txt := OprTxt;    //para que sepa el operador leído
end;
function TxpEleType.FindUnaryPostOperator(const OprTxt: string): TxpOperator;
{Recibe el texto de un operador unario Post y devuelve una referencia a un objeto
TxpOperator, del tipo. Si no está definido el operador para este tipo, devuelve nullOper.}
var
  oper: TxpOperator;
begin
//  if copyOf<>nil then begin  //Es copia, pasa a la copia
//    exit(copyOf.FindUnaryPostOperator(OprTxt));
//  end;
  /////////////////////////////////////////////////////////
  Result := nullOper;   //valor por defecto
  for oper in Operators do begin
    if (oper.kind = opkUnaryPost) and (oper.txt = upCase(OprTxt)) then begin
      exit(oper); //está definido
    end;
  end;
  //no encontró
  Result.txt := OprTxt;    //para que sepa el operador leído
end;
procedure TxpEleType.SaveToStk;
begin
  if OnSaveToStk<>nil then OnSaveToStk;
end;

procedure TxpEleType.CreateField(metName: string; procGet,
  procSet: TTypFieldProc);
{Crea una función del sistema. A diferencia de las funciones definidas por el usuario,
una función del sistema se crea, sin crear espacios de nombre. La idea es poder
crearlas rápidamente.}
var
  fun : TTypField;
begin
  fun := TTypField.Create;  //Se crea como una función normal
  fun.Name := metName;
  fun.procGet := procGet;
  fun.procSet := procSet;
//no verifica duplicidad
  fields.Add(fun);
end;
function TxpEleType.IsBitSize: boolean;
{Indica si el tipo, tiene 1 bit de tamaño}
begin
//  if copyOf<>nil then exit(copyOf.IsBitSize);  //verifica
  Result := size = -1;
end;
function TxpEleType.IsByteSize: boolean;
{Indica si el tipo, tiene 1 byte de tamaño}
begin
//  if copyOf<>nil then exit(copyOf.IsByteSize);  //verifica
  Result := size = 1;
end;
function TxpEleType.IsWordSize: boolean;
{Indica si el tipo, tiene 2 bytes de tamaño}
begin
//  if copyOf<>nil then exit(copyOf.IsWordSize);  //verifica
  Result := size = 2;
end;
function TxpEleType.IsDWordSize: boolean;
{Indica si el tipo, tiene 4 bytes de tamaño}
begin
//  if copyOf<>nil then exit(copyOf.IsDWordSize);  //verifica
  Result := size = 4;
end;
procedure TxpEleType.DefineRegister;
{Define los registros que va a usar el tipo de dato.}
begin
  if OnDefRegister<>nil then OnDefRegister;
end;

function TxpEleType.IsArrayOf(itTyp: TxpEleType; numIt: integer): boolean;
{Indicates if this type is an array of the specified type and with the specified
number of elements.}
begin
  exit( (catType = tctArray) and (nItems = numIt) and itmType.IsEquivalent(itTyp)  );
end;
function TxpEleType.IsPointerTo(ptTyp: TxpEleType): boolean;
begin
  exit( (catType = tctPointer) and ptrType.IsEquivalent(ptTyp) );
end;
function TxpEleType.IsEquivalent(typ: TxpEleType): boolean;
{Indicates if the type is the same type as the specified or has the same definition.}
begin
  if self = typ then exit(true);
  if catType <> typ.catType then exit(false);
  //Have the same category
  if (self.copyOf = typ) or (typ.copyOf = self) then exit(true);
  if (self.copyOf<>nil) and (self.copyOf = typ.copyOf) then exit(true);
  if catType = tctArray then begin
    //Equivalence for arrays
    if (self.nItems = typ.nItems) and itmType.IsEquivalent(typ.itmType) then exit(true);
  end else if catType = tctPointer then begin
    //Equivalence for pointers
    if (self.ptrType.IsEquivalent(typ.ptrType)) then exit(true);
  end;
  exit(false);
end;

constructor TxpEleType.Create;
begin
  inherited;
  idClass:=eltType;
  //Create list of methods
  fields:= TTypFields.Create(true);
  //Create list of attributes
  attribs:= TTypATtributes.Create(true);
  //Ceeate list of operators
  Operators := TxpOperators.Create(true);  //Operators apllyed to this type
  internalTypes:= TxpEleTypes.Create(true);
end;
destructor TxpEleType.Destroy;
begin
  internalTypes.Destroy;
  Operators.Destroy;
  attribs.Destroy;
  fields.Destroy;
  inherited;
end;
{ TxpEleMain }
constructor TxpEleMain.Create;
begin
  inherited;
  idClass:=eltMain;
  Parent := nil;  //la raiz no tiene padre
end;
{ TxpEleFun }
function TxpEleFunBase.SameParamsType(const funpars: TxpParFuncArray): boolean;
{Compara los parámetros de la función con una lista de parámetros. Si tienen el mismo
número de parámetros y el mismo tipo, devuelve TRUE.}
var
  i: Integer;
begin
  Result:=true;   //We assume they are the same
  if High(pars) <> High(funpars) then
    exit(false);   //Distinct parameters number
  //They have the same numbers of parameters, verify:
  for i := 0 to High(pars) do begin
    if pars[i].typ <> funpars[i].typ then begin
      exit(false);
    end;
  end;
  //si llegó hasta aquí, hay coincidencia, sale con TRUE
end;
procedure TxpEleFunBase.ClearParams;
//Elimina los parámetros de una función
begin
  setlength(pars,0);
end;
function TxpEleFunBase.ParamTypesList: string;
{Devuelve una lista con los nombres de los tipos de los parámetros, de la forma:
(byte, word) }
var
  tmp: String;
  j: Integer;
begin
  tmp := '';
  for j := 0 to High(pars) do begin
    tmp += pars[j].name+', ';
  end;
  //quita coma final
  if length(tmp)>0 then tmp := copy(tmp,1,length(tmp)-2);
  Result := '('+tmp+')';
end;
procedure TxpEleFun.SetElementsUnused;
{Marca todos sus elementos con "nCalled = 0". Se usa cuando se determina que una función
no es usada.}
var
  elem: TxpElement;
begin
  if elements = nil then exit;  //No tiene
  //Marca sus elementos, como no llamados
  for elem in elements do begin
    elem.ClearCallers;
    if elem.idClass = eltVar then begin
      TxpEleVar(elem).ResetAddress;
    end;
  end;
end;
function TxpEleFun.HasDeclar: boolean;
begin
  exit(declar<>nil);
end;
function TxpEleFun.nCalled: integer;
begin
  if IsInterrupt then exit(1);   //Los INTERRUPT son llamados implícitamente
  Result := inherited nCalled;
end;
function TxpEleFun.nLocalVars: integer;
{Devuelve el número de variables locales de la función.}
var
  elem : TxpElement;
begin
  Result := 0;
  for elem in elements do begin
    if elem.idClass = eltVar then inc(Result);
  end;
end;
function TxpEleFun.IsTerminal: boolean;
{Indica si la función ya no llama a otras funciones. Para que funcione, se debe haber
llenado primero, "lstCalled".}
begin
  Result := (lstCalled.Count = 0);
end;
function TxpEleFun.IsTerminal2: boolean;
{Indica si la función es Terminal, en el sentido que cumple:
- Tiene variables locales.
- No llama a otras funciones o las funciones a las que llama no tienen variables locales.
Donde "Variables" locales, se refiere también a parámetros del procedimiento.}
var
  called   : TxpElement;
  nCallesFuncWithLocals: Integer;
begin
  if nLocalVars = 0 then exit(false);
  //Tiene variables locales
  //Verifica llamada a funciones
  nCallesFuncWithLocals := 0;
  for called in lstCalledAll do begin
    if called.idClass = eltFunc then begin
      if TxpEleFun(called).nLocalVars > 0 then inc(nCallesFuncWithLocals);
    end;
  end;
  if nCallesFuncWithLocals = 0 then begin
    //Todas las funciones a las que llama, no tiene variables locales
    exit(true);
  end else begin
    exit(false);
  end;
end;
const CONS_ITEM_BLOCK = 10;

procedure TxpEleFun.AddAddresPend(ad: word);
{Add a pending address to the function to be completed later.}
begin
  addrsPend[nAddresPend] := ad;
  inc(nAddresPend);
  if nAddresPend > curSize then begin
    curSize += CONS_ITEM_BLOCK;   //Increase size by block
    setlength(addrsPend, curSize);  //make space
  end;
end;

//Inicialización
constructor TxpEleFun.Create;
begin
  inherited;
  idClass:=eltFunc;
  //Init addrsPend[]
  nAddresPend := 0;
  curSize := CONS_ITEM_BLOCK;   //Block size
  setlength(addrsPend, curSize);  //initial size
end;
destructor TxpEleFun.Destroy;
begin
  inherited Destroy;
end;

{ TxpEleInlin }
procedure TxpEleInlin.ClearParams;
//Elimina los parámetros de una función
begin
  setlength(pars,0);
end;
procedure TxpEleInlin.CreateParam(parName: string; typ0: TxpEleType;
  sto0: TStoOperand);
//Crea un parámetro para la función
var
  n: Integer;
begin
  //agrega
  n := high(pars)+1;
  setlength(pars, n+1);
  pars[n].name := parName;
  pars[n].typ  := typ0;  //agrega referencia
  pars[n].sto  := sto0;  //captura almacenamiento
end;
function TxpEleInlin.SameParamsType(const funpars: TxpParInlinArray): boolean;
{Compara los parámetros de la función con las de otra. Si tienen el mismo número
de parámetros, el mismo tipo y almacenamiento, devuelve TRUE.}
var
  i: Integer;
begin
  Result:=true;  //se asume que son iguales
  if High(pars) <> High(funpars) then
    exit(false);   //distinto número de parámetros
  //hay igual número de parámetros, verifica
  for i := 0 to High(pars) do begin
    if pars[i].typ <> funpars[i].typ then begin
      exit(false);
    end;
    //Estos parámetros tienen el mismo tipo
    if pars[i].sto<> funpars[i].sto then begin
      exit(false);  //Pero otro almacenamiento
    end;
  end;
  //si llegó hasta aquí, hay coincidencia, sale con TRUE
end;
function TxpEleInlin.Duplicated: boolean;
{Revisa la duplicidad de la función en su entorno. La función ya debe estar ingresada al
árbol de sintaxis.  *******  ¿Realmente se usa?}
var
  ele: TxpElement;
begin
  for ele in parent.elements do begin
    if ele = self then Continue;  //no se compara el mismo
    if ele.uname = uname then begin
      //hay coincidencia de nombre
      if ele.idClass = eltInLin then begin
        //para las funciones, se debe comparar los parámetros
        if SameParamsType(TxpEleInlin(ele).pars) then begin
          exit(true);
        end;
      end else begin
        //si tiene el mismo nombre que cualquier otro elemento, es conflicto
        exit(true);
      end;
    end;
  end;
  exit(false);
end;
constructor TxpEleInlin.Create;
begin
  inherited Create;
  idClass:=eltInLin;
end;
destructor TxpEleInlin.Destroy;
begin
  inherited Destroy;
end;

{ TxpEleFunDec }
constructor TxpEleFunDec.Create;
begin
  inherited Create;
  idClass:=eltFuncDec;
end;


procedure TxpEleUnit.ReadInterfaceElements;
{Actualiza la lista "InterfaceElements", con los elementos accesibles desde la
sección INTERFACE.}
var
  ele: TxpElement;
begin
  InterfaceElements.Clear;
  if elements = nil then exit;
  //Solo basta explorar a un nivel
  for ele in elements do begin
    if ele.location = locInterface then begin
       InterfaceElements.Add(ele);
    end;
  end;
end;
{ TxpEleUnit }
constructor TxpEleUnit.Create;
begin
  inherited;
  idClass:=eltUnit;
  InterfaceElements:= TxpElements.Create(false);
end;
destructor TxpEleUnit.Destroy;
begin
  InterfaceElements.Destroy;
  inherited Destroy;
end;
{ TxpEleBody }
constructor TxpEleBody.Create;
begin
  inherited;
  idClass := eltBody;
end;
destructor TxpEleBody.Destroy;
begin
  inherited Destroy;
end;
{ TxpEleFinal }
constructor TxpEleFinal.Create;
begin
  inherited Create;
  idClass := eltFinal;
end;
destructor TxpEleFinal.Destroy;
begin
  inherited Destroy;
end;

{ TxpEleDIREC }
constructor TxpEleDIREC.Create;
begin
  inherited Create;
  idClass := eltBody;
end;
{ TXpTreeElements }
procedure TXpTreeElements.Clear;
begin
  main.elements.Clear;  //esto debe hacer un borrado recursivo
  main.Clear;

  curNode := main;      //retorna al nodo principal
  //ELimina lista internas
  AllCons.Clear;
  AllVars.Clear;
  AllUnits.Clear;
  AllFuncs.Clear;
  AllTypes.Clear;
end;
{********* No se utilizan ya estos métodos porque se está agregando código de
identificación en TXpTreeElements.AddElement().
procedure TXpTreeElements.RefreshAllCons;
{Devuelve una lista de todas las constantes del árbol de sintaxis, incluyendo las de las
funciones y procedimientos. La lista se obtiene ordenada de acuerdo a como se haría en
una exploración sintáctica normal.}
  procedure AddCons(nod: TxpElement);
  var
    ele : TxpElement;
  begin
    if nod.elements<>nil then begin
      for ele in nod.elements do begin
        if ele.idClass = eltCons then begin
          AllCons.Add(TxpEleCon(ele));
        end else begin
          if ele.elements<>nil then
            AddCons(ele);  //recursivo
        end;
      end;
    end;
  end;
begin
  AllCons.Clear;   //por si estaba llena
  AddCons(main);
end;
procedure TXpTreeElements.RefreshAllVars;
{Devuelve una lista de todas las variables del árbol de sintaxis, incluyendo las de las
funciones y procedimientos. La lista se obtiene ordenada de acuerdo a como se haría en
una exploración sintáctica normal.}
  procedure AddVars(nod: TxpElement);
  var
    ele : TxpElement;
  begin
    if nod.elements<>nil then begin
      for ele in nod.elements do begin
        if ele.idClass = eltVar then begin
          AllVars.Add(TxpEleVar(ele));
        end else begin
          if ele.elements<>nil then
            AddVars(ele);  //recursivo
        end;
      end;
    end;
  end;
begin
  AllVars.Clear;   //por si estaba llena
  AddVars(main);
end;
procedure TXpTreeElements.RefreshAllFuncs;
{Actualiza una lista de todas las funciones del árbol de sintaxis, incluyendo las de las
unidades.}
  procedure AddFuncs(nod: TxpElement);
  var
    ele : TxpElement;
  begin
    if nod.elements<>nil then begin
      for ele in nod.elements do begin
        if ele.idClass = eltFunc then begin
          AllFuncs.Add(TxpEleFun(ele));
        end else begin
          if ele.elements<>nil then
            AddFuncs(ele);  //recursivo
        end;
      end;
    end;
  end;
begin
  AllFuncs.Clear;   //por si estaba llena
  AddFuncs(main);
end;
procedure TXpTreeElements.RefreshAllTypes;
{Devuelve una lista de todas las constantes del árbol de sintaxis, incluyendo las de las
funciones y procedimientos. La lista se obtiene ordenada de acuerdo a como se haría en
una exploración sintáctica normal.}
  procedure AddTypes(nod: TxpElement);
  var
    ele : TxpElement;
  begin
    if nod.elements<>nil then begin
      for ele in nod.elements do begin
        if ele.idClass = eltType then begin
          AllTypes.Add(TxpEleType(ele));
        end else begin
          if ele.elements<>nil then
            AddTypes(ele);  //recursivo
        end;
      end;
    end;
  end;
begin
  AllTypes.Clear;   //por si estaba llena
  AddTypes(main);
end;
}
procedure TXpTreeElements.RefreshAllUnits;
var
  ele : TxpElement;
begin
  AllUnits.Clear;   //por si estaba llena
  for ele in main.elements do begin
    if ele.idClass = eltUnit then begin
       AllUnits.Add( TxpEleUnit(ele) );
    end;
  end;
end;
function TXpTreeElements.CurNodeName: string;
{Devuelve el nombre del nodo actual}
begin
  Result := curNode.name;
end;
function TXpTreeElements.CurCodeContainer: TxpEleCodeCont;
{Devuelve una referencia al Contenedor de Cñodigo actual. Si no lo identifica,
devuelve NIL}
begin
  case curNode.idClass of
  eltFunc, eltMain, eltUnit: begin
    {Este es un caso directo, porque estamos directamente en un contenedor de código.
    No es común proque en este ámbito solo están las declaraciones, no el código}
    exit( TxpEleCodeCont(curNode) );
  end;
  eltBody: begin
    {Este es el caso mas común porque aquí si estamos dentro de un bloque que incluye
    código.}
    //Se supone que nunca debería fallar, porque un Body siempre pertenece a un CodeCont
    exit( TxpEleCodeCont(curNode.Parent) );
  end;
  else
    exit(nil);
  end;
end;
function TXpTreeElements.LastNode: TxpElement;
{Devuelve una referencia al último nodo de "main"}
begin
  Result := main.LastNode;
end;
function TXpTreeElements.BodyNode: TxpEleBody;
{Devuelve la referencia al cuerpo principal del programa.}
begin
  Result := main.BodyNode;
end;
//funciones para llenado del arbol
procedure TXpTreeElements.AddElement(elem: TxpElement; AtBegin: boolean = false);
{Add a new element to the current node. Commonly elements are add at the end of the list
unless "AtBegin" is TRUE.
This is the unique entry point to add elements to the Syntax Tree.}
begin
  //Agrega el nodo
  curNode.AddElement(elem, AtBegin);
  if OnAddElement<>nil then OnAddElement(elem);
  //Update Lists
  case elem.idClass of
  eltCons: AllCons.Add(TxpEleCon(elem));
  eltVar : AllVars.Add(TxpEleVar(elem));
  eltFunc: AllFuncs.Add(TxpEleFun(elem)); //Declarations are now stored in AllFuncs.
  eltType: AllTypes.Add(TxpEleType(elem));
  eltInLin: AllInLns.Add(TxpEleInlin(elem));
  //No se incluye el código de RefreshAllUnits() porque solo trabaja en el "main".
  end;
end;
procedure TXpTreeElements.AddElementAndOpen(elem: TxpElement);
{Agrega un elemento y cambia el nodo actual al espacio de este elemento nuevo. Este
método está reservado para las funciones o procedimientos}
begin
  {las funciones o procedimientos no se validan inicialmente, sino hasta que
  tengan todos sus parámetros agregados, porque pueden ser sobrecargados.}
  AddElement(elem);
  //Genera otro espacio de nombres
  elem.elements := TxpElements.Create(true);  //su propia lista
  curNode := elem;  //empieza a trabajar en esta lista
end;
procedure TXpTreeElements.AddElementParent(elem: TxpElement; AtBegin: boolean);
{Add element to the parent of the current element.}
var
  tmp: TxpElement;
begin
  tmp := curNode;  //Save currente node
  curNode := curNode.Parent;  //Set to parent
  AddElement(elem, AtBegin);  //Add type at the beginning
  curNode := tmp;  //Restore position
end;
procedure TXpTreeElements.OpenElement(elem: TxpElement);
{Accede al espacio de nombres del elemento indicado.}
begin
  curNode := elem;  //empieza a trabajar en esta lista
end;
procedure TXpTreeElements.CloseElement;
{Sale del nodo actual y retorna al nodo padre}
begin
  if curNode.Parent<>nil then
    curNode := curNode.Parent;
end;
//Métodos para identificación de nombres
function TXpTreeElements.FindNext: TxpElement;
{Realiza una búsqueda recursiva en el nodo "curFindNode", a partir de la posición,
"curFindIdx", hacia "atrás", el elemento con nombre "curFindName". También implementa
la búsqueda en unidades.
Esta rutina es quien define la resolución de nombres (alcance) en PicPas.}
var
  elem: TxpElement;
begin
//  debugln(' Explorando nivel: [%s] en pos: %d', [curFindNode.name, curFindIdx - 1]);
  repeat
    curFindIdx := curFindIdx - 1;  //Siempre salta a la posición anterior
    if curFindIdx<0 then begin
      //No encontró, en ese nivel. Hay que ir más atrás. Pero esto se resuelve aquí.
      if curFindNode.Parent = nil then begin
        //No hay nodo padre. Este es el nodo Main
        Result := nil;
        exit;  //aquí termina la búsqueda
      end;
      //Busca en el espacio padre
      curFindIdx := curFindNode.Index;  //posición actual
      curFindNode := curFindNode.Parent;  //apunta al padre
      if inUnit then inUnit := false;   //Sale de una unidad
      Result := FindNext();  //Recursividad IMPORTANTE: Usar paréntesis.
//      Result := nil;
      exit;
    end;
    //Verifica ahora este elemento
    elem := curFindNode.elements[curFindIdx];
    if inUnit and (elem.location = locImplement) then begin
      //No debería ser accesible
      continue;
    end;
    //Genera evento para indicar que está buscando.
    if OnFindElement<>nil then OnFindElement(elem);
    //Compara
    if (curFindName = '') or (elem.uname = curFindName) then begin
      //Encontró en "curFindIdx"
      Result := elem;
      //La siguiente búsqueda empezará en "curFindIdx-1".
      exit;
    end else begin
      //No tiene el mismo nombre, a lo mejor es una unidad
      if (elem.idClass = eltUnit) and not inUnit then begin   //Si es el priemr nodo de unidad
        //¡Diablos es una unidad! Ahora tenemos que implementar la búsqueda.
        inUnit := true;   //Marca, para que solo busque en un nivel
        curFindIdx := elem.elements.Count;  //para que busque desde el último
        curFindNode := elem;  //apunta a la unidad
        Result := FindNext();  //Recursividad IMPORTANTE: Usar paréntesis.
        if Result <> nil then begin  //¿Ya encontró?
          exit;  //Sí. No hay más que hacer aquí
        end;
        //No encontró. Hay que seguir buscando
      end;
    end;
  until false;
end;
function TXpTreeElements.FindFirst(const name: string): TxpElement;
{Routine to resolve an identifier inside the SyntaxTree, following the scope rules for
identifiers of the Pascal syntax (first the current space and then the parents spaces).
If found returns the reference to the element otherwise returns NIL.
If "name" is empty string, all the elements, of the Syntax Tree, will be scanned.}
begin
  //Busca recursivamente, a partir del espacio actual
  curFindName := UpCase(name);     //This value won't change in all the search
  inUnit := false;     //Inicia bandera
  if curNode.idClass = eltBody then begin
    {Para los cuerpos de procemientos o de programa, se debe explorar hacia atrás a
    partir de la posición del nodo actual.}
    curFindIdx := curNode.Index;  //Ubica posición
    curFindNode := curNode.Parent;  //Actualiza nodo actual de búsqueda
    Result := FindNext;
  end else begin
    {La otras forma de resolución, debe ser:
    1. Declaración de constantes, cuando se definen como expresión con otras constantes
    2. Declaración de variables, cuando se definen como ABSOLUTE <variable>
    3. Declaración de variables, cuando se definen de un tipo definido en TYPES.
    }
    curFindNode := curNode;  //Actualiza nodo actual de búsqueda
    {Formalmente debería apuntar a la posición del elemento actual, pero se deja
    apuntando a la posición final, sin peligro, porque, la resolución de nombres para
    constantes y variables, se hace solo en la primera pasada (con el árbol de sintaxis
    llenándose.)}
    curFindIdx := curNode.elements.Count;
    //Busca
    Result := FindNext;
  end;
end;
function TXpTreeElements.FindNextFuncName: TxpEleFun;
{Explora recursivamente haciá la raiz, en el arbol de sintaxis, hasta encontrar el nombre
de la fución indicada. Debe llamarse después de FindFirst().
Si no enecuentra devuelve NIL.}
var
  ele: TxpElement;
begin
  repeat
    ele := FindNext;
  until (ele=nil) or (ele.idClass = eltFunc);
  //Puede que haya encontrado la función o no
  if ele = nil then exit(nil);  //No encontró
  Result := TxpEleFun(ele);   //devuelve como función
end;

function TXpTreeElements.FindFirstType: TxpEleType;
{Starts the search for a element type in the syntax Tree.}
var
  ele: TxpElement;
begin
  ele := FindFirst('');
  while (ele<>nil) and (ele.idClass <> eltType) do begin
    ele := FindNext;
  end;
  if ele = nil then exit(nil) else exit( TxpEleType(ele) );
end;
function TXpTreeElements.FindNextType: TxpEleType;
{Scan recursively toward root, in the syntax tree, until find a type element.
Must be called after calling FindFirst(). If not found, returns NIL.}
var
  ele: TxpElement;
begin
  repeat
    ele := FindNext;
  until (ele=nil) or (ele.idClass = eltType);
  //Puede que haya encontrado la función o no
  if ele = nil then exit(nil);  //No encontró
  Result := TxpEleType(ele);   //devuelve como función
end;

function TXpTreeElements.FindVar(varName: string): TxpEleVar;
{Busca una variable con el nombre indicado en el espacio de nombres actual}
var
  ele : TxpElement;
  uName: String;
begin
  uName := upcase(varName);
  for ele in curNode.elements do begin
    if (ele.idClass = eltVar) and (upCase(ele.name) = uName) then begin
      Result := TxpEleVar(ele);
      exit;
    end;
  end;
  exit(nil);
end;
function TXpTreeElements.FindType(typName: string): TxpEleType;
{Find a type, by name, in the current element of the Synyax Tree.}
var
  ele: TxpElement;
begin
  ele := FindFirst(typName);
//  while (ele<>nil) and (ele.idClass <> eltType) do begin
//    ele := FindNext;
//  end;
  if ele = nil then exit(nil);
  if ele.idClass = eltType then exit( TxpEleType(ele) ) else exit(nil);
end;

function TXpTreeElements.ExistsArrayType(itemType: TxpEleType; nEle: integer;
  out typFound: TxpEleType): boolean;
{Finds an array type declaration, accesible from the current position in the syntax tree.
If found, returns TRUE and the type reference in "typFound".}
begin
  typFound := FindFirstType;
  while (typFound <> nil) and not typFound.IsArrayOf(itemType, nEle) do begin
    typFound := FindNextType;
  end;
  //Verify result
  Result := typFound <> nil;
end;
function TXpTreeElements.ExistsPointerType(ptrType: TxpEleType; out
  typFound: TxpEleType): boolean;
{Finds a pointer type declaration, accesible from the current position in the syntax tree.
If found, returns TRUE and the type reference in "typFound".}
begin
  typFound := FindFirstType;
  while (typFound <> nil) and not typFound.IsPointerTo(ptrType) do begin
    typFound := FindNextType;
  end;
  //Verify result
  Result := typFound <> nil;
end;

function TXpTreeElements.GetElementBodyAt(posXY: TPoint): TxpEleBody;
{Busca en el árbol de sintaxis, dentro del nodo principal, y sus nodos hijos, en qué
cuerpo (nodo Body) se encuentra la coordenada del cursor "posXY".
Si no encuentra, devuelve NIL.}
var
  res: TxpEleBody;

  procedure ExploreForBody(nod: TxpElement);
  var
    ele : TxpElement;
  begin
    if nod.elements<>nil then begin
      //Explora a todos sus elementos
      for ele in nod.elements do begin
        if ele.idClass = eltBody then begin
          //Encontró un Body, verifica
          if ele.posXYin(posXY) then begin
            res := TxpEleBody(ele);   //guarda referencia
            exit;
          end;
        end else begin
          //No es un body, puede ser un elemento con nodos hijos
          if ele.elements<>nil then
            ExploreForBody(ele);  //recursivo
        end;
      end;
    end;
  end;
begin
  //Realiza una búsqueda recursiva.
  res := nil;   //Por defecto
  ExploreForBody(main);
  Result := res;
end;
function TXpTreeElements.GetElementAt(posXY: TPoint): TxpElement;
{Busca en el árbol de sintaxis, en qué nodo Body se encuentra la coordenada del
cursor "posXY". Si no encuentra, devuelve NIL.}
var
  res: TxpEleBody;

  procedure ExploreFor(nod: TxpElement);
  var
    ele : TxpElement;
  begin
    if nod.elements<>nil then begin
      //Explora a todos sus elementos
      for ele in nod.elements do begin
//debugln('nod='+ele.Path);
        if ele.elements<>nil then begin
          //Tiene nodos interiors.
          ExploreFor(ele);  //Explora primero en los nodos hijos
          if res<>nil then exit;  //encontró
        end;
        //No encontró en los hijos, busca en el mismo nodo
        if ele.posXYin(posXY) then begin
          res := TxpEleBody(ele);   //guarda referencia
          if res<>nil then exit;  //encontró
        end;
      end;
    end;
  end;
begin
  //Realiza una búsqueda recursiva.
  res := nil;   //Por defecto
  ExploreFor(main);
  Result := res;
end;
function TXpTreeElements.GetElementCalledAt(const srcPos: TSrcPos): TxpElement;
{Explora los elementos, para ver si alguno es llamado desde la posición indicada.
Si no lo encuentra, devueleve NIL.}
var
  res: TxpElement;

  procedure ExploreForCall(nod: TxpElement);
  var
    ele : TxpElement;
  begin
    if nod.elements<>nil then begin
      //Explora a todos sus elementos
      for ele in nod.elements do begin
        {Busca un elemento que sea llamado desde desde esa posición pero que no sea
        unidad, porque a los elementos Unidad también se les asigna llamadas cuando
        se usa TCompilerBase.UpdateCallersToUnits;}
        if ele.IsCAlledAt(srcPos) and (ele.idClass<>eltUnit) then begin
            res := ele;   //guarda referencia
            exit;
        end else begin
          //No es un body, puede ser un eleemnto con nodos hijos
          if ele.elements<>nil then
            ExploreForCall(ele);  //recursivo
        end;
      end;
    end;
  end;
begin
  //Realiza una búsqueda recursiva.
  res := nil;   //Por defecto
  ExploreForCall(main);
  Result := res;
end;
function TXpTreeElements.GetELementDeclaredAt(const srcPos: TSrcPos): TxpElement;
{Explora los elementos, para ver si alguno es declarado en la posición indicada.}
var
  res: TxpElement;

  procedure ExploreForDec(nod: TxpElement);
  var
    ele : TxpElement;
  begin
    if nod.elements<>nil then begin
      //Explora a todos sus elementos
      for ele in nod.elements do begin
        if ele.IsDeclaredAt(srcPos) then begin
            res := ele;   //guarda referencia
            exit;
        end else begin
          //No es un body, puede ser un eleemnto con nodos hijos
          if ele.elements<>nil then
            ExploreForDec(ele);  //recursivo
        end;
      end;
    end;
  end;
begin
  //Realiza una búsqueda recursiva.
  res := nil;   //Por defecto
  ExploreForDec(main);
  Result := res;
end;
function TXpTreeElements.FunctionExistInCur(funName: string;
  const pars: TxpParFuncArray): boolean;
{Indica si la función definida por el nombre y parámetros, existe en el nodo actual.
La búsqueda se hace bajo la consideración de que dos funciones son iguales si tiene el
mismo nombre y los mismos tipos de parámetros.}
var
  ele: TxpElement;
  uname: String;
  funbas: TxpEleFunBase;
begin
  uname := Upcase(funName);
  for ele in curNode.elements do begin
    if ele.uname = uname then begin
      //hay coincidencia de nombre
      if ele.idClass in [eltFunc, eltFuncDec] then begin
        funbas := TxpEleFunBase(ele);
        //para las funciones, se debe comparar los parámetros
        if funbas.SameParamsType(pars) then begin
          exit(true);
        end;
      end else begin
        //Ssi tiene el mismo nombre que cualquier otro elemento, es conflicto
        exit(true);
      end;
    end;
  end;
  exit(false);
end;

//constructor y destructor
constructor TXpTreeElements.Create;
begin
  main:= TxpEleMain.Create;  //No debería
  main.name := 'Main';
  main.elements := TxpElements.Create(true);  //debe tener lista
  AllCons  := TxpEleCons.Create(false);   //Crea lista
  AllVars  := TxpEleVars.Create(false);   //Crea lista
  AllFuncs := TxpEleFuns.Create(false);   //Crea lista
  AllInLns := TxpEleInlins.Create(false); //Crea lista
  AllUnits := TxpEleUnits.Create(false);  //Crea lista
  AllTypes := TxpEleTypes.Create(false);
  curNode := main;  //empieza con el nodo principal como espacio de nombres actual
end;
destructor TXpTreeElements.Destroy;
begin
  main.Destroy;
  AllTypes.Destroy;
  AllUnits.Destroy;
  AllInLns.Destroy;
  AllFuncs.Free;
  AllVars.Free;    //por si estaba creada
  AllCons.Free;
  inherited Destroy;
end;
initialization
  //crea el operador NULL
  nullOper := TxpOperator.Create;
  typNull := TxpEleType.Create;
  typNull.name := 'null';

finalization
  typNull.Destroy;
  nullOper.Free;
end.
//1512
