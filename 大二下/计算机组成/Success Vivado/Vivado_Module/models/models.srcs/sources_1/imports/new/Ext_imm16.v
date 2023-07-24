`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/03/06 17:19:32
// Design Name: 
// Module Name: Ext_imm16
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


module Ext_imm16(
    input [15:0] imm_16,
    output [31:0] imm_32
    );
    reg i;
    initial begin
        assign i = imm_16[15];
    end
    assign imm_32 = {i,i, i, i, i, i, i, i, i, i, i, i, i, i, i, i,  imm_16};
endmodule
