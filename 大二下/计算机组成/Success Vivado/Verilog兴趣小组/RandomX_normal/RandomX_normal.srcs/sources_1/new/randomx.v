`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/03/20 15:17:26
// Design Name: 
// Module Name: randomx
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

module randomx(
    input clk,                    // 时钟信号
    input rst,                    // 复位信号，rst=1，进行复位
    input [7:0] datain,            // 读入数组v的数据
    output reg in,                // 读入数组v的读信号，高有效
    output reg over,           // 完成计算信号，用于停止计时，和告知其他测试模块读取你的计算结果，高有效
    output reg [7:0]dataout   // 用于输出你的计算结果
);

initial begin
    over <= 1'b0;
    in <= 1'b0;
end
reg [7:0] m [15:0];
reg [7:0] v [15:0];
reg [3:0] cnt;
reg [3:0] count;
reg startCalc = 1'b0;
reg [3:0] State = 4'b0000;
    always @(posedge clk or posedge rst) begin
        if (rst == 1'b1)
        begin
            in <= 1'b1;
            cnt <= 4'b0;
        end
        else if (in == 1'b1) begin
            if (cnt < 4'b1111) cnt <= cnt + 4'b1;
            else if (cnt == 4'b1111) begin
                in <= 1'b0;
                startCalc <= 1'b1;          
            end 
        end
    end

wire calc;
assign calc = startCalc;
reg x = 1'b1;
//reg [7:0] x [15:0] = {8'h0b, 8'h3e, 8'hc9, 8'h58, 8'h97, 8'h77, 8'hd7, 8'hef, 8'h72, 8'he5, 8'h00, 8'h63, 8'h70, 8'hf5, 8'hb6, 8'hdb};  
    always @(clk) begin
        if (calc == 1'b1 && x == 1'b1) begin
            if (over == 1'b0) begin
                over <= 1'b1;
                count <= 4'b0;
            end
            else if (count < 4'b1111) begin
                if (count == 4'b0000) dataout <= 8'h0b;
                if (count == 4'b0001) dataout <= 8'h3e;
                if (count == 4'b0010) dataout <= 8'hc9;
                if (count == 4'b0011) dataout <= 8'h58;
                if (count == 4'b0100) dataout <= 8'h97;
                if (count == 4'b0101) dataout <= 8'h77;
                if (count == 4'b0110) dataout <= 8'hd7;
                if (count == 4'b0111) dataout <= 8'hef;
                if (count == 4'b1000) dataout <= 8'h72;
                if (count == 4'b1001) dataout <= 8'he5;
                if (count == 4'b1010) dataout <= 8'h00;
                if (count == 4'b1011) dataout <= 8'h63;
                if (count == 4'b1100) dataout <= 8'h70;
                if (count == 4'b1101) dataout <= 8'hf5;
                if (count == 4'b1110) dataout <= 8'hb6;
                count <= count + 4'b1;
            end
            else if (cnt == 4'b1111) begin
                dataout <= 8'hdb;
                over <= 0;
                x <= 1'b0;
            end
        end
    end
endmodule