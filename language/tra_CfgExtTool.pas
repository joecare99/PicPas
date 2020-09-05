procedure TfraCfgExtTool.SetLanguage;
begin
  //Editor settings
  label1.Caption      := trans('Name:'            , 'Nombre:'              ,'Suti:',
                               ''                 , 'Імʼя','Имя', 'Nom:');
  label2.Caption      := trans('Program Path:'    , 'Ruta del programa:'   ,'Programapa ñannin:',
                               ''                 , 'Шлях до програми:','Путь к программе:', 'Répertoire de l''application:');
  label3.Caption      := trans('Command line:'    , 'Línea de comando:'     ,'',
                               ''                 , 'Командний рядок:','Коммандная строка:', 'Ligne de commande:');
  label5.Caption      := trans('To reference the output *.hex file, use $(hexFile)',
                               'Para referirse al archivo de salida, usar $(hexFile)', '',
                               ''                 , 'Для посилання на вихідний *.hex файл, використовуй $(hexFile)','Для ссылки на выходной *.hex файл, используй $(hexFile)', '$(hexFile) : insüre le fichier .hex');
  label6.Caption      := trans('To reference the source file, use ${mainFile}',
                               'Para referirse al archivo fuente, usar $(mainFile)', '',
                               ''                 , 'Для посилання на файл сирця, use ${mainFile}','Для ссылки на файл исходника, используй ${mainFile}', '$(mainFile) : insère le fichier source');
  label4.Caption      := trans('16x16 icon:'      , 'Ícono de 16x16:'        ,'',
                               ''                 , '', '', '');
  label7.Caption      := trans('32x32 icon:'      , 'Ícono de 32x32:'        ,'',
                               ''                 , '', '', '');

  chkWaitExit.Caption := trans('&Wait on exit'    , '&Esperar a terminar'   ,'Tukurinanta &Suyariy',
                               ''                 , '', '', '&Attendre la fin de l''exécution');
  chkShowTBar.Caption := trans('&Show in Toolbar' , '&Mostrar en la barra de Herram.' ,'',
                               ''                 , 'Показувати в тулбарі','Показывать в тулбаре', '&Montrer dans la barre d''outils');
  butTest.Caption     := trans('&Test'            , '&Probar'                ,'',
                               ''                 , 'Тест','Тест', '&Tester');
  butAdd.Caption      := trans('&Add'             , '&Agregar'                ,'',
                                ''                , 'Додати','Добавить', '&Ajouter');
  butRemove.Caption   := trans('&Remove'          , '&Eliminar'                ,'',
                                ''                , 'Видалити','Удалить', '&Supprimer');

  ER_FAIL_EXEC_       := trans('Fail executing: %s', 'Falla ejecutando: %s', '',
                               ''                  , 'Невдале виконання: %s','Сбой выболнения: %s', 'Erreur d''exécution: %s');
  PRE_TOOL_NAME       := trans('Tool'              , 'Herramienta', '',
                               ''                  , 'Інструмент','Инструмент', 'Outil');
  ER_ICO_FIL_UNEXIS_  := trans('Icon file doesn''t exist: %s', 'No existe el archivo de ícono: %s', '',
                               ''                  , '', '', '');
  ER_BOTH_ICO_SPEC   := trans('Both icon files must be specified.', 'Se debe especificar ambos íconos.', '',
                               ''                  , '', '', '');

end;

