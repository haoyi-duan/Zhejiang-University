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
                input[9:0]RAMADDR,             
                input[31:0]RAMData,
                
                output [9:0] addr2ram,
                output[31:0]MEM_Data,
                output[31:0]MEM_Addr
                );
    assign addr2ram  = MEM_Addr[11:2];               
	assign MEM_Addr = SWO13 ? MIO ?  {20'h00000, RAMADDR, 2'b00} : 32'hFFFFFFFF
//    assign MEM_Addr = SWO13 ? MIO ?  RAMADDR : 32'hFFFFFFFF
	                               : ROMADDR;
	assign MEM_Data = SWO13 ? MIO ?  RAMData : 32'hAA55AA55 
	                               : ROMData;

endmodule
