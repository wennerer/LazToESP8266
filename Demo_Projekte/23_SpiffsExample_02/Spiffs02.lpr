program Spiffs02;

uses
  fmem,
  timers,
  projdefs,
  laz_esp,
  esp_spiffs,
  esp_fileIO;

var
 i           : Integer;
 TAG         : PChar = 'SpiffsExamle02';
 Path        : PChar = '/MyFolder';
 FilePath    : PChar = '/MyFolder/MyFile';
 aTimerHandle: TTimerHandle;
 temp1, temp2: PChar;


procedure TimerCallback(xTimerHandle: TTimerHandle);

begin
 if not FileExists(FilePath) then
  FileWrite(FilePath,'Das ist eine von mir erzeugte Datei')
 else
  begin
   inc(i);
   writeln('Eintrag: ',i,' wird geschrieben');
   temp1 := IntToPChar(i);
   temp2 := 'Dies ist Eintrag Nr.: ';
   FileAppend(FilePath,PChar(ConcatPChar(temp2,temp1)));

  end;
 if i mod 6 = 0 then
  begin
   if i <> 0 then writeln('Alle 60 Sekunden wird die Datei gelesen:');
   FileRead(FilePath);
  end;
end;

procedure Start_Timer(out xTimerHandle: TTimerHandle;Interval:LongInt);
begin
 XTimerHandle := xTimerCreate('Timer1', // Name des Timers
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
 if xTimerStart(xTimerHandle, 1000) <> pdPASS then
  writeln('The timer could not be started');
end;


begin
 SerialBegin(9600);
 //serielle Ausgabe etwas verzögern
 i := 50;
 repeat
  dec(i);
  writeln(i);
 until i = 0 ;

 RegisterSpiffs(5,Path,Tag);

 sleep(2000);//etwas warten bis spiffs registriert
 if FileDelete(FilePath) then writeln ('File deleted');
 Start_Timer(aTimerHandle,10000);

 repeat
  sleep(1000);
  writeln('Loop');
 until false ;
 UnRegisterSpiffs(Tag);
end.
