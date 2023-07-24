`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/25 23:12:05
// Design Name: 
// Module Name: decoder4_16
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


module decoder4_16(
        input clk,
        input rst,
        input oe,              // 高有效，是否输出
        input [3:0] code,      // 待编码的码
        output [7:0] h8,       // 编码的码的高八位
        output [7:0] l8        // 编码的码的低八位
);

assign {h8, l8} = (rst || ~oe) ? 16'h0000 : (16'h01 << code);

endmodule
