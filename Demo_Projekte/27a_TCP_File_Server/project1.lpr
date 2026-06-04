program project1;

uses
  fmem,
  laz_esp,
  esp_spiffs,
  esp_fileIO,
  lwip_sockets,
  lwip_def,
  lwip_inet,
  esp_log2,
  wificonnect2,
  task,
  portmacro;

{$Include PWD.inc}

const
 PORT = 5000;

var
 TAG         : PChar = '27a_TCP';
 Path        : PChar = '/MyFolder';
 FilePath    : PChar = '/MyFolder/MyFile';

procedure SendFile (asock: longint);
var
  f: file;
  fileBuf: array[0..1023] of byte;
  readBytes: longint;
  err: longint;
begin
  AssignFile(f, '/MyFolder/MyFile');
  {$I-}
  Reset(f, 1);
  {$I+}

  if IOResult <> 0 then
  begin
    esp_loge(TAG,'%s', ['File open failed']);
    exit;
  end;

  repeat
    BlockRead(f, fileBuf, SizeOf(fileBuf), readBytes);

    if readBytes > 0 then
    begin
      err := lwip_send(asock, @fileBuf, readBytes, 0);
      if err < 0 then
      begin
        esp_loge(TAG,'%s', ['send failed']);
        CloseFile(f);
        break;
      end;
    end;

  until readBytes = 0;

  CloseFile(f);
  esp_logi(TAG,'%s', ['File transfer complete']);
end;


procedure tcp_server_task(param: pointer);
var
 //Speicher für empfangene Daten
  rx_buffer: array[0..127] of char;
  addr_family: longint;
  ip_protocol: longint;
 //Server‑Socket
  listen_sock,
 //Client‑Socket
  sock,
  len, err: longint;
 //Server‑Adresse (IP/Port)
  destAddr: sockaddr_in;
 // Client‑Adresse
  sourceAddr: sockaddr_in;
  addrLen: longword;
  tv: timeval;

begin
  while True do
  begin
    // IPv4
    FillChar(destAddr, SizeOf(destAddr), 0);
    destAddr.sin_family := AF_INET;
    destAddr.sin_port := lwip_htons(PORT);
    destAddr.sin_addr.s_addr := lwip_htonl(INADDR_ANY);

    addr_family := AF_INET;
    ip_protocol := IPPROTO_IP;

   //Socket erstellen
    listen_sock := lwip_socket(addr_family, SOCK_STREAM, ip_protocol);
    if listen_sock < 0 then  //kleiner 0 bedeutet Fehler
    begin
      ESP_LOGE(TAG,'%s', ['Unable to create socket']);
     //Kann der Socket nicht erstellt werden nach 1 Sekunde wieder probieren
      vTaskDelay(1000 div portTICK_PERIOD_MS);
      continue; //Mit „Continue“ springt man zum Ende der aktuellen Schleife.
    end;
   //Damit wacht der Task spätestens alle 5 Sekunden auf.
    lwip_setsockopt(listen_sock, SOL_SOCKET, SO_RCVTIMEO, @tv, SizeOf(tv));

    ESP_LOGI(TAG,'%s', ['Socket created']);

   //Socket wird an IP/Port gebunden
    err := lwip_bind(listen_sock, @destAddr, SizeOf(destAddr));
    if err <> 0 then
    begin
      esp_loge(TAG,'%s', ['Socket unable to bind']);
      lwip_close(listen_sock);
      continue;
    end;

    esp_logi(TAG,'%s', ['Socket binded']);

   //Auf TCP Verbindungen warten
    err := lwip_listen(listen_sock, 1);
    if err <> 0 then
    begin
      esp_loge(TAG,'%s', ['Error during listen']);
      lwip_close(listen_sock);
      continue;
    end;

    esp_logi(TAG,'%s', ['Socket listening']);

    addrLen := SizeOf(sourceAddr);
   //Verbindung akzeptieren
    sock := lwip_accept(listen_sock, @sourceAddr, @addrLen);
    if sock < 0 then
    begin
      esp_loge(TAG,'%s', ['Unable to accept connection']);
      lwip_close(listen_sock);
      continue;
    end;
   //Damit wacht der Task spätestens alle 5 Sekunden auf.
    lwip_setsockopt(sock, SOL_SOCKET, SO_RCVTIMEO, @tv, SizeOf(tv));
    esp_logi(TAG,'%s', ['Socket accepted']);

    while True do
    begin
     //Daten empfangen
      len := lwip_recv(sock, @rx_buffer, SizeOf(rx_buffer)-1, 0);

      if len < 0 then
      begin
        esp_loge(TAG,'%s', ['recv failed']);
        break;
      end
      else if len = 0 then
      begin
        esp_logi(TAG,'%s', ['Connection closed']);
        break;
      end
      else
      begin
       //Buffer wird als String ausgegeben
        rx_buffer[len] := #0;
        esp_logi(TAG, '%s %d %s', ['Received',len,'bytes']);
        esp_logi(TAG,'%s', [PChar(@rx_buffer)]);

       SendFile(sock);

      end;
    end;

   //Verbindung schließen
    lwip_shutdown(sock, 0);
    lwip_close(sock);
    lwip_close(listen_sock);
  end;

  vTaskDelete(nil);
end;

begin

 SerialBegin(9600);

 connectWifiAP(AP_NAME,PWD);
 repeat
  writeln('Start Wifi ...');
 until stationConnected = true;

 RegisterSpiffs(5,Path,Tag);
 sleep(2000);//etwas warten bis spiffs registriert
 if FileDelete(FilePath) then writeln ('File deleted');
 if not FileExists(FilePath) then
  FileWrite(FilePath,'Das ist eine von mir erzeugte Datei');

 xTaskCreate(@tcp_server_task, 'tcp_server', 4096, nil, 5, nil);

 repeat
  sleep(100);
 until false ;
 UnRegisterSpiffs(Tag);
end.
