unit Laz_ESP;

interface

uses
  task, portmacro,uart, esp_err;

type
  TChrArray = array[0..10] of char;
type
  TString11  = string[11];

const
 UART_PORT: Tuart_port = UART_NUM_0;

var
 uart_cfg: Tuart_config;

procedure sleep(Milliseconds: cardinal);
function SerialBegin(aBaudrate : longint):boolean;
procedure CopyStrToBuffer(const s: shortstring; const buf: PChar);
function IntToChar(Value: integer): TChrArray;
function IntToString(Value: integer):TString11;
function ConcatPChar250(P1,P2:PChar):PChar;

implementation

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

function ConcatPChar250(P1,P2:PChar):PChar;
var buf    : array [0..250] of byte;
    l,i,lv : integer;

begin
 i := length(P1);
 CopyStrToBuffer(P1,@(buf[0]));
 CopyStrToBuffer(P2,@(buf[i]));
 Result := PChar(@buf);
end;

end.

