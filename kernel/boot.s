.code16
.section .text
.global _start

_start:
        cli

        xorw %ax, %ax
        movw %ax, %ds
        movw %ax, %es

        movw $0x1000, %bx
        call load_kernel

        ljmp $0x0000, $0x1000

load_kernel:
        movb $0x02, %ah
        movb $1, %al
        movb $0, %ch
        movb $2, %cl
        movb $0, %dh
        movb $0x00, %dl

        int $0x13
        jc load_failed

        ret

load_failed:
        hlt
        jmp load_failed

.org 510
.word 0xAA55
