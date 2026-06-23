module efx_mac10gbe_exp_checker # (
	parameter CNT_ROLLOVER = 4'hF
) (
	input		logic				apb_clk,
	input		logic				mac_clk,

	input		logic				init_done,
	input		logic				block_lock,
	output	logic				pass_status,

	input		logic [63:0]	xgmii_rxd_i,
	input		logic [7:0]		xgmii_rxc_i,
	input		logic				rx_axis_tvalid_i,
	input		logic				rx_axis_tlast_i,
	input		logic				rx_axis_tuser_i,
	output	logic				rx_tuser_pass,
	output	logic				rx_fe_pkt_pass,

	input		logic				kr_restart_i,
	input		logic				kr_local_trained_i,
	input		logic				kr_training_failure_i,
	output	logic				kr_training_pass,

	input		logic [31:0]	apb_prdata,
	input		logic [23:0]	apb_paddr,
	input		logic				apb_pready,
	input		logic				apb_rom_end,

	output	logic				pcs_fault_pass,
	output	logic				auto_nego_pass,

	input		logic				phy_interrupt_i,
	output	logic				phy_interrupt_pass
);

logic	apb_init_done, mac_init_done;
logic	mac_block_lock;

efx_resetsync inst_apb_init_done	(
	.clk	(apb_clk),	.reset	(init_done),	.d_o	(apb_init_done)
);

efx_resetsync inst_mac_init_done	(
	.clk	(mac_clk),	.reset	(init_done),	.d_o	(mac_init_done)
);

efx_resetsync inst_mac_block_lock	(
	.clk	(mac_clk),	.reset	(block_lock),	.d_o	(mac_block_lock)
);


//Check for Bad Frame based on TUSER
logic			cnt_tuser_e;
logic [3:0]	cnt_tuser_r;

always @(posedge mac_clk) begin
	if(~mac_block_lock) begin
		rx_tuser_pass		<= 'h0;
		cnt_tuser_e			<= 'h0;
		cnt_tuser_r			<= 'h0;
	end
	else begin
		rx_tuser_pass		<= (cnt_tuser_e == 1'b0) && (cnt_tuser_r == 'd0);

		cnt_tuser_e			<= (cnt_tuser_r == CNT_ROLLOVER) ? 1'b1 : cnt_tuser_e;

		if(rx_axis_tvalid_i && rx_axis_tlast_i && rx_axis_tuser_i)
			cnt_tuser_r		<= cnt_tuser_r + 1'd1;
		else
			cnt_tuser_r		<= cnt_tuser_r;
	end
end

//Check for FE Packet
logic				cnt_fe_pkt_e;
logic [3:0]		cnt_fe_pkt_r;
logic [63:0]	xgmii_rxd_r;
logic [7:0]		xgmii_rxc_r;

always @(posedge mac_clk) begin
	if(~mac_block_lock) begin
		xgmii_rxd_r				<= 64'h0;
		xgmii_rxc_r				<= 8'h0;

		rx_fe_pkt_pass			<= 'h0;
		cnt_fe_pkt_e			<= 'h0;
		cnt_fe_pkt_r			<= 'h0;
	end
	else begin
		xgmii_rxd_r				<= xgmii_rxd_i;
		xgmii_rxc_r				<= xgmii_rxc_i;

		rx_fe_pkt_pass			<= (cnt_fe_pkt_e == 1'b0) && (cnt_fe_pkt_r == 'd0);
		cnt_fe_pkt_e			<= (cnt_fe_pkt_r == CNT_ROLLOVER) ? 1'b1 : cnt_fe_pkt_e;

		if(
			 ((xgmii_rxd_r[63:56] == 8'hFE) && (xgmii_rxc_r[7] == 1'b1)) ||
			 ((xgmii_rxd_r[55:48] == 8'hFE) && (xgmii_rxc_r[6] == 1'b1)) ||
			 ((xgmii_rxd_r[47:40] == 8'hFE) && (xgmii_rxc_r[5] == 1'b1)) ||
			 ((xgmii_rxd_r[39:32] == 8'hFE) && (xgmii_rxc_r[4] == 1'b1)) ||
			 ((xgmii_rxd_r[31:24] == 8'hFE) && (xgmii_rxc_r[3] == 1'b1)) ||
			 ((xgmii_rxd_r[23:16] == 8'hFE) && (xgmii_rxc_r[2] == 1'b1)) ||
			 ((xgmii_rxd_r[15:8]  == 8'hFE) && (xgmii_rxc_r[1] == 1'b1)) ||
			 ((xgmii_rxd_r[7:0]   == 8'hFE) && (xgmii_rxc_r[0] == 1'b1))
			)
			cnt_fe_pkt_r		<= cnt_fe_pkt_r + 1'd1;
		else
			cnt_fe_pkt_r		<= cnt_fe_pkt_r;
	end
end

//Check KR Training Status
logic	kr_local_trained_r;
logic	kr_restart_r, kr_training_failure_r;
logic	kr_train_fail;

efx_asyncreg #(.WIDTH	(1),	.ACTIVE_LOW	(1)) inst_mac_kr_restart (
	.clk		(mac_clk),
	.reset_n	(mac_init_done),
	.d_i		(kr_restart_i),
	.d_o		(kr_restart_r)
);

efx_asyncreg #(.WIDTH	(1),	.ACTIVE_LOW	(1)) inst_mac_kr_local_trained (
	.clk		(mac_clk),
	.reset_n	(mac_init_done),
	.d_i		(kr_local_trained_i),
	.d_o		(kr_local_trained_r)
);

efx_asyncreg #(.WIDTH	(1),	.ACTIVE_LOW	(1)) inst_mac_kr_training_failure (
	.clk		(mac_clk),
	.reset_n	(mac_init_done),
	.d_i		(kr_training_failure_i),
	.d_o		(kr_training_failure_r)
);

always @(posedge mac_clk) begin
	if(~mac_init_done) begin
		kr_train_fail			<= 'h0;
		kr_training_pass		<= 'h0;
	end
	else begin
		kr_train_fail			<= kr_restart_r ? 1'b0 : (kr_training_failure_r ? 1'b1 : kr_train_fail);
		kr_training_pass		<= kr_local_trained_r && ~kr_train_fail;
	end
end

//Check PCS Related Faults
logic [31:0]	pcs_status;
logic [31:0]	an_status;

//[31] CTC Over/Under flow
//[29] Hi BER
//[28] TX_Fault
//[27] RX_Fault
always @(posedge apb_clk) begin
	if(~apb_init_done) begin
		pcs_status				<= 'h0;
		an_status				<= 'h0;
		pcs_fault_pass			<= 'h0;
		auto_nego_pass			<= 'h0;
	end
	else begin
		pcs_status				<= ((apb_paddr == 24'hC00208) && apb_pready) ? apb_prdata : pcs_status;
		an_status				<= ((apb_paddr == 24'hC00278) && apb_pready) ? apb_prdata : an_status;

	`ifndef AN_ENABLE
		pcs_fault_pass			<= apb_rom_end ? (pcs_status == 32'h0000_0001) : pcs_fault_pass;
	`endif
	`ifdef AN_ENABLE
		pcs_fault_pass			<= apb_rom_end ? (pcs_status == 32'h0000_0003) : pcs_fault_pass;
	`endif

		auto_nego_pass			<= apb_rom_end ? (an_status == 32'h0000_D601) : auto_nego_pass;
	end
end

//Check for PHY Related Fault
logic	phy_interrupt_r;

efx_asyncreg #(.WIDTH	(1),	.ACTIVE_LOW	(1)) inst_mac_phy_interrupt (
	.clk		(mac_clk),
	.reset_n	(mac_block_lock),
	.d_i		(phy_interrupt_i),
	.d_o		(phy_interrupt_r)
);

always @(posedge mac_clk) begin
	if(~mac_block_lock) begin
		phy_interrupt_pass	<= (phy_interrupt_r == 1'b0);
	end
	else begin
		phy_interrupt_pass	<= (phy_interrupt_r != 1'b0) ? 1'b0 : phy_interrupt_pass;
	end
end

`ifndef LOOPBACK
    `ifdef KR_ENABLE
	    `ifdef AN_ENABLE
        	assign pass_status = rx_tuser_pass & rx_fe_pkt_pass & kr_training_pass & pcs_fault_pass & auto_nego_pass & phy_interrupt_pass;
	    `else
        	assign pass_status = rx_tuser_pass & rx_fe_pkt_pass & kr_training_pass & pcs_fault_pass & phy_interrupt_pass;
	    `endif
    `endif
    
    `ifndef KR_ENABLE
	    `ifdef AN_ENABLE
        	assign pass_status = rx_tuser_pass & rx_fe_pkt_pass & pcs_fault_pass & auto_nego_pass & phy_interrupt_pass;
	    `else
        	assign pass_status = rx_tuser_pass & rx_fe_pkt_pass & pcs_fault_pass & phy_interrupt_pass;
	    `endif
    `endif
`endif

`ifdef LOOPBACK
    assign pass_status = rx_tuser_pass;
`endif
endmodule
