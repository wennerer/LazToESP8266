unit lwip_prot_udp;

interface

uses
  lwip_arch; // Hier u16_t definiert

const
  UDP_HLEN = 8; // UDP Header Länge

type
  // UDP Header Struktur (alle Felder im Netzwerk-Byte-Order)
  PUDPHeader = ^TUDPHeader;
  TUDPHeader = packed record
    src: u16_t;   // Quellport
    dest: u16_t;  // Zielport
    len: u16_t;   // Länge des UDP-Datagramms
    chksum: u16_t; // Prüfsumme
  end;

implementation

end.
