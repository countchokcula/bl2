org 0x0
bits 16
push es ; -> 0x8000
pop ds ; <- data segment is now 0x8000

_kernel:
    cli
    mov si, kernel_load_success_msg
    L1:
        lodsb
        or al, al
        jz done

        mov ah, 09h
        mov bx, 000fh
        mov cx, 1
        int 10h

        call move_cursor_right
        jmp L1
    done:
    hlt

move_cursor_right:
    mov ah, 03h
    mov bh, 0h
    int 10h

    mov ah, 02h
    mov bh, 0
    add dl, byte 1
    int 10h
    ret
kernel_load_success_msg db "Kernel has been successfully loaded!", 0xa, 0