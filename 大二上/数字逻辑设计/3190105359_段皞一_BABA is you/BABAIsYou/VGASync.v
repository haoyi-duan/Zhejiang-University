`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:00:47 01/01/2021 
// Design Name: 
// Module Name:    VGASync 
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
module VGASync(
	input wire clk, rst,
	output wire hsync, vsync, video_en,
	output wire [9:0] xpos, ypos
   );
	
	localparam hsync_total = 800;          //������
	localparam hsync_en    = 96;           //��ɨ�迪ʼ
	localparam hsync_start = 143;          //�п�����ʾ��ʼ
	localparam hsync_end   = 143 + 640 - 1;//�п�����ʾ����
	
	localparam vsync_total = 525;          //������
	localparam vsync_en    = 2;            //��ɨ�迪ʼ
	localparam vsync_start = 35;           //�п�����ʾ��ʼ
	localparam vsync_end   = 35 + 480 - 1; //�п�����ʾ����
	
	reg [9:0] hcount, vcount;
	
	//��ɨ��
	always @ (posedge clk or posedge rst) begin
		if (rst) hcount <= 0;
		else if(hcount == hsync_total - 1) hcount <= 0;
		else hcount <= hcount + 1'b1;
	end
	
	//��ɨ��
	always @ (posedge clk or posedge rst) begin
		if (rst) vcount <= 0;
		else if(hcount == hsync_total - 1)
			if(vcount == vsync_total - 1) vcount <= 0;
			else vcount <= vcount + 1'b1;
	end
			
	assign video_en = (hcount >= hsync_start && hcount <= hsync_end && vcount >= vsync_start && vcount <= vsync_end);
	assign hsync    = (hcount >= hsync_en);
	assign vsync    = (vcount >= vsync_en);
	assign xpos     = hcount - hsync_start;
	assign ypos     = vcount - vsync_start;
	
endmodule
