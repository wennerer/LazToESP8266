program NVS_Test;

uses
  fmem,
  nvs_flash,
  nvs,
  esp_err,
  laz_esp;

type
  size_t = NativeUInt;

var
  handle  : Tnvs_handle;
  value   : Int32;
  myString: PChar;
  err     : Tesp_err;
  buffer  : array[0..63] of char;
  len     : size_t;
  i       : integer = 0;

function initNVS: Tesp_err;
begin
  Result := nvs_flash_init();
  if (Result = ESP_ERR_NVS_NO_FREE_PAGES) then
  begin
    writeln('nvs_flash_erase');
    EspErrorCheck(nvs_flash_erase(), 'nvs_flash_erase');
    writeln('nvs_flash_init()');
    Result := nvs_flash_init();
  end
  else if Result <> ESP_OK then
    writeln('NVS init error: ', Result);
end;

procedure write_value_to_NVS;
begin
 //Namespace öffnen
  err := nvs_open('storage', NVS_READWRITE, @handle);
  if err <> ESP_OK then
  begin
    WriteLn('Error opening NVS');
    Exit;
  end;

  //Wert schreiben
  value := 54321;
  err := nvs_set_i32(handle, 'myvalue', value);
  if err <> ESP_OK then
  begin
    nvs_close(handle);
    Exit;
  end;

  //Änderungen speichern
  err := nvs_commit(handle);

  //Handle schließen
  nvs_close(handle);
end;

procedure write_pchar_to_NVS;
begin
  //Mein PChar
  myString := 'Hello_World';

  //NVS Namespace öffnen
  err := nvs_open('storage', NVS_READWRITE, @handle);
  if err <> ESP_OK then
  begin
    WriteLn('Error opening NVS');
    Exit;
  end;

  //PChar in NVS schreiben
  err := nvs_set_str(handle, 'mytext', myString);
  if err <> ESP_OK then
  begin
    WriteLn('Error while writing');
    nvs_close(handle);
    Exit;
  end;

  //Änderungen speichern
  nvs_commit(handle);

  //Handle schließen
  nvs_close(handle);

  WriteLn('PChar saved successfully');
end;


procedure readNVS_value;
begin
  value := 0;

  //Namespace öffnen (READONLY)
  err := nvs_open('storage', NVS_READONLY, @handle);
  if err <> ESP_OK then
  begin
    WriteLn('Error opening NVS');
    Exit;
  end;

  //Wert lesen
  err := nvs_get_i32(handle, 'myvalue', @value);
  if err <> ESP_OK then
  begin
    WriteLn('Error reading myvalue');
    nvs_close(handle);
    Exit;
  end;

  //Handle schließen
  nvs_close(handle);

  //Ausgabe
  WriteLn('Wert aus NVS: ', value);
end;

procedure readNVS_pchar;
begin
  //Namespace öffnen
  err := nvs_open('storage', NVS_READONLY, @handle);
  if err <> ESP_OK then
  begin
    WriteLn('Error opening NVS');
    Exit;
  end;

  //Wert lesen
  len := SizeOf(buffer);
  err := nvs_get_str(handle, 'mytext', @buffer[0], @len);

  //PChar ausgeben
  if err = ESP_OK then
    WriteLn('Gelesener Text: ', buffer)
  else
    WriteLn('Key not found');

  //Handle schließen
  nvs_close(handle);
end;



begin

 SerialBegin(9600);

 initNVS;
 write_value_to_NVS;
 write_pchar_to_NVS;
 sleep(1000);
 readNVS_value;
 i:=value;
 readNVS_pchar;

 repeat
  sleep(1000);
  writeln(i);
  writeln(buffer);
 until false ;
end.
