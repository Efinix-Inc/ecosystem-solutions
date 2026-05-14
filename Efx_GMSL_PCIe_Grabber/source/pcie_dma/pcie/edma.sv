`include "dma/pre_define.vh"

module edma
(

input  logic         in_user,
output logic         phy_rstn,
input  logic         perst0,
// Clock
input  logic         clk_100m,
input  logic         clk_100m_rstn,
input  logic         clk_200m,
input  logic         clk_200m_rstn,
input  logic         clk_250m,
input  logic         clk_250m_rstn,   
//Master AXI4 Bus 0 Interface
output logic         q0_USER_PHY_RESET_N,
output logic         q0_USER_RESET_N_IN,
output logic         q0_RESET_ACK,
input  logic         q0_RESET_REQ,

    
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
    
// MASTER_AXI 
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

// APB Inferface 
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

//***************************edma**************************//
output logic [ 63:0] m_c_axi_awaddr        ,       
output logic [  7:0] m_c_axi_awid          ,          
output logic [  7:0] m_c_axi_awlen         ,         
output logic [  2:0] m_c_axi_awsize        ,        
output logic [  1:0] m_c_axi_awburst       ,       
output logic [  2:0] m_c_axi_awprot        ,        
output logic         m_c_axi_awvalid       , 

input  logic         m_c_axi_awready       ,    

output logic         m_c_axi_awlock        ,        
output logic [  3:0] m_c_axi_awcache       ,       
output logic [255:0] m_c_axi_wdata         ,         
output logic [ 31:0] m_c_axi_wdataeccparity,
output logic [ 31:0] m_c_axi_wstrb         ,         
output logic         m_c_axi_wlast         ,         
output logic         m_c_axi_wvalid        , 

input  logic         m_c_axi_wready        ,        
input  logic [  1:0] m_c_axi_bresp         ,         
input  logic [  7:0] m_c_axi_bid           ,           
input  logic         m_c_axi_bvalid        ,  

output logic         m_c_axi_bready        ,   
input  logic         m_c_axi_arready       ,           
output logic [  7:0] m_c_axi_arid          ,          
output logic [ 63:0] m_c_axi_araddr        ,        
output logic [  7:0] m_c_axi_arlen         ,         
output logic [  2:0] m_c_axi_arsize        ,        
output logic [  1:0] m_c_axi_arburst       ,       
output logic [  2:0] m_c_axi_arprot        ,        
output logic         m_c_axi_arvalid       ,       
     
output logic         m_c_axi_arlock         ,        
output logic [  3:0] m_c_axi_arcache        ,       
output logic [  7:0] m_c_axi_rid            ,           
input  logic [255:0] m_c_axi_rdata          ,         

input  logic [  1:0] m_c_axi_rresp          ,         
input  logic         m_c_axi_rlast          ,         
input  logic         m_c_axi_rvalid         ,        
output logic         m_c_axi_rready         , 


//***********************DEBUG*****************************//

output wire    [7:0]           m1_axi_awid    ,
output wire                    m1_axi_awvalid ,
output wire    [63:0]          m1_axi_awaddr  ,
output wire    [7:0]           m1_axi_awlen   ,
output wire    [2:0]           m1_axi_awsize  ,
output wire                    m1_axi_awready ,
output wire                    m1_axi_wvalid  ,
output wire    [255:0]         m1_axi_wdata   ,
output wire    [31:0]          m1_axi_wstrb   ,
output wire                    m1_axi_wlast   ,
output wire                    m1_axi_wready  ,
output wire    [7:0]           m1_axi_bid     ,
output wire    [1:0]           m1_axi_bresp   ,
output wire                    m1_axi_bvalid  ,
output wire                    m1_axi_bready  ,
output wire    [7:0]           m1_axi_arid    ,
output wire                    m1_axi_arvalid ,
output wire    [63:0]          m1_axi_araddr  ,
output wire    [7:0]           m1_axi_arlen   ,
output wire    [2:0]           m1_axi_arsize  ,
output wire                    m1_axi_arready ,
output wire    [7:0]           m1_axi_rid     ,
output wire                    m1_axi_rvalid  ,
output wire    [255:0]         m1_axi_rdata   ,
output wire                    m1_axi_rlast   ,
output wire    [1:0]           m1_axi_rresp   ,
output wire                    m1_axi_rready  ,


//************************rd********************************//
input  logic         m_axi_arready           ,
output logic [63:0]  m_axi_araddr            ,
output logic [7:0]   m_axi_arlen             ,
output logic         m_axi_arvalid           ,
//AXI rd data channl
input  logic          m_axi_rvalid            ,
input  logic [64-1:0] m_axi_rdata             ,
input  logic          m_axi_rlast             ,
output logic          m_axi_rready            ,

output logic [7:0]    m_axi_awid              ,
output logic          m_axi_awvalid           ,
output logic [63:0]   m_axi_awaddr            ,
output logic [3:0]    m_axi_awregion          ,
output logic [7:0]    m_axi_awlen             ,
output logic [2:0]    m_axi_awsize            ,
output logic [1:0]    m_axi_awburst           ,
output logic [2:0]    m_axi_awprot            ,
output logic [1:0]    m_axi_awlock            ,
output logic [3:0]    m_axi_awcache           ,
input  logic          m_axi_awready           ,
output logic          m_axi_wvalid            ,
output logic [63:0]   m_axi_wdata             ,
output logic [7:0]    m_axi_wstrb             ,
output logic          m_axi_wlast             ,
input  logic          m_axi_wready            ,
input  logic [7:0]    m_axi_bid               ,
input  logic [1:0]    m_axi_bresp             ,
input  logic          m_axi_bvalid            ,
output logic          m_axi_bready            ,

input  logic          tx_src_axis_tready         ,
output logic [63:0]   tx_src_axis_tdata          ,
output logic          tx_src_axis_tvalid         ,
output logic          tx_src_axis_tlast          ,

output logic          rx_src_axis_tready         ,
input  logic [63:0]   rx_src_axis_tdata          ,
input  logic          rx_src_axis_tvalid         ,
input  logic          rx_src_axis_tlast          ,


//abp3 slave interface for system to communicate with board Logic. 
 input   [7:0]     Board_status,
 output  [31:0]	   master_Control_Input_A,
 input   [31:0]	   master_Control_Status_A,
 output  [31:0]	   master_Control_Input_B,
 input   [31:0]	   master_Control_Status_B,
 output  [31:0]	   master_Control_Input_C,
 input   [31:0]	   master_Control_Status_C,

//APB3 Slave Interface
output wire  [9:0]    mac_l2_apb3_paddr,
output wire           mac_l2_apb3_psel,
output wire           mac_l2_apb3_penable,
input  wire           mac_l2_apb3_pready,
output wire           mac_l2_apb3_pwrite,//0:rd; 1:wr;
output wire  [31:0]   mac_l2_apb3_pwdata,
input  wire  [31:0]   mac_l2_apb3_prdata,
input  wire           mac_l2_apb3_pslverror,  
//vio
input  logic          rstn_vio         ,
input  logic          q0_apb_start     ,
input  logic [ 23:0]  q0_paddr_test    ,
input  logic [ 31:0]  q0_pwdata_vio    ,
input  logic [  3:0]  q0_pwdata_par_vio,
input  logic          q0_write_vio     ,
output logic [  3:0]  q0_obs_pstates   ,
output logic  [31:0]  q0_prdata_test   , 
output logic          q0_apb_done      




    );


//--------------------------------------------------------------------------------------------------------------------------//
// Signals
//--------------------------------------------------------------------------------------------------------------------------//
localparam COMPILE_DATE    = 16'h1010;
localparam AXI_DW          = `DW;
localparam DMA_DSC_BYP     = `DSC_BYP;
localparam DMA_CHANNEL_NUM = `CHANNEL_NUM;
localparam DMA_ST_MODE     = `ST_MODE;


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
logic [ 31:0] m_c_axi_rdataeccparity ;




//parameter                       AXI_DW =256;
parameter                       AXI_AW = 64;
parameter                       AXI_SW = (AXI_DW/8);
parameter                       ID_WIDTH = 8;
parameter                       AWUSER_WIDTH = 1;
parameter                       WUSER_WIDTH = 1;
parameter                       BUSER_WIDTH = 1;
parameter                       ARUSER_WIDTH = 1;
parameter                       RUSER_WIDTH = 1;

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

logic         dscbyp_flag;

logic [  AXI_DW*DMA_CHANNEL_NUM - 1:0] m_axis_h2c_tdata;   
logic [AXI_DW*DMA_CHANNEL_NUM/8 - 1:0] m_axis_h2c_tparity; 
logic [         DMA_CHANNEL_NUM - 1:0] m_axis_h2c_tlast;    
logic [         DMA_CHANNEL_NUM - 1:0] m_axis_h2c_tvalid;  
logic [AXI_DW*DMA_CHANNEL_NUM/8 - 1:0] m_axis_h2c_tkeep;   
logic [         DMA_CHANNEL_NUM - 1:0] m_axis_h2c_tready;  

logic [  AXI_DW*DMA_CHANNEL_NUM - 1:0] s_axis_c2h_tdata;   
logic [AXI_DW*DMA_CHANNEL_NUM/8 - 1:0] s_axis_c2h_tparity; 
logic [         DMA_CHANNEL_NUM - 1:0] s_axis_c2h_tlast;    
logic [         DMA_CHANNEL_NUM - 1:0] s_axis_c2h_tvalid;  
logic [AXI_DW*DMA_CHANNEL_NUM/8 - 1:0] s_axis_c2h_tkeep;   
logic [         DMA_CHANNEL_NUM - 1:0] s_axis_c2h_tready; 

logic         h2c_dsc_byp_ready;   
logic [ 63:0] h2c_dsc_byp_dst_addr;
logic [ 63:0] h2c_dsc_byp_src_addr;
logic [ 27:0] h2c_dsc_byp_len;     
logic [ 15:0] h2c_dsc_byp_ctl;     
logic         h2c_dsc_byp_load;    

logic         c2h_dsc_byp_ready;   
logic [ 63:0] c2h_dsc_byp_dst_addr;
logic [ 63:0] c2h_dsc_byp_src_addr;
logic [ 27:0] c2h_dsc_byp_len;     
logic [ 15:0] c2h_dsc_byp_ctl;     
logic         c2h_dsc_byp_load; 

logic [31:0] dma_mode; 


wire                  desc_rd_ready           ;
wire                  desc_rd_valid           ;
wire  [63:0]          rd_saddr                ;
wire  [27:0]          rd_size                 ;
wire  [31:0]          rd_saddr_h              ;
wire  [31:0]          rd_saddr_l              ;
wire                    wr_rstn;


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

//wire    [7:0]           m1_axi_awid    ;
//wire                    m1_axi_awvalid ;
//wire    [63:0]          m1_axi_awaddr  ;
//wire    [7:0]           m1_axi_awlen   ;
//wire    [2:0]           m1_axi_awsize  ;
//wire                    m1_axi_awready ;
//wire                    m1_axi_wvalid  ;
//wire    [255:0]         m1_axi_wdata   ;
//wire    [31:0]          m1_axi_wstrb   ;
//wire                    m1_axi_wlast   ;
//wire                    m1_axi_wready  ;
//wire    [7:0]           m1_axi_bid     ;
//wire    [1:0]           m1_axi_bresp   ;
//wire                    m1_axi_bvalid  ;
//wire                    m1_axi_bready  ;
//wire    [7:0]           m1_axi_arid    ;
//wire                    m1_axi_arvalid ;
//wire    [63:0]          m1_axi_araddr  ;
//wire    [7:0]           m1_axi_arlen   ;
//wire    [2:0]           m1_axi_arsize  ;
//wire                    m1_axi_arready ;
//wire    [7:0]           m1_axi_rid     ;
//wire                    m1_axi_rvalid  ;
//wire    [255:0]         m1_axi_rdata   ;
//wire                    m1_axi_rlast   ;
//wire    [1:0]           m1_axi_rresp   ;
//wire                    m1_axi_rready  ;

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

wire    [31:0]          ex_apb3_rx_paddr    ;
wire                    ex_apb3_rx_psel     ;
wire                    ex_apb3_rx_penable  ;
wire                    ex_apb3_rx_pready   ;
wire                    ex_apb3_rx_pwrite   ;//0:rd; 1:wr;
wire    [31:0]          ex_apb3_rx_pwdata   ;
wire    [31:0]          ex_apb3_rx_prdata   ;
wire                    ex_apb3_rx_pslverror;

wire                            io_asyncResetn;
wire                    axi_clk;
wire                    axiclk;
wire                    apbclk;
wire    [63:0]          desc_src_addr;
wire                    desc_wr_valid;

wire    [31:0]          c_saddr_h              ;
wire    [31:0]          c_saddr_l              ;
wire    [31:0]          c_eaddr_h              ;
wire    [31:0]          c_eaddr_l              ;
wire    [31:0]          h_saddr_h              ;
wire    [31:0]          h_saddr_l              ;
wire    [31:0]          h_eaddr_h              ;
wire    [31:0]          h_eaddr_l              ;

reg     [ 15:0]                 user_reset_r;
reg                             link_up;
reg                             link_up_asyn_dly1;
reg                             link_up_asyn_dly2;
reg                             link_up_asyn_dly3;
reg     [3:0]                   count; 
reg                             perstn_asyn_dly1;
reg                             perstn_asyn_dly2;
reg                             perstn_asyn_dly3;
wire                            pcie_config;


wire pcie_apb_delayer; //To delay the apb signal based on the linkup status

//--------------------------------------------------------------------------------------------------------------------------//
// Behave
//--------------------------------------------------------------------------------------------------------------------------//
assign axi_clk = clk_200m;
assign axiclk  = clk_250m;
assign apbclk  = clk_100m;

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

assign pcie_apb_delayer = (q0_LINK_STATUS == 2'b10) || (q0_LINK_STATUS == 2'b11) ? 1'b1 : 1'b0; 
// Reset

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
/*
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
*/

localparam RAM_ADDR_W	    = 3;
localparam ROM_DEPTH		= 5;
localparam PADDR_WIDTH		= 24;
localparam PDATA_WIDTH		= 32;
localparam L0_STATE         = 6'h10;
localparam COUNT_THRESHOLD  = 4'd10;

always @ (posedge clk_250m , negedge clk_250m_rstn )
begin
    if(clk_250m_rstn == 1'b0 )begin
        count   <= 4'h0;
        link_up <= 1'b0;
    end else begin
        if(q0_LTSSM_STATE == L0_STATE) begin
            // LTSSM state is 0x10, increment counter
            if(count != COUNT_THRESHOLD ) begin
                count   <= count + 1'b1;
                link_up <= 1'b0;          // Not yet 10 cycles
            end else begin
                link_up <= 1'b1;          // Counter has reached 10, assert l0
            end
        end else begin // LTSSM state is not 0x10, reset counter and deassert l0
            count   <= 4'h0;
            link_up <= 1'b0;        
        end    
    end
end

always @(posedge clk_100m , negedge clk_100m_rstn)
begin
    if(clk_100m_rstn == 1'b0) begin
        link_up_asyn_dly1 <= 1'b0;
        link_up_asyn_dly2 <= 1'b0;
        link_up_asyn_dly3 <= 1'b0;
    end else begin
        link_up_asyn_dly1 <= link_up;
        link_up_asyn_dly2 <= link_up_asyn_dly1;
        link_up_asyn_dly3 <= link_up_asyn_dly2;
    end
end

always @(posedge clk_100m , negedge clk_100m_rstn)
begin
    if(clk_100m_rstn == 1'b0) begin
        perstn_asyn_dly1 <= 1'b0;
        perstn_asyn_dly2 <= 1'b0;
        perstn_asyn_dly3 <= 1'b0;
    end else begin
        perstn_asyn_dly1 <= perst0;
        perstn_asyn_dly2 <= perstn_asyn_dly1;
        perstn_asyn_dly3 <= perstn_asyn_dly2;
    end
end

assign pcie_config = link_up_asyn_dly3 & perstn_asyn_dly3;


pcie_apb_master #(
	.ROM_MIF				            ("efx_pcie_rom_mif.mem"             ),
	.ROM_DEPTH			                (ROM_DEPTH                          ),
	.RAM_ADDR_W			                (RAM_ADDR_W                         ),
	.PADDR_WIDTH		                (PADDR_WIDTH                        ),
	.PDATA_WIDTH		                (PDATA_WIDTH                        )
) q1_pcie_apb_master(    
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
    
	.PSEL					            (q0_USER_APB_PSEL                   ),
	.PWRITE				                (q0_USER_APB_PWRITE                 ),
	.PENABLE				            (q0_USER_APB_PENABLE                ),
	.PADDR				                (q0_USER_APB_PADDR                  ),
	.PWDATA				                (q0_USER_APB_PWDATA                 ),
	.PWDATA_PAR				            (q0_USER_APB_PWDATA_PAR             ),
    .PSTRB                              (q0_USER_APB_PSTRB                  ),  
    .PSTRB_PAR                          (q0_USER_APB_PSTRB_PAR              ),      
	.PCLK					            (apbclk                             ),
	.PRESETn				            (pcie_config                   ), // (pcie_apb_delayer                   ),                     //(q0_apb_start                       ),
	.PRDATA				                (q0_USER_APB_PRDATA                 ),
	.PREADY				                (q0_USER_APB_PREADY                 ),
	.PSLVERR				            (q0_USER_APB_PSLVERR                )
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
  
/*assign m1_axi_awready = s_cfg1_axil_awready;
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
);*/

axi2apb3 u_axi2apb3(
  .s_axi_awvalid    (m1_axi_awvalid ),
  .s_axi_awready    (m1_axi_awready ),
  .s_axi_awaddr     (m1_axi_awaddr  ),
  .s_axi_awregion   (m1_axi_awregion),
  .s_axi_awlen      (m1_axi_awlen   ),
  .s_axi_awsize     (m1_axi_awsize  ),
  .s_axi_awlock     (m1_axi_awlock  ),
  .s_axi_awcache    (m1_axi_awcache ),
  .s_axi_awqos      (m1_axi_awqos   ),
  .s_axi_awprot     (m1_axi_awprot  ),
  .s_axi_wvalid     (m1_axi_wvalid  ),
  .s_axi_wready     (m1_axi_wready  ),
  .s_axi_wdata      (m1_axi_wdata   ),
  .s_axi_wstrb      (m1_axi_wstrb   ),
  .s_axi_wlast      (m1_axi_wlast   ),
  .s_axi_bvalid     (m1_axi_bvalid  ),
  .s_axi_bready     (m1_axi_bready  ),
  .s_axi_bresp      (m1_axi_bresp   ),
  .s_axi_arvalid    (m1_axi_arvalid ),
  .s_axi_arready    (m1_axi_arready ),
  .s_axi_araddr     (m1_axi_araddr  ),
  .s_axi_arregion   (m1_axi_arregion),
  .s_axi_arlen      (m1_axi_arlen   ),
  .s_axi_arsize     (m1_axi_arsize  ),
  .s_axi_arlock     (m1_axi_arlock  ),
  .s_axi_arcache    (m1_axi_arcache ),
  .s_axi_arqos      (m1_axi_arqos   ),
  .s_axi_arprot     (m1_axi_arprot  ),
  .s_axi_rvalid     (m1_axi_rvalid  ),
  .s_axi_rready     (m1_axi_rready  ),
  .s_axi_rdata      (m1_axi_rdata   ),
  .s_axi_rresp      (m1_axi_rresp   ),
  .s_axi_rlast      (m1_axi_rlast   ),
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
//assign s_apb3_rx_pready    = ex_apb3_rx_pready   ;
//assign s_apb3_rx_prdata    = ex_apb3_rx_prdata   ;
//assign s_apb3_rx_pslverror = ex_apb3_rx_pslverror;

assign s_apb3_rx_pready    = (s_apb3_rx_paddr[12] == 1'b0) ? ex_apb3_rx_pready    :  mac_l2_apb3_pready   ;
assign s_apb3_rx_prdata    = (s_apb3_rx_paddr[12] == 1'b0) ? ex_apb3_rx_prdata    :  mac_l2_apb3_prdata   ;
assign s_apb3_rx_pslverror = (s_apb3_rx_paddr[12] == 1'b0) ? ex_apb3_rx_pslverror :  mac_l2_apb3_pslverror;

assign ex_apb3_rx_paddr   = s_apb3_rx_paddr[11:0];
assign ex_apb3_rx_psel    = (s_apb3_rx_paddr[12] == 1'b0) ? s_apb3_rx_psel : 1'b0;
assign ex_apb3_rx_penable = s_apb3_rx_penable;
assign ex_apb3_rx_pwrite  = s_apb3_rx_pwrite;
assign ex_apb3_rx_pwdata  = s_apb3_rx_pwdata;

//assign s_apb3_rx_pready    = mac_l2_apb3_pready   ;
//assign s_apb3_rx_prdata    = mac_l2_apb3_prdata   ;
//assign s_apb3_rx_pslverror = mac_l2_apb3_pslverror;

assign mac_l2_apb3_paddr   = s_apb3_rx_paddr[9:0];
assign mac_l2_apb3_psel    = (s_apb3_rx_paddr[12] == 1'b1) ? s_apb3_rx_psel : 1'b0;
//assign mac_l2_apb3_psel    = s_apb3_rx_psel ;
assign mac_l2_apb3_penable = s_apb3_rx_penable;
assign mac_l2_apb3_pwrite  = s_apb3_rx_pwrite;
assign mac_l2_apb3_pwdata  = s_apb3_rx_pwdata;


systerm_reg#(
    .ADDR_WTH                           (12                                 ) 
)systerm_reg(
    .s_apb3_clk                         (axiclk                             ),
    .s_apb3_rstn                        (~user_reset                            ),
    .s_apb3_0_paddr                     (ex_apb3_rx_paddr                     ),
    .s_apb3_0_psel                      (ex_apb3_rx_psel                      ),
    .s_apb3_0_penable                   (ex_apb3_rx_penable                   ),
    .s_apb3_0_pready                    (ex_apb3_rx_pready                    ),
    .s_apb3_0_pwrite                    (ex_apb3_rx_pwrite                    ), 
    .s_apb3_0_pwdata                    (ex_apb3_rx_pwdata                    ),
    .s_apb3_0_prdata                    (ex_apb3_rx_prdata                    ),
    .s_apb3_0_pslverror                 (ex_apb3_rx_pslverror                 ),
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
    .wr_rstn                            (wr_rstn),
//lpddr4 rd config reg

    .desc_rd_ready                      (desc_rd_ready                      ),
    .desc_rd_valid                      (desc_rd_valid                      ),
    .rd_saddr_h                         (rd_saddr_h                         ),
    .rd_saddr_l                         (rd_saddr_l                         ),
    .rd_size                            (rd_size                            ),

//rx chk config reg
    .check_sum                          (check_sum                          ),
    .error_sum                          (error_sum                          ),
    .check_data_clear                   (check_data_clear                   ),
    
    //abp3 slave interface for system to communicate with board Logic. 
     .Board_status(Board_status),
     .master_Control_Input_A(master_Control_Input_A),
     .master_Control_Status_A(master_Control_Status_A),
     .master_Control_Input_B(master_Control_Input_B),
     .master_Control_Status_B(master_Control_Status_B),
     .master_Control_Input_C(master_Control_Input_C),
     .master_Control_Status_C(master_Control_Status_C)

);

assign rd_saddr = {rd_saddr_h,rd_saddr_l};

lpddr_rd #(
    .DATA_WTH                           (64                                ) 
)u_lpddr_rd(
//Globle Signals                                                                 
    .clk                                (axiclk                             ),
    .rstn                               (~user_reset                             ),
//systerm reg Source Interface                                          
    .desc_valid                         (desc_rd_valid                      ),
    .desc_ready                         (desc_rd_ready                      ),
    .saddr_i                            (rd_saddr                           ),
    .size_i                             (rd_size                            ),
    .m_axi_arvalid                      (m_axi_arvalid                 ),
    .m_axi_arready                      (m_axi_arready                 ),
    .m_axi_araddr                       (m_axi_araddr                  ),    
    .m_axi_arlen                        (m_axi_arlen                   ),
    .m_axi_rvalid                       (m_axi_rvalid                  ),
    .m_axi_rready                       (m_axi_rready                  ),
    .m_axi_rdata                        (m_axi_rdata                   ),
    .m_axi_rlast                        (m_axi_rlast                   ),
    .src_axis_tready                    (tx_src_axis_tready                 ),
    .src_axis_tdata                     (tx_src_axis_tdata                  ),
    .src_axis_tvalid                    (tx_src_axis_tvalid                 ),
    .src_axis_tlast                     (tx_src_axis_tlast                  )        
);

lpddr4_wr#(
.AXI_BURST  (256)
)u_lpddr4_wr(

.clk           (axiclk),
.rstn          ((~user_reset  )&&(wr_rstn) ),
.base_addr     ({c_saddr_h,c_saddr_l}),
.addr_space    ({c_eaddr_h,c_eaddr_l}),//in bytes.
.s_axis_tvalid (rx_src_axis_tvalid),
.s_axis_tdata  (rx_src_axis_tdata),
.s_axis_tlast  (rx_src_axis_tlast),
.s_axis_tready (rx_src_axis_tready),
.m_axi_awid    (m_axi_awid),
.m_axi_awvalid (m_axi_awvalid),
.m_axi_awaddr  (m_axi_awaddr),
.m_axi_awregion(),
.m_axi_awlen   (m_axi_awlen     ),
.m_axi_awsize  (m_axi_awsize    ),
.m_axi_awburst (m_axi_awburst   ),
.m_axi_awprot  (m_axi_awprot    ),
.m_axi_awlock  (m_axi_awlock    ),
.m_axi_awcache (m_axi_awcache   ),
.m_axi_awready (m_axi_awready   ),
.m_axi_wvalid  (m_axi_wvalid    ),
.m_axi_wdata   (m_axi_wdata     ),
.m_axi_wstrb   (m_axi_wstrb     ),
.m_axi_wlast   (m_axi_wlast     ),
.m_axi_wready  (m_axi_wready    ),
.m_axi_bid     (m_axi_bid       ),
.m_axi_bresp   (m_axi_bresp     ),
.m_axi_bvalid  (m_axi_bvalid    ),
.m_axi_bready  (m_axi_bready    ),
.update_addr   (desc_src_addr),
.update_en     (desc_wr_valid)
);


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

s_axi4_bus#(
    .M0_BASE_ADDR                       (64'h0                                  ),
    .M0_ADDR_SPACE                      (64'h80000                               ),
    .M1_BASE_ADDR                       (64'ha0000                         ),
    .M1_ADDR_SPACE                      (64'h200000000                              ),
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


`ifdef DISABLE_DSC_BYPASS_MODE
    assign dscbyp_flag = 1'b0;
`else                  
    assign dscbyp_flag = 1'b1;
`endif


// Set DMA mode
// AXI DATA WIDTH 4'h0: 64bit, 4'h1: 128bit, 4'h2: 256bit, 4'h3:  512bit, 4'hf: error!
assign dma_mode[ 3: 0] = (AXI_DW == 64) ? 4'h0 : ((AXI_DW == 128) ? 4'h1 : ((AXI_DW == 256) ? 4'h2 : ((AXI_DW == 512) ? 4'h3 : 4'hf)));
// DSC BYPASS MODE
assign dma_mode[ 7: 4] = DMA_DSC_BYP;
// Channel number
assign dma_mode[11: 8] = DMA_CHANNEL_NUM;
// ST mode
assign dma_mode[15:12] = DMA_ST_MODE;
// Date
assign dma_mode[31:16] = COMPILE_DATE;

//-------------------------------------------------------------------------------------------------------------------
// DMA                                                                                                               
//-------------------------------------------------------------------------------------------------------------------
dma_ip_wrap 
#(
    .C_H2C_NUM_CHNL      ( DMA_CHANNEL_NUM ),
    .C_C2H_NUM_CHNL      ( DMA_CHANNEL_NUM ),
    .DSC_BYPASS_RD       ( DMA_DSC_BYP     ),
    .DSC_BYPASS_WR       ( DMA_DSC_BYP     ),
    .C_M_AXI_DATA_WIDTH  ( AXI_DW          ),
    .C_M_AXIS_DATA_WIDTH ( AXI_DW          ),
    .C_S_AXIS_DATA_WIDTH ( AXI_DW          ),
    .DMA_ST              ( DMA_ST_MODE     ))
dma_ip_wrap_inst
(
    //---------------------------------------------------------------------------------------------------------------
    //-- AXI Global
    //---------------------------------------------------------------------------------------------------------------
    .user_clk                  ( axiclk                    ),
    .user_reset                ( user_reset                ),
    .link_up                   ( in_user                   ),
    .sys_rst_n                 ( 1'b1                      ), 
    .axi_aresetn               (                           ), 
    
    //---------------------------------------------------------------------------------------------------------------
    // TO PCIE  --> PCIE HARD CORE AXI Slave
    //---------------------------------------------------------------------------------------------------------------
    .m_h_axi_awaddr            ( q0_MASTER_AXI_AWADDR      ),  
    .m_h_axi_awid              ( q0_MASTER_AXI_AWID        ),  
    .m_h_axi_awlen             ( q0_MASTER_AXI_AWLEN       ),  
    .m_h_axi_awsize            ( q0_MASTER_AXI_AWSIZE      ),  
    .m_h_axi_awvalid           ( q0_MASTER_AXI_AWVALID     ),  
    .m_h_axi_awready           ( q0_MASTER_AXI_AWREADY     ),
    .m_h_axi_awburst           (                           ),  
    .m_h_axi_awprot            (                           ),  
    .m_h_axi_awlock            (                           ),
    .m_h_axi_awcache           (                           ),
                                                        
    .m_h_axi_wdata             ( q0_MASTER_AXI_WDATA       ),  
    .m_h_axi_wdataeccparity    ( q0_MASTER_AXI_WDATA_PAR   ), 
    .m_h_axi_wstrb             ( q0_MASTER_AXI_WSTRB       ), 
    .m_h_axi_wlast             ( q0_MASTER_AXI_WLAST       ), 
    .m_h_axi_wvalid            ( q0_MASTER_AXI_WVALID      ), 
    .m_h_axi_wready            ( q0_MASTER_AXI_WREADY      ), 
                                                        
    .m_h_axi_bresp             ( q0_MASTER_AXI_BRESP       ),
    .m_h_axi_bid               ( q0_MASTER_AXI_BID         ),
    .m_h_axi_bvalid            ( q0_MASTER_AXI_BVALID      ),
    .m_h_axi_bready            ( q0_MASTER_AXI_BREADY      ),
                                                            
    .m_h_axi_arid              ( q0_MASTER_AXI_ARID        ),
    .m_h_axi_araddr            ( q0_MASTER_AXI_ARADDR      ),
    .m_h_axi_arlen             ( q0_MASTER_AXI_ARLEN       ),
    .m_h_axi_arsize            ( q0_MASTER_AXI_ARSIZE      ),
    .m_h_axi_arvalid           ( q0_MASTER_AXI_ARVALID     ),
    .m_h_axi_arready           ( q0_MASTER_AXI_ARREADY     ),
    .m_h_axi_arburst           (                           ),
    .m_h_axi_arprot            (                           ),
    .m_h_axi_arlock            (                           ),
    .m_h_axi_arcache           (                           ),
                                                        
    .m_h_axi_rid               ( q0_MASTER_AXI_RID         ),
    .m_h_axi_rdata             ( q0_MASTER_AXI_RDATA       ),
    .m_h_axi_rdataeccparity    ( q0_MASTER_AXI_RDATA_PAR   ),
    .m_h_axi_rresp             ( q0_MASTER_AXI_RRESP       ),
    .m_h_axi_rlast             ( q0_MASTER_AXI_RLAST       ),
    .m_h_axi_rvalid            ( q0_MASTER_AXI_RVALID      ),
    .m_h_axi_rready            ( q0_MASTER_AXI_RREADY      ),
    
    //---------------------------------------------------------------------------------------------------------------
    //-- To User --> For local AXI4-MM interface
    //---------------------------------------------------------------------------------------------------------------
    .m_c_axi_awaddr            ( m_c_axi_awaddr            ),  
    .m_c_axi_awid              ( m_c_axi_awid              ),  
    .m_c_axi_awlen             ( m_c_axi_awlen             ),  
    .m_c_axi_awsize            ( m_c_axi_awsize            ),  
    .m_c_axi_awburst           ( m_c_axi_awburst           ),  
    .m_c_axi_awprot            ( m_c_axi_awprot            ),  
    .m_c_axi_awvalid           ( m_c_axi_awvalid           ),  
    .m_c_axi_awready           ( m_c_axi_awready           ),  
    .m_c_axi_awlock            ( m_c_axi_awlock            ),  
    .m_c_axi_awcache           ( m_c_axi_awcache           ),  
                                                        
    .m_c_axi_wdata             ( m_c_axi_wdata             ),  
    .m_c_axi_wdataeccparity    ( m_c_axi_wdataeccparity    ),  
    .m_c_axi_wstrb             ( m_c_axi_wstrb             ),  
    .m_c_axi_wlast             ( m_c_axi_wlast             ),  
    .m_c_axi_wvalid            ( m_c_axi_wvalid            ),  
    .m_c_axi_wready            ( m_c_axi_wready            ),  
                                                        
    .m_c_axi_bresp             ( m_c_axi_bresp             ),  
    .m_c_axi_bid               ( m_c_axi_bid               ),  
    .m_c_axi_bvalid            ( m_c_axi_bvalid            ),  
    .m_c_axi_bready            ( m_c_axi_bready            ),  
                                                        
    .m_c_axi_arid              ( m_c_axi_arid              ),  
    .m_c_axi_araddr            ( m_c_axi_araddr            ),  
    .m_c_axi_arlen             ( m_c_axi_arlen             ),  
    .m_c_axi_arsize            ( m_c_axi_arsize            ),  
    .m_c_axi_arburst           ( m_c_axi_arburst           ),  
    .m_c_axi_arprot            ( m_c_axi_arprot            ),  
    .m_c_axi_arvalid           ( m_c_axi_arvalid           ),  
    .m_c_axi_arready           ( m_c_axi_arready           ),  
    .m_c_axi_arlock            ( m_c_axi_arlock            ),  
    .m_c_axi_arcache           ( m_c_axi_arcache           ),  
                                                        
    .m_c_axi_rid               ( m_c_axi_rid               ),  
    .m_c_axi_rdata             ( m_c_axi_rdata             ),  
    .m_c_axi_rdataeccparity    ( m_c_axi_rdataeccparity    ),  
    .m_c_axi_rresp             ( m_c_axi_rresp             ),  
    .m_c_axi_rlast             ( m_c_axi_rlast             ),  
    .m_c_axi_rvalid            ( m_c_axi_rvalid            ),  
    .m_c_axi_rready            ( m_c_axi_rready            ),  

    //---------------------------------------------------------------------------------------------------------------
    //-- To User --> For local AXI Stream interface
    //---------------------------------------------------------------------------------------------------------------
    .m_axis_h2c_tdata          ( m_axis_h2c_tdata          ),
    .m_axis_h2c_tparity        ( m_axis_h2c_tparity        ),
    .m_axis_h2c_tuser          (                           ),
    .m_axis_h2c_tlast          ( m_axis_h2c_tlast          ),
    .m_axis_h2c_tvalid         ( m_axis_h2c_tvalid         ),
    .m_axis_h2c_tkeep          ( m_axis_h2c_tkeep          ),
    .m_axis_h2c_tready         ( m_axis_h2c_tready         ),

    .s_axis_c2h_tdata          ( s_axis_c2h_tdata          ),
    .s_axis_c2h_tparity        ( s_axis_c2h_tparity        ),
    .s_axis_c2h_tlast          ( s_axis_c2h_tlast          ),
    .s_axis_c2h_tuser          ( 'h0                       ),
    .s_axis_c2h_tvalid         ( s_axis_c2h_tvalid         ),
    .s_axis_c2h_tkeep          ( s_axis_c2h_tkeep          ),
    .s_axis_c2h_tready         ( s_axis_c2h_tready         ),
    
    //---------------------------------------------------------------------------------------------------------------
    // AXI-Lite Slave interface <-- From Target AXI MM (from pcie)
    //---------------------------------------------------------------------------------------------------------------
    .s_cfg_axil_awvalid        ( s_cfg_axil_awvalid        ),
    .s_cfg_axil_awaddr         ( s_cfg_axil_awaddr         ),
    .s_cfg_axil_awprot         ( s_cfg_axil_awprot         ),
    .s_cfg_axil_awready        ( s_cfg_axil_awready        ),
    .s_cfg_axil_wvalid         ( s_cfg_axil_wvalid         ),
    .s_cfg_axil_wdata          ( s_cfg_axil_wdata          ),
    .s_cfg_axil_wstrb          ( s_cfg_axil_wstrb          ),
    .s_cfg_axil_wready         ( s_cfg_axil_wready         ),
    .s_cfg_axil_bvalid         ( s_cfg_axil_bvalid         ),
    .s_cfg_axil_bresp          ( s_cfg_axil_bresp          ),
    .s_cfg_axil_bready         ( s_cfg_axil_bready         ),
    .s_cfg_axil_arvalid        ( s_cfg_axil_arvalid        ),
    .s_cfg_axil_araddr         ( s_cfg_axil_araddr         ),
    .s_cfg_axil_arprot         ( s_cfg_axil_arprot         ),
    .s_cfg_axil_arready        ( s_cfg_axil_arready        ),
    .s_cfg_axil_rvalid         ( s_cfg_axil_rvalid         ),
    .s_cfg_axil_rdata          ( s_cfg_axil_rdata          ),
    .s_cfg_axil_rresp          ( s_cfg_axil_rresp          ),
    .s_cfg_axil_rready         ( s_cfg_axil_rready         ),
    
    //---------------------------------------------------------------------------------------------------------------
    // AXI-Lite Slave interface <-- From User logic
    //---------------------------------------------------------------------------------------------------------------
    .s_local_cfg_axil_awaddr   ( 'h0                       ),
    .s_local_cfg_axil_awprot   ( 'h0                       ),
    .s_local_cfg_axil_awvalid  ( 'h0                       ),
    .s_local_cfg_axil_awready  (                           ),
    .s_local_cfg_axil_wdata    ( 'h0                       ),
    .s_local_cfg_axil_wstrb    ( 'h0                       ),
    .s_local_cfg_axil_wvalid   ( 'h0                       ),
    .s_local_cfg_axil_wready   (                           ),
    .s_local_cfg_axil_bvalid   (                           ),
    .s_local_cfg_axil_bresp    (                           ),
    .s_local_cfg_axil_bready   ( 'h0                       ),
    .s_local_cfg_axil_araddr   ( 'h0                       ),
    .s_local_cfg_axil_arprot   ( 'h0                       ),
    .s_local_cfg_axil_arvalid  ( 'h0                       ),
    .s_local_cfg_axil_arready  (                           ),
    .s_local_cfg_axil_rdata    (                           ),
    .s_local_cfg_axil_rresp    (                           ),
    .s_local_cfg_axil_rvalid   (                           ),
    .s_local_cfg_axil_rready   ( 'h0                       ),
    
    //---------------------------------------------------------------------------------------------------------------
    // HTC descriptors bypass interface
    //---------------------------------------------------------------------------------------------------------------   
    .h2c_dsc_byp_ready         ( h2c_dsc_byp_ready         ),
    .h2c_dsc_byp_dst_addr      ( h2c_dsc_byp_dst_addr      ),
    .h2c_dsc_byp_src_addr      ( h2c_dsc_byp_src_addr      ),
    .h2c_dsc_byp_len           ( h2c_dsc_byp_len           ),
    .h2c_dsc_byp_ctl           ( h2c_dsc_byp_ctl           ),
    .h2c_dsc_byp_load          ( h2c_dsc_byp_load          ),
                                                        
    //---------------------------------------------------------------------------------------------------------------
    // CTH descriptors bypass interface
    //---------------------------------------------------------------------------------------------------------------
    .c2h_dsc_byp_ready         ( c2h_dsc_byp_ready         ),
    .c2h_dsc_byp_dst_addr      ( c2h_dsc_byp_dst_addr      ),
    .c2h_dsc_byp_src_addr      ( c2h_dsc_byp_src_addr      ),
    .c2h_dsc_byp_len           ( c2h_dsc_byp_len           ),
    .c2h_dsc_byp_ctl           ( c2h_dsc_byp_ctl           ),
    .c2h_dsc_byp_load          ( c2h_dsc_byp_load          ),
    
    //---------------------------------------------------------------------------------------------------------------
    // Interrupt
    //---------------------------------------------------------------------------------------------------------------
    .cfg_interrupt_msix_enable ( cfg_interrupt_msix_en     ),
    .cfg_interrupt_int         ( cfg_interrupt_int         ),
    .cfg_interrupt_sent        ( cfg_interrupt_sent        ),

    //---------------------------------------------------------------------------------------------------------------
    // MPS & MRRS
    //---------------------------------------------------------------------------------------------------------------    
    .cfg_max_payload_size      ( q0_PCIE_MAX_PAYLOAD_SIZE  ),
    .cfg_max_read_req_size     ( q0_PCIE_MAX_READ_REQ_SIZE ),
    
    //---------------------------------------------------------------------------------------------------------------
    // Status
    //---------------------------------------------------------------------------------------------------------------
    .h2c_running               ( h2c_running               ),
    .h2c_busy                  ( h2c_busy                  ),
    .h2c_interrupt             ( h2c_interrupt             ),
    .c2h_running               ( c2h_running               ),
    .c2h_busy                  ( c2h_busy                  ),
    .c2h_interrupt             ( c2h_interrupt             )
);     

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

endmodule
