`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/03/11 14:56:16
// Design Name: 
// Module Name: mod60_sim
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


module mod60_sim;
reg clk;
reg rst;
wire [7:0]mod60;

mod60 mod60_U(
    .clk(clk),
    .rst(rst),
    .mod60(mod60)
);

initial begin
    rst = 1;
    clk = 0;
    #5;
    rst = 0;

end

always @ (*)
begin
    #20;
    clk <= ~clk;
end
endmodule
