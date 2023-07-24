`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:12:36 05/26/2014 
// Design Name: 
// Module Name:    RISC-V SCPU NINE Instruction 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module RSCPU9( input clk,
               input reset,                     //rst
               input Ready,                     //MIO_ready
               input [31:0]Datai, 
               output [31:0]Datao, 
               output [31:0]Addr, 
               output [31:0]PC, 
               input [31:0]INST,                //inst_in
               input [7:0]TNI, 
               output ALE, 
               output MIO, 
               output WR,
               input [6:0]Debug_addr,
               output [31:0]Debug_data
               );

wire [31:0]A, B, RS1DATA, WDATA; 
wire [4:0] Wt_addr;  
wire ALUSrc_B, ALUSrc_A;
wire [2:0] ALUC;                                    //ALU_Control
wire RegWrite;
wire [1:0] DatatoReg;                               //MemtoReg
//wire [1:0] Branch;                                  //Jump/Branch
wire Jump, Branch;
wire sign;
wire PCEN, zero;
//wire [1:0] RegDst;
wire [1:0] ImmSel;
wire jen;
wire blt;  
   RSCU9  	U1_1(.clk(clk), 
                 .OPcode(INST[6:2]), 
                 .Fun3(INST[14:12]), 
                 .Fun7(INST[30]),
                 .MIO_ready(Ready), 
                 .reset(reset), 
                 .zero(zero), 
                 .ALE(ALE), 
                 .blt(blt),
                 .sign(sign),
                 .ALUSrc_A(ALUSrc_A),
                 .ALUSrc_B(ALUSrc_B),
                 .jen(jen),
                 .ALUC(ALUC),                               //ALU_Control
                 .Jump(Jump),
                 .Branch(Branch),                           //Jump/Branch
                 .ImmSel(ImmSel),
                 .CPU_MIO(MIO), 
                 .DatatoReg(DatatoReg),                     //MemtoReg
                 .PCEN(PCEN), 
//                 .RegDst(RegDst), 
                 .RegWrite(RegWrite), 
                 .WR(WR));                                  //MemRW
                
wire[31:0]Debug_regs;					  
   RSDP9	 U1_2(.clk(clk),
                  .rst(reset), 
                  .sign(sign),
				  //.ALUSrc_A(ALUSrc_A), 
				  .ALUSrc_B(ALUSrc_B),
				  .ImmSel(ImmSel),
				  .ALUC(ALUC),                          //ALU_Control
				  .Jump(Jump),
				  .jen(jen),
				  .Branch(Branch),                      //Branch-Jump
                  .DatatoReg(DatatoReg),                //MemtoReg
                  .Data_in(Datai), 
                  .inst_field(INST), 
//                .RegDst(RegDst), 
                  //.PCEN(PCEN), 
                  .RegWrite(RegWrite),
				  .blt(blt),
                  .ALU_out(Addr),                       //res
                  .Data_out(Datao), 
                  .PC_out(PC), 
                  .overflow(), 
                  .zero(zero),
                  //.ALUA(A),
                  .ALUB(B),
                  .rs1_data(RS1DATA),
                  .Wt_data(WDATA),
			      .Debug_addr(Debug_addr),
                  .Debug_regs(Debug_regs)
                  );

                  
//DEBUG TEST:
wire [31:0] Test_signal;
	assign Debug_data = Debug_addr[5] ? Test_signal : Debug_regs;
	
    CPUTEST    U1_3(.PC(PC),
                     .INST(INST),
                     .RS1DATA(RS1DATA),
                     .Datai(Datai),
                     .Datao(Datao),
                     .Addr(Addr),
                     .A(A),
                     .B(B),
                     .WDATA(WDATA),
                     .ALUC(ALUC),
                     .DatatoReg(DatatoReg),
                     .ALUSrc_A(ALUSrc_A),
                     .ALUSrc_B(ALUSrc_B),
                     .WR(WR),
                     .RegWrite(RegWrite),
                     .Branch(Branch),
                     .Jump(Jump),
                    
                     .Debug_addr(Debug_addr[4:0]),
                     .Test_signal(Test_signal)    
                    ); 
                 
endmodule


