`include "MIPS.v"

module test;
    reg clk;
    reg reset;
    integer i;

    initial begin
        clk = 0;
        reset = 1;
        i = 0;

        $dumpfile("testWave.vcd");  // 指定VCD文件的名字为test.vcd，仿真信息将记录到此文件
        $dumpvars(0, test);  // 指定层次数为0，则tb_code 模块及其下面各层次的所有信号将被记录
        #50 $finish;
    end

    MIPS test(.Clk(clk), .Reset(reset));

    always #1 begin
        clk = ~clk;
    end

    always @(posedge clk) begin
        i = i + 1;
        $display("\n\n********************************************************************************");
        $display("********************************************************************************\n");
    end

    always @(negedge clk) begin
        if (i == 1) begin
            reset = 0;
        end
    end

endmodule