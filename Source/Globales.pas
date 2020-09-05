{
Unidad con declaraciones globales del proyecto
}
unit Globales;
{$mode objfpc}{$H+}
interface
uses  Classes, SysUtils, Forms, SynEdit, SynEditKeyCmds, MisUtils,
      lclType, FileUtil, LazLogger, Menus ;

const
  NOM_PROG = 'PicPas';   //nombre de programa
  {$I ../version.txt}   //versión del programa

var
   //Variables globales
   MsjError    : String;    //Bandera - Mensaje de error
   //Rutas sin "/" final
   patApp     : string;     //ruta de la aplicación
   patSamples : string;     //ruta de la carpeta de scripts
   patUnits   : string;     //ruta para guardar las sintaxis
   patTemp    : string;     //ruta para los archivos temporales
   patSyntax  : string;     //ruta de los archivos de sintaxis
   patThemes  : string;     //ruta de los archivos de temas
   patDevices10 : string;     //ruta para guardar unidades
   patDevices16 : string;     //ruta para guardar unidades
   patDevices17 : string;     //ruta para guardar unidades
   patDevices18 : string;     //ruta para guardar unidades

   archivoEnt  : string;    //archivo de entrada
   MostrarError: Boolean;   //Bandera para mostrar mensajesde error.
   ActConsSeg  : Boolean;   //Activa consultas en segundo plano

/////////////// Campos para manejo del diccionario //////////
var
 curLanguage: string;  //identificador del lenguaje

//type
// TTranslation = record
//  en: string;
//  es: string;
// end;
//
//const
// TestRec: TTranslation = (en: 'Something'; es: 'algo'; );

function Trans(const strEn, strEs, strQu, strDe, strUk, strRu, strFr: string): string;
//////////////////////////////////////////////////////
function LeerParametros: boolean;
function NombDifArc(nomBase: String): String;

implementation
const
  WA_DIR_NOEXIST = 'Directory: %s no found. It will be created';
  ER_CANN_READDI = 'Cannot read or create directories.';

function Trans(const strEn, strEs, strQu, strDe, strUk, strRu, strFr: string): string;
  function ClearLangId(str: string): string;
  {Limpia la cadena del caracter identificador de lenguaje, de la forma:
  #en=
  que se puede usar al inicio de una cadena.}
  begin
     if str='' then exit('');
     if length(str)<4 then exit(str);
     if (str[1] = '#') and (str[4] = '=') then begin
       delete(str, 1, 4);
       exit(str);
     end else begin
       exit(str);
     end;
  end;
begin
  case LowerCase(curLanguage) of
  'en': begin
     Result := ClearLangId(strEn);
  end;
  'es': begin
     Result := ClearLangId(strEs);
     if Result = '' then Result := ClearLangId(strEn);
  end;
  'qu': begin
     Result := ClearLangId(strQu);
     if Result = '' then Result := strEs;
  end;  //por defecto
  'de': begin
     Result := ClearLangId(strDe);
     if Result = '' then Result := ClearLangId(strEn);
  end;  //por defecto
  'uk': begin
     Result := ClearLangId(strUk);
     if Result = '' then Result := ClearLangId(strEn); //por defecto
  end;
  'ru': begin
     Result := ClearLangId(strRu);
     if Result = '' then Result := ClearLangId(strEn); //por defecto
  end;
  'fr': begin
     Result := ClearLangId(strFr);
     if Result = '' then Result := ClearLangId(strEn); //por defecto
  end;
  else  //Por defecto Inglés
    Result := ClearLangId(strEn);
  end;
end;
function LeerParametros: boolean;
{lee la linea de comandos
 Si hay error devuelve TRUE}
var
   par : String;
   i   : Integer;
begin
   Result := false;    //valor por defecto
   //valores por defecto
   archivoEnt := '';
   MostrarError := True;
   ActConsSeg := False;
   //Lee parámetros de entrada
   par := ParamStr(1);
   if par = '' then begin
     MsgErr('Nombre de archivo vacío.');
     Result := true;
     exit;  //sale con error
   end;
   if par[1] = '/' then begin  //es parámetro
      i := 1;  //para que explore desde el principio
   end else begin  //es archivo
      archivoEnt := par;  //el primer elemento es el archivo de entrada
      i := 2;  //explora siguientes
   end;
   while i <= ParamCount do begin
      par := ParamStr(i);
      If par[1] = '/' Then begin
         Case UpCase(par) of
            '/NOERROR': MostrarError := False;
            '/ERROR': MostrarError := True;
            '/CONSEG': ActConsSeg := True;
            '/NOCONSEG': ActConsSeg := False;
         Else begin
                MsgErr('Error. Parámetro desconocido: ' + par);
                Result := true;
                exit;  //sale con error
              End
         End
      end Else begin
//         archivoSal := par;
      End;
      inc(i);  //pasa al siguiente
   end;
End;
function NombDifArc(nomBase: String): String;
{Genera un nombre diferente de archivo, tomando el nombre dado como raiz.}
const MAX_ARCH = 10;
var i : Integer;    //Número de intentos con el nombre de archivo de salida
    cadBase : String;   //Cadena base del nombre base
    extArc: string;    //extensión

  function NombArchivo(i: integer): string;
  begin
    Result := cadBase + '-' + IntToStr(i) + extArc;
  end;

begin
   Result := nomBase;  //nombre por defecto
   extArc := ExtractFileExt(nomBase);
   if ExtractFilePath(nomBase) = '' then exit;  //protección
   //quita ruta y cambia extensión
   cadBase := ChangeFileExt(nomBase,'');
   //busca archivo libre
   for i := 0 to MAX_ARCH-1 do begin
      If not FileExists(NombArchivo(i)) then begin
        //Se encontró nombre libre
        Exit(NombArchivo(i));  //Sale con nombre
      end;
   end;
   //todos los nombres estaban ocupados. Sale con el mismo nombre
End;

initialization
  //inicia directorios de la aplicación
  patApp      :=  ExtractFilePath(Application.ExeName);  //incluye el '\' final
  patSamples  := patApp + 'samples';
  patUnits    := patApp + 'units';
  patTemp     := patApp + 'temp';
  patSyntax   := patApp + 'syntax';
  patThemes   := patApp + 'themes';
  patDevices10 := patApp + 'devices10';
  patDevices16 := patApp + 'devices16';
  patDevices17 := patApp + 'devices17';
  patDevices18 := patApp + 'devices18';
  archivoEnt  := '';    //archivo de entrada
  //verifica existencia de carpetas de trabajo
  try
    if not DirectoryExists(patSamples) then begin
       msgexc(WA_DIR_NOEXIST, [patSamples]);
       CreateDir(patSamples);
    end;
    if not DirectoryExists(patUnits) then begin
       msgexc(WA_DIR_NOEXIST, [patUnits]);
       CreateDir(patUnits);
    end;
    if not DirectoryExists(patDevices10) then begin
       msgexc(WA_DIR_NOEXIST, [patDevices10]);
       CreateDir(patDevices10);
    end;
    if not DirectoryExists(patDevices16) then begin
       msgexc(WA_DIR_NOEXIST, [patDevices16]);
       CreateDir(patDevices16);
    end;
    if not DirectoryExists(patDevices17) then begin
       msgexc(WA_DIR_NOEXIST, [patDevices17]);
       CreateDir(patDevices17);
    end;
    if not DirectoryExists(patDevices18) then begin
       msgexc(WA_DIR_NOEXIST, [patDevices18]);
       CreateDir(patDevices18);
    end;
    if not DirectoryExists(patTemp) then begin
       msgexc(WA_DIR_NOEXIST, [patTemp]);
       CreateDir(patTemp);
    end;
    if not DirectoryExists(patSyntax) then begin
       msgexc(WA_DIR_NOEXIST, [patSyntax]);
       CreateDir(patSyntax);
    end;
    if not DirectoryExists(patThemes) then begin
       msgexc(WA_DIR_NOEXIST, [patThemes]);
      CreateDir(patThemes);
    end;

  except
    msgErr(ER_CANN_READDI);
  end;

finalization
  //Por algún motivo, la unidad HeapTrc indica que hay gotera de memoria si no se liberan
  //estas cadenas:
  patApp :=  '';
  patSamples := '';
  patUnits := '';
  patDevices10 := '';
  patDevices16 := '';
  patDevices17 := '';
  patDevices18 := '';
  patTemp := '';
  patSyntax := '';
end.

