`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/03/14 15:54:55
// Design Name: 
// Module Name: or_bit_32_sim
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


module or_bit_32_sim;
reg [31:0]a;
wire o;

or_bit_32 or_bit_32_u(
    .a(a),
    .o(o)
);

initial begin
    a = 32'h12345678;
    #200;
    a = 32'h0;
    #100;
    a  = 32'hffffffff;
    #100;
    a = 0;
    #40;
end
endmodule
