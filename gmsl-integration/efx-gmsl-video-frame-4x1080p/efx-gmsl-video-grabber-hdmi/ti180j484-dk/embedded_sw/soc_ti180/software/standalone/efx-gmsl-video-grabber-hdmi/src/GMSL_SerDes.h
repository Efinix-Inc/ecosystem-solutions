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

#ifndef SRC_GMSL_SERDES_H_
#define SRC_GMSL_SERDES_H_

#define GMSL_CSI2_LANES 4

#include "bsp.h"
#include "i2c.h"
//#include "i2cDemo.h" //BSP
//#include "../i2c/i2cDemo/src/userDef.h"

#define GMSL_Ser_I2C_addr  0x40 //0x80 <<1
#define GMSl_Des_I2C_addr  0x28 //0x50 <<1

//#define Serializer_Part  MAX96793
//#define Deserializer_Part MAX96792A

//Port Map for the Serializer (MAX96783)


#define REG_GMSL_SER_MIPI_RX_Base 0x330
#define REG_GMSL_SER_MIPI_RX_0 (REG_GMSL_SER_MIPI_RX_Base+0 )
#define REG_GMSL_SER_MIPI_RX_1 (REG_GMSL_SER_MIPI_RX_Base+1 )

#define REG_GMSL_SER_GPIO_BASE 0x2BE
#define REG_GMSL_SER_GPIO_0_A  (REG_GMSL_SER_GPIO_BASE +0)
#define REG_GMSL_SER_GPIO_0_B  (REG_GMSL_SER_GPIO_BASE +1)
#define REG_GMSL_SER_GPIO_0_C  (REG_GMSL_SER_GPIO_BASE +2)
#define REG_GMSL_SER_GPIO_1_A  (REG_GMSL_SER_GPIO_BASE +3)
#define REG_GMSL_SER_GPIO_1_B  (REG_GMSL_SER_GPIO_BASE +4)
#define REG_GMSL_SER_GPIO_1_C  (REG_GMSL_SER_GPIO_BASE +5)
#define REG_GMSL_SER_GPIO_2_A  (REG_GMSL_SER_GPIO_BASE +6)
#define REG_GMSL_SER_GPIO_2_B  (REG_GMSL_SER_GPIO_BASE +7)
#define REG_GMSL_SER_GPIO_2_C  (REG_GMSL_SER_GPIO_BASE +8)





//Port Map for the Deserializer (MAX96782A)

#define REG_GMSL_DES_MIPI_TX0_BASE 	0x400
#define REG_GMSL_DES_MIPI_TX0_TX10 	(REG_GMSL_DES_MIPI_TX0_BASE +10)

#define REG_GMSL_DES_MIPI_TX1_BASE 	0x440
#define REG_GMSL_DES_MIPI_TX1_TX10 	(REG_GMSL_DES_MIPI_TX1_BASE +10)
#define REG_GMSL_DES_MIPI_TX1_TX52 	(REG_GMSL_DES_MIPI_TX1_BASE +52)



#define REG_GMSL_DES_MIPI_TX2_BASE 	0x480
#define REG_GMSL_DES_MIPI_TX2_TX10 	(REG_GMSL_DES_MIPI_TX2_BASE +10)
#define REG_GMSL_DES_MIPI_TX2_TX52 	(REG_GMSL_DES_MIPI_TX2_BASE +52)


#define REG_GMSL_DES_MIPI_TX3_BASE 	0x4C0
#define REG_GMSL_DES_MIPI_TX3_TX10 	(REG_GMSL_DES_MIPI_TX3_BASE +10)

		//40A
	   //44A
	   //474 //TX52
	   //48A
	   //4B4
	   //4CA


#define REG_GMSL_DES_BACKTOP_BASE 	0x300
#define REG_GMSL_DES_BACKTOP25 	(REG_GMSL_DES_BACKTOP_BASE +0x20)
#define REG_GMSL_DES_BACKTOP28 	(REG_GMSL_DES_BACKTOP_BASE +0x23)


int GMSL_Ser_WriteRegData(u16 reg,u8 data);
int GMSL_Des_WriteRegData(u16 reg,u8 data);
u8  GMSL_Ser_ReadRegData(u16 reg);
u8  GMSL_Des_ReadRegData(u16 reg);


int GMSL_SerDes_init(void);



#endif /* SRC_GMSL_SERDES_H_ */
