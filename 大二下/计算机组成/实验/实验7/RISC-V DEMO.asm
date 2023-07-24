jal x0, 32
add x0, x0, x0
add x0, x0, x0
add x0, x0, x0
add x0, x0, x0
add x0, x0, x0
add x0, x0, x0
add x0, x0, x0
start:
lw x5, 12(x0)
slt x6, x0, x5
add x7, x6, x6
add x28, x7, x6
add x14, x7, x7
add x5, x28, x28
add x5, x5, x5
add x29, x5, x28
add x30, x29, x29
add x30, x30, x30
add x8, x30, x28
add x30, x30, x30
add x30, x30, x30
add x31, x30, x29
add x30, x30, x30
add x30, x30, x30
add x30, x30, x30
add x30, x30, x30
add x30, x30, x30
add x30, x30, x30
add x30, x30, x30
add x30, x30, x30
add x30, x30, x30
add x30, x30, x30
add x30, x30, x30
add x30, x30, x30
add x30, x30, x30
add x30, x30, x30
add x30, x30, x30
add x30, x30, x30
add x30, x30, x30
add x30, x30, x30
add x30, x30, x30
add x30, x30, x30
add x30, x30, x30
add x30, x30, x30
add x30, x30, x30
add x30, x30, x30
add x30, x30, x30
add x30, x30, x30
add x30, x30, x30
add x30, x30, x30
add x30, x30, x30
add x9, x30, x30
or x12, x9, x30
add x18, x9, x9
add x5, x18, x18
add x5, x5, x5
loop:
sub x13, x0, x6
sw x12, 4(x9)
lw x11, 0(x9)
add x11, x11, x11
add x11, x11, x11
sw x11, 0(x9)
add x21, x21, x6
sw x21 0(x16)
lw x22 20(x0)
loop2:
lw x11, 0(x9)
add x11, x11, x11
add x11, x11, x11
sw x11, 0(x9)
and x24, x11, x5
add x22, x22, x6
beq x22, x0, 92
l_next:
lw x11, 0(x9)
add x23, x14, x14
add x25, x23, x23
add x23, x23, x25
and x24, x11, x23
beq x24, x0, 24
beq x24, x23, 40
add x23, x14, x14
beq x24, x23, 44
sw x21, 0(xx18)
jal x0, -72
L00:
beq x15, x13, 8
jal x0, 8
L4:
add x15, x13, x13
L3:
sw x15, 0(x18)
jal x0, -92
L11:
lw x21, 96(x19)
sw x21, 0(x18)
jal x0, -104
L01:
lw x21, 32(x19)
sw x21, 0(x18)
jal x0, -116
C_init:
lw x22, 20(x0)
add x15, x15, x15
or x15, x15, x6
add x19, x19,, x14
and x19, x19, x14
and x19, x19, x8
add x21, x21, x6
beq x21, x13, 8
jal x0, 12
L6:
add x21, x0, x14
add x21, x21, x6
L7:
lw x11, 0(x9)
add x24, x11, x11
add x24, x24, x24
sw x24, 0(x9)
sw x12, 4(x9)
jal x0,, -148
