module Mips (
	input clock,
	input reset,
	//RAM
	output	[17:0]	addr,
	inout	[15:0]	data,
	output		wre,
	output		oute,
	output		hb_mask,
	output		lb_mask,
	output		chip_en
);

reg internalClock;

always @(posedge clock) internalClock = !internalClock;

always @(negedge reset) begin
	internalClock <= 0;
end

endmodule
