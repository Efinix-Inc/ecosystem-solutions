module lpddr_rd#(
    parameter                       DATA_WTH = 64
)(
//Globle Signals
input                           clk                     ,
input                           rstn                    ,
//systerm reg Source Interface
input                           desc_valid              ,
output   reg                    desc_ready              ,
input           [63:0]          saddr_i                 ,
input           [27:0]          size_i                  ,
//AXI rd addr channl
input                           m_axi_arready           ,
output  reg     [63:0]          m_axi_araddr            ,
output          [7:0]           m_axi_arlen             ,
output  reg                     m_axi_arvalid           ,
//AXI rd data channl
input                           m_axi_rvalid            ,
input           [DATA_WTH-1:0]  m_axi_rdata             ,
input                           m_axi_rlast             ,
output                          m_axi_rready            ,
//AXI Stream Source Interface 
input                           src_axis_tready         ,
output          [DATA_WTH-1:0]  src_axis_tdata          ,
output                          src_axis_tvalid         ,
output                          src_axis_tlast                  
                                         

);

// Parameter Define
parameter                       MAX_RSIZE     = 256*8;
parameter                       GT_DESC       = 4'd0;
parameter                       CALC_AXI_LEN  = 4'd1;
parameter                       SEND_RW       = 4'd2;
parameter                       READ_DATA     = 4'd3;
parameter                       WAITE_XGMAC   = 4'd5;
parameter                       DONE          = 4'd4;


// Register Define
reg     [63:0]                  saddr         ;
reg     [27:0]                  size          ;
reg     [27:0]                  size_d1          ;
reg     [64:0]                  cur_addr             ;
reg     [7:0]                   axi_len             ;
//reg                             desc_ready           ;

reg     [2:0]                   cur_state           ;
reg     [2:0]                   next_state          ;
reg     [27:0]                  data_cnt          ;

// Wire Define
wire    [64:0]                  u1_wdata;
wire    [64:0]                  u1_rdata;
wire                            u1_empty;
wire                            u1_rden;
wire                            u1_wren;
wire                            u1_almfull;
wire                            u1_full;
wire                            u1_prog_full_o;
//Encryption begin
/*----------------------------------------------------------------------------------*\
                                 The main code
\*----------------------------------------------------------------------------------*/

always @(posedge clk or negedge rstn)
begin
    if(rstn == 1'b0)
        cur_state <= GT_DESC;
    else
		cur_state <= next_state;
end


always @(posedge clk or negedge rstn)
begin
    if(rstn == 1'b0)
        data_cnt <= 28'h0;
    else if(cur_state == GT_DESC)
		data_cnt <= 28'h0;
    else if(m_axi_rvalid == 1'b1 && m_axi_rready == 1'b1)
        data_cnt <= data_cnt + 28'd8; 
end


always @(*)
begin
	case(cur_state)
    GT_DESC      :
        if(desc_valid == 1'b1)
            next_state = CALC_AXI_LEN;
        else
            next_state = GT_DESC;
    CALC_AXI_LEN  :
        if(size == 28'b0)
            next_state = DONE;
        else
            next_state = SEND_RW;
    SEND_RW    :
        if( m_axi_arready == 1'b1)
            next_state = READ_DATA;
        else
            next_state = SEND_RW;
    READ_DATA:
        if( (m_axi_rlast == 1'b1) && (m_axi_rvalid == 1'b1) && (m_axi_rready == 1'b1))
            next_state = WAITE_XGMAC;
        else
            next_state = READ_DATA;
    WAITE_XGMAC:
        if( u1_prog_full_o != 1'b1)
            next_state = CALC_AXI_LEN;
        else
            next_state = WAITE_XGMAC;

    DONE:
        if( (data_cnt >= size_d1 - 28'd8) && (m_axi_rlast == 1'b1))
            next_state = GT_DESC;
        else
            next_state = DONE;        

    default : next_state = GT_DESC;

    endcase
end


always @(posedge clk or negedge rstn)
begin
    if(rstn == 1'b0)
        desc_ready <= 1'd1;
    else if(desc_valid == 1'b1 && desc_ready == 1'd1)
        desc_ready <= 1'd0;
    else if(cur_state == GT_DESC )
        desc_ready <= 1'd1; 
end

always @(posedge clk or negedge rstn)
begin
    if(rstn == 1'b0)
        m_axi_araddr <= 64'h0;
    else if(cur_state == CALC_AXI_LEN)
        m_axi_araddr <= cur_addr;
end


//assign m_axi_araddr = (cur_state == CALC_AXI_LEN) ? cur_addr : 64'h0 ;
assign m_axi_arlen      = axi_len  ;
/*assign src_axis_tdata   = m_axi_rdata;
assign src_axis_tlast   = m_axi_rlast; 
assign src_axis_tvalid  = m_axi_rvalid ;
assign m_axi_rready     = src_axis_tready  ;*/

wire   [8:0 ]  axi_len1 ;
assign  axi_len1 = axi_len + 1 ;

always @(posedge clk or negedge rstn)
begin
    if(rstn == 1'b0)
        m_axi_arvalid <= 1'd0;
    else if(cur_state == CALC_AXI_LEN && size != 28'b0 )
        m_axi_arvalid <= 1'd1;
    else if(cur_state == SEND_RW && m_axi_arready == 1'b1 )
        m_axi_arvalid <= 1'd0; 
end

always @(posedge clk or negedge rstn)
begin
    if(rstn == 1'b0)
        saddr <= 64'd0;
    else if(cur_state == GT_DESC && desc_valid == 1'b1)
        saddr <=saddr_i;
    else if(cur_state == DONE )
        saddr <= 64'd0; 
end


always @(posedge clk or negedge rstn)
begin
    if(rstn == 1'b0)
        size_d1 <= 28'd0;
    else if(cur_state == GT_DESC && desc_valid == 1'b1)
        size_d1 <=size_i;
end

always @(posedge clk or negedge rstn)
begin
    if(rstn == 1'b0)
        size <= 28'd0;
    else if(cur_state == GT_DESC && desc_valid == 1'b1)
        size <=size_i;
    else if(cur_state == SEND_RW &&  m_axi_arready == 1'b1 )
        size <= size - {axi_len1,3'b0}; 
end

always @(posedge clk or negedge rstn)
begin
    if(rstn == 1'b0)
        axi_len <= 8'h0;
    else if(cur_state == GT_DESC || cur_state == DONE)
        axi_len <= 8'h0;
    else if((cur_state == CALC_AXI_LEN) &&  (MAX_RSIZE > size) )
        axi_len <= size[10:3] - 1; 
    else if((cur_state == CALC_AXI_LEN) &&  (MAX_RSIZE <= size) )
        axi_len <= 8'hff; 
    
end



always @(posedge clk or negedge rstn)
begin
    if(rstn == 1'b0)
        cur_addr <= 64'hffff_ffff_ffff_ffff;
    else if(cur_state == GT_DESC || cur_addr == 64'hffff_ffff_ffff_ffff)
        cur_addr <=saddr_i;
    else if(cur_state == SEND_RW && m_axi_arready == 1'b1)
        cur_addr <= cur_addr + {axi_len1,3'b0};

end



assign u1_wdata = {m_axi_rdata,m_axi_rlast};
assign m_axi_rready  = !u1_full  ;
assign u1_wren  = m_axi_rready == 1'b1 &&  m_axi_rvalid == 1'b1;

assign {src_axis_tdata,src_axis_tlast} = u1_rdata;
assign src_axis_tvalid = ~u1_empty;
assign u1_rden = src_axis_tvalid && src_axis_tready;

efx_fifo_wrapper # (
    .FAMILY                             ("TITANIUM"                         ),
    .SYNC_CLK                           (1                                  ),
    .MODE                               ("FWFT"                             ),
    .DEPTH                              (2048                               ),
    .DATA_WIDTH                         (65                                 ),
    .PIPELINE_REG                       (1                                  ),
    .OPTIONAL_FLAGS                     (0                                  ),
    .OUTPUT_REG                         (0                                  ),
    .PROGRAMMABLE_FULL                  ("STATIC_SINGLE"                    ),
    .PROG_FULL_ASSERT                   (1024                               ),
    .PROG_FULL_NEGATE                   (1024                               ),
    .PROGRAMMABLE_EMPTY                 ("NONE"                             ),
    .PROG_EMPTY_ASSERT                  (0                                  ),
    .PROG_EMPTY_NEGATE                  (0                                  ),
    .RAM_STYLE                          ("block_ram"                        )
)
u1
(
    .a_rst_i                            (!rstn                              ),
    .clk_i                              (clk                                ),
    .wr_en_i                            (u1_wren                            ),
    .rd_en_i                            (u1_rden                            ),
    .wdata                              (u1_wdata                           ),
    .almost_full_o                      (u1_almfull                         ),
    .prog_full_o                        (u1_prog_full_o                     ),
    .full_o                             (u1_full                            ),
    .datacount_o                        (                                   ),
    .empty_o                            (u1_empty                           ),
    .rd_valid_o                         (                                   ),
    .rdata                              (u1_rdata                           ),
    .rst_busy                           (                                   )
); 



//Encryption end

endmodule