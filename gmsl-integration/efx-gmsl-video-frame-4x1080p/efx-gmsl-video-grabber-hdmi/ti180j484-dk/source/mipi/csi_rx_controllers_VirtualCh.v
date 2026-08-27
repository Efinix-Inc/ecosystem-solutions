////////////////////////////////////////////////////////////////////////////
//           _____       
//          / _______    Copyright (C) 2013-2021 Efinix Inc. All rights reserved.
//         / /       \   
//        / /  ..    /   csi_rx_controllers.v
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

module csi_rx_controllers_VirtualCh #(
	parameter   NUM_CHANNEL = 4,


    parameter   DATAWIDTH_PER_CHANNEL = 8, //Datawidth per lanes
    parameter   NUM_RX_PER_CHANNEL = 2,    //Number of Lanes
 //   parameter CSI_NUM_DATA_LANE = 2;
    
	
	parameter   PIXEL_RX_DATAWIDTH = 10,	//RAW10, RAW12
    parameter   PIXEL_OUT_DATAWIDTH = 8,

    parameter CLOCK_FREQ_MHZ = 100
   
)
(

    input       rstn,
    input       clk,
    input       clk_pixel, 
    
	 input       i_ref_clk,
	
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
    
    output  [NUM_CHANNEL-1:0] rx_out_de,
    output  [NUM_CHANNEL-1:0] rx_out_vs,
    output  [NUM_CHANNEL-1:0] rx_out_hs,
    
    output  [NUM_CHANNEL*8-1:0]                   rx_virtual_ch,
    
    output  [NUM_CHANNEL*PIXEL_OUT_DATAWIDTH-1:0] rx_out_data_00,
    output  [NUM_CHANNEL*PIXEL_OUT_DATAWIDTH-1:0] rx_out_data_01,
    output  [NUM_CHANNEL*PIXEL_OUT_DATAWIDTH-1:0] rx_out_data_10,
    output  [NUM_CHANNEL*PIXEL_OUT_DATAWIDTH-1:0] rx_out_data_11
    

	
);
/////////////////////////////////////////////////////////////////////////////


 



genvar x,y;

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
		
		localparam START_PIXEL_OUT_DATAWIDTH	= PIXEL_OUT_DATAWIDTH * x; 
		localparam END_PIXEL_OUT_DATAWIDTH		= PIXEL_OUT_DATAWIDTH * (x+1) -1;

			
		assign resetb_rx[x] = 	w_rstn;
		
		
		wire 	[15:0] w_word_count;
		wire	[5:0] w_datatype;
		wire	w_rx_valid;
		wire	[3:0] w_rx_vs;
		wire	[3:0] w_rx_hs;
		wire	[63:0] w_rx_data;
		wire    [31:0] w_mipi_debug_out;	
        
        reg [7:0] r_VirtualCh;
        
        reg [7:0] r_vs_VirtualCh;
        reg [7:0] r_hs_VirtualCh;
        
            
        wire   [31:0] w_debug_error_bits;
    
        assign  w_debug_error_bits = w_mipi_debug_out & 32'h00007fff;
            
            
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
        
        reg [3:0] r_i_ref_clk;
        reg [31:0] count_HS_clk;
        reg [31:0] count_HS_clk_log;
        
        always @(posedge clk_byte_HS[x] or negedge w_mipi_dphy_rx_reset_byte_HS_n[x] )
        begin
            if (~w_mipi_dphy_rx_reset_byte_HS_n[x]) 
            begin
                count_HS_clk  <= 1'd0;
                count_HS_clk_log<= 1'd0;
              
                r_i_ref_clk<= 'd0;
            end 
            else 
            begin
                r_i_ref_clk <= {r_i_ref_clk[2:0], i_ref_clk};
                
                if( (!r_i_ref_clk[3]) && r_i_ref_clk[2]   )
                begin
                    count_HS_clk_log   <= count_HS_clk;
                    count_HS_clk  <= 1'd0;                    
                end 
                else 
                begin
                    count_HS_clk <= count_HS_clk + 'd1;
                end 
            end 
            
        end 
        
        reg [1:0] r_rx_out_hs;
        reg [1:0] r_rx_out_vs;
        reg [3:0] r_i_ref_clk_B;
        
        reg [31:0] count_line_rate;
        reg [31:0] count_line_rate_log;
        reg [31:0] count_frame_rate;
        reg [31:0] count_frame_rate_log;
        
        
        always @(posedge clk_pixel or negedge w_reset_pixel_n )
        begin
            if (~w_reset_pixel_n) 
            begin
                count_line_rate  <= 1'd0;
                count_line_rate_log<= 1'd0;
                count_frame_rate  <= 1'd0;
                count_frame_rate_log<= 1'd0;
              
                r_i_ref_clk_B<= 'd0;
                r_rx_out_hs <='d0;
                r_rx_out_vs <='d0;
                
            end 
            else 
            begin
                r_i_ref_clk_B <= {r_i_ref_clk_B[2:0], i_ref_clk};
                r_rx_out_hs <= {r_rx_out_hs[0:0],rx_out_hs[x]};
                r_rx_out_vs <= {r_rx_out_vs[0:0],rx_out_vs[x]};
                
                
                
                
                if( (!r_i_ref_clk_B[3]) && r_i_ref_clk_B[2]   )
                begin
                    count_line_rate_log   <= count_line_rate;
                    count_line_rate  <= 1'd0;        
        
                    count_frame_rate_log   <= count_frame_rate;
                    count_frame_rate  <= 1'd0;        

        
                end 
                else 
                begin
                   
                    if( (!r_rx_out_hs[1]) && r_rx_out_hs[0]   )
                    begin
                        count_line_rate <= count_line_rate + 'd1;
                    end
                    
                    if( (!r_rx_out_vs[1]) && r_rx_out_vs[0]   )
                    begin
                        count_frame_rate <= count_frame_rate + 'd1;
                    end
                    
                end 
            end 
            
        end 
			
			
		/*efx_csi2_rx_top_rx  //efx_csi2_rx // 
		#(
            .HS_DATA_WIDTH(DATAWIDTH_PER_CHANNEL),
            .NUM_DATA_LANE(NUM_RX_PER_CHANNEL),
            .CLOCK_FREQ_MHZ(CLOCK_FREQ_MHZ),
            .PIXEL_FIFO_DEPTH(2048)
		)
		inst_efx_csi2_rx0*/
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
			.axi_clk		    (1'b0), 
			.axi_reset_n	    (1'b0),
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
			
			.hsync_vc0			(w_rx_hs[0]),
			.hsync_vc1			(w_rx_hs[1]),
			.hsync_vc2			(w_rx_hs[2]),
			.hsync_vc3			(w_rx_hs[3]),
			.vsync_vc0			(w_rx_vs[0]),
			.vsync_vc1			(w_rx_vs[1]),
			.vsync_vc2			(w_rx_vs[2]),
			.vsync_vc3			(w_rx_vs[3]),
			.vc					(),
			.word_count			(w_word_count),
			.shortpkt_data_field(),
			.datatype			(w_datatype),
			.pixel_per_clk		(),
			.pixel_data			(w_rx_data),
			.pixel_data_valid	(w_rx_valid),
			.irq				(),
            .mipi_debug_in      (32'd0),
            .mipi_debug_out     (w_mipi_debug_out)
            
		);
	
		assign rx_out_de[x] =  w_rx_valid;
		assign rx_out_vs[x] =  (w_rx_vs!='d0)?1'b1:1'b0;
		assign rx_out_hs[x] =  (w_rx_hs!='d0)?1'b1:1'b0;
               
        always @(posedge clk or negedge w_rstn) begin
            if (!w_rstn)
            begin
                r_vs_VirtualCh <= 'd0;
            end
            else 
            begin 
                case (w_rx_vs)
                    4'b0001: r_vs_VirtualCh = 'd0;   // case 0
                    4'b0010: r_vs_VirtualCh = 'd1;   // case 1
                    4'b0100: r_vs_VirtualCh = 'd2;   // case 2
                    4'b1000: r_vs_VirtualCh = 'd3;   // case 2
                    default: r_vs_VirtualCh = r_vs_VirtualCh; // default case
                endcase
            end 
        end

        always @(posedge clk or negedge w_rstn) begin
            if (!w_rstn)
            begin
                r_hs_VirtualCh <= 'd0;
            end
            else 
            begin 
                case (w_rx_hs)
                    4'b0001: r_hs_VirtualCh = 'd0;   // case 0
                    4'b0010: r_hs_VirtualCh = 'd1;   // case 1
                    4'b0100: r_hs_VirtualCh = 'd2;   // case 2
                    4'b1000: r_hs_VirtualCh = 'd3;   // case 2
                    default: r_hs_VirtualCh = r_hs_VirtualCh; // default case
                endcase
            end 
        end
        
        always @(posedge clk or negedge w_rstn) begin
            if (!w_rstn)
            begin
                r_VirtualCh <= 'd0;
            end
            else 
            begin 
                if(r_VirtualCh != r_vs_VirtualCh)
                begin 
                    r_VirtualCh <= r_vs_VirtualCh;
                end 
               /* else if(r_VirtualCh != r_hs_VirtualCh)
                begin
                     r_VirtualCh <= r_hs_VirtualCh;
                end*/ 
                else 
                begin
                    r_VirtualCh <= r_VirtualCh;
                end 
            
            
            end 
        end
        
  
        
		
		localparam END_PIXEL_RX_DATAWIDTH_00	= PIXEL_RX_DATAWIDTH * (1);
		localparam END_PIXEL_RX_DATAWIDTH_01	= PIXEL_RX_DATAWIDTH * (2);
		localparam END_PIXEL_RX_DATAWIDTH_10	= PIXEL_RX_DATAWIDTH * (3);
		localparam END_PIXEL_RX_DATAWIDTH_11	= PIXEL_RX_DATAWIDTH * (4);
        
        assign rx_virtual_ch[x*8 +: 8] = r_VirtualCh;

		assign rx_out_data_00[END_PIXEL_OUT_DATAWIDTH:START_PIXEL_OUT_DATAWIDTH] = w_rx_data[END_PIXEL_RX_DATAWIDTH_00-1:END_PIXEL_RX_DATAWIDTH_00-PIXEL_OUT_DATAWIDTH];
		assign rx_out_data_01[END_PIXEL_OUT_DATAWIDTH:START_PIXEL_OUT_DATAWIDTH] = w_rx_data[END_PIXEL_RX_DATAWIDTH_01-1:END_PIXEL_RX_DATAWIDTH_01-PIXEL_OUT_DATAWIDTH];
		assign rx_out_data_10[END_PIXEL_OUT_DATAWIDTH:START_PIXEL_OUT_DATAWIDTH] = w_rx_data[END_PIXEL_RX_DATAWIDTH_10-1:END_PIXEL_RX_DATAWIDTH_10-PIXEL_OUT_DATAWIDTH];
		assign rx_out_data_11[END_PIXEL_OUT_DATAWIDTH:START_PIXEL_OUT_DATAWIDTH] = w_rx_data[END_PIXEL_RX_DATAWIDTH_11-1:END_PIXEL_RX_DATAWIDTH_11-PIXEL_OUT_DATAWIDTH];


		wire [NUM_CHANNEL-1:0][31:0]  w_rx_hsync_per_frame;
		wire [NUM_CHANNEL-1:0][31:0]  w_rx_pixel_per_line;
		wire [NUM_CHANNEL-1:0][31:0]  w_rx_frame_rate;      // Measured in Hz 

		wire [NUM_CHANNEL-1:0][31:0]  w_rx_clk_byte_HS_count;      // Measured in Hz 

		for(y=0; y< 4; y=y+1)
		begin:csi_rx_monitor
	
			video_monitor inst_csi_rx_monitor(
				.clk(clk),        // Pixel clock
				.reset_n(w_rstn),
				.vsync(w_rx_vs[y]),
				.hsync(w_rx_hs[y]),
				.de(w_rx_valid),         // Data Enable / Valid
				.ref_clk_hz(32'd200_000_000), // Frequency of the pixel clock (for rate calc)
				
				.clk_byte_HS(clk_byte_HS[x]),
				.reset_byte_HS_n(w_mipi_dphy_rx_reset_byte_HS_n[x]),
				
				.clk_byte_HS_count(w_rx_clk_byte_HS_count[y]),
				
				
				.hsync_per_frame(w_rx_hsync_per_frame[y]),
				.pixel_per_line (w_rx_pixel_per_line [y]),
				.frame_rate     (w_rx_frame_rate     [y]) // Measured in Hz
			);
		end

	
	end 

endgenerate 


////////////////////////MIPI RX//////////////////////





endmodule

//////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2013-2020 Efinix Inc. All rights reserved.
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
