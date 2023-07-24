`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/03/14 16:24:58
// Design Name: 
// Module Name: TOP
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


module TOP(
    input c0,
    input s0,
    input [1:0]s1,
    input [2:0]s2,
    
    input [4:0]I0,
    input [4:0]I1,
    input [4:0]I2,
    input [4:0]I3,
    
    input [7:0]O0,
    input [7:0]O1,
    input [7:0]O2,
    input [7:0]O3,
    input [7:0]O4,
    input [7:0]O5,
    input [7:0]O6,
    input [7:0]O7,
    
    input [31:0]H0,    
    input [31:0]H1,
    input [31:0]H2,
    input [31:0]H3,
    input [31:0]H4,
    input [31:0]H5,
    input [31:0]H6,
    input [31:0]H7,
    
    input [63:0]M0,
    input [63:0]M1,
    
    output [31:0]add1,
    output [32:0]add2,
    output [32:0]addsub,
    output [31:0]oror,
    output [31:0]andand,
    output [31:0]nornor,
    output [31:0]xorxor,
    output orbit,
    
    output [4:0] mux1,
    output [4:0] mux2,
    output [31:0] mux3,
    output [31:0] mux4,
    output [7:0] mux5,
    output [31:0] mux6,
    output [63:0] mux7, 
    output [7:0] mux8
    );
    
    add_32 U1(
        .a(H0),
        .b(H1),
        .c(add1)
    );
    
    ADC32 U2(
        .a(H0),
        .b(H1),
        .c0(c0),
        .s(addsub)
    );
    
    adc32 U3(
        .a(H0),
        .b(H1),
        .o(add2)
    );
    
    or32 U4(
        .a(H0),
        .b(H1),
        .res(oror)
    );
    
    and32 U5(
        .a(H1),
        .b(H1),
        .res(andand)
    );
    
    nor32 U6(
        .a(H0),
        .b(H1),
        .res(nornor)
    );
    
    xor32 U7(
        .a(H0),
        .b(H1),
        .res(xorxor)
    );
    
    or_bit_32 U8(
        .a(H0),
        .o(orbit)
    );
    
    MUX2T1_5 MUX1(
        .I0(I0),
        .I1(I1),
        .s(s0),
        .o(mux1)
    );
    
    MUX4T1_5 MUX2
    (
        .I0(I0),
        .I1(I1),
        .I2(I2),
        .I3(I3),
        .s(s1),
        .o(mux2)
    );
    
    MUX2T1_32 MUX3(
        .I0(H0),
        .I1(H1),
        .s(s0),
        .o(mux3)
    );
    
    MUX4T1_32 MUX4(
        .I0(H0),
        .I1(H1),
        .I2(H2),
        .I3(H3),
        .s(s1),
        .o(mux4)
    );
    
    MUX8T1_8 MUX5(
        .I0(O0),
        .I1(O1),
        .I2(O2),
        .I3(O3),
        .I4(O4),
        .I5(O5),
        .I6(O6),
        .I7(O7),
        .s(s2),
        .o(mux5)
    );
    
    MUX8T1_32 MUX6(
        .I0(H0),
        .I1(H1),
        .I2(H2),
        .I3(H3),
        .I4(H4),
        .I5(H5),
        .I6(H6),
        .I7(H7),
        .s(s2),
        .o(mux6)  
    );
    
    MUX2T1_64 MUX7(
        .a(M0),
        .b(M1),
        .s(s0),
        .o(mux7)
    );
    
    MUX2T1_8 MUX8(
        .a(O0),
        .b(O1),
        .s(s0),
        .o(mux8)
    );
    
    
endmodule
