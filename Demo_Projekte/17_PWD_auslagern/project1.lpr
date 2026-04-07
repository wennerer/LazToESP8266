program project1;


uses
fmem,
laz_esp,
task,
portmacro,
wificonnect2;

{$Include PWD.inc}

begin
SerialBegin(9600);

connectWifiAP(AP_NAME, PWD);

repeat
 vTaskDelay(1000 div portTICK_PERIOD_MS);

until false ;

end.

