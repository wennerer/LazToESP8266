unit wificonnectsta;

{ This is a helper unit to either connect to an access point
  or to create a local access point.

  The global variable stationConnected is true when connected to an AP. }

{$include freertosconfig.inc}

interface

uses
  esp_err, esp_wifi, esp_wifi_types, esp_netif, esp_event, esp_event_base,
  {$ifdef CPULX6}
  esp_netif_types, esp_wifi_default, esp_bit_defs, esp_netif_ip_addr,
  {$else}
  nvs_flash, eagle_soc, tcpip_adapter, ip4_addr,
  {$endif}
  nvs, event_groups,
  esp_interface, projdefs,
  lwip_netif;

var
  stationConnected: boolean;

// NOTE: hostName is an optional name for this network interface.
// It should not exceed TCPIP_HOSTNAME_MAX_SIZE = 32 bytes

// Connect to an external access point using provided credetials
procedure connectWifiAP(const APName, APassword: shortstring; hostName: pchar = nil);



implementation

const
  WifiConnect    = BIT0;
  WifiFail       = BIT1;

var
  WifiEventGroup: TEventGroupHandle;
  {$ifdef CPULX6}
  netif_handle: Pesp_netif;
  {$endif}
  isNetifInit: boolean = false;
  isEventLoopCreated: boolean = false;

// Rather use StrPLCopy, but while sysutils are not yet working...
procedure CopyStringToBuffer(const s: shortstring; const buf: PChar);
var
  i: integer;
  pc: Pchar;
begin
  i := 1;
  pc := buf;
  while i <= length(s) do
  begin
    pc^ := s[i];
    inc(pc);
    inc(i);
  end;
end;

procedure EventHandler(Arg: pointer; AEventBase: Tesp_event_base;
                       AEventID: int32; AEventData: pointer);
var
  event: Pip_event_got_ip;
  addr: uint32;
begin
  if (AEventBase = WIFI_EVENT) then
  begin
    case Twifi_event(AEventID) of
      WIFI_EVENT_STA_START: esp_wifi_connect();

      WIFI_EVENT_STA_DISCONNECTED:
      begin
        stationConnected := false;
        esp_wifi_connect();
      end;

      else
        writeln('Received Wifi event: ', Twifi_event(AEventID));
    end;
  end
  else if (AEventBase = IP_EVENT) then
  begin
    case Tip_event(AEventID) of
      IP_EVENT_STA_GOT_IP:
      begin
        event := Pip_event_got_ip(AEventData);
        addr := event^.ip_info.ip.addr;
        writeln('Got ip: ',  addr and $FF, '.', (addr shr 8) and $FF, '.', (addr shr 16) and $FF, '.', addr shr 24);
        stationConnected := true;

        if assigned(WifiEventGroup) then
          xEventGroupSetBits(WifiEventGroup, WifiConnect);
      end;

      IP_EVENT_STA_LOST_IP: stationConnected := false;

      else
        writeln('Received IP event: ', Tip_event(AEventID));
    end;
  end
  else
    writeln('Received event base = ', AEventBase, 'event ID = ', AEventID);
end;

function initNVS: Tesp_err;
begin
  Result := nvs_flash_init();
  if (Result = ESP_ERR_NVS_NO_FREE_PAGES) {$ifdef CPULX6}or (Result = ESP_ERR_NVS_NEW_VERSION_FOUND){$endif} then
  begin
    writeln('nvs_flash_erase');
    EspErrorCheck(nvs_flash_erase(), 'nvs_flash_erase');
    writeln('nvs_flash_init()');
    Result := nvs_flash_init();
  end
  else if Result <> ESP_OK then
    writeln('NVS init error: ', Result);
end;

procedure connectWifiAP(const APName, APassword: shortstring; hostName: pchar);
var
  cfg: Twifi_init_config;
  wifi_config: Twifi_config;
  bits: TEventBits;

begin

  EspErrorCheck(initNVS, 'initNVS');

  stationConnected := false;
  WifiEventGroup := xEventGroupCreate();

  EspErrorCheck(esp_netif_init(), 'esp_netif_init'); //ruft tcpip_adapter_init(); auf!
  EspErrorCheck(esp_event_loop_create_default(), 'esp_event_loop_create_default');

  {$ifdef CPULX6}
  netif_handle := esp_netif_create_default_wifi_sta();
  {$endif}

  WIFI_INIT_CONFIG_DEFAULT(cfg);
  EspErrorCheck(esp_wifi_init(@cfg), 'esp_wifi_init');

  EspErrorCheck(esp_event_handler_register(WIFI_EVENT, ESP_EVENT_ANY_ID, Tesp_event_handler(@EventHandler), nil), 'esp_event_handler_register');
  EspErrorCheck(esp_event_handler_register(IP_EVENT, ord(IP_EVENT_STA_GOT_IP), Tesp_event_handler(@EventHandler), nil), 'esp_event_handler_register');

  EspErrorCheck(esp_wifi_set_mode(WIFI_MODE_STA), 'esp_wifi_set_mode');

  FillChar(wifi_config, sizeof(wifi_config), #0);
  // If no AP name is given, just start wifi
  // it should use previously saved credentials if available
  if APName <> '' then
  begin
    CopyStringToBuffer(APName, @(wifi_config.sta.ssid[0]));
    CopyStringToBuffer(APassword, @(wifi_config.sta.password[0]));
    EspErrorCheck(esp_wifi_set_config(ESP_IF_WIFI_STA, @wifi_config), 'esp_wifi_set_config');
  end;

  EspErrorCheck(esp_wifi_start(), 'esp_wifi_start');

  if hostName <> nil then
    {$ifdef CPULX6}
    EspErrorCheck(esp_netif_set_hostname(netif_handle, @hostName[0]), 'esp_netif_set_hostname');
    {$else}
    EspErrorCheck(tcpip_adapter_set_hostname(TCPIP_ADAPTER_IF_STA, @hostName[0]), 'tcpip_adapter_set_hostname');
    {$endif}



  EspErrorCheck(esp_wifi_connect(), 'esp_wifi_connect');

  // Wait until either WifiConnected or WifiFail bit gets set
  // by xEventGroupSetBits call in EventHandler_ESP32
  bits := xEventGroupWaitBits(WifiEventGroup,
          WifiConnect or WifiFail,
          pdFALSE,
          pdFALSE,
          10 * configTICK_RATE_HZ);  // timeout after 10 seconds

  if (bits and WifiConnect) = WifiConnect then
   begin
    writeln('Connected. Test connection by pinging the above IP address from the same network');

   (* esp_netif[0] := @sta_netif;
    netif := esp_netif[0];
    if netif <> nil then
     begin
      writeln('Netif-IP: ',netif^.ip_addr.addr);
      writeln('Netif-IP: ',netif^.gw.addr);
      writeln('Netif-IP: ',netif^.netmask.addr)
     end
    else writeln('Netif=NIL'); *)

   end
  else if (bits and WifiFail) = WifiFail then
    writeln('### Failed to connect')
  else
    writeln('Unexpected: timeout waiting for WifiEventGroup');
end;


end.
