`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/03/10 22:44:35
// Design Name: 
// Module Name: regs_sim
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

module regs_sim;

reg clk, rst, RegWrite;
reg [4:0] Rs1_addr, Rs2_addr, Wt_addr;
reg [31:0] Wt_data;
wire [31:0] Rs1_data, Rs2_data;

regs regs_u(
    .clk(clk),
    .rst(rst),
    .RegWrite(RegWrite),
    .Rs1_addr(Rs1_addr),
    .Rs2_addr(Rs2_addr),
    .Wt_addr(Wt_addr),
    .Wt_data(Wt_data),
    .Rs1_data(Rs1_data),
    .Rs2_data(Rs2_data)
);

integer i = 0;
initial begin
clk = 0;
rst = 1;
Wt_addr = 5'b0_0000;
Wt_data = 32'h0000_0000;
RegWrite = 0;
Rs1_addr = 5'b0_0000;
Rs2_addr = 5'b0_0000;
fork
    forever #20 clk <= ~clk;
    #10 rst = 0;
    begin
    for (i = 0; i < 32; i = i+2) begin
        Wt_addr <= i;
        Rs1_addr <= i;
        Rs2_addr <= i;
        Wt_data <= 32'hAAAA_AAA0 + i;
        #10; RegWrite <= 1;
        #15; RegWrite <= 0;
        #5;
        Wt_addr <= i+1;
        Rs1_addr <= i+1;
        Rs2_addr <= i+1;
        Wt_data <= 32'h55555551+i;
        #20; RegWrite <= 1;
        #15; RegWrite <= 0;
        #15;
    end
    RegWrite = 0;
    for (i = 0; i < 32; i = i+1) begin
        #30 Wt_addr <= i;
            Rs1_addr <= i;
            Rs2_addr <= i;     
    end
    end
join
end 
endmodule