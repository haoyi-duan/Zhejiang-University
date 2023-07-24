`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/03/09 18:06:17
// Design Name: 
// Module Name: ALU_tb
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


module ALU_tb;
    reg [31:0]A;
    reg [2:0]ALU_operation;
    reg [31:0]B;
    wire [31:0]res;
    wire zero;
    wire overflow;

ALU_5359 ALU_wrapper_u(
    .A(A),
    .B(B),
    .ALU_operation(ALU_operation),
    .res(res),
    .zero(zero),
    .overflow(overflow)
);

initial begin
    A = 32'ha5a5a5a5;
    B = 32'h5a5a5a5a;
    ALU_operation = 3'b111;
    #100;
    ALU_operation = 3'b110;
    #100;
    ALU_operation = 3'b101;
    #100;
    ALU_operation = 3'b100;
    #100;
    ALU_operation = 3'b011;
    #100;
    ALU_operation = 3'b010;
    #100;
    ALU_operation = 3'b001;
    #100;
    ALU_operation = 3'b000;
    #100;
    A = 32'h01234567;
    B = 32'h76543210;
    ALU_operation = 3'b111;
end
endmodule
