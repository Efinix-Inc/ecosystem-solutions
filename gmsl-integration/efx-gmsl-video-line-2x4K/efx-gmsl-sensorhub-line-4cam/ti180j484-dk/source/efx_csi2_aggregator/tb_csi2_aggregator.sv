`timescale 1ns/1ps
import csi2_rx_cfg_pkg::*;
import csi2_rx_sim_pkg::*;

module tb_csi2_aggregator;

    // --- 2. Signal Declarations ---
    logic sys_clk = 0;
    logic rst_n = 0;

    logic [NUM_CHANNEL-1:0]        rx_clks = '0;
    logic [NUM_CHANNEL-1:0]        rx_rst_n = '0;
    logic [NUM_CHANNEL-1:0]        rx_vsync = '0;
    logic [NUM_CHANNEL-1:0]        rx_hsync = '0;
    logic [NUM_CHANNEL-1:0][MAX_DATA_WIDTH-1:0] rx_data = '0;
    logic [NUM_CHANNEL-1:0]        rx_valid = '0;

    logic [MAX_DATA_WIDTH-1:0]     tx_data;
    logic                          tx_valid;
    logic [NUM_CHANNEL-1:0]        tx_vsync;
    logic [NUM_CHANNEL-1:0]        tx_hsync;
    logic [5:0]                    tx_data_type;
    logic [$clog2(NUM_CHANNEL)-1:0] tx_vc_id;

    logic [NUM_CHANNEL-1:0]        rx_start;
	logic [NUM_CHANNEL-1:0][31:0]  tx_hsync_count;
	logic [31:0]  				   tx_valid_count;


	logic [31:0]  tx_frame_num;
	logic [15:0]  tx_line_num;
    // --- 3. Clock Generation ---
    always #2.5 sys_clk = ~sys_clk; // 200 MHz

	generate
	for (genvar i = 0; i < NUM_CHANNEL; i++) begin : clk_gen
		initial forever #SIM_SENSOR_ARRAY[i].CLK rx_clks[i] = ~rx_clks[i];
	end
	endgenerate

	logic [NUM_CHANNEL-1:0][31:0]  w_rx_frame_count;
    logic [NUM_CHANNEL-1:0][31:0]  w_rx_hsync_per_frame;
    logic [NUM_CHANNEL-1:0][31:0]  w_rx_pixel_per_line;
    logic [NUM_CHANNEL-1:0][31:0]  w_rx_frame_rate;      // Measured in Hz 
	
	logic [NUM_CHANNEL-1:0][31:0]  w_tx_frame_count;
    logic [NUM_CHANNEL-1:0][31:0]  w_tx_hsync_per_frame;
    logic [NUM_CHANNEL-1:0][31:0]  w_tx_pixel_per_line;
    logic [NUM_CHANNEL-1:0][31:0]  w_tx_frame_rate;      // Measured in Hz 


genvar x;
generate 
	for(x=0; x< NUM_CHANNEL; x=x+1)
	begin:csi_rx_monitor

     
        
        video_monitor inst_csi_rx_monitor(
            .clk(rx_clks[x]),        // Pixel clock
            .reset_n(rx_rst_n[x]),
            .vsync(rx_vsync[x]),
            .hsync(rx_hsync[x]),
            .de(rx_valid[x]),         // Data Enable / Valid
            .ref_clk_hz(32'd50_000_000), // Frequency of the pixel clock (for rate calc)
            
            .hsync_per_frame(w_rx_hsync_per_frame[x]),
            .pixel_per_line (w_rx_pixel_per_line [x]),
            .frame_rate     (w_rx_frame_rate     [x]) // Measured in Hz
        );
    end
endgenerate 

    // --- 4. DUT Instance ---
    csi2_aggregator_top dut (
        .sys_clk      (sys_clk),
        .rst_n        (rst_n),
        .rx_clks      (rx_clks),
        .rx_rst_n     (rx_rst_n),
        .rx_vsync     (rx_vsync),
        .rx_hsync     (rx_hsync),
        .rx_data      (rx_data),
        .rx_valid     (rx_valid),
		.tx_enable	  (1'b1),
        .tx_data      (tx_data),
        .tx_valid     (tx_valid),
        .tx_vsync     (tx_vsync),
        .tx_hsync     (tx_hsync),
        .tx_data_type (tx_data_type),
        .tx_vc_id     (tx_vc_id)
    );
	
generate 
	for(x=0; x< NUM_CHANNEL; x=x+1)
	begin:csi_tx_vc_monitor

    
        
        video_monitor inst_csi_rx_monitor(
            .clk(sys_clk),        // Pixel clock
            .reset_n(rst_n),
            .vsync(tx_vsync[x]),
            .hsync(tx_hsync[x]),
            .de(tx_valid & tx_vsync[x] & tx_hsync[x]),         // Data Enable / Valid
            .ref_clk_hz(32'd200_000_000), // Frequency of the pixel clock (for rate calc)
            
            .hsync_per_frame(w_tx_hsync_per_frame[x]),
            .pixel_per_line (w_tx_pixel_per_line [x]),
            .frame_rate     (w_tx_frame_rate     [x]) // Measured in Hz
        );
    end
endgenerate 	
	
	
	task automatic call_hblank(int ch_idx, int HSP, int HBP, int WORDS_PER_LINE, int HFP);
		
		repeat(HSP) @(posedge rx_clks[ch_idx]);
        // Active Pixels
        rx_hsync[ch_idx] = 1; 
		repeat(HBP) @(posedge rx_clks[ch_idx]);
		repeat(WORDS_PER_LINE) @(posedge rx_clks[ch_idx]);
		repeat(HFP) @(posedge rx_clks[ch_idx]);
        rx_hsync[ch_idx] = 0;		
    endtask

    // --- 5. Updated Camera Simulation Task ---
    task automatic simulate_camera(int ch_idx);
        csi2_cfg_t cfg = SENSOR_ARRAY[ch_idx];
		csi2_sim_t SIM_CAM = SIM_SENSOR_ARRAY[ch_idx];
		
        // Calculate words based on pixels per clock
        int words_per_line = (SIM_CAM.H_RES + cfg.PIXEL_PER_CLK - 1) / cfg.PIXEL_PER_CLK;
        int total_h_clks   =  SIM_CAM.HSP + SIM_CAM.HBP + words_per_line + SIM_CAM.HFP;

        $display("[TIME %0t] [CH %0d] Sensor Active: %0d x %0d", $time, ch_idx , SIM_CAM.H_RES, SIM_CAM.V_RES );

		rx_start[ch_idx] = 1;
        // Reset channel
        rx_rst_n[ch_idx] = 0;
        rx_vsync[ch_idx] = 0;
        rx_hsync[ch_idx] = 0;
        rx_valid[ch_idx] = 0;
        repeat(50) @(posedge rx_clks[ch_idx]);
        rx_rst_n[ch_idx] = 1;

	//	repeat(SIM_CAM.INIT_DLY) @(posedge rx_clks[ch_idx]);

		repeat(SIM_CAM.NUM_FRAME) begin
       // forever begin
            // Vertical Sync Period
            //repeat(SIM_CAM.VSP) repeat(total_h_clks) @(posedge rx_clks[ch_idx]);
			repeat(SIM_CAM.VSP) call_hblank(ch_idx,SIM_CAM.HSP,SIM_CAM.HBP,words_per_line, SIM_CAM.HFP);
            rx_vsync[ch_idx] = 1; // Start of Frame (includes VBP + Active + VFP)
            // Vertical Back Porch
            // repeat(SIM_CAM.VBP) repeat(total_h_clks) @(posedge rx_clks[ch_idx]);
			repeat(SIM_CAM.VSP) call_hblank(ch_idx,SIM_CAM.HSP,SIM_CAM.HBP,words_per_line, SIM_CAM.HFP);

            // Active Video Lines
            for (int v = 0; v < SIM_CAM.V_RES; v++) begin
                // Horizontal Sync + Back Porch
                rx_hsync[ch_idx] = 0;
                repeat(SIM_CAM.HSP) @(posedge rx_clks[ch_idx]);
                // Active Line Data
                rx_hsync[ch_idx] = 1;
				repeat(SIM_CAM.HBP) @(posedge rx_clks[ch_idx]);
                
                for (int h = 0; h < words_per_line; h++) begin
                    @(posedge rx_clks[ch_idx]);
                    rx_valid[ch_idx] = 1;
                    rx_data[ch_idx]  = {8'(ch_idx), 8'(v), 16'(h), 32'h55AA_55AA};
                end
                
                // End of Active Data
                @(posedge rx_clks[ch_idx]);
                rx_valid[ch_idx] = 0;

                // Horizontal Front Porch
                repeat(SIM_CAM.HFP) @(posedge rx_clks[ch_idx]);
                rx_hsync[ch_idx] = 0;
            end
            
            // Vertical Front Porch
            //repeat(SIM_CAM.VFP) repeat(total_h_clks) @(posedge rx_clks[ch_idx]);
            repeat(SIM_CAM.VFP) call_hblank(ch_idx,SIM_CAM.HSP,SIM_CAM.HBP,words_per_line, SIM_CAM.HFP);
            
            rx_vsync[ch_idx] = 0; // End of Frame
            
            // Short Idle between frames
            repeat(100) @(posedge rx_clks[ch_idx]);
        end
		 $display("[TIME %0t] [CH %0d] Simulated %0d Frame Successfully", $time, SIM_CAM.NUM_FRAME, ch_idx);
		rx_start[ch_idx] = 0;	
    endtask

    // --- 6. Main Stimulus ---
    initial begin
        $display("--- Starting Multi-Channel 1080p Aggregator Test ---");
        rst_n = 0;
        #500 rst_n = 1;

        for (int i = 0; i < NUM_CHANNEL; i++) begin
            fork
                automatic int idx = i; 			
                simulate_camera(idx);
            join_none
        end

        // Run for enough time to see line aggregation
        // Note: 1080p takes a lot of simulation cycles. 
        // For quick tests, reduce V_RES to 10 in the parameters above.
        #2000000; 
		wait (rx_start =='d0);
		#500000; 
		$display("--- Simulation Finished ---");
        $stop;
    end

    // --- 7. Console Monitor ---
    always @(posedge sys_clk) begin
        if (tx_valid) begin
            // Verify sync steering
            if (tx_hsync[tx_vc_id] !== 1'b1) begin
                $error("[TIME %0t] SYNC ERROR: tx_hsync[%0d] inactive during TX", $time, tx_vc_id);
            end
        end
    end
	
	 always @(posedge sys_clk) begin

		for (int i = 0; i < NUM_CHANNEL; i++) begin

			
			if(tx_hsync[i]==0)
				tx_hsync_count[i] <= 'd0;
			else 		
				tx_hsync_count[i] <= tx_hsync_count[i] +1'b1;

		end 
		
		if(tx_valid==0)
			tx_valid_count <= 'd0;
		else 		
			tx_valid_count <= tx_valid_count +1'b1;
    end
	

endmodule