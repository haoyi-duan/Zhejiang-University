`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/03/05 11:58:19
// Design Name: 
// Module Name: add_32
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


module add_32(
    input [31:0]a,
    input [31:0]b, 
    output [31:0]c
    );
    wire [30:0] cin;
    addr u1 (
        .a0     (a[0]), 
        .b0     (b[0]), 
        .c0     (1'b0), 
        .out1   (c[0]), 
        .c1     (cin[0])
        );
    
    addr u2 (
        .a0     (a[1]), 
        .b0     (b[1]), 
        .c0     (cin[0]), 
        .out1   (c[1]), 
        .c1     (cin[1])
        );
        
    addr u3 (
        .a0     (a[2]), 
        .b0     (b[2]), 
        .c0     (cin[1]), 
        .out1   (c[2]), 
        .c1     (cin[2])
        );
        
 addr u4 (
               .a0     (a[3]), 
               .b0     (b[3]), 
               .c0     (cin[2]), 
               .out1   (c[3]), 
               .c1     (cin[3])
               );  
               
addr u5 (
.a0     (a[4]), 
.b0     (b[4]), 
.c0     (cin[3]), 
.out1   (c[4]), 
.c1     (cin[4])
);            
addr u6 (
.a0     (a[5]), 
.b0     (b[5]), 
.c0     (cin[4]), 
.out1   (c[5]), 
.c1     (cin[5])
);   
addr u7 (
.a0     (a[6]), 
.b0     (b[6]), 
.c0     (cin[5]), 
.out1   (c[6]), 
.c1     (cin[6])
);              
addr u8 (
.a0     (a[7]), 
.b0     (b[7]), 
.c0     (cin[6]), 
.out1   (c[7]), 
.c1     (cin[7])
);            
addr u9 (
.a0     (a[8]), 
.b0     (b[8]), 
.c0     (cin[7]), 
.out1   (c[8]), 
.c1     (cin[8])
);            
addr u10 (
.a0     (a[9]), 
.b0     (b[9]), 
.c0     (cin[8]), 
.out1   (c[9]), 
.c1     (cin[9])
);            
addr u11 (
.a0     (a[10]), 
.b0     (b[10]), 
.c0     (cin[9]), 
.out1   (c[10]), 
.c1     (cin[10])
);             
addr u12 (
.a0     (a[11]), 
.b0     (b[11]), 
.c0     (cin[10]), 
.out1   (c[11]), 
.c1     (cin[11])
);               
addr u13 (
.a0     (a[12]), 
.b0     (b[12]), 
.c0     (cin[11]), 
.out1   (c[12]), 
.c1     (cin[12])
);        
addr u14 (
.a0     (a[13]), 
.b0     (b[13]), 
.c0     (cin[12]), 
.out1   (c[13]), 
.c1     (cin[13])
);   
addr u15 (
.a0     (a[14]), 
.b0     (b[14]), 
.c0     (cin[13]), 
.out1   (c[14]), 
.c1     (cin[14])
);   
addr u16 (
.a0     (a[15]), 
.b0     (b[15]), 
.c0     (cin[14]), 
.out1   (c[15]), 
.c1     (cin[15])
);   
addr u17 (
.a0     (a[16]), 
.b0     (b[16]), 
.c0     (cin[15]), 
.out1   (c[16]), 
.c1     (cin[16])
);   
addr u18 (
.a0     (a[17]), 
.b0     (b[17]), 
.c0     (cin[16]), 
.out1   (c[17]), 
.c1     (cin[17])
);   
addr u19 (
.a0     (a[18]), 
.b0     (b[18]), 
.c0     (cin[17]), 
.out1   (c[18]), 
.c1     (cin[18])
);   
addr u20 (
.a0     (a[19]), 
.b0     (b[19]), 
.c0     (cin[18]), 
.out1   (c[19]), 
.c1     (cin[19])
);   
addr u21 (
.a0     (a[20]), 
.b0     (b[20]), 
.c0     (cin[19]), 
.out1   (c[20]), 
.c1     (cin[20])
);   
addr u22 (
.a0     (a[21]), 
.b0     (b[21]), 
.c0     (cin[20]), 
.out1   (c[21]), 
.c1     (cin[21])
);   
addr u23 (
.a0     (a[22]), 
.b0     (b[22]), 
.c0     (cin[21]), 
.out1   (c[22]), 
.c1     (cin[22])
);   
addr u24 (
.a0     (a[23]), 
.b0     (b[23]), 
.c0     (cin[22]), 
.out1   (c[23]), 
.c1     (cin[23])
);   
addr u25 (
.a0     (a[24]), 
.b0     (b[24]), 
.c0     (cin[23]), 
.out1   (c[24]), 
.c1     (cin[24])
);   
addr u26 (
.a0     (a[25]), 
.b0     (b[25]), 
.c0     (cin[24]), 
.out1   (c[25]), 
.c1     (cin[25])
);   
addr u27 (
.a0     (a[26]), 
.b0     (b[26]), 
.c0     (cin[25]), 
.out1   (c[26]), 
.c1     (cin[26])
);   
addr u28 (
.a0     (a[27]), 
.b0     (b[27]), 
.c0     (cin[26]), 
.out1   (c[27]), 
.c1     (cin[27])
);   
addr u29 (
.a0     (a[28]), 
.b0     (b[28]), 
.c0     (cin[27]), 
.out1   (c[28]), 
.c1     (cin[28])
);   
addr u30 (
.a0     (a[29]), 
.b0     (b[29]), 
.c0     (cin[28]), 
.out1   (c[29]), 
.c1     (cin[29])
);   
addr u31 (
.a0     (a[30]), 
.b0     (b[30]), 
.c0     (cin[29]), 
.out1   (c[30]), 
.c1     (cin[30])
);   
addr u32 (
.a0     (a[31]), 
.b0     (b[31]), 
.c0     (cin[30]), 
.out1   (c[31]), 
.c1     (cin[31])
);   

endmodule
