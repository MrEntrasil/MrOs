[BITS 16]
[ORG 0x7C00]

start:
        cli
        xor ax, ax
        mov ds, ax
        mov es, ax
        mov ss, ax
        mov sp, 0x7C00

        mov bx, 0x1000
        mov ah, 0x02
        mov al, 5
        mov ch, 0
        mov cl, 2
        mov dh, 0
        mov dl, 0
        int 0x13

        jc disk_error

        mov si, msg
print:
        lodsb
        or al, al
        jz done
        mov ah, 0x0E
        int 0x10
        jmp print

done:
        cli
        lgdt [gdt_descriptor]

        mov eax, cr0
        or eax, 1
        mov cr0, eax

        jmp 0x08:protected_mode_entry

disk_error:
        mov si, err
        jmp print

; ------ PROTECTED MODE -------
[BITS 32]
protected_mode_entry:
        mov ax, 0x10
        mov ds, ax
        mov ss, ax
        mov es, ax
        mov fs, ax
        mov gs, ax
        mov esp, 0x9000

        call 0x1000

hang:
        hlt
        jmp hang

msg db "Bootloader succefull loaded!", 0
err db "Disk Error!", 0

gdt_start:
        dq 0x0000000000000000
        dq 0x00CF9A000000FFFF
        dq 0x00CF92000000FFFF

gdt_descriptor:
        dw gdt_end - gdt_start - 1
        dd gdt_start
gdt_end:
        

times 510 - ($ - $$) db 0
dw 0xAA55
