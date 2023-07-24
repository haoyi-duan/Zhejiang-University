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

`define CPU_ctrl_signals \
{ImmSel , ALUSrc_B , DatatoReg , RegWrite , MemRead , MemWrite , Branch, Jump, ALUop, jen, mret}   

module RSCU9(
    input clk,
    input reset,
    input [4:0]OPcode,
    input [2:0]Fun3,
    input Fun7,
    input MIO_ready,
    input zero,
    output reg jen,
    output reg ALUSrc_A,
    output reg ALUSrc_B,
    output reg [1:0]ImmSel,
    output reg [1:0]DatatoReg,
    output PCEN,
    output reg Jump,
    output reg Branch,
    output reg RegWrite,
    output WR,
    output reg blt,
    output reg [2:0]ALUC,
    output reg sign,
    output reg mret,
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
        5'b01100 : begin `CPU_ctrl_signals = {2'b00,1'b0,2'b00,1'b1,1'b0,1'b0,1'b0,1'b0,2'b10,1'b0,1'b0}; end // ALU R-type
        5'b00000 : begin `CPU_ctrl_signals = {2'b00,1'b1,2'b01,1'b1,1'b1,1'b0,1'b0,1'b0,2'b00,1'b0,1'b0}; end // I type 00
        5'b01000 : begin `CPU_ctrl_signals = {2'b01,1'b1,2'b00,1'b0,1'b0,1'b1,1'b0,1'b0,2'b00,1'b0,1'b0}; end // S 01
        5'b11000 : begin `CPU_ctrl_signals = {2'b10,1'b0,2'b10,1'b0,1'b0,1'b0,1'b1,1'b0,2'b01,1'b0,1'b0}; end // Beq 10
        5'b11011 : begin `CPU_ctrl_signals = {2'b11,1'b1,2'b10,1'b1,1'b0,1'b0,1'b0,1'b1,2'b00,1'b0,1'b0}; end // J 11
        5'b00100 : begin `CPU_ctrl_signals = {2'b00,1'b1,2'b00,1'b1,1'b1,1'b0,1'b0,1'b0,2'b11,1'b0,1'b0}; end // addi
        5'b01101 : begin `CPU_ctrl_signals = {2'b00,1'b1,2'b11,1'b1,1'b0,1'b0,1'b0,1'b0,2'b00,1'b0,1'b0}; end // lui
        5'b11001 : begin `CPU_ctrl_signals = {2'b00,1'b1,2'b10,1'b1,1'b0,1'b0,1'b0,1'b1,2'b00,1'b1,1'b0}; end // jalr
        5'b11100 : begin `CPU_ctrl_signals = {2'b00,1'b1,2'b10,1'b1,1'b0,1'b0,1'b0,1'b1,2'b00,1'b1,1'b1}; end // mret
        default : begin `CPU_ctrl_signals = {2'b00,1'b0,2'b00,1'b0,1'b0,1'b0,1'b0,1'b0,2'b11,1'b0,1'b0};  end 
        endcase
    end
        
       assign Fun = {Fun3,Fun7};
       always @(*) begin
            case(ALUop)
            2'b00: {ALUC, sign} = 4'b0101;
            2'b01: case(Fun3)
                3'b000: {ALUC, blt, sign} = 5'b1101_1; //beq
                3'b001: {ALUC, blt, sign} = 5'b1100_1; //bne
                3'b100: {ALUC, blt, sign} = 5'b1110_1; //blt
            endcase
            2'b10: case(Fun)
                    4'b0000:{ALUC, sign} = 4'b0101; //add
                    4'b0001:{ALUC, sign} = 4'b1101; //sub
                    4'b1110:{ALUC, sign} = 4'b0001; //and
                    4'b1100:{ALUC, sign} = 4'b0011; //or
                    4'b0100:{ALUC, sign} = 4'b1111; //slt
                    4'b0110:{ALUC, sign} = 4'b1110; //sltu
                    4'b1010:{ALUC, sign} = 4'b1011; //srl
                    4'b1000:{ALUC, sign} = 4'b0111; //xor
                   default: {ALUC, sign} = 4'bx; 
                   endcase
           2'b11: case(Fun3)
                   3'b000:{ALUC, sign} = 4'b0101;  //addi
                   3'b001:{ALUC, sign} = 4'b1011; //slli
                   3'b010:{ALUC, sign} = 4'b1111; //slti
                   3'b011:{ALUC, sign} = 4'b1110; //sltiu
                   3'b100:{ALUC, sign} = 4'b0111;  //xori
                   3'b101:{ALUC, sign} = 4'b1011;  //srli
                   3'b110:{ALUC, sign} = 4'b0011;  //ori
                   3'b111:{ALUC, sign} = 4'b0001; //andi
                  default: {ALUC, sign} = 4'bx;
                  endcase
          endcase
          end
endmodule
