// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.2 (win64) Build 2258646 Thu Jun 14 20:03:12 MDT 2018
// Date        : Thu Mar 11 12:42:50 2021
// Host        : ZJU-DXPS running 64-bit major release  (build 9200)
// Command     : write_verilog -mode synth_stub D:/FPGA_work/ORGV20VI/EdfIP/MIOBUS.v
// Design      : MIOBUS
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7k160tffg676-2L
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module MIOBUS(clk, rst, BTN, SW, mem_w, Data4CPU, Addr_bus, 
  ram_data_out, Counter, C0, C1, C2, CPU_wait, Data2CPU, ram_data_in, ram_addr, data_ram_we, 
  GPIO_W0200, GPIO_W0204, CONT_W0208, Peripheral)
/* synthesis syn_black_box black_box_pad_pin="clk,rst,BTN[3:0],SW[15:0],mem_w,Data4CPU[31:0],Addr_bus[31:0],ram_data_out[31:0],Counter[31:0],C0,C1,C2,CPU_wait,Data2CPU[31:0],ram_data_in[31:0],ram_addr[9:0],data_ram_we,GPIO_W0200,GPIO_W0204,CONT_W0208,Peripheral[31:0]" */;
  input clk;
  input rst;
  input [3:0]BTN;
  input [15:0]SW;
  input mem_w;
  input [31:0]Data4CPU;
  input [31:0]Addr_bus;
  input [31:0]ram_data_out;
  input [31:0]Counter;
  input C0;
  input C1;
  input C2;
  output CPU_wait;
  output [31:0]Data2CPU;
  output [31:0]ram_data_in;
  output [9:0]ram_addr;
  output data_ram_we;
  output GPIO_W0200;
  output GPIO_W0204;
  output CONT_W0208;
  output [31:0]Peripheral;
endmodule
