`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/03/17 12:52:48
// Design Name: 
// Module Name: randomx_sim
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
module randomx_sim;
reg clk;
reg rst;
wire [7:0]dataout;
wire [7:0] datain;
wire in;
wire over;

Top Top_U(
    .clk(clk),
    .rst(rst),
    .datain(datain),
    .in(in),
    .over(over),
    .dataout(dataout)
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
