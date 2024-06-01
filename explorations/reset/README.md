# 68k reset circuits 
Os circuitos de halt & reset foram experimentados em várias fases.

Na primeira fase (escolha para circuito teste freerun1):
- a) Rosco hackaday reset
- b) jtsiomb/m68kcomputer reset

Na segunda fase (melhoria Power on Reset)  
- c) myreset1

A aguardar
- d) reset only
- e) Rosco reset


# a) Rosco hackaday reset
https://hackaday.io/project/164305-roscom68k/log/160626-the-reset-circuit
![alt text](https://github.com/inaciose/68000x/blob/main/explorations/reset/roscom68k-hackday-reset1.jpeg?raw=true)
Não consegui por a funcionar. Não chegou a ser testado no circuito freerun.

# b) jtsiomb/m68kcomputer reset
![alt text](https://github.com/inaciose/68000x/blob/main/explorations/reset/jtsiomb-m68kcomputer-reset1.jpg?raw=true)
O circuito funcionou e foi usado no teste freerun.
obriga a clicar sempre no reset depois de ligar. Pois numa fase inicial não mantem os sinais halt e o reset em low.
Pelo que li para um arranque on power on eles tem de ser mantidos low por um perido de tempo.

# c) myreset1

# d) reset only
https://myprojects77.wordpress.com/2017/09/07/first-blog-post/

# e) Rosco reset
rosco-m68kcomputer-reset1.jpg

# Escolha do circuito de halt & reset a ser usado no circuito de teste freerun1
Foram experimentados os circuitos a) e b). 
O circuito b) jtsiomb-m68kcomputer-reset1.jpg, foi o escolhido para ser usado no teste freerun1

# Notas sobre o circuito c) myreset1
No seguimento do estudo de uma solução melhor, fui experimentando várias configurações até chegar a esta, que aparentemente seria funcional.
Mas tem uma oscliação estranha quando se clica no reset, ver fotos abaixo.
Falta desenhar o circuito.




