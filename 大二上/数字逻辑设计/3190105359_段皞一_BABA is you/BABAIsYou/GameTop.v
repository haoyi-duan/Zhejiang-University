`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:44:04 01/01/2021 
// Design Name: 
// Module Name:    GameTop 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module GameTop(
	input clk, rst,
	input SW,
	inout [4:0] BTN_X,
	inout [3:0] BTN_Y,
	output HSYNC, VSYNC,
	output [3:0] Red, Green, Blue,
	output [7:0] LED,
	output SEGLED_CLK, SEGLED_CLR, SEGLED_DO, SEGLED_PEN,
	output wire [3:0] AN,
	output wire [7:0] Segment,
	output buzzer
   );
	
	//ʱ�ӷ�Ƶ�ź�
	wire [31:0] clkdiv;
	//���ִ�������ȡ�ź�
	wire [31:0] ROM_addra, ROM_addrb, RAM_addra, RAM_addrb;
	wire [11:0] ROM_outa, ROM_outb;
	wire [7:0] RAM_ina, RAM_inb, RAM_outa, RAM_outb;
	wire RAM_wea, RAM_web;
	wire [31:0] VRAM_in_addr, VRAM_out_addr;
	wire VRAM_en;
	wire [11:0] VRAM_in, VRAM_out;
	//��ǰVGAʱ���ź�
	wire video_en;
	wire [9:0] x, y;
	//��ť�ź�
	wire [4:0] keyCode;
	wire keyReady;
	//��Ϸ�ؿ���
	wire [3:0] level;
	assign VRAM_out_addr = video_en ? (y * 640 + x) : 32'b0;
	assign LED = {4'b0000, level};
	
	//ʱ�ӷ�Ƶ
	clkdiv cd(clk, rst, clkdiv);
	
	//������ť�ź�
	//�ϣ�01010 �£�01110 ��01101 �ң�01111
	Keypad key(.clk(clkdiv[15]), .keyX(BTN_Y), .keyY(BTN_X), .keyCode(keyCode), .keyReady(keyReady));
	
	//������
	ROM dataROM(.clka(clk), .addra(ROM_addra), .douta(ROM_outa),
					.clkb(clk), .addrb(ROM_addrb), .doutb(ROM_outb));
	RAM dataRAM(.clka(clk), .addra(RAM_addra), .dina(RAM_ina), .douta(RAM_outa), .wea(RAM_wea),
					.clkb(clk), .addrb(RAM_addrb), .dinb(RAM_inb), .doutb(RAM_outb), .web(1'b0));
	VRAM screen(.clka(clk), .addra(VRAM_in_addr), .dina(VRAM_in), .wea(VRAM_en),
					.clkb(clk), .addrb(VRAM_out_addr), .doutb(VRAM_out));
	
	//��Ϸ���߼�
	main main0(.clk(clkdiv[0]), .rst(rst), .key(keyCode), .keyReady(keyReady), .ROM_raddr(ROM_addra), .ROM_dout(ROM_outa),
				  .RAM_we(RAM_wea), .RAM_rwaddr(RAM_addra), .RAM_din(RAM_ina), .RAM_dout(RAM_outa), .level(level));
	
	//����VRAM
	VGADisp vgad(.clk(clkdiv[0]), .ROM_raddr(ROM_addrb), .ROM_dout(ROM_outb), .RAM_raddr(RAM_addrb), .RAM_dout(RAM_outb),
					 .VRAM_we(VRAM_en), .VRAM_waddr(VRAM_in_addr), .VRAM_din(VRAM_in));
	
	//��ʾ
	vgac vgas(.vga_clk(clkdiv[1]), .clrn(~rst), .d_in(VRAM_out), .row_addr(y), .col_addr(x), .video_en(video_en), .r(Red), .g(Green), .b(Blue), .hs(HSYNC), .vs(VSYNC));
	//VGASync vgas(.clk(clkdiv[1]), .rst(rst), .hsync(HSYNC), .vsync(VSYNC), .video_en(video_en), .xpos(x), .ypos(y));
	Sseg_Dev led(.clk(clk),.rst(1'b0),.Start(clkdiv[20]),.flash(1),
		.Hexs({level, 8'b0000_0000, 3'b000, keyCode[4],3'b000, keyCode[3], 3'b000,keyCode[2],3'b000, keyCode[1],3'b000, keyCode[0]}),.point(8'b00000000),.LES(8'b00000000),
		.seg_clk(SEGLED_CLK),.seg_clrn(SEGLED_CLR),.seg_sout(SEGLED_DO),.SEG_PEN(SEGLED_PEN));
	song fire(clk, SW, buzzer);
	disp_num_new Level(clk,{level, level, level, level},4'b1110,4'b0000,1'b0,AN,Segment);

endmodule
