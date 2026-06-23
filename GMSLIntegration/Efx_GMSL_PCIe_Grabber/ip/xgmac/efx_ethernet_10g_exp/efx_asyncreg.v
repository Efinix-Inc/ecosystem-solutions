
// synopsys translate_off
`timescale 1 ns / 1 ps													
// synopsys translate_on

module efx_asyncreg #(
    parameter ASYNC_STAGE = 2,
    parameter WIDTH = 4,
    parameter ACTIVE_LOW = 1, // 0 - Active high reset, 1 - Active low reset
    parameter RST_VALUE = 0 
) (
    input  wire             clk,
    input  wire             reset_n,
    input  wire [WIDTH-1:0] d_i,
    output wire [WIDTH-1:0] d_o
);

(* async_reg = "true" *) reg [WIDTH-1:0] async_reg[ASYNC_STAGE-1:0];

assign d_o = async_reg[ASYNC_STAGE-1];

genvar i;
generate
   if (ACTIVE_LOW == 1) begin: active_low
      if (RST_VALUE == 0) begin: low_reset_0
         always @ (posedge clk or negedge reset_n) begin
             if(!reset_n) begin
                 async_reg[0]         <= {WIDTH{1'b0}};
             end
             else begin 
                 async_reg[0]         <= d_i;
             end
         end
             
         for (i=1; i<ASYNC_STAGE; i=i+1) begin
             always @ (posedge clk or negedge reset_n) begin
                 if(!reset_n) begin
                     async_reg[i]         <= {WIDTH{1'b0}};
                 end
                 else begin 
                     async_reg[i]         <= async_reg[i-1];
                 end
             end
         end
      end
      else begin: low_reset_1
         always @ (posedge clk or negedge reset_n) begin
             if(!reset_n) begin
                 async_reg[0]         <= {WIDTH{1'b1}};
             end
             else begin 
                 async_reg[0]         <= d_i;
             end
         end
             
         for (i=1; i<ASYNC_STAGE; i=i+1) begin
             always @ (posedge clk or negedge reset_n) begin
                 if(!reset_n) begin
                     async_reg[i]         <= {WIDTH{1'b1}};
                 end
                 else begin 
                     async_reg[i]         <= async_reg[i-1];
                 end
             end
         end
      end
   end
   else begin: active_high
      if (RST_VALUE == 0) begin: high_reset_0
         always @ (posedge clk or posedge reset_n) begin
             if(reset_n) begin
                 async_reg[0]         <= {WIDTH{1'b0}};
             end
             else begin 
                 async_reg[0]         <= d_i;
             end
         end
             
         for (i=1; i<ASYNC_STAGE; i=i+1) begin
             always @ (posedge clk or posedge reset_n) begin
                 if(reset_n) begin
                     async_reg[i]         <= {WIDTH{1'b0}};
                 end
                 else begin 
                     async_reg[i]         <= async_reg[i-1];
                 end
             end
         end
      end
      else begin: high_reset_1
         always @ (posedge clk or posedge reset_n) begin
             if(reset_n) begin
                 async_reg[0]         <= {WIDTH{1'b1}};
             end
             else begin 
                 async_reg[0]         <= d_i;
             end
         end
             
         for (i=1; i<ASYNC_STAGE; i=i+1) begin
             always @ (posedge clk or posedge reset_n) begin
                 if(reset_n) begin
                     async_reg[i]         <= {WIDTH{1'b1}};
                 end
                 else begin 
                     async_reg[i]         <= async_reg[i-1];
                 end
             end
         end
      end
   end
endgenerate

endmodule
