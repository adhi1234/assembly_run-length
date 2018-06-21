%define BUF_SIZE 1024										; Constant for buffer size in .bss

SECTION		.data											; Initialized data section
	InputMsg: db  "Enter ye encrypted text and behold:",10	; Input prompt var
	InputLen: equ $-InputMsg								; Input prompt size

	NewLine:  db  "",0Ah,0									; Blank var to format output
	NewLen:   equ $-NewLine									; Length of blank var

SECTION		.bss						; Section containing uninitialized data
	InputBuffer:  resb BUF_SIZE			; Length of the buffer, const 1024 bits
	BufInput:     equ $-InputBuffer		; Text buffer for input
	
	OutputBuffer: resb BUF_SIZE			; Length of the buffer, const 1024 bits
	BufOutput:    equ $-OutputBuffer	; Text buffer for output

SECTION		.text			; Section containing the code
global		_start			; Linker needs this to find the entry point!
extern 		exit			; Linking external library file to this program
%include	"lib.mac"		; Including a macro file to organize code

_start:								; Start program
	writeMsg InputMsg,InputLen		; Write the user prompt to stdout
	readMsg InputBuffer,BufInput	; Read the input buffer full of text from stdin
	mov edi,OutputBuffer			; Move the output buffer to edi
	xor eax,eax						; Clear eax
	xor ebx,ebx						; Clear ebx

InitialComparison:					; Ensures what is read in is not empty/equal to return
	mov al,[ecx]					; Move the value of what's at ecx add to al
	cmp al,0xa						; Check for end of string
	je  Exit						; If end of string then jump to exit

StoreFirstChar:						; Store the first char and prepare to loop x times
	stosb							; Store first char to output buffer (what is in al to edi)
	inc   ecx						; Increment the pointer at ecx to next value
	mov   bl,[ecx]					; Move the value of the thing at the new ecx position to bl (this is num)
	sub   bl,48						; Subtract 48 from bl (we are restricting certain ascii values. Set 0
	dec   bl						; Decrement the number at bl

TheStosBLoop:						; This loop prints to output buffer the appropriate number of char in al
	cmp   bl,0						; Check to see if loop has met condition (number of iterations set by bl)
	je    GetNextChar				; If has met conditions then get next character from input
	stosb							; If not store the char in new position in output buffer
	dec   bl						; Decrement bl since char has been written out
	jmp   TheStosBLoop				; Repeat loop to check to see if loop exit condition is met

GetNextChar:						; Get the next character from input
	inc ecx							; Increase pointer at ecx to next value
	xor eax,eax						; Clear eax reg
	xor ebx,ebx						; Clear ebx reg
	jmp InitialComparison			; Jump to InitialComparison

Exit:								; Exit protocol writes output buffer to stdout and terminates program
	writeMsg OutputBuffer,BufOutput ; Write the output buffer to stdout
	writeMsg NewLine,NewLen			; Write a new line for readability
	call exit						; Call the library for exit protocol
