#ifndef PROJECT_H_
#define PROJECT_H_

#include <stdatomic.h>
#include <stdint.h>
#include <stdlib.h>

#include "soc.h"
#include "type.h"
#include "lib/libfixmath/fix16.h"

#define FRAME_WIDTH     			1920
#define FRAME_HEIGHT    			1080
#define FRAME_CHANNELS     			4

#define NET_HEIGHT      			384
#define NET_WIDTH       			384
#define NET_CHANNELS     			3
#define MODEL_INPUT_SIZE   			(NET_CHANNELS*NET_HEIGHT*NET_WIDTH)

#define IOU_THRESHOLD				0.25
#define OBJ_THRESHOLD				0.15
#define YOLO_CLASSES				1





/// Application related constants.
// Total number of image
#define SAMPLE_IMAGES_N				3

// To enable ECNN interrupt
#define ECNN_INTERRUPT				1

//Maximum bbox handled by display anotator module
#define BBOX_MAX 					16


/// NOR Flash addresses.
#define CNN_FW_ROM_ADDR				0x00900000
#define CNN_MODEL_ROM_ADDR			0x00A00000
#define IMAGES_FLASH_ADDR			0x01200000



/// RAM addresses allocation.
/// RAM address and sizes. Make sure the size allocated for each is enough for each section
#define DRAM						((volatile uint32_t *)SYSTEM_DDR_BMB)
#define BRAM						((volatile uint32_t *)SYSTEM_RAM_A_CTRL)
// 8 MiB offset to avoid overlapping with program ram space defined in
// `default.ld`, line 7
// Makesure this offset address is always larger than program ram space
#define PROJECT_BASE				0x00800000



//// Display related sizes and offsets
//Set to 4 for multi-buffering; Set to 1 for single buffering
//(shared for camera frame capture, display).
#define MAX_DISPLAY_BUFFERS			4

//DMA is connected to AXI0, so it will transfer 512 bit data
//Makesure the box buffer and display buffer that consist of command, data, and dummy data as padding
//are completely divisible by respective total data transfer (512-bit)
//DMA channel will transfer 64-bit word to annotator
//Each transfer initiated from DMA controller will be 512-bit word, thus we need to ensure an even number of transfer
#define TOTAL_BOX_SIZE				(BBOX_MAX * 8)
#define DUMMY_BYTE_SIZE				(64 - 8)
#define TOTAL_BOX_BUFFER_SIZE		(8 + TOTAL_BOX_SIZE + DUMMY_BYTE_SIZE)

#define IMAGE_SIZE 					(FRAME_WIDTH * FRAME_HEIGHT * 4)
#define IMAGE_CMD_OFFSET 			0
#define IMAGE_START_OFFSET 			(IMAGE_CMD_OFFSET + 8)
#define IMAGE_END_OFFSET 			(IMAGE_START_OFFSET + IMAGE_SIZE)
#define IMAGE_DUMMY_OFFSET 			(IMAGE_END_OFFSET + DUMMY_BYTE_SIZE)
#define FRAME_BUFFER_SIZE			(IMAGE_DUMMY_OFFSET - IMAGE_CMD_OFFSET)

// Display
#define DISPLAY_BUF_BASE			0x0800000//PROJECT_BASE
#define display_buffer_array		((volatile uint32_t*)DISPLAY_BUF_BASE)
//to give enough space for accommate MAX_DISPLAY_BUFFERS*FRAME_WIDTH*FRAME_HEIGHT*4 bytes data
#define DISPLAY_ALLOC				(8 * 1024 * 1024 * MAX_DISPLAY_BUFFERS)
// bbox coordinate
#define YOLO_BOX_BASE				(DISPLAY_BUF_BASE + DISPLAY_ALLOC)
#define YOLO_BOX_CMD_OFFSET			(YOLO_BOX_BASE)
#define YOLO_BOX_START_OFFSET		(YOLO_BOX_CMD_OFFSET + 8)
#define YOLO_BOX_END_OFFSET			(YOLO_BOX_CMD_OFFSET + TOTAL_BOX_BUFFER_SIZE)
#define yolo_bbox_array				((volatile uint64_t*)(YOLO_BOX_CMD_OFFSET))
// bbox coordinate for second bbox, if hardware supported
//#define YOLO_BOX2_CMD_OFFSET		(YOLO_BOX_END_OFFSET + 8)
//#define YOLO_BOX2_START_OFFSET	(YOLO_BOX2_CMD_OFFSET + 8)
//#define YOLO_BOX2_END_OFFSET		(YOLO_BOX2_CMD_OFFSET + TOTAL_BOX_BUFFER_SIZE)
//#define yolo_bbox2_array			((volatile uint64_t*)(YOLO_BOX2_START_OFFSET))
#define YOLO_BOX_ALLOC				(2 * 1024 * 1024) //give enough space for storing bbox buf
// Compressed static images in LZ4 format
#define IMAGES_LZ4_BASE				(YOLO_BOX_BASE + YOLO_BOX_ALLOC)
#define IMAGES_LZ4_SIZE				12050089 // Bytes, from "wc -l" on *.lz4.hex
#define IMAGES_LZ4_ALLOC			(12 * 1024 * 1024)
// Decompressed static images
#define IMAGES_RGB_BASE				(IMAGES_LZ4_BASE + IMAGES_LZ4_ALLOC)
#define IMAGES_RGB_SIZE				(FRAME_WIDTH * FRAME_HEIGHT * 4)		//size of 1 image, depend on your image data
#define IMAGES_RGB_TOTAL_SIZE		(IMAGES_RGB_SIZE * SAMPLE_IMAGES_N)  	//SAMPLE_IMAGES_N number of images
#define IMAGES_RGB_ALLOC			(24 * 1024 * 1024) // 3x1080p frames
// Plannar static images
#define PLANAR_RGB_BASE				(IMAGES_RGB_BASE + IMAGES_RGB_ALLOC)
#define PLANAR_RGB_ALLOC			(2 * 1024 * 1024) // NET_CHANNELS*NET_HEIGHT*NET_WIDTH size per image

// eCNN driver and model
// Makesure the start address of CNN_FW_RAM_ADDR and CNN_MODEL_RAM_ADDR must at even number MiB
#define CNN_MODEL_LZ4_BASE			(PLANAR_RGB_BASE + PLANAR_RGB_ALLOC)
#define CNN_MODEL_ROM_SIZE			(8 * 1024 * 1024)
#define CNN_MODEL_LZ4_ALLOC			CNN_MODEL_ROM_SIZE
#define CNN_FW_LZ4_BASE				(CNN_MODEL_LZ4_BASE + CNN_MODEL_LZ4_ALLOC)
#define CNN_FW_ROM_SIZE				DPU_INSTRUCTION_SIZE
#define CNN_FW_RAM_ADDR				(CNN_FW_LZ4_BASE + CNN_FW_ROM_SIZE)
#define CNN_MODEL_RAM_ADDR			(CNN_FW_RAM_ADDR + CNN_FW_ROM_SIZE)

#if TI180_EVK_BSP == 1
// #include "driver/hdmi_adv7511.h"
#define APP_OPT_FLASH_32MB_LAYOUT 1
#define APP_OPT_VO_NO_PAUSE 1
#define APP_OPT_NO_ROM 0
#else
#define APP_OPT_FLASH_32MB_LAYOUT 0
#define APP_OPT_VO_NO_PAUSE 0
#define APP_OPT_NO_ROM 0
#endif

#define CNN_DIN_BUF_A                                                          \
		((uint8_t *)(intptr_t)(CNN_MODEL_RAM_ADDR + 62 * 1024 * 1024))
#define CNN_DIN_BUF_LEN_A                                                      \
		(2 * 1024 * 1024 + 6 * 1024 * 1024 * APP_OPT_FLASH_32MB_LAYOUT)
#define CNN_DIN_BUF_LEN_B                                                      \
		(2 * 1024 * 1024 + 6 * 1024 * 1024 * APP_OPT_FLASH_32MB_LAYOUT)
#define CNN_DIN_BUF_B 				(CNN_DIN_BUF_A + CNN_DIN_BUF_LEN_A)
#define CNN_PCFG_IOBUF 				(CNN_DIN_BUF_B + CNN_DIN_BUF_LEN_B)
#define CNN_DOUT_BUF_BASE 			(CNN_PCFG_IOBUF + (1 * 1024 * 1024))



// fast bit calculation
#define SIZE_KiB(x)					((x) >> 10)
#define MUL2(x)						((x) << 1)
#define MUL4(x)						((x) << 2)
#define DIV2(x)						((x) >> 1)
#define MOD128(x)					((x) & 127)

#define U32PTR(x)					((volatile uint32_t *)(x))

///
static inline void flush_data_cache(void) {
#if defined(__ICCRISCV__)
  asm("DC32 0x500F");
#else
  __asm(".word(0x500F)");
#endif
}

// Forward declarations.

///
void crash();

///
void printPTime(uint32_t ts1, uint32_t ts2, char *s);

///
void initSPI(u32 spi);

///
void moveFlash2Mem(uint32_t spi, uint32_t cs, uint32_t flashAddress,
                   uint32_t memoryAddress, uint32_t size);

///
int decompressLZ4(void *src, uint32_t src_len, void *dst, uint32_t dst_len);

#define master_control_input_A		EXAMPLE_APB3_SLV_REG18_OFFSET
#define master_control_sataus_A		EXAMPLE_APB3_SLV_REG19_OFFSET
#define master_control_input_B		EXAMPLE_APB3_SLV_REG20_OFFSET
#define master_control_sataus_B		EXAMPLE_APB3_SLV_REG21_OFFSET
#define master_control_input_C		EXAMPLE_APB3_SLV_REG22_OFFSET
#define master_control_sataus_C		EXAMPLE_APB3_SLV_REG23_OFFSET

#endif /* PROJECT_H_*/
