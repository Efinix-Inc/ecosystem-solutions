`ifndef PRE_DEFINE_VH
	`define PRE_DEFINE_VH

	// DW : 64 128 256 512
	`define DW 			256
	// DSC_BYP: 4'b0000 or 4'b1111. one bit per channel.
	`define DSC_BYP 	0
    // Channel number
	`define CHANNEL_NUM 1
	// DMA_ST: 1: ST; 0: AXI
	`define ST_MODE 	0
    // Define PAR type
    `define DB_PCIE_ODD_EVEN_SELECT  1    
`endif