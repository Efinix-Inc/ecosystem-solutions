/*
 * intc.h
 *
 *  Created on: 2022年4月2日
 *      Author: jefferyl
 */

#ifndef SRC_INTC_H_
#define SRC_INTC_H_

#define DMASG_BASE            	IO_APB_SLAVE_0_INPUT
#define CNN_IP_BASE_ADDR		IO_APB_SLAVE_2_INPUT


#define CS_SG_APB_SLV			IO_APB_SLAVE_3_INPUT

#include <stdint.h>
#include "riscv.h"
#include "plic.h"
#include "bsp.h"
#include "dmasg.h"
#include "project.h"

//For interrupt signal
extern uint8_t cam_s2mm_active;
extern uint8_t display_mm2s_active;
extern volatile uint8_t ecnn_intc_done;


//Each channel connects to only 1 port, hence all ports are referred as port 0.
#define DMASG_CAM_S2MM_CHANNEL         0
#define DMASG_CAM_S2MM_PORT            0

#define DMASG_DISPLAY_MM2S_CHANNEL     1
#define DMASG_DISPLAY_MM2S_PORT        0

#define DMASG_MSCALE_IN_MM2S_CHANNEL   2
#define DMASG_MSCALE_IN_MM2S_PORT      0

#define DMASG_MSCALE_R_SS2M_CHANNEL    3
#define DMASG_MSCALE_R_SS2M_PORT       0

#define DMASG_MSCALE_G_SS2M_CHANNEL    4
#define DMASG_MSCALE_G_SS2M_PORT       0

#define DMASG_MSCALE_B_SS2M_CHANNEL    5
#define DMASG_MSCALE_B_SS2M_PORT       0

#ifdef __cplusplus
extern "C" {
#endif

/************************** Variable Definitions *****************************/

/************************** Function Definitions *****************************/
void IntcInitialize();
void userInterrupt();
void trap_entry();
void trap();
void trigger_next_display_dma();
void trigger_next_cam_dma();
void trigger_next_box_dma();

#ifdef __cplusplus
}
#endif
#endif /* SRC_INTC_H_ */
