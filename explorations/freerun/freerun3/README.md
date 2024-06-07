# Circuito de teste free run para o motorola 68000, v 3.0
Relativamente á antiga versão foi acrescentado o circuito de dtack single step, e os três circuitos foram consolidados numa placa perfurada que denominei de basic_control_board.

![alt text](https://github.com/inaciose/68000x/blob/main/explorations/freerun/freerun3/freerun3_full-view1.jpeg?raw=true) 

Composto por cpu, com os pull ups nos sinais requeridos, e circuitos de clock (em bb), halt & reset (em bb), dtack single step ou grounded (jumper select), e leds (em modo contador se estiver funcional).  
  
Neste circuito, os cpu e os pullups, estão na cpu_bord v1.0, e os leds estão numa breadboard.  
![alt text](https://github.com/inaciose/68000x/blob/main/explorations/freerun/freerun1/freerun_circuit1.jpg?raw=true)  
  
# clock circuit
![alt text](https://github.com/inaciose/68000x/blob/main/explorations/clock/basic-2pin-crystal/basic-rc2014-clock1.jpg?raw=true)  
  
# halt & reset circuit
![alt text](https://github.com/inaciose/68000x/blob/main/explorations/reset/68kmyreset1/68kmyreset1.png?raw=true)  
  
# dtack
![alt text](https://github.com/inaciose/68000x/blob/main/explorations/dtack/68kmydtackpss1/68kmydtackpss1.png?raw=true)  
  
# resultado
Funcional.  
  
# notas sobre a alimentação
Com o interruptor de alimentação na imagem abaixo, a fonte de alimentação exibia 0.22A de corrente e as tensões (para 5V in) foram as seguintes:  
- placa de controlo basico: 4.78V
- breadboard leds: 4.65
  
Sem interruptor, ou seja só os jacarés a ligar (imagem abaixo), a fonte de alimentação exibia 0.23A de corrente e as tensões (para 5V in) foram as seguintes:
- placa de controlo basico: 4.99V
- breadboard leds: 4.85V

![alt text](https://github.com/inaciose/68000x/blob/main/explorations/freerun/freerun3/interruptor_quebra_tensao.jpeg?raw=true)  
![alt text](https://github.com/inaciose/68000x/blob/main/explorations/freerun/freerun3/jacaredirecto_ok.jpeg?raw=true)  

