all:modules
MIPS:
	iverilog -o MIPS Alu.v Decode.v MemController.v Ram.v Writeback.v Comparator.v Execute.v Memory.v Registers.v Control.v Fetch.v Mips.v Shifter.v
	./MIPS
	gtkwave registers_testbench.vcd
clear:
	rm *.o

modules: Alu Comparator Control Decode Execute Fetch MemController Memory Mips Ram Registers Shifter Writeback

Alu: Alu.v 
	iverilog -o Alu.o Alu.v
Comparator: Comparator.v 
	iverilog -o Comparator.o Comparator.v
Control: Control.v 
	iverilog -o Control.o Control.v
Decode: Decode.v 
	iverilog -o Decode.o Decode.v Comparator.v Control.v
Execute: Execute.v 
	iverilog -o Execute.o Execute.v Alu.v Shifter.v
Fetch: Fetch.v 
	iverilog -o Fetch.o Fetch.v
MemController: MemController.v 
	iverilog -o MemController.o MemController.v
Memory: Memory.v 
	iverilog -o Memory.o Memory.v
Mips: Mips.v 
	iverilog -o Mips.o Mips.v
Ram: Ram.v 
	iverilog -o Ram.o Ram.v
Registers: Registers.v 
	iverilog -o Registers.o Registers.v
Shifter: Shifter.v 
	iverilog -o Shifter.o Shifter.v
Writeback: Writeback.v 
	iverilog -o Writeback.o Writeback.v
