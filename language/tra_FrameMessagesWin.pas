MSG_INICOMP := trans('Starting Compilation...', 'Iniciando compilación...', '',
                     'Compilieren ausführen...','Починаю компіляцію...','Начинаю компиляцию...', 'Lancement de la compilation....','正在开始编译...');
MSG_WARN    := trans('Warning'                , 'Advertencia'             , 'Avertissement',
                     'Warnung','Попередження','Предупреждение', '','警告');
MSG_WARNS   := trans('Warnings'               , 'Advertencias'            , '',
                     'Warnungen','Попередження','Предупреждения', 'Avertissements','警告');
MSG_ERROR   := trans('Error'                  , 'Error'                   , '',
                     'Fehler','Помилка','Ошибка', 'Erreur','错误');
MSG_ERRORS  := trans('Errors'                 , 'Errores'                 , '',
                     'Fehler','Помилки','Ошибки', 'Erreurs','错误');
MSG_COMPIL  := trans('Compiled in: '          , 'Compilado en: '          , '',
                     'Compiliert in: ','Скомпільовано за: ','Скомпилировано за: ', 'Compilé en:','编译于：');

lblInform.Caption := Trans('Information'     , 'Información'      , ''      ,
                           'Information'       , 'Інформація'  ,'Информация', 'Information','信息');
lblWarns.Caption  := Trans('Warnings'        , 'Advertencias'     , ''      ,
                           'Warnungen'         , 'Попередження','Предупреждения', 'Avertissements','警告');
lblErrors.Caption := Trans('Errors'          , 'Errores'          , ''      ,
                           'Fehler'            , 'Помилки'     ,'Ошибки', 'Erreurs','错误');
PanGrilla.Caption := Trans('<< No messages >>','<< Sin mensajes >>',''      ,
                           '<<Keine Meldungen>>','<< Немає повідомлень >>','<< Нет сообщений >>', '<< Aucun message >>','[无消息]');
mnClearAll.Caption:= Trans('Clear &All'      , 'Limpiar &Todo'    , ''      ,
                           'Alle lös&chen'                 , 'Зтерти все'  ,'', 'Effacer &Tout','');
mnCopyRow.Caption := Trans('&Copy Row'       , '&Copiar fila'     , ''      ,
                           'Zeile &kopiere'                 , '','', '&Copier ligne','');

