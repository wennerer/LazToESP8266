program project1;

{$Include sdkconfig.inc}

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

(*-------------------------------------------Geht auch so für reine Textdateien----------------------------------------
procedure SendFile (asock: longint);
var
  f: PFILE;
  lineBuf: array[0..255] of Char;
begin
  f := fopen('/MyFolder/MyFile', 'r');

  if f = nil then
    Exit;

  while fgets(@lineBuf[0], SizeOf(lineBuf), f) <> nil do
  begin
    lwip_send(asock, @lineBuf[0], strlen(@lineBuf[0]), 0);
  end;

  fclose(f);
end;
*)


procedure SendFile(asock: LongInt);
var
  f: PFILE;
  fileBuf: array[0..1023] of Byte;
  readBytes: SizeUInt;
  err: LongInt;
begin
  f := fopen('/MyFolder/MyFile', 'rb');

  if f = nil then
  begin
    esp_loge(TAG,'%s',['File open failed']);
    Exit;
  end;

  repeat
    readBytes := fread(@fileBuf[0], 1, SizeOf(fileBuf), f);

    if readBytes > 0 then
    begin
      err := lwip_send(asock, @fileBuf[0], readBytes, 0);

      if err < 0 then
      begin
        esp_loge(TAG,'%s',['send failed']);
        Break;
      end;
    end;

  until readBytes = 0;

  fclose(f);

  esp_logi(TAG,'%s',['File transfer complete']);
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
  end;

 ESP_LOGI(TAG,'%s', ['Socket created']);

//Socket wird an IP/Port gebunden
 err := lwip_bind(listen_sock, @destAddr, SizeOf(destAddr));
 if err <> 0 then
  begin
   esp_loge(TAG,'%s', ['Socket unable to bind']);
   lwip_close(listen_sock);
  end;

 esp_logi(TAG,'%s', ['Socket binded']);

//Auf TCP Verbindungen warten
 err := lwip_listen(listen_sock, 1);
 if err <> 0 then
  begin
   esp_loge(TAG,'%s', ['Error during listen']);
   lwip_close(listen_sock);
   exit;
   //continue;
  end;
 while True do
  begin
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

   esp_logi(TAG,'%s', ['Socket accepted']);

   while True do
    begin
     //Daten empfangen
      len := lwip_recv(sock, @rx_buffer, SizeOf(rx_buffer)-1, 0);
      if len < 0 then
       begin
        esp_loge(TAG,'%s', ['recv timeout']);
        continue;
       end
      else if len = 0 then
       begin
        esp_logi(TAG,'%s', ['client disconnected']);
        break;
       end
      else
       begin
      //Buffer wird als String ausgegeben
        rx_buffer[len] := #0;
        esp_logi(TAG, '%s %d %s', ['Received',len,'bytes']);
        esp_logi(TAG,'%s', [PChar(@rx_buffer)]);

        SendFile(sock);
        break;
       end;
     end;

   //Verbindung schließen
    lwip_shutdown(sock, 0);
    lwip_close(sock);

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
 sleep(1000);
 if not FileExists(FilePath) then
  begin
   FileWrite(FilePath,'Das ist eine von mir erzeugte Datei');
   FileAppend(FilePath,'Zeile 1');
   FileAppend(FilePath,'Zeile 2');
   FileAppend(FilePath,'Zeile 3');
   FileAppend(FilePath,'Zeile 4');
   FileAppend(FilePath,'Zeile 5');
   writeln('File created');
  end;

 sleep(1000);
 xTaskCreate(@tcp_server_task, 'tcp_server', 4096, nil, 5, nil);

 repeat
  sleep(100);
 until false ;
 UnRegisterSpiffs(Tag);
end.
