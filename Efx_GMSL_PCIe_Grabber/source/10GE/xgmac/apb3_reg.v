`timescale 1 ns / 1 ns
module apb3_reg#(
    parameter                       ADDR_WTH = 10,
    parameter                       REG_WIDTH = 32,
    parameter                       VERSION = 32'h10
)
(

//Globle Signals
//
//APB3 Slave Interface
input                           s_apb3_clk,
input                           s_apb3_rstn,
input           [ADDR_WTH-1:0]  s_apb3_paddr,
input                           s_apb3_psel,
input                           s_apb3_penable,
output  reg                     s_apb3_pready,
input                           s_apb3_pwrite,//0:rd; 1:wr;
input           [31:0]          s_apb3_pwdata,
output  reg     [31:0]          s_apb3_prdata,
output  wire                    s_apb3_pslverror,
output  reg                     interrupt,
//Cfg Space Registers
//--Example Registers Field
output  reg                     tx_ena,
output  reg                     rx_ena,
output  reg                     xon_gen,
output  reg                     promis_en,
output  reg                     pad_en,
output  reg                     crc_fwd,
output  reg                     pause_ignore,
output  reg                     tx_addr_ins,
output  reg                     sw_reset,
output  reg                     loop_ena,
output  reg     [2:0]           eth_speed,
output  reg                     xoff_gen,
output  reg                     cnt_reset,
output  reg     [47:0]          mac_addr,
output  reg     [15:0]          frm_length,
output  reg     [15:0]          pause_quant,
output  reg     [5:0]           tx_ipg_length,
//--Statistics Counters Field
input                           tx_interupt,
output  reg                     tx_interupt_req,
input                           rx_interupt,
output  reg                     rx_interupt_req,
input           [REG_WIDTH-1:0] aFramesTransmittedOK,
input           [REG_WIDTH-1:0] aFramesReceivedOK,
input           [REG_WIDTH-1:0] aFramesReceivedLen,
input           [REG_WIDTH-1:0] aFrameCheckSequenceErrors,
input           [REG_WIDTH-1:0] aTxPAUSEMACCtrlFrames,
input           [REG_WIDTH-1:0] aRxPAUSEMACCtrlFrames,
input           [REG_WIDTH-1:0] ifInErrors,
input           [REG_WIDTH-1:0] ifOutErrors,
input           [REG_WIDTH-1:0] aRSReceivedLinkErrors,
input           [REG_WIDTH-1:0] aRxFilterFramesErrors,
input           [REG_WIDTH-1:0] etherStatsPkts,
input           [REG_WIDTH-1:0] etherStatsUndersizePkts,
input           [REG_WIDTH-1:0] etherStatsOversizePkts,
input           [REG_WIDTH-1:0] aTxFifoOverflowFramesErrors,
input           [REG_WIDTH-1:0] aTxIncontinuityFramesErrors,

//--Receive Supplementary Registers Field
output  reg                     broadcast_filter_en,
output  reg     [47:0]          mac_addr_mask,
//--Transmit Supplementary Registers Field
output  reg                     tx_dst_addr_ins,
output  reg     [47:0]          dst_mac_addr
);
// Parameter Define 

// Register Define
reg     [ADDR_WTH-3:0]          loc_addr;
reg                             loc_wr_vld;
reg                             loc_rd_vld;
reg     [31:0]                  loc_wdata;
reg     [1:0]                   interrupt_status;
reg     [1:0]                   interrupt_mask;
reg                             tx_interupt_d1;
reg                             tx_interupt_d2;
reg                             tx_interupt_d3;
reg                             rx_interupt_d1;
reg                             rx_interupt_d2;
reg                             rx_interupt_d3;
// Wire Define
wire    [31:0]                  command_config;
/*----------------------------------------------------------------------------------*\
                                 The main code
\*----------------------------------------------------------------------------------*/
//apb3 interface
always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
        loc_addr <= {ADDR_WTH-2{1'b0}};
	else if((s_apb3_psel == 1'b1) && (s_apb3_penable == 1'b0))
		loc_addr <= s_apb3_paddr[2+:ADDR_WTH-2];
end

always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
        loc_wr_vld <= 1'b0;
	else if((s_apb3_psel == 1'b1) && (s_apb3_penable == 1'b0) && (s_apb3_pwrite == 1'b1))
		loc_wr_vld <= 1'b1;
    else
        loc_wr_vld <= 1'b0;
end

always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
        loc_wdata <= 32'h0;
	else if((s_apb3_psel == 1'b1) && (s_apb3_penable == 1'b0) && (s_apb3_pwrite == 1'b1))
		loc_wdata <= s_apb3_pwdata;
end


always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
        loc_rd_vld <= 1'b0;
	else if((s_apb3_psel == 1'b1) && (s_apb3_penable == 1'b0) && (s_apb3_pwrite == 1'b0))
		loc_rd_vld <= 1'b1;
    else
        loc_rd_vld <= 1'b0;
end

always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
        s_apb3_pready <= 1'b0;
	else if((loc_wr_vld == 1'b1) || (loc_rd_vld == 1'b1))
		s_apb3_pready <= 1'b1;
    else
        s_apb3_pready <= 1'b0;
end

always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
        s_apb3_prdata <= 32'h0;
	else if(loc_rd_vld == 1'b1)
        begin
            case(loc_addr)
            //Base Configuration Registers Field
            'h000 : s_apb3_prdata <= VERSION;
            'h002 : s_apb3_prdata <= command_config;
            'h003 : s_apb3_prdata <= mac_addr[31:0];
            'h004 : s_apb3_prdata <= {16'h0,mac_addr[47:32]};
            'h005 : s_apb3_prdata <= {16'h0,frm_length[15:0]};
            'h006 : s_apb3_prdata <= {16'h0,pause_quant[15:0]};
            'h017 : s_apb3_prdata <= {26'h0,tx_ipg_length[5:0]};
            //Statistics Counters Field
            'h01a : s_apb3_prdata <= aFramesTransmittedOK;
            'h01b : s_apb3_prdata <= aFramesReceivedOK;
            'h01c : s_apb3_prdata <= aFrameCheckSequenceErrors;
            'h020 : s_apb3_prdata <= aTxPAUSEMACCtrlFrames;
            'h021 : s_apb3_prdata <= aRxPAUSEMACCtrlFrames;
            'h022 : s_apb3_prdata <= ifInErrors;
            'h023 : s_apb3_prdata <= ifOutErrors;
            'h027 : s_apb3_prdata <= aRxFilterFramesErrors;
            'h02d : s_apb3_prdata <= etherStatsPkts;
            'h02e : s_apb3_prdata <= etherStatsUndersizePkts;
            'h02f : s_apb3_prdata <= etherStatsOversizePkts;
            'h030 : s_apb3_prdata <= aFramesReceivedLen;
            'h031 : s_apb3_prdata <= aTxFifoOverflowFramesErrors;
            'h032 : s_apb3_prdata <= aTxIncontinuityFramesErrors;
            'h033 : s_apb3_prdata <= aRSReceivedLinkErrors;
            //interrupt 
            'h040 : s_apb3_prdata <= {31'h0,interrupt_status[0]};
            'h041 : s_apb3_prdata <= {31'h0,interrupt_mask[0]};           
            
            endcase
        end
end

assign s_apb3_pslverror = 1'b0;

always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
        interrupt <= 1'b0;
    else
        interrupt <= ((interrupt_status[0] == 1'b1) && (interrupt_mask[0] == 1'b0));// ||
//                       ((interrupt_status[1] == 1'b1) && (interrupt_mask[1] == 1'b0)));
end
/*----------------------------------------------------------------------------------*\
    Register Space -- Base Configuration Registers Field
\*----------------------------------------------------------------------------------*/

//loc_addr = 0x002; axi_addr = 0x008; RW;
always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
        begin
            tx_ena <= 1'h1;
            rx_ena <= 1'h1;
            xon_gen <= 1'h0;
            promis_en <= 1'h0;
            pad_en <= 1'h0;
            crc_fwd <= 1'h1;
            pause_ignore <= 1'h0;
            tx_addr_ins <= 1'h0;
            sw_reset <= 1'h0;
            loop_ena <= 1'h0;
            eth_speed[2:0] <= 3'h4;
            xoff_gen <= 1'h0;
            cnt_reset <= 1'h0;
        end
	else if((loc_wr_vld == 1'b1) && (loc_addr == 'h002))
        begin
            tx_ena <= loc_wdata[0];
            rx_ena <= loc_wdata[1];
            xon_gen <= loc_wdata[2];
            promis_en <= loc_wdata[4];
            pad_en <= loc_wdata[5];
            crc_fwd <= loc_wdata[6];
            pause_ignore <= loc_wdata[8];
            tx_addr_ins <= loc_wdata[9];
            sw_reset <= loc_wdata[13];
            loop_ena <= loc_wdata[15];
            eth_speed[2:0] <= loc_wdata[18:16];
            xoff_gen <= loc_wdata[22];
            cnt_reset <= loc_wdata[31];
        end
end

assign command_config = {cnt_reset,7'h0,
                         1'h0,xoff_gen,3'h0,eth_speed[2:0],
                         loop_ena,1'h0,sw_reset,3'h0,tx_addr_ins,pause_ignore,
                         1'h0,crc_fwd,pad_en,promis_en,1'h0,xon_gen,rx_ena,tx_ena};

//loc_addr = 0x003; axi_addr = 0x00c; RW;
always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
        begin
            mac_addr[31:0] <= 32'h0;
        end
	else if((loc_wr_vld == 1'b1) && (loc_addr == 'h003))
        begin
            mac_addr[31:0] <= loc_wdata[31:0];
        end
end

//loc_addr = 0x004; axi_addr = 0x010; RW;
always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
        begin
            mac_addr[47:32] <= 16'h0;
        end
	else if((loc_wr_vld == 1'b1) && (loc_addr == 'h004))
        begin
            mac_addr[47:32] <= loc_wdata[15:0];
        end
end


//loc_addr = 0x005; axi_addr = 0x014; RW;
always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
        begin
            frm_length[15:0] <= 16'h5ee;
        end
	else if((loc_wr_vld == 1'b1) && (loc_addr == 'h005))
        begin
            frm_length[15:0] <= loc_wdata[15:0];
        end
end

//loc_addr = 0x006; axi_addr = 0x018; RW;
always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
        begin
            pause_quant[15:0] <= 16'h0;
        end
	else if((loc_wr_vld == 1'b1) && (loc_addr == 'h006))
        begin
            pause_quant[15:0] <= loc_wdata[15:0];
        end
end

//loc_addr = 0x017; axi_addr = 0x05c; RW;
always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
        begin
            tx_ipg_length[5:0] <= 6'h3;
        end
	else if((loc_wr_vld == 1'b1) && (loc_addr == 'h017))
        begin
            tx_ipg_length[5:0] <= loc_wdata[5:0];
        end
end

/*----------------------------------------------------------------------------------*\
    Register Space -- Receive Supplementary Registers Field
\*----------------------------------------------------------------------------------*/
//loc_addr = 0x050; axi_addr = 0x140; RW;
always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
        begin
            broadcast_filter_en <= 1'h0;
        end
	else if((loc_wr_vld == 1'b1) && (loc_addr == 'h050))
        begin
            broadcast_filter_en <= loc_wdata[0];
        end
end

//loc_addr = 0x051; axi_addr = 0x144; RW;
always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
        begin
            mac_addr_mask[31:0] <= 32'h0;
        end
	else if((loc_wr_vld == 1'b1) && (loc_addr == 'h051))
        begin
            mac_addr_mask[31:0] <= loc_wdata[31:0];
        end
end

//loc_addr = 0x052; axi_addr = 0x148; RW;
always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
        begin
            mac_addr_mask[47:32] <= 16'h0;
        end
	else if((loc_wr_vld == 1'b1) && (loc_addr == 'h052))
        begin
            mac_addr_mask[47:32] <= loc_wdata[15:0];
        end
end

/*----------------------------------------------------------------------------------*\
    Register Space -- Transmit Supplementary Registers Field
\*----------------------------------------------------------------------------------*/
//loc_addr = 0x060; axi_addr = 0x180; RW;
always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
        begin
            tx_dst_addr_ins <= 1'h0;
        end
	else if((loc_wr_vld == 1'b1) && (loc_addr == 'h060))
        begin
            tx_dst_addr_ins <= loc_wdata[0];
        end
end

//loc_addr = 0x061; axi_addr = 0x184; RW;
always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
        begin
            dst_mac_addr[31:0] <= 32'h0;
        end
	else if((loc_wr_vld == 1'b1) && (loc_addr == 'h061))
        begin
            dst_mac_addr[31:0] <= loc_wdata[31:0];
        end
end

//loc_addr = 0x062; axi_addr = 0x188; RW;
always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
        begin
            dst_mac_addr[47:32] <= 16'h0;
        end
	else if((loc_wr_vld == 1'b1) && (loc_addr == 'h062))
        begin
            dst_mac_addr[47:32] <= loc_wdata[15:0];
        end
end

always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
    begin
        tx_interupt_d1 <= 1'b0;
        tx_interupt_d2 <= 1'b0;
        tx_interupt_d3 <= 1'b0;
        rx_interupt_d1 <= 1'b0;
        rx_interupt_d2 <= 1'b0;
        rx_interupt_d3 <= 1'b0;        
    end    
    else 
    begin
        tx_interupt_d1 <= tx_interupt;
        tx_interupt_d2 <= tx_interupt_d1;
        tx_interupt_d3 <= tx_interupt_d2;
        rx_interupt_d1 <= rx_interupt;
        rx_interupt_d2 <= rx_interupt_d1;
        rx_interupt_d3 <= rx_interupt_d2;      
    end
end

always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
        tx_interupt_req <= 1'b0;
    else if((tx_interupt_d3 == 1'b0) && (tx_interupt_d2 == 1'b1))
        tx_interupt_req <= 1'b0;         
    else if((tx_interupt_d3 == 1'b1) && (tx_interupt_d2 == 1'b0))
        tx_interupt_req <= 1'b1;
end

always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
        rx_interupt_req <= 1'b0;
    else if((rx_interupt_d3 == 1'b0) && (rx_interupt_d2 == 1'b1))
        rx_interupt_req <= 1'b0;         
    else if((rx_interupt_d3 == 1'b1) && (rx_interupt_d2 == 1'b0))
        rx_interupt_req <= 1'b1;
end
//loc_addr = 0x040; apb_addr = 0x100; RC;
//interrupt status register
//[0] - interrupt 0 register
always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
        interrupt_status <= 1'b0;
    else if((loc_wr_vld == 1'b1) && (loc_addr == 'h040) && (s_apb3_pwdata[0] == 1'b1))
        interrupt_status <= 1'b0;
    else if((!rx_interupt_d3 & rx_interupt_d2) || (!tx_interupt_d3 & tx_interupt_d2))
        interrupt_status <= 1'b1;
end

//[1] - interrupt 1 register
/*always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
        interrupt_status[1] <= 1'b0;
    else if((loc_wr_vld == 1'b1) && (loc_addr == 'h02) && (s_apb3_pwdata[1] == 1'b1))
        interrupt_status[1] <= 1'b0;
    else if(int_1_pulse == 1'b1)
        interrupt_status[1] <= 1'b1;
end
*/
//loc_addr = 0x041; axi_addr = 0x104; RW;
//interrupt mask register
always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
        interrupt_mask <= 1'b0;
	else if((loc_wr_vld == 1'b1) && (loc_addr == 'h041))
        interrupt_mask <= s_apb3_pwdata[0];
end

/*----------------------------------------------------------------------------------*\
    Register Space -- The End
\*----------------------------------------------------------------------------------*/
//Encryption end

endmodule
