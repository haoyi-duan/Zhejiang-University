.386
data segment use16
s db 100 dup(0),0Dh,0Ah,'$';输入的字符串存储到数组s中
t db 100 dup(0),0Dh,0Ah,'$';输出的字符串存储到数组t中
data ends
code segment use16
assume cs:code, ds:data
main:
   mov ax, data
   mov ds, ax
   mov si, 0;数组s的下标用寄存器SI表示
   mov di, 0;数组t的下标用寄存器DI表示
   mov dx, 0
again:;循环调用int 21h的01h功能实现一行字符的输入
      ;输入的字符一次存到s数组中
   mov ah, 01h
   int 21h
   cmp al, 0Dh;判断是否输入回车，是则结束输入阶段
   je end_input
   mov s[si], al
   add si, 1
   jmp again
end_input:;结束输入，回车转化成ASCII码00h保存到数组中
   mov s[si], 00h
   mov si, 0
read:;读取s中的字符
   mov dl, s[si]
   add si, 1
   cmp dl, 'a'
   jae maybe_lower
   jmp not_lower
maybe_lower:;dl>='a'，进行进一步的小写字母判断
   cmp dl, 'z'
   jbe is_lower
not_lower:;不是小写字母，要判断是否是回车或者空格
   cmp dl, 0Dh
   je output
   cmp dl, ' '
   je is_empty
   mov t[di], dl
   add di, 1
   jmp read
is_empty:
   jmp read;字符是空格，不存入t数组中，跳转到read，继续读取后续的字符
is_lower:
   sub dl, 'a'
   add dl, 'A';是小写字符，转化成大写字符
   mov t[di], dl;转化后的大写字符存储到t数组中
   add di, 1
   jmp read
output:
   mov t[di], 00h;结束读取，最后把ASCII码00h保存到数组末尾
   mov di, 0;di赋值为0，之后重头开始遍历输出
   mov dl, 0Ah;换行
   mov ah, 02h
   int 21h
   mov dl, 0Dh;回车
   mov ah, 02h
   int 21h
print:
   mov dl, t[di]
   mov ah, 02h;循环调用int 21h的02h功能实现一行字符的输出
   int 21h
   add di, 1
   cmp dl, 00h;判断是否读到数组的末尾，是则跳转到exit
   je exit
   jmp print;循环调用print
exit:
   mov dl,0Ah;换行
   mov ah,2
   int 21h
   mov dl,0Dh;回车
   mov ah,2
   int 21h
   mov ah, 4Ch;结束
   int 21h
code ends
end main