# Placa base de cpu MC68000 / MC681000
# Ver. 1.0

A placa contem o cpu, os pull ups nos sinais requeridos, pinos de acesso a todos os sinais do processador (bus expansão horizontal e vertical)  
e 4 conjuntos especificos de pinos para ligar:  
- a alimentação (5V), 
- circuito de clock, 
- circuito de halt & reset. 
- circuito dtack.

Execução do circuito em placa perfurada para o CPU e ligações aos seus sinais a foi feita em duas fases.  
  
1) efectuado todo o circuito excepto o bus de expansão de 80 pinos hroziontal (a 90 graus)
2) efectuado o bus de expansão de 80 pinos horizontal
  
![alt text](https://github.com/inaciose/68000x/blob/main/explorations/boards/cpu_board/68kcpu_board_full_top_view_with_zif1.jpeg?raw=true)  
  

# bus expansão horizontal
![alt text](https://github.com/inaciose/68000x/blob/main/explorations/boards/cpu_board/68kcpu_board_full_expansion_bus_con1.jpeg?raw=true)  
  
  
# ligações auxiliares
![alt text](https://github.com/inaciose/68000x/blob/main/explorations/boards/cpu_board/68kcpu_board_basic_connectors1.jpeg?raw=true)  
  
  
# notas da fase 2
Outras imagens da placa já com o bus de expensão horizontal
![alt text](https://github.com/inaciose/68000x/blob/main/explorations/boards/cpu_board/68kcpu_board_full_top_view1.jpeg?raw=true)  
  
![alt text](https://github.com/inaciose/68000x/blob/main/explorations/boards/cpu_board/68kcpu_board_full_bottom_view1.jpeg?raw=true)  

  
Teste freerun  
![alt text](https://github.com/inaciose/68000x/blob/main/explorations/boards/cpu_board/68kcpu_board_full_top_view_with_expansion_freerun1.jpeg?raw=true)  
  
  
Exemplo da placa de expansão prevista  
![alt text](https://github.com/inaciose/68000x/blob/main/explorations/boards/cpu_board/68kcpu_board_full_top_view_with_expansion1.jpeg?raw=true)  

# notas fase 1
A placa está funcional e já foi testada num circuito freerun, mas precisa de ser melhorada  
  
![alt text](https://github.com/inaciose/68000x/blob/main/explorations/boards/cpu_board/68kcpu_board_top_view_with_zif1.jpeg?raw=true)  
