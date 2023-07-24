.386P
;=========================================================
;copyright (c) Black White
;email: iceman@zju.edu.cn
;------------Structure of gate----------------------------
gate struc
offset_0_15  dw 0; +0+1 lower 16 bits for offset
selector     dw 0; +2+3 selector
arg_count    db 0; +4   count of arguments
attrib       db 0; +5   P DPL S TYPE
                 ;      1 00  0 1100
                 ;              1100=386 call gate
                 ;              0100=286 call gate
offset_16_31 dw 0; +6+7 upper 16 bits for offset
gate ends
;------------End of Structure of gate---------------------

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
;          B2: 1=Expand-down bit for stack, 1=Conform bit for code
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
priv_sele equ $ - offset gdt; 30h
priv_desc desc <0FFFFh, 0000h, 00h, 9Bh, 40h, 00h> ; 32-bit
gate_sele equ $ - offset gdt; 38h
gate_desc gate <0000h, 0000h, 00h, 8Ch, 0000h>     ; 386 call gate
gdt_len equ $ - offset gdt
gdtr _gdtr <0, 0, 0>
succ_msg db 'Success!', 0Dh, 0Ah, '$'
fail_msg db 'Failure!', 0Dh, 0Ah, '$'
old_a20_status db 0
data_len equ $ - offset gdt
data ends

priv_seg segment use32
assume cs:priv_seg
ring0:
   ;arpl
   push ebp
   mov ebp, esp
   push es
   push edi
   les edi, [ebp+0Ch]
   mov ax, es:[edi]
   ror ah, 4
   mov es:[edi], ax
   pop edi
   pop es
   pop ebp
   retf
priv_seg_len equ $ - offset ring0
priv_seg ends

pseg segment use32
assume cs:pseg
protect:
   cld
   mov ax, vram_sele; offset vram_desc
   mov ds, ax
   mov es, ax
   mov ecx, 80*25
   mov esi, 10000h
   mov edi, esi
reverse_color:
;   lodsw; AX=DS:[ESI], ESI+=2
;   ror ah, 4
;   stosw
   push es
   push edi
   db 09Ah; 48-bit call far ptr priv_sele:ring0
   dd 0   ; 32-bit offset will be ignored, because priv_sele points to a call gate
          ; which contains target selector & offset
   dw gate_sele
   add esp, 8
   add edi, 2
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
   mov al, 93h ; AL = access
   mov ah, 00h ; AH = granularity
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
   mov al, 093h; DPL=3, data(Writable | Accessed)
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
   mov dx, priv_seg
   mov ebx, priv_seg_len - 1
   mov al, 09Bh; DPL=3, code(eXecutable | Readable | Accessed)
   mov ah, 40h; 32-bit
   mov si, priv_sele
   call far ptr fill_gdt_item
   ;
   mov gdt[gate_sele].selector, priv_sele
   mov ebx, offset ring0
   mov gdt[gate_sele].offset_0_15, bx
   shr ebx, 10h
   mov gdt[gate_sele].offset_16_31, bx
   mov gdt[gate_sele].arg_count, 2
   mov gdt[gate_sele].attrib, 8Ch; 386 call gate
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
   lgdt fword ptr gdtr; 把gdt表的首地址及长度载入到gdtr寄存器
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
   test al, 2; input buffer full flag (Bit1)
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
