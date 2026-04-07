unit WifiUdp;

{$mode ObjFPC}{$H+}

interface

uses
  task,
  portmacro,
  lwip_sockets,
  lwip_inet,
  lwip_def,
  queue, projdefs;

type
 Tesp_udp = record
  RemoteIP   : PChar;
  RemotePort : Word;
  Payload    : PChar;
  Buffer0    : PChar;
  Buffer1    : PChar;
  RecvIP     : PChar;
  err        : Integer;

 end;

type TJSONS = (J1,J2);

const
 P1  : PChar = '{"method": "getPower"}';   //liefert den momentanen Verbrauch in mW
 P2  : PChar = '{"method":"getPilot","params":{}}';   //Liefert den Schaltzustand ein/aus


var
 esp_udp        : Tesp_udp;
 QueueHandle    : TQueueHandle;
 timeout        : timeval;

procedure UDP_Send(RemoteIP : PChar; RemotePort : Word; Message : PChar);

implementation

var
 TAG  : PChar;
 JSON : TJSONS;

procedure ChangeJSON;
begin
 JSON := TJSONS((ord(JSON) + 1) mod 2);
 //writeln(ord(json));
 case ord(JSON) of
  0 : esp_udp.Payload := P1;
  1 : esp_udp.Payload := P2;
 end;
end;

procedure Send(pvParameters: Pointer);cdecl;
var
  rx_buffer : array[0..127] of char;
  addr_str  : array[0..127] of char;
  addr_family : Integer;
  ip_protocol : Integer;

  destAddr : sockaddr_in;
  sourceAddr : sockaddr_in;
  sock : Integer;

  len : Integer;
  socklen : socklen_t;
begin
  while True do
  begin
    FillChar(destAddr, SizeOf(destAddr), 0);
    FillChar(destAddr, SizeOf(sourceAddr), 0);

    timeout.tv_sec := 3;   // 3 Sekunden warten auf Antwort
    timeout.tv_usec := 0;

    destAddr.sin_addr.s_addr := inet_addr(esp_udp.RemoteIP);
    destAddr.sin_family := AF_INET;
    destAddr.sin_port := lwip_htons(esp_udp.RemotePort);

    addr_family := AF_INET;
    ip_protocol := IPPROTO_IP;

    sock := lwip_socket(addr_family, SOCK_DGRAM, ip_protocol);
    //falls keine Antwort kommt abbrechen timeout
    lwip_setsockopt(sock, SOL_SOCKET, SO_RCVTIMEO, @timeout, SizeOf(timeout));
    if sock < 0 then
    begin
      writeln(TAG,' , Unable to create socket');
      break;
    end;

    //Writeln(TAG, ' , Socked created');

    while True do
    begin
      esp_udp.err := lwip_sendto(
      sock,
      esp_udp.Payload,
      strlen(esp_udp.Payload),
      0,
      @destAddr,
      SizeOf(destAddr)
      );

      if esp_udp.err < 0 then
      begin
        writeln (TAG, ' , Error occurred during sending , Fehler: ', esp_udp.err);
        break;
      end;

      //writeln(TAG, ' , Message sent');

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
        writeln(TAG,' , recv failed');
        esp_udp.err := -1;
        break;
      end
      else
      begin
        if destAddr.sin_addr.s_addr = sourceAddr.sin_addr.s_addr then
         begin
          //writeln('Antwort erhalten');

          rx_buffer[len] := #0;
          if ord(json) = 0 then
           begin
            esp_udp.Buffer0 := rx_buffer;
            //writeln(0,rx_buffer);
           end;
          if ord(json) = 1 then
           begin
            esp_udp.Buffer1 := rx_buffer;
            //writeln(1, rx_buffer);
           end;

          inet_ntoa_r(sourceAddr.sin_addr, @addr_str, SizeOf(addr_str));
          esp_udp.RecvIP := PChar(addr_str);

          if xQueueSend(QueueHandle, @esp_udp, portMAX_DELAY) <> pdTRUE then
           begin
            writeln('Queue could not send!');
           end;
         end;
      end;
      ChangeJSON;
      vTaskDelay(5000 div portTICK_PERIOD_MS);

    end;

    if sock <> -1 then
    begin
      //writeln(TAG, ' , Shutting down socket and restarting... , Socket: ',sock);
      lwip_shutdown(sock, 0);
      lwip_close(sock);
    end;

  end;
  vTaskDelete(nil);
end;


procedure UDP_Send(RemoteIP : PChar; RemotePort : Word; Message : PChar);
begin
 esp_udp.RemoteIP   := RemoteIP;
 esp_udp.RemotePort := RemotePort;
 esp_udp.Payload    := Message;
 esp_udp.err        := -1;
 TAG  := 'UDPSend';

 QueueHandle := xQueueCreate(1, SizeOf(Tesp_udp));
 xTaskCreate(@Send, 'UDP_Send', 4096, nil, 4, nil);
end;

end.

