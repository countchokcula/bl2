move_cursor:
    push bp
    mov bp, sp

    call get_cursor_pos
    mov ah, 02h ;sub routine
    mov bh, 0h ; page
    add dl, [bp+4] ; col
    int 10h
    
    mov sp, bp
    pop bp
    ret 4
create_new_line:
    call get_cursor_pos
    mov ah, 02h
    mov bh, 0h ; page
    add dh, 1 ; increments row
    xor dl, dl ; resets col
    int 10h
    ret
move_cursor_right:
    mov ah, 03h ; get cursor pos
    int 10h

    mov ah, 02h
    mov bh, 0h
    add dl, 1 ; adds to column
    int 10h

    xor dx, dx
    ret
get_cursor_pos:
    mov ah, 03h
    mov bh, 0
    int 10h
    ret 
write_at_cursor:
    ; al = char bh page, bl color, cx amount
    cmp al, byte 0xa
    je new_line_char ; if(al == 0xa) new_line else putchar
    cmp al, byte 0 ; if(al == 0) write_at_cursorEND else putchar
    jz write_at_cursorEND
    jmp putchar

    new_line_char:   
        call create_new_line
        jmp write_at_cursorEND

    putchar:
        mov ah, 09h
        int 10h
        call move_cursor_right
    write_at_cursorEND:
        ret 
print: ; params si:string
    printL1:
        lodsb
        mov bx, 000fh
        mov cx, 1
        call write_at_cursor

        or [si], byte 0
        jnz printL1
    ret