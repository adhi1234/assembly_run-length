SECTION		.text
global		exit

	exit:
		mov eax,1
		mov ebx,0
		int 80H
