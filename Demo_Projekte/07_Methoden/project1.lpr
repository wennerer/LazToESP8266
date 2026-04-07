program project1;

uses fmem,sysutils, portmacro, task, Laz_ESP ;

var
 i      : integer;
 buf    : array[0..15] of byte;
 str    : ansistring;
 s      : TString11;
 c      : TChrArray;
 P,P1,P2: PChar;
 xLastWakeTime: TTickType;

begin
 SerialBegin(9600);
 i:= 100;
 while  i < 500 do
  begin
   writeln(i);
   inc(i);
  end;

 CopyStrToBuffer('Hallo',@(buf[0]));
 writeln(PChar(@buf));

 str := 'Huhu'#0;
 CopyStrToBuffer(str,@(buf[0]));
 writeln(PChar(@buf));

 c := inttochar(540);
 writeln(PChar(@c));

 s := IntToString(-3099);
 writeln('String: ',s);

 s := IntToString(0);
 writeln('String: ',s);

 s := IntToString(987654321);
 writeln('String: ',s);

 s:= inttostr(378);
 writeln(s);

 i := Pos('Test','Das ist ein Test');
 writeln('Test an Position: ',i,' gefunden');

 P := 'Ich bin ein PChar';
 writeln(P);
 i := Pos('PChar',P);
 writeln('PChar an Position: ',i,' gefunden');

 P1 := 'Hallo';
 P2 := ' Welt';
 CopyStrToBuffer(P1,@(buf[0]));
 CopyStrToBuffer(P2,@(buf[5]));
 writeln(PChar(@buf));
 P := PChar(@buf);
 writeln(P);

 P1 := 'Hello';
 P2 := ' World';
 P := ConcatPChar250(P1,P2); //max. 250 Zeichen!
 writeln(P);

 xLastWakeTime := xTaskGetTickCount(); // aktuelle Zeit

 repeat

  writeln('In der Schleife');
  sleep(1000);
  // exakt 1000 ms Zyklus
  //vTaskDelayUntil(@xLastWakeTime, 1000 div portTICK_PERIOD_MS);

 until false;
end.

