unit lwip_udp;

{$mode objfpc}{$H+}

interface

uses
  lwip_opt, lwip_pbuf, lwip_netif, lwip_ip_addr, lwip_ip, lwip_ip6_addr, lwip_prot_udp, lwip_err;

//{$IF LWIP_UDP}

type
  udp_flags_t = Byte;

const
  UDP_FLAGS_NOCHKSUM       = $01;
  UDP_FLAGS_UDPLITE        = $02;
  UDP_FLAGS_CONNECTED      = $04;
  UDP_FLAGS_MULTICAST_LOOP = $08;


type
  Pudp_pcb = ^Tudp_pcb;

  { Receive callback }
  Tudp_recv_fn = procedure(arg  : Pointer;pcb  : Pudp_pcb;p: Ppbuf;addr : Pip_addr_t;port : u16_t); cdecl;

  Tudp_pcb = record
    { Common IP PCB part }
    local_ip   : ip_addr_t;
    remote_ip  : ip_addr_t;
    so_options : u8_t;
    tos        : u8_t;
    ttl        : u8_t;
    {$IFDEF LWIP_NETIF_HWADDRHINT}
    addr_hint  : u8_t;
    {$ENDIF}

    { UDP specific }
    next        : Pudp_pcb;
    flags       : u8_t;
    local_port  : u16_t;
    remote_port : u16_t;

    {$IF LWIP_MULTICAST_TX_OPTIONS}
    {$IF LWIP_IPV4}
     mcast_ip4: Tip4_addr; // outgoing network interface IPv4 address for multicast
    {$ENDIF}
     mcast_ifindex: Byte;
     mcast_ttl: Byte;
    {$ENDIF}

    {$IFDEF LWIP_UDPLITE}
    chksum_len_rx : u16_t;
    chksum_len_tx : u16_t;
    {$ENDIF}

    recv     : Tudp_recv_fn;
    recv_arg : Pointer;
  end;

var
  udp_pcbs: Pudp_pcb;

function udp_new: Pudp_pcb; cdecl;external;
function udp_new_ip_type(ip_type: Byte): Pudp_pcb; cdecl;external;
procedure udp_remove(pcb: Pudp_pcb); cdecl;external;
function udp_bind(pcb: Pudp_pcb; const ipaddr: Pip_addr_t; port: Word): err_t; cdecl;external;
procedure udp_bind_netif(pcb: Pudp_pcb; netif: Pnetif); cdecl;external;
function udp_connect(pcb: Pudp_pcb; const ipaddr: Pip_addr_t; port: Word): err_t; cdecl;external;
procedure udp_disconnect(pcb: Pudp_pcb); cdecl;external;
procedure udp_recv(pcb: Pudp_pcb; recv: Tudp_recv_fn; recv_arg: Pointer); cdecl;external;
function udp_sendto_if(pcb: Pudp_pcb; p: Ppbuf; const dst_ip: Pip_addr_t;
                       dst_port: Word; netif: Pnetif): err_t; cdecl;external;
function udp_sendto_if_src(pcb: Pudp_pcb; p: Ppbuf; const dst_ip: Pip_addr_t;
                           dst_port: Word; netif: Pnetif; const src_ip: Pip_addr_t): err_t; cdecl;external;
function udp_sendto(pcb: Pudp_pcb; p: Ppbuf; const dst_ip: Pip_addr_t; dst_port: Word): err_t; cdecl;external;
function udp_send(pcb: Pudp_pcb; p: Ppbuf): err_t; cdecl;external;

{$IF LWIP_CHECKSUM_ON_COPY and CHECKSUM_GEN_UDP}
function udp_sendto_if_chksum(pcb: Pudp_pcb; p: Ppbuf; const dst_ip: Pip_addr_t;
                              dst_port: Word; netif: Pnetif; have_chksum: Byte;
                              chksum: Word): err_t; cdecl;external;
function udp_sendto_chksum(pcb: Pudp_pcb; p: Ppbuf; const dst_ip: Pip_addr_t;
                            dst_port: Word; have_chksum: Byte; chksum: Word): err_t; cdecl;external;
function udp_send_chksum(pcb: Pudp_pcb; p: Ppbuf; have_chksum: Byte;
                         chksum: Word): err_t; cdecl;external;
function udp_sendto_if_src_chksum(pcb: Pudp_pcb; p: Ppbuf; const dst_ip: Pip_addr_t;
                                  dst_port: Word; netif: Pnetif;
                                  have_chksum: Byte; chksum: Word; const src_ip: Pip_addr_t): err_t; cdecl;external;
{$ENDIF}

{ Flags helper functions }
function udp_flags(pcb: Pudp_pcb): udp_flags_t; inline;
procedure udp_setflags(pcb: Pudp_pcb; f: udp_flags_t); inline;
procedure udp_set_flags(pcb: Pudp_pcb; set_flags: udp_flags_t); inline;
procedure udp_clear_flags(pcb: Pudp_pcb; clr_flags: udp_flags_t); inline;
function udp_is_flag_set(pcb: Pudp_pcb; flag: udp_flags_t): Boolean; inline;

procedure udp_input(p: Ppbuf; inp: Pnetif); cdecl;external;
procedure udp_init; cdecl;external;
procedure udp_netif_ip_addr_changed(const old_addr, new_addr: Pip_addr_t); cdecl;external;

{$IF LWIP_MULTICAST_TX_OPTIONS}
{$IF LWIP_IPV4}
procedure udp_set_multicast_netif_addr(pcb: Pudp_pcb; const ip4addr: Tip4_addr); inline;
function udp_get_multicast_netif_addr(pcb: Pudp_pcb): Ptip4_addr; inline;
{$ENDIF}
procedure udp_set_multicast_netif_index(pcb: Pudp_pcb; idx: Byte); inline;
function udp_get_multicast_netif_index(pcb: Pudp_pcb): Byte; inline;
procedure udp_set_multicast_ttl(pcb: Pudp_pcb; value: Byte); inline;
function udp_get_multicast_ttl(pcb: Pudp_pcb): Byte; inline;
{$ENDIF}

{$IFDEF UDP_DEBUG}
procedure udp_debug_print(udphdr: Pudp_hdr); cdecl;
{$ENDIF}

implementation

function udp_flags(pcb: Pudp_pcb): udp_flags_t; inline;
begin
  Result := pcb^.flags;
end;

procedure udp_setflags(pcb: Pudp_pcb; f: udp_flags_t); inline;
begin
  pcb^.flags := f;
end;

procedure udp_set_flags(pcb: Pudp_pcb; set_flags: udp_flags_t); inline;
begin
  pcb^.flags := pcb^.flags or set_flags;
end;

procedure udp_clear_flags(pcb: Pudp_pcb; clr_flags: udp_flags_t); inline;
begin
  pcb^.flags := pcb^.flags and (not clr_flags);
end;

function udp_is_flag_set(pcb: Pudp_pcb; flag: udp_flags_t): Boolean; inline;
begin
  Result := (pcb^.flags and flag) <> 0;
end;

{$IF LWIP_MULTICAST_TX_OPTIONS}
{$IF LWIP_IPV4}
procedure udp_set_multicast_netif_addr(pcb: Pudp_pcb; const ip4addr: Tip4_addr); inline;
begin
  pcb^.mcast_ip4 := ip4addr;
end;

function udp_get_multicast_netif_addr(pcb: Pudp_pcb): Ptip4_addr; inline;
begin
  Result := @pcb^.mcast_ip4;
end;
{$ENDIF}

procedure udp_set_multicast_netif_index(pcb: Pudp_pcb; idx: Byte); inline;
begin
  pcb^.mcast_ifindex := idx;
end;

function udp_get_multicast_netif_index(pcb: Pudp_pcb): Byte; inline;
begin
  Result := pcb^.mcast_ifindex;
end;

procedure udp_set_multicast_ttl(pcb: Pudp_pcb; value: Byte); inline;
begin
  pcb^.mcast_ttl := value;
end;

function udp_get_multicast_ttl(pcb: Pudp_pcb): Byte; inline;
begin
  Result := pcb^.mcast_ttl;
end;
{$ENDIF}

end.

