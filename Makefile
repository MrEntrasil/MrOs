TARGET = mros.img
CC     = gcc
ASM    = as
CFLAGS = -m32 -ffreestanding -nostdlib -fno-pic -fno-pie

all: $(TARGET)

$(TARGET): ./build ./build/boot.bin ./build/kernel.bin
	dd if=/dev/zero of=$(TARGET) bs=512 count=2880
	dd if=./build/boot.bin of=$(TARGET) conv=notrunc bs=512 count=1
	dd if=./build/kernel.bin of=$(TARGET) conv=notrunc bs=512 seek=1

./build:
	mkdir -p ./build

./build/kernel.bin: ./build/kernel.o ./build/task.o
	ld -m elf_i386 -T ./kernel/linker.ld -nostdlib --oformat binary ./build/kernel.o ./build/task.o -o ./build/kernel.bin

./build/kernel.o: ./kernel/kernel.c
		$(CC) $(CFLAGS) -c ./kernel/kernel.c -o ./build/kernel.o

./build/task.o: ./kernel/task.c
		$(CC) $(CFLAGS) -c ./kernel/task.c -o ./build/task.o

./build/boot.bin: ./kernel/boot.s
		as --32 ./kernel/boot.s -o ./build/boot.o
		ld -m elf_i386 -Ttext 0x7C00 --oformat binary ./build/boot.o -o ./build/boot.bin

clean:
	rm -rf ./build/* $(TARGET)
