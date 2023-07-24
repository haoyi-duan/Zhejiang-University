`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/03/11 14:24:07
// Design Name: 
// Module Name: mod10
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


module mod10(
    input clk,
    input rst,
    output reg [3:0] mod10
);
    always @(posedge clk or posedge rst)
    begin
        if (rst)
            mod10 <= 0;
        else
        if (mod10 == 4'b1001)
            mod10 <= 4'b0000;
        else   
            mod10 <= mod10 + 1'b1;
    end
endmodule
