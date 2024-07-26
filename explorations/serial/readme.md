# serial / uart / acia

Primeira tentativa será com o ic MC68B50. A escolha deve-se a ter exemplo de inicialização em z80 assembly e ter menos pinos.  

Creio que o código nesta página é para o acia mc68b50, e se não for deve dar para adaptar. espero eu...   
https://github.com/kanpapa/mic68k/blob/master/zbug/zbug_mic68k.x68  

Esta página tem codigo para o acia mc68b50 com o circuito jefftranter-68000-mc68b50_circuit1   
https://github.com/jefftranter/68000/blob/master/testprog/trans.s  

Não consegui por a funcionar, e passei para a exploração do do MC68681.  
Consegui colocar o MC68681 a funcionar no modo mais simples (pooling).  
Adaptei o um programa monitor para a minha máquina.  
O programa monitor (monitorMC68681t1v1.S68) está disponivel em:  
https://github.com/inaciose/68000x/tree/main/explorations/monitors  
A versão 6 do programa monitor permite o envio de programas em srecords  
Consegui colocar a duart do MC68681 a funcionar com interrupts. O programa foi feito tem C. Ver https://github.com/inaciose/m68k_bare_metal  
  
