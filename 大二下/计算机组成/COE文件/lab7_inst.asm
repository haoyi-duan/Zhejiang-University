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
sw x6, 0x4(x3) # �������˿�:F0000004���ͼ�������r6=F8000000
lw x5, 0(x3) # ��GPIO�˿�F0000000״̬:{oux8��oux9��oux10��D28-D20��LED7-LE
add x5, x5, x5 # ����
add x5, x5, x5 # ����2λ��SW��LED���룬ͬʱD1D0��00��ѡ�������ͨ��0
sw x5, 0(x3) # r5�����GPIO�˿�F0000000�����ü�����ͨ��counter_set=00�˿�
addi x9, x9, 1 # r9=r9+1
sw x9, 0(x4) # r9��r4=E0000000�߶���˿�
lw x13, 0x14(zero) # ȡ�洢��20��ԪԤ��������r13,���������ʱ����

loop2:
lw x5, 0(x3) # ��GPIO�˿�F0000000״̬:{oux8��oux9��oux10��D28-D20��LED7-LE
add x5, x5, x5
add x5, x5, x5 # ����2λ��SW��LED���룬ͬʱD1D0��00��ѡ�������ͨ��0
sw x5, 0(x3) # r5�����GPIO�˿�F0000000��������ͨ��counter_set=00�˿ڲ���

lw x5, 0(x3) # �ٶ�GPIO�˿�F0000000״̬
and x11, x5,x8 # ȡ���λ=oux8����������λ��r11
#  bne x11,x8,l_next # oux8����=0,Counterͨ��0���,ת��������ʼ��,�޸�7������ʾ
addi x13, x13, 1 # ���������ʱ
bne x13, zero,l_next
jal C_init # �������r13=0,ת��������ʼ��,�޸�7������ʾ:C_init

l_next: # �ж�7������ʾģʽ��SW[4:3]����
lw x5, 0(x3) # �ٶ�GPIO�˿�F0000000����SW״̬
addi x18, zero, 0x0008 # r18=00000008
add x22, x18, x18 # r22=00000010
add x18, x18, x22 # r18=00000018(00011000)
and x11, x5, x18 # ȡSW[4:3]
beq x11, zero, L00 # SW[4:3]=00,7����ʾ"��"ѭ����λ��L00��SW0=0
beq x11, x18, L11 # SW[4:3]=11,7����ʾ��ʾ�߶�ͼ�Σ�L11��SW0=0
addi x18, zero, 0x0008 # r18=8
beq x11, x18, L01 # SW[4:3]=01,�߶���ʾԤ�����֣�L01��SW0=1
sw x9, 0(x4) # SW[4:3]=10����ʾr9��SW0=1
j loop2

L00:
bne x10, x7, L3 # r10=ffffffff,ת��L4

L4:
not x10, zero # r10=ffffffff
add x10, x10, x10 # r10=fffffffe

L3:
sw x10, 0(x4) # SW[4:3]=00,7����ʾ����λ����ʾ
j loop2

L11:
lw x9, 0x60(x17) # SW[4:3]=11�����ڴ�ȡԤ���߶�ͼ��
sw x9, 0(x4) # SW[4:3]=11����ʾ�߶�ͼ��
j loop2

L01:
lw x9, 0x20(x17) # SW[4:3]=01�����ڴ�ȡԤ������
sw x9, 0(x4) # SW[4:3]=01,�߶���ʾԤ������
j loop2

C_init:
lw x13, 0x14(zero) # ȡ���������ʱ��ʼ������
add x10, x10, x10 # r10=fffffffc��7��ͼ�ε�����
ori x10, x10, 1 # r10ĩλ��1����Ӧ���Ͻǲ���ʾ
addi x17, x17, 4 # r17=00000004��LEDͼ�ηô��ַ+4
and x17, x17, x20 # r17=000000XX�����ε�ַ��λ��ֻȡ6λ
add x9, x9, x2 # r9+1
bne x9, x7, L7 # ��r9=ffffffff,����r9=5

addi x9, x9, 5 # ����r9=5

L7:
lw x5, 0(x3) # ��GPIO�˿�F0000000״̬
add x11, x5, x5
add x11, x11, x11 # ����2λ��SW��LED���룬ͬʱD1D0��00��ѡ�������ͨ��0
sw x11, 0(x3)  # r5�����GPIO�˿�F0000000��������ͨ��counter_set=00�˿ڲ���
sw x6, 4(x3) # �������˿�:F0000004���ͼ�������r6=F8000000
jr x1 # j l_next
