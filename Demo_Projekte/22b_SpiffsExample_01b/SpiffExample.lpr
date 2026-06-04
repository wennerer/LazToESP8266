program SpiffExample;

{$linklib spiffs, static}


uses
  fmem,
  ctypes,
  esp_err,
  esp_log2,
  laz_esp,
  esp_partition,
  spi_flash,
  esp_system,
  esp_spiffs;

var
  i : integer;


type
  PFILE = Pointer;

{$PACKRECORDS C}
type
  Pesp_vfs_spiffs_conf_t = ^esp_vfs_spiffs_conf_t;
  esp_vfs_spiffs_conf_t = record
    base_path: PChar;
    partition_label: PChar;
    max_files: cint;
    format_if_mount_failed: ByteBool;
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
  part : Pesp_partition;
  err: Tesp_err;
  m: Tflash_size_map;


begin
  ESP_LOGI(TAG,'%s',['Initializing SPIFFS']);

  conf.base_path := '/spiffs';
  conf.partition_label := nil;
  conf.max_files := 1;//5;
  conf.format_if_mount_failed := True;

//XXXXXXXXXXXXXXXX--- Ab hier einige nützliche Befehle zur Fehlersuche ---XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

//nach einer Spiffs Partition suchen, part enthält einen Zeiger auf die Partitionsbeschreibung
  part := esp_partition_find_first(
          ESP_PARTITION_TYPE_DATA,
          ESP_PARTITION_SUBTYPE_DATA_SPIFFS,
          nil);
//Ausgeben der Beschreibung
  writeln('type=', Ord(part^._type));
  writeln('subtype=', Ord(part^.subtype));
  writeln('address=', part^.address);
  writeln('size=', part^.size);
//Vergleicht die Parameter mit der aktuellen Partitionstabelle
  if esp_partition_verify(part) = nil then
   writeln('verify=nil')
  else
   writeln('verify=ok');
//zeigt an ob eine Spiffspartition gefunden wurde
  if part = nil then
   begin
    writeln('SPIFFS Partition NICHT gefunden');
   end
  else
   begin
    writeln('SPIFFS gefunden');
    writeln('Address=', part^.address);
    writeln('Size=', part^.size);
   end;
//versucht einen Bereich innerhalb einer Spiffspartition zu löschen
  err := esp_partition_erase_range(part, 0, $1000);
  writeln('erase=', esp_err_to_name(err));
//liest in der Spiffspartition, wenn Err = ESP_ok dann okay
 Err :=esp_partition_read(part,$3E8, @Buf, 4);
 WriteLn('esp_partition_read bei 3E8=',esp_err_to_name(err));
 Err :=esp_partition_read(part,$C350, @Buf, 4);
 WriteLn('esp_partition_read bei C350=',esp_err_to_name(err));
 Err :=esp_partition_read(part,$15F90, @Buf, 4);
 WriteLn('esp_partition_read bei $15F90=',esp_err_to_name(err));
//liest außerhalb
 Err :=esp_partition_read(part,$150000, @Buf, 4);
 WriteLn('esp_partition_read bei $150000=',esp_err_to_name(err));

//liest direkt aus dem Flash-Chip, wenn Err = ESP_ok dann okay
  Err := spi_flash_read($1FF000, @Buf, 4);
  WriteLn('1FF000=', esp_err_to_name(err));
  Err := spi_flash_read($200000, @Buf, 4);
  WriteLn('200000=', esp_err_to_name(err));
  Err := spi_flash_read($2FF000, @Buf, 4);
  WriteLn('2FF000=', esp_err_to_name(err));
  Err := spi_flash_read($300000, @Buf, 4);
  WriteLn('300000=', esp_err_to_name(err));

//liefert Flash-Größen-/Layoutschema
  m := system_get_flash_size_map;
  WriteLn('Map Ord = ', Ord(m));
  case m of
    FLASH_SIZE_4M_MAP_256_256:
      WriteLn('4 Mbit (512 KB)');
    FLASH_SIZE_2M:
      WriteLn('2 Mbit (256 KB)');
    FLASH_SIZE_8M_MAP_512_512:
      WriteLn('8 Mbit (1 MB)');
    FLASH_SIZE_16M_MAP_512_512:
      WriteLn('16 Mbit (2 MB)');
    FLASH_SIZE_32M_MAP_512_512:
      WriteLn('32 Mbit (4 MB)');
    FLASH_SIZE_16M_MAP_1024_1024:
      WriteLn('16 Mbit (2 MB)');
    FLASH_SIZE_32M_MAP_1024_1024:
      WriteLn('32 Mbit (4 MB)');
    FLASH_SIZE_32M_MAP_2048_2048:
      WriteLn('32 Mbit (4 MB)');
    FLASH_SIZE_64M_MAP_1024_1024:
      WriteLn('64 Mbit (8 MB)');
    FLASH_SIZE_128M_MAP_1024_1024:
      WriteLn('128 Mbit (16 MB)');
  end;

//liefert Flashgröße des Chip in Bytes
  writeln('Flash size=', spi_flash_get_chip_size);

//liefert die Größe des Datentyps Tesp_partition in Bytes
  writeln('sizeof Tesp_partition=', SizeOf(Tesp_partition));



  //XXXXXXXXXXXXXXXX--- Ende ---XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

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

 sleep(1000);

 app_main;

 repeat
  sleep(1000);
  writeln('Bin in der Loop angelangt');
 until false ;

end.
