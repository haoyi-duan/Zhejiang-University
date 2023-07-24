`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/03/21 14:20:23
// Design Name: 
// Module Name: MEMTEST
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module  CPUTEST(input[31:0]PC_IF,               //IF������ǰȡָPC��ַָ��
                input[31:0]PC_ID,               //ID������ǰ����ָ��PC��ַָ��
                input[31:0]PC_EXE,              //EXE������ǰִ��ALUָ��PC��ַָ��
                input[31:0]PC_MEM,              //MEM������ǰ���ʴ洢����ת��ָ��PC��ַָ��
                input[31:0]PC_WB,               //WB������ǰд�Ĵ���ָ��PC��ַָ��
                input[31:0]PC_next_IF,          //IF��next PC,����
                input[31:0]PCJump,              //UJ/jalr/Bת��Ŀ���ַ
                input[31:0]inst_IF,             //IF������ǰȡ��ָ��Inst
                input[31:0]inst_ID,             //ID������ǰ����ָ��ID_IR
                input[31:0]inst_EXE,            //EXE������ǰ����ִ��ALU����ָ�������
                input[31:0]inst_MEM,            //MEM������ǰ���ڷ��ʴ洢��ָ�������
                input[31:0]inst_WB,             //WB������ǰ����дĿ�ļĴ�������ָ�������
                
                input[31:0]RS1DATA,             //rs1�Ĵ���A������(ID��)
                input[31:0]RS2DATA,             //rs2�Ĵ���B������(ID��)
                input[31:0]Imm32,               //ImmGen���������(ID��)
                input[31:0]Datai,               //���ݴ洢����IO����CPU����(MEM��)
                input[31:0]Datao,               //CPU���MIO����(rs2�����Ĵ�����)
                input[31:0]Addr,                //CPU���MIO��ַ(ALU�������ALUO������MEM��)
                input[31:0]A,                   //ALU A���룬�Ĵ���A�������䵽EXE��
                input[31:0]B,                   //ALU B���룬�Ĵ���B�������䵽EXE��
                input[31:0]ALU_out,             //ALU�������(EXE_ALUO)
                input[31:0]WDATA,               //дĿ�ļĴ�������(WB������)
                input [2:0]ALUC,                //ALU��������(EXEʹ��)
                input [1:0]DatatoReg,           //Ŀ�ļĴ���д����ѡ��(WB��ʹ��)
                input [1:0]PCSource,            //ָ���ַѡ���ź�(IF��MEM������)
                input [1:0]ImmSel,              //������ѡ�����(ID��ʹ��)
                input PCEN,                     //PC�Ĵ���ʹ��
                input Branch,                   //��ָ֧���������(MEM��)
                input ALUSrc_A,                 //ALU Aͨ����������ѡ��(EXEʹ��)
                input ALUSrc_B,                 //ALU Bͨ����������ѡ��(EXEʹ��)
                input WR,                       //�洢��д�ź�(MEMʹ��)
                input MIO,                      //MIO������־�ź�
                input RegWrite,                 //Ŀ�ļĴ���д�ź�(WBʹ��)
                input data_hazard,              //���ݾ����ȴ�������
                input control_hazard,           //���ƾ���������ȴ�������
                input[4:0]Debug_addr,           //���Զ�λ�ź�
                output reg [31:0] Test_signal   //���ԡ������ź�
                );

    always @* begin
        case (Debug_addr[4:0])
            0: Test_signal = PC_IF;
            1: Test_signal = inst_IF;
            2: Test_signal = RS1DATA;
            3: Test_signal = RS2DATA;

            4: Test_signal = PC_ID;      
            5: Test_signal = inst_ID;
            6: Test_signal = inst_ID[19:15];    // rs1 address
            7: Test_signal = inst_ID[24:20];    // rs2 address

            8: Test_signal = PC_EXE;      
            9: Test_signal = inst_EXE;    
            10: Test_signal = 32'hAA55AA55;
            11: Test_signal = PCJump;

            12: Test_signal = PC_MEM; 
            13: Test_signal = inst_MEM;   
            14: Test_signal = {15'h0, Branch, 7'h0, PCEN, 6'h0, PCSource};  
            15: Test_signal = {15'h0, data_hazard, 15'h0, control_hazard}; 

            16: Test_signal = PC_WB;      
            17: Test_signal = inst_WB;        
            18: Test_signal = {14'h0, ImmSel, 7'h0, ALUSrc_A, 7'h0, ALUSrc_B};
            19: Test_signal = PC_next_IF;
                           
            20: Test_signal = A;
            21: Test_signal = ALU_out;
            22: Test_signal = Addr;
            23: Test_signal = ALUC; 

            24: Test_signal = B;
            25: Test_signal = WDATA;
            26: Test_signal = Datai;
            27: Test_signal = {15'h0, WR, 15'h0, MIO};

            28: Test_signal = Imm32;
            29: Test_signal = inst_WB[11:7]; // rd address
            30: Test_signal = Datao;
            31: Test_signal = {15'h0, RegWrite, 14'h0, DatatoReg};
            
            default: Test_signal = 32'hAA55_AA55;
        endcase
    end
                          
endmodule