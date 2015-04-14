module Registers (
	input clock,
	input reset,
	input [4:0] addra,
	output reg [31:0] dataa,
	input [4:0] addrb,
	output reg [31:0] datab,
	input enc,
	input [4:0] addrc,
	input [31:0] datac);

	reg [31:0] registers [31:0];
	reg [4:0] i;

	//Reset token
	always @(posedge clock) begin
		if(reset==1) begin
			for(i = 0; i < 31;i = i + 1) begin
				registers[i] = 0;
			end
		end
	end

	//Data a
	always @(posedge clock) begin
		dataa = registers[addra];
	end	

	//Data b
	always @(posedge clock) begin
		datab = registers[addrb];
	end

	//Data c
	always @(posedge clock) begin
		if(enc==1) begin
			registers[addrc] = datac;
		end
	end

endmodule
