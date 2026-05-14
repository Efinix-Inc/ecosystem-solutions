module data_check #(
parameter        DATA_WIDTH = 32

)
(
input                           clk,
input                           rst_n,
                           
input                           data_en,
input                           data_last,
input           [DATA_WIDTH-1:0]data,
output    reg   [DATA_WIDTH-1:0]          data_rev,
output    reg   [DATA_WIDTH/64-1:0]       data_err_temp,

output  reg                     data_err
);

reg   [15:0]                    data_cnt;
reg   [15:0]                    err_cnt;
reg                             data_en_1d;

wire  [DATA_WIDTH-1:0]          data_rev_temp;


always @ (posedge clk , negedge rst_n)
begin
    if(rst_n == 1'b0)
        data_cnt <= 16'h0;
    else if(data_en == 1'b1)
        data_cnt <= data_cnt + 1;
    else;
end

always @ (posedge clk , negedge rst_n)
begin
    if(rst_n == 1'b0)
        data_rev <= 'h0;
    else if(data_en == 1'b1)
        data_rev <= data;
    else;
end


genvar i;
generate 
for(i=0;i<DATA_WIDTH/64;i=i+1)begin

assign data_rev_temp[i*64+:64] = data_rev[i*64+:64] + (DATA_WIDTH/64);

always @ (posedge clk , negedge rst_n)
begin
    if(rst_n == 1'b0)
        data_err_temp[i] <= 1'h0;
    else if((data_en == 1'b1) && (data_rev_temp[i*64+:64] != data[i*64+:64]))
        data_err_temp[i] <= 1'b1;
    else
        data_err_temp[i] <= 1'h0;
end

end
endgenerate


always @ (posedge clk , negedge rst_n)
begin
    if(rst_n == 1'b0)
        data_err <= 1'h0;
    else if(err_cnt>1)
        data_err <= 1;
    else
        data_err <= 1'h0;

end

always @ (posedge clk , negedge rst_n)
begin
    if(rst_n == 1'b0)
        err_cnt <= 16'h0;
    else if(data_cnt == 16'h0)
        err_cnt <= 16'h0;
    else if(data_err_temp != 0)
        err_cnt <= err_cnt + 1'b1;
end

endmodule