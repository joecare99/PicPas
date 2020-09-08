
//Update messages
ER_NOT_IMPLEM_ := trans('Not implemented: "%s"'      , 'No implementado: "%s"'         ,'',
                        'Nicht implementiert: "%s"'  ,'Не впроваджено: "%s"','Не реализовано: "%s"', 'Non implémenté : "%s"');
ER_IDEN_EXPECT := trans('Identifier expected.'       , 'Identificador esperado.'       ,'',
                        'Bezeichner erwartet.'       , 'Очікується ідентифікатор.','Ожидается идентификатор.', 'Identifiant attendu.');
ER_DUPLIC_IDEN := trans('Duplicated identifier: "%s"', 'Identificador duplicado: "%s"' ,'',
                        'Doppelter Platzhalter: "%s"','Дубльований ідентифікатор: "%s"','Дублированный идентификатор: "%s"', 'Identifiant à double : "%s"');
ER_INVAL_FLOAT := trans('Unvalid float number.'      , 'Número decimal no válido.'     ,'',
                        'Ungültige Gleitkommazahl.'  ,'Невірне число з плаваючою комою.','Недопустимое число с плавающей запятой.', 'Nombre à virgule flottante invalide.');
ER_NOTYPDEFNUM := trans('No type defined to accommodate this number.', 'No hay tipo definido para albergar a este número.','',
                        'Kein Typ definiert.'        ,'Для типу цього числа не визначено жодного типу','Не определён тип для размещения этого числа', 'Aucun type défini pour ce nombre.');
ER_INV_MEMADDR := trans('Invalid memory address.'    , 'Dirección de memoria inválida.','',
                        'Ungültige Speicheradresse.' , 'Недійсна адреса памʼяті.','Недопустимый адрес памяти.', 'Adresse mémoire invalide.');
ER_BIT_VAR_REF := trans('A bit variable reference expected.'          , 'Se esreraba referencia a una variable bit.','',
                        'Es wird eine Bitvariablen-referenz erwartet.', 'Очікується біт-змінна.','Ожидается бит-переменная.', 'Référence de bit attendue.');
ER_EXP_VAR_IDE := trans('Identifier of variable expected.', 'Se esperaba identificador de variable.','',
                        'Variablenbezeichner erwartet.'   , 'Очікується фдентифікатор змінної.','Ожидается идентификатор переменной.', 'Identifiant de variable attendu.');
ER_UNKNOWN_ID_ := trans('Unknown identifier: %s'     , 'Identificador desconocido: %s' ,'',
                        'Unbekannter Bezeichner: %s' , 'Невідомий ідентифікатор: %s','Неизвестный идентификатор: %s', 'Identifiant inconnu : %s');
ER_IDE_CON_EXP := trans('Identifier of constant expected.', 'Se esperaba identificador de constante','',
                        'Konstantenbezeichner erwartet.'  , 'Очікується ідентифікатор константи.','Ожидается идентификатор константы.', 'Identifiant de constante attendu');
ER_NUM_ADD_EXP := trans('Numeric address expected.'   , 'Se esperaba dirección numérica.','',
                        'Numerische Adresse erwartet.', 'Очікується числова адреса.','Ожидается числовой адрес.', 'Adresse numérique attendue.');
ER_IDE_TYP_EXP := trans('Identifier of type expected.', 'Se esperaba identificador de tipo.','',
                        'Typenbezeichner erwartet.'   , 'Очікується ідентифікатор типу.','Ожидается идентификатор типа.', 'Identifiant de type attendu.');
ER_SEM_COM_EXP := trans('":" or "," expected.'        , 'Se esperaba ":" o ",".'        ,'',
                        '":"oder"," erwartet.'        , '":" або "," очікується.','":" или "," ожидается.', '":" ou "," attendus.');
ER_EQU_COM_EXP := trans('"=" or "," expected.'        , 'Se esperaba "=" o ","','',
                        '"=" oder "," erwartet.'      , '"=" або "," очікується.','"=" или "," ожидается.', '"=" ou "," attendus.');
ER_COMPIL_PROC := trans('There is a compilation in progress.'      , 'Ya se está compilando un programa actualmente.','',
                        'Es ist (noch) ein Kompiliervorgang aktiv.', 'Триває компіляція.','Происходит компиляция.', 'Une compilation et en cours.');
ER_CON_EXP_EXP := trans('Constant expression expected.', 'Se esperaba una expresión constante','',
                        'Konstanter Ausdruck erwartet.', '', '', 'Expression constante attendue.');
ER_FIL_NOFOUND := trans('File not found: %s'        , 'Archivo no encontrado: %s', '',
                        'Datei nicht gefunden: "%s"', 'Файл не знайдено: %s','Файл не найден: %s', 'Fichier non trouvé: %s');

WA_UNUSED_CON_ := trans('Unused constant: %s', 'Constante sin usar: %s', '',
                        'Unbenutzte Konstante:%s','Невикористана константа: %s','Неиспользованная константа: %s', 'Constante non utilisée : %s');
WA_UNUSED_VAR_ := trans('Unused variable: %s', 'Variable sin usar: %s', '',
                        'Unbenutzte Variable:%s','Невикористана змінна: %s','Неиспользованная переменная: %s', 'Variable non utilisée : %s');
WA_UNUSED_PRO_ := trans('Unused procedure: %s', 'Procedimiento sin usar: %s', '',
                        'Unbenutztes Prozedur:%s','Невикористана процедура: %s','Неиспользованная процедура: %s', 'Procédure non utilisée : %s');

MSG_RAM_USED   := trans('RAM Used   = '   , 'RAM usada  =', '',
                        'RAM verwendet =','RAM використано   = ','RAM использовано   = ', 'RAM utilisée    =');
MSG_FLS_USED   := trans('Flash Used = '   , 'Flash usada=', '',
                        'Flash verwendet =','Flash використано = ','Flash использовано = ', 'FLASH utilisée =');
ER_ARR_SIZ_BIG := trans('Array size to big.' , 'Tamaño de arreglo muy grande', '',
                        'Arraygröße zu groß.'                   ,'Розмір масиву завеликий.','Размер массива слишком велик.', 'Tableau trop grand.');
ER_INV_ARR_SIZ := trans('Invalid array size.', 'Tamaño de arreglo inválido', '',
                        'Ungültige Arraygröße.'                   , 'Помилка в розмірі масиву.','Ошибка размера массива.', 'Taille de tableau invalide.');


