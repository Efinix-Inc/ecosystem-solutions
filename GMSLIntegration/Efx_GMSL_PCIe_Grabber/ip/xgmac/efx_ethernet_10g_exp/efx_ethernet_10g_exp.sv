module efx_ethernet_10g_exp #(
	parameter Q1_RAM_ADDR_W					= 5,
	parameter Q3_RAM_ADDR_W					= 5,

	parameter Q1_ROM_DEPTH					= 6,
	parameter Q3_ROM_DEPTH					= 6,

	parameter REG_WIDTH						= 'd32,

	parameter APB_PADDR_WIDTH				= 24,
	parameter APB_PDATA_WIDTH				= 32,
	parameter AXIS_DW							= 64
) (
	input  logic								INIT_CLK,
	input  logic								IN_USER,
	input  logic								PLL_LOCKED,

	input  logic								Q1_APB_CLK,
	input  logic								Q3_APB_CLK,

	output logic								Q1_L2_PCS_RST_N_RX,
	output logic								Q1_L2_PCS_RST_N_TX,
	input  logic								Q1_L2_BLOCK_LOCK,
	input  logic								Q1_L2_HI_BER,
	input  logic								Q1_L2_IRQ,
	input  logic								Q1_L2_PCS_STATUS,
	input  logic								Q1_L2_PHY_INTERRUPT,
	output logic								Q1_L2_PMA_TX_ELEC_IDLE,
	output logic								Q1_L2_ETH_EEE_ALERT_EN,

	
	output logic								Q1_L2_KR_TRAINING_ENABLE,
	output logic								Q1_L2_KR_RESTART_TRAINING,
	input  logic								Q1_L2_KR_TRAINING,
	input  logic								Q1_L2_KR_FRAME_LOCK,
	input  logic								Q1_L2_KR_LOCAL_RX_TRAINED,
	input  logic								Q1_L2_KR_SIGNAL_DETECT,
	input  logic								Q1_L2_KR_TRAINING_FAILURE,

	output logic								Q3_L2_PCS_RST_N_RX,
	output logic								Q3_L2_PCS_RST_N_TX,
	input  logic								Q3_L2_BLOCK_LOCK,
	input  logic								Q3_L2_HI_BER,
	input  logic								Q3_L2_IRQ,
	input  logic								Q3_L2_PCS_STATUS,
	input  logic								Q3_L2_PHY_INTERRUPT,
	output logic								Q3_L2_PMA_TX_ELEC_IDLE,
	output logic								Q3_L2_ETH_EEE_ALERT_EN,
	
	output logic								Q3_L2_KR_TRAINING_ENABLE,
	output logic								Q3_L2_KR_RESTART_TRAINING,
	input  logic								Q3_L2_KR_TRAINING,
	input  logic								Q3_L2_KR_FRAME_LOCK,	
	input  logic								Q3_L2_KR_LOCAL_RX_TRAINED,
	input  logic								Q3_L2_KR_SIGNAL_DETECT,
	input  logic								Q3_L2_KR_TRAINING_FAILURE,

	output logic								Q1_USER_APB_PSEL,
	output logic								Q1_USER_APB_PWRITE,
	output logic								Q1_USER_APB_PENABLE,
	output logic [APB_PADDR_WIDTH-1:0]	Q1_USER_APB_PADDR,
	output logic [APB_PDATA_WIDTH-1:0]	Q1_USER_APB_PWDATA,
	input  logic [APB_PDATA_WIDTH-1:0]	Q1_USER_APB_PRDATA,
	input  logic								Q1_USER_APB_PREADY,
	input  logic								Q1_USER_APB_PSLVERR,

	output logic								Q3_USER_APB_PSEL,
	output logic								Q3_USER_APB_PWRITE,
	output logic								Q3_USER_APB_PENABLE,
	output logic [APB_PADDR_WIDTH-1:0]	Q3_USER_APB_PADDR,
	output logic [APB_PDATA_WIDTH-1:0]	Q3_USER_APB_PWDATA,
	input  logic [APB_PDATA_WIDTH-1:0]	Q3_USER_APB_PRDATA,
	input  logic								Q3_USER_APB_PREADY,
	input  logic								Q3_USER_APB_PSLVERR,

	output logic								PASS_STATUS,

	output logic [63:0]						Q1_L2_TXD,
	output logic [7:0]						Q1_L2_TXC,
	input  logic [63:0]						Q1_L2_RXD,
	input  logic [7:0]						Q1_L2_RXC,

	output logic [63:0]						Q3_L2_TXD,
	output logic [7:0]						Q3_L2_TXC,
	input  logic [63:0]						Q3_L2_RXD,
	input  logic [7:0]						Q3_L2_RXC,

`ifndef VERIF
	input  logic								DEBUG_CLK,
`endif

`ifdef VERIF
	input  logic								in_Q1_L2_cnt_rst_n,
	input  logic								in_Q1_L2_rx_pause_ignore,
	input  logic [47:0]						in_Q1_L2_rx_address_filtering_mask,
	input  logic								in_Q1_L2_tx_pause_gen,
	input  logic [15:0]						in_Q1_L2_tx_pause_quant,

	input  logic								in_Q3_L2_cnt_rst_n,
	input  logic								in_Q3_L2_rx_pause_ignore,
	input  logic [47:0]						in_Q3_L2_rx_address_filtering_mask,
	input  logic								in_Q3_L2_tx_pause_gen,
	input  logic [15:0]						in_Q3_L2_tx_pause_quant,
	
	input  logic								in_Q1_ram_usr_wren_w,
	input  logic [Q1_RAM_ADDR_W-1:0]		in_Q1_ram_usr_addr_w,
	input  logic								in_Q1_usr_apb_start_w,
	input  logic [APB_PADDR_WIDTH-1:0]	in_Q1_usr_apb_addr_w,
	input  logic								in_Q1_usr_apb_write_w,
	input  logic [APB_PDATA_WIDTH-1:0]	in_Q1_usr_apb_pwdata_w,
	
	input  logic								in_Q3_ram_usr_wren_w,
	input  logic [Q3_RAM_ADDR_W-1:0]		in_Q3_ram_usr_addr_w,
	input  logic								in_Q3_usr_apb_start_w,
	input  logic [APB_PADDR_WIDTH-1:0]	in_Q3_usr_apb_addr_w,
	input  logic								in_Q3_usr_apb_write_w,
	input  logic [APB_PDATA_WIDTH-1:0]	in_Q3_usr_apb_pwdata_w,
	
	input  logic								Q1_L2_restart_kr_training_IN,
	input  logic								Q3_L2_restart_kr_training_IN,
`endif

	//Port Declaration
	input  logic		Q1_L2_10gbe_clk,
	input  logic		Q1_PMA_CMN_READY,
	output logic		Q1_L2_PMA_XCVR_PLLCLK_EN,
	input  logic		Q1_L2_PMA_XCVR_PLLCLK_EN_ACK,
	output logic [3:0]		Q1_L2_PMA_XCVR_POWER_STATE_REQ,
	input  logic [3:0]		Q1_L2_PMA_XCVR_POWER_STATE_ACK,
	input  logic		Q1_L2_PMA_RX_SIGNAL_DETECT,
	input  logic		Q3_L2_10gbe_clk,
	input  logic		Q3_PMA_CMN_READY,
	output logic		Q3_L2_PMA_XCVR_PLLCLK_EN,
	input  logic		Q3_L2_PMA_XCVR_PLLCLK_EN_ACK,
	output logic [3:0]		Q3_L2_PMA_XCVR_POWER_STATE_REQ,
	input  logic [3:0]		Q3_L2_PMA_XCVR_POWER_STATE_ACK,
	input  logic		Q3_L2_PMA_RX_SIGNAL_DETECT,
	input  logic		jtag_vio_CAPTURE,
	input  logic		jtag_vio_DRCK,
	input  logic		jtag_vio_RESET,
	input  logic		jtag_vio_RUNTEST,
	input  logic		jtag_vio_SEL,
	input  logic		jtag_vio_SHIFT,
	input  logic		jtag_vio_TCK,
	input  logic		jtag_vio_TDI,
	input  logic		jtag_vio_TMS,
	input  logic		jtag_vio_UPDATE,
	output logic		jtag_vio_TDO
);

//Wire Declaration
logic		Q1_apb_rom_end_w;
logic		Q1_apb_done_w;
logic		Q1_ram_usr_wren_w;
logic [Q1_RAM_ADDR_W -1:0]		Q1_ram_usr_addr_w;
logic [APB_PDATA_WIDTH-1:0]		Q1_ram_dout_d_w;
logic [APB_PADDR_WIDTH-1:0]		Q1_ram_dout_a_w;
logic		Q1_usr_apb_start_w;
logic		Q1_usr_apb_write_w;
logic [APB_PADDR_WIDTH-1:0]		Q1_usr_apb_addr_w;
logic [APB_PDATA_WIDTH-1:0]		Q1_usr_apb_pwdata_w;
logic		Q1_apb_halt_w;
logic		Q1_L2_init_done;
logic [AXIS_DW-1:0]		Q1_L2_rx_axis_mac_tdata;
logic		Q1_L2_rx_axis_mac_tvalid;
logic		Q1_L2_rx_axis_mac_tlast;
logic [AXIS_DW/8-1:0]		Q1_L2_rx_axis_mac_tkeep;
logic		Q1_L2_rx_axis_mac_tuser;
logic [AXIS_DW-1:0]		Q1_L2_tx_axis_mac_tdata;
logic		Q1_L2_tx_axis_mac_tvalid;
logic		Q1_L2_tx_axis_mac_tlast;
logic [AXIS_DW/8-1:0]		Q1_L2_tx_axis_mac_tkeep;
logic		Q1_L2_tx_axis_mac_tuser;
logic		Q1_L2_tx_axis_mac_tready;
logic		Q1_L2_cnt_rst_n;
logic		Q1_L2_rx_pause_ignore;
logic [47:0]		Q1_L2_rx_address_filtering_mask;
logic		Q1_L2_tx_pause_gen;
logic [15:0]		Q1_L2_tx_pause_quant;
logic		Q1_L2_tx_pause_busy;
logic [REG_WIDTH-1:0]		Q1_L2_cnt_tx_frame_transmitted_good;
logic [REG_WIDTH-1:0]		Q1_L2_cnt_tx_frame_pause_mac_ctrl;
logic [REG_WIDTH-1:0]		Q1_L2_cnt_tx_frame_error_txfifo_overflow;
logic [REG_WIDTH-1:0]		Q1_L2_cnt_tx_frame_is_fe;
logic [REG_WIDTH-1:0]		Q1_L2_cnt_rx_frame_received_good;
logic [13:0]		Q1_L2_rpt_rx_frame_length;
logic [REG_WIDTH-1:0]		Q1_L2_cnt_rx_frame_error_fcs;
logic [REG_WIDTH-1:0]		Q1_L2_cnt_rx_frame_pause_mac_ctrl;
logic [REG_WIDTH-1:0]		Q1_L2_cnt_rx_frame_errors;
logic [REG_WIDTH-1:0]		Q1_L2_cnt_rx_frame_received_total;
logic [REG_WIDTH-1:0]		Q1_L2_cnt_rx_frame_undersized;
logic [REG_WIDTH-1:0]		Q1_L2_cnt_rx_frame_oversized;
logic [REG_WIDTH-1:0]		Q1_L2_cnt_rx_frame_mismatched_length;
logic [REG_WIDTH-1:0]		Q1_L2_cnt_rx_frame_filtered_by_address;
logic		Q1_L2_pass_status;
logic		Q1_L2_rx_tuser_pass;
logic		Q1_L2_fe_pkt_pass;
logic		Q1_L2_kr_training_pass;
logic		Q1_L2_pcs_fault_pass;
logic		Q1_L2_auto_nego_pass;
logic		Q1_L2_phy_interrupt_pass;
logic		Q3_apb_rom_end_w;
logic		Q3_apb_done_w;
logic		Q3_ram_usr_wren_w;
logic [Q3_RAM_ADDR_W -1:0]		Q3_ram_usr_addr_w;
logic [APB_PDATA_WIDTH-1:0]		Q3_ram_dout_d_w;
logic [APB_PADDR_WIDTH-1:0]		Q3_ram_dout_a_w;
logic		Q3_usr_apb_start_w;
logic		Q3_usr_apb_write_w;
logic [APB_PADDR_WIDTH-1:0]		Q3_usr_apb_addr_w;
logic [APB_PDATA_WIDTH-1:0]		Q3_usr_apb_pwdata_w;
logic		Q3_apb_halt_w;
logic		Q3_L2_init_done;
logic [AXIS_DW-1:0]		Q3_L2_rx_axis_mac_tdata;
logic		Q3_L2_rx_axis_mac_tvalid;
logic		Q3_L2_rx_axis_mac_tlast;
logic [AXIS_DW/8-1:0]		Q3_L2_rx_axis_mac_tkeep;
logic		Q3_L2_rx_axis_mac_tuser;
logic [AXIS_DW-1:0]		Q3_L2_tx_axis_mac_tdata;
logic		Q3_L2_tx_axis_mac_tvalid;
logic		Q3_L2_tx_axis_mac_tlast;
logic [AXIS_DW/8-1:0]		Q3_L2_tx_axis_mac_tkeep;
logic		Q3_L2_tx_axis_mac_tuser;
logic		Q3_L2_tx_axis_mac_tready;
logic		Q3_L2_cnt_rst_n;
logic		Q3_L2_rx_pause_ignore;
logic [47:0]		Q3_L2_rx_address_filtering_mask;
logic		Q3_L2_tx_pause_gen;
logic [15:0]		Q3_L2_tx_pause_quant;
logic		Q3_L2_tx_pause_busy;
logic [REG_WIDTH-1:0]		Q3_L2_cnt_tx_frame_transmitted_good;
logic [REG_WIDTH-1:0]		Q3_L2_cnt_tx_frame_pause_mac_ctrl;
logic [REG_WIDTH-1:0]		Q3_L2_cnt_tx_frame_error_txfifo_overflow;
logic [REG_WIDTH-1:0]		Q3_L2_cnt_tx_frame_is_fe;
logic [REG_WIDTH-1:0]		Q3_L2_cnt_rx_frame_received_good;
logic [13:0]		Q3_L2_rpt_rx_frame_length;
logic [REG_WIDTH-1:0]		Q3_L2_cnt_rx_frame_error_fcs;
logic [REG_WIDTH-1:0]		Q3_L2_cnt_rx_frame_pause_mac_ctrl;
logic [REG_WIDTH-1:0]		Q3_L2_cnt_rx_frame_errors;
logic [REG_WIDTH-1:0]		Q3_L2_cnt_rx_frame_received_total;
logic [REG_WIDTH-1:0]		Q3_L2_cnt_rx_frame_undersized;
logic [REG_WIDTH-1:0]		Q3_L2_cnt_rx_frame_oversized;
logic [REG_WIDTH-1:0]		Q3_L2_cnt_rx_frame_mismatched_length;
logic [REG_WIDTH-1:0]		Q3_L2_cnt_rx_frame_filtered_by_address;
logic		Q3_L2_pass_status;
logic		Q3_L2_rx_tuser_pass;
logic		Q3_L2_fe_pkt_pass;
logic		Q3_L2_kr_training_pass;
logic		Q3_L2_pcs_fault_pass;
logic		Q3_L2_auto_nego_pass;
logic		Q3_L2_phy_interrupt_pass;


//Customized Logic
logic	Q1_L2_pcs_rst_n;
always @(posedge Q1_L2_10gbe_clk) begin
	if(~PLL_LOCKED)
		Q1_L2_pcs_rst_n	<= 1'b0;
	else
		Q1_L2_pcs_rst_n	<= PLL_LOCKED;
end

logic	Q3_L2_pcs_rst_n;
always @(posedge Q3_L2_10gbe_clk) begin
	if(~PLL_LOCKED)
		Q3_L2_pcs_rst_n	<= 1'b0;
	else
		Q3_L2_pcs_rst_n	<= PLL_LOCKED;
end

assign Q1_L2_PMA_TX_ELEC_IDLE		= 1'b0;
assign Q1_L2_ETH_EEE_ALERT_EN		= 1'b0;

assign Q3_L2_PMA_TX_ELEC_IDLE		= 1'b0;
assign Q3_L2_ETH_EEE_ALERT_EN		= 1'b0;


//CDC
logic	apb_Q1_L2_init_done, apb_Q3_L2_init_done;
efx_resetsync inst_q1_apb_init_done (
	.clk	(Q1_APB_CLK), 	.reset	(Q1_L2_init_done),	.d_o	(apb_Q1_L2_init_done)
);

efx_resetsync inst_q3_apb_init_done (
	.clk	(Q3_APB_CLK), 	.reset	(Q3_L2_init_done),	.d_o	(apb_Q3_L2_init_done)
);


//Macros: VERIF, LOOPBACK, KR_ENABLE, AN_ENABLE
//KR Training, APB
//PCS Status signal, Pattern Generator, XGMII interface
logic				Q1_apb_rst_n, Q3_apb_rst_n;
logic [31:0]	Q1_USER_APB_PRDATA_w, Q3_USER_APB_PRDATA_w;
logic				Q1_USER_APB_PREADY_w, Q3_USER_APB_PREADY_w;
logic				Q1_L2_block_lock_w, Q3_L2_block_lock_w;
logic				Q1_L2_pat_gen_start, Q3_L2_pat_gen_start;
logic [7:0]		Q1_L2_xgmii_txc, Q3_L2_xgmii_txc;
logic [63:0]	Q1_L2_xgmii_txd, Q3_L2_xgmii_txd;
logic [7:0]		Q1_L2_xgmii_rxc, Q3_L2_xgmii_rxc;
logic [63:0]	Q1_L2_xgmii_rxd, Q3_L2_xgmii_rxd;
logic				Q1_L2_restart_kr_training_w, Q3_L2_restart_kr_training_w;

`ifdef LOOPBACK
	assign Q1_L2_PCS_RST_N_RX				= 1'b0;
	assign Q1_L2_PCS_RST_N_TX				= 1'b0;

	assign Q1_L2_KR_TRAINING_ENABLE		= 1'b0;
	assign Q1_L2_KR_RESTART_TRAINING		= 1'b0;

	assign Q1_apb_rst_n						= 1'b0;
	assign Q1_USER_APB_PREADY_w			= 1'b0;
	assign Q1_USER_APB_PRDATA_w			= 32'h0;
	localparam Q1_APB_HALT_1				= 3;
	localparam Q1_APB_HALT_2				= 3;
	assign Q1_L2_apb_halt_1					= 1'b0;
	assign Q1_L2_apb_halt_2					= 1'b0;
	assign Q1_L2_pat_gen_start				= Q1_L2_init_done;

	assign Q1_L2_block_lock_w				= 1'b1; //Checker for RX_AXI

	assign Q1_L2_TXC							= 8'h0;
	assign Q1_L2_TXD							= 64'h0;
	assign Q1_L2_xgmii_rxc					= Q1_L2_xgmii_txc;
	assign Q1_L2_xgmii_rxd					= Q1_L2_xgmii_txd;

	assign PASS_STATUS						= Q1_L2_pass_status;
`endif

`ifndef LOOPBACK
	assign Q1_L2_PCS_RST_N_RX				= Q1_L2_pcs_rst_n;
	assign Q1_L2_PCS_RST_N_TX				= Q1_L2_pcs_rst_n; 

	`ifdef KR_ENABLE
		assign Q1_L2_KR_TRAINING_ENABLE	= 1'b1;
		assign Q1_L2_KR_RESTART_TRAINING	= Q1_L2_restart_kr_training_w;
	`endif
	`ifndef KR_ENABLE
		assign Q1_L2_KR_TRAINING_ENABLE	= 1'b0;
		assign Q1_L2_KR_RESTART_TRAINING	= 1'b0;
	`endif

	assign Q1_apb_rst_n						= apb_Q1_L2_init_done;
	assign Q1_USER_APB_PREADY_w			= Q1_USER_APB_PREADY;
	assign Q1_USER_APB_PRDATA_w			= Q1_USER_APB_PRDATA;
	assign Q1_L2_apb_halt_1					= Q1_L2_BLOCK_LOCK;
	`ifndef AN_ENABLE
		localparam Q1_APB_HALT_1			= 3;
		localparam Q1_APB_HALT_2			= 3;
		assign Q1_L2_apb_halt_2				= Q1_L2_PCS_STATUS;
		assign Q1_L2_pat_gen_start			= Q1_L2_PCS_STATUS;
	`endif
	`ifdef AN_ENABLE
		localparam Q1_APB_HALT_1			= 4;
		localparam Q1_APB_HALT_2			= 5;
		assign Q1_L2_apb_halt_2				= Q1_L2_PCS_STATUS && Q1_L2_IRQ;
		assign Q1_L2_pat_gen_start			= Q1_L2_PCS_STATUS && Q1_L2_IRQ;
	`endif

	assign Q1_L2_block_lock_w				= Q1_L2_BLOCK_LOCK;

	assign Q1_L2_TXC							= Q1_L2_xgmii_txc;
	assign Q1_L2_TXD							= Q1_L2_xgmii_txd;
	assign Q1_L2_xgmii_rxc					= Q1_L2_RXC;
	assign Q1_L2_xgmii_rxd					= Q1_L2_RXD;

	assign PASS_STATUS						= Q1_L2_pass_status & Q3_L2_pass_status;
`endif


`ifndef VERIF
	assign Q1_L2_restart_kr_training_w			= Q1_L2_restart_kr_training_vio || 1'b0;
	assign Q3_L2_restart_kr_training_w			= Q3_L2_restart_kr_training_vio || 1'b0;
`endif
`ifdef VERIF
	assign Q1_L2_restart_kr_training_w			= Q1_L2_restart_kr_training_IN;
	assign Q3_L2_restart_kr_training_w			= Q3_L2_restart_kr_training_IN;

	assign Q1_ram_usr_wren_w						= in_Q1_ram_usr_wren_w;
	assign Q1_ram_usr_addr_w						= in_Q1_ram_usr_addr_w;
	assign Q1_usr_apb_start_w						= in_Q1_usr_apb_start_w;
	assign Q1_usr_apb_addr_w						= in_Q1_usr_apb_addr_w;
	assign Q1_usr_apb_write_w						= in_Q1_usr_apb_write_w;
	assign Q1_usr_apb_pwdata_w						= in_Q1_usr_apb_pwdata_w;

	assign Q3_ram_usr_wren_w						= in_Q3_ram_usr_wren_w;
	assign Q3_ram_usr_addr_w						= in_Q3_ram_usr_addr_w;
	assign Q3_usr_apb_start_w						= in_Q3_usr_apb_start_w;
	assign Q3_usr_apb_addr_w						= in_Q3_usr_apb_addr_w;
	assign Q3_usr_apb_write_w						= in_Q3_usr_apb_write_w;
	assign Q3_usr_apb_pwdata_w						= in_Q3_usr_apb_pwdata_w;

	assign Q1_L2_cnt_rst_n							= in_Q1_L2_cnt_rst_n;
	assign Q1_L2_rx_pause_ignore					= in_Q1_L2_rx_pause_ignore;
	assign Q1_L2_rx_address_filtering_mask		= in_Q1_L2_rx_address_filtering_mask;
	assign Q1_L2_tx_pause_gen						= in_Q1_L2_tx_pause_gen;
	assign Q1_L2_tx_pause_quant					= in_Q1_L2_tx_pause_quant;

	assign Q3_L2_cnt_rst_n							= in_Q3_L2_cnt_rst_n;
	assign Q3_L2_rx_pause_ignore					= in_Q3_L2_rx_pause_ignore;
	assign Q3_L2_rx_address_filtering_mask		= in_Q3_L2_rx_address_filtering_mask;
	assign Q3_L2_tx_pause_gen						= in_Q3_L2_tx_pause_gen;
	assign Q3_L2_tx_pause_quant					= in_Q3_L2_tx_pause_quant;
`endif


assign Q3_L2_PCS_RST_N_RX			= Q3_L2_pcs_rst_n;
assign Q3_L2_PCS_RST_N_TX			= Q3_L2_pcs_rst_n; 

`ifdef KR_ENABLE
	assign Q3_L2_KR_TRAINING_ENABLE	= 1'b1;
	assign Q3_L2_KR_RESTART_TRAINING	= Q3_L2_restart_kr_training_w;
`endif
`ifndef KR_ENABLE
	assign Q3_L2_KR_TRAINING_ENABLE	= 1'b0;
	assign Q3_L2_KR_RESTART_TRAINING	= 1'b0;
`endif

assign Q3_apb_rst_n					= apb_Q3_L2_init_done;
assign Q3_USER_APB_PREADY_w		= Q3_USER_APB_PREADY;
assign Q3_USER_APB_PRDATA_w		= Q3_USER_APB_PRDATA;
assign Q3_L2_apb_halt_1				= Q3_L2_BLOCK_LOCK;
`ifndef AN_ENABLE
	localparam Q3_APB_HALT_1		= 3;
	localparam Q3_APB_HALT_2		= 3;
	assign Q3_L2_apb_halt_2			= Q3_L2_PCS_STATUS;
	assign Q3_L2_pat_gen_start		= Q3_L2_PCS_STATUS;
`endif
`ifdef AN_ENABLE
	localparam Q3_APB_HALT_1		= 4;
	localparam Q3_APB_HALT_2		= 5;
	assign Q3_L2_apb_halt_2			= Q3_L2_PCS_STATUS && Q3_L2_IRQ;
	assign Q3_L2_pat_gen_start		= Q3_L2_PCS_STATUS && Q3_L2_IRQ;
`endif

assign Q3_L2_block_lock_w			= Q3_L2_BLOCK_LOCK;

assign Q3_L2_TXC						= Q3_L2_xgmii_txc;
assign Q3_L2_TXD						= Q3_L2_xgmii_txd;
assign Q3_L2_xgmii_rxc				= Q3_L2_RXC;
assign Q3_L2_xgmii_rxd				= Q3_L2_RXD;


//APB
logic [31:0]	Q1_USER_APB_PRDATA_r, Q3_USER_APB_PRDATA_r;
logic				Q1_USER_APB_PREADY_r, Q3_USER_APB_PREADY_r;

always @(posedge Q1_APB_CLK) begin
	Q1_USER_APB_PREADY_r	<= Q1_USER_APB_PREADY_w;
	Q1_USER_APB_PRDATA_r	<= Q1_USER_APB_PRDATA_w;
end

always @(posedge Q3_APB_CLK) begin
	Q3_USER_APB_PREADY_r	<= Q3_USER_APB_PREADY_w;
	Q3_USER_APB_PRDATA_r	<= Q3_USER_APB_PRDATA_w;
end

//Instances
efx_mac10gbe_exp_apb_master #(
`ifdef AN_ENABLE
	.ROM_MIF				("./efx_q1_rom_mif_an.mem"),
`endif
`ifndef AN_ENABLE
	.ROM_MIF				("./efx_q1_rom_mif.mem"),
`endif
	.ROM_DEPTH			(Q1_ROM_DEPTH),
	.RAM_ADDR_W			(Q1_RAM_ADDR_W),
	.PADDR_WIDTH		(APB_PADDR_WIDTH),
	.PDATA_WIDTH		(APB_PDATA_WIDTH)
) inst_Q1_L2_apb_master(
	.apb_halt_i			(Q1_apb_halt_w),
	.apb_rom_end_o		(Q1_apb_rom_end_w),
	.apb_done_o			(Q1_apb_done_w),

	.ram_usr_wren_i	(Q1_ram_usr_wren_w),
	.ram_usr_addr_i	(Q1_ram_usr_addr_w),
	.ram_dout_d_o		(Q1_ram_dout_d_w),
	.ram_dout_a_o		(Q1_ram_dout_a_w),

	.usr_apb_start_i	(Q1_usr_apb_start_w),
	.usr_apb_write_i	(Q1_usr_apb_write_w),
	.usr_apb_addr_i	(Q1_usr_apb_addr_w),
	.usr_apb_pwdata_i	(Q1_usr_apb_pwdata_w),

	.PSEL					(Q1_USER_APB_PSEL),
	.PWRITE				(Q1_USER_APB_PWRITE),
	.PENABLE				(Q1_USER_APB_PENABLE),
	.PADDR				(Q1_USER_APB_PADDR),
	.PWDATA				(Q1_USER_APB_PWDATA),

	.PCLK					(Q1_APB_CLK),
	.PRESETn				(Q1_apb_rst_n),
	.PRDATA				(Q1_USER_APB_PRDATA),
	.PREADY				(Q1_USER_APB_PREADY),
	.PSLVERR				(Q1_USER_APB_PSLVERR)
);

efx_mac10gbe_exp_apb_halt # (
	.CNT_HALT1	(Q1_APB_HALT_1),
	.CNT_HALT2	(Q1_APB_HALT_2)
) inst_Q1_L2_apb_halt(
	.pclk_i		(Q1_APB_CLK),
	.presetn_i	(Q1_apb_rst_n),
	.pready_i	(Q1_USER_APB_PREADY_w),
	.irq1_i		(Q1_L2_apb_halt_1),
	.irq2_i		(Q1_L2_apb_halt_2),

	.apb_halt_o	(Q1_apb_halt_w)
);

efx_mac10gbe_exp_pat_gen inst_Q1_L2_pat_gen(
	.clk									(Q1_L2_10gbe_clk),
	.rst_n								(Q1_L2_pcs_rst_n),
	.pcs_status							(Q1_L2_pat_gen_start),

	.tx_axis_mac_tready				(Q1_L2_tx_axis_mac_tready),
	.tx_axis_mac_tvalid				(Q1_L2_tx_axis_mac_tvalid),
	.tx_axis_mac_tlast				(Q1_L2_tx_axis_mac_tlast),
	.tx_axis_mac_tdata				(Q1_L2_tx_axis_mac_tdata),
	.tx_axis_mac_tkeep				(Q1_L2_tx_axis_mac_tkeep),
	.tx_axis_mac_tuser				(Q1_L2_tx_axis_mac_tuser)
);

xgmac inst_Q1_L2_mac10gbe (
	.mac_reset_n								(Q1_L2_pcs_rst_n),
	.mac10gbe_clk								(Q1_L2_10gbe_clk),

	.init_clk									(INIT_CLK),
	.init_rst_n									(IN_USER),
	.PMA_CMN_READY								(Q1_PMA_CMN_READY),
	.PMA_XCVR_PLLCLK_EN						(Q1_L2_PMA_XCVR_PLLCLK_EN),
	.PMA_XCVR_PLLCLK_EN_ACK					(Q1_L2_PMA_XCVR_PLLCLK_EN_ACK),
	.PMA_XCVR_POWER_STATE_REQ				(Q1_L2_PMA_XCVR_POWER_STATE_REQ),
	.PMA_XCVR_POWER_STATE_ACK				(Q1_L2_PMA_XCVR_POWER_STATE_ACK),
	.PMA_RX_SIGNAL_DETECT					(Q1_L2_PMA_RX_SIGNAL_DETECT),
	.phy_init_done								(Q1_L2_init_done),

	.rx_axis_mac_tdata						(Q1_L2_rx_axis_mac_tdata),
	.rx_axis_mac_tvalid						(Q1_L2_rx_axis_mac_tvalid),
	.rx_axis_mac_tlast						(Q1_L2_rx_axis_mac_tlast),
	.rx_axis_mac_tkeep						(Q1_L2_rx_axis_mac_tkeep),
	.rx_axis_mac_tuser						(Q1_L2_rx_axis_mac_tuser),

	.tx_axis_mac_tdata						(Q1_L2_tx_axis_mac_tdata),
	.tx_axis_mac_tvalid						(Q1_L2_tx_axis_mac_tvalid),
	.tx_axis_mac_tlast						(Q1_L2_tx_axis_mac_tlast),
	.tx_axis_mac_tkeep						(Q1_L2_tx_axis_mac_tkeep),
	.tx_axis_mac_tuser						(Q1_L2_tx_axis_mac_tuser),
	.tx_axis_mac_tready						(Q1_L2_tx_axis_mac_tready),

	.cnt_rst_n									(Q1_L2_cnt_rst_n),
	.rx_pause_ignore							(Q1_L2_rx_pause_ignore),
	.rx_address_filtering_mask				(Q1_L2_rx_address_filtering_mask),
	.tx_pause_gen								(Q1_L2_tx_pause_gen),
	.tx_pause_quant							(Q1_L2_tx_pause_quant),
	.tx_pause_busy								(Q1_L2_tx_pause_busy),
	
	.cnt_tx_frame_transmitted_good		(Q1_L2_cnt_tx_frame_transmitted_good),
	.cnt_tx_frame_pause_mac_ctrl			(Q1_L2_cnt_tx_frame_pause_mac_ctrl),
	.cnt_tx_frame_error_txfifo_overflow	(Q1_L2_cnt_tx_frame_error_txfifo_overflow),
	.cnt_tx_frame_is_fe						(Q1_L2_cnt_tx_frame_is_fe),
	.cnt_rx_frame_received_good			(Q1_L2_cnt_rx_frame_received_good),
	.rpt_rx_frame_length						(Q1_L2_rpt_rx_frame_length),
	.cnt_rx_frame_error_fcs					(Q1_L2_cnt_rx_frame_error_fcs),
	.cnt_rx_frame_pause_mac_ctrl			(Q1_L2_cnt_rx_frame_pause_mac_ctrl),
	.cnt_rx_frame_errors						(Q1_L2_cnt_rx_frame_errors),
	.cnt_rx_frame_received_total			(Q1_L2_cnt_rx_frame_received_total),
	.cnt_rx_frame_undersized				(Q1_L2_cnt_rx_frame_undersized),
	.cnt_rx_frame_oversized					(Q1_L2_cnt_rx_frame_oversized),
	.cnt_rx_frame_mismatched_length		(Q1_L2_cnt_rx_frame_mismatched_length),
	.cnt_rx_frame_filtered_by_address	(Q1_L2_cnt_rx_frame_filtered_by_address),

	.XGMII_RXD									(Q1_L2_xgmii_rxd),
	.XGMII_RXC									(Q1_L2_xgmii_rxc),
	.XGMII_TXD									(Q1_L2_xgmii_txd),
	.XGMII_TXC									(Q1_L2_xgmii_txc)
);

efx_mac10gbe_exp_checker #(
	.CNT_ROLLOVER				('d15)
) inst_Q1_L2_checker(
	.apb_clk						(Q1_APB_CLK),
	.mac_clk						(Q1_L2_10gbe_clk),

	.init_done					(Q1_L2_init_done),
	.block_lock					(Q1_L2_block_lock_w),
	.pass_status				(Q1_L2_pass_status),

	.xgmii_rxd_i				(Q1_L2_xgmii_rxd),
	.xgmii_rxc_i				(Q1_L2_xgmii_rxc),
	.rx_axis_tvalid_i			(Q1_L2_rx_axis_mac_tvalid),
	.rx_axis_tlast_i			(Q1_L2_rx_axis_mac_tlast),
	.rx_axis_tuser_i			(Q1_L2_rx_axis_mac_tuser),

	.rx_tuser_pass				(Q1_L2_rx_tuser_pass),
	.rx_fe_pkt_pass			(Q1_L2_fe_pkt_pass),

	.kr_restart_i				(Q1_L2_KR_RESTART_TRAINING),
	.kr_local_trained_i		(Q1_L2_KR_LOCAL_RX_TRAINED),
	.kr_training_failure_i	(Q1_L2_KR_TRAINING_FAILURE),
	.kr_training_pass			(Q1_L2_kr_training_pass),

	.apb_prdata					(Q1_USER_APB_PRDATA_r),
	.apb_paddr					(Q1_USER_APB_PADDR),
	.apb_pready					(Q1_USER_APB_PREADY_r),
	.apb_rom_end				(Q1_apb_rom_end_w),
	.pcs_fault_pass			(Q1_L2_pcs_fault_pass),
	.auto_nego_pass			(Q1_L2_auto_nego_pass),

	.phy_interrupt_i			(Q1_L2_PHY_INTERRUPT),
	.phy_interrupt_pass		(Q1_L2_phy_interrupt_pass)
);

efx_mac10gbe_exp_apb_master #(
`ifdef AN_ENABLE
	.ROM_MIF				("./efx_q3_rom_mif_an.mem"),
`endif
`ifndef AN_ENABLE
	.ROM_MIF				("./efx_q3_rom_mif.mem"),
`endif
	.ROM_DEPTH			(Q3_ROM_DEPTH),
	.RAM_ADDR_W			(Q3_RAM_ADDR_W),
	.PADDR_WIDTH		(APB_PADDR_WIDTH),
	.PDATA_WIDTH		(APB_PDATA_WIDTH)
) inst_Q3_L2_apb_master(
	.apb_halt_i			(Q3_apb_halt_w),
	.apb_rom_end_o		(Q3_apb_rom_end_w),
	.apb_done_o			(Q3_apb_done_w),

	.ram_usr_wren_i	(Q3_ram_usr_wren_w),
	.ram_usr_addr_i	(Q3_ram_usr_addr_w),
	.ram_dout_d_o		(Q3_ram_dout_d_w),
	.ram_dout_a_o		(Q3_ram_dout_a_w),

	.usr_apb_start_i	(Q3_usr_apb_start_w),
	.usr_apb_write_i	(Q3_usr_apb_write_w),
	.usr_apb_addr_i	(Q3_usr_apb_addr_w),
	.usr_apb_pwdata_i	(Q3_usr_apb_pwdata_w),

	.PSEL					(Q3_USER_APB_PSEL),
	.PWRITE				(Q3_USER_APB_PWRITE),
	.PENABLE				(Q3_USER_APB_PENABLE),
	.PADDR				(Q3_USER_APB_PADDR),
	.PWDATA				(Q3_USER_APB_PWDATA),

	.PCLK					(Q3_APB_CLK),
	.PRESETn				(Q3_apb_rst_n),
	.PRDATA				(Q3_USER_APB_PRDATA),
	.PREADY				(Q3_USER_APB_PREADY),
	.PSLVERR				(Q3_USER_APB_PSLVERR)
);

efx_mac10gbe_exp_apb_halt # (
	.CNT_HALT1	(Q3_APB_HALT_1),
	.CNT_HALT2	(Q3_APB_HALT_2)
) inst_Q3_L2_apb_halt(
	.pclk_i		(Q3_APB_CLK),
	.presetn_i	(Q3_apb_rst_n),
	.pready_i	(Q3_USER_APB_PREADY_w),
	.irq1_i		(Q3_L2_apb_halt_1),
	.irq2_i		(Q3_L2_apb_halt_2),

	.apb_halt_o	(Q3_apb_halt_w)
);

efx_mac10gbe_exp_pat_gen inst_Q3_L2_pat_gen(
	.clk									(Q3_L2_10gbe_clk),
	.rst_n								(Q3_L2_pcs_rst_n),
	.pcs_status							(Q3_L2_pat_gen_start),

	.tx_axis_mac_tready				(Q3_L2_tx_axis_mac_tready),
	.tx_axis_mac_tvalid				(Q3_L2_tx_axis_mac_tvalid),
	.tx_axis_mac_tlast				(Q3_L2_tx_axis_mac_tlast),
	.tx_axis_mac_tdata				(Q3_L2_tx_axis_mac_tdata),
	.tx_axis_mac_tkeep				(Q3_L2_tx_axis_mac_tkeep),
	.tx_axis_mac_tuser				(Q3_L2_tx_axis_mac_tuser)
);

xgmac inst_Q3_L2_mac10gbe (
	.mac_reset_n								(Q3_L2_pcs_rst_n),
	.mac10gbe_clk								(Q3_L2_10gbe_clk),

	.init_clk									(INIT_CLK),
	.init_rst_n									(IN_USER),
	.PMA_CMN_READY								(Q3_PMA_CMN_READY),
	.PMA_XCVR_PLLCLK_EN						(Q3_L2_PMA_XCVR_PLLCLK_EN),
	.PMA_XCVR_PLLCLK_EN_ACK					(Q3_L2_PMA_XCVR_PLLCLK_EN_ACK),
	.PMA_XCVR_POWER_STATE_REQ				(Q3_L2_PMA_XCVR_POWER_STATE_REQ),
	.PMA_XCVR_POWER_STATE_ACK				(Q3_L2_PMA_XCVR_POWER_STATE_ACK),
	.PMA_RX_SIGNAL_DETECT					(Q3_L2_PMA_RX_SIGNAL_DETECT),
	.phy_init_done								(Q3_L2_init_done),

	.rx_axis_mac_tdata						(Q3_L2_rx_axis_mac_tdata),
	.rx_axis_mac_tvalid						(Q3_L2_rx_axis_mac_tvalid),
	.rx_axis_mac_tlast						(Q3_L2_rx_axis_mac_tlast),
	.rx_axis_mac_tkeep						(Q3_L2_rx_axis_mac_tkeep),
	.rx_axis_mac_tuser						(Q3_L2_rx_axis_mac_tuser),

	.tx_axis_mac_tdata						(Q3_L2_tx_axis_mac_tdata),
	.tx_axis_mac_tvalid						(Q3_L2_tx_axis_mac_tvalid),
	.tx_axis_mac_tlast						(Q3_L2_tx_axis_mac_tlast),
	.tx_axis_mac_tkeep						(Q3_L2_tx_axis_mac_tkeep),
	.tx_axis_mac_tuser						(Q3_L2_tx_axis_mac_tuser),
	.tx_axis_mac_tready						(Q3_L2_tx_axis_mac_tready),

	.cnt_rst_n									(Q3_L2_cnt_rst_n),
	.rx_pause_ignore							(Q3_L2_rx_pause_ignore),
	.rx_address_filtering_mask				(Q3_L2_rx_address_filtering_mask),
	.tx_pause_gen								(Q3_L2_tx_pause_gen),
	.tx_pause_quant							(Q3_L2_tx_pause_quant),
	.tx_pause_busy								(Q3_L2_tx_pause_busy),
	
	.cnt_tx_frame_transmitted_good		(Q3_L2_cnt_tx_frame_transmitted_good),
	.cnt_tx_frame_pause_mac_ctrl			(Q3_L2_cnt_tx_frame_pause_mac_ctrl),
	.cnt_tx_frame_error_txfifo_overflow	(Q3_L2_cnt_tx_frame_error_txfifo_overflow),
	.cnt_tx_frame_is_fe						(Q3_L2_cnt_tx_frame_is_fe),
	.cnt_rx_frame_received_good			(Q3_L2_cnt_rx_frame_received_good),
	.rpt_rx_frame_length						(Q3_L2_rpt_rx_frame_length),
	.cnt_rx_frame_error_fcs					(Q3_L2_cnt_rx_frame_error_fcs),
	.cnt_rx_frame_pause_mac_ctrl			(Q3_L2_cnt_rx_frame_pause_mac_ctrl),
	.cnt_rx_frame_errors						(Q3_L2_cnt_rx_frame_errors),
	.cnt_rx_frame_received_total			(Q3_L2_cnt_rx_frame_received_total),
	.cnt_rx_frame_undersized				(Q3_L2_cnt_rx_frame_undersized),
	.cnt_rx_frame_oversized					(Q3_L2_cnt_rx_frame_oversized),
	.cnt_rx_frame_mismatched_length		(Q3_L2_cnt_rx_frame_mismatched_length),
	.cnt_rx_frame_filtered_by_address	(Q3_L2_cnt_rx_frame_filtered_by_address),

	.XGMII_RXD									(Q3_L2_xgmii_rxd),
	.XGMII_RXC									(Q3_L2_xgmii_rxc),
	.XGMII_TXD									(Q3_L2_xgmii_txd),
	.XGMII_TXC									(Q3_L2_xgmii_txc)
);

efx_mac10gbe_exp_checker #(
	.CNT_ROLLOVER				('d15)
) inst_Q3_L2_checker(
	.apb_clk						(Q3_APB_CLK),
	.mac_clk						(Q3_L2_10gbe_clk),

	.init_done					(Q3_L2_init_done),
	.block_lock					(Q3_L2_block_lock_w),
	.pass_status				(Q3_L2_pass_status),

	.xgmii_rxd_i				(Q3_L2_xgmii_rxd),
	.xgmii_rxc_i				(Q3_L2_xgmii_rxc),
	.rx_axis_tvalid_i			(Q3_L2_rx_axis_mac_tvalid),
	.rx_axis_tlast_i			(Q3_L2_rx_axis_mac_tlast),
	.rx_axis_tuser_i			(Q3_L2_rx_axis_mac_tuser),

	.rx_tuser_pass				(Q3_L2_rx_tuser_pass),
	.rx_fe_pkt_pass			(Q3_L2_fe_pkt_pass),

	.kr_restart_i				(Q3_L2_KR_RESTART_TRAINING),
	.kr_local_trained_i		(Q3_L2_KR_LOCAL_RX_TRAINED),
	.kr_training_failure_i	(Q3_L2_KR_TRAINING_FAILURE),
	.kr_training_pass			(Q3_L2_kr_training_pass),

	.apb_prdata					(Q3_USER_APB_PRDATA_r),
	.apb_paddr					(Q3_USER_APB_PADDR),
	.apb_pready					(Q3_USER_APB_PREADY_r),
	.apb_rom_end				(Q3_apb_rom_end_w),
	.pcs_fault_pass			(Q3_L2_pcs_fault_pass),
	.auto_nego_pass			(Q3_L2_auto_nego_pass),

	.phy_interrupt_i			(Q3_L2_PHY_INTERRUPT),
	.phy_interrupt_pass		(Q3_L2_phy_interrupt_pass)
);

`ifndef VERIF
	edb_top edb_top_inst(
		.bscan_CAPTURE												(jtag_vio_CAPTURE),
		.bscan_DRCK													(jtag_vio_DRCK),
		.bscan_RESET												(jtag_vio_RESET),
		.bscan_RUNTEST												(jtag_vio_RUNTEST),
		.bscan_SEL													(jtag_vio_SEL),
		.bscan_SHIFT												(jtag_vio_SHIFT),
		.bscan_TCK													(jtag_vio_TCK),
		.bscan_TDI													(jtag_vio_TDI),
		.bscan_TMS													(jtag_vio_TMS),
		.bscan_UPDATE												(jtag_vio_UPDATE),
		.bscan_TDO													(jtag_vio_TDO),

		.vio0_clk													(DEBUG_CLK),

		.vio0_q1_cmn_ready										(Q1_PMA_CMN_READY),
		.vio0_q3_cmn_ready										(Q3_PMA_CMN_READY),

		.vio0_q1_l2_kr_training									(Q1_L2_KR_TRAINING),
		.vio0_q1_l2_kr_frame_lock								(Q1_L2_KR_FRAME_LOCK),
		.vio0_q1_l2_kr_local_rx_trained						(Q1_L2_KR_LOCAL_RX_TRAINED),
		.vio0_q1_l2_kr_signal_detect							(Q1_L2_KR_SIGNAL_DETECT),
		.vio0_q1_l2_kr_training_failure						(Q1_L2_KR_TRAINING_FAILURE),

		.vio0_q3_l2_kr_training									(Q3_L2_KR_TRAINING),
		.vio0_q3_l2_kr_frame_lock								(Q3_L2_KR_FRAME_LOCK),
		.vio0_q3_l2_kr_local_rx_trained						(Q3_L2_KR_LOCAL_RX_TRAINED),
		.vio0_q3_l2_kr_signal_detect							(Q3_L2_KR_SIGNAL_DETECT),
		.vio0_q3_l2_kr_training_failure						(Q3_L2_KR_TRAINING_FAILURE),

		.vio0_q1_l2_block_lock									(Q1_L2_BLOCK_LOCK),
		.vio0_q1_l2_hi_ber										(Q1_L2_HI_BER),
		.vio0_q1_l2_irq											(Q1_L2_IRQ),
		.vio0_q1_l2_pcs_status									(Q1_L2_PCS_STATUS),
		.vio0_q1_l2_phy_interrupt								(Q1_L2_PHY_INTERRUPT),

		.vio0_q3_l2_block_lock									(Q3_L2_BLOCK_LOCK),
		.vio0_q3_l2_hi_ber										(Q3_L2_HI_BER),
		.vio0_q3_l2_irq											(Q3_L2_IRQ),
		.vio0_q3_l2_pcs_status									(Q3_L2_PCS_STATUS),
		.vio0_q3_l2_phy_interrupt								(Q3_L2_PHY_INTERRUPT),

		.vio0_q1_l2_init_done									(Q1_L2_init_done),
		.vio0_q3_l2_init_done									(Q3_L2_init_done),

		.vio0_pll_locked											(PLL_LOCKED),
		.vio0_q1_l2_rx_signal_detect							(Q1_L2_PMA_RX_SIGNAL_DETECT),
		.vio0_q3_l2_rx_signal_detect							(Q3_L2_PMA_RX_SIGNAL_DETECT),

		.vio0_q1_ram_dout_d										(Q1_ram_dout_d_w),
		.vio0_q1_ram_dout_a										(Q1_ram_dout_a_w),
		.vio0_q3_ram_dout_d										(Q3_ram_dout_d_w),
		.vio0_q3_ram_dout_a										(Q3_ram_dout_a_w),

		.vio0_q1_apb_rom_end										(Q1_apb_rom_end_w),
		.vio0_q3_apb_rom_end										(Q3_apb_rom_end_w),
		
		.vio0_q1_l2_cnt_tx_frame_transmitted_good			(Q1_L2_cnt_tx_frame_transmitted_good),
		.vio0_q1_l2_cnt_tx_frame_pause_mac_ctrl			(Q1_L2_cnt_tx_frame_pause_mac_ctrl),
		.vio0_q1_l2_cnt_tx_frame_error_txfifo_overflow	(Q1_L2_cnt_tx_frame_error_txfifo_overflow),
		.vio0_q1_l2_cnt_tx_frame_is_fe						(Q1_L2_cnt_tx_frame_is_fe),
		.vio0_q1_l2_cnt_rx_frame_received_good				(Q1_L2_cnt_rx_frame_received_good),
		.vio0_q1_l2_rpt_rx_frame_length						(Q1_L2_rpt_rx_frame_length),
		.vio0_q1_l2_cnt_rx_frame_error_fcs					(Q1_L2_cnt_rx_frame_error_fcs),
		.vio0_q1_l2_cnt_rx_frame_pause_mac_ctrl			(Q1_L2_cnt_rx_frame_pause_mac_ctrl),
		.vio0_q1_l2_cnt_rx_frame_errors						(Q1_L2_cnt_rx_frame_errors),
		.vio0_q1_l2_cnt_rx_frame_received_total			(Q1_L2_cnt_rx_frame_received_total),
		.vio0_q1_l2_cnt_rx_frame_undersized					(Q1_L2_cnt_rx_frame_undersized),
		.vio0_q1_l2_cnt_rx_frame_oversized					(Q1_L2_cnt_rx_frame_oversized),
		.vio0_q1_l2_cnt_rx_frame_mismatched_length		(Q1_L2_cnt_rx_frame_mismatched_length),
		.vio0_q1_l2_cnt_rx_frame_filtered_by_address		(Q1_L2_cnt_rx_frame_filtered_by_address),
		
		.vio0_q3_l2_cnt_tx_frame_transmitted_good			(Q3_L2_cnt_tx_frame_transmitted_good),
		.vio0_q3_l2_cnt_tx_frame_pause_mac_ctrl			(Q3_L2_cnt_tx_frame_pause_mac_ctrl),
		.vio0_q3_l2_cnt_tx_frame_error_txfifo_overflow	(Q3_L2_cnt_tx_frame_error_txfifo_overflow),
		.vio0_q3_l2_cnt_tx_frame_is_fe						(Q3_L2_cnt_tx_frame_is_fe),
		.vio0_q3_l2_cnt_rx_frame_received_good				(Q3_L2_cnt_rx_frame_received_good),
		.vio0_q3_l2_rpt_rx_frame_length						(Q3_L2_rpt_rx_frame_length),
		.vio0_q3_l2_cnt_rx_frame_error_fcs					(Q3_L2_cnt_rx_frame_error_fcs),
		.vio0_q3_l2_cnt_rx_frame_pause_mac_ctrl			(Q3_L2_cnt_rx_frame_pause_mac_ctrl),
		.vio0_q3_l2_cnt_rx_frame_errors						(Q3_L2_cnt_rx_frame_errors),
		.vio0_q3_l2_cnt_rx_frame_received_total			(Q3_L2_cnt_rx_frame_received_total),
		.vio0_q3_l2_cnt_rx_frame_undersized					(Q3_L2_cnt_rx_frame_undersized),
		.vio0_q3_l2_cnt_rx_frame_oversized					(Q3_L2_cnt_rx_frame_oversized),
		.vio0_q3_l2_cnt_rx_frame_mismatched_length		(Q3_L2_cnt_rx_frame_mismatched_length),
		.vio0_q3_l2_cnt_rx_frame_filtered_by_address		(Q3_L2_cnt_rx_frame_filtered_by_address),
		
		.vio0_q1_l2_tx_pause_busy								(Q1_L2_tx_pause_busy),
		.vio0_q3_l2_tx_pause_busy								(Q3_L2_tx_pause_busy),

		.vio0_q1_l2_restart_kr_training_IN					(Q1_L2_restart_kr_training_vio),
		.vio0_q3_l2_restart_kr_training_IN					(Q3_L2_restart_kr_training_vio),

		.vio0_q1_ram_usr_wren									(Q1_ram_usr_wren_w),
		.vio0_q1_ram_usr_addr									(Q1_ram_usr_addr_w),
		.vio0_q3_ram_usr_wren									(Q3_ram_usr_wren_w),
		.vio0_q3_ram_usr_addr									(Q3_ram_usr_addr_w),

		.vio0_q1_usr_apb_start									(Q1_usr_apb_start_w),
		.vio0_q1_usr_apb_write									(Q1_usr_apb_write_w),
		.vio0_q1_usr_apb_addr									(Q1_usr_apb_addr_w),
		.vio0_q1_usr_apb_pwdata									(Q1_usr_apb_pwdata_w),

		.vio0_q3_usr_apb_start									(Q3_usr_apb_start_w),
		.vio0_q3_usr_apb_write									(Q3_usr_apb_write_w),
		.vio0_q3_usr_apb_addr									(Q3_usr_apb_addr_w),
		.vio0_q3_usr_apb_pwdata									(Q3_usr_apb_pwdata_w),
		
		.vio0_q1_l2_cnt_rst_n									(Q1_L2_cnt_rst_n),
		.vio0_q1_l2_rx_pause_ignore							(Q1_L2_rx_pause_ignore),
		.vio0_q1_l2_rx_address_filtering_mask				(Q1_L2_rx_address_filtering_mask),
		.vio0_q1_l2_tx_pause_gen								(Q1_L2_tx_pause_gen),
		.vio0_q1_l2_tx_pause_quant								(Q1_L2_tx_pause_quant),
		
		.vio0_q3_l2_cnt_rst_n									(Q3_L2_cnt_rst_n),
		.vio0_q3_l2_rx_pause_ignore							(Q3_L2_rx_pause_ignore),
		.vio0_q3_l2_rx_address_filtering_mask				(Q3_L2_rx_address_filtering_mask),
		.vio0_q3_l2_tx_pause_gen								(Q3_L2_tx_pause_gen),
		.vio0_q3_l2_tx_pause_quant								(Q3_L2_tx_pause_quant),
		
		.vio0_PASS_STATUS											(PASS_STATUS),
		
		.vio1_clk													(DEBUG_CLK),

		.vio1_Q1_L2_rx_tuser_pass								(Q1_L2_rx_tuser_pass),
		.vio1_Q1_L2_fe_pkt_pass									(Q1_L2_fe_pkt_pass),
		.vio1_Q1_L2_kr_training_pass							(Q1_L2_kr_training_pass),
		.vio1_Q1_L2_pcs_fault_pass								(Q1_L2_pcs_fault_pass),
		.vio1_Q1_L2_phy_interrupt_pass						(Q1_L2_phy_interrupt_pass),
		.vio1_Q1_L2_auto_nego_pass								(Q1_L2_auto_nego_pass),
		
		.vio1_Q3_L2_rx_tuser_pass								(Q3_L2_rx_tuser_pass),
		.vio1_Q3_L2_fe_pkt_pass									(Q3_L2_fe_pkt_pass),
		.vio1_Q3_L2_kr_training_pass							(Q3_L2_kr_training_pass),
		.vio1_Q3_L2_pcs_fault_pass								(Q3_L2_pcs_fault_pass),
		.vio1_Q3_L2_phy_interrupt_pass						(Q3_L2_phy_interrupt_pass),
		.vio1_Q3_L2_auto_nego_pass								(Q3_L2_auto_nego_pass)

	);
`endif


endmodule
