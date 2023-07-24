// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.2 (win64) Build 2258646 Thu Jun 14 20:03:12 MDT 2018
// Date        : Sat May 22 21:36:37 2021
// Host        : ZJU-DXPS running 64-bit major release  (build 9200)
// Command     : write_verilog -mode synth_stub D:/FPGA_work/ORGV20VI/EdfIP/WB_Stage.edf.v
// Design      : WB_Stage
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7k160tffg676-2L
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module WB_Stage(WB_DatatoReg, WB_ALUO, WB_MDR, WB_PCurrent, 
  WB_WData)
/* synthesis syn_black_box black_box_pad_pin="WB_DatatoReg[1:0],WB_ALUO[31:0],WB_MDR[31:0],WB_PCurrent[31:0],WB_WData[31:0]" */;
  input [1:0]WB_DatatoReg;
  input [31:0]WB_ALUO;
  input [31:0]WB_MDR;
  input [31:0]WB_PCurrent;
  output [31:0]WB_WData;
endmodule
