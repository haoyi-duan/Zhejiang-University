`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/05 16:07:51
// Design Name: 
// Module Name: RSCU9
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

`define CPU_ctrl_signals {ImmSel , ALUSrc_B , DatatoReg , RegWrite , MemRead , MemWrite , Branch, Jump, ALUop}   

module RSCU9(
    input clk,
    input reset,
    input [4:0]OPcode,
    input [2:0]Fun3,
    input Fun7,
    input MIO_ready,
    input zero,
    output reg ALUSrc_A,
    output reg ALUSrc_B,
    output reg [1:0]ImmSel,
    output reg [1:0]DatatoReg,
    output PCEN,
    output reg Jump,
    output reg Branch,
    output reg RegWrite,
    output WR,
    output reg [2:0]ALUC,
    output CPU_MIO,
    output ALE
    );
    
    reg MemWrite;
    reg MemRead;
    reg [1:0] ALUop;
    wire [3:0] Fun;
    assign WR = MemWrite&&(~MemRead);
    assign ALE = ~clk;
    assign PCEN = 1;
    

    always @* begin
        case (OPcode)
        5'b01100 : begin  `CPU_ctrl_signals = {2'd0,1'b0,2'd0,1'b1,1'b0,1'b0,1'b0,1'b0,2'b10}; end //dont care
        5'b00000 : begin `CPU_ctrl_signals = {2'd0,1'b1,2'd1,1'b1,1'b1,1'b0,1'b0,1'b0,2'b00}; end // I type 00
        5'b01000 : begin `CPU_ctrl_signals = {2'd1,1'b1,2'd0,1'b0,1'b0,1'b1,1'b0,1'b0,2'b00}; end //S 01
        5'b11000 : begin `CPU_ctrl_signals = {2'b10,1'b0,2'd2,1'b0,1'b0,1'b0,1'b1,1'b0,2'b01}; end //B 10
        5'b11011 : begin `CPU_ctrl_signals = {2'b11,1'b1,2'd2,1'b1,1'b0,1'b0,1'b0,1'b1,2'b00}; end //J 11
        5'b00100 : begin `CPU_ctrl_signals = {2'b00,1'b1,2'd0,1'b1,1'b1,1'b0,1'b0,1'b0,2'b10}; end
        
        default : begin `CPU_ctrl_signals = {2'd0,1'b0,2'd0,1'b0,1'b0,1'b0,1'b0,1'b0,2'b11}; end
        endcase
    end
        
       assign Fun = {Fun3,Fun7};
       always @(*) begin
            case(ALUop)
            2'b00: ALUC = 3'b010;
            2'b01: ALUC = 3'b110;
            2'b10: case(Fun)
                    4'b0000:ALUC = 3'b010;
                    4'b0001:ALUC =  3'b110;
                    4'b1110:ALUC =  3'b000;
                    4'b1100:ALUC = 3'b001;
                    4'b0100:ALUC = 3'b111;
                    4'b1010:ALUC = 3'b101;
                    4'b1000:ALUC = 3'b011;
                   default: ALUC = 3'bx;
                   endcase
           2'b11: case(Fun3)
                   3'b000:ALUC = 3'b010;  //addi
                   3'b001:ALUC =  3'b101;
                   3'b100:ALUC = 3'b011;
                   3'b101:ALUC = 3'b101;  //xori
                   3'b101:ALUC = 3'b101;
                   3'b100:ALUC = 3'b011;
                  default: ALUC = 3'bx;
                  endcase
          endcase
          end
endmodule
