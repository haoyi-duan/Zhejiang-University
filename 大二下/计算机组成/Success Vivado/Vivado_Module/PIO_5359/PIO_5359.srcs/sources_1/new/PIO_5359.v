`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/03/16 23:02:06
// Design Name: 
// Module Name: PIO_5359
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


module PIO_5359(
    input clk,
    input rst,
    input EN,
    input [31:0] PData,
    output reg [7:0] LED,
    output reg [23:0] GPIOf0
    );
    
    always @(negedge clk or posedge rst) begin
        if (rst) begin LED <= 16'hAA; GPIOf0 <=0;end
            else if (EN) {GPIOf0[23:2], LED, GPIOf0[1:0]} <= PData;
                else begin LED <= LED; GPIOf0[23:0] <= GPIOf0[23:0]; end
    end

endmodule