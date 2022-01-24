
module mux21_32 (
    input [31:0] A,
    input [31:0] B,
    input sel,

    output reg [31:0] out
);

always @(*) begin
    case (sel)
        1'b0: out = A;
        1'b1: out = B;
    endcase
end
    
endmodule


module mux31_5 (
    input [4:0] A,
    input [4:0] B,
    input [4:0] C,
    input [1:0] sel,

    output reg [4:0] out
);

always @(*) begin
    case (sel)
        2'b00: out = A;
        2'b01: out = B;
        2'b10: out = C;
    endcase
end

endmodule

module mux31_32 (
    input [31:0] A,
    input [31:0] B,
    input [31:0] C,
    input [1:0] sel,

    output reg [31:0] out
);

always @(*) begin
    case (sel)
        2'b00: out = A;
        2'b01: out = B;
        2'b10: out = C;
    endcase
end
    
endmodule
