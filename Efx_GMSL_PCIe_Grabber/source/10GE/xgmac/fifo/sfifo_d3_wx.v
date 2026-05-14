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
output  wire    [2:0]           usedw,
output  wire                    full,
output  wire                    empty,
output  wire                    almost_full,
output  wire                    almost_empty
);
// Parameter Define 

// Register Define 
reg     [4*WTH-1:0]             sr_dout;
reg     [2:0]                   sr_cnt;

// Wire Define

/*----------------------------------------------------------------------------------*\
                                 The main code
\*----------------------------------------------------------------------------------*/
//Encryption begin
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
B0Lyyrr5RhYP1PCKMRVghd+/JF4CA/9eKH//JRQwVngc3/kQ+3Rm92cyp5Q7k2kV
xiMDsh+ZartYeVAzOzlIFHM4I0IjavCOmThZDZ3wy5ICJ9s4r5zvGex2TqzKi5BO
w+1Jrr4rsu2nUWwbvvRrzIWDGT5jfDMQlMmBJZlg9PKDAs33y1kcztpLe1pn7Vl8
iHTZl3DrGaCAGCpm4BuWws6xOzvq900USYFDu60+s7KLoWL74nm5qVibs2IAJfA2
AxE+dV+PZ3YhCvPufVtLOH26/CMzno3qZRZmugJsTQuhmi8n1Am8bYHnzOXTOfEN
ZSi8if2Gyqcs7028p0sv3A==
`pragma protect key_keyowner="Mentor Graphics Corporation"
`pragma protect key_keyname="MGC-VERIF-SIM-RSA-1"
`pragma protect key_method="rsa"
`pragma protect encoding=(enctype="base64", line_length=64, bytes=128)
`pragma protect key_block
XASOgnMT+SXCMWjsHhw3f6z3WkTshRgc91vMPYDsGEwH7yS91XV8OKIwC/HZcTBr
BW+0DMOuWVSvf1ZM4f1VhUtjWddPSm4yEA2/GjYWThPG1YvdTOGMV89aDcDuNirF
6nGnzfg4/as1OSzDVlD/H9TM4ihDHSJIzJshm0F6m/M=
`pragma protect data_method="aes256-cbc"
`pragma protect encoding=(enctype="base64", line_length=64, bytes=2768)
`pragma protect data_block
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
`pragma protect end_protected
endmodule
