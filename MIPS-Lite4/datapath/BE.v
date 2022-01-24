
module BE (
    input [1:0] Addr,
    input [2:0] BE_sel,

    output reg [3:0] Membe,
    output Sign
);

    assign Sign = BE_sel[2];

    always @(*) begin

        Membe = 4'b0000;
        case (BE_sel[1:0])
            2'b00: Membe = 4'b1111;
            2'b01: Membe[Addr] = 1'b1;
            2'b10: begin
                if (Addr)
                    Membe[3:2] = 2'b11;
                else
                    Membe[1:0] = 2'b11;
            end
        endcase

    end
    
endmodule