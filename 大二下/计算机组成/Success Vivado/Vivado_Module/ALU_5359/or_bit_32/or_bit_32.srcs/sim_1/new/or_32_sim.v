`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/03/10 22:09:47
// Design Name: 
// Module Name: or_32_sim
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


module or_32_sim;
reg [31:0] a;
wire o;

or_bit_32 or_bit_32(
    .a(a),
    .o(o)
);

initial begin
    a = 32'h1111_1111;
    #100;
    a = 32'h0000_0000;
    #240;
end
endmodule
