// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.2 (win64) Build 2258646 Thu Jun 14 20:03:12 MDT 2018
// Date        : Thu Mar 11 19:24:06 2021
// Host        : ZJU-DXPS running 64-bit major release  (build 9200)
// Command     : write_verilog -mode synth_stub D:/FPGA_work/ORGV20VI/EdfIP/MSCPUE.v
// Design      : MSCPUE
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7k160tffg676-2L
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module MSCPUE(clk, reset, Ready, Datai, Datao, Addr, PC, INST, TNI, ALE, 
  MIO, WR, Debug_addr, Debug_data)
/* synthesis syn_black_box black_box_pad_pin="clk,reset,Ready,Datai[31:0],Datao[31:0],Addr[31:0],PC[31:0],INST[31:0],TNI[7:0],ALE,MIO,WR,Debug_addr[6:0],Debug_data[31:0]" */;
  input clk;
  input reset;
  input Ready;
  input [31:0]Datai;
  output [31:0]Datao;
  output [31:0]Addr;
  output [31:0]PC;
  input [31:0]INST;
  input [7:0]TNI;
  output ALE;
  output MIO;
  output WR;
  input [6:0]Debug_addr;
  output [31:0]Debug_data;
endmodule
