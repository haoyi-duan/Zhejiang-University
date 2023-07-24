;---------------------------------------
;PrtSc/SysRq: E0 2A E0 37 E0 B7 E0 AA  ;
;Pause/Break: E1 1D 45 E1 9D C5        ;
;---------------------------------------
data segment
old_9h dw 0, 0
stop   db 0
key    db 0; key=31h
phead  dw 0
key_extend  db 'KeyExtend=', 0
key_up      db 'KeyUp=', 0
key_down    db 'KeyDown=', 0
key_code    db '00h ', 0
hex_tbl     db '0123456789ABCDEF'
cr          db  0Dh, 0Ah, 0
data ends

code segment
assume cs:code, ds:data
main:
   mov ax, data
   mov ds, ax
   xor ax, ax
   mov es, ax
   mov bx, 9*4
   push es:[bx]
   pop old_9h[0]
   push es:[bx+2]
   pop old_9h[2]    ; ����int 9h���ж�����
   cli
   mov word ptr es:[bx], offset int_9h
   mov es:[bx+2], cs; �޸�int 9h���ж�����
   sti
again:
   cmp [stop], 1
   jne again        ; �������ڴ�ѭ���ȴ�
   push old_9h[0]
   pop es:[bx]
   push old_9h[2]
   pop es:[bx+2]    ; �ָ�int 9h���ж�����
   mov ah, 4Ch
   int 21h

int_9h:
   push ax
   push bx
   push cx
   push ds
   mov ax, data
   mov ds, ax       ; ��������DS����Ϊ���жϵĲ�һ���������Լ��ĳ���
   in al, 60h       ; AL=key code
   mov [key], al
   cmp al, 0E0h
   je  extend
   cmp al, 0E1h
   jne up_or_down
extend:
   mov [phead], offset key_extend
   call output
   jmp check_esc
up_or_down:
   test al, 80h     ; ���λ==1ʱ��ʾkey up
   jz down
up:
   mov [phead], offset key_up
   call output
   mov bx, offset cr
   call display     ; ����س�����
   jmp check_esc
down:
   mov [phead], offset key_down
   call output
check_esc:   
   cmp [key], 81h   ; Esc����key up��
   jne int_9h_iret
   mov [stop], 1
int_9h_iret:
   mov al, 20h      ; ��EOI(End Of Interrupt)�źŸ��жϿ�������
   out 20h, al      ; ��ʾ�����Ѵ���ǰ��Ӳ���ж�(Ӳ���жϴ������Ҫ��2��ָ��)��
                    ; ��Ϊ����û����ת����old_9h�����Ա����Լ���EOI�źš�
                    ; �������old_9h�Ļ�����old_9h��������2��ָ�����Ͳ�Ҫд��
   pop ds
   pop cx
   pop bx
   pop ax
   iret             ; �жϷ���ָ��Ӷ�ջ���������IP��CS��FL��

output:
   push ax
   push bx
   push cx
   mov bx, offset hex_tbl
   mov cl, 4
   push ax   ; ��AL=31h=0011 0001
   shr al, cl; AL=03h
   xlat      ; AL = DS:[BX+AL] = '3'
   mov key_code[0], al
   pop ax
   and al, 0Fh; AL=01h
   xlat       ; AL='1'
   mov key_code[1], al
   mov bx, [phead]
   call display     ; �����ʾ��Ϣ
   mov bx, offset key_code
   call display     ; �������
   pop cx
   pop bx
   pop ax
   ret
   
display:
   push ax
   push bx
   push si
   mov si, bx
   mov bx, 0007h    ; BL = color
   cld
display_next:
   mov ah, 0Eh      ; AH=0Eh, BIOS int 10h���ӹ��ܣ���������жϴ�ȫ
   lodsb
   or al, al
   jz display_done
   int 10h          ; ÿ�����һ���ַ�
   jmp display_next
display_done:
   pop si
   pop bx
   pop ax
   ret
code ends
end main