`timescale 1ns/1ps
//`include "csi2_aggregator_params.svh"
import csi2_rx_cfg_pkg::*;

module tb_csi2_aggregator;

    // --- Global Signals ---
    logic sys_clk = 0;
    logic rst_n = 0;

    // --- Aggregator Interface Arrays ---
    logic [NUM_CHANNEL-1:0]        rx_clks = '0;
    logic [NUM_CHANNEL-1:0]        rx_rst_n = '0;
    logic [NUM_CHANNEL-1:0]        rx_vsync = '0;
    logic [NUM_CHANNEL-1:0]        rx_hsync = '0;
    logic [NUM_CHANNEL-1:0][MAX_DATA_WIDTH-1:0] rx_data = '0;
    logic [NUM_CHANNEL-1:0]        rx_valid = '0;

    // --- TX Interface ---
    logic [MAX_DATA_WIDTH-1:0]     tx_data;
    logic                          tx_valid;
    logic [NUM_CHANNEL-1:0]		   tx_vsync;   // Added: Frame indicator
    logic [NUM_CHANNEL-1:0]		   tx_hsync;   // Added: Line/Data indicator
    logic [5:0]                    tx_data_type;
    logic [$clog2(NUM_CHANNEL)-1:0] tx_vc_id;

    // --- 1. Clock Generation ---
    // System Clock: 200 MHz
    always #2.5 sys_clk = ~sys_clk;

    // Camera Clocks (Each running at slightly different speeds to simulate reality)
    initial begin
        fork
//            forever #3.367 rx_clks[0] = ~rx_clks[0]; // ~148.5 MHz
//            forever #5.000 rx_clks[1] = ~rx_clks[1]; // 100 MHz
//            forever #8.000 rx_clks[2] = ~rx_clks[2]; // 62.5 MHz
//            forever #3.500 rx_clks[3] = ~rx_clks[3]; // ~142 MHz

            forever #20.00 rx_clks[0] = ~rx_clks[0]; // 25 MHz
            forever #20.00 rx_clks[1] = ~rx_clks[1]; // 25 MHz
            forever #20.00 rx_clks[2] = ~rx_clks[2]; // 25 MHz
            forever #20.00 rx_clks[3] = ~rx_clks[3]; // 25 MHz


        join
    end

    // --- 2. DUT Instance ---
    csi2_aggregator_top dut (.*);

    // --- 3. Camera Simulation Task ---
    // This task mimics one MIPI RX channel
    task automatic simulate_camera(int ch_idx);
        chan_cfg_t cfg = SENSOR_ARRAY[ch_idx];
        int words_per_line = (cfg.LINE_WIDTH + cfg.PIXEL_PER_CLK - 1) / cfg.PIXEL_PER_CLK;
        
        $display("[CH %0d] Starting Simulation: %0d Pixels/Line", ch_idx, cfg.LINE_WIDTH);

        // Reset channel
        rx_rst_n[ch_idx] = 0;
        repeat(10) @(posedge rx_clks[ch_idx]);
        rx_rst_n[ch_idx] = 1;

        forever begin
            // Frame Start
            rx_vsync[ch_idx] = 1;
            repeat(10) @(posedge rx_clks[ch_idx]); // Vertical Blanking

            for (int v = 0; v < 10; v++) begin // Simulate only 10 lines for speed
                // Horizontal Blanking
                rx_hsync[ch_idx] = 0;
                repeat(20) @(posedge rx_clks[ch_idx]);
                
                // Active Video
                rx_hsync[ch_idx] = 1;
                for (int h = 0; h < words_per_line; h++) begin
                    @(posedge rx_clks[ch_idx]);
                    rx_valid[ch_idx] = 1;
                    // Pattern: [8-bit CH | 8-bit Line | 16-bit Pixel | 32-bit AA]
                    rx_data[ch_idx] = {8'(ch_idx), 8'(v), 16'(h), 32'hAAAA_BBBB};
                end
                @(posedge rx_clks[ch_idx]);
                rx_valid[ch_idx] = 0;
                rx_hsync[ch_idx] = 0;
            end
            
            rx_vsync[ch_idx] = 0;
            repeat(500) @(posedge rx_clks[ch_idx]); // Inter-frame delay
        end
    endtask

    // --- 4. Main Simulation Stimulus ---
    initial begin
        $display("--- Starting Multi-Channel Aggregator Test ---");
        rst_n = 0;
        #100 rst_n = 1;

        // Start all 4 cameras in parallel
        for (int i = 0; i < NUM_CHANNEL; i++) begin
            fork
                automatic int idx = i; // Create local copy for automatic task
                simulate_camera(idx);
            join_none
        end

        // Run for a specific time or until a condition is met
        #500000;
        $display("--- Simulation Finished ---");
        $stop;
    end

    // --- 5. Monitor/Checker ---
    // Log TX output to console to verify Round-Robin is working
    always @(posedge sys_clk) begin
        if (tx_valid) begin
            $display("TX Output: VC=%0d | DT=0x%0h | Data=%0h", 
                     tx_vc_id, tx_data_type, tx_data);
        end
    end

endmodule