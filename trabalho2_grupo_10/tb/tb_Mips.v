module main;

	reg clock;
	reg reset;

	Mips MIPS(
		.clock(clock),
		.reset(reset),
		.addr(RAM.addr),
		.data(RAM.data),
		.wre(RAM.wre),
		.oute(RAM.oute),
		.hb_mask(RAM.hb_mask),
		.lb_mask(RAM.lb_mask),
		.chip_en(RAM.chip_en)
	);

	Ram RAM(
		.addr(MIPS.addr),
		.data(MIPS.data),
		.wre(MIPS.wre),
		.oute(MIPS.oute),
		.hb_mask(MIPS.hb_mask),
		.lb_mask(MIPS.lb_mask),
		.chip_en(MIPS.chip_en)
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
		$dumpfile("mips.vcd");
		$dumpvars(0, main.MIPS);
		$dumpvars(0, main.RAM);
		
		/*
		instrução ADDI
		 */
		#3 -> reset_trigger;
		@ (reset_done_trigger);
		$readmemh("tb/addi.ram", main.RAM.memory);

		#20

		
		/*
		instrução SUB
		 */
		#3 -> reset_trigger;
		@ (reset_done_trigger);
		$readmemh("tb/sub.ram", main.RAM.memory);
		#20 if (main.MIPS.REGISTERS.registers[4] == 6)begin
			$display("A instrução SUB foi executada corretamente");
		end else begin
			$display("A instrução SUB não foi executada corretamente");
		end

		/*
		instrução ADD
		 */
		#3 -> reset_trigger;
		@ (reset_done_trigger);
		$readmemh("tb/add.ram", main.RAM.memory);
		#20 if (main.MIPS.REGISTERS.registers[4] == 26)begin
			$display("A instrução ADD foi executada corretamente");
		end else begin
			$display("A instrução ADD não foi executada corretamente");
		end
		
		/*
		
		 */
		
		#3 -> reset_trigger;
		@ (reset_done_trigger);
		$readmemh("tb/add.ram", main.RAM.memory);
		#20 if (main.MIPS.REGISTERS.registers[4] == 26)begin
			$display("A instrução ADD foi executada corretamente");
		end else begin
			$display("A instrução ADD não foi executada corretamente");
		end

			
/*		#1
		$readmemh("fibonacci.ram", main.RAM.memory);
		//Testando o carregamento do arquivo
		if(main.RAM.memory[5]!=16'h0006 || main.RAM.memory[31]!=16'h0003 || main.RAM.memory[33]!=16'h4820 || main.RAM.memory[262143]!=16'h0000)
			$display("Erro ao carregar a memória RAM");
		else
			$display("Memória carregada com sucesso!!!");*/
	end

	initial
		#1000  $finish;
endmodule /* main */
