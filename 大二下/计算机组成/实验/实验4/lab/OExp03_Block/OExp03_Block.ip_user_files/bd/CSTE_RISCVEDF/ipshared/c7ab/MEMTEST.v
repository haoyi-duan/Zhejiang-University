`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/03/21 14:20:23
// Design Name: 
// Module Name: MEMTEST
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


module  MEMTEST(input MIO,
                input SWO13,
                input[31:0]ROMADDR,
                input[31:0]ROMData,
                input[31:0]RAMADDR,             
                input[31:0]RAMData,
                
                output[31:0]MEM_Data,
                output[31:0]MEM_Addr
                );
                

	assign MEM_Addr = SWO13 ? MIO ?  RAMADDR : 32'hFFFFFFFF
	                               : ROMADDR;
	assign MEM_Data = SWO13 ? MIO ?  RAMData : 32'hAA55AA55 
	                               : ROMData;

endmodule
