
module ALU (
    input [31:0] A,
    input [31:0] B,
    input [2:0] F,
    
    output reg [31:0] C,
    output Zero
);
    
    assign Zero = C ? 0 : 1;

    always @(*) begin
        
        case (F)
            3'b001: C = A | B;
            3'b010: C = A - B;
            3'b011: C = A + B;
            3'b100: C = (A < B) ? 32'd1 : 32'd0;
            3'b101: C = B;
        endcase

    end

endmodule