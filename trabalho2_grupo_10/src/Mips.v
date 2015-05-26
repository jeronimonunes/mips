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
reg clockFast;

assign oute = 0;
assign hb_mask = 0;
assign lb_mask = 0;
assign chip_en = 0;

always @(clock) clockFast = !clockFast;

always @(negedge reset) begin
	clockFast <= 0;
end

//Wires por causa do erro relatado no e-mail

	wire [4:0] addra;
	wire [4:0] addrb;
	wire [4:0] addrc;
	wire [4:0] addrout;
	wire [31:0] ass_dataa;
	wire [31:0] ass_datab;
	wire clock;
	wire [31:0] dataa;
	wire [31:0] datab;
	wire [31:0] datac;
	wire enc;
	wire ex_if_stall;
	wire ex_mem_readmem;
	wire [31:0] ex_mem_regb;
	wire [4:0] ex_mem_regdest;
	wire ex_mem_selwsource;
	wire [31:0] ex_mem_wbvalue;
	wire ex_mem_writemem;
	wire ex_mem_writereg;
	wire [2:0] id_ex_aluop;
	wire [31:0] id_ex_imedext;
	wire id_ex_readmem;
	wire [31:0] id_ex_rega;
	wire [31:0] id_ex_regb;
	wire [4:0] id_ex_regdest;
	wire id_ex_selalushift;
	wire id_ex_selimregb;
	wire id_ex_selwsource;
	wire [4:0] id_ex_shiftamt;
	wire [1:0] id_ex_shiftop;
	wire id_ex_unsig;
	wire id_ex_writemem;
	wire id_ex_writeov;
	wire id_ex_writereg;
	wire [31:0] id_if_pcimd2ext;
	wire [31:0] id_if_pcindex;
	wire [31:0] id_if_rega;
	wire id_if_selpcsource;
	wire [1:0] id_if_selpctype;
	wire [4:0] id_reg_addra;
	wire [4:0] id_reg_addrb;
	wire [31:0] if_id_instruc;
	wire [31:0] if_id_nextpc;
	wire [17:0] if_mc_addr;
	wire if_mc_en;
	wire [31:0] mc_if_data;
	wire [17:0] mc_ram_addr;
	wire [15:0] mc_ram_data;
	wire mc_ram_wre;
	wire [17:0] mem_mc_addr;
	wire [31:0] mem_mc_data;
	wire mem_mc_en;
	wire mem_mc_rw;
	wire [4:0] mem_wb_regdest;
	wire [31:0] mem_wb_wbvalue;
	wire mem_wb_writereg;
	wire [31:0] reg_id_ass_dataa;
	wire [31:0] reg_id_ass_datab;
	wire [31:0] reg_id_dataa;
	wire [31:0] reg_id_datab;
	wire [31:0] regout;
	wire reset;
	wire [4:0] wb_reg_addr;
	wire [31:0] wb_reg_data;
	wire wb_reg_en;

MemControler memControler(
    clockFast,
    reset,
    //Fetch
    if_mc_en,
    if_mc_addr,
    mc_if_data,
    //Memory
    mem_mc_rw,
    mem_mc_en,
    mem_mc_addr,
    mem_mc_data,
    //Ram
    mc_ram_addr,
    mc_ram_wre,
    mc_ram_data
);


Memory MEMORY(
    clock,
    reset,
    //Execute
    ex_mem_readmem,
    ex_mem_writemem,
    ex_mem_regb,
    ex_mem_selwsource,
    ex_mem_regdest,
    ex_mem_writereg,
    ex_mem_wbvalue,

    //Memory Controller
    mem_mc_rw,
    mem_mc_en,
    mem_mc_addr,
    mem_mc_data,
    //Writeback
    mem_wb_regdest,
    mem_wb_writereg,
    mem_wb_wbvalue
);

Execute EXECUTE(
	clock,
	reset,
    //Decode
	id_ex_selalushift,
	id_ex_selimregb,
	id_ex_aluop,
	id_ex_unsig,
	id_ex_shiftop,
	id_ex_shiftamt,
	id_ex_rega,
	id_ex_readmem,
	id_ex_writemem,
	id_ex_regb,
	id_ex_imedext,
	id_ex_selwsource,
	id_ex_regdest,
	id_ex_writereg,
	id_ex_writeov,
    //Fetch
	ex_if_stall,
    //Memory
	ex_mem_readmem,
	ex_mem_writemem,
	ex_mem_regb,
	ex_mem_selwsource,
	ex_mem_regdest,
	ex_mem_writereg,
	ex_mem_wbvalue
);


Writeback WRITEBACK(
    //Memory
    mem_wb_regdest,
    mem_wb_writereg,
    mem_wb_wbvalue,
    //Registers
    wb_reg_en,
    wb_reg_addr,
    wb_reg_data
);

Fetch FETCH(
    clock,
    reset,
    //Execute
    ex_if_stall,
    //Decode
    if_id_nextpc,
    if_id_instruc,
    id_if_selpcsource,
    id_if_rega,
    id_if_pcimd2ext,
    id_if_pcindex,
    id_if_selpctype,
    //Memory Controller
    if_mc_en,
    if_mc_addr,
    mc_if_data
);

Decode DECODE(
	clock,
	reset,
    //Fetch
	if_id_instruc,
	if_id_nextpc,
	id_if_selpcsource,
	id_if_rega,
	id_if_pcimd2ext,
	id_if_pcindex,
	id_if_selpctype,
    //Execute
	id_ex_selalushift,
	id_ex_selimregb,
	id_ex_aluop,
	id_ex_unsig,
	id_ex_shiftop,
	id_ex_shiftamt,
	id_ex_rega,
	id_ex_readmem,
	id_ex_writemem,
	id_ex_regb,
	id_ex_imedext,
	id_ex_selwsource,
	id_ex_regdest,
	id_ex_writereg,
	id_ex_writeov,
 //Registers
	id_reg_addra,
	id_reg_addrb,
	reg_id_dataa,
	reg_id_datab,
	reg_id_ass_dataa,
	reg_id_ass_datab
);

Registers REGISTERS (
	clock,
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
	regout
);

endmodule
