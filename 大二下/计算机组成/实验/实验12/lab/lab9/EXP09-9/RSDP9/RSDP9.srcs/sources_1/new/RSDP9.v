`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/08 08:58:32
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

module RSDP9(
    input clk,
    input rst,
    input [31:0] inst_field,
    input [31:0] Data_in,
    input ALUSrc_A,
    input ALUSrc_B,
    input [2:0] ALUC,
    input [1:0] ImmSel,
    input [1:0] DatatoReg,
    input PCEN,
    input Jump,
    input Branch,
    input RegWrite,
    input Sign,
    
    output [31:0] PCOUT,
    output [31:0] Data_out,
    output [31:0] ALU_out,
    output overflow,
    output zero,
    output [31:0] rs1_data,
    output [31:0] Wt_data,
    output [31:0] ALUA,
    output [31:0] ALUB,
    input [6:0] Debug_addr,
    output [31:0] Debug_regs
    );
    
    //PC寄存器写描述
        reg [31:0] PC;
        always @(posedge clk or posedge rst) begin
            if (rst == 1) begin
                PC <= 32'h0000_0000;
            end
            else if (PCEN) PC <= PC + 4;
            else PC <= PC;
        end
    
    wire [31:0] Rom_Addr = PC; //指令存储器地址通路
    wire [31:0] imm32;
    wire [31:0] PC_4 = PC + 4; //修改PC指针
    wire [4:0] rs1 = inst_field[19:15]; //REG Source 1 to rs1
    wire [4:0] rs2 = inst_field[24:20]; //REG Source 2 to rs2
    wire [4:0] rd = inst_field[11:7]; //REG Destination rd
    //wire [11:0] imm12 = inst_field[31:20]; //12位Immediate
    //wire [11:0] ims12 = {inst_field[31:25], inst_field[11:7]}; //12位store偏移立即数（地址）
    //wire [12:0] imsb12 = {inst_field[31], inst_field[7], inst_field[30:25], inst_field[11:8], 1'b0}; //13位branch偏移立即数（地址） 
    //wire [20:0] imj20 = {inst_field[31], inst_field[19:12], inst_field[20], inst_field[30:21]};
    // 21位Jump长偏移立即数（地址）
    //wire [19:0] imu20 = {inst_field[31:12]};
    // 20位高位Immediate
    
    //寄存器读通路
    wire [4:0] Reg_addr_A = rs1;
    wire [4:0] Reg_addr_B = rs2;
    wire [31:0] rdata_A, rdata_B;
    
    //寄存器写通路
    wire [4:0] Wt_addr = rd;
    
    //寄存器写数据通路（也是存储器读和PC保护通道。注意：不要重复，后继要扩展）
    
    //assign Wt_data = DatatoReg ? Data_in : ALU_out;
    
    ImmGen ImmGem(
        .s(ImmSel),
        .I(inst_field),
        .o(imm32)
    );
    
    //寄存器调用
    regs reg_files(
        .clk(clk),
        .rst(rst),
        .Rs1_addr(Reg_addr_A),
        .Rs2_addr(Reg_addr_B),
        .Wt_addr(Wt_addr),
        .Wt_data(Wt_data),
        .RegWrite(RegWrite),
        .Rs1_data(rdata_A),
        .Rs2_data(rdata_B)
    );
    
    //ALU输入通路
    wire [31:0] MUX_out;
    MUX2T1_32 MUX2T1_32_1(
    .s(Branch & zero),
    .I0(PC_4),
    .I1(PC + imm32),
    .o(MUX_out)
    );
    
    wire [31:0] ALU_B;
    MUX2T1_32 MUX2T1_32_0(
    .I0(rdata_A),
    .I1(imm32),
    .s(ALUSrc_B),
    .o(ALU_B)
    );
       
    wire [31:0] REG_D;
    MUX2T1_32 MUX2T1_32_3(
    .s(Jump),
    .I0(MUX_out),
    .I1(PC + imm32),
    .o(REG_D)
    );
    //ALU输出通路
    wire [31:0] Result;
    assign ALU_out = Result;
    ALU_5359 ALU(
        .A(rdata_A),
        .B(ALU_B),
        .ALU_operation(ALUC),
        .res(Result),
        .zero(zero)
    );
    //存储器通路
    assign Data_out = rdata_B;
    wire [31:0] Din = Data_out;
    wire [31:0] Ram_addr = ALU_out;
    //存储器读通路（也是寄存器与写数据通路，不必重复）
    MUX4T1_32 MUX4_T1_32_0(
    .s(DatatoReg),
    .I0(ALU_out),
    .I1(Data_in),
    .I2(PC_4),
    .I3(PC_4),
    .o(Wt_data)
    );
    
    REG32 PCC (
    .clk(clk),
    .rst(rst),
    .CE(1'b1),
    .D(REG_D),
    .Q(PCOUT)
    );
    endmodule
