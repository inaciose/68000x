# Circuit for single step with dtack
Circuito que gera o sinal dtack, mantendo-o high, excepto durante um ciclo de relógio,  
que fica low, quando é premido o botão para avançar.  

Este circuito apenas suspende cpu quando existem acessos à memória, ou periféricos.  
Este circuito é uma implementação do exposto no video disponivel em:  

https://www.youtube.com/watch?v=rYkr1mFQ_50  

No video é exibido o seguinte esquema e gráficos dos sinais intermédios e do sinal dtack_low  
![alt text](https://github.com/inaciose/68000x/blob/main/explorations/dtack/dtack_singlestep1.jpg?raw=true)  

Converti o esquema para o seguinte circuito   
![alt text](https://github.com/inaciose/68000x/blob/main/explorations/dtack/68kmydtackpss1/68kmydtackpss1.png?raw=true)

Convertido para uma breadboard  
![alt text](https://github.com/inaciose/68000x/blob/main/explorations/dtack/68kmydtackpss1/68kmydtackpss1-bb1.jpeg?raw=true)  

Quando experimentado no circuito de freerun com 4 leds adicionais de A1 a A4  
![alt text](https://github.com/inaciose/68000x/blob/main/explorations/dtack/68kmydtackpss1/68kmydtackpss1-bb1-signal1.jpeg?raw=true)  

Video do teste no youtube  
https://www.youtube.com/watch?v=jKyf-8iSz-k  

Parece que se deixarmos muito tempo o cpu suspenso o sistma acaba por deixar de funcionar.

