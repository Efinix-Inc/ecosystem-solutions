/////////////////////////////////////////////////////////////////////////////
//           _____       
//          / _______    Copyright (C) 2013-2020 Efinix Inc. All rights reserved.
//         / /       \   
//        / /  ..    /   
//       / / .'     /    
//    __/ /.'      /     
//   __   \       /      
//  /_/ /\ \_____/ /     
// ____/  \_______/      
//
// *******************************
// Revisions:
// 1.0 Initial rev
//
// *******************************
`timescale 1 ns / 1 ns
module apb3_2_axi4_lite#(
    parameter                       ADDR_WTH = 10
)
(
//Globle Signals
input                           clk,
input                           rstn,
//APB3 Slave Interface
input           [ADDR_WTH-1:0]  s_apb3_paddr,
input                           s_apb3_psel,
input                           s_apb3_penable,
output  reg                     s_apb3_pready,
input                           s_apb3_pwrite,//0:rd; 1:wr;
input           [31:0]          s_apb3_pwdata,
output  reg     [31:0]          s_apb3_prdata,
output  reg                     s_apb3_pslverror,
//AXI4-Lite Master Interface
output  reg     [ADDR_WTH-1:0]  m_axi_awaddr,//Write Address. byte address.
output  reg                     m_axi_awvalid,//Write address valid.
input                           m_axi_awready,//Write address ready.
output  reg     [31:0]          m_axi_wdata,//Write data bus.
output  reg                     m_axi_wvalid,//Write valid.
input                           m_axi_wready,//Write ready.
input           [1:0]           m_axi_bresp,//Write response.
input                           m_axi_bvalid,//Write response valid.
output  wire                    m_axi_bready,//Response ready.
output  reg     [ADDR_WTH-1:0]  m_axi_araddr,//Read address. byte address.
output  reg                     m_axi_arvalid,//Read address valid.
input                           m_axi_arready,//Read address ready.
input           [1:0]           m_axi_rresp,//Read response.
input           [31:0]          m_axi_rdata,//Read data.
input                           m_axi_rvalid,//Read valid.
output  wire                    m_axi_rready//Read ready.
);
// Parameter Define 
parameter State_idle    = 3'd0;
parameter State_wsetup  = 3'd1;
parameter State_rsetup  = 3'd2;
parameter State_ready   = 3'd3;
parameter State_err     = 3'd4;

// Register Define
reg     [2:0]                   cur_state;
reg     [2:0]                   next_state;
reg     [7:0]                   timeout_cnt;

// Wire Define

/*----------------------------------------------------------------------------------*\
                                 The main code
\*----------------------------------------------------------------------------------*/

/*----------------------- FSM Region ----------------------------*/
always @(posedge clk or negedge rstn)
begin
    if(rstn == 1'b0)
        cur_state <= State_idle;
    else
		cur_state <= next_state;
end

always @(*)
begin
	case(cur_state)
    State_idle :
        if((s_apb3_psel == 1'b1) && (s_apb3_penable == 1'b0) && (s_apb3_pwrite == 1'b1))
            next_state = State_wsetup;
        else if((s_apb3_psel == 1'b1) && (s_apb3_penable == 1'b0))
            next_state = State_rsetup;
        else
            next_state = State_idle;

    State_wsetup : 
        if((m_axi_awvalid == 1'b0) && (m_axi_wvalid == 1'b0))
            next_state = State_ready;
        else if(timeout_cnt[7] == 1'b1)
            next_state = State_err;
        else
            next_state = State_wsetup;

    State_rsetup :
        if(m_axi_rvalid == 1'b1)
            next_state = State_ready;
        else if(timeout_cnt[7] == 1'b1)
            next_state = State_err;
        else
            next_state = State_rsetup;

    State_ready :
        next_state = State_idle;

    State_err :
        next_state = State_idle;

    default :
        next_state = State_idle;
    endcase
end

always @(posedge clk or negedge rstn)
begin
    if(rstn == 1'b0)
        timeout_cnt <= 8'h0;
    else if((cur_state == State_wsetup) || (cur_state == State_rsetup))
        timeout_cnt <= timeout_cnt + 1'b1;
    else
        timeout_cnt <= 8'h0;
end

/*----------------------- APB3 Region ----------------------------*/
always @(posedge clk or negedge rstn)
begin
    if(rstn == 1'b0)
        s_apb3_pready <= 1'b0;
    else if((cur_state == State_ready) || (cur_state == State_err))
        s_apb3_pready <= 1'b1;
    else
        s_apb3_pready <= 1'b0;
end

always @(posedge clk or negedge rstn)
begin
    if(rstn == 1'b0)
        s_apb3_pslverror <= 1'b0;
    else if(cur_state == State_err)
        s_apb3_pslverror <= 1'b1;
    else
        s_apb3_pslverror <= 1'b0;
end

always @(posedge clk or negedge rstn)
begin
    if(rstn == 1'b0)
        s_apb3_prdata <= 32'h0;
    else if(m_axi_rvalid == 1'b1)
        s_apb3_prdata <= m_axi_rdata;
end

/*----------------------- AXI4-Lite Region ----------------------------*/
always @(posedge clk or negedge rstn)
begin
    if(rstn == 1'b0)
        m_axi_awaddr <= {ADDR_WTH{1'b0}};
    else if((cur_state == State_idle) && (s_apb3_psel == 1'b1) && (s_apb3_penable == 1'b0) && (s_apb3_pwrite == 1'b1))
        m_axi_awaddr <= s_apb3_paddr;
end

always @(posedge clk or negedge rstn)
begin
    if(rstn == 1'b0)
        m_axi_awvalid <= 1'b0;
    else if((cur_state == State_idle) && (s_apb3_psel == 1'b1) && (s_apb3_penable == 1'b0) && (s_apb3_pwrite == 1'b1))
        m_axi_awvalid <= 1'b1;
    else if((m_axi_awready == 1'b1) || (cur_state == State_idle))
        m_axi_awvalid <= 1'b0;
end

always @(posedge clk or negedge rstn)
begin
    if(rstn == 1'b0)
        m_axi_wdata <= 32'h0;
    else if((cur_state == State_idle) && (s_apb3_psel == 1'b1) && (s_apb3_penable == 1'b0) && (s_apb3_pwrite == 1'b1))
        m_axi_wdata <= s_apb3_pwdata;
end

always @(posedge clk or negedge rstn)
begin
    if(rstn == 1'b0)
        m_axi_wvalid <= 1'b0;
    else if((cur_state == State_idle) && (s_apb3_psel == 1'b1) && (s_apb3_penable == 1'b0) && (s_apb3_pwrite == 1'b1))
        m_axi_wvalid <= 1'b1;
    else if((m_axi_wready == 1'b1) || (cur_state == State_idle))
        m_axi_wvalid <= 1'b0;
end

assign m_axi_bready = 1'b1;

always @(posedge clk or negedge rstn)
begin
    if(rstn == 1'b0)
        m_axi_araddr <= {ADDR_WTH{1'b0}};
    else if((cur_state == State_idle) && (s_apb3_psel == 1'b1) && (s_apb3_penable == 1'b0) && (s_apb3_pwrite == 1'b0))
        m_axi_araddr <= s_apb3_paddr;
end

always @(posedge clk or negedge rstn)
begin
    if(rstn == 1'b0)
        m_axi_arvalid <= 1'b0;
    else if((cur_state == State_idle) && (s_apb3_psel == 1'b1) && (s_apb3_penable == 1'b0) && (s_apb3_pwrite == 1'b0))
        m_axi_arvalid <= 1'b1;
    else if((m_axi_arready == 1'b1) || (cur_state == State_idle))
        m_axi_arvalid <= 1'b0;
end

assign m_axi_rready = 1'b1;

endmodule
