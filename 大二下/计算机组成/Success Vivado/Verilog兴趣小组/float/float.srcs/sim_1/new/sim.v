`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/18 01:08:14
// Design Name: 
// Module Name: sim
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


module sim;
reg clk;
reg rst;
wire [7:0]dataout;
wire [7:0] datainA;
wire [7:0] datainB;
wire in;
wire out;
wire sub;

wire [3:0] bigE, smallE, bigM, smallM;
wire bigS, smallS;
wire s, change;
wire [3:0] round_exp, exp_diff, shift, final_exp;
wire [2:0] final_result;
wire [7:0] ll, ss, result, round_result;
wire NanBig, InfBig, NanSmall, InfSmall, trueSub;
wire is_nan, is_inf, z3, z2, z1, z0, carry, over_flow;

top Top_U(
    .clk(clk),
    .rst(rst),
    .datainA(datainA),
    .datainB(datainB),
    .in(in),
    .out(out),
    .sub(sub),
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

parameter clk_period = 10;

initial begin
    clk = 1;
    rst = 1;
    #clk_period;
    rst = 0;
end

always #(clk_period) clk = ~clk;
endmodule