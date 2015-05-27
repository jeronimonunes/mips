module main;

	reg clock;

	 reg reset;
	 wire [17:0] addr;
	 wire [15:0] data;
	 wire wre;
	 wire oute;
	 wire hb_mask;
	 wire lb_mask;
	 wire chip_en;

	Mips MIPS(
		clock,
		reset,
		addr,
		data,
		wre,
		oute,
		hb_mask,
		lb_mask,
		chip_en
	);

	Ram RAM(
		addr,
		data,
		wre,
		oute,
		hb_mask,
		lb_mask,
		chip_en
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
		
		/**
		* instrução ADDI
		*/
		#3 -> reset_trigger;
		@ (reset_done_trigger);
		$readmemh("tb/addi.ram", main.RAM.memory);

			
		/*
		instrução SUB
		#3 -> reset_trigger;
		@ (reset_done_trigger);
		$readmemh("tb/sub.ram", main.RAM.memory);
		#20 if (main.MIPS.REGISTERS.registers[4] == 6)begin
			$display("A instrução SUB foi executada corretamente");
		end else begin
			$display("A instrução SUB não foi executada corretamente");
		end

		/*
		instrução ADD: 15+11
		#3 -> reset_trigger;
		@ (reset_done_trigger);
		$readmemh("tb/add.ram", main.RAM.memory);
		$display("%d", main.MIPS.REGISTERS.registers[28]);
		#20 if (main.MIPS.REGISTERS.registers[4] == 26)begin
			$display("A instrução ADD foi executada corretamente");
		end else begin
			$display("A instrução ADD não foi executada corretamente");
		end
		
		 */
		
		/*
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
