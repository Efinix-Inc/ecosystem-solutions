
`timescale 1 ns / 1 ns

module eth_platform#(
    parameter                       AXIS_DW =64
)
(

input                           clk_100m ,        //100m
input                           clk100m_rstn ,    
input                           clk_250m ,        //250m
input                           clk250m_rstn ,        //250m
input                           Q1_L2_10gbe_clk,  //156.25m
input                           clk156m_rstn,   

//XGMAC PHY XGMII Interface
//Debug Signals
input                           Q1_PMA_CMN_READY,
//Q1 APB3 interface
input            [31:0]         Q1_USER_APB_PRDATA,
input                           Q1_USER_APB_PREADY,
output           [23:0]         Q1_USER_APB_PADDR,
output           [31:0]         Q1_USER_APB_PWDATA,
output                          Q1_USER_APB_PWRITE,
output                          Q1_USER_APB_PSEL,
output                          Q1_USER_APB_PENABLE,
//Q1 clk rerset interface
output                          Q1_L2_PCS_RST_N_RX,
output                          Q1_L2_PCS_RST_N_TX,
output                          Q1_L2_PHY_RESET_N,
//Q1 control interface
output                          Q1_L2_ETH_EEE_ALERT_EN,
output                          Q1_L2_PMA_TX_ELEC_IDLE,

//Q1 power up interface
input           [3:0]           Q1_L2_PMA_XCVR_POWER_STATE_ACK,
input                           Q1_L2_PMA_XCVR_PLLCLK_EN_ACK,
input                           Q1_L2_PMA_RX_SIGNAL_DETECT,
output          [3:0]           Q1_L2_PMA_XCVR_POWER_STATE_REQ,
output                          Q1_L2_PMA_XCVR_PLLCLK_EN,
//Q1 xgmii interface
input           [7:0]           Q1_L2_RXC,
input           [63:0]          Q1_L2_RXD,
output  wire    [63:0]          Q1_L2_TXD,
output  wire    [7:0]           Q1_L2_TXC,

input   wire    [AXIS_DW-1:0]   l2_tx_axis_mac_tdata,
input   wire                    l2_tx_axis_mac_tvalid,
input   wire                    l2_tx_axis_mac_tlast,
input   wire    [AXIS_DW/8-1:0] l2_tx_axis_mac_tkeep,
input   wire                    l2_tx_axis_mac_tuser,
output  wire                    l2_tx_axis_mac_tready,
output  wire    [AXIS_DW-1:0]   l2_rx_axis_mac_tdata,
output  wire                    l2_rx_axis_mac_tvalid,
output  wire                    l2_rx_axis_mac_tlast,
output  wire    [AXIS_DW/8-1:0] l2_rx_axis_mac_tkeep,
output  wire                    l2_rx_axis_mac_tuser,
input   wire                    l2_rx_axis_mac_tready,
//APB3 Slave Interface
input   wire    [9:0]           mac_l2_apb3_paddr,
input   wire                    mac_l2_apb3_psel,
input   wire                    mac_l2_apb3_penable,
output  wire                    mac_l2_apb3_pready,
input   wire                    mac_l2_apb3_pwrite,//0:rd; 1:wr;
input   wire    [31:0]          mac_l2_apb3_pwdata,
output  wire    [31:0]          mac_l2_apb3_prdata,
output  wire                    mac_l2_apb3_pslverror,    
// others
output          [3:0]           SFP_TXDISABLE

);
// Parameter Define 


// Register Define

// Wire Define
//-- Reset
wire                            sys_clk;
//wire                            clk50m_rstn;
//wire                            clk156m_rstn;
//--System Registers
wire                            sys_rst_n;
wire                            proto_reset;
//--AXI4-Stream Interface

//wire    [AXIS_DW-1:0]           l2_tx_axis_mac_tdata;
//wire                            l2_tx_axis_mac_tvalid;
//wire                            l2_tx_axis_mac_tlast;
//wire    [AXIS_DW/8-1:0]         l2_tx_axis_mac_tkeep;
//wire                            l2_tx_axis_mac_tuser;
//wire                            l2_tx_axis_mac_tready;
//wire    [AXIS_DW-1:0]           l2_rx_axis_mac_tdata;
//wire                            l2_rx_axis_mac_tvalid;
//wire                            l2_rx_axis_mac_tlast;
//wire    [AXIS_DW/8-1:0]         l2_rx_axis_mac_tkeep;
//wire                            l2_rx_axis_mac_tuser;
//wire                            l2_rx_axis_mac_tready;

//Mac APB3 Interface
wire    [9:0]                   mac_l2_apb3_paddr;
wire                            mac_l2_apb3_psel;
wire                            mac_l2_apb3_penable;
wire                            mac_l2_apb3_pready;
wire                            mac_l2_apb3_pwrite;
wire    [31:0]                  mac_l2_apb3_pwdata;
wire    [31:0]                  mac_l2_apb3_prdata;
wire                            mac_l2_apb3_pslverror;

//TSE DDIO
wire                            rx_axis_tuser;
wire    [23:0]                  APB_PADDR;
wire                            L2_init_done;
wire                            pat_gen_en_vio;
wire    [15:0]                  pat_gen_num_vio;
wire    [15:0]                  pat_udp_dlen_vio;
wire    [15:0]                  pat_gen_ipg_vio;

/*----------------------------------------------------------------------------------*\
                                 The main code
\*----------------------------------------------------------------------------------*/

/*----------------------- Clock Region -----------------------*/

assign sys_clk = clk_250m;
assign clk_156m_25 = Q1_L2_10gbe_clk;

/*----------------------- Reset Region -----------------------*/

assign proto_reset = 1'b0;

/*----------------------- xgmac Region -----------------------*/
assign SFP_TXDISABLE = 4'b0;
assign Q1_L2_PCS_RST_N_RX = 1'b1;
assign Q1_L2_PCS_RST_N_TX = 1'b1;
/*----------------------- SFP+ Region -----------------------*/

phy_10ge_init_seq #(
	.KR_TRAINING(0) //1 - ON, 0 - OFF
) q1_L2_phy_10ge_init_seq(
	.clk										(clk_100m                               ),
	.in_user									(clk100m_rstn                           ),
	.qX_pma_cmn_ready						    (Q1_PMA_CMN_READY                       ),
	.qX_pma_xcvr_pllclk_en_ack_p_N	            (Q1_L2_PMA_XCVR_PLLCLK_EN_ACK           ),
	.qX_pma_xcvr_power_state_ack_p_N	        (Q1_L2_PMA_XCVR_POWER_STATE_ACK         ),
	.qX_pma_rx_signal_detect_ln_N		        (Q1_L2_PMA_RX_SIGNAL_DETECT             ),
//	.qX_chN_10g_user_apb_reset_n		        (Q1_APB_RESET_N                         ),
	.qX_phy_p0N_reset_n					        (Q1_L2_PHY_RESET_N                      ),
	.qX_pma_xcvr_pllclk_en_p_N			        (Q1_L2_PMA_XCVR_PLLCLK_EN               ),
	.qX_pma_xcvr_power_state_req_p_N	        (Q1_L2_PMA_XCVR_POWER_STATE_REQ         ),
	.qX_pma_tx_elec_idle_ln_N			        (Q1_L2_PMA_TX_ELEC_IDLE                 ),
	.qX_eth_eee_alert_en_ln_N			        (Q1_L2_ETH_EEE_ALERT_EN                 ),
	.qX_kr_restart_training_ln_N		        (Q1_L2_KR_RESTART_TRAINING              ),
	.qX_kr_training_enable_ln_N		            (Q1_L2_KR_TRAINING_ENABLE               ),
	.init_done								    (L2_init_done                           )
);

//assign init_done = Q1_L3_init_done | Q1_L2_init_done |Q1_L1_init_done | Q1_L0_init_done;
//assign tx_axis_mac_tuser = 1'b0;
/*----------------------- APB INITIAL Module ----------------------------*/
//APB

localparam RAM_ADDR_W	    = 3;
localparam ROM_DEPTH		= 5;
localparam PADDR_WIDTH		= 20;
localparam PDATA_WIDTH		= 32;
//wire apb_halt_vio;
wire                            apb_rom_end_vio;
wire                            apb_done_vio;

wire							ram_usr_wren_vio;
wire [RAM_ADDR_W -1:0]	        ram_usr_addr_vio; //RAM_ADDR_W
wire [PADDR_WIDTH-1:0]	        ram_dout_a_vio;
wire [PDATA_WIDTH-1:0]	        ram_dout_d_vio;

wire							usr_apb_start_vio;
wire							usr_apb_write_vio;
wire [PADDR_WIDTH-1:0]	        usr_apb_addr_vio;
wire [PDATA_WIDTH-1:0]	        usr_apb_pwdata_vio;

apb_master #(
	.ROM_MIF				            ("efx_rom_mif.mem"                  ),
	.ROM_DEPTH			                (ROM_DEPTH                          ),
	.RAM_ADDR_W			                (RAM_ADDR_W                         ),
	.PADDR_WIDTH		                (PADDR_WIDTH                        ),
	.PDATA_WIDTH		                (PDATA_WIDTH                        )
) q1_apb_master(    
	.apb_halt_i			                (0                                  ),
	.apb_rom_end_o		                (apb_rom_end_vio                    ),
	.apb_done_o			                (apb_done_vio                       ),
    
	.ram_usr_wren_i	                    (ram_usr_wren_vio                   ),
	.ram_usr_addr_i	                    (ram_usr_addr_vio                   ),
	.ram_dout_d_o	                    (ram_dout_d_vio                     ),
	.ram_dout_a_o	                    (ram_dout_a_vio                     ),
    
	.usr_apb_start_i	                (usr_apb_start_vio                  ),
	.usr_apb_write_i	                (usr_apb_write_vio                  ),
	.usr_apb_addr_i	                    (usr_apb_addr_vio                   ),
	.usr_apb_pwdata_i	                (usr_apb_pwdata_vio                 ),
    
	.PSEL					            (Q1_USER_APB_PSEL                   ),
	.PWRITE				                (Q1_USER_APB_PWRITE                 ),
	.PENABLE				            (Q1_USER_APB_PENABLE                ),
	.PADDR				                (APB_PADDR                          ),
	.PWDATA				                (Q1_USER_APB_PWDATA                 ),
	.PCLK					            (clk_100m                           ),
	.PRESETn				            (L2_init_done                       ),
	.PRDATA				                (Q1_USER_APB_PRDATA                 ),
	.PREADY				                (Q1_USER_APB_PREADY                 ),
	.PSLVERR				            (0                                  )
);  


/*----------------------- MCU Module ----------------------------*/

assign Q1_USER_APB_PADDR = {3'b110,10'b0,APB_PADDR[10:0]};

/*----------------------- UDP Tx Module ----------------------------*/

/*----------------------- xgmac Region -----------------------*/

xgmac                                  u_l2_xgmac
(
//Globle Signals
    .mac_reset                          (!clk156m_rstn                      ),
    .proto_reset                        (proto_reset                        ),
    .tx_mac_aclk                        (clk_156m_25                        ),
//Receive AXI4-Stream Interface 
    .rx_axis_clk                        (sys_clk                            ),
    .rx_axis_mac_tdata                  (l2_rx_axis_mac_tdata               ),
    .rx_axis_mac_tvalid                 (l2_rx_axis_mac_tvalid              ),
    .rx_axis_mac_tlast                  (l2_rx_axis_mac_tlast               ),
    .rx_axis_mac_tkeep                  (l2_rx_axis_mac_tkeep               ),
    .rx_axis_mac_tuser                  (l2_rx_axis_mac_tuser               ),
    .rx_axis_mac_tready                 (l2_rx_axis_mac_tready              ),
//Transmit AXI4-Stream Interface
    .tx_axis_clk                        (sys_clk                            ),
    .tx_axis_mac_tdata                  (l2_tx_axis_mac_tdata               ),
    .tx_axis_mac_tvalid                 (l2_tx_axis_mac_tvalid              ),
    .tx_axis_mac_tlast                  (l2_tx_axis_mac_tlast               ),
    .tx_axis_mac_tkeep                  (l2_tx_axis_mac_tkeep               ),
    .tx_axis_mac_tuser                  (l2_tx_axis_mac_tuser               ),
    .tx_axis_mac_tready                 (l2_tx_axis_mac_tready              ),
//APB3 Slave Interface  
    .s_apb3_clk                         (clk_250m                           ),
    .s_apb3_paddr                       (mac_l2_apb3_paddr                  ),
    .s_apb3_psel                        (mac_l2_apb3_psel                   ),
    .s_apb3_penable                     (mac_l2_apb3_penable                ),
    .s_apb3_pready                      (mac_l2_apb3_pready                 ),
    .s_apb3_pwrite                      (mac_l2_apb3_pwrite                 ),
    .s_apb3_pwdata                      (mac_l2_apb3_pwdata                 ),
    .s_apb3_prdata                      (mac_l2_apb3_prdata                 ),
    .s_apb3_pslverror                   (mac_l2_apb3_pslverror              ),

//XGMII Interface                                                           
    .xgmii_txd                          (Q1_L2_TXD                          ),
    .xgmii_txc                          (Q1_L2_TXC                          ),
    .xgmii_rxd                          (Q1_L2_RXD                          ),
    .xgmii_rx_clk                       (Q1_L2_10gbe_clk                    ),
    .xgmii_rxc                          (Q1_L2_RXC                          )    
);

endmodule

