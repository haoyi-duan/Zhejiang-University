`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/12 18:22:30
// Design Name: 
// Module Name: ImmGen
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

module ImmGen(
    input [1:0]s,
    input [31:0]I,
    output reg [31:0] o
    );
    always @(*)
    begin
        case(s)
        2'b00: o <= {{20{I[31]}}, I[31:20]};
        2'b01: o <= {{20{I[31]}}, I[31:25], I[11:7]};
        2'b10: o <= {{19{I[31]}}, I[31], I[7], I[30:25], I[11:8], 1'b0};
        2'b11: o <= {{11{I[31]}}, I[31], I[19:12], I[20], I[30:21], 1'b0};
        default:;
        endcase
    end
endmodule
