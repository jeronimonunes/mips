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
		$dumpvars(0,main.MIPS.REGISTERS.registers[0]);
		$dumpvars(0,main.MIPS.REGISTERS.registers[1]);
		$dumpvars(0,main.MIPS.REGISTERS.registers[2]);
		$dumpvars(0,main.MIPS.REGISTERS.registers[3]);
		$dumpvars(0,main.MIPS.REGISTERS.registers[4]);
		$dumpvars(0,main.MIPS.REGISTERS.registers[5]);
		$dumpvars(0,main.MIPS.REGISTERS.registers[6]);
		$dumpvars(0,main.MIPS.REGISTERS.registers[7]);
		$dumpvars(0,main.MIPS.REGISTERS.registers[8]);
		$dumpvars(0,main.MIPS.REGISTERS.registers[9]);
		$dumpvars(0,main.MIPS.REGISTERS.registers[10]);
		$dumpvars(0,main.MIPS.REGISTERS.registers[11]);
		$dumpvars(0,main.MIPS.REGISTERS.registers[12]);
		$dumpvars(0,main.MIPS.REGISTERS.registers[13]);
		$dumpvars(0,main.MIPS.REGISTERS.registers[14]);
		$dumpvars(0,main.MIPS.REGISTERS.registers[15]);
		$dumpvars(0,main.MIPS.REGISTERS.registers[16]);
		$dumpvars(0,main.MIPS.REGISTERS.registers[17]);
		$dumpvars(0,main.MIPS.REGISTERS.registers[18]);
		$dumpvars(0,main.MIPS.REGISTERS.registers[19]);
		$dumpvars(0,main.MIPS.REGISTERS.registers[20]);
		$dumpvars(0,main.MIPS.REGISTERS.registers[21]);
		$dumpvars(0,main.MIPS.REGISTERS.registers[22]);
		$dumpvars(0,main.MIPS.REGISTERS.registers[23]);
		$dumpvars(0,main.MIPS.REGISTERS.registers[24]);
		$dumpvars(0,main.MIPS.REGISTERS.registers[25]);
		$dumpvars(0,main.MIPS.REGISTERS.registers[26]);
		$dumpvars(0,main.MIPS.REGISTERS.registers[27]);
		$dumpvars(0,main.MIPS.REGISTERS.registers[28]);
		$dumpvars(0,main.MIPS.REGISTERS.registers[29]);
		$dumpvars(0,main.MIPS.REGISTERS.registers[30]);
		$dumpvars(0,main.MIPS.REGISTERS.registers[31]);

		/**
		 * Teste de carregamento complexo na memória
		 */
		#3 -> reset_trigger;
		@ (reset_done_trigger);
		$readmemh("tb/fibonacci.ram", main.RAM.memory);
		//Testando o carregamento do arquivo
		#1 if(main.RAM.memory[4]!=16'h2004 || main.RAM.memory[30]!=16'h100b || main.RAM.memory[32]!=16'h0040 || main.RAM.memory[262143]!=16'h0000)
			$display("Erro ao carregar a memória RAM"); 
		else
			$display("Memória carregada com sucesso");

		/**
		 * Instrução NOR
		 * addi $5, $0, 7
		 * nor $6, $5, $5
		 */
		#3 -> reset_trigger;
		@ (reset_done_trigger);
		$readmemh("tb/nor.ram", main.RAM.memory); 
		#50 if (main.MIPS.REGISTERS.registers[6] == 'hfffffff8)
			$display("A instrução NOR foi executada corretamente");
		else
			$display("A instrução NOR não foi executada corretamente");

		/**
		* instrução ADDI $2, $0, 4
		*/
		#3 -> reset_trigger;
		@ (reset_done_trigger);
		$readmemh("tb/addi.ram", main.RAM.memory); 
		#50 if (main.MIPS.REGISTERS.registers[2] == 4)
			$display("A instrução ADDI foi executada corretamente");
		else
			$display("A instrução ADDI não foi executada corretamente");
		
		/**
		* addi $10, $0, 1
		* addi $11, $0, -57
		* sub $12, $10, $11
		*/
		#3 -> reset_trigger;
		@ (reset_done_trigger);
		$readmemh("tb/sub.ram", main.RAM.memory);
		#55 if (main.MIPS.REGISTERS.registers[12] == 'h58)
			$display("A instrução SUB foi executada corretamente");
		else
			$display("A instrução SUB não foi executada corretamente");

		/**
		 * addi $29, $0, 5
		 * addi $30, $0, 4
		 * add $31, $29, $30
		 */
		#3 -> reset_trigger;
		@ (reset_done_trigger);
		$readmemh("tb/add.ram", main.RAM.memory);
		#55 if (main.MIPS.REGISTERS.registers[31] == 'h9)
			$display("A instrução ADD foi executada corretamente");
		else
			$display("A instrução ADD não foi executada corretamente");

		/**
		 * addi $6, $0, 3
		 * addi $7, $0, 4
		 * or $8, $6, $7
		 */
		#3 -> reset_trigger;
		@ (reset_done_trigger);
		$readmemh("tb/or.ram", main.RAM.memory);
		#55 if (main.MIPS.REGISTERS.registers[8] == 'h7)
			$display("A instrução OR foi executada corretamente");
		else 
			$display("A instrução OR não foi executada corretamente");

		/**
		 * addi $17, $0, -5
		 * addi $16, $0, 2
		 * subu $18, $17, $16
		 */
		#3 -> reset_trigger;
		@ (reset_done_trigger);
		$readmemh("tb/subu.ram", main.RAM.memory);
		#55 if (main.MIPS.REGISTERS.registers[18] == 'hfffffff9)
			$display("A instrução SUBU foi executada corretamente");
		else
			$display("A instrução SUBU não foi executada corretamente");
	end

	initial
		#1000  $finish;
endmodule /* main */
