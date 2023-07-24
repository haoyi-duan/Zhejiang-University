`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/03/14 15:32:13
// Design Name: 
// Module Name: MUX8sim
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

module MUX8sim;
reg [7:0]a;
reg [7:0]b;
reg s;
wire [7:0]o;

MUX2T1_8 MUX2T1_8_U(
    .a(a),
    .b(b),
    .s(s),
    .o(o)
);

initial begin
    a = 8'hab;
    b = 8'hff;
    s = 1;
    #200;
    s = 0;
    #100;
end
endmodule
