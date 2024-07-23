# Monitor for 68K with MC68681 DUART
Este programa monitor foi feito com base no trabalho de ChartreuseK (link 1), alterado para funcionar com a DUART MC68681, ao qual acrescentei posteriormente a funcionalidade de enviar ficheiros com s records.  

# Ligações do MC68681 minimas necessárias para o funcionamento.
Esquema Schematic_68KMC68681_basic_2024-07-23.pdf disponivel em:
https://github.com/inaciose/68000x/tree/main/explorations/serial/MC68681

# Comandos do monitor
(E)xamine, (D)eposit, (L)load srec, (R)un, (H)elp  

nota: nos argumentos os H são digitos hexadecimais.  

(E)xamine  
eHHHHHH para um unico endereço.  
eHHHHHH; para vários endereços em linha (Enter avança uma linha, Space avança várias linhas).  

(D)eposit  
dHHHHHH HH  

(L)load srec
l (sem argumentos) permite o envio de ficheiros com srecords: S0, S1, S2 e S8.  
Ver informações sobre os programas terminais e o envio de ficheiros com srecords.  

(R)un  
rHHHHHH executa o programa com inicio na endereço de memória HHHHHH.  

(H)elp  
h exibe os comandos disponiveis. 

# memory map
ROM  
0x000000 - 0x0003FC - Vectors (have jumps to 0x100000 base, except the first two: SSP_ADDR e RESET  
0x000400 - 0x000ABA - ROM code (basic code that initialize the machine and implement the commands)  
0x000ABE - 0x000C67 - ROM data (strings)  
Free ROM until 0x0FFFFF  

RAM  
0x100000 - 0x1003FC - Vectors  
0x100400 - 0x100800 - Monitor variables space  
Free ram until stack pointer range  

0x1FFFAA - stack pointer top  
0x1FFFAA - 0x200000 - Monitor line buffer  


# Monitors sources

- 1) https://github.com/ChartreuseK/68k-Monitor (alterado para funcionar com a DUART MC68681 e teste na maquina ok)
- 2) https://github.com/jefftranter/68000/blob/master/monitor/ (codigo necessita de ser adaptado para o easy68k)
- 3) https://github.com/kanpapa/mic68k/tree/master/zbug (testado no simulador easy68K)

# Envio de ficheiros com S records
No windows utilizar o Teraterm (permite definir um delay por caracter).  
No linux usar o cutecom (sudo apt install cutecom)(permite definir um delay por caracter).  

