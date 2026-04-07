unit lwip_ip6_addr;

{$mode objfpc}{$H+}

interface

uses
  lwip_opt, lwip_def;  // lwIP-Optionen und Definitionen (u8_t, u16_t, u32_t, PP_HTONL, etc.)

{$IFDEF LWIP_IPV6}
type
  u8_t  = Byte;
  u16_t = Word;
  u32_t = LongWord;
  s8_t  = ShortInt;


type
  // IPv6-Adresse mit optionalem Zone-Index
  TIP6Addr = record
    addr: array[0..3] of u32_t;
{$IFDEF LWIP_IPV6_SCOPES}
    zone: u8_t;
{$ENDIF}
  end;
  PIP6Addr = ^TIP6Addr;

const
  IP6_NO_ZONE = 0;

  // IPv6 Address States
  IP6_ADDR_INVALID      = $00;
  IP6_ADDR_TENTATIVE    = $08;
  IP6_ADDR_TENTATIVE_1  = $09;
  IP6_ADDR_TENTATIVE_2  = $0A;
  IP6_ADDR_TENTATIVE_3  = $0B;
  IP6_ADDR_TENTATIVE_4  = $0C;
  IP6_ADDR_TENTATIVE_5  = $0D;
  IP6_ADDR_TENTATIVE_6  = $0E;
  IP6_ADDR_TENTATIVE_7  = $0F;
  IP6_ADDR_VALID        = $10;
  IP6_ADDR_PREFERRED    = $30;
  IP6_ADDR_DEPRECATED   = $10;
  IP6_ADDR_DUPLICATED   = $40;

  IP6_ADDR_TENTATIVE_COUNT_MASK = $07;

  IP6_ADDR_LIFE_STATIC   = 0;
  IP6_ADDR_LIFE_INFINITE = $FFFFFFFF;

  IP6ADDR_STRLEN_MAX = 46;

  // Multicast scopes
  IP6_MULTICAST_SCOPE_INTERFACE_LOCAL     = $1;
  IP6_MULTICAST_SCOPE_LINK_LOCAL          = $2;
  IP6_MULTICAST_SCOPE_SITE_LOCAL          = $5;
  IP6_MULTICAST_SCOPE_ADMIN_LOCAL         = $4;
  IP6_MULTICAST_SCOPE_GLOBAL              = $E;

procedure IP6Addr_Part(ip6addr: PIP6Addr; index: Integer; a, b, c, d: u8_t);
procedure IP6Addr_SetZero(ip6addr: PIP6Addr);
procedure IP6Addr_SetLoopback(ip6addr: PIP6Addr);
procedure IP6Addr_Copy(dest: TIP6Addr; const src: TIP6Addr);
function IP6Addr_IsAny(const ip6addr: TIP6Addr): Boolean;
function IP6Addr_IsLoopback(const ip6addr: TIP6Addr): Boolean;

{$ENDIF}

implementation

{$IFDEF LWIP_IPV6}
// Set partial IPv6 address using four bytes
procedure IP6Addr_Part(ip6addr: PIP6Addr; index: Integer; a, b, c, d: u8_t);
begin
  ip6addr^.addr[index] := PP_HTONL(LWIP_MAKEU32(a, b, c, d));
end;

// Set entire IPv6 address to zero
procedure IP6Addr_SetZero(ip6addr: PIP6Addr);
begin
  ip6addr^.addr[0] := 0;
  ip6addr^.addr[1] := 0;
  ip6addr^.addr[2] := 0;
  ip6addr^.addr[3] := 0;
{$IFDEF LWIP_IPV6_SCOPES}
  ip6addr^.zone := IP6_NO_ZONE;
{$ENDIF}
end;

// Set IPv6 loopback address (::1)
procedure IP6Addr_SetLoopback(ip6addr: PIP6Addr);
begin
  ip6addr^.addr[0] := 0;
  ip6addr^.addr[1] := 0;
  ip6addr^.addr[2] := 0;
  ip6addr^.addr[3] := PP_HTONL($00000001);
{$IFDEF LWIP_IPV6_SCOPES}
  ip6addr^.zone := IP6_NO_ZONE;
{$ENDIF}
end;

// Copy IPv6 address
procedure IP6Addr_Copy(dest: TIP6Addr; const src: TIP6Addr);
begin
  dest.addr[0] := src.addr[0];
  dest.addr[1] := src.addr[1];
  dest.addr[2] := src.addr[2];
  dest.addr[3] := src.addr[3];
{$IFDEF LWIP_IPV6_SCOPES}
  dest.zone := src.zone;
{$ENDIF}
end;

// Check if IPv6 address is all zeros (::)
function IP6Addr_IsAny(const ip6addr: TIP6Addr): Boolean;
begin
  Result := (ip6addr.addr[0] = 0) and
            (ip6addr.addr[1] = 0) and
            (ip6addr.addr[2] = 0) and
            (ip6addr.addr[3] = 0);
end;

// Check if IPv6 address is loopback (::1)
function IP6Addr_IsLoopback(const ip6addr: TIP6Addr): Boolean;
begin
  Result := (ip6addr.addr[0] = 0) and
            (ip6addr.addr[1] = 0) and
            (ip6addr.addr[2] = 0) and
            (ip6addr.addr[3] = PP_HTONL($00000001));
end;
{$ENDIF}
end.
