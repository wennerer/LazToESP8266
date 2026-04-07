unit lwip_ip_addr;
{$MACRO ON}
interface

(*uses
  ip4_addr, ip6_addr, lwip_opt, lwip_def; *)

uses
  SysUtils,
  lwip_ip4_addr,
  lwip_ip6_addr;

type
  u8_t = Byte;

{$IFDEF __cplusplus}
{ C++ extern handling would go here if needed }
{$ENDIF}

type
  { IP address types for use in ip_addr_t.type member }
  TLwipIpAddrType = (
    IPADDR_TYPE_V4 = 0,    { IPv4 }
    IPADDR_TYPE_V6 = 6,    { IPv6 }
    IPADDR_TYPE_ANY = 46   { IPv4+IPv6 ("dual-stack") }
  );

{$IFDEF LWIP_IPV4 and LWIP_IPV6}

type
  { A record type for both IP version's addresses }
  ip_addr_t = record
    case Byte of
      0: (ip6: ip6_addr_t);
      1: (ip4: ip4_addr_t);
    u_addr: record
      ip6: ip6_addr_t;
      ip4: ip4_addr_t;
    end;
    type_: u8;  { lwip_ip_addr_type }
  end;

var
  ip_addr_any_type: ip_addr_t; external;

{ Macro equivalents as inline functions }
function IPADDR4_INIT(u32val: uint32): ip_addr_t; inline;
function IPADDR4_INIT_BYTES(a, b, c, d: uint8): ip_addr_t; inline;
function IPADDR6_INIT(a, b, c, d: uint32): ip_addr_t; inline;
function IPADDR6_INIT_HOST(a, b, c, d: uint32): ip_addr_t; inline;
function IPADDR_ANY_TYPE_INIT: ip_addr_t; inline;

function IP_IS_ANY_TYPE_VAL(const ipaddr: ip_addr_t): Boolean; inline;
function IP_IS_V4_VAL(const ipaddr: ip_addr_t): Boolean; inline;
function IP_IS_V6_VAL(const ipaddr: ip_addr_t): Boolean; inline;
function IP_IS_V4(ipaddr: Pip_addr_t): Boolean; inline;
function IP_IS_V6(ipaddr: Pip_addr_t): Boolean; inline;

procedure IP_SET_TYPE_VAL(var ipaddr: ip_addr_t; iptype: TLwipIpAddrType); inline;
procedure IP_SET_TYPE(ipaddr: Pip_addr_t; iptype: TLwipIpAddrType); inline;
function IP_GET_TYPE(ipaddr: Pip_addr_t): TLwipIpAddrType; inline;

function IP_ADDR_RAW_SIZE(const ipaddr: ip_addr_t): Integer; inline;
function IP_ADDR_PCB_VERSION_MATCH_EXACT(const pcb: Pointer; const ipaddr: Pip_addr_t): Boolean; inline;
function IP_ADDR_PCB_VERSION_MATCH(const pcb: Pointer; const ipaddr: Pip_addr_t): Boolean; inline;

function ip_2_ip6(ipaddr: Pip_addr_t): Pip6_addr_t; inline;
function ip_2_ip4(ipaddr: Pip_addr_t): Pip4_addr_t; inline;

procedure IP_ADDR4(var ipaddr: ip_addr_t; a, b, c, d: uint8); inline;
procedure IP_ADDR6(var ipaddr: ip_addr_t; i0, i1, i2, i3: uint32); inline;
procedure IP_ADDR6_HOST(var ipaddr: ip_addr_t; i0, i1, i2, i3: uint32); inline;

procedure ip_clear_no4(var ipaddr: ip_addr_t); inline;

{$IFDEF ESP_IPV6}
function IP_V6_EQ_PART(const ipaddr: Pip_addr_t; WORD: Integer; VAL: uint32): Boolean; inline;
function IP_IS_V4MAPPEDV6(const ipaddr: Pip_addr_t): Boolean; inline;
{$ENDIF}

procedure ip_addr_copy(var dest, src: ip_addr_t); inline;
procedure ip_addr_copy_from_ip6(var dest: ip_addr_t; const src: ip6_addr_t); inline;
procedure ip_addr_copy_from_ip6_packed(var dest: ip_addr_t; const src: Pip6_addr_t); inline;
procedure ip_addr_copy_from_ip4(var dest: ip_addr_t; const src: ip4_addr_t); inline;

procedure ip_addr_set_ip4_u32(ipaddr: Pip_addr_t; val: uint32); inline;
procedure ip_addr_set_ip4_u32_val(var ipaddr: ip_addr_t; val: uint32); inline;
function ip_addr_get_ip4_u32(ipaddr: Pip_addr_t): uint32; inline;

procedure ip_addr_set(dest, src: Pip_addr_t); inline;
procedure ip_addr_set_ipaddr(dest, src: Pip_addr_t); inline;
procedure ip_addr_set_zero(ipaddr: Pip_addr_t); inline;
procedure ip_addr_set_zero_ip4(ipaddr: Pip_addr_t); inline;
procedure ip_addr_set_zero_ip6(ipaddr: Pip_addr_t); inline;

procedure ip_addr_set_any(is_ipv6: Boolean; ipaddr: Pip_addr_t); inline;
procedure ip_addr_set_any_val(is_ipv6: Boolean; var ipaddr: ip_addr_t); inline;
procedure ip_addr_set_loopback(is_ipv6: Boolean; ipaddr: Pip_addr_t); inline;
procedure ip_addr_set_loopback_val(is_ipv6: Boolean; var ipaddr: ip_addr_t); inline;

procedure ip_addr_set_hton(dest, src: Pip_addr_t); inline;
procedure ip_addr_get_network(target, host, netmask: Pip_addr_t); inline;

function ip_addr_netcmp(addr1, addr2, mask: Pip_addr_t): Boolean; inline;
function ip_addr_cmp(addr1, addr2: Pip_addr_t): Boolean; inline;
function ip_addr_cmp_zoneless(addr1, addr2: Pip_addr_t): Boolean; inline;

function ip_addr_isany(ipaddr: Pip_addr_t): Boolean; inline;
function ip_addr_isany_val(const ipaddr: ip_addr_t): Boolean; inline;
function ip_addr_isbroadcast(ipaddr: Pip_addr_t; netif: Pointer): Boolean; inline;
function ip_addr_ismulticast(ipaddr: Pip_addr_t): Boolean; inline;
function ip_addr_isloopback(ipaddr: Pip_addr_t): Boolean; inline;
function ip_addr_islinklocal(ipaddr: Pip_addr_t): Boolean; inline;

procedure ip_addr_debug_print(debug: Boolean; ipaddr: Pip_addr_t); inline;
procedure ip_addr_debug_print_val(debug: Boolean; const ipaddr: ip_addr_t); inline;

function ipaddr_ntoa(const addr: Pip_addr_t): PChar;
function ipaddr_ntoa_r(const addr: Pip_addr_t; buf: PChar; buflen: Integer): PChar;
function ipaddr_aton(cp: PChar; addr: Pip_addr_t): Integer;

const
  IPADDR_STRLEN_MAX = IP6ADDR_STRLEN_MAX;

procedure ip4_2_ipv4_mapped_ipv6(ip6addr: Pip6_addr_t; const ip4addr: Pip4_addr_t); inline;
procedure unmap_ipv4_mapped_ipv6(ip4addr: Pip4_addr_t; const ip6addr: Pip6_addr_t); inline;

function IP46_ADDR_ANY(type_: TLwipIpAddrType): Pip_addr_t; inline;

{$ELSE} { IPv4 or IPv6 only }

{ Simplified versions for single IP stack }

{$IFDEF LWIP_IPV6} { LWIP_IPV6 only }
type
  ip_addr_t = ip6_addr_t;

const
  IPADDR6_INIT: ip_addr_t = (addr: (0, 0, 0, 0));
  IPADDR_STRLEN_MAX = IP6ADDR_STRLEN_MAX;


{$ELSE}

type
  Pip_addr_t =^ip_addr_t;
  ip_addr_t = ip4_addr_t;

const
  IPADDR4_INIT: ip_addr_t = (addr: 0);
  IPADDR_STRLEN_MAX = IP4ADDR_STRLEN_MAX;

{$ENDIF} { LWIP_IPV4 }

{$ENDIF} { LWIP_IPV4 and LWIP_IPV6 }

{$IFDEF LWIP_IPV6}
var
  ip6_addr_any: ip_addr_t; external;

//const
  //IP6_ADDR_ANY = @ip6_addr_any;
  {$DEFINE IP6_ADDR_ANY := @ip6_addr_any}

{$IFDEF not LWIP_IPV4}
  //IP_ADDR_ANY = IP6_ADDR_ANY;
  {$DEFINE IP_ADDR_ANY := @ip6_addr_any}
{$ENDIF}
{$Else}
var
  ip_addr_any: ip_addr_t; external;
  ip_addr_broadcast: ip_addr_t; external;

(*const
  IP_ADDR_ANY = ip_addr_any;
  IP4_ADDR_ANY = @ip_addr_any;*)
  {$DEFINE IP_ADDR_ANY := @ip_addr_any}
  {$DEFINE IP4_ADDR_ANY := @ip_addr_any}



{$ENDIF}


{$IFDEF LWIP_IPV4 and LWIP_IPV6}
const
  IP_ANY_TYPE = @ip_addr_any_type;
{$ELSE}
//const
  //IP_ANY_TYPE = IP_ADDR_ANY;
  {$DEFINE IP_ANY_TYPE := @ip_addr_any}
{$ENDIF}

implementation

{ Implementation of inline functions would go here }
{ Most of these are simple wrappers/redirects to the underlying IPv4/IPv6 functions }

end.



(*unit lwip_ip_addr;

{$mode objfpc}{$H+}

interface

uses
  SysUtils,
  lwip_ip4_addr,
  lwip_ip6_addr;

type
  u8_t = Byte;

  { entspricht enum lwip_ip_addr_type }
  lwip_ip_addr_type = (
    IPADDR_TYPE_V4 = 0,
    IPADDR_TYPE_V6 = 6,
    IPADDR_TYPE_ANY = 46
  );

{$IFDEF LWIP_IPV4}
{$IFDEF LWIP_IPV6}

type
  ip_addr_u = record
    case Integer of
      0: (ip6: ip6_addr_t);
      1: (ip4: ip4_addr_t);
  end;

  ip_addr_t = record
    u_addr: ip_addr_u;
    _type: u8_t;
  end;

var
  ip_addr_any_type: ip_addr_t;

{ --- Typprüfung --- }

function IP_GET_TYPE(const ipaddr: ip_addr_t): u8_t; inline;
procedure IP_SET_TYPE(var ipaddr: ip_addr_t; iptype: u8_t); inline;

function IP_IS_V4(const ipaddr: ip_addr_t): Boolean; inline;
function IP_IS_V6(const ipaddr: ip_addr_t): Boolean; inline;
function IP_IS_ANY_TYPE(const ipaddr: ip_addr_t): Boolean; inline;

{ --- Zugriff --- }

function ip_2_ip4(var ipaddr: ip_addr_t): PIP4_addr_t; inline;
function ip_2_ip6(var ipaddr: ip_addr_t): PIP6_addr_t; inline;

{ --- Setzen IPv4 --- }

procedure IP_ADDR4(var ipaddr: ip_addr_t; a,b,c,d: Byte);
procedure IP_ADDR6(var ipaddr: ip_addr_t; i0,i1,i2,i3: LongWord);

{ --- Copy --- }

procedure ip_addr_copy(var dest: ip_addr_t; const src: ip_addr_t);

{ --- Vergleiche --- }

function ip_addr_cmp(const a,b: ip_addr_t): Boolean;

{$ENDIF}
{$ENDIF}

implementation

{$IFDEF LWIP_IPV4}
{$IFDEF LWIP_IPV6}

function IP_GET_TYPE(const ipaddr: ip_addr_t): u8_t; inline;
begin
  Result := ipaddr._type;
end;

procedure IP_SET_TYPE(var ipaddr: ip_addr_t; iptype: u8_t); inline;
begin
  ipaddr._type := iptype;
end;

function IP_IS_V4(const ipaddr: ip_addr_t): Boolean; inline;
begin
  Result := ipaddr._type = Ord(IPADDR_TYPE_V4);
end;

function IP_IS_V6(const ipaddr: ip_addr_t): Boolean; inline;
begin
  Result := ipaddr._type = Ord(IPADDR_TYPE_V6);
end;

function IP_IS_ANY_TYPE(const ipaddr: ip_addr_t): Boolean; inline;
begin
  Result := ipaddr._type = Ord(IPADDR_TYPE_ANY);
end;

function ip_2_ip4(var ipaddr: ip_addr_t): PIP4_addr_t; inline;
begin
  Result := @ipaddr.u_addr.ip4;
end;

function ip_2_ip6(var ipaddr: ip_addr_t): PIP6_addr_t; inline;
begin
  Result := @ipaddr.u_addr.ip6;
end;

procedure IP_ADDR4(var ipaddr: ip_addr_t; a,b,c,d: Byte);
begin
  IP4_ADDR(ipaddr.u_addr.ip4, a,b,c,d);
  ipaddr._type := Ord(IPADDR_TYPE_V4);
end;

procedure IP_ADDR6(var ipaddr: ip_addr_t; i0,i1,i2,i3: LongWord);
begin
  IP6_ADDR(ipaddr.u_addr.ip6, i0,i1,i2,i3);
  ipaddr._type := Ord(IPADDR_TYPE_V6);
end;

procedure ip_addr_copy(var dest: ip_addr_t; const src: ip_addr_t);
begin
  dest._type := src._type;
  if IP_IS_V6(src) then
    ip6_addr_copy(dest.u_addr.ip6, src.u_addr.ip6)
  else
    ip4_addr_copy(dest.u_addr.ip4, src.u_addr.ip4);
end;

function ip_addr_cmp(const a,b: ip_addr_t): Boolean;
begin
  if a._type <> b._type then
    Exit(False);

  if IP_IS_V6(a) then
    Result := ip6_addr_cmp(@a.u_addr.ip6, @b.u_addr.ip6)
  else
    Result := ip4_addr_cmp(@a.u_addr.ip4, @b.u_addr.ip4);
end;

{$ENDIF}
{$ENDIF}

end. *)
