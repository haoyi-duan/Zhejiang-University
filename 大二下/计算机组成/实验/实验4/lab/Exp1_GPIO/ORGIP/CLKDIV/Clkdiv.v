`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:19:38 07/17/2012 
// Design Name: 
// Module Name:    clk_div 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Clkdiv(input clk,
					input rst,
					input STEP,
					output reg[31:0]clkdiv,
					output CPUClk,
					output nCPUClk
					);
					
// Clock divider-Ê±ÖÓ·ÖÆµÆ÷


	always @ (posedge clk ) 	//or posedge rst
				clkdiv <= clkdiv + 1'b1;
//		if (rst) clkdiv <= 0; else clkdiv <= clkdiv + 1'b1; 
		
	assign CPUClk = (STEP)? clkdiv[24] : clkdiv[0];
	assign nCPUClk = ~CPUClk;
		
endmodule
