// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.2 (win64) Build 2258646 Thu Jun 14 20:03:12 MDT 2018
// Date        : Sat Mar 20 13:04:54 2021
// Host        : ZJU-DXPS running 64-bit major release  (build 9200)
// Command     : write_verilog -mode synth_stub D:/FPGA_work/ORGV20VI/EdfIP/RSDP9.v
// Design      : RSDP9
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7k160tffg676-2L
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module RSDP9(clk, rst, inst_field, Data_in, ALUSrc_A, ALUSrc_B, 
  ALUC, ImmSel, DatatoReg, PCEN, Jump, Branch, RegWrite, Sign, PCOUT, Data_out, ALU_out, overflow, zero, 
  rs1_data, Wt_data, ALUA, ALUB, Debug_addr, Debug_regs)
/* synthesis syn_black_box black_box_pad_pin="clk,rst,inst_field[31:0],Data_in[31:0],ALUSrc_A,ALUSrc_B,ALUC[2:0],ImmSel[1:0],DatatoReg[1:0],PCEN,Jump,Branch,RegWrite,Sign,PCOUT[31:0],Data_out[31:0],ALU_out[31:0],overflow,zero,rs1_data[31:0],Wt_data[31:0],ALUA[31:0],ALUB[31:0],Debug_addr[6:0],Debug_regs[31:0]" */;
  input clk;
  input rst;
  input [31:0]inst_field;
  input [31:0]Data_in;
  input ALUSrc_A;
  input ALUSrc_B;
  input [2:0]ALUC;
  input [1:0]ImmSel;
  input [1:0]DatatoReg;
  input PCEN;
  input Jump;
  input Branch;
  input RegWrite;
  input Sign;
  output [31:0]PCOUT;
  output [31:0]Data_out;
  output [31:0]ALU_out;
  output overflow;
  output zero;
  output [31:0]rs1_data;
  output [31:0]Wt_data;
  output [31:0]ALUA;
  output [31:0]ALUB;
  input [6:0]Debug_addr;
  output [31:0]Debug_regs;
endmodule
