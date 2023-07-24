`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/03/14 15:21:12
// Design Name: 
// Module Name: MUX2T1_64
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module MUX2T1_64(
    input [63:0]a,
    input [63:0]b,
    input s,
    output [63:0]o
    );
    assign o = s ? b : a;
endmodule
