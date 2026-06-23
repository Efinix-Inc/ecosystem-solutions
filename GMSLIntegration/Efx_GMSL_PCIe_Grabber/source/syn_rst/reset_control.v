module reset_control (
	external_rstn,
	clk,
	rstn	
);

parameter NUM_EXTERNAL_RESETS = 3;
parameter NUM_DOMAINS = 4;
parameter SEQUENTIAL_RELEASE = 1'b1;

input [NUM_EXTERNAL_RESETS-1:0] external_rstn;
input [NUM_DOMAINS-1:0] clk;
output [NUM_DOMAINS-1:0] rstn;

genvar i;

wire [NUM_EXTERNAL_RESETS-1:0] filtered_rstn;
generate
for (i=0; i<NUM_EXTERNAL_RESETS; i=i+1)
begin : lp0
  reset_filter rf_extern (
    .enable(1'b1),
	.rstn_raw(external_rstn[i]),
	.clk(clk[0]),
	.rstn_filtered(filtered_rstn[i]));
end
endgenerate

wire sys_rstn = &filtered_rstn;

reset_filter rf_sys (
    .enable(1'b1),
	.rstn_raw(sys_rstn),
	.clk(clk[0]),
	.rstn_filtered(rstn[0]));

generate 
for (i=1;i<NUM_DOMAINS;i=i+1)
begin : lp1
    reset_filter rf_out (
	    .enable(SEQUENTIAL_RELEASE ? rstn[i-1] : 1'b1),
	    .rstn_raw(sys_rstn),
	    .clk(clk[i]),
	    .rstn_filtered(rstn[i])
	);
end
endgenerate

endmodule
