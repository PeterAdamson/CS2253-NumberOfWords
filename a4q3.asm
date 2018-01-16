;Author: Peter Adamson
;This function counts the number of words in a string.  
;It uses the function ISALPHA to assist.  This function is found in the file a4q1.asm
;note that this function will not compile in isolation, as the ISALPHA function is required.  See a4q4.asm for tests

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
