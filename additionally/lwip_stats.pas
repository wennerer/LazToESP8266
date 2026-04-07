unit lwip_stats;

{$mode objfpc}{$H+}

interface

uses
  lwip_opt, lwip_mem, lwip_memp;

type
  u8_t  = Byte;
  u16_t = Word;
  u32_t = Cardinal;

type
{$ifDef LWIP_STATS_LARGE}
  STAT_COUNTER = u32_t;
{$else}
  STAT_COUNTER = u16_t;
{$endif}

type
  stats_proto = record
    xmit     : STAT_COUNTER;
    recv     : STAT_COUNTER;
    fw       : STAT_COUNTER;
    drop     : STAT_COUNTER;
    chkerr   : STAT_COUNTER;
    lenerr   : STAT_COUNTER;
    memerr   : STAT_COUNTER;
    rterr    : STAT_COUNTER;
    proterr  : STAT_COUNTER;
    opterr   : STAT_COUNTER;
    err      : STAT_COUNTER;
    cachehit : STAT_COUNTER;
  end;

  stats_igmp = record
    xmit        : STAT_COUNTER;
    recv        : STAT_COUNTER;
    drop        : STAT_COUNTER;
    chkerr      : STAT_COUNTER;
    lenerr      : STAT_COUNTER;
    memerr      : STAT_COUNTER;
    proterr     : STAT_COUNTER;
    rx_v1       : STAT_COUNTER;
    rx_group    : STAT_COUNTER;
    rx_general  : STAT_COUNTER;
    rx_report   : STAT_COUNTER;
    tx_join     : STAT_COUNTER;
    tx_leave    : STAT_COUNTER;
    tx_report   : STAT_COUNTER;
  end;

  stats_mem = record
  {$if defined(LWIP_DEBUG) or defined(LWIP_STATS_DISPLAY)}
    name : PChar;
  {$endif}
    err     : STAT_COUNTER;
    avail   : mem_size_t;
    used    : mem_size_t;
    max     : mem_size_t;
    illegal : STAT_COUNTER;
  end;

  stats_syselem = record
    used : STAT_COUNTER;
    max  : STAT_COUNTER;
    err  : STAT_COUNTER;
  end;

  stats_sys = record
    sem   : stats_syselem;
    mutex : stats_syselem;
    mbox  : stats_syselem;
  end;

  stats_mib2 = record
    ipinhdrerrors     : u32_t;
    ipinaddrerrors    : u32_t;
    ipinunknownprotos : u32_t;
    ipindiscards      : u32_t;
    ipindelivers      : u32_t;
    ipoutrequests     : u32_t;
    ipoutdiscards     : u32_t;
    ipoutnoroutes     : u32_t;
    ipreasmoks        : u32_t;
    ipreasmfails      : u32_t;
    ipfragoks         : u32_t;
    ipfragfails       : u32_t;
    ipfragcreates     : u32_t;
    ipreasmreqds      : u32_t;
    ipforwdatagrams   : u32_t;
    ipinreceives      : u32_t;

    tcpactiveopens    : u32_t;
    tcppassiveopens   : u32_t;
    tcpattemptfails   : u32_t;
    tcpestabresets    : u32_t;
    tcpoutsegs        : u32_t;
    tcpretranssegs    : u32_t;
    tcpinsegs         : u32_t;
    tcpinerrs         : u32_t;
    tcpoutrsts        : u32_t;

    udpindatagrams    : u32_t;
    udpnoports        : u32_t;
    udpinerrors       : u32_t;
    udpoutdatagrams   : u32_t;

    icmpinmsgs        : u32_t;
    icmpinerrors      : u32_t;
    icmpindestunreachs: u32_t;
    icmpintimeexcds   : u32_t;
    icmpinparmprobs   : u32_t;
    icmpinsrcquenchs  : u32_t;
    icmpinredirects   : u32_t;
    icmpinechos       : u32_t;
    icmpinechoreps    : u32_t;
    icmpintimestamps  : u32_t;
    icmpintimestampreps : u32_t;
    icmpinaddrmasks   : u32_t;
    icmpinaddrmaskreps: u32_t;
    icmpoutmsgs       : u32_t;
    icmpouterrors     : u32_t;
    icmpoutdestunreachs : u32_t;
    icmpouttimeexcds  : u32_t;
    icmpoutechos      : u32_t;
    icmpoutechoreps   : u32_t;
  end;

type
  stats_ = record
  {$if LINK_STATS}
    link : stats_proto;
  {$endif}
  {$if IP_STATS}
    ip : stats_proto;
  {$endif}
  {$if TCP_STATS}
    tcp : stats_proto;
  {$endif}
  {$if UDP_STATS}
    udp : stats_proto;
  {$endif}
  {$if MEM_STATS}
    mem : stats_mem;
  {$endif}
  {$if SYS_STATS}
    sys : stats_sys;
  {$endif}
  {$if MIB2_STATS}
    mib2 : stats_mib2;
  {$endif}
  end;

var
  lwipstats : stats_;

procedure stats_init;

procedure STATS_INC(var x : STAT_COUNTER); inline;
procedure STATS_DEC(var x : STAT_COUNTER); inline;

implementation

procedure STATS_INC(var x : STAT_COUNTER); inline;
begin
  Inc(x);
end;

procedure STATS_DEC(var x : STAT_COUNTER); inline;
begin
  Dec(x);
end;

procedure stats_init;
begin
  FillChar(lwipstats, SizeOf(lwipstats), 0);
end;

end.
