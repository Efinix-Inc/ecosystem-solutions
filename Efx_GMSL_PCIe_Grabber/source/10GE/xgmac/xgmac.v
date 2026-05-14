`timescale 1 ns / 1 ns
module xgmac#(
    parameter                       VERSION = 32'h10,
    parameter                       RXFIFO_EN = 1,
    parameter                       RXFIFO_DTH = 2048,
    parameter                       TXFIFO_EN = 1,
    parameter                       TXFIFO_DTH = 2048,
    parameter                       AXIS_DW = 64
)
(
//Globle Signals
input                           mac_reset,//Globle Reset
input                           proto_reset,//Tx & Rx Reset
input                           tx_mac_aclk,//156.25M
//interrupt Signals
output  wire                    interrupt,      //    interrupt
//Receive AXI4-Stream Interface
input                           rx_axis_clk,
output  wire    [AXIS_DW-1:0]   rx_axis_mac_tdata,
output  wire                    rx_axis_mac_tvalid,
output  wire                    rx_axis_mac_tlast,
output  wire    [AXIS_DW/8-1:0] rx_axis_mac_tkeep,
output  wire                    rx_axis_mac_tuser,
input                           rx_axis_mac_tready,
//Transmit AXI4-Stream Interface
input                           tx_axis_clk,
input           [AXIS_DW-1:0]   tx_axis_mac_tdata,
input                           tx_axis_mac_tvalid,
input                           tx_axis_mac_tlast,
input           [AXIS_DW/8-1:0] tx_axis_mac_tkeep,
input                           tx_axis_mac_tuser,
output  wire                    tx_axis_mac_tready,
//XGMII Interface
input   wire    [63:0]          xgmii_rxd,
input   wire    [7:0]           xgmii_rxc,
input   wire                    xgmii_rx_clk,
output  wire    [63:0]          xgmii_txd,
output  wire    [7:0]           xgmii_txc,
output  wire                    xgmii_tx_clk,    
//APB3 Slave Interface
input   wire                    s_apb3_clk,
input   wire    [15:0]          s_apb3_paddr,
input   wire                    s_apb3_psel,
input   wire                    s_apb3_penable,
output  wire                    s_apb3_pready,
input   wire                    s_apb3_pwrite,//0:rd; 1:wr;
input   wire    [31:0]          s_apb3_pwdata,
output  wire    [31:0]          s_apb3_prdata,
output  wire                    s_apb3_pslverror         

);

// Parameter Define 
////`include "efx_eval.v"
localparam                      REG_WIDTH = 32;
// Register Define 

// Wire Define 
//Cfg Space Registers
//--Base Registers Field
wire                            tx_ena;
wire                            rx_ena;
wire                            xon_gen;
wire                            promis_en;
wire                            pad_en;
wire                            crc_fwd;
wire                            pause_ignore;
wire                            tx_addr_ins;
wire                            sw_reset;
wire                            loop_ena;
//wire    [2:0]                   eth_speed;
wire                            xoff_gen;
wire                            cnt_reset;
wire    [47:0]                  mac_addr;
wire    [15:0]                  frm_length;
wire    [15:0]                  pause_quant;
wire    [5:0]                   tx_ipg_length;
//Statistics Counters Field
wire                            tx_interupt;
wire                            tx_interupt_req;
wire                            rx_interupt;
wire                            rx_interupt_req;
wire    [REG_WIDTH-1:0]         aFramesTransmittedOK;
wire    [REG_WIDTH-1:0]         aFramesReceivedOK;
wire    [REG_WIDTH-1:0]         aFramesReceivedLen;
wire    [REG_WIDTH-1:0]         aFrameCheckSequenceErrors;
wire    [REG_WIDTH-1:0]         aTxPAUSEMACCtrlFrames;
wire    [REG_WIDTH-1:0]         aRxPAUSEMACCtrlFrames;
wire    [REG_WIDTH-1:0]         ifInErrors;
wire    [REG_WIDTH-1:0]         ifOutErrors;
wire    [REG_WIDTH-1:0]         aRxFilterFramesErrors;
wire    [REG_WIDTH-1:0]         etherStatsPkts;
wire    [REG_WIDTH-1:0]         etherStatsUndersizePkts;
wire    [REG_WIDTH-1:0]         etherStatsOversizePkts;
wire    [REG_WIDTH-1:0]         aRSReceivedLinkErrors;
wire    [REG_WIDTH-1:0]         aTxFifoOverflowFramesErrors;
wire    [REG_WIDTH-1:0]         aTxIncontinuityFramesErrors;
//--Receive Supplementary Registers Field
wire                            broadcast_filter_en;
wire    [47:0]                  mac_addr_mask;
//--Transmit Supplementary Registers Field
wire                            tx_dst_addr_ins;
wire    [47:0]                  dst_mac_addr;
//MDIO Signals
wire    [15:0]                  Prsd;
wire                            LinkFail;
wire                            Busy;
wire                            Nvalid;
wire                            RStatStart;
wire                            WCtrlDataStart;
wire                            WAddrStart;
wire                            UpdateMIIRX_DATAReg;
//Flow Control Signals
wire    [15:0]                  rx_pause_quant;
wire                            rx_pause_quant_en;
wire                            rx_pause_quant_en_resp;
//Rx Fifo Signals
wire    [63:0]                  ff_rx_data;
wire    [7:0]                   ff_rx_strb;
wire                            ff_rx_en;
wire                            ff_rx_err;
wire                            ff_rx_eop;
wire                            ff_rx_full;
//Tx Fifo Signals
wire    [63:0]                  ff_tx_data;
wire    [7:0]                   ff_tx_strb;
wire                            ff_tx_eop;
wire                            ff_tx_vld;
wire                            ff_tx_err;
wire                            ff_tx_rdy;
//Loop Fifo Signals
wire                            fifo_rst;
wire                            u1_wrreq;
wire                            u1_rdreq;
wire    [71:0]                  u1_data;
wire                            u1_empty;
wire    [71:0]                  u1_q;
//Gmii Signals
wire                            xgmii_err_w;
wire    [7:0]                   xgmii_rxc_w;
wire    [63:0]                  xgmii_rxd_w;
wire    [7:0]                   xgmii_txc_w;
wire    [63:0]                  xgmii_txd_w;
wire    [7:0]                   xgmii_rs_rxc_w;
wire    [63:0]                  xgmii_rs_rxd_w;
wire    [7:0]                   xgmii_rs_txc_w;
wire    [63:0]                  xgmii_rs_txd_w;
wire                            xgmii_rs_tx_err;
//Other Signals
wire                            txfifo_overflow_err;
wire                            tx_mac_aclk_en;
wire                            rx_mac_aclk_en;
//Globle Signals
wire                            rx_reset;
wire                            tx_reset;
wire                            rx_mac_reset;
wire                            tx_mac_reset;
wire                            s_apb3_reset;
wire                            rx_mac_aclk;
reg                             rx_mac_reset_1P;
reg                             rx_mac_reset_2P;
reg                             tx_mac_reset_1P;
reg                             tx_mac_reset_2P;
reg                             s_apb3_reset_1P;
reg                             s_apb3_reset_2P;

//assign rx_mac_aclk = xgmii_rx_clk;
assign xgmii_tx_clk = tx_mac_aclk;
assign tx_mac_aclk_en = 1'b1;
assign rx_mac_aclk_en = 1'b1;
/*----------------------------------------------------------------------------------*\
                                 The main code
\*----------------------------------------------------------------------------------*/
//Encryption begin
/*----------------------- Reset Region ---------------------------*/
assign rx_reset = (mac_reset == 1'b1) || (proto_reset == 1'b1) || (rx_ena == 1'b0);
assign tx_reset = (mac_reset == 1'b1) || (proto_reset == 1'b1) || (tx_ena == 1'b0);

/*----------------------- Clock Region ----------------------------*/
// ------- reset synchronizer for rx_mac_aclk -------
always @(posedge rx_mac_aclk or posedge rx_reset)
begin
    if (rx_reset) begin
        rx_mac_reset_1P    <= 1'b1;
        rx_mac_reset_2P    <= 1'b1;
    end
    else begin
        rx_mac_reset_1P    <= 1'b0;
        rx_mac_reset_2P    <= rx_mac_reset_1P;
    end
end
assign rx_mac_reset = rx_mac_reset_2P;

// ------- reset synchronizer for tx_mac_aclk -------
always @(posedge tx_mac_aclk or posedge tx_reset)
begin
    if (tx_reset) begin
        tx_mac_reset_1P    <= 1'b1;
        tx_mac_reset_2P    <= 1'b1;
    end
    else begin
        tx_mac_reset_1P    <= 1'b0;
        tx_mac_reset_2P    <= tx_mac_reset_1P;
    end
end
assign tx_mac_reset = tx_mac_reset_2P;

// ------- reset synchronizer for s_apb3_clk -------
always @(posedge s_apb3_clk or posedge mac_reset)
begin
    if (mac_reset) begin
        s_apb3_reset_1P    <= 1'b1;
        s_apb3_reset_2P    <= 1'b1;
    end
    else begin
        s_apb3_reset_1P    <= 1'b0;
        s_apb3_reset_2P    <= s_apb3_reset_1P;
    end
end
assign s_apb3_rstn = !s_apb3_reset_2P;
/*----------------------- LoopBack Region ----------------------------*/

assign xgmii_txc    = (loop_ena == 1'b1) ? 8'hff  : xgmii_rs_txc_w;
assign xgmii_txd    = (loop_ena == 1'b1) ? 64'h07070707_07070707 : xgmii_rs_txd_w;

assign xgmii_rs_rxc_w  = (loop_ena == 1'b1) ? xgmii_rs_txc_w  : xgmii_rxc;
assign xgmii_rs_rxd_w  = (loop_ena == 1'b1) ? xgmii_rs_txd_w  : xgmii_rxd;

assign rx_mac_aclk  = (loop_ena == 1'b1) ? tx_mac_aclk  : xgmii_rx_clk;
/*----------------------- Receive Region ----------------------------*/
rx_axi4_st#(
    .RXFIFO_EN                  (RXFIFO_EN                  ),
    .RXFIFO_DTH                 (RXFIFO_DTH                 ),
    .AXIS_DW                    (AXIS_DW                    )
)
u_rx_axi4_st
(
//Globle Signals
    .rx_clk                     (rx_mac_aclk                ),
    .rx_clk_en                  (rx_mac_aclk_en             ),
    .rx_rstn                    (!rx_mac_reset              ),
//Receive AXI4-Stream Interface
    .rx_axis_clk                (rx_axis_clk                ),
    .rx_axis_mac_tdata          (rx_axis_mac_tdata          ),
    .rx_axis_mac_tvalid         (rx_axis_mac_tvalid         ),
    .rx_axis_mac_tlast          (rx_axis_mac_tlast          ),
    .rx_axis_mac_tkeep          (rx_axis_mac_tkeep          ),
    .rx_axis_mac_tuser          (rx_axis_mac_tuser          ),
    .rx_axis_mac_tready         (rx_axis_mac_tready         ),
//Rx Fifo Interface
    .ff_rx_data                 (ff_rx_data                 ),
    .ff_rx_strb                 (ff_rx_strb                 ),
    .ff_rx_en                   (ff_rx_en                   ),
    .ff_rx_err                  (ff_rx_err                  ),
    .ff_rx_eop                  (ff_rx_eop                  ),
    .ff_rx_full                 (ff_rx_full                 )
);

rx_engine #(
	.REG_WIDTH                  (REG_WIDTH                  )          
)u_rx_engine
(
    .rx_clk                     (rx_mac_aclk                ),
    .rx_clk_en                  (rx_mac_aclk_en             ),
    .rx_rstn                    (!rx_mac_reset              ),
//Configuration Signals
    .crc_fwd                    (crc_fwd                    ),
    .promis_en                  (promis_en                  ),
    .pause_ignore               (pause_ignore               ),
    .cnt_reset                  (cnt_reset                  ),
    .frm_length                 (frm_length                 ),
    .broadcast_filter_en        (broadcast_filter_en        ),
    .mac_addr                   (mac_addr                   ),
    .mac_addr_mask              (mac_addr_mask              ),
//GMII Interface
    .xgmii_rxd                  (xgmii_rxd_w                ),
    .xgmii_rxc                  (xgmii_rxc_w                ),
    .xgmii_rx_err               (xgmii_err_w                ),
//Rx Fifo Interface
    .ff_rx_data                 (ff_rx_data                 ),
    .ff_rx_strb                 (ff_rx_strb                 ),
    .ff_rx_en                   (ff_rx_en                   ),
    .ff_rx_err                  (ff_rx_err                  ),
    .ff_rx_eop                  (ff_rx_eop                  ),
    .ff_rx_full                 (ff_rx_full                 ),
//Flow Control Signals
    .rx_pause_quant             (rx_pause_quant             ),
    .rx_pause_quant_en          (rx_pause_quant_en          ),
    .rx_pause_quant_en_resp     (rx_pause_quant_en_resp     ),
//Statistics Counters
    .rx_interupt_req            (rx_interupt_req            ),
    .rx_interupt                (rx_interupt                ),
    .aFramesReceivedLen         (aFramesReceivedLen         ),
    .aFramesReceivedOK          (aFramesReceivedOK          ),
    .aFrameCheckSequenceErrors  (aFrameCheckSequenceErrors  ),
    .aRxPAUSEMACCtrlFrames      (aRxPAUSEMACCtrlFrames      ),
    .ifInErrors                 (ifInErrors                 ),
    .etherStatsPkts             (etherStatsPkts             ),
    .etherStatsUndersizePkts    (etherStatsUndersizePkts    ),
    .etherStatsOversizePkts     (etherStatsOversizePkts     ),
    .aRSReceivedLinkErrors      (aRSReceivedLinkErrors      ),
    .aRxFilterFramesErrors      (aRxFilterFramesErrors      )
);

/*----------------------- Transmit Region ----------------------------*/
tx_axi4_st#(
    .TXFIFO_EN                  (TXFIFO_EN                  ),
    .TXFIFO_DTH                 (TXFIFO_DTH                 ),
    .AXIS_DW                    (AXIS_DW                    )
)
u_tx_axi4_st
(
//Globle Signals
    .tx_clk                     (tx_mac_aclk                ),
    .tx_clk_en                  (tx_mac_aclk_en             ),
    .tx_rstn                    (!tx_mac_reset              ),
//Configuration Signals
    .tx_addr_ins                (tx_addr_ins                ),
    .mac_addr                   (mac_addr                   ),
    .tx_dst_addr_ins            (tx_dst_addr_ins            ),
    .dst_mac_addr               (dst_mac_addr               ),
//Transmit AXI4-Stream Interface
    .tx_axis_clk                (tx_axis_clk                ),
    .tx_axis_mac_tdata          (tx_axis_mac_tdata          ),
    .tx_axis_mac_tvalid         (tx_axis_mac_tvalid         ),
    .tx_axis_mac_tlast          (tx_axis_mac_tlast          ),
    .tx_axis_mac_tkeep          (tx_axis_mac_tkeep          ),
    .tx_axis_mac_tuser          (tx_axis_mac_tuser          ),
    .tx_axis_mac_tready         (tx_axis_mac_tready         ),
//Tx Fifo Interface
    .ff_tx_data                 (ff_tx_data                 ),
    .ff_tx_strb                 (ff_tx_strb                 ),
    .ff_tx_sop                  (                           ),
    .ff_tx_eop                  (ff_tx_eop                  ),
    .ff_tx_vld                  (ff_tx_vld                  ),
    .ff_tx_err                  (ff_tx_err                  ),
    .ff_tx_rdy                  (ff_tx_rdy                  ),
    .txfifo_overflow_err        (txfifo_overflow_err        )
);

tx_engine #(
	.REG_WIDTH                  (REG_WIDTH                  )          
)u_tx_engine
(
//Globle Signals
    .tx_clk                     (tx_mac_aclk                ),
    .tx_clk_en                  (tx_mac_aclk_en             ),
    .tx_rstn                    (!tx_mac_reset              ),
//Configuration Signals
    .xon_gen                    (xon_gen                    ),
    .xoff_gen                   (xoff_gen                   ),
    .cnt_reset                  (cnt_reset                  ),
    .mac_addr                   (mac_addr                   ),
    .pause_quant                (pause_quant                ),
    .tx_ipg_length              (tx_ipg_length              ),
    .txfifo_overflow_err        (txfifo_overflow_err        ),
//GMII Interface
    .xgmii_txd                  (xgmii_txd_w                ),
    .xgmii_txc                  (xgmii_txc_w                ),
    .xgmii_tx_err               (xgmii_tx_err               ),
    .xgmii_rs_tx_err            (xgmii_rs_tx_err            ),
//Tx Fifo Interface
    .ff_tx_data                 (ff_tx_data                 ),
    .ff_tx_strb                 (ff_tx_strb                 ),
    .ff_tx_eop                  (ff_tx_eop                  ),
    .ff_tx_vld                  (ff_tx_vld                  ),
    .ff_tx_err                  (ff_tx_err                  ),
    .ff_tx_rdy                  (ff_tx_rdy                  ),
//Flow Control Signals
    .rx_pause_quant             (rx_pause_quant             ),
    .rx_pause_quant_en          (rx_pause_quant_en          ),
    .rx_pause_quant_en_resp     (rx_pause_quant_en_resp     ),    
//Statistics Counters
    .tx_interupt_req            (tx_interupt_req            ),
    .tx_interupt                (tx_interupt                ),
    .aFramesTransmittedOK       (aFramesTransmittedOK       ),
    .aTxPAUSEMACCtrlFrames      (aTxPAUSEMACCtrlFrames      ),
    .aTxFifoOverflowFramesErrors(aTxFifoOverflowFramesErrors),
    .aTxIncontinuityFramesErrors(aTxIncontinuityFramesErrors),
    .ifOutErrors                (ifOutErrors                )
);

xgmii_if_rs u_xgmii_if_rs
(
//Globle Signals
    .xgmii_tx_clk               (tx_mac_aclk                ),
    .xgmii_rx_clk               (rx_mac_aclk                ),
    .tx_rstn                    (!tx_mac_reset              ),
    .rx_rstn                    (!rx_mac_reset              ),
//GMII Interface
    .xgmii_rxd                  (xgmii_rs_rxd_w            ),
    .xgmii_rxc                  (xgmii_rs_rxc_w            ),
    .xgmii_txd                  (xgmii_rs_txd_w            ),
    .xgmii_txc                  (xgmii_rs_txc_w            ),
    
    .xgmii_rs_rxd               (xgmii_rxd_w                ),
    .xgmii_rs_rxc               (xgmii_rxc_w                ),
    .xgmii_rs_err               (xgmii_err_w                ),
    .xgmii_rs_txd               (xgmii_txd_w                ),
    .xgmii_rs_txc               (xgmii_txc_w                ),
    .xgmii_rs_tx_err            (xgmii_rs_tx_err            )
 );
 
/*----------------------- Configuration Management Region ----------------------------*/

apb3_reg#(
    .ADDR_WTH                   (10                         ),
    .REG_WIDTH                  (REG_WIDTH                  ),
    .VERSION                    (VERSION                    )
)
u_apb3_reg
(
//Globle Signals
    .s_apb3_clk                 (s_apb3_clk                 ),
    .s_apb3_rstn                (s_apb3_rstn                ),
//APB3 Slave Interface
    .s_apb3_paddr               (s_apb3_paddr               ),
    .s_apb3_psel                (s_apb3_psel                ),
    .s_apb3_penable             (s_apb3_penable             ),
    .s_apb3_pready              (s_apb3_pready              ),
    .s_apb3_pwrite              (s_apb3_pwrite              ),
    .s_apb3_pwdata              (s_apb3_pwdata              ),
    .s_apb3_prdata              (s_apb3_prdata              ),
    .s_apb3_pslverror           (s_apb3_pslverror           ),
    .interrupt                  (interrupt                  ),
//Cfg Space Registers
//--Base Configuration Registers Field
    .tx_ena                     (tx_ena                     ),
    .rx_ena                     (rx_ena                     ),
    .xon_gen                    (xon_gen                    ),
    .promis_en                  (promis_en                  ),
    .pad_en                     (pad_en                     ),
    .crc_fwd                    (crc_fwd                    ),
    .pause_ignore               (pause_ignore               ),
    .tx_addr_ins                (tx_addr_ins                ),
    .sw_reset                   (sw_reset                   ),
    .loop_ena                   (loop_ena                   ),
//    .eth_speed                  (eth_speed                  ),
    .xoff_gen                   (xoff_gen                   ),
    .cnt_reset                  (cnt_reset                  ),
    .mac_addr                   (mac_addr                   ),
    .frm_length                 (frm_length                 ),
    .pause_quant                (pause_quant                ),
    .tx_ipg_length              (tx_ipg_length              ),
//--Statistics Counters Field
    .rx_interupt                (rx_interupt                ),
    .rx_interupt_req            (rx_interupt_req            ),
    .tx_interupt                (tx_interupt                ),
    .tx_interupt_req            (tx_interupt_req            ),
    .aFramesReceivedLen         (aFramesReceivedLen         ),
    .aFramesTransmittedOK       (aFramesTransmittedOK       ),
    .aFramesReceivedOK          (aFramesReceivedOK          ),
    .aFrameCheckSequenceErrors  (aFrameCheckSequenceErrors  ),
    .aTxPAUSEMACCtrlFrames      (aTxPAUSEMACCtrlFrames      ),
    .aRxPAUSEMACCtrlFrames      (aRxPAUSEMACCtrlFrames      ),
    .ifInErrors                 (ifInErrors                 ),
    .ifOutErrors                (ifOutErrors                ),
    .aRSReceivedLinkErrors      (aRSReceivedLinkErrors      ),    
    .aRxFilterFramesErrors      (aRxFilterFramesErrors      ),
    .etherStatsPkts             (etherStatsPkts             ),
    .etherStatsUndersizePkts    (etherStatsUndersizePkts    ),
    .etherStatsOversizePkts     (etherStatsOversizePkts     ),
    .aTxFifoOverflowFramesErrors(aTxFifoOverflowFramesErrors),
    .aTxIncontinuityFramesErrors(aTxIncontinuityFramesErrors),
//--Receive Supplementary Registers Field
    .broadcast_filter_en        (broadcast_filter_en        ),
    .mac_addr_mask              (mac_addr_mask              ),
//--Transmit Supplementary Registers Field
    .tx_dst_addr_ins            (tx_dst_addr_ins            ),
    .dst_mac_addr               (dst_mac_addr               )
);
//Encryption end
endmodule















