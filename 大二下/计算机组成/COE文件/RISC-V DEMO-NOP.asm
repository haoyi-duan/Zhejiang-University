jal x0, start
add x0, x0, x0
add x0, x0, x0
add x0, x0, x0
add x0, x0, x0
add x0, x0, x0
add x0, x0, x0
add x0, x0, x0
start:
lw x5, 12(x0)
nop
nop
slt x6, x0, x5
nop
nop
add x7, x6, x6
nop
nop
add x28, x7, x6
add x14, x7, x7
nop
add x5, x28, x28
nop
nop
add x5, x5, x5
nop
nop
add x29, x5, x28
nop
nop
add x30, x29, x29
nop
nop
add x30, x30, x30
nop
nop
add x8, x30, x28
add x30, x30, x30
nop
nop
add x30, x30, x30
nop
nop
add x31, x30, x29
add x30, x30, x30
nop
nop
add x30, x30, x30
nop
nop
add x30, x30, x30
nop
nop
add x30, x30, x30
nop
nop
add x30, x30, x30
nop
nop
add x30, x30, x30
nop
nop
add x30, x30, x30
nop
nop
add x30, x30, x30
nop
nop
add x30, x30, x30
nop
nop
add x30, x30, x30
nop
nop
add x30, x30, x30
nop
nop
add x30, x30, x30
nop
nop
add x30, x30, x30
nop
nop
add x30, x30, x30
nop
nop
add x30, x30, x30
nop
nop
add x30, x30, x30
nop
nop
add x30, x30, x30
nop
nop
add x30, x30, x30
nop
nop
add x30, x30, x30
nop
nop
add x30, x30, x30
nop
nop
add x30, x30, x30
nop
nop
add x30, x30, x30
nop
nop
add x30, x30, x30
nop
nop
add x9, x30, x30
nop
nop
or x12, x9, x30
add x18, x9, x9
nop
nop
add x5, x18, x18
nop
nop
add x5, x5, x5
loop:
sub x13, x0, x6
sw x12, 4(x9)
lw x11, 0(x9)
nop
nop
add x11, x11, x11
nop
nop
add x11, x11, x11
nop
nop
sw x11, 0(x9)
add x21, x21, x6
nop
nop
sw x21 0(x18)
lw x22 20(x0)
loop2:
lw x11, 0(x9)
nop
nop
add x11, x11, x11
nop
nop
add x11, x11, x11
nop
nop
sw x11, 0(x9)
lw x11 0(x9)
nop
nop
and x24, x11, x5
add x22, x22, x6
nop
nop
beq x22, x0, C_init
nop
nop
nop
l_next:
lw x11, 0(x9)
add x23, x14, x14
nop
nop
add x25, x23, x23
nop
nop
add x23, x23, x25
nop
nop
and x24, x11, x23
nop
nop
beq x24, x0, L00
nop
nop
nop
beq x24, x23, L11
nop
nop
nop
add x23, x14, x14
nop
nop
beq x24, x23, L01
nop
nop
nop
sw x21, 0(x18)
jal x0, loop2
nop
nop
nop
L00:
beq x15, x13, L4
nop
nop
nop
jal x0, L3
nop
nop
nop
L4:
add x15, x13, x13
nop
nop
L3:
sw x15, 0(x18)
jal x0, loop2
nop
nop
L11:
lw x21, 96(x19)
nop
nop
sw x21, 0(x18)
jal x0, loop2
nop
nop
nop
L01:
lw x21, 32(x19)
nop
nop
sw x21, 0(x18)
jal x0, loop2
nop
nop
nop
C_init:
lw x22, 20(x0)
add x15, x15, x15
nop
nop
or x15, x15, x6
add x19, x19,, x14
nop
nop
and x19, x19, x14
and x19, x19, x8
add x21, x21, x6
nop
nop
beq x21, x13, L6
jal x0, L7
nop
nop
nop
L6:
add x21, x0, x14
nop
nop
add x21, x21, x6
L7:
lw x11, 0(x9)
nop
nop
add x24, x11, x11
nop
nop
add x24, x24, x24
nop
nop
sw x24, 0(x9)
sw x12, 4(x9)
jal x0, l_next
nop
nop
nop