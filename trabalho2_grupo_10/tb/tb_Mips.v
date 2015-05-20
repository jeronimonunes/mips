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

	Mips MIPS(
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
		$readmemh("fibonacci.ram", main.RAM.memory);
		//Testando o carregamento do arquivo
		if(main.RAM.memory[5]!=16'h0006 || main.RAM.memory[31]!=16'h0003 || main.RAM.memory[33]!=16'h4820 || main.RAM.memory[262143]!=16'h0000)
			$display("Erro ao carregar a memória RAM");
		else
			$display("Memória carregada com sucesso!!!");

		$dumpfile("mips.vcd");
		$dumpvars(1, main.MIPS);
		#2 -> reset_trigger;
		@ (reset_done_trigger);
		#700 $display("%d",main.MIPS.REGISTERS.registers[2]);
	end

	initial
		#1000  $finish;
endmodule /* main */
