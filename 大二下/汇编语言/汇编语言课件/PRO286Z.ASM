.386P
;=========================================================
;copyright (c) Black White, Dec 14, 2020.
;email: iceman@zju.edu.cn
;------------Structure of TSS-----------------------------
;structure for task state segment
_tss struc
back_link dw 0, 0  ; +00 selector of previous tss
esp0   dd 0        ; +04
ss0    dw 0, 0     ; +08
esp1   dd 0        ; +0C
ss1    dw 0, 0     ; +10
esp2   dd 0        ; +14
ss2    dw 0, 0     ; +18
_cr3   dd 0        ; +1C
_eip   dd 0        ; +20
_efl   dd 0        ; +24
_eax   dd 0        ; +28
_ecx   dd 0        ; +2C
_edx   dd 0        ; +30
_ebx   dd 0        ; +34
_esp   dd 0        ; +38
_ebp   dd 0        ; +3C
_esi   dd 0        ; +40
_edi   dd 0        ; +44
_es    dw 0, 0     ; +48
_cs    dw 0, 0     ; +4C
_ss    dw 0, 0     ; +50
_ds    dw 0, 0     ; +54
_fs    dw 0, 0     ; +58
_gs    dw 0, 0     ; +5C
_ldt   dw 0, 0     ; +60
tflag  dw 0        ; +64, bit0 of this word is called T(debug trap) flag,
                   ; when Tflag is set, it causes the processor to raise a debug
                   ; exception when a task switch to this task occurs.
iobase dw 0        ; +66
_tss ends
;total 68h bytes
;------------End of Structure of TSS----------------------

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

stk0 segment stack use16
stk0_begin label byte
   dw 200h dup(0)
stk0_len equ $ - offset stk0_begin
stk0 ends

stk3 segment use16
stk3_begin label byte
   dw 200h dup(0)
stk3_len equ $ - offset stk3_begin
stk3 ends

data segment use16
gdt  label byte
null_desc desc <0000h, 0000h, 00h, 00h, 00h, 00h>
code_sele equ $ - offset gdt; 08h
code_desc desc <0FFFFh, 0000h, 00h, 9Bh, 00h, 00h> ; 16-bit
data_sele equ $ - offset gdt; 10h
data_desc desc <0FFFFh, 0000h, 00h, 93h, 00h, 00h> ; 16-bit
tran_sele equ $ - offset gdt; 18h
tran_desc desc <0FFFFh, 0000h, 00h, 9Bh, 00h, 00h> ; 16-bit
pseg_sele equ $ - offset gdt; 20h
pseg_desc desc <0FFFFh, 0000h, 00h, 9Bh, 40h, 00h> ; 32-bit
gate_sele equ $ - offset gdt; 28h
gate_desc gate <0000h, 0000h, 00h, 0ECh, 0000h>    ; 386 call gate, DPL=3
stk0_sele equ $ - offset gdt; 30h
stk0_desc desc <0000h, 0000h, 00h, 93h, 00h, 00h>  ; 16-bit, DPL=0
stk3_sele equ $ - offset gdt; 38h
stk3_desc desc <0000h, 0000h, 00h, 0F3h, 00h, 00h> ; 16-bit, DPL=3
code0_sele equ $ - offset gdt; 40h
code0_desc desc <0FFFFh, 0000h, 00h, 9Bh, 40h, 00h> ; 32-bit
code3_sele equ $ - offset gdt; 48h
code3_desc desc <0FFFFh, 0000h, 00h, 9Bh, 40h, 00h> ; 32-bit
vram0_sele equ $ - offset gdt; 50h
vram0_desc desc <0FFFFh, 8000h, 0Ah, 93h, 4Fh, 00h> ; 32-bit, DPL=0
vram3_sele equ $ - offset gdt; 58h
vram3_desc desc <0FFFFh, 8000h, 0Ah, 0F3h, 4Fh, 00h>; 32-bit, DPL=3
tss0_sele  equ $ - offset gdt; 60h
tss0_desc  desc <0000h, 0000h, 00h, 0E9h, 00h, 00h> ; 16-bit, DPL=3, 386 tss, not busy
tss3_sele  equ $ - offset gdt; 68h
tss3_desc  desc <0000h, 0000h, 00h, 0E9h, 00h, 00h> ; 16-bit, DPL=3, 386 tss, not busy
gdt_len equ $ - offset gdt
gdtr _gdtr <0, 0, 0>
tss0 _tss <>
tss3 _tss <>
succ_msg db 'Success!', 0Dh, 0Ah, '$'
fail_msg db 'Failure!', 0Dh, 0Ah, '$'
old_a20_status db 0
data_len equ $ - offset gdt
data ends

code0 segment use32
assume cs:code0
code0_begin:
;This ring0 function will be called via call gate from ring3
draw_sth_on_the_screen0:
   push ebp
   mov ebp, esp
   push ds
   push es
   push ecx
   push esi
   push edi
   mov eax, [ebp+0Ch]; ax=argument vram3_sele
   mov ecx, [ebp+8]  ; cx=old_cs whose RPL is 3
   arpl ax, cx      ; Adjust the privilege level here to prevent ring0 
                    ; code from accessing the segment which ring3 has no 
                    ; privilege to access.
                    ; If ring3 passed vram_sele0 instead of vram_sele3 
                    ; as the argument, then the following instruction
                    ; "mov ds, ax" will definitely generate a GPF
                    ; (General Protection Fault).
   mov ds, ax       ; ds=vram3_sele or 3
   mov es, ax       ; es=vram3_sele or 3
   mov ecx, 80*25
   mov esi, 10000h
   mov edi, esi
reverse_color:
   lodsw; AX=DS:[ESI], ESI+=2
   ror ah, 4
   stosw
   loop reverse_color
   pop edi
   pop esi
   pop ecx
   pop es
   pop ds
   pop ebp
   retf 4; must pop the argument else old_esp & old_ss will not be popped properly

;ring0 is reached from ring3 via tss
ring0:
   db 0EAh; 48-bit jmp far ptr instruction
   dd offset transit; 32-bit offset
   dw tran_sele     ; 16-bit selector
                    ; jmp tran_sele:transit   
;code0_len equ $ - offset ring0
code0_len equ $ - offset code0_begin
code0  ends

code3 segment use32
assume cs:code3
ring3:
   mov ax, vram3_sele; RPL=0, here we need not set its RPL to 3 because
                     ; the callee will adjust the RPL with arpl instruction.
   push eax; argument passed to draw_sth_on_the_screen0()
   db 09Ah ; call far ptr gate_sele:0 ==> code0_sele:draw_sth_on_the_screen0
   dd 0
   dw gate_sele or 3
   ;
   db 0EAh ; jmp far ptr tss0_sele:0 ==> code0_sele:ring0
   dd 0    ; this far jmp via tss will cause task switch(from ring3 task 
   dw tss0_sele or 3; to ring0 task)
   ; This jmp instruction's machine code is as follows:
   ; 004B:0000000C EA  00 00 00 00  63 00 ; jmp far 0063:00000000
   ; 004B:00000013 ; This address will be saved in ring3's tss, that is to say,
   ;               ; tss._eip = 13h and tss._cs = 4Bh
code3_len equ $ - offset ring3
code3  ends

pseg segment use32; This segment is reserved for future maintenance.
assume cs:pseg
protect:          ; This function will never be called in this program.
   nop
pseg_len equ $ - offset protect
pseg ends

tran_seg segment use16; DPL=0, Executable | Readable, limit=FFFF
assume cs:tran_seg
transit:
   mov ax, data_sele; ax->old data_descriptor
   push ax
   mov ds, ax
   mov dx, data
   mov ebx, 10000h-1; limit must be compatible with real mode segment
   mov al, 93h      ; DPL must be 0 which is compatible with real mode segment
   mov ah, 00h      ; To recover access may be much more important than limit.
   mov si, data_sele
   db 9Ah ; call far ptr code_sele:fill_gdt_item
   dw offset fill_gdt_item
   dw code_sele     ; reset data_descriptor's limit & DPL
   pop ax; ax-> new data_descriptor
   mov ds, ax; refresh segment descriptor cache in protected mode
   mov es, ax; so that DS & ES's limit and access will be compatible with 
             ; those in real mode
   mov ax, stk0_sele
   push ax
   mov ax, data_sele
   mov ds, ax
   mov dx, stk0
   mov ebx, 10000h-1
   mov al, 93h     ; DPL=0
   mov ah, 0
   mov si, stk0_sele
   db 9Ah ; call far ptr code_sele:fill_gdt_item
   dw offset fill_gdt_item
   dw code_sele     ; reset data_descriptor's limit & DPL
   pop ax; ax->new stk0_descriptor
   mov ss, ax
   ;
   mov eax, cr0
   and eax, 7FFFFFFEh; remove paging & protecting flag   
   mov cr0, eax; disable protected mode
   db  0EAh    ; Now return to real mode! Use real mode address!
   dw  offset back_real
   dw  code
tran_seg ends

code segment use16
assume cs:code, ds:data, ss:stk0
main:
   cld
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
   mov ax, stk0
   mov ss, ax
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
   mov dx, code
   mov ebx, offset end_of_code - 1
   mov al, 9Bh; code(eXecutable | Readable | Accessed), DPL=0
   mov ah, 00h; 16-bit
   mov si, code_sele
   call far ptr fill_gdt_item
   ;
   mov dx, data; DX = real mode segment address
   mov ebx, data_len - 1; EBX= limit
   mov al, 093h ; AL = access, DPL=0
   mov ah, 00h ; AH = granularity
   mov si, data_sele; SI = selector
   call far ptr fill_gdt_item
   ;
   mov dx, tran_seg
   mov ebx, 10000h-1; limit must be compatible with real mode
   mov al, 9Bh ; code(eXecutable | Readable | Accessed), DPL=0
   mov ah, 00h ; 16-bit
   mov si, tran_sele
   call far ptr fill_gdt_item
   ;
   mov dx, pseg
   mov ebx, pseg_len - 1
   mov al, 9Bh ; code(eXecutable | Readable | Accessed), DPL=0
   mov ah, 40h ; 32-bit
   mov si, pseg_sele
   call far ptr fill_gdt_item
   ;
   mov gdt[gate_sele].selector, code0_sele
   mov ebx, offset draw_sth_on_the_screen0
   mov gdt[gate_sele].offset_0_15, bx
   shr ebx, 10h
   mov gdt[gate_sele].offset_16_31, bx
   mov gdt[gate_sele].arg_count, 1; one argument
   mov gdt[gate_sele].attrib, 0ECh; 386 call gate, DPL=3
   ;
   mov dx, stk0
   mov ebx, stk0_len-1
   mov al, 93h; data(Writable | Accessed), DPL=0
   mov ah, 00h; 16-bit
   mov si, stk0_sele
   call far ptr fill_gdt_item
   ;
   mov dx, stk3
   mov ebx, stk3_len-1
   mov al, 0F3h; data(Writable | Accessed), DPL=3
   mov ah, 00h; 16-bit
   mov si, stk3_sele
   call far ptr fill_gdt_item
   ;
   mov dx, code0
   mov ebx, code0_len - 1
   mov al, 09Bh; code(eXecutable | Readable | Accessed), DPL=0
   mov ah, 40h; 32-bit
   mov si, code0_sele
   call far ptr fill_gdt_item
   ;
   mov dx, code3
   mov ebx, code3_len - 1
   mov al, 0FBh; code(eXecutable | Readable | Accessed), DPL=3
   mov ah, 40h; 32-bit
   mov si, code3_sele
   call far ptr fill_gdt_item
   ;
   mov dx, 0A800h
   mov ebx, 100000h - 1; 1M-1
   mov al, 093h; DPL=0, data(Writable | Accessed)
   mov ah, 40h; 32-bit flag(Bit6) is set for data segment whose limit exceeds 64K
   mov si, vram0_sele
   call far ptr fill_gdt_item
   ;
   mov dx, 0A800h
   mov ebx, 100000h - 1; 1M-1
   mov al, 0F3h; DPL=3, data(Writable | Accessed)
   mov ah, 40h; 32-bit flag(Bit6) is set for data segment whose limit exceeds 64K
   mov si, vram3_sele
   call far ptr fill_gdt_item
   ;
   mov dx, data
   mov di, offset tss0
   mov ebx, 68h-1
   mov al, 0E9h; DPL=3, 386 tss, not busy
   mov ah, 00h; G=0, D=0
   mov si, tss0_sele
   call fill_tss_and_desc
   mov tss0._esp, stk0_len
   mov tss0._ss, stk0_sele
   mov tss0._eip, offset ring0
   mov tss0._cs, code0_sele
   mov tss0._ds, data_sele
   mov tss0._es, data_sele
   ;
   mov dx, data
   mov di, offset tss3
   mov ebx, 68h-1
   mov al, 0E9h; DPL=3, 386 tss, not busy
   mov ah, 00h; G=0, D=0
   mov si, tss3_sele
   call near ptr fill_tss_and_desc
   mov tss3._esp, stk3_len
   mov tss3._ss, stk3_sele or 3
   mov tss3._eip, offset ring3
   mov tss3._cs, code3_sele or 3
   mov tss3._ds, data_sele or 3
   mov tss3._es, data_sele or 3
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
   lgdt fword ptr gdtr; load GDT's base & limit into GDTR
   cli
   mov eax, cr0
   and eax, 7FFFFFFEh; remove paging & protecting flag
   or eax, 1         ; enable protected mode flag
   mov cr0, eax      ; switch to protected mode
   ;In 80286, the 4 instructions above may be replaced with 
   ;the following 4 instructions:
   ;smsw ax          ; save machine status word
   ;and ax, 1Fh
   ;or al, 1
   ;lmsw ax          ; enable PE bit of MSW or CR0
   mov ax, tss3_sele
   ltr ax            ; Load task register so that it will point to tss3_descriptor.
                     ; Loading tr is a must before calling a ring0 function via 
                     ; call gate from ring3, because call gate requires stack switch
                     ; which must be set in the tss pointed to by TR.
                     ; And we could not execute LTR in ring3 code, because it's
                     ; a privileged instruction which can only be executed in 
                     ; ring0 code.
   mov ax, stk3_sele
   or ax, 3; RPL=3
   movzx eax, ax
   push eax
   mov eax, stk3_len
   push eax
   mov ax, code3_sele
   or ax, 3; RPL=3
   movzx eax, ax
   push eax
   mov eax, offset ring3
   push eax
;------------------------------------------------------------------
;The following instructions are actually not needed, because
;every segment or selector has its internal descriptor cache.
   mov ax, stk0_sele
   mov ss, ax       ; ss=selector
   db 0EAh          ; jmp far ptr code_sele:here
   dw offset here   ; ip=here
   dw code_sele     ; cs=selector
;-------------The above instructions are not needed----------------
here:
   db 66h ; This opcode in combination with retf is to contruct a 
   retf   ; 32-bit retf instead of a 16-bit retf. A 16-bit retf 
          ; pops a 16-bit ip and a 16-bit cs, while a 32-bit retf
          ; concerned with inter-privilege-return(return_cs.RPL > CPL) 
          ; pops the following stuff in order:
          ;    32-bit return_eip;\ caller's cs:eip
          ;    32-bit return_cs ;/
          ;    32-bit return_esp;\ caller's ss:esp
          ;    32-bit return_ss ;/
          ; After retf, CPL will be set to 3(in real mode, CPL=0),
          ; cs=code3_sele|3, eip=ring3, ss=stk3_sele|3, esp=stk3_len,
          ; so the control will be transfered to code3_sele:ring3.
;------------------------------------------------------------------


;input:
;   DX = seg tss
;   DI = offset tss
;   AL = access
;   AH = granularity
;   SI = selector
;output:
;gdt+si -> tss_desc with info
;------------------------------------------------
;EFL structure for reference
;1 1 
;1 0 F E DC B A 9 8 7 6 5 4 3 2 1 0 ;<- Bit #
;V R 0 N IO O D I T S Z 0 A 0 P 1 C ;<- Flag Name
;M F   T PL
fill_tss_and_desc proc
    mov gdt[si].access, al
    mov gdt[si].gran, ah
    mov gdt[si].lim_0_15, bx; set lower 16 bits of limit
    shr ebx, 10h
    or  gdt[si].gran, bl; set higher 4 bits of limit
    push dx
    push di
    movzx edx, dx
    shl edx, 4
    movzx edi, di
    add edx, edi; convert logical address to physical address
    mov gdt[si].bas_0_15, dx ; set lower 16 bits of base address
    shr edx, 10h
    mov gdt[si].bas_16_23, dl; set mid 8 bits of base address
    mov gdt[si].bas_24_31, dh; set higher 8 bits of base address
    pop di
    pop dx
    push es
    push di
    mov es, dx
    xor al, al
    mov cx, 68h
    rep stosb
    pop di
    mov es:[di].iobase, 68h
    mov es:[di].esp0, stk0_len
    mov es:[di].ss0, stk0_sele
    pop es
    ret
fill_tss_and_desc endp


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
