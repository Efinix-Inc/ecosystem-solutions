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

module integer_downscale #(
    parameter STREAM_WIDTH = 32,
    parameter COUNTER_WIDTH = 11,
    parameter MAX_W = 1919,
    parameter MAX_H = 1079,
    parameter FACTOR_WIDTH = 3,
    parameter SCALE_FACTOR_MINUS1 = 4
) (
    input                       ACLK,
    input                       ARESETn,
    input                       s_axis_in_TVALID,
    output                      s_axis_in_TREADY,
    input  [  STREAM_WIDTH-1:0] s_axis_in_TDATA,
    input  [STREAM_WIDTH/8-1:0] s_axis_in_TKEEP,
    input                       s_axis_in_TLAST,
    input  [               3:0] s_axis_in_TDEST,
    output                      m_axis_out_TVALID,
    input                       m_axis_out_TREADY,
    output [  STREAM_WIDTH-1:0] m_axis_out_TDATA,
    output [STREAM_WIDTH/8-1:0] m_axis_out_TKEEP,
    output                      m_axis_out_TLAST,
    output [               3:0] m_axis_out_TDEST
);

  reg  [COUNTER_WIDTH-1:0] sx;
  reg  [COUNTER_WIDTH-1:0] sy;
  reg  [ FACTOR_WIDTH-1:0] fx;
  reg  [ FACTOR_WIDTH-1:0] fy;
  wire                     in_hs;
  wire                     out_enable;
  wire                     out_xlast;
  wire                     out_ylast;

  assign s_axis_in_TREADY  = m_axis_out_TREADY;
  assign in_hs             = s_axis_in_TVALID & s_axis_in_TREADY;
  assign out_enable        = (fx == 0) && (fy == 0);
  assign m_axis_out_TVALID = s_axis_in_TVALID & out_enable;
  assign m_axis_out_TDATA  = s_axis_in_TDATA & {STREAM_WIDTH{out_enable}};
  assign m_axis_out_TDEST  = s_axis_in_TDEST & {4{out_enable}};
  assign out_xlast         = ((MAX_W - SCALE_FACTOR_MINUS1) == sx);
  assign out_ylast         = ((MAX_H - SCALE_FACTOR_MINUS1) == sy);
  assign m_axis_out_TLAST  = out_xlast & out_ylast;

  always @(posedge ACLK) begin
    if (!ARESETn) begin
      sx <= 0;
      sy <= 0;
      fx <= 0;
      fy <= 0;
    end else if (in_hs) begin
      if (MAX_W == sx) begin
        sx <= 0;
        sy <= (MAX_H == sy) ? 0 : sy + 1;
        fy <= (SCALE_FACTOR_MINUS1 == fy) ? 0 : fy + 1;
      end else begin
        sx <= sx + 1;
      end

      if (SCALE_FACTOR_MINUS1 == fx) begin
        fx <= 0;
      end else begin
        fx <= fx + 1;
      end
    end
  end

endmodule
