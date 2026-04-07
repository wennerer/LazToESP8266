unit lwip_sys;

{$mode objfpc}{$H+}

interface

uses
  lwip_opt;

{$IFDEF FPC}
{$PACKRECORDS C}
{$ENDIF}

{$IFDEF FPC}
{$LINKLIB c}  // Falls C-Library benötigt
{$ENDIF}

{$IFDEF NO_SYS}

// Für minimalen standalone Betrieb
type
  sys_sem_t   = Byte;
  sys_mutex_t = Byte;
  sys_mbox_t  = Byte;

function sys_sem_new(var s: sys_sem_t; c: Byte): Integer; inline;
procedure sys_sem_signal(var s: sys_sem_t); inline;
function sys_arch_sem_wait(var s: sys_sem_t; timeout: LongWord): LongWord; inline;
procedure sys_sem_free(var s: sys_sem_t); inline;
function sys_sem_valid(var s: sys_sem_t): Integer; inline;
procedure sys_sem_set_invalid(var s: sys_sem_t); inline;

function sys_mutex_new(var mu: sys_mutex_t): Integer; inline;
procedure sys_mutex_lock(var mu: sys_mutex_t); inline;
procedure sys_mutex_unlock(var mu: sys_mutex_t); inline;
procedure sys_mutex_free(var mu: sys_mutex_t); inline;
function sys_mutex_valid(var mu: sys_mutex_t): Integer; inline;

function sys_mbox_new(var m: sys_mbox_t; size: Integer): Integer; inline;
procedure sys_mbox_post(var m: sys_mbox_t; msg: Pointer); inline;
function sys_mbox_trypost(var m: sys_mbox_t; msg: Pointer): Integer; inline;
procedure sys_mbox_free(var m: sys_mbox_t); inline;
function sys_mbox_valid(var m: sys_mbox_t): Integer; inline;

function sys_thread_new(name: PChar; thread: Pointer; arg: Pointer; stacksize, prio: Integer): Pointer; inline;

procedure sys_msleep(ms: LongWord); inline;

{$ELSE} // NO_SYS

{$IFDEF ESP_LWIP_LOCK}
procedure SYS_ARCH_PROTECT_CONN(conn: Pointer); inline;
procedure SYS_ARCH_UNPROTECT_CONN(conn: Pointer); inline;
procedure SYS_ARCH_PROTECT_SOCK(sock: Pointer); inline;
procedure SYS_ARCH_UNPROTECT_SOCK(sock: Pointer); inline;
{$ENDIF}

// Timeout-Returncodes
const
  SYS_ARCH_TIMEOUT = $FFFFFFFF;
  SYS_MBOX_EMPTY   = SYS_ARCH_TIMEOUT;

uses
  lwip_err, lwip_sys_arch;

type
  lwip_thread_fn = procedure(arg: Pointer); cdecl;
  sys_thread_t = Pointer;
  sys_prot_t = LongWord; // Für SYS_ARCH_PROTECT/UNPROTECT

// Mutex-Funktionen
{$IF LWIP_COMPAT_MUTEX = 0}
function sys_mutex_new(var mutex: sys_mutex_t): err_t; cdecl;
procedure sys_mutex_lock(var mutex: sys_mutex_t); cdecl;
procedure sys_mutex_unlock(var mutex: sys_mutex_t); cdecl;
procedure sys_mutex_free(var mutex: sys_mutex_t); cdecl;
function sys_mutex_valid(var mutex: sys_mutex_t): Integer; cdecl;
procedure sys_mutex_set_invalid(var mutex: sys_mutex_t); cdecl;
{$ELSE}
type
  sys_mutex_t = sys_sem_t;
{$ENDIF}

// Semaphore-Funktionen
function sys_sem_new(var sem: sys_sem_t; count: Byte): err_t; cdecl;
procedure sys_sem_signal(var sem: sys_sem_t); cdecl;
function sys_sem_signal_isr(var sem: sys_sem_t): Integer; cdecl;
function sys_arch_sem_wait(var sem: sys_sem_t; timeout: LongWord): LongWord; cdecl;
procedure sys_sem_free(var sem: sys_sem_t); cdecl;
function sys_sem_valid(var sem: sys_sem_t): Integer; cdecl;
procedure sys_sem_set_invalid(var sem: sys_sem_t); cdecl;

// Mailbox-Funktionen
function sys_mbox_new(var mbox: sys_mbox_t; size: Integer): err_t; cdecl;
procedure sys_mbox_post(var mbox: sys_mbox_t; msg: Pointer); cdecl;
function sys_mbox_trypost(var mbox: sys_mbox_t; msg: Pointer): err_t; cdecl;
function sys_mbox_trypost_fromisr(var mbox: sys_mbox_t; msg: Pointer): err_t; cdecl;
function sys_arch_mbox_fetch(var mbox: sys_mbox_t; msg: PPointers; timeout: LongWord): LongWord; cdecl;
function sys_arch_mbox_tryfetch(var mbox: sys_mbox_t; msg: PPointers): LongWord; cdecl;
procedure sys_mbox_free(var mbox: sys_mbox_t); cdecl;
function sys_mbox_valid(var mbox: sys_mbox_t): Integer; cdecl;
procedure sys_mbox_set_invalid(var mbox: sys_mbox_t); cdecl;

// Thread-Funktionen
function sys_thread_new(name: PChar; thread: lwip_thread_fn; arg: Pointer; stacksize, prio: Integer): sys_thread_t; cdecl;

// Misc/System
procedure sys_init; cdecl;
function sys_jiffies: LongWord; cdecl;
function sys_now: LongWord; cdecl;

// Critical Region Protection
function sys_arch_protect: sys_prot_t; cdecl;
procedure sys_arch_unprotect(pval: sys_prot_t); cdecl;

{$ENDIF} // NO_SYS

implementation

{$IFDEF NO_SYS}

function sys_sem_new(var s: sys_sem_t; c: Byte): Integer;
begin
  Result := 0; // ERR_OK
end;

procedure sys_sem_signal(var s: sys_sem_t); begin end;
function sys_arch_sem_wait(var s: sys_sem_t; timeout: LongWord): LongWord; begin Result := 0; end;
procedure sys_sem_free(var s: sys_sem_t); begin end;
function sys_sem_valid(var s: sys_sem_t): Integer; begin Result := 0; end;
procedure sys_sem_set_invalid(var s: sys_sem_t); begin end;

function sys_mutex_new(var mu: sys_mutex_t): Integer; begin Result := 0; end;
procedure sys_mutex_lock(var mu: sys_mutex_t); begin end;
procedure sys_mutex_unlock(var mu: sys_mutex_t); begin end;
procedure sys_mutex_free(var mu: sys_mutex_t); begin end;
function sys_mutex_valid(var mu: sys_mutex_t): Integer; begin Result := 0; end;

function sys_mbox_new(var m: sys_mbox_t; size: Integer): Integer; begin Result := 0; end;
procedure sys_mbox_post(var m: sys_mbox_t; msg: Pointer); begin end;
function sys_mbox_trypost(var m: sys_mbox_t; msg: Pointer): Integer; begin Result := 0; end;
procedure sys_mbox_free(var m: sys_mbox_t); begin end;
function sys_mbox_valid(var m: sys_mbox_t): Integer; begin Result := 0; end;

function sys_thread_new(name: PChar; thread: Pointer; arg: Pointer; stacksize, prio: Integer): Pointer;
begin
  Result := nil;
end;

procedure sys_msleep(ms: LongWord); begin end;

{$ENDIF} // NO_SYS

end.
