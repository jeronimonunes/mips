module ula(clock, inputA, inputB, operation, outputA);

//Clock variable, the output value will ve available in A on posedge
input clock;

//The two variables to perform the operation
input [32:0] inputA;
input [32:0] inputB;

//The operation, corresponding to the six last numbers in MIPS instruction
input [5:0] operation;

//The output value
output reg [32:0] outputA;

always @(*) begin
    case(operation)
	 6'd32: outputA = inputA + inputB; // add
         6'd34: outputA = inputA - inputB; // sub
         6'd24: outputA = inputA * inputB; // mult
         6'd26: outputA = inputA / inputB; // div
	default: outputA = 32'd0;
    endcase
end


endmodule
