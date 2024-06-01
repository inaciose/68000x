# 68000 clock circuits
Os circuitos de clock foram experimentados em várias fases.  
Na primeira fase (escolha para circuito teste freerun1):  
- a) basic 4pin crystal clock
- b) basic rc2014 clock

Segunda fase (avaliação de alternativas)
- c) basic 4pin crystal clock
- d) rosco m68kcomputer clock (variation of 4pin crystal clock)

# a) roscom68k hackday clock  
Testado em breadboard, foto sinal no dso
![alt text](https://github.com/inaciose/68000x/blob/main/explorations/clock/roscom68k-hackday-clock1.jpg?raw=true)
![alt text](https://github.com/inaciose/68000x/blob/main/explorations/clock/roscom68k-hackday-clock1-bb1.jpeg?raw=true)
![alt text](https://github.com/inaciose/68000x/blob/main/explorations/clock/roscom68k-hackday-clock1-bb1-signal1.jpeg?raw=true)

# b) basic rc2014 clock  
Testado em breadboard, foto sinal no dso  
![alt text](https://github.com/inaciose/68000x/blob/main/explorations/clock/basic-rc2014-clock1.jpg?raw=true)
![alt text](https://github.com/inaciose/68000x/blob/main/explorations/clock/basic-rc2014-clock1-bb1.jpeg?raw=true)
![alt text](https://github.com/inaciose/68000x/blob/main/explorations/clock/basic-rc2014-clock1-bb1-signal1.jpeg?raw=true)

# c) basic 4pin crystal clock  
Este circuito só foi testado depois de ter efectuado o primeiro teste ao circuito freerun
Testado em breadboard, foto sinal no dso
![alt text](https://github.com/inaciose/68000x/blob/main/explorations/clock/basic_4pin_crystal_clock1.jpeg?raw=true)
![alt text](https://github.com/inaciose/68000x/blob/main/explorations/clock/basic_4pin_crystal_clock1-bb1.jpeg?raw=true)
![alt text](https://github.com/inaciose/68000x/blob/main/explorations/clock/basic_4pin_crystal_clock1-bb1-signal1.jpeg?raw=true)

# d) rosco m68kcomputer clock  
Este circuito só foi testado depois de ter efectuado o primeiro teste ao circuito freerun
Testado em breadboard, foto sinal no dso
![alt text](https://github.com/inaciose/68000x/blob/main/explorations/clock/rosco-m68kcomputer-clock1.jpg?raw=true)
![alt text](https://github.com/inaciose/68000x/blob/main/explorations/clock/rosco-m68kcomputer-clock1-bb1.jpeg?raw=true)
![alt text](https://github.com/inaciose/68000x/blob/main/explorations/clock/rosco-m68kcomputer-clock1-bb1-signal1.jpeg?raw=true)

# Escolha do circuito de clock a ser usado no circuito de teste freerun1
O escolhido para ser usado no circuito de teste freerun1 foi o "basic rc2014 clock"

![alt text](https://github.com/inaciose/68000x/blob/main/explorations/clock/basic-rc2014-clock1.jpg?raw=true)

# Notas à avaliação de alternativas
- O circuito "basic 4pin crystal clock" é simples, muito mais simples que o "basic rc2014 clock" e a qualidade do sinal é semelhante. 
Regra geral pela simplicidade é preferivel o seu uso, até porque acaba por não ser muito mais dispendioso em material.
- O circuito "rosco m68kcomputer clock" é semelhante ao basico do cristal de 4 pinos, acresentando dois condensadores e uma resistentencia.  
Não verifiquei qualquer mais valia neste circuito face ao "basic 4pin crystal clock". No sinal nota-se uma ligeira diminuição na frequência.  
Portanto, no futuro, e até nova avaliação, a decisão de qual circuito usar recai sobre as opções:
- basic 4pin crystal clock
- basic rc2014 clock

  


