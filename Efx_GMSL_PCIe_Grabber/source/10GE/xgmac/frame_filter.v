`timescale 1 ns / 1 ns
module frame_filter
(
//Globle Signals
input                           rx_clk,
input                           rx_clk_en,
input                           rx_rstn,
//Configuration Signals
input                           promis_en,
input                           broadcast_filter_en,
input           [47:0]          mac_addr,
input           [47:0]          mac_addr_mask,
//Filter Ctr Interface
input                           dst_addr_en,
input           [47:0]          dst_addr,
output  reg                     filter_frame_drop
//Status and  Error Signals
);
// Parameter Define 

// Register Define 
reg     [47:0]                  dst_addr_sr;
reg                             dst_addr_en_dl1;
reg                             broadcast_drop;
reg                             mac_addr_drop;

// Wire Define
wire                            addr_check_en;
wire    [47:0]                  mac_addr_xor;

/*----------------------------------------------------------------------------------*\
                                 The main code
\*----------------------------------------------------------------------------------*/
//Encryption begin
always @(posedge rx_clk or negedge rx_rstn)
begin
    if(rx_rstn == 1'b0)
        dst_addr_sr <= 48'h0;
    else if(rx_clk_en == 1'b0)
        dst_addr_sr <= dst_addr_sr;
    else if(dst_addr_en == 1'b1)
        dst_addr_sr <= dst_addr;
end

always @(posedge rx_clk or negedge rx_rstn)
begin
    if(rx_rstn == 1'b0)
        dst_addr_en_dl1 <= 1'b0;
    else if(rx_clk_en == 1'b0)
        dst_addr_en_dl1 <= dst_addr_en_dl1;
    else
        dst_addr_en_dl1 <= dst_addr_en;
end

assign addr_check_en = (dst_addr_en_dl1 == 1'b1) && (dst_addr_en == 1'b0);

/*----------------------- Broadcast Check Region ----------------------------*/
always @(posedge rx_clk or negedge rx_rstn)
begin
    if(rx_rstn == 1'b0)
        broadcast_drop <= 1'b0;
    else if(rx_clk_en == 1'b0)
        broadcast_drop <= broadcast_drop;
    else if((broadcast_filter_en == 1'b1) && (addr_check_en == 1'b1) && (dst_addr_sr == {48{1'b1}}))
        broadcast_drop <= 1'b1;
    else
        broadcast_drop <= 1'b0;
end

/*----------------------- Unicast & Multicast Check Region ----------------------------*/
assign mac_addr_xor = (mac_addr^dst_addr_sr) & mac_addr_mask;

always @(posedge rx_clk or negedge rx_rstn)
begin
    if(rx_rstn == 1'b0)
        mac_addr_drop <= 1'b0;
    else if(rx_clk_en == 1'b0)
        mac_addr_drop <= mac_addr_drop;
    else if((addr_check_en == 1'b1) && (mac_addr_xor != {48{1'b0}}) && (dst_addr_sr != {48{1'b1}}))
        mac_addr_drop <= 1'b1;
    else
        mac_addr_drop <= 1'b0;
end

/*----------------------- Filter Region ----------------------------*/
always @(posedge rx_clk or negedge rx_rstn)
begin
    if(rx_rstn == 1'b0)
        filter_frame_drop <= 1'b0;
    else if(rx_clk_en == 1'b0)
        filter_frame_drop <= filter_frame_drop;
    else if((promis_en == 1'b0) && ((broadcast_drop == 1'b1) || (mac_addr_drop == 1'b1)))
        filter_frame_drop <= 1'b1;
    else
        filter_frame_drop <= 1'b0;
end
//Encryption end
endmodule
