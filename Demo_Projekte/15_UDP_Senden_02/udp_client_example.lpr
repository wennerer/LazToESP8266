program udp_senden_WIZ;

{$mode objfpc}{$H+}

uses
  fmem,
  SysUtils,
  lwip_sockets,
  task,
  esp_log2,
  portmacro,
  lwip_inet,
  lwip_def,
  wificonnect2,
  Laz_ESP;

const
  TAG = 'First_WIZ';
  HOST_IP_ADDR = '192.168.178.92'; // anpassen, das ist die IP des Gerätes an das gesendet wird
  PORT = 38899;   //Dieser Port muss für die WIZ Geräte verwendet werden!

  AP_NAME  = //'DEINE_SSID';
  PWD      = //'DEIN_Netzwerkschlüssel';

  const payload_on  : PChar = '{"method":"setState","params":{"state":true}}';
  const payload_off : PChar = '{"method":"setState","params":{"state":false}}';

var
  payload       : PChar;
  State         : boolean;

procedure udp_client_task(pvParameters: Pointer);
var
  rx_buffer : array[0..127] of char;
  addr_str  : array[0..127] of char;
  addr_family : Integer;
  ip_protocol : Integer;

  destAddr : sockaddr_in;
  sourceAddr : sockaddr_in;
  sock : Integer;
  err : Integer;
  len : Integer;
  socklen : socklen_t;

begin
  while True do
  begin
    FillChar(destAddr, SizeOf(destAddr), 0);

    destAddr.sin_addr.s_addr := inet_addr(HOST_IP_ADDR);
    destAddr.sin_family := AF_INET;
    destAddr.sin_port := lwip_htons(PORT);

    addr_family := AF_INET;
    ip_protocol := IPPROTO_IP;

    inet_ntoa_r(destAddr.sin_addr, @addr_str, SizeOf(addr_str));
    writeln('Adresse:',StrPas(@addr_str[0]));

    sock := lwip_socket(addr_family, SOCK_DGRAM, ip_protocol);

    if sock < 0 then
    begin
      ESP_LOGE(TAG, 'Unable to create socket',[]);
      break;
    end;

    ESP_LOGI(TAG, 'Socket created',[]);



    while True do
    begin
      if not State then
       begin
        payload := payload_on;  //Einschalten
        State := true;
        writeln('Ich schalte Ein');
       end
      else
       begin
        payload := payload_off;  //Ausschalten
        State := false;
        Writeln('Ich schalte Aus');
       end;


      err := lwip_sendto(
        sock,
        payload,
        strlen(payload),
        0,
        @destAddr,
        SizeOf(destAddr)
      );

      if err < 0 then
      begin
        ESP_LOGE(TAG, 'Error occurred during sending, %d',[Err]);
        break;
      end;

      ESP_LOGI(TAG, 'Message sent, %d',[Err]);

      socklen := SizeOf(sourceAddr);

      len := lwip_recvfrom(
        sock,
        @rx_buffer,
        SizeOf(rx_buffer) -1,
        0,
        @sourceAddr,
        @socklen
      );

      if len < 0 then
      begin
        ESP_LOGE(TAG, 'recvfrom failed, %d',[Len]);
        break;
      end
      else
      begin
        rx_buffer[len] := #0;
        writeln('Received ',len,' bytes from ', StrPas(@addr_str[0]));
        ESP_LOGI(TAG, '%s , %d', [rx_buffer, Len]);

        inet_ntoa_r(sourceAddr.sin_addr, @addr_str, SizeOf(addr_str));
        writeln('SourceAdresse:',StrPas(@addr_str[0]));
      end;

      vTaskDelay(2000 div portTICK_PERIOD_MS);

    end;

    if sock <> -1 then
    begin
      ESP_LOGE(TAG, 'Shutting down socket and restarting... ,%d',[sock]);
      lwip_shutdown(sock, 0);
      lwip_close(sock);
    end;
  end;

  vTaskDelete(nil);
end;

begin
  SerialBegin(9600);

  connectWifiAP(AP_NAME, PWD);

  State := false;

  xTaskCreate(
    @udp_client_task,
    PChar('udp_client'),
    8192,//4096,
    nil,
    5,
    nil
  );

  while True do
  begin
   sleep(100);
  end;

end.
