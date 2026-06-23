`define IP_UUID _449a7b9bfbac46b2a2d60d871e2fb598
`define IP_NAME_CONCAT(a,b) a``b
`define IP_MODULE_NAME(name) `IP_NAME_CONCAT(name,`IP_UUID)

module efx_mac10gbe_exp_apb_halt # (
	parameter CNT_HALT1	= 6,
	parameter CNT_HALT2	= 12
) (
	input  logic pclk_i, //200Mhz
	input  logic presetn_i,
	input  logic pready_i,
	input  logic irq1_i,
	input  logic irq2_i,

	output logic apb_halt_o
);

`IP_MODULE_NAME(efx_mac10gbe_exp_apb_halt)# (
	.CNT_HALT1(CNT_HALT1),
	.CNT_HALT2(CNT_HALT2)
) inst_apb_halt (
	.pclk_i(pclk_i), //200Mhz
	.presetn_i(presetn_i),
	.pready_i(pready_i),
	.irq1_i(irq1_i),
	.irq2_i(irq2_i),

	.apb_halt_o(apb_halt_o)
);

endmodule

//pragma protect
//pragma protect begin

/* Encryption Envelope */

`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "QuestaSim" , encrypt_agent_info = "2021.1"
`pragma protect key_keyowner = "Efinix Inc." , key_keyname = "EFX_K01"
`pragma protect key_method = "rsa"
`pragma protect encoding = ( enctype = "base64" , line_length = 64 , bytes = 256 )
`pragma protect key_block
F+tPZr1ttfTkk/Ewm//UcHY0TZg3FXmQzoWr710oWkbt5z70I2aTxQMuHNbBeHmb
gQnbIrVuOURfT5hnnPZ41OkY8UtpcOrrh3MceWuuQtxSKTs2DdyRp2D+oxwPXUOF
wOqKjnqgIQiFeaZe/wLXCJhQHMaq1FsZakE54n+bINiTD5NW0MjRqiYvbc5BzvCn
rXBU6BE6e+DN9vyx3Cb7DILeGdSSyOTfc7vKJkLdO6y+jJyJEIRyTEhgEDS1NtDB
HrFVGHmZUFyW99JAAPLkz9iBXH/ME4CJZXvv/Nh67RyQ0TbgWXhVzbI3PxaDeAD0
cKSFMqzhdBrvo6R5eQSnwg==
`pragma protect data_method = "aes256-cbc"
`pragma protect encoding = ( enctype = "base64" , line_length = 64 , bytes = 928 )
`pragma protect data_block
o2YSb3xJEjNS4L7sn+nxt1L/GrK6rdVkh/ZLugawih1qyCqz2LOxhMA3zdBr0JSo
8pU2rI4RDgh4THLt/2hVoZSCuB63ZJ1/8CfedNrz9s9wefA2aGuWfAU1vvUgmLXc
MmunHc2SYgjp/1f2FSABs/izRMmg2SeoNKeyRM3QPIu3xmyH6Ki+shgHXTCgtRhc
GtP/wpUZ+pWyVigb6aL9l5/64ljUjMghGFmXAZKxmgSxHSwFPHyk315Mpbb08Kls
ngtO6dgpLuEaWI0MzWiDc7nL1oAHr+sCtn7k+tN+CCPkpq/SF5MPCouEiwbUvKm0
6iNF/qxncrgE20GOjwexXWGow2hU4c49DsATXwOv4STfs3+8tfNQKHVEh1uv0zdb
bujhwOb7XlX+y08FjbVmpMJr/OI7bPQqWbwbQwQHxbplzXQG3lsc8a396qg3RBRl
VzgceJca2sAfhsfiK7nzGs1yYP8/bgA/Ji9KRDK/+f/R7qE98oZBXsy+helS7TOb
UNVZsYCLNJX4wfii3d1HWOpt8tP4Ica8YyqRvc2Mkq27DnmF1x2/eBPwDpcAdqhb
InwHtYFUR2PFSNAULqhihIS4MiTfo6gY8+wfJNJx2CYZJA2BpqxL0hf5DahIzhOK
ONEijUZo1wiK/PdgBmnNgttN0rXzuscSBbktihG3fNM0f+CMAGe7f3YffjdZI/3l
tBCSLDQ2XkiVp85ooWcCuy6862wG5tbXNegCoB7gmHSwfC51n5WQLpg7B6UQKarG
I0IGXjo+TCbPBEkQmd5hQ4uXBIuw21Glk/415/1GbiqOCcghqTpOSABEMzwgvhNv
0SqBp+1eBEpysY3f6RPrbBIVlHaQrnGQ6RWgzAhlKc8JVmvU0KEMFd0UIDD1P9LU
YUbs3sn7klm/nUNFVm+AOlvXksQLZNR00NdziFVHpCspN64FeLmjDodB/BNvJSui
93YqEVp3fuLFOEswQFeTa84ohXfj9SSsgcsHc0s2d9YGdbfWzdl73SHC71QJesHH
czTEGdQjnoywFp27zd0Q7MHGYQxZhbnWqDJO775izvutJY+xprrZ7m/Eef5ZxUb2
xXNNkRrQtMGtLnyihxF4E52XOU3Hq2n3gwIB22lSp9oS9Gcn2s3sronzv7smxQL3
Ze15uIjpbqN+Akn7ftp4IgX8pRmeuZ+id5m88F3x3pElx6EaX6DORxJOtV4F6XFp
iO+mkwniPGgaA687whB/7g==
`pragma protect end_protected

//pragma protect end

`undef IP_UUID
`undef IP_NAME_CONCAT
`undef IP_MODULE_NAME