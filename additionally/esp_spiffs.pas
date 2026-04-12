unit esp_spiffs;

{$mode objfpc}{$H+}
{$linklib spiffs, static}
interface

uses
  ctypes,
  esp_log2,
  esp_err;


type
  esp_err_t = cint;

  Psize_t = ^size_t;
  size_t = csize_t;

  Pesp_vfs_spiffs_conf_t = ^esp_vfs_spiffs_conf_t;
  esp_vfs_spiffs_conf_t = record
    base_path: PChar;
    partition_label: PChar;
    max_files: size_t;
    format_if_mount_failed: Boolean;
  end;


//Register and mount SPIFFS to VFS
function esp_vfs_spiffs_register(conf: Pesp_vfs_spiffs_conf_t): esp_err_t; cdecl; external;

//Unregister and unmount SPIFFS
function esp_vfs_spiffs_unregister(partition_label: PChar): esp_err_t; cdecl; external;

//Check if SPIFFS is mounted
function esp_spiffs_mounted(partition_label: PChar): Boolean; cdecl; external;

//Format SPIFFS partition
function esp_spiffs_format(partition_label: PChar): esp_err_t; cdecl; external;

//Get SPIFFS info
function esp_spiffs_info(partition_label: PChar;total_bytes: Psize_t;used_bytes: Psize_t): esp_err_t; cdecl; external;

procedure RegisterSpiffs(MaxFiles:size_t;aPath, aTag : PChar);
procedure UnRegisterSpiffs(aTag :PChar);

implementation

procedure RegisterSpiffs(MaxFiles:size_t;aPath,aTag : PChar);
var
 //TAG: PChar = 'example';
 conf: esp_vfs_spiffs_conf_t;
 ret: esp_err_t;
 total, used: size_t;
 //buf: array[0..63] of char;
 //P : PChar;
 //f : PFile;

begin
 ESP_LOGI(aTAG,'%s',['Initializing SPIFFS']);

 conf.base_path              := aPath;
 conf.partition_label        := nil;
 conf.max_files              := MaxFiles;
 conf.format_if_mount_failed := True;
 total                       := 0;
 used                        := 0;

 ret := esp_vfs_spiffs_register(@conf);

 if ret <> ESP_OK then
  begin
   if ret = ESP_FAIL then
    ESP_LOGE(aTAG,'s%',['Failed to mount or format filesystem'])
   else if ret = ESP_ERR_NOT_FOUND then
    ESP_LOGE(aTAG,'s%' ,['Failed to find SPIFFS partition'])
   else
    ESP_LOGE(aTAG,'s%' ,[esp_err_to_name(ret)]);
    exit;
  end;

 ret := esp_spiffs_info(nil, @total, @used);
 if ret <> ESP_OK then
  ESP_LOGE(aTAG,'%s' ,[esp_err_to_name(ret)])
 else
  writeln('[INFO] Partition size: total=', total, ' used=', used);

end;

procedure UnRegisterSpiffs(aTag :PChar);
begin
 esp_vfs_spiffs_unregister(nil);
 ESP_LOGI(aTAG, '%s', ['SPIFFS unmounted']);
end;

end.
