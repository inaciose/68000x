# 68000 dtack circuits

Opções disponiveis:
- a) dtack_singlestep1.jpg
- b) jtsiomb-m68kcomputer-dtack1.jpg
- c) dtack grounded

No circuito de teste freerun foi usado o dtack grounded.

Quando coloquei o serial io com o MC68681, deixei de usar o dtack ligado ao gnd, 
e passei a usar um 74LS11, que tem 3 triplos ANDs, para fazer o AND aos sinais 
dos decoders da ROM, RAM, IO (digital output on leds), serial.

Li que é preferivel usar ICs com open colector, presumo para expansibilidade 
facilitada, já que o open colector é o que permite não ter uma gate and para 
misturar dois sinais de output.
