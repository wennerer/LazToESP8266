unit esp_spiffs;

{$mode objfpc}{$H+}
{$linklib spiffs, static}
interface

uses
  ctypes;

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

implementation

end.
