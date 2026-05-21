program tcp01;

{$include freertosconfig.inc}

uses
  fmem,
  task,
  portmacro,
  lwip_sockets,
  lwip_inet,
  esp_log2,
  lwip_def,
  wificonnect2,
  laz_esp;


{$Include PWD.inc}


const
  TAG = 'TCP Echo Server';
  PORT = 5000;


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
      esp_loge(TAG,'%s', ['Unable to create socket']);
     //Kann der Socket nicht erstellt werden nach 1 Sekunde wieder probieren
      vTaskDelay(1000 div portTICK_PERIOD_MS);
      continue;
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


       //Daten zurücksenden (hier das was empfangen wurde)
        rx_buffer[len]   := #13; //RecvString() braucht CR/LF
        rx_buffer[len+1] := #10;
        err := lwip_send(sock, @rx_buffer, len+2, 0);
        if err < 0 then
        begin
          esp_loge(TAG,'%s', ['send failed']);
          break;
        end;
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

 xTaskCreate(@tcp_server_task, 'tcp_server', 4096, nil, 5, nil);

 repeat
  vTaskDelay(100);
 until false;

end.

