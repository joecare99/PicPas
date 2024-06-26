//Main menu
 mnFile.Caption  := Trans('&File'    , '&Archivo'       , '&Khipu'        ,
                          '&Datei'   ,'Файл'		,'Файл',
                          '&Fichier','&文件');
 mnEdit.Caption  := Trans('&Edit'    , '&Edición'       , '&Allichay'     ,
                          '&Bearbeiten'	,'Зміни'	,'Редактировать',
                          '&Editer','&编辑');
 mnFind.Caption  := Trans('&Search'  , '&Buscar'        , '&Maskhay'      ,
                          '&Suchen'  , 'Пошук',         'Поиск',
                          '&Chercher','&搜索');
 mnView.Caption  := Trans('&View'    , '&Ver'           , '&Qhaway'       ,
                          '&Anzeigen' , 'Вигляд'         ,'Вид',
                          '&Affichage','&视图');
 mnTools.Caption := Trans('&Tools'   , '&Herramientas'  , '&Llamk''anakuna' ,
                          '&Tools','Інструменти','Инструменты',
                          '&Outils','&工具');

//File Actions
 acArcNewFile.Caption := Trans('New &File'      , 'Nuevo &Archivo'   , 'Musuq &Khipu'        ,
                               '&Neu','Новий файл','Новый проект',
                               'Nouveau &Fichier','新文件');
 acArcNewFile.Hint    := Trans('New File'       , 'Nuevo Archivo'    , 'Musuq Khipu'         ,
                               'Neue Datei','Новий файл','Новый файл',
                               'Nouveau Fichier','新文件');
 acArcNewProj.Caption := Trans('New &Project'   , 'Nuevo &Proyecto'  , 'Musuq &Proyecto'     ,
                               'Neues &Projekt','Новий проект','Новый файл',
                               'Nouveau &Projet','新建项目');
 acArcNewProj.Hint    := Trans('New &Project'   , 'Nuevo Proyecto'   , 'Musuq Proyecto'      ,
                               'Neues &Projekt','Новий проект','Новый проект',
                               'Nouveau &Projet','新建项目');
 acArcOpen.Caption    := Trans('&Open...'       , '&Abrir...'        , 'K&ichay'             ,
                               '&Öffnen...','Відкрити...','Открыть...',
                               '&Ouvrir...','打开(&O)...');
 acArcOpen.Hint       := Trans('Open file'      , 'Abrir archivo'    , 'Khiputa kichay'      ,
                               'Datei Öffnen','Відкрити файл','Открыть файл',
                               'Ouvrir un fichier','打开文件');
 acArcSave.Caption    := Trans('&Save'          , '&Guardar'         , '&Waqaychay'          ,
                               '&Speichern','Зберегти','Сохранить',
                               '&Enregistrer','&保存');
 acArcSave.Hint       := Trans('Save file'      , 'Guardar archivo'  , 'Khiputa waqaychay'   ,
                               'Datei speichern','Зберегти файл','Сохранить файл',
                               'Enregistrer fichier','保存文件');
 acArcSaveAs.Caption  := Trans('Sa&ve As...'    , 'G&uardar Como...' , 'Kay hinata &waqaychay',
                               'Speichern &unter ...','Зберегти як...','Сохранить как...',
                               'Enregistrer &sous...','另存为... (&V)');
 acArcSaveAs.Hint     := Trans('Save file as...','Guardar como...'  , 'Kay hinata waqaychay',
                               'Datei mit unter neuem Namen speichern ...','Зберегти файл як...','Сохранить файл как...',
                               'Enregistrer fichier sous...','文件另存为...');
 acArcCloseFile.Caption:=Trans('&Close File'    , '&Cerrar archivo'  , 'Khiputa wi&sqay'     ,
                               'Datei s&chließen','Закрити файл','Закрыть файл',
                               '&Fermer Fichier','•关闭文件');
 acArcCloseProj.Caption:=Trans('Close Project'  , 'Cerrar Proyecto'  , 'Proyectota wisqay'   ,
                               'Projekt schließen','Закрити проект','Закрыть проект',
                               'Fermer Projet','关闭项目');
 mnSamples.Caption    := Trans('Samples'        , 'Ejemplos'         , 'Qhawarinakuna'       ,
                               'Beispiele','Приклади','Примеры',
                               'Exemples','采样');
 acArcQuit.Caption    := Trans('&Quit'          , '&Salir'           , 'Ll&uqsiy'            ,
                               '&Beenden','Вийти','Выход',
                               '&Quitter','&退出');
 acArcQuit.Hint       := Trans('Close the program','Cerrar el programa','Programata wi&sqay',
                               'Programm beenden','Закрити програму','Закрыть программу',
                               'Quitter l''application','关闭程序');

//Edit Actions
 acEdUndo.Caption     := Trans('&Undo'       , '&Deshacer'        , '&Paskay',
                               '&Zurück','Відміна','Отмена',
                               '&Annuler','&撤销');
 acEdUndo.Hint        := Trans('Undo'        , 'Deshacer'         , 'Paskay',
                               'Änderung zurücknehmen','Відміна','Отмена',
                               'Annuler','撤销');
 acEdRedo.Caption     := Trans('&Redo'       , '&Rehacer'         , '&Ruwapay',
                               '&Wiederholen','Повторити','Повторить',
                               '&Refaire','&重做');
 acEdRedo.Hint        := Trans('Redo'        , 'Reahacer'         , 'Ruwapay',
                               'Änderung wiederholen','Повторити','Повторить',
                               'Refaire','重做');
 acEdCut.Caption      := Trans('C&ut'        , 'Cor&tar'          , 'Ku&chuy',
                               'A&usschneiden','Вирізати','Вырезать',
                               'Co&uper','C&ut');
 acEdCut.Hint         := Trans('Cut'         , 'Cortar'           , 'Kuchuy',
                               'Ausschneiden','Вирізати','Вырезать',
                               'Couper','剪切');
 acEdCopy.Caption     := Trans('&Copy'       , '&Copiar'          , 'Kiki&nchay',
                               '&Kopieren','Копіювати','Копировать',
                               'Copier','复制(&C)');
 acEdCopy.Hint        := Trans('Copy'        , 'Copiar'           , 'Kikinchay',
                               'Kopieren','Копіювати','Копировать',
                               'Copier','复制');
 acEdPaste.Caption    := Trans('&Paste'      , '&Pegar'           , 'k''ask&ay',
                               '&Einfügen','Вставити','Вставить',
                               'Co&ller','粘贴(&P)');
 acEdPaste.Hint       := Trans('Paste'       , 'Pegar'            , 'K''askay',
                               'Einfügen','Вставити','Вставить',
                               'Coller','粘贴');
 acEdSelecAll.Caption := Trans('Select &All'    , 'Seleccionar &Todo'  , 'Llapan&ta Akllay',
                               'Alles &Auswählen','Вибрати все','Выбрать всё',
                               'Tout &Sélectionner','全选（＆A）');
 acEdSelecAll.Hint    := Trans('Select all'  , 'Seleccionar todo' , 'Llapanta Akllay',
                               'Alles auswählen','Вибрати все','Выбрать всё',
                               'Tout sélectionner','全选');

//Search Actions
 acSearFind.Caption    := Trans('Find...'      , 'Buscar...'          , 'Maskhay',
                                'Finden...'    , 'Знайти...'          , 'Найти...',
                                'Chercher...','');
 acSearFind.Hint       := Trans('Find text'    , 'Buscar texto'       , 'Qillqata maskhay',
                                'Finde Text'  , 'Знайти текст'       , 'Найти текст',
                                'Chercher texte','');
 acSearFindNxt.Caption := Trans('Find &Next'   , 'Buscar &Siguiente'  , '&Hamuqta Maskhay',
                                '&Weitersuchen','Знайти наступний','Найти следующий',
                                'Chercher &Suivant','');
 acSearFindNxt.Hint    := Trans('Find Next'    , 'Buscar Siguiente'   , 'Hamuqta Maskhay',
                                'Weitersuchen','Знайти наступний','Найти следующий',
                                'Chercher Suivant','');
 acSearFindPrv.Caption := Trans('Find &Previous','Buscar &Anterior'   , '',
                                'Finde &Vorherige','Знайти попередній','Найти предыдущий',
                                'Chercher &Précédent','');
 acSearFindPrv.Hint    := Trans('Find &Previous','Buscar &Anterior'   , '',
                                'Finde &Vorherige','Знайти попередній','Найти предыдущий',
                                'Chercher Précédent','');
 acSearReplac.Caption  := Trans('&Replace...'    , '&Reemplazar...'     , '&Yankiy',
                                '&Ersetzen...','Замінити...','Замена...',
                                '&Remplacer...','');
 acSearReplac.Hint     := Trans('Replace text'   , 'Reemplazar texto'   , 'Qillqata yankiy',
                                'Text ersetzen','Замінити текст','Заменить текст',
                                'Remplacer texte','');

 //View actions
 acViewMsgPan.Caption := Trans('&Messages Panel'         , 'Panel de &Mensajes'           , '&Willanakuna qhawachiq',
                                '&Nachrichten Panel','Панель повідомлень','Панель сообщений',
                                'Panneau &Messages','& 消息面板');
 acViewMsgPan.Hint    := Trans('Show/hide Messages Panel', 'Mostrar/Ocultar el Panel de Mensajes', 'Willanakuna qhawachiqta Rikuchiy/Pakachiy',
                                'Nachrichten Panel zeigen oder verbergen','Показати/Сховати панель повідомлень','Показать/Спрятать панель сообщений',
                                'Montrer/Cacher le panneau des Messages','显示/隐藏消息面板');
 acViewStatbar.Caption:= Trans('&Status Bar'             , 'Barra de &Estado'             , '&Imayna kasqanta Qhawachiq',
                                '&Statuszeile'           , '', '',
                                'Barre de &statut','状态栏');
 acViewStatbar.Hint   := Trans('Show/hide Status Bar'    , 'Mostrar/Ocultar la barra de estado', 'Imayna Kasqanta Rikuchiy/Pakachiy',
                               'Statuszeile zeigen oder verbergen','','',
                               'Montrer/Cacher la barre de statut','显示/隐藏状态栏');
 acViewToolbar.Caption:= Trans('&Tool Bar'               , 'Barra de &Herramientas'       , '&Llamk''anakuna Qhawachiq',
                               '&Werkzeugleiste','Панель інструментів','Панель инструментов',
                               'Barre d''&Outils','工具条');
 acViewToolbar.Hint   := Trans('Show/hide Tool Bar'      , 'Mostrar/Ocultar la barra de herramientas', 'Llamk''anakuna Qhawachiqta Rikuchiy/Pakachiy',
                               'Werkzeugleiste zeigen oder verbergen','Показати/Сховати панель інструментів','Показать/Спрятать панель инструментов',
                               'Montrer/Cacher la barre d''Outils','显示/隐藏工具栏');
 acViewSynTree.Caption:= Trans('&Code explorer'          , '&Explorador de código.'       , '&Chimpukunata t''aqwiq',
                               '&Quelltext-Explorer','Оглядач кода','Обозреватель кода',
                               '&Explorateur de Code','&代码资源管理器');
 acViewAsmPan.Caption := Trans('&Assembler Panel'        , '&Panel de ensamblador.'       , '',
                               '&Assembler Bereich','Панель асемблера','Панель ассемблера',
                               'Panneau &Assembleur','');


//Tool actions
 acToolCompil.Caption  := Trans('&Compile'                , '&Compilar'  , '&Compilay',
                                '&Compilieren'            , 'Компілювати', 'Компилировать',
                                '&Compiler','编译(&C)');
 acToolCompil.Hint     := Trans('Compile the source code' , 'Compila el código fuente'     , 'Pachanmanta chimpukuna kaqta compilay',
                                'Compiliere den Quelltext','Компілювати','Компилировать',
                                'Compiler le code source','编译源代码');
 acToolComEjec.Caption := Trans('Compile and E&xecute'    , 'Compilar y Ej&ecutar'         , 'Compilay chaymanta &Hinay',
                                'Compilieren und Au&sführen','Компілювати та виконати','Компилировать и выполнить',
                                'Compiler et &Exécuter','编译和 E&xecute');
 acToolComEjec.Hint    := Trans('Compile and Execute'     , 'Compilar y Ejecutar'          , 'Compilay chaymanta &Hinay',
                                'Compilieren und Ausführen','Компілювати та виконати','Компилировать и выполнить',
                                'Compiler et Exécuter','编译和执行');
 acToolPICExpl.Caption := Trans('PIC E&xplorer'           , 'E&xplorador de PIC'           , 'PIC nisqakunata T''aqwiq',
                                'PIC E&xplorer','PIC оглядач','PIC обозреватель',
                                'E&xplorateur de PIC','图片 E & xplorer');
 acToolPICExpl.Hint    := Trans('Open the PIC devices explorer','Abrir el explorador de dispos. PIC', 'Dispos. PIC nisqa t''aqwiqta kichariy',
                                'Öffne den PIC Geräte explorer','Відкрити PIC оглядач','Открыть PIC обозреватель',
                                'Ouvrir l''explorateur de modèles PIC','打开 PIC 设备资源管理器');
 acToolListRep.Caption := Trans('&List Report'            , '&Reporte de listado'          , '',
                                '&List-Bericht','Звіт','Отчет',
                                '&Rapport de Compilation','');
 acToolFindDec.Caption := Trans('Find declaration' , 'Ir a la declaración' , 'Riqsichikusqan k''itiman riy',
                                'Finde Deklaration','Знайти декларування','Найти декларирование',
                                'Trouver déclaration','查找声明');
 acToolRamExp.Caption  := Trans('&RAM Explorer' , 'Explorador de &RAM' , '',
                                '&RAM Explorer','','',
                                '','');

 acToolASMDebug.Caption:= Trans('ASM &Debugger'        , '&Depurador de ASM'            , '',
                                'ASM &Debugger','ASM зневаджувач','ASM отладчик',
                                '&Débogueur PIC','');
 acToolASMDebug.Hint   := Trans('ASM &Debugger'        , '&Depurador de ASM'            , '',
                                'ASM &Debugger','ASM зневаджувач','ASM отладчик',
                                'Démarrer le Débogueur','');
 MenuItem51.Caption    := Trans('&Select Compiler'        , '&Elegir Compilador'            , '',
                                '&Select Compiler','','',
                                '','');
 acToolConfig.Caption  := Trans('&Settings'               , '&Configuración'                , 'Kamachina',
                                '&Einstellungen','Налагодження','Настройки',
                                '&Paramètres','&设置');
 acToolConfig.Hint     := Trans('Settings dialog'         , 'Ver configuración'            , 'Kamachinata qhaway',
                                'Einstellungs-Dialog','Діалог налагоджень','Диалог настроек',
                                'Paramètres','设置对话框');

//Messages
 MSG_MODIFIED      := Trans('(*)Modified'      , '(*)Modificado'                  , '',
                         '(*) Geändert','(*)Змінено','(*)Изменено',
                         '(*)Modifié','');
 MSG_SAVED      := Trans('Saved'            , 'Guardado'                       , '',
                         'Gespeichert','Збережено','Сохранено',
                         'Enregistré','');
 MSG_NOFILES    := Trans('No files.'        , 'Sin archivos'                   , '',
                         'Keine Dateien','Немає файлів.','Нет файлов.',
                         'Aucun fichier','');
 MSG_NOFOUND_   := Trans('No found "%s"'    , 'No se encuentra: "%s"'          , '',
                         '"%s" nicht gefunden','Не знайдено "%s"','Не найдено "%s"',
                         '"%s" non trouvé','');
 MSG_N_REPLAC   := Trans('%d words replaced', 'Se reemplazaron %d ocurrencias.', '',
                         '%d Wörter ersetzt','%d слів замінено','%d слов заменено',
                         '%d mots remplacés','');
 MSG_REPTHIS    := Trans('Replace this?'    , '¿Reemplazar esta ocurrencia?'   , '',
                         'Ersetzen','Замінити це?','Заменить это?',
                         'Remplacer ceci?','');
 MSG_SYNFIL_NOF := Trans('Syntax file not found: %s' , 'Archivo de sintaxis no encontrado: %s'   , '',
                         'Syntax-Datei nicht gefunden: %s','','',
                         'Fichier de syntaxe non trouvé : %s','');
 MSG_FILSAVCOMP  := Trans('File must be saved before compiling.', 'Archivo debe ser guardado antes de compilar', '',
                          'Die Datei muss vor dem Kompilieren gespeichert werden.', '', '',
                          'Le fichier doit être sauvegardé pour compiler.','');
 MSG_BASEL_COMP  := Trans('Baseline Compiler', 'Compilador Baseline', '',
                          'Baseline-Compiler', '', '',
                          '','');
 MSG_MIDRAN_COMP := Trans('Mid-range Compiler', 'Compilador Mid-range', '',
                          'Mid-Range-Compiler', '', '',
                          '','');
 MSG_ENMIDR_COMP := Trans('Enhanced Mid-range Compiler', 'Compilador Enhanced Mid-range', '',
                          'Verbesserter Midrange-Compiler', '', '',
                          '','');
 MSG_PROJECT     := Trans('Project: ', '', '',
                          'Projekt: ', '', '',
                          '','');

