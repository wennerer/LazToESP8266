unit c_time;
(* Diese Unit stammt ursprünglich von ccrause aus esp-idf und wurde von mir etwas verändert
   siehe: https://github.com/ccrause/fpc-esp-freertos/blob/master/freertos-fpc/esp-idf/c_time.pas *)
interface

uses
  portmacro;

const
  CLOCKS_PER_SEC = 1000;
  CLK_TCK = CLOCKS_PER_SEC;

type
  Ptimeval = ^Ttimeval;
  Ttimeval = record
    tv_sec,
    tv_usec: uint32;
  end;

  Ptm = ^Ttm;
  Ttm = record
    tm_sec: longint;
    tm_min: longint;
    tm_hour: longint;
    tm_mday: longint;
    tm_mon: longint;
    tm_year: longint;
    tm_wday: longint;
    tm_yday: longint;
    tm_isdst: longint;
  end;

  Ptime = ^Ttime;
  Ttime = uint32;

  Pclock = ^Tclock;
  Tclock = uint32;

  Ptimezone = ^Ttimezone;
  Ttimezone = record
    tz_minuteswest: integer;    // minutes west of Greenwich
    tz_dsttime: integer;        // type of dst correction
  end;

const
  DST_NONE = 0; // not on dst
  DST_USA  = 1; // USA style dst
  DST_AUST = 2; // Australian style dst
  DST_WET  = 3; // Western European dst
  DST_MET  = 4; // Middle European dst
  DST_EET  = 5; // Eastern European dst
  DST_CAN  = 6; // Canada


function clock: Tclock;cdecl; external;
function difftime(_time2: Ttime; _time1: Ttime): double;cdecl; external;
function mktime(_timeptr: Ptm): Ttime;cdecl; external;
function time(_timer: Ptime): Ttime;cdecl; external;
function asctime(_tblock: Ptm): pansichar;cdecl; external;
function ctime(_time: Ptime): pchar;cdecl; external;

function gmtime(const timer: Ptime): Ptm;cdecl; external;
function localtime(const timer: Ptime): Ptm;cdecl; external;
function localtime_r(const time: Ptime; const timeinfo: Ptm): Ptm;cdecl; external;
function strftime(s: pchar; maxsize: Tsize; fmt: pchar;
  t: Ptm): Tsize;cdecl; external;

function gettimeofday(tv: PTimeval; tz: PTimeZone): integer;cdecl; external;
function settimeofday(tv: PTimeval; tz: Ptimezone): integer;cdecl; external;

//function asctime_r(__restrict: Ptm; __restrict: pansichar): pansichar; external;
//function ctime_r(para1: Ptime; para2: pansichar): pansichar; external;

procedure tzset();cdecl; external;

// From stdlib.h
function setenv(str: PChar; val: PChar; overwrite: integer): integer;cdecl; external;

implementation

end.

