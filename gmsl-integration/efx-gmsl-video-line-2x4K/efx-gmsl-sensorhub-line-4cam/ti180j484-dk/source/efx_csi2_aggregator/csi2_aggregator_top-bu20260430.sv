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

    
    // TX Interface (Vectorized Syncs)
    
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


    // --- 1. Dynamic Buffer Generation ---
    genvar i;
    generate
        for (i = 0; i < NUM_CHANNEL; i = i + 1) begin : RX_CHANNELS
            logic [SENSOR_ARRAY[i].DATA_WIDTH-1:0] w_buf_rd_data;
            
            async_multi_line_buffer #(
                .DATA_WIDTH     (SENSOR_ARRAY[i].DATA_WIDTH), 
                .PIXEL_PER_CLK  (SENSOR_ARRAY[i].PIXEL_PER_CLK),
                .LINE_WIDTH     (SENSOR_ARRAY[i].LINE_WIDTH),
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

	//int HSP   ;// H-Sync Pulse
	//int HBP   ;// H-Back Porch
	//int HFP   ;// H-Front Porch

    // --- 2. Fair Arbiter FSM ---
    typedef enum logic [2:0] {IDLE, HSP, HBP, READ_LINE, EXTRA_SYNC, WAIT_CONSUME, HFP} state_t;
    state_t state;

    logic [$clog2(NUM_CHANNEL)-1:0] active_ch;
    logic [$clog2(NUM_CHANNEL)-1:0] rr_ptr; 
    logic [31:0]                    gap_counter;
	logic [15:0]                    slot_counter;
	logic [$clog2(NUM_CHANNEL)-1:0] active_slot;
    logic [15:0] 					buf_rd_en_count;
	logic [15:0] 					last_tx_count;
	

    // VSyncs are always driven by their respective synchronized buffer signals
  // assign tx_vsync = rd_vsync_sigs;


			
	always_ff @(posedge sys_clk or negedge rst_n) begin
        if (!rst_n) begin
			slot_counter <= '0;
			active_slot  <= '0;
		end else begin
			if(slot_counter == TX_SLOT_COUNT-1)
			begin
			   slot_counter <= '0;
			   if( active_slot == NUM_CHANNEL-1)
					active_slot  <=  '0;
			   else 
					active_slot  <= active_slot + 1'b1;

			   tx_vsync[active_slot] <= rd_vsync_sigs[active_slot];

			end 
			else
			begin
				slot_counter <= slot_counter+1'b1;
			end

		end 

	end
	
	

    always_ff @(posedge sys_clk or negedge rst_n) begin
        if (!rst_n) begin
            state             <= IDLE;
            active_ch         <= 0;
            rr_ptr            <= 0;
            buf_rd_en         <= '0;
            buf_line_consumed <= '0;
            tx_valid          <= 0;
            tx_hsync          <= '0; // Clear all HSync bits
            tx_data           <= '0;
            gap_counter       <= '0;
			buf_rd_en_count   <= '0;
			last_tx_count     <= '0;
        end else begin
            buf_line_consumed <= '0;
            // Default HSync to 0; it will be set high only for the active channel in READ_LINE
            tx_hsync <= '0; 

			if(last_tx_count!=0)
			begin
				last_tx_count <= last_tx_count -1;
			end


            case (state)
                IDLE: begin
                    tx_valid  <= 0;
                    buf_rd_en <= '0;
					
					 

                    for (int j = 0; j < NUM_CHANNEL; j++) begin
                        automatic int idx = (rr_ptr + j >= NUM_CHANNEL) ? (rr_ptr + j - NUM_CHANNEL) : (rr_ptr + j);
                        
                        if (buf_lines_ready[idx] > 0) begin
                            active_ch <= idx;
                            rr_ptr    <= (idx == NUM_CHANNEL-1) ? 0 : idx + 1;
                            state     <= READ_LINE;

							tx_frame_num <= frame_num[idx];
							tx_line_num <= line_num[idx];
							tx_line_count <=  SENSOR_ARRAY[idx].LINE_WIDTH;


							if (TX_HSP > 0) begin
								gap_counter <= TX_HSP - 1;
								state       <= HSP;
							end else begin

								if (TX_HBP > 0) begin
									gap_counter <= TX_HBP - 1;
									state       <= HBP;
								end else begin
									state       <= READ_LINE;
									buf_rd_en[idx] <= 1;
									buf_rd_en_count<= 0;
								end
								
							end
							
							
							
                            break; 
                        end
                    end
                end
				HSP: begin
				    tx_hsync[active_ch]  <= 0; 
					
                    if (gap_counter == 0) begin
                        if (TX_HBP > 0) begin
							gap_counter <= TX_HBP - 1;
							state       <= HBP;
						end else begin
							state       <= READ_LINE;
							buf_rd_en[active_ch] <= 1;
							buf_rd_en_count      <= 0;
						end
                    end else begin
                        gap_counter <= gap_counter - 1;
                    end
                end
				HBP: begin
				    tx_hsync[active_ch]  <= 1; 

                    if (gap_counter == 0) begin
                        state <= READ_LINE;
						buf_rd_en[active_ch] <= 1;
						buf_rd_en_count	     <= 0;
                    end else begin
                        gap_counter <= gap_counter - 1;
                    end
                end				
                READ_LINE: begin
                    buf_rd_en[active_ch] <= 1;
					buf_rd_en_count		 <= buf_rd_en_count + 1;
					tx_valid             <= 1;
                    
                    tx_hsync[active_ch]  <= 1; 
                    
                    tx_data              <= buf_rd_data[active_ch];
                    tx_vc_id             <= active_ch;
                    tx_data_type         <= SENSOR_ARRAY[active_ch].DEFAULT_DT;

                    if (buf_line_empty[active_ch]) begin
                        buf_rd_en[active_ch] <= 0;
						state <= WAIT_CONSUME;
                    end
                end

                WAIT_CONSUME: begin
					tx_hsync[active_ch]  <= 1; 
                    tx_valid <= 0;
					
                    buf_line_consumed[active_ch] <= 1; 
                   
					if (TX_HFP > 0) begin
						gap_counter <= TX_HFP - 1;
						state       <= HFP;
					end else begin
						state       <= IDLE;
					end
					
                end

                HFP: begin
					tx_hsync[active_ch]  <= 1; 
					
					
					
                    if (gap_counter == 0) begin
						if(last_tx_count == 0) begin 
							state <= IDLE;
							last_tx_count <= buf_rd_en_count;
						end 
                    end else begin
                        gap_counter <= gap_counter - 1;
                    end
                end
            endcase
        end
    end
endmodule