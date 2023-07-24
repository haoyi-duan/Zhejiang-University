// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.2 (win64) Build 2258646 Thu Jun 14 20:03:12 MDT 2018
// Date        : Sat May 22 21:31:24 2021
// Host        : ZJU-DXPS running 64-bit major release  (build 9200)
// Command     : write_verilog -mode synth_stub D:/FPGA_work/ORGV20VI/EdfIP/EXE_Stage.edf.v
// Design      : EXE_Stage
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7k160tffg676-2L
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module EXE_Stage(clk, rst, EN, flush, EX_IR, EX_PCurrent, EX_Imm32, 
  EX_A, EX_B, EX_ALUSrc_A, EX_ALUSrc_B, EX_RegWrite, EX_Jump, EX_Branch, EX_rd, EX_ALUC, 
  EX_DatatoReg, EX_WR, EX_MIO, EX_Sign, MEM_PCurrent, MEM_IR, MEM_ALUO, MEM_Datao, MEM_Target, 
  MEM_rd, MEM_DatatoReg, MEM_zero, MEM_RegWrite, MEM_Jump, MEM_Branch, MEM_WR, MEM_MIO, ALUA, ALUB)
/* synthesis syn_black_box black_box_pad_pin="clk,rst,EN,flush,EX_IR[31:0],EX_PCurrent[31:0],EX_Imm32[31:0],EX_A[31:0],EX_B[31:0],EX_ALUSrc_A,EX_ALUSrc_B,EX_RegWrite,EX_Jump,EX_Branch,EX_rd[4:0],EX_ALUC[2:0],EX_DatatoReg[1:0],EX_WR,EX_MIO,EX_Sign,MEM_PCurrent[31:0],MEM_IR[31:0],MEM_ALUO[31:0],MEM_Datao[31:0],MEM_Target[31:0],MEM_rd[4:0],MEM_DatatoReg[1:0],MEM_zero,MEM_RegWrite,MEM_Jump,MEM_Branch,MEM_WR,MEM_MIO,ALUA[31:0],ALUB[31:0]" */;
  input clk;
  input rst;
  input EN;
  input flush;
  input [31:0]EX_IR;
  input [31:0]EX_PCurrent;
  input [31:0]EX_Imm32;
  input [31:0]EX_A;
  input [31:0]EX_B;
  input EX_ALUSrc_A;
  input EX_ALUSrc_B;
  input EX_RegWrite;
  input EX_Jump;
  input EX_Branch;
  input [4:0]EX_rd;
  input [2:0]EX_ALUC;
  input [1:0]EX_DatatoReg;
  input EX_WR;
  input EX_MIO;
  input EX_Sign;
  output [31:0]MEM_PCurrent;
  output [31:0]MEM_IR;
  output [31:0]MEM_ALUO;
  output [31:0]MEM_Datao;
  output [31:0]MEM_Target;
  output [4:0]MEM_rd;
  output [1:0]MEM_DatatoReg;
  output MEM_zero;
  output MEM_RegWrite;
  output MEM_Jump;
  output MEM_Branch;
  output MEM_WR;
  output MEM_MIO;
  output [31:0]ALUA;
  output [31:0]ALUB;
endmodule
