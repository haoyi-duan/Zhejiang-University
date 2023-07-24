# baseAddr 0000
j start # 0
add zero, zero, zero # 4
add zero, zero, zero # 8
add zero, zero, zero # C
add zero, zero, zero # 10
add zero, zero, zero # 14
add zero, zero, zero # 18
add zero, zero, zero # 1C

start:
lui x3, 0xf0000 # r3=F0000000
lui x4, 0xe0000 # r4=E0000000
lui x8, 0x80000 # r8=80000000

addi x20, zero, 0x003f # r20=0000003F
lui x6, 0xf8000 # r6=F8000000

loop:
not x7, zero # r1=FFFFFFFF
sltu x2, zero, x7 # r2=00000001
addi x10, x7, -1 # r10=FFFFFFFE

loop1:
sw x6, 0x4(x3) # 计数器端口:F0000004，送计数常数r6=F8000000
lw x5, 0(x3) # 读GPIO端口F0000000状态:{oux8，oux9，oux10，D28-D20，LED7-LE
add x5, x5, x5 # 左移
add x5, x5, x5 # 左移2位将SW与LED对齐，同时D1D0置00，选择计数器通道0
sw x5, 0(x3) # r5输出到GPIO端口F0000000，设置计数器通道counter_set=00端口
addi x9, x9, 1 # r9=r9+1
sw x9, 0(x4) # r9送r4=E0000000七段码端口
lw x13, 0x14(zero) # 取存储器20单元预存数据至r13,程序计数延时常数

loop2:
lw x5, 0(x3) # 读GPIO端口F0000000状态:{oux8，oux9，oux10，D28-D20，LED7-LE
add x5, x5, x5
add x5, x5, x5 # 左移2位将SW与LED对齐，同时D1D0置00，选择计数器通道0
sw x5, 0(x3) # r5输出到GPIO端口F0000000，计数器通道counter_set=00端口不变

lw x5, 0(x3) # 再读GPIO端口F0000000状态
and x11, x5,x8 # 取最高位=oux8，屏蔽其余位送r11
#  bne x11,x8,l_next # oux8计数=0,Counter通道0溢出,转计数器初始化,修改7段码显示
addi x13, x13, 1 # 程序计数延时
bne x13, zero,l_next
jal C_init # 程序计数r13=0,转计数器初始化,修改7段码显示:C_init

l_next: # 判断7段码显示模式：SW[4:3]控制
lw x5, 0(x3) # 再读GPIO端口F0000000开关SW状态
addi x18, zero, 0x0008 # r18=00000008
add x22, x18, x18 # r22=00000010
add x18, x18, x22 # r18=00000018(00011000)
and x11, x5, x18 # 取SW[4:3]
beq x11, zero, L00 # SW[4:3]=00,7段显示"点"循环移位：L00，SW0=0
beq x11, x18, L11 # SW[4:3]=11,7段显示显示七段图形：L11，SW0=0
addi x18, zero, 0x0008 # r18=8
beq x11, x18, L01 # SW[4:3]=01,七段显示预置数字，L01，SW0=1
sw x9, 0(x4) # SW[4:3]=10，显示r9，SW0=1
j loop2

L00:
bne x10, x7, L3 # r10=ffffffff,转移L4

L4:
not x10, zero # r10=ffffffff
add x10, x10, x10 # r10=fffffffe

L3:
sw x10, 0(x4) # SW[4:3]=00,7段显示点移位后显示
j loop2

L11:
lw x9, 0x60(x17) # SW[4:3]=11，从内存取预存七段图形
sw x9, 0(x4) # SW[4:3]=11，显示七段图形
j loop2

L01:
lw x9, 0x20(x17) # SW[4:3]=01，从内存取预存数字
sw x9, 0(x4) # SW[4:3]=01,七段显示预置数字
j loop2

C_init:
lw x13, 0x14(zero) # 取程序计数延时初始化常数
add x10, x10, x10 # r10=fffffffc，7段图形点左移
ori x10, x10, 1 # r10末位置1，对应右上角不显示
addi x17, x17, 4 # r17=00000004，LED图形访存地址+4
and x17, x17, x20 # r17=000000XX，屏蔽地址高位，只取6位
add x9, x9, x2 # r9+1
bne x9, x7, L7 # 若r9=ffffffff,重置r9=5

addi x9, x9, 5 # 重置r9=5

L7:
lw x5, 0(x3) # 读GPIO端口F0000000状态
add x11, x5, x5
add x11, x11, x11 # 左移2位将SW与LED对齐，同时D1D0置00，选择计数器通道0
sw x11, 0(x3)  # r5输出到GPIO端口F0000000，计数器通道counter_set=00端口不变
sw x6, 4(x3) # 计数器端口:F0000004，送计数常数r6=F8000000
jr x1 # j l_next
