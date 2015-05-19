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

//Pedaço do clock dividido;
reg internalClock;

always @(posedge clock) internalClock = !internalClock;

always @(negedge reset) begin
	internalClock <= 0;
end

//Fios
wire [17:0] mc_ram_addr;
assign mc_ram_addr = addr;

MemControler memControler(
    .clock(clock),
    .reset(reset),
    //Fetch
    .if_mc_en(FETCH.if_mc_en),
    .if_mc_addr(FETCH.if_mc_addr),
    .mc_if_data(FETCH.mc_if_data),
    //Memory
    .mem_mc_rw(MEMORY.mem_mc_rw),
    .mem_mc_en(MEMORY.mem_mc_en),
    .mem_mc_addr(MEMORY.mem_mc_addr),
    .mem_mc_data(MEMORY.mem_mc_data),
    //Ram
    .mc_ram_addr(addr),
    .mc_ram_wre(wre),
    .mc_ram_data(data)
);
/*
	//Memory Controler 
	wire if_mc_en; 
	wire [17:0] if_mc_addr;
	wire [31:0] mc_if_data;

	//Memory.Execute	
	wire ex_mem_readmem,
	ex_mem_writemem,
	ex_mem_writereg,
	mem_wb_writereg,
	ex_mem_selwsource;
	wire [31:0] ex_mem_regb;
	wire [4:0] ex_mem_regdest;
	wire [31:0] ex_mem_wbvalue;
	wire [4:0] mem_wb_regdest;
	wire [31:0] mem_wb_wbvalue;
*/

Memory MEMORY(
    .clock(clock),
    .reset(reset),
    //Execute
    .ex_mem_readmem(EXECUTE.ex_mem_readmem),
    .ex_mem_writemem(EXECUTE.ex_mem_writemem),
    .ex_mem_regb(EXECUTE.ex_mem_regb),
    .ex_mem_selwsource(EXECUTE.ex_mem_selwsource),
    .ex_mem_regdest(EXECUTE.ex_mem_regdest),
    .ex_mem_writereg(EXECUTE.ex_mem_writereg),
    .ex_mem_wbvalue(EXECUTE.ex_mem_wbvalue),
    //Memory Controller
    .mem_mc_rw(memControler.mem_mc_rw),
    .mem_mc_en(memControler.mem_mc_en),
    .mem_mc_addr(memControler.mem_mc_addr),
    .mem_mc_data(memControler.mem_mc_data),
    //Writeback
    .mem_wb_regdest(WRITEBACK.mem_wb_regdest),
    .mem_wb_writereg(WRITEBACK.mem_wb_writereg),
    .mem_wb_wbvalue(WRITEBACK.mem_wb_wbvalue)
);

Execute EXECUTE(
	.clock(clock),
	.reset(reset),
    //Decode
	.id_ex_selalushift(DECODE.id_ex_selalushift),
	.id_ex_selimregb(DECODE.id_ex_selimregb),
	.id_ex_aluop(DECODE.id_ex_aluop),
	.id_ex_unsig(DECODE.id_ex_unsig),
	.id_ex_shiftop(DECODE.id_ex_shiftop),
	.id_ex_shiftamt(DECODE.id_ex_shiftamt),
	.id_ex_rega(DECODE.id_ex_rega),
	.id_ex_readmem(DECODE.id_ex_readmem),
	.id_ex_writemem(DECODE.id_ex_writemem),
	.id_ex_regb(DECODE.id_ex_regb),
	.id_ex_imedext(DECODE.id_ex_imedext),
	.id_ex_selwsource(DECODE.id_ex_selwsource),
	.id_ex_regdest(DECODE.id_ex_regdest),
	.id_ex_writereg(DECODE.id_ex_writereg),
	.id_ex_writeov(DECODE.id_ex_writeov),
    //Fetch
	.ex_if_stall(FETCH.ex_if_stall),
    //Memory
	.ex_mem_readmem(MEMORY.ex_mem_readmem),
	.ex_mem_writemem(MEMORY.ex_mem_writemem),
	.ex_mem_regb(MEMORY.ex_mem_regb),
	.ex_mem_selwsource(MEMORY.ex_mem_selwsource),
	.ex_mem_regdest(MEMORY.ex_mem_regdest),
	.ex_mem_writereg(MEMORY.ex_mem_writereg),
	.ex_mem_wbvalue(MEMORY.ex_mem_wbvalue)
);


Writeback WRITEBACK(
    //Memory
    .mem_wb_regdest(MEMORY.mem_wb_regdest),
    .mem_wb_writereg(MEMORY.mem_wb_writereg),
    .mem_wb_wbvalue(MEMORY.mem_wb_regdest),
    //Registers
    .wb_reg_en(REGISTERS.wb_reg_en),
    .wb_reg_addr(REGISTERS.wb_reg_addr),
    .wb_reg_data(REGISTERS.wb_reg_data)
);

Fetch FETCH(
    .clock(clock),
    .reset(reset),
    //Execute
    .ex_if_stall(EXECUTE.ex_if_stall),
    //Decode
    .if_id_nextpc(DECODE.if_id_nextpc),
    .if_id_instruc(DECODE.if_id_instruc),
    .id_if_selpcsource(DECODE.id_if_selpcsource),
    .id_if_rega(DECODE.id_if_rega),
    .id_if_pcimd2ext(DECODE.id_if_pcindex),
    .id_if_pcindex(DECODE.id_if_pcindex),
    .id_if_selpctype(DECODE.id_if_selpctype),
    //Memory Controller
    .if_mc_en(memControler.if_mc_en),
    .if_mc_addr(memControler.if_mc_addr),
    .mc_if_data(memControler.mc_if_data)
);

Decode DECODE(
	.clock(clock),
	.reset(reset),
    //Fetch
	.if_id_instruc(FETCH.if_id_instruc),
	.if_id_nextpc(FETCH.if_id_nextpc),
	.id_if_selpcsource(FETCH.id_if_selpcsource),
	.id_if_rega(FETCH.id_if_rega),
	.id_if_pcimd2ext(FETCH.id_if_pcimd2ext),
	.id_if_pcindex(FETCH.id_if_pcindex),
	.id_if_selpctype(FETCH.id_if_selpctype),
    //Execute
	.id_ex_selalushift(EXECUTE.id_ex_selalushift),
	.id_ex_selimregb(EXECUTE.id_ex_selimregb),
	.id_ex_aluop(EXECUTE.id_ex_aluop),
	.id_ex_unsig(EXECUTE.id_ex_unsig),
	.id_ex_shiftop(EXECUTE.id_ex_shiftop),
	.id_ex_shiftamt(EXECUTE.id_ex_shiftamt),
	.id_ex_rega(EXECUTE.id_ex_rega),
	.id_ex_readmem(EXECUTE.id_ex_readmem),
	.id_ex_writemem(EXECUTE.id_ex_writemem),
	.id_ex_regb(EXECUTE.id_ex_regb),
	.id_ex_imedext(EXECUTE.id_ex_imedext),
	.id_ex_selwsource(EXECUTE.id_ex_selwsource),
	.id_ex_regdest(EXECUTE.id_ex_regdest),
	.id_ex_writereg(EXECUTE.id_ex_writereg),
	.id_ex_writeov(EXECUTE.id_ex_writeov),
 //Registers
	.id_reg_addra(REGISTERS.addra),
	.id_reg_addrb(REGISTERS.addrb),
	.reg_id_dataa(REGISTERS.dataa),
	.reg_id_datab(REGISTERS.datab),
	.reg_id_ass_dataa(REGISTERS.ass_dataa),
	.reg_id_ass_datab(REGISTERS.ass_datab)
);

wire clock,
	reset,
	addra,
	dataa,
	ass_dataa,
	addrb,
	datab,
	ass_datab,
	enc,
	addrc,
	datac,
	addrout,
	regout;

Registers REGISTERS (
	clock,
	reset,
	addra(DECODE.addra),
	dataa(DECODE.dataa),
	.ass_dataa(DECODE.reg_id_ass_dataa),
	addrb(DECODE.addrb),
	.datab(DECODE.datab),
	.ass_datab(DECODE.reg_id_ass_datab),
	enc,
	addrc,
	datac,
	addrout,
	regout
);

endmodule
