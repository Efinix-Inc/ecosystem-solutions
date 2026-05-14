`timescale 1ns / 1ns
 
module crossbar#(
    parameter                       AXI_AW                  = 32, 
    parameter                       AXI_DW                  = 64, 
    parameter                       S_COUNT                 = 3, 
    parameter                       FAMILY                  = "TRION",
    parameter                       RD_QUEUE_FIFO_RAM_STYLE = "block_ram", 
    parameter                       RD_QUEUE_FIFO_DEPTH     = 512
)
(
                                
//Global Signals 
input                           clk,
input                           rstn,

//
output  reg                     rdcmd_only,
//Slave Local Bus Interface
//--Slave Local Bus Write/Read Address 
input           [S_COUNT*1-1:0] s_lb_arw,
input           [S_COUNT*1-1:0] s_lb_avalid,
output  wire    [S_COUNT*1-1:0] s_lb_aready,
input           [S_COUNT*AXI_AW-1:0]
                                s_lb_aaddr,
input           [S_COUNT*8-1:0] s_lb_alen,
//--Slave Local Bus Write Data 
input           [S_COUNT*1-1:0] s_lb_wvalid,
output  wire    [S_COUNT*1-1:0] s_lb_wready,
input           [S_COUNT*AXI_DW-1:0]     
                                s_lb_wdata,
input           [S_COUNT*AXI_DW/8-1:0]     
                                s_lb_wstrb,
input           [S_COUNT*1-1:0] s_lb_wlast,
//--Slave Local Bus Write Resp 
output  wire    [S_COUNT*1-1:0] s_lb_bvalid,
input           [S_COUNT*1-1:0] s_lb_bready,
output  wire    [S_COUNT*2-1:0] s_lb_bresp,
//--Slave Local Bus Read Data
output  wire    [S_COUNT*1-1:0] s_lb_rvalid,
input           [S_COUNT*1-1:0] s_lb_rready,
output  wire    [S_COUNT*AXI_DW-1:0]     
                                s_lb_rdata,
output  wire    [S_COUNT*1-1:0] s_lb_rlast,

//Master Local Bus Interface
//--Master Local Bus Write/Read Address 
output  reg                     m_lb_arw,
output  reg                     m_lb_avalid,
input                           m_lb_aready,
output  reg     [AXI_AW-1:0]    m_lb_aaddr,
output  reg     [7:0]           m_lb_alen,
//--Master Local Bus Write Data 
output  reg                     m_lb_wvalid,
input                           m_lb_wready,
output  reg     [AXI_DW-1:0]    m_lb_wdata,
output  reg     [AXI_DW/8-1:0]  m_lb_wstrb,
output  reg                     m_lb_wlast,
input                           m_lb_bvalid,
output  wire                    m_lb_bready,
input           [1:0]           m_lb_bresp,
//--Master Local Bus Read Data
input                           m_lb_rvalid,
output  wire                    m_lb_rready,
input           [AXI_DW-1:0]    m_lb_rdata,
input                           m_lb_rlast


);

//Parameter Define
localparam                      S_COUNT_WTH                = (S_COUNT > 1) ? $clog2(S_COUNT) : 1; 
localparam                      BRESP_QUEUE_FIFO_RAM_STYLE = RD_QUEUE_FIFO_RAM_STYLE;
localparam                      BRESP_QUEUE_FIFO_DEPTH     = RD_QUEUE_FIFO_DEPTH;

//Register Define
reg     [S_COUNT-1:0]           ch_req;
reg     [S_COUNT_WTH:0]         grant_num_r;
reg                             grant_ready;

//Wire Define
wire    [S_COUNT-1:0]           grant;
wire    [S_COUNT_WTH-1:0]       grant_num;
wire                            grant_valid;
//--read queue fifo
wire                            u1_wen;
wire    [S_COUNT_WTH-1:0]       u1_wdata;
wire                            u1_almfull;
wire                            u1_ren;
wire    [S_COUNT_WTH-1:0]       u1_rdata;
wire                            u1_empty;
wire    [S_COUNT_WTH-1:0]       rd_num;

//--b resp queue fifo
wire                            u2_wen;
wire    [S_COUNT_WTH-1:0]       u2_wdata;
wire                            u2_almfull;
wire                            u2_ren;
wire    [S_COUNT_WTH-1:0]       u2_rdata;
wire                            u2_empty;
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
TaTU881LVoTgOhVE9uIiesE4Hkmt6vzp8pnbksJ9nEsEnjPhAzbyXavvdydMf6Mu
grCueLxl5zQd+qAA5+kV43OaPL5bY0DwOQvZVsRyuseMvseB+IESDZAwhm1qjEJU
oRmJsY0GHXNXJMZRQuiwl9bOYusxLiyaSSZ/t6X+xYH5GgCTwxCn8bj67XboSAJM
elqk6058TYrqwHABHQ66YnWBn13Uu0uR1+hj1LWNQj6qcB86vdYoHSr8iz4NDj6S
e0JGJ4Qz9GQsOqA2QthNa7MsljhLjdP0BcBwy/oNiwei9524+kuYc3oUodSEJBAh
aNWTL6nMI+eSk18goEtHxw==
`pragma protect key_keyowner="Mentor Graphics Corporation"
`pragma protect key_keyname="MGC-VERIF-SIM-RSA-1"
`pragma protect key_method="rsa"
`pragma protect encoding=(enctype="base64", line_length=64, bytes=128)
`pragma protect key_block
hrEb38nov6rHlIHAOtM9xhizIDnS4EwBi5R9lh2cwGbMWS0ZvGTy9mJkP6HaHHmc
EN81/CHKJTAZFwwZ7iy0sIENvxm3F0srkRyg6YnTiAgZsGGFuBeBvjiextL2PtpK
v7CWcdJTcOVmWKfe0b1XORrP6X0hKMs6Jczk+j6fkIo=
`pragma protect data_method="aes256-cbc"
`pragma protect encoding=(enctype="base64", line_length=64, bytes=10960)
`pragma protect data_block
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
r4LFMNdZgaQ9WuObYs4asQ==
`pragma protect end_protected
endmodule
