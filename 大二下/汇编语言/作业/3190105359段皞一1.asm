.386
data segment use16
s db 100 dup(0),0Dh,0Ah,'$';������ַ����洢������s��
t db 100 dup(0),0Dh,0Ah,'$';������ַ����洢������t��
data ends
code segment use16
assume cs:code, ds:data
main:
   mov ax, data
   mov ds, ax
   mov si, 0;����s���±��üĴ���SI��ʾ
   mov di, 0;����t���±��üĴ���DI��ʾ
   mov dx, 0
again:;ѭ������int 21h��01h����ʵ��һ���ַ�������
      ;������ַ�һ�δ浽s������
   mov ah, 01h
   int 21h
   cmp al, 0Dh;�ж��Ƿ�����س��������������׶�
   je end_input
   mov s[si], al
   add si, 1
   jmp again
end_input:;�������룬�س�ת����ASCII��00h���浽������
   mov s[si], 00h
   mov si, 0
read:;��ȡs�е��ַ�
   mov dl, s[si]
   add si, 1
   cmp dl, 'a'
   jae maybe_lower
   jmp not_lower
maybe_lower:;dl>='a'�����н�һ����Сд��ĸ�ж�
   cmp dl, 'z'
   jbe is_lower
not_lower:;����Сд��ĸ��Ҫ�ж��Ƿ��ǻس����߿ո�
   cmp dl, 0Dh
   je output
   cmp dl, ' '
   je is_empty
   mov t[di], dl
   add di, 1
   jmp read
is_empty:
   jmp read;�ַ��ǿո񣬲�����t�����У���ת��read��������ȡ�������ַ�
is_lower:
   sub dl, 'a'
   add dl, 'A';��Сд�ַ���ת���ɴ�д�ַ�
   mov t[di], dl;ת����Ĵ�д�ַ��洢��t������
   add di, 1
   jmp read
output:
   mov t[di], 00h;������ȡ������ASCII��00h���浽����ĩβ
   mov di, 0;di��ֵΪ0��֮����ͷ��ʼ�������
   mov dl, 0Ah;����
   mov ah, 02h
   int 21h
   mov dl, 0Dh;�س�
   mov ah, 02h
   int 21h
print:
   mov dl, t[di]
   mov ah, 02h;ѭ������int 21h��02h����ʵ��һ���ַ������
   int 21h
   add di, 1
   cmp dl, 00h;�ж��Ƿ���������ĩβ��������ת��exit
   je exit
   jmp print;ѭ������print
exit:
   mov dl,0Ah;����
   mov ah,2
   int 21h
   mov dl,0Dh;�س�
   mov ah,2
   int 21h
   mov ah, 4Ch;����
   int 21h
code ends
end main