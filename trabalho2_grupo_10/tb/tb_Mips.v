module main;

	reg clock;
	reg reset;
	wire [17:0]	addr;
	wire [15:0] data;
	wire wre;
	wire oute;
	wire hb_mask;
	wire lb_mask;
	wire chip_en;

	Mips mips(
		.clock(clock),
		.reset(reset),
		.addr(addr),
		.data(data),
		.wre(wre),
		.oute(oute),
		.hb_mask(hb_mask),
		.lb_mask(lb_mask),
		.chip_en(chip_en)
	);

	Ram RAM(
		.addr(addr),
		.data(data),
		.wre(wre),
		.oute(oute),
		.hb_mask(hb_mask),
		.lb_mask(lb_mask),
		.chip_en(chip_en)
	);

	initial begin
	   clock = 0;
	end

	event reset_trigger;
	event reset_done_trigger;

	initial begin
		forever begin
			@ (reset_trigger);
			#1
			reset = 1'b0;
			#1
			reset = 1'b1;
			-> reset_done_trigger;
		end
	end

	always
	   #1 clock = !clock;

	initial begin
		$readmemh("/home/grad/ccomp/13/jeronimonunes/data.hex", main.RAM.memory);
		$display("%x\n",main.RAM.memory[1]);

		$dumpfile("mips.vcd");
		$dumpvars(1, main.mips);
		#2 -> reset_trigger;
		@ (reset_done_trigger);

	end

	initial
		#500  $finish;
endmodule /* main */
