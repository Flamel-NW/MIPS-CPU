
module Extender (
    input [15:0] A,
    input Extop,
    
    output [31:0] B
);

    mux21_32 m_mux21_32(.A({{16{A[15]}}, A}), 
        .B({A, {16{1'b0}}}), 
        .sel(Extop), 
        .out(B));
    
endmodule