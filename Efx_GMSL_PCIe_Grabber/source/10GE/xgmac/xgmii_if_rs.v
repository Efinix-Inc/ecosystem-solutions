module xgmii_if_rs (
//XGMII Interface
input   wire                    xgmii_rx_clk,
input   wire                    rx_rstn,
input   wire                    xgmii_tx_clk,
input   wire                    tx_rstn,

input   wire    [63:0]          xgmii_rxd,
input   wire    [7:0]           xgmii_rxc,
output  reg     [63:0]          xgmii_txd,
output  reg     [7:0]           xgmii_txc,

output  reg     [63:0]          xgmii_rs_rxd,
output  reg     [7:0]           xgmii_rs_rxc,
output  reg                     xgmii_rs_err,
input   wire    [63:0]          xgmii_rs_txd,
input   wire    [7:0]           xgmii_rs_txc,
output  reg                     xgmii_rs_tx_err
);

// Parameter Define 
localparam PREAMBLE           = 8'h55;
localparam SFD                = 8'hD5;
localparam START              = 8'hFB;
localparam IDLE               = 8'h07;
localparam LOCAL_FAULT        = 32'h0100009C;
localparam REMOTE_FAULT       = 32'h0200009C;
localparam LINK_INTERRUPT     = 32'h0300009C;

// Register Define 
reg     [6:0]                   check_128_cycle;
reg                             local_fault_rx;
reg     [3:0]                   local_fault_cnt;
reg                             local_fault_err;
reg                             remote_fault_rx;
reg     [3:0]                   remote_fault_cnt;
reg                             remote_fault_err;
reg                             link_fault_rx;
reg     [3:0]                   link_fault_cnt;
reg                             link_fault_err;
reg     [63:0]                  xgmii_rxd_d1;
reg     [7:0]                   xgmii_rxc_d1;
reg     [63:0]                  xgmii_rxd_d2;
reg     [7:0]                   xgmii_rxc_d2;
reg                             xgmii_splicing;
reg     [63:0]                  rs_rxd;
reg     [7:0]                   rs_rxc;
reg                             local_fault_err_d1; 
reg                             local_fault_err_d2; 
reg                             local_fault_err_d3; 
reg                             remote_fault_err_d1;
reg                             remote_fault_err_d2;
reg                             remote_fault_err_d3;
reg                             link_fault_err_d1;
reg                             link_fault_err_d2;
reg                             link_fault_err_d3;


// Wire Define

/*----------------------------------------------------------------------------------*\
                                 The main code
\*----------------------------------------------------------------------------------*/
//Encryption begin
/*----------------------------------------------------------------------------------*\
//rs_rx
\*----------------------------------------------------------------------------------*/

always @(posedge xgmii_rx_clk or negedge rx_rstn)
begin
    if(rx_rstn == 1'b0)
        check_128_cycle <= 7'h00;
    else
        check_128_cycle <= check_128_cycle + 1'b1;
end
/*----------------------------------------------------------------------------------*\
//local_fault_err
\*----------------------------------------------------------------------------------*/
always @(posedge xgmii_rx_clk or negedge rx_rstn)
begin
    if(rx_rstn == 1'b0)
        local_fault_rx <= 1'b0;
    else if(((xgmii_rxc[3:0] == 4'b0001) && (xgmii_rxd[31:0] == LOCAL_FAULT)) ||
            ((xgmii_rxc[7:4] == 4'b0001) && (xgmii_rxd[63:32] == LOCAL_FAULT))) 
        local_fault_rx <= 1'b1;
    else
        local_fault_rx <= 1'b0;
end

always @(posedge xgmii_rx_clk or negedge rx_rstn)
begin
    if(rx_rstn == 1'b0)
        local_fault_cnt <= 4'h0;
    else if(check_128_cycle == 7'b1111_111)
        local_fault_cnt <= 4'h0; 
    else if(local_fault_cnt == 4'b1111)
        local_fault_cnt <= 4'hf;         
    else if(local_fault_rx == 1'b1)
        local_fault_cnt <= local_fault_cnt + 1'b1;
end
/*
always @(posedge xgmii_rx_clk or negedge rx_rstn)
begin
    if(rx_rstn == 1'b0)
        local_fault_err <= 1'b0;
    else if(check_128_cycle == 7'b1111_111)
        begin
            if(local_fault_cnt >=4)
                local_fault_err <= 1'b1;
            else if(local_fault_cnt ==0)
                local_fault_err <= 1'b0;  
        end
    else;
end
*/
always @(posedge xgmii_rx_clk or negedge rx_rstn)
begin
    if(rx_rstn == 1'b0)
        local_fault_err <= 1'b0;
    else if(local_fault_cnt >=4)
        local_fault_err <= 1'b1;        
    else if((check_128_cycle == 7'b1111_111) && (local_fault_cnt ==0))
        local_fault_err <= 1'b0;  
    else;
end


/*----------------------------------------------------------------------------------*\
//remote_fault_err
\*----------------------------------------------------------------------------------*/
always @(posedge xgmii_rx_clk or negedge rx_rstn)
begin
    if(rx_rstn == 1'b0)
        remote_fault_rx <= 1'b0;
    else if(((xgmii_rxc[3:0] == 4'b0001) && (xgmii_rxd[31:0] == REMOTE_FAULT)) ||
            ((xgmii_rxc[7:4] == 4'b0001) && (xgmii_rxd[63:32] == REMOTE_FAULT))) 
        remote_fault_rx <= 1'b1;
    else
        remote_fault_rx <= 1'b0;
end

always @(posedge xgmii_rx_clk or negedge rx_rstn)
begin
    if(rx_rstn == 1'b0)
        remote_fault_cnt <= 4'h0;
    else if(check_128_cycle == 7'b1111_111)
        remote_fault_cnt <= 4'h0; 
    else if(remote_fault_cnt == 4'hf)
        remote_fault_cnt <= 4'hf;         
    else if(remote_fault_rx == 1'b1)
        remote_fault_cnt <= remote_fault_cnt + 1'b1;
end
/*
always @(posedge xgmii_rx_clk or negedge rx_rstn)
begin
    if(rx_rstn == 1'b0)
        remote_fault_err <= 1'b0;
    else if(check_128_cycle == 7'b1111_111)
        begin
            if(remote_fault_cnt >=4)
                remote_fault_err <= 1'b1;
            else if(remote_fault_cnt ==0)
                remote_fault_err <= 1'b0;  
        end
    else;
end
*/
always @(posedge xgmii_rx_clk or negedge rx_rstn)
begin
    if(rx_rstn == 1'b0)
        remote_fault_err <= 1'b0;
    else if(remote_fault_cnt >=4)
        remote_fault_err <= 1'b1;        
    else if((check_128_cycle == 7'b1111_111) && (remote_fault_cnt ==0))
        remote_fault_err <= 1'b0;  
    else;
end


/*----------------------------------------------------------------------------------*\
//link_fault_err
\*----------------------------------------------------------------------------------*/
always @(posedge xgmii_rx_clk or negedge rx_rstn)
begin
    if(rx_rstn == 1'b0)
        link_fault_rx <= 1'b0;
    else if(((xgmii_rxc[3:0] == 4'b0001) && (xgmii_rxd[31:0] == LINK_INTERRUPT)) ||
            ((xgmii_rxc[7:4] == 4'b0001) && (xgmii_rxd[63:32] == LINK_INTERRUPT))) 
        link_fault_rx <= 1'b1;
    else
        link_fault_rx <= 1'b0;
end


always @(posedge xgmii_rx_clk or negedge rx_rstn)
begin
    if(rx_rstn == 1'b0)
        link_fault_cnt <= 4'h0;
    else if(check_128_cycle == 7'b1111_111)
        link_fault_cnt <= 4'h0; 
    else if(link_fault_cnt == 4'hf)
        link_fault_cnt <= 4'hf;         
    else if(link_fault_rx == 1'b1)
        link_fault_cnt <= link_fault_cnt + 1'b1;
end
/*
always @(posedge xgmii_rx_clk or negedge rx_rstn)
begin
    if(rx_rstn == 1'b0)
        link_fault_err <= 1'b0;
    else if(check_128_cycle == 7'b1111_111)
        begin
            if(link_fault_cnt >=4)
                link_fault_err <= 1'b1;
            else if(link_fault_cnt ==0)
                link_fault_err <= 1'b0;  
        end
    else;
end
*/
always @(posedge xgmii_rx_clk or negedge rx_rstn)
begin
    if(rx_rstn == 1'b0)
        link_fault_err <= 1'b0;
    else if(link_fault_cnt >=4)
        link_fault_err <= 1'b1;        
    else if((check_128_cycle == 7'b1111_111) && (link_fault_cnt ==0))
        link_fault_err <= 1'b0;  
    else;
end

/*----------------------------------------------------------------------------------*\
//xgmii_rs_rxc   splicing
\*----------------------------------------------------------------------------------*/
always @(posedge xgmii_rx_clk )
begin
    xgmii_rxc_d1 <= xgmii_rxc;
    xgmii_rxd_d1 <= xgmii_rxd;
    xgmii_rxc_d2 <= xgmii_rxc_d1;
    xgmii_rxd_d2 <= xgmii_rxd_d1;
end


always @(posedge xgmii_rx_clk or negedge rx_rstn)
begin
    if(rx_rstn == 1'b0)
        xgmii_splicing <= 1'b0;
    else if((xgmii_rxc == 8'h01) && (xgmii_rxd == {SFD,{6{PREAMBLE}},START}))
        xgmii_splicing <= 1'b0;
    else if(((xgmii_rxc   [3:0] == 4'b0000) && (xgmii_rxd   [31:0]  == {SFD,{3{PREAMBLE}}})) &&
            ((xgmii_rxc_d1[7:4] == 4'b0001) && (xgmii_rxd_d1[63:32] == {{3{PREAMBLE}},START}))) 
        xgmii_splicing <= 1'b1;
end


always @(posedge xgmii_rx_clk or negedge rx_rstn)
begin
    if(rx_rstn == 1'b0)
        rs_rxc <= 8'b0;
    else if(xgmii_splicing == 1'b0)
        rs_rxc <= xgmii_rxc_d2;
    else
        rs_rxc <= {xgmii_rxc_d1[3:0],xgmii_rxc_d2[7:4]};
end

always @(posedge xgmii_rx_clk or negedge rx_rstn)
begin
    if(rx_rstn == 1'b0)
        rs_rxd <= 64'b0;
    else if(xgmii_splicing == 1'b0)
        rs_rxd <= xgmii_rxd_d2;
    else
        rs_rxd <= {xgmii_rxd_d1[31:0],xgmii_rxd_d2[63:32]};
end

always @(posedge xgmii_rx_clk or negedge rx_rstn)
begin
    if(rx_rstn == 1'b0)
        xgmii_rs_rxc <= 8'b0;
    else if((link_fault_err == 1'b1) || (local_fault_err == 1'b1) || (remote_fault_err == 1'b1))
        xgmii_rs_rxc <= 8'b0;
    else if((rs_rxc == 8'h01) && (rs_rxd == {SFD,{6{PREAMBLE}},START}))
        xgmii_rs_rxc <= 8'hff;
    else
        xgmii_rs_rxc <= ~rs_rxc;
end

always @(posedge xgmii_rx_clk or negedge rx_rstn)
begin
    if(rx_rstn == 1'b0)
        xgmii_rs_rxd <= 64'b0;
    else if((link_fault_err == 1'b1) || (local_fault_err == 1'b1) || (remote_fault_err == 1'b1))
        xgmii_rs_rxd <= 64'b0;        
    else if((rs_rxc == 8'h01) && (rs_rxd == {SFD,{6{PREAMBLE}},START}))
        xgmii_rs_rxd <= {SFD,{7{PREAMBLE}}};
    else
        xgmii_rs_rxd <= rs_rxd;
end
/*----------------------------------------------------------------------------------*\
//xgmii_rs_err    static register
\*----------------------------------------------------------------------------------*/
always @(posedge xgmii_rx_clk or negedge rx_rstn)
begin
    if(rx_rstn == 1'b0)
        xgmii_rs_err <= 1'b0;
    else if((link_fault_err == 1'b1) || (local_fault_err == 1'b1) || (remote_fault_err == 1'b1))
        xgmii_rs_err <= 1'b1;
    else
        xgmii_rs_err <= 1'b0;
end


/*----------------------------------------------------------------------------------*\
//xgmii_rs_txc  
\*----------------------------------------------------------------------------------*/

always @(posedge xgmii_tx_clk )
begin
    local_fault_err_d1 <= local_fault_err;
    local_fault_err_d2 <= local_fault_err_d1;
    local_fault_err_d3 <= local_fault_err_d2;
    remote_fault_err_d1 <= remote_fault_err;
    remote_fault_err_d2 <= remote_fault_err_d1;
    remote_fault_err_d3 <= remote_fault_err_d2;
    link_fault_err_d1 <= link_fault_err;
    link_fault_err_d2 <= link_fault_err_d1;
    link_fault_err_d3 <= link_fault_err_d2;
end

always @(posedge xgmii_tx_clk or negedge tx_rstn)
begin
    if(tx_rstn == 1'b0)
        xgmii_txc <= 8'b1111_1111;
    else if(local_fault_err_d3 == 1'b1)
        xgmii_txc <= 8'b0001_0001;
    else if(remote_fault_err_d3 == 1'b1)
        xgmii_txc <= 8'b1111_1111;  
    else if((xgmii_rs_txc == 8'hff) && (xgmii_rs_txd == {SFD,{7{PREAMBLE}}}))
        xgmii_txc <= 8'h01;        
    else
        xgmii_txc <= ~xgmii_rs_txc;
end

always @(posedge xgmii_tx_clk or negedge tx_rstn)
begin
    if(tx_rstn == 1'b0)
        xgmii_txd <= {8{IDLE}};
    else if(local_fault_err_d3 == 1'b1)
        xgmii_txd <= {REMOTE_FAULT,REMOTE_FAULT};
    else if(remote_fault_err_d3 == 1'b1)
        xgmii_txd <= {8{IDLE}};   
    else if((xgmii_rs_txc == 8'hff) && (xgmii_rs_txd == {SFD,{7{PREAMBLE}}}))
        xgmii_txd <= {SFD,{6{PREAMBLE}},START};        
    else
        xgmii_txd <= xgmii_rs_txd;
end

/*----------------------------------------------------------------------------------*\
//xgmii_rs_tx_err    static register
\*----------------------------------------------------------------------------------*/
always @(posedge xgmii_tx_clk or negedge tx_rstn)
begin
    if(tx_rstn == 1'b0)
        xgmii_rs_tx_err <= 1'b0;
    else if((link_fault_err_d3 == 1'b1) || (local_fault_err_d3 == 1'b1) || (remote_fault_err_d3 == 1'b1))
        xgmii_rs_tx_err <= 1'b1;
    else
        xgmii_rs_tx_err <= 1'b0;
end
//Encryption end
endmodule