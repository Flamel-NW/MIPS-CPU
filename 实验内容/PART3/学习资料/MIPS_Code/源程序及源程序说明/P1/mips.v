module mips( clk, rst );
   input   clk;
   input   rst;
   
   wire 		     RFWr;
   wire 		     DMWr;
   wire 		     PCWr;
   wire 		     IRWr;
   wire [1:0]  EXTOp;
   wire [1:0]  ALUOp;
   wire [1:0]  NPCOp;
   wire [1:0]  GPRSel;
   wire [1:0]  WDSel;
   wire 		     BSel;
   wire 		     Zero;
   wire [29:0] PC, NPC;
   wire [31:0] im_dout, dm_dout;
   wire [31:0] DR_out;
   wire [31:0] instr;
   wire [4:0]  rs;
   wire [4:0]  rt;
   wire [4:0]  rd;
   wire [5:0]  Op;
   wire [5:0]  Funct;
   wire [15:0] Imm16; 
   wire [31:0] Imm32;
   wire [25:0] IMM;
   wire [4:0]  A3;
   wire [31:0] WD;
   wire [31:0] RD1, RD1_r, RD2, RD2_r;
   wire [31:0] B, C, C_r;
   
   assign Op = instr[31:26];
   assign Funct = instr[5:0];
   assign rs = instr[25:21];
   assign rt = instr[20:16];
   assign rd = instr[15:11];
   assign Imm16 = instr[15:0];
   assign IMM = instr[25:0];
   
   
   ctrl U_CTRL (
      .clk(clk),	.rst(rst), .Zero(Zero), .Op(Op),  .Funct(Funct),
      .RFWr(RFWr),   .DMWr(DMWr),   .PCWr(PCWr),   .IRWr(IRWr),
      .EXTOp(EXTOp), .ALUOp(ALUOp), .NPCOp(NPCOp), .GPRSel(GPRSel),
      .WDSel(WDSel), .BSel(BSel)
   );
   
   PC U_PC (
      .clk(clk), .rst(rst), .PCWr(PCWr), .NPC(NPC), .PC(PC)
   ); 
   
   NPC U_NPC ( 
      .PC(PC), .NPCOp(NPCOp), .IMM(IMM), .NPC(NPC)
   );
   
   im_4k U_IM ( 
      .addr(PC[9:0]) , .dout(im_dout)
   );
   
   IR U_IR ( 
      .clk(clk), .rst(rst), .IRWr(IRWr), .im_dout(im_dout), .instr(instr)
   );
   
   RF U_RF (
      .A1(rs), .A2(rt), .A3(A3), .WD(WD), .clk(clk), 
      .RFWr(RFWr), .RD1(RD1), .RD2(RD2)
   );
   
   mux4 #(5) U_MUX4_GPR_A3 (
      .d0(rd), .d1(rt), .d2(5'd31), .d3(/*undefine*/5'd0),
      .s(GPRSel), .y(A3)
   );

   mux4 #(32) U_MUX4_GPR_WD (
      .d0(C_r), .d1(DR_out), .d2({PC,2'b00}), .d3(/*undefine*/32'd0),
      .s(WDSel), .y(WD)
   );
   
   flopr #(32) U_RD1_Reg (
      .clk(clk), .rst(rst), .d(RD1), .q(RD1_r)
   );
   
   flopr #(32) U_RD2_Reg (
      .clk(clk), .rst(rst), .d(RD2), .q(RD2_r)
   );
   
   EXT U_EXT ( 
      .Imm16(Imm16), .EXTOp(EXTOp), .Imm32(Imm32) 
   );
   
   mux2 #(32) U_MUX_ALU_B (
      .d0(RD2_r), .d1(Imm32), .s(BSel) , .y(B)
   );
   
   alu U_ALU ( 
      .A(RD1_r), .B(B), .ALUOp(ALUOp), .C(C), .Zero(Zero)
   );
   
   flopr #(32) U_ALUOut (
      .clk(clk), .rst(rst), .d(C), .q(C_r)
   );
   
   dm_4k U_DM ( 
      .addr(C_r[11:2]), .din(RD2_r), .DMWr(DMWr), .clk(clk), .dout(dm_dout)
   );
   
   flopr #(32) U_DR (
      .clk(clk), .rst(rst), .d(dm_dout), .q(DR_out)
   );

endmodule