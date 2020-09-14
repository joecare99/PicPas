var
  TIT_CFG_ENVIRON, TIT_CFG_MESPAN, TIT_CFG_CODEXP,
  TIT_CFG_EDITOR, TIT_CFG_SYNTAX,
  TIT_CFG_ASSEMB,  TIT_CFG_COMPIL, TIT_CFG_EXTOOL: String;
  LABEL_THEM_NONE, TIT_CFG_EDICOL: String;

procedure TConfig.SetLanguage;
begin
  fraCfgSynEdit.SetLanguage;
  fraCfgExtTool.SetLanguage;
  fraCfgSyntax.SetLanguage;

Caption              := Trans('Settings'               , 'Configuración'            , '',
                              'Einstellungen','Налаштування','Настройки', 'Paramètres','设置');
BitAceptar.Caption   := Trans('&OK'                    , 'Aceptar'                  , '',
                              '&Ok','','', '&Ok','&确认');
BitAplicar.Caption   := Trans('&Apply'                 , 'Aplicar'                  , '',
                              '&Übernehmen','Застосувати','Применить', '&Appliquer','&应用');
BitCancel.Caption    := Trans('&Cancel'                , 'Cancelar'                  , '',
                              '&Abbrechen','Відміна','Отмена', 'A&nnuler','&取消');

////////////////////////////////////////////////////////////////////////////
//////////////////////////  Environment Settings //////////////////////////
////////////////////////////////////////////////////////////////////////////
TIT_CFG_ENVIRON     := Trans('Environment', 'Entorno', '',
                             'Umgebung','Оточення','Окружение', 'Environnement','');

Label2.Caption      := Trans('Language'               , 'Lenguaje'                 , '',
                              'Sprache','Мова','Язык', 'Langue','语言');
RadioGroup1.Caption := Trans('Toolbar'                 , 'Barra de herramientas'    , 'Barre d''outils',
                              'Werkzeugleiste','Панель інструментів','Панель инструментов', '','工具栏');
RadioGroup1.Items[0]:= Trans('Small Icons'             , 'Íconos pequeños'          , '',
                              'Kleine Bilder','Маленькі піктограми','Маленькие иконки', 'Petites Icônes','小图标');
RadioGroup1.Items[1]:= Trans('Big Icons'               , 'Íconos grandes'           , '',
                              'Große Bilder','Великі піктограми','Большие иконки', 'Grandes Icônes','大图标');
label1.Caption      := Trans('Units Path:'             , 'Ruta de unidades'         , '',
                              'Unitpfad:','','', 'Répertoire des unités:','单位路径：');

label3.Caption      := Trans('&Set Theme'        , '&Fijar Tema', '',
                               '&Wähle Design','Обрати тему','Выбрать тему', '&Charger un thème','');
LABEL_THEM_NONE     := Trans('None', 'Ninguno', '',
                             'Keine','Нічого','Ничего', 'Aucun','');
label4.Caption      := Trans('&Create Theme'        , '&Crear Tema', '',
                               '&Design erstellen','Створити тему','Создать тему', '&Créer un thème','');
butSaveCurThem.Caption := Trans('&Save current config.', 'Guardar config. actual', '',
                             '&Aktuelle Konfiguration speichern.','Зберегти налаштування','Сохранить настройки', '&Enregister thème actuel');;

chkLoadLast.Caption := Trans('', 'Cargar último archivo editado', '',
                             'Letzte editierte Datei laden','Завантажити останній файл','Загрузить последний файл', 'Charger le dernier' + #13#10 + 'fichier édité');

lblPanelCol.Caption := Trans('Panels Color:'             , 'Color de los paneles:', '',
                               'Paneelenfarbe:','Колір панелей:','Цвет панелей:', 'Couleur des panneaux:','面板颜色：');
lblSplitCol.Caption := Trans('Splitters color:'          , 'Color de los separadores:', '',
                               'Trenner-Farbe:','Колір розподілувача:','Цвет разделителя:', 'Couleur des séparateurs:','');

////////////////////////////////////////////////////////////////////////////
//////////////////////////  Code Explorer //////////////////////////
////////////////////////////////////////////////////////////////////////////
TIT_CFG_CODEXP    := Trans('Code Explorer', 'Explorador de Código', '',
                           'Quellenexplorer','Оглядач коду','Инспектор кода', 'Explorateur de Code','');
lblCodExplCol1.Caption:= Trans('Back color:' , 'Color de Fondo:', '',
                               'Code-Explorer Hintergrundfarbe:','Колір фону:','Цвет фона:', 'Couleur de fond','代码资源管理器背面颜色：');
lblCodExplCol2.Caption:= Trans('Text Color:' , 'Color de Texto:', '',
                               'Code-Explorer Textfarbe:','Колір тексту:','Цвет текста:', 'Couleur du texte','代码资源管理器文本颜色：');
grpFilType.Caption    := Trans('File types shown:' , 'Tipos de archivos mostrados:', '',
                               'Gezeigte Dateitypen:','','', 'Types de fichiers affichés:','');
////////////////////////////////////////////////////////////////////////////
//////////////////////////  Message Panel //////////////////////////
////////////////////////////////////////////////////////////////////////////
TIT_CFG_MESPAN    := Trans('Message Panel', 'Panel de Mensajes', '',
                           'Nachrichtenbereich','Панель повідомлень','Панель сообщений', 'Panneau de Messages','');
lblMessPan1.Caption   := Trans('Back color'   , 'Color de Fondo', '',
                               'Nachrichtenpaneel Hintergrundfarbe','Колір фону','Цвет фона', 'Couleur de fond','消息面板背面颜色');
lblMessPan2.Caption   := Trans('Text color:'  , 'Color de Texto', '',
                               'Nachrichtenpaneel Textfarbe:','Колір тексту:','Цвет текста:', 'Couleur du texte:','消息面板文本颜色：');
lblMessPan3.Caption   := Trans('Error color:' , 'Color de Error', '',
                               'Nachrichtenpaneel Fehlerfarbe:','Колір помилки:','Цвет ошибки:', 'Couleur des erreurs:','消息面板错误颜色：');
lblMessPan4.Caption   := Trans('Selection color:', 'Color de Selección', '',
                               'Nachrichtenpaneel Auswahlfarbe:','Колір обраного:','Цвет выделения:', 'Couleur de sélection:','消息面板 Selec.颜色：');

////////////////////////////////////////////////////////////////////////////
//////////////////////////  Editor settings ///////////////////////////////
////////////////////////////////////////////////////////////////////////////
TIT_CFG_EDITOR    := Trans('Editor'                 , 'Editor'                   , '',
                              'Editor','Редактор','Редактор', 'Editeur','');

Label6.Caption       := trans('&Font:'                 , '&Letra:'                     ,'',
                              'Schri&ftart:','Шрифт:','Шрифт:', 'Police','');
Label7.Caption       := trans('&Size:'                 , '&Tamaño:'                    ,'',
                              '&Größe:','Розмір:','Размер:', 'Taille','');
chkViewVScroll.Caption:= trans('&Vertical Scrollbar'    , 'Barra de desplaz &Vert.'     ,'',
                              '& Vertikale Bildlaufleiste','Вертикальній скролбар','Вертикальный скролбар', 'Barre de défilement' + #13#10 + 'verticale','');
chkViewHScroll.Caption:= trans('&Horizontal Scrollbar'  , 'Barra de desplaz &Horiz.'    ,'',
                              '&Horizontale Bildlaufleiste','Горизонтальний скролбар','Горизонтальный скролбар', 'Barre de défilement' + #13#10 + 'horizontale','');

grpTabEdiState.Caption :=Trans('Tab Editor State'  , 'Estado de pestañas del editor', '',
                              'Registerkarte Editor Zustand','','', 'Affichage des onglets');;
grpTabEdiState.Items[0]:=Trans('&Show always'      , '选项卡编辑器状态', '',
                              '','Показувати завжди','Показывать всегда', '&Toujours afficher');
grpTabEdiState.Items[1]:=Trans('Hide for &One file', '&Ocultar si hay un archivo', '',
                              'Ausblenden für &eine Datei','Сховати для одного файлу','Скрыть для одного файла', '&Si plusieurs fichiers','隐藏为 &一个文件');
grpTabEdiState.Items[2]:=Trans('&Hide always'      , 'Ocultar &Siempre'          , '',
                              '&Immer ausblenden','Ховати завжди','Прятать всегда', '&Toujours cacher','• 始终隐藏');

chkAutSynChk.Caption := Trans('Automatic Syntax checking', 'Verificac. Automática de sintaxis', '',
                              'Automatische Syntaxprüfung','Автомтична перевірка синтаксису','Автоматическая проверка синтаксиса', 'Correction de syntaxe automatique','自动语法检查');

////////////////////////////////////////////////////////////////////////////
//////////////////////////// Editor Colors Settings ////////////////////////
////////////////////////////////////////////////////////////////////////////
TIT_CFG_EDICOL      := Trans('Colors'                 , 'Colores'                   , '',
                             'Farben','Кольори','Цвета', 'Couleurs','');
////////////////////////////////////////////////////////////////////////////
//////////////////////////// Editor-Syntax Settings ////////////////////////
////////////////////////////////////////////////////////////////////////////
TIT_CFG_SYNTAX      := Trans('Syntax'                 , 'Sintaxis'                 , '',
                             'Syntax','Синтакс','Синтакс', 'Syntaxe','');
////////////////////////////////////////////////////////////////////////////
//////////////////////////// Assembler settings ////////////////////////////
////////////////////////////////////////////////////////////////////////////
TIT_CFG_ASSEMB       := Trans('Assembler'              , 'Ensamblador'              , '',
                                 'Assembler','Асемблер','Ассемблер', 'Assembleur','');
chkIncHeadMpu.Caption:= Trans('Include MPU &Header'    , 'Incluir &Encabezado de MPU','',
                              'MPU &Kopfzeilen einbinden','Включити MPU заголовок','Включить MPU заголовок', 'Inclure les directives de processeur','包括 MPU + 标题');
chkIncDecVar.Caption := Trans('Include &Variables declaration', 'Incluir Declaración de variables', '',
                              'Variablendeklaration einfügen','Включити декларування змінних','Включить объявление переменных', 'Inclure les déclarations de &variables','包括 &变量声明');
RadioGroup2.Caption  := Trans('Style'                  , 'Estilo'                   , '',
                              'Stil','Стиль','Стиль', 'Style','样式');
chkExcUnused.Caption  := Trans('Exclude unused'         , 'Excluir no usadas'        , '',
                             'Unbenutzte ausschlieÃen','Виключити невикористовуване','Исключить неиспользуемое', 'Exclure les portions inutilisées','排除未使用的');
chkIncAddress.Caption := Trans('Include &Memory Address','Incluir &Dirección de memoria','',
                               'Speicheradressen einbinden','Включити Memory Address','Включить Memory Address', 'Inclure les adresses' + #13#10 + '&mémoire','包括和内存地址');
chkIncComment.Caption := Trans('Include &Comments'      , 'Incluir &Comentarios'     , '',
                               'Kommentare hinzufügen','Включити коментарі','Включить комментарии', 'Inclure les' + #13#10 + '&commentaires','包括和评论');
chkIncComment2.Caption:= Trans('Include &Detailed comments', 'Incluir Comentarios &detallados' , '',
                               '&Detaillierte Kommentare hinzufügen','Включити детальні коментарі','Включить детальные комментарии', 'Inclure les commentaires' + #13#10 + '&détaillés','包括 +详细评论');
chkIncVarName.Caption := Trans('Include &Variable Names','Incluir Nombre de &Variables','',
                               '&Variablennamen einbinden','Включити імена змінних','Включить имена переменных', 'Inclure les &noms de' + #13#10 + 'variables','包括 &变量名称');
////////////////////////////////////////////////////////////////////////////
//////////////////////////// Output Settings ///////////////////////////////
////////////////////////////////////////////////////////////////////////////
TIT_CFG_COMPIL         := Trans('Compiler'               , 'Compilador'               , '',
                                'Compiler','Компілятор','Компилятор', 'Compilateur','');
chkShowErrMsg.Caption  := Trans('&Show Error Messages'   , '&Mostrar mensajes de error', '',
                                '&Zeige Fehlermeldungen','Показувати сповіщення про помилки','Показывать сообщения об ошибках', '&Afficher les messages d''erreur','•显示错误消息');
grpOptimLev.Caption    := Trans('Optimization Level:'    , 'Nivel de optimización:'   , '',
                                'Optimierungsstufe:','Рівень оптимізації:','Уровень оптимизации:', 'Niveau d''optimisation:','优化级别：');
grpOptimLev.Items[0]   := Trans('Fool'                   , 'Tonto'                    , '',
                                'Dumm','Дурень','Дурак', 'Basique','弄臣');
grpOptimLev.Items[1]   := Trans('Smart'                  , 'Inteligente'              , '',
                                'Schlau','Розумний','Умный', 'Avancé','智能');
chkOptBnkAftIF.Caption := Trans('After IF structure'    , 'Después de instrucciones IF.', '',
                               'Nach IF-Struktur','Після структури IF','После структуры IF', 'Après le bloc IF','在 IF 结构之后');
chkOptBnkBefPro.Caption:= Trans('Before Procedures'     , 'Antes de procedimientos.', '',
                               'Vor Prozeduren','Перед процедурами','Перед процедурами', 'Avant les procédures','程序前');
chkOptBnkAftPro.Caption:= Trans('After Procedures'      , 'Después de procedimientos.', '',
                                'Nach den Prozeduren','Після адреси','После адреса', 'Après les procédures','程序后');
chkReuProcVar.Caption  := Trans('Reuse Procedures Variables', 'Reutilizar variables de proced.', '',
                                'Prozedurvariablen wiederverwenden','Повторно використовувати змінні процедур','Повторно использовать переменные процедур', 'Ré-utiliser les variables de procédure','');
////////////////////////////////////////////////////////////////////////////
//////////////////////////// External Tool ////////////////////////////
////////////////////////////////////////////////////////////////////////////
TIT_CFG_EXTOOL    := Trans('External Tool'           , 'Herramienta Externa'      , '',
                           'Externes Werkzeug','Завнішній інструмент','Внешний инструмент', 'Outils Externes','');
FillTree;
end;

