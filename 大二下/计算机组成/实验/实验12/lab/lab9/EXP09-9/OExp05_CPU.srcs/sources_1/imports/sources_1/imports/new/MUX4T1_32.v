`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/03/05 11:53:59
// Design Name: 
// Module Name: MUX4T1_32
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


module MUX4T1_32(
    input [1:0]s,
    input [31:0]I0,
    input [31:0]I1,
    input [31:0]I2,
    input [31:0]I3,
    output reg [31:0] o
    );
    always @(*)
    begin
        case(s)
        2'b00: o <= I0;
        2'b01: o <= I1;
        2'b10: o <= I2;
        2'b11: o <= I3;
        default:o <= o;
        endcase
    end
endmodule
