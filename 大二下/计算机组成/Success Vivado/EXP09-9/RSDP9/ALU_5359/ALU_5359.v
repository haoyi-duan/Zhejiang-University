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
    input [31:0]A,
    input [31:0]B,
    input [2:0]ALU_operation,
    output reg [31:0]res,
    output zero,
    output overflow
    );
    
    wire [31:0] res_and, res_or, res_addsub, res_nor, res_slt, res_xor, res_srl;
    parameter one = 32'h0000_0001, zero_0 = 32'h0000_0000;    
    assign res_and = A & B;
    assign res_or = A | B;
    assign res_nor = ~(A | B);
    assign res_slt = (A < B) ? one : zero_0;
    assign res_xor = A ^ B;
    assign res_srl = A >> B[10:6];// B>>1 ;
    
    always @(*)
    begin
        case (ALU_operation)
            3'b000: res = res_and;
            3'b001: res = res_or;
            3'b010: res = res_addsub;
            3'b011: res = res_xor;
            3'b100: res = res_nor;
            3'b101: res = res_srl;
            3'b110: res = res_addsub;
            3'b111: res = res_slt;
            default: res = 32'hx;
        endcase
    end
    
    ADC32 U1(
    .a(A),
    .b(B),
    .c0(ALU_operation[2]),
    .s({overflow, res_addsub})
    );
    
    assign zero = (res==0) ? 1:0;
endmodule

