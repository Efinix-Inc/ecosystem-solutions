`timescale 1ns / 1ns

module slave_coupler#(
    parameter                       AXI_AW           = 32,
    parameter                       AXI_DW           = 32,
    parameter                       S_AXI_CMD_REG_EN = 1
    
)
(

//Global Signals
input                           clk,
input                           rstn,
//
input                           rdcmd_only,
//Slave AXI4 Bus Interface
input                           s_axi_awvalid,
output  wire                    s_axi_awready,
input           [AXI_AW-1:0]    s_axi_awaddr,
input           [7:0]           s_axi_awlen,
input                           s_axi_wvalid,
output  wire                    s_axi_wready,
input           [AXI_DW-1:0]    s_axi_wdata,
input           [AXI_DW/8-1:0]  s_axi_wstrb,
input                           s_axi_wlast,
output  wire                    s_axi_bvalid,
input                           s_axi_bready,
output  wire    [1:0]           s_axi_bresp,
input                           s_axi_arvalid,
output  wire                    s_axi_arready,
input           [AXI_AW-1:0]    s_axi_araddr,
input           [7:0]           s_axi_arlen,
output  wire                    s_axi_rvalid,
input                           s_axi_rready,
output  wire    [AXI_DW-1:0]    s_axi_rdata,
output  wire                    s_axi_rlast,
output  wire    [1:0]           s_axi_rresp,

//Master Local Bus Interface
//--Master Local Bus Write/Read Address 
output  reg                     m_lb_arw,
output  wire                    m_lb_avalid,
input                           m_lb_aready,
output  wire    [AXI_AW-1:0]    m_lb_aaddr,
output  wire    [7:0]           m_lb_alen,

//--Master Local Bus Write Data 
output  wire                    m_lb_wvalid,
input                           m_lb_wready,
output  wire    [AXI_DW-1:0]    m_lb_wdata,
output  wire    [AXI_DW/8-1:0]  m_lb_wstrb,
output  wire                    m_lb_wlast,

//--Master Local Bus Bresp 
input                           m_lb_bvalid,
output  wire                    m_lb_bready,
input           [AXI_DW-1:0]    m_lb_bresp,
//--Master Local Bus Read Data
input                           m_lb_rvalid,
output  wire                    m_lb_rready,
input           [AXI_DW-1:0]    m_lb_rdata,
input                           m_lb_rlast

);

//Parameter Define

//Register Define
reg                             last_arw;

//Wire Define


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
f4Vfv5x+5o5LpzQ/09au5dSODpnvNBH7Fytnp7A+PPxdlUiUbMtENovLUhqeFbEY
grI+UJeUQNbBQXEZa9LVfU5EjqHIF161Su1jymsqyUC6I6a8bmXSYfmUdiyXFI9U
hbwP7usGBYFU8iHAMkTk+9sNZzvC03mEFUCqnGUISGQ3g2knlFozq+yTWKOAdPJh
W8sVsJvxe1BWOjbJ4lB/LcYtF1GBGQO2gr0KSO8Lgk+48dlWN3u7qLWdN5VsbHzk
Y7nvXj6KKmM3Yvckcz1E2Aoc/DK3goZu0WN1O6m8+9OWcYXqxNz4OWXnRsXmJo+/
GWEv0DpWwj6cYZG5NZSCkw==
`pragma protect key_keyowner="Mentor Graphics Corporation"
`pragma protect key_keyname="MGC-VERIF-SIM-RSA-1"
`pragma protect key_method="rsa"
`pragma protect encoding=(enctype="base64", line_length=64, bytes=128)
`pragma protect key_block
JOLRTHwDdkrdjoVSLANBbaKHZo1OIMdYyQu+g5UTMWbUbvTQ2mHNKVZRZ2GfQDxa
eMt24k3YMXL7ya7M3cU4Mc99+d8ynZWXKqR5r1y4h5PMrOomRYVtwmG0HyF8X8a3
Okkciv/zT3I77Ts/eTwdlseMwXw7aD1WaccIzatW734=
`pragma protect data_method="aes256-cbc"
`pragma protect encoding=(enctype="base64", line_length=64, bytes=8464)
`pragma protect data_block
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
GrByvr0Cb7NKzPox9qZaaw==
`pragma protect end_protected
endmodule
