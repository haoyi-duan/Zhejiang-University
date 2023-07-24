`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:35:20 09/25/2017 
// Design Name: 
// Module Name:    vga_debug 
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
module VGA_TEST(
	input clk,
//	input [9:0] PCol,                                      //���˱�������������VGA�ı�ģʽͳһ������VGA���衣���޸�����̫�࣬��ʱ�ָ���
//	input [9:0] PRow,                                      //���˱�����
	input SWO14,                                           //�洢���ݷ�ҳ��2021 Modify :������ʾ��֡ROM����
	input SWO13,                                           //ROM��RAM�л�
	input [31:0] Debug_data,
	input [31:0] MEM_Addr,                                 //2021 ���� ROM���Ե�ַ��
	input [31:0] MEM_Data,                                 //2021 ���� ROM ����������
	
	output[3:0] Red,
    output[3:0] Green,
    output[3:0] Blue,
    output VSYNC,
    output HSYNC,

//	output reg [11:0]dout,
	output [6:0] Debug_addr);
	
reg [31:0] data_buf [0:3];
reg [31:0] MEMBUF[0:255];            //�洢���������ݻ��棺128��Ԫ�������Ҫ���ӣ����޸���ʾ��λ�͸�ʽ
reg [7:0] ascii_code;
reg [8*7:0] strdata;
reg [11:0]dout;
wire pixel;
wire [9:0] PRow, PCol;

wire  [9:0] row_addr =  PRow - 10'd35;     // pixel ram row addr 
wire  [9:0] col_addr =  PCol- 10'd143;    // pixel ram col addr 

wire should_latch_debug_data = (PCol < 10'd143) && (PCol[2:0] == 3'b000) && (row_addr[3:0] == 4'b0000);

wire [4:0] char_index_row = row_addr[8:4] - 2;
wire [6:0] char_index_col = (PCol < 10'd143) ? 0 : (col_addr / 8 + 1);
wire [1:0] char_page = char_index_col / 20;
wire [4:0] char_index_in_page = char_index_col % 20;
//wire [2:0] char_index_in_reg_buf = 7 - (char_index_in_page - 9);               //û��ʹ��   2021 Modify ע�͵�

//    assign dout = pixel ? {4'b1111, {4{~Debug_addr[5]}}, {4{~Debug_addr[6]}}} : 12'b1100_0000_0000;         //Debug_addr[5]     12'b111111111111
    always @* begin                                                            // 2021 Modify �����ɫ����۲�
       if(pixel)
        case(Debug_addr[6:5])
            2'b00:   dout = 12'b1111_1111_1111; 
            2'b01:   dout = 12'b0000_0000_1111; 
            2'b10:   dout = 12'b0000_1111_1111; 
            default: dout = 12'b0000_1111_1111; 
        endcase
      else dout = 12'b1000_0000_0000;
    end

assign Debug_addr = {char_index_row , PCol[4:3]};
wire[7:0] current_display_reg_addr = {1'b0, char_index_row, char_page};

    always @(negedge clk) begin                                     //2021 Modify ��ROM��������д��
        MEMBUF[{SWO13,MEM_Addr[8:2]}] <= MEM_Data;                  //SWO13=1����RAM,����ROM
    end
    
   wire [31:0] MEMDATA = MEMBUF[{SWO13,1'b0,SWO14 + Debug_addr[5],Debug_addr[4:0]}];  //2021 Modify ��ʾROM/RAM���ݣ�û�ж�����Ϊ0000_00000H��SWO14������֡��ÿ֡32����
   
always @(posedge clk) begin                                         //2021 Modify 
	if (should_latch_debug_data) begin
		if(Debug_addr[6]) data_buf[Debug_addr[1:0]] <= MEMDATA;   //��Ļ�·���ʾROM����
		else data_buf[Debug_addr[1:0]] <= Debug_data; 
	end
end

always @(posedge clk) begin                                                     //��λ�����Ҫ�޸ġ�������д
	if (col_addr[2:0] == 3'b111) begin
		ascii_code <= " ";
		if ((char_index_in_page >= 10) && (char_index_in_page <= 10 + 7)) begin
			ascii_code <=  num2str(data_buf[char_page][(7 - (char_index_in_page - 10)) * 4  +: 4]);
		end
		if ((char_index_in_page >= 2) && (char_index_in_page <= 8)) begin
			ascii_code <= strdata[(6 - (char_index_in_page - 2)) * 8 +:8];
		end
		if ((row_addr < 2 * 16) || (row_addr >= 480 - 2 * 16)) begin
			ascii_code <= " ";
		end
	end
end
    wire [8*5:0] MEMADDRSTR = SWO13 ? "RAM:0" : "CODE-";                                   //�л�RAM/ROM��ַ��ʾ��־
always @(posedge clk) begin                                                                 //2021 Modify ,���ڻ���Ҫ����
		case (current_display_reg_addr[7:5])
			3'b000: strdata <= {"REGS-", num2str(current_display_reg_addr[5:4]), num2str(current_display_reg_addr[3:0])};
			3'b001: case (current_display_reg_addr[4:0])
				// datapath debug signals, MUST be compatible with 'debug_data_signal' in 'datapath.v'
				0: strdata <= "P-POINT";
				1: strdata <= "OP-CODE";
				2: strdata <= "IMM--16";
				3: strdata <= "JMP-E26";
				
				4: strdata <= "RS-ADDR";     
				5: strdata <= "RS-DATA";    
				6: strdata <= "CPUADDR";
				7: strdata <= "CPU-DAO";
				
				8: strdata <= "RT-ADDR";
				9: strdata <= "RT-DATA";
				10: strdata <= "CPU-DAI";
				11: strdata <= "RD-ADDR";
				
				12: strdata <= "ALU-AIN";   
				13: strdata <= "ALU-OUT";    
				14: strdata <= "MIO-CPU";
				15: strdata <= "RD-DATA";
				
				16: strdata <= "ALU-BIN";
				17: strdata <= "-------";
				18: strdata <= "-------";
				19: strdata <= "WB-ADDR";
				
				20: strdata <= "-------";
				21: strdata <= "-------";
				22: strdata <= "-------";
				23: strdata <= "WB-DATA";
				
				default: strdata <= "RESERVE";
			endcase
			3'b010: strdata <= {MEMADDRSTR, num2str({SWO14 + current_display_reg_addr[5],current_display_reg_addr[4]}), num2str(current_display_reg_addr[3:0])};
			3'b011: strdata <= {MEMADDRSTR, num2str({SWO14 ,current_display_reg_addr[5]}+1'b1), num2str(current_display_reg_addr[3:0])};
//			3'b010: strdata <= {MEMADDRSTR, num2str({SWO14 + current_display_reg_addr[5],current_display_reg_addr[4]}), num2str(current_display_reg_addr[3:0])};

			default: strdata <= "RESERVE";
		endcase
end


FONT8_16 FONT_8X16 (                                //�����޸�Ϊ��׼�ֿ�
	.clk(clk),
	.ascii_code(ascii_code[6:0]),
	.row(row_addr[3:0]),
	.col(col_addr[2:0]),
	.row_of_pixels(pixel)
);

	function [7:0] num2str;
		input [3:0] number;
		begin
			if (number < 10)
				num2str = "0" + number;
			else
				num2str = "A" - 10 + number;
		end
	endfunction

        vga     U12(.clk(clk),
                    .rst(1'b0),
                    .Din(dout),
                    .PCol(PCol),
                    .PRow(PRow),
                    .R(Red),
                    .G(Green),
                    .B(Blue),
                    .VS(VSYNC),
                    .HS(HSYNC)
                     );


endmodule
