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
    input EN,                      //��ˮ�Ĵ���ʹ��
    input Data_stall,              //���ݾ����ȴ�������
    input flush,                   //���ƾ���������ȴ�������
    input [31:0] PCOUT,            //ָ�������ָ��
    input [31:0] IR,               //ָ��洢�����
    
    output reg [31:0] ID_IR,      //ȡֵ����
    output reg [31:0] ID_PCurrent //��ǰ����ָ���ַ
    );
    
    //reg[31:0]ID_PCurrent, ID_IR
    always @(posedge clk) begin
        if (rst) begin
            ID_IR <= 32'h0000_0000;        //��λ����
            ID_PCurrent <= 32'h0000_0000;  //��λ����
        end 
        else if (EN) begin
            ID_IR <= IR;            //����ָ���ID��ˮ������
            ID_PCurrent <= PCOUT;   //���͵�ǰȡָPC��Branch/Jumpָ�����Ŀ���ַ����PC+4��
        end           
        else begin
            ID_IR <= ID_IR;            //����
            ID_PCurrent <= ID_PCurrent;   
        end
    end
endmodule


