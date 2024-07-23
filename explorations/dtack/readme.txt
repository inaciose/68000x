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

Se não usarmos um IC com open colector, e complicar a expansão, podemos usar
um 74LS11, que tem 3 gates and com 3 entrada cada, para desenhar um sistema com:
- uma entrada com o sinal de cs da rom
- uma entrada com o sinal de cs da ram
- uma entrada com o sinal de cs do digital output (leds) 
- a saida desta gate alimenta duas entradas de outro triplo and
- a outra entrada com o sinal de dtack do mc68681
- expandir implica: - colocar um jumper para HIGH numa entrada e leva-la a um user pin no bus

Estive a verificar e não vi nenhuma versão do 74LS11 com open collector que facilitaria
a transição. por isso pelo vou manter esta solução, na primeira perfboard com os
circuitos de controlo da ROM, RAM, DOUT e DUART.

