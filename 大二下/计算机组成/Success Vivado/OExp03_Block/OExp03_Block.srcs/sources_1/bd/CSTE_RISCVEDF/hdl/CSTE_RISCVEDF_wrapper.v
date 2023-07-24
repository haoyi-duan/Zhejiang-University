//Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2017.4 (win64) Build 2086221 Fri Dec 15 20:55:39 MST 2017
//Date        : Tue Mar 30 19:18:18 2021
//Host        : LAPTOP-0HOK14LD running 64-bit major release  (build 9200)
//Command     : generate_target CSTE_RISCVEDF_wrapper.bd
//Design      : CSTE_RISCVEDF_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module CSTE_RISCVEDF_wrapper
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
  input clk_100mhz;
  output readn;

  wire [3:0]AN;
  wire [3:0]Blue;
  wire Buzzer;
  wire CR;
  wire [3:0]Green;
  wire HSYNC;
  wire [3:0]KCOL;
  wire [4:0]KROW;
  wire [7:0]LED;
  wire LEDCK;
  wire LEDCR;
  wire LEDDT;
  wire LEDEN;
  wire RDY;
  wire RSTN;
  wire [3:0]Red;
  wire SEGCK;
  wire SEGCR;
  wire SEGDT;
  wire SEGEN;
  wire [7:0]SEGMENT;
  wire [15:0]SW;
  wire VSYNC;
  wire clk_100mhz;
  wire readn;

  CSTE_RISCVEDF CSTE_RISCVEDF_i
       (.AN(AN),
        .Blue(Blue),
        .Buzzer(Buzzer),
        .CR(CR),
        .Green(Green),
        .HSYNC(HSYNC),
        .KCOL(KCOL),
        .KROW(KROW),
        .LED(LED),
        .LEDCK(LEDCK),
        .LEDCR(LEDCR),
        .LEDDT(LEDDT),
        .LEDEN(LEDEN),
        .RDY(RDY),
        .RSTN(RSTN),
        .Red(Red),
        .SEGCK(SEGCK),
        .SEGCR(SEGCR),
        .SEGDT(SEGDT),
        .SEGEN(SEGEN),
        .SEGMENT(SEGMENT),
        .SW(SW),
        .VSYNC(VSYNC),
        .clk_100mhz(clk_100mhz),
        .readn(readn));
endmodule
