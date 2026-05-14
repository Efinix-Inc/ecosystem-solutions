// Generator : SpinalHDL dev    git head : dc12986f7be901bf780d3c1a429753f75032cd6d
// Component : axi2apb3

`timescale 1ns/1ps

module axi2apb3 (
  input  wire          s_axi_awvalid,
  output wire          s_axi_awready,
  input  wire [31:0]   s_axi_awaddr,
  input  wire [3:0]    s_axi_awregion,
  input  wire [7:0]    s_axi_awlen,
  input  wire [2:0]    s_axi_awsize,
  input  wire [0:0]    s_axi_awlock,
  input  wire [3:0]    s_axi_awcache,
  input  wire [3:0]    s_axi_awqos,
  input  wire [2:0]    s_axi_awprot,
  input  wire          s_axi_wvalid,
  output wire          s_axi_wready,
  input  wire [255:0]  s_axi_wdata,
  input  wire [31:0]   s_axi_wstrb,
  input  wire          s_axi_wlast,
  output wire          s_axi_bvalid,
  input  wire          s_axi_bready,
  output wire [1:0]    s_axi_bresp,
  input  wire          s_axi_arvalid,
  output wire          s_axi_arready,
  input  wire [31:0]   s_axi_araddr,
  input  wire [3:0]    s_axi_arregion,
  input  wire [7:0]    s_axi_arlen,
  input  wire [2:0]    s_axi_arsize,
  input  wire [0:0]    s_axi_arlock,
  input  wire [3:0]    s_axi_arcache,
  input  wire [3:0]    s_axi_arqos,
  input  wire [2:0]    s_axi_arprot,
  output wire          s_axi_rvalid,
  input  wire          s_axi_rready,
  output wire [255:0]  s_axi_rdata,
  output wire [1:0]    s_axi_rresp,
  output wire          s_axi_rlast,
  output wire [31:0]   m_apb3_PADDR,
  output wire [0:0]    m_apb3_PSEL,
  output wire          m_apb3_PENABLE,
  input  wire          m_apb3_PREADY,
  output wire          m_apb3_PWRITE,
  output wire [31:0]   m_apb3_PWDATA,
  input  wire [31:0]   m_apb3_PRDATA,
  input  wire          m_apb3_PSLVERROR,
  input  wire          clk,
  input  wire          reset
);

  wire                ac_io_axi_arw_payload_write;
  wire                downsizer_io_input_ar_ready;
  wire                downsizer_io_input_aw_ready;
  wire                downsizer_io_input_w_ready;
  wire                downsizer_io_input_r_valid;
  wire       [255:0]  downsizer_io_input_r_payload_data;
  wire       [1:0]    downsizer_io_input_r_payload_resp;
  wire                downsizer_io_input_r_payload_last;
  wire                downsizer_io_input_b_valid;
  wire       [1:0]    downsizer_io_input_b_payload_resp;
  wire                downsizer_io_output_ar_valid;
  wire       [31:0]   downsizer_io_output_ar_payload_addr;
  wire       [3:0]    downsizer_io_output_ar_payload_region;
  wire       [7:0]    downsizer_io_output_ar_payload_len;
  wire       [2:0]    downsizer_io_output_ar_payload_size;
  wire       [0:0]    downsizer_io_output_ar_payload_lock;
  wire       [3:0]    downsizer_io_output_ar_payload_cache;
  wire       [3:0]    downsizer_io_output_ar_payload_qos;
  wire       [2:0]    downsizer_io_output_ar_payload_prot;
  wire                downsizer_io_output_aw_valid;
  wire       [31:0]   downsizer_io_output_aw_payload_addr;
  wire       [3:0]    downsizer_io_output_aw_payload_region;
  wire       [7:0]    downsizer_io_output_aw_payload_len;
  wire       [2:0]    downsizer_io_output_aw_payload_size;
  wire       [0:0]    downsizer_io_output_aw_payload_lock;
  wire       [3:0]    downsizer_io_output_aw_payload_cache;
  wire       [3:0]    downsizer_io_output_aw_payload_qos;
  wire       [2:0]    downsizer_io_output_aw_payload_prot;
  wire                downsizer_io_output_w_valid;
  wire       [31:0]   downsizer_io_output_w_payload_data;
  wire       [3:0]    downsizer_io_output_w_payload_strb;
  wire                downsizer_io_output_w_payload_last;
  wire                downsizer_io_output_r_ready;
  wire                downsizer_io_output_b_ready;
  wire                ac_io_axi_arw_ready;
  wire                ac_io_axi_w_ready;
  wire                ac_io_axi_b_valid;
  wire       [1:0]    ac_io_axi_b_payload_resp;
  wire                ac_io_axi_r_valid;
  wire       [31:0]   ac_io_axi_r_payload_data;
  wire       [1:0]    ac_io_axi_r_payload_resp;
  wire                ac_io_axi_r_payload_last;
  wire       [31:0]   ac_io_apb_PADDR;
  wire       [0:0]    ac_io_apb_PSEL;
  wire                ac_io_apb_PENABLE;
  wire                ac_io_apb_PWRITE;
  wire       [31:0]   ac_io_apb_PWDATA;
  wire                streamArbiter_io_inputs_0_ready;
  wire                streamArbiter_io_inputs_1_ready;
  wire                streamArbiter_io_output_valid;
  wire       [31:0]   streamArbiter_io_output_payload_addr;
  wire       [3:0]    streamArbiter_io_output_payload_region;
  wire       [7:0]    streamArbiter_io_output_payload_len;
  wire       [2:0]    streamArbiter_io_output_payload_size;
  wire       [0:0]    streamArbiter_io_output_payload_lock;
  wire       [3:0]    streamArbiter_io_output_payload_cache;
  wire       [3:0]    streamArbiter_io_output_payload_qos;
  wire       [2:0]    streamArbiter_io_output_payload_prot;
  wire       [0:0]    streamArbiter_io_chosen;
  wire       [1:0]    streamArbiter_io_chosenOH;

  axi2apb3_Axi4Downsizer downsizer (
    .io_input_aw_valid           (s_axi_awvalid                             ), //i
    .io_input_aw_ready           (downsizer_io_input_aw_ready               ), //o
    .io_input_aw_payload_addr    (s_axi_awaddr[31:0]                        ), //i
    .io_input_aw_payload_region  (s_axi_awregion[3:0]                       ), //i
    .io_input_aw_payload_len     (s_axi_awlen[7:0]                          ), //i
    .io_input_aw_payload_size    (s_axi_awsize[2:0]                         ), //i
    .io_input_aw_payload_lock    (s_axi_awlock                              ), //i
    .io_input_aw_payload_cache   (s_axi_awcache[3:0]                        ), //i
    .io_input_aw_payload_qos     (s_axi_awqos[3:0]                          ), //i
    .io_input_aw_payload_prot    (s_axi_awprot[2:0]                         ), //i
    .io_input_w_valid            (s_axi_wvalid                              ), //i
    .io_input_w_ready            (downsizer_io_input_w_ready                ), //o
    .io_input_w_payload_data     (s_axi_wdata[255:0]                        ), //i
    .io_input_w_payload_strb     (s_axi_wstrb[31:0]                         ), //i
    .io_input_w_payload_last     (s_axi_wlast                               ), //i
    .io_input_b_valid            (downsizer_io_input_b_valid                ), //o
    .io_input_b_ready            (s_axi_bready                              ), //i
    .io_input_b_payload_resp     (downsizer_io_input_b_payload_resp[1:0]    ), //o
    .io_input_ar_valid           (s_axi_arvalid                             ), //i
    .io_input_ar_ready           (downsizer_io_input_ar_ready               ), //o
    .io_input_ar_payload_addr    (s_axi_araddr[31:0]                        ), //i
    .io_input_ar_payload_region  (s_axi_arregion[3:0]                       ), //i
    .io_input_ar_payload_len     (s_axi_arlen[7:0]                          ), //i
    .io_input_ar_payload_size    (s_axi_arsize[2:0]                         ), //i
    .io_input_ar_payload_lock    (s_axi_arlock                              ), //i
    .io_input_ar_payload_cache   (s_axi_arcache[3:0]                        ), //i
    .io_input_ar_payload_qos     (s_axi_arqos[3:0]                          ), //i
    .io_input_ar_payload_prot    (s_axi_arprot[2:0]                         ), //i
    .io_input_r_valid            (downsizer_io_input_r_valid                ), //o
    .io_input_r_ready            (s_axi_rready                              ), //i
    .io_input_r_payload_data     (downsizer_io_input_r_payload_data[255:0]  ), //o
    .io_input_r_payload_resp     (downsizer_io_input_r_payload_resp[1:0]    ), //o
    .io_input_r_payload_last     (downsizer_io_input_r_payload_last         ), //o
    .io_output_aw_valid          (downsizer_io_output_aw_valid              ), //o
    .io_output_aw_ready          (streamArbiter_io_inputs_1_ready           ), //i
    .io_output_aw_payload_addr   (downsizer_io_output_aw_payload_addr[31:0] ), //o
    .io_output_aw_payload_region (downsizer_io_output_aw_payload_region[3:0]), //o
    .io_output_aw_payload_len    (downsizer_io_output_aw_payload_len[7:0]   ), //o
    .io_output_aw_payload_size   (downsizer_io_output_aw_payload_size[2:0]  ), //o
    .io_output_aw_payload_lock   (downsizer_io_output_aw_payload_lock       ), //o
    .io_output_aw_payload_cache  (downsizer_io_output_aw_payload_cache[3:0] ), //o
    .io_output_aw_payload_qos    (downsizer_io_output_aw_payload_qos[3:0]   ), //o
    .io_output_aw_payload_prot   (downsizer_io_output_aw_payload_prot[2:0]  ), //o
    .io_output_w_valid           (downsizer_io_output_w_valid               ), //o
    .io_output_w_ready           (ac_io_axi_w_ready                         ), //i
    .io_output_w_payload_data    (downsizer_io_output_w_payload_data[31:0]  ), //o
    .io_output_w_payload_strb    (downsizer_io_output_w_payload_strb[3:0]   ), //o
    .io_output_w_payload_last    (downsizer_io_output_w_payload_last        ), //o
    .io_output_b_valid           (ac_io_axi_b_valid                         ), //i
    .io_output_b_ready           (downsizer_io_output_b_ready               ), //o
    .io_output_b_payload_resp    (ac_io_axi_b_payload_resp[1:0]             ), //i
    .io_output_ar_valid          (downsizer_io_output_ar_valid              ), //o
    .io_output_ar_ready          (streamArbiter_io_inputs_0_ready           ), //i
    .io_output_ar_payload_addr   (downsizer_io_output_ar_payload_addr[31:0] ), //o
    .io_output_ar_payload_region (downsizer_io_output_ar_payload_region[3:0]), //o
    .io_output_ar_payload_len    (downsizer_io_output_ar_payload_len[7:0]   ), //o
    .io_output_ar_payload_size   (downsizer_io_output_ar_payload_size[2:0]  ), //o
    .io_output_ar_payload_lock   (downsizer_io_output_ar_payload_lock       ), //o
    .io_output_ar_payload_cache  (downsizer_io_output_ar_payload_cache[3:0] ), //o
    .io_output_ar_payload_qos    (downsizer_io_output_ar_payload_qos[3:0]   ), //o
    .io_output_ar_payload_prot   (downsizer_io_output_ar_payload_prot[2:0]  ), //o
    .io_output_r_valid           (ac_io_axi_r_valid                         ), //i
    .io_output_r_ready           (downsizer_io_output_r_ready               ), //o
    .io_output_r_payload_data    (ac_io_axi_r_payload_data[31:0]            ), //i
    .io_output_r_payload_resp    (ac_io_axi_r_payload_resp[1:0]             ), //i
    .io_output_r_payload_last    (ac_io_axi_r_payload_last                  ), //i
    .clk                         (clk                                       ), //i
    .reset                       (reset                                     )  //i
  );
  axi2apb3_Axi4SharedToApb3Bridge ac (
    .io_axi_arw_valid         (streamArbiter_io_output_valid             ), //i
    .io_axi_arw_ready         (ac_io_axi_arw_ready                       ), //o
    .io_axi_arw_payload_addr  (streamArbiter_io_output_payload_addr[31:0]), //i
    .io_axi_arw_payload_len   (streamArbiter_io_output_payload_len[7:0]  ), //i
    .io_axi_arw_payload_size  (streamArbiter_io_output_payload_size[2:0] ), //i
    .io_axi_arw_payload_burst (2'b01                                     ), //i
    .io_axi_arw_payload_write (ac_io_axi_arw_payload_write               ), //i
    .io_axi_w_valid           (downsizer_io_output_w_valid               ), //i
    .io_axi_w_ready           (ac_io_axi_w_ready                         ), //o
    .io_axi_w_payload_data    (downsizer_io_output_w_payload_data[31:0]  ), //i
    .io_axi_w_payload_strb    (downsizer_io_output_w_payload_strb[3:0]   ), //i
    .io_axi_w_payload_last    (downsizer_io_output_w_payload_last        ), //i
    .io_axi_b_valid           (ac_io_axi_b_valid                         ), //o
    .io_axi_b_ready           (downsizer_io_output_b_ready               ), //i
    .io_axi_b_payload_resp    (ac_io_axi_b_payload_resp[1:0]             ), //o
    .io_axi_r_valid           (ac_io_axi_r_valid                         ), //o
    .io_axi_r_ready           (downsizer_io_output_r_ready               ), //i
    .io_axi_r_payload_data    (ac_io_axi_r_payload_data[31:0]            ), //o
    .io_axi_r_payload_resp    (ac_io_axi_r_payload_resp[1:0]             ), //o
    .io_axi_r_payload_last    (ac_io_axi_r_payload_last                  ), //o
    .io_apb_PADDR             (ac_io_apb_PADDR[31:0]                     ), //o
    .io_apb_PSEL              (ac_io_apb_PSEL                            ), //o
    .io_apb_PENABLE           (ac_io_apb_PENABLE                         ), //o
    .io_apb_PREADY            (m_apb3_PREADY                             ), //i
    .io_apb_PWRITE            (ac_io_apb_PWRITE                          ), //o
    .io_apb_PWDATA            (ac_io_apb_PWDATA[31:0]                    ), //o
    .io_apb_PRDATA            (m_apb3_PRDATA[31:0]                       ), //i
    .io_apb_PSLVERROR         (m_apb3_PSLVERROR                          ), //i
    .clk                      (clk                                       ), //i
    .reset                    (reset                                     )  //i
  );
  axi2apb3_StreamArbiter streamArbiter (
    .io_inputs_0_valid          (downsizer_io_output_ar_valid               ), //i
    .io_inputs_0_ready          (streamArbiter_io_inputs_0_ready            ), //o
    .io_inputs_0_payload_addr   (downsizer_io_output_ar_payload_addr[31:0]  ), //i
    .io_inputs_0_payload_region (downsizer_io_output_ar_payload_region[3:0] ), //i
    .io_inputs_0_payload_len    (downsizer_io_output_ar_payload_len[7:0]    ), //i
    .io_inputs_0_payload_size   (downsizer_io_output_ar_payload_size[2:0]   ), //i
    .io_inputs_0_payload_lock   (downsizer_io_output_ar_payload_lock        ), //i
    .io_inputs_0_payload_cache  (downsizer_io_output_ar_payload_cache[3:0]  ), //i
    .io_inputs_0_payload_qos    (downsizer_io_output_ar_payload_qos[3:0]    ), //i
    .io_inputs_0_payload_prot   (downsizer_io_output_ar_payload_prot[2:0]   ), //i
    .io_inputs_1_valid          (downsizer_io_output_aw_valid               ), //i
    .io_inputs_1_ready          (streamArbiter_io_inputs_1_ready            ), //o
    .io_inputs_1_payload_addr   (downsizer_io_output_aw_payload_addr[31:0]  ), //i
    .io_inputs_1_payload_region (downsizer_io_output_aw_payload_region[3:0] ), //i
    .io_inputs_1_payload_len    (downsizer_io_output_aw_payload_len[7:0]    ), //i
    .io_inputs_1_payload_size   (downsizer_io_output_aw_payload_size[2:0]   ), //i
    .io_inputs_1_payload_lock   (downsizer_io_output_aw_payload_lock        ), //i
    .io_inputs_1_payload_cache  (downsizer_io_output_aw_payload_cache[3:0]  ), //i
    .io_inputs_1_payload_qos    (downsizer_io_output_aw_payload_qos[3:0]    ), //i
    .io_inputs_1_payload_prot   (downsizer_io_output_aw_payload_prot[2:0]   ), //i
    .io_output_valid            (streamArbiter_io_output_valid              ), //o
    .io_output_ready            (ac_io_axi_arw_ready                        ), //i
    .io_output_payload_addr     (streamArbiter_io_output_payload_addr[31:0] ), //o
    .io_output_payload_region   (streamArbiter_io_output_payload_region[3:0]), //o
    .io_output_payload_len      (streamArbiter_io_output_payload_len[7:0]   ), //o
    .io_output_payload_size     (streamArbiter_io_output_payload_size[2:0]  ), //o
    .io_output_payload_lock     (streamArbiter_io_output_payload_lock       ), //o
    .io_output_payload_cache    (streamArbiter_io_output_payload_cache[3:0] ), //o
    .io_output_payload_qos      (streamArbiter_io_output_payload_qos[3:0]   ), //o
    .io_output_payload_prot     (streamArbiter_io_output_payload_prot[2:0]  ), //o
    .io_chosen                  (streamArbiter_io_chosen                    ), //o
    .io_chosenOH                (streamArbiter_io_chosenOH[1:0]             ), //o
    .clk                        (clk                                        ), //i
    .reset                      (reset                                      )  //i
  );
  assign s_axi_arready = downsizer_io_input_ar_ready;
  assign s_axi_awready = downsizer_io_input_aw_ready;
  assign s_axi_wready = downsizer_io_input_w_ready;
  assign s_axi_rvalid = downsizer_io_input_r_valid;
  assign s_axi_rdata = downsizer_io_input_r_payload_data;
  assign s_axi_rlast = downsizer_io_input_r_payload_last;
  assign s_axi_rresp = downsizer_io_input_r_payload_resp;
  assign s_axi_bvalid = downsizer_io_input_b_valid;
  assign s_axi_bresp = downsizer_io_input_b_payload_resp;
  assign ac_io_axi_arw_payload_write = streamArbiter_io_chosenOH[1];
  assign m_apb3_PADDR = ac_io_apb_PADDR;
  assign m_apb3_PSEL = ac_io_apb_PSEL;
  assign m_apb3_PENABLE = ac_io_apb_PENABLE;
  assign m_apb3_PWRITE = ac_io_apb_PWRITE;
  assign m_apb3_PWDATA = ac_io_apb_PWDATA;

endmodule

module axi2apb3_StreamArbiter (
  input  wire          io_inputs_0_valid,
  output wire          io_inputs_0_ready,
  input  wire [31:0]   io_inputs_0_payload_addr,
  input  wire [3:0]    io_inputs_0_payload_region,
  input  wire [7:0]    io_inputs_0_payload_len,
  input  wire [2:0]    io_inputs_0_payload_size,
  input  wire [0:0]    io_inputs_0_payload_lock,
  input  wire [3:0]    io_inputs_0_payload_cache,
  input  wire [3:0]    io_inputs_0_payload_qos,
  input  wire [2:0]    io_inputs_0_payload_prot,
  input  wire          io_inputs_1_valid,
  output wire          io_inputs_1_ready,
  input  wire [31:0]   io_inputs_1_payload_addr,
  input  wire [3:0]    io_inputs_1_payload_region,
  input  wire [7:0]    io_inputs_1_payload_len,
  input  wire [2:0]    io_inputs_1_payload_size,
  input  wire [0:0]    io_inputs_1_payload_lock,
  input  wire [3:0]    io_inputs_1_payload_cache,
  input  wire [3:0]    io_inputs_1_payload_qos,
  input  wire [2:0]    io_inputs_1_payload_prot,
  output wire          io_output_valid,
  input  wire          io_output_ready,
  output wire [31:0]   io_output_payload_addr,
  output wire [3:0]    io_output_payload_region,
  output wire [7:0]    io_output_payload_len,
  output wire [2:0]    io_output_payload_size,
  output wire [0:0]    io_output_payload_lock,
  output wire [3:0]    io_output_payload_cache,
  output wire [3:0]    io_output_payload_qos,
  output wire [2:0]    io_output_payload_prot,
  output wire [0:0]    io_chosen,
  output wire [1:0]    io_chosenOH,
  input  wire          clk,
  input  wire          reset
);

  wire       [3:0]    _zz__zz_maskProposal_0_2;
  wire       [3:0]    _zz__zz_maskProposal_0_2_1;
  wire       [1:0]    _zz__zz_maskProposal_0_2_2;
  reg                 locked;
  wire                maskProposal_0;
  wire                maskProposal_1;
  reg                 maskLocked_0;
  reg                 maskLocked_1;
  wire                maskRouted_0;
  wire                maskRouted_1;
  wire       [1:0]    _zz_maskProposal_0;
  wire       [3:0]    _zz_maskProposal_0_1;
  wire       [3:0]    _zz_maskProposal_0_2;
  wire       [1:0]    _zz_maskProposal_0_3;
  wire                io_output_fire;
  wire                _zz_io_chosen;

  assign _zz__zz_maskProposal_0_2 = (_zz_maskProposal_0_1 - _zz__zz_maskProposal_0_2_1);
  assign _zz__zz_maskProposal_0_2_2 = {maskLocked_0,maskLocked_1};
  assign _zz__zz_maskProposal_0_2_1 = {2'd0, _zz__zz_maskProposal_0_2_2};
  assign maskRouted_0 = (locked ? maskLocked_0 : maskProposal_0);
  assign maskRouted_1 = (locked ? maskLocked_1 : maskProposal_1);
  assign _zz_maskProposal_0 = {io_inputs_1_valid,io_inputs_0_valid};
  assign _zz_maskProposal_0_1 = {_zz_maskProposal_0,_zz_maskProposal_0};
  assign _zz_maskProposal_0_2 = (_zz_maskProposal_0_1 & (~ _zz__zz_maskProposal_0_2));
  assign _zz_maskProposal_0_3 = (_zz_maskProposal_0_2[3 : 2] | _zz_maskProposal_0_2[1 : 0]);
  assign maskProposal_0 = _zz_maskProposal_0_3[0];
  assign maskProposal_1 = _zz_maskProposal_0_3[1];
  assign io_output_fire = (io_output_valid && io_output_ready);
  assign io_output_valid = ((io_inputs_0_valid && maskRouted_0) || (io_inputs_1_valid && maskRouted_1));
  assign io_output_payload_addr = (maskRouted_0 ? io_inputs_0_payload_addr : io_inputs_1_payload_addr);
  assign io_output_payload_region = (maskRouted_0 ? io_inputs_0_payload_region : io_inputs_1_payload_region);
  assign io_output_payload_len = (maskRouted_0 ? io_inputs_0_payload_len : io_inputs_1_payload_len);
  assign io_output_payload_size = (maskRouted_0 ? io_inputs_0_payload_size : io_inputs_1_payload_size);
  assign io_output_payload_lock = (maskRouted_0 ? io_inputs_0_payload_lock : io_inputs_1_payload_lock);
  assign io_output_payload_cache = (maskRouted_0 ? io_inputs_0_payload_cache : io_inputs_1_payload_cache);
  assign io_output_payload_qos = (maskRouted_0 ? io_inputs_0_payload_qos : io_inputs_1_payload_qos);
  assign io_output_payload_prot = (maskRouted_0 ? io_inputs_0_payload_prot : io_inputs_1_payload_prot);
  assign io_inputs_0_ready = (maskRouted_0 && io_output_ready);
  assign io_inputs_1_ready = (maskRouted_1 && io_output_ready);
  assign io_chosenOH = {maskRouted_1,maskRouted_0};
  assign _zz_io_chosen = io_chosenOH[1];
  assign io_chosen = _zz_io_chosen;
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      locked <= 1'b0;
      maskLocked_0 <= 1'b0;
      maskLocked_1 <= 1'b1;
    end else begin
      if(io_output_valid) begin
        maskLocked_0 <= maskRouted_0;
        maskLocked_1 <= maskRouted_1;
      end
      if(io_output_valid) begin
        locked <= 1'b1;
      end
      if(io_output_fire) begin
        locked <= 1'b0;
      end
    end
  end


endmodule

module axi2apb3_Axi4SharedToApb3Bridge (
  input  wire          io_axi_arw_valid,
  output reg           io_axi_arw_ready,
  input  wire [31:0]   io_axi_arw_payload_addr,
  input  wire [7:0]    io_axi_arw_payload_len,
  input  wire [2:0]    io_axi_arw_payload_size,
  input  wire [1:0]    io_axi_arw_payload_burst,
  input  wire          io_axi_arw_payload_write,
  input  wire          io_axi_w_valid,
  output reg           io_axi_w_ready,
  input  wire [31:0]   io_axi_w_payload_data,
  input  wire [3:0]    io_axi_w_payload_strb,
  input  wire          io_axi_w_payload_last,
  output reg           io_axi_b_valid,
  input  wire          io_axi_b_ready,
  output wire [1:0]    io_axi_b_payload_resp,
  output reg           io_axi_r_valid,
  input  wire          io_axi_r_ready,
  output wire [31:0]   io_axi_r_payload_data,
  output wire [1:0]    io_axi_r_payload_resp,
  output wire          io_axi_r_payload_last,
  output wire [31:0]   io_apb_PADDR,
  output reg  [0:0]    io_apb_PSEL,
  output reg           io_apb_PENABLE,
  input  wire          io_apb_PREADY,
  output wire          io_apb_PWRITE,
  output wire [31:0]   io_apb_PWDATA,
  input  wire [31:0]   io_apb_PRDATA,
  input  wire          io_apb_PSLVERROR,
  input  wire          clk,
  input  wire          reset
);
  localparam Axi4ToApb3BridgePhase_SETUP = 2'd0;
  localparam Axi4ToApb3BridgePhase_ACCESS_1 = 2'd1;
  localparam Axi4ToApb3BridgePhase_RESPONSE = 2'd2;

  reg        [1:0]    phase;
  reg                 write;
  reg        [31:0]   readedData;
  wire                when_Axi4SharedToApb3Bridge_l91;
  wire                when_Axi4SharedToApb3Bridge_l97;

  always @(*) begin
    io_axi_arw_ready = 1'b0;
    case(phase)
      Axi4ToApb3BridgePhase_SETUP : begin
        if(when_Axi4SharedToApb3Bridge_l91) begin
          if(when_Axi4SharedToApb3Bridge_l97) begin
            io_axi_arw_ready = 1'b1;
          end
        end
      end
      Axi4ToApb3BridgePhase_ACCESS_1 : begin
        if(io_apb_PREADY) begin
          io_axi_arw_ready = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_axi_w_ready = 1'b0;
    case(phase)
      Axi4ToApb3BridgePhase_SETUP : begin
        if(when_Axi4SharedToApb3Bridge_l91) begin
          if(when_Axi4SharedToApb3Bridge_l97) begin
            io_axi_w_ready = 1'b1;
          end
        end
      end
      Axi4ToApb3BridgePhase_ACCESS_1 : begin
        if(io_apb_PREADY) begin
          io_axi_w_ready = write;
        end
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_axi_b_valid = 1'b0;
    case(phase)
      Axi4ToApb3BridgePhase_SETUP : begin
      end
      Axi4ToApb3BridgePhase_ACCESS_1 : begin
      end
      default : begin
        if(write) begin
          io_axi_b_valid = 1'b1;
        end
      end
    endcase
  end

  always @(*) begin
    io_axi_r_valid = 1'b0;
    case(phase)
      Axi4ToApb3BridgePhase_SETUP : begin
      end
      Axi4ToApb3BridgePhase_ACCESS_1 : begin
      end
      default : begin
        if(!write) begin
          io_axi_r_valid = 1'b1;
        end
      end
    endcase
  end

  always @(*) begin
    io_apb_PSEL[0] = 1'b0;
    case(phase)
      Axi4ToApb3BridgePhase_SETUP : begin
        if(when_Axi4SharedToApb3Bridge_l91) begin
          io_apb_PSEL[0] = 1'b1;
          if(when_Axi4SharedToApb3Bridge_l97) begin
            io_apb_PSEL[0] = 1'b0;
          end
        end
      end
      Axi4ToApb3BridgePhase_ACCESS_1 : begin
        io_apb_PSEL[0] = 1'b1;
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_apb_PENABLE = 1'b0;
    case(phase)
      Axi4ToApb3BridgePhase_SETUP : begin
      end
      Axi4ToApb3BridgePhase_ACCESS_1 : begin
        io_apb_PENABLE = 1'b1;
      end
      default : begin
      end
    endcase
  end

  assign when_Axi4SharedToApb3Bridge_l91 = (io_axi_arw_valid && ((! io_axi_arw_payload_write) || io_axi_w_valid));
  assign when_Axi4SharedToApb3Bridge_l97 = (io_axi_arw_payload_write && (io_axi_w_payload_strb == 4'b0000));
  assign io_apb_PADDR = io_axi_arw_payload_addr;
  assign io_apb_PWDATA = io_axi_w_payload_data;
  assign io_apb_PWRITE = io_axi_arw_payload_write;
  assign io_axi_r_payload_resp = {io_apb_PSLVERROR,1'b0};
  assign io_axi_b_payload_resp = {io_apb_PSLVERROR,1'b0};
  assign io_axi_r_payload_data = readedData;
  assign io_axi_r_payload_last = 1'b1;
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      phase <= Axi4ToApb3BridgePhase_SETUP;
    end else begin
      case(phase)
        Axi4ToApb3BridgePhase_SETUP : begin
          if(when_Axi4SharedToApb3Bridge_l91) begin
            phase <= Axi4ToApb3BridgePhase_ACCESS_1;
            if(when_Axi4SharedToApb3Bridge_l97) begin
              phase <= Axi4ToApb3BridgePhase_RESPONSE;
            end
          end
        end
        Axi4ToApb3BridgePhase_ACCESS_1 : begin
          if(io_apb_PREADY) begin
            phase <= Axi4ToApb3BridgePhase_RESPONSE;
          end
        end
        default : begin
          if(write) begin
            if(io_axi_b_ready) begin
              phase <= Axi4ToApb3BridgePhase_SETUP;
            end
          end else begin
            if(io_axi_r_ready) begin
              phase <= Axi4ToApb3BridgePhase_SETUP;
            end
          end
        end
      endcase
    end
  end

  always @(posedge clk) begin
    case(phase)
      Axi4ToApb3BridgePhase_SETUP : begin
        write <= io_axi_arw_payload_write;
      end
      Axi4ToApb3BridgePhase_ACCESS_1 : begin
        if(io_apb_PREADY) begin
          readedData <= io_apb_PRDATA;
        end
      end
      default : begin
      end
    endcase
  end


endmodule

module axi2apb3_Axi4Downsizer (
  input  wire          io_input_aw_valid,
  output wire          io_input_aw_ready,
  input  wire [31:0]   io_input_aw_payload_addr,
  input  wire [3:0]    io_input_aw_payload_region,
  input  wire [7:0]    io_input_aw_payload_len,
  input  wire [2:0]    io_input_aw_payload_size,
  input  wire [0:0]    io_input_aw_payload_lock,
  input  wire [3:0]    io_input_aw_payload_cache,
  input  wire [3:0]    io_input_aw_payload_qos,
  input  wire [2:0]    io_input_aw_payload_prot,
  input  wire          io_input_w_valid,
  output wire          io_input_w_ready,
  input  wire [255:0]  io_input_w_payload_data,
  input  wire [31:0]   io_input_w_payload_strb,
  input  wire          io_input_w_payload_last,
  output wire          io_input_b_valid,
  input  wire          io_input_b_ready,
  output wire [1:0]    io_input_b_payload_resp,
  input  wire          io_input_ar_valid,
  output wire          io_input_ar_ready,
  input  wire [31:0]   io_input_ar_payload_addr,
  input  wire [3:0]    io_input_ar_payload_region,
  input  wire [7:0]    io_input_ar_payload_len,
  input  wire [2:0]    io_input_ar_payload_size,
  input  wire [0:0]    io_input_ar_payload_lock,
  input  wire [3:0]    io_input_ar_payload_cache,
  input  wire [3:0]    io_input_ar_payload_qos,
  input  wire [2:0]    io_input_ar_payload_prot,
  output wire          io_input_r_valid,
  input  wire          io_input_r_ready,
  output wire [255:0]  io_input_r_payload_data,
  output wire [1:0]    io_input_r_payload_resp,
  output wire          io_input_r_payload_last,
  output wire          io_output_aw_valid,
  input  wire          io_output_aw_ready,
  output wire [31:0]   io_output_aw_payload_addr,
  output wire [3:0]    io_output_aw_payload_region,
  output wire [7:0]    io_output_aw_payload_len,
  output wire [2:0]    io_output_aw_payload_size,
  output wire [0:0]    io_output_aw_payload_lock,
  output wire [3:0]    io_output_aw_payload_cache,
  output wire [3:0]    io_output_aw_payload_qos,
  output wire [2:0]    io_output_aw_payload_prot,
  output wire          io_output_w_valid,
  input  wire          io_output_w_ready,
  output wire [31:0]   io_output_w_payload_data,
  output wire [3:0]    io_output_w_payload_strb,
  output wire          io_output_w_payload_last,
  input  wire          io_output_b_valid,
  output wire          io_output_b_ready,
  input  wire [1:0]    io_output_b_payload_resp,
  output wire          io_output_ar_valid,
  input  wire          io_output_ar_ready,
  output wire [31:0]   io_output_ar_payload_addr,
  output wire [3:0]    io_output_ar_payload_region,
  output wire [7:0]    io_output_ar_payload_len,
  output wire [2:0]    io_output_ar_payload_size,
  output wire [0:0]    io_output_ar_payload_lock,
  output wire [3:0]    io_output_ar_payload_cache,
  output wire [3:0]    io_output_ar_payload_qos,
  output wire [2:0]    io_output_ar_payload_prot,
  input  wire          io_output_r_valid,
  output wire          io_output_r_ready,
  input  wire [31:0]   io_output_r_payload_data,
  input  wire [1:0]    io_output_r_payload_resp,
  input  wire          io_output_r_payload_last,
  input  wire          clk,
  input  wire          reset
);

  wire                readOnly_io_input_ar_ready;
  wire                readOnly_io_input_r_valid;
  wire       [255:0]  readOnly_io_input_r_payload_data;
  wire       [1:0]    readOnly_io_input_r_payload_resp;
  wire                readOnly_io_input_r_payload_last;
  wire                readOnly_io_output_ar_valid;
  wire       [31:0]   readOnly_io_output_ar_payload_addr;
  wire       [3:0]    readOnly_io_output_ar_payload_region;
  wire       [7:0]    readOnly_io_output_ar_payload_len;
  wire       [2:0]    readOnly_io_output_ar_payload_size;
  wire       [0:0]    readOnly_io_output_ar_payload_lock;
  wire       [3:0]    readOnly_io_output_ar_payload_cache;
  wire       [3:0]    readOnly_io_output_ar_payload_qos;
  wire       [2:0]    readOnly_io_output_ar_payload_prot;
  wire                readOnly_io_output_r_ready;
  wire                writeOnly_io_input_aw_ready;
  wire                writeOnly_io_input_w_ready;
  wire                writeOnly_io_input_b_valid;
  wire       [1:0]    writeOnly_io_input_b_payload_resp;
  wire                writeOnly_io_output_aw_valid;
  wire       [31:0]   writeOnly_io_output_aw_payload_addr;
  wire       [3:0]    writeOnly_io_output_aw_payload_region;
  wire       [7:0]    writeOnly_io_output_aw_payload_len;
  wire       [2:0]    writeOnly_io_output_aw_payload_size;
  wire       [0:0]    writeOnly_io_output_aw_payload_lock;
  wire       [3:0]    writeOnly_io_output_aw_payload_cache;
  wire       [3:0]    writeOnly_io_output_aw_payload_qos;
  wire       [2:0]    writeOnly_io_output_aw_payload_prot;
  wire                writeOnly_io_output_w_valid;
  wire       [31:0]   writeOnly_io_output_w_payload_data;
  wire       [3:0]    writeOnly_io_output_w_payload_strb;
  wire                writeOnly_io_output_w_payload_last;
  wire                writeOnly_io_output_b_ready;

  axi2apb3_Axi4ReadOnlyDownsizer readOnly (
    .io_input_ar_valid           (io_input_ar_valid                        ), //i
    .io_input_ar_ready           (readOnly_io_input_ar_ready               ), //o
    .io_input_ar_payload_addr    (io_input_ar_payload_addr[31:0]           ), //i
    .io_input_ar_payload_region  (io_input_ar_payload_region[3:0]          ), //i
    .io_input_ar_payload_len     (io_input_ar_payload_len[7:0]             ), //i
    .io_input_ar_payload_size    (io_input_ar_payload_size[2:0]            ), //i
    .io_input_ar_payload_lock    (io_input_ar_payload_lock                 ), //i
    .io_input_ar_payload_cache   (io_input_ar_payload_cache[3:0]           ), //i
    .io_input_ar_payload_qos     (io_input_ar_payload_qos[3:0]             ), //i
    .io_input_ar_payload_prot    (io_input_ar_payload_prot[2:0]            ), //i
    .io_input_r_valid            (readOnly_io_input_r_valid                ), //o
    .io_input_r_ready            (io_input_r_ready                         ), //i
    .io_input_r_payload_data     (readOnly_io_input_r_payload_data[255:0]  ), //o
    .io_input_r_payload_resp     (readOnly_io_input_r_payload_resp[1:0]    ), //o
    .io_input_r_payload_last     (readOnly_io_input_r_payload_last         ), //o
    .io_output_ar_valid          (readOnly_io_output_ar_valid              ), //o
    .io_output_ar_ready          (io_output_ar_ready                       ), //i
    .io_output_ar_payload_addr   (readOnly_io_output_ar_payload_addr[31:0] ), //o
    .io_output_ar_payload_region (readOnly_io_output_ar_payload_region[3:0]), //o
    .io_output_ar_payload_len    (readOnly_io_output_ar_payload_len[7:0]   ), //o
    .io_output_ar_payload_size   (readOnly_io_output_ar_payload_size[2:0]  ), //o
    .io_output_ar_payload_lock   (readOnly_io_output_ar_payload_lock       ), //o
    .io_output_ar_payload_cache  (readOnly_io_output_ar_payload_cache[3:0] ), //o
    .io_output_ar_payload_qos    (readOnly_io_output_ar_payload_qos[3:0]   ), //o
    .io_output_ar_payload_prot   (readOnly_io_output_ar_payload_prot[2:0]  ), //o
    .io_output_r_valid           (io_output_r_valid                        ), //i
    .io_output_r_ready           (readOnly_io_output_r_ready               ), //o
    .io_output_r_payload_data    (io_output_r_payload_data[31:0]           ), //i
    .io_output_r_payload_resp    (io_output_r_payload_resp[1:0]            ), //i
    .io_output_r_payload_last    (io_output_r_payload_last                 ), //i
    .clk                         (clk                                      ), //i
    .reset                       (reset                                    )  //i
  );
  axi2apb3_Axi4WriteOnlyDownsizer writeOnly (
    .io_input_aw_valid           (io_input_aw_valid                         ), //i
    .io_input_aw_ready           (writeOnly_io_input_aw_ready               ), //o
    .io_input_aw_payload_addr    (io_input_aw_payload_addr[31:0]            ), //i
    .io_input_aw_payload_region  (io_input_aw_payload_region[3:0]           ), //i
    .io_input_aw_payload_len     (io_input_aw_payload_len[7:0]              ), //i
    .io_input_aw_payload_size    (io_input_aw_payload_size[2:0]             ), //i
    .io_input_aw_payload_lock    (io_input_aw_payload_lock                  ), //i
    .io_input_aw_payload_cache   (io_input_aw_payload_cache[3:0]            ), //i
    .io_input_aw_payload_qos     (io_input_aw_payload_qos[3:0]              ), //i
    .io_input_aw_payload_prot    (io_input_aw_payload_prot[2:0]             ), //i
    .io_input_w_valid            (io_input_w_valid                          ), //i
    .io_input_w_ready            (writeOnly_io_input_w_ready                ), //o
    .io_input_w_payload_data     (io_input_w_payload_data[255:0]            ), //i
    .io_input_w_payload_strb     (io_input_w_payload_strb[31:0]             ), //i
    .io_input_w_payload_last     (io_input_w_payload_last                   ), //i
    .io_input_b_valid            (writeOnly_io_input_b_valid                ), //o
    .io_input_b_ready            (io_input_b_ready                          ), //i
    .io_input_b_payload_resp     (writeOnly_io_input_b_payload_resp[1:0]    ), //o
    .io_output_aw_valid          (writeOnly_io_output_aw_valid              ), //o
    .io_output_aw_ready          (io_output_aw_ready                        ), //i
    .io_output_aw_payload_addr   (writeOnly_io_output_aw_payload_addr[31:0] ), //o
    .io_output_aw_payload_region (writeOnly_io_output_aw_payload_region[3:0]), //o
    .io_output_aw_payload_len    (writeOnly_io_output_aw_payload_len[7:0]   ), //o
    .io_output_aw_payload_size   (writeOnly_io_output_aw_payload_size[2:0]  ), //o
    .io_output_aw_payload_lock   (writeOnly_io_output_aw_payload_lock       ), //o
    .io_output_aw_payload_cache  (writeOnly_io_output_aw_payload_cache[3:0] ), //o
    .io_output_aw_payload_qos    (writeOnly_io_output_aw_payload_qos[3:0]   ), //o
    .io_output_aw_payload_prot   (writeOnly_io_output_aw_payload_prot[2:0]  ), //o
    .io_output_w_valid           (writeOnly_io_output_w_valid               ), //o
    .io_output_w_ready           (io_output_w_ready                         ), //i
    .io_output_w_payload_data    (writeOnly_io_output_w_payload_data[31:0]  ), //o
    .io_output_w_payload_strb    (writeOnly_io_output_w_payload_strb[3:0]   ), //o
    .io_output_w_payload_last    (writeOnly_io_output_w_payload_last        ), //o
    .io_output_b_valid           (io_output_b_valid                         ), //i
    .io_output_b_ready           (writeOnly_io_output_b_ready               ), //o
    .io_output_b_payload_resp    (io_output_b_payload_resp[1:0]             ), //i
    .clk                         (clk                                       ), //i
    .reset                       (reset                                     )  //i
  );
  assign io_input_ar_ready = readOnly_io_input_ar_ready;
  assign io_input_r_valid = readOnly_io_input_r_valid;
  assign io_input_r_payload_data = readOnly_io_input_r_payload_data;
  assign io_input_r_payload_resp = readOnly_io_input_r_payload_resp;
  assign io_input_r_payload_last = readOnly_io_input_r_payload_last;
  assign io_input_aw_ready = writeOnly_io_input_aw_ready;
  assign io_input_w_ready = writeOnly_io_input_w_ready;
  assign io_input_b_valid = writeOnly_io_input_b_valid;
  assign io_input_b_payload_resp = writeOnly_io_input_b_payload_resp;
  assign io_output_ar_valid = readOnly_io_output_ar_valid;
  assign io_output_ar_payload_addr = readOnly_io_output_ar_payload_addr;
  assign io_output_ar_payload_region = readOnly_io_output_ar_payload_region;
  assign io_output_ar_payload_len = readOnly_io_output_ar_payload_len;
  assign io_output_ar_payload_size = readOnly_io_output_ar_payload_size;
  assign io_output_ar_payload_lock = readOnly_io_output_ar_payload_lock;
  assign io_output_ar_payload_cache = readOnly_io_output_ar_payload_cache;
  assign io_output_ar_payload_qos = readOnly_io_output_ar_payload_qos;
  assign io_output_ar_payload_prot = readOnly_io_output_ar_payload_prot;
  assign io_output_r_ready = readOnly_io_output_r_ready;
  assign io_output_aw_valid = writeOnly_io_output_aw_valid;
  assign io_output_aw_payload_addr = writeOnly_io_output_aw_payload_addr;
  assign io_output_aw_payload_region = writeOnly_io_output_aw_payload_region;
  assign io_output_aw_payload_len = writeOnly_io_output_aw_payload_len;
  assign io_output_aw_payload_size = writeOnly_io_output_aw_payload_size;
  assign io_output_aw_payload_lock = writeOnly_io_output_aw_payload_lock;
  assign io_output_aw_payload_cache = writeOnly_io_output_aw_payload_cache;
  assign io_output_aw_payload_qos = writeOnly_io_output_aw_payload_qos;
  assign io_output_aw_payload_prot = writeOnly_io_output_aw_payload_prot;
  assign io_output_w_valid = writeOnly_io_output_w_valid;
  assign io_output_w_payload_data = writeOnly_io_output_w_payload_data;
  assign io_output_w_payload_strb = writeOnly_io_output_w_payload_strb;
  assign io_output_w_payload_last = writeOnly_io_output_w_payload_last;
  assign io_output_b_ready = writeOnly_io_output_b_ready;

endmodule

module axi2apb3_Axi4WriteOnlyDownsizer (
  input  wire          io_input_aw_valid,
  output wire          io_input_aw_ready,
  input  wire [31:0]   io_input_aw_payload_addr,
  input  wire [3:0]    io_input_aw_payload_region,
  input  wire [7:0]    io_input_aw_payload_len,
  input  wire [2:0]    io_input_aw_payload_size,
  input  wire [0:0]    io_input_aw_payload_lock,
  input  wire [3:0]    io_input_aw_payload_cache,
  input  wire [3:0]    io_input_aw_payload_qos,
  input  wire [2:0]    io_input_aw_payload_prot,
  input  wire          io_input_w_valid,
  output wire          io_input_w_ready,
  input  wire [255:0]  io_input_w_payload_data,
  input  wire [31:0]   io_input_w_payload_strb,
  input  wire          io_input_w_payload_last,
  output wire          io_input_b_valid,
  input  wire          io_input_b_ready,
  output wire [1:0]    io_input_b_payload_resp,
  output wire          io_output_aw_valid,
  input  wire          io_output_aw_ready,
  output wire [31:0]   io_output_aw_payload_addr,
  output wire [3:0]    io_output_aw_payload_region,
  output wire [7:0]    io_output_aw_payload_len,
  output wire [2:0]    io_output_aw_payload_size,
  output wire [0:0]    io_output_aw_payload_lock,
  output wire [3:0]    io_output_aw_payload_cache,
  output wire [3:0]    io_output_aw_payload_qos,
  output wire [2:0]    io_output_aw_payload_prot,
  output wire          io_output_w_valid,
  input  wire          io_output_w_ready,
  output wire [31:0]   io_output_w_payload_data,
  output wire [3:0]    io_output_w_payload_strb,
  output wire          io_output_w_payload_last,
  input  wire          io_output_b_valid,
  output wire          io_output_b_ready,
  input  wire [1:0]    io_output_b_payload_resp,
  input  wire          clk,
  input  wire          reset
);

  wire                generator_io_input_ready;
  wire                generator_io_output_valid;
  wire       [31:0]   generator_io_output_payload_addr;
  wire       [3:0]    generator_io_output_payload_region;
  wire       [7:0]    generator_io_output_payload_len;
  wire       [2:0]    generator_io_output_payload_size;
  wire       [0:0]    generator_io_output_payload_lock;
  wire       [3:0]    generator_io_output_payload_cache;
  wire       [3:0]    generator_io_output_payload_qos;
  wire       [2:0]    generator_io_output_payload_prot;
  wire       [31:0]   generator_io_start;
  wire       [6:0]    generator_io_ratio;
  wire       [2:0]    generator_io_size;
  wire                generator_io_working;
  wire                generator_io_last;
  wire                generator_io_done;
  wire                inputDataCounter_io_available;
  wire                inputDataCounter_io_working;
  wire                inputDataCounter_io_last;
  wire                inputDataCounter_io_done;
  wire       [7:0]    inputDataCounter_io_value;
  wire                streamCounter_io_available;
  wire                streamCounter_io_working;
  wire                streamCounter_io_last;
  wire                streamCounter_io_done;
  wire       [7:0]    streamCounter_io_value;
  wire                dataExtender_io_input_ready;
  wire                dataExtender_io_output_valid;
  wire       [255:0]  dataExtender_io_output_payload_data;
  wire       [31:0]   dataExtender_io_output_payload_strb;
  wire                dataExtender_io_output_payload_last;
  wire                dataExtender_io_working;
  wire                dataExtender_io_first;
  wire                dataExtender_io_last;
  wire                dataExtender_io_done;
  wire                rspCtrlStream_fifo_io_push_ready;
  wire                rspCtrlStream_fifo_io_pop_valid;
  wire                rspCtrlStream_fifo_io_pop_payload;
  wire       [1:0]    rspCtrlStream_fifo_io_occupancy;
  wire       [1:0]    rspCtrlStream_fifo_io_availability;
  wire       [7:0]    _zz_beatOffsetReg;
  wire       [7:0]    _zz_beatOffsetReg_1;
  wire       [7:0]    _zz_beatOffsetReg_2;
  wire       [7:0]    _zz_writeStream_w_payload_data;
  wire                writeStream_aw_valid;
  wire                writeStream_aw_ready;
  wire       [31:0]   writeStream_aw_payload_addr;
  wire       [3:0]    writeStream_aw_payload_region;
  wire       [7:0]    writeStream_aw_payload_len;
  wire       [2:0]    writeStream_aw_payload_size;
  wire       [0:0]    writeStream_aw_payload_lock;
  wire       [3:0]    writeStream_aw_payload_cache;
  wire       [3:0]    writeStream_aw_payload_qos;
  wire       [2:0]    writeStream_aw_payload_prot;
  wire                writeStream_w_valid;
  wire                writeStream_w_ready;
  wire       [31:0]   writeStream_w_payload_data;
  wire       [3:0]    writeStream_w_payload_strb;
  wire                writeStream_w_payload_last;
  wire                writeStream_b_valid;
  wire                writeStream_b_ready;
  wire       [1:0]    writeStream_b_payload_resp;
  wire                dataWorking;
  wire                _zz_io_input_aw_ready;
  wire                writeCmd_valid;
  wire                writeCmd_ready;
  wire       [31:0]   writeCmd_payload_addr;
  wire       [3:0]    writeCmd_payload_region;
  wire       [7:0]    writeCmd_payload_len;
  wire       [2:0]    writeCmd_payload_size;
  wire       [0:0]    writeCmd_payload_lock;
  wire       [3:0]    writeCmd_payload_cache;
  wire       [3:0]    writeCmd_payload_qos;
  wire       [2:0]    writeCmd_payload_prot;
  wire                cmdStream_valid;
  reg                 cmdStream_ready;
  wire       [31:0]   cmdStream_payload_addr;
  wire       [3:0]    cmdStream_payload_region;
  wire       [7:0]    cmdStream_payload_len;
  wire       [2:0]    cmdStream_payload_size;
  wire       [0:0]    cmdStream_payload_lock;
  wire       [3:0]    cmdStream_payload_cache;
  wire       [3:0]    cmdStream_payload_qos;
  wire       [2:0]    cmdStream_payload_prot;
  wire                staleInputData;
  wire                _zz_io_input_w_ready;
  wire                writeData_valid;
  wire                writeData_ready;
  wire       [255:0]  writeData_payload_data;
  wire       [31:0]   writeData_payload_strb;
  wire                writeData_payload_last;
  wire                writeCmd_fire;
  wire                writeData_fire;
  wire                rspCountStream_valid;
  wire                rspCountStream_ready;
  wire       [31:0]   rspCountStream_payload_addr;
  wire       [3:0]    rspCountStream_payload_region;
  wire       [7:0]    rspCountStream_payload_len;
  wire       [2:0]    rspCountStream_payload_size;
  wire       [0:0]    rspCountStream_payload_lock;
  wire       [3:0]    rspCountStream_payload_cache;
  wire       [3:0]    rspCountStream_payload_qos;
  wire       [2:0]    rspCountStream_payload_prot;
  wire                countCmdStream_valid;
  wire                countCmdStream_ready;
  wire       [31:0]   countCmdStream_payload_addr;
  wire       [3:0]    countCmdStream_payload_region;
  wire       [7:0]    countCmdStream_payload_len;
  wire       [2:0]    countCmdStream_payload_size;
  wire       [0:0]    countCmdStream_payload_lock;
  wire       [3:0]    countCmdStream_payload_cache;
  wire       [3:0]    countCmdStream_payload_qos;
  wire       [2:0]    countCmdStream_payload_prot;
  wire                outCmdStream_valid;
  wire                outCmdStream_ready;
  wire       [31:0]   outCmdStream_payload_addr;
  wire       [3:0]    outCmdStream_payload_region;
  wire       [7:0]    outCmdStream_payload_len;
  wire       [2:0]    outCmdStream_payload_size;
  wire       [0:0]    outCmdStream_payload_lock;
  wire       [3:0]    outCmdStream_payload_cache;
  wire       [3:0]    outCmdStream_payload_qos;
  wire       [2:0]    outCmdStream_payload_prot;
  reg                 cmdStream_fork3_logic_linkEnable_0;
  reg                 cmdStream_fork3_logic_linkEnable_1;
  reg                 cmdStream_fork3_logic_linkEnable_2;
  wire                when_Stream_l1063;
  wire                when_Stream_l1063_1;
  wire                when_Stream_l1063_2;
  wire                rspCountStream_fire;
  wire                countCmdStream_fire;
  wire                outCmdStream_fire;
  wire                dataStream_valid;
  wire                dataStream_ready;
  wire       [255:0]  dataStream_payload_data;
  wire       [31:0]   dataStream_payload_strb;
  wire                dataStream_payload_last;
  wire                dataStream_fire;
  reg        [4:0]    beatOffsetReg;
  reg        [4:0]    beatOffset;
  wire       [4:0]    offset;
  wire                staleData;
  wire                _zz_writeStream_w_valid;
  wire                rspCtrlStream_valid;
  wire                rspCtrlStream_ready;
  wire                rspCtrlStream_payload;
  wire                rspStream_valid;
  reg                 rspStream_ready;
  wire                rspStream_payload_1;
  wire       [1:0]    rspStream_payload_2_resp;
  wire                rspStream_fire;
  wire                when_Stream_l445;
  reg                 rspStream_thrown_valid;
  wire                rspStream_thrown_ready;
  wire                rspStream_thrown_payload_1;
  wire       [1:0]    rspStream_thrown_payload_2_resp;

  assign _zz_beatOffsetReg = (_zz_beatOffsetReg_1 + _zz_beatOffsetReg_2);
  assign _zz_beatOffsetReg_1 = {3'd0, beatOffset};
  assign _zz_beatOffsetReg_2 = ({7'd0,1'b1} <<< generator_io_size);
  assign _zz_writeStream_w_payload_data = ({3'd0,offset} <<< 2'd3);
  axi2apb3_Axi4DownsizerSubTransactionGenerator_1 generator (
    .io_input_valid           (writeCmd_valid                         ), //i
    .io_input_ready           (generator_io_input_ready               ), //o
    .io_input_payload_addr    (writeCmd_payload_addr[31:0]            ), //i
    .io_input_payload_region  (writeCmd_payload_region[3:0]           ), //i
    .io_input_payload_len     (writeCmd_payload_len[7:0]              ), //i
    .io_input_payload_size    (writeCmd_payload_size[2:0]             ), //i
    .io_input_payload_lock    (writeCmd_payload_lock                  ), //i
    .io_input_payload_cache   (writeCmd_payload_cache[3:0]            ), //i
    .io_input_payload_qos     (writeCmd_payload_qos[3:0]              ), //i
    .io_input_payload_prot    (writeCmd_payload_prot[2:0]             ), //i
    .io_output_valid          (generator_io_output_valid              ), //o
    .io_output_ready          (cmdStream_ready                        ), //i
    .io_output_payload_addr   (generator_io_output_payload_addr[31:0] ), //o
    .io_output_payload_region (generator_io_output_payload_region[3:0]), //o
    .io_output_payload_len    (generator_io_output_payload_len[7:0]   ), //o
    .io_output_payload_size   (generator_io_output_payload_size[2:0]  ), //o
    .io_output_payload_lock   (generator_io_output_payload_lock       ), //o
    .io_output_payload_cache  (generator_io_output_payload_cache[3:0] ), //o
    .io_output_payload_qos    (generator_io_output_payload_qos[3:0]   ), //o
    .io_output_payload_prot   (generator_io_output_payload_prot[2:0]  ), //o
    .io_start                 (generator_io_start[31:0]               ), //o
    .io_ratio                 (generator_io_ratio[6:0]                ), //o
    .io_size                  (generator_io_size[2:0]                 ), //o
    .io_working               (generator_io_working                   ), //o
    .io_last                  (generator_io_last                      ), //o
    .io_done                  (generator_io_done                      ), //o
    .clk                      (clk                                    ), //i
    .reset                    (reset                                  )  //i
  );
  axi2apb3_StreamTransactionCounter inputDataCounter (
    .io_ctrlFire   (writeCmd_fire                 ), //i
    .io_targetFire (writeData_fire                ), //i
    .io_available  (inputDataCounter_io_available ), //o
    .io_count      (writeCmd_payload_len[7:0]     ), //i
    .io_working    (inputDataCounter_io_working   ), //o
    .io_last       (inputDataCounter_io_last      ), //o
    .io_done       (inputDataCounter_io_done      ), //o
    .io_value      (inputDataCounter_io_value[7:0]), //o
    .clk           (clk                           ), //i
    .reset         (reset                         )  //i
  );
  axi2apb3_StreamTransactionCounter streamCounter (
    .io_ctrlFire   (countCmdStream_fire            ), //i
    .io_targetFire (dataStream_fire                ), //i
    .io_available  (streamCounter_io_available     ), //o
    .io_count      (countCmdStream_payload_len[7:0]), //i
    .io_working    (streamCounter_io_working       ), //o
    .io_last       (streamCounter_io_last          ), //o
    .io_done       (streamCounter_io_done          ), //o
    .io_value      (streamCounter_io_value[7:0]    ), //o
    .clk           (clk                            ), //i
    .reset         (reset                          )  //i
  );
  axi2apb3_StreamTransactionExtender dataExtender (
    .io_count               (generator_io_ratio[6:0]                   ), //i
    .io_input_valid         (writeData_valid                           ), //i
    .io_input_ready         (dataExtender_io_input_ready               ), //o
    .io_input_payload_data  (writeData_payload_data[255:0]             ), //i
    .io_input_payload_strb  (writeData_payload_strb[31:0]              ), //i
    .io_input_payload_last  (writeData_payload_last                    ), //i
    .io_output_valid        (dataExtender_io_output_valid              ), //o
    .io_output_ready        (dataStream_ready                          ), //i
    .io_output_payload_data (dataExtender_io_output_payload_data[255:0]), //o
    .io_output_payload_strb (dataExtender_io_output_payload_strb[31:0] ), //o
    .io_output_payload_last (dataExtender_io_output_payload_last       ), //o
    .io_working             (dataExtender_io_working                   ), //o
    .io_first               (dataExtender_io_first                     ), //o
    .io_last                (dataExtender_io_last                      ), //o
    .io_done                (dataExtender_io_done                      ), //o
    .clk                    (clk                                       ), //i
    .reset                  (reset                                     )  //i
  );
  axi2apb3_StreamFifo rspCtrlStream_fifo (
    .io_push_valid   (rspCtrlStream_valid                    ), //i
    .io_push_ready   (rspCtrlStream_fifo_io_push_ready       ), //o
    .io_push_payload (rspCtrlStream_payload                  ), //i
    .io_pop_valid    (rspCtrlStream_fifo_io_pop_valid        ), //o
    .io_pop_ready    (rspStream_fire                         ), //i
    .io_pop_payload  (rspCtrlStream_fifo_io_pop_payload      ), //o
    .io_flush        (1'b0                                   ), //i
    .io_occupancy    (rspCtrlStream_fifo_io_occupancy[1:0]   ), //o
    .io_availability (rspCtrlStream_fifo_io_availability[1:0]), //o
    .clk             (clk                                    ), //i
    .reset           (reset                                  )  //i
  );
  assign _zz_io_input_aw_ready = (! dataWorking);
  assign writeCmd_valid = (io_input_aw_valid && _zz_io_input_aw_ready);
  assign io_input_aw_ready = (writeCmd_ready && _zz_io_input_aw_ready);
  assign writeCmd_payload_addr = io_input_aw_payload_addr;
  assign writeCmd_payload_region = io_input_aw_payload_region;
  assign writeCmd_payload_len = io_input_aw_payload_len;
  assign writeCmd_payload_size = io_input_aw_payload_size;
  assign writeCmd_payload_lock = io_input_aw_payload_lock;
  assign writeCmd_payload_cache = io_input_aw_payload_cache;
  assign writeCmd_payload_qos = io_input_aw_payload_qos;
  assign writeCmd_payload_prot = io_input_aw_payload_prot;
  assign writeCmd_ready = generator_io_input_ready;
  assign cmdStream_valid = generator_io_output_valid;
  assign cmdStream_payload_addr = generator_io_output_payload_addr;
  assign cmdStream_payload_region = generator_io_output_payload_region;
  assign cmdStream_payload_len = generator_io_output_payload_len;
  assign cmdStream_payload_size = generator_io_output_payload_size;
  assign cmdStream_payload_lock = generator_io_output_payload_lock;
  assign cmdStream_payload_cache = generator_io_output_payload_cache;
  assign cmdStream_payload_qos = generator_io_output_payload_qos;
  assign cmdStream_payload_prot = generator_io_output_payload_prot;
  assign _zz_io_input_w_ready = (! staleInputData);
  assign writeData_valid = (io_input_w_valid && _zz_io_input_w_ready);
  assign io_input_w_ready = (writeData_ready && _zz_io_input_w_ready);
  assign writeData_payload_data = io_input_w_payload_data;
  assign writeData_payload_strb = io_input_w_payload_strb;
  assign writeData_payload_last = io_input_w_payload_last;
  assign writeCmd_fire = (writeCmd_valid && writeCmd_ready);
  assign writeData_fire = (writeData_valid && writeData_ready);
  assign staleInputData = (! inputDataCounter_io_working);
  always @(*) begin
    cmdStream_ready = 1'b1;
    if(when_Stream_l1063) begin
      cmdStream_ready = 1'b0;
    end
    if(when_Stream_l1063_1) begin
      cmdStream_ready = 1'b0;
    end
    if(when_Stream_l1063_2) begin
      cmdStream_ready = 1'b0;
    end
  end

  assign when_Stream_l1063 = ((! rspCountStream_ready) && cmdStream_fork3_logic_linkEnable_0);
  assign when_Stream_l1063_1 = ((! countCmdStream_ready) && cmdStream_fork3_logic_linkEnable_1);
  assign when_Stream_l1063_2 = ((! outCmdStream_ready) && cmdStream_fork3_logic_linkEnable_2);
  assign rspCountStream_valid = (cmdStream_valid && cmdStream_fork3_logic_linkEnable_0);
  assign rspCountStream_payload_addr = cmdStream_payload_addr;
  assign rspCountStream_payload_region = cmdStream_payload_region;
  assign rspCountStream_payload_len = cmdStream_payload_len;
  assign rspCountStream_payload_size = cmdStream_payload_size;
  assign rspCountStream_payload_lock = cmdStream_payload_lock;
  assign rspCountStream_payload_cache = cmdStream_payload_cache;
  assign rspCountStream_payload_qos = cmdStream_payload_qos;
  assign rspCountStream_payload_prot = cmdStream_payload_prot;
  assign rspCountStream_fire = (rspCountStream_valid && rspCountStream_ready);
  assign countCmdStream_valid = (cmdStream_valid && cmdStream_fork3_logic_linkEnable_1);
  assign countCmdStream_payload_addr = cmdStream_payload_addr;
  assign countCmdStream_payload_region = cmdStream_payload_region;
  assign countCmdStream_payload_len = cmdStream_payload_len;
  assign countCmdStream_payload_size = cmdStream_payload_size;
  assign countCmdStream_payload_lock = cmdStream_payload_lock;
  assign countCmdStream_payload_cache = cmdStream_payload_cache;
  assign countCmdStream_payload_qos = cmdStream_payload_qos;
  assign countCmdStream_payload_prot = cmdStream_payload_prot;
  assign countCmdStream_fire = (countCmdStream_valid && countCmdStream_ready);
  assign outCmdStream_valid = (cmdStream_valid && cmdStream_fork3_logic_linkEnable_2);
  assign outCmdStream_payload_addr = cmdStream_payload_addr;
  assign outCmdStream_payload_region = cmdStream_payload_region;
  assign outCmdStream_payload_len = cmdStream_payload_len;
  assign outCmdStream_payload_size = cmdStream_payload_size;
  assign outCmdStream_payload_lock = cmdStream_payload_lock;
  assign outCmdStream_payload_cache = cmdStream_payload_cache;
  assign outCmdStream_payload_qos = cmdStream_payload_qos;
  assign outCmdStream_payload_prot = cmdStream_payload_prot;
  assign outCmdStream_fire = (outCmdStream_valid && outCmdStream_ready);
  assign writeStream_aw_valid = outCmdStream_valid;
  assign outCmdStream_ready = writeStream_aw_ready;
  assign writeStream_aw_payload_addr = outCmdStream_payload_addr;
  assign writeStream_aw_payload_region = outCmdStream_payload_region;
  assign writeStream_aw_payload_len = outCmdStream_payload_len;
  assign writeStream_aw_payload_size = outCmdStream_payload_size;
  assign writeStream_aw_payload_lock = outCmdStream_payload_lock;
  assign writeStream_aw_payload_cache = outCmdStream_payload_cache;
  assign writeStream_aw_payload_qos = outCmdStream_payload_qos;
  assign writeStream_aw_payload_prot = outCmdStream_payload_prot;
  assign dataStream_fire = (dataStream_valid && dataStream_ready);
  assign countCmdStream_ready = streamCounter_io_available;
  always @(*) begin
    beatOffset = beatOffsetReg;
    if(countCmdStream_fire) begin
      beatOffset = countCmdStream_payload_addr[4 : 0];
    end
  end

  assign offset = (beatOffset & (~ 5'h03));
  assign writeData_ready = dataExtender_io_input_ready;
  assign dataStream_valid = dataExtender_io_output_valid;
  assign dataStream_payload_data = dataExtender_io_output_payload_data;
  assign dataStream_payload_strb = dataExtender_io_output_payload_strb;
  assign dataStream_payload_last = dataExtender_io_output_payload_last;
  assign dataWorking = ((! inputDataCounter_io_available) || (! writeData_ready));
  assign staleData = (! streamCounter_io_working);
  assign _zz_writeStream_w_valid = (! staleData);
  assign dataStream_ready = (writeStream_w_ready && _zz_writeStream_w_valid);
  assign writeStream_w_valid = (dataStream_valid && _zz_writeStream_w_valid);
  assign writeStream_w_payload_data = dataStream_payload_data[_zz_writeStream_w_payload_data +: 32];
  assign writeStream_w_payload_last = streamCounter_io_last;
  assign writeStream_w_payload_strb = dataStream_payload_strb[offset +: 4];
  assign rspCtrlStream_valid = rspCountStream_valid;
  assign rspCountStream_ready = rspCtrlStream_ready;
  assign rspCtrlStream_payload = generator_io_last;
  assign rspCtrlStream_ready = rspCtrlStream_fifo_io_push_ready;
  assign rspStream_valid = (rspCtrlStream_fifo_io_pop_valid && writeStream_b_valid);
  assign rspStream_fire = (rspStream_valid && rspStream_ready);
  assign writeStream_b_ready = rspStream_fire;
  assign rspStream_payload_1 = rspCtrlStream_fifo_io_pop_payload;
  assign rspStream_payload_2_resp = writeStream_b_payload_resp;
  assign when_Stream_l445 = (! rspStream_payload_1);
  always @(*) begin
    rspStream_thrown_valid = rspStream_valid;
    if(when_Stream_l445) begin
      rspStream_thrown_valid = 1'b0;
    end
  end

  always @(*) begin
    rspStream_ready = rspStream_thrown_ready;
    if(when_Stream_l445) begin
      rspStream_ready = 1'b1;
    end
  end

  assign rspStream_thrown_payload_2_resp = rspStream_payload_2_resp;
  assign rspStream_thrown_payload_1 = rspStream_payload_1;
  assign io_input_b_valid = rspStream_thrown_valid;
  assign rspStream_thrown_ready = io_input_b_ready;
  assign io_input_b_payload_resp = rspStream_thrown_payload_2_resp;
  assign io_output_aw_valid = writeStream_aw_valid;
  assign writeStream_aw_ready = io_output_aw_ready;
  assign io_output_aw_payload_addr = writeStream_aw_payload_addr;
  assign io_output_aw_payload_region = writeStream_aw_payload_region;
  assign io_output_aw_payload_len = writeStream_aw_payload_len;
  assign io_output_aw_payload_size = writeStream_aw_payload_size;
  assign io_output_aw_payload_lock = writeStream_aw_payload_lock;
  assign io_output_aw_payload_cache = writeStream_aw_payload_cache;
  assign io_output_aw_payload_qos = writeStream_aw_payload_qos;
  assign io_output_aw_payload_prot = writeStream_aw_payload_prot;
  assign io_output_w_valid = writeStream_w_valid;
  assign writeStream_w_ready = io_output_w_ready;
  assign io_output_w_payload_data = writeStream_w_payload_data;
  assign io_output_w_payload_strb = writeStream_w_payload_strb;
  assign io_output_w_payload_last = writeStream_w_payload_last;
  assign writeStream_b_valid = io_output_b_valid;
  assign io_output_b_ready = writeStream_b_ready;
  assign writeStream_b_payload_resp = io_output_b_payload_resp;
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      cmdStream_fork3_logic_linkEnable_0 <= 1'b1;
      cmdStream_fork3_logic_linkEnable_1 <= 1'b1;
      cmdStream_fork3_logic_linkEnable_2 <= 1'b1;
    end else begin
      if(rspCountStream_fire) begin
        cmdStream_fork3_logic_linkEnable_0 <= 1'b0;
      end
      if(countCmdStream_fire) begin
        cmdStream_fork3_logic_linkEnable_1 <= 1'b0;
      end
      if(outCmdStream_fire) begin
        cmdStream_fork3_logic_linkEnable_2 <= 1'b0;
      end
      if(cmdStream_ready) begin
        cmdStream_fork3_logic_linkEnable_0 <= 1'b1;
        cmdStream_fork3_logic_linkEnable_1 <= 1'b1;
        cmdStream_fork3_logic_linkEnable_2 <= 1'b1;
      end
    end
  end

  always @(posedge clk) begin
    if(countCmdStream_fire) begin
      beatOffsetReg <= countCmdStream_payload_addr[4 : 0];
    end
    if(dataStream_fire) begin
      beatOffsetReg <= _zz_beatOffsetReg[4:0];
    end
  end


endmodule

module axi2apb3_Axi4ReadOnlyDownsizer (
  input  wire          io_input_ar_valid,
  output wire          io_input_ar_ready,
  input  wire [31:0]   io_input_ar_payload_addr,
  input  wire [3:0]    io_input_ar_payload_region,
  input  wire [7:0]    io_input_ar_payload_len,
  input  wire [2:0]    io_input_ar_payload_size,
  input  wire [0:0]    io_input_ar_payload_lock,
  input  wire [3:0]    io_input_ar_payload_cache,
  input  wire [3:0]    io_input_ar_payload_qos,
  input  wire [2:0]    io_input_ar_payload_prot,
  output wire          io_input_r_valid,
  input  wire          io_input_r_ready,
  output wire [255:0]  io_input_r_payload_data,
  output wire [1:0]    io_input_r_payload_resp,
  output wire          io_input_r_payload_last,
  output wire          io_output_ar_valid,
  input  wire          io_output_ar_ready,
  output wire [31:0]   io_output_ar_payload_addr,
  output wire [3:0]    io_output_ar_payload_region,
  output wire [7:0]    io_output_ar_payload_len,
  output wire [2:0]    io_output_ar_payload_size,
  output wire [0:0]    io_output_ar_payload_lock,
  output wire [3:0]    io_output_ar_payload_cache,
  output wire [3:0]    io_output_ar_payload_qos,
  output wire [2:0]    io_output_ar_payload_prot,
  input  wire          io_output_r_valid,
  output reg           io_output_r_ready,
  input  wire [31:0]   io_output_r_payload_data,
  input  wire [1:0]    io_output_r_payload_resp,
  input  wire          io_output_r_payload_last,
  input  wire          clk,
  input  wire          reset
);

  wire                generator_io_input_ready;
  wire                generator_io_output_valid;
  wire       [31:0]   generator_io_output_payload_addr;
  wire       [3:0]    generator_io_output_payload_region;
  wire       [7:0]    generator_io_output_payload_len;
  wire       [2:0]    generator_io_output_payload_size;
  wire       [0:0]    generator_io_output_payload_lock;
  wire       [3:0]    generator_io_output_payload_cache;
  wire       [3:0]    generator_io_output_payload_qos;
  wire       [2:0]    generator_io_output_payload_prot;
  wire       [31:0]   generator_io_start;
  wire       [6:0]    generator_io_ratio;
  wire       [2:0]    generator_io_size;
  wire                generator_io_working;
  wire                generator_io_last;
  wire                generator_io_done;
  wire                dataOutCounter_io_input_ready;
  wire                dataOutCounter_io_output_valid;
  wire       [6:0]    dataOutCounter_io_output_payload_ratio;
  wire       [2:0]    dataOutCounter_io_output_payload_size;
  wire       [7:0]    dataOutCounter_io_output_payload_len;
  wire       [31:0]   dataOutCounter_io_output_payload_start;
  wire                dataOutCounter_io_working;
  wire                dataOutCounter_io_first;
  wire                dataOutCounter_io_last;
  wire                dataOutCounter_io_done;
  wire                dataCounter_io_input_ready;
  wire                dataCounter_io_output_valid;
  wire       [6:0]    dataCounter_io_output_payload_ratio;
  wire       [2:0]    dataCounter_io_output_payload_size;
  wire       [7:0]    dataCounter_io_output_payload_len;
  wire       [31:0]   dataCounter_io_output_payload_start;
  wire                dataCounter_io_working;
  wire                dataCounter_io_first;
  wire                dataCounter_io_last;
  wire                dataCounter_io_done;
  wire       [7:0]    _zz_beatOffset;
  wire       [7:0]    _zz_beatOffset_1;
  wire       [7:0]    _zz_beatOffset_2;
  wire       [7:0]    _zz_dataReg_aheadValue;
  (* nowrshmsk *) reg        [255:0]  dataReg_aheadValue;
  wire                readCmdGen_valid;
  wire                readCmdGen_ready;
  wire       [31:0]   readCmdGen_payload_addr;
  wire       [3:0]    readCmdGen_payload_region;
  wire       [7:0]    readCmdGen_payload_len;
  wire       [2:0]    readCmdGen_payload_size;
  wire       [0:0]    readCmdGen_payload_lock;
  wire       [3:0]    readCmdGen_payload_cache;
  wire       [3:0]    readCmdGen_payload_qos;
  wire       [2:0]    readCmdGen_payload_prot;
  wire                readCmdCount_valid;
  wire                readCmdCount_ready;
  wire       [31:0]   readCmdCount_payload_addr;
  wire       [3:0]    readCmdCount_payload_region;
  wire       [7:0]    readCmdCount_payload_len;
  wire       [2:0]    readCmdCount_payload_size;
  wire       [0:0]    readCmdCount_payload_lock;
  wire       [3:0]    readCmdCount_payload_cache;
  wire       [3:0]    readCmdCount_payload_qos;
  wire       [2:0]    readCmdCount_payload_prot;
  wire                cmdStream_valid;
  wire                cmdStream_ready;
  wire       [31:0]   cmdStream_payload_addr;
  wire       [3:0]    cmdStream_payload_region;
  wire       [7:0]    cmdStream_payload_len;
  wire       [2:0]    cmdStream_payload_size;
  wire       [0:0]    cmdStream_payload_lock;
  wire       [3:0]    cmdStream_payload_cache;
  wire       [3:0]    cmdStream_payload_qos;
  wire       [2:0]    cmdStream_payload_prot;
  wire       [6:0]    cmdState_ratio;
  wire       [2:0]    cmdState_size;
  wire       [7:0]    cmdState_len;
  wire       [31:0]   cmdState_start;
  wire                countCmdStream_valid;
  wire                countCmdStream_ready;
  wire       [6:0]    countCmdStream_payload_ratio;
  wire       [2:0]    countCmdStream_payload_size;
  wire       [7:0]    countCmdStream_payload_len;
  wire       [31:0]   countCmdStream_payload_start;
  wire                countOutStream_valid;
  wire                countOutStream_ready;
  wire       [6:0]    countOutStream_payload_ratio;
  wire       [2:0]    countOutStream_payload_size;
  wire       [7:0]    countOutStream_payload_len;
  wire       [31:0]   countOutStream_payload_start;
  wire                countStream_valid;
  wire                countStream_ready;
  wire       [6:0]    countStream_payload_ratio;
  wire       [2:0]    countStream_payload_size;
  wire       [7:0]    countStream_payload_len;
  wire       [31:0]   countStream_payload_start;
  wire                io_output_r_fire;
  reg        [255:0]  dataReg;
  reg        [4:0]    beatOffset;
  wire                countOutStream_fire;
  wire                when_Axi4Downsizer_l227;
  wire       [4:0]    offset;
  wire                dataOut_valid;
  wire                dataOut_ready;
  wire       [255:0]  dataOut_payload_data;
  wire       [1:0]    dataOut_payload_resp;
  wire                dataOut_payload_last;
  reg                 lastLast;
  wire                when_Axi4Downsizer_l242;
  wire                when_Axi4Downsizer_l244;
  wire                when_Stream_l445;
  reg                 io_output_r_thrown_valid;
  wire                io_output_r_thrown_ready;
  wire       [31:0]   io_output_r_thrown_payload_data;
  wire       [1:0]    io_output_r_thrown_payload_resp;
  wire                io_output_r_thrown_payload_last;

  assign _zz_dataReg_aheadValue = ({3'd0,offset} <<< 2'd3);
  assign _zz_beatOffset = (_zz_beatOffset_1 + _zz_beatOffset_2);
  assign _zz_beatOffset_1 = {3'd0, beatOffset};
  assign _zz_beatOffset_2 = ({7'd0,1'b1} <<< countStream_payload_size);
  axi2apb3_Axi4DownsizerSubTransactionGenerator_1 generator (
    .io_input_valid           (readCmdGen_valid                       ), //i
    .io_input_ready           (generator_io_input_ready               ), //o
    .io_input_payload_addr    (readCmdGen_payload_addr[31:0]          ), //i
    .io_input_payload_region  (readCmdGen_payload_region[3:0]         ), //i
    .io_input_payload_len     (readCmdGen_payload_len[7:0]            ), //i
    .io_input_payload_size    (readCmdGen_payload_size[2:0]           ), //i
    .io_input_payload_lock    (readCmdGen_payload_lock                ), //i
    .io_input_payload_cache   (readCmdGen_payload_cache[3:0]          ), //i
    .io_input_payload_qos     (readCmdGen_payload_qos[3:0]            ), //i
    .io_input_payload_prot    (readCmdGen_payload_prot[2:0]           ), //i
    .io_output_valid          (generator_io_output_valid              ), //o
    .io_output_ready          (cmdStream_ready                        ), //i
    .io_output_payload_addr   (generator_io_output_payload_addr[31:0] ), //o
    .io_output_payload_region (generator_io_output_payload_region[3:0]), //o
    .io_output_payload_len    (generator_io_output_payload_len[7:0]   ), //o
    .io_output_payload_size   (generator_io_output_payload_size[2:0]  ), //o
    .io_output_payload_lock   (generator_io_output_payload_lock       ), //o
    .io_output_payload_cache  (generator_io_output_payload_cache[3:0] ), //o
    .io_output_payload_qos    (generator_io_output_payload_qos[3:0]   ), //o
    .io_output_payload_prot   (generator_io_output_payload_prot[2:0]  ), //o
    .io_start                 (generator_io_start[31:0]               ), //o
    .io_ratio                 (generator_io_ratio[6:0]                ), //o
    .io_size                  (generator_io_size[2:0]                 ), //o
    .io_working               (generator_io_working                   ), //o
    .io_last                  (generator_io_last                      ), //o
    .io_done                  (generator_io_done                      ), //o
    .clk                      (clk                                    ), //i
    .reset                    (reset                                  )  //i
  );
  axi2apb3_StreamTransactionExtender_1 dataOutCounter (
    .io_count                (countCmdStream_payload_len[7:0]             ), //i
    .io_input_valid          (countCmdStream_valid                        ), //i
    .io_input_ready          (dataOutCounter_io_input_ready               ), //o
    .io_input_payload_ratio  (countCmdStream_payload_ratio[6:0]           ), //i
    .io_input_payload_size   (countCmdStream_payload_size[2:0]            ), //i
    .io_input_payload_len    (countCmdStream_payload_len[7:0]             ), //i
    .io_input_payload_start  (countCmdStream_payload_start[31:0]          ), //i
    .io_output_valid         (dataOutCounter_io_output_valid              ), //o
    .io_output_ready         (countOutStream_ready                        ), //i
    .io_output_payload_ratio (dataOutCounter_io_output_payload_ratio[6:0] ), //o
    .io_output_payload_size  (dataOutCounter_io_output_payload_size[2:0]  ), //o
    .io_output_payload_len   (dataOutCounter_io_output_payload_len[7:0]   ), //o
    .io_output_payload_start (dataOutCounter_io_output_payload_start[31:0]), //o
    .io_working              (dataOutCounter_io_working                   ), //o
    .io_first                (dataOutCounter_io_first                     ), //o
    .io_last                 (dataOutCounter_io_last                      ), //o
    .io_done                 (dataOutCounter_io_done                      ), //o
    .clk                     (clk                                         ), //i
    .reset                   (reset                                       )  //i
  );
  axi2apb3_StreamTransactionExtender_2 dataCounter (
    .io_count                (countOutStream_payload_ratio[6:0]        ), //i
    .io_input_valid          (countOutStream_valid                     ), //i
    .io_input_ready          (dataCounter_io_input_ready               ), //o
    .io_input_payload_ratio  (countOutStream_payload_ratio[6:0]        ), //i
    .io_input_payload_size   (countOutStream_payload_size[2:0]         ), //i
    .io_input_payload_len    (countOutStream_payload_len[7:0]          ), //i
    .io_input_payload_start  (countOutStream_payload_start[31:0]       ), //i
    .io_output_valid         (dataCounter_io_output_valid              ), //o
    .io_output_ready         (countStream_ready                        ), //i
    .io_output_payload_ratio (dataCounter_io_output_payload_ratio[6:0] ), //o
    .io_output_payload_size  (dataCounter_io_output_payload_size[2:0]  ), //o
    .io_output_payload_len   (dataCounter_io_output_payload_len[7:0]   ), //o
    .io_output_payload_start (dataCounter_io_output_payload_start[31:0]), //o
    .io_working              (dataCounter_io_working                   ), //o
    .io_first                (dataCounter_io_first                     ), //o
    .io_last                 (dataCounter_io_last                      ), //o
    .io_done                 (dataCounter_io_done                      ), //o
    .clk                     (clk                                      ), //i
    .reset                   (reset                                    )  //i
  );
  always @(*) begin
    dataReg_aheadValue = dataReg;
    if(io_output_r_valid) begin
      dataReg_aheadValue[_zz_dataReg_aheadValue +: 32] = io_output_r_payload_data;
    end
  end

  assign io_input_ar_ready = (readCmdGen_ready && readCmdCount_ready);
  assign readCmdGen_valid = (io_input_ar_valid && io_input_ar_ready);
  assign readCmdCount_valid = (io_input_ar_valid && io_input_ar_ready);
  assign readCmdGen_payload_addr = io_input_ar_payload_addr;
  assign readCmdGen_payload_region = io_input_ar_payload_region;
  assign readCmdGen_payload_len = io_input_ar_payload_len;
  assign readCmdGen_payload_size = io_input_ar_payload_size;
  assign readCmdGen_payload_lock = io_input_ar_payload_lock;
  assign readCmdGen_payload_cache = io_input_ar_payload_cache;
  assign readCmdGen_payload_qos = io_input_ar_payload_qos;
  assign readCmdGen_payload_prot = io_input_ar_payload_prot;
  assign readCmdCount_payload_addr = io_input_ar_payload_addr;
  assign readCmdCount_payload_region = io_input_ar_payload_region;
  assign readCmdCount_payload_len = io_input_ar_payload_len;
  assign readCmdCount_payload_size = io_input_ar_payload_size;
  assign readCmdCount_payload_lock = io_input_ar_payload_lock;
  assign readCmdCount_payload_cache = io_input_ar_payload_cache;
  assign readCmdCount_payload_qos = io_input_ar_payload_qos;
  assign readCmdCount_payload_prot = io_input_ar_payload_prot;
  assign readCmdGen_ready = generator_io_input_ready;
  assign cmdStream_valid = generator_io_output_valid;
  assign cmdStream_payload_addr = generator_io_output_payload_addr;
  assign cmdStream_payload_region = generator_io_output_payload_region;
  assign cmdStream_payload_len = generator_io_output_payload_len;
  assign cmdStream_payload_size = generator_io_output_payload_size;
  assign cmdStream_payload_lock = generator_io_output_payload_lock;
  assign cmdStream_payload_cache = generator_io_output_payload_cache;
  assign cmdStream_payload_qos = generator_io_output_payload_qos;
  assign cmdStream_payload_prot = generator_io_output_payload_prot;
  assign io_output_ar_valid = cmdStream_valid;
  assign cmdStream_ready = io_output_ar_ready;
  assign io_output_ar_payload_addr = cmdStream_payload_addr;
  assign io_output_ar_payload_region = cmdStream_payload_region;
  assign io_output_ar_payload_len = cmdStream_payload_len;
  assign io_output_ar_payload_size = cmdStream_payload_size;
  assign io_output_ar_payload_lock = cmdStream_payload_lock;
  assign io_output_ar_payload_cache = cmdStream_payload_cache;
  assign io_output_ar_payload_qos = cmdStream_payload_qos;
  assign io_output_ar_payload_prot = cmdStream_payload_prot;
  assign countCmdStream_valid = readCmdCount_valid;
  assign readCmdCount_ready = countCmdStream_ready;
  assign countCmdStream_payload_ratio = generator_io_ratio;
  assign countCmdStream_payload_size = generator_io_size;
  assign countCmdStream_payload_len = readCmdCount_payload_len;
  assign countCmdStream_payload_start = generator_io_start;
  assign countCmdStream_ready = dataOutCounter_io_input_ready;
  assign countOutStream_valid = dataOutCounter_io_output_valid;
  assign countOutStream_payload_ratio = dataOutCounter_io_output_payload_ratio;
  assign countOutStream_payload_size = dataOutCounter_io_output_payload_size;
  assign countOutStream_payload_len = dataOutCounter_io_output_payload_len;
  assign countOutStream_payload_start = dataOutCounter_io_output_payload_start;
  assign countOutStream_ready = dataCounter_io_input_ready;
  assign countStream_valid = dataCounter_io_output_valid;
  assign countStream_payload_ratio = dataCounter_io_output_payload_ratio;
  assign countStream_payload_size = dataCounter_io_output_payload_size;
  assign countStream_payload_len = dataCounter_io_output_payload_len;
  assign countStream_payload_start = dataCounter_io_output_payload_start;
  assign io_output_r_fire = (io_output_r_valid && io_output_r_ready);
  assign countStream_ready = io_output_r_fire;
  assign countOutStream_fire = (countOutStream_valid && countOutStream_ready);
  assign when_Axi4Downsizer_l227 = (countOutStream_fire && dataOutCounter_io_first);
  assign offset = (beatOffset & (~ 5'h03));
  assign when_Axi4Downsizer_l242 = ((dataOutCounter_io_working && dataOutCounter_io_last) && countOutStream_fire);
  assign when_Axi4Downsizer_l244 = (dataCounter_io_last && io_output_r_fire);
  assign when_Stream_l445 = (! dataCounter_io_last);
  always @(*) begin
    io_output_r_thrown_valid = io_output_r_valid;
    if(when_Stream_l445) begin
      io_output_r_thrown_valid = 1'b0;
    end
  end

  always @(*) begin
    io_output_r_ready = io_output_r_thrown_ready;
    if(when_Stream_l445) begin
      io_output_r_ready = 1'b1;
    end
  end

  assign io_output_r_thrown_payload_data = io_output_r_payload_data;
  assign io_output_r_thrown_payload_resp = io_output_r_payload_resp;
  assign io_output_r_thrown_payload_last = io_output_r_payload_last;
  assign dataOut_valid = io_output_r_thrown_valid;
  assign io_output_r_thrown_ready = dataOut_ready;
  assign dataOut_payload_data = dataReg_aheadValue;
  assign dataOut_payload_last = (io_output_r_thrown_payload_last && lastLast);
  assign dataOut_payload_resp = io_output_r_thrown_payload_resp;
  assign io_input_r_valid = dataOut_valid;
  assign dataOut_ready = io_input_r_ready;
  assign io_input_r_payload_data = dataOut_payload_data;
  assign io_input_r_payload_resp = dataOut_payload_resp;
  assign io_input_r_payload_last = dataOut_payload_last;
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      dataReg <= 256'h0;
      beatOffset <= 5'h0;
      lastLast <= 1'b0;
    end else begin
      if(when_Axi4Downsizer_l227) begin
        beatOffset <= countOutStream_payload_start[4 : 0];
      end else begin
        if(io_output_r_fire) begin
          beatOffset <= _zz_beatOffset[4:0];
        end
      end
      if(when_Axi4Downsizer_l242) begin
        lastLast <= 1'b1;
      end else begin
        if(when_Axi4Downsizer_l244) begin
          lastLast <= 1'b0;
        end
      end
      dataReg <= dataReg_aheadValue;
    end
  end


endmodule

module axi2apb3_StreamFifo (
  input  wire          io_push_valid,
  output wire          io_push_ready,
  input  wire          io_push_payload,
  output wire          io_pop_valid,
  input  wire          io_pop_ready,
  output wire          io_pop_payload,
  input  wire          io_flush,
  output wire [1:0]    io_occupancy,
  output wire [1:0]    io_availability,
  input  wire          clk,
  input  wire          reset
);

  reg        [0:0]    logic_ram_spinal_port1;
  wire       [0:0]    _zz_logic_ram_port;
  reg                 _zz_1;
  wire                logic_ptr_doPush;
  wire                logic_ptr_doPop;
  wire                logic_ptr_full;
  wire                logic_ptr_empty;
  reg        [1:0]    logic_ptr_push;
  reg        [1:0]    logic_ptr_pop;
  wire       [1:0]    logic_ptr_occupancy;
  wire       [1:0]    logic_ptr_popOnIo;
  wire                when_Stream_l1248;
  reg                 logic_ptr_wentUp;
  wire                io_push_fire;
  wire                logic_push_onRam_write_valid;
  wire       [0:0]    logic_push_onRam_write_payload_address;
  wire                logic_push_onRam_write_payload_data;
  wire                logic_pop_addressGen_valid;
  reg                 logic_pop_addressGen_ready;
  wire       [0:0]    logic_pop_addressGen_payload;
  wire                logic_pop_addressGen_fire;
  wire                logic_pop_sync_readArbitation_valid;
  wire                logic_pop_sync_readArbitation_ready;
  wire       [0:0]    logic_pop_sync_readArbitation_payload;
  reg                 logic_pop_addressGen_rValid;
  reg        [0:0]    logic_pop_addressGen_rData;
  wire                when_Stream_l375;
  wire                logic_pop_sync_readPort_cmd_valid;
  wire       [0:0]    logic_pop_sync_readPort_cmd_payload;
  wire                logic_pop_sync_readPort_rsp;
  wire                logic_pop_sync_readArbitation_translated_valid;
  wire                logic_pop_sync_readArbitation_translated_ready;
  wire                logic_pop_sync_readArbitation_translated_payload;
  wire                logic_pop_sync_readArbitation_fire;
  reg        [1:0]    logic_pop_sync_popReg;
  reg [0:0] logic_ram [0:1];

  assign _zz_logic_ram_port = logic_push_onRam_write_payload_data;
  always @(posedge clk) begin
    if(_zz_1) begin
      logic_ram[logic_push_onRam_write_payload_address] <= _zz_logic_ram_port;
    end
  end

  always @(posedge clk) begin
    if(logic_pop_sync_readPort_cmd_valid) begin
      logic_ram_spinal_port1 <= logic_ram[logic_pop_sync_readPort_cmd_payload];
    end
  end

  always @(*) begin
    _zz_1 = 1'b0;
    if(logic_push_onRam_write_valid) begin
      _zz_1 = 1'b1;
    end
  end

  assign when_Stream_l1248 = (logic_ptr_doPush != logic_ptr_doPop);
  assign logic_ptr_full = (((logic_ptr_push ^ logic_ptr_popOnIo) ^ 2'b10) == 2'b00);
  assign logic_ptr_empty = (logic_ptr_push == logic_ptr_pop);
  assign logic_ptr_occupancy = (logic_ptr_push - logic_ptr_popOnIo);
  assign io_push_ready = (! logic_ptr_full);
  assign io_push_fire = (io_push_valid && io_push_ready);
  assign logic_ptr_doPush = io_push_fire;
  assign logic_push_onRam_write_valid = io_push_fire;
  assign logic_push_onRam_write_payload_address = logic_ptr_push[0:0];
  assign logic_push_onRam_write_payload_data = io_push_payload;
  assign logic_pop_addressGen_valid = (! logic_ptr_empty);
  assign logic_pop_addressGen_payload = logic_ptr_pop[0:0];
  assign logic_pop_addressGen_fire = (logic_pop_addressGen_valid && logic_pop_addressGen_ready);
  assign logic_ptr_doPop = logic_pop_addressGen_fire;
  always @(*) begin
    logic_pop_addressGen_ready = logic_pop_sync_readArbitation_ready;
    if(when_Stream_l375) begin
      logic_pop_addressGen_ready = 1'b1;
    end
  end

  assign when_Stream_l375 = (! logic_pop_sync_readArbitation_valid);
  assign logic_pop_sync_readArbitation_valid = logic_pop_addressGen_rValid;
  assign logic_pop_sync_readArbitation_payload = logic_pop_addressGen_rData;
  assign logic_pop_sync_readPort_rsp = logic_ram_spinal_port1[0];
  assign logic_pop_sync_readPort_cmd_valid = logic_pop_addressGen_fire;
  assign logic_pop_sync_readPort_cmd_payload = logic_pop_addressGen_payload;
  assign logic_pop_sync_readArbitation_translated_valid = logic_pop_sync_readArbitation_valid;
  assign logic_pop_sync_readArbitation_ready = logic_pop_sync_readArbitation_translated_ready;
  assign logic_pop_sync_readArbitation_translated_payload = logic_pop_sync_readPort_rsp;
  assign io_pop_valid = logic_pop_sync_readArbitation_translated_valid;
  assign logic_pop_sync_readArbitation_translated_ready = io_pop_ready;
  assign io_pop_payload = logic_pop_sync_readArbitation_translated_payload;
  assign logic_pop_sync_readArbitation_fire = (logic_pop_sync_readArbitation_valid && logic_pop_sync_readArbitation_ready);
  assign logic_ptr_popOnIo = logic_pop_sync_popReg;
  assign io_occupancy = logic_ptr_occupancy;
  assign io_availability = (2'b10 - logic_ptr_occupancy);
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      logic_ptr_push <= 2'b00;
      logic_ptr_pop <= 2'b00;
      logic_ptr_wentUp <= 1'b0;
      logic_pop_addressGen_rValid <= 1'b0;
      logic_pop_sync_popReg <= 2'b00;
    end else begin
      if(when_Stream_l1248) begin
        logic_ptr_wentUp <= logic_ptr_doPush;
      end
      if(io_flush) begin
        logic_ptr_wentUp <= 1'b0;
      end
      if(logic_ptr_doPush) begin
        logic_ptr_push <= (logic_ptr_push + 2'b01);
      end
      if(logic_ptr_doPop) begin
        logic_ptr_pop <= (logic_ptr_pop + 2'b01);
      end
      if(io_flush) begin
        logic_ptr_push <= 2'b00;
        logic_ptr_pop <= 2'b00;
      end
      if(logic_pop_addressGen_ready) begin
        logic_pop_addressGen_rValid <= logic_pop_addressGen_valid;
      end
      if(io_flush) begin
        logic_pop_addressGen_rValid <= 1'b0;
      end
      if(logic_pop_sync_readArbitation_fire) begin
        logic_pop_sync_popReg <= logic_ptr_pop;
      end
      if(io_flush) begin
        logic_pop_sync_popReg <= 2'b00;
      end
    end
  end

  always @(posedge clk) begin
    if(logic_pop_addressGen_ready) begin
      logic_pop_addressGen_rData <= logic_pop_addressGen_payload;
    end
  end


endmodule

module axi2apb3_StreamTransactionExtender (
  input  wire [6:0]    io_count,
  input  wire          io_input_valid,
  output wire          io_input_ready,
  input  wire [255:0]  io_input_payload_data,
  input  wire [31:0]   io_input_payload_strb,
  input  wire          io_input_payload_last,
  output wire          io_output_valid,
  input  wire          io_output_ready,
  output wire [255:0]  io_output_payload_data,
  output wire [31:0]   io_output_payload_strb,
  output wire          io_output_payload_last,
  output wire          io_working,
  output wire          io_first,
  output wire          io_last,
  output wire          io_done,
  input  wire          clk,
  input  wire          reset
);

  wire                counter_io_available;
  wire                counter_io_working;
  wire                counter_io_last;
  wire                counter_io_done;
  wire       [6:0]    counter_io_value;
  wire                io_input_fire;
  wire                io_output_fire;
  reg        [255:0]  payloadReg_data;
  reg        [31:0]   payloadReg_strb;
  reg                 payloadReg_last;
  wire       [255:0]  payload_data;
  wire       [31:0]   payload_strb;
  wire                payload_last;

  axi2apb3_StreamTransactionCounter_6 counter (
    .io_ctrlFire   (io_input_fire        ), //i
    .io_targetFire (io_output_fire       ), //i
    .io_available  (counter_io_available ), //o
    .io_count      (io_count[6:0]        ), //i
    .io_working    (counter_io_working   ), //o
    .io_last       (counter_io_last      ), //o
    .io_done       (counter_io_done      ), //o
    .io_value      (counter_io_value[6:0]), //o
    .clk           (clk                  ), //i
    .reset         (reset                )  //i
  );
  assign io_input_fire = (io_input_valid && io_input_ready);
  assign io_output_fire = (io_output_valid && io_output_ready);
  assign payload_data = payloadReg_data;
  assign payload_strb = payloadReg_strb;
  assign payload_last = payloadReg_last;
  assign io_output_payload_data = payload_data;
  assign io_output_payload_strb = payload_strb;
  assign io_output_payload_last = (counter_io_last && payload_last);
  assign io_output_valid = counter_io_working;
  assign io_input_ready = counter_io_available;
  assign io_last = counter_io_last;
  assign io_done = counter_io_done;
  assign io_first = ((counter_io_value == 7'h0) && counter_io_working);
  assign io_working = counter_io_working;
  always @(posedge clk) begin
    if(io_input_fire) begin
      payloadReg_data <= io_input_payload_data;
      payloadReg_strb <= io_input_payload_strb;
      payloadReg_last <= io_input_payload_last;
    end
  end


endmodule

//axi2apb3_StreamTransactionCounter_1 replaced by axi2apb3_StreamTransactionCounter

module axi2apb3_StreamTransactionCounter (
  input  wire          io_ctrlFire,
  input  wire          io_targetFire,
  output wire          io_available,
  input  wire [7:0]    io_count,
  output wire          io_working,
  output wire          io_last,
  output wire          io_done,
  output wire [7:0]    io_value,
  input  wire          clk,
  input  wire          reset
);

  wire       [7:0]    _zz_counter_valueNext;
  wire       [0:0]    _zz_counter_valueNext_1;
  reg        [7:0]    expected;
  reg        [7:0]    countReg;
  reg                 counter_willIncrement;
  reg                 counter_willClear;
  reg        [7:0]    counter_valueNext;
  reg        [7:0]    counter_value;
  wire                counter_willOverflowIfInc;
  wire                counter_willOverflow;
  wire                lastOne;
  reg                 running;
  reg                 working;
  wire                done;
  wire                when_Stream_l2200;

  assign _zz_counter_valueNext_1 = counter_willIncrement;
  assign _zz_counter_valueNext = {7'd0, _zz_counter_valueNext_1};
  always @(*) begin
    expected = countReg;
    if(io_ctrlFire) begin
      expected = io_count;
    end
  end

  always @(*) begin
    counter_willIncrement = 1'b0;
    if(!done) begin
      if(when_Stream_l2200) begin
        counter_willIncrement = 1'b1;
      end
    end
  end

  always @(*) begin
    counter_willClear = 1'b0;
    if(done) begin
      counter_willClear = 1'b1;
    end
  end

  assign counter_willOverflowIfInc = (counter_value == 8'hff);
  assign counter_willOverflow = (counter_willOverflowIfInc && counter_willIncrement);
  always @(*) begin
    counter_valueNext = (counter_value + _zz_counter_valueNext);
    if(counter_willClear) begin
      counter_valueNext = 8'h0;
    end
  end

  assign lastOne = (expected <= counter_value);
  always @(*) begin
    working = running;
    if(io_ctrlFire) begin
      working = 1'b1;
    end
  end

  assign done = (lastOne && io_targetFire);
  assign when_Stream_l2200 = (io_targetFire && working);
  assign io_working = working;
  assign io_last = (lastOne && working);
  assign io_done = (done && working);
  assign io_value = counter_value;
  assign io_available = (! running);
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      counter_value <= 8'h0;
      running <= 1'b0;
    end else begin
      counter_value <= counter_valueNext;
      if(done) begin
        running <= 1'b0;
      end else begin
        running <= working;
      end
    end
  end

  always @(posedge clk) begin
    countReg <= expected;
  end


endmodule

//axi2apb3_Axi4DownsizerSubTransactionGenerator replaced by axi2apb3_Axi4DownsizerSubTransactionGenerator_1

module axi2apb3_StreamTransactionExtender_2 (
  input  wire [6:0]    io_count,
  input  wire          io_input_valid,
  output wire          io_input_ready,
  input  wire [6:0]    io_input_payload_ratio,
  input  wire [2:0]    io_input_payload_size,
  input  wire [7:0]    io_input_payload_len,
  input  wire [31:0]   io_input_payload_start,
  output wire          io_output_valid,
  input  wire          io_output_ready,
  output wire [6:0]    io_output_payload_ratio,
  output wire [2:0]    io_output_payload_size,
  output wire [7:0]    io_output_payload_len,
  output wire [31:0]   io_output_payload_start,
  output wire          io_working,
  output wire          io_first,
  output wire          io_last,
  output wire          io_done,
  input  wire          clk,
  input  wire          reset
);

  wire                counter_io_available;
  wire                counter_io_working;
  wire                counter_io_last;
  wire                counter_io_done;
  wire       [6:0]    counter_io_value;
  wire                io_input_fire;
  wire                io_output_fire;
  reg        [6:0]    payloadReg_ratio;
  reg        [2:0]    payloadReg_size;
  reg        [7:0]    payloadReg_len;
  reg        [31:0]   payloadReg_start;
  wire       [6:0]    payload_ratio;
  wire       [2:0]    payload_size;
  wire       [7:0]    payload_len;
  wire       [31:0]   payload_start;

  axi2apb3_StreamTransactionCounter_6 counter (
    .io_ctrlFire   (io_input_fire        ), //i
    .io_targetFire (io_output_fire       ), //i
    .io_available  (counter_io_available ), //o
    .io_count      (io_count[6:0]        ), //i
    .io_working    (counter_io_working   ), //o
    .io_last       (counter_io_last      ), //o
    .io_done       (counter_io_done      ), //o
    .io_value      (counter_io_value[6:0]), //o
    .clk           (clk                  ), //i
    .reset         (reset                )  //i
  );
  assign io_input_fire = (io_input_valid && io_input_ready);
  assign io_output_fire = (io_output_valid && io_output_ready);
  assign payload_ratio = payloadReg_ratio;
  assign payload_size = payloadReg_size;
  assign payload_len = payloadReg_len;
  assign payload_start = payloadReg_start;
  assign io_output_payload_ratio = payload_ratio;
  assign io_output_payload_size = payload_size;
  assign io_output_payload_len = payload_len;
  assign io_output_payload_start = payload_start;
  assign io_output_valid = counter_io_working;
  assign io_input_ready = counter_io_available;
  assign io_last = counter_io_last;
  assign io_done = counter_io_done;
  assign io_first = ((counter_io_value == 7'h0) && counter_io_working);
  assign io_working = counter_io_working;
  always @(posedge clk) begin
    if(io_input_fire) begin
      payloadReg_ratio <= io_input_payload_ratio;
      payloadReg_size <= io_input_payload_size;
      payloadReg_len <= io_input_payload_len;
      payloadReg_start <= io_input_payload_start;
    end
  end


endmodule

module axi2apb3_StreamTransactionExtender_1 (
  input  wire [7:0]    io_count,
  input  wire          io_input_valid,
  output wire          io_input_ready,
  input  wire [6:0]    io_input_payload_ratio,
  input  wire [2:0]    io_input_payload_size,
  input  wire [7:0]    io_input_payload_len,
  input  wire [31:0]   io_input_payload_start,
  output wire          io_output_valid,
  input  wire          io_output_ready,
  output wire [6:0]    io_output_payload_ratio,
  output wire [2:0]    io_output_payload_size,
  output wire [7:0]    io_output_payload_len,
  output wire [31:0]   io_output_payload_start,
  output wire          io_working,
  output wire          io_first,
  output wire          io_last,
  output wire          io_done,
  input  wire          clk,
  input  wire          reset
);

  wire                counter_io_available;
  wire                counter_io_working;
  wire                counter_io_last;
  wire                counter_io_done;
  wire       [7:0]    counter_io_value;
  wire                io_input_fire;
  wire                io_output_fire;
  reg        [6:0]    payloadReg_ratio;
  reg        [2:0]    payloadReg_size;
  reg        [7:0]    payloadReg_len;
  reg        [31:0]   payloadReg_start;
  wire       [6:0]    payload_ratio;
  wire       [2:0]    payload_size;
  wire       [7:0]    payload_len;
  wire       [31:0]   payload_start;

  axi2apb3_StreamTransactionCounter_4 counter (
    .io_ctrlFire   (io_input_fire        ), //i
    .io_targetFire (io_output_fire       ), //i
    .io_available  (counter_io_available ), //o
    .io_count      (io_count[7:0]        ), //i
    .io_working    (counter_io_working   ), //o
    .io_last       (counter_io_last      ), //o
    .io_done       (counter_io_done      ), //o
    .io_value      (counter_io_value[7:0]), //o
    .clk           (clk                  ), //i
    .reset         (reset                )  //i
  );
  assign io_input_fire = (io_input_valid && io_input_ready);
  assign io_output_fire = (io_output_valid && io_output_ready);
  assign payload_ratio = payloadReg_ratio;
  assign payload_size = payloadReg_size;
  assign payload_len = payloadReg_len;
  assign payload_start = payloadReg_start;
  assign io_output_payload_ratio = payload_ratio;
  assign io_output_payload_size = payload_size;
  assign io_output_payload_len = payload_len;
  assign io_output_payload_start = payload_start;
  assign io_output_valid = counter_io_working;
  assign io_input_ready = counter_io_available;
  assign io_last = counter_io_last;
  assign io_done = counter_io_done;
  assign io_first = ((counter_io_value == 8'h0) && counter_io_working);
  assign io_working = counter_io_working;
  always @(posedge clk) begin
    if(io_input_fire) begin
      payloadReg_ratio <= io_input_payload_ratio;
      payloadReg_size <= io_input_payload_size;
      payloadReg_len <= io_input_payload_len;
      payloadReg_start <= io_input_payload_start;
    end
  end


endmodule

module axi2apb3_Axi4DownsizerSubTransactionGenerator_1 (
  input  wire          io_input_valid,
  output wire          io_input_ready,
  input  wire [31:0]   io_input_payload_addr,
  input  wire [3:0]    io_input_payload_region,
  input  wire [7:0]    io_input_payload_len,
  input  wire [2:0]    io_input_payload_size,
  input  wire [0:0]    io_input_payload_lock,
  input  wire [3:0]    io_input_payload_cache,
  input  wire [3:0]    io_input_payload_qos,
  input  wire [2:0]    io_input_payload_prot,
  output wire          io_output_valid,
  input  wire          io_output_ready,
  output wire [31:0]   io_output_payload_addr,
  output wire [3:0]    io_output_payload_region,
  output wire [7:0]    io_output_payload_len,
  output wire [2:0]    io_output_payload_size,
  output wire [0:0]    io_output_payload_lock,
  output wire [3:0]    io_output_payload_cache,
  output wire [3:0]    io_output_payload_qos,
  output wire [2:0]    io_output_payload_prot,
  output wire [31:0]   io_start,
  output reg  [6:0]    io_ratio,
  output reg  [2:0]    io_size,
  output wire          io_working,
  output wire          io_last,
  output wire          io_done,
  input  wire          clk,
  input  wire          reset
);

  wire                cmdExtender_io_input_ready;
  wire                cmdExtender_io_output_valid;
  wire       [31:0]   cmdExtender_io_output_payload_addr;
  wire       [3:0]    cmdExtender_io_output_payload_region;
  wire       [7:0]    cmdExtender_io_output_payload_len;
  wire       [2:0]    cmdExtender_io_output_payload_size;
  wire       [0:0]    cmdExtender_io_output_payload_lock;
  wire       [3:0]    cmdExtender_io_output_payload_cache;
  wire       [3:0]    cmdExtender_io_output_payload_qos;
  wire       [2:0]    cmdExtender_io_output_payload_prot;
  wire                cmdExtender_io_working;
  wire                cmdExtender_io_first;
  wire                cmdExtender_io_last;
  wire                cmdExtender_io_done;
  wire       [31:0]   _zz_startAddress;
  wire       [6:0]    _zz_ratio;
  wire       [31:0]   _zz_address;
  wire       [15:0]   _zz_address_1;
  wire       [8:0]    _zz_address_2;
  wire       [8:0]    _zz_address_3;
  wire       [1:0]    _zz_address_4;
  reg        [31:0]   startAddress;
  wire       [2:0]    sizeDiff;
  reg        [2:0]    sizePerTrans;
  reg        [6:0]    ratio;
  wire                when_Axi4Downsizer_l48;
  wire                cmdStreamWithSize_valid;
  wire                cmdStreamWithSize_ready;
  wire       [31:0]   cmdStreamWithSize_payload_addr;
  wire       [3:0]    cmdStreamWithSize_payload_region;
  wire       [7:0]    cmdStreamWithSize_payload_len;
  wire       [2:0]    cmdStreamWithSize_payload_size;
  wire       [0:0]    cmdStreamWithSize_payload_lock;
  wire       [3:0]    cmdStreamWithSize_payload_cache;
  wire       [3:0]    cmdStreamWithSize_payload_qos;
  wire       [2:0]    cmdStreamWithSize_payload_prot;
  wire                io_input_fire;
  reg        [2:0]    size;
  wire                cmdExtendedStream_valid;
  wire                cmdExtendedStream_ready;
  wire       [31:0]   cmdExtendedStream_payload_addr;
  wire       [3:0]    cmdExtendedStream_payload_region;
  wire       [7:0]    cmdExtendedStream_payload_len;
  wire       [2:0]    cmdExtendedStream_payload_size;
  wire       [0:0]    cmdExtendedStream_payload_lock;
  wire       [3:0]    cmdExtendedStream_payload_cache;
  wire       [3:0]    cmdExtendedStream_payload_qos;
  wire       [2:0]    cmdExtendedStream_payload_prot;
  reg        [31:0]   address;
  wire                cmdStreamWithSize_fire;
  wire                cmdExtendedStream_fire;
  wire                cmdStream_valid;
  wire                cmdStream_ready;
  wire       [31:0]   cmdStream_payload_addr;
  wire       [3:0]    cmdStream_payload_region;
  wire       [7:0]    cmdStream_payload_len;
  wire       [2:0]    cmdStream_payload_size;
  wire       [0:0]    cmdStream_payload_lock;
  wire       [3:0]    cmdStream_payload_cache;
  wire       [3:0]    cmdStream_payload_qos;
  wire       [2:0]    cmdStream_payload_prot;
  reg        [6:0]    dataRatio;

  assign _zz_startAddress = (io_input_payload_addr >>> io_input_payload_size);
  assign _zz_ratio = (7'h01 <<< sizeDiff);
  assign _zz_address_1 = ({7'd0,_zz_address_2} <<< size);
  assign _zz_address = {16'd0, _zz_address_1};
  assign _zz_address_2 = ({1'b0,cmdExtendedStream_payload_len} + _zz_address_3);
  assign _zz_address_4 = {1'b0,1'b1};
  assign _zz_address_3 = {7'd0, _zz_address_4};
  axi2apb3_StreamTransactionExtender_4 cmdExtender (
    .io_count                 (ratio[6:0]                               ), //i
    .io_input_valid           (cmdStreamWithSize_valid                  ), //i
    .io_input_ready           (cmdExtender_io_input_ready               ), //o
    .io_input_payload_addr    (cmdStreamWithSize_payload_addr[31:0]     ), //i
    .io_input_payload_region  (cmdStreamWithSize_payload_region[3:0]    ), //i
    .io_input_payload_len     (cmdStreamWithSize_payload_len[7:0]       ), //i
    .io_input_payload_size    (cmdStreamWithSize_payload_size[2:0]      ), //i
    .io_input_payload_lock    (cmdStreamWithSize_payload_lock           ), //i
    .io_input_payload_cache   (cmdStreamWithSize_payload_cache[3:0]     ), //i
    .io_input_payload_qos     (cmdStreamWithSize_payload_qos[3:0]       ), //i
    .io_input_payload_prot    (cmdStreamWithSize_payload_prot[2:0]      ), //i
    .io_output_valid          (cmdExtender_io_output_valid              ), //o
    .io_output_ready          (cmdExtendedStream_ready                  ), //i
    .io_output_payload_addr   (cmdExtender_io_output_payload_addr[31:0] ), //o
    .io_output_payload_region (cmdExtender_io_output_payload_region[3:0]), //o
    .io_output_payload_len    (cmdExtender_io_output_payload_len[7:0]   ), //o
    .io_output_payload_size   (cmdExtender_io_output_payload_size[2:0]  ), //o
    .io_output_payload_lock   (cmdExtender_io_output_payload_lock       ), //o
    .io_output_payload_cache  (cmdExtender_io_output_payload_cache[3:0] ), //o
    .io_output_payload_qos    (cmdExtender_io_output_payload_qos[3:0]   ), //o
    .io_output_payload_prot   (cmdExtender_io_output_payload_prot[2:0]  ), //o
    .io_working               (cmdExtender_io_working                   ), //o
    .io_first                 (cmdExtender_io_first                     ), //o
    .io_last                  (cmdExtender_io_last                      ), //o
    .io_done                  (cmdExtender_io_done                      ), //o
    .clk                      (clk                                      ), //i
    .reset                    (reset                                    )  //i
  );
  assign sizeDiff = (io_input_payload_size - 3'b010);
  assign when_Axi4Downsizer_l48 = (3'b010 < io_input_payload_size);
  always @(*) begin
    if(when_Axi4Downsizer_l48) begin
      startAddress = (_zz_startAddress <<< io_input_payload_size);
    end else begin
      startAddress = io_input_payload_addr;
    end
  end

  always @(*) begin
    if(when_Axi4Downsizer_l48) begin
      ratio = (_zz_ratio - 7'h01);
    end else begin
      ratio = 7'h0;
    end
  end

  always @(*) begin
    if(when_Axi4Downsizer_l48) begin
      sizePerTrans = 3'b010;
    end else begin
      sizePerTrans = io_input_payload_size;
    end
  end

  assign cmdStreamWithSize_valid = io_input_valid;
  assign io_input_ready = cmdStreamWithSize_ready;
  assign cmdStreamWithSize_payload_addr = startAddress;
  assign cmdStreamWithSize_payload_size = sizePerTrans;
  assign cmdStreamWithSize_payload_region = io_input_payload_region;
  assign cmdStreamWithSize_payload_len = io_input_payload_len;
  assign cmdStreamWithSize_payload_lock = io_input_payload_lock;
  assign cmdStreamWithSize_payload_cache = io_input_payload_cache;
  assign cmdStreamWithSize_payload_qos = io_input_payload_qos;
  assign cmdStreamWithSize_payload_prot = io_input_payload_prot;
  assign io_input_fire = (io_input_valid && io_input_ready);
  assign cmdStreamWithSize_ready = cmdExtender_io_input_ready;
  assign cmdExtendedStream_valid = cmdExtender_io_output_valid;
  assign cmdExtendedStream_payload_addr = cmdExtender_io_output_payload_addr;
  assign cmdExtendedStream_payload_region = cmdExtender_io_output_payload_region;
  assign cmdExtendedStream_payload_len = cmdExtender_io_output_payload_len;
  assign cmdExtendedStream_payload_size = cmdExtender_io_output_payload_size;
  assign cmdExtendedStream_payload_lock = cmdExtender_io_output_payload_lock;
  assign cmdExtendedStream_payload_cache = cmdExtender_io_output_payload_cache;
  assign cmdExtendedStream_payload_qos = cmdExtender_io_output_payload_qos;
  assign cmdExtendedStream_payload_prot = cmdExtender_io_output_payload_prot;
  assign cmdStreamWithSize_fire = (cmdStreamWithSize_valid && cmdStreamWithSize_ready);
  assign cmdExtendedStream_fire = (cmdExtendedStream_valid && cmdExtendedStream_ready);
  assign cmdStream_valid = cmdExtendedStream_valid;
  assign cmdExtendedStream_ready = cmdStream_ready;
  assign cmdStream_payload_addr = address;
  assign cmdStream_payload_region = cmdExtendedStream_payload_region;
  assign cmdStream_payload_len = cmdExtendedStream_payload_len;
  assign cmdStream_payload_size = cmdExtendedStream_payload_size;
  assign cmdStream_payload_lock = cmdExtendedStream_payload_lock;
  assign cmdStream_payload_cache = cmdExtendedStream_payload_cache;
  assign cmdStream_payload_qos = cmdExtendedStream_payload_qos;
  assign cmdStream_payload_prot = cmdExtendedStream_payload_prot;
  always @(*) begin
    if(io_input_fire) begin
      io_ratio = ratio;
    end else begin
      io_ratio = dataRatio;
    end
  end

  always @(*) begin
    if(io_input_fire) begin
      io_size = sizePerTrans;
    end else begin
      io_size = size;
    end
  end

  assign io_working = cmdExtender_io_working;
  assign io_last = cmdExtender_io_last;
  assign io_done = cmdExtender_io_done;
  assign io_start = startAddress;
  assign io_output_valid = cmdStream_valid;
  assign cmdStream_ready = io_output_ready;
  assign io_output_payload_addr = cmdStream_payload_addr;
  assign io_output_payload_region = cmdStream_payload_region;
  assign io_output_payload_len = cmdStream_payload_len;
  assign io_output_payload_size = cmdStream_payload_size;
  assign io_output_payload_lock = cmdStream_payload_lock;
  assign io_output_payload_cache = cmdStream_payload_cache;
  assign io_output_payload_qos = cmdStream_payload_qos;
  assign io_output_payload_prot = cmdStream_payload_prot;
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      size <= 3'b010;
      address <= 32'h0;
      dataRatio <= 7'h0;
    end else begin
      if(io_input_fire) begin
        size <= sizePerTrans;
      end
      if(cmdStreamWithSize_fire) begin
        address <= cmdStreamWithSize_payload_addr;
      end else begin
        if(cmdExtendedStream_fire) begin
          address <= (address + _zz_address);
        end
      end
      if(io_input_fire) begin
        dataRatio <= ratio;
      end
    end
  end


endmodule

//axi2apb3_StreamTransactionCounter_2 replaced by axi2apb3_StreamTransactionCounter_6

//axi2apb3_StreamTransactionExtender_3 replaced by axi2apb3_StreamTransactionExtender_4

//axi2apb3_StreamTransactionCounter_3 replaced by axi2apb3_StreamTransactionCounter_6

module axi2apb3_StreamTransactionCounter_4 (
  input  wire          io_ctrlFire,
  input  wire          io_targetFire,
  output wire          io_available,
  input  wire [7:0]    io_count,
  output wire          io_working,
  output wire          io_last,
  output wire          io_done,
  output wire [7:0]    io_value,
  input  wire          clk,
  input  wire          reset
);

  wire       [7:0]    _zz_counter_valueNext;
  wire       [0:0]    _zz_counter_valueNext_1;
  reg        [7:0]    countReg;
  reg                 counter_willIncrement;
  reg                 counter_willClear;
  reg        [7:0]    counter_valueNext;
  reg        [7:0]    counter_value;
  wire                counter_willOverflowIfInc;
  wire                counter_willOverflow;
  wire       [7:0]    expected;
  wire                lastOne;
  reg                 running;
  wire                working;
  wire                done;
  wire                when_Stream_l2200;

  assign _zz_counter_valueNext_1 = counter_willIncrement;
  assign _zz_counter_valueNext = {7'd0, _zz_counter_valueNext_1};
  always @(*) begin
    counter_willIncrement = 1'b0;
    if(!done) begin
      if(when_Stream_l2200) begin
        counter_willIncrement = 1'b1;
      end
    end
  end

  always @(*) begin
    counter_willClear = 1'b0;
    if(done) begin
      counter_willClear = 1'b1;
    end
  end

  assign counter_willOverflowIfInc = (counter_value == 8'hff);
  assign counter_willOverflow = (counter_willOverflowIfInc && counter_willIncrement);
  always @(*) begin
    counter_valueNext = (counter_value + _zz_counter_valueNext);
    if(counter_willClear) begin
      counter_valueNext = 8'h0;
    end
  end

  assign expected = countReg;
  assign lastOne = (expected <= counter_value);
  assign working = running;
  assign done = (lastOne && io_targetFire);
  assign when_Stream_l2200 = (io_targetFire && working);
  assign io_working = working;
  assign io_last = (lastOne && working);
  assign io_done = (done && working);
  assign io_value = counter_value;
  assign io_available = ((! working) || io_done);
  always @(posedge clk) begin
    if(io_ctrlFire) begin
      countReg <= io_count;
    end
  end

  always @(posedge clk or posedge reset) begin
    if(reset) begin
      counter_value <= 8'h0;
      running <= 1'b0;
    end else begin
      counter_value <= counter_valueNext;
      if(io_ctrlFire) begin
        running <= 1'b1;
      end else begin
        if(done) begin
          running <= 1'b0;
        end
      end
    end
  end


endmodule

module axi2apb3_StreamTransactionExtender_4 (
  input  wire [6:0]    io_count,
  input  wire          io_input_valid,
  output wire          io_input_ready,
  input  wire [31:0]   io_input_payload_addr,
  input  wire [3:0]    io_input_payload_region,
  input  wire [7:0]    io_input_payload_len,
  input  wire [2:0]    io_input_payload_size,
  input  wire [0:0]    io_input_payload_lock,
  input  wire [3:0]    io_input_payload_cache,
  input  wire [3:0]    io_input_payload_qos,
  input  wire [2:0]    io_input_payload_prot,
  output wire          io_output_valid,
  input  wire          io_output_ready,
  output wire [31:0]   io_output_payload_addr,
  output wire [3:0]    io_output_payload_region,
  output wire [7:0]    io_output_payload_len,
  output wire [2:0]    io_output_payload_size,
  output wire [0:0]    io_output_payload_lock,
  output wire [3:0]    io_output_payload_cache,
  output wire [3:0]    io_output_payload_qos,
  output wire [2:0]    io_output_payload_prot,
  output wire          io_working,
  output wire          io_first,
  output wire          io_last,
  output wire          io_done,
  input  wire          clk,
  input  wire          reset
);

  wire                counter_io_available;
  wire                counter_io_working;
  wire                counter_io_last;
  wire                counter_io_done;
  wire       [6:0]    counter_io_value;
  wire                io_input_fire;
  wire                io_output_fire;
  reg        [31:0]   payloadReg_addr;
  reg        [3:0]    payloadReg_region;
  reg        [7:0]    payloadReg_len;
  reg        [2:0]    payloadReg_size;
  reg        [0:0]    payloadReg_lock;
  reg        [3:0]    payloadReg_cache;
  reg        [3:0]    payloadReg_qos;
  reg        [2:0]    payloadReg_prot;
  wire       [31:0]   payload_addr;
  wire       [3:0]    payload_region;
  wire       [7:0]    payload_len;
  wire       [2:0]    payload_size;
  wire       [0:0]    payload_lock;
  wire       [3:0]    payload_cache;
  wire       [3:0]    payload_qos;
  wire       [2:0]    payload_prot;

  axi2apb3_StreamTransactionCounter_6 counter (
    .io_ctrlFire   (io_input_fire        ), //i
    .io_targetFire (io_output_fire       ), //i
    .io_available  (counter_io_available ), //o
    .io_count      (io_count[6:0]        ), //i
    .io_working    (counter_io_working   ), //o
    .io_last       (counter_io_last      ), //o
    .io_done       (counter_io_done      ), //o
    .io_value      (counter_io_value[6:0]), //o
    .clk           (clk                  ), //i
    .reset         (reset                )  //i
  );
  assign io_input_fire = (io_input_valid && io_input_ready);
  assign io_output_fire = (io_output_valid && io_output_ready);
  assign payload_addr = payloadReg_addr;
  assign payload_region = payloadReg_region;
  assign payload_len = payloadReg_len;
  assign payload_size = payloadReg_size;
  assign payload_lock = payloadReg_lock;
  assign payload_cache = payloadReg_cache;
  assign payload_qos = payloadReg_qos;
  assign payload_prot = payloadReg_prot;
  assign io_output_payload_addr = payload_addr;
  assign io_output_payload_region = payload_region;
  assign io_output_payload_len = payload_len;
  assign io_output_payload_size = payload_size;
  assign io_output_payload_lock = payload_lock;
  assign io_output_payload_cache = payload_cache;
  assign io_output_payload_qos = payload_qos;
  assign io_output_payload_prot = payload_prot;
  assign io_output_valid = counter_io_working;
  assign io_input_ready = counter_io_available;
  assign io_last = counter_io_last;
  assign io_done = counter_io_done;
  assign io_first = ((counter_io_value == 7'h0) && counter_io_working);
  assign io_working = counter_io_working;
  always @(posedge clk) begin
    if(io_input_fire) begin
      payloadReg_addr <= io_input_payload_addr;
      payloadReg_region <= io_input_payload_region;
      payloadReg_len <= io_input_payload_len;
      payloadReg_size <= io_input_payload_size;
      payloadReg_lock <= io_input_payload_lock;
      payloadReg_cache <= io_input_payload_cache;
      payloadReg_qos <= io_input_payload_qos;
      payloadReg_prot <= io_input_payload_prot;
    end
  end


endmodule

//axi2apb3_StreamTransactionCounter_5 replaced by axi2apb3_StreamTransactionCounter_6

module axi2apb3_StreamTransactionCounter_6 (
  input  wire          io_ctrlFire,
  input  wire          io_targetFire,
  output wire          io_available,
  input  wire [6:0]    io_count,
  output wire          io_working,
  output wire          io_last,
  output wire          io_done,
  output wire [6:0]    io_value,
  input  wire          clk,
  input  wire          reset
);

  wire       [6:0]    _zz_counter_valueNext;
  wire       [0:0]    _zz_counter_valueNext_1;
  reg        [6:0]    countReg;
  reg                 counter_willIncrement;
  reg                 counter_willClear;
  reg        [6:0]    counter_valueNext;
  reg        [6:0]    counter_value;
  wire                counter_willOverflowIfInc;
  wire                counter_willOverflow;
  wire       [6:0]    expected;
  wire                lastOne;
  reg                 running;
  wire                working;
  wire                done;
  wire                when_Stream_l2200;

  assign _zz_counter_valueNext_1 = counter_willIncrement;
  assign _zz_counter_valueNext = {6'd0, _zz_counter_valueNext_1};
  always @(*) begin
    counter_willIncrement = 1'b0;
    if(!done) begin
      if(when_Stream_l2200) begin
        counter_willIncrement = 1'b1;
      end
    end
  end

  always @(*) begin
    counter_willClear = 1'b0;
    if(done) begin
      counter_willClear = 1'b1;
    end
  end

  assign counter_willOverflowIfInc = (counter_value == 7'h7f);
  assign counter_willOverflow = (counter_willOverflowIfInc && counter_willIncrement);
  always @(*) begin
    counter_valueNext = (counter_value + _zz_counter_valueNext);
    if(counter_willClear) begin
      counter_valueNext = 7'h0;
    end
  end

  assign expected = countReg;
  assign lastOne = (expected <= counter_value);
  assign working = running;
  assign done = (lastOne && io_targetFire);
  assign when_Stream_l2200 = (io_targetFire && working);
  assign io_working = working;
  assign io_last = (lastOne && working);
  assign io_done = (done && working);
  assign io_value = counter_value;
  assign io_available = ((! working) || io_done);
  always @(posedge clk) begin
    if(io_ctrlFire) begin
      countReg <= io_count;
    end
  end

  always @(posedge clk or posedge reset) begin
    if(reset) begin
      counter_value <= 7'h0;
      running <= 1'b0;
    end else begin
      counter_value <= counter_valueNext;
      if(io_ctrlFire) begin
        running <= 1'b1;
      end else begin
        if(done) begin
          running <= 1'b0;
        end
      end
    end
  end


endmodule
