// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.2 (win64) Build 2258646 Thu Jun 14 20:03:12 MDT 2018
// Date        : Sat Feb 27 16:34:53 2021
// Host        : ZJU-DXPS running 64-bit major release  (build 9200)
// Command     : write_verilog -mode synth_stub D:/FPGA_work/ORG20V/EdfIP/P2S.v
// Design      : P2S
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7k160tffg676-2L
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module P2S(clk, rst, Start, PData, sclk, sclrn, sout, EN)
/* synthesis syn_black_box black_box_pad_pin="clk,rst,Start,PData[63:0],sclk,sclrn,sout,EN" */;
  input clk;
  input rst;
  input Start;
  input [63:0]PData;
  output sclk;
  output sclrn;
  output sout;
  output EN;
endmodule
