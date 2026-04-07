unit lwip_ip;

{$mode objfpc}{$H+}
{$PACKRECORDS C}  // C-kompatible Struktur-Packung

interface

uses
  lwip_def, lwip_pbuf, lwip_ip_addr, lwip_err, lwip_netif, lwip_prot_ip4,lwip_ip4, lwip_ip6, lwip_prot_ip;

const
  LWIP_IP_HDRINCL = nil;

  SOF_REUSEADDR  = $04;  // allow local address reuse
  SOF_KEEPALIVE  = $08;  // keep connections alive
  SOF_BROADCAST  = $20;  // permit broadcast
  SOF_INHERITED  = SOF_REUSEADDR or SOF_KEEPALIVE;

type
  { IP PCB common part }
  TIP_PCB_NETIF_HINT = record
    {$IFDEF LWIP_NETIF_USE_HINTS}
    netif_hints: TNetIfHint;
    {$ENDIF}
  end;

  TIP_PCB = record
    local_ip: ip_addr_t;
    remote_ip: ip_addr_t;
    netif_idx: UInt8;
    so_options: UInt8;
    tos: UInt8;
    ttl: UInt8;
    {$IFDEF LWIP_NETIF_USE_HINTS}
    netif_hints: TNetIfHint;
    {$ENDIF}
  end;

 TIP_Globals = record
    current_netif: PNetIf;
    current_input_netif: PNetIf;
    {$IFDEF LWIP_IPV6}
    current_ip6_header: PIP6_HDR;
    {$ELSE}
    current_ip4_header: PIP_HDR;
    {$ENDIF}
    current_ip_header_tot_len: UInt16;
    current_iphdr_src: ip_addr_t;
    current_iphdr_dest: ip_addr_t;
  end;

var
  ip_data: TIP_Globals;external;

{ IP input entry point }
 function ip_input(p: Ppbuf; inp: PNetIf): err_t; cdecl; external;
{ Inline-Funktionen für aktuellen Packet-Zugriff }
function ip_current_netif: PNetIf; inline;
function ip_current_input_netif: PNetIf; inline;
function ip_current_header_tot_len: UInt16; inline;
function ip_current_src_addr: PIp_Addr_T; inline;
function ip_current_dest_addr: PIp_Addr_T; inline;
function ip4_current_header: PIP_HDR; inline;
function ip4_current_src_addr: PIp_Addr_T; inline;
function ip4_current_dest_addr: PIp_Addr_T; inline;
function ip_get_option(const pcb: TIP_PCB; opt: UInt8): Boolean; inline;
procedure ip_set_option(var pcb: TIP_PCB; opt: UInt8); inline;
procedure ip_reset_option(var pcb: TIP_PCB; opt: UInt8); inline;

implementation

function ip_current_netif: PNetIf; inline;
begin
  Result := ip_data.current_netif;
end;

function ip_current_input_netif: PNetIf; inline;
begin
  Result := ip_data.current_input_netif;
end;

function ip_current_header_tot_len: UInt16; inline;
begin
  Result := ip_data.current_ip_header_tot_len;
end;

function ip_current_src_addr: PIp_Addr_T; inline;
begin
  Result := @ip_data.current_iphdr_src;
end;

function ip_current_dest_addr: PIp_Addr_T; inline;
begin
  Result := @ip_data.current_iphdr_dest;
end;


{$IFDEF LWIP_IPV6}
function ip6_current_header: PIP6_HDR; inline;
begin
  Result := ip_data.current_ip6_header;
end;

function ip6_current_src_addr: PIp_Addr_T; inline;
begin
  Result := @ip_data.current_iphdr_src;
end;

function ip6_current_dest_addr: PIp_Addr_T; inline;
begin
  Result := @ip_data.current_iphdr_dest;
end;
{$ELSE}
function ip4_current_header: PIP_HDR; inline;
begin
  Result := ip_data.current_ip4_header;
end;

function ip4_current_src_addr: PIp_Addr_T; inline;
begin
  Result := @ip_data.current_iphdr_src;
end;

function ip4_current_dest_addr: PIp_Addr_T; inline;
begin
  Result := @ip_data.current_iphdr_dest;
end;
{$ENDIF}

{ Option Handling }
function ip_get_option(const pcb: TIP_PCB; opt: UInt8): Boolean; inline;
begin
  Result := (pcb.so_options and opt) <> 0;
end;

procedure ip_set_option(var pcb: TIP_PCB; opt: UInt8); inline;
begin
  pcb.so_options := pcb.so_options or opt;
end;

procedure ip_reset_option(var pcb: TIP_PCB; opt: UInt8); inline;
begin
  pcb.so_options := pcb.so_options and not opt;
end;

end.

