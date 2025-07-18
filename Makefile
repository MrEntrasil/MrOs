all:
	nasm -f bin ./kernel/bootloader.s -o ./build/bootloader.bin
	gcc -ffreestanding -m32 -nostdlib -fno-pic -fno-pie -no-pie -c ./kernel/kernel.c -o ./build/kernel.o
	ld -nostdlib -m elf_i386 -T ./kernel/linker.ld ./build/kernel.o -o ./build/kernel.elf
	objcopy -O binary ./build/kernel.elf ./build/kernel.bin
	dd if=/dev/zero of=floppy.img bs=512 count=2880
	dd if=./build/bootloader.bin of=./floppy.img bs=512 count=1 conv=notrunc
	dd if=./build/kernel.bin of=floppy.img bs=512 seek=1 conv=notrunc
