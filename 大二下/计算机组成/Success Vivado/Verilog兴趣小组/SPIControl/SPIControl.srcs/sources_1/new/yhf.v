`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/21 19:29:59
// Design Name: 
// Module Name: yhf
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
module yhf(
        input clk,            
        input rst,            
        output ready,         

        output in,            
        input [8:0] inNum,   
        input [7:0] datain,   

        output reg out,              
        input [7:0] outNum,         
        output reg [7:0] dataout,    

        output reg cs_n,     
        output clk_o,         
        input  d_i,          
        output d_o           
       );

reg [8:0]rest_inNum;
reg [7:0]rest_outNum;
reg [2:0]cnt;
reg en;
reg ready_cnt;
reg clk_n, ready_n, in_n, d_on;

assign clk_o = clk_n;
assign ready = ready_n;
assign in = in_n;
assign d_o = d_on;

always @(posedge clk or posedge rst) begin
    if(rst == 1'b1) begin
        ready_n <= 1'b1;
        ready_cnt <= 1'b0;
        in_n <= 1'b0;
        out <= 1'b0;
        cs_n <= 1'b1;
        clk_n <= 1'b0;
        d_on <= 1'b0;
        dataout <= 8'h00;
    end
    else begin
        if(ready_n == 1'b0) begin
            if(ready_cnt == 1'b1) begin
                ready_n <= 1'b1;
                ready_cnt <= 1'b0;
            end
            else begin
                ready_n <= 1'b0;
                ready_cnt <= 1'b1;
            end
            cs_n <= 1'b1;
            in_n <= 1'b0;
            out <= 1'b0;
            clk_n <= 1'b0;
            d_on <= 1'b0;
            dataout <= 8'h00;
        end
        else begin
            if(cs_n == 1'b1) begin
                rest_inNum <= inNum;
                rest_outNum <= outNum;
                clk_n <= 1'b0;
                en <= 1'b0;
                out <= 1'b0;
                in_n <= 1'b0;
                cnt <= 7;
                dataout <= 8'h00;
                if(inNum > 0) begin
                    d_on <= datain[7];
                    cs_n <= 1'b0;
                end
                else if(outNum == 0) begin 
                    cs_n <= 1'b1;
                    ready_n <= 1'b0;
                end
                else begin
                    cs_n <= 1'b0;
                end
            end
            else begin
                if(rest_inNum > 0) begin
                    out <= 1'b0;
                    if(cnt == 0) begin
                        if(en == 1'b0) begin
                            clk_n <= 1'b1;
                            en <= 1'b1;
                            in_n <= 1'b0;
                            if(rest_inNum == 1) begin
                                rest_inNum = 0;
                                cnt <= 8;
                            end
                            else begin
                                rest_inNum <= rest_inNum - 1;
                                cnt <= 7;
                            end
                        end
                        else begin
                            in_n <= 1'b1;
                            clk_n <= 1'b0;
                            en <= 1'b0;
                            d_on <= datain[0];
                        end
                    end
                    else begin
                        in_n <= 1'b0;
                        if(en == 1'b0) begin
                            clk_n <= 1'b1;
                            en <= 1'b1;
                            cnt <= cnt - 1;
                        end
                        else begin
                            clk_n <= 1'b0;
                            d_on <= datain[cnt];
                            en <= 1'b0;
                        end
                    end
                end
                else if(rest_outNum > 0) begin
                    in_n <= 1'b0;
                    d_on <= 1'b0;
                    if(cnt == 0) begin
                        if(en == 1'b0) begin
                            clk_n <= 1'b1;
                            out <= 1'b0;
                            dataout[0] <= d_i;
                            en <= 1'b1;
                        end
                        else begin
                            clk_n <= 1'b0;
                            out <= 1'b1;
                            en <= 1'b0;
                            if(rest_outNum == 1) begin
                                rest_outNum = 0;
                                ready_n <= 1'b0;
                            end
                            else begin
                                rest_outNum <= rest_outNum - 1;
                                cnt <= 7;
                            end
                        end
                    end
                    else begin
                        out <= 1'b0;
                        if(en == 1'b0) begin
                            clk_n <= 1'b1;
                            en <= 1'b1;
                            dataout[cnt] <= d_i;
                        end
                        else begin
                            clk_n <= 1'b0;
                            en <= 1'b0;
                            cnt <= cnt - 1;
                        end
                    end 
                end
                else begin
                    clk_n <= 1'b0;
                    in_n <= 1'b0;
                    d_on <= 1'b0;
                    out <= 1'b0;
                    en <= 1'b0;
                    ready_n <= 1'b0;
                end
            end
        end
    end
end
endmodule
