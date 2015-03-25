module registersbank(input write, input writeAddress, input writeData,
	input outputAddressA, input outputAddressB, output outputA, output outputB);

//entrada para representar o número do registrador a ser utilizado
input[4:0] outputAddressA, outputAddressB;
output[31:0] reg outputA, outputB;
input write;
input 

