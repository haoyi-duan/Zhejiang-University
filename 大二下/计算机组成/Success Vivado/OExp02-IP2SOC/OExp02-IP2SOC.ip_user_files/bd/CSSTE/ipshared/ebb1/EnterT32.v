// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.2 (win64) Build 2258646 Thu Jun 14 20:03:12 MDT 2018
// Date        : Sat Feb 27 16:17:06 2021
// Host        : ZJU-DXPS running 64-bit major release  (build 9200)
// Command     : write_verilog -mode synth_stub D:/FPGA_work/ORG20V/EdfIP/EnterT32.v
// Design      : EnterT32
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7k160tffg676-2L
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module EnterT32(clk, Din, BTN, ArrayKey, TEST, UP16, Text, DRDY, readn, Ai, 
  Bi, blink)
/* synthesis syn_black_box black_box_pad_pin="clk,Din[4:0],BTN[3:0],ArrayKey,TEST[2:0],UP16,Text,DRDY,readn,Ai[31:0],Bi[31:0],blink[7:0]" */;
  input clk;
  input [4:0]Din;
  input [3:0]BTN;
  input ArrayKey;
  input [2:0]TEST;
  input UP16;
  input Text;
  input DRDY;
  output readn;
  output [31:0]Ai;
  output [31:0]Bi;
  output [7:0]blink;
endmodule
