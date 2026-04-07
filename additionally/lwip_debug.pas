unit lwip_debug;

{$mode delphi}{$H+}

interface

uses
  lwip_arch, lwip_opt;

type
  // Parameterlose Prozedur-Referenz (für Handler)
  TProc = reference to procedure;

{ Debug Level (LWIP_DBG_MIN_LEVEL) }
const
  LWIP_DBG_LEVEL_ALL     = $00;  { Alle Meldungen }
  LWIP_DBG_LEVEL_WARNING = $01;  { Warnungen: z.B. falsche Checksums, verworfene Pakete }
  LWIP_DBG_LEVEL_SERIOUS = $02;  { Schwerwiegende Fehler, z.B. Speicherfehler }
  LWIP_DBG_LEVEL_SEVERE  = $03;  { Kritisch }

  LWIP_DBG_MASK_LEVEL = $03;
  LWIP_DBG_LEVEL_OFF  = LWIP_DBG_LEVEL_ALL;

{ Debug Message Enable/Disable (LWIP_DBG_TYPES_ON) }
const
  LWIP_DBG_ON  = $80;
  LWIP_DBG_OFF = $00;

{ Debug Message Types }
const
  LWIP_DBG_TRACE = $40;  { Ablaufverfolgung }
  LWIP_DBG_STATE = $20;  { Modulzustände }
  LWIP_DBG_FRESH = $10;  { Neu hinzugefügter, evtl. ungetesteter Code }
  LWIP_DBG_HALT  = $08;  { Anhalten nach Ausgabe }

{ Assertions }
{$ifdef notdefined LWIP_NOASSERT}
procedure LWIP_ASSERT(const message: PChar; assertion: Boolean);
{$else}
procedure LWIP_ASSERT(const message: PChar; assertion: Boolean); inline;
{$endif}

{ Errors }
{$ifndef LWIP_ERROR}
{$ifdef LWIP_DEBUG}
procedure LWIP_PLATFORM_ERROR(const message: PChar);
{$else}
procedure LWIP_PLATFORM_ERROR(const message: PChar); inline;
{$endif}

procedure LWIP_ERROR(const message: PChar; expression: Boolean; handler: TProc);
{$endif}

{ Debug printing macro equivalent }
{$ifdef LWIP_DEBUG}
procedure LWIP_DEBUGF(debug: Byte; message: PChar);
{$else}
procedure LWIP_DEBUGF(debug: Byte; message: PChar); inline;
{$endif}

implementation

uses
  SysUtils;

{$ifdef notdefined LWIP_NOASSERT}
procedure LWIP_ASSERT(const message: PChar; assertion: Boolean);
begin
  if not assertion then
    LWIP_PLATFORM_ASSERT(message);
end;
{$else}
procedure LWIP_ASSERT(const message: PChar; assertion: Boolean);
begin
  { nichts }
end;
{$endif}

{$ifdef LWIP_DEBUG}
procedure LWIP_PLATFORM_ERROR(const message: PChar);
begin
  LWIP_PLATFORM_DIAG(message);
end;

procedure LWIP_ERROR(const message: PChar; expression: Boolean; handler: TProc);
begin
  if not expression then
  begin
    LWIP_PLATFORM_ERROR(message);
    if Assigned(handler) then handler();
  end;
end;

procedure LWIP_DEBUGF(debug: Byte; message: PChar);
begin
  if ((debug and LWIP_DBG_ON) <> 0) and
     ((debug and LWIP_DBG_TYPES_ON) <> 0) and
     (SmallInt(debug and LWIP_DBG_MASK_LEVEL) >= LWIP_DBG_MIN_LEVEL) then
  begin
    LWIP_PLATFORM_DIAG(message);
    if ((debug and LWIP_DBG_HALT) <> 0) then
      while True do;
  end;
end;
{$else}
procedure LWIP_PLATFORM_ERROR(const message: PChar); inline;
begin
end;

procedure LWIP_ERROR(const message: PChar; expression: Boolean; handler: TProc); inline;
begin
end;

procedure LWIP_DEBUGF(debug: Byte; message: PChar); inline;
begin
end;
{$endif}

end.
