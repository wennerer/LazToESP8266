unit lwip_inet;

{$mode objfpc}{$H+}

interface

uses
 lwip_opt,
 lwip_def,
 lwip_ip_addr,
 lwip_ip6_addr,
 ctypes;

type
  u8_t  = Byte;
  u32_t = LongWord;

  in_addr_t = u32_t;

type
  Pin_addr = ^in_addr;
  in_addr = record
    s_addr: in_addr_t;
  end;

type
  Pin6_addr = ^in6_addr;
  in6_addr = record
    case Integer of
      0: (u32_addr: array[0..3] of u32_t);
      1: (u8_addr: array[0..15] of u8_t);
  end;

{ Alias wie in C: s6_addr }
function s6_addr(var addr: in6_addr): PByte; inline;

{ ===== Konstanten ===== }

const
  INADDR_NONE      = $FFFFFFFF;
  INADDR_LOOPBACK  = $7F000001;
  INADDR_ANY       = $00000000;
  INADDR_BROADCAST = $FFFFFFFF;

  INET_ADDRSTRLEN  = 16;
  INET6_ADDRSTRLEN = 46;

{ ===== IPv6 Initializer ===== }

function IN6ADDR_ANY_INIT: in6_addr;
function IN6ADDR_LOOPBACK_INIT: in6_addr;

{ extern Variable }
var
  in6addr_any: in6_addr; cvar; external;

{ ===== lwIP interne Funktionen ===== }

function ipaddr_addr(cp: PChar): u32_t; cdecl; external;
function ip4addr_aton(cp: PChar; addr: Pointer): cint; cdecl; external;
function ip4addr_ntoa(addr: Pointer): PChar; cdecl; external;
function ip4addr_ntoa_r(addr: Pointer; buf: PChar; buflen: cint): PChar; cdecl; external;

function ip6addr_aton(cp: PChar; addr: Pointer): cint; cdecl; external;
function ip6addr_ntoa(addr: Pointer): PChar; cdecl; external;
function ip6addr_ntoa_r(addr: Pointer; buf: PChar; buflen: cint): PChar; cdecl; external;

{ ===== Wrapper (Ersatz für Makros) ===== }

function inet_addr(cp: PChar): u32_t; inline;
function inet_aton(cp: PChar; addr: Pin_addr): cint; inline;
function inet_ntoa(addr: in_addr): PChar; inline;
function inet_ntoa_r(addr: in_addr; buf: PChar; buflen: cint): PChar; inline;

function inet6_aton(cp: PChar; addr: Pin6_addr): cint; inline;
function inet6_ntoa(addr: in6_addr): PChar; inline;
function inet6_ntoa_r(addr: in6_addr; buf: PChar; buflen: cint): PChar; inline;

implementation

function s6_addr(var addr: in6_addr): PByte; inline;
begin
  Result := @addr.u8_addr[0];
end;

function IN6ADDR_ANY_INIT: in6_addr;
begin
  FillChar(Result, SizeOf(Result), 0);
end;

function IN6ADDR_LOOPBACK_INIT: in6_addr;
begin
  FillChar(Result, SizeOf(Result), 0);
  Result.u32_addr[3] := 1; // ::1
end;

{ ===== IPv4 ===== }

function inet_addr(cp: PChar): u32_t; inline;
begin
  Result := ipaddr_addr(cp);
end;

function inet_aton(cp: PChar; addr: Pin_addr): cint; inline;
begin
  Result := ip4addr_aton(cp, addr);
end;

function inet_ntoa(addr: in_addr): PChar; inline;
begin
  Result := ip4addr_ntoa(@addr);
end;

function inet_ntoa_r(addr: in_addr; buf: PChar; buflen: cint): PChar; inline;
begin
  Result := ip4addr_ntoa_r(@addr, buf, buflen);
end;

{ ===== IPv6 ===== }

function inet6_aton(cp: PChar; addr: Pin6_addr): cint; inline;
begin
  Result := ip6addr_aton(cp, addr);
end;

function inet6_ntoa(addr: in6_addr): PChar; inline;
begin
  Result := ip6addr_ntoa(@addr);
end;

function inet6_ntoa_r(addr: in6_addr; buf: PChar; buflen: cint): PChar; inline;
begin
  Result := ip6addr_ntoa_r(@addr, buf, buflen);
end;

end.
