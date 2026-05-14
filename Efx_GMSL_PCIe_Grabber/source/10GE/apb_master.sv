module apb_master # (
	parameter ROM_MIF			= "./efx_rom_mif.mem",
	parameter ROM_DEPTH		= 10,
	parameter RAM_ADDR_W		= 5, //Depth = 32, Stores up to 32 entries
	parameter PADDR_WIDTH	= 19,
	parameter PDATA_WIDTH	= 32
) (
	input  logic							apb_halt_i,
	output logic							apb_rom_end_o,
	output logic							apb_done_o, //LLTAN_NEW

	input  logic							ram_usr_wren_i, //LLTAN_EDIT
	input  logic [RAM_ADDR_W -1:0]	ram_usr_addr_i, //LLTAN_EDIT
	output logic [PDATA_WIDTH-1:0]	ram_dout_d_o,
	output logic [PADDR_WIDTH-1:0]	ram_dout_a_o,

	input  logic							usr_apb_start_i, //LLTAN_NEW
	input  logic							usr_apb_write_i, //LLTAN_NEW
	input  logic [PADDR_WIDTH-1:0]	usr_apb_addr_i, //LLTAN_NEW
	input  logic [PDATA_WIDTH-1:0]	usr_apb_pwdata_i, //LLTAN_NEW

	// APB BUS signal
	output logic							PSEL,
	output logic							PWRITE,
	output logic							PENABLE,
	output logic [PADDR_WIDTH-1:0]	PADDR,
	output logic [PDATA_WIDTH-1:0]	PWDATA,

	input  logic							PCLK, // 200Mhz
	input  logic							PRESETn,
	input  logic [PDATA_WIDTH-1:0]	PRDATA,
	input  logic							PREADY,
	input  logic							PSLVERR
);

// State Machine
typedef enum logic [3:0] {
	IDLE				= 4'b0000,
	ROM_READ			= 4'b0001,
	SETUP_PHASE		= 4'b0011,
	ACCESS_PHASE	= 4'b0010,
	APB_DONE			= 4'b0100
} state;
state curr_state, next_state;

//ROM
logic [9:0]			rom_cnt;
logic					rom_read;
logic [PADDR_WIDTH+PDATA_WIDTH:0]		rom_mif	[(ROM_DEPTH -1) : 0];

initial $readmemh (ROM_MIF, rom_mif);

//ROM Address using counter
logic 							rom_op_end, rom_op_end_r;

assign apb_rom_end_o	= rom_op_end_r;
always @(posedge PCLK or negedge PRESETn) begin
	if(~PRESETn) begin
		rom_cnt <= 'd0;
		rom_op_end		<= 'h0;
		rom_op_end_r	<= 'h0;
		apb_done_o		<= 'h0;
	end
	else begin
		rom_op_end		<= (rom_cnt == ROM_DEPTH); //LLTAN_EDIT:((curr_state == IDLE) && (rom_cnt == ROM_DEPTH));
		rom_op_end_r	<= rom_op_end;
		apb_done_o		<= rom_op_end && (curr_state == IDLE);

		if((curr_state == APB_DONE) && (rom_op_end == 1'b0)) begin
			rom_cnt <= rom_cnt + 1'd1;
		end
		else begin
			rom_cnt <= rom_cnt;
		end
	end
end

//Read from ROM
logic								apb_rwop;
logic [PADDR_WIDTH-1:0]		apb_addr;
logic [PDATA_WIDTH-1:0]		apb_data;

//LLTAN_EDIT
always @(posedge PCLK or negedge PRESETn) begin
	if(~PRESETn) begin
		apb_data <= {PDATA_WIDTH{1'b0}};
		apb_addr <= {PADDR_WIDTH{1'b0}};
		apb_rwop <= 1'b0;
	end
	else begin
		if((curr_state == ROM_READ)) begin
			if(rom_op_end_r == 1'b0) begin
				apb_rwop <= rom_mif[rom_cnt][(PDATA_WIDTH+PADDR_WIDTH)+:1];
				apb_addr <= rom_mif[rom_cnt][ PDATA_WIDTH+:PADDR_WIDTH];
				apb_data <= rom_mif[rom_cnt][ 0+:PDATA_WIDTH];
			end
			else begin
				apb_rwop <= usr_apb_write_i;
				apb_addr <= usr_apb_addr_i;
				apb_data <= usr_apb_pwdata_i;
			end
		end
		else begin
			apb_rwop <= apb_rwop;
			apb_addr <= apb_addr;
			apb_data <= apb_data;
		end
	end
end

//State Machine
logic apb_halt_r;
logic usr_start_r, usr_start_p;

always @(posedge PCLK or negedge PRESETn) begin
	if(~PRESETn) begin
		curr_state	<= IDLE;
		apb_halt_r	<= 1'b1;
		usr_start_p	<= 1'b0;
		usr_start_r	<= 1'b0;
	end
	else begin
		curr_state	<= next_state;
		apb_halt_r	<= apb_halt_i;
		usr_start_r	<= usr_apb_start_i;
		usr_start_p	<= (apb_rom_end_o) ? (usr_apb_start_i && ~usr_start_r) : 1'b0;
	end
end

always_comb begin
	case(curr_state)
		IDLE			: begin
			if(usr_start_p == 1'b1)
				next_state		= ROM_READ;
			else begin
				if((PSLVERR == 1'b1) || (apb_halt_r == 1'b1) || (rom_cnt == ROM_DEPTH))
					next_state		= IDLE;
				else
					next_state		= ROM_READ;
			end
		end
		ROM_READ		: begin
			next_state			= SETUP_PHASE;
		end
		SETUP_PHASE	: begin
			next_state			= ACCESS_PHASE;
		end
		ACCESS_PHASE: begin
		   if(PREADY && PENABLE)
				next_state		= APB_DONE;
			else
				next_state		= ACCESS_PHASE;
		end
		APB_DONE		: begin
			next_state		= IDLE;
		end
		default		: begin
			next_state			= IDLE;
		end
	endcase
end

always @(posedge PCLK or negedge PRESETn) begin
	if(~PRESETn) begin
		PSEL		<= 1'b0;
		PWRITE	<= 1'b0;
		PENABLE	<= 1'b0;
		PADDR		<= {PADDR_WIDTH{1'b0}};
		PWDATA	<= {PDATA_WIDTH{1'b0}};
	end
	else begin
		PSEL		<= ((curr_state == SETUP_PHASE) || (curr_state == ACCESS_PHASE)) ? 1'b1 : 1'b0;
		PWRITE	<= ((curr_state == SETUP_PHASE) || (curr_state == ACCESS_PHASE)) ? apb_rwop : 1'b0;
		PENABLE	<= (curr_state == ACCESS_PHASE) ? 1'b1 : 1'b0;
		PADDR		<= ((curr_state == ROM_READ) || (curr_state == SETUP_PHASE) || (curr_state == ACCESS_PHASE)) ? apb_addr : PADDR;
		PWDATA	<= ((curr_state == ROM_READ) || (curr_state == SETUP_PHASE) || (curr_state == ACCESS_PHASE)) ? apb_data : PWDATA;
	end
end

//RAM: Capturing Data and Address from APB_READ
logic								ram_write;
logic [RAM_ADDR_W -1:0]		ram_cnt;
logic [PDATA_WIDTH-1:0]		ram_din;
logic [PADDR_WIDTH-1:0]		ram_ain;

always @(posedge PCLK or negedge PRESETn) begin
	if(~PRESETn) begin
		ram_write		<= 'b0;
		ram_cnt			<= 'd0;
		ram_din			<= 'h0;
		ram_ain			<= 'h0;
	end
	else begin
		if((next_state == APB_DONE) && (apb_rwop == 0)) begin
			ram_write	<= 'd1;
			ram_din		<= PRDATA;
			ram_ain		<= PADDR;
		end
		else begin
			ram_write	<= 'd0;
			ram_din		<= ram_din;
			ram_ain		<= ram_ain;
		end

		if((curr_state == APB_DONE) && (apb_rwop == 0)) begin
			ram_cnt		<= ram_cnt + 1'd1;
		end
		else begin
			ram_cnt 		<= ram_cnt;
		end

	end
end

//Write into or Read From RAM
localparam RAM_DEPTH = 2** RAM_ADDR_W;
logic								ram_wren;
logic [RAM_ADDR_W-1 :0]		ram_addr;
logic [PDATA_WIDTH-1:0]		ram_data_d	[(RAM_DEPTH -1) : 0];
logic [PADDR_WIDTH-1:0]		ram_data_a	[(RAM_DEPTH -1) : 0];

integer j,q;
initial for(j=0; j<RAM_DEPTH; j++) ram_data_d[j] = {PDATA_WIDTH{1'b0}};
initial for(q=0; q<RAM_DEPTH; q++) ram_data_a[q] = {PADDR_WIDTH{1'b0}};

assign ram_wren	= ram_write ? 1'b1 : ram_usr_wren_i;
assign ram_addr	= ram_write ? ram_cnt	: ram_usr_addr_i;

always @(posedge PCLK) begin
	if(ram_wren) begin
		ram_data_d[ram_addr]	<=	ram_din;
		ram_data_a[ram_addr]	<=	ram_ain;
	end
	else begin
		ram_dout_d_o			<= ram_data_d[ram_addr];
		ram_dout_a_o			<= ram_data_a[ram_addr];
	end
end

endmodule
