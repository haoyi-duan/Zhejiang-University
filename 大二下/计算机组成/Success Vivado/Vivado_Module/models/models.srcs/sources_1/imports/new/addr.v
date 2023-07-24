`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/03/05 12:07:26
// Design Name: 
// Module Name: addr
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


module addr(
    input a0,
    input b0,
    input c0,
    output out1,
    output c1
    );
    
    assign out1 = a0^b0^c0;
    assign c1 = ((a0&b0)|(a0&c0)|(b0&c0));
endmodule
