/*

Copyright (c) 2018 Alex Forencich

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

*/

// Language: Verilog 2001

`resetall
`timescale 1ns / 1ps
`default_nettype none

/*
 * AXI4 register
 */
module axi_register #
(
    // Width of data bus in bits
    parameter DATA_WIDTH = 32,
    // Width of address bus in bits
    parameter ADDR_WIDTH = 32,
    // Width of wstrb (width of data bus in words)
    parameter STRB_WIDTH = (DATA_WIDTH/8),
    // Width of ID signal
    parameter ID_WIDTH = 8,
    // Propagate awuser signal
    parameter AWUSER_ENABLE = 0,
    // Width of awuser signal
    parameter AWUSER_WIDTH = 1,
    // Propagate wuser signal
    parameter WUSER_ENABLE = 0,
    // Width of wuser signal
    parameter WUSER_WIDTH = 1,
    // Propagate buser signal
    parameter BUSER_ENABLE = 0,
    // Width of buser signal
    parameter BUSER_WIDTH = 1,
    // Propagate aruser signal
    parameter ARUSER_ENABLE = 0,
    // Width of aruser signal
    parameter ARUSER_WIDTH = 1,
    // Propagate ruser signal
    parameter RUSER_ENABLE = 0,
    // Width of ruser signal
    parameter RUSER_WIDTH = 1,
    // AW channel register type
    // 0 to bypass, 1 for simple buffer, 2 for skid buffer
    parameter AW_REG_TYPE = 1,
    // W channel register type
    // 0 to bypass, 1 for simple buffer, 2 for skid buffer
    parameter W_REG_TYPE = 2,
    // B channel register type
    // 0 to bypass, 1 for simple buffer, 2 for skid buffer
    parameter B_REG_TYPE = 1,
    // AR channel register type
    // 0 to bypass, 1 for simple buffer, 2 for skid buffer
    parameter AR_REG_TYPE = 1,
    // R channel register type
    // 0 to bypass, 1 for simple buffer, 2 for skid buffer
    parameter R_REG_TYPE = 2
)
(
    input  wire                     clk,
    input  wire                     rst,

    /*
     * AXI slave interface
     */
    input  wire [ID_WIDTH-1:0]      s_axi_awid,
    input  wire [ADDR_WIDTH-1:0]    s_axi_awaddr,
    input  wire [7:0]               s_axi_awlen,
    input  wire [2:0]               s_axi_awsize,
    input  wire [1:0]               s_axi_awburst,
    input  wire                     s_axi_awlock,
    input  wire [3:0]               s_axi_awcache,
    input  wire [2:0]               s_axi_awprot,
    input  wire [3:0]               s_axi_awqos,
    input  wire [3:0]               s_axi_awregion,
    input  wire [AWUSER_WIDTH-1:0]  s_axi_awuser,
    input  wire                     s_axi_awvalid,
    output wire                     s_axi_awready,
    input  wire [DATA_WIDTH-1:0]    s_axi_wdata,
    input  wire [STRB_WIDTH-1:0]    s_axi_wstrb,
    input  wire                     s_axi_wlast,
    input  wire [WUSER_WIDTH-1:0]   s_axi_wuser,
    input  wire                     s_axi_wvalid,
    output wire                     s_axi_wready,
    output wire [ID_WIDTH-1:0]      s_axi_bid,
    output wire [1:0]               s_axi_bresp,
    output wire [BUSER_WIDTH-1:0]   s_axi_buser,
    output wire                     s_axi_bvalid,
    input  wire                     s_axi_bready,
    input  wire [ID_WIDTH-1:0]      s_axi_arid,
    input  wire [ADDR_WIDTH-1:0]    s_axi_araddr,
    input  wire [7:0]               s_axi_arlen,
    input  wire [2:0]               s_axi_arsize,
    input  wire [1:0]               s_axi_arburst,
    input  wire                     s_axi_arlock,
    input  wire [3:0]               s_axi_arcache,
    input  wire [2:0]               s_axi_arprot,
    input  wire [3:0]               s_axi_arqos,
    input  wire [3:0]               s_axi_arregion,
    input  wire [ARUSER_WIDTH-1:0]  s_axi_aruser,
    input  wire                     s_axi_arvalid,
    output wire                     s_axi_arready,
    output wire [ID_WIDTH-1:0]      s_axi_rid,
    output wire [DATA_WIDTH-1:0]    s_axi_rdata,
    output wire [1:0]               s_axi_rresp,
    output wire                     s_axi_rlast,
    output wire [RUSER_WIDTH-1:0]   s_axi_ruser,
    output wire                     s_axi_rvalid,
    input  wire                     s_axi_rready,

    /*
     * AXI master interface
     */
    output wire [ID_WIDTH-1:0]      m_axi_awid,
    output wire [ADDR_WIDTH-1:0]    m_axi_awaddr,
    output wire [7:0]               m_axi_awlen,
    output wire [2:0]               m_axi_awsize,
    output wire [1:0]               m_axi_awburst,
    output wire                     m_axi_awlock,
    output wire [3:0]               m_axi_awcache,
    output wire [2:0]               m_axi_awprot,
    output wire [3:0]               m_axi_awqos,
    output wire [3:0]               m_axi_awregion,
    output wire [AWUSER_WIDTH-1:0]  m_axi_awuser,
    output wire                     m_axi_awvalid,
    input  wire                     m_axi_awready,
    output wire [DATA_WIDTH-1:0]    m_axi_wdata,
    output wire [STRB_WIDTH-1:0]    m_axi_wstrb,
    output wire                     m_axi_wlast,
    output wire [WUSER_WIDTH-1:0]   m_axi_wuser,
    output wire                     m_axi_wvalid,
    input  wire                     m_axi_wready,
    input  wire [ID_WIDTH-1:0]      m_axi_bid,
    input  wire [1:0]               m_axi_bresp,
    input  wire [BUSER_WIDTH-1:0]   m_axi_buser,
    input  wire                     m_axi_bvalid,
    output wire                     m_axi_bready,
    output wire [ID_WIDTH-1:0]      m_axi_arid,
    output wire [ADDR_WIDTH-1:0]    m_axi_araddr,
    output wire [7:0]               m_axi_arlen,
    output wire [2:0]               m_axi_arsize,
    output wire [1:0]               m_axi_arburst,
    output wire                     m_axi_arlock,
    output wire [3:0]               m_axi_arcache,
    output wire [2:0]               m_axi_arprot,
    output wire [3:0]               m_axi_arqos,
    output wire [3:0]               m_axi_arregion,
    output wire [ARUSER_WIDTH-1:0]  m_axi_aruser,
    output wire                     m_axi_arvalid,
    input  wire                     m_axi_arready,
    input  wire [ID_WIDTH-1:0]      m_axi_rid,
    input  wire [DATA_WIDTH-1:0]    m_axi_rdata,
    input  wire [1:0]               m_axi_rresp,
    input  wire                     m_axi_rlast,
    input  wire [RUSER_WIDTH-1:0]   m_axi_ruser,
    input  wire                     m_axi_rvalid,
    output wire                     m_axi_rready
);

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
JX+UPRSZ3DW2neY8rKyPfwSA5Fv9sh8E0v9BnQfTvFLne7w1SuK9ujj2KMRAKCJs
yVgM7UTY4opMZh2p3CKd6h86DxyeoZbycLi6TtsMcyAljOsgZJ1HEaOn29bN2h1y
fH7EZIdbTdNsjMUJwZAsTknBaGcRbEwnrjxd4tZdZ1cqnR4cMlzVuBUa+Ej2gZo8
bngbl70/OOsox8ua4jApaiKHXHMPx93zuTDKVKNNMMo7L7C+/4STQ/UtWfhw40BB
rvncyzMCjJJCPC+gcIT3pP+MJVlMbJE+f8NB9ZBK3w3pp77VBzwkRTQe4i7Cnnp+
M+CXne/BloM3BedNzt7TVQ==
`pragma protect key_keyowner="Mentor Graphics Corporation"
`pragma protect key_keyname="MGC-VERIF-SIM-RSA-1"
`pragma protect key_method="rsa"
`pragma protect encoding=(enctype="base64", line_length=64, bytes=128)
`pragma protect key_block
BTIjiy5VFWLFEBMPa+x+lXIdHxPPhCZMvw/jwrCL5vckM1XJNnm3m5STTAGT6Mg3
7EXtTjaL4kpt2YUlih6sfoH9KQWllYQOlrEbINex6V7So80bJvQg+Cp9wtdP/K7t
RlzIQzGQhOEuddcwEs6mTTeqwRgZIDUCrez6Ae7/ubQ=
`pragma protect data_method="aes256-cbc"
`pragma protect encoding=(enctype="base64", line_length=64, bytes=3904)
`pragma protect data_block
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
4Xl+7ab5IWqj1stnBVXeAA==
`pragma protect end_protected
endmodule

`resetall
