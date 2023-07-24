.386
_disk struc
para_size dw 0
sector_count dw 0
buf_addr dw 0, 0
sector_number dd 0, 0
_disk ends

data segment use16
buf db 200h dup(0)
para _disk <0010h, 0001h>
data ends

code segment use16
assume cs:code, ds:data
main:
   mov ax, data
   mov ds, ax
   mov para.buf_addr[0], offset buf
   mov para.buf_addr[2], data
   mov para.sector_num[0], 0
   mov para.sector_num[4], 0
   mov ah, 42h
   mov dl, 80h
   mov si, offset para
   int 13h
   mov ah, 4Ch
   int 21h
code ends
end main

   