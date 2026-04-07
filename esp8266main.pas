{ <Some adjustments specifically for programming an ESP8266>

  Copyright (C) <28.7.2025> <Bernd Hübner (wennerer)> <contact: German Lazarusforum>

  This source is free software; you can redistribute it and/or modify it under the terms of the GNU General Public
  License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later
  version.

  This code is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
  warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
  details.

  A copy of the GNU General Public License is available on the World Wide Web at
  <http://www.gnu.org/copyleft/gpl.html>. You can also obtain it by writing to the Free Software Foundation, Inc., 51
  Franklin Street - Fifth Floor, Boston, MA 02110-1335, USA.

  This programme requires Synaser. Please read the licence terms there.
}




unit esp8266main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, IDEWindowIntf, MenuIntf, IDECommands, Forms, LCLType,
  Dialogs, Graphics, uartmonitor_frame;

resourcestring
  mnuESP8266        = 'ESP8266';
  mnuShowUartMonitor = 'UART-Monitor';

type

  { TMyUartMonitorForm }

  TMyUartMonitorForm = class (TCustomForm)
  private
   MainFrame : TMonitorFrame;
  public
   constructor CreateNew(AOwner: TComponent; Num: Integer = 0); override;
   destructor  Destroy; override;
  end;
procedure Register;


var UartMonitorForm    : TMyUartMonitorForm = nil;
    Cmd                : TIDEMenuCommand  = nil;
    CmdMessageComposer : TIDECommand;
    itmESP8266         : TIDEMenuSection;

implementation

procedure CreateUartMonitorForm(Sender: TObject; aFormName: string; var AForm: TCustomForm; DoDisableAutoSizing: boolean);
begin
 if CompareText(aFormName,'UartMonitorForm')<>0 then exit;

 IDEWindowCreators.CreateForm(UartMonitorForm,TMyUartMonitorForm,DoDisableAutosizing,Application);

 AForm:=UartMonitorForm;
end;

procedure OnCmdUartMonitorClick(Sender: TObject);
begin
 IDEWindowCreators.ShowForm(UartMonitorForm.Name,true);
end;

procedure Register;
var Key      : TIDEShortCut;
    Cat      : TIDECommandCategory;
    CmdMyTool: TIDECommand;
begin
  {$R image.res}

  //Create a new Mainmenuitem ESP8266
  itmESP8266 := RegisterIDESubMenu(mnuMain,mnuESP8266,mnuESP8266);

  UartMonitorForm := TMyUartMonitorForm.CreateNew(Application,0);

  IDEWindowCreators.Add('UartMonitorForm',@CreateUartMonitorForm,nil,'100','100','1100','500');

  //Erzeugt den Menüeintrag mit Shortcut:
  Key := IDEShortCut(VK_M,[ssShift,ssAlt],VK_UNKNOWN,[]);
  Cat := IDECommandList.FindIDECommand(ecFind).Category;
  CmdMyTool := RegisterIDECommand(Cat,mnuShowUartMonitor,mnuShowUartMonitor, Key, nil,@OnCmdUartMonitorClick);
  Cmd := RegisterIDEMenuCommand(itmESP8266,mnuShowUartMonitor,mnuShowUartMonitor, nil, nil, CmdMyTool,'Window_16');

  //Ohne Shortcut
  //RegisterIDEMenuCommand(itmCustomTools, mnuShowUartMonitor,mnuShowUartMonitor,nil,@OnCmdClick,nil);

end;

{ TMyUartMonitorForm }
constructor TMyUartMonitorForm.CreateNew(AOwner: TComponent; Num: Integer);
begin
  inherited CreateNew(AOwner, Num);
  Name := 'UartMonitorForm';
  Caption := 'UART Monitor';
  SetBounds(100,100,1000,400);
  Color := clDefault;

  MainFrame := TMonitorFrame.Create(self);
  MainFrame.Parent := self;
end;

destructor TMyUartMonitorForm.Destroy;
begin

  inherited Destroy;
end;

end.


