.386
;对C语言版本的推箱子游戏进行汇编复现
dgroup group data, stk, code
   UP          equ 4800h ;汇编语言可以调用int 16h/AH=00h
   LEFT        equ 4B00h ;读取上下左右4个方向键及Esc、退格键
   DOWN        equ 5000h ;mov ah, 0
   RIGHT       equ 4D00h ;int 16h; AX = 键盘编码
   BACKSPACE   equ 0E08h ;退格键
   ESC_        equ 011Bh ;-----------------------------------
   ROCK        equ 0000h ;仓库外面的石块
   BRICK       equ 0001h ;包围仓库的红色砖块
   BOX         equ 0002h ;箱子
   FLOOR       equ 0003h ;仓库里面的绿色砖块
   BALL        equ 0004h ;球，用来标注箱子需要存放的位置
   MAN         equ 0005h ;推箱子的人，图像与WALK_UP相同
   BOB         equ 0006h ;box on ball，箱子与球重叠
   PUSH_UP     equ 0000h ;往上推箱子的人
   PUSH_LEFT   equ 0001h ;往左推箱子的人
   PUSH_DOWN   equ 0002h ;往下推箱子的人
   PUSH_RIGHT  equ 0003h ;往右推箱子的人
   WALK_UP     equ 0004h ;往上走的人
   WALK_LEFT   equ 0005h ;往左走的人
   WALK_DOWN   equ 0006h ;往下走的人
   WALK_RIGHT  equ 0007h ;往右走的人
   MAX_LEVEL   equ 30    ;关卡数量

;地图由BLK构成, 如BRICK, BOX, FLOOR, BALL, MAN都是BLK
;blk_ptr指向存放BLK图像的内存块, blk_size表示该内存块的长度
BLK_INFO struc
   BLK_INFOblk_size dw 0
   BLK_INFOblk_ptr dd 0
BLK_INFO ends
;存储文件的结构
SAVE struc
   SAVEmagic db 0,0
   SAVElevel dw 0
   SAVEsteps dw 0
   SAVEman_x dw 0
   SAVEman_y dw 0
   SAVEman_flag dw 0
   SAVEflag dw 1189 dup(0)
SAVE ends
;地图文件的结构
MAP struc
   MAPblk_size_level dw 11 dup(0)
   MAPflag dw 13079 dup(0)
MAP ends

stk segment stack use16
   db 100h dup('S')
stk ends

data segment use16
;blk_size_level一共有5级: 0, 1, 2, 3, 4
;其中0级不用; 各个blk_size_level对应的物体或人的图像宽、高为:
;obj_width[blk_size_level]
;obj_height[blk_size_level]
;以下二维数组的第1维就是blk_size_level;
;第2维是指物体或人的BLK ID, 如BRICK, BOX,
;FLOOR, PUSH_UP, WALK_UP均为BLK ID.
   blk_size_level dw 0
;存放物体的图像信息
   obj_blk BLK_INFO <>,<>,<>,<>,<>,<>,<>
           BLK_INFO <>,<>,<>,<>,<>,<>,<>
	   BLK_INFO <>,<>,<>,<>,<>,<>,<>
	   BLK_INFO <>,<>,<>,<>,<>,<>,<>
	   BLK_INFO <>,<>,<>,<>,<>,<>,<>
;存放人的图像信息
   man_blk BLK_INFO <>,<>,<>,<>,<>,<>,<>,<>
           BLK_INFO <>,<>,<>,<>,<>,<>,<>,<>
	   BLK_INFO <>,<>,<>,<>,<>,<>,<>,<>
	   BLK_INFO <>,<>,<>,<>,<>,<>,<>,<>
	   BLK_INFO <>,<>,<>,<>,<>,<>,<>,<>
;存放文本的图像信息：这包括“目前关数：000” “已走步数：0000”
   txt_blk BLK_INFO <>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>

   palette db 000h,001h,002h,003h,004h,005h,014h,007h
           db 038h,039h,03Ah,03Bh,03Ch,03Dh,03Eh,03Fh
;以下数组的下标均为blk_size_level
   obj_width      dw 000h,030h,020h,018h,010h
   obj_height     dw 000h,024h,018h,012h,00Ch
   map_columns    dw 000h,00Dh,014h,01Ah,028h
   map_rows       dw 000h,009h,00Eh,013h,01Ch 
   box_count      dw 0 ;箱子个数
   ball_count     dw 0 ;球的个数 
   bob_count      dw 0 ;箱子叠球的个数
   level          dw 0 ;第几关(base 1)
   steps          dw 0 ;已走步数
   level_in_map   dw 0 ;当前地图中是第几关(base 1), 一个地图文件里面总共10关
   man_x          dw 0 ;人的当前坐标
   man_y          dw 0 
   box_x          dw 0 ;刚推好的箱子坐标
   box_y          dw 0
   back_available dw 0 ;是否允许回退一步
   back_man_flag  dw 4 ;人的上一步flag
   man_flag       dw 4 ;人的当前flag
   ;
   ox  dw 0 ;当前坐标
   oy  dw 0
   nx  dw 0 ;前一格坐标
   ny  dw 0
   fx  dw 0 ;前二格坐标
   fy  dw 0
   opx dw 0 ;当前像素坐标
   opy dw 0
   npx dw 0 ;前一格像素坐标
   npy dw 0
   fpx dw 0 ;前二格像素坐标
   fpy dw 0
   back_man_x dw 0 ;上一步的人坐标
   back_man_y dw 0
   back_box_x dw 0 ;上一步的箱子坐标
   back_box_y dw 0
   ;地图中某个物体的id称为flag
   nflag  dw 0 ;前一格的flag
   fflag  dw 0 ;前两格的flag
   bar_px dw 0 ;状态条（用于显示当前关数及步数）的像素坐标
   bar_py dw 0
   str_level db 6 dup('?') ;当前关数
   str_steps db 6 dup('$') ;当前步数
   ;
   blk_buf dd 0 ;用来保存人当前踩住的物体的图像，如FLOOR，BALL
   pmap    dd 0 ;指向地图的指针
   ;
   ;各种报错信息的字符串
   err_malloc_text db "Not enough memory for blk_buf.", 0Dh, 0Ah, '$'
   err_blk_text    db "build_blk_info_from_file() failed!", 0Dh, 0Ah, '$'
   err_load_text   db "load_map(level) failed!", 0Dh, 0Ah, '$'
   ;程序中用到的文件名
   box_filename db "box.sav", 0
   filename1    db "boxdata\\obj\\size%\\flag%.dat", 0
   filename2    db "boxdata\\man\\size%\\man%.dat", 0
   filename3    db "boxdata\\txt\\txt%.dat", 0   
   filename4    db "boxdata\\txt\\txt10.dat", 0
   map_file     db "boxdata\\map\\lnk%x.map", 0
   ;玩家游戏状态
   play_status dw 0 
data ends

stk segment stack use16
   db 200h dup('S')
stk ends

code segment use16
assume cs:code, ds:data, ss:stk
;切换到文本模式
text:
   mov ax, 0003h
   int 10h
   ret
;切换到640*480*16 color图形模式
vga:
   mov ax, 0012h
   int 10h
   ;
   mov al, 5
   mov dx, 3CEh
   out dx, al
   mov al, 0
   inc dx; DX=3CFh
   out dx, al
   ;
   mov al, 8
   mov dx, 3CEh
   out dx, al
   inc dx
   mov al, 0FFh
   out dx, al
   ;
   mov al, 3
   mov dx, 3CEh
   out dx, al
   inc dx
   mov al, 0
   out dx, al
   ret
;
select_plane:
   push bp
   mov bp, sp
   push es
   ;
   mov al, 4
   mov dx, 3CEh
   out dx, al
   ;
   mov al, [bp+4]
   mov dx, 3CFh
   out dx, al
   ;
   mov al, 2
   mov dx, 3C4h
   out dx, al
   ;
   mov al, 1
   mov ah, [bp+4]
select_plane_begin:
   cmp ah, 0
   jle select_plane_end
   dec ah
   shl al, 1
   jmp select_plane_begin
select_plane_end:
   mov dx, 03C5h 
   out dx, al
   ;
   pop es
   pop bp
   ret
;调色板
set_palette:
   push bp
   mov bp, sp
   push es 
   ;
   mov ax, 1002h
   les dx, dword ptr [bp+4]
   mov bh, 0
   int 10h 
   ;
   pop es  
   pop bp
   ret
;
memset_far_memory_block:
   push bp
   mov bp, sp
   push cx
   push ax 
   push di
   push es
   ;
   les di, dword ptr [bp+4]
   mov cx, word ptr [bp+9]
   mov al, byte ptr [bp+8]
   cld
   rep stosb
   ;
   pop es
   pop di
   pop ax
   pop cx
   pop bp
   ret
;读文件，返回的是段地址，偏移地址为0
read_file: 
   push bp
   mov bp, sp
   ;FILE *
   sub sp, 2 ;[bp-2]:fp dw
   ;byte *
   sub sp, 2 ;[bp-4]:p dw
   ;word
   sub sp, 2 ;[bp-6]:size dw
   push ds
   push bx
   push di
   push si
   ;fp = fopen(filename, "rb");
   mov ax, data
   mov ds, ax
   mov ax, 3D00h
   mov dx, word ptr [bp+4]
   int 21h
   mov word ptr [bp-2], ax ;fp
   jc read_file_end
   ;fseek(fp, 0, SEEK_END);
   mov ax, 4202h
   mov bx, word ptr [bp-2] ;fp
   xor cx, cx
   xor dx, dx
   int 21h ;dx:ax = size
   mov word ptr [bp-6], ax
   ;fseek(fp, 0, SEEK_SET);
   mov ax, 4200h
   mov bx, word ptr [bp-2] ;fp
   xor cx, cx
   xor dx, dx
   int 21h ;dx:ax=0
   ;p = malloc(size)
   mov bx, word ptr [bp-6] ;size
   add bx, 0Fh
   shr bx, 4
   mov ah, 48h
   int 21h ;ax=segment for allocated memory
   mov word ptr [bp-4], ax ;p->segment
   jc read_file_close
   ;fread
   mov ah, 3Fh
   mov bx, word ptr [bp-2] ;fp
   mov cx, word ptr [bp-6] ;size
   mov dx, 0
   mov ds, word ptr [bp-4]
   int 21h
   jmp read_file_fread
read_file_close:
   mov ah, 3Eh
   mov bx, word ptr [bp-2] ;fp
   int 21h
read_file_end:
   ;*n = 0
   mov di, [bp+6] ;&n
   mov word ptr ss:[di], 0
   mov ax, 0
read_file_back:
   pop si 
   pop di 
   pop bx 
   pop ds 
   mov sp, bp
   pop bp
   ret
read_file_fread:
   mov ah, 3Eh
   mov bx, word ptr [bp-2] ;fp
   int 21h
   ;*n = size
   mov ax, word ptr [bp-6]
   mov di, word ptr [bp+6] 
   mov word ptr ss:[di], ax
   mov ax, word ptr [bp-4] ;p
   jmp read_file_back
;由于汇编中的malloc和farmalloc并无是实质上的区别，
;不在需要进行先段内申请内存空间存放数据，
;再将数据转移到段外，释放段内内存的方法，
;省去了copy_near_to_far函数
build_blk_info_from_file:
   push bp
   mov bp, sp
   ;
   sub sp, 2 ;[bp-2]:i dw
   sub sp, 2 ;[bp-4]:j dw
   sub sp, 2 ;[bp-6]:p dw p->段地址
   sub sp, 2 ;[bp-8]:n dw
   sub sp, 2 ;[bp-10]:copy_bytes dw
   push si
   push di 
   push bx 
   push dx
   ;
   mov word ptr [bp-2], 1 ;i=1
build_loop:
   cmp word ptr [bp-2], 4 ;i<=4
   ja build_loop_end
   mov word ptr [bp-4], 0 ;j=0
build_loop_in_loop:
   ;sprintf(filename, "boxdata\\obj\\size%d\\flag%d.dat", i, j);
   mov ax, word ptr [bp-2] ;i
   add al, '0' ;i+'0'
   mov byte ptr filename1[18], al 
   mov ax, word ptr [bp-4] ;j
   add al, '0' ;j+'0'   
   mov byte ptr filename1[25], al
   lea di, [bp-8]
   push di
   push offset filename1
   call read_file
   add sp, 4
   mov word ptr [bp-6], ax ;p
   cmp word ptr [bp-6], 0
   je build_return0
   ;求出 [i][j]
   mov ax, word ptr [bp-2] ;i
   mov dx, 0
   mov si, 7
   mul si
   add ax, word ptr [bp-4] ;i*7+j
   mov dx, 0
   mov si, type BLK_INFO
   mul si
   mov di, ax
   mov si, word ptr [bp-8] ;n
   mov obj_blk[di].BLK_INFOblk_size, si
   ;obj_blk[i][j].blk_ptr = {p, 0000}
   mov ax, word ptr [bp-6] ;p->seg
   shl eax, 16 ;长地址
   mov obj_blk[di].BLK_INFOblk_ptr, eax
   inc word ptr [bp-4] ;j++
   cmp word ptr [bp-4], 6 ;j<=6
   jle build_loop_in_loop
   inc word ptr [bp-2] ;i++
   jmp build_loop
build_loop_end:
   mov word ptr [bp-2], 1 ;i=1
build_loop2:
   cmp word ptr [bp-2], 4 ;i<=4
   ja build_loop2_end
   mov word ptr [bp-4], 0 ;j=0
build_loop2_in_loop:
   ;sprintf
   mov ax, word ptr [bp-2] ;i
   add al, '0' ;i+'0'
   mov byte ptr filename2[18], al 
   mov ax, word ptr [bp-4] ;j
   add al, '0' ;j+'0'   
   mov byte ptr filename2[24], al
   lea di, [bp-8]
   push di
   push offset filename2
   call read_file
   add sp, 4
   mov word ptr [bp-6], ax ;p
   cmp word ptr [bp-6], 0
   je build_return0
   ;求出 [i][j]
   mov ax, word ptr [bp-2] ;i
   mov dx, 0
   mov si, 8
   mul si
   add ax, word ptr [bp-4] ;i*7+j
   mov si, type BLK_INFO
   mul si
   mov di, ax
   mov si, word ptr [bp-8] ;n
   mov man_blk[di].BLK_INFOblk_size, si
   ;man_blk[i][j].blk_ptr = {p, 0000}
   mov eax, 0
   mov ax, word ptr [bp-6] ;p->seg
   shl eax, 16 ;长地址
   mov man_blk[di].BLK_INFOblk_ptr, eax
   inc word ptr [bp-4] ;j++
   cmp word ptr [bp-4], 7 ;j<=7
   jle build_loop2_in_loop
   inc word ptr [bp-2] ;i++
   jmp build_loop2
build_loop2_end:
   mov word ptr [bp-2], 0 ;i=0
build_loop3:
   cmp word ptr [bp-2], 10 ;i<10
   jae build_loop3_end
   ;sprintf
   mov ax, word ptr [bp-2] ;i
   add al, '0' ;i+'0'
   mov byte ptr filename3[17], al 
   lea di, [bp-8]
   push di
   push offset filename3
   call read_file
   add sp, 4
   mov word ptr [bp-6], ax ;p
   cmp word ptr [bp-6], 0
   je build_return0
   ;求出 [i]
   mov ax, word ptr [bp-2] ;i
   mov dx, 0
   mov si, type BLK_INFO
   mul si
   mov di, ax
   mov si, word ptr [bp-8] ;n
   mov txt_blk[di].BLK_INFOblk_size, si
   ;txt_blk[i][j].blk_ptr = {p, 0000}
   mov eax, 0
   mov ax, word ptr [bp-6] ;p->seg
   shl eax, 16 ;长地址
   mov txt_blk[di].BLK_INFOblk_ptr, eax
   inc word ptr [bp-2] ;i++
   jmp build_loop3
build_loop3_end:
   ;
   ;sprintf 
   lea di, word ptr [bp-8]
   push di
   push offset filename4
   call read_file
   add sp, 4
   mov word ptr [bp-6], ax ;p
   cmp word ptr [bp-6], 0
   je build_return0
   ;求出 [i]
   mov si, word ptr [bp-8] ;n
   mov txt_blk[60].BLK_INFOblk_size, si
   ;txt_blk[i][j].blk_ptr = {p, 0000}
   mov eax, 0
   mov ax, word ptr [bp-6] ;p->seg
   shl eax, 16 ;长地址
   mov txt_blk[60].BLK_INFOblk_ptr, eax   
   ;
   mov ax, 1
   jmp build_exit
build_return0:
   mov ax, 0
build_exit:
   pop dx 
   pop bx
   pop di 
   pop si 
   mov sp, bp
   pop bp
   ret
;保存左上角为(x, y), 右下角为(x+width-1, y+height-1)的矩形图像到p指向的内存块中
;int get_obj(byte far *p, int x, int y, word width, word height)
get_obj:
   push bp
   mov bp, sp
   ;byte far *
   sub sp, 4 ;[bp-4]:q dd
   sub sp, 4 ;[bp-8]:v dd
   sub sp, 4 ;[bp-12]:pv dd
   sub sp, 4 ;[bp-16]:buf dd
   ;byte
   ;ror是显卡中每个字节需要循环右移的次数
   sub sp, 1 ;[bp-17]:ror db
   ;latch用来保存显卡中某个字节的值
   sub sp, 1 ;[bp-18]:latch db
   sub sp, 1 ;[bp-19]:mask db
   sub sp, 1 ;[bp-20]:final_byte_mask db
   sub sp, 1 ;[bp-21]:tail_mask db
   sub sp, 1 ;[bp-22]:and_mask db
   ;int
   sub sp, 2 ;[bp-24]:bytes_per_line_per_plane dw
   sub sp, 2 ;[bp-26]:tail_bits_per_line_per_plane dw
   sub sp, 2 ;[bp-28]:r dw
   sub sp, 2 ;[bp-30]:plane dw
   sub sp, 2 ;[bp-32]:len dw
   sub sp, 2 ;[bp-34]:i dw
   sub sp, 2 ;[bp-36]:k dw
   sub sp, 2 ;[bp-38]:n dw
   ;
   push es
   push di
   push si
   push ds
   ;
   les di, dword ptr [bp+4] ;es:[di]->p
   mov si, word ptr [bp+12] ;width
   mov word ptr es:[di], si
   mov si, word ptr [bp+14] ;height
   mov word ptr es:[di+2], si
   mov word ptr [bp-32], 4
   mov ax, word ptr [bp+12] ;width
   mov dx, 0
   mov si, 8
   div si
   ;dx=width%8, ax=width/8
   mov word ptr [bp-24], ax
   mov word ptr [bp-26], dx
   ;buf = farmalloc((width+7) / 8 + 1);
   mov ax, [bp+12] ;width
   add ax, 7
   mov dx, 0
   mov si, 8
   div si
   ;dx=%8, ax=/8
   inc ax
   add ax, 0Fh
   shr ax, 4
   ;ax:内存块的节长度
   mov bx, ax ;内存块的节长度
   mov ah, 48h
   int 21h ;ax=内存块的段地址，内存块的偏移地址为0
   jc get_obj_return0
   shl eax, 16
   mov dword ptr [bp-16], eax
   ;v = (byte far *)0xA0000000 + (y * 640L + x) / 8
   mov ax, word ptr [bp+10] ;y
   mov dx, 0
   mov si, 640
   mul si
   ;dx:ax = y*640
   add ax, word ptr [bp+8] ;+x
   adc dx, 0
   mov si, 8
   div si
   ;dx:%8, ax:/8
   and eax, 0000FFFFh
   add eax, 0A0000000h
   mov dword ptr [bp-8], eax
   ;ror=x%8
   mov ax, word ptr [bp+8] ;x
   mov dx, 0
   mov si, 8
   div si
   ;dx=%8, ax=/8
   mov byte ptr [bp-17], dl
   ;mask = 0xFFh >> ror
   mov byte ptr [bp-19], 0FFh
   mov al, byte ptr [bp-17] ;ror
shift1:
   cmp al, 0
   jle shift1_end
   shr byte ptr [bp-19], 1
   dec al
   jmp shift1
shift1_end:
   ;q=p+4 // q->data(byte *)
   mov eax, dword ptr [bp+4] ;p dd
   add eax, 4
   mov dword ptr [bp-4], eax
   ;pv = v
   mov eax, dword ptr [bp-8]
   mov dword ptr [bp-12], eax
   ;for(r = 0; r < height; r++)
   mov word ptr [bp-28], 0 ;r=0
get_obj_loop_begin:
   mov ax, word ptr [bp+14] ;height
   cmp word ptr [bp-28], ax ;r < height
   jae get_obj_loop_end ;jmp if > or
   mov word ptr [bp-30], 0 ;plane=0
get_obj_loop_in:
   push word ptr [bp-30] ;push plane
   call select_plane
   add sp, 2
   cmp byte ptr [bp-17], 0 ;ror  
   je get_obj_loop_in_else
   mov di, word ptr [bp-24] ;bytes_per_line_per_plane
   inc di
   mov word ptr [bp-38], di ;n
   mov al, byte ptr [bp-19] ;mask
   mov byte ptr [bp-20], al ;final_byte_mask = mask
   jmp get_obj_loop_in_next
get_obj_loop_in_else:
   mov di, word ptr [bp-24] ;bytes_per_line_per_plane
   mov word ptr [bp-38], di
   mov byte ptr [bp-20], 0
get_obj_loop_in_next:
   ;movedata(FP_SEG(pv),FP_OFF(pv),FP_SEG(buf),FP_OFF(buf),n);
   mov ds, word ptr [bp-10]
   mov si, word ptr [bp-12]
   mov es, word ptr [bp-14]
   mov di, word ptr [bp-16]
   mov cx, word ptr [bp-38] ;n
   cld
   rep movsb
   ;if(tail_bits_per_line_per_plane != 0)
   cmp word ptr [bp-26], 0 ;tail_bits_plane != 0
   je tail_bits_plane_equal_0
   ;tail_mask = (1 << tail_bits_per_line_per_plane) - 1;
   mov al, 1
   mov si, word ptr [bp-26] ;tail_bits_per_line_per_plane
shift2:
   cmp si, 0
   jle shift2_end
   shl al, 1
   dec si
   jmp shift2
shift2_end:
   dec al ;tail_mask
   ;tail_mask = tail_mask << (8-tail_bits_per_line_per_plane);
   mov di, 8
   sub di, word ptr [bp-26] ;8-tail_bits_per_line_per_plane
shift3:
   cmp di, 0 ;tail_mask!=0
   jle shift3_end
   shl al, 1
   dec di
   jmp shift3
shift3_end:
   ;tail_mask = tail_mask >> ror | tail_mask << (8-ror);
   mov ah, al ;ah=al=tail_mask
   mov bh, byte ptr [bp-17] ;tail_mask>>ror
shift4:
   cmp bh, 0
   jle shift4_end
   shr ah, 1
   dec bh
   jmp shift4
shift4_end:
   mov dh, 8
   sub dh, byte ptr [bp-17] ;8-ror
shift5:
   cmp dh, 0 ;tail_mask<<(8-ror)
   jle shift5_end
   shl al, 1
   dec dh
   jmp shift5
shift5_end:
   or ah, al
   mov byte ptr [bp-21], ah ;tail_mask
   ;
   ;and_mask = final_byte_mask & tail_mask;
   ;ah=tail_mask
   and ah, byte ptr [bp-20] 
   mov byte ptr [bp-22], ah ;and_mask
   ;tail_mask ^= and_mask;
   xor byte ptr [bp-21], ah
   ;
   cmp byte ptr [bp-21], 0 ;tail_mask != 0
   je tail_mask_else
   les di, dword ptr [bp-16] ;es:[di]->buf
   lds si, dword ptr [bp-12] ;ds:[si]->pv
   add di, word ptr [bp-38]
   add si, word ptr [bp-38]
   movsb
   les di, dword ptr [bp-16] ;es:[di]->buf
   add di, word ptr [bp-38]
   mov al, byte ptr [bp-21] ;tail_mask
   and byte ptr es:[di], al
   inc word ptr [bp-38] ;n++
   jmp get_obj_loop_in_loop
tail_mask_else:
   ;buf[n-1] &= ~final_byte_mask | and_mask;
   les di, dword ptr [bp-16] ;es:[di]->buf
   add di, word ptr [bp-38]
   dec di
   ;es:[di]->buf[n-1]
   mov al, byte ptr [bp-20] ;~final_byte_mask
   not al
   or al, byte ptr [bp-22]
   and byte ptr es:[di], al
   jmp get_obj_loop_in_loop
tail_bits_plane_equal_0:
   ;buf[n-1] &= ~final_byte_mask;
   les di, dword ptr [bp-16] ;es:[di]->buf
   add di, word ptr [bp-38]
   dec di
   ;es:[di]->buf[n-1]
   mov al, byte ptr [bp-20] ;~final_byte_mask
   not al   
   and byte ptr es:[di], al
   ;
get_obj_loop_in_loop:
   mov word ptr [bp-36], 0 ;k=0
get_obj_loop_in_loop_begin:
   mov dl, byte ptr [bp-17] ;ror
   and dx, 00FFh
   cmp word ptr [bp-36], dx
   jge get_obj_loop_in_loop_end
   mov ax, 0 ;ah=old_cf, al=new_cf
   mov di, word ptr [bp-38] ;n
   dec di ;n-1
   mov word ptr [bp-34], di ;i=n-1
get_obj_loop_in_loop_in:
   les di, dword ptr [bp-16] ;buf
   add di, word ptr [bp-34]
   mov al, byte ptr es:[di] ;buf[i]
   shr al, 7 ;new_cf
   shl byte ptr es:[di], 1
   or byte ptr es:[di], ah
   mov ah, al 
   dec word ptr [bp-34] ;i--
   cmp word ptr [bp-34], 0 ;i >= 0
   jge get_obj_loop_in_loop_in
   inc word ptr [bp-36] ;k++
   jmp get_obj_loop_in_loop_begin   
get_obj_loop_in_loop_end:
   mov ax, word ptr [bp+12] ;width
   add ax, 7
   mov dx, 0
   mov si, 8
   div si
   ;dx:%8, ax:/8
   mov word ptr [bp-38], ax
   ;movedata(FP_SEG(buf), FP_OFF(buf), FP_SEG(q), FP_OFF(q), n);
   mov ds, word ptr [bp-14]
   mov si, word ptr [bp-16]
   mov es, word ptr [bp-2]
   mov di, word ptr [bp-4]
   mov cx, word ptr [bp-38] ;n
   cld 
   rep movsb
   ;q += n;
   ;len += n;
   mov bx, word ptr [bp-38] ;n
   and ebx, 0000FFFFh
   add dword ptr [bp-4], ebx ;q+=n
   add word ptr [bp-32], bx ;len+=n
   inc word ptr [bp-30] ;plane++
   cmp word ptr [bp-30], 4
   jl get_obj_loop_in 
   ;pv += 640/8;
   add dword ptr [bp-12], 80
   inc word ptr [bp-28] ;r++ 
   jmp get_obj_loop_begin
   ;
get_obj_loop_end:
   ;farfree(buf)
   mov ah, 49h
   mov es, word ptr [bp-14] ;seg buf
   int 21h
   mov ax, word ptr [bp-32] ;len
   jmp get_obj_exit
get_obj_return0:
   mov ax, 0
get_obj_exit:
   pop ds
   pop si 
   pop di 
   pop es 
   mov sp, bp
   pop bp
   ret 
;/* 在(x,y)处显示p所指向的BLK图像 */
;/* BLK图像结构如下:
;   +00 width ; word
;   +02 height; word
;   +04 line0 data for plane0; 0101 0101 \  构成了一条8个点的水平线
;       line0 data for plane1; 0011 0011  \ 每个点对应一个bit
;       line0 data for plane2; 0000 1111  / 从左到右8个点的颜色为:
;       line0 data for plane3; 0000 0000 /  0, 1, 2, 3, 4, 5, 6, 7
;       line1 data for plane0; |||     |
;       line1 data for plane1; |||     |
;       line1 data for plane2; |||     +----第7个点的二进制颜色从下往上=0111=7 
;       line1 data for plane3; ||+----------第2个点的二进制颜色从下往上=0010=2
;       line2 data for plane0; |+-----------第1个点的二进制颜色从下往上=0001=1
;       line2 data for plane1; +------------第0个点的二进制颜色从下往上=0000=0
;       line2 data for plane2;
;       line2 data for plane3;
; */
;void put_obj(byte far *p, int x, int y)
put_obj:
   ;[bp+4]:p dd
   ;[bp+8]:x dw
   ;[bp+10]:y dw
   push bp
   mov bp, sp
   ;byte far*
   sub sp, 4 ;[bp-4]:q dd
   sub sp, 4 ;[bp-8]:v dd
   sub sp, 4 ;[bp-12]:pv dd
   ;byte
   sub sp, 1 ;[bp-13]:ror db
   sub sp, 1 ;[bp-14]:latch db
   sub sp, 1 ;[bp-15]:mask db
   sub sp, 1 ;[bp-16]:final_byte_mask db
   sub sp, 1 ;[bp-17]:tail_mask db
   sub sp, 1 ;[bp-18]:and_mask db
   ;word
   sub sp, 2 ;[bp-20]:width dw
   sub sp, 2 ;[bp-22]:height dw
   sub sp, 2 ;[bp-24]:bytes_per_line_per_plane dw
   sub sp, 2 ;[bp-26]:tail_bits_per_line_per_plane dw
   sub sp, 2 ;[bp-28]:r dw
   sub sp, 2 ;[bp-30]:plane dw
   sub sp, 2 ;[bp-32]:i dw
   sub sp, 2 ;[bp-34]:n dw
   push es
   push di
   push si
   push ds
   ;   
   les di, dword ptr [bp+4] ;es:[di]->*p
   mov si, word ptr es:[di] ;*p
   mov word ptr [bp-20], si ;width = *(word far *)p;
   mov si, word ptr es:[di+2] ;*(p+2)
   mov word ptr [bp-22], si ;height = *(word far *)(p+2);
   mov ax, word ptr [bp-20]
   mov dx, 0
   mov si, 8
   div si
   ;dx:width%8, ax:width/8
   mov word ptr [bp-24], ax
   mov word ptr [bp-26], dx
   ;v = (byte far *)0xA0000000 + (y * 640L + x) / 8
   mov ax, word ptr [bp+10] ;y
   mov si, 640
   mul si
   ;dx:ax = y*640
   add ax, word ptr [bp+8] ;+x
   adc dx, 0
   mov si, 8
   div si
   ;dx:%8, ax:/8
   and eax, 0000FFFFh
   add eax, 0A0000000h
   mov dword ptr [bp-8], eax
   ;ror=x%8
   mov ax, word ptr [bp+8] ;x
   mov dx, 0
   mov si, 8
   div si
   ;dx=%8, ax=/8
   mov byte ptr [bp-13], dl
   ;mask = 0xFFh >> ror
   mov byte ptr [bp-15], 0FFh
   mov al, byte ptr [bp-13] ;ror
put_shift1:
   cmp al, 0
   jle put_shift1_end
   shr byte ptr [bp-15], 1
   dec al
   jmp put_shift1
put_shift1_end:
   ;q=p+4 // q->data(byte *)
   mov eax, dword ptr [bp+4] ;p dd
   add eax, 4
   mov dword ptr [bp-4], eax
   ;pv = v
   mov eax, dword ptr [bp-8]
   mov dword ptr [bp-12], eax   
   ;for(r = 0; r < height; r++)
   mov word ptr [bp-28], 0 ;r=0
put_obj_loop_begin:
   mov ax, word ptr [bp-22] ;height
   cmp word ptr [bp-28], ax ;r < height
   jge put_obj_loop_end ;jmp if > or =
   mov word ptr [bp-30], 0 ;plane=0
put_obj_loop_in:
   push word ptr [bp-30] ;push plane
   call select_plane
   add sp, 2
   cmp byte ptr [bp-13], 0 ;ror  
   je put_obj_loop_in_else
   ;outportb(0x3CE, 8); /* mask register */
   mov al, 8
   mov dx, 3CEh
   out dx, al
   ;outportb(0x3CF, mask);
   mov al, byte ptr [bp-15]
   mov dx, 3CFh
   out dx, al   
   ;outportb(0x3CE, 3); /* ror register */
   mov al, 3
   mov dx, 3CEh
   out dx, al
   ;outportb(0x3CF, ror);
   mov al, byte ptr [bp-13]
   mov dx, 3CFh
   out dx, al
   mov word ptr [bp-32], 0 ;i = 0
put_obj_loop_in_loop1:
   mov ax, word ptr [bp-24] ;bytes_per_line_per_plane
   cmp word ptr [bp-32], ax
   jae put_obj_loop_in_loop1_end
   ;latch = pv[i]
   mov si, word ptr [bp-32] ;i
   les di, dword ptr [bp-12] ;es:[di]->pv
   add di, si ;[i]
   mov al, byte ptr es:[di] ;al=pv[i]
   mov byte ptr [bp-14], al
   ;pv[i] = q[i]
   les di, dword ptr [bp-12] ;es:[di]->pv
   lds si, dword ptr [bp-4] ;ds:[si]->q
   mov ax, word ptr [bp-32] ;i
   add di, ax
   add si, ax
   movsb
   inc word ptr [bp-32] ;i++
   jmp put_obj_loop_in_loop1
put_obj_loop_in_loop1_end:
   ;outportb(0x3CE, 8); /* mask register */
   mov al, 8
   mov dx, 3CEh
   out dx, al
   ;outportb(0x3CF, ~mask);
   mov al, byte ptr [bp-15]
   not al
   mov dx, 3CFh
   out dx, al
   mov word ptr [bp-32], 0 ;i = 0 
put_obj_loop_in_loop2:
   mov ax, word ptr [bp-24] ;bytes_per_line_per_plane
   cmp word ptr [bp-32], ax
   jge put_obj_loop_in_loop2_end
   ;latch = pv[i+1]
   mov si, word ptr [bp-32] ;i
   inc si ;i+1
   les di, dword ptr [bp-12] ;es:[di]->pv
   add di, si ;[i+1]
   mov al, byte ptr es:[di] ;al=pv[i+1]
   mov byte ptr [bp-14], al
   ;pv[i+1] = q[i]
   les di, dword ptr [bp-12] ;es:[di]->pv
   lds si, dword ptr [bp-4] ;ds:[si]->q
   mov ax, word ptr [bp-32] ;i
   add di, ax
   inc di
   add si, ax
   movsb
   inc word ptr [bp-32] ;i++
   jmp put_obj_loop_in_loop2
put_obj_loop_in_loop2_end: 
   ;n = bytes_per_line_per_plane + 1;
   mov ax, word ptr [bp-24] ;byte_per_line_per_plane
   inc ax
   mov word ptr [bp-34], ax ;n=bytes_per_line_per_plane+1
   ;final_byte_mask = mask;
   mov al, byte ptr [bp-15] ;mask
   mov byte ptr [bp-16], al
   jmp put_obj_else_end
put_obj_loop_in_else:
   ;outportb(0x3CE, 8); /* mask register */
   mov al, 8
   mov dx, 3CEh
   out dx, al
   ;outportb(0x3CF, 0xFF);
   mov al, 0FFh
   mov dx, 3CFh
   out dx, al
   ;outportb(0x3CE, 3);
   mov al, 3
   mov dx, 3CEh
   out dx, al
   ;outportb(0x3CF, 0); 
   mov al, 0
   mov dx, 3CFh
   out dx, al
   ;movedata(FP_SEG(q), FP_OFF(q), FP_SEG(pv), FP_OFF(pv), bytes_per_line_per_plane);
   lds si, dword ptr [bp-4]
   les di, dword ptr [bp-12]
   mov cx, word ptr [bp-24]
   cld
   rep movsb
   ;n = bytes_per_line_per_plane;
   mov si, word ptr [bp-24]
   mov word ptr [bp-34], si
   ;final_byte_mask = 0x00; 
   mov byte ptr [bp-16], 0
put_obj_else_end:
   ;q += bytes_per_line_per_plane;
   mov ax, word ptr [bp-24]
   and eax, 0000FFFFh
   add dword ptr [bp-4], eax
   ;
   cmp word ptr [bp-26], 0
   je put_obj_loop_in_pre
   ;tail_mask = (1 << tail_bits_per_line_per_plane) - 1;
   mov al, 1
   mov si, word ptr [bp-26]
put_shift2:
   cmp si, 0
   jle put_shift2_end
   shl al, 1
   dec si
   jmp put_shift2 
put_shift2_end:
   ;tail_mask = tail_mask << (8-tail_bits_per_line_per_plane);
   mov si, 8
   sub si, word ptr [bp-26] ;si=(8-tail_bits_per_line_per_plane)
put_shift3:
   cmp si, 0
   jle put_shift3_end
   shl byte ptr [bp-17], 1
   dec si
   jmp put_shift3
put_shift3_end:
   ;tail_mask = tail_mask >> ror | tail_mask << (8-ror);
   mov ah, byte ptr [bp-17]
   mov al, byte ptr [bp-17]
   ;tail_mask >> ror
   mov dh, byte ptr [bp-13]
put_shift4:
   cmp dh, 0
   jle put_shift4_end
   shr ah, 1
   dec dh
   jmp put_shift4
put_shift4_end:
   ;tail_mask << (8-ror);
   mov dh, 8
   sub dh, byte ptr [bp-17]
put_shift5:
   cmp dh, 0
   jle put_shift5_end
   shl al, 1
   dec dh
   jmp put_shift5
put_shift5_end:
   or ah, al
   mov byte ptr [bp-17], ah
   ;and_mask = final_byte_mask & tail_mask;
   mov al, byte ptr [bp-16] ;final_byte_mask
   and al, byte ptr [bp-17] ;final_byte_mask & tail_mask;
   mov byte ptr [bp-18], al
   ;outportb(0x3CE, 8);
   mov al, 8
   mov dx, 3CEh
   out dx, al
   ;outportb(0x3CF, and_mask);
   mov al, byte ptr [bp-18]
   mov dx, 3CFh
   out dx, al
   ;outportb(0x3CE, 3);
   mov al, 3
   mov dx, 3CEh
   out dx, al
   ;outportb(0x3CF, ror);
   mov al, byte ptr [bp-13]
   mov dx, 3CEh
   out dx, al
   ;latch = pv[n-1];
   les di, dword ptr [bp-12]
   add di, word ptr [bp-34]
   dec di
   mov al, byte ptr es:[di]
   mov byte ptr [bp-14], al
   ;pv[n-1] = *q;
   les di, dword ptr [bp-4] ;es:[di]->q
   mov al, byte ptr es:[di] ;al=*q
   les di, dword ptr [bp-12]
   add di, word ptr [bp-34]
   dec di
   mov byte ptr es:[di], al
   ;tail_mask ^= and_mask;
   mov al, byte ptr [bp-18]
   xor byte ptr [bp-17], al
   ;if(tail_mask != 0)
   cmp byte ptr [bp-17], 0
   je put_obj_if_end
   ;outportb(0x3CE, 8);   
   mov al, 8
   mov dx, 3CEh
   out dx, al
   ;outportb(0x3CF, tail_mask);
   mov al, byte ptr [bp-17]
   mov dx, 3CFh
   out dx, al
   ;latch = pv[n];
   les di, dword ptr [bp-12] ;es:[di]->pv
   add di, word ptr [bp-34]
   mov al, byte ptr es:[di]
   mov byte ptr [bp-14], al
   ;pv[n] = *q;
   les di, dword ptr [bp-4] ;es:[di]->q
   mov al, byte ptr es:[di] ;al=*q
   les di, dword ptr [bp-12]
   add di, word ptr [bp-34]
   mov byte ptr es:[di], al  
put_obj_if_end:
   ;q++
   inc dword ptr [bp-4]
put_obj_loop_in_pre:
   ;plane++
   inc word ptr [bp-30]
   cmp word ptr [bp-30], 4
   jl put_obj_loop_in
   ;pv += 640/8;
   add dword ptr [bp-12], 80
   ;r++
   inc word ptr [bp-28]
   jmp put_obj_loop_begin
put_obj_loop_end:
   ;outportb(0x3CE, 8);
   mov al, 8
   mov dx, 3CEh
   out dx, al
   ;outportb(0x3CF, 0xFF);
   mov al, 0FFh
   mov dx, 3CFh
   out dx, al
   ;outportb(0x3CE, 3);
   mov al, 3
   mov dx, 3CEh
   out dx, al
   ;outportb(0x3CF, 0);
   mov al, 0
   mov dx, 3CFh
   out dx, al
put_obj_exit:
   pop ds
   pop si 
   pop di 
   pop es
   mov sp, bp
   pop bp
   ret
;
load_map: ;返回段地址
   push bp
   mov bp, sp
   ;
   sub sp, 2 ;[bp-2]:n dw
   sub sp, 2 ;[bp-4]:map_file_idx dw
   ;
   push di
   push si
   push es
   push ds
   ;
   cmp word ptr [bp+4], MAX_LEVEL
   jle load_map_next
   mov word ptr [bp+4], 1 ;level = 1
load_map_next:
   mov ax, word ptr [bp+4]
   dec ax
   mov dx, 0
   mov si, 10
   div si
   ;dx:%10, ax:/10
   mov word ptr [bp-4], ax
   ;pmap = read_file(map_file[map_file_idx], &n);
   lea si, [bp-2]
   push si
   mov al, byte ptr [bp-4] ;map_file_idx
   inc al
   add al, '0'
   mov dx, data 
   mov ds, dx
   mov byte ptr map_file[17], al
   push offset map_file
   call read_file
   add sp, 4
   ;
   pop ds
   pop es 
   pop si 
   pop di 
   mov sp, bp
   pop bp
   ret
;
draw_level_and_steps:
   push bp
   mov bp, sp
   ;
   sub sp, 2;[bp-2]:i dw
   sub sp, 2;[bp-4]:d dw
   ;
   push di
   push ax
   push bx
   push dx
   push es
   ;str_level<-"%03d"<-level
   mov str_level[0], 0
   mov ax, level
   mov bh, 10
   div bh
   mov str_level[1], al
   mov str_level[2], ah
   ;str_steps<-"%03d"<-steps
   mov ax, steps
   mov dx, 0
   mov di, 10
   div di
   ;dh = 个位
   mov str_steps[3], dl
   mov dx, 0
   div di
   ;dh = 十位
   mov str_steps[2], dl
   mov dx, 0
   div di
   ;dh = 百位
   mov str_steps[1], dl
   mov dx, 0
   div di
   ;dh = 千位
   mov str_steps[0], dl
   ;
   mov word ptr [bp-2], 0 ;i = 0
level_and_steps_loop_begin:
   cmp word ptr [bp-2], 3 ;i < 3
   jae level_steps_loop_end
   mov di, word ptr [bp-2]
   mov al, str_level[di]
   mov ah, 0
   mov word ptr [bp-4], ax
   mov ax, bar_py
   add ax, 4
   push ax
   ;bar_px+(8+i)*digit_width
   mov ax, word ptr [bp-2] ;ax = i
   add ax, 8 ;i+8
   mov bh, 00Ch
   mul bh ;ax=(i+8)*digit_width
   add ax, bar_px
   push ax ;int x
   mov ax, word ptr [bp-4]
   mov bx, type BLK_INFO
   mov dx, 0
   mul bx
   mov di, ax
   push txt_blk[di].BLK_INFOblk_ptr
   call put_obj
   add sp, 8
   inc word ptr [bp-2]
   jmp level_and_steps_loop_begin
level_steps_loop_end:
   mov word ptr [bp-2], 0 ;i = 0
level_and_steps_loop2_begin:
   cmp word ptr [bp-2], 4 ;i < 4
   jae level_steps_loop2_end
   mov di, word ptr [bp-2]
   mov al, str_steps[di]
   mov ah, 0
   mov word ptr [bp-4], ax
   mov ax, bar_py
   add ax, 4
   push ax
   ;bar_px+6+(19+i)*digit_width
   mov ax, word ptr [bp-2] ;ax = i
   add ax, 19 ;i+19
   mov bh, 00Ch
   mul bh ;ax=(i+19)*digit_width
   add ax, bar_px
   add ax, 6
   push ax
   mov ax, word ptr [bp-4]
   mov bx, type BLK_INFO
   mov dx, 0
   mul bx
   mov di, ax
   push txt_blk[di].BLK_INFOblk_ptr
   call put_obj
   add sp, 8
   inc word ptr [bp-2]
   jmp level_and_steps_loop2_begin
level_steps_loop2_end:
   pop es 
   pop dx 
   pop bx 
   pop ax 
   pop di 
   mov sp, bp
   pop bp
   ret
;
DrawMap_CountObj_SetManXyFlag:
   ;[bp+4]:mx dw
   ;[bp+6]:my dw
   ;[bp+8]:mflag dw
   push bp
   mov bp, sp
   ;
   sub sp, 2 ;[bp-2]:x dw
   sub sp, 2 ;[bp-4]:y dw
   sub sp, 2 ;[bp-6]:man_px
   sub sp, 2 ;[bp-8]:man_py
   sub sp, 2 ;[bp-10]:flag
   push si
   push di
   push es
   ;
   mov ball_count, 0
   mov box_count, 0
   mov bob_count, 0
   call vga ;转换到图形模式
   ;set_palette(&palette[0]); /* 设置调色板 */
   mov ebx, 0
   mov bx, offset palette
   mov ax, data
   shl eax, 16
   add eax, ebx
   push eax
   call set_palette
   add sp, 4
   ;y = 1
   mov word ptr [bp-4], 1 ;y = 1
Draw_loop:
   mov di, blk_size_level
   add di, di
   mov si, word ptr map_rows[di]
   cmp word ptr [bp-4], si
   ja Draw_loop_end
   mov word ptr [bp-2], 1 ;x = 1
Draw_loop_in:
   ;flag = pmap->flag[y][x][level_in_map];
   mov ax, word ptr [bp-4] ;y
   mov dx, 0
   mov si, 41*11
   mul si ;ax=size
   mov si, ax ;si=size
   mov dx, 0
   mov ax, word ptr [bp-2] ;x
   mov di, 11
   mul di ;ax=size'
   add si, ax
   add si, level_in_map
   add si, si
   les di, dword ptr pmap
   add di, 22
   add di, si 
   mov ax, word ptr es:[di] ;pmap->flag[y][x][level_in_map]
   mov word ptr [bp-10], ax ;flag
   ;if(flag == MAN)
   cmp word ptr [bp-10], MAN
   jne maybe_ball
   mov ax, word ptr [bp-2] ;x
   mov man_x, ax
   mov ax, word ptr [bp-4] ;y
   mov man_y, ax
   mov man_flag, WALK_UP ;原始地图里的人的flag一定是WALK_UP
   mov word ptr [bp-10], FLOOR ;把人换成FLOOR并显示在地图上
   ;pmap->flag[y][x][level_in_map] = FLOOR; 
   ;原始地图里的人踩住的物体一定是FLOOR, 不可能是BALL. 
   mov ax, word ptr [bp-4] ;y
   mov dx, 0
   mov si, 41*11
   mul si ;ax=size
   mov si, ax ;si=size
   mov dx, 0
   mov ax, word ptr [bp-2] ;x
   mov di, 11
   mul di ;ax=size'
   add si, ax
   add si, level_in_map
   add si, si
   les di, dword ptr pmap
   add di, 22
   add di, si
   mov word ptr es:[di], FLOOR
   jmp Draw_if_else_end
maybe_ball:
   ;else if(flag == BALL)
   cmp word ptr [bp-10], BALL
   jne maybe_box
   inc ball_count
   jmp Draw_if_else_end
maybe_box:
   ;else if(flag == BOX)
   cmp word ptr [bp-10], BOX
   jne maybe_bob
   inc box_count
   jmp Draw_if_else_end
maybe_bob:
   ;else if(flag == BOB)
   cmp word ptr [bp-10], BOB
   jne Draw_if_else_end
   inc ball_count
   inc box_count
   inc bob_count
Draw_if_else_end:
   ;put_obj(obj_blk[blk_size_level][flag].blk_ptr,
   ;      /*=*/ (x-1) * obj_width[blk_size_level],
   ;      /*=*/ (y-1) * obj_height[blk_size_level]); /* 画flag对应的BLK */
   ;画flag对应的BLK
   mov di, blk_size_level
   add di, di
   mov ax, word ptr obj_height[di]
   mov dx, 0
   mov si, word ptr [bp-4] ;y
   dec si ;y-1
   mul si
   push ax
   ;
   mov ax, word ptr obj_width[di]
   mov dx, 0
   mov si, word ptr [bp-2]
   dec si ;x-1
   mul si
   push ax
   ;push obj_blk[blk_size_level][flag].blk_ptr
   mov ax, blk_size_level
   mov dx, 0
   mov si, 7
   mul si
   ;ax = size
   add ax, word ptr [bp-10]
   mov dx, 0
   mov si, type BLK_INFO
   mul si
   mov di, ax
   push dword ptr obj_blk[di].BLK_INFOblk_ptr
   call put_obj
   add sp, 8
   ;x++
   inc word ptr [bp-2]
   mov di, blk_size_level
   add di, di
   mov si, word ptr map_columns[di]
   cmp word ptr [bp-2], si
   jle Draw_loop_in  
   inc word ptr [bp-4]
   jmp Draw_loop
Draw_loop_end:
   ;if(mx != 0 && my != 0)
   cmp word ptr [bp+4], 0
   je Draw_not
   cmp word ptr [bp+6], 0 
   je Draw_not
   mov ax, word ptr [bp+4]
   mov man_x, ax
   mov ax, word ptr [bp+6]
   mov man_y, ax
   mov ax, word ptr [bp+8]
   mov man_flag, ax
Draw_not:   
   ;man_px = (man_x-1) * obj_width[blk_size_level];
   mov di, blk_size_level
   add di, di
   mov ax, word ptr obj_width[di]
   mov di, man_x
   dec di
   mov dx, 0
   mul di
   mov word ptr [bp-6], ax
   ;man_py = (man_y-1) * obj_height[blk_size_level];
   mov di, blk_size_level
   add di, di
   mov ax, word ptr obj_height[di]
   mov di, man_y
   dec di
   mov dx, 0
   mul di
   mov word ptr [bp-8], ax
   ;get_obj(blk_buf, man_px, man_py, obj_width[blk_size_level], obj_height[blk_size_level]);
   ;保存人当前踩住的物体图像到blk_buf指向的内存块中
   mov di, blk_size_level
   add di, di
   push word ptr obj_height[di]
   ;
   push word ptr obj_width[di]
   push word ptr [bp-8]
   push word ptr [bp-6]
   push dword ptr blk_buf
   call get_obj
   add sp, 12
   ;put_obj(man_blk[blk_size_level][man_flag].blk_ptr, man_px, man_py);
   ;在(man_x, man_y)处画人
   push word ptr [bp-8]
   push word ptr [bp-6]
   ;push man_blk[blk_size_level][man_flag].blk_ptr
   mov ax, blk_size_level
   mov dx, 0
   mov si, 8
   mul si
   ;ax = size
   add ax, man_flag
   mov dx, 0
   mov si, type BLK_INFO
   mul si
   mov di, ax
   push dword ptr man_blk[di].BLK_INFOblk_ptr
   call put_obj
   add sp, 8
   ;bar_py = map_rows[blk_size_level] * obj_height[blk_size_level] + 4;
   mov di, blk_size_level
   add di, di
   mov ax, word ptr map_rows[di]
   mov dx, 0
   mov si, word ptr obj_height[di]
   mul si
   add ax, 4
   mov bar_py, ax
   ;bar_px = (map_columns[blk_size_level] * obj_width[blk_size_level]
   ;    - *(word far *)txt_blk[10].blk_ptr) / 2;
   mov di, blk_size_level
   add di, di
   mov ax, word ptr map_columns[di]
   mov dx, 0
   mov si, word ptr obj_width[di]
   mul si ;ax=map_columns*obj_width
   les di, dword ptr txt_blk[60].BLK_INFOblk_ptr
   mov si, word ptr es:[di]
   sub ax, si
   mov dx, 0
   mov si, 2
   div si
   mov bar_px, ax
   ;put_obj(txt_blk[10].blk_ptr, bar_px, bar_py);
   push bar_py
   push bar_px
   push dword ptr txt_blk[60].BLK_INFOblk_ptr
   call put_obj
   add sp, 8
   ;显示当前关数及步数
   call draw_level_and_steps
   ;
   pop es
   pop di 
   pop si 
   mov sp, bp
   pop bp
   ret
;
do_walk_or_push:
   push bp
   mov bp, sp
   push di
   push si
   push es
   ;nflag = 前面一格的flag; fflag = 前面二格的flag
   ;nflag = pmap->flag[ny][nx][level_in_map]
   mov ax, ny
   mov dx, 0
   mov si, 41*11
   mul si
   mov si, ax ;si=size
   mov dx, 0
   mov ax, nx
   mov di, 11
   mul di
   add si, ax
   add si, level_in_map
   add si, si
   les di, dword ptr pmap
   add di, 22
   add di, si
   mov ax, word ptr es:[di]
   mov nflag, ax   
   ;fflag = pmap->flag[fy][fx][level_in_map];
   mov ax, fy
   mov dx, 0
   mov si, 41*11
   mul si
   mov si, ax ;si=size
   mov dx, 0
   mov ax, fx
   mov di, 11
   mul di
   add si, ax
   add si, level_in_map
   add si, si
   les di, dword ptr pmap
   add di, 22
   add di, si
   mov ax, word ptr es:[di]
   mov fflag, ax
   ;if(nflag == ROCK || nflag == BRICK)
   ;cannot go
   cmp nflag, ROCK
   mov ax, 0
   je do_walk_exit
   cmp nflag, BRICK
   mov ax, 0
   je do_walk_exit
   ;opx = (ox-1) * obj_width[blk_size_level];
   ;当前(x,y)转化成像素坐标
   mov di, blk_size_level
   add di, di
   mov ax, obj_width[di]
   mov dx, 0
   mov si, ox
   dec si
   mul si
   mov opx, ax
   ;opy = (oy-1) * obj_height[blk_size_level];
   mov di, blk_size_level
   add di, di
   mov ax, obj_height[di]
   mov dx, 0
   mov si, oy
   dec si
   mul si
   mov opy, ax   
   ;npx = (nx-1) * obj_width[blk_size_level];
   ;前面一格(x,y)转化成像素坐标
   mov di, blk_size_level
   add di, di
   mov ax, obj_width[di]
   mov dx, 0
   mov si, nx
   dec si
   mul si
   mov npx, ax
   ;npy = (ny-1) * obj_height[blk_size_level];
   mov di, blk_size_level
   add di, di
   mov ax, obj_height[di]
   mov dx, 0
   mov si, ny
   dec si
   mul si
   mov npy, ax
   ;fpx = (fx-1) * obj_width[blk_size_level];
   ;前面二格(x,y)转化成像素坐标
   mov di, blk_size_level
   add di, di
   mov ax, obj_width[di]
   mov dx, 0
   mov si, fx
   dec si
   mul si
   mov fpx, ax
   ;fpy = (fy-1) * obj_height[blk_size_level];
   mov di, blk_size_level
   add di, di
   mov ax, obj_height[di]
   mov dx, 0
   mov si, fy
   dec si
   mul si
   mov fpy, ax
   ;if(nflag == FLOOR || nflag == BALL)
   cmp nflag, FLOOR
   je floor_or_ball
   cmp nflag, BALL
   je floor_or_ball
   jmp do_walk_next
floor_or_ball:
   ;put_obj
   push opy
   push opx
   push blk_buf
   call put_obj
   add sp, 8
   ;get_obj
   mov di, blk_size_level
   add di, di
   push word ptr obj_height[di]
   push word ptr obj_width[di]
   push npy
   push npx
   push blk_buf
   call get_obj
   add sp, 12
   ;put_obj:
   push npy
   push npx
   ;man_blk[blk_size_level][walk_flag].blk_ptr
   mov ax, blk_size_level   
   mov dx, 0
   mov si, 8
   mul si
   add ax, word ptr [bp+4]
   mov dx, 0
   mov si, type BLK_INFO
   mul si
   mov di, ax
   push dword ptr man_blk[di].BLK_INFOblk_ptr
   call put_obj
   add sp, 8
   mov back_available, 0
   mov ax, word ptr [bp+4]
   mov man_flag, ax
   mov ax, nx
   mov man_x, ax
   mov ax, ny
   mov man_y, ax
   inc steps
   call draw_level_and_steps
   mov ax, 1
   jmp do_walk_exit
do_walk_next:
   ;if(nflag == BOX || nflag == BOB)
   cmp nflag, BOX
   je box_or_bob
   cmp nflag, BOB
   je box_or_bob
   jmp do_walk_exit
box_or_bob:
   cmp fflag, FLOOR
   jne maybe_cannot_push
   jmp box_or_bob_next
maybe_cannot_push:
   cmp fflag, BALL
   jne cannot_push
   jmp box_or_bob_next
cannot_push:
   mov ax, 0
   jmp do_walk_exit
box_or_bob_next:
   ;put_obj(blk_buf, opx, opy);
   push opy
   push opx
   push blk_buf
   call put_obj
   add sp, 8
   cmp nflag, BOB
   jne do_walk_maybe_floor
   ;put_obj(obj_blk[blk_size_level][BALL].blk_ptr, npx, npy);
   push npy
   push npx
   mov ax, blk_size_level
   mov dx, 0
   mov si, 7
   mul si
   add ax, BALL
   mov dx, 0
   mov si, type BLK_INFO
   mul si
   mov di, ax
   push dword ptr obj_blk[di].BLK_INFOblk_ptr
   call put_obj
   add sp, 8
   mov ax, ny
   mov dx, 0
   mov si, 41*11
   mul si
   mov si, ax ;si=size
   mov ax, nx
   mov dx, 0
   mov di, 11
   mul di 
   add si, ax
   add si, level_in_map
   add si, si
   les di, dword ptr pmap 
   add di, 22
   add di, si 
   mov word ptr es:[di], BALL
   dec bob_count
   jmp do_walk_if_else_end
do_walk_maybe_floor:
   push npy 
   push npx
   mov ax, blk_size_level
   mov dx, 0
   mov si, 7
   mul si 
   add ax, FLOOR 
   mov si, type BLK_INFO
   mov dx, 0
   mul si
   mov si, ax
   push dword ptr obj_blk[si].BLK_INFOblk_ptr
   call put_obj
   add sp, 8
   mov ax, ny
   mov dx, 0
   mov si, 41*11
   mul si
   mov si, ax ;si=size
   mov ax, nx
   mov dx, 0
   mov di, 11
   mul di 
   add si, ax
   add si, level_in_map
   add si, si
   les di, dword ptr pmap 
   add di, 22
   add di, si 
   mov word ptr es:[di], FLOOR 
do_walk_if_else_end:
   ;get_obj(blk_buf, npx, npy, obj_width[blk_size_level], obj_height[blk_size_level]);
   mov si, blk_size_level
   add si, si
   push word ptr obj_height[si]
   push word ptr obj_width[si]
   push npy 
   push npx 
   push blk_buf
   call get_obj
   add sp, 12
   ;if(fflag == BALL)
   cmp fflag, BALL 
   jne new_else
   ;put_obj(obj_blk[blk_size_level][BOB].blk_ptr, fpx, fpy); 
   push fpy
   push fpx
   mov ax, blk_size_level
   mov dx, 0
   mov si, 7
   mul si
   add ax, BOB
   mov dx, 0
   mov si, type BLK_INFO
   mul si
   mov si, ax
   push dword ptr obj_blk[si].BLK_INFOblk_ptr
   call put_obj
   add sp, 8
   ;pmap->flag[fy][fx][level_in_map] = BOB;
   mov ax, fy 
   mov dx, 0
   mov si, 41*11
   mul si 
   mov si, ax ;si = size
   mov ax, fx
   mov dx, 0
   mov di, 11
   mul di 
   add si, ax
   add si, level_in_map
   add si, si
   les di, dword ptr pmap 
   add di, 22
   add di, si 
   mov word ptr es:[di], BOB 
   inc bob_count
   jmp do_walk_last_step
new_else:
   push fpy
   push fpx
   mov ax, blk_size_level
   mov dx, 0
   mov si, 7
   mul si
   add ax, BOX 
   mov dx, 0
   mov si, type BLK_INFO
   mul si
   mov si, ax
   push dword ptr obj_blk[si].BLK_INFOblk_ptr
   call put_obj
   add sp, 8
   ;pmap->flag[fy][fx][level_in_map] = BOX;
   mov ax, fy 
   mov dx, 0
   mov si, 41*11
   mul si 
   mov si, ax ;si = size
   mov ax, fx
   mov dx, 0
   mov di, 11
   mul di 
   add si, ax
   add si, level_in_map
   add si, si
   les di, dword ptr pmap 
   add di, 22
   add di, si 
   mov word ptr es:[di], BOX   
do_walk_last_step:
   ;put_obj(man_blk[blk_size_level][push_flag].blk_ptr, npx, npy);
   push npy
   push npx
   mov ax, blk_size_level
   mov dx, 0
   mov si, 8
   mul si 
   add ax, word ptr [bp+6]
   mov dx, 0
   mov si, type BLK_INFO
   mul si 
   mov si, ax
   push dword ptr man_blk[si].BLK_INFOblk_ptr
   call put_obj 
   add sp, 8
   mov ax, man_flag
   mov back_man_flag, ax
   mov ax, ox
   mov back_man_x, ax
   mov ax, oy
   mov back_man_y, ax
   mov ax, nx
   mov back_box_x, ax
   mov ax, ny
   mov back_box_y, ax
   mov ax, word ptr [bp+6]
   mov man_flag, ax
   mov ax, nx
   mov man_x, ax
   mov ax, ny
   mov man_y, ax
   mov ax, fx
   mov box_x, ax
   mov ax, fy
   mov box_y, ax
   mov back_available, 1
   inc steps
   call draw_level_and_steps
   ;if(bob_count == ball_count)
   mov ax, ball_count
   cmp bob_count, ax
   mov ax, 2
   je do_walk_exit
   mov ax, 1    
do_walk_exit:
   pop es
   pop si 
   pop di 
   pop bp
   ret
;
go_up:
   mov ax, man_x
   mov ox, ax
   mov nx, ax
   mov fx, ax
   ;
   mov ax, man_y
   mov oy, ax
   dec ax
   mov ny, ax
   dec ax
   mov fy, ax
   ;
   mov ax, PUSH_UP
   push ax
   mov ax, WALK_UP
   push ax
   call do_walk_or_push
   add sp, 4
   ret
;
go_left:
   mov ax, man_x
   mov ox, ax
   dec ax
   mov nx, ax
   dec ax
   mov fx, ax
   ;
   mov ax, man_y
   mov oy, ax
   mov ny, ax
   mov fy, ax
   ;
   mov ax, PUSH_LEFT
   push ax
   mov ax, WALK_LEFT
   push ax
   call do_walk_or_push
   add sp, 4
   ret
;
go_down:
   mov ax, man_x
   mov ox, ax
   mov nx, ax
   mov fx, ax
   ;
   mov ax, man_y
   mov oy, ax
   inc ax
   mov ny, ax
   inc ax
   mov fy, ax
   ;
   mov ax, PUSH_DOWN
   push ax
   mov ax, WALK_DOWN
   push ax
   call do_walk_or_push
   add sp, 4
   ret
;  
go_right:
   mov ax, man_x
   mov ox, ax
   inc ax
   mov nx, ax
   inc ax
   mov fx, ax
   ;
   mov ax, man_y
   mov oy, ax
   mov ny, ax
   mov fy, ax
   ;
   mov ax, PUSH_RIGHT
   push ax
   mov ax, WALK_RIGHT
   push ax
   call do_walk_or_push
   add sp, 4
   ret
;
go_back:
   push bp 
   mov bp, sp
   ;
   sub sp, 2 ;[bp-2]:bx dw
   sub sp, 2 ;[bp-4]:by dw
   sub sp, 2 ;[bp-6]:bpx dw
   sub sp, 2 ;[bp-8]:bpy dw
   ; 
   push di
   push si
   push es 
   cmp back_available, 0
   mov ax, 0
   je go_back_exit
   mov ax, man_x
   mov ox, ax
   mov ax, man_y
   mov oy, ax
   mov ax, box_x
   mov word ptr [bp-2], ax
   mov ax, box_y
   mov word ptr [bp-4], ax 
   ;
   mov di, blk_size_level
   add di, di
   mov ax, word ptr obj_width[di]
   mov dx, 0
   mov si, ox 
   dec si 
   mul si 
   mov opx, ax ;当前人的(x,y)转化成像素坐标
   ;
   mov ax, word ptr obj_height[di]
   mov dx, 0
   mov si, oy  
   dec si 
   mul si 
   mov opy, ax
   ;
   ;当前箱子的(x,y)转化成像素坐标
   mov ax, word ptr obj_width[di]
   mov dx, 0
   mov si, word ptr [bp-2] ;bx 
   dec si 
   mul si 
   mov word ptr [bp-6], ax
   ;
   mov ax, word ptr obj_height[di]
   mov dx, 0
   mov si, word ptr [bp-4]
   dec si 
   mul si 
   mov word ptr [bp-8], ax
   ;
   ;put_obj(blk_buf, opx, opy);
   push opy 
   push opx 
   push dword ptr blk_buf
   call put_obj
   add sp, 8
   ;
   mov ax, word ptr [bp-4]
   mov dx, 0
   mov si, 41*11
   mul si 
   mov si, ax ;si = size
   mov ax, word ptr [bp-2]
   mov dx, 0
   mov di, 11
   mul di 
   add si, ax
   add si, level_in_map
   add si, si
   les di, dword ptr pmap 
   add di, 22
   add di, si
   cmp word ptr es:[di], BOB
   jne go_back_else
   ;put_obj(obj_blk[blk_size_level][BALL].blk_ptr, bpx, bpy);
   push word ptr [bp-8]
   push word ptr [bp-6]
   mov ax, blk_size_level
   mov dx, 0
   mov si, 7
   mul si 
   add ax, BALL 
   mov dx, 0
   mov si, type BLK_INFO 
   mul si 
   mov si, ax
   push obj_blk[si].BLK_INFOblk_ptr
   call put_obj 
   add sp, 8   
   mov ax, word ptr [bp-4]
   mov si, 41*11
   mov dx, 0
   mul si 
   mov si, ax ;si = size
   mov ax, word ptr [bp-2]
   mov dx, 0
   mov di, 11
   mul di 
   add si, ax
   add si, level_in_map
   add si, si
   les di, dword ptr pmap 
   add di, 22
   add di, si 
   mov word ptr es:[di], BALL 
   dec bob_count
   jmp go_back_else_end
go_back_else:
   push word ptr [bp-8]
   push word ptr [bp-6]
   mov ax, blk_size_level
   mov dx, 0
   mov si, 7
   mul si 
   add ax, FLOOR 
   mov dx, 0
   mov si, type BLK_INFO 
   mul si 
   mov si, ax
   push dword ptr obj_blk[si].BLK_INFOblk_ptr
   call put_obj 
   add sp, 8
   mov ax, word ptr [bp-4]
   mov si, 41*11
   mov dx, 0
   mul si 
   mov si, ax
   mov ax, word ptr [bp-2]
   mov dx, 0
   mov di, 11
   mul di 
   add si, ax
   add si, level_in_map
   add si, si
   les di, dword ptr pmap 
   add di, 22
   add di, si 
   mov word ptr es:[di], FLOOR     
go_back_else_end:
   mov ax, back_man_x
   mov ox, ax
   mov ax, back_man_y
   mov oy, ax
   mov ax, back_box_x
   mov word ptr [bp-2], ax
   mov ax, back_box_y
   mov word ptr [bp-4], ax
   ;
   mov si, blk_size_level
   add si, si
   mov ax, obj_width[si] 
   mov dx, 0
   mov di, ox 
   dec di 
   mul di 
   mov opx, ax
   ;
   mov ax, obj_height[si] 
   mov dx, 0
   mov di, oy 
   dec di 
   mul di 
   mov opy, ax
   ;
   mov ax, obj_width[si] 
   mov dx, 0
   mov di, word ptr [bp-2]
   dec di 
   mul di 
   mov word ptr [bp-6], ax
   ;
   mov ax, obj_height[si] 
   mov dx, 0
   mov di, word ptr [bp-4] 
   dec di 
   mul di 
   mov word ptr [bp-8], ax
   ;
   ;get_obj(blk_buf, opx, opy, obj_width[blk_size_level], obj_height[blk_size_level]);
   push word ptr obj_height[si]
   push word ptr obj_width[si]
   push opy 
   push opx 
   push dword ptr blk_buf
   call get_obj
   add sp, 12
   ;put_obj
   push opy 
   push opx 
   mov ax, blk_size_level
   mov dx, 0
   mov si, 8
   mul si 
   add ax, back_man_flag
   mov dx, 0
   mov si, type BLK_INFO 
   mul si 
   mov si, ax
   push man_blk[si].BLK_INFOblk_ptr
   call put_obj
   add sp, 8
   ;if(pmap->flag[by][bx][level_in_map] == BALL)
   mov ax, word ptr [bp-4]
   mov dx, 0
   mov si, 41*11
   mul si 
   mov si, ax ;si = size
   mov ax, word ptr [bp-2]
   mov dx, 0
   mov di, 11
   mul di 
   add si, ax
   add si, level_in_map
   add si, si
   les di, dword ptr pmap 
   add di, 22
   add di, si 
   cmp word ptr es:[di], BALL 
   jne go_back_last_step_else
   ;
   ;put_obj(obj_blk[blk_size_level][BOB].blk_ptr, bpx, bpy);
   push word ptr [bp-8]
   push word ptr [bp-6]
   mov ax, blk_size_level
   mov dx, 0
   mov si, 7
   mul si 
   add ax, BOB 
   mov dx, 0
   mov si, type BLK_INFO 
   mul si 
   mov si, ax
   push dword ptr obj_blk[si].BLK_INFOblk_ptr
   call put_obj
   add sp, 8
   mov ax, word ptr [bp-4]
   mov dx, 0
   mov si, 41*11
   mul si 
   mov si, ax ;si = size
   mov ax, word ptr [bp-2]
   mov dx, 0
   mov di, 11
   mul di 
   add si, ax
   add si, level_in_map
   add si, si
   les di, dword ptr pmap 
   add di, 22
   add di, si 
   mov word ptr es:[di], BOB 
   inc bob_count
   ;   
   jmp go_back_final
go_back_last_step_else:
   ;put_obj(obj_blk[blk_size_level][BOX].blk_ptr, bpx, bpy);
   push word ptr [bp-8]
   push word ptr [bp-6]
   mov ax, blk_size_level
   mov dx, 0
   mov si, 7
   mul si 
   add ax, BOX
   mov dx, 0
   mov si, type BLK_INFO 
   mul si 
   mov si, ax
   push dword ptr obj_blk[si].BLK_INFOblk_ptr
   call put_obj
   add sp, 8
   mov ax, word ptr [bp-4]
   mov dx, 0
   mov si, 41*11
   mul si 
   mov si, ax ;si = size
   mov ax, word ptr [bp-2]
   mov dx, 0
   mov di, 11
   mul di 
   add si, ax
   add si, level_in_map
   add si, si
   les di, dword ptr pmap 
   add di, 22
   add di, si 
   mov word ptr es:[di], BOX
go_back_final:
   ;man_x = ox;
   mov ax, ox
   mov man_x, ax
   mov ax, oy
   mov man_y, ax
   mov ax, back_man_flag
   mov man_flag, ax
   mov ax, word ptr [bp-2]
   mov box_x, ax
   mov ax, word ptr [bp-4]
   mov box_y, ax
   dec steps 
   call draw_level_and_steps
   mov back_available, 0
   mov ax, 1 
go_back_exit:
   pop es 
   pop si 
   pop di 
   mov sp, bp 
   pop bp 
   ret 
;
go_esc:
   push bp 
   mov bp, sp 
   ;
   sub sp, 2 ;[bp-2]:ps dw 存储段地址
   sub sp, 2 ;[bp-4]:fp dw
   sub sp, 2 ;[bp-6]:n dw
   sub sp, 2 ;[bp-8]:x dw
   sub sp, 2 ;[bp-10]:y dw
   ;
   push si
   push di
   push bx
   push es
   push ds
   ;fp = fopen("box.sav", "wb");
   mov ax, 3D01h
   mov dx, data
   mov ds, dx 
   mov dx, offset box_filename
   int 21h ;ax = fp
   mov word ptr [bp-4], ax ;fp
   jnc go_esc_malloc
   ;setup a new file
   mov ah, 3Ch
   mov dx, data
   mov ds, dx 
   mov dx, offset box_filename
   mov cx, 0
   int 21h  
   mov word ptr [bp-4], ax ;fp
   jc go_esc_exit 
   ;fp = fopen("box.sav", "wb");
   mov ax, 3D01h
   mov dx, data
   mov ds, dx 
   mov dx, offset box_filename
   int 21h ;ax = fp
   mov word ptr [bp-4], ax ;fp
   jc go_esc_exit
go_esc_malloc:
   ;ps = malloc(sizeof(SAVE)); 段地址
   mov bx, type SAVE
   add bx, 0Fh
   shr bx, 4
   mov ah, 48h
   int 21h
   mov word ptr [bp-2], ax
   mov ax, -1
   jc go_esc_exit
   ;initialize the ps->SAVE
   mov ax, word ptr [bp-2]
   mov es, ax 
   mov byte ptr es:[0], 'B'
   mov byte ptr es:[1], 'W'
   mov ax, level
   mov word ptr es:[2], ax
   mov ax, steps
   mov word ptr es:[4], ax
   mov ax, man_x
   mov word ptr es:[6], ax
   mov ax, man_y
   mov word ptr es:[8], ax
   mov ax, man_flag
   mov word ptr es:[10], ax 
   mov word ptr [bp-10], 1 ;y = 1
go_esc_loop:
   mov si, blk_size_level
   add si, si 
   mov ax, word ptr map_rows[si]
   cmp word ptr [bp-10], ax ;y <= map_rows
   ja go_esc_loop_end
   mov word ptr [bp-8], 1 ;x = 1
go_esc_loop_in:
   ;ps->flag[y][x] = pmap->flag[y][x][level_in_map];
   mov ax, word ptr [bp-10] ;y
   mov dx, 0
   mov si, 41*11
   mul si 
   mov si, ax ;si = size
   mov ax, word ptr [bp-8] ;x
   mov dx, 0
   mov di, 11
   mul di 
   add si, ax
   add si, level_in_map
   add si, si 
   les di, dword ptr pmap 
   add di, 22
   add di, si
   mov cx, word ptr es:[di]
   ;pmap->flag[y][x][level_in_map];
   ;
   mov ax, word ptr [bp-10]
   mov dx, 0
   mov si, 41
   mul si 
   add ax, word ptr [bp-8] ;ax = y*0x29+x
   mov di, ax
   add di, di 
   mov es, word ptr [bp-2] ;ps
   mov word ptr es:[di+12], cx
   inc word ptr [bp-8]
   mov si, blk_size_level
   add si, si 
   mov ax, word ptr map_columns[si]
   cmp word ptr [bp-8], ax ;x <= map_columns
   jle go_esc_loop_in 
   inc word ptr [bp-10]
   jmp go_esc_loop  
go_esc_loop_end:
   ;fwrite(ps, 1, sizeof(SAVE), fp);
   mov ah, 40h
   mov bx, word ptr [bp-4]
   mov cx, type SAVE 
   mov ds, word ptr [bp-2]
   mov dx, 0
   int 21h
   ;fclose(fp);
   mov ah, 3Eh
   mov bx, word ptr [bp-4]
   int 21h
   ;free(ps);
   mov ah, 49h
   mov es, word ptr [bp-2] ;ps
   int 21h
   mov ax, -1
go_esc_exit:
   pop ds 
   pop es 
   pop bx 
   pop di 
   pop si 
   mov sp, bp 
   pop bp 
   ret 
;
play:
   push bp
   mov bp, sp
   ;Go *go[6]
   sub sp, 2
   mov ax, offset go_up
   mov word ptr [bp-2], ax ;go_up
   sub sp, 2
   mov ax, offset go_left
   mov word ptr [bp-4], ax ;go_left
   sub sp, 2
   mov ax, offset go_down
   mov word ptr [bp-6], ax ;go_down
   sub sp, 2
   mov ax, offset go_right
   mov word ptr [bp-8], ax ;go_right
   sub sp, 2
   mov ax, offset go_back
   mov word ptr [bp-10], ax ;go_back
   sub sp, 2
   mov ax, offset go_esc
   mov word ptr [bp-12], ax ;go_esc
   ;word key_map[6]
   sub sp, 2
   mov word ptr [bp-14], UP
   sub sp, 2
   mov word ptr [bp-16], LEFT
   sub sp, 2
   mov word ptr [bp-18], DOWN
   sub sp, 2
   mov word ptr [bp-20], RIGHT
   sub sp, 2
   mov word ptr [bp-22], BACKSPACE
   sub sp, 2
   mov word ptr [bp-24], ESC_
   ;word key
   sub sp, 2 ;[bp-26]:key dw
   ;int i, n, result = 0
   sub sp, 2 ;[bp-28]:i dw
   sub sp, 2 ;[bp-30]:result sw
   mov word ptr [bp-30], 0 ;result = 0
   ;n = 6
   push di
   push es
play_do:
   ;key = bioskey(0)
   mov ah, 0;
   int 16h
   ;if(key == key_map[i])
   mov word ptr [bp-26], ax
   mov word ptr [bp-28], 0 ;i = 0
play_do_loop:
   cmp word ptr [bp-28], 6 ;i < 6
   jae play_do_loop_end
   mov di, word ptr [bp-28]
   add di, di
   sub bp, di
   mov ax, word ptr [bp-14];[bp-di-14] ;key_map[i]
   add bp, di
   cmp word ptr [bp-26], ax ;key == key_map[i]
   je play_do_loop_end
   inc word ptr [bp-28] ;i++
   jmp play_do_loop
play_do_loop_end:
   cmp word ptr [bp-28], 6 
   jge play_do_loop_next
   ;result = (*go[i])();
   mov di, word ptr [bp-28] ;di = i
   add di, di ;di = 2i
   sub bp, di
   mov si, word ptr [bp-2] ;es:[di]->go[i]
   add bp, di
   call si ;call go[i]
   mov word ptr [bp-30], ax ;result = (*go[i])()
play_do_loop_next:
   cmp word ptr [bp-30], -1
   jne play_do_maybe_next
   jmp play_do_end
play_do_maybe_next:
   cmp word ptr [bp-30], 2
   jne play_do
play_do_end:   
   ;ax:return result
   mov ax, word ptr [bp-30]
   pop es 
   pop di 
   mov sp, bp
   pop bp
   ret
;
load_from_file:
   push bp
   mov bp, sp
   push ds
   ;fp = fopen(filename, "rb")
   mov ax, 3D00h
   mov dx, data
   mov ds, dx
   mov dx, word ptr [bp+4]
   int 21h
   mov ax, 0
   jc load_from_file_exit
   mov ax, 1
load_from_file_exit:
   pop ds
   pop bp
   ret
;
main:
   mov ax, data
   mov ds, ax 
   ;resize
   mov dx, offset dgroup:end_flag
   add dx, 100h ;加上psp长度100h
   add dx, 0Fh
   shr dx, 4
   mov ah, 4Ah
   mov bx, dx 
   int 21h
   ;blk_buf = malloc()
   mov ah, 48h
   ;用来保存人当前踩住的物体图像
   mov bx, ((4 + (030h/8+1)*4 * 024h) + 0Fh) / 10h; 分配1012字节
   int 21h     ; 内存分配, 或成功则CF=0且ax=段地址, 否则CF=1
   jc err_malloc
   shl eax, 16
   mov dword ptr blk_buf, eax
   ;
   call build_blk_info_from_file
   cmp ax, 0
   je err_blk 
   ;
   mov man_x, 0 ;defaule value for original map
   mov man_y, 0 ;
   mov man_flag, 0
   push offset box_filename
   ;if "box.sav" exists, returns 1
   ;else returns 0
   call load_from_file
   add sp, 2
   cmp ax, 0
   jne load_from_previous
   mov level, 1
   mov level_in_map, 1
   mov steps, 0
   ;pmap = (MAP*)load_map(level);
   push level
   call load_map
   add sp, 2
   shl eax, 16
   mov pmap, eax
   cmp pmap, 0
   je err_load
   ;blk_size_level = pmap->blk_size_level[level_in_map];
   mov si, level_in_map
   add si, si
   les di, dword ptr pmap 
   add di, si
   mov ax, word ptr es:[di]
   mov blk_size_level, ax
   jmp draw_map_loop
   ;
   ;特别声明，在复现游戏的过程中，发现保存游戏上一次退出的阶段并不是十分实用。
   ;在很多场景下，推箱子的残局是无法获胜的，最终还是要通过手动删除box.sav文件的方法，
   ;重新从第一关开始。
   ;因此，我对load_previous_info_from_file函数的细节做了修改。
   ;（也就是变成下面的load_from_previous代码块）
   ;box.sav还是按照参考代码的结构存储所有信息，
   ;使用C语言版本编译好的box.exe可以验证本汇编程序运行后生成的box.sav的正确性。
   ;但是读取的时候，我只取其中的level\blk_size_level信息，生成相应关卡的初始图像。
   ;删去了之后通过循环把box.sav中的ps->flag信息覆盖到pmap->中的过程。
load_from_previous:
;fp = fopen(filename, "rb")
   push bp
   mov bp, sp 
   sub sp, 2 ;[bp-2]:ps dw
   sub sp, 2 ;[bp-4]:fp dw
   sub sp, 2 ;[bp-6]:n dw
   ;
   mov ax, 3D00h
   mov dx, data
   mov ds, dx
   mov dx, offset box_filename
   int 21h
   mov word ptr [bp-4], ax
   ;ps = malloc(sizeof(SAVE))
   mov bx, type SAVE
   add bx, 0Fh
   shr bx, 4
   mov ah, 48h
   int 21h
   mov word ptr [bp-2], ax ;ps = 段地址
   jc err_malloc
   ;n=fread(ps, 1, sizeof(SAVE), fp)
   mov ah, 3Fh
   mov bx, word ptr [bp-4] ;fp
   mov cx, type SAVE
   mov dx, 0
   mov ds, word ptr [bp-2] ;ps
   int 21h
   mov word ptr [bp-6], ax ;n
   mov ax, data
   mov ds, ax
   ;fclose(fp)
   mov ah, 3Eh
   mov bx, word ptr [bp-4] ;fp
   int 21h 
   mov ax, type SAVE
   cmp word ptr [bp-6], ax
   jl err_load
   ;if ps->magic != 0x5742
   mov es, word ptr [bp-2]
   cmp word ptr es:[0], 5742h
   jne err_load
   ;level = ps->level;
   mov es, word ptr [bp-2]
   mov ax, word ptr es:[2]
   mov level, ax
   dec ax
   mov dx, 0
   mov si, 10
   div si
   inc dx
   mov word ptr level_in_map, dx
   mov es, word ptr [bp-2]
   mov ax, word ptr es:[4]
   mov steps, 0
   ;pmap = (MAP*)load_map(level);
   push level
   call load_map
   add sp, 2
   shl eax, 16
   mov pmap, eax
   ;if(pmap == NULL)
   cmp pmap, 0
   je err_load
   ;blk_size_level = pmap->blk_size_level[level_in_map];
   mov si, level_in_map
   add si, si 
   les di, dword ptr pmap 
   add di, si   
   mov ax, word ptr es:[di]
   mov blk_size_level, ax
   ;free(ps);
   mov ah, 49h
   mov es, word ptr [bp-2] ;ps
   int 21h
   mov ax, 1
   mov sp, bp 
   pop bp
;
draw_map_loop:
   push man_flag
   push man_y
   push man_x
   ;If man_x & man_y are not zero, then the above function will draw man 
   ;on the specified coordinates (man_x, man_y);
   ;If man_x & man_y are zero, then the above function will search man's 
   ;coordinates according to the man flag located at original map and 
   ;finally sets man_x, man_y and man_flag.   
   call DrawMap_countObj_SetManXyFlag
   add sp, 6
   mov back_available, 0 ;刚开始玩的时候不可以回退
   call play
   mov play_status, ax
   ;free(pmap)
   mov ah, 49h
   les di, dword ptr pmap
   int 21h
   mov pmap, 0
   cmp play_status, -1
   je draw_map_end
   inc level
   mov ax, level
   dec ax
   mov dx, 0
   mov si, 10
   div si
   inc dx
   mov level_in_map, dx
   mov steps, 0
   mov man_x, 0
   mov man_y, 0
   mov man_flag, 0
   push level
   call load_map
   add sp, 2
   shl eax, 16
   mov dword ptr pmap, eax
   cmp pmap, 0
   je err_load
   ;blk_size_level = pmap->blk_size_level[level_in_map];
   mov si, level_in_map
   add si, si
   les di, dword ptr pmap
   add di, si
   mov ax, word ptr es:[di]
   mov blk_size_level, ax
   cmp play_status, -1
   jne draw_map_loop
   ;text()
draw_map_end:
   ;切换到文本模式
   call text
   jmp exit
err_malloc:
   mov ah, 9
   mov dx, offset err_malloc_text
   int 21h
   jmp exit
err_blk:
   mov ah, 9
   mov dx, offset err_blk_text
   int 21h 
   jmp exit
err_load:
   mov ah, 9
   mov dx, offset err_load_text
   int 21h      
exit:
   mov ah, 4Ch
   int 21h
end_flag label byte
code ends
end main