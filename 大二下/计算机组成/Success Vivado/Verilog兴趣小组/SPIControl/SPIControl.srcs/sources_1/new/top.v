`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/15 21:19:28
// Design Name: 
// Module Name: top
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


module top(
       input clk,
       input rst,
       output [7:0] datain,
       output in,
       output [7:0] dataout,
       output out,
       output cs_n,
       output clk_o,
       output d_o,
       output reg d_i,
       output ready
   );

reg [4:0] addr;  
reg cnt; 
wire [8:0] inNum = 9'b0000_0_0001;
wire [7:0] outNum = 8'b0000_0001;

always @(posedge clk or posedge rst) begin
   if(rst == 1'b1) begin
       addr = 5'b0_0000;
       cnt = 0;
       d_i = 0;
   end  
   else if(in == 1'b1) begin       
       addr = addr + 5'b0_0001;
   end
   else if(cnt == 0) begin
        cnt = 1'b1;
        d_i = ~d_i;
   end
   else if (cnt == 1) begin
        cnt = 1'b0;
   end
   
end

       ROM data(
           .a(addr),
           .spo(datain)
       );
       
SPIControl U1
(
.clk(clk),
.rst(rst),
.ready(ready),
.in(in),
.inNum(inNum),
.datain(datain),
.out(out),
.outNum(outNum),
.dataout(dataout),
.cs_n(cs_n),
.clk_o(clk_o),
.d_i(d_i),
.d_o(d_o)
);
   endmodule