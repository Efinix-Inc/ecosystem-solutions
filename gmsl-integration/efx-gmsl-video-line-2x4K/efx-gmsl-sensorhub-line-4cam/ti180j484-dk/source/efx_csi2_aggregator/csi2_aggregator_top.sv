`include "csi2_aggregator_params.svh"
import csi2_rx_cfg_pkg::*;

module csi2_aggregator_top 
(
    input  logic              sys_clk,
    input  logic              rst_n, 
    
    // RX Interface
    input  logic [NUM_CHANNEL-1:0]        rx_clks,
    input  logic [NUM_CHANNEL-1:0]        rx_rst_n,
    input  logic [NUM_CHANNEL-1:0]        rx_vsync,
    input  logic [NUM_CHANNEL-1:0]        rx_hsync,
    `ifdef SIM
    	input  logic [NUM_CHANNEL-1:0][MAX_DATA_WIDTH-1:0] rx_data,
    `else
		input  logic [NUM_CHANNEL*MAX_DATA_WIDTH-1:0] rx_data,
	`endif
    input  logic [NUM_CHANNEL-1:0]        rx_valid,

    output logic [NUM_CHANNEL*32-1:0]     rx_frame_count,
    output logic [NUM_CHANNEL*16-1:0]     rx_line_count,

    output logic tx_global_hsync, 

    // TX Interface (Vectorized Syncs)
    input  logic 						  tx_enable,
	
    output logic [MAX_DATA_WIDTH-1:0]     tx_data,
    output logic                          tx_valid,
    output logic [NUM_CHANNEL-1:0]        tx_vsync,     // Individual VSync per VC
    output logic [NUM_CHANNEL-1:0]        tx_hsync,     // Individual HSync per VC
    output logic [5:0]                    tx_data_type,
    output logic [$clog2(NUM_CHANNEL)-1:0] tx_vc_id,
    output logic [31:0]  tx_frame_num,
    output logic [15:0]  tx_line_num,
	output logic [15:0]  tx_line_count
	


);

    // --- Interconnects ---
    logic [NUM_CHANNEL-1:0]        buf_rd_en;
    logic [NUM_CHANNEL-1:0]        buf_line_consumed;
    logic [NUM_CHANNEL-1:0][MAX_DATA_WIDTH-1:0] buf_rd_data;
    logic [NUM_CHANNEL-1:0][$clog2(8):0]        buf_lines_ready; 
    logic [NUM_CHANNEL-1:0]                     buf_line_empty;
    logic [NUM_CHANNEL-1:0]                     buf_empty;
    logic [NUM_CHANNEL-1:0]                     wr_line_full;
    logic [NUM_CHANNEL-1:0]                     wr_buffer_full;    
    logic [NUM_CHANNEL-1:0]                     rd_vsync_sigs; 


	logic [NUM_CHANNEL-1:0][31:0]  frame_num;
	logic [NUM_CHANNEL-1:0][15:0]  line_num;

	
	typedef enum logic [2:0] {F_IDLE, F_WAIT_START, F_READ_LINES, F_READ_LAST_LINE, F_WAIT_END} frame_state_t;
	frame_state_t [NUM_CHANNEL-1:0] frame_state;
	logic [NUM_CHANNEL-1:0] frame_state_update;
	
	// --- 1. Dynamic Buffer Generation ---
    genvar i;
    generate
        for (i = 0; i < NUM_CHANNEL; i = i + 1) begin : RX_CHANNELS
            logic [SENSOR_ARRAY[i].DATA_WIDTH-1:0] w_buf_rd_data;
            logic [2:0] rd_frame_state_vector;
			// Proper procedural assignment
			always_comb begin
				frame_state[i] = frame_state_t'(rd_frame_state_vector);
			end
			

            async_multi_line_buffer #(
                .DATA_WIDTH     (SENSOR_ARRAY[i].DATA_WIDTH), 
                .PIXEL_PER_CLK  (SENSOR_ARRAY[i].PIXEL_PER_CLK),
                .LINE_WIDTH     (SENSOR_ARRAY[i].LINE_WIDTH),
				.FRAME_HEIGHT   (SENSOR_ARRAY[i].FRAME_HEIGHT),
                .NUM_LINES      (SENSOR_ARRAY[i].NUM_LINES), 
				.RD_EMPTY_OFFSET(2)
            ) u_line_buffer (
                .wr_clk         (rx_clks[i]),
                .wr_rst_n       (rx_rst_n[i]),
                .wr_vsync       (rx_vsync[i]),
                .wr_hsync       (rx_hsync[i]),
           		`ifdef SIM
           		.wr_data        (rx_data[i][SENSOR_ARRAY[i].DATA_WIDTH-1:0]),
           		`else	 
                .wr_data        (rx_data[i*MAX_DATA_WIDTH +: SENSOR_ARRAY[i].DATA_WIDTH]),
                `endif
                .wr_en          (rx_valid[i]),
                .rd_clk         (sys_clk),
                .rd_rst_n       (rst_n),
                .rd_en          (buf_rd_en[i]),
                .rd_data        (w_buf_rd_data),
                .line_consumed  (buf_line_consumed[i]),
				.rd_frame_state (rd_frame_state_vector),
				.frame_state_update(frame_state_update[i]),
				
                .rd_vsync       (rd_vsync_sigs[i]), 
                .rd_hsync       (),                 
                .rd_lines_available (buf_lines_ready[i]),
                .rd_line_empty      (buf_line_empty[i]),
				.rd_buffer_empty    (buf_empty[i]),
				
                .rd_rd_frame_num(frame_num[i]),
                .rd_rd_line_num(line_num[i]),
                .wr_line_full(wr_line_full[i]),    // Current line being written is at the last pixel
                .wr_buffer_full(wr_buffer_full[i])     // All NUM_LINES are stored and ready
            );
            
            assign rx_frame_count[i*32 +: 32] = frame_num[i];
            assign rx_line_count [i*16 +: 16] = line_num[i];
            
            always_comb begin
                buf_rd_data[i] = '0; 
                buf_rd_data[i][SENSOR_ARRAY[i].DATA_WIDTH-1:0] = w_buf_rd_data;
            end
        end
    endgenerate


	

    // VSyncs are always driven by their respective synchronized buffer signals
  // assign tx_vsync = rd_vsync_sigs;

	logic global_hsync;
	logic global_hsync_start;
	logic global_rd_start;
	logic global_rd_end;
	logic global_hsync_end;	
	logic global_hact;
	// --- 1. 2 FSM to generate the global h-sync Pluse
	typedef enum logic [2:0] {G_IDLE, G_HSP, G_HBP, G_HACT, G_HFP} global_state_t;
    global_state_t global_state;
	logic [15:0]   global_counter;
	
	logic [$clog2(NUM_CHANNEL)-1:0] active_ch;
    logic [15:0] 					buf_rd_en_count;
	
	always_ff @(posedge sys_clk or negedge rst_n) begin
        if (!rst_n) begin
			global_state      <=G_IDLE;
			global_counter    <='d0;
			global_hsync      <='d0;
			global_hsync_start<='d0;
			global_rd_start   <='d0;
			global_rd_end     <='d0;
			global_hsync_end  <='d0;	
			global_hact       <='d0;

            tx_global_hsync   <='d0;
		end else begin
            tx_global_hsync   <= global_hsync;

        
			case (global_state)
                G_IDLE: begin 
					global_hsync_end  <='d0;
					if(tx_enable) begin 
						global_state <= G_HSP;
						global_hsync_start<='d1;
						global_counter <= TX_HSP - 1;
						global_hsync <= 0;
						global_hact  <= 0;
					end else 
						global_state <= G_IDLE;
				end 
				G_HSP: begin 
					global_hsync_start<='d0;
					global_hsync_end  <='d0;

					if (global_counter == 0) begin
                   		global_counter <= TX_HBP - 1;
						global_state       <= G_HBP;
						global_hsync <= 1;
						global_hact  <= 0;
					end
					else 
					begin 
						global_counter <= global_counter -1;
					end 
				end
				G_HBP: begin 
					if (global_counter == 0) begin
                   		global_counter <= TX_HACT - 1;
						global_rd_start   <='d1;
						global_state        <= G_HACT;
						global_hsync <= 1;
						global_hact  <= 1;
					end
					else 
					begin 
						global_counter <= global_counter -1;
					end 
				end
				G_HACT: begin 
					global_rd_start   <='d0;
					if (global_counter == 0) begin
                   		global_counter <= TX_HFP - 1;
						global_state       <= G_HFP;
						global_rd_end     <='d1;
						global_hsync <= 1;
						global_hact  <= 0;
					end
					else 
					begin 
						global_counter <= global_counter -1;
					end 
						
				end	
				G_HFP: begin 
					global_rd_end     <='d0;
					if (global_counter == 0) begin
                   		global_hsync <= 0;
						global_hact  <= 0;
						global_hsync_end  <='d1;

						global_state <= G_IDLE;
					end
					else 
					begin 
						global_counter <= global_counter -1;
					end 
				end					
			endcase
		end
	end 
		

    // --- 2. Fair Arbiter FSM ---
    typedef enum logic [3:0] {IDLE, VSYNC_START,VSYNC_START2, VSYNC_END,VSYNC_END2, READ_LINE , READ_LINE2, WAIT_CONSUME} state_t;
    state_t state;
		
	always_ff @(posedge sys_clk or negedge rst_n) begin
        if (!rst_n) begin
			state  <= IDLE;
			frame_state_update <= '0;
			tx_hsync		   <= '0;
			tx_vsync           <= '0;
			tx_valid           <= 0;
			buf_line_consumed  <= '0;
        end else begin
		    case (state)
                IDLE: begin
						logic [$clog2(8):0] max_lines;
						logic [1:0] found;

						if (global_hsync_start) 
						begin 
							
								
							max_lines = 0;
							found     = 0;
							
							// Find the channel with the maximum lines ready
							for (int j = 0; j < NUM_CHANNEL; j++) begin
								case(frame_state[j])
									F_WAIT_START: begin
										max_lines = 'b1111; 
										active_ch = j;
										found     = 1;	
									end
									F_WAIT_END: begin
										max_lines = 'b1111; 
										active_ch = j;
										found     = 2;
									end 		
                                    F_READ_LAST_LINE: begin
										if (buf_lines_ready[j] > max_lines) begin
											max_lines = buf_lines_ready[j];
											active_ch = j;
											found     = 3;
										end 
									end  
									F_READ_LINES: begin
										if (buf_lines_ready[j] > max_lines) begin
											max_lines = buf_lines_ready[j];
											active_ch = j;
											found     = 3;
										end 
									end  
																
									
								endcase
							end 
							
							if (found) begin
								tx_frame_num <= frame_num[active_ch];
								tx_line_num  <= line_num[active_ch];
								tx_vc_id     <= active_ch;
								if(found==1)begin
									state     <= VSYNC_START;
								end 
								else if(found==2)begin
									state     <= VSYNC_END;
								end 
								else if(found==3)begin
									state     <= READ_LINE;
									tx_line_count <=  SENSOR_ARRAY[active_ch].LINE_WIDTH;
								end 
						
							end 
							
							
								
							
							
						end 
				
				
				end 
				VSYNC_START: begin
					tx_vsync[active_ch]  <= 1; 
					frame_state_update[active_ch] <= 1;
					state <= VSYNC_START2;
				end 
				VSYNC_START2: begin
					frame_state_update[active_ch] <= 0;
					state <= IDLE;
				end 
				
				VSYNC_END: begin
					if(global_hsync_end)
					begin 
						tx_vsync[active_ch]  <= 0; 
						frame_state_update[active_ch] <= 1;
						state <= VSYNC_END2;
					end 
				end 
				VSYNC_END2: begin
					frame_state_update[active_ch] <= 0;
					state <= IDLE;
				end 
				READ_LINE: begin 
					tx_hsync[active_ch]  <= global_hsync;
					if(global_rd_start)begin  
						buf_rd_en[active_ch] <= 1;
						buf_rd_en_count	     <= 0;
						state <= READ_LINE2;
						tx_valid             <= 0;
					end 
				end 
				READ_LINE2: begin 
					tx_hsync[active_ch]  <= global_hsync; 
                    
					buf_rd_en[active_ch] <= 1;
					buf_rd_en_count		 <= buf_rd_en_count + 1;
					tx_valid             <= 1;
                    
                    
                    tx_data              <= buf_rd_data[active_ch];
                    tx_vc_id             <= active_ch;
                    tx_data_type         <= SENSOR_ARRAY[active_ch].DEFAULT_DT;

                    if (buf_line_empty[active_ch]) begin
                        buf_rd_en[active_ch] <= 0;
						buf_line_consumed[active_ch] <= 1; 
						state <= WAIT_CONSUME;
                    end
				end 
				WAIT_CONSUME: begin
					tx_hsync[active_ch]  <= global_hsync; 
					tx_valid <= 0;
					buf_line_consumed[active_ch] <= 0; 
                    if (global_hsync_end)
					begin 
						state <= IDLE;
						tx_hsync[active_ch] <= 0;
					end 
					
					
				end 
		    endcase
		end

	end 
	



    //// --- 2. Fair Arbiter FSM ---
    //typedef enum logic [2:0] {IDLE, HSP, HBP, READ_LINE, EXTRA_SYNC, WAIT_CONSUME, HFP} state_t;
    //state_t state;
	//
    //logic [$clog2(NUM_CHANNEL)-1:0] active_ch;
    //logic [$clog2(NUM_CHANNEL)-1:0] rr_ptr; 
    //logic [31:0]                    gap_counter;
	//logic [15:0]                    slot_counter;
	//logic [$clog2(NUM_CHANNEL)-1:0] active_slot;
    //logic [15:0] 					buf_rd_en_count;
	//logic [15:0] 					last_tx_count;
	//	
    //always_ff @(posedge sys_clk or negedge rst_n) begin
    //    if (!rst_n) begin
    //        state             <= IDLE;
    //        active_ch         <= 0;
    //        rr_ptr            <= 0;
    //        buf_rd_en         <= '0;
    //        buf_line_consumed <= '0;
    //        tx_valid          <= 0;
    //        tx_hsync          <= '0; // Clear all HSync bits
    //        tx_data           <= '0;
    //        gap_counter       <= '0;
	//		buf_rd_en_count   <= '0;
	//		last_tx_count     <= '0;
    //        ch_start     	 <= '0;
	//		ch_end	     	 <= '0;
	//		
    //    end else begin
    //        buf_line_consumed <= '0;
    //        // Default HSync to 0; it will be set high only for the active channel in READ_LINE
    //        tx_hsync <= '0; 
	//		ch_start     	 <= '0;
	//		ch_end	     	 <= '0;
	//
	//		if(last_tx_count!=0)
	//		begin
	//			last_tx_count <= last_tx_count -1;
	//		end
	//
	//
    //        case (state)
    //            IDLE: begin
    //                tx_valid  <= 0;
    //                buf_rd_en <= '0;
	//				begin 
	//					logic [$clog2(8):0] max_lines;
	//					logic found;
	//						
	//					max_lines = 0;
	//					found     = 0;
	//					
	//					// Find the channel with the maximum lines ready
	//					for (int j = 0; j < NUM_CHANNEL; j++) begin
	//						
	//						if (buf_lines_ready[j] > max_lines) begin
	//							max_lines = buf_lines_ready[j];
	//							active_ch = j;
	//							found     = 1;
	//						end
	//					end 
	//					
	//					
	//
	//					//for (int j = 0; j < NUM_CHANNEL; j++) begin
	//					//   automatic int idx = (rr_ptr + j >= NUM_CHANNEL) ? (rr_ptr + j - NUM_CHANNEL) : (rr_ptr + j);
	//						
	//						if (found) begin
	//							state     <= READ_LINE;
	//
	//							tx_frame_num <= frame_num[active_ch];
	//							tx_line_num <= line_num[active_ch];
	//							tx_line_count <=  SENSOR_ARRAY[active_ch].LINE_WIDTH;
	//
    //                            ch_start[active_ch] <= 1;
	//							if (TX_HSP > 0) begin
	//								gap_counter <= TX_HSP - 1;
	//								state       <= HSP;
    //                                 
	//							end else begin
	//
	//								if (TX_HBP > 0) begin
	//									gap_counter <= TX_HBP - 1;
	//									state       <= HBP;
	//								end else begin
	//									state       <= READ_LINE;
	//									buf_rd_en[active_ch] <= 1;
	//									buf_rd_en_count<= 0;
	//								end
	//								
	//							end
	//						end 	
	//					end 	
	//						
    //                    //    break; 
    //                    //end
    //                //end
    //            end
	//			HSP: begin
	//			    tx_hsync[active_ch]  <= 0; 
	//				
    //                if (gap_counter == 0) begin
    //                    if (TX_HBP > 0) begin
	//						gap_counter <= TX_HBP - 1;
	//						state       <= HBP;
	//					end else begin
	//						state       <= READ_LINE;
	//						buf_rd_en[active_ch] <= 1;
	//						buf_rd_en_count      <= 0;
	//					end
    //                end else begin
    //                    gap_counter <= gap_counter - 1;
    //                end
    //            end
	//			HBP: begin
	//			    tx_hsync[active_ch]  <= 1; 
	//
    //                if (gap_counter == 0) begin
    //                    state <= READ_LINE;
	//					buf_rd_en[active_ch] <= 1;
	//					buf_rd_en_count	     <= 0;
    //                end else begin
    //                    gap_counter <= gap_counter - 1;
    //                end
    //            end				
    //            READ_LINE: begin
    //                buf_rd_en[active_ch] <= 1;
	//				buf_rd_en_count		 <= buf_rd_en_count + 1;
	//				tx_valid             <= 1;
    //                
    //                tx_hsync[active_ch]  <= 1; 
    //                
    //                tx_data              <= buf_rd_data[active_ch];
    //                tx_vc_id             <= active_ch;
    //                tx_data_type         <= SENSOR_ARRAY[active_ch].DEFAULT_DT;
	//
    //                if (buf_line_empty[active_ch]) begin
    //                    buf_rd_en[active_ch] <= 0;
	//					state <= WAIT_CONSUME;
    //                end
    //            end
	//
    //            WAIT_CONSUME: begin
	//				tx_hsync[active_ch]  <= 1; 
    //                tx_valid <= 0;
	//				
    //                buf_line_consumed[active_ch] <= 1; 
    //               
	//				if (TX_HFP > 0) begin
	//					gap_counter <= TX_HFP - 1;
	//					state       <= HFP;
	//				end else begin
	//					state       <= IDLE;
    //                    ch_end[active_ch] <= 1;
	//				end
	//				
    //            end
	//
    //            HFP: begin
	//				tx_hsync[active_ch]  <= 1; 
	//				
	//				
	//				
    //                if (gap_counter == 0) begin
	//					if(last_tx_count == 0) begin 
	//						state <= IDLE;
    //                        ch_end[active_ch] <= 1;
	//						last_tx_count <= buf_rd_en_count;
	//					end 
    //                end else begin
    //                    gap_counter <= gap_counter - 1;
    //                end
    //            end
    //        endcase
    //    end
    //end
endmodule