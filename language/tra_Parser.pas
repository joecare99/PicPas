var
  ER_NOT_IMPLEM_, ER_IDEN_EXPECT, ER_DUPLIC_IDEN, ER_INVAL_FLOAT: string;
  ER_ERR_IN_NUMB, ER_NOTYPDEFNUM, ER_UNDEF_TYPE_: string;
  ER_INV_MAD_DEV, ER_EXP_VAR_IDE, ER_INV_MEMADDR, ER_BIT_VAR_REF: String;
  ER_UNKNOWN_ID_: string;
  ER_IDE_CON_EXP, ER_NUM_ADD_EXP, ER_IDE_TYP_EXP, ER_SEM_COM_EXP: String;
  ER_EQU_COM_EXP, ER_END_EXPECTE, ER_EOF_END_EXP, ER_BOOL_EXPECT: String;
  ER_UNKN_STRUCT, ER_PROG_NAM_EX, ER_COMPIL_PROC, ER_CON_EXP_EXP: String;
  ER_NOT_AFT_END, ER_ELS_UNEXPEC : String;
  ER_INST_NEV_EXE, ER_ONLY_ONE_REG: String;
  ER_VARIAB_EXPEC, ER_ONL_BYT_WORD, ER_ASIG_EXPECT: String;
  ER_FIL_NOFOUND, WA_UNUSED_CON_, WA_UNUSED_VAR_,WA_UNUSED_PRO_: String;
  MSG_RAM_USED, MSG_FLS_USED, ER_NOTYPDEF_NU, ER_ARR_SIZ_BIG: String;
  ER_INV_ARR_SIZ: String;

procedure SetLanguage;
begin
//Update messages
ER_NOT_IMPLEM_ := trans('Not implemented: "%s"'      , 'No implementado: "%s"'         ,'',
                        'Nicht implementiert: "%s"');
ER_IDEN_EXPECT := trans('Identifier expected.'       , 'Identificador esperado.'       ,'',
                        'Bezeichner erwartet.');
ER_DUPLIC_IDEN := trans('Duplicated identifier: "%s"', 'Identificador duplicado: "%s"' ,'',
                        'Doppelter Platzhalter: "%s"');
ER_INVAL_FLOAT := trans('Unvalid float number.'      , 'Número decimal no válido.'     ,'',
                        'Ungültige Gleitkommazahl.');
ER_ERR_IN_NUMB := trans('Error in number.'           , 'Error en número'               ,'',
                        'Fehler bei Nummer.');
ER_NOTYPDEFNUM := trans('No type defined to accommodate this number.', 'No hay tipo definido para albergar a este número.','',
                        'Kein Typ definiert.');
ER_UNDEF_TYPE_ := trans('Undefined type "%s"'        , 'Tipo "%s" no definido.'        ,'',
                        'Undefinierter Typ "%s"');
ER_INV_MEMADDR := trans('Invalid memory address.'    , 'Dirección de memoria inválida.','',
                        'Ungültige Speicheradresse.');
ER_BIT_VAR_REF := trans('A bit variable reference expected.', 'Se esreraba referencia a una variable bit.','',
                        'Es wird eine Bitvariablen-referenz erwartet.');
ER_INV_MAD_DEV := trans('Invalid memory address for this device.', 'No existe esta dirección de memoria en este dispositivo.','',
                        'Ungültige Speicheradresse für dieses Gerät.');
ER_EXP_VAR_IDE := trans('Identifier of variable expected.', 'Se esperaba identificador de variable.','',
                        'Variablenbezeichner erwartet.');
ER_UNKNOWN_ID_ := trans('Unknown identifier: %s'     , 'Identificador desconocido: %s' ,'',
                        'Unbekannter Bezeichner: %s');
ER_IDE_CON_EXP := trans('Identifier of constant expected.', 'Se esperaba identificador de constante','',
                        'Konstantenbezeichner erwartet.');
ER_NUM_ADD_EXP := trans('Numeric address expected.'  , 'Se esperaba dirección numérica.','',
                        'Numerische Adresse erwartet.');
ER_IDE_TYP_EXP := trans('Identifier of type expected.', 'Se esperaba identificador de tipo.','',
                        'Typenbezeichner erwartet.');
ER_SEM_COM_EXP := trans('":" or "," expected.'       , 'Se esperaba ":" o ",".'        ,'',
                        '":"oder"," erwartet.');
ER_EQU_COM_EXP := trans('"=" or "," expected.', 'Se esperaba "=" o ","','',
                        '"=" oder "," erwartet.');
ER_END_EXPECTE := trans('"end" expected.', 'Se esperaba "end".','',
                        '"End" erwartet.');
ER_EOF_END_EXP := trans('Unexpected end of file. "end" expected.', 'Inesperado fin de archivo. Se esperaba "end".','',
                        'Unerwartetes Dateiende. "end" erwartet.');
ER_BOOL_EXPECT := trans('Boolean expression expected.', 'Se esperaba expresión booleana.','',
                        'Bool''scher Ausdruck erwartet.');
ER_UNKN_STRUCT := trans('Unknown structure.', 'Estructura desconocida.','',
                        'Unbekannte Struktur.');
ER_PROG_NAM_EX := trans('Program name expected.', 'Se esperaba nombre de programa.','',
                        'Name des Programms erwartet.');
ER_COMPIL_PROC := trans('There is a compilation in progress.', 'Ya se está compilando un programa actualmente.','',
                        'Es ist (noch) ein Kompiliervorgang aktiv.');
ER_CON_EXP_EXP := trans('Constant expression expected.', 'Se esperaba una expresión constante','',
                        'Konstanter Ausdruck erwartet.');
ER_NOT_AFT_END := trans('Syntax error. Nothing should be after "END."', 'Error de sintaxis. Nada debe aparecer después de "END."','',
                        'Syntax-Fehler. Es sollte nichts nach "END." kommen.');
ER_ELS_UNEXPEC := trans('"else" unexpected.', '"else" inesperado', '',
                        '"else" nicht erwartet.');
ER_INST_NEV_EXE:= trans('Instruction will never execute.', 'Esta instrucción no se ejecutará', '',
                        'Bereich wird niemals ausgeführt.');
ER_ONLY_ONE_REG:= trans('Only one REGISTER parameter is allowed.', 'Solo se permite un parámetro REGISTER.', '',
                        'Nur ein REGISTER Parameter erlaubt.');
ER_VARIAB_EXPEC:= trans('Variable expected.', 'Se esperaba Variable', '',
                        'Variable erwartet.');
ER_ONL_BYT_WORD:= trans('Only BYTE or WORD index is allowed in FOR.', 'Solo variables Byte o Word son permitidas.', '',
                        'In FOR-Schleifen sind nur BYTE oder WORD Indizes erlaubt.');
ER_ASIG_EXPECT := trans('":=" expected.', 'Se esperaba ":="', '',
                        '":=" erwartet.');
ER_FIL_NOFOUND := trans('File not found: %s', 'Archivo no encontrado: %s', '',
                        'Datei nicht gefunden: "%s"');
ER_NOTYPDEF_NU := trans('No type defined to allocate this number.', 'No hay tipo para almacenar este número.', '',
                        '');

WA_UNUSED_CON_ := trans('Unused constant: %s', 'Constante sin usar: %s', '',
                        'Unbenutzte Konstante:%s');
WA_UNUSED_VAR_ := trans('Unused variable: %s', 'Variable sin usar: %s', '',
                        'Unbenutzte Variable:%s');
WA_UNUSED_PRO_ := trans('Unused procedure: %s', 'Procedimiento sin usar: %s', '',
                        'Unbenutztes Prozedur:%s');

MSG_RAM_USED   := trans('RAM Used   = ', 'RAM usada  =', '',
                        'RAM verwendet =');
MSG_FLS_USED   := trans('Flash Used = ', 'Flash usada=', '',
                        'Flash verwendet =');
ER_ARR_SIZ_BIG := trans('Array size to big.'       , 'Tamaño de arreglo muy grande', '',
                        '');
ER_INV_ARR_SIZ := trans('Invalid array size.'      , 'Tamaño de arreglo inválido', '',
                        '');

end;

