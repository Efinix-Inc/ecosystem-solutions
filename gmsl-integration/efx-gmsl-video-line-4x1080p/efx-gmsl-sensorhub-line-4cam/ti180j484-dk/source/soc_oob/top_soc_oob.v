////////////////////////////////////////////////////////////////////////////
//           _____       
//          / _______    Copyright (C) 2013-2021 Efinix Inc. All rights reserved.
//         / /       \   
//        / /  ..    /   csi_rx_controllers.v
//       / / .'     /    
//    __/ /.'      /     Description:
//   __   \       /      Module for SOC board in TI180M484 OOB development Kit Example Design
//  /_/ /\ \_____/ /     
// ____/  \_______/      
//
// ***********************************************************************
// Revisions:
// 1.0 Initial rev
/////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

// ------------------------------------------------------------------------------
// 1. User requires to manually uncomment SOFT_TAP definition and reassign pin for
// soft jtag pins
// 2. User requires to manually edit SDC constraint for io_systemClk
// ------------------------------------------------------------------------------

//`define SOFT_TAP 1


`define AXI_MEM_DBW 512
`define AXI_MEM_AXI4_ENABLE 1
//`define AXI_M0_PORT_ENABLE 1
//`define AXI_M0_DBW 512;
//`define AXI_M1_PORT_ENABLE 1
//`define AXI_M1_DBW 512

`define AXI_M0_MEM_CHECKER_ENABLE 1
`define AXI_M0_DBW 512

//`define AXI_M1_SD_HOST_ENABLE 1
`define AXI_M1_DBW 32;

`define MEM_CHECKER_LFSR 1

module top_soc_oob #(

    
  	parameter   NUM_CAM		    = 4,
    parameter   SYS_FREQ_MHZ    = 100,
    parameter   HARD_CONFIG     = 32'h00000000
    
)
(
	//Clock Control
	input      io_systemClk,
	input      io_asyncReset,
	input      io_memoryClk,
	output	   io_memoryReset,
    output   wire  io_systemReset,
   
	input 		sd_base_clk,
	
   
	//Memory Interface
 
	`ifdef AXI_MEM_AXI4_ENABLE
    output              mem_ar_valid,
	input               mem_ar_ready,
	output     [31:0]   mem_ar_payload_addr,
	output     [7:0]    mem_ar_payload_id,
	output     [3:0]    mem_ar_payload_region,
	output     [7:0]    mem_ar_payload_len,
	output     [2:0]    mem_ar_payload_size,
	output     [1:0]    mem_ar_payload_burst,
	output     [0:0]    mem_ar_payload_lock,
	output     [3:0]    mem_ar_payload_cache,
	output     [3:0]    mem_ar_payload_qos,
	output     [2:0]    mem_ar_payload_prot,
	
    output              mem_aw_valid,
	input               mem_aw_ready,
	output     [31:0]   mem_aw_payload_addr,
	output     [7:0]    mem_aw_payload_id,
	output     [3:0]    mem_aw_payload_region,
	output     [7:0]    mem_aw_payload_len,
	output     [2:0]    mem_aw_payload_size,
	output     [1:0]    mem_aw_payload_burst,
	output     [0:0]    mem_aw_payload_lock,
	output     [3:0]    mem_aw_payload_cache,
	output     [3:0]    mem_aw_payload_qos,
	output     [2:0]    mem_aw_payload_prot,
	
    output              mem_w_valid,
	input               mem_w_ready,
	output     [`AXI_MEM_DBW-1:0]  	mem_w_payload_data,
	output     [`AXI_MEM_DBW/8-1:0]  mem_w_payload_strb,
	output              mem_w_payload_last,
	//output     [7:0]    mem_w_payload_id,

    input               mem_b_valid,
	output              mem_b_ready,
	input      [7:0]    mem_b_payload_id,
	input      [1:0]    mem_b_payload_resp,
	
    input               mem_r_valid,
	output              mem_r_ready,
	input      [`AXI_MEM_DBW-1:0]  mem_r_payload_data,
	input      [7:0]    mem_r_payload_id,
	input      [1:0]    mem_r_payload_resp,
	input               mem_r_payload_last,
	
    `else
    output              mem_arw_valid,
	input               mem_arw_ready,
	output     [31:0]   mem_arw_payload_addr,
	output     [7:0]    mem_arw_payload_id,
	output     [3:0]    mem_arw_payload_region,
	output     [7:0]    mem_arw_payload_len,
	output     [2:0]    mem_arw_payload_size,
	output     [1:0]    mem_arw_payload_burst,
	output     [0:0]    mem_arw_payload_lock,
	output     [3:0]    mem_arw_payload_cache,
	output     [3:0]    mem_arw_payload_qos,
	output     [2:0]    mem_arw_payload_prot,
	output              mem_arw_payload_write,
	
    output              mem_w_valid,
	input               mem_w_ready,
	output     [AXI_DBW-1:0]  	mem_w_payload_data,
	output     [AXI_DBW/8-1:0]  mem_w_payload_strb,
	output              mem_w_payload_last,
	
    input               mem_b_valid,
	output              mem_b_ready,
	input      [7:0]    mem_b_payload_id,
	input      [1:0]    mem_b_payload_resp,
	
    input               mem_r_valid,
	output              mem_r_ready,
	input      [AXI_DBW-1:0]  mem_r_payload_data,
	input      [7:0]    mem_r_payload_id,
	input      [1:0]    mem_r_payload_resp,
	input               mem_r_payload_last,
	output     [7:0]    mem_w_payload_id,
    `endif
    
//Port to Memory Axi Cross Bar Master  0 
`ifdef AXI_M0_PORT_ENABLE	
 	
    input               M0_clk,
    output              M0_reset,
    
	input               M0_aw_valid,
    output              M0_aw_ready,
    input      [31:0]   M0_aw_payload_addr,
    input      [3:0]    M0_aw_payload_id,
    input      [3:0]    M0_aw_payload_region,
    input      [7:0]    M0_aw_payload_len,
    input      [2:0]    M0_aw_payload_size,
    input      [1:0]    M0_aw_payload_burst,
    input      [0:0]    M0_aw_payload_lock,
    input      [3:0]    M0_aw_payload_cache,
    input      [3:0]    M0_aw_payload_qos,
    input      [2:0]    M0_aw_payload_prot,
    
    input               M0_w_valid,
    output              M0_w_ready,
    input      [AXI_MASTER0_DBW-1:0]  M0_w_payload_data,
    input      [AXI_MASTER0_DBW/8-1:0]   M0_w_payload_strb,
    input               M0_w_payload_last,
    
    output              M0_b_valid,
    input               M0_b_ready,
    output     [3:0]    M0_b_payload_id,
    output     [1:0]    M0_b_payload_resp,
    
    input               M0_ar_valid,
    output              M0_ar_ready,
    input      [31:0]   M0_ar_payload_addr,
    input      [3:0]    M0_ar_payload_id,
    input      [3:0]    M0_ar_payload_region,
    input      [7:0]    M0_ar_payload_len,
    input      [2:0]    M0_ar_payload_size,
    input      [1:0]    M0_ar_payload_burst,
    input      [0:0]    M0_ar_payload_lock,
    input      [3:0]    M0_ar_payload_cache,
    input      [3:0]    M0_ar_payload_qos,
    input      [2:0]    M0_ar_payload_prot,
    
    output              M0_r_valid,
    input               M0_r_ready,
    output     [AXI_MASTER0_DBW-1:0]  M0_r_payload_data,
    output     [3:0]    M0_r_payload_id,
    output     [1:0]    M0_r_payload_resp,
    output              M0_r_payload_last,
   
`endif	

//Port to Memory Axi Cross Bar Master  1 
`ifdef AXI_M1_PORT_ENABLE	
 	
    input               M1_clk,
    output              M1_reset,
    
	input               M1_aw_valid,
    output              M1_aw_ready,
    input      [31:0]   M1_aw_payload_addr,
    input      [3:0]    M1_aw_payload_id,
    input      [3:0]    M1_aw_payload_region,
    input      [7:0]    M1_aw_payload_len,
    input      [2:0]    M1_aw_payload_size,
    input      [1:0]    M1_aw_payload_burst,
    input      [0:0]    M1_aw_payload_lock,
    input      [3:0]    M1_aw_payload_cache,
    input      [3:0]    M1_aw_payload_qos,
    input      [2:0]    M1_aw_payload_prot,
    
    input               M1_w_valid,
    output              M1_w_ready,
    input      [`AXI_M1_DBW-1:0]  M1_w_payload_data,
    input      [`AXI_M1_DBW/8-1:0]   M1_w_payload_strb,
    input               M1_w_payload_last,
    
    output              M1_b_valid,
    input               M1_b_ready,
    output     [3:0]    M1_b_payload_id,
    output     [1:0]    M1_b_payload_resp,
    
    input               M1_ar_valid,
    output              M1_ar_ready,
    input      [31:0]   M1_ar_payload_addr,
    input      [3:0]    M1_ar_payload_id,
    input      [3:0]    M1_ar_payload_region,
    input      [7:0]    M1_ar_payload_len,
    input      [2:0]    M1_ar_payload_size,
    input      [1:0]    M1_ar_payload_burst,
    input      [0:0]    M1_ar_payload_lock,
    input      [3:0]    M1_ar_payload_cache,
    input      [3:0]    M1_ar_payload_qos,
    input      [2:0]    M1_ar_payload_prot,
    
    output              M1_r_valid,
    input               M1_r_ready,
    output     [`AXI_M1_DBW-1:0]  M1_r_payload_data,
    output     [3:0]    M1_r_payload_id,
    output     [1:0]    M1_r_payload_resp,
    output              M1_r_payload_last,
   
`endif	



	
	//SOC Ports
  	output              uart_0_txd,
  	input               uart_0_rxd,
	// Flash Interface 
  	output         		spi_flash_0_sclk_write,
  	output              spi_flash_0_data_0_writeEnable,
  	input          		spi_flash_0_data_0_read,
  	output         		spi_flash_0_data_0_write,
  	output              spi_flash_0_data_1_writeEnable,
  	input          		spi_flash_0_data_1_read,
  	output         		spi_flash_0_data_1_write,
  	output         		spi_flash_0_ss,
	
	output         		spi_flash_1_sclk_write,
  	output              spi_flash_1_data_0_writeEnable,
  	input          		spi_flash_1_data_0_read,
  	output         		spi_flash_1_data_0_write,
  	output              spi_flash_1_data_1_writeEnable,
  	input          		spi_flash_1_data_1_read,
  	output         		spi_flash_1_data_1_write,
  	output         		spi_flash_1_ss,

      
	// Camera I2C Interface 
	output   [NUM_CAM-1:0] cam_i2c_sda_write,
	input    [NUM_CAM-1:0] cam_i2c_sda_read,
	output   [NUM_CAM-1:0] cam_i2c_scl_write,
	input    [NUM_CAM-1:0] cam_i2c_scl_read,
			
	//APB Slave 1 (DMA Streamming Controller)
	input				dma_interrupt,
	
	output     [15:0]   dma_apbSlave_PADDR,
	output     [0:0]    dma_apbSlave_PSEL,
	output              dma_apbSlave_PENABLE,
	input               dma_apbSlave_PREADY,
	output              dma_apbSlave_PWRITE,
	output     [31:0]   dma_apbSlave_PWDATA,
	input      [31:0]   dma_apbSlave_PRDATA,
	input               dma_apbSlave_PSLVERROR,

	output     [15:0]   dma_sg_apbSlave_PADDR,
	output     [0:0]    dma_sg_apbSlave_PSEL,
	output              dma_sg_apbSlave_PENABLE,
	input               dma_sg_apbSlave_PREADY,
	output              dma_sg_apbSlave_PWRITE,
	output     [31:0]   dma_sg_apbSlave_PWDATA,
	input      [31:0]   dma_sg_apbSlave_PRDATA,
	input               dma_sg_apbSlave_PSLVERROR,

	 
	//SD Interface
	output  wire           sd_clk_hi,
	output  wire           sd_clk_lo,
	input                  sd_cmd_i,
	output  wire           sd_cmd_o,
	output  wire           sd_cmd_oe,
	input           [3:0]  sd_dat_i,
	output  wire    [3:0]  sd_dat_o,
	output  wire    [3:0]  sd_dat_oe,
	input                  sd_wp,
	input                  sd_cd_n,
	
    
   	//user custom ports
	output	[5:0]		o_LED,					//Bit [3:0]
	input	[5:0]		i_switch,
	
	//Reg 2 RGB Gain Control
	output 	[2:0]		o_red_gain,				//Bit [2:0]
	output 	[2:0]		o_green_gain,			//Bit [6:4]
	output 	[2:0]		o_blue_gain,				//Bit [10:8]
    
    output  wire [3:0]  o_start_dma_stream_in,	//Bit [0]
	output  wire [3:0]  o_start_dma_stream_out,	//Bit [1]
    output  wire [1:0]  o_start_vga_gen,	    //Bit [1]
    output  wire [0:0]  o_start_minip_tx,	    //Bit [1]
    output  wire [0:0]  o_start_minip_rx,	    //Bit [1]
    
    output  wire [1:0]        o_i2c_sel,
	output  wire [4:0]        o_debayer_sel,
    
    //
    output              mem_checker_pass,
    
`ifdef SOFT_TAP
  	input  				io_jtag_tms,
  	input  				io_jtag_tdi,
  	output 				io_jtag_tdo,
  	input  				io_jtag_tck
`else 
	input 				jtagCtrl_tck,
  	input 				jtagCtrl_tdi,
  	output				jtagCtrl_tdo,
  	input 				jtagCtrl_enable,
  	input 				jtagCtrl_capture,
  	input 				jtagCtrl_shift,
  	input 				jtagCtrl_update,
  	input 				jtagCtrl_reset
 `endif

);
/////////////////////////////////////////////////////////////////////////////



//Local Parameter 
localparam 	NI 	= 1;
//Reset and PLL

//wire					hbram_ready;
//wire 					mcuReset;
//wire					io_systemReset;
wire					io_ddrMasterReset;


//User Interupt
wire					userInterrupt;
wire   [NI-1:0] 			apb3Interrupt;
wire					axi4Interrupt;
//AXI Slave 0
wire   [7:0]				axi_awid;
wire   [31:0]				axi_awaddr;
wire   [7:0]				axi_awlen;
wire   [2:0]				axi_awsize;
wire   [1:0]				axi_awburst;
wire					axi_awlock;
wire   [3:0]				axi_awcache;
wire   [2:0]				axi_awprot;
wire   [3:0]				axi_awqos;
wire   [3:0]				axi_awregion;
wire	 				axi_awvalid;
wire					axi_awready;
wire   [31:0]				axi_wdata;
wire   [3:0] 				axi_wstrb;
wire					axi_wvalid;
wire	 				axi_wlast;
wire					axi_wready;
wire   [7:0]				axi_bid;
wire   [1:0]				axi_bresp;
wire	 				axi_bvalid;
wire					axi_bready;
wire   [7:0]				axi_arid;
wire   [31:0]				axi_araddr;
wire   [7:0]				axi_arlen;
wire   [2:0]				axi_arsize;
wire   [1:0]				axi_arburst;
wire	 				axi_arlock;
wire   [3:0]				axi_arcache;
wire   [2:0]				axi_arprot;
wire   [3:0]				axi_arqos;
wire   [3:0]				axi_arregion;
wire	 				axi_arvalid;
wire					axi_arready;
wire   [7:0]				axi_rid;
wire   [31:0]				axi_rdata;
wire   [1:0]				axi_rresp;
wire         				axi_rlast;
wire					axi_rvalid;
wire					axi_rready;	

wire					ddr_awValid;
wire					ddr_arValid;
wire					memoryFail;


//  I2C for Camera 	
wire	[1:0]	  w_cam_i2c_mux;
wire              w_i2c_0_sda_write;
wire               w_i2c_0_sda_read;
wire              w_i2c_0_scl_write;
wire               w_i2c_0_scl_read;


//APB Slave 0  (Regsisters Test)
wire 	 [15:0]   w_apbSlave_0_PADDR;
wire 	 [0:0]    w_apbSlave_0_PSEL;
wire 	          w_apbSlave_0_PENABLE;
wire 	          w_apbSlave_0_PREADY;
wire 	          w_apbSlave_0_PWRITE;
wire 	 [31:0]   w_apbSlave_0_PWDATA;
wire 	 [31:0]   w_apbSlave_0_PRDATA;
wire 	          w_apbSlave_0_PSLVERROR;

//APB Slave 1  (OOB Configuration Regsisters)
wire 	 [15:0]   w_apbSlave_1_PADDR;
wire 	 [0:0]    w_apbSlave_1_PSEL;
wire 	          w_apbSlave_1_PENABLE;
wire 	          w_apbSlave_1_PREADY;
wire 	          w_apbSlave_1_PWRITE;
wire 	 [31:0]   w_apbSlave_1_PWDATA;
wire 	 [31:0]   w_apbSlave_1_PRDATA;
wire 	          w_apbSlave_1_PSLVERROR;

 //SD APB3 Port
 //APB Slave 2  ( SD Host Controller )
wire     [15:0]   w_apbSlave_2_PADDR;
wire     [0:0]    w_apbSlave_2_PSEL;
wire              w_apbSlave_2_PENABLE;
wire              w_apbSlave_2_PREADY;
wire              w_apbSlave_2_PWRITE;
wire     [31:0]   w_apbSlave_2_PWDATA;
wire     [31:0]   w_apbSlave_2_PRDATA;
wire              w_apbSlave_2_PSLVERROR;

 //DMA Controller APB3 Port
 //APB Slave 3  ( DMA Controller )
wire     [15:0]   w_apbSlave_3_PADDR;
wire     [0:0]    w_apbSlave_3_PSEL;
wire              w_apbSlave_3_PENABLE;
wire              w_apbSlave_3_PREADY;
wire              w_apbSlave_3_PWRITE;
wire     [31:0]   w_apbSlave_3_PWDATA;
wire     [31:0]   w_apbSlave_3_PRDATA;
wire              w_apbSlave_3_PSLVERROR;




 
 
//--SDHC Signals
wire                            sd_int;
wire                            sd_dat_oe_w;


	
assign w_cam_i2c_mux = o_i2c_sel;


wire userInterrupt_0;

`ifdef AXI_M0_MEM_CHECKER_ENABLE




`ifdef  MEM_CHECKER_LFSR

wire [7:0]  m_awid_0;
wire [31:0] m_awaddr_0;
wire [7:0]  m_awlen_0;
wire [2:0]  m_awsize_0;
wire [1:0]  m_awburst_0;
wire [1:0]  m_awlock_0;
wire		m_awvalid_0;
wire		m_awready_0;

wire [7:0]  m_arid_0;
wire [31:0] m_araddr_0;
wire [7:0]  m_arlen_0;
wire [2:0]  m_arsize_0;
wire [1:0]  m_arburst_0;
wire [1:0]  m_arlock_0;
wire		m_arvalid_0;
wire		m_arready_0;

wire [7:0]  m_wid_0;
wire [`AXI_M0_DBW-1:0]       m_wdata_0;
wire [(`AXI_M0_DBW/8)-1:0]	m_wstrb_0;
wire		m_wlast_0;
wire		m_wvalid_0;
wire		m_wready_0;
wire [3:0] m_rid_0;
wire [`AXI_M0_DBW-1:0] m_rdata_0;
wire		m_rlast_0;
wire		m_rvalid_0;
wire		m_rready_0;
wire [1:0] m_rresp_0;
wire [7:0] m_bid_0;
wire [1:0] m_bresp_0;
wire		m_bvalid_0;
wire		m_bready_0;
wire		m_awvalid_0;
wire		m_arvalid_0;
wire		m_pass_0;
wire		m_start_0;
wire		io_axiMasterReset_0;

reg		    r_test_start_0;


timer_start #(
.MHZ(SYS_FREQ_MHZ),
.SECOND(3)
) memcheck_s0 (
.clk(io_systemClk),
.rst_n(~io_systemReset),
.start(m_start_0)
);

always @(posedge io_memoryClk or posedge io_axiMasterReset_0)
begin
    if (io_axiMasterReset_0)
    begin
        r_test_start_0 <= 1'b0;
    end
    else 
    begin
        r_test_start_0 <= m_start_0;
    end
end 
wire fail_0;
wire done_0;

wire [31:0] vio_mask;
assign vio_mask = {32{1'b1}};

memory_checker_lfsr #(
.START_ADDR('h00100000),
.STOP_ADDR('h001FF800)
    )
memcheck_0(

        .axi_clk(io_memoryClk),
        .rstn(~io_axiMasterReset_0),
        .start(r_test_start_0),
        
        .awid(m_awid_0),
        .awaddr(m_awaddr_0),
        .awlen(m_awlen_0),
        .awsize(m_awsize_0),
        .awburst(m_awburst_0),
        .awcache(),
        .awlock(m_awlock_0),
        .awvalid(m_awvalid_0),
        .awcobuf(),
        .awapcmd(),
        .awallstrb(),
        .awready(m_awready_0),
        .awqos(),
        
        .arid(m_arid_0),
        .araddr(m_araddr_0),
        .arlen(m_arlen_0),
        .arsize(m_arsize_0),
        .arburst(m_arburst_0),
        .arlock(m_arlock_0),
        .arvalid(m_arvalid_0),
        .arapcmd(),
        .arready(m_arready_0),
        .arqos(),
        .atype(),
        
        .wdata(m_wdata_0),
        .wstrb(m_wstrb_0),
        .wlast(m_wlast_0),
        .wvalid(m_wvalid_0),
        .wready(m_wready_0),
        .rid(m_rid_0),
        .rdata(m_rdata_0),
        .rlast(m_rlast_0),
        .rvalid(m_rvalid_0),
        .rready(m_rready_0),
        .rresp(m_rresp_0),
        .bid(m_bid_0),
        .bvalid(m_bvalid_0),
        .bready(m_bready_0),
        .fail(fail_0),
        .done(done_0),
        .rdata_obs(),
        .rdata_exp(),
        .i_lfsr_seed(128'h5555AAAA5555AAAA5555AAAA5555AAAA),
        .check_mask(vio_mask)
        
);
assign m_pass_0 = done_0 & (~fail_0);

`else

wire [7:0]  m_aid_0;
wire [31:0] m_aaddr_0;
wire [7:0]  m_alen_0;
wire [2:0]  m_asize_0;
wire [1:0]  m_aburst_0;
wire [1:0]  m_alock_0;
wire		m_avalid_0;
wire		m_aready_0;
wire		m_awready_0;
wire		m_arready_0;
wire		m_atype_0;
wire [7:0]  m_wid_0;
wire [`AXI_M0_DBW-1:0]       m_wdata_0;
wire [(`AXI_M0_DBW/8)-1:0]	m_wstrb_0;
wire		m_wlast_0;
wire		m_wvalid_0;
wire		m_wready_0;
wire [3:0] m_rid_0;
wire [`AXI_M0_DBW-1:0] m_rdata_0;
wire		m_rlast_0;
wire		m_rvalid_0;
wire		m_rready_0;
wire [1:0] m_rresp_0;
wire [7:0] m_bid_0;
wire [1:0] m_bresp_0;
wire		m_bvalid_0;
wire		m_bready_0;
wire		m_awvalid_0;
wire		m_arvalid_0;
wire		m_pass_0;
wire		m_start_0;
wire		io_axiMasterReset_0;

reg		    r_test_start_0;


assign m_aready_0=(m_atype_0 & m_awready_0) | (!m_atype_0 & m_arready_0);
assign m_awvalid_0=m_avalid_0 & m_atype_0;
assign m_arvalid_0=m_avalid_0 & ~m_atype_0;

timer_start #(
.MHZ(SYS_FREQ_MHZ),
.SECOND(3)
) memcheck_s0 (
.clk(io_systemClk),
.rst_n(~io_systemReset),
.start(m_start_0)
);

always @(posedge io_memoryClk or posedge io_axiMasterReset_0)
begin
    if (io_axiMasterReset_0)
    begin
        r_test_start_0 <= 1'b0;
    end
    else 
    begin
        r_test_start_0 <= m_start_0;
    end
end 

memory_checker #(
.START_ADDR('h00100000),
.STOP_ADDR('h001FF800),
.ALEN(63),
.WIDTH(`AXI_M0_DBW)
) memcheck_0 (
.axi_clk(io_memoryClk),
.rstn(~io_axiMasterReset_0),
.start(r_test_start_0),
.aid(m_aid_0),
.aaddr(m_aaddr_0),
.alen(m_alen_0),
.asize(m_asize_0),
.aburst(m_aburst_0),
.alock(m_alock_0),
.avalid(m_avalid_0),
.aready(m_aready_0),
.atype(m_atype_0),
.wid(m_wid_0),
.wdata(m_wdata_0),
.wstrb(m_wstrb_0),
.wlast(m_wlast_0),
.wvalid(m_wvalid_0),
.wready(m_wready_0),
.rid(m_rid_0),
.rdata(m_rdata_0),
.rlast(m_rlast_0),
.rvalid(m_rvalid_0),
.rready(m_rready_0),
.rresp(m_rresp_0),
.bid(m_bid_0),
.bvalid(m_bvalid_0),
.bready(m_bready_0),
.pass(m_pass_0));
`endif

assign mem_checker_pass = m_pass_0;
`endif 


genvar i;


assign w_i2c_0_scl_read = cam_i2c_scl_read[w_cam_i2c_mux];
assign w_i2c_0_sda_read = cam_i2c_sda_read[w_cam_i2c_mux];

generate 
	for (i=0; i< NUM_CAM; i=i+1)
	begin
    	assign cam_i2c_sda_write[i] = (w_cam_i2c_mux == i)?w_i2c_0_sda_write : 1'b1;
		assign cam_i2c_scl_write[i] = (w_cam_i2c_mux == i)?w_i2c_0_scl_write : 1'b1;
	end
endgenerate 

/////////////////////////////////////////////////////////////////////////////
apb3_slave #(
.ADDR_WIDTH(16)) apb_slave_0 (
.clk(io_systemClk),
.resetn(~io_systemReset),
.PADDR      (w_apbSlave_0_PADDR),
.PSEL       (w_apbSlave_0_PSEL),
.PENABLE    (w_apbSlave_0_PENABLE),
.PREADY     (w_apbSlave_0_PREADY),
.PWRITE     (w_apbSlave_0_PWRITE),
.PWDATA     (w_apbSlave_0_PWDATA),
.PRDATA     (w_apbSlave_0_PRDATA),
.PSLVERROR  (w_apbSlave_0_PSLVERROR));



//Custom APB PLUGIN
apb3_slave_oob #(
	// user parameter starts here
	//
	//.ADDR_WIDTH	(16),
//	.DATA_WIDTH	(32),
//	.NUM_REG	(5)
) apb_slave_1_oob (
	.clk		(io_systemClk),
	.resetn		(~io_systemReset),
	.PADDR		(w_apbSlave_1_PADDR),
	.PSEL		(w_apbSlave_1_PSEL),
	.PENABLE	(w_apbSlave_1_PENABLE),
	.PREADY		(w_apbSlave_1_PREADY),
	.PWRITE		(w_apbSlave_1_PWRITE),
	.PWDATA		(w_apbSlave_1_PWDATA),
	.PRDATA		(w_apbSlave_1_PRDATA),
	.PSLVERROR 	(w_apbSlave_1_PSLVERROR),
	
	// user logic starts here
	//Input Ports		
	.i_id(32'he4d3c2b1a0),					//Bit [31:0]		
	
	//Output Ports
	//Reg 0	LED Control
	.o_LED(o_LED),					//Bit [3:0]
	.i_switch(i_switch),
	
	//Reg 1 Streaming control
	.o_start_dma_stream_in(o_start_dma_stream_in),	
	.o_start_dma_stream_out(o_start_dma_stream_out),	
    .o_start_vga_gen(o_start_vga_gen),
    .o_start_minip_tx(o_start_minip_tx),	    //Bit [1]
    .o_start_minip_rx(o_start_minip_rx),	    //Bit [1]
	.o_uvc_resetn(o_uvc_resetn),
	//Reg 2 RGB Gain Control
	.o_red_gain(o_red_gain),		//Bit [2:0]
	.o_green_gain(o_green_gain),	//Bit [6:4]
	.o_blue_gain(o_blue_gain),		//Bit [10:8]
	
		
	.i_uvc_status(i_uvc_status),
	.o_uvc_control(o_uvc_control),
	.o_uvc_X_START(o_uvc_X_START),
	.o_uvc_X_WIN(o_uvc_X_WIN),
	.o_uvc_Y_START(o_uvc_Y_START),
	.o_uvc_Y_WIN(o_uvc_Y_WIN),
	
    .o_i2c_sel(o_i2c_sel),
    .o_debayer_sel(o_debayer_sel), 
    .i_hard_config(HARD_CONFIG)
);



axi4_slave #(
	.ADDR_WIDTH	(32),
	.DATA_WIDTH 	(32)
) axi_slave_0 (
	.axi_interrupt  (axi4Interrupt),
	.axi_aclk	(io_systemClk),
	.axi_resetn	(~io_systemReset),
	.axi_awid	(axi_awid),
	.axi_awaddr	(axi_awaddr),
	.axi_awlen	(axi_awlen),
	.axi_awsize	(axi_awsize),
	.axi_awburst	(axi_awburst),
	.axi_awlock	(axi_awlock),
	.axi_awcache	(axi_awcache),
	.axi_awprot	(axi_awprot),
	.axi_awqos	(axi_awqos),
	.axi_awregion	(axi_awregion),
	.axi_awvalid	(axi_awvalid),
	.axi_awready	(axi_awready),
	.axi_wdata	(axi_wdata),
	.axi_wstrb	(axi_wstrb),
	.axi_wlast	(axi_wlast),
	.axi_wvalid	(axi_wvalid),
	.axi_wready	(axi_wready),
	.axi_bid	(axi_bid),
	.axi_bresp	(axi_bresp),
	.axi_bvalid	(axi_bvalid),
	.axi_bready	(axi_bready),
	.axi_arid	(axi_arid),
	.axi_araddr	(axi_araddr),
	.axi_arlen	(axi_arlen),
	.axi_arsize	(axi_arsize),
	.axi_arburst	(axi_arburst),
	.axi_arlock	(axi_arlock),
	.axi_arcache	(axi_arcache),
	.axi_arprot	(axi_arprot),
	.axi_arqos	(axi_arqos),
	.axi_arregion	(axi_arregion),
	.axi_arvalid	(axi_arvalid),
	.axi_arready	(axi_arready),
	.axi_rid	(axi_rid),
	.axi_rdata	(axi_rdata),
	.axi_rresp	(axi_rresp),
        .axi_rlast	(axi_rlast),
	.axi_rvalid	(axi_rvalid),
	.axi_rready	(axi_rready)	
);


timer_start #(
.MHZ(SYS_FREQ_MHZ),
.SECOND(10),
.PULSE(1)
) intr_s0 (
.clk(io_systemClk),
.rst_n(~io_systemReset),
.start(userInterrupt_0));



`ifdef AXI_M1_SD_HOST_ENABLE
//SD ADMA port
//--AXI4 Interface for SD ADMA
wire    [7:0]	sd_axi_awid;
wire    [31:0]  sd_axi_awaddr;
wire    [7:0]   sd_axi_awlen;
wire    [3:0]   sd_axi_awsize;
wire    [1:0]   sd_axi_awburst;
wire    sd_axi_awlock;
wire    [3:0]   sd_axi_awcache;
wire    [2:0]   sd_axi_awprot;
wire    sd_axi_awvalid;
wire    sd_axi_awready;
wire    [31:0]  sd_axi_wdata;
wire    [3:0]   sd_axi_wstrb;
wire    sd_axi_wlast;
wire    sd_axi_wvalid;
wire    sd_axi_wready;
wire    [7:0]	sd_axi_bid;
wire    [1:0]	sd_axi_bresp;
wire    sd_axi_bvalid;
wire    sd_axi_bready;
wire    [7:0]   sd_axi_arid;
wire    [31:0]  sd_axi_araddr;
wire    [7:0]   sd_axi_arlen;
wire    [2:0]   sd_axi_arsize;
wire    [1:0]   sd_axi_arburst;
wire    sd_axi_arlock;
wire    [3:0]   sd_axi_arcache;
wire    [2:0]	sd_axi_arprot;
wire    sd_axi_arvalid;
wire    sd_axi_arready;
wire    [7:0]   sd_axi_rid;
wire    [31:0]  sd_axi_rdata;
wire    [1:0]   sd_axi_rresp;
wire    sd_axi_rlast;
wire    sd_axi_rvalid;
wire    sd_axi_rready;

//--AXI4-Lite Interface
wire    [9:0]       sd_axil_awaddr;
wire    sd_axil_awvalid;
wire    sd_axil_awready;
wire    [31:0]       sd_axil_wdata;
wire    sd_axil_wvalid;
wire    sd_axil_wready;
wire    [1:0]        sd_axil_bresp;
wire    sd_axil_bvalid;
wire    sd_axil_bready;
wire    [9:0]       sd_axil_araddr;
wire    sd_axil_arvalid;
wire    sd_axil_arready;
wire    [1:0]        sd_axil_rresp;
wire    [31:0]       sd_axil_rdata;
wire    sd_axil_rvalid;
wire    sd_axil_rready;


apb3_2_axi4_lite_sdhc u_apb_bus
(
//Globle Signals
    .clk                                (io_systemClk                            ),
    .rstn                               (!io_systemReset                     ),
//APB3 Slave Interface
    .s_apb3_paddr                       (w_apbSlave_2_PADDR ),
    .s_apb3_psel                        (w_apbSlave_2_PSEL),
    .s_apb3_penable                     (w_apbSlave_2_PENABLE),
    .s_apb3_pready                      (w_apbSlave_2_PREADY),
    .s_apb3_pwrite                      (w_apbSlave_2_PWRITE),
    .s_apb3_pwdata                      (w_apbSlave_2_PWDATA),
    .s_apb3_prdata                      (w_apbSlave_2_PRDATA),
    .s_apb3_pslverror                   (w_apbSlave_2_PSLVERROR),
//AXI4-Lite Master Interface
    .m_axi_awaddr                       (sd_axil_awaddr),
    .m_axi_awvalid                      (sd_axil_awvalid),
    .m_axi_awready                      (sd_axil_awready),
    .m_axi_wdata                        (sd_axil_wdata),
    .m_axi_wvalid                       (sd_axil_wvalid),
    .m_axi_wready                       (sd_axil_wready),
   // .m_axi_bresp                        (sd_axil_bresp ),
   // .m_axi_bvalid                       (sd_axil_bvalid),
   // .m_axi_bready                       (sd_axil_bready),
    .m_axi_araddr                       (sd_axil_araddr),
    .m_axi_arvalid                      (sd_axil_arvalid),
    .m_axi_arready                      (sd_axil_arready),
   // .m_axi_rresp                        (sd_axil_rresp),
    .m_axi_rdata                        (sd_axil_rdata),
    .m_axi_rvalid                       (sd_axil_rvalid),
    .m_axi_rready                       (sd_axil_rready)
);


sd_host u_sdhc
(
//Globle Signals
    .sd_rst                             (io_systemReset      	            ),
    .sd_base_clk                        (sd_base_clk                           ),
    .sd_int                             (sd_int                             ),
    .sd_wp                              (sd_wp                              ),
    .sd_cd_n                            (sd_cd_n                            ),
//AXI4-Lite Register Interface
    .s_axi_aclk                         (io_systemClk),
    .s_axi_awaddr                       (sd_axil_awaddr),
    .s_axi_awvalid                      (sd_axil_awvalid),
    .s_axi_awready                      (sd_axil_awready),
    .s_axi_wdata                        (sd_axil_wdata),
    .s_axi_wstrb                        ('hf),
    .s_axi_wvalid                       (sd_axil_wvalid),
    .s_axi_wready                       (sd_axil_wready),
    .s_axi_bresp                        (),//(sd_axil_bresp),
    .s_axi_bvalid                       (),//(sd_axil_bvalid),
    .s_axi_bready                       (1'b1),//(sd_axil_bready),
    .s_axi_araddr                       (sd_axil_araddr),
    .s_axi_arvalid                      (sd_axil_arvalid),
    .s_axi_arready                      (sd_axil_arready),
    .s_axi_rresp                        (),//(sd_axil_rresp),
    .s_axi_rdata                        (sd_axil_rdata),
    .s_axi_rvalid                       (sd_axil_rvalid),
    .s_axi_rready                       (sd_axil_rready),
//AXI4 Memory Bus Interface
    .m_axi_clk                          (io_memoryClk),
//--Write Bus Interface
//--AXI4 Interface for SD ADMA
    .m_axi_awvalid                      (sd_axi_awvalid),
    .m_axi_awaddr                       (sd_axi_awaddr),
    .m_axi_awlen                        (sd_axi_awlen),
    .m_axi_awsize                       (sd_axi_awsize),
    .m_axi_awburst                      (sd_axi_awburst),
    .m_axi_awprot                       (sd_axi_awprot),
    .m_axi_awlock                       (sd_axi_awlock),
    .m_axi_awcache                      (sd_axi_awcache),
    .m_axi_awready                      (sd_axi_awready),
    .m_axi_wdata                        (sd_axi_wdata),
    .m_axi_wstrb                        (sd_axi_wstrb),
    .m_axi_wlast                        (sd_axi_wlast),
    .m_axi_wvalid                       (sd_axi_wvalid),
    .m_axi_wready                       (sd_axi_wready),
    .m_axi_bresp                        (sd_axi_bresp),
    .m_axi_bvalid                       (sd_axi_bvalid),
    .m_axi_bready                       (sd_axi_bready),
//--Read Bus Interface
    .m_axi_arvalid                      (sd_axi_arvalid),
    .m_axi_araddr                       (sd_axi_araddr),
    .m_axi_arlen                        (sd_axi_arlen),
    .m_axi_arsize                       (sd_axi_arsize),
    .m_axi_arburst                      (sd_axi_arburst),
    .m_axi_arprot                       (sd_axi_arprot),
    .m_axi_arlock                       (sd_axi_arlock),
    .m_axi_arcache                      (sd_axi_arcache),
    .m_axi_arready                      (sd_axi_arready),
    .m_axi_rvalid                       (sd_axi_rvalid),
    .m_axi_rdata                        (sd_axi_rdata),
    .m_axi_rlast                        (sd_axi_rlast),
    .m_axi_rresp                        (sd_axi_rresp),
    .m_axi_rready                       (sd_axi_rready),
//SD Interface
    .sd_clk_hi                          (sd_clk_hi   ),
    .sd_clk_lo                          (sd_clk_lo   ),
    .sd_cmd_i                           (sd_cmd_i    ),
    .sd_cmd_o                           (sd_cmd_o    ),
    .sd_cmd_oe                          (sd_cmd_oe   ),
    .sd_dat_i                           (sd_dat_i    ),
    .sd_dat_o                           (sd_dat_o    ),
    .sd_dat_oe                          (sd_dat_oe_w )
);

assign sd_dat_oe = {4{sd_dat_oe_w}};
`endif 

soc_ti180 soc_inst
(
  .io_systemClk					(io_systemClk),
  .io_asyncReset				(io_asyncReset),
  .io_memoryClk					(io_memoryClk),
  .io_memoryReset				(io_memoryReset), 		
  .system_uart_0_io_txd			(uart_0_txd),
  .system_uart_0_io_rxd			(uart_0_rxd),
  .system_i2c_0_io_sda_write	(w_i2c_0_sda_write),
  .system_i2c_0_io_sda_read		(w_i2c_0_sda_read),
  .system_i2c_0_io_scl_write	(w_i2c_0_scl_write),
  .system_i2c_0_io_scl_read		(w_i2c_0_scl_read),
  .system_gpio_0_io_read		(),
  .system_gpio_0_io_write		(),
  .system_gpio_0_io_writeEnable	(),
  
  .io_apbSlave_0_PADDR			(w_apbSlave_0_PADDR),
  .io_apbSlave_0_PSEL			(w_apbSlave_0_PSEL),
  .io_apbSlave_0_PENABLE		(w_apbSlave_0_PENABLE),
  .io_apbSlave_0_PREADY			(w_apbSlave_0_PREADY),
  .io_apbSlave_0_PWRITE			(w_apbSlave_0_PWRITE),
  .io_apbSlave_0_PWDATA			(w_apbSlave_0_PWDATA),
  .io_apbSlave_0_PRDATA			(w_apbSlave_0_PRDATA),
  .io_apbSlave_0_PSLVERROR		(w_apbSlave_0_PSLVERROR),
  
  .io_apbSlave_1_PADDR			(w_apbSlave_1_PADDR),
  .io_apbSlave_1_PSEL			(w_apbSlave_1_PSEL),
  .io_apbSlave_1_PENABLE		(w_apbSlave_1_PENABLE),
  .io_apbSlave_1_PREADY			(w_apbSlave_1_PREADY),
  .io_apbSlave_1_PWRITE			(w_apbSlave_1_PWRITE),
  .io_apbSlave_1_PWDATA			(w_apbSlave_1_PWDATA),
  .io_apbSlave_1_PRDATA			(w_apbSlave_1_PRDATA),
  .io_apbSlave_1_PSLVERROR		(w_apbSlave_1_PSLVERROR),
  
  .io_apbSlave_2_PADDR			(w_apbSlave_2_PADDR),
  .io_apbSlave_2_PSEL			(w_apbSlave_2_PSEL),
  .io_apbSlave_2_PENABLE		(w_apbSlave_2_PENABLE),
  .io_apbSlave_2_PREADY			(w_apbSlave_2_PREADY),
  .io_apbSlave_2_PWRITE			(w_apbSlave_2_PWRITE),
  .io_apbSlave_2_PWDATA			(w_apbSlave_2_PWDATA),
  .io_apbSlave_2_PRDATA			(w_apbSlave_2_PRDATA),
  .io_apbSlave_2_PSLVERROR		(w_apbSlave_2_PSLVERROR),
  
  .io_apbSlave_3_PADDR			(dma_apbSlave_PADDR),
  .io_apbSlave_3_PSEL			(dma_apbSlave_PSEL),
  .io_apbSlave_3_PENABLE		(dma_apbSlave_PENABLE),
  .io_apbSlave_3_PREADY			(dma_apbSlave_PREADY),
  .io_apbSlave_3_PWRITE			(dma_apbSlave_PWRITE),
  .io_apbSlave_3_PWDATA			(dma_apbSlave_PWDATA),
  .io_apbSlave_3_PRDATA			(dma_apbSlave_PRDATA),
  .io_apbSlave_3_PSLVERROR		(dma_apbSlave_PSLVERROR),
  
  .io_apbSlave_4_PADDR			(dma_sg_apbSlave_PADDR),
  .io_apbSlave_4_PSEL			(dma_sg_apbSlave_PSEL),
  .io_apbSlave_4_PENABLE		(dma_sg_apbSlave_PENABLE),
  .io_apbSlave_4_PREADY			(dma_sg_apbSlave_PREADY),
  .io_apbSlave_4_PWRITE			(dma_sg_apbSlave_PWRITE),
  .io_apbSlave_4_PWDATA			(dma_sg_apbSlave_PWDATA),
  .io_apbSlave_4_PRDATA			(dma_sg_apbSlave_PRDATA),
  .io_apbSlave_4_PSLVERROR		(dma_sg_apbSlave_PSLVERROR),
  
  
  
  .userInterruptA				(userInterrupt_0),		
  .userInterruptB				(sd_int),  
  .userInterruptC				(dma_interrupt),  
 
 
 
  .io_systemReset				(io_systemReset),		
  
  `ifdef AXI_MEM_AXI4_ENABLE
  .io_ddrA_ar_valid			    (mem_ar_valid),
  .io_ddrA_ar_ready			    (mem_ar_ready),
  .io_ddrA_ar_payload_addr		(mem_ar_payload_addr),
  .io_ddrA_ar_payload_id		(mem_ar_payload_id),
  .io_ddrA_ar_payload_region	(mem_ar_payload_region),
  .io_ddrA_ar_payload_len		(mem_ar_payload_len),
  .io_ddrA_ar_payload_size		(mem_ar_payload_size),
  .io_ddrA_ar_payload_burst	    (mem_ar_payload_burst),
  .io_ddrA_ar_payload_lock		(mem_ar_payload_lock),
  .io_ddrA_ar_payload_cache 	(mem_ar_payload_cache),
  .io_ddrA_ar_payload_qos		(mem_ar_payload_qos),
  .io_ddrA_ar_payload_prot		(mem_ar_payload_prot),

  .io_ddrA_aw_valid			    (mem_aw_valid),
  .io_ddrA_aw_ready			    (mem_aw_ready),
  .io_ddrA_aw_payload_addr		(mem_aw_payload_addr),
  .io_ddrA_aw_payload_id		(mem_aw_payload_id),
  .io_ddrA_aw_payload_region	(mem_aw_payload_region),
  .io_ddrA_aw_payload_len		(mem_aw_payload_len),
  .io_ddrA_aw_payload_size		(mem_aw_payload_size),
  .io_ddrA_aw_payload_burst	    (mem_aw_payload_burst),
  .io_ddrA_aw_payload_lock		(mem_aw_payload_lock),
  .io_ddrA_aw_payload_cache	    (mem_aw_payload_cache),
  .io_ddrA_aw_payload_qos		(mem_aw_payload_qos),
  .io_ddrA_aw_payload_prot		(mem_aw_payload_prot),

  .io_ddrA_w_valid			    (mem_w_valid),
  .io_ddrA_w_ready			    (mem_w_ready),
  .io_ddrA_w_payload_data		(mem_w_payload_data),
  .io_ddrA_w_payload_strb		(mem_w_payload_strb),
  .io_ddrA_w_payload_last		(mem_w_payload_last),

  .io_ddrA_b_valid		    	(mem_b_valid),
  .io_ddrA_b_ready			    (mem_b_ready),
  .io_ddrA_b_payload_id			(mem_b_payload_id),
  .io_ddrA_b_payload_resp		(mem_b_payload_resp),

  .io_ddrA_r_valid			    (mem_r_valid),
  .io_ddrA_r_ready			    (mem_r_ready),
  .io_ddrA_r_payload_data		(mem_r_payload_data),
  .io_ddrA_r_payload_id			(mem_r_payload_id),
  .io_ddrA_r_payload_resp		(mem_r_payload_resp),
  .io_ddrA_r_payload_last		(mem_r_payload_last),
 // .io_ddrA_w_payload_id			(mem_w_payload_id),

  `else
  .io_ddrA_arw_valid			(mem_arw_valid),
  .io_ddrA_arw_ready			(mem_arw_ready),
  .io_ddrA_arw_payload_addr		(mem_arw_payload_addr),
  .io_ddrA_arw_payload_id		(mem_arw_payload_id),
  .io_ddrA_arw_payload_region	(mem_arw_payload_region),
  .io_ddrA_arw_payload_len		(mem_arw_payload_len),
  .io_ddrA_arw_payload_size		(mem_arw_payload_size),
  .io_ddrA_arw_payload_burst	(mem_arw_payload_burst),
  .io_ddrA_arw_payload_lock		(mem_arw_payload_lock),
  .io_ddrA_arw_payload_cache	(mem_arw_payload_cache),
  .io_ddrA_arw_payload_qos		(mem_arw_payload_qos),
  .io_ddrA_arw_payload_prot		(mem_arw_payload_prot),
  .io_ddrA_arw_payload_write	(mem_arw_payload_write),

  .io_ddrA_w_valid			    (mem_w_valid),
  .io_ddrA_w_ready			    (mem_w_ready),
  .io_ddrA_w_payload_data		(mem_w_payload_data),
  .io_ddrA_w_payload_strb		(mem_w_payload_strb),
  .io_ddrA_w_payload_last		(mem_w_payload_last),

  .io_ddrA_b_valid		    	(mem_b_valid),
  .io_ddrA_b_ready			    (mem_b_ready),
  .io_ddrA_b_payload_id			(mem_b_payload_id),
  .io_ddrA_b_payload_resp		(mem_b_payload_resp),

  .io_ddrA_r_valid			    (mem_r_valid),
  .io_ddrA_r_payload_data		(mem_r_payload_data),
  .io_ddrA_r_ready			    (mem_r_ready),
  .io_ddrA_r_payload_id			(mem_r_payload_id),
  .io_ddrA_r_payload_resp		(mem_r_payload_resp),
  .io_ddrA_r_payload_last		(mem_r_payload_last),
  .io_ddrA_w_payload_id			(mem_w_payload_id),
  `endif
  
  `ifdef AXI_M0_PORT_ENABLE
  .io_ddrMasters_0_aw_valid			(M0_aw_valid),
  .io_ddrMasters_0_aw_ready			(M0_aw_ready),
  .io_ddrMasters_0_aw_payload_addr	(M0_aw_payload_addr),
  .io_ddrMasters_0_aw_payload_id	(M0_aw_payload_id),
  .io_ddrMasters_0_aw_payload_region(M0_aw_payload_region),//({4{1'b0}}),
  .io_ddrMasters_0_aw_payload_len	(M0_aw_payload_len),
  .io_ddrMasters_0_aw_payload_size	(M0_aw_payload_size),
  .io_ddrMasters_0_aw_payload_burst	(M0_aw_payload_burst),
  .io_ddrMasters_0_aw_payload_lock	(M0_aw_payload_lock),
  .io_ddrMasters_0_aw_payload_cache	(M0_aw_payload_cache), //({4{1'b0}}),
  .io_ddrMasters_0_aw_payload_qos	(M0_aw_payload_cache),   //({4{1'b0}}),
  .io_ddrMasters_0_aw_payload_prot	(M0_aw_payload_prot),	//({3{1'b0}}),
  .io_ddrMasters_0_w_valid			(M0_w_valid),
  .io_ddrMasters_0_w_ready			(M0_w_ready),
  .io_ddrMasters_0_w_payload_data	(M0_w_payload_data),
  .io_ddrMasters_0_w_payload_strb	(M0_w_payload_strb),
  .io_ddrMasters_0_w_payload_last	(M0_w_payload_last),
  .io_ddrMasters_0_b_valid			(M0_b_valid),
  .io_ddrMasters_0_b_ready			(M0_b_ready),
  .io_ddrMasters_0_b_payload_id		(M0_b_payload_id),
  .io_ddrMasters_0_b_payload_resp	(M0_b_payload_resp),
  .io_ddrMasters_0_ar_valid			(M0_ar_valid),
  .io_ddrMasters_0_ar_ready			(M0_ar_ready),
  .io_ddrMasters_0_ar_payload_addr	(M0_ar_payload_addr),
  .io_ddrMasters_0_ar_payload_id	(M0_ar_payload_id),
  .io_ddrMasters_0_ar_payload_region(M0_ar_payload_region),//({4{1'b0}}),
  .io_ddrMasters_0_ar_payload_len	(M0_ar_payload_len),
  .io_ddrMasters_0_ar_payload_size	(M0_ar_payload_size),
  .io_ddrMasters_0_ar_payload_burst	(M0_ar_payload_burst),
  .io_ddrMasters_0_ar_payload_lock	(M0_ar_payload_lock),
  .io_ddrMasters_0_ar_payload_cache	(M0_ar_payload_cache), //({4{1'b0}}),
  .io_ddrMasters_0_ar_payload_qos	(M0_ar_payload_qos),   //({4{1'b0}}),
  .io_ddrMasters_0_ar_payload_prot	(M0_ar_payload_prot),	//({3{1'b0}}),
  .io_ddrMasters_0_r_valid			(M0_r_valid),
  .io_ddrMasters_0_r_ready			(M0_r_ready),
  .io_ddrMasters_0_r_payload_data	(M0_r_payload_data),
  .io_ddrMasters_0_r_payload_id		(M0_r_payload_id),
  .io_ddrMasters_0_r_payload_resp	(M0_r_payload_resp),
  .io_ddrMasters_0_r_payload_last	(M0_r_payload_last),
  .io_ddrMasters_0_clk				(M0_clk),
  .io_ddrMasters_0_reset			(M0_reset),
   `endif 
  
  
  `ifdef AXI_M0_MEM_CHECKER_ENABLE
  `ifdef MEM_CHECKER_LFSR
  
.io_ddrMasters_0_clk(io_memoryClk),
.io_ddrMasters_0_reset(io_axiMasterReset_0),
.io_ddrMasters_0_aw_valid(m_awvalid_0),
.io_ddrMasters_0_aw_ready(m_awready_0),
.io_ddrMasters_0_aw_payload_addr(m_awaddr_0),
.io_ddrMasters_0_aw_payload_id(m_awid_0[3:0]),
.io_ddrMasters_0_aw_payload_region(4'h0),
.io_ddrMasters_0_aw_payload_len(m_awlen_0),
.io_ddrMasters_0_aw_payload_size(m_awsize_0),
.io_ddrMasters_0_aw_payload_burst(m_awburst_0),
.io_ddrMasters_0_aw_payload_lock(m_awlock_0[0]),
.io_ddrMasters_0_aw_payload_cache(4'h0),
.io_ddrMasters_0_aw_payload_qos(4'h0),
.io_ddrMasters_0_aw_payload_prot(3'h0),
.io_ddrMasters_0_w_valid(m_wvalid_0),
.io_ddrMasters_0_w_ready(m_wready_0),
.io_ddrMasters_0_w_payload_data(m_wdata_0),
.io_ddrMasters_0_w_payload_strb(m_wstrb_0),
.io_ddrMasters_0_w_payload_last(m_wlast_0),
.io_ddrMasters_0_b_valid(m_bvalid_0),
.io_ddrMasters_0_b_ready(m_bready_0),
.io_ddrMasters_0_b_payload_id(m_bid_0[3:0]),
.io_ddrMasters_0_b_payload_resp(m_bresp_0),
.io_ddrMasters_0_ar_valid(m_arvalid_0),
.io_ddrMasters_0_ar_ready(m_arready_0),
.io_ddrMasters_0_ar_payload_addr(m_araddr_0),
.io_ddrMasters_0_ar_payload_id(m_arid_0[3:0]),
.io_ddrMasters_0_ar_payload_region(4'h0),
.io_ddrMasters_0_ar_payload_len(m_arlen_0),
.io_ddrMasters_0_ar_payload_size(m_arsize_0),
.io_ddrMasters_0_ar_payload_burst(m_arburst_0),
.io_ddrMasters_0_ar_payload_lock(m_arlock_0[0]),
.io_ddrMasters_0_ar_payload_cache(4'h0),
.io_ddrMasters_0_ar_payload_qos(4'h0),
.io_ddrMasters_0_ar_payload_prot(3'h0),
.io_ddrMasters_0_r_valid(m_rvalid_0),
.io_ddrMasters_0_r_ready(m_rready_0),
.io_ddrMasters_0_r_payload_data(m_rdata_0),
.io_ddrMasters_0_r_payload_id(m_rid_0),
.io_ddrMasters_0_r_payload_resp(m_rresp_0),
.io_ddrMasters_0_r_payload_last(m_rlast_0),
  `else 
.io_ddrMasters_0_clk(io_memoryClk),
.io_ddrMasters_0_reset(io_axiMasterReset_0),
.io_ddrMasters_0_aw_valid(m_awvalid_0),
.io_ddrMasters_0_aw_ready(m_awready_0),
.io_ddrMasters_0_aw_payload_addr(m_aaddr_0),
.io_ddrMasters_0_aw_payload_id(m_aid_0[3:0]),
.io_ddrMasters_0_aw_payload_region(4'h0),
.io_ddrMasters_0_aw_payload_len(m_alen_0),
.io_ddrMasters_0_aw_payload_size(m_asize_0),
.io_ddrMasters_0_aw_payload_burst(m_aburst_0),
.io_ddrMasters_0_aw_payload_lock(m_alock_0[0]),
.io_ddrMasters_0_aw_payload_cache(4'h0),
.io_ddrMasters_0_aw_payload_qos(4'h0),
.io_ddrMasters_0_aw_payload_prot(3'h0),
.io_ddrMasters_0_w_valid(m_wvalid_0),
.io_ddrMasters_0_w_ready(m_wready_0),
.io_ddrMasters_0_w_payload_data(m_wdata_0),
.io_ddrMasters_0_w_payload_strb(m_wstrb_0),
.io_ddrMasters_0_w_payload_last(m_wlast_0),
.io_ddrMasters_0_b_valid(m_bvalid_0),
.io_ddrMasters_0_b_ready(m_bready_0),
.io_ddrMasters_0_b_payload_id(m_bid_0[3:0]),
.io_ddrMasters_0_b_payload_resp(m_bresp_0),
.io_ddrMasters_0_ar_valid(m_arvalid_0),
.io_ddrMasters_0_ar_ready(m_arready_0),
.io_ddrMasters_0_ar_payload_addr(m_aaddr_0),
.io_ddrMasters_0_ar_payload_id(m_aid_0[3:0]),
.io_ddrMasters_0_ar_payload_region(4'h0),
.io_ddrMasters_0_ar_payload_len(m_alen_0),
.io_ddrMasters_0_ar_payload_size(m_asize_0),
.io_ddrMasters_0_ar_payload_burst(m_aburst_0),
.io_ddrMasters_0_ar_payload_lock(m_alock_0[0]),
.io_ddrMasters_0_ar_payload_cache(4'h0),
.io_ddrMasters_0_ar_payload_qos(4'h0),
.io_ddrMasters_0_ar_payload_prot(3'h0),
.io_ddrMasters_0_r_valid(m_rvalid_0),
.io_ddrMasters_0_r_ready(m_rready_0),
.io_ddrMasters_0_r_payload_data(m_rdata_0),
.io_ddrMasters_0_r_payload_id(m_rid_0),
.io_ddrMasters_0_r_payload_resp(m_rresp_0),
.io_ddrMasters_0_r_payload_last(m_rlast_0),
  
  `endif 
  `endif 
   
  `ifdef AXI_M1_PORT_ENABLE
  .io_ddrMasters_1_aw_valid			(M1_aw_valid),
  .io_ddrMasters_1_aw_ready			(M1_aw_ready),
  .io_ddrMasters_1_aw_payload_addr	(M1_aw_payload_addr),
  .io_ddrMasters_1_aw_payload_id	(M1_aw_payload_id),
  .io_ddrMasters_1_aw_payload_region(M1_aw_payload_region),//({4{1'b0}}),
  .io_ddrMasters_1_aw_payload_len	(M1_aw_payload_len),
  .io_ddrMasters_1_aw_payload_size	(M1_aw_payload_size),
  .io_ddrMasters_1_aw_payload_burst	(M1_aw_payload_burst),
  .io_ddrMasters_1_aw_payload_lock	(M1_aw_payload_lock),
  .io_ddrMasters_1_aw_payload_cache	(M1_aw_payload_cache), //({4{1'b0}}),
  .io_ddrMasters_1_aw_payload_qos	(M1_aw_payload_cache),   //({4{1'b0}}),
  .io_ddrMasters_1_aw_payload_prot	(M1_aw_payload_prot),	//({3{1'b0}}),
  .io_ddrMasters_1_w_valid			(M1_w_valid),
  .io_ddrMasters_1_w_ready			(M1_w_ready),
  .io_ddrMasters_1_w_payload_data	(M1_w_payload_data),
  .io_ddrMasters_1_w_payload_strb	(M1_w_payload_strb),
  .io_ddrMasters_1_w_payload_last	(M1_w_payload_last),
  .io_ddrMasters_1_b_valid			(M1_b_valid),
  .io_ddrMasters_1_b_ready			(M1_b_ready),
  .io_ddrMasters_1_b_payload_id		(M1_b_payload_id),
  .io_ddrMasters_1_b_payload_resp	(M1_b_payload_resp),
  .io_ddrMasters_1_ar_valid			(M1_ar_valid),
  .io_ddrMasters_1_ar_ready			(M1_ar_ready),
  .io_ddrMasters_1_ar_payload_addr	(M1_ar_payload_addr),
  .io_ddrMasters_1_ar_payload_id	(M1_ar_payload_id),
  .io_ddrMasters_1_ar_payload_region(M1_ar_payload_region),//({4{1'b0}}),
  .io_ddrMasters_1_ar_payload_len	(M1_ar_payload_len),
  .io_ddrMasters_1_ar_payload_size	(M1_ar_payload_size),
  .io_ddrMasters_1_ar_payload_burst	(M1_ar_payload_burst),
  .io_ddrMasters_1_ar_payload_lock	(M1_ar_payload_lock),
  .io_ddrMasters_1_ar_payload_cache	(M1_ar_payload_cache), //({4{1'b0}}),
  .io_ddrMasters_1_ar_payload_qos	(M1_ar_payload_qos),   //({4{1'b0}}),
  .io_ddrMasters_1_ar_payload_prot	(M1_ar_payload_prot),	//({3{1'b0}}),
  .io_ddrMasters_1_r_valid			(M1_r_valid),
  .io_ddrMasters_1_r_ready			(M1_r_ready),
  .io_ddrMasters_1_r_payload_data	(M1_r_payload_data),
  .io_ddrMasters_1_r_payload_id		(M1_r_payload_id),
  .io_ddrMasters_1_r_payload_resp	(M1_r_payload_resp),
  .io_ddrMasters_1_r_payload_last	(M1_r_payload_last),
  .io_ddrMasters_1_clk				(M1_clk),
  .io_ddrMasters_1_reset			(M1_reset),
  `endif 
  
  `ifdef AXI_M1_SD_HOST_ENABLE
  .io_ddrMasters_1_aw_valid           (sd_axi_awvalid),
  .io_ddrMasters_1_aw_ready           (sd_axi_awready),
  .io_ddrMasters_1_aw_payload_addr    (sd_axi_awaddr),
  .io_ddrMasters_1_aw_payload_id      ( 'hE0 ),
  .io_ddrMasters_1_aw_payload_region  (  ),
  .io_ddrMasters_1_aw_payload_len     (sd_axi_awlen),
  .io_ddrMasters_1_aw_payload_size    (sd_axi_awsize),
  .io_ddrMasters_1_aw_payload_burst   (sd_axi_awburst),
  .io_ddrMasters_1_aw_payload_lock    (sd_axi_awlock),
  .io_ddrMasters_1_aw_payload_cache   (sd_axi_awcache),
  .io_ddrMasters_1_aw_payload_qos     (  ),
  .io_ddrMasters_1_aw_payload_prot    (  ),
  .io_ddrMasters_1_w_valid            (sd_axi_wvalid),
  .io_ddrMasters_1_w_ready            (sd_axi_wready),
  .io_ddrMasters_1_w_payload_data     (sd_axi_wdata),
  .io_ddrMasters_1_w_payload_strb     (sd_axi_wstrb),
  .io_ddrMasters_1_w_payload_last     (sd_axi_wlast),
  .io_ddrMasters_1_b_valid            (sd_axi_bvalid),
  .io_ddrMasters_1_b_ready            (sd_axi_bready),
  .io_ddrMasters_1_b_payload_id       (  ),
  .io_ddrMasters_1_b_payload_resp     (sd_axi_bresp),
  
  .io_ddrMasters_1_ar_valid           (sd_axi_arvalid),
  .io_ddrMasters_1_ar_ready           (sd_axi_arready),
  .io_ddrMasters_1_ar_payload_addr    (sd_axi_araddr),
  .io_ddrMasters_1_ar_payload_id      ('hE1  ),
  .io_ddrMasters_1_ar_payload_region  (  ),
  .io_ddrMasters_1_ar_payload_len     (sd_axi_arlen),
  .io_ddrMasters_1_ar_payload_size    (sd_axi_arsize),
  .io_ddrMasters_1_ar_payload_burst   (sd_axi_arburst),
  .io_ddrMasters_1_ar_payload_lock    (sd_axi_arlock),
  .io_ddrMasters_1_ar_payload_cache   (sd_axi_arcache),
  .io_ddrMasters_1_ar_payload_qos     (  ),
  .io_ddrMasters_1_ar_payload_prot    (  ),
  .io_ddrMasters_1_r_valid            (sd_axi_rvalid),
  .io_ddrMasters_1_r_ready            (sd_axi_rready),
  .io_ddrMasters_1_r_payload_data     (sd_axi_rdata),
  .io_ddrMasters_1_r_payload_id       (  ),
  .io_ddrMasters_1_r_payload_resp     (sd_axi_rresp ),
  .io_ddrMasters_1_r_payload_last     (sd_axi_rlast),
  .io_ddrMasters_1_clk                (io_memoryClk ),
  .io_ddrMasters_1_reset              (             ),
  `endif
  
  
  .system_spi_0_io_sclk_write			(spi_flash_0_sclk_write),
  .system_spi_0_io_data_0_writeEnable	(spi_flash_0_data_0_writeEnable),
  .system_spi_0_io_data_0_read			(spi_flash_0_data_0_read),
  .system_spi_0_io_data_0_write			(spi_flash_0_data_0_write),
  .system_spi_0_io_data_1_writeEnable	(spi_flash_0_data_1_writeEnable),
  .system_spi_0_io_data_1_read			(spi_flash_0_data_1_read),
  .system_spi_0_io_data_1_write			(spi_flash_0_data_1_write),
  .system_spi_0_io_data_2_writeEnable	(),
  .system_spi_0_io_data_2_read		(),
  .system_spi_0_io_data_2_write		(),
  .system_spi_0_io_data_3_writeEnable	(),
  .system_spi_0_io_data_3_read		(),
  .system_spi_0_io_data_3_write		(),
  .system_spi_0_io_ss					(spi_flash_0_ss),
  
  .system_spi_1_io_sclk_write			(spi_flash_1_sclk_write),
  .system_spi_1_io_data_0_writeEnable	(spi_flash_1_data_0_writeEnable),
  .system_spi_1_io_data_0_read			(spi_flash_1_data_0_read),
  .system_spi_1_io_data_0_write			(spi_flash_1_data_0_write),
  .system_spi_1_io_data_1_writeEnable	(spi_flash_1_data_1_writeEnable),
  .system_spi_1_io_data_1_read			(spi_flash_1_data_1_read),
  .system_spi_1_io_data_1_write			(spi_flash_1_data_1_write),
  .system_spi_1_io_data_2_writeEnable	(),
  .system_spi_1_io_data_2_read		(),
  .system_spi_1_io_data_2_write		(),
  .system_spi_1_io_data_3_writeEnable	(),
  .system_spi_1_io_data_3_read		(),
  .system_spi_1_io_data_3_write		(),
  .system_spi_1_io_ss					(spi_flash_1_ss),
  
  
  
  .axiA_awvalid				(axi_awvalid),
  .axiA_awready				(axi_awready),
  .axiA_awaddr				(axi_awaddr),
  .axiA_awid				(axi_awid),
  .axiA_awregion			(axi_awregion),
  .axiA_awlen				(axi_awlen),
  .axiA_awsize				(axi_awsize),
  .axiA_awburst				(axi_awburst),
  .axiA_awlock				(axi_awlock),
  .axiA_awcache				(axi_awcache),
  .axiA_awqos				(axi_awqos),
  .axiA_awprot				(axi_awprot),
  .axiA_wvalid				(axi_wvalid),
  .axiA_wready				(axi_wready),
  .axiA_wdata				(axi_wdata),
  .axiA_wstrb				(axi_wstrb),
  .axiA_wlast				(axi_wlast),
  .axiA_bvalid				(axi_bvalid),
  .axiA_bready				(axi_bready),
  .axiA_bid				(axi_bid),
  .axiA_bresp				(axi_bresp),
  .axiA_arvalid				(axi_arvalid),
  .axiA_arready				(axi_arready),
  .axiA_araddr				(axi_araddr),
  .axiA_arid				(axi_arid),
  .axiA_arregion			(axi_arregion),
  .axiA_arlen				(axi_arlen),
  .axiA_arsize				(axi_arsize),
  .axiA_arburst				(axi_arburst),
  .axiA_arlock				(axi_arlock),
  .axiA_arcache				(axi_arcache),
  .axiA_arqos				(axi_arqos),
  .axiA_arprot				(axi_arprot),
  .axiA_rvalid				(axi_rvalid),
  .axiA_rready				(axi_rready),
  .axiA_rdata				(axi_rdata),
  .axiA_rid				(axi_rid),
  .axiA_rresp				(axi_rresp),
  .axiA_rlast				(axi_rlast),
  .axiAInterrupt			(axi4Interrupt),	
  
  `ifdef SOFT_TAP
  .io_jtag_tck				(io_jtag_tck),
  .io_jtag_tdi				(io_jtag_tdi),
  .io_jtag_tdo				(io_jtag_tdo),
  .io_jtag_tms				(io_jtag_tms)
 `else
  .jtagCtrl_tck				(jtagCtrl_tck),
  .jtagCtrl_tdi				(jtagCtrl_tdi),
  .jtagCtrl_tdo				(jtagCtrl_tdo),
  .jtagCtrl_enable			(jtagCtrl_enable),
  .jtagCtrl_capture			(jtagCtrl_capture),
  .jtagCtrl_shift			(jtagCtrl_shift),
  .jtagCtrl_update			(jtagCtrl_update),
  .jtagCtrl_reset			(jtagCtrl_reset)
 `endif
);





endmodule

//////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2013-2020 Efinix Inc. All rights reserved.
//
// This   document  contains  proprietary information  which   is
// protected by  copyright. All rights  are reserved.  This notice
// refers to original work by Efinix, Inc. which may be derivitive
// of other work distributed under license of the authors.  In the
// case of derivative work, nothing in this notice overrides the
// original author's license agreement.  Where applicable, the 
// original license agreement is included in it's original 
// unmodified form immediately below this header.
//
// WARRANTY DISCLAIMER.  
//     THE  DESIGN, CODE, OR INFORMATION ARE PROVIDED “AS IS” AND 
//     EFINIX MAKES NO WARRANTIES, EXPRESS OR IMPLIED WITH 
//     RESPECT THERETO, AND EXPRESSLY DISCLAIMS ANY IMPLIED WARRANTIES, 
//     INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF 
//     MERCHANTABILITY, NON-INFRINGEMENT AND FITNESS FOR A PARTICULAR 
//     PURPOSE.  SOME STATES DO NOT ALLOW EXCLUSIONS OF AN IMPLIED 
//     WARRANTY, SO THIS DISCLAIMER MAY NOT APPLY TO LICENSEE.
//
// LIMITATION OF LIABILITY.  
//     NOTWITHSTANDING ANYTHING TO THE CONTRARY, EXCEPT FOR BODILY 
//     INJURY, EFINIX SHALL NOT BE LIABLE WITH RESPECT TO ANY SUBJECT 
//     MATTER OF THIS AGREEMENT UNDER TORT, CONTRACT, STRICT LIABILITY 
//     OR ANY OTHER LEGAL OR EQUITABLE THEORY (I) FOR ANY INDIRECT, 
//     SPECIAL, INCIDENTAL, EXEMPLARY OR CONSEQUENTIAL DAMAGES OF ANY 
//     CHARACTER INCLUDING, WITHOUT LIMITATION, DAMAGES FOR LOSS OF 
//     GOODWILL, DATA OR PROFIT, WORK STOPPAGE, OR COMPUTER FAILURE OR 
//     MALFUNCTION, OR IN ANY EVENT (II) FOR ANY AMOUNT IN EXCESS, IN 
//     THE AGGREGATE, OF THE FEE PAID BY LICENSEE TO EFINIX HEREUNDER 
//     (OR, IF THE FEE HAS BEEN WAIVED, $100), EVEN IF EFINIX SHALL HAVE 
//     BEEN INFORMED OF THE POSSIBILITY OF SUCH DAMAGES.  SOME STATES DO 
//     NOT ALLOW THE EXCLUSION OR LIMITATION OF INCIDENTAL OR 
//     CONSEQUENTIAL DAMAGES, SO THIS LIMITATION AND EXCLUSION MAY NOT 
//     APPLY TO LICENSEE.
//
/////////////////////////////////////////////////////////////////////////////
