
// synopsys translate_off
`timescale 1 ns / 1 ps                                                  
// synopsys translate_on

module top #(   //csi2 example design
    parameter NUM_DATA_LANE = 4,
    // Video parameters
    parameter HSA        = 5, 
    parameter HBP        = 5, 
    parameter HFP        = 1024,
    parameter HACT_CNT   = 1920,
    parameter VSA        = 1,
    parameter VBP        = 1,
    parameter VFP        = 2,
    parameter VACT_CNT   = 1080,   
    // efx_csi2_tx_top parameter:
    parameter HS_DATA_WIDTH          = 16,
    parameter tINIT_NS               = 400000,
    parameter tINIT_SKEWCAL_NS       = 100000,
    parameter HS_BYTECLK_MHZ         = 156,
    parameter DPHY_CLOCK_MODE        = "Continuous", //"Continuous", "Discontinuous"
    // parameter NUM_DATA_LANE          = 4,
    parameter PACK_TYPE              = 4'b1111,
    parameter PIXEL_FIFO_DEPTH       = 4096,
    parameter ENABLE_VCX             = 0,
    parameter FRAME_MODE             = "GENERIC",    //1-ACCURATE, 0-GENERIC
    parameter ENABLE_SKEWCAL_INIT    = 1,
    parameter ASYNC_STAGE            = 2,
    
    // csi2_hard_mipi_rx parameter:
    parameter CLOCK_FREQ_MHZ    = 100,
    parameter AREGISTER         = 8
)(
////////////////////////    CLOCK & PLL     ////////////////////////
input  logic        mipi_clk,   //100MHz
input  logic        pixel_clk,
input  logic        cfg_clk,    //100MHz
input  logic        esc_clk,    //20MHz

input  logic        i_pll1_locked,
input  logic        i_pll2_locked,  

////////////////////////    USER CONTROL    ///////////////////
output logic [4:0]  led,
input  logic        reset_n,  //sw5
input  logic        i_inject_err_n,

//mipi dphy rx
///---- MIPI blocks related clocks   ----///
input  logic        mipi_dphy_tx_inst1_SLOWCLK,      //MIPI HS byte clock from MIPI block 
///----MIPI blocks control signals   ----///
input  logic        mipi_dphy_tx_inst1_PLL_UNLOCK,
output logic        mipi_dphy_tx_inst1_RESET_N,
output logic        mipi_dphy_tx_inst1_PLL_SSC_EN, 
///----Clock Lane   ----///
input  logic        mipi_dphy_tx_inst1_STOPSTATE_CLK,
output logic        mipi_dphy_tx_inst1_TX_REQUEST_HS,
output logic        mipi_dphy_tx_inst1_TX_ULPS_CLK,
output logic        mipi_dphy_tx_inst1_TX_ULPS_EXIT,
input  logic        mipi_dphy_tx_inst1_TX_ULPS_ACTIVE_CLK_NOT,
///----Data Lane ULPS ----///
output logic        mipi_dphy_tx_inst1_TX_ULPS_ESC_LAN0,
output logic        mipi_dphy_tx_inst1_TX_ULPS_ESC_LAN1,
output logic        mipi_dphy_tx_inst1_TX_ULPS_ESC_LAN2,
output logic        mipi_dphy_tx_inst1_TX_ULPS_ESC_LAN3,
output logic        mipi_dphy_tx_inst1_TX_ULPS_EXIT_LAN0,
output logic        mipi_dphy_tx_inst1_TX_ULPS_EXIT_LAN1,
output logic        mipi_dphy_tx_inst1_TX_ULPS_EXIT_LAN2,
output logic        mipi_dphy_tx_inst1_TX_ULPS_EXIT_LAN3,
input  logic        mipi_dphy_tx_inst1_TX_ULPS_ACTIVE_NOT_LAN0,
input  logic        mipi_dphy_tx_inst1_TX_ULPS_ACTIVE_NOT_LAN1,
input  logic        mipi_dphy_tx_inst1_TX_ULPS_ACTIVE_NOT_LAN2,
input  logic        mipi_dphy_tx_inst1_TX_ULPS_ACTIVE_NOT_LAN3,
///----Data Lane LP mode   ----///
output logic        mipi_dphy_tx_inst1_TX_REQUEST_ESC_LAN0,
output logic        mipi_dphy_tx_inst1_TX_REQUEST_ESC_LAN1,
output logic        mipi_dphy_tx_inst1_TX_REQUEST_ESC_LAN2,
output logic        mipi_dphy_tx_inst1_TX_REQUEST_ESC_LAN3,
input  logic        mipi_dphy_tx_inst1_STOPSTATE_LAN0,
input  logic        mipi_dphy_tx_inst1_STOPSTATE_LAN1,
input  logic        mipi_dphy_tx_inst1_STOPSTATE_LAN2,
input  logic        mipi_dphy_tx_inst1_STOPSTATE_LAN3,
///----Data Lane HS mode   ----///
output logic        mipi_dphy_tx_inst1_TX_SKEW_CAL_HS_LAN0,
output logic        mipi_dphy_tx_inst1_TX_SKEW_CAL_HS_LAN1,
output logic        mipi_dphy_tx_inst1_TX_SKEW_CAL_HS_LAN2,
output logic        mipi_dphy_tx_inst1_TX_SKEW_CAL_HS_LAN3,
input  logic        mipi_dphy_tx_inst1_TX_READY_HS_LAN0,
input  logic        mipi_dphy_tx_inst1_TX_READY_HS_LAN1,
input  logic        mipi_dphy_tx_inst1_TX_READY_HS_LAN2,
input  logic        mipi_dphy_tx_inst1_TX_READY_HS_LAN3,
output logic        mipi_dphy_tx_inst1_TX_REQUEST_HS_LAN0,
output logic        mipi_dphy_tx_inst1_TX_REQUEST_HS_LAN1,
output logic        mipi_dphy_tx_inst1_TX_REQUEST_HS_LAN2,
output logic        mipi_dphy_tx_inst1_TX_REQUEST_HS_LAN3,
output logic [15:0] mipi_dphy_tx_inst1_TX_DATA_HS_LAN0,
output logic [15:0] mipi_dphy_tx_inst1_TX_DATA_HS_LAN1,
output logic [15:0] mipi_dphy_tx_inst1_TX_DATA_HS_LAN2,
output logic [15:0] mipi_dphy_tx_inst1_TX_DATA_HS_LAN3,
output logic        mipi_dphy_tx_inst1_TX_WORD_VALID_HS_LAN0,
output logic        mipi_dphy_tx_inst1_TX_WORD_VALID_HS_LAN1,
output logic        mipi_dphy_tx_inst1_TX_WORD_VALID_HS_LAN2,
output logic        mipi_dphy_tx_inst1_TX_WORD_VALID_HS_LAN3,
///---- Data Lane 0 Escape mode LPDT   ----///
output logic        mipi_dphy_tx_inst1_TX_VALID_ESC, 
output logic [7:0]  mipi_dphy_tx_inst1_TX_DATA_ESC,
output logic        mipi_dphy_tx_inst1_TX_LPDT_ESC,
input  logic        mipi_dphy_tx_inst1_TX_READY_ESC,
output logic [3:0]  mipi_dphy_tx_inst1_TX_TRIGGER_ESC,
    
//mipi dphy rx
input  logic        mipi_dphy_rx_inst2_SLOWCLK,
input  logic        mipi_dphy_rx_inst2_ERR_CONTENTION_LP0,
input  logic        mipi_dphy_rx_inst2_ERR_CONTENTION_LP1,
input  logic        mipi_dphy_rx_inst2_ERR_CONTROL_LAN0,
input  logic        mipi_dphy_rx_inst2_ERR_CONTROL_LAN1,
input  logic        mipi_dphy_rx_inst2_ERR_CONTROL_LAN2,
input  logic        mipi_dphy_rx_inst2_ERR_CONTROL_LAN3,
input  logic        mipi_dphy_rx_inst2_ERR_ESC_LAN0,
input  logic        mipi_dphy_rx_inst2_ERR_ESC_LAN1,
input  logic        mipi_dphy_rx_inst2_ERR_ESC_LAN2,
input  logic        mipi_dphy_rx_inst2_ERR_ESC_LAN3,
input  logic        mipi_dphy_rx_inst2_ERR_SOT_HS_LAN0,
input  logic        mipi_dphy_rx_inst2_ERR_SOT_HS_LAN1,
input  logic        mipi_dphy_rx_inst2_ERR_SOT_HS_LAN2,
input  logic        mipi_dphy_rx_inst2_ERR_SOT_HS_LAN3,
input  logic        mipi_dphy_rx_inst2_ERR_SOT_SYNC_HS_LAN0,
input  logic        mipi_dphy_rx_inst2_ERR_SOT_SYNC_HS_LAN1,
input  logic        mipi_dphy_rx_inst2_ERR_SOT_SYNC_HS_LAN2,
input  logic        mipi_dphy_rx_inst2_ERR_SOT_SYNC_HS_LAN3,
input  logic        mipi_dphy_rx_inst2_LP_CLK,
input  logic        mipi_dphy_rx_inst2_RX_ACTIVE_HS_LAN0,
input  logic        mipi_dphy_rx_inst2_RX_ACTIVE_HS_LAN1,
input  logic        mipi_dphy_rx_inst2_RX_ACTIVE_HS_LAN2,
input  logic        mipi_dphy_rx_inst2_RX_ACTIVE_HS_LAN3,
input  logic        mipi_dphy_rx_inst2_RX_CLK_ACTIVE_HS,
input  logic [7:0]  mipi_dphy_rx_inst2_RX_DATA_ESC,
input  logic [15:0] mipi_dphy_rx_inst2_RX_DATA_HS_LAN0,
input  logic [15:0] mipi_dphy_rx_inst2_RX_DATA_HS_LAN1,
input  logic [15:0] mipi_dphy_rx_inst2_RX_DATA_HS_LAN2,
input  logic [15:0] mipi_dphy_rx_inst2_RX_DATA_HS_LAN3,
input  logic        mipi_dphy_rx_inst2_RX_LPDT_ESC,
input  logic        mipi_dphy_rx_inst2_RX_SKEW_CAL_HS_LAN0,
input  logic        mipi_dphy_rx_inst2_RX_SKEW_CAL_HS_LAN1,
input  logic        mipi_dphy_rx_inst2_RX_SKEW_CAL_HS_LAN2,
input  logic        mipi_dphy_rx_inst2_RX_SKEW_CAL_HS_LAN3,
input  logic        mipi_dphy_rx_inst2_RX_SYNC_HS_LAN0,
input  logic        mipi_dphy_rx_inst2_RX_SYNC_HS_LAN1,
input  logic        mipi_dphy_rx_inst2_RX_SYNC_HS_LAN2,
input  logic        mipi_dphy_rx_inst2_RX_SYNC_HS_LAN3,
input  logic [3:0]  mipi_dphy_rx_inst2_RX_TRIGGER_ESC,
input  logic        mipi_dphy_rx_inst2_RX_ULPS_ACTIVE_CLK_NOT,
input  logic        mipi_dphy_rx_inst2_RX_ULPS_ACTIVE_NOT_LAN0,
input  logic        mipi_dphy_rx_inst2_RX_ULPS_ACTIVE_NOT_LAN1,
input  logic        mipi_dphy_rx_inst2_RX_ULPS_ACTIVE_NOT_LAN2,
input  logic        mipi_dphy_rx_inst2_RX_ULPS_ACTIVE_NOT_LAN3,
input  logic        mipi_dphy_rx_inst2_RX_ULPS_CLK_NOT,
input  logic        mipi_dphy_rx_inst2_RX_ULPS_ESC_LAN0,
input  logic        mipi_dphy_rx_inst2_RX_ULPS_ESC_LAN1,
input  logic        mipi_dphy_rx_inst2_RX_ULPS_ESC_LAN2,
input  logic        mipi_dphy_rx_inst2_RX_ULPS_ESC_LAN3,
input  logic        mipi_dphy_rx_inst2_RX_VALID_ESC,
input  logic        mipi_dphy_rx_inst2_RX_VALID_HS_LAN0,
input  logic        mipi_dphy_rx_inst2_RX_VALID_HS_LAN1,
input  logic        mipi_dphy_rx_inst2_RX_VALID_HS_LAN2,
input  logic        mipi_dphy_rx_inst2_RX_VALID_HS_LAN3,
input  logic        mipi_dphy_rx_inst2_STOPSTATE_CLK,
input  logic        mipi_dphy_rx_inst2_STOPSTATE_LAN0,
input  logic        mipi_dphy_rx_inst2_STOPSTATE_LAN1,
input  logic        mipi_dphy_rx_inst2_STOPSTATE_LAN2,
input  logic        mipi_dphy_rx_inst2_STOPSTATE_LAN3,
output logic        mipi_dphy_rx_inst2_FORCE_RX_MODE,
output logic        mipi_dphy_rx_inst2_RESET_N,
output logic        mipi_dphy_rx_inst2_RST0_N
);

logic rx_out_valid_1P, rx_out_hs_1P;
logic mipi_dphy_rx_reset_byte_HS_n, mipi_dphy_tx_reset_byte_HS_n, reset_esc_n;
logic [21:0] count_led;



logic        w_pll_locked;
logic        w_global_rstn;
logic        w_pixel_rstn;
logic [8:0]  w_frame_cnt;

logic        w_fb_clk_arstn;
logic        w_fb_clk_arst;
logic        w_dphy_byte_clk_arstn;
logic        w_dphy_byte_clk_arst;
logic        w_rx_byte_clk_arstn;
logic        w_rx_byte_clk_arst;

logic        w_vsync;
logic        w_hsync;
logic        w_valid;
logic [9:0] w_out_x;
logic [9:0] w_out_y;


// Mapping to CSI RX
logic           w_rx_vsync;
logic           w_rx_hsync;
logic [1:0]     w_rx_vc;
logic [15:0]    w_rx_word_count;
logic [63:0]    w_rx_pixel_data;
logic           w_rx_pixel_data_valid;
logic [5:0]     w_rx_datatype;

logic w_hsync_match;
logic w_vsync_match;
logic w_pdata_match;
logic w_vdata_match;

////////////////////////////////////////////////////////////////
//==============================================================
assign mipi_dphy_rx_inst2_FORCE_RX_MODE = 1'b1;
assign mipi_dphy_rx_inst2_RESET_N = reset_n;
assign mipi_dphy_rx_inst2_RST0_N = reset_n;

// tie-off unused DPHY TX ports:

assign mipi_dphy_tx_inst1_TX_VALID_ESC      = 'h0; 
assign mipi_dphy_tx_inst1_TX_DATA_ESC       = 'h0;
assign mipi_dphy_tx_inst1_TX_LPDT_ESC       = 'h0;
assign mipi_dphy_tx_inst1_TX_TRIGGER_ESC    = 'h0;

////////////////////////////////////////////////////////////////

// output indicator assignment

assign led[0] = w_frame_cnt[5];
assign led[1] = w_hsync_match;
assign led[2] = w_vsync_match;
assign led[3] = w_pdata_match;
assign led[4] = w_vdata_match;

assign w_pll_locked  = i_pll1_locked & i_pll2_locked;

// reset handling.. 
reset_ctrl #(
    .NUM_RST       (4),
    .CYCLE         (4),
    .IN_RST_ACTIVE (4'b0000),
    .OUT_RST_ACTIVE(4'b0000)
) inst_reset_ctrl (
    .i_arst({4{w_global_rstn}}),
    .i_clk({
        cfg_clk,
        mipi_dphy_tx_inst1_SLOWCLK,
        mipi_dphy_tx_inst1_SLOWCLK,
        esc_clk
    }),
    .o_srst({
        cfg_clk_reset_n,
        mipi_dphy_rx_reset_byte_HS_n,
        mipi_dphy_tx_reset_byte_HS_n,
        reset_esc_n
    })
);


wire [63:0] w_data_mask;
wire [5:0]  video_format;

////////// testcase specific /////////////////////////////////////////////
localparam PixelPerClock = 3'd2;
assign video_format  = 6'h24; ///RGB888
assign w_data_mask   = { {16{1'h0}},{48{1'h1}} }; // RGB888: pack type 48.

//////////////////////////////////////////////////////////////////////////

// logic to handle the init+skewcal timing of dphy (100us+400us).
//localparam tINIT_NS = 500000;
localparam INIT_CLK_MHZ = HS_BYTECLK_MHZ;
localparam integer INIT_CLK_NS = 1000/(INIT_CLK_MHZ);
localparam integer INIT_CYCLE = ((tINIT_NS + tINIT_SKEWCAL_NS) / INIT_CLK_NS); //min=500us for init+skew.

logic [31:0] w_init_cnt;
logic w_init_done;

always @ (posedge mipi_dphy_tx_inst1_SLOWCLK or negedge mipi_dphy_tx_reset_byte_HS_n) begin
    if (~mipi_dphy_tx_reset_byte_HS_n) begin
        w_init_cnt    <= 'd0;
    end
    else if (w_init_cnt < INIT_CYCLE) begin
        w_init_cnt    <= w_init_cnt + 'd1;
    end
end

assign w_init_done = (w_init_cnt == INIT_CYCLE);

csichk #(
    .MAX_HRES       (HACT_CNT       ),
    .MAX_VRES       (VACT_CNT       ),
    .HSP            (HSA            ),
    .HBP            (HBP            ),
    .HFP            (HFP            ),
    .VSP            (VSA            ),
    .VBP            (VBP            ),
    .VFP            (VFP            ),
    .PixelPerClock  (PixelPerClock  ),
    .FRAME_MODE     (FRAME_MODE     )
) csichk_inst (
    .i_arstn        (reset_n        ),
    .pll_locked     (w_pll_locked   ),
    .o_pixel_rstn   (w_pixel_rstn   ),
    .o_global_rstn  (w_global_rstn  ),
    
    .i_fb_clk       (mipi_clk       ),
    .i_sysclk       (pixel_clk      ),
    
    .o_vsync        (w_vsync        ),
    .o_hsync        (w_hsync        ),
    .o_valid        (w_valid        ),
    .o_out_x        (w_out_x        ),
    .o_out_y        (w_out_y        ),
    .i_data_mask    (w_data_mask    ),

    .i_inject_err1_n(i_inject_err_n ),
    .i_inject_err2_n(1'b1           ),
    .o_hsync_match  (w_hsync_match  ),
    .o_vsync_match  (w_vsync_match  ),
    .o_pdata_match  (w_pdata_match  ),
    .o_vdata_match  (w_vdata_match  ),
    .o_frame_cnt    (w_frame_cnt    ),
    
    .i_vsync        (w_rx_vsync           ),
    .i_hsync        (w_rx_hsync           ),                 
    .i_valid        (w_rx_pixel_data_valid),                 
    .i_pdata        (w_rx_pixel_data      ), 

    .i_init_done    (w_init_done    )
);

logic   [5:0]   r_tx_axi_araddr_1P;
logic           r_tx_axi_arvalid_1P;
logic           w_tx_axi_arready;
logic   [31:0]  w_tx_axi_rdata;
logic           w_tx_axi_rvalid;
logic           r_tx_axi_rready_1P;


// Mapping to DPHY TX ///////////////////////////////////////////////
logic TxUlpsClk;
logic TxUlpsExitClk;
logic [NUM_DATA_LANE-1:0] TxUlpsEsc;
logic [NUM_DATA_LANE-1:0] TxUlpsExit;
logic [NUM_DATA_LANE-1:0] TxRequestEsc;
logic [NUM_DATA_LANE-1:0] TxSkewCalHS;
logic [NUM_DATA_LANE-1:0] TxRequestHS;
logic TxRequestHSc;
logic [15:0] TxDataHS0;
logic [15:0] TxDataHS1;
logic [15:0] TxDataHS2;
logic [15:0] TxDataHS3;
logic [1:0] TxReqValidHS0, TxReqValidHS1, TxReqValidHS2, TxReqValidHS3;
logic TxUlpsActiveClkNot;
logic [NUM_DATA_LANE-1:0] TxStopStateD;
logic TxStopStateC;
logic [NUM_DATA_LANE-1:0] TxUlpsActiveNot;
logic [NUM_DATA_LANE-1:0] TxReadyHS;

assign mipi_dphy_tx_inst1_RESET_N = reset_n;
assign mipi_dphy_tx_inst1_TX_ULPS_CLK = TxUlpsClk;
assign mipi_dphy_tx_inst1_TX_ULPS_EXIT = TxUlpsExitClk;
assign TxUlpsActiveClkNot = mipi_dphy_tx_inst1_TX_ULPS_ACTIVE_CLK_NOT;
assign mipi_dphy_tx_inst1_TX_ULPS_ESC_LAN0 = TxUlpsEsc[0];
assign mipi_dphy_tx_inst1_TX_ULPS_ESC_LAN1 = TxUlpsEsc[1];
assign mipi_dphy_tx_inst1_TX_ULPS_ESC_LAN2 = TxUlpsEsc[2];
assign mipi_dphy_tx_inst1_TX_ULPS_ESC_LAN3 = TxUlpsEsc[3];
assign mipi_dphy_tx_inst1_TX_ULPS_EXIT_LAN0 = TxUlpsExit[0];
assign mipi_dphy_tx_inst1_TX_ULPS_EXIT_LAN1 = TxUlpsExit[1];
assign mipi_dphy_tx_inst1_TX_ULPS_EXIT_LAN2 = TxUlpsExit[2];
assign mipi_dphy_tx_inst1_TX_ULPS_EXIT_LAN3 = TxUlpsExit[3];
assign mipi_dphy_tx_inst1_TX_REQUEST_ESC_LAN0 = TxRequestEsc[0];
assign mipi_dphy_tx_inst1_TX_REQUEST_ESC_LAN1 = TxRequestEsc[1];
assign mipi_dphy_tx_inst1_TX_REQUEST_ESC_LAN2 = TxRequestEsc[2];
assign mipi_dphy_tx_inst1_TX_REQUEST_ESC_LAN3 = TxRequestEsc[3];
assign mipi_dphy_tx_inst1_TX_SKEW_CAL_HS_LAN0 = TxSkewCalHS[0];
assign mipi_dphy_tx_inst1_TX_SKEW_CAL_HS_LAN1 = TxSkewCalHS[1];
assign mipi_dphy_tx_inst1_TX_SKEW_CAL_HS_LAN2 = TxSkewCalHS[2];
assign mipi_dphy_tx_inst1_TX_SKEW_CAL_HS_LAN3 = TxSkewCalHS[3];
assign TxStopStateD[0] = mipi_dphy_tx_inst1_STOPSTATE_LAN0;
assign TxStopStateD[1] = mipi_dphy_tx_inst1_STOPSTATE_LAN1;
assign TxStopStateD[2] = mipi_dphy_tx_inst1_STOPSTATE_LAN2;
assign TxStopStateD[3] = mipi_dphy_tx_inst1_STOPSTATE_LAN3;
assign TxStopStateC = mipi_dphy_tx_inst1_STOPSTATE_CLK;
assign TxUlpsActiveNot[0] = mipi_dphy_tx_inst1_TX_ULPS_ACTIVE_NOT_LAN0;
assign TxUlpsActiveNot[1] = mipi_dphy_tx_inst1_TX_ULPS_ACTIVE_NOT_LAN1;
assign TxUlpsActiveNot[2] = mipi_dphy_tx_inst1_TX_ULPS_ACTIVE_NOT_LAN2;
assign TxUlpsActiveNot[3] = mipi_dphy_tx_inst1_TX_ULPS_ACTIVE_NOT_LAN3;
assign TxReadyHS[0] = mipi_dphy_tx_inst1_TX_READY_HS_LAN0;
assign TxReadyHS[1] = mipi_dphy_tx_inst1_TX_READY_HS_LAN1;
assign TxReadyHS[2] = mipi_dphy_tx_inst1_TX_READY_HS_LAN2;
assign TxReadyHS[3] = mipi_dphy_tx_inst1_TX_READY_HS_LAN3;
assign mipi_dphy_tx_inst1_TX_REQUEST_HS = TxRequestHSc;
assign mipi_dphy_tx_inst1_TX_DATA_HS_LAN0 = TxDataHS0;
assign mipi_dphy_tx_inst1_TX_DATA_HS_LAN1 = TxDataHS1;
assign mipi_dphy_tx_inst1_TX_DATA_HS_LAN2 = TxDataHS2;
assign mipi_dphy_tx_inst1_TX_DATA_HS_LAN3 = TxDataHS3;
assign mipi_dphy_tx_inst1_TX_REQUEST_HS_LAN0 = TxRequestHS[0];
assign mipi_dphy_tx_inst1_TX_REQUEST_HS_LAN1 = TxRequestHS[1];
assign mipi_dphy_tx_inst1_TX_REQUEST_HS_LAN2 = TxRequestHS[2];
assign mipi_dphy_tx_inst1_TX_REQUEST_HS_LAN3 = TxRequestHS[3];
assign mipi_dphy_tx_inst1_TX_WORD_VALID_HS_LAN0 = TxReqValidHS0[1];
assign mipi_dphy_tx_inst1_TX_WORD_VALID_HS_LAN1 = TxReqValidHS1[1];
assign mipi_dphy_tx_inst1_TX_WORD_VALID_HS_LAN2 = TxReqValidHS2[1];
assign mipi_dphy_tx_inst1_TX_WORD_VALID_HS_LAN3 = TxReqValidHS3[1];

// efx_csi2_tx_top # (
//     .HS_DATA_WIDTH       (HS_DATA_WIDTH      ),
//     .tINIT_NS            (tINIT_NS           ),
//     .tINIT_SKEWCAL_NS    (tINIT_SKEWCAL_NS   ),
//     .HS_BYTECLK_MHZ      (HS_BYTECLK_MHZ     ),
//     .DPHY_CLOCK_MODE     (DPHY_CLOCK_MODE    ),
//     .NUM_DATA_LANE       (NUM_DATA_LANE      ),
//     .PACK_TYPE           (PACK_TYPE          ),
//     .PIXEL_FIFO_DEPTH    (PIXEL_FIFO_DEPTH   ),
//     .ENABLE_VCX          (ENABLE_VCX         ),
//     .FRAME_MODE          (FRAME_MODE         ),
//     .ENABLE_SKEWCAL_INIT (ENABLE_SKEWCAL_INIT),
//     .ASYNC_STAGE         (ASYNC_STAGE        )
// ) inst_csi2_tx_top
efx_csi2_tx_top inst_csi2_tx_top
(
    .reset_byte_HS_n    (mipi_dphy_tx_reset_byte_HS_n),
    .clk_byte_HS        (mipi_dphy_tx_inst1_SLOWCLK),
    .reset_pixel_n      (w_pixel_rstn),
    .clk_pixel          (pixel_clk),
    .reset_esc_n        (reset_esc_n),
    .clk_esc            (esc_clk),

    //PPI Interface
    .TxUlpsClk          (TxUlpsClk),
    .TxUlpsExitClk      (TxUlpsExitClk),
    .TxUlpsActiveClkNot (TxUlpsActiveClkNot),
    .TxUlpsEsc          (TxUlpsEsc),
    .TxUlpsExit         (TxUlpsExit),
    .TxRequestEsc       (TxRequestEsc),
    .TxSkewCalHS        (TxSkewCalHS),
    .TxStopStateD       (TxStopStateD),
    .TxStopStateC       (TxStopStateC),
    .TxUlpsActiveNot    (TxUlpsActiveNot),
    .TxReadyHS          (TxReadyHS),
    .TxRequestHS        (TxRequestHS),
    .TxRequestHSc       (TxRequestHSc),
    .TxDataHS0          (TxDataHS0),
    .TxDataHS1          (TxDataHS1),
    .TxDataHS2          (TxDataHS2),
    .TxDataHS3          (TxDataHS3),
    .TxDataHS4          (),
    .TxDataHS5          (),
    .TxDataHS6          (),
    .TxDataHS7          (),
    .TxReqValidHS0      (TxReqValidHS0),
    .TxReqValidHS1      (TxReqValidHS1),
    .TxReqValidHS2      (TxReqValidHS2),
    .TxReqValidHS3      (TxReqValidHS3),
    .TxReqValidHS4      (),
    .TxReqValidHS5      (),
    .TxReqValidHS6      (),
    .TxReqValidHS7      (),

    //AXI4-Lite Interface
    .axi_clk            (mipi_clk), 
    .axi_reset_n        (w_global_rstn),
    .axi_awaddr         (6'b0),//Write Address. byte address.
    .axi_awvalid        (1'b1),//Write address valid.
    .axi_awready        (),//Write address ready.
    .axi_wdata          (32'b0),//Write data bus.
    .axi_wvalid         (1'b0),//Write valid.
    .axi_wready         (),//Write ready.
    .axi_bvalid         (),//Write response valid.
    .axi_bready         (1'b0),//Response ready.      
    .axi_araddr         ('h0),//Read address. byte address.
    .axi_arvalid        ('h0),//Read address valid.
    .axi_arready        (w_tx_axi_arready),//Read address ready.
    .axi_rdata          (w_tx_axi_rdata),//Read data.
    .axi_rvalid         (w_tx_axi_rvalid),//Read valid.
    .axi_rready         (1'b1),//Read ready.
    
    .hsync_vc0          (w_hsync),
    .hsync_vc1          (1'b0),
    .hsync_vc2          (1'b0),
    .hsync_vc3          (1'b0),
    .hsync_vc4          (1'b0),
    .hsync_vc5          (1'b0),
    .hsync_vc6          (1'b0),
    .hsync_vc7          (1'b0),
    .hsync_vc8          (1'b0),
    .hsync_vc9          (1'b0),
    .hsync_vc10         (1'b0),
    .hsync_vc11         (1'b0),
    .hsync_vc12         (1'b0),
    .hsync_vc13         (1'b0),
    .hsync_vc14         (1'b0),
    .hsync_vc15         (1'b0),
    .vsync_vc0          (w_vsync),
    .vsync_vc1          (1'b0),
    .vsync_vc2          (1'b0),
    .vsync_vc3          (1'b0),
    .vsync_vc4          (1'b0),
    .vsync_vc5          (1'b0),
    .vsync_vc6          (1'b0),
    .vsync_vc7          (1'b0),
    .vsync_vc8          (1'b0),
    .vsync_vc9          (1'b0),
    .vsync_vc10         (1'b0),
    .vsync_vc11         (1'b0),
    .vsync_vc12         (1'b0),
    .vsync_vc13         (1'b0),
    .vsync_vc14         (1'b0),
    .vsync_vc15         (1'b0),

    .datatype           (video_format   ),
    .pixel_data         ({w_out_y[1:0],w_out_x[1:0],{3{w_out_y,w_out_x}}}),
    .pixel_data_valid   (w_valid        ),
    .haddr              (HACT_CNT       ),
    .line_num           ('h0            ),
    .frame_num          ('h0            ),  
    .irq                (               )
);


// Mapping to DPHY RX ///////////////////////////////////////////////
logic rx_out_hs, rx_out_vs;

logic   [5:0]   r_rx_axi_araddr_1P;
logic           r_rx_axi_arvalid_1P;
logic           w_rx_axi_arready;
logic   [31:0]  w_rx_axi_rdata;
logic           w_rx_axi_rvalid;
logic           r_rx_axi_rready_1P;

// Mapping to DPHY RX IF
logic RxUlpsClkNot;
logic [NUM_DATA_LANE-1:0]   RxErrEsc;
logic [NUM_DATA_LANE-1:0]   RxErrControl;
logic [NUM_DATA_LANE-1:0]   RxErrSotSyncHS;
logic [NUM_DATA_LANE-1:0]   RxClkEsc;
logic [NUM_DATA_LANE-1:0]   RxUlpsEsc;
logic [NUM_DATA_LANE-1:0]   RxUlpsActiveNot;
logic [NUM_DATA_LANE-1:0]   RxSkewCalHS;
logic [NUM_DATA_LANE-1:0]   RxStopState;
logic [NUM_DATA_LANE-1:0]   RxValidHS;
logic [NUM_DATA_LANE-1:0]   RxSyncHS;
logic [NUM_DATA_LANE-1:0][15:0] RxDataHS;

assign RxUlpsClkNot = mipi_dphy_rx_inst2_RX_ULPS_CLK_NOT;
assign RxUlpsActiveClkNot = mipi_dphy_rx_inst2_RX_ULPS_ACTIVE_CLK_NOT;
assign RxErrEsc[0] = mipi_dphy_rx_inst2_ERR_ESC_LAN0;
assign RxErrEsc[1] = mipi_dphy_rx_inst2_ERR_ESC_LAN1;
assign RxErrEsc[2] = mipi_dphy_rx_inst2_ERR_ESC_LAN2;
assign RxErrEsc[3] = mipi_dphy_rx_inst2_ERR_ESC_LAN3;
assign RxErrControl[0] = mipi_dphy_rx_inst2_ERR_CONTROL_LAN0;
assign RxErrControl[1] = mipi_dphy_rx_inst2_ERR_CONTROL_LAN1;
assign RxErrControl[2] = mipi_dphy_rx_inst2_ERR_CONTROL_LAN2;
assign RxErrControl[3] = mipi_dphy_rx_inst2_ERR_CONTROL_LAN3;
assign RxErrSotSyncHS[0] = mipi_dphy_rx_inst2_ERR_SOT_SYNC_HS_LAN0;
assign RxErrSotSyncHS[1] = mipi_dphy_rx_inst2_ERR_SOT_SYNC_HS_LAN1;
assign RxErrSotSyncHS[2] = mipi_dphy_rx_inst2_ERR_SOT_SYNC_HS_LAN2;
assign RxErrSotSyncHS[3] = mipi_dphy_rx_inst2_ERR_SOT_SYNC_HS_LAN3;
assign RxUlpsEsc[0] = mipi_dphy_rx_inst2_RX_ULPS_ESC_LAN0;
assign RxUlpsEsc[1] = mipi_dphy_rx_inst2_RX_ULPS_ESC_LAN1;
assign RxUlpsEsc[2] = mipi_dphy_rx_inst2_RX_ULPS_ESC_LAN2;
assign RxUlpsEsc[3] = mipi_dphy_rx_inst2_RX_ULPS_ESC_LAN3;
assign RxClkEsc[0] = 1'b0;
assign RxClkEsc[1] = 1'b0;
assign RxClkEsc[2] = 1'b0;
assign RxClkEsc[3] = 1'b0;
assign RxUlpsActiveNot[0] = mipi_dphy_rx_inst2_RX_ULPS_ACTIVE_NOT_LAN0;
assign RxUlpsActiveNot[1] = mipi_dphy_rx_inst2_RX_ULPS_ACTIVE_NOT_LAN1;
assign RxUlpsActiveNot[2] = mipi_dphy_rx_inst2_RX_ULPS_ACTIVE_NOT_LAN2;
assign RxUlpsActiveNot[3] = mipi_dphy_rx_inst2_RX_ULPS_ACTIVE_NOT_LAN3;
assign RxSkewCalHS[0] = mipi_dphy_rx_inst2_RX_SKEW_CAL_HS_LAN0;
assign RxSkewCalHS[1] = mipi_dphy_rx_inst2_RX_SKEW_CAL_HS_LAN1;
assign RxSkewCalHS[2] = mipi_dphy_rx_inst2_RX_SKEW_CAL_HS_LAN2;
assign RxSkewCalHS[3] = mipi_dphy_rx_inst2_RX_SKEW_CAL_HS_LAN3;
assign RxStopState[0] = mipi_dphy_rx_inst2_STOPSTATE_LAN0;
assign RxStopState[1] = mipi_dphy_rx_inst2_STOPSTATE_LAN1;
assign RxStopState[2] = mipi_dphy_rx_inst2_STOPSTATE_LAN2;
assign RxStopState[3] = mipi_dphy_rx_inst2_STOPSTATE_LAN3;
assign RxValidHS[0] = mipi_dphy_rx_inst2_RX_VALID_HS_LAN0;
assign RxValidHS[1] = mipi_dphy_rx_inst2_RX_VALID_HS_LAN1;
assign RxValidHS[2] = mipi_dphy_rx_inst2_RX_VALID_HS_LAN2;
assign RxValidHS[3] = mipi_dphy_rx_inst2_RX_VALID_HS_LAN3;
assign RxSyncHS[0] = mipi_dphy_rx_inst2_RX_SYNC_HS_LAN0;
assign RxSyncHS[1] = mipi_dphy_rx_inst2_RX_SYNC_HS_LAN1;
assign RxSyncHS[2] = mipi_dphy_rx_inst2_RX_SYNC_HS_LAN2;
assign RxSyncHS[3] = mipi_dphy_rx_inst2_RX_SYNC_HS_LAN3;
assign RxDataHS[0] = mipi_dphy_rx_inst2_RX_DATA_HS_LAN0;
assign RxDataHS[1] = mipi_dphy_rx_inst2_RX_DATA_HS_LAN1;
assign RxDataHS[2] = mipi_dphy_rx_inst2_RX_DATA_HS_LAN2;
assign RxDataHS[3] = mipi_dphy_rx_inst2_RX_DATA_HS_LAN3;

//csi2_hard_mipi_rx #(
//    .HS_DATA_WIDTH    (HS_DATA_WIDTH   ),
//    .tINIT_NS         (tINIT_NS        ),
//    .CLOCK_FREQ_MHZ   (CLOCK_FREQ_MHZ  ),
//    .NUM_DATA_LANE    (NUM_DATA_LANE   ),
//    .PACK_TYPE        (PACK_TYPE       ),
//    .AREGISTER        (AREGISTER       ),
//    .ENABLE_VCX       (ENABLE_VCX      ),
//    .FRAME_MODE       (FRAME_MODE      ),
//    .ASYNC_STAGE      (ASYNC_STAGE     ),
//    .PIXEL_FIFO_DEPTH (PIXEL_FIFO_DEPTH)
//) inst_csi2_rx_top
csi2_hard_mipi_rx inst_csi2_rx_top
(
    .reset_n                (w_global_rstn),
    .clk                    (mipi_clk),
    .reset_byte_HS_n        (mipi_dphy_rx_reset_byte_HS_n),
    .clk_byte_HS            (mipi_dphy_rx_inst2_SLOWCLK),
    .reset_pixel_n          (w_pixel_rstn),
    .clk_pixel              (pixel_clk),

    // PPI Interface
    .RxClkEsc               (RxClkEsc),
    .RxUlpsClkNot           (RxUlpsClkNot),
    .RxUlpsActiveClkNot     (RxUlpsActiveClkNot),
    .RxErrEsc               (RxErrEsc),
    .RxErrControl           (RxErrControl),
    .RxErrSotSyncHS         (RxErrSotSyncHS),
    .RxUlpsEsc              (RxUlpsEsc),
    .RxUlpsActiveNot        (RxUlpsActiveNot),
    .RxSkewCalHS            (RxSkewCalHS),
    .RxStopState            (RxStopState),
    .RxSyncHS               (RxSyncHS),
    .RxDataHS0              (RxDataHS[0]),
    .RxDataHS1              (RxDataHS[1]),
    .RxDataHS2              (RxDataHS[2]),
    .RxDataHS3              (RxDataHS[3]),
    .RxDataHS4              (),
    .RxDataHS5              (),
    .RxDataHS6              (),
    .RxDataHS7              (),
    .RxValidHS0             ({RxValidHS[0], RxValidHS[0]}),
    .RxValidHS1             ({RxValidHS[1], RxValidHS[1]}),
    .RxValidHS2             ({RxValidHS[2], RxValidHS[2]}),
    .RxValidHS3             ({RxValidHS[3], RxValidHS[3]}),
    .RxValidHS4             (),
    .RxValidHS5             (),
    .RxValidHS6             (),
    .RxValidHS7             (),
    
    //AXI4-Lite Interface
    .axi_clk                (mipi_clk               ),
    .axi_reset_n            (w_global_rstn          ),
    .axi_awaddr             (6'b0                   ),//Write Address. byte address.
    .axi_awvalid            (1'b0                   ),//Write address valid.
    .axi_awready            (                       ),//Write address ready.
    .axi_wdata              (32'b0                  ),//Write data bus.
    .axi_wvalid             (1'b0                   ),//Write valid.
    .axi_wready             (                       ),//Write ready.           
    .axi_bvalid             (                       ),//Write response valid.
    .axi_bready             (1'b0                   ),//Response ready.      
    .axi_araddr             (r_rx_axi_araddr_1P     ),//Read address. byte address.
    .axi_arvalid            (r_rx_axi_arvalid_1P    ),//Read address valid.
    .axi_arready            (w_rx_axi_arready       ),//Read address ready.
    .axi_rdata              (w_rx_axi_rdata         ),//Read data.
    .axi_rvalid             (w_rx_axi_rvalid        ),//Read valid.
    .axi_rready             (1'b1                   ),//Read ready.

    .hsync_vc0              (w_rx_hsync             ),
    .hsync_vc1              (                       ),
    .hsync_vc2              (                       ),
    .hsync_vc3              (                       ),
    .hsync_vc4              (                       ),
    .hsync_vc5              (                       ),
    .hsync_vc6              (                       ),
    .hsync_vc7              (                       ),
    .hsync_vc8              (                       ),
    .hsync_vc9              (                       ),
    .hsync_vc10             (                       ),
    .hsync_vc11             (                       ),
    .hsync_vc12             (                       ),
    .hsync_vc13             (                       ),
    .hsync_vc14             (                       ),
    .hsync_vc15             (                       ),
    .vsync_vc0              (w_rx_vsync             ),
    .vsync_vc1              (                       ),
    .vsync_vc2              (                       ),
    .vsync_vc3              (                       ),
    .vsync_vc4              (                       ),
    .vsync_vc5              (                       ),
    .vsync_vc6              (                       ),
    .vsync_vc7              (                       ),
    .vsync_vc8              (                       ),
    .vsync_vc9              (                       ),
    .vsync_vc10             (                       ),
    .vsync_vc11             (                       ),
    .vsync_vc12             (                       ),
    .vsync_vc13             (                       ),
    .vsync_vc14             (                       ),
    .vsync_vc15             (                       ),

    .vc                     (w_rx_vc                ),
    .vcx                    (                       ),
    .word_count             (w_rx_word_count        ),
    .shortpkt_data_field    (                       ),
    .datatype               (w_rx_datatype          ),
    .pixel_per_clk          (                       ),
    .pixel_data             (w_rx_pixel_data        ),
    .pixel_data_valid       (w_rx_pixel_data_valid  ),
    .irq                    (                       )
);

endmodule
