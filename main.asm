.equ loop1 = 6
.equ seed = 0b00000001
.equ a = 0b00000001
ldi r18, loop1 ; Counter for the loop
ldi r16, seed ; Seed value
ldi r17, a ; Constant 'a’
ldi r19, 1

loop_start:
    ldi r17, a
    eor r16, r17 ; XOR the seed with constant 'a’
    lsl r16 ; Left shift the result
    mov r20, r16
    mov r21, r20
    andi r20, 0x0F ; Extracting LSD (last 4 bits)

; Extracting the most significant digit (MSD)
    lsr r21 ; Right shift to move the LSD
    andi r21, 0x0F ; Extracting MSD (last 4 bits)

;Check if r16 is in the range from 01 to 59
    cpi r16, 0x01 ; Compare r16 with 01
    brlo skip_print1 ; Skip printing if r16 < 01
    cpi r16, 0x3B ; Compare r16 with 59 (3B in
hexadecimal)
brsh skip_print2 ; Skip printing if r16 >= 59

; Port Addresses (Moved outside the loop)
.equ DDRC = 0x1A
.equ PINC = 0x19
.equ DDRA = 0x17
.equ PORTA = 0x1B
.equ DDRB = 0x14
.equ PORTB = 0x18
; Program Initialization: Set Ports
ldi r22, 0xFF ; Temporary register for port
initialization

out DDRC, r22 ; Set Port C for input
out DDRA, r22 ; Set Port A for output
out DDRB, r22 ; Set Port B for output
in r17, PINC ; Read the value on port C
out PORTA, r21 ; Output the value to port A
out PORTB, r20 ; Output the value to port B
dec r18 ; Decrement loop counter
brne loop_start ; Continue looping if counter not zero

skip_print1:
    brne loop_start ; Continue looping if counter not zero

skip_print2: ; Subroutine of if statement checking, changing the seed
    mov r22, r19
    ldi r17, 0x3B
    mul r22, r17
    sub r16, r22
    inc r19
    brne loop_start ; Continue looping if counternot zero

end: rjmp end  ; End of the program (infinite loop)
