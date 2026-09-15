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
#include "GMSL_SerDes.h"
#include "common.h"
#include "userdef.h"





int GMSL_Ser_WriteRegData(u16 reg,u8 data)
{
	u8 outdata;

    i2c_masterStartBlocking(I2C_CTRL_MIPI);

    i2c_txByte(I2C_CTRL_MIPI, GMSL_Ser_I2C_addr<<1);
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

int GMSL_Des_WriteRegData(u16 reg,u8 data)
{
	u8 outdata;

    i2c_masterStartBlocking(I2C_CTRL_MIPI);

    i2c_txByte(I2C_CTRL_MIPI, GMSl_Des_I2C_addr<<1);
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


u8  GMSL_Ser_ReadRegData(u16 reg)
{
	u8 outdata;

    i2c_masterStartBlocking(I2C_CTRL_MIPI);

    i2c_txByte(I2C_CTRL_MIPI, GMSL_Ser_I2C_addr<<1);
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

	i2c_txByte(I2C_CTRL_MIPI, (GMSL_Ser_I2C_addr<<1) | 0x01);
	i2c_txNackBlocking(I2C_CTRL_MIPI);
	assert(i2c_rxAck(I2C_CTRL_MIPI)); // Optional check

	i2c_txByte(I2C_CTRL_MIPI, 0xFF);
	i2c_txNackBlocking(I2C_CTRL_MIPI);
	assert(i2c_rxNack(I2C_CTRL_MIPI)); // Optional check
	outdata = i2c_rxData(I2C_CTRL_MIPI);

	i2c_masterStopBlocking(I2C_CTRL_MIPI);

	return outdata;
}

u8  GMSL_Des_ReadRegData(u16 reg)
{
	u8 outdata;

    i2c_masterStartBlocking(I2C_CTRL_MIPI);

    i2c_txByte(I2C_CTRL_MIPI, GMSl_Des_I2C_addr<<1);
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

	i2c_txByte(I2C_CTRL_MIPI, (GMSl_Des_I2C_addr<<1) | 0x01);
	i2c_txNackBlocking(I2C_CTRL_MIPI);
	assert(i2c_rxAck(I2C_CTRL_MIPI)); // Optional check

	i2c_txByte(I2C_CTRL_MIPI, 0xFF);
	i2c_txNackBlocking(I2C_CTRL_MIPI);
	assert(i2c_rxNack(I2C_CTRL_MIPI)); // Optional check
	outdata = i2c_rxData(I2C_CTRL_MIPI);

	i2c_masterStopBlocking(I2C_CTRL_MIPI);

	return outdata;
}



int GMSL_SerDes_init(void)
{



	// GMSL_Des_WriteRegData(REG_GMSL_DES_MIPI_TX0_TX10, 0x50);      //On Serializer side, Set Mipi CSI-2 Interface to 2Lanes


   if (GMSL_Ser_WriteRegData(REG_GMSL_SER_GPIO_2_A, 0x80) )   //On Serializer side, set Sensor Enable Pin to Low
	   return 1;


   bsp_uDelay(50000);

  GMSL_Ser_WriteRegData(REG_GMSL_SER_MIPI_RX_1, 0x10);      //On Serializer side, Set Mipi CSI-2 Interface to 2Lanes

//   De-Serilizer
//   0x40A = 0x50,
 //  0x44A = 0x50,
 //  0x48A=0x50



   GMSL_Des_WriteRegData(REG_GMSL_DES_MIPI_TX0_TX10, 0x50);      //On Serializer side, Set Mipi CSI-2 Interface to 2Lanes
   GMSL_Des_WriteRegData(REG_GMSL_DES_MIPI_TX1_TX10, 0x50);      //On Serializer side, Set Mipi CSI-2 Interface to 2Lanes
   GMSL_Des_WriteRegData(REG_GMSL_DES_MIPI_TX2_TX10, 0x50);      //On Serializer side, Set Mipi CSI-2 Interface to 2Lanes



   GMSL_Des_WriteRegData(REG_GMSL_DES_BACKTOP25, 0x39); 		//Phy1 2500Mbps
   GMSL_Des_WriteRegData(REG_GMSL_DES_BACKTOP28, 0x39);         //Phy2 2500Mbps


   if (GMSL_Ser_WriteRegData(REG_GMSL_SER_GPIO_2_A, 0x90) )   //On Serializer side, Set Sensor Enable Pin to High
   	   return 1;


   bsp_uDelay(50000);

   return 0;
}
