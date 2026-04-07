unit lwip_ip4;

interface

uses
  lwip_opt, lwip_def, lwip_pbuf, lwip_ip4_addr, lwip_err, lwip_netif, lwip_prot_ip4;

{$IF LWIP_IPV4}

{$IFDEF LWIP_HOOK_IP4_ROUTE_SRC}
const
  LWIP_IPV4_SRC_ROUTING = 1;
{$ELSE}
const
  LWIP_IPV4_SRC_ROUTING = 0;
{$ENDIF}

const
  IP_OPTIONS_SEND = (LWIP_IPV4 and LWIP_IGMP);

procedure ip_init; inline;

function ip4_route(const dest: PIP4_ADDR_t): PNetIf;cdecl; external;
{$IF LWIP_IPV4_SRC_ROUTING}
function ip4_route_src(const src, dest: PIP4_ADDR): PNetIf;
{$ELSE}
function ip4_route_src(const src, dest: PIP4_ADDR_t): PNetIf; inline;
{$ENDIF}

function ip4_input(p: PPBuf; inp: PNetIf): Err_t;cdecl; external;
function ip4_output(p: PPBuf; const src, dest: PIP4_ADDR_t; ttl, tos, proto: u8_t): Err_t;cdecl; external;
function ip4_output_if(p: PPBuf; const src, dest: PIP4_ADDR_t; ttl, tos, proto: u8_t;
                       netif: PNetIf): Err_t;cdecl; external;
function ip4_output_if_src(p: PPBuf; const src, dest: PIP4_ADDR_t; ttl, tos, proto: u8_t;
                           netif: PNetIf): Err_t;cdecl; external;

{$IFDEF LWIP_NETIF_USE_HINTS}
function ip4_output_hinted(p: PPBuf; const src, dest: PIP4_ADDR_t; ttl, tos, proto: u8_t;
                           netif_hint: PNetIfHint): Err_t; cdecl; external;

{$ENDIF}

{$IF IP_OPTIONS_SEND}
function ip4_output_if_opt(p: PPBuf; const src, dest: PIP4_ADDR_t; ttl, tos, proto: u8_t;
                           netif: PNetIf; ip_options: Pointer; optlen: u16_t): Err_t;cdecl; external;
function ip4_output_if_opt_src(p: PPBuf; const src, dest: PIP4_ADDR_t; ttl, tos, proto: u8_t;
                               netif: PNetIf; ip_options: Pointer; optlen: u16_t): Err_t;cdecl; external;
{$ENDIF}

{$IF LWIP_MULTICAST_TX_OPTIONS}
procedure ip4_set_default_multicast_netif(default_multicast_netif: PNetIf);
{$ENDIF}

function NetIf_IP_Addr4(netif: PNetIf): PIP4_ADDR_t; inline;
function ip4_netif_get_local_ip(netif: PNetIf): PIP4_ADDR_t; inline;

procedure ip4_debug_print(p: PPBuf);

implementation

procedure ip_init; inline;
begin
  // Kompatibilität, keine Initialisierung nötig
end;

{$IF NOT LWIP_IPV4_SRC_ROUTING}
function ip4_route_src(const src, dest: PIP4_ADDR_t): PNetIf; inline;
begin
  Result := ip4_route(dest);
end;
{$ENDIF}

function NetIf_IP_Addr4(netif: PNetIf): PIP4_ADDR_t; inline;
begin
  if netif = nil then
    Result := nil
  else
    Result := @netif^.ip_addr;
end;

function ip4_netif_get_local_ip(netif: PNetIf): PIP4_ADDR_t; inline;
begin
  if netif <> nil then
    Result := netif_ip_addr4(netif)
  else
    Result := nil;
end;


procedure ip4_debug_print(p: PPBuf);
begin
  // leer
end;

{$ENDIF}
end.
