unit lwip_sockets;

{$mode objfpc}{$H+}

interface

uses
  ctypes,
  lwip_opt,
  lwip_ip_addr,
  lwip_netif,
  lwip_err,
  lwip_inet,
  lwip_errno,
  lwip_arch,
  //lwip_poll,
  esp_sys_poll,
  sysutils;

type
  sa_family_t = cuint8;
  in_port_t   = cuint16;
  Psocklen_t  = ^socklen_t;
  socklen_t   = cuint32;

type
 (* Pin_addr = ^in_addr;
  in_addr = record
    s_addr: cuint32;
  end; *)

  Pin6_addr = ^in6_addr;
  in6_addr = record
    s6_addr: array[0..15] of cuint8;
  end;

const
  SIN_ZERO_LEN = 8;

type

  sockaddr_in = record
    sin_len    : cuint8;
    sin_family : sa_family_t;
    sin_port   : in_port_t;
    sin_addr   : in_addr;
    sin_zero   : array[0..SIN_ZERO_LEN-1] of char;
  end;

  sockaddr_in6 = record
    sin6_len       : cuint8;
    sin6_family    : sa_family_t;
    sin6_port      : in_port_t;
    sin6_flowinfo  : cuint32;
    sin6_addr      : in6_addr;
    sin6_scope_id  : cuint32;
  end;

  Psockaddr = ^sockaddr;
  sockaddr = record
    sa_len    : cuint8;
    sa_family : sa_family_t;
    sa_data   : array[0..13] of char;
  end;

  sockaddr_storage = record
    s2_len    : cuint8;
    ss_family : sa_family_t;
    s2_data1  : array[0..1] of char;
    s2_data2  : array[0..2] of cuint32;
    s2_data3  : array[0..2] of cuint32;
  end;

type
  Piovec = ^iovec;
  iovec = record
    iov_base : pointer;
    iov_len  : csize_t;
  end;

  Pmsghdr = ^msghdr;
  msghdr = record
    msg_name       : pointer;
    msg_namelen    : socklen_t;
    msg_iov        : Piovec;
    msg_iovlen     : cint;
    msg_control    : pointer;
    msg_controllen : socklen_t;
    msg_flags      : cint;
  end;

  Pcmsghdr = ^cmsghdr;
  cmsghdr = record
    cmsg_len   : socklen_t;
    cmsg_level : cint;
    cmsg_type  : cint;
  end;

  linger = record
    l_onoff  : cint;
    l_linger : cint;
  end;

const
  SOCK_STREAM = 1;
  SOCK_DGRAM  = 2;
  SOCK_RAW    = 3;

const
  SO_REUSEADDR = $0004;
  SO_KEEPALIVE = $0008;
  SO_BROADCAST = $0020;

const
  AF_UNSPEC = 0;
  AF_INET   = 2;
  AF_INET6  = 10;

const
  PF_INET   = AF_INET;
  PF_INET6  = AF_INET6;
  PF_UNSPEC = AF_UNSPEC;

const
  IPPROTO_IP   = 0;
  IPPROTO_TCP  = 6;
  IPPROTO_UDP  = 17;
  IPPROTO_RAW  = 255;

const
  MSG_PEEK     = $01;
  MSG_WAITALL  = $02;
  MSG_OOB      = $04;
  MSG_DONTWAIT = $08;
  MSG_MORE     = $10;
  MSG_NOSIGNAL = $20;

const
  SHUT_RD   = 0;
  SHUT_WR   = 1;
  SHUT_RDWR = 2;

const
  SOL_SOCKET = $FFF;

  // Socket Optionen
  const
    SO_DEBUG       = $0001;
    SO_ACCEPTCONN  = $0002;
    SO_DONTROUTE   = $0010;
    SO_USELOOPBACK = $0040;
    SO_LINGER      = $0080;
    SO_DONTLINGER  = not SO_LINGER;
    SO_OOBINLINE   = $0100;
    SO_REUSEPORT   = $0200;
    SO_SNDBUF      = $1001;
    SO_RCVBUF      = $1002;
    SO_SNDTIMEO    = $1005;
    SO_RCVTIMEO    = $1006;
    SO_ERROR       = $1007;
    SO_TYPE        = $1008;
    SO_BINDTODEVICE= $100B;

type
  Pfd_set = ^fd_set;
  fd_set = record
    fd_bits: array[0..255] of byte;
  end;

type
  timeval = record
    tv_sec  : clong;
    tv_usec : clong;
  end;

{ ---- lwip socket API ---- }

function lwip_accept(s: cint; addr: Psockaddr; addrlen: Psocklen_t): cint; cdecl; external;
function lwip_bind(s: cint; name: Psockaddr; namelen: socklen_t): cint; cdecl; external;
function lwip_shutdown(s: cint; how: cint): cint; cdecl; external;
function lwip_connect(s: cint; name: Psockaddr; namelen: socklen_t): cint; cdecl; external;
function lwip_listen(s: cint; backlog: cint): cint; cdecl; external;
function lwip_socket(domain, _type, protocol: cint): cint; cdecl; external;

function lwip_setsockopt(s, level, optname: Integer; const optval: Pointer; optlen: socklen_t): Integer; cdecl;external;

function lwip_recv(s: cint; mem: pointer; len: csize_t; flags: cint): ssize_t; cdecl; external;
function lwip_send(s: cint; dataptr: pointer; size: csize_t; flags: cint): ssize_t; cdecl; external;

function lwip_recvfrom(s: cint; mem: pointer; len: csize_t; flags: cint;
  from: Psockaddr; fromlen: Psocklen_t): ssize_t; cdecl; external;

function lwip_sendto(s: cint; dataptr: pointer; size: csize_t; flags: cint;
  dest: Psockaddr; tolen: socklen_t): ssize_t; cdecl; external;

function lwip_close(s: cint): cint; cdecl; external;

implementation

end.
