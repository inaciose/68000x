# Main control board - placa de controlo principal

Esta placa inclui:
- a descodificação e lógica de acesso à ROM (0x000000 : 0x0FFFFF) e RAM (0x010000 : 0x01FFFF) (https://github.com/inaciose/68000x/tree/main/explorations/memory/romram_circuit1)
- leds como saida digital (0x800001) (https://github.com/inaciose/68000x/tree/main/explorations/io/74logic)
- clock 3.6864 para uarts
- duart MC68681 (0x900001) (ainda está em BB, não sei se consigo colocar os ICs todos para ter interrups) (https://github.com/inaciose/68000x/tree/main/explorations/serial/MC68681)
- geração do sinal dtack (sem ser open colector)


