`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/31 11:02:39
// Design Name: 
// Module Name: sim
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


module sim;
    reg clk;
    reg rst;
    reg [31:0] inst_field;
    reg [31:0] Data_in;
    reg ALUSrc_B;
    reg [2:0] ALUC;
    reg [1:0] ImmSel;
    reg [1:0] DatatoReg;
    reg Jump;
    reg Branch;
    reg RegWrite;
    reg [6:0] Debug_addr;
    
    wire [31:0] Debug_regs;
    wire [31:0] ALU_out;
    wire [31:0] Data_out;
    wire [31:0] PC_out;
    wire zero;
    wire overflow;
    wire [31:0] rs1_data;
    wire [31:0] Wt_data;
    wire [31:0] ALUB;
    
    RSDP9(
        .clk(clk),
        .rst(rst),
        .inst_field(inst_field),
        .Data_in(Data_in),
        .ALUSrc_B(ALUSrc_B),
        .ALUC(ALUC),
        .ImmSel(ImmSel),
        .DatatoReg(DatatoReg),
        .Jump(Jump),
        .Branch(Branch),
        .RegWrite(RegWrite),
        .Debug_addr(Debug_addr),
        
        .Debug_regs(Debug_regs),
        .ALU_out(ALU_out),
        .Data_out(Data_out),
        .PC_out(PC_out),
        .zero(zero),
        .overflow(overflow),
        .rs1_data(rs1_data),
        .Wt_data(Wt_data),
        .ALUB(ALUB)
    );
parameter clk_period = 10;
    
    initial begin
        clk = 1;
        rst = 1;
        #clk_period;
        rst = 0;
    end
endmodule
