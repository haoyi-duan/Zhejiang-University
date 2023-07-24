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
module  CPUTEST(input[31:0]PC_IF,               //IF级：当前取指PC地址指针
                input[31:0]PC_ID,               //ID级：当前译码指令PC地址指针
                input[31:0]PC_EXE,              //EXE级：当前执行ALU指令PC地址指针
                input[31:0]PC_MEM,              //MEM级：当前访问存储器或转移指令PC地址指针
                input[31:0]PC_WB,               //WB级：当前写寄存器指令PC地址指针
                input[31:0]PC_next_IF,          //IF级next PC,保留
                input[31:0]PCJump,              //UJ/jalr/B转移目标地址
                input[31:0]inst_IF,             //IF级：当前取入指令Inst
                input[31:0]inst_ID,             //ID级：当前译码指令ID_IR
                input[31:0]inst_EXE,            //EXE级：当前正在执行ALU操作指令，测试用
                input[31:0]inst_MEM,            //MEM级：当前正在访问存储器指令，测试用
                input[31:0]inst_WB,             //WB级：当前正在写目的寄存器操作指令，测试用
                
                input[31:0]RS1DATA,             //rs1寄存器A读出数(ID级)
                input[31:0]RS2DATA,             //rs2寄存器B读出数(ID级)
                input[31:0]Imm32,               //ImmGen输出立即数(ID级)
                input[31:0]Datai,               //数据存储器或IO输入CPU数据(MEM级)
                input[31:0]Datao,               //CPU输出MIO数据(rs2读出寄存器数)
                input[31:0]Addr,                //CPU输出MIO地址(ALU计算输出ALUO传输至MEM级)
                input[31:0]A,                   //ALU A输入，寄存器A读出传输到EXE级
                input[31:0]B,                   //ALU B输入，寄存器B读出传输到EXE级
                input[31:0]ALU_out,             //ALU计算输出(EXE_ALUO)
                input[31:0]WDATA,               //写目的寄存器数据(WB级生成)
                input [2:0]ALUC,                //ALU操作控制(EXE使用)
                input [1:0]DatatoReg,           //目的寄存器写数据选择(WB级使用)
                input [1:0]PCSource,            //指令地址选择信号(IF和MEM级生成)
                input [1:0]ImmSel,              //立即数选择控制(ID级使用)
                input PCEN,                     //PC寄存器使能
                input Branch,                   //分支指令译码输出(MEM级)
                input ALUSrc_A,                 //ALU A通道输入数据选择(EXE使用)
                input ALUSrc_B,                 //ALU B通道输入数据选择(EXE使用)
                input WR,                       //存储器写信号(MEM使用)
                input MIO,                      //MIO操作标志信号
                input RegWrite,                 //目的寄存器写信号(WB使用)
                input data_hazard,              //数据竞争等待，保留
                input control_hazard,           //控制竞争清除并等待，保留
                input[4:0]Debug_addr,           //测试定位信号
                output reg [31:0] Test_signal   //测试、调试信号
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