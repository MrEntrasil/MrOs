TARGET=mros.img

all: $(TARGET)

$(TARGET): ./build ./build/boot.bin ./build/kernel.bin
	dd if=/dev/zero of=$(TARGET) bs=512 count=2880
	dd if=./build/boot.bin of=$(TARGET) conv=notrunc bs=512 count=1
	dd if=./build/kernel.bin of=$(TARGET) conv=notrunc bs=512 seek=1

./build:
	mkdir -p ./build

./build/kernel.bin: ./kernel/kernel.s
	as --32 ./kernel/kernel.s -o ./build/kernel.o
	ld -m elf_i386 -Ttext 0x1000 --oformat binary ./build/kernel.o -o ./build/kernel.bin

./build/boot.bin: ./kernel/boot.s
		as --32 ./kernel/boot.s -o ./build/boot.o
		ld -m elf_i386 -Ttext 0x7C00 --oformat binary ./build/boot.o -o ./build/boot.bin

clean:
	rm -rf ./build/boot.bin ./build/kernel.bin $(TARGET)
