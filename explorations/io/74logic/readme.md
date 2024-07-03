# 68K output using only 74 series logic ICs
  
# 78LS138  
A20 - A  
A21 - B  
A22 - C  
AS - G2B_  
RW - G2A_  
A13 - G1  
  
Y0 - $800000  
Y1 - $9x...  
Y7 - $fx...  
  
Using Y0  
  
# 74LS273  
  
pin1 *-IC  
  
RST - CLR_  
LED0 - q1  
d0 - d1  
d1 - d2  
LED1 - q2  
LED2 - q3  
d2 - d3  
d3 - d4  
LED3 - q4  
GND - GND  
  
pin11 *-IC  
  
VCC - VCC  
LED7 - q8  
d7 - d8  
d6 - d7  
LED6 - q7  
LED5 - q6  
d5 - d6  
d4 - d5  
LED4 - q5  
Y0 - CLK  


# test code
<code>
    ORG     $0000
    DC.L    $00aaff00
    DC.L    start       
    ORG     $0040
START:
    move.w  #$aaf0, d0
    move.w  d0, $100000
    not.w   d0
    move.w  d0, $100002
    move.w  $100000, d1
    move.w  $100002, d2
    
    move.b  d1, $800000
    move.b  d2, $800000
    
    jmp     START
</code>
