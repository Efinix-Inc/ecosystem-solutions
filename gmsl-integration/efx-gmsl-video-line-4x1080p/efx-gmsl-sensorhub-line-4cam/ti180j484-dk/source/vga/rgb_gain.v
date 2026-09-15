module rgb_gain
#(
	parameter	P_DEPTH			= 10,
	parameter	PW				= P_DEPTH*4
)
(
	input               i_pclk,
	input               i_arstn,
	
	input 		        i_hs,
	input               i_vs,
	input				i_de,
	input				i_valid,
	input [PW-1:0]  	i_data,
    input [2:0]         blue_gain,
    input [2:0]         green_gain,
    input [2:0]         red_gain,
	
	output              o_hs,
	output				o_vs,
	output				o_de,
	output				o_valid,
	output [PW-1:0]  	o_data
);

wire	[PW-1:0] 		w_data_filtered;
		
wire	[P_DEPTH:0] 	odd_line_byte_3;
wire	[P_DEPTH:0] 	odd_line_byte_2;
wire	[P_DEPTH:0] 	odd_line_byte_1;
wire	[P_DEPTH:0] 	odd_line_byte_0;
		
wire	[P_DEPTH-1:0] 	odd_line_pix_3;
wire	[P_DEPTH-1:0] 	odd_line_pix_2;
wire	[P_DEPTH-1:0] 	odd_line_pix_1;
wire	[P_DEPTH-1:0] 	odd_line_pix_0;
		
wire	[P_DEPTH:0] 	even_line_byte_3;
wire	[P_DEPTH:0] 	even_line_byte_2;
wire	[P_DEPTH:0] 	even_line_byte_1;
wire	[P_DEPTH:0] 	even_line_byte_0;
		
wire	[P_DEPTH-1:0] 	even_line_pix_3;
wire	[P_DEPTH-1:0] 	even_line_pix_2;
wire	[P_DEPTH-1:0] 	even_line_pix_1;
wire	[P_DEPTH-1:0] 	even_line_pix_0;
		
wire	[P_DEPTH-1:0] 	byte_3_div_1;
wire	[P_DEPTH-1:0] 	byte_3_div_2;
wire	[P_DEPTH-1:0] 	byte_3_div_4;
wire	[P_DEPTH-1:0] 	byte_2_div_1;
wire	[P_DEPTH-1:0] 	byte_2_div_2;
wire	[P_DEPTH-1:0] 	byte_2_div_4;
wire	[P_DEPTH-1:0] 	byte_1_div_1;
wire	[P_DEPTH-1:0] 	byte_1_div_2;
wire	[P_DEPTH-1:0] 	byte_1_div_4;
wire	[P_DEPTH-1:0] 	byte_0_div_1;
wire	[P_DEPTH-1:0] 	byte_0_div_2;
wire	[P_DEPTH-1:0] 	byte_0_div_4;

reg						r_line_cnt;

/* RGB gain filter */   
assign byte_3_div_1 = i_data[PW-1:P_DEPTH*3];
assign byte_3_div_2 = byte_3_div_1 >> 1;
assign byte_3_div_4 = byte_3_div_1 >> 2;
assign byte_2_div_1 = i_data[P_DEPTH*3-1:P_DEPTH*2];
assign byte_2_div_2 = byte_2_div_1 >> 1;
assign byte_2_div_4 = byte_2_div_1 >> 2;
assign byte_1_div_1 = i_data[P_DEPTH*2-1:P_DEPTH];
assign byte_1_div_2 = byte_1_div_1 >> 1;
assign byte_1_div_4 = byte_1_div_1 >> 2;
assign byte_0_div_1 = i_data[P_DEPTH-1:0];
assign byte_0_div_2 = byte_0_div_1 >> 1;
assign byte_0_div_4 = byte_0_div_1 >> 2;

// Gb B Gb B  
assign odd_line_byte_3 = green_gain[2] ? 
          byte_3_div_1+(byte_3_div_2 & {P_DEPTH{green_gain[1]}})+(byte_3_div_4 & {P_DEPTH{green_gain[0]}}):
          byte_3_div_1-byte_3_div_4-(byte_3_div_2 & {P_DEPTH{~green_gain[1]}})-(byte_3_div_4 & {P_DEPTH{~green_gain[0]}});
assign odd_line_byte_2 = blue_gain[2] ? 
          byte_2_div_1+(byte_2_div_2 & {P_DEPTH{blue_gain[1]}})+(byte_2_div_4 & {P_DEPTH{blue_gain[0]}}):
          byte_2_div_1-byte_2_div_4-(byte_2_div_2 & {P_DEPTH{~blue_gain[1]}})-(byte_2_div_4 & {P_DEPTH{~blue_gain[0]}});
assign odd_line_byte_1 = green_gain[2] ? 
          byte_1_div_1+(byte_1_div_2 & {P_DEPTH{green_gain[1]}})+(byte_1_div_4 & {P_DEPTH{green_gain[0]}}):
          byte_1_div_1-byte_1_div_4-(byte_1_div_2 & {P_DEPTH{~green_gain[1]}})-(byte_1_div_4 & {P_DEPTH{~green_gain[0]}});
assign odd_line_byte_0 = blue_gain[2] ? 
          byte_0_div_1+(byte_0_div_2 & {P_DEPTH{blue_gain[1]}})+(byte_0_div_4 & {P_DEPTH{blue_gain[0]}}):
          byte_0_div_1-byte_0_div_4-(byte_0_div_2 & {P_DEPTH{~blue_gain[1]}})-(byte_0_div_4 & {P_DEPTH{~blue_gain[0]}});
// R Gr R Gr
assign even_line_byte_3 = red_gain[2] ? 
          byte_3_div_1+(byte_3_div_2 & {P_DEPTH{red_gain[1]}})+(byte_3_div_4 & {P_DEPTH{red_gain[0]}}):
          byte_3_div_1-byte_3_div_4-(byte_3_div_2 & {P_DEPTH{~red_gain[1]}})-(byte_3_div_4 & {P_DEPTH{~red_gain[0]}});
assign even_line_byte_2 = green_gain[2] ? 
          byte_2_div_1+(byte_2_div_2 & {P_DEPTH{green_gain[1]}})+(byte_2_div_4 & {P_DEPTH{green_gain[0]}}):
          byte_2_div_1-byte_2_div_4-(byte_2_div_2 & {P_DEPTH{~green_gain[1]}})-(byte_2_div_4 & {P_DEPTH{~green_gain[0]}});
assign even_line_byte_1 = red_gain[2] ? 
          byte_1_div_1+(byte_1_div_2 & {P_DEPTH{red_gain[1]}})+(byte_1_div_4 & {P_DEPTH{red_gain[0]}}):
          byte_1_div_1-byte_1_div_4-(byte_1_div_2 & {P_DEPTH{~red_gain[1]}})-(byte_1_div_4 & {P_DEPTH{~red_gain[0]}});
assign even_line_byte_0 = green_gain[2] ? 
          byte_0_div_1+(byte_0_div_2 & {P_DEPTH{green_gain[1]}})+(byte_0_div_4 & {P_DEPTH{green_gain[0]}}):
          byte_0_div_1-byte_0_div_4-(byte_0_div_2 & {P_DEPTH{~green_gain[1]}})-(byte_0_div_4 & {P_DEPTH{~green_gain[0]}});

assign odd_line_pix_3 	= odd_line_byte_3[P_DEPTH] 	? {P_DEPTH{1'b1}} : odd_line_byte_3[P_DEPTH-1:0];
assign odd_line_pix_2 	= odd_line_byte_2[P_DEPTH] 	? {P_DEPTH{1'b1}} : odd_line_byte_2[P_DEPTH-1:0];
assign odd_line_pix_1 	= odd_line_byte_1[P_DEPTH] 	? {P_DEPTH{1'b1}} : odd_line_byte_1[P_DEPTH-1:0];
assign odd_line_pix_0 	= odd_line_byte_0[P_DEPTH] 	? {P_DEPTH{1'b1}} : odd_line_byte_0[P_DEPTH-1:0];
assign even_line_pix_3 	= even_line_byte_3[P_DEPTH] ? {P_DEPTH{1'b1}} : even_line_byte_3[P_DEPTH-1:0];
assign even_line_pix_2 	= even_line_byte_2[P_DEPTH] ? {P_DEPTH{1'b1}} : even_line_byte_2[P_DEPTH-1:0];
assign even_line_pix_1 	= even_line_byte_1[P_DEPTH] ? {P_DEPTH{1'b1}} : even_line_byte_1[P_DEPTH-1:0];
assign even_line_pix_0 	= even_line_byte_0[P_DEPTH] ? {P_DEPTH{1'b1}} : even_line_byte_0[P_DEPTH-1:0];

assign w_data_filtered = !r_line_cnt ?
                            {even_line_pix_3,even_line_pix_2,even_line_pix_1,even_line_pix_0}:
                             {odd_line_pix_3, odd_line_pix_2, odd_line_pix_1, odd_line_pix_0};

/* SYNC delay */
reg				r_hs_1P;
reg				r_de_1P;
reg				r_vs_1P;
reg				r_valid_1P;
reg				r_hs_2P;
reg				r_de_2P;
reg				r_vs_2P;
reg				r_valid_2P;
reg	[PW-1:0]	r_data_1P;
reg	[PW-1:0]	r_data_2P;

always@(posedge i_pclk)
begin
	if (~i_arstn)
	begin
		r_hs_1P		<= 1'b0;
		r_de_1P		<= 1'b0;
		r_vs_1P		<= 1'b0;
		r_valid_1P	<= 1'b0;
		r_hs_2P		<= 1'b0;
		r_de_2P		<= 1'b0;
		r_vs_2P		<= 1'b0;
		r_valid_2P	<= 1'b0;
		r_line_cnt	<= 1'b0;
		r_data_1P	<= {PW{1'b0}};
		r_data_2P	<= {PW{1'b0}};
	end
	else
	begin
		r_de_1P		<= i_de;
		r_hs_1P		<= i_hs;
		r_vs_1P		<= i_vs;	
		r_valid_1P	<= i_valid;
		r_data_1P	<= w_data_filtered;
		r_de_2P		<= r_de_1P;
		r_hs_2P		<= r_hs_1P;
		r_vs_2P		<= r_vs_1P;	
		r_valid_2P	<= r_valid_1P;
		r_data_2P	<= r_data_1P;
		
		if (r_vs_1P && !i_vs)
			r_line_cnt	<= 1'b0;
		if (r_de_1P && !i_de)
			r_line_cnt 	<= ~r_line_cnt;
	end
end

assign	o_hs	= i_hs;
assign	o_de	= i_de;
assign	o_vs	= i_vs;
assign	o_valid	= i_valid;
assign	o_data	= w_data_filtered;

endmodule
