module CRC_chk (
input   wire                    Clk            ,
input   wire                    Clk_en         ,
input   wire                    Reset          ,
input   wire                    Init           ,
input                           crc_fwd,
input   wire                    Data_en        ,
input   wire                    Data_eop       ,
input   wire    [63:0]          Frame_data     ,
input   wire    [7:0]           Data_strb      ,

output  reg                     Frame_en_o     ,
output  reg     [63:0]          Frame_data_o   ,
output  reg     [7:0]           Frame_strb_o   ,
output  reg                     Frame_eop_o    ,

output  reg                     CRC_err        ,
output  reg                     CRC_err_en     

);

//******************************************************************************   
//internal signals                                                              
//******************************************************************************
wire [63:0]   Frame_data_w;
wire [31:0]   CRC_reg_w;
reg [31:0]      CRC_reg;
reg [31:0]      CRC_src;
reg                             crc_fwd_dl1;
reg                             crc_fwd_en;
reg  [7:0]    CRC_ena;
reg  [63:0]   CRC_eop_data;
reg  [31:0]   CRC_reg_out;
reg  [63:0]   Frame_data_d1=0;
reg  [63:0]   Frame_data_d2=0;
reg  [63:0]   Frame_data_d3=0;
reg  [63:0]   Frame_data_d4=0;
reg  [63:0]   Frame_data_d5=0;
reg  [63:0]   Frame_data_d6=0;
reg  [63:0]   Frame_data_d7=0;
reg  [63:0]   Frame_data_d8=0;
reg  [7:0]    Data_strb_d1=0;
reg  [7:0]    Data_strb_d2=0;
reg  [7:0]    Data_strb_d3=0;
reg  [7:0]    Data_strb_d4=0;
reg  [7:0]    Data_strb_d5=0;
reg  [7:0]    Data_strb_d6=0;
reg  [7:0]    Data_strb_d7=0;
reg  [7:0]    Data_strb_d8=0;
reg  [7:0]    Data_strb_d9=0;
reg           Data_en_d1=0;
reg           Data_en_d2=0;
reg           Data_en_d3=0;
reg           Data_en_d4=0;
reg           Data_en_d5=0;
reg           Data_en_d6=0;
reg           Data_en_d7=0;
reg           Data_en_d8=0;
reg           Data_eop_extend;
reg           Data_eop_extend_d1=0;
reg           Data_eop_extend_d2=0;
reg           Data_eop_extend_d3=0;
reg           Data_eop_extend_d4=0;
reg           Data_eop_extend_d5=0;
reg           Data_eop_extend_d6=0;
reg           Data_eop_extend_d7=0;
reg           Data_eop_extend_d8=0;
reg           Data_eop_d1=0;
reg           Data_eop_d2=0;
reg           Data_eop_d3=0;
reg           Data_eop_d4=0;
reg           Data_eop_d5=0;
reg           Data_eop_d6=0;
reg           Data_eop_d7=0;
reg           Data_eop_d8=0;

//******************************************************************************
//******************************************************************************
//******************************************************************************
//Encryption begin
genvar i ,j;
generate
for(i=0;i<64;i=i+1)begin
    assign Frame_data_w[63-i] = Frame_data[i];
end    
endgenerate

always @ (posedge Clk or posedge Reset)
begin
    if (Reset)
        CRC_reg     <=32'hffffffff;
    else if (!Clk_en)
        CRC_reg     <=CRC_reg;
    else if (Init)
        CRC_reg     <=32'hffffffff;
    else if (Data_en && (!Data_eop || (Data_eop && Data_strb == 8'hff)))
        CRC_reg     <=crc(Frame_data,CRC_reg);
    else; 
end

always @ (posedge Clk or posedge Reset)
begin
    if (Reset)
        CRC_ena     <=8'b0;
    else if (!Clk_en)
        CRC_ena     <=CRC_ena;
    else if (Data_en & Data_eop)
        CRC_ena     <=Data_strb;
    else if (CRC_ena != 0)
        CRC_ena     <=CRC_ena >> 1;
end

always @ (posedge Clk or posedge Reset)
begin
    if (Reset)
        CRC_eop_data     <=64'b0;
    else if (!Clk_en)
        CRC_eop_data     <=CRC_eop_data;
    else if (Data_en & Data_eop)
        CRC_eop_data     <=Frame_data;
    else if (CRC_ena != 0)
        CRC_eop_data     <=CRC_eop_data >> 8;
end

always @ (posedge Clk or posedge Reset)
begin
    if (Reset)
        CRC_reg_out     <=32'hffffffff;
    else if (!Clk_en)
        CRC_reg_out     <=CRC_reg_out;
    else if (Data_en & Data_eop)
        CRC_reg_out     <=CRC_reg;        
    else if (CRC_ena != 0)
        CRC_reg_out     <=crc_d8(CRC_eop_data[7:0],CRC_reg_out);
end



// C704DD7B
always @ (posedge Clk or posedge Reset)
begin
    if (Reset)
        Data_eop_extend     <=1'b0;
    else if (!Clk_en)
        Data_eop_extend     <=Data_eop_extend;
    else if (Data_en && Data_eop && Data_strb <=8'b00001111)
        Data_eop_extend     <=1'b1;        
    else 
        Data_eop_extend     <=1'b0;
end

always @ (posedge Clk )
begin
    Data_en_d1 <= Data_en ;
    Data_en_d2 <= Data_en_d1;
    Data_en_d3 <= Data_en_d2;
    Data_en_d4 <= Data_en_d3;
    Data_en_d5 <= Data_en_d4;
    Data_en_d6 <= Data_en_d5;
    Data_en_d7 <= Data_en_d6;
    Data_en_d8 <= Data_en_d7;

    Data_strb_d1 <= Data_strb;
    Data_strb_d2 <= Data_strb_d1;
    Data_strb_d3 <= Data_strb_d2;
    Data_strb_d4 <= Data_strb_d3;
    Data_strb_d5 <= Data_strb_d4;
    Data_strb_d6 <= Data_strb_d5;
    Data_strb_d7 <= Data_strb_d6;
    Data_strb_d8 <= Data_strb_d7;
    Data_strb_d9 <= Data_strb_d8;
    
    Frame_data_d1 <= Frame_data;
    Frame_data_d2 <= Frame_data_d1;
    Frame_data_d3 <= Frame_data_d2;
    Frame_data_d4 <= Frame_data_d3;
    Frame_data_d5 <= Frame_data_d4;
    Frame_data_d6 <= Frame_data_d5;
    Frame_data_d7 <= Frame_data_d6;
    Frame_data_d8 <= Frame_data_d7;
    
    Data_eop_extend_d1 <= Data_eop_extend;
    Data_eop_extend_d2 <= Data_eop_extend_d1;
    Data_eop_extend_d3 <= Data_eop_extend_d2;
    Data_eop_extend_d4 <= Data_eop_extend_d3;
    Data_eop_extend_d5 <= Data_eop_extend_d4;
    Data_eop_extend_d6 <= Data_eop_extend_d5;
    Data_eop_extend_d7 <= Data_eop_extend_d6;
    Data_eop_extend_d8 <= Data_eop_extend_d7;  

    Data_eop_d1 <= Data_eop;
    Data_eop_d2 <= Data_eop_d1;
    Data_eop_d3 <= Data_eop_d2;
    Data_eop_d4 <= Data_eop_d3;
    Data_eop_d5 <= Data_eop_d4;
    Data_eop_d6 <= Data_eop_d5;
    Data_eop_d7 <= Data_eop_d6;
    Data_eop_d8 <= Data_eop_d7;      
end

always @(posedge Clk or negedge Reset)
begin
    if(Reset == 1'b1)
        begin
            crc_fwd_dl1 <= 1'h0;
            crc_fwd_en <= 1'h0;
        end
    else
        begin
            crc_fwd_dl1 <= crc_fwd;
            crc_fwd_en <= !crc_fwd_dl1;
        end
end
 
generate
for(j=0;j<32;j=j+1)
    assign CRC_reg_w[31-j] = CRC_reg_out[j];
endgenerate

always @ (posedge Clk or posedge Reset)
begin
    if (Reset)
        Frame_en_o     <=1'b0;
    else if (!Clk_en)
        Frame_en_o     <=Frame_en_o;
    else if(crc_fwd_en)
        Frame_en_o     <=  Data_en_d8 & (!(Data_eop_extend_d7 | Data_eop_extend_d8));
    else    
        Frame_en_o     <=Data_en_d8;
end
        
always @ (posedge Clk or posedge Reset)
begin
    if (Reset)
        Frame_data_o     <=64'b0;
    else if (!Clk_en)
        Frame_data_o     <=Frame_data_o;
    else if(Data_eop_d8 & crc_fwd_en)
    begin
        case(Data_strb_d8)
            8'b0000_0001 : Frame_data_o <= 64'h0;
            8'b0000_0011 : Frame_data_o <= 64'h0;
            8'b0000_0111 : Frame_data_o <= 64'h0;
            8'b0000_1111 : Frame_data_o <= 64'h0;
            8'b0001_1111 : Frame_data_o <= {56'b0,Frame_data_d8[1*8-1:0]};
            8'b0011_1111 : Frame_data_o <= {48'b0,Frame_data_d8[2*8-1:0]};
            8'b0111_1111 : Frame_data_o <= {40'b0,Frame_data_d8[3*8-1:0]};
            8'b1111_1111 : Frame_data_o <= {32'h0,Frame_data_d8[4*8-1:0]};
            default      : Frame_data_o <=        Frame_data_d8[8*8-1:0];
        endcase
    end 
    else if(Data_eop_extend_d6 & crc_fwd_en)
    begin
        case(Data_strb_d7)
            8'b0000_0001 : Frame_data_o <= {24'b0,Frame_data_d8[5*8-1:0]};
            8'b0000_0011 : Frame_data_o <= {16'b0,Frame_data_d8[6*8-1:0]};
            8'b0000_0111 : Frame_data_o <= {8'b0, Frame_data_d8[7*8-1:0]};
            8'b0000_1111 : Frame_data_o <=        Frame_data_d8[8*8-1:0];
            default      : Frame_data_o <=        Frame_data_d8[8*8-1:0];
        endcase
    end   
    else    
        Frame_data_o     <= Frame_data_d8;
end        
        
always @ (posedge Clk or posedge Reset)
begin
    if (Reset)
        Frame_strb_o     <=8'b0;
    else if (!Clk_en)
        Frame_strb_o     <=Frame_strb_o;
    else if(Data_eop_d8 & crc_fwd_en)
    begin
        case(Data_strb_d8)
            8'b0001_1111 : Frame_strb_o <= 8'b0000_0001;
            8'b0011_1111 : Frame_strb_o <= 8'b0000_0011;
            8'b0111_1111 : Frame_strb_o <= 8'b0000_0111;
            8'b1111_1111 : Frame_strb_o <= 8'b0000_1111;        
            default      : Frame_strb_o <= 8'b0000_0000;
        endcase
    end 
    else if(Data_eop_extend_d6 & crc_fwd_en)
    begin
        case(Data_strb_d7)
            8'b0000_0001 : Frame_strb_o <= 8'b0001_1111;
            8'b0000_0011 : Frame_strb_o <= 8'b0011_1111;
            8'b0000_0111 : Frame_strb_o <= 8'b0111_1111;
            8'b0000_1111 : Frame_strb_o <= 8'b1111_1111;
            default      : Frame_strb_o <= 8'b1111_1111;
        endcase
    end           
    else 
        Frame_strb_o     <=  Data_strb_d8;
end        

always @ (posedge Clk or posedge Reset)
begin
    if (Reset)
        Frame_eop_o     <=1'b0;
    else if (!Clk_en)
        Frame_eop_o     <=Frame_eop_o;
    else if(crc_fwd_en & (Data_eop_extend_d6 | Data_eop_extend_d7))
        Frame_eop_o     <= Data_eop_d7 ;
    else    
        Frame_eop_o     <= Data_eop_d8 ;
end

always @ (posedge Clk or posedge Reset)
begin
    if (Reset)
        CRC_err_en     <=1'b0;
    else if (!Clk_en)
        CRC_err_en     <= CRC_err_en;
    else 
        CRC_err_en     <= Frame_eop_o ;
end

always @ (posedge Clk or posedge Reset)
begin
    if (Reset)
        CRC_err     <= 1'b0;
    else if (Frame_eop_o && CRC_reg_w != 32'hC704DD7B)  
        CRC_err     <= 1'b1;
    else
        CRC_err     <= 1'b0;
end

//******************************************************************************
//******************************************************************************
//input data width is 8bit, and the first bit is bit[0]
function[31:0]  NextCRC;
    input[7:0]      D;
    input[31:0]     C;
    reg[31:0]       NewCRC;
    begin
    NewCRC[0]=C[24]^C[30]^D[1]^D[7];
    NewCRC[1]=C[25]^C[31]^D[0]^D[6]^C[24]^C[30]^D[1]^D[7];
    NewCRC[2]=C[26]^D[5]^C[25]^C[31]^D[0]^D[6]^C[24]^C[30]^D[1]^D[7];
    NewCRC[3]=C[27]^D[4]^C[26]^D[5]^C[25]^C[31]^D[0]^D[6];
    NewCRC[4]=C[28]^D[3]^C[27]^D[4]^C[26]^D[5]^C[24]^C[30]^D[1]^D[7];
    NewCRC[5]=C[29]^D[2]^C[28]^D[3]^C[27]^D[4]^C[25]^C[31]^D[0]^D[6]^C[24]^C[30]^D[1]^D[7];
    NewCRC[6]=C[30]^D[1]^C[29]^D[2]^C[28]^D[3]^C[26]^D[5]^C[25]^C[31]^D[0]^D[6];
    NewCRC[7]=C[31]^D[0]^C[29]^D[2]^C[27]^D[4]^C[26]^D[5]^C[24]^D[7];
    NewCRC[8]=C[0]^C[28]^D[3]^C[27]^D[4]^C[25]^D[6]^C[24]^D[7];
    NewCRC[9]=C[1]^C[29]^D[2]^C[28]^D[3]^C[26]^D[5]^C[25]^D[6];
    NewCRC[10]=C[2]^C[29]^D[2]^C[27]^D[4]^C[26]^D[5]^C[24]^D[7];
    NewCRC[11]=C[3]^C[28]^D[3]^C[27]^D[4]^C[25]^D[6]^C[24]^D[7];
    NewCRC[12]=C[4]^C[29]^D[2]^C[28]^D[3]^C[26]^D[5]^C[25]^D[6]^C[24]^C[30]^D[1]^D[7];
    NewCRC[13]=C[5]^C[30]^D[1]^C[29]^D[2]^C[27]^D[4]^C[26]^D[5]^C[25]^C[31]^D[0]^D[6];
    NewCRC[14]=C[6]^C[31]^D[0]^C[30]^D[1]^C[28]^D[3]^C[27]^D[4]^C[26]^D[5];
    NewCRC[15]=C[7]^C[31]^D[0]^C[29]^D[2]^C[28]^D[3]^C[27]^D[4];
    NewCRC[16]=C[8]^C[29]^D[2]^C[28]^D[3]^C[24]^D[7];
    NewCRC[17]=C[9]^C[30]^D[1]^C[29]^D[2]^C[25]^D[6];
    NewCRC[18]=C[10]^C[31]^D[0]^C[30]^D[1]^C[26]^D[5];
    NewCRC[19]=C[11]^C[31]^D[0]^C[27]^D[4];
    NewCRC[20]=C[12]^C[28]^D[3];
    NewCRC[21]=C[13]^C[29]^D[2];
    NewCRC[22]=C[14]^C[24]^D[7];
    NewCRC[23]=C[15]^C[25]^D[6]^C[24]^C[30]^D[1]^D[7];
    NewCRC[24]=C[16]^C[26]^D[5]^C[25]^C[31]^D[0]^D[6];
    NewCRC[25]=C[17]^C[27]^D[4]^C[26]^D[5];
    NewCRC[26]=C[18]^C[28]^D[3]^C[27]^D[4]^C[24]^C[30]^D[1]^D[7];
    NewCRC[27]=C[19]^C[29]^D[2]^C[28]^D[3]^C[25]^C[31]^D[0]^D[6];
    NewCRC[28]=C[20]^C[30]^D[1]^C[29]^D[2]^C[26]^D[5];
    NewCRC[29]=C[21]^C[31]^D[0]^C[30]^D[1]^C[27]^D[4];
    NewCRC[30]=C[22]^C[31]^D[0]^C[28]^D[3];
    NewCRC[31]=C[23]^C[29]^D[2];
    NextCRC=NewCRC;
    end
endfunction
//******************************************************************************
//******************************************************************************
// convention: the first serial bit is D[0]
function automatic [31:0] crc;
    input [63:0] data;
    input [31:0] crcIn;

begin
    crc[0] = crcIn[1] ^ crcIn[3] ^ crcIn[4] ^ crcIn[6] ^ crcIn[9] ^ crcIn[10] ^ crcIn[11] ^ crcIn[14] ^ crcIn[16] ^ crcIn[17] ^ crcIn[19] ^ crcIn[20] ^ crcIn[27] ^ crcIn[30] ^ data[1] ^ data[3] ^ data[4] ^ data[6] ^ data[9] ^ data[10] ^ data[11] ^ data[14] ^ data[16] ^ data[17] ^ data[19] ^ data[20] ^ data[27] ^ data[30] ^ data[32] ^ data[33] ^ data[34] ^ data[35] ^ data[36] ^ data[38] ^ data[39] ^ data[40] ^ data[48] ^ data[52] ^ data[54] ^ data[55] ^ data[58];
    crc[1] = crcIn[0] ^ crcIn[2] ^ crcIn[4] ^ crcIn[5] ^ crcIn[7] ^ crcIn[10] ^ crcIn[11] ^ crcIn[12] ^ crcIn[15] ^ crcIn[17] ^ crcIn[18] ^ crcIn[20] ^ crcIn[21] ^ crcIn[28] ^ crcIn[31] ^ data[0] ^ data[2] ^ data[4] ^ data[5] ^ data[7] ^ data[10] ^ data[11] ^ data[12] ^ data[15] ^ data[17] ^ data[18] ^ data[20] ^ data[21] ^ data[28] ^ data[31] ^ data[33] ^ data[34] ^ data[35] ^ data[36] ^ data[37] ^ data[39] ^ data[40] ^ data[41] ^ data[49] ^ data[53] ^ data[55] ^ data[56] ^ data[59];
    crc[2] = crcIn[0] ^ crcIn[1] ^ crcIn[3] ^ crcIn[5] ^ crcIn[6] ^ crcIn[8] ^ crcIn[11] ^ crcIn[12] ^ crcIn[13] ^ crcIn[16] ^ crcIn[18] ^ crcIn[19] ^ crcIn[21] ^ crcIn[22] ^ crcIn[29] ^ data[0] ^ data[1] ^ data[3] ^ data[5] ^ data[6] ^ data[8] ^ data[11] ^ data[12] ^ data[13] ^ data[16] ^ data[18] ^ data[19] ^ data[21] ^ data[22] ^ data[29] ^ data[32] ^ data[34] ^ data[35] ^ data[36] ^ data[37] ^ data[38] ^ data[40] ^ data[41] ^ data[42] ^ data[50] ^ data[54] ^ data[56] ^ data[57] ^ data[60];
    crc[3] = crcIn[0] ^ crcIn[1] ^ crcIn[2] ^ crcIn[4] ^ crcIn[6] ^ crcIn[7] ^ crcIn[9] ^ crcIn[12] ^ crcIn[13] ^ crcIn[14] ^ crcIn[17] ^ crcIn[19] ^ crcIn[20] ^ crcIn[22] ^ crcIn[23] ^ crcIn[30] ^ data[0] ^ data[1] ^ data[2] ^ data[4] ^ data[6] ^ data[7] ^ data[9] ^ data[12] ^ data[13] ^ data[14] ^ data[17] ^ data[19] ^ data[20] ^ data[22] ^ data[23] ^ data[30] ^ data[33] ^ data[35] ^ data[36] ^ data[37] ^ data[38] ^ data[39] ^ data[41] ^ data[42] ^ data[43] ^ data[51] ^ data[55] ^ data[57] ^ data[58] ^ data[61];
    crc[4] = crcIn[0] ^ crcIn[1] ^ crcIn[2] ^ crcIn[3] ^ crcIn[5] ^ crcIn[7] ^ crcIn[8] ^ crcIn[10] ^ crcIn[13] ^ crcIn[14] ^ crcIn[15] ^ crcIn[18] ^ crcIn[20] ^ crcIn[21] ^ crcIn[23] ^ crcIn[24] ^ crcIn[31] ^ data[0] ^ data[1] ^ data[2] ^ data[3] ^ data[5] ^ data[7] ^ data[8] ^ data[10] ^ data[13] ^ data[14] ^ data[15] ^ data[18] ^ data[20] ^ data[21] ^ data[23] ^ data[24] ^ data[31] ^ data[34] ^ data[36] ^ data[37] ^ data[38] ^ data[39] ^ data[40] ^ data[42] ^ data[43] ^ data[44] ^ data[52] ^ data[56] ^ data[58] ^ data[59] ^ data[62];
    crc[5] = crcIn[1] ^ crcIn[2] ^ crcIn[3] ^ crcIn[4] ^ crcIn[6] ^ crcIn[8] ^ crcIn[9] ^ crcIn[11] ^ crcIn[14] ^ crcIn[15] ^ crcIn[16] ^ crcIn[19] ^ crcIn[21] ^ crcIn[22] ^ crcIn[24] ^ crcIn[25] ^ data[1] ^ data[2] ^ data[3] ^ data[4] ^ data[6] ^ data[8] ^ data[9] ^ data[11] ^ data[14] ^ data[15] ^ data[16] ^ data[19] ^ data[21] ^ data[22] ^ data[24] ^ data[25] ^ data[32] ^ data[35] ^ data[37] ^ data[38] ^ data[39] ^ data[40] ^ data[41] ^ data[43] ^ data[44] ^ data[45] ^ data[53] ^ data[57] ^ data[59] ^ data[60] ^ data[63];
    crc[6] = crcIn[1] ^ crcIn[2] ^ crcIn[5] ^ crcIn[6] ^ crcIn[7] ^ crcIn[11] ^ crcIn[12] ^ crcIn[14] ^ crcIn[15] ^ crcIn[19] ^ crcIn[22] ^ crcIn[23] ^ crcIn[25] ^ crcIn[26] ^ crcIn[27] ^ crcIn[30] ^ data[1] ^ data[2] ^ data[5] ^ data[6] ^ data[7] ^ data[11] ^ data[12] ^ data[14] ^ data[15] ^ data[19] ^ data[22] ^ data[23] ^ data[25] ^ data[26] ^ data[27] ^ data[30] ^ data[32] ^ data[34] ^ data[35] ^ data[41] ^ data[42] ^ data[44] ^ data[45] ^ data[46] ^ data[48] ^ data[52] ^ data[55] ^ data[60] ^ data[61];
    crc[7] = crcIn[0] ^ crcIn[2] ^ crcIn[3] ^ crcIn[6] ^ crcIn[7] ^ crcIn[8] ^ crcIn[12] ^ crcIn[13] ^ crcIn[15] ^ crcIn[16] ^ crcIn[20] ^ crcIn[23] ^ crcIn[24] ^ crcIn[26] ^ crcIn[27] ^ crcIn[28] ^ crcIn[31] ^ data[0] ^ data[2] ^ data[3] ^ data[6] ^ data[7] ^ data[8] ^ data[12] ^ data[13] ^ data[15] ^ data[16] ^ data[20] ^ data[23] ^ data[24] ^ data[26] ^ data[27] ^ data[28] ^ data[31] ^ data[33] ^ data[35] ^ data[36] ^ data[42] ^ data[43] ^ data[45] ^ data[46] ^ data[47] ^ data[49] ^ data[53] ^ data[56] ^ data[61] ^ data[62];
    crc[8] = crcIn[1] ^ crcIn[3] ^ crcIn[4] ^ crcIn[7] ^ crcIn[8] ^ crcIn[9] ^ crcIn[13] ^ crcIn[14] ^ crcIn[16] ^ crcIn[17] ^ crcIn[21] ^ crcIn[24] ^ crcIn[25] ^ crcIn[27] ^ crcIn[28] ^ crcIn[29] ^ data[1] ^ data[3] ^ data[4] ^ data[7] ^ data[8] ^ data[9] ^ data[13] ^ data[14] ^ data[16] ^ data[17] ^ data[21] ^ data[24] ^ data[25] ^ data[27] ^ data[28] ^ data[29] ^ data[32] ^ data[34] ^ data[36] ^ data[37] ^ data[43] ^ data[44] ^ data[46] ^ data[47] ^ data[48] ^ data[50] ^ data[54] ^ data[57] ^ data[62] ^ data[63];
    crc[9] = crcIn[1] ^ crcIn[2] ^ crcIn[3] ^ crcIn[5] ^ crcIn[6] ^ crcIn[8] ^ crcIn[11] ^ crcIn[15] ^ crcIn[16] ^ crcIn[18] ^ crcIn[19] ^ crcIn[20] ^ crcIn[22] ^ crcIn[25] ^ crcIn[26] ^ crcIn[27] ^ crcIn[28] ^ crcIn[29] ^ data[1] ^ data[2] ^ data[3] ^ data[5] ^ data[6] ^ data[8] ^ data[11] ^ data[15] ^ data[16] ^ data[18] ^ data[19] ^ data[20] ^ data[22] ^ data[25] ^ data[26] ^ data[27] ^ data[28] ^ data[29] ^ data[32] ^ data[34] ^ data[36] ^ data[37] ^ data[39] ^ data[40] ^ data[44] ^ data[45] ^ data[47] ^ data[49] ^ data[51] ^ data[52] ^ data[54] ^ data[63];
    crc[10] = crcIn[1] ^ crcIn[2] ^ crcIn[7] ^ crcIn[10] ^ crcIn[11] ^ crcIn[12] ^ crcIn[14] ^ crcIn[21] ^ crcIn[23] ^ crcIn[26] ^ crcIn[28] ^ crcIn[29] ^ data[1] ^ data[2] ^ data[7] ^ data[10] ^ data[11] ^ data[12] ^ data[14] ^ data[21] ^ data[23] ^ data[26] ^ data[28] ^ data[29] ^ data[32] ^ data[34] ^ data[36] ^ data[37] ^ data[39] ^ data[41] ^ data[45] ^ data[46] ^ data[50] ^ data[53] ^ data[54] ^ data[58];
    crc[11] = crcIn[2] ^ crcIn[3] ^ crcIn[8] ^ crcIn[11] ^ crcIn[12] ^ crcIn[13] ^ crcIn[15] ^ crcIn[22] ^ crcIn[24] ^ crcIn[27] ^ crcIn[29] ^ crcIn[30] ^ data[2] ^ data[3] ^ data[8] ^ data[11] ^ data[12] ^ data[13] ^ data[15] ^ data[22] ^ data[24] ^ data[27] ^ data[29] ^ data[30] ^ data[33] ^ data[35] ^ data[37] ^ data[38] ^ data[40] ^ data[42] ^ data[46] ^ data[47] ^ data[51] ^ data[54] ^ data[55] ^ data[59];
    crc[12] = crcIn[3] ^ crcIn[4] ^ crcIn[9] ^ crcIn[12] ^ crcIn[13] ^ crcIn[14] ^ crcIn[16] ^ crcIn[23] ^ crcIn[25] ^ crcIn[28] ^ crcIn[30] ^ crcIn[31] ^ data[3] ^ data[4] ^ data[9] ^ data[12] ^ data[13] ^ data[14] ^ data[16] ^ data[23] ^ data[25] ^ data[28] ^ data[30] ^ data[31] ^ data[34] ^ data[36] ^ data[38] ^ data[39] ^ data[41] ^ data[43] ^ data[47] ^ data[48] ^ data[52] ^ data[55] ^ data[56] ^ data[60];
    crc[13] = crcIn[4] ^ crcIn[5] ^ crcIn[10] ^ crcIn[13] ^ crcIn[14] ^ crcIn[15] ^ crcIn[17] ^ crcIn[24] ^ crcIn[26] ^ crcIn[29] ^ crcIn[31] ^ data[4] ^ data[5] ^ data[10] ^ data[13] ^ data[14] ^ data[15] ^ data[17] ^ data[24] ^ data[26] ^ data[29] ^ data[31] ^ data[32] ^ data[35] ^ data[37] ^ data[39] ^ data[40] ^ data[42] ^ data[44] ^ data[48] ^ data[49] ^ data[53] ^ data[56] ^ data[57] ^ data[61];
    crc[14] = crcIn[5] ^ crcIn[6] ^ crcIn[11] ^ crcIn[14] ^ crcIn[15] ^ crcIn[16] ^ crcIn[18] ^ crcIn[25] ^ crcIn[27] ^ crcIn[30] ^ data[5] ^ data[6] ^ data[11] ^ data[14] ^ data[15] ^ data[16] ^ data[18] ^ data[25] ^ data[27] ^ data[30] ^ data[32] ^ data[33] ^ data[36] ^ data[38] ^ data[40] ^ data[41] ^ data[43] ^ data[45] ^ data[49] ^ data[50] ^ data[54] ^ data[57] ^ data[58] ^ data[62];
    crc[15] = crcIn[6] ^ crcIn[7] ^ crcIn[12] ^ crcIn[15] ^ crcIn[16] ^ crcIn[17] ^ crcIn[19] ^ crcIn[26] ^ crcIn[28] ^ crcIn[31] ^ data[6] ^ data[7] ^ data[12] ^ data[15] ^ data[16] ^ data[17] ^ data[19] ^ data[26] ^ data[28] ^ data[31] ^ data[33] ^ data[34] ^ data[37] ^ data[39] ^ data[41] ^ data[42] ^ data[44] ^ data[46] ^ data[50] ^ data[51] ^ data[55] ^ data[58] ^ data[59] ^ data[63];
    crc[16] = crcIn[1] ^ crcIn[3] ^ crcIn[4] ^ crcIn[6] ^ crcIn[7] ^ crcIn[8] ^ crcIn[9] ^ crcIn[10] ^ crcIn[11] ^ crcIn[13] ^ crcIn[14] ^ crcIn[18] ^ crcIn[19] ^ crcIn[29] ^ crcIn[30] ^ data[1] ^ data[3] ^ data[4] ^ data[6] ^ data[7] ^ data[8] ^ data[9] ^ data[10] ^ data[11] ^ data[13] ^ data[14] ^ data[18] ^ data[19] ^ data[29] ^ data[30] ^ data[33] ^ data[36] ^ data[39] ^ data[42] ^ data[43] ^ data[45] ^ data[47] ^ data[48] ^ data[51] ^ data[54] ^ data[55] ^ data[56] ^ data[58] ^ data[59] ^ data[60];
    crc[17] = crcIn[0] ^ crcIn[2] ^ crcIn[4] ^ crcIn[5] ^ crcIn[7] ^ crcIn[8] ^ crcIn[9] ^ crcIn[10] ^ crcIn[11] ^ crcIn[12] ^ crcIn[14] ^ crcIn[15] ^ crcIn[19] ^ crcIn[20] ^ crcIn[30] ^ crcIn[31] ^ data[0] ^ data[2] ^ data[4] ^ data[5] ^ data[7] ^ data[8] ^ data[9] ^ data[10] ^ data[11] ^ data[12] ^ data[14] ^ data[15] ^ data[19] ^ data[20] ^ data[30] ^ data[31] ^ data[34] ^ data[37] ^ data[40] ^ data[43] ^ data[44] ^ data[46] ^ data[48] ^ data[49] ^ data[52] ^ data[55] ^ data[56] ^ data[57] ^ data[59] ^ data[60] ^ data[61];
    crc[18] = crcIn[1] ^ crcIn[3] ^ crcIn[5] ^ crcIn[6] ^ crcIn[8] ^ crcIn[9] ^ crcIn[10] ^ crcIn[11] ^ crcIn[12] ^ crcIn[13] ^ crcIn[15] ^ crcIn[16] ^ crcIn[20] ^ crcIn[21] ^ crcIn[31] ^ data[1] ^ data[3] ^ data[5] ^ data[6] ^ data[8] ^ data[9] ^ data[10] ^ data[11] ^ data[12] ^ data[13] ^ data[15] ^ data[16] ^ data[20] ^ data[21] ^ data[31] ^ data[32] ^ data[35] ^ data[38] ^ data[41] ^ data[44] ^ data[45] ^ data[47] ^ data[49] ^ data[50] ^ data[53] ^ data[56] ^ data[57] ^ data[58] ^ data[60] ^ data[61] ^ data[62];
    crc[19] = crcIn[0] ^ crcIn[2] ^ crcIn[4] ^ crcIn[6] ^ crcIn[7] ^ crcIn[9] ^ crcIn[10] ^ crcIn[11] ^ crcIn[12] ^ crcIn[13] ^ crcIn[14] ^ crcIn[16] ^ crcIn[17] ^ crcIn[21] ^ crcIn[22] ^ data[0] ^ data[2] ^ data[4] ^ data[6] ^ data[7] ^ data[9] ^ data[10] ^ data[11] ^ data[12] ^ data[13] ^ data[14] ^ data[16] ^ data[17] ^ data[21] ^ data[22] ^ data[32] ^ data[33] ^ data[36] ^ data[39] ^ data[42] ^ data[45] ^ data[46] ^ data[48] ^ data[50] ^ data[51] ^ data[54] ^ data[57] ^ data[58] ^ data[59] ^ data[61] ^ data[62] ^ data[63];
    crc[20] = crcIn[4] ^ crcIn[5] ^ crcIn[6] ^ crcIn[7] ^ crcIn[8] ^ crcIn[9] ^ crcIn[12] ^ crcIn[13] ^ crcIn[15] ^ crcIn[16] ^ crcIn[18] ^ crcIn[19] ^ crcIn[20] ^ crcIn[22] ^ crcIn[23] ^ crcIn[27] ^ crcIn[30] ^ data[4] ^ data[5] ^ data[6] ^ data[7] ^ data[8] ^ data[9] ^ data[12] ^ data[13] ^ data[15] ^ data[16] ^ data[18] ^ data[19] ^ data[20] ^ data[22] ^ data[23] ^ data[27] ^ data[30] ^ data[32] ^ data[35] ^ data[36] ^ data[37] ^ data[38] ^ data[39] ^ data[43] ^ data[46] ^ data[47] ^ data[48] ^ data[49] ^ data[51] ^ data[54] ^ data[59] ^ data[60] ^ data[62] ^ data[63];
    crc[21] = crcIn[0] ^ crcIn[1] ^ crcIn[3] ^ crcIn[4] ^ crcIn[5] ^ crcIn[7] ^ crcIn[8] ^ crcIn[11] ^ crcIn[13] ^ crcIn[21] ^ crcIn[23] ^ crcIn[24] ^ crcIn[27] ^ crcIn[28] ^ crcIn[30] ^ crcIn[31] ^ data[0] ^ data[1] ^ data[3] ^ data[4] ^ data[5] ^ data[7] ^ data[8] ^ data[11] ^ data[13] ^ data[21] ^ data[23] ^ data[24] ^ data[27] ^ data[28] ^ data[30] ^ data[31] ^ data[32] ^ data[34] ^ data[35] ^ data[37] ^ data[44] ^ data[47] ^ data[49] ^ data[50] ^ data[54] ^ data[58] ^ data[60] ^ data[61] ^ data[63];
    crc[22] = crcIn[2] ^ crcIn[3] ^ crcIn[5] ^ crcIn[8] ^ crcIn[10] ^ crcIn[11] ^ crcIn[12] ^ crcIn[16] ^ crcIn[17] ^ crcIn[19] ^ crcIn[20] ^ crcIn[22] ^ crcIn[24] ^ crcIn[25] ^ crcIn[27] ^ crcIn[28] ^ crcIn[29] ^ crcIn[30] ^ crcIn[31] ^ data[2] ^ data[3] ^ data[5] ^ data[8] ^ data[10] ^ data[11] ^ data[12] ^ data[16] ^ data[17] ^ data[19] ^ data[20] ^ data[22] ^ data[24] ^ data[25] ^ data[27] ^ data[28] ^ data[29] ^ data[30] ^ data[31] ^ data[34] ^ data[39] ^ data[40] ^ data[45] ^ data[50] ^ data[51] ^ data[52] ^ data[54] ^ data[58] ^ data[59] ^ data[61] ^ data[62];
    crc[23] = crcIn[0] ^ crcIn[3] ^ crcIn[4] ^ crcIn[6] ^ crcIn[9] ^ crcIn[11] ^ crcIn[12] ^ crcIn[13] ^ crcIn[17] ^ crcIn[18] ^ crcIn[20] ^ crcIn[21] ^ crcIn[23] ^ crcIn[25] ^ crcIn[26] ^ crcIn[28] ^ crcIn[29] ^ crcIn[30] ^ crcIn[31] ^ data[0] ^ data[3] ^ data[4] ^ data[6] ^ data[9] ^ data[11] ^ data[12] ^ data[13] ^ data[17] ^ data[18] ^ data[20] ^ data[21] ^ data[23] ^ data[25] ^ data[26] ^ data[28] ^ data[29] ^ data[30] ^ data[31] ^ data[32] ^ data[35] ^ data[40] ^ data[41] ^ data[46] ^ data[51] ^ data[52] ^ data[53] ^ data[55] ^ data[59] ^ data[60] ^ data[62] ^ data[63];
    crc[24] = crcIn[3] ^ crcIn[5] ^ crcIn[6] ^ crcIn[7] ^ crcIn[9] ^ crcIn[11] ^ crcIn[12] ^ crcIn[13] ^ crcIn[16] ^ crcIn[17] ^ crcIn[18] ^ crcIn[20] ^ crcIn[21] ^ crcIn[22] ^ crcIn[24] ^ crcIn[26] ^ crcIn[29] ^ crcIn[31] ^ data[3] ^ data[5] ^ data[6] ^ data[7] ^ data[9] ^ data[11] ^ data[12] ^ data[13] ^ data[16] ^ data[17] ^ data[18] ^ data[20] ^ data[21] ^ data[22] ^ data[24] ^ data[26] ^ data[29] ^ data[31] ^ data[34] ^ data[35] ^ data[38] ^ data[39] ^ data[40] ^ data[41] ^ data[42] ^ data[47] ^ data[48] ^ data[53] ^ data[55] ^ data[56] ^ data[58] ^ data[60] ^ data[61] ^ data[63];
    crc[25] = crcIn[1] ^ crcIn[3] ^ crcIn[7] ^ crcIn[8] ^ crcIn[9] ^ crcIn[11] ^ crcIn[12] ^ crcIn[13] ^ crcIn[16] ^ crcIn[18] ^ crcIn[20] ^ crcIn[21] ^ crcIn[22] ^ crcIn[23] ^ crcIn[25] ^ data[1] ^ data[3] ^ data[7] ^ data[8] ^ data[9] ^ data[11] ^ data[12] ^ data[13] ^ data[16] ^ data[18] ^ data[20] ^ data[21] ^ data[22] ^ data[23] ^ data[25] ^ data[33] ^ data[34] ^ data[38] ^ data[41] ^ data[42] ^ data[43] ^ data[49] ^ data[52] ^ data[55] ^ data[56] ^ data[57] ^ data[58] ^ data[59] ^ data[61] ^ data[62];
    crc[26] = crcIn[0] ^ crcIn[2] ^ crcIn[4] ^ crcIn[8] ^ crcIn[9] ^ crcIn[10] ^ crcIn[12] ^ crcIn[13] ^ crcIn[14] ^ crcIn[17] ^ crcIn[19] ^ crcIn[21] ^ crcIn[22] ^ crcIn[23] ^ crcIn[24] ^ crcIn[26] ^ data[0] ^ data[2] ^ data[4] ^ data[8] ^ data[9] ^ data[10] ^ data[12] ^ data[13] ^ data[14] ^ data[17] ^ data[19] ^ data[21] ^ data[22] ^ data[23] ^ data[24] ^ data[26] ^ data[34] ^ data[35] ^ data[39] ^ data[42] ^ data[43] ^ data[44] ^ data[50] ^ data[53] ^ data[56] ^ data[57] ^ data[58] ^ data[59] ^ data[60] ^ data[62] ^ data[63];
    crc[27] = crcIn[0] ^ crcIn[4] ^ crcIn[5] ^ crcIn[6] ^ crcIn[13] ^ crcIn[15] ^ crcIn[16] ^ crcIn[17] ^ crcIn[18] ^ crcIn[19] ^ crcIn[22] ^ crcIn[23] ^ crcIn[24] ^ crcIn[25] ^ crcIn[30] ^ data[0] ^ data[4] ^ data[5] ^ data[6] ^ data[13] ^ data[15] ^ data[16] ^ data[17] ^ data[18] ^ data[19] ^ data[22] ^ data[23] ^ data[24] ^ data[25] ^ data[30] ^ data[32] ^ data[33] ^ data[34] ^ data[38] ^ data[39] ^ data[43] ^ data[44] ^ data[45] ^ data[48] ^ data[51] ^ data[52] ^ data[55] ^ data[57] ^ data[59] ^ data[60] ^ data[61] ^ data[63];
    crc[28] = crcIn[3] ^ crcIn[4] ^ crcIn[5] ^ crcIn[7] ^ crcIn[9] ^ crcIn[10] ^ crcIn[11] ^ crcIn[18] ^ crcIn[23] ^ crcIn[24] ^ crcIn[25] ^ crcIn[26] ^ crcIn[27] ^ crcIn[30] ^ crcIn[31] ^ data[3] ^ data[4] ^ data[5] ^ data[7] ^ data[9] ^ data[10] ^ data[11] ^ data[18] ^ data[23] ^ data[24] ^ data[25] ^ data[26] ^ data[27] ^ data[30] ^ data[31] ^ data[32] ^ data[36] ^ data[38] ^ data[44] ^ data[45] ^ data[46] ^ data[48] ^ data[49] ^ data[53] ^ data[54] ^ data[55] ^ data[56] ^ data[60] ^ data[61] ^ data[62];
    crc[29] = crcIn[4] ^ crcIn[5] ^ crcIn[6] ^ crcIn[8] ^ crcIn[10] ^ crcIn[11] ^ crcIn[12] ^ crcIn[19] ^ crcIn[24] ^ crcIn[25] ^ crcIn[26] ^ crcIn[27] ^ crcIn[28] ^ crcIn[31] ^ data[4] ^ data[5] ^ data[6] ^ data[8] ^ data[10] ^ data[11] ^ data[12] ^ data[19] ^ data[24] ^ data[25] ^ data[26] ^ data[27] ^ data[28] ^ data[31] ^ data[32] ^ data[33] ^ data[37] ^ data[39] ^ data[45] ^ data[46] ^ data[47] ^ data[49] ^ data[50] ^ data[54] ^ data[55] ^ data[56] ^ data[57] ^ data[61] ^ data[62] ^ data[63];
    crc[30] = crcIn[0] ^ crcIn[1] ^ crcIn[3] ^ crcIn[4] ^ crcIn[5] ^ crcIn[7] ^ crcIn[10] ^ crcIn[12] ^ crcIn[13] ^ crcIn[14] ^ crcIn[16] ^ crcIn[17] ^ crcIn[19] ^ crcIn[25] ^ crcIn[26] ^ crcIn[28] ^ crcIn[29] ^ crcIn[30] ^ data[0] ^ data[1] ^ data[3] ^ data[4] ^ data[5] ^ data[7] ^ data[10] ^ data[12] ^ data[13] ^ data[14] ^ data[16] ^ data[17] ^ data[19] ^ data[25] ^ data[26] ^ data[28] ^ data[29] ^ data[30] ^ data[35] ^ data[36] ^ data[39] ^ data[46] ^ data[47] ^ data[50] ^ data[51] ^ data[52] ^ data[54] ^ data[56] ^ data[57] ^ data[62] ^ data[63];
    crc[31] = crcIn[0] ^ crcIn[2] ^ crcIn[3] ^ crcIn[5] ^ crcIn[8] ^ crcIn[9] ^ crcIn[10] ^ crcIn[13] ^ crcIn[15] ^ crcIn[16] ^ crcIn[18] ^ crcIn[19] ^ crcIn[26] ^ crcIn[29] ^ crcIn[31] ^ data[0] ^ data[2] ^ data[3] ^ data[5] ^ data[8] ^ data[9] ^ data[10] ^ data[13] ^ data[15] ^ data[16] ^ data[18] ^ data[19] ^ data[26] ^ data[29] ^ data[31] ^ data[32] ^ data[33] ^ data[34] ^ data[35] ^ data[37] ^ data[38] ^ data[39] ^ data[47] ^ data[51] ^ data[53] ^ data[54] ^ data[57] ^ data[63];
end
endfunction
//******************************************************************************
//******************************************************************************
function automatic [31:0] crc_d8;
    input [7:0] data; 
    input [31:0] crcIn;
begin
    crc_d8[0] = crcIn[2] ^ crcIn[8] ^ data[2];
    crc_d8[1] = crcIn[0] ^ crcIn[3] ^ crcIn[9] ^ data[0] ^ data[3];
    crc_d8[2] = crcIn[0] ^ crcIn[1] ^ crcIn[4] ^ crcIn[10] ^ data[0] ^ data[1] ^ data[4];
    crc_d8[3] = crcIn[1] ^ crcIn[2] ^ crcIn[5] ^ crcIn[11] ^ data[1] ^ data[2] ^ data[5];
    crc_d8[4] = crcIn[0] ^ crcIn[2] ^ crcIn[3] ^ crcIn[6] ^ crcIn[12] ^ data[0] ^ data[2] ^ data[3] ^ data[6];
    crc_d8[5] = crcIn[1] ^ crcIn[3] ^ crcIn[4] ^ crcIn[7] ^ crcIn[13] ^ data[1] ^ data[3] ^ data[4] ^ data[7];
    crc_d8[6] = crcIn[4] ^ crcIn[5] ^ crcIn[14] ^ data[4] ^ data[5];
    crc_d8[7] = crcIn[0] ^ crcIn[5] ^ crcIn[6] ^ crcIn[15] ^ data[0] ^ data[5] ^ data[6];
    crc_d8[8] = crcIn[1] ^ crcIn[6] ^ crcIn[7] ^ crcIn[16] ^ data[1] ^ data[6] ^ data[7];
    crc_d8[9] = crcIn[7] ^ crcIn[17] ^ data[7];
    crc_d8[10] = crcIn[2] ^ crcIn[18] ^ data[2];
    crc_d8[11] = crcIn[3] ^ crcIn[19] ^ data[3];
    crc_d8[12] = crcIn[0] ^ crcIn[4] ^ crcIn[20] ^ data[0] ^ data[4];
    crc_d8[13] = crcIn[0] ^ crcIn[1] ^ crcIn[5] ^ crcIn[21] ^ data[0] ^ data[1] ^ data[5];
    crc_d8[14] = crcIn[1] ^ crcIn[2] ^ crcIn[6] ^ crcIn[22] ^ data[1] ^ data[2] ^ data[6];
    crc_d8[15] = crcIn[2] ^ crcIn[3] ^ crcIn[7] ^ crcIn[23] ^ data[2] ^ data[3] ^ data[7];
    crc_d8[16] = crcIn[0] ^ crcIn[2] ^ crcIn[3] ^ crcIn[4] ^ crcIn[24] ^ data[0] ^ data[2] ^ data[3] ^ data[4];
    crc_d8[17] = crcIn[0] ^ crcIn[1] ^ crcIn[3] ^ crcIn[4] ^ crcIn[5] ^ crcIn[25] ^ data[0] ^ data[1] ^ data[3] ^ data[4] ^ data[5];
    crc_d8[18] = crcIn[0] ^ crcIn[1] ^ crcIn[2] ^ crcIn[4] ^ crcIn[5] ^ crcIn[6] ^ crcIn[26] ^ data[0] ^ data[1] ^ data[2] ^ data[4] ^ data[5] ^ data[6];
    crc_d8[19] = crcIn[1] ^ crcIn[2] ^ crcIn[3] ^ crcIn[5] ^ crcIn[6] ^ crcIn[7] ^ crcIn[27] ^ data[1] ^ data[2] ^ data[3] ^ data[5] ^ data[6] ^ data[7];
    crc_d8[20] = crcIn[3] ^ crcIn[4] ^ crcIn[6] ^ crcIn[7] ^ crcIn[28] ^ data[3] ^ data[4] ^ data[6] ^ data[7];
    crc_d8[21] = crcIn[2] ^ crcIn[4] ^ crcIn[5] ^ crcIn[7] ^ crcIn[29] ^ data[2] ^ data[4] ^ data[5] ^ data[7];
    crc_d8[22] = crcIn[2] ^ crcIn[3] ^ crcIn[5] ^ crcIn[6] ^ crcIn[30] ^ data[2] ^ data[3] ^ data[5] ^ data[6];
    crc_d8[23] = crcIn[3] ^ crcIn[4] ^ crcIn[6] ^ crcIn[7] ^ crcIn[31] ^ data[3] ^ data[4] ^ data[6] ^ data[7];
    crc_d8[24] = crcIn[0] ^ crcIn[2] ^ crcIn[4] ^ crcIn[5] ^ crcIn[7] ^ data[0] ^ data[2] ^ data[4] ^ data[5] ^ data[7];
    crc_d8[25] = crcIn[0] ^ crcIn[1] ^ crcIn[2] ^ crcIn[3] ^ crcIn[5] ^ crcIn[6] ^ data[0] ^ data[1] ^ data[2] ^ data[3] ^ data[5] ^ data[6];
    crc_d8[26] = crcIn[0] ^ crcIn[1] ^ crcIn[2] ^ crcIn[3] ^ crcIn[4] ^ crcIn[6] ^ crcIn[7] ^ data[0] ^ data[1] ^ data[2] ^ data[3] ^ data[4] ^ data[6] ^ data[7];
    crc_d8[27] = crcIn[1] ^ crcIn[3] ^ crcIn[4] ^ crcIn[5] ^ crcIn[7] ^ data[1] ^ data[3] ^ data[4] ^ data[5] ^ data[7];
    crc_d8[28] = crcIn[0] ^ crcIn[4] ^ crcIn[5] ^ crcIn[6] ^ data[0] ^ data[4] ^ data[5] ^ data[6];
    crc_d8[29] = crcIn[0] ^ crcIn[1] ^ crcIn[5] ^ crcIn[6] ^ crcIn[7] ^ data[0] ^ data[1] ^ data[5] ^ data[6] ^ data[7];
    crc_d8[30] = crcIn[0] ^ crcIn[1] ^ crcIn[6] ^ crcIn[7] ^ data[0] ^ data[1] ^ data[6] ^ data[7];
    crc_d8[31] = crcIn[1] ^ crcIn[7] ^ data[1] ^ data[7];
end
endfunction
//******************************************************************************
//******************************************************************************
//input data width is 8bit, and the first bit is bit[7]
function [31:0] NextCRC_D8;
    input [7:0] d;
    input [31:0] c;
    reg [31:0] newcrc;
    begin
    newcrc[0] = d[6] ^ d[0] ^ c[24] ^ c[30];
    newcrc[1] = d[7] ^ d[6] ^ d[1] ^ d[0] ^ c[24] ^ c[25] ^ c[30] ^ c[31];
    newcrc[2] = d[7] ^ d[6] ^ d[2] ^ d[1] ^ d[0] ^ c[24] ^ c[25] ^ c[26] ^ c[30] ^ c[31];
    newcrc[3] = d[7] ^ d[3] ^ d[2] ^ d[1] ^ c[25] ^ c[26] ^ c[27] ^ c[31];
    newcrc[4] = d[6] ^ d[4] ^ d[3] ^ d[2] ^ d[0] ^ c[24] ^ c[26] ^ c[27] ^ c[28] ^ c[30];
    newcrc[5] = d[7] ^ d[6] ^ d[5] ^ d[4] ^ d[3] ^ d[1] ^ d[0] ^ c[24] ^ c[25] ^ c[27] ^ c[28] ^ c[29] ^ c[30] ^ c[31];
    newcrc[6] = d[7] ^ d[6] ^ d[5] ^ d[4] ^ d[2] ^ d[1] ^ c[25] ^ c[26] ^ c[28] ^ c[29] ^ c[30] ^ c[31];
    newcrc[7] = d[7] ^ d[5] ^ d[3] ^ d[2] ^ d[0] ^ c[24] ^ c[26] ^ c[27] ^ c[29] ^ c[31];
    newcrc[8] = d[4] ^ d[3] ^ d[1] ^ d[0] ^ c[0] ^ c[24] ^ c[25] ^ c[27] ^ c[28];
    newcrc[9] = d[5] ^ d[4] ^ d[2] ^ d[1] ^ c[1] ^ c[25] ^ c[26] ^ c[28] ^ c[29];
    newcrc[10] = d[5] ^ d[3] ^ d[2] ^ d[0] ^ c[2] ^ c[24] ^ c[26] ^ c[27] ^ c[29];
    newcrc[11] = d[4] ^ d[3] ^ d[1] ^ d[0] ^ c[3] ^ c[24] ^ c[25] ^ c[27] ^ c[28];
    newcrc[12] = d[6] ^ d[5] ^ d[4] ^ d[2] ^ d[1] ^ d[0] ^ c[4] ^ c[24] ^ c[25] ^ c[26] ^ c[28] ^ c[29] ^ c[30];
    newcrc[13] = d[7] ^ d[6] ^ d[5] ^ d[3] ^ d[2] ^ d[1] ^ c[5] ^ c[25] ^ c[26] ^ c[27] ^ c[29] ^ c[30] ^ c[31];
    newcrc[14] = d[7] ^ d[6] ^ d[4] ^ d[3] ^ d[2] ^ c[6] ^ c[26] ^ c[27] ^ c[28] ^ c[30] ^ c[31];
    newcrc[15] = d[7] ^ d[5] ^ d[4] ^ d[3] ^ c[7] ^ c[27] ^ c[28] ^ c[29] ^ c[31];
    newcrc[16] = d[5] ^ d[4] ^ d[0] ^ c[8] ^ c[24] ^ c[28] ^ c[29];
    newcrc[17] = d[6] ^ d[5] ^ d[1] ^ c[9] ^ c[25] ^ c[29] ^ c[30];
    newcrc[18] = d[7] ^ d[6] ^ d[2] ^ c[10] ^ c[26] ^ c[30] ^ c[31];
    newcrc[19] = d[7] ^ d[3] ^ c[11] ^ c[27] ^ c[31];
    newcrc[20] = d[4] ^ c[12] ^ c[28];
    newcrc[21] = d[5] ^ c[13] ^ c[29];
    newcrc[22] = d[0] ^ c[14] ^ c[24];
    newcrc[23] = d[6] ^ d[1] ^ d[0] ^ c[15] ^ c[24] ^ c[25] ^ c[30];
    newcrc[24] = d[7] ^ d[2] ^ d[1] ^ c[16] ^ c[25] ^ c[26] ^ c[31];
    newcrc[25] = d[3] ^ d[2] ^ c[17] ^ c[26] ^ c[27];
    newcrc[26] = d[6] ^ d[4] ^ d[3] ^ d[0] ^ c[18] ^ c[24] ^ c[27] ^ c[28] ^ c[30];
    newcrc[27] = d[7] ^ d[5] ^ d[4] ^ d[1] ^ c[19] ^ c[25] ^ c[28] ^ c[29] ^ c[31];
    newcrc[28] = d[6] ^ d[5] ^ d[2] ^ c[20] ^ c[26] ^ c[29] ^ c[30];
    newcrc[29] = d[7] ^ d[6] ^ d[3] ^ c[21] ^ c[27] ^ c[30] ^ c[31];
    newcrc[30] = d[7] ^ d[4] ^ c[22] ^ c[28] ^ c[31];
    newcrc[31] = d[5] ^ c[23] ^ c[29];
    NextCRC_D8 = newcrc;
    end
endfunction
//******************************************************************************
//******************************************************************************  
// convention: the first serial bit is D[63]
function [31:0] NextCRC_D64;
    input [63:0] d;
    input [31:0] c;
    reg [31:0] newcrc;
    begin
    newcrc[0] = d[63] ^ d[61] ^ d[60] ^ d[58] ^ d[55] ^ d[54] ^ d[53] ^ d[50] ^ d[48] ^ d[47] ^ d[45] ^ d[44] ^ d[37] ^ d[34] ^ d[32] ^ d[31] ^ d[30] ^ d[29] ^ d[28] ^ d[26] ^ d[25] ^ d[24] ^ d[16] ^ d[12] ^ d[10] ^ d[9] ^ d[6] ^ d[0] ^ c[0] ^ c[2] ^ c[5] ^ c[12] ^ c[13] ^ c[15] ^ c[16] ^ c[18] ^ c[21] ^ c[22] ^ c[23] ^ c[26] ^ c[28] ^ c[29] ^ c[31];
    newcrc[1] = d[63] ^ d[62] ^ d[60] ^ d[59] ^ d[58] ^ d[56] ^ d[53] ^ d[51] ^ d[50] ^ d[49] ^ d[47] ^ d[46] ^ d[44] ^ d[38] ^ d[37] ^ d[35] ^ d[34] ^ d[33] ^ d[28] ^ d[27] ^ d[24] ^ d[17] ^ d[16] ^ d[13] ^ d[12] ^ d[11] ^ d[9] ^ d[7] ^ d[6] ^ d[1] ^ d[0] ^ c[1] ^ c[2] ^ c[3] ^ c[5] ^ c[6] ^ c[12] ^ c[14] ^ c[15] ^ c[17] ^ c[18] ^ c[19] ^ c[21] ^ c[24] ^ c[26] ^ c[27] ^ c[28] ^ c[30] ^ c[31];
    newcrc[2] = d[59] ^ d[58] ^ d[57] ^ d[55] ^ d[53] ^ d[52] ^ d[51] ^ d[44] ^ d[39] ^ d[38] ^ d[37] ^ d[36] ^ d[35] ^ d[32] ^ d[31] ^ d[30] ^ d[26] ^ d[24] ^ d[18] ^ d[17] ^ d[16] ^ d[14] ^ d[13] ^ d[9] ^ d[8] ^ d[7] ^ d[6] ^ d[2] ^ d[1] ^ d[0] ^ c[0] ^ c[3] ^ c[4] ^ c[5] ^ c[6] ^ c[7] ^ c[12] ^ c[19] ^ c[20] ^ c[21] ^ c[23] ^ c[25] ^ c[26] ^ c[27];
    newcrc[3] = d[60] ^ d[59] ^ d[58] ^ d[56] ^ d[54] ^ d[53] ^ d[52] ^ d[45] ^ d[40] ^ d[39] ^ d[38] ^ d[37] ^ d[36] ^ d[33] ^ d[32] ^ d[31] ^ d[27] ^ d[25] ^ d[19] ^ d[18] ^ d[17] ^ d[15] ^ d[14] ^ d[10] ^ d[9] ^ d[8] ^ d[7] ^ d[3] ^ d[2] ^ d[1] ^ c[0] ^ c[1] ^ c[4] ^ c[5] ^ c[6] ^ c[7] ^ c[8] ^ c[13] ^ c[20] ^ c[21] ^ c[22] ^ c[24] ^ c[26] ^ c[27] ^ c[28];
    newcrc[4] = d[63] ^ d[59] ^ d[58] ^ d[57] ^ d[50] ^ d[48] ^ d[47] ^ d[46] ^ d[45] ^ d[44] ^ d[41] ^ d[40] ^ d[39] ^ d[38] ^ d[33] ^ d[31] ^ d[30] ^ d[29] ^ d[25] ^ d[24] ^ d[20] ^ d[19] ^ d[18] ^ d[15] ^ d[12] ^ d[11] ^ d[8] ^ d[6] ^ d[4] ^ d[3] ^ d[2] ^ d[0] ^ c[1] ^ c[6] ^ c[7] ^ c[8] ^ c[9] ^ c[12] ^ c[13] ^ c[14] ^ c[15] ^ c[16] ^ c[18] ^ c[25] ^ c[26] ^ c[27] ^ c[31];
    newcrc[5] = d[63] ^ d[61] ^ d[59] ^ d[55] ^ d[54] ^ d[53] ^ d[51] ^ d[50] ^ d[49] ^ d[46] ^ d[44] ^ d[42] ^ d[41] ^ d[40] ^ d[39] ^ d[37] ^ d[29] ^ d[28] ^ d[24] ^ d[21] ^ d[20] ^ d[19] ^ d[13] ^ d[10] ^ d[7] ^ d[6] ^ d[5] ^ d[4] ^ d[3] ^ d[1] ^ d[0] ^ c[5] ^ c[7] ^ c[8] ^ c[9] ^ c[10] ^ c[12] ^ c[14] ^ c[17] ^ c[18] ^ c[19] ^ c[21] ^ c[22] ^ c[23] ^ c[27] ^ c[29] ^ c[31];
    newcrc[6] = d[62] ^ d[60] ^ d[56] ^ d[55] ^ d[54] ^ d[52] ^ d[51] ^ d[50] ^ d[47] ^ d[45] ^ d[43] ^ d[42] ^ d[41] ^ d[40] ^ d[38] ^ d[30] ^ d[29] ^ d[25] ^ d[22] ^ d[21] ^ d[20] ^ d[14] ^ d[11] ^ d[8] ^ d[7] ^ d[6] ^ d[5] ^ d[4] ^ d[2] ^ d[1] ^ c[6] ^ c[8] ^ c[9] ^ c[10] ^ c[11] ^ c[13] ^ c[15] ^ c[18] ^ c[19] ^ c[20] ^ c[22] ^ c[23] ^ c[24] ^ c[28] ^ c[30];
    newcrc[7] = d[60] ^ d[58] ^ d[57] ^ d[56] ^ d[54] ^ d[52] ^ d[51] ^ d[50] ^ d[47] ^ d[46] ^ d[45] ^ d[43] ^ d[42] ^ d[41] ^ d[39] ^ d[37] ^ d[34] ^ d[32] ^ d[29] ^ d[28] ^ d[25] ^ d[24] ^ d[23] ^ d[22] ^ d[21] ^ d[16] ^ d[15] ^ d[10] ^ d[8] ^ d[7] ^ d[5] ^ d[3] ^ d[2] ^ d[0] ^ c[0] ^ c[2] ^ c[5] ^ c[7] ^ c[9] ^ c[10] ^ c[11] ^ c[13] ^ c[14] ^ c[15] ^ c[18] ^ c[19] ^ c[20] ^ c[22] ^ c[24] ^ c[25] ^ c[26] ^ c[28];
    newcrc[8] = d[63] ^ d[60] ^ d[59] ^ d[57] ^ d[54] ^ d[52] ^ d[51] ^ d[50] ^ d[46] ^ d[45] ^ d[43] ^ d[42] ^ d[40] ^ d[38] ^ d[37] ^ d[35] ^ d[34] ^ d[33] ^ d[32] ^ d[31] ^ d[28] ^ d[23] ^ d[22] ^ d[17] ^ d[12] ^ d[11] ^ d[10] ^ d[8] ^ d[4] ^ d[3] ^ d[1] ^ d[0] ^ c[0] ^ c[1] ^ c[2] ^ c[3] ^ c[5] ^ c[6] ^ c[8] ^ c[10] ^ c[11] ^ c[13] ^ c[14] ^ c[18] ^ c[19] ^ c[20] ^ c[22] ^ c[25] ^ c[27] ^ c[28] ^ c[31];
    newcrc[9] = d[61] ^ d[60] ^ d[58] ^ d[55] ^ d[53] ^ d[52] ^ d[51] ^ d[47] ^ d[46] ^ d[44] ^ d[43] ^ d[41] ^ d[39] ^ d[38] ^ d[36] ^ d[35] ^ d[34] ^ d[33] ^ d[32] ^ d[29] ^ d[24] ^ d[23] ^ d[18] ^ d[13] ^ d[12] ^ d[11] ^ d[9] ^ d[5] ^ d[4] ^ d[2] ^ d[1] ^ c[0] ^ c[1] ^ c[2] ^ c[3] ^ c[4] ^ c[6] ^ c[7] ^ c[9] ^ c[11] ^ c[12] ^ c[14] ^ c[15] ^ c[19] ^ c[20] ^ c[21] ^ c[23] ^ c[26] ^ c[28] ^ c[29];
    newcrc[10] = d[63] ^ d[62] ^ d[60] ^ d[59] ^ d[58] ^ d[56] ^ d[55] ^ d[52] ^ d[50] ^ d[42] ^ d[40] ^ d[39] ^ d[36] ^ d[35] ^ d[33] ^ d[32] ^ d[31] ^ d[29] ^ d[28] ^ d[26] ^ d[19] ^ d[16] ^ d[14] ^ d[13] ^ d[9] ^ d[5] ^ d[3] ^ d[2] ^ d[0] ^ c[0] ^ c[1] ^ c[3] ^ c[4] ^ c[7] ^ c[8] ^ c[10] ^ c[18] ^ c[20] ^ c[23] ^ c[24] ^ c[26] ^ c[27] ^ c[28] ^ c[30] ^ c[31];
    newcrc[11] = d[59] ^ d[58] ^ d[57] ^ d[56] ^ d[55] ^ d[54] ^ d[51] ^ d[50] ^ d[48] ^ d[47] ^ d[45] ^ d[44] ^ d[43] ^ d[41] ^ d[40] ^ d[36] ^ d[33] ^ d[31] ^ d[28] ^ d[27] ^ d[26] ^ d[25] ^ d[24] ^ d[20] ^ d[17] ^ d[16] ^ d[15] ^ d[14] ^ d[12] ^ d[9] ^ d[4] ^ d[3] ^ d[1] ^ d[0] ^ c[1] ^ c[4] ^ c[8] ^ c[9] ^ c[11] ^ c[12] ^ c[13] ^ c[15] ^ c[16] ^ c[18] ^ c[19] ^ c[22] ^ c[23] ^ c[24] ^ c[25] ^ c[26] ^ c[27];
    newcrc[12] = d[63] ^ d[61] ^ d[59] ^ d[57] ^ d[56] ^ d[54] ^ d[53] ^ d[52] ^ d[51] ^ d[50] ^ d[49] ^ d[47] ^ d[46] ^ d[42] ^ d[41] ^ d[31] ^ d[30] ^ d[27] ^ d[24] ^ d[21] ^ d[18] ^ d[17] ^ d[15] ^ d[13] ^ d[12] ^ d[9] ^ d[6] ^ d[5] ^ d[4] ^ d[2] ^ d[1] ^ d[0] ^ c[9] ^ c[10] ^ c[14] ^ c[15] ^ c[17] ^ c[18] ^ c[19] ^ c[20] ^ c[21] ^ c[22] ^ c[24] ^ c[25] ^ c[27] ^ c[29] ^ c[31];
    newcrc[13] = d[62] ^ d[60] ^ d[58] ^ d[57] ^ d[55] ^ d[54] ^ d[53] ^ d[52] ^ d[51] ^ d[50] ^ d[48] ^ d[47] ^ d[43] ^ d[42] ^ d[32] ^ d[31] ^ d[28] ^ d[25] ^ d[22] ^ d[19] ^ d[18] ^ d[16] ^ d[14] ^ d[13] ^ d[10] ^ d[7] ^ d[6] ^ d[5] ^ d[3] ^ d[2] ^ d[1] ^ c[0] ^ c[10] ^ c[11] ^ c[15] ^ c[16] ^ c[18] ^ c[19] ^ c[20] ^ c[21] ^ c[22] ^ c[23] ^ c[25] ^ c[26] ^ c[28] ^ c[30];
    newcrc[14] = d[63] ^ d[61] ^ d[59] ^ d[58] ^ d[56] ^ d[55] ^ d[54] ^ d[53] ^ d[52] ^ d[51] ^ d[49] ^ d[48] ^ d[44] ^ d[43] ^ d[33] ^ d[32] ^ d[29] ^ d[26] ^ d[23] ^ d[20] ^ d[19] ^ d[17] ^ d[15] ^ d[14] ^ d[11] ^ d[8] ^ d[7] ^ d[6] ^ d[4] ^ d[3] ^ d[2] ^ c[0] ^ c[1] ^ c[11] ^ c[12] ^ c[16] ^ c[17] ^ c[19] ^ c[20] ^ c[21] ^ c[22] ^ c[23] ^ c[24] ^ c[26] ^ c[27] ^ c[29] ^ c[31];
    newcrc[15] = d[62] ^ d[60] ^ d[59] ^ d[57] ^ d[56] ^ d[55] ^ d[54] ^ d[53] ^ d[52] ^ d[50] ^ d[49] ^ d[45] ^ d[44] ^ d[34] ^ d[33] ^ d[30] ^ d[27] ^ d[24] ^ d[21] ^ d[20] ^ d[18] ^ d[16] ^ d[15] ^ d[12] ^ d[9] ^ d[8] ^ d[7] ^ d[5] ^ d[4] ^ d[3] ^ c[1] ^ c[2] ^ c[12] ^ c[13] ^ c[17] ^ c[18] ^ c[20] ^ c[21] ^ c[22] ^ c[23] ^ c[24] ^ c[25] ^ c[27] ^ c[28] ^ c[30];
    newcrc[16] = d[57] ^ d[56] ^ d[51] ^ d[48] ^ d[47] ^ d[46] ^ d[44] ^ d[37] ^ d[35] ^ d[32] ^ d[30] ^ d[29] ^ d[26] ^ d[24] ^ d[22] ^ d[21] ^ d[19] ^ d[17] ^ d[13] ^ d[12] ^ d[8] ^ d[5] ^ d[4] ^ d[0] ^ c[0] ^ c[3] ^ c[5] ^ c[12] ^ c[14] ^ c[15] ^ c[16] ^ c[19] ^ c[24] ^ c[25];
    newcrc[17] = d[58] ^ d[57] ^ d[52] ^ d[49] ^ d[48] ^ d[47] ^ d[45] ^ d[38] ^ d[36] ^ d[33] ^ d[31] ^ d[30] ^ d[27] ^ d[25] ^ d[23] ^ d[22] ^ d[20] ^ d[18] ^ d[14] ^ d[13] ^ d[9] ^ d[6] ^ d[5] ^ d[1] ^ c[1] ^ c[4] ^ c[6] ^ c[13] ^ c[15] ^ c[16] ^ c[17] ^ c[20] ^ c[25] ^ c[26];
    newcrc[18] = d[59] ^ d[58] ^ d[53] ^ d[50] ^ d[49] ^ d[48] ^ d[46] ^ d[39] ^ d[37] ^ d[34] ^ d[32] ^ d[31] ^ d[28] ^ d[26] ^ d[24] ^ d[23] ^ d[21] ^ d[19] ^ d[15] ^ d[14] ^ d[10] ^ d[7] ^ d[6] ^ d[2] ^ c[0] ^ c[2] ^ c[5] ^ c[7] ^ c[14] ^ c[16] ^ c[17] ^ c[18] ^ c[21] ^ c[26] ^ c[27];
    newcrc[19] = d[60] ^ d[59] ^ d[54] ^ d[51] ^ d[50] ^ d[49] ^ d[47] ^ d[40] ^ d[38] ^ d[35] ^ d[33] ^ d[32] ^ d[29] ^ d[27] ^ d[25] ^ d[24] ^ d[22] ^ d[20] ^ d[16] ^ d[15] ^ d[11] ^ d[8] ^ d[7] ^ d[3] ^ c[0] ^ c[1] ^ c[3] ^ c[6] ^ c[8] ^ c[15] ^ c[17] ^ c[18] ^ c[19] ^ c[22] ^ c[27] ^ c[28];
    newcrc[20] = d[61] ^ d[60] ^ d[55] ^ d[52] ^ d[51] ^ d[50] ^ d[48] ^ d[41] ^ d[39] ^ d[36] ^ d[34] ^ d[33] ^ d[30] ^ d[28] ^ d[26] ^ d[25] ^ d[23] ^ d[21] ^ d[17] ^ d[16] ^ d[12] ^ d[9] ^ d[8] ^ d[4] ^ c[1] ^ c[2] ^ c[4] ^ c[7] ^ c[9] ^ c[16] ^ c[18] ^ c[19] ^ c[20] ^ c[23] ^ c[28] ^ c[29];
    newcrc[21] = d[62] ^ d[61] ^ d[56] ^ d[53] ^ d[52] ^ d[51] ^ d[49] ^ d[42] ^ d[40] ^ d[37] ^ d[35] ^ d[34] ^ d[31] ^ d[29] ^ d[27] ^ d[26] ^ d[24] ^ d[22] ^ d[18] ^ d[17] ^ d[13] ^ d[10] ^ d[9] ^ d[5] ^ c[2] ^ c[3] ^ c[5] ^ c[8] ^ c[10] ^ c[17] ^ c[19] ^ c[20] ^ c[21] ^ c[24] ^ c[29] ^ c[30];
    newcrc[22] = d[62] ^ d[61] ^ d[60] ^ d[58] ^ d[57] ^ d[55] ^ d[52] ^ d[48] ^ d[47] ^ d[45] ^ d[44] ^ d[43] ^ d[41] ^ d[38] ^ d[37] ^ d[36] ^ d[35] ^ d[34] ^ d[31] ^ d[29] ^ d[27] ^ d[26] ^ d[24] ^ d[23] ^ d[19] ^ d[18] ^ d[16] ^ d[14] ^ d[12] ^ d[11] ^ d[9] ^ d[0] ^ c[2] ^ c[3] ^ c[4] ^ c[5] ^ c[6] ^ c[9] ^ c[11] ^ c[12] ^ c[13] ^ c[15] ^ c[16] ^ c[20] ^ c[23] ^ c[25] ^ c[26] ^ c[28] ^ c[29] ^ c[30];
    newcrc[23] = d[62] ^ d[60] ^ d[59] ^ d[56] ^ d[55] ^ d[54] ^ d[50] ^ d[49] ^ d[47] ^ d[46] ^ d[42] ^ d[39] ^ d[38] ^ d[36] ^ d[35] ^ d[34] ^ d[31] ^ d[29] ^ d[27] ^ d[26] ^ d[20] ^ d[19] ^ d[17] ^ d[16] ^ d[15] ^ d[13] ^ d[9] ^ d[6] ^ d[1] ^ d[0] ^ c[2] ^ c[3] ^ c[4] ^ c[6] ^ c[7] ^ c[10] ^ c[14] ^ c[15] ^ c[17] ^ c[18] ^ c[22] ^ c[23] ^ c[24] ^ c[27] ^ c[28] ^ c[30];
    newcrc[24] = d[63] ^ d[61] ^ d[60] ^ d[57] ^ d[56] ^ d[55] ^ d[51] ^ d[50] ^ d[48] ^ d[47] ^ d[43] ^ d[40] ^ d[39] ^ d[37] ^ d[36] ^ d[35] ^ d[32] ^ d[30] ^ d[28] ^ d[27] ^ d[21] ^ d[20] ^ d[18] ^ d[17] ^ d[16] ^ d[14] ^ d[10] ^ d[7] ^ d[2] ^ d[1] ^ c[0] ^ c[3] ^ c[4] ^ c[5] ^ c[7] ^ c[8] ^ c[11] ^ c[15] ^ c[16] ^ c[18] ^ c[19] ^ c[23] ^ c[24] ^ c[25] ^ c[28] ^ c[29] ^ c[31];
    newcrc[25] = d[62] ^ d[61] ^ d[58] ^ d[57] ^ d[56] ^ d[52] ^ d[51] ^ d[49] ^ d[48] ^ d[44] ^ d[41] ^ d[40] ^ d[38] ^ d[37] ^ d[36] ^ d[33] ^ d[31] ^ d[29] ^ d[28] ^ d[22] ^ d[21] ^ d[19] ^ d[18] ^ d[17] ^ d[15] ^ d[11] ^ d[8] ^ d[3] ^ d[2] ^ c[1] ^ c[4] ^ c[5] ^ c[6] ^ c[8] ^ c[9] ^ c[12] ^ c[16] ^ c[17] ^ c[19] ^ c[20] ^ c[24] ^ c[25] ^ c[26] ^ c[29] ^ c[30];
    newcrc[26] = d[62] ^ d[61] ^ d[60] ^ d[59] ^ d[57] ^ d[55] ^ d[54] ^ d[52] ^ d[49] ^ d[48] ^ d[47] ^ d[44] ^ d[42] ^ d[41] ^ d[39] ^ d[38] ^ d[31] ^ d[28] ^ d[26] ^ d[25] ^ d[24] ^ d[23] ^ d[22] ^ d[20] ^ d[19] ^ d[18] ^ d[10] ^ d[6] ^ d[4] ^ d[3] ^ d[0] ^ c[6] ^ c[7] ^ c[9] ^ c[10] ^ c[12] ^ c[15] ^ c[16] ^ c[17] ^ c[20] ^ c[22] ^ c[23] ^ c[25] ^ c[27] ^ c[28] ^ c[29] ^ c[30];
    newcrc[27] = d[63] ^ d[62] ^ d[61] ^ d[60] ^ d[58] ^ d[56] ^ d[55] ^ d[53] ^ d[50] ^ d[49] ^ d[48] ^ d[45] ^ d[43] ^ d[42] ^ d[40] ^ d[39] ^ d[32] ^ d[29] ^ d[27] ^ d[26] ^ d[25] ^ d[24] ^ d[23] ^ d[21] ^ d[20] ^ d[19] ^ d[11] ^ d[7] ^ d[5] ^ d[4] ^ d[1] ^ c[0] ^ c[7] ^ c[8] ^ c[10] ^ c[11] ^ c[13] ^ c[16] ^ c[17] ^ c[18] ^ c[21] ^ c[23] ^ c[24] ^ c[26] ^ c[28] ^ c[29] ^ c[30] ^ c[31];
    newcrc[28] = d[63] ^ d[62] ^ d[61] ^ d[59] ^ d[57] ^ d[56] ^ d[54] ^ d[51] ^ d[50] ^ d[49] ^ d[46] ^ d[44] ^ d[43] ^ d[41] ^ d[40] ^ d[33] ^ d[30] ^ d[28] ^ d[27] ^ d[26] ^ d[25] ^ d[24] ^ d[22] ^ d[21] ^ d[20] ^ d[12] ^ d[8] ^ d[6] ^ d[5] ^ d[2] ^ c[1] ^ c[8] ^ c[9] ^ c[11] ^ c[12] ^ c[14] ^ c[17] ^ c[18] ^ c[19] ^ c[22] ^ c[24] ^ c[25] ^ c[27] ^ c[29] ^ c[30] ^ c[31];
    newcrc[29] = d[63] ^ d[62] ^ d[60] ^ d[58] ^ d[57] ^ d[55] ^ d[52] ^ d[51] ^ d[50] ^ d[47] ^ d[45] ^ d[44] ^ d[42] ^ d[41] ^ d[34] ^ d[31] ^ d[29] ^ d[28] ^ d[27] ^ d[26] ^ d[25] ^ d[23] ^ d[22] ^ d[21] ^ d[13] ^ d[9] ^ d[7] ^ d[6] ^ d[3] ^ c[2] ^ c[9] ^ c[10] ^ c[12] ^ c[13] ^ c[15] ^ c[18] ^ c[19] ^ c[20] ^ c[23] ^ c[25] ^ c[26] ^ c[28] ^ c[30] ^ c[31];
    newcrc[30] = d[63] ^ d[61] ^ d[59] ^ d[58] ^ d[56] ^ d[53] ^ d[52] ^ d[51] ^ d[48] ^ d[46] ^ d[45] ^ d[43] ^ d[42] ^ d[35] ^ d[32] ^ d[30] ^ d[29] ^ d[28] ^ d[27] ^ d[26] ^ d[24] ^ d[23] ^ d[22] ^ d[14] ^ d[10] ^ d[8] ^ d[7] ^ d[4] ^ c[0] ^ c[3] ^ c[10] ^ c[11] ^ c[13] ^ c[14] ^ c[16] ^ c[19] ^ c[20] ^ c[21] ^ c[24] ^ c[26] ^ c[27] ^ c[29] ^ c[31];
    newcrc[31] = d[62] ^ d[60] ^ d[59] ^ d[57] ^ d[54] ^ d[53] ^ d[52] ^ d[49] ^ d[47] ^ d[46] ^ d[44] ^ d[43] ^ d[36] ^ d[33] ^ d[31] ^ d[30] ^ d[29] ^ d[28] ^ d[27] ^ d[25] ^ d[24] ^ d[23] ^ d[15] ^ d[11] ^ d[9] ^ d[8] ^ d[5] ^ c[1] ^ c[4] ^ c[11] ^ c[12] ^ c[14] ^ c[15] ^ c[17] ^ c[20] ^ c[21] ^ c[22] ^ c[25] ^ c[27] ^ c[28] ^ c[30];
    NextCRC_D64 = newcrc;
    end
endfunction

//Encryption end
endmodule        
        
        