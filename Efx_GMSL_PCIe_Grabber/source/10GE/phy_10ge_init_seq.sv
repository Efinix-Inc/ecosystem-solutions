module phy_10ge_init_seq # (
	parameter DLY_IN_USER			= 'd3,
	parameter DLY_PLLCLK_EN_ACK	= 'd15,
	parameter DLY_PSTATE_IDLE		= 'd15,
	parameter DLY_INIT_DONE			= 'd13000,
	parameter KR_TRAINING			= 1
) ( 
	input  logic			clk,
	input  logic			in_user, // from CB to Core

	input  logic			qX_pma_cmn_ready, // from PMA
	input  logic			qX_pma_xcvr_pllclk_en_ack_p_N, // from PMA
	input  logic [3:0]	qX_pma_xcvr_power_state_ack_p_N, // from PMA
	input  logic			qX_pma_rx_signal_detect_ln_N, // from PMA

	output logic			qX_chN_10g_user_apb_reset_n, // SW will tie this off to 1.
	output logic			qX_phy_p0N_reset_n, // Set to 1 upon enter user mode
	output logic			qX_pma_xcvr_pllclk_en_p_N,
	output logic [3:0]	qX_pma_xcvr_power_state_req_p_N,
	output logic			qX_pma_tx_elec_idle_ln_N,
	output logic			qX_eth_eee_alert_en_ln_N,
	output logic			qX_kr_restart_training_ln_N,
	output logic			qX_kr_training_enable_ln_N,
	output logic			init_done // pull out to GPIO/APB PRESETn to start signal_ok & tx_dp_en
);

// State Machine
typedef enum logic [2:0] {
	IDLE				= 'b000,
	PLLCLK_EN		= 'b001,
	REQ_PSTATE_A2	= 'b011,
	PSTATE_IDLE		= 'b010,
	REQ_PSTATE_A0	= 'b110,
	PRE_INIT_DONE	= 'b111,
	PHY_DONE_INIT	= 'b101
} state;
state curr_state, next_state;

//Counters
logic [2:0]		cnt_in_user;
logic [3:0]		cnt_pllclk_en_ack;
logic [3:0]		cnt_pstate_idle;
logic [13:0]	cnt_init_done;

always @(posedge clk or negedge in_user) begin
	if(~in_user) begin
		cnt_in_user				<= 'd0;
		cnt_pllclk_en_ack		<= 'd0;
		cnt_pstate_idle		<= 'd0;
		cnt_init_done			<= 'd0;
	end
	else begin
		if(cnt_in_user <= DLY_IN_USER)
			cnt_in_user			<= cnt_in_user + 1'd1;
		else
			cnt_in_user			<= cnt_in_user;

		//Assertion of qX_pma_cmn_ready preceeds qX_pma_xcvr_pllclk_en_ack_p_N
		if((qX_pma_xcvr_pllclk_en_ack_p_N == 1'b1) && (cnt_pllclk_en_ack <= DLY_PLLCLK_EN_ACK))
			cnt_pllclk_en_ack	<= cnt_pllclk_en_ack + 1'd1;
		else
			cnt_pllclk_en_ack	<= cnt_pllclk_en_ack;

		if((qX_pma_xcvr_power_state_ack_p_N == 4'b0100) && (cnt_pstate_idle <= DLY_PSTATE_IDLE))
			cnt_pstate_idle	<= cnt_pstate_idle + 1'd1;
		else
			cnt_pstate_idle	<= cnt_pstate_idle;

		if((qX_pma_rx_signal_detect_ln_N == 1'b1) && (cnt_init_done <= DLY_INIT_DONE))
			cnt_init_done		<= cnt_init_done + 1'd1;
		else
			cnt_init_done		<= cnt_init_done;
	end
end

//State Machine
always @(posedge clk or negedge in_user) begin
	if(~in_user)
		curr_state <= IDLE;
	else    
		curr_state <= next_state;
end

always @(*) begin
	case(curr_state)
		IDLE					: begin
			if(in_user && (cnt_in_user == DLY_IN_USER))
				next_state = PLLCLK_EN;
			else
				next_state = IDLE;
		end
		PLLCLK_EN			: begin
			if(qX_pma_cmn_ready && qX_pma_xcvr_pllclk_en_ack_p_N && (cnt_pllclk_en_ack == DLY_PLLCLK_EN_ACK))
				next_state = REQ_PSTATE_A2;
			else
				next_state = PLLCLK_EN;
		end
		REQ_PSTATE_A2	: begin
			if(qX_pma_xcvr_power_state_ack_p_N == 4'b0100)
				next_state = PSTATE_IDLE;
			else
				next_state = REQ_PSTATE_A2;
		end
		PSTATE_IDLE		: begin
			if((qX_pma_xcvr_power_state_ack_p_N == 4'b0100) && (cnt_pstate_idle == DLY_PSTATE_IDLE))
				next_state = REQ_PSTATE_A0;
			else
				next_state = PSTATE_IDLE;
		end
		REQ_PSTATE_A0	: begin
			if((qX_pma_xcvr_power_state_ack_p_N == 4'b0001) && qX_pma_rx_signal_detect_ln_N)
				next_state = PRE_INIT_DONE;
			else
				next_state = REQ_PSTATE_A0;
		end
		PRE_INIT_DONE		: begin
			//LLTAN_RM:if(qX_pma_rx_signal_detect_ln_N && (cnt_init_done == DLY_INIT_DONE))
			if(cnt_init_done == DLY_INIT_DONE)
				next_state = PHY_DONE_INIT;
			else
				next_state = PRE_INIT_DONE;
		end
		PHY_DONE_INIT		: begin
			next_state = PHY_DONE_INIT;
		end
		default				: begin
			next_state = IDLE;
		end
	endcase
end

//Output Signals
assign qX_chN_10g_user_apb_reset_n	= 1'b1;
assign qX_phy_p0N_reset_n				= 1'b1;
assign qX_pma_tx_elec_idle_ln_N		= 1'b0;
assign qX_eth_eee_alert_en_ln_N		= 1'b0;
assign qX_kr_restart_training_ln_N	= 1'b0;

always @(posedge clk or negedge in_user) begin
	if(~in_user) begin
		qX_kr_training_enable_ln_N			<= 1'b0;
		qX_pma_xcvr_pllclk_en_p_N			<= 1'b0;
		init_done								<= 1'b0;
		qX_pma_xcvr_power_state_req_p_N	<= 4'b0000;
	end
	else begin
		qX_kr_training_enable_ln_N			<= (KR_TRAINING == 1) ? 1'b1 : 1'b0;
		qX_pma_xcvr_pllclk_en_p_N			<= (curr_state == PLLCLK_EN) ? 1'b1 : qX_pma_xcvr_pllclk_en_p_N;
		init_done								<= (curr_state == PHY_DONE_INIT) ? 1'b1 : init_done;

//	qX_pma_xcvr_power_state_req_p_N	<= ((curr_state == REQ_PSTATE_A0) || (curr_state == PRE_INIT_DONE) || (curr_state == PRE_INIT_DONE)) ? 4'b0001 : ((curr_state == REQ_PSTATE_A2) ? 4'b0100 : 4'b0000);
		case(curr_state)
			REQ_PSTATE_A2	: qX_pma_xcvr_power_state_req_p_N	<= 4'b0100;
			REQ_PSTATE_A0	: qX_pma_xcvr_power_state_req_p_N	<= 4'b0001;
			PRE_INIT_DONE	: qX_pma_xcvr_power_state_req_p_N	<= 4'b0001;
			PHY_DONE_INIT	: qX_pma_xcvr_power_state_req_p_N	<= 4'b0001;
			default			: qX_pma_xcvr_power_state_req_p_N	<= 4'b0000;
		endcase
	end
end

endmodule
