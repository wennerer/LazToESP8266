program adc01;

uses
  fmem,
  laz_esp,
  esp_log2,
  adc,
  task,
  wificonnect2,
  esp_err,
  sysutils;

{$Include PWD.inc}

const
 TAG : PChar = 'adc_example';

procedure adc_task(pvParameters: Pointer);
var Data: uint16;
begin
 while True do
  begin
   if adc_read(@Data) = ESP_OK then
    ESP_LOGI(Tag, '%s%d', ['adc read:',data]);

   sleep(1000);
  end;
end;

procedure app_main;
var
  adc_config : Tadc_config;
  err        : Tesp_err;
begin

  FillChar(adc_config, SizeOf(adc_config), 0);

  // Abhängig von menuconfig -> PHY -> vdd33_const
  // ADC_READ_TOUT_MODE misst die Spannung am externen ADC-Eingang TOUT
  // ADC_READ_VDD_MODE misst die interne Betriebsspannung des ESP8266 (VDD33)
  // ADC_READ_MAX_MODE kann nicht als Betriebsmodus verwendet werden,er dient nur als obere Grenze für Prüfungen
  adc_config.mode := ADC_READ_VDD_MODE;
  adc_config.clk_div := 8;


  err:= adc_init(@adc_config);
  ESP_LOGI(TAG,'%s%s',['Init Result: ',esp_err_to_name(err)]);

  xTaskCreate(
    @adc_task,
    'adc_task',
    4096,
    nil,
    5,
    nil
  );
end;

begin
 SerialBegin(9600);

 connectWifiAP(AP_NAME,PWD);
 repeat
  writeln('Start Wifi ...');
 until stationConnected = true;

 app_main;

 repeat
  sleep(100);
 until false ;
end.

