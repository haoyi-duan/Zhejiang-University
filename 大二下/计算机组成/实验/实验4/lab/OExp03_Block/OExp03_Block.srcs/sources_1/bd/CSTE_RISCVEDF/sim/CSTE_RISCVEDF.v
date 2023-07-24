//Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2017.4 (win64) Build 2086221 Fri Dec 15 20:55:39 MST 2017
//Date        : Tue Mar 30 19:18:18 2021
//Host        : LAPTOP-0HOK14LD running 64-bit major release  (build 9200)
//Command     : generate_target CSTE_RISCVEDF.bd
//Design      : CSTE_RISCVEDF
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module ARRAYBLOCK_imp_VQSXA4
   (BTN,
    Buzzer,
    CR,
    DIVO,
    KCOL,
    KROW,
    LES,
    ONE,
    RDY,
    RSTN,
    SWO,
    SWO0,
    SWO1,
    SWO13_0,
    SWO14_0,
    SWO2,
    SWO765_0,
    SW_0,
    ZERO,
    blink,
    clk_100mhz,
    points,
    readn,
    rst);
  output [3:0]BTN;
  output Buzzer;
  output CR;
  input [31:0]DIVO;
  input [3:0]KCOL;
  output [4:0]KROW;
  output [63:0]LES;
  output ONE;
  output RDY;
  input RSTN;
  output [15:0]SWO;
  output SWO0;
  output SWO1;
  output SWO13_0;
  output SWO14_0;
  output SWO2;
  output [2:0]SWO765_0;
  input [15:0]SW_0;
  output ZERO;
  output [7:0]blink;
  input clk_100mhz;
  output [63:0]points;
  output readn;
  output rst;

  wire [31:0]DIVO_0_1;
  wire [3:0]KCOL_0_1;
  wire [7:0]M4_blink;
  wire M4_readn;
  wire RSTN_0_1;
  wire SWOTap_SWO0;
  wire SWOTap_SWO1;
  wire SWOTap_SWO13;
  wire SWOTap_SWO14;
  wire SWOTap_SWO15;
  wire SWOTap_SWO2;
  wire [2:0]SWOTap_SWO765;
  wire [15:0]SW_0_1;
  wire TESTOTap_Buzzer;
  wire [63:0]TESTOTap_LES;
  wire TESTOTap_ONE;
  wire TESTOTap_ZERO;
  wire [63:0]TESTOTap_points;
  wire [3:0]U9_BTNO;
  wire U9_CR;
  wire [4:0]U9_KCODE;
  wire U9_KRDY;
  wire [4:0]U9_KROW;
  wire [15:0]U9_SWO;
  wire U9_rst;
  wire clk_0_1;

  assign BTN[3:0] = U9_BTNO;
  assign Buzzer = TESTOTap_Buzzer;
  assign CR = U9_CR;
  assign DIVO_0_1 = DIVO[31:0];
  assign KCOL_0_1 = KCOL[3:0];
  assign KROW[4:0] = U9_KROW;
  assign LES[63:0] = TESTOTap_LES;
  assign ONE = TESTOTap_ONE;
  assign RDY = U9_KRDY;
  assign RSTN_0_1 = RSTN;
  assign SWO[15:0] = U9_SWO;
  assign SWO0 = SWOTap_SWO0;
  assign SWO1 = SWOTap_SWO1;
  assign SWO13_0 = SWOTap_SWO13;
  assign SWO14_0 = SWOTap_SWO14;
  assign SWO2 = SWOTap_SWO2;
  assign SWO765_0[2:0] = SWOTap_SWO765;
  assign SW_0_1 = SW_0[15:0];
  assign ZERO = TESTOTap_ZERO;
  assign blink[7:0] = M4_blink;
  assign clk_0_1 = clk_100mhz;
  assign points[63:0] = TESTOTap_points;
  assign readn = M4_readn;
  assign rst = U9_rst;
  CSTE_RISCVEDF_EnterT32_0_0 M4
       (.ArrayKey(SWOTap_SWO15),
        .BTN(U9_BTNO),
        .DRDY(U9_KRDY),
        .Din(U9_KCODE),
        .TEST(SWOTap_SWO765),
        .Text(SWOTap_SWO0),
        .UP16(SWOTap_SWO1),
        .blink(M4_blink),
        .clk(clk_0_1),
        .readn(M4_readn));
  CSTE_RISCVEDF_SWOUT_0_0 SWOTap
       (.SWI(U9_SWO),
        .SWO0(SWOTap_SWO0),
        .SWO1(SWOTap_SWO1),
        .SWO13(SWOTap_SWO13),
        .SWO14(SWOTap_SWO14),
        .SWO15(SWOTap_SWO15),
        .SWO2(SWOTap_SWO2),
        .SWO765(SWOTap_SWO765));
  CSTE_RISCVEDF_TESTO_0_0 TESTOTap
       (.Buzzer(TESTOTap_Buzzer),
        .DIVO(DIVO_0_1),
        .LES(TESTOTap_LES),
        .ONE(TESTOTap_ONE),
        .SWO(U9_SWO),
        .ZERO(TESTOTap_ZERO),
        .blink(M4_blink),
        .points(TESTOTap_points));
  CSTE_RISCVEDF_Arraykeys_0_0 U9
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

module CLKBLOCK_imp_1RYZQRU
   (CPUClk,
    DIV,
    DIVO06,
    DIVO08,
    DIVO10,
    DIVO12,
    DIVO18T19,
    DIVO20,
    DIVO25,
    STEP,
    clk_0,
    nCPUClk,
    rst_0);
  output CPUClk;
  output [31:0]DIV;
  output DIVO06;
  output DIVO08;
  output DIVO10;
  output DIVO12;
  output [1:0]DIVO18T19;
  output DIVO20;
  output DIVO25;
  input STEP;
  input clk_0;
  output nCPUClk;
  input rst_0;

  wire DIVOTap_DIVO06;
  wire DIVOTap_DIVO08;
  wire DIVOTap_DIVO10;
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
  assign DIVO08 = DIVOTap_DIVO08;
  assign DIVO10 = DIVOTap_DIVO10;
  assign DIVO12 = DIVOTap_DIVO12;
  assign DIVO18T19[1:0] = DIVOTap_DIVO18T19;
  assign DIVO20 = DIVOTap_DIVO20;
  assign DIVO25 = DIVOTap_DIVO25;
  assign STEP_0_1 = STEP;
  assign clk_0_2 = clk_0;
  assign nCPUClk = U8_nCPUClk;
  assign rst_0_1 = rst_0;
  CSTE_RISCVEDF_DIVO_0_0 DIVOTap
       (.DIV(U8_clkdiv),
        .DIVO06(DIVOTap_DIVO06),
        .DIVO08(DIVOTap_DIVO08),
        .DIVO10(DIVOTap_DIVO10),
        .DIVO12(DIVOTap_DIVO12),
        .DIVO18T19(DIVOTap_DIVO18T19),
        .DIVO20(DIVOTap_DIVO20),
        .DIVO25(DIVOTap_DIVO25));
  CSTE_RISCVEDF_Clkdiv_0_0 U8
       (.CPUClk(U8_CPUClk),
        .STEP(STEP_0_1),
        .clk(clk_0_2),
        .clkdiv(U8_clkdiv),
        .nCPUClk(U8_nCPUClk),
        .rst(rst_0_1));
endmodule

(* CORE_GENERATION_INFO = "CSTE_RISCVEDF,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=CSTE_RISCVEDF,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=25,numReposBlks=20,numNonXlnxBlks=16,numHierBlks=5,maxHierDepth=1,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,synth_mode=Global}" *) (* HW_HANDOFF = "CSTE_RISCVEDF.hwdef" *) 
module CSTE_RISCVEDF
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
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLK_100MHZ CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLK_100MHZ, ASSOCIATED_RESET RSTN, CLK_DOMAIN CSTE_RISCVEDF_clk_100mhz, FREQ_HZ 100000000, PHASE 0.000" *) input clk_100mhz;
  output readn;

  wire [3:0]ARRAYBLOCK_BTN;
  wire [63:0]ARRAYBLOCK_LES;
  wire [15:0]ARRAYBLOCK_SWO;
  wire ARRAYBLOCK_SWO0;
  wire ARRAYBLOCK_SWO1;
  wire ARRAYBLOCK_SWO14_0;
  wire ARRAYBLOCK_SWO2;
  wire [2:0]ARRAYBLOCK_SWO765_0;
  wire [7:0]ARRAYBLOCK_blink;
  wire [63:0]ARRAYBLOCK_points;
  wire ARRAYBLOCK_rst;
  wire CLKBLOCK_CPUClk;
  wire CLKBLOCK_DIVO06;
  wire CLKBLOCK_DIVO08;
  wire CLKBLOCK_DIVO12;
  wire [1:0]CLKBLOCK_DIVO18T19;
  wire CLKBLOCK_DIVO20;
  wire CLKBLOCK_DIVO25;
  wire CLKBLOCK_nCPUClk;
  wire [3:0]KCOL_0_1;
  wire M4_readn;
  wire [31:0]MEMARYBLOCK_MEM_Addr;
  wire [31:0]MEMARYBLOCK_MEM_Data;
  wire [31:0]MEMARYBLOCK_douta;
  wire RSTN_0_1;
  wire SWO13_1;
  wire [15:0]SW_0_1;
  wire TESTOTap_Buzzer;
  wire [31:0]U10_Counter;
  wire U10_counter0_OUT;
  wire U10_counter1_OUT;
  wire U10_counter2_OUT;
  wire [3:0]U11_Blue;
  wire [3:0]U11_Green;
  wire U11_HSYNC;
  wire [3:0]U11_Red;
  wire U11_VSYNC;
  wire U1_ALE;
  wire [31:0]U1_Addr;
  wire [31:0]U1_Datao;
  wire U1_MIO;
  wire [31:0]U1_PC;
  wire [6:0]U1_TESTREG_Debug_addr;
  wire [31:0]U1_TESTREG_Debug_data;
  wire U1_WR;
  wire [31:0]U2_spo;
  wire U4_CONT_W0208;
  wire U4_CPU_wait;
  wire [31:0]U4_Data2CPU;
  wire U4_GPIO_W0200;
  wire U4_GPIO_W0204;
  wire [31:0]U4_Peripheral;
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
  wire [31:0]U8_clkdiv;
  wire U9_CR;
  wire U9_KRDY;
  wire [4:0]U9_KROW;
  wire [9:0]addra_1;
  wire clk_0_1;
  wire [31:0]dina_1;
  wire wea_1;
  wire [1:0]xlslice_0_Dout;

  assign AN[3:0] = U61_AN;
  assign Blue[3:0] = U11_Blue;
  assign Buzzer = TESTOTap_Buzzer;
  assign CR = U9_CR;
  assign Green[3:0] = U11_Green;
  assign HSYNC = U11_HSYNC;
  assign KCOL_0_1 = KCOL[3:0];
  assign KROW[4:0] = U9_KROW;
  assign LED[7:0] = U71_LED;
  assign LEDCK = U7_ledclk;
  assign LEDCR = U7_ledclrn;
  assign LEDDT = U7_ledsout;
  assign LEDEN = U7_LEDEN;
  assign RDY = U9_KRDY;
  assign RSTN_0_1 = RSTN;
  assign Red[3:0] = U11_Red;
  assign SEGCK = U6_segclk;
  assign SEGCR = U6_segclrn;
  assign SEGDT = U6_segsout;
  assign SEGEN = U6_SEGEN;
  assign SEGMENT[7:0] = U61_SEGMENT;
  assign SW_0_1 = SW[15:0];
  assign VSYNC = U11_VSYNC;
  assign clk_0_1 = clk_100mhz;
  assign readn = M4_readn;
  ARRAYBLOCK_imp_VQSXA4 ARRAYBLOCK
       (.BTN(ARRAYBLOCK_BTN),
        .Buzzer(TESTOTap_Buzzer),
        .CR(U9_CR),
        .DIVO(U8_clkdiv),
        .KCOL(KCOL_0_1),
        .KROW(U9_KROW),
        .LES(ARRAYBLOCK_LES),
        .RDY(U9_KRDY),
        .RSTN(RSTN_0_1),
        .SWO(ARRAYBLOCK_SWO),
        .SWO0(ARRAYBLOCK_SWO0),
        .SWO1(ARRAYBLOCK_SWO1),
        .SWO13_0(SWO13_1),
        .SWO14_0(ARRAYBLOCK_SWO14_0),
        .SWO2(ARRAYBLOCK_SWO2),
        .SWO765_0(ARRAYBLOCK_SWO765_0),
        .SW_0(SW_0_1),
        .blink(ARRAYBLOCK_blink),
        .clk_100mhz(clk_0_1),
        .points(ARRAYBLOCK_points),
        .readn(M4_readn),
        .rst(ARRAYBLOCK_rst));
  CLKBLOCK_imp_1RYZQRU CLKBLOCK
       (.CPUClk(CLKBLOCK_CPUClk),
        .DIV(U8_clkdiv),
        .DIVO06(CLKBLOCK_DIVO06),
        .DIVO08(CLKBLOCK_DIVO08),
        .DIVO12(CLKBLOCK_DIVO12),
        .DIVO18T19(CLKBLOCK_DIVO18T19),
        .DIVO20(CLKBLOCK_DIVO20),
        .DIVO25(CLKBLOCK_DIVO25),
        .STEP(ARRAYBLOCK_SWO2),
        .clk_0(clk_0_1),
        .nCPUClk(CLKBLOCK_nCPUClk),
        .rst_0(ARRAYBLOCK_rst));
  DISPBLOCK_imp_UR01OZ DISPBLOCK
       (.A0(CLKBLOCK_DIVO08),
        .AN(U61_AN),
        .Data0(U4_Peripheral),
        .EN(U4_GPIO_W0204),
        .IO_clk(CLKBLOCK_nCPUClk),
        .LES_0(ARRAYBLOCK_LES),
        .SEGCK(U6_segclk),
        .SEGCR(U6_segclrn),
        .SEGDT(U6_segsout),
        .SEGEN(U6_SEGEN),
        .SEGMENT(U61_SEGMENT),
        .Scan10(CLKBLOCK_DIVO18T19),
        .Scan2(ARRAYBLOCK_SWO1),
        .Test(ARRAYBLOCK_SWO765_0),
        .Text(ARRAYBLOCK_SWO0),
        .clk_100mhz_2(clk_0_1),
        .data1(U1_PC),
        .data2(U2_spo),
        .data3(U1_Addr),
        .data4(U4_Data2CPU),
        .data5(U1_Datao),
        .data6(U8_clkdiv),
        .data7(U10_Counter),
        .flash(CLKBLOCK_DIVO25),
        .map2up(CLKBLOCK_DIVO20),
        .points_0(ARRAYBLOCK_points),
        .rst_1(ARRAYBLOCK_rst));
  GPIOBLOCK_imp_I5E0P4 GPIOBLOCK
       (.Dout(xlslice_0_Dout),
        .EN_0(U4_GPIO_W0200),
        .LED(U71_LED),
        .LEDCK(U7_ledclk),
        .LEDCR(U7_ledclrn),
        .LEDDT(U7_ledsout),
        .LEDEN(U7_LEDEN),
        .PData(U4_Peripheral),
        .Start(CLKBLOCK_DIVO20),
        .clk1(CLKBLOCK_nCPUClk),
        .rst_2(ARRAYBLOCK_rst));
  MEMARYBLOCK_imp_R25EAQ MEMARYBLOCK
       (.MEM_Addr(MEMARYBLOCK_MEM_Addr),
        .MEM_Data(MEMARYBLOCK_MEM_Data),
        .MIO(U1_MIO),
        .PCin(U1_PC),
        .RAMADDR(U1_Addr),
        .SWO13(SWO13_1),
        .addra(addra_1),
        .clka(U1_ALE),
        .dina(dina_1),
        .douta(MEMARYBLOCK_douta),
        .spo(U2_spo),
        .wea(wea_1));
  CSTE_RISCVEDF_RSCPU9_0_0 U1
       (.ALE(U1_ALE),
        .Addr(U1_Addr),
        .Datai(U4_Data2CPU),
        .Datao(U1_Datao),
        .Debug_addr(U1_TESTREG_Debug_addr),
        .Debug_data(U1_TESTREG_Debug_data),
        .INST(U2_spo),
        .MIO(U1_MIO),
        .PC(U1_PC),
        .Ready(U4_CPU_wait),
        .TNI(ARRAYBLOCK_blink),
        .WR(U1_WR),
        .clk(CLKBLOCK_CPUClk),
        .reset(ARRAYBLOCK_rst));
  CSTE_RISCVEDF_Counter_0_0 U10
       (.Counter(U10_Counter),
        .clk(clk_0_1),
        .clk0(CLKBLOCK_DIVO06),
        .clk1(CLKBLOCK_DIVO20),
        .clk2(CLKBLOCK_DIVO12),
        .counter0_OUT(U10_counter0_OUT),
        .counter1_OUT(U10_counter1_OUT),
        .counter2_OUT(U10_counter2_OUT),
        .counter_ch(xlslice_0_Dout),
        .counter_val(U4_Peripheral),
        .counter_we(U4_CONT_W0208),
        .rst(ARRAYBLOCK_rst));
  CSTE_RISCVEDF_VGA_TEST_0_0 U11
       (.Blue(U11_Blue),
        .Debug_addr(U1_TESTREG_Debug_addr),
        .Debug_data(U1_TESTREG_Debug_data),
        .Green(U11_Green),
        .HSYNC(U11_HSYNC),
        .MEM_Addr(MEMARYBLOCK_MEM_Addr),
        .MEM_Data(MEMARYBLOCK_MEM_Data),
        .Red(U11_Red),
        .SWO13(SWO13_1),
        .SWO14(ARRAYBLOCK_SWO14_0),
        .VSYNC(U11_VSYNC),
        .clk(clk_0_1));
  CSTE_RISCVEDF_MIOBUS_0_0 U4
       (.Addr_bus(U1_Addr),
        .BTN(ARRAYBLOCK_BTN),
        .C0(U10_counter0_OUT),
        .C1(U10_counter1_OUT),
        .C2(U10_counter2_OUT),
        .CONT_W0208(U4_CONT_W0208),
        .CPU_wait(U4_CPU_wait),
        .Counter(U10_Counter),
        .Data2CPU(U4_Data2CPU),
        .Data4CPU(U1_Datao),
        .GPIO_W0200(U4_GPIO_W0200),
        .GPIO_W0204(U4_GPIO_W0204),
        .Peripheral(U4_Peripheral),
        .SW(ARRAYBLOCK_SWO),
        .clk(CLKBLOCK_nCPUClk),
        .data_ram_we(wea_1),
        .mem_w(U1_WR),
        .ram_addr(addra_1),
        .ram_data_in(dina_1),
        .ram_data_out(MEMARYBLOCK_douta),
        .rst(ARRAYBLOCK_rst));
endmodule

module DISPBLOCK_imp_UR01OZ
   (A0,
    AN,
    Data0,
    EN,
    IO_clk,
    LES_0,
    SEGCK,
    SEGCR,
    SEGDT,
    SEGEN,
    SEGMENT,
    Scan10,
    Scan2,
    Test,
    Text,
    clk_100mhz_2,
    data1,
    data2,
    data3,
    data4,
    data5,
    data6,
    data7,
    flash,
    map2up,
    points_0,
    rst_1);
  input A0;
  output [3:0]AN;
  input [31:0]Data0;
  input EN;
  input IO_clk;
  input [63:0]LES_0;
  output SEGCK;
  output SEGCR;
  output SEGDT;
  output SEGEN;
  output [7:0]SEGMENT;
  input [1:0]Scan10;
  input Scan2;
  input [2:0]Test;
  input Text;
  input clk_100mhz_2;
  input [31:0]data1;
  input [31:0]data2;
  input [31:0]data3;
  input [31:0]data4;
  input [31:0]data5;
  input [31:0]data6;
  input [31:0]data7;
  input flash;
  input map2up;
  input [63:0]points_0;
  input rst_1;

  wire A0_0_1;
  wire [31:0]Data0_0_1;
  wire EN_0_1;
  wire [63:0]LES_0_1;
  wire [1:0]Scan10_0_1;
  wire Scan2;
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
  wire clk_1_1;
  wire clk_1_2;
  wire [31:0]data1_0_1;
  wire [31:0]data2_0_1;
  wire [31:0]data3_0_1;
  wire [31:0]data4_0_1;
  wire [31:0]data5_0_1;
  wire [31:0]data6_0_1;
  wire [31:0]data7_0_1;
  wire flash_0_1;
  wire map2up_0_1;
  wire [63:0]points_0_1;
  wire rst_1_1;

  assign A0_0_1 = A0;
  assign AN[3:0] = U61_AN;
  assign Data0_0_1 = Data0[31:0];
  assign EN_0_1 = EN;
  assign LES_0_1 = LES_0[63:0];
  assign SEGCK = U6_segclk;
  assign SEGCR = U6_segclrn;
  assign SEGDT = U6_segsout;
  assign SEGEN = U6_SEGEN;
  assign SEGMENT[7:0] = U61_SEGMENT;
  assign Scan10_0_1 = Scan10[1:0];
  assign Test_0_1 = Test[2:0];
  assign Text_0_1 = Text;
  assign clk_1_1 = IO_clk;
  assign clk_1_2 = clk_100mhz_2;
  assign data1_0_1 = data1[31:0];
  assign data2_0_1 = data2[31:0];
  assign data3_0_1 = data3[31:0];
  assign data4_0_1 = data4[31:0];
  assign data5_0_1 = data5[31:0];
  assign data6_0_1 = data6[31:0];
  assign data7_0_1 = data7[31:0];
  assign flash_0_1 = flash;
  assign map2up_0_1 = map2up;
  assign points_0_1 = points_0[63:0];
  assign rst_1_1 = rst_1;
  CSTE_RISCVEDF_DSEGIO_0_0 U5
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
        .map2up(map2up_0_1),
        .mapup(U5_mapup),
        .point(U5_point),
        .points(points_0_1),
        .rst(rst_1_1));
  CSTE_RISCVEDF_Display_0_0 U6
       (.Hexs(U5_Disp),
        .LES(U5_LE),
        .SEGEN(U6_SEGEN),
        .Start(map2up_0_1),
        .Text(Text_0_1),
        .clk(clk_1_2),
        .flash(flash_0_1),
        .mapup(U5_mapup),
        .points(U5_point),
        .rst(rst_1_1),
        .segclk(U6_segclk),
        .segclrn(U6_segclrn),
        .segsout(U6_segsout));
  CSTE_RISCVEDF_Disp2Hex_0_0 U61
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

module GPIOBLOCK_imp_I5E0P4
   (Dout,
    EN_0,
    LED,
    LEDCK,
    LEDCR,
    LEDDT,
    LEDEN,
    PData,
    Start,
    clk1,
    rst_2);
  output [1:0]Dout;
  input EN_0;
  output [7:0]LED;
  output LEDCK;
  output LEDCR;
  output LEDDT;
  output LEDEN;
  input [31:0]PData;
  input Start;
  input clk1;
  input rst_2;

  wire [31:0]Datai_0_1;
  wire EN_0_2;
  wire Start_0_1;
  wire [7:0]U71_LED;
  wire [15:0]U7_GPIOf0;
  wire U7_LEDEN;
  wire U7_ledclk;
  wire U7_ledclrn;
  wire U7_ledsout;
  wire clk_1_3;
  wire rst_2_1;
  wire [1:0]xlslice_0_Dout;

  assign Datai_0_1 = PData[31:0];
  assign Dout[1:0] = xlslice_0_Dout;
  assign EN_0_2 = EN_0;
  assign LED[7:0] = U71_LED;
  assign LEDCK = U7_ledclk;
  assign LEDCR = U7_ledclrn;
  assign LEDDT = U7_ledsout;
  assign LEDEN = U7_LEDEN;
  assign Start_0_1 = Start;
  assign clk_1_3 = clk1;
  assign rst_2_1 = rst_2;
  CSTE_RISCVEDF_GPIO_0_0 U7
       (.Datai(Datai_0_1),
        .EN(EN_0_2),
        .GPIOf0(U7_GPIOf0),
        .LEDEN(U7_LEDEN),
        .Start(Start_0_1),
        .clk(clk_1_3),
        .ledclk(U7_ledclk),
        .ledclrn(U7_ledclrn),
        .ledsout(U7_ledsout),
        .rst(rst_2_1));
  CSTE_RISCVEDF_PIO_0_0 U71
       (.Datai(Datai_0_1),
        .EN(EN_0_2),
        .LED(U71_LED),
        .clk(clk_1_3),
        .rst(rst_2_1));
  CSTE_RISCVEDF_xlslice_0_0 xlslice_0
       (.Din(U7_GPIOf0),
        .Dout(xlslice_0_Dout));
endmodule

module MEMARYBLOCK_imp_R25EAQ
   (MEM_Addr,
    MEM_Data,
    MIO,
    PCin,
    RAMADDR,
    SWO13,
    addra,
    clka,
    dina,
    douta,
    spo,
    wea);
  output [31:0]MEM_Addr;
  output [31:0]MEM_Data;
  input MIO;
  input [31:0]PCin;
  input [31:0]RAMADDR;
  input SWO13;
  input [9:0]addra;
  input clka;
  input [31:0]dina;
  output [31:0]douta;
  output [31:0]spo;
  input [0:0]wea;

  wire [31:0]Din_0_1;
  wire [31:0]MEMTEST_0_MEM_Addr;
  wire [31:0]MEMTEST_0_MEM_Data;
  wire MIO_0_1;
  wire [31:0]RAMADDR_0_1;
  wire SWO13_1_1;
  wire [31:0]U2_spo;
  wire [31:0]U3_douta;
  wire [9:0]addra_0_1;
  wire clka_0_1;
  wire [31:0]dina_0_1;
  wire [0:0]wea_0_1;
  wire [9:0]xlslice_0_Dout1;

  assign Din_0_1 = PCin[31:0];
  assign MEM_Addr[31:0] = MEMTEST_0_MEM_Addr;
  assign MEM_Data[31:0] = MEMTEST_0_MEM_Data;
  assign MIO_0_1 = MIO;
  assign RAMADDR_0_1 = RAMADDR[31:0];
  assign SWO13_1_1 = SWO13;
  assign addra_0_1 = addra[9:0];
  assign clka_0_1 = clka;
  assign dina_0_1 = dina[31:0];
  assign douta[31:0] = U3_douta;
  assign spo[31:0] = U2_spo;
  assign wea_0_1 = wea[0];
  CSTE_RISCVEDF_MEMTEST_0_0 MEMTEST_0
       (.MEM_Addr(MEMTEST_0_MEM_Addr),
        .MEM_Data(MEMTEST_0_MEM_Data),
        .MIO(MIO_0_1),
        .RAMADDR(RAMADDR_0_1),
        .RAMData(U3_douta),
        .ROMADDR(Din_0_1),
        .ROMData(U2_spo),
        .SWO13(SWO13_1_1));
  CSTE_RISCVEDF_xlslice_0_1 PCWA
       (.Din(Din_0_1),
        .Dout(xlslice_0_Dout1));
  CSTE_RISCVEDF_dist_mem_gen_0_0 U2
       (.a(xlslice_0_Dout1),
        .spo(U2_spo));
  CSTE_RISCVEDF_blk_mem_gen_0_0 U3
       (.addra(addra_0_1),
        .clka(clka_0_1),
        .dina(dina_0_1),
        .douta(U3_douta),
        .wea(wea_0_1));
endmodule
