
module PC (
    input [31:2] nPC,
    input Clk,
    input Reset,

    output reg [31:2] PC
);

    always @(posedge Clk) begin
        
        PC <= nPC;

    end

    always @(*) begin

        if (Reset)
            PC = 30'h00000000;

    end

endmodule