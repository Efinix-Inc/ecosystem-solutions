`timescale 1 ns / 1 ns
module sfifo_d3_wx#(
    parameter                       WTH = 16
)
(
input                           clk,
input                           rstn,
input           [WTH-1:0]       data,
input                           wrreq,
input                           rdreq,
output  wire    [WTH-1:0]       q,
output  wire    [1:0]           usedw,
output  wire                    full,
output  wire                    empty,
output  wire                    almost_full,
output  wire                    almost_empty
);
// Parameter Define 

// Register Define 
reg     [3*WTH-1:0]             sr_dout;
reg     [1:0]                   sr_cnt;

// Wire Define

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
QbHAvE0MP9lSLpLJX/5HyROHqCALcDoJrYLrzt/zN3Irr3myd70FgwqbXCjQncOm
vx8rJzyESnmyEvr/9N/VJyg2PRbCLRCyX6Z8GngukFazUFHiFgl30d4MZhtnqNvv
wdgCGsA5OnY0emSAWxz9UtqbY3KJuO69rXNLixKQigMdFp0zlNgPGPyCsT+g5HYS
dxbCFvMUTyOeTIsWFjmaDBkZXcs78J3b+bf6ktZX1qyE2mrZO0ZrtUuSvUP58XsJ
GIPIxS3SbHfhwk0MQ7/RGQe/3Lnj6k9FtQFNRGemnCfi6sPN7Weiflo4ZFgIylc/
g0m3Q40gKd6WSLX/kOoPfg==
`pragma protect key_keyowner="Mentor Graphics Corporation"
`pragma protect key_keyname="MGC-VERIF-SIM-RSA-1"
`pragma protect key_method="rsa"
`pragma protect encoding=(enctype="base64", line_length=64, bytes=128)
`pragma protect key_block
NGU7FTMZ2pasnWoRmggud2ew4WUpkbW0VoMPRgtfzN6AT30NXyWuYBAxUxVeb4lx
XzcMnF04meMr0HQAvi0oC55sQORMETmPjagRCfdYFgjJ88YRWQbGI5uZDM5aXAVr
iljPeutFV170jvH1smymd0OkfT1KrsJF5IpwofiMtZ0=
`pragma protect data_method="aes256-cbc"
`pragma protect encoding=(enctype="base64", line_length=64, bytes=2384)
`pragma protect data_block
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
`pragma protect end_protected
endmodule
