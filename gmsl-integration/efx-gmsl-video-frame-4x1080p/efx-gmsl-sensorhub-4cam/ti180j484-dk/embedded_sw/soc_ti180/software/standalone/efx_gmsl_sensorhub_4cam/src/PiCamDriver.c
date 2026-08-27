////////////////////////////////////////////////////////////////////////////
//           _____
//          / _______    Copyright (C) 2013-2022 Efinix Inc. All rights reserved.
//         / /       \
//        / /  ..    /
//       / / .'     /
//    __/ /.'      /     Description:
//   __   \       /
//  /_/ /\ \_____/ /
// ____/  \_______/
//
// ***********************************************************************

#include "bsp.h"
#include "i2c.h"
//#include "i2cDemo.h" //From BSP
//#include "../i2c/i2cDemo/src/userDef.h"
#include "riscv.h"
#include "PiCamDriver.h"
#include "common.h"
#include "userdef.h"

#define PiCam_I2C_addr  0x10


int PiCam_WriteRegData(u16 reg,u8 data)
{
	u8 outdata;

    i2c_masterStartBlocking(I2C_CTRL_MIPI);

    i2c_txByte(I2C_CTRL_MIPI, PiCam_I2C_addr<<1);
	i2c_txNackBlocking(I2C_CTRL_MIPI);
	if (assert(i2c_rxAck(I2C_CTRL_MIPI)) ) // Optional check
		return 1;
	i2c_txByte(I2C_CTRL_MIPI, (reg>>8) & 0xFF);
	i2c_txNackBlocking(I2C_CTRL_MIPI);
	if (assert(i2c_rxAck(I2C_CTRL_MIPI)) ) // Optional check
		return 1;
	i2c_txByte(I2C_CTRL_MIPI, (reg) & 0xFF);
	i2c_txNackBlocking(I2C_CTRL_MIPI);
	if (assert(i2c_rxAck(I2C_CTRL_MIPI)) ) // Optional check
		return 1;
	i2c_txByte(I2C_CTRL_MIPI, data & 0xFF);
	i2c_txNackBlocking(I2C_CTRL_MIPI);
	if (assert(i2c_rxAck(I2C_CTRL_MIPI)) ) // Optional check
		return 1;
	i2c_masterStopBlocking(I2C_CTRL_MIPI);

	return 0;
}

u8 PiCam_ReadRegData(u16 reg)
{
	u8 outdata;

    i2c_masterStartBlocking(I2C_CTRL_MIPI);

    i2c_txByte(I2C_CTRL_MIPI, PiCam_I2C_addr<<1);
	i2c_txNackBlocking(I2C_CTRL_MIPI);
	assert(i2c_rxAck(I2C_CTRL_MIPI)); // Optional check

	i2c_txByte(I2C_CTRL_MIPI, (reg>>8) & 0xFF);
	i2c_txNackBlocking(I2C_CTRL_MIPI);
	assert(i2c_rxAck(I2C_CTRL_MIPI)); // Optional check

	i2c_txByte(I2C_CTRL_MIPI, (reg) & 0xFF);
	i2c_txNackBlocking(I2C_CTRL_MIPI);
	assert(i2c_rxAck(I2C_CTRL_MIPI)); // Optional check

	i2c_masterStopBlocking(I2C_CTRL_MIPI);
	i2c_masterStartBlocking(I2C_CTRL_MIPI);

	i2c_txByte(I2C_CTRL_MIPI, (PiCam_I2C_addr<<1) | 0x01);
	i2c_txNackBlocking(I2C_CTRL_MIPI);
	assert(i2c_rxAck(I2C_CTRL_MIPI)); // Optional check

	i2c_txByte(I2C_CTRL_MIPI, 0xFF);
	i2c_txNackBlocking(I2C_CTRL_MIPI);
	assert(i2c_rxNack(I2C_CTRL_MIPI)); // Optional check
	outdata = i2c_rxData(I2C_CTRL_MIPI);

	i2c_masterStopBlocking(I2C_CTRL_MIPI);

	return outdata;
}
void AccessCommSeq(void)
{
	PiCam_WriteRegData(0x30EB, 0x05);
	PiCam_WriteRegData(0x30EB, 0x0C);
	PiCam_WriteRegData(0x300A, 0xFF);
	PiCam_WriteRegData(0x300B, 0xFF);
	PiCam_WriteRegData(0x30EB, 0x05);
	PiCam_WriteRegData(0x30EB, 0x09);
}

void PiCam_Output_Size(u16 X,u16 Y)
{
	PiCam_WriteRegData(x_output_size_A_1	, X>>8);
	PiCam_WriteRegData(x_output_size_A_0	, X & 0xFF);
	PiCam_WriteRegData(y_output_size_A_1	, Y>>8);
	PiCam_WriteRegData(y_output_size_A_0	, Y & 0xFF);
}

void PiCam_Output_activePixel(u16 XStart,u16 XEnd, u16 YStart, u16 YEnd)
{

	//Max Active pixel 3280* 2464--imx219

	PiCam_WriteRegData(X_ADD_STA_A_1	, XStart>>8);
	PiCam_WriteRegData(X_ADD_STA_A_0	, XStart&0xFF);
	PiCam_WriteRegData(X_ADD_END_A_1	, XEnd>>8);
	PiCam_WriteRegData(X_ADD_END_A_0	, XEnd&0xFF);

	PiCam_WriteRegData(Y_ADD_STA_A_1	, YStart>>8);
	PiCam_WriteRegData(Y_ADD_STA_A_0	, YStart&0xFF);
	PiCam_WriteRegData(Y_ADD_END_A_1	, YEnd>>8);
	PiCam_WriteRegData(Y_ADD_END_A_0	, YEnd&0xFF);
}

void PiCam_Output_activePixelX(u16 XStart,u16 XEnd)
{
	//Max Active pixel 3280* 2464--imx219

	PiCam_WriteRegData(X_ADD_STA_A_1	, XStart>>8);
	PiCam_WriteRegData(X_ADD_STA_A_0	, XStart&0xFF);
	PiCam_WriteRegData(X_ADD_END_A_1	, XEnd>>8);
	PiCam_WriteRegData(X_ADD_END_A_0	, XEnd&0xFF);
}

void PiCam_Output_activePixelY(u16 YStart,u16 YEnd)
{
	//Max Active pixel 3280* 2464--imx219

	PiCam_WriteRegData(Y_ADD_STA_A_1	, YStart>>8);
	PiCam_WriteRegData(Y_ADD_STA_A_0	, YStart&0xFF);
	PiCam_WriteRegData(Y_ADD_END_A_1	, YEnd>>8);
	PiCam_WriteRegData(Y_ADD_END_A_0	, YEnd&0xFF);
}

void PiCam_SetBinningMode(u8 Xmode, u8 Ymode)
{
	//0:no-binning
	//1:x2-binning
	//2:x4-binning
	//3:x2 analog (special)

	if(Xmode>=3)	Xmode=3;
	if(Ymode>=3)	Ymode=3;

	PiCam_WriteRegData(BINNING_MODE_H_A, Xmode);
	PiCam_WriteRegData(BINNING_MODE_V_A, Ymode);
}

void PiCam_Output_ColorBarSize(u16 X,u16 Y)
{
	PiCam_WriteRegData(TP_WINDOW_WIDTH_1	, X>>8);
	PiCam_WriteRegData(TP_WINDOW_WIDTH_0	, X & 0xFF);
	PiCam_WriteRegData(TP_WINDOW_HEIGHT_1	, Y>>8);
	PiCam_WriteRegData(TP_WINDOW_HEIGHT_0	, Y & 0xFF);
}

void PiCam_TestPattern(u8 Enable,u8 mode,u16 X,u16 Y)
{
	//0000h - no pattern (default)
	//0001h - solid color
	//0002h - 100 % color bars
	//0003h - fade to grey color bar
	//0004h - PN9
	//0005h - 16 split color bar
	//0006h - 16 split inverted color bar
	//0007h - column counter
	//0008h - inverted column counter
	//0009h - PN31

	PiCam_WriteRegData(test_pattern_Ena, 0x00);

	if(Enable==0)	mode=0;

	PiCam_WriteRegData(test_pattern_mode, mode);

	PiCam_Output_ColorBarSize(X,Y);
}


void PiCam_TestPatternColur (u16 X,u16 Y, u16 r,u16 gr, u16 b, u16 gb)
{
	//0000h - no pattern (default)
	//0001h - solid color
	//0002h - 100 % color bars
	//0003h - fade to grey color bar
	//0004h - PN9
	//0005h - 16 split color bar
	//0006h - 16 split inverted color bar
	//0007h - column counter
	//0008h - inverted column counter
	//0009h - PN31

	PiCam_WriteRegData(test_pattern_Ena, 0x00);
	PiCam_WriteRegData(test_pattern_mode, 0x01);

	PiCam_WriteRegData(TD_R_1, ((u8)((r>>8) & 0x03)));
	PiCam_WriteRegData(TD_R_0, ((u8)(r&0xff)));

	PiCam_WriteRegData(TD_GR_1, (u8)((gr>>8) & 0x03));
	PiCam_WriteRegData(TD_GR_0, ((u8)(gr&0xff)));

	PiCam_WriteRegData(TD_B_1, ((u8)((b>>8) & 0x03)));
	PiCam_WriteRegData(TD_B_0, ((u8)(gb&0xff)));

	PiCam_WriteRegData(TD_GB_1, ((u8)((gb>>8) & 0x03)));
	PiCam_WriteRegData(TD_GB_0, ((u8)(gb&0xff)));

	PiCam_Output_ColorBarSize(X,Y);


}




int PiCam_Gainfilter(u8 AGain, u16 DGain)
{
	if(PiCam_WriteRegData(ANA_GAIN_GLOBAL_A, AGain&0xFF) )
		return 1;
	PiCam_WriteRegData(DIG_GAIN_GLOBAL_A_1, (DGain>>8)&0x0F);
	PiCam_WriteRegData(DIG_GAIN_GLOBAL_A_0, DGain&0xFF);
}



int PiCam_init(void)
{
   if (PiCam_WriteRegData(mode_select, 0x00) )
	   return 1;
   AccessCommSeq();
   PiCam_WriteRegData(CSI_LANE_MODE, 0x01);
   PiCam_WriteRegData(DPHY_CTRL, 0x00);
   PiCam_WriteRegData(EXCK_FREQ_1, 0x18);
   PiCam_WriteRegData(EXCK_FREQ_0, 0x00);

   PiCam_WriteRegData(FRM_LENGTH_A_1, 0x04);
   PiCam_WriteRegData(FRM_LENGTH_A_0, 0x59);

   PiCam_WriteRegData(LINE_LENGTH_A_1, 0x0D);
   PiCam_WriteRegData(LINE_LENGTH_A_0, 0x78);

//  PiCam_Output_activePixel(0, 3279, 0, 2463);
   PiCam_Output_activePixel(680, 2599, 690, 1771);
 //PiCam_Output_activePixel(0, 1080, 0, 1920);


 //PiCam_Output_Size(1080,1920);
   PiCam_Output_Size(1920,1080);
   //PiCam_Output_Size(1280, 720);
   //PiCam_Output_Size(640, 480);

   PiCam_WriteRegData(X_ODD_INC_A, 0x01);
   PiCam_WriteRegData(Y_ODD_INC_A, 0x01);

   //0: No binning; 1: x2 binning; 2: x4 binning; 3: x2 binning (analog special)
   PiCam_SetBinningMode(0, 0);

   PiCam_WriteRegData(CSI_DATA_FORMAT_A_1, 0x0A);
   PiCam_WriteRegData(CSI_DATA_FORMAT_A_0, 0x0A);

   PiCam_WriteRegData(VTPXCK_DIV, 0x05);
   PiCam_WriteRegData(VTSYCK_DIV, 0x01);
   PiCam_WriteRegData(PREPLLCK_VT_DIV, 0x03);
   PiCam_WriteRegData(PREPLLCK_OP_DIV, 0x03);
   PiCam_WriteRegData(PLL_VT_MPY_1, 0x00);
//   PiCam_WriteRegData(PLL_VT_MPY_0, 0x39);
   PiCam_WriteRegData(PLL_VT_MPY_0, 0x60);//0x70);
   PiCam_WriteRegData(OPPXCK_DIV, 0x0A);
   PiCam_WriteRegData(OPSYCK_DIV, 0x01);
   PiCam_WriteRegData(PLL_OP_MPY_1, 0x00);
   PiCam_WriteRegData(PLL_OP_MPY_0, 0x72);

   PiCam_WriteRegData(OPPXCK_DIV, 0x0A);
   PiCam_WriteRegData(OPSYCK_DIV, 0x01);
   PiCam_WriteRegData(PLL_OP_MPY_1, 0x00);
   PiCam_WriteRegData(PLL_OP_MPY_0, 0x72);


   // PiCam_WriteRegData(0x455E	,0x00);
   // PiCam_WriteRegData(0x471E	,0x4B);
   // PiCam_WriteRegData(0x4767	,0x0F);
   // PiCam_WriteRegData(0x4750	,0x14);
   // PiCam_WriteRegData(0x4540	,0x00);
   // PiCam_WriteRegData(0x47B4	,0x14);
   // PiCam_WriteRegData(0x4713	,0x30);
   // PiCam_WriteRegData(0x478B	,0x10);
   // PiCam_WriteRegData(0x478F	,0x10);
   // PiCam_WriteRegData(0x4793	,0x10);
   // PiCam_WriteRegData(0x4797	,0x0E);
   // PiCam_WriteRegData(0x479B	,0x0E);

 //  PiCam_TestPattern(1,0x0002,1920,1080);
  // PiCam_TestPattern(1,0x0007,1920,1080);
   //PiCam_TestPatternColur (0,0, u16 r,u16 gr, u16 b, u16 gb)
 //  PiCam_TestPatternColur (1920,1080, 0xffff, 0x0000, 0x0000, 0x0000);
//G
  // PiCam_TestPatternColur (1920,1080, 0x0000, 0xffff,  0x0000, 0x0000);
   //B
   //PiCam_TestPatternColur (1920,1080, 0x0000, 0x0000, 0xffff, 0x0000);
      //B
//   PiCam_TestPatternColur (1920,1080, 0x0000, 0x0000, 0x0000, 0xffff);
//        //R





//   PiCam_Gainfilter(0xB9, 0x200);
 //  PiCam_Gainfilter(0xEA, 0x200);
   PiCam_Gainfilter(0x40, 0x200);


   //Shorter camera exposure time, suitable for standard light condition. Higher frame rate.
   PiCam_WriteRegData(FRM_LENGTH_A_1, 0x06);
   PiCam_WriteRegData(FRM_LENGTH_A_0, 0xe3);
   PiCam_WriteRegData(LINE_LENGTH_A_1, 0x0D);
    PiCam_WriteRegData(LINE_LENGTH_A_0, 0x78);
   PiCam_WriteRegData(COARSE_INTEGRATION_TIME_A_1, 0x04);
     PiCam_WriteRegData(COARSE_INTEGRATION_TIME_A_0, 0x54);



     //Gain Tunning for RGB
	 PiCam_WriteRegData(LSC_ENABLE, 0x01);
     PiCam_WriteRegData(LSC_COLOR_MODE, 0x00);
     PiCam_WriteRegData(LSC_TUNING_ENABLE, 0x01);
     PiCam_WriteRegData(LSC_WHITE_BALANCE_RG_1, 0x00);
     PiCam_WriteRegData(LSC_WHITE_BALANCE_RG_0, 0x00);
     PiCam_WriteRegData(LSC_TUNING_COEF_R, 0x00);
     PiCam_WriteRegData(LSC_TUNING_COEF_GR, 0xf0);
     PiCam_WriteRegData(LSC_TUNING_COEF_GB, 0xf0);
     PiCam_WriteRegData(LSC_TUNING_COEF_B, 0x00);


     PiCam_WriteRegData(gain_r_1, 0x0A);
     PiCam_WriteRegData(gain_r_0, 0x00);

     PiCam_WriteRegData(gain_GR_1, 0x08);
     PiCam_WriteRegData(gain_GR_0, 0x00);

     PiCam_WriteRegData(gain_GB_1, 0x08);
     PiCam_WriteRegData(gain_GB_0, 0x00);

     PiCam_WriteRegData(gain_B_1, 0x0C);
     PiCam_WriteRegData(gain_B_0, 0x00);

     PiCam_WriteRegData(gain_BLACKLEVEL_1, 0x00);
     PiCam_WriteRegData(gain_BLACKLEVEL_0, 0x60);

 /*  PiCam_WriteRegData(FRM_LENGTH_A_1, 0x07);
   PiCam_WriteRegData(FRM_LENGTH_A_0, 0x90);


   PiCam_WriteRegData(LINE_LENGTH_A_1, 0x0D);
   PiCam_WriteRegData(LINE_LENGTH_A_0, 0x78);

   PiCam_WriteRegData(COARSE_INTEGRATION_TIME_A_1, 0x03);
   PiCam_WriteRegData(COARSE_INTEGRATION_TIME_A_0, 0x00);
   PiCam_WriteRegData(COARSE_INTEGRATION_TIME_B_1, 0x03);
    PiCam_WriteRegData(COARSE_INTEGRATION_TIME_B_0, 0x00);*/

/*
   //Longer camera exposure time, suitable for low light condition. Trade-off with lower frame rate.
   PiCam_WriteRegData(FRM_LENGTH_A_1, 0x0A);
   PiCam_WriteRegData(FRM_LENGTH_A_0, 0xA8);
   PiCam_WriteRegData(COARSE_INTEGRATION_TIME_A_1, 0x0A);
   PiCam_WriteRegData(COARSE_INTEGRATION_TIME_A_0, 0x54);
*/

 //  PiCam_WriteRegData(IMG_ORIENTATION_A, 0x02);
     PiCam_WriteRegData(IMG_ORIENTATION_A, 0x00);

     PiCam_WriteRegData(mode_select, 0x01);

   return 0;
}

/*
     {0x0100, 0x00, 0},
	{0x30EB, 0x05, 0},
	{0x30EB, 0x0C, 0},
	{0x300A, 0xFF, 0},
	{0x300B, 0xFF, 0},
	{0x30EB, 0x05, 0},
	{0x30EB, 0x09, 0},
	{0x0114, 0x01, 0},
	{0x0128, 0x00, 0},
	{0x012A, 0x18, 0},
	{0x012B, 0x00, 0},
    {0x015A, 0x04, 0},
    {0x015B, 0x6C, 0},
    {0x0157, 0xE6, 0},
    {0x0160, 0x06, 0},
    {0x0161, 0xE3, 0},
	{0x0162, 0x0D, 0},
	{0x0163, 0x78, 0},
	{0x0164, 0x02, 0},
	{0x0165, 0xA8, 0},
	{0x0166, 0x0A, 0},
	{0x0167, 0x37, 0},
	{0x0168, 0x02, 0},
	{0x0169, 0xB4, 0},
	{0x016A, 0x06, 0},
	{0x016B, 0xEC, 0},
	{0x016C, 0x07, 0},
	{0x016D, 0x90, 0},
	{0x016E, 0x04, 0},
	{0x016F, 0x39, 0},
	{0x0170, 0x01, 0},
	{0x0171, 0x01, 0},
	{0x0174, 0x00, 0},
	{0x0175, 0x00, 0},
	{0x018C, 0x0A, 0},
	{0x018D, 0x0A, 0},
	{0x0301, 0x05, 0},
	{0x0303, 0x01, 0},
	{0x0304, 0x03, 0},
	{0x0305, 0x03, 0},
	{0x0306, 0x00, 0},
	{0x0307, 0x39, 0},
	{0x0309, 0x0A, 0},
	{0x030B, 0x01, 0},
	{0x030C, 0x00, 0},
	{0x030D, 0x72, 0},
	{0x0624, 0x07, 0},
	{0x0625, 0x80, 0},
	{0x0626, 0x04, 0},
	{0x0627, 0x38, 0},
	{0x455E, 0x00, 0},
	{0x471E, 0x4B, 0},
	{0x4767, 0x0F, 0},
	{0x4750, 0x14, 0},
	{0x4540, 0x00, 0},
	{0x47B4, 0x14, 0},
	{0x4713, 0x30, 0},
	{0x478B, 0x10, 0},
	{0x478F, 0x10, 0},
	{0x4793, 0x10, 0},
	{0x4797, 0x0E, 0},
	{0x479B, 0x0E, 0},
	{0x0100, 0x01, 0},
    {0x0190, 0x01, 0},
    {0x0191, 0x00, 0},
    {0x0193, 0x01, 0},
    {0x0194, 0x00, 0},
    {0x0195, 0x00, 0},
    {0x0198, 0x00, 0},
    {0x0199, 0xF0, 0},
    {0x019A, 0xF0, 0},
    {0x019B, 0x00, 0},
    {0x019C, 0x0A, 0},  //R
    {0x019D, 0x00, 0},  //R
    {0x019E, 0x07, 0},  //GR
    {0x019F, 0x00, 0},  //GR
    {0x01A0, 0x07, 0},  //GB
    {0x01A1, 0x00, 0},  //GB
    {0x01A2, 0x0C, 0},  //B
    {0x01A3, 0x00, 0},  //B
    {0xD1EA, 0x00, 0},  //BLACK LEVEL
    {0xD1EB, 0x60, 0}   //BLACK LEVEL
 */
