
//Update messages
ER_NOT_IMPLEM_ := trans('Not implemented: "%s"'      , 'No implementado: "%s"'         ,'',
                        'Nicht implementiert: "%s"'  ,'Не впроваджено: "%s"','Не реализовано: "%s"', 'Non implémenté : "%s"','未实现："%s"');
ER_IDEN_EXPECT := trans('Identifier expected.'       , 'Identificador esperado.'       ,'',
                        'Bezeichner erwartet.'       , 'Очікується ідентифікатор.','Ожидается идентификатор.', 'Identifiant attendu.','需要标识符。');
ER_DUPLIC_IDEN := trans('Duplicated identifier: "%s"', 'Identificador duplicado: "%s"' ,'',
                        'Doppelter Platzhalter: "%s"','Дубльований ідентифікатор: "%s"','Дублированный идентификатор: "%s"', 'Identifiant à double : "%s"','重复标识符："%s"');
ER_INVAL_FLOAT := trans('Unvalid float number.'      , 'Número decimal no válido.'     ,'',
                        'Ungültige Gleitkommazahl.'  ,'Невірне число з плаваючою комою.','Недопустимое число с плавающей запятой.', 'Nombre à virgule flottante invalide.','未验证的浮点数。');
ER_ERR_IN_NUMB := trans('Error in number.'           , 'Error en número'               ,'',
                        'Fehler bei Nummer.'         ,'Помилка в числі.','Ошибка в числе.', 'Nombre invalide.','数字错误。');
ER_NOTYPDEFNUM := trans('No type defined to accommodate this number.', 'No hay tipo definido para albergar a este número.','',
                        'Kein Typ definiert.'        ,'Для типу цього числа не визначено жодного типу','Не определён тип для размещения этого числа', 'Aucun type défini pour ce nombre.','没有定义任何类型来容纳此数字。');
ER_UNDEF_TYPE_ := trans('Undefined type "%s"'        , 'Tipo "%s" no definido.'        ,'',
                        'Undefinierter Typ "%s"'     , 'Невизначений тип "%s"','Неопределённый тип "%s"', 'Type indéfini "%s"','未定义类型"%s"');
ER_INV_MEMADDR := trans('Invalid memory address.'    , 'Dirección de memoria inválida.','',
                        'Ungültige Speicheradresse.' , 'Недійсна адреса памʼяті.','Недопустимый адрес памяти.', 'Adresse mémoire invalide.','无效的内存地址。');
ER_BIT_VAR_REF := trans('A bit variable reference expected.'          , 'Se esreraba referencia a una variable bit.','',
                        'Es wird eine Bitvariablen-referenz erwartet.', 'Очікується біт-змінна.','Ожидается бит-переменная.', 'Référence de bit attendue.','预期为位变量引用。');
ER_INV_MAD_DEV := trans('Invalid memory address for this device.', 'No existe esta dirección de memoria en este dispositivo.','Adresse mémoire invalide pour ce modèle PIC.',
                        'Ungültige Speicheradresse für dieses Gerät.','Недійсна адреса памʼяті для цього пристрою.','Недопустимый адрес памяти для этого устройства.', '','此设备的内存地址无效。');
ER_EXP_VAR_IDE := trans('Identifier of variable expected.', 'Se esperaba identificador de variable.','',
                        'Variablenbezeichner erwartet.'   , 'Очікується фдентифікатор змінної.','Ожидается идентификатор переменной.', 'Identifiant de variable attendu.','预期的变量的标识符。');
ER_UNKNOWN_ID_ := trans('Unknown identifier: %s'     , 'Identificador desconocido: %s' ,'',
                        'Unbekannter Bezeichner: %s' , 'Невідомий ідентифікатор: %s','Неизвестный идентификатор: %s', 'Identifiant inconnu : %s','未知标识符： %s');
ER_IDE_CON_EXP := trans('Identifier of constant expected.', 'Se esperaba identificador de constante','',
                        'Konstantenbezeichner erwartet.'  , 'Очікується ідентифікатор константи.','Ожидается идентификатор константы.', 'Identifiant de constante attendu','应数常量的标识符。');
ER_NUM_ADD_EXP := trans('Numeric address expected.'   , 'Se esperaba dirección numérica.','',
                        'Numerische Adresse erwartet.', 'Очікується числова адреса.','Ожидается числовой адрес.', 'Adresse numérique attendue.','预期的数字地址。');
ER_IDE_TYP_EXP := trans('Identifier of type expected.', 'Se esperaba identificador de tipo.','',
                        'Typenbezeichner erwartet.'   , 'Очікується ідентифікатор типу.','Ожидается идентификатор типа.', 'Identifiant de type attendu.','预期的类型的标识符。');
ER_SEM_COM_EXP := trans('":" or "," expected.'        , 'Se esperaba ":" o ",".'        ,'',
                        '":"oder"," erwartet.'        , '":" або "," очікується.','":" или "," ожидается.', '":" ou "," attendus.','"："或"，预期。');
ER_EQU_COM_EXP := trans('"=" or "," expected.'        , 'Se esperaba "=" o ","','',
                        '"=" oder "," erwartet.'      , '"=" або "," очікується.','"=" или "," ожидается.', '"=" ou "," attendus.','"="或""预期。');
ER_END_EXPECTE := trans('"end" expected.', 'Se esperaba "end".','',
                        '"End" erwartet.','"end" очікується.','"end" ожидается.', '"end" attendu.','预期"结束"。');
ER_EOF_END_EXP := trans('Unexpected end of file. "end" expected.', 'Inesperado fin de archivo. Se esperaba "end".','',
                        'Unerwartetes Dateiende. "end" erwartet.','Неочікуваний кінець файла. "end" очікується.','Неожиданный конец файла. "end" ожидается.', '"end" attendu à la fin du fichier.','意外的文件结束。预期"结束"。');
ER_BOOL_EXPECT := trans('Boolean expression expected.'  , 'Se esperaba expresión booleana.','',
                        'Bool''scher Ausdruck erwartet.','Очікується булевий вираз.','Ожидается булевое выражение.', 'Expression booléenne attendue','预期布尔表达式。');
ER_UNKN_STRUCT := trans('Unknown structure.'    , 'Estructura desconocida.','',
                        'Unbekannte Struktur.'  ,'Невідома структура.','Неизвестная структура.', 'Structure inconnue.','未知结构。');
ER_PROG_NAM_EX := trans('Program name expected.'      , 'Se esperaba nombre de programa.','',
                        'Name des Programms erwartet.','Очікується імʼя програми.','Ожидается имя программы.', 'Nom de programme attendu.','预期程序名称。');
ER_COMPIL_PROC := trans('There is a compilation in progress.'      , 'Ya se está compilando un programa actualmente.','',
                        'Es ist (noch) ein Kompiliervorgang aktiv.', 'Триває компіляція.','Происходит компиляция.', 'Une compilation et en cours.','正在编写一份汇编。');
ER_CON_EXP_EXP := trans('Constant expression expected.', 'Se esperaba una expresión constante','',
                        'Konstanter Ausdruck erwartet.', '', '', 'Expression constante attendue.','预期常量表达式。');
ER_NOT_AFT_END := trans('Syntax error. Nothing should be after "END."'       , 'Error de sintaxis. Nada debe aparecer después de "END."','',
                        'Syntax-Fehler. Es sollte nichts nach "END." kommen.', 'Синтаксична помилка. Нічого не повинно бути після "END."','Ошибка синтаксиса. Ничего не должно быть после "END."', 'Erreur de syntaxe. Rien ne devrait suivre "END."','语法错误。"结束"之后不应该是任何东西。');
ER_ELS_UNEXPEC := trans('"else" unexpected.'    , '"else" inesperado', '',
                        '"else" nicht erwartet.','"else" несподівано.','"else" неожиданно.', '"else" inattendu.','"否则" 出乎意料。');
ER_INST_NEV_EXE:= trans('Instruction will never execute.' , 'Esta instrucción no se ejecutará', '',
                        'Bereich wird niemals ausgeführt.','Інструкція ніколи не виконуватиметься.','Инструкция никогда не будет выполнена.', 'L''instruction ne sera jamais exécutée.','指令永远不会执行。');
ER_ONLY_ONE_REG:= trans('Only one REGISTER parameter is allowed.', 'Solo se permite un parámetro REGISTER.', '',
                        'Nur ein REGISTER Parameter erlaubt.'    ,'Дозволено тільки один параметр REGISTER.','Только один параметр REGISTER разрешён.', 'Un seul paramètre REGISTRE est autorisé.','只允许一个注册参数。');
ER_VARIAB_EXPEC:= trans('Variable expected.' , 'Se esperaba Variable', '',
                        'Variable erwartet.' ,'Змінна очікується.','Переменная ожидается.', 'Variable attendue.','等待变量。');
ER_ONL_BYT_WORD:= trans('Only BYTE or WORD index is allowed in FOR.', 'Solo variables Byte o Word son permitidas.', '',
                        'In FOR-Schleifen sind nur BYTE oder WORD Indizes erlaubt.','Для FOR дозволено лише індекс BYTE або WORD.','В FOR допускается только индекс BYTE или WORD.', 'Seuls des indexes BYTE ou WORD sont autorisées dans une boucle FOR.','在 FOR 中只允许字节或 WORD 索引。');
ER_ASIG_EXPECT := trans('":=" expected.' , 'Se esperaba ":="', '',
                        '":=" erwartet.' , '":=" очікується.', '":=" ожидается.', '":=" attendu.','"：=" 预期。');
ER_FIL_NOFOUND := trans('File not found: %s'        , 'Archivo no encontrado: %s', '',
                        'Datei nicht gefunden: "%s"', 'Файл не знайдено: %s','Файл не найден: %s', 'Fichier non trouvé: %s','未找到文件： %s');
ER_NOTYPDEF_NU := trans('No type defined to allocate this number.', 'No hay tipo para almacenar este número.', '',
                        'Es wurde kein Typ definiert, um diese Nummer zuzuweisen.','Не визначено тип, щоб виділити цей номер.','Нет определенного типа, чтобы выделить это число.', 'Aucun type défini pour allouer ce nombre','');

WA_UNUSED_CON_ := trans('Unused constant: %s', 'Constante sin usar: %s', '',
                        'Unbenutzte Konstante:%s','Невикористана константа: %s','Неиспользованная константа: %s', 'Constante non utilisée : %s','未使用的常量： %s');
WA_UNUSED_VAR_ := trans('Unused variable: %s', 'Variable sin usar: %s', '',
                        'Unbenutzte Variable:%s','Невикористана змінна: %s','Неиспользованная переменная: %s', 'Variable non utilisée : %s','未使用的变量： %s');
WA_UNUSED_PRO_ := trans('Unused procedure: %s', 'Procedimiento sin usar: %s', '',
                        'Unbenutztes Prozedur:%s','Невикористана процедура: %s','Неиспользованная процедура: %s', 'Procédure non utilisée : %s','未使用的过程： %s');

MSG_RAM_USED   := trans('RAM Used   = '   , 'RAM usada  =', '',
                        'RAM verwendet =','RAM використано   = ','RAM использовано   = ', 'RAM utilisée    =','已用内存 |');
MSG_FLS_USED   := trans('Flash Used = '   , 'Flash usada=', '',
                        'Flash verwendet =','Flash використано = ','Flash использовано = ', 'FLASH utilisée =','使用闪光灯 |');
ER_ARR_SIZ_BIG := trans('Array size to big.' , 'Tamaño de arreglo muy grande', '',
                        'Arraygröße zu groß.'                   ,'Розмір масиву завеликий.','Размер массива слишком велик.', 'Tableau trop grand.','');
ER_INV_ARR_SIZ := trans('Invalid array size.', 'Tamaño de arreglo inválido', '',
                        'Ungültige Arraygröße.'                   , 'Помилка в розмірі масиву.','Ошибка размера массива.', 'Taille de tableau invalide.','');


