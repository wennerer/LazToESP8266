unit lwip_netif;

{$mode objfpc}{$H+}

interface

uses
  lwip_opt,
  lwip_err,
  lwip_ip4_addr,
  lwip_ip_addr,
  lwip_def,
  lwip_pbuf,
  lwip_stats;

type
  u8_t  = Byte;
  u16_t = Word;
  u32_t = LongWord;
  s8_t  = ShortInt;

{ ======================== Konstanten ======================== }

const
  NETIF_MAX_HWADDR_LEN = 6;
  NETIF_NAMESIZE       = 6;

{ ===== Flags ===== }

const
  NETIF_FLAG_UP        = $01;
  NETIF_FLAG_BROADCAST = $02;
  NETIF_FLAG_LINK_UP   = $04;
  NETIF_FLAG_ETHARP    = $08;
  NETIF_FLAG_ETHERNET  = $10;
  NETIF_FLAG_IGMP      = $20;
  NETIF_FLAG_MLD6      = $40;

{ ======================== Callback Typen ======================== }

type
  PNetIf = ^TNetIf;

  netif_init_fn  = function(netif: PNetIf): err_t; cdecl;
  netif_input_fn = function(p: PPBuf; inp: PNetIf): err_t; cdecl;

{$IFDEF LWIP_IPV6}
  netif_output_ip6_fn = function(netif: PNetIf; p: PPBuf;
    ipaddr: PIP6_addr_t): err_t; cdecl;
{$ELSE}
  netif_output_fn = function(netif: PNetIf; p: PPBuf;
  ipaddr: PIP4_addr_t): err_t; cdecl;
{$ENDIF}

  netif_linkoutput_fn = function(netif: PNetIf; p: PPBuf): err_t; cdecl;
  netif_status_callback_fn = procedure(netif: PNetIf); cdecl;

{ ======================== netif Struktur ======================== }
 TNetIf = record

{$IFNDEF LWIP_SINGLE_NETIF}
    next: PNetIf;
{$ENDIF}

{$IFDEF LWIP_IPV6}
  ip6_addr: array[0..LWIP_IPV6_NUM_ADDRESSES-1] of ip_addr_t;
  ip6_addr_state: array[0..LWIP_IPV6_NUM_ADDRESSES-1] of u8_t;
{$ELSE}
  ip_addr : ip_addr_t;
  netmask : ip_addr_t;
  gw      : ip_addr_t;
{$ENDIF}

  input: netif_input_fn;
  linkoutput: netif_linkoutput_fn;

{$IFDEF LWIP_IPV6}
      output_ip6: netif_output_ip6_fn;
{$ELSE}
    output: netif_output_fn;
{$ENDIF}





{$IFDEF LWIP_NETIF_STATUS_CALLBACK}
    status_callback: netif_status_callback_fn;
{$ENDIF}

{$IFDEF LWIP_NETIF_LINK_CALLBACK}
    link_callback: netif_status_callback_fn;
{$ENDIF}

    state: Pointer;

    mtu: u16_t;
    hwaddr: array[0..NETIF_MAX_HWADDR_LEN-1] of u8_t;
    hwaddr_len: u8_t;
    flags: u8_t;
    name: array[0..1] of Char;
    num: u8_t;

{$IFDEF LWIP_IPV6_AUTOCONFIG}
    ip6_autoconfig_enabled: u8_t;
{$ENDIF}

  end;



{ ======================== Globale Variablen ======================== }

var
  netif_default: PNetIf;
{$IFNDEF LWIP_SINGLE_NETIF}
  netif_list: PNetIf;
{$ENDIF}

{ ======================== Inline Helpers ======================== }

procedure netif_set_flags(netif: PNetIf; set_flags: u8_t); inline;
procedure netif_clear_flags(netif: PNetIf; clr_flags: u8_t); inline;
function  netif_is_flag_set(netif: PNetIf; flag: u8_t): Boolean; inline;
function  netif_is_up(netif: PNetIf): Boolean; inline;
function  netif_is_link_up(netif: PNetIf): Boolean; inline;
function  netif_get_index(netif: PNetIf): u8_t; inline;

{ ======================== API Funktionen ======================== }

procedure netif_init; cdecl;external;

function netif_add_noaddr(netif: PNetIf; state: Pointer;
  init: netif_init_fn; input: netif_input_fn): PNetIf; cdecl;external;

{$IFDEF LWIP_IPV6}
{$ELSE}
function netif_add(netif: PNetIf;
  ipaddr, netmask, gw: PIP4_addr_t;
  state: Pointer;
  init: netif_init_fn;
  input: netif_input_fn): PNetIf; cdecl;external;

procedure netif_set_addr(netif: PNetIf;
  ipaddr, netmask, gw: PIP4_addr_t); cdecl;external;
{$ENDIF}

procedure netif_remove(netif: PNetIf); cdecl;external;
function  netif_find(name: PChar): PNetIf; cdecl;external;
procedure netif_set_default(netif: PNetIf); cdecl;external;

procedure netif_set_up(netif: PNetIf); cdecl;external;
procedure netif_set_down(netif: PNetIf); cdecl;external;
procedure netif_set_link_up(netif: PNetIf); cdecl;external;
procedure netif_set_link_down(netif: PNetIf); cdecl;external;

function netif_input(p: PPBuf; inp: PNetIf): err_t; cdecl;external;

implementation

{ ======================== Inline Implementierung ======================== }

procedure netif_set_flags(netif: PNetIf; set_flags: u8_t); inline;
begin
  netif^.flags := netif^.flags or set_flags;
end;

procedure netif_clear_flags(netif: PNetIf; clr_flags: u8_t); inline;
begin
  netif^.flags := netif^.flags and not clr_flags;
end;

function netif_is_flag_set(netif: PNetIf; flag: u8_t): Boolean; inline;
begin
  Result := (netif^.flags and flag) <> 0;
end;

function netif_is_up(netif: PNetIf): Boolean; inline;
begin
  Result := netif_is_flag_set(netif, NETIF_FLAG_UP);
end;

function netif_is_link_up(netif: PNetIf): Boolean; inline;
begin
  Result := netif_is_flag_set(netif, NETIF_FLAG_LINK_UP);
end;

function netif_get_index(netif: PNetIf): u8_t; inline;
begin
  Result := netif^.num + 1;
end;

end.
