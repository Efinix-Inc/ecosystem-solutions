module apb3_async#(
parameter DATA_WIDTH = 32,      // Data bus width (default 32-bit)
parameter ADDR_WIDTH = 32,      // Address bus width (default 32-bit)
parameter FIFO_DEPTH = 8        // FIFO depth (default 8 entries)
)
(
// ========== Source APB3 Interface ==========
input                           s_apb3_pclk,
input                           s_apb3_presetn,
input                           s_apb3_psel,
input                           s_apb3_penable,
input                           s_apb3_pwrite,
input      [ADDR_WIDTH-1:0]     s_apb3_paddr,
input      [DATA_WIDTH-1:0]     s_apb3_pwdata,
input      [(DATA_WIDTH/8)-1:0] s_apb3_pstrb,
output wire                     s_apb3_pready,
output reg                      s_apb3_pslverr,
output reg [DATA_WIDTH-1:0]     s_apb3_prdata,

// ========== Destination APB3 Interface ==========
input                           m_apb3_pclk,
input                           m_apb3_presetn,
output reg                      m_apb3_psel,
output reg                      m_apb3_penable,
output wire                     m_apb3_pwrite,
output wire [ADDR_WIDTH-1:0]    m_apb3_paddr,
output wire [DATA_WIDTH-1:0]    m_apb3_pwdata,
output wire [(DATA_WIDTH/8)-1:0]m_apb3_pstrb,
input                           m_apb3_pready,
input                           m_apb3_pslverr,
input      [DATA_WIDTH-1:0]     m_apb3_prdata
);
//Parameter Define
parameter REQ_IDLE     = 3'd00;
parameter REQ_READ     = 3'd01;
parameter REQ_WRITE    = 3'd02;
parameter REQ_WAIT     = 3'd03;
localparam REQ_FIFO_WIDTH  = 1 + (DATA_WIDTH/8) + ADDR_WIDTH + DATA_WIDTH;
localparam RESP_FIFO_WIDTH = 1 + DATA_WIDTH;
//Register Define
reg   s_pready_temp;
reg [2:0] req_state;

reg m_apb3_pready_1dly;
reg m_apb3_psel_1dly;

//Wire Define
// Response control signals
wire                          resp_fifo_full;
wire                          resp_fifo_empty;
wire                          resp_rd_en;
wire                          resp_wr_en;
wire [RESP_FIFO_WIDTH-1:0]    resp_fifo_din;
wire [RESP_FIFO_WIDTH-1:0]    resp_fifo_dout;
// Request FIFO signals
wire                          req_fifo_full;
wire                          req_fifo_empty;
wire [REQ_FIFO_WIDTH-1:0]     req_fifo_din;
wire                          req_fifo_wr_en;
wire                          req_fifo_rd_en;
wire [REQ_FIFO_WIDTH-1:0]     req_fifo_dout;

wire                          m_apb3_psel_pos;
//Encryption begin
/*--------------------------------------------------------------*\
                       The main code
\*--------------------------------------------------------------*/
// Request FIFO connections
assign req_fifo_din   = {s_apb3_pwrite, s_apb3_pstrb, s_apb3_paddr, s_apb3_pwdata};
assign req_fifo_wr_en = (req_state == REQ_IDLE) && (s_apb3_psel == 1'b1) && (s_apb3_penable == 1'b0);
assign req_fifo_rd_en = (m_apb3_pready == 1'b1);

always @(posedge s_apb3_pclk) 
begin
    if (s_apb3_presetn == 1'b0) 
        s_pready_temp <= 1'b0;
    else if((req_state == REQ_WRITE) && (req_fifo_full == 1'b0))
        s_pready_temp <= 1'b1;
    else if(resp_rd_en == 1'b1)
        s_pready_temp <= 1'b1;
    else
        s_pready_temp <= 1'b0;
end

assign s_apb3_pready = (s_pready_temp == 1'b1) && (req_state != REQ_IDLE);
// Request FSM (Source clock domain)
always @(posedge s_apb3_pclk) 
begin
    if (s_apb3_presetn == 1'b0) 
        req_state <= REQ_IDLE;
    else 
    begin
        case (req_state)
            REQ_IDLE: 
            begin
                if ((s_apb3_psel == 1'b1) && (s_apb3_penable == 1'b0) && (s_apb3_pwrite == 1'b1)) 
                    req_state <= REQ_WRITE;
                else if ((s_apb3_psel == 1'b1) && (s_apb3_penable == 1'b0) && (s_apb3_pwrite == 1'b0)) 
                    req_state <= REQ_READ;
            end
            REQ_WRITE: 
            begin
                if (s_pready_temp) 
                    req_state <= REQ_IDLE;
            end
            REQ_READ: 
            begin
                if (resp_rd_en) 
                    req_state <= REQ_WAIT;
            end
            REQ_WAIT: 
            begin
                if (s_pready_temp) 
                    req_state <= REQ_IDLE;
            end            
            default: req_state <= REQ_IDLE;
            
        endcase
    end
end

/*---------------------------- read Data Region ---------------------------*/

efx_fifo_asyn_a69d128                   u1_apb_rdata_async_fifo
(
    .a_wr_rst_i                         (!s_apb3_presetn                    ),
    .a_rd_rst_i                         (!m_apb3_presetn                    ),
    .full_o                             (req_fifo_full                      ),
    .empty_o                            (req_fifo_empty                     ),
    .wr_clk_i                           (s_apb3_pclk                        ),
    .rd_clk_i                           (m_apb3_pclk                        ),
    .wr_en_i                            (req_fifo_wr_en                     ),
    .rd_en_i                            (req_fifo_rd_en                     ), 
    .wdata                              (req_fifo_din                       ),   
    .rdata                              (req_fifo_dout                      ),
    .wr_datacount_o                     (                                   ),
    .rd_datacount_o                     (                                   ),
    .rst_busy                           (                                   )
);

assign m_apb3_pwrite = req_fifo_empty ? {{1'd0}}               : req_fifo_dout[REQ_FIFO_WIDTH-1];
assign m_apb3_pstrb  = req_fifo_empty ? {(DATA_WIDTH/8){1'd0}} : req_fifo_dout[DATA_WIDTH+ADDR_WIDTH+:DATA_WIDTH/8];
assign m_apb3_paddr  = req_fifo_empty ? {ADDR_WIDTH{1'd0}}     : req_fifo_dout[DATA_WIDTH+:ADDR_WIDTH];
assign m_apb3_pwdata = req_fifo_empty ? {DATA_WIDTH{1'd0}}     : req_fifo_dout[0+:DATA_WIDTH];

always @(posedge m_apb3_pclk) 
begin
    if (m_apb3_presetn == 1'b0) 
        m_apb3_psel <= 1'b0;
    else if(m_apb3_pready == 1'b1)
        m_apb3_psel <= 1'b0;            
    else if(req_fifo_empty == 1'b0)
        m_apb3_psel <= 1'b1;
end

always @(posedge m_apb3_pclk) 
begin
    if (m_apb3_presetn == 1'b0) 
    begin
        m_apb3_pready_1dly <= 1'b0;
        m_apb3_psel_1dly   <= 1'b0;
    end
    else 
    begin
        m_apb3_pready_1dly <= m_apb3_pready;
        m_apb3_psel_1dly   <= m_apb3_psel;
    end 
end

assign m_apb3_psel_pos = (m_apb3_psel_1dly == 1'b0) && (m_apb3_psel == 1'b1);

always @(posedge m_apb3_pclk) 
begin
    if (m_apb3_presetn == 1'b0) 
        m_apb3_penable <= 1'b0;
    else if(m_apb3_pready == 1'b1)
        m_apb3_penable <= 1'b0;
    else if(m_apb3_psel_pos == 1'b1)
        m_apb3_penable <= 1'b1;
end

// =============================================
// Response Path (Destination -> Source)
// =============================================

// Response FIFO connections
assign resp_fifo_din = {m_apb3_pslverr, m_apb3_prdata};
assign resp_wr_en    = m_apb3_psel && m_apb3_penable && m_apb3_pready && !m_apb3_pwrite && !resp_fifo_full;
/*---------------------------- Write Data Region ---------------------------*/
//Write Data Asynchronous FIFO

efx_fifo_asyn_a33d128                   u2_apb_wdata_async_fifo
(
    .a_wr_rst_i                         (!m_apb3_presetn                    ),
    .a_rd_rst_i                         (!s_apb3_presetn                    ),
    .full_o                             (resp_fifo_full                     ),
    .empty_o                            (resp_fifo_empty                    ),
    .wr_clk_i                           (m_apb3_pclk                        ),
    .rd_clk_i                           (s_apb3_pclk                        ),
    .wr_en_i                            (resp_wr_en                         ),
    .rd_en_i                            (resp_rd_en                         ), 
    .wdata                              (resp_fifo_din                      ), 
    .rdata                              (resp_fifo_dout                     ),
    .wr_datacount_o                     (                                   ),
    .rd_datacount_o                     (                                   ),
    .rst_busy                           (                                   )
);

// Response read control (Source clock domain)

assign resp_rd_en = (req_state == REQ_READ) && (resp_fifo_empty == 1'b0);

// Source interface outputs
always @(posedge s_apb3_pclk)
begin
    if (s_apb3_presetn == 1'b0)   
        {s_apb3_pslverr, s_apb3_prdata} <= {RESP_FIFO_WIDTH{1'b0}};
    else if(resp_rd_en == 1'b1)
        {s_apb3_pslverr, s_apb3_prdata} <= resp_fifo_dout;
end

//Encryption end
endmodule
