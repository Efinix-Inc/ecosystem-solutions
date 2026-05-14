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

module letterbox #(
    parameter STREAM_WIDTH = 32,
    parameter COUNTER_WIDTH = 9,
    parameter MAX_W_DIV4_MINUS1 = 95,
    parameter IMG_H = 215,
    parameter LBOX_H = 83
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

  reg  [COUNTER_WIDTH-1:0] sx_div4;
  reg  [COUNTER_WIDTH-1:0] sy;
  wire [COUNTER_WIDTH-1:0] max_h;
  wire                     at_max_h;
  reg  [              1:0] curr_state;
  reg  [              1:0] next_state;
  wire                     out_hs;
  wire                     in_box;
  wire                     last_beat;

  localparam Idle = 2'd0, TBox = 2'd1, OrgImg = 2'd2, BBox = 2'd3;

  assign in_box            = (curr_state == TBox) || (curr_state == BBox);
  assign max_h             = (in_box) ? LBOX_H : IMG_H;
  assign at_max_h          = (max_h == sy);
  assign at_max_w          = (MAX_W_DIV4_MINUS1 == sx_div4);
  assign out_hs            = m_axis_out_TVALID & m_axis_out_TREADY;
  assign s_axis_in_TREADY  = m_axis_out_TREADY & (curr_state == OrgImg);
  assign m_axis_out_TVALID = (s_axis_in_TVALID & (curr_state == OrgImg)) | in_box;
  assign m_axis_out_TDATA  = (curr_state == OrgImg) ? s_axis_in_TDATA : (in_box) ? 32'h72727272 : 32'd0;  // 'd114 = 'h72
  assign m_axis_out_TKEEP  = 4'hF;
  assign m_axis_out_TLAST  = (curr_state == BBox) && at_max_h && at_max_w;
  assign m_axis_out_TDEST  = s_axis_in_TDEST;
  assign last_beat         = out_hs && at_max_w && at_max_h;

  always @(*) begin
    case (curr_state)
      Idle: begin
        if (s_axis_in_TVALID) begin
          next_state = TBox;
        end else begin
          next_state = Idle;
        end
      end

      TBox: begin
        if (last_beat) begin
          next_state = OrgImg;
        end else begin
          next_state = TBox;
        end
      end

      OrgImg: begin
        if (last_beat) begin
          next_state = BBox;
        end else begin
          next_state = OrgImg;
        end
      end

      BBox: begin
        if (last_beat) begin
          next_state = Idle;
        end else begin
          next_state = BBox;
        end
      end

      default: next_state = Idle;
    endcase
  end

  always @(posedge ACLK) begin
    if (!ARESETn) begin
      curr_state <= Idle;
    end else begin
      curr_state <= next_state;
    end
  end

  always @(posedge ACLK) begin
    if (!ARESETn) begin
      sx_div4 <= 0;
      sy      <= 0;
    end else if (out_hs) begin
      if (at_max_w) begin
        sx_div4 <= 0;
        sy      <= at_max_h ? 0 : sy + 1;
      end else begin
        sx_div4 <= sx_div4 + 1;
      end
    end
  end

endmodule
