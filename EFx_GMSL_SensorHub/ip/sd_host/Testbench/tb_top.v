////////////////////////////////////////////////////////////////////////////
//           _____       
//          / _______    Copyright (C) 2013-2024 Efinix Inc. All rights reserved.
//         / /       \   
//        / /  ..    /   .v
//       / / .'     /    
//    __/ /.'      /     Description:
//   __   \       /      
//  /_/ /\ \_____/ /     
// ____/  \_______/      
//
// ***********************************************************************
// Revisions:
// 1.0 Initial rev
//
// ***********************************************************************
`timescale 1 ns/100ps
module tb_top(
);
// Parameter Define 
parameter CLK_DIV = 16'd2;
parameter TSET_CASE = 1;//Values range from "1" to "5"
parameter SD_RCA = 16'h2000;
parameter BLOCK_SIZE = 12'd512;
//--ACMD41
parameter HC_HCS = 1'b0;//High Capacity Support(OCR[30]). 0:SDSC Only Host; 1:SDHC or SDXC Supported;
parameter HC_XPC = 1'b0;//XPC controls the maximum power in the default speed mode of SDXC card.
parameter HC_S18R = 1'b1;//Sends request to switch to 1.8V signaling (S18R).
parameter HC_VDD_VOLT = 24'h0;//VDD Voltage Window(OCR[23:0])
//--ACMD6
parameter HC_BUS_WTH = 2'h2;//0:1-bit; 2:4-bit;
`include "sd_host_define.vh"
// Register Define 
reg                             Reset;
reg                             clk_50m=0;
reg                             clk_100m=0;
reg                             clk_12m5=0;
reg                             sd_clk=0;
reg     [119:0]                 cmd_resp;
reg                             rd_start=0;
reg     [31:0]                  wr_data=0;
reg     [31:0]                  rd_data=0;
reg     [31:0]                  data_addr;
reg     [31:0]                  save_reg0=0;
reg     [31:0]                  save_reg1=0;
reg     [31:0]                  save_reg2=0;
reg     [31:0]                  save_reg3=0;
//--APB3 Interface
reg     [9:0]                   m_apb3_paddr=0;
reg                             m_apb3_psel=0;
reg                             m_apb3_penable=0;
reg                             m_apb3_pwrite=0;
reg     [31:0]                  m_apb3_pwdata=0;
wire    [31:0]                  m_apb3_prdata;
wire                            m_apb3_pslerror;
wire                            m_apb3_pready;

//--MEM AXI4 32 bits Interface
reg     [31:0]                  m0_axi_awaddr=0;
reg     [7:0]                   m0_axi_awlen=8'd0;
wire     [2:0]                  m0_axi_awsize;
reg     [1:0]                   m0_axi_awburst=2'b01;
reg     [2:0]                   m0_axi_awprot=3'b010;
reg     [1:0]                   m0_axi_awlock=2'b00;
reg     [3:0]                   m0_axi_awcache=4'b0011;
reg                             m0_axi_awvalid=0;
wire                            m0_axi_awready;
wire    [7:0]                   m0_axi_bid;
wire    [1:0]                   m0_axi_bresp;
wire                            m0_axi_bvalid;
reg                             m0_axi_bready=0;
reg     [ADMA_DATA_WIDTH-1:0]   m0_axi_wdata=0;
reg     [ADMA_DATA_WIDTH/8-1:0] m0_axi_wstrb={ADMA_DATA_WIDTH/8{1'b1}};
reg                             m0_axi_wlast=0;
reg                             m0_axi_wvalid=0;
wire                            m0_axi_wready;
reg     [31:0]                  m0_axi_araddr=0;
reg     [7:0]                   m0_axi_arlen=8'd0;
reg     [2:0]                   m0_axi_arsize=3'b010;
reg     [1:0]                   m0_axi_arburst=2'b01;
reg     [2:0]                   m0_axi_arprot=3'b010;
reg     [2:0]                   m0_axi_arlock=2'b00;
reg     [3:0]                   m0_axi_arcache=4'b0011;
reg                             m0_axi_arvalid=0;
wire                            m0_axi_arready;
wire    [7:0]                   m0_axi_rid;
wire    [ADMA_DATA_WIDTH-1:0]   m0_axi_rdata;
wire    [1:0]                   m0_axi_rresp;
wire                            m0_axi_rlast;
wire                            m0_axi_rvalid;
reg                             m0_axi_rready=1;
//--SD AXI4 32bits Interface
wire    [7:0]                   m1_axi_awid;
wire    [31:0]                  m1_axi_awaddr;
wire    [7:0]                   m1_axi_awlen;
wire    [2:0]                   m1_axi_awsize;
wire    [1:0]                   m1_axi_awburst;
wire                            m1_axi_awlock;
wire    [3:0]                   m1_axi_awcache;
wire    [2:0]                   m1_axi_awprot;
wire                            m1_axi_awvalid;
wire                            m1_axi_awready;
wire    [ADMA_DATA_WIDTH-1:0]   m1_axi_wdata;
wire    [ADMA_DATA_WIDTH/8-1:0] m1_axi_wstrb;
wire                            m1_axi_wlast;
wire                            m1_axi_wvalid;
wire                            m1_axi_wready;
wire    [7:0]                   m1_axi_bid;
wire    [1:0]                   m1_axi_bresp;
wire                            m1_axi_bvalid;
wire                            m1_axi_bready;
wire    [7:0]                   m1_axi_arid;
wire    [31:0]                  m1_axi_araddr;
wire    [7:0]                   m1_axi_arlen;
wire    [2:0]                   m1_axi_arsize;
wire    [1:0]                   m1_axi_arburst;
wire                            m1_axi_arlock;
wire    [3:0]                   m1_axi_arcache;
wire    [2:0]                   m1_axi_arprot;
wire                            m1_axi_arvalid;
wire                            m1_axi_arready;
wire    [7:0]                   m1_axi_rid;
wire    [ADMA_DATA_WIDTH-1:0]   m1_axi_rdata;
wire    [1:0]                   m1_axi_rresp;
wire                            m1_axi_rlast;
wire                            m1_axi_rvalid;
wire                            m1_axi_rready;
//--Master 32bits Interface
wire    [7:0]                   m_axi_awid;
wire    [31:0]                  m_axi_awaddr;
wire    [7:0]                   m_axi_awlen;
wire    [2:0]                   m_axi_awsize;
wire    [1:0]                   m_axi_awburst;
wire                            m_axi_awlock;
wire    [3:0]                   m_axi_awcache;
wire    [2:0]                   m_axi_awprot;
wire                            m_axi_awvalid;
wire                            m_axi_awready;
wire    [ADMA_DATA_WIDTH-1:0]   m_axi_wdata;
wire    [ADMA_DATA_WIDTH/8-1:0] m_axi_wstrb;
wire                            m_axi_wlast;
wire                            m_axi_wvalid;
wire                            m_axi_wready;
wire    [7:0]                   m_axi_bid;
wire    [1:0]                   m_axi_bresp;
wire                            m_axi_bvalid;
wire                            m_axi_bready;
wire    [7:0]                   m_axi_arid;
wire    [31:0]                  m_axi_araddr;
wire    [7:0]                   m_axi_arlen;
wire    [2:0]                   m_axi_arsize;
wire    [1:0]                   m_axi_arburst;
wire                            m_axi_arlock;
wire    [3:0]                   m_axi_arcache;
wire    [2:0]                   m_axi_arprot;
wire                            m_axi_arvalid;
wire                            m_axi_arready;
wire    [7:0]                   m_axi_rid;
wire    [ADMA_DATA_WIDTH-1:0]   m_axi_rdata;
wire    [1:0]                   m_axi_rresp;
wire                            m_axi_rlast;
wire                            m_axi_rvalid;
wire                            m_axi_rready;
//
wire                            sd_cmd;
wire    [3:0]                   sd_dat;
wire                            sd_cmd_i;
wire                            sd_cmd_o;
wire                            sd_cmd_oe;
wire    [3:0]                   sd_dat_i;
wire    [3:0]                   sd_dat_o;
wire                            sd_dat_oe;

assign m0_axi_awsize =  (ADMA_DATA_WIDTH == 32)? 3'b010:
                        (ADMA_DATA_WIDTH == 64)? 3'b011:
                        (ADMA_DATA_WIDTH == 128)? 3'b100:
                        (ADMA_DATA_WIDTH == 256)? 3'b101:3'b110;

//genvar i;
reg [31:0] i;
integer j=0;
//-----------------------------------------------------------------------------------//
//                                  THE Sim Behavior
//-----------------------------------------------------------------------------------//
initial
begin
	#10000000;
	$display("EFX_ERROR: Timeout! TEST FAILED ");
end


initial
    begin
	    $display("EFX_INFO: SDHC DATA R/W TEST ");
	    Reset	=1;
        data_addr = 32'h0;
	    #20		
        Reset	=0;
    	#100
        interrupt_set_task();
        apb3_wr('h01*4,{16'h1,CLK_DIV});//set clk_out_en & clk_out_div
        #1000;
        SD_initialization();
        blockWrite(0*BLOCK_SIZE,16,32'hffffffff);
        blockRead(0*BLOCK_SIZE,16);
	    //SuspendAndResume_task();
	    ADMAWrite(0*BLOCK_SIZE,2,32'h200000,32'h100);
        ADMARead(0*BLOCK_SIZE,2,32'hA00000,32'h100);
        $display("EFX_INFO: TEST PASSED ");
	    $finish;
	    
    end
    
//-----------------------------------------------------------------------------------//
//                                  THE Clock Generate
//-----------------------------------------------------------------------------------//
always clk_50m  = #(10)   ~clk_50m;
always clk_100m = #(5)    ~clk_100m;
always clk_12m5 = #(40)   ~clk_12m5;
//always clk_12m5 = #(250)   ~clk_12m5;//400K

//-----------------------------------------------------------------------------------//
//                                  THE Sim Condition
//-----------------------------------------------------------------------------------//
axi_interconnect #
(
    .S_COUNT                            (2                                  ),
    .M_COUNT                            (1                                  ),
    .DATA_WIDTH                         (ADMA_DATA_WIDTH                    ),
    .ADDR_WIDTH                         (32                                 ),
    .ID_WIDTH                           (8                                  )
)
u_axi_interconnect
(
    .clk                                (clk_50m                            ),
    .rst                                (Reset                             ),
//AXI slave interfaces
    .s_axi_awid                         ({m1_axi_awid,8'h0}                 ),
    .s_axi_awaddr                       ({m1_axi_awaddr,m0_axi_awaddr}      ), 
    .s_axi_awlen                        ({m1_axi_awlen,m0_axi_awlen}        ), 
    .s_axi_awsize                       ({m1_axi_awsize,m0_axi_awsize}      ), 
    .s_axi_awburst                      ({m1_axi_awburst,m0_axi_awburst}    ), 
    .s_axi_awlock                       ({m1_axi_awlock,m0_axi_awlock[0]}   ), 
    .s_axi_awcache                      ({m1_axi_awcache,m0_axi_awcache}    ), 
    .s_axi_awprot                       ({m1_axi_awprot,3'h0}               ), 
    .s_axi_awvalid                      ({m1_axi_awvalid,m0_axi_awvalid}    ), 
    .s_axi_awready                      ({m1_axi_awready,m0_axi_awready}    ),
    .s_axi_awqos			            (8'h0),
    .s_axi_awuser			            (2'h0), 
    .s_axi_wdata                        ({m1_axi_wdata,m0_axi_wdata}        ), 
    .s_axi_wstrb                        ({m1_axi_wstrb,m0_axi_wstrb}        ), 
    .s_axi_wlast                        ({m1_axi_wlast,m0_axi_wlast}        ), 
    .s_axi_wvalid                       ({m1_axi_wvalid,m0_axi_wvalid}      ), 
    .s_axi_wready                       ({m1_axi_wready,m0_axi_wready}      ),
    .s_axi_wuser			            (2'h0),
    .s_axi_bid                          ({m1_axi_bid,m0_axi_bid}            ),
    .s_axi_bresp                        ({m1_axi_bresp,m0_axi_bresp}        ), 
    .s_axi_bvalid                       ({m1_axi_bvalid,m0_axi_bvalid}      ), 
    .s_axi_bready                       ({m1_axi_bready,m0_axi_bready}      ),
    .s_axi_buser			            (),
    .s_axi_arid                         ({m1_axi_arid,8'h0}                 ),
    .s_axi_araddr                       ({m1_axi_araddr,m0_axi_araddr}      ), 
    .s_axi_arlen                        ({m1_axi_arlen,m0_axi_arlen}        ), 
    .s_axi_arsize                       ({m1_axi_arsize,m0_axi_arsize}      ), 
    .s_axi_arburst                      ({m1_axi_arburst,m0_axi_arburst}    ), 
    .s_axi_arlock                       ({m1_axi_arlock,m0_axi_arlock[0]}   ), 
    .s_axi_arcache                      ({m1_axi_arcache,m0_axi_arcache}    ), 
    .s_axi_arprot                       ({m1_axi_arprot,3'h0}               ), 
    .s_axi_arvalid                      ({m1_axi_arvalid,m0_axi_arvalid}    ), 
    .s_axi_arready                      ({m1_axi_arready,m0_axi_arready}    ),
    .s_axi_arqos			            (8'h0),
    .s_axi_aruser			            (2'h0),
    .s_axi_rid                          ({m1_axi_rid,m0_axi_rid}            ),
    .s_axi_rdata                        ({m1_axi_rdata,m0_axi_rdata}        ), 
    .s_axi_rresp                        ({m1_axi_rresp,m0_axi_rresp}        ), 
    .s_axi_rlast                        ({m1_axi_rlast,m0_axi_rlast}        ), 
    .s_axi_rvalid                       ({m1_axi_rvalid,m0_axi_rvalid}      ), 
    .s_axi_rready                       ({m1_axi_rready,m0_axi_rready}      ),
    .s_axi_ruser			            (),
//AXI master interfaces
    .m_axi_awid                         (m_axi_awid                         ),
    .m_axi_awaddr                       (m_axi_awaddr                       ), 
    .m_axi_awlen                        (m_axi_awlen                        ), 
    .m_axi_awsize                       (m_axi_awsize                       ), 
    .m_axi_awburst                      (m_axi_awburst                      ), 
    .m_axi_awlock                       (m_axi_awlock                       ), 
    .m_axi_awcache                      (m_axi_awcache                      ), 
    .m_axi_awprot                       (m_axi_awprot                       ), 
    .m_axi_awvalid                      (m_axi_awvalid                      ), 
    .m_axi_awready                      (m_axi_awready                      ), 
    .m_axi_awqos			            (),
    .m_axi_awregion			            (),
    .m_axi_awuser			            (),
    .m_axi_wdata                        (m_axi_wdata                        ), 
    .m_axi_wstrb                        (m_axi_wstrb                        ), 
    .m_axi_wlast                        (m_axi_wlast                        ), 
    .m_axi_wvalid                       (m_axi_wvalid                       ), 
    .m_axi_wready                       (m_axi_wready                       ),
    .m_axi_wuser			            (),
    .m_axi_bid                          (m_axi_bid                          ),
    .m_axi_bresp                        (m_axi_bresp                        ), 
    .m_axi_bvalid                       (m_axi_bvalid                       ), 
    .m_axi_bready                       (m_axi_bready                       ),
    .m_axi_buser			            (1'b0),
    .m_axi_arid                         (m_axi_arid                         ),
    .m_axi_araddr                       (m_axi_araddr                       ), 
    .m_axi_arlen                        (m_axi_arlen                        ), 
    .m_axi_arsize                       (m_axi_arsize                       ), 
    .m_axi_arburst                      (m_axi_arburst                      ), 
    .m_axi_arlock                       (m_axi_arlock                       ), 
    .m_axi_arcache                      (m_axi_arcache                      ), 
    .m_axi_arprot                       (m_axi_arprot                       ), 
    .m_axi_arvalid                      (m_axi_arvalid                      ), 
    .m_axi_arready                      (m_axi_arready                      ),
    .m_axi_arregion			            (),
    .m_axi_arqos			            (),
    .m_axi_aruser			            (),
    .m_axi_rid                          (m_axi_rid                          ),
    .m_axi_rdata                        (m_axi_rdata                        ), 
    .m_axi_rresp                        (m_axi_rresp                        ), 
    .m_axi_rlast                        (m_axi_rlast                        ), 
    .m_axi_rvalid                       (m_axi_rvalid                       ), 
    .m_axi_rready                       (m_axi_rready                       ),
    .m_axi_ruser			            (1'b0)
);

axi_ram #
(
    .DATA_WIDTH                         (ADMA_DATA_WIDTH                    ),
    .ADDR_WIDTH                         (12                                 ),
    .ID_WIDTH                           (8                                  ),
    .PIPELINE_OUTPUT                    (0                                  )
)
u_axi_ram
(
    .clk                                (clk_50m                            ),
    .rst                                (Reset                              ),
    .s_axi_awid                         (m_axi_awid                         ),
    .s_axi_awaddr                       (m_axi_awaddr                       ), 
    .s_axi_awlen                        (m_axi_awlen                        ), 
    .s_axi_awsize                       (m_axi_awsize                       ), 
    .s_axi_awburst                      (m_axi_awburst                      ), 
    .s_axi_awlock                       (m_axi_awlock                       ), 
    .s_axi_awcache                      (m_axi_awcache                      ), 
    .s_axi_awprot                       (m_axi_awprot                       ), 
    .s_axi_awvalid                      (m_axi_awvalid                      ), 
    .s_axi_awready                      (m_axi_awready                      ), 
    .s_axi_wdata                        (m_axi_wdata                        ), 
    .s_axi_wstrb                        (m_axi_wstrb                        ), 
    .s_axi_wlast                        (m_axi_wlast                        ), 
    .s_axi_wvalid                       (m_axi_wvalid                       ), 
    .s_axi_wready                       (m_axi_wready                       ), 
    .s_axi_bid                          (m_axi_bid                          ),
    .s_axi_bresp                        (m_axi_bresp                        ), 
    .s_axi_bvalid                       (m_axi_bvalid                       ), 
    .s_axi_bready                       (m_axi_bready                       ),
    .s_axi_arid                         (m_axi_arid                         ),
    .s_axi_araddr                       (m_axi_araddr                       ), 
    .s_axi_arlen                        (m_axi_arlen                        ), 
    .s_axi_arsize                       (m_axi_arsize                       ), 
    .s_axi_arburst                      (m_axi_arburst                      ), 
    .s_axi_arlock                       (m_axi_arlock                       ), 
    .s_axi_arcache                      (m_axi_arcache                      ), 
    .s_axi_arprot                       (m_axi_arprot                       ), 
    .s_axi_arvalid                      (m_axi_arvalid                      ), 
    .s_axi_arready                      (m_axi_arready                      ),
    .s_axi_rid                          (m_axi_rid                          ),
    .s_axi_rdata                        (m_axi_rdata                        ), 
    .s_axi_rresp                        (m_axi_rresp                        ), 
    .s_axi_rlast                        (m_axi_rlast                        ), 
    .s_axi_rvalid                       (m_axi_rvalid                       ), 
    .s_axi_rready                       (m_axi_rready                       )
);

//-----------------------------------------------------------------------------------//
//                                  THE DUT
//-----------------------------------------------------------------------------------//

top #(
    .ADMA_DW(ADMA_DATA_WIDTH)
) u_top (
//Globle Signals
//----pll_0
    .clk_50m                            (clk_50m                            ),
    .clk_100m                           (clk_100m                           ),
    .pll_0_locked                       (!Reset                             ),
//APB3
    .apb_paddr                          (m_apb3_paddr                       ),
    .apb_psel                           (m_apb3_psel                        ),
    .apb_penable                        (m_apb3_penable                     ),
    .apb_pready                         (m_apb3_pready                      ),
    .apb_pwrite                         (m_apb3_pwrite                      ),
    .apb_pwdata                         (m_apb3_pwdata                      ),
    .apb_prdata                         (m_apb3_prdata                      ),
    .apb_pslverror                      (m_apb3_pslerror                    ),
//AXI4
    //.m_axi_awid                         (m1_axi_awid                        ),
    .m_axi_awaddr                       (m1_axi_awaddr                      ), 
    .m_axi_awlen                        (m1_axi_awlen                       ), 
    .m_axi_awsize                       (m1_axi_awsize                      ), 
    .m_axi_awburst                      (m1_axi_awburst                     ), 
    .m_axi_awlock                       (m1_axi_awlock                      ), 
    .m_axi_awcache                      (m1_axi_awcache                     ), 
    .m_axi_awprot                       (m1_axi_awprot                      ), 
    .m_axi_awvalid                      (m1_axi_awvalid                     ), 
    .m_axi_awready                      (m1_axi_awready                     ), 
    .m_axi_wdata                        (m1_axi_wdata                       ), 
    .m_axi_wstrb                        (m1_axi_wstrb                       ), 
    .m_axi_wlast                        (m1_axi_wlast                       ), 
    .m_axi_wvalid                       (m1_axi_wvalid                      ), 
    .m_axi_wready                       (m1_axi_wready                      ),
    //.m_axi_bid                          (m1_axi_bid                         ),
    .m_axi_bresp                        (m1_axi_bresp                       ), 
    .m_axi_bvalid                       (m1_axi_bvalid                      ), 
    .m_axi_bready                       (m1_axi_bready                      ),
    //.m_axi_arid                         (m1_axi_arid                        ),
    .m_axi_araddr                       (m1_axi_araddr                      ), 
    .m_axi_arlen                        (m1_axi_arlen                       ), 
    .m_axi_arsize                       (m1_axi_arsize                      ), 
    .m_axi_arburst                      (m1_axi_arburst                     ), 
    .m_axi_arlock                       (m1_axi_arlock                      ), 
    .m_axi_arcache                      (m1_axi_arcache                     ), 
    .m_axi_arprot                       (m1_axi_arprot                      ), 
    .m_axi_arvalid                      (m1_axi_arvalid                     ), 
    .m_axi_arready                      (m1_axi_arready                     ),
    //.m_axi_rid                          (m1_axi_rid                         ),
    .m_axi_rdata                        (m1_axi_rdata                       ), 
    .m_axi_rresp                        (m1_axi_rresp                       ), 
    .m_axi_rlast                        (m1_axi_rlast                       ), 
    .m_axi_rvalid                       (m1_axi_rvalid                      ), 
    .m_axi_rready                       (m1_axi_rready                      ),
//SD Interface
    .sd_clk_hi                          (sd_clk_hi                          ),
    .sd_clk_lo                          (sd_clk_lo                          ),
    .sd_cmd_i                           (sd_cmd_i                           ),
    .sd_cmd_o                           (sd_cmd_o                           ),
    .sd_cmd_oe                          (sd_cmd_oe                          ),
    .sd_dat_i                           (sd_dat_i                           ),
    .sd_dat_o                           (sd_dat_o                           ),
    .sd_dat_oe                          (sd_dat_oe                          )
);

always @(posedge clk_100m)
begin
	sd_clk <= sd_clk_hi;
end

/*----------------------- Tri Region ----------------------------*/
assign sd_cmd = (sd_cmd_oe) ? sd_cmd_o : 1'bz;
assign sd_cmd_i = sd_cmd;

assign sd_dat = (sd_dat_oe) ? sd_dat_o : 4'hz;
assign sd_dat_i = sd_dat;

//-----------------------------------------------------------------------------------//
//                                  THE SD Model
//-----------------------------------------------------------------------------------//
sdModel u_sdModel(
    .sdClk                      (sd_clk                     ),
    .cmd                        (sd_cmd                     ),
    .dat                        (sd_dat                     )
);

//-----------------------------------------------------------------------------------//
//                                  THE Test Case Task
//-----------------------------------------------------------------------------------//
task blockWrite;//Not using DMA - WRITE BLOCK
    input [31:0] sd_addr;
    input [15:0] blk_count;
    input [31:0] sdata;
    begin
        wait(u_top.u1_sdhc.u_sdhc.u_sd_dat_ctr.cur_state == 3'd0);
        @(posedge sd_clk);
        apb3_wr('h41*4,{blk_count,4'h0,BLOCK_SIZE});//sdhc_reg - Block Size & Block Count Register

        if(blk_count == 16'd1) begin
            cmd_tx(6'd24,1'b1,sd_addr,4'h1,{1'b0,1'b0,2'h0,1'b1,1'b0});//CMD24
        end
        else begin
            cmd_tx(6'd25,1'b1,sd_addr,4'h1,{1'b1,1'b0,2'h1,1'b1,1'b0});//CMD25
        end
        get_resp_r1();

        for (i = 0; i <blk_count; i = i + 1) begin
            //Wait one block data can be written to the buffer.
            wait(u_top.u1_sdhc.u_sdhc.buffer_write_enable == 1);
            //Write One Block
            wr_data = sdata;
            dat_wr();
        end
        wait(u_top.sd_int == 1'b1);
        apb3_wr('h4c*4,32'h2);//clr transfer_complete interrupt
        $display("EFX_INFO: PIO WRITE PASSED");
    end
endtask

task blockRead;//Not using DMA - READ BLOCK
    input [31:0] sd_addr;
    input [15:0] blk_count;
    begin
        wait(u_top.u1_sdhc.u_sdhc.u_sd_dat_ctr.cur_state == 3'd0);
        @(posedge sd_clk);
        apb3_wr('h41*4,{blk_count,4'h0,BLOCK_SIZE});//sdhc_reg - Block Size & Block Count Register

        if(blk_count == 16'd1) begin
            cmd_tx(6'd17,1'b1,sd_addr,4'h1,{1'b0,1'b1,2'h0,1'b1,1'b0});//CMD17
        end
        else begin
            cmd_tx(6'd18,1'b1,sd_addr,4'h1,{1'b1,1'b1,2'h1,1'b1,1'b0});//CMD18
        end
        get_resp_r1();
        for (i = 0; i <blk_count; i = i + 1) begin
            //Wait readable block data exists in the buffer.
            wait(u_top.u1_sdhc.u_sdhc.buffer_read_enable == 1);
            //Read One Block
            dat_rd();
        end
        wait(u_top.sd_int == 1'b1);
        apb3_wr('h4c*4,32'h2);//clr transfer_complete interrupt
        $display("EFX_INFO: PIO READ PASSED");
    end
endtask

task SuspendAndResume_task;
    reg [31:0] sd_addr;
    reg [15:0] w_blk_count;
    reg [31:0] sdata;
    reg [15:0] suspend_w_blk_count;
    begin
        sd_addr = 0*BLOCK_SIZE;
        w_blk_count = 4;
        sdata = 32'h0;
        suspend_w_blk_count = 2;
        @(posedge sd_clk);
        //-----Write Block
        wait(u_top.u1_sdhc.u_sdhc.u_sd_dat_ctr.cur_state == 3'd0);
        @(posedge sd_clk);
        apb3_wr('h41*4,{w_blk_count,4'h0,BLOCK_SIZE});//sdhc_reg - Block Size & Block Count Register
        cmd_tx(6'd25,1'b1,sd_addr,4'h1,{1'b1,1'b0,2'h1,1'b1,1'b0});//CMD25
        get_resp_r1();

        wr_data = sdata;
        for (i = 0; i < w_blk_count-suspend_w_blk_count; i = i + 1) begin
            //Wait one block data can be written to the buffer.
            wait(u_top.u1_sdhc.u_sdhc.buffer_write_enable == 1);
            //Write One Block
            dat_wr();
        end
        //-----Suspend Write Block
        apb3_wr('h4a*4,{16'h1,14'h0,HC_BUS_WTH});//set stop_at_block_gap_request
        wait(u_top.sd_int == 1'b1);
        apb3_rd('h4c*4,rd_data);//read interrupt status
        if(rd_data[2] == 1'b1) begin
            apb3_wr('h4c*4,32'h4);//clr block_gap_event interrupt
            apb3_rd('h40*4,save_reg0);//Save Register(000-00Dh)
            apb3_rd('h41*4,save_reg1);//Save Register(000-00Dh)
            apb3_rd('h42*4,save_reg2);//Save Register(000-00Dh)
            apb3_rd('h43*4,save_reg3);//Save Register(000-00Dh)
        end
        wait(u_top.sd_int == 1'b1);
        apb3_rd('h4c*4,rd_data);//read interrupt status
        if(rd_data[1] == 1'b1) begin
            apb3_wr('h4c*4,32'h2);//clr transfer_complete interrupt
        end
        //-----Insert Read Block
        blockRead(sd_addr,w_blk_count-suspend_w_blk_count);

        //-----Resume Write Block
        wait(u_top.u1_sdhc.u_sdhc.u_sd_dat_ctr.cur_state == 3'd0);
        apb3_wr('h4a*4,{16'h2,14'h0,HC_BUS_WTH});//set continue_request
        wait(u_top.sd_int == 1'b1);
        apb3_wr('h4c*4,32'h1);//clr command_complete interrupt
        for (i = 0; i < suspend_w_blk_count; i = i + 1) begin
            //Wait one block data can be written to the buffer.
            wait(u_top.u1_sdhc.u_sdhc.buffer_write_enable == 1);
            //Write One Block
            dat_wr();
        end
        wait(u_top.sd_int == 1'b1);
        apb3_wr('h4c*4,32'h2);//clr transfer_complete interrupt
    end
endtask

task ADMAWrite;//Using ADMA - WRITE BLOCK
    input [31:0] sd_addr;
    input [15:0] blk_count;
    input [31:0] dma_ds_addr;//the address of descriptor table in the system memory.
    input [31:0] dma_data_addr;//the address of data in the system memory.
    reg   [31:0] mem_wdata;
    reg   [31:0] mem_addr;
    reg   [16:0] mem_len;
    begin
        
        @(posedge sd_clk)
        begin
            mem_wdata = 32'h0;
            mem_addr = dma_data_addr;
            mem_len = blk_count*BLOCK_SIZE;
        end
        for (i = 0; i < mem_len/(ADMA_DATA_WIDTH/8); i = i + 1) begin
            mem_wr(mem_addr,mem_wdata);
            mem_addr = mem_addr + (ADMA_DATA_WIDTH/8);
            mem_wdata = mem_wdata + 1;
        end

        if(ADMA_DATA_WIDTH == 32)
        begin
            mem_wr(dma_ds_addr,{mem_len[16:1],10'h0,2'b10,1'b0,3'b001});
            mem_wr(dma_ds_addr+4,dma_data_addr);
            mem_wr(dma_ds_addr+8,{mem_len[16:1],10'h0,2'b10,1'b0,3'b011});
            mem_wr(dma_ds_addr+12,dma_data_addr+mem_len[16:1]);
        end
        else if(ADMA_DATA_WIDTH == 64)
        begin
            mem_wr(dma_ds_addr,{dma_data_addr, mem_len[16:1],10'h0,2'b10,1'b0,3'b001});
            mem_wr(dma_ds_addr+8,{dma_data_addr+mem_len[16:1], mem_len[16:1],10'h0,2'b10,1'b0,3'b011});        
        end
        else if(ADMA_DATA_WIDTH == 128)
        begin
            mem_wr(dma_ds_addr,{dma_data_addr+mem_len[16:1], {mem_len[16:1],10'h0,2'b10,1'b0,3'b011}, dma_data_addr, mem_len[16:1],10'h0,2'b10,1'b0,3'b001});
        end
        else if(ADMA_DATA_WIDTH == 256)
        begin
            mem_wr(dma_ds_addr,{128'd0, dma_data_addr+mem_len[16:1], {mem_len[16:1],10'h0,2'b10,1'b0,3'b011}, dma_data_addr, mem_len[16:1],10'h0,2'b10,1'b0,3'b001});
        end
        else if(ADMA_DATA_WIDTH == 512)
        begin
            mem_wr(dma_ds_addr,{256'd0, dma_data_addr+mem_len[16:1], {mem_len[16:1],10'h0,2'b10,1'b0,3'b011}, dma_data_addr, mem_len[16:1],10'h0,2'b10,1'b0,3'b001});
        end

        wait(u_top.u1_sdhc.u_sdhc.u_sd_dat_ctr.cur_state == 3'd0);
        @(posedge sd_clk)
        begin
            apb3_wr('h56*4,dma_ds_addr);//sdhc_reg - ADMA System Address Register
            apb3_wr('h41*4,{blk_count,4'h0,BLOCK_SIZE});//sdhc_reg - Block Size & Block Count Register
        end

        if(blk_count == 16'd1) begin
            cmd_tx(6'd24,1'b1,sd_addr,4'h1,{1'b0,1'b0,2'h0,1'b1,1'b1});//CMD24
        end
        else begin
            cmd_tx(6'd25,1'b1,sd_addr,4'h1,{1'b1,1'b0,2'h1,1'b1,1'b1});//CMD25
        end
        get_resp_r1();
        //wait(u_top.sd_int == 1'b1);
        //apb3_wr('h4c*4,32'h2);//clr transfer_complete interrupt

        wait(u_top.sd_int == 1'b1);
	    $display("EFX_INFO: ADMA WRITE PASSED");
        apb3_wr('h4c*4,32'h2);//clr transfer_complete interrupt
    end
endtask

task ADMARead;//Using ADMA - Read BLOCK
    input [31:0] sd_addr;
    input [15:0] blk_count;
    input [31:0] dma_ds_addr;//the address of descriptor table in the system memory.
    input [31:0] dma_data_addr;//the address of data in the system memory.
    
    reg   [31:0] mem_addr;
    reg   [16:0] mem_len;
    begin
        
        @(posedge sd_clk)
        begin
            mem_addr = dma_data_addr;
            mem_len = blk_count*BLOCK_SIZE;
        end
 
        if(ADMA_DATA_WIDTH == 32)
        begin
            mem_wr(dma_ds_addr,{mem_len[16:1],10'h0,2'b10,1'b0,3'b001});
            mem_wr(dma_ds_addr+4,dma_data_addr);
            mem_wr(dma_ds_addr+8,{mem_len[16:1],10'h0,2'b10,1'b0,3'b011});
            mem_wr(dma_ds_addr+12,dma_data_addr+mem_len[16:1]);
        end
        else if(ADMA_DATA_WIDTH == 64)
        begin
            mem_wr(dma_ds_addr,{dma_data_addr, mem_len[16:1],10'h0,2'b10,1'b0,3'b001});
            mem_wr(dma_ds_addr+8,{dma_data_addr+mem_len[16:1], mem_len[16:1],10'h0,2'b10,1'b0,3'b011});        
        end
        else if(ADMA_DATA_WIDTH == 128)
        begin
            mem_wr(dma_ds_addr,{dma_data_addr+mem_len[16:1], {mem_len[16:1],10'h0,2'b10,1'b0,3'b011}, dma_data_addr, mem_len[16:1],10'h0,2'b10,1'b0,3'b001});
        end
        else if(ADMA_DATA_WIDTH == 256)
        begin
            mem_wr(dma_ds_addr,{128'd0, dma_data_addr+mem_len[16:1], {mem_len[16:1],10'h0,2'b10,1'b0,3'b011}, dma_data_addr, mem_len[16:1],10'h0,2'b10,1'b0,3'b001});
        end
            else if(ADMA_DATA_WIDTH == 512)
        begin
            mem_wr(dma_ds_addr,{256'd0, dma_data_addr+mem_len[16:1], {mem_len[16:1],10'h0,2'b10,1'b0,3'b011}, dma_data_addr, mem_len[16:1],10'h0,2'b10,1'b0,3'b001});
        end

        wait(u_top.u1_sdhc.u_sdhc.u_sd_dat_ctr.cur_state == 3'd0);
        @(posedge sd_clk)
        begin
            apb3_wr('h56*4,dma_ds_addr);//sdhc_reg - ADMA System Address Register
            apb3_wr('h41*4,{blk_count,4'h0,BLOCK_SIZE});//sdhc_reg - Block Size & Block Count Register
        end

        if(blk_count == 16'd1) begin
            cmd_tx(6'd17,1'b1,sd_addr,4'h1,{1'b0,1'b1,2'h0,1'b1,1'b1});//CMD17
        end
        else begin
            cmd_tx(6'd18,1'b1,sd_addr,4'h1,{1'b1,1'b1,2'h1,1'b1,1'b1});//CMD18
        end
        get_resp_r1();

        wait(u_top.sd_int == 1'b1);
	    $display("EFX_INFO: ADMA READ PASSED");
        apb3_wr('h4c*4,32'h2);//clr transfer_complete interrupt

        for (i = 0; i < mem_len/(ADMA_DATA_WIDTH/8); i = i + 1) begin
            mem_rd(mem_addr);
            mem_addr = mem_addr + (ADMA_DATA_WIDTH/8);
        end
    end
endtask
//-----------------------------------------------------------------------------------//
//                                  THE Func Task
//-----------------------------------------------------------------------------------//
task SD_initialization;
    begin
        cmd_tx(6'd0,1'b0,32'h0,4'h0,6'h0);//CMD0
//        cmd_tx(6'd8,1'b0,32'h01aa,4'h7,6'h0);
        cmd_tx(6'd55,1'b0,{SD_RCA,16'h0},4'h1,6'h0);//CMD55
        get_resp_r1();
        cmd_tx(6'd41,1'b0,{1'h0,HC_HCS,1'h0,HC_XPC,3'h0,HC_S18R,HC_VDD_VOLT},4'h3,6'h0);//ACMD41
        get_resp_r3();
        cmd_tx(6'd2,1'b0,32'h0,4'h2,6'h0);//CMD2
        cmd_tx(6'd3,1'b0,32'h0,4'h6,6'h0);//CMD3
        get_resp_r6();
        cmd_tx(6'd7,1'b0,{SD_RCA,16'h0},4'h1,6'h0);//CMD7
        get_resp_r1();
        apb3_wr('h4a*4,{30'h0,HC_BUS_WTH});//sdhc_reg - Host Control 1
        cmd_tx(6'd55,1'b0,{SD_RCA,16'h0},4'h3,6'h0);//CMD55
        get_resp_r1();
        cmd_tx(6'd6,1'b0,{30'h0,HC_BUS_WTH},4'h1,6'h0);//ACMD6
        get_resp_r1();
        cmd_tx(6'd16,1'b0,{20'h0,BLOCK_SIZE},4'h1,6'h0);//CMD16
        get_resp_r1();
    end
    $display("EFX_INFO: SD INIT DONE");
endtask

task interrupt_set_task;
    begin
        apb3_wr('h4e*4,32'hffffffcf);//sdhc_reg - Normal Interrupt Signal Enable & Error Interrupt Signal Enable
        apb3_wr('h4d*4,32'hffffffcf);//sdhc_reg - Normal Interrupt Status Enable & Error Interrupt Status Enable
    end
endtask

task suspend_task;
    begin
        apb3_wr('h4a*4,{8'h0,8'h1,16'h0});//set stop_at_block_gap_request
        wait(u_top.sd_int == 1'b1);
        apb3_rd('h4c*4,rd_data);//read interrupt status
        if(rd_data[5] == 1'b1) begin
            apb3_wr('h4c*4,32'h20);//clr buffer_read_ready interrupt
            dat_rd();
        end
        if(rd_data[2] == 1'b1) begin
            apb3_wr('h4c*4,32'h4);//clr block_gap_event interrupt
            wait(u_top.sd_int == 1'b1);
            apb3_rd('h40*4,save_reg0);//Save Register(000-00Dh)
            apb3_rd('h41*4,save_reg1);//Save Register(000-00Dh)
            apb3_rd('h42*4,save_reg2);//Save Register(000-00Dh)
            apb3_rd('h43*4,save_reg3);//Save Register(000-00Dh)
        end
        apb3_wr('h4c*4,32'h2);//clr transfer_complete interrupt
    end
endtask

task resume_task;
    begin
        apb3_wr('h4a*4,{8'h0,8'h2,16'h0});//set continue_request
    end
endtask

//-----------------------------------------------------------------------------------//
//                                  THE Base Task
//-----------------------------------------------------------------------------------//
//axi4 memory bus wr task
task mem_wr;
    input [31:0] awaddr;
    input [ADMA_DATA_WIDTH-1:0] wdata;

    begin
    @(posedge clk_50m)
    begin
        m0_axi_awaddr <= awaddr;
        m0_axi_awvalid <= 1'b1;
    end
    wait(m0_axi_awready);
    @(posedge clk_50m)
    begin
        m0_axi_awvalid <= 1'b0;
        m0_axi_wdata <= wdata;
        m0_axi_wlast <= 1'b1;
        m0_axi_wvalid <= 1'b1;
        m0_axi_bready <= 1'b1;
    end
    wait(m0_axi_wready);
    @(posedge clk_50m)
    begin
        m0_axi_wdata <= 32'h0;
        m0_axi_wlast <= 1'b0;
        m0_axi_wvalid <= 1'b0;
    end
    wait(m0_axi_bvalid);
    @(posedge clk_50m)
    begin
        m0_axi_bready <= 1'b0;
    end
    end
endtask

//axi4 memory bus wr task
task mem_rd;
    input [31:0] araddr;

    begin
    @(posedge clk_50m)
    begin
        m0_axi_araddr <= araddr;
        m0_axi_arvalid <= 1'b1;
    end
    wait(m0_axi_arready);
    @(posedge clk_50m)
    begin
        m0_axi_arvalid <= 1'b0;
    end
    end
endtask

//apb3 bus wr task
task apb3_wr;
    input [9:0] awaddr;
    input [31:0] wdata;

    begin
    @(posedge clk_50m)
    begin
        m_apb3_paddr <= awaddr;
        m_apb3_pwrite <= 1'b1;
        m_apb3_psel <= 1'b1;
        m_apb3_pwdata <= wdata;
    end
    @(posedge clk_50m)
    begin
        m_apb3_penable <= 1;
    end
    wait(m_apb3_pready);
    @(posedge clk_50m)
    begin
        m_apb3_paddr <= 0;
        m_apb3_pwrite <= 0;
        m_apb3_psel <= 0;
        m_apb3_pwdata <= 1'b0;
        m_apb3_penable <= 0;
    end
    @(posedge clk_50m);
    end
endtask

//apb3 bus rd task
task apb3_rd;
    input [9:0] araddr;
    output reg [31:0] rdata;

    begin
    @(posedge clk_50m)
    begin
        m_apb3_paddr <= araddr;
        m_apb3_pwrite <= 1'b0;
        m_apb3_psel <= 1'b1;
    end
    @(posedge clk_50m)
    begin
        m_apb3_penable <= 1;
    end
    wait(m_apb3_pready);
        rdata <= u_top.apb_prdata   [0*32 +: 1*32];
    @(posedge clk_50m)
    begin
        m_apb3_paddr <= 0;
        m_apb3_pwrite <= 0;
        m_apb3_psel <= 0;
        m_apb3_penable <= 0;
    end
    @(posedge clk_50m);
    end
endtask

task get_resp_r1;
    reg AKE_SEQ_ERROR;
    reg APP_CMD;
    reg READY_FOR_DATA;
    reg [12:9] CURRENT_STATE;
    reg ERASE_RESET;
    reg CARD_ECC_DISABLED;
    reg WP_ERASE_SKIP;
    reg CSD_OVERWRITE;
    reg ERROR;
    reg CC_ERROR;
    reg CARD_ECC_FAILED;
    reg ILLEGAL_COMMAND;
    reg COM_CRC_ERROR;
    reg LOCK_UNLOCK_FAILED;
    reg CARD_IS_LOCKED;
    reg WP_VIOLATION;
    reg ERASE_PARAM;
    reg ERASE_SEQ_ERROR;
    reg BLOCK_LEN_ERROR;
    reg ADDRESS_ERROR;
    reg OUT_OF_RANGE;

    @(posedge sd_clk)
    begin
        AKE_SEQ_ERROR <= cmd_resp[3];
        APP_CMD <= cmd_resp[5];
        READY_FOR_DATA <= cmd_resp[8];
        CURRENT_STATE <= cmd_resp[12:9];
        ERASE_RESET <= cmd_resp[13];
        CARD_ECC_DISABLED <= cmd_resp[14];
        WP_ERASE_SKIP <= cmd_resp[15];
        CSD_OVERWRITE <= cmd_resp[16];
        ERROR <= cmd_resp[19];
        CC_ERROR <= cmd_resp[20];
        CARD_ECC_FAILED <= cmd_resp[21];
        ILLEGAL_COMMAND <= cmd_resp[22];
        COM_CRC_ERROR <= cmd_resp[23];
        LOCK_UNLOCK_FAILED <= cmd_resp[24];
        CARD_IS_LOCKED <= cmd_resp[25];
        WP_VIOLATION <= cmd_resp[26];
        ERASE_PARAM <= cmd_resp[27];
        ERASE_SEQ_ERROR <= cmd_resp[28];
        BLOCK_LEN_ERROR <= cmd_resp[29];
        ADDRESS_ERROR <= cmd_resp[30];
        OUT_OF_RANGE <= cmd_resp[31];
    end
endtask

task get_resp_r3;
    reg [23:15] VOLTAGE;
    reg S18A;
    reg UHS_II_Card_Status;
    reg Card_Capacity_Status;//This bit is valid only when the card power up status bit is set.
    reg Card_power_up_status_bit;//This bit is set to LOW if the card has not finished the power up routine.

    begin
    @(posedge sd_clk);
    VOLTAGE <= cmd_resp[23:15];
    S18A <= cmd_resp[24];
    UHS_II_Card_Status <= cmd_resp[29];
    Card_Capacity_Status <= cmd_resp[30];
    Card_power_up_status_bit <= cmd_resp[31];
    end
endtask

task get_resp_r6;
    reg AKE_SEQ_ERROR;
    reg APP_CMD;
    reg READY_FOR_DATA;
    reg [12:9] CURRENT_STATE;
    reg ERROR;
    reg ILLEGAL_COMMAND;
    reg COM_CRC_ERROR;
    reg [31:16] RCA;

    begin
    @(posedge sd_clk);
    AKE_SEQ_ERROR <= cmd_resp[3];
    APP_CMD <= cmd_resp[5];
    READY_FOR_DATA <= cmd_resp[8];
    CURRENT_STATE <= cmd_resp[12:9];
    ERROR <= cmd_resp[13];
    ILLEGAL_COMMAND <= cmd_resp[14];
    COM_CRC_ERROR <= cmd_resp[15];
    RCA <= cmd_resp[31:16];
    end
endtask

//cmd tx task
task cmd_tx;
    input [5:0] index;
    input        adtc;
    input [31:0] argument;
    //[resp] - 4bits
    //0000b : No Response.
    //0xxxb : "Rx" (R1,R2,R3,R4,R5,R6,R7) e.g. R1=0001b;
    //1xxxb : "Rxb" (R1b,R5b) e.g. R5b=1101b;
    input [3:0] resp;
    input [5:0] tfr_mode;
    reg data_present_select;

    begin
    wait(u_top.u1_sdhc.u_sdhc.cmd_busy == 1'b0);
    apb3_wr('h42*4,argument);//sdhc_reg - Argument 1 Register
    //resp_type - 000b:No Response; 001b:R2; 010 b:R3,R4; 110b:R1,R5,R6,R7; 011b:R1b,R5b;
    case(resp)
    4'h0 ://No Response
        //                                   index_chk crc_chk       resp_type
        apb3_wr('h43*4,{2'h0,index,2'h0,adtc,1'b0,     1'b0,   1'b0, 2'h0,     10'h0,tfr_mode});
    4'h2 ://R2
        //                                   index_chk crc_chk       resp_type
        apb3_wr('h43*4,{2'h0,index,2'h0,adtc,1'b0,     1'b1,   1'b0, 2'h1,     10'h0,tfr_mode});
    4'h3 ://R3
        //                                   index_chk crc_chk       resp_type
        apb3_wr('h43*4,{2'h0,index,2'h0,adtc,1'b0,     1'b0,   1'b0, 2'h2,     10'h0,tfr_mode});
    4'h4 ://R4
        //                                   index_chk crc_chk       resp_type
        apb3_wr('h43*4,{2'h0,index,2'h0,adtc,1'b0,     1'b0,   1'b0, 2'h2,     10'h0,tfr_mode});
    4'h1 ://R1
        //                                   index_chk crc_chk       resp_type
        apb3_wr('h43*4,{2'h0,index,2'h0,adtc,1'b1,     1'b1,   1'b0, 2'h2,     10'h0,tfr_mode});
    4'h5 ://R5
        //                                   index_chk crc_chk       resp_type
        apb3_wr('h43*4,{2'h0,index,2'h0,adtc,1'b1,     1'b1,   1'b0, 2'h2,     10'h0,tfr_mode});
    4'h6 ://R6
        //                                   index_chk crc_chk       resp_type
        apb3_wr('h43*4,{2'h0,index,2'h0,adtc,1'b1,     1'b1,   1'b0, 2'h2,     10'h0,tfr_mode});
    4'h7 ://R7
        //                                   index_chk crc_chk       resp_type
        apb3_wr('h43*4,{2'h0,index,2'h0,adtc,1'b1,     1'b1,   1'b0, 2'h2,     10'h0,tfr_mode});
    4'h9 ://R1b
        //                                   index_chk crc_chk       resp_type
        apb3_wr('h43*4,{2'h0,index,2'h0,adtc,1'b1,     1'b1,   1'b0, 2'h3,     10'h0,tfr_mode});
    4'hd ://R5b
        //                                   index_chk crc_chk       resp_type
        apb3_wr('h43*4,{2'h0,index,2'h0,adtc,1'b1,     1'b1,   1'b0, 2'h3,     10'h0,tfr_mode});
    endcase
    wait(u_top.sd_int == 1'b1);
    apb3_wr('h4c*4,32'h1);//clr command_complete interrupt
    if(resp == 4'h2) begin
        apb3_rd('h44*4,cmd_resp[31:0]);
        apb3_rd('h45*4,cmd_resp[63:32]);
        apb3_rd('h46*4,cmd_resp[95:64]);
        apb3_rd('h47*4,cmd_resp[119:96]);
    end else if(resp != 4'h0) begin
        apb3_rd('h44*4,cmd_resp[31:0]);
        apb3_rd('h45*4,cmd_resp[63:32]);
    end
    end
endtask

//data read task
task dat_rd;
    reg [15:0] i;

    for (i = 0; i <BLOCK_SIZE/4; i = i + 1) begin
        apb3_rd('h48*4,rd_data);//sdhc_reg - buffer_data_port Register
        #100;
    end

endtask

//data write task
task dat_wr;
    reg [15:0] i;

    for (i = 0; i <BLOCK_SIZE/4; i = i + 1) begin
        apb3_wr('h48*4,wr_data);//sdhc_reg - buffer_data_port Register
        wr_data = wr_data + 1;
        #100;
    end

endtask



endmodule
////////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2013-2024 Efinix Inc. All rights reserved.              
//
// This   document  contains  proprietary information  which   is        
// protected by  copyright. All rights  are reserved.  This notice       
// refers to original work by Efinix, Inc. which may be derivitive       
// of other work distributed under license of the authors.  In the       
// case of derivative work, nothing in this notice overrides the         
// original author's license agreement.  Where applicable, the           
// original license agreement is included in it's original               
// unmodified form immediately below this header.                        
//
// WARRANTY DISCLAIMER.                                                  
//     THE  DESIGN, CODE, OR INFORMATION ARE PROVIDED “AS IS” AND        
//     EFINIX MAKES NO WARRANTIES, EXPRESS OR IMPLIED WITH               
//     RESPECT THERETO, AND EXPRESSLY DISCLAIMS ANY IMPLIED WARRANTIES,  
//     INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF          
//     MERCHANTABILITY, NON-INFRINGEMENT AND FITNESS FOR A PARTICULAR    
//     PURPOSE.  SOME STATES DO NOT ALLOW EXCLUSIONS OF AN IMPLIED       
//     WARRANTY, SO THIS DISCLAIMER MAY NOT APPLY TO LICENSEE.           
//
// LIMITATION OF LIABILITY.                                              
//     NOTWITHSTANDING ANYTHING TO THE CONTRARY, EXCEPT FOR BODILY       
//     INJURY, EFINIX SHALL NOT BE LIABLE WITH RESPECT TO ANY SUBJECT    
//     MATTER OF THIS AGREEMENT UNDER TORT, CONTRACT, STRICT LIABILITY   
//     OR ANY OTHER LEGAL OR EQUITABLE THEORY (I) FOR ANY INDIRECT,      
//     SPECIAL, INCIDENTAL, EXEMPLARY OR CONSEQUENTIAL DAMAGES OF ANY    
//     CHARACTER INCLUDING, WITHOUT LIMITATION, DAMAGES FOR LOSS OF      
//     GOODWILL, DATA OR PROFIT, WORK STOPPAGE, OR COMPUTER FAILURE OR   
//     MALFUNCTION, OR IN ANY EVENT (II) FOR ANY AMOUNT IN EXCESS, IN    
//     THE AGGREGATE, OF THE FEE PAID BY LICENSEE TO EFINIX HEREUNDER    
//     (OR, IF THE FEE HAS BEEN WAIVED, $100), EVEN IF EFINIX SHALL HAVE 
//     BEEN INFORMED OF THE POSSIBILITY OF SUCH DAMAGES.  SOME STATES DO 
//     NOT ALLOW THE EXCLUSION OR LIMITATION OF INCIDENTAL OR            
//     CONSEQUENTIAL DAMAGES, SO THIS LIMITATION AND EXCLUSION MAY NOT   
//     APPLY TO LICENSEE.
//
////////////////////////////////////////////////////////////////////////////////
