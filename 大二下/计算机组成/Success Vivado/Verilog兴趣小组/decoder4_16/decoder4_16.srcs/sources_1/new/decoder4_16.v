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
        input oe,              // ����Ч���Ƿ����
        input [3:0] code,      // ���������
        output [7:0] h8,       // �������ĸ߰�λ
        output [7:0] l8        // �������ĵͰ�λ
);

assign {h8, l8} = (rst || ~oe) ? 16'h0000 : (16'h01 << code);

endmodule
