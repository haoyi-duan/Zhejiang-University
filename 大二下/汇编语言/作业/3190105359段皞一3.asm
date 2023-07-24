.386
data segment use16 ; 数组初始化为'?'填充，方便之后进行调试，也好进行末尾的判断
   buf      db 100
            db  ?
            db 100 dup('?') ; 存储输入的四则运算字符串
   out_item dd 100 dup('????'),0Dh,0Ah,'$' ; 记录生成的逆波兰表达式
   op_item  db 100 dup('?'),0Dh,0Ah,'$' ; 运算符队列，计算逆波兰表达式的过程中暂存的
   p        db '(', '(', '+', '-', '*', '/' ; 比较运算符优先级所用到的字符串数组
                                            ; 特意把左括号的优先级设成最低, 这样在运算符队列中
                                            ; 左括号后面跟随的+ - * /运算符就不可能出现它们的优
                                            ; 先级低于左括号的情形从而导致左括号被挪到输出队列中.
   s        db 10 dup(0),0Dh,0Ah,'$' ; 将结果转化成十进制，存储输出的字符串
data ends

stack segment stack use16
   dw 100h dup(?) 
stack ends

code segment use16
assume cs:code, ds:data, ss:stack

fetch_a_num: ; 在当前字符是'0'-'9'之间的时候激活函数，从当前位开始往后取数字，
             ; 直到字符不是数字为止，并将取到的字符串转化成数字格式，之后存入out_item
   push eax
   push edx
   mov eax, 0 ; 被乘数
fetch_again: 
   cmp byte ptr [bx], '0' ; 判断是否到达数组的结束标志
   jb fetch_end
   cmp byte ptr [bx], '9'
   ja fetch_end
   mov edx, 10 ; 乘数
   mul edx ; EDX:EAX=乘积, 其中EDX=0
           ; 或写成imul eax, edx
   mov edx, 0
   mov dl, [bx] ; DL='1'
   sub dl, '0' ; 将DL转化成数字格式
   add eax, edx
   inc bx
   jmp fetch_again
fetch_end:
   push si
   add si, si
   add si, si ; 由于out_item是dd类型，赋值的时候要将下标乘4
   mov out_item[si], eax
   pop si
   inc si
   pop eax
   pop edx
   ret

is_lower_privilege: ; 判断当前运算符c的优先级是否低于前一个运算符b的优先级
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
   cmp cx, bx ; 函数返回后接ja跳转，根据cx<=bx的结果决定之后的路线
; 优先级相同时如+和-, 因为左结合的原因, 
; 先出现的运算符b的优先级高于当前运算符c, 
; 故ic==ib时也返回真
   pop di
   pop bx
   pop cx
   ret

get_op_order: ; 把+ - * /运算符转化成0 1 2 3
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

compute: ; 根据逆波兰表达式，计算得出结果，存放在eax寄存器中
   mov di, 0
compute_begin:
   cmp si, 1
   jbe compute_end ; 如果si(nout)<=1，那么out_item[0]就是最终的结果了
compute_step0:
   push di
   add di, di
   add di, di
   mov edx, out_item[di]
   pop di
   and edx, 80000000h ; 在输出队列中搜索运算符, 最高位为0是整数
   cmp edx, 0
   jne compute_step1
   inc di
   jmp compute_step0 
compute_step1:
   push di
   add di, di
   add di, di
   mov ecx, out_item[di]
   and ecx, 7fffffffh ; 清除最高位, cl=0代表+, 1代表-, 2代表*, 3代表
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
   mov out_item[di-8], eax ; 当前计算结果存放到out_item[i-2]的位置
   pop di
   push di
compute_copy: ; 复制输出队列中的第i+1至第nout-1个元素到第i-1个元素处
              ; 从而删除原第i-1及第i个元素                   
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
   sub si, 2 ; 更新输出队列中的元素个数 
   dec di ; i调整到原来i-1的位置
   jmp compute_begin
compute_end:
   mov eax, out_item[0] ; 当输出队列中仅剩一个元素时, 该元素就是运算结果
   ret

main:
   mov ax, data
   mov ds, ax
   mov ah, 0Ah
   mov dx, offset buf ; 通过int 21h/AH=0Ah中断实现gets(buf)的效果
   int 21h
   mov ah, 02h
   mov dl, 0Dh
   int 21h
   mov ah, 02h
   mov dl, 0Ah
   int 21h 
   mov bx, offset buf+2 ; bx存储buf+2的地址，即输入字符串内容的首地址
   mov dx, 0
   mov dl, buf[1] ; 获取字符串的长度
   mov di, dx
   mov byte ptr [bx+di], '?' ; 将字符串的末尾设为'?'，方便后续进行调试和末尾判读
   mov di, 2
   imul ax, di, 2
reverse_polish_notation:
   mov di, 0 ;nop
   mov si, 0 ;nout
polish_begin:
   mov al, byte ptr [bx]
   cmp al, '?' ; 判断字符串是否到末尾
   je pop_op
   cmp al, ' ' ; 跳过空格
   jne polish_step0
   inc bx
   jmp polish_begin
polish_step0:
   cmp al, '0' ; 如果大于'0'，有可能是一个数字字符，要进行进一步的判断
   jae maybe_digit
polish_step1:
   cmp al, '(' 
   ; 由于左括号并不能对两个数做运算, 它与右括号之间的表达式最终 
   ; 将算出一个整数, 因此()应该理解成一个数, 左括号不应该与它前
   ; 面的运算符+ - * /或前面的左括号比较优先级, 否则会导致它前面
   ; 的运算符或左括号挪到输出队列中. 
   jne polish_step2
   mov op_item[di], al ; 保存左括号到运算符队列中
   inc di
   inc bx
   jmp polish_begin
maybe_digit:
   cmp al, '9' ; 断定是不是数字字符
   ja polish_step1
   call fetch_a_num ; 如果是数字字符，就调用函数，取出数字存入out_item中
   jmp polish_begin
polish_step2:
   cmp al, ')'
   ; 中缀表达式中遇到右括号时必须在运算符队列中寻找匹配的左括号
   ; 并把()之间的运算符按从右到左顺序取出并保存到输出队列中 
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
   ; 若当前运算符的优先级低于运算符队列中的前一个运算符, 则把
   ; 前一运算符挪到输出队列中, 再取前一运算符比较优先级直到运
   ; 算符队列为空或前一运算符的优先级低于当前运算符. 
   pop di
   ja polish_step4
   dec di
   call get_op_order
   inc si  
   jmp polish_step3
polish_step4:
   mov op_item[di], al ; 当前运算符保存到运算符队列中
   inc di
   inc bx
   jmp polish_begin
pop_op: ; 若运算符队列中有剩余的运算符，则按从右到左的顺序取出
        ; 并保存到队列中
   cmp di, 0
   jle polish_exit
   dec di
   call get_op_order
   inc si
   jmp pop_op
polish_exit:
   call compute
   push eax
oct_output: ; 以十进制格式输出
   mov si, 0
   mov edx, 0
   mov ebx, 10
oct_begin: ; 除以10，余数作为当前位的数压入字符串堆栈
           ; 商作为下一个除数继续除以10，直到商为0
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
   cmp si, 0ffffh ; 0-1=ffff溢出
   jne oct_begin_print
   mov dl,0Ah;换行
   mov ah,2
   int 21h
   mov dl,0Dh;回车
   mov ah,2
   int 21h
   pop eax
   mov ebx, eax
   push ebx
   push eax
   mov di, 0
   mov si, 0
hex_output: ; 以16进制格式输出
   mov dl, '0'
   pop ebx
   rol ebx, 4 ; 循环左移4位，从高位开始读取，最后输出刚好先从高位
   push ebx
   and ebx, 0000000fh ; 取低四位
   cmp bl, 10 ; 如果大于10，转化成字母
   jb print_hex
   mov dl, 'A'
   sub bl, 10
print_hex:
   add dl, bl
   mov ah, 02h
   int 21h
   inc di
   cmp di, 8 ; 判断是否输出完毕
   jb hex_output
   mov dl, 'h' ; 输出结束后，末尾加上一个'h'
   mov ah, 02h
   int 21h
   mov dl,0Ah;换行
   mov ah,2
   int 21h
   mov dl,0Dh;回车
   mov ah,2
   int 21h
   mov di, 0
   mov si, 0
   pop eax
   mov ebx, eax
   push ebx
binary_output: ; 以2进制的格式输出
   mov dl, '0'
   pop ebx
   rol ebx, 1 ; 循环左移1位
   push ebx
   and ebx, 00000001h
   add dl, bl
   mov ah, 02h
   int 21h
   inc di
   inc si
   cmp di, 4 ; 每四位进行一次空格，
             ; 但是最后四位结束没有空格，而是接上一个'h'
   jne no_space
   cmp si, 32
   je no_space
   mov dl, ' ' ; 输出空格
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
   mov ah, 4Ch ; 结束
   int 21h
code ends
end main