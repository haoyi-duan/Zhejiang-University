`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/27 07:42:22
// Design Name: 
// Module Name: RV32IPCU_C
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

//`define CPU_ctrl_signals \
//    {ImmSel, ALUSrc_B, DatatoReg, RegWrite, MemRead, MemWrite, Branch, Jump, ALUop, jen, rs1_used, rs2_used, CPU_MIO}   
    
    module RV32IPCU_C(
        input clk,
        input reset,
        input [4:0] OPcode,
        input [2:0] Fun3,
        input Fun7,
        input MIO_ready,
        input zero,
        //output reg jen,
        output reg ALUSrc_A,
        output reg ALUSrc_B,
        output reg [1:0]ImmSel,
        output reg [1:0]DatatoReg,
        output PCEN,
        output reg Jump,
        output reg Branch,
        output reg RegWrite,
        output reg WR,
        //output reg blt,
        output reg [2:0]ALUC,
        output reg rs1_used,
        output reg rs2_used,
        //output reg sign,
        output reg CPU_MIO,
        output ALE
        );
        
        //reg MemWrite;
        //reg MemRead;
        reg [1:0] ALUop;
        wire [3:0] Fun;
        //assign WR = MemWrite&&(~MemRead);
        assign ALE = ~clk;
        assign PCEN = 1; 
        
        always @* begin
            ALUSrc_A = 0;
            ALUSrc_B = 0;
            DatatoReg = 0;
            RegWrite = 0;
            Branch = 0;
            Jump = 0;
            WR = 0;
            CPU_MIO = 0;
            ALUop = 0;
            rs1_used = 0;
            rs2_used = 0;
            case (OPcode)
            5'b01100 : begin ALUop = 2'b10; RegWrite = 1; ALUSrc_B = 0; Branch = 0; Jump = 0; DatatoReg = 2'b00; rs1_used = 1; rs2_used = 1; end // ALU R-type
            5'b00000 : begin ALUop = 2'b00; RegWrite = 1; ImmSel = 2'b00; ALUSrc_B = 1; Branch = 0; Jump = 0; DatatoReg = 2'b01; rs1_used = 1; WR = 0; CPU_MIO = 1; end // load type 00
            5'b01000 : begin ALUop = 2'b00; RegWrite = 0; ImmSel = 2'b01; ALUSrc_B = 1; Branch = 0; Jump = 0; WR = 1; CPU_MIO = 1; rs1_used = 1; rs2_used = 1; end // store 01
            5'b11000 : begin ALUop = 2'b01; RegWrite = 0; ImmSel = 2'b10; ALUSrc_B = 0; Branch = 1; Jump = 0; rs1_used = 1; rs2_used = 1; end // Beq 10
            5'b11011 : begin RegWrite = 1; ImmSel = 2'b11; Jump = 1; DatatoReg = 2'b10; end // J 11
            5'b00100 : begin ALUop = 2'b11; RegWrite = 1; ImmSel = 2'b00; ALUSrc_B = 1; Branch = 0; Jump = 0; DatatoReg = 2'b00; rs1_used = 1; end // ALU addi
            default : begin ALUop = 2'b00; end 
            endcase
        end
            
           assign Fun = {Fun3,Fun7};
           always @(*) begin
                case(ALUop)
                    2'b00: ALUC = 3'b010;
                    2'b01: ALUC = 3'b110;
                    2'b10: case(Fun)
                        4'b0000:ALUC = 3'b010; //add
                        4'b0001:ALUC = 3'b110; //sub
                        4'b1110:ALUC = 3'b000; //and
                        4'b1100:ALUC = 3'b001; //or
                        4'b0100:ALUC = 3'b111; //slt
                        4'b1010:ALUC = 3'b101; //srl
                        4'b1000:ALUC = 3'b011; //xor
                       default: ALUC = 3'bx; 
                       endcase
                    2'b11: case(Fun3)
                        3'b000:ALUC = 3'b010;  //addi
                        3'b010:ALUC = 3'b111; //slti
                        3'b100:ALUC = 3'b011;  //xori
                        3'b101:ALUC = 3'b101;  //srli
                        3'b110:ALUC = 3'b001;  //ori
                        3'b111:ALUC = 3'b000; //andi
                        default: ALUC = 3'bx;
                        endcase
                    default: ALUC = 3'bx;
                endcase
              end
    endmodule
