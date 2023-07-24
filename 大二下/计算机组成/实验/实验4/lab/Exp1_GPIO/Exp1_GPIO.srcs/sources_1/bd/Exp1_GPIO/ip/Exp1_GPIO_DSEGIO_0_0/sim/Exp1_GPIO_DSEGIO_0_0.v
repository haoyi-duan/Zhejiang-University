// (c) Copyright 1995-2021 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
// 
// DO NOT MODIFY THIS FILE.


// IP VLNV: ZJUCLIP:user:DSEGIO:1.0
// IP Revision: 1

`timescale 1ns/1ps

(* DowngradeIPIdentifiedWarnings = "yes" *)
module Exp1_GPIO_DSEGIO_0_0 (
  clk,
  rst,
  EN,
  Test,
  points,
  LES,
  Data0,
  data1,
  data2,
  data3,
  data4,
  data5,
  data6,
  data7,
  point,
  LE,
  Disp,
  mapup
);

(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME clk, ASSOCIATED_RESET rst, FREQ_HZ 100000000, PHASE 0.000, CLK_DOMAIN Exp1_GPIO_clk_0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 clk CLK" *)
input wire clk;
input wire rst;
input wire EN;
input wire [2 : 0] Test;
input wire [63 : 0] points;
input wire [63 : 0] LES;
input wire [31 : 0] Data0;
input wire [31 : 0] data1;
input wire [31 : 0] data2;
input wire [31 : 0] data3;
input wire [31 : 0] data4;
input wire [31 : 0] data5;
input wire [31 : 0] data6;
input wire [31 : 0] data7;
output wire [7 : 0] point;
output wire [7 : 0] LE;
output wire [31 : 0] Disp;
output wire mapup;

  DSEGIO inst (
    .clk(clk),
    .rst(rst),
    .EN(EN),
    .Test(Test),
    .points(points),
    .LES(LES),
    .Data0(Data0),
    .data1(data1),
    .data2(data2),
    .data3(data3),
    .data4(data4),
    .data5(data5),
    .data6(data6),
    .data7(data7),
    .point(point),
    .LE(LE),
    .Disp(Disp),
    .mapup(mapup)
  );
endmodule
