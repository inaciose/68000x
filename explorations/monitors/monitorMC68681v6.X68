*-----------------------------------------------------------
* Title      : 68k Homebrew ROM Monitor
* Written by : xsi
* Date       : July 21th 2024
* Description: A simple ROM monitor for my homebrew 68k
*              Based on works of: 
*               Hayden Kroepfl (ChartreuseK) the monitor
*               Kazuhiro Ouchi (kanpapa) the srecords
*               
*-----------------------------------------------------------

EASY68K_SIM	EQU 0		; set 0 to use ACIA1
*EASY68K_SIM	EQU 1		; set 1 to use EASy68K Sim68K I/O

BIT_ESC      EQU 0              ; ESC BIT POSITION #0

* v1.01     original changed to work with the MC68681
* v1.02     add easy68k serial conditional to debug on simulator
* v1.03     load srecords file (not working)
* v1.04     multibyte hex dump
* v1.05     roll back to v1.03, but with working load srecords file
* v1.06     add jumps to #100000 base on the vector table in the 1st 1024K
*
* To make this responsive to different terminal widths we need to change the number of bytes printed
* on a line from 16, which fits exactly on a 72 column screen, to an ammount based on a formula.
*  Sizes: 
*   Address:      "000000: " 8
*   Each Byte:    "00 "      3
*   Start ASCII:  "|"        1
*   Each ASCII:   "."        1
*   End ASCII:    "|"        1
*
*   Width = 8 + numBytes*(3 + 1) + 2
*   numBytes = (Width - 10)/4 = (Width - 10)>>2
*  Examples:
*    (80 - 10)/4 = 70/4 = 16 Bytes
*    (40 - 10)/4 = 30/4 =  7 Bytes
*    (32 - 10)/4 = 22/4 =  5 Bytes
* On small screens we should not show the start and end characters on the ASCII section
* 40 Characters wide or less
*    (40 - 8)/4  = 32/4 =  8 Bytes
*    (32 - 8)/4  = 24/4 =  6 Bytes



**********************************
* Defines
*
RAM_START           equ     $100000
RAM_END             equ     $200000
MAX_LINE_LENGTH     equ     80

*********************************
* 68681 Duart Register Addresses
*
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

SP      EQU 32
BS      EQU 8
RS      EQU $1E

CTRLC	EQU	$03     
CTRLX	EQU	$18     * Line Clear


**********************************
* Variables
*
varCurAddr  equ     RAM_END-4                        * Last address accessed
varLineBuf  equ     varCurAddr-MAX_LINE_LENGTH-2     * Line buffer

varLast     equ     varLineBuf


**********************************
* Defines 2 
*
STACK_START         equ     varLast



**** PROGRAM STARTS HERE ****
    
    ORG     $0000
    
**** FIRST 8 bytes loaded after reset ****
    DC.l    STACK_START  * Supervisor stack pointer
    DC.l    START        * Initial PC    
    
    DC.l    RAM_START+$008  * bus error
    DC.l    RAM_START+$00C  * address error
    DC.l    RAM_START+$010  * ilegal instruction
    DC.l    RAM_START+$014  * divide by zero
    DC.l    RAM_START+$018  * CHK instruction
    DC.l    RAM_START+$01C  * TRAPV instruction
    DC.l    RAM_START+$020  * privilege violation
    DC.l    RAM_START+$024  * trace
    DC.l    RAM_START+$028  * line 1010 emulator
    DC.l    RAM_START+$02C  * line 1111 emulator
    DC.l    RAM_START+$030
    DC.l    RAM_START+$034
    DC.l    RAM_START+$038
    DC.l    RAM_START+$03C  * Unitialized interrupt vector
    DC.l    RAM_START+$040  
    DC.l    RAM_START+$044
    DC.l    RAM_START+$048
    DC.l    RAM_START+$04C
    DC.l    RAM_START+$050
    DC.l    RAM_START+$054
    DC.l    RAM_START+$058
    DC.l    RAM_START+$05C
    DC.l    RAM_START+$060  * spurius interrupt
    DC.l    RAM_START+$064  * level 1 interrupt autovector
    DC.l    RAM_START+$068  * level 2 interrupt autovector
    DC.l    RAM_START+$06C  * level 3 interrupt autovector
    DC.l    RAM_START+$070  * level 4 interrupt autovector
    DC.l    RAM_START+$074  * level 5 interrupt autovector
    DC.l    RAM_START+$078  * level 6 interrupt autovector
    DC.l    RAM_START+$07C  * level 7 interrupt autovector
    DC.l    RAM_START+$080  * TRAP #0
    DC.l    RAM_START+$084  * TRAP #1
    DC.l    RAM_START+$088  * TRAP #2
    DC.l    RAM_START+$08C  * TRAP #3
    DC.l    RAM_START+$090  * TRAP #4
    DC.l    RAM_START+$094  * TRAP #5
    DC.l    RAM_START+$098  * TRAP #6
    DC.l    RAM_START+$09C  * TRAP #7
    DC.l    RAM_START+$0a0  * TRAP #8
    DC.l    RAM_START+$0a4  * TRAP #9
    DC.l    RAM_START+$0a8  * TRAP #10
    DC.l    RAM_START+$0aC  * TRAP #11
    DC.l    RAM_START+$0b0  * TRAP #12
    DC.l    RAM_START+$0b4  * TRAP #13
    DC.l    RAM_START+$0b8  * TRAP #14
    DC.l    RAM_START+$0bC  * TRAP #15
    DC.l    RAM_START+$0c0
    DC.l    RAM_START+$0c4
    DC.l    RAM_START+$0c8
    DC.l    RAM_START+$0cC
    DC.l    RAM_START+$0d0
    DC.l    RAM_START+$0d4
    DC.l    RAM_START+$0d8
    DC.l    RAM_START+$0dC
    DC.l    RAM_START+$0e0
    DC.l    RAM_START+$0e4
    DC.l    RAM_START+$0e8
    DC.l    RAM_START+$0eC
    DC.l    RAM_START+$0f0
    DC.l    RAM_START+$0f4
    DC.l    RAM_START+$0f8
    DC.l    RAM_START+$0fC
    DC.l    RAM_START+$100  * user interrupt vector (start)
    DC.l    RAM_START+$104
    DC.l    RAM_START+$108
    DC.l    RAM_START+$10c
    DC.l    RAM_START+$110
    DC.l    RAM_START+$114
    DC.l    RAM_START+$118
    DC.l    RAM_START+$11C
    DC.l    RAM_START+$120
    DC.l    RAM_START+$124
    DC.l    RAM_START+$128
    DC.l    RAM_START+$12C
    DC.l    RAM_START+$130
    DC.l    RAM_START+$134
    DC.l    RAM_START+$138
    DC.l    RAM_START+$13C
    DC.l    RAM_START+$140
    DC.l    RAM_START+$144
    DC.l    RAM_START+$148
    DC.l    RAM_START+$14C
    DC.l    RAM_START+$150
    DC.l    RAM_START+$154
    DC.l    RAM_START+$158
    DC.l    RAM_START+$15C
    DC.l    RAM_START+$160
    DC.l    RAM_START+$164
    DC.l    RAM_START+$168
    DC.l    RAM_START+$16C
    DC.l    RAM_START+$170
    DC.l    RAM_START+$174
    DC.l    RAM_START+$178
    DC.l    RAM_START+$17C
    DC.l    RAM_START+$180
    DC.l    RAM_START+$184
    DC.l    RAM_START+$188
    DC.l    RAM_START+$18C
    DC.l    RAM_START+$190
    DC.l    RAM_START+$194
    DC.l    RAM_START+$198
    DC.l    RAM_START+$19C
    DC.l    RAM_START+$1a0
    DC.l    RAM_START+$1a4
    DC.l    RAM_START+$1a8
    DC.l    RAM_START+$1aC
    DC.l    RAM_START+$1b0
    DC.l    RAM_START+$1b4
    DC.l    RAM_START+$1b8
    DC.l    RAM_START+$1bC
    DC.l    RAM_START+$1c0
    DC.l    RAM_START+$1c4
    DC.l    RAM_START+$1c8
    DC.l    RAM_START+$1cC
    DC.l    RAM_START+$1d0
    DC.l    RAM_START+$1d4
    DC.l    RAM_START+$1d8
    DC.l    RAM_START+$1dC
    DC.l    RAM_START+$1e0
    DC.l    RAM_START+$1e4
    DC.l    RAM_START+$1e8
    DC.l    RAM_START+$1eC
    DC.l    RAM_START+$1f0
    DC.l    RAM_START+$1f4
    DC.l    RAM_START+$1f8
    DC.l    RAM_START+$1fC
    DC.l    RAM_START+$200
    DC.l    RAM_START+$204
    DC.l    RAM_START+$208
    DC.l    RAM_START+$20C
    DC.l    RAM_START+$210
    DC.l    RAM_START+$214
    DC.l    RAM_START+$218
    DC.l    RAM_START+$21C
    DC.l    RAM_START+$220
    DC.l    RAM_START+$224
    DC.l    RAM_START+$228
    DC.l    RAM_START+$22C
    DC.l    RAM_START+$230
    DC.l    RAM_START+$234
    DC.l    RAM_START+$238
    DC.l    RAM_START+$23C
    DC.l    RAM_START+$240
    DC.l    RAM_START+$244
    DC.l    RAM_START+$248
    DC.l    RAM_START+$24C
    DC.l    RAM_START+$250
    DC.l    RAM_START+$254
    DC.l    RAM_START+$258
    DC.l    RAM_START+$25C
    DC.l    RAM_START+$260
    DC.l    RAM_START+$264
    DC.l    RAM_START+$268
    DC.l    RAM_START+$26C
    DC.l    RAM_START+$270
    DC.l    RAM_START+$274
    DC.l    RAM_START+$278
    DC.l    RAM_START+$27C
    DC.l    RAM_START+$280
    DC.l    RAM_START+$284
    DC.l    RAM_START+$288
    DC.l    RAM_START+$28C
    DC.l    RAM_START+$290
    DC.l    RAM_START+$294
    DC.l    RAM_START+$298
    DC.l    RAM_START+$29C
    DC.l    RAM_START+$2a0
    DC.l    RAM_START+$2a4
    DC.l    RAM_START+$2a8
    DC.l    RAM_START+$2aC
    DC.l    RAM_START+$2b0
    DC.l    RAM_START+$2b4
    DC.l    RAM_START+$2b8
    DC.l    RAM_START+$2bC
    DC.l    RAM_START+$2c0
    DC.l    RAM_START+$2c4
    DC.l    RAM_START+$2c8
    DC.l    RAM_START+$2cC
    DC.l    RAM_START+$2d0
    DC.l    RAM_START+$2d4
    DC.l    RAM_START+$2d8
    DC.l    RAM_START+$2dC
    DC.l    RAM_START+$2e0
    DC.l    RAM_START+$2e4
    DC.l    RAM_START+$2e8
    DC.l    RAM_START+$2eC
    DC.l    RAM_START+$2f0
    DC.l    RAM_START+$2f4
    DC.l    RAM_START+$2f8
    DC.l    RAM_START+$2fC
    DC.l    RAM_START+$300
    DC.l    RAM_START+$304
    DC.l    RAM_START+$308
    DC.l    RAM_START+$30c
    DC.l    RAM_START+$310
    DC.l    RAM_START+$314
    DC.l    RAM_START+$318
    DC.l    RAM_START+$31C
    DC.l    RAM_START+$320
    DC.l    RAM_START+$324
    DC.l    RAM_START+$328
    DC.l    RAM_START+$32C
    DC.l    RAM_START+$330
    DC.l    RAM_START+$334
    DC.l    RAM_START+$338
    DC.l    RAM_START+$33C
    DC.l    RAM_START+$340
    DC.l    RAM_START+$344
    DC.l    RAM_START+$348
    DC.l    RAM_START+$34C
    DC.l    RAM_START+$350
    DC.l    RAM_START+$354
    DC.l    RAM_START+$358
    DC.l    RAM_START+$35C
    DC.l    RAM_START+$360
    DC.l    RAM_START+$364
    DC.l    RAM_START+$368
    DC.l    RAM_START+$36C
    DC.l    RAM_START+$370
    DC.l    RAM_START+$374
    DC.l    RAM_START+$378
    DC.l    RAM_START+$37C
    DC.l    RAM_START+$380
    DC.l    RAM_START+$384
    DC.l    RAM_START+$388
    DC.l    RAM_START+$38C
    DC.l    RAM_START+$390
    DC.l    RAM_START+$394
    DC.l    RAM_START+$398
    DC.l    RAM_START+$39C
    DC.l    RAM_START+$3a0
    DC.l    RAM_START+$3a4
    DC.l    RAM_START+$3a8
    DC.l    RAM_START+$3aC
    DC.l    RAM_START+$3b0
    DC.l    RAM_START+$3b4
    DC.l    RAM_START+$3b8
    DC.l    RAM_START+$3bC
    DC.l    RAM_START+$3c0
    DC.l    RAM_START+$3c4
    DC.l    RAM_START+$3c8
    DC.l    RAM_START+$3cC
    DC.l    RAM_START+$3d0
    DC.l    RAM_START+$3d4
    DC.l    RAM_START+$3d8
    DC.l    RAM_START+$3dC
    DC.l    RAM_START+$3e0
    DC.l    RAM_START+$3e4
    DC.l    RAM_START+$3e8
    DC.l    RAM_START+$3eC
    DC.l    RAM_START+$3f0
    DC.l    RAM_START+$3f4
    DC.l    RAM_START+$3f8
    DC.l    RAM_START+$3fC * user interrupt vector (end)


    
    ORG     $0400
    
********************************************
* Cold start entry point
*
START:
    lea     STACK_START, SP     * Set our stack pointer to be sure
    jsr     initDuart           * Setup the serial port
 
********************************************
* Simple Ram Readback Test
*    
ramCheck:
    lea     msgRamCheck, A0
    bsr.w   printString
    lea     RAM_START, A2
 .loop:
    move.b  #$AA, (A2)   * First test with 10101010
    cmp.b   #$AA, (A2)
    *bne.s   .fail
    beq.s   .ok1
    jsr     .fail
 .ok1:
    move.b  #$55, (A2)   * Then with 01010101
    cmp.b   #$55, (A2)
    *bne.s   .fail
    beq.s   .ok2
    jsr     .fail
 .ok2:
    move.b  #$00, (A2)   * And finally clear the memory
    cmp.b   #$00, (A2)+  * And move to the next byte
    *bne.s   .fail
    beq.s   .ok3
    jsr     .fail
 .ok3: 
    cmp.l   #RAM_END, A2  
    blt.s   .loop        * While we're still below the end of ram to check
    bra.s   .succ   
 .fail:                  * One of the bytes of RAM failed to readback test
    lea     msgRamFail, A0
    bsr.w   printString
    move.l  A2, D0
    bsr.w   printHexLong * Print out the address that failed
    bsr.w   printNewline
    rts
 .haltloop:              * Sit forever in the halt loop
    bra.s   .haltloop
 .succ:                  * All bytes passed the readback test
    lea     msgRamPass, A0
    bsr.w   printString



**************************************************
* Warm Restart entry point
*
monitorStart:
    * used by hexdump & load srecors
    move.l #$100400, RAMBASE

    lea     msgBanner, A0   * Show our banner
    bsr.w   printString
    lea     msgHelp,   A0   * And the command help message
    bsr.w   printString

monitorLine:                * Our main monitor loop
    lea     msgPrompt, a0   * Prompt
    bsr.w   printString     
    bsr.w   readLine        * Read in the line
    bsr.w   lineToUpper     * Convert to upper-case for ease of parsing
    bsr.w   parseLine       * Then parse and respond to the line
    
    bra.s   monitorLine
    
    
    
    
***************************************
* Converts input line to uppercase
lineToUpper:
    lea     varLineBuf, a0   * Get the start of the line buffer
 .loop:
    move.b  (a0), d0         * Read in a character
    cmp.b   #'a', d0         
    blt.s   .next            * Is it less than lower-case 'a', then move on
    cmp.b   #'z', d0
    bgt.s   .next            * Is it greater than lower-case 'z', then move on
    sub.b   #$20, d0         * Then convert a to A, b to B, etc.
 .next:
    move.b  d0, (a0)+        * Store the character back into a0, and move to the next
    bne.s   .loop            * Keep going till we hit a null terminator
    rts

***************************************
* Parse Line
parseLine:
    movem.l a2-a3, -(SP)        * Save registers
    lea     varLineBuf, a0
 .findCommand:
    move.b  (a0)+, d0
    cmp.b   #' ', d0            * Ignore spaces
    beq.w   .findCommand    
    cmp.b   #'E', d0            * Examine command
    beq.w   .examine
    cmp.b   #'D', d0            * Deposit command
    beq.w   .deposit
    cmp.b   #'R', d0            * Run command
    beq.w   .run
    cmp.b   #'L', d0            * Load s records command
    beq.w   .srec
    cmp.b   #'H', d0            * Help command
    beq.w   .help
    cmp.b   #0, d0              * Ignore blank lines
    beq.s   .exit               
 .invalid:   
    lea     msgInvalidCommand, a0
    bsr.w   printString
 .exit:
    movem.l (SP)+, a2-a3        * Restore registers
    rts

**********************
* Examines memory addresses
* Valid modes:
*   e ADDR                  Displays a single byte
*   e ADDR-ADDR             Dispalys all bytes between the two addresses
*   e ADDR+LEN              Dispays LEN bytes after ADDR
*   e ADDR;                 Interactive mode, space shows 16 lines, enter shows 1.
*   e ADDR.                 Quick line, displays one line 
 .examine:
    bsr.w   parseNumber         * Read in the start address
    tst.b   d1                  * Make sure it's valid (parseNumber returns non-zero in d1 for failure)
    bne.w   .invalidAddr        
    move.l  d0, a3              * Save the start address
 .exloop:
    move.b  (a0)+, d0
    cmp.b   #' ', d0            * Ignore spaces
    beq.s   .exloop
    cmp.b   #'-', d0            * Check if it's a range specifier
    beq.s   .exrange
    cmp.b   #'+', d0            * Check if it's a length specifier
    beq.s   .exlength
    cmp.b   #';', d0            * Check if we're going interactive
    beq.s   .exinter
    cmp.b   #'.', d0            * Check if quick 16 
    beq.s   .exquick
    move.l  #1, d0              * Otherwise read in a single byte
    bra.s   .exend              
 .exrange:
    bsr.w   parseNumber         * Find the end address
    tst.b   d1                  * Check if we found a valid address
    bne.w   .invalidAddr
    sub.l   a3, d0              * Get the length
    bra.s   .exend
 .exquick:                      * Quick mode means show one line of 16 bytes
    move.l  #$10, d0
    bra.s   .exend
 .exlength:                     * Length mode means a length is specified
    bsr.w   parseNumber         * Find the length
    tst.b   d1
    bne.w   .invalidAddr
 .exend:                        * We're done parsing, give the parameters to dumpRAM and exit
    move.l  a3, a0
    bsr.w   dumpRAM
    bra.s   .exit
 .exinter:                      * Interactive mode, Space shows 16 lines, enter shows 1.
    move.l  a3, a0              * Current Address
    move.l  #$10, d0            * 16 bytes
    bsr.w   dumpRAM             * Dump this line
    add.l   #$10, a3            * Move up the current address 16 bytes
 .exinterend:
    bsr.w   inChar
    cmp.b   #CR, d0             * Display another line
    beq.s   .exinter
    cmp.b   #' ', d0            * Display a page (256 bytes at a time)
    beq.s   .exinterpage
    bra.s   .exit               * Otherwise exit
 .exinterpage:
    move.l  a3, a0
    move.l  #$100, d0           * 256 bytes
    bsr.w   dumpRAM             * Dump 16 lines of RAM
    add.l   #$100, a3           * Move up the current address by 256
    bra.s   .exinterend

****************************************
* Deposit values into RAM
* d ADDR VAL VAL            Deposit value(s) into RAM
* d ADDR VAL VAL;           Deposit values, continue with values on next line
*  VAL VAL VAL;              - Continuing with further continue
* d: VAL VAL                Continue depositing values after the last address written to
 .deposit:
    move.b  (a0), d0
    cmp.b   #':', d0            * Check if we want to continue from last
    beq.s   .depCont
    
    bsr.w   parseNumber         * Otherwise read the address
    tst.b   d1
    bne.s   .invalidAddr
    move.l  d0, a3              * Save the start address
 .depLoop:
    move.b  (a0), d0            
    cmp.b   #';', d0            * Check for continue
    beq.s   .depMultiline
    tst     d0                  * Check for the end of line
    beq     .depEnd
    
    bsr.w   parseNumber         * Otherwise read a value
    tst.b   d1
    bne.s   .invalidVal
    cmp.w   #255, d0            * Make sure it's a byte
    bgt.s   .invalidVal
    
    move.b  d0, (a3)+           * Store the value into memory
    bra.s   .depLoop
    
 .depCont:
    move.l  varCurAddr, a3      * Read in the last address 
    addq.l  #1, a0              * Skip over the ':'
    bra.s   .depLoop
    
 .depMultiline:
    lea     msgDepositPrompt, a0
    bsr.w   printString
    bsr.w   readLine            * Read in the next line to be parsed
    bsr.w   lineToUpper         * Convert to uppercase
    lea     varLineBuf, a0      * Reset our buffer pointer
    bra.s   .depLoop            * And jump back to decoding
 .depEnd:
    move.l  a3, varCurAddr
    bra.w   .exit
****************************************
* 
 .run:
    bsr.w   parseNumber         * Otherwise read the address
    tst.b   d1
    bne.s   .invalidAddr
    move.l  d0, a0
    jsr     (a0)                * Jump to the code! 
                                * Go as subroutine to allow code to return to us
    jsr     monitorStart        * Warm start after returning so everything is in
                                * a known state.
    
 .help:
    lea     msgHelp, a0
    bsr.w   printString
    bra.w   .exit
 .invalidAddr:
    lea     msgInvalidAddress, a0
    bsr.w   printString
    bra.w   .exit
 .invalidVal:
    lea     msgInvalidValue, a0
    bsr.w   printString
    bra.w   .exit
    
 .srec: 
    jsr READ_S_REC
    bra.w   .exit
  
**************************************
* Find and parse a hex number
*  Starting address in A0
*  Number returned in D0
*  Status in D1   (0 success, 1 fail)
*  TODO: Try and merge first digit code with remaining digit code
parseNumber:
    eor.l   d0, d0           * Zero out d0
    move.b  (a0)+, d0
    cmp.b   #' ', d0         * Ignore all leading spaces
    beq.s   parseNumber
    cmp.b   #'0', d0         * Look for hex digits 0-9
    blt.s   .invalid
    cmp.b   #'9', d0
    ble.s   .firstdigit1

    cmp.b   #'A', d0         * Look for hex digits A-F
    blt.s   .invalid    
    cmp.b   #'F', d0
    ble.s   .firstdigit2
 .invalid:
    move.l  #1, d1          * Invalid character, mark failure and return
    rts
 .firstdigit2:
    sub.b   #'7', d0        * Turn 'A' to 10
    bra.s   .loop
 .firstdigit1:
    sub.b   #'0', d0        * Turn '0' to 0
 .loop:
    move.b  (a0)+, d1       * Read in a digit
    cmp.b   #'0', d1        * Look for hex digits 0-9
    blt.s   .end            * Any other characters mean we're done reading
    cmp.b   #'9', d1
    ble.s   .digit1
    cmp.b   #'A', d1        * Look for hex digits A-F
    blt.s   .end
    cmp.b   #'F', d1
    ble.s   .digit2

.end:                       * We hit a non-hex digit character, we're done parsing
    subq.l  #1, a0          * Move the pointer back before the end character we read
    move.l  #0, d1
    rts
 .digit2:
    sub.b   #'7', d1        * Turn 'A' to 10
    bra.s   .digit3
 .digit1:
    sub.b   #'0', d1        * Turn '0' to 0
 .digit3:
    lsl.l   #4, d0          * Shift over to the next nybble
    add.b   d1, d0          * Place in our current nybble (could be or.b instead)
    bra.s   .loop
    
    
****************************************
* Dumps a section of RAM to the screen
* Displays both hex values and ASCII characters
* d0 - Number of bytes to dump
* a0 - Start Address
dumpRAM:
    movem.l d2-d4/a2, -(SP)  * Save registers
    move.l  a0, a2           * Save the start address
    move.l  d0, d2           * And the number of bytes
 .line:
    move.l  a2, d0          
    bsr.w   printHexAddr     * Starting address of this line
    lea     msgColonSpace, a0
    bsr.w   printString
    move.l  #16, d3          * 16 Bytes can be printed on a line
    move.l  d3, d4           * Save number of bytes on this line
 .hexbyte:
    tst.l   d2               * Check if we're out of bytes
    beq.s   .endbytesShort
    tst.b   d3               * Check if we're done this line
    beq.s   .endbytes    
    move.b  (a2)+, d0        * Read a byte in from RAM
    bsr.w   printHexByte     * Display it
    move.b  #' ', d0
    bsr.w   outChar          * Space out bytes
    subq.l  #1, d3    
    subq.l  #1, d2        
    bra.s   .hexbyte
 .endbytesShort:
    sub.b   d3, d4           * Make d4 the actual number of bytes on this line
    move.b  #' ', d0
 .endbytesShortLoop:
    tst.b   d3               * Check if we ended the line
    beq.s   .endbytes
    move.b  #' ', d0
    bsr.w   outChar          * Three spaces to pad out
    move.b  #' ', d0
    bsr.w   outChar
    move.b  #' ', d0
    bsr.w   outChar
    
    subq.b  #1, d3
    bra.s   .endbytesShortLoop
 .endbytes:
    suba.l  d4, a2           * Return to the start address of this line
 .endbytesLoop:
    tst.b   d4               * Check if we're done printing ascii
    beq     .endline    
    subq.b  #1, d4
    move.b  (a2)+, d0        * Read the byte again
    cmp.b   #' ', d0         * Lowest printable character
    blt.s   .unprintable
    cmp.b   #'~', d0         * Highest printable character
    bgt.s   .unprintable
    bsr.w   outChar
    bra.s   .endbytesLoop
 .unprintable:
    move.b  #'.', d0
    bsr.w   outChar
    bra.s   .endbytesLoop
 .endline:
    lea     msgNewline, a0
    bsr.w   printString
    tst.l   d2
    ble.s   .end
    bra.w   .line
 .end:
    movem.l (SP)+, d2-d4/a2  * Restore registers
    rts
    
    
        
    
******
* Read in a line into the line buffer
readLine:
    movem.l d2/a2, -(SP)     * Save changed registers
    lea     varLineBuf, a2   * Start of the lineBuffer
    eor.w   d2, d2           * Clear the character counter
 .loop:
    bsr.w   inChar           * Read a character from the serial port
    cmp.b   #BKSP, d0        * Is it a backspace?
    beq.s   .backspace
    cmp.b   #CTRLX, d0       * Is it Ctrl-H (Line Clear)?
    beq.s   .lineclear
    cmp.b   #CR, d0          * Is it a carriage return?
    beq.s   .endline
    cmp.b   #LF, d0          * Is it anything else but a LF?
    beq.s   .loop            * Ignore LFs and get the next character
 .char:                      * Normal character to be inserted into the buffer
    cmp.w   #MAX_LINE_LENGTH, d2
    bge.s   .loop            * If the buffer is full ignore the character
    move.b  d0, (a2)+        * Otherwise store the character
    addq.w  #1, d2           * Increment character count
    bsr.w   outChar          * Echo the character
    bra.s   .loop            * And get the next one
 .backspace:
    tst.w   d2               * Are we at the beginning of the line?
    beq.s   .loop            * Then ignore it
    bsr.w   outChar          * Backspace
    move.b  #' ', d0
    bsr.w   outChar          * Space
    move.b  #BKSP, d0
    bsr.w   outChar          * Backspace
    subq.l  #1, a2           * Move back in the buffer
    subq.l  #1, d2           * And current character count
    bra.s   .loop            * And goto the next character
 .lineclear:
    tst     d2               * Anything to clear?
    beq.s   .loop            * If not, fetch the next character
    suba.l  d2, a2           * Return to the start of the buffer
 .lineclearloop:
    move.b  #BKSP, d0
    bsr.w   outChar          * Backspace
    move.b  #' ', d0
    bsr.w   outChar          * Space
    move.b  #BKSP, d0
    bsr.w   outChar          * Backspace
    subq.w  #1, d2          
    bne.s   .lineclearloop   * Go till the start of the line
    bra.s   .loop   
 .endline:
    bsr.w   outChar          * Echo the CR
    move.b  #LF, d0
    bsr.w   outChar          * Line feed to be safe
    move.b  #0, (a2)         * Terminate the line (Buffer is longer than max to allow this at full length)
    movea.l a2, a0           * Ready the pointer to return (if needed)
    movem.l (SP)+, d2/a2     * Restore registers
    rts                      * And return




    
******
* Prints a newline (CR, LF)
printNewline:
    lea     msgNewline, a0
******
* Print a null terminated string
*
printString:
 .loop:
    move.b  (a0)+, d0    * Read in character
    beq.s   .end         * Check for the null
    
    bsr.w   outChar      * Otherwise write the character
    bra.s   .loop        * And continue
 .end:
    rts

** KEEP All printHex functions together **
******
* Print a hex word
printHexWord:
    move.l  d2, -(SP)    * Save D2
    move.l  d0, d2       * Save the address in d2
    
    rol.l   #8, d2       * 4321 -> 3214
    rol.l   #8, d2       * 3214 -> 2143 
    bra.s   printHex_wordentry  * Print out the last 16 bits
*****
* Print a hex 24-bit address
printHexAddr:
    move.l d2, -(SP)     * Save D2
    move.l d0, d2          * Save the address in d2
    
    rol.l   #8, d2       * 4321 -> 3214
    bra.s   printHex_addrentry  * Print out the last 24 bits
******
* Print a hex long
printHexLong:
    move.l  d2, -(SP)     * Save D2
    move.l  d0, d2        * Save the address in d2
    
    rol.l   #8, d2        * 4321 -> 3214 high byte in low
    move.l  d2, d0
    bsr.s   printHexByte  * Print the high byte (24-31)
printHex_addrentry:     
    rol.l   #8, d2        * 3214 -> 2143 middle-high byte in low
    move.l  d2, d0              
    bsr.s   printHexByte  * Print the high-middle byte (16-23)
printHex_wordentry:    
    rol.l   #8, d2        * 2143 -> 1432 Middle byte in low
    move.l  d2, d0
    bsr.s   printHexByte  * Print the middle byte (8-15)
    rol.l   #8, d2
    move.l  d2, d0
    bsr.s   printHexByte  * Print the low byte (0-7)
    
    move.l (SP)+, d2      * Restore D2
    RTS
    
******
* Print a hex byte
*  - Takes byte in D0
printHexByte:
    move.l  D2, -(SP)
    move.b  D0, D2
    lsr.b   #$4, D0
    add.b   #'0', D0
    cmp.b   #'9', D0     * Check if the hex number was from 0-9
    ble.s   .second
    add.b   #7, D0       * Shift 0xA-0xF from ':' to 'A'
.second:
    bsr.s   outChar      * Print the digit
    andi.b  #$0F, D2     * Now we want the lower digit Mask only the lower digit
    add.b   #'0', D2
    cmp.b   #'9', D2     * Same as before    
    ble.s   .end
    add.b   #7, D2
.end:
    move.b  D2, D0
    bsr.s   outChar      * Print the lower digit
    move.l  (SP)+, D2
    rts
    
* condtional console swtich
********************************** 
  
    IFEQ	EASY68K_SIM
; CONSOLE IS MC68681
*****
* Initializes the 68681 DUART port A as 9600 8N1 
initDuart:
    move.b  #$30, CRA       * Reset Transmitter
    move.b  #$20, CRA       * Reset Reciever
    move.b  #$10, CRA       * Reset Mode Register Pointer
    
    move.b  #$00, ACR       * Baud Rate Set #2
    move.b  #$BB, CSRA      * Set Tx and Rx rates to 9600
    move.b  #$93, MRA       * 7-bit, No Parity ($93 for 8-bit, $92 for 7-bit)
    move.b  #$07, MRA       * Normal Mode, Not CTS/RTS, 1 stop bit
    
    move.b  #$05, CRA       * Enable Transmit/Recieve
    rts

*****
* Writes a character to Port A, blocking if not ready (Full buffer)
*  - Takes a character in D0
outChar:
    btst    #2, SRA      * Check if transmitter ready bit is set   
    beq     outChar     * wait id bit 2 is 0
    move.b  d0, TBA      * Transmit Character
    rts

*****
* Reads in a character from Port A, blocking if none available
*  - Returns character in D0
*    
inChar:
    btst    #RxRDY,  SRA     * Check if receiver ready bit is set
    beq     inChar      * wait id bit 0 is 0
    move.b  RBA, d0      * Read Character into D0
    rts

	ENDC

	IFNE	EASY68K_SIM
; CONSOLE IS EASy68K Sim68K I/O

initDuart  ;Keyboard Echo.
           ;D1.B = 0 to turn off keyboard echo.
           ;D1.B = non zero to enable it (default).
           ;Echo is restored on 'Reset' or when a new file is loaded.
           MOVE.B #0,D1
           MOVE.B #12,D0
           TRAP #15
           RTS

outChar   MOVEM.L D0-D1,-(SP)  ; SAVE D1
          MOVE.B D0,D1
          MOVE.B #6,D0
          TRAP #15
          MOVEM.L (SP)+,D0-D1 ; RESTORE D1
          RTS


inChar    MOVE.L D1,-(SP)  ; SAVE D1
          MOVE.B #5,D0
          TRAP #15
          MOVE.B D1,D0  ;ACIAD.L,D0
          MOVE.L (SP)+,D1 ; RESTORE D1
          RTS

         ENDC
* end condtional console swtich
**********************************



; Print string
; A3 POINTED TO FIRST BYTE
; END WITH 0

PSTR     MOVE.B (A3)+,D0
         CMP.B  #0,D0
         BEQ.S PSTR1
         BSR outChar
         BRA.S PSTR

PSTR1    RTS

; NEW LINE

NEW_LINE MOVE.L D0,-(SP)
         MOVE.B #CR,D0
         BSR outChar
         MOVE.B #LF,D0
         BSR outChar
         MOVE.L (SP)+,D0
         RTS


; PRINT_DEC
; D0 32-BIT BINARY NUMBER

PRINT_DEC MOVE.L D0,-(SP)  ; SAVE D0
          MOVEA.L RAMBASE.L,A6
          ADDA.L #BUFFER,A6
          BSR HEX2DEC
          MOVEA.L RAMBASE.L,A3
          ADDA.L #BUFFER,A3
          BSR PSTR
          MOVE.L (SP)+,D0 ; RESTORE D0
          RTS

; HEX2DEC   HEX2DEC convert hex to decimal                   
; CONVERT BINARY TO DECIMAL  REG D0 PUT IN (A6) BUFFER AS ASCII

HEX2DEC  MOVEM.L D1-D7,-(SP)   ;SAVE REGISTERS
         MOVE.L  D0,D7               ;SAVE IT HERE
         BPL.S   HX2DC
         NEG.L   D7             ;CHANGE TO POSITIVE
         BMI.S   HX2DC57        ;SPECIAL CASE (-0)
         MOVE.B  #'-',(A6)+     ;PUT IN NEG SIGN
HX2DC    CLR.W   D4             ;FOR ZERO SURPRESS
         MOVEQ.L   #10,D6         ;COUNTER
HX2DC0   MOVEQ.L   #1,D2          ;VALUE TO SUB
         MOVE.L  D6,D1          ;COUNTER
         SUBQ.L  #1,D1          ;ADJUST - FORM POWER OF TEN
         BEQ.S   HX2DC2         ;IF POWER IS ZERO
HX2DC1   MOVE.W  D2,D3          ;D3=LOWER WORD
         MULU.W    #10,D3
         SWAP.W    D2             ;D2=UPPER WORD
         MULU.W    #10,D2
         SWAP.W    D3             ;ADD UPPER TO UPPER
         ADD.W   D3,D2
         SWAP.W    D2             ;PUT UPPER IN UPPER
         SWAP.W    D3             ;PUT LOWER IN LOWER
         MOVE.W  D3,D2          ;D2=UPPER & LOWER
         SUBQ.L  #1,D1
         BNE     HX2DC1
HX2DC2   CLR.L   D0             ;HOLDS SUB AMT
HX2DC22  CMP.L   D2,D7
         BLT.S   HX2DC3         ;IF NO MORE SUB POSSIBLE
         ADDQ.L  #1,D0          ;BUMP SUBS
         SUB.L   D2,D7          ;COUNT DOWN BY POWERS OF TEN
         BRA.S   HX2DC22        ;DO MORE
HX2DC3   TST.B   D0             ;ANY VALUE?
         BNE.S   HX2DC4
         TST.W   D4             ;ZERO SURPRESS
         BEQ.S   HX2DC5
HX2DC4   ADDI.B  #$30,D0        ;BINARY TO ASCII
         MOVE.B  D0,(A6)+       ;PUT IN BUFFER
         MOVE.B  D0,D4          ;MARK AS NON ZERO SURPRESS
HX2DC5   SUBQ.L  #1,D6          ;NEXT POWER
         BNE     HX2DC0
         TST.W   D4             ;SEE IF ANYTHING PRINTED
         BNE.S   HX2DC6
HX2DC57  MOVE.B  #'0',(A6)+     ;PRINT AT LEST A ZERO
HX2DC6   MOVE.B  #0,(A6)        ; PUT TERMINATOR
         MOVEM.L (SP)+,D1-D7   ;RESTORE REGISTERS
         RTS                    ;END OF ROUTINE


; READ TWO BYTES ASCII AND CONVERT TO SINGLE BYTE DATA

; ENTRY: D0 FROM CIN 
; EXIT: D1 8-BIT VALUE 
;       
GET_HEX  BSR inChar
         *BSR outChar
         CMP.B #' ',D0         ; IF BIT_ESC PRESSED
         BNE.S GET_HEX1
         BSET.B #BIT_ESC,FLAG(A6)
         RTS


GET_HEX1 CMP.B #CR,D0
         BNE.S GET_HEX2
         BSET.B #1,FLAG(A6)       ; ENTER PRESSED
         RTS


GET_HEX2 BSR TO_HEX
         ROL.B #4,D1
         MOVE.B D1,D2
         BSR inChar
         *BSR outChar
         BSR TO_HEX
         ADD.B D2,D1
         RTS


GET_HEXS BSR inChar
         *BSR outChar
         BSR TO_HEX
         ROL.B #4,D1
         MOVE.B D1,D2
         BSR inChar
         *BSR outChar
         BSR TO_HEX
         ADD.B D2,D1
         RTS


; CONVERT ASCII LETTER TO 8-BIT VALUE

TO_HEX SUBI.B #$30,D0
       CMPI.B #$A,D0
       BMI  ZERO_TO_NINE
       AND.B #%11011111,D0
       SUBI.B #7,D0

ZERO_TO_NINE

       MOVE.B D0,D1

        RTS


*****
* Read s records file
;
;S214000400227C00400001143C00006100002C128297
;S804000000FB

; READ S-RECORD
; D5 = BYTE CHECK SUM FOR EACH RECORD
; D4 = NUMBER OF BYTE RECEIVED

READ_S_REC      LEA.L LOAD.L,A3
                BSR PSTR
                CLR.L D4     ; CLEAR NUMBER OF BYTE 
                CLR.L D5     ; CLEAR CHECK SUM AND ERROR BYTE

READ_S_REC1     BSR inChar
                *BSR outChar
                CMP.B #'S',D0
                BNE.S CHECK_ESC
                BRA.S GET_TYPE


CHECK_ESC       CMP.B #ESC,D0
                BNE.S READ_S_REC1
                RTS


GET_TYPE        BSR inChar
                *BSR outChar
                CMP.B #'8',D0
                BNE CHECK_START

WAIT_CR         BSR inChar
                *BSR outChar
                CMP.B #CR,D0
                BNE.S WAIT_CR

                BSR NEW_LINE
                BSR NEW_LINE
                MOVE.L D4,D0
                BSR PRINT_DEC     ; SHOW NUMBER OF BYTE RECEIVED
                MOVEA.L #NUMBER,A3
                BSR PSTR

                SWAP.W D5
                CLR.L D0
                MOVE.W D5,D0
                BSR PRINT_DEC
                MOVEA.L #ERROR,A3
                BSR PSTR
                RTS


CHECK_START     CMP.B #'2',D0	; CHECK S2 RECORD
                BEQ.S READ_S2

                CMP.B #'1',D0	; CHECK S1 RECORD
                BEQ.S READ_S1

                CMP.B #'0',D0	; CHECK S0 RECORD
                BEQ.S READ_S_REC1	; SKIP DATA
                BRA.S READ_S_REC1	; SKIP DATA


START_FOUND     CLR.W D5          ; CLEAR BYTE CHECK SUM

                BSR GET_HEXS
                CLR.L D7
                MOVE.B D1,D7       ; NUMBER OF BYTE SAVED TO D7
                ;SUBQ.B #5,D7
                ;MOVE.L D7,D0

                ADD.B  D1,D5       ; ADD CHECK SUM
		RTS

;S1 (2 BYTE ADDRESS)
READ_S1		BSR START_FOUND

              SUBQ.B #4,D7
              MOVE.L D7,D0

; GET 16-BIT ADDRESS, SAVE TO A6

              CLR.L D6
              BSR GET_HEXS
              MOVE.B D1,D6
              ADD.B  D1,D5          ; ADD CHECK SUM

              ROL.L #8,D6
              BSR GET_HEXS
              MOVE.B D1,D6
              ADD.B D1,D5           ; ADD CHECK SUM

              MOVEA.L D6,A6
              BRA READ_DATA           


;S2 (3 BYTE ADDRESS)
READ_S2       BSR START_FOUND                

              SUBQ.B #5,D7
              MOVE.L D7,D0

; GET 24-BIT ADDRESS, SAVE TO A6

              CLR.L D6
              BSR GET_HEXS
              MOVE.B D1,D6
              ADD.B  D1,D5

              ROL.L #8,D6
              BSR GET_HEXS
              MOVE.B D1,D6
              ADD.B D1,D5

              ROL.L #8,D6

              BSR GET_HEXS
              MOVE.B D1,D6
              ADD.B D1,D5

              MOVEA.L D6,A6
                         
READ_DATA     BSR GET_HEXS
              ADD.B  D1,D5      ; ADD CHECK SUM
              MOVE.B D1,(A6)+

              not.b d1          ; complement before sending

              ;MOVE.B D1,DOUT.L  ; INDICATOR WHILE LOADING

              ADDQ.L #1,D4      ; BUMP NUMBER OF BYTE RECEIVED
              DBF D7,READ_DATA

              NOT.B D5          ; ONE'S COMPLEMENT OF BYTE CHECK SUM         

              BSR GET_HEXS      ; GET BYTE CHECK SUM

              CMP.B D1,D5       ; COMPARE CHECK SUM
              BEQ.S NO_ERROR

              ADD.L #$10000,D5  ; ADD 1 TO UPPER WORD
              MOVE.B #'X',D0    ; IF NOT EQUAL SEND 'X' FOR ERROR
              BRA.S CHECKSUM_ERROR

NO_ERROR      MOVE.B #'_',D0      ; '_' NO ERROR RECORD
CHECKSUM_ERROR BSR outChar

              BRA READ_S_REC1

*
*LOOP_BACK     BSR inChar
*              CMP.B #13,D0
*              BNE LOOP_BACK
*              RTS

**********************************
* Strings
*
msgBanner:
    dc.b CR,LF,'ZTG 68K ROM Monitor',CR,LF
    dc.b       '==============================',CR,LF,0
msgHelp:
    dc.b 'Available Commands: ',CR,LF
    dc.b ' (E)xamine  (D)eposit  (R)un   (L)oadsr   (H)elp',CR,LF,0
msgDepositPrompt:
    dc.b ': ',0
msgPrompt:
    dc.b '> ',0
msgInvalidCommand:
    dc.b 'Invalid Command',CR,LF,0
msgInvalidAddress:
    dc.b 'Invalid Address',CR,LF,0
msgInvalidValue:
    dc.b 'Invalid Value',CR,LF,0
msgRamCheck:
    dc.b 'Checking RAM...',CR,LF,0
msgRamFail:
    dc.b 'Failed at: ',0
msgRamPass:
    dc.b 'Passed.',CR,LF,0
msgNewline:
    dc.b CR,LF,0
msgColonSpace:
    dc.b ': ',0


LOAD   DC.B 'Load Motorola s-record (accept s1,s2 and s8) quit: ESC',13,10,0

NUMBER DC.B ' bytes loaded, ',0
ERROR  DC.B ' records checksum error',13,10,0

NEW    DC.B 'New 24-bit pointer',0


HEX    DC.B 'Hex dump memory',13,10,10
       DC.B 'ADDRESS  0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F',0

*TITLE  DC.B 13,10,'68kmon',13,10,0

*PROMPT DC.B '>',0

**********************************
* vars pointers?
*
    ORG $100400
;RAMBASE  DC.L   1   ; RAM BASE ADDRESS
RAMBASE  DS.L   $100          ; RAM BASE ADDRESS

;RAM      EQU $000000            ; RAM START ADDRESS


OFFSET      EQU  0               ; FOR DISASSEMBLER USAGE
*DEBUG       EQU  OFFSET+32
FLAG        EQU  OFFSET+4         ; 16-BIT MONITOR FLAG
BUFFER      EQU  OFFSET+8
*POINTER_NOW EQU  BUFFER+128


    END    START            * last line of source


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~




