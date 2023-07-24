code segment
assume cs:code, ds:code
int_21h:
    cmp ah, 9
    je is_write_string_function
    jmp dword ptr cs:[old_21h]
is_write_string_function:
    push ax
    push bx
    push dx
    mov bx, dx; ds:bx->string to output
output_next_char:
    mov dl, [bx]
    cmp dl, '$'
    je end_of_string
    cmp dl, 'a'
    jb not_lowercase
    cmp dl, 'z'
    ja not_lowercase
    sub dl, 20h; convert lowercase to uppercase
not_lowercase:
    mov ah, 2
    pushf
    call dword ptr cs:[old_21h]; Use pushf & call to emulate int 21h
                               ; so that we can output one char inside int_21h.
    inc bx
    jmp output_next_char
end_of_string:
    pop dx
    pop bx
    pop ax
    iret
old_21h dw 0, 0
main:
    push cs
    pop ds ; DS=CS
    xor ax, ax
    mov es, ax
    mov bx, 21h*4; ES:BX-> int_21h's vector
    push es:[bx]
    pop old_21h[0]
    push es:[bx+2]
    pop old_21h[2]; save old vector of int_21h

    cli    ; disable interrupt when changing int_21h's vector
    mov word ptr es:[bx], offset int_21h
    mov es:[bx+2], cs
    sti    ; enable interrupt
    ;-------------------------
install:
    mov ah,9
    mov dx,offset install_msg
    int 21h
    mov dx,offset main; DX=len for keeping resident
    add dx,100h; include PSP's len
    add dx,0Fh; include remnant bytes
    mov cl,4
    shr dx,cl ; DX=program's paragraph size to keep resident
    mov ah,31h; 1 paragraph = 10h×Ö½Ú
    int 21h   ; keep resident
install_msg db "The program hooks int 21h's vector and affects the behavior of int 21h/AH=09h.",0Dh,0Ah
            db "Copyright Black White. Nov 20,2020",0Dh,0Ah,'$'
code ends
end main

