all:
	nasm -f bin ./kernel/bootloader.s -o ./build/bootloader.bin
	gcc -m32 -ffreestanding -c ./kernel/kernel.c -o ./build/kernel.o
	ld -m elf_i386 -T ./kernel/linker.ld ./build/kernel.o -o ./build/kernel.bin
	dd if=/dev/zero of=mros.img bs=512 count=2880
	dd if=./build/bootloader.bin of=mros.img bs=512 conv=notrunc
	dd if=./build/kernel.bin of=mros.img bs=512 seek=1 conv=notrunc
