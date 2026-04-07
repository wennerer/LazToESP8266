unit lwip_err;

{$mode objfpc}
{$H+}
{$inline on}

interface

uses
  lwip_arch;

{ -----------------------------------------------------------------------------
  Error Enum (entspricht err_enum_t)
  ----------------------------------------------------------------------------- }

//type
  //err_enum_t = (
  const
    ERR_OK         =   0;   // No error
    ERR_MEM        =  -1;  // Out of memory
    ERR_BUF        =  -2;  // Buffer error
    ERR_TIMEOUT    =  -3;  // Timeout
    ERR_RTE        =  -4;  // Routing problem
    ERR_INPROGRESS =  -5;  // Operation in progress
    ERR_VAL        =  -6;  // Illegal value
    ERR_WOULDBLOCK =  -7;  // Would block
    ERR_USE        =  -8;  // Address in use
    ERR_ALREADY    =  -9;  // Already connecting
    ERR_ISCONN     = -10; // Already connected
    ERR_CONN       = -11; // Not connected
    ERR_IF         = -12; // Low-level netif error
    ERR_ABRT       = -13; // Connection aborted
    ERR_RST        = -14; // Connection reset
    ERR_CLSD       = -15; // Connection closed
    ERR_ARG        = -16;  // Illegal argument
  //);

{ -----------------------------------------------------------------------------
  err_t Typ
  ----------------------------------------------------------------------------- }

{$ifdef LWIP_ERR_T}
  type err_t = LWIP_ERR_T;
{$else}
 // type err_t = s8_t;  // signed 8-bit (Standard lwIP)
 Type
   err_t = ShortInt; // s8_t in C is typically a signed 8-bit integer, use ShortInt in Pascal
{$endif}

{ -----------------------------------------------------------------------------
  Debug String
  ----------------------------------------------------------------------------- }

{$ifdef LWIP_DEBUG}
function lwip_strerr(err: err_t): PChar;
{$else}
function lwip_strerr(err: err_t): PChar; inline;
{$endif}

{ -----------------------------------------------------------------------------
  err_t → errno (Linux)
  ----------------------------------------------------------------------------- }

{$ifndef NO_SYS}
function err_to_errno(err: err_t): Integer;
{$endif}

implementation

{$ifdef LWIP_DEBUG}
function lwip_strerr(err: err_t): PChar;
begin
  case err of
    ERR_OK:         Result := 'OK';
    ERR_MEM:        Result := 'Out of memory';
    ERR_BUF:        Result := 'Buffer error';
    ERR_TIMEOUT:    Result := 'Timeout';
    ERR_RTE:        Result := 'Routing problem';
    ERR_INPROGRESS: Result := 'In progress';
    ERR_VAL:        Result := 'Illegal value';
    ERR_WOULDBLOCK: Result := 'Would block';
    ERR_USE:        Result := 'Address in use';
    ERR_ALREADY:    Result := 'Already connecting';
    ERR_ISCONN:     Result := 'Already connected';
    ERR_CONN:       Result := 'Not connected';
    ERR_IF:         Result := 'Netif error';
    ERR_ABRT:       Result := 'Connection aborted';
    ERR_RST:        Result := 'Connection reset';
    ERR_CLSD:       Result := 'Connection closed';
    ERR_ARG:        Result := 'Illegal argument';
  else
    Result := 'Unknown error';
  end;
end;
{$else}
function lwip_strerr(err: err_t): PChar; inline;
begin
  Result := '';
end;
{$endif}

{$ifndef NO_SYS}
function err_to_errno(err: err_t): Integer;
begin
  case err of
    ERR_OK:         Result := 0;
    ERR_MEM:        Result := 12;  // ENOMEM
    ERR_BUF:        Result := 105; // ENOBUFS
    ERR_TIMEOUT:    Result := 110; // ETIMEDOUT
    ERR_RTE:        Result := 113; // EHOSTUNREACH
    ERR_INPROGRESS: Result := 115; // EINPROGRESS
    ERR_VAL:        Result := 22;  // EINVAL
    ERR_WOULDBLOCK: Result := 11;  // EAGAIN
    ERR_USE:        Result := 98;  // EADDRINUSE
    ERR_ALREADY:    Result := 114; // EALREADY
    ERR_ISCONN:     Result := 106; // EISCONN
    ERR_CONN:       Result := 107; // ENOTCONN
    ERR_IF:         Result := 5;   // EIO
    ERR_ABRT:       Result := 103; // ECONNABORTED
    ERR_RST:        Result := 104; // ECONNRESET
    ERR_CLSD:       Result := 107; // ENOTCONN
    ERR_ARG:        Result := 22;  // EINVAL
  else
    Result := -1;
  end;
end;
{$endif}

end.
