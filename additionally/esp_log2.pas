unit esp_log2;

{$mode objfpc}{$H+}

interface

uses
  ctypes, sysutils;

type
  esp_log_level_t = (
    ESP_LOG_NONE = 0,
    ESP_LOG_ERROR,
    ESP_LOG_WARN,
    ESP_LOG_INFO,
    ESP_LOG_DEBUG,
    ESP_LOG_VERBOSE,
    ESP_LOG_MAX
  );

type
  putchar_like_t = function(ch: cint): cint; cdecl;

procedure esp_log_level_set(tag: PChar; level: esp_log_level_t); cdecl; external;

function esp_log_set_putchar(func: putchar_like_t): putchar_like_t; cdecl; external;

function esp_log_timestamp: uint32; cdecl; external;
function esp_log_early_timestamp: uint32; cdecl; external;

procedure esp_log_write(level: esp_log_level_t; tag, fmt: PChar); cdecl; varargs; external;
procedure esp_early_log_write(level: esp_log_level_t; tag, fmt: PChar); cdecl; varargs; external;

{ Logging helpers }

procedure ESP_LOGE(tag, fmt: PChar; const args: array of const);
procedure ESP_LOGW(tag, fmt: PChar; const args: array of const);
procedure ESP_LOGI(tag, fmt: PChar; const args: array of const);
procedure ESP_LOGD(tag, fmt: PChar; const args: array of const);
procedure ESP_LOGV(tag, fmt: PChar; const args: array of const);

procedure ESP_EARLY_LOGE(tag, fmt: PChar; const args: array of const);
procedure ESP_EARLY_LOGW(tag, fmt: PChar; const args: array of const);
procedure ESP_EARLY_LOGI(tag, fmt: PChar; const args: array of const);
procedure ESP_EARLY_LOGD(tag, fmt: PChar; const args: array of const);
procedure ESP_EARLY_LOGV(tag, fmt: PChar; const args: array of const);

implementation

procedure log_internal(level: esp_log_level_t; tag, fmt: PChar; const args: array of const);
var
  s: string;
begin
  s := Format(fmt, args);
  esp_log_write(level, tag, PChar(s));
end;

procedure ESP_LOGE(tag, fmt: PChar; const args: array of const);
begin
  log_internal(ESP_LOG_ERROR, tag, fmt, args);
end;

procedure ESP_LOGW(tag, fmt: PChar; const args: array of const);
begin
  log_internal(ESP_LOG_WARN, tag, fmt, args);
end;

procedure ESP_LOGI(tag, fmt: PChar; const args: array of const);
begin
  log_internal(ESP_LOG_INFO, tag, fmt, args);
end;

procedure ESP_LOGD(tag, fmt: PChar; const args: array of const);
begin
  log_internal(ESP_LOG_DEBUG, tag, fmt, args);
end;

procedure ESP_LOGV(tag, fmt: PChar; const args: array of const);
begin
  log_internal(ESP_LOG_VERBOSE, tag, fmt, args);
end;

procedure ESP_EARLY_LOGE(tag, fmt: PChar; const args: array of const);
var s: string;
begin
  s := Format(fmt, args);
  esp_early_log_write(ESP_LOG_ERROR, tag, PChar(s));
end;

procedure ESP_EARLY_LOGW(tag, fmt: PChar; const args: array of const);
var s: string;
begin
  s := Format(fmt, args);
  esp_early_log_write(ESP_LOG_WARN, tag, PChar(s));
end;

procedure ESP_EARLY_LOGI(tag, fmt: PChar; const args: array of const);
var s: string;
begin
  s := Format(fmt, args);
  esp_early_log_write(ESP_LOG_INFO, tag, PChar(s));
end;

procedure ESP_EARLY_LOGD(tag, fmt: PChar; const args: array of const);
var s: string;
begin
  s := Format(fmt, args);
  esp_early_log_write(ESP_LOG_DEBUG, tag, PChar(s));
end;

procedure ESP_EARLY_LOGV(tag, fmt: PChar; const args: array of const);
var s: string;
begin
  s := Format(fmt, args);
  esp_early_log_write(ESP_LOG_VERBOSE, tag, PChar(s));
end;

end.
