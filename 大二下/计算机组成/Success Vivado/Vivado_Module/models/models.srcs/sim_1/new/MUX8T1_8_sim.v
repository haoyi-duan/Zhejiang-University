`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/03/14 16:16:05
// Design Name: 
// Module Name: MUX8T1_8_sim
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


module MUX8T1_8_sim;
reg [7:0]I0;
reg [7:0]I1;
reg [7:0]I2;
reg [7:0]I3;
reg [7:0]I4;
reg [7:0]I5;
reg [7:0]I6;
reg [7:0]I7;
reg [2:0]s;
wire [7:0]o;

MUX8T1_8 MUX8T1_8_U(
    .I0(I0),
    .I1(I1),
    .I2(I2),
    .I3(I3),
    .I4(I4),
    .I5(I5),
    .I6(I6),
    .I7(I7),
    .s(s),
    .o(o)
);

initial begin
    I0 = 8'h00;
    I1 = 8'h11;
    I2 = 8'h22;
    I3 = 8'haa;
    I4 = 8'hbb;
    I5 = 8'hff;
    I6 = 8'h12;
    I7 = 8'hbc;
    s = 3'b000;
    #100;
    s = 3'b001;
    #100;
    s = 3'b010;
    #40;
    s = 3'b011;
    #40;
    s = 3'b100;
    #50;
    s = 3'b101;
    #100;
    s = 3'b110;
    #40;
    s = 3'b111;
    #40;
end
endmodule

