/*
 * sd_ctrl.h
 *
 *  Created on: 16 Mar 2021
 *      Author: user
 */

#ifndef SRC_EFX_MMC_DRIVER_H_
#define SRC_EFX_MMC_DRIVER_H_

#include "bsp.h"
#include "userdef.h"
#include "mmc.h"

#define REG_VERSION 					0x0000
#define REG_ARGUMENT2 					0x0000
#define REG_BLOCKSIZE_COUNT				0x0004
#define REG_ARGUMENT1 					0x0008
#define REG_TRANFER_MODE 				0x000C
#define REG_COMMAND_RESP31_0 			0x0010
#define REG_COMMAND_RESP63_32 			0x0014
#define REG_COMMAND_RESP95_64 			0x0018
#define REG_COMMAND_RESP127_96 			0x001C
#define REG_BUFFER_DATA					0x0020
#define REG_PRESENT_STATE 				0x0024
#define REG_HOST_CONTORL				0x0028
#define REG_CLOCK_CONTORL				0x002C
#define REG_NORMAL_INTERRUPT_STATUS0	0x0030
#define REG_NORMAL_INTERRUPT_STATUS1	0x0034
#define REG_AUTO_CMD_ERROR				0x003C
#define REG_CAPABILITIES0				0x0040
#define REG_CAPABILITIES1				0x0044
#define REG_MAX_CURRENT					0x0048
#define REG_CAPABILITIES2				0x004C
#define REG_FORECE_EVENT				0x0050
#define REG_ADMA_ERROR_STATUS			0x0054
#define REG_ADMA_SYSTEM_ADDR0			0x0058
#define REG_ADMA_SYSTEM_ADDR1			0x005C
#define REG_PRESENT_VALUE0				0x0060
#define REG_PRESENT_VALUE1				0x0064
#define REG_PRESENT_VALUE2				0x0068
#define REG_PRESENT_VALUE3				0x006C
#define REG_SHARE_BUS_CONTORL			0x00E0
#define REG_SLOT_INTERRUPT_STATUS		0x00FC

typedef  struct {
	u32 dma_enable;
	u32 block_count_enable;
	u32 auto_cmd_enable;
	u32 data_transfer_direction_select;//0:write; 1:read;
	u32 multi_or_single_block_select;
}TransModeStruct;

struct  sd_ctrl_dev{
	int base_addr;
	int clk_freq;
	int f_min;
	int f_max;
	int app_cmd;
	TransModeStruct *TransModePtr;
};

void sd_ctrl_write(struct sd_ctrl_dev *dev, uint32_t offset, uint32_t data);
uint32_t sd_ctrl_read(struct sd_ctrl_dev *dev, uint32_t offset);
int sd_ctrl_set_clk(struct mmc *mmc);
int sd_ctrl_mmc_probe(struct mmc *mmc ,int base_addr);


#endif /* SRC_EFX_MMC_DRIVER_H_ */
