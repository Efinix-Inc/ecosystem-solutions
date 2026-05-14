`timescale 1 ns / 1 ns
module tx_engine#(
	parameter                       REG_WIDTH = 32
)
(
//Globle Signals
input                           tx_clk,
input                           tx_clk_en,
input                           tx_rstn,
//Configuration Signals
input                           xon_gen,
input                           xoff_gen,
input                           cnt_reset,
input           [47:0]          mac_addr,
input           [15:0]          pause_quant,
input           [5:0]           tx_ipg_length,
input                           txfifo_overflow_err,
//GMII Interface
output  wire    [63:0]          xgmii_txd,
output  wire    [7:0]           xgmii_txc,
output  wire                    xgmii_tx_err,
input   wire                    xgmii_rs_tx_err,
//Tx Fifo Interface
input           [63:0]          ff_tx_data,
input           [7:0]           ff_tx_strb,
input                           ff_tx_eop,
input                           ff_tx_vld,
input                           ff_tx_err,
output  wire                    ff_tx_rdy,
//Flow Control Signals
input           [15:0]          rx_pause_quant,
input                           rx_pause_quant_en,
output                          rx_pause_quant_en_resp,
//Statistics Counters
input                           tx_interupt_req,
output  wire                    tx_interupt,
output  wire    [REG_WIDTH-1:0] aFramesTransmittedOK,
output  wire    [REG_WIDTH-1:0] aTxPAUSEMACCtrlFrames,
output  wire    [REG_WIDTH-1:0] aTxFifoOverflowFramesErrors,
output  wire    [REG_WIDTH-1:0] aTxIncontinuityFramesErrors,
output  wire    [REG_WIDTH-1:0] ifOutErrors
//Status and  Error Signals
);


// Parameter Define 

// Register Define 

// Wire Define 
wire                            crc_init;
wire    [63:0]                  crc_data;
wire    [7:0]                   crc_data_strb;
wire                            crc_data_en;
wire                            crc_eop;
wire                            crc_rd;
wire    [31:0]                  crc_out;

wire    [63:0]                  Frame_data_o;
wire    [7:0]                   Frame_strb_o;
wire                            Frame_en_o;
/*----------------------------------------------------------------------------------*\
                                 The main code
\*----------------------------------------------------------------------------------*/
//Encryption begin
tx_ctr u_tx_ctr
(
//Globle Signals
    .tx_clk                     (tx_clk                     ),
    .tx_clk_en                  (tx_clk_en                  ),
    .tx_rstn                    (tx_rstn                    ),
//Configuration Signals
    .xon_gen                    (xon_gen                    ),
    .xoff_gen                   (xoff_gen                   ),
    .cnt_reset                  (cnt_reset                  ),
    .mac_addr                   (mac_addr                   ),
    .pause_quant                (pause_quant                ),
    .tx_ipg_length              (tx_ipg_length              ),
    .txfifo_overflow_err        (txfifo_overflow_err        ),
//GMII Interface
    .xgmii_txd                  (xgmii_txd                  ),
    .xgmii_txc                  (xgmii_txc                  ),
    .xgmii_tx_err               (xgmii_tx_err               ),
    .xgmii_rs_tx_err            (xgmii_rs_tx_err            ),
//Tx Fifo Interface
    .ff_tx_data                 (ff_tx_data                 ),
    .ff_tx_strb                 (ff_tx_strb                 ),
    .ff_tx_eop                  (ff_tx_eop                  ),
    .ff_tx_vld                  (ff_tx_vld                  ),
    .ff_tx_err                  (ff_tx_err                  ),
    .ff_tx_rdy                  (ff_tx_rdy                  ),
//CRC Check Signals
    .crc_init                   (crc_init                   ),
    .crc_data                   (crc_data                   ),
    .crc_data_strb              (crc_data_strb              ),
    .crc_data_en                (crc_data_en                ),
    .crc_eop                    (crc_eop                    ),
    .Frame_en_o                 (Frame_en_o                 ),
    .Frame_data_o               (Frame_data_o               ),
    .Frame_strb_o               (Frame_strb_o               ),     
//    .crc_rd                     (crc_rd                     ),
//    .crc_out                    (crc_out                    ),
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

CRC_gen U_CRC_gen(
    .Clk                        (tx_clk                     ),
    .Clk_en                     (tx_clk_en                  ),
    .Reset                      (!tx_rstn                   ),
    .Init                       (crc_init                   ),
    .Frame_data                 (crc_data                   ),
    .Data_strb                  (crc_data_strb              ),
    .Data_en                    (crc_data_en                ),
    .Data_eop                   (crc_eop                    ),
    .CRC_rd                     (crc_rd                     ),
    .Frame_en_o                 (Frame_en_o                 ),
    .Frame_data_o               (Frame_data_o               ),
    .Frame_strb_o               (Frame_strb_o               )   
//    .CRC_out                    (crc_out                    ),
//    .CRC_end                    (                           )
);

//Encryption end
endmodule
