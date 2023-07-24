data segment
buf db 200h dup(0)
data ends

code segment
assume cs:code, ds:data
main:
   mov ax, data
   mov es, ax
   mov ah, 2
   mov al, 1
   mov dl, 80h
   mov dh, 0
   mov cl, 1
   mov ch, 0
   mov bx, offset buf
   int 13h
   mov ah, 4Ch
   int 21h
code ends
end main

   