program udp_client_example;

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
  wificonnect2;

const
  TAG = 'example';
  HOST_IP_ADDR = '192.168.178.52'; // anpassen, das ist die IP des Gerätes an das gesendet wird
  PORT = 3333;

  payload : PChar = 'Message from ESP8266';

  AP_NAME  = //'DEINE_SSID';
  PWD      = //'DEIN_Netzwerkschlüssel';

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

    sock := lwip_socket(addr_family, SOCK_DGRAM, ip_protocol);

    if sock < 0 then
    begin
      ESP_LOGE(TAG, 'Unable to create socket',[err]);
      break;
    end;

    ESP_LOGI(TAG, 'Socket created',[err]);

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
        ESP_LOGE(TAG, 'Error occurred during sending',[Err]);
        break;
      end;

      ESP_LOGI(TAG, 'Message sent',[Err]);

      socklen := SizeOf(sourceAddr);

      len := lwip_recvfrom(
        sock,
        @rx_buffer,
        SizeOf(rx_buffer) - 1,
        0,
        @sourceAddr,
        @socklen
      );

      if len < 0 then
      begin
        ESP_LOGE(TAG, 'recvfrom failed',[Err]);
        break;
      end
      else
      begin
        rx_buffer[len] := #0;
        ESP_LOGI(TAG, '%s %d', [rx_buffer, Err]);
      end;

      vTaskDelay(2000 div portTICK_PERIOD_MS);
    end;

    if sock <> -1 then
    begin
      ESP_LOGE(TAG, 'Shutting down socket and restarting...',[Err]);
      lwip_shutdown(sock, 0);
      lwip_close(sock);
    end;
  end;

  vTaskDelete(nil);
end;

begin

  connectWifiAP(AP_NAME, PWD);

  xTaskCreate(
    @udp_client_task,
    PChar('udp_client'),
    4096,
    nil,
    5,
    nil
  );
end.
