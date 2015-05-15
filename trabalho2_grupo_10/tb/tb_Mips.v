module main;
	reg clock;
	reg reset;
	reg [17:0]	addr;
	wire [15:0] data;
	reg wre;
	reg oute;
	reg hb_mask;
	reg lb_mask;
	reg chip_en;

	Mips mips(clock, reset, addr, data, wre, oute, hb_mask, lb_mask, chip_en);

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
      $dumpvars(1, main.mips);
      $monitor("reset=%b addra =%b dataa=%b addrb=%b datab=%b enc=%b addrc=%b datac=%b", reset, addra, dataa, addrb, datab, enc, addrc, datac);
      #2 -> reset_trigger;
      @ (reset_done_trigger);

	initial
	   #500  $finish;
endmodule /* main */
