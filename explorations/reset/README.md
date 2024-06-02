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
![alt text](https://github.com/inaciose/68000x/blob/main/explorations/reset/roscom68k-hackday/roscom68k-hackday-reset1.jpeg?raw=true)  
Não consegui por a funcionar. Não chegou a ser testado no circuito freerun.
  
# b) jtsiomb m68kcomputer reset
![alt text](https://github.com/inaciose/68000x/blob/main/explorations/reset/jtsiomb-m68kcomputer/jtsiomb-m68kcomputer-reset1.jpg?raw=true)  
O circuito funcionou e foi usado no teste freerun.  
obriga a clicar sempre no reset depois de ligar. Pois numa fase inicial não mantem os sinais halt e o reset em low.  
Pelo que li para um arranque on power on eles tem de ser mantidos low por um perido de tempo.  

# c) myreset1
No seguimento do estudo de uma solução melhor, cheguei ao ponto de pedir ao chat gpt que desenhasse o circuito.  
Não resolveu, mas fui dar uma olhada a circuitos e cheguei a conclusão que necessitave de um circuito mono estável e reinicavel.  
No entanto não consegui encontrar nenhum que estivesse de acordo com as necessidades e fui experimentando várias configurações.  
Até que numa das tentativas consegui um circuito que aparentemente seria funcional.  
O problema é que tem uma oscliação estranha quando se clica no reset, ver fotos abaixo.  
![alt text](https://github.com/inaciose/68000x/blob/main/explorations/reset/68kmyreset1/68kmyreset1-bb1.jpeg?raw=true)  
![alt text](https://github.com/inaciose/68000x/blob/main/explorations/reset/68kmyreset1/68kmyreset1-bb1-signal1.jpeg?raw=true)

Nesta versão a oscilação no sinal out do ne555 foi eliminada, pela colocação de uma resistencia entre o TR e RST.
![alt text](https://github.com/inaciose/68000x/blob/main/explorations/reset/68kmyreset1/68kmyreset1-bb2.jpeg?raw=true)  
![alt text](https://github.com/inaciose/68000x/blob/main/explorations/reset/68kmyreset1/68kmyreset1.png?raw=true)

Foi testada no circuito de teste free run, e com ela já não é necessário clicar no botão de reset, para iniciar bem o cpu.
Nesta fase de exploração, creio ser a melhor escolha.

# d) reset only
https://myprojects77.wordpress.com/2017/09/07/first-blog-post/  

# e) Rosco reset
![alt text](https://github.com/inaciose/68000x/blob/main/explorations/reset/rosco-m68kcomputer/rosco-m68kcomputer-reset1.jpg?raw=true)  
  

# Escolha do circuito de reset a ser usado no circuito de teste freerun1
Foram experimentados os circuitos a) e b).  
O circuito b) jtsiomb-m68kcomputer-reset1, foi o escolhido para ser usado no teste freerun1  

# Novo circuito de reset a ser usado no circuito de teste freerun2
Após algumas experiências cheguei uma solução melhor.  
Com apenas 2 ICs produz um sinal de halt e reset low nos 500ms iniciais, ou pressionando o botão de reset.  
No teste do freerun2 com este circuito o cpu arrancou normalmente sem necessidade de pressionar o reset.  




