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
module    SWOUT(input[15:0] SWI,
                output SWO15,
                output SWO14,
                output SWO13,
                output[2:0]SWO765,
                output[1:0]SWO43,
                output SWO2,
                output SWO0,
                output SWO1,
                output[4:0] SWO13T8
                );
                             
    assign SWO15 = SWI[15];
    assign SWO14 = SWI[14];
    assign SWO13 = SWI[13];
    assign SWO765 = SWI[7:5];
    assign SWO43 = SWI[4:3];
    assign SWO2 = SWI[2];
    assign SWO1 = SWI[1];
    assign SWO0 = SWI[0];
    assign SWO13T8 = SWI[12:8];               

endmodule
