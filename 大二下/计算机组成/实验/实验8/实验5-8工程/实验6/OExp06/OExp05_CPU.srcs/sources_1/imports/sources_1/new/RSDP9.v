`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/13 10:37:03
// Design Name: 
// Module Name: RSDP9
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
module RSDP9
   (input clk,
    input rst,
    input [31:0] inst_field,
    input [31:0] Data_in,
    input ALUSrc_B,
    input [2:0] ALUC,
    input [1:0] ImmSel,
    input [1:0] DatatoReg,
    input Jump,
    input Branch,
    input RegWrite,
    input [6:0] Debug_addr,
    
    output [31:0] Debug_regs,
    output [31:0] ALU_out,
    output [31:0] Data_out,
    output [31:0] PC_out,
    output zero,
    output overflow,
    output [31:0] rs1_data,
    output [31:0] Wt_data,
    output [31:0] ALUB);

  wire [31:0]ALU_res;
  wire [31:0]Imm;
  wire [31:0]Branch_MUX_out;
  wire [31:0]Jump_MUX_out;
  wire [31:0]REGS_din;
  wire [31:0]PC_Q;
  wire [31:0]REGS_douta;
  wire [31:0]REGS_doutb;
  wire [31:0]PC_plus_4;
  wire [31:0]PC_rel;
  wire branch;

  assign branch = Branch & zero;
  assign PC_plus_4 = PC_Q + 32'h4;
  assign PC_rel = PC_Q + Imm;
  
  assign ALU_out[31:0] = ALU_res;
  assign Data_out[31:0] = REGS_doutb;
  assign PC_out[31:0] = PC_Q;
  assign rs1_data = REGS_douta;
  assign Wt_data = REGS_din;
  
  ALU_5359 ALU
       (.A(REGS_douta), 
        .B(ALUB),
        .ALU_operation(ALUC),
        .res(ALU_res),
        .zero(zero),
        .overflow(overflow));
        
  ImmGen ImmGen_0
       (.s(ImmSel),
        .o(Imm),
        .I(inst_field));
        
  MUX2T1_32 Branch_MUX
       (.I0(PC_plus_4),
        .I1(PC_rel),
        .o(Branch_MUX_out),
        .s(branch));
        
  MUX2T1_32 Jump_MUX
       (.I0(Branch_MUX_out),
        .I1(PC_rel),
        .o(Jump_MUX_out),
        .s(Jump));
        
  MUX2T1_32 ALUB_MUX
       (.I0(REGS_doutb),
        .I1(Imm),
        .o(ALUB),
        .s(ALUSrc_B));
        
  MUX4T1_32 DatatoReg_MUX
       (.I0(ALU_res),
        .I1(Data_in),
        .I2(PC_plus_4),
        .I3(PC_plus_4),
        .o(REGS_din),
        .s(DatatoReg));
        
  REG32 PC
       (.CE(1'b1),
        .D(Jump_MUX_out),
        .Q(PC_Q),
        .clk(clk),
        .rst(rst));
       
  regs REGS
       (.clk(clk),
        .rst(rst),
        .Wt_data(REGS_din),
        .Rs1_data(REGS_douta),
        .Rs2_data(REGS_doutb),
        .Rs1_addr(inst_field[19:15]),
        .Rs2_addr(inst_field[24:20]),
        .Wt_addr(inst_field[11:7]),
        .RegWrite(RegWrite),
        .Debug_addr(Debug_addr),
        .Debug_regs(Debug_regs)
        );
        
endmodule