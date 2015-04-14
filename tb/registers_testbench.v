module registers_testbench;

	reg clock;
	reg reset;
	reg [4:0] addra;
	reg [4:0] addrb;
	reg enc;
	reg [4:0] addrc;
	reg [31:0] datac;

	wire [31:0] dataa;
	wire [31:0] datab;

	initial $dumpfile("registers_testbench.vcd");
	initial $dumpvars(0, registers_testbench);

	initial
	begin
		#0 clock=0;
		#0 reset=0;
		#0 addra=0;
		#0 addrb=0;
		#0 enc=0;
		#0 addrc=0;
		#0 datac=0;
		#2 reset=1;
		#2 reset=0;

		#1 addrc = 7;
		#0 enc = 1;
		#0 datac = 'h233;
		#0 addrb = 7;
		#20 $finish;
	end

	always #1 clock = !clock;

	Registers r(clock,reset,addra,dataa,addrb,
						datab,enc,addrc,datac);
endmodule
