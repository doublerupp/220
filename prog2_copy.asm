;Assuming user will only enter ' ' 0-9 *+/-
;
;
;
.ORIG x3000
	
;;;;;Intro Paragraph: This program takes the input from the user in the form of reverse polish notation, and then it performs the necessary calculations. The calculations are performed by utilizing specific subroutines called using the JSR function to perform the necessary operations. The user input is pushed to a stack until an operator is detected, which is when the necessary arithmetic subroutine is called. The arithmetic subroutines assume that the input is stored in R3 and R4 through popping user input into a stack. When the stack only has one value signifying the final answer, this program utilizes the algorithm used in lab 1 and mp1 to print the result in hexidecimal and store the final result in R5.

	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;R0 - character input from keyboard
;R6 - current numerical output
;
;

;LD R0, ASCII_PLUS

EVALUATE
	ST R0, SAVER0_EVAL
GETC	;Read character from keyboard to monitor
	AND R5, R5, #0; 
	ADD R5, R5, #-1; assume set is unbalanced to start
	LD R6, NEG_NEWLINE	
	ADD R6, R0, R6	; compare additive inverse of newline to character inputted 
	BRz DONE	;halt program if new line is entered
	LD R6, NEG_CARRIAGE
	ADD R6, R0, R6	;
	BRz DONE
	LD R6, NEG_SPACE
	ADD R6, R0, R6	; compare input to space
	BRz EVALUATE
	OUT

	
	
N_PLUS	LD R6, NEG_PLUS 
	ADD R6, R0, R6  ; compare input to plus
	BRnp N_MUL ; moves to NEG_DIVIDE if char entered is not plus
	JSR PLUS
	BRnzp EVALUATE	;returns to evaluate loop if subroutine is executed

N_MUL
	LD R6, NEG_ASTERIK
	ADD R6, R0, R6	; compare input to multiplication operator 
	BRnp N_DIVIDE ; if it isn't '*' proceed to divide
	JSR MUL
	BRnzp EVALUATE
	
N_DIVIDE	
	LD R6, NEG_DIVIDE
	ADD R6, R0, R6  ; compare input to divide
	BRnp N_SUBTRACT ; moves to NEG_SUBTRACT if char entered is not divide
	JSR DIV
	BRnzp EVALUATE

N_SUBTRACT
	LD R6, NEG_SUBTRACT
	ADD R6, R0, R6  ; compare input to subtract
	BRnp N_EXPONENT ; moves to NEG_EXPONENT if char entered is not subtract
	JSR MIN
	BRnzp EVALUATE

N_EXPONENT
	LD R6, NEG_EXPONENT
	ADD R6, R0, R6  ; compare input to exponent
	BRnp N_ZERO	; moves to ASCII_A if char entered is not exponent
	JSR EXP
	BRnzp EVALUATE

N_ZERO	
	LD R6, NEG_ZERO

ASCII_LOOP 
	ST R6, LOOP_SAVER6
	ADD R6, R0, R6	 	; compare input to NEG_ZERO
	BRn  INVALID 		;detect    input and determine what number it is or if invalid
	BRp NEXT_NUMBER
	LD R6, NEG_NINE
	ADD R6, R0, R6
	BRp INVALID

	
	ADD R0, R0, #-16 ; remove ascii offest
	ADD R0, R0, #-16 ; after removing offset push to stack
	ADD R0, R0, #-16 ;
	JSR PUSH
	BRnzp EVALUATE	

NEXT_NUMBER
	LD R6, LOOP_SAVER6
	ADD R6, R6, #-1	 ;
	BRnzp ASCII_LOOP ;
	
CHECK_INVALID
	ADD R5, R5, #0;
	BRp INVALID
	RET		;invalid  in case of underflow when the pop subroutine returns a value of 1 in R5

INVALID
	LEA R1, INVALID_EXPRESSION	;loop to print "Invalid Expression", which is a string stored in memory
	LD R0, NEW_LINE
	OUT

ERROR_MESSAGE
		
	LDR R0, R1, #0  ;put ascii values of the string into R0
	BRz FINISHED	;HALT if null character is found
	OUT
	ADD R1, R1, #1	;increment pointer
	BRnzp ERROR_MESSAGE
	OUT

		

DONE
	LD R0, SAVER0_EVAL
	LD R3, STACK_TOP
	LD R4, STACK_START
	NOT R3, R3
	ADD R3, R3, R4	;
	BRnp INVALID
	AND R5, R5, #0	;
	ADD R5, R5, R0 	; copy answer into R5
	JSR PRINT_HEX	;execute final subroutine to print result in hex
	
	

FINISHED
	LD R5, PRINT_HEX_STR5
	HALT

NEW_LINE	.FILL x000A
;;;check or underflow
CHECK_UNDERFLOW
	ADD R5, R5, #0
	BRp INVALID
	RET

INVALID_EXPRESSION .STRINGZ "Invalid Expression"
NEG_CARRIAGE	.FILL xFFF3
NEG_NEWLINE	.FILL xFFF6
NEG_SPACE	.FILL xFFDF
NEG_ZERO	.FILL xFFD0
NEG_NINE	.FILL xFFC7
NEG_ASTERIK	.FILL xFFD6
NEG_PLUS	.FILL xFFD5
NEG_DIVIDE	.FILL xFFD1
NEG_SUBTRACT	.FILL xFFD3
NEG_EXPONENT	.FILL xFFA2
ASCII_NINE	.FILL x39
ASCII_ASTERIK 	.FILL x2A
ASCII_PLUS	.FILL x2B
ASCII_DIVIDE	.FILL x2F
ASCII_SUBTRACT	.FILL x2D
ASCII_EXPONENT	.FILL x5E
LOOP_SAVER6	.BLKW #1
SAVER0_EVAL	.BLKW #1


PRINT_HEX_STR0	.BLKW #1
PRINT_HEX_STR1	.BLKW #1
PRINT_HEX_STR2	.BLKW #1
PRINT_HEX_STR3	.BLKW #1
PRINT_HEX_STR4	.BLKW #1
PRINT_HEX_STR5	.BLKW #1
PRINT_HEX_STR6	.BLKW #1




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;input R3, R4
;out R0
PLUS
;save registers before excuting subroutine

	ST R1, PLUS_SAVER1
	ST R2, PLUS_SAVER2
	ST R3, PLUS_SAVER3		
	ST R4, PLUS_SAVER4
	ST R6, PLUS_SAVER6			
	ST R7, PLUS_SAVER7	

	
	;pop numbers in stack and store in R3 and R4 respectively
	JSR POP
	ADD R3, R0, #0	;
	JSR CHECK_UNDERFLOW
	
	

	JSR POP
	JSR CHECK_UNDERFLOW

	ADD R4, R0, #0 	;

	AND R0, R0, #0	;
	ADD R0, R3, R4	;

	;push result to stack from subroutine
	JSR PUSH

	LD R1, PLUS_SAVER1
	LD R2, PLUS_SAVER2
	LD R3, PLUS_SAVER3		
	LD R4, PLUS_SAVER4
	LD R6, PLUS_SAVER6			
	LD R7, PLUS_SAVER7	
	
RET
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;input R3, R4
;out R0
MIN	
;save registers before subroutine
			
	ST R1, PLUS_SAVER1
	ST R2, PLUS_SAVER2
	ST R3, PLUS_SAVER3		
	ST R4, PLUS_SAVER4
	ST R6, PLUS_SAVER6			
	ST R7, PLUS_SAVER7
	
	;pop numbers in stack
	JSR POP
	ADD R3, R0, #0	;
	JSR CHECK_UNDERFLOW
	
	

	JSR POP
	JSR CHECK_UNDERFLOW

	ADD R4, R0, #0 	;

	AND R0, R0, #0	;
	NOT R3, R3	;
	ADD R3, R3, #1	; inverse R4	
	ADD R0, R3, R4	; subtract R4 from R3 and store in R0

	;push result to stack
	JSR PUSH

	;restore register values
	LD R1, PLUS_SAVER1
	LD R2, PLUS_SAVER2
	LD R3, PLUS_SAVER3		
	LD R4, PLUS_SAVER4
	LD R6, PLUS_SAVER6			
	LD R7, PLUS_SAVER7
RET	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;input R3, R4
;out R0
MUL	
;save registers
	ST R1, PLUS_SAVER1
	ST R2, PLUS_SAVER2
	ST R3, PLUS_SAVER3		
	ST R4, PLUS_SAVER4
	ST R6, PLUS_SAVER6			
	ST R7, PLUS_SAVER7
	;pop values from stack

	JSR POP
	ADD R3, R0, #0	;
	JSR CHECK_UNDERFLOW
	

	JSR POP
	ADD R4, R0, #0 	;
	JSR CHECK_UNDERFLOW
	
	AND R6, R6, #0; clear R6
	ADD R6, R4, #0; copy R4 into R6
	ADD R3, R3, #0; set cc for R3
	BRz MULT_ZERO	;multiply by zero case
MULT_NONZERO
	ADD R3, R3, #-1; set cc for R3 for cases other that multiply by 0
	Brz MULT_DONE	; when multiplication counter is 0, finish subroutine
	ADD R4, R4, R6; implement multiplication loop
	BRnzp MULT_NONZERO
MULT_ZERO
	AND R0, R0, #0; account for multiply by zero case
	BRnzp FIN_MULT
MULT_DONE
	ADD R0, R4, #0; place result in R0
	
FIN_MULT
	JSR PUSH

	;restore registers
	LD R1, PLUS_SAVER1
	LD R2, PLUS_SAVER2
	LD R3, PLUS_SAVER3		
	LD R4, PLUS_SAVER4
	LD R6, PLUS_SAVER6			
	LD R7, PLUS_SAVER7
RET
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;input R3, R4
;out R0
	
DIV	
	ST R1, PLUS_SAVER1
	ST R2, PLUS_SAVER2
	ST R3, PLUS_SAVER3		
	ST R4, PLUS_SAVER4
	ST R6, PLUS_SAVER6			
	ST R7, PLUS_SAVER7
	;saved registers
	AND R4, R4, #0; clear R4
	AND R3, R3, #0; clear R3

	JSR POP
	ADD R3, R0, #0	;
	JSR CHECK_UNDERFLOW
	AND R0, R0, #0; clear R0

	JSR POP
	ADD R4, R0, #0 	;
	JSR CHECK_UNDERFLOW
	
	
	AND R0, R0, #0; clear R0
	ADD R3, R3, #0; set cc for divide by zero case
	BRz INVALID	; print error message if the input is invalid
	NOT R3, R3	; find inverse of the second input	
	ADD R3, R3, #1	;R3<- -R3
DIV_LOOP
	ADD R4, R3, R4	; 
	;ADD R4, R4, #0 set cc for R4
	BRn DONE_DIV
	ADD R0, R0, #1 ; increment R0 for each time difference between R3 and R4 is positve
	BRnzp DIV_LOOP
DONE_DIV
	JSR PUSH
	
	;push result to stack and restore registers
	LD R1, PLUS_SAVER1
	LD R2, PLUS_SAVER2
	LD R3, PLUS_SAVER3		
	LD R4, PLUS_SAVER4
	LD R6, PLUS_SAVER6			
	LD R7, PLUS_SAVER7
RET
	
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;input R3, R4
;out R0
EXP
	ST R1, PLUS_SAVER1
	ST R2, PLUS_SAVER2
	ST R3, PLUS_SAVER3		
	ST R4, PLUS_SAVER4
	ST R6, PLUS_SAVER6			
	ST R7, PLUS_SAVER7
	;save registers and implement exponentiation algorithm

	JSR POP
	ADD R3, R0, #0	;
	JSR CHECK_UNDERFLOW
	AND R0, R0, #0; clear R0

	JSR POP
	ADD R4, R0, #0 	;
	JSR CHECK_UNDERFLOW
	
	AND R2, R2, #0; clear R2 as a temp register
	ADD R2, R4, #0; copy R4 into R6 initially
	AND R6, R6, #0; clear R6 as a temp register
	AND R0, R0, #0	;clear R0
	ADD R3, R3, #0; check value of power
	BRz ZERO_POWER
	ADD R3, R3, #-1; check for one power case
	BRz ONE_POWER
	ADD R3, R3, #1; Restore value for R3
	ADD R6, R4, #0; copy R4 into R6 for other uses
	ADD R0, R6, #0;
POWER_LOOP
	ADD R3, R3, #-1; set cc
	BRz DONE2	;; code to next part of program
	AND R4, R4, #0; 
	ADD R4, R6, #0; clear and restore R4
EXP_MULT_LOOP
	ADD R4, R4, #-1; set cc
	BRnz NEXT
	ADD R0, R0, R2;
	BRnzp EXP_MULT_LOOP
NEXT
	AND R2, R2, #0; clear R2
	ADD R2, R0, #0; copy in R0 from previous loop
	BRnzp POWER_LOOP

ONE_POWER
	ADD R0, R4, #0; account for case when raised to the first power
	BRnzp DONE2
ZERO_POWER
	ADD R0, R0, #1; account for zero power case
	BRnzp DONE2
	
	
DONE2
	JSR PUSH		
	LD R1, PLUS_SAVER1
	LD R2, PLUS_SAVER2
	LD R3, PLUS_SAVER3		
	LD R4, PLUS_SAVER4
	LD R6, PLUS_SAVER6			
	LD R7, PLUS_SAVER7
RET



POP_SaveR3	.BLKW #1	; 
POP_SaveR4	.BLKW #1	;
STACK_END	.FILL x3FF0	;
STACK_START	.FILL x4000	;
STACK_TOP	.FILL x4000	;


PLUS_SAVER0	.BLKW #1
PLUS_SAVER1	.BLKW #1
PLUS_SAVER2	.BLKW #1
PLUS_SAVER3	.BLKW #1
PLUS_SAVER4	.BLKW #1
PLUS_SAVER5	.BLKW #1
PLUS_SAVER6	.BLKW #1
PLUS_SAVER7	.BLKW #1

;;code to print hex
PRINT_HEX
;initialize registers except for R3

ST R0, PRINT_HEX_STR0
ST R1, PRINT_HEX_STR1
ST R2, PRINT_HEX_STR2
ST R3, PRINT_HEX_STR3
ST R4, PRINT_HEX_STR4
ST R5, PRINT_HEX_STR5
ST R6, PRINT_HEX_STR6

ADD R3, R0, #0;
;; put hex output on newline and 'x' 
LD R0, NEW_LINE
OUT
LD R0, ASCII_X
OUT

AND R0, R0, #0; holds value to print 
AND R1, R1, #0; counter for characters printed
AND R2, R2, #0; counter for the number of bits read
AND R4, R4, #0;holds a copy of R3 contents being shifted 
AND R5, R5, #0; holds a copy of R4 to set cc



	ADD R1, R1, #4; set digit counter to 4
OUTERLOOP 
	ADD R1, R1, #0; set cc for R1 
	BRz FINISHED

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


ASCII_ZERO .FILL x30
ASCII_A    .FILL x41
ASCII_X    .FILL x78


.END
