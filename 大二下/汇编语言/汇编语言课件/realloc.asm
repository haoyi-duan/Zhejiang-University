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
   add dx, 100h; ����psp����100h
   add dx, 0Fh
   shr dx, 4   ; dx=(�����ʵ�ʳ���+100h+0Fh) / 10h, ��λ��paragraph����(1��=10h�ֽ�)
               ; ���ж�ӵ�0Fh�ֽ���Ϊ����1~15�ֽڵ���ͷ������һ����
   mov ah, 4Ah
   mov bx, dx  ; bx=��Ҫ�������ڴ�Ľڳ���, es=psp(����տ�ʼ����ʱes�����͵���psp)
   int 21h     ; �ڴ��ط���, ����psp:0~stk:end_flag-1֮����ڴ�, �ͷ�end_flag����Ŀռ�
               ; �Է�ֹint 21h/ah=48h�����ڴ�ʱʧ��
   mov ah, 48h
   mov bx, 100h; ����100h�ڼ�1000h�ֽ�
   int 21h     ; �ڴ����, ��ɹ���CF=0��ax=�ε�ַ, ����CF=1
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


