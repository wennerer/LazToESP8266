unit lwip_prot_ip4;

interface

uses
  lwip_arch, lwip_ip4_addr, lwip_def;

{$IFDEF FPC}
  {$PACKRECORDS C}  // Entspricht PACK_STRUCT_STRUCT
{$ENDIF}

type
  // Packed IPv4 address für Netzwerkheader
  ip4_addr_p_t = packed record
    addr: u32_t;
  end;

const
  IP_HLEN = 20;       // Größe des IPv4-Headers
  IP_HLEN_MAX = 60;   // Maximalgröße inkl. Optionen

  // Fragment Flags
  IP_RF = $8000;      // Reserved fragment flag
  IP_DF = $4000;      // Don't fragment flag
  IP_MF = $2000;      // More fragments flag
  IP_OFFMASK = $1FFF; // Maske für Fragmentierungsbits

type
  // IPv4 Header
  PIP_HDR = ^ip_hdr;
  ip_hdr = packed record
    _v_hl: u8_t;        // Version + Header Length
    _tos: u8_t;         // Type of Service
    _len: u16_t;        // Total Length
    _id: u16_t;         // Identification
    _offset: u16_t;     // Fragment Offset
    _ttl: u8_t;         // Time To Live
    _proto: u8_t;       // Protocol
    _chksum: u16_t;     // Checksum
    src: ip4_addr_p_t;  // Source IP
    dest: ip4_addr_p_t; // Destination IP
  end;

{ Zugriffsfunktionen ähnlich den Makros aus C }

function IPH_V(const hdr: PIP_HDR): u8_t; inline;
function IPH_HL(const hdr: PIP_HDR): u8_t; inline;
function IPH_HL_BYTES(const hdr: PIP_HDR): u8_t; inline;
function IPH_TOS(const hdr: PIP_HDR): u8_t; inline;
function IPH_LEN(const hdr: PIP_HDR): u16_t; inline;
function IPH_ID(const hdr: PIP_HDR): u16_t; inline;
function IPH_OFFSET(const hdr: PIP_HDR): u16_t; inline;
function IPH_OFFSET_BYTES(const hdr: PIP_HDR): u16_t; inline;
function IPH_TTL(const hdr: PIP_HDR): u8_t; inline;
function IPH_PROTO(const hdr: PIP_HDR): u8_t; inline;
function IPH_CHKSUM(const hdr: PIP_HDR): u16_t; inline;

procedure IPH_VHL_SET(hdr: PIP_HDR; v, hl: u8_t); inline;
procedure IPH_TOS_SET(hdr: PIP_HDR; tos: u8_t); inline;
procedure IPH_LEN_SET(hdr: PIP_HDR; len: u16_t); inline;
procedure IPH_ID_SET(hdr: PIP_HDR; id: u16_t); inline;
procedure IPH_OFFSET_SET(hdr: PIP_HDR; off: u16_t); inline;
procedure IPH_TTL_SET(hdr: PIP_HDR; ttl: u8_t); inline;
procedure IPH_PROTO_SET(hdr: PIP_HDR; proto: u8_t); inline;
procedure IPH_CHKSUM_SET(hdr: PIP_HDR; chksum: u16_t); inline;

implementation

function IPH_V(const hdr: PIP_HDR): u8_t; inline;
begin
  Result := hdr^._v_hl shr 4;
end;

function IPH_HL(const hdr: PIP_HDR): u8_t; inline;
begin
  Result := hdr^._v_hl and $0F;
end;

function IPH_HL_BYTES(const hdr: PIP_HDR): u8_t; inline;
begin
  Result := IPH_HL(hdr) * 4;
end;

function IPH_TOS(const hdr: PIP_HDR): u8_t; inline;
begin
  Result := hdr^._tos;
end;

function IPH_LEN(const hdr: PIP_HDR): u16_t; inline;
begin
  Result := hdr^._len;
end;

function IPH_ID(const hdr: PIP_HDR): u16_t; inline;
begin
  Result := hdr^._id;
end;

function IPH_OFFSET(const hdr: PIP_HDR): u16_t; inline;
begin
  Result := hdr^._offset;
end;

function IPH_OFFSET_BYTES(const hdr: PIP_HDR): u16_t; inline;
begin
  Result := (lwip_ntohs(IPH_OFFSET(hdr)) and IP_OFFMASK) * 8;
end;

function IPH_TTL(const hdr: PIP_HDR): u8_t; inline;
begin
  Result := hdr^._ttl;
end;

function IPH_PROTO(const hdr: PIP_HDR): u8_t; inline;
begin
  Result := hdr^._proto;
end;

function IPH_CHKSUM(const hdr: PIP_HDR): u16_t; inline;
begin
  Result := hdr^._chksum;
end;

procedure IPH_VHL_SET(hdr: PIP_HDR; v, hl: u8_t); inline;
begin
  hdr^._v_hl := (v shl 4) or hl;
end;

procedure IPH_TOS_SET(hdr: PIP_HDR; tos: u8_t); inline;
begin
  hdr^._tos := tos;
end;

procedure IPH_LEN_SET(hdr: PIP_HDR; len: u16_t); inline;
begin
  hdr^._len := len;
end;

procedure IPH_ID_SET(hdr: PIP_HDR; id: u16_t); inline;
begin
  hdr^._id := id;
end;

procedure IPH_OFFSET_SET(hdr: PIP_HDR; off: u16_t); inline;
begin
  hdr^._offset := off;
end;

procedure IPH_TTL_SET(hdr: PIP_HDR; ttl: u8_t); inline;
begin
  hdr^._ttl := ttl;
end;

procedure IPH_PROTO_SET(hdr: PIP_HDR; proto: u8_t); inline;
begin
  hdr^._proto := proto;
end;

procedure IPH_CHKSUM_SET(hdr: PIP_HDR; chksum: u16_t); inline;
begin
  hdr^._chksum := chksum;
end;

end.
