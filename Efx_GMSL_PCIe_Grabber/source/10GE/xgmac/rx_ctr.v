`timescale 1 ns / 1 ns
module rx_ctr #(
	parameter                       REG_WIDTH = 32
)
(
//Globle Signals
input                           rx_clk,
input                           rx_clk_en,
input                           rx_rstn,
//Configuration Signals
input                           pause_ignore,
input                           cnt_reset,
input           [15:0]          frm_length,
//GMII Interface
input           [63:0]          xgmii_rxd,
input           [7:0]           xgmii_rxc,
input                           xgmii_rx_err,
//Rx Fifo Interface
output  reg     [63:0]          ff_rx_data,
output  reg     [7:0]           ff_rx_strb,
output  reg                     ff_rx_en,
output  wire                    ff_rx_err,
output  reg                     ff_rx_eop,
input                           ff_rx_full,
//CRC Check Signals
output  reg                     crc_init,
output  wire    [63:0]          crc_data,
output  reg     [7:0]           crc_data_strb,
output  reg                     crc_data_en,
output  wire                    crc_eop,
input   wire                    Frame_en_o     ,
input   wire    [63:0]          Frame_data_o   ,
input   wire    [7:0]           Frame_strb_o   ,
input                           Frame_eop_o,
input                           crc_err,
input                           crc_err_en,
//Frame Filter Signals
output  wire    [47:0]          dst_addr,
output  reg                     dst_addr_en,
input                           filter_frame_drop,
//Flow Control Signals
output  reg     [15:0]          rx_pause_quant,
output  reg                     rx_pause_quant_en,
input                           rx_pause_quant_en_resp,
//Statistics Counters
input                           rx_interupt_req,
output  reg                     rx_interupt,
output  reg     [REG_WIDTH-1:0] aFramesReceivedOK,
output  reg     [REG_WIDTH-1:0] aFramesReceivedLen,
output  reg     [REG_WIDTH-1:0] aFrameCheckSequenceErrors,
output  reg     [REG_WIDTH-1:0] aRxPAUSEMACCtrlFrames,
output  reg     [REG_WIDTH-1:0] ifInErrors,
output  reg     [REG_WIDTH-1:0] etherStatsPkts,
output  reg     [REG_WIDTH-1:0] etherStatsUndersizePkts,
output  reg     [REG_WIDTH-1:0] etherStatsOversizePkts,
output  reg     [REG_WIDTH-1:0] aRSReceivedLinkErrors,
output  reg     [REG_WIDTH-1:0] aRxFilterFramesErrors
//Status and  Error Signals
);
// Parameter Define 
localparam State_idle     = 3'd0;
localparam State_data     = 3'd1;
localparam State_checkCRC = 3'd2;
localparam State_OkEnd    = 3'd3;
localparam State_ErrEnd   = 3'd4;

localparam Pause_idle      = 2'd0;
localparam Pause_pre_syn   = 2'd1;
localparam Pause_quanta    = 2'd2;
localparam Pause_syn       = 2'd3;

localparam PREAMBLE       = 64'hd5555555_55555555;
localparam PAUSE_ADDR     = 48'h010000c28001;//48'h0180c2000001;
localparam PAUSE_TYPE     = 32'h01000888;    //32'h01000888;

// Register Define 
reg                             rx_dv_r;
reg                             rx_dv_r2;
reg                             rx_err_r;
reg     [63:0]                  rx_d_r;
reg     [63:0]                  rx_d_r2;
reg     [7:0]                   rxc_r;
reg     [7:0]                   rxc_r2;
reg     [7:0]                   crc_eop_r;
reg     [2:0]                   cur_state;
reg     [2:0]                   next_state;
reg     [15:0]                  frm_len_cnt;
reg     [2:0]                   fc_cur_state;
reg     [2:0]                   fc_next_state;
reg                             rx_pause_quant_en_resp_dl1;
reg                             rx_pause_quant_en_resp_dl2;
reg                             cnt_reset_dl1;
reg                             cnt_reset_dl2;
reg                             aFramesReceivedOK_en;
reg                             aFrameCheckSequenceErrors_en;
reg                             aRxPAUSEMACCtrlFrames_en;
reg                             ifInErrors_en;
reg                             etherStatsUndersizePkts_en;
reg                             etherStatsOversizePkts_en;
reg                             aRxFilterFramesErrors_en;
reg                             rx_interupt_en;
reg                             rx_interupt_req_d1;
reg                             rx_interupt_req_d2;
reg                             rx_interupt_req_d3;
// Wire Define
wire                            too_short;
wire                            too_long;

/*----------------------------------------------------------------------------------*\
                                 The main code
\*----------------------------------------------------------------------------------*/
//Encryption begin
always @(posedge rx_clk or negedge rx_rstn)
begin
    if(rx_rstn == 1'b0)
        begin
            rx_dv_r  <= 1'h0;
            rx_dv_r2 <= 1'h0;
            rx_d_r   <= 64'h0;
            rx_d_r2  <= 64'h0;
            rxc_r    <= 8'h0;
        end
    else if(rx_clk_en == 1'b0)
        begin
            rx_dv_r  <= rx_dv_r;
            rx_dv_r2 <= rx_dv_r2;
            rx_d_r   <= rx_d_r;
            rx_d_r2  <= rx_d_r2;
            rxc_r    <= rxc_r;          
        end
    else
        begin
            rx_dv_r  <= |xgmii_rxc;
            rx_dv_r2 <= rx_dv_r;
            rx_d_r   <= xgmii_rxd;
            rx_d_r2  <= rx_d_r;
            rxc_r    <= xgmii_rxc;          
        end
end

/*----------------------- CRC Check Region ----------------------------*/
assign crc_data = rx_d_r2;

always @(posedge rx_clk or negedge rx_rstn)
begin
    if(rx_rstn == 1'b0)
        crc_init <= 1'b0;
    else if(rx_clk_en == 1'b0)
        crc_init <= crc_init;
    else if((rx_dv_r == 1'b1) && (rx_d_r == PREAMBLE))
        crc_init <= 1'b1;
    else
        crc_init <= 1'b0;
end

always @(posedge rx_clk or negedge rx_rstn)
begin
    if(rx_rstn == 1'b0)
        crc_data_en <= 1'b0;
    else if(rx_clk_en == 1'b0)
        crc_data_en <= crc_data_en;
    else
        crc_data_en <= rx_dv_r;
end

//assign crc_eop = ((rx_dv_r2 == 1'b1)&& (rx_dv_r == 1'b0));
generate 
genvar i;
for(i=0;i<8;i=i+1) begin
always @(posedge rx_clk or negedge rx_rstn)
begin
    if(rx_rstn == 1'b0)
        crc_eop_r[i] <= 1'b0;
    else if(rx_clk_en == 1'b0)
        crc_eop_r[i] <= crc_eop_r[i] ;
    else if(rxc_r[i] == 1'b0 && rx_d_r[i*8+:8] == 8'hfd)
        crc_eop_r[i]  <= 1'b1;
    else
        crc_eop_r[i] <= 1'b0;
end
end
endgenerate

assign crc_eop = |crc_eop_r;

always @(posedge rx_clk or negedge rx_rstn)
begin
    if(rx_rstn == 1'b0)
        crc_data_strb <= 8'b0;
    else if(rx_clk_en == 1'b0)
        crc_data_strb <= crc_data_strb;
    else
        crc_data_strb <= rxc_r;
end
/*----------------------- FSM Region ----------------------------*/
always @(posedge rx_clk or negedge rx_rstn)
begin
    if(rx_rstn == 1'b0)
        cur_state <= State_idle;
    else if(rx_clk_en == 1'b0)
        cur_state <= cur_state;
    else
		cur_state <= next_state;
end

always @(*)
begin
	case(cur_state)
    State_idle :
        if((Frame_en_o == 1'b1) && (Frame_data_o == PREAMBLE))
            next_state = State_data;
        else
            next_state = State_idle;

    State_data :
        if(((Frame_eop_o == 1'b1) && ((too_short == 1'b1) || (too_long == 1'b1))) ||
            (ff_rx_full == 1'b1) || (filter_frame_drop == 1'b1))
            next_state = State_ErrEnd;
        else if(Frame_eop_o == 1'b1)
            next_state = State_OkEnd;
        else
            next_state = State_data;
    
//    State_checkCRC :
//        if((crc_err_en == 1'b1) && (crc_err == 1'b1))
//            next_state = State_ErrEnd;
//        else if(crc_err_en == 1'b1)
//            next_state = State_OkEnd;
//        else
//            next_state = State_checkCRC;

    State_OkEnd :
        if((Frame_en_o == 1'b1) && (Frame_data_o == PREAMBLE))
            next_state = State_data;
        else
            next_state = State_idle;


    State_ErrEnd :
        if(ff_rx_full == 1'b0)
            next_state = State_idle;
        else
            next_state = State_ErrEnd;
        
    default :
        next_state = State_idle;
    endcase
end

/*----------------------- Rx Monitor Region ----------------------------*/
always @(posedge rx_clk or negedge rx_rstn)
begin
    if(rx_rstn == 1'b0)
        frm_len_cnt <= 16'h0;
    else if((cur_state == State_idle) || (cur_state == State_OkEnd))
        frm_len_cnt <= 16'h8;
    else if(cur_state == State_data)
        case(Frame_strb_o)
            8'b0000_0001        : frm_len_cnt <= frm_len_cnt + 1;
            8'b0000_0011        : frm_len_cnt <= frm_len_cnt + 2;
            8'b0000_0111        : frm_len_cnt <= frm_len_cnt + 3;
            8'b0000_1111        : frm_len_cnt <= frm_len_cnt + 4;
            8'b0001_1111        : frm_len_cnt <= frm_len_cnt + 5;
            8'b0011_1111        : frm_len_cnt <= frm_len_cnt + 6;
            8'b0111_1111        : frm_len_cnt <= frm_len_cnt + 7;
            8'b1111_1111        : frm_len_cnt <= frm_len_cnt + 8;
            default             : frm_len_cnt <= frm_len_cnt + 0;
        endcase
end

assign too_short = (frm_len_cnt < 16'd64) ? 1'b1 : 1'b0;
assign too_long = (frm_len_cnt > frm_length) ? 1'b1 : 1'b0;

/*----------------------- Fifo Interface Region ----------------------------*/
always @(posedge rx_clk or negedge rx_rstn)
begin
    if(rx_rstn == 1'b0)
        ff_rx_data <= 8'h0;
    else if(rx_clk_en == 1'b0)
        ff_rx_data <= ff_rx_data;
    else if(cur_state == State_data)
        ff_rx_data <= Frame_data_o;
  
end

always @(posedge rx_clk or negedge rx_rstn)
begin
    if(rx_rstn == 1'b0)
        ff_rx_en <= 1'b0;
    else if(rx_clk_en == 1'b0)
        ff_rx_en <= ff_rx_en;
    else if(cur_state == State_data)
        ff_rx_en <= Frame_en_o;
    else      
        ff_rx_en <= 1'b0;
end

always @(posedge rx_clk or negedge rx_rstn)
begin
    if(rx_rstn == 1'b0)
        ff_rx_strb <= 8'b0;
    else if(rx_clk_en == 1'b0)
        ff_rx_strb <= ff_rx_strb;
    else if(cur_state == State_data)
        ff_rx_strb <= Frame_strb_o;
    else      
        ff_rx_strb <= 8'b0;        
end

always @(posedge rx_clk or negedge rx_rstn)
begin
    if(rx_rstn == 1'b0)
        ff_rx_eop <= 1'b0;
    else if(rx_clk_en == 1'b0)
        ff_rx_eop <= ff_rx_eop;
    else if(cur_state == State_data)
        ff_rx_eop <= Frame_eop_o;
    else
        ff_rx_eop <= 1'b0;
end

//always @(posedge rx_clk or negedge rx_rstn)
//begin
//    if(rx_rstn == 1'b0)
//        ff_rx_err <= 1'b0;
//    else if(rx_clk_en == 1'b0)
//        ff_rx_err <= ff_rx_err;
//    else if((cur_state == State_ErrEnd) && (ff_rx_full == 1'b0))
//        ff_rx_err <= 1'b1;
//    else
//        ff_rx_err <= 1'b0;
//end

assign ff_rx_err =((cur_state == State_ErrEnd) && (ff_rx_full == 1'b0));
/*----------------------- Frame Filter Region ----------------------------*/
assign dst_addr = ff_rx_data[47:0];

always @(posedge rx_clk or negedge rx_rstn)
begin
    if(rx_rstn == 1'b0)
        dst_addr_en <= 1'b0;
    else if(rx_clk_en == 1'b0)
        dst_addr_en <= dst_addr_en;
    else if((frm_len_cnt == 16'd8) && (cur_state == State_data))
        dst_addr_en <= 1'b1;
    else
        dst_addr_en <= 1'b0;
end

/*----------------------- Flow Control Region ----------------------------*/
always @(posedge rx_clk or negedge rx_rstn)
begin
    if(rx_rstn == 1'b0)
        fc_cur_state <= Pause_idle;
    else if(rx_clk_en == 1'b0)
        fc_cur_state <= fc_cur_state;
    else
		fc_cur_state <= fc_next_state;
end

always @(*)
begin
	case(fc_cur_state)
    Pause_idle :
        if(cur_state == State_data)
            fc_next_state = Pause_pre_syn;
        else
            fc_next_state = Pause_idle;

    Pause_pre_syn :
        case(frm_len_cnt)
        16'd8 :
            if(Frame_data_o[47:0] == PAUSE_ADDR)
                fc_next_state = Pause_pre_syn;
            else
                fc_next_state = Pause_idle;

        16'd16 :
            if(Frame_data_o[63:32] == PAUSE_TYPE)
                fc_next_state = Pause_quanta;
            else
                fc_next_state = Pause_idle;

        default: fc_next_state = Pause_pre_syn;
        endcase

    Pause_quanta :
        fc_next_state = Pause_syn;

    Pause_syn :
        if(cur_state == State_idle)
            fc_next_state = Pause_idle;
        else
            fc_next_state = Pause_syn;

    default :
        fc_next_state = Pause_idle;
    endcase
end


always @(posedge rx_clk or negedge rx_rstn)
begin
    if(rx_rstn == 1'b0)
        rx_pause_quant <= 16'h0;
    else if(rx_clk_en == 1'b0)
        rx_pause_quant <= rx_pause_quant;
    else if(fc_cur_state == Pause_quanta)
        rx_pause_quant <= Frame_data_o[15:0];

end

always @(posedge rx_clk or negedge rx_rstn)
begin
    if(rx_rstn == 1'b0)
        begin
            rx_pause_quant_en_resp_dl1 <= 1'b0;
            rx_pause_quant_en_resp_dl2 <= 1'b0;
        end
    else if(rx_clk_en == 1'b0)
        begin          
            rx_pause_quant_en_resp_dl1 <= rx_pause_quant_en_resp_dl1;
            rx_pause_quant_en_resp_dl2 <= rx_pause_quant_en_resp_dl2;
        end
    else
        begin         
            rx_pause_quant_en_resp_dl1 <= rx_pause_quant_en_resp;
            rx_pause_quant_en_resp_dl2 <= rx_pause_quant_en_resp_dl1;
        end
end

always @(posedge rx_clk or negedge rx_rstn)
begin
    if(rx_rstn == 1'b0)
        rx_pause_quant_en <= 1'b0;
    else if(rx_clk_en == 1'b0)
        rx_pause_quant_en <= rx_pause_quant_en;
    else if(pause_ignore == 1'b1)
        rx_pause_quant_en <= 1'b0;
    else if((fc_cur_state == Pause_syn) && (cur_state == State_OkEnd))
        rx_pause_quant_en <= 1'b1;
    else if(rx_pause_quant_en_resp_dl2 == 1'b1)
        rx_pause_quant_en <= 1'b0;
end

/*----------------------- Statistics Region ----------------------------*/
always @(posedge rx_clk or negedge rx_rstn)
begin
    if(rx_rstn == 1'b0)
        begin
            cnt_reset_dl1 <= 1'b0;
            cnt_reset_dl2 <= 1'b0;
        end
    else
        begin
            cnt_reset_dl1 <= cnt_reset;
            cnt_reset_dl2 <= cnt_reset_dl1;
        end
end

//aFramesReceivedOK
always @(posedge rx_clk or negedge rx_rstn)
begin
    if(rx_rstn == 1'b0)
        aFramesReceivedOK_en <= 1'b0;
    else if(cnt_reset_dl2 == 1'b1)
        aFramesReceivedOK_en <= 1'b0;
    else if(rx_clk_en == 1'b0)
        aFramesReceivedOK_en <= aFramesReceivedOK_en;
    else if(cur_state == State_OkEnd)
        aFramesReceivedOK_en <= 1'b1;
    else
        aFramesReceivedOK_en <= 1'b0;
end

always @(posedge rx_clk or negedge rx_rstn)
begin
    if(rx_rstn == 1'b0)
        aFramesReceivedOK <= {REG_WIDTH{1'b0}};
    else if(cnt_reset_dl2 == 1'b1)
        aFramesReceivedOK <= {REG_WIDTH{1'b0}};
    else if((rx_clk_en == 1'b0) || (&aFramesReceivedOK == 1'b1))
        aFramesReceivedOK <= aFramesReceivedOK;
    else if(aFramesReceivedOK_en == 1'b1)
        aFramesReceivedOK <= aFramesReceivedOK + 1'b1;
end

//aFramesReceivedLen
always @(posedge rx_clk or negedge rx_rstn)
begin
    if(rx_rstn == 1'b0)
        aFramesReceivedLen <= {REG_WIDTH{1'b0}};
    else if(cnt_reset_dl2 == 1'b1)
        aFramesReceivedLen <= {REG_WIDTH{1'b0}};
    else if((rx_clk_en == 1'b1) && (cur_state == State_OkEnd))
        aFramesReceivedLen <= frm_len_cnt;
end

//aFrameCheckSequenceErrors
always @(posedge rx_clk or negedge rx_rstn)
begin
    if(rx_rstn == 1'b0)
        aFrameCheckSequenceErrors_en <= 1'b0;
    else if(cnt_reset_dl2 == 1'b1)
        aFrameCheckSequenceErrors_en <= 1'b0;
    else if(rx_clk_en == 1'b0)
        aFrameCheckSequenceErrors_en <= aFrameCheckSequenceErrors_en;
//    else if((cur_state == State_checkCRC) && (crc_err_en == 1'b1) && (crc_err == 1'b1))
    else if((crc_err_en == 1'b1) && (crc_err == 1'b1))
        aFrameCheckSequenceErrors_en <= 1'b1;
    else
        aFrameCheckSequenceErrors_en <= 1'b0;
end

always @(posedge rx_clk or negedge rx_rstn)
begin
    if(rx_rstn == 1'b0)
        aFrameCheckSequenceErrors <= {REG_WIDTH{1'b0}};
    else if(cnt_reset_dl2 == 1'b1)
        aFrameCheckSequenceErrors <= {REG_WIDTH{1'b0}};
    else if((rx_clk_en == 1'b0) || (aFrameCheckSequenceErrors == {REG_WIDTH{1'b1}}))
        aFrameCheckSequenceErrors <= aFrameCheckSequenceErrors;
    else if(aFrameCheckSequenceErrors_en == 1'b1)
        aFrameCheckSequenceErrors <= aFrameCheckSequenceErrors + 1;
end

//aRxPAUSEMACCtrlFrames
always @(posedge rx_clk or negedge rx_rstn)
begin
    if(rx_rstn == 1'b0)
        aRxPAUSEMACCtrlFrames_en <= 1'b0;
    else if(cnt_reset_dl2 == 1'b1)
        aRxPAUSEMACCtrlFrames_en <= 1'b0;
    else if(rx_clk_en == 1'b0)
        aRxPAUSEMACCtrlFrames_en <= aRxPAUSEMACCtrlFrames_en;
    else if((rx_clk_en == 1'b1) && (fc_cur_state == Pause_syn) && (cur_state == State_OkEnd))
        aRxPAUSEMACCtrlFrames_en <= 1'b1;
    else
        aRxPAUSEMACCtrlFrames_en <= 1'b0;
end

always @(posedge rx_clk or negedge rx_rstn)
begin
    if(rx_rstn == 1'b0)
        aRxPAUSEMACCtrlFrames <= {REG_WIDTH{1'b0}};
    else if(cnt_reset_dl2 == 1'b1)
        aRxPAUSEMACCtrlFrames <= {REG_WIDTH{1'b0}};
    else if((rx_clk_en == 1'b0) || (aRxPAUSEMACCtrlFrames == {REG_WIDTH{1'b1}}))
        aRxPAUSEMACCtrlFrames <= aRxPAUSEMACCtrlFrames;
    else if(aRxPAUSEMACCtrlFrames_en == 1'b1)
        aRxPAUSEMACCtrlFrames <= aRxPAUSEMACCtrlFrames + 1;
end

//ifInErrors
always @(posedge rx_clk or negedge rx_rstn)
begin
    if(rx_rstn == 1'b0)
        ifInErrors_en <= 1'b0;
    else if(cnt_reset_dl2 == 1'b1)
        ifInErrors_en <= 1'b0;
    else if(rx_clk_en == 1'b0)
        ifInErrors_en <= ifInErrors_en;
    else if((cur_state == State_ErrEnd) && (ff_rx_full == 1'b0))
        ifInErrors_en <= 1'b1;
    else
        ifInErrors_en <= 1'b0;
end

always @(posedge rx_clk or negedge rx_rstn)
begin
    if(rx_rstn == 1'b0)
        ifInErrors <= {REG_WIDTH{1'b0}};
    else if(cnt_reset_dl2 == 1'b1)
        ifInErrors <= {REG_WIDTH{1'b0}};
    else if((rx_clk_en == 1'b0) || (ifInErrors == {REG_WIDTH{1'b1}}))
        ifInErrors <= ifInErrors;
    else if(ifInErrors_en == 1'b1)
        ifInErrors <= ifInErrors + 1;
end

//etherStatsPkts
always @(posedge rx_clk or negedge rx_rstn)
begin
    if(rx_rstn == 1'b0)
        etherStatsPkts <= {REG_WIDTH{1'b0}};
    else if(cnt_reset_dl2 == 1'b1)
        etherStatsPkts <= {REG_WIDTH{1'b0}};
    else if((rx_clk_en == 1'b0) || (&etherStatsPkts == 1'b1))
        etherStatsPkts <= etherStatsPkts;
    else if((aFramesReceivedOK_en == 1'b1) || (ifInErrors_en == 1'b1))
        etherStatsPkts <= etherStatsPkts + 1;
end

//etherStatsUndersizePkts
always @(posedge rx_clk or negedge rx_rstn)
begin
    if(rx_rstn == 1'b0)
        etherStatsUndersizePkts_en <= 1'b0;
    else if(cnt_reset_dl2 == 1'b1)
        etherStatsUndersizePkts_en <= 1'b0;
    else if(rx_clk_en == 1'b0)
        etherStatsUndersizePkts_en <= etherStatsUndersizePkts_en;
    else if((cur_state == State_data) && (Frame_eop_o == 1'b1) && (too_short == 1'b1))
        etherStatsUndersizePkts_en <= 1'b1;
    else
        etherStatsUndersizePkts_en <= 1'b0;
end

always @(posedge rx_clk or negedge rx_rstn)
begin
    if(rx_rstn == 1'b0)
        etherStatsUndersizePkts <= {REG_WIDTH{1'b0}};
    else if(cnt_reset_dl2 == 1'b1)
        etherStatsUndersizePkts <= {REG_WIDTH{1'b0}};
    else if((rx_clk_en == 1'b0) || (etherStatsUndersizePkts == {REG_WIDTH{1'b1}}))
        etherStatsUndersizePkts <= etherStatsUndersizePkts;
    else if(etherStatsUndersizePkts_en == 1'b1)
        etherStatsUndersizePkts <= etherStatsUndersizePkts + 1;
end

//etherStatsOversizePkts
always @(posedge rx_clk or negedge rx_rstn)
begin
    if(rx_rstn == 1'b0)
        etherStatsOversizePkts_en <= 1'b0;
    else if(cnt_reset_dl2 == 1'b1)
        etherStatsOversizePkts_en <= 1'b0;
    else if(rx_clk_en == 1'b0)
        etherStatsOversizePkts_en <= etherStatsOversizePkts_en;
    else if((cur_state == State_data) && (Frame_eop_o == 1'b1) && (too_long == 1'b1))
        etherStatsOversizePkts_en <= 1'b1;
    else
        etherStatsOversizePkts_en <= 1'b0;
end

always @(posedge rx_clk or negedge rx_rstn)
begin
    if(rx_rstn == 1'b0)
        etherStatsOversizePkts <= {REG_WIDTH{1'b0}};
    else if(cnt_reset_dl2 == 1'b1)
        etherStatsOversizePkts <= {REG_WIDTH{1'b0}};
    else if((rx_clk_en == 1'b0) || (etherStatsOversizePkts == {REG_WIDTH{1'b1}}))
        etherStatsOversizePkts <= etherStatsOversizePkts;
    else if(etherStatsOversizePkts_en == 1'b1)
        etherStatsOversizePkts <= etherStatsOversizePkts + 1;
end

//aRxFilterFramesErrors
always @(posedge rx_clk or negedge rx_rstn)
begin
    if(rx_rstn == 1'b0)
        aRxFilterFramesErrors_en <= 1'b0;
    else if(cnt_reset_dl2 == 1'b1)
        aRxFilterFramesErrors_en <= 1'b0;
    else if(rx_clk_en == 1'b0)
        aRxFilterFramesErrors_en <= aRxFilterFramesErrors_en;
    else if((cur_state == State_data) && (filter_frame_drop == 1'b1))
        aRxFilterFramesErrors_en <= 1'b1;
    else
        aRxFilterFramesErrors_en <= 1'b0;
end

always @(posedge rx_clk or negedge rx_rstn)
begin
    if(rx_rstn == 1'b0)
        aRxFilterFramesErrors <= {REG_WIDTH{1'b0}};
    else if(cnt_reset_dl2 == 1'b1)
        aRxFilterFramesErrors <= {REG_WIDTH{1'b0}};
    else if((rx_clk_en == 1'b0) || (aRxFilterFramesErrors == {REG_WIDTH{1'b1}}))
        aRxFilterFramesErrors <= aRxFilterFramesErrors;
    else if(aRxFilterFramesErrors_en == 1'b1)
        aRxFilterFramesErrors <= aRxFilterFramesErrors + 1;
end

//aRSReceivedLinkErrors
always @(posedge rx_clk or negedge rx_rstn)
begin
    if(rx_rstn == 1'b0)
        aRSReceivedLinkErrors <= {REG_WIDTH{1'b0}};
    else if(cnt_reset_dl2 == 1'b1)
        aRSReceivedLinkErrors <= {REG_WIDTH{1'b0}};
    else if((rx_clk_en == 1'b0) || (aRSReceivedLinkErrors == {REG_WIDTH{1'b1}}))
        aRSReceivedLinkErrors <= aRSReceivedLinkErrors;
    else if(xgmii_rx_err == 1'b1)
        aRSReceivedLinkErrors <= aRSReceivedLinkErrors + 1;
end

/*----------------------- Interrupt Region ----------------------------*/
//rx_interupt_en
always @(posedge rx_clk or negedge rx_rstn)
begin
    if(rx_rstn == 1'b0)
        rx_interupt_en <= 1'b0;
    else if(cnt_reset_dl2 == 1'b1)
        rx_interupt_en <= 1'b0;
    else if(rx_clk_en == 1'b0)
        rx_interupt_en <= rx_interupt_en;
    else if(aFrameCheckSequenceErrors_en | ifInErrors_en | etherStatsUndersizePkts_en | 
            etherStatsOversizePkts_en | aRxFilterFramesErrors_en | xgmii_rx_err)
        rx_interupt_en <= 1'b1;
    else
        rx_interupt_en <= 1'b0;
end


always @(posedge rx_clk or negedge rx_rstn)
begin
    if(rx_rstn == 1'b0)
        begin
            rx_interupt_req_d1 <= 1'b0;
            rx_interupt_req_d2 <= 1'b0;
            rx_interupt_req_d3 <= 1'b0;
        end
    else
        begin
            rx_interupt_req_d1 <= rx_interupt_req;
            rx_interupt_req_d2 <= rx_interupt_req_d1;
            rx_interupt_req_d3 <= rx_interupt_req_d2;
        end
end

always @(posedge rx_clk or negedge rx_rstn)
begin
    if(rx_rstn == 1'b0)
        rx_interupt <= 1'b0;
    else if(cnt_reset_dl2 == 1'b1)
        rx_interupt <= 1'b0;  
    else if((rx_interupt_req_d3 == 1'b0) && (rx_interupt_req_d2 == 1'b1))
        rx_interupt <= 1'b0;         
    else if(rx_interupt_en == 1'b1)
        rx_interupt <= 1'b1;
end

//Encryption end
endmodule
