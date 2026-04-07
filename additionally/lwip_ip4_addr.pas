unit lwip_ip4_addr;

{$mode objfpc}{$H+}

interface

uses
  lwip_opt, lwip_def;

{$if LWIP_IPV4}
type
  u8_t  = Byte;
  u16_t = Word;
  u32_t = LongWord;
  s8_t  = ShortInt;


type
  ip4_addr_ = record
    addr: u32_t;
  end;

  ip4_addr_t = ip4_addr_;
  Pip4_addr_t = ^ip4_addr_t;

type
  Pnetif = Pointer; { forward declaration }
 (* Pnetif = ^Tnetif;
  Tnetif = record  *)

 // end;

const
  IPADDR_NONE      = u32_t($FFFFFFFF);
  IPADDR_LOOPBACK  = u32_t($7F000001);
  IPADDR_ANY       = u32_t($00000000);
  IPADDR_BROADCAST = u32_t($FFFFFFFF);

  IP_LOOPBACKNET = 127;

  IP_CLASSA_NET = $FF000000;
  IP_CLASSB_NET = $FFFF0000;
  IP_CLASSC_NET = $FFFFFF00;
  IP_CLASSD_NET = $F0000000;

  IP4ADDR_STRLEN_MAX = 16;

procedure IP4_ADDR(ipaddr: Pip4_addr_t; a,b,c,d: u8_t); inline;

procedure ip4_addr_copy(var dest: ip4_addr_t; const src: ip4_addr_t); inline;

procedure ip4_addr_set(dest: Pip4_addr_t; src: Pip4_addr_t); inline;

procedure ip4_addr_set_zero(ipaddr: Pip4_addr_t); inline;

procedure ip4_addr_set_any(ipaddr: Pip4_addr_t); inline;

procedure ip4_addr_set_loopback(ipaddr: Pip4_addr_t); inline;

function ip4_addr_cmp(addr1, addr2: Pip4_addr_t): Boolean; inline;

function ip4_addr_isany(addr: Pip4_addr_t): Boolean; inline;

function ip4_addr_get_u32(src: Pip4_addr_t): u32_t; inline;

procedure ip4_addr_set_u32(dest: Pip4_addr_t; value: u32_t); inline;

function ip4_addr_isloopback(ipaddr: Pip4_addr_t): Boolean; inline;

function ip4_addr1(ipaddr: Pip4_addr_t): u8_t; inline;
function ip4_addr2(ipaddr: Pip4_addr_t): u8_t; inline;
function ip4_addr3(ipaddr: Pip4_addr_t): u8_t; inline;
function ip4_addr4(ipaddr: Pip4_addr_t): u8_t; inline;

function ipaddr_addr(cp: PChar): u32_t;

function ip4addr_aton(cp: PChar; addr: Pip4_addr_t): Integer;

function ip4addr_ntoa(addr: Pip4_addr_t): PChar;

function ip4addr_ntoa_r(addr: Pip4_addr_t; buf: PChar; buflen: Integer): PChar;

function ip4_addr_isbroadcast_u32(addr: u32_t; netif: Pnetif): u8_t;

function ip4_addr_netmask_valid(netmask: u32_t): u8_t;
{$endif}
implementation

{$if LWIP_IPV4}

procedure IP4_ADDR(ipaddr: Pip4_addr_t; a,b,c,d: u8_t); inline;
begin
  ipaddr^.addr :=
      (u32_t(a) shl 24) or
      (u32_t(b) shl 16) or
      (u32_t(c) shl 8)  or
       u32_t(d);
end;

procedure ip4_addr_copy(var dest: ip4_addr_t; const src: ip4_addr_t); inline;
begin
  dest.addr := src.addr;
end;

procedure ip4_addr_set(dest: Pip4_addr_t; src: Pip4_addr_t); inline;
begin
  if src = nil then
    dest^.addr := 0
  else
    dest^.addr := src^.addr;
end;

procedure ip4_addr_set_zero(ipaddr: Pip4_addr_t); inline;
begin
  ipaddr^.addr := 0;
end;

procedure ip4_addr_set_any(ipaddr: Pip4_addr_t); inline;
begin
  ipaddr^.addr := IPADDR_ANY;
end;

procedure ip4_addr_set_loopback(ipaddr: Pip4_addr_t); inline;
begin
  ipaddr^.addr := IPADDR_LOOPBACK;
end;

function ip4_addr_cmp(addr1, addr2: Pip4_addr_t): Boolean; inline;
begin
  Result := addr1^.addr = addr2^.addr;
end;

function ip4_addr_isany(addr: Pip4_addr_t): Boolean; inline;
begin
  Result := (addr = nil) or (addr^.addr = IPADDR_ANY);
end;

function ip4_addr_get_u32(src: Pip4_addr_t): u32_t; inline;
begin
  Result := src^.addr;
end;

procedure ip4_addr_set_u32(dest: Pip4_addr_t; value: u32_t); inline;
begin
  dest^.addr := value;
end;

function ip4_addr_isloopback(ipaddr: Pip4_addr_t): Boolean; inline;
begin
  Result := (ipaddr^.addr and IP_CLASSA_NET) = (IP_LOOPBACKNET shl 24);
end;

function ip4_addr1(ipaddr: Pip4_addr_t): u8_t; inline;
begin
  Result := (ipaddr^.addr shr 24) and $FF;
end;

function ip4_addr2(ipaddr: Pip4_addr_t): u8_t; inline;
begin
  Result := (ipaddr^.addr shr 16) and $FF;
end;

function ip4_addr3(ipaddr: Pip4_addr_t): u8_t; inline;
begin
  Result := (ipaddr^.addr shr 8) and $FF;
end;

function ip4_addr4(ipaddr: Pip4_addr_t): u8_t; inline;
begin
  Result := ipaddr^.addr and $FF;
end;

function ipaddr_addr(cp: PChar): u32_t;
begin
  Result := 0; { Implementierung folgt im lwIP-Port }
end;

function ip4addr_aton(cp: PChar; addr: Pip4_addr_t): Integer;
begin
  Result := 0;
end;

function ip4addr_ntoa(addr: Pip4_addr_t): PChar;
begin
  Result := nil;
end;

function ip4addr_ntoa_r(addr: Pip4_addr_t; buf: PChar; buflen: Integer): PChar;
begin
  Result := nil;
end;

function ip4_addr_isbroadcast_u32(addr: u32_t; netif: Pnetif): u8_t;
begin
  Result := 0;
end;

function ip4_addr_netmask_valid(netmask: u32_t): u8_t;
begin
  Result := 0;
end;

{$endif}

end.
