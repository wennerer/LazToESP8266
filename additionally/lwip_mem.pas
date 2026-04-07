unit lwip_mem;

{$mode objfpc}{$H+}

interface

uses
  lwip_opt
  {$ifDEF MEM_LIBC_MALLOC}
  , lwip_arch
  {$endif};

type
  u16_t = Word;

type

{$if MEM_LIBC_MALLOC}

  mem_size_t = SizeUInt;

{$elseif MEM_USE_POOLS}

  mem_size_t = u16_t;

{$else}

  {$if MEM_SIZE > 64000}
  mem_size_t = u32_t;
  {$else}
  mem_size_t = u16_t;
  {$endif}

{$endif}

procedure mem_init;

function mem_trim(mem: Pointer; size: mem_size_t): Pointer;

function mem_malloc(size: mem_size_t): Pointer;

function mem_calloc(count: mem_size_t; size: mem_size_t): Pointer;

procedure mem_free(mem: Pointer);

implementation

procedure mem_init;
begin
end;

function mem_trim(mem: Pointer; size: mem_size_t): Pointer;
begin
  Result := mem;
end;

function mem_malloc(size: mem_size_t): Pointer;
begin
  GetMem(Result, size);
end;

function mem_calloc(count: mem_size_t; size: mem_size_t): Pointer;
var
  total: mem_size_t;
begin
  total := count * size;
  GetMem(Result, total);
  if Result <> nil then
    FillChar(Result^, total, 0);
end;

procedure mem_free(mem: Pointer);
begin
  if mem <> nil then
    FreeMem(mem);
end;

end.
