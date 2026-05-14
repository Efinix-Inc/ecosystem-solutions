
`timescale 1 ns / 1 ns
module pcie_dma_top(
//Globle Signals
input                           clk_100m,
input                           clk_200m,
input                           clk_250m,
input                           clk_100m_rstn,
input                           clk_200m_rstn,
input                           clk_250m_rstn,
input                           perst0,

//input                           jtag_inst1_CAPTURE,
//input                           jtag_inst1_DRCK,
//input                           jtag_inst1_RESET,
//input                           jtag_inst1_RUNTEST,
//input                           jtag_inst1_SEL,
//input                           jtag_inst1_SHIFT,
//input                           jtag_inst1_TCK,
//input                           jtag_inst1_TDI,
//input                           jtag_inst1_TMS,
//input                           jtag_inst1_UPDATE,
//output                          jtag_inst1_TDO,
//LPDDR4 Controller Interface
//--Master AXI4 Interface
input                           axi0_ARREADY,
input                           axi0_AWREADY,
input           [5:0]           axi0_BID,
input           [1:0]           axi0_BRESP,
input                           axi0_BVALID,
input           [511:0]         axi0_RDATA,
input           [5:0]           axi0_RID,
input                           axi0_RLAST,
input           [1:0]           axi0_RRESP,
input                           axi0_RVALID,
input                           axi0_WREADY,
output  wire    [32:0]          axi0_ARADDR,
output  wire                    axi0_ARAPCMD,
output  wire    [1:0]           axi0_ARBURST,
output  wire    [5:0]           axi0_ARID,
output  wire    [7:0]           axi0_ARLEN,
output  wire                    axi0_ARLOCK,
output  wire                    axi0_ARQOS,
output  wire    [2:0]           axi0_ARSIZE,
output  wire                    axi0_ARESETn,
output  wire                    axi0_ARVALID,
output  wire    [32:0]          axi0_AWADDR,
output  wire                    axi0_AWALLSTRB,
output  wire                    axi0_AWAPCMD,
output  wire    [1:0]           axi0_AWBURST,
output  wire    [3:0]           axi0_AWCACHE,
output  wire    [2:0]           axi0_AWPROT,
output  wire    [3:0]           axi0_ARCACHE,
output  wire    [2:0]           axi0_ARPROT,
output  wire                    axi0_AWCOBUF,
output  wire    [5:0]           axi0_AWID,
output  wire    [7:0]           axi0_AWLEN,
output  wire                    axi0_AWLOCK,
output  wire                    axi0_AWQOS,
output  wire    [2:0]           axi0_AWSIZE,
output  wire                    axi0_AWVALID,
output  wire                    axi0_BREADY,
output  wire                    axi0_RREADY,
output  wire    [511:0]         axi0_WDATA,
output  wire                    axi0_WLAST,
output  wire    [63:0]          axi0_WSTRB,
output  wire                    axi0_WVALID,
//--Configuration Interface
output  wire                    ddr_inst_CFG_RST,    //Active-high DDR configuration controller reset.
output  wire                    ddr_inst_CFG_START,    //Start the DDR configuration controller.
input                           ddr_inst_CFG_DONE,    //Indicates the controller configuration is done
output  wire                    ddr_inst_CFG_SEL,    
output  wire                    ddr_pll_rstn,


//Extra Salve port for accessing LPDDR4 Controller Interface 
input                           s2_axi_awvalid,
output  wire                    s2_axi_awready,
input           [31:0]    s2_axi_awaddr,
input           [7:0]           s2_axi_awlen,
input                           s2_axi_wvalid,
output  wire                    s2_axi_wready,
input           [511:0] s2_axi_wdata,
input           [63:0]
                                s2_axi_wstrb,
input                           s2_axi_wlast,
output  wire                    s2_axi_bvalid,
input                           s2_axi_bready,
output  wire    [1:0]           s2_axi_bresp,
input                           s2_axi_arvalid,
output  wire                    s2_axi_arready,
input           [31:0]    	s2_axi_araddr,
input           [7:0]           s2_axi_arlen,
output  wire                    s2_axi_rvalid,
input                           s2_axi_rready,
output  wire    [511:0] s2_axi_rdata,
output  wire                    s2_axi_rlast,
output  wire    [1:0]           s2_axi_rresp,




//PCIe Interface
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

//AXI Stream Master  
input  wire          tx_src_axis_tready,
output wire [63:0]   tx_src_axis_tdata ,
output wire          tx_src_axis_tvalid,
output wire          tx_src_axis_tlast ,

output wire          rx_src_axis_tready,
input  wire [63:0]   rx_src_axis_tdata ,
input  wire          rx_src_axis_tvalid,
input  wire          rx_src_axis_tlast ,

//apb3 slave interface for MAC (encoded Address range inside edma module).  
output wire  [9:0]    mac_l2_apb3_paddr,
output wire           mac_l2_apb3_psel,
output wire           mac_l2_apb3_penable,
input  wire           mac_l2_apb3_pready,
output wire           mac_l2_apb3_pwrite,//0:rd; 1:wr;
output wire  [31:0]   mac_l2_apb3_pwdata,
input  wire  [31:0]   mac_l2_apb3_prdata,
input  wire           mac_l2_apb3_pslverror,  

//abp3 slave interface for system to communicate with board Logic. 
 input   [7:0]     Board_status,
 output  [31:0]	   master_Control_Input_A,
 input   [31:0]	   master_Control_Status_A,
 output  [31:0]	   master_Control_Input_B,
 input   [31:0]	   master_Control_Status_B,
 output  [31:0]	   master_Control_Input_C,
 input   [31:0]	   master_Control_Status_C,


////XGMAC PHY XGMII Interface
////--Debug Signals
//input                           Q1_PMA_CMN_READY,
////--Q1 APB3 interface
//input            [31:0]         Q1_USER_APB_PRDATA,
//input                           Q1_USER_APB_PREADY,
//output           [23:0]         Q1_USER_APB_PADDR,
//output           [31:0]         Q1_USER_APB_PWDATA,
//output                          Q1_USER_APB_PWRITE,
//output                          Q1_USER_APB_PSEL,
//output                          Q1_USER_APB_PENABLE,
////--Q1 clk rerset interface
//input                           Q1_L2_10gbe_clk,
//output                          Q1_L2_PCS_RST_N_RX,
//output                          Q1_L2_PCS_RST_N_TX,
//output                          Q1_L2_PHY_RESET_N,
////--Q1 control interface
//output                          Q1_L2_ETH_EEE_ALERT_EN,
//output                          Q1_L2_PMA_TX_ELEC_IDLE,
////--Q1 power up interface
//input           [3:0]           Q1_L2_PMA_XCVR_POWER_STATE_ACK,
//input                           Q1_L2_PMA_XCVR_PLLCLK_EN_ACK,
//input                           Q1_L2_PMA_RX_SIGNAL_DETECT,
//output          [3:0]           Q1_L2_PMA_XCVR_POWER_STATE_REQ,
//output                          Q1_L2_PMA_XCVR_PLLCLK_EN,
////--Q1 xgmii interface
//input           [7:0]           Q1_L2_RXC,
//input           [63:0]          Q1_L2_RXD,
//output  wire    [63:0]          Q1_L2_TXD,
//output  wire    [7:0]           Q1_L2_TXC,
////Optical Module Interface
//output          [3:0]           SFP_TXDISABLE





//Debugging by vio
input  wire          rstn_vio         ,
input  wire          q0_apb_start     ,
input  wire [ 23:0]  q0_paddr_test    ,
input  wire [ 31:0]  q0_pwdata_vio    ,
input  wire [  3:0]  q0_pwdata_par_vio,
input  wire          q0_write_vio     ,
output wire [  3:0]  q0_obs_pstates   ,
output wire  [31:0]  q0_prdata_test   , 
output wire          q0_apb_done      ,  


//Probe Signals for S0_AXI and S1_AXI
output                                  debug_ddr_err,
output                                  debug_ddr_rd_err,
output  [63:0]                          debug_data_rev,
output  [15:0]                          debug_data_err_temp, 

//----Probe Signals for Slave AXI4 Sideband Interface

output wire                            debug_s0_axi_awvalid,
output wire                            debug_s0_axi_awready,
output wire    [63:0]                  debug_s0_axi_awaddr,
output wire    [7:0]                   debug_s0_axi_awlen,
output wire                            debug_s0_axi_wvalid,
output wire                            debug_s0_axi_wready,
output wire    [255:0]                 debug_s0_axi_wdata,
output wire    [31:0]                  debug_s0_axi_wstrb,
output wire                            debug_s0_axi_wlast,
output wire                            debug_s0_axi_bvalid,
output wire                            debug_s0_axi_bready,
output wire    [1:0]                   debug_s0_axi_bresp,
output wire                            debug_s0_axi_arvalid,
output wire                            debug_s0_axi_arready,
output wire    [63:0]                  debug_s0_axi_araddr,
output wire    [7:0]                   debug_s0_axi_arlen,
output wire                            debug_s0_axi_rvalid,
output wire                            debug_s0_axi_rready,
output wire    [255:0]                 debug_s0_axi_rdata,
output wire                            debug_s0_axi_rlast,
output wire    [1:0]                   debug_s0_axi_rresp,

output wire                            debug_s1_axi_awvalid,
output wire                            debug_s1_axi_awready,
output wire    [63:0]                  debug_s1_axi_awaddr,
output wire    [7:0]                   debug_s1_axi_awlen,
output wire                            debug_s1_axi_wvalid,
output wire                            debug_s1_axi_wready,
output wire    [63:0]                  debug_s1_axi_wdata,
output wire    [7:0]                   debug_s1_axi_wstrb,
output wire                            debug_s1_axi_wlast,
output wire                            debug_s1_axi_bvalid,
output wire                            debug_s1_axi_bready,
output wire    [1:0]                   debug_s1_axi_bresp,
output wire                            debug_s1_axi_arvalid,
output wire                            debug_s1_axi_arready,
output wire    [63:0]                  debug_s1_axi_araddr,
output wire    [7:0]                   debug_s1_axi_arlen,
output wire                            debug_s1_axi_rvalid,
output wire                            debug_s1_axi_rready,
output wire    [63:0]                  debug_s1_axi_rdata,
output wire                            debug_s1_axi_rlast,
output wire    [1:0]                   debug_s1_axi_rresp,
output wire    [7:0]                   debug_l2_rx_axis_mac_tkeep



);
//Parameter Define 

//Register Define

//Wire Define
//--AXI-Stream Interface
//wire    [2*1-1:0]               axis_tvalid;
//wire    [2*64-1:0]              axis_tdata;
//wire    [2*1-1:0]               axis_tlast;
//wire    [2*1-1:0]               axis_tready;
////--APB3 Interface
//wire    [1*10-1:0]              apb3_paddr;
//wire    [1*1-1:0]               apb3_psel;
//wire    [1*1-1:0]               apb3_penable;
//wire    [1*1-1:0]               apb3_pready;
//wire    [1*1-1:0]               apb3_pwrite;
//wire    [1*32-1:0]              apb3_pwdata;
//wire    [1*32-1:0]              apb3_prdata;
//wire    [1*1-1:0]               apb3_pslverror;

wire                            rstn_vio        ;
wire                            q0_apb_start    ;
wire    [ 23:0]                 q0_paddr_test   ;
wire    [ 31:0]                 q0_pwdata_vio   ;
wire    [  3:0]                 q0_pwdata_par_vi;
wire                            q0_write_vio    ;
wire    [  3:0]                 q0_obs_pstates  ;
wire     [31:0]                 q0_prdata_test   ;
wire                            q0_apb_done     ;
//--AXI4 Interface
//----Slave AXI4 Write Interface
wire    [63:0]                  r_TARGET_AXI_AWADDR;
wire    [7:0]                   r_TARGET_AXI_AWID;
wire    [7:0]                   r_TARGET_AXI_AWLEN;
wire    [2:0]                   r_TARGET_AXI_AWSIZE;
wire                            r_TARGET_AXI_AWVALID;
wire    [87:0]                  r_TARGET_AXI_AWUSER;
wire                            r_TARGET_AXI_AWREADY;
wire    [255:0]                 r_TARGET_AXI_WDATA;
wire    [31:0]                  r_TARGET_AXI_WDATA_PAR;
wire                            r_TARGET_AXI_WLAST;
wire    [31:0]                  r_TARGET_AXI_WSTRB;
wire    [3:0]                   r_TARGET_AXI_WSTRB_PAR;
wire                            r_TARGET_AXI_WVALID;
wire                            r_TARGET_AXI_WREADY;
wire    [7:0]                   r_TARGET_AXI_BID;
wire                            r_TARGET_AXI_BID_PAR;
wire    [1:0]                   r_TARGET_AXI_BRESP;
wire                            r_TARGET_AXI_BRESP_PAR;
wire                            r_TARGET_AXI_BVALID;
wire                            r_TARGET_AXI_BREADY;
//----Slave AXI4 Read Interface          
wire    [63:0]                  r_TARGET_AXI_ARADDR;
wire    [7:0]                   r_TARGET_AXI_ARID;
wire    [7:0]                   r_TARGET_AXI_ARLEN;
wire    [2:0]                   r_TARGET_AXI_ARSIZE;
wire                            r_TARGET_AXI_ARVALID;
wire    [87:0]                  r_TARGET_AXI_ARUSER;
wire                            r_TARGET_AXI_ARREADY;
wire    [255:0]                 r_TARGET_AXI_RDATA;
wire    [31:0]                  r_TARGET_AXI_RDATA_PAR;
wire    [7:0]                   r_TARGET_AXI_RID;
wire                            r_TARGET_AXI_RID_PAR;
wire                            r_TARGET_AXI_RLAST;
wire    [1:0]                   r_TARGET_AXI_RRESP;
wire                            r_TARGET_AXI_RRESP_PAR;
wire                            r_TARGET_AXI_RVALID;
wire                            r_TARGET_AXI_RREADY;

//----Master AXI4 Write Interface
wire    [63:0]                  r_MASTER_AXI_AWADDR;
wire    [7:0]                   r_MASTER_AXI_AWID;
wire    [7:0]                   r_MASTER_AXI_AWLEN;
wire    [2:0]                   r_MASTER_AXI_AWSIZE;
wire                            r_MASTER_AXI_AWVALID;
wire    [87:0]                  r_MASTER_AXI_AWUSER;
wire                            r_MASTER_AXI_AWREADY;
wire    [255:0]                 r_MASTER_AXI_WDATA;
wire    [31:0]                  r_MASTER_AXI_WDATA_PAR;
wire                            r_MASTER_AXI_WLAST;
wire    [31:0]                  r_MASTER_AXI_WSTRB;
wire    [3:0]                   r_MASTER_AXI_WSTRB_PAR;
wire                            r_MASTER_AXI_WVALID;
wire                            r_MASTER_AXI_WREADY;
wire    [7:0]                   r_MASTER_AXI_BID;
wire                            r_MASTER_AXI_BID_PAR;
wire    [1:0]                   r_MASTER_AXI_BRESP;
wire                            r_MASTER_AXI_BRESP_PAR;
wire                            r_MASTER_AXI_BVALID;
wire                            r_MASTER_AXI_BREADY;
//----Master AXI4 Read Interface         
wire    [63:0]                  r_MASTER_AXI_ARADDR;
wire    [7:0]                   r_MASTER_AXI_ARID;
wire    [7:0]                   r_MASTER_AXI_ARLEN;
wire    [2:0]                   r_MASTER_AXI_ARSIZE;
wire                            r_MASTER_AXI_ARVALID;
wire    [87:0]                  r_MASTER_AXI_ARUSER;
wire                            r_MASTER_AXI_ARREADY;
wire    [255:0]                 r_MASTER_AXI_RDATA;
wire    [31:0]                  r_MASTER_AXI_RDATA_PAR;
wire    [7:0]                   r_MASTER_AXI_RID;
wire                            r_MASTER_AXI_RID_PAR;
wire                            r_MASTER_AXI_RLAST;
wire    [1:0]                   r_MASTER_AXI_RRESP;
wire                            r_MASTER_AXI_RRESP_PAR;
wire                            r_MASTER_AXI_RVALID;
wire                            r_MASTER_AXI_RREADY;

//----Slave AXI4 Sideband Interface

wire                            s0_axi_awvalid;
wire                            s0_axi_awready;
wire    [63:0]                  s0_axi_awaddr;
wire    [7:0]                   s0_axi_awlen;
wire                            s0_axi_wvalid;
wire                            s0_axi_wready;
wire    [255:0]                 s0_axi_wdata;
wire    [31:0]                  s0_axi_wstrb;
wire                            s0_axi_wlast;
wire                            s0_axi_bvalid;
wire                            s0_axi_bready;
wire    [1:0]                   s0_axi_bresp;
wire                            s0_axi_arvalid;
wire                            s0_axi_arready;
wire    [63:0]                  s0_axi_araddr;
wire    [7:0]                   s0_axi_arlen;
wire                            s0_axi_rvalid;
wire                            s0_axi_rready;
wire    [255:0]                 s0_axi_rdata;
wire                            s0_axi_rlast;
wire    [1:0]                   s0_axi_rresp;

wire                            s1_axi_awvalid;
wire                            s1_axi_awready;
wire    [63:0]                  s1_axi_awaddr;
wire    [7:0]                   s1_axi_awlen;
wire                            s1_axi_wvalid;
wire                            s1_axi_wready;
wire    [63:0]                  s1_axi_wdata;
wire    [7:0]                   s1_axi_wstrb;
wire                            s1_axi_wlast;
wire                            s1_axi_bvalid;
wire                            s1_axi_bready;
wire    [1:0]                   s1_axi_bresp;
wire                            s1_axi_arvalid;
wire                            s1_axi_arready;
wire    [63:0]                  s1_axi_araddr;
wire    [7:0]                   s1_axi_arlen;
wire                            s1_axi_rvalid;
wire                            s1_axi_rready;
wire    [63:0]                  s1_axi_rdata;
wire                            s1_axi_rlast;
wire    [1:0]                   s1_axi_rresp;
wire    [7:0]                   l2_rx_axis_mac_tkeep;

wire    [7:0]                   m1_axi_awid    ;
wire                            m1_axi_awvalid ;
wire    [63:0]                  m1_axi_awaddr  ;
wire    [7:0]                   m1_axi_awlen   ;
wire    [2:0]                   m1_axi_awsize  ;
wire                            m1_axi_awready ;
wire                            m1_axi_wvalid  ;
wire    [255:0]                 m1_axi_wdata   ;
wire    [31:0]                  m1_axi_wstrb   ;
wire                            m1_axi_wlast   ;
wire                            m1_axi_wready  ;
wire    [7:0]                   m1_axi_bid     ;
wire    [1:0]                   m1_axi_bresp   ;
wire                            m1_axi_bvalid  ;
wire                            m1_axi_bready  ;
wire    [7:0]                   m1_axi_arid    ;
wire                            m1_axi_arvalid ;
wire    [63:0]                  m1_axi_araddr  ;
wire    [7:0]                   m1_axi_arlen   ;
wire    [2:0]                   m1_axi_arsize  ;
wire                            m1_axi_arready ;
wire    [7:0]                   m1_axi_rid     ;
wire                            m1_axi_rvalid  ;
wire    [255:0]                 m1_axi_rdata   ;
wire                            m1_axi_rlast   ;
wire    [1:0]                   m1_axi_rresp   ;
wire                            m1_axi_rready  ;

/*----------------------------------------------------------------------------------*\
                                 The main code
\*----------------------------------------------------------------------------------*/



/*----------------------- LPDDR4 Region ----------------------------*/
interconnect_wrapper #(
    .AXI_AW                             (64                                 ), 
    .S0_AXI_DW                          (256                                ),
    .S1_AXI_DW                          (64                                 ),
    .S2_AXI_DW                          (512                                ),
    .M_AXI_DW                           (512                                ),

    .ASYNC                              (1'b1                               ),
    .S0_AXI_REG_EN                      (5'b00000                           ),
    .M0_AXI_REG_EN                      (5'b00000                           ),
    .S1_AXI_REG_EN                      (5'b00000                           ),
    .M1_AXI_REG_EN                      (5'b00000                           ),
    .S2_AXI_REG_EN                      (5'b00000                           ),
    .M2_AXI_REG_EN                      (5'b00000                           ),
    .FAMILY                             ("TITANIUM"                         )           
)
u_lpddr4
(
//Slave AXI4 Bus 0
    .clk_250m                           (clk_250m                           ),
    .clk_250m_rstn                      (clk_250m_rstn                      ),
//--AXI4 Write Bus
    .s0_axi_awvalid                     (s0_axi_awvalid                     ),
    .s0_axi_awready                     (s0_axi_awready                     ),
    .s0_axi_awaddr                      (s0_axi_awaddr                      ),
    .s0_axi_awlen                       (s0_axi_awlen                       ),
    .s0_axi_wvalid                      (s0_axi_wvalid                      ),
    .s0_axi_wready                      (s0_axi_wready                      ),
    .s0_axi_wdata                       (s0_axi_wdata                       ),
    .s0_axi_wstrb                       (s0_axi_wstrb                       ),
    .s0_axi_wlast                       (s0_axi_wlast                       ),
    .s0_axi_bvalid                      (s0_axi_bvalid                      ),
    .s0_axi_bready                      (s0_axi_bready                      ),
    .s0_axi_bresp                       (s0_axi_bresp                       ),
//--AXI4 Read Bus
    .s0_axi_arvalid                     (s0_axi_arvalid                     ),
    .s0_axi_arready                     (s0_axi_arready                     ),
    .s0_axi_araddr                      (s0_axi_araddr                      ),
    .s0_axi_arlen                       (s0_axi_arlen                       ),
    .s0_axi_rvalid                      (s0_axi_rvalid                      ),
    .s0_axi_rready                      (s0_axi_rready                      ),
    .s0_axi_rdata                       (s0_axi_rdata                       ),
    .s0_axi_rlast                       (s0_axi_rlast                       ),
    .s0_axi_rresp                       (s0_axi_rresp                       ),
//Slave AXI4 Bus 1
//--AXI4 Write Bus
    .s1_axi_awvalid                     (s1_axi_awvalid                     ),
    .s1_axi_awready                     (s1_axi_awready                     ),
    .s1_axi_awaddr                      (s1_axi_awaddr                      ),
    .s1_axi_awlen                       (s1_axi_awlen                       ),
    .s1_axi_wvalid                      (s1_axi_wvalid                      ),
    .s1_axi_wready                      (s1_axi_wready                      ),
    .s1_axi_wdata                       (s1_axi_wdata                       ),
    .s1_axi_wstrb                       (s1_axi_wstrb                       ),
    .s1_axi_wlast                       (s1_axi_wlast                       ),
    .s1_axi_bvalid                      (s1_axi_bvalid                      ),
    .s1_axi_bready                      (s1_axi_bready                      ),
    .s1_axi_bresp                       (s1_axi_bresp                       ),
//--AXI4 Read Bus
    .s1_axi_arvalid                     (s1_axi_arvalid                     ),
    .s1_axi_arready                     (s1_axi_arready                     ),
    .s1_axi_araddr                      (s1_axi_araddr                      ),
    .s1_axi_arlen                       (s1_axi_arlen                       ),
    .s1_axi_rvalid                      (s1_axi_rvalid                      ),
    .s1_axi_rready                      (s1_axi_rready                      ),
    .s1_axi_rdata                       (s1_axi_rdata                       ),
    .s1_axi_rlast                       (s1_axi_rlast                       ),
    .s1_axi_rresp                       (s1_axi_rresp                       ),
//Slave AXI4 Bus 2
//--AXI4 Write Bus
    .s2_axi_awvalid                     (s2_axi_awvalid                     ),
    .s2_axi_awready                     (s2_axi_awready                     ),
    .s2_axi_awaddr                      (s2_axi_awaddr                                   ),
    .s2_axi_awlen                       (s2_axi_awlen                                   ),
    .s2_axi_wvalid                      (s2_axi_wvalid                              ),
    .s2_axi_wready                      (s2_axi_wready                                   ),
    .s2_axi_wdata                       (s2_axi_wdata                                   ),
    .s2_axi_wstrb                       (s2_axi_wstrb                                   ),
    .s2_axi_wlast                       (s2_axi_wlast                                   ),
    .s2_axi_bvalid                      (s2_axi_bvalid                                   ),
    .s2_axi_bready                      (s2_axi_bready                               ),
    .s2_axi_bresp                       (s2_axi_bresp                                   ),
//--AXI4 Read Bus
    .s2_axi_arvalid                     (s2_axi_arvalid                               ),
    .s2_axi_arready                     (s2_axi_arready                                  ),
    .s2_axi_araddr                      (s2_axi_araddr                                   ),
    .s2_axi_arlen                       (s2_axi_arlen                                   ),
    .s2_axi_rvalid                      (s2_axi_rvalid                                   ),
    .s2_axi_rready                      (s2_axi_rready                              ),
    .s2_axi_rdata                       (s2_axi_rdata                                   ),
    .s2_axi_rlast                       (s2_axi_rlast                                   ),
    .s2_axi_rresp                       (s2_axi_rresp                                   ),
//Master AXI4 Bus(Connect to LPDDR4 Controller)
    .clk_200m                           (clk_200m                           ),
    .clk_200m_rstn                      (clk_200m_rstn                      ),
//--AXI4 Bus
    .axi0_ARREADY                       (axi0_ARREADY                       ),
    .axi0_AWREADY                       (axi0_AWREADY                       ),
    .axi0_BID                           (axi0_BID                           ),
    .axi0_BRESP                         (axi0_BRESP                         ),
    .axi0_BVALID                        (axi0_BVALID                        ),
    .axi0_RDATA                         (axi0_RDATA                         ),
    .axi0_RID                           (axi0_RID                           ),
    .axi0_RLAST                         (axi0_RLAST                         ),
    .axi0_RRESP                         (axi0_RRESP                         ),
    .axi0_RVALID                        (axi0_RVALID                        ),
    .axi0_WREADY                        (axi0_WREADY                        ),
    .axi0_ARADDR                        (axi0_ARADDR                        ),
    .axi0_ARAPCMD                       (axi0_ARAPCMD                       ),
    .axi0_ARBURST                       (axi0_ARBURST                       ),
    .axi0_ARID                          (axi0_ARID                          ),
    .axi0_ARLEN                         (axi0_ARLEN                         ),
    .axi0_ARLOCK                        (axi0_ARLOCK                        ),
    .axi0_ARQOS                         (axi0_ARQOS                         ),
    .axi0_ARSIZE                        (axi0_ARSIZE                        ),
    .axi0_ARESETn                       (axi0_ARESETn                       ),
    .axi0_ARVALID                       (axi0_ARVALID                       ),
    .axi0_AWADDR                        (axi0_AWADDR                        ),
    .axi0_AWALLSTRB                     (axi0_AWALLSTRB                     ),
    .axi0_AWAPCMD                       (axi0_AWAPCMD                       ),
    .axi0_AWBURST                       (axi0_AWBURST                       ),
    .axi0_AWCACHE                       (axi0_AWCACHE                       ),
    .axi0_AWPROT                        (axi0_AWPROT                        ),
    .axi0_ARCACHE                       (axi0_ARCACHE                       ),
    .axi0_ARPROT                        (axi0_ARPROT                        ),
    .axi0_AWCOBUF                       (axi0_AWCOBUF                       ),
    .axi0_AWID                          (axi0_AWID                          ),
    .axi0_AWLEN                         (axi0_AWLEN                         ),
    .axi0_AWLOCK                        (axi0_AWLOCK                        ),
    .axi0_AWQOS                         (axi0_AWQOS                         ),
    .axi0_AWSIZE                        (axi0_AWSIZE                        ),
    .axi0_AWVALID                       (axi0_AWVALID                       ),
    .axi0_BREADY                        (axi0_BREADY                        ),
    .axi0_RREADY                        (axi0_RREADY                        ),
    .axi0_WDATA                         (axi0_WDATA                         ),
    .axi0_WLAST                         (axi0_WLAST                         ),
    .axi0_WSTRB                         (axi0_WSTRB                         ),
    .axi0_WVALID                        (axi0_WVALID                        ),
//DDR configuration
    .ddr_inst_CFG_RST                   (ddr_inst_CFG_RST                   ),
    .ddr_inst_CFG_START                 (ddr_inst_CFG_START                 ),
    .ddr_inst_CFG_DONE                  (ddr_inst_CFG_DONE                  ),
    .ddr_inst_CFG_SEL                   (ddr_inst_CFG_SEL                   ),
    .ddr_pll_rstn                       (ddr_pll_rstn                       )
);

/*----------------------- AXI REG ----------------------------*/
axi_reg#
(
    .DATA_WIDTH                         (256                                ),
    // Width of address bus in bits
    .ADDR_WIDTH                         (64                                 )
)
u0_axi_register 
(
    .clk                                (clk_250m                           ),
    .rst                                (~clk_250m_rstn                     ),

    /*
     * AXI slave interface
     */
    .s_axi_awid                         (r_MASTER_AXI_AWID                  ),
    .s_axi_awaddr                       (r_MASTER_AXI_AWADDR                ),
    .s_axi_awlen                        (r_MASTER_AXI_AWLEN                 ),
    .s_axi_awsize                       (r_MASTER_AXI_AWSIZE                ),
    .s_axi_awburst                      (                                   ),
    .s_axi_awlock                       (                                   ),
    .s_axi_awcache                      (                                   ),
    .s_axi_awprot                       (                                   ),
    .s_axi_awqos                        (                                   ),
    .s_axi_awregion                     (                                   ),
    .s_axi_awuser                       (r_MASTER_AXI_AWUSER                ),
    .s_axi_awvalid                      (r_MASTER_AXI_AWVALID               ),
    .s_axi_awready                      (r_MASTER_AXI_AWREADY               ),
    .s_axi_wdata                        (r_MASTER_AXI_WDATA                 ),
    .s_axi_wdata_par                    (r_MASTER_AXI_WDATA_PAR             ),
    .s_axi_wstrb                        (r_MASTER_AXI_WSTRB                 ),
    .s_axi_wstrb_par                    (r_MASTER_AXI_WSTRB_PAR             ),
    .s_axi_wlast                        (r_MASTER_AXI_WLAST                 ),
    .s_axi_wuser                        (                                   ),
    .s_axi_wvalid                       (r_MASTER_AXI_WVALID                ),
    .s_axi_wready                       (r_MASTER_AXI_WREADY                ),
    .s_axi_bid                          (r_MASTER_AXI_BID                   ),
    .s_axi_bid_par                      (r_MASTER_AXI_BID_PAR               ),
    .s_axi_bresp                        (r_MASTER_AXI_BRESP                 ),
    .s_axi_bresp_par                    (r_MASTER_AXI_BRESP_PAR             ),
    .s_axi_buser                        (                                   ),
    .s_axi_bvalid                       (r_MASTER_AXI_BVALID                ),
    .s_axi_bready                       (r_MASTER_AXI_BREADY                ),

    .s_axi_arid                         (r_MASTER_AXI_ARID                  ),
    .s_axi_araddr                       (r_MASTER_AXI_ARADDR                ),
    .s_axi_arlen                        (r_MASTER_AXI_ARLEN                 ),
    .s_axi_arsize                       (r_MASTER_AXI_ARSIZE                ),
    .s_axi_arburst                      (                                   ),
    .s_axi_arlock                       (                                   ),
    .s_axi_arcache                      (                                   ),
    .s_axi_arprot                       (                                   ),
    .s_axi_arqos                        (                                   ),
    .s_axi_arregion                     (                                   ),
    .s_axi_aruser                       (r_MASTER_AXI_ARUSER                ),
    .s_axi_arvalid                      (r_MASTER_AXI_ARVALID               ),
    .s_axi_arready                      (r_MASTER_AXI_ARREADY               ),
    .s_axi_rid                          (r_MASTER_AXI_RID                   ),
    .s_axi_rid_par                      (r_MASTER_AXI_RID_PAR               ),
    .s_axi_rdata                        (r_MASTER_AXI_RDATA                 ),
    .s_axi_rdata_par                    (r_MASTER_AXI_RDATA_PAR             ),
    .s_axi_rresp                        (r_MASTER_AXI_RRESP                 ),
    .s_axi_rresp_par                    (r_MASTER_AXI_RRESP_PAR             ),
    .s_axi_rlast                        (r_MASTER_AXI_RLAST                 ),
    .s_axi_ruser                        (                                   ),
    .s_axi_rvalid                       (r_MASTER_AXI_RVALID                ),
    .s_axi_rready                       (r_MASTER_AXI_RREADY                ),

    /*
     * AXI master interface
     */
    .m_axi_awid                         (q0_MASTER_AXI_AWID                 ),
    .m_axi_awaddr                       (q0_MASTER_AXI_AWADDR               ),
    .m_axi_awlen                        (q0_MASTER_AXI_AWLEN                ),
    .m_axi_awsize                       (q0_MASTER_AXI_AWSIZE               ),
    .m_axi_awburst                      (                                   ),
    .m_axi_awlock                       (                                   ),
    .m_axi_awcache                      (                                   ),
    .m_axi_awprot                       (                                   ),
    .m_axi_awqos                        (                                   ),
    .m_axi_awregion                     (                                   ),
    .m_axi_awuser                       (q0_MASTER_AXI_AWUSER               ),
    .m_axi_awvalid                      (q0_MASTER_AXI_AWVALID              ),
    .m_axi_awready                      (q0_MASTER_AXI_AWREADY              ),
    .m_axi_wdata                        (q0_MASTER_AXI_WDATA                ),
    .m_axi_wdata_par                    (q0_MASTER_AXI_WDATA_PAR            ),
    .m_axi_wstrb                        (q0_MASTER_AXI_WSTRB                ),
    .m_axi_wstrb_par                    (q0_MASTER_AXI_WSTRB_PAR            ),
    .m_axi_wlast                        (q0_MASTER_AXI_WLAST                ),
    .m_axi_wuser                        (                                   ),
    .m_axi_wvalid                       (q0_MASTER_AXI_WVALID               ),
    .m_axi_wready                       (q0_MASTER_AXI_WREADY               ),
    .m_axi_bid                          (q0_MASTER_AXI_BID                  ),
    .m_axi_bid_par                      (q0_MASTER_AXI_BID_PAR              ),
    .m_axi_bresp                        (q0_MASTER_AXI_BRESP                ),
    .m_axi_bresp_par                    (q0_MASTER_AXI_BRESP_PAR            ),
    .m_axi_buser                        (                                   ),
    .m_axi_bvalid                       (q0_MASTER_AXI_BVALID               ),
    .m_axi_bready                       (q0_MASTER_AXI_BREADY               ),

    .m_axi_arid                         (q0_MASTER_AXI_ARID                 ),
    .m_axi_araddr                       (q0_MASTER_AXI_ARADDR               ),
    .m_axi_arlen                        (q0_MASTER_AXI_ARLEN                ),
    .m_axi_arsize                       (q0_MASTER_AXI_ARSIZE               ),
    .m_axi_arburst                      (                                   ),
    .m_axi_arlock                       (                                   ),
    .m_axi_arcache                      (                                   ),
    .m_axi_arprot                       (                                   ),
    .m_axi_arqos                        (                                   ),
    .m_axi_arregion                     (                                   ),
    .m_axi_aruser                       (q0_MASTER_AXI_ARUSER               ),
    .m_axi_arvalid                      (q0_MASTER_AXI_ARVALID              ),
    .m_axi_arready                      (q0_MASTER_AXI_ARREADY              ),
    .m_axi_rid                          (q0_MASTER_AXI_RID                  ),
    .m_axi_rid_par                      (q0_MASTER_AXI_RID_PAR              ),
    .m_axi_rdata                        (q0_MASTER_AXI_RDATA                ),
    .m_axi_rdata_par                    (q0_MASTER_AXI_RDATA_PAR            ),
    .m_axi_rresp                        (q0_MASTER_AXI_RRESP                ),
    .m_axi_rresp_par                    (q0_MASTER_AXI_RRESP_PAR            ),
    .m_axi_rlast                        (q0_MASTER_AXI_RLAST                ),
    .m_axi_ruser                        (                                   ),
    .m_axi_rvalid                       (q0_MASTER_AXI_RVALID               ),
    .m_axi_rready                       (q0_MASTER_AXI_RREADY               )
);

axi_reg#
(
    .DATA_WIDTH                         (256                                ),
    // Width of address bus in bits
    .ADDR_WIDTH                         (64                                 )
)
u1_axi_register 
(
    .clk                                (clk_250m                           ),
    .rst                                (~clk_250m_rstn                     ),

    /*
     * AXI slave interface
     */
    .m_axi_awid                         (r_TARGET_AXI_AWID                  ),
    .m_axi_awaddr                       (r_TARGET_AXI_AWADDR                ),
    .m_axi_awlen                        (r_TARGET_AXI_AWLEN                 ),
    .m_axi_awsize                       (r_TARGET_AXI_AWSIZE                ),
    .m_axi_awburst                      (                                   ),
    .m_axi_awlock                       (                                   ),
    .m_axi_awcache                      (                                   ),
    .m_axi_awprot                       (                                   ),
    .m_axi_awqos                        (                                   ),
    .m_axi_awregion                     (                                   ),
    .m_axi_awuser                       (r_TARGET_AXI_AWUSER                ),
    .m_axi_awvalid                      (r_TARGET_AXI_AWVALID               ),
    .m_axi_awready                      (r_TARGET_AXI_AWREADY               ),
    .m_axi_wdata                        (r_TARGET_AXI_WDATA                 ),
    .m_axi_wdata_par                    (r_TARGET_AXI_WDATA_PAR             ),
    .m_axi_wstrb                        (r_TARGET_AXI_WSTRB                 ),
    .m_axi_wstrb_par                    (r_TARGET_AXI_WSTRB_PAR             ),
    .m_axi_wlast                        (r_TARGET_AXI_WLAST                 ),
    .m_axi_wuser                        (                                   ),
    .m_axi_wvalid                       (r_TARGET_AXI_WVALID                ),
    .m_axi_wready                       (r_TARGET_AXI_WREADY                ),
    .m_axi_bid                          (r_TARGET_AXI_BID                   ),
    .m_axi_bid_par                      (r_TARGET_AXI_BID_PAR               ),
    .m_axi_bresp                        (r_TARGET_AXI_BRESP                 ),
    .m_axi_bresp_par                    (r_TARGET_AXI_BRESP_PAR             ),
    .m_axi_buser                        (                                   ),
    .m_axi_bvalid                       (r_TARGET_AXI_BVALID                ),
    .m_axi_bready                       (r_TARGET_AXI_BREADY                ),

    .m_axi_arid                         (r_TARGET_AXI_ARID                  ),
    .m_axi_araddr                       (r_TARGET_AXI_ARADDR                ),
    .m_axi_arlen                        (r_TARGET_AXI_ARLEN                 ),
    .m_axi_arsize                       (r_TARGET_AXI_ARSIZE                ),
    .m_axi_arburst                      (                                   ),
    .m_axi_arlock                       (                                   ),
    .m_axi_arcache                      (                                   ),
    .m_axi_arprot                       (                                   ),
    .m_axi_arqos                        (                                   ),
    .m_axi_arregion                     (                                   ),
    .m_axi_aruser                       (r_TARGET_AXI_ARUSER                ),
    .m_axi_arvalid                      (r_TARGET_AXI_ARVALID               ),
    .m_axi_arready                      (r_TARGET_AXI_ARREADY               ),
    .m_axi_rid                          (r_TARGET_AXI_RID                   ),
    .m_axi_rid_par                      (r_TARGET_AXI_RID_PAR               ),
    .m_axi_rdata                        (r_TARGET_AXI_RDATA                 ),
    .m_axi_rdata_par                    (r_TARGET_AXI_RDATA_PAR             ),
    .m_axi_rresp                        (r_TARGET_AXI_RRESP                 ),
    .m_axi_rresp_par                    (r_TARGET_AXI_RRESP_PAR             ),
    .m_axi_rlast                        (r_TARGET_AXI_RLAST                 ),
    .m_axi_ruser                        (                                   ),
    .m_axi_rvalid                       (r_TARGET_AXI_RVALID                ),
    .m_axi_rready                       (r_TARGET_AXI_RREADY                ),

    /*
     * AXI master interface
     */
    .s_axi_awid                         (q0_TARGET_AXI_AWID                 ),
    .s_axi_awaddr                       (q0_TARGET_AXI_AWADDR               ),
    .s_axi_awlen                        (q0_TARGET_AXI_AWLEN                ),
    .s_axi_awsize                       (q0_TARGET_AXI_AWSIZE               ),
    .s_axi_awburst                      (                                   ),
    .s_axi_awlock                       (                                   ),
    .s_axi_awcache                      (                                   ),
    .s_axi_awprot                       (                                   ),
    .s_axi_awqos                        (                                   ),
    .s_axi_awregion                     (                                   ),
    .s_axi_awuser                       (q0_TARGET_AXI_AWUSER               ),
    .s_axi_awvalid                      (q0_TARGET_AXI_AWVALID              ),
    .s_axi_awready                      (q0_TARGET_AXI_AWREADY              ),
    .s_axi_wdata                        (q0_TARGET_AXI_WDATA                ),
    .s_axi_wdata_par                    (q0_TARGET_AXI_WDATA_PAR            ),
    .s_axi_wstrb                        (q0_TARGET_AXI_WSTRB                ),
    .s_axi_wstrb_par                    (q0_TARGET_AXI_WSTRB_PAR            ),
    .s_axi_wlast                        (q0_TARGET_AXI_WLAST                ),
    .s_axi_wuser                        (                                   ),
    .s_axi_wvalid                       (q0_TARGET_AXI_WVALID               ),
    .s_axi_wready                       (q0_TARGET_AXI_WREADY               ),
    .s_axi_bid                          (q0_TARGET_AXI_BID                  ),
    .s_axi_bid_par                      (q0_TARGET_AXI_BID_PAR              ),
    .s_axi_bresp                        (q0_TARGET_AXI_BRESP                ),
    .s_axi_bresp_par                    (q0_TARGET_AXI_BRESP_PAR            ),
    .s_axi_buser                        (                                   ),
    .s_axi_bvalid                       (q0_TARGET_AXI_BVALID               ),
    .s_axi_bready                       (q0_TARGET_AXI_BREADY               ),

    .s_axi_arid                         (q0_TARGET_AXI_ARID                 ),
    .s_axi_araddr                       (q0_TARGET_AXI_ARADDR               ),
    .s_axi_arlen                        (q0_TARGET_AXI_ARLEN                ),
    .s_axi_arsize                       (q0_TARGET_AXI_ARSIZE               ),
    .s_axi_arburst                      (                                   ),
    .s_axi_arlock                       (                                   ),
    .s_axi_arcache                      (                                   ),
    .s_axi_arprot                       (                                   ),
    .s_axi_arqos                        (                                   ),
    .s_axi_arregion                     (                                   ),
    .s_axi_aruser                       (q0_TARGET_AXI_ARUSER               ),
    .s_axi_arvalid                      (q0_TARGET_AXI_ARVALID              ),
    .s_axi_arready                      (q0_TARGET_AXI_ARREADY              ),
    .s_axi_rid                          (q0_TARGET_AXI_RID                  ),
    .s_axi_rid_par                      (q0_TARGET_AXI_RID_PAR              ),
    .s_axi_rdata                        (q0_TARGET_AXI_RDATA                ),
    .s_axi_rdata_par                    (q0_TARGET_AXI_RDATA_PAR            ),
    .s_axi_rresp                        (q0_TARGET_AXI_RRESP                ),
    .s_axi_rresp_par                    (q0_TARGET_AXI_RRESP_PAR            ),
    .s_axi_rlast                        (q0_TARGET_AXI_RLAST                ),
    .s_axi_ruser                        (                                   ),
    .s_axi_rvalid                       (q0_TARGET_AXI_RVALID               ),
    .s_axi_rready                       (q0_TARGET_AXI_RREADY               )
);

/*----------------------- PCIe Region ----------------------------*/
edma u_pcie
(
//Globle Signals
    .in_user                            (in_user                            ),
//    .phy_rstn                           (phy_rstn                           ),
    .clk_100m                           (clk_100m                           ),
    .clk_100m_rstn                      (clk_100m_rstn                      ),
    .clk_200m                           (clk_200m                           ),
    .clk_200m_rstn                      (clk_200m_rstn                      ),
    .clk_250m                           (clk_250m                           ),
    .clk_250m_rstn                      (clk_250m_rstn                      ),
//PCIe Interface
    .q0_USER_PHY_RESET_N                (q0_USER_PHY_RESET_N                ),
    .q0_USER_RESET_N_IN                 (q0_USER_RESET_N_IN                 ),
    .q0_RESET_ACK                       (q0_RESET_ACK                       ),
    .q0_RESET_REQ                       (q0_RESET_REQ                       ),
    .q0_USER_AXI_RESET_N                (q0_USER_AXI_RESET_N                ),
    .perst0                             (perst0                           ),    
//--Slave AXI4 Interface   
//----Slave AXI4 Write Interface
    .q0_TARGET_AXI_AWADDR               (r_TARGET_AXI_AWADDR                ),
    .q0_TARGET_AXI_AWID                 (r_TARGET_AXI_AWID                  ),
    .q0_TARGET_AXI_AWLEN                (r_TARGET_AXI_AWLEN                 ),
    .q0_TARGET_AXI_AWSIZE               (r_TARGET_AXI_AWSIZE                ),
    .q0_TARGET_AXI_AWVALID              (r_TARGET_AXI_AWVALID               ),
    .q0_TARGET_AXI_AWUSER               (r_TARGET_AXI_AWUSER                ),
    .q0_TARGET_AXI_AWREADY              (r_TARGET_AXI_AWREADY               ),
    .q0_TARGET_AXI_WDATA                (r_TARGET_AXI_WDATA                 ),
    .q0_TARGET_AXI_WDATA_PAR            (r_TARGET_AXI_WDATA_PAR             ),
    .q0_TARGET_AXI_WLAST                (r_TARGET_AXI_WLAST                 ),
    .q0_TARGET_AXI_WSTRB                (r_TARGET_AXI_WSTRB                 ),
    .q0_TARGET_AXI_WSTRB_PAR            (r_TARGET_AXI_WSTRB_PAR             ),
    .q0_TARGET_AXI_WVALID               (r_TARGET_AXI_WVALID                ),
    .q0_TARGET_AXI_WREADY               (r_TARGET_AXI_WREADY                ),
    .q0_TARGET_AXI_BID                  (r_TARGET_AXI_BID                   ),
    .q0_TARGET_AXI_BID_PAR              (r_TARGET_AXI_BID_PAR               ),
    .q0_TARGET_AXI_BRESP                (r_TARGET_AXI_BRESP                 ),
    .q0_TARGET_AXI_BRESP_PAR            (r_TARGET_AXI_BRESP_PAR             ),
    .q0_TARGET_AXI_BVALID               (r_TARGET_AXI_BVALID                ),
    .q0_TARGET_AXI_BREADY               (r_TARGET_AXI_BREADY                ),
//----Slave AXI4 Read Interface
    .q0_TARGET_AXI_ARADDR               (r_TARGET_AXI_ARADDR                ),
    .q0_TARGET_AXI_ARID                 (r_TARGET_AXI_ARID                  ),
    .q0_TARGET_AXI_ARLEN                (r_TARGET_AXI_ARLEN                 ),
    .q0_TARGET_AXI_ARSIZE               (r_TARGET_AXI_ARSIZE                ),
    .q0_TARGET_AXI_ARVALID              (r_TARGET_AXI_ARVALID               ),
    .q0_TARGET_AXI_ARUSER               (r_TARGET_AXI_ARUSER                ),
    .q0_TARGET_AXI_ARREADY              (r_TARGET_AXI_ARREADY               ),
    .q0_TARGET_AXI_RDATA                (r_TARGET_AXI_RDATA                 ),
    .q0_TARGET_AXI_RDATA_PAR            (r_TARGET_AXI_RDATA_PAR             ),
    .q0_TARGET_AXI_RID                  (r_TARGET_AXI_RID                   ),
    .q0_TARGET_AXI_RID_PAR              (r_TARGET_AXI_RID_PAR               ),
    .q0_TARGET_AXI_RLAST                (r_TARGET_AXI_RLAST                 ),
    .q0_TARGET_AXI_RRESP                (r_TARGET_AXI_RRESP                 ),
    .q0_TARGET_AXI_RRESP_PAR            (r_TARGET_AXI_RRESP_PAR             ),
    .q0_TARGET_AXI_RVALID               (r_TARGET_AXI_RVALID                ),
    .q0_TARGET_AXI_RREADY               (r_TARGET_AXI_RREADY                ),
//----Slave AXI4 Sideband Interface 
    .q0_TARGET_NON_POSTED_REJ           (q0_TARGET_NON_POSTED_REJ           ),
//--Master AXI4 Interface       
//----Master AXI4 Write Interface   
    .q0_MASTER_AXI_AWADDR               (r_MASTER_AXI_AWADDR                ),
    .q0_MASTER_AXI_AWID                 (r_MASTER_AXI_AWID                  ),
    .q0_MASTER_AXI_AWLEN                (r_MASTER_AXI_AWLEN                 ),
    .q0_MASTER_AXI_AWSIZE               (r_MASTER_AXI_AWSIZE                ),
    .q0_MASTER_AXI_AWVALID              (r_MASTER_AXI_AWVALID               ),
    .q0_MASTER_AXI_AWUSER               (r_MASTER_AXI_AWUSER                ),
    .q0_MASTER_AXI_AWREADY              (r_MASTER_AXI_AWREADY               ),
    .q0_MASTER_AXI_WDATA                (r_MASTER_AXI_WDATA                 ),
    .q0_MASTER_AXI_WDATA_PAR            (r_MASTER_AXI_WDATA_PAR             ),
    .q0_MASTER_AXI_WLAST                (r_MASTER_AXI_WLAST                 ),
    .q0_MASTER_AXI_WSTRB                (r_MASTER_AXI_WSTRB                 ),
    .q0_MASTER_AXI_WSTRB_PAR            (r_MASTER_AXI_WSTRB_PAR             ),
    .q0_MASTER_AXI_WVALID               (r_MASTER_AXI_WVALID                ),
    .q0_MASTER_AXI_WREADY               (r_MASTER_AXI_WREADY                ),
    .q0_MASTER_AXI_BID                  (r_MASTER_AXI_BID                   ),
    .q0_MASTER_AXI_BID_PAR              (r_MASTER_AXI_BID_PAR               ),
    .q0_MASTER_AXI_BRESP                (r_MASTER_AXI_BRESP                 ),
    .q0_MASTER_AXI_BRESP_PAR            (r_MASTER_AXI_BRESP_PAR             ),
    .q0_MASTER_AXI_BVALID               (r_MASTER_AXI_BVALID                ),
    .q0_MASTER_AXI_BREADY               (r_MASTER_AXI_BREADY                ),
//----Master AXI4 Read Interface
    .q0_MASTER_AXI_ARADDR               (r_MASTER_AXI_ARADDR                ),
    .q0_MASTER_AXI_ARID                 (r_MASTER_AXI_ARID                  ),
    .q0_MASTER_AXI_ARLEN                (r_MASTER_AXI_ARLEN                 ),
    .q0_MASTER_AXI_ARSIZE               (r_MASTER_AXI_ARSIZE                ),
    .q0_MASTER_AXI_ARVALID              (r_MASTER_AXI_ARVALID               ),
    .q0_MASTER_AXI_ARUSER               (r_MASTER_AXI_ARUSER                ),
    .q0_MASTER_AXI_ARREADY              (r_MASTER_AXI_ARREADY               ),
    .q0_MASTER_AXI_RDATA                (r_MASTER_AXI_RDATA                 ),
    .q0_MASTER_AXI_RDATA_PAR            (r_MASTER_AXI_RDATA_PAR             ),
    .q0_MASTER_AXI_RID                  (r_MASTER_AXI_RID                   ),
    .q0_MASTER_AXI_RID_PAR              (r_MASTER_AXI_RID_PAR               ),
    .q0_MASTER_AXI_RLAST                (r_MASTER_AXI_RLAST                 ),
    .q0_MASTER_AXI_RRESP                (r_MASTER_AXI_RRESP                 ),
    .q0_MASTER_AXI_RRESP_PAR            (r_MASTER_AXI_RRESP_PAR             ),
    .q0_MASTER_AXI_RVALID               (r_MASTER_AXI_RVALID                ),
    .q0_MASTER_AXI_RREADY               (r_MASTER_AXI_RREADY                ),
//--Master APB3 Interface   
    .q0_USER_APB_PADDR                  (q0_USER_APB_PADDR                  ),
    .q0_USER_APB_PSEL                   (q0_USER_APB_PSEL                   ),
    .q0_USER_APB_PENABLE                (q0_USER_APB_PENABLE                ),
    .q0_USER_APB_PWRITE                 (q0_USER_APB_PWRITE                 ),
    .q0_USER_APB_PWDATA                 (q0_USER_APB_PWDATA                 ),
    .q0_USER_APB_PWDATA_PAR             (q0_USER_APB_PWDATA_PAR             ),
    .q0_USER_APB_PSTRB                  (q0_USER_APB_PSTRB                  ),
    .q0_USER_APB_PSTRB_PAR              (q0_USER_APB_PSTRB_PAR              ),
    .q0_USER_APB_PRDATA                 (q0_USER_APB_PRDATA                 ),
    .q0_USER_APB_PRDATA_PAR             (q0_USER_APB_PRDATA_PAR             ),
    .q0_USER_APB_PREADY                 (q0_USER_APB_PREADY                 ),
    .q0_USER_APB_PSLVERR                (q0_USER_APB_PSLVERR                ),
//--FLR 
    .q0_FLR_IN_PROGRESS                 (q0_FLR_IN_PROGRESS                 ),
    .q0_FLR_DONE                        (q0_FLR_DONE                        ),
//--Interrupt Pin   
    .q0_LOCAL_INTERRUPT                 (q0_LOCAL_INTERRUPT                 ),
    .q0_INTERRUPT_SIDEBAND_SIGNALS      (q0_INTERRUPT_SIDEBAND_SIGNALS      ),
//--Legacy Interrupt Pin
    .q0_INTA_IN                         (q0_INTA_IN                         ),
    .q0_INTB_IN                         (q0_INTB_IN                         ),
    .q0_INTC_IN                         (q0_INTC_IN                         ),
    .q0_INTD_IN                         (q0_INTD_IN                         ),
    .q0_INT_PENDING_STATUS              (q0_INT_PENDING_STATUS              ),
    .q0_INT_ACK                         (q0_INT_ACK                         ),
//--Message Pin
    .q0_MSG                             (q0_MSG                             ),
    .q0_MSG_BYTE_EN                     (q0_MSG_BYTE_EN                     ),
    .q0_MSG_DATA                        (q0_MSG_DATA                        ),
    .q0_MSG_END                         (q0_MSG_END                         ),
    .q0_MSG_PASID                       (q0_MSG_PASID                       ),
    .q0_MSG_PASID_PRESENT               (q0_MSG_PASID_PRESENT               ),
    .q0_MSG_START                       (q0_MSG_START                       ),
    .q0_MSG_VALID                       (q0_MSG_VALID                       ),
    .q0_MSG_VDH                         (q0_MSG_VDH                         ),
//--Error Pin
    .q0_CORRECTABLE_ERROR_IN            (q0_CORRECTABLE_ERROR_IN            ),
    .q0_UNCORRECTABLE_ERROR_IN          (q0_UNCORRECTABLE_ERROR_IN          ),
    .q0_FATAL_ERROR_OUT                 (q0_FATAL_ERROR_OUT                 ),
    .q0_NON_FATAL_ERROR_OUT             (q0_NON_FATAL_ERROR_OUT             ),
    .q0_CORRECTABLE_ERROR_OUT           (q0_CORRECTABLE_ERROR_OUT           ),
//--Status Pin
    .q0_LTSSM_STATE                     (q0_LTSSM_STATE                     ),
    .q0_REG_ACCESS_CLK_SHUTOFF          (q0_REG_ACCESS_CLK_SHUTOFF          ),
    .q0_CORE_CLK_SHUTOFF                (q0_CORE_CLK_SHUTOFF                ),
    .q0_LINK_STATUS                     (q0_LINK_STATUS                     ),
    .q0_FUNCTION_STATUS                 (q0_FUNCTION_STATUS                 ),
    .q0_PCIE_MAX_READ_REQ_SIZE          (q0_PCIE_MAX_READ_REQ_SIZE          ),
    .q0_PCIE_MAX_PAYLOAD_SIZE           (q0_PCIE_MAX_PAYLOAD_SIZE           ),
    .q0_PIPE_P00_RATE                   (q0_PIPE_P00_RATE                   ),
    .q0_PMA_CMN_READY                   (q0_PMA_CMN_READY                   ),
//--Configuration Snoop Pin
    .q0_CONFIG_READ_DATA                (q0_CONFIG_READ_DATA                ),
    .q0_CONFIG_READ_DATA_PAR            (q0_CONFIG_READ_DATA_PAR            ),
    .q0_CONFIG_READ_DATA_VALID          (q0_CONFIG_READ_DATA_VALID          ),
    .q0_CONFIG_READ_RECEIVED            (q0_CONFIG_READ_RECEIVED            ),
    .q0_CONFIG_REG_NUM                  (q0_CONFIG_REG_NUM                  ),
    .q0_CONFIG_WRITE_BYTE_ENABLE        (q0_CONFIG_WRITE_BYTE_ENABLE        ),
    .q0_CONFIG_WRITE_BYTE_ENABLE_PAR    (q0_CONFIG_WRITE_BYTE_ENABLE_PAR    ),
    .q0_CONFIG_WRITE_DATA               (q0_CONFIG_WRITE_DATA               ),
    .q0_CONFIG_WRITE_DATA_PAR           (q0_CONFIG_WRITE_DATA_PAR           ),
    .q0_CONFIG_WRITE_RECEIVED           (q0_CONFIG_WRITE_RECEIVED           ),
    .q0_CONFIG_FUNCTION_NUM             (q0_CONFIG_FUNCTION_NUM             ),
    .q0_DEBUG_DATA_OUT                  (q0_DEBUG_DATA_OUT                  ),
    .q0_FPGA_DIV2_CLK                   (q0_FPGA_DIV2_CLK                   ),
    .q0_FPGA_DIV2_CLK_io                (q0_FPGA_DIV2_CLK_io                ),
//EDMA Interface
//--Master AXI4 Interface 
//----Master AXI4 Write Interface
    .m_c_axi_awaddr                     (s0_axi_awaddr                      ),
    .m_c_axi_awid                       (s0_axi_awid                        ),
    .m_c_axi_awlen                      (s0_axi_awlen                       ),
    .m_c_axi_awsize                     (s0_axi_awsize                      ),
    .m_c_axi_awburst                    (s0_axi_awburst                     ),
    .m_c_axi_awprot                     (s0_axi_awprot                      ),
    .m_c_axi_awvalid                    (s0_axi_awvalid                     ),
    .m_c_axi_awready                    (s0_axi_awready                     ),
    .m_c_axi_awlock                     (s0_axi_awlock                      ),
    .m_c_axi_awcache                    (s0_axi_awcache                     ),
    .m_c_axi_wdata                      (s0_axi_wdata                       ),
    .m_c_axi_wstrb                      (s0_axi_wstrb                       ),
    .m_c_axi_wlast                      (s0_axi_wlast                       ),
    .m_c_axi_wvalid                     (s0_axi_wvalid                      ),
    .m_c_axi_wready                     (s0_axi_wready                      ),
    .m_c_axi_bresp                      (s0_axi_bresp                       ),
    .m_c_axi_bid                        (s0_axi_bid                         ),
    .m_c_axi_bvalid                     (s0_axi_bvalid                      ),
    .m_c_axi_bready                     (s0_axi_bready                      ),
//----Master AXI4 Read Interface
    .m_c_axi_arready                    (s0_axi_arready                     ),
    .m_c_axi_arid                       (s0_axi_arid                        ),
    .m_c_axi_araddr                     (s0_axi_araddr                      ),
    .m_c_axi_arlen                      (s0_axi_arlen                       ),
    .m_c_axi_arsize                     (s0_axi_arsize                      ),
    .m_c_axi_arburst                    (s0_axi_arburst                     ),
    .m_c_axi_arprot                     (s0_axi_arprot                      ),
    .m_c_axi_arvalid                    (s0_axi_arvalid                     ),
    .m_c_axi_arlock                     (s0_axi_arlock                      ),
    .m_c_axi_arcache                    (s0_axi_arcache                     ),
    .m_c_axi_rid                        (s0_axi_rid                         ),
    .m_c_axi_rdata                      (s0_axi_rdata                       ),
    .m_c_axi_rresp                      (s0_axi_rresp                       ),
    .m_c_axi_rlast                      (s0_axi_rlast                       ),
    .m_c_axi_rvalid                     (s0_axi_rvalid                      ),
    .m_c_axi_rready                     (s0_axi_rready                      ),
//Packet Interface
//--Master AXI4 Read Interface 
    .m_axi_arready                      (s1_axi_arready                     ),
    .m_axi_araddr                       (s1_axi_araddr                      ),
    .m_axi_arlen                        (s1_axi_arlen                       ),
    .m_axi_arvalid                      (s1_axi_arvalid                     ),
    .m_axi_rvalid                       (s1_axi_rvalid                      ),
    .m_axi_rdata                        (s1_axi_rdata                       ),
    .m_axi_rlast                        (s1_axi_rlast                       ),
    .m_axi_rready                       (s1_axi_rready                      ),

    .m_axi_awid                         (s1_axi_awid                        ),
    .m_axi_awvalid                      (s1_axi_awvalid                     ),
    .m_axi_awaddr                       (s1_axi_awaddr                      ),
    .m_axi_awregion                     (                                   ),
    .m_axi_awlen                        (s1_axi_awlen                       ),
    .m_axi_awsize                       (s1_axi_awsize                      ),
    .m_axi_awburst                      (s1_axi_awburst                     ),
    .m_axi_awprot                       (s1_axi_awprot                      ),
    .m_axi_awlock                       (s1_axi_awlock                      ),
    .m_axi_awcache                      (s1_axi_awcache                     ),
    .m_axi_awready                      (s1_axi_awready                     ),
    .m_axi_wvalid                       (s1_axi_wvalid                      ),
    .m_axi_wdata                        (s1_axi_wdata                       ),
    .m_axi_wstrb                        (s1_axi_wstrb                       ),
    .m_axi_wlast                        (s1_axi_wlast                       ),
    .m_axi_wready                       (s1_axi_wready                      ),
    .m_axi_bid                          (s1_axi_bid                         ),
    .m_axi_bresp                        (s1_axi_bresp                       ),
    .m_axi_bvalid                       (s1_axi_bvalid                      ),
    .m_axi_bready                       (s1_axi_bready                      ),

//--Master AXI4 Write
    .m1_axi_awid                        (m1_axi_awid                        ),
    .m1_axi_awvalid                     (m1_axi_awvalid                     ),
    .m1_axi_awaddr                      (m1_axi_awaddr                      ),
    .m1_axi_awlen                       (m1_axi_awlen                       ),
    .m1_axi_awsize                      (m1_axi_awsize                      ),
    .m1_axi_awready                     (m1_axi_awready                     ),
    .m1_axi_wvalid                      (m1_axi_wvalid                      ),
    .m1_axi_wdata                       (m1_axi_wdata                       ),
    .m1_axi_wstrb                       (m1_axi_wstrb                       ),
    .m1_axi_wlast                       (m1_axi_wlast                       ),
    .m1_axi_wready                      (m1_axi_wready                      ),
    .m1_axi_bid                         (m1_axi_bid                         ),
    .m1_axi_bresp                       (m1_axi_bresp                       ),
    .m1_axi_bvalid                      (m1_axi_bvalid                      ),
    .m1_axi_bready                      (m1_axi_bready                      ),
//--Master AXI4 Read
    .m1_axi_arid                        (m1_axi_arid                        ),
    .m1_axi_arvalid                     (m1_axi_arvalid                     ),
    .m1_axi_araddr                      (m1_axi_araddr                      ),
    .m1_axi_arlen                       (m1_axi_arlen                       ),
    .m1_axi_arsize                      (m1_axi_arsize                      ),
    .m1_axi_arready                     (m1_axi_arready                     ),
    .m1_axi_rid                         (m1_axi_rid                         ),
    .m1_axi_rvalid                      (m1_axi_rvalid                      ),
    .m1_axi_rdata                       (m1_axi_rdata                       ),
    .m1_axi_rlast                       (m1_axi_rlast                       ),
    .m1_axi_rresp                       (m1_axi_rresp                       ),
    .m1_axi_rready                      (m1_axi_rready                      ),    
//--Master AXI-Stream Interface(Connect to XGMAC Wrapper)
    .rx_src_axis_tready                 (rx_src_axis_tready                 ),
    .rx_src_axis_tdata                  (rx_src_axis_tdata                  ),
    .rx_src_axis_tvalid                 (rx_src_axis_tvalid                 ),
    .rx_src_axis_tlast                  (rx_src_axis_tlast                  ),

    .tx_src_axis_tready                 (tx_src_axis_tready                 ),
    .tx_src_axis_tdata                  (tx_src_axis_tdata                  ),
    .tx_src_axis_tvalid                 (tx_src_axis_tvalid                 ),
    .tx_src_axis_tlast                  (tx_src_axis_tlast                  ),


//APB3 interface 
    .Board_status(Board_status),
    .master_Control_Input_A(master_Control_Input_A),
    .master_Control_Status_A(master_Control_Status_A),
    .master_Control_Input_B(master_Control_Input_B),
    .master_Control_Status_B(master_Control_Status_B),
    .master_Control_Input_C(master_Control_Input_C),
    .master_Control_Status_C(master_Control_Status_C),
 
 
//Master APB3 Interface(Connect to XGMAC Wrapper)
    .mac_l2_apb3_paddr                  (mac_l2_apb3_paddr                  ),
    .mac_l2_apb3_psel                   (mac_l2_apb3_psel                   ),
    .mac_l2_apb3_penable                (mac_l2_apb3_penable                ),
    .mac_l2_apb3_pready                 (mac_l2_apb3_pready                 ),
    .mac_l2_apb3_pwrite                 (mac_l2_apb3_pwrite                 ),
    .mac_l2_apb3_pwdata                 (mac_l2_apb3_pwdata                 ),
    .mac_l2_apb3_prdata                 (mac_l2_apb3_prdata                 ),
    .mac_l2_apb3_pslverror              (mac_l2_apb3_pslverror              ),
//Test VIO Interface
    .rstn_vio                           (rstn_vio                           ),
    .q0_apb_start                       ((q0_apb_start || perst0 )          ),
    .q0_paddr_test                      (q0_paddr_test                      ),
    .q0_pwdata_vio                      (q0_pwdata_vio                      ),
    .q0_pwdata_par_vio                  (q0_pwdata_par_vio                  ),
    .q0_write_vio                       (q0_write_vio                       ),
    .q0_obs_pstates                     (q0_obs_pstates                     ),
    .q0_prdata_test                     (q0_prdata_test                     ),
    .q0_apb_done                        (q0_apb_done                        )
);



///*----------------------- XGETH Region ----------------------------*/
//eth_platform#(
//    .AXIS_DW                            (64                                 )
//)
//u_xgeth
//(
//    .clk_100m                           (clk_100m                           ),
//    .clk100m_rstn                       (clk_100m_rstn                      ),
//    .clk_250m                           (clk_250m                           ),
//    .clk250m_rstn                       (clk_250m_rstn                      ),
//    .clk156m_rstn                       (clk_156m_rstn                      ),
//
////XGMAC PHY XGMII Interface
////--Debug Signals
//    .Q1_PMA_CMN_READY                   (Q1_PMA_CMN_READY                   ),
////--Q1 APB3 interface
//    .Q1_USER_APB_PRDATA                 (Q1_USER_APB_PRDATA                 ),
//    .Q1_USER_APB_PREADY                 (Q1_USER_APB_PREADY                 ),
//    .Q1_USER_APB_PADDR                  (Q1_USER_APB_PADDR                  ),
//    .Q1_USER_APB_PWDATA                 (Q1_USER_APB_PWDATA                 ),
//    .Q1_USER_APB_PWRITE                 (Q1_USER_APB_PWRITE                 ),
//    .Q1_USER_APB_PSEL                   (Q1_USER_APB_PSEL                   ),
//    .Q1_USER_APB_PENABLE                (Q1_USER_APB_PENABLE                ),
////--Q1 clk rerset interface
//    .Q1_L2_10gbe_clk                    (Q1_L2_10gbe_clk                    ),
//    .Q1_L2_PCS_RST_N_RX                 (Q1_L2_PCS_RST_N_RX                 ),
//    .Q1_L2_PCS_RST_N_TX                 (Q1_L2_PCS_RST_N_TX                 ),
//    .Q1_L2_PHY_RESET_N                  (Q1_L2_PHY_RESET_N                  ),
////--Q1 control interface
//    .Q1_L2_ETH_EEE_ALERT_EN             (Q1_L2_ETH_EEE_ALERT_EN             ),
//    .Q1_L2_PMA_TX_ELEC_IDLE             (Q1_L2_PMA_TX_ELEC_IDLE             ),
////--Q1 power up interface
//    .Q1_L2_PMA_XCVR_POWER_STATE_ACK     (Q1_L2_PMA_XCVR_POWER_STATE_ACK     ),
//    .Q1_L2_PMA_XCVR_PLLCLK_EN_ACK       (Q1_L2_PMA_XCVR_PLLCLK_EN_ACK       ),
//    .Q1_L2_PMA_RX_SIGNAL_DETECT         (Q1_L2_PMA_RX_SIGNAL_DETECT         ),
//    .Q1_L2_PMA_XCVR_POWER_STATE_REQ     (Q1_L2_PMA_XCVR_POWER_STATE_REQ     ),
//    .Q1_L2_PMA_XCVR_PLLCLK_EN           (Q1_L2_PMA_XCVR_PLLCLK_EN           ),
////--Q1 xgmii interface
//    .Q1_L2_RXC                          (Q1_L2_RXC                          ),
//    .Q1_L2_RXD                          (Q1_L2_RXD                          ),
//    .Q1_L2_TXD                          (Q1_L2_TXD                          ),
//    .Q1_L2_TXC                          (Q1_L2_TXC                          ),
////Slave AXI-Stream Interface(Connect to PCIe Wrapper)
//    .l2_tx_axis_mac_tdata               (axis_tdata [0*64 +: 1*64]          ),
//    .l2_tx_axis_mac_tvalid              (axis_tvalid[0*1  +: 1*1 ]          ),
//    .l2_tx_axis_mac_tlast               (axis_tlast [0*1  +: 1*1 ]          ),
//    .l2_tx_axis_mac_tkeep               (8'hff                              ),
//    .l2_tx_axis_mac_tuser               (1'b0                               ),
//    .l2_tx_axis_mac_tready              (axis_tready[0*1  +: 1*1 ]          ),
////Master AXI-Stream Interface(Connect to PCIe Wrapper)
//    .l2_rx_axis_mac_tdata               (axis_tdata [1*64 +: 1*64]          ),
//    .l2_rx_axis_mac_tvalid              (axis_tvalid[1*1  +: 1*1 ]          ),
//    .l2_rx_axis_mac_tlast               (axis_tlast [1*1  +: 1*1 ]          ),
//    .l2_rx_axis_mac_tkeep               (l2_rx_axis_mac_tkeep               ),
//    .l2_rx_axis_mac_tuser               (/*Not Used*/                       ),
//    .l2_rx_axis_mac_tready              (axis_tready[1*1  +: 1*1 ]          ),
////Slave APB3 Interface(Connect to PCIe Wrapper)
//    .mac_l2_apb3_paddr                  (apb3_paddr    [0*10 +: 1*10]       ),
//    .mac_l2_apb3_psel                   (apb3_psel     [0*1  +: 1*1 ]       ),
//    .mac_l2_apb3_penable                (apb3_penable  [0*1  +: 1*1 ]       ),
//    .mac_l2_apb3_pready                 (apb3_pready   [0*1  +: 1*1 ]       ),
//    .mac_l2_apb3_pwrite                 (apb3_pwrite   [0*1  +: 1*1 ]       ),
//    .mac_l2_apb3_pwdata                 (apb3_pwdata   [0*32 +: 1*32]       ),
//    .mac_l2_apb3_prdata                 (apb3_prdata   [0*32 +: 1*32]       ),
//    .mac_l2_apb3_pslverror              (apb3_pslverror[0*1  +: 1*1 ]       ),
////Optical Module Interface
//    .SFP_TXDISABLE                      (SFP_TXDISABLE                      )
//
//);
//wire                                  ddr_err;
//wire                                  ddr_rd_err;
//
//wire  [63:0]                          data_rev; 
//wire  [15:0]                          data_err_temp; 

data_check #(
    .DATA_WIDTH                         (64                                 )
)
u1_data_check(
    .clk                                (clk_250m                           ),
    .rst_n                              (clk_250m_rstn                      ),
    .data_last                          (s1_axi_wlast                       ),
    .data_en                            (s1_axi_wvalid & s1_axi_wready      ),
    .data                               (s1_axi_wdata                       ),
    .data_rev                           (debug_data_rev                           ),
    .data_err_temp                      (debug_data_err_temp                      ),
    .data_err                           (debug_ddr_err                            )
);
data_check #(
    .DATA_WIDTH                         (256                                ) 
)
u2_data_check(
    .clk                                (clk_250m                           ),
    .rst_n                              (clk_250m_rstn                      ),
    .data_last                          (s0_axi_wlast                       ),
    .data_en                            (s0_axi_wvalid & s0_axi_wready      ),
    .data                               (s0_axi_wdata                       ),
    .data_err                           (debug_ddr_rd_err                         )
);

assign debug_s0_axi_awvalid   = s0_axi_awvalid   ;
assign debug_s0_axi_awready   = s0_axi_awready   ;
assign debug_s0_axi_awaddr    = s0_axi_awaddr    ;
assign debug_s0_axi_awlen     = s0_axi_awlen     ;
assign debug_s0_axi_wvalid    = s0_axi_wvalid    ;
assign debug_s0_axi_wready    = s0_axi_wready    ;
assign debug_s0_axi_wdata     = s0_axi_wdata     ;
assign debug_s0_axi_wstrb     = s0_axi_wstrb     ;
assign debug_s0_axi_wlast     = s0_axi_wlast     ;
assign debug_s0_axi_bvalid    = s0_axi_bvalid    ;
assign debug_s0_axi_bready    = s0_axi_bready    ;
assign debug_s0_axi_bresp     = s0_axi_bresp     ;
assign debug_s0_axi_arvalid   = s0_axi_arvalid   ;
assign debug_s0_axi_arready   = s0_axi_arready   ;
assign debug_s0_axi_araddr    = s0_axi_araddr    ;
assign debug_s0_axi_arlen     = s0_axi_arlen     ;
assign debug_s0_axi_rvalid    = s0_axi_rvalid    ;
assign debug_s0_axi_rready    = s0_axi_rready    ;
assign debug_s0_axi_rdata     = s0_axi_rdata     ;
assign debug_s0_axi_rlast     = s0_axi_rlast     ;
assign debug_s0_axi_rresp     = s0_axi_rresp     ;

assign debug_s1_axi_awvalid   = s1_axi_awvalid   ;
assign debug_s1_axi_awready   = s1_axi_awready   ;
assign debug_s1_axi_awaddr    = s1_axi_awaddr    ;
assign debug_s1_axi_awlen     = s1_axi_awlen     ;
assign debug_s1_axi_wvalid    = s1_axi_wvalid    ;
assign debug_s1_axi_wready    = s1_axi_wready    ;
assign debug_s1_axi_wdata     = s1_axi_wdata     ;
assign debug_s1_axi_wstrb     = s1_axi_wstrb     ;
assign debug_s1_axi_wlast     = s1_axi_wlast     ;
assign debug_s1_axi_bvalid    = s1_axi_bvalid    ;
assign debug_s1_axi_bready    = s1_axi_bready    ;
assign debug_s1_axi_bresp     = s1_axi_bresp     ;
assign debug_s1_axi_arvalid   = s1_axi_arvalid   ;
assign debug_s1_axi_arready   = s1_axi_arready   ;
assign debug_s1_axi_araddr    = s1_axi_araddr    ;
assign debug_s1_axi_arlen     = s1_axi_arlen     ;
assign debug_s1_axi_rvalid    = s1_axi_rvalid    ;
assign debug_s1_axi_rready    = s1_axi_rready    ;
assign debug_s1_axi_rdata     = s1_axi_rdata     ;
assign debug_s1_axi_rlast     = s1_axi_rlast     ;
assign debug_s1_axi_rresp     = s1_axi_rresp     ;
assign debug_l2_rx_axis_mac_tkeep = l2_rx_axis_mac_tkeep;



////-------------------------------------------------------------------------------------------------------------------
//// Debug VIO                                                                                                               
////-------------------------------------------------------------------------------------------------------------------  
//edb_top edb_top_inst 
//(
//    .bscan_CAPTURE                      (jtag_inst1_CAPTURE                 ),
//    .bscan_DRCK                         (jtag_inst1_DRCK                    ),
//    .bscan_RESET                        (jtag_inst1_RESET                   ),
//    .bscan_RUNTEST                      (jtag_inst1_RUNTEST                 ),
//    .bscan_SEL                          (jtag_inst1_SEL                     ),
//    .bscan_SHIFT                        (jtag_inst1_SHIFT                   ),
//    .bscan_TCK                          (jtag_inst1_TCK                     ),
//    .bscan_TDI                          (jtag_inst1_TDI                     ),
//    .bscan_TMS                          (jtag_inst1_TMS                     ),
//    .bscan_UPDATE                       (jtag_inst1_UPDATE                  ),
//    .bscan_TDO                          (jtag_inst1_TDO                     ),
//                                                           
//    .vio0_clk                           ( clk_100m                          ),
//    // Probe                                                        
//    .vio0_q0_ltssm_state                ( q0_LTSSM_STATE                    ),
//    .vio0_q0_link_status                ( q0_LINK_STATUS                    ),
//    .vio0_q0_pipe_p00_rate              ( q0_PIPE_P00_RATE                  ),
//    .vio0_q0_cmn_ready                  ( q0_PMA_CMN_READY                  ),
//    .vio0_q0_debug_data_out             ( q0_DEBUG_DATA_OUT                 ),
//    .vio0_q0_flr_in_progress            ( q0_FLR_IN_PROGRESS                ),
//    .vio0_in_user                       ( in_user                           ),
//    .vio0_Q1_PMA_CMN_READY              ( Q1_PMA_CMN_READY                  ),
//    .vio0_Q1_L2_PMA_XCVR_PLLCLK_EN_ACK  ( Q1_L2_PMA_XCVR_PLLCLK_EN_ACK      ),
//    .vio0_Q1_L2_PMA_XCVR_POWER_STATE_ACK( Q1_L2_PMA_XCVR_POWER_STATE_ACK    ),
//    .vio0_Q1_L2_PMA_XCVR_PLLCLK_EN      ( Q1_L2_PMA_XCVR_PLLCLK_EN          ),
//    .vio0_Q1_L2_PMA_XCVR_POWER_STATE_REQ( Q1_L2_PMA_XCVR_POWER_STATE_REQ    ),
//    // Probe                                               
//    .vio0_q0_obs_pstates                ( q0_obs_pstates                    ),
//    .vio0_q0_apb_done                   ( q0_apb_done                       ),
//    .vio0_q0_prdata_test                ( q0_prdata_test                    ),
//    // Source                                                               
//    .vio0_q0_paddr_test                 ( q0_paddr_test                     ),
//    .vio0_q0_pwdata_vio                 ( q0_pwdata_vio                     ),
//    .vio0_q0_pwdata_par_vio             ( q0_pwdata_par_vio                 ),
//    .vio0_q0_write_vio                  ( q0_write_vio                      ),
//    .vio0_q0_apb_start                  ( q0_apb_start                      ),
//    .vio0_rstn_vio                      ( rstn_vio                          ),
//   
//    // Target Master Bus
// /*    .la1_clk                           ( clk_250m                          ), 
//    // Catch TARGET AXI
//     .la1_ddr_err                       (ddr_err                            ),
//     .la1_q0_TARGET_AXI_AWADDR          (q0_TARGET_AXI_AWADDR               ),
//     .la1_q0_TARGET_AXI_AWID            (q0_TARGET_AXI_AWID                 ),
//     .la1_q0_TARGET_AXI_AWVALID         (q0_TARGET_AXI_AWVALID              ),
//     .la1_q0_TARGET_AXI_AWREADY         (q0_TARGET_AXI_AWREADY              ),
//     .la1_q0_TARGET_AXI_WDATA           (q0_TARGET_AXI_WDATA                ),
//     .la1_q0_TARGET_AXI_WLAST           (q0_TARGET_AXI_WLAST                ),
//     .la1_q0_TARGET_AXI_WVALID          (q0_TARGET_AXI_WVALID               ),
//     .la1_q0_TARGET_AXI_WREADY          (q0_TARGET_AXI_WREADY               ),
//     .la1_q0_TARGET_AXI_BRESP           (q0_TARGET_AXI_BRESP                ),
//     .la1_q0_TARGET_AXI_BVALID          (q0_TARGET_AXI_BVALID               ),
//     .la1_q0_TARGET_AXI_BREADY          (q0_TARGET_AXI_BREADY               ),
//     .la1_q0_TARGET_AXI_ARADDR          (q0_TARGET_AXI_ARADDR               ),
//     .la1_q0_TARGET_AXI_ARID            (q0_TARGET_AXI_ARID                 ),
//     .la1_q0_TARGET_AXI_ARVALID         (q0_TARGET_AXI_ARVALID              ),
//     .la1_q0_TARGET_AXI_ARREADY         (q0_TARGET_AXI_ARREADY              ),
//     .la1_q0_TARGET_AXI_RDATA           (q0_TARGET_AXI_RDATA                ),
//     .la1_q0_TARGET_AXI_RLAST           (q0_TARGET_AXI_RLAST                ),
//     .la1_q0_TARGET_AXI_RRESP           (q0_TARGET_AXI_RRESP                ),
//     .la1_q0_TARGET_AXI_RVALID          (q0_TARGET_AXI_RVALID               ),
//     .la1_q0_TARGET_AXI_RREADY          (q0_TARGET_AXI_RREADY               ),
//
//     .la1_q0_MASTER_AXI_AWADDR          (q0_MASTER_AXI_AWADDR               ),
//     .la1_q0_MASTER_AXI_AWID            (q0_MASTER_AXI_AWID                 ),
//     .la1_q0_MASTER_AXI_AWVALID         (q0_MASTER_AXI_AWVALID              ),
//     .la1_q0_MASTER_AXI_AWREADY         (q0_MASTER_AXI_AWREADY              ),
//     .la1_q0_MASTER_AXI_WDATA           (q0_MASTER_AXI_WDATA                ),
//     .la1_q0_MASTER_AXI_WLAST           (q0_MASTER_AXI_WLAST                ),
//     .la1_q0_MASTER_AXI_WVALID          (q0_MASTER_AXI_WVALID               ),
//     .la1_q0_MASTER_AXI_WREADY          (q0_MASTER_AXI_WREADY               ),
//     .la1_q0_MASTER_AXI_BRESP           (q0_MASTER_AXI_BRESP                ),
//     .la1_q0_MASTER_AXI_BVALID          (q0_MASTER_AXI_BVALID               ),
//     .la1_q0_MASTER_AXI_BREADY          (q0_MASTER_AXI_BREADY               ),
//     .la1_q0_MASTER_AXI_ARADDR          (q0_MASTER_AXI_ARADDR               ),
//     .la1_q0_MASTER_AXI_ARID            (q0_MASTER_AXI_ARID                 ),
//     .la1_q0_MASTER_AXI_ARVALID         (q0_MASTER_AXI_ARVALID              ),
//     .la1_q0_MASTER_AXI_ARREADY         (q0_MASTER_AXI_ARREADY              ),
//     .la1_q0_MASTER_AXI_RDATA           (q0_MASTER_AXI_RDATA                ),
//     .la1_q0_MASTER_AXI_RLAST           (q0_MASTER_AXI_RLAST                ),
//     .la1_q0_MASTER_AXI_RRESP           (q0_MASTER_AXI_RRESP                ),
//     .la1_q0_MASTER_AXI_RVALID          (q0_MASTER_AXI_RVALID               ),
//     .la1_q0_MASTER_AXI_RREADY          (q0_MASTER_AXI_RREADY               ),*/
//     
//     .la0_clk                           (clk_250m                           ), 
//     .la0_ddr_err                       (ddr_err                            ),     
//     .la0_s0_axi_awaddr                 (s0_axi_awaddr                      ),
//     .la0_s0_axi_awid                   (s0_axi_awid                        ),
//     .la0_s0_axi_awvalid                (s0_axi_awvalid                     ),
//     .la0_s0_axi_awready                (s0_axi_awready                     ),
//     .la0_s0_axi_wdata                  (s0_axi_wdata                       ),
//     .la0_s0_axi_wlast                  (s0_axi_wlast                       ),
//     .la0_s0_axi_wvalid                 (s0_axi_wvalid                      ),
//     .la0_s0_axi_wready                 (s0_axi_wready                      ),
//     .la0_s0_axi_bresp                  (s0_axi_bresp                       ),
//     .la0_s0_axi_bvalid                 (s0_axi_bvalid                      ),
//     .la0_s0_axi_bready                 (s0_axi_bready                      ),
//     .la0_s0_axi_araddr                 (s0_axi_araddr                      ),
//     .la0_s0_axi_arid                   (s0_axi_arid                        ),
//     .la0_s0_axi_arvalid                (s0_axi_arvalid                     ),
//     .la0_s0_axi_arready                (s0_axi_arready                     ),
//     .la0_s0_axi_rdata                  (s0_axi_rdata                       ),
//     .la0_s0_axi_rlast                  (s0_axi_rlast                       ),
//     .la0_s0_axi_rresp                  (s0_axi_rresp                       ),
//     .la0_s0_axi_rvalid                 (s0_axi_rvalid                      ),
//     .la0_s0_axi_rready                 (s0_axi_rready                      ),
//
//     .la0_s1_axi_awaddr                 (s1_axi_awaddr                      ),
//     .la0_s1_axi_awid                   (s1_axi_awid                        ),
//     .la0_s1_axi_awvalid                (s1_axi_awvalid                     ),
//     .la0_s1_axi_awready                (s1_axi_awready                     ),
//     .la0_s1_axi_wdata                  (s1_axi_wdata                       ),
//     .la0_s1_axi_wlast                  (s1_axi_wlast                       ),
//     .la0_s1_axi_wvalid                 (s1_axi_wvalid                      ),
//     .la0_s1_axi_wready                 (s1_axi_wready                      ),
//     .la0_s1_axi_bresp                  (s1_axi_bresp                       ),
//     .la0_s1_axi_bvalid                 (s1_axi_bvalid                      ),
//     .la0_s1_axi_bready                 (s1_axi_bready                      ),
//     .la0_s1_axi_araddr                 (s1_axi_araddr                      ),
//     .la0_s1_axi_arid                   (s1_axi_arid                        ),
//     .la0_s1_axi_arvalid                (s1_axi_arvalid                     ),
//     .la0_s1_axi_arready                (s1_axi_arready                     ),
//     .la0_s1_axi_rdata                  (s1_axi_rdata                       ),
//     .la0_s1_axi_rlast                  (s1_axi_rlast                       ),
//     .la0_s1_axi_rresp                  (s1_axi_rresp                       ),
//     .la0_s1_axi_rvalid                 (s1_axi_rvalid                      ),
//     .la0_s1_axi_rready                 (s1_axi_rready                      ),
//     .la0_addr_AXI_AWADDR               (axi0_AWADDR                        ),
//     .la0_addr_AXI_AWID                 (axi0_AWID                          ),
//     .la0_addr_AXI_AWVALID              (axi0_AWVALID                       ),
//     .la0_addr_AXI_AWREADY              (axi0_AWREADY                       ),
//     .la0_addr_AXI_WDATA                (axi0_WDATA                         ),
//     .la0_addr_AXI_WLAST                (axi0_WLAST                         ),
//     .la0_addr_AXI_WVALID               (axi0_WVALID                        ),
//     .la0_addr_AXI_WREADY               (axi0_WREADY                        ),
//     .la0_addr_AXI_BRESP                (axi0_BRESP                         ),
//     .la0_addr_AXI_BVALID               (axi0_BVALID                        ),
//     .la0_addr_AXI_BREADY               (axi0_BREADY                        ),
//     .la0_addr_AXI_ARADDR               (axi0_ARADDR                        ),
//     .la0_addr_AXI_ARID                 (axi0_ARID                          ),
//     .la0_addr_AXI_ARVALID              (axi0_ARVALID                       ),
//     .la0_addr_AXI_ARREADY              (axi0_ARREADY                       ),
//     .la0_addr_AXI_RDATA                (axi0_RDATA                         ),
//     .la0_addr_AXI_RLAST                (axi0_RLAST                         ),
//     .la0_addr_AXI_RRESP                (axi0_RRESP                         ),
//     .la0_addr_AXI_RVALID               (axi0_RVALID                        ),
//     .la0_addr_AXI_RREADY               (axi0_RREADY                        ),
//     .la0_ddr_rd_err                    (ddr_rd_err                         ),
//
// 
//    
// /*    .la2_clk                           (clk_200m                           ), 
//     .la2_addr_AXI_AWADDR               (axi0_AWADDR                        ),
//     .la2_addr_AXI_AWID                 (axi0_AWID                          ),
//     .la2_addr_AXI_AWVALID              (axi0_AWVALID                       ),
//     .la2_addr_AXI_AWREADY              (axi0_AWREADY                       ),
//     .la2_addr_AXI_WDATA                (axi0_WDATA                         ),
//     .la2_addr_AXI_WLAST                (axi0_WLAST                         ),
//     .la2_addr_AXI_WVALID               (axi0_WVALID                        ),
//     .la2_addr_AXI_WREADY               (axi0_WREADY                        ),
//     .la2_addr_AXI_BRESP                (axi0_BRESP                         ),
//     .la2_addr_AXI_BVALID               (axi0_BVALID                        ),
//     .la2_addr_AXI_BREADY               (axi0_BREADY                        ),
//     .la2_addr_AXI_ARADDR               (axi0_ARADDR                        ),
//     .la2_addr_AXI_ARID                 (axi0_ARID                          ),
//     .la2_addr_AXI_ARVALID              (axi0_ARVALID                       ),
//     .la2_addr_AXI_ARREADY              (axi0_ARREADY                       ),
//     .la2_addr_AXI_RDATA                (axi0_RDATA                         ),
//     .la2_addr_AXI_RLAST                (axi0_RLAST                         ),
//     .la2_addr_AXI_RRESP                (axi0_RRESP                         ),
//     .la2_addr_AXI_RVALID               (axi0_RVALID                        ),
//     .la2_addr_AXI_RREADY               (axi0_RREADY                        ),
//     .la2_ddr_rd_err                    (ddr_rd_err                         ),*/
//     
// /*   .la3_clk                            ( clk_250m                          ), 
//    .la3_m1_axi_awid                    (m1_axi_awid                        ),
//    .la3_m1_axi_awvalid                 (m1_axi_awvalid                     ),
//    .la3_m1_axi_awaddr                  (m1_axi_awaddr                      ),
//    .la3_m1_axi_awlen                   (m1_axi_awlen                       ),
//    .la3_m1_axi_awsize                  (m1_axi_awsize                      ),
//    .la3_m1_axi_awready                 (m1_axi_awready                     ),
//    .la3_m1_axi_wvalid                  (m1_axi_wvalid                      ),
//    .la3_m1_axi_wdata                   (m1_axi_wdata                       ),
//    .la3_m1_axi_wstrb                   (m1_axi_wstrb                       ),
//    .la3_m1_axi_wlast                   (m1_axi_wlast                       ),
//    .la3_m1_axi_wready                  (m1_axi_wready                      ),
////    .la3_m1_axi_bid                     (m1_axi_bid                         ),
//    .la3_m1_axi_bresp                   (m1_axi_bresp                       ),
//    .la3_m1_axi_bvalid                  (m1_axi_bvalid                      ),
//    .la3_m1_axi_bready                  (m1_axi_bready                      ),
//    .la3_m1_axi_arid                    (m1_axi_arid                        ),
//    .la3_m1_axi_arvalid                 (m1_axi_arvalid                     ),
//    .la3_m1_axi_araddr                  (m1_axi_araddr                      ),
//    .la3_m1_axi_arlen                   (m1_axi_arlen                       ),
//    .la3_m1_axi_arsize                  (m1_axi_arsize                      ),
//    .la3_m1_axi_arready                 (m1_axi_arready                     ),
//    .la3_m1_axi_rid                     (m1_axi_rid                         ),
//    .la3_m1_axi_rvalid                  (m1_axi_rvalid                      ),
//    .la3_m1_axi_rdata                   (m1_axi_rdata                       ),
//    .la3_m1_axi_rlast                   (m1_axi_rlast                       ),
//    .la3_m1_axi_rresp                   (m1_axi_rresp                       ),
//    .la3_m1_axi_rready                  (m1_axi_rready                      ),*/
//    
////    .la1_clk                            ( clk_250m                         ),
//    .la0_Q1_L2_RXC                      ( Q1_L2_RXC                         ),
//    .la0_Q1_L2_RXD                      ( Q1_L2_RXD                         ),
//    .la0_Q1_L2_TXC                      ( Q1_L2_TXC                         ),
//    .la0_Q1_L2_TXD                      ( Q1_L2_TXD                         ),    
//
////    .la3_clk                            ( clk_250m                             ),
//    .la0_rx_src_axis_tready             (axis_tready[1*1  +: 1*1 ]          ),
//    .la0_rx_src_axis_tvalid             (axis_tvalid[1*1  +: 1*1 ]          ),
//    .la0_rx_src_axis_tlast              (axis_tlast [1*1  +: 1*1 ]          ),
//    .la0_rx_src_axis_tdata              (axis_tdata [1*64 +: 1*64]          ),
//    .la0_rx_axis_mac_tkeep              (l2_rx_axis_mac_tkeep               ),
//                    
//    .la0_tx_src_axis_tready             (axis_tready[0*1  +: 1*1 ]          ),
//    .la0_tx_src_axis_tdata              (axis_tdata [0*64 +: 1*64]          ),
//    .la0_tx_src_axis_tvalid             (axis_tvalid[0*1  +: 1*1 ]          ),
//    .la0_tx_src_axis_tlast              (axis_tlast [0*1  +: 1*1 ]          )   
//);
endmodule
