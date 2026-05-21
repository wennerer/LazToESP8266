unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs,
  StdCtrls,
  blcksock;

type

  { TForm1 }

  TForm1 = class(TForm)
    ButtonDisconnect: TButton;
    ButtonSend: TButton;
    ButtonConnect: TButton;
    Edit1: TEdit;
    Memo1: TMemo;
    procedure ButtonConnectClick(Sender: TObject);
    procedure ButtonDisconnectClick(Sender: TObject);
    procedure ButtonSendClick(Sender: TObject);
  private
    Sock: TTCPBlockSocket;
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}



procedure TForm1.ButtonConnectClick(Sender: TObject);
begin
  Sock := TTCPBlockSocket.Create;
  Sock.RaiseExcept := False;
  Sock.ConnectionTimeout := 3000;

  Sock.Connect('192.168.178.140', '5000');

  if Sock.LastError <> 0 then
  begin
    Memo1.Lines.Add('Verbindung fehlgeschlagen: ' + Sock.LastErrorDesc);
    Exit;
  end;

  Memo1.Lines.Add('Verbunden!');
end;

procedure TForm1.ButtonSendClick(Sender: TObject);
var
  S: string;
begin
  S := Edit1.Text + #10;

  Sock.SendString(S);

  if Sock.LastError <> 0 then
  begin
    Memo1.Lines.Add('Senden fehlgeschlagen: ' + Sock.LastErrorDesc);
    Exit;
  end;

  // Antwort vom ESP lesen
  S := Sock.RecvString(3000); // 3000 ms Timeout

  if Sock.LastError = 0 then
    Memo1.Lines.Add('ESP antwortet: ' + S)
  else
    Memo1.Lines.Add('Keine Antwort oder Timeout');
end;

procedure TForm1.ButtonDisconnectClick(Sender: TObject);
begin
  Sock.CloseSocket;
  Sock.Free;
  Memo1.Lines.Add('Verbindung geschlossen.');
end;



end.


