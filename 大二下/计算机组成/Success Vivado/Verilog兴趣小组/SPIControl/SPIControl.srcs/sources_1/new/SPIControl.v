module SPIControl(
            input clk,            // ʱ��
            input rst,            // ��λ�ź�
            output ready,        // һ��ָ��ִ������źţ���������Ч����Чʱ������һ��inNum��outNum
    
            output in,            // ��������Ч����Чʱ��֪����ϵͳ������һ��datain����
            input [8:0] inNum,    // ��Ҫ�����byte����
            input [7:0] datain, // ��Ҫ�����byte
    
            output reg out,                // �����أ���ʾ����������ɣ�����Ч����Чʱ��֤dataout��Ч
            input [7:0] outNum,            // ��Ҫ�����byte����
            output reg [7:0] dataout,    // �����byte����
    
            output reg cs_n,    // SPI��CS�ź�
            output clk_o,        // SPI��CLK�ź�
            input  d_i,            // SPI��DI�ź�
            output d_o            // SPI��DO�ź�
        );
        
        reg in_a, d_oa; 
        reg [2:0] cnt;
        reg startWrite;
        reg start;
        reg startRead;
        reg [8:0] cntWrite;
        reg [7:0] cntRead;
        wire clk_tmp;
        reg clk_n;
        reg ready_n;
        reg count;
        reg outBegin;
        reg [1:0]endCnt;
        reg endend;
        reg rst_init;
        reg ready_cnt;
        assign in = in_a;
        assign d_o = d_oa;
        assign clk_tmp = ~clk;
        assign ready = ready_n;
        assign clk_o = clk_n && ~cs_n;  
        
        always @(posedge rst or negedge clk_tmp) begin
            if (rst == 1) begin
                endCnt = 2'b00;
                outBegin = 1'b0;
                endend = 1'b0;
                clk_n = 1'b0;
                start = 1'b0;
                count = 1'b0;
                ready_n = 1'b1;
                dataout = 0;
                in_a = 1'b0; 
                out = 1'b0;
                d_oa = 1'b0;
                cs_n = 1'b1;
                cnt = 3'b000;
                rst_init = 1'b0;
                startWrite = 1'b0;
                startRead = 1'b0;
                cntWrite = 9'b0000_00000;
                cntRead = 8'b0000_0000;
                ready_cnt <= 1'b0;
            end
            else begin
                if (ready_n == 1'b0) begin
                    if (ready_cnt == 1'b1) begin
                        ready_cnt = 1'b0;
                        ready_n = 1'b1;
                    end
                    else begin
                        ready_n = 1'b1;
                        ready_cnt = 1'b0;
                    end
                    else begin
                        if (ready_n == 1'b0) begin
                            if (ready_cnt == 1'b1) begin
                                ready_n = 1'b1;
                                ready_cnt = 1'b0;
                            end
                            else begin
                                ready_n = 1'b0;
                                ready_cnt = 1'b1;
                            end
                            cs_n <= 1'b1;
                            in <= 1'b0;
                            out <= 1'b0;
                            clk_o <= 1'b0;
                            d_o <= 1'b0;
                            dataout <= 8'h00;
                        end
                        else begin
                            if (cs_n == 1'b1) begin
                                cntWrite = 0;
                                cntRead = 0;
                                clk_n = 1'b0;
                                c
                            end
                end
                if (endend == 1'b1) begin
                    if (endCnt == 2'b01) begin
                        ready_n = 1'b0;
                        cs_n = 1'b1;
                        dataout = 0;
                        endCnt = endCnt + 1'b1;
                    end
                    else if (endCnt == 2'b10) begin
                        ready_n = 1'b1;
                        cs_n = 1'b1;
                        endCnt = endCnt + 1'b1;
                    end
                    else if (endCnt == 2'b11) begin
                        start = 1'b0;
                        endend = 1'b0;
                        endCnt = 2'b00;
                        in_a = 1'b0; 
                        d_oa = 1'b0;
                        startWrite = 1'b0;
                        startRead = 1'b0;
                        cntWrite = 9'b0000_00000;
                        cntRead = 8'b0000_0000;
                        cnt = 3'b000; 
                        outBegin = 1'b0;
                        count = 1'b0;
                        ready_n = 1'b1;
                        cs_n = 1'b0;
                    end                
                end
                if (start == 1'b0) begin
                    start = 1'b1;
                    if (inNum == 0) startWrite = 1'b1;
                    if (outNum == 0) startRead = 1'b1;
                end
                if (startWrite == 1'b1 && startRead == 1'b1 && endCnt == 2'b00) begin
                    ready_n = 1'b0;
                    endend = 1'b1;
                    endCnt = 2'b01;
                    out = 1'b1;
                end
                if (outBegin == 1'b1) begin
                    outBegin = 1'b0;
                    out = 1'b1;
                    if (cntRead == outNum) begin
                        endend = 1'b1;
                        ready_n = 1'b0;
                        startRead = 1'b1;
                        endCnt = 2'b01;
                    end
                end
                if (count == 1'b0) begin //�½���
                    clk_n = 0;
                    count = 1'b1;
                    if (endend == 1'b0 && startWrite == 1'b0 && clk_tmp == 0) begin
                        if (cntWrite < inNum) begin
                            if (cnt < 3'b111) begin
                                d_oa <= datain[7-cnt];
                                cnt <= cnt + 3'b001;
                            end
                            else if (cnt == 3'b111) begin
                                d_oa <= datain[7-cnt];
                                cnt <= 3'b000;
                                in_a <= 1'b1;
                                cntWrite <= cntWrite + 1'b1;
                            end
                        end
                        else begin
                            startWrite <= 1'b1;
                            d_oa <= 1'b0;
                            cnt <= 3'b000;
                            if (startRead == 1'b1) begin
                                endend <= 1'b1;
                                ready_n <= 1'b0;
                                endCnt <= 2'b01;
                            end
                        end
                    end
                end
                else if (count == 1'b1) begin //������
                    count = 1'b0;
                    clk_n = 1;
                    in_a <= 1'b0;
                    out <= 1'b0;
                    if (endend == 1'b0 && startWrite == 1'b1 && startRead == 1'b0 && clk_tmp == 0) begin
                        if (cntRead < outNum) begin
                            if (cnt < 3'b111) begin
                                out <= 1'b0;
                                dataout[7-cnt] <= d_i;
                                cnt = cnt + 3'b001;
                            end
                            else if (cnt == 3'b111) begin
                                outBegin <= 1'b1;
                                dataout[0] <= d_i;
                                cnt <= 3'b000;
                                cntRead = cntRead + 1'b1;
                            end
                        end
                    end
                end 
            end
        end              
    endmodule