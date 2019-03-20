# SignalHandler
Signal handling implementation in 32bit and 64bit asm


## Working

To compile 32 bit asm, 

1) `nasm -f elf32 32bit.asm`
2) `ld -m elf_i386 -o <out_file> 32bit.o`

To compile 64 bit asm,

1) `nasm -f elf64 64bit.asm`
2) `ld 64bit.o -o <output_file>`
