module sim;
reg clk;
reg rst;
reg [31:0] inst_field;
reg [31:0] Data_in;
reg rs1_used;
reg rs2_used;
reg ALUSrc_A;
reg ALUSrc_B;
reg [2:0] ALUC;
reg [1:0] ImmSel;
reg [1:0] DatatoReg;
reg PCEN;
reg Jump;
reg Branch;
reg RegWrite;
reg WR;
reg MIO;
reg sign;
reg jen;
reg blt;

wire [31:0] PCOUT;
wire [31:0] ID_IR;
wire [31:0] Data_out;
wire MWR;
wire M_MIO;
wire [31:0] ALU_out;
wire overflow;
wire zero;

wire [31:0]rs1_data;
wire [31:0]rs2_data;
wire [31:0]Imm32;
wire [31:0]Wt_data;
wire [31:0]ALUA;
wire [31:0]ALUB;
wire BJ_stall;
wire Data_stall;
wire J_stall;
wire [1:0] PCSource;
wire [31:0] ID_PCurrent;
wire [31:0] EX_IR;
wire [31:0] EX_PCurrent;
wire [31:0] MEM_IR;
wire [31:0] MEM_PCurrent;
wire [31:0] MEM_Target;
wire [31:0] WB_IR;
wire [31:0] WB_PCurrent;


RV32IPDP_C U1(
    .clk(clk),
    .rst(rst),
    .inst_field(inst_field),
    .Data_in(Data_in),
    .rs1_used(rs1_used),
    .rs2_used(rs2_used),
    .ALUSrc_A(ALUSrc_A),
    .ALUSrc_B(ALUSrc_B),
    .ALUC(ALUC),
    .ImmSel(ImmSel),
    .DatatoReg(DatatoReg),
    .PCEN(PCEN),
    .Jump(Jump),
    .Branch(Branch),
    .RegWrite(RegWrite),
    .WR(WR),
    .MIO(MIO),
    .sign(sign),
    .jen(jen),
    .blt(blt),
    
    .PCOUT(PCOUT),
    .ID_IR(ID_IR),
    .Data_out(Data_out),
    .MWR(MWR),
    .M_MIO(M_MIO),
    .ALU_out(ALU_out),
    .overflow(overflow),
    .zero(zero),
    
    .rs1_data(rs1_data),
    .rs2_data(rs2_data),
    .Imm32(Imm32),
    .Wt_data(Wt_data),
    .ALUA(ALUA),
    .ALUB(ALUB),
    .BJ_stall(BJ_stall),
    .Data_stall(Data_stall),
    .J_stall(J_stall),
    .PCSource(PCSource),
    .ID_PCurrent(ID_PCurrent),
    .EX_IR(EX_IR),
    .EX_PCurrent(EX_PCurrent),
    .MEM_IR(MEM_IR),
    .MEM_PCurrent(MEM_PCurrent),
    .MEM_Target(MEM_Target),
    .WB_IR(WB_IR),
    .WB_PCurrent(WB_PCurrent)
    );
    
parameter clk_period = 10;

initial begin
rst = 1; clk = 0; #10;
rst = 0; 
// lw x5, 12(x0)
inst_field = 32'h00C02283; Data_in = 32'h1234_5678; rs1_used = 1; rs2_used = 1; ALUSrc_A = 0; ALUSrc_B = 0; ALUC = 2'b00; ImmSel = 2'b00;
DatatoReg = 2'b00; PCEN = 1; Jump = 0; Branch = 0; RegWrite = 1; WR = 0; MIO = 1; sign = 1; jen = 0; blt = 1; #20;
// slt x6, x0, x5
inst_field = 32'h00502333; Data_in = 32'h11111111; rs1_used = 1; rs2_used = 1; ALUSrc_A = 0; ALUSrc_B = 0; ALUC = 2'b00; ImmSel = 2'b00;
DatatoReg = 2'b01; PCEN = 1; Jump = 0; Branch = 0; RegWrite = 1; WR = 0; MIO = 0; sign = 1; jen = 0; blt = 1; #20;
// add x7, x6, x6
inst_field = 32'h006303B3; Data_in = 32'h2222_2222; rs1_used = 1; rs2_used = 1; ALUSrc_A = 0; ALUSrc_B = 0; ALUC = 2'b00; ImmSel = 2'b00;
DatatoReg = 2'b01; PCEN = 1; Jump = 0; Branch = 0; RegWrite = 1; WR = 0; MIO = 0; sign = 1; jen = 0; blt = 1; #20;
// or x12, x9, x30
inst_field = 32'h01E4E633; Data_in = 32'h3333_3333; rs1_used = 1; rs2_used = 1; ALUSrc_A = 0; ALUSrc_B = 0; ALUC = 2'b00; ImmSel = 2'b00;
DatatoReg = 2'b01; PCEN = 1; Jump = 0; Branch = 0; RegWrite = 1; WR = 0; MIO = 0; sign = 1; jen = 0; blt = 1; #20;
// sub x13, x0, x6
inst_field = 32'h406006B3; Data_in = 32'h4444_4444; rs1_used = 1; rs2_used = 1; ALUSrc_A = 0; ALUSrc_B = 0; ALUC = 2'b00; ImmSel = 2'b00;
DatatoReg = 2'b01; PCEN = 1; Jump = 0; Branch = 0; RegWrite = 1; WR = 0; MIO = 0; sign = 1; jen = 0; blt = 1; #20;
// beq x0, x0, begin
inst_field = 32'h00000463; Data_in = 32'h5555_5555; rs1_used = 1; rs2_used = 1; ALUSrc_A = 0; ALUSrc_B = 0; ALUC = 2'b00; ImmSel = 2'b00;
DatatoReg = 2'b01; PCEN = 1; Jump = 0; Branch = 0; RegWrite = 1; WR = 0; MIO = 0; sign = 1; jen = 0; blt = 1; #20;
// add x0, x0, x0
inst_field = 32'h00000033; Data_in = 32'h6666_6666; rs1_used = 1; rs2_used = 1; ALUSrc_A = 0; ALUSrc_B = 0; ALUC = 2'b00; ImmSel = 2'b00;
DatatoReg = 2'b01; PCEN = 1; Jump = 0; Branch = 0; RegWrite = 1; WR = 0; MIO = 0; sign = 1; jen = 0; blt = 1; #20;
// jal x0, end
inst_field = 32'h0040006F; Data_in = 32'h0000_0004; rs1_used = 0; rs2_used = 0; ALUSrc_A = 0; ALUSrc_B = 1; ALUC = 2'b00; ImmSel = 2'b11;
DatatoReg = 2'b10; PCEN = 1; Jump = 1; Branch = 0; RegWrite = 1; WR = 0; MIO = 0; sign = 1; jen = 0; blt = 1; #20;
// add x1, x1, x2
inst_field = 32'h002080B3; Data_in = 32'h7777_7777; rs1_used = 1; rs2_used = 1; ALUSrc_A = 0; ALUSrc_B = 0; ALUC = 2'b00; ImmSel = 2'b00;
DatatoReg = 2'b01; PCEN = 1; Jump = 0; Branch = 0; RegWrite = 1; WR = 0; MIO = 0; sign = 1; jen = 0; blt = 1; #20;

end

always #(clk_period)  begin
   clk = ~clk;
end

endmodule