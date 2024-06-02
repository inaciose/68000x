# Circuito de teste free run para o motorola 68000, v 1.0
Composto por cpu, com os pull ups nos sinais requeridos, e circuitos de clock (em bb), halt & reset (em bb), dtack grounded e leds (em modo contador se estiver funcional).  

Neste circuito, os cpu e os pullups, estão na cpu_bord v1.0, e os leds estão numa breadboard.  
![alt text](https://github.com/inaciose/68000x/blob/main/explorations/freerun/freerun1/freerun_circuit1.jpg?raw=true)

# clock circuit
![alt text](https://github.com/inaciose/68000x/blob/main/explorations/clock/basic-2pin-crystal/basic-rc2014-clock1.jpg?raw=true)

# halt & reset circuit
![alt text](https://github.com/inaciose/68000x/blob/main/explorations/reset/jtsiomb-m68kcomputer/jtsiomb-m68kcomputer-reset1.jpg?raw=true)

# dtack
dtack grounded

Imagem de conjunto do circuito a funcionar.  
![alt text](https://github.com/inaciose/68000x/blob/main/explorations/freerun/freerun1/68kcpu_freerun_test_bb_signals1.jpeg?raw=true)

Funcional Depois de ligado, é necessário presionar o botao de reset, para o cpu funcionar.  
O circuito de reset deveria manter os pinos halt e reset em low durante os primeiros 500ms após ligar. (Power on reset)  

