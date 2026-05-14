`timescale 1 ns / 1 ns

`define DEBUG

module interconnect_wrapper #(
    parameter                       AXI_AW        = 32, 
    parameter                       S0_AXI_DW     = 256,
    parameter                       S1_AXI_DW     = 256,
    parameter                       S2_AXI_DW     = 256,
    parameter                       M_AXI_DW      = 512,

    parameter                       ASYNC         = 1'b1,
    parameter                       S0_AXI_REG_EN = 5'b00000,
    parameter                       M0_AXI_REG_EN = 5'b00000,
    parameter                       S1_AXI_REG_EN = 5'b00000,
    parameter                       M1_AXI_REG_EN = 5'b00000,
    parameter                       S2_AXI_REG_EN = 5'b00000,
    parameter                       M2_AXI_REG_EN = 5'b00000,
    parameter                       FAMILY        = "TITANIUM"           
)
(
input                           clk_250m,
input                           clk_250m_rstn,

input                           s0_axi_awvalid,
output  wire                    s0_axi_awready,
input           [AXI_AW-1:0]    s0_axi_awaddr,
input           [7:0]           s0_axi_awlen,
input                           s0_axi_wvalid,
output  wire                    s0_axi_wready,
input           [S0_AXI_DW-1:0] s0_axi_wdata,
input           [S0_AXI_DW/8-1:0]
                                s0_axi_wstrb,
input                           s0_axi_wlast,
output  wire                    s0_axi_bvalid,
input                           s0_axi_bready,
output  wire    [1:0]           s0_axi_bresp,
input                           s0_axi_arvalid,
output  wire                    s0_axi_arready,
input           [AXI_AW-1:0]    s0_axi_araddr,
input           [7:0]           s0_axi_arlen,
output  wire                    s0_axi_rvalid,
input                           s0_axi_rready,
output  wire    [S0_AXI_DW-1:0] s0_axi_rdata,
output  wire                    s0_axi_rlast,
output  wire    [1:0]           s0_axi_rresp,

input                           s1_axi_awvalid,
output  wire                    s1_axi_awready,
input           [AXI_AW-1:0]    s1_axi_awaddr,
input           [7:0]           s1_axi_awlen,
input                           s1_axi_wvalid,
output  wire                    s1_axi_wready,
input           [S1_AXI_DW-1:0] s1_axi_wdata,
input           [S1_AXI_DW/8-1:0]
                                s1_axi_wstrb,
input                           s1_axi_wlast,
output  wire                    s1_axi_bvalid,
input                           s1_axi_bready,
output  wire    [1:0]           s1_axi_bresp,
input                           s1_axi_arvalid,
output  wire                    s1_axi_arready,
input           [AXI_AW-1:0]    s1_axi_araddr,
input           [7:0]           s1_axi_arlen,
output  wire                    s1_axi_rvalid,
input                           s1_axi_rready,
output  wire    [S1_AXI_DW-1:0] s1_axi_rdata,
output  wire                    s1_axi_rlast,
output  wire    [1:0]           s1_axi_rresp,

input                           s2_axi_awvalid,
output  wire                    s2_axi_awready,
input           [AXI_AW-1:0]    s2_axi_awaddr,
input           [7:0]           s2_axi_awlen,
input                           s2_axi_wvalid,
output  wire                    s2_axi_wready,
input           [S2_AXI_DW-1:0] s2_axi_wdata,
input           [S2_AXI_DW/8-1:0]
                                s2_axi_wstrb,
input                           s2_axi_wlast,
output  wire                    s2_axi_bvalid,
input                           s2_axi_bready,
output  wire    [1:0]           s2_axi_bresp,
input                           s2_axi_arvalid,
output  wire                    s2_axi_arready,
input           [AXI_AW-1:0]    s2_axi_araddr,
input           [7:0]           s2_axi_arlen,
output  wire                    s2_axi_rvalid,
input                           s2_axi_rready,
output  wire    [S2_AXI_DW-1:0] s2_axi_rdata,
output  wire                    s2_axi_rlast,
output  wire    [1:0]           s2_axi_rresp,

//--AXI4 Interface For LPDDR4
input                           clk_200m,
input                           clk_200m_rstn,

input                           axi0_ARREADY,
input                           axi0_AWREADY,
input           [5:0]           axi0_BID,
input           [1:0]           axi0_BRESP,
input                           axi0_BVALID,
input           [M_AXI_DW-1:0]  axi0_RDATA,
input           [5:0]           axi0_RID,
input                           axi0_RLAST,
input           [1:0]           axi0_RRESP,
input                           axi0_RVALID,
input                           axi0_WREADY,
output  wire    [AXI_AW-1:0]    axi0_ARADDR,
output  wire                    axi0_ARAPCMD,
output  wire    [1:0]           axi0_ARBURST,
output  wire    [5:0]           axi0_ARID,
output  wire    [7:0]           axi0_ARLEN,
output  wire                    axi0_ARLOCK,
output  wire                    axi0_ARQOS,
output  wire    [2:0]           axi0_ARSIZE,
output  wire                    axi0_ARESETn,
output  wire                    axi0_ARVALID,
output  wire    [AXI_AW-1:0]    axi0_AWADDR,
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
output  wire    [M_AXI_DW-1:0]  axi0_WDATA,
output  wire                    axi0_WLAST,
output  wire    [M_AXI_DW/8-1:0]axi0_WSTRB,
output  wire                    axi0_WVALID,

output  wire                    ddr_inst_CFG_RST,    //Active-high DDR configuration controller reset.
output  wire                    ddr_inst_CFG_START,    //Start the DDR configuration controller.
input                           ddr_inst_CFG_DONE,    //Indicates the controller configuration is done
output  wire                    ddr_inst_CFG_SEL,    
output  wire                    ddr_pll_rstn 

);

//Parameter Define
parameter                       S_COUNT   = 3; 
parameter                       AXI_CNT = 1;

parameter                       S0_ASYNC  = ASYNC;
parameter                       S1_ASYNC  = ASYNC; 
parameter                       S2_ASYNC  = ASYNC; 

parameter                       S0_AXI_SW = S0_AXI_DW/8;
parameter                       S1_AXI_SW = S1_AXI_DW/8;
parameter                       S2_AXI_SW = S2_AXI_DW/8;

parameter                       M0_AXI_DW = M_AXI_DW;
parameter                       M1_AXI_DW = M_AXI_DW;
parameter                       M2_AXI_DW = M_AXI_DW;
parameter                       M0_AXI_SW = M0_AXI_DW/8;
parameter                       M1_AXI_SW = M1_AXI_DW/8;
parameter                       M2_AXI_SW = M2_AXI_DW/8;

//Register Define
reg     [1 : 0]                 ddr_cfg_ok_dly;

//Wire Define
wire                            ddr_cfg_ok ;
wire                            s0_axi_clk;
wire                            s0_axi_rstn;
wire                            s1_axi_clk;
wire                            s1_axi_rstn;
wire                            s2_axi_clk;
wire                            s2_axi_rstn;
wire                            m_axi_clk;
wire                            m_axi_rstn;

//--AXI4 Interface
wire    [AXI_CNT*AXI_AW-1:0]    m0_axi_awaddr;
wire    [AXI_CNT*8-1:0]         m0_axi_awlen;
wire    [AXI_CNT*3-1:0]         m0_axi_awsize;
wire    [AXI_CNT*2-1:0]         m0_axi_awburst;
wire    [AXI_CNT-1:0]           m0_axi_awlock;
wire    [AXI_CNT*4-1:0]         m0_axi_awcache;
wire    [AXI_CNT*3-1:0]         m0_axi_awprot;
wire    [AXI_CNT-1:0]           m0_axi_awvalid;
wire    [AXI_CNT-1:0]           m0_axi_awready;
wire    [AXI_CNT*M0_AXI_DW-1:0] m0_axi_wdata;
wire    [AXI_CNT*M0_AXI_SW-1:0] m0_axi_wstrb;
wire    [AXI_CNT-1:0]           m0_axi_wlast;
wire    [AXI_CNT-1:0]           m0_axi_wvalid;
wire    [AXI_CNT-1:0]           m0_axi_wready;
wire    [AXI_CNT*2-1:0]         m0_axi_bresp;
wire    [AXI_CNT-1:0]           m0_axi_bvalid;
wire    [AXI_CNT-1:0]           m0_axi_bready;
wire    [AXI_CNT*AXI_AW-1:0]    m0_axi_araddr;
wire    [AXI_CNT*8-1:0]         m0_axi_arlen;
wire    [AXI_CNT*3-1:0]         m0_axi_arsize;
wire    [AXI_CNT*2-1:0]         m0_axi_arburst;
wire    [AXI_CNT-1:0]           m0_axi_arlock;
wire    [AXI_CNT*4-1:0]         m0_axi_arcache;
wire    [AXI_CNT*3-1:0]         m0_axi_arprot;
wire    [AXI_CNT-1:0]           m0_axi_arvalid;
wire    [AXI_CNT-1:0]           m0_axi_arready;
wire    [AXI_CNT*M0_AXI_DW-1:0] m0_axi_rdata;
wire    [AXI_CNT*2-1:0]         m0_axi_rresp;
wire    [AXI_CNT-1:0]           m0_axi_rlast;
wire    [AXI_CNT-1:0]           m0_axi_rvalid;
wire    [AXI_CNT-1:0]           m0_axi_rready;

wire    [AXI_CNT*M0_AXI_DW-1:0] m00_axi_rdata;
wire    [AXI_CNT*2-1:0]         m00_axi_rresp;
wire    [AXI_CNT-1:0]           m00_axi_rlast;
wire    [AXI_CNT-1:0]           m00_axi_rvalid;
wire    [AXI_CNT-1:0]           m00_axi_rready;

wire    [AXI_CNT*AXI_AW-1:0]    m11_axi_awaddr;
wire    [AXI_CNT*8-1:0]         m11_axi_awlen;
wire    [AXI_CNT-1:0]           m11_axi_awvalid;

//wire    [AXI_CNT*AXI_AW-1:0]    m1_axi_awaddr;
//wire    [AXI_CNT*8-1:0]         m1_axi_awlen;
wire    [AXI_CNT*3-1:0]         m1_axi_awsize;
wire    [AXI_CNT*2-1:0]         m1_axi_awburst;
wire    [AXI_CNT-1:0]           m1_axi_awlock;
wire    [AXI_CNT*4-1:0]         m1_axi_awcache;
wire    [AXI_CNT*3-1:0]         m1_axi_awprot;
//wire    [AXI_CNT-1:0]           m1_axi_awvalid;
wire    [AXI_CNT-1:0]           m1_axi_awready;
wire    [AXI_CNT*M1_AXI_DW-1:0] m1_axi_wdata;
wire    [AXI_CNT*M1_AXI_SW-1:0] m1_axi_wstrb;
wire    [AXI_CNT-1:0]           m1_axi_wlast;
wire    [AXI_CNT-1:0]           m1_axi_wvalid;
wire    [AXI_CNT-1:0]           m1_axi_wready;

wire    [AXI_CNT*M1_AXI_DW-1:0] m11_axi_wdata;
wire    [AXI_CNT*M1_AXI_SW-1:0] m11_axi_wstrb;
wire    [AXI_CNT-1:0]           m11_axi_wlast;
wire    [AXI_CNT-1:0]           m11_axi_wvalid;
wire    [AXI_CNT-1:0]           m11_axi_wready;

wire    [AXI_CNT*2-1:0]         m1_axi_bresp;
wire    [AXI_CNT-1:0]           m1_axi_bvalid;
wire    [AXI_CNT-1:0]           m1_axi_bready;
wire    [AXI_CNT*AXI_AW-1:0]    m1_axi_araddr;
wire    [AXI_CNT*8-1:0]         m1_axi_arlen;
wire    [AXI_CNT*3-1:0]         m1_axi_arsize;
wire    [AXI_CNT*2-1:0]         m1_axi_arburst;
wire    [AXI_CNT-1:0]           m1_axi_arlock;
wire    [AXI_CNT*4-1:0]         m1_axi_arcache;
wire    [AXI_CNT*3-1:0]         m1_axi_arprot;
wire    [AXI_CNT-1:0]           m1_axi_arvalid;
wire    [AXI_CNT-1:0]           m1_axi_arready;
wire    [AXI_CNT*M1_AXI_DW-1:0] m1_axi_rdata;
wire    [AXI_CNT*2-1:0]         m1_axi_rresp;
wire    [AXI_CNT-1:0]           m1_axi_rlast;
wire    [AXI_CNT-1:0]           m1_axi_rvalid;
wire    [AXI_CNT-1:0]           m1_axi_rready;

wire    [AXI_CNT*M1_AXI_DW-1:0] m11_axi_rdata;
wire    [AXI_CNT*2-1:0]         m11_axi_rresp;
wire    [AXI_CNT-1:0]           m11_axi_rlast;
wire    [AXI_CNT-1:0]           m11_axi_rvalid;
wire    [AXI_CNT-1:0]           m11_axi_rready;


wire    [AXI_CNT*AXI_AW-1:0]    m2_axi_awaddr;
wire    [AXI_CNT*8-1:0]         m2_axi_awlen;
wire    [AXI_CNT*3-1:0]         m2_axi_awsize;
wire    [AXI_CNT*2-1:0]         m2_axi_awburst;
wire    [AXI_CNT-1:0]           m2_axi_awlock;
wire    [AXI_CNT*4-1:0]         m2_axi_awcache;
wire    [AXI_CNT*3-1:0]         m2_axi_awprot;
wire    [AXI_CNT-1:0]           m2_axi_awvalid;
wire    [AXI_CNT-1:0]           m2_axi_awready;
wire    [AXI_CNT*M2_AXI_DW-1:0] m2_axi_wdata;
wire    [AXI_CNT*M2_AXI_SW-1:0] m2_axi_wstrb;
wire    [AXI_CNT-1:0]           m2_axi_wlast;
wire    [AXI_CNT-1:0]           m2_axi_wvalid;
wire    [AXI_CNT-1:0]           m2_axi_wready;
wire    [AXI_CNT*2-1:0]         m2_axi_bresp;
wire    [AXI_CNT-1:0]           m2_axi_bvalid;
wire    [AXI_CNT-1:0]           m2_axi_bready;
wire    [AXI_CNT*AXI_AW-1:0]    m2_axi_araddr;
wire    [AXI_CNT*8-1:0]         m2_axi_arlen;
wire    [AXI_CNT*3-1:0]         m2_axi_arsize;
wire    [AXI_CNT*2-1:0]         m2_axi_arburst;
wire    [AXI_CNT-1:0]           m2_axi_arlock;
wire    [AXI_CNT*4-1:0]         m2_axi_arcache;
wire    [AXI_CNT*3-1:0]         m2_axi_arprot;
wire    [AXI_CNT-1:0]           m2_axi_arvalid;
wire    [AXI_CNT-1:0]           m2_axi_arready;
wire    [AXI_CNT*M2_AXI_DW-1:0] m2_axi_rdata;
wire    [AXI_CNT*2-1:0]         m2_axi_rresp;
wire    [AXI_CNT-1:0]           m2_axi_rlast;
wire    [AXI_CNT-1:0]           m2_axi_rvalid;
wire    [AXI_CNT-1:0]           m2_axi_rready;
wire                            u1_wren;
wire                            u1_rden;
wire                            u1_full;
wire                            u1_empty;
wire    [514:0]                 u1_wdata;
wire    [514:0]                 u1_rdata;

wire                            u2_wren;
wire                            u2_rden;
wire                            u2_full;
wire                            u2_empty;
wire    [514:0]                 u2_wdata;
wire    [514:0]                 u2_rdata;

reg                             rstn;
//Encryption begin
/*----------------------------------------------------------------------------------*\
                                 The main code
\*----------------------------------------------------------------------------------*/
/*---------------------- Clock & Reset Region -------------------------*/
assign s_axi_clk  = clk_250m;
assign s_axi_rstn = clk_250m_rstn & rstn;

assign m_axi_clk  = clk_200m;
assign m_axi_rstn = clk_200m_rstn;

`ifdef SIM_MODE 
always@(posedge clk_250m)
begin
    rstn <= clk_250m_rstn;
end 
`else
always@(posedge clk_250m)
begin
    ddr_cfg_ok_dly <= {ddr_cfg_ok_dly[0],ddr_cfg_ok} ;
    rstn           <= ddr_cfg_ok_dly[1];
end 
`endif 

assign ddr_pll_rstn = 1'b1;
/*---------------------------- LPDDR4 CFG Region ---------------------------*/
localparam [1:0]    IDLE        = 2'b00,
                    CFG_START   = 2'b01,
                    CFG_DONE    = 2'b11;

reg     [1:0]   cfg_st, cfg_next;
reg     [7:0]   cfg_count;
reg     [7:0]   rst_delay_cnt ;
//Reset and PLL

always@(posedge clk_200m or negedge clk_200m_rstn)
begin
    if(!clk_200m_rstn) begin
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

always @(posedge clk_200m or negedge clk_200m_rstn)
begin
    if(~clk_200m_rstn) begin
        rst_delay_cnt <= 0;
    end 
    else if(cfg_next == CFG_DONE) begin
        if(~rst_delay_cnt[7]) rst_delay_cnt <= rst_delay_cnt + 1;
    end 
end 

assign ddr_inst_CFG_START  = (cfg_st != IDLE);
assign ddr_cfg_ok          = rst_delay_cnt[7] ;//(cfg_st == CFG_DONE);
assign ddr_inst_CFG_RST    = (cfg_st == IDLE);
assign ddr_inst_CFG_SEL    = 1'b0;

assign axi0_ARESETn = (cfg_st == CFG_DONE) ? 1'b1 : 1'b0;//ddr_cfg_ok;

assign axi0_AWQOS     = 0;
assign axi0_AWALLSTRB = 0;
assign axi0_AWCOBUF   = 0;
assign axi0_ARQOS     = 0; 
assign axi0_ARAPCMD   = 0;
assign axi0_AWAPCMD   = 0;

assign s0_axi_rresp = 2'b00;
assign s1_axi_rresp = 2'b00;
assign s2_axi_rresp = 2'b00;

/*------------------------------ Common Region -----------------------------*/
axi_interconnect #(
    .S_COUNT                            (S_COUNT                            ),
    .AXI_AW                             (AXI_AW                             ),
    .AXI_DW                             (M_AXI_DW                           ),
    .FAMILY                             (FAMILY                             )
)
u_axi_interconnect
(

    .clk                                (m_axi_clk                          ),
    .rstn                               (m_axi_rstn                         ),

    .s_axi_awvalid                      ({m2_axi_awvalid,m1_axi_awvalid,m0_axi_awvalid}),
    .s_axi_awready                      ({m2_axi_awready,m1_axi_awready,m0_axi_awready}),
    .s_axi_awaddr                       ({m2_axi_awaddr ,m1_axi_awaddr ,m0_axi_awaddr }),
    .s_axi_awlen                        ({m2_axi_awlen  ,m1_axi_awlen  ,m0_axi_awlen  }),
    .s_axi_wvalid                       ({m2_axi_wvalid ,m1_axi_wvalid ,m0_axi_wvalid }),
    .s_axi_wready                       ({m2_axi_wready ,m1_axi_wready ,m0_axi_wready }),
    .s_axi_wdata                        ({m2_axi_wdata  ,m1_axi_wdata  ,m0_axi_wdata  }),
    .s_axi_wstrb                        ({m2_axi_wstrb  ,m1_axi_wstrb  ,m0_axi_wstrb  }),
    .s_axi_wlast                        ({m2_axi_wlast  ,m1_axi_wlast  ,m0_axi_wlast  }),
    .s_axi_bvalid                       ({m2_axi_bvalid ,m1_axi_bvalid ,m0_axi_bvalid }),
    .s_axi_bready                       ({m2_axi_bready ,m1_axi_bready ,m0_axi_bready }),
    .s_axi_bresp                        ({m2_axi_bresp  ,m1_axi_bresp  ,m0_axi_bresp  }),
    .s_axi_arvalid                      ({m2_axi_arvalid,m1_axi_arvalid,m0_axi_arvalid}),
    .s_axi_arready                      ({m2_axi_arready,m1_axi_arready,m0_axi_arready}),
    .s_axi_araddr                       ({m2_axi_araddr ,m1_axi_araddr ,m0_axi_araddr }),
    .s_axi_arlen                        ({m2_axi_arlen  ,m1_axi_arlen  ,m0_axi_arlen  }),
    .s_axi_rvalid                       ({m2_axi_rvalid ,m1_axi_rvalid ,m0_axi_rvalid }),
    .s_axi_rready                       ({m2_axi_rready ,m1_axi_rready ,m0_axi_rready }),
    .s_axi_rdata                        ({m2_axi_rdata  ,m1_axi_rdata  ,m0_axi_rdata  }),
    .s_axi_rlast                        ({m2_axi_rlast  ,m1_axi_rlast  ,m0_axi_rlast  }),
    .s_axi_rresp                        ({m2_axi_rresp  ,m1_axi_rresp  ,m0_axi_rresp  }),
    
    .m_axi_awvalid                      (axi0_AWVALID                       ),
    .m_axi_awready                      (axi0_AWREADY                       ),
    .m_axi_awaddr                       (axi0_AWADDR                        ),
    .m_axi_awlen                        (axi0_AWLEN                         ),
    .m_axi_awid                         (axi0_AWID                          ),
    .m_axi_awsize                       (axi0_AWSIZE                        ),
    .m_axi_awburst                      (axi0_AWBURST                       ),
    .m_axi_awlock                       (axi0_AWLOCK                        ),
    .m_axi_awcache                      (axi0_AWCACHE                       ),
    .m_axi_awprot                       (axi0_AWPROT                        ),
    .m_axi_wvalid                       (axi0_WVALID                        ),
    .m_axi_wready                       (axi0_WREADY                        ),
    .m_axi_wdata                        (axi0_WDATA                         ),
    .m_axi_wstrb                        (axi0_WSTRB                         ),
    .m_axi_wlast                        (axi0_WLAST                         ),
    .m_axi_bvalid                       (axi0_BVALID                        ),
    .m_axi_bready                       (axi0_BREADY                        ),
    .m_axi_bresp                        (axi0_BRESP                         ),

    .m_axi_arvalid                      (axi0_ARVALID                       ),
    .m_axi_arready                      (axi0_ARREADY                       ),
    .m_axi_araddr                       (axi0_ARADDR                        ),
    .m_axi_arlen                        (axi0_ARLEN                         ),
    .m_axi_arid                         (axi0_ARID                          ),
    .m_axi_arsize                       (axi0_ARSIZE                        ),
    .m_axi_arburst                      (axi0_ARBURST                       ),
    .m_axi_arlock                       (axi0_ARLOCK                        ),
    .m_axi_arcache                      (axi0_ARCACHE                       ),
    .m_axi_arprot                       (axi0_ARPROT                        ),
    .m_axi_rvalid                       (axi0_RVALID                        ),
    .m_axi_rready                       (axi0_RREADY                        ),
    .m_axi_rdata                        (axi0_RDATA                         ),
    .m_axi_rlast                        (axi0_RLAST                         ),
    .m_axi_rresp                        (axi0_RRESP                         )
    
);

/*------------------------------ Common Region -----------------------------*/
axi_adapter #(
    .AXI_AW                             (AXI_AW                             ),
    .S_AXI_DW                           (S0_AXI_DW                          ),
    .M_AXI_DW                           (M0_AXI_DW                          ),
    .ASYNC                              (S0_ASYNC                           ),
    .S_AXI_REG_EN                       (S0_AXI_REG_EN                      ),
    .M_AXI_REG_EN                       (M0_AXI_REG_EN                      )
)
u0_axi_adapter
(
    .s_axi_clk                          (s_axi_clk                          ),
    .s_axi_rstn                         (s_axi_rstn                         ),
    .s_axi_awvalid                      (s0_axi_awvalid                     ),
    .s_axi_awready                      (s0_axi_awready                     ),
    .s_axi_awaddr                       (s0_axi_awaddr                      ),
    .s_axi_awlen                        (s0_axi_awlen                       ),
    .s_axi_wvalid                       (s0_axi_wvalid                      ),
    .s_axi_wready                       (s0_axi_wready                      ),
    .s_axi_wdata                        (s0_axi_wdata                       ),
    .s_axi_wstrb                        (s0_axi_wstrb                       ),
    .s_axi_wlast                        (s0_axi_wlast                       ),
    .s_axi_bready                       (s0_axi_bready                      ),
    .s_axi_bvalid                       (s0_axi_bvalid                      ),
    .s_axi_bresp                        (s0_axi_bresp                       ),
    .s_axi_arvalid                      (s0_axi_arvalid                     ),
    .s_axi_arready                      (s0_axi_arready                     ),
    .s_axi_araddr                       (s0_axi_araddr                      ),
    .s_axi_arlen                        (s0_axi_arlen                       ),
    .s_axi_rvalid                       (s0_axi_rvalid                      ),
    .s_axi_rready                       (s0_axi_rready                      ),
    .s_axi_rdata                        (s0_axi_rdata                       ),
    .s_axi_rlast                        (s0_axi_rlast                       ),

    .m_axi_clk                          (m_axi_clk                          ),
    .m_axi_rstn                         (m_axi_rstn                         ),
    .m_axi_awvalid                      (m0_axi_awvalid                     ),
    .m_axi_awready                      (m0_axi_awready                     ),
    .m_axi_awaddr                       (m0_axi_awaddr                      ),
    .m_axi_awlen                        (m0_axi_awlen                       ),
    .m_axi_awid                         (m0_axi_awid                        ),
    .m_axi_awsize                       (m0_axi_awsize                      ),
    .m_axi_awburst                      (m0_axi_awburst                     ),
    .m_axi_awlock                       (m0_axi_awlock                      ),
    .m_axi_awcache                      (m0_axi_awcache                     ),
    .m_axi_awprot                       (m0_axi_awprot                      ),
    .m_axi_wvalid                       (m0_axi_wvalid                      ),
    .m_axi_wready                       (m0_axi_wready                      ),
    .m_axi_wdata                        (m0_axi_wdata                       ),
    .m_axi_wstrb                        (m0_axi_wstrb                       ),
    .m_axi_wlast                        (m0_axi_wlast                       ),
    .m_axi_bvalid                       (m0_axi_bvalid                      ),
    .m_axi_bready                       (m0_axi_bready                      ),
    .m_axi_bresp                        (m0_axi_bresp                       ),
    .m_axi_arvalid                      (m0_axi_arvalid                     ),
    .m_axi_arready                      (m0_axi_arready                     ),
    .m_axi_araddr                       (m0_axi_araddr                      ),
    .m_axi_arlen                        (m0_axi_arlen                       ),
    .m_axi_arid                         (m0_axi_arid                        ),
    .m_axi_arsize                       (m0_axi_arsize                      ),
    .m_axi_arburst                      (m0_axi_arburst                     ),
    .m_axi_arlock                       (m0_axi_arlock                      ),
    .m_axi_arcache                      (m0_axi_arcache                     ),
    .m_axi_arprot                       (m0_axi_arprot                      ),
    .m_axi_rvalid                       (m00_axi_rvalid                      ),
    .m_axi_rready                       (m00_axi_rready                      ),
    .m_axi_rdata                        (m00_axi_rdata                       ),
    .m_axi_rlast                        (m00_axi_rlast                       ),
    .m_axi_rresp                        (m00_axi_rresp                       )

);

assign u2_wdata = {m0_axi_rdata,m0_axi_rresp,m0_axi_rlast};
assign u2_wren  = (m0_axi_rready && m0_axi_rvalid);
assign m0_axi_rready = !u2_full;

assign {m00_axi_rdata,m00_axi_rresp,m00_axi_rlast} = u2_rdata;
assign u2_rden = (m00_axi_rready && m00_axi_rvalid);
assign m00_axi_rvalid = !u2_empty;

efx_fifo_wrapper # (
    .FAMILY                             ("TITANIUM"                         ),
    .SYNC_CLK                           (1                                  ),
    .MODE                               ("FWFT"                             ),
    .DEPTH                              (512                                ),
    .DATA_WIDTH                         (515                                ),
    .PIPELINE_REG                       (1                                  ),
    .OPTIONAL_FLAGS                     (1                                  ),
    .OUTPUT_REG                         (0                                  ),
    .PROGRAMMABLE_FULL                  ("STATIC_SINGLE"                    ),
    .PROG_FULL_ASSERT                   (1024                               ),
    .PROG_FULL_NEGATE                   (1024                               ),
    .PROGRAMMABLE_EMPTY                 ("NONE"                             ),
    .PROG_EMPTY_ASSERT                  (0                                  ),
    .PROG_EMPTY_NEGATE                  (0                                  ),
    .RAM_STYLE                          ("block_ram"                        )
)
u2
(
    .a_rst_i                            (!m_axi_rstn                        ),
    .clk_i                              (m_axi_clk                          ),
    .wr_en_i                            (u2_wren                            ),
    .rd_en_i                            (u2_rden                            ),
    .wdata                              (u2_wdata                           ),
    .almost_full_o                      (u2_almfull                         ),
//    .prog_full_o                        (u1_prog_full_o                     ),
    .full_o                             (u2_full                            ),
    .datacount_o                        (                                   ),
    .empty_o                            (u2_empty                           ),
    .rd_valid_o                         (                                   ),
    .rdata                              (u2_rdata                           ),
    .rst_busy                           (                                   )
); 

/*------------------------------ Common Region -----------------------------*/
axi_adapter #(
    .AXI_AW                             (AXI_AW                             ),
    .S_AXI_DW                           (S1_AXI_DW                          ),
    .M_AXI_DW                           (M1_AXI_DW                          ),
    .ASYNC                              (S1_ASYNC                           ),
    .S_AXI_REG_EN                       (S1_AXI_REG_EN                      ),
    .M_AXI_REG_EN                       (M1_AXI_REG_EN                      )
)
u1_axi_adapter
(
    .s_axi_clk                          (s_axi_clk                          ),
    .s_axi_rstn                         (s_axi_rstn                         ),
    .s_axi_awvalid                      (s1_axi_awvalid                     ),
    .s_axi_awready                      (s1_axi_awready                     ),
    .s_axi_awaddr                       (s1_axi_awaddr                      ),
    .s_axi_awlen                        (s1_axi_awlen                       ),
    .s_axi_wvalid                       (s1_axi_wvalid                      ),
    .s_axi_wready                       (s1_axi_wready                      ),
    .s_axi_wdata                        (s1_axi_wdata                       ),
    .s_axi_wstrb                        (s1_axi_wstrb                       ),
    .s_axi_wlast                        (s1_axi_wlast                       ),
    .s_axi_bready                       (s1_axi_bready                      ),
    .s_axi_bvalid                       (s1_axi_bvalid                      ),
    .s_axi_bresp                        (s1_axi_bresp                       ),
    .s_axi_arvalid                      (s1_axi_arvalid                     ),
    .s_axi_arready                      (s1_axi_arready                     ),
    .s_axi_araddr                       (s1_axi_araddr                      ),
    .s_axi_arlen                        (s1_axi_arlen                       ),
    .s_axi_rvalid                       (s1_axi_rvalid                      ),
    .s_axi_rready                       (s1_axi_rready                      ),
    .s_axi_rdata                        (s1_axi_rdata                       ),
    .s_axi_rlast                        (s1_axi_rlast                       ),

    .m_axi_clk                          (m_axi_clk                          ),
    .m_axi_rstn                         (m_axi_rstn                         ),
    
    .m_axi_awvalid                      (m11_axi_awvalid                     ),
    .m_axi_awready                      (m11_axi_awready                     ),
    .m_axi_awaddr                       (m11_axi_awaddr                      ),
    .m_axi_awlen                        (m11_axi_awlen                       ),

    .m_axi_awid                         (m1_axi_awid                        ),
    .m_axi_awsize                       (m1_axi_awsize                      ),
    .m_axi_awburst                      (m1_axi_awburst                     ),
    .m_axi_awlock                       (m1_axi_awlock                      ),
    .m_axi_awcache                      (m1_axi_awcache                     ),
    .m_axi_awprot                       (m1_axi_awprot                      ),

    .m_axi_wvalid                       (m11_axi_wvalid                      ),
    .m_axi_wready                       (m11_axi_wready                      ),
    .m_axi_wdata                        (m11_axi_wdata                       ),
    .m_axi_wstrb                        (m11_axi_wstrb                       ),
    .m_axi_wlast                        (m11_axi_wlast                       ),

    .m_axi_bvalid                       (m1_axi_bvalid                      ),
    .m_axi_bready                       (m1_axi_bready                      ),
    .m_axi_bresp                        (m1_axi_bresp                       ),

    .m_axi_arvalid                      (m1_axi_arvalid                     ),
    .m_axi_arready                      (m1_axi_arready                     ),
    .m_axi_araddr                       (m1_axi_araddr                      ),
    .m_axi_arlen                        (m1_axi_arlen                       ),
    .m_axi_arid                         (m1_axi_arid                        ),
    .m_axi_arsize                       (m1_axi_arsize                      ),
    .m_axi_arburst                      (m1_axi_arburst                     ),
    .m_axi_arlock                       (m1_axi_arlock                      ),
    .m_axi_arcache                      (m1_axi_arcache                     ),
    .m_axi_arprot                       (m1_axi_arprot                      ),
    .m_axi_rvalid                       (m11_axi_rvalid                      ),
    .m_axi_rready                       (m11_axi_rready                      ),
    .m_axi_rdata                        (m11_axi_rdata                       ),
    .m_axi_rlast                        (m11_axi_rlast                       ),
    .m_axi_rresp                        (m11_axi_rresp                       )

);


always @(posedge m_axi_clk or negedge m_axi_rstn)
begin
    if(m_axi_rstn == 1'b0) begin
        m1_axi_awaddr <= 64'h0;
        m1_axi_awlen  <= 8'h0;
    end 
    else if(m11_axi_awready && m11_axi_awvalid) begin
        m1_axi_awaddr <= m11_axi_awaddr;
        m1_axi_awlen  <= m11_axi_awlen;
    end 
end 

always @(posedge m_axi_clk or negedge m_axi_rstn)
begin
    if(m_axi_rstn == 1'b0) begin
        m11_axi_awready <= 1'b1;
    end 
    else if(m11_axi_awready && m11_axi_awvalid) begin
        m11_axi_awready <= 1'b0;
    end
    else if(m1_axi_awready && m1_axi_awvalid)begin
        m11_axi_awready <= 1'b1;
    end
end 

always @(posedge m_axi_clk or negedge m_axi_rstn)
begin
    if(m_axi_rstn == 1'b0) begin
        m1_axi_awvalid <= 1'b0;
    end 
    else if(m1_axi_awready && m1_axi_awvalid)begin
        m1_axi_awvalid <= 1'b0;
    end
    else if(u1_prog_full_o && m1_axi_busy) begin
        m1_axi_awvalid <= 1'b1;
    end
end 

always @(posedge m_axi_clk or negedge m_axi_rstn)
begin
    if(m_axi_rstn == 1'b0) begin
        m1_axi_busy <= 1'b0;
    end 
    else if(m11_axi_awready && m11_axi_awvalid)begin
        m1_axi_busy <= 1'b1;
    end
    else if(m1_axi_awready && m1_axi_awvalid) begin
        m1_axi_busy <= 1'b0;
    end
end 

reg                             m1_axi_busy;
reg                             m1_axi_awvalid;
reg                             m11_axi_awready;
reg     [63:0]                  m1_axi_awaddr;
reg     [7:0]                   m1_axi_awlen;

wire                            u3_wren;
wire                            u3_rden;
wire                            u3_full;
wire                            u1_prog_full_o;
wire                            u3_empty;
wire    [576:0]                 u3_wdata;
wire    [576:0]                 u3_rdata;

assign u3_wdata = {m11_axi_wdata,m11_axi_wstrb,m11_axi_wlast};
assign u3_wren  = (m11_axi_wvalid && m11_axi_wready);
assign m11_axi_wready = !u3_full;

assign {m1_axi_wdata,m1_axi_wstrb,m1_axi_wlast} = u3_rdata;
assign u3_rden = (m1_axi_wvalid && m1_axi_wready);
assign m1_axi_wvalid = !u3_empty;

efx_fifo_wrapper # (
    .FAMILY                             ("TITANIUM"                         ),
    .SYNC_CLK                           (1                                  ),
    .MODE                               ("FWFT"                             ),
    .DEPTH                              (512                                ),
    .DATA_WIDTH                         (577                                ),
    .PIPELINE_REG                       (1                                  ),
    .OPTIONAL_FLAGS                     (0                                  ),
    .OUTPUT_REG                         (0                                  ),
    .PROGRAMMABLE_FULL                  ("STATIC_SINGLE"                    ),
    .PROG_FULL_ASSERT                   (28                                 ),
    .PROG_FULL_NEGATE                   (28                                 ),
    .PROGRAMMABLE_EMPTY                 ("NONE"                             ),
    .PROG_EMPTY_ASSERT                  (0                                  ),
    .PROG_EMPTY_NEGATE                  (0                                  ),
    .RAM_STYLE                          ("block_ram"                        )
)
u3
(
    .a_rst_i                            (!m_axi_rstn                        ),
    .clk_i                              (m_axi_clk                          ),
    .wr_en_i                            (u3_wren                            ),
    .rd_en_i                            (u3_rden                            ),
    .wdata                              (u3_wdata                           ),
    .almost_full_o                      (u3_almfull                         ),
    .prog_full_o                        (u1_prog_full_o                     ),
    .full_o                             (u3_full                            ),
    .datacount_o                        (                                   ),
    .empty_o                            (u3_empty                           ),
    .rd_valid_o                         (                                   ),
    .rdata                              (u3_rdata                           ),
    .rst_busy                           (                                   )
); 



assign u1_wdata = {m1_axi_rdata,m1_axi_rresp,m1_axi_rlast};
assign u1_wren  = (m1_axi_rready && m1_axi_rvalid);
assign m1_axi_rready = !u1_full;

assign {m11_axi_rdata,m11_axi_rresp,m11_axi_rlast} = u1_rdata;
assign u1_rden = (m11_axi_rready && m11_axi_rvalid);
assign m11_axi_rvalid = !u1_empty;

efx_fifo_wrapper # (
    .FAMILY                             ("TITANIUM"                         ),
    .SYNC_CLK                           (1                                  ),
    .MODE                               ("FWFT"                             ),
    .DEPTH                              (512                                ),
    .DATA_WIDTH                         (515                                ),
    .PIPELINE_REG                       (1                                  ),
    .OPTIONAL_FLAGS                     (1                                  ),
    .OUTPUT_REG                         (0                                  ),
    .PROGRAMMABLE_FULL                  ("STATIC_SINGLE"                    ),
    .PROG_FULL_ASSERT                   (1024                               ),
    .PROG_FULL_NEGATE                   (1024                               ),
    .PROGRAMMABLE_EMPTY                 ("NONE"                             ),
    .PROG_EMPTY_ASSERT                  (0                                  ),
    .PROG_EMPTY_NEGATE                  (0                                  ),
    .RAM_STYLE                          ("block_ram"                        )
)
u1
(
    .a_rst_i                            (!m_axi_rstn                        ),
    .clk_i                              (m_axi_clk                          ),
    .wr_en_i                            (u1_wren                            ),
    .rd_en_i                            (u1_rden                            ),
    .wdata                              (u1_wdata                           ),
    .almost_full_o                      (u1_almfull                         ),
//    .prog_full_o                        (u1_prog_full_o                     ),
    .full_o                             (u1_full                            ),
    .datacount_o                        (                                   ),
    .empty_o                            (u1_empty                           ),
    .rd_valid_o                         (                                   ),
    .rdata                              (u1_rdata                           ),
    .rst_busy                           (                                   )
); 

/*------------------------------ Common Region -----------------------------*/
axi_adapter #(
    .AXI_AW                             (AXI_AW                             ),
    .S_AXI_DW                           (S2_AXI_DW                          ),
    .M_AXI_DW                           (M2_AXI_DW                          ),
    .ASYNC                              (S2_ASYNC                           ),
    .S_AXI_REG_EN                       (S2_AXI_REG_EN                      ),
    .M_AXI_REG_EN                       (M2_AXI_REG_EN                      )
)
u2_axi_adapter
(
    .s_axi_clk                          (s_axi_clk                          ),
    .s_axi_rstn                         (s_axi_rstn                         ),
    .s_axi_awvalid                      (s2_axi_awvalid                     ),
    .s_axi_awready                      (s2_axi_awready                     ),
    .s_axi_awaddr                       (s2_axi_awaddr                      ),
    .s_axi_awlen                        (s2_axi_awlen                       ),
    .s_axi_wvalid                       (s2_axi_wvalid                      ),
    .s_axi_wready                       (s2_axi_wready                      ),
    .s_axi_wdata                        (s2_axi_wdata                       ),
    .s_axi_wstrb                        (s2_axi_wstrb                       ),
    .s_axi_wlast                        (s2_axi_wlast                       ),
    .s_axi_bready                       (s2_axi_bready                      ),
    .s_axi_bvalid                       (s2_axi_bvalid                      ),
    .s_axi_bresp                        (s2_axi_bresp                       ),
    .s_axi_arvalid                      (s2_axi_arvalid                     ),
    .s_axi_arready                      (s2_axi_arready                     ),
    .s_axi_araddr                       (s2_axi_araddr                      ),
    .s_axi_arlen                        (s2_axi_arlen                       ),
    .s_axi_rvalid                       (s2_axi_rvalid                      ),
    .s_axi_rready                       (s2_axi_rready                      ),
    .s_axi_rdata                        (s2_axi_rdata                       ),
    .s_axi_rlast                        (s2_axi_rlast                       ),

    .m_axi_clk                          (m_axi_clk                          ),
    .m_axi_rstn                         (m_axi_rstn                         ),
    .m_axi_awvalid                      (m2_axi_awvalid                     ),
    .m_axi_awready                      (m2_axi_awready                     ),
    .m_axi_awaddr                       (m2_axi_awaddr                      ),
    .m_axi_awlen                        (m2_axi_awlen                       ),
    .m_axi_awid                         (m2_axi_awid                        ),
    .m_axi_awsize                       (m2_axi_awsize                      ),
    .m_axi_awburst                      (m2_axi_awburst                     ),
    .m_axi_awlock                       (m2_axi_awlock                      ),
    .m_axi_awcache                      (m2_axi_awcache                     ),
    .m_axi_awprot                       (m2_axi_awprot                      ),
    .m_axi_wvalid                       (m2_axi_wvalid                      ),
    .m_axi_wready                       (m2_axi_wready                      ),
    .m_axi_wdata                        (m2_axi_wdata                       ),
    .m_axi_wstrb                        (m2_axi_wstrb                       ),
    .m_axi_wlast                        (m2_axi_wlast                       ),
    .m_axi_bvalid                       (m2_axi_bvalid                      ),
    .m_axi_bready                       (m2_axi_bready                      ),
    .m_axi_bresp                        (m2_axi_bresp                       ),
    .m_axi_arvalid                      (m2_axi_arvalid                     ),
    .m_axi_arready                      (m2_axi_arready                     ),
    .m_axi_araddr                       (m2_axi_araddr                      ),
    .m_axi_arlen                        (m2_axi_arlen                       ),
    .m_axi_arid                         (m2_axi_arid                        ),
    .m_axi_arsize                       (m2_axi_arsize                      ),
    .m_axi_arburst                      (m2_axi_arburst                     ),
    .m_axi_arlock                       (m2_axi_arlock                      ),
    .m_axi_arcache                      (m2_axi_arcache                     ),
    .m_axi_arprot                       (m2_axi_arprot                      ),
    .m_axi_rvalid                       (m2_axi_rvalid                      ),
    .m_axi_rready                       (m2_axi_rready                      ),
    .m_axi_rdata                        (m2_axi_rdata                       ),
    .m_axi_rlast                        (m2_axi_rlast                       ),
    .m_axi_rresp                        (m2_axi_rresp                       )

);

/*------------------------------ Common Region -----------------------------*/
//Encryption end
endmodule

