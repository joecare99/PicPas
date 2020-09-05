ER_INV_MEMADDR := trans('Invalid memory address.'     , 'Dirección de memoria inválida.','',
                        'Ungültige Speicheradresse.'  , 'Недійсна адреса памʼяті.','Недопустимый адрес памяти.', 'Adresse mémoire invalide.');
ER_EXP_VAR_IDE := trans('Identifier of variable expected.', 'Se esperaba identificador de variable.','',
                        'Variablenbezeichner erwartet.'   , 'Очікується фдентифікатор змінної.','Ожидается идентификатор переменной.', 'Identifiant de variable attendu.');
ER_NUM_ADD_EXP := trans('Numeric address expected.'   , 'Se esperaba dirección numérica.','',
                        'Numerische Adresse erwartet.', 'Очікується числова адреса.'    ,'Ожидается числовой адрес.', 'Adresse numérique attendue.');
ER_CON_EXP_EXP := trans('Constant expression expected.', 'Se esperaba una expresión constante','',
                        'Konstanter Ausdruck erwartet.', '', '', 'Expression constante attendue.');
ER_EQU_EXPECTD := trans('"=" expected.'               , 'Se esperaba "="'               ,'',
                        '"=" erwartet.'               , '"=" очікується.'               ,'"=" ожидается.' , '"=" attendue.');
ER_IDEN_EXPECT := trans('Identifier expected.'       , 'Identificador esperado.'       ,'',
                        'Bezeichner erwartet.'       , 'Очікується ідентифікатор.','Ожидается идентификатор.', 'Identifiant attendu.');
ER_NOT_IMPLEM_ := trans('Not implemented: "%s"'       , 'No implementado: "%s"'         ,'',
                        'Nicht implementiert: "%s"'   , 'Не впроваджено: "%s"','Не реализовано: "%s"', 'Non implémenté : "%s"');
ER_SEM_COM_EXP := trans('":" or "," expected.'        , 'Se esperaba ":" o ",".'        ,'',
                        '":"oder"," erwartet.'        , '":" або "," очікується.','":" или "," ожидается.', '":" ou "," attendus.');
ER_INV_ARR_SIZ := trans('Invalid array size.', 'Tamaño de arreglo inválido', '',
                        ''                   , 'Помилка в розмірі масиву.','Ошибка размера массива.', 'Taille de tableau invalide.');
ER_ARR_SIZ_BIG := trans('Array size to big.' , 'Tamaño de arreglo muy grande', '',
                        ''                   ,'Розмір масиву завеликий.','Размер массива слишком велик.', 'Tableau trop grand.');
ER_IDE_TYP_EXP := trans('Identifier of type expected.', 'Se esperaba identificador de tipo.','',
                        'Typenbezeichner erwartet.'   , 'Очікується ідентифікатор типу.','Ожидается идентификатор типа.', 'Identifiant de type attendu.');
ER_IDE_CON_EXP := trans('Identifier of constant expected.', 'Se esperaba identificador de constante','',
                        'Konstantenbezeichner erwartet.'  , 'Очікується ідентифікатор константи.','Ожидается идентификатор константы.', 'Identifiant de constante attendu');
ER_EQU_COM_EXP := trans('"=" or "," expected.'        , 'Se esperaba "=" o ","'         ,'',
                        '"=" oder "," erwartet.'      , '"=" або "," очікується.','"=" или "," ожидается.', '"=" ou "," attendus.');
ER_DUPLIC_IDEN := trans('Duplicated identifier: "%s"' , 'Identificador duplicado: "%s"' ,'',
                        'Doppelter Platzhalter: "%s"' , 'Дубльований ідентифікатор: "%s"','Дублированный идентификатор: "%s"', 'Identifiant à double : "%s"');
ER_NOTYPDEF_NU := trans('No type defined to allocate this number.', 'No hay tipo para almacenar este número.', '',
                        '','Не визначено тип, щоб виділити цей номер.','Нет определенного типа, чтобы выделить это число.', 'Aucun type défini pour allouer ce nombre');
ER_EOF_END_EXP := trans('Unexpected end of file. "end" expected.', 'Inesperado fin de archivo. Se esperaba "end".','',
                        'Unerwartetes Dateiende. "end" erwartet.','Неочікуваний кінець файла. "end" очікується.','Неожиданный конец файла. "end" ожидается.', '"end" attendu à la fin du fichier.');
ER_ELS_UNEXPEC := trans('"else" unexpected.'    , '"else" inesperado', '',
                        '"else" nicht erwartet.','"else" несподівано.','"else" неожиданно.', '"else" inattendu.');
ER_END_EXPECTE := trans('"end" expected.', 'Se esperaba "end".','',
                        '"End" erwartet.','"end" очікується.','"end" ожидается.', '"end" attendu.');
ER_NOT_AFT_END := trans('Syntax error. Nothing should be after "END."'       , 'Error de sintaxis. Nada debe aparecer después de "END."','',
                        'Syntax-Fehler. Es sollte nichts nach "END." kommen.', 'Синтаксична помилка. Нічого не повинно бути після "END."','Ошибка синтаксиса. Ничего не должно быть после "END."', 'Erreur de syntaxe. Rien ne devrait suivre "END."');
ER_ONLY_ONE_REG:= trans('Only one REGISTER parameter is allowed.', 'Solo se permite un parámetro REGISTER.', '',
                        'Nur ein REGISTER Parameter erlaubt.'    ,'Дозволено тільки один параметр REGISTER.','Только один параметр REGISTER разрешён.', 'Un seul paramètre REGISTRE est autorisé.');
ER_BOOL_EXPECT := trans('Boolean expression expected.'  , 'Se esperaba expresión booleana.','',
                        'Bool''scher Ausdruck erwartet.','Очікується булевий вираз.','Ожидается булевое выражение.', 'Expression booléenne attendue');
ER_INST_NEV_EXE:= trans('Instruction will never execute.' , 'Esta instrucción no se ejecutará', '',
                        'Bereich wird niemals ausgeführt.','Інструкція ніколи не виконуватиметься.','Инструкция никогда не будет выполнена.', 'L''instruction ne sera jamais exécutée.');
ER_UNKN_STRUCT := trans('Unknown structure.'    , 'Estructura desconocida.','',
                        'Unbekannte Struktur.'  ,'Невідома структура.','Неизвестная структура.', 'Structure inconnue.');
ER_ERR_IN_NUMB := trans('Error in number.'           , 'Error en número'               ,'',
                        'Fehler bei Nummer.'         ,'Помилка в числі.','Ошибка в числе.', 'Nombre invalide.');
ER_UNDEF_TYPE_ := trans('Undefined type "%s"'        , 'Tipo "%s" no definido.'        ,'',
                        'Undefinierter Typ "%s"'     , 'Невизначений тип "%s"','Неопределённый тип "%s"', 'Type indéfini "%s"');
ER_DUPLIC_FUNC_:= trans('Duplicated function: %s'     ,'Función duplicada: %s', '',
                        '', '', '', '');
ER_FIL_NOFOUND := trans('File not found: %s'        , 'Archivo no encontrado: %s', '',
                        'Datei nicht gefunden: "%s"', 'Файл не знайдено: %s','Файл не найден: %s', 'Fichier non trouvé: %s');
ER_PROG_NAM_EX := trans('Program name expected.'      , 'Se esperaba nombre de programa.','',
                        'Name des Programms erwartet.','Очікується імʼя програми.','Ожидается имя программы.', 'Nom de programme attendu.');

