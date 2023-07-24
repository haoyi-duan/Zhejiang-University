`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/25 19:29:53
// Design Name: 
// Module Name: RV32IPDP_C
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


module RV32IPDP_C(
    input wire clk,
    input wire rst,
    input wire [31:0] inst_field,
    input wire [31:0] Data_in,
    input wire rs1_used,
    input wire rs2_used,
    input wire ALUSrc_A,
    input wire ALUSrc_B,
    input wire [2:0] ALUC,
    input wire [1:0] ImmSel,
    input wire [1:0] DatatoReg,
    input PCEN,
    input wire Jump,
    input wire Branch,
    input wire RegWrite,
    input wire WR,
    input wire MIO,
    input sign,
    //input jen,
    //input blt,
    
    output wire [31:0] PCOUT,
    output [31:0] ID_IR,
    output wire [31:0] Data_out,
    output wire MWR,
    output wire M_MIO,
    output wire [31:0] ALU_out,
    output overflow,
    output zero,
    
    output [31:0]rs1_data,
    output [31:0]rs2_data,
    output [31:0]Imm32,
    output reg [31:0]Wt_data,
    output [31:0]ALUA,
    output [31:0]ALUB,
    output BJ_stall,
    output Data_stall,
    output [1:0] PCSource,
    output wire [31:0] ID_PCurrent,
    output wire [31:0] EX_IR,
    output wire [31:0] EX_PCurrent,
    output wire [31:0] MEM_IR,
    output wire [31:0] MEM_PCurrent,
    output wire [31:0] MEM_Target,
    output wire [31:0] WB_IR,
    output wire [31:0] WB_PCurrent,
    input [6:0] Debug_addr,
    output [31:0] Debug_regs 
    );
    
//    wire [31:0]Branch_MUX_out;
//    wire [31:0]Jump_MUX_in;
//    wire [31:0]Jump_MUX_out;
    
    wire MEM_zero, MEM_Jump, MEM_Branch;
    //wire [31:0] MEM_ALUO;
    //assign ze = (MEM_blt == 1'b1) ? MEM_zero : ~MEM_zero;
    //assign branch = MEM_Branch & ze;
    
    //IF stage
    reg [31:0] PCNEXT;
    wire [31:0] PC_4 = PCOUT + 4;
    wire [31:0] PC_Jump = MEM_Target;
    wire [31:0] PC_Branch = MEM_Target;
    wire Btake = MEM_zero && MEM_Branch;
    assign PCSource = {MEM_Jump, Btake};
    wire PCWR = PCEN;
   
   always @* begin
    case (PCSource)
        2'b00: PCNEXT = PC_4;
        2'b01: PCNEXT = PC_Branch;
        2'b10: PCNEXT = PC_Jump;
        2'b11: PCNEXT = PC_4;
    endcase
   end
    
    REG32 PC
         (.CE(PCWR),
          .D(PCNEXT),
          .Q(PCOUT),
          .clk(clk),
          .rst(rst)
          );
    //IF/ID Latch          
    REG_IF_ID IFID(
        .clk(clk),
        .rst(rst),
        .EN(1'b1),
        .Data_stall(),
        .flush(),
        .PCOUT(PCOUT),
        .IR(inst_field),
        .ID_IR(ID_IR),
        .ID_PCurrent(ID_PCurrent)
    );
    
    //ID stage
    wire [4:0] rs1_addr = ID_IR[19:15];
    wire [4:0] rs2_addr = ID_IR[24:20];
    wire [4:0] rd_addr = ID_IR[11:7];
    wire [4:0] WB_rd;
    wire WB_RegWrite;

      regs DU2(
          .clk(clk),
          .rst(rst),
          .Wt_data(Wt_data),
          .rdata_A(rs1_data),
          .rdata_B(rs2_data),
          .R_addr_A(rs1_addr),
          .R_addr_B(rs2_addr),
          .Wt_addr(WB_rd),
          .L_S(WB_RegWrite),
          .Debug_addr(Debug_addr[4:0]),
          .Debug_regs(Debug_regs)
      );

    ImmGen ImmGen_0
         (.s(ImmSel),
          .sign(1),
          .o(Imm32),
          .I(ID_IR));
    
    //ID/EX Latch
    wire [31:0] EX_A, EX_B, EX_Imm32;
    wire [4:0] EX_rd;
    wire [2:0] EX_ALUC;
    wire [1:0] EX_DatatoReg;
    wire EX_ALUSrc_A, EX_ALUSrc_B, EX_Jump, EX_Branch, EX_RegWrite, EX_WR, EX_MIO, EX_sign;
          
    REG_ID_EX IDEX(
        .clk(clk),
        .rst(rst),
        .EN(1'b1),
        .flush(1'b0),
        .ID_IR(ID_IR),
        .ID_PCurrent(ID_PCurrent),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data),
        .Imm32(Imm32),
        .rd_addr(rd_addr),
        .ALUSrc_A(ALUSrc_A),
        .ALUSrc_B(ALUSrc_B),
        .ALUC(ALUC),
        .DatatoReg(DatatoReg),
        .RegWrite(RegWrite),
        .Jump(Jump),
        .Branch(Branch),
        .WR(WR),
        .MIO(MIO),
        .sign(sign),
        
        .EX_PCurrent(EX_PCurrent),
        .EX_IR(EX_IR),
        .EX_A(EX_A),
        .EX_B(EX_B),
        .EX_Imm32(EX_Imm32),
        .EX_rd(EX_rd),
        .EX_ALUSrc_A(EX_ALUSrc_A),
        .EX_ALUSrc_B(EX_ALUSrc_B),
        .EX_ALUC(EX_ALUC),
        .EX_DatatoReg(EX_DatatoReg),
        .EX_RegWrite(EX_RegWrite),
        .EX_Jump(EX_Jump),
        .EX_Branch(EX_Branch),
        .EX_WR(EX_WR),
        .EX_MIO(EX_MIO),
        .EX_sign(EX_sign)
    );        
    
    //EXE stage        
    wire [31:0] EX_ALUO;
    assign ALUA = EX_A;
    assign ALUB = EX_ALUSrc_B ? EX_Imm32 : EX_B;
    wire [31:0] EX_Target = EX_PCurrent + EX_Imm32;
                
    ALU_5359 ALU
         (.A(ALUA), 
          .B(ALUB),
          .sign(EX_sign),
          .ALU_operation(EX_ALUC),
          .res(EX_ALUO),
          .zero(zero)
          );
                
    //EX/MEM Latch
    wire [31:0] MEM_ALUO, MEM_Datao;
    wire [4:0] MEM_rd;
    wire [1:0] MEM_DatatoReg;
    wire MEM_RegWrite, MEM_WR, MEM_MIO;

    REG_EX_MEM EXMEM(
        .clk(clk),
        .rst(rst),
        .EN(1'b1),
        .flush(),
        .EX_IR(EX_IR),
        .EX_PCurrent(EX_PCurrent),
        .EX_B(EX_B), .EX_ALUO(EX_ALUO), .EX_Target(EX_Target), .zero(zero), .EX_rd(EX_rd),
        .EX_DatatoReg(EX_DatatoReg), .EX_RegWrite(EX_RegWrite), .EX_Jump(EX_Jump),
        .EX_Branch(EX_Branch), .EX_WR(EX_WR), .EX_MIO(EX_MIO),
        
        .MEM_PCurrent(MEM_PCurrent), .MEM_IR(MEM_IR), .MEM_ALUO(MEM_ALUO), .MEM_Datao(MEM_Datao),
        .MEM_Target(MEM_Target), .MEM_rd(MEM_rd), .MEM_DatatoReg(MEM_DatatoReg), .MEM_RegWrite(MEM_RegWrite),
        .MEM_zero(MEM_zero), .MEM_Jump(MEM_Jump), .MEM_Branch(MEM_Branch), .MEM_WR(MEM_WR), .MEM_MIO(MEM_MIO) );

    //MEM stage
    assign Data_out = MEM_Datao;
    assign ALU_out = MEM_ALUO;
    assign MWR = MEM_WR;
    assign M_MIO = MEM_MIO;
    wire [31:0] WB_ALUO, WB_MDR;
    wire [1:0] WB_DatatoReg;
    
    //MEM/WB Latch
    REG_MEM_WB MEMWB(
        .clk(clk), .rst(rst), .EN(1'b1), .MEM_IR(MEM_IR), .MEM_PCurrent(MEM_PCurrent),
        .MEM_ALUO(MEM_ALUO), .Datai(Data_in), .MEM_rd(MEM_rd),
        .MEM_DatatoReg(MEM_DatatoReg), .MEM_RegWrite(MEM_RegWrite),
        
        .WB_PCurrent(WB_PCurrent), .WB_IR(WB_IR), .WB_ALUO(WB_ALUO), .WB_MDR(WB_MDR),
        .WB_rd(WB_rd), .WB_DatatoReg(WB_DatatoReg), .WB_RegWrite(WB_RegWrite) 
    );
    
    // WB stage - - - - - - - - - - - - - - - - - - - - - - - - - -            
    always @* begin
        case (WB_DatatoReg)
            2'b00: Wt_data = WB_ALUO;
            2'b01: Wt_data = WB_MDR;
            2'b10: Wt_data = WB_PCurrent + 4;
            2'b11: Wt_data = WB_PCurrent + 4;
        endcase
    end    
  endmodule
    
    
    
    
    
    
    
    
  