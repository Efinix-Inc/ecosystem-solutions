////////////////////////////////////////////////////////////////////////////
//           _____       
//          / _______    Copyright (C) 2013-2021 Efinix Inc. All rights reserved.
//         / /       \   
//        / /  ..    /   top.v
//       / / .'     /    
//    __/ /.'      /     Description:
//   __   \       /      
//  /_/ /\ \_____/ /     
// ____/  \_______/      
//
// ***********************************************************************
// Revisions:
// 1.0 Initial rev
//
// ***********************************************************************
`timescale 1 ns / 1 ns
module top#(
    parameter ADMA_DW=32
)
(
//Globle Signals
//----pll_0
input                           clk_50m,
input                           clk_100m,
input                           pll_0_locked,
input           [31:0]          apb_paddr,
input                           apb_psel,
input                           apb_penable,
output                          apb_pready,
input                           apb_pwrite,
input           [31:0]          apb_pwdata,
output          [31:0]          apb_prdata,
output                          apb_pslverror,
//--Write Bus Interface
output  wire                    m_axi_awvalid,
output  wire    [31:0]          m_axi_awaddr,
output  wire    [7:0]           m_axi_awlen,
output  wire    [2:0]           m_axi_awsize,
output  wire    [1:0]           m_axi_awburst,
output  wire    [2:0]           m_axi_awprot,
output  wire    [1:0]           m_axi_awlock,
output  wire    [3:0]           m_axi_awcache,
input                           m_axi_awready,
output  wire    [ADMA_DW-1:0]   m_axi_wdata,
output  wire    [ADMA_DW/8-1:0] m_axi_wstrb,
output  wire                    m_axi_wlast,
output  wire                    m_axi_wvalid,
input                           m_axi_wready,
input           [1:0]           m_axi_bresp,
input                           m_axi_bvalid,
output  wire                    m_axi_bready,
//--Read Bus Interface
output  wire                    m_axi_arvalid,
output  wire    [31:0]          m_axi_araddr,
output  wire    [7:0]           m_axi_arlen,
output  wire    [2:0]           m_axi_arsize,
output  wire    [1:0]           m_axi_arburst,
output  wire    [2:0]           m_axi_arprot,
output  wire    [1:0]           m_axi_arlock,
output  wire    [3:0]           m_axi_arcache,
input                           m_axi_arready,
input                           m_axi_rvalid,
input           [ADMA_DW-1:0]   m_axi_rdata,
input                           m_axi_rlast,
input           [1:0]           m_axi_rresp,
output  wire                    m_axi_rready,
//SD Interface
output  wire                    sd_clk_hi,
output  wire                    sd_clk_lo,
input                           sd_cmd_i,
output  wire                    sd_cmd_o,
output  wire                    sd_cmd_oe,
input           [3:0]           sd_dat_i,
output  wire    [3:0]           sd_dat_o,
output  wire    [3:0]           sd_dat_oe,
input                           sd_wp,
input                           sd_cd_n
);

//AXI4-Lite Register Bus Interface
wire [9:0]                      s_axi_awaddr;	//Write Address. byte address.
wire                            s_axi_awvalid;	//Write address valid.
wire                            s_axi_awready;	//Write address ready.
wire [31:0]                     s_axi_wdata;	//Write data bus.
wire                            s_axi_wvalid;	//Write valid.
wire                            s_axi_wready;	//Write ready.
wire [1:0]                      s_axi_bresp;	//Write response.
wire                            s_axi_bvalid;	//Write response valid.
wire                            s_axi_bready;	//Response ready.
wire [9:0]                      s_axi_araddr;	//Read address. byte address.
wire                            s_axi_arvalid;	//Read address valid.
wire                            s_axi_arready;	//Read address ready.
wire [1:0]                      s_axi_rresp;	//Read response.
wire [31:0]                     s_axi_rdata;	//Read data.
wire                            s_axi_rvalid;	//Read valid.
wire                            s_axi_rready;	//Read ready.


apb3_2_axi4_lite#(
    .ADDR_WTH                           (10                     )
)
u_apb_bus
(
//Globle Signals
    .clk                                (clk_50m                ),
    .rstn                               (pll_0_locked           ),
//APB3 Slave Interface
    .s_apb3_paddr                       (apb_paddr              ),
    .s_apb3_psel                        (apb_psel               ),
    .s_apb3_penable                     (apb_penable            ),
    .s_apb3_pready                      (apb_pready             ),
    .s_apb3_pwrite                      (apb_pwrite             ),
    .s_apb3_pwdata                      (apb_pwdata             ),
    .s_apb3_prdata                      (apb_prdata             ),
    .s_apb3_pslverror                   (apb_pslverror          ),
//AXI4-Lite Master Interfaceaddr                       
    .m_axi_awaddr                       (s_axi_awaddr           ),
    .m_axi_awvalid                      (s_axi_awvalid          ),
    .m_axi_awready                      (s_axi_awready          ),
    .m_axi_wdata                        (s_axi_wdata            ),
    .m_axi_wvalid                       (s_axi_wvalid           ),
    .m_axi_wready                       (s_axi_wready           ),
    .m_axi_bresp                        (s_axi_bresp            ),
    .m_axi_bvalid                       (s_axi_bvalid           ),
    .m_axi_bready                       (s_axi_bready           ),
    .m_axi_araddr                       (s_axi_araddr           ),
    .m_axi_arvalid                      (s_axi_arvalid          ),
    .m_axi_arready                      (s_axi_arready          ),
    .m_axi_rresp                        (s_axi_rresp            ),
    .m_axi_rdata                        (s_axi_rdata            ),
    .m_axi_rvalid                       (s_axi_rvalid           ),
    .m_axi_rready                       (s_axi_rready           )
);

/*----------------------- The SDHC core -----------------------*/
sd_host u1_sdhc
(
//Globle Signals
    .sd_rst                             (!pll_0_locked          ),
    .sd_base_clk                        (clk_100m               ),
    .sd_int                             (sd_int                 ),
    .sd_wp                              (sd_wp                  ),
    .sd_cd_n                            (sd_cd_n                ),
//AXI4-Lite Register Interface
    .s_axi_aclk                         (clk_50m                ),
    .s_axi_awaddr                       (s_axi_awaddr           ),
    .s_axi_awvalid                      (s_axi_awvalid          ),
    .s_axi_awready                      (s_axi_awready          ),
    .s_axi_wdata                        (s_axi_wdata            ),
    .s_axi_wstrb                        (4'hf                   ),
    .s_axi_wvalid                       (s_axi_wvalid           ),
    .s_axi_wready                       (s_axi_wready           ),
    .s_axi_bresp                        (s_axi_bresp            ),
    .s_axi_bvalid                       (s_axi_bvalid           ),
    .s_axi_bready                       (s_axi_bready           ),
    .s_axi_araddr                       (s_axi_araddr           ),
    .s_axi_arvalid                      (s_axi_arvalid          ),
    .s_axi_arready                      (s_axi_arready          ),
    .s_axi_rresp                        (s_axi_rresp            ),
    .s_axi_rdata                        (s_axi_rdata            ),
    .s_axi_rvalid                       (s_axi_rvalid           ),
    .s_axi_rready                       (s_axi_rready           ),
//AXI4 Memory Bus Interface
    .m_axi_clk                          (clk_50m                ),
//--Write Bus Interface
    .m_axi_awvalid                      (m_axi_awvalid          ),
    .m_axi_awaddr                       (m_axi_awaddr           ),
    .m_axi_awlen                        (m_axi_awlen            ),
    .m_axi_awsize                       (m_axi_awsize           ),
    .m_axi_awburst                      (m_axi_awburst          ),
    .m_axi_awprot                       (m_axi_awprot           ),
    .m_axi_awlock                       (m_axi_awlock           ),
    .m_axi_awcache                      (m_axi_awcache          ),
    .m_axi_awready                      (m_axi_awready          ),
    .m_axi_wdata                        (m_axi_wdata            ),
    .m_axi_wstrb                        (m_axi_wstrb            ),
    .m_axi_wlast                        (m_axi_wlast            ),
    .m_axi_wvalid                       (m_axi_wvalid           ),
    .m_axi_wready                       (m_axi_wready           ),
    .m_axi_bresp                        (m_axi_bresp            ),
    .m_axi_bvalid                       (m_axi_bvalid           ),
    .m_axi_bready                       (m_axi_bready           ),
//--Read Bus Interface
    .m_axi_arvalid                      (m_axi_arvalid          ),
    .m_axi_araddr                       (m_axi_araddr           ),
    .m_axi_arlen                        (m_axi_arlen            ),
    .m_axi_arsize                       (m_axi_arsize           ),
    .m_axi_arburst                      (m_axi_arburst          ),
    .m_axi_arprot                       (m_axi_arprot           ),
    .m_axi_arlock                       (m_axi_arlock           ),
    .m_axi_arcache                      (m_axi_arcache          ),
    .m_axi_arready                      (m_axi_arready          ),
    .m_axi_rvalid                       (m_axi_rvalid           ),
    .m_axi_rdata                        (m_axi_rdata            ),
    .m_axi_rlast                        (m_axi_rlast            ),
    .m_axi_rresp                        (m_axi_rresp            ),
    .m_axi_rready                       (m_axi_rready           ),
//SD Interface
    .sd_clk_hi                          (sd_clk_hi              ),
    .sd_clk_lo                          (sd_clk_lo              ),
    .sd_cmd_i                           (sd_cmd_i               ),
    .sd_cmd_o                           (sd_cmd_o               ),
    .sd_cmd_oe                          (sd_cmd_oe              ),
    .sd_dat_i                           (sd_dat_i               ),
    .sd_dat_o                           (sd_dat_o               ),
    .sd_dat_oe                          (sd_dat_oe_w            )
);

assign sd_dat_oe = {4{sd_dat_oe_w}};

endmodule

////////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2013-2024 Efinix Inc. All rights reserved.              
//
// This   document  contains  proprietary information  which   is        
// protected by  copyright. All rights  are reserved.  This notice       
// refers to original work by Efinix, Inc. which may be derivitive       
// of other work distributed under license of the authors.  In the       
// case of derivative work, nothing in this notice overrides the         
// original author's license agreement.  Where applicable, the           
// original license agreement is included in it's original               
// unmodified form immediately below this header.                        
//
// WARRANTY DISCLAIMER.                                                  
//     THE  DESIGN, CODE, OR INFORMATION ARE PROVIDED “AS IS” AND        
//     EFINIX MAKES NO WARRANTIES, EXPRESS OR IMPLIED WITH               
//     RESPECT THERETO, AND EXPRESSLY DISCLAIMS ANY IMPLIED WARRANTIES,  
//     INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF          
//     MERCHANTABILITY, NON-INFRINGEMENT AND FITNESS FOR A PARTICULAR    
//     PURPOSE.  SOME STATES DO NOT ALLOW EXCLUSIONS OF AN IMPLIED       
//     WARRANTY, SO THIS DISCLAIMER MAY NOT APPLY TO LICENSEE.           
//
// LIMITATION OF LIABILITY.                                              
//     NOTWITHSTANDING ANYTHING TO THE CONTRARY, EXCEPT FOR BODILY       
//     INJURY, EFINIX SHALL NOT BE LIABLE WITH RESPECT TO ANY SUBJECT    
//     MATTER OF THIS AGREEMENT UNDER TORT, CONTRACT, STRICT LIABILITY   
//     OR ANY OTHER LEGAL OR EQUITABLE THEORY (I) FOR ANY INDIRECT,      
//     SPECIAL, INCIDENTAL, EXEMPLARY OR CONSEQUENTIAL DAMAGES OF ANY    
//     CHARACTER INCLUDING, WITHOUT LIMITATION, DAMAGES FOR LOSS OF      
//     GOODWILL, DATA OR PROFIT, WORK STOPPAGE, OR COMPUTER FAILURE OR   
//     MALFUNCTION, OR IN ANY EVENT (II) FOR ANY AMOUNT IN EXCESS, IN    
//     THE AGGREGATE, OF THE FEE PAID BY LICENSEE TO EFINIX HEREUNDER    
//     (OR, IF THE FEE HAS BEEN WAIVED, $100), EVEN IF EFINIX SHALL HAVE 
//     BEEN INFORMED OF THE POSSIBILITY OF SUCH DAMAGES.  SOME STATES DO 
//     NOT ALLOW THE EXCLUSION OR LIMITATION OF INCIDENTAL OR            
//     CONSEQUENTIAL DAMAGES, SO THIS LIMITATION AND EXCLUSION MAY NOT   
//     APPLY TO LICENSEE.
//
////////////////////////////////////////////////////////////////////////////////
