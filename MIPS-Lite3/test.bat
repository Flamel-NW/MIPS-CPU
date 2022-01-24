cd MIPS-Lite3

iverilog testbench.v
vvp a.out > testlog.txt
@REM gtkwave testWave.vcd

del a.out
del testWave.vcd
