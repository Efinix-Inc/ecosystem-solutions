`timescale 1 ns / 1 ns
module rx_engine#(
	parameter                       REG_WIDTH = 32
)
(
//Globle Signals
input                           rx_clk,
input                           rx_clk_en,
input                           rx_rstn,
//Configuration Signals
input                           crc_fwd,
input                           promis_en,
input                           pause_ignore,
input                           cnt_reset,
input           [15:0]          frm_length,
input                           broadcast_filter_en,
input           [47:0]          mac_addr,
input           [47:0]          mac_addr_mask,
//GMII Interface
input           [63:0]          xgmii_rxd,
input           [7:0]           xgmii_rxc,
input                           xgmii_rx_err,
//Rx Fifo Interface
output  wire    [63:0]          ff_rx_data,
output  wire    [7:0]           ff_rx_strb,
output  wire                    ff_rx_en,
output  wire                    ff_rx_err,
output  wire                    ff_rx_eop,
input                           ff_rx_full,
//Flow Control Signals
output  wire    [15:0]          rx_pause_quant,
output  wire                    rx_pause_quant_en,
input                           rx_pause_quant_en_resp,
//Statistics Counters
input                           rx_interupt_req,
output  wire                    rx_interupt,
output  wire    [REG_WIDTH-1:0] aFramesReceivedOK,
output  wire    [REG_WIDTH-1:0] aFramesReceivedLen,
output  wire    [REG_WIDTH-1:0] aFrameCheckSequenceErrors,
output  wire    [REG_WIDTH-1:0] aRxPAUSEMACCtrlFrames,
output  wire    [REG_WIDTH-1:0] ifInErrors,
output  wire    [REG_WIDTH-1:0] etherStatsPkts,
output  wire    [REG_WIDTH-1:0] etherStatsUndersizePkts,
output  wire    [REG_WIDTH-1:0] etherStatsOversizePkts,
output  wire    [REG_WIDTH-1:0] aRSReceivedLinkErrors,
output  wire    [REG_WIDTH-1:0] aRxFilterFramesErrors
);
// Parameter Define 

// Register Define 

// Wire Define
wire                            crc_init;
wire    [63:0]                  crc_data;
wire    [7:0]                   crc_data_strb;
wire                            crc_data_en;
wire                            crc_eop;
wire                            crc_err;
wire                            crc_err_en;
wire    [47:0]                  dst_addr;
wire                            dst_addr_en;
wire                            filter_frame_drop;
wire    [63:0]                  Frame_data_o;
wire    [7:0]                   Frame_strb_o;
wire                            Frame_en_o;
wire                            Frame_eop_o;
/*----------------------------------------------------------------------------------*\
                                 The main code
\*----------------------------------------------------------------------------------*/
//Encryption begin
rx_ctr u_rx_ctr
(
//Globle Signals
    .rx_clk                     (rx_clk                     ),
    .rx_clk_en                  (rx_clk_en                  ),
    .rx_rstn                    (rx_rstn                    ),
//Configuration Signals
    .pause_ignore               (pause_ignore               ),
    .cnt_reset                  (cnt_reset                  ),
    .frm_length                 (frm_length                 ),
//GMII Interface
    .xgmii_rxd                  (xgmii_rxd                  ),
    .xgmii_rxc                  (xgmii_rxc                  ),
    .xgmii_rx_err               (xgmii_rx_err               ),
//Rx Fifo Interface
    .ff_rx_data                 (ff_rx_data                 ),
    .ff_rx_strb                 (ff_rx_strb                 ),
    .ff_rx_en                   (ff_rx_en                   ),
    .ff_rx_err                  (ff_rx_err                  ),
    .ff_rx_eop                  (ff_rx_eop                  ),
    .ff_rx_full                 (ff_rx_full                 ),
//CRC Check Signals
    .crc_init                   (crc_init                   ),
    .crc_data                   (crc_data                   ),
    .crc_data_strb              (crc_data_strb              ),
    .crc_data_en                (crc_data_en                ),
    .crc_eop                    (crc_eop                    ),
    .Frame_en_o                 (Frame_en_o                 ),
    .Frame_data_o               (Frame_data_o               ),
    .Frame_strb_o               (Frame_strb_o               ), 
    .Frame_eop_o                (Frame_eop_o                ), 
    .crc_err                    (crc_err                    ),
    .crc_err_en                 (crc_err_en                 ),
//Frame Filter Signals
    .dst_addr                   (dst_addr                   ),
    .dst_addr_en                (dst_addr_en                ),
    .filter_frame_drop          (filter_frame_drop          ),
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

frame_filter u_frame_filter
(
//Globle Signals
    .rx_clk                     (rx_clk                     ),
    .rx_clk_en                  (rx_clk_en                  ),
    .rx_rstn                    (rx_rstn                    ),
//Configuration Signals
    .promis_en                  (promis_en                  ),
    .broadcast_filter_en        (broadcast_filter_en        ),
    .mac_addr                   (mac_addr                   ),
    .mac_addr_mask              (mac_addr_mask              ),
//Filter Ctr Interface
    .dst_addr_en                (dst_addr_en                ),
    .dst_addr                   (dst_addr                   ),
    .filter_frame_drop          (filter_frame_drop          )
);

CRC_chk u_CRC_chk(
    .Clk                        (rx_clk                     ),
    .Clk_en                     (rx_clk_en                  ),
    .Reset                      (!rx_rstn                   ),
    .crc_fwd                    (crc_fwd                    ),
    .Init                       (crc_init                   ),
    .Frame_data                 (crc_data                   ),
    .Data_strb                  (crc_data_strb              ),
    .Data_en                    (crc_data_en                ),
    .Data_eop                   (crc_eop                    ),

    .Frame_en_o                 (Frame_en_o                 ),
    .Frame_data_o               (Frame_data_o               ),
    .Frame_strb_o               (Frame_strb_o               ),    
    .Frame_eop_o                (Frame_eop_o                ),    

    .CRC_err                    (crc_err                    ),
    .CRC_err_en                 (crc_err_en                 )
);   
//Encryption end
endmodule
