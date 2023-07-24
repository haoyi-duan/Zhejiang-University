code segment
assume cs:code, ds:code
main:
   jmp begin
old1h dw 0, 0
prev_addr dw offset first, code;前条指令的地址
begin: 
   push cs
   pop ds; DS=CS
   xor ax, ax
   mov es, ax
   mov bx, 4
   push es:[bx]
   pop old1h[0]
   push es:[bx+2]
   pop old1h[2]
   mov word ptr es:[bx], offset int1h
   mov word ptr es:[bx+2], cs
   pushf; save old FL
   pushf
   pop ax
   or ax, 100h; 1 0000 0000
   push ax
   popf; TF=1
first:
   nop; 当某条指令执行前TF==1,则该条指令执行后会
      ; 自动执行int 01h单步中断
single_step_begin:
;first int 1h
   xor ax, ax
   mov cx, 3
next:
   add ax, cx
   nop
   loop next
   popf; restore old FL, TF=0
;last int 1h
   nop;
single_step_end:
   push old1h[0]
   pop es:[bx]
   push old1h[2]
   pop es:[bx+2]
   mov ah, 4Ch
   int 21h
int1h:
   push bp
   mov bp, sp
   push bx
   push es
   les bx, dword ptr cs:[prev_addr]
   inc byte ptr es:[bx]; 加密上一条指令
   les bx, dword ptr [bp+2]
   ;mov bx, [bp+2]
   ;mov es, [bp+4]; es:bx->下条指令的首字节

   dec byte ptr es:[bx]; 解密下一条指令
   mov cs:prev_addr[0], bx
   mov cs:prev_addr[2], es
   pop es
   pop bx
   pop bp
   iret
code ends
end main
