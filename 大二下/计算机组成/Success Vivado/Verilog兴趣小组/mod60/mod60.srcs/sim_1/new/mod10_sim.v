`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/03/11 14:35:46
// Design Name: 
// Module Name: mod10_sim
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


module mod10_sim;
reg clk;
reg rst;
wire [3:0] mod10;

mod10 mod10_u(
    .clk(clk),
    .rst(rst),
    .mod10(mod10)
);

initial begin
    clk <= 0;
    rst = 0;
    #200;
    rst = 1;
    #20;
    rst = 0;
    #40;
    rst = 1;
    #10;
    rst = 0;
    #100;
end
    always @(*)
    begin
        #20;
        clk <= ~clk;
    end
endmodule
