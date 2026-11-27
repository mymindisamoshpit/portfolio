procedure Tfr.SetConnectionParams;
begin
  // Загружаем тип подключения из JSON
  DrvFR.ConnectionType := fr_config.GetValue<integer>('fr_connection_type');
  DrvFR.ProtocolType := 0;
  
  if (DrvFR.ConnectionType = 0) then
  begin
    // Настройка COM-порта
    DrvFR.ComNumber := fr_config.GetValue<integer>('fr_com_number');
    DrvFR.BaudRate := fr_config.GetValue<integer>('fr_baud_rate');
  end
  else if (DrvFR.ConnectionType = 6) then
  begin
    // Настройка TCP/IP
    DrvFR.IPAddress := fr_config.GetValue<string>('fr_ip_address');
    DrvFR.TCPPort := fr_config.GetValue<integer>('fr_tcp_port');
    DrvFR.UseIPAddress := StrToBool('True');
  end;
  
  DrvFR.Timeout := fr_config.GetValue<integer>('fr_timeout');
  DrvFR.Password := 30; // Системный пароль
end;
