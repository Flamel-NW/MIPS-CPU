
module IM (
    input [31:2] PC,
    
    output [31:0] Instr
);
    
    reg [31:0] ROM[0:1024];

    initial begin
        $readmemh("code.dat", ROM);
    end

    assign Instr = ROM[PC[12:2]];

endmodule