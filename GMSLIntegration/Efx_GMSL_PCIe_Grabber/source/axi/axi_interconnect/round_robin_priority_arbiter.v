
`timescale 1ns / 1ns
 
module round_robin_priority_arbiter#(
    parameter                       REQ_NUM = 3, 
    localparam                      REQ_NUM_WTH = (REQ_NUM > 1) ? $clog2(REQ_NUM) : 1 
)
(
input                           clk,
input                           rstn,

input           [REQ_NUM-1:0]   ch_req,

input                           grant_ready,
output  wire                    grant_valid,
output  reg     [REQ_NUM_WTH-1:0] 
                                grant_num
);
//Parameter Define
 
//Register Define
reg     [REQ_NUM-1:0]           last_state;
reg     [REQ_NUM-1:0]           one_hot_mem [REQ_NUM-1:0];
reg     [REQ_NUM_WTH-1:0]       grant_num_next;
reg                             grant_req;
reg     [REQ_NUM-1:0]           grant_r;
//Wire Define
wire    [2*REQ_NUM-1:0]         grant_ext;
wire    [REQ_NUM-1:0]           grant;

`pragma protect begin_protected
`pragma protect version=1
`pragma protect encrypt_agent="ipecrypt"
`pragma protect encrypt_agent_info="http://ipencrypter.com Version: 20.0.8"
`pragma protect author="author-a"
`pragma protect author_info="author-a-details"

`pragma protect key_keyowner="Efinix Inc."
`pragma protect key_keyname="EFX_K01"
`pragma protect key_method="rsa"
`pragma protect encoding=(enctype="base64", line_length=64, bytes=256)
`pragma protect key_block
CVZepyWNdgPHzAM6aUVZ6G/ccXEWifN8P1yY4diOaYn7D5IXrm8yFXKLHkkCtYlX
aPDwtPGy5lWtMjQn5asC97r+IQSF2xB11x9qICS0Ta1xdCQuSmFHTAzQeB897upv
tFVJULkH/iAvlHrXXhPIgizG/NvvwhGcpCHtYvftthYqgDtt0s5zARjtBEI/t2K2
d+Rp+VvdY7eXHtd7qPdVW75tvN1Dl3NwSrcxqpvq/PmBaH9kqzw3N4sUW0oxZDyo
n09mk4bjtmd/Pi83XGn4nOUbYX7w7adYJ6ZDmPAan8rw0+RkHN/yVok7+yXFTin6
weTcF9ND/j3IvWDJInsa7Q==
`pragma protect key_keyowner="Mentor Graphics Corporation"
`pragma protect key_keyname="MGC-VERIF-SIM-RSA-1"
`pragma protect key_method="rsa"
`pragma protect encoding=(enctype="base64", line_length=64, bytes=128)
`pragma protect key_block
cLpr1Lygtb1gV4jk6GcUL9Jc2wNAEPckw5eLj/I8GU7vs4DDp2BxaF8PjhP8tivg
s9LIvHw3S+IQQ45pG2DknV1jizW+KV9pZqFnRSOLB2ejATkQML+veFedHeEHQt31
srq1QbsbE5CM2xT51BHX91HhDhxcMlrxXfk+bcEPjIk=
`pragma protect data_method="aes256-cbc"
`pragma protect encoding=(enctype="base64", line_length=64, bytes=2000)
`pragma protect data_block
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
`pragma protect end_protected
endmodule
