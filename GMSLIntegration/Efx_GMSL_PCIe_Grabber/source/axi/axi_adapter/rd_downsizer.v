`timescale 1ns / 1ns

module rd_downsizer #(
    parameter                       AXI_AW   = 32,
    parameter                       S_AXI_DW = 32,
    parameter                       M_AXI_DW = 32,
    parameter                       FAMILY   = "TITANIUM"
    
)
(

//Global Signals
input                           clk,
input                           rstn,
//Slave AXI4 Bus Interface
//--Slave AXI4 Read
input                           s_axi_arvalid,
output  reg                     s_axi_arready,
input           [AXI_AW-1:0]    s_axi_araddr,
input           [7:0]           s_axi_arlen,
output  reg                     s_axi_rvalid,
input                           s_axi_rready,
output  wire    [S_AXI_DW-1:0]  s_axi_rdata,
output  wire                    s_axi_rlast,

//Master AXI4 Bus Interface
//--Master AXI4 Bus Read 
output  reg                     m_axi_arvalid,
input                           m_axi_arready,
output  reg     [AXI_AW-1:0]    m_axi_araddr,
output  reg     [7:0]           m_axi_arlen,
output  wire    [7:0]           m_axi_arid,
output  wire    [2:0]           m_axi_arsize,
output  wire    [1:0]           m_axi_arburst,
output  wire    [1:0]           m_axi_arlock,
output  wire    [3:0]           m_axi_arcache,
output  wire    [2:0]           m_axi_arprot,
input                           m_axi_rvalid,
output  reg                     m_axi_rready,
input           [M_AXI_DW-1:0]  m_axi_rdata,
input                           m_axi_rlast,
input           [7:0]           m_axi_rid,
input           [1:0]           m_axi_rresp

);
//Parameter Define
localparam                      RATIO       = S_AXI_DW/M_AXI_DW;
localparam                      RATIO_W     = ($clog2(RATIO) == 0) ? 1 : $clog2(RATIO);
localparam                      S_AXI_SW    = S_AXI_DW/8;
localparam                      M_AXI_SW    = M_AXI_DW/8;
localparam                      S_BURST_WTH = RATIO_W + 8;

//Register Define
reg     [S_BURST_WTH:0]         s_burst_cnt;
reg     [S_BURST_WTH:0]         s_burst_cnt_r;
reg     [RATIO_W:0]             split_cmd_cnt;
reg     [RATIO_W:0]             split_cmd_cnt_r;
reg     [M_AXI_DW-1:0]          in_data_r1;
reg                             in_last_r1;
reg     [M_AXI_DW-1:0]          in_data_r0;
reg                             in_last_r0;
reg     [1:0]                   in_cnt;
reg     [S_AXI_DW-1:0]          sr_data;
reg                             temp_last;
reg     [RATIO_W:0]             in_last_cnt;
reg     [RATIO_W-1:0]           sr_addr;

//Wire Define
wire                            u0_wen;
wire    [RATIO_W:0]             u0_wdata;
wire                            u0_almfull;
wire                            u0_ren;
wire    [RATIO_W:0]             u0_rdata;
wire                            u0_empty;
wire                            in_en;
wire                            sr_en;

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
hAsVrgXldl1Rx7jjEpIw+7Fon1OUqP+dVKtk5xHRg7jGdKsulKjohGx6w2n9WVaG
8vj9ewYLM///18Svq1uFOccrCIH5sAiCFfiBFOEkXVgLqNxEMDeP9oy/dKF9+bW9
6k8LUri4UJBzZQtH/EJd6nTHioC4C1WeRNVipll5ekSxyGdC+r/vihCwgLISlX0E
CujEssxhKtVpC2f4nNtc4KPH/8pRAJJ+LAEh+ta4zRWfvDn3hS1TtMLekxb8+LTc
WCIg5TrCraVF5+jL6lyHhuorWsI1rAkel4iTaChhCWMuYOHXtumQQcClQlyDesu4
WE935xzEJMpWpJDFCTxDJQ==
`pragma protect key_keyowner="Mentor Graphics Corporation"
`pragma protect key_keyname="MGC-VERIF-SIM-RSA-1"
`pragma protect key_method="rsa"
`pragma protect encoding=(enctype="base64", line_length=64, bytes=128)
`pragma protect key_block
BoGxd1kLHKc2/SZE9OCYTXwXy8HvpXgpNwK8oMjjfmozB97X1eW5FDu/vERNxDR0
Rs/50tBSv2Y2Gax05ZWxEqq78HiSSBtDUnaBEJG9TfpUIK429M8HaB8S+I8PVcSv
4wnQmWOqKIUJsGFqxwG+UHahIcRjNOJg0klA0o7mVyQ=
`pragma protect data_method="aes256-cbc"
`pragma protect encoding=(enctype="base64", line_length=64, bytes=11392)
`pragma protect data_block
qCAnn5ub/HqiORt7zrsHeWaEmMw+asmpiQ/2Iy6QF3uj4nNm4i+vfeiyyQ2f8D+p
+7uYGijTOslfA9Io0S8kppR9lPN0gs636KlYA943A2N4V7Dtm8wNaSLE35F6lltI
HUeuKcfuFykKdPR69odAY32F5rukK1eRu5vFtCevjA+M1hwsFYJQLq5te4TApqRD
t1+Mn0D6ohzc+6GiA5sMy0rpJDnIecZQDcD/CBS7HpI+tZoFIOuNGorxvZAKu++8
GwWYUooGuIXi58moklGFLNdkWBthyhkqXF2oqWct6DOG/0P+N715nLmGmPi/XZUS
VYIS6/CNP4uujf3Or+ldvRumxXRvpHGkZ/AJW3sFiFmayv816aL3HJDZcs3YCbhz
d5mbeEkVfQH6nYARJuOJjU7zwAT7M3y1NRQBl002jaPBl/5b9uhiVcZG+CNPBt8Y
ZIV+KeeD1yaXdCHITwgW7AHhArNtzYREi37sNG4tFkGEmODnqIqWOQgEl8pwLnce
jlo3H95Yr28Fky5hrM/55RKdJVIC1mMk96jCDIOgjtSvwIcNJHAgpUmEVmAFb4o6
35pAVSoOcsDQ7NX+G90/fG6H7RXi4J7+lZu+GviOUbgva6PLF3SkxDqAVW7LAyRj
7oZzFP7ooeHAV5FZWUUNk8iEtNM2LoyNfw03Zidy48h/PKcrKbyzIL9kY5l7B2Ro
RZFcPXgCV+1XQYNDw2K06+VvQ1NXRXJefIXmkZTp4HjrAkI67ionJnmwX+Yt4wmV
i5YoCS1rf4il35ztmFF7t9QNbnL2q2zOcyklQVeoVnoy4KLIKv2qj2dHVa2rONtg
IYtRPUjQAVoLSvSD1mUBnXRlXDdrFCCK35rH3xXEs5QX/ym1zmjjHMdvEH91xLKv
dybgXJGUWmD9Sy9oiZzbaAc+GY1scVdBfe1QDh1PWyEx9H/sVOHjDz3jZYT4KUUL
pZ9EMiCnoNjS3YFL6rW0QmP4rYYSlB5G0kbSGzPqyA74fEZGHzm7J9WWsnS21qjz
1wiw8itrWgQV7JuSY3QjP0KtBtGHnLEaPZUu1RubXAtffA15of8vqPSSKg/8QOI4
+gSsUauKoKf9diQZIlZxGKgKlDxyn+7UmXoYGLtiVfbENyEUA/MqB2xe16tuAkZ5
8HmUbPsgKhzdh9wAkBvCswkIDthf4UDATXEo8yBzVH5+VEsXfXNMnuoAF7YpoIGe
6usbFPjKOwrPaHJclwcs28maCHo5VS/HmxqpZjUBk+iaL/N9tIfyrzpiSEuvxQ9h
ImW3CsXtMSE16c//IrgGumbzN9KYP4oWbxjWs2Vh8ddiHz52varVUuc/pQTVVnHR
tM69QS6u3g1VtLSdS/anfxTGF0i+9xOI0qDhhyPbcgmx7cpW6nB7usuW3p8wMoFU
XCrBbsLmOs26ZYMrg6oI05yfA6GWU24k+QbztK+/3GfYFUcTf3LHN3HBWovCZut2
0ZsFOzKCwZ+8K0gwmCDvQdBGqytGATC33DtKXsMU8dtNzByPqd2lSxQIFd01XYN9
M+9YknjgMtoq3eCmdhUgJ9g41iqWe7zJZ+N6EKnaEJGyMGaitJ1zzd5M/vLmtKL2
snsTj3RaNjOQZje+x9ezmSlJtUWVh2knGUrAY1DAMqQ/n/G/u33awQZRHVoFTz9F
I9cgSaEro1I4QMkAtlX2HTLG2eStrGbI8RlNrKR8hFWOZ4j6eSIGPbEqNhbbfkNF
RcdBrqYK2dx8gzGA6YL2Mt0zp1W3f6iGTfG6fKMOQYSJc1CNg+orYE0eI5gNY7EJ
INLJki3+jliqF2h/hBO8myA5bWSlbhls5ogRE0nMMVaQECYFcckJ1dp98Pd5xyTr
k3Pc1Ix4Cx280r9g3HMgiMyDYM4tcl6dt402kku3O43R0j95JV1SK/QuvSfi5ee3
XVkS/p6hWaIzjrnieO6GRkOahzpdhL2wOsKIbcJnTEyRZ8ul2fhCbfIYRd+G6UQA
ze8k0Ob2Te1nU2QT5PoVmz8szMktdmJfY+h1p6HR+6zjmeD9vb7DtaNn858ROlWV
XJCxYn6F2ZT+flwyYnf5d0gTj3/+DzcJPdKWcLkP7XVf+ycPR/jPgnE1aoEEqXlG
jCokyohDfajEc+MzukXQk9/eOg4FGChUaZkknzoqZOhWeixHiCmz4ETDWYnxqw9X
tsOiLYA3tRKs5fvvIWrprzZ2yiHXdXQnEq1EdPB0O/QYD7/kz78clmIwVLpLap05
8uVWSlKjS/cJAIm00oOyd55OjowsoMTtSrTRBYXOZkbAqmfE8cF28GYigcsmxkfd
K5hV9msI/BdCxcCjP30b8NoHZQsro/eW+6UmiQK+K161a5kOymKXREIdWZiIYmF6
icBm/oqrhgmSGg3BEHk7Gcfqmk8QoKVypN4KMS2zvLgRAaLpNOf1DxawFFyfFS8U
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
dZbCNsVnMAd+k371sQaAWw==
`pragma protect end_protected
endmodule
