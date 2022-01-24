`include "ctrl_encode_def.v"
`include "instruction_def.v"
module ctrl(clk,	rst, Zero, Op, Funct,
            RFWr, DMWr, PCWr, IRWr,
            EXTOp, ALUOp, NPCOp, GPRSel,
            WDSel, BSel);
    
   input 		     clk, rst, Zero;       
   input  [5:0] Op;
   input  [5:0] Funct;
   output       RFWr;
   output       DMWr;
   output       PCWr;
   output       IRWr;
   output [1:0] EXTOp;
   output [1:0] ALUOp;
   output [1:0] NPCOp;
   output [1:0] GPRSel;
   output [1:0] WDSel;
   output       BSel; 
    
   parameter Fetch  = 4'b0000,
             DCD    = 4'b0001,
             Exe    = 4'b0010,
             MA     = 4'b0011,
             Branch = 4'b0100,
             Jmp    = 4'b0101,
             MR     = 4'b0110,
             MW     = 4'b0111,
             WB     = 4'b1000,
             MemWB  = 4'b1001;
    
	
   wire RType;   // Type of R-Type Instruction
   wire IType;   // Tyoe of Imm    Instruction  
   wire BrType;  // Type of Branch Instruction
   wire JType;   // Type of Jump   Instruction
   wire LdType;  // Type of Load   Instruction
   wire StType;  // Type of Store  Instruction
   wire MemType; // Type pf Memory Instruction(Load/Store)
	
   assign RType   = (Op == `INSTR_RTYPE_OP);
   assign IType   = (Op == `INSTR_ORI_OP  );
   assign BrType  = (Op == `INSTR_BEQ_OP  );
   assign JType   = (Op == `INSTR_JAL_OP  );
	assign LdType  = (Op == `INSTR_LW_OP   );
	assign StType  = (Op == `INSTR_SW_OP   );
   assign MemType = LdType || StType;
    
	/*************************************************/
	/******               FSM                   ******/
   reg [3:0] nextstate;
   reg [3:0] state;
   
   always @(posedge clk or posedge rst) begin
	   if ( rst )
		   state <= Fetch;
      else
         state <= nextstate;
	end // end always
             
   always @(*) begin
      case (state)
         Fetch: nextstate = DCD;
         DCD: begin
            if ( RType || IType ) 
				   nextstate = Exe;
            else if ( MemType ) 
               nextstate = MA;
            else if ( BrType )
               nextstate = Branch;
            else if ( JType )
               nextstate = Jmp;
            else   //if Op wrong, then fetch next one.
               nextstate = Fetch;
         end
         Exe:  nextstate = WB;
         MA: begin 
            if ( LdType )
				   nextstate = MR;   //LW
            else if ( StType )
					nextstate = MW;   //SW
			end
         Branch: nextstate = Fetch;
         Jmp: 	nextstate = Fetch;
         MR:   nextstate = MemWB;
         MW:   nextstate = Fetch;
         WB: 	 nextstate = Fetch;
         MemWB: nextstate = Fetch;      
			default: ;
       endcase
   end // end always
	
	
	/*************************************************/
	/******         Control Signal              ******/
	reg       RFWr;
   reg       DMWr;
   reg       PCWr;
   reg       IRWr;
   reg [1:0] EXTOp;
   reg [1:0] ALUOp;
   reg [1:0] NPCOp;
   reg [1:0] GPRSel;
   reg [1:0] WDSel;
   reg       BSel;
	
	always @( * ) begin
	   case ( state ) 
		   Fetch: begin
            PCWr   = 1'b1;
            NPCOp  = `NPC_PLUS4; 
            IRWr   = 1'b1;
            RFWr  = 1'b0;
            DMWr   = 1'b0;
            EXTOp  = 0;
            GPRSel = 0;
            WDSel  = 0;
            BSel   = 0;
            ALUOp  = 0;
			end // end Fetch
         DCD: begin
            PCWr   = 1'b0;
            NPCOp  = 0;
            IRWr   = 1'b0;
            RFWr  = 1'b0;
            DMWr   = 1'b0;
            EXTOp  = 0;
            GPRSel = 0;
            WDSel  = 0;
            BSel   = 0;
            ALUOp  = 0;
			end	// end DCD
         Exe: 	begin
            PCWr   = 1'b0;
            NPCOp  = 0;
            IRWr   = 1'b0;
            RFWr  = 1'b0;
            DMWr   = 1'b0;
            if (Op == `INSTR_ORI_OP)
               EXTOp = `EXT_ZERO;
            else
               EXTOp = 0;
            GPRSel = 0;
            WDSel  = 0;
            DMWr   = 0;
            if (IType)
               BSel   = 1'b1;
            else
               BSel   = 1'b0;
            if (Op == `INSTR_ORI_OP)
               ALUOp = `ALUOp_OR;
            else if (Op == `INSTR_RTYPE_OP) begin
               case (Funct)
                   `INSTR_ADDU_FUNCT: ALUOp = `ALUOp_ADDU;
                   `INSTR_SUBU_FUNCT: ALUOp = `ALUOp_SUBU;
                   default: ;
               endcase
            end
			end // end Exe
         MA: begin
            PCWr   = 1'b0;
            NPCOp  = 0;
            IRWr   = 1'b0;
            RFWr  = 1'b0;
            DMWr   = 1'b0;
            EXTOp  = `EXT_SIGNED;
            GPRSel = 0;
            WDSel  = 0;
            BSel   = 1'b1;
            ALUOp  = `ALUOp_ADDU;
			end // end MA
         Branch: begin
            if (Zero) 
               PCWr = 1'b1;
            else
               PCWr = 1'b0;
            NPCOp  = `NPC_BRANCH;
            IRWr   = 1'b0;
            RFWr  = 1'b0;
            DMWr   = 1'b0;
            EXTOp  = `EXT_SIGNED;
            GPRSel = 0;
            WDSel  = 0;
            BSel   = 1'b0;
            ALUOp  = 0;
			end // end Branch
         Jmp: 	begin
            PCWr   = 1'b1;
            NPCOp  = `NPC_JUMP;
            IRWr   = 1'b0;
            RFWr  = 1'b1;
            DMWr   = 1'b0;
            EXTOp  = `EXT_SIGNED;
            GPRSel = `GPRSel_31;
            WDSel  = `WDSel_FromPC;
            BSel   = 0;
            ALUOp  = 0;
			end // end Jmp
         MR:  begin
            PCWr   = 1'b0;
            NPCOp  = 0;
            IRWr   = 1'b0;
            RFWr  = 1'b0;
            DMWr   = 1'b0;
            EXTOp  = 0;
            GPRSel = 0;
            WDSel  = 0;
            BSel   = 0;
            ALUOp  = 0;
			end // end MR
         MW:  begin
            PCWr   = 1'b0;
            NPCOp  = 0;
            IRWr   = 1'b0;
            RFWr  = 1'b0;
            DMWr   = 1'b1;
            EXTOp  = 0;
            GPRSel = 0;
            WDSel  = 0;
            BSel   = 0;
            ALUOp  = 0;
			end // end MW
         WB: 	begin
            PCWr   = 1'b0;
            NPCOp  = 0;
            IRWr   = 1'b0;
            RFWr  = 1'b1;
            DMWr   = 1'b0;
            EXTOp  = 0;
            if (IType)
               GPRSel = `GPRSel_RT;
            else
               GPRSel = `GPRSel_RD;
            WDSel  = `WDSel_FromALU;
            BSel   = 0;
            ALUOp  = 0;
			end // end WB
         MemWB: begin
            PCWr   = 1'b0;
            NPCOp  = 0;
            IRWr   = 1'b0;
            RFWr  = 1'b1;
            DMWr   = 1'b0;
            EXTOp  = 0;
            GPRSel = `GPRSel_RT;
            WDSel  = `WDSel_FromMEM;
            BSel   = 0;
            ALUOp  = 0;
			end // end MemWB
			default: begin
            PCWr   = 1'b0;
            NPCOp  = 0;
            IRWr   = 1'b0;
            RFWr  = 1'b0;
            DMWr   = 1'b0;
            EXTOp  = 0;
            GPRSel = 0;
            WDSel  = 0;
            BSel   = 0;
            ALUOp  = 0;
			end // end default
	   endcase
   end // end always
    
endmodule
