unit esp_sys_poll;

{$mode objfpc}{$H+}

interface

uses
  ctypes;

const
  POLLIN     = (1 shl 0);  // data other than high-priority may be read
  POLLRDNORM = (1 shl 1);  // normal data may be read
  POLLRDBAND = (1 shl 2);  // priority data may be read
  POLLPRI    = POLLRDBAND; // high-priority data may be read
  POLLOUT    = (1 shl 3);  // data may be written
  POLLWRNORM = POLLOUT;    // equivalent to POLLOUT
  POLLWRBAND = (1 shl 4);  // priority data may be written
  POLLERR    = (1 shl 5);  // error occurred
  POLLHUP    = (1 shl 6);  // descriptor hung up
  POLLNVAL   = (1 shl 7);  // invalid descriptor

type
  Ppollfd = ^pollfd;

  pollfd = record
    fd: cint;        // descriptor
    events: cshort;  // requested events
    revents: cshort; // returned events
  end;

  nfds_t = cuint;

function poll(fds: Ppollfd; nfds: nfds_t; timeout: cint): cint; cdecl; external;

implementation

end.
