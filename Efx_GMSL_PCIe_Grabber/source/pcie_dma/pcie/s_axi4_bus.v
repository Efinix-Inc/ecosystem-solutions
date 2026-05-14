
`timescale 1 ns / 1 ns
module s_axi4_bus#(
    parameter                       M0_BASE_ADDR  = 64'h0,
    parameter                       M0_ADDR_SPACE = 1024,
    parameter                       M1_BASE_ADDR  = 64'h400,
    parameter                       M1_ADDR_SPACE = 1024,
    parameter                       M2_BASE_ADDR  = 64'h800,
    parameter                       M2_ADDR_SPACE = 1024
)
(
//Globle Signals
input                           axi_clk,
input                           axi_rstn,
//PCIE Slave AXI4 Bus Interface(Connect to PCIe Master AXI4 Bus)
//--Slave AXI4 Write
input           [7:0]           s_axi_awid,
input                           s_axi_awvalid,
input           [63:0]          s_axi_awaddr,
input           [7:0]           s_axi_awlen,
input           [2:0]           s_axi_awsize,
output  reg                     s_axi_awready,
input                           s_axi_wvalid,
input           [255:0]         s_axi_wdata,
input           [31:0]          s_axi_wstrb,
input                           s_axi_wlast,
output  reg                     s_axi_wready,
output  reg     [7:0]           s_axi_bid,
output  reg     [1:0]           s_axi_bresp,
output  reg                     s_axi_bvalid,
input                           s_axi_bready,
//--Slave AXI4 Read
input           [7:0]           s_axi_arid,
input                           s_axi_arvalid,
input           [63:0]          s_axi_araddr,
input           [7:0]           s_axi_arlen,
input           [2:0]           s_axi_arsize,
output  reg                     s_axi_arready,
output  reg     [7:0]           s_axi_rid,
output  reg                     s_axi_rvalid,
output  reg     [255:0]         s_axi_rdata,
output  reg                     s_axi_rlast,
output  reg     [1:0]           s_axi_rresp,
input                           s_axi_rready,
//Master AXI4 Bus 0 Interface
//--Master AXI4 Write
output  wire    [7:0]           m0_axi_awid,
output  wire                    m0_axi_awvalid,
output  wire    [63:0]          m0_axi_awaddr,
output  wire    [7:0]           m0_axi_awlen,
output  wire    [2:0]           m0_axi_awsize,
input                           m0_axi_awready,
output  wire                    m0_axi_wvalid,
output  wire    [255:0]         m0_axi_wdata,
output  wire    [31:0]          m0_axi_wstrb,
output  wire                    m0_axi_wlast,
input                           m0_axi_wready,
input           [7:0]           m0_axi_bid,
input           [1:0]           m0_axi_bresp,
input                           m0_axi_bvalid,
output  wire                    m0_axi_bready,
//--Master AXI4 Read
output  wire    [7:0]           m0_axi_arid,
output  wire                    m0_axi_arvalid,
output  wire    [63:0]          m0_axi_araddr,
output  wire    [7:0]           m0_axi_arlen,
output  wire    [2:0]           m0_axi_arsize,
input                           m0_axi_arready,
input           [7:0]           m0_axi_rid,
input                           m0_axi_rvalid,
input           [255:0]         m0_axi_rdata,
input                           m0_axi_rlast,
input           [1:0]           m0_axi_rresp,
output  wire                    m0_axi_rready,
//Master AXI4 Bus 1 Interface
//--Master AXI4 Write
output  wire    [7:0]           m1_axi_awid,
output  wire                    m1_axi_awvalid,
output  wire    [63:0]          m1_axi_awaddr,
output  wire    [7:0]           m1_axi_awlen,
output  wire    [2:0]           m1_axi_awsize,
input                           m1_axi_awready,
output  wire                    m1_axi_wvalid,
output  wire    [255:0]         m1_axi_wdata,
output  wire    [31:0]          m1_axi_wstrb,
output  wire                    m1_axi_wlast,
input                           m1_axi_wready,
input           [7:0]           m1_axi_bid,
input           [1:0]           m1_axi_bresp,
input                           m1_axi_bvalid,
output  wire                    m1_axi_bready,
//--Master AXI4 Read
output  wire    [7:0]           m1_axi_arid,
output  wire                    m1_axi_arvalid,
output  wire    [63:0]          m1_axi_araddr,
output  wire    [7:0]           m1_axi_arlen,
output  wire    [2:0]           m1_axi_arsize,
input                           m1_axi_arready,
input           [7:0]           m1_axi_rid,
input                           m1_axi_rvalid,
input           [255:0]         m1_axi_rdata,
input                           m1_axi_rlast,
input           [1:0]           m1_axi_rresp,
output  wire                    m1_axi_rready,
//Master AXI4 Bus 2 Interface
//--Master AXI4 Write
output  wire    [7:0]           m2_axi_awid,
output  wire                    m2_axi_awvalid,
output  wire    [63:0]          m2_axi_awaddr,
output  wire    [7:0]           m2_axi_awlen,
output  wire    [2:0]           m2_axi_awsize,
input                           m2_axi_awready,
output  wire                    m2_axi_wvalid,
output  wire    [255:0]         m2_axi_wdata,
output  wire    [31:0]          m2_axi_wstrb,
output  wire                    m2_axi_wlast,
input                           m2_axi_wready,
input           [7:0]           m2_axi_bid,
input           [1:0]           m2_axi_bresp,
input                           m2_axi_bvalid,
output  wire                    m2_axi_bready,
//--Master AXI4 Read
output  wire    [7:0]           m2_axi_arid,
output  wire                    m2_axi_arvalid,
output  wire    [63:0]          m2_axi_araddr,
output  wire    [7:0]           m2_axi_arlen,
output  wire    [2:0]           m2_axi_arsize,
input                           m2_axi_arready,
input           [7:0]           m2_axi_rid,
input                           m2_axi_rvalid,
input           [255:0]         m2_axi_rdata,
input                           m2_axi_rlast,
input           [1:0]           m2_axi_rresp,
output  wire                    m2_axi_rready
);
//Parameter Define 
localparam M0_TAIL_ADDR = M0_BASE_ADDR+M0_ADDR_SPACE;
localparam M1_TAIL_ADDR = M1_BASE_ADDR+M1_ADDR_SPACE;
localparam M2_TAIL_ADDR = M2_BASE_ADDR+M2_ADDR_SPACE;

//Register Define
reg     [2:0]                   m_rch;
reg                             s_axi_arready_pause;
reg                             null_axi_rvalid;
reg     [2:0]                   m_wch;
reg                             s_axi_awready_pause;
reg                             null_axi_bvalid;

//Wire Define
wire                            u1_wren;
wire    [7:0]                   u1_wdata;
wire                            u1_rden;
wire    [7:0]                   u1_rdata;
wire                            u1_empty;
wire                            u2_wren;
wire    [7:0]                   u2_wdata;
wire                            u2_rden;
wire    [7:0]                   u2_rdata;
wire                            u2_empty;

/*----------------------------------------------------------------------------------*\
                                 The main code
\*----------------------------------------------------------------------------------*/

/*----------------------- AXI4 Read Interface Region -----------------------*/

always @(posedge axi_clk or negedge axi_rstn)
begin
    if(axi_rstn == 1'b0)
        m_rch <= 3'h0;
    else if((m_rch == 3'h0) && (s_axi_arvalid == 1'b1) && (s_axi_araddr>=M0_BASE_ADDR) && (s_axi_araddr<M0_TAIL_ADDR))
        m_rch <= 3'h1;
    else if((m_rch == 3'h0) && (s_axi_arvalid == 1'b1) && (s_axi_araddr>=M1_BASE_ADDR) && (s_axi_araddr<M1_TAIL_ADDR))
        m_rch <= 3'h2;
    else if((m_rch == 3'h0) && (s_axi_arvalid == 1'b1) && (s_axi_araddr>=M2_BASE_ADDR) && (s_axi_araddr<M2_TAIL_ADDR))
        m_rch <= 3'h3;
    else if((m_rch == 3'h0) && (s_axi_arvalid == 1'b1))
        m_rch <= 3'h4;
    else if((s_axi_rvalid == 1'b1) && (s_axi_rready == 1'b1) && (s_axi_rlast == 1'b1))
        m_rch <= 3'h0;
end

always @(posedge axi_clk or negedge axi_rstn)
begin
    if(axi_rstn == 1'b0)
        s_axi_arready_pause <= 1'b0;
    else if((s_axi_arvalid == 1'b1) && (s_axi_arready == 1'b1))
        s_axi_arready_pause <= 1'b1;
    else if((s_axi_rvalid == 1'b1) && (s_axi_rready == 1'b1) && (s_axi_rlast == 1'b1))
        s_axi_arready_pause <= 1'b0;
end

efx_fifo_wrapper # (
    .FAMILY                             ("TITANIUM"                         ),
    .SYNC_CLK                           (1                                  ),
    .MODE                               ("FWFT"                             ),
    .DEPTH                              (512                                ),
    .DATA_WIDTH                         (8                                  ),
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
u1
(
    .a_rst_i                            (!axi_rstn                          ),
    .clk_i                              (axi_clk                            ),
    .wr_en_i                            (u1_wren                            ),
    .rd_en_i                            (u1_rden                            ),
    .wdata                              (u1_wdata                           ),
    .full_o                             (                                   ),
    .datacount_o                        (                                   ),
    .empty_o                            (u1_empty                           ),
    .rd_valid_o                         (                                   ),
    .rdata                              (u1_rdata                           ),
    .rst_busy                           (                                   )
); 

assign u1_wren = (s_axi_arvalid == 1'b1) && (s_axi_arready == 1'b1);
assign u1_wdata = s_axi_arid;
assign u1_rden = (s_axi_rvalid == 1'b1) && (s_axi_rready == 1'b1) && (s_axi_rlast == 1'b1);

//Master AXI BUS 0
assign m0_axi_arid     = 8'h0;
assign m0_axi_arvalid  = ((m_rch == 3'h1) && (s_axi_arready_pause == 1'b0)) ? s_axi_arvalid : 1'b0;
assign m0_axi_araddr   = s_axi_araddr - M0_BASE_ADDR;
assign m0_axi_arlen    = s_axi_arlen;
assign m0_axi_arsize   = s_axi_arsize;
assign m0_axi_rready   = ((m_rch == 3'h1) && (u1_empty == 1'b0)) ? s_axi_rready : 1'b0;
//Master AXI BUS 1
assign m1_axi_arid     = 8'h0;
assign m1_axi_arvalid  = ((m_rch == 3'h2) && (s_axi_arready_pause == 1'b0)) ? s_axi_arvalid : 1'b0;
assign m1_axi_araddr   = s_axi_araddr - M1_BASE_ADDR;
assign m1_axi_arlen    = s_axi_arlen;
assign m1_axi_arsize   = s_axi_arsize;
assign m1_axi_rready   = ((m_rch == 3'h2) && (u1_empty == 1'b0)) ? s_axi_rready : 1'b0;
//Master AXI BUS 2
assign m2_axi_arid     = 8'h0;
assign m2_axi_arvalid  = ((m_rch == 3'h3) && (s_axi_arready_pause == 1'b0)) ? s_axi_arvalid : 1'b0;
assign m2_axi_araddr   = s_axi_araddr - M2_BASE_ADDR;
assign m2_axi_arlen    = s_axi_arlen;
assign m2_axi_arsize   = s_axi_arsize;
assign m2_axi_rready   = ((m_rch == 3'h3) && (u1_empty == 1'b0)) ? s_axi_rready : 1'b0;
//Master AXI BUS NULL
always @(posedge axi_clk or negedge axi_rstn)
begin
    if(axi_rstn == 1'b0)
        null_axi_rvalid <= 1'b0;
    else if((m_rch == 3'h4) && (s_axi_arvalid == 1'b1) && (s_axi_arready == 1'b1))
        null_axi_rvalid <= 1'b1;
    else if((u1_empty == 1'b0) && (s_axi_rready == 1'b1))
        null_axi_rvalid <= 1'b0;
end

//Slave AXI BUS
always @(*)
begin
    case(m_rch)
    3'h1 :
        begin
            s_axi_arready = (s_axi_arready_pause) ? 1'b0 : m0_axi_arready;
            s_axi_rid     = u1_rdata;
            s_axi_rvalid  = (u1_empty) ? 1'b0 : m0_axi_rvalid;
            s_axi_rdata   = m0_axi_rdata;
            s_axi_rlast   = m0_axi_rlast;
            s_axi_rresp   = m0_axi_rresp;
        end
    3'h2 :
        begin
            s_axi_arready = (s_axi_arready_pause) ? 1'b0 : m1_axi_arready;
            s_axi_rid     = u1_rdata;
            s_axi_rvalid  = (u1_empty) ? 1'b0 : m1_axi_rvalid;
            s_axi_rdata   = m1_axi_rdata;
            s_axi_rlast   = m1_axi_rlast;
            s_axi_rresp   = m1_axi_rresp;
        end
    3'h3 :
        begin
            s_axi_arready = (s_axi_arready_pause) ? 1'b0 : m2_axi_arready;
            s_axi_rid     = u1_rdata;
            s_axi_rvalid  = (u1_empty) ? 1'b0 : m2_axi_rvalid;
            s_axi_rdata   = m2_axi_rdata;
            s_axi_rlast   = m2_axi_rlast;
            s_axi_rresp   = m2_axi_rresp;
        end
    3'h4 :
        begin
            s_axi_arready = (s_axi_arready_pause) ? 1'b0 : 1'b1;
            s_axi_rid     = u1_rdata;
            s_axi_rvalid  = (u1_empty) ? 1'b0 : null_axi_rvalid;
            s_axi_rdata   = 256'h0;
            s_axi_rlast   = 1'b1;
            s_axi_rresp   = 2'h3;
        end
    default :
        begin
            s_axi_arready = 1'b0;
            s_axi_rid     = 8'h0;
            s_axi_rvalid  = 1'b0;
            s_axi_rdata   = 256'h0;
            s_axi_rlast   = 1'b0;
            s_axi_rresp   = 2'h0;
        end
    endcase
end

/*----------------------- AXI4 Write Interface Region -----------------------*/
always @(posedge axi_clk or negedge axi_rstn)
begin
    if(axi_rstn == 1'b0)
        m_wch <= 3'h0;
    else if((m_wch == 3'h0) && (s_axi_awvalid == 1'b1) && (s_axi_awaddr>=M0_BASE_ADDR) && (s_axi_awaddr<M0_TAIL_ADDR))
        m_wch <= 3'h1;
    else if((m_wch == 3'h0) && (s_axi_awvalid == 1'b1) && (s_axi_awaddr>=M1_BASE_ADDR) && (s_axi_awaddr<M1_TAIL_ADDR))
        m_wch <= 3'h2;
    else if((m_wch == 3'h0) && (s_axi_awvalid == 1'b1) && (s_axi_awaddr>=M2_BASE_ADDR) && (s_axi_awaddr<M2_TAIL_ADDR))
        m_wch <= 3'h3;
    else if((m_wch == 3'h0) && (s_axi_awvalid == 1'b1))
        m_wch <= 3'h4;
    else if((s_axi_bvalid == 1'b1) && (s_axi_bready == 1'b1))
        m_wch <= 3'h0;
end

always @(posedge axi_clk or negedge axi_rstn)
begin
    if(axi_rstn == 1'b0)
        s_axi_awready_pause <= 1'b0;
    else if((s_axi_awvalid == 1'b1) && (s_axi_awready == 1'b1))
        s_axi_awready_pause <= 1'b1;
    else if((s_axi_bvalid == 1'b1) && (s_axi_bready == 1'b1))
        s_axi_awready_pause <= 1'b0;
end

efx_fifo_wrapper # (
    .FAMILY                             ("TITANIUM"                         ),
    .SYNC_CLK                           (1                                  ),
    .MODE                               ("FWFT"                             ),
    .DEPTH                              (512                                ),
    .DATA_WIDTH                         (8                                  ),
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
    .a_rst_i                            (!axi_rstn                          ),
    .clk_i                              (axi_clk                            ),
    .wr_en_i                            (u2_wren                            ),
    .rd_en_i                            (u2_rden                            ),
    .wdata                              (u2_wdata                           ),
    .full_o                             (                                   ),
    .datacount_o                        (                                   ),
    .empty_o                            (u2_empty                           ),
    .rd_valid_o                         (                                   ),
    .rdata                              (u2_rdata                           ),
    .rst_busy                           (                                   )
); 

assign u2_wren = (s_axi_awvalid == 1'b1) && (s_axi_awready == 1'b1);
assign u2_wdata = s_axi_awid;
assign u2_rden = (s_axi_bvalid == 1'b1) && (s_axi_bready == 1'b1);

//Master AXI BUS 0
assign m0_axi_awid     = 8'h0;
assign m0_axi_awvalid  = ((m_wch == 3'h1) && (s_axi_awready_pause == 1'b0)) ? s_axi_awvalid : 1'b0;
assign m0_axi_awaddr   = s_axi_awaddr - M0_BASE_ADDR;
assign m0_axi_awlen    = s_axi_awlen;
assign m0_axi_awsize   = s_axi_awsize;
assign m0_axi_wvalid   = (m_wch == 3'h1) ? s_axi_wvalid : 1'b0;
assign m0_axi_wdata    = s_axi_wdata;
assign m0_axi_wstrb    = s_axi_wstrb;
assign m0_axi_wlast    = s_axi_wlast;
assign m0_axi_bready   = ((m_wch == 3'h1) && (u2_empty == 1'b0)) ? s_axi_bready : 1'b0;
//Master AXI BUS 1
assign m1_axi_awid     = 8'h0;
assign m1_axi_awvalid  = ((m_wch == 3'h2) && (s_axi_awready_pause == 1'b0)) ? s_axi_awvalid : 1'b0;
assign m1_axi_awaddr   = s_axi_awaddr - M1_BASE_ADDR;
assign m1_axi_awlen    = s_axi_awlen;
assign m1_axi_awsize   = s_axi_awsize;
assign m1_axi_wvalid   = (m_wch == 3'h2) ? s_axi_wvalid : 1'b0;
assign m1_axi_wdata    = s_axi_wdata;
assign m1_axi_wstrb    = s_axi_wstrb;
assign m1_axi_wlast    = s_axi_wlast;
assign m1_axi_bready   = ((m_wch == 3'h2) && (u2_empty == 1'b0)) ? s_axi_bready : 1'b0;
//Master AXI BUS 2
assign m2_axi_awid     = 8'h0;
assign m2_axi_awvalid  = ((m_wch == 3'h3) && (s_axi_awready_pause == 1'b0)) ? s_axi_awvalid : 1'b0;
assign m2_axi_awaddr   = s_axi_awaddr - M2_BASE_ADDR;
assign m2_axi_awlen    = s_axi_awlen;
assign m2_axi_awsize   = s_axi_awsize;
assign m2_axi_wvalid   = (m_wch == 3'h3) ? s_axi_wvalid : 1'b0;
assign m2_axi_wdata    = s_axi_wdata;
assign m2_axi_wstrb    = s_axi_wstrb;
assign m2_axi_wlast    = s_axi_wlast;
assign m2_axi_bready   = ((m_wch == 3'h3) && (u2_empty == 1'b0)) ? s_axi_bready : 1'b0;
//Master AXI BUS NULL
always @(posedge axi_clk or negedge axi_rstn)
begin
    if(axi_rstn == 1'b0)
        null_axi_bvalid <= 1'b0;
    else if((m_wch == 3'h4) && (s_axi_awvalid == 1'b1) && (s_axi_awready == 1'b1))
        null_axi_bvalid <= 1'b1;
    else if((u2_empty == 1'b0) && (s_axi_bready == 1'b1))
        null_axi_bvalid <= 1'b0;
end

//Slave AXI BUS
always @(*)
begin
    case(m_wch)
    3'h1 :
        begin
            s_axi_awready = (s_axi_awready_pause) ? 1'b0 : m0_axi_awready;
            s_axi_wready  = m0_axi_wready;
            s_axi_bid     = u2_rdata;
            s_axi_bresp   = m0_axi_bresp;
            s_axi_bvalid  = (u2_empty) ? 1'b0 : m0_axi_bvalid;
        end
    3'h2 :
        begin
            s_axi_awready = (s_axi_awready_pause) ? 1'b0 : m1_axi_awready;
            s_axi_wready  = m1_axi_wready;
            s_axi_bid     = u2_rdata;
            s_axi_bresp   = m1_axi_bresp;
            s_axi_bvalid  = (u2_empty) ? 1'b0 : m1_axi_bvalid;
        end
    3'h3 :
        begin
            s_axi_awready = (s_axi_awready_pause) ? 1'b0 : m2_axi_awready;
            s_axi_wready  = m2_axi_wready;
            s_axi_bid     = u2_rdata;
            s_axi_bresp   = m2_axi_bresp;
            s_axi_bvalid  = (u2_empty) ? 1'b0 : m2_axi_bvalid;
        end
    3'h4 :
        begin
            s_axi_awready = (s_axi_awready_pause) ? 1'b0 : 1'b1;
            s_axi_wready  = 1'b1;
            s_axi_bid     = u2_rdata;
            s_axi_bresp   = 2'h3;
            s_axi_bvalid  = (u2_empty) ? 1'b0 : null_axi_bvalid;
        end
    default :
        begin
            s_axi_awready = 1'b0;
            s_axi_wready  = 1'b0;
            s_axi_bid     = 8'h0;
            s_axi_bresp   = 2'h0;
            s_axi_bvalid  = 1'b0;
        end
    endcase
end

endmodule
