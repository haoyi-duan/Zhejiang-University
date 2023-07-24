`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/03/14 16:25:15
// Design Name: 
// Module Name: top_sim
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


module top_sim;
    reg c0;
    reg s0;
    reg [1:0]s1;
    reg [2:0]s2;
    
    reg [4:0]I0;
    reg [4:0]I1;
    reg [4:0]I2;
    reg [4:0]I3;
    
    reg [7:0]O0;
    reg [7:0]O1;
    reg [7:0]O2;
    reg [7:0]O3;
    reg [7:0]O4;
    reg [7:0]O5;
    reg [7:0]O6;
    reg [7:0]O7;
    
    reg [31:0]H0;    
    reg [31:0]H1;
    reg [31:0]H2;
    reg [31:0]H3;
    reg [31:0]H4;
    reg [31:0]H5;
    reg [31:0]H6;
    reg [31:0]H7;
    
    reg [63:0]M0;
    reg [63:0]M1;
    
    wire [31:0]add1;
    wire [32:0]add2;
    wire [32:0]addsub;
    wire [31:0]oror;
    wire [31:0]andand;
    wire [31:0]nornor;
    wire [31:0]xorxor;
    wire orbit;
    
    wire [4:0] mux1;
    wire [4:0] mux2;
    wire [31:0] mux3;
    wire [31:0] mux4;
    wire [7:0] mux5;
    wire [31:0] mux6;
    wire [63:0] mux7; 
    wire [7:0] mux8;
    
    TOP TOP_U(
        .c0(c0),
        .s0(s0),
        .s1(s1),
        .s2(s2),
        
        .I0(I0),
        .I1(I1),
        .I2(I2),
        .I3(I3),
        
        .O0(O0),
        .O1(O1),
        .O2(O2),
        .O3(O3),
        .O4(O4),
        .O5(O5),
        .O6(O6),
        .O7(O7),
        
        .H0(H0),    
        .H1(H1),
        .H2(H2),
        .H3(H3),
        .H4(H4),
        .H5(H5),
        .H6(H6),
        .H7(H7),
        
        .M0(M0),
        .M1(M1),
        
        .add1(add1),
        .add2(add2),
        .addsub(addsub),
        .oror(oror),
        .andand(andand),
        .nornor(nornor),
        .xorxor(xorxor),
        .orbit(orbit),
        
        .mux1(mux1),
        .mux2(mux2),
        .mux3(mux3),
        .mux4(mux4),
        .mux5(mux5),
        .mux6(mux6),
        .mux7(mux7), 
        .mux8(mux8)
    );
    
    initial begin
        c0 = 0;
        s0 = 0;
        s1 = 0;
        s2 = 0;
       
        I0 = 5'b01010;
        I1 = 5'b11111;
        I2 = 5'b00001;
        I3 = 5'b01000;
       
        O0 = 8'haa;
        O1 = 8'hbb;
        O2 = 8'hcc;
        O3 = 8'hdd;
        O4 = 8'hff;
        O5 = 8'hab;
        O6 = 8'hcd;
        O7 = 8'hef;
       
        H0 = 32'hfabd1234;    
        H1 = 32'h00001187;
        H2 = 32'h119dfacd;
        H3 = 32'haaaaaaaa;
        H4 = 32'hffffffff;
        H5 = 32'habcd3452;
        H6 = 32'h10100101;
        H7 = 32'habcdefab;
       
        M0 = 64'h1111_2222_3333_4444;
        M1 = 64'hffff_ffff_ffff_ffff;
        #200;
        c0 = 1;
        s0 = 1;
        s1 = 2'b01;
        s2 = 3'b001;
              
        H0 = 32'h00000000;    
        H1 = 32'hffffffff;
        #100;
        c0 = 1;
        s0 = 1;
        s1 = 2'b01;
        s2 = 3'b001;
               
        H0 = 32'hfabd1234;    
        H1 = 32'h00000000;
        #40;
        c0 = 0;
        s1 = 2'b10;
        s2 = 3'b111;
               
        H0 = 32'h00000000;    
        H1 = 32'h11111111;
    end
endmodule
