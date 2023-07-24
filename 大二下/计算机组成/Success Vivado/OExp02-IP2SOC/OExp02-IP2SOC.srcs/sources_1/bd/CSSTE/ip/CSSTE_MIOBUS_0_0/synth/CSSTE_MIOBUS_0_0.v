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


// IP VLNV: ZJUCLIP:user:MIOBUS:1.0
// IP Revision: 2

(* X_CORE_INFO = "MIOBUS,Vivado 2017.4" *)
(* CHECK_LICENSE_TYPE = "CSSTE_MIOBUS_0_0,MIOBUS,{}" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module CSSTE_MIOBUS_0_0 (
  clk,
  rst,
  BTN,
  SW,
  mem_w,
  Data4CPU,
  Addr_bus,
  ram_data_out,
  Counter,
  C0,
  C1,
  C2,
  CPU_wait,
  Data2CPU,
  ram_data_in,
  ram_addr,
  data_ram_we,
  GPIO_W0200,
  GPIO_W0204,
  CONT_W0208,
  Peripheral
);

(* X_INTERFACE_INFO = "ZJUCLIP:user:MI:1.0 MIO clk" *)
input wire clk;
(* X_INTERFACE_INFO = "ZJUCLIP:user:MI:1.0 MIO rst" *)
input wire rst;
(* X_INTERFACE_INFO = "ZJUCLIP:user:MI:1.0 MIO BTN" *)
input wire [3 : 0] BTN;
(* X_INTERFACE_INFO = "ZJUCLIP:user:MI:1.0 MIO SW" *)
input wire [15 : 0] SW;
(* X_INTERFACE_INFO = "ZJUCLIP:user:CPUBUS:1.0 MCPUBUS mem_w" *)
input wire mem_w;
(* X_INTERFACE_INFO = "ZJUCLIP:user:CPUBUS:1.0 MCPUBUS Data4CPU" *)
input wire [31 : 0] Data4CPU;
(* X_INTERFACE_INFO = "ZJUCLIP:user:CPUBUS:1.0 MCPUBUS Addr_bus" *)
input wire [31 : 0] Addr_bus;
(* X_INTERFACE_INFO = "ZJUCLIP:user:RAMBUS:1.0 RAMBUS ram_data_out" *)
input wire [31 : 0] ram_data_out;
(* X_INTERFACE_INFO = "ZJUCLIP:user:Counter:1.0 Counter Counter" *)
input wire [31 : 0] Counter;
(* X_INTERFACE_INFO = "ZJUCLIP:user:Counter:1.0 Counter C0" *)
input wire C0;
(* X_INTERFACE_INFO = "ZJUCLIP:user:Counter:1.0 Counter C1" *)
input wire C1;
(* X_INTERFACE_INFO = "ZJUCLIP:user:Counter:1.0 Counter C2" *)
input wire C2;
(* X_INTERFACE_INFO = "ZJUCLIP:user:CPUBUS:1.0 MCPUBUS CPU_wait" *)
output wire CPU_wait;
(* X_INTERFACE_INFO = "ZJUCLIP:user:CPUBUS:1.0 MCPUBUS Data2CPU" *)
output wire [31 : 0] Data2CPU;
(* X_INTERFACE_INFO = "ZJUCLIP:user:RAMBUS:1.0 RAMBUS ram_data_in" *)
output wire [31 : 0] ram_data_in;
(* X_INTERFACE_INFO = "ZJUCLIP:user:RAMBUS:1.0 RAMBUS ram_addr" *)
output wire [9 : 0] ram_addr;
(* X_INTERFACE_INFO = "ZJUCLIP:user:RAMBUS:1.0 RAMBUS data_ram_we" *)
output wire data_ram_we;
(* X_INTERFACE_INFO = "ZJUCLIP:user:IOUT:1.0 MIOUT GPIO_W0200" *)
output wire GPIO_W0200;
(* X_INTERFACE_INFO = "ZJUCLIP:user:IOUT:1.0 MIOUT GPIO_W0204" *)
output wire GPIO_W0204;
(* X_INTERFACE_INFO = "ZJUCLIP:user:IOUT:1.0 MIOUT CONT_W0208" *)
output wire CONT_W0208;
(* X_INTERFACE_INFO = "ZJUCLIP:user:IOUT:1.0 MIOUT Peripheral" *)
output wire [31 : 0] Peripheral;

  MIOBUS inst (
    .clk(clk),
    .rst(rst),
    .BTN(BTN),
    .SW(SW),
    .mem_w(mem_w),
    .Data4CPU(Data4CPU),
    .Addr_bus(Addr_bus),
    .ram_data_out(ram_data_out),
    .Counter(Counter),
    .C0(C0),
    .C1(C1),
    .C2(C2),
    .CPU_wait(CPU_wait),
    .Data2CPU(Data2CPU),
    .ram_data_in(ram_data_in),
    .ram_addr(ram_addr),
    .data_ram_we(data_ram_we),
    .GPIO_W0200(GPIO_W0200),
    .GPIO_W0204(GPIO_W0204),
    .CONT_W0208(CONT_W0208),
    .Peripheral(Peripheral)
  );
endmodule
