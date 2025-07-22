.code16
.section .text
.global _start

_start:
        cli

        xorw %ax, %ax
        movw %ax, %ds
        movw %ax, %es
        movw %ax, %ss
        movw $0x9000, %sp

        movw $0x1000, %bx
        call load_kernel

        call gdt_load
        
        movl %cr0, %eax
        orl $1, %eax
        movl %eax, %cr0

        ljmp $0x08, $entry_pm

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

.align 4
gdt_start:
        .word 0
        .word 0
        .byte 0
        .byte 0
        .byte 0
        .byte 0

        .word 0xFFFF
        .word 0x0000
        .byte 0x00
        .byte 0x9A
        .byte 0xCF
        .byte 0x00

        .word 0xFFFF
        .word 0x0000
        .byte 0x00
        .byte 0x92
        .byte 0xCF
        .byte 0x00

gdt_descripter:
        .word gdt_end - gdt_start - 1
        .long gdt_start

gdt_end:
        
gdt_load:
        lgdt gdt_descripter
        ret

.code32
entry_pm:
        mov $0x10, %ax
        mov %ax, %ds
        mov %ax, %es
        mov %ax, %fs
        mov %ax, %gs
        mov %ax, %ss
        mov $0x90000, %esp

        call 0x1000
        hlt
        jmp .

.org 510
.word 0xAA55
