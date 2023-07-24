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
module  CPUTEST(input[31:0]PC,					//当前PC指针信号
                input[31:0]INST,				//当前读出指令
                input[31:0]RS1DATA,				//rs1寄存器读出数
                input[31:0]Datai,				//外部输入CPU数据
                input[31:0]Datao,				//CPU输出数据(对应rs2寄存器输出)
                input[31:0]Addr,				//CPU输出地址(对应ALU运算结果)
                input[31:0]A,					//ALU A端口输入数据
                input[31:0]B,					//ALU B端口输入数据
                input[31:0]WDATA,				//寄存器写入数据
                input [2:0]ALUC,				//ALU操作功能编码
                input [1:0]DatatoReg,			//寄存器写通路控制
                input ALUSrc_A,					//寄存器A通道控制 
                input ALUSrc_B,					//寄存器B通道控制
                input WR,						//存储器写信号
                input RegWrite,					//寄存器写信号
                input Branch,					//SB转移标志
                input Jump,						//UB转移标志
                
                input[4:0]Debug_addr,			//采样时序地址
               output reg [31:0] Test_signal	//采样输出数据
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
