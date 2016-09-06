;Assuming user will only enter ' ' 0-9 *+/-
;
;
;
.ORIG x3000
	
;your code goes here
	











;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;R3- value to print in hexadecimal
PRINT_HEX

;initialize registers except for R3

	AND R0, R0, #0; holds value to print 
	AND R1, R1, #0; counter for characters printed
	AND R2, R2, #0; counter for the number of bits read
	AND R4, R4, #0;holds a copy of R3 contents being shifted 
	AND R5, R5, #0; holds a copy of R4 to set cc



	ADD R1, R1, #4; set digit counter to 4
OUTERLOOP 
	ADD R1, R1, #0; set cc for R1 
	BRz DONE
; end program when all of R3 has been read
	AND R4, R4, #0; clear R4
	ADD R2, R2, #4;
READ 	ADD R2, R2, #0; set cc for R2 
	BRz ASCII_VAL
	ADD R4, R4, R4; shift contents of R4 to the left
	ADD R3, R3, #0; set cc for R3
	BRzp ZERO_DIGIT
	ADD R4, R4,#1; add 1 to R4 if negative value is in R3
	BRnzp SHIFT_LEFT
ZERO_DIGIT 
	ADD R4, R4, #0; Add 0 to R4 if R3 is zero or positve 
SHIFT_LEFT 
	ADD R3, R3, R3; shift contents of R3 to the left
	ADD R2, R2, #-1; decrement R2
BRnzp READ

ASCII_VAL 
	ADD R5, R4, #0; copy R4 into R5
	AND R0, R0, #0; clear R0
	ADD R5, R5, #-9; set cc for conditional statment
	BRnz ASCII_NUM
	LD R6, ASCII_A
	ADD R0, R4, R6; put the correct ascii value in R0 for letters
	ADD R0, R0, #-10
	BRnzp PRINT
ASCII_NUM 
	LD R6, ASCII_ZERO
	ADD R0, R4, R6; put the correct ascii value in R0 for numbers
PRINT OUT; print the character
	ADD R1, R1, #-1; decrement outerloop counter
	BRnzp OUTERLOOP

 ; stop the computer
 DONE HALT

 ; program data section starts here

ASCII_ZERO .FILL x30
ASCII_A    .FILL x41

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;R0 - character input from keyboard
;R6 - current numerical output
;
;
EVALUATE

GETC	;Read character from keyboard to monitor
	AND R5, R5, #0; 
	ADD R5, R5, #-1; assume set is unbalanced to start
	LD R6, NEG_NEWLINE
	ADD R6, R0, R6	; compare additive inverse of newline to character inputted 
	BRz DONE	;halt program if new line is entered
	LD R6, NEG_SPACE
	ADD R6, R0, R6	; compare input to space
	BRz EVALUATE
	
	LD, R6, NEG_ASTERIK 
	ADD R6, R0, R6  ; compare input to asterik
	BRnp NEG_PLUS   ; moves to NEG_PLUS if char entered is not asterik
	JSR POP
	JSR POP
	
	LD, R6, NEG_PLUS 
	ADD R6, R0, R6  ; compare input to plus
	BRnp NEG_DIVIDE ; moves to NEG_DIVIDE if char entered is not plus
	JSR POP
	JSR POP

	LD, R6, NEG_DIVIDE
	ADD R6, R0, R6  ; compare input to divide
	BRnp NEG_SUBTACT; moves to NEG_SUBTRACT if char entered is not divide
	JSR POP
	JSR POP

	LD, R6, NEG_SUBTRACT
	ADD R6, R0, R6  ; compare input to subtract
	BRnp NEG_EXPONENT; moves to NEG_EXPONENT if char entered is not subtract
	JSR POP
	JSR POP

	LD, R6, NEG_EXPONENT
	ADD R6, R0, R6  ; compare input to exponent
	BRnp NEG_ZERO	; moves to ASCII_A if char entered is not exponent
	JSR POP
	
	JSR POP
	
	LD R6, NEG_ZERO
	ADD R6, R0, R6	 ; compare input to NEG_ZERO
	BRnp NEG_NINE
	JSR PUSH

	LD R6, NEG_NINE
	ADD R6, R0, R6	; compare input to NEG_NINE
	BRnp EVALUATE
	JSR PUSH

INVALID
	;; needs code	
	

;your code goes here


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;input R3, R4
;out R0
PLUS	
;your code goes here
	ADD R0, R3, R4;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;input R3, R4
;out R0
MIN	
;your code goes here
	NOT R3, R3,
	ADD R3, R3, #1
	ADD R0, R3, R4
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;input R3, R4
;out R0
MUL	
;your code goes here
	AND R0, R0, #0
	ADD R0, R3, R0
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;input R3, R4
;out R0
;DIV	
;your code goes here
	
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;input R3, R4
;out R0
;EXP
;your code goes here
	
;IN:R0, OUT:R5 (0-success, 1-fail/overflow)
;R3: STACK_END R4: STACK_TOP
;
PUSH	
	ST R3, PUSH_SaveR3	;save R3
	ST R4, PUSH_SaveR4	;save R4
	AND R5, R5, #0		;
	LD R3, STACK_END	;
	LD R4, STACk_TOP	;
	ADD R3, R3, #-1		;
	NOT R3, R3		;
	ADD R3, R3, #1		;
	ADD R3, R3, R4		;
	BRz OVERFLOW		;stack is full
	STR R0, R4, #0		;no overflow, store value in the stack
	ADD R4, R4, #-1		;move top of the stack
	ST R4, STACK_TOP	;store top of stack pointer
	BRnzp DONE_PUSH		;
OVERFLOW
	ADD R5, R5, #1		;
DONE_PUSH
	LD R3, PUSH_SaveR3	;
	LD R4, PUSH_SaveR4	;
	RET


PUSH_SaveR3	.BLKW #1	;
PUSH_SaveR4	.BLKW #1	;


;OUT: R0, OUT R5 (0-success, 1-fail/underflow)
;R3 STACK_START R4 STACK_TOP
;
POP	
	ST R3, POP_SaveR3	;save R3
	ST R4, POP_SaveR4	;save R3
	AND R5, R5, #0		;clear R5
	LD R3, STACK_START	;
	LD R4, STACK_TOP	;
	NOT R3, R3		;
	ADD R3, R3, #1		;
	ADD R3, R3, R4		;
	BRz UNDERFLOW		;
	ADD R4, R4, #1		;
	LDR R0, R4, #0		;
	ST R4, STACK_TOP	;
	BRnzp DONE_POP		;
UNDERFLOW
	ADD R5, R5, #1		;
DONE_POP
	LD R3, POP_SaveR3	;
	LD R4, POP_SaveR4	;
	RET
ASCII_ZERO	.FILL x30
ASCII_NINE	.FILL x39
ASCII_ASTERIK 	.FILL x2A
ASCII_PLUS	.FILL x2B
ASCII_DIVIDE	.FILL x2F
ASCII_SUBTRACT	.FILL x2D
ASCII_EXPONENT	.FILL x5E

NEG_ZERO	.FILL xFFD0
NEG_NINE	.FILL xFFC7
NEG_ASTERIK	.FILL FFD6
NEG_PLUS	.FILL FFD5
NEG_DIVIDE	.FILL FFD1
NEG_SUBTRACT	.FILL FFD3
NEG_EXPONENT	.FILL FFA3

.STRINGZ "Invalid Expression"

POP_SaveR3	.BLKW #1	; 
POP_SaveR4	.BLKW #1	;
STACK_END	.FILL x3FF0	;
STACK_START	.FILL x4000	;
STACK_TOP	.FILL x4000	;


.END
