`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/15 22:01:48
// Design Name: 
// Module Name: sim
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


module sim;
reg clk;
reg rst;
wire [7:0] datain;
wire in;
wire [7:0] dataout;
wire out;
wire cs_n;
wire clk_o;
wire d_o;
wire d_i;
wire ready;

top Top_U(
    .clk(clk),
    .rst(rst),
    .datain(datain),
    .in(in),
    .dataout(dataout),
    .out(out),
    .cs_n(cs_n),
    .clk_o(clk_o),
    .d_o(d_o),
    .d_i(d_i),
    .ready(ready)
);

parameter clk_period = 10;

initial begin
    clk = 1;
    rst = 1;
    #clk_period;
    rst = 0;
end

always #(clk_period) clk = ~clk;
endmodule
