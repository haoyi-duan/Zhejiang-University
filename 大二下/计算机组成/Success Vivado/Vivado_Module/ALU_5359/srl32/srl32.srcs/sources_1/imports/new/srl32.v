`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/03/05 23:00:06
// Design Name: 
// Module Name: srl32
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


module srl32(
    input [31:0]a,
    input [31:0]b,
    output reg [31:0]res
    );
    
    reg [4:0] s;
    initial begin 
        res <= a;  
        s <= b[10:6];
        while (s > 0) begin
            res <= {0, res[31:1]};
            s <= s-1'b1;
        end    
    end
endmodule
