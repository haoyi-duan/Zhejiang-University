`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/03/05 17:58:03
// Design Name: 
// Module Name: adc
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


module adc(
    input a0,
    input b0,
    input c0,
    input s, //指示加减法
    output reg out1,
    output reg c1    
    );
    always @(*)
    begin
    case (s)
    1'b0:   begin
            assign out1 = a0^b0^c0; 
            assign c1 = ((a0&b0)|(a0&c0)|(b0&c0));
            end
    1'b1:   begin
            assign out1 = (~a0&b0&~c0) | (a0&~b0&~c0) | (~a0&~b0&c0) | (a0&b0&c0);
            assign c1 = (~a0&b0&~c0) | (~a0&~b0&c0) | (~a0&b0&c0) | (a0&b0&c0);
            end
    endcase
    end
endmodule
