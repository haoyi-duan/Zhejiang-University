.386
dgroup group data, code, stk

data segment use16
err_msg db "Not enough memory!", 0Dh, 0Ah, '$'
suc_msg db "Success in allocating memory!", 0Dh, 0Ah, '$'
data ends

code segment use16
assume cs:code, ds:data, ss:stk
main:
   mov ax, data
   mov ds, ax
   mov dx, offset dgroup:end_flag
   add dx, 100h; 加上psp长度100h
   add dx, 0Fh
   shr dx, 4   ; dx=(程序的实际长度+100h+0Fh) / 10h, 单位是paragraph即节(1节=10h字节)
               ; 其中多加的0Fh字节是为了让1~15字节的零头都计作一个节
   mov ah, 4Ah
   mov bx, dx  ; bx=需要保留的内存的节长度, es=psp(程序刚开始运行时es本来就等于psp)
   int 21h     ; 内存重分配, 保留psp:0~stk:end_flag-1之间的内存, 释放end_flag后面的空间
               ; 以防止int 21h/ah=48h分配内存时失败
   mov ah, 48h
   mov bx, 100h; 分配100h节即1000h字节
   int 21h     ; 内存分配, 或成功则CF=0且ax=段地址, 否则CF=1
   jnc success
fail:
   mov ah, 9
   mov dx, offset err_msg
   int 21h
   jmp exit
success:
   mov ah, 9
   mov dx, offset suc_msg
   int 21h
exit:
   mov ah, 4Ch
   int 21h
code ends

stk segment stack use16
   db 100h dup('S')
end_flag label byte
stk ends
end main


