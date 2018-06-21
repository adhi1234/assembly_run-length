%define BUF_SIZE 1024									; Constant for buffer size in .bss

SECTION		.data										; Initialized data section
	InputMsg: db  "Enter ye text hitherto forth:",10	; Input prompt var
	InputLen: equ $-InputMsg							; Input prompt size

	NewLine:  db  "",0Ah,0								; Blank var to format output
	NewLen:   equ $-NewLine								; Length of blank var

SECTION		.bss						; Section containing uninitialized data
	InputBuffer:  resb BUF_SIZE			; Length of the buffer, const 1024 bits
	BufInput:     equ $-InputBuffer		; Text buffer for input
	
	OutputBuffer: resb BUF_SIZE			; Length of the buffer, const 1024 bits
	BufOutput:    equ $-OutputBuffer	; Text buffer for output

SECTION		.text			; Section contain the code
global		_start			; Linker needs this to find the entry point!
extern		exit			; Linking external library file to this program
%include	"lib.mac"		; Including a macro file to help keep code organized

_start:								; Start program 
	writeMsg InputMsg,InputLen		; Prints user prompt to enter parens
	readMsg InputBuffer,BufInput	; Read a buffer full of text from stdin
	mov edi,OutputBuffer			; Move the output buffer to edi
	xor edx,edx						; Clear edx reg
	mov edx,48						; Initialize edx to 48 (ascii offset)
	jmp MoveCurrLett				; Jump to MoveCurrLett (stage current char to compare)

CompareValues:						; Compare the two values for equality
	cmp bl,0xa						; Check to see if end of buffer has been reached
	je  WriteOut					; If end of buffer, jump to writeOut
	cmp al,bl						; Compare al and bl
	je  Increment					; If al and bl are equal, jump to increment

StoreOutput:						; Store the current character to buffer, clear, reset
	stosb							; Store the current character to next position in output buff
	xor eax,eax						; Clear eax reg
	mov al,dl						; Move the counter (dl) into al
	stosb							; Store the counter at the next position in output buff
	jmp Reset						; Jump to reset

Increment:							; Increments the counter var for repetition
	inc edx							; Increase the value of edx (counter)
	xor ebx,ebx						; Clear ebx reg
	inc ecx							; Increment the pointer for ecx (input buffer)
	mov bl,[ecx]					; Move the value of the thing at input buff addy to bl
	jmp CompareValues				; Jump to compare values

MoveCurrLett:						; Move the current character into al and stage the buff index
	xor eax,eax						; CLear eax reg
	xor ebx,ebx						; Clear ebx reg
	mov al,[ecx]					; Move the value of the thing at input buff addy (ecx) to al
	mov bl,[ecx]				 	; Move the value of the thing at input buff addy (ebx) to bl
	jmp CompareValues				; Jump to compare values

Reset:								; Reset variables after writing out current
	xor eax,eax						; Clear eax reg	(current char for comparison)
	xor ebx,ebx						; Clear ebx reg (input index value)
	xor edx,edx						; Clear edx reg (counter)
	mov edx,48						; Initialize edx (counter) to 48 to offset ascii value
	jmp MoveCurrLett				; Jump to MoveCurrLett to stage next set

WriteOut:							; Store last values and exit program
	stosb							; Store char from al into next available spot in output buff
	xor eax,eax						; Clear eax
	mov al,dl						; Move the counter value into al for writing
	stosb							; Store the counter value to next available spot in output buff
	writeMsg OutputBuffer,BufOutput ; Write the output buffer to stdout
	writeMsg NewLine,NewLen			; Write the new line to stdout (improve formatting)
	call exit						; Call external library for exit program
