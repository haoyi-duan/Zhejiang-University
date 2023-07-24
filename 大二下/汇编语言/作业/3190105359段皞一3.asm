.386
data segment use16 ; �����ʼ��Ϊ'?'��䣬����֮����е��ԣ�Ҳ�ý���ĩβ���ж�
   buf      db 100
            db  ?
            db 100 dup('?') ; �洢��������������ַ���
   out_item dd 100 dup('????'),0Dh,0Ah,'$' ; ��¼���ɵ��沨�����ʽ
   op_item  db 100 dup('?'),0Dh,0Ah,'$' ; ��������У������沨�����ʽ�Ĺ������ݴ��
   p        db '(', '(', '+', '-', '*', '/' ; �Ƚ���������ȼ����õ����ַ�������
                                            ; ����������ŵ����ȼ�������, �����������������
                                            ; �����ź�������+ - * /������Ͳ����ܳ������ǵ���
                                            ; �ȼ����������ŵ����δӶ����������ű�Ų�����������.
   s        db 10 dup(0),0Dh,0Ah,'$' ; �����ת����ʮ���ƣ��洢������ַ���
data ends

stack segment stack use16
   dw 100h dup(?) 
stack ends

code segment use16
assume cs:code, ds:data, ss:stack

fetch_a_num: ; �ڵ�ǰ�ַ���'0'-'9'֮���ʱ�򼤻�����ӵ�ǰλ��ʼ����ȡ���֣�
             ; ֱ���ַ���������Ϊֹ������ȡ�����ַ���ת�������ָ�ʽ��֮�����out_item
   push eax
   push edx
   mov eax, 0 ; ������
fetch_again: 
   cmp byte ptr [bx], '0' ; �ж��Ƿ񵽴�����Ľ�����־
   jb fetch_end
   cmp byte ptr [bx], '9'
   ja fetch_end
   mov edx, 10 ; ����
   mul edx ; EDX:EAX=�˻�, ����EDX=0
           ; ��д��imul eax, edx
   mov edx, 0
   mov dl, [bx] ; DL='1'
   sub dl, '0' ; ��DLת�������ָ�ʽ
   add eax, edx
   inc bx
   jmp fetch_again
fetch_end:
   push si
   add si, si
   add si, si ; ����out_item��dd���ͣ���ֵ��ʱ��Ҫ���±��4
   mov out_item[si], eax
   pop si
   inc si
   pop eax
   pop edx
   ret

is_lower_privilege: ; �жϵ�ǰ�����c�����ȼ��Ƿ����ǰһ�������b�����ȼ�
   push di
   push bx
   push cx
   mov di, 0
   mov cx, 0
   mov bx, 0
is_lower_begin:
   cmp dh, p[di]
   je is_lower_step1
   cmp dh, p[di+1]
   je is_lower_step1
   jmp is_lower_step2
is_lower_step1:
   mov cx, di
is_lower_step2:
   cmp dl, p[di]
   je is_lower_step3
   cmp dl, p[di+1]
   je is_lower_step3
   jmp is_lower_step4
is_lower_step3:
   mov bx, di
is_lower_step4:
   add di, 2
   cmp di, 6
   jb is_lower_begin
   cmp cx, bx ; �������غ��ja��ת������cx<=bx�Ľ������֮���·��
; ���ȼ���ͬʱ��+��-, ��Ϊ���ϵ�ԭ��, 
; �ȳ��ֵ������b�����ȼ����ڵ�ǰ�����c, 
; ��ic==ibʱҲ������
   pop di
   pop bx
   pop cx
   ret

get_op_order: ; ��+ - * /�����ת����0 1 2 3
   push eax
   mov eax, 80000000h
   cmp op_item[di], '+'
   je is_add
   cmp op_item[di], '-'
   je is_sub
   cmp op_item[di], '*'
   je is_mul
   cmp op_item[di], '/'
   je is_div
is_add:
   mov eax, 80000000h
   jmp op_end
is_sub:
   mov eax, 80000001h
   jmp op_end
is_mul:
   mov eax, 80000002h
   jmp op_end
is_div:
   mov eax, 80000003h
   jmp op_end
op_end:
   push si
   add si, si
   add si, si
   mov out_item[si], eax
   pop si
   pop eax
   ret

compute: ; �����沨�����ʽ������ó�����������eax�Ĵ�����
   mov di, 0
compute_begin:
   cmp si, 1
   jbe compute_end ; ���si(nout)<=1����ôout_item[0]�������յĽ����
compute_step0:
   push di
   add di, di
   add di, di
   mov edx, out_item[di]
   pop di
   and edx, 80000000h ; ��������������������, ���λΪ0������
   cmp edx, 0
   jne compute_step1
   inc di
   jmp compute_step0 
compute_step1:
   push di
   add di, di
   add di, di
   mov ecx, out_item[di]
   and ecx, 7fffffffh ; ������λ, cl=0����+, 1����-, 2����*, 3����
   mov eax, out_item[di-8] ; num1
   mov ebx, out_item[di-4] ; num2
   pop di
   cmp cl, 0
   je compute_add
   cmp cl, 1
   je compute_sub
   cmp cl, 2
   je compute_mul
   cmp cl, 3
   je compute_div
compute_add:
   add eax, ebx ; num1+num2
   jmp compute_out
compute_sub:
   sub eax, ebx ; num1-num2
   jmp compute_out
compute_mul:
   mul ebx ; num1*num2
   jmp compute_out
compute_div:
   push edx
   mov edx, 0
   div ebx ; num1/num2
   pop edx
compute_out:
   push di
   add di, di
   add di, di
   mov out_item[di-8], eax ; ��ǰ��������ŵ�out_item[i-2]��λ��
   pop di
   push di
compute_copy: ; ������������еĵ�i+1����nout-1��Ԫ�ص���i-1��Ԫ�ش�
              ; �Ӷ�ɾ��ԭ��i-1����i��Ԫ��                   
   inc di
   push di
   add di, di
   add di, di
   cmp out_item[di], 00h
   pop di
   je compute_copy_end
   push di
   add di, di
   add di, di
   mov eax, out_item[di]
   mov out_item[di-8], eax
   pop di
   jmp compute_copy
compute_copy_end:
   pop di
   sub si, 2 ; ������������е�Ԫ�ظ��� 
   dec di ; i������ԭ��i-1��λ��
   jmp compute_begin
compute_end:
   mov eax, out_item[0] ; ����������н�ʣһ��Ԫ��ʱ, ��Ԫ�ؾ���������
   ret

main:
   mov ax, data
   mov ds, ax
   mov ah, 0Ah
   mov dx, offset buf ; ͨ��int 21h/AH=0Ah�ж�ʵ��gets(buf)��Ч��
   int 21h
   mov ah, 02h
   mov dl, 0Dh
   int 21h
   mov ah, 02h
   mov dl, 0Ah
   int 21h 
   mov bx, offset buf+2 ; bx�洢buf+2�ĵ�ַ���������ַ������ݵ��׵�ַ
   mov dx, 0
   mov dl, buf[1] ; ��ȡ�ַ����ĳ���
   mov di, dx
   mov byte ptr [bx+di], '?' ; ���ַ�����ĩβ��Ϊ'?'������������е��Ժ�ĩβ�ж�
   mov di, 2
   imul ax, di, 2
reverse_polish_notation:
   mov di, 0 ;nop
   mov si, 0 ;nout
polish_begin:
   mov al, byte ptr [bx]
   cmp al, '?' ; �ж��ַ����Ƿ�ĩβ
   je pop_op
   cmp al, ' ' ; �����ո�
   jne polish_step0
   inc bx
   jmp polish_begin
polish_step0:
   cmp al, '0' ; �������'0'���п�����һ�������ַ���Ҫ���н�һ�����ж�
   jae maybe_digit
polish_step1:
   cmp al, '(' 
   ; ���������Ų����ܶ�������������, ����������֮��ı��ʽ���� 
   ; �����һ������, ���()Ӧ������һ����, �����Ų�Ӧ������ǰ
   ; ��������+ - * /��ǰ��������űȽ����ȼ�, ����ᵼ����ǰ��
   ; ���������������Ų�����������. 
   jne polish_step2
   mov op_item[di], al ; ���������ŵ������������
   inc di
   inc bx
   jmp polish_begin
maybe_digit:
   cmp al, '9' ; �϶��ǲ��������ַ�
   ja polish_step1
   call fetch_a_num ; ����������ַ����͵��ú�����ȡ�����ִ���out_item��
   jmp polish_begin
polish_step2:
   cmp al, ')'
   ; ��׺���ʽ������������ʱ�����������������Ѱ��ƥ���������
   ; ����()֮�������������ҵ���˳��ȡ�������浽��������� 
   jne polish_step3
polish_step2_1:
   dec di
   cmp op_item[di], '('
   je polish_step2_2
   call get_op_order
   inc si
   jmp polish_step2_1
polish_step2_2:
   inc bx
   jmp polish_begin
polish_step3:
   cmp di, 0
   push di
   jle polish_step4
   mov dh, byte ptr [bx]
   mov dl, op_item[di-1]
   call is_lower_privilege
   ; ����ǰ����������ȼ���������������е�ǰһ�������, ���
   ; ǰһ�����Ų�����������, ��ȡǰһ������Ƚ����ȼ�ֱ����
   ; �������Ϊ�ջ�ǰһ����������ȼ����ڵ�ǰ�����. 
   pop di
   ja polish_step4
   dec di
   call get_op_order
   inc si  
   jmp polish_step3
polish_step4:
   mov op_item[di], al ; ��ǰ��������浽�����������
   inc di
   inc bx
   jmp polish_begin
pop_op: ; ���������������ʣ�����������򰴴��ҵ����˳��ȡ��
        ; �����浽������
   cmp di, 0
   jle polish_exit
   dec di
   call get_op_order
   inc si
   jmp pop_op
polish_exit:
   call compute
   push eax
oct_output: ; ��ʮ���Ƹ�ʽ���
   mov si, 0
   mov edx, 0
   mov ebx, 10
oct_begin: ; ����10��������Ϊ��ǰλ����ѹ���ַ�����ջ
           ; ����Ϊ��һ��������������10��ֱ����Ϊ0
   div ebx
   cmp eax, 0
   je oct_print
   mov s[si], dl
   inc si
   mov edx, 0
   jmp oct_begin
oct_print:
   mov s[si], dl
oct_begin_print:
   mov ah, 02h
   mov dl, '0'
   add dl, s[si]
   int 21h
   dec si
   cmp si, 0ffffh ; 0-1=ffff���
   jne oct_begin_print
   mov dl,0Ah;����
   mov ah,2
   int 21h
   mov dl,0Dh;�س�
   mov ah,2
   int 21h
   pop eax
   mov ebx, eax
   push ebx
   push eax
   mov di, 0
   mov si, 0
hex_output: ; ��16���Ƹ�ʽ���
   mov dl, '0'
   pop ebx
   rol ebx, 4 ; ѭ������4λ���Ӹ�λ��ʼ��ȡ���������պ��ȴӸ�λ
   push ebx
   and ebx, 0000000fh ; ȡ����λ
   cmp bl, 10 ; �������10��ת������ĸ
   jb print_hex
   mov dl, 'A'
   sub bl, 10
print_hex:
   add dl, bl
   mov ah, 02h
   int 21h
   inc di
   cmp di, 8 ; �ж��Ƿ�������
   jb hex_output
   mov dl, 'h' ; ���������ĩβ����һ��'h'
   mov ah, 02h
   int 21h
   mov dl,0Ah;����
   mov ah,2
   int 21h
   mov dl,0Dh;�س�
   mov ah,2
   int 21h
   mov di, 0
   mov si, 0
   pop eax
   mov ebx, eax
   push ebx
binary_output: ; ��2���Ƶĸ�ʽ���
   mov dl, '0'
   pop ebx
   rol ebx, 1 ; ѭ������1λ
   push ebx
   and ebx, 00000001h
   add dl, bl
   mov ah, 02h
   int 21h
   inc di
   inc si
   cmp di, 4 ; ÿ��λ����һ�οո�
             ; ���������λ����û�пո񣬶��ǽ���һ��'h'
   jne no_space
   cmp si, 32
   je no_space
   mov dl, ' ' ; ����ո�
   mov ah, 02h
   int 21h
   mov di, 0
no_space:   
   cmp si, 32
   jb binary_output
   mov dl, 'B'
   mov ah, 02h
   int 21h
done:
   mov ah, 4Ch ; ����
   int 21h
code ends
end main