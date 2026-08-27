`include "csi2_aggregator_params.svh"
import csi2_rx_cfg_pkg::*;

module csi2_aggregator_top (
    input  logic              sys_clk,
    input  logic              rst_n, // Global system reset
    
    // RX Interface (Sizes driven by package)
    input  logic [NUM_CHANNEL-1:0]        rx_clks,
    input  logic [NUM_CHANNEL-1:0]        rx_rst_n,
    input  logic [NUM_CHANNEL-1:0]        rx_vsync,
    input  logic [NUM_CHANNEL-1:0]        rx_hsync,
    input  logic [NUM_CHANNEL-1:0][MAX_DATA_WIDTH-1:0] rx_data,
    input  logic [NUM_CHANNEL-1:0]        rx_valid,
    
    // TX Interface
    output logic [MAX_DATA_WIDTH-1:0]     tx_data,
    output logic                          tx_valid,
    output logic [5:0]                    tx_data_type,
    output logic [$clog2(NUM_CHANNEL)-1:0] tx_vc_id
);

    // Arbiter/Buffer Interconnects
    logic [NUM_CHANNEL-1:0]        buf_rd_en;
    logic [NUM_CHANNEL-1:0]        buf_line_consumed;
    logic [NUM_CHANNEL-1:0][MAX_DATA_WIDTH-1:0] buf_rd_data;
    logic [NUM_CHANNEL-1:0][$clog2(8):0]        buf_lines_ready; 
    logic [NUM_CHANNEL-1:0]                     buf_line_empty;


//module async_multi_line_buffer #(
//    parameter int DATA_WIDTH    = 64,
//    parameter int PIXEL_PER_CLK = 4, 
//    parameter int LINE_WIDTH    = 1920,
//    parameter int NUM_LINES     = 4
//)(
//    // Write Domain (Camera/RX)
//    input  logic                   wr_clk,
//    input  logic                   wr_rst_n,
//    input  logic                   wr_vsync,   // Active High Level
//    input  logic                   wr_hsync,   // Active High Level
//    input  logic [DATA_WIDTH-1:0]  wr_data,
//    input  logic                   wr_en,
//    output logic [31:0]            wr_frame_count,
//	
//	output logic wr_line_full,    // Current line being written is at the last pixel
//    output logic wr_buffer_full,     // All NUM_LINES are stored and ready
//   
//	
//    
//    // Read Domain (System/Aggregator)
//    input  logic                   rd_clk,
//    input  logic                   rd_rst_n,
//    output logic                   rd_vsync,   // Synchronized to rd_clk
//    output logic                   rd_hsync,   // Synchronized to rd_clk
//    input  logic                   rd_en,
//    output logic [DATA_WIDTH-1:0]  rd_data,
//    input  logic                   line_consumed,
//
//    // Metadata (Synchronized to rd_clk)
//    output logic [$clog2(NUM_LINES):0] rd_lines_available,
//    output logic [15:0]                rd_wr_line_num,
//    output logic [15:0]                rd_rd_line_num,
//    output logic                       rd_sync_pulse,
//    output logic [31:0]                rd_in_frame_num,
//	
// 
//    output logic rd_line_empty,   // Current line being read is at the last pixel   
//    output logic rd_buffer_empty     // No lines are stored (0 lines available)
//	
//	
//);

    // --- 1. Dynamic Buffer Generation ---
    genvar i;
    generate
        for (i = 0; i < NUM_CHANNEL; i = i + 1) begin : RX_CHANNELS
            logic [SENSOR_ARRAY[i].DATA_WIDTH-1:0] w_buf_rd_data;
            
            async_multi_line_buffer #(
                .DATA_WIDTH     (SENSOR_ARRAY[i].DATA_WIDTH), 
                .PIXEL_PER_CLK  (SENSOR_ARRAY[i].PIXEL_PER_CLK),
                .LINE_WIDTH     (SENSOR_ARRAY[i].LINE_WIDTH),
                .NUM_LINES      (SENSOR_ARRAY[i].NUM_LINES) 
            ) u_line_buffer (
                .wr_clk         (rx_clks[i]),
                .wr_rst_n       (rx_rst_n[i]),
                .wr_vsync       (rx_vsync[i]),
                .wr_hsync       (rx_hsync[i]),
                .wr_data        (rx_data[i][SENSOR_ARRAY[i].DATA_WIDTH-1:0]),
                .wr_en          (rx_valid[i]),
                
                .rd_clk         (sys_clk),
                .rd_rst_n       (rst_n),
                .rd_en          (buf_rd_en[i]),
                .rd_data        (w_buf_rd_data),
                .line_consumed  (buf_line_consumed[i]),

                .rd_lines_available (buf_lines_ready[i]),
                .rd_line_empty      (buf_line_empty[i]),
                .wr_buffer_full        (),
                .rd_buffer_empty       ()
            );
            
            // Map small channel width to wide aggregator bus
            always_comb begin
                buf_rd_data[i] = '0; 
                buf_rd_data[i][SENSOR_ARRAY[i].DATA_WIDTH-1:0] = w_buf_rd_data;
            end
        end
    endgenerate

    // --- 2. Fair Arbiter Logic ---
    typedef enum logic [1:0] {IDLE, READ_LINE, WAIT_CONSUME} state_t;
    state_t state;
    logic [$clog2(NUM_CHANNEL)-1:0] active_ch;
    logic [$clog2(NUM_CHANNEL)-1:0] rr_ptr; 

    always_ff @(posedge sys_clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            active_ch <= 0;
            rr_ptr    <= 0;
            buf_rd_en <= 0;
            buf_line_consumed <= 0;
            tx_valid  <= 0;
        end else begin
            buf_line_consumed <= 0;
            
            case (state)
                IDLE: begin
					int idx;
                    tx_valid <= 0;
                    for (int j = 0; j < NUM_CHANNEL; j++) begin
                        idx = (rr_ptr + j >= NUM_CHANNEL) ? (rr_ptr + j - NUM_CHANNEL) : (rr_ptr + j);
                        if (buf_lines_ready[idx] > 0) begin
                            active_ch <= idx;
                            rr_ptr    <= (idx == NUM_CHANNEL-1) ? 0 : idx + 1;
                            state     <= READ_LINE;
                            break; 
                        end
                    end
                end

                READ_LINE: begin
                    buf_rd_en[active_ch] <= 1;
                    tx_valid     <= 1;
                    tx_data      <= buf_rd_data[active_ch];
                    tx_vc_id     <= active_ch;
                    tx_data_type <= SENSOR_ARRAY[active_ch].DEFAULT_DT;

                    if (buf_line_empty[active_ch]) begin
                        buf_rd_en[active_ch] <= 0;
                        state <= WAIT_CONSUME;
                    end
                end

                WAIT_CONSUME: begin
                    tx_valid <= 0;
                    buf_line_consumed[active_ch] <= 1;
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule