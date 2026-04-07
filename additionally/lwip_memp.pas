unit lwip_memp;

{$mode objfpc}{$H+}

interface

uses
  lwip_opt;



type
  memp_t = (
    MEMP_RAW_PCB,
    MEMP_UDP_PCB,
    MEMP_TCP_PCB,
    MEMP_TCP_SEG,
    MEMP_NETBUF,
    MEMP_NETCONN,
    MEMP_TCPIP_MSG_API,
    MEMP_TCPIP_MSG_INPKT,
    MEMP_MAX
  );

type
  Pmemp_desc = ^memp_desc;

  memp_desc = record
    desc   : PChar;
    size   : Word;
    num    : Word;
    base   : Pointer;
    tab    : Pointer;
  end;

var
  memp_pools : array[0..Ord(MEMP_MAX)-1] of Pmemp_desc;

{ API }

procedure memp_init;

function memp_malloc(t : memp_t): Pointer;

procedure memp_free(t : memp_t; mem : Pointer);

{ Pool helper macros als Funktionen }

procedure LWIP_MEMPOOL_INIT(desc : Pmemp_desc); inline;

function LWIP_MEMPOOL_ALLOC(desc : Pmemp_desc): Pointer; inline;

procedure LWIP_MEMPOOL_FREE(desc : Pmemp_desc; mem : Pointer); inline;

{$if MEM_USE_POOLS}
type
  memp_malloc_helper = record
    poolnr : memp_t;
    {$if (MEMP_OVERFLOW_CHECK) or (LWIP_STATS and MEM_STATS)}
    size : u16_t;
    {$endif}
  end;
{$endif}

implementation


procedure memp_init;
begin
  { Initialisierung der Pools erfolgt normalerweise in memp.c }
end;

function memp_malloc(t : memp_t): Pointer;
begin
  { einfache Heap-Implementierung als Platzhalter }
  Result := nil;
end;

procedure memp_free(t : memp_t; mem : Pointer);
begin
end;

procedure LWIP_MEMPOOL_INIT(desc : Pmemp_desc); inline;
begin
  { entspricht memp_init_pool }
end;

function LWIP_MEMPOOL_ALLOC(desc : Pmemp_desc): Pointer; inline;
begin
  Result := memp_malloc(MEMP_MAX);
end;

procedure LWIP_MEMPOOL_FREE(desc : Pmemp_desc; mem : Pointer); inline;
begin
  memp_free(MEMP_MAX, mem);
end;

end.
