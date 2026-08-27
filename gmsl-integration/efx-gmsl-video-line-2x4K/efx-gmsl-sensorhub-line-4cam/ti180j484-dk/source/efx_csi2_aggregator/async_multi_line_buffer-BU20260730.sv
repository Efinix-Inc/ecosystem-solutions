module async_multi_line_buffer #(
    parameter int DATA_WIDTH    = 64,
    parameter int PIXEL_PER_CLK = 4, 
    parameter int LINE_WIDTH    = 1920,
	parameter int FRAME_HEIGHT  = 1080,
    parameter int NUM_LINES     = 4,
	
	parameter int RD_EMPTY_OFFSET= 2

	
)(
    // Write Domain (Camera/RX)
    input  logic                   wr_clk,
    input  logic                   wr_rst_n,
    input  logic                   wr_vsync,   // Active High Level
    input  logic                   wr_hsync,   // Active High Level
    input  logic [DATA_WIDTH-1:0]  wr_data,
    input  logic                   wr_en,
    output logic [31:0]            wr_frame_count,
	
	output logic wr_line_full,    // Current line being written is at the last pixel
    output logic wr_buffer_full,     // All NUM_LINES are stored and ready
   
	
    
    // Read Domain (System/Aggregator)
    input  logic                   rd_clk,
    input  logic                   rd_rst_n,
    output logic                   rd_vsync,   // Synchronized to rd_clk
    output logic                   rd_hsync,   // Synchronized to rd_clk
    input  logic                   rd_en,
    output logic [DATA_WIDTH-1:0]  rd_data,
    input  logic                   line_consumed,
	
	output logic [2:0]			   rd_frame_state,
	input  logic 				   frame_state_update,

    // Metadata (Synchronized to rd_clk)
    
    output logic [15:0]                rd_wr_line_num,
	output logic [$clog2(NUM_LINES):0] rd_lines_available,	
    output logic [15:0]                rd_rd_line_num,
	

	
    output logic [31:0]                rd_rd_frame_num,
	
 
    output logic rd_line_empty,      // Current line being read is at the last pixel   
//	output logic rd_line_pro_empty,  // Programmable Empty that would assert earlier to fixed the read latency. 
    output logic rd_buffer_empty,     // No lines are stored (0 lines available)
	

	output logic                       rd_sync_pulse
	
);

    localparam int WORDS_PER_LINE = (LINE_WIDTH + PIXEL_PER_CLK - 1) / PIXEL_PER_CLK;
    
    // --- RAM Inference ---
    (* syn_ramstyle = "block_ram" *)  logic [DATA_WIDTH-1:0] ram [NUM_LINES * WORDS_PER_LINE];

    // --- Write Domain Logic ---
    logic wr_vsync_d, wr_hsync_d, wr_en_d;
	
    //logic vsync_rising_wr;
    logic [$clog2(WORDS_PER_LINE)-1:0] wr_ptr;
    logic [$clog2(NUM_LINES)-1:0]      wr_line_idx;
    logic                              wr_line_done_pulse;
	logic r_rd_vsync;         

    logic rd_line_num_compare;
	
	
	

    always_ff @(posedge wr_clk or negedge wr_rst_n) begin
        if (!wr_rst_n) begin
            wr_vsync_d <= 0;
            wr_ptr <= 0;
            wr_line_idx <= 0;
            wr_frame_count <= 0;
            wr_line_done_pulse <= 0;
			wr_line_full <= 0;
        end else begin
            wr_vsync_d <= wr_vsync;
            wr_hsync_d <= wr_hsync;
			wr_en_d    <= wr_en;

            if (wr_vsync && !wr_vsync_d) begin // Start of Frame
                wr_frame_count <= wr_frame_count + 1;
			end 
			
			
			if (!wr_hsync) begin 
				wr_ptr <= 0;
				wr_line_done_pulse <= 0; 
				if(wr_hsync_d)    
				begin
					if(wr_ptr!=0)
					begin 
						wr_line_idx <= (wr_line_idx == NUM_LINES - 1) ? 0 : wr_line_idx + 1;
					end
				end 
			end 
			else 
			begin 
				if (wr_en ) begin 
					if (wr_ptr < WORDS_PER_LINE)
					begin 
						ram[(wr_line_idx * WORDS_PER_LINE) + wr_ptr] <= wr_data;
						wr_ptr <= wr_ptr + 1;
					end 
					else 
					begin
						wr_line_full <= 1;
					end 
					
					if (wr_ptr == WORDS_PER_LINE - 1) begin 
						wr_line_done_pulse <= 1; 
						
					end 
					else 
					begin 
						wr_line_done_pulse <= 0; 
					end 	
				end 
				else 
				begin 
					wr_line_done_pulse <= 0; 
				end 
			end 
        end
    end

    // --- Clock Domain Crossing (CDC) ---
    logic rd_wr_en_pulse;
    logic rd_vsync_pulse;
	logic rd_vsync_pulse_end;
    logic rd_hsync_pulse;
	logic rd_hsync_pulse_end;


    logic rd_line_ready_pulse;

    // Sync Frame Start (VSYNC event)
    pulse_sync u_vsync_sync (
        .clk_in(wr_clk), .rst_in(wr_rst_n), .pulse_in(wr_vsync && !wr_vsync_d),
        .clk_out(rd_clk), .rst_out(rd_rst_n), .pulse_out(rd_vsync_pulse)
    );
	
	// Sync Frame End (VSYNC event)
    pulse_sync u_vsync_sync_end (
        .clk_in(wr_clk), .rst_in(wr_rst_n), .pulse_in(!wr_vsync && wr_vsync_d),
        .clk_out(rd_clk), .rst_out(rd_rst_n), .pulse_out(rd_vsync_pulse_end)
    );

	// Sync Line Start (HSYNC event)
	pulse_sync u_hsync_sync (
        .clk_in(wr_clk), .rst_in(wr_rst_n), .pulse_in(wr_hsync && !wr_hsync_d),
        .clk_out(rd_clk), .rst_out(rd_rst_n), .pulse_out(rd_hsync_pulse)
    );
	
	// Sync Line End (HSYNC event)
    pulse_sync u_hsync_sync_end (
        .clk_in(wr_clk), .rst_in(wr_rst_n), .pulse_in(!wr_hsync && wr_hsync_d),
        .clk_out(rd_clk), .rst_out(rd_rst_n), .pulse_out(rd_hsync_pulse_end)
    );



    // Sync WR Enable Start (WR enable event)
    pulse_sync u_wr_en_sync (
        .clk_in(wr_clk), .rst_in(wr_rst_n), .pulse_in(wr_en && !wr_en_d),
        .clk_out(rd_clk), .rst_out(rd_rst_n), .pulse_out(rd_wr_en_pulse)
    );

    // Sync Line Done (HSYNC event)
    pulse_sync u_line_Done_sync (
        .clk_in(wr_clk), .rst_in(wr_rst_n), .pulse_in(wr_line_done_pulse),
        .clk_out(rd_clk), .rst_out(rd_rst_n), .pulse_out(rd_line_ready_pulse)
    );

    // --- Read Domain Logic ---
    logic [$clog2(WORDS_PER_LINE)-1:0] rd_ptr;
    logic [$clog2(NUM_LINES)-1:0]      rd_line_idx;
	
	logic 						rd_frame_start;
	logic 					    rd_frame_end;

    always_ff @(posedge rd_clk or negedge rd_rst_n) begin
        if (!rd_rst_n) begin
            rd_ptr <= 0;
            rd_line_idx <= 0;
            rd_lines_available <= 0;
            rd_vsync <= 0;
			r_rd_vsync <= 0;
			
			rd_hsync <= 0;
            rd_wr_line_num <= 0;
            rd_rd_line_num <= 0;
			rd_rd_frame_num <=0;
            
            rd_line_num_compare <=0;
			
			rd_frame_start <= 0;
			rd_frame_end   <= 0;
			
        end else begin
            // 1. Handle VSYNC (Reset read side on new frame)
            if (rd_vsync_pulse) begin
                rd_line_idx <= 0;
                rd_rd_line_num <= 0;
                rd_wr_line_num <= 0;
                rd_lines_available <= 0;

	        end
			
			if (rd_vsync_pulse) begin
				rd_vsync <=1;
            end 
			else if (rd_vsync_pulse_end) 
			begin 
				rd_vsync <=0;
				rd_rd_frame_num<= rd_rd_frame_num+1;
                          	     
			end 

			if (rd_hsync_pulse) begin
				rd_hsync <= 1;
            end 
			else if (rd_hsync_pulse_end) 
			begin
				rd_hsync <= 0;
				// rd_vsync <= r_rd_vsync;
			end 

            // 2. Track available lines
            case ({rd_line_ready_pulse, line_consumed})
                2'b10: rd_lines_available <= rd_lines_available + 1;
                2'b01: rd_lines_available <= (rd_lines_available > 0) ? rd_lines_available - 1 : 0;
            endcase

					
			//if( rd_line_ready_pulse && (rd_wr_line_num == 0) ) 
			if( rd_vsync_pulse) 
			begin
				rd_frame_start <= 1'b1;
			end 
			else 
			begin 
				rd_frame_start <= 1'b0;
			end 

			if(rd_vsync_pulse_end)
			//if( line_consumed && (rd_rd_line_num == FRAME_HEIGHT-1) )
			begin 
				rd_frame_end <= 1'b1;			
			end 
			else 
			begin 
				rd_frame_end <= 1'b0;						
			end 

			

            if (rd_line_ready_pulse) begin
				rd_wr_line_num <= rd_wr_line_num + 1;
			end 
            // 3. Handle Data Reading & HSYNC
            if (rd_en) begin
                if (rd_ptr == WORDS_PER_LINE - 1) begin
                    rd_ptr <= 0;
					
                end else begin
                    rd_ptr <= rd_ptr + 1;
                end
            end 


            if (line_consumed) begin
						
                rd_line_idx <= (rd_line_idx == NUM_LINES - 1) ? 0 : rd_line_idx + 1;
                rd_rd_line_num <= rd_rd_line_num + 1;
                
                if( (rd_rd_line_num+1) != rd_wr_line_num ) 
                begin 
                    rd_line_num_compare <= 1'b1;
                end 
                else 
                begin
                    rd_line_num_compare <= 1'b0;
                end 
                
            end
        end
    end

    //assign rd_data = ram[(rd_line_idx * WORDS_PER_LINE) + rd_ptr];
	always_ff @(posedge rd_clk) begin
        rd_data <= ram[(rd_line_idx * WORDS_PER_LINE) + rd_ptr];
    end

// --- 1. Single Line Status Logic ---
    // wr_line_full: High when the write pointer reaches the end of one line
 //   assign wr_line_full = (wr_ptr == WORDS_PER_LINE) && wr_en;

    // rd_line_empty: High when the read pointer reaches the end of one line
   // assign rd_line_empty = (rd_ptr == WORDS_PER_LINE) && rd_en;

    // --- 2. Total Buffer Status Logic (rd_clk domain) ---
    always_ff @(posedge rd_clk or negedge rd_rst_n) begin
        if (!rd_rst_n) begin
            wr_buffer_full  <= 0;
            rd_buffer_empty <= 1;
			
			rd_line_empty <=1;
			//rd_line_pro_empty <= 1;
        end else begin
            // Total Buffer Full: No more lines can be stored
            wr_buffer_full  <= (rd_lines_available == NUM_LINES);
            
            // Total Buffer Empty: No lines available to be read
            rd_buffer_empty <= (rd_lines_available == 0);
			
			
			if ((rd_ptr == WORDS_PER_LINE-RD_EMPTY_OFFSET) && rd_en)
			begin 
				rd_line_empty <= 1'b1;
			end
			else if(rd_lines_available != 0 )
			begin 
				rd_line_empty <=1'b0;
			end
			
		//	if ((rd_ptr == WORDS_PER_LINE-1-RD_EMPTY_OFFSET) && rd_en)
		//	begin 
		//		rd_line_pro_empty <= 1'b1;
		//	end
		//	else if(rd_lines_available != 0 )
		//	begin 
		//		rd_line_pro_empty <=1'b0;
		//	end
			
			
			
			
			
		
        end
    end
	
	
	typedef enum logic [2:0] {F_IDLE, F_WAIT_START, F_READ_LINES, F_WAIT_END} frame_state_t;
	frame_state_t frame_state;
	
	
	assign rd_frame_state = frame_state;
	
	always_ff @(posedge rd_clk or negedge rd_rst_n) begin
        if (!rd_rst_n) begin
			frame_state <= F_IDLE;
		end else begin
			case(frame_state)
				F_IDLE:begin
					if(rd_frame_start) begin 
						frame_state<= F_WAIT_START;
					end
				end 
				F_WAIT_START:begin
					if(frame_state_update)
					begin
						frame_state<= F_READ_LINES;
					end 
				end
				
				F_READ_LINES:begin
					if(rd_frame_end)
					begin
						frame_state<= F_WAIT_END;
					end 
				end
				
				F_WAIT_END:begin
					if(frame_state_update)
					begin
						frame_state<= F_IDLE;
					end 
				end
				
			endcase
		
		end 
	end
		


endmodule