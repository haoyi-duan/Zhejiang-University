// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.2 (win64) Build 2258646 Thu Jun 14 20:03:12 MDT 2018
// Date        : Thu Mar 11 19:57:23 2021
// Host        : ZJU-DXPS running 64-bit major release  (build 9200)
// Command     : write_verilog -mode synth_stub D:/FPGA_work/ORGV20VI/EdfIP/DSEGIO.v
// Design      : DSEGIO
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7k160tffg676-2L
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module DSEGIO(clk, rst, EN, A0, Test, points, LES, Data0, data1, data2, 
  data3, data4, data5, data6, data7, Disp, point, LE, mapup)
/* synthesis syn_black_box black_box_pad_pin="clk,rst,EN,A0,Test[2:0],points[63:0],LES[63:0],Data0[31:0],data1[31:0],data2[31:0],data3[31:0],data4[31:0],data5[31:0],data6[31:0],data7[31:0],Disp[31:0],point[7:0],LE[7:0],mapup" */;
  input clk;
  input rst;
  input EN;
  input A0;
  input [2:0]Test;
  input [63:0]points;
  input [63:0]LES;
  input [31:0]Data0;
  input [31:0]data1;
  input [31:0]data2;
  input [31:0]data3;
  input [31:0]data4;
  input [31:0]data5;
  input [31:0]data6;
  input [31:0]data7;
  output [31:0]Disp;
  output [7:0]point;
  output [7:0]LE;
  output mapup;
endmodule
