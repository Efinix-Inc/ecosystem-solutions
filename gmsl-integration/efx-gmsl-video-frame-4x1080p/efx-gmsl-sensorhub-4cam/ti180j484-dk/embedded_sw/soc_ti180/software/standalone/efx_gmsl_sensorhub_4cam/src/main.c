////////////////////////////////////////////////////////////////////////////
//           _____
//          / _______    Copyright (C) 2013-2022 Efinix Inc. All rights reserved.
//         / /       \
//        / /  ..    /
//       / / .'     /
//    __/ /.'      /     Description:
//   __   \       /       Main Controller flow for TI180M484 dev kit OOB design
//  /_/ /\ \_____/ /
// ____/  \_______/
//
// ***********************************************************************

#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include "bsp.h"
#include "userdef.h"
#include "intc.h"
#include "mmc.h"
#include "common.h"
#include "efx_mmc_driver.h"
#include "sdhc_driver.h"
#include "dma_video_Stream.h"
#include "dmasg.h"
#include "PiCamDriver.h"
#include "IMX477_Driver.h"

#include "GMSL_SerDes.h"



#define MAX_SPRIT_LINE		2
#define MAX_LINE_OUT		1080

#define START_MEM_ADDR			0x2000000
#define START_FRAMEBUFFER_ADDR	START_MEM_ADDR
#define START_DESCRIPTOR_ADDR	START_FRAMEBUFFER_ADDR + 0x400000
#define START_SD_BUF_ADDR		START_DESCRIPTOR_ADDR  + 0x100000
#define START_SD_RDBUF_ADDR		START_SD_BUF_ADDR	   + 0x100000
#define START_DESCRIPTOR_ADDR_input		START_SD_RDBUF_ADDR	   + 0x100000
#define START_DESCRIPTOR_ADDR_output		START_DESCRIPTOR_ADDR_input	   + 0x100000


#define mem_framebuffer ((uint32_t*)START_FRAMEBUFFER_ADDR)





#define OutFrameLine

#define IMX477_ENABLE			0
#define GMSL_SerDes_ENABLE			1

uint32_t * framebuffer_ptr[10];

#define descriptors0  ((  struct dmasg_descriptor __attribute__ ((aligned (64))) *   )START_DESCRIPTOR_ADDR)
#define descriptors_input  ((  struct dmasg_descriptor __attribute__ ((aligned (64))) *   )START_DESCRIPTOR_ADDR_input)
#define descriptors_output  ((  struct dmasg_descriptor __attribute__ ((aligned (64))) *   )START_DESCRIPTOR_ADDR_output)




int32_t cam_brightness = BRIGHTNESS_DEFAULT;
int32_t cam_gain_r	   = GAIN_R_DEFAULT;
int32_t cam_gain_g	   = GAIN_G_DEFAULT;
int32_t cam_gain_b	   = GAIN_B_DEFAULT;


#define buf ((char*) START_SD_BUF_ADDR)
#define rd_buf ((char*) START_SD_BUF_ADDR)

u32 lastChannel = DMASG_CHANNEL2;
u32 swithCmdPtr = 0;

#define program_mem ((volatile uint32_t*)(0x1000)) // DDR Start Address of Ruby
#define data_mem ((volatile uint32_t*)(0x100000)) // DDR Start Address of Ruby

void check_sd(u32 testtype);
void cmd_operation(uint8_t key );

void cmd_cam_brightnes(u8 AGain, u16 DGain);
void cmd_cam_colour_gain( u16 gain_r, u16 gain_g, u16 gain_b);


int camStatus[4];

int last_overlay_type = 0;


struct cs_sg_descriptor cs_descriptor_csi_TX[4];
struct cs_sg_descriptor cs_descriptor_csi_RX[4];


volatile struct dmasg_descriptor input_descriptor[40] __attribute__ ((aligned (64)));

void print(uint8_t * data) {
      uart_writeStr(BSP_UART_TERMINAL, data);
    }







void inital_video_stream()
{
	mipi_i2c_init();
	u32 apb3_rd = APB3_REGR(OOB_APB_SLV, APB3_SLV0_REG1_LED);
	apb3_rd &= (~0x07);

	int result;

	for(int i=0;i<FRAME_SIZE*8; i++)
	{
		mem_framebuffer[i] = 0x00000000;
	}
	framebuffer_ptr[0] =  mem_framebuffer;

	framebuffer_ptr[1] =  mem_framebuffer  +FRAME_SIZE*1;
	framebuffer_ptr[2] =  mem_framebuffer  +FRAME_SIZE*2;
	framebuffer_ptr[3] =  mem_framebuffer  +FRAME_SIZE*3;
	framebuffer_ptr[4] =  mem_framebuffer  +FRAME_SIZE*4;


	framebuffer_ptr[5] = mem_framebuffer  +FRAME_SIZE*5;
	framebuffer_ptr[6] = mem_framebuffer  +FRAME_SIZE*6;
	framebuffer_ptr[7] = mem_framebuffer  +FRAME_SIZE*7;
	framebuffer_ptr[8] = mem_framebuffer  +FRAME_SIZE*8;
	framebuffer_ptr[9] = mem_framebuffer  +FRAME_SIZE*9;


	bsp_printf(" Cameras Initial !\n\r");

	mipi_i2c_init();



	for(int x=0; x<4; x++)
	{
		camStatus[x] = 0;
		APB3_REGW(OOB_APB_SLV, APB3_SLV_REG12_I2C_CAM_SEL, x);




		if(GMSL_SerDes_ENABLE==1)
		{

			bsp_printf("GMSL Initial!\n\r",x );
			if(GMSL_SerDes_init())
			{
				bsp_printf("GMSL Serilizer and Deserilizer Initial Error!\n\r",x );
			}
			else {
				bsp_printf("GMSL Serilizer and Deserilizer Initial Done!\n\r",x);
			}
		}


		if (IMX477_ENABLE == 1)
		{
			if(imx477_init())
			{
				bsp_printf("IMX477 Camera %d Initial Error !\n\r",x );
			}
			else {
				camStatus[x] =1;
				bsp_printf("IMX477 Camera %d Initial Done !\n\r",x);
			}

		}
		else {

			if(PiCam_init()){
					bsp_printf("Pi Camera %d Initial Error !\n\r",x );
				}
			else {
				camStatus[x] =1;
				bsp_printf("Pi Camera %d Initial Done !\n\r",x);
			}
		}

		bsp_uDelay(200000);

	}



	APB3_REGW(OOB_APB_SLV, APB3_SLV0_REG1_LED, apb3_rd);

	framebuffer_pattern(framebuffer_ptr[0],0,0); //Buffer for Camera RX0
	framebuffer_pattern(framebuffer_ptr[1],1,1);//Buffer for Camera RX1
	framebuffer_pattern(framebuffer_ptr[2],0,1);//Buffer for Camera RX2
	framebuffer_pattern(framebuffer_ptr[3],1,0);//Buffer for Camera RX3
//	framebuffer_pattern(framebuffer_ptr[5],3,0);//Buffer for Camera RX3
//	framebuffer_overlayFrame(framebuffer_ptr[5], 480, 1440, 270, 810, 8, 1);

	framebuffer_pattern(framebuffer_ptr[5],2,0);//Buffer for Camera
	framebuffer_pattern(framebuffer_ptr[6],2,0);//Buffer for Camera RX3
	framebuffer_pattern(framebuffer_ptr[7],2,0);//Buffer for Camera RX3
	framebuffer_pattern(framebuffer_ptr[8],2,0);//Buffer for Camera RX3
	framebuffer_pattern(framebuffer_ptr[9],2,0);//Buffer for Camera RX3


	u32 start_x = 200 + 0;
	u32 start_y = 200 + 0;
	u32 end_x 	= 200 + 93*4;
	u32 end_y   = 200 + 158;


	framebuffer_loadTable(framebuffer_ptr[5], start_x, end_x, start_y ,end_y ,0 );
	framebuffer_loadTable(framebuffer_ptr[6], start_x, end_x, start_y ,end_y, 1 );
	framebuffer_loadTable(framebuffer_ptr[7], start_x, end_x, start_y ,end_y, 2 );
	framebuffer_loadTable(framebuffer_ptr[8], start_x, end_x, start_y ,end_y, 3 );
	framebuffer_loadTable(framebuffer_ptr[9], start_x, end_x, start_y ,end_y, 4 );



	//framebuffer_pattern(framebuffer_ptr[4],0);//Buffer for Camera RX3
//	framebuffer_overlayMask(framebuffer_ptr[4],0);//Buffer for Overlay Mask
//	framebuffer_overlayFrame(framebuffer_ptr[4], 480, 1440, 270, 810, 8, 1);


	framebuffer_pattern(framebuffer_ptr[4],3,0);//Buffer for Overlay Mask



	dmasg_priority(DMASG_BASE, DMASG_CHANNEL0, 5, 7);
	dmasg_priority(DMASG_BASE, DMASG_CHANNEL1, 5, 7);
	dmasg_priority(DMASG_BASE, DMASG_CHANNEL2, 5, 7);
	dmasg_priority(DMASG_BASE, DMASG_CHANNEL3, 5, 7);
	//dmasg_priority(DMASG_BASE, DMASG_CHANNEL_OVERLAY, 6, 7);
	//dmasg_priority(DMASG_BASE, DMASG_CHANNEL_HDMI, 7, 7);

	//Streaming Input Interrupt configuration
	//dmasg_interrupt_pending_clear(DMASG_BASE,DMASG_CHANNEL0,0xFFFFFFFF);
	dmasg_interrupt_config(DMASG_BASE, DMASG_CHANNEL0, DMASG_CHANNEL_INTERRUPT_INPUT_PACKET_MASK);  //Disable dmasg channel interrupt
	dmasg_interrupt_pending_clear(DMASG_BASE,DMASG_CHANNEL1,0xFFFFFFFF);
	dmasg_interrupt_config(DMASG_BASE, DMASG_CHANNEL1, DMASG_CHANNEL_INTERRUPT_INPUT_PACKET_MASK);  //Disable dmasg channel interrupt
	dmasg_interrupt_pending_clear(DMASG_BASE,DMASG_CHANNEL2,0xFFFFFFFF);
	dmasg_interrupt_config(DMASG_BASE, DMASG_CHANNEL2, DMASG_CHANNEL_INTERRUPT_INPUT_PACKET_MASK);  //Disable dmasg channel interrupt
	dmasg_interrupt_pending_clear(DMASG_BASE,DMASG_CHANNEL3,0xFFFFFFFF);
	dmasg_interrupt_config(DMASG_BASE, DMASG_CHANNEL3, DMASG_CHANNEL_INTERRUPT_INPUT_PACKET_MASK);  //Disable dmasg channel interrupt




	APB3_REGW(OOB_APB_SLV, APB3_SLV_REG_STREAM_IN, 0x00);
	bsp_uDelay(200000);
	dma_video_in_channel_stop(DMASG_CHANNEL0);
	dma_video_in_channel_stop(DMASG_CHANNEL1);
	dma_video_in_channel_stop(DMASG_CHANNEL2);
	dma_video_in_channel_stop(DMASG_CHANNEL3);

	lastChannel = DMASG_CHANNEL0;
	APB3_REGW(OOB_APB_SLV, APB3_SLV_REG_STREAM_IN, 0x00);
	bsp_uDelay(400000);






	cs_descriptor_csi_RX[0].ctrl_word = 0x0002;
	cs_descriptor_csi_RX[0].src_addr =  0;
	cs_descriptor_csi_RX[0].dst_addr = ((u32)(framebuffer_ptr[0] ));
	cs_descriptor_csi_RX[0].nBytes = (u32)(FRAME_SIZE*4)-1;

	cs_descriptor_csi_RX[1].ctrl_word = 0x0002;
	cs_descriptor_csi_RX[1].src_addr = 0;
	cs_descriptor_csi_RX[1].dst_addr = ((u32)(framebuffer_ptr[1] ));
	cs_descriptor_csi_RX[1].nBytes = (u32)(FRAME_SIZE*4)-1;

	cs_descriptor_csi_RX[2].ctrl_word = 0x0002;
	cs_descriptor_csi_RX[2].src_addr = 0;
	cs_descriptor_csi_RX[2].dst_addr = ((u32)(framebuffer_ptr[2] ));
	cs_descriptor_csi_RX[2].nBytes = (u32)(FRAME_SIZE*4)-1;

	cs_descriptor_csi_RX[3].ctrl_word = 0x0002;
	cs_descriptor_csi_RX[3].src_addr = 0;
	cs_descriptor_csi_RX[3].dst_addr = ((u32)(framebuffer_ptr[3] ));
	cs_descriptor_csi_RX[3].nBytes = (u32)(FRAME_SIZE*4)-1;

	//dma_video_in_channel_execution(framebuffer_ptr[0], 	DMASG_CHANNEL0);
	dma_video_in_channel_cs_sg_execution(cs_descriptor_csi_RX, 4, DMASG_CHANNEL0);



//	APB3_REGW(OOB_APB_SLV, APB3_SLV_REG_STREAM_IN, 0x01);

//	bsp_uDelay(400000);
	dma_video_in_channel_execution(framebuffer_ptr[1], 	DMASG_CHANNEL1);
//	dma_video_in_channel_cs_sg_execution(cs_descriptor_csi_RX, 4, DMASG_CHANNEL1);
//	APB3_REGW(OOB_APB_SLV, APB3_SLV_REG_STREAM_IN, 0x03);

//	bsp_uDelay(400000);
	dma_video_in_channel_execution(framebuffer_ptr[2], 	DMASG_CHANNEL2);
//	dma_video_in_channel_cs_sg_execution(cs_descriptor_csi_RX, 4, DMASG_CHANNEL2);
//	APB3_REGW(OOB_APB_SLV, APB3_SLV_REG_STREAM_IN, 0x07);

//	bsp_uDelay(400000);
	dma_video_in_channel_execution(framebuffer_ptr[3],	DMASG_CHANNEL3);
//	dma_video_in_channel_cs_sg_execution(cs_descriptor_csi_RX, 4, DMASG_CHANNEL3);

//	bsp_uDelay(400000);
	APB3_REGW(OOB_APB_SLV, APB3_SLV_REG_STREAM_IN, 0x0f);


//	dma_video_out_split4_frame(framebuffer_ptr[0],framebuffer_ptr[1], framebuffer_ptr[2], framebuffer_ptr[3], descriptors0 );

	//bsp_uDelay(400000);
	//dma_video_out_channel_execution(framebuffer_ptr[0], DMASG_CHANNEL_HDMI);
	bsp_uDelay(400000);




	cs_descriptor_csi_TX[0].ctrl_word = 0x0002;
	cs_descriptor_csi_TX[0].src_addr = ((u32)(framebuffer_ptr[0] ));
	cs_descriptor_csi_TX[0].dst_addr = 0;
	cs_descriptor_csi_TX[0].nBytes = (u32)(FRAME_SIZE*4);

	cs_descriptor_csi_TX[1].ctrl_word = 0x0002;
	cs_descriptor_csi_TX[1].src_addr = ((u32)(framebuffer_ptr[1] ));
	cs_descriptor_csi_TX[1].dst_addr = 0;
	cs_descriptor_csi_TX[1].nBytes = (u32)(FRAME_SIZE*4);

	cs_descriptor_csi_TX[2].ctrl_word = 0x0002;
	cs_descriptor_csi_TX[2].src_addr = ((u32)(framebuffer_ptr[2] ));
	cs_descriptor_csi_TX[2].dst_addr = 0;
	cs_descriptor_csi_TX[2].nBytes = (u32)(FRAME_SIZE*4);

	cs_descriptor_csi_TX[3].ctrl_word = 0x0002;
	cs_descriptor_csi_TX[3].src_addr = ((u32)(framebuffer_ptr[3] ));
	cs_descriptor_csi_TX[3].dst_addr = 0;
	cs_descriptor_csi_TX[3].nBytes = (u32)(FRAME_SIZE*4);

//	dma_video_out_channel_execution(framebuffer_ptr[9], DMASG_CHANNEL_DUMMY_CSI);

	dma_video_out_channel_cs_sg_execution(cs_descriptor_csi_TX, 4,DMASG_CHANNEL_DUMMY_CSI);

	bsp_uDelay(400000);
	//dma_video_out_channel_execution(framebuffer_ptr[4], DMASG_CHANNEL_OVERLAY);


	//dma_video_out_execution(framebuffer_ptr[4], framebuffer+FRAME_SIZE );


	APB3_REGW(OOB_APB_SLV, APB3_SLV_REG8_UVC_X_START, 0);
	APB3_REGW(OOB_APB_SLV, APB3_SLV_REG9_UVC_X_END, 540);
	APB3_REGW(OOB_APB_SLV, APB3_SLV_REG10_UVC_Y_START, 0);
	APB3_REGW(OOB_APB_SLV, APB3_SLV_REG11_UVC_Y_END, 1920);

//	dma_video_out_execution(framebuffer, framebuffer+FRAME_SIZE );

	//APB3_REGW(OOB_APB_SLV, APB3_SLV0_REG1_LED, 0x03);
//	APB3_REGW(OOB_APB_SLV, APB3_SLV0_REG2_STREAM_CTRL, 0x03);

	//APB3_REGW(OOB_APB_SLV, APB3_SLV0_REG3_RGB, 0x00000647);//0x00000547);
//	APB3_REGW(OOB_APB_SLV, APB3_SLV0_REG3_RGB, 0x0000944);//0x00000547);
	APB3_REGW(OOB_APB_SLV, APB3_SLV_REG12_I2C_DEBAYER_SEL, 0x00000001);//0x00000547);
	APB3_REGW(OOB_APB_SLV, APB3_SLV_REG_STREAM_OUT, 0x0f  | 0x70);




	cmd_cam_brightnes((cam_brightness/0x1000)&0xff, cam_brightness&0xfff);
	cmd_cam_colour_gain(cam_gain_r, cam_gain_g, cam_gain_b);



//	cmd_operation('1');
}



#define MASK_ALL  	0x03
#define MASK_SW1	( MASK_ALL & (~0x01) )
#define MASK_SW2	( MASK_ALL & (~0x02) )
#define MASK_SW3	( MASK_ALL & (~0x04) )

void cmd_cam_brightnes(u8 AGain, u16 DGain)
{


	for(int x=0; x<4; x++)
	{
		APB3_REGW(OOB_APB_SLV, APB3_SLV_REG12_I2C_CAM_SEL, x);
		if(camStatus[x]!=0)
		{
			if( PiCam_Gainfilter(AGain,DGain) ){
				bsp_printf("Pi Camera %d Brightness Error !\n\r",x );
			}
			else
			{
				bsp_printf("Pi Camera %d Brightness Done !\n\r",x);
				bsp_printf("AGain: 0x%x\n\r",AGain);
				bsp_printf("DGain: 0x%x\n\r",DGain);

			}

		}
		bsp_uDelay(200000);

	}

}

void cmd_cam_colour_gain( u16 gain_r, u16 gain_g, u16 gain_b)
{

	for(int x=0; x<4; x++)
	{
		APB3_REGW(OOB_APB_SLV, APB3_SLV_REG12_I2C_CAM_SEL, x);
		if(camStatus[x]!=0)
		{

			 if ( PiCam_WriteRegData(gain_r_1, (gain_r/0x100)&0xff) ==0 )
			 {
				 PiCam_WriteRegData(gain_r_0, gain_r&0xff);
				 PiCam_WriteRegData(gain_GR_1, (gain_g/0x100)&0xff);
				 PiCam_WriteRegData(gain_GR_0, gain_g&0xff);

				 PiCam_WriteRegData(gain_GB_1, (gain_g/0x100)&0xff);
				 PiCam_WriteRegData(gain_GB_0, gain_g&0xff);

				 PiCam_WriteRegData(gain_B_1, (gain_b/0x100)&0xff);
				 PiCam_WriteRegData(gain_B_0, gain_b&0xff);
				 bsp_printf("Pi Camera %d Colour !\n\r",x);
				 bsp_printf("Red Gain: 0x%x\n\r",gain_r);
				 bsp_printf("Green Gain: 0x%x\n\r",gain_g);
				 bsp_printf("Blue Gain: 0x%x\n\r",gain_b);

			 }

		}
		bsp_uDelay(200000);

	}

}


void overlay_update(uint32_t type)
{

	/*if (last_overlay_type != type)
	{
		if(last_overlay_type != 7 )
		{
		//	framebuffer_pattern(framebuffer_ptr[4],3,0);//Buffer for Overlay Mask
		}
		else if(type == 6)
		{
		 	framebuffer_overlayFrame(framebuffer_ptr[4], 0, 	960, 	0, 		540,	 8, 8);
			framebuffer_overlayFrame(framebuffer_ptr[4], 0, 	960, 	540, 	1080,	 8, 8);
			framebuffer_overlayFrame(framebuffer_ptr[4], 960, 	1920,	0, 		540,	 8, 8);
			framebuffer_overlayFrame(framebuffer_ptr[4], 960, 	1920, 	540, 	1080,	 8, 8);
		}


		if (type == 7) {
			framebuffer_pattern(framebuffer_ptr[4],3,0);//Buffer for Overlay Mask
		}
		else if (type == 6)
		{
		 	framebuffer_overlayFrame(framebuffer_ptr[4], 0, 	960, 	0, 		540,	 8, 1);
		 	framebuffer_overlayFrame(framebuffer_ptr[4], 0, 	960, 	540, 	1080,	 8, 1);
		 	framebuffer_overlayFrame(framebuffer_ptr[4], 960, 	1920,	0, 		540,	 8, 1);
		 	framebuffer_overlayFrame(framebuffer_ptr[4], 960, 	1920, 	540, 	1080,	 8, 1);
		}
	}

	last_overlay_type = type;
*/
}


void cmd_operation(uint8_t key )
{
	if(key == '1')
	{
		swithCmdPtr = 0;
	}
	else if (key == '2')
	{
		swithCmdPtr = 1;
	}
	else if (key == '3')
	{
		swithCmdPtr = 2;

	}
	else if (key == '4')
	{
		swithCmdPtr = 3;

	}
	else if (key == '5')
	{
		swithCmdPtr = 4;



	}




}

u32 last_switch = MASK_ALL;
u32 NextDisplayMode	= 0x01; // next display mode 0: Camera Mode, 1: Colour Pattern Mode, 2:All Black Pattern Mode



void switch2cmd()
{
	uint8_t command[5] = {'1','2','3','4','5'};

	swithCmdPtr++;
	if(swithCmdPtr>=5)
	{
		swithCmdPtr=0;

	}
	cmd_operation(command[swithCmdPtr]);

}
void swtich_event()
{

	u32 rd_apb3 = APB3_REGR(OOB_APB_SLV, APB3_SLV_REG5_SW_IN);
	rd_apb3 &= MASK_ALL;


	if(last_switch!=rd_apb3)
	{
		//bsp_printf("Event Switch 0x%x\n\r",rd_apb3);
		u32 apb3_rd = APB3_REGR(OOB_APB_SLV, APB3_SLV0_REG1_LED);
		apb3_rd &= (~0x02);
		APB3_REGW(OOB_APB_SLV, APB3_SLV0_REG1_LED, apb3_rd);


		if(rd_apb3 != MASK_ALL)
		{
			rd_apb3 = APB3_REGR(OOB_APB_SLV, APB3_SLV_REG5_SW_IN);
			rd_apb3 &= MASK_ALL;

		}


		if(rd_apb3==MASK_SW1)
		{
			 bsp_printf("Event Switch 0\n\r");

		}
		else if(rd_apb3==MASK_SW2)
		{
			 bsp_printf("Event Switch 1\n\r");
			 switch2cmd();
		}
	}

	last_switch = rd_apb3;



}

void main(){
	int index=0;

	bsp_printf("************** TI180 OOBTest *******************\r\n");
	bsp_printf("Version :  %s\r\n", VERSION);


	uint8_t key;

	IntcInitialize();

	u32 HardConfig = APB3_REGR(OOB_APB_SLV, APB3_SLV_REG_HARD_CONFIG);
	bsp_printf("Hardware Configuration Code: 0x%x\n\r",HardConfig);


	bsp_printf("Waiting To Start Stream TX!\n\r");

	APB3_REGW(OOB_APB_SLV, APB3_SLV_REG_STREAM_OUT, 0x00 | 0x30 );
	bsp_uDelay(100000);

	APB3_REGW(OOB_APB_SLV, APB3_SLV_REG_STREAM_OUT, 0x00 | 0x70 );
	bsp_uDelay(100000);

/*
	 while(1)
	 {
		if(uart_readOccupancy(BSP_UART_TERMINAL)){
			key=uart_read(BSP_UART_TERMINAL);
			bsp_printf("Start initial Video TX!\n\r");

			break;
		}
		  bsp_uDelay(100000);
	}*/


	inital_video_stream();

	  while(1)
	    {
	        if(uart_readOccupancy(BSP_UART_TERMINAL)){
	        	key=uart_read(BSP_UART_TERMINAL);
	            bsp_putString("echo character:");
	            bsp_putChar(key);
	            bsp_putString("\n\r");


	         //   cmd_operation(key );


	        }
	        bsp_uDelay(100000);
	       // swtich_event();

	    }


}
