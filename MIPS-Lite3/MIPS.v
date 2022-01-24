`include "datapath/ALU.v"
`include "datapath/DM.v"
`include "datapath/Extender.v"
`include "datapath/IM.v"
`include "datapath/PC.v"
`include "datapath/nPC.v"
`include "datapath/GPR.v"
`include "control/Controller.v"
`include "utils/mux.v"

module MIPS (
    input Clk,
    input Reset
);

    reg Display;

    initial begin
        Display = 1'b1;  // test
    end

    wire [1:0] Regdst;
    wire Alusrc;
    wire Memwrite;
    wire [1:0] Memtoreg;
    wire Regwrite;
    wire [1:0] nPC_sel;
    wire Extop;
    wire [2:0] Aluop;

    wire [31:2] nPC;
    wire [31:2] PC;

    wire [31:0] Instr;

    wire Zero;
    wire [31:0] PC_add;    

    wire [4:0] A3_in;
    wire [31:0] Wd_in;
    wire [31:0] Rd1_A;
    wire [31:0] Rd2_out;

    wire [31:0] Imm_ext;

    wire [31:0] B_in;
    wire [31:0] C_out;

    wire [31:0] DMout;

    Controller m_Controller(.op(Instr[31:26]), .func(Instr[5:0]), 
        .Regdst(Regdst), .Alusrc(Alusrc), .Memwrite(Memwrite), .Memtoreg(Memtoreg), .Regwrite(Regwrite), .nPC_sel(nPC_sel), .Extop(Extop), .Aluop(Aluop));

    PC m_PC(.nPC(nPC), .Clk(Clk), .Reset(Reset), 
        .PC(PC));

    IM m_IM(.PC(PC),
        .Instr(Instr));

    nPC m_nPC(.PC(PC), .IMM(Instr[25:0]), .Reg(Rd1_A), .nPC_sel(nPC_sel), .Zero(Zero),
        .nPC(nPC), .PC_add(PC_add));

    mux31_5 mReg_mux31_5(.A(Instr[20:16]), .B(Instr[15:11]), .C(5'b11111), .sel(Regdst), 
        .out(A3_in));

    GPR m_GPR(.A1(Instr[25:21]), .A2(Instr[20:16]), .A3(A3_in), .Regwrite(Regwrite), .Wd(Wd_in), .Clk(Clk), .Reset(Reset), 
        .Rd1(Rd1_A), .Rd2(Rd2_out));

    Extender m_Extender(.A(Instr[15:0]), .Extop(Extop), 
        .B(Imm_ext));

    mux21_32 mALU_mux21_32(.A(Rd2_out), .B(Imm_ext), .sel(Alusrc), 
        .out(B_in));

    ALU m_ALU(.A(Rd1_A), .B(B_in), .F(Aluop), 
        .C(C_out), .Zero(Zero));

    DM m_DM(.A(C_out[11:2]), .D(Rd2_out), .Memwrite(Memwrite), .Memtoreg(Memtoreg[0]), .Reset(Reset), .Clk(Clk), 
        .out(DMout));

    mux31_32 mMemtoreg_mux31_32(.A(C_out), .B(DMout), .C(PC_add), .sel(Memtoreg), 
        .out(Wd_in));

    always @(negedge Clk) begin
        
        if (Display) begin
            $display("\n----------------------------------------");
            $display("PC:");
            $display("%d", PC);
            $display("Instruction:");
            $display("%b", Instr);
            $display("----------------------------------------");
        end

    end

endmodule