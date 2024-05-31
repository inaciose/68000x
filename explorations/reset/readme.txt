# 68k reset circuits 

# a) Rosco reset
rosco-m68kcomputer-reset1.jpg

# b) Rosco hackaday reset
https://hackaday.io/project/164305-roscom68k/log/160626-the-reset-circuit
roscom68k-hackday-reset1.jpeg

# c) jtsiomb/m68kcomputer reset
jtsiomb-m68kcomputer-reset1.jpg

# d) reset only
https://myprojects77.wordpress.com/2017/09/07/first-blog-post/

Foram experimentados os circuitos b) e c). 
Não consegui por o b) a funcionar. Não chegou a ser testado no freerun
O circuito c) jtsiomb-m68kcomputer-reset1.jpg, funcionou e foi usado no teste freerun.

# Notas sobre o circuito c) jtsiomb-m68kcomputer-reset1.jpg
obriga a clicar sempre no reset depois de ligar. Pois numa fase inicial não mantem os sinais halt e o reset em low.
Pelo que li para um arranque on power on eles tem de ser mantidos low por um perido de tempo.

A estudar uma solução melhor. Neste momento estou a considerar usar dois ne555.  
