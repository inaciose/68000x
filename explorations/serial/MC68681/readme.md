# interfacing 68000 with 68681

# Block 1 - Simple, one uart, no interrupts  

Testado e a funcionar com o programa acima (MC68681test.X68)  

MC68681  

A1 - RS1 (1)  
nc - IP3  
A2 - RS2  
nc - IP1  
A3 - RS3 (5)  
A4 - RS4  
CTS? - IP0  
RW - RW  
DTC - DTACK_  
nc - RxDB (10)  
nc - TxDB  
nc - OP1  
nc - OP3  
nc - OP5  
nc - OP7 (15)  
D1 - D1  
D3 - D3  
D5 - D5  
D7 - D7  
GND - GND  (20)  

nota:  
DTC (74LS11) é o input do AND triplo (74LS11) que recebe o resultado do AND das saidas usadas dos decoders da ROM, RAM e Digital Output (IO).  
  
VCC - VCC (40)  
nc - IP4  
nc - IP5  
pu - IACK_  
nc - IP2  
SCS - CS_ (35)  
RESET_ - RESET  
GND - X2  
SCLK - X1  
RX - RxDA  
TX - TxDA (30)  
RTS - OP0  
nc - OP2  
nc - OP4  
nc - OP6  
D0 - D0 (25)  
D2 - D2  
D4 - D4  
D6 - D6  
nc - IRQ_ (21)  

notas: 
pu = pullup
SCS (74LS138) saida Y0  

74LS128  

A20 - A (1)  
A21 - B  
A22 - C  
G2B_ - LDS_  
G2A_ - AS_ (5)  
G1 - A23  
nc - Y7  
GND - GND (8)  

VCC - VCC  (16)  
nc - Y0  
SCS - Y1  (14)  
nc - Y2  
nc - Y3  
nc - Y4  
nc - Y5  
nc - Y6  (9)  




