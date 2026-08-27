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
#ifndef USERDEF_H_
#define USERDEF_H_

#include <stdlib.h>
#include <string.h>
#include "soc.h"
#include "compatibility.h"
#include "bsp.h"
/************************** Hardware Header File ***************************/
#define VERSION "3.1"
#define UART_0	SYSTEM_UART_0_IO_APB
#define APB_0	IO_APB_SLAVE_0_APB
#define APB_1	IO_APB_SLAVE_1_APB



#define DDR_SADDR  0x010000
#define PROBE_ADDR IO_APB_SLAVE_2_APB
#define I2C_CTRL_MIPI	SYSTEM_I2C_0_IO_APB
//#define I2C_CTRL_HDMI	SYSTEM_I2C_1_IO_APB


#define mem ((volatile uint32_t*)0x010000) // DDR Start Address of Ruby
#define MAX_WORDS (1* 1024 * 1024)


/************************** Main Header File ***************************/
#define DEBUG_PRINTF_EN  0

/************************** SDHC Header File ***************************/
#define MAX_CLK_FREQ   50000//KHz
#define SD_CLK_FREQ   MAX_CLK_FREQ//KHz
#define SDHC_ADDR     0x100
#define BLOCK_SIZE    0x200
#define MAX_BLK_BUF   0x100
#define DATA_WIDTH    0x2 //0x0:1-bit mode; 0x2:4-bit mode;


/************************** INTC Header File *****************************/
#define INT_ENABLE  0xffffffcf

#define INT_COMMAND_COMPLETE      0x1
#define INT_TRANSFER_COMPLETE     0x2
#define INT_BLOCK_GAP_EVENT       0x4
#define INT_BUFFER_WRITE_READY    0x10
#define INT_BUFFER_READ_READY     0x20
#define INT_CARD_INSERTION        0x40
#define INT_CARD_REMOVAL          0x80
#define INT_COMMAND_TIMEOUT_ERROR 0x10000
#define INT_COMMAND_CRC_ERROR     0x20000
#define INT_COMMAND_END_BIT_ERROR 0x40000
#define INT_COMMAND_INDEX_ERROR   0x80000
#define INT_DATA_CRC_ERROR        0x200000





/************************** APB3 Slave Port *************************************/
#define APB3_SLV0_REG0_ID   		 0  //Read ID
#define APB3_SLV0_REG1_LED   		 4  //LED Control
#define APB3_SLV0_REG2_STREAM_CTRL   8  //Streaming control Bit0 (Stream In), Bit1 (stream Out)
#define APB3_SLV0_REG3_RGB		   	 12 //RGB Gain Control
#define APB3_SLV0_REG4_DEBUG	   	 16 //Debug Register

#define APB3_SLV_REG5_SW_IN    		20 //switch Input
#define APB3_SLV_REG6_UVC_STATUS    24 //uvc status
#define APB3_SLV_REG7_UVC_CONTROL   28 //uvc control
#define APB3_SLV_REG8_UVC_X_START   32 //uvc x_start
#define APB3_SLV_REG9_UVC_X_END	    36 //uvc x_end
#define APB3_SLV_REG10_UVC_Y_START  40 //uvc y_start
#define APB3_SLV_REG11_UVC_Y_END  	44 //uvc y_end
#define APB3_SLV_REG12_I2C_CAM_SEL  	48 //I2C CAM Selection
#define APB3_SLV_REG12_I2C_DEBAYER_SEL  	52 //I2C CAM Selection


#define APB3_SLV_REG_CONSTANT_ID         0*4
#define APB3_SLV_REG_LED_CONTROL         1*4
#define APB3_SLV_REG_STREAM_COTNROL      2*4      //preserved
#define APB3_SLV_REG_DEBAYER_RGB_GAIN    3*4
#define APB3_SLV_REG_DEBUG_REG           4*4
#define APB3_SLV_REG_SWITCH_INPUT        5*4
#define APB3_SLV_REG_UVC_STATUS          6*4      //preserved
#define APB3_SLV_REG_UVC_CONTROL         7*4      //preserved
#define APB3_SLV_REG_UVC_X_START         8*4      //preserved
#define APB3_SLV_REG_UVC_X_END           9*4      //preserved
#define APB3_SLV_REG_UVC_Y_START         10*4     //preserved
#define APB3_SLV_REG_UVC_Y_END           11*4     //preserved
#define APB3_SLV_REG_I2C_SEL             12*4     //preserved
#define APB3_SLV_REG_DEBAYER_SEL         13*4     //preserved

#define APB3_SLV_REG_STREAM_IN           14*4
#define APB3_SLV_REG_STREAM_OUT          15*4

#define APB3_SLV_REG_HARD_CONFIG         16*4

#define APB3_SLV_REG_FRAMESIZE_CH0       17*4
#define APB3_SLV_REG_FRAMESIZE_CH1       18*4
#define APB3_SLV_REG_FRAMESIZE_CH2       19*4
#define APB3_SLV_REG_FRAMESIZE_CH3       20*4


#define OOB_APB_SLV		IO_APB_SLAVE_1_APB
#define SDHC_APB_SLV	IO_APB_SLAVE_2_APB
#define DMA_APB_SLV		IO_APB_SLAVE_3_APB
#define CS_SG_APB_SLV	IO_APB_SLAVE_4_APB






/************************** Streaming Control ***********************************/

#define DMASG_BASE		DMA_APB_SLV
#define DMASG_OP0		0
#define DMASG_OP1		1
#define DMASG_OP2		2
#define DMASG_OP3		3
#define DMASG_OP4		4
#define DMASG_OP5		5
#define DMASG_OP6		6




#define DMASG_CHANNEL0 	DMASG_OP0  //Video RX0 In
#define DMASG_CHANNEL1  DMASG_OP1  //Video RX1 In
#define DMASG_CHANNEL2 	DMASG_OP2  //Video RX2 In
#define DMASG_CHANNEL3 	DMASG_OP3  //Video RX3 In


#define DMASG_CHANNEL4 	DMASG_OP4 //Video Out ch2
#define DMASG_CHANNEL6 	DMASG_OP6 //Video Out ch2


#define DMASG_CHANNEL_HDMI		DMASG_OP4	//Video Out Ch1
#define DMASG_CHANNEL_OVERLAY	DMASG_OP5	//Video Out Ch1
#define DMASG_CHANNEL_DUMMY_CSI	DMASG_OP6	//Video Out Ch1





#define FRAME_X_RX  (3840)
#define FRAME_Y_RX  (2160)
#define FRAME_SIZE_RX  (FRAME_X_RX *FRAME_Y_RX/4 )

#define FRAME_X_HDMI  (1920)
#define FRAME_Y_HDMI  (1080)
#define FRAME_SIZE_HDMI  (FRAME_X_HDMI *FRAME_Y_HDMI/4 )

#define FRAME_X_TX  (1920)
#define FRAME_Y_TX  (1080)
#define FRAME_SIZE_TX  (FRAME_X_TX *FRAME_Y_TX/4 )


#define FRAME_SIZE_display  (1920*1080/4)  //(1920*1080/4)



#define FRAME1_ADDR mem
#define FRAME2_ADDR mem+FRAME_SIZE


#define BRIGHTNESS_DEFAULT  0x40400
#define BRIGHTNESS_MAX	 	0xfffff
#define BRIGHTNESS_MIN	    0x200
#define BRIGHTNESS_STEP	    0x200


#define GAIN_R_DEFAULT  0xA00
#define GAIN_R_MAX	 	0xfff
#define GAIN_R_MIN	    0x000
#define GAIN_R_STEP	    0x080

#define GAIN_G_DEFAULT  0x800
#define GAIN_G_MAX	 	0xfff
#define GAIN_G_MIN	    0x000
#define GAIN_G_STEP	    0x080

#define GAIN_B_DEFAULT  0xC00
#define GAIN_B_MAX	 	0xfff
#define GAIN_B_MIN	    0x000
#define GAIN_B_STEP	    0x080




//#define PANEL_APB_SLV	IO_APB_SLAVE_3_APB

#define APB3_REGW(addr, offset, data) \
	write_u32(data, addr+offset)

#define APB3_REGR(addr, offset) \
	read_u32(addr+offset)


#define I2C_CTRL_HZ BSP_CLINT_HZ

#endif
