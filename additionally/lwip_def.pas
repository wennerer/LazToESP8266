unit lwip_def;

{$mode objfpc}
{$H+}
{$inline on}

interface

uses
  SysUtils,
  lwip_arch;

{ -----------------------------------------------------------------------------
  Performance (LWIP_PERF)
  ----------------------------------------------------------------------------- }

{$ifdef LWIP_PERF}
  procedure PERF_START;
  procedure PERF_STOP(const Name: string);
{$else}
  procedure PERF_START; inline;
  procedure PERF_STOP(const Name: string); inline;
{$endif}

{ -----------------------------------------------------------------------------
  Max / Min
  ----------------------------------------------------------------------------- }

function LWIP_MAX(x, y: PtrUInt): PtrUInt; inline;
function LWIP_MIN(x, y: PtrUInt): PtrUInt; inline;

{ -----------------------------------------------------------------------------
  Array Size (nur für statische Arrays!)
  ----------------------------------------------------------------------------- }

generic function LWIP_ARRAYSIZE<T>(constref Arr: array of T): SizeUInt; inline;

{ -----------------------------------------------------------------------------
  U32 aus Bytes erzeugen
  ----------------------------------------------------------------------------- }

function LWIP_MAKEU32(a, b, c, d: u8_t): u32_t; inline;

{ -----------------------------------------------------------------------------
  Byte Order
  ----------------------------------------------------------------------------- }

function lwip_htons(x: u16_t): u16_t; inline;
function lwip_ntohs(x: u16_t): u16_t; inline;
function lwip_htonl(x: u32_t): u32_t; inline;
function lwip_ntohl(x: u32_t): u32_t; inline;

{ Compile-Time Varianten (für Konstanten) }

function PP_HTONS(x: u16_t): u16_t; inline;
function PP_NTOHS(x: u16_t): u16_t; inline;
function PP_HTONL(x: u32_t): u32_t; inline;
function PP_NTOHL(x: u32_t): u32_t; inline;

{ -----------------------------------------------------------------------------
  String Utilities
  ----------------------------------------------------------------------------- }

procedure lwip_itoa(var resultStr: string; number: Integer);
function lwip_strnicmp(const str1, str2: PChar; len: SizeUInt): Integer;
function lwip_stricmp(const str1, str2: PChar): Integer;
function lwip_strnstr(const buffer, token: PChar; n: SizeUInt): PChar;

implementation

{ -----------------------------------------------------------------------------
  PERF
  ----------------------------------------------------------------------------- }

{$ifdef LWIP_PERF}
procedure PERF_START;
begin
  // hier kannst du z.B. Zeitstempel speichern
end;

procedure PERF_STOP(const Name: string);
begin
  // hier Differenz berechnen
end;
{$else}
procedure PERF_START; inline;
begin
end;

procedure PERF_STOP(const Name: string); inline;
begin
end;
{$endif}

{ -----------------------------------------------------------------------------
  Max / Min
  ----------------------------------------------------------------------------- }

function LWIP_MAX(x, y: PtrUInt): PtrUInt; inline;
begin
  if x > y then Result := x else Result := y;
end;

function LWIP_MIN(x, y: PtrUInt): PtrUInt; inline;
begin
  if x < y then Result := x else Result := y;
end;

{ -----------------------------------------------------------------------------
  Array Size
  ----------------------------------------------------------------------------- }

generic function LWIP_ARRAYSIZE<T>(constref Arr: array of T): SizeUInt; inline;
begin
  Result := Length(Arr);
end;

{ -----------------------------------------------------------------------------
  MAKEU32
  ----------------------------------------------------------------------------- }

function LWIP_MAKEU32(a, b, c, d: u8_t): u32_t; inline;
begin
  Result :=
    (u32_t(a) shl 24) or
    (u32_t(b) shl 16) or
    (u32_t(c) shl 8)  or
     u32_t(d);
end;

{ -----------------------------------------------------------------------------
  Byteorder
  ----------------------------------------------------------------------------- }

{$if BYTE_ORDER = BIG_ENDIAN}

function lwip_htons(x: u16_t): u16_t; inline; begin Result := x; end;
function lwip_ntohs(x: u16_t): u16_t; inline; begin Result := x; end;
function lwip_htonl(x: u32_t): u32_t; inline; begin Result := x; end;
function lwip_ntohl(x: u32_t): u32_t; inline; begin Result := x; end;

function PP_HTONS(x: u16_t): u16_t; inline; begin Result := x; end;
function PP_NTOHS(x: u16_t): u16_t; inline; begin Result := x; end;
function PP_HTONL(x: u32_t): u32_t; inline; begin Result := x; end;
function PP_NTOHL(x: u32_t): u32_t; inline; begin Result := x; end;

{$else}

function lwip_htons(x: u16_t): u16_t; inline;
begin
  Result := ((x and $00FF) shl 8) or
            ((x and $FF00) shr 8);
end;

function lwip_ntohs(x: u16_t): u16_t; inline;
begin
  Result := lwip_htons(x);
end;

function lwip_htonl(x: u32_t): u32_t; inline;
begin
  Result :=
    ((x and $000000FF) shl 24) or
    ((x and $0000FF00) shl 8)  or
    ((x and $00FF0000) shr 8)  or
    ((x and $FF000000) shr 24);
end;

function lwip_ntohl(x: u32_t): u32_t; inline;
begin
  Result := lwip_htonl(x);
end;

function PP_HTONS(x: u16_t): u16_t; inline;
begin
  Result := lwip_htons(x);
end;

function PP_NTOHS(x: u16_t): u16_t; inline;
begin
  Result := lwip_htons(x);
end;

function PP_HTONL(x: u32_t): u32_t; inline;
begin
  Result := lwip_htonl(x);
end;

function PP_NTOHL(x: u32_t): u32_t; inline;
begin
  Result := lwip_htonl(x);
end;

{$endif}

{ -----------------------------------------------------------------------------
  String Utilities
  ----------------------------------------------------------------------------- }

procedure lwip_itoa(var resultStr: string; number: Integer);
begin
  resultStr := IntToStr(number);
end;

function lwip_strnicmp(const str1, str2: PChar; len: SizeUInt): Integer;
begin
  Result := StrLIComp(str1, str2, len);
end;

function lwip_stricmp(const str1, str2: PChar): Integer;
begin
  Result := StrIComp(str1, str2);
end;

function lwip_strnstr(const buffer, token: PChar; n: SizeUInt): PChar;
var
  i: SizeUInt;
  tokenLen: SizeUInt;
begin
  Result := nil;
  tokenLen := StrLen(token);

  if tokenLen = 0 then Exit(buffer);

  for i := 0 to n - tokenLen do
    if StrLComp(buffer + i, token, tokenLen) = 0 then
      Exit(buffer + i);
end;

end.
