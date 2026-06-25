////////////////////////////////////////////////////////////////////////////
//           _____       
//          / _______    Copyright (C) 2013-2021 Efinix Inc. All rights reserved.
//         / /       \   
//        / /  ..    /   top.v
//       / / .'     /    
//    __/ /.'      /     Description:
//   __   \       /      
//  /_/ /\ \_____/ /     
// ____/  \_______/      
//
// ***********************************************************************
// Revisions:
// 1.0 Initial rev
//
// ***********************************************************************
`timescale 1 ns / 1 ns
//`define SOFT_TAP
module top#(
)
(
// PLL
input                           clk_50m,
input                           clk_100m,
input                           pll_0_locked,
input                           pll_1_locked,
// SOC JTAG
`ifndef SOFT_TAP
input               		    jtag_inst1_TCK,
input               		    jtag_inst1_TDI,
output              		    jtag_inst1_TDO,
input               		    jtag_inst1_SEL,
input               		    jtag_inst1_CAPTURE,
input               		    jtag_inst1_SHIFT,
input               		    jtag_inst1_UPDATE,
input               		    jtag_inst1_RESET,
`else
input 				            io_jtag_tms,
input 				            io_jtag_tdi,
output 				            io_jtag_tdo,
input 				            io_jtag_tck,
`endif
//SOC UART
output  wire                    system_uart_0_io_txd,
input                           system_uart_0_io_rxd,
//SOC SPI
output  wire                    system_spi_0_io_sclk_write,
output  wire                    system_spi_0_io_data_0_writeEnable,
input                           system_spi_0_io_data_0_read,
output  wire                    system_spi_0_io_data_0_write,
output  wire                    system_spi_0_io_data_1_writeEnable,
input                           system_spi_0_io_data_1_read,
output  wire                    system_spi_0_io_data_1_write,
output  wire                    system_spi_0_io_ss,
//SOC MEMORY INTF
output  wire                    io_ddrA_arw_valid,
input                           io_ddrA_arw_ready,
output  wire    [31:0]          io_ddrA_arw_payload_addr,
output  wire    [7:0]           io_ddrA_arw_payload_id,
output  wire    [7:0]           io_ddrA_arw_payload_len,
output  wire    [2:0]           io_ddrA_arw_payload_size,
output  wire    [1:0]           io_ddrA_arw_payload_burst,
output  wire    [1:0]           io_ddrA_arw_payload_lock,
output  wire                    io_ddrA_arw_payload_write,
output  wire    [7:0]           io_ddrA_w_payload_id,
output  wire                    io_ddrA_w_valid,
input                           io_ddrA_w_ready,
output  wire    [127:0]         io_ddrA_w_payload_data,
output  wire    [15:0]          io_ddrA_w_payload_strb,
output  wire                    io_ddrA_w_payload_last,
input                           io_ddrA_b_valid,
output  wire                    io_ddrA_b_ready,
input           [7:0]           io_ddrA_b_payload_id,
input                           io_ddrA_r_valid,
output  wire                    io_ddrA_r_ready,
input           [127:0]         io_ddrA_r_payload_data,
input           [7:0]           io_ddrA_r_payload_id,
input           [1:0]           io_ddrA_r_payload_resp,
input                           io_ddrA_r_payload_last,
//SD INTF
output  wire                    sd_clk_hi,
output  wire                    sd_clk_lo,
input                           sd_cmd_i,
output  wire                    sd_cmd_o,
output  wire                    sd_cmd_oe,
input           [3:0]           sd_dat_i,
output  wire    [3:0]           sd_dat_o,
output  wire    [3:0]           sd_dat_oe,
input                           sd_wp
//input                         sd_cd_n
);
// Parameter Define 
localparam AXI_CNT = 1;
localparam AXI_DW = 32;         // Data Width
localparam AXI_AW = 32;         // Address Width
localparam AXI_SW = AXI_DW/8;   // Write Strobes Width
localparam AXIL_CNT = 1;
localparam APB_CNT = 2;

//--Reset
wire                            ddr_init_done;
wire                            pll_locked;
wire                            sys_clk50m_rstn;
wire                            pl_clk125m_rstn;
wire				            io_memoryReset;
wire				            io_systemReset;
//--SDHC Signals
wire                            sd_cd_n;
wire                            sd_int;
wire                            sd_dat_oe_w;
//--AXI4 Interface
wire    [AXI_CNT*8-1:0]         axi_awid;
wire    [AXI_CNT*AXI_AW-1:0]    axi_awaddr;
wire    [AXI_CNT*8-1:0]         axi_awlen;
wire    [AXI_CNT*3-1:0]         axi_awsize;
wire    [AXI_CNT*2-1:0]         axi_awburst;
wire    [AXI_CNT-1:0]           axi_awlock;
wire    [AXI_CNT*4-1:0]         axi_awcache;
wire    [AXI_CNT*3-1:0]         axi_awprot;
wire    [AXI_CNT-1:0]           axi_awvalid;
wire    [AXI_CNT-1:0]           axi_awready;
wire    [AXI_CNT*AXI_DW-1:0]    axi_wdata;
wire    [AXI_CNT*AXI_SW-1:0]    axi_wstrb;
wire    [AXI_CNT-1:0]           axi_wlast;
wire    [AXI_CNT-1:0]           axi_wvalid;
wire    [AXI_CNT-1:0]           axi_wready;
wire    [AXI_CNT*8-1:0]         axi_bid;
wire    [AXI_CNT*2-1:0]         axi_bresp;
wire    [AXI_CNT-1:0]           axi_bvalid;
wire    [AXI_CNT-1:0]           axi_bready;
wire    [AXI_CNT*8-1:0]         axi_arid;
wire    [AXI_CNT*AXI_AW-1:0]    axi_araddr;
wire    [AXI_CNT*8-1:0]         axi_arlen;
wire    [AXI_CNT*3-1:0]         axi_arsize;
wire    [AXI_CNT*2-1:0]         axi_arburst;
wire    [AXI_CNT-1:0]           axi_arlock;
wire    [AXI_CNT*4-1:0]         axi_arcache;
wire    [AXI_CNT*3-1:0]         axi_arprot;
wire    [AXI_CNT-1:0]           axi_arvalid;
wire    [AXI_CNT-1:0]           axi_arready;
wire    [AXI_CNT*8-1:0]         axi_rid;
wire    [AXI_CNT*AXI_DW-1:0]    axi_rdata;
wire    [AXI_CNT*2-1:0]         axi_rresp;
wire    [AXI_CNT-1:0]           axi_rlast;
wire    [AXI_CNT-1:0]           axi_rvalid;
wire    [AXI_CNT-1:0]           axi_rready;
//--AXI4-Lite Interface
wire    [AXIL_CNT*32-1:0]       axil_awaddr;
wire    [AXIL_CNT-1:0]          axil_awvalid;
wire    [AXIL_CNT-1:0]          axil_awready;
wire    [AXIL_CNT*32-1:0]       axil_wdata;
wire    [AXIL_CNT*4-1:0]        axil_wstrb;
wire    [AXIL_CNT-1:0]          axil_wvalid;
wire    [AXIL_CNT-1:0]          axil_wready;
wire    [AXIL_CNT*2-1:0]        axil_bresp;
wire    [AXIL_CNT-1:0]          axil_bvalid;
wire    [AXIL_CNT-1:0]          axil_bready;
wire    [AXIL_CNT*32-1:0]       axil_araddr;
wire    [AXIL_CNT-1:0]          axil_arvalid;
wire    [AXIL_CNT-1:0]          axil_arready;
wire    [AXIL_CNT*2-1:0]        axil_rresp;
wire    [AXIL_CNT*32-1:0]       axil_rdata;
wire    [AXIL_CNT-1:0]          axil_rvalid;
wire    [AXIL_CNT-1:0]          axil_rready;
//--APB3 Interface
wire    [APB_CNT*32-1:0]        apb_paddr;
wire    [APB_CNT-1:0]           apb_psel;
wire    [APB_CNT-1:0]           apb_penable;
wire    [APB_CNT-1:0]           apb_pready;
wire    [APB_CNT-1:0]           apb_pwrite;
wire    [APB_CNT*32-1:0]        apb_pwdata;
wire    [APB_CNT*32-1:0]        apb_prdata;
wire    [APB_CNT-1:0]           apb_pslverror;
// SDHC AXI4 and  AXI4-Lite Interface (CSR)
wire [31:0]  sdhc_csr_axi4_awaddr;
wire        sdhc_csr_axi4_awvalid;
wire        sdhc_csr_axi4_awready;
wire [31:0] sdhc_csr_axi4_wdata;
wire [3:0]  sdhc_csr_axi4_wstrb;
wire        sdhc_csr_axi4_wvalid;
wire        sdhc_csr_axi4_wready;
wire [1:0]  sdhc_csr_axi4_bresp;
wire        sdhc_csr_axi4_bvalid;
wire        sdhc_csr_axi4_bready;
wire [31:0]  sdhc_csr_axi4_araddr;
wire        sdhc_csr_axi4_arvalid;
wire        sdhc_csr_axi4_arready;
wire [1:0]  sdhc_csr_axi4_rresp;
wire [31:0] sdhc_csr_axi4_rdata;
wire        sdhc_csr_axi4_rvalid;
wire        sdhc_csr_axi4_rready;
wire [7:0]  sdhc_csr_axi4_awid;
wire [7:0]  sdhc_csr_axi4_arid;
wire [7:0]  sdhc_csr_axi4_rid;
wire [7:0]  sdhc_csr_axi4_bid;

wire [31:0]  sdhc_csr_axil_awaddr;
wire        sdhc_csr_axil_awvalid;
wire        sdhc_csr_axil_awready;
wire [31:0] sdhc_csr_axil_wdata;
wire [3:0]  sdhc_csr_axil_wstrb;
wire        sdhc_csr_axil_wvalid;
wire        sdhc_csr_axil_wready;
wire [1:0]  sdhc_csr_axil_bresp;
wire        sdhc_csr_axil_bvalid;
wire        sdhc_csr_axil_bready;
wire [31:0]  sdhc_csr_axil_araddr;
wire        sdhc_csr_axil_arvalid;
wire        sdhc_csr_axil_arready;
wire [1:0]  sdhc_csr_axil_rresp;
wire [31:0] sdhc_csr_axil_rdata;
wire        sdhc_csr_axil_rvalid;
wire        sdhc_csr_axil_rready;

/*----------------------------------------------------------------------------------*\
                                 The main code
\*----------------------------------------------------------------------------------*/

/*----------------------- Clock Region -----------------------*/


/*----------------------- Reset Region -----------------------*/
assign pll_locked = pll_0_locked & pll_1_locked;

//System Synchronize Reset
defparam u_sys_rstn.NUM_EXTERNAL_RESETS = 1;
defparam u_sys_rstn.NUM_DOMAINS = 1;
defparam u_sys_rstn.SEQUENTIAL_RELEASE = 1'b0; 
reset_control u_sys_rstn(
	.external_rstn                      ({pll_locked}                       ),
	.clk                                ({clk_50m}                          ),
	.rstn                               ({sys_clk50m_rstn}                  )
);

//Progarmmable Logic Synchronize Reset
defparam u_pl_rstn.NUM_EXTERNAL_RESETS = 2;
defparam u_pl_rstn.NUM_DOMAINS = 1;
defparam u_pl_rstn.SEQUENTIAL_RELEASE = 1'b0; 
reset_control u_pl_rstn(
	.external_rstn                      ({!pl_sw_rst,pll_locked}            ),
	.clk                                ({clk_50m}                          ),
	.rstn                               ({pl_clk50m_rstn}                   )
);

/*----------------------- Risc-V MCU Module ----------------------------*/
sd_soc soc_inst
(
    .io_systemClk                       (clk_50m                            ),
    .io_asyncReset                      (!sys_clk50m_rstn                   ),
    .io_memoryClk                       (clk_100m                           ),
    .io_memoryReset                     (io_memoryReset                     ),
    .system_uart_0_io_txd               (system_uart_0_io_txd               ),
    .system_uart_0_io_rxd               (system_uart_0_io_rxd               ),
    .io_apbSlave_0_PADDR                (apb_paddr    [0*32 +: 1*32]        ),
    .io_apbSlave_0_PSEL                 (apb_psel     [0*1  +: 1*1]         ),
    .io_apbSlave_0_PENABLE              (apb_penable  [0*1  +: 1*1]         ),
    .io_apbSlave_0_PREADY               (apb_pready   [0*1  +: 1*1]         ),
    .io_apbSlave_0_PWRITE               (apb_pwrite   [0*1  +: 1*1]         ),
    .io_apbSlave_0_PWDATA               (apb_pwdata   [0*32 +: 1*32]        ),
    .io_apbSlave_0_PRDATA               (apb_prdata   [0*32 +: 1*32]        ),
    .io_apbSlave_0_PSLVERROR            (apb_pslverror[0*1  +: 1*1]         ),
    .io_apbSlave_1_PADDR                (apb_paddr    [1*32 +: 1*32]        ),
    .io_apbSlave_1_PSEL                 (apb_psel     [1*1  +: 1*1]         ),
    .io_apbSlave_1_PENABLE              (apb_penable  [1*1  +: 1*1]         ),
    .io_apbSlave_1_PREADY               (apb_pready   [1*1  +: 1*1]         ),
    .io_apbSlave_1_PWRITE               (apb_pwrite   [1*1  +: 1*1]         ),
    .io_apbSlave_1_PWDATA               (apb_pwdata   [1*32 +: 1*32]        ),
    .io_apbSlave_1_PRDATA               (apb_prdata   [1*32 +: 1*32]        ),
    .io_apbSlave_1_PSLVERROR            (apb_pslverror[1*1  +: 1*1]         ),
    .axiA_awready  ( sdhc_csr_axi4_awready ),
    .axiA_awlen    (  ), // o
    .axiA_awsize   (  ), // o
    .axiA_awlock   (  ), // o
    .axiA_awqos    (  ), // o
    .axiA_awprot   (  ), // o
    .axiA_awcache  (  ), // o
    .axiA_awburst  (  ), // o
    .axiA_awaddr   ( sdhc_csr_axi4_awaddr ),
    .axiA_awid     ( sdhc_csr_axi4_awid ), // o
    .axiA_awregion (  ), // o
    .axiA_awvalid  ( sdhc_csr_axi4_awvalid ),
    .axiA_arburst  (  ), // o
    .axiA_arcache  (  ), // o
    .axiA_arsize   (  ), // o
    .axiA_arregion (  ), // o
    .axiA_arready  ( sdhc_csr_axi4_arready ),
    .axiA_arqos    (  ), // o
    .axiA_arprot   (  ), // o
    .axiA_arlock   (  ), // o
    .axiA_arlen    (  ), // o
    .axiA_arid     ( sdhc_csr_axi4_arid ), // o
    .axiA_arvalid  ( sdhc_csr_axi4_arvalid ),
    .axiA_araddr   ( sdhc_csr_axi4_araddr ),
    .axiA_wvalid   ( sdhc_csr_axi4_wvalid ),
    .axiA_wready   ( sdhc_csr_axi4_wready ),
    .axiA_wdata    ( sdhc_csr_axi4_wdata ),
    .axiA_wstrb    ( sdhc_csr_axi4_wstrb ),
    .axiA_wlast    (  ), //o
    .axiA_bvalid   ( sdhc_csr_axi4_bvalid ),
    .axiA_bready   ( sdhc_csr_axi4_bready ),
    .axiA_bid      ( sdhc_csr_axi4_bid ), // i
    .axiA_bresp    ( sdhc_csr_axi4_bresp ),
    .axiA_rlast    ( 1'b1 ), // i
    .axiA_rvalid   ( sdhc_csr_axi4_rvalid ),
    .axiA_rready   ( sdhc_csr_axi4_rready ),
    .axiA_rdata    ( sdhc_csr_axi4_rdata ),
    .axiA_rid      ( sdhc_csr_axi4_rid ), // i
    .axiA_rresp    ( sdhc_csr_axi4_rresp ),
    .axiAInterrupt (  ), // i
    .userInterruptA                     (sd_int                             ),
    .io_systemReset                     (io_systemReset                     ),
    .io_ddrA_arw_valid                  (io_ddrA_arw_valid                  ),
    .io_ddrA_arw_ready                  (io_ddrA_arw_ready                  ),
    .io_ddrA_arw_payload_addr           (io_ddrA_arw_payload_addr           ),
    .io_ddrA_arw_payload_id             (io_ddrA_arw_payload_id             ),
    .io_ddrA_arw_payload_region         (                                   ),
    .io_ddrA_arw_payload_len            (io_ddrA_arw_payload_len            ),
    .io_ddrA_arw_payload_size           (io_ddrA_arw_payload_size           ),
    .io_ddrA_arw_payload_burst          (io_ddrA_arw_payload_burst          ),
    .io_ddrA_arw_payload_lock           (io_ddrA_arw_payload_lock           ),
    .io_ddrA_arw_payload_cache          (                                   ),
    .io_ddrA_arw_payload_qos            (                                   ),
    .io_ddrA_arw_payload_prot           (                                   ),
    .io_ddrA_arw_payload_write          (io_ddrA_arw_payload_write          ),
    .io_ddrA_w_valid                    (io_ddrA_w_valid                    ),
    .io_ddrA_w_ready                    (io_ddrA_w_ready                    ),
    .io_ddrA_w_payload_data             (io_ddrA_w_payload_data             ),
    .io_ddrA_w_payload_strb             (io_ddrA_w_payload_strb             ),
    .io_ddrA_w_payload_last             (io_ddrA_w_payload_last             ),
    .io_ddrA_b_valid                    (io_ddrA_b_valid                    ),
    .io_ddrA_b_ready                    (io_ddrA_b_ready                    ),
    .io_ddrA_b_payload_id               (io_ddrA_b_payload_id               ),
    .io_ddrA_b_payload_resp             (2'h0                               ),
    .io_ddrA_r_valid                    (io_ddrA_r_valid                    ),
    .io_ddrA_r_ready                    (io_ddrA_r_ready                    ),
    .io_ddrA_r_payload_data             (io_ddrA_r_payload_data             ),
    .io_ddrA_r_payload_id               (io_ddrA_r_payload_id               ),
    .io_ddrA_r_payload_resp             (io_ddrA_r_payload_resp             ),
    .io_ddrA_r_payload_last             (io_ddrA_r_payload_last             ),
    .io_ddrA_w_payload_id               (io_ddrA_w_payload_id               ),
    .io_ddrMasters_0_aw_valid           (axi_awvalid[0*1      +: 1*1]       ),
    .io_ddrMasters_0_aw_ready           (axi_awready[0*1      +: 1*1]       ),
    .io_ddrMasters_0_aw_payload_addr    (axi_awaddr [0*AXI_AW +: 1*AXI_AW]  ),
    .io_ddrMasters_0_aw_payload_id      ( 'hE0 ),
    .io_ddrMasters_0_aw_payload_region  (  ),
    .io_ddrMasters_0_aw_payload_len     (axi_awlen  [0*8      +: 1*8]       ),
    .io_ddrMasters_0_aw_payload_size    (axi_awsize [0*3      +: 1*3]       ),
    .io_ddrMasters_0_aw_payload_burst   (axi_awburst[0*2      +: 1*2]       ),
    .io_ddrMasters_0_aw_payload_lock    (axi_awlock [0*1      +: 1*1]       ),
    .io_ddrMasters_0_aw_payload_cache   (axi_awcache[0*4      +: 1*4]       ),
    .io_ddrMasters_0_aw_payload_qos     (                                   ),
    .io_ddrMasters_0_aw_payload_prot    (                                   ),
    .io_ddrMasters_0_w_valid            (axi_wvalid [0*1      +: 1*1]       ),
    .io_ddrMasters_0_w_ready            (axi_wready [0*1      +: 1*1]       ),
    .io_ddrMasters_0_w_payload_data     (axi_wdata  [0*AXI_DW +: 1*AXI_DW]  ),
    .io_ddrMasters_0_w_payload_strb     (axi_wstrb  [0*AXI_SW +: 1*AXI_SW]  ),
    .io_ddrMasters_0_w_payload_last     (axi_wlast  [0*1      +: 1*1]       ),
    .io_ddrMasters_0_b_valid            (axi_bvalid [0*1      +: 1*1]       ),
    .io_ddrMasters_0_b_ready            (axi_bready [0*1      +: 1*1]       ),
    .io_ddrMasters_0_b_payload_id       (                                   ),
    .io_ddrMasters_0_b_payload_resp     (axi_bresp  [0*2      +: 1*2]       ),
    .io_ddrMasters_0_ar_valid           (axi_arvalid[0*1      +: 1*1]       ),
    .io_ddrMasters_0_ar_ready           (axi_arready[0*1      +: 1*1]       ),
    .io_ddrMasters_0_ar_payload_addr    (axi_araddr [0*AXI_AW +: 1*AXI_AW]  ),
    .io_ddrMasters_0_ar_payload_id      ('hE1                               ),
    .io_ddrMasters_0_ar_payload_region  (                                   ),
    .io_ddrMasters_0_ar_payload_len     (axi_arlen  [0*8      +: 1*8]       ),
    .io_ddrMasters_0_ar_payload_size    (axi_arsize [0*3      +: 1*3]       ),
    .io_ddrMasters_0_ar_payload_burst   (axi_arburst[0*2      +: 1*2]       ),
    .io_ddrMasters_0_ar_payload_lock    (axi_arlock [0*1      +: 1*1]       ),
    .io_ddrMasters_0_ar_payload_cache   (axi_arcache[0*4      +: 1*4]       ),
    .io_ddrMasters_0_ar_payload_qos     (                                   ),
    .io_ddrMasters_0_ar_payload_prot    (                                   ),
    .io_ddrMasters_0_r_valid            (axi_rvalid [0*1      +: 1*1]       ),
    .io_ddrMasters_0_r_ready            (axi_rready [0*1      +: 1*1]       ),
    .io_ddrMasters_0_r_payload_data     (axi_rdata  [0*AXI_DW +: 1*AXI_DW]  ),
    .io_ddrMasters_0_r_payload_id       (                                   ),
    .io_ddrMasters_0_r_payload_resp     (axi_rresp  [0*2      +: 1*2]       ),
    .io_ddrMasters_0_r_payload_last     (axi_rlast  [0*1      +: 1*1]       ),
    .io_ddrMasters_0_clk                (clk_50m                            ),
    .io_ddrMasters_0_reset              (                                   ),
    .system_spi_0_io_sclk_write	        (system_spi_0_io_sclk_write         ),
    .system_spi_0_io_data_0_writeEnable	(system_spi_0_io_data_0_writeEnable ),
    .system_spi_0_io_data_0_read        (system_spi_0_io_data_0_read        ),
    .system_spi_0_io_data_0_write       (system_spi_0_io_data_0_write       ),
    .system_spi_0_io_data_1_writeEnable	(system_spi_0_io_data_1_writeEnable ),
    .system_spi_0_io_data_1_read        (system_spi_0_io_data_1_read        ),
    .system_spi_0_io_data_1_write       (system_spi_0_io_data_1_write       ),
    .system_spi_0_io_data_2_writeEnable (                                   ),
    .system_spi_0_io_data_2_read        (                                   ),
    .system_spi_0_io_data_2_write       (                                   ),
    .system_spi_0_io_data_3_writeEnable (                                   ),
    .system_spi_0_io_data_3_read        (                                   ),
    .system_spi_0_io_data_3_write       (                                   ),
    .system_spi_0_io_ss                 (system_spi_0_io_ss                 ),
     `ifndef SOFT_TAP
    .jtagCtrl_tck			            (jtag_inst1_TCK			            ),
    .jtagCtrl_tdi			            (jtag_inst1_TDI			            ),
    .jtagCtrl_tdo			            (jtag_inst1_TDO			            ),
    .jtagCtrl_enable			        (jtag_inst1_SEL			            ),
    .jtagCtrl_capture			        (jtag_inst1_CAPTURE		            ),
    .jtagCtrl_shift			            (jtag_inst1_SHIFT		            ),
    .jtagCtrl_update			        (jtag_inst1_UPDATE		            ),
    .jtagCtrl_reset			            (jtag_inst1_RESET		            )
    `else
    .io_jtag_tms 			            ( io_jtag_tms 			            ),
    .io_jtag_tdi 			            ( io_jtag_tdi 			            ),
    .io_jtag_tdo 			            ( io_jtag_tdo 			            ),
    .io_jtag_tck			            ( io_jtag_tck 			            )
    `endif
);

axi4_to_axi4l u_axi4_to_axi4l
(
.axi_clk	( clk_50m ),
.axi_rstn	( sys_clk50m_rstn ),
// AXI4 Slave
.s_axi4_awready	( sdhc_csr_axi4_awready ),
.s_axi4_awaddr	( sdhc_csr_axi4_awaddr ),
.s_axi4_awid	( sdhc_csr_axi4_awid ),
.s_axi4_awvalid	( sdhc_csr_axi4_awvalid ),
.s_axi4_wready	( sdhc_csr_axi4_wready ),
.s_axi4_wdata	( sdhc_csr_axi4_wdata ),
.s_axi4_wstrb	( sdhc_csr_axi4_wstrb ),
.s_axi4_wvalid	( sdhc_csr_axi4_wvalid ),
.s_axi4_bready	( sdhc_csr_axi4_bready ),
.s_axi4_bresp	( sdhc_csr_axi4_bresp ),
.s_axi4_bid	    ( sdhc_csr_axi4_bid ),
.s_axi4_bvalid	( sdhc_csr_axi4_bvalid ),
.s_axi4_arready	( sdhc_csr_axi4_arready ),
.s_axi4_araddr	( sdhc_csr_axi4_araddr ),
.s_axi4_arid	( sdhc_csr_axi4_arid ),
.s_axi4_arvalid	( sdhc_csr_axi4_arvalid ),
.s_axi4_rready	( sdhc_csr_axi4_rready ),
.s_axi4_rdata	( sdhc_csr_axi4_rdata ),
.s_axi4_rresp	( sdhc_csr_axi4_rresp ),
.s_axi4_rid	    ( sdhc_csr_axi4_rid ),
.s_axi4_rvalid	( sdhc_csr_axi4_rvalid ),

// AXI4-Lite
.m_axi4l_awaddr	( sdhc_csr_axil_awaddr),
.m_axi4l_awvalid( sdhc_csr_axil_awvalid),
.m_axi4l_awready( sdhc_csr_axil_awready),
.m_axi4l_wdata	( sdhc_csr_axil_wdata),
.m_axi4l_wstrb  ( sdhc_csr_axil_wstrb),
.m_axi4l_wvalid	( sdhc_csr_axil_wvalid),
.m_axi4l_wready	( sdhc_csr_axil_wready),
.m_axi4l_bresp	( sdhc_csr_axil_bresp),
.m_axi4l_bvalid	( sdhc_csr_axil_bvalid),
.m_axi4l_bready	( sdhc_csr_axil_bready),
.m_axi4l_araddr	( sdhc_csr_axil_araddr),
.m_axi4l_arvalid( sdhc_csr_axil_arvalid),
.m_axi4l_arready( sdhc_csr_axil_arready),
.m_axi4l_rresp	( sdhc_csr_axil_rresp),
.m_axi4l_rdata	( sdhc_csr_axil_rdata),
.m_axi4l_rvalid	( sdhc_csr_axil_rvalid),
.m_axi4l_rready	( sdhc_csr_axil_rready)
);

/*----------------------- The System Registers Module -----------------------*/
sys_registers u_sys_registers
(
//Globle Signals
//
//APB3 Slave Interface
    .s_apb3_clk                         (clk_50m                            ),
    .s_apb3_rstn                        (!io_systemReset                    ),
    .s_apb3_paddr                       (apb_paddr    [1*32 +: 1*32]        ),
    .s_apb3_psel                        (apb_psel     [1*1  +: 1*1]         ),
    .s_apb3_penable                     (apb_penable  [1*1  +: 1*1]         ),
    .s_apb3_pready                      (apb_pready   [1*1  +: 1*1]         ),
    .s_apb3_pwrite                      (apb_pwrite   [1*1  +: 1*1]         ),
    .s_apb3_pwdata                      (apb_pwdata   [1*32 +: 1*32]        ),
    .s_apb3_prdata                      (apb_prdata   [1*32 +: 1*32]        ),
    .s_apb3_pslverror                   (apb_pslverror[1*1  +: 1*1]         ),
//Cfg Space Registers
//--Base Registers Field
    .pl_sw_rst                          (pl_sw_rst                          )
);

/*----------------------- The SD Host Controller Module --------------------*/
sd_host_exp u_sdhc
(
//Globle Signals
    .sd_rst                             (io_systemReset      	            ),
    .sd_base_clk                        (clk_100m                           ),
    .sd_int                             (sd_int                             ),
    .sd_wp                              (sd_wp                              ),
    .sd_cd_n                            (sd_cd_n                            ),
//AXI4-Lite Register Interface
    .s_axi_aclk                         (clk_50m                            ),
    .s_axi_awaddr                       (sdhc_csr_axil_awaddr[9:0]     ),
    .s_axi_awvalid                      (sdhc_csr_axil_awvalid          ),
    .s_axi_awready                      (sdhc_csr_axil_awready          ),
    .s_axi_wdata                        (sdhc_csr_axil_wdata         ),
    .s_axi_wstrb			            (sdhc_csr_axil_wstrb),
    .s_axi_wvalid                       (sdhc_csr_axil_wvalid          ),
    .s_axi_wready                       (sdhc_csr_axil_wready          ),
    .s_axi_bresp                        (sdhc_csr_axil_bresp         ),
    .s_axi_bvalid                       (sdhc_csr_axil_bvalid          ),
    .s_axi_bready                       (sdhc_csr_axil_bready          ),
    .s_axi_araddr                       (sdhc_csr_axil_araddr[9:0]     ),
    .s_axi_arvalid                      (sdhc_csr_axil_arvalid          ),
    .s_axi_arready                      (sdhc_csr_axil_arready          ),
    .s_axi_rresp                        (sdhc_csr_axil_rresp          ),
    .s_axi_rdata                        (sdhc_csr_axil_rdata         ),
    .s_axi_rvalid                       (sdhc_csr_axil_rvalid          ),
    .s_axi_rready                       (sdhc_csr_axil_rready          ),
//AXI4 Memory Bus Interface
    .m_axi_clk                          (clk_50m                            ),
//--Write Bus Interface
    .m_axi_awvalid                      (axi_awvalid[0*1      +: 1*1]       ),
    .m_axi_awaddr                       (axi_awaddr [0*AXI_AW +: 1*AXI_AW]  ),
    .m_axi_awlen                        (axi_awlen  [0*8      +: 1*8]       ),
    .m_axi_awsize                       (axi_awsize [0*3      +: 1*3]       ),
    .m_axi_awburst                      (axi_awburst[0*2      +: 1*2]       ),
    .m_axi_awprot                       (axi_awprot [0*3      +: 1*3]       ),
    .m_axi_awlock                       (axi_awlock [0*1      +: 1*1]       ),
    .m_axi_awcache                      (axi_awcache[0*4      +: 1*4]       ),
    .m_axi_awready                      (axi_awready[0*1      +: 1*1]       ),
    .m_axi_wdata                        (axi_wdata  [0*AXI_DW +: 1*AXI_DW]  ),
    .m_axi_wstrb                        (axi_wstrb  [0*AXI_SW +: 1*AXI_SW]  ),
    .m_axi_wlast                        (axi_wlast  [0*1      +: 1*1]       ),
    .m_axi_wvalid                       (axi_wvalid [0*1      +: 1*1]       ),
    .m_axi_wready                       (axi_wready [0*1      +: 1*1]       ),
    .m_axi_bresp                        (axi_bresp  [0*2      +: 1*2]       ),
    .m_axi_bvalid                       (axi_bvalid [0*1      +: 1*1]       ),
    .m_axi_bready                       (axi_bready [0*1      +: 1*1]       ),
//--Read Bus Interface
    .m_axi_arvalid                      (axi_arvalid[0*1      +: 1*1]       ),
    .m_axi_araddr                       (axi_araddr [0*AXI_AW +: 1*AXI_AW]  ),
    .m_axi_arlen                        (axi_arlen  [0*8      +: 1*8]       ),
    .m_axi_arsize                       (axi_arsize [0*3      +: 1*3]       ),
    .m_axi_arburst                      (axi_arburst[0*2      +: 1*2]       ),
    .m_axi_arprot                       (axi_arprot [0*3      +: 1*3]       ),
    .m_axi_arlock                       (axi_arlock [0*1      +: 1*1]       ),
    .m_axi_arcache                      (axi_arcache[0*4      +: 1*4]       ),
    .m_axi_arready                      (axi_arready[0*1      +: 1*1]       ),
    .m_axi_rvalid                       (axi_rvalid [0*1      +: 1*1]       ),
    .m_axi_rdata                        (axi_rdata  [0*AXI_DW +: 1*AXI_DW]  ),
    .m_axi_rlast                        (axi_rlast  [0*1      +: 1*1]       ),
    .m_axi_rresp                        (axi_rresp  [0*2      +: 1*2]       ),
    .m_axi_rready                       (axi_rready [0*1      +: 1*1]       ),
//SD Interface
    .sd_clk_hi                          (sd_clk_hi                          ),
    .sd_clk_lo                          (sd_clk_lo                          ),
    .sd_cmd_i                           (sd_cmd_i                           ),
    .sd_cmd_o                           (sd_cmd_o                           ),
    .sd_cmd_oe                          (sd_cmd_oe                          ),
    .sd_dat_i                           (sd_dat_i                           ),
    .sd_dat_o                           (sd_dat_o                           ),
    .sd_dat_oe                          (sd_dat_oe_w                        )
);

assign sd_dat_oe = {4{sd_dat_oe_w}};
assign sd_cd_n   = 1'b0;
/*----------------------------------------------------------------------------------*\
                                 The function code
\*----------------------------------------------------------------------------------*/
function integer clogb2;
input [31:0] value;
begin
value = value - 1;
for (clogb2 = 0; value > 0; clogb2 = clogb2 + 1)
value = value >> 1;
end
endfunction

endmodule

