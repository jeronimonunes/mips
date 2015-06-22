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
	wire [31:0] regout;
	wire [4:0] addrout;
	wire [31:0] memout;

	Mips MIPS(
		clock,
		reset,
		addr,
		data,
		wre,
		oute,
		hb_mask,
		lb_mask,
		chip_en,
		regout,
		addrout,
		memout
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

	/**
	 * Eventos criados para reset do processador
	 * Como cada instrução vai ser testada individualmente com uma memória limpa,
	 * será necessário
	 */
	event reset_trigger;
	event reset_done_trigger;

	initial begin
		forever begin
			@ (reset_trigger);
			#1 reset = 1'b0;
			#1 reset = 1'b1;
			#1 -> reset_done_trigger;
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
		* instrução INC $2, $0
		* instrução INC $2, $2
		*/
		#3 -> reset_trigger;
		@(reset_done_trigger);
		$readmemh("tb/inc.ram", main.RAM.memory); 
		#50 if (main.MIPS.REGISTERS.registers[2] == 2)
			$display("A instrução INC foi executada corretamente");
		else 
			$display("A instrução INC não foi executada corretamente");

		/**
		* ADDI $29, 5
		* ADDI $30, 4
		* NOP * 4
		* MUL $31, $30, $29
		*/
		#3 -> reset_trigger;
		@(reset_done_trigger);
		$readmemh("tb/mul.ram", main.RAM.memory); 
		#100 if (main.MIPS.REGISTERS.registers[31] == 'h14)
			$display("A instrução MUL foi executada corretamente");
		else
			$display("A instrução MUL não foi executada corretamente");

		/**
		* ADDI $29, 0x7fff
		* ADDI $30, 0x7fff
		* NOP * 4
		* MUL $29, $30, $29
		* MUL $29, $30, $29
		* A Instrução acima ativa o sinal de overflow como esperado.
		*/
		#3 -> reset_trigger;
		@(reset_done_trigger);
		$readmemh("tb/mulovertest.ram", main.RAM.memory);
		#100 if (main.MIPS.REGISTERS.registers[29] == 'h3fff0001)
			$display("Deu overflow! Tudo certo!");
		else
			$display("Não deu overflow! Algo errado ocorreu!");
	end

	initial
		#270  $finish;

endmodule /* main */