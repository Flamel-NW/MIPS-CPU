// NPC control signal
`define NPC_PLUS4   2'b00
`define NPC_BRANCH  2'b01
`define NPC_JUMP    2'b10   

// EXT control signal
`define EXT_ZERO    2'b00
`define EXT_SIGNED  2'b01
`define EXT_HIGHPOS 2'b10

// ALU control signal
`define ALUOp_ADDU  2'b00
`define ALUOp_SUBU  2'b01
`define ALUOp_OR    2'b10


// GPR control signal
`define GPRSel_RD   2'b00
`define GPRSel_RT   2'b01
`define GPRSel_31   2'b10

`define WDSel_FromALU 2'b00
`define WDSel_FromMEM 2'b01
`define WDSel_FromPC  2'b10 