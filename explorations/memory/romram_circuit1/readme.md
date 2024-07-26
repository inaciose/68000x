# ROM & RAM circuit decoder

Este circuito foi implementado na main_control_board disponivel em: https://github.com/inaciose/68000x/tree/main/explorations/boards  

2x 39SF040, 2x512KB (one for even (low) and one for odd (upper))  
1x 74LS138  
2x 74LS32  
1x 74LS04  
  
  
# 74LS138  
A20 > A  
A21 > B  
A22 > C  
A23 > G2B_  
GND > G2A_  
5V  > G1    

ROMLOWCE = Y0 + LDS  
ROMUPCE = Y0 + UDS  
  
ROMOE = AS + not(RW)  

RAMLOWCE = Y1 + LDS  
RAMUPCE = Y1 + UDS  
  
RAMOE = AS + not(RW)  
RAMWE = AS + RW  

O 68000 é big endian, um long 0A 0B 0C 0D é armazenado da seguinte forma:  
  

# Teste ROM 1  

Foram gravadas duas ROMs com:  
0000  
8000  
0000  
0008  
303C  
...  
4EF8  
0008  

Não correu muito bem, pois não fez o loop que esperava.  

# Teste ROM 2
Usando a placa bus_rom_board.  
  
ROMLOWCE = Y0 + LDS  
ROMUPCE = Y0 + UDS  
  
ROMOE AS + not(RW)  

easybin: save as 2 files: 0, 1  
  
bin 0 go to high data bits  
bin 1 go to low data bits  

code   
00000000                             7      ORG     $0000  
00000000= 00AAFF00                   8      DC.L    $00aaff00  
00000004= 00000040                   9      DC.L    start  
00000040                            10      ORG     $0040  
00000040                            11  START:   
00000040  303C AAAA                 12      move.w  #$aaaa, d0  
00000044  33C0 00100000             14      move.w  d0, $100000  
0000004A  4640                      15      not.w   d0  
0000004C  4EF8 0040                 17      jmp     START  
00000050  FFFF FFFF                 22      SIMHALT  
00000054                            26      END    START

data LEDS  
0011  
h--l  
00AA  
FF00  
0000  
0040  
303C  
AAAA  
33C0  
0010  
0000  
4640  
4EF8  
0040  

Correu bem. Funcionou comforme esperado.

# teste RAM 1

ROM conforme teste ROM 2  

RAMLOWCE = Y1 + LDS  
RAMUPCE = Y1 + UDS  
  
RAMOE AS + not(RW) 
RAMWE AS + RW  

00000000                             7      ORG     $0000  
00000000= 00AAFF00                   8      DC.L    $00aaff00  
00000004= 00000040                   9      DC.L    start        
00000040                            10      ORG     $0040  
00000040                            11  START:  
00000040  303C AAAA                 12      move.w  #$aaaa, d0  
00000044  33C0 00100000             13      move.w  d0, $100000  
0000004A  4640                      14      not.w   d0  
0000004C  33C0 00100002             15      move.w  d0, $100002  
00000052  3239 00100000             16      move.w  $100000, d1  
00000058  3439 00100002             17      move.w  $100002, d2  
0000005E  7600                      18      move.l  #$00000000, d3  
00000060  2604                      19      move.l  d4, d3  
00000062  1639 00100000             20      move.b  $100000, d3  
00000068  1839 00100001             21      move.b  $100001, d4  
0000006E                            22      
0000006E  4EF8 0040                 23      jmp     START  
00000072  FFFF FFFF                 25      SIMHALT  
00000076                            29      END    START  

Correu bem. Funcionou comforme esperado.  
