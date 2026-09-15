////////////////////////////////////////////////////////////////////////////
//           _____       
//          / _______    Copyright (C) 2013-2026 Efinix Inc. All rights reserved.
//         / /       \   
//        / /  ..    /   csi_rx_controllers_full.v
//       / / .'     /    
//    __/ /.'      /     Description:
//   __   \       /      
//  /_/ /\ \_____/ /     
// ____/  \_______/      
//
// ***********************************************************************
// Revisions:
// 1.0 Initial rev

/////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module csi_rx_controllers_full #(
	parameter   NUM_CHANNEL = 4,

    parameter   DATAWIDTH_PER_CHANNEL = 8, //Datawidth per lanes
    parameter   NUM_RX_PER_CHANNEL = 2    //Number of Lanes
 //   parameter CSI_NUM_DATA_LANE = 2;
   
   
)
(

    input       rstn,
    input       clk,
    input       clk_pixel, 
    
    
    input       axi_clk, 
	input       axi_reset_n,
    
	
	
  // DPHY interface port
	
    input    [NUM_CHANNEL-1:0]   clk_byte_HS,
    output   [NUM_CHANNEL-1:0]   reset_byte_HS_n,
	output   [NUM_CHANNEL-1:0]   resetb_rx,
        
    input   [NUM_CHANNEL*NUM_RX_PER_CHANNEL-1:0] RxClkEsc,    
    input	[NUM_CHANNEL*DATAWIDTH_PER_CHANNEL-1:0]	RxDataHS0,  //full 16 bit
    input	[NUM_CHANNEL*DATAWIDTH_PER_CHANNEL-1:0]	RxDataHS1,
    input	[NUM_CHANNEL*DATAWIDTH_PER_CHANNEL-1:0]	RxDataHS2,
    input	[NUM_CHANNEL*DATAWIDTH_PER_CHANNEL-1:0]	RxDataHS3,
    input	[NUM_CHANNEL-1:0]	RxValidHS0,
    input	[NUM_CHANNEL-1:0]	RxValidHS1,
    input	[NUM_CHANNEL-1:0]	RxValidHS2,
    input	[NUM_CHANNEL-1:0]	RxValidHS3,
    
    input	[NUM_CHANNEL*NUM_RX_PER_CHANNEL-1:0]	RxSyncHS,
    input	[NUM_CHANNEL-1:0]    	RxUlpsClkNot,
    input	[NUM_CHANNEL-1:0]    	RxUlpsActiveClkNot,
    input	[NUM_CHANNEL*NUM_RX_PER_CHANNEL-1:0]	RxErrEsc,
    input	[NUM_CHANNEL*NUM_RX_PER_CHANNEL-1:0]	RxErrControl,
    input	[NUM_CHANNEL*NUM_RX_PER_CHANNEL-1:0]	RxErrSotSyncHS,
    input	[NUM_CHANNEL*NUM_RX_PER_CHANNEL-1:0]	RxUlpsEsc,
    input	[NUM_CHANNEL*NUM_RX_PER_CHANNEL-1:0]	RxUlpsActiveNot,
    input	[NUM_CHANNEL*NUM_RX_PER_CHANNEL-1:0]	RxSkewCalHS,
    input	[NUM_CHANNEL*NUM_RX_PER_CHANNEL-1:0]	RxStopState,


  // CSI controller ouptut interface port
    output  [NUM_CHANNEL-1:0] 		rx_out_de,
    output  [NUM_CHANNEL-1:0] 		rx_out_vs,
    output  [NUM_CHANNEL-1:0] 		rx_out_hs,
	output	[NUM_CHANNEL*64-1:0]	rx_out_data,
	output  [NUM_CHANNEL*6-1:0]		rx_out_dt, //Data type
	output	[NUM_CHANNEL*16-1:0]	rx_out_wc, //would count    
	output	[NUM_CHANNEL*16-1:0]	rx_out_line_num, //Line Number     
	output	[NUM_CHANNEL*16-1:0]	rx_out_frame_num //Frame Number     
	

	
);
/////////////////////////////////////////////////////////////////////////////


 



genvar x;

wire [NUM_CHANNEL-1:0] w_mipi_dphy_rx_reset_byte_HS_n;
wire w_reset_pixel_n;

assign reset_byte_HS_n = w_mipi_dphy_rx_reset_byte_HS_n;

assign w_rstn = rstn;

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
);


generate 
	for(x=0; x< NUM_CHANNEL; x=x+1)
	begin:csi_rx
		// MIPI Rx0
		
		localparam START_DATAWIDTH_PER_CHANNEL 	= DATAWIDTH_PER_CHANNEL * x; 
		localparam END_DATAWIDTH_PER_CHANNEL   	= DATAWIDTH_PER_CHANNEL * (x+1) -1;
        
        localparam START_VALID_PER_CHANNEL 	    = (DATAWIDTH_PER_CHANNEL/8)* x; 
		localparam END_VALID_PER_CHANNEL   	    = (DATAWIDTH_PER_CHANNEL/8)* (x+1) -1;
        
		
		localparam START_NUM_RX_PER_CHANNEL 	= NUM_RX_PER_CHANNEL * x; 
		localparam END_NUM_RX_PER_CHANNEL   	= NUM_RX_PER_CHANNEL * (x+1) -1;
		
			
		assign resetb_rx[x] = 	w_rstn;
		
		
		wire 	[15:0] w_word_count;
		wire    [15:0] w_line_num;
		wire    [15:0] w_frame_num;
		wire	[5:0] w_datatype;
		wire	w_rx_valid;
		wire	w_rx_vs;
		wire	w_rx_hs;
		wire	[63:0] w_rx_data;
        wire	[63:0] w_rx_data_count;
        
		wire    [31:0] w_mipi_debug_out;	
        wire   [31:0] w_debug_error_bits;
    
        assign  w_debug_error_bits = w_mipi_debug_out & 32'h00007ffc;  
		reset
		#(
			.IN_RST_ACTIVE	("LOW"),
			.OUT_RST_ACTIVE	("LOW"),
			.CYCLE			(3)
		)
		inst_rx_byteclk_rst
		(
			.i_arst	(w_rstn),
			.i_clk	(clk_byte_HS[x]), //mipi_dphy_rx_clk_CLKOUT
			.o_srst	(w_mipi_dphy_rx_reset_byte_HS_n[x])
		);	
			
			
	
       csi2_hard_mipi_rx inst_efx_csi2_rx0
		(
			.reset_n			(w_rstn),
			.clk				(clk),
			.reset_byte_HS_n	(w_mipi_dphy_rx_reset_byte_HS_n[x]),
			.clk_byte_HS		(clk_byte_HS[x]), // mipi_dphy_rx_clk_CLKOUT 
			.reset_pixel_n		(w_reset_pixel_n),
			.clk_pixel			(clk_pixel),  
			
			// DPHY interface port
			.RxClkEsc           (RxClkEsc       [END_NUM_RX_PER_CHANNEL:START_NUM_RX_PER_CHANNEL] ),
            .RxDataHS0          (RxDataHS0		[END_DATAWIDTH_PER_CHANNEL:START_DATAWIDTH_PER_CHANNEL]),
			.RxDataHS1          (RxDataHS1		[END_DATAWIDTH_PER_CHANNEL:START_DATAWIDTH_PER_CHANNEL]),
			.RxDataHS2          (RxDataHS2		[END_DATAWIDTH_PER_CHANNEL:START_DATAWIDTH_PER_CHANNEL]),
			.RxDataHS3          (RxDataHS3		[END_DATAWIDTH_PER_CHANNEL:START_DATAWIDTH_PER_CHANNEL]),
			
            .RxValidHS0         ({RxValidHS0[x],RxValidHS0[x]}),
            .RxValidHS1         ({RxValidHS1[x],RxValidHS1[x]}),
            .RxValidHS2         ({RxValidHS2[x],RxValidHS2[x]}),
            .RxValidHS3         ({RxValidHS3[x],RxValidHS3[x]}),
            
			.RxSyncHS           (RxSyncHS		[END_NUM_RX_PER_CHANNEL:START_NUM_RX_PER_CHANNEL]),
			.RxUlpsClkNot       (RxUlpsClkNot		[x]),
			.RxUlpsActiveClkNot (RxUlpsActiveClkNot	[x]),
		
			.RxErrEsc           (RxErrEsc		[END_NUM_RX_PER_CHANNEL:START_NUM_RX_PER_CHANNEL]),
			.RxErrControl       (RxErrControl	[END_NUM_RX_PER_CHANNEL:START_NUM_RX_PER_CHANNEL]),
			.RxErrSotSyncHS     (RxErrSotSyncHS	[END_NUM_RX_PER_CHANNEL:START_NUM_RX_PER_CHANNEL]),
			
			.RxUlpsEsc          (RxUlpsEsc		[END_NUM_RX_PER_CHANNEL:START_NUM_RX_PER_CHANNEL]),
			.RxUlpsActiveNot    (RxUlpsActiveNot[END_NUM_RX_PER_CHANNEL:START_NUM_RX_PER_CHANNEL]),
			.RxSkewCalHS        (RxSkewCalHS	[END_NUM_RX_PER_CHANNEL:START_NUM_RX_PER_CHANNEL]),
			.RxStopState        (RxStopState	[END_NUM_RX_PER_CHANNEL:START_NUM_RX_PER_CHANNEL]),
		
			//AXI4-Lite Interface
			.axi_clk		    (axi_clk), 
			.axi_reset_n	    (axi_reset_n),
			.axi_awaddr		    (4'b0),//Write Address. byte address.
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
			.axi_rready		    (1'b1),//Read ready.
			
			.hsync_vc0			(w_rx_hs),
			.hsync_vc1			(),
			.hsync_vc2			(),
			.hsync_vc3			(),
			.vsync_vc0			(w_rx_vs),
			.vsync_vc1			(),
			.vsync_vc2			(),
			.vsync_vc3			(),
			.vc					(),
			.word_count			(w_word_count),
			.pixel_line_num		(w_line_num	),
			.pixel_frame_num	(w_frame_num),
			
			.shortpkt_data_field(),
			.datatype			(w_datatype),
			.pixel_per_clk		(),
			.pixel_data			(w_rx_data),
			.pixel_data_valid	(w_rx_valid),
			.irq				(),
            .mipi_debug_in      (32'd0),
            .mipi_debug_out     (w_mipi_debug_out)
            
		);
        
        reg [15:0] r_line_count;
        reg [15:0] r_data_count;
        reg r_rx_hs_1P; 
        reg r_rx_vs_1P;   
        
        always @(posedge clk or negedge w_rstn)
        begin 
            if(!w_rstn)
            begin
               r_data_count <= 'd0;
               r_line_count <= 'd0;
               r_rx_hs_1P <= 1'b0;
               r_rx_vs_1P <= 1'b0;
            end 
            else 
            begin
                r_rx_hs_1P <= w_rx_hs;
                r_rx_vs_1P <= w_rx_vs;
                
                
                if(!w_rx_hs& (r_rx_hs_1P))
                begin
                    r_data_count <= 'd0;
                end 
                else 
                begin
                    if(w_rx_valid)
                    begin
                        r_data_count <= r_data_count +'d1;
                    end 
                end 
                
                
                if(!w_rx_vs & r_rx_vs_1P)
                begin
                    r_line_count <= 'd0;
                end 
                else 
                begin 
                    if(!w_rx_hs& (r_rx_hs_1P))
                    begin
                        r_line_count <= r_line_count+ 1'b1;
                    end 
                
                
                end 
                
            end 
        
        end 
        
	
		assign rx_out_de[x] =  w_rx_valid;
		assign rx_out_vs[x] =  w_rx_vs;
		assign rx_out_hs[x] =  w_rx_hs;
        
        assign w_rx_data_count = {r_line_count,r_data_count};
		assign rx_out_data[64*x +:64] =w_rx_data;// w_rx_data_count;    //w_rx_data;
		assign rx_out_dt[6*x +:6] =  w_datatype;
		assign rx_out_wc[16*x +:16] =  w_word_count;
		
		assign rx_out_line_num[16*x +:16]    =  w_line_num;
		assign rx_out_frame_num[16*x +:16] =  w_frame_num;
		
		
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
