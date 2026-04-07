unit lwipopts;

{$mode objfpc}{$H+}

interface

uses
  lwip_arch;  // für esp_random, falls IP_NAPT

const
  LWIP_TESTMODE                   = 1;

  LWIP_IPV6                       = 1;

  LWIP_CHECKSUM_ON_COPY           = 1;
  TCP_CHECKSUM_ON_COPY_SANITY_CHECK = 1;

procedure TCP_CHECKSUM_ON_COPY_SANITY_CHECK_FAIL(const printfmsg: PChar);

const
  NO_SYS                          = 0;
  SYS_LIGHTWEIGHT_PROT            = 0;
  LWIP_NETCONN                    = not NO_SYS;
  LWIP_SOCKET                     = not NO_SYS;
  LWIP_NETCONN_FULLDUPLEX         = LWIP_SOCKET;
  LWIP_NETBUF_RECVINFO            = 1;
  LWIP_HAVE_LOOPIF                = 1;

  TCPIP_THREAD_TEST               = 1;

  LWIP_DHCP                       = 1;

  MEM_SIZE                        = 16000;
  TCP_SND_QUEUELEN                = 40;
  MEMP_NUM_TCP_SEG                = TCP_SND_QUEUELEN;
 const TCP_MSS = 536;
  TCP_SND_BUF                     = 12 * TCP_MSS;
  TCP_WND                         = 10 * TCP_MSS;
  LWIP_WND_SCALE                  = 1;
  TCP_RCV_SCALE                   = 0;
  PBUF_POOL_SIZE                  = 400;

  LWIP_IGMP                       = 1;
  LWIP_MDNS_RESPONDER             = 1;
  LWIP_NUM_NETIF_CLIENT_DATA      = LWIP_MDNS_RESPONDER;

  ETHARP_SUPPORT_STATIC_ENTRIES   = 1;
 LWIP_NUM_SYS_TIMEOUT_INTERNAL = 12;
  MEMP_NUM_SYS_TIMEOUT            = LWIP_NUM_SYS_TIMEOUT_INTERNAL + 8;

  MIB2_STATS                      = 1;

  LWIP_NETIF_EXT_STATUS_CALLBACK  = 1;

procedure LWIP_MEM_ILLEGAL_FREE(msg: PChar);

const
  SNTP_SERVER_DNS                 = 0;
  LWIP_COMPAT_SOCKET_INET         = 0;

  // ESP spezifische Konfiguration
  ESP_LWIP                        = 1;
  ESP_DHCP                        = 1;
  ESP_DHCPS_TIMER                  = 0;
  ESP_STATS_DROP                   = 0;
  ESP_PBUF                         = 1;
  ESP_IP4_ROUTE                    = 1;
  ESP_AUTO_IP                      = 1;
  ESP_IPV6                         = 1;
  ESP_SOCKET                       = 0;
  ESP_PPP                          = 1;
  ESP_LWIP_IGMP_TIMERS_ONDEMAND    = 1;
  ESP_LWIP_MLD6_TIMERS_ONDEMAND    = 1;
  ESP_GRATUITOUS_ARP               = 1;
  ESP_LWIP_SELECT                  = 1;
  ESP_LWIP_LOCK                    = 1;

{$IFDEF IP_NAPT}
const
  IP_NAPT_MAX = 16;
{$UNDEF LWIP_RAND}
function LWIP_RAND: u32_t; inline;
begin
  Result := esp_random();
end;

function esp_random: u32_t; cdecl; external;
{$ENDIF}

{$IFDEF ESP_TEST_DEBUG}
const
  NAPT_DEBUG = LWIP_DBG_ON;
  IP_DEBUG   = LWIP_DBG_ON;
  UDP_DEBUG  = LWIP_DBG_ON;
  TCP_DEBUG  = LWIP_DBG_ON;
{$ENDIF}

implementation

procedure TCP_CHECKSUM_ON_COPY_SANITY_CHECK_FAIL(const printfmsg: PChar);
begin
  Assert(False, 'TCP_CHECKSUM_ON_COPY_SANITY_CHECK_FAIL');
end;

procedure LWIP_MEM_ILLEGAL_FREE(msg: PChar);
begin
  // do nothing
end;

end.
