//module definition


module lpddr_wr#(
    parameter                       DATA_WTH = 256
)(
//Globle Signals
input                           clk                     ,
input                           rstn                    ,
//systerm reg Source Interface
input           [63:0]          c_saddr_i               ,
input           [63:0]          c_eaddr_i               ,
input           [63:0]          h_saddr_i               ,
input           [63:0]          h_eaddr_i               ,
input                           lpdr_wr_en              ,
input                           dma_sta                 ,
input                           desc_ready              ,
output   reg                    desc_valid              ,
output   reg                    lpdr_wr_busy            ,
output   reg    [63:0]          desc_src_addr           ,
output   reg    [63:0]          desc_dst_addr           ,
output   reg    [27:0]          desc_len                ,
//AXI rd addr channl
input                           m_axi_awready            ,
output          [63:0]          m_axi_awaddr            ,
output          [7:0]           m_axi_awlen             ,
output   reg                    m_axi_awvalid           ,
//AXI rd data channl
output                          m_axi_wvalid            ,
output          [DATA_WTH-1:0]  m_axi_wdata             ,
output                          m_axi_wlast             ,
input                           m_axi_wready            ,
//AXI Stream Source Interface 
input                           sink_axis_tvalid        ,
output                          sink_axis_tready        ,
input           [DATA_WTH-1:0]  sink_axis_tdata         ,
input                           sink_axis_tlast         ,       
input           [27:0]          sink_axis_tuser               
                                         

);

// Parameter Define
parameter                       MAX_WSIZE     = 256*32;
parameter                       IDEL       = 4'd0;
parameter                       GET_CMD    = 4'd1;
parameter                       SEND_DATA  = 4'd2;
parameter                       DONE       = 4'd3;


// Register Define
reg     [63:0]                  c_saddr         ;
reg     [63:0]                  c_eaddr         ;
reg     [63:0]                  h_saddr         ;
reg     [63:0]                  h_eaddr         ;
reg     [64:0]                  cur_addr             ;
reg     [64:0]                  cur_addr_cnt             ;
reg     [27:0]                  pkt_len             ;

//reg                             desc_ready           ;
reg     [27:0]                  w_cnt           ;

reg     [2:0]                   cur_state           ;
reg     [2:0]                   next_state          ;

// Wire Define
wire    [63:0]                  size_4k    ; 
wire    [7:0]                   size_4k_len    ; 
wire    [63:0]                  desc_raddr ;
wire                            addr_ready ;
wire                            fifo_empty ;
wire                            wr_en      ;
wire    [63:0]                  h_c_addr   ;
wire    [63:0]                  h_c_flag   ;
wire    [7:0]                   axi_len   ;
wire    [8:0]                   axi_len1;
wire    [28:0]                  pkt_len1             ;
//Encryption begin
/*----------------------------------------------------------------------------------*\
                                 The main code
\*----------------------------------------------------------------------------------*/

always @(posedge clk or negedge rstn)
begin
    if(rstn == 1'b0)
        cur_state <= IDEL;
    else
		cur_state <= next_state;
end


always @(*)
begin
	case(cur_state)
    IDEL      :
        if(lpdr_wr_en == 1'b1)
            next_state = GET_CMD;
        else
            next_state = IDEL;
    GET_CMD  :
        if((sink_axis_tvalid == 1'b1) && (addr_ready == 1'b1))
            next_state = SEND_DATA;
        else
            next_state = GET_CMD;
    SEND_DATA    :
        if(w_cnt == 28'h0 && m_axi_awvalid ==1'b0 )
            next_state = DONE;
        else
            next_state = SEND_DATA;
    DONE    :
        if(lpdr_wr_en == 1'b0)
            next_state = IDEL;
        else if(desc_ready == 1'b1)
            next_state = GET_CMD;
        else
            next_state = DONE;

    default : next_state = IDEL;

    endcase
end


assign pkt_len1 = pkt_len + 1 ;
assign size_4k = 13'h1000 - cur_addr[11:0]; 
assign size_4k_len = size_4k[12:5] - 1'b1; 

assign axi_len = pkt_len > size_4k_len ? size_4k_len :
                     pkt_len > 8'hff   ? 8'hff       : 
                                         pkt_len -1'b1   ;
assign addr_ready = fifo_empty                               ? 1'b1 :
                    desc_raddr < cur_addr                    ? 1'b1 :
                    desc_raddr - cur_addr >  {pkt_len1,5'b0} ? 1'b1 :
                                                               1'b0 ;

assign m_axi_awlen = axi_len;
assign m_axi_awaddr = cur_addr;


always @(posedge clk or negedge rstn)
begin
    if(rstn == 1'b0)
        begin
            c_saddr <= 64'h0;
            h_saddr <= 64'h0;
            c_eaddr <= 64'h0;
            h_eaddr <= 64'h0;
        end
    else if(cur_state ==  IDEL)
        begin
            c_saddr <= c_saddr_i;
            h_saddr <= h_saddr_i;
            c_eaddr <= c_eaddr_i;
            h_eaddr <= h_eaddr_i;
        end
end




always @(posedge clk or negedge rstn)
begin
    if(rstn == 1'b0)
        m_axi_awvalid <= 1'd0;
    else if((cur_state == SEND_DATA && pkt_len == 28'h0)  || (m_axi_awvalid ==1'b1 && m_axi_awready ==1'b1))
        m_axi_awvalid <= 1'd0;
    else if(cur_state == SEND_DATA )
        m_axi_awvalid <= 1'd1;      //yiwen

end

always @(posedge clk or negedge rstn)
begin
    if(rstn == 1'b0)
        lpdr_wr_busy <= 1'd0;
    else if(cur_state == IDEL )
        lpdr_wr_busy <= 1'd0;
    else 
        lpdr_wr_busy <= 1'd1;      //yiwen
end



always @(posedge clk or negedge rstn)
begin
    if(rstn == 1'b0)
        pkt_len <= 28'd0;
    else if(cur_state == GET_CMD )
        pkt_len <= sink_axis_tuser + 1;
    else if(m_axi_awvalid && m_axi_awready )
        pkt_len <= pkt_len - axi_len1;      //yiwen
end


always @(posedge clk or negedge rstn)
begin
    if(rstn == 1'b0)
        w_cnt <= 28'h0;
    else if((cur_state == GET_CMD))
        w_cnt <= sink_axis_tuser;
    else if(cur_state == SEND_DATA && m_axi_wvalid == 1'b1 && m_axi_wready == 1'b1 )
        w_cnt <= w_cnt - 1'h1;      //yiwen 
end

always @(posedge clk or negedge rstn)
begin
    if(rstn == 1'b0)
        cur_addr_cnt <= 28'h0;
    else if((cur_state == IDEL) || ((cur_state == GET_CMD) && (c_eaddr - cur_addr < {(sink_axis_tuser + 1),5'b0})) )
        cur_addr_cnt <= c_saddr;
    else if(cur_state == GET_CMD)
        cur_addr_cnt <= cur_addr;
    else if(cur_state == SEND_DATA && m_axi_wvalid == 1'b1 && m_axi_wready == 1'b1 )
        cur_addr_cnt <= cur_addr_cnt + 32;      //yiwen 
end

/*always @(posedge clk or negedge rstn)
begin
    if(rstn == 1'b0)
        m_axi_wlast <= 1'd0;
    else if((m_axi_wready == 1'b1 ) && (m_axi_wlast == 1'b1))
        m_axi_wlast <= 1'd0;
    else if(w_cnt == axi_len - 1 && m_axi_wvalid == 1'b1 && m_axi_wready == 1'b1 )
        m_axi_wlast <= 1'd1;      //yiwen 
end*/


assign m_axi_wlast = ((cur_addr_cnt[11:0]  == 12'hfe0) || (sink_axis_tlast)) ? 1'b1 :1'b0;
//assign m_axi_wlast = cur_addr_cnt[11:0] == 12'hfe0 ? 1'b1 :1'b0;

assign m_axi_wdata = sink_axis_tdata;
assign m_axi_wvalid = (cur_state == SEND_DATA) ? sink_axis_tvalid :1'b0;
assign sink_axis_tready =  (cur_state == SEND_DATA) ? m_axi_wready :1'b0;
assign axi_len1 = axi_len+1;



always @(posedge clk or negedge rstn)
begin
    if(rstn == 1'b0)
        cur_addr <= 64'd0;
    else if((cur_state == IDEL) || ((cur_state == GET_CMD) && (c_eaddr - cur_addr < {(sink_axis_tuser + 1),5'b0})) )
        cur_addr <= c_saddr;
    else if( m_axi_awvalid == 1'b1 && m_axi_awready == 1'b1 )
        cur_addr <= cur_addr + {axi_len1,5'b0} ;      //
end

assign h_c_addr =  h_saddr > c_saddr ? h_saddr - c_saddr : c_saddr - h_saddr;
assign h_c_flag =  h_saddr > c_saddr ? 1'b1 :1'b0 ;
always @(posedge clk or negedge rstn)
begin
    if(rstn == 1'b0)
        desc_src_addr <= 64'd0;
    else if((cur_state == GET_CMD) && (c_eaddr - cur_addr < pkt_len) )
        desc_src_addr <= c_saddr;
    else if(cur_state == GET_CMD )
        desc_src_addr <= cur_addr;      //
end

always @(posedge clk or negedge rstn)
begin
    if(rstn == 1'b0)
        desc_dst_addr <= 64'd0;
    else if(h_c_flag == 1'b1)
        desc_dst_addr <= desc_src_addr + h_c_addr;      //
    else if(h_c_flag == 1'b0)
        desc_dst_addr <= desc_src_addr - h_c_addr;      //
end

always @(posedge clk or negedge rstn)
begin
    if(rstn == 1'b0)
        desc_len <= 28'd0;
    else if((cur_state == GET_CMD)  )
        desc_len <= {(sink_axis_tuser + 1),5'b0};

end

always @(posedge clk or negedge rstn)
begin
    if(rstn == 1'b0)
        desc_valid <= 1'd0;
    else if(desc_ready == 1'b1 && desc_valid == 1'd1)
        desc_valid <= 1'd0;
    else if((cur_state == DONE))
        desc_valid <= 1'd1;

end

assign wr_en = desc_ready == 1'b1 && desc_valid == 1'b1 ;

efx_fifo_wrapper#(
    .SYNC_CLK                           (1                                  ),
    .SYNC_STAGE                         (2                                  ),
    .DATA_WIDTH                         (64                                 ),
    .MODE                               ("FWFT"                             ),
    .OUTPUT_REG                         (0                                  ),
    .PROG_FULL_ASSERT                   (                                   ),
    .PROGRAMMABLE_FULL                  ("STATIC_SINGLE"                    ),
    .PROG_FULL_NEGATE                   (                                   ),
    .PROGRAMMABLE_EMPTY                 ("NONE"                             ),
    .PROG_EMPTY_ASSERT                  (0                                  ),
    .PROG_EMPTY_NEGATE                  (0                                  ),
    .OPTIONAL_FLAGS                     (1                                  ),
    .PIPELINE_REG                       (1                                  ),
    .DEPTH                              (16                                 ),
    .FAMILY                             ("TITANIUM"                         ),
    .ASYM_WIDTH_RATIO                   (4                                  ),
    .BYPASS_RESET_SYNC                  (0                                  ),
    .RAM_STYLE                          ("register"                         )
)
u2_wr_fifo
(
    .almost_full_o                      (                                   ),
    .prog_full_o                        (                                   ),
    .full_o                             (                                   ),
    .overflow_o                         (                                   ),
    .wr_ack_o                           (                                   ),
    .empty_o                            (fifo_empty                         ),
    .almost_empty_o                     (                                   ),
    .underflow_o                        (                                   ),
    .rd_valid_o                         (                                   ),
    .rdata                              (desc_raddr                         ),
    .clk_i                              (clk                                ),
    .wr_clk_i                           (                                   ),
    .rd_clk_i                           (                                   ),
    .wr_en_i                            (wr_en                              ),
    .rd_en_i                            (dma_sta                            ),
    .wdata                              (desc_src_addr                      ),
    .wr_datacount_o                     (                                   ),
    .rst_busy                           (                                   ),
    .rd_datacount_o                     (                                   ),
    .a_wr_rst_i                         (                                   ),
    .a_rd_rst_i                         (                                   ),
    .a_rst_i                            (!rstn                       )
);


//Encryption end

endmodule