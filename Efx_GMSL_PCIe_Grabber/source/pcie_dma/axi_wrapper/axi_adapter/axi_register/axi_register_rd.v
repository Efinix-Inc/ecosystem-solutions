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
 * AXI4 register (read)
 */
module axi_register_rd #
(
    // Width of data bus in bits
    parameter DATA_WIDTH = 32,
    // Width of address bus in bits
    parameter ADDR_WIDTH = 32,
    // Width of wstrb (width of data bus in words)
    parameter STRB_WIDTH = (DATA_WIDTH/8),
    // Width of ID signal
    parameter ID_WIDTH = 8,
    // Propagate aruser signal
    parameter ARUSER_ENABLE = 0,
    // Width of aruser signal
    parameter ARUSER_WIDTH = 1,
    // Propagate ruser signal
    parameter RUSER_ENABLE = 0,
    // Width of ruser signal
    parameter RUSER_WIDTH = 1,
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
nV82SPUKU5MAkX5a0E+3AtSYG2YUrrgYM3sHBwbm5hbobPl0ezgEtSR0/2o24pag
nbu2k4CF6ZbdtL6tEblza/4SmONsAC+KPBLEMWpkbY3o8DvWW54nMJ3VdUglVPK3
B96tr3HojOPzQ0a9wT2LlekkHcJvmemNqLqLKwOXNgJ2B8zcNgB1+X5t/SoyLW9r
7KzWrbhJTdSEvLBJ831MgOEjBGiwv/KB87iB3v64LpQ49f9hhymd2nhlMsniAN3p
6ANXbgZu9NJBnNRapGZa/FleQLu9DBno4ZqSkuxB3BRVKTcl3JXz3tdsYLXGrhlc
M7NI+pru+tetNciralaP5w==
`pragma protect key_keyowner="Mentor Graphics Corporation"
`pragma protect key_keyname="MGC-VERIF-SIM-RSA-1"
`pragma protect key_method="rsa"
`pragma protect encoding=(enctype="base64", line_length=64, bytes=128)
`pragma protect key_block
lK7HKb/kKnpWSGLQvJVwOdFq3BUdUtM2dN0e9rJkQnhNQZzBIlCh0UTUOe4KJmwn
+a+oZgKrJwO+yc+bieIqb58q4Dh/MSRzjvaY+ww4GXsYOOVRbNqFdfdQCaqxLO0j
v8Qq6ADansMNbMQEJfu7FyfRGVR/p7QxGt0G35PDz0I=
`pragma protect data_method="aes256-cbc"
`pragma protect encoding=(enctype="base64", line_length=64, bytes=14768)
`pragma protect data_block
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
`pragma protect end_protected
endmodule

`resetall
