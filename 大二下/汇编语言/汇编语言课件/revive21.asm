code segment
assume cs:code, ds:code
old_01h dw 0, 0
old_21h dw 0, 0
prompt db "This program will use the single-step technique to recover int 21h's vector.", 0Dh, 0Ah
       db "Copyright (C) Black White. Nov 20, 2020.", 0Dh, 0Ah, '$'
recover_msg db "int 21h's vector is recovered!", 0Dh, 0Ah, '$'
int_01h:
    push bp
    mov bp, sp
    cmp word ptr [bp+4], 550h; check whether the traced instruction's segment address <= 550h
    ja skip
store_the_original_int_21h_vector:
    push [bp+2]
    pop cs:old_21h[0]
    push [bp+4]
    pop cs:old_21h[2]
    and word ptr [bp+6], not 0100h; clear TF
skip:
    pop bp
    iret
main:
    push cs
    pop ds; DS=CS=code
    mov ah, 9
    mov dx, offset prompt
    int 21h
    xor ax, ax
    mov es, ax
    push es:[1*4]
    pop cs:old_01h[0]; save int 01h's vector
    push es:[1*4+2]
    pop cs:old_01h[2]
    cli
    mov word ptr es:[1*4], offset int_01h
    mov word ptr es:[1*4+2], cs; change int 01h's vector
    sti
    pushf
    push cs
    mov di, offset here
    push di; use 3 pushes to prepare for emulating int 21h
    mov ah, 30h; pretend to call int 21h/AH=30h
    pushf
    pop dx; DX=FL
    or dx, 100h
    push dx
    popf; TF=1
    jmp dword ptr es:[21h*4]; emulate int 21h/AH=30h
                            ; NOTE: After executing this jmp, there will be 
                            ; an int 01h before the 1st instruction of int 21h
here:
    cli
    push cs:old_21h[0]
    pop es:[21h*4]
    push cs:old_21h[2]
    pop es:[21h*4+2]  ; recover int 21h's vector
    push cs:old_01h[0]
    pop es:[1*4]
    push cs:old_01h[2]
    pop es:[1*4+2]    ; recover int 01h's vector
    sti
    mov ah, 9
    mov dx, offset recover_msg
    int 21h
    mov ah, 4Ch
    int 21h
code ends
end main




    
    