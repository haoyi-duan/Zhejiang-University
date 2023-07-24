//Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2017.4 (win64) Build 2086221 Fri Dec 15 20:55:39 MST 2017
//Date        : Sun Mar  7 22:51:48 2021
//Host        : LAPTOP-0HOK14LD running 64-bit major release  (build 9200)
//Command     : generate_target design_1_wrapper.bd
//Design      : design_1_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module design_1_wrapper
   (I0,
    I1,
    o_0,
    s,
    s1,
    s2);
  input [4:0]I0;
  input [4:0]I1;
  output [4:0]o_0;
  input [1:0]s;
  input s1;
  input [2:0]s2;

  wire [4:0]I0;
  wire [4:0]I1;
  wire [4:0]o_0;
  wire [1:0]s;
  wire s1;
  wire [2:0]s2;

  design_1 design_1_i
       (.I0(I0),
        .I1(I1),
        .o_0(o_0),
        .s(s),
        .s1(s1),
        .s2(s2));
endmodule
