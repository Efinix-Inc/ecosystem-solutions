`timescale 1 ns / 1 ns
module rx_axi4_st#(
    parameter                       RXFIFO_EN = 0,
    parameter                       RXFIFO_DTH = 2048,
    parameter                       AXIS_DW = 64
)
(
//Globle Signals
input                           rx_clk,
input                           rx_clk_en,
input                           rx_rstn,
//Receive AXI4-Stream Interface
input                           rx_axis_clk,
output  reg     [AXIS_DW-1:0]   rx_axis_mac_tdata,
output  reg                     rx_axis_mac_tvalid,
output  reg                     rx_axis_mac_tlast,
output  reg     [AXIS_DW/8-1:0] rx_axis_mac_tkeep,
output  reg                     rx_axis_mac_tuser,
input                           rx_axis_mac_tready,
//Rx Fifo Interface
input           [63:0]          ff_rx_data,
input           [7:0]           ff_rx_strb,
input                           ff_rx_en,
input                           ff_rx_err,
input                           ff_rx_eop,
output  wire                    ff_rx_full
//Status and  Error Signals
);
// Parameter Define 
localparam FIFO_DTH = (RXFIFO_EN) ? RXFIFO_DTH : 16;
localparam DATA_WTH = (AXIS_DW/8) +AXIS_DW+4;
localparam RATIO    = AXIS_DW == 64 ? 4 : 3;
// Register Define 
reg                             crc_fwd_dl1;
reg                             crc_fwd_en;
reg     [8:0]                   fifo_en_sr;
reg     [79:0]                  fifo_data_sr;
reg     [AXIS_DW-1:0]           fifo_tdata;
reg     [AXIS_DW-1:0]           fifo_tdata_ord;
reg                             fifo_tvalid;
reg                             fifo_tlast;
reg                             fifo_tuser;

// Wire Define
wire    [DATA_WTH-1:0]          u1_data;
wire                            u1_wrreq;
wire                            u1_rdreq;
wire    [DATA_WTH-1:0]          u1_q;
wire                            u1_full;
wire                            u1_empty;
/*----------------------------------------------------------------------------------*\
                                 The main code
\*----------------------------------------------------------------------------------*/
//Encryption begin
/*----------------------- FIFO 1 Region ----------------------------*/
efx_fifo_wrapper #(
    .FAMILY                             ("TITANIUM"                         ),
    .SYNC_CLK                           (0                                  ),
    .DEPTH                              (FIFO_DTH                           ),
    .DATA_WIDTH                         (DATA_WTH                           ),
    .MODE                               ("FWFT"                             ),
    .OUTPUT_REG                         (0                                  ),
    .PIPELINE_REG                       (1                                  ),
    .OPTIONAL_FLAGS                     (1                                  ),
    .PROGRAMMABLE_FULL                  ("NONE"                             ),
    .PROGRAMMABLE_EMPTY                 ("NONE"                             ),
    .ASYM_WIDTH_RATIO                   (RATIO                              ),
    .RAM_STYLE                          ("block_ram"                        )
)
u1_rxfifo
(
    .almost_full_o                      (                                   ),
    .full_o                             (u1_full                            ),
    .prog_full_o                        (                                   ),
    .overflow_o                         (                                   ),
    .wr_ack_o                           (                                   ),
    .empty_o                            (u1_empty                           ),
    .almost_empty_o                     (                                   ),
    .underflow_o                        (                                   ),
    .rd_valid_o                         (                                   ),
    .rdata                              (u1_q                               ),
    .wr_clk_i                           (rx_clk                             ),
    .rd_clk_i                           (rx_axis_clk                        ),
    .wr_en_i                            (u1_wrreq                           ),
    .rd_en_i                            (u1_rdreq                           ),
    .a_rst_i                            (!rx_rstn                           ),
    .wdata                              (u1_data                            ),
    .wr_datacount_o                     (                                   ),
    .rd_datacount_o                     (                                   )
);

assign u1_wrreq = ff_rx_en ;

generate begin
if(AXIS_DW == 32) begin
    assign u1_data = {ff_rx_err,ff_rx_eop,ff_rx_strb[7:4],ff_rx_data[63:32],2'b00,ff_rx_strb[3:0],ff_rx_data[31:0]}; 
end else begin   // AXIS_DW == 64
    assign u1_data = {ff_rx_err,ff_rx_eop,ff_rx_strb,ff_rx_data};    
end

end endgenerate
/*----------------------- Input Region ----------------------------*/
assign u1_rdreq = (u1_empty == 1'b0) && ((rx_axis_mac_tvalid == 1'b0) || (rx_axis_mac_tready == 1'b1));
assign ff_rx_full = u1_full;
/*----------------------- Output Region ----------------------------*/
always @(posedge rx_axis_clk or negedge rx_rstn)
begin
    if(rx_rstn == 1'b0)
        rx_axis_mac_tvalid <= 1'b0;
	else if(u1_rdreq == 1'b1)
        rx_axis_mac_tvalid <= 1'b1;
    else if(rx_axis_mac_tready == 1'b1)
        rx_axis_mac_tvalid <= 1'b0;
end

always @(posedge rx_axis_clk or negedge rx_rstn)
begin
    if(rx_rstn == 1'b0)
        rx_axis_mac_tdata <= {AXIS_DW{1'b0}};
    else if(u1_rdreq == 1'b1)
        rx_axis_mac_tdata <= u1_q[0+:AXIS_DW];
	else if(rx_axis_mac_tready == 1'b1)
        rx_axis_mac_tdata <= rx_axis_mac_tdata;
end

always @(posedge rx_axis_clk or negedge rx_rstn)
begin
    if(rx_rstn == 1'b0)
        rx_axis_mac_tkeep <= {AXIS_DW/8{1'b0}};
    else if(u1_rdreq == 1'b1) 
        rx_axis_mac_tkeep <= u1_q[AXIS_DW+:AXIS_DW/8];
	else if(rx_axis_mac_tready == 1'b1)
        rx_axis_mac_tkeep <= {AXIS_DW/8{1'b0}};
end


always @(posedge rx_axis_clk or negedge rx_rstn)
begin
    if(rx_rstn == 1'b0)
        rx_axis_mac_tlast <= 1'b0;
    else if(u1_rdreq == 1'b1)
        rx_axis_mac_tlast <= u1_q[AXIS_DW+AXIS_DW/8+:1];
	else if(rx_axis_mac_tready == 1'b1)
        rx_axis_mac_tlast <= 1'b0;
end

always @(posedge rx_axis_clk or negedge rx_rstn)
begin
    if(rx_rstn == 1'b0)
        rx_axis_mac_tuser <= 1'b0;
    else if(u1_rdreq == 1'b1)
        rx_axis_mac_tuser <= u1_q[AXIS_DW+AXIS_DW/8+1+:1];
	else if(rx_axis_mac_tready == 1'b1)
        rx_axis_mac_tuser <= 1'b0;
end
//Encryption end
endmodule
