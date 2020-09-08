//Parser unit
ER_IDEN_EXPECT := trans('Identifier expected.'       , 'Identificador esperado.'       ,'',
                        'Bezeichner erwartet.'       , 'Очікується ідентифікатор.','Ожидается идентификатор.', 'Identifiant attendu.','');
ER_NOT_IMPLEM_ := trans('Not implemented: "%s"'       , 'No implementado: "%s"'         ,'',
                        'Nicht implementiert: "%s"'   , 'Не впроваджено: "%s"','Не реализовано: "%s"', 'Non implémenté : "%s"','');
ER_DUPLIC_IDEN := trans('Duplicated identifier: "%s"' , 'Identificador duplicado: "%s"' ,'',
                        'Doppelter Platzhalter: "%s"' , 'Дубльований ідентифікатор: "%s"','Дублированный идентификатор: "%s"', 'Identifiant à double : "%s"','');
ER_UNDEF_TYPE_ := trans('Undefined type "%s"'         , 'Tipo "%s" no definido.'        ,'',
                        'Undefinierter Typ "%s"'      , 'Невизначений тип "%s"','Неопределённый тип "%s"', 'Type indéfini "%s"','');
ER_SEMIC_EXPEC  := trans('";" expected.'              , 'Se esperaba ";"', '',
                         '"," erwartet.', '', '', '','');
ER_STR_EXPECTED := trans('"%s" expected.'             , 'Se esperaba "%s"'              , '',
                         '"%s" erwartet.', '', '', '','');
ER_TYP_PARM_ER_ := trans('Type parameters error on %s', 'Error en tipo de parámetros de %s', '',
                         'Typparameterfehler auf %s', '', '', '','');
ER_UNKNOWN_IDE_ := trans('Unknown identifier: %s'     , 'Identificador desconocido: %s' , '',
                         'Unbekannter Bezeichner: %s', '', '', '','');
ER_IN_EXPRESSI  := trans('Error in expression. ")" expected.', 'Error en expresión. Se esperaba ")"', '',
                         'Fehler im Ausdruck. ")" erwartet.', '', '', '','');
ER_OPERAN_EXPEC := trans('Operand expected.'          , 'Se esperaba operando.'         , '',
                         'Operand erwartet.', '', '', '','');
ER_ILLEG_OPERA_ := trans('Illegal Operation: %s'      , 'Operación no válida: %s'       , '',
                         'Unzulässiger Vorgang: %s', '', '', '','');
ER_UND_OPER_TY_ := trans('Undefined operator: %s for type: %s', 'No está definido el operador: %s para tipo: %s', '',
                         'Nicht definierter Operator: %s für Typ: %s', '', '', '','');
ER_CAN_AP_OPER_ := trans('Cannot apply the operator "%s" to type "%s"', 'No se puede aplicar el operador "%s" al tipo "%s"', '',
                         'Der Operator "%s" kann nicht auf den Typ "%s" angewendet werden.', '', '', '','');
ER_IN_CHARACTER := trans('Error in character.'        , 'Error en caracter.'            , '',
                         'Fehler im Zeichen.', '', '', '','');
ER_INV_COD_CHAR := trans('Invalid code for char.'     , 'Código inválido para caracter' , '',
                         'Ungültiger Code für Zeichen.', '', '', '','');
ER_IDE_TYP_EXP := trans('Identifier of type expected.', 'Se esperaba identificador de tipo.','',
                        'Typenbezeichner erwartet.'   , 'Очікується ідентифікатор типу.','Ожидается идентификатор типа.', 'Identifiant de type attendu.','');
ER_ONLY_ONE_REG:= trans('Only one REGISTER parameter is allowed.', 'Solo se permite un parámetro REGISTER.', '',
                        'Nur ein REGISTER Parameter erlaubt.'    ,'Дозволено тільки один параметр REGISTER.','Только один параметр REGISTER разрешён.', 'Un seul paramètre REGISTRE est autorisé.','');
ER_RA_HAV_USED := trans('Register A has been used.'   , 'Ya se ha usado el rgistro A.','',
                        'Register A wurde verwendet.'  , '','', '','');

