`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/03/19 09:53:01
// Design Name: 
// Module Name: Top
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

 module Top(
        input clk,
        input rst,
        output [7:0] datain,
        output in,
        output over,
        output [7:0] dataout
    );

reg [3:0] addr;    
always @(posedge clk or posedge rst) begin
    if(rst == 1'b1) begin
        addr = 4'b0;
    end  
    else if(in == 1'b1) begin       
        addr = addr + 4'b1;
    end
end

        RandomX_Rom ROM_NEW(
            .a(addr),
            .spo(datain)
        );
        
        RandomX_normal random_data(
            .clk(clk),
            .rst(rst),
            .datain(datain),
            .in(in),
            .over(over),
            .dataout(dataout)
            );
    endmodule
