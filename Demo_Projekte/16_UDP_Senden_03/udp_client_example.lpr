program udp_lesen_WIZ;

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
  HOST_IP_ADDR = '192.168.178.93'; // anpassen, das ist die IP des Gerätes an das gesendet wird
  PORT = 38899;   //Dieser Port muss für die WIZ Geräte verwendet werden!

  AP_NAME  = //'DEINE_SSID';
  PWD      = //'DEIN_Netzwerkschlüssel';

  const payload_get  : PChar = '{"method": "getPower"}';


var
  payload       : PChar;

 function ExtractPower(json: PChar; out value: Integer): Boolean;
 var
   p: PChar;
   neg: Boolean;
 begin
    Result := False;
    value := 0;

    //Erwarteter json: {"method":"getPower","env":"pro","result":{"power":62207}}
    p := StrPos(json, '"power":');
    if p = nil then
      Exit;

    Inc(p, 8); // hinter "power":

    // whitespace überspringen
    while (p^ = ' ') do
      Inc(p);

    // negatives Vorzeichen
    neg := False;
    if p^ = '-' then
    begin
      neg := True;
      Inc(p);
    end;

    // nur Zahlen
    if not (p^ in ['0'..'9']) then
      Exit;

    // Zahl parsen
    while (p^ in ['0'..'9']) do
    begin
      value := value * 10 + (Ord(p^) - Ord('0'));
      Inc(p);
    end;

    //von milliWatt nach Watt
    Value := round(Value / 1000);

    if neg then
      value := -value;

    Result := True;
 end;


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

  Watt : integer;

begin
  while True do
  begin
    FillChar(destAddr, SizeOf(destAddr), 0);

    destAddr.sin_addr.s_addr := inet_addr(HOST_IP_ADDR);
    destAddr.sin_family := AF_INET;
    destAddr.sin_port := lwip_htons(PORT);

    addr_family := AF_INET;
    ip_protocol := IPPROTO_IP;

    sock := lwip_socket(addr_family, SOCK_DGRAM, ip_protocol);

    if sock < 0 then
    begin
      ESP_LOGE(TAG, 'Unable to create socket',[]);
      break;
    end;

    ESP_LOGI(TAG, 'Socket created',[]);



    while True do
    begin

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
        rx_buffer[len] := #0; //Hier wird Null terminiert
        ExtractPower(PChar(@rx_buffer[0]),Watt);
        writeln(Watt);

        inet_ntoa_r(sourceAddr.sin_addr, @addr_str, SizeOf(addr_str)-1);
        writeln(addr_str);

      end;

      vTaskDelay(5000 div portTICK_PERIOD_MS);

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

  Payload := payload_get;

  xTaskCreate(
    @udp_client_task,
    PChar('udp_client'),
    4096,
    nil,
    5,
    nil
  );

  while True do
  begin
   sleep(100);
  end;

end.
