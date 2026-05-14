// Generator : SpinalHDL dev    git head : e62c0f1238cb838fea491b9c1b7b59562aabd79f
// Component : axil2apb3

`timescale 1ns/1ps

module axil2apb3 (
  input  wire          s_axil_awvalid,
  output wire          s_axil_awready,
  input  wire [31:0]   s_axil_awaddr,
  input  wire [2:0]    s_axil_awprot,
  input  wire          s_axil_wvalid,
  output wire          s_axil_wready,
  input  wire [31:0]   s_axil_wdata,
  input  wire [3:0]    s_axil_wstrb,
  output wire          s_axil_bvalid,
  input  wire          s_axil_bready,
  output wire [1:0]    s_axil_bresp,
  input  wire          s_axil_arvalid,
  output wire          s_axil_arready,
  input  wire [31:0]   s_axil_araddr,
  input  wire [2:0]    s_axil_arprot,
  output wire          s_axil_rvalid,
  input  wire          s_axil_rready,
  output wire [31:0]   s_axil_rdata,
  output wire [1:0]    s_axil_rresp,
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

  wire                a4_io_axi_arw_payload_write;
  wire                a4_io_axi_arw_ready;
  wire                a4_io_axi_w_ready;
  wire                a4_io_axi_b_valid;
  wire       [0:0]    a4_io_axi_b_payload_id;
  wire       [1:0]    a4_io_axi_b_payload_resp;
  wire                a4_io_axi_r_valid;
  wire       [31:0]   a4_io_axi_r_payload_data;
  wire       [0:0]    a4_io_axi_r_payload_id;
  wire       [1:0]    a4_io_axi_r_payload_resp;
  wire                a4_io_axi_r_payload_last;
  wire       [31:0]   a4_io_apb_PADDR;
  wire       [0:0]    a4_io_apb_PSEL;
  wire                a4_io_apb_PENABLE;
  wire                a4_io_apb_PWRITE;
  wire       [31:0]   a4_io_apb_PWDATA;
  wire                streamArbiter_io_inputs_0_ready;
  wire                streamArbiter_io_inputs_1_ready;
  wire                streamArbiter_io_output_valid;
  wire       [31:0]   streamArbiter_io_output_payload_addr;
  wire       [2:0]    streamArbiter_io_output_payload_prot;
  wire       [0:0]    streamArbiter_io_chosen;
  wire       [1:0]    streamArbiter_io_chosenOH;
  wire       [0:0]    _zz_io_axi_arw_payload_id;
  wire       [7:0]    _zz_io_axi_arw_payload_len;

  axil2apb3_Axi4SharedToApb3Bridge a4 (
    .io_axi_arw_valid         (streamArbiter_io_output_valid             ), //i
    .io_axi_arw_ready         (a4_io_axi_arw_ready                       ), //o
    .io_axi_arw_payload_addr  (streamArbiter_io_output_payload_addr[31:0]), //i
    .io_axi_arw_payload_id    (_zz_io_axi_arw_payload_id                 ), //i
    .io_axi_arw_payload_len   (_zz_io_axi_arw_payload_len[7:0]           ), //i
    .io_axi_arw_payload_size  (3'b010                                    ), //i
    .io_axi_arw_payload_burst (2'b01                                     ), //i
    .io_axi_arw_payload_write (a4_io_axi_arw_payload_write               ), //i
    .io_axi_w_valid           (s_axil_wvalid                             ), //i
    .io_axi_w_ready           (a4_io_axi_w_ready                         ), //o
    .io_axi_w_payload_data    (s_axil_wdata[31:0]                        ), //i
    .io_axi_w_payload_strb    (s_axil_wstrb[3:0]                         ), //i
    .io_axi_w_payload_last    (1'b1                                      ), //i
    .io_axi_b_valid           (a4_io_axi_b_valid                         ), //o
    .io_axi_b_ready           (s_axil_bready                             ), //i
    .io_axi_b_payload_id      (a4_io_axi_b_payload_id                    ), //o
    .io_axi_b_payload_resp    (a4_io_axi_b_payload_resp[1:0]             ), //o
    .io_axi_r_valid           (a4_io_axi_r_valid                         ), //o
    .io_axi_r_ready           (s_axil_rready                             ), //i
    .io_axi_r_payload_data    (a4_io_axi_r_payload_data[31:0]            ), //o
    .io_axi_r_payload_id      (a4_io_axi_r_payload_id                    ), //o
    .io_axi_r_payload_resp    (a4_io_axi_r_payload_resp[1:0]             ), //o
    .io_axi_r_payload_last    (a4_io_axi_r_payload_last                  ), //o
    .io_apb_PADDR             (a4_io_apb_PADDR[31:0]                     ), //o
    .io_apb_PSEL              (a4_io_apb_PSEL                            ), //o
    .io_apb_PENABLE           (a4_io_apb_PENABLE                         ), //o
    .io_apb_PREADY            (m_apb3_PREADY                             ), //i
    .io_apb_PWRITE            (a4_io_apb_PWRITE                          ), //o
    .io_apb_PWDATA            (a4_io_apb_PWDATA[31:0]                    ), //o
    .io_apb_PRDATA            (m_apb3_PRDATA[31:0]                       ), //i
    .io_apb_PSLVERROR         (m_apb3_PSLVERROR                          ), //i
    .clk                      (clk                                       ), //i
    .reset                    (reset                                     )  //i
  );
  axil2apb3_StreamArbiter streamArbiter (
    .io_inputs_0_valid        (s_axil_arvalid                            ), //i
    .io_inputs_0_ready        (streamArbiter_io_inputs_0_ready           ), //o
    .io_inputs_0_payload_addr (s_axil_araddr[31:0]                       ), //i
    .io_inputs_0_payload_prot (s_axil_arprot[2:0]                        ), //i
    .io_inputs_1_valid        (s_axil_awvalid                            ), //i
    .io_inputs_1_ready        (streamArbiter_io_inputs_1_ready           ), //o
    .io_inputs_1_payload_addr (s_axil_awaddr[31:0]                       ), //i
    .io_inputs_1_payload_prot (s_axil_awprot[2:0]                        ), //i
    .io_output_valid          (streamArbiter_io_output_valid             ), //o
    .io_output_ready          (a4_io_axi_arw_ready                       ), //i
    .io_output_payload_addr   (streamArbiter_io_output_payload_addr[31:0]), //o
    .io_output_payload_prot   (streamArbiter_io_output_payload_prot[2:0] ), //o
    .io_chosen                (streamArbiter_io_chosen                   ), //o
    .io_chosenOH              (streamArbiter_io_chosenOH[1:0]            ), //o
    .clk                      (clk                                       ), //i
    .reset                    (reset                                     )  //i
  );
  assign s_axil_awready = streamArbiter_io_inputs_1_ready;
  assign s_axil_wready = a4_io_axi_w_ready;
  assign s_axil_bvalid = a4_io_axi_b_valid;
  assign s_axil_bresp = a4_io_axi_b_payload_resp;
  assign s_axil_arready = streamArbiter_io_inputs_0_ready;
  assign s_axil_rvalid = a4_io_axi_r_valid;
  assign s_axil_rdata = a4_io_axi_r_payload_data;
  assign s_axil_rresp = a4_io_axi_r_payload_resp;
  assign _zz_io_axi_arw_payload_id[0 : 0] = 1'b0;
  assign _zz_io_axi_arw_payload_len[7 : 0] = 8'h0;
  assign a4_io_axi_arw_payload_write = streamArbiter_io_chosenOH[1];
  assign m_apb3_PADDR = a4_io_apb_PADDR;
  assign m_apb3_PSEL = a4_io_apb_PSEL;
  assign m_apb3_PENABLE = a4_io_apb_PENABLE;
  assign m_apb3_PWRITE = a4_io_apb_PWRITE;
  assign m_apb3_PWDATA = a4_io_apb_PWDATA;

endmodule

module axil2apb3_StreamArbiter (
  input  wire          io_inputs_0_valid,
  output wire          io_inputs_0_ready,
  input  wire [31:0]   io_inputs_0_payload_addr,
  input  wire [2:0]    io_inputs_0_payload_prot,
  input  wire          io_inputs_1_valid,
  output wire          io_inputs_1_ready,
  input  wire [31:0]   io_inputs_1_payload_addr,
  input  wire [2:0]    io_inputs_1_payload_prot,
  output wire          io_output_valid,
  input  wire          io_output_ready,
  output wire [31:0]   io_output_payload_addr,
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

module axil2apb3_Axi4SharedToApb3Bridge (
  input  wire          io_axi_arw_valid,
  output reg           io_axi_arw_ready,
  input  wire [31:0]   io_axi_arw_payload_addr,
  input  wire [0:0]    io_axi_arw_payload_id,
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
  output wire [0:0]    io_axi_b_payload_id,
  output wire [1:0]    io_axi_b_payload_resp,
  output reg           io_axi_r_valid,
  input  wire          io_axi_r_ready,
  output wire [31:0]   io_axi_r_payload_data,
  output wire [0:0]    io_axi_r_payload_id,
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
  reg        [0:0]    id;
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
  assign io_axi_r_payload_id = id;
  assign io_axi_b_payload_id = id;
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
        id <= io_axi_arw_payload_id;
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
