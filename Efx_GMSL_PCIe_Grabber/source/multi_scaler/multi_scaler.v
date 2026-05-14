///////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024 github-efx
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
///////////////////////////////////////////////////////////////////////////////////

module multi_scaler #(
    parameter STREAM_WIDTH       = 32  ,
    parameter SCALE_FACTOR       = 5   ,
    parameter INPUT_IMAGE_WIDTH  = 1920,
    parameter INPUT_IMAGE_HEIGHT = 1080
) (
    input                       ACLK,
    input                       ACLK_2x,
    input                       ARESETn,
    input                       s_axis_in_TVALID,
    output                      s_axis_in_TREADY,
    input  [  STREAM_WIDTH-1:0] s_axis_in_TDATA,
    input  [STREAM_WIDTH/8-1:0] s_axis_in_TKEEP,
    input                       s_axis_in_TLAST,
    input  [               3:0] s_axis_in_TDEST,

    output                      m_axis_r_TVALID,
    input                       m_axis_r_TREADY,
    output [  STREAM_WIDTH-1:0] m_axis_r_TDATA,
    output [STREAM_WIDTH/8-1:0] m_axis_r_TKEEP,
    output                      m_axis_r_TLAST,
    output [               3:0] m_axis_r_TDEST,
    output                      m_axis_g_TVALID,
    input                       m_axis_g_TREADY,
    output [  STREAM_WIDTH-1:0] m_axis_g_TDATA,
    output [STREAM_WIDTH/8-1:0] m_axis_g_TKEEP,
    output                      m_axis_g_TLAST,
    output [               3:0] m_axis_g_TDEST,
    output                      m_axis_b_TVALID,
    input                       m_axis_b_TREADY,
    output [  STREAM_WIDTH-1:0] m_axis_b_TDATA,
    output [STREAM_WIDTH/8-1:0] m_axis_b_TKEEP,
    output                      m_axis_b_TLAST,
    output [               3:0] m_axis_b_TDEST
);

  wire                      m_axis_downscale_TVALID;
  wire                      m_axis_downscale_TREADY;
  wire [  STREAM_WIDTH-1:0] m_axis_downscale_TDATA;
  wire [STREAM_WIDTH/8-1:0] m_axis_downscale_TKEEP;
  wire                      m_axis_downscale_TLAST;
  wire [               3:0] m_axis_downscale_TDEST;

  wire                      s_axis_p2p_TVALID;
  wire                      s_axis_p2p_TREADY;
  wire [  STREAM_WIDTH-1:0] s_axis_p2p_TDATA;
  wire [STREAM_WIDTH/8-1:0] s_axis_p2p_TKEEP;
  wire                      s_axis_p2p_TLAST;
  wire [               3:0] s_axis_p2p_TDEST;

  wire                      m_axis_p2p_r_TVALID;
  wire                      m_axis_p2p_r_TREADY;
  wire [  STREAM_WIDTH-1:0] m_axis_p2p_r_TDATA;
  wire [STREAM_WIDTH/8-1:0] m_axis_p2p_r_TKEEP;
  wire                      m_axis_p2p_r_TLAST;
  wire [               3:0] m_axis_p2p_r_TDEST;
  wire                      m_axis_p2p_g_TVALID;
  wire                      m_axis_p2p_g_TREADY;
  wire [  STREAM_WIDTH-1:0] m_axis_p2p_g_TDATA;
  wire [STREAM_WIDTH/8-1:0] m_axis_p2p_g_TKEEP;
  wire                      m_axis_p2p_g_TLAST;
  wire [               3:0] m_axis_p2p_g_TDEST;
  wire                      m_axis_p2p_b_TVALID;
  wire                      m_axis_p2p_b_TREADY;
  wire [  STREAM_WIDTH-1:0] m_axis_p2p_b_TDATA;
  wire [STREAM_WIDTH/8-1:0] m_axis_p2p_b_TKEEP;
  wire                      m_axis_p2p_b_TLAST;
  wire [               3:0] m_axis_p2p_b_TDEST;

  localparam    SCALE_FACTOR_MINUS1        = SCALE_FACTOR - 1      ;
  localparam    FACTOR_WIDTH               = $clog2(SCALE_FACTOR)  ;
  localparam    INPUT_IMAGE_WIDTH_MINUS1   = INPUT_IMAGE_WIDTH - 1 ;
  localparam    INPUT_IMAGE_HEIGHT_MINUS1  = INPUT_IMAGE_HEIGHT - 1;
  localparam    INPUT_IMAGE_WIDTH_SCALED   = INPUT_IMAGE_WIDTH/SCALE_FACTOR;
  localparam    INPUT_IMAGE_HEIGHT_SCALED  = INPUT_IMAGE_HEIGHT/SCALE_FACTOR;
  localparam    OUTPUT_IMAGE_WIDTH_MINUS1  = INPUT_IMAGE_WIDTH_SCALED - 1;
  localparam    OUTPUT_IMAGE_HEIGHT_MINUS1 = INPUT_IMAGE_HEIGHT_SCALED - 1;
  localparam    OUTPUT_WIDTH_DIV4_MINUS1   = (INPUT_IMAGE_WIDTH_SCALED)/4 - 1;
  localparam    LBOX_H                     = ((INPUT_IMAGE_WIDTH_SCALED) - (INPUT_IMAGE_HEIGHT_SCALED))/2 -1;
  
  // 1920x1080 to 384x216, integer factor 5, raster order 
  integer_downscale #(
      .STREAM_WIDTH       (STREAM_WIDTH),
      .COUNTER_WIDTH      (11),
      .MAX_W              (INPUT_IMAGE_WIDTH_MINUS1),
      .MAX_H              (INPUT_IMAGE_HEIGHT_MINUS1),
      .FACTOR_WIDTH       (FACTOR_WIDTH),
      .SCALE_FACTOR_MINUS1(SCALE_FACTOR_MINUS1)
  ) integer_downscale_inst (
      .ACLK             (ACLK_2x),
      .ARESETn          (ARESETn),
      .s_axis_in_TVALID (s_axis_in_TVALID),
      .s_axis_in_TREADY (s_axis_in_TREADY),
      .s_axis_in_TDATA  (s_axis_in_TDATA),
      .s_axis_in_TKEEP  (s_axis_in_TKEEP),
      .s_axis_in_TLAST  (s_axis_in_TLAST),
      .s_axis_in_TDEST  (s_axis_in_TDEST),
      .m_axis_out_TVALID(m_axis_downscale_TVALID),
      .m_axis_out_TREADY(m_axis_downscale_TREADY),
      .m_axis_out_TDATA (m_axis_downscale_TDATA),
      .m_axis_out_TKEEP (m_axis_downscale_TKEEP),
      .m_axis_out_TLAST (m_axis_downscale_TLAST),
      .m_axis_out_TDEST (m_axis_downscale_TDEST)
  );

  wire fifo_full;
  wire fifo_empty;
  assign m_axis_downscale_TREADY = ~fifo_full;
  assign s_axis_p2p_TVALID       = ~fifo_empty;

  axis_fifo_w41 axis_fifo_inst (
      .a_rst_i (~ARESETn),
      .wr_clk_i(ACLK_2x),
      .wdata   ({m_axis_downscale_TDATA, m_axis_downscale_TKEEP, m_axis_downscale_TLAST, m_axis_downscale_TDEST}),
      .wr_en_i (m_axis_downscale_TVALID),
      .full_o  (fifo_full),
      .rd_clk_i(ACLK),
      .rdata   ({s_axis_p2p_TDATA, s_axis_p2p_TKEEP, s_axis_p2p_TLAST, s_axis_p2p_TDEST}),
      .rd_en_i (s_axis_p2p_TREADY),
      .empty_o (fifo_empty)
  );

  packed_to_planar #(
      .STREAM_WIDTH     (STREAM_WIDTH),
      .COUNTER_WIDTH    (10),
      .MAX_W_DIV4_MINUS1(OUTPUT_WIDTH_DIV4_MINUS1  ),
      .MAX_H            (OUTPUT_IMAGE_HEIGHT_MINUS1)
  ) packed2planar_inst (
      .ACLK            (ACLK),
      .ARESETn         (ARESETn),
      .s_axis_in_TVALID(s_axis_p2p_TVALID  /*  m_axis_downscale_TVALID */),
      .s_axis_in_TREADY(s_axis_p2p_TREADY  /*  m_axis_downscale_TREADY */),
      .s_axis_in_TDATA (s_axis_p2p_TDATA   /*  m_axis_downscale_TDATA  */),
      .s_axis_in_TKEEP (s_axis_p2p_TKEEP   /*  m_axis_downscale_TKEEP  */),
      .s_axis_in_TLAST (s_axis_p2p_TLAST   /*  m_axis_downscale_TLAST  */),
      .s_axis_in_TDEST (s_axis_p2p_TDEST   /*  m_axis_downscale_TDEST  */),
      .m_axis_r_TVALID (m_axis_p2p_r_TVALID),
      .m_axis_r_TREADY (m_axis_p2p_r_TREADY),
      .m_axis_r_TDATA  (m_axis_p2p_r_TDATA),
      .m_axis_r_TKEEP  (m_axis_p2p_r_TKEEP),
      .m_axis_r_TLAST  (m_axis_p2p_r_TLAST),
      .m_axis_r_TDEST  (m_axis_p2p_r_TDEST),
      .m_axis_g_TVALID (m_axis_p2p_g_TVALID),
      .m_axis_g_TREADY (m_axis_p2p_g_TREADY),
      .m_axis_g_TDATA  (m_axis_p2p_g_TDATA),
      .m_axis_g_TKEEP  (m_axis_p2p_g_TKEEP),
      .m_axis_g_TLAST  (m_axis_p2p_g_TLAST),
      .m_axis_g_TDEST  (m_axis_p2p_g_TDEST),
      .m_axis_b_TVALID (m_axis_p2p_b_TVALID),
      .m_axis_b_TREADY (m_axis_p2p_b_TREADY),
      .m_axis_b_TDATA  (m_axis_p2p_b_TDATA),
      .m_axis_b_TKEEP  (m_axis_p2p_b_TKEEP),
      .m_axis_b_TLAST  (m_axis_p2p_b_TLAST),
      .m_axis_b_TDEST  (m_axis_p2p_b_TDEST)
  );

  // 384x216 to 384x384 letterbox, raster order
  letterbox #(
      .STREAM_WIDTH     (STREAM_WIDTH),
      .COUNTER_WIDTH    (10),
      .MAX_W_DIV4_MINUS1(OUTPUT_WIDTH_DIV4_MINUS1  ),
      .IMG_H            (OUTPUT_IMAGE_HEIGHT_MINUS1),
      .LBOX_H           (LBOX_H)
  ) letterbox_r_inst (
      .ACLK             (ACLK),
      .ARESETn          (ARESETn),
      .s_axis_in_TVALID (m_axis_p2p_r_TVALID),
      .s_axis_in_TREADY (m_axis_p2p_r_TREADY),
      .s_axis_in_TDATA  (m_axis_p2p_r_TDATA),
      .s_axis_in_TKEEP  (m_axis_p2p_r_TKEEP),
      .s_axis_in_TLAST  (m_axis_p2p_r_TLAST),
      .s_axis_in_TDEST  (m_axis_p2p_r_TDEST),
      .m_axis_out_TVALID(m_axis_r_TVALID),
      .m_axis_out_TREADY(m_axis_r_TREADY),
      .m_axis_out_TDATA (m_axis_r_TDATA),
      .m_axis_out_TKEEP (m_axis_r_TKEEP),
      .m_axis_out_TLAST (m_axis_r_TLAST),
      .m_axis_out_TDEST (m_axis_r_TDEST)
  );

  letterbox #(
      .STREAM_WIDTH     (STREAM_WIDTH),
      .COUNTER_WIDTH    (10),
      .MAX_W_DIV4_MINUS1(OUTPUT_WIDTH_DIV4_MINUS1  ),
      .IMG_H            (OUTPUT_IMAGE_HEIGHT_MINUS1),
      .LBOX_H           (LBOX_H)
  ) letterbox_g_inst (
      .ACLK             (ACLK),
      .ARESETn          (ARESETn),
      .s_axis_in_TVALID (m_axis_p2p_g_TVALID),
      .s_axis_in_TREADY (m_axis_p2p_g_TREADY),
      .s_axis_in_TDATA  (m_axis_p2p_g_TDATA),
      .s_axis_in_TKEEP  (m_axis_p2p_g_TKEEP),
      .s_axis_in_TLAST  (m_axis_p2p_g_TLAST),
      .s_axis_in_TDEST  (m_axis_p2p_g_TDEST),
      .m_axis_out_TVALID(m_axis_g_TVALID),
      .m_axis_out_TREADY(m_axis_g_TREADY),
      .m_axis_out_TDATA (m_axis_g_TDATA),
      .m_axis_out_TKEEP (m_axis_g_TKEEP),
      .m_axis_out_TLAST (m_axis_g_TLAST),
      .m_axis_out_TDEST (m_axis_g_TDEST)
  );

  letterbox #(
      .STREAM_WIDTH     (STREAM_WIDTH),
      .COUNTER_WIDTH    (10),
      .MAX_W_DIV4_MINUS1(OUTPUT_WIDTH_DIV4_MINUS1  ),
      .IMG_H            (OUTPUT_IMAGE_HEIGHT_MINUS1),
      .LBOX_H           (LBOX_H)
  ) letterbox_b_inst (
      .ACLK             (ACLK),
      .ARESETn          (ARESETn),
      .s_axis_in_TVALID (m_axis_p2p_b_TVALID),
      .s_axis_in_TREADY (m_axis_p2p_b_TREADY),
      .s_axis_in_TDATA  (m_axis_p2p_b_TDATA),
      .s_axis_in_TKEEP  (m_axis_p2p_b_TKEEP),
      .s_axis_in_TLAST  (m_axis_p2p_b_TLAST),
      .s_axis_in_TDEST  (m_axis_p2p_b_TDEST),
      .m_axis_out_TVALID(m_axis_b_TVALID),
      .m_axis_out_TREADY(m_axis_b_TREADY),
      .m_axis_out_TDATA (m_axis_b_TDATA),
      .m_axis_out_TKEEP (m_axis_b_TKEEP),
      .m_axis_out_TLAST (m_axis_b_TLAST),
      .m_axis_out_TDEST (m_axis_b_TDEST)
  );

endmodule
