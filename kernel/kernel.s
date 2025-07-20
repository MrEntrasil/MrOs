.code16
.global _start

_start:
        movb $'X', %al
        movb $0x0E, %ah
        int $0x10

hang:
        hlt
        jmp hang
