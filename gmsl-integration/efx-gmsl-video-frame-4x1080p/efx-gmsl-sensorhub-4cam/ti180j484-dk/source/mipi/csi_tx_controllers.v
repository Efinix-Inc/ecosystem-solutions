////////////////////////////////////////////////////////////////////////////
//           _____       
//          / _______    Copyright (C) 2013-2026 Efinix Inc. All rights reserved.
//         / /       \   
//        / /  ..    /   csi_rx_controllers.v
//       / / .'     /    
//    __/ /.'      /     Description:
//   __   \       /      Module for genearte multi channels of CSI2 TX for Hard D phy IO 
//  /_/ /\ \_____/ /     
// ____/  \_______/      
//
// ***********************************************************************
// Revisions:
// 1.0 Initial rev
`timescale 1ns / 1ps

module csi_tx_controllers #(
	parameter   NUM_CHANNEL = 4,


    parameter   DATAWIDTH_PER_CHANNEL = 16,    
    parameter   NUM_TX_PER_CHANNEL = 2,    
    
	
	parameter   PIXEL_TX_DATAWIDTH = 10,	//RAW10, RAW12
    parameter   PIXEL_OUT_DATAWIDTH = 8
    
)
(

    input       rstn,
    input       clk,
    input       clk_pixel, 
    input       clk_esc,
  	
  // DPHY interface port
	
    input    [NUM_CHANNEL-1:0]   clk_byte_HS,
    output   [NUM_CHANNEL-1:0]   reset_byte_HS_n,
	output   [NUM_CHANNEL-1:0]   resetb_tx,
  
   //TX
    input	[NUM_CHANNEL-1:0] 						TxStopStateC,
    input	[NUM_CHANNEL-1:0] 						TxUlpsActiveClkNot,
    input 	[NUM_CHANNEL*NUM_TX_PER_CHANNEL-1:0]	TxReadyHS,  
    input 	[NUM_CHANNEL*NUM_TX_PER_CHANNEL-1:0]	TxStopStateD,
    input 	[NUM_CHANNEL*NUM_TX_PER_CHANNEL-1:0]	TxUlpsActiveNot,
		
    output	[NUM_CHANNEL*NUM_TX_PER_CHANNEL-1:0]	TxRequestHS,
    output	[NUM_CHANNEL*NUM_TX_PER_CHANNEL-1:0]	TxRequestEsc,
    output	[NUM_CHANNEL*NUM_TX_PER_CHANNEL-1:0]	TxUlpsExit,
    output	[NUM_CHANNEL*NUM_TX_PER_CHANNEL-1:0]	TxUlpsEsc,
    output	[NUM_CHANNEL*DATAWIDTH_PER_CHANNEL-1:0]	TxDataHS0,  //full16bit
    output	[NUM_CHANNEL*DATAWIDTH_PER_CHANNEL-1:0]	TxDataHS1,
    output	[NUM_CHANNEL*DATAWIDTH_PER_CHANNEL-1:0]	TxDataHS2,
    output	[NUM_CHANNEL*DATAWIDTH_PER_CHANNEL-1:0]	TxDataHS3,
    output	[NUM_CHANNEL*NUM_TX_PER_CHANNEL-1:0]	TxSkewCalHS,
    output	[NUM_CHANNEL-1:0]						TxUlpsClk,
    output	[NUM_CHANNEL-1:0]						TxUlpsExitClk,
    output	[NUM_CHANNEL-1:0]						TxRequestHSc,    
    output  [NUM_CHANNEL*2-1:0]                     TxReqValidHS0,
    output  [NUM_CHANNEL*2-1:0]                     TxReqValidHS1,
    output  [NUM_CHANNEL*2-1:0]                     TxReqValidHS2,
    output  [NUM_CHANNEL*2-1:0]                     TxReqValidHS3,

    input [5:0]  datatype,   // data type of the Long Packet
    input [15:0] haddr,   //16 bit total Horizontal number of pixels


  // CSI controller input interface port
    
    input  [NUM_CHANNEL-1:0] tx_in_de,
    input  [NUM_CHANNEL-1:0] tx_in_vs0,
    input  [NUM_CHANNEL-1:0] tx_in_hs0,
    input  [NUM_CHANNEL-1:0] tx_in_vs1,
    input  [NUM_CHANNEL-1:0] tx_in_hs1,
    input  [NUM_CHANNEL-1:0] tx_in_vs2,
    input  [NUM_CHANNEL-1:0] tx_in_hs2,
    input  [NUM_CHANNEL-1:0] tx_in_vs3,
    input  [NUM_CHANNEL-1:0] tx_in_hs3,

    input  [NUM_CHANNEL*PIXEL_OUT_DATAWIDTH-1:0] tx_in_data_00,
    input  [NUM_CHANNEL*PIXEL_OUT_DATAWIDTH-1:0] tx_in_data_01,
    input  [NUM_CHANNEL*PIXEL_OUT_DATAWIDTH-1:0] tx_in_data_10,
    input  [NUM_CHANNEL*PIXEL_OUT_DATAWIDTH-1:0] tx_in_data_11
    
	
);
/////////////////////////////////////////////////////////////////////////////

genvar x;

wire [NUM_CHANNEL-1:0] w_mipi_dphy_tx_reset_byte_HS_n;
wire w_reset_pixel_n;
wire w_reset_esc_n;

assign reset_byte_HS_n = w_mipi_dphy_tx_reset_byte_HS_n;

assign w_rstn = rstn;

wire w_byte_reset;


counter_start 
#(
	//.MHZ(100),
	.COUNT(100000000),
    .PULSE(0)
)
inst_pixel_clk_rst
 (
	.clk(clk_pixel),
	.rst_n(w_rstn),
	.start(w_reset_pixel_n)
);

/*
reset
#(
	.IN_RST_ACTIVE	("LOW"),
	.OUT_RST_ACTIVE	("LOW"),
	.CYCLE			(3)
)
inst_pixel_clk_rst
(
	.i_arst	(w_rstn), //w_rstn - delay the pixel data genration
	.i_clk	(clk_pixel),
	.o_srst	(w_reset_pixel_n)
);*/

reset
#(
	.IN_RST_ACTIVE	("LOW"),
	.OUT_RST_ACTIVE	("LOW"),
	.CYCLE			(3)
)
inst_esc_clk_rst
(
	.i_arst	(w_rstn),
	.i_clk	(clk_esc),
	.o_srst	(w_reset_esc_n)
);


generate 
	for(x=0; x< NUM_CHANNEL; x=x+1)
	begin:csi_tx
		// MIPI Rx0
		
		localparam START_DATAWIDTH_PER_CHANNEL 	= DATAWIDTH_PER_CHANNEL * x; 
		localparam END_DATAWIDTH_PER_CHANNEL   	= DATAWIDTH_PER_CHANNEL * (x+1) -1;
		
		localparam START_NUM_TX_PER_CHANNEL 	= NUM_TX_PER_CHANNEL * x; 
		localparam END_NUM_TX_PER_CHANNEL   	= NUM_TX_PER_CHANNEL * (x+1) -1;
		
		localparam START_PIXEL_IN_DATAWIDTH	    = PIXEL_OUT_DATAWIDTH * x; 
		localparam END_PIXEL_IN_DATAWIDTH		= PIXEL_OUT_DATAWIDTH * (x+1) -1;
        
        localparam BIT_SHIFT                    = PIXEL_TX_DATAWIDTH - PIXEL_OUT_DATAWIDTH;
      

			
		assign resetb_tx[x] = 	w_rstn;
		
		
		wire	w_video_valid;
		wire	w_video_de;
		wire	w_video_hs0;
		wire	w_video_vs0;
        wire	w_video_hs1;
		wire	w_video_vs1;
        wire	w_video_hs2;
		wire	w_video_vs2;
        wire	w_video_hs3;
		wire	w_video_vs3;
        
        
		wire	[63:0] w_video_data;
        wire [31:0] w_mipi_debug_in;
        wire [31:0] w_mipi_debug_out;
        
  
        wire w_fifo_full;
        wire w_fifo_empty;
        
        assign w_fifo_full  = w_mipi_debug_out[0];
        assign w_fifo_empty = w_mipi_debug_out[1];
        	
		reset
		#(
			.IN_RST_ACTIVE	("LOW"),
			.OUT_RST_ACTIVE	("LOW"),
			.CYCLE			(3)
		)
		inst_tx_byteclk_rst
		(
			.i_arst	(w_rstn),
			.i_clk	(clk_byte_HS[x]), //mipi_dphy_tx_SLOWCLK
			.o_srst	(w_mipi_dphy_tx_reset_byte_HS_n[x])
		);
			
		// MIPI Tx0
    /*   efx_csi2_tx_top_tx //efx_csi2_tx_top_tx
		#(
            .HS_DATA_WIDTH       (DATAWIDTH_PER_CHANNEL),
            .tINIT_NS            (100000),
            .tINIT_SKEWCAL_NS    (100000),
            .CLOCK_FREQ_MHZ      (1000/16),
            .DPHY_CLOCK_MODE     ("Continuous"), //"Continuous", "Discontinuous"
            .NUM_DATA_LANE       (NUM_TX_PER_CHANNEL),
            .PACK_TYPE           (4'b1111),
            .PIXEL_FIFO_DEPTH    (4096),  //set this to 2 power value of DEPTH = (MAX_HRES/8) x 2
            .ENABLE_VCX          (0),
            .FRAME_MODE          ("GENERIC"),    //1-ACCURATE, 0-GENERIC
            .ENABLE_SKEWCAL_INIT (1),
            .ASYNC_STAGE         (2)
		)inst_efx_csi2_tx */
		csi2_hard_mipi_tx inst_efx_csi2_tx
		(
		//	.reset_n			(w_rstn),
		//	.clk				(clk),
			.reset_byte_HS_n	(w_mipi_dphy_tx_reset_byte_HS_n[x]),
			.clk_byte_HS		(clk_byte_HS[x]),     //change to pclk from mipi_dphy_tx_SLOWCLK
			.reset_pixel_n		(w_reset_pixel_n),
			.clk_pixel			(clk_pixel),   
			.reset_esc_n        (w_reset_esc_n),
            .clk_esc            (clk_esc),
            
            
			// ----- DPHY interface -----------
            .TxUlpsClk          (TxUlpsClk[x]),
			.TxUlpsExitClk      (TxUlpsExitClk[x]),
            .TxUlpsActiveClkNot (TxUlpsActiveClkNot[x]),
			.TxUlpsEsc          (TxUlpsEsc[END_NUM_TX_PER_CHANNEL:START_NUM_TX_PER_CHANNEL]),
			.TxUlpsExit         (TxUlpsExit[END_NUM_TX_PER_CHANNEL:START_NUM_TX_PER_CHANNEL]),
			.TxRequestEsc       (TxRequestEsc[END_NUM_TX_PER_CHANNEL:START_NUM_TX_PER_CHANNEL]),
			.TxSkewCalHS        (TxSkewCalHS[END_NUM_TX_PER_CHANNEL:START_NUM_TX_PER_CHANNEL]), 
			.TxStopStateD       (TxStopStateD[END_NUM_TX_PER_CHANNEL:START_NUM_TX_PER_CHANNEL]),
			.TxStopStateC       (TxStopStateC[x]),
            .TxUlpsActiveNot    (TxUlpsActiveNot[END_NUM_TX_PER_CHANNEL:START_NUM_TX_PER_CHANNEL]),
            .TxReadyHS          (TxReadyHS[END_NUM_TX_PER_CHANNEL:START_NUM_TX_PER_CHANNEL]),  
			.TxRequestHS        (TxRequestHS[END_NUM_TX_PER_CHANNEL:START_NUM_TX_PER_CHANNEL]),
			.TxRequestHSc       (TxRequestHSc[x]),
            .TxDataHS0         (TxDataHS0[END_DATAWIDTH_PER_CHANNEL:START_DATAWIDTH_PER_CHANNEL]),
			.TxDataHS1         (TxDataHS1[END_DATAWIDTH_PER_CHANNEL:START_DATAWIDTH_PER_CHANNEL]),
			.TxDataHS2         (TxDataHS2[END_DATAWIDTH_PER_CHANNEL:START_DATAWIDTH_PER_CHANNEL]),
			.TxDataHS3         (TxDataHS3[END_DATAWIDTH_PER_CHANNEL:START_DATAWIDTH_PER_CHANNEL]),
			.TxDataHS4          (),
            .TxDataHS5          (),
            .TxDataHS6          (),
            .TxDataHS7          (),
            .TxReqValidHS0      (TxReqValidHS0[2*(x+1)-1: 2*x]),
            .TxReqValidHS1      (TxReqValidHS1[2*(x+1)-1: 2*x]),
            .TxReqValidHS2      (TxReqValidHS2[2*(x+1)-1: 2*x]),
            .TxReqValidHS3      (TxReqValidHS3[2*(x+1)-1: 2*x]),
		
			
			//AXI4-Lite Interface
			.axi_clk		    (clk), 
			.axi_reset_n	    (w_rstn),
			.axi_awaddr		    (6'b0),//Write Address. byte address.
			.axi_awvalid	    (1'b0),//Write address valid.
			.axi_awready	    (),//Write address ready.
			.axi_wdata		    (32'b0),//Write data bus.
			.axi_wvalid		    (1'b0),//Write valid.
			.axi_wready		    (),//Write ready.
			.axi_bvalid		    (),//Write response valid.
			.axi_bready		    (1'b0),//Response ready.      
			.axi_araddr		    (6'b0),//Read address. byte address.
			.axi_arvalid	    (1'b0),//Read address valid.
			.axi_arready	    (),//Read address ready.
			.axi_rdata		    (),//Read data.
			.axi_rvalid		    (),//Read valid.
			.axi_rready		    (1'b0),//Read ready.
			
			.hsync_vc0			(w_video_hs0),
			.hsync_vc1			(w_video_hs1),
			.hsync_vc2			(w_video_hs2),
			.hsync_vc3			(w_video_hs3),
			.vsync_vc0			(w_video_vs0),
			.vsync_vc1			(w_video_vs1),
			.vsync_vc2			(w_video_vs2),
			.vsync_vc3			(w_video_vs3),
			.datatype			(datatype),   	
			.pixel_data			(w_video_data),
			.pixel_data_valid	(w_video_valid),
			.haddr              (haddr),  		
			.line_num			(0),
			.frame_num			(0),	
			.irq				(),
            
            .mipi_debug_in      (w_mipi_debug_in),
            .mipi_debug_out     (w_mipi_debug_out)
            
		);
	
		assign w_video_valid = tx_in_de[x];
		assign w_video_vs0	 = tx_in_vs0[x];
		assign w_video_hs0	 = tx_in_hs0[x];
		assign w_video_vs1	 = tx_in_vs1[x];
		assign w_video_hs1	 = tx_in_hs1[x];
		assign w_video_vs2	 = tx_in_vs2[x];
		assign w_video_hs2	 = tx_in_hs2[x];
		assign w_video_vs3	 = tx_in_vs3[x];
		assign w_video_hs3	 = tx_in_hs3[x];
		
        
		assign w_video_data[PIXEL_TX_DATAWIDTH*1 -1: PIXEL_TX_DATAWIDTH*0 ] = {tx_in_data_00[END_PIXEL_IN_DATAWIDTH:START_PIXEL_IN_DATAWIDTH] , {BIT_SHIFT{1'b0}}};
		assign w_video_data[PIXEL_TX_DATAWIDTH*2 -1: PIXEL_TX_DATAWIDTH*1 ] = {tx_in_data_01[END_PIXEL_IN_DATAWIDTH:START_PIXEL_IN_DATAWIDTH] , {BIT_SHIFT{1'b0}}};
		assign w_video_data[PIXEL_TX_DATAWIDTH*3 -1: PIXEL_TX_DATAWIDTH*2 ] = {tx_in_data_10[END_PIXEL_IN_DATAWIDTH:START_PIXEL_IN_DATAWIDTH] , {BIT_SHIFT{1'b0}}};
		assign w_video_data[PIXEL_TX_DATAWIDTH*4 -1: PIXEL_TX_DATAWIDTH*3 ] = {tx_in_data_11[END_PIXEL_IN_DATAWIDTH:START_PIXEL_IN_DATAWIDTH] , {BIT_SHIFT{1'b0}}};

	end 


endgenerate 


////////////////////////MIPI RX//////////////////////





endmodule

//////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2013-2026 Efinix Inc. All rights reserved.
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
/////////////////////////////////////////////////////////////////////////////
