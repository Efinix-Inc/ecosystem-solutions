
////////////////////////////////////////////////////////////////////////////
//           _____       
//          / _______    Copyright (C) 2013-2021 Efinix Inc. All rights reserved.
//         / /       \   
//        / /  ..    /   dma_stream_controller.v
//       / / .'     /    
//    __/ /.'      /     Description:
//   __   \       /      Module for dma controller for streaming in TI180M484 dev kit OOB design
//  /_/ /\ \_____/ /     
// ____/  \_______/      
//
// ***********************************************************************
// Revisions:
// 1.0 Initial rev

/////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
`define AXI_MEM_AXI4_ENABLE 1
module dma_stream_controller #(
	parameter 	AXI_DBW = 512,
    parameter   NUM_CSI_RX_IN  = 4,
	parameter   CSI_RX_PIXEL_DATAWIDTH  = 8,
	parameter   CSI_RX_PIXEL_PER_CLK    = 4,

    parameter   NUM_CSI_TX_OUT = 1,
	parameter   CSI_TX_PIXEL_DATAWIDTH  = 8,
	parameter   CSI_TX_PIXEL_PER_CLK    = 4,

    parameter   NUM_VIDEO_TX_OUT = 2,
	parameter   VIDEO_TX_PIXEL_DATAWIDTH  = 8,
	parameter   VIDEO_TX_PIXEL_PER_CLK    = 4
)
(
	//Clock Control
	input      io_systemClk,
	input      io_asyncReset,
	input      io_memoryClk,
	output	   io_memoryReset,
    input      io_systemReset,
    
    input      io_ddrMasterReset,
    
    input     [NUM_CSI_RX_IN-1:0] in_vclk,
    input      out_vclk,
	input       out_tx_clk,
    
    input 		vga_reset,
    
    input       i_ref_clk,
	  
    //DMA Control Ports
    input 	[15:0]      dma_ctrl_apb_PADDR,
    input 	      	    dma_ctrl_apb_PSEL,
    input 	            dma_ctrl_apb_PENABLE,
    output	            dma_ctrl_apb_PREADY,
    input 	            dma_ctrl_apb_PWRITE,
    input 	[31:0]      dma_ctrl_apb_PWDATA,
    output	[31:0]      dma_ctrl_apb_PRDATA,
    output	            dma_ctrl_apb_PSLVERROR,  
     
	output 				dma_ctrl_interrupt,
    
    //apb3 port for Custom SG mode Registers. 
	input	[15:0]	    dma_sg_apb_PADDR,
	input	            dma_sg_apb_PSEL,
	input	            dma_sg_apb_PENABLE,
	output	            dma_sg_apb_PREADY,
	input	            dma_sg_apb_PWRITE,
	input 	[31:0] 	    dma_sg_apb_PWDATA,
	output	[31:0] 	    dma_sg_apb_PRDATA,
	output              dma_sg_apb_PSLVERROR,
    
    
	
   `ifdef AXI_MEM_AXI4_ENABLE
	output read_arvalid,	//11
	output [31:0] read_araddr,
	input read_arready,
	output [3:0] read_arregion,
	output [7:0] read_arlen,
	output [2:0] read_arsize,
	output [1:0] read_arburst,
	output read_arlock,
	output [3:0] read_arcache,
	output [3:0] read_arqos,
	output [2:0] read_arprot,
	
	output read_rready,				//5
	input read_rvalid,
	input [AXI_DBW-1:0] read_rdata,
	input read_rlast,
	input [1:0] read_rresp,			
	
	output write_awvalid,	//11
	input write_awready,
	output [31:0] write_awaddr,
	output [3:0] write_awregion,
	output [7:0] write_awlen,
	output [2:0] write_awsize,
	output [1:0] write_awburst,
	output write_awlock,
	output [3:0] write_awcache,
	output [3:0] write_awqos,
	output [2:0] write_awprot,
	
	output write_wvalid,		//5
	input write_wready,
	output [AXI_DBW-1:0] write_wdata,
	output [(AXI_DBW/8)-1:0] write_wstrb,
	output write_wlast,
	
	input write_bvalid,	//3
	output write_bready,
	input [1:0] write_bresp,
    `else
	//DMA AXI3 memory Interface 
    output dma_axi_arwvalid,
    input dma_axi_arwready,
    output [31:0] dma_axi_arwaddr,
    
    output [3:0] dma_axi_arwregion,
    output [7:0] dma_axi_arwlen,
    output [2:0] dma_axi_arwsize,
    output [1:0] dma_axi_arwburst,
    output dma_axi_arwlock,
    output [3:0] dma_axi_arwcache,
    output [3:0] dma_axi_arwqos,
    output [2:0] dma_axi_arwprot,
    output dma_axi_arwwrite,
    
    output dma_axi_wvalid,
    input dma_axi_wready,
    output [AXI_DBW-1:0] dma_axi_wdata,
    output [AXI_DBW/8-1:0] dma_axi_wstrb,
    output dma_axi_wlast,
    
    input dma_axi_bvalid,
    output dma_axi_bready,
    input [1:0] dma_axi_bresp,
    
    input dma_axi_rvalid,
    output dma_axi_rready,
    input [AXI_DBW-1:0] dma_axi_rdata,
    input [1:0] dma_axi_rresp,
    input dma_axi_rlast,
    `endif
 
	//Streaming Control Signal 
	input 	[3:0]	start_dma_stream_in,
	input 	[3:0]	start_dma_stream_out,
    input   [1:0]   start_vga_gen,
    
	//CSI RX Stream Input
	input [NUM_CSI_RX_IN-1:0]	 in_de,
	input [NUM_CSI_RX_IN-1:0] 	 in_hs,
	input [NUM_CSI_RX_IN-1:0]	 in_vs,
    input [NUM_CSI_RX_IN*8-1:0]  in_virtual_ch,
	input [NUM_CSI_RX_IN*CSI_RX_PIXEL_DATAWIDTH-1:0]	 in_rd_00,
	input [NUM_CSI_RX_IN*CSI_RX_PIXEL_DATAWIDTH-1:0]	 in_rd_01,
	input [NUM_CSI_RX_IN*CSI_RX_PIXEL_DATAWIDTH-1:0] 	 in_rd_10,
	input [NUM_CSI_RX_IN*CSI_RX_PIXEL_DATAWIDTH-1:0]	 in_rd_11,
	
	//CSI TX Stream Output
	output [NUM_CSI_TX_OUT-1:0]	out_csi_tx_de,
	output [NUM_CSI_TX_OUT-1:0]	out_csi_tx_valid,
	output [NUM_CSI_TX_OUT-1:0] out_csi_tx_hsync0,
	output [NUM_CSI_TX_OUT-1:0] out_csi_tx_vsync0,
    output [NUM_CSI_TX_OUT-1:0] out_csi_tx_hsync1,
	output [NUM_CSI_TX_OUT-1:0] out_csi_tx_vsync1,
    output [NUM_CSI_TX_OUT-1:0] out_csi_tx_hsync2,
	output [NUM_CSI_TX_OUT-1:0] out_csi_tx_vsync2,
    output [NUM_CSI_TX_OUT-1:0] out_csi_tx_hsync3,
	output [NUM_CSI_TX_OUT-1:0] out_csi_tx_vsync3,
    
	output [NUM_CSI_TX_OUT*CSI_TX_PIXEL_DATAWIDTH-1:0]	out_csi_tx_rd_00,
	output [NUM_CSI_TX_OUT*CSI_TX_PIXEL_DATAWIDTH-1:0]	out_csi_tx_rd_01,
	output [NUM_CSI_TX_OUT*CSI_TX_PIXEL_DATAWIDTH-1:0]  out_csi_tx_rd_10,
	output [NUM_CSI_TX_OUT*CSI_TX_PIXEL_DATAWIDTH-1:0]	out_csi_tx_rd_11,
	
	
	//Video Stream Output
	output [NUM_VIDEO_TX_OUT-1:0] out_video_de,
	output [NUM_VIDEO_TX_OUT-1:0] out_video_valid,
	output [NUM_VIDEO_TX_OUT-1:0] out_video_hsync,
	output [NUM_VIDEO_TX_OUT-1:0] out_video_vsync,
	output [NUM_VIDEO_TX_OUT*VIDEO_TX_PIXEL_DATAWIDTH-1:0]	out_video_rd_00,
	output [NUM_VIDEO_TX_OUT*VIDEO_TX_PIXEL_DATAWIDTH-1:0]	out_video_rd_01,
	output [NUM_VIDEO_TX_OUT*VIDEO_TX_PIXEL_DATAWIDTH-1:0]  out_video_rd_10,
	output [NUM_VIDEO_TX_OUT*VIDEO_TX_PIXEL_DATAWIDTH-1:0]	out_video_rd_11
	
	
);
/////////////////////////////////////////////////////////////////////////////

parameter	CSI_TX_MAX_HRES		= 11'd1920 ;
parameter	CSI_TX_MAX_VRES		= 11'd1080;
parameter	CSI_TX_HSP				= 8'd200; //'d176; //8'd44;
parameter	CSI_TX_HBP				= 8'd400; //'d592; //8'd148;
parameter	CSI_TX_HFP				= 8'd200; //'d352; //8'd88;
parameter	CSI_TX_VSP				= 6'd5;
parameter	CSI_TX_VBP				= 6'd21;
parameter	CSI_TX_VFP				= 6'd4;

parameter	CSI_TX_NUM_CHANNEL		= 4;



parameter	VIDEO_MAX_HRES		= 11'd1920;
parameter	VIDEO_MAX_VRES		= 11'd1080;
parameter	VIDEO_HSP			= 8'd44;
parameter	VIDEO_HBP			= 8'd148;
parameter	VIDEO_HFP			= 8'd88;
parameter	VIDEO_VSP			= 6'd5;
parameter	VIDEO_VBP			= 6'd36;
parameter	VIDEO_VFP			= 6'd4;


//DMA port
wire  [6:0]                      dma_interrupts;


//wire 				w_start_dma_stream_in;
//wire  				w_start_dma_stream_out;


assign dma_ctrl_interrupt = | dma_interrupts;

localparam CSI_RX_TOTAL_DATAWIDTH = CSI_RX_PIXEL_DATAWIDTH * CSI_RX_PIXEL_PER_CLK;
localparam CSI_TX_TOTAL_DATAWIDTH = CSI_TX_PIXEL_DATAWIDTH * CSI_TX_PIXEL_PER_CLK;
localparam VIDEO_TX_TOTAL_DATAWIDTH = VIDEO_TX_PIXEL_DATAWIDTH * VIDEO_TX_PIXEL_PER_CLK;


wire w_VideoFrameOut_tvalid_ch1;
wire w_VideoFrameOut_tready_ch1;
wire [CSI_TX_TOTAL_DATAWIDTH-1:0] w_VideoFrameOut_tdata_ch1;
wire [CSI_TX_TOTAL_DATAWIDTH/8-1:0] w_VideoFrameOut_tkeep_ch1;
wire [CSI_TX_TOTAL_DATAWIDTH/8-1:0] w_VideoFrameOut_tdest_ch1;
wire w_VideoFrameOut_tlast_ch1;

wire w_VideoFrameOut_tvalid_ch2;
wire w_VideoFrameOut_tready_ch2;
wire [VIDEO_TX_TOTAL_DATAWIDTH-1:0] w_VideoFrameOut_tdata_ch2;
wire [VIDEO_TX_TOTAL_DATAWIDTH/8-1:0] w_VideoFrameOut_tkeep_ch2;
wire [VIDEO_TX_TOTAL_DATAWIDTH/8-1:0] w_VideoFrameOut_tdest_ch2;
wire w_VideoFrameOut_tlast_ch2;



wire [NUM_CSI_RX_IN-1:0]w_VideoFrameIn_tvalid;
wire [NUM_CSI_RX_IN-1:0]w_VideoFrameIn_tready;
wire [NUM_CSI_RX_IN*CSI_RX_TOTAL_DATAWIDTH-1:0] w_VideoFrameIn_tdata;
wire [NUM_CSI_RX_IN*CSI_RX_TOTAL_DATAWIDTH/8-1:0] w_VideoFrameIn_tkeep;
wire [NUM_CSI_RX_IN*CSI_RX_TOTAL_DATAWIDTH/8-1:0] w_VideoFrameIn_tdest;
wire [NUM_CSI_RX_IN-1:0]w_VideoFrameIn_tlast;

wire [NUM_CSI_TX_OUT-1:0]w_VideoFrameOut_CSI_TX_tvalid;
wire [NUM_CSI_TX_OUT-1:0]w_VideoFrameOut_CSI_TX_tready;
wire [NUM_CSI_TX_OUT*CSI_TX_TOTAL_DATAWIDTH-1:0]   w_VideoFrameOut_CSI_TX_tdata;
wire [NUM_CSI_TX_OUT*CSI_TX_TOTAL_DATAWIDTH/8-1:0] w_VideoFrameOut_CSI_TX_tkeep;
wire [NUM_CSI_TX_OUT*CSI_TX_TOTAL_DATAWIDTH/8-1:0] w_VideoFrameOut_CSI_TX_tdest;
wire [NUM_CSI_TX_OUT-1:0]w_VideoFrameOut_CSI_TX_tlast;

wire [NUM_VIDEO_TX_OUT-1:0]w_VideoFrameOut_tvalid;
wire [NUM_VIDEO_TX_OUT-1:0]w_VideoFrameOut_tready;
wire [NUM_VIDEO_TX_OUT*VIDEO_TX_TOTAL_DATAWIDTH-1:0] w_VideoFrameOut_tdata;
wire [NUM_VIDEO_TX_OUT*VIDEO_TX_TOTAL_DATAWIDTH/8-1:0] w_VideoFrameOut_tkeep;
wire [NUM_VIDEO_TX_OUT*VIDEO_TX_TOTAL_DATAWIDTH/8-1:0] w_VideoFrameOut_tdest;
wire [NUM_VIDEO_TX_OUT-1:0]w_VideoFrameOut_tlast;



wire	w_fb_CSI_TX_gen_hs;
wire	w_fb_CSI_TX_gen_vs;
wire	w_fb_CSI_TX_gen_ah;
wire	w_fb_CSI_TX_gen_de;
wire  [CSI_TX_NUM_CHANNEL-1:0]  w_fb_CSI_TX_gen_channel;
wire  [CSI_TX_NUM_CHANNEL-1:0]  w_fb_CSI_TX_gen_next_channel;
wire  [CSI_TX_NUM_CHANNEL-1:0]  w_fb_CSI_TX_gen_hs_ch;
wire  [CSI_TX_NUM_CHANNEL-1:0]  w_fb_CSI_TX_gen_vs_ch;

wire	w_fb_vga_gen_hs;
wire	w_fb_vga_gen_vs;
wire	w_fb_vga_gen_ah;
wire	w_fb_vga_gen_de;


wire   [2:0]          sg_cmd_channelId;
wire                  sg_cmd_valid;
wire                  sg_cmd_ready;
wire   [26:0]         sg_cmd_bytesDone;
wire                  sg_cmd_endOfPacket;
wire                  sg_cmd_completed;
wire                  sg_cmd_read;
wire                  sg_cmd_write;
wire                  sg_rsp_valid;
wire   [2:0]          sg_rsp_channelId;
wire   [31:0]         sg_rsp_srcAddress;
wire   [31:0]         sg_rsp_dstAddress;
wire   [25:0]         sg_rsp_bytes;
wire                  sg_rsp_last;
wire                  sg_rsp_stall;


wire [7*8-1:0]        sg_out_control;
wire [7*8-1:0]        sg_in_control;

wire [7:0] sg_in_control_ch0; //Video Stream In 0  
wire [7:0] sg_in_control_ch1; //Video Stream In 1 
wire [7:0] sg_in_control_ch2; //Video Stream In 2 
wire [7:0] sg_in_control_ch3; //Video Stream In 3 
wire [7:0] sg_in_control_ch4; //Video Stream Out (Main)
wire [7:0] sg_in_control_ch5; //Video Stream Out (overlay)
reg  [1:0] sg_in_control_ch6; //CSI TX Ch1    (Index of Descriptor Selection)

wire [7:0] sg_out_control_ch0; //Video Stream In 0 
wire [7:0] sg_out_control_ch1; //Video Stream In 1 
wire [7:0] sg_out_control_ch2; //Video Stream In 2 
wire [7:0] sg_out_control_ch3; //Video Stream In 3 
wire [7:0] sg_out_control_ch4; //Video Stream Out (Main)
wire [7:0] sg_out_control_ch5; //Video Stream Out (overlay)
wire [7:0] sg_out_control_ch6; //CSI TX Ch1


assign sg_in_control[0*8 +: 8] = sg_in_control_ch0;
assign sg_in_control[1*8 +: 8] = sg_in_control_ch1;
assign sg_in_control[2*8 +: 8] = sg_in_control_ch2;
assign sg_in_control[3*8 +: 8] = sg_in_control_ch3;
assign sg_in_control[4*8 +: 8] = sg_in_control_ch4;
assign sg_in_control[5*8 +: 8] = sg_in_control_ch5;
assign sg_in_control[6*8 +: 8] = sg_in_control_ch6; 

assign sg_out_control_ch0 = sg_out_control[0*8 +: 8];
assign sg_out_control_ch1 = sg_out_control[1*8 +: 8];
assign sg_out_control_ch2 = sg_out_control[2*8 +: 8];
assign sg_out_control_ch3 = sg_out_control[3*8 +: 8];
assign sg_out_control_ch4 = sg_out_control[4*8 +: 8];
assign sg_out_control_ch5 = sg_out_control[5*8 +: 8];
assign sg_out_control_ch6 = sg_out_control[6*8 +: 8];


assign sg_in_control_ch0  =  in_virtual_ch[0*8 +: 8];
assign sg_in_control_ch1  =  in_virtual_ch[1*8 +: 8];
assign sg_in_control_ch2  =  in_virtual_ch[2*8 +: 8];
assign sg_in_control_ch3  =  in_virtual_ch[3*8 +: 8];


always @(*) begin
    case (w_fb_CSI_TX_gen_next_channel)
        4'b0001: sg_in_control_ch6 = 2'd0;   // case 0
        4'b0010: sg_in_control_ch6 = 2'd1;   // case 1
        4'b0100: sg_in_control_ch6 = 2'd2;   // case 2
        4'b1000: sg_in_control_ch6 = 2'd3;   // case 2
        default: sg_in_control_ch6 = 2'd0; // default case
    endcase
end


reg [7:0] r_sg_out_control_ch0; //Video Stream In 0 
reg [7:0] r_sg_out_control_ch6; //Video Stream In 1 

always @(posedge in_vclk[0])
begin
    r_sg_out_control_ch0 <= sg_out_control_ch0;
    r_sg_out_control_ch6 <= sg_out_control_ch6;
    
end 

reg [1:0] r_fb_CSI_TX_gen_hs;
reg [3:0] r_i_ref_clk;
reg [31:0] count_line_rate;
reg [31:0] count_line_rate_log;


reg r_vga_gen_resetn_csiTX;
reg r_vga_gen_resetn_hdmi;


always @ (posedge out_tx_clk or posedge io_asyncReset)
begin
    if (io_asyncReset)
    begin
        r_vga_gen_resetn_csiTX <= 1'b0;
    end 
    else 
    begin
        r_vga_gen_resetn_csiTX <= start_vga_gen[0]; 
    end 

end 


always @ (posedge out_vclk or posedge io_asyncReset)
begin
    if (io_asyncReset)
    begin
        r_vga_gen_resetn_hdmi <= 1'b0;
    end 
    else 
    begin
        r_vga_gen_resetn_hdmi <= start_vga_gen[1]; 
    end 

end 




vga_gen_VirtualCh
#(
	.H_SyncPulse	(CSI_TX_HSP),
	.H_BackPorch	(CSI_TX_HBP),
	.H_ActivePix	(CSI_TX_MAX_HRES/CSI_TX_PIXEL_PER_CLK),
	.H_FrontPorch	(CSI_TX_HFP),
	.V_SyncPulse	(CSI_TX_VSP),
	.V_BackPorch	(CSI_TX_VBP),
	.V_ActivePix	(CSI_TX_MAX_VRES),
	.V_FrontPorch	(CSI_TX_VFP),
	.P_Cnt			(3'd1),
    .nCHANNEL       (CSI_TX_NUM_CHANNEL)
)
inst_fb_vga_gen_CSI_TX
(
	.in_pclk	(out_tx_clk),
	.in_rstn	(r_vga_gen_resetn_csiTX), 
    
    .in_enable  (1'b1),
	.out_hs		(w_fb_CSI_TX_gen_hs),
	.out_vs		(w_fb_CSI_TX_gen_vs),
	.out_de		(w_fb_CSI_TX_gen_ah),
	.out_valid	(w_fb_CSI_TX_gen_de),
	.out_x		(),
	.out_y		(),
    .out_next_Channel (w_fb_CSI_TX_gen_next_channel),
    .out_channel (w_fb_CSI_TX_gen_channel),
    .out_hs_ch   (w_fb_CSI_TX_gen_vs_ch),
    .out_vs_ch   (w_fb_CSI_TX_gen_hs_ch)    
);

    always @(posedge out_tx_clk or posedge io_asyncReset )
        begin
            if (io_asyncReset) 
            begin
                count_line_rate  <= 1'd0;
                count_line_rate_log<= 1'd0;
              
                r_i_ref_clk<= 'd0;
                r_fb_CSI_TX_gen_hs<='d0;
            end 
            else 
            begin
                r_i_ref_clk <= {r_i_ref_clk[2:0], i_ref_clk};
                r_fb_CSI_TX_gen_hs <= {r_fb_CSI_TX_gen_hs[0:0],w_fb_CSI_TX_gen_hs};
                
                if( (!r_i_ref_clk[3]) && r_i_ref_clk[2]   )
                begin
                    count_line_rate_log   <= count_line_rate;
                    count_line_rate  <= 1'd0;                    
                end 
                else 
                begin
                    if( (!r_fb_CSI_TX_gen_hs[1]) && r_fb_CSI_TX_gen_hs[0]   )
                    begin
                        count_line_rate <= count_line_rate + 'd1;
                    end
                end 
            end 
            
        end 



vga_gen_v2
#(
	.H_SyncPulse	(VIDEO_HSP),
	.H_BackPorch	(VIDEO_HBP),
	.H_ActivePix	(VIDEO_MAX_HRES),
	.H_FrontPorch	(VIDEO_HFP),
	.V_SyncPulse	(VIDEO_VSP),
	.V_BackPorch	(VIDEO_VBP),
	.V_ActivePix	(VIDEO_MAX_VRES),
	.V_FrontPorch	(VIDEO_VFP),
	.P_Cnt			(3'd4)
)
inst_fb_vga_gen_video
(
	.in_pclk	(out_vclk),
	.in_rstn	(~io_asyncReset ),//(r_vga_gen_resetn_hdmi), //
	.out_hs		(w_fb_vga_gen_hs),
	.out_vs		(w_fb_vga_gen_vs),
	.out_de		(w_fb_vga_gen_ah),
	.out_valid	(w_fb_vga_gen_de),
	.out_x		(),
	.out_y		()
);

genvar x;
generate 
	for(x=0; x<NUM_CSI_RX_IN; x=x+1)
	begin:dma_stream_in 
		
		localparam START_CAM_CSI_PIXEL_DATAWIDTH = CSI_RX_PIXEL_DATAWIDTH * (x);
		localparam END_CAM_CSI_PIXEL_DATAWIDTH   = CSI_RX_PIXEL_DATAWIDTH * (x+1);
		localparam START_CSI_RX_TOTAL_DATAWIDTH	 = CSI_RX_TOTAL_DATAWIDTH * (x);
		localparam END_CSI_RX_TOTAL_DATAWIDTH    = CSI_RX_TOTAL_DATAWIDTH * (x+1);
		
		localparam START_CSI_RX_TOTAL_DATAWIDTH_NB = CSI_RX_TOTAL_DATAWIDTH/8 * (x);
		localparam END_CSI_RX_TOTAL_DATAWIDTH_NB   = CSI_RX_TOTAL_DATAWIDTH/8 * (x+1);
		
	
		axi_streamin 
		#(
			.FRAME_COUNT(1*1920*1080)
		)
		inst_axi_streamin
		(
			.axi_clk(in_vclk[x]),
			.in_clk(in_vclk[x]),
			.rstn(1'b1),
			.i_ref_clk(i_ref_clk),
			.stream_en(start_dma_stream_in[x]),
		
		//Frame Size
			.x_size(11'd1920),	//h
			.y_size(11'd1080),	//v
		
			.in_de(in_de[x]),
			.in_hs(in_hs[x]),
			.in_vs(in_vs[x]),
			.in_rd_00(in_rd_00[END_CAM_CSI_PIXEL_DATAWIDTH-1  :START_CAM_CSI_PIXEL_DATAWIDTH]),
			.in_rd_01(in_rd_01[END_CAM_CSI_PIXEL_DATAWIDTH-1  :START_CAM_CSI_PIXEL_DATAWIDTH]),
			.in_rd_10(in_rd_10[END_CAM_CSI_PIXEL_DATAWIDTH-1  :START_CAM_CSI_PIXEL_DATAWIDTH]),
			.in_rd_11(in_rd_11[END_CAM_CSI_PIXEL_DATAWIDTH-1  :START_CAM_CSI_PIXEL_DATAWIDTH]),
			
			.out_tvalid(w_VideoFrameIn_tvalid[x]),
			.in_tready(w_VideoFrameIn_tready[x]),
			.out_tdata(w_VideoFrameIn_tdata[END_CSI_RX_TOTAL_DATAWIDTH-1:START_CSI_RX_TOTAL_DATAWIDTH]),
			.out_tkeep(w_VideoFrameIn_tkeep[END_CSI_RX_TOTAL_DATAWIDTH_NB-1:START_CSI_RX_TOTAL_DATAWIDTH_NB]),
			.out_tdest(w_VideoFrameIn_tdest[END_CSI_RX_TOTAL_DATAWIDTH_NB-1:START_CSI_RX_TOTAL_DATAWIDTH_NB]),
			.out_tlast(w_VideoFrameIn_tlast[x])
		
		);
	end
	
	for(x=0; x<NUM_CSI_TX_OUT; x=x+1)
	begin:dma_stream_csi_tx
	
		localparam START_CSI_TX_PIXEL_DATAWIDTH = CSI_TX_PIXEL_DATAWIDTH * (x);
		localparam END_CSI_TX_PIXEL_DATAWIDTH   = CSI_TX_PIXEL_DATAWIDTH * (x+1);
		localparam START_CSI_TX_TOTAL_DATAWIDTH	 = CSI_TX_TOTAL_DATAWIDTH * (x);
		localparam END_CSI_TX_TOTAL_DATAWIDTH    = CSI_TX_TOTAL_DATAWIDTH * (x+1);
			
		localparam START_CSI_TX_TOTAL_DATAWIDTH_NB = CSI_TX_TOTAL_DATAWIDTH/8 * (x);	
		localparam END_CSI_TX_TOTAL_DATAWIDTH_NB   = CSI_TX_TOTAL_DATAWIDTH/8 * (x+1);	
	
        axi_streamout_VirtualCh 
        #(
			.nCHANNEL(CSI_TX_NUM_CHANNEL)
        )
         inst_axi_streamout
		(
			.axi_clk(out_tx_clk),
			.out_clk(out_tx_clk),
			.rstn(1'b1),
			
			.stream_en(start_dma_stream_out[x+2]),
		
		//Frame Size
			.x_size(11'd1920),	//h
			.y_size(11'd1080),	//v
			
			.in_tvalid(w_VideoFrameOut_CSI_TX_tvalid[x]),
			.out_tready(w_VideoFrameOut_CSI_TX_tready[x]),
			.in_tdata(w_VideoFrameOut_CSI_TX_tdata[END_CSI_TX_TOTAL_DATAWIDTH-1:START_CSI_TX_TOTAL_DATAWIDTH]),
			.in_tkeep(w_VideoFrameOut_CSI_TX_tkeep[END_CSI_TX_TOTAL_DATAWIDTH_NB-1:START_CSI_TX_TOTAL_DATAWIDTH_NB]),
			.in_tdest(w_VideoFrameOut_CSI_TX_tdest[END_CSI_TX_TOTAL_DATAWIDTH_NB-1:START_CSI_TX_TOTAL_DATAWIDTH_NB]),
			.in_tlast(w_VideoFrameOut_CSI_TX_tlast[x]),
		
			.in_hs		(w_fb_CSI_TX_gen_hs),
			.in_vs		(w_fb_CSI_TX_gen_vs),
			.in_de		(w_fb_CSI_TX_gen_ah),
			.in_valid	(w_fb_CSI_TX_gen_de),
            .in_channel (w_fb_CSI_TX_gen_channel),
            .in_hs_ch   (w_fb_CSI_TX_gen_vs_ch),
            .in_vs_ch   (w_fb_CSI_TX_gen_hs_ch),
			
            .out_de   (out_csi_tx_de[x]),
			.out_valid(out_csi_tx_valid[x]),
			.out_hsync(),//out_csi_tx_hsync0[x]),
			.out_vsync(),//out_csi_tx_vsync0[x]),
            .out_hsync_ch({out_csi_tx_hsync3[x],out_csi_tx_hsync2[x],out_csi_tx_hsync1[x],out_csi_tx_hsync0[x]}),
            .out_vsync_ch({out_csi_tx_vsync3[x],out_csi_tx_vsync2[x],out_csi_tx_vsync1[x],out_csi_tx_vsync0[x]}),
            
            
			.out_rd_00(out_csi_tx_rd_00[END_CSI_TX_PIXEL_DATAWIDTH-1  :START_CSI_TX_PIXEL_DATAWIDTH]),
			.out_rd_01(out_csi_tx_rd_01[END_CSI_TX_PIXEL_DATAWIDTH-1  :START_CSI_TX_PIXEL_DATAWIDTH]),
			.out_rd_10(out_csi_tx_rd_10[END_CSI_TX_PIXEL_DATAWIDTH-1  :START_CSI_TX_PIXEL_DATAWIDTH]),
			.out_rd_11(out_csi_tx_rd_11[END_CSI_TX_PIXEL_DATAWIDTH-1  :START_CSI_TX_PIXEL_DATAWIDTH]),
			
			.in_tlast_count(),
			.in_tvalid_count()
		);	
	end 
	
	
	for(x=0; x<NUM_VIDEO_TX_OUT; x=x+1)
	begin:dma_stream_video_tx 
	
		localparam START_VIDEO_TX_PIXEL_DATAWIDTH  = VIDEO_TX_PIXEL_DATAWIDTH * (x);
		localparam END_VIDEO_TX_PIXEL_DATAWIDTH    = VIDEO_TX_PIXEL_DATAWIDTH * (x+1);
		localparam START_VIDEO_TX_TOTAL_DATAWIDTH  = VIDEO_TX_TOTAL_DATAWIDTH * (x);
		localparam END_VIDEO_TX_TOTAL_DATAWIDTH    = VIDEO_TX_TOTAL_DATAWIDTH * (x+1);
			
		localparam START_VIDEO_TX_TOTAL_DATAWIDTH_NB = VIDEO_TX_TOTAL_DATAWIDTH/8 * (x);	
		localparam END_VIDEO_TX_TOTAL_DATAWIDTH_NB   = VIDEO_TX_TOTAL_DATAWIDTH/8 * (x+1);	
	
		axi_streamout inst_axi_streamout
		(
			.axi_clk(out_vclk),
			.out_clk(out_vclk),
			.rstn(1'b1),
			
			.stream_en(start_dma_stream_out[x+0]),
		
		//Frame Size
			.x_size(11'd1920),	//h
			.y_size(11'd1080),	//v
			
			.in_tvalid(w_VideoFrameOut_tvalid[x]),
			.out_tready(w_VideoFrameOut_tready[x]),
			.in_tdata(w_VideoFrameOut_tdata[END_VIDEO_TX_TOTAL_DATAWIDTH-1   :START_VIDEO_TX_TOTAL_DATAWIDTH]),
			.in_tkeep(w_VideoFrameOut_tkeep[END_VIDEO_TX_TOTAL_DATAWIDTH_NB-1:START_VIDEO_TX_TOTAL_DATAWIDTH_NB]),
			.in_tdest(w_VideoFrameOut_tdest[END_VIDEO_TX_TOTAL_DATAWIDTH_NB-1:START_VIDEO_TX_TOTAL_DATAWIDTH_NB]),
			.in_tlast(w_VideoFrameOut_tlast[x]),
		
			.in_hs		(w_fb_vga_gen_hs),
			.in_vs		(w_fb_vga_gen_vs),
			.in_de		(w_fb_vga_gen_ah),
			.in_valid	(w_fb_vga_gen_de),
			
			
			.out_de   (out_video_de[x]),
			.out_valid(out_video_valid[x]),
			.out_hsync(out_video_hsync[x]),
			.out_vsync(out_video_vsync[x]),
			.out_rd_00(out_video_rd_00[END_VIDEO_TX_PIXEL_DATAWIDTH-1  :START_VIDEO_TX_PIXEL_DATAWIDTH]),
			.out_rd_01(out_video_rd_01[END_VIDEO_TX_PIXEL_DATAWIDTH-1  :START_VIDEO_TX_PIXEL_DATAWIDTH]),
			.out_rd_10(out_video_rd_10[END_VIDEO_TX_PIXEL_DATAWIDTH-1  :START_VIDEO_TX_PIXEL_DATAWIDTH]),
			.out_rd_11(out_video_rd_11[END_VIDEO_TX_PIXEL_DATAWIDTH-1  :START_VIDEO_TX_PIXEL_DATAWIDTH]),
			
			.in_tlast_count(),
			.in_tvalid_count()
		);	
	end 

endgenerate

dma_controller inst_dma(

//EfxDMA inst_dma(
////dma_oob_wrapper inst_dma(

	.clk(io_memoryClk),
	.reset(io_ddrMasterReset),
	.ctrl_clk(io_systemClk),
	.ctrl_reset(io_systemReset),


    //APB Slave
    .ctrl_PADDR			(dma_ctrl_apb_PADDR),
   	.ctrl_PSEL			(dma_ctrl_apb_PSEL),
   	.ctrl_PENABLE		(dma_ctrl_apb_PENABLE),
   	.ctrl_PREADY		(dma_ctrl_apb_PREADY),
   	.ctrl_PWRITE		(dma_ctrl_apb_PWRITE),
   	.ctrl_PWDATA		(dma_ctrl_apb_PWDATA),
   	.ctrl_PRDATA		(dma_ctrl_apb_PRDATA),
   	.ctrl_PSLVERROR		(dma_ctrl_apb_PSLVERROR),
   	.ctrl_interrupts 	(dma_interrupts),
    
	
	//axi interface
	`ifdef AXI_MEM_AXI4_ENABLE
    .read_arvalid		(read_arvalid	), //11
    .read_araddr		(read_araddr	),
    .read_arready		(read_arready	),
    .read_arregion		(read_arregion	),
    .read_arlen			(read_arlen		),
    .read_arsize		(read_arsize	),
    .read_arburst		(read_arburst	),
    .read_arlock		(read_arlock	),
    .read_arcache		(read_arcache	),
    .read_arqos			(read_arqos		),
    .read_arprot		(read_arprot	),
						 				
    .read_rready		(read_rready	), //5
    .read_rvalid		(read_rvalid	),
    .read_rdata			(read_rdata		),
    .read_rlast			(read_rlast		),
    .read_rresp			(read_rresp		),
						 				
    .write_awvalid		(write_awvalid	), //11
    .write_awready		(write_awready	),
    .write_awaddr		(write_awaddr	),
    .write_awregion		(write_awregion	),
    .write_awlen		(write_awlen	),
    .write_awsize		(write_awsize	),
    .write_awburst		(write_awburst	),
    .write_awlock		(write_awlock	),
    .write_awcache		(write_awcache	),
    .write_awqos		(write_awqos	),
    .write_awprot		(write_awprot	),
						 				
    .write_wvalid		(write_wvalid	), //5
    .write_wready		(write_wready	),
    .write_wdata		(write_wdata	),
    .write_wstrb		(write_wstrb	),
    .write_wlast		(write_wlast	),
						 				
    .write_bvalid		(write_bvalid	), //3
    .write_bready		(write_bready	),
    .write_bresp		(write_bresp	),
    
	`else
    .axi_arwvalid(dma_axi_arwvalid),
	.axi_arwready(dma_axi_arwready),
	.axi_arwaddr(dma_axi_arwaddr),
	
	.axi_arwregion(dma_axi_arwregion),
	.axi_arwlen(dma_axi_arwlen),
	.axi_arwsize(dma_axi_arwsize),
	.axi_arwburst(dma_axi_arwburst),
	.axi_arwlock(dma_axi_arwlock),
	.axi_arwcache(dma_axi_arwcache),
	.axi_arwqos(dma_axi_arwqos),
	.axi_arwprot(dma_axi_arwprot),
	.axi_arwwrite(dma_axi_arwwrite),
	
	.axi_wvalid(dma_axi_wvalid),
	.axi_wready(dma_axi_wready),
	.axi_wdata(dma_axi_wdata),
	.axi_wstrb(dma_axi_wstrb),
	.axi_wlast(dma_axi_wlast),
	
	.axi_bvalid(dma_axi_bvalid),
	.axi_bready(dma_axi_bready),
	.axi_bresp(dma_axi_bresp),
	
	.axi_rvalid(dma_axi_rvalid),
	.axi_rready(dma_axi_rready),
	.axi_rdata(dma_axi_rdata),
	.axi_rresp(dma_axi_rresp),
	.axi_rlast(dma_axi_rlast),
	`endif
  
	//Video Stream In
 
    .dat0_i_clk(in_vclk[0]),
    .dat0_i_reset(io_ddrMasterReset),
    
    .dat0_i_tvalid(w_VideoFrameIn_tvalid[0]),
    .dat0_i_tready(w_VideoFrameIn_tready[0]),
    .dat0_i_tdata(w_VideoFrameIn_tdata[CSI_RX_TOTAL_DATAWIDTH-1: 0]),
    .dat0_i_tkeep(w_VideoFrameIn_tkeep[CSI_RX_TOTAL_DATAWIDTH/8-1: 0]),
    .dat0_i_tdest(w_VideoFrameIn_tdest[CSI_RX_TOTAL_DATAWIDTH/8-1: 0]),
    .dat0_i_tlast(w_VideoFrameIn_tlast[0]),
	
	.dat1_i_clk(in_vclk[1]),
    .dat1_i_reset(io_ddrMasterReset),
    
    .dat1_i_tvalid(w_VideoFrameIn_tvalid[1]),
    .dat1_i_tready(w_VideoFrameIn_tready[1]),
    .dat1_i_tdata(w_VideoFrameIn_tdata[CSI_RX_TOTAL_DATAWIDTH*2-1: CSI_RX_TOTAL_DATAWIDTH*1]),
    .dat1_i_tkeep(w_VideoFrameIn_tkeep[CSI_RX_TOTAL_DATAWIDTH/8*2-1: CSI_RX_TOTAL_DATAWIDTH/8*1]),
    .dat1_i_tdest(w_VideoFrameIn_tdest[CSI_RX_TOTAL_DATAWIDTH/8*2-1: CSI_RX_TOTAL_DATAWIDTH/8*1]),
    .dat1_i_tlast(w_VideoFrameIn_tlast[1]),
	
	.dat2_i_clk(in_vclk[2]),
    .dat2_i_reset(io_ddrMasterReset),
    
    .dat2_i_tvalid(w_VideoFrameIn_tvalid[2]),
    .dat2_i_tready(w_VideoFrameIn_tready[2]),
    .dat2_i_tdata(w_VideoFrameIn_tdata[CSI_RX_TOTAL_DATAWIDTH*3-1: CSI_RX_TOTAL_DATAWIDTH*2]),
    .dat2_i_tkeep(w_VideoFrameIn_tkeep[CSI_RX_TOTAL_DATAWIDTH/8*3-1: CSI_RX_TOTAL_DATAWIDTH/8*2]),
    .dat2_i_tdest(w_VideoFrameIn_tdest[CSI_RX_TOTAL_DATAWIDTH/8*3-1: CSI_RX_TOTAL_DATAWIDTH/8*2]),
    .dat2_i_tlast(w_VideoFrameIn_tlast[2]),
	
	.dat3_i_clk(in_vclk[3]),
    .dat3_i_reset(io_ddrMasterReset),
    
    .dat3_i_tvalid(w_VideoFrameIn_tvalid[3]),
    .dat3_i_tready(w_VideoFrameIn_tready[3]),
    .dat3_i_tdata(w_VideoFrameIn_tdata[CSI_RX_TOTAL_DATAWIDTH*4-1: CSI_RX_TOTAL_DATAWIDTH*3]),
    .dat3_i_tkeep(w_VideoFrameIn_tkeep[CSI_RX_TOTAL_DATAWIDTH/8*4-1: CSI_RX_TOTAL_DATAWIDTH/8*3]),
    .dat3_i_tdest(w_VideoFrameIn_tdest[CSI_RX_TOTAL_DATAWIDTH/8*4-1: CSI_RX_TOTAL_DATAWIDTH/8*3]),
    .dat3_i_tlast(w_VideoFrameIn_tlast[3]),
	
	
	//Video Stream Out (Main)
	  
    .dat4_o_clk(out_vclk),
    .dat4_o_reset(io_ddrMasterReset),
  
    .dat4_o_tvalid(w_VideoFrameOut_tvalid[0]),
    .dat4_o_tready(w_VideoFrameOut_tready[0]),
    .dat4_o_tdata(w_VideoFrameOut_tdata[VIDEO_TX_TOTAL_DATAWIDTH*1-1   :VIDEO_TX_TOTAL_DATAWIDTH*0]),
    .dat4_o_tkeep(w_VideoFrameOut_tkeep[VIDEO_TX_TOTAL_DATAWIDTH/8*1-1 :VIDEO_TX_TOTAL_DATAWIDTH/8*0]),
    .dat4_o_tdest(w_VideoFrameOut_tdest[VIDEO_TX_TOTAL_DATAWIDTH/8*1-1 :VIDEO_TX_TOTAL_DATAWIDTH/8*0]),
    .dat4_o_tlast(w_VideoFrameOut_tlast[0] ),
    
	
	//Video Stream Out (overlay)
	.dat5_o_clk(out_vclk),
	.dat5_o_reset(io_ddrMasterReset),
	
	.dat5_o_tvalid(w_VideoFrameOut_tvalid[1]),
	.dat5_o_tready(w_VideoFrameOut_tready[1]),
	.dat5_o_tdata (w_VideoFrameOut_tdata[VIDEO_TX_TOTAL_DATAWIDTH*2-1   :VIDEO_TX_TOTAL_DATAWIDTH*1]),
	.dat5_o_tkeep (w_VideoFrameOut_tkeep[VIDEO_TX_TOTAL_DATAWIDTH/8*2-1 :VIDEO_TX_TOTAL_DATAWIDTH/8*1]),
	.dat5_o_tdest (w_VideoFrameOut_tdest[VIDEO_TX_TOTAL_DATAWIDTH/8*2-1 :VIDEO_TX_TOTAL_DATAWIDTH/8*1]),
	.dat5_o_tlast (w_VideoFrameOut_tlast[1]),
	
	//CSI TX Ch1
	.dat6_o_clk(out_tx_clk),
	.dat6_o_reset(io_ddrMasterReset),
	
	.dat6_o_tvalid(w_VideoFrameOut_CSI_TX_tvalid[0]),
	.dat6_o_tready(w_VideoFrameOut_CSI_TX_tready[0]),
	.dat6_o_tdata (w_VideoFrameOut_CSI_TX_tdata[CSI_TX_TOTAL_DATAWIDTH*1-1   :CSI_TX_TOTAL_DATAWIDTH*0]),
	.dat6_o_tkeep (w_VideoFrameOut_CSI_TX_tkeep[CSI_TX_TOTAL_DATAWIDTH/8*1-1 :CSI_TX_TOTAL_DATAWIDTH/8*0]),
	.dat6_o_tdest (w_VideoFrameOut_CSI_TX_tdest[CSI_TX_TOTAL_DATAWIDTH/8*1-1 :CSI_TX_TOTAL_DATAWIDTH/8*0]),
	.dat6_o_tlast (w_VideoFrameOut_CSI_TX_tlast[0]),
    
    .sg_cmd_channelId     (sg_cmd_channelId               ),
    .sg_cmd_valid         (sg_cmd_valid                   ),
    .sg_cmd_ready         (sg_cmd_ready                   ),
    .sg_cmd_bytesDone     (sg_cmd_bytesDone               ),
    .sg_cmd_endOfPacket   (sg_cmd_endOfPacket             ),
    .sg_cmd_completed     (sg_cmd_completed               ),
    .sg_cmd_read          (sg_cmd_read                    ),
    .sg_cmd_write         (sg_cmd_write                   ),
    .sg_rsp_valid         (sg_rsp_valid                   ),
    .sg_rsp_channelId     (sg_rsp_channelId               ),
    .sg_rsp_srcAddress    (sg_rsp_srcAddress              ),
    .sg_rsp_dstAddress    (sg_rsp_dstAddress              ),
    .sg_rsp_bytes         (sg_rsp_bytes                   ),
    .sg_rsp_last          (sg_rsp_last                    ),
    .sg_rsp_stall         (sg_rsp_stall                   )
	    
);


custom_sg_linked_list  #(
    .NUM_CHANNEL     (7),
    .NUM_DESCRIPTIOR (4),
    .CTRL_WIDTH      (8)
    
)sgll_inst(
  .clk                  (io_memoryClk    ),
  .reset                (io_ddrMasterReset      ),
  .ctrl_clk             (io_systemClk         ),
  .ctrl_reset           (io_systemReset       ),
  
  .sg_cmd_valid         (sg_cmd_valid         ),
  .sg_cmd_ready         (sg_cmd_ready         ),
  .sg_cmd_read          (sg_cmd_read          ),
  .sg_cmd_write         (sg_cmd_write         ),
  .sg_cmd_channelId     (sg_cmd_channelId     ),
  .sg_cmd_bytesDone     (sg_cmd_bytesDone     ),
  .sg_cmd_endOfPacket   (sg_cmd_endOfPacket   ),
  .sg_cmd_completed     (sg_cmd_completed     ),
  .sg_rsp_valid         (sg_rsp_valid         ),
  .sg_rsp_channelId     (sg_rsp_channelId     ),
  .sg_rsp_srcAddress    (sg_rsp_srcAddress    ),
  .sg_rsp_dstAddress    (sg_rsp_dstAddress    ),
  .sg_rsp_bytes         (sg_rsp_bytes         ),
  .sg_rsp_last          (sg_rsp_last          ),
  .sg_rsp_stallout      (sg_rsp_stall         ),

  .sg_out_control       (sg_out_control),
  .sg_in_control        (sg_in_control),
  
  //apb3 port
  .PADDR        (dma_sg_apb_PADDR),
  .PSEL         (dma_sg_apb_PSEL     ),
  .PENABLE      (dma_sg_apb_PENABLE  ),
  .PREADY       (dma_sg_apb_PREADY   ),
  .PWRITE       (dma_sg_apb_PWRITE   ),
  .PWDATA       (dma_sg_apb_PWDATA   ),
  .PRDATA       (dma_sg_apb_PRDATA   ),
  .PSLVERROR    (dma_sg_apb_PSLVERROR)
  
  
);




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
