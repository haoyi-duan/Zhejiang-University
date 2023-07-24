`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/03/11 14:24:59
// Design Name: 
// Module Name: mod60
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

module mod60(
    input clk,
    input rst,
    output [7:0] mod60
);

integer i = 0;

mod10 ten(
    .clk(clk),
    .rst(rst | mod60[7:4] == 4'b0110),
    .mod10(mod60[3:0])
);

mod10 one(
    .clk(mod60[3:0] == 4'b0000),
    .rst(rst | mod60[7:4] == 4'b0110),
    .mod10(mod60[7:4])
);

begin
    
end
endmodule
