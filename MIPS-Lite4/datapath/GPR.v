
module GPR (
    input [4:0] A1,
    input [4:0] A2,
    input [4:0] A3,
    input [31:0] Wd,
    input Regwrite,
    input Clk,
    input Reset,
    
    output [31:0] Rd1,
    output [31:0] Rd2
);

    reg [31:0] Regs[0:31];

    integer i;
    reg Display;

    initial begin
        Display = 1'b1;  // test
    end

    assign Rd1 = Regs[A1];
    assign Rd2 = Regs[A2];

    always @(*) begin
        
        if (Reset)
            for (i = 0; i < 32; i++)
                Regs[i] = 0;

    end

    always @(posedge Clk) begin
        
        if (Regwrite)
            Regs[A3] <= Wd;
            
    end

    always @(negedge Clk) begin
        
        if (Display) begin
            $display("\n----------------------------------------");
            $display("Regs:");
            for (i = 0; i < 32; i++) begin
                $write("%h\t", Regs[i]);
                if (i % 4 == 3)
                    $display("");
            end
            $display("----------------------------------------");
        end
        
    end
    
endmodule