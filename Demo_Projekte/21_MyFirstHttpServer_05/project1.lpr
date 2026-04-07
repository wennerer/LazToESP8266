program project1;

uses
  fmem,
  laz_esp,
  wificonnect2,
  portmacro,
  timers,
  projdefs,
  wifiudp,
  queue,
  esp_http_server,
  esp_err,
  portable,
  http_parser,
  semphr;

{$Include PWD.inc}

const
  Remote_IP_ADDR = '192.168.178.102'; // anpassen, das ist die IP des Gerätes an das gesendet wird (defekt 92,Heizung 93)
  PORT = 38899;   //Dieser Port muss für die WIZ Geräte verwendet werden!

  Payload_on   : PChar = '{"method":"setState","params":{"state":true}}';  //schaltet ein
  Payload_off  : PChar = '{"method":"setState","params":{"state":false}}'; //schaltet aus


var
  Timer1Handle : TTimerHandle;
  Chunk1       : PChar;
  Chunk2       : PChar;
  Chunk3       : PChar;
  Chunk4       : PChar;
  Chunk5       : PChar;
  ChunkMutex   : TSemaphoreHandle;
  WIZ1         : boolean;


function ExtractPower(json: PChar; out value: Integer): Boolean;
var
 pStart, pEnd : Integer;
 Watt,i       : Integer;
 valueStr     : shortstring;
begin
 Result := False;
 value := 0;

 pStart := Pos('"power":', json);
 if pStart > 0 then
  begin
   pStart := pStart + Length('"power":');

   // Ende der Zahl finden
   pEnd := pStart;
   while (pEnd <= Length(json)) and (json[pEnd] in ['0'..'9']) do
    Inc(pEnd);

   valueStr := Copy(json, pStart, pEnd - pStart+1);
   val(valueStr,Watt,i);
  end
 else
 begin
  WriteLn('Power nicht gefunden');
  exit;
 end;

 //von milliWatt nach Watt
  Value := round(Watt / 1000);
  Result := True;
end;

procedure TimerCallback(xTimerHandle: TTimerHandle);
var Received_udp : Tesp_udp;
    i, Watt      : integer;
    s            : shortstring;

begin

 if xQueueReceive(QueueHandle, @Received_Udp, 0) = pdTRUE then
  begin
    i := Pos('getPower',Received_Udp.Buffer0);
    if i <> 0 then
     begin
      ExtractPower(Received_Udp.Buffer0,Watt);
      s := inttostr(Watt);
      if xSemaphoreTake(ChunkMutex, portMAX_DELAY) = pdTRUE then
       begin
        StrToPChar(s,Chunk4);
        xSemaphoreGive(ChunkMutex);
       end;
      end;
    i := Pos('getPilot',Received_Udp.Buffer1);
    if i <> 0 then
     begin
      i := Pos('true',Received_Udp.Buffer1);
      if i <> 0 then WIZ1 := true
      else WIZ1 := false;
     end;
  end;
end;

procedure Start_Timer(out xTimerHandle: TTimerHandle;Interval:LongInt);
begin
xTimerHandle := xTimerCreate('Timer1', // Name des Timers
                             pdMS_TO_TICKS(Interval),// Periode in Ticks
                             pdTRUE,          // pdTRUE = wiederholend, pdFALSE = einmalig
                             nil,             // Timer-ID optional
                             @TimerCallback);//Callback-Funktion

if xTimerHandle = nil then
 begin
  writeln('The timer could not be created');
  Exit;
 end;

// Timer starten
if xTimerStart(xTimerHandle,5000) <> pdPASS then   //Timer startet um 5000 versetzt!
 writeln('The timer could not be started');
end;

procedure CreateWebpage;
begin
 Chunk1:= '<!DOCTYPE html><html>'+
           '<head>'+
            '<title>ESP8266 HTTP Server</title>'+
            '<meta http-equiv="refresh" content=20>'+   //Webseite aktualisiert sich alle 20 Sekunden
            '<style>'+
             'body {font-family: sans-serif;background-color:#302c2c}'+
             '.led-green {'+
             'margin-top: 6px;'+
             'width: 18px;'+
             'height: 18px;'+
             'background-color: greenyellow;'+
             'border-radius: 50%;'+
             'box-shadow: #000 0 -1px 7px 1px, inset #460 0 -1px 9px, #7D0 0 2px 12px;'+
             'float:left;}'+
             '.led-gray {'+
             'margin-top: 6px;'+
             'width: 18px;'+
             'height: 18px;'+
             'background-color: #C0C0C0;'+
             'border-radius: 50%;'+
             'box-shadow: #000 0 -1px 7px 1px, inset #9A9 0 -1px 9px, #969 0 2px 14px;'+
             'float:left;}'+
            '</style>'+
           '</head>'+
             '<form method="GET" action="/pushed">'+
             '<h1><font color="snow">ESP8266 HTTP Server</font></h1>'+
             '<br><font color="snow">Maschine [Ein/Aus]:</font></br>';

  if WIZ1 then Chunk2 := '<div class="led-green"></div>';

  if not WIZ1 then Chunk2 := '<div class="led-gray"></div>';

  Chunk3 :=  '<style>input{color:white}</style>'+
             '<input type="submit" name="action" value="Ein" style=''Background-color: #6b7074;'+
             'font-family:Bradley Hand ITC; font-size: 24; font-weight: bold;width: 45px;'+
             'border-radius: 6px;border-width: 1px;border-color: snow;margin-top: 5px;margin-left:15px;''>'+

             '<input type="submit" name="action" value="Aus" style=''Background-color: #6b7074;'+
             'font-family:Bradley Hand ITC; font-size: 24; font-weight: bold;width: 45px;'+
             'border-radius: 6px;border-width: 1px;border-color: snow;margin-left: 5px;''>'+

             '<input type="text" name="WIZ1.1" value="';

 //Chunk4 :=   wird in der TimerCallback gesetzt

 Chunk5 :=   '" size="9" style=''border-color:rgb(3, 3, 125);'+
             'border-width: 2px;border-style: solid;text-align: right;margin-left: 7px;'+
             'background-color:rgb(255, 255, 255);color:black;width: 70px;'' readonly>'+

             '<label style= "margin-left: 10px;color : snow">Watt</label>'+

            '</form>'+
           '</html>';
end;

function main_get_handler(req: Phttpd_req): Tesp_err;

begin
 Result := ESP_FAIL;
 //writeln('Main_GetHandler');
 CreateWebpage;
 if xSemaphoreTake(ChunkMutex, portMAX_DELAY) = pdTRUE then
 begin
  httpd_resp_send_chunk(req, Chunk1, length(Chunk1));
  httpd_resp_send_chunk(req, Chunk2, length(Chunk2));
  httpd_resp_send_chunk(req, Chunk3, length(Chunk3));
  httpd_resp_send_chunk(req, Chunk4, length(Chunk4));
  httpd_resp_send_chunk(req, Chunk5, length(Chunk5));
  // Signal finish of chunks
  httpd_resp_send_chunk(req, nil, 0);
  result := ESP_OK;
  xSemaphoreGive(ChunkMutex);
 end;
end;


function WIZ_get_handler(req: Phttpd_req): Tesp_err;
var
  buf: PChar;
  buf_len: uint32;
  i : integer;
begin
 Result := ESP_FAIL;
 //writeln('Form Handler');
 buf_len := httpd_req_get_hdr_value_len(req, 'Host') + 1;
 if (buf_len > 1) then
 begin
  buf := pvPortMalloc(buf_len);
  if (httpd_req_get_hdr_value_str(req, 'Host', buf, buf_len) = ESP_OK) then
   writeln('Found header => Host: ', buf);
  vPortFree(buf);
 end;

 buf_len := httpd_req_get_url_query_len(req) +1;
  if buf_len > 1 then
  begin
   buf := pvPortMalloc(buf_len);
   if httpd_req_get_url_query_str(req, buf,buf_len) = ESP_OK then
   writeln('Query: ', buf);

   i := Pos('Ein',buf);
   if i <> 0 then
   begin
    Wiz1 := true;
    esp_udp.Payload := Payload_on;
    //writeln('WIZ1 ist ein');
   end;
   i := Pos('Aus',buf);
   if i <> 0 then
   begin
    Wiz1 := false;
    esp_udp.Payload := Payload_off;
    //writeln('WIZ1 ist aus');
   end;

   vPortFree(buf);
  end;

 // Signal finish of chunks
 httpd_resp_set_status(req, '303 See Other');  //setzt auf neue URL
 httpd_resp_set_hdr(req, 'Location', '/');     //neue URL
 httpd_resp_send_chunk(req, nil, 0);
 result := ESP_OK;
end;

function start_webserver: Thttpd_handle;
var
  server: Thttpd_handle;
  config: Thttpd_config;
  mainUriHandlerConfig: Thttpd_uri;
  WIZUriHandlerConfig: Thttpd_uri;

begin
  config := HTTPD_DEFAULT_CONFIG();

  with mainUriHandlerConfig do
  begin
    uri       := '/';
    method    := HTTP_GET;
    handler   := @main_get_handler;
    user_ctx  := nil;
  end;

  with WIZUriHandlerConfig do
  begin
    uri       := '/pushed';
    method    := HTTP_GET;
    handler   := @WIZ_get_handler;
    user_ctx  := nil;
  end;

  writeln('Starting server on port: ', config.server_port);
  if (httpd_start(@server, @config) = ESP_OK) then
  begin
    // Set URI handlers
    writeln('Registering URI handler');
    httpd_register_uri_handler(server, @mainUriHandlerConfig);
    httpd_register_uri_handler(server, @WIZUriHandlerConfig);
    result := server;
  end
  else
  begin
    result := nil;
    writeln('### Failed to start httpd');
  end;
end;



begin

 SerialBegin(9600);

 ChunkMutex := xSemaphoreCreateMutex();
 Chunk4 := '0';

 connectWifiAP(AP_NAME,PWD);
 repeat
  writeln('Start Wifi ...');
 until stationConnected = true;

 UDP_Send(Remote_IP_ADDR,Port,P1);

 Start_Timer(Timer1Handle,1000);

 writeln('Starting web server...');
 start_webserver;
 repeat
  sleep(100);
 until false ;
end.
