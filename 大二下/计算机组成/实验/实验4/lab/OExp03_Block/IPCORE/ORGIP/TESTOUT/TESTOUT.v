`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/02/21 20:12:27
// Design Name: 
// Module Name: SWOUT
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
module    TESTO(input[15:0] SWO,
	            input [31:0] DIVO,
	            input [7:0]blink,

                output Buzzer,
                output [63:0]points,
	            output [63:0]LES,
                output[31:0] PData,
                output [9:0]addr,
	            output ONE,
                output ZERO
                );
                             
    assign Buzzer  = DIVO[25] & SWO[8];
    assign LES = {64'h0000_0000_0000_0000};
    assign points = {DIVO[31:0], DIVO[31:13], 5'h0, 8'h00};
    assign PData = {SWO[13:0],SWO[15:0],2'b00};
    assign addr = {5'b00000,SWO[3],DIVO[27:24]};
    assign ONE =1'b1;
    assign ZERO = 1'b0;	

endmodule
