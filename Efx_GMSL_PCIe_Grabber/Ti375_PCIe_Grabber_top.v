///////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024 github-efx
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
///////////////////////////////////////////////////////////////////////////////////

// To enable RiscV soft tap connection (for debugger).
//`define SOFT_TAP 1

//`define CSI_RX_4LANES   //Default 2 lanes
`define CSI_RX_LANE_DATAWIDTH   16

`define HARD_DPHY_RX


module Ti375_PCIe_Grabber_top #(
    parameter MIPI_FRAME_WIDTH   = 1920, // Camera input resolution
    parameter MIPI_FRAME_HEIGHT  = 1080, // Camera input resolution
    parameter FRAME_WIDTH        = 1920, // Output display frame resolution
    parameter FRAME_HEIGHT       = 1080, // Output display frame resolution
    parameter INPUT_IMAGE_WIDTH  = 1920, // Input image size for pre-processing
    parameter INPUT_IMAGE_HEIGHT = 1080, // Input image size for pre-processing
    parameter SCALE_FACTOR       = 5,   // Reduce the input image size by this factor before pre-processing
    parameter AXI_0_DATA_WIDTH   = 512   // AXI Width 0 connected to DMA
)	   
(
`ifndef SOFT_TAP        
output		                    jtagCtrl_tdi    ,
input		                    jtagCtrl_tdo    ,
output		                    jtagCtrl_enable ,
output		                    jtagCtrl_capture,
output		                    jtagCtrl_shift  ,
output		                    jtagCtrl_update ,
output		                    jtagCtrl_reset  ,
input		                    ut_jtagCtrl_tdi    ,
output		                    ut_jtagCtrl_tdo    ,
input		                    ut_jtagCtrl_enable ,
input		                    ut_jtagCtrl_capture,
input		                    ut_jtagCtrl_shift  ,
input		                    ut_jtagCtrl_update ,
input		                    ut_jtagCtrl_reset  ,
`else               
output                          io_jtag_tdi,
input                           io_jtag_tdo,
output                          io_jtag_tms,
input                           pin_io_jtag_tdi,
output                          pin_io_jtag_tdo,
input                           pin_io_jtag_tms,
`endif              

//Temporary fix to slb overwriting clock names 
output                          io_peripheralClk, 
output                          io_ddrMasters_0_clk,


//AXI Master 0 Read Data Channel
input		                    io_ddrMasters_0_r_valid           ,
output		                    io_ddrMasters_0_r_ready           ,
input [127:0]                   io_ddrMasters_0_r_payload_data    ,
input [3:0]                     io_ddrMasters_0_r_payload_id      ,
input [1:0]                     io_ddrMasters_0_r_payload_resp    ,
input		                    io_ddrMasters_0_r_payload_last    ,

//AXI Master 0 Write Data Channel
output		                    io_ddrMasters_0_w_valid           ,
input		                    io_ddrMasters_0_w_ready           ,
output [127:0]                  io_ddrMasters_0_w_payload_data    ,
output [15:0]                   io_ddrMasters_0_w_payload_strb    ,
output		                    io_ddrMasters_0_w_payload_last    ,

//AXI Master 0 Response Channel
input		                    io_ddrMasters_0_b_valid           ,
output		                    io_ddrMasters_0_b_ready           ,
input [3:0]                     io_ddrMasters_0_b_payload_id      ,
input [1:0]                     io_ddrMasters_0_b_payload_resp    ,

//AXI Master 0 Read Address Channel
output		                    io_ddrMasters_0_ar_valid          ,
input		                    io_ddrMasters_0_ar_ready          ,
output [31:0]                   io_ddrMasters_0_ar_payload_addr   ,
output [3:0]                    io_ddrMasters_0_ar_payload_id     ,
output [3:0]                    io_ddrMasters_0_ar_payload_region ,
output [7:0]                    io_ddrMasters_0_ar_payload_len    ,
output [2:0]                    io_ddrMasters_0_ar_payload_size   ,
output [1:0]                    io_ddrMasters_0_ar_payload_burst  ,
output		                    io_ddrMasters_0_ar_payload_lock   ,
output [3:0]                    io_ddrMasters_0_ar_payload_cache  ,
output [3:0]                    io_ddrMasters_0_ar_payload_qos    ,
output [2:0]                    io_ddrMasters_0_ar_payload_prot   ,

//AXI Master 0 Write Address Channel
output		                    io_ddrMasters_0_aw_valid          ,
input		                    io_ddrMasters_0_aw_ready          ,
output [31:0]                   io_ddrMasters_0_aw_payload_addr   ,
output [3:0]                    io_ddrMasters_0_aw_payload_id     ,
output [3:0]                    io_ddrMasters_0_aw_payload_region ,
output [7:0]                    io_ddrMasters_0_aw_payload_len    ,
output [2:0]                    io_ddrMasters_0_aw_payload_size   ,
output [1:0]                    io_ddrMasters_0_aw_payload_burst  ,
output		                    io_ddrMasters_0_aw_payload_lock   ,
output [3:0]                    io_ddrMasters_0_aw_payload_cache  ,
output [3:0]                    io_ddrMasters_0_aw_payload_qos    ,
output [2:0]                    io_ddrMasters_0_aw_payload_prot   ,
output		                    io_ddrMasters_0_aw_payload_allStrb,


output		                    system_spi_0_io_sclk_write        ,
output		                    system_spi_0_io_data_0_writeEnable,
input		                    system_spi_0_io_data_0_read       ,
output		                    system_spi_0_io_data_0_write      ,
output		                    system_spi_0_io_data_1_writeEnable,
input		                    system_spi_0_io_data_1_read       ,
output		                    system_spi_0_io_data_1_write      ,
output		                    system_spi_0_io_data_2_writeEnable,
input		                    system_spi_0_io_data_2_read       ,
output		                    system_spi_0_io_data_2_write      ,
output		                    system_spi_0_io_data_3_writeEnable,
input		                    system_spi_0_io_data_3_read       ,
output		                    system_spi_0_io_data_3_write      ,
output [3:0]                    system_spi_0_io_ss                ,

output		                    system_uart_0_io_txd,
input		                    system_uart_0_io_rxd,

input [31:0]                    axiA_awaddr  ,
input [7:0]	                    axiA_awlen   ,
input [2:0]	                    axiA_awsize  ,
input [1:0]	                    axiA_awburst ,
input		                    axiA_awlock  ,
input [3:0]	                    axiA_awcache ,
input [2:0]	                    axiA_awprot  ,
input [3:0]	                    axiA_awqos   ,
input [3:0]	                    axiA_awregion,
input		                    axiA_awvalid ,
output		                    axiA_awready ,
input [31:0]                    axiA_wdata   ,
input [3:0]                     axiA_wstrb   ,
input		                    axiA_wvalid  ,
input		                    axiA_wlast   ,
output		                    axiA_wready  ,
output [1:0]                    axiA_bresp   ,
output		                    axiA_bvalid  ,
input		                    axiA_bready  ,
input [31:0]                    axiA_araddr  ,
input [7:0]	                    axiA_arlen   ,
input [2:0]	                    axiA_arsize  ,
input [1:0]	                    axiA_arburst ,
input		                    axiA_arlock  ,
input [3:0]	                    axiA_arcache ,
input [2:0]	                    axiA_arprot  ,
input [3:0]	                    axiA_arqos   ,
input [3:0]	                    axiA_arregion,
input		                    axiA_arvalid ,
output		                    axiA_arready ,
output [31:0]                   axiA_rdata   ,
output [1:0]                    axiA_rresp   ,
output		                    axiA_rlast   ,
output		                    axiA_rvalid  ,
input		                    axiA_rready  ,
output                          axiAInterrupt,

input                           cfg_done ,
output                          cfg_start,
output                          cfg_sel  ,
output                          cfg_reset,

input                           ddr_inst2_CFG_DONE,
output                          ddr_inst2_CFG_RESET,
output                          ddr_inst2_CFG_SEL,
output                          ddr_inst2_CFG_START,

//Up to 8 Interrupts. userInterruptH is connected to eCNN
output		                    userInterruptA,
output		                    userInterruptB,
output		                    userInterruptC,
output		                    userInterruptD,
output		                    userInterruptE,
output		                    userInterruptF,
output		                    userInterruptG,
output		                    userInterruptH,


`ifndef  HARD_DPHY_RX
//MIPI RX - Camera      
input    wire                   cam_ck_LP_P_IN,
input    wire                   cam_ck_LP_N_IN,
output   wire                   cam_ck_HS_TERM,
output   wire                   cam_ck_HS_ENA,
input    wire                   cam_ck_CLKOUT,

input    wire  [7:0]            cam_d0_HS_IN     ,
input    wire  [7:0]            cam_d0_HS_IN_1   ,
input    wire  [7:0]            cam_d0_HS_IN_2   ,
input    wire  [7:0]            cam_d0_HS_IN_3   ,
input    wire                   cam_d0_LP_P_IN   ,
input    wire                   cam_d0_LP_N_IN   ,
output   wire                   cam_d0_HS_TERM   ,
output   wire                   cam_d0_HS_ENA    ,
output   wire                   cam_d0_RST       ,
output   wire                   cam_d0_FIFO_RD   ,
input    wire                   cam_d0_FIFO_EMPTY,

input    wire  [7:0]            cam_d1_HS_IN     ,
input    wire  [7:0]            cam_d1_HS_IN_1   ,
input    wire  [7:0]            cam_d1_HS_IN_2   ,
input    wire  [7:0]            cam_d1_HS_IN_3   ,
input    wire                   cam_d1_LP_P_IN   ,
input    wire                   cam_d1_LP_N_IN   ,
output   wire                   cam_d1_HS_TERM   ,
output   wire                   cam_d1_HS_ENA    ,
output   wire                   cam_d1_RST       ,
output   wire                   cam_d1_FIFO_RD   ,
input    wire                   cam_d1_FIFO_EMPTY,


`else 
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

 `endif

//CSI Camera interface      
input                           i_cam_sda   ,
output                          o_cam_sda_oe,
input                           i_cam_scl   ,
output                          o_cam_scl_oe,
output	                        o_cam_scl   ,
output	                        o_cam_sda   ,
output                          o_cam_rstn  ,

// I2C Configuration for HDMI
input                           i_hdmi_sda   ,
output                          o_hdmi_sda_oe,
input                           i_hdmi_scl   ,
output                          o_hdmi_scl_oe,


input                           hdmi_yuv_hs_IN ,
output                          hdmi_yuv_vs_OE ,
input                           hdmi_yuv_vs_IN ,
output                          hdmi_yuv_hs_OE ,
output                          hdmi_yuv_vs_OUT,
output                          hdmi_yuv_hs_OUT,

output                          hdmi_yuv_de  ,
output  [15:0]                  hdmi_yuv_data,

//Moved hdmi pll to soc_pll_mem_clk
input                           pll_osc_LOCKED ,
output                          pll_osc_RSTN   ,

input                           pll_osc2_LOCKED ,
output                          pll_osc2_RSTN   ,


input                           i_sys_clk          ,
input                           io_memoryClk       ,
input                           i_pixel_clk        ,
input                           i_hdmi_clk_148p5MHz,
input                           i_sys_clk_25mhz    ,

//3 Clocks Input for eCNN
input                           prp_clk     ,
input                           prp_clk_2x  ,
input                           prp_clk_2x_n,

input                           io_peripheralReset,
input                           io_systemReset    ,
output                          io_asyncReset     ,
output  reg                     sysClk_reset_ok   ,
output  reg                     periClk_reset_ok  ,
input                           io_gpio_sw_n      ,
input                           io_gpio_sw2_n     ,

//Make sure all interface clocks are locked
input                           pll_hdmi_locked   ,
input                           pll_system_locked ,
input                           pll_prp_locked    ,


//DDR AXI 0
output                          soc_ddr_inst1_ARSTN_0    ,

//DDR AXI 0 Read Data Channel
input   [AXI_0_DATA_WIDTH-1:0]  soc_ddr_inst1_RDATA_0    ,  //Read data.
input   [5:0]                   soc_ddr_inst1_RID_0      ,  //Read ID tag. This signal is the identification tag for the read data group of signals generated by the slave.
input                           soc_ddr_inst1_RLAST_0    ,  //Read last. This signal indicates the last transfer in a read burst.
output                          soc_ddr_inst1_RREADY_0   ,  //Read ready. This signal indicates that the master can accept the read data and response information.
input   [1:0]                   soc_ddr_inst1_RRESP_0    ,  //Read response. This signal indicates the status of the read transfer.
input                           soc_ddr_inst1_RVALID_0   ,  //Read valid. This signal indicates that the channel is signaling the required read data.

//DDR AXI 0 Write Data Channel 
output  [AXI_0_DATA_WIDTH-1:0]  soc_ddr_inst1_WDATA_0    ,  //Write data. AXI4 port 0 is 256, port 1 is 128.
output                          soc_ddr_inst1_WLAST_0    ,  //Write last. This signal indicates the last transfer in a write burst.
input                           soc_ddr_inst1_WREADY_0   ,  //Write ready. This signal indicates that the slave can accept the write data.
output  [AXI_0_DATA_WIDTH/8-1:0]soc_ddr_inst1_WSTRB_0    ,  //Write strobes. This signal indicates which byte lanes hold valid data. There is one write strobe bit for each eight bits of the write data bus.
output                          soc_ddr_inst1_WVALID_0   ,  //Write valid. This signal indicates that valid write data and strobes are available.
   
   
//DDR AXI 0 Wrtie Response Channel
input   [5:0]                   soc_ddr_inst1_BID_0      ,  //Response ID tag. This signal is the ID tag of the write response.
output                          soc_ddr_inst1_BREADY_0   ,  //Response ready. This signal indicates that the master can accept a write response.
input   [1:0]                   soc_ddr_inst1_BRESP_0    ,  //Read response. This signal indicates the status of the read transfer.
input                           soc_ddr_inst1_BVALID_0   ,  //Write response valid. This signal indicates that the channel is signaling a valid write response.

//DDR AXI 0 Read Address Channel
output  [32:0]                  soc_ddr_inst1_ARADDR_0   ,  //Read address. It gives the address of the first transfer in a burst transaction.
output  [1:0]                   soc_ddr_inst1_ARBURST_0  ,  //Burst type. The burst type and the size determine how the address for each transfer within the burst is calculated.
output  [5:0]                   soc_ddr_inst1_ARID_0     ,  //Address ID. This signal identifies the group of address signals.
output  [7:0]                   soc_ddr_inst1_ARLEN_0    ,  //Burst length. This signal indicates the number of transfers in a burst.
input                           soc_ddr_inst1_ARREADY_0  ,  //Address ready. This signal indicates that the slave is ready to accept an address and associated control signals.
output  [2:0]                   soc_ddr_inst1_ARSIZE_0   ,  //Burst size. This signal indicates the size of each transfer in the burst.
output                          soc_ddr_inst1_ARVALID_0  ,  //Address valid. This signal indicates that the channel is signaling valid address and control information.
output                          soc_ddr_inst1_ARLOCK_0   ,  //Lock type. This signal provides additional information about the atomic characteristics of the transfer.
output                          soc_ddr_inst1_ARAPCMD_0  ,  //Read auto-precharge.
output                          soc_ddr_inst1_ARQOS_0    ,  //QoS indentifier for read transaction.

//DDR AXI 0 Write Address Channel
output  [32:0]                  soc_ddr_inst1_AWADDR_0   ,  //Write address. It gives the address of the first transfer in a burst transaction.
output  [1:0]                   soc_ddr_inst1_AWBURST_0  ,  //Burst type. The burst type and the size determine how the address for each transfer within the burst is calculated.
output  [5:0]                   soc_ddr_inst1_AWID_0     ,  //Address ID. This signal identifies the group of address signals.
output  [7:0]                   soc_ddr_inst1_AWLEN_0    ,  //Burst length. This signal indicates the number of transfers in a burst.
input                           soc_ddr_inst1_AWREADY_0  ,  //Address ready. This signal indicates that the slave is ready to accept an address and associated control signals.
output  [2:0]                   soc_ddr_inst1_AWSIZE_0   ,  //Burst size. This signal indicates the size of each transfer in the burst.
output                          soc_ddr_inst1_AWVALID_0  ,  //Address valid. This signal indicates that the channel is signaling valid address and control information.
output                          soc_ddr_inst1_AWLOCK_0   ,  //Lock type. This signal provides additional information about the atomic characteristics of the transfer.
output                          soc_ddr_inst1_AWAPCMD_0  ,  //Write auto-precharge.
output                          soc_ddr_inst1_AWQOS_0    ,  //QoS indentifier for write transaction.
output  [3:0]                   soc_ddr_inst1_AWCACHE_0  ,  //Memory type. This signal indicates how transactions are required to progress through a system.
output                          soc_ddr_inst1_AWALLSTRB_0,  //Write all strobes asserted.
output                          soc_ddr_inst1_AWCOBUF_0,     //Write coherent bufferable selection.





//DDR2 AXI 0
output                          ddr_inst2_ARSTN_0    ,

//DDR AXI 0 Read Data Channel
input   [AXI_0_DATA_WIDTH-1:0]  ddr_inst2_RDATA_0    ,  //Read data.
input   [5:0]                   ddr_inst2_RID_0      ,  //Read ID tag. This signal is the identification tag for the read data group of signals generated by the slave.
input                           ddr_inst2_RLAST_0    ,  //Read last. This signal indicates the last transfer in a read burst.
output                          ddr_inst2_RREADY_0   ,  //Read ready. This signal indicates that the master can accept the read data and response information.
input   [1:0]                   ddr_inst2_RRESP_0    ,  //Read response. This signal indicates the status of the read transfer.
input                           ddr_inst2_RVALID_0   ,  //Read valid. This signal indicates that the channel is signaling the required read data.

//DDR AXI 0 Write Data Channel 
output  [AXI_0_DATA_WIDTH-1:0]  ddr_inst2_WDATA_0    ,  //Write data. AXI4 port 0 is 256, port 1 is 128.
output                          ddr_inst2_WLAST_0    ,  //Write last. This signal indicates the last transfer in a write burst.
input                           ddr_inst2_WREADY_0   ,  //Write ready. This signal indicates that the slave can accept the write data.
output  [AXI_0_DATA_WIDTH/8-1:0]ddr_inst2_WSTRB_0    ,  //Write strobes. This signal indicates which byte lanes hold valid data. There is one write strobe bit for each eight bits of the write data bus.
output                          ddr_inst2_WVALID_0   ,  //Write valid. This signal indicates that valid write data and strobes are available.
   
   
//DDR AXI 0 Wrtie Response Channel
input   [5:0]                   ddr_inst2_BID_0      ,  //Response ID tag. This signal is the ID tag of the write response.
output                          ddr_inst2_BREADY_0   ,  //Response ready. This signal indicates that the master can accept a write response.
input   [1:0]                   ddr_inst2_BRESP_0    ,  //Read response. This signal indicates the status of the read transfer.
input                           ddr_inst2_BVALID_0   ,  //Write response valid. This signal indicates that the channel is signaling a valid write response.

//DDR AXI 0 Read Address Channel
output  [32:0]                  ddr_inst2_ARADDR_0   ,  //Read address. It gives the address of the first transfer in a burst transaction.
output  [1:0]                   ddr_inst2_ARBURST_0  ,  //Burst type. The burst type and the size determine how the address for each transfer within the burst is calculated.
output  [5:0]                   ddr_inst2_ARID_0     ,  //Address ID. This signal identifies the group of address signals.
output  [7:0]                   ddr_inst2_ARLEN_0    ,  //Burst length. This signal indicates the number of transfers in a burst.
input                           ddr_inst2_ARREADY_0  ,  //Address ready. This signal indicates that the slave is ready to accept an address and associated control signals.
output  [2:0]                   ddr_inst2_ARSIZE_0   ,  //Burst size. This signal indicates the size of each transfer in the burst.
output                          ddr_inst2_ARVALID_0  ,  //Address valid. This signal indicates that the channel is signaling valid address and control information.
output                          ddr_inst2_ARLOCK_0   ,  //Lock type. This signal provides additional information about the atomic characteristics of the transfer.
output                          ddr_inst2_ARAPCMD_0  ,  //Read auto-precharge.
output                          ddr_inst2_ARQOS_0    ,  //QoS indentifier for read transaction.

//DDR AXI 0 Write Address Channel
output  [32:0]                  ddr_inst2_AWADDR_0   ,  //Write address. It gives the address of the first transfer in a burst transaction.
output  [1:0]                   ddr_inst2_AWBURST_0  ,  //Burst type. The burst type and the size determine how the address for each transfer within the burst is calculated.
output  [5:0]                   ddr_inst2_AWID_0     ,  //Address ID. This signal identifies the group of address signals.
output  [7:0]                   ddr_inst2_AWLEN_0    ,  //Burst length. This signal indicates the number of transfers in a burst.
input                           ddr_inst2_AWREADY_0  ,  //Address ready. This signal indicates that the slave is ready to accept an address and associated control signals.
output  [2:0]                   ddr_inst2_AWSIZE_0   ,  //Burst size. This signal indicates the size of each transfer in the burst.
output                          ddr_inst2_AWVALID_0  ,  //Address valid. This signal indicates that the channel is signaling valid address and control information.
output                          ddr_inst2_AWLOCK_0   ,  //Lock type. This signal provides additional information about the atomic characteristics of the transfer.
output                          ddr_inst2_AWAPCMD_0  ,  //Write auto-precharge.
output                          ddr_inst2_AWQOS_0    ,  //QoS indentifier for write transaction.
output  [3:0]                   ddr_inst2_AWCACHE_0  ,  //Memory type. This signal indicates how transactions are required to progress through a system.
output                          ddr_inst2_AWALLSTRB_0,  //Write all strobes asserted.
output                          ddr_inst2_AWCOBUF_0,     //Write coherent bufferable selection.

//PCIe Interface

input                           clk_100m,
input                           clk_200m,
input                           clk_250m,
input                           PLL_LOCKED,
input                           perst0,

input                           in_user,
output  wire                    q0_USER_PHY_RESET_N,
output  wire                    q0_USER_RESET_N_IN,
output  wire                    q0_RESET_ACK,
input                           q0_RESET_REQ,
input                           q0_HOT_RESET_OUT,
output  wire                    q0_USER_AXI_RESET_N,
//--Slave AXI4 Interface   
//----Slave AXI4 Write Interface
input           [63:0]          q0_TARGET_AXI_AWADDR,
input           [7:0]           q0_TARGET_AXI_AWID,
input           [7:0]           q0_TARGET_AXI_AWLEN,
input           [2:0]           q0_TARGET_AXI_AWSIZE,
input                           q0_TARGET_AXI_AWVALID,
input           [87:0]          q0_TARGET_AXI_AWUSER,
output  wire                    q0_TARGET_AXI_AWREADY,
input           [255:0]         q0_TARGET_AXI_WDATA,
input           [31:0]          q0_TARGET_AXI_WDATA_PAR,
input                           q0_TARGET_AXI_WLAST,
input           [31:0]          q0_TARGET_AXI_WSTRB,
input           [3:0]           q0_TARGET_AXI_WSTRB_PAR,
input                           q0_TARGET_AXI_WVALID,
output  wire                    q0_TARGET_AXI_WREADY,
output  wire    [7:0]           q0_TARGET_AXI_BID,
output  wire                    q0_TARGET_AXI_BID_PAR,
output  wire    [1:0]           q0_TARGET_AXI_BRESP,
output  wire                    q0_TARGET_AXI_BRESP_PAR,
output  wire                    q0_TARGET_AXI_BVALID,
input                           q0_TARGET_AXI_BREADY,
//----Slave AXI4 Read Interface
input           [63:0]          q0_TARGET_AXI_ARADDR,
input           [7:0]           q0_TARGET_AXI_ARID,
input           [7:0]           q0_TARGET_AXI_ARLEN,
input           [2:0]           q0_TARGET_AXI_ARSIZE,
input                           q0_TARGET_AXI_ARVALID,
input           [87:0]          q0_TARGET_AXI_ARUSER,
output  wire                    q0_TARGET_AXI_ARREADY,
output  wire    [255:0]         q0_TARGET_AXI_RDATA,
output  wire    [31:0]          q0_TARGET_AXI_RDATA_PAR,
output  wire    [7:0]           q0_TARGET_AXI_RID,
output  wire                    q0_TARGET_AXI_RID_PAR,
output  wire                    q0_TARGET_AXI_RLAST,
output  wire    [1:0]           q0_TARGET_AXI_RRESP,
output  wire                    q0_TARGET_AXI_RRESP_PAR,
output  wire                    q0_TARGET_AXI_RVALID,
input                           q0_TARGET_AXI_RREADY,
//----Slave AXI4 Sideband Interface
output  wire                    q0_TARGET_NON_POSTED_REJ,
//--Master AXI4 Interface   
//----Master AXI4 Write Interface
output  wire    [63:0]          q0_MASTER_AXI_AWADDR,
output  wire    [7:0]           q0_MASTER_AXI_AWID,
output  wire    [7:0]           q0_MASTER_AXI_AWLEN,
output  wire    [2:0]           q0_MASTER_AXI_AWSIZE,
output  wire                    q0_MASTER_AXI_AWVALID,
output  wire    [87:0]          q0_MASTER_AXI_AWUSER,
input                           q0_MASTER_AXI_AWREADY,
output  wire    [255:0]         q0_MASTER_AXI_WDATA,
output  wire    [31:0]          q0_MASTER_AXI_WDATA_PAR,
output  wire                    q0_MASTER_AXI_WLAST,
output  wire    [31:0]          q0_MASTER_AXI_WSTRB,
output  wire    [3:0]           q0_MASTER_AXI_WSTRB_PAR,
output  wire                    q0_MASTER_AXI_WVALID,
input                           q0_MASTER_AXI_WREADY,
input           [7:0]           q0_MASTER_AXI_BID,
input                           q0_MASTER_AXI_BID_PAR,
input           [1:0]           q0_MASTER_AXI_BRESP,
input                           q0_MASTER_AXI_BRESP_PAR,
input                           q0_MASTER_AXI_BVALID,
output  wire                    q0_MASTER_AXI_BREADY,
//----Master AXI4 Read Interface
output  wire    [63:0]          q0_MASTER_AXI_ARADDR,
output  wire    [7:0]           q0_MASTER_AXI_ARID,
output  wire    [7:0]           q0_MASTER_AXI_ARLEN,
output  wire    [2:0]           q0_MASTER_AXI_ARSIZE,
output  wire                    q0_MASTER_AXI_ARVALID,
output  wire    [87:0]          q0_MASTER_AXI_ARUSER,
input                           q0_MASTER_AXI_ARREADY,
input           [255:0]         q0_MASTER_AXI_RDATA,
input           [31:0]          q0_MASTER_AXI_RDATA_PAR,
input           [7:0]           q0_MASTER_AXI_RID,
input                           q0_MASTER_AXI_RID_PAR,
input                           q0_MASTER_AXI_RLAST,
input           [1:0]           q0_MASTER_AXI_RRESP,
input                           q0_MASTER_AXI_RRESP_PAR,
input                           q0_MASTER_AXI_RVALID,
output  wire                    q0_MASTER_AXI_RREADY,
//--Master APB3 Interface
output  wire    [23:0]          q0_USER_APB_PADDR,
output  wire                    q0_USER_APB_PSEL,
output  wire                    q0_USER_APB_PENABLE,
output  wire                    q0_USER_APB_PWRITE,
output  wire    [31:0]          q0_USER_APB_PWDATA,
output  wire    [3:0]           q0_USER_APB_PWDATA_PAR,
output  wire    [3:0]           q0_USER_APB_PSTRB,
output  wire                    q0_USER_APB_PSTRB_PAR,
input           [31:0]          q0_USER_APB_PRDATA,
input           [3:0]           q0_USER_APB_PRDATA_PAR,
input                           q0_USER_APB_PREADY,
input                           q0_USER_APB_PSLVERR,
//--FLR
input           [3:0]           q0_FLR_IN_PROGRESS,
output  wire    [3:0]           q0_FLR_DONE,
//--Interrupt Pin
input                           q0_LOCAL_INTERRUPT,
input           [27:0]          q0_INTERRUPT_SIDEBAND_SIGNALS,
//--Legacy Interrupt Pin
output  wire                    q0_INTA_IN,
output  wire                    q0_INTB_IN,
output  wire                    q0_INTC_IN,
output  wire                    q0_INTD_IN,
output  wire    [3:0]           q0_INT_PENDING_STATUS,
input                           q0_INT_ACK,
//--Message Pin
input           [255:0]         q0_MSG,
input           [31:0]          q0_MSG_BYTE_EN,
input                           q0_MSG_DATA,
input                           q0_MSG_END,
input           [21:0]          q0_MSG_PASID,
input                           q0_MSG_PASID_PRESENT,
input                           q0_MSG_START,
input                           q0_MSG_VALID,
input                           q0_MSG_VDH,
//--Error Pin
output  wire                    q0_CORRECTABLE_ERROR_IN,
output  wire                    q0_UNCORRECTABLE_ERROR_IN,
input                           q0_FATAL_ERROR_OUT,
input                           q0_NON_FATAL_ERROR_OUT,
input                           q0_CORRECTABLE_ERROR_OUT,
//--Status Pin
input           [5:0]           q0_LTSSM_STATE,
input                           q0_REG_ACCESS_CLK_SHUTOFF,
input                           q0_CORE_CLK_SHUTOFF,
input           [1:0]           q0_LINK_STATUS,
input           [15:0]          q0_FUNCTION_STATUS,
input           [2:0]           q0_PCIE_MAX_READ_REQ_SIZE,
input           [2:0]           q0_PCIE_MAX_PAYLOAD_SIZE,
input           [1:0]           q0_PIPE_P00_RATE,
input                           q0_PMA_CMN_READY,
//--Configuration Snoop Pin
output  wire    [31:0]          q0_CONFIG_READ_DATA,
output  wire    [3:0]           q0_CONFIG_READ_DATA_PAR,
output  wire                    q0_CONFIG_READ_DATA_VALID,
input                           q0_CONFIG_READ_RECEIVED,
input           [9:0]           q0_CONFIG_REG_NUM,
input           [3:0]           q0_CONFIG_WRITE_BYTE_ENABLE,
input                           q0_CONFIG_WRITE_BYTE_ENABLE_PAR,
input           [31:0]          q0_CONFIG_WRITE_DATA,
input           [3:0]           q0_CONFIG_WRITE_DATA_PAR,
input                           q0_CONFIG_WRITE_RECEIVED,
input           [7:0]           q0_CONFIG_FUNCTION_NUM,
input           [15:0]          q0_DEBUG_DATA_OUT,
input                           q0_FPGA_DIV2_CLK,
output  wire                    q0_FPGA_DIV2_CLK_io,

//XGMAC PHY XGMII Interface
//--Debug Signals
input                           Q1_PMA_CMN_READY,
//--Q1 APB3 interface
input            [31:0]         Q1_USER_APB_PRDATA,
input                           Q1_USER_APB_PREADY,
output           [23:0]         Q1_USER_APB_PADDR,
output           [31:0]         Q1_USER_APB_PWDATA,
output                          Q1_USER_APB_PWRITE,
output                          Q1_USER_APB_PSEL,
output                          Q1_USER_APB_PENABLE,
//--Q1 clk rerset interface
input                           Q1_L2_10gbe_clk,
output                          Q1_L2_PCS_RST_N_RX,
output                          Q1_L2_PCS_RST_N_TX,
output                          Q1_L2_PHY_RESET_N,
//--Q1 control interface
output                          Q1_L2_ETH_EEE_ALERT_EN,
output                          Q1_L2_PMA_TX_ELEC_IDLE,
//--Q1 power up interface
input           [3:0]           Q1_L2_PMA_XCVR_POWER_STATE_ACK,
input                           Q1_L2_PMA_XCVR_PLLCLK_EN_ACK,
input                           Q1_L2_PMA_RX_SIGNAL_DETECT,
output          [3:0]           Q1_L2_PMA_XCVR_POWER_STATE_REQ,
output                          Q1_L2_PMA_XCVR_PLLCLK_EN,
//--Q1 xgmii interface
input           [7:0]           Q1_L2_RXC,
input           [63:0]          Q1_L2_RXD,
output  wire    [63:0]          Q1_L2_TXD,
output  wire    [7:0]           Q1_L2_TXC,
//Optical Module Interface
output          [3:0]           SFP_TXDISABLE, 

input                           q0_LINK_DOWN_RESET_OUT
);

////////////////////////
// Variable Declaration
////////////////////////
localparam  PERI_FREQ       = 250;

localparam  VIDEO_MAX_HRES  = 11'd1920;
localparam  VIDEO_HSP       = 8'd44   ;
localparam  VIDEO_HBP       = 8'd148  ;
localparam  VIDEO_HFP       = 8'd88   ;

localparam  VIDEO_MAX_VRES  = 11'd1080;
localparam  VIDEO_VSP       = 6'd5    ;
localparam  VIDEO_VBP       = 6'd36   ;
localparam  VIDEO_VFP       = 6'd4    ;

// CSI Controller
localparam CSI_RX_PIXEL_DATAWIDTH     = CAM_PIXEL_RX_MEM_DATAWIDTH;
localparam CSI_RX_PIXEL_PER_CLK       = 4;
localparam CSI_RX_TOTAL_DATAWIDTH     = CSI_RX_PIXEL_DATAWIDTH * CSI_RX_PIXEL_PER_CLK;
localparam CSI_RX_NUM_DATA_LANE       = 2;
localparam CSI_RX_DATA_WIDTH_LANE     = 16;
localparam CAM_PIXEL_RX_DATAWIDTH     = 10;   //RAW10, RAW12
localparam CAM_PIXEL_RX_MEM_DATAWIDTH = 8;

//APB0 (DMA)
wire [15:0] io_apbSlave_0_PADDR    ;
wire        io_apbSlave_0_PSEL     ;
wire        io_apbSlave_0_PENABLE  ;
wire        io_apbSlave_0_PREADY   ;
wire        io_apbSlave_0_PWRITE   ;
wire [31:0] io_apbSlave_0_PWDATA   ;
wire [31:0] io_apbSlave_0_PRDATA   ;
wire        io_apbSlave_0_PSLVERROR;

//APB1
wire [19:0] io_apbSlave_1_PADDR    ;
wire        io_apbSlave_1_PSEL     ;
wire        io_apbSlave_1_PENABLE  ;
wire        io_apbSlave_1_PREADY   ;
wire        io_apbSlave_1_PWRITE   ;
wire [31:0] io_apbSlave_1_PWDATA   ;
wire [31:0] io_apbSlave_1_PRDATA   ;
wire        io_apbSlave_1_PSLVERROR;

//APB2 (eCNN)
wire [15:0] io_apbSlave_2_PADDR    ;
wire        io_apbSlave_2_PSEL     ;
wire        io_apbSlave_2_PENABLE  ;
wire        io_apbSlave_2_PREADY   ;
wire        io_apbSlave_2_PWRITE   ;
wire [31:0] io_apbSlave_2_PWDATA   ;
wire [31:0] io_apbSlave_2_PRDATA   ;
wire        io_apbSlave_2_PSLVERROR;

//APB3 (DMA Custom SG Desctipors)
wire [15:0] io_apbSlave_3_PADDR    ;
wire        io_apbSlave_3_PSEL     ;
wire        io_apbSlave_3_PENABLE  ;
wire        io_apbSlave_3_PREADY   ;
wire        io_apbSlave_3_PWRITE   ;
wire [31:0] io_apbSlave_3_PWDATA   ;
wire [31:0] io_apbSlave_3_PRDATA   ;
wire        io_apbSlave_3_PSLVERROR;



wire        cnn_calc_start;
wire        cnn_calc_end;

wire [5:0]  dma_interrupts;	
wire        w_hdmi_clk    ;

assign pll_osc_RSTN     =   1'b1;
assign pll_osc2_RSTN     =   1'b1;

assign w_hdmi_clk = i_hdmi_clk_148p5MHz; // HDMI Clock 148.5 MHz


wire [7:0]     Board_status;
wire [31:0]	   master_Control_Input_A;
wire [31:0]	   master_Control_Status_A;
wire [31:0]	   master_Control_Input_B;
wire [31:0]	   master_Control_Status_B;
wire [31:0]	   master_Control_Input_C;
wire [31:0]	   master_Control_Status_C;
wire [31:0]	   master_Control_Input_D;
wire [31:0]	   master_Control_Status_D;


//////////////////
//Configure AXI0//
//////////////////
assign soc_ddr_inst1_ARSTN_0 = ~io_systemReset;
wire [7:0] dma_arid;
wire [7:0] dma_awid;

assign dma_arid = 8'hE0;
assign dma_awid = 8'hE1;

assign soc_ddr_inst1_ARID_0 = {dma_arid[7:6], dma_arid[3:0]};
assign soc_ddr_inst1_AWID_0 = {dma_awid[7:6], dma_awid[3:0]};

assign soc_ddr_inst1_ARADDR_0[32] = 1'b0;
assign soc_ddr_inst1_AWADDR_0[32] = 1'b0;

assign soc_ddr_inst1_AWAPCMD_0 =   1'b0;
assign soc_ddr_inst1_ARAPCMD_0 =   1'b0;
assign soc_ddr_inst1_AWALLSTRB_0 = 1'b0;
assign soc_ddr_inst1_AWCOBUF_0   = 1'b0;

assign  io_peripheralClk     = prp_clk; 
assign  io_ddrMasters_0_clk  = clk_250m; 

//assign ddr_inst2_ARSTN_0 = ~io_systemReset;

////////////////
//Reset Related
//////////////////
wire io_asyncResetn_evsoc;
wire mipi_rstn;
wire i_arstn  ;

assign io_asyncResetn_evsoc   = ~io_asyncReset & pll_osc_LOCKED & pll_osc2_LOCKED & pll_hdmi_locked;
assign i_arstn                = (io_asyncResetn_evsoc & (!mipi_rstn));
assign o_cam_rstn             = i_arstn;

reg[31:0]  r_ref_count ;// (1Hz) 
reg r_ref_clk   ; 


always@(posedge i_sys_clk or negedge io_asyncResetn_evsoc)
begin
    if(!io_asyncResetn_evsoc)
    begin
        r_ref_count <= 'd0;
        r_ref_clk <= 1'b0;
    end
    else 
    begin
        r_ref_count <= r_ref_count +1'b1;
        if(r_ref_count >= 50*1000*1000)
        begin
            r_ref_count <= 'd0;
            r_ref_clk <= ~r_ref_clk;
        
        end 
       
    end 
end 


 
// Reset synchronizers
wire soc_prp_reset_out;     
common_reset #(
    .IN_RST_ACTIVE("HIGH"),
    .OUT_RST_ACTIVE("LOW"),
    .CYCLE(1)
) u_common_reset_prp_reset (
    .i_arst (io_peripheralReset),
	.i_clk  (prp_clk),
	.o_srst (soc_prp_reset_out)
);    


//q0_LINK_DOWN_RESET_OUT
// Reset synchronizers
wire soc_prp_linkdown_reset_out;     
common_reset #(
    .IN_RST_ACTIVE("HIGH"),
    .OUT_RST_ACTIVE("HIGH"),
    .CYCLE(1)
) u_common_soc_prp_linkdown_reset_out (
    .i_arst (q0_LINK_DOWN_RESET_OUT),
	.i_clk  (prp_clk),
	.o_srst (soc_prp_linkdown_reset_out)
);    

/*----------------------- Reset Region ----------------------------*/
//System Synchronize Reset
defparam u_sys_rstn.NUM_EXTERNAL_RESETS = 1;
defparam u_sys_rstn.NUM_DOMAINS = 4;
defparam u_sys_rstn.SEQUENTIAL_RELEASE = 1'b0; 

reset_control u_sys_rstn(
	.external_rstn                      ({PLL_LOCKED}                                                ),
	.clk                                ({clk_250m,io_memoryClk,Q1_L2_10gbe_clk,clk_100m}                ),
	.rstn                               ({clk_250m_rstn,clk_200m_rstn,clk_156m_rstn,clk_100m_rstn}   )
);



wire [31:0]                             debug_cam_display_fifo_status;
wire                                    debug_display_dma_fifo_underflow;
wire                                    debug_display_dma_fifo_overflow;
wire                                    wRstDebugReg;
wire [31:0]                             debug_display_dma_fifo_rcount; 
wire [31:0]                             debug_display_dma_fifo_wcount;

wire [2:0]	                            w_hdmi_i2c_state;
wire		                            w_hdmi_confdone;

wire                                    hdmi_yuv_vs;
wire                                    hdmi_yuv_hs;

assign                                  hdmi_yuv_vs_OE = !hdmi_yuv_vs;
assign                                  hdmi_yuv_hs_OE = !hdmi_yuv_hs;

assign                                  hdmi_yuv_vs_OUT = 0;
assign                                  hdmi_yuv_hs_OUT = 0;


wire                                    w_rx_out_de;

wire                                    w_rx_out_vs;
wire                                    w_rx_out_hs;


//Virtual Channel
wire [3:0]                              w_rx_out_vs_vc;
wire [3:0]                              w_rx_out_hs_vc;
reg [7:0]                               r_VirtualCh;
reg [7:0]                               r_vs_VirtualCh;
reg [7:0]                               r_hs_VirtualCh;
reg [7:0]                               w_VirtualCh;
reg [7:0]                               w_VirtualCh_ptr;



wire [6*8-1:0]        sg_out_control;
wire [6*8-1:0]        sg_in_control;

wire [7:0] sg_in_control_ch0; //Video Stream In 0  
wire [7:0] sg_in_control_ch1; //Video Stream In 1 
wire [7:0] sg_in_control_ch2; //Video Stream In 2 
wire [7:0] sg_in_control_ch3; //Video Stream In 3 
wire [7:0] sg_in_control_ch4; //Video Stream Out (Main)
wire [7:0] sg_in_control_ch5; //Video Stream Out (overlay)

wire [7:0] sg_out_control_ch0; //Video Stream In 0 
wire [7:0] sg_out_control_ch1; //Video Stream In 1 
wire [7:0] sg_out_control_ch2; //Video Stream In 2 
wire [7:0] sg_out_control_ch3; //Video Stream In 3 
wire [7:0] sg_out_control_ch4; //Video Stream Out (Main)
wire [7:0] sg_out_control_ch5; //Video Stream Out (overlay)


assign sg_in_control[0*8 +: 8] = sg_in_control_ch0;
assign sg_in_control[1*8 +: 8] = sg_in_control_ch1;
assign sg_in_control[2*8 +: 8] = sg_in_control_ch2;
assign sg_in_control[3*8 +: 8] = sg_in_control_ch3;
assign sg_in_control[4*8 +: 8] = sg_in_control_ch4;
assign sg_in_control[5*8 +: 8] = sg_in_control_ch5;

assign sg_out_control_ch0 = sg_out_control[0*8 +: 8];
assign sg_out_control_ch1 = sg_out_control[1*8 +: 8];
assign sg_out_control_ch2 = sg_out_control[2*8 +: 8];
assign sg_out_control_ch3 = sg_out_control[3*8 +: 8];
assign sg_out_control_ch4 = sg_out_control[4*8 +: 8];
assign sg_out_control_ch5 = sg_out_control[5*8 +: 8];






wire [CAM_PIXEL_RX_MEM_DATAWIDTH-1:0]   w_rx_out_data_00;
wire [CAM_PIXEL_RX_MEM_DATAWIDTH-1:0]   w_rx_out_data_01;
wire [CAM_PIXEL_RX_MEM_DATAWIDTH-1:0]   w_rx_out_data_10;
wire [CAM_PIXEL_RX_MEM_DATAWIDTH-1:0]   w_rx_out_data_11;
wire [5:0]                              rx_out_dt;

        


//DMA signals for eCNN pre-processing
localparam Dma2DataWidth = 64;
localparam Dma2KeepWidth = Dma2DataWidth / 8;

wire                     m_axis_dma2_TVALID;
wire                     m_axis_dma2_TREADY;
wire [Dma2DataWidth-1:0] m_axis_dma2_TDATA ;
wire [Dma2KeepWidth-1:0] m_axis_dma2_TKEEP ;
wire                     m_axis_dma2_TLAST ;
wire [              3:0] m_axis_dma2_TDEST ;

wire                     m_axis_dmafix_TVALID;
wire                     m_axis_dmafix_TREADY;
wire [Dma2DataWidth-1:0] m_axis_dmafix_TDATA ;
wire [Dma2KeepWidth-1:0] m_axis_dmafix_TKEEP ;
wire                     m_axis_dmafix_TLAST ;
wire [              3:0] m_axis_dmafix_TDEST ;

assign m_axis_dmafix_TVALID  = (&m_axis_dma2_TKEEP) & m_axis_dma2_TVALID;
assign m_axis_dma2_TREADY    = m_axis_dmafix_TREADY;
assign m_axis_dmafix_TDATA   = m_axis_dma2_TDATA;
assign m_axis_dmafix_TKEEP   = (&m_axis_dma2_TKEEP) ? {Dma2KeepWidth{1'b1}} : {Dma2KeepWidth{1'b0}};
assign m_axis_dmafix_TLAST   = m_axis_dma2_TLAST;
assign m_axis_dmafix_TDEST   = m_axis_dma2_TDEST;


localparam AxisDataWidth = 32;
localparam AxisKeepWidth = AxisDataWidth / 8;

wire                     m_axis_dmahalf_TVALID;
wire                     m_axis_dmahalf_TREADY;
wire [AxisDataWidth-1:0] m_axis_dmahalf_TDATA ;
wire [AxisKeepWidth-1:0] m_axis_dmahalf_TKEEP ;
wire                     m_axis_dmahalf_TLAST ;
wire [              3:0] m_axis_dmahalf_TDEST ;

wire                     m_axis_mscale_r_TVALID;
wire                     m_axis_mscale_r_TREADY;
wire [AxisDataWidth-1:0] m_axis_mscale_r_TDATA ;
wire [AxisKeepWidth-1:0] m_axis_mscale_r_TKEEP ;
wire                     m_axis_mscale_r_TLAST ;
wire [              3:0] m_axis_mscale_r_TDEST ;

wire                     m_axis_mscale_g_TVALID;
wire                     m_axis_mscale_g_TREADY;
wire [AxisDataWidth-1:0] m_axis_mscale_g_TDATA ;
wire [AxisKeepWidth-1:0] m_axis_mscale_g_TKEEP ;
wire                     m_axis_mscale_g_TLAST ;
wire [              3:0] m_axis_mscale_g_TDEST ;

wire                     m_axis_mscale_b_TVALID;
wire                     m_axis_mscale_b_TREADY;
wire [AxisDataWidth-1:0] m_axis_mscale_b_TDATA ;
wire [AxisKeepWidth-1:0] m_axis_mscale_b_TKEEP ;
wire                     m_axis_mscale_b_TLAST ;
wire [              3:0] m_axis_mscale_b_TDEST ;

/////////////////////
//AXI CNN SIGNAL
/////////////////////
localparam CnnIdWidth = 3;
localparam CnnDataWidth = 128;
localparam CnnStrbWidth = CnnDataWidth / 8;

/* CNN AXI master */
wire [  CnnIdWidth-1:0] axi_cnn_AWID   ;
wire [  CnnIdWidth-1:0] axi_cnn_ARID   ;
wire [            31:0] axi_cnn_AWADDR ;
wire [            31:0] axi_cnn_ARADDR ;
wire [             7:0] axi_cnn_AWLEN  ;
wire [             7:0] axi_cnn_ARLEN  ;
wire [             2:0] axi_cnn_AWSIZE ;
wire [             2:0] axi_cnn_ARSIZE ;
wire [             1:0] axi_cnn_AWBURST;
wire [             1:0] axi_cnn_ARBURST;
wire                    axi_cnn_AWLOCK ;
wire                    axi_cnn_ARLOCK ;
wire [             3:0] axi_cnn_AWCACHE;
wire [             3:0] axi_cnn_ARCACHE;
wire [             2:0] axi_cnn_AWPROT ;
wire [             2:0] axi_cnn_ARPROT ;
wire [             3:0] axi_cnn_AWQOS   , axi_cnn_ARQOS   ;
wire [             3:0] axi_cnn_AWREGION, axi_cnn_ARREGION;

wire [  CnnIdWidth-1:0] axi_cnn_BID  ;
wire [  CnnIdWidth-1:0] axi_cnn_RID  ;
wire [CnnDataWidth-1:0] axi_cnn_WDATA;
wire [CnnDataWidth-1:0] axi_cnn_RDATA;
wire [CnnStrbWidth-1:0] axi_cnn_WSTRB;
wire [             1:0] axi_cnn_BRESP;
wire [             1:0] axi_cnn_RRESP;
wire                    axi_cnn_WLAST;
wire                    axi_cnn_RLAST;
wire axi_cnn_AWVALID, axi_cnn_ARVALID, axi_cnn_WVALID, axi_cnn_BVALID, axi_cnn_RVALID;
wire axi_cnn_AWREADY, axi_cnn_ARREADY, axi_cnn_WREADY, axi_cnn_BREADY, axi_cnn_RREADY;

// Camera Input Prepocessing
wire [63:0]     w_mapped_raw_data;





// Adding PCIE DMA signals
wire                            clk_250m_rstn;
wire                            clk_200m_rstn;
wire                            clk_156m_rstn;
wire                            clk_100m_rstn;


//AXI Stream Master  
wire           tx_src_axis_tready;
wire [63:0]   tx_src_axis_tdata  ;
wire          tx_src_axis_tvalid ;
wire          tx_src_axis_tlast  ;

wire          rx_src_axis_tready ;
wire [63:0]   rx_src_axis_tdata  ;
wire          rx_src_axis_tvalid ;
wire          rx_src_axis_tlast  ;

wire          l2_rx_axis_mac_tkeep;

//apb3 slave interface for MAC (encoded Address range inside edma module).  
wire  [9:0]    mac_l2_apb3_paddr ;
wire           mac_l2_apb3_psel  ;
wire           mac_l2_apb3_penable;
wire           mac_l2_apb3_pready;
wire           mac_l2_apb3_pwrite;//0:rd; 1:wr;
wire  [31:0]   mac_l2_apb3_pwdata;
wire  [31:0]   mac_l2_apb3_prdata;
wire           mac_l2_apb3_pslverror;  

//Debugging by vio
wire          rstn_vio         ;
wire          q0_apb_start     ;
wire [ 23:0]  q0_paddr_test    ;
wire [ 31:0]  q0_pwdata_vio    ;
wire [  3:0]  q0_pwdata_par_vio;
wire          q0_write_vio     ;
wire [  3:0]  q0_obs_pstates   ;
wire  [31:0]  q0_prdata_test   ; 
wire          q0_apb_done      ;  




//Probe Signals for S0_AXI and S1_AXI
wire                            debug_ddr_err       ;
wire                            debug_ddr_rd_err    ;
wire  [63:0]                    debug_data_rev      ;
wire  [15:0]                    debug_data_err_temp ; 

//----Probe Signals for Slave AXI4 Sideband Interface

wire                            debug_s0_axi_awvalid;
wire                            debug_s0_axi_awready;
wire    [63:0]                  debug_s0_axi_awaddr ;
wire    [7:0]                   debug_s0_axi_awlen  ;
wire                            debug_s0_axi_wvalid ;
wire                            debug_s0_axi_wready ;
wire    [255:0]                 debug_s0_axi_wdata  ;
wire    [31:0]                  debug_s0_axi_wstrb  ;
wire                            debug_s0_axi_wlast  ;
wire                            debug_s0_axi_bvalid ;
wire                            debug_s0_axi_bready ;
wire    [1:0]                   debug_s0_axi_bresp  ;
wire                            debug_s0_axi_arvalid;
wire                            debug_s0_axi_arready;
wire    [63:0]                  debug_s0_axi_araddr ;
wire    [7:0]                   debug_s0_axi_arlen  ;
wire                            debug_s0_axi_rvalid ;
wire                            debug_s0_axi_rready ;
wire    [255:0]                 debug_s0_axi_rdata  ;
wire                            debug_s0_axi_rlast  ;
wire    [1:0]                   debug_s0_axi_rresp  ;

wire                            debug_s1_axi_awvalid;
wire                            debug_s1_axi_awready;
wire    [63:0]                  debug_s1_axi_awaddr ;
wire    [7:0]                   debug_s1_axi_awlen  ;
wire                            debug_s1_axi_wvalid ;
wire                            debug_s1_axi_wready ;
wire    [63:0]                  debug_s1_axi_wdata  ;
wire    [7:0]                   debug_s1_axi_wstrb  ;
wire                            debug_s1_axi_wlast  ;
wire                            debug_s1_axi_bvalid ;
wire                            debug_s1_axi_bready ;
wire    [1:0]                   debug_s1_axi_bresp  ;
wire                            debug_s1_axi_arvalid;
wire                            debug_s1_axi_arready;
wire    [63:0]                  debug_s1_axi_araddr ;
wire    [7:0]                   debug_s1_axi_arlen  ;
wire                            debug_s1_axi_rvalid ;
wire                            debug_s1_axi_rready ;
wire    [63:0]                  debug_s1_axi_rdata  ;
wire                            debug_s1_axi_rlast  ;
wire    [1:0]                   debug_s1_axi_rresp  ;
wire    [7:0]                   debug_l2_rx_axis_mac_tkeep;



//DDR AXI 0 Read Data Channel
wire  [127:0]                 ecnn_DMA_RDATA_0    ;  //Read data.
wire  [5:0]                   ecnn_DMA_RID_0      ;  //Read ID tag. This signal is the identification tag for the read data group of signals generated by the slave.
wire                          ecnn_DMA_RLAST_0    ;  //Read last. This signal indicates the last transfer in a read burst.
wire                          ecnn_DMA_RREADY_0   ;  //Read ready. This signal indicates that the master can accept the read data and response information.
wire  [1:0]                   ecnn_DMA_RRESP_0    ;  //Read response. This signal indicates the status of the read transfer.
wire                          ecnn_DMA_RVALID_0   ;  //Read valid. This signal indicates that the channel is signaling the required read data.

//DDR AXI 0 Write Data Channel 
wire  [127:0]                 ecnn_DMA_WDATA_0    ;  //Write data. AXI4 port 0 is 256, port 1 is 128.
wire                          ecnn_DMA_WLAST_0    ;  //Write last. This signal indicates the last transfer in a write burst.
wire                          ecnn_DMA_WREADY_0   ;  //Write ready. This signal indicates that the slave can accept the write data.
wire  [15:0]                  ecnn_DMA_WSTRB_0    ;  //Write strobes. This signal indicates which byte lanes hold valid data. There is one write strobe bit for each eight bits of the write data bus.
wire                          ecnn_DMA_WVALID_0   ;  //Write valid. This signal indicates that valid write data and strobes are available.
   
   
//DDR AXI 0 Wrtie Response Channel
wire  [5:0]                   ecnn_DMA_BID_0      ;  //Response ID tag. This signal is the ID tag of the write response.
wire                          ecnn_DMA_BREADY_0   ;  //Response ready. This signal indicates that the master can accept a write response.
wire  [1:0]                   ecnn_DMA_BRESP_0    ;  //Read response. This signal indicates the status of the read transfer.
wire                          ecnn_DMA_BVALID_0   ;  //Write response valid. This signal indicates that the channel is signaling a valid write response.

//DDR AXI 0 Read Address Channel
wire  [31:0]                  ecnn_DMA_ARADDR_0   ;  //Read address. It gives the address of the first transfer in a burst transaction.
wire  [1:0]                   ecnn_DMA_ARBURST_0  ;  //Burst type. The burst type and the size determine how the address for each transfer within the burst is calculated.
wire  [5:0]                   ecnn_DMA_ARID_0     ;  //Address ID. This signal identifies the group of address signals.
wire  [7:0]                   ecnn_DMA_ARLEN_0    ;  //Burst length. This signal indicates the number of transfers in a burst.
wire                          ecnn_DMA_ARREADY_0  ;  //Address ready. This signal indicates that the slave is ready to accept an address and associated control signals.
wire  [2:0]                   ecnn_DMA_ARSIZE_0   ;  //Burst size. This signal indicates the size of each transfer in the burst.
wire                          ecnn_DMA_ARVALID_0  ;  //Address valid. This signal indicates that the channel is signaling valid address and control information.
wire                          ecnn_DMA_ARLOCK_0   ;  //Lock type. This signal provides additional information about the atomic characteristics of the transfer.
wire                          ecnn_DMA_ARAPCMD_0  ;  //Read auto-precharge.
wire                          ecnn_DMA_ARQOS_0    ;  //QoS indentifier for read transaction.
wire  [2:0]                   ecnn_DMA_ARPROT_0   ;
wire  [3:0]                   ecnn_DMA_ARCACHE_0  ;
wire  [3:0]                   ecnn_DMA_ARREGION_0 ;

//DDR AXI 0 Write Address Channel
wire  [31:0]                  ecnn_DMA_AWADDR_0   ;  //Write address. It gives the address of the first transfer in a burst transaction.
wire  [1:0]                   ecnn_DMA_AWBURST_0  ;  //Burst type. The burst type and the size determine how the address for each transfer within the burst is calculated.
wire  [5:0]                   ecnn_DMA_AWID_0     ;  //Address ID. This signal identifies the group of address signals.
wire  [7:0]                   ecnn_DMA_AWLEN_0    ;  //Burst length. This signal indicates the number of transfers in a burst.
wire                          ecnn_DMA_AWREADY_0  ;  //Address ready. This signal indicates that the slave is ready to accept an address and associated control signals.
wire  [2:0]                   ecnn_DMA_AWSIZE_0   ;  //Burst size. This signal indicates the size of each transfer in the burst.
wire                          ecnn_DMA_AWVALID_0  ;  //Address valid. This signal indicates that the channel is signaling valid address and control information.
wire                          ecnn_DMA_AWLOCK_0   ;  //Lock type. This signal provides additional information about the atomic characteristics of the transfer.
wire                          ecnn_DMA_AWAPCMD_0  ;  //Write auto-precharge.
wire                          ecnn_DMA_AWQOS_0    ;  //QoS indentifier for write transaction.
wire  [3:0]                   ecnn_DMA_AWCACHE_0  ;  //Memory type. This signal indicates how transactions are required to progress through a system.
wire                          ecnn_DMA_AWALLSTRB_0;  //Write all strobes asserted.
wire                          ecnn_DMA_AWCOBUF_0  ;     //Write coherent bufferable selection.
wire  [2:0]                   ecnn_DMA_AWPROT_0   ;
wire  [3:0]                   ecnn_DMA_AWREGION_0 ;
`ifndef  HARD_DPHY_RX       

////////////////////////////////////////////////////////////////
// MIPI RX - Camera
wire  [7:0]                             w_cam_d0_HS_IN;
wire  [7:0]                             w_cam_d1_HS_IN;
reg                                     w_cam_confdone;
wire                                    w_cam_ck_HS_ENA_0;
wire                                    w_cam_ck_HS_TERM_0;
wire  [1:0]                             w_cam_d_HS_ENA_0;

wire  [5:0]                             w_mipi_rx_dt;
wire                                    w_mipi_rx_vs;
wire                                    w_mipi_rx_hs;
wire                                    w_mipi_rx_de;
wire  [63:0]                            w_mipi_rx_data;

reg   [10:0]                            r_rx_x_mipi;
reg   [10:0]                            r_rx_y_mipi;
reg                                     r_rx_hs;
reg                                     r_rx_vs;  


(* async_reg = "true" *)reg   [1:0]    r_mipi_rx_data_LP_P_IN_0_1P;
(* async_reg = "true" *)reg   [1:0]    r_mipi_rx_data_LP_N_IN_0_1P;
(* async_reg = "true" *)reg   [15:0]   r_mipi_rx_data_HS_IN_0_1P;
(* async_reg = "true" *)reg   [1:0]    r_mipi_rx_data_LP_P_IN_0_2P;
(* async_reg = "true" *)reg   [1:0]    r_mipi_rx_data_LP_N_IN_0_2P;
(* async_reg = "true" *)reg   [15:0]   r_mipi_rx_data_HS_IN_0_2P;

////////////////////////////////////////////////////////////////
// MIPI CSI RX Channel - Camera

always@(negedge i_arstn or posedge cam_ck_CLKOUT)
begin
   if (~i_arstn)
   begin
      r_mipi_rx_data_LP_P_IN_0_1P   <= 2'b0;
      r_mipi_rx_data_LP_N_IN_0_1P   <= 2'b0;
      r_mipi_rx_data_HS_IN_0_1P     <= {16{1'b0}};
      
      r_mipi_rx_data_LP_P_IN_0_2P   <= 2'b0;
      r_mipi_rx_data_LP_N_IN_0_2P   <= 2'b0;
      r_mipi_rx_data_HS_IN_0_2P     <= {16{1'b0}};
   end
   else
   begin
      r_mipi_rx_data_LP_P_IN_0_1P   <= {cam_d1_LP_P_IN, cam_d0_LP_P_IN}; 
      r_mipi_rx_data_LP_N_IN_0_1P   <= {cam_d1_LP_N_IN, cam_d0_LP_N_IN};
      r_mipi_rx_data_HS_IN_0_1P     <= {w_cam_d1_HS_IN[7:0], w_cam_d0_HS_IN[7:0]};
               
      r_mipi_rx_data_LP_P_IN_0_2P   <= r_mipi_rx_data_LP_P_IN_0_1P;
      r_mipi_rx_data_LP_N_IN_0_2P   <= r_mipi_rx_data_LP_N_IN_0_1P;
      r_mipi_rx_data_HS_IN_0_2P     <= r_mipi_rx_data_HS_IN_0_1P;
   end
end

assign   w_cam_d0_HS_IN    = {cam_d0_HS_IN_3, cam_d0_HS_IN_2, cam_d0_HS_IN_1, cam_d0_HS_IN};
assign   w_cam_d1_HS_IN    = {cam_d1_HS_IN_3, cam_d1_HS_IN_2, cam_d1_HS_IN_1, cam_d1_HS_IN};

assign   cam_ck_HS_TERM  = w_cam_ck_HS_ENA_0;
assign   cam_ck_HS_ENA   = w_cam_ck_HS_ENA_0;
assign   cam_d0_HS_TERM  = w_cam_d_HS_ENA_0[0];
assign   cam_d1_HS_TERM  = w_cam_d_HS_ENA_0[1];
assign   cam_d0_HS_ENA   = w_cam_d_HS_ENA_0[0];
assign   cam_d1_HS_ENA   = w_cam_d_HS_ENA_0[1];
assign   cam_d0_RST      = ~i_arstn;
assign   cam_d1_RST      = ~i_arstn;     


 
assign sg_in_control_ch0  =  r_VirtualCh[0*8 +: 8];

assign w_rx_out_hs =  (w_rx_out_hs_vc!='d0)?1'b1:1'b0;
assign w_rx_out_vs =  (w_rx_out_vs_vc!='d0)?1'b1:1'b0;

        always @(posedge i_pixel_clk or negedge i_arstn) begin
            if (!i_arstn)
            begin
                r_vs_VirtualCh <= 'd0;
            end
            else 
            begin 
                case (w_rx_out_vs_vc)
                    4'b0001: r_vs_VirtualCh = 'd0;   // case 0
                    4'b0010: r_vs_VirtualCh = 'd1;   // case 1
                    4'b0100: r_vs_VirtualCh = 'd2;   // case 2
                    4'b1000: r_vs_VirtualCh = 'd3;   // case 2
                    default: r_vs_VirtualCh = r_vs_VirtualCh; // default case
                endcase
            end 
        end

        always @(posedge i_pixel_clk or negedge i_arstn) begin
            if (!i_arstn)
            begin
                r_hs_VirtualCh <= 'd0;
            end
            else 
            begin 
                case (w_rx_out_hs_vc)
                    4'b0001: r_hs_VirtualCh = 'd0;   // case 0
                    4'b0010: r_hs_VirtualCh = 'd1;   // case 1
                    4'b0100: r_hs_VirtualCh = 'd2;   // case 2
                    4'b1000: r_hs_VirtualCh = 'd3;   // case 2
                    default: r_hs_VirtualCh = r_hs_VirtualCh; // default case
                endcase
            end 
        end
     always @(posedge i_pixel_clk or negedge i_arstn) begin
            if (!i_arstn)
            begin
                r_VirtualCh <= 'd0;
            end
            else 
            begin 
                if(r_VirtualCh != r_vs_VirtualCh)
                begin 
                    r_VirtualCh <= r_vs_VirtualCh;
                end 
               /* else if(r_VirtualCh != r_hs_VirtualCh)
                begin
                     r_VirtualCh <= r_hs_VirtualCh;
                end*/ 
                else 
                begin
                    r_VirtualCh <= r_VirtualCh;
                end 
            
            
            end 
        end
        
csi2_rx_cam #(
) u_csi2_rx_cam (
   .reset_n             (i_arstn      ),
   .clk                 (i_pixel_clk  ),
   .reset_byte_HS_n     (i_arstn      ),
   .clk_byte_HS         (cam_ck_CLKOUT),
   .reset_pixel_n       (i_arstn      ),
   .clk_pixel           (i_pixel_clk  ),
   
   .Rx_LP_CLK_P         (cam_ck_LP_P_IN    ),
   .Rx_LP_CLK_N         (cam_ck_LP_N_IN    ),
   .Rx_HS_enable_C      (w_cam_ck_HS_ENA_0 ),
   .LVDS_termen_C       (w_cam_ck_HS_TERM_0),

   .Rx_LP_D_P           (r_mipi_rx_data_LP_P_IN_0_2P    ),
   .Rx_LP_D_N           (r_mipi_rx_data_LP_N_IN_0_2P    ),
   .Rx_HS_D_0           (r_mipi_rx_data_HS_IN_0_2P[7:0] ),
   .Rx_HS_D_1           (r_mipi_rx_data_HS_IN_0_2P[15:8]),
   .Rx_HS_D_2           (),
   .Rx_HS_D_3           (),
   .Rx_HS_D_4           (),
   .Rx_HS_D_5           (),
   .Rx_HS_D_6           (),
   .Rx_HS_D_7           (),
   .Rx_HS_enable_D      (w_cam_d_HS_ENA_0),
   .LVDS_termen_D       (),
   .fifo_rd_enable      ({cam_d1_FIFO_RD,    cam_d0_FIFO_RD}),
   .fifo_rd_empty       ({cam_d1_FIFO_EMPTY, cam_d0_FIFO_EMPTY}),
   .DLY_enable_D        (),
   .DLY_inc_D           (),
   .u_dly_enable_D      (),
   .u_dly_inc_D         (),
   
   .axi_clk             (1'b0),
   .axi_reset_n         (1'b0),
   .axi_awaddr          (6'b0),
   .axi_awvalid         (1'b0),
   .axi_awready         (),
   .axi_wdata           (32'b0),
   .axi_wvalid          (1'b0),
   .axi_wready          (),
   
   .axi_bvalid          (),
   .axi_bready          (1'b0),
   .axi_araddr          (6'b0),
   .axi_arvalid         (1'b0),
   .axi_arready         (),
   .axi_rdata           (),
   .axi_rvalid          (),
   .axi_rready          (1'b0),
   
   .hsync_vc0           (w_rx_out_hs_vc[0]),
   .hsync_vc1           (w_rx_out_hs_vc[1]),
   .hsync_vc2           (w_rx_out_hs_vc[2]),
   .hsync_vc3           (w_rx_out_hs_vc[3]),
   .hsync_vc4           (),
   .hsync_vc5           (),
   .hsync_vc6           (),
   .hsync_vc7           (),
   .hsync_vc8           (),
   .hsync_vc9           (),
   .hsync_vc10          (),
   .hsync_vc11          (),
   .hsync_vc12          (),
   .hsync_vc13          (),
   .hsync_vc14          (),
   .hsync_vc15          (),
   .vsync_vc0           (w_rx_out_vs_vc[0]),
   .vsync_vc1           (w_rx_out_vs_vc[1]),
   .vsync_vc2           (w_rx_out_vs_vc[2]),
   .vsync_vc3           (w_rx_out_vs_vc[3]),
   .vsync_vc4           (),
   .vsync_vc5           (),
   .vsync_vc6           (),
   .vsync_vc7           (),
   .vsync_vc8           (),
   .vsync_vc9           (),
   .vsync_vc10          (),
   .vsync_vc11          (),
   .vsync_vc12          (),
   .vsync_vc13          (),
   .vsync_vc14          (),
   .vsync_vc15          (),
   .vc                  (),
   .vcx                 (),
   .word_count          (),
   .shortpkt_data_field (),
   .datatype            (rx_out_dt),
   .pixel_per_clk       (),
   .pixel_data          (w_mapped_raw_data),
   .pixel_data_valid    (w_rx_out_de      ),
   .irq                 ()
);

`else 
assign sg_in_control_ch0  =  w_VirtualCh[0*8 +: 8];
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

//csi_rx_controllers #(
csi_rx_controllers_VirtualCh #(
	.NUM_CHANNEL(1),
    .NUM_RX_PER_CHANNEL(CSI_RX_NUM_DATA_LANE),
    .DATAWIDTH_PER_CHANNEL(CSI_RX_DATA_WIDTH_LANE),
	.PIXEL_RX_DATAWIDTH(CAM_PIXEL_RX_DATAWIDTH),	//RAW10, RAW12
    .PIXEL_OUT_DATAWIDTH(CAM_PIXEL_RX_MEM_DATAWIDTH)	//DATAWIDTH will be store to Memory
)
inst_csi_rx_controllers
(

    .rstn(i_arstn),
    .clk(i_pixel_clk),// .clk(i_sys_clk_100mhz),		  //For Controller Clock 100mhz
    .clk_pixel(i_pixel_clk),// .clk_pixel(i_pixel_clk), //pixel clock for 4K@60 min. 220Mhz
    .i_ref_clk(r_ref_clk),
  // DPHY interface port
	
    .clk_byte_HS	({rx_pclk_0}),
    .reset_byte_HS_n({rx_reset_byte_HS_n_0}),
	.resetb_rx		({resetb_rx_0}),
        
    .RxDataHS0( {RxDataHS_0[0]}),  //full 16 bit
    .RxDataHS1( {RxDataHS_0[1]}),
    .RxValidHS0({RxValidHS_0[0]}),
    .RxValidHS1({RxValidHS_0[1]}),
    `ifdef CSI_RX_4LANES
    .RxDataHS2( {RxDataHS_0[2]}),
    .RxDataHS3( {RxDataHS_0[3]}),
    .RxValidHS2({RxValidHS_0[2]}),
    .RxValidHS3({RxValidHS_0[3]}),
    `endif
    
    .RxSyncHS           ({RxSyncHS_0 }),
    .RxUlpsClkNot		({RxUlpsClkNot_0		}),
    .RxUlpsActiveClkNot	({RxUlpsActiveClkNot_0}),
    .RxErrEsc		    ({RxErrEsc_0	      }),
    .RxErrControl	    ({RxErrControl_0    }),
    .RxErrSotSyncHS	    ({RxErrSotSyncHS_0  }),
    .RxUlpsEsc		    ({RxUlpsEsc_0       }),
    .RxUlpsActiveNot    ({RxUlpsActiveNot_0 }),
    .RxSkewCalHS	    ({RxSkewCalHS_0     }),
    .RxStopState	    ({RxStopState_0     }),

  // CSI controller ouptut interface port
    
    .rx_datatype(rx_out_dt),
    .rx_out_de(w_rx_out_de),
    .rx_out_vs(w_rx_out_vs),
    .rx_out_hs(w_rx_out_hs),
    .rx_virtual_ch(w_VirtualCh),
   // .rx_virtual_ch_ptr(w_VirtualCh_ptr),
    
  //.rx_out_data_00(),
  //.rx_out_data_01(),
  //.rx_out_data_10(),
  //.rx_out_data_11(),
    
    .rx_out_data_full(w_mapped_raw_data)
);



`endif

wire            cam_dma_wready   ;
wire            cam_dma_wvalid   ;
wire            cam_dma_wlast    ;
wire [63:0]     cam_dma_wdata    ;

wire            stream_wr_en_ch0  ;
wire [48-1:0]   stream_wr_data_ch0;
wire            stream_wr_en_ch1  ;
wire [48-1:0]   stream_wr_data_ch1;

// Picam Debug register to APB status registers.
wire            debug_cam_dma_fifo_overflow ;
wire            debug_cam_dma_fifo_underflow;
wire [31:0]     debug_cam_dma_fifo_rcount   ;
wire [31:0]     debug_cam_dma_fifo_wcount   ;
wire [31:0]     debug_cam_dma_status        ;

wire            debug_cam_pixel_remap_fifo_underflow;
wire            debug_cam_pixel_remap_fifo_overflow ;

//cam_picam & hdmi
wire [15:0]     rgb_control;
wire            trigger_capture_frame;
wire            continuous_capture_frame;
wire            rgb_gray;
wire            cam_dma_init_done;
wire [31:0]     frames_per_second;
wire [31:0]     set_offset_display_rgb;
wire            hw_accel_dma_init_done;

wire            hw_accel_dma_init_done_ch0;
wire            hw_accel_dma_init_done_ch1;

cam_picam # (
    .MIPI_FRAME_WIDTH                       (MIPI_FRAME_WIDTH),             //Input frame resolution from MIPI
    .MIPI_FRAME_HEIGHT                      (MIPI_FRAME_HEIGHT),            //Input frame resolution from MIPI
    .FRAME_WIDTH                            (FRAME_WIDTH),                  //Output frame resolution to external memory
    .FRAME_HEIGHT                           (FRAME_HEIGHT),                 //Output frame resolution to external memory
    .DMA_TRANSFER_LENGTH                    ((FRAME_WIDTH*FRAME_HEIGHT)/2), //2PPC
    .MIPI_PCLK_CLK_RATE                     (32'd100_000_000)               // as mipi_pclk is 100MHz
) u_cam (
    .mipi_pclk                              (i_pixel_clk      ),
    .rst_n                                  (i_arstn          ),
    .mipi_cam_data                          (w_mapped_raw_data),
    .mipi_cam_valid                         (w_rx_out_de      ),
    .mipi_cam_vs                            (w_rx_out_vs      ),
    .mipi_cam_hs                            (w_rx_out_hs      ),
    .mipi_cam_type                          (rx_out_dt)       ,
    
    .stream_wr_en_ch0                       (stream_wr_en_ch0  ),
    .stream_wr_data_ch0                     (stream_wr_data_ch0),
    .stream_wr_en_ch1                       (stream_wr_en_ch1  ),
    .stream_wr_data_ch1                     (stream_wr_data_ch1), 

    .cam_dma_wready                         (cam_dma_wready),
    .cam_dma_wvalid                         (cam_dma_wvalid),
    .cam_dma_wlast                          (cam_dma_wlast ),
    .cam_dma_wdata                          (cam_dma_wdata ),

    .rgb_control                            (rgb_control),
    .trigger_capture_frame                  (trigger_capture_frame),
    .continuous_capture_frame               (continuous_capture_frame),
    .rgb_gray                               (rgb_gray),
    .cam_dma_init_done                      (cam_dma_init_done),
    .frames_per_second                      (frames_per_second),
    .debug_cam_pixel_remap_fifo_overflow    (debug_cam_pixel_remap_fifo_overflow ),
    .debug_cam_pixel_remap_fifo_underflow   (debug_cam_pixel_remap_fifo_underflow),
    .debug_cam_dma_fifo_overflow            (debug_cam_dma_fifo_overflow         ),
    .debug_cam_dma_fifo_underflow           (debug_cam_dma_fifo_underflow        ),
    .debug_cam_dma_fifo_rcount              (debug_cam_dma_fifo_rcount           ),
    .debug_cam_dma_fifo_wcount              (debug_cam_dma_fifo_wcount           ),
    .debug_cam_dma_status                   (debug_cam_dma_status                )
);


/////////////
// Camera I2C
/////////////
/* I2C initialization for ADV7511 */
display_hdmi_adv7511_config #(
    .INITIAL_CODE   ("source/display/hdmi/display_hdmi_adv7511_reg.mem")
) inst_adv7511_config (
    .i_arst         (~i_arstn),
    .i_sysclk       (i_sys_clk_25mhz),
    .i_pll_locked   (pll_system_locked),
    .o_state        (),
    .o_confdone     (w_hdmi_confdone),
    
    .i_sda          (i_hdmi_sda   ),
    .o_sda_oe       (o_hdmi_sda_oe),
    .i_scl          (i_hdmi_scl   ),
    .o_scl_oe       (o_hdmi_scl_oe),
    .o_rstn         ()
);


// Display Hdmi                 
wire [63:0]      display_dma_rdata;
wire             display_dma_rvalid;
wire [7:0]       display_dma_rkeep;
wire             display_dma_rready;

// Diplay post process from DMA to HDMI Port
display_hdmi_yuv #(
    .FRAME_WIDTH     (FRAME_WIDTH ),
    .FRAME_HEIGHT    (FRAME_HEIGHT),

    .VIDEO_MAX_HRES  (VIDEO_MAX_HRES),
    .VIDEO_HSP       (VIDEO_HSP     ),
    .VIDEO_HBP       (VIDEO_HBP     ),
    .VIDEO_HFP       (VIDEO_HFP     ),

    .VIDEO_MAX_VRES  (VIDEO_MAX_VRES),
    .VIDEO_VSP       (VIDEO_VSP     ),
    .VIDEO_VBP       (VIDEO_VBP     ),
    .VIDEO_VFP       (VIDEO_VFP     )
    
) inst_display_hdmi_yuv(
    .iHdmiClk                           (w_hdmi_clk),
    .iRst_n                             (i_arstn),
    
    // control offset display to red or green 
    .set_offset_display_rgb             (set_offset_display_rgb),
    
    //DMA RGB Input
    .ivDisplayDmaRdData                 (display_dma_rdata ),
    .iDisplayDmaRdValid                 (display_dma_rvalid),
    .iv7DisplayDmaRdKeep                (8'hFF),
    .oDisplayDmaRdReady                 (display_dma_rready),
    
    // Status.
    .iRstDebugReg                       (1'b0),
    .oDebugDisplayDmaFifoUnderflow      (debug_display_dma_fifo_underflow),
    .oDebugDisplayDmaFifoOverflow       (debug_display_dma_fifo_overflow ),
    .ov32DebugDisplayDmaFifoRCount      (debug_display_dma_fifo_rcount   ), 
    .ov32DebugDisplayDmaFifoWCount      (debug_display_dma_fifo_wcount   ),

    // Output to HDMI
    .oHdmiYuvVs                         (hdmi_yuv_vs ),
    .oHdmiYuvHs                         (hdmi_yuv_hs ),
    .oHdmiYuvDe                         (hdmi_yuv_de ),
    .ov16HdmiYuvData                    (hdmi_yuv_data)
);


// Display Hdmi
wire             bbox_dma_tvalid;
wire             bbox_dma_tready;
wire [63:0]      bbox_dma_tdata;
wire [7:0]       bbox_dma_tkeep;
wire [3:0]       bbox_dma_tdest;
wire             bbox_dma_tlast;


display_annotator #(
   .FRAME_WIDTH  (FRAME_WIDTH),
   .FRAME_HEIGHT (FRAME_HEIGHT),
   .MAX_BBOX     (16)
) u_display_annotator (
   .clk        (w_hdmi_clk),
   .rst        (~i_arstn),
   
   .in_valid   (bbox_dma_tvalid),
   .in_last    (bbox_dma_tlast ),
   .in_data    (bbox_dma_tdata ),
   .in_ready   (bbox_dma_tready),
   
   .out_valid  (display_dma_rvalid),
   .out_data   (display_dma_rdata ),
   .out_ready  (display_dma_rready)
);


reg [7:0] r_Board_status;

assign Board_status = r_Board_status;
always @ (posedge prp_clk)
begin
    r_Board_status <= {7'd0, in_user};
end 

/*****************/
/*DMA            */
/*****************/


wire   [2:0]          sg_cmd_channelId;
wire                  sg_cmd_valid;
wire                  sg_cmd_ready;
wire   [26:0]         sg_cmd_bytesDone;
wire                  sg_cmd_endOfPacket;
wire                  sg_cmd_completed;
wire                  sg_cmd_read;
wire                  sg_cmd_write;
wire                  sg_rsp_valid;
wire   [2:0]          sg_rsp_channelId;
wire   [31:0]         sg_rsp_srcAddress;
wire   [31:0]         sg_rsp_dstAddress;
wire   [25:0]         sg_rsp_bytes;
wire                  sg_rsp_last;
wire                  sg_rsp_stall;

wire ecnn_dma_reset ;
assign ecnn_dma_reset = io_systemReset | (!clk_250m_rstn)| soc_prp_linkdown_reset_out;

dma u_dma(
    .clk                (clk_250m),
    .reset              (ecnn_dma_reset ), //(!clk_250m_rstn   ),
    
    .ctrl_clk           (prp_clk),
    .ctrl_reset         (!soc_prp_reset_out),

    //APB Slave
    .ctrl_PADDR         (io_apbSlave_0_PADDR         ),
    .ctrl_PSEL          (io_apbSlave_0_PSEL          ),
    .ctrl_PENABLE       (io_apbSlave_0_PENABLE       ),
    .ctrl_PREADY        (io_apbSlave_0_PREADY        ),
    .ctrl_PWRITE        (io_apbSlave_0_PWRITE        ),
    .ctrl_PWDATA        (io_apbSlave_0_PWDATA        ),
    .ctrl_PRDATA        (io_apbSlave_0_PRDATA        ),
    .ctrl_PSLVERROR     (io_apbSlave_0_PSLVERROR     ),
    .ctrl_interrupts    (dma_interrupts              ),

    //DMA AXI memory Interface 
    .read_arvalid       (ecnn_DMA_ARVALID_0     ),
    .read_araddr        (ecnn_DMA_ARADDR_0[31:0]),
    .read_arready       (ecnn_DMA_ARREADY_0     ),
    .read_arregion      (),
    .read_arlen         (ecnn_DMA_ARLEN_0       ),
    .read_arsize        (ecnn_DMA_ARSIZE_0      ),
    .read_arburst       (ecnn_DMA_ARBURST_0     ),
    .read_arlock        (ecnn_DMA_ARLOCK_0      ),
    .read_arcache       (     ),       //
    .read_arqos         (ecnn_DMA_ARQOS_0       ),
    .read_arprot        (      ),       //
    
    .read_rready        (ecnn_DMA_RREADY_0      ),
    .read_rvalid        (ecnn_DMA_RVALID_0      ),
    .read_rdata         (ecnn_DMA_RDATA_0       ),
    .read_rlast         (ecnn_DMA_RLAST_0       ),
    .read_rresp         (ecnn_DMA_RRESP_0       ),
    
    .write_awvalid      (ecnn_DMA_AWVALID_0     ),
    .write_awready      (ecnn_DMA_AWREADY_0     ),
    .write_awaddr       (ecnn_DMA_AWADDR_0[31:0]),
    .write_awregion     (),
    .write_awlen        (ecnn_DMA_AWLEN_0       ),
    .write_awsize       (ecnn_DMA_AWSIZE_0      ),
    .write_awburst      (ecnn_DMA_AWBURST_0     ),
    .write_awlock       (ecnn_DMA_AWLOCK_0      ),
    .write_awcache      (ecnn_DMA_AWCACHE_0     ),
    .write_awqos        (ecnn_DMA_AWQOS_0       ),
    .write_awprot       (      ),        //
    
    .write_wvalid       (ecnn_DMA_WVALID_0      ),
    .write_wready       (ecnn_DMA_WREADY_0      ),
    .write_wdata        (ecnn_DMA_WDATA_0       ),
    .write_wstrb        (ecnn_DMA_WSTRB_0       ),
    .write_wlast        (ecnn_DMA_WLAST_0       ),
    
    .write_bvalid       (ecnn_DMA_BVALID_0      ),
    .write_bready       (ecnn_DMA_BREADY_0      ),
    .write_bresp        (ecnn_DMA_BRESP_0       ),

	
    //64bits Camera Video Stream In
    .dat0_i_clk         (i_pixel_clk        ),
    .dat0_i_reset       (~i_arstn           ),
    .dat0_i_tvalid      (cam_dma_wvalid     ),
    .dat0_i_tready      (cam_dma_wready     ),
    .dat0_i_tdata       (cam_dma_wdata      ),
    .dat0_i_tkeep       ({8{cam_dma_wvalid}}),
    .dat0_i_tdest       (4'd0),
    .dat0_i_tlast       (cam_dma_wlast      ),
	
     //64-bit dma channel (MM2S - from external memory)
    .dat1_o_clk         (w_hdmi_clk     ),
    .dat1_o_reset       (~i_arstn       ),
    .dat1_o_tvalid      (bbox_dma_tvalid),
    .dat1_o_tready      (bbox_dma_tready),
    .dat1_o_tdata       (bbox_dma_tdata ),
    .dat1_o_tkeep       (bbox_dma_tkeep ),
    .dat1_o_tdest       (bbox_dma_tdest ),
    .dat1_o_tlast       (bbox_dma_tlast ),
    
    //Raw ecnn input data for pre-processing
    .dat2_o_clk         (prp_clk),
    .dat2_o_reset       (!soc_prp_reset_out    ),
    .dat2_o_tvalid      (m_axis_dma2_TVALID    ),
    .dat2_o_tready      (m_axis_dma2_TREADY    ),
    .dat2_o_tdata       (m_axis_dma2_TDATA     ),
    .dat2_o_tkeep       (m_axis_dma2_TKEEP     ),
    .dat2_o_tlast       (m_axis_dma2_TLAST     ),
    .dat2_o_tdest       (m_axis_dma2_TDEST     ),

    .dat3_i_clk         (prp_clk),
    .dat3_i_reset       (!soc_prp_reset_out    ),
    .dat3_i_tvalid      (m_axis_mscale_r_TVALID),
    .dat3_i_tready      (m_axis_mscale_r_TREADY),
    .dat3_i_tdata       (m_axis_mscale_r_TDATA ),
    .dat3_i_tkeep       (m_axis_mscale_r_TKEEP ),
    .dat3_i_tlast       (m_axis_mscale_r_TLAST ),
    .dat3_i_tdest       (m_axis_mscale_r_TDEST ),

    .dat4_i_clk         (prp_clk),
    .dat4_i_reset       (!soc_prp_reset_out    ),
    .dat4_i_tvalid      (m_axis_mscale_g_TVALID),
    .dat4_i_tready      (m_axis_mscale_g_TREADY),
    .dat4_i_tdata       (m_axis_mscale_g_TDATA ),
    .dat4_i_tkeep       (m_axis_mscale_g_TKEEP ),
    .dat4_i_tlast       (m_axis_mscale_g_TLAST ),
    .dat4_i_tdest       (m_axis_mscale_g_TDEST ),
        
    .dat5_i_clk         (prp_clk),
    .dat5_i_reset       (!soc_prp_reset_out    ),
    .dat5_i_tvalid      (m_axis_mscale_b_TVALID),
    .dat5_i_tready      (m_axis_mscale_b_TREADY),
    .dat5_i_tdata       (m_axis_mscale_b_TDATA ),
    .dat5_i_tkeep       (m_axis_mscale_b_TKEEP ),
    .dat5_i_tlast       (m_axis_mscale_b_TLAST ),
    .dat5_i_tdest       (m_axis_mscale_b_TDEST ),
    
    
    .sg_cmd_channelId     (sg_cmd_channelId               ),
    .sg_cmd_valid         (sg_cmd_valid                   ),
    .sg_cmd_ready         (sg_cmd_ready                   ),
    .sg_cmd_bytesDone     (sg_cmd_bytesDone               ),
    .sg_cmd_endOfPacket   (sg_cmd_endOfPacket             ),
    .sg_cmd_completed     (sg_cmd_completed               ),
    .sg_cmd_read          (sg_cmd_read                    ),
    .sg_cmd_write         (sg_cmd_write                   ),
    .sg_rsp_valid         (sg_rsp_valid                   ),
    .sg_rsp_channelId     (sg_rsp_channelId               ),
    .sg_rsp_srcAddress    (sg_rsp_srcAddress              ),
    .sg_rsp_dstAddress    (sg_rsp_dstAddress              ),
    .sg_rsp_bytes         (sg_rsp_bytes                   ),
    .sg_rsp_last          (sg_rsp_last                    ),
    .sg_rsp_stall         (sg_rsp_stall                   )
    
    
);

custom_sg_linked_list  #(
    .NUM_CHANNEL     (6),
    .NUM_DESCRIPTIOR (4),
    .CTRL_WIDTH      (8)
    
)sgll_inst(
  .clk                  (clk_250m               ),
  .reset                (ecnn_dma_reset      ),
  .ctrl_clk             (prp_clk         ),
  .ctrl_reset           (!soc_prp_reset_out       ),
  
  .sg_cmd_valid         (sg_cmd_valid         ),
  .sg_cmd_ready         (sg_cmd_ready         ),
  .sg_cmd_read          (sg_cmd_read          ),
  .sg_cmd_write         (sg_cmd_write         ),
  .sg_cmd_channelId     (sg_cmd_channelId     ),
  .sg_cmd_bytesDone     (sg_cmd_bytesDone     ),
  .sg_cmd_endOfPacket   (sg_cmd_endOfPacket   ),
  .sg_cmd_completed     (sg_cmd_completed     ),
  .sg_rsp_valid         (sg_rsp_valid         ),
  .sg_rsp_channelId     (sg_rsp_channelId     ),
  .sg_rsp_srcAddress    (sg_rsp_srcAddress    ),
  .sg_rsp_dstAddress    (sg_rsp_dstAddress    ),
  .sg_rsp_bytes         (sg_rsp_bytes         ),
  .sg_rsp_last          (sg_rsp_last          ),
  .sg_rsp_stallout      (sg_rsp_stall         ),

  .sg_out_control       (sg_out_control),
  .sg_in_control        (sg_in_control),
  
  //apb3 port
  .PADDR        (io_apbSlave_3_PADDR),
  .PSEL         (io_apbSlave_3_PSEL     ),
  .PENABLE      (io_apbSlave_3_PENABLE  ),
  .PREADY       (io_apbSlave_3_PREADY   ),
  .PWRITE       (io_apbSlave_3_PWRITE   ),
  .PWDATA       (io_apbSlave_3_PWDATA   ),
  .PRDATA       (io_apbSlave_3_PRDATA   ),
  .PSLVERROR    (io_apbSlave_3_PSLVERROR)
  
  
);


assign userInterruptE = |dma_interrupts;


//Streaming in 64-bit instead of 32-bit doubles the pre-processing speed 
//Requires a bridge to convert 64-bit to 32-bit for pre-processing
//Pre-processing with 32-bits gives more accurate output

axis_width_64to32 #(
    .STREAM_WIDTH_IN (Dma2DataWidth),
    .STREAM_WIDTH_OUT(AxisDataWidth)
) axis_width_64to32_dma1_inst (
    .ACLK_in          (prp_clk),
    .ACLK_out         (prp_clk_2x),
    .ARESETn          (soc_prp_reset_out),
    .s_axis_in_TVALID (m_axis_dmafix_TVALID ),
    .s_axis_in_TREADY (m_axis_dmafix_TREADY ),
    .s_axis_in_TDATA  (m_axis_dmafix_TDATA  ),
    .s_axis_in_TKEEP  (m_axis_dmafix_TKEEP  ),
    .s_axis_in_TLAST  (m_axis_dmafix_TLAST  ),
    .s_axis_in_TDEST  (m_axis_dmafix_TDEST  ),
    .m_axis_out_TVALID(m_axis_dmahalf_TVALID),
    .m_axis_out_TREADY(m_axis_dmahalf_TREADY),
    .m_axis_out_TDATA (m_axis_dmahalf_TDATA ),
    .m_axis_out_TKEEP (m_axis_dmahalf_TKEEP ),
    .m_axis_out_TLAST (m_axis_dmahalf_TLAST ),
    .m_axis_out_TDEST (m_axis_dmahalf_TDEST )
);

multi_scaler #(
      .STREAM_WIDTH(32),
      .SCALE_FACTOR(SCALE_FACTOR),
      .INPUT_IMAGE_WIDTH(INPUT_IMAGE_WIDTH),
      .INPUT_IMAGE_HEIGHT(INPUT_IMAGE_HEIGHT)
  ) multi_scaler_inst (
      .ACLK            (prp_clk),
      .ACLK_2x         (prp_clk_2x),
      .ARESETn         (soc_prp_reset_out),
      .s_axis_in_TVALID(m_axis_dmahalf_TVALID),
      .s_axis_in_TREADY(m_axis_dmahalf_TREADY),
      .s_axis_in_TDATA (m_axis_dmahalf_TDATA ),
      .s_axis_in_TKEEP (m_axis_dmahalf_TKEEP ),
      .s_axis_in_TLAST (m_axis_dmahalf_TLAST ),
      .s_axis_in_TDEST (m_axis_dmahalf_TDEST ),
      .m_axis_r_TVALID (m_axis_mscale_r_TVALID),
      .m_axis_r_TREADY (m_axis_mscale_r_TREADY),
      .m_axis_r_TDATA  (m_axis_mscale_r_TDATA ),
      .m_axis_r_TKEEP  (m_axis_mscale_r_TKEEP ),
      .m_axis_r_TLAST  (m_axis_mscale_r_TLAST ),
      .m_axis_r_TDEST  (m_axis_mscale_r_TDEST ),
      .m_axis_g_TVALID (m_axis_mscale_g_TVALID),
      .m_axis_g_TREADY (m_axis_mscale_g_TREADY),
      .m_axis_g_TDATA  (m_axis_mscale_g_TDATA ),
      .m_axis_g_TKEEP  (m_axis_mscale_g_TKEEP ),
      .m_axis_g_TLAST  (m_axis_mscale_g_TLAST ),
      .m_axis_g_TDEST  (m_axis_mscale_g_TDEST ),
      .m_axis_b_TVALID (m_axis_mscale_b_TVALID),
      .m_axis_b_TREADY (m_axis_mscale_b_TREADY),
      .m_axis_b_TDATA  (m_axis_mscale_b_TDATA ),
      .m_axis_b_TKEEP  (m_axis_mscale_b_TKEEP ),
      .m_axis_b_TLAST  (m_axis_mscale_b_TLAST ),
      .m_axis_b_TDEST  (m_axis_mscale_b_TDEST )
  );
											   

reg  [31:0]     sysClk_cnt;
reg  [31:0]     periClk_cnt;

/*                                                                                  */
/* Check aliveness of system and peripheral reset                                   */
/*                                                                                  */
always@(posedge prp_clk or posedge !soc_prp_reset_out)
begin  
    if(!soc_prp_reset_out)
    begin
        periClk_cnt <= 'd0;
        periClk_reset_ok <= 1'b0;        
    end
    else
    begin
        if(periClk_cnt == (PERI_FREQ*1000000)-1)
        begin
            periClk_cnt <= 'd0;
            periClk_reset_ok <= ~periClk_reset_ok;            
        end
        else
        begin
            periClk_cnt <= periClk_cnt + 1'b1;
            periClk_reset_ok <= periClk_reset_ok;                        
        end
    end
end

always@(posedge i_sys_clk_25mhz or posedge io_systemReset)
begin  
    if(io_systemReset)
    begin
        sysClk_cnt <= 'd0;
        sysClk_reset_ok <= 1'b0;        
    end
    else
    begin
        if(sysClk_cnt == (PERI_FREQ*1000000)-1)
        begin
            sysClk_cnt <= 'd0;
            sysClk_reset_ok <= ~sysClk_reset_ok;            
        end
        else
        begin
            sysClk_cnt <= sysClk_cnt + 1'b1;
            sysClk_reset_ok <= sysClk_reset_ok;                        
        end
    end
end

 
////////////////////////
//AXI MASTER <-> eCNN/// 
////////////////////////
//assign io_ddrMasters_0_aw_payload_id     = {1'b1, axi_cnn_AWID}          ;
//assign io_ddrMasters_0_aw_payload_addr   = axi_cnn_AWADDR                ;
//assign io_ddrMasters_0_aw_payload_len    = axi_cnn_AWLEN                 ;
//assign io_ddrMasters_0_aw_payload_size   = axi_cnn_AWSIZE                ;
//assign io_ddrMasters_0_aw_payload_burst  = axi_cnn_AWBURST               ;
//assign io_ddrMasters_0_aw_payload_lock   = axi_cnn_AWLOCK                ;
//assign io_ddrMasters_0_aw_payload_cache  = axi_cnn_AWCACHE               ;
//assign io_ddrMasters_0_aw_payload_prot   = axi_cnn_AWPROT                ;
//assign io_ddrMasters_0_aw_payload_qos    = axi_cnn_AWQOS                 ;
//assign io_ddrMasters_0_aw_payload_region = axi_cnn_AWREGION              ;
//assign io_ddrMasters_0_aw_valid          = axi_cnn_AWVALID               ;
//assign axi_cnn_AWREADY                   = io_ddrMasters_0_aw_ready      ;
//assign io_ddrMasters_0_w_payload_data    = axi_cnn_WDATA                 ;
//assign io_ddrMasters_0_w_payload_strb    = axi_cnn_WSTRB                 ;
//assign io_ddrMasters_0_w_payload_last    = axi_cnn_WLAST                 ;
//assign io_ddrMasters_0_w_valid           = axi_cnn_WVALID                ;
//assign axi_cnn_WREADY                    = io_ddrMasters_0_w_ready       ;
//assign axi_cnn_BID[CnnIdWidth-1:0]       = io_ddrMasters_0_b_payload_id  ;
//assign axi_cnn_BRESP                     = io_ddrMasters_0_b_payload_resp;
//assign axi_cnn_BVALID                    = io_ddrMasters_0_b_valid       ;
//assign io_ddrMasters_0_b_ready           = axi_cnn_BREADY                ;
//assign io_ddrMasters_0_ar_payload_id     = {1'b1, axi_cnn_ARID}          ;
//assign io_ddrMasters_0_ar_payload_addr   = axi_cnn_ARADDR                ;
//assign io_ddrMasters_0_ar_payload_len    = axi_cnn_ARLEN                 ;
//assign io_ddrMasters_0_ar_payload_size   = axi_cnn_ARSIZE                ;
//assign io_ddrMasters_0_ar_payload_burst  = axi_cnn_ARBURST               ;
//assign io_ddrMasters_0_ar_payload_lock   = axi_cnn_ARLOCK                ;
//assign io_ddrMasters_0_ar_payload_cache  = axi_cnn_ARCACHE               ;
//assign io_ddrMasters_0_ar_payload_prot   = axi_cnn_ARPROT                ;
//assign io_ddrMasters_0_ar_payload_qos    = axi_cnn_ARQOS                 ;
//assign io_ddrMasters_0_ar_payload_region = axi_cnn_ARREGION              ;
//assign io_ddrMasters_0_ar_valid          = axi_cnn_ARVALID               ;
//assign axi_cnn_ARREADY                   = io_ddrMasters_0_ar_ready      ;
//assign axi_cnn_RID[CnnIdWidth-1:0]       = io_ddrMasters_0_r_payload_id  ;
//assign axi_cnn_RDATA                     = io_ddrMasters_0_r_payload_data;
//assign axi_cnn_RRESP                     = io_ddrMasters_0_r_payload_resp;
//assign axi_cnn_RLAST                     = io_ddrMasters_0_r_payload_last;
//assign axi_cnn_RVALID                    = io_ddrMasters_0_r_valid       ;
//assign io_ddrMasters_0_r_ready           = axi_cnn_RREADY                ;



assign io_ddrMasters_0_aw_payload_id     = 4'h2          ;
assign io_ddrMasters_0_aw_payload_addr   = ecnn_DMA_AWADDR_0             ;//
assign io_ddrMasters_0_aw_payload_len    = ecnn_DMA_AWLEN_0              ;//
assign io_ddrMasters_0_aw_payload_size   = ecnn_DMA_AWSIZE_0             ;//
assign io_ddrMasters_0_aw_payload_burst  = ecnn_DMA_AWBURST_0            ;//
assign io_ddrMasters_0_aw_payload_lock   = ecnn_DMA_AWLOCK_0             ;//
assign io_ddrMasters_0_aw_payload_cache  = ecnn_DMA_AWCACHE_0            ;//
assign io_ddrMasters_0_aw_payload_prot   = ecnn_DMA_AWPROT_0             ;//
assign io_ddrMasters_0_aw_payload_qos    = ecnn_DMA_AWQOS_0              ;//
assign io_ddrMasters_0_aw_payload_region = 'd0;//          ecnn_DMA_AWREGION_0              
assign io_ddrMasters_0_aw_valid          = ecnn_DMA_AWVALID_0            ;//
assign io_ddrMasters_0_aw_payload_allStrb= ecnn_DMA_AWALLSTRB_0          ;//
assign ecnn_DMA_AWREADY_0                = io_ddrMasters_0_aw_ready      ;//
assign io_ddrMasters_0_w_payload_data    = ecnn_DMA_WDATA_0              ;//
assign io_ddrMasters_0_w_payload_strb    = ecnn_DMA_WSTRB_0              ;//
assign io_ddrMasters_0_w_payload_last    = ecnn_DMA_WLAST_0              ;//
assign io_ddrMasters_0_w_valid           = ecnn_DMA_WVALID_0             ;//
assign ecnn_DMA_WREADY_0                 = io_ddrMasters_0_w_ready       ;//
assign ecnn_DMA_BID_0[3:0]               = io_ddrMasters_0_b_payload_id  ;//
assign ecnn_DMA_BRESP_0                  = io_ddrMasters_0_b_payload_resp;//
assign ecnn_DMA_BVALID_0                 = io_ddrMasters_0_b_valid       ;//
assign io_ddrMasters_0_b_ready           = ecnn_DMA_BREADY_0             ;//
assign io_ddrMasters_0_ar_payload_id     = 4'h3                          ;
assign io_ddrMasters_0_ar_payload_addr   = ecnn_DMA_ARADDR_0             ;//
assign io_ddrMasters_0_ar_payload_len    = ecnn_DMA_ARLEN_0              ;//
assign io_ddrMasters_0_ar_payload_size   = ecnn_DMA_ARSIZE_0             ;//
assign io_ddrMasters_0_ar_payload_burst  = ecnn_DMA_ARBURST_0            ;//
assign io_ddrMasters_0_ar_payload_lock   = ecnn_DMA_ARLOCK_0             ;//
assign io_ddrMasters_0_ar_payload_cache  = 'd0;//ecnn_DMA_ARCACHE_0          
assign io_ddrMasters_0_ar_payload_prot   = ecnn_DMA_ARPROT_0             ;//
assign io_ddrMasters_0_ar_payload_qos    = ecnn_DMA_ARQOS_0              ;//
assign io_ddrMasters_0_ar_payload_region = 'd0; //ecnn_DMA_ARREGION_0              ;
assign io_ddrMasters_0_ar_valid          = ecnn_DMA_ARVALID_0            ;//
assign ecnn_DMA_ARREADY_0                = io_ddrMasters_0_ar_ready      ;//
assign axi_cnn_RID[CnnIdWidth-1:0]       = io_ddrMasters_0_r_payload_id  ;
assign ecnn_DMA_RDATA_0                  = io_ddrMasters_0_r_payload_data;//
assign ecnn_DMA_RRESP_0                  = io_ddrMasters_0_r_payload_resp;//
assign ecnn_DMA_RLAST_0                  = io_ddrMasters_0_r_payload_last;//
assign ecnn_DMA_RVALID_0                 = io_ddrMasters_0_r_valid       ;//
assign io_ddrMasters_0_r_ready           = ecnn_DMA_RREADY_0             ;//


////////////////////////
  /* DepEye CNN IP */
////////////////////////
//  core_cnn_postmap cnn_inst (
//      .clk     (prp_clk          ),
//      .clk_2x  (prp_clk_2x       ),
//      .clk_2x_n(prp_clk_2x_n     ),
////    .clk_4x_n(prp_clk_4x_n     ), //Not part of config
//      .rstn    (soc_prp_reset_out),
//
//      .flag_calc_start(cnn_calc_start),
//      .flag_calc_end  (cnn_calc_end  ),
//
//      .s_apb_paddr    (io_apbSlave_2_PADDR[11:0]),
//      .s_apb_psel     (io_apbSlave_2_PSEL       ),
//      .s_apb_penable  (io_apbSlave_2_PENABLE    ),
//      .s_apb_pwrite   (io_apbSlave_2_PWRITE     ),
//      .s_apb_pwdata   (io_apbSlave_2_PWDATA     ),
//      .s_apb_pready   (io_apbSlave_2_PREADY     ),
//      .s_apb_prdata   (io_apbSlave_2_PRDATA     ),
//      .s_apb_pslverror(io_apbSlave_2_PSLVERROR  ),
//
//      .m_axi_awid     (axi_cnn_AWID   ),
//      .m_axi_awaddr   (axi_cnn_AWADDR ),
//      .m_axi_awlen    (axi_cnn_AWLEN  ),
//      .m_axi_awsize   (axi_cnn_AWSIZE ),
//      .m_axi_awburst  (axi_cnn_AWBURST),  // .m_axi_awlock (m_axi_cnn_AWLOCK),
//      .m_axi_awcache  (axi_cnn_AWCACHE),
//      .m_axi_awprot   (axi_cnn_AWPROT ),  // .m_axi_awqos  (m_axi_cnn_AWQOS),
//      .m_axi_awvalid  (axi_cnn_AWVALID),
//      .m_axi_awready  (axi_cnn_AWREADY),
//      .m_axi_wdata    (axi_cnn_WDATA  ),
//      .m_axi_wstrb    (axi_cnn_WSTRB  ),
//      .m_axi_wlast    (axi_cnn_WLAST  ),
//      .m_axi_wvalid   (axi_cnn_WVALID ),
//      .m_axi_wready   (axi_cnn_WREADY ),   
//      .m_axi_bid      (axi_cnn_BID    ),
//      .m_axi_bresp    (axi_cnn_BRESP  ),
//      .m_axi_bvalid   (axi_cnn_BVALID ),
//      .m_axi_bready   (axi_cnn_BREADY ),  
//      .m_axi_arid     (axi_cnn_ARID   ),
//      .m_axi_araddr   (axi_cnn_ARADDR ),
//      .m_axi_arlen    (axi_cnn_ARLEN  ),
//      .m_axi_arsize   (axi_cnn_ARSIZE ),
//      .m_axi_arburst  (axi_cnn_ARBURST),  // .m_axi_arlock (m_axi_cnn_ARLOCK),
//      .m_axi_arcache  (axi_cnn_ARCACHE),
//      .m_axi_arprot   (axi_cnn_ARPROT ),  // .m_axi_arqos  (m_axi_cnn_ARQOS),
//      .m_axi_arvalid  (axi_cnn_ARVALID),
//      .m_axi_arready  (axi_cnn_ARREADY),
//      .m_axi_rid      (axi_cnn_RID    ),
//      .m_axi_rdata    (axi_cnn_RDATA  ),
//      .m_axi_rresp    (axi_cnn_RRESP  ),
//      .m_axi_rlast    (axi_cnn_RLAST  ),
//      .m_axi_rvalid   (axi_cnn_RVALID ),
//      .m_axi_rready   (axi_cnn_RREADY )
//  );
//
//assign userInterruptH = cnn_calc_end;

wire soc_reset_perstn; 
assign soc_reset_perstn = io_gpio_sw_n & ~soc_prp_linkdown_reset_out; 
////////////////////
// SLB CONNECTION //
////////////////////
EfxSapphireHpSoc_slb u_top_peripherals(
    .system_i2c_0_io_sda_writeEnable   (o_cam_sda_oe),
    .system_i2c_0_io_sda_write         (o_cam_sda   ),
    .system_i2c_0_io_sda_read          (i_cam_sda   ),
    .system_i2c_0_io_scl_writeEnable   (o_cam_scl_oe),
    .system_i2c_0_io_scl_write         (o_cam_scl   ),
    .system_i2c_0_io_scl_read          (i_cam_scl   ),
    
    .system_spi_0_io_sclk_write        (system_spi_0_io_sclk_write        ),
    .system_spi_0_io_data_0_writeEnable(system_spi_0_io_data_0_writeEnable),
    .system_spi_0_io_data_0_read       (system_spi_0_io_data_0_read       ),
    .system_spi_0_io_data_0_write      (system_spi_0_io_data_0_write      ),
    .system_spi_0_io_data_1_writeEnable(system_spi_0_io_data_1_writeEnable),
    .system_spi_0_io_data_1_read       (system_spi_0_io_data_1_read       ),
    .system_spi_0_io_data_1_write      (system_spi_0_io_data_1_write      ),
    .system_spi_0_io_data_2_writeEnable(system_spi_0_io_data_2_writeEnable),
    .system_spi_0_io_data_2_read       (system_spi_0_io_data_2_read       ),
    .system_spi_0_io_data_2_write      (system_spi_0_io_data_2_write      ),
    .system_spi_0_io_data_3_writeEnable(system_spi_0_io_data_3_writeEnable),
    .system_spi_0_io_data_3_read       (system_spi_0_io_data_3_read       ),
    .system_spi_0_io_data_3_write      (system_spi_0_io_data_3_write      ),
    .system_spi_0_io_ss                (system_spi_0_io_ss                ),
    
     //DMA
    .io_apbSlave_0_PADDR    (io_apbSlave_0_PADDR    ),
    .io_apbSlave_0_PSEL     (io_apbSlave_0_PSEL     ),
    .io_apbSlave_0_PENABLE  (io_apbSlave_0_PENABLE  ),
    .io_apbSlave_0_PREADY   (io_apbSlave_0_PREADY   ),
    .io_apbSlave_0_PWRITE   (io_apbSlave_0_PWRITE   ),
    .io_apbSlave_0_PWDATA   (io_apbSlave_0_PWDATA   ),
    .io_apbSlave_0_PRDATA   (io_apbSlave_0_PRDATA   ),
    .io_apbSlave_0_PSLVERROR(io_apbSlave_0_PSLVERROR),
     //common_apb3
    .io_apbSlave_1_PADDR    (io_apbSlave_1_PADDR    ),
    .io_apbSlave_1_PSEL     (io_apbSlave_1_PSEL     ),
    .io_apbSlave_1_PENABLE  (io_apbSlave_1_PENABLE  ),
    .io_apbSlave_1_PREADY   (io_apbSlave_1_PREADY   ),
    .io_apbSlave_1_PWRITE   (io_apbSlave_1_PWRITE   ),
    .io_apbSlave_1_PWDATA   (io_apbSlave_1_PWDATA   ),
    .io_apbSlave_1_PRDATA   (io_apbSlave_1_PRDATA   ),
    .io_apbSlave_1_PSLVERROR(io_apbSlave_1_PSLVERROR),
     //eCNN
    .io_apbSlave_2_PADDR    (io_apbSlave_2_PADDR    ),
    .io_apbSlave_2_PSEL     (io_apbSlave_2_PSEL     ),
    .io_apbSlave_2_PENABLE  (io_apbSlave_2_PENABLE  ),
    .io_apbSlave_2_PREADY   (io_apbSlave_2_PREADY   ),
    .io_apbSlave_2_PWRITE   (io_apbSlave_2_PWRITE   ),
    .io_apbSlave_2_PWDATA   (io_apbSlave_2_PWDATA   ),
    .io_apbSlave_2_PRDATA   (io_apbSlave_2_PRDATA   ),
    .io_apbSlave_2_PSLVERROR(io_apbSlave_2_PSLVERROR),
     //DMA SG custom descitpors 
    .io_apbSlave_3_PADDR    (io_apbSlave_3_PADDR    ),
    .io_apbSlave_3_PSEL     (io_apbSlave_3_PSEL     ),
    .io_apbSlave_3_PENABLE  (io_apbSlave_3_PENABLE  ),
    .io_apbSlave_3_PREADY   (io_apbSlave_3_PREADY   ),
    .io_apbSlave_3_PWRITE   (io_apbSlave_3_PWRITE   ),
    .io_apbSlave_3_PWDATA   (io_apbSlave_3_PWDATA   ),
    .io_apbSlave_3_PRDATA   (io_apbSlave_3_PRDATA   ),
    .io_apbSlave_3_PSLVERROR(io_apbSlave_3_PSLVERROR),
    
    
    
    .userInterruptA         (userInterruptA),
    .userInterruptB         (userInterruptB),
    .userInterruptC         (userInterruptC),
    
    `ifndef SOFT_TAP
    .jtagCtrl_tdi       (jtagCtrl_tdi       ),
    .jtagCtrl_tdo       (jtagCtrl_tdo       ),
    .jtagCtrl_enable    (jtagCtrl_enable    ),
    .jtagCtrl_capture   (jtagCtrl_capture   ),
    .jtagCtrl_shift     (jtagCtrl_shift     ),
    .jtagCtrl_update    (jtagCtrl_update    ),
    .jtagCtrl_reset     (jtagCtrl_reset     ),
    .ut_jtagCtrl_tdi    (ut_jtagCtrl_tdi    ),
    .ut_jtagCtrl_tdo    (ut_jtagCtrl_tdo    ),
    .ut_jtagCtrl_enable (ut_jtagCtrl_enable ),
    .ut_jtagCtrl_capture(ut_jtagCtrl_capture),
    .ut_jtagCtrl_shift  (ut_jtagCtrl_shift  ),
    .ut_jtagCtrl_update (ut_jtagCtrl_update ),
    .ut_jtagCtrl_reset  (ut_jtagCtrl_reset  ),
    `else
    .io_jtag_tdi(io_jtag_tdi),
    .io_jtag_tdo(io_jtag_tdo),
    .io_jtag_tms(io_jtag_tms),
    .pin_io_jtag_tdi(pin_io_jtag_tdi),
    .pin_io_jtag_tdo(pin_io_jtag_tdo),
    .pin_io_jtag_tms(pin_io_jtag_tms),
    `endif
    
    .system_uart_0_io_txd (system_uart_0_io_txd),
    .system_uart_0_io_rxd (system_uart_0_io_rxd),
    
    .system_gpio_0_io_read({3'b000,io_gpio_sw2_n}),
    .system_gpio_0_io_write(),
    .system_gpio_0_io_writeEnable(),
    
    .axiA_awvalid  (axiA_awvalid ),
    .axiA_awready  (axiA_awready ),
    .axiA_awaddr   (axiA_awaddr  ),
    .axiA_awlen    (axiA_awlen   ),
    .axiA_awsize   (axiA_awsize  ),
    .axiA_awcache  (axiA_awcache ),
    .axiA_awprot   (axiA_awprot  ),
    .axiA_wvalid   (axiA_wvalid  ),
    .axiA_wready   (axiA_wready  ),
    .axiA_wdata    (axiA_wdata   ),
    .axiA_wstrb    (axiA_wstrb   ),
    .axiA_wlast    (axiA_wlast   ),
    .axiA_bvalid   (axiA_bvalid  ),
    .axiA_bready   (axiA_bready  ),
    .axiA_bresp    (axiA_bresp   ),
    .axiA_arvalid  (axiA_arvalid ),
    .axiA_arready  (axiA_arready ),
    .axiA_araddr   (axiA_araddr  ),
    .axiA_arlen    (axiA_arlen   ),
    .axiA_arsize   (axiA_arsize  ),
    .axiA_arcache  (axiA_arcache ),
    .axiA_arprot   (axiA_arprot  ),
    .axiA_rvalid   (axiA_rvalid  ),
    .axiA_rready   (axiA_rready  ),
    .axiA_rdata    (axiA_rdata   ),
    .axiA_rresp    (axiA_rresp   ),
    .axiA_rlast    (axiA_rlast   ),
    .axiAInterrupt (axiAInterrupt),
    
    .cfg_done  (cfg_done ),
    .cfg_start (cfg_start),
    .cfg_sel   (cfg_sel  ),
    .cfg_reset (cfg_reset),
    
    .io_peripheralClk      (prp_clk           ),
    .io_peripheralReset    (!soc_prp_reset_out),
    .io_asyncReset         (io_asyncReset     ),
    .io_gpio_sw_n          (soc_reset_perstn  ), //(io_gpio_sw_n      ), 
    .pll_peripheral_locked (pll_prp_locked    ),
    .pll_system_locked     (pll_system_locked )
);


wire             debug_dma_hw_accel_in_fifo_underflow ;
wire             debug_dma_hw_accel_in_fifo_overflow  ;
wire             debug_dma_hw_accel_out_fifo_underflow;
wire             debug_dma_hw_accel_out_fifo_overflow ;
wire  [31:0]     debug_dma_hw_accel_in_fifo_wcount    ;
wire  [31:0]     debug_dma_hw_accel_out_fifo_rcount   ;

// For control and status register
common_apb3 #(
   .ADDR_WIDTH                              (16),
   .DATA_WIDTH                              (32),
   .NUM_REG                                 (24)
) u_apb3_cam_display (
    .clk                                    (prp_clk),
    .resetn                                 (soc_prp_reset_out),
    
    // Output Control
    .mipi_rstn                              (mipi_rstn                 ),
    .rgb_control                            (rgb_control               ),
    .trigger_capture_frame                  (trigger_capture_frame     ),
    .continuous_capture_frame               (continuous_capture_frame  ),
    .rgb_gray                               (rgb_gray                  ),
    .cam_dma_init_done                      (cam_dma_init_done         ),
    .hw_accel_dma_init_done                 (hw_accel_dma_init_done    ),    
    .hw_accel_dma_init_done_ch0             (hw_accel_dma_init_done_ch0),
    .hw_accel_dma_init_done_ch1             (hw_accel_dma_init_done_ch1),
    
    .frames_per_second                      (frames_per_second     ),
    .set_offset_display_rgb                 (set_offset_display_rgb),
    
    .Board_status(Board_status),
     
    .master_Control_Input_A(master_Control_Input_A),
    .master_Control_Status_A(master_Control_Status_A),
    .master_Control_Input_B(master_Control_Input_B),
    .master_Control_Status_B(master_Control_Status_B),
    .master_Control_Input_C(master_Control_Input_C),
    .master_Control_Status_C(master_Control_Status_C),
    

    // Input Info Data
    .debug_fifo_status                      (debug_cam_display_fifo_status     ),
    .debug_cam_dma_fifo_rcount              (debug_cam_dma_fifo_rcount         ),
    .debug_cam_dma_fifo_wcount              (debug_cam_dma_fifo_wcount         ),
    .debug_display_dma_fifo_rcount          (debug_display_dma_fifo_rcount     ),
    .debug_display_dma_fifo_wcount          (debug_display_dma_fifo_wcount     ),
    .debug_dma_hw_accel_in_fifo_wcount      (debug_dma_hw_accel_in_fifo_wcount ),
    .debug_dma_hw_accel_out_fifo_rcount     (debug_dma_hw_accel_out_fifo_rcount),
    .debug_cam_dma_status                   (debug_cam_dma_status              ),

    // Apb 3 interface
    .PADDR                                  (io_apbSlave_1_PADDR    ),
    .PSEL                                   (io_apbSlave_1_PSEL     ),
    .PENABLE                                (io_apbSlave_1_PENABLE  ),
    .PREADY                                 (io_apbSlave_1_PREADY   ),
    .PWRITE                                 (io_apbSlave_1_PWRITE   ),
    .PWDATA                                 (io_apbSlave_1_PWDATA   ),
    .PRDATA                                 (io_apbSlave_1_PRDATA   ),
    .PSLVERROR                              (io_apbSlave_1_PSLVERROR)
);

assign debug_cam_display_fifo_status= {22'd0,  debug_dma_hw_accel_out_fifo_overflow, debug_dma_hw_accel_out_fifo_underflow,
                                               debug_dma_hw_accel_in_fifo_overflow , debug_dma_hw_accel_in_fifo_underflow ,
                                               debug_cam_pixel_remap_fifo_underflow, debug_cam_pixel_remap_fifo_overflow  , 
                                               debug_cam_dma_fifo_underflow        , debug_cam_dma_fifo_overflow          , 
                                               debug_display_dma_fifo_underflow    , debug_display_dma_fifo_overflow      };
                                               


pcie_dma_top inst_pcie_dma_top(
//Globle Signals
.clk_100m   (clk_100m   ),
.clk_200m   (io_memoryClk   ),
.clk_250m   (clk_250m   ),

.clk_100m_rstn(clk_100m_rstn),
.clk_200m_rstn(clk_200m_rstn),
.clk_250m_rstn(clk_250m_rstn),

.perst0     (perst0     ),

//LPDDR4 Controller Interface
//--Master AXI4 Interface
.axi0_ARREADY           (soc_ddr_inst1_ARREADY_0       ),
.axi0_AWREADY           (soc_ddr_inst1_AWREADY_0       ),
.axi0_BID               (soc_ddr_inst1_BID_0           ),
.axi0_BRESP             (soc_ddr_inst1_BRESP_0         ),
.axi0_BVALID            (soc_ddr_inst1_BVALID_0        ),
.axi0_RDATA             (soc_ddr_inst1_RDATA_0         ),
.axi0_RID               (soc_ddr_inst1_RID_0           ),
.axi0_RLAST             (soc_ddr_inst1_RLAST_0         ),
.axi0_RRESP             (soc_ddr_inst1_RRESP_0         ),
.axi0_RVALID            (soc_ddr_inst1_RVALID_0        ),
.axi0_WREADY            (soc_ddr_inst1_WREADY_0        ),
.axi0_ARADDR            (soc_ddr_inst1_ARADDR_0[31:0]        ),
.axi0_ARAPCMD           (soc_ddr_inst1_ARAPCMD_0       ),
.axi0_ARBURST           (soc_ddr_inst1_ARBURST_0       ),
.axi0_ARID              (          ),
.axi0_ARLEN             (soc_ddr_inst1_ARLEN_0         ),
.axi0_ARLOCK            (soc_ddr_inst1_ARLOCK_0        ),
.axi0_ARQOS             (soc_ddr_inst1_ARQOS_0         ),
.axi0_ARSIZE            (soc_ddr_inst1_ARSIZE_0        ),
.axi0_ARESETn           (       ),
.axi0_ARVALID           (soc_ddr_inst1_ARVALID_0       ),
.axi0_AWADDR            (soc_ddr_inst1_AWADDR_0[31:0]        ),
.axi0_AWALLSTRB         (soc_ddr_inst1_AWALLSTRB_0     ),
.axi0_AWAPCMD           (soc_ddr_inst1_AWAPCMD_0       ),
.axi0_AWBURST           (soc_ddr_inst1_AWBURST_0       ),
.axi0_AWCACHE           (soc_ddr_inst1_AWCACHE_0       ),
.axi0_AWPROT            (soc_ddr_inst1_AWPROT_0        ),
.axi0_ARCACHE           (soc_ddr_inst1_ARCACHE_0       ),
.axi0_ARPROT            (soc_ddr_inst1_ARPROT_0        ),
.axi0_AWCOBUF           (soc_ddr_inst1_AWCOBUF_0       ),
.axi0_AWID              (          ),
.axi0_AWLEN             (soc_ddr_inst1_AWLEN_0         ),
.axi0_AWLOCK            (soc_ddr_inst1_AWLOCK_0        ),
.axi0_AWQOS             (soc_ddr_inst1_AWQOS_0         ),
.axi0_AWSIZE            (soc_ddr_inst1_AWSIZE_0        ),
.axi0_AWVALID           (soc_ddr_inst1_AWVALID_0       ),
.axi0_BREADY            (soc_ddr_inst1_BREADY_0        ),
.axi0_RREADY            (soc_ddr_inst1_RREADY_0        ),
.axi0_WDATA             (soc_ddr_inst1_WDATA_0         ),
.axi0_WLAST             (soc_ddr_inst1_WLAST_0         ),
.axi0_WSTRB             (soc_ddr_inst1_WSTRB_0         ),
.axi0_WVALID            (soc_ddr_inst1_WVALID_0        ),
//--Configuration Interface
.ddr_inst_CFG_RST       (      ),    //Active-high DDR configuration controller reset.
.ddr_inst_CFG_START     (    ),    //Start the DDR configuration controller.
.ddr_inst_CFG_DONE      (cfg_done     ),    //Indicates the controller configuration is done
.ddr_inst_CFG_SEL       (      ),    
.ddr_pll_rstn           (ddr_pll_rstn          ),


//Extra Salve port for accessing LPDDR4 Controller Interface 
//.s2_axi_awvalid(ecnn_DMA_AWVALID_0),
//.s2_axi_awready(ecnn_DMA_AWREADY_0),
//.s2_axi_awaddr (ecnn_DMA_AWADDR_0),
//.s2_axi_awlen  (ecnn_DMA_AWLEN_0),
//.s2_axi_wvalid (ecnn_DMA_WVALID_0),
//.s2_axi_wready (ecnn_DMA_WREADY_0),
//.s2_axi_wdata  (ecnn_DMA_WDATA_0),
//.s2_axi_wstrb  (ecnn_DMA_WSTRB_0),
//.s2_axi_wlast  (ecnn_DMA_WLAST_0),
//.s2_axi_bvalid (ecnn_DMA_BVALID_0),
//.s2_axi_bready (ecnn_DMA_BREADY_0),
//.s2_axi_bresp  (ecnn_DMA_BRESP_0),
//.s2_axi_arvalid(ecnn_DMA_ARVALID_0),
//.s2_axi_arready(ecnn_DMA_ARREADY_0),
//.s2_axi_araddr (ecnn_DMA_ARADDR_0),
//.s2_axi_arlen  (ecnn_DMA_ARLEN_0),
//.s2_axi_rvalid (ecnn_DMA_RVALID_0),
//.s2_axi_rready (ecnn_DMA_RREADY_0),
//.s2_axi_rdata  (ecnn_DMA_RDATA_0),
//.s2_axi_rlast  (ecnn_DMA_RLAST_0),
//.s2_axi_rresp  (ecnn_DMA_RRESP_0),


.s2_axi_awvalid('d0),
.s2_axi_awready(),
.s2_axi_awaddr ('d0),
.s2_axi_awlen  ('d0),
.s2_axi_wvalid ('d0),
.s2_axi_wready (),
.s2_axi_wdata  ('d0),
.s2_axi_wstrb  ('d0),
.s2_axi_wlast  ('d0),
.s2_axi_bvalid (),
.s2_axi_bready ('d0),
.s2_axi_bresp  (),
.s2_axi_arvalid(),
.s2_axi_arready(),
.s2_axi_araddr ('d0),
.s2_axi_arlen  ('d0),
.s2_axi_rvalid (),
.s2_axi_rready ('d0),
.s2_axi_rdata  (),
.s2_axi_rlast  (),
.s2_axi_rresp  (),
//PCIe Interface
.in_user                (in_user               ),
.q0_USER_PHY_RESET_N    (q0_USER_PHY_RESET_N   ),
.q0_USER_RESET_N_IN     (q0_USER_RESET_N_IN    ),
.q0_RESET_ACK           (q0_RESET_ACK          ),
.q0_RESET_REQ           (q0_RESET_REQ          ),
.q0_HOT_RESET_OUT       (q0_HOT_RESET_OUT      ),
.q0_USER_AXI_RESET_N    (q0_USER_AXI_RESET_N   ),
//--Slave AXI4 Interface   
//----Slave AXI4 Write Interface
.q0_TARGET_AXI_AWADDR       (q0_TARGET_AXI_AWADDR   ),
.q0_TARGET_AXI_AWID         (q0_TARGET_AXI_AWID     ),
.q0_TARGET_AXI_AWLEN        (q0_TARGET_AXI_AWLEN    ),
.q0_TARGET_AXI_AWSIZE       (q0_TARGET_AXI_AWSIZE   ),
.q0_TARGET_AXI_AWVALID      (q0_TARGET_AXI_AWVALID  ),
.q0_TARGET_AXI_AWUSER       (q0_TARGET_AXI_AWUSER   ),
.q0_TARGET_AXI_AWREADY      (q0_TARGET_AXI_AWREADY  ),
.q0_TARGET_AXI_WDATA        (q0_TARGET_AXI_WDATA    ),
.q0_TARGET_AXI_WDATA_PAR    (q0_TARGET_AXI_WDATA_PAR),
.q0_TARGET_AXI_WLAST        (q0_TARGET_AXI_WLAST    ),
.q0_TARGET_AXI_WSTRB        (q0_TARGET_AXI_WSTRB    ),
.q0_TARGET_AXI_WSTRB_PAR    (q0_TARGET_AXI_WSTRB_PAR),
.q0_TARGET_AXI_WVALID       (q0_TARGET_AXI_WVALID   ),
.q0_TARGET_AXI_WREADY       (q0_TARGET_AXI_WREADY   ),
.q0_TARGET_AXI_BID          (q0_TARGET_AXI_BID      ),
.q0_TARGET_AXI_BID_PAR      (q0_TARGET_AXI_BID_PAR  ),
.q0_TARGET_AXI_BRESP        (q0_TARGET_AXI_BRESP    ),
.q0_TARGET_AXI_BRESP_PAR    (q0_TARGET_AXI_BRESP_PAR),
.q0_TARGET_AXI_BVALID       (q0_TARGET_AXI_BVALID   ),
.q0_TARGET_AXI_BREADY       (q0_TARGET_AXI_BREADY   ),
//----Slave AXI4 Read Interface
.q0_TARGET_AXI_ARADDR       (q0_TARGET_AXI_ARADDR   ),
.q0_TARGET_AXI_ARID         (q0_TARGET_AXI_ARID     ),
.q0_TARGET_AXI_ARLEN        (q0_TARGET_AXI_ARLEN    ),
.q0_TARGET_AXI_ARSIZE       (q0_TARGET_AXI_ARSIZE   ),
.q0_TARGET_AXI_ARVALID      (q0_TARGET_AXI_ARVALID  ),
.q0_TARGET_AXI_ARUSER       (q0_TARGET_AXI_ARUSER   ),
.q0_TARGET_AXI_ARREADY      (q0_TARGET_AXI_ARREADY  ),
.q0_TARGET_AXI_RDATA        (q0_TARGET_AXI_RDATA    ),
.q0_TARGET_AXI_RDATA_PAR    (q0_TARGET_AXI_RDATA_PAR),
.q0_TARGET_AXI_RID          (q0_TARGET_AXI_RID      ),
.q0_TARGET_AXI_RID_PAR      (q0_TARGET_AXI_RID_PAR  ),
.q0_TARGET_AXI_RLAST        (q0_TARGET_AXI_RLAST    ),
.q0_TARGET_AXI_RRESP        (q0_TARGET_AXI_RRESP    ),
.q0_TARGET_AXI_RRESP_PAR    (q0_TARGET_AXI_RRESP_PAR),
.q0_TARGET_AXI_RVALID       (q0_TARGET_AXI_RVALID   ),
.q0_TARGET_AXI_RREADY       (q0_TARGET_AXI_RREADY   ),
//----Slave AXI4 Sideband Interface
.q0_TARGET_NON_POSTED_REJ   (q0_TARGET_NON_POSTED_REJ),
//--Master AXI4 Interface   
//----Master AXI4 Write Interface
.q0_MASTER_AXI_AWADDR       (q0_MASTER_AXI_AWADDR      ),
.q0_MASTER_AXI_AWID         (q0_MASTER_AXI_AWID        ),
.q0_MASTER_AXI_AWLEN        (q0_MASTER_AXI_AWLEN       ),
.q0_MASTER_AXI_AWSIZE       (q0_MASTER_AXI_AWSIZE      ),
.q0_MASTER_AXI_AWVALID      (q0_MASTER_AXI_AWVALID     ),
.q0_MASTER_AXI_AWUSER       (q0_MASTER_AXI_AWUSER      ),
.q0_MASTER_AXI_AWREADY      (q0_MASTER_AXI_AWREADY     ),
.q0_MASTER_AXI_WDATA        (q0_MASTER_AXI_WDATA       ),
.q0_MASTER_AXI_WDATA_PAR    (q0_MASTER_AXI_WDATA_PAR   ),
.q0_MASTER_AXI_WLAST        (q0_MASTER_AXI_WLAST       ),
.q0_MASTER_AXI_WSTRB        (q0_MASTER_AXI_WSTRB       ),
.q0_MASTER_AXI_WSTRB_PAR    (q0_MASTER_AXI_WSTRB_PAR   ),
.q0_MASTER_AXI_WVALID       (q0_MASTER_AXI_WVALID      ),
.q0_MASTER_AXI_WREADY       (q0_MASTER_AXI_WREADY      ),
.q0_MASTER_AXI_BID          (q0_MASTER_AXI_BID         ),
.q0_MASTER_AXI_BID_PAR      (q0_MASTER_AXI_BID_PAR     ),
.q0_MASTER_AXI_BRESP        (q0_MASTER_AXI_BRESP       ),
.q0_MASTER_AXI_BRESP_PAR    (q0_MASTER_AXI_BRESP_PAR   ),
.q0_MASTER_AXI_BVALID       (q0_MASTER_AXI_BVALID      ),
.q0_MASTER_AXI_BREADY       (q0_MASTER_AXI_BREADY      ),
//----Master AXI4 Read Interface
.q0_MASTER_AXI_ARADDR       (q0_MASTER_AXI_ARADDR       ),
.q0_MASTER_AXI_ARID         (q0_MASTER_AXI_ARID         ),
.q0_MASTER_AXI_ARLEN        (q0_MASTER_AXI_ARLEN        ),
.q0_MASTER_AXI_ARSIZE       (q0_MASTER_AXI_ARSIZE       ),
.q0_MASTER_AXI_ARVALID      (q0_MASTER_AXI_ARVALID      ),
.q0_MASTER_AXI_ARUSER       (q0_MASTER_AXI_ARUSER       ),
.q0_MASTER_AXI_ARREADY      (q0_MASTER_AXI_ARREADY      ),
.q0_MASTER_AXI_RDATA        (q0_MASTER_AXI_RDATA        ),
.q0_MASTER_AXI_RDATA_PAR    (q0_MASTER_AXI_RDATA_PAR    ),
.q0_MASTER_AXI_RID          (q0_MASTER_AXI_RID          ),
.q0_MASTER_AXI_RID_PAR      (q0_MASTER_AXI_RID_PAR      ),
.q0_MASTER_AXI_RLAST        (q0_MASTER_AXI_RLAST        ),
.q0_MASTER_AXI_RRESP        (q0_MASTER_AXI_RRESP        ),
.q0_MASTER_AXI_RRESP_PAR    (q0_MASTER_AXI_RRESP_PAR    ),
.q0_MASTER_AXI_RVALID       (q0_MASTER_AXI_RVALID       ),
.q0_MASTER_AXI_RREADY       (q0_MASTER_AXI_RREADY       ),
//--Master APB3 Interface
.q0_USER_APB_PADDR          (q0_USER_APB_PADDR          ),
.q0_USER_APB_PSEL           (q0_USER_APB_PSEL           ),
.q0_USER_APB_PENABLE        (q0_USER_APB_PENABLE        ),
.q0_USER_APB_PWRITE         (q0_USER_APB_PWRITE         ),
.q0_USER_APB_PWDATA         (q0_USER_APB_PWDATA         ),
.q0_USER_APB_PWDATA_PAR     (q0_USER_APB_PWDATA_PAR     ),
.q0_USER_APB_PSTRB          (q0_USER_APB_PSTRB          ),
.q0_USER_APB_PSTRB_PAR      (q0_USER_APB_PSTRB_PAR      ),
.q0_USER_APB_PRDATA         (q0_USER_APB_PRDATA         ),
.q0_USER_APB_PRDATA_PAR     (q0_USER_APB_PRDATA_PAR     ),
.q0_USER_APB_PREADY         (q0_USER_APB_PREADY         ),
.q0_USER_APB_PSLVERR        (q0_USER_APB_PSLVERR        ),
//--FLR
.q0_FLR_IN_PROGRESS         (q0_FLR_IN_PROGRESS         ),
.q0_FLR_DONE                (q0_FLR_DONE                ),
//--Interrupt Pin
.q0_LOCAL_INTERRUPT             (q0_LOCAL_INTERRUPT             ),
.q0_INTERRUPT_SIDEBAND_SIGNALS  (q0_INTERRUPT_SIDEBAND_SIGNALS),
//--Legacy Interrupt Pin
.q0_INTA_IN                     (q0_INTA_IN                    ),
.q0_INTB_IN                     (q0_INTB_IN                    ),
.q0_INTC_IN                     (q0_INTC_IN                    ),
.q0_INTD_IN                     (q0_INTD_IN                    ),
.q0_INT_PENDING_STATUS          (q0_INT_PENDING_STATUS         ),
.q0_INT_ACK                     (q0_INT_ACK                    ),
//--Message Pin
.q0_MSG                         (q0_MSG                ),
.q0_MSG_BYTE_EN                 (q0_MSG_BYTE_EN        ),
.q0_MSG_DATA                    (q0_MSG_DATA           ),
.q0_MSG_END                     (q0_MSG_END            ),
.q0_MSG_PASID                   (q0_MSG_PASID          ),
.q0_MSG_PASID_PRESENT           (q0_MSG_PASID_PRESENT  ),
.q0_MSG_START                   (q0_MSG_START          ),
.q0_MSG_VALID                   (q0_MSG_VALID          ),
.q0_MSG_VDH                     (q0_MSG_VDH            ),
//--Error Pin
.q0_CORRECTABLE_ERROR_IN        (q0_CORRECTABLE_ERROR_IN        ),
.q0_UNCORRECTABLE_ERROR_IN      (q0_UNCORRECTABLE_ERROR_IN      ),
.q0_FATAL_ERROR_OUT             (q0_FATAL_ERROR_OUT             ),
.q0_NON_FATAL_ERROR_OUT         (q0_NON_FATAL_ERROR_OUT         ),
.q0_CORRECTABLE_ERROR_OUT       (q0_CORRECTABLE_ERROR_OUT       ),
//--Status Pin
.q0_LTSSM_STATE                 (q0_LTSSM_STATE                 ),
.q0_REG_ACCESS_CLK_SHUTOFF      (q0_REG_ACCESS_CLK_SHUTOFF      ),
.q0_CORE_CLK_SHUTOFF            (q0_CORE_CLK_SHUTOFF            ),
.q0_LINK_STATUS                 (q0_LINK_STATUS                 ),
.q0_FUNCTION_STATUS             (q0_FUNCTION_STATUS             ),
.q0_PCIE_MAX_READ_REQ_SIZE      (q0_PCIE_MAX_READ_REQ_SIZE      ),
.q0_PCIE_MAX_PAYLOAD_SIZE       (q0_PCIE_MAX_PAYLOAD_SIZE       ),
.q0_PIPE_P00_RATE               (q0_PIPE_P00_RATE               ),
.q0_PMA_CMN_READY               (q0_PMA_CMN_READY               ),
//--Configuration Snoop Pin
.q0_CONFIG_READ_DATA            (q0_CONFIG_READ_DATA            ),
.q0_CONFIG_READ_DATA_PAR        (q0_CONFIG_READ_DATA_PAR        ),
.q0_CONFIG_READ_DATA_VALID      (q0_CONFIG_READ_DATA_VALID      ), 
.q0_CONFIG_READ_RECEIVED        (q0_CONFIG_READ_RECEIVED        ),
.q0_CONFIG_REG_NUM              (q0_CONFIG_REG_NUM              ),
.q0_CONFIG_WRITE_BYTE_ENABLE    (q0_CONFIG_WRITE_BYTE_ENABLE    ),
.q0_CONFIG_WRITE_BYTE_ENABLE_PAR(q0_CONFIG_WRITE_BYTE_ENABLE_PAR),
.q0_CONFIG_WRITE_DATA           (q0_CONFIG_WRITE_DATA           ),
.q0_CONFIG_WRITE_DATA_PAR       (q0_CONFIG_WRITE_DATA_PAR       ),  
.q0_CONFIG_WRITE_RECEIVED       (q0_CONFIG_WRITE_RECEIVED       ),
.q0_CONFIG_FUNCTION_NUM         (q0_CONFIG_FUNCTION_NUM         ),
.q0_DEBUG_DATA_OUT              (q0_DEBUG_DATA_OUT              ),
.q0_FPGA_DIV2_CLK               (q0_FPGA_DIV2_CLK               ),
.q0_FPGA_DIV2_CLK_io            (q0_FPGA_DIV2_CLK_io            ),


//AXI Stream Master  
.tx_src_axis_tready         (tx_src_axis_tready         ),
.tx_src_axis_tdata          (tx_src_axis_tdata          ),
.tx_src_axis_tvalid         (tx_src_axis_tvalid         ),
.tx_src_axis_tlast          (tx_src_axis_tlast          ),
.rx_src_axis_tready         (rx_src_axis_tready         ),
.rx_src_axis_tdata          (rx_src_axis_tdata          ),
.rx_src_axis_tvalid         (rx_src_axis_tvalid         ),
.rx_src_axis_tlast          (rx_src_axis_tlast          ),

//apb3 slave interface for MAC (encoded Address range inside edma module).  
.mac_l2_apb3_paddr          (mac_l2_apb3_paddr      ),
.mac_l2_apb3_psel           (mac_l2_apb3_psel       ),
.mac_l2_apb3_penable        (mac_l2_apb3_penable    ),
.mac_l2_apb3_pready         (mac_l2_apb3_pready     ),
.mac_l2_apb3_pwrite         (mac_l2_apb3_pwrite     ),//0:rd; 1:wr;
.mac_l2_apb3_pwdata         (mac_l2_apb3_pwdata     ),
.mac_l2_apb3_prdata         (mac_l2_apb3_prdata     ),
.mac_l2_apb3_pslverror      (mac_l2_apb3_pslverror  ),  

 //abp3 slave interface for system to communicate with board Logic. 
.Board_status(Board_status),


.master_Control_Input_A(master_Control_Input_A),
.master_Control_Status_A(master_Control_Status_A),
.master_Control_Input_B(master_Control_Input_B),
.master_Control_Status_B(master_Control_Status_B),
.master_Control_Input_C(master_Control_Input_C),
.master_Control_Status_C(master_Control_Status_C),


//Debugging by vio
.rstn_vio                   (rstn_vio         ),
.q0_apb_start               (q0_apb_start     ),
.q0_paddr_test              (q0_paddr_test    ),
.q0_pwdata_vio              (q0_pwdata_vio    ),
.q0_pwdata_par_vio          (q0_pwdata_par_vio),
.q0_write_vio               (q0_write_vio     ),
.q0_obs_pstates             (q0_obs_pstates   ),
.q0_prdata_test             (q0_prdata_test   ), 
.q0_apb_done                (q0_apb_done      ),  



//Probe Signals for S0_AXI and S1_AXI
.debug_ddr_err              (debug_ddr_err              ),
.debug_ddr_rd_err           (debug_ddr_rd_err           ),
.debug_data_rev             (debug_data_rev             ),
.debug_data_err_temp        (debug_data_err_temp        ), 

//----Probe Signals for Slave AXI4 Sideband Interface

.debug_s0_axi_awvalid       (debug_s0_axi_awvalid       ),
.debug_s0_axi_awready       (debug_s0_axi_awready       ),
.debug_s0_axi_awaddr        (debug_s0_axi_awaddr        ),
.debug_s0_axi_awlen         (debug_s0_axi_awlen         ),
.debug_s0_axi_wvalid        (debug_s0_axi_wvalid        ),
.debug_s0_axi_wready        (debug_s0_axi_wready        ),
.debug_s0_axi_wdata         (debug_s0_axi_wdata         ),
.debug_s0_axi_wstrb         (debug_s0_axi_wstrb         ),
.debug_s0_axi_wlast         (debug_s0_axi_wlast         ),
.debug_s0_axi_bvalid        (debug_s0_axi_bvalid        ),
.debug_s0_axi_bready        (debug_s0_axi_bready        ),
.debug_s0_axi_bresp         (debug_s0_axi_bresp         ),
.debug_s0_axi_arvalid       (debug_s0_axi_arvalid       ),
.debug_s0_axi_arready       (debug_s0_axi_arready       ),
.debug_s0_axi_araddr        (debug_s0_axi_araddr        ),
.debug_s0_axi_arlen         (debug_s0_axi_arlen         ),
.debug_s0_axi_rvalid        (debug_s0_axi_rvalid        ),
.debug_s0_axi_rready        (debug_s0_axi_rready        ),
.debug_s0_axi_rdata         (debug_s0_axi_rdata         ),
.debug_s0_axi_rlast         (debug_s0_axi_rlast         ),
.debug_s0_axi_rresp         (debug_s0_axi_rresp         ),

.debug_s1_axi_awvalid       (debug_s1_axi_awvalid       ),
.debug_s1_axi_awready       (debug_s1_axi_awready       ),
.debug_s1_axi_awaddr        (debug_s1_axi_awaddr        ),
.debug_s1_axi_awlen         (debug_s1_axi_awlen         ),
.debug_s1_axi_wvalid        (debug_s1_axi_wvalid        ),
.debug_s1_axi_wready        (debug_s1_axi_wready        ),
.debug_s1_axi_wdata         (debug_s1_axi_wdata         ),
.debug_s1_axi_wstrb         (debug_s1_axi_wstrb         ),
.debug_s1_axi_wlast         (debug_s1_axi_wlast         ),
.debug_s1_axi_bvalid        (debug_s1_axi_bvalid        ),
.debug_s1_axi_bready        (debug_s1_axi_bready        ),
.debug_s1_axi_bresp         (debug_s1_axi_bresp         ),
.debug_s1_axi_arvalid       (debug_s1_axi_arvalid       ),
.debug_s1_axi_arready       (debug_s1_axi_arready       ),
.debug_s1_axi_araddr        (debug_s1_axi_araddr        ),
.debug_s1_axi_arlen         (debug_s1_axi_arlen         ),
.debug_s1_axi_rvalid        (debug_s1_axi_rvalid        ),
.debug_s1_axi_rready        (debug_s1_axi_rready        ),
.debug_s1_axi_rdata         (debug_s1_axi_rdata         ),
.debug_s1_axi_rlast         (debug_s1_axi_rlast         ),
.debug_s1_axi_rresp         (debug_s1_axi_rresp         ),
.debug_l2_rx_axis_mac_tkeep (debug_l2_rx_axis_mac_tkeep )


);



/*----------------------- XGETH Region ----------------------------*/
eth_platform#(
    .AXIS_DW                            (64                                 )
)
u_xgeth
(
    .clk_100m                           (clk_100m                           ),
    .clk100m_rstn                       (clk_100m_rstn                      ),
    .clk_250m                           (clk_250m                           ),
    .clk250m_rstn                       (clk_250m_rstn                      ),
    .clk156m_rstn                       (clk_156m_rstn                      ),

//XGMAC PHY XGMII Interface
//--Debug Signals
    .Q1_PMA_CMN_READY                   (Q1_PMA_CMN_READY                   ),
//--Q1 APB3 interface
    .Q1_USER_APB_PRDATA                 (Q1_USER_APB_PRDATA                 ),
    .Q1_USER_APB_PREADY                 (Q1_USER_APB_PREADY                 ),
    .Q1_USER_APB_PADDR                  (Q1_USER_APB_PADDR                  ),
    .Q1_USER_APB_PWDATA                 (Q1_USER_APB_PWDATA                 ),
    .Q1_USER_APB_PWRITE                 (Q1_USER_APB_PWRITE                 ),
    .Q1_USER_APB_PSEL                   (Q1_USER_APB_PSEL                   ),
    .Q1_USER_APB_PENABLE                (Q1_USER_APB_PENABLE                ),
//--Q1 clk rerset interface
    .Q1_L2_10gbe_clk                    (Q1_L2_10gbe_clk                    ),
    .Q1_L2_PCS_RST_N_RX                 (Q1_L2_PCS_RST_N_RX                 ),
    .Q1_L2_PCS_RST_N_TX                 (Q1_L2_PCS_RST_N_TX                 ),
    .Q1_L2_PHY_RESET_N                  (Q1_L2_PHY_RESET_N                  ),
//--Q1 control interface
    .Q1_L2_ETH_EEE_ALERT_EN             (Q1_L2_ETH_EEE_ALERT_EN             ),
    .Q1_L2_PMA_TX_ELEC_IDLE             (Q1_L2_PMA_TX_ELEC_IDLE             ),
//--Q1 power up interface
    .Q1_L2_PMA_XCVR_POWER_STATE_ACK     (Q1_L2_PMA_XCVR_POWER_STATE_ACK     ),
    .Q1_L2_PMA_XCVR_PLLCLK_EN_ACK       (Q1_L2_PMA_XCVR_PLLCLK_EN_ACK       ),
    .Q1_L2_PMA_RX_SIGNAL_DETECT         (Q1_L2_PMA_RX_SIGNAL_DETECT         ),
    .Q1_L2_PMA_XCVR_POWER_STATE_REQ     (Q1_L2_PMA_XCVR_POWER_STATE_REQ     ),
    .Q1_L2_PMA_XCVR_PLLCLK_EN           (Q1_L2_PMA_XCVR_PLLCLK_EN           ),
//--Q1 xgmii interface
    .Q1_L2_RXC                          (Q1_L2_RXC                          ),
    .Q1_L2_RXD                          (Q1_L2_RXD                          ),
    .Q1_L2_TXD                          (Q1_L2_TXD                          ),
    .Q1_L2_TXC                          (Q1_L2_TXC                          ),
//Slave AXI-Stream Interface(Connect to PCIe Wrapper)
    .l2_tx_axis_mac_tdata               (tx_src_axis_tdata                  ),
    .l2_tx_axis_mac_tvalid              (tx_src_axis_tvalid                 ),
    .l2_tx_axis_mac_tlast               (tx_src_axis_tlast                  ),
    .l2_tx_axis_mac_tkeep               (8'hff                              ),
    .l2_tx_axis_mac_tuser               (1'b0                               ),
    .l2_tx_axis_mac_tready              (tx_src_axis_tready                 ),
//Master AXI-Stream Interface(Connect to PCIe Wrapper)
    .l2_rx_axis_mac_tdata               (rx_src_axis_tdata                  ),
    .l2_rx_axis_mac_tvalid              (rx_src_axis_tvalid                 ),
    .l2_rx_axis_mac_tlast               (rx_src_axis_tlast                  ),
    .l2_rx_axis_mac_tkeep               (l2_rx_axis_mac_tkeep               ),
    .l2_rx_axis_mac_tuser               (/*Not Used*/                       ),
    .l2_rx_axis_mac_tready              (rx_src_axis_tready                 ),
//Slave APB3 Interface(Connect to PCIe Wrapper)
    .mac_l2_apb3_paddr                  (mac_l2_apb3_paddr                  ),
    .mac_l2_apb3_psel                   (mac_l2_apb3_psel                   ),
    .mac_l2_apb3_penable                (mac_l2_apb3_penable                ),
    .mac_l2_apb3_pready                 (mac_l2_apb3_pready                 ),
    .mac_l2_apb3_pwrite                 (mac_l2_apb3_pwrite                 ),
    .mac_l2_apb3_pwdata                 (mac_l2_apb3_pwdata                 ),
    .mac_l2_apb3_prdata                 (mac_l2_apb3_prdata                 ),
    .mac_l2_apb3_pslverror              (mac_l2_apb3_pslverror              ),
//Optical Module Interface
    .SFP_TXDISABLE                      (SFP_TXDISABLE                      )

);


                                               
endmodule
