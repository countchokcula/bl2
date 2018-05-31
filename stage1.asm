bits 16
org 0x7c00
jmp _intialize
nop
%include "print_tools.asm"
_intialize:
    mov [BOOT_DRIVE], dl
    
    xor ax, ax ; zeros out
    mov ds, ax ; 0x7c00:0x0
    mov es, ax ; 0x7c00:0x0

    mov ax, 0x7E00
    mov ss, ax ; moves stack segment passed bootloader, prevents overwriting

    xor ax, ax

    mov ax, 0000h
    int 10h

    mov ah, 01h ; text cursor shape
    mov cx, 0607h
    int 10h

    mov ah, 02h ; set cursor
    mov bh, 0000h
    mov dx, 0000h
    int 10h
reset_drive:
    mov cx, 5
    reset_driveL1:
        sub cx, byte 1
        push cx

        mov ah, 00h
        mov dl, [BOOT_DRIVE]
        int 13h

        pop cx
        or cx, cx
        jz reset_drive_error ; after 5 attempts
        jc reset_driveL1
        ;--success
        mov si, reset_drive_msg
        call print
        jmp load_kernel
    reset_drive_error:
        mov si, reset_drive_error_msg
        call print
        hlt
load_kernel:
    mov cx, 5
    load_kernelL1:
        sub cx, byte 1
        push cx

        mov bx, 0x8000
        mov es, bx
        xor bx, bx ; [es:bx] 0x1000:0x0 

        mov ax, 0201h
        mov cx, 0002h
        mov dh, 00h
        mov dl, [BOOT_DRIVE]
        int 13h

        pop cx
        or cx, cx
        jz load_kernel_error
        jc load_kernelL1
        ;--success
        mov si, load_kernel_msg
        call print
        jmp 0x8000:0x0
    load_kernel_error:
        mov si, load_kernel_error_msg
        call print
        hlt

load_kernel_msg db "Sector successfully loaded", 0xa, 0
load_kernel_error_msg db "Sector could not be loaded from 0x8000:0x0", 0xa, 0
reset_drive_msg db "Drive has been reset", 0xa, 0
reset_drive_error_msg db "Drive could not be reset", 0xa, 0
BOOT_DRIVE db 0

times 510-($-$$) db 0
dw 0xAA55