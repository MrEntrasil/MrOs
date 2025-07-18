bits 16
org 0x7C00

global _start

_start:
        cli
        xor ax, ax
        mov ds, ax
        mov es, ax

        mov bx, 0x7E00
        mov ah, 0x02
        mov al, 2
        mov ch, 0
        mov cl, 2
        mov dh, 0
        mov dl, 0

        int 0x13
        jc $

        jmp 0x0000:0x7E00

times 510 - ($ - $$) db 0
dw 0xAA55
