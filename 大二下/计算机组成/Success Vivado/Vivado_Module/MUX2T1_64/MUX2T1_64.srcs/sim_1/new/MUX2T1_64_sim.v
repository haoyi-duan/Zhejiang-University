`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/03/14 15:22:39
// Design Name: 
// Module Name: MUX2T1_64_sim
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


module MUX2T1_64_sim;
reg [63:0]a;
reg [62:0]b;
reg s;
wire [63:0]o;

MUX2T1_64 a33(
    .a(a),
    .b(b),
    .s(s),
    .o(o)
);

initial begin
    a = 64'h89abff66;
    b = 64'h1234ffff;
    s = 1;
    #200;
    s = 0;
    #100;
end
endmodule
