`timescale 1 ns / 1 ns
module tx_axi4_st#(
    parameter                       TXFIFO_EN = 0,
    parameter                       TXFIFO_DTH = 2048,
    parameter                       AXIS_DW = 64
)
(
//Globle Signals
input                           tx_clk,
input                           tx_clk_en,
input                           tx_rstn,
//Configuration Signals
input                           tx_addr_ins,
input           [47:0]          mac_addr,
input                           tx_dst_addr_ins,
input           [47:0]          dst_mac_addr,
//Transmit AXI4-Stream Interface
input                           tx_axis_clk,
input           [AXIS_DW-1:0]   tx_axis_mac_tdata,
input                           tx_axis_mac_tvalid,
input                           tx_axis_mac_tlast,
input           [AXIS_DW/8-1:0] tx_axis_mac_tkeep,
input                           tx_axis_mac_tuser,
output  reg                     tx_axis_mac_tready,
//Tx Fifo Interface
output  reg     [63:0]          ff_tx_data,
output  reg     [7:0]           ff_tx_strb,
output  reg                     ff_tx_sop,
output  reg                     ff_tx_eop,
output  reg                     ff_tx_vld,
output  reg                     ff_tx_err,
input                           ff_tx_rdy,
//Status and  Error Signals
output  reg                     txfifo_overflow_err
);


// Parameter Define 
localparam FIFO_DTH = (TXFIFO_EN) ? TXFIFO_DTH : 16;
localparam DATA_WIDTH =  64 + (64/8) + 2;
localparam ASYM_WIDTH_RATIO =  4  ;
// Register Define 
reg     [3:0]                   tx_addr_cnt;
reg                             tx_axis_mac_en;
reg     [15:0]                  tx_pkt_cnt;
reg                             pkt_rev_turn;
reg                             pkt_rev_turn_d1;
reg                             pkt_rev_turn_d2;
reg                             pkt_rev_turn_d3;
reg                             pkt_rev;
reg     [2:0]                   pkt_trans_dlycnt;
reg                             pkt_trans;
reg                             txfifo_overflow;
reg                             txfifo_overflow_d1;
reg                             txfifo_overflow_d2;
reg                             txfifo_overflow_d3;

reg     [2:0]                   u1_full_dlycnt;
reg                             txfifo_overflow_rst;
reg                             u1_rdreq_r;
reg                             axis_wreq_en;
reg     [AXIS_DW-1:0]           axis_tdata_d1;
reg     [AXIS_DW/8-1:0]         axis_tkeep_d1;
reg                             axis_tlast_d1;
reg                             axis_tuser_d1;
reg                             tx_tlast;
reg                             tx_tuser;
reg     [63:0]                  tx_tdata;
reg     [7:0]                   tx_tstrb;
// Wire Define
wire    [DATA_WIDTH-1:0]        u1_data;
wire                            u1_wrreq;
wire                            u1_rst;
wire                            u1_rdreq;
wire    [DATA_WIDTH-1:0]        u1_q;
wire                            u1_empty;
wire                            u1_almfull;
wire                            u1_full;
wire    [95:0]                  tx_axi_mac_addr;
wire    [95:0]                  axi_mac_addr;

/*----------------------------------------------------------------------------------*\
                                 The main code
\*----------------------------------------------------------------------------------*/
//Encryption begin

/*----------------------- FIFO 1 Region ----------------------------*/

generate
if(TXFIFO_EN == 0)
begin
efx_fifo_wrapper #(
    .FAMILY                             ("TITANIUM"                         ),
    .SYNC_CLK                           (0                                  ),
    .DEPTH                              (FIFO_DTH                           ),
    .DATA_WIDTH                         (DATA_WIDTH                         ),
    .MODE                               ("FWFT"                             ),
    .OUTPUT_REG                         (0                                  ),
    .PIPELINE_REG                       (1                                  ),
    .OPTIONAL_FLAGS                     (1                                  ),
    .PROGRAMMABLE_FULL                  ("NONE"                             ),
    .PROGRAMMABLE_EMPTY                 ("NONE"                             ),
    .ASYM_WIDTH_RATIO                   (ASYM_WIDTH_RATIO                   ),
    .RAM_STYLE                          ("block_ram"                        )
)
u1_txfifo
(
    .almost_full_o                      (u1_almfull                         ),
    .full_o                             (u1_full                            ),
    .prog_full_o                        (                                   ),
    .overflow_o                         (                                   ),
    .wr_ack_o                           (                                   ),
    .empty_o                            (u1_empty                           ),
    .almost_empty_o                     (                                   ),
    .underflow_o                        (                                   ),
    .rd_valid_o                         (                                   ),
    .rdata                              (u1_q                               ),
    .wr_clk_i                           (tx_axis_clk                        ),
    .rd_clk_i                           (tx_clk                             ),
    .wr_en_i                            (u1_wrreq                           ),
    .rd_en_i                            (u1_rdreq                           ),
    .a_rst_i                            (u1_rst                             ),
    .wdata                              (u1_data                            ),
    .wr_datacount_o                     (                                   ),
    .rd_datacount_o                     (                                   )
);

end
else
begin
/*
efx_fifo_d16k #(
    .DEPTH                      (FIFO_DTH                   ),
    .DATA_WIDTH                 (DATA_WIDTH                 ),
    .ASYM_WIDTH_RATIO           (ASYM_WIDTH_RATIO           )

)
u1
(
//Output
    .almost_full_o              (u1_almfull                 ),
    .full_o                     (u1_full                    ),
    .empty_o                    (u1_empty                   ),
    .rd_valid_o                 (                           ),
    .rdata                      (u1_q                       ),
//Input
    .wr_clk_i                   (tx_axis_clk                ),
    .rd_clk_i                   (tx_clk                     ),
    .wr_en_i                    (u1_wrreq                   ),
    .rd_en_i                    (u1_rdreq                   ),
    .a_rst_i                    (u1_rst                     ),
    .wdata                      (u1_data                    )
);
*/

efx_fifo_wrapper #(
    .FAMILY                             ("TITANIUM"                         ),
    .SYNC_CLK                           (0                                  ),
    .DEPTH                              (FIFO_DTH                           ),
    .DATA_WIDTH                         (DATA_WIDTH                         ),
    .MODE                               ("FWFT"                             ),
    .OUTPUT_REG                         (0                                  ),
    .PIPELINE_REG                       (1                                  ),
    .OPTIONAL_FLAGS                     (1                                  ),
    .PROGRAMMABLE_FULL                  ("NONE"                             ),
    .PROGRAMMABLE_EMPTY                 ("NONE"                             ),
    .ASYM_WIDTH_RATIO                   (ASYM_WIDTH_RATIO                   ),
    .RAM_STYLE                          ("block_ram"                        )
)
u1_txfifo
(
    .almost_full_o                      (u1_almfull                         ),
    .full_o                             (u1_full                            ),
    .prog_full_o                        (                                   ),
    .overflow_o                         (                                   ),
    .wr_ack_o                           (                                   ),
    .empty_o                            (u1_empty                           ),
    .almost_empty_o                     (                                   ),
    .underflow_o                        (                                   ),
    .rd_valid_o                         (                                   ),
    .rdata                              (u1_q                               ),
    .wr_clk_i                           (tx_axis_clk                        ),
    .rd_clk_i                           (tx_clk                             ),
    .wr_en_i                            (u1_wrreq                           ),
    .rd_en_i                            (u1_rdreq                           ),
    .a_rst_i                            (u1_rst                             ),
    .wdata                              (u1_data                            ),
    .wr_datacount_o                     (                                   ),
    .rd_datacount_o                     (                                   )
);


end
endgenerate


assign u1_data ={tx_tuser,tx_tlast,tx_tstrb,tx_tdata};

generate
if(TXFIFO_EN == 0)
begin

    assign u1_rst = (tx_rstn == 1'b0);
    assign u1_wrreq = (tx_axis_mac_tvalid == 1'b1) && (tx_axis_mac_tready == 1'b1) && (axis_wreq_en == 1);
    assign u1_rdreq = (u1_empty == 1'b0) && (tx_clk_en == 1'b1) && ((ff_tx_vld == 1'b0) || (ff_tx_rdy == 1'b1));

end
else
begin
    reg tx_pkt_dly;
    assign u1_rst = (tx_rstn == 1'b0) || (txfifo_overflow_rst == 1'b1);
    assign u1_wrreq = (tx_axis_mac_tvalid == 1'b1) && (tx_axis_mac_tready == 1'b1) && (axis_wreq_en == 1) && (txfifo_overflow_rst == 1'b0);
    assign u1_rdreq = (u1_empty == 1'b0) && (tx_clk_en == 1'b1) && ((ff_tx_vld == 1'b0) || (ff_tx_rdy == 1'b1)) && (tx_pkt_cnt != 16'h0) && (tx_pkt_dly == 1'b0);

    always @(posedge tx_clk or negedge tx_rstn)
    begin
        if(tx_rstn == 1'b0)
            tx_pkt_dly <= 1'b0;
        else if((u1_rdreq == 1'b1) && (u1_q[72] == 1'b1))
            tx_pkt_dly <= 1'b1;
        else if(pkt_trans == 1'b1)
            tx_pkt_dly <= 1'b0;
    end
    
    always @(posedge tx_axis_clk or negedge tx_rstn)
    begin
        if(tx_rstn == 1'b0)
            pkt_rev_turn <= 1'b0;
        else if((tx_axis_mac_tvalid == 1'b1) && (tx_axis_mac_tready == 1'b1) && (tx_axis_mac_tlast == 1'b1))
            pkt_rev_turn <= ~pkt_rev_turn;
    end

    always @(posedge tx_clk or negedge tx_rstn)
    begin
        if(tx_rstn == 1'b0)
            begin
                pkt_rev_turn_d1 <= 1'b0;
                pkt_rev_turn_d2 <= 1'b0;
                pkt_rev_turn_d3 <= 1'b0;
            end
        else
            begin
                pkt_rev_turn_d1 <= pkt_rev_turn;
                pkt_rev_turn_d2 <= pkt_rev_turn_d1;
                pkt_rev_turn_d3 <= pkt_rev_turn_d2;
            end
    end

    always @(posedge tx_clk or negedge tx_rstn)
    begin
        if(tx_rstn == 1'b0)
            pkt_rev <= 1'b0;
        else
            pkt_rev <= pkt_rev_turn_d3 ^ pkt_rev_turn_d2;
    end

    always @(posedge tx_clk or negedge tx_rstn)
    begin
        if(tx_rstn == 1'b0)
            pkt_trans_dlycnt <= 3'h0;
        else if((u1_rdreq == 1'b1) && (u1_q[72] == 1'b1))
            pkt_trans_dlycnt <= 3'h1;
        else if(pkt_trans_dlycnt != 0)
            pkt_trans_dlycnt <= pkt_trans_dlycnt + 1;            
    end

    always @(posedge tx_clk or negedge tx_rstn)
    begin
        if(tx_rstn == 1'b0)
            pkt_trans <= 1'b0;
        else if(pkt_trans_dlycnt == 3'h1)
            pkt_trans <= 1'b1;
        else
            pkt_trans <= 1'b0;
    end

    always @(posedge tx_clk or negedge tx_rstn)
    begin
        if(tx_rstn == 1'b0)
            tx_pkt_cnt <= 16'h0;
        else if((pkt_trans == 1'b1) && (pkt_rev == 1'b1) && (txfifo_overflow == 1'b0))
            tx_pkt_cnt <= tx_pkt_cnt;
        else if(pkt_trans == 1'b1)
            tx_pkt_cnt <= tx_pkt_cnt - 1'b1;
        else if((pkt_rev == 1'b1) && (txfifo_overflow == 1'b0))
            tx_pkt_cnt <= tx_pkt_cnt + 1'b1;
    end

    always @(posedge tx_clk or negedge tx_rstn)
    begin
        if(tx_rstn == 1'b0)
            u1_full_dlycnt <= 3'h0;
        else if(u1_full == 1'b0)
            u1_full_dlycnt <= 3'h0;
        else if(u1_full_dlycnt < 3'h7)
            u1_full_dlycnt <= u1_full_dlycnt + 1;            
    end
    
    always @(posedge tx_clk or negedge tx_rstn)
    begin
        if(tx_rstn == 1'b0)
            txfifo_overflow <= 1'b0;
        else if(pkt_rev == 1'b1)
            txfifo_overflow <= 1'b0;
        else if((u1_full_dlycnt == 3'h7) && (tx_pkt_cnt == 16'h0))
            txfifo_overflow <= 1'b1;
    end
    
    always @(posedge tx_clk or negedge tx_rstn)
    begin
        if(tx_rstn == 1'b0)
            txfifo_overflow_err <= 1'b0;
        else if((txfifo_overflow == 1'b1) && (pkt_rev == 1'b1))
            txfifo_overflow_err <= 1'b1;
        else if(tx_clk_en == 1'b1)
            txfifo_overflow_err <= 1'b0;
    end

    always @(posedge tx_axis_clk or negedge tx_rstn)
    begin
        if(tx_rstn == 1'b0)
            begin
                txfifo_overflow_d1 <= 1'b0;
                txfifo_overflow_d2 <= 1'b0;
                txfifo_overflow_d3 <= 1'b0;
            end
        else
            begin
                txfifo_overflow_d1 <= txfifo_overflow;
                txfifo_overflow_d2 <= txfifo_overflow_d1;
                txfifo_overflow_d3 <= txfifo_overflow_d2;
            end
    end

    always @(posedge tx_axis_clk or negedge tx_rstn)
    begin
        if(tx_rstn == 1'b0)
            txfifo_overflow_rst <= 1'b0;
        else if((tx_axis_mac_tvalid == 1'b1) && (tx_axis_mac_tready == 1'b1) && (tx_axis_mac_tlast == 1'b1))
            txfifo_overflow_rst <= 1'b0;
        else if((txfifo_overflow_d3 == 1'b0) && (txfifo_overflow_d2 == 1'b1))
            txfifo_overflow_rst <= 1'b1;            
    end
    
end
endgenerate

/*----------------------- Input Region ----------------------------*/
always @(posedge tx_axis_clk or negedge tx_rstn)
begin
    if(tx_rstn == 1'b0)
        tx_axis_mac_tready <= 1'b0;
    else if(u1_almfull == 1'b1)
        tx_axis_mac_tready <= 1'b0;
    else
        tx_axis_mac_tready <= 1'b1;
end

always @(posedge tx_axis_clk or negedge tx_rstn)
begin
    if(tx_rstn == 1'b0)
        tx_addr_cnt <= 4'h0;
    else if((tx_axis_mac_tvalid == 1'b1) && (tx_axis_mac_tready == 1'b1) && (tx_axis_mac_tlast == 1'b1))
        tx_addr_cnt <= 4'h0;
    else if((tx_axis_mac_tvalid == 1'b1) && (tx_axis_mac_tready == 1'b1) && (tx_addr_cnt < 4))
        tx_addr_cnt <= tx_addr_cnt + 1'b1;
end

assign tx_axi_mac_addr = {dst_mac_addr,mac_addr};
genvar i;
generate
    for(i=0;i<96/8;i=i+1)begin
        assign axi_mac_addr[i*8+:8] = tx_axi_mac_addr[(96/8-i-1)*8+:8];
    end    
endgenerate
/*
always @(*)
begin
    if((tx_addr_ins == 1'b1) && (tx_addr_cnt >= 4'd0) && (tx_addr_cnt < 96/AXIS_DW))
        tx_tdata = axi_mac_addr[tx_addr_cnt*AXIS_DW +: AXIS_DW];
    else
        tx_tdata = tx_axis_mac_tdata;
end
*/
generate
if(AXIS_DW == 32) begin

always @(posedge tx_axis_clk or negedge tx_rstn)
begin
    if(tx_rstn == 1'b0)
        axis_wreq_en <= 1'b0;
    else if((tx_axis_mac_tvalid == 1'b1) && (tx_axis_mac_tready == 1'b1) && (tx_axis_mac_tlast == 1'b1))
        axis_wreq_en <= 1'b0;            
    else if((tx_axis_mac_tvalid == 1'b1) && (tx_axis_mac_tready == 1'b1))
        axis_wreq_en <= ~axis_wreq_en;
end 

always @(posedge tx_axis_clk)
begin
    axis_tdata_d1 <= tx_axis_mac_tdata;
    axis_tkeep_d1 <= tx_axis_mac_tkeep;
    axis_tlast_d1 <= tx_axis_mac_tlast;
    axis_tuser_d1 <= tx_axis_mac_tuser;
end 

always @(*)
begin
    if(tx_addr_cnt == 2'd1)
    begin
        case({tx_addr_ins,tx_dst_addr_ins})
            2'b00 : tx_tdata = {tx_axis_mac_tdata,axis_tdata_d1};
            2'b01 : tx_tdata = {tx_axis_mac_tdata[63:48] ,axi_mac_addr[47:0]};
            2'b10 : tx_tdata = {axi_mac_addr[63:48] ,tx_axis_mac_tdata[15:0],axis_tdata_d1};
            2'b11 : tx_tdata = axi_mac_addr[63:0];
            default :tx_tdata = {tx_axis_mac_tdata,axis_tdata_d1};
        endcase 
    end    
    else if(tx_addr_cnt == 2'd3)
        begin
            if(tx_addr_ins == 1)
                tx_tdata = {tx_axis_mac_tdata ,axi_mac_addr[95:64]};
            else    
                tx_tdata = {tx_axis_mac_tdata,axis_tdata_d1};
        end
    else
        tx_tdata = {tx_axis_mac_tdata,axis_tdata_d1};
end 

always @(*)
begin
    tx_tlast =    tx_axis_mac_tlast | axis_tlast_d1;
    tx_tuser =    tx_axis_mac_tuser | axis_tuser_d1;
    tx_tstrb =    {tx_axis_mac_tkeep,axis_tkeep_d1};
end   
  
end else begin   // AXIS_DW == 64

always @(*)
begin
    if(tx_addr_cnt == 2'd0)
    begin
        case({tx_addr_ins,tx_dst_addr_ins})
            2'b00 : tx_tdata = tx_axis_mac_tdata;
            2'b01 : tx_tdata = {tx_axis_mac_tdata[63:48] ,axi_mac_addr[47:0]};
            2'b10 : tx_tdata = {axi_mac_addr[63:48] ,tx_axis_mac_tdata[47:0]};
            2'b11 : tx_tdata = axi_mac_addr[63:0];
            default :tx_tdata = tx_axis_mac_tdata;
        endcase 
    end    
    else if(tx_addr_cnt == 2'd1)
        begin
            if(tx_addr_ins == 1)
                tx_tdata = {tx_axis_mac_tdata[63:32] ,axi_mac_addr[95:64]};
            else    
                tx_tdata = tx_axis_mac_tdata;
        end
    else
        tx_tdata = tx_axis_mac_tdata;
end 

always @(*)
begin
    axis_wreq_en =1'b1;
    tx_tlast =    tx_axis_mac_tlast;
    tx_tstrb =    tx_axis_mac_tkeep;
    tx_tuser =    tx_axis_mac_tuser;
end 

end
endgenerate



/*----------------------- Output Region ----------------------------*/
always @(posedge tx_clk or negedge tx_rstn)
begin
    if(tx_rstn == 1'b0)
        tx_axis_mac_en <= 1'b0;
    else if((u1_rdreq == 1'b1) && (u1_q[72] == 1'b1))
        tx_axis_mac_en <= 1'b0;
    else if(u1_rdreq == 1'b1)
        tx_axis_mac_en <= 1'b1;
end

always @(posedge tx_clk or negedge tx_rstn)
begin
    if(tx_rstn == 1'b0)
        ff_tx_sop <= 1'b0;
    else if((u1_rdreq == 1'b1) && (tx_axis_mac_en == 1'b0))
        ff_tx_sop <= 1'b1;
    else if((ff_tx_rdy == 1'b1) && (tx_clk_en == 1'b1))
        ff_tx_sop <= 1'b0;
end

always @(posedge tx_clk or negedge tx_rstn)
begin
    if(tx_rstn == 1'b0)
        ff_tx_vld <= 1'b0;
    else if(u1_rdreq == 1'b1) 
        ff_tx_vld <= 1'b1;
    else if((ff_tx_rdy == 1'b1) && (tx_clk_en == 1'b1))
        ff_tx_vld <= 1'b0;
end

always @(posedge tx_clk or negedge tx_rstn)
begin
    if(tx_rstn == 1'b0)
        ff_tx_data <= 64'h0;
    else if(u1_rdreq == 1'b1)
        ff_tx_data <= u1_q[63:0];
end

always @(posedge tx_clk or negedge tx_rstn)
begin
    if(tx_rstn == 1'b0)
        ff_tx_strb <= 8'h0;
    else if(u1_rdreq == 1'b1)
        ff_tx_strb <= u1_q[71:64];
end

always @(posedge tx_clk or negedge tx_rstn)
begin
    if(tx_rstn == 1'b0)
        ff_tx_eop <= 1'b0;
    else if((u1_rdreq == 1'b1) && (u1_q[72] == 1'b1))
        ff_tx_eop <= 1'b1;
    else if((ff_tx_rdy == 1'b1) && (tx_clk_en == 1'b1))
        ff_tx_eop <= 1'b0;
end

always @(posedge tx_clk or negedge tx_rstn)
begin
    if(tx_rstn == 1'b0)
        ff_tx_err <= 1'b0;
    else if((u1_rdreq == 1'b1) && (u1_q[72] == 1'b1))
        ff_tx_err <= u1_q[73];
    else if((ff_tx_rdy == 1'b1) && (tx_clk_en == 1'b1))
        ff_tx_err <= 1'b0;
end
//Encryption end
endmodule
