// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.2 (win64) Build 2258646 Thu Jun 14 20:03:12 MDT 2018
// Date        : Sat May 22 21:26:07 2021
// Host        : ZJU-DXPS running 64-bit major release  (build 9200)
// Command     : write_verilog -mode synth_stub D:/FPGA_work/ORGV20VI/EdfIP/IF_Stage.edf.v
// Design      : IF_Stage
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7k160tffg676-2L
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module IF_Stage(clk, rst, EN, flush, Data_stall, PCEN, Btaken, 
  MEM_Jump, inst_field, MEM_Target, PCOUT, ID_IR, ID_PCurrent, PCSource)
/* synthesis syn_black_box black_box_pad_pin="clk,rst,EN,flush,Data_stall,PCEN,Btaken,MEM_Jump,inst_field[31:0],MEM_Target[31:0],PCOUT[31:0],ID_IR[31:0],ID_PCurrent[31:0],PCSource[1:0]" */;
  input clk;
  input rst;
  input EN;
  input flush;
  input Data_stall;
  input PCEN;
  input Btaken;
  input MEM_Jump;
  input [31:0]inst_field;
  input [31:0]MEM_Target;
  output [31:0]PCOUT;
  output [31:0]ID_IR;
  output [31:0]ID_PCurrent;
  output [1:0]PCSource;
endmodule
