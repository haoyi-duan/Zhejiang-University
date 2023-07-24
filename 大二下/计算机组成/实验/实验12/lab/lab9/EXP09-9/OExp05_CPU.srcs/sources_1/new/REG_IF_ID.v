`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/28 14:09:08
// Design Name: 
// Module Name: REG_IF_ID
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

module REG_IF_ID(
    input clk,
    input rst,
    input EN,                      //流水寄存器使能
    input Data_stall,              //数据竞争等待，保留
    input flush,                   //控制竞争清除并等待，保留
    input [31:0] PCOUT,            //指令存贮器指针
    input [31:0] IR,               //指令存储器输出
    
    output reg [31:0] ID_IR,      //取值锁存
    output reg [31:0] ID_PCurrent //当前存在指令地址
    );
    
    //reg[31:0]ID_PCurrent, ID_IR
    always @(posedge clk) begin
        if (rst) begin
            ID_IR <= 32'h0000_0000;        //复位清零
            ID_PCurrent <= 32'h0000_0000;  //复位清零
        end 
        else if (EN) begin
            ID_IR <= IR;            //锁存指令传送ID流水级译码
            ID_PCurrent <= PCOUT;   //传送当前取指PC，Branch/Jump指令计算目标地址（非PC+4）
        end           
        else begin
            ID_IR <= ID_IR;            //保持
            ID_PCurrent <= ID_PCurrent;   
        end
    end
endmodule


