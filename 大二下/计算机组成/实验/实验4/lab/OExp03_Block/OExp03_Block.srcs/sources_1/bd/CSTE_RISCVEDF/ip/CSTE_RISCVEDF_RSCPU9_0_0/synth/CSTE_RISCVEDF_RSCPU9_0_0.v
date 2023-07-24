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


// IP VLNV: ZJUCLIP:user:RSCPU9:1.0
// IP Revision: 1

(* X_CORE_INFO = "RSCPU9,Vivado 2017.4" *)
(* CHECK_LICENSE_TYPE = "CSTE_RISCVEDF_RSCPU9_0_0,RSCPU9,{}" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module CSTE_RISCVEDF_RSCPU9_0_0 (
  clk,
  reset,
  Ready,
  Datai,
  Datao,
  Addr,
  PC,
  INST,
  TNI,
  ALE,
  MIO,
  WR,
  Debug_addr,
  Debug_data
);

input wire clk;
input wire reset;
(* X_INTERFACE_INFO = "ZJUCLIP:user:CPUB:1.0 CPUBUS Ready" *)
input wire Ready;
(* X_INTERFACE_INFO = "ZJUCLIP:user:CPUB:1.0 CPUBUS Datai" *)
input wire [31 : 0] Datai;
(* X_INTERFACE_INFO = "ZJUCLIP:user:CPUB:1.0 CPUBUS Datao" *)
output wire [31 : 0] Datao;
(* X_INTERFACE_INFO = "ZJUCLIP:user:CPUB:1.0 CPUBUS Addr" *)
output wire [31 : 0] Addr;
(* X_INTERFACE_INFO = "ZJUCLIP:user:PCCODE:1.0 PCCODE PC" *)
output wire [31 : 0] PC;
(* X_INTERFACE_INFO = "ZJUCLIP:user:PCCODE:1.0 PCCODE INST" *)
input wire [31 : 0] INST;
input wire [7 : 0] TNI;
output wire ALE;
output wire MIO;
(* X_INTERFACE_INFO = "ZJUCLIP:user:CPUB:1.0 CPUBUS WR" *)
output wire WR;
(* X_INTERFACE_INFO = "ZJUCLIP:user:DEBUG:1.0 TESTREG Debug_addr" *)
input wire [6 : 0] Debug_addr;
(* X_INTERFACE_INFO = "ZJUCLIP:user:DEBUG:1.0 TESTREG Debug_data" *)
output wire [31 : 0] Debug_data;

  RSCPU9 inst (
    .clk(clk),
    .reset(reset),
    .Ready(Ready),
    .Datai(Datai),
    .Datao(Datao),
    .Addr(Addr),
    .PC(PC),
    .INST(INST),
    .TNI(TNI),
    .ALE(ALE),
    .MIO(MIO),
    .WR(WR),
    .Debug_addr(Debug_addr),
    .Debug_data(Debug_data)
  );
endmodule
