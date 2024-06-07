# 68K basic control board
Esta placa inclui os circuitos de relógio, reset & halt, e dtack single step.  
Foi feita para substituir as duas breadboards que continham os três circuitos acima.  
  
![alt text](https://github.com/inaciose/68000x/blob/main/explorations/boards/basic_control_board/basic_control_board_topview1.jpeg?raw=true)  

# circuito
Esta placa contem os seguintes circuitos préviamente testados em breadboard:  
- clock/basic-2pin-crystal
- reset/68kmyreset1
- dtack/68kmydtackpss1

A placa tem jumpers para selecionar quais os sinais que são passados para o cpu bus, e dois botões de controlo de reset e dtack single step.
Também tem os terminais para a alimentação de 5V, e dois terminais (pinos dupon) para alimentação de outro circuito directamente (no centro perto do connector com a cpu_board).  

# Botões de controlo
- Do lado direito tem o butão de reset, e o led de halt (quando o sinal de halt está high, que é a situação normal, o led está acesso).  
- Do lado esquerdo tem o botão de dtack single step.  

# Jumpers de configuração
Do lado esquerdo tem os pinos que permitem configurar com um jump o sinal dtack passado para a cpu board
- jumper para a direita dtack single step
- junper para a esquerda dtack grounded
- sem jumper, dtack gerido noutro circuito
  
Ao centro tem o jumper que seleciona a passagem ou não do sinal de clock para cpu board.  
- Se estiver colocado o sinal de clock é passado para a cpu board
- Se não estiver colocado, o sinal de clock tem de ser gerado noutro circuito.

Do lado direito tem os jumpers que permitem a passagem ou não do sinal de reset e halt
- Se estiverem colocados os sinais passam para a cpu board.  
- caso não estiverem colocados estes sinais tem de ser gerados em outro circuito.

  
