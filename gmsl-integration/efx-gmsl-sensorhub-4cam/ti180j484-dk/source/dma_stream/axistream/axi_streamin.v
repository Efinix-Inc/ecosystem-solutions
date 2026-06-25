/////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2013-2021 Efinix Inc. All rights reserved.
//
// Description:
// AXI Stream Input
// From Video Signal Input to AXI Stream Signal which connected to DMA Controller  
//
// Language:  Verilog 2001
//
// ------------------------------------------------------------------------------
/////////////////////////////////////////////////////////////////////////////////


module axi_streamin
#(
	parameter FRAME_COUNT = 1*1920*1080,
    parameter PIXEL_WIDTH = 8
)
(
input 			axi_clk,
input 			in_clk,
input 			rstn,

input           i_ref_clk, //1hz

//Frame Size
input 		[10:0]	x_size,	//h
input 		[10:0]	y_size,	//v

input 		stream_en,

input       	in_de,
input       	in_hs,
input       	in_vs,
input	[PIXEL_WIDTH-1:0]	in_rd_00,
input	[PIXEL_WIDTH-1:0]   in_rd_01,
input	[PIXEL_WIDTH-1:0]   in_rd_10,
input	[PIXEL_WIDTH-1:0]   in_rd_11,

output              out_tvalid,
input               in_tready,
output     [31:0]   out_tdata,
output     [3:0]   	out_tkeep,
output     [3:0]	out_tdest,
output              out_tlast

);

//Main states
localparam  IDLE 		 = 3'b000;
localparam  WAIT_STREAM  = 3'b001;
localparam  START_STREAM = 3'b010;
localparam  START_FRAME  = 3'b011;
localparam  STREAM_VALID = 3'b100;
localparam  STREAM_HOLD  = 3'b101;
localparam  END_FRAME2   = 3'b110;




reg 	[10:0]	r_x_count;
reg 	[10:0]	r_y_count;
reg 	[20:0]	r_d_count;
reg 	[2:0] 	r_axi_state;

wire 	[31:0]	w_data_out;




reg [31:0] r_frame_count;

reg [31:0] r_out_tdata;
reg 	   r_out_tvalid;
reg 	   r_out_tlast;
reg [3:0]  r_out_tkeep;



reg 			r_in_de_1P;
reg 			r_in_hs_1P;
reg 			r_in_Vs_1P;
reg 	[10:0]	r_hs_count;
reg 	[10:0]	r_vs_count;
reg 	[31:0]	r_de_count;


reg 	[31:0]	r_in_buffer;
reg		r_de_buffer;
reg 	r_rd_buffer;
reg 	r_end_frame;

reg 	[31:0]	debug_data_in_count;
reg 	[31:0]	debug_data_out_count;


reg 	[31:0]	r_data_in_count;
reg 	[31:0]	r_data_out_count;

(* async_reg = "true" *) reg 	r_stream_en;

wire w_fifo_data_empty;
wire w_fifo_data_full;

reg [31:0] r_rx_count;
reg [31:0] r_2dma_count;
reg [31:0] r_rx_count_log;
reg [31:0] r_2dma_count_log;

reg [3:0] r_i_ref_clk;

reg r_fifo_resetn;


always @(posedge in_clk or negedge rstn )
begin
    if (~rstn) 
	begin  
        r_in_de_1P <= 1'b0;
        r_in_hs_1P <= 1'b0;
        r_in_Vs_1P <= 1'b0;
		r_stream_en <= 1'b0;
		
		debug_data_in_count <= 32'd0;
		debug_data_out_count <= 32'd0;

    end
    else
    begin       
        r_in_hs_1P <= in_hs;
        r_in_Vs_1P <= in_vs;
        r_in_de_1P <= in_de;
		r_stream_en <= stream_en;
		
		if((~r_in_Vs_1P) & in_vs)
		begin
			r_hs_count <= 11'd0;
			r_vs_count <= 11'd0;
			r_de_count <= 32'd0;
			debug_data_in_count <= 32'd0;
			debug_data_out_count <= 32'd0;

		end
		if((~r_in_hs_1P) & in_hs)
		begin
			r_vs_count <= r_vs_count + 1'b1;
			r_hs_count <= 11'd0;
	
		end
		
		//if((~r_in_de_1P) & in_de)
		//begin
		//	r_de_count <= 11'd0;
        //end
		
		if(r_in_hs_1P)
		begin
			r_hs_count <= r_hs_count +1'b1;
		end

		if(r_in_de_1P)
		begin
			r_de_count <= r_de_count +1'b1;
		end
		
		if(r_de_buffer)
		begin
			debug_data_in_count <= debug_data_in_count + 1'b1;
		end 
		
		if (in_tready& r_out_tvalid)
		begin
					
			if (r_out_tkeep  == 4'b1111)
			begin
				debug_data_out_count <= debug_data_out_count + 1'b1;
			end 
		
		end 
			
    end

end

always @(posedge in_clk or negedge rstn)
begin
	if(~rstn)
	begin
		r_axi_state<= IDLE;
		r_end_frame<= 1'b0; 
        r_fifo_resetn <= 1'b0; 
	end
	else
	begin
		case (r_axi_state)		
		
		IDLE:
			begin
				
				r_axi_state<= WAIT_STREAM;
				r_rd_buffer  <= 1'b0;
				r_out_tvalid <= 1'b0;
				r_out_tkeep  <= 4'b0000;
				r_out_tlast<= 1'b0;
				r_end_frame <= 1'b0; 
                r_fifo_resetn <= 1'b0;
			end 
		
		WAIT_STREAM:
			begin
				
				if((~r_in_Vs_1P) & in_vs)
				begin
					if(in_tready & r_stream_en)
					begin
						r_rd_buffer  <= 1'b0;
						r_out_tvalid <= 1'b0;
						r_out_tkeep  <= 4'b0000;
						r_out_tlast<= 1'b0;
						r_axi_state<= START_FRAME;
						r_data_in_count <= 32'd0;
						r_data_out_count <= 32'd0;
                        r_fifo_resetn <= 1'b1;
					end
				end
                else 
                begin 
                    r_fifo_resetn <= 1'b0;
                    r_rd_buffer  <= 1'b1;
                end 
				
			end 
		START_STREAM:
			begin
				
				if((~r_in_Vs_1P) & in_vs)
				begin
					r_rd_buffer  <= 1'b0;
					r_out_tvalid <= 1'b0;
					r_out_tkeep  <= 4'b0000;	
					r_out_tlast<= 1'b0;
					r_axi_state<= START_FRAME;
					r_data_in_count <= 32'd0;
					r_data_out_count <= 32'd0;
                     r_fifo_resetn <= 1'b1;
				end	
                else 
                begin 
                    r_fifo_resetn <= 1'b0;
                    r_rd_buffer  <= 1'b1;
                end 
			end
		START_FRAME:
			begin
				if(in_de&in_hs)
				begin
					r_in_buffer <=  {in_rd_11,in_rd_10,in_rd_01,in_rd_00};
					r_de_buffer <= 1'b1;
					r_data_in_count <= r_data_in_count +1'b1;
				end
				else 
				begin
					r_de_buffer <= 1'b0;
				end 
                
                 if (r_data_out_count != r_data_in_count)
                 begin
                    if (in_tready) 
                    begin 
                        r_rd_buffer  <= 1'b1;
                        r_out_tvalid <= 1'b1;
                        r_out_tkeep  <= 4'b1111;
                        
                        r_data_out_count <= r_data_out_count +1'b1;
                        if (r_data_out_count == ('h7e900 -'h1) )
                        begin 
                            r_out_tlast	 <= 1'b1;
                            r_axi_state<= END_FRAME2;
                        end 
                    end 
                    else
                    begin
                        r_rd_buffer  <= 1'b0;
                    end  
                    
                 end 
                 else 
                 begin
                    r_rd_buffer  <= 1'b0;
                    r_out_tvalid <= 1'b0;
					r_out_tkeep  <= 4'b0000;
                    r_out_tlast	 <= 1'b0; 
                 end  
                
                
                
             
                
                
                /*
                
                
                if (~w_fifo_data_empty & in_tready) //Data Valid in FIFO and AXI stream ready to receivce Data  
                begin 
                    
                    
                    if (r_data_out_count != r_data_in_count)
                    begin 
                        r_data_out_count <= r_data_out_count +1'b1;
                        r_rd_buffer  <= 1'b1;
                        r_out_tvalid <= 1'b1;
                        r_out_tkeep  <= 4'b1111;
                        
                        if (r_data_out_count == ('h7e900 -'h1) )
                        begin 
                            r_end_frame  <= 1'b1;
                            r_axi_state<= END_FRAME2;
                            r_out_tlast	 <= 1'b1;                       
                        end 
                        
                    end 
                    
                
                end 
                else if (w_fifo_data_empty & in_tready) //Data Is not Valid in FIFO and AXI stream ready to receivce Data 
                begin 
                    r_rd_buffer  <= 1'b1;
					r_out_tvalid <= 1'b0;
					r_out_tkeep  <= 4'b0000;
					r_out_tlast	 <= 1'b0;      
                    if (r_data_out_count != r_data_in_count)
                    begin 
                        r_data_out_count <= r_data_out_count +1'b1;     
                    end         
                
                end 
                else if (~w_fifo_data_empty & ~in_tready) //Data Is Valid in FIFO , But AXI stream is not ready to receivce Data  
                begin 
                   // if (r_data_out_count != r_data_in_count)
                   // begin 
                    //    r_rd_buffer  <= 1'b0;
                     //   r_out_tvalid <= 1'b1;
                     //   r_out_tkeep  <= 4'b1111;
                    //end 
                    r_rd_buffer  <= 1'b0;
					r_out_tvalid <= 1'b0;
					r_out_tkeep  <= 4'b0000;
					r_out_tlast	 <= 1'b0;
                
                end 
                else if (w_fifo_data_empty & ~in_tready) //No Data and AXI stream is not ready  
                begin 
                    r_rd_buffer  <= 1'b0;
					r_out_tvalid <= 1'b0;
					r_out_tkeep  <= 4'b0000;
					r_out_tlast	 <= 1'b0;
                
                    if (r_data_out_count != r_data_in_count)
                    begin 
                        r_data_out_count <= r_data_out_count +1'b1;     
                    end 
                
                
                end 
                
                */
                
                           
                
            end 
       STREAM_VALID:
            begin
            //	if(in_de&in_hs)
			//	begin
			//		r_in_buffer <=  {in_rd_11,in_rd_10,in_rd_01,in_rd_00};
			//		r_de_buffer <= 1'b1;
			//		r_data_in_count <= r_data_in_count +1'b1;
			//	end
			//	else 
			//	begin
			//		r_de_buffer <= 1'b0;
			//	end 
            //
            //    
            //
            //    if ( (~w_fifo_data_empty) & (r_data_out_count != r_data_in_count)  )
            //    begin 
            //        if(in_tready)
            //        begin   
            //            r_data_out_count <= r_data_out_count +1'b1;
            //            r_rd_buffer  <= 1'b1;
            //            r_out_tvalid <= 1'b1;
            //            r_out_tkeep  <= 4'b1111;
            //               
            //            if (r_data_out_count == ('h7e900 -'h1) )
            //            begin 
            //                r_rd_buffer <= 1'b0;
            //            
            //                r_end_frame  <= 1'b1;
            //                r_axi_state<= END_FRAME2;
            //                r_out_tlast	 <= 1'b1;
            //            end
            //            
            //        end 
            //        else 
            //        begin 
            //            r_rd_buffer <= 1'b0;
            //        
            //        end 
            //    end 
            //    else 
            //    begin 
            //    	r_rd_buffer  <= 1'b0;
			//		r_out_tvalid <= 1'b0;
			//		r_out_tkeep  <= 4'b0000;
			//		r_out_tlast	 <= 1'b0;    
            //        r_axi_state <=  START_FRAME;
            //    end 
           
            
            end 
       STREAM_HOLD:
            begin
            //	if(in_de&in_hs)
			//	begin
			//		r_in_buffer <=  {in_rd_11,in_rd_10,in_rd_01,in_rd_00};
			//		r_de_buffer <= 1'b1;
			//		r_data_in_count <= r_data_in_count +1'b1;
			//	end
			//	else 
			//	begin
			//		r_de_buffer <= 1'b0;
			//	end 

            end
    
          
                
                
      /*          
                
                
					
                if (r_data_out_count != r_data_in_count)
                begin 
                    if(in_tready  )
                    begin
                    
                        if(~w_fifo_data_empty)
                        begin 
                            r_data_out_count <= r_data_out_count +1'b1;
                            r_rd_buffer  <= 1'b1;
                            r_out_tvalid <= 1'b1;
                            r_out_tkeep  <= 4'b1111;
					    
                        
                            if (r_data_out_count == ('h7e900 -'h1) )
                            begin 
                                r_end_frame  <= 1'b1;
                                r_axi_state<= END_FRAME2;
                                r_out_tlast	 <= 1'b1;
                            end
                       end  
                    end 
                    else 
                    begin
                         r_rd_buffer  <= 1'b0;
                    end                
                end 
                else 
				begin
					r_rd_buffer  <= 1'b0;
					r_out_tvalid <= 1'b0;
					r_out_tkeep  <= 4'b0000;
					r_out_tlast	 <= 1'b0;
				end 
                */
                    
                    
            /*    if ( (~w_fifo_data_empty & in_tready) & (r_data_out_count == ('h7e900 -'h1) ) )   
                begin
                    r_data_out_count <= r_data_out_count +1'b1;
					r_rd_buffer  <= 1'b1;
					r_out_tvalid <= 1'b1;
					r_out_tkeep  <= 4'b1111;
					r_out_tlast	 <= 1'b1;
                    r_end_frame  <= 1'b1;
                    r_axi_state<= END_FRAME2;
                end                   
                else if( (~w_fifo_data_empty & in_tready) & (r_data_out_count != r_data_in_count) )
				begin
					r_data_out_count <= r_data_out_count +1'b1;
					r_rd_buffer  <= 1'b1;
					r_out_tvalid <= 1'b1;
					r_out_tkeep  <= 4'b1111;
					r_out_tlast	 <= 1'b0;
				end
				else 
				begin
					r_rd_buffer  <= 1'b0;
					r_out_tvalid <= 1'b0;
					r_out_tkeep  <= 4'b0000;
					r_out_tlast	 <= 1'b0;
				end */
				
				
		/*		if((r_in_Vs_1P) & ~in_vs)
				begin
					r_end_frame<= 1'b1;
				end	
				
				if(r_end_frame)
	//			if( (r_vs_count == 'h438) && (r_hs_count == ('h1E0 -'h1)) )
                begin
                     
					if(w_fifo_data_empty)
					begin
						r_end_frame  <= 1'b0;
						r_rd_buffer  <= 1'b0;
						r_out_tvalid <= 1'b1;
						r_out_tkeep  <= 4'b0000;
						r_out_tlast	 <= 1'b1;
						r_axi_state<= END_FRAME1;
					end
				end */
						
		END_FRAME2:
			begin
				r_rd_buffer  <= 1'b0;
                r_de_buffer  <= 1'b0;
				r_out_tvalid <= 1'b0;
				r_out_tkeep  <= 4'b0000;
				r_out_tlast	 <= 1'b0;
                r_end_frame  <= 1'b0;
				if(r_stream_en)
				begin
					r_axi_state<= START_STREAM;
				end 
				else 
				begin
					r_axi_state<= WAIT_STREAM;
				end 
			end
		default:
			begin
			end
		endcase
	end
end
fifo 
#(
	.DATA_WIDTH(32),
    .ADDR_WIDTH(10)
)	   
inst_fifo_data
(
  .clk 		(in_clk	),
  .nrst 	(r_fifo_resetn	),
  .empty    (w_fifo_data_empty)    , // FIFO empty
  .full     (w_fifo_data_full)     , // FIFO full
  .we 		(r_de_buffer &  (~w_fifo_data_full) ),
  .re 		(r_rd_buffer &  (~w_fifo_data_empty)),
  .data_in 	(r_in_buffer),
  .data_out (w_data_out)
 );

 always @(posedge in_clk or negedge rstn )
begin
    if (~rstn) 
    begin
        r_rx_count  <= 1'd0;
        r_2dma_count<= 1'd0;
        r_rx_count_log  <= 1'd0;
        r_2dma_count_log<= 1'd0;
        
        r_i_ref_clk<= 'd0;
    end 
    else 
    begin
        r_i_ref_clk <= {r_i_ref_clk[2:0], i_ref_clk};
        
        if( (!r_i_ref_clk[3]) && r_i_ref_clk[2]   )
        begin
            r_rx_count_log   <= r_rx_count;
            r_2dma_count_log <= r_2dma_count;
            r_rx_count  <= 1'd0;
            r_2dma_count<= 1'd0;
            
        end 
        else 
        begin
            if(r_de_buffer)
            begin 
                r_rx_count = r_rx_count +1'b1;
            end 
            
            if(r_rd_buffer)
            begin 
                r_2dma_count = r_2dma_count +1'b1;
            end   
        end
        
    end 
    
end 
 
 
reg r_out_tvalid_1P;
reg r_out_tlast_1P;
reg [3:0] r_out_tkeep_1P;

always @(posedge in_clk or negedge rstn)
begin
	if(~rstn)
	begin
		r_out_tvalid_1P<= 1'b0;
		r_out_tlast_1P <= 1'b0;
		r_out_tkeep_1P <= 4'b0000;
	end
	else
	begin
		r_out_tvalid_1P<= r_out_tvalid;
		r_out_tlast_1P <= r_out_tlast;
		r_out_tkeep_1P <= r_out_tkeep;
	
	end 
	
end 

assign out_tdata = w_data_out;
assign out_tvalid = r_out_tvalid_1P;
assign out_tlast = r_out_tlast_1P;
assign out_tkeep = r_out_tkeep_1P;




endmodule
