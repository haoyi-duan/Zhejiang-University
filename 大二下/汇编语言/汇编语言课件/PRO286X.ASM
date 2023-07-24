comment #
1. 如何区分段描述符与门描述符及系统描述符?
(1) 数据段、代码段、堆栈段描述符的access的S位(即Bit4)=1;
(2) 门描述符(call gate、interrupt gate、trap gate、task gate)的S位=0;
(3) 系统描述符TSS(task state segment)及LDT(local descriptor table)的S位=0;

2. 如何区分数据段描述符与代码段描述符?
(1) 数据段描述符的access的Bit3=0, 表示不可执行;
(2) 代码段描述符的access的Bit3=1, 表示可执行;

3. 数据段描述符与代码段描述符的access的Bit1有何区别?
(1) 数据段描述符access的Bit1=1时表示该数据段可写, 否则表示只读;
(2) 代码段描述符access的Bit1=1时表示该代码段可读, 否则表示只执行(不可读);

4. 数据段描述符与代码段描述符的access的Bit2有何区别?
(1) 数据段描述符access的Bit2=1时表示该数据段为expanded-down类型, 否则为普通数据段。
    expanded-down类型适用于堆栈段, base=段起始地址+limit+1, limit跟普通数据段一样。
    普通数据段的base=段起始地址。
(2) 代码段描述符access的Bit2=1时表示该代码段为conforming类型, 否则为普通代码段。
    conforming类型的代码段是指当调用者调用conforming代码段内的函数并执行到该函
    数内的指令时，当前CPL仍旧等于调用者的CPL而不会变成conforming段的DPL。当调用
    者调用普通代码段(non-conform)内的函数并执行到该函数内的指令时，当前CPL会变
    成non-conforming段的DPL。

5. 描述符的哪个位决定对应的段是32位还是16位?
   gran中的Bit6=1时表示该段为32位，否则表示该段为16位。当数据段的limit+1超过64K时，
   应该把Bit6置1。当代码段的指令工作在32位模式下时，必须把Bit6置1。请注意16位代码
   段与32位代码段的区别不仅仅在于偏移地址宽度的差异，更在于同样的机器码在不同模式
   下执行时会有不一样的结果，例如:
   (1) 33 C0这组机器码在16位模式下表示xor ax,ax而
   在32位模式下表示xor eax,eax
   (2) lodsb指令在16位模式下表示AL=ds:[si]再si++，
   而在32位模式下表示AL=ds:[esi]再
       esi++
   (3) call far ptr指令在16位模式下要求目标地址
   为"16位段地址:16偏移地址", 而在32位
       模式下, 要求目标地址为
       "16位段地址:32位偏移地址"

6. CPU如何判断当前进程能否访问某个段?
(1) CPL是当前进程CS中的低2位, 表示该进程的权限。DPL是段描述符(descriptor)中成员
    access的第6位及第5位, 表示该描述符所描述的段的访问权限。
(2) CPL <= DPL时，当前进程才可以访问该DPL对应的数据段
    0      3      当前进程访问gate时也使用此规则
(3) CPL >= DPL时，当前进程才可以通过调用门call该DPL对应的代码段
    3      0

7. 当ring3进程通过call gate调用ring0函数时，ring0函数使用什么方法阻止自己访问
   由调用者传递过来的参数所指向的调用者本来无权访问的内存块?
ring3:
   push 18h; 段地址    \  18h:28h->内存块
   push 28h; 偏移地址  /  其中ring3无权访问18h这个段(假定18h描述符的DPL=0)
   ;call 0020h:12345678h 不能直接call ring0段(假定20h描述符的DPL=0)
   call far ptr 10h:00000000h; 其中10h是call gate的selector
here:
   add esp, 8
;===============================================
;         0   1   2   3   4   5    6   7
;gdt+10h 78h,56h,20h,00h,02h,0ECh,34h,12h; 调用门
;                       参数 权限=
;                       个数 1110 1100(P=1, DPL=3, S=0, type=0Ch)
;目标函数的地址=0020h:12345678h
在cs:eip切换到0020h:12345678h前,
CPU从当前任务状态段tss(task state segment)中取出
ring0的堆栈指针ss0:esp0, 并设置ss=ss0, esp=esp0
tss里面包含了当前进程的所有寄存器值，还有切换到
ring0、ring1、ring2时要用到的堆栈指针ss0:esp0、 
ss1:esp1、ss2:esp2, 当前tss的首地址保存在寄存器tr中。
接下去在新堆栈中压入以下信息:
esp+00  here的偏移地址
esp+04  old cs; 注意old cs的低2位是调用者的CPL
esp+08  28h; 偏移地址
esp+0C  18h; 段地址
esp+10  old esp
esp+14  old ss
老堆栈中压入的信息如下(没有cs及返回地址):
esp+00  28h; 偏移地址
esp+04  18h; 段地址
注意新堆栈的权限是ring0，其内容不可能被调用者篡改。
到达目标函数后, CPL=0, 目标函数会在任何一个段寄存器
被赋值前对源操作数做权限修正, 例如:
ring0:
   push ebp
   mov ebp, esp
;指令执行到此, 堆栈结构如下:
;ebp+00  old ebp
;ebp+04  返回地址
;ebp+08  old cs; 注意old cs的低2位是调用者的CPL
;ebp+0C  28h; 偏移地址
;ebp+10  18h; 段地址
;ebp+14  old esp
;ebp+18  old ss
   mov ax, [ebp+10h]; 18h=调用者传递过来的内存块段地址
   ;mov ds, ax      ; 这里不可以不经权限验证就赋值给ds
   mov cx, [ebp+08h]; cx=old cs
   arpl ax, cx; 当ax.RPL<cx.RPL时, ax.RPL = cx.RPL
              ; arpl: adjust requestor's privilege level
              ; ax=2Bh=0000 0000 0010 1011
              ;       =0000 0000 0010 1000 + 11
   mov ds, ax ; 此时会引发GPF(General Protection Fault)
              ; 因为CPU会按以下规则做权限检查:
              ; max(CPL,RPL in ax) <= ax所指段的DPL
              ;          3                0
end of comment #



.386P
;=========================================================
;copyright (c) Black White
;email: iceman@zju.edu.cn
;------------Structure of Descriptor----------------------
desc struc
lim_0_15   dw 0; +0+1 lower 16 bits for segment limit(total 20 bits)
bas_0_15   dw 0; +2+3 lower 16 bits for segment's base address(total 32 bits)
bas_16_23  db 0; +4   16-23 bits for segment's base address
access     db 0; +5   access right byte; P(B7) DPL(B65) S(B4) T(B321) A(B0)
gran       db 0; +6   granularity byte; G(B7) D(B6) 0(B5) AVL(B4) lim_16_19(B3210)
bas_24_31  db 0; +7   higher 8 bits for segment's base address
desc ends

;--------------------------------------------------
;access:
;       P(B7)    Present bit(whether this segment exists)
;       DPL(B65) Descriptor Privilege Level bits(varies from 0 to 3)
;       S(B4)    Segment bit describing segment's attr:
;                1=data/code segment descriptor;
;                0=system descriptor(i.e. LDT and TSS desc.) and gate 
;                descriptor(i.e. task, call, interrupt, and trap gates' desc.)
;       T(B321)  Type bits:
;       1. if S==1(data/code/stack segment)
;          B3: Execute bit(1=code, 0=data or stack)
;          B2: 1=Expand-down bit for stack, 
;              1=Conform bit for code
;          B1: 1=Writable bit for data, 1=Readable bit for code
;          B0: Access bit, 1=accessed, 0=not accessed
;       2. if S==0(system desc. and gate desc.)
;          B3210: type for system desc. and gate desc.
;           00h: Undefined           08h: Undefined
;           01h: 286 TSS desc.       09h: 386 TSS desc.
;           02h: LDT desc.           0Ah: Undefined
;           03h: busy 286 TSS desc.  0Bh: busy 386 TSS desc.
;           04h: 286 call gate desc. 0Ch: 386 call gate desc.
;           05h: task gate desc.     0Dh: Undefined
;           06h: 286 intr gate desc. 0Eh: 386 intr gate desc.
;           07h: 286 trap gate desc. 0Fh: 386 trap gate desc.
;gran:
;     granularity byte.
;     G(B7)      Granularity bit: 1=page granularity, 0=byte granularity
;     D(B6)      Data attr bit: 1=32-bit addr, 0=16-bit addr
;     0(B5)      Reserved bit: should be kept 0
;     AVL(B4)    Available bit: kept for user
;     lim_16-19(B3210) higher 4 bits for segment limit
;--------------------------------------------------
;-----------End of Structure of descriptor---------

;----------Structure of gdtr-----------------------
_gdtr struc
_gdtr_lim       dw 0
_gdtr_bas_0_15  dw 0
_gdtr_bas_16_31 dw 0
_gdtr ends
;---------End of Structure of gdtr------------------------

stk segment stack use16
   dw 400h dup(0)
stk ends

data segment use16
gdt  label byte
null_desc desc <0000h, 0000h, 00h, 00h, 00h, 00h>
vram_sele equ $ - offset gdt; 08h
vram_desc desc <0FFFFh, 8000h, 0Ah, 93h, 4Fh, 00h> ; 32-bit
data_sele equ $ - offset gdt; 10h
data_desc desc <0FFFFh, 0000h, 00h, 93h, 00h, 00h> ; 16-bit
tran_sele equ $ - offset gdt; 18h
tran_desc desc <0FFFFh, 0000h, 00h, 9Bh, 00h, 00h> ; 16-bit
pseg_sele equ $ - offset gdt; 20h
pseg_desc desc <0FFFFh, 0000h, 00h, 9Bh, 40h, 00h> ; 32-bit
code_sele equ $ - offset gdt; 28h
code_desc desc <0FFFFh, 0000h, 00h, 9Bh, 00h, 00h> ; 16-bit
gdt_len equ $ - offset gdt
gdtr _gdtr <0, 0, 0>
succ_msg db 'Success!', 0Dh, 0Ah, '$'
fail_msg db 'Failure!', 0Dh, 0Ah, '$'
old_a20_status db 0
data_len equ $ - offset gdt
data ends


pseg segment use32
assume cs:pseg
protect:
   cld
   mov ax, vram_sele; offset vram_desc
   mov ds, ax; AX中的低2位称为RPL
   mov es, ax; 也会与vram_sele指向的描述符的DPL
             ; 比较
   mov ecx, 80*25
   mov esi, 10000h
   mov edi, esi
reverse_color:
   lodsw; AX=DS:[ESI], ESI+=2
   ror ah, 4
   stosw
   loop reverse_color
   db 0EAh; 48-bit jmp far ptr instruction
   dd offset transit; 32-bit offset
   dw tran_sele     ; 16-bit selector
                    ; jmp tran_sele:transit
pseg_len equ $ - offset protect
pseg ends

tran_seg segment use16
assume cs:tran_seg
transit:
   mov ax, data_sele
   mov ds, ax
   mov dx, data
   mov ebx, 10000h-1; limit must be compatible with real mode segment
   mov al, 93h
   mov ah, 00h
   mov si, data_sele
   db 9Ah ; call far ptr code_sele:fill_gdt_item
   dw offset fill_gdt_item
   dw code_sele
   ;
   mov ax, data_sele
   mov ds, ax; refresh segment descriptor cache in protected mode
   mov es, ax; so that DS & ES's limit and access will be compatible with 
             ; those in real mode
   ;
   mov eax, cr0
   and eax, 7FFFFFFEh; remove paging & protecting flag   
   mov cr0, eax; disable protected mode
   db  0EAh    ; Now return to real mode! Use real mode address!
   dw  offset back_real
   dw  code
tran_seg_len equ $ - offset transit
tran_seg ends

code segment use16
assume cs:code, ds:data, ss:stk
main:
   mov ax, data
   mov ds, ax
   ;Bochs config: port_e9_hack: enabled=1
   ;to insert a breakpoint here
   mov dx, 8A00h
   mov ax, 8A00h
   out dx, ax
   mov ax, 8AE0h
   out dx, ax
   ;
   call get_a20_status
   mov old_a20_status, al
   ;
   mov ah, 0DFh; A20 gated on
   call gate_a20
   jnz error
   jmp enable_a20_ok
back_real:
   mov ax, data
   mov ds, ax
   mov es, ax
   mov ah, old_a20_status
   call gate_a20; recover A20 status
   mov dx, offset succ_msg
   jmp exit
error:
   mov dx, offset fail_msg
exit:
   mov ah, 9
   int 21h
   mov ah, 4Ch
   int 21h

;output:
;  AL=A20 status
get_a20_status proc
   call test_8042
   mov al, 0ADh; disable keyboard
   out 64h, al
   call test_8042
   mov al, 0D0h; query status
   out 64h, al
   call test_8042
   in  al, 60h; AL=current A20 status
   push ax
   call test_8042
   mov al, 0AEh; enable keyboard
   out 64h, al
   call test_8042
   pop ax
   ret
get_a20_status endp

enable_a20_ok:
   mov dx, data; DX = real mode segment address
   mov ebx, data_len - 1; EBX= limit
   mov al, 93h ; AL = access 1001 0011
   mov ah, 00h ; AH = granularity 0000 0000
   mov si, data_sele; SI = selector
   call far ptr fill_gdt_item
   ;
   mov dx, pseg
   mov ebx, pseg_len - 1
   mov al, 9Bh ; code(eXecutable | Readable | Accessed)
   mov ah, 40h ; 32-bit
   mov si, pseg_sele
   call far ptr fill_gdt_item
   ;
   mov dx, tran_seg
   mov ebx, 10000h-1; limit must be compatible with real mode
   mov al, 9Bh ; code(eXecutable | Readable | Accessed)
   mov ah, 00h ; 16-bit
   mov si, tran_sele
   call far ptr fill_gdt_item
   ;
   mov dx, 0A800h
   mov ebx, 100000h - 1; 1M-1
   mov al, 93h; data(Writable | Accessed)
   mov ah, 40h; 32-bit flag(Bit6) is set for data segment whose limit exceeds 64K
   mov si, vram_sele
   call far ptr fill_gdt_item
   ;
   mov dx, code
   mov ebx, offset end_of_code - 1
   mov al, 9Bh; code(eXecutable | Readable | Accessed)
   mov ah, 00h; 16-bit
   mov si, code_sele
   call far ptr fill_gdt_item
   ;
   mov gdtr._gdtr_lim, gdt_len - 1
   mov dx, seg gdt
   mov ax, offset gdt
   movzx edx, dx
   movzx eax, ax
   shl edx, 4
   add edx, eax; edx = physical address of gdt
   mov gdtr._gdtr_bas_0_15, dx
   shr edx, 10h
   mov gdtr._gdtr_bas_16_31, dx
   lgdt fword ptr gdtr; gdtr是一个48位的变量
   ; 把gdt表的首地址及长度载入到gdtr寄存器
   ; sgdt指令用来把gdtr的值保存到某个48位变量中
   cli
   mov eax, cr0
   and eax, 7FFFFFFEh; remove paging & protecting flag
   or eax, 1         ; enable protected mode flag
   mov cr0, eax      ; switch to protected mode
   ;在386以下CPU中(如80286), 上面4条指令的效果也可以用以下4条指令实现
   ;smsw ax          ; save machine status word
   ;and ax, 1Fh
   ;or al, 1
   ;lmsw ax          ; enable PE bit of MSW or CR0

   ;jmp far ptr 20h:0  ; 这里不能用常数表示远跳的段地址, 否则会有编译错误
   db 0EAh; jmp far ptr; 故用机器码来实现jmp far指令
   dw 0000h            ; protect's offset
   dw pseg_sele        ; protect's selector
                       ; jmp pseg_sele:protect
;-----------------------------------
;input:
;   DX = real mode segment address
;   EBX= limit
;   AL = access
;   AH = granularity
;   SI = selector
;output:
;gdt+si -> gdt item with info
fill_gdt_item proc far
    mov gdt[si].access, al
    mov gdt[si].gran, ah
    mov gdt[si].lim_0_15, bx; set lower 16 bits of limit
    shr ebx, 10h
    or  gdt[si].gran, bl; set higher 4 bits of limit
    movzx edx, dx
    shl edx, 4; convert segment address to physical address
    mov gdt[si].bas_0_15, dx ; set lower 16 bits of base address
    shr edx, 10h
    mov gdt[si].bas_16_23, dl; set mid 8 bits of base address
    mov gdt[si].bas_24_31, dh; set higher 8 bits of base address
    retf
fill_gdt_item endp

;---------------------------------------------------------------
; GATE_A20:  This routine controls a signal which gates address
;            line 20 (A20).  The gate A20 signal is an output of
;            of the 8042 slave processor (keyboard controller).
;            A20 should be gated on before entering protected
;            mode, to allow addressing of the entire 16M address
;            space of the 80286, or 4G address space of the
;            80386 & 80486.  It should be gated off after
;            entering real mode -- from protected mode.
;---------------------------------------------------------------
; Input:   AH = DD ==> A20 gated off (A20 always 0)
;          AH = DF ==> A20 gated on  (CPU controls A20)
; Output:  AL = 0  ==> Operation successful
;          AL = 2  ==> Operation failed, 8042 can't accept cmd
; Register(s) modified:  AX
;---------------------------------------------------------------
gate_a20 proc
;---------------------------------------------------------------
   cli             ; disable ints while using 8042
   call test_8042  ; insure 8042 input buffer empty
   jnz  a20_fail   ; ret: 8042 unable to accept cmd
   mov  al, 0ADh   ; disable keyboard
   out  64h, al 
   call test_8042
   jnz  a20_fail
   mov  al, 0D1h   ; 8042 cmd to write output port
   out  64h, al    ; output cmd to 8042
   call test_8042  ; wait for 8042 to accept cmd
   jnz  a20_fail   ; ret: 8042 unable to accept cmd
   mov  al, ah     ; 8042 port data
   out  60h, al    ; output port data to 8042
   call test_8042  ; wait for 8042 to port data
   jnz  a20_fail
   mov  al, 0AEh   ; enable keyboard
   out  64h, al
   call test_8042
a20_fail:
   sti
   ret
gate_a20 endp

;---------------------------------------------------------------
; test_8042:  This routine waits for the 8042 buffer to empty.
;---------------------------------------------------------------
; Input:   None
; Output:  AL = 0, 8042 input buffer empty:     ZF
;          AL = 2, Time out; 8042 buffer full:  NZ
; Register(s) modified:  AX
;---------------------------------------------------------------
test_8042 proc
   push cx
   xor cx, cx
test_again:
   in al, 64h; 8042 status port 
   jmp $+2   ; may be replaced with the instruction for delay: out 0EDh, ax
   test al, 2; input buffer full flag (Bit1==1)
   loopnz test_again
   jz test_8042_ret
test_next:
   in al, 64h
   jmp $+2
   test al, 2
   loopnz test_next
test_8042_ret:
   pop cx
   ret
test_8042 endp
end_of_code label byte
code ends
end main
