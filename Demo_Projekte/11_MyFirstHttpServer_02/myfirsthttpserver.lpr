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

procedure CreateWebpage;
begin
 writeln('CreateWebpage.....');
 content:= '<!DOCTYPE html><html>'+
           '<head>'+
            '<title>ESP8266 HTTP Server</title>'+
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
           '<form>'+
             '<h1><font color="snow">ESP8266 HTTP Server</font></h1>'+
             '<br><font color="snow">Maschine [Ein/Aus]:</font></br>'+
             '<div class="led-green"></div>'+

             //<div class="led-gray"></div>

             '<style>input{color:white}</style>'+
             '<input type="submit" name="WIZ1" value="Ein" style=''Background-color: #6b7074;'+
             'font-family:Bradley Hand ITC; font-size: 24; font-weight: bold;width: 45px;'+
             'border-radius: 6px;border-width: 1px;border-color: snow;margin-top: 5px;margin-left:15px;''>'+

             '<input type="submit" name="WIZ1" value="Aus" style=''Background-color: #6b7074;'+
             'font-family:Bradley Hand ITC; font-size: 24; font-weight: bold;width: 45px;'+
             'border-radius: 6px;border-width: 1px;border-color: snow;margin-left: 5px;''>'+

             '<input type="text" name="WIZ1.1" value="0" size="9" style=''border-color:rgb(3, 3, 125);'+
             'border-width: 2px;border-style: solid;text-align: right;margin-left: 7px;'+
             'background-color:rgb(255, 255, 255);color:black;width: 70px;'' readonly>'+

             '<label style= "margin-left: 10px;color : snow">Watt</label>'+

            '</form>'+
           '</html>';

end;

function main_get_handler(req: Phttpd_req): Tesp_err;
var
  buf: PChar;
  buf_len: uint32;

begin
  writeln('GetHandler');
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
    vPortFree(buf);
   end;

  CreateWebpage;
  httpd_resp_send(req, content, length(content));

  result := ESP_OK;
end;


function start_webserver: Thttpd_handle;
var
  server: Thttpd_handle;
  config: Thttpd_config;
  mainUriHandlerConfig: Thttpd_uri;

begin
  config := HTTPD_DEFAULT_CONFIG();

  with mainUriHandlerConfig do
  begin
    uri       := '/';
    method    := HTTP_GET;
    handler   := @main_get_handler;
    user_ctx  := nil;
  end;

  writeln('Starting server on port: ', config.server_port);
  if (httpd_start(@server, @config) = ESP_OK) then
  begin
    // Set URI handlers
    writeln('Registering URI handler');
    httpd_register_uri_handler(server, @mainUriHandlerConfig);
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

  connectWifiAP(AP_NAME, PWD);

  writeln('Starting web server...');
  start_webserver;

  repeat
    vTaskDelay(10);
  until false;
end.

