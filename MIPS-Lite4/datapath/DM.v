
module DM (
    input [11:2] A,
    input [31:0] D,
    input [3:0] Membe,
    input Sign,
    input Memwrite,
    input Memread,
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

        if (Memread) begin
            case (Membe)

                4'b0001: out = {{24{Sign ? RAM[A][7] : 1'b0}}, RAM[A][7:0]};
                4'b0010: out = {{24{Sign ? RAM[A][15] : 1'b0}}, RAM[A][15:8]};
                4'b0100: out = {{24{Sign ? RAM[A][23] : 1'b0}}, RAM[A][23:16]};
                4'b1000: out = {{24{Sign ? RAM[A][31] : 1'b0}}, RAM[A][31:24]};

                4'b0011: out = {{16{Sign ? RAM[A][15] : 1'b0}}, RAM[A][15:0]};
                4'b1100: out = {{16{Sign ? RAM[A][31] : 1'b0}}, RAM[A][31:16]};

                4'b1111: out = RAM[A];
                
            endcase
        end
        
        if (Reset)
            for (i = 0; i < 1024; i++)
                RAM[i] = 0;

    end

    always @(posedge Clk) begin
        
        if (Memwrite) begin
            case (Membe)

                4'b0001: RAM[A][7:0] = D[7:0];
                4'b0010: RAM[A][15:8] = D[7:0];
                4'b0100: RAM[A][23:16] = D[7:0];
                4'b1000: RAM[A][31:24] = D[7:0];

                4'b0011: RAM[A][15:0] = D[15:0];
                4'b1100: RAM[A][31:16] = D[31:16];

                4'b1111: RAM[A] = D;

            endcase
        end
        
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