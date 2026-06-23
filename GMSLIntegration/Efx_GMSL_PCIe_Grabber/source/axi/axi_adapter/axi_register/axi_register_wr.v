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
 * AXI4 register (write)
 */
module axi_register_wr #
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
    // AW channel register type
    // 0 to bypass, 1 for simple buffer, 2 for skid buffer
    parameter AW_REG_TYPE = 1,
    // W channel register type
    // 0 to bypass, 1 for simple buffer, 2 for skid buffer
    parameter W_REG_TYPE = 2,
    // B channel register type
    // 0 to bypass, 1 for simple buffer, 2 for skid buffer
    parameter B_REG_TYPE = 1
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
    output wire                     m_axi_bready
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
gSvEK3eghWz/K6p0DtLskXT7128HNjH2p3lsQh1UZ5ORX2XfWmbE3a0SI4uqEEbH
5xkCwJDJNcgAA7GeUlyBRwJS4tZvALESzZqxNARP+HTtXpwy42G/+aWkcURmd90r
dEi/Hxft019bDM6EPihn+WCIUkKByZ7nDw5gZwUBDkdvQnEEy141SIreWXPN/zH1
WE8dAEDVF7FcXo7Y3BbNnjZRd8gaz2m11m1oNRCAaHKc0VF9w5BQugMhdbQ7ocqk
BqQeYTlxwsM2z/Jym1nhVCNx/Zo4AaGwXqAaOQD1X1g3cyv0dLZpLbwdArUHhZW3
vFuDq7c4BBac5Z+56Z6HxA==
`pragma protect key_keyowner="Mentor Graphics Corporation"
`pragma protect key_keyname="MGC-VERIF-SIM-RSA-1"
`pragma protect key_method="rsa"
`pragma protect encoding=(enctype="base64", line_length=64, bytes=128)
`pragma protect key_block
em4J+Q8CUwsnvpxa+UTZaYKnlsDC0RPbPVz+pizlWF6fOI9yqTsvcNXnmjC1iRfI
mvUHZjuoxB/yQkiP6WseWH33DjPfTnfKjDFJsYou25e7xiSO73UCibCBM2msZCQc
rMVgAsM3OztN/FWN5OEFLktwFn9/kW0b0NK7mqKo2ug=
`pragma protect data_method="aes256-cbc"
`pragma protect encoding=(enctype="base64", line_length=64, bytes=19296)
`pragma protect data_block
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
`pragma protect end_protected
endmodule

`resetall
