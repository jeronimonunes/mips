MIPS: tb/inc.ram tb/mulovertest.ram tb/tb_Mips.v src/Mips.v src/Ram.v src/MemControler.v src/Memory.v src/Execute.v src/Writeback.v src/Fetch.v src/Decode.v src/Registers.v src/Alu.v src/Shifter.v src/Comparator.v src/Control.v
	iverilog -o MIPS tb/tb_Mips.v src/Mips.v src/Ram.v src/MemControler.v src/Memory.v src/Execute.v src/Writeback.v src/Fetch.v src/Decode.v src/Registers.v src/Alu.v src/Shifter.v src/Comparator.v src/Control.v
	./MIPS
	gtkwave mips.vcd
clear:
	rm *.o MIPS
all:modules

modules: Alu Comparator Control Decode Execute Fetch MemController Memory Mips Ram Registers Shifter Writeback

Alu: src/Alu.v 
	iverilog -o Alu.o src/Alu.v
Comparator: src/Comparator.v 
	iverilog -o Comparator.o src/Comparator.v
Control: src/Control.v 
	iverilog -o Control.o src/Control.v
Decode: src/Decode.v 
	iverilog -o Decode.o src/Decode.v src/Comparator.v src/Control.v
Execute: src/Execute.v 
	iverilog -o Execute.o src/Execute.v src/Alu.v src/Shifter.v
Fetch: src/Fetch.v 
	iverilog -o Fetch.o src/Fetch.v
MemController: src/MemController.v 
	iverilog -o MemController.o src/MemController.v
Memory: src/Memory.v 
	iverilog -o Memory.o src/Memory.v
Mips: src/Mips.v 
	iverilog -o Mips.o src/Mips.v
Ram: src/Ram.v 
	iverilog -o Ram.o src/Ram.v
Registers: src/Registers.v 
	iverilog -o Registers.o src/Registers.v
Shifter: src/Shifter.v 
	iverilog -o Shifter.o src/Shifter.v
Writeback: src/Writeback.v 
	iverilog -o Writeback.o src/Writeback.v
