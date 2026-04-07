program project1;

uses
 fmem, laz_esp;



var

i    : integer;
f    : double;
str  : string;




begin
 serialbegin(9600);
 i:= 0;

 while i< 1000 do
  begin
   inc(i);
   writeln(i);
  end;

 while i > 500 do
  begin
   dec(i);
   writeln(i);
  end;

 repeat
  i := 5 * 4;
  writeln(i);

  i := 34 div 7;
  writeln(i);

  i := 12 mod 5;
  writeln(i);

  i := trunc(2.435);
  writeln(i);

  i := round(20/6);
  writeln(i);

  i := 7;
  i += 2;
  writeln(i);
  i -= 2;
  writeln(i);

  f := 20 / 6;
  writeln(f);
  writeln(f:2:2);
  writeln(f:3:3);

  f := frac(0.123);
  writeln(f:0:3);

  f := int(3.6789);
  writeln(f:2:2);

  str := 'Hallo';
  writeln(str);

  i := length(str);
  write(i,LineEnding);


  str := concat('Von ','Vorne');
  writeln(str);

  writeln('Das geht auch so: ',str,' Auch mit Zahlen: ',i);


  sleep(1000);
 until false ;
end.

