program myfirsthttpserver;
uses
  fmem,
  wificonnect2,
  esp_http_server, esp_err, http_parser,
  portable, task, laz_esp;

{$macro on}
{$inline on}

const
  AP_NAME  = //'DEINE_SSID';
  PWD      = //'DEIN_Netzwerkschlüssel';

var
 content : PChar;


// Import fpc logo in gif format as array of char
//{$include fpclogo.inc}

function hello_get_handler(req: Phttpd_req): Tesp_err;
var
  buf: PChar;
  buf_len: uint32;
begin
  buf_len := httpd_req_get_hdr_value_len(req, 'Host') + 1;
  if (buf_len > 1) then
  begin
    buf := pvPortMalloc(buf_len);
    if (httpd_req_get_hdr_value_str(req, 'Host', buf, buf_len) = ESP_OK) then
      writeln('Found header => Host: ', buf);
    vPortFree(buf);
  end;

  httpd_resp_send(req, content, length(content));

  result := ESP_OK;
end;


function start_webserver: Thttpd_handle;
var
  server: Thttpd_handle;
  config: Thttpd_config;
  helloUriHandlerConfig: Thttpd_uri;

begin
  config := HTTPD_DEFAULT_CONFIG();

  with helloUriHandlerConfig do
  begin
    uri       := '/';
    method    := HTTP_GET;
    handler   := @hello_get_handler;
    user_ctx  := nil;
  end;

  writeln('Starting server on port: ', config.server_port);
  if (httpd_start(@server, @config) = ESP_OK) then
  begin
    // Set URI handlers
    writeln('Registering URI handler');
    httpd_register_uri_handler(server, @helloUriHandlerConfig);
    result := server;
  end
  else
  begin
    result := nil;
    writeln('### Failed to start httpd');
  end;
end;

procedure CreateWebpage;
begin
 content:= '<!DOCTYPE html><html>'+
           '<head>'+
            '<title>ESP8266 HTTP Server</title>'+
            '<style>'+
             '.led-green {'+
             'margin-top: 6px;'+
             'width: 18px;'+
             'height: 18px;'+
             'background-color: greenyellow;'+
             'border-radius: 50%;'+
             'box-shadow: #000 0 -1px 7px 1px, inset #460 0 -1px 9px, #7D0 0 2px 12px;'+
             'float:left;}'+
            '</style>'+
           '</head>'+
           '<form>'+
             '<h1><font color="red">ESP8266 HTTP Server</font></h1>'+
             '<div class="led-green"></div>'+
            '</form>'+
           '</html>';

end;

begin
  SerialBegin(9600);

  connectWifiAP(AP_NAME, PWD);

  CreateWebpage;

  writeln('Starting web server...');
  start_webserver;

  repeat
    vTaskDelay(10);
  until false;
end.

