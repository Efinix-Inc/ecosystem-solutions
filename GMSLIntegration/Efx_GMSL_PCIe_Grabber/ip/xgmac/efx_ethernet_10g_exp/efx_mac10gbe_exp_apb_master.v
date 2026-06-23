`define IP_UUID _449a7b9bfbac46b2a2d60d871e2fb598
`define IP_NAME_CONCAT(a,b) a``b
`define IP_MODULE_NAME(name) `IP_NAME_CONCAT(name,`IP_UUID)

module efx_mac10gbe_exp_apb_master # (
	parameter ROM_MIF			= "./efx_rom_mif.mem",
	parameter ROM_DEPTH		= 10,
	parameter RAM_ADDR_W		= 5, //Depth = 32, Stores up to 32 entries
	parameter PADDR_WIDTH	= 24,
	parameter PDATA_WIDTH	= 32
) (
	input  logic							apb_halt_i,
	output logic							apb_rom_end_o,
	output logic							apb_done_o,

	input  logic							ram_usr_wren_i,
	input  logic [RAM_ADDR_W -1:0]	ram_usr_addr_i,
	output logic [PDATA_WIDTH-1:0]	ram_dout_d_o,
	output logic [PADDR_WIDTH-1:0]	ram_dout_a_o,

	input  logic							usr_apb_start_i,
	input  logic							usr_apb_write_i,
	input  logic [PADDR_WIDTH-1:0]	usr_apb_addr_i,
	input  logic [PDATA_WIDTH-1:0]	usr_apb_pwdata_i,

	// APB BUS signal
	output logic							PSEL,
	output logic							PWRITE,
	output logic							PENABLE,
	output logic [PADDR_WIDTH-1:0]	PADDR,
	output logic [PDATA_WIDTH-1:0]	PWDATA,

	input  logic							PCLK, // 200Mhz
	input  logic							PRESETn,
	input  logic [PDATA_WIDTH-1:0]	PRDATA,
	input  logic							PREADY,
	input  logic							PSLVERR
);

`IP_MODULE_NAME(efx_mac10gbe_exp_apb_master)# (
	.ROM_MIF(ROM_MIF),
	.ROM_DEPTH(ROM_DEPTH),
	.RAM_ADDR_W(RAM_ADDR_W), //Depth = 32, Stores up to 32 entries
	.PADDR_WIDTH(PADDR_WIDTH),
	.PDATA_WIDTH(PDATA_WIDTH)
) inst_apb_master (
    .apb_halt_i(apb_halt_i),
    .apb_rom_end_o(apb_rom_end_o),
    .apb_done_o(apb_done_o),
    
    .ram_usr_wren_i(ram_usr_wren_i),
    .ram_usr_addr_i(ram_usr_addr_i),
    .ram_dout_d_o(ram_dout_d_o),
    .ram_dout_a_o(ram_dout_a_o),
    
    .usr_apb_start_i(usr_apb_start_i),
    .usr_apb_write_i(usr_apb_write_i),
    .usr_apb_addr_i(usr_apb_addr_i),
    .usr_apb_pwdata_i(usr_apb_pwdata_i),
    
    
    .PSEL(PSEL),
    .PWRITE(PWRITE),
    .PENABLE(PENABLE),
    .PADDR(PADDR),
    .PWDATA(PWDATA),
    
    .PCLK(PCLK), // 200Mhz
    .PRESETn(PRESETn),
    .PRDATA(PRDATA),
    .PREADY(PREADY),
    .PSLVERR(PSLVERR)
);
endmodule

//pragma protect
//pragma protect begin

/* Encryption Envelope */

`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "QuestaSim" , encrypt_agent_info = "2021.1"
`pragma protect key_keyowner = "Efinix Inc." , key_keyname = "EFX_K01"
`pragma protect key_method = "rsa"
`pragma protect encoding = ( enctype = "base64" , line_length = 64 , bytes = 256 )
`pragma protect key_block
bGbmdyroRuOXbC35O92XMuHF2orfGjfOp8Q22BKF6KbDl9p7YhFAuCNNdYAO+hJL
bKqhKai/G5P7AXhDatDlsu84l3USHX4ITE9lrIXhKk+uLAtRujGOb1vEY8Z+MvA6
11cViXJd4grOUzhDbughwTzEcoiEcH2BjEmXWuBgdeOr8/R9H/okJwKNHJAQv6Xa
436FrXTZ3Hsluk9RWIsXkFzuo0SDA8sH9/xeJYGikdhjkY+KMuBvuObqXGMiPerf
7Ye/XhAi5mXJrOyQ2NH4AccAsRwE7PRMW6ddQPdFuHY7QMqHyhDgXftbUROgqtMV
09dRYYvyUKYWO/jN+KkqGA==
`pragma protect data_method = "aes256-cbc"
`pragma protect encoding = ( enctype = "base64" , line_length = 64 , bytes = 5760 )
`pragma protect data_block
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
`pragma protect end_protected

//pragma protect end

`undef IP_UUID
`undef IP_NAME_CONCAT
`undef IP_MODULE_NAME
