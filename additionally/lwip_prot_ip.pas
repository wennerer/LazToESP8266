unit lwip_prot_ip;

{$mode objfpc}{$H+}
{$PACKRECORDS C}   // C-kompatible Packung für Strukturen

interface

uses
  lwip_def;

const
  IP_PROTO_ICMP     = 1;
  IP_PROTO_IGMP     = 2;
  IP_PROTO_UDP      = 17;
  IP_PROTO_UDPLITE  = 136;
  IP_PROTO_TCP      = 6;

{ Lädt die erste Byte der IP-Header-Struktur und gibt die Version zurück }
function IP_HDR_GET_VERSION(ptr: Pointer): UInt8; inline;

implementation

function IP_HDR_GET_VERSION(ptr: Pointer): UInt8; inline;
begin
  if ptr <> nil then
    Result := PUInt8(ptr)^ shr 4
  else
    Result := 0;
end;

end.
