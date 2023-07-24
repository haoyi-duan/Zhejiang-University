// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.2 (win64) Build 2258646 Thu Jun 14 20:03:12 MDT 2018
// Date        : Sat May 22 21:34:23 2021
// Host        : ZJU-DXPS running 64-bit major release  (build 9200)
// Command     : write_verilog -mode synth_stub D:/FPGA_work/ORGV20VI/EdfIP/MEM_Stage.edf.v
// Design      : MEM_Stage
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7k160tffg676-2L
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module MEM_Stage(clk, rst, EN, MEM_IR, MEM_PCurrent, Datai, MEM_Datao, 
  MEM_ALUO, MEM_WR, MEM_zero, MEM_Branch, MEM_RegWrite, MEM_rd, MEM_DatatoReg, WB_PCurrent, WB_IR, 
  Addr, MWR, Btaken, WB_RegWrite, WB_DatatoReg, WB_rd, WB_ALUO, WB_MDR, Datao)
/* synthesis syn_black_box black_box_pad_pin="clk,rst,EN,MEM_IR[31:0],MEM_PCurrent[31:0],Datai[31:0],MEM_Datao[31:0],MEM_ALUO[31:0],MEM_WR,MEM_zero,MEM_Branch,MEM_RegWrite,MEM_rd[4:0],MEM_DatatoReg[1:0],WB_PCurrent[31:0],WB_IR[31:0],Addr[31:0],MWR,Btaken,WB_RegWrite,WB_DatatoReg[1:0],WB_rd[4:0],WB_ALUO[31:0],WB_MDR[31:0],Datao[31:0]" */;
  input clk;
  input rst;
  input EN;
  input [31:0]MEM_IR;
  input [31:0]MEM_PCurrent;
  input [31:0]Datai;
  input [31:0]MEM_Datao;
  input [31:0]MEM_ALUO;
  input MEM_WR;
  input MEM_zero;
  input MEM_Branch;
  input MEM_RegWrite;
  input [4:0]MEM_rd;
  input [1:0]MEM_DatatoReg;
  output [31:0]WB_PCurrent;
  output [31:0]WB_IR;
  output [31:0]Addr;
  output MWR;
  output Btaken;
  output WB_RegWrite;
  output [1:0]WB_DatatoReg;
  output [4:0]WB_rd;
  output [31:0]WB_ALUO;
  output [31:0]WB_MDR;
  output [31:0]Datao;
endmodule
