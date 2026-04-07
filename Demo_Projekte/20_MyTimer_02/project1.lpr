program project1;

uses
  fmem, timers, projdefs,
  laz_esp;

var
  FirstTimer  : TTimerHandle;
  SEcondTimer : TTimerHandle;

procedure TimerCallback(xTimerHandle: TTimerHandle);
begin
 if xTimerHandle = FirstTimer then
   writeln('Message from Firsttimer');
 if xTimerHandle = SecondTimer then
   writeln('Message from Secondtimer');
end;

procedure Start_Timer(out xTimerHandle: TTimerHandle;Interval:LongInt);
begin
 XTimerHandle := xTimerCreate('aTimer', // Name des Timers
                              pdMS_TO_TICKS(Interval),// Periode in Ticks
                              pdTRUE,          // pdTRUE = wiederholend, pdFALSE = einmalig
                              nil,             // Timer-ID optional
                              @TimerCallback);//Callback-Funktion

 if xTimerHandle = nil then
  begin
   writeln('The timer could not be created');
   Exit;
  end;

// Timer starten
 if xTimerStart(xTimerHandle, 0) <> pdPASS then
  writeln('The timer could not be started');
end;

begin
 SerialBegin(9600);
 Start_Timer(FirstTimer,1000);
 sleep(500);
 Start_Timer(SecondTimer,2000);

 repeat
  sleep(100);
 until false ;
end.
