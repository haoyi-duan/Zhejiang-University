// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.2 (win64) Build 2258646 Thu Jun 14 20:03:12 MDT 2018
// Date        : Sat Feb 27 16:28:44 2021
// Host        : ZJU-DXPS running 64-bit major release  (build 9200)
// Command     : write_verilog -mode synth_stub D:/FPGA_work/ORG20V/EdfIP/Disp2Hex.v
// Design      : Disp2Hex
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7k160tffg676-2L
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module Disp2Hex(Hexs, Scan2, Scan10, points, LES, Text, flash, AN, 
  SEGMENT)
/* synthesis syn_black_box black_box_pad_pin="Hexs[31:0],Scan2,Scan10[1:0],points[7:0],LES[7:0],Text,flash,AN[3:0],SEGMENT[7:0]" */;
  input [31:0]Hexs;
  input Scan2;
  input [1:0]Scan10;
  input [7:0]points;
  input [7:0]LES;
  input Text;
  input flash;
  output [3:0]AN;
  output [7:0]SEGMENT;
endmodule
