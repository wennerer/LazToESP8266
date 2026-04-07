program project1;


uses
fmem,
laz_esp,
task,
portmacro,
wificonnect2,
time_server,
esp_sntp;

{$Include PWD.inc}

var
 s    : shortstring;
 Stat : Tsntp_sync_status;

begin
SerialBegin(9600);

connectWifiAP(AP_NAME, PWD);
//warten bis Wifi verbunden ist
repeat
 sleep(500);
 writeln('Wait for Wifi ......');
until stationConnected = true;

initTime;
//warten bis sntpCallback eintrifft
repeat
 sleep (100);
 Stat := sntp_get_sync_status;
until Stat = SNTP_SYNC_STATUS_COMPLETED;

repeat
 currentTimeAsString(s);
 writeln('Orginal: ',s);
 DateTimeAsString_de(s);
 writeln('Datum und Zeit: ',s);
 DateAsString_de(s);
 writeln('Datum: ',s);
 TimeAsString_de(s);
 writeln('Zeit: ',s);
 vTaskDelay(1000 div portTICK_PERIOD_MS);
until false ;

end.

