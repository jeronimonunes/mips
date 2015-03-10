all:MIPS
MIPS: modules
modules:
	iverilog -o MIPS src/main/verilog/ULA.v
teste:
	iverilog -o MIPS_Test src/main/verilog/ULA.v
clear:
	rm *.out
