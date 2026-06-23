module custom_sg_linked_list #(
  parameter srcAddr      = 32'h00010000,
  parameter dstAddr      = 32'h00020000,
  parameter frame_rate   = 5,    
  parameter buffer_size  = 1280   
) (
  input                 clk,
  input                 reset,
  input   wire          sg_cmd_valid,
  output  wire          sg_cmd_ready,
  input   wire          sg_cmd_read,
  input   wire          sg_cmd_write,
  input   wire [1:0]    sg_cmd_channelId,
  input   wire [26:0]   sg_cmd_bytesDone,
  input   wire          sg_cmd_endOfPacket,
  input   wire          sg_cmd_completed,
  output  reg           sg_rsp_valid,
  output  reg [1:0]     sg_rsp_channelId,
  output  reg [31:0]    sg_rsp_srcAddress,
  output  reg [31:0]    sg_rsp_dstAddress,
  output  reg [25:0]    sg_rsp_bytes,
  output  reg           sg_rsp_last,
  output  reg           sg_rsp_stallout

);
/////////////////////////////////////////////////////////////////////////////

  reg        [15:0]   srcLine;
  reg        [31:0]   srcPtr;
  wire                srcIsLast;
  wire                srcIsStall;

  reg        [15:0]   dstLine;
  reg        [31:0]   dstPtr;
  wire                dstIsLast;
  wire                dstIsStall;
/////////////////////////////////////////////////////////////////////////////

    assign srcIsLast     = (srcLine == frame_rate-1);
    assign srcIsStall    = (srcLine == frame_rate);
    assign dstIsLast     = (dstLine == frame_rate-1);
    assign dstIsStall    = (dstLine == frame_rate);
    assign sg_cmd_ready  = 1'b1;    
    
    
    always@(posedge clk)
    begin
        if(sg_cmd_valid)
        begin
          case(sg_cmd_channelId)
          2'b00: 
          begin
              sg_rsp_valid       <= 1'b1;
              sg_rsp_channelId   <= 2'b00;
              sg_rsp_srcAddress  <= srcPtr;
              sg_rsp_dstAddress  <= 0;
              sg_rsp_bytes       <= buffer_size-1;
              sg_rsp_last        <= srcIsLast;
              sg_rsp_stallout    <= srcIsStall;         
          end
          2'b01:
           begin
              sg_rsp_valid       <= 1'b1;
              sg_rsp_channelId   <= 2'b01;
              sg_rsp_srcAddress  <= 0;
              sg_rsp_dstAddress  <= dstPtr;
              sg_rsp_bytes       <= buffer_size-1;
              sg_rsp_last        <= dstIsLast;
              sg_rsp_stallout    <= dstIsStall;         
          end
          default:
          begin
              sg_rsp_valid       <= 1'b0;
              sg_rsp_channelId   <= 2'b00;
              sg_rsp_srcAddress  <= 0;
              sg_rsp_dstAddress  <= 0;
              sg_rsp_bytes       <= 0;
              sg_rsp_last        <= 0;
              sg_rsp_stallout    <= 0;           
          end   
          endcase
        end
        else
        begin
            sg_rsp_valid       <= 1'b0;
            sg_rsp_channelId   <= 2'b00;
            sg_rsp_srcAddress  <= 0;
            sg_rsp_dstAddress  <= 0;
            sg_rsp_bytes       <= 0;
            sg_rsp_last        <= 0;
            sg_rsp_stallout    <= 0;                       
        end
    end 

    always @(posedge clk or posedge reset)
    begin
      if(reset) begin
        srcLine <= 0;
        srcPtr <= srcAddr;
        dstLine <= 0;
        dstPtr <= dstAddr;
      end 
      else begin
        if(sg_cmd_valid) 
            case(sg_cmd_channelId)
            2'b00:
            begin
              srcPtr <= srcPtr + buffer_size;
              srcLine <= srcLine + 1;
              if(srcIsStall) begin
                srcLine <= 0;
                srcPtr <= srcAddr;
              end
            end
            2'b01:
            begin
              dstPtr <= dstPtr + buffer_size;
              dstLine <= dstLine + 1;
              if(dstIsStall) begin
                dstLine <= 0;
                dstPtr <= dstAddr;
              end       
            end
            default:
            begin
                srcLine <= 0;
                srcPtr  <= 0;
                dstLine <= 0;
                dstPtr  <= 0;                
            end
            endcase
      end
    end

endmodule