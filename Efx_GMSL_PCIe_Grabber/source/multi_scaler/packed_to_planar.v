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

module packed_to_planar #(
    parameter STREAM_WIDTH = 32,
    parameter COUNTER_WIDTH = 9,
    parameter MAX_W_DIV4_MINUS1 = 95,  // 384/4 = 96
    parameter MAX_H = 215
) (
    input                       ACLK,
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

  wire                     r_full;
  wire                     g_full;
  wire                     b_full;
  wire                     r_empty;
  wire                     g_empty;
  wire                     b_empty;
  wire                     r_read;
  wire                     g_read;
  wire                     b_read;
  wire                     in_hs;
  // wire                     out_hs;
  wire                     r_hs;
  wire                     g_hs;
  wire                     b_hs;
  wire [ STREAM_WIDTH-1:0] r_tdata;
  wire [ STREAM_WIDTH-1:0] g_tdata;
  wire [ STREAM_WIDTH-1:0] b_tdata;
  // reg  [COUNTER_WIDTH-1:0] sx_div4;
  // reg  [              2:0] color;
  reg  [COUNTER_WIDTH-1:0] r_sx_div4;
  reg  [COUNTER_WIDTH-1:0] g_sx_div4;
  reg  [COUNTER_WIDTH-1:0] b_sx_div4;
  reg  [COUNTER_WIDTH-1:0] r_sy;
  reg  [COUNTER_WIDTH-1:0] g_sy;
  reg  [COUNTER_WIDTH-1:0] b_sy;

  assign s_axis_in_TREADY = ~r_full & ~g_full & ~b_full;
  assign in_hs            = s_axis_in_TVALID & s_axis_in_TREADY;
  // assign out_hs           = m_axis_out_TVALID & m_axis_out_TREADY;
  // assign m_axis_out_TKEEP = 4'hF;
  // assign m_axis_out_TLAST = (MAX_W_DIV4_MINUS1 == sw);
  assign r_hs             = m_axis_r_TVALID & m_axis_r_TREADY;
  assign g_hs             = m_axis_g_TVALID & m_axis_g_TREADY;
  assign b_hs             = m_axis_b_TVALID & m_axis_b_TREADY;
  assign m_axis_r_TVALID  = ~r_empty;
  assign m_axis_g_TVALID  = ~g_empty;
  assign m_axis_b_TVALID  = ~b_empty;
  assign r_read           = m_axis_r_TREADY;
  assign g_read           = m_axis_g_TREADY;
  assign b_read           = m_axis_b_TREADY;
  assign m_axis_r_TDATA   = r_tdata;
  assign m_axis_g_TDATA   = g_tdata;
  assign m_axis_b_TDATA   = b_tdata;
  assign m_axis_r_TKEEP   = 4'hF;
  assign m_axis_g_TKEEP   = 4'hF;
  assign m_axis_b_TKEEP   = 4'hF;
  assign m_axis_r_TLAST   = (MAX_W_DIV4_MINUS1 == r_sx_div4) && (MAX_H == r_sy);
  assign m_axis_g_TLAST   = (MAX_W_DIV4_MINUS1 == g_sx_div4) && (MAX_H == g_sy);
  assign m_axis_b_TLAST   = (MAX_W_DIV4_MINUS1 == b_sx_div4) && (MAX_H == b_sy);

  // always @(posedge ACLK) begin
  //   if (!ARESETn) begin
  //     sx_div4    <= 0;
  //     color <= 3'b001;
  //   end else if (out_hs) begin
  //     if (MAX_W_DIV4_MINUS1 == sx_div4) begin
  //       sx_div4    <= 0;
  //       color <= (3'b100 == color) ? 3'b001 : (color << 1);
  //     end else begin
  //       sx_div4 <= sx_div4 + 1;
  //     end
  //   end
  // end

  always @(posedge ACLK) begin
    if (!ARESETn) begin
      r_sx_div4 <= 0;
      r_sy      <= 0;
    end else if (r_hs) begin
      if (MAX_W_DIV4_MINUS1 == r_sx_div4) begin
        r_sx_div4 <= 0;
        r_sy      <= (MAX_H == r_sy) ? 0 : r_sy + 1;
      end else begin
        r_sx_div4 <= r_sx_div4 + 1;
      end
    end
  end

  always @(posedge ACLK) begin
    if (!ARESETn) begin
      g_sx_div4 <= 0;
      g_sy      <= 0;
    end else if (g_hs) begin
      if (MAX_W_DIV4_MINUS1 == g_sx_div4) begin
        g_sx_div4 <= 0;
        g_sy      <= (MAX_H == g_sy) ? 0 : g_sy + 1;
      end else begin
        g_sx_div4 <= g_sx_div4 + 1;
      end
    end
  end

  always @(posedge ACLK) begin
    if (!ARESETn) begin
      b_sx_div4 <= 0;
      b_sy      <= 0;
    end else if (b_hs) begin
      if (MAX_W_DIV4_MINUS1 == b_sx_div4) begin
        b_sx_div4 <= 0;
        b_sy      <= (MAX_H == b_sy) ? 0 : b_sy + 1;
      end else begin
        b_sx_div4 <= b_sx_div4 + 1;
      end
    end
  end

  // localparam ColorR = 3'b001, ColorG = 3'b010, ColorB = 3'b100;

  // always @(*) begin
  //   case (color)
  //     ColorR: begin
  //       m_axis_out_TVALID        = ~r_empty;
  //       m_axis_out_TDATA         = r_tdata;
  //       {r_read, g_read, b_read} = {m_axis_out_TREADY, 1'b0, 1'b0};
  //     end

  //     ColorG: begin
  //       m_axis_out_TVALID        = ~g_empty;
  //       m_axis_out_TDATA         = g_tdata;
  //       {r_read, g_read, b_read} = {1'b0, m_axis_out_TREADY, 1'b0};
  //     end

  //     ColorB: begin
  //       m_axis_out_TVALID        = ~b_empty;
  //       m_axis_out_TDATA         = b_tdata;
  //       {r_read, g_read, b_read} = {1'b0, 1'b0, m_axis_out_TREADY};
  //     end
  //   endcase
  // end

  // 1024x8 in, 256x32 out
  planar_fifo_in8out32 r_fifo_inst (
      .clk_i         (ACLK),
      .a_rst_i       (~ARESETn),
      .wr_datacount_o(),
      .rd_datacount_o(),
      .wr_en_i       (in_hs),
      .full_o        (r_full),
      .wdata         (s_axis_in_TDATA[0+:8]),
      .empty_o       (r_empty),
      .rd_en_i       (r_read),
      .rdata         (r_tdata)
  );

  planar_fifo_in8out32 g_fifo_inst (
      .clk_i         (ACLK),
      .a_rst_i       (~ARESETn),
      .wr_datacount_o(),
      .rd_datacount_o(),
      .wr_en_i       (in_hs),
      .full_o        (g_full),
      .wdata         (s_axis_in_TDATA[8+:8]),
      .empty_o       (g_empty),
      .rd_en_i       (g_read),
      .rdata         (g_tdata)
  );

  planar_fifo_in8out32 b_fifo_inst (
      .clk_i         (ACLK),
      .a_rst_i       (~ARESETn),
      .wr_datacount_o(),
      .rd_datacount_o(),
      .wr_en_i       (in_hs),
      .full_o        (b_full),
      .wdata         (s_axis_in_TDATA[16+:8]),
      .empty_o       (b_empty),
      .rd_en_i       (b_read),
      .rdata         (b_tdata)
  );

endmodule
