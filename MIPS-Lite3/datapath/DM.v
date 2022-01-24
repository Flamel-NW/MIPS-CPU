
module DM (
    input [11:2] A,
    input [31:0] D,
    input Memwrite,
    input Memtoreg,
    input Reset,
    input Clk,
    
    output reg [31:0] out
);

    reg [31:0] RAM[0:1024];

    integer i;
    reg Display;

    initial begin
        Display = 1'b1;  // test
    end

    always @(*) begin

        if (Memtoreg)
            out = RAM[A];
        
        if (Reset)
            for (i = 0; i < 1024; i++)
                RAM[i] = 0;

    end

    always @(posedge Clk) begin
        
        if (Memwrite)
            RAM[A] <= D;
        
    end

    always @(negedge Clk) begin
        
        if (Display) begin
            $display("\n----------------------------------------");
            $display("Memory:");
            for (i = 0; i < 32; i++) begin
                $write("%h\t", RAM[i]);
                if (i % 4 == 3)
                    $display("");
            end
            $display("----------------------------------------");
        end

    end
    
endmodule