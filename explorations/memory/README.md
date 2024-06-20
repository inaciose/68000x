# Memory, ROM, RAM, address decoding
Memória, ROM, RAM, descodificação de endereços

# rosco-m68k
https://github.com/rosco-m68k/rosco_m68k/blob/develop/design/r2/kicad/rosco_m68k.pdf  
  
A descodificação de endereços e outra logica adicional é efectuada em 4 PAL ATF22V10C.  
  
512K ROM + 512K RAM  
  
- 2 X ROM SST39SF040  

ROM U1 SST39SF040 
D0 > D0 : D7 > D7
A1 > A0 : A19 > A18  
ODDROMSEL > CE  
WR > OE  

ROM U2 SST39SF040 
D0 > D0 : D8 > D15
A1 > A0 : A19 > A18  
EVENROMSEL > CE  
WR > OE  

- 2 X RAM AS6C4008  

RAM U3 AS6C4008  
D0 > D0 : D7 > D7  
A1 > A0 : A19 > A18  
ODDRAMSEL > CE  
WR > OE  
RW > WE  
  
2 RAM 44 AS6C4008  
D0 > D0 : D8 > D15  
A1 > A0 : A19 > A18  
EVENRAMSEL > CE  
WR > OE  
RW > WE  

ODDROMSEL, EVENROMSEL, ODDRAMSEL, EVENRAMSEL e WR, são gerados por um PAL (IC2 ATF22V10C), que gera também: IOSEL, EXPSEL, e DTACK?
O IC2 tem como input os seguintes sinais básicos: A18-A23, LDS, UDS, AS e RW, assim como BOOT (IC5), CPUSP (IC5), e LGEXP (jumper vcc?gnd)
(verificar programa do PAL)

# Rosco hackday
https://hackaday.io/project/164305-roscom68k/log/162200-the-address-decoder
(eventualmente mais tarde)

# jtsiomb-m68kcomputer

8K ROM + 128K RAM

2 X AT28C64

ROM U9 AT28C64
  
D0 > D0 : D7 > D7  
A1 > A0 : A13 > A12  
VCC > WE  
ROMEN > CE  
AS > OE  

ROM U13 AT28C64
  
D0 > D0 : D8 > D15  
A1 > A0 : A13 > A12  
VCC > WE  
ROMEN > CE  
AS > OE  

4 X UM61512  
  
RAM U10 UM61512  
D0 > D0 : D0 > D7  
A1 > A0 : A16 > A15  
RD > OE 
WR > WE
CE1 > RAMEN + LDS
CE2 > !A17

RAM U15 UM61512  
D0 > D0 : D8 > D15  
A1 > A0 : A16 > A15  
RD > OE 
WR > WE
CE1 > RAMEN + UDS
CE2 > !A17

RAM U11 UM61512  
D0 > D0 : D7 > D7  
A1 > A0 : A16 > A15  
RD > OE 
WR > WE
CE1 > RAMEN + LDS
CE2 > A17

RAM U16 UM61512  
D0 > D0 : D8 > D15  
A1 > A0 : A16 > A15  
RD > OE 
WR > WE
CE1 > RAMEN + UDS
CE2 > A17

