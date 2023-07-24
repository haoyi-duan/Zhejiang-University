`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/03/05 19:18:01
// Design Name: 
// Module Name: ADC_32_sim
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


module ADC_32_sim;
reg [31:0]a;
reg [31:0]b;
reg c0;
wire [32:0]s;

ADC32 ADC_32U(
    .a(a),
    .b(b),
    .c0(c0),
    .s(s)
);

initial begin
    c0 = 1;
    a = 32'h0000000a;//a = 32'h8432FABC;
    b = 32'h00000002;//b = 32'hF4560111;
end
endmodule
