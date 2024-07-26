# Memory, ROM, RAM, address decoding
Memória, ROM, RAM, descodificação de endereços (inclusive para periféricos).  

2 x 512KB ROM (SST39SF040) + 2 x 512KB RAM (AS6C4008)  

Sinais usados 
Endereço: A20, A21, A22, A24
Controlo: AS_, UDS_ LDS_, AS_

O sinal LDS_ fica activo os bits menos significativos, que correspondem aos bytes impares.
O sinal UDS_ fica activo os bits mais significativos, que correspondem aos bytes pares.

