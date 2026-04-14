unit Laz_ESP;

interface

uses
  task,
  portmacro,
  uart,
  esp_err,
  lwip_ip4_addr,
  lwip_ip_addr,
  lwip_def,
  lwip_udp,
  lwip_err,
  esp_log2,
  ctypes;

type
  TChrArray = array[0..10] of char;
type
  TString11  = string[11];

const
 UART_PORT: Tuart_port = UART_NUM_0;

const
  { Flags for getrandom }
  GRND_NONBLOCK = $0001;  { Do not block if entropy pool not initialized }
  GRND_RANDOM   = $0002;  { Use /dev/random instead of /dev/urandom }

var
 uart_cfg: Tuart_config;

 {
   Get random bytes from the kernel's random number generator

   Parameters:
     buf     - pointer to buffer to fill with random bytes
     buflen  - number of bytes to generate
     flags   - control flags (GRND_NONBLOCK, GRND_RANDOM)

   Returns:
     On success: number of bytes written to buf
     On error: -1 (and errno is set)
 }
function getrandom(buf: pointer; buflen: PtrUInt; flags: cardinal): PtrInt;cdecl; external;

function Random: integer;
function GetRandomInRange(minVal, maxVal: integer): integer;
procedure sleep(Milliseconds: cardinal);
function SerialBegin(aBaudrate : longint):boolean;
procedure CopyStrToBuffer(const s: shortstring; const buf: PChar);
procedure StrToPChar(const s: shortstring; out P: PChar);
function IntToChar(Value: integer): TChrArray;
function IntToString(Value: integer):TString11;
function ConcatPChar250(P1,P2:PChar):PChar; //verliert den Zeiger!
function ConcatPChar(P1, P2: PChar): string;
function ipaddr_aton(var cp: PChar; var addr: PIP_ADDR_T): Integer;
function ipaddr_ntoa(addr: pip_addr_t): PChar;
function ipaddr_ntoa_r(addr: pip_addr_t;buf: PChar;buflen: Integer): PChar;
function IntToStr (I : Longint) : String;
function IntToPChar(I : Longint) : PChar;
function HexValue(c: Char): Integer;

implementation

function Random: integer;
var
  buffer: integer;
  bytesRead: integer;
begin
 bytesRead := getrandom(@buffer, 4, 0);
 if bytesRead > 0 then
   Result := buffer
  else
   ESP_LOGE('Random','%s',['No random number found']);

end;

function GetRandomInRange(minVal, maxVal: integer): integer;
var
  buffer: LongWord;
  bytesRead: integer;
begin
  bytesRead := getrandom(@buffer, 4, 0);
  if bytesRead > 0 then
   Result := minVal + (buffer mod (maxVal - minVal + 1))
  else
   ESP_LOGE('GetRandomInRange','%s',['No random number found']);
end;

procedure sleep(Milliseconds: cardinal);
begin
  vTaskDelay(Milliseconds div portTICK_PERIOD_MS);
end;

function SerialBegin(aBaudrate: longint) : boolean;
var bo : boolean;
begin
 Result := true;
 uart_cfg.baud_rate  := aBaudrate;//(aBaudrate*40) div 26;
 uart_cfg.data_bits  := UART_DATA_8_BITS;
 uart_cfg.parity     := UART_PARITY_DISABLE;
 uart_cfg.stop_bits  := UART_STOP_BITS_1;
 uart_cfg.flow_ctrl  := UART_HW_FLOWCTRL_DISABLE;
 bo := EspErrorCheck(uart_param_config(UART_PORT, @uart_cfg)); //liefert true wenn okay
 if not bo then Result := false;
 bo := EspErrorCheck(uart_driver_install(UART_PORT, 256, 0, 0, nil, 0)); //liefert true wenn okay
 if Result then if not bo then Result := false;
end;

procedure CopyStrToBuffer(const s: shortstring; const buf: PChar);
var
  i: integer;
  pc: Pchar;
begin
  i := 1;
  pc := buf;
  while i <= length(s) do
  begin
    pc^ := s[i];
    inc(pc);
    inc(i);
  end;
end;

procedure StrToPChar(const s: shortstring; out P: PChar);
var
  buffer: array[0..255] of Char;
  i: Integer;
begin
  for i := 1 to Length(s) do
    buffer[i-1] := s[i];

  buffer[Length(s)] := #0;  // Nullterminierung

  p := @buffer[0];
end;


function IntToChar(Value: integer): TChrArray;
var
  i,lv   : integer;
  c1     : TChrArray;
  c2     : TChrArray;
begin
 for i:= 0 to 10 do c1[i]:= chr(65);
 i :=0;
 while (Value <> 0) do
  begin
   c1[i]  := chr((Value mod 10)+48);
   inc(i);
   Value := Value DIV 10;
  end;

 for i:= 0 to 10 do c2[i]:= #0;
 i := 0;
 for lv:=10 downto 0 do
  begin
   c2[i] := c1[lv];
   inc(i);
  end;

 for lv := 0 to 10 do c1[lv]:= #0;
 i:=0;
 for lv:= 0 to 10 do
  begin
   if c2[lv] <> chr(65) then
    begin
     c1[i] := c2[lv];
     inc(i);
    end;
  end;

 Result := c1;
end ;

function IntToString(Value: integer):TString11;
var
  i,lv   : integer;
  c1     : TChrArray;
  c2     : TChrArray;
  s      : string[11];
  neg    : boolean;
begin
 neg := false;
 for i:= 0 to 10 do c1[i]:= chr(65);

 if Value = 0 then
  begin
   Result := '0';
   exit;
  end;

 if Value < 0 then
  begin
   Value := Value * (-1);
   neg := true;
  end;


 i :=0;
 while (Value <> 0) do
  begin
   c1[i]  := chr((Value mod 10)+48);
   inc(i);
   Value := Value DIV 10;
  end;

 for i:= 0 to 10 do c2[i]:= #0;
 i := 0;
 for lv:=10 downto 0 do
  begin
   c2[i] := c1[lv];
   inc(i);
  end;

 for lv := 0 to 10 do c1[lv]:= #0;
 i:=0;
 for lv:= 0 to 10 do
  begin
   if c2[lv] <> chr(65) then
    begin
     c1[i] := c2[lv];
     inc(i);
    end;
  end;



 if neg then
  begin
   c2[0] := '-';
   for i := 0 to 9 do
    c2[i+1] := c1[i];
   for i := 0 to 10 do
    s[i+1] := c2[i];
  end
 else
  for i := 0 to 10 do
   s[i+1] := c1[i];

 Result := s;
end ;

function ConcatPChar250(P1,P2:PChar):PChar;  //Funktioniert nicht richtig verliert den Zeiger!
var buf    : array [0..250] of byte;
    i      : integer;
begin
 i := length(P1);
 CopyStrToBuffer(P1,@(buf[0]));
 CopyStrToBuffer(P2,@(buf[i]));
 Result := PChar(@buf);
end;

function ConcatPChar(P1, P2: PChar): string;
begin
  Result := StrPas(P1) + StrPas(P2);
end;

function ipaddr_aton(var cp: PChar; var addr: PIP_ADDR_T): Integer;
var
  val: UInt32;
  base: Byte;
  c, ch: Char;
  cutoff: UInt32;
  cutlim: Integer;
  parts: array[0..3] of UInt32;
  pp: Integer;
begin
  pp := 0;
  c := cp^;

  while True do
  begin
    // Nur Ziffern am Anfang erlaubt
    if not (c in ['0'..'9']) then
    begin
      Result := 0;
      Exit;
    end;

    val := 0;
    base := 10;

    if c = '0' then
    begin
      Inc(cp);
      c := cp^;
      if (c = 'x') or (c = 'X') then
      begin
        base := 16;
        Inc(cp);
        c := cp^;
      end
      else
        base := 8;
    end;

    cutoff := $FFFFFFFF div base;
    cutlim := $FFFFFFFF mod base;

    while True do
    begin
      if (c in ['0'..'9']) then
      begin
        ch := c;
        if (val > cutoff) or ((val = cutoff) and (Ord(ch) - Ord('0') > cutlim)) then
        begin
          Result := 0;
          Exit;
        end;
        val := val * base + (Ord(ch) - Ord('0'));
        Inc(cp);
        c := cp^;
      end
      else if (base = 16) and (c in ['0'..'9', 'a'..'f', 'A'..'F']) then
      begin
        if c in ['0'..'9'] then
          ch := Chr(Ord(c) - Ord('0'))
        else if c in ['a'..'f'] then
          ch := Chr(Ord(c) - Ord('a') + 10)
        else
          ch := Chr(Ord(c) - Ord('A') + 10);

        if (val > cutoff) or ((val = cutoff) and (Ord(ch) > cutlim)) then
        begin
          Result := 0;
          Exit;
        end;
        val := (val shl 4) or Ord(ch);
        Inc(cp);
        c := cp^;
      end
      else
        Break;
    end;

    if c = '.' then
    begin
      if pp >= 3 then
      begin
        Result := 0;
        Exit;
      end;
      parts[pp] := val;
      Inc(pp);
      Inc(cp);
      c := cp^;
    end
    else
      Break;
  end;

  // Überprüfen auf Trailing-Chars
  if (c <> #0) and not (c in [#1..#32]) then
  begin
    Result := 0;
    Exit;
  end;

  // Zusammensetzen
  case pp + 1 of
    1: ; // a -- 32 bits
    2: begin // a.b -- 8.24 bits
         if (val > $FFFFFF) or (parts[0] > $FF) then
         begin Result := 0; Exit; end;
         val := val or (parts[0] shl 24);
       end;
    3: begin // a.b.c -- 8.8.16 bits
         if (val > $FFFF) or (parts[0] > $FF) or (parts[1] > $FF) then
         begin Result := 0; Exit; end;
         val := val or (parts[0] shl 24) or (parts[1] shl 16);
       end;
    4: begin // a.b.c.d -- 8.8.8.8 bits
         if (val > $FF) or (parts[0] > $FF) or (parts[1] > $FF) or (parts[2] > $FF) then
         begin Result := 0; Exit; end;
         val := val or (parts[0] shl 24) or (parts[1] shl 16) or (parts[2] shl 8);
       end;
  else
    Result := 0; //bedeutet Fehler
    Exit;
  end;

  if addr <> nil then
    ip4_addr_set_u32(addr, lwip_htonl(val));

  Result := 1;  //bedeutet Erfolg
end;

function ipaddr_ntoa(addr: pip_addr_t): PChar;
var
  str: array[0..15] of Char; //static;
begin
  ipaddr_ntoa_r(addr, @str[0], SizeOf(str));
  Result := @str[0];
end;

function ipaddr_ntoa_r(addr: pip_addr_t;
                       buf: PChar;
                       buflen: Integer): PChar;
var
  s_addr: u32_t;
  inv: array[0..2] of Char;
  rp: PChar;
  ap: PByte;
  rem: Byte;
  n, i: Byte;
  len: Integer;
begin
  len := 0;

  s_addr := ip4_addr_get_u32(addr);

  rp := buf;
  ap := @s_addr;

  for n := 0 to 3 do
  begin
    i := 0;
    repeat
      rem := ap^ mod 10;
      ap^ := ap^ div 10;
      inv[i] := Chr(Ord('0') + rem);
      Inc(i);
    until ap^ = 0;

    while i > 0 do
    begin
      Dec(i);
      if len >= buflen then
      begin
        Result := nil;
        Exit;
      end;
      rp^ := inv[i];
      Inc(rp);
      Inc(len);
    end;

    if len >= buflen then
    begin
      Result := nil;
      Exit;
    end;
    rp^ := '.';
    Inc(rp);
    Inc(len);

    Inc(ap);
  end;

  Dec(rp);
  rp^ := #0;

  Result := buf;
end;

Function IntToStr (I : Longint) : String;
Var S : String;
begin
 Str (I,S);
 IntToStr:=S;
end;

Function IntToPChar(I : Longint) : PChar;
var s: string;
begin
 s := IntToStr(i); // Integer → String
 Result := PChar(s);    // String → PChar
end;

function HexValue(c: Char): Integer;
begin
  case c of
    '0'..'9': Result := ord(c) - ord('0');
    'A'..'F': Result := ord(c) - (ord('A') - 10);
    'a'..'f': Result := ord(c) - (ord('a') - 10);
  else
    Result := 0;
  end;
end;

end.

