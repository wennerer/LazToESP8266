unit esp_fileIO;

interface

uses
 ctypes,
 esp_log2,
 laz_esp;

type
  PFILE = Pointer;

function fopen(filename, mode: PChar): PFILE; cdecl; external;
function fclose(f: PFILE): cint; cdecl; external;
function fprintf(f: PFILE; fmt: PChar): cint; cdecl; varargs; external;
function fgets(buf: PChar; size: cint; f: PFILE): PChar; cdecl; external;
function remove(path: PChar): cint; cdecl; external;
function unlink(path: PChar): cint; cdecl; external;

function FileExists(const aPath: PChar): boolean;
function FileWrite (const aPath,aText : PChar):boolean;
function FileAppend (const aPath,aText : PChar):boolean;
procedure FileRead (const aPath : PChar);
function FileReadLine(const aPath: PChar; out line: PChar): boolean;
function FileDelete(const aPath : PChar):boolean;


implementation

function FileExists(const aPath: PChar): boolean;
var
  f: PFILE;
begin
  f := fopen(aPath, 'r');
  if f <> nil then
  begin
    fclose(f);
    exit(True);
  end;
  Result := False;
end;

function FileWrite (const aPath,aText : PChar):boolean;
var
  f: PFILE;
begin
 f := fopen(aPath, 'w');
  if f = nil then
  begin
    ESP_LOGE('FileWrite','%s',[ 'fopen write failed']);
    exit(false);
  end;
 fprintf(f,'%s%s',aText,PChar(LineEnding));
 fclose(f);
 Result := True;
end;

function FileAppend (const aPath,aText : PChar):boolean;
var
  f: PFILE;
begin
 f := fopen(aPath, 'a');
  if f = nil then
  begin
    ESP_LOGE('FileAppend','%s',[ 'fopen write failed']);
    exit(false);
  end;
 fprintf(f, '%s%s', aText, PChar(LineEnding));


 fclose(f);
 Result := True;
end;

procedure FileRead (const aPath : PChar);
var
 f: PFILE;
 buf: array[0..255] of Char;
begin
  f := fopen(aPath, 'r');
  if f <> nil then
  begin
    while fgets(@buf[0], SizeOf(buf), f) <> nil do
     write (PChar(@buf[0]));
    fclose(f);
  end;
end;

function FileReadLine(const aPath: PChar; out line: PChar): boolean;
var
  f: PFILE;
  buffer: array[0..127] of char;
begin
  Result := False;
  line := '';

  f := fopen(aPath, 'r');
  if f = nil then exit;

  if fgets(@buffer[0], SizeOf(buffer), f) <> nil then
  begin
    line := PChar(@buffer[0]);
    Result := True;
  end;

  fclose(f);
end;

function FileDelete(const aPath : PChar):boolean;
var
  res: Integer;
  f    : PFILE;
begin
  if not FileExists(aPath) then
   exit(false);

  f := fopen(aPath, 'r');
  if f <> nil then
   fclose(f);

  res := remove(aPath);

  if res < 0 then
   exit(false)
  else
   Result := true;
end;


end.

