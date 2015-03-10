module ula_testbench;

#TODO It's not going to be like this. We will use all 32 bits of MIPS
#TODO And we are gonna see how much wires does the operation of MIPS uses
#TODO inside the OC1 book
reg [15:0] entrada1;
reg [15:0] regA;
reg [2:0] OpSelect;

wire [15:0] saida_ula;

initial $dumpfile("ula_testbench.vcd");
initial $dumpvars(0, ula_testbench);

initial
begin
    #1 OpSelect = 101; entrada1 = 16'b0000000000001000;
    #1 OpSelect = 001; regA = 16'b0000000000001001;
    #1 OpSelect = 000;
    #1 OpSelect = 111;
end

ula u(entrada1, regA, OpSelect, saida_ula);

endmodule
