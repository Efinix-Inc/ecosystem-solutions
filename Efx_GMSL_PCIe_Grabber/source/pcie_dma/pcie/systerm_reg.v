//module definition

`timescale 1 ns / 1 ns
module systerm_reg#(
    parameter                       ADDR_WTH = 10
)
(
//Globle Signals
//
//APB3 Slave Interface
input                           s_apb3_clk,
input                           s_apb3_rstn,

input           [ADDR_WTH-1:0]  s_apb3_0_paddr,
input                           s_apb3_0_psel,
input                           s_apb3_0_penable,
output                          s_apb3_0_pready,
input                           s_apb3_0_pwrite,//0:rd; 1:wr;
input           [31:0]          s_apb3_0_pwdata,
output          [31:0]          s_apb3_0_prdata,
output                          s_apb3_0_pslverror,

input           [ADDR_WTH-1:0]  s_apb3_1_paddr,
input                           s_apb3_1_psel,
input                           s_apb3_1_penable,
output                          s_apb3_1_pready,
input                           s_apb3_1_pwrite,//0:rd; 1:wr;
input           [31:0]          s_apb3_1_pwdata,
output          [31:0]          s_apb3_1_prdata,
output                          s_apb3_1_pslverror,






/*input                           s_apb3_clk,
input                           s_apb3_rstn,
input           [ADDR_WTH-1:0]  s_apb3_paddr,
input                           s_apb3_psel,
input                           s_apb3_penable,
output  reg                     s_apb3_pready,
input                           s_apb3_pwrite,//0:rd; 1:wr;
input           [31:0]          s_apb3_pwdata,
output  reg     [31:0]          s_apb3_prdata,
output  wire                    s_apb3_pslverror,*/
//Cfg Space Registers
//tx_pkt_gen config reg
output  reg                     pkt_gen_en,
output  reg     [15:0]          pkt_len,
output  reg                     pkt_sta,
output  reg     [15:0]          frame_len,
output  reg     [31:0]          frameIntv,
input                           pky_gen_busy,
//lpddr4 wr config reg

output  reg                     lpdr_wr_en,
output  reg                     lpdr_wr_busy,
output  reg     [31:0]          c_saddr_h,
output  reg     [31:0]          c_saddr_l,
output  reg     [31:0]          c_eaddr_h,
output  reg     [31:0]          c_eaddr_l,
output  reg     [31:0]          h_saddr_h,
output  reg     [31:0]          h_saddr_l,
output  reg     [31:0]          h_eaddr_h,
output  reg     [31:0]          h_eaddr_l,
input           [63:0]          desc_src_addr,
input           [63:0]          desc_dst_addr,
input           [27:0]          desc_len,
output                          desc_wr_ready,
input                           desc_wr_valid,
output          [15:0]          c2h_desc_byp_ctl,
output          [63:0]          c2h_desc_byp_dst_addr,
output          [63:0]          c2h_desc_byp_src_addr,
output          [63:0]          c2h_desc_byp_len,
output          [63:0]          c2h_desc_byp_load,
input                           c2h_desc_byp_ready,

//lpddr4 rd config reg

input                           desc_rd_ready,
output                          desc_rd_valid,
output          [31:0]          rd_saddr_h,
output          [31:0]          rd_saddr_l,
output          [27:0]          rd_size,

//rx chk config reg
input           [31:0]          check_sum,
input           [31:0]          error_sum,
input           [31:0]          err_int,
output  reg                     check_data_clear,
output  reg                     wr_rstn,

input           [15:0]          ack,

 //abp3 slave interface for system to communicate with board Logic. 
 input   [7:0]     Board_status,
 output reg [31:0]  master_Control_Input_A,
 input   [31:0]	   master_Control_Status_A,
 output reg [31:0]  master_Control_Input_B,
 input   [31:0]	   master_Control_Status_B,
 output reg [31:0]  master_Control_Input_C,
 input   [31:0]	   master_Control_Status_C

);
// Parameter Define 

// Register Define
reg     [ADDR_WTH-3:0]          loc_addr;
reg                             loc_wr_vld;
reg                             loc_rd_vld;
reg                     lpdr_rd_en;
reg     [31:0]          rd_saddr_h_i;
reg     [31:0]          rd_saddr_l_i;
reg     [27:0]          rd_size_i;
reg                     desc_en;
reg     [15:0]          interrupt_status;
reg     [15:0]          interrupt_mask;
reg     [15:0]          irq;
reg     [31:0]          s_apb3_prdata;

reg     [31:0]          desc_cnt;
reg     [31:0]          rd_cnt;

reg                     s_apb3_pready;
reg     [63:0]          wr_addr;


// Wire Define
wire                                desc_full;
wire                                desc_empty;
wire     [91:0]                     fifo_data_i;
wire     [91:0]                     fifo1_data_i;
wire     [91:0]                     fifo_data_o;
wire     [91:0]                     fifo1_data_o;
wire                                rd_en;
wire                                rd1_en;
wire                                fifo1_full;
wire                                fifo1_empty;
wire                                wr1_en;


wire    [ADDR_WTH-1:0]  s_apb3_paddr;
wire                    s_apb3_psel;
wire                    s_apb3_penable;
wire                    s_apb3_pwrite;//0:rd; 1:wr;
wire    [31:0]          s_apb3_pwdata;
wire                    s_apb3_pslverror;





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
            //Example Registers Field
            'h080 : s_apb3_prdata <= {29'h0,pkt_sta,pky_gen_busy,pkt_gen_en};//200
            'h081 : s_apb3_prdata <= {4'h0,pkt_len};//204
            'h082 : s_apb3_prdata <= {16'h0,frame_len};//208
            'h083 : s_apb3_prdata <= frameIntv;

            'h090 : s_apb3_prdata <= {30'h0,lpdr_wr_busy,lpdr_wr_en};//240
            'h091 : s_apb3_prdata <= c_saddr_h;//244
            'h092 : s_apb3_prdata <= c_saddr_l;//248
            'h093 : s_apb3_prdata <= h_saddr_h;//24c
            'h094 : s_apb3_prdata <= h_saddr_l;//250
            'h095 : s_apb3_prdata <= c_eaddr_h;//254
            'h096 : s_apb3_prdata <= c_eaddr_l;//258
            'h097 : s_apb3_prdata <= h_eaddr_h;//25c
            'h098 : s_apb3_prdata <= h_eaddr_l;//260
            'h099 : s_apb3_prdata <= {29'h0,fifo1_empty,fifo1_full,lpdr_rd_en};//264
            'h09a : s_apb3_prdata <= wr_addr[31:0];//268
            'h09b : s_apb3_prdata <= wr_addr[63:32];//26c
            'h09c : s_apb3_prdata <= c2h_desc_byp_len[27:0];//270

            'h0a0 : s_apb3_prdata <= {28'h0,wr_rstn,desc_empty,desc_full,desc_en};//280
            'h0a1 : s_apb3_prdata <= rd_saddr_h_i;
            'h0a2 : s_apb3_prdata <= rd_saddr_l_i;
            'h0a3 : s_apb3_prdata <= {4'b0,rd_size_i};
            'h0a4 : s_apb3_prdata <= rd_saddr_h;
            'h0a5 : s_apb3_prdata <= rd_saddr_l;
            'h0a6 : s_apb3_prdata <= {4'b0,rd_size};
            'h0a7 : s_apb3_prdata <= desc_cnt;
            'h0a8 : s_apb3_prdata <= rd_cnt;

            'h0b0 : s_apb3_prdata <= {31'h0,check_data_clear};
            'h0b1 : s_apb3_prdata <= check_sum;
            'h0b2 : s_apb3_prdata <= error_sum;

            'h0c0 : s_apb3_prdata <= {16'h0,interrupt_status};
            'h0c1 : s_apb3_prdata <= {16'h0,interrupt_mask};

		
	    'h0d0 : s_apb3_prdata <= {24'h0, Board_status};
            'h0d1 : s_apb3_prdata <= {24'h0, master_Control_Status_A};
            'h0d3 : s_apb3_prdata <= {24'h0, master_Control_Status_B};
	    'h0d5 : s_apb3_prdata <= {24'h0, master_Control_Status_C};

            default : s_apb3_prdata = 32'hfefefefe;
            endcase
        end
end
//可有主机控制的中断
assign s_apb3_pslverror = 1'b0;

/*----------------------------------------------------------------------------------*\
    Register Space -- Example Registers Field
\*----------------------------------------------------------------------------------*/




//loc_addr = 0x080; axi_addr = 0x200; RW;
always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
        begin
            pkt_sta <= 1'h0;
            pkt_gen_en <= 1'h0;
        end
	else if((loc_wr_vld == 1'b1) && (loc_addr == 'h080))
        begin
            pkt_sta <= s_apb3_pwdata[2];
            pkt_gen_en <= s_apb3_pwdata[0];
        end
end

//0x204
always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
        begin
            pkt_len <= 28'h0;
        end
	else if((loc_wr_vld == 1'b1) && (loc_addr == 'h081))
        begin
            pkt_len <= s_apb3_pwdata[27:0];
        end
end
//0x208
always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
        begin
            frame_len <= 16'h0;
        end
	else if((loc_wr_vld == 1'b1) && (loc_addr == 'h082))
        begin
            frame_len <= s_apb3_pwdata[15:0];
        end
end

//0x20c
always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
        begin
            frameIntv <= 32'h0;
        end
	else if((loc_wr_vld == 1'b1) && (loc_addr == 'h083))
        begin
            frameIntv <= s_apb3_pwdata;
        end
end

always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
        begin
            wr_addr <= 64'h0;
        end
	else //if(desc_wr_valid == 1'b1)
        begin
            wr_addr <= desc_src_addr;
        end
end
 


always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
        begin
            lpdr_wr_en <= 1'h0;
        end
	else if((loc_wr_vld == 1'b1) && (loc_addr == 'h090))
        begin
            lpdr_wr_en <= s_apb3_pwdata[0];
        end
end

always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
        begin
            c_saddr_h <= 32'h0;
        end
	else if((loc_wr_vld == 1'b1) && (loc_addr == 'h091))
        begin
            c_saddr_h <= s_apb3_pwdata;
        end
end

always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
        begin
            c_saddr_l <= 32'h0;
        end
	else if((loc_wr_vld == 1'b1) && (loc_addr == 'h092))
        begin
            c_saddr_l <= s_apb3_pwdata;
        end
end

always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
        begin
            h_saddr_h <= 32'h0;
        end
	else if((loc_wr_vld == 1'b1) && (loc_addr == 'h093))
        begin
            h_saddr_h <= s_apb3_pwdata;
        end
end

always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
        begin
            h_saddr_l <= 32'h0;
        end
	else if((loc_wr_vld == 1'b1) && (loc_addr == 'h094))
        begin
            h_saddr_l <= s_apb3_pwdata;
        end
end

always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
        begin
            c_eaddr_h <= 32'h0;
        end
	else if((loc_wr_vld == 1'b1) && (loc_addr == 'h095))
        begin
            c_eaddr_h <= s_apb3_pwdata;
        end
end

always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
        begin
            c_eaddr_l <= 32'h0;
        end
	else if((loc_wr_vld == 1'b1) && (loc_addr == 'h096))
        begin
            c_eaddr_l <= s_apb3_pwdata;
        end
end

always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
        begin
            h_eaddr_h <= 32'h0;
        end
	else if((loc_wr_vld == 1'b1) && (loc_addr == 'h097))
        begin
            h_eaddr_h <= s_apb3_pwdata;
        end
end

always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
        begin
            h_eaddr_l <= 32'h0;
        end
	else if((loc_wr_vld == 1'b1) && (loc_addr == 'h098))
        begin
            h_eaddr_l <= s_apb3_pwdata;
        end
end

always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
        begin
            lpdr_rd_en <= 1'h0;
        end
	else if(lpdr_rd_en == 1'h1)
        begin
            lpdr_rd_en <=1'h0;
        end
	else if((loc_wr_vld == 1'b1) && (loc_addr == 'h099))
        begin
            lpdr_rd_en <= s_apb3_pwdata[0];
        end
end

always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
        begin
            desc_en <= 1'h0;
        end
	else if(desc_en == 1'h1)
        begin
            desc_en <=1'h0;
        end
	else if((loc_wr_vld == 1'b1) && (loc_addr == 'h0a0))
        begin
            desc_en <= s_apb3_pwdata[0];
        end
end


always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
        begin
            wr_rstn <= 1'h1;
        end
	else if((loc_wr_vld == 1'b1) && (loc_addr == 'h0a0))
        begin
            wr_rstn <= s_apb3_pwdata[3];
        end
end


always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
        begin
            rd_saddr_h_i <= 32'h0;
        end
	else if((loc_wr_vld == 1'b1) && (loc_addr == 'h0a1))
        begin
            rd_saddr_h_i <= s_apb3_pwdata;
        end
end

always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
        begin
            rd_saddr_l_i <= 32'h0;
        end
	else if((loc_wr_vld == 1'b1) && (loc_addr == 'h0a2))
        begin
            rd_saddr_l_i <= s_apb3_pwdata;
        end
end

always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
        begin
            rd_size_i <= 28'h0;
        end
	else if((loc_wr_vld == 1'b1) && (loc_addr == 'h0a3))
        begin
            rd_size_i <= s_apb3_pwdata[27:0];
        end
end

always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
        begin
            desc_cnt <= 32'h0;
        end
	else if((loc_wr_vld == 1'b1) && (loc_addr == 'h0a7))
        begin
            desc_cnt <= s_apb3_pwdata;
        end
	else if(desc_en == 1'b1)
        begin
            desc_cnt <= desc_cnt + 1'b1;
        end
end

always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
        begin
            rd_cnt <= 32'h0;
        end
	else if((loc_wr_vld == 1'b1) && (loc_addr == 'h0a8))
        begin
            rd_cnt <= s_apb3_pwdata;
        end
	else if(rd_en == 1'b1)
        begin
            rd_cnt <= rd_cnt + 1'b1;
        end
end


always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
        begin
            check_data_clear <= 1'h0;
        end
	else if(check_data_clear == 1'h1)
        begin
            check_data_clear <=1'h0;
        end
	else if((loc_wr_vld == 1'b1) && (loc_addr == 'h0b0))
        begin
            check_data_clear <= s_apb3_pwdata[0];
        end
end

always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
        begin
            master_Control_Input_A <= 8'h00;
        end
	else if(check_data_clear == 1'h1)
        begin
            master_Control_Input_A <=1'h0;
        end
	else if((loc_wr_vld == 1'b1) && (loc_addr == 'h0d2))
        begin
            master_Control_Input_A <= s_apb3_pwdata[31:0];
        end
end

always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
        begin
            master_Control_Input_B <= 8'h00;
        end
	else if(check_data_clear == 1'h1)
        begin
            master_Control_Input_B <=1'h0;
        end
	else if((loc_wr_vld == 1'b1) && (loc_addr == 'h0d4))
        begin
            master_Control_Input_B <= s_apb3_pwdata[31:0];
        end
end
always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
        begin
            master_Control_Input_C <= 8'h00;
        end
	else if(check_data_clear == 1'h1)
        begin
            master_Control_Input_C <=1'h0;
        end
	else if((loc_wr_vld == 1'b1) && (loc_addr == 'h0d6))
        begin
            master_Control_Input_C <= s_apb3_pwdata[31:0];
        end
end


assign fifo_data_i = {rd_size_i,rd_saddr_h_i,rd_saddr_l_i};
assign {rd_size,rd_saddr_h,rd_saddr_l} = fifo_data_o;
assign desc_rd_valid = ~desc_empty;
assign rd_en = (desc_rd_valid == 1'b1) && (desc_rd_ready == 1'b1);

efx_fifo_wrapper#(
    .SYNC_CLK                           (1                                  ),
    .SYNC_STAGE                         (2                                  ),
    .DATA_WIDTH                         (92                                 ),
    .MODE                               ("FWFT"                             ),
    .OUTPUT_REG                         (0                                  ),
    .PROG_FULL_ASSERT                   (                                   ),
    .PROGRAMMABLE_FULL                  ("STATIC_SINGLE"                    ),
    .PROG_FULL_NEGATE                   (                                   ),
    .PROGRAMMABLE_EMPTY                 ("NONE"                             ),
    .PROG_EMPTY_ASSERT                  (0                                  ),
    .PROG_EMPTY_NEGATE                  (0                                  ),
    .OPTIONAL_FLAGS                     (1                                  ),
    .PIPELINE_REG                       (1                                  ),
    .DEPTH                              (64                                  ),
    .FAMILY                             ("TITANIUM"                         ),
    .ASYM_WIDTH_RATIO                   (4                                  ),
    .BYPASS_RESET_SYNC                  (0                                  ),
    .RAM_STYLE                          ("register"                         )
)
u1_desc_rd_fifo
(
    .almost_full_o                      (                                   ),
    .prog_full_o                        (                                   ),
    .full_o                             (desc_full                          ),
    .overflow_o                         (                                   ),
    .wr_ack_o                           (                                   ),
    .empty_o                            (desc_empty                         ),
    .almost_empty_o                     (                                   ),
    .underflow_o                        (                                   ),
    .rd_valid_o                         (                                   ),
    .rdata                              (fifo_data_o                        ),
    .clk_i                              (s_apb3_clk                         ),
    .wr_clk_i                           (                                   ),
    .rd_clk_i                           (                                   ),
    .wr_en_i                            (desc_en                            ),
    .rd_en_i                            (rd_en                              ),
    .wdata                              (fifo_data_i                        ),
    .wr_datacount_o                     (                                   ),
    .rst_busy                           (                                   ),
    .rd_datacount_o                     (                                   ),
    .a_wr_rst_i                         (                                   ),
    .a_rd_rst_i                         (                                   ),
    .a_rst_i                            (!s_apb3_rstn                       )
);


assign c2h_desc_byp_ctl = 16'h0;
assign fifo1_data_i = {desc_src_addr,desc_len};

assign {c2h_desc_byp_dst_addr,c2h_desc_byp_len} = fifo1_data_o;

efx_fifo_wrapper#(
    .SYNC_CLK                           (1                                  ),
    .SYNC_STAGE                         (2                                  ),
    .DATA_WIDTH                         (64                                 ),
    .MODE                               ("FWFT"                             ),
    .OUTPUT_REG                         (0                                  ),
    .PROG_FULL_ASSERT                   (                                   ),
    .PROGRAMMABLE_FULL                  ("STATIC_SINGLE"                    ),
    .PROG_FULL_NEGATE                   (                                   ),
    .PROGRAMMABLE_EMPTY                 ("NONE"                             ),
    .PROG_EMPTY_ASSERT                  (0                                  ),
    .PROG_EMPTY_NEGATE                  (0                                  ),
    .OPTIONAL_FLAGS                     (1                                  ),
    .PIPELINE_REG                       (1                                  ),
    .DEPTH                              (8                                 ),
    .FAMILY                             ("TITANIUM"                         ),
    .ASYM_WIDTH_RATIO                   (4                                  ),
    .BYPASS_RESET_SYNC                  (0                                  ),
    .RAM_STYLE                          ("register"                         )
)
u2_desc_wr_fifo
(
    .almost_full_o                      (                                   ),
    .prog_full_o                        (                                   ),
    .full_o                             (fifo1_full                         ),
    .overflow_o                         (                                   ),
    .wr_ack_o                           (                                   ),
    .empty_o                            (fifo1_empty                        ),
    .almost_empty_o                     (                                   ),
    .underflow_o                        (                                   ),
    .rd_valid_o                         (                                   ),
    .rdata                              (fifo1_data_o                       ),
    .clk_i                              (s_apb3_clk                         ),
    .wr_clk_i                           (                                   ),
    .rd_clk_i                           (                                   ),
    .wr_en_i                            (desc_wr_valid                      ),
    .rd_en_i                            (lpdr_rd_en                         ),
    .wdata                              (fifo1_data_i                       ),
    .wr_datacount_o                     (                                   ),
    .rst_busy                           (                                   ),
    .rd_datacount_o                     (                                   ),
    .a_wr_rst_i                         (                                   ),
    .a_rd_rst_i                         (                                   ),
    .a_rst_i                            (!s_apb3_rstn                       )
);



//*************************************irq*******************************************//

always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
        begin
            irq[0] <= 1'h0;
        end
	else if((loc_wr_vld == 1'b1) && (loc_addr == 'h0c0))
        begin
            irq[0]  <= ((interrupt_status[0] == 1'b1) && (interrupt_mask[0] == 1'b0));
        end
end

always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
        interrupt_status[0] <= 1'b0;
    else if((loc_wr_vld == 1'b1) && (loc_addr == 'h0c0))
        interrupt_status[0] <= s_apb3_pwdata[0];
    else if(ack[0] == 1'b1)
        interrupt_status[0] <= 1'b0;
    else if(err_int == 1'b1)
        interrupt_status[0] <= 1'b1;
end

genvar j;
generate
for (j=1; j<16; j=j+1)begin
    
always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
            irq[j] <= 1'h0;
	else 
            irq[j]  <= ((interrupt_status[j] == 1'b1) && (interrupt_mask[j] == 1'b0));
end

always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
        interrupt_status[j] <= 1'b0;
    else if((loc_wr_vld == 1'b1) && (loc_addr == 'h0c0))
        interrupt_status[j] <= s_apb3_pwdata[j];
    else if(ack[j] == 1'b1)
        interrupt_status[j] <= 1'b0;
end

always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
        interrupt_mask <= 16'b0;
	else if((loc_wr_vld == 1'b1) && (loc_addr == 'h0c1))
        interrupt_mask <= s_apb3_pwdata[15:0];
end

end

endgenerate



assign s_apb3_0_pready    = (s_apb3_0_psel == 1'b1) ? s_apb3_pready    : 1'b0;
assign s_apb3_0_prdata    = (s_apb3_0_psel == 1'b1) ? s_apb3_prdata    : 1'b0;
assign s_apb3_0_pslverror = (s_apb3_0_psel == 1'b1) ? s_apb3_pslverror : 1'b0;

assign s_apb3_paddr       = (s_apb3_0_psel == 1'b1) ? s_apb3_0_paddr   : s_apb3_1_paddr   ;
assign s_apb3_penable     = (s_apb3_0_psel == 1'b1) ? s_apb3_0_penable : s_apb3_1_penable   ;
assign s_apb3_pwrite      = (s_apb3_0_psel == 1'b1) ? s_apb3_0_pwrite  : s_apb3_1_pwrite  ;
assign s_apb3_pwdata      = (s_apb3_0_psel == 1'b1) ? s_apb3_0_pwdata  : s_apb3_1_pwdata  ;

assign s_apb3_psel        = s_apb3_0_psel == 1'b1 ? s_apb3_0_psel  : s_apb3_1_psel   ;


assign s_apb3_1_pready    = s_apb3_0_psel == 1'b0 ? s_apb3_pready    : 1'b0;
assign s_apb3_1_prdata    = s_apb3_0_psel == 1'b0 ? s_apb3_prdata    : 1'b0;
assign s_apb3_1_pslverror = s_apb3_0_psel == 1'b0 ? s_apb3_pslverror : 1'b0;

/*assign s_apb3_paddr       = s_apb3_0_psel == 1'b0 ? s_apb3_1_paddr   : 0   ;
assign s_apb3_penable     = s_apb3_0_psel == 1'b0 ? s_apb3_1_penable : 0   ;
assign s_apb3_pwrite      = s_apb3_0_psel == 1'b0 ? s_apb3_1_pwrite  : 0   ;*/



/*

//loc_addr = 0x081; axi_addr = 0x204; RW;
//[axi4_st_mux_select] 0:pat tx mode; 1:rx2tx loopback mode;
//[pat_mux_select] 0:udp pat; 1:mac pat;
always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
        begin
            axi4_st_mux_select <= 1'h0;
            pat_mux_select <= 1'h0;
        end
	else if((loc_wr_vld == 1'b1) && (loc_addr == 'h081))
        begin
            axi4_st_mux_select <= s_apb3_pwdata[0];
            pat_mux_select <= s_apb3_pwdata[1];
        end
end

//loc_addr = 0x082; axi_addr = 0x208; RW;
always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
        begin
            udp_pat_gen_en <= 1'h0;
            mac_pat_gen_en <= 1'h0;
        end
	else if((loc_wr_vld == 1'b1) && (loc_addr == 'h082))
        begin
            udp_pat_gen_en <= s_apb3_pwdata[0];
            mac_pat_gen_en <= s_apb3_pwdata[1];
        end
end

//loc_addr = 0x083; axi_addr = 0x20c; RW;
always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
        begin
            pat_gen_num <= 16'h0;
            pat_gen_ipg <= 16'h0;
        end
	else if((loc_wr_vld == 1'b1) && (loc_addr == 'h083))
        begin
            pat_gen_num <= s_apb3_pwdata[15:0];
            pat_gen_ipg <= s_apb3_pwdata[31:16];
        end
end

//loc_addr = 0x084; axi_addr = 0x210; RW;
always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
        begin
            pat_dst_mac[31:0] <= 32'h0;
        end
	else if((loc_wr_vld == 1'b1) && (loc_addr == 'h084))
        begin
            pat_dst_mac[31:0] <= s_apb3_pwdata[31:0];
        end
end

//loc_addr = 0x085; axi_addr = 0x214; RW;
always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
        begin
            pat_dst_mac[47:32] <= 16'h0;
        end
	else if((loc_wr_vld == 1'b1) && (loc_addr == 'h085))
        begin
            pat_dst_mac[47:32] <= s_apb3_pwdata[15:0];
        end
end

//loc_addr = 0x086; axi_addr = 0x218; RW;
always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
        begin
            pat_src_mac[31:0] <= 32'h0;
        end
	else if((loc_wr_vld == 1'b1) && (loc_addr == 'h086))
        begin
            pat_src_mac[31:0] <= s_apb3_pwdata[31:0];
        end
end

//loc_addr = 0x087; axi_addr = 0x21c; RW;
always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
        begin
            pat_src_mac[47:32] <= 16'h0;
        end
	else if((loc_wr_vld == 1'b1) && (loc_addr == 'h087))
        begin
            pat_src_mac[47:32] <= s_apb3_pwdata[15:0];
        end
end

//loc_addr = 0x088; axi_addr = 0x220; RW;
always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
        begin
            pat_mac_dlen <= 16'h0;
        end
	else if((loc_wr_vld == 1'b1) && (loc_addr == 'h088))
        begin
            pat_mac_dlen <= s_apb3_pwdata[15:0];
        end
end

//loc_addr = 0x089; axi_addr = 0x224; RW;
always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
        begin
            pat_src_ip <= 32'h0;
        end
	else if((loc_wr_vld == 1'b1) && (loc_addr == 'h089))
        begin
            pat_src_ip <= s_apb3_pwdata[31:0];
        end
end

//loc_addr = 0x08a; axi_addr = 0x228; RW;
always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
        begin
            pat_dst_ip <= 32'h0;
        end
	else if((loc_wr_vld == 1'b1) && (loc_addr == 'h08a))
        begin
            pat_dst_ip <= s_apb3_pwdata[31:0];
        end
end

//loc_addr = 0x08b; axi_addr = 0x22c; RW;
always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
        begin
            pat_src_port <= 16'h0;
            pat_dst_port <= 16'h0;
        end
	else if((loc_wr_vld == 1'b1) && (loc_addr == 'h08b))
        begin
            pat_src_port <= s_apb3_pwdata[15:0];
            pat_dst_port <= s_apb3_pwdata[31:16];
        end
end

//loc_addr = 0x08c; axi_addr = 0x230; RW;
always @(posedge s_apb3_clk or negedge s_apb3_rstn)
begin
    if(s_apb3_rstn == 1'b0)
        begin
            pat_udp_dlen <= 16'h0;
        end
	else if((loc_wr_vld == 1'b1) && (loc_addr == 'h08c))
        begin
            pat_udp_dlen <= s_apb3_pwdata[15:0];
        end
end
*/
/*----------------------------------------------------------------------------------*\
    Register Space -- The End
\*----------------------------------------------------------------------------------*/

endmodule
