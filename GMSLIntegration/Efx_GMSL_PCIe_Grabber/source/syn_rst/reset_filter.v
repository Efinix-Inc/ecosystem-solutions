module reset_filter (
	enable,
	rstn_raw,
	clk,
	rstn_filtered
);

parameter PULSE_HOLD = 3;  

input enable;
input rstn_raw;
input clk;
output rstn_filtered;

reg [PULSE_HOLD-1:0] rstn_reg /* synthesis preserve */;
initial rstn_reg = {PULSE_HOLD{1'b0}};

always @(posedge clk or negedge rstn_raw) begin
  if (!rstn_raw) begin
    rstn_reg <= {PULSE_HOLD{1'b0}};
  end
  else begin
	rstn_reg <= {enable,rstn_reg[PULSE_HOLD-1:1]};
  end
end

assign rstn_filtered = rstn_reg[0];

endmodule
