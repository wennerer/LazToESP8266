{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit laz_to_esp8266;

{$warn 5023 off : no warning about unused units}
interface

uses
  esp8266main, uartmonitor_frame, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('esp8266main', @esp8266main.Register);
end;

initialization
  RegisterPackage('laz_to_esp8266', @Register);
end.
