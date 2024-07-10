RAM_START           equ     $100000
RAM_END             equ     $1FFFFF
STACK_START         equ     $1FFFFE

*********************************
* 68681 Duart Register Addresses
* first register address must be odd

DUART equ $900001       * Base Addr of DUART
MRA   equ DUART+0       * Mode Register A           (R/W)
SRA   equ DUART+2       * Status Register A         (r)
CSRA  equ DUART+2       * Clock Select Register A   (w)
CRA   equ DUART+4       * Commands Register A       (w)
RBA   equ DUART+6       * Receiver Buffer A         (r)
TBA   equ DUART+6       * Transmitter Buffer A      (w)
ACR   equ DUART+8       * Aux. Control Register     (R/W)
ISR   equ DUART+10      * Interrupt Status Register (R)
IMR   equ DUART+10      * Interrupt Mask Register   (W)
MRB   equ DUART+16      * Mode Register B           (R/W)
SRB   equ DUART+18      * Status Register B         (R)
CSRB  equ DUART+18      * Clock Select Register B   (W)
CRB   equ DUART+20      * Commands Register B       (W)
RBB   equ DUART+22      * Reciever Buffer B         (R)
TBB   equ DUART+22      * Transmitter Buffer B      (W)
IVR   equ DUART+24      * Interrupt Vector Register (R/W)

RxRDY equ 0
TxRDY equ 2

**********************************
* ASCII Control Characters
*
BEL   equ $07
BKSP  equ $08       * CTRL-H
TAB   equ $09
LF    equ $0A
CR    equ $0D
ESC   equ $1B

CTRLC	EQU	$03     
CTRLX	EQU	$18     * Line Clear

**********************************
* boot
*

    ORG     $0000
    DC.L    STACK_START
    DC.L    start      
 
    ORG     $0400

**********************************
* start
*

START:
    lea     STACK_START, SP
    jsr     initDuart   
 
    lea     str1, A0
    jsr     printString
    
loop1
    jsr     inChar
    jsr     outChar
    jmp     loop1

**********************************
* serial io MC68681
*

* Initializes the 68681 DUART port A as 9600 8N1 
initDuart:
    move.b  #$30, CRA       * Reset Transmitter
    move.b  #$20, CRA       * Reset Reciever
    move.b  #$10, CRA       * Reset Mode Register Pointer    
    move.b  #$00, ACR       * Baud Rate Set
    *move.b  #$80, ACR       * Baud Rate Set #2    
    move.b  #$BB, CSRA      * Set Tx and Rx rates to 9600
    move.b  #$93, MRA       * 8-bit, No Parity ($93 for 8-bit, $92 for 7-bit)
    move.b  #$07, MRA       * Normal Mode, Not CTS/RTS, 1 stop bit    
    move.b  #$05, CRA       * Enable Transmit/Recieve
    rts  
    
* Writes a character to Port A, blocking if not ready (Full buffer)
*  - Takes a character in D0
outChar:
    btst    #2, SRA      * Check if transmitter ready bit is set   
    beq     outChar     * wait id bit 2 is 0
    move.b  d0, TBA      * Transmit Character
    rts
    
* Reads in a character from Port A, blocking if none available
*  - Returns character in D0
inChar:
    btst    #RxRDY,  SRA     * Check if receiver ready bit is set
    beq     inChar      * wait id bit 0 is 0
    move.b  RBA, d0      * Read Character into D0
    rts

**********************************
* strings
*

* print string with start address in A0
printString:
 .psloop:
    move.b  (a0)+, d0    * Read in character
    beq.s   .psend         * Check for the null
    
    bsr.s   outChar      * Otherwise write the character
    bra.s   .psloop        * And continue
 .psend:
    rts

    SIMHALT
    
* Put variables and constants here

str1            dc.b CR,LF,'Hello world',CR,LF,0

    END    START        ; last line of source





