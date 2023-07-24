`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/03/11 13:33:54
// Design Name: 
// Module Name: ALU_5359
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

module ALU_5359(
    input sign,
    input [31:0]A,
    input [31:0]B,
    input [2:0]ALU_operation,
    output reg [31:0]res,
    output zero,
    output overflow
    );
    
    wire signa, signb;
    assign signa = A[31];
    assign signb = B[31];
    wire [31:0] res_and, res_or, res_nor, res_slt, res_xor, res_srl, res_add, res_sub;
    parameter one = 32'h0000_0001, zero_0 = 32'h0000_0000;    
    
    assign res_and = A & B;
    assign res_or = A | B;
    assign res_nor = ~(A | B);
    assign res_slt = (sign == 0 || signa & signb == 0) ? ((A < B) ? one : zero_0) : (signa == 1 && signb == 0) ? one : (signa == 0 && signb == 1) ? zero_0 : (A < B) ? zero_0 : one;
    assign res_xor = A ^ B;
    assign res_srl = A >> B;
    assign res_add = A + B;
    assign res_sub = A - B;
    
    always @(*)
    begin
        case (ALU_operation)
            3'b000: res = res_and;
            3'b001: res = res_or;
            3'b010: res = res_add;
            3'b011: res = res_xor;
            3'b100: res = res_nor;
            3'b101: res = res_srl;
            3'b110: res = res_sub;
            3'b111: res = res_slt;
            default: res = 32'hx;
        endcase
    end
    
    assign zero = (res==0) ? 1:0;
endmodule

