// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.2 (win64) Build 2258646 Thu Jun 14 20:03:12 MDT 2018
// Date        : Sun Feb 28 21:32:30 2021
// Host        : ZJU-DXPS running 64-bit major release  (build 9200)
// Command     : write_verilog -mode synth_stub D:/FPGA_work/ORG20V/EdfIP/Arraykeys.v
// Design      : Arraykeys
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7k160tffg676-2L
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module Arraykeys(clk, RSTN, readn, KCOL, KROW, SW, KCODE, KRDY, pulse, BTNO, 
  SWO, CR, rst)
/* synthesis syn_black_box black_box_pad_pin="clk,RSTN,readn,KCOL[3:0],KROW[4:0],SW[15:0],KCODE[4:0],KRDY,pulse[3:0],BTNO[3:0],SWO[15:0],CR,rst" */;
  input clk;
  input RSTN;
  input readn;
  input [3:0]KCOL;
  output [4:0]KROW;
  input [15:0]SW;
  output [4:0]KCODE;
  output KRDY;
  output [3:0]pulse;
  output [3:0]BTNO;
  output [15:0]SWO;
  output CR;
  output rst;
endmodule
