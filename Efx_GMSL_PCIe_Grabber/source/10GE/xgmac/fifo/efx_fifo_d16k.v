

module efx_fifo_d16k# (
    parameter DEPTH              = 512,           // Reverted (Equivalent to WDATA_DEPTH) 
    parameter DATA_WIDTH         = 32,            // Reverted (Equivalent to WDATA_WIDTH)
    parameter ASYM_WIDTH_RATIO   = 4,
    parameter RDATA_WIDTH        = rdwidthcompute(ASYM_WIDTH_RATIO,DATA_WIDTH),
    parameter RD_DEPTH           = rddepthcompute(DEPTH,DATA_WIDTH,RDATA_WIDTH),
    parameter RADDR_WIDTH        = depth2width(RD_DEPTH)
)(
    input  wire                   a_rst_i,
    input  wire                   wr_clk_i,
    input  wire                   rd_clk_i,
    input  wire                   wr_en_i,
    input  wire                   rd_en_i,
    input  wire [DATA_WIDTH-1:0]  wdata,
    output wire                   almost_full_o,
//    output reg                    prog_full_o,
    output wire                   full_o,
    output wire                   empty_o,
    output wire                   rd_valid_o,
    output wire [RDATA_WIDTH-1:0] rdata

); 
// Parameter Define 

localparam FIFO_NUM          = (DEPTH<4096) ? 1 : DEPTH/4096;
localparam FIFO_NUM_WIDTH    = depth2width(FIFO_NUM);
localparam FIFO_DTH          = (DEPTH<4096) ? DEPTH : 4096;
localparam FIFO_WADDR_WIDTH  = depth2width(FIFO_DTH);
localparam FIFO_RADDR_WIDTH  = (DEPTH<4096) ? RADDR_WIDTH : 
                                              depth2width(rddrwidthcompute(ASYM_WIDTH_RATIO,FIFO_DTH));
// Register Define 
reg     [FIFO_WADDR_WIDTH-1:0]  wr_addr;
reg     [FIFO_RADDR_WIDTH-1:0]  rd_addr;
reg     [FIFO_NUM_WIDTH-1:0]    wr_sel;
reg     [FIFO_NUM_WIDTH-1:0]    rd_sel;
reg     [FIFO_NUM_WIDTH-1:0]    rd_sel_d1;
reg                             u2_wren;
// Wire Define
wire    [FIFO_NUM-1:0]          u1_wren;
wire    [FIFO_NUM-1:0]          u1_rden;
wire    [FIFO_NUM-1:0]          u1_empty;
wire    [FIFO_NUM-1:0]          u1_almfull;
wire    [FIFO_NUM-1:0]          u1_full;
wire    [RDATA_WIDTH-1:0]       u1_q[FIFO_NUM-1:0];
reg     [RDATA_WIDTH-1:0]       u2_data;
wire                            u2_almfull;
/*----------------------- FIFO 1 Region ----------------------------*/
//Encryption begin
`pragma protect begin_protected
`pragma protect version=1
`pragma protect encrypt_agent="ipecrypt"
`pragma protect encrypt_agent_info="http://ipencrypter.com Version: 20.0.8"
`pragma protect author="author-a"
`pragma protect author_info="author-a-details"

`pragma protect key_keyowner="Efinix Inc."
`pragma protect key_keyname="EFX_K01"
`pragma protect key_method="rsa"
`pragma protect encoding=(enctype="base64", line_length=64, bytes=256)
`pragma protect key_block
gr/Rw/owx+lTFyg3kY/b4/N7kUUsBGzFA/iVlqFlESrqW6+sJET7Y14SDpJlXlSm
lJ3NN6aP6NT4J4EmKboII99pJEnQb50vbnAmbhQe5QbIgtB9duH9dpEZhxqm4CXZ
5hkSmE0AtQg1ZWz52F2V2RMsd/Y7TcJk8er5sP2zlDRGtDYSLRzaI3alNOZG5zgs
wc9Y7qAeQDYiixZD/qIC2uPmbAx1Ci5ou3W6DHQzMj7pk2w5w20dNlyw60lMak08
5Dv49jTBTLOgGOMaibC+cLgZgtDKHlWcOPh7oDd1pIMwPb+Dyp2KoQPhQl1H8doP
KHiyu2f6w2owkPg9hDc1Qw==
`pragma protect key_keyowner="Mentor Graphics Corporation"
`pragma protect key_keyname="MGC-VERIF-SIM-RSA-1"
`pragma protect key_method="rsa"
`pragma protect encoding=(enctype="base64", line_length=64, bytes=128)
`pragma protect key_block
MdCd9tHdexnhzSE2D9ijd0xSq7mY8YsJZpyZsac+8nSIV1Y02lHnKLIn9NGvQyr4
7McEME3w84tnH3mSlmdNUXAjvP49vb8ExbKbf3KISwD9xh1QHzbXDnzVgxU0h1db
kf1yPT5GuQ01Za9v3jpLOsWoGs5Z/gQWBqf3WQnh2k0=
`pragma protect data_method="aes256-cbc"
`pragma protect encoding=(enctype="base64", line_length=64, bytes=7120)
`pragma protect data_block
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
46ZoL2H7jhaBhRhtNPeTBA==
`pragma protect end_protected
endmodule
