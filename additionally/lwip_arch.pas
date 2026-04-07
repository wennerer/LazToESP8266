unit lwip_arch;

{$mode objfpc}
{$H+}
{$PACKRECORDS C}   // C-kompatible Record-Ausrichtung

interface

uses
  {$ifdef FPC_HAS_SYSUTILS}
  SysUtils,
  {$endif}
  ctypes;

{ ---------------------------------------------------------------------------
  Endian
  --------------------------------------------------------------------------- }

const
  LITTLE_ENDIAN = 1234;
  BIG_ENDIAN    = 4321;

{$if defined(FPC_LITTLE_ENDIAN)}
  BYTE_ORDER = LITTLE_ENDIAN;
{$elseif defined(FPC_BIG_ENDIAN)}
  BYTE_ORDER = BIG_ENDIAN;
{$else}
  BYTE_ORDER = LITTLE_ENDIAN; // Fallback
{$endif}

{ ---------------------------------------------------------------------------
  Basis-Typen (stdint Ersatz)
  --------------------------------------------------------------------------- }

type
  u8_t  = UInt8;
  s8_t  = Int8;
  u16_t = UInt16;
  s16_t = Int16;
  u32_t = UInt32;
  s32_t = Int32;
  u64_t = UInt64;
  s64_t = Int64;

  mem_ptr_t = PtrUInt;
  ssize_t   = PtrInt;

const
  LWIP_UINT32_MAX = $FFFFFFFF;

{ ---------------------------------------------------------------------------
  Diagnose / Assertion
  --------------------------------------------------------------------------- }

procedure LWIP_PLATFORM_DIAG(const Msg: string); inline;
procedure LWIP_PLATFORM_ASSERT(const Msg: string); inline;

{ ---------------------------------------------------------------------------
  CTYPE Ersatz (leichtgewichtige Implementierung)
  --------------------------------------------------------------------------- }

function lwip_isdigit(c: Char): Boolean; inline;
function lwip_isxdigit(c: Char): Boolean; inline;
function lwip_islower(c: Char): Boolean; inline;
function lwip_isupper(c: Char): Boolean; inline;
function lwip_isspace(c: Char): Boolean; inline;
function lwip_tolower(c: Char): Char; inline;
function lwip_toupper(c: Char): Char; inline;

{ ---------------------------------------------------------------------------
  Alignment
  --------------------------------------------------------------------------- }

const
  MEM_ALIGNMENT = SizeOf(PtrUInt);

function LWIP_MEM_ALIGN_SIZE(size: PtrUInt): PtrUInt; inline;
function LWIP_MEM_ALIGN_BUFFER(size: PtrUInt): PtrUInt; inline;
function LWIP_MEM_ALIGN(addr: Pointer): Pointer; inline;

{ ---------------------------------------------------------------------------
  Packed Struct Support (FPC)
  --------------------------------------------------------------------------- }

type
  PACK_STRUCT_STRUCT = packed record end;

{ ---------------------------------------------------------------------------
  Utility
  --------------------------------------------------------------------------- }

procedure LWIP_UNUSED_ARG(x: Pointer); inline;

implementation

procedure LWIP_PLATFORM_DIAG(const Msg: string); inline;
begin
  WriteLn(Msg);
end;

procedure LWIP_PLATFORM_ASSERT(const Msg: string); inline;
begin
  {$ifdef FPC_HAS_SYSUTILS}
  raise Exception.CreateFmt('Assertion failed: %s', [Msg]);
  {$else}
  Halt(1);
  {$endif}
end;

function lwip_isdigit(c: Char): Boolean; inline;
begin
  Result := (c >= '0') and (c <= '9');
end;

function lwip_isxdigit(c: Char): Boolean; inline;
begin
  Result := lwip_isdigit(c) or
            ((c >= 'a') and (c <= 'f')) or
            ((c >= 'A') and (c <= 'F'));
end;

function lwip_islower(c: Char): Boolean; inline;
begin
  Result := (c >= 'a') and (c <= 'z');
end;

function lwip_isupper(c: Char): Boolean; inline;
begin
  Result := (c >= 'A') and (c <= 'Z');
end;

function lwip_isspace(c: Char): Boolean; inline;
begin
  Result := c in [' ', #9, #10, #13, #11, #12];
end;

function lwip_tolower(c: Char): Char; inline;
begin
  if lwip_isupper(c) then
    Result := Chr(Ord(c) - Ord('A') + Ord('a'))
  else
    Result := c;
end;

function lwip_toupper(c: Char): Char; inline;
begin
  if lwip_islower(c) then
    Result := Chr(Ord(c) - Ord('a') + Ord('A'))
  else
    Result := c;
end;

function LWIP_MEM_ALIGN_SIZE(size: PtrUInt): PtrUInt; inline;
begin
  Result := (size + MEM_ALIGNMENT - 1) and not (MEM_ALIGNMENT - 1);
end;

function LWIP_MEM_ALIGN_BUFFER(size: PtrUInt): PtrUInt; inline;
begin
  Result := size + MEM_ALIGNMENT - 1;
end;

function LWIP_MEM_ALIGN(addr: Pointer): Pointer; inline;
begin
  Result := Pointer(
    (PtrUInt(addr) + MEM_ALIGNMENT - 1) and
    not (MEM_ALIGNMENT - 1)
  );
end;

procedure LWIP_UNUSED_ARG(x: Pointer); inline;
begin
end;

end.
