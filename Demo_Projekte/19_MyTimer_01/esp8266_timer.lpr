program esp8266_timer;

{$mode objfpc}{$H+}

uses
  fmem,
  timers,
  projdefs,
  laz_esp;

{$include freertosconfig.inc}
const
  TIMER_PERIOD = 3000; // ms also 3 Sekunden

var
  MyTimer: TTimerHandle;
  i      : integer;

procedure MyTimerCallback(xTimer: TTimerHandle);
begin
  inc(i);
  writeln('Der Timer wurde ' ,i,' mal ausgelöst!');
end;

procedure Start_Timer;
begin
  // Timer erstellen  MyTimer ist das Handle auf den Timer!
  MyTimer := xTimerCreate('MyTimer', // Name des Timers
                          pdMS_TO_TICKS(TIMER_PERIOD),// Periode in Ticks
                          pdTRUE,          // pdTRUE = wiederholend, pdFALSE = einmalig
                          nil,             // Timer-ID optional
                          @MyTimerCallback);//Callback-Funktion

  if MyTimer = nil then
  begin
    writeln('TIMER', 'Timer konnte nicht erstellt werden');
    Exit;
  end;

  // Timer starten
  if xTimerStart(MyTimer, 0) <> pdPASS then
    writeln('TIMER', 'Timer konnte nicht gestartet werden');
end;

procedure Stopp_Timer;
begin
 // Timer stoppen
 if xTimerStop(MyTimer, 0) <> pdPASS then
  writeln('Timer konnte nicht gestoppt werden')
 else
  begin
   writeln('Timer erfolgreich gestoppt');
   //Wenn der Timer einmalig ist, kann man ihn auch löschen, um Speicher freizugeben.
   xTimerDelete(MyTimer, 0);
  end;


end;

begin
  i := 0;
  SerialBegin(9600);
  Start_Timer;

 repeat
  sleep(100);
  if i = 10 then Stopp_Timer;
 until false ;
end.
