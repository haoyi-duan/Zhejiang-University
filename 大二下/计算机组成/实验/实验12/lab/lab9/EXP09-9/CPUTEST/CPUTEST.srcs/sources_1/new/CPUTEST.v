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
module  CPUTEST(input[31:0]PC,					//��ǰPCָ���ź�
                input[31:0]INST,				//��ǰ����ָ��
                input[31:0]RS1DATA,				//rs1�Ĵ���������
                input[31:0]Datai,				//�ⲿ����CPU����
                input[31:0]Datao,				//CPU�������(��Ӧrs2�Ĵ������)
                input[31:0]Addr,				//CPU�����ַ(��ӦALU������)
                input[31:0]A,					//ALU A�˿���������
                input[31:0]B,					//ALU B�˿���������
                input[31:0]WDATA,				//�Ĵ���д������
                input [2:0]ALUC,				//ALU�������ܱ���
                input [1:0]DatatoReg,			//�Ĵ���дͨ·����
                input ALUSrc_A,					//�Ĵ���Aͨ������ 
                input ALUSrc_B,					//�Ĵ���Bͨ������
                input WR,						//�洢��д�ź�
                input RegWrite,					//�Ĵ���д�ź�
                input Branch,					//SBת�Ʊ�־
                input Jump,						//UBת�Ʊ�־
                
                input[4:0]Debug_addr,			//����ʱ���ַ
               output reg [31:0] Test_signal	//�����������
                );
	
	always @* begin
        case (Debug_addr[4:0])
            0: Test_signal = PC;
            1: Test_signal = INST;
            2: Test_signal = {{20{INST[31]}},INST[31:20]};             	 //imm_12
            3: Test_signal = {{{11{INST[31]}},INST[31],INST[19:12],INST[20],INST[30:21],1'b0}}; 	        //UJimm			

            4: Test_signal = { {27'b0, INST[19:15]}};                   //rs1	
            5: Test_signal = RS1DATA;		                            //rs1_data
            6: Test_signal = {{20{INST[31]}}, INST[31:25], INST[11:7]}; //Simm_12          
            7: Test_signal = {INST[31:12], 12'h0};                      //LU_imm 			                    

            8: Test_signal = {27'b0, INST[24:20]};                      //rs2
            9: Test_signal =  Datao;		                              //Rs2_data
            10: Test_signal = {{19{INST[31]}}, INST[31], INST[7], INST[30:25], INST[11:8],1'b0};//SB_imm            
            11: Test_signal = {7'h0,WR, 7'h0,RegWrite,13'h0,ALUC};      // control signal

            12: Test_signal = {27'b0, INST[11:7]};                      //rd A;
            13: Test_signal = WDATA;                                    //Write:rd-Data
            14: Test_signal = Datai;			                         //MIO to CPU
            15: Test_signal = {7'h0,Branch, 7'h0,Jump, 14'b0, DatatoReg};

            16: Test_signal = A;
            17: Test_signal = Addr;                                    //ALU_out
            18: Test_signal = Datai;			                         //Data to CPU    {31'b0, WR};
            19: Test_signal = {27'b0, INST[11:7]};     		           //Wt
                           
            20: Test_signal = B;
            21: Test_signal = Addr;			                           //CPU Addr
            22: Test_signal = Datao;
            23: Test_signal =WDATA; 

            24: Test_signal = {7'b0, ALUSrc_A, 7'b0, ALUSrc_B, 14'b0, DatatoReg};
            default: Test_signal = 32'hAA55_AA55;
        endcase
    end
						  
endmodule
