program project1;
uses uart, esp_err;

procedure vTaskDelay(xTicksToDelay: uint32); external;

const
 UART_PORT: Tuart_port = UART_NUM_0;
 aMsg     = 'Zähler auf 0 zurückgesetzt';
var
  uart_cfg: Tuart_config;
  str     : shortstring;
  i       : integer;
begin
 uart_cfg.baud_rate  := 9600;//(9600*40) div 26;
 uart_cfg.data_bits  := UART_DATA_8_BITS;
 uart_cfg.parity     := UART_PARITY_DISABLE;
 uart_cfg.stop_bits  := UART_STOP_BITS_1;
 uart_cfg.flow_ctrl  := UART_HW_FLOWCTRL_DISABLE;
 EspErrorCheck(uart_param_config(UART_PORT, @uart_cfg)); //liefert true wenn okay
 EspErrorCheck(uart_driver_install(UART_PORT, 256, 0, 0, nil, 0)); //liefert true wenn okay

 str := 'Durchlauf';
 i := 0;
 repeat
  writeln('Das ist der ',i,' ',str);
  i += 1;
  if i > 500 then
   begin
    i:= 0;
    uart_write_bytes(UART_PORT, @aMsg[1], length(aMsg));
   end;
 until false;
end.

