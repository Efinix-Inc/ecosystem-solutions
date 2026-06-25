module axi4_to_axi4l
#( parameter AWIDTH = 32,
   parameter DWIDTH = 32
)(
  // AXI4 (Slave) IN
  output                  s_axi4_awready,
  input  [AWIDTH-1:0]     s_axi4_awaddr,
  input  [7:0]            s_axi4_awid,
  input                   s_axi4_awvalid,
  
  output                  s_axi4_wready,
  input  [DWIDTH-1:0]     s_axi4_wdata,
  input  [(DWIDTH/8)-1:0] s_axi4_wstrb,
  input                   s_axi4_wvalid,

  input                   s_axi4_bready,
  output [1:0]            s_axi4_bresp,
  output [7:0]            s_axi4_bid,
  output                  s_axi4_bvalid,
  
  output              s_axi4_arready,
  input  [AWIDTH-1:0] s_axi4_araddr,
  input  [7:0]        s_axi4_arid,
  input               s_axi4_arvalid,
  
  input               s_axi4_rready,
  output [DWIDTH-1:0] s_axi4_rdata,
  output [1:0]        s_axi4_rresp,
  output [7:0]        s_axi4_rid,
  output              s_axi4_rvalid,
  output              s_axi4_rlast,

  // AXI4-Lite (Master) OUT
  output [AWIDTH-1:0]     m_axi4l_awaddr,
  output                  m_axi4l_awvalid,
  input                   m_axi4l_awready,
  
  output [DWIDTH-1:0]     m_axi4l_wdata,
  output [(DWIDTH/8)-1:0] m_axi4l_wstrb,
  output                  m_axi4l_wvalid,
  input                   m_axi4l_wready,
  
  input  [1:0]            m_axi4l_bresp,
  input                   m_axi4l_bvalid,
  output                  m_axi4l_bready,
  
  output [AWIDTH-1:0]     m_axi4l_araddr,
  output                  m_axi4l_arvalid,
  input                   m_axi4l_arready,
  
  input [1:0]             m_axi4l_rresp,
  input [DWIDTH-1:0]      m_axi4l_rdata,
  input                   m_axi4l_rvalid,
  output                  m_axi4l_rready,

  // Global signals
  input axi_clk,
  input axi_rstn
);

reg [7:0] axi4_awid_r;
reg [7:0] axi4_arid_r;

assign m_axi4l_awaddr  = s_axi4_awaddr;
assign m_axi4l_awvalid = s_axi4_awvalid;
assign m_axi4l_wdata   = s_axi4_wdata;
assign m_axi4l_wstrb   = s_axi4_wstrb;
assign m_axi4l_wvalid  = s_axi4_wvalid;
assign m_axi4l_bready  = s_axi4_bready;

assign m_axi4l_araddr  = s_axi4_araddr;
assign m_axi4l_arvalid = s_axi4_arvalid;
assign m_axi4l_rready  = s_axi4_rready;

assign s_axi4_awready  = m_axi4l_awready;
assign s_axi4_wready   = m_axi4l_wready;
assign s_axi4_arready  = m_axi4l_arready;
assign s_axi4_bresp    = m_axi4l_bresp;
assign s_axi4_bid      = axi4_awid_r;
assign s_axi4_bvalid   = m_axi4l_bvalid;
assign s_axi4_rdata    = m_axi4l_rdata;
assign s_axi4_rresp    = m_axi4l_rresp;
assign s_axi4_rid      = axi4_arid_r;
assign s_axi4_rvalid   = m_axi4l_rvalid;
assign s_axi4_rlast    = 1'b1;

always @(posedge axi_clk or negedge axi_rstn) begin
  if(~axi_rstn) begin
    axi4_awid_r <= 8'h0;
  end else begin
    if(s_axi4_awvalid & s_axi4_awready) axi4_awid_r <= s_axi4_awid;
  end
end

always @(posedge axi_clk or negedge axi_rstn) begin
  if(~axi_rstn) begin
    axi4_arid_r <= 8'h0;
  end else begin
    if(s_axi4_arvalid & s_axi4_arready) axi4_arid_r <= s_axi4_arid;
  end
end

endmodule

// ------------------------------------
// Instantiation template:
//-------------------------------------
//
//axi4_to_axi4l u_axi4_to_axi4l
//(
//  // From SOC
// .s_axi4_awready(  ),
// .s_axi4_awaddr(  ),
// .s_axi4_awid(  ),
// .s_axi4_awvalid(  ),
//  
// .s_axi4_wready(  ),
// .s_axi4_wdata(  ),
// .s_axi4_wstrb(  ),
// .s_axi4_wvalid(  ),
//
// .s_axi4_bready(  ),
// .s_axi4_bresp(  ),
// .s_axi4_bid(  ),
// .s_axi4_bvalid(  ),
//  
// .s_axi4_arready(  ),
// .s_axi4_araddr(  ),
// .s_axi4_arid(  ),
// .s_axi4_arvalid(  ),
//  
// .s_axi4_rready(  ),
// .s_axi4_rdata(  ),
// .s_axi4_rresp(  ),
// .s_axi4_rid(  ),
// .s_axi4_rvalid(  ),
// .s_axi4_rlast(  ),
//
//  // To SDHC
// .m_axi4l_awaddr(  ),
// .m_axi4l_awvalid(  ),
// .m_axi4l_awready(  ),
//  
// .m_axi4l_wdata(  ),
// .m_axi4l_wstrb(  ),
// .m_axi4l_wvalid(  ),
// .m_axi4l_wready(  ),
//  
// .m_axi4l_bresp(  ),
// .m_axi4l_bvalid(  ),
// .m_axi4l_bready(  ),
//  
// .m_axi4l_araddr(  ),
// .m_axi4l_arvalid(  ),
// .m_axi4l_arready(  ),
//  
// .m_axi4l_rresp(  ),
// .m_axi4l_rdata(  ),
// .m_axi4l_rvalid(  ),
// .m_axi4l_rready(  ),
//
//  // Global signals
// .axi_clk(  ),
// .axi_rstn(  )
//);
