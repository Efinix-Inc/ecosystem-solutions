
`timescale 1 ns / 1 ns
module lpddr4_wr#(
    parameter                       AXI_BURST = 256,
    parameter                       AXI_DW = 64
)
(
//Globle Signals
input                           clk,
input                           rstn,
//Cfg Space Registers
input           [63:0]          base_addr,
input           [31:0]          addr_space,//in bytes.
//Slave AXI-Stream Bus Interface
input                           s_axis_tvalid,
input           [AXI_DW-1:0]    s_axis_tdata,
//input           [7:0]           s_axis_tkeep,
input                           s_axis_tlast,
output  reg                     s_axis_tready,
//Master AXI4 Write Bus Interface(Connect to BUF Slave AXI4 Bus)
output  wire    [7:0]           m_axi_awid,
output  reg                     m_axi_awvalid,
output  reg     [63:0]          m_axi_awaddr,
output  wire    [3:0]           m_axi_awregion,
output  reg     [7:0]           m_axi_awlen,
output  wire    [2:0]           m_axi_awsize,
output  wire    [1:0]           m_axi_awburst,
output  wire    [2:0]           m_axi_awprot,
output  wire    [1:0]           m_axi_awlock,
output  wire    [3:0]           m_axi_awcache,
input                           m_axi_awready,
output  reg                     m_axi_wvalid,
output  reg     [AXI_DW-1:0]    m_axi_wdata,
output  wire    [AXI_DW/8-1:0]  m_axi_wstrb,
output  reg                     m_axi_wlast,
input                           m_axi_wready,
input           [7:0]           m_axi_bid,
input           [1:0]           m_axi_bresp,
input                           m_axi_bvalid,
output  wire                    m_axi_bready,
//Status and  Error Signals
output  reg     [63:0]          update_addr,
output  reg                     update_en
);
//Parameter Define 

//Register Define
reg     [7:0]                   burst_len;
reg     [28:0]                  space_cnt;
reg                             addr_clr;
reg                             axi_busy;
reg     [7:0]                   burst_cnt;

//Wire Define
wire                            u1_wren;
wire    [AXI_DW-1:0]            u1_wdata;
wire                            u1_almfull;
wire                            u1_full;
wire                            u1_rden;
wire    [AXI_DW-1:0]            u1_rdata;
wire                            u1_empty;
wire                            u2_wren;
wire    [8:0]                   u2_wdata;
wire                            u2_almfull;
wire                            u2_full;
wire                            u2_rden;
wire    [8:0]                   u2_rdata;
wire                            u2_empty;


/*----------------------------------------------------------------------------------*\
                                 The main code
\*----------------------------------------------------------------------------------*/

/*----------------------- Slave AXI Stream Bus Region ----------------------------*/

always @(posedge clk or negedge rstn)
begin
    if(rstn == 1'b0)
        s_axis_tready <= 1'b0;
    else if((u1_almfull == 1'b1) || (u1_full == 1'b1))
        s_axis_tready <= 1'b0;
    else
        s_axis_tready <= 1'b1;
end

efx_fifo_wrapper # (
    .FAMILY                             ("TITANIUM"                         ),
    .SYNC_CLK                           (1                                  ),
    .MODE                               ("FWFT"                             ),
    .DEPTH                              (2048                               ),
    .DATA_WIDTH                         (AXI_DW                             ),
    .PIPELINE_REG                       (1                                  ),
    .OPTIONAL_FLAGS                     (1                                  ),
    .OUTPUT_REG                         (0                                  ),
    .PROGRAMMABLE_FULL                  ("NONE"                             ),
    .PROG_FULL_ASSERT                   (512                                ),
    .PROG_FULL_NEGATE                   (512                                ),
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
    .full_o                             (u1_full                            ),
    .datacount_o                        (                                   ),
    .empty_o                            (u1_empty                           ),
    .rd_valid_o                         (                                   ),
    .rdata                              (u1_rdata                           ),
    .rst_busy                           (                                   )
); 

assign u1_wdata = s_axis_tdata;
assign u1_wren = (s_axis_tvalid == 1'b1) && (s_axis_tready == 1'b1);
//assign u1_rden = (((m_axi_awvalid == 1'b1) && (m_axi_awready == 1'b1)) || 
//                (axi_busy == 1'b1)) && ((m_axi_wvalid == 1'b0) || (m_axi_wready == 1'b1));

assign u1_rden = (((m_axi_awvalid == 1'b1) && (m_axi_awready == 1'b1)) || 
                ((axi_busy == 1'b1) && (m_axi_wlast == 1'b0))) && ((m_axi_wvalid == 1'b0) || (m_axi_wready == 1'b1));

efx_fifo_wrapper # (
    .FAMILY                             ("TITANIUM"                         ),
    .SYNC_CLK                           (1                                  ),
    .MODE                               ("FWFT"                             ),
    .DEPTH                              (512                                ),
    .DATA_WIDTH                         (9                                  ),
    .PIPELINE_REG                       (1                                  ),
    .OPTIONAL_FLAGS                     (0                                  ),
    .OUTPUT_REG                         (0                                  ),
    .PROGRAMMABLE_FULL                  ("NONE"                             ),
    .PROG_FULL_ASSERT                   (512                                ),
    .PROG_FULL_NEGATE                   (512                                ),
    .PROGRAMMABLE_EMPTY                 ("NONE"                             ),
    .PROG_EMPTY_ASSERT                  (0                                  ),
    .PROG_EMPTY_NEGATE                  (0                                  ),
    .RAM_STYLE                          ("block_ram"                        )
)
u2
(
    .a_rst_i                            (!rstn                              ),
    .clk_i                              (clk                                ),
    .wr_en_i                            (u2_wren                            ),
    .rd_en_i                            (u2_rden                            ),
    .wdata                              (u2_wdata                           ),
    .almost_full_o                      (u2_almfull                         ),
    .full_o                             (u2_full                            ),
    .datacount_o                        (                                   ),
    .empty_o                            (u2_empty                           ),
    .rd_valid_o                         (                                   ),
    .rdata                              (u2_rdata                           ),
    .rst_busy                           (                                   )
); 

assign u2_wdata = {addr_clr,burst_len};
assign u2_wren = (s_axis_tvalid == 1'b1) && (s_axis_tready == 1'b1) && ((burst_len >= AXI_BURST-1) || (s_axis_tlast == 1'b1) || (space_cnt >= addr_space[31:3]-1));
assign u2_rden = (u2_empty == 1'b0) && ((axi_busy == 1'b0) || ((m_axi_wready == 1'b1) && (m_axi_wlast == 1'b1)));

always @(posedge clk or negedge rstn)
begin
    if(rstn == 1'b0)
        burst_len <= 8'h0;
    else if(u2_wren == 1'b1)
        burst_len <= 8'h0;
    else if((s_axis_tvalid == 1'b1) && (s_axis_tready == 1'b1))
        burst_len <= burst_len + 1;
end

always @(posedge clk or negedge rstn)
begin
    if(rstn == 1'b0)
        space_cnt <= 29'h0;
    else if((s_axis_tvalid == 1'b1) && (s_axis_tready == 1'b1) && (space_cnt >= addr_space[31:3]-1))
        space_cnt <= 29'h0;
    else if((s_axis_tvalid == 1'b1) && (s_axis_tready == 1'b1))
        space_cnt <= space_cnt + 1;
end

always @(posedge clk or negedge rstn)
begin
    if(rstn == 1'b0)
        addr_clr <= 1'b1;
    else if((s_axis_tvalid == 1'b1) && (s_axis_tready == 1'b1) && (space_cnt >= addr_space[31:3]-1))
        addr_clr <= 1'b1;
    else if(u2_wren == 1'b1)
        addr_clr <= 1'b0;
end

always @(posedge clk or negedge rstn)
begin
    if(rstn == 1'b0)
        axi_busy <= 1'b0;
    else if(u2_rden == 1'b1)
        axi_busy <= 1'b1;
    else if((m_axi_wvalid == 1'b1) && (m_axi_wready == 1'b1) && (m_axi_wlast == 1'b1))
        axi_busy <= 1'b0;
end

/*----------------------- Master AXI4 Write Bus Region ----------------------------*/
assign m_axi_awid = 8'h0;
assign m_axi_awregion = 4'h0;
assign m_axi_awsize = 3'h3;
assign m_axi_awburst = 2'b01;
assign m_axi_awprot = 3'b010;
assign m_axi_awlock = 2'b00;
assign m_axi_awcache = 4'b0011;
assign m_axi_wstrb = 32'hffffffff;
assign m_axi_bready = 1'b1;

always @(posedge clk or negedge rstn)
begin
    if(rstn == 1'b0)
        m_axi_awvalid <= 1'b0;
    else if(u2_rden == 1'b1)
        m_axi_awvalid <= 1'b1;
    else if(m_axi_awready == 1'b1)
        m_axi_awvalid <= 1'b0;
end

always @(posedge clk or negedge rstn)
begin
    if(rstn == 1'b0)
        m_axi_awaddr <= 64'h0;
    else if((u2_rden == 1'b1) && (u2_rdata[8] == 1'b1))
        m_axi_awaddr <= base_addr;
    else if(u2_rden == 1'b1)
        m_axi_awaddr <= m_axi_awaddr + ((u2_rdata[7:0]+1)<<3);
end

always @(posedge clk or negedge rstn)
begin
    if(rstn == 1'b0)
        m_axi_awlen <= 8'h0;
    else if(u2_rden == 1'b1)
        m_axi_awlen <= u2_rdata[7:0];
end

always @(posedge clk or negedge rstn)
begin
    if(rstn == 1'b0)
        m_axi_wvalid <= 1'b0;
    else if((m_axi_awvalid == 1'b1) && (m_axi_awready == 1'b1))
        m_axi_wvalid <= 1'b1;
	else if((m_axi_wready == 1'b1) && (m_axi_wlast == 1'b1))
        m_axi_wvalid <= 1'b0;
end

always @(posedge clk or negedge rstn)
begin
    if(rstn == 1'b0)
        m_axi_wdata <= 0;
    else if(u1_rden == 1'b1)
        m_axi_wdata <= u1_rdata;
end

always @(posedge clk or negedge rstn)
begin
    if(rstn == 1'b0)
        burst_cnt <= 8'h0;
    else if((m_axi_awvalid == 1'b1) && (m_axi_awready == 1'b1))
        burst_cnt <= m_axi_awlen;
    else if((m_axi_wvalid == 1'b1) && (m_axi_wready == 1'b1) && (burst_cnt != 0))
        burst_cnt <= burst_cnt - 1;
end

always @(posedge clk or negedge rstn)
begin
    if(rstn == 1'b0)
        m_axi_wlast <= 1'b0;
    else if(((m_axi_awvalid == 1'b1) && (m_axi_awready == 1'b1) && (m_axi_awlen == 8'h0)) || ((m_axi_wvalid == 1'b1) && (m_axi_wready == 1'b1) && (burst_cnt == 8'h1)))
        m_axi_wlast <= 1'b1;
    else if(m_axi_wready == 1'b1)
        m_axi_wlast <= 1'b0;
end

/*----------------------- Common Region ----------------------------*/
always @(posedge clk or negedge rstn)
begin
    if(rstn == 1'b0)
        update_addr <= 64'h0;
    else if((m_axi_awvalid == 1'b1) && (m_axi_awready == 1'b1))
        update_addr <= m_axi_awaddr + ((m_axi_awlen+1)<<3);
end

always @(posedge clk or negedge rstn)
begin
    if(rstn == 1'b0)
        update_en <= 1'b0;
    else if((m_axi_wvalid == 1'b1) && (m_axi_wready == 1'b1) && (m_axi_wlast == 1'b1))
        update_en <= 1'b1;
    else
        update_en <= 1'b0;
end

endmodule
