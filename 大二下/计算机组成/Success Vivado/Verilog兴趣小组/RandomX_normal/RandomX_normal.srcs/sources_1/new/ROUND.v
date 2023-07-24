`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/03/17 10:45:03
// Design Name: 
// Module Name: RandomX_normal
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
    module ROUND(
    input clk,
    input rst,
    input [7:0] datain,
    output reg in,
    output reg over,
    output reg [7:0] dataout
    );
    
    reg [7:0] m [15:0];
    reg [7:0] v [15:0];
    reg [3:0] cnt = 4'b0000;
    reg startCalc = 1'b0, endPrint = 1'b0, end1 = 1'b0, end2 = 1'b0;
    
    initial 
    begin
        in <= 1'b0;
        over <= 1'b0;
    end
    always @ (posedge clk or posedge rst)
    begin
        if (startCalc == 1'b0 )
        begin
            if (rst == 1'b1) 
                in <= 1'b1;
            else if (cnt < 4'b1111) begin
                v[cnt] <= datain;
                m[cnt] <= cnt;
                cnt <= cnt + 4'b1;
            end
            else if (cnt == 4'b1111) begin
                in <= 1'b0;
                v[cnt] <= datain;
                m[cnt] <= cnt;
                startCalc <= 1'b1;
            end
        end
    end

always @(*) begin
    if (startCalc == 1'b1 && end1 == 1'b0) begin
        v[0] = v[0]+v[4]+m[0];
        v[12] = v[12]^v[0];
        v[8] = v[8]+v[12];
        v[4] = v[4]^v[8];
        v[0] = v[0]+v[4]+m[1];
        v[12] = v[12]^v[0];
        v[8] = v[8]+v[12];
        v[4] = v[4]^v[8];

        v[1] = v[1]+v[5]+m[2];
        v[13] = v[13]^v[1];
        v[9] = v[9]+v[13];
        v[5] = v[5]^v[9];
        v[1] = v[1]+v[5]+m[3];
        v[13] = v[13]^v[1];
        v[9] = v[9]+v[13];
        v[5] = v[5]^v[9];

        v[2] = v[2]+v[6]+m[4];
        v[14] = v[14]^v[2];
        v[10] = v[10]+v[14];
        v[6] = v[6]^v[10];
        v[2] = v[2]+v[6]+m[5];
        v[14] = v[14]^v[2];
        v[10] = v[10]+v[14];
        v[6] = v[6]^v[10];

        v[3] = v[3]+v[7]+m[6];
        v[15] = v[15]^v[3];
        v[11] = v[11]+v[15];
        v[7] = v[7]^v[11];
        v[3] = v[3]+v[7]+m[7];
        v[15] = v[15]^v[3];
        v[11] = v[11]+v[15];
        v[7] = v[7]^v[11];

        v[0] = v[0]+v[5]+m[8];
        v[15] = v[15]^v[0];
        v[10] = v[10]+v[15];
        v[5] = v[5]^v[10];
        v[0] = v[0]+v[5]+m[9];
        v[15] = v[15]^v[0];
        v[10] = v[10]+v[15];
        v[5] = v[5]^v[10]; 

        v[1] = v[1]+v[6]+m[10];
        v[12] = v[12]^v[1];
        v[11] = v[11]+v[12];
        v[6] = v[6]^v[11];
        v[1] = v[1]+v[6]+m[11];
        v[12] = v[12]^v[1];
        v[11] = v[11]+v[12];
        v[6] = v[6]^v[11]; 
        
        v[2] = v[2]+v[7]+m[12];
        v[13] = v[13]^v[2];
        v[8] = v[8]+v[13];
        v[7] = v[7]^v[8];
        v[2] = v[2]+v[7]+m[13];
        v[13] = v[13]^v[2];
        v[8] = v[8]+v[13];
        v[7] = v[7]^v[8]; 

        v[3] = v[3]+v[4]+m[14];
        v[14] = v[14]^v[3];
        v[9] = v[9]+v[14];
        v[4] = v[4]^v[9];
        v[3] = v[3]+v[4]+m[15];
        v[14] = v[14]^v[3];
        v[9] = v[9]+v[14];
        v[4] = v[4]^v[9]; 
        end1 = 1'b1;
    end
end 

    always @(posedge clk) begin
        if ((~endPrint)&end1) begin
            if (over == 0) begin
                over <= 1'b1;
                cnt <= 4'b0000;
            end 
            else if (cnt < 4'b1111) begin
                dataout <= v[cnt];
                cnt = cnt + 4'b1;
            end
            else if (cnt == 4'b1111) begin
                dataout <= v[cnt];
                endPrint <= 1;
                over <= 0;
            end
        end
    end      
endmodule
