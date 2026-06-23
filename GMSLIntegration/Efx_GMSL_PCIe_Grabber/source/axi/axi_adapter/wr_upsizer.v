`timescale 1ns / 1ns

module wr_upsizer #(
    parameter                       AXI_AW   = 32,
    parameter                       S_AXI_DW = 32,
    parameter                       M_AXI_DW = 64
)
(
//Slave AXI4 Bus Interface
//--Slave Global Signals
input                           clk,
input                           rstn,
//--Slave AXI4 Write
input                           s_axi_awvalid,
output  reg                     s_axi_awready,
input           [AXI_AW-1:0]    s_axi_awaddr,
input           [7:0]           s_axi_awlen,
input                           s_axi_wvalid,
output  reg                     s_axi_wready,
input           [S_AXI_DW-1:0]  s_axi_wdata,
input           [S_AXI_DW/8-1:0]s_axi_wstrb,
input                           s_axi_wlast,
output  wire                    s_axi_bvalid,
input                           s_axi_bready,
output  wire    [1:0]           s_axi_bresp,

//Master AXI4 Bus Interface
//--Master AXI4 Bus Write 
output  reg                     m_axi_awvalid,
input                           m_axi_awready,
output  reg     [AXI_AW-1:0]    m_axi_awaddr,
output  reg     [7:0]           m_axi_awlen,
output  wire    [2:0]           m_axi_awsize,
output  wire    [7:0]           m_axi_awid,
output  wire    [1:0]           m_axi_awburst,
output  wire    [1:0]           m_axi_awlock,
output  wire    [3:0]           m_axi_awcache,
output  wire    [2:0]           m_axi_awprot,
output  reg                     m_axi_wvalid,
input                           m_axi_wready,
output  wire    [M_AXI_DW-1:0]  m_axi_wdata,
output  wire    [M_AXI_DW/8-1:0]m_axi_wstrb,
output  reg                     m_axi_wlast,
input                           m_axi_bvalid,
output  wire                    m_axi_bready,
input           [1:0]           m_axi_bresp,
input           [7:0]           m_axi_bid
);

//Parameter Define
localparam                      RATIO    = M_AXI_DW/S_AXI_DW;
localparam                      RATIO_W  = $clog2(RATIO);
localparam                      S_AXI_SW = S_AXI_DW/8;
localparam                      M_AXI_SW = M_AXI_DW/8;

//Register Define
reg                             s_w_busy_r;
reg     [S_AXI_DW-1:0]          in_data_r1;
reg     [S_AXI_SW-1:0]          in_strb_r1;
reg                             in_last_r1;
reg     [RATIO_W-1:0]           in_sr_addr_r1;
reg     [S_AXI_DW-1:0]          in_data_r0;
reg     [S_AXI_SW-1:0]          in_strb_r0;
reg                             in_last_r0;
reg     [RATIO_W-1:0]           in_sr_addr_r0;

reg     [1:0]                   in_cnt;
reg     [RATIO_W-1:0]           sr_addr;
reg     [M_AXI_DW-1:0]          sr_data;
reg     [M_AXI_SW-1:0]          sr_strb;

//Wire Define
wire                            s_w_busy;
wire    [8:0]                   s_axi_awlen_temp;
wire                            in_en;
wire                            sr_en;
wire                            sr_addr_set;
wire    [$clog2(M_AXI_SW)-$clog2(S_AXI_SW)-1:0]
                                sr_addr_value; 
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
XZxxlv+grd9ZWgPnRJ67dPQM2EGLcier8t5aZyzaBW3pWFki4PcIw6OTZ7Q0NPsx
A6Y63xgUrWRDLUq0n2MRSrjalsmFMPyk8E2rji7Mo8y62X+H2eN6f6Grcm1Sdv2A
FneK0eN3VO5KBbeG7ZZjsAgLhNrzd2ESPXIJeib3IG0pzU1248+yiy2gcEVmOPSy
VESBOuK+sX8eOWmXdT9qeSBooFGjIJYdNwKjDqPGItZo8e5/i9o+aq7q2ASUx4GD
D1lsElWtZ3b1sNCTkzf1b8z29jVKCtjALVZ0GzGPTNkAyGo9RLHrGMFHxpO5aYg7
6r/f7gqXQQ6DGTKdQO4SjQ==
`pragma protect key_keyowner="Mentor Graphics Corporation"
`pragma protect key_keyname="MGC-VERIF-SIM-RSA-1"
`pragma protect key_method="rsa"
`pragma protect encoding=(enctype="base64", line_length=64, bytes=128)
`pragma protect key_block
aJQlzLSnZIkABHjTkk1leLHfZhOOO1ZRwiQQQgCbmXni052LOUUL0GF8xSBRPKR8
L2YPBMIWscl0OC1q1eAeIHKLjh4yzR7iWWmzzFbK6hpCH2Y5Y9/1YDB7/ufAG/p1
oghDrMw2dJxrfe5Q2KtFWQ6Np1S+2yY7JRFHU2RPY4U=
`pragma protect data_method="aes256-cbc"
`pragma protect encoding=(enctype="base64", line_length=64, bytes=9024)
`pragma protect data_block
fnbxPAXw8BBFA81oxSLtvkaxByEea2jrqiKmZW2ig9LOWzM9tGUVabH1/MiDTyhz
onIFK5e52C/J5pf/WtjUj6k8EEM1RMuSDjkSMeZzna7MC45Zy4NlMyMqUB+BdxAQ
GZ2HEttctNqVBttDN6CsgJ+bI/a+frUuoSayhKsP7lx3HDY6DqnIZzPnXB8ZXs3A
qtAdsQmxMya4ipePpOaLlE4Jk8PtBCr6hAteuEXk1/aTFyJUpxVUjToWozy90pkQ
aC/j79K40ZdstlnhuA5njrdPlCed0oxknaG+j9XPC48HaNPBrCNkgVQ49HHNbtmH
6On6kIazMBBFwRhV8Of9SGNIt4MoJrh+GXcah6TyTs122zUv9TrbVzs6TZRiJHyz
Jx1Fikd63ri1846o8yU0ts+LcBX12cHJdD1EadV66UI3ne5vei0HiHwKi9Ae35kd
Fal7Z9B7dgCF15sz/jqVIGqVei49DY5sgoe+z5agpBzXVt+valafFcuEXXuG+uJm
U9ew2uHRKEosiurqdxe53qyJC/63KF3krlIQ5GpuM32M5EHW/OzVJMUMWPu5L8MS
PlsRmYq5EpueCwhRewF9yLpVqTo6WWRlJddijFFw6YV71MnmyNUjSvs4LN6Vmp+y
0Acd6Jt5Zm4gIy3Rx+w36rFOM98F98KPMVMpjpAHiUbanG8bz59nrxJyEuTDkRp+
umqN/aVe0/a662boHqmhfJkzafnYyYmsJg2g6GTExsDPje9xPTdH2mdm4ipaW7Gg
U2kLgKGv+TJC1+wjF/infvApMZFVhwsY4ArU8d7OrmN/QOMQKQTRiczcPGtyaQov
3viZ7cf1+2beNkFkCLg+1HlgqOpi2JhTSDDbw5jDupzxtxKE8yjFSr9Nj9IESQE2
C4WnQlI43hYz1plUezmHTBE7oB/kVj0/BRBD5vTPNUmKsXChAqImVDE8weFdaHXc
UfdgSCey6whZn9KoIBV+i0izDvzGZuxRKJEv7fLsoRYBrKWzyjWj1foEemood9S8
sX7VXFSZ+Q5lWorKo+UUECJo1p7vbotSzNGeL5wahCshCHao5Jju8G4iZweNz9rG
ts2xWQGSWZWSNZoCZo+4TbB0vpOPimlYuwYlYVSmPmy988sY6zkS41S0uZscquk7
6GyhyHyw6ucfMZUWhZKOH75VawQWomfXBtrUaS3RqjkW7pNVaNRySfxNSbyNGCni
rSUaLqoc/770kWCQihuIks0vFOKZG6PsdfcxOiKxwncMqklt+hGMmnVeCNElQ/Tq
r45I09RIkxgYABinWIwn5EJj7Q6LIHpXsTOZe2UlmWIGxzKB5iv4zYiksCSEvbwB
27epoRELL2+nIEKE2gOLILU8lIPYdpa3KpPWUnP0bdRhIe9FC1HDfsOPIAxQ9xLL
8iBD7b+R7PpUhft/NU0OruwigwGdHsWAUvcRNVLLICtUx5gKOKcNPUUNTezH9twH
2H5Hxjp6ySo9lBlNWdscajXCS3bIoWHcqcmiwSfJKeYpLRQHPGTiq4dlsNxJWdl7
m8psNwkyoZnxZ2odi8t1CU5FNTtmlTwRtbkuH904P0pR9LyRhi5A0XxqerOFEFw1
f0Lhz0fe2kDDxv8Lgi/v0qzRKPbZII1N6b3XzDegD6K7wWBMlxyBmwk5Wb9dp8Gk
3hJajifR+xLzL6I3N2mApE/E18BZfJXorPDGF15M+T0/d1UzahakdZdTURcWgub6
/33eJ2NZ5a2F8RKqJpfa4ZHmqpQSX7rDYhaq9XGXl/WXUidqoLKWg6mdHto62+16
uaiuj+FS1hrIkvhqROv0jVyZ/dVCAyyaHvRA+x85wMEqgjK+OGFQP9FKs/aMMElS
ulXdhFTq1R8ghcVZlcpXsRVnTbpRALn97/tJYnXFsBLJa4W7fN+4WFO807s8t6Na
OQ6o+lGk7Dq0JrR9yb6sxdINYjUqTEkEr7NNB5uYRvkCV+sgbT/Pixy30z+S0fgC
Uak3JnbDuMNVAwHjoFV+TasBaP7LpG3Nd0Ih4/x9pRlJqamDiI64iBvebgE6iXFh
AYOgiPTcfumHtWvWsKIkMiRQARCMI56quNjFcxNIYqLeiyj1BSTgofI/MpYzbsGw
1zXdxh1I6hvz6mWJ9Lo+p4qC0eNihYtSCW8VSrFa2Ja7jN9Rxn3uI7SnElwqzQ3A
lVJfwHAUb4aJ7v9u5/iXVnhZIW2deXFa250jv7s1O8HxBcdF1YnMGMOxnmt0cxxf
OWF3jeApau006RN/DN3qlennVYUNBGXXZDwGI7r6BWh6X9Mu2FcmbIisa94Zcrwx
2CylEYvjaiD3ZIe87/iQ1J9WrslyBjrlkAfCjlY72eUWzNvoqLNjjqj81NeBSSB3
z4Hkw9IMsGE+gp083wthivsJPuvKy/Ftp4ULuKDTAn/ho6BJG2kWjrfsdYHmcxMq
86AmTBENUTtcBk+a3qWcLXSIDYTW+Aca/fz4t19t5zFzcvvl9HAwLg9zpaUXUTjv
H9LowpTuOThQoR+MOkOCtruWbscCxLs9JXad9Xf/IgOxHjplOvfbddEhyVEQoNPJ
znKlYlNfHhbKGDBSqVkElYH+ZJu4/WexDzqCEKOvwF2eYa1WHLFrUy84LlBhRtxA
hJ7FepV66Jrc3Ner5jnhKuby6FLOPx78Jd2YMbcdb43O0cQa0mg6nDC7egmItP0X
HM1TfPsk8fgh2BmtnXLEb5rMdCQM1c71AvFgE/2gJFe4jDmUgEYMuMAgRXFREMV9
B/o9kH2MGP0nVtUlQuV0VZEEaKt3d3Qva6aoDjG+QmAy9iGt/gLMQb6ITBrxfZY9
alPcbX4hViUjnsQq3YvazEZQwwf6hXE/2tdmNDg4kDHNP+PKeZk82KNfskhnA6qz
FEy7IxFetLLG0c428m6+htbFGRyu7RLU/0KBd+rK7rIpK8QzN2pE4c4Yg1WGleMJ
2FU1M7CWDFIRYujutZXz+E76VGqdFlYfFNVUGI7nIvT3aDPb47Qxiw1hkw9VXHVf
xrRJr/D0aDaDVcRyTXUUsFKIlsEVPAH4w5dcacI53plnmjMtn1eQvtH5KdSBruY2
dGcFFS9Zpn9Q/UYxzGlOLfagu4zen34/GeGtFZgUrVukg6D0AF/VQ8MMRWCkCF8j
QNdQpnt3QLfGcrBF1xCs1GzXYsCQH8O+JqKkUOEeMUArY39Jlrltj0pL5JsV9qhZ
eVCfjTlMmdKPu2syJ1+yM5BdGGU60xfzDFJZskPdsbXZ8EvTL6i9zxM6dH3GwKiZ
CgS2LLABTNjvxxbbnCF/g1OdLq6TWP82aH9ClncH1kQJTGoLO0iesGuePe2s3V5i
SM4zav90DYFmy/AbdIzk0ATzXCynjjHGooVPpmbCsF94Sw2EBoJnL5u5C7NmMMRf
u4j566cSaL4ZojhzOYpIgMdEq2RSRvv80kVG5XNENxLeSNVG8p8dRsMNevWiKVoK
12R16JZguUgopIvfauIn9DGfiU9J7qT74sQp1u16bd1wp+iXkV8jFfDhC/mTABVM
Q2TQkgD2Vl5fu8Pz/zJLLjsIMlv5VMenkQry0baHlspUngXppsvmZhwxMY3ZQELc
NiKQe7hU0w1SI2dzVeGuZV9QMubfCL/IDo8apsH2QDPx3TfMREaUtDkNdpuL53Q9
lUETD1EnhUdBZaGlJQvkopXWEDlNDGFYB38KHF2ICu3awbRQuVb4TmwkKmmnx2cF
lXZqERWwaKL948oQAB2d0ex/zWMp4gGk5JSe+cQnCPdn007PYeS8WvLjJMbM28aM
uhc4M3sDlWqHMbHZ3C8+1pU0sDP0QWtfy5BTjjLz89PCSg3gmuO1NlzFFyfsK0fd
4p91UxR2wMbvKmnzSS5R3/jTzfXvvdvDEL+ArzKzOJnXcJgIIr7Yf1WRvNAIQFlf
KxLRLKBP3n2oIqkiCtVZhJdS49N0ZakZr3ikr0/bBPK4bzyW2AEai1XgPuUIpieO
uW0BjKTqU5DtKLzV2AHBY4LiO++KK2s8UM9aYIfgRPKdYed7lOYLeGa2UVgFh8Ng
efHWcu0C+IS4ZU0YhUqd4RoTyu6lxs9wpkvQRUL8TM4GE8BEVrUA6LwoQo7RAdVP
+WsRlDm/zs1p+AAgoH/SNIXXJ4utIT1XPLx+68u3wSKl/lGv4nOCmig44Oe8Wlcs
uXExT7KUL5lfROratr0eLPL2lWU/zHo9OwN2pXiYTiR/wHt2FkytyRBNwGMSLeXW
BBvgNbb0r8NKVnOJp8NDYHSJ0xgiiMLIyZVb6D9ZYrOyBhkE63E+89IAknihkqZo
YaqSrrelJlWmYc0bMNdrBRf8dkwkATwwy+xivdCktGqqaZYgjjxmYhLHM/JJsh9i
fNqEsMpZbOEP9XJXXzh7kBMOYRadDYuwIn/n7dGNXHxuE03T4CBMDePfNnU1ifVR
UM6nlX8ZecECvu9a+wn4v6GAvB+ZKQjZmdV9XtDzBCwMo3IHWa854npGLxe4uft2
jsot56HV4xZfFRhWrmBgCY1nTa1kYR8shCmUC6pfR5vG35z7bFItyOZQQwriCABX
i7fIlp3EoHgSJFkYmJpMhw9YGhM7X2NqYpViX2cudNQfLt1+PRPfNfRP/E5YW5iU
XLpRyrmAZMntXkA8EkdJoydmcNdoPiS/I4lJA/ZBk+YNS+hpynCPSVLKNiy9NAUZ
wjP22zOnavEJYQXJAskwiOB2PuknFP3VVH/bjM7AeraqH6fJAnTqp58jr1ZZxyZj
7ju+Jtv1UT3oSsDYH1zK5J1qdxtDdYsvXFEcxkPeDP9n5pkSE+1flRwrfqS5BUw9
cbIip0vtMjdu+u1RvwBwX79onzFlo0G+oF0kzsqGvCxK1HSlg9kXAj+AZxzmBIGr
blaqvoyZUgbYf6FC4Ag7ujBBxlA38+kqgqQitVWS5cpYSXI3pCyy/258Uxy/xDeu
B5Iz0XlY3TQjbDVztjtnsahF7Au1Wpt21FtGReV/AIcxdsYleUm9H2rZajUslXri
vrx5gKPbedMDJFewmivcltvVGFS7uxesjrpNbM1sYa5eOZw52vgfzYIrbJPsM1Dc
rjEyUWicZJ0+wzt9H0FCcf45ODpGZDw7Et69AEqRaxA3gOe0VeytpH+R+7YQPJe8
3I8E5gZ37/nVFDLJzdUJME5USVnnHgDJ4kfXNzqPfbpiHP8bRrXsk7AdSBUt/XRQ
PWWAIWKTaRk+PJMBoBBbR3PbCczUkr6AOPup5Qj67uDXqlhRsK0v7D35rTDGYoZ9
CHxC6ho0CQakofbpuhzRdIVPoIhc2qNh11Iud652RFpUhwJUt+tMsYJ7rP4IEcjl
+e65qrU9tK8j+rPjFr3ZKnWLFvvyXlmkUXZIzGkSSaCcWgSpiwtutbPC4gXbILIt
51kgZEqPU5N+rEA/3TVCIjIel47eZhQABLwuLdgMh8KQWnNu6tzfCyNpXAduR5aD
f3SOePAusDY4axny3YTLghCrVBV30qaN7VRplVUpfCqzvFqsX1sqZ4buss0NEp3P
NxBdvfI8Z/2L2p8OPWl05N4NYwVeO1jme5Axt+j9SNW2rgnwJyFGpqZb6WBsirL3
TTMMzJMfY+m7as1rxZIVZcfR+ZvYC1fZQTzTNp51fbVfxFc15e7oDDXON1TF7Z3g
DsdQRgq33umqfiDuFsSU65ExIkSh68yJ8KTQyLsSm4gkW5XIvxe7MLzmhgDVp8Cp
REpgOdR0oimTv8f6Y116TL8Po4KhgSZUvS58Z9VDV8ivEq5StFv1Ki/SKLb8hl2B
qSD2ieOTPMvT/kRFTRTa+P/bU/um+nfVw7/dV7uYoOMjRb0arkgThKrznIp1IXf3
dD1Vw3qK6lx0Gnd4YTw6umHzvWnPZ4l5cAdt4bffwGP6UJAAhhfwNUw4pKIFclhi
xH0Sc0nuMSi4sNI5Y9f7c6ZE8cGeOJck9Y+snFtory/cHfflTemXk+v/9CabPbLV
4jhfu3IJE3z3yQDYnxLA+rC/gM8AGjQcL4x+jMaK1+GDRiobtRId5KfTIwpEfPVO
Jm75+vlnACmIRRYJrGlQ6jhq50HRR2qLFo6Y67LS3cBif7Zgzm3BwICV3oaPMw/7
IUQY4+4K1kNT8ts5b9SGEZ2SRCzUx57XQspm1+UthX/09gdlU7LCqsXqkO86fadZ
Fe/K45zRjY1KimHizAZzqHKK+NpLYOOpJErMDxIGc8DKeLm99wEZ8Ct0Nd+S2OsW
jLHLzHHPE63SDZjG5lW3BlgNKC46v1BqfqN705DaGE/ml1IyUWSM/R8xja8AREAY
nN3zEsWJ32Ok3Gx+Ch6NzELT9vIQcYYTX8IUPdS9ooNoBAxeegY7k4KLpOpG/Hit
aMBVqMCBaNW8CTciVdFJl3ozwBINajE0yR/GTId4kdfw/G5msJ6bbsWbV61DGg/w
Ffy6VYMApoEdFgCCdcN/gzD38C0X7UNwMFPo/3jKUA/1RlhMdZp90UntmbS3qrp5
F0muokkyIJ4GC+l0fybmr+9gS3H16ipXQ62qZrqgQ8kV6c8xnx0dEIqv5ERh9aNh
TJGGZHGbf2YWTo4nYrj40nTsLT+TF4Xd3ktkgkTQ29a7YEglP6wabdiQ7krk60KN
sQbSi3Px+95VY1cdUoUBtpqixaHEpYC49/bGk0ytUvvdJ9CkI05Ah3fn7jFZcnAp
opwjEWMWfN8987JRDlhf1whiNOGoYJh6sjkzUvSTdwAsQJRTbHpeqf7KxUoCGT4l
sfkYSq7P78xBvjX6XF9IT7SYV6Fv2dO4Bxq8N98kOfHE7sJAFXdMCkOJYju/HMLo
9/Hg41Y4Ncljulq9t2BHRs87hsy2pS9DauZEi7DrFj7qS01u7eBG/sV8Pq6sSzpu
QFEUYsS7jDc4Fu01xsjcwX5wBVEaWgREJmAX1XcYQLjW4Vv4G3RN8P64gcWu8GQf
V9VTJMb5A2mSdA9mXO1TpeIG3w0Xba7ScqL+i1xE76upHR9Og4+Sd8ix3XMx+kfV
+rVvu74QBlowBTPrQYnsO7diT4HoSQzSnpWWsqRT6309zffEix9gv/9wn6PPeLD8
CcLiKVC6Fobi6TrfNT543nGsBky5KoFNXQXsNzOufnDaT9NZGFRuxz4uMTsyzecI
PPUYoV5BcUIJGxh+8ndpYCoKulq0trZc+NFmNeprI0S3+4TGtA1Nu9uaim9H81iy
Dskn1y46NUjREJI2F1+93nQ+U3vtXVIJMKJjrLJsxv9NxjCfGJDK2IoN0ZG+GaW1
E3Er1sJaq+wLcMtFnNOluI6HgZckiJ5z57HFayiZl5oFZeJ1FBj97MdHycPAZIhc
kqzynsQ58NV3/Hh3rpQqQkrjBqEodFP5Pf6x1VvJuUt28p2kJUL9LabBq+VlClPN
X0GyckvgpuuZFNY8zUrOgqmlHW7vUP6Pnuu7cnlIqzWvymro7pOrUOI8jLvC8m82
IJBtuNBsAC94/kGGDakj5OaW7jV4bPQzbQrVxdooeyPWGSsSwsC3MqJ4JK8G1Yv5
nnOzdM1zpkYMq9sUg7ArDPIvpIIA6BAk5TcaUzlsHwzBqHPkFanUupHtv26dV3Tg
e/XAid1edBwG6tEt73+AxvKOY+byzCjyhf+Hb52+p3SlcaKoCuP60HHByqpqYISr
g3MXRSF1cV5IuBVtMHaKN78NQb2QkiHk7Bp93Vrgru9a/wbJsupT7sLbEcxgwHb2
67QPKKMx4OWgMGrXWKMucFTluaEYM67tzA2ifnUGJrnUN1C3WgyocpfqZI+K6tab
X+yIqGPrBdXxuyFZ/hI5JclgXkiLKvprmlsLbmG1Ew/KPq48i2V5MuS4/pIPQxbJ
Wbd4xiC885leQHnqdOt1nLOozxUvV34CbxfvS06Z+HhlcOeq8bz7NnkwMSsd/VRM
r/g2tkV3oPWB6cgSlnV3jMTyrGhACBUcqZIRKXBlYs7uZgff6TTQn9b4aeSk2oeu
fI2mGUZVv9yZ3eMUsqq5zYBWeY/bL3UXx6JwWbDQkSV6Ik2Ubno+4o43pAYNgllt
9SokOm5TE/PuRAajUDpvedmlNhznK8umT5L2LRsUtlUqTLrT8M51MZPWpSMoauGC
5wynz5YiAjzLPeR6vdMj38futVcYBKnyYSClwmm+qW/58uVUvS9pz3tHfy16eagc
W/Hk2If4bP13BCO/+6MjI8NEEVIlZjIp8dV8oxRcaHvRByOBJnne/OXPtlUd3ep6
DSAP9crARNP0MjURumcHs8uV+QpZSaEOB30vcU7tkHzESzreq0JZtSvJr+VAsXLU
Vvi1AniRvsf0DIBm2ErDaLMuky6WhYhzliH/LGPho+ieGvSbARdDe0Zxws6GuJs9
mGAPxwwpRhH9UBLN7piSSD6h8Rgu/i97LwIeYepJxSXF7RWrkWXkCh7fn/5Odzf7
s+jMku8Smjlmg2FkbddeBm1vYmlmV9XW+0LiwRptuuKTcri+5Dd0ZHtfmOAgOQt8
92jIEqUxik+HB49d6XL5X3bnPzfbD3Jdte20KwL2T/9Bvk0fLjwQ7qE5hfYToR3U
RjwP1zqHDdqnCshdOQy28Hnfr9kTbDojWmWq3j16U4K8G4Slwo+t799IQELq//AZ
d7t/Te+PdVvXwp5LlauR1vo1KEoy3X/aylaeDkndbho9kk86n8Qul9MowUDd0OYI
IkMPq4o2hrK9UEeHSYkfzoX+3Y3GtFg11cJKeYcegizJGwCCb+uKbTHAA21/AEIU
fxa/VIDxmcd26958BwJgvO6gSQy4qMis8gOaIFwDLsUGGDQYgG2/XdWhbdprfamV
ssn68QHCbjE36Tqwuk/yIuIdUcuQVTWl7ceWIMBJNMIvmaAFWxtW1F65XTOunutF
5HCQ9xL/IqMBjzE4XJGtgZqWKFm48tYk8m/ERlAHGP0VrVuAqTt1TXB1P3N/XelQ
B21xpXkbNRfzP9wSIiJn1LNF1RMKFkiHkr3J7VfwwJeEX87yJ+C/gP3bQUcmyStq
egzUZ39E/w/NH6YSmVclG824bodAf4TsoUyaKpqvslQLRmDeAKomiiq7HhHWCYwa
frzAIExRBXbCbhB/cnNZLaOMIJCoXBjp2L50GytsR7s2lGri7wHDpDVp26FiVBO8
lPa3UkkmdT8PbTAE9fnUKyPydc5+scmCHtGS1Dcu3xCEjHOOb8zhQgvM9Uez3OOE
5lpElB31cm5zmQQT+AfhtDq6v0w7IZu4rG2SoneLrZKUJ5Rk73lxgY61nuJ6NkLH
L0XD1b13fk3lxwS824t19qM4nQMqB4LRYb3+rNVCO4x1nSDHrGbt7Q+H3AsqwH+V
gSpDPQ/6kkePDJKPKweZKKVVxr+zHoNgnow6cIEKhDYAOr7y3sh3iA4a3ySG5CFK
/BTszh/RNgpYfyO/gvHtBQ52jauCnVZBZJCi3sC1eVproDB39v/0tG/1NUgIfiWx
Yq82adpsK/2hP3k0lJ8ytakiMLbWr7no/0Zxayhyp5O7lbG/3cWf9l4DPt89J9qg
HOD4ew4/lWvu07J1IzRMWuRq9Kd+pkw7YHHyBl9Cwn2jCo27wHpxLmBtkLCC252Z
ntdbnxOJxW3dVcgDjr34MSolRqGAs29jIy/57iLOke8ZgEv4zl8Kayo5si+k585g
xI01SuSbFfQ/OdCusggFhDtZxRarYPx0dQqRnY78VD+TYjmGUbpC+/DS/LmkNC6m
+vbOVWv9aNrqqzZ/e3mb73OaU77LuOXLVu7XG/AyqnAroDm+FiGudva979nHBN/U
vzzRSpaOi2aUQURqAo52dBmz8961y5aS878jLvAYDwdf2kUE93Vg5Rv3sxxIlv2n
sTajWxNPZpz6evN4ggixN7nziMN/tD7wj6NAr/wpOGNxXr/8kv6luH25ZQurzA3o
Q+bonvVGCumPX1Vx5Pmx3tVgQH9w+TQec93aj8yVZdFQhAbtZ3toB0dk8oSrqpqy
YE82FuuUA4rHRnQBMKOYIZn1S91EqZzzoCVsCiFnt85KBz0yHnt0A3k5u0aOAZe1
0OrWHlDBoTH5tnZ27uLeNM8BQPFbjD6mLmwpsKY5NgIRsCqzboRGOTtkw/kthrf7
yt+Mzu3szJhaCSgClvoTET07R7lN3ii2zTjX2M9Qj1ZI52wt53KkVs9ASz4YtDCj
F9T+30USEqblZBUWg09am4glb/T5Gu1TGdOHDRuhw7ir94IOtrouAmbiayVWjIxI
skDi8hP6dtNrFj2zx5BhloEKPxg0IwUtjHGYkDaO6QxLVRtQmpNpxoNusqfe1+5O
iKBX1+L2IeCywhhxyhxcapXY9E5ZGCYjXtVBbVKlm6cFs8OpnFrk2/+xuoS0t93S
xSRFagNsgZxfFudy8eXlTldYerBurqTD9dJfrRigPEJBgAUupUXlygcGOiVtOIiR
wjSmKexN7M6/PmaDvhQqB6j8GAxAepo1Y3ZR2n0Nt8wTMWR39QXzO/RXxxe7SZEq
n+YVVDekzHjQ8ynguStEKLemSrtfhXyZPLC73mRn7Tmm4X+M+XgN371544zFgmEv
VObCMzOcapQx8ymdZT7I5HrPh7WMccybhlNkjm4Y/tRw2xauyjb2/QhxwOZykJnw
dQ1GMwT1QspKt2KBo+kxfoLEPZUjyzF/jdWqGX8Jhv8b37hZ8XpRZ+wL6qUSWj0S
4AguE5b3ko0N3gCcF+AYyWKgLgM7JretwaLb4wr1F0yL2MpoHNJff6YTy1SvVjvq
bOYzUSxskcquEtCkvQVJ7tq+6SEAW3RguglktaxUcnitf7gPIX/4lLYFsDQo7m1c
SmpPj0Pkdx77rquuB/MNur39WoMVhUJSTUdUzOaH5yfnp3bIYihGd+ThBeRlmr3k
rGGjsalXnMzHMT7Z+E2nAcBQM469C1dIsti1Cf7AFbHftDuXp0/jH9VPXO/JvKcI
KIgf5h5de9FiLarGvdO9waoV9mE2/8hyg8JBPejIkxIWQ7Qjlrb93QQl57sOjMoL
MbPSSZ3QkV4w9pPSB3ESY4cNJDlf9WG+8sjmJ6ySw7Yt4Djq6lVuAkMdd5I9B/De
JUwCa491GG8O0ZwH6517ikfEzVTZs1VzUHaHIoDdlsfT3daW5ZM3kWOCs4WgreDP
7Gm1Vu6aiXaspbWYxQgmbPYg9p7GgVoCP8bjnLTSBiXlXQHVkh07C+BkeOkYkDB7
f7BsoNEE5I6YwDudjKNNeEDvEZW0RHYxTWRCiwuT8tVwohIvuSFVgZI1fV5n/vQ6
cqGmIl+KS9E3rqwvugPo+X8H0GCh7lo6KTBjefrzCx/Nat1c5dxGIoyp7fBKsnaj
i01hl47je1TaTHVur6SIFZBFE/s44ZbJ3WtYucE2sd07zP/FZmg/RlrjUcD7HYmH
EukXuoOC93w74OIH/tYRr5k6xS7zLmhtbyLLMWToh5yQi0YjYWgH8fbv/azLgOdM
tJ3HzWEclPSpOe3tNJ7W3pGU2M2K62+E7aMtpQrKiJUzYYZJTPHIfO5ZaftXSE81
LjiWUWrl6/fEHxCApBNl9s1JvkaZK6P8gI/iUzXiwB9OiTUQar74iSreChfcQask
T5TMQ9L9SZMS8a9DX/5oGOO+fUWbB/Pxrg6a3s5HGOyt3wHrLhwG3RohWEbPptOS
8acigvw7gYcqC8X5JBSBUzdw2c9yMGd5ue50g6hQIRgBNCBNK3Ozo1cZSn1EX7Iz
cE0lY3x+NESkwmCZKGO4l+C1Jcj/cGVffUU/OvmXh1kLrflFokELh6Chd0H9yy1X
x0hm98pEY46RFrBCc/7FMtk+njZC0N0pK4fvuzEyBce+Sjx7FhSmBhYAtOwmlHjF
we45sX/MM3fZkRvXXp6v+o1OD++I0gqghpcOHcEqmPBThbHFtzqKNjnooGkAw6bQ
T5SmN8l6yheU4J9lky1HjP2Ex3yxtt21VavBF61C8PNglobOr1x3RK1aQhOysEHZ
iTo4ItFkasxOADg5sT5FHyHyS1ZLyaOgQg3xruU4KODgzmU6fYIQYAwgXovuV/HC
9a96kyhtWNZmxBMVDF3MXn+ZAOGu+PcVrNKo7MpgB0Wpufbpy7FTGJorbrMfHZoU
`pragma protect end_protected
endmodule
