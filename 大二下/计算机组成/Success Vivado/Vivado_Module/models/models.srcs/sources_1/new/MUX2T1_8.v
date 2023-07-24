`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/03/14 17:08:24
// Design Name: 
// Module Name: MUX2T1_8
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


module MUX2T1_8(
    input [7:0]a,
    input [7:0]b,
    input s,
    output [7:0]o
    );
    
    assign o = s?b:a;
endmodule
