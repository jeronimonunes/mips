all:MIPS
MIPS: modules
modules:
	iverilog -o MIPS src/registers.v tb/registers_testbench.v
	./MIPS
	gtkwave registers_testbench.vcd
clear:
	rm *.out
