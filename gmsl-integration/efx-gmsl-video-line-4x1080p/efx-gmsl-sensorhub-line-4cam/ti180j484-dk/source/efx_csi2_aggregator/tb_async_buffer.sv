`timescale 1ns/1ps


module tb_async_buffer;

    // --- Video Timing Parameters (Standard 1080p) ---
    parameter int H_RES = 1920;
    parameter int V_RES = 1080;
    parameter int HSP   = 44;
    parameter int HBP   = 148;
    parameter int HFP   = 88;
    parameter int VSP   = 5;
    parameter int VBP   = 36;
    parameter int VFP   = 4;

    // Derived Parameters
    parameter int D_WIDTH        = 64;
    parameter int PIXEL_P_CLK    = 4; 
    parameter int WORDS_PER_LINE  = (H_RES + PIXEL_P_CLK -1 ) / PIXEL_P_CLK;  
    parameter int N_LINES        = 4;

    // --- Signal Declarations ---
    logic wr_clk = 0;
    logic rd_clk = 0;
    logic wr_rst_n, rd_rst_n;

    logic [D_WIDTH-1:0] wr_data;
    logic               wr_en;
    logic               wr_vsync;
    logic               wr_hsync;
    logic [31:0]        wr_frame_count;

    logic               rd_en;
    logic [D_WIDTH-1:0] rd_data;
    logic               rd_vsync;
    logic               rd_hsync;
    logic               line_consumed;

    // Metadata (Synchronized to rd_clk)
    logic [$clog2(N_LINES):0] rd_lines_available;
    logic [15:0]                rd_wr_line_num;
    logic [15:0]                rd_rd_line_num;
    logic                       rd_sync_pulse;
    logic [31:0]                rd_in_frame_num;
	
    // Single Line Status (pertaining to the line currently being accessed)
    logic wr_line_full;    // Current line being written is at the last pixel
    logic rd_line_empty;   // Current line being read is at the last pixel
    
    // Total Buffer Status (pertaining to all NUM_LINES)
    logic wr_buffer_full;     // All NUM_LINES are stored and ready
    logic rd_buffer_empty;     // No lines are stored (0 lines available)

    // --- Clock Generation ---
    always #3.367 wr_clk = ~wr_clk; // ~148.5 MHz
    always #2.500 rd_clk = ~rd_clk; // 200 MHz

    // --- DUT Instance ---
    async_multi_line_buffer #(
        .DATA_WIDTH(D_WIDTH),
        .PIXEL_PER_CLK(PIXEL_P_CLK),
        .LINE_WIDTH(H_RES),
        .NUM_LINES(N_LINES)
    ) dut (.*);

    // --- Simulation Logic ---
    initial begin
        // Initialize
        wr_rst_n = 0; rd_rst_n = 0;
        wr_en = 0; wr_vsync = 0; wr_hsync = 0;
        rd_en = 0; line_consumed = 0; wr_data = 0;

        // Reset Sequence
        repeat(20) @(posedge wr_clk);
        wr_rst_n = 1; 
        repeat(20) @(posedge rd_clk);
        rd_rst_n = 1;

        $display("Starting Video Simulation with Long VSync...");

        // Simulate 2 Full Frames
        repeat(2) begin
            // 1. Start of Frame: VSync goes High
           // @(posedge wr_clk);
			
			repeat(VSP) call_hblank();
			wr_vsync = 1;

            // 2. Vertical Back Porch (VSync remains High)
            repeat(VBP) call_hblank();

            // 3. Active Video Lines
            for (int v = 0; v < V_RES; v++) begin
                // Horizontal Blanking (Sync + Back Porch)
                repeat(HSP) @(posedge wr_clk);
                // Active Pixels
                wr_hsync = 1; 
 
				repeat(HBP) @(posedge wr_clk);

                for (int h = 0; h < WORDS_PER_LINE; h++) begin
                    @(posedge wr_clk);
                    wr_en   = 1;
                    // Pattern: [16-bit Line Index | 16-bit Word Index | 32-bit Dummy]
                    wr_data = {16'(v), 16'(h), 32'h55AA_55AA};
                end
                @(posedge wr_clk);
                wr_en    = 0;
				
				// Horizontal Front Porch
                repeat(HFP) @(posedge wr_clk);
                wr_hsync = 0;

                
                
                // Read Logic Trigger: If buffer is getting full, read a line
                if (rd_lines_available >= 2) begin
                    fork 
                        read_and_check_line(v - (rd_wr_line_num - rd_rd_line_num)); 
                    join_none
                end
            end

            // 4. Vertical Front Porch (VSync remains High)
            repeat(VFP) call_hblank();

            // 5. End of Frame: VSync goes Low briefly before next frame
            wr_vsync = 0;
            repeat(100) @(posedge wr_clk);
        end

        $display("Simulation Finished Successfully.");
        $stop;
    end

    // --- Helper Tasks ---

    task call_hblank();
    // --    repeat(HSP + HBP + WORDS_PER_LINE + HFP) @(posedge wr_clk);
		
		repeat(HSP) @(posedge wr_clk);
                // Active Pixels
                wr_hsync = 1; 
		repeat(HBP) @(posedge wr_clk);
		repeat(WORDS_PER_LINE) @(posedge wr_clk);
		repeat(HFP) @(posedge wr_clk);
                wr_hsync = 0;		
    endtask

    task read_and_check_line(int expected_line_idx);
        logic [15:0] actual_v, actual_h;
        
        @(posedge rd_clk);
        for (int i = 0; i < WORDS_PER_LINE; i++) begin
            @(posedge rd_clk);
            rd_en = 1;
            // On next clock, data is available (assuming zero-latency RAM for simplicity)
            // If your RAM has 1-cycle latency, check data on the next cycle.
            actual_v = rd_data[63:48];
            actual_h = rd_data[47:32];
            
            // Optional Integrity Check
            if (rd_en && (actual_h != i)) begin
                //$display("Data Mismatch at Line %0d! Expected H %0d, Got %0d", expected_line_idx, i, actual_h);
            end
        end
        @(posedge rd_clk);
        rd_en = 0;
        line_consumed = 1;
        @(posedge rd_clk);
        line_consumed = 0;
    endtask

endmodule