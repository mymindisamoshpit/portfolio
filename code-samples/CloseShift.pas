procedure Tfr.CloseShift;
begin
  try
    // Проверка флага игнорирования Z-отчета
    if StrToBool(QueueRecord.ignore_z_report) = True then
    begin
      QueueRecord.FrResultCode := '0';
      QueueRecord.FrResultCodeDescription := QuotedStr('Ошибок нет');
      QueueRecord.FrPrintResultCode := '0';
      QueueRecord.FrPrintResultCodeDescription := QuotedStr('Ошибок нет');
    end
    else
    begin
      // Установка данных кассира (требование 54-ФЗ)
      SetCashierName(Parameters.Attributes['CashierName']);
      SetCashierINN(Parameters.Attributes['CashierINN']);
      
      // Печать Z-отчета через COM-объект
      DrvFR.PrintReportWithCleaning;
      QueueRecord.FrResultCode := IntToStr(DrvFR.ResultCode);
      QueueRecord.FrResultCodeDescription := QuotedStr(DrvFR.ResultCodeDescription);
      
      if (QueueRecord.FrResultCode = '0') then
      begin
        DrvFR.WaitForPrinting;
        QueueRecord.FrPrintResultCode := IntToStr(DrvFR.ResultCode);
        QueueRecord.FrPrintResultCodeDescription := QuotedStr(DrvFR.ResultCodeDescription);
      end;
    end;
    
    // Сохранение результата в БД
    SaveResult;
    
  except
    on E: Exception do
      WriteLog('CloseShift ' + E.ClassName + ' ' + E.Message); // Логирование ошибок
  end;
end;
