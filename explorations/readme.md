Exploração dos vários circuitos e software de base necessários para a correcta operação do cpu 68010.  

O procedimento tem sido fazer uma recolha de circuitos existentes, verificar se funcionam bem, escolher um, eventualmente melhorar ou desenhar outro.
O mesmo procedimento se aplica no desenvolvimento do software de base e software de suporte ao desenvolvimento.  

Numa primeira fase, o objectivo foi implementar um circuito de teste do micro-processador.  
Um circuito freerun constituido, pelo cpu e respectivos pull ups, e pelos seguintes sub-circuitos: o de relógio e o de halt & reset.  

De seguida implementou-se um circuito de geração do sinal de dtack por intermédio de um botão. Este circuito tem um jumper que permite, escolher esta versão de geração do sinal dtack, ligar o dtack à ground, ou desconectar e deixar que seja outro circuito a gerar o sinal dtack.

Por esta altura tinha em placa perfurada as seguintes boards
- Placa de control basico, com circuitos de RESET, HALT e DTACK
- Placa com o CPU e pull em sinais básicos (deveria ter colocado também em outros sinais com os: AS, UDS, LDS e RW
- Placa com os dois ICs da ROM e 4 slots com um bus de 78 pinos (em duas linhas) 

De seguida foi estabelecer o circuito de decoding para a ROM capaz de gerar os sinais necessários para controlar os dois ICs com ROM de 512KB cada (39SF040):  
- ROM0_CS (word high data bits)
- ROM1_CS (word lower data bits)
- ROM_OE

Estes sinais usam 3 dos user pins do bus de 78 pinos.  

Para testar o funcionamento:  
- colocaram-se leds no bus de dados e no bus de endereços.  
- preparar um programa em assembly e coloca-lo em ROM que tenha um pequeno loop de instruções.
- visualizar nos leds se para os endereços indicados os dados lidos da rom estão correctos.

Garantindo o bom funcionamento da ROM e do seu circuito de descodificação, no qual se usa a saida Y0 de um 74LS138, podemos usar a saida Y1 para a descodificação da RAM. Para isso preparou-se uma placa com 2 memórias de 512KB cada (AS6C4008), que encaixa no primeiro bus slot.  

De seguida foi estabelecer o circuito de decoding para a ROM capaz de gerar os sinaisnecessários para controlar os dois ICs da RAM:  
- RAM0_CS (word high data bits)
- RAM1_CS (word lower data bits)
- RAM_OE
- RAM_WE

Estes sinais usam 4 dos user pins do bus de 78 pinos.  

Para testar a RAM e a sua descodificação foi usado o mesmo método para testar a ROM.  Foi confirmado o bom funcionamento.

Neste estado, ficamos com uma máquina capaz de estabelecer um stack pointer e fazer uso de um stack na memória, condição necessária para poder ter sub rotinas.  

Note-se que esta descodificação simples da memória ROM e RAM, não faz o overlay, pelo que os vectores para tratamento de excepções e interrupções estão na ROM.  
Pelo que percebi o 68010 tem um registo de endereço de base para os vectores, pelo que eventualmente este design não fica penalizado com atrazo de uma jump table na ROM a apontar para os vectores para os primeiros 1024 endereços da RAM, de 0x100000 a 0x100400.  

Por esta altura tentei colocar a funcionar um ACIA MC68B50, mas não tive sucesso.

Para facilitar o debuging foi implementado um periférico de saida digital, em leds, no endereço 0x800001, mas com réplicas em todos os endereços de: 0x800000 a 0x8FFFFF.  O sinal do decoder 74LS138 é usado como clock para o 74LS273.  

Por esta atura foi feita uma perfboard com o circuito de descodificação de endereços ROM, RAM e DOUT, assim com um sinal de clock para as comunicações serie, o gerador de dtack (que irei mencionar) e espaço para colocar a DUART e um 74LS138. 

Foi colocada a funcionar uma DUART MC68681 em modo básico, sem interrups, e apenas experimentada a porta A.  Com a colocação do MC68681 a funcionar, deixou de ser possivel usar o sinal de dtack ligado a terra, e passei a usar um 74LS11 para gerar o sinal de dtack com base nos sinais de saida dos decoders (74LS138) da ROM, RAM, DOUT e DUART.  

Com uma UART a funcionar, foi possivel adaptar um software monitor e acrescentar a funcionalidade de envio de programas por S records.  

Posteriormente, foi adicionado ao circuito da UART a lógica necessária para a utilização de interrups. Não sei se esta parte caberá na perfboard, ou se tenho que fazer uma nova.  

Com a maquina a funcionar e com o monitor capaz de receber programas via serial, segue a compilação de programas em C para o 68000, com base no m68k_bare_metal.  


