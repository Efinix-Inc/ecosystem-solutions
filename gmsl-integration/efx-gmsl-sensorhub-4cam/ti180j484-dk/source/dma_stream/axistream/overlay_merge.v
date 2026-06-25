////////////////////////////////////////////////////////////////////////////
//           _____       
//          / _______    Copyright (C) 2013-2022 Efinix Inc. All rights reserved.
//         / /       \   
//        / /  ..    /   overlay_merge.v
//       / / .'     /    
//    __/ /.'      /     Description:
//   __   \       /       Module merage streaming signal and overlay streaming signal
//  /_/ /\ \_____/ /     
// ____/  \_______/      
//
// ***********************************************************************
// Revisions:
// 1.0 Initial rev

/////////////////////////////////////////////////////////////////////////////////

module overlay_merge
#(
    parameter VIDEOOUT_WIDTH = 32
)
(
input 			out_clk,
input 			rstn,

input   	    in_de,
input		    in_valid,
input   	    in_hsync,
input   	    in_vsync,
input	[7:0]	in_rd_00,
input	[7:0]   in_rd_01,
input	[7:0]   in_rd_10,
input	[7:0]   in_rd_11,

input   	    in_overlay_de,
input		    in_overlay_valid,
input   	    in_overlay_hsync,
input   	    in_overlay_vsync,
input	[7:0]	in_overlay_rd_00,
input	[7:0]   in_overlay_rd_01,
input	[7:0]   in_overlay_rd_10,
input	[7:0]   in_overlay_rd_11,
			
output  	    out_de,
output		    out_valid,
output  	    out_hsync,
output  	    out_vsync,
output	[7:0]	out_rd_00,
output	[7:0]   out_rd_01,
output	[7:0]   out_rd_10,
output	[7:0]   out_rd_11

);

reg 	    r_out_de_2P;
reg		    r_out_valid_2P;
reg 	    r_out_hsync_2P;
reg 	    r_out_vsync_2P;
reg	[7:0]	r_out_rd_00_2P;
reg	[7:0]   r_out_rd_01_2P;
reg	[7:0]   r_out_rd_10_2P;
reg	[7:0]   r_out_rd_11_2P;


reg 		r_check_overlay_1P;
reg 		r_overlay_max_00_1P;
reg 		r_overlay_max_01_1P;
reg 		r_overlay_max_10_1P;
reg 		r_overlay_max_11_1P;

reg         r_in_de_1P;   
reg	        r_in_valid_1P;
reg         r_in_hsync_1P;
reg         r_in_vsync_1P;
reg	[7:0]	r_in_rd_00_1P;
reg	[7:0]   r_in_rd_01_1P;
reg	[7:0]   r_in_rd_10_1P;
reg	[7:0]   r_in_rd_11_1P;

reg   		r_in_overlay_de_1P;
reg			r_in_overlay_valid_1P;
reg   		r_in_overlay_hsync_1P;
reg   		r_in_overlay_vsync_1P;
reg	[7:0]	r_in_overlay_rd_00_1P;
reg	[7:0]   r_in_overlay_rd_01_1P;
reg	[7:0]   r_in_overlay_rd_10_1P;
reg	[7:0]   r_in_overlay_rd_11_1P;

always @(posedge out_clk, negedge rstn)
begin
	if(!rstn)
	begin

		r_in_de_1P	   <= 1'b0;  
		r_in_valid_1P  <= 1'b0;
		r_in_hsync_1P  <= 1'b0;
		r_in_vsync_1P  <= 1'b0;
		r_in_rd_00_1P  <= 7'd0;
		r_in_rd_01_1P  <= 7'd0;
		r_in_rd_10_1P  <= 7'd0;
		r_in_rd_11_1P  <= 7'd0;
	
		r_in_overlay_de_1P	   <= 1'b0;  
		r_in_overlay_valid_1P  <= 1'b0;
		r_in_overlay_hsync_1P  <= 1'b0;
		r_in_overlay_vsync_1P  <= 1'b0;
		r_in_overlay_rd_00_1P  <= 7'd0;
		r_in_overlay_rd_01_1P  <= 7'd0;
		r_in_overlay_rd_10_1P  <= 7'd0;
		r_in_overlay_rd_11_1P  <= 7'd0;

		r_out_de_2P    <= 1'b0;
		r_out_valid_2P <= 1'b0;
		r_out_hsync_2P <= 1'b0;
		r_out_vsync_2P <= 1'b0;
		r_out_rd_00_2P <= 7'd0;
		r_out_rd_01_2P <= 7'd0;
		r_out_rd_10_2P <= 7'd0;
		r_out_rd_11_2P <= 7'd0;
		
	end
	else 
	begin
		r_in_de_1P	   <= in_de;  
		r_in_valid_1P  <= in_valid;
		r_in_hsync_1P  <= in_hsync;
		r_in_vsync_1P  <= in_vsync;
		r_in_rd_00_1P  <= in_rd_00;
		r_in_rd_01_1P  <= in_rd_01;
		r_in_rd_10_1P  <= in_rd_10;
		r_in_rd_11_1P  <= in_rd_11;
		
	
		r_in_overlay_de_1P	   <= in_overlay_de;  
		r_in_overlay_valid_1P  <= in_overlay_valid;
		r_in_overlay_hsync_1P  <= in_overlay_hsync;
		r_in_overlay_vsync_1P  <= in_overlay_vsync;
		r_in_overlay_rd_00_1P  <= in_overlay_rd_00;
		r_in_overlay_rd_01_1P  <= in_overlay_rd_01;
		r_in_overlay_rd_10_1P  <= in_overlay_rd_10;
		r_in_overlay_rd_11_1P  <= in_overlay_rd_11;
	
	
		if (in_valid & in_hsync & in_vsync & in_de)
		begin 
			r_check_overlay_1P <= 1'b1;		
		end 	
		else 
		begin
			r_check_overlay_1P <= 1'b0;		
		end 
		
		if (in_overlay_rd_00 == 8'd0)
		begin
			r_overlay_max_00_1P <= 1'b0;
		end 
		else 
		begin
			r_overlay_max_00_1P <= 1'b1;
		end 
		
		if (in_overlay_rd_01 == 8'd0)
		begin
			r_overlay_max_01_1P <= 1'b0;
		end 
		else 
		begin
			r_overlay_max_01_1P <= 1'b1;
		end 
		
		if (in_overlay_rd_10 == 8'd0)
		begin
			r_overlay_max_10_1P <= 1'b0;
		end 
		else 
		begin
			r_overlay_max_10_1P <= 1'b1;
		end 

		if (in_overlay_rd_11 == 8'd0)
		begin
			r_overlay_max_11_1P <= 1'b0;
		end 
		else 
		begin
			r_overlay_max_11_1P <= 1'b1;
		end 
		
		r_out_de_2P	   <= r_in_de_1P;   
		r_out_valid_2P  <= r_in_valid_1P;
		r_out_hsync_2P  <= r_in_hsync_1P;
		r_out_vsync_2P  <= r_in_vsync_1P;
		
		if (r_check_overlay_1P & in_overlay_rd_00)
		begin
			r_out_rd_00_2P  <= r_in_overlay_rd_00_1P;
		end 
		else 
		begin
			r_out_rd_00_2P  <= r_in_rd_00_1P;
		end 
		
		if (r_check_overlay_1P & in_overlay_rd_01)
		begin
			r_out_rd_01_2P  <= r_in_overlay_rd_01_1P;
		end 
		else 
		begin
			r_out_rd_01_2P  <= r_in_rd_01_1P;
		end 
		
		
		if (r_check_overlay_1P & in_overlay_rd_10)
		begin
			r_out_rd_10_2P  <= r_in_overlay_rd_10_1P;
		end 
		else 
		begin
			r_out_rd_10_2P  <= r_in_rd_10_1P;
		end 
		
		if (r_check_overlay_1P & in_overlay_rd_11)
		begin
			r_out_rd_11_2P  <= r_in_overlay_rd_11_1P;
		end 
		else 
		begin
			r_out_rd_11_2P  <= r_in_rd_11_1P;
		end 
		
		
		
		
	end 	


end 


assign out_de	 = r_out_de_2P;
assign out_valid = r_out_valid_2P;
assign out_hsync = r_out_hsync_2P;
assign out_vsync = r_out_vsync_2P;
assign out_rd_00 = r_out_rd_00_2P;
assign out_rd_01 = r_out_rd_01_2P;
assign out_rd_10 = r_out_rd_10_2P;
assign out_rd_11 = r_out_rd_11_2P;



endmodule   