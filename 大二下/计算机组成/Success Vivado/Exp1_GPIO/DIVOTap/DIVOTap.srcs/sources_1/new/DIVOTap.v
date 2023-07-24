`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/03/09 19:54:10
// Design Name: 
// Module Name: DIVOTap
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


module DIVOTap(
    input [31:0] DIV,
    output DIVO31T24,
    output DIVO25,
    output DIVO20,
    output [1:0] DIVO18T19,
    output DIVO12,
    output DIVO10,
    output DIVO08,
    output [17:0] Other
);

assign DIVO31T24 = DIV[31:24];
assign DIVO25 = DIV[25];
assign DIVO20 = DIV[20];
assign DIVO18T19 = DIV[19:18];
assign DIVO12 = DIV[12];
assign DIVO10 = DIV[10];
assign DIVO08 = DIV[8];
assign Other = {DIV[23:21],DIV[17:13],DIV[11],DIV[9],DIV[7:0]};

endmodule
