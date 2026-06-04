unit Unit1;

{$mode objfpc}{$H+}

interface

uses
 StdCtrls,
 Forms, Dialogs,
 Classes, sysutils,
 blcksock;

type

  { TForm1 }

TForm1 = class(TForm)
 Button_ReadFile1: TButton;
 Edit1: TEdit;
 Memo1: TMemo;
 procedure Button_ReadFile1Click(Sender: TObject);
end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button_ReadFile1Click(Sender: TObject);
var
  Sock: TTCPBlockSocket;
  FS: TFileStream;
  Buffer: array[0..1023] of byte;
  Len: Integer;
begin
 memo1.Clear;

 if FileExists('download.txt') then
 begin
  if DeleteFile('download.txt') then
   Edit1.Text := 'Datei gelöscht'
  else
   Edit1.Text :=('Löschen fehlgeschlagen');
 end
 else EDit1.Text:= 'Datei nicht vorhanden';

 Sock := TTCPBlockSocket.Create;

 try
  Sock.RaiseExcept := False;      // Synapse soll keine Exceptions werfen
  Sock.ConnectionTimeout := 3000; // 3 Sekunden Timeout

  Sock.Connect('192.168.178.140', '5000');

// Verbindung prüfen
  if Sock.LastError <> 0 then
   begin
    ShowMessage('Keine Verbindung möglich: ' + Sock.LastErrorDesc);
    Exit;
   end;

//Anfrage an den ESP senden
  Sock.SendString('SEND'#13#10);

  FS := TFileStream.Create('download.txt', fmCreate);

try
 repeat
  Len := Sock.RecvBuffer(@Buffer, SizeOf(Buffer));

// Abbruch wenn Fehler oder Verbindung geschlossen
  if (Len <= 0) or (Sock.LastError <> 0) then
   Break;
   FS.Write(Buffer, Len);
  until False;
  finally
   FS.Free;
  end;

 finally
  Sock.Free;
 end;
 Memo1.Lines.LoadFromFile('download.txt');

end;

end.

