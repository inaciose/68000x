# Circuito de teste free run para o motorola 68000, v 2.0
Relativamente a antiga versão só mudou o circuito de reset.  
Composto por cpu, com os pull ups nos sinais requeridos, e circuitos de clock (em bb), halt & reset (em bb), dtack grounded e leds (em modo contador se estiver funcional).  
  
Neste circuito, os cpu e os pullups, estão na cpu_bord v1.0, e os leds estão numa breadboard.  
![alt text](https://github.com/inaciose/68000x/blob/main/explorations/freerun/freerun1/freerun_circuit1.jpg?raw=true)  
  
# clock circuit
![alt text](https://github.com/inaciose/68000x/blob/main/explorations/clock/basic-2pin-crystal/basic-rc2014-clock1.jpg?raw=true)  
  
# halt & reset circuit
![alt text](https://github.com/inaciose/68000x/blob/main/explorations/reset/68kmyreset1/68kmyreset1.png?raw=true)  
  
# dtack
dtack grounded  
  
# resultado
Funcional. Depois de ligado já nao é necessário presionar o botao de reset, para o cpu funcionar correctamente.  

Video no youtube  
https://www.youtube.com/watch?v=SkNNHJoEbwY  
  

