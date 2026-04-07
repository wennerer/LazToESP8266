unit lwip_ip6;

{$mode objfpc}{$H+}
{$PACKRECORDS C}   // für byte-genaue LWIP-Strukturen

interface

uses
  lwip_def, lwip_pbuf, lwip_netif, lwip_err, lwip_ip6_addr;

{$IFDEF LWIP_IPV6}  // nur wenn IPv6 in lwipopts.h aktiviert ist

type
  PNetIf = ^TNetIf;
  PIP6Addr = ^TIP6Addr;
  PIPAddr = ^TIPAddr;
  PNetIfHint = ^TNetIfHint;

{ IPv6 Routing und Output-Funktionen }
function ip6_route(const src, dest: PIP6Addr): PNetIf; cdecl; external;
function ip6_select_source_address(netif: PNetIf; const dest: PIP6Addr): PIPAddr; cdecl; external;

function ip6_input(p: PPBuf; inp: PNetIf): ErrT; cdecl; external;
function ip6_output(p: PPBuf; const src, dest: PIP6Addr;
                    hl, tc, nexth: UInt8): ErrT; cdecl; external;
function ip6_output_if(p: PPBuf; const src, dest: PIP6Addr;
                       hl, tc, nexth: UInt8; netif: PNetIf): ErrT; cdecl; external;
function ip6_output_if_src(p: PPBuf; const src, dest: PIP6Addr;
                           hl, tc, nexth: UInt8; netif: PNetIf): ErrT; cdecl; external;

{$IFDEF LWIP_NETIF_USE_HINTS}
function ip6_output_hinted(p: PPBuf; const src, dest: PIP6Addr;
                           hl, tc, nexth: UInt8; netif_hint: PNetIfHint): ErrT; cdecl; external;
{$ENDIF}

{$IFDEF LWIP_IPV6_MLD}
function ip6_options_add_hbh_ra(p: PPBuf; nexth, value: UInt8): ErrT; cdecl; external;
{$ENDIF}

{ Makro-Funktion ip6_netif_get_local_ip }
function ip6_netif_get_local_ip(netif: PNetIf; dest: PIP6Addr): PIPAddr; inline;
begin
  if netif <> nil then
    Result := ip6_select_source_address(netif, dest)
  else
    Result := nil;
end;

{$IFDEF IP6_DEBUG}
procedure ip6_debug_print(p: PPBuf); cdecl; external;
{$ELSE}
procedure ip6_debug_print(p: PPBuf); inline;
begin
  // keine Debug-Ausgabe
end;
{$ENDIF}

{$ENDIF} // LWIP_IPV6

implementation

end.
