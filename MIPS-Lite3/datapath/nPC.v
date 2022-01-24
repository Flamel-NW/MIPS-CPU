
module nPC (
    input [31:2] PC,
    input [25:0] IMM,
    input [31:0] Reg,
    input [1:0] nPC_sel,
    input Zero,

    output reg [31:2] nPC,
    output [31:0] PC_add
);

    always @(*) begin
        
        case (nPC_sel)
            2'b00: nPC = PC + 30'd1;
            2'b01: nPC = PC + 30'd1 + (Zero ? {{14{IMM[15]}}, IMM[15:0]} : 0);
            2'b10: nPC = {PC[31:28], IMM};
            2'b11: nPC = Reg[31:2];
        endcase

    end

    assign PC_add = {PC + 30'd1, {2{1'b0}}};
    
endmodule
