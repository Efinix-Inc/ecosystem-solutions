///////////////////////////////////////////////////////////////////////////////////
// Copyright 2024 Efinix.Inc. All Rights Reserved.
// You may obtain a copy of the license at
//    https://www.efinixinc.com/software-license.html
///////////////////////////////////////////////////////////////////////////////////

//Define the picam version. By default is set to Picam V3.
#define PICAM_VERSION 	2

//#define STATIC_IMAGE	1
// #define SW_PLANAR		1


#include <math.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#include "bsp.h"
#include "clint.h"
#include "dmasg.h"
#include "plic.h"
#include "project.h"
#include "riscv.h"
#include "soc.h"

//#include "plic.h"
//#include "uart.h"
#include "platform/vision/common.h"
#if PICAM_VERSION == 3
#include "platform/vision/PiCamV3Driver.h"
#else
#include "platform/vision/PiCamDriver.h"
#endif
#include "platform/vision/apb3_cam.h"
#include "GMSL_serDes.h"

//Interrupt File
#include "platform/interrupt/intc.h"

#include "vexriscv.h"

#ifdef STATIC_IMAGE
uintptr_t sample_images[SAMPLE_IMAGES_N];
uintptr_t planar_images[SAMPLE_IMAGES_N];
#endif


/// SoC hardware related constants.
#define SPI0 					SYSTEM_SPI_0_IO_CTRL

//===----------------------------------------------------------------------===//
//   | DISPLAY_BUF_BASE                           | MAX_DISPLAY_BUFFERSx1080x1920x4 = 0x01FA_4000 B or 31.6 MiB
//   | ------------------------------------------ | 0x0080_0000 8 MiB
//   |                                            |  To avoid stack overwrite
//   | ------------------------------------------ | 0x0002_0000 256 KiB
//   | Program Stack (252 K)                      |  256 KiB - 4 KiB
//   | ------------------------------------------ | 0x0000_1000 4 KiB
//
//===----------------------------------------------------------------------===//
//
// NOR Flash Space Map
//   | --------------------------------- | 0x0090_0000  9 MiB
//   | RISC-V app                        |
//   | --------------------------------- | 0x0060_0000  6 MiB
//   | FPGA Gateware                     |
//   | --------------------------------- | 0x0000_0000
//
//===----------------------------------------------------------------------===//

#define bsp_putChar(c) uart_write(BSP_UART_TERMINAL, c);
#define bsp_putString(s) uart_writeStr(BSP_UART_TERMINAL, s);


u32 in_frame_count=0;


uint8_t camera_buffer = 0;
uint8_t display_buffer = 0;
uint8_t next_display_buffer = 0;
uint8_t draw_buffer = 0;
uint8_t bbox_overlay_updated = 0;

//Custom Defined Registers that Store the Descriptor in RTL ,it will be provide the Memory allocation information when DMA controller request.
//By default the RTL provides 4 descriptors per channels, It will shift to next descriptor after DMA controller request a descriptor.
   struct cs_sg_descriptor {
      u32 ctrl_word;
      u32 src_addr;
      u32 dst_addr;
      u32 nBytes;
   };
   //ctrl_word[0] Reset the descriptor pointer
   //ctrl_word[1] Increase Descriptor Pointer
   //ctrl_word[2] sg_rsp_last
   //ctrl_word[3] sg_rsp_stallout



struct cs_sg_descriptor cs_descriptor_csi_RX[4];
void dma_video_in_channel_cs_sg_execution(struct cs_sg_descriptor* cs_descriptor, u32 nCSDescriptor, u32 channel)
{

	u32 CS_SG_REGS_ADDR = (channel * 4 * 4)  *4;

		bsp_printf("stop dma input \n\r");

		bsp_printf("Custom SG mode Input init! \n\r");


		for(int i=0; i<nCSDescriptor; i++)
		{


			EXAMPLE_APB3_REGW(CS_SG_APB_SLV, CS_SG_REGS_ADDR, cs_descriptor[i].ctrl_word);
			CS_SG_REGS_ADDR +=4;

			EXAMPLE_APB3_REGW(CS_SG_APB_SLV, CS_SG_REGS_ADDR, cs_descriptor[i].src_addr);
			CS_SG_REGS_ADDR +=4;

			EXAMPLE_APB3_REGW(CS_SG_APB_SLV, CS_SG_REGS_ADDR, cs_descriptor[i].dst_addr);
			CS_SG_REGS_ADDR +=4;

			EXAMPLE_APB3_REGW(CS_SG_APB_SLV, CS_SG_REGS_ADDR, cs_descriptor[i].nBytes);
			CS_SG_REGS_ADDR +=4;

		}
		bsp_printf("Initial CS Register \n\r");

	if(dmasg_busy(DMASG_BASE, channel))
	{
		bsp_printf("stop dma Ch %x \n\r with SG MODE", channel);
		dmasg_stop(DMASG_BASE, channel);

	}
	bsp_printf("Start dma Ch %x \n\r with CS SG Mode", channel);
	dmasg_output_memory(DMASG_BASE,channel, 0, 256); // dmasg_pop_memory (DMASG_BASE, DMASG_CHANNEL0, (u32)pucEthernetBuffer, 64);
	dmasg_input_stream(DMASG_BASE, channel, 0, 1, 0); 				  // dmasg_push_stream(DMASG_BASE, DMASG_CHANNEL0, 0, 0, 0);

	dmasg_linked_list_sg_start(DMASG_BASE, channel);
	bsp_printf("Start dma input with cs cg\n\r");

}
u32 Get_CurrentVC()
{
	return 	EXAMPLE_APB3_REGR(CS_SG_APB_SLV, 0x100*4);

}

u32 buf(u32 i) {
	return DISPLAY_BUF_BASE + FRAME_BUFFER_SIZE*i;
}

u32 buf_offset(u32 i, u32 offset) {
	return buf(i) + offset;
}

char* buf_offset_char(u32 i, u32 offset) {
	return (char*)buf_offset(i, offset);
}

u32* buf_offset_u32(u32 i, u32 offset) {
	return (u32*)buf_offset(i, offset);
}

u64* buf_offset_u64(u32 i, u32 offset) {
	return (u64*)buf_offset(i, offset);
}

/// @brief Print processing time between two timestamps.
///
/// @param ts1 First timestamp.
/// @param ts2 Second timestamp.
/// @param s Character
void printPTime(uint32_t ts1, uint32_t ts2, char *s) {
	bsp_printf("\033[1;33m%s \033[0m", s);
	uint32_t rts;
	rts = ts2 - ts1;

	uint32_t ticks_per_msec = SYSTEM_CLINT_HZ / 1000;
	float msec = (float)rts / ticks_per_msec;

	//  bsp_printf_full("%s %d, %f msec\n\n\r", s, rts, msec);
	bsp_printf("%d, \033[1;35m%f msec\033[0m\n\n\r", rts, msec);
}

/// @brief Floating-point equality check.
bool fequals(float x, float y) {
	//
	return fabs(x - y) < 0.0005;
}


void send_dma(u32 channel, u32 port, u32 addr, u32 size, int interrupt, int wait, int self_restart) {
	dmasg_input_memory(DMASG_BASE, channel, addr, 16);
	dmasg_output_stream(DMASG_BASE, channel, port, 0, 0, 1);

	if(interrupt) {
		dmasg_interrupt_config(DMASG_BASE, channel, DMASG_CHANNEL_INTERRUPT_CHANNEL_COMPLETION_MASK);
	}

	if(self_restart) {
		dmasg_direct_start(DMASG_BASE, channel, size, 1);
	} else {
		dmasg_direct_start(DMASG_BASE, channel, size, 0);
	}

	if(wait) {
		while(dmasg_busy(DMASG_BASE, channel));
		flush_data_cache();
	}
}

void recv_dma(u32 channel, u32 port, u32 addr, u32 size, int interrupt, int wait, int self_restart) {
	dmasg_input_stream(DMASG_BASE, channel, port, 1, 0);
	dmasg_output_memory(DMASG_BASE, channel, addr, 16);

	if(interrupt){
		dmasg_interrupt_config(DMASG_BASE, channel, DMASG_CHANNEL_INTERRUPT_CHANNEL_COMPLETION_MASK);
	}

	if(self_restart) {
		dmasg_direct_start(DMASG_BASE, channel, size, 1);
	} else {
		dmasg_direct_start(DMASG_BASE, channel, size, 0);
	}

	if(wait){
		while(dmasg_busy(DMASG_BASE, channel));
		flush_data_cache();
	}
}

void trigger_next_display_dma() {
//	display_buffer = next_display_buffer;
	send_dma(DMASG_DISPLAY_MM2S_CHANNEL, DMASG_DISPLAY_MM2S_PORT, buf(display_buffer), FRAME_BUFFER_SIZE, 1, 0, 0);
}

void trigger_next_box_dma() {
	if (bbox_overlay_updated) {
		soc_write_buffer_flush();
		send_dma(DMASG_DISPLAY_MM2S_CHANNEL, DMASG_DISPLAY_MM2S_PORT, YOLO_BOX_CMD_OFFSET, TOTAL_BOX_BUFFER_SIZE, 0, 1, 0); //Wait till complete
		bbox_overlay_updated = 0;
	}
}

void trigger_next_cam_dma() {
//	next_display_buffer = camera_buffer;

	/*for(int i=0; i<MAX_DISPLAY_BUFFERS; i++)
	{
		if(i!=display_buffer && i!=next_display_buffer && i!=draw_buffer)
		{
			camera_buffer = i;
			break;
		}
	}*/

    u32 currentVC = Get_CurrentVC();
    example_register_write(master_control_sataus_A,  in_frame_count++ );
    example_register_write(master_control_sataus_B,  currentVC  );
    bsp_printf("Frame interrupt VC 0x%x\n\r",currentVC);

//	recv_dma(DMASG_CAM_S2MM_CHANNEL, DMASG_CAM_S2MM_PORT, buf_offset(camera_buffer, IMAGE_START_OFFSET), FRAME_WIDTH*FRAME_HEIGHT*4, 1, 0, 0);

	//Indicate start of S2MM DMA to camera building block via APB3 slave
	EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG4_OFFSET, 0x00000001);
	EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG4_OFFSET, 0x00000000);

	//Trigger storage of one captured frame via APB3 slave
	EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG2_OFFSET, 0x00000001);
	EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG2_OFFSET, 0x00000000);
}

void trigger_next_multi_scalar(){
	//uint32_t input_addr = g_cnn.use_buf_a? (uint32_t)(uintptr_t)(g_cnn.p_io_buf_a[0]) : (uint32_t)(uintptr_t)(g_cnn.p_io_buf_b[0]);
	//recv_dma(DMASG_MSCALE_R_SS2M_CHANNEL, DMASG_MSCALE_R_SS2M_PORT, input_addr, NET_WIDTH*NET_HEIGHT, 0, 0, 0);
	//recv_dma(DMASG_MSCALE_G_SS2M_CHANNEL, DMASG_MSCALE_G_SS2M_PORT, input_addr + NET_WIDTH*NET_HEIGHT, NET_WIDTH*NET_HEIGHT, 0, 0, 0);
	//recv_dma(DMASG_MSCALE_B_SS2M_CHANNEL, DMASG_MSCALE_B_SS2M_PORT, input_addr + (NET_WIDTH*NET_HEIGHT)*2, NET_WIDTH*NET_HEIGHT, 0, 0, 0);

	send_dma(DMASG_MSCALE_IN_MM2S_CHANNEL, DMASG_MSCALE_IN_MM2S_PORT, buf_offset(camera_buffer, IMAGE_START_OFFSET), FRAME_WIDTH*FRAME_HEIGHT*4, 0, 1, 0);

	//Wait for DMA transfer completion
	while(dmasg_busy(DMASG_BASE, DMASG_MSCALE_IN_MM2S_CHANNEL) ||
			dmasg_busy(DMASG_BASE, DMASG_MSCALE_R_SS2M_CHANNEL) ||
			dmasg_busy(DMASG_BASE, DMASG_MSCALE_G_SS2M_CHANNEL) ||
			dmasg_busy(DMASG_BASE, DMASG_MSCALE_B_SS2M_CHANNEL));
	flush_data_cache();
}

void color_pattern(volatile u32* buf){
	for (int y=0; y<FRAME_HEIGHT; y++) {
		for (int x=0; x<FRAME_WIDTH; x++) {
			if ((x<3 && y<3) || (x>=FRAME_WIDTH-3 && y<3) || (x<3 && y>=FRAME_HEIGHT-3) || (x>=FRAME_WIDTH-3 && y>=FRAME_HEIGHT-3)) {
				buf [y*FRAME_WIDTH + x] = 0x000000FF; //RED
			} else if (x<(FRAME_WIDTH/4)) {
				buf [y*FRAME_WIDTH + x] = 0x0000FF00; //GREEN
			} else if (x<(FRAME_WIDTH/4 *2)) {
				buf [y*FRAME_WIDTH + x] = 0x00FF0000; //BLUE
			} else if (x<(FRAME_WIDTH/4 *3)) {
				buf [y*FRAME_WIDTH + x] = 0x000000FF; //RED
			} else {
				buf [y*FRAME_WIDTH + x] = 0x00FF0000; //BLUE
			}
		}
	}
}

void init_image(void) {
	for(int i=0; i<MAX_DISPLAY_BUFFERS; i++) {
		*buf_offset_u64(i, IMAGE_CMD_OFFSET) = 1;
		//Initialize dummy data to be sent with command and data
		*buf_offset_u64(i, IMAGE_DUMMY_OFFSET) = 0;
	}
	color_pattern(buf_offset_u32(display_buffer, IMAGE_START_OFFSET));
}

/// @brief Initialize
void setup() {
	//Allocate dynamic memory using arena allocator. Refer to model/arena.h for usage.
	uint32_t hartId = csr_read(mhartid);
	// Create 500KB arena size

	/************************************************************SETUP IMAGE SOURCE************************************************************/

#ifdef STATIC_IMAGE
	bsp_printf("Copying test images from flash ...\n\r");
	init_test_images();
	bsp_printf("Done ...\n\r");

#else
	bsp_printf("Camera Setting...(VC test)");

	// Reset mipi
	EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG1_OFFSET, 0x00000001);// assert reset
	bsp_uDelay(100);
	EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG1_OFFSET, 0x00000000);//de-assert reset
	bsp_uDelay(1000*10); // 10ms delay to ensure the camera fully exits reset and stabilizes before proceeding

	//Camera I2C configuration
	mipi_i2c_init();


#if PICAM_VERSION == 3
	PiCamV3_Init();

	//SET camera pre-processing RGB gain value
	Set_RGBGain(1,5,3,7);
#else

	bsp_printf("GMSL Initial!\n\r");
	if(GMSL_SerDes_init())
	{
		bsp_printf("GMSL Serilizer and Deserilizer Initial Error!\n\r");
	}
	else {
		bsp_printf("GMSL Serilizer and Deserilizer Initial Done!\n\r");
	}

//	PiCam_init();

	//SET camera pre-processing RGB gain value
	Set_RGBGain(1,4,3,4);
#endif

	bsp_printf("Done\n\r");
#endif

	/*************************************************************SETUP DMA*************************************************************/

	bsp_printf("DMA Setting...");

	IntcInitialize();

	dmasg_priority(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL,  3, 0);
	dmasg_priority(DMASG_BASE, DMASG_CAM_S2MM_CHANNEL,      0, 0);

	dmasg_interrupt_config(DMASG_BASE, DMASG_CAM_S2MM_CHANNEL, DMASG_CHANNEL_INTERRUPT_INPUT_PACKET_MASK);  //Disable dmasg channel interrupt
	dmasg_interrupt_pending_clear(DMASG_BASE,DMASG_CAM_S2MM_CHANNEL,0xFFFFFFFF);

	bsp_printf("Done\n\r");

	/***********************************************************TRIGGER DISPLAY*******************************************************/

	bsp_printf("Initialize display memory content...");

	//Initialize test image in buffer_array (default buffer 0)
	init_image();
	bsp_printf("Done\n\r");

	bsp_printf("Initial Buffers");

		u32 * BaseAddr;
		u32 Value;
		BaseAddr = (u32*)buf_offset(0, IMAGE_START_OFFSET);
		Value = 0x10000000;
		for(int i=0; i< (FRAME_WIDTH*FRAME_HEIGHT) ; i++  )
		{
			*BaseAddr = Value;
			BaseAddr ++;
			Value ++;
		}

		BaseAddr = (u32*)buf_offset(1, IMAGE_START_OFFSET);
		Value = 0x20000000;
		for(int i=0; i< (FRAME_WIDTH*FRAME_HEIGHT) ; i++  )
		{
			*BaseAddr = Value;
			BaseAddr ++;
			Value ++;
		}

		BaseAddr = (u32*)buf_offset(2, IMAGE_START_OFFSET);
		Value = 0x30000000;
		for(int i=0; i< (FRAME_WIDTH*FRAME_HEIGHT) ; i++  )
		{
			*BaseAddr = Value;
			BaseAddr ++;
			Value ++;
		}

		BaseAddr = (u32*)buf_offset(3, IMAGE_START_OFFSET);
		Value = 0x40000000;
		for(int i=0; i< (FRAME_WIDTH*FRAME_HEIGHT) ; i++  )
		{
			*BaseAddr = Value;
			BaseAddr ++;
			Value ++;
		}


	//Initialize bbox_overlay_buffer - Trigger DMA for initialized bbox_overlay_buffer content to display annotator module!!!
	bsp_printf("Initialize Bbox to invalid ...");
	bsp_printf("Done\n\r");
	soc_write_buffer_flush();

	//Trigger display DMA once then the rest handled by interrupt sub-rountine
	bsp_printf("Trigger display DMA...");

	msDelay(3000); //Display colour bar for 3 seconds

	/*********************************************************TRIGGER CAMERA CAPTURE*****************************************************/
#ifndef STATIC_IMAGE
	//SELECT RGB or grayscale output from camera pre-processing block.
	EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG3_OFFSET, 0x00000000);   //RGB

	//Trigger camera DMA once then the rest handled by interrupt sub-rountine
	bsp_printf("Trigger camera DMA...");

	if(dmasg_busy(DMASG_BASE, DMASG_CAM_S2MM_CHANNEL))
	{
		bsp_printf("Stop Camera input DMA \n\r", DMASG_CAM_S2MM_CHANNEL);
		dmasg_stop(DMASG_BASE, DMASG_CAM_S2MM_CHANNEL);
	}

	cs_descriptor_csi_RX[0].ctrl_word = 0x0002;
	cs_descriptor_csi_RX[0].src_addr =  0;
	cs_descriptor_csi_RX[0].dst_addr = ((u32)buf_offset(0, IMAGE_START_OFFSET)  );
	cs_descriptor_csi_RX[0].nBytes = (u32)(FRAME_WIDTH*FRAME_HEIGHT*4)-1;

	cs_descriptor_csi_RX[1].ctrl_word = 0x0002;
	cs_descriptor_csi_RX[1].src_addr = 0;
	cs_descriptor_csi_RX[1].dst_addr = ((u32)buf_offset(1, IMAGE_START_OFFSET)  );
	cs_descriptor_csi_RX[1].nBytes = (u32)(FRAME_WIDTH*FRAME_HEIGHT*4)-1;

	cs_descriptor_csi_RX[2].ctrl_word = 0x0002;
	cs_descriptor_csi_RX[2].src_addr = 0;
	cs_descriptor_csi_RX[2].dst_addr = ((u32)buf_offset(2, IMAGE_START_OFFSET)  );
	cs_descriptor_csi_RX[2].nBytes = (u32)(FRAME_WIDTH*FRAME_HEIGHT*4)-1;

	cs_descriptor_csi_RX[3].ctrl_word = 0x0002;
	cs_descriptor_csi_RX[3].src_addr = 0;
	cs_descriptor_csi_RX[3].dst_addr = ((u32)buf_offset(3, IMAGE_START_OFFSET)  );
	cs_descriptor_csi_RX[3].nBytes = (u32)(FRAME_WIDTH*FRAME_HEIGHT*4)-1;



	//recv_dma(DMASG_CAM_S2MM_CHANNEL, DMASG_CAM_S2MM_PORT, buf_offset(camera_buffer, IMAGE_START_OFFSET), FRAME_WIDTH*FRAME_HEIGHT*4, 0, 0, 1);

	dma_video_in_channel_cs_sg_execution(cs_descriptor_csi_RX, 4, DMASG_CAM_S2MM_CHANNEL);


	cam_s2mm_active = 1;

	//Indicate start of S2MM DMA to camera building block via APB3 slave
	EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG4_OFFSET, 0x00000001);
	EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG4_OFFSET, 0x00000000);

	//Trigger storage of one captured frame via APB3 slave
	EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG2_OFFSET, 0x00000001);
	EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG2_OFFSET, 0x00000000);

	bsp_printf("Done\n\r");

#endif


#ifndef STATIC_IMAGE
#if PICAM_VERSION == 3
	PiCamV3_StartStreaming();
#endif
#endif


}




void main(){
	bsp_init();
	initSPI(SPI0);
	setup();
	uint32_t hartId = csr_read(mhartid);

	bsp_uDelay(100);

	int static_image_num = 0;
	uint32_t rdata;
	uint32_t timecmp_0, timecmp_1;

#ifdef STATIC_IMAGE
	uint32_t inference_image = 0;
	bool change_image = true;
	uint32_t image_cnt = 0;
	uint32_t loop_cnt = 0;
#endif

	uint8_t key;
	while(1) {
	      if(uart_readOccupancy(BSP_UART_TERMINAL)){
		        	key=uart_read(BSP_UART_TERMINAL);
		            bsp_putString("echo character:");

		        }
		        bsp_uDelay(100000);

	}

	bsp_printf("***Succesfully Ran Demo*** \r\n");


}

