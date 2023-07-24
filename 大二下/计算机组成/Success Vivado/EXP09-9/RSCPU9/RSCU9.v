// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.2 (win64) Build 2258646 Thu Jun 14 20:03:12 MDT 2018
// Date        : Sat Mar 20 12:58:53 2021
// Host        : ZJU-DXPS running 64-bit major release  (build 9200)
// Command     : write_verilog -mode synth_stub D:/FPGA_work/ORGV20VI/EdfIP/RSCU9.v
// Design      : RSCU9
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7k160tffg676-2L
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module RSCU9(clk, reset, OPcode, Fun3, Fun7, MIO_ready, zero, 
  ALUSrc_A, ALUSrc_B, ImmSel, DatatoReg, PCEN, Jump, Branch, RegWrite, WR, ALUC, CPU_MIO, ALE)
/* synthesis syn_black_box black_box_pad_pin="clk,reset,OPcode[4:0],Fun3[2:0],Fun7,MIO_ready,zero,ALUSrc_A,ALUSrc_B,ImmSel[1:0],DatatoReg[1:0],PCEN,Jump,Branch,RegWrite,WR,ALUC[2:0],CPU_MIO,ALE" */;
  input clk;
  input reset;
  input [4:0]OPcode;
  input [2:0]Fun3;
  input Fun7;
  input MIO_ready;
  input zero;
  output ALUSrc_A;
  output ALUSrc_B;
  output [1:0]ImmSel;
  output [1:0]DatatoReg;
  output PCEN;
  output Jump;
  output Branch;
  output RegWrite;
  output WR;
  output [2:0]ALUC;
  output CPU_MIO;
  output ALE;
endmodule
