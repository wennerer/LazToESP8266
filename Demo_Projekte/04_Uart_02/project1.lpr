program project1;
uses uart, esp_err;

procedure vTaskDelay(xTicksToDelay: uint32); external;

const
 UART_PORT: Tuart_port = UART_NUM_0;



var
  uart_cfg: Tuart_config;
  config  : boolean;
  driver  : boolean;
  msg     : Char;
  read    : longint;



begin
 uart_cfg.baud_rate  := 9600;//(9600*40) div 26;
 uart_cfg.data_bits  := UART_DATA_8_BITS;
 uart_cfg.parity     := UART_PARITY_DISABLE;
 uart_cfg.stop_bits  := UART_STOP_BITS_1;
 uart_cfg.flow_ctrl  := UART_HW_FLOWCTRL_DISABLE;

 driver := false;
 config := false;

 config := EspErrorCheck(uart_param_config(UART_PORT, @uart_cfg)); //liefert true wenn okay
 driver := EspErrorCheck(uart_driver_install(UART_PORT, 256, 0, 0, nil, 0)); //liefert true wenn okay
 vTaskDelay(1000);
 if config then writeln('config= true') else writeln('config= false');
 if driver then writeln('driver= true') else writeln('driver= false');
 writeln('Please send any string. "A" leaves the loop');

 repeat
  while msg <> 'A' do
   begin
    read := uart_read_bytes(UART_PORT,@msg,length(msg),20);
    if read = -1 then writeln('read = Error');

    if length(msg) > 0 then write(msg);
    if msg = chr(0) then write(LineEnding);
   end;

   writeln('Empfangen');
   vTaskDelay(100);
 until false;
end.

