//--------------------------------------------------------------------------------------------------------------------------//
// PCIe DMA Debug Project
// Date:2024-08-05
//--------------------------------------------------------------------------------------------------------------------------//
`define DB_PCIE_ODD_EVEN_SELECT 1

`timescale 1ns/1ps

module pcie
(
    // TB
    input  logic         in_user,
    output logic         phy_rstn,
    
    // Clock
    input  logic         axi_clk,
    input  logic         axiclk,
    input  logic         apbclk,
    
    // PCIE Quad 0 - EP
    output logic         q0_USER_PHY_RESET_N,
    output logic         q0_USER_RESET_N_IN,
    output logic         q0_RESET_ACK,
    input  logic         q0_RESET_REQ,
    
    
    //----------------------------------------------------------------------------//
    // lpddr4
    //----------------------------------------------------------------------------//

    input               ddr1_pll_locked,

    output              u1_cfg_start,
    output              u1_cfg_reset,
    output              u1_cfg_sel,
    input               u1_cfg_done,

    output              u1_ddr_ARSTN_0,
    output              u1_ddr_ARQOS_0,
    output              u1_ddr_AWQOS_0,
    output [5:0]        u1_ddr_AWID_0,
    output [32:0]       u1_ddr_AWADDR_0,
    output [7:0]        u1_ddr_AWLEN_0,
    output [2:0]        u1_ddr_AWSIZE_0,
    output [1:0]        u1_ddr_AWBURST_0,
    output              u1_ddr_AWVALID_0,
    output [3:0]        u1_ddr_AWCACHE_0,
    output              u1_ddr_AWCOBUF_0,
    output              u1_ddr_AWLOCK_0,
    output              u1_ddr_AWAPCMD_0,
    output              u1_ddr_AWALLSTRB_0,
    output [5:0]        u1_ddr_ARID_0,
    output [32:0]       u1_ddr_ARADDR_0,
    output [7:0]        u1_ddr_ARLEN_0,
    output [2:0]        u1_ddr_ARSIZE_0,
    output [1:0]        u1_ddr_ARBURST_0,
    output              u1_ddr_ARVALID_0,
    output              u1_ddr_ARLOCK_0,
    output              u1_ddr_ARAPCMD_0,
    output              u1_ddr_WLAST_0,
    output              u1_ddr_WVALID_0,
    output [511:0]      u1_ddr_WDATA_0,
    output [63:0]       u1_ddr_WSTRB_0,
    output              u1_ddr_BREADY_0,
    output              u1_ddr_RREADY_0,
    input               u1_ddr_AWREADY_0,
    input               u1_ddr_ARREADY_0,
    input               u1_ddr_WREADY_0,
    input [5:0]         u1_ddr_BID_0,
    input [1:0]         u1_ddr_BRESP_0,
    input               u1_ddr_BVALID_0,
    input [5:0]         u1_ddr_RID_0,
    input               u1_ddr_RLAST_0,
    input               u1_ddr_RVALID_0,
    input [511:0]       u1_ddr_RDATA_0,
    input [1:0]         u1_ddr_RRESP_0,

    output              u1_ddr_ARSTN_1,
    output              u1_ddr_ARQOS_1,
    output              u1_ddr_AWQOS_1,
    output [5:0]        u1_ddr_AWID_1,
    output [32:0]       u1_ddr_AWADDR_1,
    output [7:0]        u1_ddr_AWLEN_1,
    output [2:0]        u1_ddr_AWSIZE_1,
    output [1:0]        u1_ddr_AWBURST_1,
    output              u1_ddr_AWVALID_1,
    output [3:0]        u1_ddr_AWCACHE_1,
    output              u1_ddr_AWCOBUF_1,
    output              u1_ddr_AWLOCK_1,
    output              u1_ddr_AWAPCMD_1,
    output              u1_ddr_AWALLSTRB_1,
    output [5:0]        u1_ddr_ARID_1,
    output [32:0]       u1_ddr_ARADDR_1,
    output [7:0]        u1_ddr_ARLEN_1,
    output [2:0]        u1_ddr_ARSIZE_1,
    output [1:0]        u1_ddr_ARBURST_1,
    output              u1_ddr_ARVALID_1,
    output              u1_ddr_ARLOCK_1,
    output              u1_ddr_ARAPCMD_1,
    output              u1_ddr_WLAST_1,
    output              u1_ddr_WVALID_1,
    output [511:0]      u1_ddr_WDATA_1,
    output [63:0]       u1_ddr_WSTRB_1,
    output              u1_ddr_BREADY_1,
    output              u1_ddr_RREADY_1,
    input               u1_ddr_AWREADY_1,
    input               u1_ddr_ARREADY_1,
    input               u1_ddr_WREADY_1,
    input [5:0]         u1_ddr_BID_1,
    input [1:0]         u1_ddr_BRESP_1,
    input               u1_ddr_BVALID_1,
    input [5:0]         u1_ddr_RID_1,
    input               u1_ddr_RLAST_1,
    input               u1_ddr_RVALID_1,
    input [511:0]       u1_ddr_RDATA_1,
    input [1:0]         u1_ddr_RRESP_1,

    input               u1_CTRL_INT,
    input               u1_CTRL_MEM_RST_VALID,
    input               u1_CTRL_REFRESH,
    input               u1_CTRL_BUSY,
    input               u1_CTRL_CMD_Q_ALMOST_FULL,
    input               u1_CTRL_DP_IDLE,
    input [1:0]         u1_CTRL_CKE,
    input [1:0]         u1_CTRL_PORT_BUSY,
    
    //----------------------------------------------------------------------------//
    // TARGET_AXI 
    //----------------------------------------------------------------------------//
    output logic         q0_USER_AXI_RESET_N,
    
    // AXI Master Write Address
    input  logic [ 63:0] q0_TARGET_AXI_AWADDR,
    input  logic [  7:0] q0_TARGET_AXI_AWID,
    input  logic [  7:0] q0_TARGET_AXI_AWLEN,
    input  logic [  2:0] q0_TARGET_AXI_AWSIZE,
    input  logic         q0_TARGET_AXI_AWVALID,
    input  logic [ 87:0] q0_TARGET_AXI_AWUSER,
    output logic         q0_TARGET_AXI_AWREADY,
    
    // AXI Master Write Data
    input  logic [255:0] q0_TARGET_AXI_WDATA,
    input  logic [ 31:0] q0_TARGET_AXI_WDATA_PAR,
    input  logic         q0_TARGET_AXI_WLAST,
    input  logic [ 31:0] q0_TARGET_AXI_WSTRB,
    input  logic [  3:0] q0_TARGET_AXI_WSTRB_PAR,
    input  logic         q0_TARGET_AXI_WVALID,
    output logic         q0_TARGET_AXI_WREADY,
    
    // AXI Master Write Response
    output logic [  7:0] q0_TARGET_AXI_BID,
    output logic         q0_TARGET_AXI_BID_PAR,
    output logic [  1:0] q0_TARGET_AXI_BRESP,
    output logic         q0_TARGET_AXI_BRESP_PAR,
    output logic         q0_TARGET_AXI_BVALID,
    input  logic         q0_TARGET_AXI_BREADY,
    
    // AXI Master read address
    input  logic [ 63:0] q0_TARGET_AXI_ARADDR,
    input  logic [  7:0] q0_TARGET_AXI_ARID,
    input  logic [  7:0] q0_TARGET_AXI_ARLEN,
    input  logic [  2:0] q0_TARGET_AXI_ARSIZE,
    input  logic         q0_TARGET_AXI_ARVALID,
    input  logic [ 87:0] q0_TARGET_AXI_ARUSER,
    output logic         q0_TARGET_AXI_ARREADY,
    
    // AXI Master Read Data
    output logic [255:0] q0_TARGET_AXI_RDATA,
    output logic [ 31:0] q0_TARGET_AXI_RDATA_PAR,
    output logic [  7:0] q0_TARGET_AXI_RID,
    output logic         q0_TARGET_AXI_RID_PAR,
    output logic         q0_TARGET_AXI_RLAST,
    output logic [  1:0] q0_TARGET_AXI_RRESP,
    output logic         q0_TARGET_AXI_RRESP_PAR,
    output logic         q0_TARGET_AXI_RVALID,
    input  logic         q0_TARGET_AXI_RREADY,
    
    // AXI Master Sideband
    output logic         q0_TARGET_NON_POSTED_REJ,
    
    //----------------------------------------------------------------------------//
    // MASTER_AXI 
    //----------------------------------------------------------------------------//
    // AXI Slave Write Address
    output logic [ 63:0] q0_MASTER_AXI_AWADDR,
    output logic [  7:0] q0_MASTER_AXI_AWID,
    output logic [  7:0] q0_MASTER_AXI_AWLEN,
    output logic [  2:0] q0_MASTER_AXI_AWSIZE,
    output logic         q0_MASTER_AXI_AWVALID,
    output logic [ 87:0] q0_MASTER_AXI_AWUSER,
    input  logic         q0_MASTER_AXI_AWREADY,
    
    // AXI Slave Write Data
    output logic [255:0] q0_MASTER_AXI_WDATA,
    output logic [ 31:0] q0_MASTER_AXI_WDATA_PAR,
    output logic         q0_MASTER_AXI_WLAST,
    output logic [ 31:0] q0_MASTER_AXI_WSTRB,
    output logic [  3:0] q0_MASTER_AXI_WSTRB_PAR,
    output logic         q0_MASTER_AXI_WVALID,
    input  logic         q0_MASTER_AXI_WREADY,
    
    // AXI Slave Write Response
    input  logic [  7:0] q0_MASTER_AXI_BID,
    input  logic         q0_MASTER_AXI_BID_PAR,
    input  logic [  1:0] q0_MASTER_AXI_BRESP,
    input  logic         q0_MASTER_AXI_BRESP_PAR,
    input  logic         q0_MASTER_AXI_BVALID,
    output logic         q0_MASTER_AXI_BREADY,
    
    // AXI Slave Read Address
    output logic [ 63:0] q0_MASTER_AXI_ARADDR,
    output logic [  7:0] q0_MASTER_AXI_ARID,
    output logic [  7:0] q0_MASTER_AXI_ARLEN,
    output logic [  2:0] q0_MASTER_AXI_ARSIZE,
    output logic         q0_MASTER_AXI_ARVALID,
    output logic [ 87:0] q0_MASTER_AXI_ARUSER,
    input  logic         q0_MASTER_AXI_ARREADY,
    
    // AXI Slave Read Data
    input  logic [255:0] q0_MASTER_AXI_RDATA,
    input  logic [ 31:0] q0_MASTER_AXI_RDATA_PAR,
    input  logic [  7:0] q0_MASTER_AXI_RID,
    input  logic         q0_MASTER_AXI_RID_PAR,
    input  logic         q0_MASTER_AXI_RLAST,
    input  logic [  1:0] q0_MASTER_AXI_RRESP,
    input  logic         q0_MASTER_AXI_RRESP_PAR,
    input  logic         q0_MASTER_AXI_RVALID,
    output logic         q0_MASTER_AXI_RREADY,
    
    //----------------------------------------------------------------------------//
    // APB Inferface 
    //----------------------------------------------------------------------------//
    output logic [ 23:0] q0_USER_APB_PADDR,
    output logic         q0_USER_APB_PSEL,
    output logic         q0_USER_APB_PENABLE,
    output logic         q0_USER_APB_PWRITE,
    output logic [ 31:0] q0_USER_APB_PWDATA,
    output logic [  3:0] q0_USER_APB_PWDATA_PAR,
    output logic [  3:0] q0_USER_APB_PSTRB,
    output logic         q0_USER_APB_PSTRB_PAR,
    input  logic [ 31:0] q0_USER_APB_PRDATA,
    input  logic [  3:0] q0_USER_APB_PRDATA_PAR,
    input  logic         q0_USER_APB_PREADY,
    input  logic         q0_USER_APB_PSLVERR,
    
    // FLR
    input  logic [ 3:0]  q0_FLR_IN_PROGRESS,
    output logic [ 3:0]  q0_FLR_DONE,
    
    // Interrupt Pin
    input  logic         q0_LOCAL_INTERRUPT,
    input  logic [ 27:0] q0_INTERRUPT_SIDEBAND_SIGNALS,
    
    // Legacy Interrupt Pin
    output logic         q0_INTA_IN,
    output logic         q0_INTB_IN,
    output logic         q0_INTC_IN,
    output logic         q0_INTD_IN,
    output logic [  3:0] q0_INT_PENDING_STATUS,
    input  logic         q0_INT_ACK,
    
    // Message Pin
    input  logic [255:0] q0_MSG,
    input  logic [ 31:0] q0_MSG_BYTE_EN,
    input  logic         q0_MSG_DATA,
    input  logic         q0_MSG_END,
    input  logic [ 21:0] q0_MSG_PASID,
    input  logic         q0_MSG_PASID_PRESENT,
    input  logic         q0_MSG_START,
    input  logic         q0_MSG_VALID,
    input  logic         q0_MSG_VDH,
    
    // Error Pin
    output logic         q0_CORRECTABLE_ERROR_IN,
    output logic         q0_UNCORRECTABLE_ERROR_IN,
    input  logic         q0_FATAL_ERROR_OUT,
    input  logic         q0_NON_FATAL_ERROR_OUT,
    input  logic         q0_CORRECTABLE_ERROR_OUT,

    // Status Pin
    input  logic [  5:0] q0_LTSSM_STATE,
    input  logic         q0_REG_ACCESS_CLK_SHUTOFF,
    input  logic         q0_CORE_CLK_SHUTOFF,
    input  logic [  1:0] q0_LINK_STATUS,             // 2'b00:No receivers detected, 2'b01:Linking training in progress, 2'b10:Link up, DL initialization in progress, 2'b11:Link up, DL initialization completed
    input  logic [ 15:0] q0_FUNCTION_STATUS,
    input  logic [  2:0] q0_PCIE_MAX_READ_REQ_SIZE,  // 3'b000:128, 3'b001:256, 3'b010:512, 3'b011:1024, 3'b100:2948, 3'b101:4096
    input  logic [  2:0] q0_PCIE_MAX_PAYLOAD_SIZE,
    input  logic [  1:0] q0_PIPE_P00_RATE,           // 2'b00:Gen1, 2'b01:Gen2, 2'b10:Gen3, 2'b11:Gen4 
    input  logic         q0_PMA_CMN_READY,
    
    // Configuration Snoop Pin
    output logic [ 31:0] q0_CONFIG_READ_DATA,
    output logic [  3:0] q0_CONFIG_READ_DATA_PAR,
    output logic         q0_CONFIG_READ_DATA_VALID,
    input  logic         q0_CONFIG_READ_RECEIVED,
    input  logic [  9:0] q0_CONFIG_REG_NUM,
    input  logic [  3:0] q0_CONFIG_WRITE_BYTE_ENABLE,
    input  logic         q0_CONFIG_WRITE_BYTE_ENABLE_PAR,
    input  logic [ 31:0] q0_CONFIG_WRITE_DATA,
    input  logic [  3:0] q0_CONFIG_WRITE_DATA_PAR,
    input  logic         q0_CONFIG_WRITE_RECEIVED,
    input  logic [  7:0] q0_CONFIG_FUNCTION_NUM,
    
    input  logic [ 15:0] q0_DEBUG_DATA_OUT,                                           
    input  logic         q0_FPGA_DIV2_CLK,   
    output logic         q0_FPGA_DIV2_CLK_io,

    //----------------------------------------------------------------------------//
    // VIO/LIO JTAG inferface for debug
    //----------------------------------------------------------------------------//
    input  logic         bscan_DRCK,
    input  logic         bscan_RESET,
    input  logic         bscan_TMS,
    input  logic         bscan_RUNTEST,
    input  logic         bscan_SEL,
    input  logic         bscan_SHIFT,
    input  logic         bscan_TDI,
    input  logic         bscan_CAPTURE,
    input  logic         bscan_TCK,
    input  logic         bscan_UPDATE,
    output logic         bscan_TDO
);
//--------------------------------------------------------------------------------------------------------------------------//
// Signals
//--------------------------------------------------------------------------------------------------------------------------//
logic [ 15:0] user_reset_r;
logic         user_reset;
/*logic [  4:0] aw_byte_idx;
logic [  4:0] ar_byte_idx;*/
logic [  7:0] s_cfg_axil_awid;
logic [  7:0] s_cfg_axil_arid;

logic [  4:0] m0_aw_byte_idx;
logic [  4:0] m0_ar_byte_idx;
logic [  4:0] m1_aw_byte_idx;
logic [  4:0] m1_ar_byte_idx;


logic         rstn_vio;
logic         q0_apb_start;
logic [ 23:0] q0_paddr_test;
logic [ 31:0] q0_pwdata_vio;
logic [  3:0] q0_pwdata_par_vio;
logic         q0_write_vio;
logic [  3:0] q0_obs_pstates;
logic  [31:0] q0_prdata_test; 
logic         q0_apb_done;

parameter                       AXI_DW =256;
parameter                       AXI_AW = 64;
parameter                       AXI_SW = (AXI_DW/8);
parameter                       ID_WIDTH = 8;
parameter                       AWUSER_WIDTH = 1;
parameter                       WUSER_WIDTH = 1;
parameter                       BUSER_WIDTH = 1;
parameter                       ARUSER_WIDTH = 1;
parameter                       RUSER_WIDTH = 1;


wire    [2*ID_WIDTH-1:0]        s_axi_awid;
wire    [2*AXI_AW-1:0]          s_axi_awaddr;
wire    [2*8-1:0]               s_axi_awlen;
wire    [2*3-1:0]               s_axi_awsize;
wire    [2*2-1:0]               s_axi_awburst;
wire    [2-1:0]                 s_axi_awlock;
wire    [2*4-1:0]               s_axi_awcache;
wire    [2*3-1:0]               s_axi_awprot;
wire    [2*4-1:0]               s_axi_awqos;
wire    [2*AWUSER_WIDTH-1:0]    s_axi_awuser;
wire    [2-1:0]                 s_axi_awvalid;
wire    [2-1:0]                 s_axi_awready;
wire    [2*512-1:0]             s_axi_wdata;
wire    [2*AXI_SW-1:0]          s_axi_wstrb;
wire    [2-1:0]                 s_axi_wlast;
wire    [2*WUSER_WIDTH-1:0]     s_axi_wuser;
wire    [2-1:0]                 s_axi_wvalid;
wire    [2-1:0]                 s_axi_wready;
wire    [2*ID_WIDTH-1:0]        s_axi_bid;
wire    [2*2-1:0]               s_axi_bresp;
wire    [2*BUSER_WIDTH-1:0]     s_axi_buser;
wire    [2-1:0]                 s_axi_bvalid;
wire    [2-1:0]                 s_axi_bready;
wire    [2*ID_WIDTH-1:0]        s_axi_arid;
wire    [2*AXI_AW-1:0]          s_axi_araddr;
wire    [2*8-1:0]               s_axi_arlen;
wire    [2*3-1:0]               s_axi_arsize;
wire    [2*2-1:0]               s_axi_arburst;
wire    [2-1:0]                 s_axi_arlock;
wire    [2*4-1:0]               s_axi_arcache;
wire    [2*3-1:0]               s_axi_arprot;
wire    [2*4-1:0]               s_axi_arqos;
wire    [2*ARUSER_WIDTH-1:0]    s_axi_aruser;
wire    [2-1:0]                 s_axi_arvalid;
wire    [2-1:0]                 s_axi_arready;
wire    [2*ID_WIDTH-1:0]        s_axi_rid;
wire    [2*512-1:0]             s_axi_rdata;
wire    [2*2-1:0]               s_axi_rresp;
wire    [2-1:0]                 s_axi_rlast;
wire    [2*RUSER_WIDTH-1:0]     s_axi_ruser;
wire    [2-1:0]                 s_axi_rvalid;
wire    [2-1:0]                 s_axi_rready;

wire  [63:0] desc_src_addr;

logic [ 31:0] s_cfg_axil_awaddr;
logic [  2:0] s_cfg_axil_awprot;
logic         s_cfg_axil_awvalid;
logic         s_cfg_axil_awready;
logic [ 31:0] s_cfg_axil_wdata;
logic [  3:0] s_cfg_axil_wstrb;
logic         s_cfg_axil_wvalid;
logic         s_cfg_axil_wready;
logic         s_cfg_axil_bvalid;
logic [  1:0] s_cfg_axil_bresp;
logic         s_cfg_axil_bready;
logic [ 31:0] s_cfg_axil_araddr;
logic [  2:0] s_cfg_axil_arprot;
logic         s_cfg_axil_arvalid;
logic         s_cfg_axil_arready;
logic [ 31:0] s_cfg_axil_rdata;
logic [  1:0] s_cfg_axil_rresp;
logic         s_cfg_axil_rvalid;
logic         s_cfg_axil_rready;

logic [  7:0] s_cfg1_axil_awid;
logic [  7:0] s_cfg1_axil_arid;
logic [ 31:0] s_cfg1_axil_awaddr;
logic [  2:0] s_cfg1_axil_awprot;
logic         s_cfg1_axil_awvalid;
logic         s_cfg1_axil_awready;
logic [ 31:0] s_cfg1_axil_wdata;
logic [  3:0] s_cfg1_axil_wstrb;
logic         s_cfg1_axil_wvalid;
logic         s_cfg1_axil_wready;
logic         s_cfg1_axil_bvalid;
logic [  1:0] s_cfg1_axil_bresp;
logic         s_cfg1_axil_bready;
logic [ 31:0] s_cfg1_axil_araddr;
logic [  2:0] s_cfg1_axil_arprot;
logic         s_cfg1_axil_arvalid;
logic         s_cfg1_axil_arready;
logic [ 31:0] s_cfg1_axil_rdata;
logic [  1:0] s_cfg1_axil_rresp;
logic         s_cfg1_axil_rvalid;
logic         s_cfg1_axil_rready;

logic [ 63:0] m_c_axi_awaddr;       
logic [  7:0] m_c_axi_awid;          
logic [  7:0] m_c_axi_awlen;         
logic [  2:0] m_c_axi_awsize;        
logic [  1:0] m_c_axi_awburst;       
logic [  2:0] m_c_axi_awprot;        
logic         m_c_axi_awvalid;       
logic         m_c_axi_awready;       
logic         m_c_axi_awlock;        
logic [  3:0] m_c_axi_awcache;       
logic [255:0] m_c_axi_wdata;         
logic [ 31:0] m_c_axi_wdataeccparity;
logic [ 31:0] m_c_axi_wstrb;         
logic         m_c_axi_wlast;         
logic         m_c_axi_wvalid;        
logic         m_c_axi_wready;        
logic [  1:0] m_c_axi_bresp;         
logic [  7:0] m_c_axi_bid;           
logic         m_c_axi_bvalid;        
logic         m_c_axi_bready;        
logic [  7:0] m_c_axi_arid;          
logic [ 63:0] m_c_axi_araddr;        
logic [  7:0] m_c_axi_arlen;         
logic [  2:0] m_c_axi_arsize;        
logic [  1:0] m_c_axi_arburst;       
logic [  2:0] m_c_axi_arprot;        
logic         m_c_axi_arvalid;       
logic         m_c_axi_arready;       
logic         m_c_axi_arlock;        
logic [  3:0] m_c_axi_arcache;       
logic [  7:0] m_c_axi_rid;           
logic [255:0] m_c_axi_rdata;         
logic [ 31:0] m_c_axi_rdataeccparity;
logic [  1:0] m_c_axi_rresp;         
logic         m_c_axi_rlast;         
logic         m_c_axi_rvalid;        
logic         m_c_axi_rready;  

logic [ 63:0] m_ddr_axi_awaddr;       
logic [  7:0] m_ddr_axi_awid;          
logic [  7:0] m_ddr_axi_awlen;         
logic [  2:0] m_ddr_axi_awsize;        
logic [  1:0] m_ddr_axi_awburst;       
logic [  2:0] m_ddr_axi_awprot;        
logic         m_ddr_axi_awvalid;       
logic         m_ddr_axi_awready;       
logic         m_ddr_axi_awlock;        
logic [  3:0] m_ddr_axi_awcache;       
logic [511:0] m_ddr_axi_wdata;         
logic [ 31:0] m_ddr_axi_wdataeccparity;
logic [ 63:0] m_ddr_axi_wstrb;         
logic         m_ddr_axi_wlast;         
logic         m_ddr_axi_wvalid;        
logic         m_ddr_axi_wready;        
logic [  1:0] m_ddr_axi_bresp;         
logic [  7:0] m_ddr_axi_bid;           
logic         m_ddr_axi_bvalid;        
logic         m_ddr_axi_bready;        
logic [  7:0] m_ddr_axi_arid;          
logic [ 63:0] m_ddr_axi_araddr;        
logic [  7:0] m_ddr_axi_arlen;         
logic [  2:0] m_ddr_axi_arsize;        
logic [  1:0] m_ddr_axi_arburst;       
logic [  2:0] m_ddr_axi_arprot;        
logic         m_ddr_axi_arvalid;       
logic         m_ddr_axi_arready;       
logic         m_ddr_axi_arlock;        
logic [  3:0] m_ddr_axi_arcache;       
logic [  7:0] m_ddr_axi_rid;           
logic [511:0] m_ddr_axi_rdata;         
logic [ 31:0] m_ddr_axi_rdataeccparity;
logic [  1:0] m_ddr_axi_rresp;         
logic         m_ddr_axi_rlast;         
logic         m_ddr_axi_rvalid;        
logic         m_ddr_axi_rready;  


wire                  desc_rd_ready           ;
wire                  desc_rd_valid           ;
wire  [63:0]          rd_saddr                ;
wire  [27:0]          rd_size                 ;
wire  [31:0]          rd_saddr_h              ;
wire  [31:0]          rd_saddr_l              ;

wire                    rx_src_axis_tready          ;
wire    [AXI_DW-1:0]  rx_src_axis_tdata           ;
wire                    rx_src_axis_tvalid          ;
wire                    rx_src_axis_tlast           ;

wire                         check_data_clear        ;
wire                         err_int                 ;
wire         [31:0]          check_sum               ;
wire         [31:0]          error_sum               ;


logic         h2c_running;   
logic         h2c_busy;      
logic         h2c_interrupt; 
logic         c2h_running;   
logic         c2h_busy;      
logic         c2h_interrupt;
logic         int_ack_r0;
logic         int_ack_r1; 
logic [  5:0] int_ack_cnt;  

reg     [7:0]           m1_rid;
reg     [7:0]           m2_rid;
reg     [7:0]           m1_bid;
reg     [7:0]           m2_bid;


wire    [7:0]           user_m_axi_awid    ;
wire                    user_m_axi_awvalid ;
wire    [63:0]          user_m_axi_awaddr  ;
wire    [3:0]           user_m_axi_awregion;
wire    [7:0]           user_m_axi_awlen   ;
wire    [2:0]           user_m_axi_awsize  ;
wire    [1:0]           user_m_axi_awburst ;
wire    [2:0]           user_m_axi_awprot  ;
wire    [1:0]           user_m_axi_awlock  ;
wire    [3:0]           user_m_axi_awcache ;
wire                    user_m_axi_awready ;
wire                    user_m_axi_wvalid  ;
wire    [255:0]          user_m_axi_wdata   ;
wire    [31:0]           user_m_axi_wstrb   ;
wire                    user_m_axi_wlast   ;
wire                    user_m_axi_wready  ;
wire    [7:0]           user_m_axi_bid     ;
wire    [1:0]           user_m_axi_bresp   ;
wire                    user_m_axi_bvalid  ;
wire                    user_m_axi_bready  ;

wire    [7:0]           user_m_axi_arid    ;
wire                    user_m_axi_arvalid ;
wire    [63:0]          user_m_axi_araddr  ;
wire    [7:0]           user_m_axi_arlen   ;
wire    [2:0]           user_m_axi_arsize  ;
wire                    user_m_axi_arready ;
wire    [7:0]           user_m_axi_rid     ;
wire                    user_m_axi_rvalid  ;
wire    [255:0]         user_m_axi_rdata   ;
wire                    user_m_axi_rlast   ;
wire    [1:0]           user_m_axi_rresp   ;
wire                    user_m_axi_rready  ;

wire    [7:0]           m0_axi_awid    ;
wire                    m0_axi_awvalid ;
wire    [63:0]          m0_axi_awaddr  ;
wire    [7:0]           m0_axi_awlen   ;
wire    [2:0]           m0_axi_awsize  ;
wire                    m0_axi_awready ;
wire                    m0_axi_wvalid  ;
wire    [255:0]         m0_axi_wdata   ;
wire    [31:0]          m0_axi_wstrb   ;
wire                    m0_axi_wlast   ;
wire                    m0_axi_wready  ;
wire    [7:0]           m0_axi_bid     ;
wire    [1:0]           m0_axi_bresp   ;
wire                    m0_axi_bvalid  ;
wire                    m0_axi_bready  ;
wire    [7:0]           m0_axi_arid    ;
wire                    m0_axi_arvalid ;
wire    [63:0]          m0_axi_araddr  ;
wire    [7:0]           m0_axi_arlen   ;
wire    [2:0]           m0_axi_arsize  ;
wire                    m0_axi_arready ;
wire    [7:0]           m0_axi_rid     ;
wire                    m0_axi_rvalid  ;
wire    [255:0]         m0_axi_rdata   ;
wire                    m0_axi_rlast   ;
wire    [1:0]           m0_axi_rresp   ;
wire                    m0_axi_rready  ;

wire    [7:0]           m1_axi_awid    ;
wire                    m1_axi_awvalid ;
wire    [63:0]          m1_axi_awaddr  ;
wire    [7:0]           m1_axi_awlen   ;
wire    [2:0]           m1_axi_awsize  ;
wire                    m1_axi_awready ;
wire                    m1_axi_wvalid  ;
wire    [255:0]         m1_axi_wdata   ;
wire    [31:0]          m1_axi_wstrb   ;
wire                    m1_axi_wlast   ;
wire                    m1_axi_wready  ;
wire    [7:0]           m1_axi_bid     ;
wire    [1:0]           m1_axi_bresp   ;
wire                    m1_axi_bvalid  ;
wire                    m1_axi_bready  ;
wire    [7:0]           m1_axi_arid    ;
wire                    m1_axi_arvalid ;
wire    [63:0]          m1_axi_araddr  ;
wire    [7:0]           m1_axi_arlen   ;
wire    [2:0]           m1_axi_arsize  ;
wire                    m1_axi_arready ;
wire    [7:0]           m1_axi_rid     ;
wire                    m1_axi_rvalid  ;
wire    [255:0]         m1_axi_rdata   ;
wire                    m1_axi_rlast   ;
wire    [1:0]           m1_axi_rresp   ;
wire                    m1_axi_rready  ;

wire    [7:0]           m2_axi_awid    ;
wire                    m2_axi_awvalid ;
wire    [63:0]          m2_axi_awaddr  ;
wire    [7:0]           m2_axi_awlen   ;
wire    [2:0]           m2_axi_awsize  ;
wire                    m2_axi_awready ;
wire                    m2_axi_wvalid  ;
wire    [255:0]         m2_axi_wdata   ;
wire    [31:0]          m2_axi_wstrb   ;
wire                    m2_axi_wlast   ;
wire                    m2_axi_wready  ;
wire    [7:0]           m2_axi_bid     ;
wire    [1:0]           m2_axi_bresp   ;
wire                    m2_axi_bvalid  ;
wire                    m2_axi_bready  ;
wire    [7:0]           m2_axi_arid    ;
wire                    m2_axi_arvalid ;
wire    [63:0]          m2_axi_araddr  ;
wire    [7:0]           m2_axi_arlen   ;
wire    [2:0]           m2_axi_arsize  ;
wire                    m2_axi_arready ;
wire    [7:0]           m2_axi_rid     ;
wire                    m2_axi_rvalid  ;
wire    [255:0]         m2_axi_rdata   ;
wire                    m2_axi_rlast   ;
wire    [1:0]           m2_axi_rresp   ;
wire                    m2_axi_rready  ;

wire    [31:0]          s_apb3_rx_paddr    ;
wire                    s_apb3_rx_psel     ;
wire                    s_apb3_rx_penable  ;
wire                    s_apb3_rx_pready   ;
wire                    s_apb3_rx_pwrite   ;//0:rd; 1:wr;
wire    [31:0]          s_apb3_rx_pwdata   ;
wire    [31:0]          s_apb3_rx_prdata   ;
wire                    s_apb3_rx_pslverror;

wire                            io_asyncResetn;

//--------------------------------------------------------------------------------------------------------------------------//
// Behave
//--------------------------------------------------------------------------------------------------------------------------//
assign phy_rstn                  = 1'b0;
assign q0_FPGA_DIV2_CLK_io       = q0_FPGA_DIV2_CLK;

// EP reset
assign q0_USER_PHY_RESET_N       = 1'b1;
assign q0_USER_RESET_N_IN        = 1'b1;
assign q0_RESET_ACK              = q0_RESET_REQ;
assign q0_USER_AXI_RESET_N       = 1'b1;

// EP
assign q0_CONFIG_READ_DATA       = '0;
assign q0_CONFIG_READ_DATA_PAR   = '0;
assign q0_CONFIG_READ_DATA_VALID = '0;
assign q0_CORRECTABLE_ERROR_IN   = '0;
assign q0_UNCORRECTABLE_ERROR_IN = '0;


// Assign H2C/C2H int to IntA
assign q0_INTA_IN                = h2c_interrupt | c2h_interrupt;
assign q0_INTB_IN                = '0;
assign q0_INTC_IN                = '0;
assign q0_INTD_IN                = '0;
assign q0_INT_PENDING_STATUS     = '0;
assign q0_TARGET_NON_POSTED_REJ  = '0;
reg   [3:0]   testcnt;

// FLR
assign q0_FLR_DONE               = '0;

// Reset

localparam [1:0]    IDLE        = 2'b00,
                    CFG_START   = 2'b01,
                    CFG_DONE    = 2'b11;

reg 	[1:0]   cfg_st, cfg_next;
reg 	[7:0]   cfg_count;
reg     [7:0]   rst_delay_cnt ;
//Reset and PLL
assign io_asyncResetn = ddr1_pll_locked;
assign u1_ddr_ARSTN_0 = (cfg_st == CFG_DONE);

always@(posedge axi_clk or negedge io_asyncResetn)
begin
    if(!io_asyncResetn) begin
        cfg_st <= IDLE;
        cfg_count <= 'h0;
    end 
    else begin
            cfg_st <= cfg_next;

            if (cfg_st == IDLE)
                cfg_count <= cfg_count + 1'b1;
            else 
                cfg_count <= 'h0;
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
        if(u1_cfg_done)
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

always @(posedge axi_clk or negedge io_asyncResetn)
begin
	if(~io_asyncResetn) begin
		rst_delay_cnt <= 0;
	end 
	else if(cfg_next == CFG_DONE) begin
		if(~rst_delay_cnt[7]) rst_delay_cnt <= rst_delay_cnt + 1;
	end 
end 

assign u1_cfg_start  = (cfg_st != IDLE);
assign u1_cfg_reset    = (cfg_st == IDLE);
assign u1_cfg_sel    = 1'b0;

//lpddr4 start_config end


always@(posedge axiclk)
begin
    if (in_user == 1'b0) begin
        user_reset_r <= 16'hffff;
    end else begin
        user_reset_r[0] <= 1'b0;
        user_reset_r[15:1] <= user_reset_r[14:0];
    end
end

assign user_reset = user_reset_r[15];

// Int ACK
always@(posedge axiclk or posedge user_reset)
begin
    if (user_reset == 1'b1) begin
        int_ack_r0 <= 1'b0;
        int_ack_r1 <= 1'b0;
    end else begin
        int_ack_r0 <= q0_INT_ACK;
        int_ack_r1 <= int_ack_r0;
    end
end

// Int counter
always@(posedge axiclk or posedge user_reset)
begin
    if (user_reset == 1'b1)
        int_ack_cnt <= 'h0;
    else if ((int_ack_r0 == 1'b1) && (int_ack_r1 == 1'b0))
        int_ack_cnt <= int_ack_cnt + 6'h1;
    else 
        int_ack_cnt <= int_ack_cnt;
end

//-------------------------------------------------------------------------------------------------------------------
// PCIE APB configuration through VIO                                                                                                       
//-------------------------------------------------------------------------------------------------------------------
apb_ctrl i_q0_apb
( 
    // Loacal user interface
    .apb_clk         ( apbclk                 ),
    .rstn            ( rstn_vio               ),
    .start           ( q0_apb_start           ),
    .paddr_test      ( q0_paddr_test          ),
    .pwdata_test     ( q0_pwdata_vio          ),
    .pwdata_par_test ( q0_pwdata_par_vio      ),
    .write_i         ( q0_write_vio           ), 
    .prdata_test     ( q0_prdata_test         ),
    .pstates_obs     ( q0_obs_pstates         ),    
    .done            ( q0_apb_done            ),

    // APB interface
    .paddr           ( q0_USER_APB_PADDR      ),  
    .psel            ( q0_USER_APB_PSEL       ),  
    .penable         ( q0_USER_APB_PENABLE    ),  
    .pwrite          ( q0_USER_APB_PWRITE     ),  
    .pwdata          ( q0_USER_APB_PWDATA     ),  
    .pwdata_par      ( q0_USER_APB_PWDATA_PAR ),  
    .pstrb           ( q0_USER_APB_PSTRB      ),  
    .pstrb_par       ( q0_USER_APB_PSTRB_PAR  ),  
    .prdata          ( q0_USER_APB_PRDATA     ),  
    .pready          ( q0_USER_APB_PREADY     ),  
    .pslverr         ( q0_USER_APB_PSLVERR    )   
);                                                

//-------------------------------------------------------------------------------------------------------------------
// Bar0 -> AXI Target MM -> Cfg DMA axi lite interface
//-------------------------------------------------------------------------------------------------------------------

always@(posedge axiclk)
begin
    if (m0_axi_awvalid == 1'b1) begin
        m0_aw_byte_idx     <= m0_axi_awaddr[4:0];
    end
end

always@(posedge axiclk) 
begin
    if (m0_axi_arvalid == 1'b1) begin
        m0_ar_byte_idx     <= m0_axi_araddr[4:0];
    end
end
  
assign m0_axi_awready = s_cfg_axil_awready;
assign m0_axi_wready  = s_cfg_axil_wready;
assign m0_axi_bvalid  = s_cfg_axil_bvalid;
assign m0_axi_bresp   = s_cfg_axil_bresp;
assign m0_axi_bid     = s_cfg_axil_awid;
assign m0_axi_arready = s_cfg_axil_arready;
assign m0_axi_rlast   = s_cfg_axil_rvalid;
assign m0_axi_rdata   = ({224'h0, s_cfg_axil_rdata} << (m0_ar_byte_idx * 8));
assign m0_axi_rresp   = s_cfg_axil_rresp;
assign m0_axi_rvalid  = s_cfg_axil_rvalid;
assign m0_axi_rid     = s_cfg_axil_arid;
                           
assign s_cfg_axil_awaddr     = m0_axi_awaddr[31:0];
assign s_cfg_axil_awprot     = 3'h0;
assign s_cfg_axil_awvalid    = m0_axi_awvalid;
assign s_cfg_axil_wdata      = {(m0_axi_wdata >> (m0_aw_byte_idx * 8))}[31:0];
assign s_cfg_axil_wstrb      = {(m0_axi_wstrb >> m0_aw_byte_idx)}[3:0];
assign s_cfg_axil_wvalid     = m0_axi_wvalid;
assign s_cfg_axil_bready     = m0_axi_bready;
assign s_cfg_axil_araddr     = m0_axi_araddr[31:0];
assign s_cfg_axil_arprot     = 3'h0;
assign s_cfg_axil_arvalid    = m0_axi_arvalid;
assign s_cfg_axil_rready     = m0_axi_rready;

//-------------------------------------------------------------------------------------------------------------------
// Bar2 -> AXI Target MM -> Cfg systerrm reg axi lite interface
//-------------------------------------------------------------------------------------------------------------------
always@(posedge axiclk)
begin
    if (m1_axi_awvalid == 1'b1) begin
        m1_aw_byte_idx     <= m1_axi_awaddr[4:0];
    end
end

always@(posedge axiclk) 
begin
    if (m1_axi_arvalid == 1'b1) begin
        m1_ar_byte_idx     <= m1_axi_araddr[4:0];
    end
end
  
assign m1_axi_awready = s_cfg1_axil_awready;
assign m1_axi_wready  = s_cfg1_axil_wready;
assign m1_axi_bvalid  = s_cfg1_axil_bvalid;
assign m1_axi_bresp   = s_cfg1_axil_bresp;
assign m1_axi_bid     = s_cfg1_axil_awid;
assign m1_axi_arready = s_cfg1_axil_arready;
assign m1_axi_rlast   = s_cfg1_axil_rvalid;
assign m1_axi_rdata   = ({224'h0, s_cfg1_axil_rdata} << (m1_ar_byte_idx * 8));
assign m1_axi_rresp   = s_cfg1_axil_rresp;
assign m1_axi_rvalid  = s_cfg1_axil_rvalid;
assign m1_axi_rid     = s_cfg1_axil_arid;
                           
assign s_cfg1_axil_awaddr     = m1_axi_awaddr[31:0];
assign s_cfg1_axil_awprot     = 3'h0;
assign s_cfg1_axil_awvalid    = m1_axi_awvalid;
assign s_cfg1_axil_wdata      = {(m1_axi_wdata >> (m1_aw_byte_idx * 8))}[31:0];
assign s_cfg1_axil_wstrb      = {(m1_axi_wstrb >> m1_aw_byte_idx)}[3:0];
assign s_cfg1_axil_wvalid     = m1_axi_wvalid;
assign s_cfg1_axil_bready     = m1_axi_bready;
assign s_cfg1_axil_araddr     = m1_axi_araddr[31:0];
assign s_cfg1_axil_arprot     = 3'h0;
assign s_cfg1_axil_arvalid    = m1_axi_arvalid;
assign s_cfg1_axil_rready     = m1_axi_rready;

//-------------------------------------------------------------------------------------------------------------------
// Bar2 -> AXI lit -> apb systerrm reg apb  interface
//-------------------------------------------------------------------------------------------------------------------
axil2apb3 (
    .s_axil_awvalid  (s_cfg1_axil_awvalid  ),
    .s_axil_awready  (s_cfg1_axil_awready  ),
    .s_axil_awaddr   (s_cfg1_axil_awaddr   ),
    .s_axil_awprot   (s_cfg1_axil_awprot   ),
    .s_axil_wvalid   (s_cfg1_axil_wvalid   ),
    .s_axil_wready   (s_cfg1_axil_wready   ),
    .s_axil_wdata    (s_cfg1_axil_wdata    ),
    .s_axil_wstrb    (s_cfg1_axil_wstrb    ),
    .s_axil_bvalid   (s_cfg1_axil_bvalid   ),
    .s_axil_bready   (s_cfg1_axil_bready   ),
    .s_axil_bresp    (s_cfg1_axil_bresp    ),
    .s_axil_arvalid  (s_cfg1_axil_arvalid  ),
    .s_axil_arready  (s_cfg1_axil_arready  ),
    .s_axil_araddr   (s_cfg1_axil_araddr   ),
    .s_axil_arprot   (s_cfg1_axil_arprot   ),
    .s_axil_rvalid   (s_cfg1_axil_rvalid   ),
    .s_axil_rready   (s_cfg1_axil_rready   ),
    .s_axil_rdata    (s_cfg1_axil_rdata    ),
    .s_axil_rresp    (s_cfg1_axil_rresp    ),
    .m_apb3_PADDR    (s_apb3_rx_paddr    ),
    .m_apb3_PSEL     (s_apb3_rx_psel     ),
    .m_apb3_PENABLE  (s_apb3_rx_penable  ),
    .m_apb3_PREADY   (s_apb3_rx_pready   ),
    .m_apb3_PWRITE   (s_apb3_rx_pwrite   ),
    .m_apb3_PWDATA   (s_apb3_rx_pwdata   ),
    .m_apb3_PRDATA   (s_apb3_rx_prdata   ),
    .m_apb3_PSLVERROR(s_apb3_rx_pslverror),
    .clk             (axiclk             ),
    .reset           (user_reset          )
);

systerm_reg#(
    .ADDR_WTH                           (12                                 ) 
)systerm_reg(
    .s_apb3_clk                         (axiclk                             ),
    .s_apb3_rstn                        (~user_reset                            ),
    .s_apb3_0_paddr                     (s_apb3_rx_paddr                     ),
    .s_apb3_0_psel                      (s_apb3_rx_psel                      ),
    .s_apb3_0_penable                   (s_apb3_rx_penable                   ),
    .s_apb3_0_pready                    (s_apb3_rx_pready                    ),
    .s_apb3_0_pwrite                    (s_apb3_rx_pwrite                    ), 
    .s_apb3_0_pwdata                    (s_apb3_rx_pwdata                    ),
    .s_apb3_0_prdata                    (s_apb3_rx_prdata                    ),
    .s_apb3_0_pslverror                 (s_apb3_rx_pslverror                 ),
    .s_apb3_1_paddr                     (12'b0                     ),
    .s_apb3_1_psel                      (1'b0                      ),
    .s_apb3_1_penable                   (1'b0                   ),
    .s_apb3_1_pready                    (s_apb3_1_pready                    ),
    .s_apb3_1_pwrite                    (1'b0                    ), 
    .s_apb3_1_pwdata                    (32'b0                    ),
    .s_apb3_1_prdata                    (s_apb3_1_prdata                    ),
    .s_apb3_1_pslverror                 (s_apb3_1_pslverror                 ),
//Cfg Space Registers
//tx_pkt_gen config reg
    .pkt_gen_en                         (pkt_gen_en                         ),
    .pkt_len                            (pkt_len                            ),
    .pkt_sta                            (pkt_sta                            ),
    .frame_len                          (frame_len                          ),
    .frameIntv                          (frameIntv                          ),
    .pky_gen_busy                       (pky_gen_busy                       ),
//lpddr4 wr config reg

    .lpdr_wr_en                         (lpdr_wr_en                         ),
    .lpdr_wr_busy                       (lpdr_wr_busy                       ),
    .c_saddr_h                          (c_saddr_h                          ),
    .c_saddr_l                          (c_saddr_l                          ),
    .c_eaddr_h                          (c_eaddr_h                          ),
    .c_eaddr_l                          (c_eaddr_l                          ),
    .h_saddr_h                          (h_saddr_h                          ),
    .h_saddr_l                          (h_saddr_l                          ),
    .h_eaddr_h                          (h_eaddr_h                          ),
    .h_eaddr_l                          (h_eaddr_l                          ),
    .desc_src_addr                      (desc_src_addr                      ),
    .desc_dst_addr                      (desc_dst_addr                      ),
    .desc_len                           (desc_len                           ),
    .desc_wr_ready                      (desc_wr_ready                      ),
    .desc_wr_valid                      (desc_wr_valid                      ),
    .c2h_desc_byp_ctl                   ( c2h_desc_byp_ctl                  ),
    .c2h_desc_byp_dst_addr              ( c2h_desc_byp_dst_addr             ),
    .c2h_desc_byp_src_addr              ( c2h_desc_byp_src_addr             ),
    .c2h_desc_byp_len                   ( c2h_desc_byp_len                  ),
    .c2h_desc_byp_load                  ( c2h_desc_byp_load                 ),
    .c2h_desc_byp_ready                 ( c2h_desc_byp_ready                ),   

//lpddr4 rd config reg

    .desc_rd_ready                      (desc_rd_ready                      ),
    .desc_rd_valid                      (desc_rd_valid                      ),
    .rd_saddr_h                         (rd_saddr_h                         ),
    .rd_saddr_l                         (rd_saddr_l                         ),
    .rd_size                            (rd_size                            ),

//rx chk config reg
    .check_sum                          (check_sum                          ),
    .error_sum                          (error_sum                          ),
    .check_data_clear                   (check_data_clear                   )

);

assign rd_saddr = {rd_saddr_h,rd_saddr_l};

lpddr_rd #(
    .DATA_WTH                           (256                                ) 
)u_lpddr_rd(
//Globle Signals                                                                 
    .clk                                (axiclk                             ),
    .rstn                               (~user_reset                             ),
//systerm reg Source Interface                                          
    .desc_valid                         (desc_rd_valid                      ),
    .desc_ready                         (desc_rd_ready                      ),
    .saddr_i                            (rd_saddr                           ),
    .size_i                             (rd_size                            ),
    .m_axi_arvalid                      (user_m_axi_arvalid                 ),
    .m_axi_arready                      (user_m_axi_arready                 ),
    .m_axi_araddr                       (user_m_axi_araddr                  ),    
    .m_axi_arlen                        (user_m_axi_arlen                   ),
    .m_axi_rvalid                       (user_m_axi_rvalid                  ),
    .m_axi_rready                       (user_m_axi_rready                  ),
    .m_axi_rdata                        (user_m_axi_rdata                   ),
    .m_axi_rlast                        (user_m_axi_rlast                   ),
    .src_axis_tready                    (rx_src_axis_tready                 ),
    .src_axis_tdata                     (rx_src_axis_tdata                  ),
    .src_axis_tvalid                    (rx_src_axis_tvalid                 ),
    .src_axis_tlast                     (rx_src_axis_tlast                  )        
);

/*always@(posedge axiclk or posedge user_reset)
begin
    if (user_reset == 1'b1) begin
        testcnt <= 4'b0;
    end else begin
        testcnt <= testcnt + 1; 
    end
end
assign rx_src_axis_tready = testcnt[3];*/

lpddr4_wr#(
.AXI_BURST  (256)
)u_lpddr4_wr(

.clk           (axiclk),
.rstn          (~user_reset ),
.base_addr     ({c_saddr_h,c_saddr_l}),
.addr_space    ({c_eaddr_h,c_eaddr_l}),//in bytes.
.s_axis_tvalid (rx_src_axis_tvalid),
.s_axis_tdata  (rx_src_axis_tdata),
.s_axis_tlast  (rx_src_axis_tlast),
.s_axis_tready (rx_src_axis_tready),
.m_axi_awid    (user_m_axi_awid),
.m_axi_awvalid (user_m_axi_awvalid),
.m_axi_awaddr  (user_m_axi_awaddr),
.m_axi_awregion(),
.m_axi_awlen   (user_m_axi_awlen  ),
.m_axi_awsize  (user_m_axi_awsize ),
.m_axi_awburst (user_m_axi_awburst),
.m_axi_awprot  (user_m_axi_awprot ),
.m_axi_awlock  (user_m_axi_awlock ),
.m_axi_awcache (user_m_axi_awcache),
.m_axi_awready (user_m_axi_awready),
.m_axi_wvalid  (user_m_axi_wvalid ),
.m_axi_wdata   (user_m_axi_wdata  ),
.m_axi_wstrb   (user_m_axi_wstrb  ),
.m_axi_wlast   (user_m_axi_wlast  ),
.m_axi_wready  (user_m_axi_wready ),
.m_axi_bid     (user_m_axi_bid    ),
.m_axi_bresp   (user_m_axi_bresp  ),
.m_axi_bvalid  (user_m_axi_bvalid ),
.m_axi_bready  (user_m_axi_bready ),
.update_addr   (desc_src_addr),
.update_en     (desc_wr_valid)
);


/*rx_pkt_check u_rx_pkt_check(
//Globle Signals                                                             
    .clk                                (axiclk                             ),
    .rstn                               (~user_reset                            ),
//systerm reg Source Interface                                               
    .sink_axis_tvalid                   (rx_src_axis_tvalid                 ),
    .sink_axis_tready                   (rx_src_axis_tready                 ),
    .sink_axis_tdata                    (rx_src_axis_tdata                  ),
    .sink_axis_tlast                    (rx_src_axis_tlast                  ), 
//AXI rd addr channl                                                         
    .check_data_clear                   (check_data_clear                   ),
    .err_int                            (err_int                            ),
    .check_sum                          (check_sum                          ),
    .error_sum                          (error_sum                          )

);*/

/*axi_adapter#(
    .AXI_AW                             (64                             ),
    .S_AXI_DW                           (256                             ),
    .M_AXI_DW                           (512                                ),
    .ASYNC                              ( 1'b1                              ),
    .FAMILY                             ( "TITANIUM"                        )
)
ddr_rd_axi_adapter(

//Slave AXI4 Bus Interface
//--Global Signals
//--Slave Global Signals
    .s_axi_clk                          (axiclk                             ),
    .s_axi_rstn                         (~user_reset                        ),
//--Slave AXI4 Write
    .s_axi_awvalid                      (user_m_axi_awvalid                 ),
    .s_axi_awready                      (user_m_axi_awready                 ),
    .s_axi_awaddr                       (user_m_axi_awaddr                  ),
    .s_axi_awlen                        (user_m_axi_awlen                   ),
    .s_axi_wvalid                       (user_m_axi_wvalid                  ),
    .s_axi_wready                       (user_m_axi_wready                  ),
    .s_axi_wdata                        (user_m_axi_wdata                   ),
    .s_axi_wstrb                        (user_m_axi_wstrb                   ),
    .s_axi_wlast                        (user_m_axi_wlast                   ),
    .s_axi_bvalid                       (user_m_axi_bvalid                  ),
    .s_axi_bready                       (user_m_axi_bready                  ),
    .s_axi_bresp                        (user_m_axi_bresp                   ),
//--Slave AXI4 Read                 
    .s_axi_arvalid                      (user_m_axi_arvalid                 ),
    .s_axi_arready                      (user_m_axi_arready                 ),
    .s_axi_araddr                       (user_m_axi_araddr                  ),
    .s_axi_arlen                        (user_m_axi_arlen                   ),
    .s_axi_rvalid                       (user_m_axi_rvalid                  ),
    .s_axi_rready                       (user_m_axi_rready                  ),
    .s_axi_rdata                        (user_m_axi_rdata                   ),
    .s_axi_rlast                        (user_m_axi_rlast                   ),

//Master AXI4 Bus Interface
//--Master Global Signals
    .m_axi_clk                          (axi_clk                        ),
    .m_axi_rstn                         (~user_reset                    ),
//--Master AXI4 Bus Write 
    .m_axi_awvalid                      (u1_ddr_AWVALID_0               ),
    .m_axi_awready                      (u1_ddr_AWREADY_0               ),
    .m_axi_awaddr                       (u1_ddr_AWADDR_0                ),
    .m_axi_awlen                        (u1_ddr_AWID_0                  ),
    .m_axi_awid                         (u1_ddr_AWLEN_0                 ),
    .m_axi_awsize                       (u1_ddr_AWSIZE_0                ),
    .m_axi_awburst                      (u1_ddr_AWBURST_0               ),
    .m_axi_awlock                       (u1_ddr_AWLOCK_0                ),
    .m_axi_awcache                      (u1_ddr_AWCACHE_0               ),
    .m_axi_wvalid                       (u1_ddr_WVALID_0                ),
    .m_axi_wready                       (u1_ddr_WREADY_0                ),
    .m_axi_wdata                        (u1_ddr_WDATA_0                 ),
    .m_axi_wstrb                        (u1_ddr_WSTRB_0                 ),
    .m_axi_wlast                        (u1_ddr_WLAST_0                 ),
    .m_axi_bvalid                       (u1_ddr_BVALID_0                ),
    .m_axi_bready                       (u1_ddr_BREADY_0                ),
    .m_axi_bid                          (u1_ddr_BID_0                   ),
    .m_axi_bresp                        (u1_ddr_BRESP_0                 ),
//--Master AXI4 Bus Read 
    .m_axi_arvalid                      (u1_ddr_ARVALID_0               ),
    .m_axi_arready                      (u1_ddr_ARREADY_0               ),
    .m_axi_araddr                       (u1_ddr_ARADDR_0                ),
    .m_axi_arlen                        (u1_ddr_ARLEN_0                 ),
    .m_axi_arid                         (u1_ddr_ARID_0                  ),
    .m_axi_arsize                       (u1_ddr_ARSIZE_0                ),
    .m_axi_arburst                      (u1_ddr_ARBURST_0               ),
    .m_axi_arlock                       (u1_ddr_ARLOCK_0                ),
    .m_axi_rvalid                       (u1_ddr_RVALID_0                ),
    .m_axi_rready                       (u1_ddr_RREADY_0                ),
    .m_axi_rdata                        (u1_ddr_RDATA_0                 ),
    .m_axi_rid                          (u1_ddr_RID_0                   ),
    .m_axi_rresp                        (u1_ddr_RRESP_0                 ),
    .m_axi_rlast                        (u1_ddr_RLAST_0                 )

);*/

genvar dut_target_axi_par;
generate
    begin : GEN_TARGET_AXI_PARITY
        for(dut_target_axi_par = 0; dut_target_axi_par < 32; dut_target_axi_par = dut_target_axi_par + 1) begin : FOR_DATA_PARITY
            always@(*)
            begin
                q0_TARGET_AXI_RDATA_PAR[dut_target_axi_par] = `DB_PCIE_ODD_EVEN_SELECT ? ~(^q0_TARGET_AXI_RDATA[8 * dut_target_axi_par + 7 -:8]) : (^q0_TARGET_AXI_RDATA[8 * dut_target_axi_par + 7 -:8]);
            end
        end
    
        always@(*)
        begin
            q0_TARGET_AXI_BID_PAR   = `DB_PCIE_ODD_EVEN_SELECT ? ~^(q0_TARGET_AXI_BID ) : ^(q0_TARGET_AXI_BID );
            q0_TARGET_AXI_BRESP_PAR = `DB_PCIE_ODD_EVEN_SELECT ? ~^(q0_TARGET_AXI_BRESP) : ^(q0_TARGET_AXI_BRESP);
            q0_TARGET_AXI_RID_PAR   = `DB_PCIE_ODD_EVEN_SELECT ? ~^(q0_TARGET_AXI_RID ) : ^(q0_TARGET_AXI_RID );
            q0_TARGET_AXI_RRESP_PAR = `DB_PCIE_ODD_EVEN_SELECT ? ~^(q0_TARGET_AXI_RRESP) : ^(q0_TARGET_AXI_RRESP);
        end
    end
endgenerate
/*assign q0_TARGET_AXI_BID_PAR = 0;
assign q0_TARGET_AXI_BRESP_PAR = 0;
assign q0_TARGET_AXI_RID_PAR =0;
assign q0_TARGET_AXI_RRESP_PAR =0;
assign q0_TARGET_AXI_RDATA_PAR =0;*/

s_axi4_bus#(
    .M0_BASE_ADDR                       (64'h0                                  ),
    .M0_ADDR_SPACE                      (64'h80000                               ),
    .M1_BASE_ADDR                       (64'ha0000                         ),
    .M1_ADDR_SPACE                      (64'h1000                               ),
    .M2_BASE_ADDR                       (64'h90000                          ),
    .M2_ADDR_SPACE                      (64'h1000                         )
)u_s_axi4_bus(
//Globle Signals
    .axi_clk                            (axiclk                           ),
    .axi_rstn                           (~user_reset                            ),
    .s_axi_awid                         (q0_TARGET_AXI_AWID                     ),
    .s_axi_awvalid                      (q0_TARGET_AXI_AWVALID                  ),
    .s_axi_awaddr                       (q0_TARGET_AXI_AWADDR                   ),
    .s_axi_awlen                        (q0_TARGET_AXI_AWLEN                    ),
    .s_axi_awsize                       (q0_TARGET_AXI_AWSIZE                   ),
    .s_axi_awready                      (q0_TARGET_AXI_AWREADY                  ),   
 

    .s_axi_wvalid                       (q0_TARGET_AXI_WVALID                   ),
    .s_axi_wdata                        (q0_TARGET_AXI_WDATA                    ),
    .s_axi_wstrb                        (q0_TARGET_AXI_WSTRB                    ),
    .s_axi_wlast                        (q0_TARGET_AXI_WLAST                    ),
    .s_axi_wready                       (q0_TARGET_AXI_WREADY                   ),
    .s_axi_bid                          (q0_TARGET_AXI_BID                      ),
    .s_axi_bresp                        (q0_TARGET_AXI_BRESP                    ),
    .s_axi_bvalid                       (q0_TARGET_AXI_BVALID                   ),
    .s_axi_bready                       (q0_TARGET_AXI_BREADY                   ),
//--Slave AXI4 Read
    .s_axi_arid                         (q0_TARGET_AXI_ARID                     ),
    .s_axi_arvalid                      (q0_TARGET_AXI_ARVALID                  ),
    .s_axi_araddr                       (q0_TARGET_AXI_ARADDR                   ),
    .s_axi_arready                      (q0_TARGET_AXI_ARREADY                  ),
    .s_axi_arlen                        (q0_TARGET_AXI_ARLEN                    ),
    .s_axi_arsize                       (q0_TARGET_AXI_ARSIZE                   ),

  
    .s_axi_rid                          (q0_TARGET_AXI_RID                      ),
    .s_axi_rvalid                       (q0_TARGET_AXI_RVALID                   ),
    .s_axi_rdata                        (q0_TARGET_AXI_RDATA                    ),
    .s_axi_rlast                        (q0_TARGET_AXI_RLAST                    ),
    .s_axi_rresp                        (q0_TARGET_AXI_RRESP                    ),
    .s_axi_rready                       (q0_TARGET_AXI_RREADY                   ),
//Master AXI4 Bus 0 Interface
//--Master AXI4 Write
    .m0_axi_awid                        (m0_axi_awid                            ),
    .m0_axi_awvalid                     (m0_axi_awvalid                         ),
    .m0_axi_awaddr                      (m0_axi_awaddr                          ),
    .m0_axi_awlen                       (m0_axi_awlen                           ),
    .m0_axi_awsize                      (m0_axi_awsize                          ),
    .m0_axi_awready                     (m0_axi_awready                         ),
    .m0_axi_wvalid                      (m0_axi_wvalid                          ),
    .m0_axi_wdata                       (m0_axi_wdata                           ),
    .m0_axi_wstrb                       (m0_axi_wstrb                           ),
    .m0_axi_wlast                       (m0_axi_wlast                           ),
    .m0_axi_wready                      (m0_axi_wready                          ),
    .m0_axi_bid                         (m0_axi_bid                             ),
    .m0_axi_bresp                       (m0_axi_bresp                           ),
    .m0_axi_bvalid                      (m0_axi_bvalid                          ),
    .m0_axi_bready                      (m0_axi_bready                          ),
//--Master AXI4 Read
    .m0_axi_arid                        (m0_axi_arid                            ),
    .m0_axi_arvalid                     (m0_axi_arvalid                         ),
    .m0_axi_araddr                      (m0_axi_araddr                          ),
    .m0_axi_arlen                       (m0_axi_arlen                           ),
    .m0_axi_arsize                      (m0_axi_arsize                          ),
    .m0_axi_arready                     (m0_axi_arready                         ),
    .m0_axi_rid                         (m0_axi_rid                             ),
    .m0_axi_rvalid                      (m0_axi_rvalid                          ),
    .m0_axi_rdata                       (m0_axi_rdata                           ),
    .m0_axi_rlast                       (m0_axi_rlast                           ),
    .m0_axi_rresp                       (m0_axi_rresp                           ),
    .m0_axi_rready                      (m0_axi_rready                          ),
//Master AXI4 Bus 1 Interface
//--Master AXI4 Write
    .m1_axi_awid                        (m1_axi_awid                            ),
    .m1_axi_awvalid                     (m1_axi_awvalid                         ),
    .m1_axi_awaddr                      (m1_axi_awaddr                          ),
    .m1_axi_awlen                       (m1_axi_awlen                           ),
    .m1_axi_awsize                      (m1_axi_awsize                          ),
    .m1_axi_awready                     (m1_axi_awready                         ),
    .m1_axi_wvalid                      (m1_axi_wvalid                          ),
    .m1_axi_wdata                       (m1_axi_wdata                           ),
    .m1_axi_wstrb                       (m1_axi_wstrb                           ),
    .m1_axi_wlast                       (m1_axi_wlast                           ),
    .m1_axi_wready                      (m1_axi_wready                          ),
    .m1_axi_bid                         (m1_axi_bid                             ),
    .m1_axi_bresp                       (m1_axi_bresp                           ),
    .m1_axi_bvalid                      (m1_axi_bvalid                          ),
    .m1_axi_bready                      (m1_axi_bready                          ),
//--Master AXI4 Read
    .m1_axi_arid                        (m1_axi_arid                            ),
    .m1_axi_arvalid                     (m1_axi_arvalid                         ),
    .m1_axi_araddr                      (m1_axi_araddr                          ),
    .m1_axi_arlen                       (m1_axi_arlen                           ),
    .m1_axi_arsize                      (m1_axi_arsize                          ),
    .m1_axi_arready                     (m1_axi_arready                         ),
    .m1_axi_rid                         (m1_axi_rid                             ),
    .m1_axi_rvalid                      (m1_axi_rvalid                          ),
    .m1_axi_rdata                       (m1_axi_rdata                           ),
    .m1_axi_rlast                       (m1_axi_rlast                           ),
    .m1_axi_rresp                       (m1_axi_rresp                           ),
    .m1_axi_rready                      (m1_axi_rready                          ),
//Master AXI4 Bus 2 Interface
//--Master AXI4 Write
    .m2_axi_awid                        (m2_axi_awid                            ),
    .m2_axi_awvalid                     (m2_axi_awvalid                         ),
    .m2_axi_awaddr                      (m2_axi_awaddr                          ),
    .m2_axi_awlen                       (m2_axi_awlen                           ),
    .m2_axi_awsize                      (m2_axi_awsize                          ),
    .m2_axi_awready                     (m2_axi_awready                         ),
    .m2_axi_wvalid                      (m2_axi_wvalid                          ),
    .m2_axi_wdata                       (m2_axi_wdata                           ),
    .m2_axi_wstrb                       (m2_axi_wstrb                           ),
    .m2_axi_wlast                       (m2_axi_wlast                           ),
    .m2_axi_wready                      (m2_axi_wready                          ),
    .m2_axi_bid                         (m2_axi_bid                             ),
    .m2_axi_bresp                       (m2_axi_bresp                           ),
    .m2_axi_bvalid                      (m2_axi_bvalid                          ),
    .m2_axi_bready                      (m2_axi_bready                          ),
//--Master AXI4 Read
    .m2_axi_arid                        (m2_axi_arid                            ),
    .m2_axi_arvalid                     (m2_axi_arvalid                         ),
    .m2_axi_araddr                      (m2_axi_araddr                          ),
    .m2_axi_arlen                       (m2_axi_arlen                           ),
    .m2_axi_arsize                      (m2_axi_arsize                          ),
    .m2_axi_arready                     (m2_axi_arready                         ),
    .m2_axi_rid                         (m2_axi_rid                             ),
    .m2_axi_rvalid                      (m2_axi_rvalid                          ),
    .m2_axi_rdata                       (m2_axi_rdata                           ),
    .m2_axi_rlast                       (m2_axi_rlast                           ),
    .m2_axi_rresp                       (m2_axi_rresp                           ),
    .m2_axi_rready                      (m2_axi_rready                          ) 
);





//-------------------------------------------------------------------------------------------------------------------
// DMA                                                                                                               
//-------------------------------------------------------------------------------------------------------------------
dma_ip_wrap dma_inst 
(
    //---------------------------------------------------------------------------------------------------------------
    //-- AXI Global
    //---------------------------------------------------------------------------------------------------------------
    .user_clk               ( axiclk                  ),
    .user_reset             ( user_reset              ),
    .link_up                ( in_user                 ),
    .sys_rst_n              ( 1'b1                    ), 
    .axi_aresetn            (                         ), 
    
    //---------------------------------------------------------------------------------------------------------------
    // TO PCIE  --> PCIE HARD CORE AXI Slave
    //---------------------------------------------------------------------------------------------------------------
    .m_h_axi_awaddr         ( q0_MASTER_AXI_AWADDR    ),  
    .m_h_axi_awid           ( q0_MASTER_AXI_AWID      ),  
    .m_h_axi_awlen          ( q0_MASTER_AXI_AWLEN     ),  
    .m_h_axi_awsize         ( q0_MASTER_AXI_AWSIZE    ),  
    .m_h_axi_awvalid        ( q0_MASTER_AXI_AWVALID   ),  
    .m_h_axi_awready        ( q0_MASTER_AXI_AWREADY   ),
    .m_h_axi_awburst        (                         ),  
    .m_h_axi_awprot         (                         ),  
    .m_h_axi_awlock         (                         ),
    .m_h_axi_awcache        (                         ),
                                                      
    .m_h_axi_wdata          ( q0_MASTER_AXI_WDATA     ),  
    .m_h_axi_wdataeccparity ( q0_MASTER_AXI_WDATA_PAR ), 
    .m_h_axi_wstrb          ( q0_MASTER_AXI_WSTRB     ), 
    .m_h_axi_wlast          ( q0_MASTER_AXI_WLAST     ), 
    .m_h_axi_wvalid         ( q0_MASTER_AXI_WVALID    ), 
    .m_h_axi_wready         ( q0_MASTER_AXI_WREADY    ), 
                                                      
    .m_h_axi_bresp          ( q0_MASTER_AXI_BRESP     ),
    .m_h_axi_bid            ( q0_MASTER_AXI_BID       ),
    .m_h_axi_bvalid         ( q0_MASTER_AXI_BVALID    ),
    .m_h_axi_bready         ( q0_MASTER_AXI_BREADY    ),
                                                        
    .m_h_axi_arid           ( q0_MASTER_AXI_ARID      ),
    .m_h_axi_araddr         ( q0_MASTER_AXI_ARADDR    ),
    .m_h_axi_arlen          ( q0_MASTER_AXI_ARLEN     ),
    .m_h_axi_arsize         ( q0_MASTER_AXI_ARSIZE    ),
    .m_h_axi_arvalid        ( q0_MASTER_AXI_ARVALID   ),
    .m_h_axi_arready        ( q0_MASTER_AXI_ARREADY   ),
    .m_h_axi_arburst        (                         ),
    .m_h_axi_arprot         (                         ),
    .m_h_axi_arlock         (                         ),
    .m_h_axi_arcache        (                         ),
                                                      
    .m_h_axi_rid            ( q0_MASTER_AXI_RID       ),
    .m_h_axi_rdata          ( q0_MASTER_AXI_RDATA     ),
    .m_h_axi_rdataeccparity ( q0_MASTER_AXI_RDATA_PAR ),
    .m_h_axi_rresp          ( q0_MASTER_AXI_RRESP     ),
    .m_h_axi_rlast          ( q0_MASTER_AXI_RLAST     ),
    .m_h_axi_rvalid         ( q0_MASTER_AXI_RVALID    ),
    .m_h_axi_rready         ( q0_MASTER_AXI_RREADY    ),
    
    //---------------------------------------------------------------------------------------------------------------
    //-- To User --> For local AXI4-MM interface
    //---------------------------------------------------------------------------------------------------------------
    .m_c_axi_awaddr         ( m_c_axi_awaddr          ),   // output
    .m_c_axi_awid           ( m_c_axi_awid            ),   // output
    .m_c_axi_awlen          ( m_c_axi_awlen           ),   // output
    .m_c_axi_awsize         ( m_c_axi_awsize          ),   // output
    .m_c_axi_awburst        ( m_c_axi_awburst         ),   // output
    .m_c_axi_awprot         ( m_c_axi_awprot          ),   // output
    .m_c_axi_awvalid        ( m_c_axi_awvalid         ),   // output
    .m_c_axi_awready        ( m_c_axi_awready         ),   // input 
    .m_c_axi_awlock         ( m_c_axi_awlock          ),   // output
    .m_c_axi_awcache        ( m_c_axi_awcache         ),   // output
                                                      
    .m_c_axi_wdata          ( m_c_axi_wdata           ),   // output
    .m_c_axi_wdataeccparity ( m_c_axi_wdataeccparity  ),   // output
    .m_c_axi_wstrb          ( m_c_axi_wstrb           ),   // output
    .m_c_axi_wlast          ( m_c_axi_wlast           ),   // output
    .m_c_axi_wvalid         ( m_c_axi_wvalid          ),   // output
    .m_c_axi_wready         ( m_c_axi_wready          ),   // input 
                                                      
    .m_c_axi_bresp          ( m_c_axi_bresp           ),   // input 
    .m_c_axi_bid            ( m_c_axi_bid             ),   // input 
    .m_c_axi_bvalid         ( m_c_axi_bvalid          ),   // input 
    .m_c_axi_bready         ( m_c_axi_bready          ),   // output
                                                      
    .m_c_axi_arid           ( m_c_axi_arid            ),   // output
    .m_c_axi_araddr         ( m_c_axi_araddr          ),   // output
    .m_c_axi_arlen          ( m_c_axi_arlen           ),   // output
    .m_c_axi_arsize         ( m_c_axi_arsize          ),   // output
    .m_c_axi_arburst        ( m_c_axi_arburst         ),   // output
    .m_c_axi_arprot         ( m_c_axi_arprot          ),   // output
    .m_c_axi_arvalid        ( m_c_axi_arvalid         ),   // output
    .m_c_axi_arready        ( m_c_axi_arready         ),   // input 
    .m_c_axi_arlock         ( m_c_axi_arlock          ),   // output
    .m_c_axi_arcache        ( m_c_axi_arcache         ),   // output
                                                      
    .m_c_axi_rid            ( m_c_axi_rid             ),   // input 
    .m_c_axi_rdata          ( m_c_axi_rdata           ),   // input 
    .m_c_axi_rdataeccparity ( m_c_axi_rdataeccparity  ),   // input 
    .m_c_axi_rresp          ( m_c_axi_rresp           ),   // input 
    .m_c_axi_rlast          ( m_c_axi_rlast           ),   // input 
    .m_c_axi_rvalid         ( m_c_axi_rvalid          ),   // input 
    .m_c_axi_rready         ( m_c_axi_rready          ),   // output
    
    //---------------------------------------------------------------------------------------------------------------
    // AXI-Lite Slave interface <-- From Target AXI MM (from pcie)
    //---------------------------------------------------------------------------------------------------------------
    .s_cfg_axil_awaddr      ( s_cfg_axil_awaddr       ),
    .s_cfg_axil_awprot      ( s_cfg_axil_awprot       ),
    .s_cfg_axil_awvalid     ( s_cfg_axil_awvalid      ),
    .s_cfg_axil_awready     ( s_cfg_axil_awready      ),
    .s_cfg_axil_wdata       ( s_cfg_axil_wdata        ),
    .s_cfg_axil_wstrb       ( s_cfg_axil_wstrb        ),
    .s_cfg_axil_wvalid      ( s_cfg_axil_wvalid       ),
    .s_cfg_axil_wready      ( s_cfg_axil_wready       ),
    .s_cfg_axil_bvalid      ( s_cfg_axil_bvalid       ),
    .s_cfg_axil_bresp       ( s_cfg_axil_bresp        ),
    .s_cfg_axil_bready      ( s_cfg_axil_bready       ),
    .s_cfg_axil_araddr      ( s_cfg_axil_araddr       ),
    .s_cfg_axil_arprot      ( s_cfg_axil_arprot       ),
    .s_cfg_axil_arvalid     ( s_cfg_axil_arvalid      ),
    .s_cfg_axil_arready     ( s_cfg_axil_arready      ),
    .s_cfg_axil_rdata       ( s_cfg_axil_rdata        ),
    .s_cfg_axil_rresp       ( s_cfg_axil_rresp        ),
    .s_cfg_axil_rvalid      ( s_cfg_axil_rvalid       ),
    .s_cfg_axil_rready      ( s_cfg_axil_rready       ),
    
    //---------------------------------------------------------------------------------------------------------------
    // sts
    //---------------------------------------------------------------------------------------------------------------
    .h2c_running            ( h2c_running             ),
    .h2c_busy               ( h2c_busy                ),
    .h2c_interrupt          ( h2c_interrupt           ),
    .c2h_running            ( c2h_running             ),
    .c2h_busy               ( c2h_busy                ),
    .c2h_interrupt          ( c2h_interrupt           )
);

axi_ram axi_ram_inst1
(
    .clk           ( axiclk               ),
    .rst           ( user_reset           ),
                                          
    .s_axi_awaddr  ( user_m_axi_awaddr[14:0] ),
    .s_axi_awid    ( user_m_axi_awid         ), 
    .s_axi_awlen   ( user_m_axi_awlen        ),
    .s_axi_awsize  ( user_m_axi_awsize       ),
    .s_axi_awburst ( user_m_axi_awburst      ),
    .s_axi_awprot  ( user_m_axi_awprot       ),
    .s_axi_awvalid ( user_m_axi_awvalid      ),
    .s_axi_awready ( user_m_axi_awready      ),
    .s_axi_awlock  ( user_m_axi_awlock       ),
    .s_axi_awcache ( user_m_axi_awcache      ),
    
    .s_axi_wdata   ( user_m_axi_wdata        ),
    .s_axi_wstrb   ( user_m_axi_wstrb        ),
    .s_axi_wlast   ( user_m_axi_wlast        ),
    .s_axi_wvalid  ( user_m_axi_wvalid       ),
    .s_axi_wready  ( user_m_axi_wready       ),
                             
    .s_axi_bid     ( user_m_axi_bid          ),
    .s_axi_bresp   ( user_m_axi_bresp        ),
    .s_axi_bvalid  ( user_m_axi_bvalid       ),
    .s_axi_bready  ( user_m_axi_bready       ),
    
    .s_axi_arid    ( m_c_axi_arid         ),
    .s_axi_araddr  ( m_c_axi_araddr[14:0] ),
    .s_axi_arlen   ( m_c_axi_arlen        ),
    .s_axi_arsize  ( m_c_axi_arsize       ),
    .s_axi_arburst ( m_c_axi_arburst      ),
    .s_axi_arlock  ( m_c_axi_arlock       ),
    .s_axi_arcache ( m_c_axi_arcache      ),
    .s_axi_arprot  ( m_c_axi_arprot       ),
    .s_axi_arvalid ( m_c_axi_arvalid      ),
    .s_axi_arready ( m_c_axi_arready      ),
    
    .s_axi_rid     ( m_c_axi_rid          ),
    .s_axi_rdata   ( m_c_axi_rdata        ),
    .s_axi_rresp   ( m_c_axi_rresp        ),
    .s_axi_rlast   ( m_c_axi_rlast        ),
    .s_axi_rvalid  ( m_c_axi_rvalid       ),
    .s_axi_rready  ( m_c_axi_rready       )
);  
                        

axi_ram axi_ram_inst
(
    .clk           ( axiclk               ),
    .rst           ( user_reset           ),
                                          
    .s_axi_awaddr  ( m_c_axi_awaddr[14:0] ),
    .s_axi_awid    ( m_c_axi_awid         ), 
    .s_axi_awlen   ( m_c_axi_awlen        ),
    .s_axi_awsize  ( m_c_axi_awsize       ),
    .s_axi_awburst ( m_c_axi_awburst      ),
    .s_axi_awprot  ( m_c_axi_awprot       ),
    .s_axi_awvalid ( m_c_axi_awvalid      ),
    .s_axi_awready ( m_c_axi_awready      ),
    .s_axi_awlock  ( m_c_axi_awlock       ),
    .s_axi_awcache ( m_c_axi_awcache      ),
    
    .s_axi_wdata   ( m_c_axi_wdata        ),
    .s_axi_wstrb   ( m_c_axi_wstrb        ),
    .s_axi_wlast   ( m_c_axi_wlast        ),
    .s_axi_wvalid  ( m_c_axi_wvalid       ),
    .s_axi_wready  ( m_c_axi_wready       ),
                             
    .s_axi_bid     ( m_c_axi_bid          ),
    .s_axi_bresp   ( m_c_axi_bresp        ),
    .s_axi_bvalid  ( m_c_axi_bvalid       ),
    .s_axi_bready  ( m_c_axi_bready       ),
    
    .s_axi_arid    (8'h00          ),
    .s_axi_araddr  (user_m_axi_araddr  ),
    .s_axi_arlen   (user_m_axi_arlen         ),
    .s_axi_arsize  (3'b101        ),
    .s_axi_arburst (2'b01       ),
    .s_axi_arlock  ( 2'b00       ),
    .s_axi_arcache ( 4'b0011      ),
    .s_axi_arprot  (3'b010        ),
    .s_axi_arvalid (user_m_axi_arvalid       ),
    .s_axi_arready (user_m_axi_arready       ),
    
    .s_axi_rid     (           ),
    .s_axi_rdata   (user_m_axi_rdata         ),
    .s_axi_rresp   (         ),
    .s_axi_rlast   (user_m_axi_rlast         ),
    .s_axi_rvalid  (user_m_axi_rvalid        ),
    .s_axi_rready  (user_m_axi_rready        )
); 


/*axi_ram axi_ram_inst
(
    .clk           ( axiclk               ),
    .rst           ( user_reset           ),
                                          
    .s_axi_awaddr  ( m_c_axi_awaddr[14:0] ),
    .s_axi_awid    ( m_c_axi_awid         ), 
    .s_axi_awlen   ( m_c_axi_awlen        ),
    .s_axi_awsize  ( m_c_axi_awsize       ),
    .s_axi_awburst ( m_c_axi_awburst      ),
    .s_axi_awprot  ( m_c_axi_awprot       ),
    .s_axi_awvalid ( m_c_axi_awvalid      ),
    .s_axi_awready ( m_c_axi_awready      ),
    .s_axi_awlock  ( m_c_axi_awlock       ),
    .s_axi_awcache ( m_c_axi_awcache      ),
    
    .s_axi_wdata   ( m_c_axi_wdata        ),
    .s_axi_wstrb   ( m_c_axi_wstrb        ),
    .s_axi_wlast   ( m_c_axi_wlast        ),
    .s_axi_wvalid  ( m_c_axi_wvalid       ),
    .s_axi_wready  ( m_c_axi_wready       ),
                             
    .s_axi_bid     ( m_c_axi_bid          ),
    .s_axi_bresp   ( m_c_axi_bresp        ),
    .s_axi_bvalid  ( m_c_axi_bvalid       ),
    .s_axi_bready  ( m_c_axi_bready       ),
    
    .s_axi_arid    ( m_c_axi_arid         ),
    .s_axi_araddr  ( m_c_axi_araddr[14:0] ),
    .s_axi_arlen   ( m_c_axi_arlen        ),
    .s_axi_arsize  ( m_c_axi_arsize       ),
    .s_axi_arburst ( m_c_axi_arburst      ),
    .s_axi_arlock  ( m_c_axi_arlock       ),
    .s_axi_arcache ( m_c_axi_arcache      ),
    .s_axi_arprot  ( m_c_axi_arprot       ),
    .s_axi_arvalid ( m_c_axi_arvalid      ),
    .s_axi_arready ( m_c_axi_arready      ),
    
    .s_axi_rid     ( m_c_axi_rid          ),
    .s_axi_rdata   ( m_c_axi_rdata        ),
    .s_axi_rresp   ( m_c_axi_rresp        ),
    .s_axi_rlast   ( m_c_axi_rlast        ),
    .s_axi_rvalid  ( m_c_axi_rvalid       ),
    .s_axi_rready  ( m_c_axi_rready       )
);   
*/
assign q0_MASTER_AXI_AWUSER = 'h0;
assign q0_MASTER_AXI_ARUSER = 'h0;

genvar dut_master_axi_par;
generate
    begin: GEN_MASTER_AXI_PARITY
        for(dut_master_axi_par = 0; dut_master_axi_par < 4; dut_master_axi_par = dut_master_axi_par + 1) begin : FOR_STRB_PARITY
            always@(*)
            begin
                q0_MASTER_AXI_WSTRB_PAR[dut_master_axi_par] = `DB_PCIE_ODD_EVEN_SELECT ? ~(^q0_MASTER_AXI_WSTRB[8 * dut_master_axi_par + 7 -:8]) : (^q0_MASTER_AXI_WSTRB[8 * dut_master_axi_par + 7 -:8]);
            end
        end

        for(dut_master_axi_par = 0; dut_master_axi_par < 32; dut_master_axi_par = dut_master_axi_par + 1) begin : FOR_M_C_RD_PARITY
            always@(*)
            begin
                m_c_axi_rdataeccparity[dut_master_axi_par] = `DB_PCIE_ODD_EVEN_SELECT ? ~(^m_c_axi_rdata[8 * dut_master_axi_par + 7 -:8]) : (^m_c_axi_rdata[8 * dut_master_axi_par + 7 -:8]);
            end
        end 
    end
endgenerate

//-------------------------------------------------------------------------------------------------------------------
// Debug VIO                                                                                                               
//-------------------------------------------------------------------------------------------------------------------  
edb_top edb_top_inst 
(
    .bscan_CAPTURE               ( bscan_CAPTURE           ),
    .bscan_DRCK                  ( bscan_DRCK              ),
    .bscan_RESET                 ( bscan_RESET             ),
    .bscan_RUNTEST               ( bscan_RUNTEST           ),
    .bscan_SEL                   ( bscan_SEL               ),
    .bscan_SHIFT                 ( bscan_SHIFT             ),
    .bscan_TCK                   ( bscan_TCK               ),
    .bscan_TDI                   ( bscan_TDI               ),
    .bscan_TMS                   ( bscan_TMS               ),
    .bscan_UPDATE                ( bscan_UPDATE            ),
    .bscan_TDO                   ( bscan_TDO               ),
                                                           
    .vio0_clk                    ( apbclk                  ),
    // Probe                                               
    .vio0_q0_ltssm_state         ( q0_LTSSM_STATE          ),
    .vio0_q0_link_status         ( q0_LINK_STATUS          ),
    .vio0_q0_pipe_p00_rate       ( q0_PIPE_P00_RATE        ),
    .vio0_q0_cmn_ready           ( q0_PMA_CMN_READY        ),
    .vio0_q0_debug_data_out      ( q0_DEBUG_DATA_OUT       ),
    .vio0_q0_flr_in_progress     ( q0_FLR_IN_PROGRESS      ),
    .vio0_in_user                ( in_user                 ),

    // Probe                                               
    .vio0_q0_obs_pstates         ( q0_obs_pstates          ),
    .vio0_q0_apb_done            ( q0_apb_done             ),
    .vio0_q0_prdata_test         ( q0_prdata_test          ),
    // Source                                              
    .vio0_q0_paddr_test          ( q0_paddr_test           ),
    .vio0_q0_pwdata_vio          ( q0_pwdata_vio           ),
    .vio0_q0_pwdata_par_vio      ( q0_pwdata_par_vio       ),
    .vio0_q0_write_vio           ( q0_write_vio            ),
    .vio0_q0_apb_start           ( q0_apb_start            ),
    .vio0_rstn_vio               ( rstn_vio                ),
        
    .vio1_clk                    ( axiclk                  ),
    .vio1_int_ack_cnt            ( int_ack_cnt             ),
        
    // Target Master Bus
    .la0_clk                     ( axiclk                  ),
    // Catch TARGET AXI
    /*
     .la0_q0_AXI_AWADDR           ( q0_TARGET_AXI_AWADDR    ),
     .la0_q0_AXI_AWID             ( q0_TARGET_AXI_AWID      ),
     .la0_q0_AXI_AWVALID          ( q0_TARGET_AXI_AWVALID   ),
     .la0_q0_AXI_AWREADY          ( q0_TARGET_AXI_AWREADY   ),
     .la0_q0_AXI_WDATA            ( q0_TARGET_AXI_WDATA     ),
     .la0_q0_AXI_WLAST            ( q0_TARGET_AXI_WLAST     ),
     .la0_q0_AXI_WVALID           ( q0_TARGET_AXI_WVALID    ),
     .la0_q0_AXI_WREADY           ( q0_TARGET_AXI_WREADY    ),
     .la0_q0_AXI_BRESP            ( q0_TARGET_AXI_BRESP     ),
     .la0_q0_AXI_BVALID           ( q0_TARGET_AXI_BVALID    ),
     .la0_q0_AXI_BREADY           ( q0_TARGET_AXI_BREADY    ),
     .la0_q0_AXI_ARADDR           ( q0_TARGET_AXI_ARADDR    ),
     .la0_q0_AXI_ARID             ( q0_TARGET_AXI_ARID      ),
     .la0_q0_AXI_ARVALID          ( q0_TARGET_AXI_ARVALID   ),
     .la0_q0_AXI_ARREADY          ( q0_TARGET_AXI_ARREADY   ),
     .la0_q0_AXI_RDATA            ( q0_TARGET_AXI_RDATA     ),
     .la0_q0_AXI_RLAST            ( q0_TARGET_AXI_RLAST     ),
     .la0_q0_AXI_RRESP            ( q0_TARGET_AXI_RRESP     ),
     .la0_q0_AXI_RVALID           ( q0_TARGET_AXI_RVALID    ),
     .la0_q0_AXI_RREADY           ( q0_TARGET_AXI_RREADY    ),
    */
     .la0_q0_AXI_AWADDR           ( q0_MASTER_AXI_AWADDR    ),
     .la0_q0_AXI_AWID             ( q0_MASTER_AXI_AWID      ),
     .la0_q0_AXI_AWVALID          ( q0_MASTER_AXI_AWVALID   ),
     .la0_q0_AXI_AWREADY          ( q0_MASTER_AXI_AWREADY   ),
     .la0_q0_AXI_WDATA            ( q0_MASTER_AXI_WDATA     ),
     .la0_q0_AXI_WLAST            ( q0_MASTER_AXI_WLAST     ),
     .la0_q0_AXI_WVALID           ( q0_MASTER_AXI_WVALID    ),
     .la0_q0_AXI_WREADY           ( q0_MASTER_AXI_WREADY    ),
     .la0_q0_AXI_BRESP            ( q0_MASTER_AXI_BRESP     ),
     .la0_q0_AXI_BVALID           ( q0_MASTER_AXI_BVALID    ),
     .la0_q0_AXI_BREADY           ( q0_MASTER_AXI_BREADY    ),
     .la0_q0_AXI_ARADDR           ( q0_MASTER_AXI_ARADDR    ),
     .la0_q0_AXI_ARID             ( q0_MASTER_AXI_ARID      ),
     .la0_q0_AXI_ARVALID          ( q0_MASTER_AXI_ARVALID   ),
     .la0_q0_AXI_ARREADY          ( q0_MASTER_AXI_ARREADY   ),
     .la0_q0_AXI_RDATA            ( q0_MASTER_AXI_RDATA     ),
     .la0_q0_AXI_RLAST            ( q0_MASTER_AXI_RLAST     ),
     .la0_q0_AXI_RRESP            ( q0_MASTER_AXI_RRESP     ),
     .la0_q0_AXI_RVALID           ( q0_MASTER_AXI_RVALID    ),
     .la0_q0_AXI_RREADY           ( q0_MASTER_AXI_RREADY    ),

     .la0_m0_AXI_AWADDR           ( m0_axi_awaddr    ),
     .la0_m0_AXI_AWID             ( m0_axi_awid      ),
     .la0_m0_AXI_AWVALID          ( m0_axi_awvalid   ),
     .la0_m0_AXI_AWREADY          ( m0_axi_awready   ),
     .la0_m0_AXI_WDATA            ( m0_axi_wdata     ),
     .la0_m0_AXI_WLAST            ( m0_axi_wlast     ),
     .la0_m0_AXI_WVALID           ( m0_axi_wvalid    ),
     .la0_m0_AXI_WREADY           ( m0_axi_wready    ),
     .la0_m0_AXI_BRESP            ( m0_axi_bresp     ),
     .la0_m0_AXI_BVALID           ( m0_axi_bvalid    ),
     .la0_m0_AXI_BREADY           ( m0_axi_bready    ),
     .la0_m0_AXI_ARADDR           ( m0_axi_araddr    ),
     .la0_m0_AXI_ARID             ( m0_axi_arid      ),
     .la0_m0_AXI_ARVALID          ( m0_axi_arvalid   ),
     .la0_m0_AXI_ARREADY          ( m0_axi_arready   ),
     .la0_m0_AXI_RDATA            ( m0_axi_rdata     ),
     .la0_m0_AXI_RLAST            ( m0_axi_rlast     ),
     .la0_m0_AXI_RRESP            ( m0_axi_rresp     ),
     .la0_m0_AXI_RVALID           ( m0_axi_rvalid    ),
     .la0_m0_AXI_RREADY           ( m0_axi_rready    ),

     .la0_m1_AXI_AWADDR           ( m1_axi_awaddr    ),
     .la0_m1_AXI_AWID             ( m1_axi_awid      ),
     .la0_m1_AXI_AWVALID          ( m1_axi_awvalid   ),
     .la0_m1_AXI_AWREADY          ( m1_axi_awready   ),
     .la0_m1_AXI_WDATA            ( m1_axi_wdata     ),
     .la0_m1_AXI_WLAST            ( m1_axi_wlast     ),
     .la0_m1_AXI_WVALID           ( m1_axi_wvalid    ),
     .la0_m1_AXI_WREADY           ( m1_axi_wready    ),
     .la0_m1_AXI_BRESP            ( m1_axi_bresp     ),
     .la0_m1_AXI_BVALID           ( m1_axi_bvalid    ),
     .la0_m1_AXI_BREADY           ( m1_axi_bready    ),
     .la0_m1_AXI_ARADDR           ( m1_axi_araddr    ),
     .la0_m1_AXI_ARID             ( m1_axi_arid      ),
     .la0_m1_AXI_ARVALID          ( m1_axi_arvalid   ),
     .la0_m1_AXI_ARREADY          ( m1_axi_arready   ),
     .la0_m1_AXI_RDATA            ( m1_axi_rdata     ),
     .la0_m1_AXI_RLAST            ( m1_axi_rlast     ),
     .la0_m1_AXI_RRESP            ( m1_axi_rresp     ),
     .la0_m1_AXI_RVALID           ( m1_axi_rvalid    ),
     .la0_m1_AXI_RREADY           ( m1_axi_rready    ),

     .la0_m2_AXI_AWADDR           ( user_m_axi_awaddr    ),
     .la0_m2_AXI_AWID             ( user_m_axi_awid      ),
     .la0_m2_AXI_AWVALID          ( user_m_axi_awvalid   ),
     .la0_m2_AXI_AWREADY          ( user_m_axi_awready   ),
     .la0_m2_AXI_WDATA            ( user_m_axi_wdata     ),
     .la0_m2_AXI_WLAST            ( user_m_axi_wlast     ),
     .la0_m2_AXI_WVALID           ( user_m_axi_wvalid    ),
     .la0_m2_AXI_WREADY           ( user_m_axi_wready    ),
     .la0_m2_AXI_BRESP            ( user_m_axi_bresp     ),
     .la0_m2_AXI_BVALID           ( user_m_axi_bvalid    ),
     .la0_m2_AXI_BREADY           ( user_m_axi_bready    ),
     .la0_m2_AXI_ARADDR           ( user_m_axi_araddr    ),
     .la0_m2_AXI_ARID             ( user_m_axi_arid      ),
     .la0_m2_AXI_ARVALID          ( user_m_axi_arvalid   ),
     .la0_m2_AXI_ARREADY          ( user_m_axi_arready   ),
     .la0_m2_AXI_RDATA            ( user_m_axi_rdata     ),
     .la0_m2_AXI_RLAST            ( user_m_axi_rlast     ),
     .la0_m2_AXI_RRESP            ( user_m_axi_rresp     ),
     .la0_m2_AXI_RVALID           ( user_m_axi_rvalid    ),
     .la0_m2_AXI_RREADY           ( user_m_axi_rready    ),

     .la0_adpt1_AXI_AWADDR           (m_c_axi_awaddr  ),
     .la0_adpt1_AXI_AWID             (m_c_axi_awid    ),
     .la0_adpt1_AXI_AWVALID          (m_c_axi_awvalid  ),
     .la0_adpt1_AXI_AWREADY          (m_c_axi_awready  ),
     .la0_adpt1_AXI_WDATA            (m_c_axi_wdata  ),
     .la0_adpt1_AXI_WLAST            (m_c_axi_wlast  ),
     .la0_adpt1_AXI_WVALID           (m_c_axi_wvalid ),
     .la0_adpt1_AXI_WREADY           (m_c_axi_wready ),
     .la0_adpt1_AXI_BRESP            (m_c_axi_bresp ),
     .la0_adpt1_AXI_BVALID           (m_c_axi_bvalid ),
     .la0_adpt1_AXI_BREADY           (m_c_axi_bready ),
     .la0_adpt1_AXI_ARADDR           (m_c_axi_araddr  ),
     .la0_adpt1_AXI_ARLEN            (m_c_axi_arlen  ),
     .la0_adpt1_AXI_AWLEN            (m_c_axi_awlen  ),
     .la0_adpt1_AXI_ARID             (  ),
     .la0_adpt1_AXI_ARVALID          (m_c_axi_arvalid  ),
     .la0_adpt1_AXI_ARREADY          (m_c_axi_arready  ),
     .la0_adpt1_AXI_RDATA            (m_c_axi_rdata ),
     .la0_adpt1_AXI_RLAST            (m_c_axi_rlast  ),
     .la0_adpt1_AXI_RRESP            (  ),
     .la0_adpt1_AXI_RVALID           (m_c_axi_rvalid  ),
     .la0_adpt1_AXI_RREADY           (m_c_axi_rready  ),

     .la0_adpt2_AXI_AWADDR           (  ),

     .la0_adpt2_AXI_AWID             (  ),
     .la0_adpt2_AXI_AWVALID          (rx_src_axis_tvalid  ),
     .la0_adpt2_AXI_AWREADY          (rx_src_axis_tready  ),
     .la0_adpt2_AXI_WDATA            (rx_src_axis_tdata  ),
     .la0_adpt2_AXI_WLAST            (rx_src_axis_tlast  ),
     .la0_adpt2_AXI_WVALID           (  ),
     .la0_adpt2_AXI_WREADY           (  ),
     .la0_adpt2_AXI_BRESP            (  ),
     .la0_adpt2_AXI_BVALID           (  ),
     .la0_adpt2_AXI_BREADY           (  ),
     .la0_adpt2_AXI_ARADDR           (  ),
     .la0_adpt2_AXI_ARID             (  ),
     .la0_adpt2_AXI_ARVALID          (  ),
     .la0_adpt2_AXI_ARREADY          (  ),
     .la0_adpt2_AXI_RDATA            (  ),
     .la0_adpt2_AXI_RLAST            (  ),
     .la0_adpt2_AXI_RRESP            (  ),
     .la0_adpt2_AXI_RVALID           (  ),
     .la0_adpt2_AXI_RREADY           (  ),
     

     .la0_addr_AXI_AWADDR           ( u1_ddr_AWADDR_0   ),
     .la0_addr_AXI_AWID             ( u1_ddr_AWID_0     ),
     .la0_addr_AXI_AWVALID          ( u1_ddr_AWVALID_0  ),
     .la0_addr_AXI_AWREADY          ( u1_ddr_AWREADY_0  ),
     .la0_addr_AXI_WDATA            ( desc_src_addr    ),
     .la0_addr_AXI_WLAST            ( desc_src_valid    ),
     .la0_addr_AXI_WVALID           ( u1_ddr_WVALID_0   ),
     .la0_addr_AXI_WREADY           ( u1_ddr_WREADY_0   ),
     .la0_addr_AXI_BRESP            ( u1_ddr_BRESP_0    ),
     .la0_addr_AXI_BVALID           ( u1_ddr_BVALID_0   ),
     .la0_addr_AXI_BREADY           ( u1_ddr_BREADY_0   ),
     .la0_addr_AXI_ARADDR           ( u1_ddr_ARADDR_0   ),
     .la0_addr_AXI_ARID             ( u1_ddr_ARID_0     ),
     .la0_addr_AXI_ARVALID          ( u1_ddr_ARVALID_0  ),
     .la0_addr_AXI_ARREADY          ( u1_ddr_ARREADY_0  ),
     .la0_addr_AXI_RDATA            ( u1_ddr_RDATA_0    ),
     .la0_addr_AXI_RLAST            ( u1_ddr_RLAST_0    ),
     .la0_addr_AXI_RRESP            ( u1_ddr_RRESP_0    ),
     .la0_addr_AXI_RVALID           ( u1_ddr_RVALID_0   ),
     .la0_addr_AXI_RREADY           ( u1_ddr_RREADY_0   ),

     .la0_s_apb3_rx_paddr           (s_apb3_rx_paddr    ),
     .la0_s_apb3_rx_psel            (s_apb3_rx_psel     ),
     .la0_s_apb3_rx_penable         (s_apb3_rx_penable  ),
     .la0_s_apb3_rx_pready          (s_apb3_rx_pready   ),
     .la0_s_apb3_rx_pwrite          (s_apb3_rx_pwrite   ),
     .la0_s_apb3_rx_pwdata          (s_apb3_rx_pwdata   ),
     .la0_s_apb3_rx_prdata          (s_apb3_rx_prdata   ),
     .la0_desc_rd_ready             (desc_rd_ready      ),
     .la0_desc_rd_valid             (desc_rd_valid      ),
     .la0_rd_saddr_h                (rd_saddr_h         ),
     .la0_rd_saddr_l                (rd_saddr_l         ),
     .la0_rd_size                   (rd_size            ),

     .la0_rx_src_axis_tvalid                  (rx_src_axis_tvalid                 ),
     .la0_rx_src_axis_tready                  (rx_src_axis_tready                 ),
     .la0_rx_src_axis_tdata                   (rx_src_axis_tdata                  ),
     .la0_rx_src_axis_tlast                   (rx_src_axis_tlast                  )
    

   
);

//--------------------------------------------------------------------------------------------------------------------------//
endmodule


//-------------------------------------------------------------------------------------------------------------------
// AXI4 settings
//-------------------------------------------------------------------------------------------------------------------
// AWID/ARID/BID/RID
// .Transactions from different masters have no ordering restrictions. They can complete in any order.
// .Transactions from the same master, but with different ID values, have no ordering restrictions. They can complete in any order.
// .The data transfers for a sequence of read transactions with the same ARID value must be returned in the order in which the master issued the addresses.
// .The data transfers for a sequence of write transactions with the same AWID value must complete in the order in which the master issued the addresses.
//------------------------------------------------------------------------------ 
// AxLen
// Burst length. The burst length gives the exact number of transfers in a burst.
// Burst_Length = AxLEN[7:0] + 1
//------------------------------------------------------------------------------
// AxSize[2:0]  | Bytes in transfer | Data width
// 0b000        | 1                 | 8
// 0b001        | 2                 | 16
// 0b010        | 4                 | 32
// 0b011        | 8                 | 64
// 0b100        | 16                | 128
// 0b101        | 32                | 256
// 0b110        | 64                | 512
// 0b111        | 126               | 1024
//------------------------------------------------------------------------------
// AxBurst[1:0] | Burst type 
// 0b00         | FIXED -- In a fixed burst, the address is the same for every transfer in the burst.
// 0b01         | INCR  -- In an incrementing burst, the address for each transfer in the burst is an increment of the address for the previous transfer. The increment value depends on the size of the transfer.
// 0b10         | WRAP  -- A wrapping burst is similar to an incrementing burst, except that the address wraps around to a lower address if an upper address limit is reached.
// 0b11         | Reserved
//------------------------------------------------------------------------------
// AxProt
// Protection type. This signal indicates the privilege and security level of the transaction, and whether the transaction is a data access or an instruction access.
// Bit | Value | Function
// [0] | 0     | Unprivileged access
//     | 1     | Privileged access
// [1] | 0     | Secure access
//     | 1     | Non-secure access
// [2] | 0     | Data access
//     | 1     | Instruction access
//------------------------------------------------------------------------------
// AxQos
// Quality of Service, QoS. QoS identifier sent for each read transaction.
//------------------------------------------------------------------------------ 
// AxUser
// User signal. Optionally, the AXI4 interface signal set can include a set of User-defined signals, called the User signals, on each AXI4 channel.
//------------------------------------------------------------------------------
// Write address channel settings   
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Write data channel settings  
//------------------------------------------------------------------------------
// WSTRB                         
// Write strobes. This signal indicates which byte lanes hold valid data.
// The WSTRB[n:0] signals when HIGH, specify the byte lanes of the data bus that contain valid information. There is one write strobe for each eight bits of the write data bus.
// WSTRB[n:0] <--> WDATA[(8n)+7: (8n)].
//------------------------------------------------------------------------------
// WLAST
// Write last. This signal indicates the last transfer in a write burst.
//------------------------------------------------------------------------------
 
//------------------------------------------------------------------------------ 
// Write response channel settings  
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Read address channel settings                           
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------ 
// Read data channel settings 
//------------------------------------------------------------------------------

//-------------------------------------------------------------------------------------------------------------------