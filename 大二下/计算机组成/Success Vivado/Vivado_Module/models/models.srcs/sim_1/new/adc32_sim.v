`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/03/14 15:43:21
// Design Name: 
// Module Name: adc32_sim
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


module adc32_sim;
reg [31:0]a;
reg [31:0]b;
wire [32:0]o;

adc32 adc32_U(
    .a(a),
    .b(b),
    .o(o)
);

initial begin 
    a = 32'h987654ff;
    b = 32'habaa0011;
    #100;
    a = 32'ha349bcdd;
    b = 32'h1300ffac;
    #100;
end
endmodule
