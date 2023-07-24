//Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2017.4 (win64) Build 2086221 Fri Dec 15 20:55:39 MST 2017
//Date        : Sat Mar 13 10:13:20 2021
//Host        : LAPTOP-0HOK14LD running 64-bit major release  (build 9200)
//Command     : generate_target CSSTE.bd
//Design      : CSSTE
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module ARRARYBLOCK_imp_1HD2MIP
   (Ai,
    BTNO,
    Bi,
    CR,
    KCOL,
    KROW,
    RDY,
    RSTN,
    SW,
    SWO,
    SWO0,
    SWO1,
    SWO14,
    SWO2,
    SWO765,
    blink,
    clk_100mhz,
    readn,
    rst);
  output [31:0]Ai;
  output [3:0]BTNO;
  output [31:0]Bi;
  output CR;
  input [3:0]KCOL;
  output [4:0]KROW;
  output RDY;
  input RSTN;
  input [15:0]SW;
  output [15:0]SWO;
  output SWO0;
  output SWO1;
  output SWO14;
  output SWO2;
  output [2:0]SWO765;
  output [7:0]blink;
  input clk_100mhz;
  output readn;
  output rst;

  wire [3:0]KCOL_0_1;
  wire [31:0]M4_Ai;
  wire [31:0]M4_Bi;
  wire [7:0]M4_blink;
  wire M4_readn;
  wire RSTN_0_1;
  wire SWOTap_SWO0;
  wire SWOTap_SWO1;
  wire SWOTap_SWO14;
  wire SWOTap_SWO15;
  wire SWOTap_SWO2;
  wire [2:0]SWOTap_SWO765;
  wire [15:0]SW_0_1;
  wire [3:0]U9_BTNO;
  wire U9_CR;
  wire [4:0]U9_KCODE;
  wire U9_KRDY;
  wire [4:0]U9_KROW;
  wire [15:0]U9_SWO;
  wire U9_rst;
  wire clk_0_1;

  assign Ai[31:0] = M4_Ai;
  assign BTNO[3:0] = U9_BTNO;
  assign Bi[31:0] = M4_Bi;
  assign CR = U9_CR;
  assign KCOL_0_1 = KCOL[3:0];
  assign KROW[4:0] = U9_KROW;
  assign RDY = U9_KRDY;
  assign RSTN_0_1 = RSTN;
  assign SWO[15:0] = U9_SWO;
  assign SWO0 = SWOTap_SWO0;
  assign SWO1 = SWOTap_SWO1;
  assign SWO14 = SWOTap_SWO14;
  assign SWO2 = SWOTap_SWO2;
  assign SWO765[2:0] = SWOTap_SWO765;
  assign SW_0_1 = SW[15:0];
  assign blink[7:0] = M4_blink;
  assign clk_0_1 = clk_100mhz;
  assign readn = M4_readn;
  assign rst = U9_rst;
  CSSTE_EnterT32_0_0 M4
       (.Ai(M4_Ai),
        .ArrayKey(SWOTap_SWO15),
        .BTN(U9_BTNO),
        .Bi(M4_Bi),
        .DRDY(U9_KRDY),
        .Din(U9_KCODE),
        .TEST(SWOTap_SWO765),
        .Text(SWOTap_SWO0),
        .UP16(SWOTap_SWO1),
        .blink(M4_blink),
        .clk(clk_0_1),
        .readn(M4_readn));
  CSSTE_SWOUT_0_0 SWOTap
       (.SWI(U9_SWO),
        .SWO0(SWOTap_SWO0),
        .SWO1(SWOTap_SWO1),
        .SWO14(SWOTap_SWO14),
        .SWO15(SWOTap_SWO15),
        .SWO2(SWOTap_SWO2),
        .SWO765(SWOTap_SWO765));
  CSSTE_Arraykeys_0_0 U9
       (.BTNO(U9_BTNO),
        .CR(U9_CR),
        .KCODE(U9_KCODE),
        .KCOL(KCOL_0_1),
        .KRDY(U9_KRDY),
        .KROW(U9_KROW),
        .RSTN(RSTN_0_1),
        .SW(SW_0_1),
        .SWO(U9_SWO),
        .clk(clk_0_1),
        .readn(M4_readn),
        .rst(U9_rst));
endmodule

module CLKBLOCK_imp_1F57WKH
   (CPUClk,
    DIV,
    DIVO06,
    DIVO12,
    DIVO18T19,
    DIVO20,
    DIVO25,
    STEP,
    clk_100mhz,
    nCPUClk,
    rst);
  output CPUClk;
  output [31:0]DIV;
  output DIVO06;
  output DIVO12;
  output [1:0]DIVO18T19;
  output DIVO20;
  output DIVO25;
  input STEP;
  input clk_100mhz;
  output nCPUClk;
  input rst;

  wire DIVOTap_DIVO06;
  wire DIVOTap_DIVO12;
  wire [1:0]DIVOTap_DIVO18T19;
  wire DIVOTap_DIVO20;
  wire DIVOTap_DIVO25;
  wire STEP_0_1;
  wire U8_CPUClk;
  wire [31:0]U8_clkdiv;
  wire U8_nCPUClk;
  wire clk_0_2;
  wire rst_0_1;

  assign CPUClk = U8_CPUClk;
  assign DIV[31:0] = U8_clkdiv;
  assign DIVO06 = DIVOTap_DIVO06;
  assign DIVO12 = DIVOTap_DIVO12;
  assign DIVO18T19[1:0] = DIVOTap_DIVO18T19;
  assign DIVO20 = DIVOTap_DIVO20;
  assign DIVO25 = DIVOTap_DIVO25;
  assign STEP_0_1 = STEP;
  assign clk_0_2 = clk_100mhz;
  assign nCPUClk = U8_nCPUClk;
  assign rst_0_1 = rst;
  CSSTE_DIVO_0_0 DIVOTap
       (.DIV(U8_clkdiv),
        .DIVO06(DIVOTap_DIVO06),
        .DIVO12(DIVOTap_DIVO12),
        .DIVO18T19(DIVOTap_DIVO18T19),
        .DIVO20(DIVOTap_DIVO20),
        .DIVO25(DIVOTap_DIVO25));
  CSSTE_Clkdiv_0_0 U8
       (.CPUClk(U8_CPUClk),
        .STEP(STEP_0_1),
        .clk(clk_0_2),
        .clkdiv(U8_clkdiv),
        .nCPUClk(U8_nCPUClk),
        .rst(rst_0_1));
endmodule

(* CORE_GENERATION_INFO = "CSSTE,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=CSSTE,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=27,numReposBlks=20,numNonXlnxBlks=16,numHierBlks=7,maxHierDepth=1,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,synth_mode=Global}" *) (* HW_HANDOFF = "CSSTE.hwdef" *) 
module CSSTE
   (AN,
    Blue,
    Buzzer,
    CR,
    Green,
    HSYNC,
    KCOL,
    KROW,
    LED,
    LEDCK,
    LEDCR,
    LEDDT,
    LEDEN,
    RDY,
    RSTN,
    Red,
    SEGCK,
    SEGCR,
    SEGDT,
    SEGEN,
    SEGMENT,
    SW,
    VSYNC,
    clk_100mhz,
    readn);
  output [3:0]AN;
  output [3:0]Blue;
  output Buzzer;
  output CR;
  output [3:0]Green;
  output HSYNC;
  input [3:0]KCOL;
  output [4:0]KROW;
  output [7:0]LED;
  output LEDCK;
  output LEDCR;
  output LEDDT;
  output LEDEN;
  output RDY;
  input RSTN;
  output [3:0]Red;
  output SEGCK;
  output SEGCR;
  output SEGDT;
  output SEGEN;
  output [7:0]SEGMENT;
  input [15:0]SW;
  output VSYNC;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLK_100MHZ CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLK_100MHZ, ASSOCIATED_RESET RSTN, CLK_DOMAIN CSSTE_clk_100mhz, FREQ_HZ 100000000, PHASE 0.000" *) input clk_100mhz;
  output readn;

  wire [3:0]ARRARYBLOCK_BTNO;
  wire ARRARYBLOCK_SWO0;
  wire ARRARYBLOCK_SWO1;
  wire ARRARYBLOCK_SWO14;
  wire [2:0]ARRARYBLOCK_SWO765;
  wire [7:0]ARRARYBLOCK_blink;
  wire ARRARYBLOCK_rst;
  wire CLKBLOCK_CPUClk;
  wire [31:0]CLKBLOCK_DIV;
  wire CLKBLOCK_DIVO06;
  wire CLKBLOCK_DIVO12;
  wire [1:0]CLKBLOCK_DIVO18T19;
  wire CLKBLOCK_DIVO20;
  wire CLKBLOCK_DIVO25;
  wire CLKBLOCK_nCPUClk;
  wire [1:0]GPIOBLOCK_Dout;
  wire [3:0]KCOL_0_1;
  wire M4_readn;
  wire [15:0]Net;
  wire [31:0]RAM_B_douta;
  wire [31:0]ROM_D_spo;
  wire RSTN_0_1;
  wire STEP_1;
  wire [15:0]SW_0_1;
  wire TESTOTap_Buzzer;
  wire [63:0]TESTOTap_LES;
  wire TESTOTap_ONE;
  wire TESTOTap_ZERO;
  wire [63:0]TESTOTap_points;
  wire U10_counter0_OUT;
  wire U10_counter1_OUT;
  wire U10_counter2_OUT;
  wire [31:0]U10_counter_out;
  wire [3:0]U12_B;
  wire [3:0]U12_G;
  wire U12_HS;
  wire [3:0]U12_R;
  wire U12_VS;
  wire U1_ALE;
  wire [31:0]U1_Addr;
  wire [31:0]U1_Datao;
  wire [31:0]U1_Debug_data;
  wire [31:0]U1_PC;
  wire U1_WR;
  wire U4_CONT_W0208;
  wire [31:0]U4_Data2CPU;
  wire U4_GPIO_W0200;
  wire U4_GPIO_W0204;
  wire [31:0]U4_Peripheral;
  wire [31:0]U4_ram_data_in;
  wire [3:0]U61_AN;
  wire [7:0]U61_SEGMENT;
  wire U6_SEGEN;
  wire U6_segclk;
  wire U6_segclrn;
  wire U6_segsout;
  wire [7:0]U71_LED;
  wire U7_LEDEN;
  wire U7_ledclk;
  wire U7_ledclrn;
  wire U7_ledsout;
  wire U9_CR;
  wire U9_KRDY;
  wire [4:0]U9_KROW;
  wire [6:0]VGATEST_Debug_addr;
  wire [9:0]addra_1;
  wire clk_0_1;
  wire wea_1;

  assign AN[3:0] = U61_AN;
  assign Blue[3:0] = U12_B;
  assign Buzzer = TESTOTap_Buzzer;
  assign CR = U9_CR;
  assign Green[3:0] = U12_G;
  assign HSYNC = U12_HS;
  assign KCOL_0_1 = KCOL[3:0];
  assign KROW[4:0] = U9_KROW;
  assign LED[7:0] = U71_LED;
  assign LEDCK = U7_ledclk;
  assign LEDCR = U7_ledclrn;
  assign LEDDT = U7_ledsout;
  assign LEDEN = U7_LEDEN;
  assign RDY = U9_KRDY;
  assign RSTN_0_1 = RSTN;
  assign Red[3:0] = U12_R;
  assign SEGCK = U6_segclk;
  assign SEGCR = U6_segclrn;
  assign SEGDT = U6_segsout;
  assign SEGEN = U6_SEGEN;
  assign SEGMENT[7:0] = U61_SEGMENT;
  assign SW_0_1 = SW[15:0];
  assign VSYNC = U12_VS;
  assign clk_0_1 = clk_100mhz;
  assign readn = M4_readn;
  ARRARYBLOCK_imp_1HD2MIP ARRARYBLOCK
       (.BTNO(ARRARYBLOCK_BTNO),
        .CR(U9_CR),
        .KCOL(KCOL_0_1),
        .KROW(U9_KROW),
        .RDY(U9_KRDY),
        .RSTN(RSTN_0_1),
        .SW(SW_0_1),
        .SWO(Net),
        .SWO0(ARRARYBLOCK_SWO0),
        .SWO1(ARRARYBLOCK_SWO1),
        .SWO14(ARRARYBLOCK_SWO14),
        .SWO2(STEP_1),
        .SWO765(ARRARYBLOCK_SWO765),
        .blink(ARRARYBLOCK_blink),
        .clk_100mhz(clk_0_1),
        .readn(M4_readn),
        .rst(ARRARYBLOCK_rst));
  CLKBLOCK_imp_1F57WKH CLKBLOCK
       (.CPUClk(CLKBLOCK_CPUClk),
        .DIV(CLKBLOCK_DIV),
        .DIVO06(CLKBLOCK_DIVO06),
        .DIVO12(CLKBLOCK_DIVO12),
        .DIVO18T19(CLKBLOCK_DIVO18T19),
        .DIVO20(CLKBLOCK_DIVO20),
        .DIVO25(CLKBLOCK_DIVO25),
        .STEP(STEP_1),
        .clk_100mhz(clk_0_1),
        .nCPUClk(CLKBLOCK_nCPUClk),
        .rst(ARRARYBLOCK_rst));
  DISPBLOCK_imp_T0G5SY DISPBLOCK
       (.A0(TESTOTap_ZERO),
        .AN(U61_AN),
        .Data0(U4_Peripheral),
        .EN(U4_GPIO_W0204),
        .LES(TESTOTap_LES),
        .SEGCK(U6_segclk),
        .SEGCR(U6_segclrn),
        .SEGDT(U6_segsout),
        .SEGEN(U6_SEGEN),
        .SEGMENT(U61_SEGMENT),
        .Scan10(CLKBLOCK_DIVO18T19),
        .Scan2(ARRARYBLOCK_SWO1),
        .Start(CLKBLOCK_DIVO20),
        .Test(ARRARYBLOCK_SWO765),
        .Text(ARRARYBLOCK_SWO0),
        .clk(CLKBLOCK_nCPUClk),
        .clk_100mhz(clk_0_1),
        .data1(U1_PC),
        .data2(ROM_D_spo),
        .data3(U1_Addr),
        .data4(U4_Data2CPU),
        .data5(U1_Datao),
        .data6(CLKBLOCK_DIV),
        .data7(U10_counter_out),
        .flash(CLKBLOCK_DIVO25),
        .points(TESTOTap_points),
        .rst(ARRARYBLOCK_rst));
  GPIOBLOCK_imp_1XZRBBV GPIOBLOCK
       (.Dout(GPIOBLOCK_Dout),
        .EN(U4_GPIO_W0200),
        .LED(U71_LED),
        .LEDCK(U7_ledclk),
        .LEDCR(U7_ledclrn),
        .LEDDT(U7_ledsout),
        .LEDEN(U7_LEDEN),
        .PData(U4_Peripheral),
        .Start(CLKBLOCK_DIVO20),
        .clk1(CLKBLOCK_nCPUClk),
        .rst(ARRARYBLOCK_rst));
  RAM_B_imp_QDHJGA RAM_B
       (.addra(addra_1),
        .clka(U1_ALE),
        .dina(U4_ram_data_in),
        .douta(RAM_B_douta),
        .wea(wea_1));
  ROM_D_imp_I73H9X ROM_D
       (.Ain(U1_PC),
        .spo(ROM_D_spo));
  CSSTE_TESTO_0_0 TESTOTap
       (.Buzzer(TESTOTap_Buzzer),
        .DIVO(CLKBLOCK_DIV),
        .LES(TESTOTap_LES),
        .ONE(TESTOTap_ONE),
        .SWO(Net),
        .ZERO(TESTOTap_ZERO),
        .blink(ARRARYBLOCK_blink),
        .points(TESTOTap_points));
  CSSTE_MSCPUE_0_0 U1
       (.ALE(U1_ALE),
        .Addr(U1_Addr),
        .Datai(U4_Data2CPU),
        .Datao(U1_Datao),
        .Debug_addr(VGATEST_Debug_addr),
        .Debug_data(U1_Debug_data),
        .INST(ROM_D_spo),
        .PC(U1_PC),
        .Ready(TESTOTap_ONE),
        .TNI(ARRARYBLOCK_blink),
        .WR(U1_WR),
        .clk(CLKBLOCK_CPUClk),
        .reset(ARRARYBLOCK_rst));
  CSSTE_Counter_0_0 U10
       (.clk(CLKBLOCK_nCPUClk),
        .clk0(CLKBLOCK_DIVO06),
        .clk1(CLKBLOCK_DIVO20),
        .clk2(CLKBLOCK_DIVO12),
        .counter0_OUT(U10_counter0_OUT),
        .counter1_OUT(U10_counter1_OUT),
        .counter2_OUT(U10_counter2_OUT),
        .counter_ch(GPIOBLOCK_Dout),
        .counter_out(U10_counter_out),
        .counter_val(U4_Peripheral),
        .counter_we(U4_CONT_W0208),
        .rst(ARRARYBLOCK_rst));
  CSSTE_MIOBUS_0_0 U4
       (.Addr_bus(U1_Addr),
        .BTN(ARRARYBLOCK_BTNO),
        .C0(U10_counter0_OUT),
        .C1(U10_counter1_OUT),
        .C2(U10_counter2_OUT),
        .CONT_W0208(U4_CONT_W0208),
        .Counter(U10_counter_out),
        .Data2CPU(U4_Data2CPU),
        .Data4CPU(U1_Datao),
        .GPIO_W0200(U4_GPIO_W0200),
        .GPIO_W0204(U4_GPIO_W0204),
        .Peripheral(U4_Peripheral),
        .SW(Net),
        .clk(CLKBLOCK_nCPUClk),
        .data_ram_we(wea_1),
        .mem_w(U1_WR),
        .ram_addr(addra_1),
        .ram_data_in(U4_ram_data_in),
        .ram_data_out(RAM_B_douta),
        .rst(ARRARYBLOCK_rst));
  VGATEST_imp_YV2KUV VGATEST
       (.B(U12_B),
        .Debug_addr(VGATEST_Debug_addr),
        .Debug_data(U1_Debug_data),
        .G(U12_G),
        .HS(U12_HS),
        .MEM_Addr(U1_PC),
        .MEM_Data(ROM_D_spo),
        .R(U12_R),
        .SWO14(ARRARYBLOCK_SWO14),
        .VS(U12_VS),
        .clk_100mhz(clk_0_1),
        .rst(TESTOTap_ZERO));
endmodule

module DISPBLOCK_imp_T0G5SY
   (A0,
    AN,
    Data0,
    EN,
    LES,
    SEGCK,
    SEGCR,
    SEGDT,
    SEGEN,
    SEGMENT,
    Scan10,
    Scan2,
    Start,
    Test,
    Text,
    clk,
    clk_100mhz,
    data1,
    data2,
    data3,
    data4,
    data5,
    data6,
    data7,
    flash,
    points,
    rst);
  input A0;
  output [3:0]AN;
  input [31:0]Data0;
  input EN;
  input [63:0]LES;
  output SEGCK;
  output SEGCR;
  output SEGDT;
  output SEGEN;
  output [7:0]SEGMENT;
  input [1:0]Scan10;
  input Scan2;
  input Start;
  input [2:0]Test;
  input Text;
  input clk;
  input clk_100mhz;
  input [31:0]data1;
  input [31:0]data2;
  input [31:0]data3;
  input [31:0]data4;
  input [31:0]data5;
  input [31:0]data6;
  input [31:0]data7;
  input flash;
  input [63:0]points;
  input rst;

  wire A0_0_1;
  wire [31:0]Data0_0_1;
  wire EN_0_1;
  wire [63:0]LES_0_1;
  wire [1:0]Scan10_0_1;
  wire Scan2_0_1;
  wire Start_0_1;
  wire [2:0]Test_0_1;
  wire Text_0_1;
  wire [31:0]U5_Disp;
  wire [7:0]U5_LE;
  wire [7:0]U5_point;
  wire [3:0]U61_AN;
  wire [7:0]U61_SEGMENT;
  wire U6_SEGEN;
  wire U6_segclk;
  wire U6_segclrn;
  wire U6_segsout;
  wire clk_1_1;
  wire clk_2_1;
  wire [31:0]data1_0_1;
  wire [31:0]data2_0_1;
  wire [31:0]data3_0_1;
  wire [31:0]data4_0_1;
  wire [31:0]data5_0_1;
  wire [31:0]data6_0_1;
  wire [31:0]data7_0_1;
  wire flash_0_1;
  wire [63:0]points_0_1;
  wire rst_1_1;

  assign A0_0_1 = A0;
  assign AN[3:0] = U61_AN;
  assign Data0_0_1 = Data0[31:0];
  assign EN_0_1 = EN;
  assign LES_0_1 = LES[63:0];
  assign SEGCK = U6_segclk;
  assign SEGCR = U6_segclrn;
  assign SEGDT = U6_segsout;
  assign SEGEN = U6_SEGEN;
  assign SEGMENT[7:0] = U61_SEGMENT;
  assign Scan10_0_1 = Scan10[1:0];
  assign Scan2_0_1 = Scan2;
  assign Start_0_1 = Start;
  assign Test_0_1 = Test[2:0];
  assign Text_0_1 = Text;
  assign clk_1_1 = clk;
  assign clk_2_1 = clk_100mhz;
  assign data1_0_1 = data1[31:0];
  assign data2_0_1 = data2[31:0];
  assign data3_0_1 = data3[31:0];
  assign data4_0_1 = data4[31:0];
  assign data5_0_1 = data5[31:0];
  assign data6_0_1 = data6[31:0];
  assign data7_0_1 = data7[31:0];
  assign flash_0_1 = flash;
  assign points_0_1 = points[63:0];
  assign rst_1_1 = rst;
  CSSTE_DSEGIO_0_0 U5
       (.A0(A0_0_1),
        .Data0(Data0_0_1),
        .Disp(U5_Disp),
        .EN(EN_0_1),
        .LE(U5_LE),
        .LES(LES_0_1),
        .Test(Test_0_1),
        .clk(clk_1_1),
        .data1(data1_0_1),
        .data2(data2_0_1),
        .data3(data3_0_1),
        .data4(data4_0_1),
        .data5(data5_0_1),
        .data6(data6_0_1),
        .data7(data7_0_1),
        .point(U5_point),
        .points(points_0_1),
        .rst(rst_1_1));
  CSSTE_Display_0_0 U6
       (.Hexs(U5_Disp),
        .LES(U5_LE),
        .SEGEN(U6_SEGEN),
        .Start(Start_0_1),
        .Text(Text_0_1),
        .clk(clk_2_1),
        .flash(flash_0_1),
        .mapup(Start_0_1),
        .points(U5_point),
        .rst(rst_1_1),
        .segclk(U6_segclk),
        .segclrn(U6_segclrn),
        .segsout(U6_segsout));
  CSSTE_Disp2Hex_0_0 U61
       (.AN(U61_AN),
        .Hexs(U5_Disp),
        .LES(U5_LE),
        .SEGMENT(U61_SEGMENT),
        .Scan10(Scan10_0_1),
        .Scan2(Scan2_0_1),
        .Text(Text_0_1),
        .flash(flash_0_1),
        .points(U5_point));
endmodule

module GPIOBLOCK_imp_1XZRBBV
   (Dout,
    EN,
    LED,
    LEDCK,
    LEDCR,
    LEDDT,
    LEDEN,
    PData,
    Start,
    clk1,
    rst);
  output [1:0]Dout;
  input EN;
  output [7:0]LED;
  output LEDCK;
  output LEDCR;
  output LEDDT;
  output LEDEN;
  input [31:0]PData;
  input Start;
  input clk1;
  input rst;

  wire [31:0]Datai_0_1;
  wire EN_1_1;
  wire Start_0_2;
  wire [7:0]U71_LED;
  wire [15:0]U7_GPIOf0;
  wire U7_LEDEN;
  wire U7_ledclk;
  wire U7_ledclrn;
  wire U7_ledsout;
  wire clk_3_1;
  wire rst_2_1;
  wire [1:0]xlslice_0_Dout;

  assign Datai_0_1 = PData[31:0];
  assign Dout[1:0] = xlslice_0_Dout;
  assign EN_1_1 = EN;
  assign LED[7:0] = U71_LED;
  assign LEDCK = U7_ledclk;
  assign LEDCR = U7_ledclrn;
  assign LEDDT = U7_ledsout;
  assign LEDEN = U7_LEDEN;
  assign Start_0_2 = Start;
  assign clk_3_1 = clk1;
  assign rst_2_1 = rst;
  CSSTE_GPIO_0_0 U7
       (.Datai(Datai_0_1),
        .EN(EN_1_1),
        .GPIOf0(U7_GPIOf0),
        .LEDEN(U7_LEDEN),
        .Start(Start_0_2),
        .clk(clk_3_1),
        .ledclk(U7_ledclk),
        .ledclrn(U7_ledclrn),
        .ledsout(U7_ledsout),
        .rst(rst_2_1));
  CSSTE_PIO_0_0 U71
       (.Datai(Datai_0_1),
        .EN(EN_1_1),
        .LED(U71_LED),
        .clk(clk_3_1),
        .rst(rst_2_1));
  CSSTE_xlslice_0_0 xlslice_0
       (.Din(U7_GPIOf0),
        .Dout(xlslice_0_Dout));
endmodule

module RAM_B_imp_QDHJGA
   (addra,
    clka,
    dina,
    douta,
    wea);
  input [9:0]addra;
  input clka;
  input [31:0]dina;
  output [31:0]douta;
  input [0:0]wea;

  wire [31:0]RAM_B_douta;
  wire [9:0]addra_0_1;
  wire clka_0_1;
  wire [31:0]dina_0_1;
  wire [0:0]wea_0_1;

  assign addra_0_1 = addra[9:0];
  assign clka_0_1 = clka;
  assign dina_0_1 = dina[31:0];
  assign douta[31:0] = RAM_B_douta;
  assign wea_0_1 = wea[0];
  CSSTE_blk_mem_gen_0_1 U3
       (.addra(addra_0_1),
        .clka(clka_0_1),
        .dina(dina_0_1),
        .douta(RAM_B_douta),
        .wea(wea_0_1));
endmodule

module ROM_D_imp_I73H9X
   (Ain,
    spo);
  input [31:0]Ain;
  output [31:0]spo;

  wire [31:0]Din_0_1;
  wire [9:0]PCWA_Dout;
  wire [31:0]ROM_D_spo;

  assign Din_0_1 = Ain[31:0];
  assign spo[31:0] = ROM_D_spo;
  CSSTE_xlslice_0_1 PCWA
       (.Din(Din_0_1),
        .Dout(PCWA_Dout));
  CSSTE_dist_mem_gen_0_0 U2
       (.a(PCWA_Dout),
        .spo(ROM_D_spo));
endmodule

module VGATEST_imp_YV2KUV
   (B,
    Debug_addr,
    Debug_data,
    G,
    HS,
    MEM_Addr,
    MEM_Data,
    R,
    SWO14,
    VS,
    clk_100mhz,
    rst);
  output [3:0]B;
  output [6:0]Debug_addr;
  input [31:0]Debug_data;
  output [3:0]G;
  output HS;
  input [31:0]MEM_Addr;
  input [31:0]MEM_Data;
  output [3:0]R;
  input SWO14;
  output VS;
  input clk_100mhz;
  input rst;

  wire [31:0]Debug_data_0_1;
  wire [31:0]MEM_Addr_0_1;
  wire [31:0]MEM_Data_0_1;
  wire SWO14_0_1;
  wire [6:0]U11_Debug_addr;
  wire [11:0]U11_dout;
  wire [3:0]U12_B;
  wire [3:0]U12_G;
  wire U12_HS;
  wire [9:0]U12_PCol;
  wire [9:0]U12_PRow;
  wire [3:0]U12_R;
  wire U12_VS;
  wire clk_4_1;
  wire rst_3_1;

  assign B[3:0] = U12_B;
  assign Debug_addr[6:0] = U11_Debug_addr;
  assign Debug_data_0_1 = Debug_data[31:0];
  assign G[3:0] = U12_G;
  assign HS = U12_HS;
  assign MEM_Addr_0_1 = MEM_Addr[31:0];
  assign MEM_Data_0_1 = MEM_Data[31:0];
  assign R[3:0] = U12_R;
  assign SWO14_0_1 = SWO14;
  assign VS = U12_VS;
  assign clk_4_1 = clk_100mhz;
  assign rst_3_1 = rst;
  CSSTE_vga_debug_0_0 U11
       (.Debug_addr(U11_Debug_addr),
        .Debug_data(Debug_data_0_1),
        .MEM_Addr(MEM_Addr_0_1),
        .MEM_Data(MEM_Data_0_1),
        .PCol(U12_PCol),
        .PRow(U12_PRow),
        .SWO14(SWO14_0_1),
        .clk(clk_4_1),
        .dout(U11_dout));
  CSSTE_vga_0_0 U12
       (.B(U12_B),
        .Din(U11_dout),
        .G(U12_G),
        .HS(U12_HS),
        .PCol(U12_PCol),
        .PRow(U12_PRow),
        .R(U12_R),
        .VS(U12_VS),
        .clk(clk_4_1),
        .rst(rst_3_1));
endmodule
