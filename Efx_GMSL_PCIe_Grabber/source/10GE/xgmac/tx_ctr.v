`timescale 1 ns / 1 ns
module tx_ctr#(
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
output  reg     [63:0]          xgmii_txd,
output  reg     [7:0]           xgmii_txc,
output  reg                     xgmii_tx_err,
input                           xgmii_rs_tx_err,
//Tx Fifo Interface
input           [63:0]          ff_tx_data,
input           [7:0]           ff_tx_strb,
input                           ff_tx_eop,
input                           ff_tx_vld,
input                           ff_tx_err,
output  wire                    ff_tx_rdy,
//CRC Check Signals
output  reg                     crc_init,
output  wire    [63:0]          crc_data,
output  reg     [7:0]           crc_data_strb,
output  reg                     crc_data_en,
output  reg                     crc_eop,
input   wire                    Frame_en_o     ,
input   wire    [63:0]          Frame_data_o   ,
input   wire    [7:0]           Frame_strb_o   ,
//output  reg                     crc_rd,
//input           [31:0]          crc_out,
//Flow Control Signals
input           [15:0]          rx_pause_quant,
input                           rx_pause_quant_en,
output  reg                     rx_pause_quant_en_resp,
//Statistics Counters
input                           tx_interupt_req,
output  reg                     tx_interupt,
output  reg     [REG_WIDTH-1:0] aFramesTransmittedOK,
output  reg     [REG_WIDTH-1:0] aTxPAUSEMACCtrlFrames,
output  reg     [REG_WIDTH-1:0] ifOutErrors,
output  reg     [REG_WIDTH-1:0] aTxFifoOverflowFramesErrors,
output  reg     [REG_WIDTH-1:0] aTxIncontinuityFramesErrors
//Status and  Error Signals
);

// localparam Define 
localparam State_idle           = 4'd0;
localparam State_pause          = 4'd1;
localparam State_preamble       = 4'd2;
//localparam State_sfd            = 4'd3;
localparam State_SendPauseFrame = 4'd4;
localparam State_data           = 4'd5;
localparam State_pad            = 4'd6;
localparam State_fcs            = 4'd7;
localparam State_drop           = 4'd8;
localparam State_OkEnd          = 4'd9;
localparam State_ErrEnd         = 4'd10;
localparam State_defer          = 4'd11;
localparam State_ipg            = 4'd12;
localparam PREAMBLE             = 64'hd5555555_55555555;
// Register Define
reg     [3:0]                   cur_state;
reg     [3:0]                   next_state;
reg     [7:0]                   pause_cnt;
reg     [15:0]                  frm_len_cnt;
reg     [5:0]                   ipg_cnt;
//reg     [2:0]                   preamble_cnt;
reg     [2:0]                   fcs_cnt;
reg     [7:0]                   tx_en_r;
reg     [63:0]                  tx_d_r;
reg                             tx_err_r;
reg                             xon_gen_dl1;
reg                             xon_gen_dl2;
reg                             xoff_gen_dl1;
reg                             xoff_gen_dl2;
reg                             xon_gen_en;
reg                             xoff_gen_en;
reg     [15:0]                  rx_pause_quant_dl1;
reg     [15:0]                  rx_pause_quant_dl2;
reg                             rx_pause_quant_en_dl1;
reg                             rx_pause_quant_en_dl2;
reg                             pause_state;
reg                             pause_quanta_sub;
reg     [15:0]                  pause_quanta_cnt;
reg                             pause_en;
reg                             ff_tx_rdy_r;
reg                             cnt_reset_dl1;
reg                             cnt_reset_dl2;
reg                             aFramesTransmittedOK_en;
reg                             aTxPAUSEMACCtrlFrames_en;
reg                             ifOutErrors_en;
reg                             aTxIncontinuityFramesErrors_en;
reg                             tx_interupt_en;
reg                             tx_interupt_req_d1;
reg                             tx_interupt_req_d2;
reg                             tx_interupt_req_d3;
// Wire Define

/*----------------------------------------------------------------------------------*\
                                 The main code
\*----------------------------------------------------------------------------------*/
//Encryption begin
/*----------------------- FSM Region ----------------------------*/
always @(posedge tx_clk or negedge tx_rstn)
begin
    if(tx_rstn == 1'b0)
        cur_state <= State_defer;
    else if(tx_clk_en == 1'b0)
        cur_state <= cur_state;
    else
		cur_state <= next_state;
end

always @(*)
begin
	case(cur_state)
    State_defer :
        next_state = State_ipg;

    State_ipg : 
        if(ipg_cnt == tx_ipg_length-3)
            next_state = State_idle;
        else
            next_state = State_ipg;
        
    State_idle :
        if(pause_en == 1'b1)
            next_state = State_pause;
        else if((xoff_gen_en == 1'b1) || (xon_gen_en == 1'b1) || 
                  ((ff_tx_vld == 1'b1) && (ff_tx_eop == 1'b0)))
            next_state = State_preamble;
        else
            next_state = State_idle;

    State_pause :
        if(pause_cnt == 512/64 -1)
            next_state = State_defer;
        else
            next_state = State_pause;
   
    State_preamble :
        if((xoff_gen_en == 1'b1) || (xon_gen_en == 1'b1))
            next_state = State_SendPauseFrame;
        else
            next_state = State_data;

    State_SendPauseFrame :
        if(frm_len_cnt == 2)
            next_state = State_pad;
        else
            next_state = State_SendPauseFrame;

    State_data :
        if((ff_tx_rdy_r == 1'b1) && (ff_tx_vld == 1'b0))
            next_state = State_drop;
        else if((ff_tx_eop == 1'b1) && (ff_tx_err == 1'b1))
            next_state = State_ErrEnd;
        else if((ff_tx_eop == 1'b1) && (frm_len_cnt >= 8))
            next_state = State_OkEnd;
        else if(ff_tx_eop == 1'b1)
            next_state = State_pad;
        else
            next_state = State_data;

    State_pad :
        if(frm_len_cnt >= 8)
            next_state = State_OkEnd;
        else
            next_state = State_pad;

//    State_fcs :
//        if(fcs_cnt == 1)
//            next_state = State_OkEnd;
//        else
//            next_state = State_fcs;

    State_drop :
        if(ff_tx_eop == 1'b1)
            next_state = State_ErrEnd;
        else
            next_state = State_drop;

    State_OkEnd :
        next_state = State_defer;

    State_ErrEnd :
        next_state = State_defer;

    default :
        next_state = State_defer;
    endcase
end

/*----------------------- Tx Counter Region ----------------------------*/
always @(posedge tx_clk or negedge tx_rstn)
begin
    if(tx_rstn == 1'b0)
        pause_cnt <= 8'h0;
    else if(tx_clk_en == 1'b0)
        pause_cnt <= pause_cnt;
    else if(cur_state == State_pause)
        pause_cnt <= pause_cnt + 1'b1;
    else
        pause_cnt <= 8'h0;
end

always @(posedge tx_clk or negedge tx_rstn)
begin
    if(tx_rstn == 1'b0)
        frm_len_cnt <= 16'h0;
    else if(tx_clk_en == 1'b0)
        frm_len_cnt <= frm_len_cnt;
    else if(cur_state == State_defer)
        frm_len_cnt <= 16'h0;
    else if(((cur_state == State_data) || (cur_state == State_SendPauseFrame) || (cur_state == State_pad))
               && (frm_len_cnt != 16'hffff))
        frm_len_cnt <= frm_len_cnt + 1'b1;
end

always @(posedge tx_clk or negedge tx_rstn)
begin
    if(tx_rstn == 1'b0)
        ipg_cnt <= 6'h0;
    else if(tx_clk_en == 1'b0)
        ipg_cnt <= ipg_cnt;
    else if(cur_state == State_ipg)
        ipg_cnt <= ipg_cnt + 1'b1;
    else
        ipg_cnt <= 8'h0;
end

//always @(posedge tx_clk or negedge tx_rstn)
//begin
//    if(tx_rstn == 1'b0)
//        preamble_cnt <= 3'h0;
//    else if(tx_clk_en == 1'b0)
//        preamble_cnt <= preamble_cnt;
//    else if(cur_state == State_preamble)
//        preamble_cnt <= preamble_cnt + 1'b1;
//    else
//        preamble_cnt <= 8'h0;
//end

//always @(posedge tx_clk or negedge tx_rstn)
//begin
//    if(tx_rstn == 1'b0)
//        fcs_cnt <= 3'h0;
//    else if(tx_clk_en == 1'b0)
//        fcs_cnt <= fcs_cnt;
//    else if(cur_state == State_fcs)
//        fcs_cnt <= fcs_cnt + 1'b1;
//    else
//        fcs_cnt <= 3'h0;
//end

/*----------------------- XGMII Interface Region ----------------------------*/
always @(posedge tx_clk or negedge tx_rstn)
begin
    if(tx_rstn == 1'b0)
        tx_en_r <= 8'b0;
    else if(tx_clk_en == 1'b0)
        tx_en_r <= tx_en_r;
    else if((cur_state == State_preamble) || (cur_state == State_data) ||
            (cur_state == State_SendPauseFrame) || (cur_state == State_pad))
        tx_en_r <= ff_tx_strb;
    else
        tx_en_r <= 8'b0;
end

always @(posedge tx_clk or negedge tx_rstn)
begin
    if(tx_rstn == 1'b0)
        tx_d_r <= 64'h07070707_07070707;
    else if(tx_clk_en == 1'b0)
        tx_d_r <= tx_d_r;
    else
        case(cur_state)
        State_preamble :
            tx_d_r <= PREAMBLE;

        State_SendPauseFrame :
            case(frm_len_cnt)
            8'd0  : tx_d_r <= {48'h0180c2000001,mac_addr[15: 0]};
            8'd1  : tx_d_r <= {mac_addr[47: 16],8'h88,8'h08,8'h00,8'h01};
            8'd2  : tx_d_r <= (pause_state) ? {pause_quant[15:0],48'h0} : 64'h0;
            default : tx_d_r <= 64'h0;
            endcase
        State_data :
            case(ff_tx_strb)
                8'b0000_0001 : tx_d_r <= {56'h07070707070707,ff_tx_data[1*8-1:0]};
                8'b0000_0011 : tx_d_r <= {48'h070707070707,ff_tx_data[2*8-1:0]};
                8'b0000_0111 : tx_d_r <= {40'h0707070707,ff_tx_data[3*8-1:0]};
                8'b0000_1111 : tx_d_r <= {32'h07070707,ff_tx_data[4*8-1:0]};
                8'b0001_1111 : tx_d_r <= {24'h070707,ff_tx_data[5*8-1:0]};
                8'b0011_1111 : tx_d_r <= {16'h0707,ff_tx_data[6*8-1:0]};
                8'b0111_1111 : tx_d_r <= {8'h07,ff_tx_data[7*8-1:0]};
                8'b1111_1111 : tx_d_r <= ff_tx_data;
                default      : tx_d_r <= ff_tx_data;
            endcase
        State_pad : 
            tx_d_r <= 64'h00;
        default : tx_d_r <= 64'h07070707_07070707 ;
        endcase
end

always @(posedge tx_clk or negedge tx_rstn)
begin
    if(tx_rstn == 1'b0)
        tx_err_r <= 1'b0;
    else if(tx_clk_en == 1'b0)
        tx_err_r <= tx_err_r;
    else if((cur_state == State_data) && (((ff_tx_rdy_r == 1'b1) && (ff_tx_vld == 1'b0)) ||
                ((ff_tx_eop == 1'b1) && (ff_tx_err == 1'b1))))
        tx_err_r <= 1'b1;
    else
        tx_err_r <= 1'b0;
end

always @(posedge tx_clk or negedge tx_rstn)
begin
    if(tx_rstn == 1'b0)
        begin
            xgmii_txc    <= 8'h00;
            xgmii_tx_err <= 1'b0;
        end
    else if(tx_clk_en == 1'b0)
        begin
            xgmii_txc    <= xgmii_txc;
            xgmii_tx_err <= xgmii_tx_err;
        end
    else
        begin
            xgmii_txc    <= Frame_strb_o;
            xgmii_tx_err <= tx_err_r;
        end
end

always @(posedge tx_clk or negedge tx_rstn)
begin
    if(tx_rstn == 1'b0)
        xgmii_txd <= {8{8'h07}};
    else if(tx_clk_en == 1'b0)
        xgmii_txd <= xgmii_txd;
    else
        xgmii_txd <= Frame_data_o;
end



/*----------------------- Flow Control Region ----------------------------*/
always @(posedge tx_clk or negedge tx_rstn)
begin
    if(tx_rstn == 1'b0)
        begin
            xon_gen_dl1 <= 1'b0;
            xon_gen_dl2 <= 1'b0;
            xoff_gen_dl1 <= 1'b0;
            xoff_gen_dl2 <= 1'b0;
            rx_pause_quant_dl1 <= 16'h0;
            rx_pause_quant_dl2 <= 16'h0;
            rx_pause_quant_en_dl1 <= 1'b0;
            rx_pause_quant_en_dl2 <= 1'b0;
        end
    else if(tx_clk_en == 1'b0)
        begin
            xon_gen_dl1 <= xon_gen_dl1;
            xon_gen_dl2 <= xon_gen_dl2;
            xoff_gen_dl1 <= xoff_gen_dl1;
            xoff_gen_dl2 <= xoff_gen_dl2;
            rx_pause_quant_dl1 <= rx_pause_quant_dl1;
            rx_pause_quant_dl2 <= rx_pause_quant_dl2;
            rx_pause_quant_en_dl1 <= rx_pause_quant_en_dl1;
            rx_pause_quant_en_dl2 <= rx_pause_quant_en_dl2;
        end
    else
        begin
            xon_gen_dl1 <= xon_gen;
            xon_gen_dl2 <= xon_gen_dl1;
            xoff_gen_dl1 <= xoff_gen;
            xoff_gen_dl2 <= xoff_gen_dl1;
            rx_pause_quant_dl1 <= rx_pause_quant;
            rx_pause_quant_dl2 <= rx_pause_quant_dl1;
            rx_pause_quant_en_dl1 <= rx_pause_quant_en;
            rx_pause_quant_en_dl2 <= rx_pause_quant_en_dl1;
        end
end

always @(posedge tx_clk or negedge tx_rstn)
begin
    if(tx_rstn == 1'b0)
        xon_gen_en <= 1'b0;
    else if(tx_clk_en == 1'b0)
        xon_gen_en <= xon_gen_en;
    else if((xon_gen_dl2 == 1'b0) && (xon_gen_dl1 == 1'b1))
        xon_gen_en <= 1'b1;
    else if(cur_state == State_SendPauseFrame)
        xon_gen_en <= 1'b0;
end

always @(posedge tx_clk or negedge tx_rstn)
begin
    if(tx_rstn == 1'b0)
        xoff_gen_en <= 1'b0;
    else if(tx_clk_en == 1'b0)
        xoff_gen_en <= xoff_gen_en;
    else if((xoff_gen_dl2 == 1'b0) && (xoff_gen_dl1 == 1'b1))
        xoff_gen_en <= 1'b1;
    else if(cur_state == State_SendPauseFrame)
        xoff_gen_en <= 1'b0;
end

//0 : xon_gen; 1 : xoff_gen;
always @(posedge tx_clk or negedge tx_rstn)
begin
    if(tx_rstn == 1'b0)
        pause_state <= 1'b0;
    else if(tx_clk_en == 1'b0)
        pause_state <= pause_state;
    else if((xon_gen_dl2 == 1'b0) && (xon_gen_dl1 == 1'b1))
        pause_state <= 1'b0;
    else if((xoff_gen_dl2 == 1'b0) && (xoff_gen_dl1 == 1'b1))
        pause_state <= 1'b1;
end

always @(posedge tx_clk or negedge tx_rstn)
begin
    if(tx_rstn == 1'b0)
        pause_quanta_sub <= 1'b0;
    else if(tx_clk_en == 1'b0)
        pause_quanta_sub <= pause_quanta_sub;
    else if(pause_cnt == 512/64 -1)
        pause_quanta_sub <= 1'b1;
    else
        pause_quanta_sub <= 1'b0;
end

always @(posedge tx_clk or negedge tx_rstn)
begin
    if(tx_rstn == 1'b0)
        rx_pause_quant_en_resp <= 1'b0;
    else if(tx_clk_en == 1'b0)
        rx_pause_quant_en_resp <= rx_pause_quant_en_resp;
    else if(rx_pause_quant_en_dl2 == 1'b1)
        rx_pause_quant_en_resp <= 1'b1;
    else
        rx_pause_quant_en_resp <= 1'b0;
end

always @(posedge tx_clk or negedge tx_rstn)
begin
    if(tx_rstn == 1'b0)
        pause_quanta_cnt <= 16'h0;
    else if(tx_clk_en == 1'b0)
        pause_quanta_cnt <= pause_quanta_cnt;
    else if(rx_pause_quant_en_dl2 == 1'b1)
        pause_quanta_cnt <= rx_pause_quant_dl2;
    else if((pause_quanta_sub == 1'b1) && (pause_quanta_cnt != 16'h0))
        pause_quanta_cnt <= pause_quanta_cnt - 1'b1;
end

always @(posedge tx_clk or negedge tx_rstn)
begin
    if(tx_rstn == 1'b0)
        pause_en <= 1'b0;
    else if(tx_clk_en == 1'b0)
        pause_en <= pause_en;
    else if(pause_quanta_cnt == 16'h0)
        pause_en <= 1'b0;
    else
        pause_en <= 1'b1;
end

/*----------------------- Fifo Interface Region ----------------------------*/
always @(posedge tx_clk or negedge tx_rstn)
begin
    if(tx_rstn == 1'b0)
        ff_tx_rdy_r <= 1'b0;
    else if(tx_clk_en == 1'b0)
        ff_tx_rdy_r <= ff_tx_rdy_r;
    else if(ff_tx_eop == 1'b1)
        ff_tx_rdy_r <= 1'b0;
    else if((cur_state == State_data) || 
             ((cur_state == State_preamble) && (xoff_gen_en == 1'b0) && (xon_gen_en == 1'b0)) ||
                   (cur_state == State_drop))
        ff_tx_rdy_r <= 1'b1;
    else
        ff_tx_rdy_r <= 1'b0;
end

assign ff_tx_rdy = ((ff_tx_rdy_r || ((cur_state == State_idle) && (ff_tx_eop == 1'b1))) && (xgmii_rs_tx_err ==1'b0));

/*----------------------- CRC Generate Region ----------------------------*/
assign crc_data = tx_d_r;

always @(posedge tx_clk or negedge tx_rstn)
begin
    if(tx_rstn == 1'b0)
        crc_init <= 1'b0;
    else if(tx_clk_en == 1'b0)
        crc_init <= crc_init;
    else if(cur_state == State_preamble)
        crc_init <= 1'b1;
    else
        crc_init <= 1'b0;
end

always @(posedge tx_clk or negedge tx_rstn)
begin
    if(tx_rstn == 1'b0)
        crc_data_en <= 1'b0;
    else if(tx_clk_en == 1'b0)
        crc_data_en <= crc_data_en;
    else if((cur_state == State_data) || (cur_state == State_pad  && (frm_len_cnt <= 7)))
        crc_data_en <= 1'b1;
    else
        crc_data_en <= 1'b0;
end


always @(posedge tx_clk or negedge tx_rstn)
begin
    if(tx_rstn == 1'b0)
        crc_eop <= 1'b0;
    else if(tx_clk_en == 1'b0)
        crc_eop <= crc_eop;
    else if((cur_state == State_data) && (frm_len_cnt >= 7))
        crc_eop <= ff_tx_eop;
    else if((cur_state == State_pad)  && (frm_len_cnt == 7))
        crc_eop <= 1'b1;        
    else
        crc_eop <= 1'b0;
end

always @(posedge tx_clk or negedge tx_rstn)
begin
    if(tx_rstn == 1'b0)
        crc_data_strb <= 8'h0;
    else if(tx_clk_en == 1'b0)
        crc_data_strb <= crc_data_strb;
    else
        case(cur_state)

        State_SendPauseFrame :
            crc_data_strb <= 8'hff;
        State_data :
            begin
            if(frm_len_cnt <= 8)
                crc_data_strb <= 8'hff;
            else
                crc_data_strb <= ff_tx_strb;
            end
        State_pad : 
            crc_data_strb <= 8'hff;
        default : crc_data_strb <= 8'h0;
        endcase
end

//always @(posedge tx_clk or negedge tx_rstn)
//begin
//    if(tx_rstn == 1'b0)
//        crc_data_strb <= 8'b0;
//    else if(tx_clk_en == 1'b0)
//        crc_data_strb <= crc_data_strb;
//    else if((cur_state == State_data) || (cur_state == State_SendPauseFrame) || (cur_state == State_pad))
//        crc_data_strb <= ff_tx_strb;
//    else
//        crc_data_strb <= 8'b0;
//end

//always @(posedge tx_clk or negedge tx_rstn)
//begin
//    if(tx_rstn == 1'b0)
//        crc_rd <= 1'b0;
//    else if(tx_clk_en == 1'b0)
//        crc_rd <= crc_rd;
//    else if(cur_state == State_fcs)
//        crc_rd <= 1'b1;
//    else
//        crc_rd <= 1'b0;
//end

/*----------------------- Statistics Region ----------------------------*/
always @(posedge tx_clk or negedge tx_rstn)
begin
    if(tx_rstn == 1'b0)
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

//aFramesTransmittedOK
always @(posedge tx_clk or negedge tx_rstn)
begin
    if(tx_rstn == 1'b0)
        aFramesTransmittedOK_en <= 1'b0;
    else if(cnt_reset_dl2 == 1'b1)
        aFramesTransmittedOK_en <= 1'b0;
    else if(tx_clk_en == 1'b0)
        aFramesTransmittedOK_en <= aFramesTransmittedOK_en;
    else if(cur_state == State_OkEnd)
        aFramesTransmittedOK_en <= 1'b1;
    else
        aFramesTransmittedOK_en <= 1'b0;
end

always @(posedge tx_clk or negedge tx_rstn)
begin
    if(tx_rstn == 1'b0)
        aFramesTransmittedOK <= {REG_WIDTH{1'b0}};
    else if(cnt_reset_dl2 == 1'b1)
        aFramesTransmittedOK <= {REG_WIDTH{1'b0}};
    else if((tx_clk_en == 1'b0) || (&aFramesTransmittedOK == 1'b1))
        aFramesTransmittedOK <= aFramesTransmittedOK;
    else if(aFramesTransmittedOK_en == 1'b1)
        aFramesTransmittedOK <= aFramesTransmittedOK + 1;
end

//aTxPAUSEMACCtrlFrames
always @(posedge tx_clk or negedge tx_rstn)
begin
    if(tx_rstn == 1'b0)
        aTxPAUSEMACCtrlFrames_en <= 1'b0;
    else if(cnt_reset_dl2 == 1'b1)
        aTxPAUSEMACCtrlFrames_en <= 1'b0;
    else if(tx_clk_en == 1'b0)
        aTxPAUSEMACCtrlFrames_en <= aTxPAUSEMACCtrlFrames_en;
    else if((cur_state == State_SendPauseFrame) && (frm_len_cnt == 17))
        aTxPAUSEMACCtrlFrames_en <= 1'b1;
    else
        aTxPAUSEMACCtrlFrames_en <= 1'b0;
end

always @(posedge tx_clk or negedge tx_rstn)
begin
    if(tx_rstn == 1'b0)
        aTxPAUSEMACCtrlFrames <= {REG_WIDTH{1'b0}};
    else if(cnt_reset_dl2 == 1'b1)
        aTxPAUSEMACCtrlFrames <= {REG_WIDTH{1'b0}};
    else if((tx_clk_en == 1'b0) || (&aTxPAUSEMACCtrlFrames == 1'b1))
        aTxPAUSEMACCtrlFrames <= aTxPAUSEMACCtrlFrames;
    else if(aTxPAUSEMACCtrlFrames_en == 1'b1)
        aTxPAUSEMACCtrlFrames <= aTxPAUSEMACCtrlFrames + 1;
end

//ifOutErrors
always @(posedge tx_clk or negedge tx_rstn)
begin
    if(tx_rstn == 1'b0)
        ifOutErrors_en <= 1'b0;
    else if(cnt_reset_dl2 == 1'b1)
        ifOutErrors_en <= 1'b0;
    else if(tx_clk_en == 1'b0)
        ifOutErrors_en <= ifOutErrors_en;
    else if((cur_state == State_ErrEnd) || (txfifo_overflow_err == 1'b1))
        ifOutErrors_en <= 1'b1;
    else
        ifOutErrors_en <= 1'b0;
end

always @(posedge tx_clk or negedge tx_rstn)
begin
    if(tx_rstn == 1'b0)
        ifOutErrors <= {REG_WIDTH{1'b0}};
    else if(cnt_reset_dl2 == 1'b1)
        ifOutErrors <= {REG_WIDTH{1'b0}};
    else if((tx_clk_en == 1'b0) || (&ifOutErrors == 1'b1))
        ifOutErrors <= ifOutErrors;
    else if(ifOutErrors_en == 1'b1)
        ifOutErrors <= ifOutErrors + 1'b1;
end

//aTxFifoOverflowFramesErrors
always @(posedge tx_clk or negedge tx_rstn)
begin
    if(tx_rstn == 1'b0)
        aTxFifoOverflowFramesErrors <= {REG_WIDTH{1'b0}};
    else if(cnt_reset_dl2 == 1'b1)
        aTxFifoOverflowFramesErrors <= {REG_WIDTH{1'b0}};
    else if((tx_clk_en == 1'b0) || (&aTxFifoOverflowFramesErrors == 1'b1))
        aTxFifoOverflowFramesErrors <= aTxFifoOverflowFramesErrors;
    else if(txfifo_overflow_err == 1'b1)
        aTxFifoOverflowFramesErrors <= aTxFifoOverflowFramesErrors + 1;
end

//aTxIncontinuityFramesErrors
always @(posedge tx_clk or negedge tx_rstn)
begin
    if(tx_rstn == 1'b0)
        aTxIncontinuityFramesErrors_en <= 1'b0;
    else if(cnt_reset_dl2 == 1'b1)
        aTxIncontinuityFramesErrors_en <= 1'b0;
    else if(tx_clk_en == 1'b0)
        aTxIncontinuityFramesErrors_en <= aTxIncontinuityFramesErrors_en;
    else if((cur_state == State_drop) && (ff_tx_eop == 1'b1))
        aTxIncontinuityFramesErrors_en <= 1'b1;
    else
        aTxIncontinuityFramesErrors_en <= 1'b0;
end

always @(posedge tx_clk or negedge tx_rstn)
begin
    if(tx_rstn == 1'b0)
        aTxIncontinuityFramesErrors <= {REG_WIDTH{1'b0}};
    else if(cnt_reset_dl2 == 1'b1)
        aTxIncontinuityFramesErrors <= {REG_WIDTH{1'b0}};
    else if((tx_clk_en == 1'b0) || (&aTxIncontinuityFramesErrors == 1'b1))
        aTxIncontinuityFramesErrors <= aTxIncontinuityFramesErrors;
    else if(aTxIncontinuityFramesErrors_en == 1'b1)
        aTxIncontinuityFramesErrors <= aTxIncontinuityFramesErrors + 1;
end

/*----------------------- Interrupt Region ----------------------------*/
//tx_interupt_en
always @(posedge tx_clk or negedge tx_rstn)
begin
    if(tx_rstn == 1'b0)
        tx_interupt_en <= 1'b0;
    else if(cnt_reset_dl2 == 1'b1)
        tx_interupt_en <= 1'b0;
    else if(tx_clk_en == 1'b0)
        tx_interupt_en <= tx_interupt_en;
    else if(ifOutErrors_en | txfifo_overflow_err | aTxIncontinuityFramesErrors_en )
        tx_interupt_en <= 1'b1;
    else
        tx_interupt_en <= 1'b0;
end

always @(posedge tx_clk or negedge tx_rstn)
begin
    if(tx_rstn == 1'b0)
        begin
            tx_interupt_req_d1 <= 1'b0;
            tx_interupt_req_d2 <= 1'b0;
            tx_interupt_req_d3 <= 1'b0;
        end
    else
        begin
            tx_interupt_req_d1 <= tx_interupt_req;
            tx_interupt_req_d2 <= tx_interupt_req_d1;
            tx_interupt_req_d3 <= tx_interupt_req_d2;
        end
end

always @(posedge tx_clk or negedge tx_rstn)
begin
    if(tx_rstn == 1'b0)
        tx_interupt <= 1'b0;
    else if(cnt_reset_dl2 == 1'b1)
        tx_interupt <= 1'b0;  
    else if((tx_interupt_req_d3 == 1'b0) && (tx_interupt_req_d2 == 1'b1))
        tx_interupt <= 1'b0;         
    else if(tx_interupt_en == 1'b1)
        tx_interupt <= 1'b1;
end

//Encryption end
endmodule
