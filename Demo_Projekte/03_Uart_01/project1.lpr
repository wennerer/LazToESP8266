program project1;
uses uart, esp_err;

procedure vTaskDelay(xTicksToDelay: uint32); external;

const
 UART_PORT: Tuart_port = UART_NUM_0;
 msg = 'UART test message'#13#10;

var
  uart_cfg: Tuart_config;

begin
 //mit den Libraries von fpcupdeluxe (9600*40) div 26 mit ccrause einfach 9600!
 uart_cfg.baud_rate  := 9600;//(9600*40) div 26;
 //uart_cfg.baud_rate  := (74880*40) div 26;
 //uart_cfg.baud_rate  := 115200;//(115200*40) div 26;

 uart_cfg.data_bits  := UART_DATA_8_BITS;
 uart_cfg.parity     := UART_PARITY_DISABLE;
 uart_cfg.stop_bits  := UART_STOP_BITS_1;
 uart_cfg.flow_ctrl  := UART_HW_FLOWCTRL_DISABLE;
 EspErrorCheck(uart_param_config(UART_PORT, @uart_cfg));
 EspErrorCheck(uart_driver_install(UART_PORT, 256, 0, 0, nil, 0));
 repeat
  writeln('Ich bin eine Ausgabe mit writeln!');
  uart_write_bytes(UART_PORT, @msg[1], length(msg));
  vTaskDelay(300);
 until false;
end.
