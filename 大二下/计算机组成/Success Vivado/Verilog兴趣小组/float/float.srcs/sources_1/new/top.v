`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/17 10:36:28
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
       output [7:0] datainA,
       output [7:0] datainB,
       output in,
       output out,
       output sub,
       output [7:0] dataout,
       output [3:0] bigE, smallE, bigM, smallM,
       output bigS, smallS,
       output s, change,///
       output [3:0] round_exp, exp_diff, shift, final_exp,///
       output [2:0] final_result,///
       output [7:0] ll, ss, result, round_result,///
       output NanBig, InfBig, NanSmall, InfSmall, trueSub,///
       output is_nan, is_inf, z3, z2, z1, z0, carry, over_flow///
   );

reg [4:0] addr;    
always @(posedge clk or posedge rst) begin
   if(rst == 1'b1) begin
       addr = 5'b0;
   end  
   else if(in == 1'b1) begin       
       addr = addr + 5'b1;
   end
end

       ROM ROM_NEW(
           .a(addr),
           .spo({datainA, datainB, sub})
       );
       
 float8 calc(
          .clk(clk),
          .rst(rst),
          .in(in),
          .datainA(datainA),
          .datainB(datainB),
          .sub(sub),
          .out(out),
          .dataout(dataout),
          .bigS(bigS),
          .bigE(bigE),
          .bigM(bigM),
          .smallS(smallS),
          .smallE(smallE),
          .smallM(smallM),
          .s(s), 
          .change(change),///
          .round_exp(round_exp), 
          .exp_diff(exp_diff), 
          .shift(shift),///
          .final_result(final_result),///
          .ll(ll), 
          .ss(ss), 
          .result(result), 
          .round_result(round_result),///
          .NanBig(NanBig), 
          .InfBig(InfBig), 
          .NanSmall(NanSmall), 
          .InfSmall(InfSmall), 
          .trueSub(trueSub),///
          .is_nan(is_nan), 
          .is_inf(is_inf), 
          .z3(z3), 
          .z2(z2), 
          .z1(z1), 
          .z0(z0), 
          .carry(carry), 
          .over_flow(over_flow), 
          .final_exp(final_exp)///
          );
   endmodule
