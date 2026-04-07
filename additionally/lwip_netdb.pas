unit lwip_netdb;

{$mode objfpc}{$H+}

interface

uses
  lwip_opt,
  lwip_arch,
  lwip_inet,
  lwip_sockets;

{$IFDEF LWIP_DNS}
{$IFDEF LWIP_SOCKET}

type
  socklen_t = SizeUInt;

{ ===================== Fehlercodes ===================== }

const
  EAI_NONAME  = 200;
  EAI_SERVICE = 201;
  EAI_FAIL    = 202;
  EAI_MEMORY  = 203;
  EAI_FAMILY  = 204;

  HOST_NOT_FOUND = 210;
  NO_DATA        = 211;
  NO_RECOVERY    = 212;
  TRY_AGAIN      = 213;

{ ===================== Flags ===================== }

const
  AI_PASSIVE     = $01;
  AI_CANONNAME   = $02;
  AI_NUMERICHOST = $04;
  AI_NUMERICSERV = $08;
  AI_V4MAPPED    = $10;
  AI_ALL         = $20;
  AI_ADDRCONFIG  = $40;

{ ===================== Strukturen ===================== }

type
  PHostEnt = ^THostEnt;
  PPChar   = ^PChar;

  THostEnt = record
    h_name     : PChar;
    h_aliases  : PPChar;
    h_addrtype : LongInt;
    h_length   : LongInt;
    h_addr_list: PPChar;
  end;

  PAddrInfo = ^TAddrInfo;

  TAddrInfo = record
    ai_flags     : LongInt;
    ai_family    : LongInt;
    ai_socktype  : LongInt;
    ai_protocol  : LongInt;
    ai_addrlen   : socklen_t;
    ai_addr      : PSockAddr;
    ai_canonname : PChar;
    ai_next      : PAddrInfo;
  end;

{ entspricht NETDB_ELEM_SIZE }

function NETDB_ELEM_SIZE: SizeUInt; inline;

{ ===================== h_errno ===================== }

var
  h_errno: LongInt;

{ ===================== DNS API ===================== }

function lwip_gethostbyname(name: PChar): PHostEnt; cdecl;
function lwip_gethostbyname_r(name: PChar;
  ret: PHostEnt;
  buf: PChar;
  buflen: SizeUInt;
  resultp: PPHostEnt;
  h_errnop: PLongInt): LongInt; cdecl;

procedure lwip_freeaddrinfo(ai: PAddrInfo); cdecl;

function lwip_getaddrinfo(
  nodename : PChar;
  servname : PChar;
  hints    : PAddrInfo;
  res      : PPAddrInfo
): LongInt; cdecl;

{ ===================== Socket Kompatibilität ===================== }

{$IFDEF LWIP_COMPAT_SOCKETS}

function gethostbyname(name: PChar): PHostEnt; inline;
function gethostbyname_r(name: PChar;
  ret: PHostEnt;
  buf: PChar;
  buflen: SizeUInt;
  resultp: PPHostEnt;
  h_errnop: PLongInt): LongInt; inline;

procedure freeaddrinfo(ai: PAddrInfo); inline;

function getaddrinfo(
  nodename : PChar;
  servname : PChar;
  hints    : PAddrInfo;
  res      : PPAddrInfo
): LongInt; inline;

{$ENDIF}

{$ENDIF}
{$ENDIF}

implementation

{$IFDEF LWIP_DNS}
{$IFDEF LWIP_SOCKET}

function NETDB_ELEM_SIZE: SizeUInt; inline;
begin
  Result :=
    SizeOf(TAddrInfo) +
    SizeOf(sockaddr_storage) +
    DNS_MAX_NAME_LENGTH + 1;
end;

{$IFDEF LWIP_COMPAT_SOCKETS}

function gethostbyname(name: PChar): PHostEnt; inline;
begin
  Result := lwip_gethostbyname(name);
end;

function gethostbyname_r(name: PChar;
  ret: PHostEnt;
  buf: PChar;
  buflen: SizeUInt;
  resultp: PPHostEnt;
  h_errnop: PLongInt): LongInt; inline;
begin
  Result := lwip_gethostbyname_r(name, ret, buf, buflen, resultp, h_errnop);
end;

procedure freeaddrinfo(ai: PAddrInfo); inline;
begin
  lwip_freeaddrinfo(ai);
end;

function getaddrinfo(
  nodename : PChar;
  servname : PChar;
  hints    : PAddrInfo;
  res      : PPAddrInfo
): LongInt; inline;
begin
  Result := lwip_getaddrinfo(nodename, servname, hints, res);
end;

{$ENDIF}

{$ENDIF}
{$ENDIF}

end.
