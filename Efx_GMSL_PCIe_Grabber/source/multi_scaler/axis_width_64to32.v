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

module axis_width_64to32 #(
    parameter STREAM_WIDTH_IN  = 64,
    parameter STREAM_WIDTH_OUT = 32
) (
    input                           ACLK_in,
    input                           ACLK_out,
    input                           ARESETn,
    input                           s_axis_in_TVALID,
    output                          s_axis_in_TREADY,
    input  [   STREAM_WIDTH_IN-1:0] s_axis_in_TDATA,
    input  [ STREAM_WIDTH_IN/8-1:0] s_axis_in_TKEEP,
    input                           s_axis_in_TLAST,
    input  [                   3:0] s_axis_in_TDEST,
    output                          m_axis_out_TVALID,
    input                           m_axis_out_TREADY,
    output [  STREAM_WIDTH_OUT-1:0] m_axis_out_TDATA,
    output [STREAM_WIDTH_OUT/8-1:0] m_axis_out_TKEEP,
    output                          m_axis_out_TLAST,
    output [                   3:0] m_axis_out_TDEST
);

  wire tdata_full;
  wire tkeep_full;
  wire tlast_full;
  wire tdata_empty;
  wire tkeep_empty;
  wire tlast_empty;

  assign s_axis_in_TREADY  = ~tdata_full & ~tkeep_full & ~tlast_full;
  assign m_axis_out_TVALID = ~tdata_empty & ~tkeep_empty & ~tlast_empty;

  wire dbg_tdata_fifo_underflow;
  wire dbg_tkeep_fifo_underflow;
  wire dbg_tlast_fifo_underflow;
  wire dbg_tdata_fifo_overflow;
  wire dbg_tkeep_fifo_overflow;
  wire dbg_tlast_fifo_overflow;
  wire [7:0] dbg_tdata_fifo_wr_datacount;
  wire [7:0] dbg_tkeep_fifo_wr_datacount;
  wire [7:0] dbg_tlast_fifo_wr_datacount;
  wire [8:0] dbg_tdata_fifo_rd_datacount;
  wire [8:0] dbg_tkeep_fifo_rd_datacount;
  wire [8:0] dbg_tlast_fifo_rd_datacount;

  localparam Fifo_Impl = 0;
  generate
    if (Fifo_Impl == 0) begin
      tdata_fifo_in64out32 tdata_fifo_inst (
          .a_rst_i    (~ARESETn),
          .rst_busy   (),
          .underflow_o(dbg_tdata_fifo_underflow),
          .overflow_o (dbg_tdata_fifo_overflow),

          .wr_clk_i      (ACLK_in),
          .wdata         (s_axis_in_TDATA),
          .wr_en_i       (s_axis_in_TVALID),
          .full_o        (tdata_full),
          .wr_datacount_o(dbg_tdata_fifo_wr_datacount),

          .rd_clk_i      (ACLK_out),
          .rdata         (m_axis_out_TDATA),
          .rd_en_i       (m_axis_out_TREADY),
          .empty_o       (tdata_empty),
          .rd_datacount_o(dbg_tdata_fifo_rd_datacount)
      );

      tkeep_fifo_in8out4 tkeep_fifo_inst (
          .a_rst_i    (~ARESETn),
          .rst_busy   (),
          .underflow_o(dbg_tkeep_fifo_underflow),
          .overflow_o (dbg_tkeep_fifo_overflow),

          .wr_clk_i      (ACLK_in),
          .wdata         (s_axis_in_TKEEP),
          .wr_en_i       (s_axis_in_TVALID),
          .full_o        (tkeep_full),
          .wr_datacount_o(dbg_tkeep_fifo_wr_datacount),

          .rd_clk_i      (ACLK_out),
          .rdata         (m_axis_out_TKEEP),
          .rd_en_i       (m_axis_out_TREADY),
          .empty_o       (tkeep_empty),
          .rd_datacount_o(dbg_tkeep_fifo_rd_datacount)
      );

      tlast_tdest_fifo_in10out5 tlast_tdest_fifo_inst (
          .a_rst_i    (~ARESETn),
          .rst_busy   (),
          .underflow_o(dbg_tlast_fifo_underflow),
          .overflow_o (dbg_tlast_fifo_overflow),

          .wr_clk_i      (ACLK_in),
          .wdata         ({s_axis_in_TLAST, s_axis_in_TDEST, 1'b0, s_axis_in_TDEST}),
          .wr_en_i       (s_axis_in_TVALID),
          .full_o        (tlast_full),
          .wr_datacount_o(dbg_tlast_fifo_wr_datacount),

          .rd_clk_i      (ACLK_out),
          .rdata         ({m_axis_out_TLAST, m_axis_out_TDEST}),
          .rd_en_i       (m_axis_out_TREADY),
          .empty_o       (tlast_empty),
          .rd_datacount_o(dbg_tlast_fifo_rd_datacount)
      );
    end
  endgenerate

endmodule
