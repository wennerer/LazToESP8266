{This is a part of the package laz_to_esp8266}

unit uartmonitor_frame;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, StdCtrls, ExtCtrls, Buttons,
  Synaser;

type

  { TFrame1 }

  { TMonitorFrame }

  TMonitorFrame = class(TFrame)
    Button_SendString: TButton;
    Button_Clear: TButton;
    Button_Stop: TButton;
    Button_Read: TButton;
    CheckBox_TimeStamp: TCheckBox;
    CheckGroup_FlowControl: TCheckGroup;
    ComboBox_Port: TComboBox;
    ComboBox_Baudrate: TComboBox;
    ComboBox_DataBits: TComboBox;
    ComboBox_Parity: TComboBox;
    ComboBox_Stopbits: TComboBox;
    Edit1: TEdit;
    Memo1: TMemo;
    Shape1: TShape;
    SpeedButton_refreshport: TSpeedButton;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    StaticText4: TStaticText;
    StaticText5: TStaticText;
    StaticText6: TStaticText;
    procedure Button_SendStringClick(Sender: TObject);
    procedure Button_ClearClick(Sender: TObject);
    procedure Button_ReadClick(Sender: TObject);
    procedure Button_StopClick(Sender: TObject);
    procedure SpeedButton_refreshportClick(Sender: TObject);

  private
    terminate : boolean;
    ser       : TBlockSerial;
    baud      : integer;
    bits      : integer;
    parity    : char;
    stop      : integer;
    softflow  : boolean;
    hardflow  : boolean;
    StartTime : Qword;
    TimeStamp : boolean;
    Port      : string;
    procedure Configure;
    function FormataTime(Time:integer) : string;
  public
   constructor Create(AOwner: TComponent); override;
   destructor  Destroy; override;
  end;

implementation

{$R *.lfm}

{ TFrame1 }

procedure TMonitorFrame.Button_ReadClick(Sender: TObject);
var
    Value        : string;
    SerialActive : Boolean;
    aTime        : QWord;

begin
 Configure;
 ser:=TBlockSerial.Create;
 ser.LinuxLock   := False;
 ser.RaiseExcept := False;
 ser.Purge;
 ser.ConvertLineEnd:=true;
 try
  terminate := false;
  Memo1.Lines.Add('Verbindung wird hergestellt');
  Sleep(100);
  ser.Connect(Port);
  Sleep(100);
  ser.config(9600,8, 'N', SB1, False, False);
  ser.config(baud,bits,parity,stop,softflow,hardflow);

  Memo1.Lines.Add('Device: ' + ser.Device + '   Status: ' + ser.LastErrorDesc +' '+ Inttostr(ser.LastError));
  SerialActive:= ser.InstanceActive;
  if not (SerialActive) then Memo1.Lines.Add('Keine Verbindung zur Seriellen Schnittstelle')
   else Memo1.Lines.Add('Verbindung zur Seriellen Schnittstelle hergestellt');
  StartTime := GetTickCount64;
  repeat
   Value := ser.RecvString(10);
   Value := StringReplace(Value,chr(27),chr(32),[rfReplaceAll]); //ESC Zeichen entfernen.
    if (Value <> '') then
     begin
      if TimeStamp then
       begin
        aTime := GetTickCount64 - StartTime;
        Memo1.Lines.Add(FormataTime(aTime)+' : '+Value);
       end
      else
       Memo1.Lines.Add(Value);
     end;
    Application.Processmessages;
  until terminate = true;

 finally
  Memo1.Lines.Add('Serial Port will be freed...');
  FreeAndNil(ser);
  Memo1.Lines.Add('Serial Port was freed successfully!');
  end;
end;

procedure TMonitorFrame.Button_ClearClick(Sender: TObject);
begin
 Memo1.Clear;
end;

procedure TMonitorFrame.Button_SendStringClick(Sender: TObject);
begin
 ser.SendString(Edit1.Text+ chr(0));
end;

procedure TMonitorFrame.Button_StopClick(Sender: TObject);
begin
 terminate := true;
end;

procedure TMonitorFrame.SpeedButton_refreshportClick(Sender: TObject);
begin
 ComboBox_Port.Items.CommaText := GetSerialPortNames;
end;

procedure TMonitorFrame.Configure;
begin
 Port := ComboBox_Port.Text;
 baud := strtoint(ComboBox_Baudrate.Text);
 bits := strtoint(ComboBox_DataBits.Text);
 case ComboBox_Parity.Text of
    'None': parity := 'N';
    'Odd' : parity := 'O';
    'Even': parity := 'E';
  end;
 stop := strtoint(ComboBox_Stopbits.Text);
 softflow := CheckGroup_FlowControl.Checked[1];
 hardflow := CheckGroup_FlowControl.Checked[0];
 TimeStamp := CheckBox_TimeStamp.Checked;
end;

function TMonitorFrame.FormataTime(Time: integer): string;
 var ms, sec, min : integer;
begin
 if Time < 1000 then Result := inttostr(Time) + 'ms  ';
 if (Time >= 1000) and (Time <=60000) then
  begin
   sec := Time div 1000;
   ms  := Time - (sec * 1000);
   result := inttostr(sec)+':'+inttostr(ms)+'sec  ';
  end;
 if Time > 60000 then
  begin
   sec := Time div 1000;
   ms  := Time - (sec * 1000);
   min := sec div 60;
   sec := sec - (min * 60);

   result := inttostr(min)+':'+inttostr(sec)+':'+inttostr(ms)+'min  ';
  end;
end;

constructor TMonitorFrame.Create(AOwner: TComponent);
begin
 inherited Create(AOwner);
 ComboBox_Port.Items.CommaText := GetSerialPortNames;
end;

destructor TMonitorFrame.Destroy;
begin
 terminate := true;
 if assigned(ser) then FreeAndNil(ser);
 inherited Destroy;
end;

end.

