module video_monitor (
    input  wire        clk,        // Pixel clock
    input  wire        reset_n,
    input  wire        vsync,
    input  wire        hsync,
    input  wire        de,         
    input  wire [31:0] ref_clk_hz, 
    
    input wire         clk_byte_HS,
    input wire         reset_byte_HS_n,
    
    output reg  [31:0] clk_byte_HS_count,
    
    // All outputs are now registered (buffered)
    output reg [15:0]  hsync_per_frame,
    output reg [15:0]  pixel_per_line,
    output reg [9:0]  frame_rate      
);

    // --- Input Pipeline Registers ---
    reg vsync_sync, hsync_sync, de_sync;
    reg vsync_d, hsync_d;
    
    // --- Internal Counter Registers ---
    reg [9:0] frame_cnt_int;
    reg [15:0] h_cnt_int;
    reg [15:0] p_cnt_int;
    reg [31:0] ref_cnt_int;
	reg r_frame_check;

    reg [31:0] byte_HS_cnt_int;
    reg r_ref_toggle;
    
    reg r_byte_HS_toggle_1P;
    reg r_byte_HS_toggle_2P;
    reg r_byte_HS_toggle_3P;
    
    
    always @(posedge clk_byte_HS or negedge reset_byte_HS_n) begin 
        if(!reset_byte_HS_n) begin
            byte_HS_cnt_int<= 'd0;
            r_byte_HS_toggle_1P <= 'd0;
            r_byte_HS_toggle_2P <= 'd0;
            r_byte_HS_toggle_3P <= 'd0;
            
        end 
        else begin 
            r_byte_HS_toggle_1P <= r_ref_toggle;
            r_byte_HS_toggle_2P <= r_byte_HS_toggle_1P;
            r_byte_HS_toggle_3P <= r_byte_HS_toggle_2P;
        
            if( r_byte_HS_toggle_3P != r_byte_HS_toggle_2P)
            begin 
               clk_byte_HS_count <= byte_HS_cnt_int;
               byte_HS_cnt_int <= 'd0;
            end 
            else 
            begin 
                byte_HS_cnt_int<= byte_HS_cnt_int + 1'b1;
            end 
        end 
    end 
    
    
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            // Reset Input Regs
            vsync_sync <= 0; hsync_sync <= 0; de_sync <= 0;
            vsync_d    <= 0; hsync_d    <= 0;
            
            // Reset Internal Counters
            frame_cnt_int <= 0;
            h_cnt_int     <= 0;
            p_cnt_int     <= 0;
            ref_cnt_int   <= 0;
            
            // Reset Outputs
            hsync_per_frame <= 0;
            pixel_per_line  <= 0;
            frame_rate      <= 0;
			r_frame_check   <= 0;
            r_ref_toggle    <= 0;
        end else begin
            // --- STAGE 1: Input Registration ---
            vsync_sync <= vsync;
            hsync_sync <= hsync;
            de_sync    <= de;

            // --- STAGE 2: Edge Detection ---
            vsync_d <= vsync_sync;
            hsync_d <= hsync_sync;
            

		
			
			
			if (ref_cnt_int == ref_clk_hz) begin

				frame_rate <= frame_cnt_int;
				
				frame_cnt_int <= 0;
				ref_cnt_int   <= 0;
				r_frame_check <=0;
                r_ref_toggle <= ~r_ref_toggle;
			end
			else 
			begin
			    ref_cnt_int <= ref_cnt_int + 1;
			end 
			

			
            // Detect Rising Edge of VSYNC (End of previous frame / Start of new)
            if (vsync_sync && !vsync_d) begin
                // Update Outputs at the end of the frame         
				r_frame_check  <= 1;

                // Increment internal counter and reset others

                hsync_per_frame <= h_cnt_int;
                // Edge case: Vsync and Hsync rising same cycle
                if (hsync_sync && !hsync_d) begin
                    h_cnt_int      <= 1;
                    pixel_per_line <= p_cnt_int; // Update Output
                    p_cnt_int      <= (de_sync) ? 1 : 0;
					
                end else begin
                    h_cnt_int      <= 0;
                end 
            end
			else if (!vsync_sync && vsync_d) begin
				if(r_frame_check)begin 
				    frame_cnt_int <= frame_cnt_int + 1;
					r_frame_check <= 0;
				end 
			end 
			
            else begin
				
			
                // Detect Rising Edge of HSYNC
                if(vsync_sync==1)
                begin
                    if (hsync_sync && !hsync_d) begin
                        h_cnt_int      <= h_cnt_int + 1;
                        pixel_per_line <= p_cnt_int; // Update Output
                        p_cnt_int      <= (de_sync) ? 1 : 0;
                    end 
                    // Regular Pixel Counting
                    else if (hsync_sync & de_sync) begin
                        p_cnt_int <= p_cnt_int + 1;
                    end
                end 
            end  
        end
    end
endmodule