all: encoder decoder

encoder: encoder.o lib.o
	ld -o encoder encoder.o lib.o

decoder: decoder.o lib.o
	ld -o decoder decoder.o lib.o

encoder.o: encoder.asm
	nasm -f elf -g -F stabs encoder.asm

decoder.o: decoder.asm
	nasm -f elf -g -F stabs decoder.asm

lib.o: lib.asm
	nasm -f elf -g -F stabs lib.asm

clean:
	rm *o encoder decoder
