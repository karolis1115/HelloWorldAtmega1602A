	.equ RS = 0b100
	.equ RW = 0b010
	.equ E = 0b001
	.equ OFF = 0x00
	ldi r19,LOW(RAMEND)
	out spl,r19
	ldi r20,HIGH(RAMEND)
	out sph,r20

	;8-bit mode lcd control code
	;haha clock go brrrrrrrrrrrr

	ldi r16,0xFF ;set all of r16 register
	out DDRD,r16 ;set data dirrection register of PORTD
	out DDRB,r16 ;set data dirrection register of PORTB

	ldi r17,0b00111000	;Sets to 8-bit operation and selects 2-line display and 5 ? 8 dot character font.
	rcall send_inst
	ldi r17,0b00001110	;Turns on display and cursor. All display is in space mode because of initialization.
	rcall send_inst
	ldi r17,0b00000110	;Sets mode to increment the address by one and to shift the cursor to the right at the time ofwrite to the DD/CGRAM. Display is not shifted.
	rcall send_inst
	ldi r17,0b00000001
	rcall send_inst

	ldi r17,0b01001000 ;H
	rcall send_char
	ldi r17,0b01100101 ;e
	rcall send_char
	ldi r17,0b01101100 ;l
	rcall send_char
	ldi r17,0b01101100 ;l
	rcall send_char
	ldi r17,0b01101111 ;o
	rcall send_char
	ldi r17,0b00101100 ;,
	rcall send_char
	ldi r17,0b00100000 ;spc
	rcall send_char
	ldi r17,0b01110111 ;w
	rcall send_char
	ldi r17,0b01101111 ;o
	rcall send_char
	ldi r17,0b01110010 ;r
	rcall send_char
	ldi r17,0b01101100 ;l
	rcall send_char
	ldi r17,0b01100100 ;d
	rcall send_char
	ldi r17,0b00100001 ;!
	rcall send_char
	
loop:
	rjmp loop

lcd_wait:
	push r17 ;save r17 contents
	ser r16 ;set PORTD to input
	out DDRD,r16
lcd_busy:
	ldi r18,RW	;send RW signal
	out PORTB,r18
	ldi r18,(RW|E) ;send RW + E signal
	out PORTB,r18

	ldi r18,PORTD	;read from PORTD
	ldi r21,0b1	;set r19 for 'and' instruction
	and r18,r21	;and
	brne lcd_busy	;branch if not equal
	ldi r18,RW	;send RW signal
	out PORTB,r18

	ldi r16,0xFF	;set PORTD back to output
	out DDRD,r16
	pop r17 ;return saved r17 contents
	ret

send_inst:
	rcall lcd_wait
	out PORTD,r17
	ldi r18,E
	out PORTB,r18
	ldi r18,OFF
	out PORTB,r18
	ret

send_char:
	rcall lcd_wait
	out PORTD,r17
	ldi r18,(RS|E)
	out PORTB,r18
	ldi r18,RS
	out PORTB,r18
	ret