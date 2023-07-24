`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/03/16 18:06:48
// Design Name: 
// Module Name: GPIO_5359
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


module GPIO_5359(
    input clk,
    input rst,
    input Start,
    input EN,
    input [31:0]PData,
    output [15:0]LED_out,
    output wire ledclk,
    output wire ledsout,
    output wire ledclrn,
    output wire LEDEN,
    output reg [15:0] GPIOf0
    );
    
    reg [15:0]LED;
    assign LED_out = LED;
    always @(negedge clk or posedge rst) begin
        if (rst) begin LED <= 16'hAA; GPIOf0 <= 0; end
        else if (EN) {GPIOf0[15:2], LED, GPIOf0[1:0]} <= PData;
            else begin LED <= LED; GPIOf0[15:0] <= GPIOf0[15:0]; end
        end
    P2S  PTLED (
        .clk(clk),
        .rst(rst),
        .Serial(Start),
        .P_Data(~LED),
        .s_clk(ledclk),
        .s_clrn(ledclrn),
        .sout(ledsout),
        .EN(LEDEN)
    );
    
endmodule
