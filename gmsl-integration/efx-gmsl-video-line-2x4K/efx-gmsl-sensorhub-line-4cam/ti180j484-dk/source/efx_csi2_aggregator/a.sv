module csi2_aggregator_param #(
    parameter NUM_RX      = 4,       // Number of input channels
    parameter LINE_WIDTH  = 1920,    // Pixels per line
    parameter DATA_WIDTH  = 64       // Bits per pixel bus
)(
    input wire                   sys_clk,
    input wire                   rst_n,
    input wire [NUM_RX-1:0]      rx_clks,

    // Flattened RX inputs: [NUM_RX * WIDTH - 1 : 0]
    input wire [(NUM_RX*DATA_WIDTH)-1:0] rx_data_bus,
    input wire [NUM_RX-1:0]              rx_valid_bus,
    input wire [(NUM_RX*6)-1:0]          rx_dt_bus,

    // TX Output
    output reg [DATA_WIDTH-1:0]  tx_data,
    output reg [5:0]             tx_dt,
    output reg                   tx_valid,
    output reg [NUM_RX-1:0]      tx_vc_mask
);

    // Internal signals for generated blocks
    wire [DATA_WIDTH-1:0] fifo_dout [0:NUM_RX-1];
    wire [NUM_RX-1:0]     line_ready;
    reg  [NUM_RX-1:0]     rd_en_vec;
    reg  [NUM_RX-1:0]     pending_lines;

    // --- 1. Parameterized Buffer Generation ---
    genvar i;
    generate
        for (i = 0; i < NUM_RX; i = i + 1) begin : RX_CHANNEL
            
            // Local signals for each channel
            reg [11:0] wr_cnt;
            reg line_done_rx;

            // Extract specific channel data from flattened bus
            wire [DATA_WIDTH-1:0] current_rx_data = rx_data_bus[i*DATA_WIDTH +: DATA_WIDTH];
            wire                  current_rx_valid = rx_valid_bus[i];

            // Line Completion Detection
            always @(posedge rx_clks[i] or negedge rst_n) begin
                if (!rst_n) begin
                    wr_cnt <= 0;
                    line_done_rx <= 0;
                end else if (current_rx_valid) begin
                    if (wr_cnt == LINE_WIDTH - 1) begin
                        wr_cnt <= 0;
                        line_done_rx <= 1;
                    end else begin
                        wr_cnt <= wr_cnt + 1;
                        line_done_rx <= 0;
                    end
                end else line_done_rx <= 0;
            end

            // Synchronize pulse to sys_clk
            signal_sync_pulse u_sync (
                .clk_in(rx_clks[i]), .pulse_in(line_done_rx),
                .clk_out(sys_clk),   .pulse_out(line_ready[i])
            );

            // Async FIFO (Depth should be at least LINE_WIDTH)
            // Note: If LINE_WIDTH is 1920, set depth to 2048 or 4096
            async_fifo_64x4096 u_fifo (
                .wr_clk(rx_clks[i]),
                .din(current_rx_data),
                .wr_en(current_rx_valid),
                .rd_clk(sys_clk),
                .rd_en(rd_en_vec[i]),
                .dout(fifo_dout[i]),
                .empty() // Managed by rd_cnt logic
            );
        end
    endgenerate

    // --- 2. Parameterized Arbiter Logic ---
    reg [$clog2(NUM_RX)-1:0] active_vc;
    reg [11:0] rd_cnt;
    
    localparam IDLE = 1'b0, TRANSMIT = 1'b1;
    reg state;

    integer j;
    always @(posedge sys_clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            pending_lines <= 0;
            rd_en_vec <= 0;
            tx_valid <= 0;
            rd_cnt <= 0;
        end else begin
            // Update pending lines (Set on ready, Clear on read)
            pending_lines <= (pending_lines | line_ready) & ~rd_en_vec;

            case (state)
                IDLE: begin
                    tx_valid <= 0;
                    rd_en_vec <= 0;
                    rd_cnt <= 0;
                    
                    // Scalable Priority Arbiter
                    for (j = 0; j < NUM_RX; j = j + 1) begin
                        if (pending_lines[j] && (rd_en_vec == 0)) begin
                            active_vc <= j;
                            state <= TRANSMIT;
                        end
                    end
                end

                TRANSMIT: begin
                    rd_en_vec <= (1 << active_vc);
                    tx_valid  <= 1;
                    tx_data   <= fifo_dout[active_vc];
                    tx_vc_mask <= (1 << active_vc);
                    tx_dt     <= rx_dt_bus[active_vc*6 +: 6];

                    if (rd_cnt == LINE_WIDTH - 1) begin
                        state <= IDLE;
                    end else begin
                        rd_cnt <= rd_cnt + 1;
                    end
                end
            endcase
        end
    end
endmodule