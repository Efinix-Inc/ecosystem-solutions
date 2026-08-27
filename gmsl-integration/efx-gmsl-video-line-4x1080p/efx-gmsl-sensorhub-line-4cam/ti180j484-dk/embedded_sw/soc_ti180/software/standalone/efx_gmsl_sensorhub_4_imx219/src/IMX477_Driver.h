////////////////////////////////////////////////////////////////////////////
//           _____
//          / _______    Copyright (C) 2013-2022 Efinix Inc. All rights reserved.
//         / /       \
//        / /  ..    /
//       / / .'     /
//    __/ /.'      /     Description:
//   __   \       /       Imx477 camera initial file for TI180M484 dev kit OOB design
//  /_/ /\ \_____/ /
// ____/  \_______/
//
// ***********************************************************************

#ifndef SRC_IMX477_DRIVER_H_
#define SRC_IMX577_DRIVER_H_

#include "bsp.h"
#include "i2c.h"
//#include "i2cDemo.h" //BSP
//#include "../i2c/i2cDemo/src/userDef.h"

#define IMX477_REG_VALUE_08BIT		1
#define IMX477_REG_VALUE_16BIT		2

/* Chip ID */
#define IMX477_REG_CHIP_ID		0x0016
#define IMX477_CHIP_ID			0x0477
#define IMX378_CHIP_ID			0x0378

#define IMX477_REG_MODE_SELECT		0x0100
#define IMX477_MODE_STANDBY		0x00
#define IMX477_MODE_STREAMING		0x01

#define IMX477_REG_ORIENTATION		0x101

#define IMX477_XCLK_FREQ		24000000

#define IMX477_DEFAULT_LINK_FREQ	450000000

/* Pixel rate is fixed at 840MHz for all the modes */
#define IMX477_PIXEL_RATE		840000000

/* V_TIMING internal */
#define IMX477_REG_FRAME_LENGTH		0x0340
#define IMX477_FRAME_LENGTH_MAX		0xffdc

/* Long exposure multiplier */
#define IMX477_LONG_EXP_SHIFT_MAX	7
#define IMX477_LONG_EXP_SHIFT_REG	0x3100

/* Exposure control */
#define IMX477_REG_EXPOSURE		0x0202
#define IMX477_EXPOSURE_OFFSET		22
#define IMX477_EXPOSURE_MIN		20
#define IMX477_EXPOSURE_STEP		1
#define IMX477_EXPOSURE_DEFAULT		0x640
#define IMX477_EXPOSURE_MAX		(IMX477_FRAME_LENGTH_MAX - \
					 IMX477_EXPOSURE_OFFSET)

/* Analog gain control */
#define IMX477_REG_ANALOG_GAIN		0x0204
#define IMX477_ANA_GAIN_MIN		0
#define IMX477_ANA_GAIN_MAX		978
#define IMX477_ANA_GAIN_STEP		1
#define IMX477_ANA_GAIN_DEFAULT		0x0

/* Digital gain control */
#define IMX477_REG_DIGITAL_GAIN		0x020e
#define IMX477_DGTL_GAIN_MIN		0x0100
#define IMX477_DGTL_GAIN_MAX		0xffff
#define IMX477_DGTL_GAIN_DEFAULT	0x0100
#define IMX477_DGTL_GAIN_STEP		1


/*#define IMX477_DIG_GAIN_GR_HI       0x020E
#define IMX477_DIG_GAIN_GR_LO       0x020F
#define IMX477_DIG_GAIN_R_HI        0x0210
#define IMX477_DIG_GAIN_R_LO        0x0211
#define IMX477_DIG_GAIN_B_HI        0x0212
#define IMX477_DIG_GAIN_B_LO        0x0213
#define IMX477_DIG_GAIN_GB_HI       0x0214
#define IMX477_DIG_GAIN_GB_LO       0x0215
*/

/* Sony IMX477 Digital Gain Register Map (U8.8 Format) */
#define IMX477_DIG_GAIN_R_HI         0x020E  /* Red High Byte */
#define IMX477_DIG_GAIN_R_LO         0x020F  /* Red Low Byte */

#define IMX477_DIG_GAIN_GR_HI        0x0210  /* Green (Red row) High Byte */
#define IMX477_DIG_GAIN_GR_LO        0x0211  /* Green (Red row) Low Byte */

#define IMX477_DIG_GAIN_GB_HI        0x0212  /* Green (Blue row) High Byte */
#define IMX477_DIG_GAIN_GB_LO        0x0213  /* Green (Blue row) Low Byte */

#define IMX477_DIG_GAIN_B_HI         0x0214  /* Blue High Byte */
#define IMX477_DIG_GAIN_B_LO         0x0215  /* Blue Low Byte */


/* Test Pattern Control */
#define IMX477_REG_TEST_PATTERN		0x0600
#define IMX477_TEST_PATTERN_DISABLE	0
#define IMX477_TEST_PATTERN_SOLID_COLOR	1
#define IMX477_TEST_PATTERN_COLOR_BARS	2
#define IMX477_TEST_PATTERN_GREY_COLOR	3
#define IMX477_TEST_PATTERN_PN9		4

/* Test pattern colour components */
#define IMX477_REG_TEST_PATTERN_R	0x0602
#define IMX477_REG_TEST_PATTERN_GR	0x0604
#define IMX477_REG_TEST_PATTERN_B	0x0606
#define IMX477_REG_TEST_PATTERN_GB	0x0608
#define IMX477_TEST_PATTERN_COLOUR_MIN	0
#define IMX477_TEST_PATTERN_COLOUR_MAX	0x0fff
#define IMX477_TEST_PATTERN_COLOUR_STEP	1
#define IMX477_TEST_PATTERN_R_DEFAULT	IMX477_TEST_PATTERN_COLOUR_MAX
#define IMX477_TEST_PATTERN_GR_DEFAULT	0
#define IMX477_TEST_PATTERN_B_DEFAULT	0
#define IMX477_TEST_PATTERN_GB_DEFAULT	0

/* Trigger mode */
#define IMX477_REG_MC_MODE		0x3f0b
#define IMX477_REG_MS_SEL		0x3041
#define IMX477_REG_XVS_IO_CTRL		0x3040
#define IMX477_REG_EXTOUT_EN		0x4b81

/* Embedded metadata stream structure */
#define IMX477_EMBEDDED_LINE_WIDTH 16384
#define IMX477_NUM_EMBEDDED_LINES 1


#define IMX477_REG_CSI_LANE_MODE	0x0114
//03: 4Lane
//01: 2Lane

int imx477_init(void);
int imx477_WriteRegData(u16 reg,u8 data);
u8 imx477_ReadRegData(u16 reg);


#endif /* SRC_IMX477_DRIVER_H_ */
