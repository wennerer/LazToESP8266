unit lwip_pbuf;

{$mode objfpc}{$H+}
{$PACKRECORDS C}

interface

uses
  lwip_opt, lwip_err;

//wird in esp_netif aufgerufen!
//{$IFDEF FPC}
//{$LINKLIB lwip}
//{$ENDIF}

type
  u8_t  = Byte;
  u16_t = Word;
  s16_t = SmallInt;
  size_t = NativeUInt;

const
  PBUF_TRANSPORT_HLEN = 20;
  {$IFDEF LWIP_IPV6}
  PBUF_IP_HLEN        = 40;
  {$else}
  PBUF_IP_HLEN        = 20;
  {$ENDIF}


type
  pbuf_layer = Integer;
const
  PBUF_RAW       = 0;
  PBUF_RAW_TX    = PBUF_LINK_ENCAPSULATION_HLEN;
  PBUF_LINK      = PBUF_LINK_ENCAPSULATION_HLEN + PBUF_LINK_HLEN;
  PBUF_IP        = PBUF_LINK + PBUF_IP_HLEN;
  PBUF_TRANSPORT = PBUF_IP + PBUF_TRANSPORT_HLEN;


const
  PBUF_TYPE_FLAG_STRUCT_DATA_CONTIGUOUS = $80;
  PBUF_TYPE_FLAG_DATA_VOLATILE          = $40;
  PBUF_TYPE_ALLOC_SRC_MASK              = $0F;
  PBUF_ALLOC_FLAG_RX                     = $0100;
  PBUF_ALLOC_FLAG_DATA_CONTIGUOUS        = $0200;

  PBUF_TYPE_ALLOC_SRC_MASK_STD_HEAP      = $00;
  PBUF_TYPE_ALLOC_SRC_MASK_STD_MEMP_PBUF = $01;
  PBUF_TYPE_ALLOC_SRC_MASK_STD_MEMP_PBUF_POOL = $02;

  PBUF_FLAG_PUSH      = $01;
  PBUF_FLAG_IS_CUSTOM = $02;
  PBUF_FLAG_MCASTLOOP = $04;
  PBUF_FLAG_LLBCAST   = $08;
  PBUF_FLAG_LLMCAST   = $10;
  PBUF_FLAG_TCP_FIN   = $20;

type
  pbuf_type = integer;

const
 PBUF_RAM    = PBUF_ALLOC_FLAG_DATA_CONTIGUOUS or PBUF_TYPE_FLAG_STRUCT_DATA_CONTIGUOUS or PBUF_TYPE_ALLOC_SRC_MASK_STD_HEAP;
 PBUF_ROM_T  = PBUF_TYPE_ALLOC_SRC_MASK_STD_MEMP_PBUF;
 PBUF_REF_T  = PBUF_TYPE_FLAG_DATA_VOLATILE or PBUF_TYPE_ALLOC_SRC_MASK_STD_MEMP_PBUF;
 PBUF_POOL   = PBUF_ALLOC_FLAG_RX or PBUF_TYPE_FLAG_STRUCT_DATA_CONTIGUOUS or PBUF_TYPE_ALLOC_SRC_MASK_STD_MEMP_PBUF_POOL;


type
  LWIP_PBUF_REF_T = u16_t;

  pbuf = record
    next: ^pbuf;
    payload: Pointer;
    tot_len: u16_t;
    len: u16_t;
    type_internal: u8_t;
    flags: u8_t;
    ref: LWIP_PBUF_REF_T;
    if_idx: u8_t;
    {$IFDEF ESP_PBUF}
    l2_owner: Pointer; // ^netif
    l2_buf: Pointer;
    {$ENDIF}
  end;
  Ppbuf = ^pbuf;


  pbuf_rom = record
    next: ^pbuf;
    payload: Pointer;
  end;


{$IFDEF LWIP_SUPPORT_CUSTOM_PBUF}
  pbuf_free_custom_fn = procedure(p: Ppbuf); cdecl;

  pbuf_custom = record
    pbuf: pbuf;
    custom_free_function: pbuf_free_custom_fn;
  end;
  Ppbuf_custom = ^pbuf_custom;
{$ENDIF}

{$IFNDEF PBUF_POOL_FREE_OOSEQ}
const
  PBUF_POOL_FREE_OOSEQ = 1;
{$ENDIF}

{$IF LWIP_TCP and TCP_QUEUE_OOSEQ and NO_SYS and PBUF_POOL_FREE_OOSEQ}
var
  pbuf_free_ooseq_pending: u8_t; // volatile

procedure pbuf_free_ooseq; cdecl;
procedure PBUF_CHECK_FREE_OOSEQ;
{$ELSE}
procedure PBUF_CHECK_FREE_OOSEQ; inline;
{$ENDIF}

procedure pbuf_init; inline;

function pbuf_alloc(l: pbuf_layer; length: u16_t; t: pbuf_type): Ppbuf; cdecl;external;
function pbuf_alloc_reference(payload: Pointer; length: u16_t; t: pbuf_type): Ppbuf; cdecl;external;
{$IFDEF LWIP_SUPPORT_CUSTOM_PBUF}
function pbuf_alloced_custom(l: pbuf_layer; length: u16_t; t: pbuf_type;
                             p: Ppbuf_custom; payload_mem: Pointer; payload_mem_len: u16_t): Ppbuf; cdecl;external;
{$ENDIF}

procedure pbuf_realloc(p: Ppbuf; size: u16_t); cdecl;external;

function pbuf_get_allocsrc(p: Ppbuf): u8_t; inline;
function pbuf_match_allocsrc(p: Ppbuf; t: u8_t): Boolean; inline;
function pbuf_match_type(p: Ppbuf; t: u8_t): Boolean; inline;

function pbuf_header(p: Ppbuf; header_size: s16_t): u8_t; cdecl;external;
function pbuf_header_force(p: Ppbuf; header_size: s16_t): u8_t; cdecl;external;
function pbuf_add_header(p: Ppbuf; header_size_increment: size_t): u8_t; cdecl;external;
function pbuf_add_header_force(p: Ppbuf; header_size_increment: size_t): u8_t; cdecl;external;
function pbuf_remove_header(p: Ppbuf; header_size: size_t): u8_t; cdecl;external;
function pbuf_free_header(q: Ppbuf; size: u16_t): Ppbuf; cdecl;external;

procedure pbuf_ref(p: Ppbuf); cdecl;external;

function pbuf_free(p: Ppbuf): u8_t; cdecl;external;
function pbuf_clen(const p: Ppbuf): u16_t; cdecl;external;

procedure pbuf_cat(head, tail: Ppbuf); cdecl;external;
procedure pbuf_chain(head, tail: Ppbuf); cdecl;external;
function pbuf_dechain(p: Ppbuf): Ppbuf; cdecl;external;

function pbuf_copy(p_to: Ppbuf; const p_from: Ppbuf): err_t; cdecl;external;
function pbuf_copy_partial(const p: Ppbuf; dataptr: Pointer; len, offset: u16_t): u16_t; cdecl;external;
function pbuf_get_contiguous(const p: Ppbuf; buffer: Pointer; bufsize: size_t; len, offset: u16_t): Pointer; cdecl;external;

function pbuf_take(buf: Ppbuf; const dataptr: Pointer; len: u16_t): err_t; cdecl;external;
function pbuf_take_at(buf: Ppbuf; const dataptr: Pointer; len, offset: u16_t): err_t; cdecl;external;

function pbuf_skip(inp: Ppbuf; in_offset: u16_t; out out_offset: u16_t): Ppbuf; cdecl;external;
function pbuf_coalesce(p: Ppbuf; layer: pbuf_layer): Ppbuf; cdecl;external;
function pbuf_clone(l: pbuf_layer; t: pbuf_type; p: Ppbuf): Ppbuf; cdecl;external;

{$IFDEF LWIP_CHECKSUM_ON_COPY}
function pbuf_fill_chksum(p: Ppbuf; start_offset: u16_t; const dataptr: Pointer;
                           len: u16_t; chksum: PWord): err_t; cdecl;external;
{$ENDIF}

{$IFDEF LWIP_TCP}
{$IFDEF TCP_QUEUE_OOSEQ}
{$IFDEF LWIP_WND_SCALE}
procedure pbuf_split_64k(p: Ppbuf; rest: PPpbuf); cdecl;external;
{$ENDIF}
{$ENDIF}
{$ENDIF}

function pbuf_get_at(const p: Ppbuf; offset: u16_t): u8_t; cdecl;external;
function pbuf_try_get_at(const p: Ppbuf; offset: u16_t): Integer; cdecl;external;
procedure pbuf_put_at(p: Ppbuf; offset: u16_t; data: u8_t); cdecl;external;
function pbuf_memcmp(const p: Ppbuf; offset: u16_t; const s2: Pointer; n: u16_t): u16_t; cdecl;external;
function pbuf_memfind(const p: Ppbuf; const mem: Pointer; mem_len, start_offset: u16_t): u16_t; cdecl;external;
function pbuf_strstr(const p: Ppbuf; const substr: PChar): u16_t; cdecl;external;

implementation

{$IF LWIP_TCP and TCP_QUEUE_OOSEQ and NO_SYS and PBUF_POOL_FREE_OOSEQ}
procedure PBUF_CHECK_FREE_OOSEQ;
begin
  if pbuf_free_ooseq_pending <> 0 then
    pbuf_free_ooseq;
end;
{$ELSE}
procedure PBUF_CHECK_FREE_OOSEQ;
begin
end;
{$ENDIF}

procedure pbuf_init;
begin
  // empty for now
end;

function pbuf_get_allocsrc(p: Ppbuf): u8_t;
begin
  Result := p^.type_internal and PBUF_TYPE_ALLOC_SRC_MASK;
end;

function pbuf_match_allocsrc(p: Ppbuf; t: u8_t): Boolean;
begin
  Result := pbuf_get_allocsrc(p) = (t and PBUF_TYPE_ALLOC_SRC_MASK);
end;

function pbuf_match_type(p: Ppbuf; t: u8_t): Boolean;
begin
  Result := pbuf_match_allocsrc(p, t);
end;

end.
