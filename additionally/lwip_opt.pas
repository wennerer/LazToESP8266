unit lwip_opt;

{$mode objfpc}{$H+}
{$MACRO ON}
interface

uses lwipopts;
// Include user-defined options first
//{$I lwipopts.h} 
//{$I lwip_debug.h} 
type
  size_t = NativeUInt;
// ----------------------------------------------------------------------------
// NO_SYS
// ----------------------------------------------------------------------------

{$IFNDEF NO_SYS}
const
  NO_SYS = 0;
{$ENDIF}

// ----------------------------------------------------------------------------
// Timers
// ----------------------------------------------------------------------------

{$IFNDEF LWIP_TIMERS}
{$IFDEF NO_SYS_NO_TIMERS}
const
  LWIP_TIMERS = (not NO_SYS) or (NO_SYS and not NO_SYS_NO_TIMERS);
{$ELSE}
const
  LWIP_TIMERS = 1;
{$ENDIF}
{$ENDIF}

{$IFNDEF LWIP_TIMERS_CUSTOM}
const
  LWIP_TIMERS_CUSTOM = 0;
{$ENDIF}

// ----------------------------------------------------------------------------
// memcpy
// ----------------------------------------------------------------------------

{$IFNDEF MEMCPY}
function MEMCPY(dst, src: Pointer; len: size_t): Pointer; cdecl; inline;
{$ENDIF}

{$IFNDEF SMEMCPY}
function SMEMCPY(dst, src: Pointer; len: size_t): Pointer; cdecl; inline;
{$ENDIF}

{$IFNDEF MEMMOVE}
function MEMMOVE(dst, src: Pointer; len: size_t): Pointer; cdecl; inline;
{$ENDIF}

// ----------------------------------------------------------------------------
// Core locking
// ----------------------------------------------------------------------------

{$IFNDEF LWIP_MPU_COMPATIBLE}
const
  LWIP_MPU_COMPATIBLE = 0;
{$ENDIF}

{$IFNDEF LWIP_TCPIP_CORE_LOCKING}
const
  LWIP_TCPIP_CORE_LOCKING = 1;
{$ENDIF}

{$IFNDEF LWIP_TCPIP_CORE_LOCKING_INPUT}
const
  LWIP_TCPIP_CORE_LOCKING_INPUT = 0;
{$ENDIF}

{$IFNDEF SYS_LIGHTWEIGHT_PROT}
const
  SYS_LIGHTWEIGHT_PROT = 1;
{$ENDIF}

{$IFNDEF LWIP_ASSERT_CORE_LOCKED}
procedure LWIP_ASSERT_CORE_LOCKED; inline;
(*begin
  // No-op
end;  *)
{$ENDIF}

{$IFNDEF LWIP_MARK_TCPIP_THREAD}
procedure LWIP_MARK_TCPIP_THREAD; inline;
(*begin
  // No-op
end; *)
{$ENDIF}

// ----------------------------------------------------------------------------
// Memory options
// ----------------------------------------------------------------------------

{$IFNDEF MEM_LIBC_MALLOC}
const
  MEM_LIBC_MALLOC = 0;
{$ENDIF}

{$IFNDEF MEMP_MEM_MALLOC}
const
  MEMP_MEM_MALLOC = 0;
{$ENDIF}

{$IFNDEF MEMP_MEM_INIT}
const
  MEMP_MEM_INIT = 0;
{$ENDIF}

{$IFNDEF MEM_ALIGNMENT}
const
  MEM_ALIGNMENT = 1;
{$ENDIF}

{$IFNDEF MEM_SIZE}
const
  MEM_SIZE = 1600;
{$ENDIF}

{$IFNDEF MEMP_OVERFLOW_CHECK}
const
  MEMP_OVERFLOW_CHECK = 0;
{$ENDIF}

{$IFNDEF MEMP_SANITY_CHECK}
const
  MEMP_SANITY_CHECK = 0;
{$ENDIF}

{$IFNDEF MEM_OVERFLOW_CHECK}
const
  MEM_OVERFLOW_CHECK = 0;
{$ENDIF}

{$IFNDEF MEM_SANITY_CHECK}
const
  MEM_SANITY_CHECK = 0;
{$ENDIF}

{$IFNDEF MEM_USE_POOLS}
const
  MEM_USE_POOLS = 0;
{$ENDIF}

{$IFNDEF MEM_USE_POOLS_TRY_BIGGER_POOL}
const
  MEM_USE_POOLS_TRY_BIGGER_POOL = 0;
{$ENDIF}

{$IFNDEF MEMP_USE_CUSTOM_POOLS}
const
  MEMP_USE_CUSTOM_POOLS = 0;
{$ENDIF}

{$IFNDEF LWIP_ALLOW_MEM_FREE_FROM_OTHER_CONTEXT}
const
  LWIP_ALLOW_MEM_FREE_FROM_OTHER_CONTEXT = 0;
{$ENDIF}

// ------------------------------------------------
// Internal Memory Pool Sizes
// ------------------------------------------------

{$IFNDEF MEMP_NUM_PBUF}
const
  MEMP_NUM_PBUF = 16;
{$ENDIF}

{$IFNDEF MEMP_NUM_RAW_PCB}
const
  MEMP_NUM_RAW_PCB = 4;
{$ENDIF}

{$IFNDEF MEMP_NUM_UDP_PCB}
const
  MEMP_NUM_UDP_PCB = 4;
{$ENDIF}

{$IFNDEF MEMP_NUM_TCP_PCB}
const
  MEMP_NUM_TCP_PCB = 5;
{$ENDIF}

{$IFNDEF MEMP_NUM_TCP_PCB_LISTEN}
const
  MEMP_NUM_TCP_PCB_LISTEN = 8;
{$ENDIF}

{$IFNDEF MEMP_NUM_TCP_SEG}
const
  MEMP_NUM_TCP_SEG = 16;
{$ENDIF}

{$IFNDEF MEMP_NUM_ALTCP_PCB}
const
  MEMP_NUM_ALTCP_PCB = MEMP_NUM_TCP_PCB;
{$ENDIF}

{$IFNDEF MEMP_NUM_REASSDATA}
const
  MEMP_NUM_REASSDATA = 5;
{$ENDIF}

{$IFNDEF MEMP_NUM_FRAG_PBUF}
const
  MEMP_NUM_FRAG_PBUF = 15;
{$ENDIF}

{$IFNDEF MEMP_NUM_ARP_QUEUE}
const
  MEMP_NUM_ARP_QUEUE = 30;
{$ENDIF}

{$IFNDEF MEMP_NUM_IGMP_GROUP}
const
  MEMP_NUM_IGMP_GROUP = 8;
{$ENDIF}



{$IFNDEF MEMP_NUM_NETBUF}
const
  MEMP_NUM_NETBUF = 2;
{$ENDIF}

{$IFNDEF MEMP_NUM_NETCONN}
const
  MEMP_NUM_NETCONN = 4;
{$ENDIF}

{$IFNDEF MEMP_NUM_SELECT_CB}
const
  MEMP_NUM_SELECT_CB = 4;
{$ENDIF}

{$IFNDEF MEMP_NUM_TCPIP_MSG_API}
const
  MEMP_NUM_TCPIP_MSG_API = 8;
{$ENDIF}

{$IFNDEF MEMP_NUM_TCPIP_MSG_INPKT}
const
  MEMP_NUM_TCPIP_MSG_INPKT = 8;
{$ENDIF}

{$IFNDEF MEMP_NUM_NETDB}
const
  MEMP_NUM_NETDB = 1;
{$ENDIF}

{$IFNDEF MEMP_NUM_LOCALHOSTLIST}
const
  MEMP_NUM_LOCALHOSTLIST = 1;
{$ENDIF}

{$IFNDEF PBUF_POOL_SIZE}
const
  PBUF_POOL_SIZE = 16;
{$ENDIF}

{$IFNDEF MEMP_NUM_API_MSG}
const
  MEMP_NUM_API_MSG = MEMP_NUM_TCPIP_MSG_API;
{$ENDIF}

{$IFNDEF MEMP_NUM_DNS_API_MSG}
const
  MEMP_NUM_DNS_API_MSG = MEMP_NUM_TCPIP_MSG_API;
{$ENDIF}

{$IFNDEF MEMP_NUM_SOCKET_SETGETSOCKOPT_DATA}
const
  MEMP_NUM_SOCKET_SETGETSOCKOPT_DATA = MEMP_NUM_TCPIP_MSG_API;
{$ENDIF}

{$IFNDEF MEMP_NUM_NETIFAPI_MSG}
const
  MEMP_NUM_NETIFAPI_MSG = MEMP_NUM_TCPIP_MSG_API;
{$ENDIF}

// ------------------------------------------------
// ARP options
// ------------------------------------------------

{$IFNDEF LWIP_ARP}
const
  LWIP_ARP = 1;
{$ENDIF}

{$IFNDEF ARP_TABLE_SIZE}
const
  ARP_TABLE_SIZE = 10;
{$ENDIF}

{$IFNDEF ARP_MAXAGE}
const
  ARP_MAXAGE = 300;
{$ENDIF}

{$IFNDEF ARP_QUEUEING}
const
  ARP_QUEUEING = 0;
{$ENDIF}

{$IFNDEF ARP_QUEUE_LEN}
const
  ARP_QUEUE_LEN = 3;
{$ENDIF}

{$IFNDEF ETHARP_SUPPORT_VLAN}
const
  ETHARP_SUPPORT_VLAN = 0;
{$ENDIF}

{$IFNDEF LWIP_ETHERNET}
const
  LWIP_ETHERNET = LWIP_ARP;
{$ENDIF}

{$IFNDEF ETH_PAD_SIZE}
const
  ETH_PAD_SIZE = 0;
{$ENDIF}

{$IFNDEF ETHARP_SUPPORT_STATIC_ENTRIES}
const
  ETHARP_SUPPORT_STATIC_ENTRIES = 0;
{$ENDIF}



{
  --------------------------------
  ---------- IP options ----------
  --------------------------------
}

{
  LWIP_IPV4==1: Enable IPv4
}
{$IFNDEF LWIP_IPV4}
  {$DEFINE LWIP_IPV4}
const LWIP_IPV4 = 1;
{$ENDIF}

{
  IP_FORWARD==1: Enables the ability to forward IP packets across network
  interfaces. If you are going to run lwIP on a device with only one network
  interface, define this to 0.
}
{$IFNDEF IP_FORWARD}
  {$DEFINE IP_FORWARD}
  const IP_FORWARD = 0;
{$ENDIF}

{
  IP_REASSEMBLY==1: Reassemble incoming fragmented IP packets.
}
{$IFNDEF IP_REASSEMBLY}
  {$DEFINE IP_REASSEMBLY}
  const IP_REASSEMBLY = 1;
{$ENDIF}

{
  IP_FRAG==1: Fragment outgoing IP packets if their size exceeds MTU.
}
{$IFNDEF IP_FRAG}
  {$DEFINE IP_FRAG}
  const IP_FRAG = 1;
{$ENDIF}

{$IFNDEF LWIP_IPV4}
  {$UNDEF IP_FORWARD}
  const IP_FORWARD = 0;
  {$UNDEF IP_REASSEMBLY}
  const IP_REASSEMBLY = 0;
  {$UNDEF IP_FRAG}
  const IP_FRAG = 0;
{$IFEND}

{
  IP_NAPT==1: Enables IPv4 Network Address and Port Translation
}
{$IFNDEF IP_NAPT}
  {$DEFINE IP_NAPT}
  const IP_NAPT = 0;
{$ENDIF}

{
  IP_OPTIONS_ALLOWED: Defines the behavior for IP options.
  0 = All packets with IP options are dropped.
  1 = IP options are allowed (but not parsed).
}
{$IFNDEF IP_OPTIONS_ALLOWED}
  {$DEFINE IP_OPTIONS_ALLOWED}
  const IP_OPTIONS_ALLOWED = 1;
{$ENDIF}

{
  IP_REASS_MAXAGE: Maximum time a fragmented IP packet waits for all fragments
}
{$IFNDEF IP_REASS_MAXAGE}
  {$DEFINE IP_REASS_MAXAGE}
  const IP_REASS_MAXAGE = 15;
{$ENDIF}

{
  IP_REASS_MAX_PBUFS: Total maximum amount of pbufs waiting to be reassembled
}
{$IFNDEF IP_REASS_MAX_PBUFS}
  {$DEFINE IP_REASS_MAX_PBUFS}
  const IP_REASS_MAX_PBUFS = 10;
{$ENDIF}

{
  IP_DEFAULT_TTL: Default value for Time-To-Live used by transport layers.
}
{$IFNDEF IP_DEFAULT_TTL}
  {$DEFINE IP_DEFAULT_TTL}
  const IP_DEFAULT_TTL = 255;
{$ENDIF}

{
  IP_SOF_BROADCAST=1: Use the SOF_BROADCAST field to enable broadcast filter
}
{$IFNDEF IP_SOF_BROADCAST}
  {$DEFINE IP_SOF_BROADCAST}
  const IP_SOF_BROADCAST = 0;
{$ENDIF}

{
  IP_SOF_BROADCAST_RECV: enable the broadcast filter on recv operations.
}
{$IFNDEF IP_SOF_BROADCAST_RECV}
  {$DEFINE IP_SOF_BROADCAST_RECV}
  const IP_SOF_BROADCAST_RECV = 0;
{$ENDIF}

{
  IP_FORWARD_ALLOW_TX_ON_RX_NETIF==1: allow ip_forward() to send packets back
}
{$IFNDEF IP_FORWARD_ALLOW_TX_ON_RX_NETIF}
  {$DEFINE IP_FORWARD_ALLOW_TX_ON_RX_NETIF}
  const IP_FORWARD_ALLOW_TX_ON_RX_NETIF = 0;
{$ENDIF}

{
  ----------------------------------
  ---------- ICMP options ----------
  ----------------------------------
}

{$IFNDEF LWIP_ICMP}
  {$DEFINE LWIP_ICMP}
  const LWIP_ICMP = 1;
{$ENDIF}

{$IFNDEF ICMP_TTL}
  {$DEFINE ICMP_TTL}
  const ICMP_TTL = IP_DEFAULT_TTL;
{$ENDIF}

{$IFNDEF LWIP_BROADCAST_PING}
  {$DEFINE LWIP_BROADCAST_PING}
  const LWIP_BROADCAST_PING = 0;
{$ENDIF}

{$IFNDEF LWIP_MULTICAST_PING}
  {$DEFINE LWIP_MULTICAST_PING}
  const LWIP_MULTICAST_PING = 0;
{$ENDIF}

{
  ---------------------------------
  ---------- RAW options ----------
  ---------------------------------
}

{$IFNDEF LWIP_RAW}
  {$DEFINE LWIP_RAW}
  const LWIP_RAW = 0;
{$ENDIF}

{$IFNDEF RAW_TTL}
  {$DEFINE RAW_TTL}
  const RAW_TTL = IP_DEFAULT_TTL;
{$ENDIF}

{
  ----------------------------------
  ---------- DHCP options ----------
  ----------------------------------
}

{$IFNDEF LWIP_DHCP}
  {$DEFINE LWIP_DHCP}
  const LWIP_DHCP = 0;
{$ENDIF}

  {$IFNDEF LWIP_IPV4}
  {$UNDEF LWIP_DHCP}
  const LWIP_DHCP = 0;
{$IFEND}

{$IFNDEF DHCP_DOES_ARP_CHECK}
  {$DEFINE DHCP_DOES_ARP_CHECK}
  const DHCP_DOES_ARP_CHECK = (LWIP_DHCP and LWIP_ARP);
{$ENDIF}

{$IFNDEF LWIP_DHCP_BOOTP_FILE}
  {$DEFINE LWIP_DHCP_BOOTP_FILE}
  const LWIP_DHCP_BOOTP_FILE = 0;
{$ENDIF}

{$IFNDEF LWIP_DHCP_GET_NTP_SRV}
  {$DEFINE LWIP_DHCP_GET_NTP_SRV}
  const LWIP_DHCP_GET_NTP_SRV = 0;
{$ENDIF}

{$IFNDEF LWIP_DHCP_MAX_NTP_SERVERS}
  {$DEFINE LWIP_DHCP_MAX_NTP_SERVERS}
  const LWIP_DHCP_MAX_NTP_SERVERS = 1;
{$ENDIF}

  {$IFNDEF DNS_MAX_SERVERS}
      {$DEFINE DNS_MAX_SERVERS}
      const DNS_MAX_SERVERS = 2;
    {$ENDIF}

{$IFNDEF LWIP_DHCP_MAX_DNS_SERVERS}
  {$DEFINE LWIP_DHCP_MAX_DNS_SERVERS}
  const LWIP_DHCP_MAX_DNS_SERVERS = DNS_MAX_SERVERS;
{$ENDIF}

  {
    ------------------------------------
    ---------- AUTOIP options ----------
    ------------------------------------
  }

  {$IFNDEF LWIP_AUTOIP}
    {$DEFINE LWIP_AUTOIP}
    const LWIP_AUTOIP = 0;
  {$ENDIF}

  {$IFNDEF LWIP_IPV4}
    {$UNDEF LWIP_AUTOIP}
    const LWIP_AUTOIP = 0;
  {$IFEND}

  {$IFNDEF LWIP_DHCP_AUTOIP_COOP}
    {$DEFINE LWIP_DHCP_AUTOIP_COOP}
    const LWIP_DHCP_AUTOIP_COOP = 0;
  {$ENDIF}

  {$IFNDEF ESP_IPV6_AUTOCONFIG}
    {$DEFINE ESP_IPV6_AUTOCONFIG}
    const ESP_IPV6_AUTOCONFIG = 0;
  {$ENDIF}

  {$IFNDEF LWIP_DHCP_AUTOIP_COOP_TRIES}
    {$DEFINE LWIP_DHCP_AUTOIP_COOP_TRIES}
    const LWIP_DHCP_AUTOIP_COOP_TRIES = 9;
  {$ENDIF}

  {
    ----------------------------------
    ----- SNMP MIB2 support      -----
    ----------------------------------
  }

  {$IFNDEF LWIP_MIB2_CALLBACKS}
    {$DEFINE LWIP_MIB2_CALLBACKS}
    const LWIP_MIB2_CALLBACKS = 0;
  {$ENDIF}

    {
        ----------------------------------
        ---------- IGMP options ----------
        ----------------------------------
      }

      {$IFNDEF LWIP_IGMP}
        {$DEFINE LWIP_IGMP}
        const LWIP_IGMP = 0;
      {$ENDIF}

      {$IFNDEF LWIP_IPV4}
        {$UNDEF LWIP_IGMP}
        const LWIP_IGMP = 0;
      {$IFEND}

        {$IFNDEF LWIP_IPV6}
         {$DEFINE LWIP_IPV6}
                const LWIP_IPV6 = 0;
              {$ENDIF}

        {
                ---------- MLD6 options ----------
              }

              {$IFNDEF LWIP_IPV6_MLD}
                const LWIP_IPV6_MLD = LWIP_IPV6;
              {$ENDIF}

              {$IFNDEF MEMP_NUM_MLD6_GROUP}
                const MEMP_NUM_MLD6_GROUP = 4;
              {$ENDIF}

                {$IFNDEF LWIP_UDP}
                   {$DEFINE LWIP_UDP}
                   const LWIP_UDP = 1;
                 {$ENDIF}


  {
    ----------------------------------
    -------- Multicast options -------
    ----------------------------------
  }

  {$IFNDEF LWIP_MULTICAST_TX_OPTIONS}
    {$DEFINE LWIP_MULTICAST_TX_OPTIONS}
    const LWIP_MULTICAST_TX_OPTIONS = ((LWIP_IGMP <> 0) or (LWIP_IPV6_MLD <> 0)) and ((LWIP_UDP <> 0) or (LWIP_RAW <> 0));
  {$ENDIF}



  {
    ----------------------------------
    ---------- DNS options -----------
    ----------------------------------
  }

  {$IFNDEF LWIP_DNS}
    {$DEFINE LWIP_DNS}
    const LWIP_DNS = 0;
  {$ENDIF}

  {$IFNDEF DNS_TABLE_SIZE}
    {$DEFINE DNS_TABLE_SIZE}
    const DNS_TABLE_SIZE = 4;
  {$ENDIF}

  {$IFNDEF DNS_MAX_NAME_LENGTH}
    {$DEFINE DNS_MAX_NAME_LENGTH}
    const DNS_MAX_NAME_LENGTH = 256;
  {$ENDIF}



  {$IFNDEF DNS_MAX_RETRIES}
    {$DEFINE DNS_MAX_RETRIES}
    const DNS_MAX_RETRIES = 4;
  {$ENDIF}

  {$IFNDEF DNS_DOES_NAME_CHECK}
    {$DEFINE DNS_DOES_NAME_CHECK}
    const DNS_DOES_NAME_CHECK = 1;
  {$ENDIF}

    const
       LWIP_DNS_SECURE_RAND_XID = 1;
       LWIP_DNS_SECURE_NO_MULTIPLE_OUTSTANDING = 2;
       LWIP_DNS_SECURE_RAND_SRC_PORT = 4;

  {$IFNDEF LWIP_DNS_SECURE}
    {$DEFINE LWIP_DNS_SECURE}
    const LWIP_DNS_SECURE = (LWIP_DNS_SECURE_RAND_XID or LWIP_DNS_SECURE_NO_MULTIPLE_OUTSTANDING or LWIP_DNS_SECURE_RAND_SRC_PORT);
  {$ENDIF}



  {$IFNDEF DNS_LOCAL_HOSTLIST}
    {$DEFINE DNS_LOCAL_HOSTLIST}
    const DNS_LOCAL_HOSTLIST = 0;
  {$ENDIF}

  {$IFNDEF DNS_LOCAL_HOSTLIST_IS_DYNAMIC}
    {$DEFINE DNS_LOCAL_HOSTLIST_IS_DYNAMIC}
    const DNS_LOCAL_HOSTLIST_IS_DYNAMIC = 0;
  {$ENDIF}

  {$IFNDEF LWIP_DNS_SUPPORT_MDNS_QUERIES}
    {$DEFINE LWIP_DNS_SUPPORT_MDNS_QUERIES}
    const LWIP_DNS_SUPPORT_MDNS_QUERIES = 0;
  {$ENDIF}

  {
    ---------------------------------
    ---------- UDP options ----------
    ---------------------------------
  }



  {$IFNDEF LWIP_UDPLITE}
    {$DEFINE LWIP_UDPLITE}
    const LWIP_UDPLITE = 0;
  {$ENDIF}

  {$IFNDEF UDP_TTL}
    {$DEFINE UDP_TTL}
    const UDP_TTL = IP_DEFAULT_TTL;
  {$ENDIF}

  {$IFNDEF LWIP_NETBUF_RECVINFO}
    {$DEFINE LWIP_NETBUF_RECVINFO}
    const LWIP_NETBUF_RECVINFO = 0;
  {$ENDIF}

  {
    ---------------------------------
    ---------- TCP options ----------
    ---------------------------------
  }

  {$IFNDEF LWIP_TCP}
    {$DEFINE LWIP_TCP}
    const LWIP_TCP = 1;
  {$ENDIF}

  {$IFNDEF TCP_TTL}
    {$DEFINE TCP_TTL}
    const TCP_TTL = IP_DEFAULT_TTL;
  {$ENDIF}

       {$IFNDEF TCP_MSS}
           {$DEFINE TCP_MSS}
           const TCP_MSS = 536;
         {$ENDIF}


  {$IFNDEF TCP_WND}
    {$DEFINE TCP_WND}
    const TCP_WND = (4 * TCP_MSS);
  {$ENDIF}

  {$IFNDEF TCP_MAXRTX}
    {$DEFINE TCP_MAXRTX}
    const TCP_MAXRTX = 12;
  {$ENDIF}

  {$IFNDEF TCP_SYNMAXRTX}
    {$DEFINE TCP_SYNMAXRTX}
    const TCP_SYNMAXRTX = 6;
  {$ENDIF}

  {$IFNDEF TCP_QUEUE_OOSEQ}
    {$DEFINE TCP_QUEUE_OOSEQ}
    const TCP_QUEUE_OOSEQ = LWIP_TCP;
  {$ENDIF}

  {$IFNDEF LWIP_TCP_SACK_OUT}
    {$DEFINE LWIP_TCP_SACK_OUT}
    const LWIP_TCP_SACK_OUT = 0;
  {$ENDIF}

  {$IFNDEF LWIP_TCP_MAX_SACK_NUM}
    {$DEFINE LWIP_TCP_MAX_SACK_NUM}
    const LWIP_TCP_MAX_SACK_NUM = 4;
  {$ENDIF}



  {$IFNDEF TCP_CALCULATE_EFF_SEND_MSS}
    {$DEFINE TCP_CALCULATE_EFF_SEND_MSS}
    const TCP_CALCULATE_EFF_SEND_MSS = 1;
  {$ENDIF}

  {$IFNDEF TCP_SND_BUF}
    {$DEFINE TCP_SND_BUF}
    const TCP_SND_BUF = (2 * TCP_MSS);
  {$ENDIF}

  {$IFNDEF TCP_SND_QUEUELEN}
    {$DEFINE TCP_SND_QUEUELEN}
    const TCP_SND_QUEUELEN = ((4 * TCP_SND_BUF + (TCP_MSS - 1)) div TCP_MSS);
  {$ENDIF}


       {$IFNDEF TCP_SNDLOWAT}
       {$DEFINE TCP_SNDLOWAT := Min(Max((TCP_SND_BUF div 2), (2 * TCP_MSS) + 1), TCP_SND_BUF - 1)}
       {$ENDIF}


  {$IFNDEF TCP_SNDQUEUELOWAT}
  {$DEFINE TCP_SNDQUEUELOWAT := LWIP_MAX((TCP_SND_QUEUELEN div 2), 5)}
{$ENDIF}

  {$IFNDEF TCP_OOSEQ_MAX_BYTES}
    {$DEFINE TCP_OOSEQ_MAX_BYTES}
    const TCP_OOSEQ_MAX_BYTES = 0;
  {$ENDIF}

  {$IFNDEF TCP_OOSEQ_MAX_PBUFS}
    {$DEFINE TCP_OOSEQ_MAX_PBUFS}
    const TCP_OOSEQ_MAX_PBUFS = 0;
  {$ENDIF}

  {$IFNDEF TCP_LISTEN_BACKLOG}
    {$DEFINE TCP_LISTEN_BACKLOG}
    const TCP_LISTEN_BACKLOG = 0;
  {$ENDIF}

  {$IFNDEF TCP_DEFAULT_LISTEN_BACKLOG}
    {$DEFINE TCP_DEFAULT_LISTEN_BACKLOG}
    const TCP_DEFAULT_LISTEN_BACKLOG = $FF;
  {$ENDIF}

  {$IFNDEF TCP_OVERSIZE}
    {$DEFINE TCP_OVERSIZE}
    const TCP_OVERSIZE = TCP_MSS;
  {$ENDIF}

  {$IFNDEF LWIP_TCP_TIMESTAMPS}
    {$DEFINE LWIP_TCP_TIMESTAMPS}
    const LWIP_TCP_TIMESTAMPS = 0;
  {$ENDIF}

 {$IFNDEF TCP_WND_UPDATE_THRESHOLD}
{$DEFINE TCP_WND_UPDATE_THRESHOLD := Min(TCP_WND div 4, TCP_MSS * 4)}
{$ENDIF}

  {$IFNDEF LWIP_EVENT_API}
    {$DEFINE LWIP_EVENT_API}
    const LWIP_EVENT_API = 0;
  {$ENDIF}

  {$IFNDEF LWIP_CALLBACK_API}
    {$DEFINE LWIP_CALLBACK_API}
    const LWIP_CALLBACK_API = 1;
  {$ENDIF}

  {$IFNDEF LWIP_WND_SCALE}
    {$DEFINE LWIP_WND_SCALE}
    const LWIP_WND_SCALE = 0;
    const TCP_RCV_SCALE = 0;
  {$ENDIF}

  {$IFNDEF LWIP_TCP_PCB_NUM_EXT_ARGS}
    {$DEFINE LWIP_TCP_PCB_NUM_EXT_ARGS}
    const LWIP_TCP_PCB_NUM_EXT_ARGS = 0;
  {$ENDIF}

  {$IFNDEF LWIP_ALTCP}
    {$DEFINE LWIP_ALTCP}
    const LWIP_ALTCP = 0;
  {$ENDIF}

  {$IFNDEF LWIP_ALTCP_TLS}
    {$DEFINE LWIP_ALTCP_TLS}
    const LWIP_ALTCP_TLS = 0;
  {$ENDIF}

  {$IFDEF ESP_LWIP}
    {$IFNDEF LWIP_TCP_RTO_TIME}
      {$DEFINE LWIP_TCP_RTO_TIME}
      const LWIP_TCP_RTO_TIME = 3000;
    {$ENDIF}
  {$ENDIF}

  {
    ----------------------------------
    ---------- Pbuf options ----------
    ----------------------------------
  }

  {$IFNDEF PBUF_LINK_HLEN}
    {$IFDEF LWIP_HOOK_VLAN_SET}
      const PBUF_LINK_HLEN = 18 + ETH_PAD_SIZE;
    {$ELSE}
      const PBUF_LINK_HLEN = 14 + ETH_PAD_SIZE;
    {$ENDIF}
  {$ENDIF}

  {$IFNDEF PBUF_LINK_ENCAPSULATION_HLEN}
    const PBUF_LINK_ENCAPSULATION_HLEN = 0;
  {$ENDIF}

 {$IFNDEF PBUF_POOL_BUFSIZE}
  {$DEFINE PBUF_POOL_BUFSIZE := LWIP_MEM_ALIGN_SIZE(TCP_MSS + 40 + PBUF_LINK_ENCAPSULATION_HLEN + PBUF_LINK_HLEN)}
{$ENDIF}

    type
      u8_t = Byte;
  {$IFNDEF LWIP_PBUF_REF_T}
    type LWIP_PBUF_REF_T = u8_t;
  {$ENDIF}

  {$IFNDEF LWIP_PBUF_CUSTOM_DATA}
    {$DEFINE LWIP_PBUF_CUSTOM_DATA} // Marker, Pascal unterstützt keine leeren Makros, evtl. als Kommentar
  {$ENDIF}

  {
    ------------------------------------------------
    ---------- Network Interfaces options ----------
    ------------------------------------------------
  }

  {$IFNDEF LWIP_SINGLE_NETIF}
    const LWIP_SINGLE_NETIF = 0;
  {$ENDIF}


      {$IFNDEF ETHARP_TABLE_MATCH_NETIF}
      const
        ETHARP_TABLE_MATCH_NETIF = not LWIP_SINGLE_NETIF;
      {$ENDIF}

  {$IFNDEF LWIP_NETIF_HOSTNAME}
    const LWIP_NETIF_HOSTNAME = 0;
  {$ENDIF}

  {$IFNDEF LWIP_NETIF_API}
    const LWIP_NETIF_API = 0;
  {$ENDIF}

  {$IFNDEF LWIP_NETIF_STATUS_CALLBACK}
    const LWIP_NETIF_STATUS_CALLBACK = 0;
  {$ENDIF}

  {$IFNDEF LWIP_NETIF_EXT_STATUS_CALLBACK}
    const LWIP_NETIF_EXT_STATUS_CALLBACK = 0;
  {$ENDIF}

  {$IFNDEF LWIP_NETIF_LINK_CALLBACK}
    const LWIP_NETIF_LINK_CALLBACK = 0;
  {$ENDIF}

  {$IFNDEF LWIP_NETIF_REMOVE_CALLBACK}
    const LWIP_NETIF_REMOVE_CALLBACK = 0;
  {$ENDIF}

  {$IFNDEF LWIP_NETIF_HWADDRHINT}
    const LWIP_NETIF_HWADDRHINT = 0;
  {$ENDIF}

  {$IFNDEF LWIP_NETIF_TX_SINGLE_PBUF}
    const LWIP_NETIF_TX_SINGLE_PBUF = 0;
  {$ENDIF}

  {$IFNDEF LWIP_NUM_NETIF_CLIENT_DATA}
    const LWIP_NUM_NETIF_CLIENT_DATA = 0;
  {$ENDIF}

  {
    ------------------------------------
    ---------- LOOPIF options ----------
    ------------------------------------
  }

      {$IFNDEF LWIP_NETIF_LOOPBACK}
          const LWIP_NETIF_LOOPBACK = 0;
        {$ENDIF}

  {$IFNDEF LWIP_HAVE_LOOPIF}
    const LWIP_HAVE_LOOPIF = (LWIP_NETIF_LOOPBACK and not LWIP_SINGLE_NETIF);
  {$ENDIF}

  {$IFNDEF LWIP_LOOPIF_MULTICAST}
    const LWIP_LOOPIF_MULTICAST = 0;
  {$ENDIF}



  {$IFNDEF LWIP_LOOPBACK_MAX_PBUFS}
    const LWIP_LOOPBACK_MAX_PBUFS = 0;
  {$ENDIF}

  {$IFNDEF LWIP_NETIF_LOOPBACK_MULTITHREADING}
    const LWIP_NETIF_LOOPBACK_MULTITHREADING = not NO_SYS;
  {$ENDIF}


  {
    ------------------------------------
    ---------- Thread options ----------
    ------------------------------------
  }

  {$IFNDEF TCPIP_THREAD_NAME}
    const TCPIP_THREAD_NAME = 'tcpip_thread';
  {$ENDIF}

  {$IFNDEF TCPIP_THREAD_STACKSIZE}
    const TCPIP_THREAD_STACKSIZE = 0;
  {$ENDIF}

  {$IFNDEF TCPIP_THREAD_PRIO}
    const TCPIP_THREAD_PRIO = 1;
  {$ENDIF}

  {$IFNDEF TCPIP_MBOX_SIZE}
    const TCPIP_MBOX_SIZE = 0;
  {$ENDIF}

      {$IFNDEF SLIPIF_THREAD_NAME}
        const SLIPIF_THREAD_NAME = 'slipif_loop';
      {$ENDIF}

      {$IFNDEF SLIPIF_THREAD_STACKSIZE}
        const SLIPIF_THREAD_STACKSIZE = 0;
      {$ENDIF}

      {$IFNDEF SLIPIF_THREAD_PRIO}
        const SLIPIF_THREAD_PRIO = 1;
      {$ENDIF}

      {$IFNDEF DEFAULT_THREAD_NAME}
        const DEFAULT_THREAD_NAME = 'lwIP';
      {$ENDIF}

      {$IFNDEF DEFAULT_THREAD_STACKSIZE}
        const DEFAULT_THREAD_STACKSIZE = 0;
      {$ENDIF}

      {$IFNDEF DEFAULT_THREAD_PRIO}
        const DEFAULT_THREAD_PRIO = 1;
      {$ENDIF}

      {$IFNDEF DEFAULT_RAW_RECVMBOX_SIZE}
        const DEFAULT_RAW_RECVMBOX_SIZE = 0;
      {$ENDIF}

      {$IFNDEF DEFAULT_UDP_RECVMBOX_SIZE}
        const DEFAULT_UDP_RECVMBOX_SIZE = 0;
      {$ENDIF}

      {$IFNDEF DEFAULT_TCP_RECVMBOX_SIZE}
        const DEFAULT_TCP_RECVMBOX_SIZE = 0;
      {$ENDIF}

      {$IFNDEF DEFAULT_ACCEPTMBOX_SIZE}
        const DEFAULT_ACCEPTMBOX_SIZE = 0;
      {$ENDIF}

      {
        ----------------------------------------------
        ---------- Sequential layer options ----------
        ----------------------------------------------
      }

      {$IFNDEF LWIP_NETCONN}
        const LWIP_NETCONN = 1;
      {$ENDIF}

      {$IFNDEF LWIP_TCPIP_TIMEOUT}
        const LWIP_TCPIP_TIMEOUT = 0;
      {$ENDIF}

      {$IFNDEF LWIP_NETCONN_SEM_PER_THREAD}
        const LWIP_NETCONN_SEM_PER_THREAD = 0;
      {$ENDIF}

      {$IFNDEF LWIP_NETCONN_FULLDUPLEX}
        const LWIP_NETCONN_FULLDUPLEX = 0;
      {$ENDIF}


      {
        ------------------------------------
        ---------- Socket options ----------
        ------------------------------------
      }

      {$IFNDEF LWIP_SOCKET}
        const LWIP_SOCKET = 1;
      {$ENDIF}

      {$IFNDEF LWIP_COMPAT_SOCKETS}
        const LWIP_COMPAT_SOCKETS = 1;
      {$ENDIF}

      {$IFNDEF LWIP_POSIX_SOCKETS_IO_NAMES}
        const LWIP_POSIX_SOCKETS_IO_NAMES = 1;
      {$ENDIF}

      {$IFNDEF LWIP_SOCKET_OFFSET}
        const LWIP_SOCKET_OFFSET = 0;
      {$ENDIF}

      {$IFNDEF LWIP_TCP_KEEPALIVE}
        const LWIP_TCP_KEEPALIVE = 0;
      {$ENDIF}

      {$IFNDEF LWIP_SO_SNDTIMEO}
        const LWIP_SO_SNDTIMEO = 0;
      {$ENDIF}

      {$IFNDEF LWIP_SO_RCVTIMEO}
        const LWIP_SO_RCVTIMEO = 0;
      {$ENDIF}

      {$IFNDEF LWIP_SO_SNDRCVTIMEO_NONSTANDARD}
        const LWIP_SO_SNDRCVTIMEO_NONSTANDARD = 0;
      {$ENDIF}

      {$IFNDEF LWIP_SO_RCVBUF}
        const LWIP_SO_RCVBUF = 0;
      {$ENDIF}

      {$IFNDEF LWIP_SO_LINGER}
        const LWIP_SO_LINGER = 0;
      {$ENDIF}

      {$IFNDEF RECV_BUFSIZE_DEFAULT}
        const RECV_BUFSIZE_DEFAULT = MaxInt;
      {$ENDIF}

      {$IFNDEF LWIP_TCP_CLOSE_TIMEOUT_MS_DEFAULT}
        const LWIP_TCP_CLOSE_TIMEOUT_MS_DEFAULT = 20000;
      {$ENDIF}

      {$IFNDEF SO_REUSE}
        const SO_REUSE = 0;
      {$ENDIF}

      {$IFNDEF SO_REUSE_RXTOALL}
        const SO_REUSE_RXTOALL = 0;
      {$ENDIF}

      {$IFNDEF LWIP_FIONREAD_LINUXMODE}
        const LWIP_FIONREAD_LINUXMODE = 0;
      {$ENDIF}

      {$IFNDEF LWIP_SOCKET_SELECT}
        const LWIP_SOCKET_SELECT = 1;
      {$ENDIF}

      {$IFNDEF LWIP_SOCKET_POLL}
        const LWIP_SOCKET_POLL = 1;
      {$ENDIF}


      {
        ----------------------------------------
        ---------- Statistics options ----------
        ----------------------------------------
      }

      {$IFNDEF LWIP_STATS}
        const LWIP_STATS = 1;
      {$ENDIF}

      {$IF LWIP_STATS}

        {$IFNDEF LWIP_STATS_DISPLAY}
          const LWIP_STATS_DISPLAY = 0;
        {$ENDIF}

        {$IFNDEF LINK_STATS}
          const LINK_STATS = 1;
        {$ENDIF}

        {$IFNDEF ETHARP_STATS}
          const ETHARP_STATS = LWIP_ARP;
        {$ENDIF}

        {$IFNDEF IP_STATS}
          const IP_STATS = 1;
        {$ENDIF}

        {$IFNDEF IPFRAG_STATS}
          const IPFRAG_STATS = (IP_REASSEMBLY or IP_FRAG);
        {$ENDIF}

        {$IFNDEF ICMP_STATS}
          const ICMP_STATS = 1;
        {$ENDIF}

        {$IFNDEF IGMP_STATS}
          const IGMP_STATS = LWIP_IGMP;
        {$ENDIF}

        {$IFNDEF UDP_STATS}
          const UDP_STATS = LWIP_UDP;
        {$ENDIF}

        {$IFNDEF TCP_STATS}
          const TCP_STATS = LWIP_TCP;
        {$ENDIF}

        {$IFNDEF MEM_STATS}
          const MEM_STATS = ((MEM_LIBC_MALLOC = 0) and (MEM_USE_POOLS = 0));
        {$ENDIF}

        {$IFNDEF MEMP_STATS}
          const MEMP_STATS = (MEMP_MEM_MALLOC = 0);
        {$ENDIF}

        {$IFNDEF SYS_STATS}
          const SYS_STATS = (NO_SYS = 0);
        {$ENDIF}

        {$IFNDEF IP6_STATS}
          const IP6_STATS = LWIP_IPV6;
        {$ENDIF}


            {
                  ---------- ICMPv6 options ----------
                }

                {$IFNDEF LWIP_ICMP6}
                  const LWIP_ICMP6 = LWIP_IPV6;
                {$ENDIF}

                {$IFNDEF LWIP_ICMP6_DATASIZE}
                  const LWIP_ICMP6_DATASIZE = 8;
                {$ENDIF}

                {$IFNDEF LWIP_ICMP6_HL}
                  const LWIP_ICMP6_HL = 255;
                {$ENDIF}

        {$IFNDEF ICMP6_STATS}
          const ICMP6_STATS = (LWIP_IPV6 and LWIP_ICMP6);
        {$ENDIF}

            {$IFNDEF LWIP_IPV6_FRAG}
                   const LWIP_IPV6_FRAG = 1;
                 {$ENDIF}

                     {$IFNDEF LWIP_IPV6_REASS}
                           const LWIP_IPV6_REASS = LWIP_IPV6;
                         {$ENDIF}

        {$IFNDEF IP6_FRAG_STATS}
          const IP6_FRAG_STATS = (LWIP_IPV6 and (LWIP_IPV6_FRAG or LWIP_IPV6_REASS));
        {$ENDIF}

        {$IFNDEF MLD6_STATS}
          const MLD6_STATS = (LWIP_IPV6 and LWIP_IPV6_MLD);
        {$ENDIF}

        {$IFNDEF ND6_STATS}
          const ND6_STATS = LWIP_IPV6;
        {$ENDIF}

        {$IFNDEF MIB2_STATS}
          const MIB2_STATS = 0;
        {$ENDIF}

      {$ELSE} // LWIP_STATS = 0

        const LINK_STATS = 0;
        const ETHARP_STATS = 0;
        const IP_STATS = 0;
        const IPFRAG_STATS = 0;
        const ICMP_STATS = 0;
        const IGMP_STATS = 0;
        const UDP_STATS = 0;
        const TCP_STATS = 0;
        const MEM_STATS = 0;
        const MEMP_STATS = 0;
        const SYS_STATS = 0;
        const LWIP_STATS_DISPLAY = 0;
        const IP6_STATS = 0;
        const ICMP6_STATS = 0;
        const IP6_FRAG_STATS = 0;
        const MLD6_STATS = 0;
        const ND6_STATS = 0;
        const MIB2_STATS = 0;

      {$ENDIF} // LWIP_STATS

      {
        --------------------------------------
        ---------- Checksum options ----------
        --------------------------------------
      }

      {$IFNDEF LWIP_CHECKSUM_CTRL_PER_NETIF}
        const LWIP_CHECKSUM_CTRL_PER_NETIF = 0;
      {$ENDIF}

      {$IFNDEF CHECKSUM_GEN_IP}
        const CHECKSUM_GEN_IP = 1;
      {$ENDIF}

      {$IFNDEF CHECKSUM_GEN_UDP}
        const CHECKSUM_GEN_UDP = 1;
      {$ENDIF}

      {$IFNDEF CHECKSUM_GEN_TCP}
        const CHECKSUM_GEN_TCP = 1;
      {$ENDIF}

      {$IFNDEF CHECKSUM_GEN_ICMP}
        const CHECKSUM_GEN_ICMP = 1;
      {$ENDIF}

      {$IFNDEF CHECKSUM_GEN_ICMP6}
        const CHECKSUM_GEN_ICMP6 = 1;
      {$ENDIF}

      {$IFNDEF CHECKSUM_CHECK_IP}
        const CHECKSUM_CHECK_IP = 1;
      {$ENDIF}

      {$IFNDEF CHECKSUM_CHECK_UDP}
        const CHECKSUM_CHECK_UDP = 1;
      {$ENDIF}

      {$IFNDEF CHECKSUM_CHECK_TCP}
        const CHECKSUM_CHECK_TCP = 1;
      {$ENDIF}

      {$IFNDEF CHECKSUM_CHECK_ICMP}
        const CHECKSUM_CHECK_ICMP = 1;
      {$ENDIF}

      {$IFNDEF CHECKSUM_CHECK_ICMP6}
        const CHECKSUM_CHECK_ICMP6 = 1;
      {$ENDIF}

      {$IFNDEF LWIP_CHECKSUM_ON_COPY}
        const LWIP_CHECKSUM_ON_COPY = 0;
      {$ENDIF}


      {
        ---------------------------------------
        ---------- IPv6 options ---------------
        ---------------------------------------
      }

      {$IFNDEF LWIP_IPV6}
        const LWIP_IPV6 = 0;
      {$ENDIF}

      {$IFNDEF IPV6_REASS_MAXAGE}
        const IPV6_REASS_MAXAGE = 60;
      {$ENDIF}

      {$IFNDEF LWIP_IPV6_SCOPES}
        const LWIP_IPV6_SCOPES = (LWIP_IPV6 and (not LWIP_SINGLE_NETIF));
      {$ENDIF}

      {$IFNDEF LWIP_IPV6_SCOPES_DEBUG}
        const LWIP_IPV6_SCOPES_DEBUG = 0;
      {$ENDIF}

      {$IFNDEF LWIP_IPV6_NUM_ADDRESSES}
        const LWIP_IPV6_NUM_ADDRESSES = 3;
      {$ENDIF}

      {$IFNDEF LWIP_IPV6_FORWARD}
        const LWIP_IPV6_FORWARD = 0;
      {$ENDIF}





      {$IFNDEF LWIP_IPV6_SEND_ROUTER_SOLICIT}
        const LWIP_IPV6_SEND_ROUTER_SOLICIT = 1;
      {$ENDIF}

      {$IFNDEF LWIP_IPV6_AUTOCONFIG}
        const LWIP_IPV6_AUTOCONFIG = LWIP_IPV6;
      {$ENDIF}

      {$IFNDEF LWIP_IPV6_ADDRESS_LIFETIMES}
        const LWIP_IPV6_ADDRESS_LIFETIMES = LWIP_IPV6_AUTOCONFIG;
      {$ENDIF}

      {$IFNDEF LWIP_IPV6_DUP_DETECT_ATTEMPTS}
        const LWIP_IPV6_DUP_DETECT_ATTEMPTS = 1;
      {$ENDIF}







      {
        ---------- Neighbor Discovery (ND6) ----------
      }

      {$IFNDEF LWIP_ND6_QUEUEING}
        const LWIP_ND6_QUEUEING = LWIP_IPV6;
      {$ENDIF}

      {$IFNDEF ESP_ND6_QUEUEING}
        const ESP_ND6_QUEUEING = LWIP_IPV6;
      {$ENDIF}

      {$IFNDEF MEMP_NUM_ND6_QUEUE}
        const MEMP_NUM_ND6_QUEUE = 20;
      {$ENDIF}

      {$IFNDEF LWIP_ND6_NUM_NEIGHBORS}
        const LWIP_ND6_NUM_NEIGHBORS = 10;
      {$ENDIF}

      {$IFNDEF LWIP_ND6_NUM_DESTINATIONS}
        const LWIP_ND6_NUM_DESTINATIONS = 10;
      {$ENDIF}

      {$IFNDEF LWIP_ND6_NUM_PREFIXES}
        const LWIP_ND6_NUM_PREFIXES = 5;
      {$ENDIF}

      {$IFNDEF LWIP_ND6_NUM_ROUTERS}
        const LWIP_ND6_NUM_ROUTERS = 3;
      {$ENDIF}

      {$IFNDEF LWIP_ND6_MAX_MULTICAST_SOLICIT}
        const LWIP_ND6_MAX_MULTICAST_SOLICIT = 3;
      {$ENDIF}

      {$IFNDEF LWIP_ND6_MAX_UNICAST_SOLICIT}
        const LWIP_ND6_MAX_UNICAST_SOLICIT = 3;
      {$ENDIF}

      {$IFNDEF LWIP_ND6_MAX_ANYCAST_DELAY_TIME}
        const LWIP_ND6_MAX_ANYCAST_DELAY_TIME = 1000;
      {$ENDIF}

      {$IFNDEF LWIP_ND6_MAX_NEIGHBOR_ADVERTISEMENT}
        const LWIP_ND6_MAX_NEIGHBOR_ADVERTISEMENT = 3;
      {$ENDIF}

      {$IFNDEF LWIP_ND6_REACHABLE_TIME}
        const LWIP_ND6_REACHABLE_TIME = 30000;
      {$ENDIF}

      {$IFNDEF LWIP_ND6_RETRANS_TIMER}
        const LWIP_ND6_RETRANS_TIMER = 1000;
      {$ENDIF}

      {$IFNDEF LWIP_ND6_DELAY_FIRST_PROBE_TIME}
        const LWIP_ND6_DELAY_FIRST_PROBE_TIME = 5000;
      {$ENDIF}

      {$IFNDEF LWIP_ND6_ALLOW_RA_UPDATES}
        const LWIP_ND6_ALLOW_RA_UPDATES = 1;
      {$ENDIF}

      {$IFNDEF LWIP_ND6_TCP_REACHABILITY_HINTS}
        const LWIP_ND6_TCP_REACHABILITY_HINTS = 1;
      {$ENDIF}

      {$IFNDEF LWIP_ND6_RDNSS_MAX_DNS_SERVERS}
        const LWIP_ND6_RDNSS_MAX_DNS_SERVERS = 0;
      {$ENDIF}


      {
        ---------- DHCPv6 options ----------
      }

      {$IFNDEF LWIP_IPV6_DHCP6}
        const LWIP_IPV6_DHCP6 = 0;
      {$ENDIF}

      {$IFNDEF LWIP_IPV6_DHCP6_STATEFUL}
        const LWIP_IPV6_DHCP6_STATEFUL = 0;
      {$ENDIF}

      {$IFNDEF LWIP_IPV6_DHCP6_STATELESS}
        const LWIP_IPV6_DHCP6_STATELESS = LWIP_IPV6_DHCP6;
      {$ENDIF}

      {$IFNDEF LWIP_DHCP6_GET_NTP_SRV}
        const LWIP_DHCP6_GET_NTP_SRV = 0;
      {$ENDIF}

      {$IFNDEF LWIP_DHCP6_MAX_NTP_SERVERS}
        const LWIP_DHCP6_MAX_NTP_SERVERS = 1;
      {$ENDIF}

      {$IFNDEF LWIP_DHCP6_MAX_DNS_SERVERS}
        const LWIP_DHCP6_MAX_DNS_SERVERS = DNS_MAX_SERVERS;
      {$ENDIF}

      {
         ---------------------------------------
         ---------- Hook options ---------------
         ---------------------------------------
      }

      {
        Hooks sind standardmäßig undefiniert. Definiere sie als Funktion, wenn du sie benötigst.
      }

      {$IFDEF DOXYGEN}
      { LWIP_HOOK_FILENAME: Benutzerdefinierte Datei, die in Dateien inkludiert wird, die Hooks bereitstellen. }
      const
        LWIP_HOOK_FILENAME = 'path/to/my/lwip_hooks.h';
      {$ENDIF}

      {
         ---------------------------------------
         ---------- Debugging options ----------
         ---------------------------------------
      }

       {$IFDEF DOXYGEN}
      { INET_DEBUG: Debugging in inet.c }
      {$ENDIF}

      {$IFNDEF INET_DEBUG}
      {$DEFINE INET_DEBUG := LWIP_DBG_OFF}
      {$ENDIF}

      {$IFDEF DOXYGEN}
      { LWIP_DBG_MIN_LEVEL: Mindest-Level für Debugmeldungen }
      {$ENDIF}
      {$IFNDEF LWIP_DBG_MIN_LEVEL}
      {$DEFINE  LWIP_DBG_MIN_LEVEL := LWIP_DBG_LEVEL_ALL}
      {$ENDIF}

      {$IFDEF DOXYGEN}
      { LWIP_DBG_TYPES_ON: Maske, um bestimmte Debugmeldungen global ein/auszuschalten }
      {$ENDIF}
      {$IFNDEF LWIP_DBG_TYPES_ON}
      {$DEFINE  LWIP_DBG_TYPES_ON := LWIP_DBG_ON}
      {$ENDIF}

      {$IFDEF DOXYGEN}
      { ETHARP_DEBUG: Debugging in etharp.c }
      {$ENDIF}
      {$IFNDEF ETHARP_DEBUG}
      {$DEFINE  ETHARP_DEBUG := LWIP_DBG_OFF}
      {$ENDIF}

      {$IFDEF DOXYGEN}
      { NETIF_DEBUG: Debugging in netif.c }
      {$ENDIF}
      {$IFNDEF NETIF_DEBUG}
      {$DEFINE  NETIF_DEBUG := LWIP_DBG_OFF}
      {$ENDIF}

      {$IFDEF DOXYGEN}
      { PBUF_DEBUG: Debugging in pbuf.c }
      {$ENDIF}
      {$IFNDEF PBUF_DEBUG}
      {$DEFINE  PBUF_DEBUG := LWIP_DBG_OFF}
      {$ENDIF}

      {$IFDEF DOXYGEN}
      { API_LIB_DEBUG: Debugging in api_lib.c }
      {$ENDIF}
      {$IFNDEF API_LIB_DEBUG}
      {$DEFINE  API_LIB_DEBUG := LWIP_DBG_OFF}
      {$ENDIF}

      {$IFDEF DOXYGEN}
      { API_MSG_DEBUG: Debugging in api_msg.c }
      {$ENDIF}
      {$IFNDEF API_MSG_DEBUG}
      {$DEFINE  API_MSG_DEBUG := LWIP_DBG_OFF}
      {$ENDIF}

      {$IFDEF DOXYGEN}
      { SOCKETS_DEBUG: Debugging in sockets.c }
      {$ENDIF}
      {$IFNDEF SOCKETS_DEBUG}
      {$DEFINE  SOCKETS_DEBUG := LWIP_DBG_OFF}
      {$ENDIF}

      {$IFDEF DOXYGEN}
      { ICMP_DEBUG: Debugging in icmp.c }
      {$ENDIF}
      {$IFNDEF ICMP_DEBUG}
      {$DEFINE  ICMP_DEBUG := LWIP_DBG_OFF}
      {$ENDIF}

      {$IFDEF DOXYGEN}
      { IGMP_DEBUG: Debugging in igmp.c }
      {$ENDIF}
      {$IFNDEF IGMP_DEBUG}
      {$DEFINE  IGMP_DEBUG := LWIP_DBG_OFF}
      {$ENDIF}



      {$IFDEF DOXYGEN}
      { IP_DEBUG: Debugging für IP }
      {$ENDIF}
      {$IFNDEF IP_DEBUG}
      {$DEFINE  IP_DEBUG := LWIP_DBG_OFF}
      {$ENDIF}

      {$IFDEF DOXYGEN}
      { IP_REASS_DEBUG: Debugging in ip_frag.c }
      {$ENDIF}
      {$IFNDEF IP_REASS_DEBUG}
      {$DEFINE  IP_REASS_DEBUG := LWIP_DBG_OFF}
      {$ENDIF}

      {$IFDEF DOXYGEN}
      { RAW_DEBUG: Debugging in raw.c }
      {$ENDIF}
      {$IFNDEF RAW_DEBUG}
      {$DEFINE  RAW_DEBUG := LWIP_DBG_OFF}
      {$ENDIF}

      {$IFDEF DOXYGEN}
      { MEM_DEBUG: Debugging in mem.c }
      {$ENDIF}
      {$IFNDEF MEM_DEBUG}
      {$DEFINE  MEM_DEBUG := LWIP_DBG_OFF}
      {$ENDIF}

      {$IFDEF DOXYGEN}
      { MEMP_DEBUG: Debugging in memp.c }
      {$ENDIF}
      {$IFNDEF MEMP_DEBUG}
      {$DEFINE  MEMP_DEBUG := LWIP_DBG_OFF}
      {$ENDIF}

      {$IFDEF DOXYGEN}
      { SYS_DEBUG: Debugging in sys.c }
      {$ENDIF}
      {$IFNDEF SYS_DEBUG}
      {$DEFINE  SYS_DEBUG := LWIP_DBG_OFF}
      {$ENDIF}

      {$IFDEF DOXYGEN}
      { TIMERS_DEBUG: Debugging in timers.c }
      {$ENDIF}
      {$IFNDEF TIMERS_DEBUG}
      {$DEFINE  TIMERS_DEBUG := LWIP_DBG_OFF}
      {$ENDIF}

      {$IFDEF DOXYGEN}
      { TCP_DEBUG: Debugging für TCP }
      {$ENDIF}
      {$IFNDEF TCP_DEBUG}
      {$DEFINE  TCP_DEBUG := LWIP_DBG_OFF}
      {$ENDIF}

      {$IFDEF DOXYGEN}
      { TCP_INPUT_DEBUG: Debugging in tcp_in.c }
      {$ENDIF}
      {$IFNDEF TCP_INPUT_DEBUG}
      {$DEFINE  TCP_INPUT_DEBUG := LWIP_DBG_OFF}
      {$ENDIF}

      {$IFDEF DOXYGEN}
      { TCP_FR_DEBUG: Debugging für fast retransmit }
      {$ENDIF}
      {$IFNDEF TCP_FR_DEBUG}
      {$DEFINE  TCP_FR_DEBUG := LWIP_DBG_OFF}
      {$ENDIF}

      {$IFDEF DOXYGEN}
      { TCP_RTO_DEBUG: Debugging für TCP retransmit timeout }
      {$ENDIF}
      {$IFNDEF TCP_RTO_DEBUG}
      {$DEFINE TCP_RTO_DEBUG := LWIP_DBG_OFF}
      {$ENDIF}

      {$IFDEF DOXYGEN}
      { TCP_CWND_DEBUG: Debugging für TCP congestion window }
      {$ENDIF}
      {$IFNDEF TCP_CWND_DEBUG}
      {$DEFINE TCP_CWND_DEBUG := LWIP_DBG_OFF}
      {$ENDIF}

      {$IFDEF DOXYGEN}
      { TCP_WND_DEBUG: Debugging in tcp_in.c für Window Updates }
      {$ENDIF}
      {$IFNDEF TCP_WND_DEBUG}
      {$DEFINE TCP_WND_DEBUG := LWIP_DBG_OFF}
      {$ENDIF}

      {$IFDEF DOXYGEN}
      { TCP_OUTPUT_DEBUG: Debugging in tcp_out.c }
      {$ENDIF}
      {$IFNDEF TCP_OUTPUT_DEBUG}
      {$DEFINE TCP_OUTPUT_DEBUG := LWIP_DBG_OFF}
      {$ENDIF}

      {$IFDEF DOXYGEN}
      { TCP_RST_DEBUG: Debugging für TCP RST Messages }
      {$ENDIF}
      {$IFNDEF TCP_RST_DEBUG}
      {$DEFINE TCP_RST_DEBUG := LWIP_DBG_OFF}
      {$ENDIF}

      {$IFDEF DOXYGEN}
      { TCP_QLEN_DEBUG: Debugging für TCP Queue Lengths }
      {$ENDIF}
      {$IFNDEF TCP_QLEN_DEBUG}
      {$DEFINE TCP_QLEN_DEBUG := LWIP_DBG_OFF}
      {$ENDIF}

      {$IFDEF DOXYGEN}
      { UDP_DEBUG: Debugging in UDP }
      {$ENDIF}
      {$IFNDEF UDP_DEBUG}
      {$DEFINE UDP_DEBUG := LWIP_DBG_OFF}
      {$ENDIF}

      {$IFDEF DOXYGEN}
      { TCPIP_DEBUG: Debugging in tcpip.c }
      {$ENDIF}
      {$IFNDEF TCPIP_DEBUG}
      {$DEFINE TCPIP_DEBUG := LWIP_DBG_OFF}
      {$ENDIF}

      {$IFDEF DOXYGEN}
      { SLIP_DEBUG: Debugging in slipif.c }
      {$ENDIF}
      {$IFNDEF SLIP_DEBUG}
      {$DEFINE SLIP_DEBUG := LWIP_DBG_OFF}
      {$ENDIF}

      {$IFDEF DOXYGEN}
      { DHCP_DEBUG: Debugging in dhcp.c }
      {$ENDIF}
      {$IFNDEF DHCP_DEBUG}
      {$DEFINE DHCP_DEBUG := LWIP_DBG_OFF}
      {$ENDIF}

      {$IFDEF DOXYGEN}
      { AUTOIP_DEBUG: Debugging in autoip.c }
      {$ENDIF}
      {$IFNDEF AUTOIP_DEBUG}
      {$DEFINE AUTOIP_DEBUG := LWIP_DBG_OFF}
      {$ENDIF}

      {$IFDEF DOXYGEN}
      { DNS_DEBUG: Debugging für DNS }
      {$ENDIF}
      {$IFNDEF DNS_DEBUG}
      {$DEFINE DNS_DEBUG := LWIP_DBG_OFF}
      {$ENDIF}

      {$IFDEF DOXYGEN}
      { IP6_DEBUG: Debugging für IPv6 }
      {$ENDIF}
      {$IFNDEF IP6_DEBUG}
      {$DEFINE IP6_DEBUG := LWIP_DBG_OFF}
      {$ENDIF}

      {$IFDEF DOXYGEN}
      { DHCP6_DEBUG: Debugging in dhcp6.c }
      {$ENDIF}
      {$IFNDEF DHCP6_DEBUG}
      {$DEFINE DHCP6_DEBUG := LWIP_DBG_OFF}
      {$ENDIF}

      {$IFNDEF LWIP_TESTMODE}
      const LWIP_TESTMODE = 0;
      {$ENDIF}

      {$IFNDEF NAPT_DEBUG}
      {$DEFINE NAPT_DEBUG := LWIP_DBG_OFF}
      {$ENDIF}

      {
         --------------------------------------------------
         ---------- Performance tracking options ----------
         --------------------------------------------------
      }

      {$IFDEF DOXYGEN}
      { LWIP_PERF: Aktiviert Performance-Messungen für lwIP }
      {$ENDIF}
      {$IFNDEF LWIP_PERF}
      const LWIP_PERF = 0;
      {$ENDIF}

      {$IFNDEF MEMP_NUM_SYS_TIMEOUT}
       //const MEMP_NUM_SYS_TIMEOUT = LWIP_NUM_SYS_TIMEOUT_INTERNAL;
       {$DEFINE MEMP_NUM_SYS_TIMEOUT := LWIP_NUM_SYS_TIMEOUT_INTERNAL}
      {$ENDIF}

// LWIP_NUM_SYS_TIMEOUT_INTERNAL calculation can be adapted depending on your platform
{$IFDEF ESP_LWIP}
const
  LWIP_NUM_SYS_TIMEOUT_INTERNAL = (LWIP_TCP + IP_REASSEMBLY + (LWIP_ARP + (ESP_GRATUITOUS_ARP <> 0)) +
    (2*LWIP_DHCP + (ESP_DHCPS_TIMER <> 0)) + LWIP_AUTOIP + LWIP_IGMP + LWIP_DNS + PPP_NUM_TIMEOUTS +
    (LWIP_IPV6 * (1 + LWIP_IPV6_REASS + LWIP_IPV6_MLD)));
{$ELSE}
(*const
  LWIP_NUM_SYS_TIMEOUT_INTERNAL = (LWIP_TCP + IP_REASSEMBLY + LWIP_ARP + (2*LWIP_DHCP) +
    LWIP_AUTOIP + LWIP_IGMP + LWIP_DNS + PPP_NUM_TIMEOUTS +
    (LWIP_IPV6 * (1 + LWIP_IPV6_REASS + LWIP_IPV6_MLD)));  *)
  {$DEFINE LWIP_NUM_SYS_TIMEOUT_INTERNAL := (LWIP_TCP + IP_REASSEMBLY + LWIP_ARP + (2*LWIP_DHCP) +
    LWIP_AUTOIP + LWIP_IGMP + LWIP_DNS + PPP_NUM_TIMEOUTS +
    (LWIP_IPV6 * (1 + LWIP_IPV6_REASS + LWIP_IPV6_MLD)))}
{$ENDIF}



implementation

{$IFNDEF LWIP_ASSERT_CORE_LOCKED}
procedure LWIP_ASSERT_CORE_LOCKED; inline;
begin
  // No-op
end;
{$ENDIF}

{$IFNDEF LWIP_MARK_TCPIP_THREAD}
procedure LWIP_MARK_TCPIP_THREAD; inline;
begin
  // No-op
end;
{$ENDIF}

{$IFNDEF MEMCPY}
  {$DEFINE MEMCPY}
function MEMCPY(dst, src: Pointer; len: size_t): Pointer; cdecl; inline;
begin
  Result := dst;
  Move(src^, dst^, len);
end;
{$ENDIF}

{$IFNDEF SMEMCPY}
  {$DEFINE SMEMCPY}
function SMEMCPY(dst, src: Pointer; len: size_t): Pointer; cdecl; inline;
begin
  Result := dst;
  Move(src^, dst^, len);
end;
{$ENDIF}

{$IFNDEF MEMMOVE}
  {$DEFINE MEMMOVE}
function MEMMOVE(dst, src: Pointer; len: size_t): Pointer; cdecl; inline;
begin
  Result := dst;
  Move(src^, dst^, len);
end;
{$ENDIF}

{$IFNDEF LWIP_DHCP_IP_ADDR_RESTORE}
  {$DEFINE LWIP_DHCP_IP_ADDR_RESTORE}
  function LWIP_DHCP_IP_ADDR_RESTORE: Integer;
  begin
    Result := 0;
  end;
{$ENDIF}

{$IFNDEF LWIP_DHCP_IP_ADDR_STORE}
  {$DEFINE LWIP_DHCP_IP_ADDR_STORE}
  procedure LWIP_DHCP_IP_ADDR_STORE;
  begin
    // no operation
  end;
{$ENDIF}

{$IFNDEF LWIP_DHCP_IP_ADDR_ERASE}
  {$DEFINE LWIP_DHCP_IP_ADDR_ERASE}
  procedure LWIP_DHCP_IP_ADDR_ERASE(esp_netif: Pointer);
  begin
    // no operation
  end;
{$ENDIF}



{$IFNDEF LWIP_TCPIP_THREAD_ALIVE}
  procedure LWIP_TCPIP_THREAD_ALIVE;
  begin
    // Platzhalter, macht standardmäßig nichts
  end;
{$ENDIF}


{$IFDEF DOXYGEN}
{ LWIP_HOOK_TCP_ISN:
  Hook zur Erzeugung der Initial Sequence Number (ISN) für neue TCP-Verbindungen.
  Signatur:
    function my_hook_tcp_isn(const local_ip: Pip_addr_t; local_port: Word; 
                             const remote_ip: Pip_addr_t; remote_port: Word): UInt32;
}
{$ENDIF}

{$IFDEF DOXYGEN}
{ LWIP_HOOK_TCP_INPACKET_PCB:
  Hook für eingehende Pakete vor Übergabe an das PCB.
  Signatur:
    function my_hook_tcp_inpkt(pcb: Ptcp_pcb; hdr: Ptcp_hdr; optlen, opt1len: Word; 
                               opt2: PByte; p: Ppbuf): err_t;
}
{$ENDIF}

{$IFDEF DOXYGEN}
{ LWIP_HOOK_TCP_OUT_TCPOPT_LENGTH:
  Hook zur Anpassung der Größe von TCP-Optionen.
  Signatur:
    function my_hook_tcp_out_tcpopt_length(const pcb: Ptcp_pcb; internal_len: Byte): Byte;
}
{$ENDIF}

{$IFDEF DOXYGEN}
{ LWIP_HOOK_TCP_OUT_ADD_TCPOPTS:
  Hook für das Hinzufügen benutzerdefinierter TCP-Optionen.
  Signatur:
    function my_hook_tcp_out_add_tcpopts(p: Ppbuf; hdr: Ptcp_hdr; const pcb: Ptcp_pcb; opts: PUInt32): PUInt32;
}
{$ENDIF}

{$IFDEF DOXYGEN}
{ LWIP_HOOK_IP4_INPUT:
  Hook, aufgerufen von ip_input() (IPv4).
  Signatur:
    function my_hook(pbuf: Ppbuf; input_netif: Pnetif): Integer;
}
{$ENDIF}

{$IFDEF DOXYGEN}
{ LWIP_HOOK_IP4_ROUTE:
  Hook, aufgerufen von ip_route() (IPv4).
  Signatur:
    function my_hook(const dest: Pip4_addr_t): Pnetif;
}
{$ENDIF}

{$IFDEF DOXYGEN}
{ LWIP_HOOK_IP4_ROUTE_SRC:
  Source-basiertes Routing für IPv4.
  Signatur:
    function my_hook(const src, dest: Pip4_addr_t): Pnetif;
}
{$ENDIF}

{$IFDEF DOXYGEN}
{ LWIP_HOOK_IP4_CANFORWARD:
  Prüft, ob ein IPv4-Paket weitergeleitet werden kann.
  Signatur:
    function my_hook(p: Ppbuf; dest: UInt32): Integer;
}
{$ENDIF}

{$IFDEF DOXYGEN}
{ LWIP_HOOK_ETHARP_GET_GW:
  Hook zur Gateway-Auswahl für etharp_output().
  Signatur:
    function my_hook(netif: Pnetif; const dest: Pip4_addr_t): Pip4_addr_t;
}
{$ENDIF}

{$IFDEF DOXYGEN}
{ LWIP_HOOK_IP6_INPUT:
  Hook für eingehende IPv6-Pakete.
  Signatur:
    function my_hook(pbuf: Ppbuf; input_netif: Pnetif): Integer;
}
{$ENDIF}

{$IFDEF DOXYGEN}
{ LWIP_HOOK_IP6_ROUTE:
  Hook für IPv6-Routing.
  Signatur:
    function my_hook(const src, dest: Pip6_addr_t): Pnetif;
}
{$ENDIF}

{$IFDEF DOXYGEN}
{ LWIP_HOOK_ND6_GET_GW:
  Hook zur Auswahl des nächsten IPv6-Hops.
  Signatur:
    function my_hook(netif: Pnetif; const dest: Pip6_addr_t): Pip6_addr_t;
}
{$ENDIF}

{$IFDEF DOXYGEN}
{ LWIP_HOOK_VLAN_CHECK:
  Hook für VLAN-Filterung.
  Signatur:
    function my_hook(netif: Pnetif; eth_hdr: Peth_hdr; vlan_hdr: Peth_vlan_hdr): Integer;
}
{$ENDIF}

{$IFDEF DOXYGEN}
{ LWIP_HOOK_VLAN_SET:
  Hook zur Setzung des prio_vid-Felds im VLAN-Header.
  Signatur:
    function my_hook(netif: Pnetif; p: Ppbuf; src, dst: Peth_addr; eth_type: Word): Integer;
}
{$ENDIF}

{$IFDEF DOXYGEN}
{ LWIP_HOOK_MEMP_AVAILABLE:
  Hook, aufgerufen wenn ein memp-Pool wieder Items hat.
  Signatur:
    procedure my_hook(memp_t_type: Integer);
}
{$ENDIF}

{$IFDEF DOXYGEN}
{ LWIP_HOOK_UNKNOWN_ETH_PROTOCOL:
  Hook für unbekannte Ethernet-Protokolle.
  Signatur:
    function my_hook(pbuf: Ppbuf; netif: Pnetif): err_t;
}
{$ENDIF}

{$IFDEF DOXYGEN}
{ LWIP_HOOK_DHCP_APPEND_OPTIONS:
  Hook, um DHCP-Optionen vor dem Senden anzuhängen.
  Signatur:
    procedure my_hook(netif: Pnetif; dhcp: Pdhcp; state: Byte; msg: Pdhcp_msg; msg_type: Byte; options_len_ptr: PWord);
}
{$ENDIF}

{$IFDEF DOXYGEN}
{ LWIP_HOOK_DHCP_PARSE_OPTION:
  Hook für empfangene DHCP-Optionen.
  Signatur:
    procedure my_hook(netif: Pnetif; dhcp: Pdhcp; state: Byte; msg: Pdhcp_msg;
                      msg_type, option, len: Byte; pbuf: Ppbuf; option_value_offset: Word);
}
{$ENDIF}

{$IFDEF DOXYGEN}
{ LWIP_HOOK_DHCP6_APPEND_OPTIONS:
  Hook für DHCPv6-Optionen vor dem Senden.
  Signatur:
    procedure my_hook(netif: Pnetif; dhcp6: Pdhcp6; state: Byte; msg: Pdhcp6_msg; 
                      msg_type: Byte; options_len_ptr: PWord; max_len: Word);
}
{$ENDIF}

{$IFDEF DOXYGEN}
{ LWIP_HOOK_SOCKETS_SETSOCKOPT:
  Hook für setsockopt().
  Signatur:
    function my_hook(s: Integer; sock: Plwip_sock; level, optname: Integer; 
                     const optval: Pointer; optlen: socklen_t; err: PInteger): Integer;
}
{$ENDIF}

{$IFDEF DOXYGEN}
{ LWIP_HOOK_SOCKETS_GETSOCKOPT:
  Hook für getsockopt().
  Signatur:
    function my_hook(s: Integer; sock: Plwip_sock; level, optname: Integer;
                     optval: Pointer; optlen: Psocklen_t; err: PInteger): Integer;
}
{$ENDIF}

{$IFDEF DOXYGEN}
{ LWIP_HOOK_NETCONN_EXTERNAL_RESOLVE:
  Hook für externe DNS-Auflösung im netconn API.
  Signatur:
    function my_hook(name: PAnsiChar; addr: Pip_addr_t; addrtype: Byte; err: Perr_t): Integer;
}
{$ENDIF}

end.
