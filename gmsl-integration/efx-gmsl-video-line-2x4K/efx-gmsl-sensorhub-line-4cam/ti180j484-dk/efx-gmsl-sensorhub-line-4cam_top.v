////////////////////////////////////////////////////////////////////////////
//           _____       
//          / _______    Copyright (C) 2013-2026 Efinix Inc. All rights reserved.
//         / /       \   
//        / /  ..    /   efx_gmsl_sensorhub_line_4cam_top.v
//       / / .'     /    
//    __/ /.'      /     Description:
//   __   \       /       top file for Sensor Hub (4 Camera) of GMSL Video Streaming Demo
//  /_/ /\ \_____/ /     Support:
// ____/  \_______/       Per Line Mode
//
// ***********************************************************************
// Revisions:
// 1.0 Initial rev

/////////////////////////////////////////////////////////////////////////////////

`define MEM_SOC_AXI4_ENABLE

`define CSI_RX_4LANES   //Default 2 lanes
`define CSI_RX_LANE_DATAWIDTH   16

`define CSI_TX_4LANES   //Default 2 lanes
`define CSI_TX_LANE_DATAWIDTH   16
//`define HARD_I2C_CONFIG
`define CAM_I2C_ADDR 8'h1A

//'define HDMI_OUTPUT

module efx_gmsl_sensorhub_line_4cam_top #(
	parameter AXI_0_DATA_WIDTH = 512,
	parameter AXI_1_DATA_WIDTH  = 512,
	
	parameter NUM_CAM  			= 4,
	parameter NUM_CSI_TX		= 1,
    parameter NUM_CSI_TX_FANOUT	= 1,
    
	parameter NUM_VIDEO_OUT		= 2,
	parameter SYS_FREQ_MHZ    = 100, 
    parameter HARD_CONFIG       =32'h000004421 //Value Read by SOC 
                //Camera Module
                //HARD_CONFIG[3:0] = 1 support pi-camera module
                //HARD_CONFIG[3:0] = 2 support IMX477 Camera Module
                //HARD_CONFIG[3:0] = 3 support Coral Camera  Module
                //CSI Lanes     
                //HARD_CONFIG[7:4] = 2 for 2 lanes CSI RX/TX
                //Number of CSI RX Channels 
                //HARD_CONFIG[11:8] = 2 for 2 Channel CSI RX
                //Number of CSI RX Channels 
                //HARD_CONFIG[15:12] = 4 for 4 Channel CSI TX

)
(
	//Clock Control
    input      i_sd_clk,
	input      i_soc_clk,
	input      i_axi0_mem_clk, 
    input      i_axi1_mem_clk,
    input      i_hdmi_clk,
    input      i_pixel_clk,
    input      i_pixel_clk_tx,
    
	input 		rx_cfgclk,
	input 		tx_escclk,

    input       pll_ddr_LOCKED,  //  
    output      pll_ddr_RSTN,
    input       pll_osc2_LOCKED,    //
    output      pll_osc2_RSTN,
    input       pll_osc3_LOCKED,    //
    output      pll_osc3_RSTN,
    
    
    
    input       i_sys_clk,
    output      pll_sys_RSTN,
    input       pll_sys_LOCKED, //
    
    
    input       mipi_clk,
    input       i_sys_clk_25mhz,
  
	input 		sd_base_clk,


    
	//Startup Sequencer Signals
    output  ddr_inst_CFG_RESET,	//Active-high DDR configuration controller reset.
	output  ddr_inst_CFG_START,	//Start the DDR configuration controller.
	input   ddr_inst_CFG_DONE,	//Indicates the controller configuration is done
	output  ddr_inst_CFG_SEL,	//To select whether to use internal DDR configuration controller or user register ports for configuration:
								//0: Use internal configuration controller.
								//1: Use register configuration ports (cfg_rst, cfg_start, cfg_done will be disabled).
	//output  ddr_inst_CFG_PHY_RSTN,			//Active low reset to DDR PHY.
	
	// Controller Signal 
	//output 	ddr_inst_CTRL_RSTN,			//Controller Reset Signal 
	//input 	ddr_inst_CTRL_INT,			//Interrupt sign form controller 
	//input   ddr_inst_CTRL_MEM_RST_VALID,		//The user should wait until the mem_rst_valid signal is asserted and the DFI command signals have transitioned to the PHY pad outputs to release control of these signals
    //input 	ddr_inst_CTRL_REFRESH,		//Controller Refresh Pin Signal 
	//input 	ddr_inst_CTRL_BUSY,			//This will only be low when the controller is not reading data, writing data or processing a command
	
	//input 	ddr_inst_CTRL_CMD_Q_ALMOST_FULL, 	//Command Queue Full Pin 
	//input 	ddr_inst_CTRL_DP_IDLE,			 	//Data Path Idle
	//input 	[1:0] ddr_inst_CTRL_CKE,				 	//Delayed CKE form Controller
    //input 	[1:0] ddr_inst_CTRL_PORT_BUSY,	    //Port Busy Reading Data
	
	
    
  //DDR AXI 0
    output ddr_inst_ARST_0,
  //DDR AXI 0 Read Address Channel
	output	[32:0] ddr_inst_ARADDR_0,	//Read address. It gives the address of the first transfer in a burst transaction.
	output	[1:0] ddr_inst_ARBURST_0,	//Burst type. The burst type and the size determine how the address for each transfer within the burst is calculated.
	output	[5:0] ddr_inst_ARID_0,	//Address ID. This signal identifies the group of address signals.
	output	[7:0] ddr_inst_ARLEN_0,	//Burst length. This signal indicates the number of transfers in a burst.
	input	ddr_inst_ARREADY_0,		//Address ready. This signal indicates that the slave is ready to accept an address and associated control signals.
	output	[2:0]ddr_inst_ARSIZE_0,	//Burst size. This signal indicates the size of each transfer in the burst.
	output	ddr_inst_ARVALID_0,		//Address valid. This signal indicates that the channel is signaling valid address and control information.
	output	ddr_inst_ARLOCK_0,		//Lock type. This signal provides additional information about the atomic characteristics of the transfer.
	output	ddr_inst_ARAPCMD_0,		//Read auto-precharge.
	output	ddr_inst_ARQOS_0,		//QoS indentifier for read transaction.
  
   //DDR AXI 0 Wrtie Address Channel
	output	[32:0] ddr_inst_AWADDR_0,		//Write address. It gives the address of the first transfer in a burst transaction.
	output	[1:0] ddr_inst_AWBURST_0,		//Burst type. The burst type and the size determine how the address for each transfer within the burst is calculated.
	output	[5:0] ddr_inst_AWID_0,			//Address ID. This signal identifies the group of address signals.
	output	[7:0] ddr_inst_AWLEN_0,			//Burst length. This signal indicates the number of transfers in a burst.
	input	ddr_inst_AWREADY_0,				//Address ready. This signal indicates that the slave is ready to accept an address and associated control signals.
	output	[2:0] ddr_inst_AWSIZE_0,			//Burst size. This signal indicates the size of each transfer in the burst.
	output	ddr_inst_AWVALID_0,				//Address valid. This signal indicates that the channel is signaling valid address and control information.
	output	ddr_inst_AWLOCK_0,				//Lock type. This signal provides additional information about the atomic characteristics of the transfer.
	output	ddr_inst_AWAPCMD_0,				//Write auto-precharge.
	output	ddr_inst_AWQOS_0,				//QoS indentifier for write transaction.
	output	[3:0] ddr_inst_AWCACHE_0,			//Memory type. This signal indicates how transactions are required to progress through a system.
	output	ddr_inst_AWALLSTRB_0,			//Write all strobes asserted.
	output	ddr_inst_AWCOBUF_0,				//Write coherent bufferable selection.
	
	//DDR AXI 0 Wrtie Response Channel
	input	[5:0]ddr_inst_BID_0,			//Response ID tag. This signal is the ID tag of the write response.
	output	ddr_inst_BREADY_0,			//Response ready. This signal indicates that the master can accept a write response.
	input	[1:0]ddr_inst_BRESP_0,		//Read response. This signal indicates the status of the read transfer.
	input	ddr_inst_BVALID_0,			//Write response valid. This signal indicates that the channel is signaling a valid write response.
	
	//DDR AXI 0 Read Data Channel
	input	[AXI_0_DATA_WIDTH-1:0] ddr_inst_RDATA_0,	//Read data.
	input	[5:0] ddr_inst_RID_0,		//Read ID tag. This signal is the identification tag for the read data group of signals generated by the slave.
	input	ddr_inst_RLAST_0,		//Read last. This signal indicates the last transfer in a read burst.
	output	ddr_inst_RREADY_0,		//Read ready. This signal indicates that the master can accept the read data and response information.
	input	[1:0] ddr_inst_RRESP_0,	//Read response. This signal indicates the status of the read transfer.
	input	ddr_inst_RVALID_0,		//Read valid. This signal indicates that the channel is signaling the required read data.
	
	//DDR AXI 0 Write Data Channel Signals 
	
	output	[AXI_0_DATA_WIDTH-1:0]	ddr_inst_WDATA_0,	//Write data. AXI4 port 0 is 256, port 1 is 128.
	output	ddr_inst_WLAST_0,			//Write last. This signal indicates the last transfer in a write burst.
	input	ddr_inst_WREADY_0,		//Write ready. This signal indicates that the slave can accept the write data.
	output	[AXI_0_DATA_WIDTH/8-1:0] ddr_inst_WSTRB_0,	//Write strobes. This signal indicates which byte lanes hold valid data. There is one write strobe bit for each eight bits of the write data bus.
	output	ddr_inst_WVALID_0,		//Write valid. This signal indicates that valid write data and strobes are available.
	
    
	//DDR AXI 1 Read Address Channel
	output  ddr_inst_ARST_1,
    output	[32:0] ddr_inst_ARADDR_1,	//Read address. It gives the address of the first transfer in a burst transaction.
	output	[1:0] ddr_inst_ARBURST_1,	//Burst type. The burst type and the size determine how the address for each transfer within the burst is calculated.
	output	[5:0] ddr_inst_ARID_1,	//Address ID. This signal identifies the group of address signals.
	output	[7:0] ddr_inst_ARLEN_1,	//Burst length. This signal indicates the number of transfers in a burst.
	input	ddr_inst_ARREADY_1,		//Address ready. This signal indicates that the slave is ready to accept an address and associated control signals.
	output	[2:0]ddr_inst_ARSIZE_1,	//Burst size. This signal indicates the size of each transfer in the burst.
	output	ddr_inst_ARVALID_1,		//Address valid. This signal indicates that the channel is signaling valid address and control information.
	output	ddr_inst_ARLOCK_1,		//Lock type. This signal provides additional information about the atomic characteristics of the transfer.
	output	ddr_inst_ARAPCMD_1,		//Read auto-precharge.
	output	ddr_inst_ARQOS_1,		//QoS indentifier for read transaction.
  
   //DDR AXI 1 Wrtie Address Channel
	output	[32:0] ddr_inst_AWADDR_1,		//Write address. It gives the address of the first transfer in a burst transaction.
	output	[1:0] ddr_inst_AWBURST_1,		//Burst type. The burst type and the size determine how the address for each transfer within the burst is calculated.
	output	[5:0] ddr_inst_AWID_1,			//Address ID. This signal identifies the group of address signals.
	output	[7:0] ddr_inst_AWLEN_1,			//Burst length. This signal indicates the number of transfers in a burst.
	input	ddr_inst_AWREADY_1,				//Address ready. This signal indicates that the slave is ready to accept an address and associated control signals.
	output	[2:0] ddr_inst_AWSIZE_1,			//Burst size. This signal indicates the size of each transfer in the burst.
	output	ddr_inst_AWVALID_1,				//Address valid. This signal indicates that the channel is signaling valid address and control information.
	output	ddr_inst_AWLOCK_1,				//Lock type. This signal provides additional information about the atomic characteristics of the transfer.
	output	ddr_inst_AWAPCMD_1,				//Write auto-precharge.
	output	ddr_inst_AWQOS_1,				//QoS indentifier for write transaction.
	output	[3:0] ddr_inst_AWCACHE_1,			//Memory type. This signal indicates how transactions are required to progress through a system.
	output	ddr_inst_AWALLSTRB_1,			//Write all strobes asserted.
	output	ddr_inst_AWCOBUF_1,				//Write coherent bufferable selection.
	
	//DDR AXI 1 Wrtie Response Channel
	input	[5:0]ddr_inst_BID_1,			//Response ID tag. This signal is the ID tag of the write response.
	output	ddr_inst_BREADY_1,			//Response ready. This signal indicates that the master can accept a write response.
	input	[1:0]ddr_inst_BRESP_1,		//Read response. This signal indicates the status of the read transfer.
	input	ddr_inst_BVALID_1,			//Write response valid. This signal indicates that the channel is signaling a valid write response.
	
	//DDR AXI 1 Read Data Channel
	input	[AXI_1_DATA_WIDTH-1:0] ddr_inst_RDATA_1,	//Read data.
	input	[5:0] ddr_inst_RID_1,		//Read ID tag. This signal is the identification tag for the read data group of signals generated by the slave.
	input	ddr_inst_RLAST_1,		//Read last. This signal indicates the last transfer in a read burst.
	output	ddr_inst_RREADY_1,		//Read ready. This signal indicates that the master can accept the read data and response information.
	input	[1:0] ddr_inst_RRESP_1,	//Read response. This signal indicates the status of the read transfer.
	input	ddr_inst_RVALID_1,		//Read valid. This signal indicates that the channel is signaling the required read data.
	
	//DDR AXI 1 Write Data Channel Signals 
	
	output	[AXI_1_DATA_WIDTH-1:0]	ddr_inst_WDATA_1,	//Write data. AXI4 port 0 is 256, port 1 is 128.
	output	ddr_inst_WLAST_1,			//Write last. This signal indicates the last transfer in a write burst.
	input	ddr_inst_WREADY_1,		//Write ready. This signal indicates that the slave can accept the write data.
	output	[AXI_1_DATA_WIDTH/8-1:0] ddr_inst_WSTRB_1,	//Write strobes. This signal indicates which byte lanes hold valid data. There is one write strobe bit for each eight bits of the write data bus.
	output	ddr_inst_WVALID_1,		//Write valid. This signal indicates that valid write data and strobes are available.
	
      
    output 					system_spi_0_io_sclk_write,
    output 					system_spi_0_io_data_0_writeEnable,
    input 					system_spi_0_io_data_0_read,
    output 					system_spi_0_io_data_0_write,
    output 					system_spi_0_io_data_1_writeEnable,
    input 					system_spi_0_io_data_1_read,
    output 					system_spi_0_io_data_1_write,  
    output 					system_spi_0_io_ss,
  
    //output 					system_spi_1_io_sclk_write,
    output 					system_spi_1_io_data_0_writeEnable,
    input 					system_spi_1_io_data_0_read,
    output 					system_spi_1_io_data_0_write,
    output 					system_spi_1_io_data_1_writeEnable,
    input 					system_spi_1_io_data_1_read,
    output 					system_spi_1_io_data_1_write,  
    output 					system_spi_1_io_ss,
  
  
    output              	system_uart_0_io_txd,
    input               	system_uart_0_io_rxd,
    
	
	//CSI Camera interface 
	input	[NUM_CAM-1:0]	i_cam_sda,
    output	[NUM_CAM-1:0]	o_cam_sda_oe,
    input	[NUM_CAM-1:0]	i_cam_scl,
    output	[NUM_CAM-1:0]	o_cam_scl_oe,
  //  output	[NUM_CAM-1:0]	o_cam_rstn,

	
    //CSI RX Interface
  //MIPI DPHY RX0
  input  mipi_dphy_rx_inst1_WORD_CLKOUT_HS,
  
  output mipi_dphy_rx_inst1_FORCE_RX_MODE,
  output mipi_dphy_rx_inst1_RESET_N,
  output mipi_dphy_rx_inst1_RST0_N,
  
  input mipi_dphy_rx_inst1_ERR_CONTENTION_LP0,
  input mipi_dphy_rx_inst1_ERR_CONTENTION_LP1,
  input mipi_dphy_rx_inst1_ERR_CONTROL_LAN0,
  input mipi_dphy_rx_inst1_ERR_CONTROL_LAN1,
  input mipi_dphy_rx_inst1_ERR_ESC_LAN0,
  input mipi_dphy_rx_inst1_ERR_ESC_LAN1,
  input mipi_dphy_rx_inst1_ERR_SOT_HS_LAN0,
  input mipi_dphy_rx_inst1_ERR_SOT_HS_LAN1,
  input mipi_dphy_rx_inst1_ERR_SOT_SYNC_HS_LAN0,
  input mipi_dphy_rx_inst1_ERR_SOT_SYNC_HS_LAN1,
  input mipi_dphy_rx_inst1_LP_CLK,
  input mipi_dphy_rx_inst1_RX_ACTIVE_HS_LAN0,
  input mipi_dphy_rx_inst1_RX_ACTIVE_HS_LAN1,
  input mipi_dphy_rx_inst1_RX_CLK_ACTIVE_HS,
  input mipi_dphy_rx_inst1_ESC_LAN0_CLK,
  input mipi_dphy_rx_inst1_ESC_LAN1_CLK,
  input [7:0] mipi_dphy_rx_inst1_RX_DATA_ESC,
  input [CSI_RX_DATA_WIDTH_LANE-1:0] mipi_dphy_rx_inst1_RX_DATA_HS_LAN0,
  input [CSI_RX_DATA_WIDTH_LANE-1:0] mipi_dphy_rx_inst1_RX_DATA_HS_LAN1,
  input mipi_dphy_rx_inst1_RX_LPDT_ESC,
  input mipi_dphy_rx_inst1_RX_SKEW_CAL_HS_LAN0,
  input mipi_dphy_rx_inst1_RX_SKEW_CAL_HS_LAN1,
  input mipi_dphy_rx_inst1_RX_SYNC_HS_LAN0,
  input mipi_dphy_rx_inst1_RX_SYNC_HS_LAN1,
  input [3:0] mipi_dphy_rx_inst1_RX_TRIGGER_ESC,
  input mipi_dphy_rx_inst1_RX_ULPS_ACTIVE_CLK_NOT,
  input mipi_dphy_rx_inst1_RX_ULPS_ACTIVE_NOT_LAN0,
  input mipi_dphy_rx_inst1_RX_ULPS_ACTIVE_NOT_LAN1,
  input mipi_dphy_rx_inst1_RX_ULPS_CLK_NOT,
  input mipi_dphy_rx_inst1_RX_ULPS_ESC_LAN0,
  input mipi_dphy_rx_inst1_RX_ULPS_ESC_LAN1,
  input mipi_dphy_rx_inst1_RX_VALID_ESC,
  input mipi_dphy_rx_inst1_RX_VALID_HS_LAN0,
  input mipi_dphy_rx_inst1_RX_VALID_HS_LAN1,
  input mipi_dphy_rx_inst1_STOPSTATE_CLK,
  input mipi_dphy_rx_inst1_STOPSTATE_LAN0,
  input mipi_dphy_rx_inst1_STOPSTATE_LAN1,
  
  `ifdef CSI_RX_4LANES
  input mipi_dphy_rx_inst1_ERR_CONTROL_LAN2,
  input mipi_dphy_rx_inst1_ERR_CONTROL_LAN3,
  input mipi_dphy_rx_inst1_ERR_ESC_LAN2,
  input mipi_dphy_rx_inst1_ERR_ESC_LAN3,
  input mipi_dphy_rx_inst1_ERR_SOT_HS_LAN2,
  input mipi_dphy_rx_inst1_ERR_SOT_HS_LAN3,
  input mipi_dphy_rx_inst1_ERR_SOT_SYNC_HS_LAN2,
  input mipi_dphy_rx_inst1_ERR_SOT_SYNC_HS_LAN3,
  input mipi_dphy_rx_inst1_RX_ACTIVE_HS_LAN2,
  input mipi_dphy_rx_inst1_RX_ACTIVE_HS_LAN3,
  input mipi_dphy_rx_inst1_ESC_LAN2_CLK,
  input mipi_dphy_rx_inst1_ESC_LAN3_CLK,
  input [CSI_RX_DATA_WIDTH_LANE-1:0] mipi_dphy_rx_inst1_RX_DATA_HS_LAN2,
  input [CSI_RX_DATA_WIDTH_LANE-1:0] mipi_dphy_rx_inst1_RX_DATA_HS_LAN3,
  input mipi_dphy_rx_inst1_RX_SKEW_CAL_HS_LAN2,
  input mipi_dphy_rx_inst1_RX_SKEW_CAL_HS_LAN3,
  input mipi_dphy_rx_inst1_RX_SYNC_HS_LAN2,
  input mipi_dphy_rx_inst1_RX_SYNC_HS_LAN3,
  input mipi_dphy_rx_inst1_RX_ULPS_ACTIVE_NOT_LAN2,
  input mipi_dphy_rx_inst1_RX_ULPS_ACTIVE_NOT_LAN3,
  input mipi_dphy_rx_inst1_RX_ULPS_ESC_LAN2,
  input mipi_dphy_rx_inst1_RX_ULPS_ESC_LAN3,
  input mipi_dphy_rx_inst1_RX_VALID_HS_LAN2,
  input mipi_dphy_rx_inst1_RX_VALID_HS_LAN3,
  input mipi_dphy_rx_inst1_STOPSTATE_LAN2,
  input mipi_dphy_rx_inst1_STOPSTATE_LAN3,
  `endif
  
  //MIPI DPHY RX1
  input  mipi_dphy_rx_inst2_WORD_CLKOUT_HS,
  
  output mipi_dphy_rx_inst2_FORCE_RX_MODE,
  output mipi_dphy_rx_inst2_RESET_N,
  output mipi_dphy_rx_inst2_RST0_N,
  
  input mipi_dphy_rx_inst2_ERR_CONTENTION_LP0,
  input mipi_dphy_rx_inst2_ERR_CONTENTION_LP1,
  input mipi_dphy_rx_inst2_ERR_CONTROL_LAN0,
  input mipi_dphy_rx_inst2_ERR_CONTROL_LAN1,
  input mipi_dphy_rx_inst2_ERR_ESC_LAN0,
  input mipi_dphy_rx_inst2_ERR_ESC_LAN1,
  input mipi_dphy_rx_inst2_ERR_SOT_HS_LAN0,
  input mipi_dphy_rx_inst2_ERR_SOT_HS_LAN1,
  input mipi_dphy_rx_inst2_ERR_SOT_SYNC_HS_LAN0,
  input mipi_dphy_rx_inst2_ERR_SOT_SYNC_HS_LAN1,
  input mipi_dphy_rx_inst2_LP_CLK,
  input mipi_dphy_rx_inst2_RX_ACTIVE_HS_LAN0,
  input mipi_dphy_rx_inst2_RX_ACTIVE_HS_LAN1,
  input mipi_dphy_rx_inst2_RX_CLK_ACTIVE_HS,
  input mipi_dphy_rx_inst2_ESC_LAN0_CLK,
  input mipi_dphy_rx_inst2_ESC_LAN1_CLK,
  input [7:0] mipi_dphy_rx_inst2_RX_DATA_ESC,
  input [CSI_RX_DATA_WIDTH_LANE-1:0] mipi_dphy_rx_inst2_RX_DATA_HS_LAN0,
  input [CSI_RX_DATA_WIDTH_LANE-1:0] mipi_dphy_rx_inst2_RX_DATA_HS_LAN1,
  input mipi_dphy_rx_inst2_RX_LPDT_ESC,
  input mipi_dphy_rx_inst2_RX_SKEW_CAL_HS_LAN0,
  input mipi_dphy_rx_inst2_RX_SKEW_CAL_HS_LAN1,
  input mipi_dphy_rx_inst2_RX_SYNC_HS_LAN0,
  input mipi_dphy_rx_inst2_RX_SYNC_HS_LAN1,
  input [3:0] mipi_dphy_rx_inst2_RX_TRIGGER_ESC,
  input mipi_dphy_rx_inst2_RX_ULPS_ACTIVE_CLK_NOT,
  input mipi_dphy_rx_inst2_RX_ULPS_ACTIVE_NOT_LAN0,
  input mipi_dphy_rx_inst2_RX_ULPS_ACTIVE_NOT_LAN1,
  input mipi_dphy_rx_inst2_RX_ULPS_CLK_NOT,
  input mipi_dphy_rx_inst2_RX_ULPS_ESC_LAN0,
  input mipi_dphy_rx_inst2_RX_ULPS_ESC_LAN1,
  input mipi_dphy_rx_inst2_RX_VALID_ESC,
  input mipi_dphy_rx_inst2_RX_VALID_HS_LAN0,
  input mipi_dphy_rx_inst2_RX_VALID_HS_LAN1,
  input mipi_dphy_rx_inst2_STOPSTATE_CLK,
  input mipi_dphy_rx_inst2_STOPSTATE_LAN0,
  input mipi_dphy_rx_inst2_STOPSTATE_LAN1,

 `ifdef CSI_RX_4LANES
  input mipi_dphy_rx_inst2_ERR_CONTROL_LAN2,
  input mipi_dphy_rx_inst2_ERR_CONTROL_LAN3,
  input mipi_dphy_rx_inst2_ERR_ESC_LAN2,
  input mipi_dphy_rx_inst2_ERR_ESC_LAN3,
  input mipi_dphy_rx_inst2_ERR_SOT_HS_LAN2,
  input mipi_dphy_rx_inst2_ERR_SOT_HS_LAN3,
  input mipi_dphy_rx_inst2_ERR_SOT_SYNC_HS_LAN2,
  input mipi_dphy_rx_inst2_ERR_SOT_SYNC_HS_LAN3,
  input mipi_dphy_rx_inst2_RX_ACTIVE_HS_LAN2,
  input mipi_dphy_rx_inst2_RX_ACTIVE_HS_LAN3,
  input mipi_dphy_rx_inst2_ESC_LAN2_CLK,
  input mipi_dphy_rx_inst2_ESC_LAN3_CLK,
  input [CSI_RX_DATA_WIDTH_LANE-1:0] mipi_dphy_rx_inst2_RX_DATA_HS_LAN2,
  input [CSI_RX_DATA_WIDTH_LANE-1:0] mipi_dphy_rx_inst2_RX_DATA_HS_LAN3,
  input mipi_dphy_rx_inst2_RX_SKEW_CAL_HS_LAN2,
  input mipi_dphy_rx_inst2_RX_SKEW_CAL_HS_LAN3,
  input mipi_dphy_rx_inst2_RX_SYNC_HS_LAN2,
  input mipi_dphy_rx_inst2_RX_SYNC_HS_LAN3,
  input mipi_dphy_rx_inst2_RX_ULPS_ACTIVE_NOT_LAN2,
  input mipi_dphy_rx_inst2_RX_ULPS_ACTIVE_NOT_LAN3,
  input mipi_dphy_rx_inst2_RX_ULPS_ESC_LAN2,
  input mipi_dphy_rx_inst2_RX_ULPS_ESC_LAN3,
  input mipi_dphy_rx_inst2_RX_VALID_HS_LAN2,
  input mipi_dphy_rx_inst2_RX_VALID_HS_LAN3,
  input mipi_dphy_rx_inst2_STOPSTATE_LAN2,
  input mipi_dphy_rx_inst2_STOPSTATE_LAN3,
  `endif
  
  
 //MIPI DPHY RX2
  input  mipi_dphy_rx_inst3_WORD_CLKOUT_HS,
  
  output mipi_dphy_rx_inst3_FORCE_RX_MODE,
  output mipi_dphy_rx_inst3_RESET_N,
  output mipi_dphy_rx_inst3_RST0_N,
  
  input mipi_dphy_rx_inst3_ERR_CONTENTION_LP0,
  input mipi_dphy_rx_inst3_ERR_CONTENTION_LP1,
  input mipi_dphy_rx_inst3_ERR_CONTROL_LAN0,
  input mipi_dphy_rx_inst3_ERR_CONTROL_LAN1,
  input mipi_dphy_rx_inst3_ERR_ESC_LAN0,
  input mipi_dphy_rx_inst3_ERR_ESC_LAN1,
  input mipi_dphy_rx_inst3_ERR_SOT_HS_LAN0,
  input mipi_dphy_rx_inst3_ERR_SOT_HS_LAN1,
  input mipi_dphy_rx_inst3_ERR_SOT_SYNC_HS_LAN0,
  input mipi_dphy_rx_inst3_ERR_SOT_SYNC_HS_LAN1,
  input mipi_dphy_rx_inst3_LP_CLK,
  input mipi_dphy_rx_inst3_RX_ACTIVE_HS_LAN0,
  input mipi_dphy_rx_inst3_RX_ACTIVE_HS_LAN1,
  input mipi_dphy_rx_inst3_RX_CLK_ACTIVE_HS,
  input mipi_dphy_rx_inst3_ESC_LAN0_CLK,
  input mipi_dphy_rx_inst3_ESC_LAN1_CLK,
  input [7:0] mipi_dphy_rx_inst3_RX_DATA_ESC,
  input [CSI_RX_DATA_WIDTH_LANE-1:0] mipi_dphy_rx_inst3_RX_DATA_HS_LAN0,
  input [CSI_RX_DATA_WIDTH_LANE-1:0] mipi_dphy_rx_inst3_RX_DATA_HS_LAN1,
  input mipi_dphy_rx_inst3_RX_LPDT_ESC,
  input mipi_dphy_rx_inst3_RX_SKEW_CAL_HS_LAN0,
  input mipi_dphy_rx_inst3_RX_SKEW_CAL_HS_LAN1,
  input mipi_dphy_rx_inst3_RX_SYNC_HS_LAN0,
  input mipi_dphy_rx_inst3_RX_SYNC_HS_LAN1,
  input [3:0] mipi_dphy_rx_inst3_RX_TRIGGER_ESC,
  input mipi_dphy_rx_inst3_RX_ULPS_ACTIVE_CLK_NOT,
  input mipi_dphy_rx_inst3_RX_ULPS_ACTIVE_NOT_LAN0,
  input mipi_dphy_rx_inst3_RX_ULPS_ACTIVE_NOT_LAN1,
  input mipi_dphy_rx_inst3_RX_ULPS_CLK_NOT,
  input mipi_dphy_rx_inst3_RX_ULPS_ESC_LAN0,
  input mipi_dphy_rx_inst3_RX_ULPS_ESC_LAN1,
  input mipi_dphy_rx_inst3_RX_VALID_ESC,
  input mipi_dphy_rx_inst3_RX_VALID_HS_LAN0,
  input mipi_dphy_rx_inst3_RX_VALID_HS_LAN1,
  input mipi_dphy_rx_inst3_STOPSTATE_CLK,
  input mipi_dphy_rx_inst3_STOPSTATE_LAN0,
  input mipi_dphy_rx_inst3_STOPSTATE_LAN1,


`ifdef CSI_RX_4LANES
  input mipi_dphy_rx_inst3_ERR_CONTROL_LAN2,
  input mipi_dphy_rx_inst3_ERR_CONTROL_LAN3,
  input mipi_dphy_rx_inst3_ERR_ESC_LAN2,
  input mipi_dphy_rx_inst3_ERR_ESC_LAN3,
  input mipi_dphy_rx_inst3_ERR_SOT_HS_LAN2,
  input mipi_dphy_rx_inst3_ERR_SOT_HS_LAN3,
  input mipi_dphy_rx_inst3_ERR_SOT_SYNC_HS_LAN2,
  input mipi_dphy_rx_inst3_ERR_SOT_SYNC_HS_LAN3,
  input mipi_dphy_rx_inst3_RX_ACTIVE_HS_LAN2,
  input mipi_dphy_rx_inst3_RX_ACTIVE_HS_LAN3,
  input mipi_dphy_rx_inst3_ESC_LAN2_CLK,
  input mipi_dphy_rx_inst3_ESC_LAN3_CLK,
  input [CSI_RX_DATA_WIDTH_LANE-1:0] mipi_dphy_rx_inst3_RX_DATA_HS_LAN2,
  input [CSI_RX_DATA_WIDTH_LANE-1:0] mipi_dphy_rx_inst3_RX_DATA_HS_LAN3,
  input mipi_dphy_rx_inst3_RX_SKEW_CAL_HS_LAN2,
  input mipi_dphy_rx_inst3_RX_SKEW_CAL_HS_LAN3,
  input mipi_dphy_rx_inst3_RX_SYNC_HS_LAN2,
  input mipi_dphy_rx_inst3_RX_SYNC_HS_LAN3,
  input mipi_dphy_rx_inst3_RX_ULPS_ACTIVE_NOT_LAN2,
  input mipi_dphy_rx_inst3_RX_ULPS_ACTIVE_NOT_LAN3,
  input mipi_dphy_rx_inst3_RX_ULPS_ESC_LAN2,
  input mipi_dphy_rx_inst3_RX_ULPS_ESC_LAN3,
  input mipi_dphy_rx_inst3_RX_VALID_HS_LAN2,
  input mipi_dphy_rx_inst3_RX_VALID_HS_LAN3,
  input mipi_dphy_rx_inst3_STOPSTATE_LAN2,
  input mipi_dphy_rx_inst3_STOPSTATE_LAN3,
  `endif

 //MIPI DPHY RX1
  input  mipi_dphy_rx_inst4_WORD_CLKOUT_HS,
  
  output mipi_dphy_rx_inst4_FORCE_RX_MODE,
  output mipi_dphy_rx_inst4_RESET_N,
  output mipi_dphy_rx_inst4_RST0_N,
  
  input mipi_dphy_rx_inst4_ERR_CONTENTION_LP0,
  input mipi_dphy_rx_inst4_ERR_CONTENTION_LP1,
  input mipi_dphy_rx_inst4_ERR_CONTROL_LAN0,
  input mipi_dphy_rx_inst4_ERR_CONTROL_LAN1,
  input mipi_dphy_rx_inst4_ERR_ESC_LAN0,
  input mipi_dphy_rx_inst4_ERR_ESC_LAN1,
  input mipi_dphy_rx_inst4_ERR_SOT_HS_LAN0,
  input mipi_dphy_rx_inst4_ERR_SOT_HS_LAN1,
  input mipi_dphy_rx_inst4_ERR_SOT_SYNC_HS_LAN0,
  input mipi_dphy_rx_inst4_ERR_SOT_SYNC_HS_LAN1,
  input mipi_dphy_rx_inst4_LP_CLK,
  input mipi_dphy_rx_inst4_RX_ACTIVE_HS_LAN0,
  input mipi_dphy_rx_inst4_RX_ACTIVE_HS_LAN1,
  input mipi_dphy_rx_inst4_RX_CLK_ACTIVE_HS,
  input mipi_dphy_rx_inst4_ESC_LAN0_CLK,
  input mipi_dphy_rx_inst4_ESC_LAN1_CLK,
  input [7:0] mipi_dphy_rx_inst4_RX_DATA_ESC,
  input [CSI_RX_DATA_WIDTH_LANE-1:0] mipi_dphy_rx_inst4_RX_DATA_HS_LAN0,
  input [CSI_RX_DATA_WIDTH_LANE-1:0] mipi_dphy_rx_inst4_RX_DATA_HS_LAN1,
  input mipi_dphy_rx_inst4_RX_LPDT_ESC,
  input mipi_dphy_rx_inst4_RX_SKEW_CAL_HS_LAN0,
  input mipi_dphy_rx_inst4_RX_SKEW_CAL_HS_LAN1,
  input mipi_dphy_rx_inst4_RX_SYNC_HS_LAN0,
  input mipi_dphy_rx_inst4_RX_SYNC_HS_LAN1,
  input [3:0] mipi_dphy_rx_inst4_RX_TRIGGER_ESC,
  input mipi_dphy_rx_inst4_RX_ULPS_ACTIVE_CLK_NOT,
  input mipi_dphy_rx_inst4_RX_ULPS_ACTIVE_NOT_LAN0,
  input mipi_dphy_rx_inst4_RX_ULPS_ACTIVE_NOT_LAN1,
  input mipi_dphy_rx_inst4_RX_ULPS_CLK_NOT,
  input mipi_dphy_rx_inst4_RX_ULPS_ESC_LAN0,
  input mipi_dphy_rx_inst4_RX_ULPS_ESC_LAN1,
  input mipi_dphy_rx_inst4_RX_VALID_ESC,
  input mipi_dphy_rx_inst4_RX_VALID_HS_LAN0,
  input mipi_dphy_rx_inst4_RX_VALID_HS_LAN1,
  input mipi_dphy_rx_inst4_STOPSTATE_CLK,
  input mipi_dphy_rx_inst4_STOPSTATE_LAN0,
  input mipi_dphy_rx_inst4_STOPSTATE_LAN1,

`ifdef CSI_RX_4LANES
  input mipi_dphy_rx_inst4_ERR_CONTROL_LAN2,
  input mipi_dphy_rx_inst4_ERR_CONTROL_LAN3,
  input mipi_dphy_rx_inst4_ERR_ESC_LAN2,
  input mipi_dphy_rx_inst4_ERR_ESC_LAN3,
  input mipi_dphy_rx_inst4_ERR_SOT_HS_LAN2,
  input mipi_dphy_rx_inst4_ERR_SOT_HS_LAN3,
  input mipi_dphy_rx_inst4_ERR_SOT_SYNC_HS_LAN2,
  input mipi_dphy_rx_inst4_ERR_SOT_SYNC_HS_LAN3,
  input mipi_dphy_rx_inst4_RX_ACTIVE_HS_LAN2,
  input mipi_dphy_rx_inst4_RX_ACTIVE_HS_LAN3,
  input mipi_dphy_rx_inst4_ESC_LAN2_CLK,
  input mipi_dphy_rx_inst4_ESC_LAN3_CLK,
  input [CSI_RX_DATA_WIDTH_LANE-1:0] mipi_dphy_rx_inst4_RX_DATA_HS_LAN2,
  input [CSI_RX_DATA_WIDTH_LANE-1:0] mipi_dphy_rx_inst4_RX_DATA_HS_LAN3,
  input mipi_dphy_rx_inst4_RX_SKEW_CAL_HS_LAN2,
  input mipi_dphy_rx_inst4_RX_SKEW_CAL_HS_LAN3,
  input mipi_dphy_rx_inst4_RX_SYNC_HS_LAN2,
  input mipi_dphy_rx_inst4_RX_SYNC_HS_LAN3,
  input mipi_dphy_rx_inst4_RX_ULPS_ACTIVE_NOT_LAN2,
  input mipi_dphy_rx_inst4_RX_ULPS_ACTIVE_NOT_LAN3,
  input mipi_dphy_rx_inst4_RX_ULPS_ESC_LAN2,
  input mipi_dphy_rx_inst4_RX_ULPS_ESC_LAN3,
  input mipi_dphy_rx_inst4_RX_VALID_HS_LAN2,
  input mipi_dphy_rx_inst4_RX_VALID_HS_LAN3,
  input mipi_dphy_rx_inst4_STOPSTATE_LAN2,
  input mipi_dphy_rx_inst4_STOPSTATE_LAN3,
  `endif  
 

   //MIPI DPHY TX0  
//input mipi_dphy_tx_inst1_PLL_UNLOCK,
  input mipi_dphy_tx_inst1_STOPSTATE_CLK, //
  input mipi_dphy_tx_inst1_STOPSTATE_LAN0,//
  input mipi_dphy_tx_inst1_STOPSTATE_LAN1,//
//input mipi_dphy_tx_inst1_TX_READY_ESC,
  input mipi_dphy_tx_inst1_TX_READY_HS_LAN0,	//
  input mipi_dphy_tx_inst1_TX_READY_HS_LAN1,	//
  input mipi_dphy_tx_inst1_TX_ULPS_ACTIVE_CLK_NOT,	//
  input mipi_dphy_tx_inst1_TX_ULPS_ACTIVE_NOT_LAN0,	//
  input mipi_dphy_tx_inst1_TX_ULPS_ACTIVE_NOT_LAN1,	//
  input mipi_dphy_tx_inst1_SLOWCLK,					//
  
//  output mipi_dphy_tx_inst1_TX_CLK_ESC,
//output mipi_dphy_tx_inst1_PLL_SSC_EN,
  output mipi_dphy_tx_inst1_RESET_N,	//
//output [7:0] mipi_dphy_tx_inst1_TX_DATA_ESC,
  output [CSI_TX_DATA_WIDTH_LANE-1:0] mipi_dphy_tx_inst1_TX_DATA_HS_LAN0, //
  output [CSI_TX_DATA_WIDTH_LANE-1:0] mipi_dphy_tx_inst1_TX_DATA_HS_LAN1, //
//output mipi_dphy_tx_inst1_TX_LPDT_ESC,
  output mipi_dphy_tx_inst1_TX_REQUEST_ESC_LAN0,	//
  output mipi_dphy_tx_inst1_TX_REQUEST_ESC_LAN1,	//
  output mipi_dphy_tx_inst1_TX_REQUEST_HS,			//
  output mipi_dphy_tx_inst1_TX_REQUEST_HS_LAN0,		//
  output mipi_dphy_tx_inst1_TX_REQUEST_HS_LAN1,		//
  output mipi_dphy_tx_inst1_TX_SKEW_CAL_HS_LAN0,	//
  output mipi_dphy_tx_inst1_TX_SKEW_CAL_HS_LAN1,	//
//output [3:0] mipi_dphy_tx_inst1_TX_TRIGGER_ESC,
  output mipi_dphy_tx_inst1_TX_ULPS_CLK,	//
  output mipi_dphy_tx_inst1_TX_ULPS_ESC_LAN0,	//
  output mipi_dphy_tx_inst1_TX_ULPS_ESC_LAN1,	//
  output mipi_dphy_tx_inst1_TX_ULPS_EXIT,	//
  output mipi_dphy_tx_inst1_TX_ULPS_EXIT_LAN0,	//
  output mipi_dphy_tx_inst1_TX_ULPS_EXIT_LAN1,	//
//output mipi_dphy_tx_inst1_TX_VALID_ESC,
  output mipi_dphy_tx_inst1_TX_WORD_VALID_HS_LAN0, //
  output mipi_dphy_tx_inst1_TX_WORD_VALID_HS_LAN1, //
  
  
`ifdef CSI_TX_4LANES  
  input mipi_dphy_tx_inst1_STOPSTATE_LAN2,//
  input mipi_dphy_tx_inst1_STOPSTATE_LAN3,//
  input mipi_dphy_tx_inst1_TX_READY_HS_LAN2,	//
  input mipi_dphy_tx_inst1_TX_READY_HS_LAN3,	//
  input mipi_dphy_tx_inst1_TX_ULPS_ACTIVE_NOT_LAN2,	//
  input mipi_dphy_tx_inst1_TX_ULPS_ACTIVE_NOT_LAN3,	//
  output [CSI_TX_DATA_WIDTH_LANE-1:0] mipi_dphy_tx_inst1_TX_DATA_HS_LAN2, //
  output [CSI_TX_DATA_WIDTH_LANE-1:0] mipi_dphy_tx_inst1_TX_DATA_HS_LAN3, //
  output mipi_dphy_tx_inst1_TX_REQUEST_ESC_LAN2,	//
  output mipi_dphy_tx_inst1_TX_REQUEST_ESC_LAN3,	//
  output mipi_dphy_tx_inst1_TX_REQUEST_HS_LAN2,		//
  output mipi_dphy_tx_inst1_TX_REQUEST_HS_LAN3,		//
  output mipi_dphy_tx_inst1_TX_SKEW_CAL_HS_LAN2,	//
  output mipi_dphy_tx_inst1_TX_SKEW_CAL_HS_LAN3,	//
  output mipi_dphy_tx_inst1_TX_ULPS_ESC_LAN2,	//
  output mipi_dphy_tx_inst1_TX_ULPS_ESC_LAN3,	//
  output mipi_dphy_tx_inst1_TX_ULPS_EXIT_LAN2,	//
  output mipi_dphy_tx_inst1_TX_ULPS_EXIT_LAN3,	//
  output mipi_dphy_tx_inst1_TX_WORD_VALID_HS_LAN2, //
  output mipi_dphy_tx_inst1_TX_WORD_VALID_HS_LAN3, //
`endif  
  

    
    // YCbCr video output for HDMI
    
    input [0:0] i_hdmi_sda,
	output [0:0] o_hdmi_sda_oe,
	input [0:0] i_hdmi_scl,
	output [0:0] o_hdmi_scl_oe,
    
    output 			hdmi_yuv_vs,
    output 			hdmi_yuv_hs,
    output 			hdmi_yuv_de,
    output 			[15:0]	hdmi_yuv_data,
    
    
	  //SD Interface
    output  wire                    sd_clk_hi,
    input                           sd_cmd_i,
    output  wire                    sd_cmd_o,
    output  wire                    sd_cmd_oe,
    input           [3:0]           sd_dat_i,
    output  wire    [3:0]           sd_dat_o,
    output  wire    [3:0]           sd_dat_oe,


    
    output wire slv_sda_OE,
	output wire slv_sda_OUT,
	input       slv_sda_IN,	
	
    output wire slv_scl_OE,
	output wire slv_scl_OUT,
	input       slv_scl_IN,	

    
    
    
    
    //LED, SW
    output [5:0] o_led,
    input  [1:0] i_sw,
	
   // output check_rx_hs_clk,
   
  //  output check_tx_hs_clk,
  //  output check_rx_hs_clk,
    
   
  //  output check_rx_hsyn,
 //   output check_rx_vsyn,
 //   output check_tx_hsyn,
  //  output check_tx_vsyn,
 //   output check_hdmi_hsyn,
//    output check_hdmi_vsyn,
    
	//Debug Interface
    `ifdef SOFT_TAP_
    input  io_jtag_tms,    
    input  io_jtag_tdi,
    output io_jtag_tdo,
    input  io_jtag_tck
    
    `else 
    input  jtag_inst1_TCK,
    input  jtag_inst1_TDI,
    output jtag_inst1_TDO,
    input  jtag_inst1_SEL,
    input  jtag_inst1_CAPTURE,
    input  jtag_inst1_SHIFT,
    input  jtag_inst1_UPDATE,
    input  jtag_inst1_RESET
    `endif
    
   
		
  
	
  
	
);

`ifdef CSI_RX_4LANES
    localparam CSI_RX_NUM_DATA_LANE =4;
    localparam CSI_RX_DATA_WIDTH_LANE = `CSI_RX_LANE_DATAWIDTH;
`else
    localparam CSI_RX_NUM_DATA_LANE =2;
    localparam CSI_RX_DATA_WIDTH_LANE = `CSI_RX_LANE_DATAWIDTH;
`endif 

`ifdef CSI_TX_4LANES
    localparam CSI_TX_NUM_DATA_LANE =4;
    localparam CSI_TX_DATA_WIDTH_LANE = `CSI_TX_LANE_DATAWIDTH;
`else
    localparam CSI_TX_NUM_DATA_LANE =2;
    localparam CSI_TX_DATA_WIDTH_LANE = `CSI_TX_LANE_DATAWIDTH;
`endif 



// Mapping to DPHY RX0
wire rx_pclk_0; 
wire rx_reset_byte_HS_n_0;
wire resetb_rx_0;

wire                               	RxUlpsActiveClkNot_0;
wire                               	RxUlpsClkNot_0;
wire [CSI_RX_NUM_DATA_LANE-1:0]	    RxErrEsc_0;
wire [CSI_RX_NUM_DATA_LANE-1:0] 	    RxErrControl_0;
wire [CSI_RX_NUM_DATA_LANE-1:0] 	    RxErrSotSyncHS_0;
wire [CSI_RX_NUM_DATA_LANE-1:0]	    RxClkEsc_0;
wire [CSI_RX_NUM_DATA_LANE-1:0]	    RxUlpsEsc_0;
wire [CSI_RX_NUM_DATA_LANE-1:0]	    RxUlpsActiveNot_0;
wire [CSI_RX_NUM_DATA_LANE-1:0]	    RxSkewCalHS_0;
wire [CSI_RX_NUM_DATA_LANE-1:0]	    RxStopState_0;
wire [CSI_RX_NUM_DATA_LANE-1:0] 	    RxValidHS_0;
wire [CSI_RX_NUM_DATA_LANE-1:0]  	    RxSyncHS_0;
wire [CSI_RX_DATA_WIDTH_LANE-1:0]       RxDataHS_0 [CSI_RX_NUM_DATA_LANE-1:0]  ;

assign mipi_dphy_rx_inst1_RESET_N   = resetb_rx_0;
assign mipi_dphy_rx_inst1_RST0_N    = rx_reset_byte_HS_n_0;

//assign check_rx_hs_clk          = mipi_dphy_rx_inst1_WORD_CLKOUT_HS;
assign rx_pclk_0 				= mipi_dphy_rx_inst1_WORD_CLKOUT_HS;
assign RxUlpsClkNot_0 			= mipi_dphy_rx_inst1_RX_ULPS_CLK_NOT;
assign RxUlpsActiveClkNot_0 	= mipi_dphy_rx_inst1_RX_ULPS_ACTIVE_CLK_NOT;
assign RxErrEsc_0[0] 			= mipi_dphy_rx_inst1_ERR_ESC_LAN0;
assign RxErrEsc_0[1] 			= mipi_dphy_rx_inst1_ERR_ESC_LAN1;
assign RxErrControl_0[0] 		= mipi_dphy_rx_inst1_ERR_CONTROL_LAN0;
assign RxErrControl_0[1] 		= mipi_dphy_rx_inst1_ERR_CONTROL_LAN1;
assign RxErrSotSyncHS_0[0] 		= mipi_dphy_rx_inst1_ERR_SOT_SYNC_HS_LAN0;
assign RxErrSotSyncHS_0[1] 		= mipi_dphy_rx_inst1_ERR_SOT_SYNC_HS_LAN1;
assign RxUlpsEsc_0[0] 			= mipi_dphy_rx_inst1_RX_ULPS_ESC_LAN0;
assign RxUlpsEsc_0[1] 			= mipi_dphy_rx_inst1_RX_ULPS_ESC_LAN1;
assign RxClkEsc_0[0] 			= mipi_dphy_rx_inst1_ESC_LAN0_CLK;
assign RxClkEsc_0[1] 			= mipi_dphy_rx_inst1_ESC_LAN1_CLK;
assign RxUlpsActiveNot_0[0] 	= mipi_dphy_rx_inst1_RX_ULPS_ACTIVE_NOT_LAN0;
assign RxUlpsActiveNot_0[1] 	= mipi_dphy_rx_inst1_RX_ULPS_ACTIVE_NOT_LAN1;
assign RxSkewCalHS_0[0] 		= mipi_dphy_rx_inst1_RX_SKEW_CAL_HS_LAN0;
assign RxSkewCalHS_0[1] 		= mipi_dphy_rx_inst1_RX_SKEW_CAL_HS_LAN1;
assign RxStopState_0[0] 		= mipi_dphy_rx_inst1_STOPSTATE_LAN0;
assign RxStopState_0[1] 		= mipi_dphy_rx_inst1_STOPSTATE_LAN1;
assign RxValidHS_0[0] 			= mipi_dphy_rx_inst1_RX_VALID_HS_LAN0;
assign RxValidHS_0[1] 			= mipi_dphy_rx_inst1_RX_VALID_HS_LAN1;
assign RxSyncHS_0[0] 			= mipi_dphy_rx_inst1_RX_SYNC_HS_LAN0;
assign RxSyncHS_0[1] 			= mipi_dphy_rx_inst1_RX_SYNC_HS_LAN1;
assign RxDataHS_0[0] 			= mipi_dphy_rx_inst1_RX_DATA_HS_LAN0;
assign RxDataHS_0[1] 			= mipi_dphy_rx_inst1_RX_DATA_HS_LAN1;

`ifdef CSI_RX_4LANES  
assign RxErrEsc_0[2] 			= mipi_dphy_rx_inst1_ERR_ESC_LAN2;
assign RxErrEsc_0[3] 			= mipi_dphy_rx_inst1_ERR_ESC_LAN3;
assign RxErrControl_0[2] 		= mipi_dphy_rx_inst1_ERR_CONTROL_LAN2;
assign RxErrControl_0[3] 		= mipi_dphy_rx_inst1_ERR_CONTROL_LAN3;
assign RxErrSotSyncHS_0[2] 		= mipi_dphy_rx_inst1_ERR_SOT_SYNC_HS_LAN2;
assign RxErrSotSyncHS_0[3] 		= mipi_dphy_rx_inst1_ERR_SOT_SYNC_HS_LAN3;
assign RxUlpsEsc_0[2] 			= mipi_dphy_rx_inst1_RX_ULPS_ESC_LAN2;
assign RxUlpsEsc_0[3] 			= mipi_dphy_rx_inst1_RX_ULPS_ESC_LAN3;
assign RxClkEsc_0[2] 			= mipi_dphy_rx_inst1_ESC_LAN2_CLK;
assign RxClkEsc_0[3] 			= mipi_dphy_rx_inst1_ESC_LAN3_CLK;
assign RxUlpsActiveNot_0[2] 	= mipi_dphy_rx_inst1_RX_ULPS_ACTIVE_NOT_LAN2;
assign RxUlpsActiveNot_0[3] 	= mipi_dphy_rx_inst1_RX_ULPS_ACTIVE_NOT_LAN3;
assign RxSkewCalHS_0[2] 		= mipi_dphy_rx_inst1_RX_SKEW_CAL_HS_LAN2;
assign RxSkewCalHS_0[3] 		= mipi_dphy_rx_inst1_RX_SKEW_CAL_HS_LAN3;
assign RxStopState_0[2] 		= mipi_dphy_rx_inst1_STOPSTATE_LAN2;
assign RxStopState_0[3] 		= mipi_dphy_rx_inst1_STOPSTATE_LAN3;
assign RxValidHS_0[2] 			= mipi_dphy_rx_inst1_RX_VALID_HS_LAN2;
assign RxValidHS_0[3] 			= mipi_dphy_rx_inst1_RX_VALID_HS_LAN3;
assign RxSyncHS_0[2] 			= mipi_dphy_rx_inst1_RX_SYNC_HS_LAN2;
assign RxSyncHS_0[3] 			= mipi_dphy_rx_inst1_RX_SYNC_HS_LAN3;
assign RxDataHS_0[2] 			= mipi_dphy_rx_inst1_RX_DATA_HS_LAN2;
assign RxDataHS_0[3] 			= mipi_dphy_rx_inst1_RX_DATA_HS_LAN3;
`endif 

// Mapping to DPHY RX1
wire rx_pclk_1; 
wire rx_reset_byte_HS_n_1;
wire resetb_rx_1;

wire                                RxUlpsActiveClkNot_1;
wire                                RxUlpsClkNot_1;
wire [CSI_RX_NUM_DATA_LANE-1:0]	    RxErrEsc_1;
wire [CSI_RX_NUM_DATA_LANE-1:0] 	    RxErrControl_1;
wire [CSI_RX_NUM_DATA_LANE-1:0] 	    RxErrSotSyncHS_1;
wire [CSI_RX_NUM_DATA_LANE-1:0]	    RxClkEsc_1;
wire [CSI_RX_NUM_DATA_LANE-1:0]	    RxUlpsEsc_1;
wire [CSI_RX_NUM_DATA_LANE-1:0]	    RxUlpsActiveNot_1;
wire [CSI_RX_NUM_DATA_LANE-1:0]	    RxSkewCalHS_1;
wire [CSI_RX_NUM_DATA_LANE-1:0]	    RxStopState_1;
wire [CSI_RX_NUM_DATA_LANE-1:0] 	    RxValidHS_1;
wire [CSI_RX_NUM_DATA_LANE-1:0]  	    RxSyncHS_1;
wire [CSI_RX_DATA_WIDTH_LANE-1:0]      RxDataHS_1  [CSI_RX_NUM_DATA_LANE-1:0]  ;

assign mipi_dphy_rx_inst2_RESET_N   = resetb_rx_1;
assign mipi_dphy_rx_inst2_RST0_N    = rx_reset_byte_HS_n_1;

assign rx_pclk_1 				= mipi_dphy_rx_inst2_WORD_CLKOUT_HS;
assign RxUlpsClkNot_1 			= mipi_dphy_rx_inst2_RX_ULPS_CLK_NOT;
assign RxUlpsActiveClkNot_1	 	= mipi_dphy_rx_inst2_RX_ULPS_ACTIVE_CLK_NOT;
assign RxErrEsc_1[0] 			= mipi_dphy_rx_inst2_ERR_ESC_LAN0;
assign RxErrEsc_1[1]			= mipi_dphy_rx_inst2_ERR_ESC_LAN1;
assign RxErrControl_1[0] 		= mipi_dphy_rx_inst2_ERR_CONTROL_LAN0;
assign RxErrControl_1[1] 		= mipi_dphy_rx_inst2_ERR_CONTROL_LAN1;
assign RxErrSotSyncHS_1[0] 		= mipi_dphy_rx_inst2_ERR_SOT_SYNC_HS_LAN0;
assign RxErrSotSyncHS_1[1] 		= mipi_dphy_rx_inst2_ERR_SOT_SYNC_HS_LAN1;
assign RxUlpsEsc_1[0] 			= mipi_dphy_rx_inst2_RX_ULPS_ESC_LAN0;
assign RxUlpsEsc_1[1] 			= mipi_dphy_rx_inst2_RX_ULPS_ESC_LAN1;
assign RxClkEsc_1[0] 			= mipi_dphy_rx_inst2_ESC_LAN0_CLK;
assign RxClkEsc_1[1] 			= mipi_dphy_rx_inst2_ESC_LAN1_CLK;
assign RxUlpsActiveNot_1[0] 	= mipi_dphy_rx_inst2_RX_ULPS_ACTIVE_NOT_LAN0;
assign RxUlpsActiveNot_1[1] 	= mipi_dphy_rx_inst2_RX_ULPS_ACTIVE_NOT_LAN1;
assign RxSkewCalHS_1[0] 		= mipi_dphy_rx_inst2_RX_SKEW_CAL_HS_LAN0;
assign RxSkewCalHS_1[1] 		= mipi_dphy_rx_inst2_RX_SKEW_CAL_HS_LAN1;
assign RxStopState_1[0] 		= mipi_dphy_rx_inst2_STOPSTATE_LAN0;
assign RxStopState_1[1] 		= mipi_dphy_rx_inst2_STOPSTATE_LAN1;
assign RxValidHS_1[0] 			= mipi_dphy_rx_inst2_RX_VALID_HS_LAN0;
assign RxValidHS_1[1] 			= mipi_dphy_rx_inst2_RX_VALID_HS_LAN1;
assign RxSyncHS_1[0] 			= mipi_dphy_rx_inst2_RX_SYNC_HS_LAN0;
assign RxSyncHS_1[1] 			= mipi_dphy_rx_inst2_RX_SYNC_HS_LAN1;
assign RxDataHS_1[0] 			= mipi_dphy_rx_inst2_RX_DATA_HS_LAN0;
assign RxDataHS_1[1] 			= mipi_dphy_rx_inst2_RX_DATA_HS_LAN1;

`ifdef CSI_RX_4LANES  
assign RxErrEsc_1[2] 			= mipi_dphy_rx_inst2_ERR_ESC_LAN2;
assign RxErrEsc_1[3]			= mipi_dphy_rx_inst2_ERR_ESC_LAN3;
assign RxErrControl_1[2] 		= mipi_dphy_rx_inst2_ERR_CONTROL_LAN2;
assign RxErrControl_1[3] 		= mipi_dphy_rx_inst2_ERR_CONTROL_LAN3;
assign RxErrSotSyncHS_1[2] 		= mipi_dphy_rx_inst2_ERR_SOT_SYNC_HS_LAN2;
assign RxErrSotSyncHS_1[3] 		= mipi_dphy_rx_inst2_ERR_SOT_SYNC_HS_LAN3;
assign RxUlpsEsc_1[2] 			= mipi_dphy_rx_inst2_RX_ULPS_ESC_LAN2;
assign RxUlpsEsc_1[3] 			= mipi_dphy_rx_inst2_RX_ULPS_ESC_LAN3;
assign RxClkEsc_1[2] 			= mipi_dphy_rx_inst2_ESC_LAN2_CLK;
assign RxClkEsc_1[3] 			= mipi_dphy_rx_inst2_ESC_LAN3_CLK;
assign RxUlpsActiveNot_1[2] 	= mipi_dphy_rx_inst2_RX_ULPS_ACTIVE_NOT_LAN2;
assign RxUlpsActiveNot_1[3] 	= mipi_dphy_rx_inst2_RX_ULPS_ACTIVE_NOT_LAN3;
assign RxSkewCalHS_1[2] 		= mipi_dphy_rx_inst2_RX_SKEW_CAL_HS_LAN2;
assign RxSkewCalHS_1[3] 		= mipi_dphy_rx_inst2_RX_SKEW_CAL_HS_LAN3;
assign RxStopState_1[2] 		= mipi_dphy_rx_inst2_STOPSTATE_LAN2;
assign RxStopState_1[3] 		= mipi_dphy_rx_inst2_STOPSTATE_LAN3;
assign RxValidHS_1[2] 			= mipi_dphy_rx_inst2_RX_VALID_HS_LAN2;
assign RxValidHS_1[3] 			= mipi_dphy_rx_inst2_RX_VALID_HS_LAN3;
assign RxSyncHS_1[2] 			= mipi_dphy_rx_inst2_RX_SYNC_HS_LAN2;
assign RxSyncHS_1[3] 			= mipi_dphy_rx_inst2_RX_SYNC_HS_LAN3;
assign RxDataHS_1[2] 			= mipi_dphy_rx_inst2_RX_DATA_HS_LAN2;
assign RxDataHS_1[3] 			= mipi_dphy_rx_inst2_RX_DATA_HS_LAN3;
`endif

// Mapping to DPHY RX2
wire rx_pclk_2; 
wire rx_reset_byte_HS_n_2;
wire resetb_rx_2;

wire                                RxUlpsActiveClkNot_2;
wire                                RxUlpsClkNot_2;
wire [CSI_RX_NUM_DATA_LANE-1:0]	    RxErrEsc_2;
wire [CSI_RX_NUM_DATA_LANE-1:0] 	    RxErrControl_2;
wire [CSI_RX_NUM_DATA_LANE-1:0] 	    RxErrSotSyncHS_2;
wire [CSI_RX_NUM_DATA_LANE-1:0]	    RxClkEsc_2;
wire [CSI_RX_NUM_DATA_LANE-1:0]	    RxUlpsEsc_2;
wire [CSI_RX_NUM_DATA_LANE-1:0]	    RxUlpsActiveNot_2;
wire [CSI_RX_NUM_DATA_LANE-1:0]	    RxSkewCalHS_2;
wire [CSI_RX_NUM_DATA_LANE-1:0]	    RxStopState_2;
wire [CSI_RX_NUM_DATA_LANE-1:0] 	    RxValidHS_2;
wire [CSI_RX_NUM_DATA_LANE-1:0]  	    RxSyncHS_2;
wire [CSI_RX_DATA_WIDTH_LANE-1:0]      RxDataHS_2[CSI_RX_NUM_DATA_LANE-1:0];

assign mipi_dphy_rx_inst3_RESET_N   = resetb_rx_2;
assign mipi_dphy_rx_inst3_RST0_N    = rx_reset_byte_HS_n_2;

assign rx_pclk_2 				= mipi_dphy_rx_inst3_WORD_CLKOUT_HS;
assign RxUlpsClkNot_2 			= mipi_dphy_rx_inst3_RX_ULPS_CLK_NOT;
assign RxUlpsActiveClkNot_2 	= mipi_dphy_rx_inst3_RX_ULPS_ACTIVE_CLK_NOT;
assign RxErrEsc_2[0] 			= mipi_dphy_rx_inst3_ERR_ESC_LAN0;
assign RxErrEsc_2[1] 			= mipi_dphy_rx_inst3_ERR_ESC_LAN1;
assign RxErrControl_2[0] 		= mipi_dphy_rx_inst3_ERR_CONTROL_LAN0;
assign RxErrControl_2[1] 		= mipi_dphy_rx_inst3_ERR_CONTROL_LAN1;
assign RxErrSotSyncHS_2[0] 		= mipi_dphy_rx_inst3_ERR_SOT_SYNC_HS_LAN0;
assign RxErrSotSyncHS_2[1] 		= mipi_dphy_rx_inst3_ERR_SOT_SYNC_HS_LAN1;
assign RxUlpsEsc_2[0] 			= mipi_dphy_rx_inst3_RX_ULPS_ESC_LAN0;
assign RxUlpsEsc_2[1] 			= mipi_dphy_rx_inst3_RX_ULPS_ESC_LAN1;
assign RxClkEsc_2[0] 			= mipi_dphy_rx_inst3_ESC_LAN0_CLK;
assign RxClkEsc_2[1] 			= mipi_dphy_rx_inst3_ESC_LAN1_CLK;
assign RxUlpsActiveNot_2[0] 	= mipi_dphy_rx_inst3_RX_ULPS_ACTIVE_NOT_LAN0;
assign RxUlpsActiveNot_2[1] 	= mipi_dphy_rx_inst3_RX_ULPS_ACTIVE_NOT_LAN1;
assign RxSkewCalHS_2[0] 		= mipi_dphy_rx_inst3_RX_SKEW_CAL_HS_LAN0;
assign RxSkewCalHS_2[1] 		= mipi_dphy_rx_inst3_RX_SKEW_CAL_HS_LAN1;
assign RxStopState_2[0] 		= mipi_dphy_rx_inst3_STOPSTATE_LAN0;
assign RxStopState_2[1] 		= mipi_dphy_rx_inst3_STOPSTATE_LAN1;
assign RxValidHS_2[0] 			= mipi_dphy_rx_inst3_RX_VALID_HS_LAN0;
assign RxValidHS_2[1] 			= mipi_dphy_rx_inst3_RX_VALID_HS_LAN1;
assign RxSyncHS_2[0] 			= mipi_dphy_rx_inst3_RX_SYNC_HS_LAN0;
assign RxSyncHS_2[1] 			= mipi_dphy_rx_inst3_RX_SYNC_HS_LAN1;
assign RxDataHS_2[0] 			= mipi_dphy_rx_inst3_RX_DATA_HS_LAN0;
assign RxDataHS_2[1] 			= mipi_dphy_rx_inst3_RX_DATA_HS_LAN1;

`ifdef CSI_RX_4LANES 
assign RxErrEsc_2[2] 			= mipi_dphy_rx_inst3_ERR_ESC_LAN2;
assign RxErrEsc_2[3] 			= mipi_dphy_rx_inst3_ERR_ESC_LAN3;
assign RxErrControl_2[2] 		= mipi_dphy_rx_inst3_ERR_CONTROL_LAN2;
assign RxErrControl_2[3] 		= mipi_dphy_rx_inst3_ERR_CONTROL_LAN3;
assign RxErrSotSyncHS_2[2] 		= mipi_dphy_rx_inst3_ERR_SOT_SYNC_HS_LAN2;
assign RxErrSotSyncHS_2[3] 		= mipi_dphy_rx_inst3_ERR_SOT_SYNC_HS_LAN3;
assign RxUlpsEsc_2[2] 			= mipi_dphy_rx_inst3_RX_ULPS_ESC_LAN2;
assign RxUlpsEsc_2[3] 			= mipi_dphy_rx_inst3_RX_ULPS_ESC_LAN3;
assign RxClkEsc_2[2] 			= mipi_dphy_rx_inst3_ESC_LAN2_CLK;
assign RxClkEsc_2[3] 			= mipi_dphy_rx_inst3_ESC_LAN3_CLK;
assign RxUlpsActiveNot_2[2]  	= mipi_dphy_rx_inst3_RX_ULPS_ACTIVE_NOT_LAN2;
assign RxUlpsActiveNot_2[3]  	= mipi_dphy_rx_inst3_RX_ULPS_ACTIVE_NOT_LAN3;
assign RxSkewCalHS_2[2] 		= mipi_dphy_rx_inst3_RX_SKEW_CAL_HS_LAN2;
assign RxSkewCalHS_2[3] 		= mipi_dphy_rx_inst3_RX_SKEW_CAL_HS_LAN3;
assign RxStopState_2[2] 		= mipi_dphy_rx_inst3_STOPSTATE_LAN2;
assign RxStopState_2[3] 		= mipi_dphy_rx_inst3_STOPSTATE_LAN3;
assign RxValidHS_2[2] 			= mipi_dphy_rx_inst3_RX_VALID_HS_LAN2;
assign RxValidHS_2[3] 			= mipi_dphy_rx_inst3_RX_VALID_HS_LAN3;
assign RxSyncHS_2[2] 			= mipi_dphy_rx_inst3_RX_SYNC_HS_LAN2;
assign RxSyncHS_2[3] 			= mipi_dphy_rx_inst3_RX_SYNC_HS_LAN3;
assign RxDataHS_2[2] 			= mipi_dphy_rx_inst3_RX_DATA_HS_LAN2;
assign RxDataHS_2[3] 			= mipi_dphy_rx_inst3_RX_DATA_HS_LAN3;
`endif

// Mapping to DPHY RX3
wire rx_pclk_3; 
wire rx_reset_byte_HS_n_3;
wire resetb_rx_3;

wire                                RxUlpsActiveClkNot_3;
wire                                RxUlpsClkNot_3;
wire [CSI_RX_NUM_DATA_LANE-1:0]	    RxErrEsc_3;
wire [CSI_RX_NUM_DATA_LANE-1:0] 	    RxErrControl_3;
wire [CSI_RX_NUM_DATA_LANE-1:0] 	    RxErrSotSyncHS_3;
wire [CSI_RX_NUM_DATA_LANE-1:0]	    RxClkEsc_3;
wire [CSI_RX_NUM_DATA_LANE-1:0]	    RxUlpsEsc_3;
wire [CSI_RX_NUM_DATA_LANE-1:0]	    RxUlpsActiveNot_3;
wire [CSI_RX_NUM_DATA_LANE-1:0]	    RxSkewCalHS_3;
wire [CSI_RX_NUM_DATA_LANE-1:0]	    RxStopState_3;
wire [CSI_RX_NUM_DATA_LANE-1:0] 	    RxValidHS_3;
wire [CSI_RX_NUM_DATA_LANE-1:0]  	    RxSyncHS_3;
wire [CSI_RX_DATA_WIDTH_LANE-1:0]      RxDataHS_3 [CSI_RX_NUM_DATA_LANE-1:0];

assign mipi_dphy_rx_inst4_RESET_N   = resetb_rx_3;
assign mipi_dphy_rx_inst4_RST0_N    = rx_reset_byte_HS_n_3;

assign rx_pclk_3 				= mipi_dphy_rx_inst4_WORD_CLKOUT_HS;
assign RxUlpsClkNot_3 			= mipi_dphy_rx_inst4_RX_ULPS_CLK_NOT;
assign RxUlpsActiveClkNot_3 	= mipi_dphy_rx_inst4_RX_ULPS_ACTIVE_CLK_NOT;
assign RxErrEsc_3[0] 			= mipi_dphy_rx_inst4_ERR_ESC_LAN0;
assign RxErrEsc_3[1] 			= mipi_dphy_rx_inst4_ERR_ESC_LAN1;
assign RxErrControl_3[0] 		= mipi_dphy_rx_inst4_ERR_CONTROL_LAN0;
assign RxErrControl_3[1] 		= mipi_dphy_rx_inst4_ERR_CONTROL_LAN1;
assign RxErrSotSyncHS_3[0] 		= mipi_dphy_rx_inst4_ERR_SOT_SYNC_HS_LAN0;
assign RxErrSotSyncHS_3[1] 		= mipi_dphy_rx_inst4_ERR_SOT_SYNC_HS_LAN1;
assign RxUlpsEsc_3[0] 			= mipi_dphy_rx_inst4_RX_ULPS_ESC_LAN0;
assign RxUlpsEsc_3[1] 			= mipi_dphy_rx_inst4_RX_ULPS_ESC_LAN1;
assign RxClkEsc_3[0] 			= mipi_dphy_rx_inst4_ESC_LAN0_CLK;
assign RxClkEsc_3[1] 			= mipi_dphy_rx_inst4_ESC_LAN1_CLK;
assign RxUlpsActiveNot_3[0] 	= mipi_dphy_rx_inst4_RX_ULPS_ACTIVE_NOT_LAN0;
assign RxUlpsActiveNot_3[1] 	= mipi_dphy_rx_inst4_RX_ULPS_ACTIVE_NOT_LAN1;
assign RxSkewCalHS_3[0] 		= mipi_dphy_rx_inst4_RX_SKEW_CAL_HS_LAN0;
assign RxSkewCalHS_3[1] 		= mipi_dphy_rx_inst4_RX_SKEW_CAL_HS_LAN1;
assign RxStopState_3[0] 		= mipi_dphy_rx_inst4_STOPSTATE_LAN0;
assign RxStopState_3[1] 		= mipi_dphy_rx_inst4_STOPSTATE_LAN1;
assign RxValidHS_3[0] 			= mipi_dphy_rx_inst4_RX_VALID_HS_LAN0;
assign RxValidHS_3[1] 			= mipi_dphy_rx_inst4_RX_VALID_HS_LAN1;
assign RxSyncHS_3[0] 			= mipi_dphy_rx_inst4_RX_SYNC_HS_LAN0;
assign RxSyncHS_3[1] 			= mipi_dphy_rx_inst4_RX_SYNC_HS_LAN1;
assign RxDataHS_3[0] 			= mipi_dphy_rx_inst4_RX_DATA_HS_LAN0;
assign RxDataHS_3[1] 			= mipi_dphy_rx_inst4_RX_DATA_HS_LAN1;

`ifdef CSI_RX_4LANES 
assign RxErrEsc_3[2] 			= mipi_dphy_rx_inst4_ERR_ESC_LAN2;
assign RxErrEsc_3[3] 			= mipi_dphy_rx_inst4_ERR_ESC_LAN3;
assign RxErrControl_3[2] 		= mipi_dphy_rx_inst4_ERR_CONTROL_LAN2;
assign RxErrControl_3[3] 		= mipi_dphy_rx_inst4_ERR_CONTROL_LAN3;
assign RxErrSotSyncHS_3[2] 		= mipi_dphy_rx_inst4_ERR_SOT_SYNC_HS_LAN2;
assign RxErrSotSyncHS_3[3] 		= mipi_dphy_rx_inst4_ERR_SOT_SYNC_HS_LAN3;
assign RxUlpsEsc_3[2] 			= mipi_dphy_rx_inst4_RX_ULPS_ESC_LAN2;
assign RxUlpsEsc_3[3] 			= mipi_dphy_rx_inst4_RX_ULPS_ESC_LAN3;
assign RxClkEsc_3[2] 			= mipi_dphy_rx_inst4_ESC_LAN2_CLK;
assign RxClkEsc_3[3] 			= mipi_dphy_rx_inst4_ESC_LAN3_CLK;
assign RxUlpsActiveNot_3[2]  	= mipi_dphy_rx_inst4_RX_ULPS_ACTIVE_NOT_LAN2;
assign RxUlpsActiveNot_3[3]  	= mipi_dphy_rx_inst4_RX_ULPS_ACTIVE_NOT_LAN3;
assign RxSkewCalHS_3[2] 		= mipi_dphy_rx_inst4_RX_SKEW_CAL_HS_LAN2;
assign RxSkewCalHS_3[3] 		= mipi_dphy_rx_inst4_RX_SKEW_CAL_HS_LAN3;
assign RxStopState_3[2] 		= mipi_dphy_rx_inst4_STOPSTATE_LAN2;
assign RxStopState_3[3] 		= mipi_dphy_rx_inst4_STOPSTATE_LAN3;
assign RxValidHS_3[2] 			= mipi_dphy_rx_inst4_RX_VALID_HS_LAN2;
assign RxValidHS_3[3] 			= mipi_dphy_rx_inst4_RX_VALID_HS_LAN3;
assign RxSyncHS_3[2] 			= mipi_dphy_rx_inst4_RX_SYNC_HS_LAN2;
assign RxSyncHS_3[3] 			= mipi_dphy_rx_inst4_RX_SYNC_HS_LAN3;
assign RxDataHS_3[2] 			= mipi_dphy_rx_inst4_RX_DATA_HS_LAN2;
assign RxDataHS_3[3] 			= mipi_dphy_rx_inst4_RX_DATA_HS_LAN3;
`endif

// Mapping to DPHY TX 0 
//CSI TX Interface
wire tx_pclk_0;//
wire resetb_tx_0;  //
wire TxUlpsClk_0;	//
wire TxUlpsExitClk_0; //
wire [CSI_TX_NUM_DATA_LANE-1:0] TxUlpsEsc_0;	//
wire [CSI_TX_NUM_DATA_LANE-1:0] TxUlpsExit_0;	//
wire [CSI_TX_NUM_DATA_LANE-1:0] TxRequestEsc_0;	//
wire [CSI_TX_NUM_DATA_LANE-1:0] TxSkewCalHS_0;		//
wire [CSI_TX_NUM_DATA_LANE-1:0] TxRequestHS_0;		//
wire TxRequestHSc_0;	//
wire [CSI_TX_DATA_WIDTH_LANE-1:0] TxDataHS0_0; //
wire [CSI_TX_DATA_WIDTH_LANE-1:0] TxDataHS1_0; //
wire [CSI_TX_DATA_WIDTH_LANE-1:0] TxDataHS2_0; //
wire [CSI_TX_DATA_WIDTH_LANE-1:0] TxDataHS3_0; //
wire [1:0] TxReqValidHS0_0;//
wire [1:0] TxReqValidHS1_0;// 
wire [1:0] TxReqValidHS2_0;// 
wire [1:0] TxReqValidHS3_0;//
wire TxUlpsActiveClkNot_0;	//
wire [CSI_TX_NUM_DATA_LANE-1:0] TxStopStateD_0;//
wire TxStopStateC_0;	//
wire [CSI_TX_NUM_DATA_LANE-1:0] TxUlpsActiveNot_0; //
wire [CSI_TX_NUM_DATA_LANE-1:0] TxReadyHS_0;	//

//assign mipi_dphy_tx_inst1_TX_CLK_ESC = tx_escclk; 

//assign check_tx_hs_clk          = mipi_dphy_tx_inst1_SLOWCLK;
assign tx_pclk_0 = mipi_dphy_tx_inst1_SLOWCLK;
assign mipi_dphy_tx_inst1_RESET_N =  resetb_tx_0;
assign mipi_dphy_tx_inst1_TX_ULPS_CLK  = TxUlpsClk_0;
assign mipi_dphy_tx_inst1_TX_ULPS_EXIT = TxUlpsExitClk_0;
assign mipi_dphy_tx_inst1_TX_ULPS_EXIT_LAN0 = TxUlpsExit_0[0];
assign mipi_dphy_tx_inst1_TX_ULPS_EXIT_LAN1 = TxUlpsExit_0[1];
assign TxUlpsActiveClkNot_0 = mipi_dphy_tx_inst1_TX_ULPS_ACTIVE_CLK_NOT;
assign mipi_dphy_tx_inst1_TX_ULPS_ESC_LAN0 = TxUlpsEsc_0[0];
assign mipi_dphy_tx_inst1_TX_ULPS_ESC_LAN1 = TxUlpsEsc_0[1];
assign mipi_dphy_tx_inst1_TX_REQUEST_ESC_LAN0 = TxRequestEsc_0[0];
assign mipi_dphy_tx_inst1_TX_REQUEST_ESC_LAN1 = TxRequestEsc_0[1];
assign mipi_dphy_tx_inst1_TX_SKEW_CAL_HS_LAN0 = TxSkewCalHS_0[0];
assign mipi_dphy_tx_inst1_TX_SKEW_CAL_HS_LAN1 = TxSkewCalHS_0[1];
assign TxStopStateD_0[0] = mipi_dphy_tx_inst1_STOPSTATE_LAN0;
assign TxStopStateD_0[1] = mipi_dphy_tx_inst1_STOPSTATE_LAN1;
assign TxStopStateC_0 = mipi_dphy_tx_inst1_STOPSTATE_CLK;
assign TxUlpsActiveNot_0[0] = mipi_dphy_tx_inst1_TX_ULPS_ACTIVE_NOT_LAN0;
assign TxUlpsActiveNot_0[1] = mipi_dphy_tx_inst1_TX_ULPS_ACTIVE_NOT_LAN1;
assign TxReadyHS_0[0] = mipi_dphy_tx_inst1_TX_READY_HS_LAN0;
assign TxReadyHS_0[1] = mipi_dphy_tx_inst1_TX_READY_HS_LAN1;
assign mipi_dphy_tx_inst1_TX_REQUEST_HS_LAN0 = TxRequestHS_0[0];
assign mipi_dphy_tx_inst1_TX_REQUEST_HS_LAN1 = TxRequestHS_0[1];
assign mipi_dphy_tx_inst1_TX_REQUEST_HS = TxRequestHSc_0;
assign mipi_dphy_tx_inst1_TX_DATA_HS_LAN0 = TxDataHS0_0;
assign mipi_dphy_tx_inst1_TX_DATA_HS_LAN1 = TxDataHS1_0;
assign mipi_dphy_tx_inst1_TX_WORD_VALID_HS_LAN0 = TxReqValidHS0_0[1];
assign mipi_dphy_tx_inst1_TX_WORD_VALID_HS_LAN1 = TxReqValidHS1_0[1];

`ifdef CSI_TX_4LANES 
assign mipi_dphy_tx_inst1_TX_ULPS_EXIT_LAN2 = TxUlpsExit_0[2];
assign mipi_dphy_tx_inst1_TX_ULPS_EXIT_LAN3 = TxUlpsExit_0[3];
assign mipi_dphy_tx_inst1_TX_ULPS_ESC_LAN2 = TxUlpsEsc_0[2];
assign mipi_dphy_tx_inst1_TX_ULPS_ESC_LAN3 = TxUlpsEsc_0[3];
assign mipi_dphy_tx_inst1_TX_REQUEST_ESC_LAN2 = TxRequestEsc_0[2];
assign mipi_dphy_tx_inst1_TX_REQUEST_ESC_LAN3 = TxRequestEsc_0[3];
assign mipi_dphy_tx_inst1_TX_SKEW_CAL_HS_LAN2 = TxSkewCalHS_0[2];
assign mipi_dphy_tx_inst1_TX_SKEW_CAL_HS_LAN3 = TxSkewCalHS_0[3];
assign TxStopStateD_0[2] = mipi_dphy_tx_inst1_STOPSTATE_LAN2;
assign TxStopStateD_0[3] = mipi_dphy_tx_inst1_STOPSTATE_LAN3;
assign TxUlpsActiveNot_0[2] = mipi_dphy_tx_inst1_TX_ULPS_ACTIVE_NOT_LAN2;
assign TxUlpsActiveNot_0[3] = mipi_dphy_tx_inst1_TX_ULPS_ACTIVE_NOT_LAN3;
assign TxReadyHS_0[2] = mipi_dphy_tx_inst1_TX_READY_HS_LAN2;
assign TxReadyHS_0[3] = mipi_dphy_tx_inst1_TX_READY_HS_LAN3;
assign mipi_dphy_tx_inst1_TX_REQUEST_HS_LAN2 = TxRequestHS_0[2];
assign mipi_dphy_tx_inst1_TX_REQUEST_HS_LAN3 = TxRequestHS_0[3];
assign mipi_dphy_tx_inst1_TX_DATA_HS_LAN2 = TxDataHS2_0;
assign mipi_dphy_tx_inst1_TX_DATA_HS_LAN3 = TxDataHS3_0;
assign mipi_dphy_tx_inst1_TX_WORD_VALID_HS_LAN2 = TxReqValidHS2_0[1];
assign mipi_dphy_tx_inst1_TX_WORD_VALID_HS_LAN3 = TxReqValidHS3_0[1];
`endif





//CSI Camera Interface
wire  [NUM_CAM-1:0] w_cam_i2c_sda_write;
wire  [NUM_CAM-1:0] w_cam_i2c_sda_read;
wire  [NUM_CAM-1:0] w_cam_i2c_scl_write;
wire  [NUM_CAM-1:0] w_cam_i2c_scl_read;

`ifdef HARD_I2C_CONFIG
assign w_cam_i2c_sda_read = i_cam_sda;
assign o_cam_sda_oe       = w_cam_i2c_sda_write; 
assign w_cam_i2c_scl_read = i_cam_scl;
assign o_cam_scl_oe 	  = w_cam_i2c_scl_write; 
`else
assign w_cam_i2c_sda_read = i_cam_sda;
assign o_cam_sda_oe       = ~w_cam_i2c_sda_write; 
assign w_cam_i2c_scl_read = i_cam_scl;
assign o_cam_scl_oe 	  = ~w_cam_i2c_scl_write; 
`endif

// CSI controllers ouptut interface port


localparam   CAM_PIXEL_RX_DATAWIDTH = 10;	//RAW10, RAW12
localparam   CAM_PIXEL_RX_MEM_DATAWIDTH = 8;
localparam   CSI_PIXEL_TX_DATAWIDTH = 10;	//RAW10, RAW12
localparam   CSI_PIXEL_TX_MEM_DATAWIDTH = 8;
localparam   VIDEO_MEM_DATAWIDTH = 8;

wire [NUM_CAM*8-1:0] w_rx_virtual_ch;    
wire [NUM_CAM-1  :0] w_rx_out_de;
wire [NUM_CAM-1  :0] w_rx_out_vs;
wire [NUM_CAM-1  :0] w_rx_out_hs;
wire [NUM_CAM*CAM_PIXEL_RX_MEM_DATAWIDTH-1:0] w_rx_out_data_00;
wire [NUM_CAM*CAM_PIXEL_RX_MEM_DATAWIDTH-1:0] w_rx_out_data_01;
wire [NUM_CAM*CAM_PIXEL_RX_MEM_DATAWIDTH-1:0] w_rx_out_data_10;
wire [NUM_CAM*CAM_PIXEL_RX_MEM_DATAWIDTH-1:0] w_rx_out_data_11;
    

//CSI TX Stream Output
wire [NUM_CSI_TX-1:0] w_out_csi_tx_de;
wire [NUM_CSI_TX-1:0] w_out_csi_tx_valid;
wire [NUM_CSI_TX-1:0] w_out_csi_tx_hsync0;
wire [NUM_CSI_TX-1:0] w_out_csi_tx_vsync0;

wire [NUM_CSI_TX-1:0] w_out_csi_tx_hsync1;
wire [NUM_CSI_TX-1:0] w_out_csi_tx_vsync1;

wire [NUM_CSI_TX-1:0] w_out_csi_tx_hsync2;
wire [NUM_CSI_TX-1:0] w_out_csi_tx_vsync2;

wire [NUM_CSI_TX-1:0] w_out_csi_tx_hsync3;
wire [NUM_CSI_TX-1:0] w_out_csi_tx_vsync3;


wire [NUM_CSI_TX*CSI_PIXEL_TX_MEM_DATAWIDTH-1:0] w_out_csi_tx_rd_00;
wire [NUM_CSI_TX*CSI_PIXEL_TX_MEM_DATAWIDTH-1:0] w_out_csi_tx_rd_01;
wire [NUM_CSI_TX*CSI_PIXEL_TX_MEM_DATAWIDTH-1:0] w_out_csi_tx_rd_10;
wire [NUM_CSI_TX*CSI_PIXEL_TX_MEM_DATAWIDTH-1:0] w_out_csi_tx_rd_11;
	
	
	//Video Stream Output
wire [NUM_VIDEO_OUT-1:0] w_out_video_de;
wire [NUM_VIDEO_OUT-1:0] w_out_video_valid;
wire [NUM_VIDEO_OUT-1:0] w_out_video_hsync;
wire [NUM_VIDEO_OUT-1:0] w_out_video_vsync;
wire [NUM_VIDEO_OUT*VIDEO_MEM_DATAWIDTH-1:0]w_out_video_rd_00;
wire [NUM_VIDEO_OUT*VIDEO_MEM_DATAWIDTH-1:0]w_out_video_rd_01;
wire [NUM_VIDEO_OUT*VIDEO_MEM_DATAWIDTH-1:0]w_out_video_rd_10;
wire [NUM_VIDEO_OUT*VIDEO_MEM_DATAWIDTH-1:0]w_out_video_rd_11;


	//Overlay Video Stream Output
wire [0:0] w_out_video_overlay_de;
wire [0:0] w_out_video_overlay_valid;
wire [0:0] w_out_video_overlay_hsync;
wire [0:0] w_out_video_overlay_vsync;
wire [VIDEO_MEM_DATAWIDTH-1:0]w_out_video_overlay_rd_00;
wire [VIDEO_MEM_DATAWIDTH-1:0]w_out_video_overlay_rd_01;
wire [VIDEO_MEM_DATAWIDTH-1:0]w_out_video_overlay_rd_10;
wire [VIDEO_MEM_DATAWIDTH-1:0]w_out_video_overlay_rd_11;


//SOC to DMA 
wire     [15:0]   w_dma_apbSlave_PADDR;
wire     [0:0]    w_dma_apbSlave_PSEL;
wire              w_dma_apbSlave_PENABLE;
wire              w_dma_apbSlave_PREADY;
wire              w_dma_apbSlave_PWRITE;
wire     [31:0]   w_dma_apbSlave_PWDATA;
wire     [31:0]   w_dma_apbSlave_PRDATA;
wire              w_dma_apbSlave_PSLVERROR;
wire 			  w_dma_ctrl_interrupt;

wire     [15:0]   w_dma_sg_apbSlave_PADDR;
wire     [0:0]    w_dma_sg_apbSlave_PSEL;
wire              w_dma_sg_apbSlave_PENABLE;
wire              w_dma_sg_apbSlave_PREADY;
wire              w_dma_sg_apbSlave_PWRITE;
wire     [31:0]   w_dma_sg_apbSlave_PWDATA;
wire     [31:0]   w_dma_sg_apbSlave_PRDATA;
wire              w_dma_sg_apbSlave_PSLVERROR;


wire 	[2:0]     w_red_gain;				//Bit [2:0]
wire 	[2:0]     w_green_gain;			//Bit [6:4]
wire 	[2:0]     w_blue_gain;				//Bit [10:8]


wire  [3:0] w_start_dma_stream_in;
wire  [3:0] w_start_dma_stream_out;
wire  [1:0] w_start_vga_gen;
wire  [0:0] w_start_minip_tx;
wire  [0:0] w_start_minip_rx;

wire [4:0] w_debayer_sel;
    
wire w_reset_pixel_n;

wire w_reset_pixel_n; 

wire w_ddr_clk_resstn;
wire w_ddr_ready;

wire w_sysclk_arstn;
wire w_sysclk_arst;

wire ddr_cfg_ok;


/////////////////////////////////////////////////////////////////////////////
//ddr4 config
localparam [1:0]    IDLE        = 2'b00,
                    CFG_START   = 2'b01,
                    CFG_DONE    = 2'b11;

wire ddr_cfg_ok;

localparam          AXI0_DATAWIDTH        = 128;
localparam          AXI1_DATAWIDTH        = 512;     
reg [1:0]   cfg_st, cfg_next;
reg [7:0]   cfg_count;
//Reset and PLL
wire 		reset;
wire		io_systemReset;
wire 	    io_memoryReset;				

wire        w_pre1_asyncResetn;
wire        w_pre2_asyncResetn;

wire        io_asyncResetn;
wire m_pass_0;

wire reset;
/////////////////////////////////////////////////////////////////////////////
//Reset and PLL

assign pll_ddr_RSTN 	= 1'b1;
assign pll_osc2_RSTN    = 1'b1;
assign pll_osc3_RSTN    = 1'b1;

assign pll_sys_RSTN     = 1'b1;

assign io_asyncResetn = i_sw[0] & pll_sys_LOCKED & pll_ddr_LOCKED & pll_osc2_LOCKED & pll_osc3_LOCKED;
assign w_sysclk_arst 	= ~( io_asyncResetn );//~( io_asyncResetn & ddr_cfg_ok);
assign w_sysclk_arstn   = ~w_sysclk_arst;



/*
timer_ms_start #(
.MHZ(SYS_FREQ_MHZ),
.minisecond(10)
) memcheck_s0 (
.clk(i_sys_clk),
.rst_n(w_pre1_asyncResetn),
.start(io_asyncResetn)
);
*/
/*
reset
#(
	.IN_RST_ACTIVE	("LOW"),
	.OUT_RST_ACTIVE	("LOW"),
	.CYCLE			(3)
)
inst_sys_clk_rst
(
	.i_arst	(w_pre2_asyncResetn),
	.i_clk	(i_sys_clk),
	.o_srst	()
);
*/


/////////////////////////////////////////////////////////////////////////////

//assign m_aready_0=(m_atype_0 & m_awready_0) | (!m_atype_0 & m_arready_0);
//assign m_awvalid_0=m_avalid_0 & m_atype_0;
//assign m_arvalid_0=m_avalid_0 & ~m_atype_0;



wire [31:0] io_ddrA_ar_payload_addr_i;
wire [31:0] io_ddrA_aw_payload_addr_i;
wire [7:0]  io_ddrA_ar_payload_id_i;
wire [7:0]  io_ddrA_aw_payload_id_i;
wire [7:0]  io_ddrA_b_payload_id_i;
wire [7:0]  io_ddrA_r_payload_id_i;

assign ddr_inst_ARID_0  = {io_ddrA_ar_payload_id_i[7:6], io_ddrA_ar_payload_id_i[3:0]};
assign ddr_inst_AWID_0  = {io_ddrA_aw_payload_id_i[7:6], io_ddrA_aw_payload_id_i[3:0]};
assign io_ddrA_b_payload_id_i = {ddr_inst_BID_0[5:4], 2'b00, ddr_inst_BID_0[3:0]};
assign io_ddrA_r_payload_id_i = {ddr_inst_RID_0[5:4], 2'b00, ddr_inst_RID_0[3:0]};

assign ddr_inst_ARST_0 =    ddr_cfg_ok; //1'b1;//~io_memoryReset;//1'b1;
assign ddr_inst_ARAPCMD_0 = 1'b0;
assign ddr_inst_AWALLSTRB_0 = 1'b0;
assign ddr_inst_AWAPCMD_0 = 1'b0;
assign ddr_inst_AWCOBUF_0 = 1'b0;
assign ddr_inst_ARADDR_0= {1'b0, io_ddrA_ar_payload_addr_i};
assign ddr_inst_AWADDR_0= {1'b0, io_ddrA_aw_payload_addr_i};


//////////////////////////////// DMA ////////////////////////////////////////
//APB DMA 0  
/*wire   [13:0]   io_apbSlave_0_PADDR;
wire          	io_apbSlave_0_PSEL;
wire            io_apbSlave_0_PENABLE;
wire            io_apbSlave_0_PREADY;
wire            io_apbSlave_0_PWRITE;
wire   [31:0]   io_apbSlave_0_PWDATA;
wire   [31:0]   io_apbSlave_0_PRDATA;
wire            io_apbSlave_0_PSLVERROR;
*/
wire 		tester_i_tvalid;	
wire  		tester_i_tready;	
wire   [31:0]	tester_i_tdata;
wire   [3:0]	tester_i_tkeep;	
wire   [3:0]	tester_i_tdest;	
wire      	tester_i_tlast;	
wire 		tester_o_tvalid;	
wire      	tester_o_tready;
wire   [31:0]	tester_o_tdata;	
wire   [3:0]	tester_o_tkeep;	
wire   [3:0]	tester_o_tdest;	
wire 		tester_o_tlast;	
wire            read_arvalid;
wire            read_arready;
wire   [31:0]   read_araddr;
wire   [3:0]    read_arregion;
wire   [7:0]    read_arlen;
wire   [2:0]    read_arsize;
wire   [1:0]    read_arburst;
wire   [0:0]    read_arlock;
wire   [3:0]    read_arcache;
wire   [3:0]    read_arqos;
wire   [2:0]    read_arprot;
wire            read_rvalid;
wire            read_rready;
wire   [127:0]   read_rdata;
wire   [1:0]    read_rresp;
wire            read_rlast;
wire            write_awvalid;
wire            write_awready;
wire   [31:0]   write_awaddr;
wire   [3:0]    write_awregion;
wire   [7:0]    write_awlen;
wire   [2:0]    write_awsize;
wire   [1:0]    write_awburst;
wire   [0:0]    write_awlock;
wire   [3:0]    write_awcache;
wire   [3:0]    write_awqos;
wire   [2:0]    write_awprot;
wire            write_wvalid;
wire            write_wready;
wire   [127:0]   write_wdata;
wire   [15:0]    write_wstrb;
wire            write_wlast;
wire            write_bvalid;
wire            write_bready;
wire   [1:0]    write_bresp;

wire   [5:0]    w_o_led;

assign o_led[3:0]   =  w_o_led[3:0];

reg r_DDR_Reset;

reg[31:0]  r_ref_count ;// (1Hz) 
reg r_ref_clk   ; 


always@(posedge i_sys_clk or negedge io_asyncResetn)
begin
    if(!io_asyncResetn)
    begin
        r_ref_count <= 'd0;
        r_ref_clk <= 1'b0;
    end
    else 
    begin
        r_ref_count <= r_ref_count +1'b1;
        if(r_ref_count >= 100*1000*1000)
        begin
            r_ref_count <= 'd0;
            r_ref_clk <= ~r_ref_clk;
        
        end 
       
    end 
end 




//wire w_DDR_Resetn; 
//assign w_DDR_Resetn =  (~io_memoryReset) & io_asyncResetn;
/////////////////////////////////////////////////////////////////////////////
//ddr4 config
always@(posedge i_sys_clk or negedge io_asyncResetn)
begin
   
    if(!io_asyncResetn)
    begin
        cfg_st <= IDLE;
        cfg_count <= 'h0;
        r_DDR_Reset <= 1'b0;
    end 
    else
    begin
//        r_DDR_Reset <= io_memoryReset;
        r_DDR_Reset <= io_memoryReset;
       
       
        if (r_DDR_Reset) 
        begin
            cfg_st <= IDLE;
            cfg_count <= 'h0;
        end 
        else 
        begin
      
            cfg_st <= cfg_next;

            if (cfg_st == IDLE)
                cfg_count <= cfg_count + 1'b1;
            else 
                cfg_count <= 'h0;
        end
    end 
        
end

always@(*)
begin
    cfg_next = cfg_st;
    case(cfg_st)
    IDLE:
    begin
        if(cfg_count == 'hff)
            cfg_next = CFG_START;
        else
            cfg_next = IDLE;
    end
    CFG_START:
    begin
        if(ddr_inst_CFG_DONE)
            cfg_next = CFG_DONE;
        else
            cfg_next = CFG_START;
    end
    CFG_DONE:
        cfg_next = CFG_DONE;
    default:
        cfg_next = IDLE;
    endcase
end

assign ddr_inst_CFG_START    = (cfg_st != IDLE);
//assign cfg_ok       = (cfg_st == CFG_DONE);
assign ddr_cfg_ok   = (cfg_st == CFG_DONE);
assign o_led[5]     = (cfg_st == CFG_DONE);
assign ddr_inst_CFG_RESET    = (cfg_st == IDLE);
assign ddr_inst_CFG_SEL      = 1'b0;

/*
always@(posedge i_sys_clk)
begin
    if(cfg_st == IDLE)
        cfg_count <= cfg_count + 1'b1;
    else
        cfg_count <= 'h0;
end*/
//assign o_led[3] = m_pass_0;

assign o_cam_rstn = {4{w_sysclk_arstn}};

wire [NUM_CAM-1  :0]    w_rx_cam_de;
wire [NUM_CAM-1  :0]    w_rx_cam_vs;
wire [NUM_CAM-1  :0]    w_rx_cam_hs;
wire [NUM_CAM*64-1  :0] w_rx_cam_data;
wire [NUM_CAM*6-1:0]    w_rx_cam_dt; //Data type
wire [NUM_CAM*16-1:0]   w_rx_cam_wc; //would count    
wire [NUM_CAM*16-1:0]   w_rx_cam_line_num; //Line Number     
wire [NUM_CAM*16-1:0]   w_rx_cam_frame_num; //Frame Number 





//csi_rx_controllers #(
csi_rx_controllers_full #(
	.NUM_CHANNEL(NUM_CAM),
    .NUM_RX_PER_CHANNEL(CSI_RX_NUM_DATA_LANE),
    .DATAWIDTH_PER_CHANNEL(CSI_RX_DATA_WIDTH_LANE)
)
inst_csi_rx_controllers
(

    .rstn(w_sysclk_arstn),
   .clk(i_pixel_clk),// .clk(i_sys_clk_100mhz),		  //For Controller Clock 100mhz
   .clk_pixel(i_pixel_clk),// .clk_pixel(i_pixel_clk), //pixel clock for 4K@60 min. 220Mhz
  // 	.i_ref_clk(r_ref_clk),
  // DPHY interface port
  
     .axi_clk(i_pixel_clk_tx), 
     .axi_reset_n(w_sysclk_arstn),
	
    .clk_byte_HS	({rx_pclk_3,rx_pclk_2,rx_pclk_1,rx_pclk_0}),
    .reset_byte_HS_n({rx_reset_byte_HS_n_3,rx_reset_byte_HS_n_2,rx_reset_byte_HS_n_1,rx_reset_byte_HS_n_0}),
	.resetb_rx		({resetb_rx_3,resetb_rx_2,resetb_rx_1,resetb_rx_0}),
        
    .RxDataHS0({RxDataHS_3[0],RxDataHS_2[0],RxDataHS_1[0],RxDataHS_0[0]}),  //full 16 bit
    .RxDataHS1({RxDataHS_3[1],RxDataHS_2[1],RxDataHS_1[1],RxDataHS_0[1]}),
    .RxValidHS0({RxValidHS_3[0],RxValidHS_2[0],RxValidHS_1[0],RxValidHS_0[0]}),
    .RxValidHS1({RxValidHS_3[1],RxValidHS_2[1],RxValidHS_1[1],RxValidHS_0[1]}),
    `ifdef CSI_RX_4LANES
    .RxDataHS2({RxDataHS_3[2],RxDataHS_2[2],RxDataHS_1[2],RxDataHS_0[2]}),
    .RxDataHS3({RxDataHS_3[3],RxDataHS_2[3],RxDataHS_1[3],RxDataHS_0[3]}),
    .RxValidHS2({RxValidHS_3[2],RxValidHS_2[2],RxValidHS_1[2],RxValidHS_0[2]}),
    .RxValidHS3({RxValidHS_3[3],RxValidHS_2[3],RxValidHS_1[3],RxValidHS_0[3]}),
    `endif
    
    .RxSyncHS ({RxSyncHS_3 ,RxSyncHS_2 ,RxSyncHS_1 ,RxSyncHS_0 }),
    .RxUlpsClkNot		({RxUlpsClkNot_3,		RxUlpsClkNot_2,			RxUlpsClkNot_1,			RxUlpsClkNot_0		}),
    .RxUlpsActiveClkNot	({RxUlpsActiveClkNot_3,	RxUlpsActiveClkNot_2,	RxUlpsActiveClkNot_1,	RxUlpsActiveClkNot_0}),
    .RxErrEsc		({RxErrEsc_3,	    RxErrEsc_2,	      RxErrEsc_1,	    RxErrEsc_0	      }),
    .RxErrControl	({RxErrControl_3,   RxErrControl_2,   RxErrControl_1,   RxErrControl_0    }),
    .RxErrSotSyncHS	({RxErrSotSyncHS_3, RxErrSotSyncHS_2, RxErrSotSyncHS_1, RxErrSotSyncHS_0  }),
    .RxUlpsEsc		({RxUlpsEsc_3,      RxUlpsEsc_2,      RxUlpsEsc_1,      RxUlpsEsc_0       }),
    .RxUlpsActiveNot({RxUlpsActiveNot_3,RxUlpsActiveNot_2,RxUlpsActiveNot_1,RxUlpsActiveNot_0 }),
    .RxSkewCalHS	({RxSkewCalHS_3,    RxSkewCalHS_2,    RxSkewCalHS_1,    RxSkewCalHS_0     }),
    .RxStopState	({RxStopState_3,    RxStopState_2,    RxStopState_1,    RxStopState_0     }),

     // CSI controller ouptut interface port
    .rx_out_de			(w_rx_cam_de		),
    .rx_out_vs			(w_rx_cam_vs		),
    .rx_out_hs			(w_rx_cam_hs		),
	.rx_out_data		(w_rx_cam_data	    ),
	.rx_out_dt			(w_rx_cam_dt		), //Data type
	.rx_out_wc			(w_rx_cam_wc		), //would count    
	.rx_out_line_num	(w_rx_cam_line_num  ), //Line Number     
	.rx_out_frame_num   (w_rx_cam_frame_num )  //Frame Number     
);





reg r_minip_tx_resetn;
always @ (posedge i_pixel_clk_tx or negedge w_sysclk_arstn)
begin
    if (~w_sysclk_arstn)
    begin
        r_minip_tx_resetn <= 1'b0;
    end 
    else 
    begin
        r_minip_tx_resetn <= w_start_minip_tx[0]; 
    end 

end 


wire [63:0]         tx_data ;
wire                tx_valid;
wire [NUM_CAM-1:0]  tx_vsync;     // Individual VSync per VC
wire [NUM_CAM-1:0]  tx_hsync;     // Individual HSync per VC
wire [5:0]          tx_data_type;
wire [1:0]          tx_vc_id;
wire [31:0]         tx_frame_num;
wire [15:0]         tx_line_num;
wire [15:0]         tx_line_count;

wire [NUM_CAM*32-1:0]     w_rx_frame_count;
wire [NUM_CAM*16-1:0]     w_rx_line_count;





wire [3:0] w_cam_cfgdone;

wire [3:0] w_clk_byte_HS;
wire [3:0] w_reset_byte_HS_n;


 assign w_clk_byte_HS	  = {rx_pclk_3,rx_pclk_2,rx_pclk_1,rx_pclk_0};
 assign w_reset_byte_HS_n = {rx_reset_byte_HS_n_3,rx_reset_byte_HS_n_2,rx_reset_byte_HS_n_1,rx_reset_byte_HS_n_0};


genvar x;
generate 
	for(x=0; x< NUM_CAM; x=x+1)
	begin:csi_rx_monitor

        wire [31:0]  w_rx_frame_count;
        wire [31:0]  w_rx_hsync_per_frame;
        wire [31:0]  w_rx_pixel_per_line;
        wire [31:0]  w_rx_frame_rate;      // Measured in Hz 
        wire [31:0]  w_rx_mipi_hs_clk;
        wire [31:0]  w_rx_de_throughput;
        
        video_monitor inst_csi_rx_monitor(
            .clk(i_pixel_clk),        // Pixel clock
            .reset_n(w_sysclk_arstn),
            .vsync(w_rx_cam_vs[x]),
            .hsync(w_rx_cam_hs[x]),
            .de(w_rx_cam_de[x]),         // Data Enable / Valid
            .ref_clk_hz(32'd250_000_000), // Frequency of the pixel clock (for rate calc)
            
            .hsync_per_frame(w_rx_hsync_per_frame),
            .pixel_per_line (w_rx_pixel_per_line ),
            .frame_rate     (w_rx_frame_rate     ), // Measured in Hz
            
            .vsync_pulse    (w_o_led[x]),
            .mipi_clk(w_clk_byte_HS[x]),
            .mipi_clk_rst_n(w_reset_byte_HS_n[x]), 
            
            .mipi_clk_freq(w_rx_mipi_hs_clk),
            .de_throughput(w_rx_de_throughput)
            
        );
    end
endgenerate 
wire tx_global_hsync;
csi2_aggregator_top inst_csi2_aggregator
(
    .sys_clk (i_pixel_clk_tx),
    .rst_n(r_minip_tx_resetn), 
    
    // RX Interface
    .rx_clks( {i_pixel_clk,i_pixel_clk,i_pixel_clk,i_pixel_clk}),
    .rx_rst_n({w_sysclk_arstn,w_sysclk_arstn,w_sysclk_arstn,w_sysclk_arstn}),
	
    .rx_vsync(w_rx_cam_vs),
    .rx_hsync(w_rx_cam_hs),
    .rx_data (w_rx_cam_data),
    .rx_valid(w_rx_cam_de),
    
    .rx_frame_count(w_rx_frame_count),
    .rx_line_count (w_rx_line_count ),
    .tx_enable    (1'b1),
    .tx_global_hsync(tx_global_hsync),
    // TX Interface (Vectorized Syncs)
    .tx_data      (tx_data      ),
    .tx_valid     (tx_valid     ),
    .tx_vsync     (tx_vsync     ),     // Individual VSync per VC
    .tx_hsync     (tx_hsync     ),     // Individual HSync per VC
    .tx_data_type (tx_data_type ),
    .tx_vc_id     (tx_vc_id     ),
    .tx_frame_num (tx_frame_num ),
    .tx_line_num  (tx_line_num  ),
	.tx_line_count(tx_line_count)
	
);
generate 
	for(x=0; x< NUM_CAM; x=x+1)
	begin:csi_tx_vc_monitor

        wire [31:0]  w_tx_frame_count;
        wire [31:0]  w_tx_hsync_per_frame;
        wire [31:0]  w_tx_pixel_per_line;
        wire [31:0]  w_tx_frame_rate;      // Measured in Hz 
         wire [31:0]  w_tx_de_throughput;
        
        video_monitor inst_csi_Tx_monitor(
            .clk(i_pixel_clk_tx),        // Pixel clock
            .reset_n(r_minip_tx_resetn),
            
            
            
            .vsync(tx_vsync[x]),
            .hsync(tx_hsync[x]),
            .de(tx_valid & tx_vsync[x] & tx_hsync[x]),         // Data Enable / Valid
            .ref_clk_hz(32'd250_000_000), // Frequency of the pixel clock (for rate calc)
            
            .hsync_per_frame(w_tx_hsync_per_frame),
            .pixel_per_line (w_tx_pixel_per_line ),
            .frame_rate     (w_tx_frame_rate     ), // Measured in Hz
            
            .de_throughput(w_tx_de_throughput)

        );
    end
endgenerate 

wire tx_fifo_full;
wire tx_fifo_empty;
 
      
reg [31:0] ref_cnt_int;
reg [31:0] de_cnt_int;
reg [31:0] idle_cnt_int;
reg [31:0] global_hsyn_cnt_int;
reg [31:0] hsyn_cnt_int;

reg [31:0] ref_cnt;
reg [31:0] de_cnt;
reg [31:0] idle_cnt;
reg [31:0] global_hsyn_cnt;
reg [31:0] hsyn_cnt;


reg r_tx_global_hsync_P1;
reg r_tx_global_hsync_P2;

reg r_tx_hsync_P1;
reg r_tx_hsync_P2;
      

always @(posedge i_pixel_clk_tx or negedge r_minip_tx_resetn) begin
    if (!r_minip_tx_resetn) begin 
        r_tx_global_hsync_P1 <= 'd0;
        r_tx_global_hsync_P2 <= 'd0;

        r_tx_hsync_P1 <= 'd0;
        r_tx_hsync_P2 <= 'd0;
    
    
        ref_cnt_int <= 'd0;
        de_cnt_int   <= 'd0;
        idle_cnt_int  <= 'd0;
        global_hsyn_cnt_int  <= 'd0;
        hsyn_cnt_int  <= 'd0;

        ref_cnt  <= 'd0;
        de_cnt  <= 'd0 ;
        idle_cnt  <= 'd0;
        global_hsyn_cnt  <= 'd0;
        hsyn_cnt  <= 'd0;
    end 
    
    else 
    begin
    
        r_tx_global_hsync_P1 <= tx_global_hsync;
        r_tx_global_hsync_P2 <= r_tx_global_hsync_P1;

        r_tx_hsync_P1 <= (tx_hsync ==0) ? 1'b0: 1'b1;
        r_tx_hsync_P2 <= r_tx_hsync_P1;

        if(ref_cnt_int == 32'd250_000_000)
        begin
            ref_cnt_int <= 'd0;
            de_cnt_int   <= 'd0;
            idle_cnt_int  <= 'd0;
            global_hsyn_cnt_int  <= 'd0;
            hsyn_cnt_int  <= 'd0;
        
        
            ref_cnt  <= ref_cnt_int;
            de_cnt  <= de_cnt_int ;
            idle_cnt  <= idle_cnt_int;
            global_hsyn_cnt  <= global_hsyn_cnt_int;
            hsyn_cnt  <= hsyn_cnt_int;
        
        end 
        else 
        begin
        
            if (tx_valid) begin
                de_cnt_int <= de_cnt_int +1;
            end 
            
            if (tx_fifo_empty) begin
                idle_cnt_int <= idle_cnt_int +1;
            end 
            
            if(!r_tx_global_hsync_P2 & r_tx_global_hsync_P1)
            begin
                global_hsyn_cnt_int <= global_hsyn_cnt_int +1;
            end 
 
           if(!r_tx_hsync_P2 & r_tx_hsync_P1)
            begin
                hsyn_cnt_int <= hsyn_cnt_int +1;
            end 
 
 
            
            ref_cnt_int <= ref_cnt_int +1;
        end 
    
    
    
    end      
end         

csi_tx_controllers_full #(
	.NUM_CHANNEL(NUM_CSI_TX_FANOUT),
    .NUM_TX_PER_CHANNEL(CSI_TX_NUM_DATA_LANE),
    .DATAWIDTH_PER_CHANNEL(CSI_TX_DATA_WIDTH_LANE),
	.PIXEL_TX_DATAWIDTH(CSI_PIXEL_TX_DATAWIDTH),	//RAW10, RAW12
    .PIXEL_OUT_DATAWIDTH(CSI_PIXEL_TX_MEM_DATAWIDTH)
    
)
inst_csi_tx_controllers
(

	.rstn(r_minip_tx_resetn),
    .clk(mipi_clk),		  //For Controller Clock 100mhz
    .clk_pixel(i_pixel_clk_tx), //pixel clock for 4K@60 min. 220Mhz
  	.clk_esc(tx_escclk),
  // DPHY interface port
	
    .clk_byte_HS(tx_pclk_0),
 //   .reset_byte_HS_n(),
	.resetb_tx(resetb_tx_0),
  
   //TX
    .TxStopStateC		(TxStopStateC_0),
    .TxUlpsActiveClkNot	(TxUlpsActiveClkNot_0),
    .TxReadyHS			(TxReadyHS_0),  
    .TxStopStateD		(TxStopStateD_0),
    .TxUlpsActiveNot	(TxUlpsActiveNot_0),
		
    .TxRequestHS		(TxRequestHS_0	  ),
    .TxRequestEsc      	(TxRequestEsc_0   ),
    .TxUlpsExit        	(TxUlpsExit_0     ),
    .TxUlpsEsc         	(TxUlpsEsc_0      ),
    .TxSkewCalHS       	(TxSkewCalHS_0    ),
    .TxUlpsClk         	(TxUlpsClk_0      ),
    .TxUlpsExitClk     	(TxUlpsExitClk_0  ),
    .TxRequestHSc      	(TxRequestHSc_0   ),

    
    .TxDataHS0         	(TxDataHS0_0      ),
    .TxDataHS1         	(TxDataHS1_0      ),
    .TxReqValidHS0      (TxReqValidHS0_0),
    .TxReqValidHS1      (TxReqValidHS1_0),
    
    `ifdef CSI_TX_4LANES
    .TxDataHS2         	(TxDataHS2_0    ),
    .TxDataHS3         	(TxDataHS3_0    ),
    .TxReqValidHS2      (TxReqValidHS2_0),
    .TxReqValidHS3      (TxReqValidHS3_0),
    `endif
    
    
    .tx_in_de       (tx_valid),
	.tx_in_data     (tx_data ),
    .tx_in_vs       ({12'd0,tx_vsync[3:0]}),
    .tx_in_hs       ({12'd0,tx_hsync[3:0]}), 
	.tx_in_dt       (tx_data_type ),   // data type of the Long Packet
    .tx_in_haddr    (tx_line_count),   //16 bit total Horizontal number of pixels
	.tx_in_line_num (tx_line_num  ),    //
    .tx_in_frame_num(tx_frame_num ),   //
    
 
     
    .tx_fifo_full   (tx_fifo_full ),
    .tx_fifo_empty  (tx_fifo_empty)
     
);

wire [7:0] dma_arid;
wire [7:0] dma_awid;


assign ddr_inst_ARADDR_1[32] = 1'b0;
assign ddr_inst_AWADDR_1[32] = 1'b0;

assign dma_arid = 8'hE0;
assign dma_awid = 8'hE1;

assign ddr_inst_ARID_1 = {dma_arid[7:6], dma_arid[3:0]};
assign ddr_inst_AWID_1 = {dma_awid[7:6], dma_awid[3:0]};

assign ddr_inst_AWAPCMD_1 = 1'b0;
assign ddr_inst_ARAPCMD_1 = 1'b0;
assign ddr_inst_AWALLSTRB_1 = 1'b0;
assign ddr_inst_AWCOBUF_1   = 1'b0;

assign ddr_inst_ARST_1 = ddr_cfg_ok;//1'b1;//~io_memoryReset;//1'b1;


`ifdef HARD_I2C_CONFIG


assign w_start_minip_tx = (w_cam_cfgdone != 'd0) ? 1'b1: 1'b0;



reg [3:0]r_piv2_config_rst;

genvar i;

// Generate block to instantiate 4 modules
generate

    //THe sensor IMX477 output resulsts may be impacted, if time interval of configurated time between sensor and next sensor are too close.    
    for (i = 0; i < 4; i = i + 1) begin : gen_piv2_config
        
        reg [31:0] dly_cnt;
        reg r_start_cam_config;
        
    
        always@(posedge i_pixel_clk_tx or negedge w_sysclk_arstn)
        begin
            if(!w_sysclk_arstn)
            begin 
                dly_cnt <= 'd0;
                r_start_cam_config <= 'd0;
            end
            else 
            begin
                if(dly_cnt == i*32'd250_000_000) 
                begin
                    r_start_cam_config <= 1'd1;
                    
                end 
                else 
                begin 
                    dly_cnt <= dly_cnt + 'd1;
                end 
            
            end 
        
        end 
        
        always@(posedge i_sys_clk_25mhz or negedge r_start_cam_config)
        begin 
            if (!r_start_cam_config)
            begin
                r_piv2_config_rst[i] <= 1'b1;
            end 
            else 
            begin
                r_piv2_config_rst[i] <= 1'b0;
            end 
        
        end 
        
        
        
        piv2_config #(
            .I2C_ID         (`CAM_I2C_ADDR),
            .INITIAL_CODE   ("source/cam/imx477_4k44fps.mem"),
            .MEM_DEPTH		(1284)
        )
        inst_piv2_config (
            .i_arst         (r_piv2_config_rst[i]), // (w_sysclk_arst),
            .i_sysclk       (i_sys_clk_25mhz),
            .i_pll_locked   (pll_sys_LOCKED),
            .o_state        (),
            .o_confdone     (w_cam_cfgdone[i]),
            
            .i_dbg_we       (1'b0),
            .i_dbg_din      (8'b0),
            .i_dbg_addr     (10'b0),
            .o_dbg_dout     (),
            .i_dbg_reconfig (1'b0),
            
            // Loop index 'i' drives the independent camera interfaces
            .i_sda          (w_cam_i2c_sda_read[i]),
            .o_sda_oe       (w_cam_i2c_sda_write[i]),
            .i_scl          (w_cam_i2c_scl_read[i]),
            .o_scl_oe       (w_cam_i2c_scl_write[i]),
            .o_rstn         ()
        );
    end
endgenerate

`else

top_soc_oob #(
    .NUM_CAM(4),
    .HARD_CONFIG(HARD_CONFIG)
)
inst_soc_oob(

	//Clock Control
	.io_systemClk		(i_soc_clk),
	.io_asyncReset		(w_sysclk_arst),
	.io_memoryClk		(i_axi0_mem_clk),
	.io_memoryReset		(io_memoryReset), 
    .io_systemReset     (io_systemReset),

 
    //Memory Interface 
	.mem_ar_valid	       (ddr_inst_ARVALID_0 		    ),
	.mem_ar_ready	       (ddr_inst_ARREADY_0          ),
	.mem_ar_payload_addr   (io_ddrA_ar_payload_addr_i   ),
	.mem_ar_payload_id     (io_ddrA_ar_payload_id_i     ),
	.mem_ar_payload_region ( ),
	.mem_ar_payload_len    (ddr_inst_ARLEN_0    ),
	.mem_ar_payload_size   (ddr_inst_ARSIZE_0   ),
	.mem_ar_payload_burst  (ddr_inst_ARBURST_0  ),
	.mem_ar_payload_lock   (ddr_inst_ARLOCK_0   ),
	.mem_ar_payload_cache  (  ),
	.mem_ar_payload_qos    (ddr_inst_ARQOS_0    ),
	.mem_ar_payload_prot   ( ),
    
    .mem_aw_valid	       (ddr_inst_AWVALID_0 		 ),
	.mem_aw_ready	       (ddr_inst_AWREADY_0          ),
	.mem_aw_payload_addr   (io_ddrA_aw_payload_addr_i   ),
	.mem_aw_payload_id     (io_ddrA_aw_payload_id_i     ),
	.mem_aw_payload_region ( ),
	.mem_aw_payload_len    (ddr_inst_AWLEN_0    ),
	.mem_aw_payload_size   (ddr_inst_AWSIZE_0   ),
	.mem_aw_payload_burst  (ddr_inst_AWBURST_0  ),
	.mem_aw_payload_lock   (ddr_inst_AWLOCK_0   ),
	.mem_aw_payload_cache  (ddr_inst_AWCACHE_0  ),
	.mem_aw_payload_qos    (ddr_inst_AWQOS_0    ),
	.mem_aw_payload_prot   (   ),
   
	.mem_w_valid            (ddr_inst_WVALID_0 			  ),
	.mem_w_ready            (ddr_inst_WREADY_0            ),
	.mem_w_payload_data     (ddr_inst_WDATA_0     ),
	.mem_w_payload_strb     (ddr_inst_WSTRB_0     ),
	.mem_w_payload_last 	(ddr_inst_WLAST_0     ),
	
	.mem_b_valid 			(ddr_inst_BVALID_0 			  ),
	.mem_b_ready            (ddr_inst_BREADY_0            ),
	.mem_b_payload_id       (io_ddrA_b_payload_id_i       ),
	.mem_b_payload_resp     (ddr_inst_BRESP_0     ),
	
	.mem_r_valid 			(ddr_inst_RVALID_0 			  ),
	.mem_r_ready            (ddr_inst_RREADY_0            ),
	.mem_r_payload_data     (ddr_inst_RDATA_0     ),
	.mem_r_payload_id       (io_ddrA_r_payload_id_i       ),
	.mem_r_payload_resp     (ddr_inst_RRESP_0     ),
	.mem_r_payload_last     (ddr_inst_RLAST_0     ),
//	.mem_w_payload_id       (w_mem_w_payload_id       ),



    	
	//SOC Ports
  	.uart_0_txd						  (system_uart_0_io_txd),
  	.uart_0_rxd						  (system_uart_0_io_rxd),
	// SPI Flash 0 Interface 
  	.spi_flash_0_sclk_write           (system_spi_0_io_sclk_write 			),
  	.spi_flash_0_data_0_writeEnable   (system_spi_0_io_data_0_writeEnable   ),
  	.spi_flash_0_data_0_read          (system_spi_0_io_data_0_read          ),
  	.spi_flash_0_data_0_write         (system_spi_0_io_data_0_write         ),
  	.spi_flash_0_data_1_writeEnable   (system_spi_0_io_data_1_writeEnable   ),
  	.spi_flash_0_data_1_read          (system_spi_0_io_data_1_read          ),
  	.spi_flash_0_data_1_write         (system_spi_0_io_data_1_write         ),
  	.spi_flash_0_ss                   (system_spi_0_io_ss                   ),

	// SPI Flash 0 Interface 
//	.spi_flash_1_sclk_write 		  (system_spi_1_io_sclk_write           ),
	.spi_flash_1_sclk_write 		  (	),
  	.spi_flash_1_data_0_writeEnable   (system_spi_1_io_data_0_writeEnable   ),
  	.spi_flash_1_data_0_read          (system_spi_1_io_data_0_read          ),
  	.spi_flash_1_data_0_write         (system_spi_1_io_data_0_write         ),
  	.spi_flash_1_data_1_writeEnable   (system_spi_1_io_data_1_writeEnable   ),
  	.spi_flash_1_data_1_read          (system_spi_1_io_data_1_read          ),
  	.spi_flash_1_data_1_write         (system_spi_1_io_data_1_write         ),
  	.spi_flash_1_ss                   (system_spi_1_io_ss                   ),

	// Camera I2C Interface 
`ifndef HARD_I2C_CONFIG
	.cam_i2c_sda_write	(w_cam_i2c_sda_write),
	.cam_i2c_sda_read	(w_cam_i2c_sda_read),
	.cam_i2c_scl_write	(w_cam_i2c_scl_write),
	.cam_i2c_scl_read	(w_cam_i2c_scl_read),
`endif				
	//APB Slave 1 (DMA Streamming Controller)
	.dma_interrupt		   (w_dma_ctrl_interrupt    ),
	
	.dma_apbSlave_PADDR    (w_dma_apbSlave_PADDR	),
	.dma_apbSlave_PSEL     (w_dma_apbSlave_PSEL     ),
	.dma_apbSlave_PENABLE  (w_dma_apbSlave_PENABLE  ),
	.dma_apbSlave_PREADY   (w_dma_apbSlave_PREADY   ),
	.dma_apbSlave_PWRITE   (w_dma_apbSlave_PWRITE   ),
	.dma_apbSlave_PWDATA   (w_dma_apbSlave_PWDATA   ),
	.dma_apbSlave_PRDATA   (w_dma_apbSlave_PRDATA   ),
	.dma_apbSlave_PSLVERROR(w_dma_apbSlave_PSLVERROR),
	
    .dma_sg_apbSlave_PADDR    (w_dma_sg_apbSlave_PADDR	),
	.dma_sg_apbSlave_PSEL     (w_dma_sg_apbSlave_PSEL     ),
	.dma_sg_apbSlave_PENABLE  (w_dma_sg_apbSlave_PENABLE  ),
	.dma_sg_apbSlave_PREADY   (w_dma_sg_apbSlave_PREADY   ),
	.dma_sg_apbSlave_PWRITE   (w_dma_sg_apbSlave_PWRITE   ),
	.dma_sg_apbSlave_PWDATA   (w_dma_sg_apbSlave_PWDATA   ),
	.dma_sg_apbSlave_PRDATA   (w_dma_sg_apbSlave_PRDATA   ),
	.dma_sg_apbSlave_PSLVERROR(w_dma_sg_apbSlave_PSLVERROR),
    
    
	 
	//SD Card Host Access
   // .sd_base_clk(i_soc_clk),// i_sys_clk_100mhz
    .sd_base_clk(i_sd_clk),// i_sys_clk_100mhz
    .sd_clk_hi(sd_clk_hi),
	.sd_clk_lo(sd_clk_lo),
	.sd_cmd_i(sd_cmd_i),
	.sd_cmd_o(sd_cmd_o),
	.sd_cmd_oe(sd_cmd_oe),
	.sd_dat_i(sd_dat_i),
	.sd_dat_o(sd_dat_o),
	.sd_dat_oe(sd_dat_oe),
	.sd_wp(),
	.sd_cd_n(),
    
    .o_start_dma_stream_in(w_start_dma_stream_in),	    //Bit [0]
	.o_start_dma_stream_out(w_start_dma_stream_out),	//Bit [1]
    .o_start_vga_gen(w_start_vga_gen),
    .o_start_minip_tx(w_start_minip_tx),	            //Bit [1]
    .o_start_minip_rx(w_start_minip_rx),	             //Bit [1]
    
    .o_red_gain(w_red_gain),
    .o_green_gain(w_green_gain),
    .o_blue_gain(w_blue_gain),
    
  	.o_LED(),			
	.i_switch({3'b000,i_sw}),
     
  
     .o_debayer_sel(w_debayer_sel),  
        
     .mem_checker_pass(o_led[4]),    
`ifdef SOFT_TAP_
	.io_jtag_tck		(io_jtag_tck),
	.io_jtag_tdi		(io_jtag_tdi),
	.io_jtag_tdo		(io_jtag_tdo),
	.io_jtag_tms		(io_jtag_tms)
`else 
	.jtagCtrl_tck		(jtag_inst1_TCK),
	.jtagCtrl_tdi		(jtag_inst1_TDI),
	.jtagCtrl_tdo		(jtag_inst1_TDO),
	.jtagCtrl_enable	(jtag_inst1_SEL),
	.jtagCtrl_capture	(jtag_inst1_CAPTURE),
	.jtagCtrl_shift		(jtag_inst1_SHIFT),
	.jtagCtrl_update	(jtag_inst1_UPDATE),
	.jtagCtrl_reset		(jtag_inst1_RESET) 

`endif

    


);

`endif

wire [7:0] w_i2c_reg_ctrl;
wire [7:0] w_i2c_reg_config;


i2c_slave_regs inst_i2c_slave_ctrl(
    .clk(i_sys_clk),
    .rst(w_sysclk_arst),

    // I2C Physical Line Signals
    .scl_in(slv_scl_IN),
    .scl_out(slv_scl_OUT),
    .scl_oe(slv_scl_OE),

    .sda_in(slv_sda_IN),
    .sda_out(slv_sda_OUT),
    .sda_oe(slv_sda_OE),

    // Hardware Outputs Driven by Master Write Registers
    .reg_ctrl(w_i2c_reg_ctrl),
    .reg_config(w_i2c_reg_config),

    // Hardware Inputs Read by Master Read Registers
    .reg_status(8'ha5),
    .reg_version(8'd0)
);


//assign check_rx_hsyn   = w_rx_out_hs[0]; 
//assign check_rx_vsyn   = w_rx_out_vs[0]; 
//assign check_tx_hsyn   = w_out_csi_tx_hsync[0]; 
//assign check_tx_vsyn   = w_out_csi_tx_vsync[0]; 
//assign check_hdmi_hsyn = hdmi_yuv_hs;
//assign check_hdmi_vsyn = hdmi_yuv_vs;


endmodule
