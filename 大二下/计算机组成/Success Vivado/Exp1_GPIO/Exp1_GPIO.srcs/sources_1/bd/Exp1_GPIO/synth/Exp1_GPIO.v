//Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2017.4 (win64) Build 2086221 Fri Dec 15 20:55:39 MST 2017
//Date        : Tue Mar 16 16:25:09 2021
//Host        : LAPTOP-0HOK14LD running 64-bit major release  (build 9200)
//Command     : generate_target Exp1_GPIO.bd
//Design      : Exp1_GPIO
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module Display_imp_1BAKVHZ
   (AN,
    Data0,
    EN,
    LES,
    SEGCLK,
    SEGCLR,
    SEGDT,
    SEGEN,
    SEGMENT,
    Scan10,
    Scan2,
    Start,
    Test,
    Text,
    clk_100mhz,
    data1,
    data2,
    data6,
    data7,
    flash,
    points,
    rst);
  output [3:0]AN;
  input [31:0]Data0;
  input EN;
  input [63:0]LES;
  output SEGCLK;
  output SEGCLR;
  output SEGDT;
  output SEGEN;
  output [7:0]SEGMENT;
  input [1:0]Scan10;
  input Scan2;
  input Start;
  input [2:0]Test;
  input Text;
  input clk_100mhz;
  input [31:0]data1;
  input [31:0]data2;
  input [31:0]data6;
  input [31:0]data7;
  input flash;
  input [63:0]points;
  input rst;

  wire [31:0]Data0_0_1;
  wire EN_0_1;
  wire [63:0]LES_0_1;
  wire [1:0]Scan10_0_1;
  wire Scan2;
  wire Start_0_1;
  wire [2:0]Test_0_1;
  wire Text_0_1;
  wire [31:0]U5_Disp;
  wire [7:0]U5_LE;
  wire U5_mapup;
  wire [7:0]U5_point;
  wire [3:0]U61_AN;
  wire [7:0]U61_SEGMENT;
  wire U6_SEGEN;
  wire U6_segclk;
  wire U6_segclrn;
  wire U6_segsout;
  wire clk_0_2;
  wire [31:0]data1_0_1;
  wire [31:0]data2_0_1;
  wire [31:0]data6_0_1;
  wire [31:0]data7_0_1;
  wire flash_0_1;
  wire [63:0]points_0_1;
  wire rst_0_1;

  assign AN[3:0] = U61_AN;
  assign Data0_0_1 = Data0[31:0];
  assign EN_0_1 = EN;
  assign LES_0_1 = LES[63:0];
  assign SEGCLK = U6_segclk;
  assign SEGCLR = U6_segclrn;
  assign SEGDT = U6_segsout;
  assign SEGEN = U6_SEGEN;
  assign SEGMENT[7:0] = U61_SEGMENT;
  assign Scan10_0_1 = Scan10[1:0];
  assign Start_0_1 = Start;
  assign Test_0_1 = Test[2:0];
  assign Text_0_1 = Text;
  assign clk_0_2 = clk_100mhz;
  assign data1_0_1 = data1[31:0];
  assign data2_0_1 = data2[31:0];
  assign data6_0_1 = data6[31:0];
  assign data7_0_1 = data7[31:0];
  assign flash_0_1 = flash;
  assign points_0_1 = points[63:0];
  assign rst_0_1 = rst;
  Exp1_GPIO_DSEGIO_0_0 U5
       (.Data0(Data0_0_1),
        .Disp(U5_Disp),
        .EN(EN_0_1),
        .LE(U5_LE),
        .LES(LES_0_1),
        .Test(Test_0_1),
        .clk(clk_0_2),
        .data1(data1_0_1),
        .data2(data2_0_1),
        .data3(data2_0_1),
        .data4(data2_0_1),
        .data5(data2_0_1),
        .data6(data6_0_1),
        .data7(data7_0_1),
        .mapup(U5_mapup),
        .point(U5_point),
        .points(points_0_1),
        .rst(rst_0_1));
  Exp1_GPIO_Display_0_0 U6
       (.Hexs(U5_Disp),
        .LES(U5_LE),
        .SEGEN(U6_SEGEN),
        .Start(Start_0_1),
        .Text(Text_0_1),
        .clk(clk_0_2),
        .flash(flash_0_1),
        .mapup(U5_mapup),
        .points(U5_point),
        .rst(rst_0_1),
        .segclk(U6_segclk),
        .segclrn(U6_segclrn),
        .segsout(U6_segsout));
  Exp1_GPIO_Disp2Hex_0_0 U61
       (.AN(U61_AN),
        .Hexs(U5_Disp),
        .LES(U5_LE),
        .SEGMENT(U61_SEGMENT),
        .Scan10(Scan10_0_1),
        .Scan2(Scan2),
        .Text(Text_0_1),
        .flash(flash_0_1),
        .points(U5_point));
endmodule

(* CORE_GENERATION_INFO = "Exp1_GPIO,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=Exp1_GPIO,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=17,numReposBlks=13,numNonXlnxBlks=10,numHierBlks=4,maxHierDepth=1,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,synth_mode=Global}" *) (* HW_HANDOFF = "Exp1_GPIO.hwdef" *) 
module Exp1_GPIO
   (AN,
    CR,
    DIVCLKO,
    EN,
    KCOL,
    KROW,
    LED,
    LEDCK,
    LEDCR,
    LEDDT,
    LEDEN,
    LES,
    PData,
    RDY,
    RSTN,
    SEGCK,
    SEGCR,
    SEGDT,
    SEGEN,
    SEGMENT,
    SW,
    addr,
    blink,
    clk_100mhz,
    points,
    readn,
    wea);
  output [3:0]AN;
  output CR;
  output [31:0]DIVCLKO;
  input EN;
  input [3:0]KCOL;
  output [4:0]KROW;
  output [7:0]LED;
  output LEDCK;
  output LEDCR;
  output LEDDT;
  output LEDEN;
  input [63:0]LES;
  input [31:0]PData;
  output RDY;
  input RSTN;
  output SEGCK;
  output SEGCR;
  output SEGDT;
  output SEGEN;
  output [7:0]SEGMENT;
  input [15:0]SW;
  input [9:0]addr;
  output [7:0]blink;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLK_100MHZ CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLK_100MHZ, ASSOCIATED_RESET RSTN, CLK_DOMAIN Exp1_GPIO_clk_0, FREQ_HZ 100000000, PHASE 0.000" *) input clk_100mhz;
  input [63:0]points;
  output readn;
  input [0:0]wea;

  wire EN_0_1;
  wire [3:0]KCOL_0_1;
  wire [63:0]LES_0_1;
  wire [31:0]M4_Ai;
  wire [31:0]M4_Bi;
  wire [7:0]M4_blink;
  wire M4_readn;
  wire [31:0]PData_0_1;
  wire [31:0]RAM_Dout;
  wire RSTN_0_1;
  wire STEP_1;
  wire SWOUT_0_SWO0;
  wire SWOUT_0_SWO1;
  wire SWOUT_0_SWO15;
  wire [2:0]SWOUT_0_SWO765;
  wire [15:0]SW_0_1;
  wire [1:0]Scan10_1;
  wire Start_1;
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
  wire [3:0]U9_BTNO;
  wire U9_CR;
  wire [4:0]U9_KCODE;
  wire U9_KRDY;
  wire [4:0]U9_KROW;
  wire [15:0]U9_SWO;
  wire [9:0]addra_0_1;
  wire clk_0_1;
  wire clk_DIVO25;
  wire [31:0]clk_clkdiv;
  wire [31:0]dina_1;
  wire [63:0]points_0_1;
  wire rst_1;
  wire [0:0]wea_0_1;

  assign AN[3:0] = U61_AN;
  assign CR = U9_CR;
  assign DIVCLKO[31:0] = clk_clkdiv;
  assign EN_0_1 = EN;
  assign KCOL_0_1 = KCOL[3:0];
  assign KROW[4:0] = U9_KROW;
  assign LED[7:0] = U71_LED;
  assign LEDCK = U7_ledclk;
  assign LEDCR = U7_ledclrn;
  assign LEDDT = U7_ledsout;
  assign LEDEN = U7_LEDEN;
  assign LES_0_1 = LES[63:0];
  assign PData_0_1 = PData[31:0];
  assign RDY = U9_KRDY;
  assign RSTN_0_1 = RSTN;
  assign SEGCK = U6_segclk;
  assign SEGCR = U6_segclrn;
  assign SEGDT = U6_segsout;
  assign SEGEN = U6_SEGEN;
  assign SEGMENT[7:0] = U61_SEGMENT;
  assign SW_0_1 = SW[15:0];
  assign addra_0_1 = addr[9:0];
  assign blink[7:0] = M4_blink;
  assign clk_0_1 = clk_100mhz;
  assign points_0_1 = points[63:0];
  assign readn = M4_readn;
  assign wea_0_1 = wea[0];
  Display_imp_1BAKVHZ Display
       (.AN(U61_AN),
        .Data0(M4_Ai),
        .EN(EN_0_1),
        .LES(LES_0_1),
        .SEGCLK(U6_segclk),
        .SEGCLR(U6_segclrn),
        .SEGDT(U6_segsout),
        .SEGEN(U6_SEGEN),
        .SEGMENT(U61_SEGMENT),
        .Scan10(Scan10_1),
        .Scan2(SWOUT_0_SWO1),
        .Start(Start_1),
        .Test(SWOUT_0_SWO765),
        .Text(SWOUT_0_SWO0),
        .clk_100mhz(clk_0_1),
        .data1(M4_Bi),
        .data2(clk_clkdiv),
        .data6(dina_1),
        .data7(RAM_Dout),
        .flash(clk_DIVO25),
        .points(points_0_1),
        .rst(rst_1));
  GPIO_imp_1BJU264 GPIO
       (.EN(EN_0_1),
        .LED(U71_LED),
        .LEDCK(U7_ledclk),
        .LEDCR(U7_ledclrn),
        .LEDDT(U7_ledsout),
        .LEDEN(U7_LEDEN),
        .PData(PData_0_1),
        .Start(Start_1),
        .clk_100mhz(clk_0_1),
        .rst(rst_1));
  Exp1_GPIO_EnterT32_0_0 M4
       (.Ai(M4_Ai),
        .ArrayKey(SWOUT_0_SWO15),
        .BTN(U9_BTNO),
        .Bi(M4_Bi),
        .DRDY(U9_KRDY),
        .Din(U9_KCODE),
        .TEST(SWOUT_0_SWO765),
        .Text(SWOUT_0_SWO0),
        .UP16(SWOUT_0_SWO1),
        .blink(M4_blink),
        .clk(clk_0_1),
        .readn(M4_readn));
  RAM_imp_1SJPJ9F RAM
       (.Dout(RAM_Dout),
        .addra(addra_0_1),
        .clk_100mhz(clk_0_1),
        .dina(dina_1),
        .wea(wea_0_1));
  Exp1_GPIO_dist_mem_gen_0_1 ROM_D
       (.a(addra_0_1),
        .spo(dina_1));
  Exp1_GPIO_SWOUT_0_0 SWTap
       (.SWI(U9_SWO),
        .SWO0(SWOUT_0_SWO0),
        .SWO1(SWOUT_0_SWO1),
        .SWO15(SWOUT_0_SWO15),
        .SWO2(STEP_1),
        .SWO765(SWOUT_0_SWO765));
  Exp1_GPIO_Arraykeys_0_0 U9
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
        .rst(rst_1));
  clk_imp_SYSXRJ clk
       (.DIVO10(Start_1),
        .DIVO18T19(Scan10_1),
        .DIVO25(clk_DIVO25),
        .STEP(STEP_1),
        .clk_100mhz(clk_0_1),
        .clkdiv(clk_clkdiv),
        .rst(rst_1));
endmodule

module GPIO_imp_1BJU264
   (EN,
    GPIOf0_0,
    LED,
    LEDCK,
    LEDCR,
    LEDDT,
    LEDEN,
    PData,
    Start,
    clk_100mhz,
    rst);
  input EN;
  output [23:0]GPIOf0_0;
  output [7:0]LED;
  output LEDCK;
  output LEDCR;
  output LEDDT;
  output LEDEN;
  input [31:0]PData;
  input Start;
  input clk_100mhz;
  input rst;

  wire EN_0_2;
  wire [31:0]PData_0_1;
  wire Start_0_1;
  wire [23:0]U71_GPIOf0;
  wire [7:0]U71_LED;
  wire U7_LEDEN;
  wire U7_ledclk;
  wire U7_ledclrn;
  wire U7_ledsout;
  wire clk_0_2;
  wire rst_0_1;

  assign EN_0_2 = EN;
  assign GPIOf0_0[23:0] = U71_GPIOf0;
  assign LED[7:0] = U71_LED;
  assign LEDCK = U7_ledclk;
  assign LEDCR = U7_ledclrn;
  assign LEDDT = U7_ledsout;
  assign LEDEN = U7_LEDEN;
  assign PData_0_1 = PData[31:0];
  assign Start_0_1 = Start;
  assign clk_0_2 = clk_100mhz;
  assign rst_0_1 = rst;
  Exp1_GPIO_GPIO_0_0 U7
       (.EN(EN_0_2),
        .LEDEN(U7_LEDEN),
        .PData(PData_0_1),
        .Start(Start_0_1),
        .clk(clk_0_2),
        .ledclk(U7_ledclk),
        .ledclrn(U7_ledclrn),
        .ledsout(U7_ledsout),
        .rst(rst_0_1));
  Exp1_GPIO_PIO_0_0 U71
       (.EN(EN_0_2),
        .GPIOf0(U71_GPIOf0),
        .LED(U71_LED),
        .PData(PData_0_1),
        .clk(clk_0_2),
        .rst(rst_0_1));
endmodule

module RAM_imp_1SJPJ9F
   (Dout,
    addra,
    clk_100mhz,
    dina,
    wea);
  output [31:0]Dout;
  input [9:0]addra;
  input [0:0]clk_100mhz;
  input [31:0]dina;
  input [0:0]wea;

  wire [0:0]Op1_0_1;
  wire [31:0]RAM_B_douta;
  wire [9:0]addra_0_1;
  wire [31:0]dina_0_1;
  wire [0:0]util_vector_logic_0_Res;
  wire [0:0]wea_0_1;

  assign Dout[31:0] = RAM_B_douta;
  assign Op1_0_1 = clk_100mhz[0];
  assign addra_0_1 = addra[9:0];
  assign dina_0_1 = dina[31:0];
  assign wea_0_1 = wea[0];
  Exp1_GPIO_blk_mem_gen_0_0 RAM_B
       (.addra(addra_0_1),
        .clka(util_vector_logic_0_Res),
        .dina(dina_0_1),
        .douta(RAM_B_douta),
        .wea(wea_0_1));
  Exp1_GPIO_util_vector_logic_0_0 util_vector_logic_0
       (.Op1(Op1_0_1),
        .Res(util_vector_logic_0_Res));
endmodule

module clk_imp_SYSXRJ
   (CPUClk,
    DIVO10,
    DIVO18T19,
    DIVO20,
    DIVO25,
    STEP,
    clk_100mhz,
    clkdiv,
    nCPUClk,
    rst);
  output CPUClk;
  output DIVO10;
  output [1:0]DIVO18T19;
  output DIVO20;
  output DIVO25;
  input STEP;
  input clk_100mhz;
  output [31:0]clkdiv;
  output nCPUClk;
  input rst;

  wire DIVTap_DIVO10;
  wire [1:0]DIVTap_DIVO18T19;
  wire DIVTap_DIVO20;
  wire DIVTap_DIVO25;
  wire STEP_0_1;
  wire U8_CPUClk;
  wire [31:0]U8_clkdiv;
  wire U8_nCPUClk;
  wire clk_0_2;
  wire rst_0_1;

  assign CPUClk = U8_CPUClk;
  assign DIVO10 = DIVTap_DIVO10;
  assign DIVO18T19[1:0] = DIVTap_DIVO18T19;
  assign DIVO20 = DIVTap_DIVO20;
  assign DIVO25 = DIVTap_DIVO25;
  assign STEP_0_1 = STEP;
  assign clk_0_2 = clk_100mhz;
  assign clkdiv[31:0] = U8_clkdiv;
  assign nCPUClk = U8_nCPUClk;
  assign rst_0_1 = rst;
  Exp1_GPIO_DIVO_0_0 DIVTap
       (.DIV(U8_clkdiv),
        .DIVO10(DIVTap_DIVO10),
        .DIVO18T19(DIVTap_DIVO18T19),
        .DIVO20(DIVTap_DIVO20),
        .DIVO25(DIVTap_DIVO25));
  Exp1_GPIO_Clkdiv_0_0 U8
       (.CPUClk(U8_CPUClk),
        .STEP(STEP_0_1),
        .clk(clk_0_2),
        .clkdiv(U8_clkdiv),
        .nCPUClk(U8_nCPUClk),
        .rst(rst_0_1));
endmodule
