`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:30:23 01/07/2021 
// Design Name: 
// Module Name:    main 
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
module main(
	input wire clk, rst,
	input wire [4:0] key,
	input wire keyReady,
	input wire [11:0] ROM_dout,
	input wire [7:0] RAM_dout,
	output reg RAM_we,
	output reg [31:0] ROM_raddr, RAM_rwaddr,
	output reg [7:0] RAM_din,
	output reg [3:0] level
   );
	
	reg wasReady = 1'b0;
	reg [7:0] state = 8'h10;
	reg [4:0] keyReg;
	reg [4:0] x, y, x2, y2;
	reg [3:0] index, index2;
	reg [7:0] property;
	reg [4:0] pushNum = 5'b0;
	reg [8:0] curpos;
	wire [8:0] pos, pos2;
	assign pos = y * 20 + x;
	assign pos2 = y2 * 20 + x2;
	initial level = 4'b0;
	
	//�ϣ�01010 �£�01110 ��01101 �ң�01111
	always @ (posedge clk) begin
		case(state)
			8'h0: begin//����״̬
				wasReady <= keyReady;
				if (!wasReady && keyReady) begin
					if (key == 5'b00110) state = 8'h10;//���õ�ǰ�ؿ�
					else if (key == 5'b00101 && level != 0) begin//������һ��
						level = level - 1;
						state = 8'h10;
					end
					else if (key == 5'b00111 && level != 12) begin//������һ��
						level = level + 1;
						state = 8'h10;
					end
					else if (key == 5'b01010 || key == 5'b01110 || key == 5'b01101 || key == 5'b01111) begin
						x <= 5'h1F; y <= 5'h0;
						keyReg <= key;
						state = 8'h1;
					end
				end
			end
			8'h1: begin//ɨ�����и���
				pushNum = 5'b0;
				if (x == 19 && y == 14) begin//ɨ�����
					x <= 5'h1F; y <= 5'h0;
					state = 8'hf0;//������һ֡��ͼ�������Ժ���ʾ�ĸ���
				end else begin
					if (x == 19) begin
						x <= 0;
						y <= y + 1'b1;
					end else x <= x + 1'b1;
					state = 8'h2;
				end
			end
			8'h2: begin//��ȡ������Ԫ����Ϣ
				RAM_we = 0;
				RAM_rwaddr = {1'b0, pos};
				state = 8'h3;
			end
			8'h3: begin//��ȡ������Ԫ������
				if (RAM_dout[4] ^ RAM_dout[5]) state = 8'h1;//������Ԫ�������֣������飬�����߶�
				else begin
					index = RAM_dout[3:0];
					if (index < 3) index = 4'b0;
					else index = index - 4'd3;
					RAM_rwaddr = {6'b011111, index};//Ԫ�����Ե�ַ
					state = 8'h23;
				end
			end
			8'h23: begin
				if (RAM_dout[3:0] == 4'b0001 || RAM_dout[7:4] == 4'b0001) state = 8'h4;//����Ԫ�ؿ����߶�
				else state = 8'h1;//�����߶�
			end
			8'h4: begin//׼���ƶ�
				pushNum = pushNum + 1'b1;//��¼�ۻ������ܸ�����
				case(keyReg)
					5'b01010: begin//����
						curpos = pos - (20 * pushNum);
						if(((pos - 20 * (pushNum - 1)) / 20) == 0) state = 8'h1;//�ߵ�����
						else begin
							RAM_rwaddr = {1'b0, curpos};
							state = 8'h5;
						end
					end
					5'b01110: begin//����
						curpos = pos + (20 * pushNum);
						if(((pos + 20 * (pushNum - 1)) / 20) == 14) state = 8'h1;//�ߵ�����
						else begin
							RAM_rwaddr = {1'b0, curpos};
							state = 8'h5;
						end
					end
					5'b01101: begin//����
						curpos = pos - (1 * pushNum);
						if(((pos - 1 * (pushNum - 1)) % 20) == 0) state = 8'h1;//�ߵ�����
						else begin
							RAM_rwaddr = {1'b0, curpos};
							state = 8'h5;
						end
					end
					5'b01111: begin//����
						curpos = pos + (1 * pushNum);
						if(((pos + 1 * (pushNum - 1)) % 20) == 19) state = 8'h1;//�ߵ�����
						else begin
							RAM_rwaddr = {1'b0, curpos};
							state = 8'h5;
						end
					end
				endcase
			end
			8'h5: begin//��ȡ��һ��Ԫ��
				if (RAM_dout[4] ^ RAM_dout[5]) state = 8'h4;//��һ��Ԫ�������֣������飬�����ƶ�
				else if (RAM_dout[5:4] == 2'b11) state = 8'h7;//��һ���ǿո񣬿����߹�
				else begin//������Ҫ����������
					index = RAM_dout[3:0];
					if (index < 3) index = 4'b0;
					else index = index - 4'd3;//��ȡ������
					RAM_rwaddr = {6'b011111, index};//Ԫ�����Ե�ַ
					state = 8'h6;
				end
			end
			8'h6: begin//�����һ��Ԫ������
				if (RAM_dout[3:0] == 4'b0100 || RAM_dout[7:4] == 4'b0100) state = 8'h4;//�����ƶ�
				else if (RAM_dout[3:0] == 4'b0011 || RAM_dout[7:4] == 4'b0011) state = 8'h1;//���ϰ���
				else if (RAM_dout[3:0] == 4'b0010 || RAM_dout[7:4] == 4'b0010) begin//���յ�
               if (pushNum == 1) begin//�Ҳ��Ǳ��ƶ�������
						level = level + 1;//������һ��
						state = 8'h10;//���³�ʼ��ͼ
               end
					else state = 8'h7;//���򵱳�ֱ���߹�
				end
				else state = 8'h7;//�����߹�
			end
			8'h7: begin//��ȡ��һ����Ϣ
				RAM_we = 0;
				case(keyReg)
					5'b01010: RAM_rwaddr = {1'b0, curpos + 20};//����
					5'b01110: RAM_rwaddr = {1'b0, curpos - 20};//����
					5'b01101: RAM_rwaddr = {1'b0, curpos + 1} ;//����
					5'b01111: RAM_rwaddr = {1'b0, curpos - 1} ;//����
				endcase
				state = 8'h8;
			end
			8'h8: begin//д��ø���Ϣ
				RAM_we = 1;
				RAM_rwaddr = {1'b1, curpos};//��һ֡��ͼ�иø�λ�õĵ�ַ
				if (RAM_dout[5:0] != 6'b000000 && RAM_dout[5:0] != 6'b000001 && RAM_dout[5:0] != 6'b000010 && RAM_dout[5:0] != 6'b000011)
					RAM_din = RAM_dout;//����BABA��ֱ��д��
				else case(keyReg)//�����ж�BABA�ĳ���
					5'b01010: RAM_din = 8'b11000000;//����
					5'b01110: RAM_din = 8'b11000001;//����
					5'b01101: RAM_din = 8'b11000010;//����
					5'b01111: RAM_din = 8'b11000011;//����
				endcase
				case(keyReg)
					5'b01010: curpos = curpos + 20;//����
					5'b01110: curpos = curpos - 20;//����
					5'b01101: curpos = curpos + 1 ;//����
					5'b01111: curpos = curpos - 1 ;//����
				endcase
				pushNum = pushNum - 1'b1;//����һ��
				if (pushNum == 0) state = 8'h9;//����Ѿ����������и��ӣ�������ʼ�ĸ���
				else state = 8'h7;//�����������
			end
			8'h9: begin//��ʼ�ж��Ƿ�Ҫ���³�ʼ��
			if((keyReg == 5'b01110 && curpos / 20 != 0) || (keyReg == 5'b01111 && curpos % 20 != 0)) begin//����������߻������ߣ�Ҫ����һ�����ж�
					RAM_we = 0;
					if (keyReg == 5'b01110) curpos = curpos - 20;
					else curpos = curpos - 1;
					RAM_rwaddr = {1'b0, curpos};//�����һ��Ԫ������
					state = 8'ha;
				end
				else state = 8'hc;//����ֱ�Ӹ�д��ʼ��
			end
			8'ha: begin
				if (RAM_dout[4] ^ RAM_dout[5]) state = 8'h9;//��һ��Ԫ�������֣������ƶ������ż��
				else if (RAM_dout[4:3] == 2'b11) state = 8'hc;//��һ��Ϊ�գ�ֱ�Ӹ�д��ʼ��
				else begin
					index = RAM_dout[3:0];
					if (index < 4'd3) index = 4'b0;
					else index = index - 4'd3;//��ȡ������
					RAM_rwaddr = {6'b011111, index};//Ԫ�����Ե�ַ
					state = 8'hb;
				end
			end
			8'hb: begin//��鵱ǰ��Ԫ��
				if (RAM_dout[3:0] == 4'b0001 || RAM_dout[7:4] == 4'b0001) state = 8'h1;//�����߶�������д��ʼ��
				else if (RAM_dout[3:0] == 4'b0100 || RAM_dout[7:4] == 4'b0100) state = 8'h9;//�����ƶ������ż��
				else state = 8'hc;//�����߹�
			end
			8'hc: begin//�����ʼ��
				RAM_we = 1;
				RAM_rwaddr = {1'b1, pos};
				RAM_din = 8'b11111111;
				state = 8'h1;
			end
			
			/////////////////////////////////////////
			
			//���²���
			8'h10: begin
				x <= 5'h1F; y <= 5'h0;
				state = 8'h11;
			end
			8'h11: begin
				if (x == 19 && y == 14) begin
					x <= 5'h1F; y <= 5'h0;
					state = 8'hf0;//ɨ����ϣ�������һ֡��ͼ�������Ժ���ʾ�ĸ���
				end else begin
					if (x == 19) begin
						x <= 0;
						y <= y + 1'b1;
					end else x <= x + 1'b1;
					state = 8'h12;
				end
			end
			8'h12: begin//��ȡ��ʼ��ͼ�ĸ�����Ԫ��
				ROM_raddr = {4'b1000, level, pos};
				state = 8'h13;
			end
			8'h13: begin//��ÿһ����Ԫ��д����һ֡��ͼ
				RAM_we = 1;
				RAM_rwaddr = {1'b1, pos};
				RAM_din = {2'b11, ROM_dout[5:0]};
				state = 8'h11;
			end
			
			/////////////////////////////////////////
			
			//������һ֡��ͼ����Ԫ������
			8'hf0: begin//ɨ���ͼ
				if (x == 19 && y == 14) begin
					x <= 5'h1F; y <= 5'h0;
					state = 8'hfa;//׼������ǰ��ͼ����Ϊ��һ֡��ͼ
				end else begin
					if (x == 19) begin
						x <= 0;
						y <= y + 1'b1;
					end else x <= x + 1'b1;
					state = 8'hf1;
				end
			end
			8'hf1: begin//��ȡ��ǰ�����һ֡��Ϣ
				RAM_we = 0;
				RAM_rwaddr = {1'b1, pos};
				state = 8'hf2;
			end
			8'hf2: begin//���ĵ�ǰ��
				if (RAM_dout[5:4] == 2'b01) begin//�������������
					index = RAM_dout[3:0];//��ȡ������
					state = 8'hf3;//Ҫ�����ж�
				end
				else state = 8'hf0;
			end
			8'hf3: begin//�����ж������򱾸�
				RAM_we = 0;
				if (x == 19 || x == 18) begin//�������ռ䲻���Թ������
					property[3:0] = 4'b0000;//û������
					state = 8'hf6;//���������ж�
				end else begin//�����ұ�һ��
					RAM_rwaddr = {1'b1, pos + 9'd1};
					state = 8'hf4;
				end
			end
			8'hf4: begin//�����ж��������һ��
				if (RAM_dout[5:0] != 6'b100000) begin//����ұ�һ����IS
					property[3:0] = 4'b0000;//û������
					state = 8'hf6;//���������ж�
				end else begin//�����ұߵڶ���
					RAM_rwaddr = {1'b1, pos + 9'd2};
					state = 8'hf5;
				end
			end
			8'hf5: begin//�����ж�������ڶ���
				if (RAM_dout[5:4] == 2'b10)//�������������
					property[3:0] = RAM_dout[3:0];//��¼����
				else property[3:0] = 4'b0000;//����û������
				if (RAM_dout[5:4] != 2'b01) state = 8'hf6;//���������������
				else begin//�������������
						index2 = RAM_dout[3:0];
						x2 <= 5'h1F; y2 <= 5'h0;
						state = 8'he0;//��ʼɨ���ͼ��ת������Ԫ��
				end
			end
			8'he0: begin//ɨ���ͼ
				if (x2 == 19 && y2 == 14)
					state = 8'hf6;
				else begin
					if (x2 == 19) begin
						x2 <= 0;
						y2 <= y2 + 1'b1;
					end else x2 <= x2 + 1'b1;
					state = 8'he1;
				end
			end
			8'he1: begin//��ȡ��������
				RAM_we = 0;
				RAM_rwaddr = {1'b1, pos2};
				state = 8'he2;
			end
			8'he2: begin
				if (RAM_dout[5:4] == 2'b00 && ((RAM_dout[3:0] < 4'd3) ? 4'd3 : RAM_dout[3:0]) - 4'd3  == index) begin//�����Ҫ�ı������
					RAM_we = 1;
					RAM_rwaddr = {1'b1, pos2};
					RAM_din = {4'b1100, index2 + 4'd3};
				end
				state = 8'he0;
			end
			
			8'hf6: begin//�����ж������򱾸�
				if (y == 14 || y == 13) begin//�������ռ䲻���Թ������
					property[7:4] = 4'b0000;//û������
					state = 8'hf9;//������������
				end else begin//�����±�һ��
					RAM_rwaddr = {1'b1, pos + 9'd20};
					state = 8'hf7;
				end
			end
			8'hf7: begin//�����ж��������һ��
				if (RAM_dout[5:0] != 6'b100000) begin//����ұ�һ����IS
					property[7:4] = 4'b0000;//û������
					state = 8'hf9;//������������
				end else begin//�����±ߵڶ���
					RAM_rwaddr = {1'b1, pos + 9'd40};
					state = 8'hf8;
				end
			end
			8'hf8: begin//�����ж�������ڶ���
				if (RAM_dout[5:4] == 2'b10)//�������������
					property[7:4] = RAM_dout[3:0];//��¼����
				else property[7:4] = 4'b0000;//����û������
				if (RAM_dout[5:4] != 2'b01) state = 8'hf9;//�������������
				else begin
					index2 = RAM_dout[3:0];
					x2 <= 5'h1F; y2 <= 5'h0;
					state = 8'hea;//��ʼɨ���ͼ��ת������Ԫ��
				end
			end
			8'hea: begin//ɨ���ͼ
				if (x2 == 19 && y2 == 14)
					state = 8'hf9;
				else begin
					if (x2 == 19) begin
						x2 <= 0;
						y2 <= y2 + 1'b1;
					end else x2 <= x2 + 1'b1;
					state = 8'heb;
				end
			end
			8'heb: begin//��ȡ��������
				RAM_we = 0;
				RAM_rwaddr = {1'b1, pos2};
				state = 8'hec;
			end
			8'hec: begin
				if (RAM_dout[5:4] == 2'b00 && ((RAM_dout[3:0] < 4'd3) ? 4'd3 : RAM_dout[3:0]) - 4'd3 == index) begin//�����Ҫ�ı������
					RAM_we = 1;
					RAM_rwaddr = {1'b1, pos2};
					RAM_din = {4'b1100, index2 + 4'd3};
				end
				state = 8'hea;
			end
			
			8'hf9: begin//д������
				if (property == 8'b0001_0010 || property == 8'b0010_0001) begin//�����Ԫ��ͬʱ����YOU��WIN����
					level = level + 1;
					state = 8'h10;
				end else begin
					RAM_we = 1;
					RAM_rwaddr = {6'b011111, index};
					RAM_din = property;
					state = 8'hf0;
				end
			end
			
			//����ǰ��ͼ����Ϊ��һ֡��ͼ
			8'hfa: begin//ɨ���ͼ
				if (x == 19 && y == 14)
					state = 8'h0;
				else begin
					if (x == 19) begin
						x <= 0;
						y <= y + 1'b1;
					end else x <= x + 1'b1;
					state = 8'hfb;
				end
			end
			8'hfb: begin//��ȡ��ǰ�����һ֡��Ϣ
				RAM_we = 0;
				RAM_rwaddr = {1'b1, pos};
				state = 8'hfc;
			end
			8'hfc: begin//���ĵ�ǰ��
				RAM_we = 1;
				RAM_din = RAM_dout;
				RAM_rwaddr = {1'b0, pos};
				state = 8'hfa;
			end
		endcase
	end

endmodule
