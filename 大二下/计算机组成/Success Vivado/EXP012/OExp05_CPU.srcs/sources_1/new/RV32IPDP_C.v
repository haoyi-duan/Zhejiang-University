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
    input jen,
    input blt,
    
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
    output J_stall,
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
    
    wire flush;
    wire MEM_zero, MEM_Jump, MEM_Branch;
    reg [1:0] ForwardA, ForwardB;
    reg [1:0] Forwards1, Forwards2;
    //IF stage
    wire MEM_blt, ID_zero;
    wire [31:0] ID_ALUA, ID_ALUB;
    assign ID_zero = (ID_ALUA==ID_ALUB) ? 1 : 0;
    //wire Btake = ((blt == 1) ? ID_zero : ~ID_zero) && Branch;
    reg Btaken;
    reg [31:0] PCNEXT;
    wire [31:0] ID_Target = ID_PCurrent + Imm32;
    wire [31:0] PC_4 = PCOUT + 4;
    wire [31:0] PC_Jump = ID_Target;
    wire [31:0] PC_Branch = Btaken ? ID_Target : PCOUT;
    reg [31:0] ALUA_reg;
    reg HarzardLoad;
    
    assign PCSource = {Jump, Btaken};
//    wire PCWR = ~J_stall && ~Data_stall && PCEN;
    wire PCWR = ~Data_stall && PCEN;
    wire [31:0] MEM_ALUO;
    
    assign ID_ALUA = rs1_data;
    assign ID_ALUB = ALUSrc_B ? Imm32 : rs2_data;
    
   always @* begin
    case (PCSource)
        2'b00: PCNEXT = PC_4;
        2'b01: PCNEXT = PC_Branch;
        2'b10: PCNEXT = PC_Jump;
        2'b11: PCNEXT = rs1_data + Imm32;
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
        .Data_stall(Data_stall),
        .flush(BJ_stall),
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
    wire [4:0] EX_rd, EX_rs1, EX_rs2;
    wire [2:0] EX_ALUC;
    wire [1:0] EX_DatatoReg;
    wire EX_ALUSrc_A, EX_ALUSrc_B, EX_Jump, EX_Branch, EX_RegWrite, EX_WR, EX_MIO, EX_sign, EX_jen, EX_blt;
          
    REG_ID_EX IDEX(
        .clk(clk),
        .rst(rst),
        .EN(1'b1),
        .flush(Data_stall),
        .ID_IR(ID_IR),
        .ID_PCurrent(ID_PCurrent),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data),
        .Imm32(Imm32),
        .rd_addr(rd_addr),
        .rs1_addr(rs1_addr),
        .rs2_addr(rs2_addr),
        .ALUSrc_A(ALUSrc_A),
        .ALUSrc_B(ALUSrc_B),
        .ALUC(ALUC),
        .DatatoReg(DatatoReg),
        .RegWrite(RegWrite),
        .Jump(Jump),
        .Branch(Branch),
        .WR(WR),
        .MIO(MIO),
        .jen(jen),
        .blt(blt),
        .sign(sign),
        
        .EX_PCurrent(EX_PCurrent),
        .EX_IR(EX_IR),
        .EX_A(EX_A),
        .EX_B(EX_B),
        .EX_Imm32(EX_Imm32),
        .EX_rd(EX_rd),
        .EX_rs1(EX_rs1),
        .EX_rs2(EX_rs2),
        .EX_ALUSrc_A(EX_ALUSrc_A),
        .EX_ALUSrc_B(EX_ALUSrc_B),
        .EX_ALUC(EX_ALUC),
        .EX_DatatoReg(EX_DatatoReg),
        .EX_RegWrite(EX_RegWrite),
        .EX_Jump(EX_Jump),
        .EX_Branch(EX_Branch),
        .EX_WR(EX_WR),
        .EX_MIO(EX_MIO),
        .EX_jen(EX_jen),
        .EX_blt(EX_blt),
        .EX_sign(EX_sign)
    );        
    
    //EXE stage        
    wire [31:0] EX_ALUO;
//    assign ALUA = EX_A;
//    assign ALUB = EX_ALUSrc_B ? EX_Imm32 : EX_B;
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
    wire [31:0] MEM_Datao;
    wire [4:0] MEM_rd;
    wire [1:0] MEM_DatatoReg;
    wire MEM_RegWrite, MEM_WR, MEM_MIO, MEM_jen;

    REG_EX_MEM EXMEM(
        .clk(clk),
        .rst(rst),
        .EN(1'b1),
        .flush(Data_stall),
        .EX_IR(EX_IR),
        .EX_PCurrent(EX_PCurrent),
        .EX_B(EX_B), .EX_ALUO(EX_ALUO), .EX_Target(EX_Target), .zero(zero), .EX_rd(EX_rd),
        .EX_DatatoReg(EX_DatatoReg), .EX_RegWrite(EX_RegWrite), .EX_Jump(EX_Jump),
        .EX_Branch(EX_Branch), .EX_WR(EX_WR), .EX_MIO(EX_MIO), .EX_jen(EX_jen), .EX_blt(EX_blt),
        
        .MEM_PCurrent(MEM_PCurrent), .MEM_IR(MEM_IR), .MEM_ALUO(MEM_ALUO), .MEM_Datao(MEM_Datao),
        .MEM_Target(MEM_Target), .MEM_rd(MEM_rd), .MEM_DatatoReg(MEM_DatatoReg), .MEM_RegWrite(MEM_RegWrite),
        .MEM_zero(MEM_zero), .MEM_Jump(MEM_Jump), .MEM_Branch(MEM_Branch), .MEM_WR(MEM_WR), .MEM_MIO(MEM_MIO), .MEM_jen(MEM_jen), .MEM_blt(MEM_blt) );

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
            2'b11: Wt_data = {WB_IR[31:12], 12'b0000_0000_0000};
        endcase
    end    
    
    // Hazards Detection bt Data dependence - - - - - - - - - - - - -
//    wire Hazards = (EX_RegWrite && EX_rd != 0 || MEM_RegWrite && MEM_rd != 0);
//    assign Data_stall = (rs1_used && rs1_addr != 0 && Harzard && (rs1_addr == EX_rd || rs1_addr == MEM_rd)) ||
//                        (rs2_used && rs2_addr != 0 && Harzard && (rs2_addr == EX_rd || rs2_addr == MEM_rd));
    assign Data_stall = HarzardLoad;
    // Hazards Detection bt Branch dependence - - - - - - - - - - - - 
    //assign BJ_stall = Branch || Jump || EX_Branch || EX_Jump || MEM_Branch || MEM_Jump;
    //assign J_stall = Branch || Jump || EX_Branch || EX_Jump;
    assign BJ_stall = Btaken || Jump;
    
        always@* begin
        case (ForwardA)
            2'b00: ALUA_reg = EX_A;
            2'b01: ALUA_reg = Wt_data;
            2'b10: ALUA_reg = MEM_ALUO;
            2'b11: ALUA_reg = EX_A;
        endcase
    end
    
    assign ALUA = ALUA_reg;
    
    always @* begin
        if (MEM_RegWrite && MEM_rd != 0 && EX_rs1 == MEM_rd) ForwardA = 2'b10;
        else if (WB_RegWrite && WB_rd != 0  && EX_rs1 == WB_rd) ForwardA = 2'b01;
        else ForwardA = 2'b00; 
    end

    reg [31:0] FEX_B;
    always @* begin
        case (ForwardB)
            2'b00: FEX_B = EX_B;
            2'b01: FEX_B = Wt_data;
            2'b10: FEX_B = MEM_ALUO;
            2'b11: FEX_B = EX_B;
        endcase
    end
    
    MUX2T1_32 ALUB_U(
        .I0(FEX_B),
        .I1(EX_Imm32),
        .s(EX_ALUSrc_B),
        .o(ALUB)
    );
    
    always @* begin
        if (MEM_RegWrite && MEM_rd != 0 && EX_rs2 == MEM_rd) ForwardB = 2'b10;
        else if (WB_RegWrite && WB_rd != 0 && EX_rs2 == WB_rd) ForwardB = 2'b01;
        else ForwardB = 2'b00;
    end

    always @* begin
        if (Branch && EX_RegWrite && EX_rd != 0 && rs1_addr != 0 && rs1_addr == EX_rd) Forwards1 = 2'b10;
        else if (Branch && MEM_RegWrite && MEM_rd != 0 && rs1_addr != 0 && rs1_addr == MEM_rd) Forwards1 = 2'b01;
        else Forwards1 = 2'b00;
        if (Branch && EX_RegWrite && EX_rd != 0 && rs2_addr != 0 && rs2_addr == EX_rd) Forwards2 = 2'b10;
        else if (Branch && MEM_RegWrite && MEM_rd != 0 && rs2_addr != 0 && rs2_addr == MEM_rd) Forwards2 = 2'b01;
        else Forwards2 = 2'b00;
     end

    reg Btmp;
    always @* begin
        case ({Forwards1, Forwards2})
            4'b0000: Btaken = Branch && rs1_data == rs2_data;
            4'b0010: Btaken = Branch && rs1_data == EX_ALUO;
            4'b0001: Btaken = Branch && rs1_data == MEM_ALUO;
            
            4'b1000: Btaken = Branch && EX_ALUO == rs2_data;
            4'b1010: Btaken = Branch && EX_ALUO == EX_ALUO;
            4'b1001: Btaken = Branch && EX_ALUO == MEM_ALUO;
            
            4'b0100: Btaken = Branch && MEM_ALUO == rs2_data;
            4'b0110: Btaken = Branch && MEM_ALUO == EX_ALUO;
            4'b0101: Btaken = Branch && MEM_ALUO == MEM_ALUO;
            default: Btaken = Branch && rs1_data == rs2_data;
        endcase
    end
       
    always @* begin
        HarzardLoad = 0;
        if (~EX_WR && EX_MIO && EX_rd != 0 && ((rs1_addr != 0 && rs1_addr == EX_rd) || (rs2_addr != 0 && rs2_addr == EX_rd))) 
            HarzardLoad = 1;
    end
    assign Data_stall = HarzardLoad;
  endmodule
    
    
    
    
    
    
    
    
  