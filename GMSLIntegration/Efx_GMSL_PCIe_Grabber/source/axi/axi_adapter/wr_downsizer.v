`timescale 1ns / 1ns

module wr_downsizer #(
    parameter                       AXI_AW   = 32,
    parameter                       S_AXI_DW = 64,
    parameter                       M_AXI_DW = 32,
    parameter                       FAMILY   = "TITANIUM"
)
(
//Global Signals
input                           clk,
input                           rstn,
//Slave AXI4 Bus Interface
//--Slave AXI4 Write
input                           s_axi_awvalid,
output  reg                     s_axi_awready,
input           [AXI_AW-1:0]    s_axi_awaddr,
input           [7:0]           s_axi_awlen,
input                           s_axi_wvalid,
output  reg                     s_axi_wready,
input           [S_AXI_DW-1:0]  s_axi_wdata,
input           [S_AXI_DW/8-1:0]s_axi_wstrb,
input                           s_axi_wlast,
output  reg                     s_axi_bvalid,
input                           s_axi_bready,
output  reg    [1:0]            s_axi_bresp,

//Master AXI4 Bus Interface
//--Master AXI4 Bus Write 
output  reg                     m_axi_awvalid,
input                           m_axi_awready,
output  reg     [AXI_AW-1:0]    m_axi_awaddr,
output  reg     [7:0]           m_axi_awlen,
output  wire    [7:0]           m_axi_awid,
output  wire    [2:0]           m_axi_awsize,
output  wire    [1:0]           m_axi_awburst,
output  wire    [1:0]           m_axi_awlock,
output  wire    [3:0]           m_axi_awcache,
output  wire    [2:0]           m_axi_awprot,
output  reg                     m_axi_wvalid,
input                           m_axi_wready,
output  wire    [M_AXI_DW-1:0]  m_axi_wdata,
output  wire    [M_AXI_DW/8-1:0]m_axi_wstrb,
output  wire                    m_axi_wlast,
input                           m_axi_bvalid,
output  reg                     m_axi_bready,
input           [7:0]           m_axi_bid,
input           [1:0]           m_axi_bresp

);
//Parameter Define
localparam                      RATIO       = S_AXI_DW/M_AXI_DW;
localparam                      RATIO_W     = ($clog2(RATIO) == 0) ? 1 : $clog2(RATIO);
localparam                      S_AXI_SW    = S_AXI_DW/8;
localparam                      M_AXI_SW    = M_AXI_DW/8;
localparam                      S_BURST_WTH = RATIO_W + 8; 

//Register Define
reg     [S_BURST_WTH:0]         s_burst_cnt;
reg     [S_BURST_WTH:0]         s_burst_cnt_r;
reg     [RATIO_W:0]             split_cmd_cnt;
reg     [RATIO_W:0]             split_cmd_cnt_r;
reg     [S_AXI_DW-1:0]          in_data;
reg     [S_AXI_SW-1:0]          in_strb;
reg                             in_last;
reg     [RATIO_W:0]             in_cnt;
reg                             sr_en;
reg     [1:0]                   sr_cnt;
reg     [M_AXI_DW-1:0]          sr_data_r1;
reg     [M_AXI_SW-1:0]          sr_strb_r1;
reg                             sr_last_r1;
reg     [M_AXI_DW-1:0]          sr_data_r0;
reg     [M_AXI_SW-1:0]          sr_strb_r0;
reg                             sr_last_r0;
reg                             temp_wlast;
reg     [7:0]                   m_axi_cnt;
reg     [RATIO_W-1:0]           sr_last_cnt;
reg                             wvalid_en_next;
reg     [RATIO_W-1:0]           bresp_cnt;

//Wire Define
wire                            u0_wen;
wire    [RATIO_W:0]             u0_wdata;
wire                            u0_almfull;
wire                            u0_ren;
wire    [RATIO_W:0]             u0_rdata;
wire                            u0_empty;
wire                            in_en;
wire                            out_en;

`pragma protect begin_protected
`pragma protect version=1
`pragma protect encrypt_agent="ipecrypt"
`pragma protect encrypt_agent_info="http://ipencrypter.com Version: 20.0.8"
`pragma protect author="author-a"
`pragma protect author_info="author-a-details"

`pragma protect key_keyowner="Efinix Inc."
`pragma protect key_keyname="EFX_K01"
`pragma protect key_method="rsa"
`pragma protect encoding=(enctype="base64", line_length=64, bytes=256)
`pragma protect key_block
gfCpZb1/QZnLTrEtKA+S5+qQXSEFWHJ4oEJ2QM7eFgjT+WqkLEh/kddy8Htzfm0x
IsOvd26GKYoiCDfAJyrIdmm+bGdZpeueUiTJ9s4SBEjHLkxipddYO1LHEGWzOUAK
r5nPgIVmJDBLO7D5FoqcyQ4f206NMtt/S5JO6iXrhWqCXkxsLsZ3ABGGie6AZljy
ajMtp1mk/TnRF2kLSjhr9Bd4j3eW5dU/3TNO0S0w4FWM7CQtxOqFM0fau0eU0Mn5
5lr6iwMABxWUyFSqF0SR/OhxbWaC7hQim149t1svdvgkIho60egjs3h1Brd9hx7z
9PMpzf29DG1ycGEXQNI5qg==
`pragma protect key_keyowner="Mentor Graphics Corporation"
`pragma protect key_keyname="MGC-VERIF-SIM-RSA-1"
`pragma protect key_method="rsa"
`pragma protect encoding=(enctype="base64", line_length=64, bytes=128)
`pragma protect key_block
ElKP2JbliM5DfktM/hQSajcX8jlBGSrMO5vltvN7MKijUA8Kxe36/ym0Zki0Ogkq
7+T7o/Qu4pC3uXCsPjFkFXEMxmwoVT4Fh8nzOXMCR5yZ6GIWhmhFNCV56MJh+V54
zKVlkxwDiORo8C4pB9TUgfbQZ/5EiK+1rPn88GZSzyE=
`pragma protect data_method="aes256-cbc"
`pragma protect encoding=(enctype="base64", line_length=64, bytes=15264)
`pragma protect data_block
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
`pragma protect end_protected
endmodule
