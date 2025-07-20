void main() {
        asm volatile (
                "movb $'X', %al \n"
                "movb $0x0E, %ah \n"
                "int $0x10"
        );
        while (1);
}
