module efx_mac10gbe_exp_pat_gen (
	input  logic			clk,
	input  logic			rst_n,
	input  logic			pcs_status,

	input  logic			tx_axis_mac_tready,
	output logic			tx_axis_mac_tvalid,
	output logic			tx_axis_mac_tlast,
	output logic [63:0]	tx_axis_mac_tdata,
	output logic [7:0]	tx_axis_mac_tkeep,
	output logic			tx_axis_mac_tuser
);

`ifndef JUMBO
    localparam ROLL_OVER = 8'd150;
    localparam CNT_WIDTH = 'd8;
`endif

`ifdef JUMBO
    localparam ROLL_OVER = 12'd2350;
    localparam CNT_WIDTH = 'd12;
`endif

logic [CNT_WIDTH-1:0]	pat_gen_cnt;

//14Byte Header + 986 Byte Payload
//14Byte Header + 16366 Byte Payload (Jumbo)
always @(posedge clk or negedge rst_n) begin
	if(~rst_n) begin
		pat_gen_cnt						<= {CNT_WIDTH{1'b0}};
		tx_axis_mac_tvalid			<= 1'b0;
		tx_axis_mac_tlast 			<= 1'b0;
		tx_axis_mac_tdata				<= 64'h0;
		tx_axis_mac_tkeep				<= 8'h0;
		tx_axis_mac_tuser				<= 1'b0;
	end
	else begin

		if(tx_axis_mac_tready == 1'b1) begin
			if(pcs_status) begin
				pat_gen_cnt				<= (pat_gen_cnt <= ROLL_OVER) ? (pat_gen_cnt + 1'b1) : {CNT_WIDTH{1'b0}};
			end
			else begin
				pat_gen_cnt				<= 'd0;
			end
		end
		else begin
			pat_gen_cnt					<= pat_gen_cnt;
		end

		if(pat_gen_cnt == 'd1) begin
			tx_axis_mac_tvalid		<= 1'b1;
			tx_axis_mac_tlast			<= 1'b0;
			tx_axis_mac_tdata			<= 64'h3a_ae_80_00_20_7a_3F_3E;
			tx_axis_mac_tkeep			<= 8'hFF;
			tx_axis_mac_tuser			<= 1'b0;
		end
		else if(pat_gen_cnt == 'd2) begin
			tx_axis_mac_tvalid		<= 1'b1;
			tx_axis_mac_tlast			<= 1'b0;
			tx_axis_mac_tdata			<= {pat_gen_cnt[0], pat_gen_cnt[6:0], pat_gen_cnt[0], pat_gen_cnt[6:0], 48'h00_08_80_00_20_20};
			tx_axis_mac_tkeep			<= 8'hFF;
			tx_axis_mac_tuser			<= 1'b0;
		end
		else if(pat_gen_cnt >= 'd3 && pat_gen_cnt <= 'd124) begin
			tx_axis_mac_tvalid		<= 1'b1;
			tx_axis_mac_tlast			<= 1'b0;
			tx_axis_mac_tdata			<= {8{pat_gen_cnt[0], pat_gen_cnt[6:0]}};
			tx_axis_mac_tkeep			<= 8'hFF;
			tx_axis_mac_tuser			<= 1'b0;
		end
		else if(pat_gen_cnt == 'd125) begin
			tx_axis_mac_tvalid		<= 1'b1;
			tx_axis_mac_tlast			<= 1'b1;
			tx_axis_mac_tdata			<= {8{pat_gen_cnt[0], pat_gen_cnt[6:0]}};
			tx_axis_mac_tkeep			<= 8'hFF;
			tx_axis_mac_tuser			<= 1'b0;
		end
		else if(pat_gen_cnt == 'd200) begin //Jumbo
			tx_axis_mac_tvalid		<= 1'b1;
			tx_axis_mac_tlast			<= 1'b0;
			tx_axis_mac_tdata			<= 64'h80_00_20_7a_3f_3e_80_00;
			tx_axis_mac_tkeep			<= 8'hFF;
			tx_axis_mac_tuser			<= 1'b0;
		end
		else if(pat_gen_cnt == 'd201) begin
			tx_axis_mac_tvalid		<= 1'b1;
			tx_axis_mac_tlast			<= 1'b0;
			tx_axis_mac_tdata			<= {48'h20_20_3a_ae_08_00, pat_gen_cnt[7:0], pat_gen_cnt[7:0]};
			tx_axis_mac_tkeep			<= 8'hFF;
			tx_axis_mac_tuser			<= 1'b0;
		end
		else if(pat_gen_cnt >= 'd202 && pat_gen_cnt <= 12'd2245) begin
			tx_axis_mac_tvalid		<= 1'b1;
			tx_axis_mac_tlast			<= 1'b0;
			tx_axis_mac_tdata			<= {8{pat_gen_cnt[7:0]}};
			tx_axis_mac_tkeep			<= 8'hFF;
			tx_axis_mac_tuser			<= 1'b0;
		end
		else if(pat_gen_cnt == 'd2246) begin
			tx_axis_mac_tvalid		<= 1'b1;
			tx_axis_mac_tlast			<= 1'b1;
			tx_axis_mac_tdata			<= {8{pat_gen_cnt[7:0]}};
			tx_axis_mac_tkeep			<= 8'hFF;
			tx_axis_mac_tuser			<= 1'b0;
		end
		else begin
			tx_axis_mac_tvalid		<= 1'b0;
			tx_axis_mac_tlast			<= 1'b0;
			tx_axis_mac_tdata			<= 64'h0;
			tx_axis_mac_tkeep			<= 8'h0;
			tx_axis_mac_tuser			<= 1'b0;
		end

	end
end

endmodule
