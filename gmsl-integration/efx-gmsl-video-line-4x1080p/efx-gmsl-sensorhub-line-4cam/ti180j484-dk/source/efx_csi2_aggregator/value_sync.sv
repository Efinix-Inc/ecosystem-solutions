module value_sync (
	parameter DATA_WIDTH 32
)
(
    input  logic sync_in,
    input  logic [DATA_WIDTH-1: 0] value_in,	
    input  logic clk_out, rst_out,
    output logic sync_pulse,
	output logic [DATA_WIDTH-1: 0] value_out,
);
// 2. Synchronize the Frame Count (using Vsync as the gate)
logic sync_s1, sync_s2, sync_s3;
logic sync_pulse;

	always_ff @(posedge clk_out or negedge rst_out) begin
		if (!rst_out) begin
			sync_s1    <= 0;
			sync_s2    <= 0;
			sync_s3    <= 0;
			value_out   <= 0;
		end else begin
			sync_s1 <= sync_in;
			sync_s2 <= sync_s1;
			sync_s3 <= sync_s2;
			
			// Edge detect the synchronized Vsync
			if (sync_s2 && !sync_s3) begin
				sync_pulse <= 1'b1;
				// It is now safe to sample the frame count because it's stable
				value_out <= value_in;
			end
			else 
			begin 
				sync_pulse <= 1'b0;
				
			end 
		end
	end
endmodule