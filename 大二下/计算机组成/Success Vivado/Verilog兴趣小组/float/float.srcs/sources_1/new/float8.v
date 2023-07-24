`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/03/28 10:48:22
// Design Name: 
// Module Name: float8
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

module float8(
    input clk,
    input rst,
    output in,
    input [7:0] datainA,
    input [7:0] datainB,
    input sub,
    output reg out,
    output reg [7:0] dataout,
    output reg [3:0] bigE, smallE, bigM, smallM,
    output reg bigS, smallS,
    output reg s, change,///
    output reg [3:0] round_exp, exp_diff, shift, final_exp,///
    output reg [2:0] final_result,///
    output reg [7:0] ll, ss, result, round_result,///
    output reg NanBig, InfBig, NanSmall, InfSmall, trueSub,///
    output reg is_nan, is_inf, z3, z2, z1, z0, carry, over_flow///
    );
    
    reg in_a, start, step1, step2, step3, step4;
    reg [7:0] tmp;
    assign in = in_a;
    
//    reg [3:0] round_exp;
//    reg [3:0] exp_diff, shift;
//    reg [2:0] final_result;
//    reg bigS, smallS, change, s;
//    reg [3:0] bigE, smallE, round_exp;
//    reg [3:0] bigM, smallM, exp_diff, shift;
//    reg [6:0] ll, ss, result, round_result;
//    reg NanBig, InfBig, NanSmall, InfSmall, trueSub;
//    reg is_nan, is_inf, z3, z2, z1, z0, carry, over_flow, final_exp;

    always @(posedge clk or posedge rst) begin
        if (rst == 1) begin
            start <= 1'b0;
            step1 <= 1'b0;
            step2 <= 1'b0;
            step3 <= 1'b0;
            step4 <= 1'b0;
            in_a <= 1'b0;
            change <= 1'b0;
        end
        else begin
            if (start == 1'b0) begin
                start <= 1'b1;
                in_a <= 1'b1;
            end
            else if (in_a <= 1'b1 && step1 == 1'b0) begin
                in_a <= 1'b0;
                step1 <= 1'b1;
                
                bigS = datainA[7];
                bigE = datainA[6:3];
                bigM = {1'b0, datainA[2:0]};
                
                smallS = datainB[7];
                smallE = datainB[6:3];
                smallM = {1'b0, datainB[2:0]};
                
                if ((smallE > bigE) || ((smallE == bigE) && (smallM > bigM))) begin
                    bigS = datainB[7];
                    bigE = datainB[6:3];
                    bigM = {1'b0, datainB[2:0]};
                
                    smallS = datainA[7];
                    smallE = datainA[6:3];
                    smallM = {1'b0, datainA[2:0]};
                    
                    change = 1'b1;
                end
                
                s = change ? sub^datainB[7] : datainA[7];
                NanBig = (bigE == 4'b1111 && bigM != 4'b0000);
                InfBig = (bigE == 4'b1111 && bigM == 4'b0000);
                NanSmall = (smallE == 4'b1111 && smallM != 4'b0000);
                InfSmall = (smallE == 4'b1111 && smallM == 4'b0000);
                
                trueSub = (sub == 1'b0 && bigS != smallS) || (sub == 1'b1 && bigS == smallS);
                is_nan = NanBig || NanSmall || (trueSub && InfBig && InfSmall);
                is_inf = InfBig || InfSmall;
                if (bigE != 0) bigM = bigM + 4'b1000;
                if (smallE != 0) smallM = smallM + 4'b1000;
                step1 <= 1'b1;
            end 
            else if (step2 == 1'b0) begin
                exp_diff = bigE - smallE;
                shift = (bigE != 0 && smallE == 0) ? (exp_diff-1) : exp_diff;
                
                ll = bigM << 3;
                ss = (smallM << 3) >> shift;
                result = (trueSub == 1'b0) ? (ll + ss) : (ll - ss);
                step2 <= 1'b1;
            end
            else if (step3 == 1'b0) begin
                if ((result >> 3) & (1 << 4)) begin
                    result = result >> 1;
                    bigE = bigE + 4'b0001;
                end
                else begin
                    if ((result >> 3) & (1 << 3)) begin
                        if (bigE == 4'b0000) bigE = 4'b0001;
                    end
                    else begin
                        tmp = result >> 3;
                        z3 = tmp[3]==1'b1;
                        z2 = tmp[2]==1'b1;
                        z1 = tmp[1]==1'b1;
                        z0 = tmp[0]==1'b1;
                        shift = 0;
                        if (z3 == 0) begin
                            shift = shift + 1;
                            if (z2 == 0) begin
                                shift = shift + 1;
                                if (z1 == 0) begin
                                    shift = shift + 1;
                                    if (z0 == 0) begin
                                        shift = shift + 1;
                                    end
                                end
                            end
                        end
                        if (bigE > shift) begin
                            result = result << shift;
                            bigE = bigE - shift;
                        end
                        else begin
                            if (bigE != 0) begin result = result << (bigE - 1); end
                            bigE = 0;
                        end
                    end
                end
                step3 = 1'b1;
            end
            else if (step4 == 1'b0) begin
                z3 = (result&(1<<3))!=0 ? 1'b1 : 1'b0;
                z2 = (result&(1<<2))!=0 ? 1'b1 : 1'b0;
                z1 = (result&(1<<1))!=0 ? 1'b1 : 1'b0;
                z0 = (result&(1<<0))!=0 ? 1'b1 : 1'b0;
                carry = (z2 && (z1||z0)) || (z2 && !z1 && !z0 && z3);
                
                round_result = (result >> 3) + (carry ? 1'b1: 1'b0);
                round_exp = bigE;
                if (round_result & (1<<4)) round_exp = round_exp + 1'b1;
                over_flow = (bigE >= 4'b1111) | (round_exp >= 4'b1111) ? 1'b1 : 1'b0;
                final_exp = over_flow==1'b1 ? 4'b1111 : round_exp;
                final_result = over_flow==1'b1 ? 4'b0000 : round_result & 7;
                if (is_nan) begin
                    final_exp = 4'b1111;
                    final_result = 3'b111;
                end
                else if (is_inf) begin
                    final_exp = 4'b1111;
                    final_result = 3'b000;
                end
                dataout[7] <= s;
                dataout[6:3] <= final_exp;
                dataout[2:0] <= final_result;
                step4 <= 1'b1;
                out <= 1'b1;
            end
            else if (step1 == 1'b1 && step2 == 1'b1 && step3 == 1'b1 && step4 == 1'b1) begin
                out <= 1'b0;
                in_a <= 1'b1;
                step1 <= 1'b0;
                step2 <= 1'b0;
                step3 <= 1'b0;
                step4 <= 1'b0;
                change <= 1'b0;
            end
        end
    end
endmodule