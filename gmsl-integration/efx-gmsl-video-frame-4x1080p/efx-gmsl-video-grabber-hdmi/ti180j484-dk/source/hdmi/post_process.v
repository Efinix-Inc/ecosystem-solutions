////////////////////////////////////////////////////////////////////////////
//           _____       
//          / _______    Copyright (C) 2013-2021 Efinix Inc. All rights reserved.
//         / /       \   
//        / /  ..    /   post_process.v
//       / / .'     /    
//    __/ /.'      /     Description:
//   __   \       /       HDMI_post_process module for converting raw video of dma frame buffer to yuv video (HDMI)   
//  /_/ /\ \_____/ /      and it is used on TI180M484 dev kit OOB design
// ____/  \_______/      
//
// ***********************************************************************
// Revisions:
// 1.0 Initial rev

/////////////////////////////////////////////////////////////////////////////////


//inst_mipi_rx_csi/w_dbg_rxd[x]~FF
// F225 TX PS
// 0	X
// 45	X
// 90	
// 135
// 180
// 225	X
// 270	X
// 315
/*
for byte clock / slow clock output, set PCR_DLY_SEL* to 4
for data fastclk, set to 0 phase shift and set PCR_DLY_SEL* to 6
for clock fastclk, set to 180 phase shift and set PCR_DLY_SEL* to 0 (no need to change).
*/
// 0000 0000 0110 0000 0000
// report_timing -setup -hold -npath 100 -file io_timing.txt -from [get_cells {r_mipi_txd0_HS_OUT_3P[*]~FF r_mipi_txd1_HS_OUT_3P[*]~FF}] -to [get_ports {mipi_txd0_HS_OUT[*] mipi_txd1_HS_OUT[*]}]

// Required:	1920x1080x8x6x30 =	2985984000
// Theoretical:	400x1000x1000x16 =	6400000000
// Measured:	Max write =			4088000000
//				Max red =			4080000000


module hdmi_post_process
(

	i_resetn, 
	i_clk,

    line_sel,
    pixel_sel,
    
    in_de,			
	in_valid,		
	in_hs,			
	in_vs,			
	in_data,
	
	yuv_vs,
	yuv_hs,
	yuv_de,
	yuv_data,
	
	o_led,
	
);

input 	i_resetn;
input 	i_clk;


input   [1:0]   line_sel;
input   [2:0]   pixel_sel;


input   in_de;			
input 	in_valid;		
input 	in_hs;		
input 	in_vs;			
input 	[31:0] in_data;	


// YCbCr video output
output 	reg		yuv_vs;
output 	reg		yuv_hs;
output 	reg		yuv_de;
output 	reg		[15:0]	yuv_data;

output	wire	o_led;




wire	w_sysclk_arstn;
wire	w_sysclk_arst;


reg		[10:0]	r_gain_x;
reg		[10:0]	r_gain_y;
reg		r_gain_vs_1P;
reg		r_gain_vs_2P;
reg		r_gain_de_1P;

wire 	w_unpack_out_vs;
wire 	w_unpack_out_de;
wire 	w_unpack_out_hs;
wire 	w_unpack_out_valid;
wire 	[15:0]	w_unpack_out_data;
wire 	[10:0]	w_unpack_out_x;
wire 	[10:0]	w_unpack_out_y;

////////////////////////////////////////////////////////////////
// Debayer
wire	w_debayer_lb_hs;
wire	w_debayer_lb_vs;
wire	w_debayer_lb_de;
wire	w_debayer_lb_valid;
wire	[15:0]	w_debayer_lb_p_11;
wire	[15:0]	w_debayer_lb_p_00;
wire	[15:0]	w_debayer_lb_p_01;

wire	w_debayer_hs;
wire	w_debayer_vs;
wire	w_debayer_de;
wire	w_debayer_valid;
wire	[10:0]	w_debayer_x;
wire	[10:0]	w_debayer_y;
wire	[15:0]	w_debayer_r;
wire	[15:0]	w_debayer_g;
wire	[15:0]	w_debayer_b;

wire	w_fb_vga_gen_vs;
wire	w_fb_vga_gen_hs;
wire	w_fb_vga_gen_de;
wire	w_fb_vga_gen_valid;
wire	[10:0]	w_fb_vga_gen_x;
wire	[10:0]	w_fb_vga_gen_y;
wire	[10:0]	w_fb_vga_dbg_y;

wire	w_fb_de;
wire	w_fb_valid;
wire	w_fb_hs;
wire	w_fb_vs;
wire	[7:0]	w_fb_r;
wire	[7:0]	w_fb_g;
wire	[7:0]	w_fb_b;
wire	[31:0]	w_fb_data;

wire	w_unpack_dp_vs;
wire	w_unpack_dp_hs;
wire	w_unpack_dp_de;
wire	w_unpack_dp_valid;
wire	[10:0]	w_unpack_dp_x;
wire	[10:0]	w_unpack_dp_y;
wire	[23:0]	w_unpack_dp_data;

reg		[10:0]	r_fb_x;
reg		[10:0]	r_fb_y;
reg		r_fb_de_1P;

////////////////////////////////////////////////////////////////
/* RGB to YCbCr */
reg		r_yuv_cnt;
reg		r_yuv_vs_1P ;
reg		r_yuv_hs_1P ;
reg		r_yuv_de_1P ;
reg		r_yuv_vs_2P ;
reg		r_yuv_hs_2P ;
reg		r_yuv_de_2P ;
reg		r_yuv_vs_3P ;
reg		r_yuv_hs_3P ;
reg		r_yuv_de_3P ;
reg		r_yuv_vs_4P ;
reg		r_yuv_hs_4P ;
reg		r_yuv_de_4P ;
reg		r_yuv_vs_5P ;
reg		r_yuv_hs_5P ;
reg		r_yuv_de_5P ;
reg		r_yuv_vs_6P ;
reg		r_yuv_hs_6P ;
reg		r_yuv_de_6P ;
reg		r_yuv_vs_7P ;
reg		r_yuv_hs_7P ;
reg		r_yuv_de_7P ;
reg		[7:0]	r_r_in;
reg		[7:0]	r_g_in;
reg		[7:0]	r_b_in;
reg		[15:0]	r_yuv_data_6P;
reg 	[11:0] 	r_yuv_x_cnt;
reg 	[11:0] 	r_yuv_frame_cnt;
reg		r_yuv_hs_out;
reg		r_yuv_vs_out;

wire	w_de_out;
wire 	[7:0]	w_y_out;
wire 	[7:0]	w_cb_out;
wire 	[7:0]	w_cr_out;

//////////////////////////////////////////////////////////////


assign	w_fb_de		= in_de;		
assign	w_fb_valid  = in_valid;
assign	w_fb_hs     = in_hs;		
assign	w_fb_vs     = in_vs;		
assign	w_fb_data   = in_data;
assign  w_sysclk_arstn =	i_resetn;



always@(negedge w_sysclk_arstn or posedge i_clk)
begin
	if (~w_sysclk_arstn)
	begin
		r_fb_de_1P	<= 1'b0;
		r_fb_x		<= {11{1'b0}};
		r_fb_y		<= {11{1'b0}};
	end
	else
	begin
		r_fb_de_1P	<= w_fb_de;

		if (~w_fb_de && r_fb_de_1P)
			r_fb_y	<= r_fb_y + 1'b1;
			
		if (~w_fb_vs)
			r_fb_y	<= {11{1'b0}};
		
		if (w_fb_de)
		begin
			if (w_fb_valid)
				r_fb_x	<= r_fb_x + 1'b1;
		end
		else
			r_fb_x		<= {11{1'b0}};
	end
end

/* Unpack 32 bit data to 16 bit data */
data_unpack
#(
	.PIXEL_BIT	(8'd16),
	.PACK_BIT	(8'd32),
	.FIFO_WIDTH	(4'd10)
)
inst_data_unpack_4to2
(
	.in_pclk	(i_clk),
	.in_rstn	(w_sysclk_arstn),
	
	.in_x		(r_fb_x		),
	.in_y		(r_fb_y		),
	.in_valid	(w_fb_valid	),
	.in_de		(w_fb_de	),
	.in_hs		(w_fb_hs	),
	.in_vs		(w_fb_vs	),
	.in_data	(w_fb_data	),

	.out_x		(w_unpack_out_x		),
	.out_y		(w_unpack_out_y		),
	.out_valid	(w_unpack_out_valid	),
	.out_de		(w_unpack_out_de	),
	.out_hs		(w_unpack_out_hs	),
	.out_vs		(w_unpack_out_vs	),
	.out_data	(w_unpack_out_data	)
);

/* 3 lines buffer for debayer */
line_buffer
#(
	.P_DEPTH	(8),
	.X_CNT_WIDTH(10)
)
inst_line_buffer_debayer
(
	.i_arstn	(w_sysclk_arstn),
	.i_pclk		(i_clk),
	
	.i_vsync	(w_unpack_out_vs	),
	.i_hsync	(w_unpack_out_hs	),
	.i_de		(w_unpack_out_de	),
	.i_valid	(w_unpack_out_valid	),
	.i_p		(w_unpack_out_data	),
	
	.o_vsync	(w_debayer_lb_vs),
	.o_hsync	(w_debayer_lb_hs),
	.o_de		(w_debayer_lb_de),
	.o_valid	(w_debayer_lb_valid),
	.o_p_11		(w_debayer_lb_p_11),
	.o_p_00		(w_debayer_lb_p_00),
	.o_p_01		(w_debayer_lb_p_01)
);



reg	r_debayer_lb_hs_sel;
reg	r_debayer_lb_vs_sel;
reg	r_debayer_lb_de_sel;
reg	r_debayer_lb_valid_sel;
reg	[15:0]	r_debayer_lb_p_11_sel;
reg	[15:0]	r_debayer_lb_p_00_sel;
reg	[15:0]	r_debayer_lb_p_01_sel;


always@(negedge w_sysclk_arstn or posedge i_clk)
begin
	if (~w_sysclk_arstn)
	begin
		r_debayer_lb_hs_sel	<= 1'b0;
        r_debayer_lb_vs_sel	<= 1'b0;
        r_debayer_lb_de_sel	<= 1'b0;
        r_debayer_lb_valid_sel	<= 1'b0;
        
        
		r_debayer_lb_p_00_sel		<= {15{1'b0}};
		r_debayer_lb_p_01_sel		<= {15{1'b0}};
        r_debayer_lb_p_11_sel		<= {15{1'b0}};
        
	end
	else
	begin
    
        r_debayer_lb_hs_sel	<= w_debayer_lb_hs;
        r_debayer_lb_vs_sel	<= w_debayer_lb_vs;
        r_debayer_lb_de_sel	<= w_debayer_lb_de;
        r_debayer_lb_valid_sel	<= w_debayer_lb_valid;
		
        case ({pixel_sel[0],line_sel})
        3'd0: r_debayer_lb_p_00_sel <= w_debayer_lb_p_00;
        3'd1: r_debayer_lb_p_00_sel <= w_debayer_lb_p_01;
        3'd2: r_debayer_lb_p_00_sel <= w_debayer_lb_p_00;
        3'd3: r_debayer_lb_p_00_sel <= w_debayer_lb_p_11;
        3'd4: r_debayer_lb_p_00_sel <= {w_debayer_lb_p_00[7:0], w_debayer_lb_p_00[15:8]};
        3'd5: r_debayer_lb_p_00_sel <= {w_debayer_lb_p_01[7:0], w_debayer_lb_p_01[15:8]};
        3'd6: r_debayer_lb_p_00_sel <= {w_debayer_lb_p_00[7:0], w_debayer_lb_p_00[15:8]};
        3'd7: r_debayer_lb_p_00_sel <= {w_debayer_lb_p_11[7:0], w_debayer_lb_p_11[15:8]};
        endcase 
        
        case ({pixel_sel[1],line_sel})
        3'd0: r_debayer_lb_p_01_sel <= w_debayer_lb_p_01;
        3'd1: r_debayer_lb_p_01_sel <= w_debayer_lb_p_00;
        3'd2: r_debayer_lb_p_01_sel <= w_debayer_lb_p_11;
        3'd3: r_debayer_lb_p_01_sel <= w_debayer_lb_p_01;
        3'd4: r_debayer_lb_p_01_sel <= {w_debayer_lb_p_01[7:0], w_debayer_lb_p_01[15:8]};
        3'd5: r_debayer_lb_p_01_sel <= {w_debayer_lb_p_00[7:0], w_debayer_lb_p_00[15:8]};
        3'd6: r_debayer_lb_p_01_sel <= {w_debayer_lb_p_11[7:0], w_debayer_lb_p_11[15:8]};
        3'd7: r_debayer_lb_p_01_sel <= {w_debayer_lb_p_01[7:0], w_debayer_lb_p_01[15:8]};
        endcase 
          
        case ({pixel_sel[2],line_sel})
        3'd0: r_debayer_lb_p_11_sel <= w_debayer_lb_p_11;
        3'd1: r_debayer_lb_p_11_sel <= w_debayer_lb_p_11;
        3'd2: r_debayer_lb_p_11_sel <= w_debayer_lb_p_01;
        3'd3: r_debayer_lb_p_11_sel <= w_debayer_lb_p_00;
        3'd4: r_debayer_lb_p_11_sel <= {w_debayer_lb_p_11[7:0], w_debayer_lb_p_11[15:8]};
        3'd5: r_debayer_lb_p_11_sel <= {w_debayer_lb_p_11[7:0], w_debayer_lb_p_11[15:8]};
        3'd6: r_debayer_lb_p_11_sel <= {w_debayer_lb_p_01[7:0], w_debayer_lb_p_01[15:8]};
        3'd7: r_debayer_lb_p_11_sel <= {w_debayer_lb_p_00[7:0], w_debayer_lb_p_00[15:8]};
        endcase 
	end
end


/* Debayer */
raw_to_rgb
#(
	.P_DEPTH	(8),
	.LEGACY		(1'b1)
)
inst_raw_to_rgb
(
	.i_arstn	(w_sysclk_arstn),
	.i_pclk		(i_clk),
	
	.i_r_addn	(1'b0),
	.i_r_gain	(8'b0),
	.i_r_shift	(1'b0),
	.i_g_addn	(1'b0),
	.i_g_gain	(8'b0),
	.i_g_shift	(1'b0),
	.i_b_addn	(1'b0),
	.i_b_gain	(8'b0),
	.i_b_shift	(1'b0),
	
	.i_vsync	(r_debayer_lb_vs_sel),
	.i_hsync	(r_debayer_lb_hs_sel),
	.i_de		(r_debayer_lb_de_sel),
	.i_valid	(r_debayer_lb_valid_sel),
	.i_p_11		(r_debayer_lb_p_11_sel),//({w_debayer_lb_p_00[7:0], w_debayer_lb_p_00[15:8]}),// (w_debayer_lb_p_11), 
	.i_p_00		(r_debayer_lb_p_00_sel),//({w_debayer_lb_p_11[7:0], w_debayer_lb_p_11[15:8]}),//(w_debayer_lb_p_00),
	.i_p_01		(r_debayer_lb_p_01_sel),//({w_debayer_lb_p_01[7:0], w_debayer_lb_p_01[15:8]}),//(w_debayer_lb_p_01),
	
	.o_dbg_valid			(),
	.o_dbg_bayer_11_01_0P_0	(),
	.o_dbg_bayer_11_01_0P_1	(),
	.o_dbg_bayer_00_01_0P_0	(),
	.o_dbg_bayer_00_01_0P_1	(),
	.o_dbg_bayer_01_01_0P_0	(),
	.o_dbg_bayer_01_01_0P_1	(),
	.o_dbg_bayer_11_00_1P_0	(),
	.o_dbg_bayer_11_00_1P_1	(),
	.o_dbg_bayer_00_00_1P_0	(),
	.o_dbg_bayer_00_00_1P_1	(),
	.o_dbg_bayer_01_00_1P_0	(),
	.o_dbg_bayer_01_00_1P_1	(),
	.o_dbg_bayer_11_11_2P_0	(),
	.o_dbg_bayer_11_11_2P_1	(),
	.o_dbg_bayer_00_11_2P_0	(),
	.o_dbg_bayer_00_11_2P_1	(),
	.o_dbg_bayer_01_11_2P_0	(),
	.o_dbg_bayer_01_11_2P_1	(),
	
	.o_vsync	(w_debayer_vs),
	.o_hsync	(w_debayer_hs),
	.o_de		(w_debayer_de),
	.o_valid	(w_debayer_valid),
	.o_x_cnt	(w_debayer_x),
	.o_y_cnt	(w_debayer_y),
	.o_r		(w_debayer_r),
	.o_g		(w_debayer_g),
	.o_b		(w_debayer_b)
    //.o_r		(),
	//.o_g		(),
	//.o_b		()
);

//assign w_debayer_r =  w_debayer_x;
//assign w_debayer_g =  w_debayer_x;
//assign w_debayer_b =  w_debayer_y;


/* Unpack 48 bit data to 24 bit data */
data_unpack
#(
	.PIXEL_BIT	(8'd24),
	.PACK_BIT	(8'd48),
	.FIFO_WIDTH	(4'd11)
)
inst_data_unpack_2to1
(
	.in_pclk	(i_clk),
	.in_rstn	(w_sysclk_arstn),
	
	.in_x		(w_debayer_x		),
	.in_y		(w_debayer_y		),
	.in_valid	(w_debayer_valid	),
	.in_de		(w_debayer_de		),
	.in_hs		(w_debayer_hs		),
	.in_vs		(w_debayer_vs		),
	.in_data	({w_debayer_r[15:8], w_debayer_g[15:8], w_debayer_b[15:8], w_debayer_r[7:0], w_debayer_g[7:0], w_debayer_b[7:0]}),
    //.in_data	({w_debayer_g[15:8], w_debayer_b[15:8], w_debayer_r[15:8], w_debayer_g[7:0], w_debayer_b[7:0], w_debayer_r[7:0]}),   //r g b 

	.out_x		(w_unpack_dp_x		),
	.out_y		(w_unpack_dp_y		),
	.out_valid	(w_unpack_dp_valid	),
	.out_de		(w_unpack_dp_de		),
	.out_hs		(w_unpack_dp_hs		),
	.out_vs		(w_unpack_dp_vs		),
	.out_data	(w_unpack_dp_data	)
//	.out_data	()
);

//assign	w_unpack_dp_data = {w_unpack_dp_x[7:0] + w_unpack_dp_y[7:0], w_unpack_dp_y[7:0], w_unpack_dp_x[7:0]};

/* RGB to YCbCr */

/*
color_coding_converter
#(
	.R_DEPTH(8),
	.G_DEPTH(8),
	.B_DEPTH(8),
	.Y_DEPTH(8),
	.U_DEPTH(8),
	.V_DEPTH(8),
	
	.ROM_A00("./rtl/hdmi/rom_a00.mem"),
	.ROM_A01("./rtl/hdmi/rom_a01.mem"),
	.ROM_A02("./rtl/hdmi/rom_a02.mem"),
	.ROM_A10("./rtl/hdmi/rom_a10.mem"),
	.ROM_A11("./rtl/hdmi/rom_a11.mem"),
	.ROM_A12("./rtl/hdmi/rom_a12.mem"),
	.ROM_A20("./rtl/hdmi/rom_a20.mem"),
	.ROM_A21("./rtl/hdmi/rom_a21.mem"),
	.ROM_A22("./rtl/hdmi/rom_a22.mem")
)
inst_RGB_to_YCbCr_in0
(                                                                    
	.i_arst		(w_sysclk_arst	),                                               
	.i_pclk		(i_clk		), 
		
	.i_rgb2yuv_de	(w_unpack_dp_valid		),
	.i_rgb2yuv_r	(w_unpack_dp_data[23:16]),
	.i_rgb2yuv_g	(w_unpack_dp_data[15:8]	),
	.i_rgb2yuv_b	(w_unpack_dp_data[7:0]	),
	.o_rgb2yuv_de	(w_de_out	),
	.o_rgb2yuv_y	(w_y_out	),
	.o_rgb2yuv_u	(w_cb_out	),
	.o_rgb2yuv_v	(w_cr_out	),
	
	.i_yuv2rgb_de	(1'b0),
	.i_yuv2rgb_y	(8'b0),
	.i_yuv2rgb_u	(8'b0),
	.i_yuv2rgb_v	(8'b0),
	.o_yuv2rgb_de	(),
	.o_yuv2rgb_r	(),	
	.o_yuv2rgb_g	(),
	.o_yuv2rgb_b	()
);
*/

     	// 5 RL
		color_coding_converter
		#(
			.Y_OFFSET	(8'd16),
			.ROM_A00	("../../source/mif/yuv/rom_a00.mem"),
			.ROM_A01	("../../source/mif/yuv/rom_a01.mem"),
			.ROM_A02	("../../source/mif/yuv/rom_a02.mem"),
			.ROM_A10	("../../source/mif/yuv/rom_a10.mem"),
			.ROM_A11	("../../source/mif/yuv/rom_a11.mem"),
			.ROM_A12	("../../source/mif/yuv/rom_a12.mem"),
			.ROM_A20	("../../source/mif/yuv/rom_a20.mem"),
			.ROM_A21	("../../source/mif/yuv/rom_a21.mem"),
			.ROM_A22	("../../source/mif/yuv/rom_a22.mem")
		)
		inst_RGB_to_YCbCr_in0
		(
			.i_arst	(w_sysclk_arst),
			.i_pclk	(i_clk),
			.i_en	(1'b1),
			
            .i_rgb2yuv_de	(w_unpack_dp_valid		),
            .i_rgb2yuv_r	(w_unpack_dp_data[23:16]),
            .i_rgb2yuv_g	(w_unpack_dp_data[15:8]	),
            .i_rgb2yuv_b	(w_unpack_dp_data[7:0]	),
			//.o_rgb2yuv_de	(w_uvc_de),
			//.o_rgb2yuv_y	(w_uvc_y[7:0]),
			//.o_rgb2yuv_u	(w_uvc_u[7:0]),
			//.o_rgb2yuv_v	(w_uvc_v[7:0]),
            
            .o_rgb2yuv_de	(w_de_out	),
            .o_rgb2yuv_y	(w_y_out	),
            .o_rgb2yuv_u	(w_cb_out	),
            .o_rgb2yuv_v	(w_cr_out	),
			
			.i_yuv2rgb_de	(1'b0),
			.i_yuv2rgb_y	('b0),
			.i_yuv2rgb_u	('b0),
			.i_yuv2rgb_v	('b0),
			.o_yuv2rgb_de	(),
			.o_yuv2rgb_r	(),
			.o_yuv2rgb_g	(),
			.o_yuv2rgb_b	()
		);


/* Remap 2 pixels per clock to odd and even yuv pixels */
always @(posedge i_clk) 
begin 
    if(~w_sysclk_arstn)
	begin		
		r_yuv_cnt		<= 1'b0;
		r_yuv_vs_1P     <= 1'b0;
		r_yuv_hs_1P     <= 1'b0;
		r_yuv_de_1P     <= 1'b0;
		r_yuv_vs_2P     <= 1'b0;
		r_yuv_hs_2P     <= 1'b0;
		r_yuv_de_2P     <= 1'b0;
		r_yuv_vs_3P     <= 1'b0;
		r_yuv_hs_3P     <= 1'b0;
		r_yuv_de_3P     <= 1'b0;
		r_yuv_vs_4P     <= 1'b0;
		r_yuv_hs_4P     <= 1'b0;
		r_yuv_de_4P     <= 1'b0;
		r_yuv_vs_5P     <= 1'b0;
		r_yuv_hs_5P     <= 1'b0;
		r_yuv_de_5P     <= 1'b0;
		r_yuv_vs_6P     <= 1'b0;
		r_yuv_hs_6P     <= 1'b0;
		r_yuv_de_6P     <= 1'b0;
		r_yuv_vs_7P     <= 1'b0;
		r_yuv_hs_7P     <= 1'b0;
		r_yuv_de_7P     <= 1'b0;		
		r_yuv_x_cnt		<= 11'b0;
		r_yuv_frame_cnt	<= 11'b0;
		r_yuv_hs_out    <= 1'b0;
		r_yuv_vs_out    <= 1'b0;		
		r_yuv_data_6P	<= 16'b0;
	end
	else 
	begin
		r_yuv_vs_1P     <= w_unpack_dp_vs ;
		r_yuv_hs_1P     <= w_unpack_dp_hs ;
		r_yuv_vs_2P     <= r_yuv_vs_1P ;
		r_yuv_hs_2P     <= r_yuv_hs_1P ;
		r_yuv_vs_3P     <= r_yuv_vs_2P ;
		r_yuv_hs_3P     <= r_yuv_hs_2P ;
		r_yuv_vs_4P     <= r_yuv_vs_3P ;
		r_yuv_hs_4P     <= r_yuv_hs_3P ;
		r_yuv_vs_5P     <= r_yuv_vs_4P ;
		r_yuv_hs_5P     <= r_yuv_hs_4P ;
		r_yuv_vs_6P     <= r_yuv_vs_5P ;
		r_yuv_hs_6P     <= r_yuv_hs_5P ;
		r_yuv_de_6P     <= w_de_out ;
		r_yuv_vs_7P     <= r_yuv_vs_6P ;
		r_yuv_hs_7P     <= r_yuv_hs_6P ;
		
		if (w_de_out)
		begin			
			r_yuv_cnt	<= ~r_yuv_cnt;			
			r_yuv_x_cnt	<= r_yuv_x_cnt + 1'b1;
		end
		else
		begin			
			r_yuv_cnt	<= 1'b0;
			r_yuv_x_cnt	<= 11'b0;
		end
		
		if (r_yuv_cnt)
			r_yuv_data_6P	<= {w_cr_out, w_y_out};
		else
			r_yuv_data_6P	<= {w_cb_out, w_y_out};
				
		yuv_vs  	<= ~r_yuv_vs_6P;
		yuv_hs  	<= ~r_yuv_hs_6P;
		yuv_de  	<= r_yuv_de_6P;
		yuv_data	<= r_yuv_data_6P;
		
		if (~r_yuv_vs_6P && r_yuv_vs_7P)
			r_yuv_frame_cnt	<= r_yuv_frame_cnt + 1'b1;
	end
end

assign	o_led	= r_yuv_frame_cnt[6];

endmodule
