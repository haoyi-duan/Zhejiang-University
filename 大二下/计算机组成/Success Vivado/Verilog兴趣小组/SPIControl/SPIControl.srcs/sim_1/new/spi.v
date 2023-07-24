`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/09 00:19:47
// Design Name: 
// Module Name: spi
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

module spi;
reg clk;
reg rst;
reg [7:0] datain;
wire in;
wire [7:0] dataout;
wire out;
wire cs_n;
wire clk_o;
wire d_o;
reg d_i;
wire ready;
reg [8:0] inNum; 
reg [7:0] outNum;

yhf new(
//SPIControl new(
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
    .ready(ready),
    .inNum(inNum),
    .outNum(outNum)
);
parameter clk_period = 5;

initial begin
rst = 1;#5;
rst = 0;clk = 0;
inNum = 0; datain = 8'h37; outNum = 2; d_i = 1; #160;
datain = 8'h01; #160;
d_i = 1;#20; d_i = 1;#20; d_i = 1;#20; d_i = 1;#20; 
d_i = 1;#20; d_i = 1;#20; d_i = 1;#20; d_i = 1;#20;

d_i = 0;#20; d_i = 0;#20; d_i = 0;#20; d_i = 1;#20; 
d_i = 0;#20; d_i = 0;#20; d_i = 0;#20; d_i = 1;#20;
d_i = 0;#20;

inNum = 1; outNum = 0; datain = 8'h17;
end

always #(clk_period)  begin
   clk = ~clk;
end
endmodule
