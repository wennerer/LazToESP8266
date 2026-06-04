program SpiffExample;

{$linklib spiffs, static}

uses
  fmem,
  ctypes,
  esp_err,
  esp_log2,
  laz_esp,
  esp_spiffs;

var
  i : integer;


type
  PFILE = Pointer;

type
  Pesp_vfs_spiffs_conf_t = ^esp_vfs_spiffs_conf_t;
  esp_vfs_spiffs_conf_t = record
    base_path: PChar;
    partition_label: PChar;
    max_files: cint;
    format_if_mount_failed: boolean;
  end;

function fopen(filename, mode: PChar): PFILE; cdecl; external;
function fclose(f: PFILE): cint; cdecl; external;
function fprintf(f: PFILE; fmt: PChar): cint; cdecl; varargs; external;
function fgets(buf: PChar; size: cint; f: PFILE): PChar; cdecl; external;


procedure app_main;
var
  TAG: PChar = 'example';
  conf: esp_vfs_spiffs_conf_t;
  ret: esp_err_t;
  total, used: size_t;
  buf: array[0..63] of char;
  P : PChar;
  f : PFile;
begin
  ESP_LOGI(TAG,'%s',['Initializing SPIFFS']);

  conf.base_path := '/spiffs';
  conf.partition_label := nil;
  conf.max_files := 1;//5;
  conf.format_if_mount_failed := True;

  ret := esp_vfs_spiffs_register(@conf);

  if ret <> ESP_OK then
  begin
    if ret = ESP_FAIL then
      ESP_LOGE(TAG,'s%',['Failed to mount or format filesystem'])
    else if ret = ESP_ERR_NOT_FOUND then
      ESP_LOGE(TAG,'s%' ,['Failed to find SPIFFS partition'])
    else
      ESP_LOGE(TAG,'s%' ,[esp_err_to_name(ret)]);
    exit;
  end;

  total := 0;
  used := 0;

  ret := esp_spiffs_info(nil, @total, @used);
  if ret <> ESP_OK then
    ESP_LOGE(TAG,'%s' ,[esp_err_to_name(ret)])
  else
    writeln('[INFO] Partition size: total=', total, ' used=', used);


 { Datei schreiben }
  f := fopen('/spiffs/test.txt', 'w');
  if f = nil then
  begin
    ESP_LOGE(TAG,'%s',[ 'fopen write fehlgeschlagen']);
    exit;
  end;

  fprintf(f, 'Hallo Freunde von FreePascal',#10);
  fclose(f);

  { Datei lesen }
  f := fopen('/spiffs/test.txt', 'r');
  if f = nil then
  begin
    ESP_LOGE(TAG,'%s', ['fopen read fehlgeschlagen']);
    exit;
  end;

  if fgets(@buf[0], sizeof(buf), f) <> nil then
   begin
    P := @buf[0];
    ESP_LOGI(TAG, 'Gelesen: %s', [P]);
   end;
  fclose(f);

  esp_vfs_spiffs_unregister(nil);
  ESP_LOGI(TAG, '%s', ['SPIFFS unmounted']);
end;

begin
 SerialBegin(9600);
 //serielle Ausgabe etwas verzögern
 i := 100;
 repeat
  dec(i);
  writeln(i);
 until i = 0 ;



 app_main;

 repeat
  sleep(1000);
  writeln('Bin in der Loop angelangt');
 until false ;

end.
