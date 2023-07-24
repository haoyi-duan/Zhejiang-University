// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.2 (win64) Build 2258646 Thu Jun 14 20:03:12 MDT 2018
// Date        : Sat May 22 21:28:42 2021
// Host        : ZJU-DXPS running 64-bit major release  (build 9200)
// Command     : write_verilog -mode synth_stub D:/FPGA_work/ORGV20VI/EdfIP/ID_Stage.edf.v
// Design      : ID_Stage
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7k160tffg676-2L
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module ID_Stage(clk, rst, EN, flush, ID_IR, ID_PCurrent, ALUSrc_A, 
  ALUSrc_B, RegWrite, WB_RegWrite, Jump, Branch, WR, MIO, Sign, ALUC, ImmSel, DatatoReg, WB_rd, Wt_data, 
  EX_IR, EX_PCurrent, EX_ALUSrc_A, EX_ALUSrc_B, EX_Jump, EX_Branch, EX_RegWrite, EX_WR, EX_MIO, 
  EX_Sign, EX_rd, EX_ALUC, EX_DatatoReg, EX_A, EX_B, EX_Imm32, rs1_data, rs2_data, Imm32, Debug_addr, 
  Debug_regs)
/* synthesis syn_black_box black_box_pad_pin="clk,rst,EN,flush,ID_IR[31:0],ID_PCurrent[31:0],ALUSrc_A,ALUSrc_B,RegWrite,WB_RegWrite,Jump,Branch,WR,MIO,Sign,ALUC[2:0],ImmSel[1:0],DatatoReg[1:0],WB_rd[4:0],Wt_data[31:0],EX_IR[31:0],EX_PCurrent[31:0],EX_ALUSrc_A,EX_ALUSrc_B,EX_Jump,EX_Branch,EX_RegWrite,EX_WR,EX_MIO,EX_Sign,EX_rd[4:0],EX_ALUC[2:0],EX_DatatoReg[1:0],EX_A[31:0],EX_B[31:0],EX_Imm32[31:0],rs1_data[31:0],rs2_data[31:0],Imm32[31:0],Debug_addr[4:0],Debug_regs[31:0]" */;
  input clk;
  input rst;
  input EN;
  input flush;
  input [31:0]ID_IR;
  input [31:0]ID_PCurrent;
  input ALUSrc_A;
  input ALUSrc_B;
  input RegWrite;
  input WB_RegWrite;
  input Jump;
  input Branch;
  input WR;
  input MIO;
  input Sign;
  input [2:0]ALUC;
  input [1:0]ImmSel;
  input [1:0]DatatoReg;
  input [4:0]WB_rd;
  input [31:0]Wt_data;
  output [31:0]EX_IR;
  output [31:0]EX_PCurrent;
  output EX_ALUSrc_A;
  output EX_ALUSrc_B;
  output EX_Jump;
  output EX_Branch;
  output EX_RegWrite;
  output EX_WR;
  output EX_MIO;
  output EX_Sign;
  output [4:0]EX_rd;
  output [2:0]EX_ALUC;
  output [1:0]EX_DatatoReg;
  output [31:0]EX_A;
  output [31:0]EX_B;
  output [31:0]EX_Imm32;
  output [31:0]rs1_data;
  output [31:0]rs2_data;
  output [31:0]Imm32;
  input [4:0]Debug_addr;
  output [31:0]Debug_regs;
endmodule
