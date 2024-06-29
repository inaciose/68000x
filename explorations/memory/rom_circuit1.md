# ROM circuit decoder

2x 39SF040, 2x512KB (one for even (low) and one for odd (upper))  
1x 74LS138  
1x 74LS32  
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
  
ROMOE AS + not(RW)  
  
O 68000 é big endian, um long 0A 0B 0C 0D é armazenado da seguinte forma:  
  
end + 0 = 0A  
end + 1 = 0B  
end + 2 = 0C  
end + 3 = 0D  
  
end + 0 = 0A 0B  
end + 2 = 0C 0D  

# Teste 1  

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


