;Author: Peter Adamson 3319005
;this program makes use of three seperate functions in order to count the length of a message and how many words are in that message.
;the length of the message is stored in len, while the number of words in the message is returned in R0

TOP_STACK	EQU	0X2000
START
	LDR	sp,=TOP_STACK
	LDR	R1,=msg
	BL	STRLEN
	STR	R0,len		;store the length
	BL	CNTWRD
	STR	R0,nwrds	;store the number of words
STOP	B	STOP


CNTWRD
	STMDB	sp!,{R1-R5,LR}
	MOV	R4,#0		;initialize a counter for the number of words
	MOV	R5,#0		;set our indicator to 0
LOOP2			
	LDRB	R2,[R1],#1      ;loads the ith byte of message into R2 then increments R1
	CMP	R2,#0
	BEQ	DONE3	        ;if R2 is 0, we have reached the end of our message.  Finish
	BL	ISALPHA	        ;call the ISALPHA function
	CMP	R5,R0
	BEQ	SKIPTO	        ;if R5 and R0 is equal, nothing has been changed by ISALPHA, so we are either still in a word, or still between words.  Continue looping
	CMP	R0,#1		
	ADDEQ	R4,R4,#1 	;if R0 has been set to 1, we are pointing to a word so add one to the word counter
	MOV	R5,R0	        ;flip R5 to equal R0 to indicate that we need to loop through to the end of the current word or current space
SKIPTO
	B	LOOP2
DONE3
	MOV	R0,R4		;store the word counter in R0
	LDMIA	sp!,{R1-R5,PC}
	BX	R14

ISALPHA
	STMDB	sp!,{LR}	;stores the link register in the stack 
	MOV	R0,#0	        ;defaults R0 to 0
	CMP	R2,#'A'	        
	BLT	DONE1	        ;if the value in R2 is less than 'A', nothing needs to be done
    	CMP 	R2,#'z'
	BGT	DONE1	        ;if the value in R2 is greater than 'z', nothing needs to be done
	CMP	R2,#'Z'
	MOVLE	R0,#1	        
	BLE	DONE1	        ;if this instruction is reached, the value in R2 is greater than 'A'.  If it is also less than 'Z', set R0 to 1
	CMP	R2,#'a'	        
	MOVGE	R0,#1	        ;if this instuction is reached, the value in R2 is less than 'z'.  If it is also greater than 'a', set R0 to 1
DONE1
	LDMIA	sp!,{PC}   	;load the link register into the program counter
	BX	R14

STRLEN
	STMDB	sp!,{R1,R3,LR}  	;stores the link register in the stack
LOOP1	
	LDRB	R3,[R1],#1	;load the ith byte of the string into R3, then increment R1
	CMP	R3,#0
	BEQ	DONE2 		;if the byte loaded into R3 is 0, we have reached the end of the string.  Do nothing
	ADD	R0,R0,#1    	;if we are not at the end of the string, add 1 to the counter in R0
	B	LOOP1      	;loop back to check the next byte
DONE2
	LDMIA	sp!,{R1,R3,PC}       	;loads the link register into the program counter
	BX	R14

msg	DCB	"This is a test string.  See if it works: test-case"
	DCB	0 	;NULL marks the end of the string
	ALIGN	4
len	SPACE	4
nwrds	SPACE	4
