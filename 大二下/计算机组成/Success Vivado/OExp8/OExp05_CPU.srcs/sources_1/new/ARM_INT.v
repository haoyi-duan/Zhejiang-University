`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/25 22:08:19
// Design Name: 
// Module Name: ARM_INT
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


module ARM_INT(
    input clk,
    input rst,
    input INT,
    input INTA,
    input mret,
    input [31:0] PCNEXT,
    output INTR,
    output reg [31:0] PC
    );
    assign INTA = INT;
    reg int_act, int_en, int_req_r;
    reg [31:0] EPC;
    wire int_clr;
    reg [1:0] INT_get;
    //interrupt trigger
    assign INTR = int_act;
    assign int_clr = rst | ~int_act;
    
    always @(posedge clk) begin
        INT_get <= {INT_get[0], INT};
    end
    
    always @(posedge clk) begin
        if (INT_get == 2'b01) int_req_r <= 1;
        else if (int_clr) int_req_r <= 0;
    end
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin  EPC <= 0;
                        int_act <= 0;
                        int_en <= 1;
        end
        else if (int_req_r & int_en) begin
            int_act <= 1;
            int_en <= 0;
        end
        else begin if (INTA & int_act) begin
            int_act <= 0;
            EPC <= PCNEXT;
        end 
        if (mret) int_en <= 1;
    end
    end
    always @(*) begin
        if (rst == 1'b1) PC <= 32'h0000_0000;
        else if (INTA) PC <= 32'h0000_0004;
        else if (mret) PC <= EPC;
        else PC <= PCNEXT;
    end
        
endmodule
