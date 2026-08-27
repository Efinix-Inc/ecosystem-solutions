////////////////////////////////////////////////////////////////////////////
//           _____
//          / _______    Copyright (C) 2013-2022 Efinix Inc. All rights reserved.
//         / /       \
//        / /  ..    /
//       / / .'     /
//    __/ /.'      /     Description:
//   __   \       /       interrupt initial for TI180M484 dev kit OOB design
//  /_/ /\ \_____/ /
// ____/  \_______/
//
// ***********************************************************************

#include "bsp.h"
#include "intc.h"
#include "userdef.h"

int flash_led =0;
u32 flash_led_count =0;

IntStruct IntPtr;
struct sd_ctrl_dev *dev;

#define MAX_SPRIT_LINE		2
#define MAX_LINE_OUT		1080

extern struct dmasg_descriptor descriptors0[MAX_LINE_OUT*MAX_SPRIT_LINE+1]  __attribute__ ((aligned (64)));

int ds_index = 0;

int flashled;
int ChannelCount[4];


void printb(uint8_t * data) {
      uart_writeStr(BSP_UART_TERMINAL, data);
    }

void print_hexb(uint32_t val, uint32_t digits)
{
    for (int i = (4*digits)-4; i >= 0; i -= 4)
        uart_write(BSP_UART_TERMINAL, "0123456789ABCDEF"[(val >> i) % 16]);
}

/************************** Function Definitions *****************************/
void trap_entry();

/********************************* Function **********************************/
void UserInterruptSDIsr()
{
	u32 int_status;
	sd_ctrl_write(dev,SDHC_ADDR+REG_NORMAL_INTERRUPT_STATUS1+4,0x00);

	int_status = sd_ctrl_read(dev,SDHC_ADDR+REG_NORMAL_INTERRUPT_STATUS0);

	if(int_status&INT_COMMAND_COMPLETE) {
		IntPtr.command_complete = 0x1;
		sd_ctrl_write(dev,SDHC_ADDR+REG_NORMAL_INTERRUPT_STATUS0,INT_COMMAND_COMPLETE);
		if(DEBUG_PRINTF_EN == 1) {
			uart_writeStr(UART_0,"INT : COMMAND_COMPLETE\n\r");
		}
	}

	if(int_status&INT_TRANSFER_COMPLETE) {
		IntPtr.transfer_complete = 0x1;
		sd_ctrl_write(dev,SDHC_ADDR+REG_NORMAL_INTERRUPT_STATUS0,INT_TRANSFER_COMPLETE);
		if(DEBUG_PRINTF_EN == 1) {
			uart_writeStr(UART_0,"INT : TRANSFER_COMPLETE\n\r");
		}
	}

	if(int_status&INT_BLOCK_GAP_EVENT) {
		IntPtr.block_gap_event = 0x1;
		sd_ctrl_write(dev,SDHC_ADDR+REG_NORMAL_INTERRUPT_STATUS0,INT_BLOCK_GAP_EVENT);
		if(DEBUG_PRINTF_EN == 1) {
			uart_writeStr(UART_0,"INT : BLOCK_GAP_EVENT\n\r");
		}
	}

	if(int_status&INT_BUFFER_WRITE_READY) {
		//IntPtr.buffer_write_ready = 0x1;
		sd_ctrl_write(dev,SDHC_ADDR+REG_NORMAL_INTERRUPT_STATUS0,INT_BUFFER_WRITE_READY);
		if(DEBUG_PRINTF_EN == 1) {
			uart_writeStr(UART_0,"INT : BUFFER_WRITE_READY\n\r");
		}
	}

	if(int_status&INT_BUFFER_READ_READY) {
		//IntPtr.buffer_read_ready = 0x1;
		sd_ctrl_write(dev,SDHC_ADDR+REG_NORMAL_INTERRUPT_STATUS0,INT_BUFFER_READ_READY);
		if(DEBUG_PRINTF_EN == 1) {
			uart_writeStr(UART_0,"INT : BUFFER_READ_READY\n\r");
		}
	}

	if(int_status&INT_CARD_INSERTION) {
		IntPtr.card_insertion = 0x1;
		sd_ctrl_write(dev,SDHC_ADDR+REG_NORMAL_INTERRUPT_STATUS0,INT_CARD_INSERTION);
		if(DEBUG_PRINTF_EN == 1) {
			uart_writeStr(UART_0,"INT : CARD_INSERTION\n\r");
		}
	}

	if(int_status&INT_CARD_REMOVAL) {
		IntPtr.card_removal = 0x1;
		sd_ctrl_write(dev,SDHC_ADDR+REG_NORMAL_INTERRUPT_STATUS0,INT_CARD_REMOVAL);
		if(DEBUG_PRINTF_EN == 1) {
			uart_writeStr(UART_0,"INT : CARD_REMOVAL\n\r");
		}
	}

	if(int_status&INT_COMMAND_TIMEOUT_ERROR) {
		IntPtr.command_timeout_error = 0x1;
		sd_ctrl_write(dev,SDHC_ADDR+REG_NORMAL_INTERRUPT_STATUS0,INT_COMMAND_TIMEOUT_ERROR);
		if(DEBUG_PRINTF_EN == 1) {
			uart_writeStr(UART_0,"INT : COMMAND_TIMEOUT_ERROR\n\r");
		}
	}

	if(int_status&INT_COMMAND_CRC_ERROR) {
		IntPtr.command_crc_error = 0x1;
		sd_ctrl_write(dev,SDHC_ADDR+REG_NORMAL_INTERRUPT_STATUS0,INT_COMMAND_CRC_ERROR);
		if(DEBUG_PRINTF_EN == 1) {
			uart_writeStr(UART_0,"INT : COMMAND_CRC_ERROR\n\r");
		}
	}

	if(int_status&INT_COMMAND_END_BIT_ERROR) {
		IntPtr.command_end_bit_error = 0x1;
		sd_ctrl_write(dev,SDHC_ADDR+REG_NORMAL_INTERRUPT_STATUS0,INT_COMMAND_END_BIT_ERROR);
		if(DEBUG_PRINTF_EN == 1) {
			uart_writeStr(UART_0,"INT : COMMAND_END_BIT_ERROR\n\r");
		}
	}

	if(int_status&INT_COMMAND_INDEX_ERROR) {
		IntPtr.command_index_error = 0x1;
		sd_ctrl_write(dev,SDHC_ADDR+REG_NORMAL_INTERRUPT_STATUS0,INT_COMMAND_INDEX_ERROR);
		if(DEBUG_PRINTF_EN == 1) {
			uart_writeStr(UART_0,"INT : COMMAND_INDEX_ERROR\n\r");
		}
	}

	if(int_status&INT_DATA_CRC_ERROR) {
		//IntPtr.data_crc_error = 0x1;
		sd_ctrl_write(dev,SDHC_ADDR+REG_NORMAL_INTERRUPT_STATUS0,INT_DATA_CRC_ERROR);
		if(DEBUG_PRINTF_EN == 1) {
			uart_writeStr(UART_0,"INT : DATA_CRC_ERROR\n\r");
		}
	}

	sd_ctrl_write(dev,SDHC_ADDR+REG_NORMAL_INTERRUPT_STATUS1+4,INT_ENABLE);
}

// Check the status of the specified channel.
static u32 dmasg_read_channelState(u32 base, u32 channel , u32 mask){
    u32 ca = dmasg_ca(base, channel);
    return read_u32(ca + DMASG_CHANNEL_INTERRUPT_PENDING) & mask;
}



void UserInterruptDMAIsr(){


	if (dmasg_read_channelState(DMASG_BASE, DMASG_CHANNEL0, DMASG_CHANNEL_INTERRUPT_INPUT_PACKET_MASK) )
	{
		dmasg_interrupt_pending_clear(DMASG_BASE, DMASG_CHANNEL0, DMASG_CHANNEL_INTERRUPT_INPUT_PACKET_MASK);  //Disable dmasg channel interrupt
		ChannelCount[0]++;
		if(ChannelCount[0]>=10)
		{
			ChannelCount[0] =0;
			flashled ^= 0x01;
			APB3_REGW(OOB_APB_SLV, APB3_SLV_REG_LED_CONTROL, flashled);
		}
	}
	if (dmasg_read_channelState(DMASG_BASE, DMASG_CHANNEL1, DMASG_CHANNEL_INTERRUPT_INPUT_PACKET_MASK) )
	{
		dmasg_interrupt_pending_clear(DMASG_BASE, DMASG_CHANNEL1, DMASG_CHANNEL_INTERRUPT_INPUT_PACKET_MASK);  //Disable dmasg channel interrupt
		ChannelCount[1]++;
		if(ChannelCount[1]>=10)
		{
			ChannelCount[1] =0;
			flashled ^= 0x02;
			APB3_REGW(OOB_APB_SLV, APB3_SLV_REG_LED_CONTROL, flashled);
		}
	}
	if (dmasg_read_channelState(DMASG_BASE, DMASG_CHANNEL2, DMASG_CHANNEL_INTERRUPT_INPUT_PACKET_MASK) )
	{
		dmasg_interrupt_pending_clear(DMASG_BASE, DMASG_CHANNEL2, DMASG_CHANNEL_INTERRUPT_INPUT_PACKET_MASK);  //Disable dmasg channel interrupt
		ChannelCount[2]++;
		if(ChannelCount[2]>=10)
		{
			ChannelCount[2] =0;
			flashled ^= 0x04;
			APB3_REGW(OOB_APB_SLV, APB3_SLV_REG_LED_CONTROL, flashled);
		}
	}
	if (dmasg_read_channelState(DMASG_BASE, DMASG_CHANNEL3, DMASG_CHANNEL_INTERRUPT_INPUT_PACKET_MASK) )
	{
		dmasg_interrupt_pending_clear(DMASG_BASE, DMASG_CHANNEL3, DMASG_CHANNEL_INTERRUPT_INPUT_PACKET_MASK);  //Disable dmasg channel interrupt
		ChannelCount[3]++;
		if(ChannelCount[3]>=10)
		{
			ChannelCount[3] =0;
			flashled ^= 0x08;
			APB3_REGW(OOB_APB_SLV, APB3_SLV_REG_LED_CONTROL, flashled);
		}
	}



/*

	if (dmasg_busy(DMASG_BASE, DMASG_CHANNEL0) )
	{

	//	dmasg_interrupt_config(DMASG_BASE, DMASG_CHANNEL0, DMASG_CHANNEL_INTERRUPT_INPUT_PACKET_MASK);  //Disable dmasg channel interrupt
		dmasg_interrupt_pending_clear(DMASG_BASE, DMASG_CHANNEL0, DMASG_CHANNEL_INTERRUPT_INPUT_PACKET_MASK);  //Disable dmasg channel interrupt
		flash_led_count++;

		if(flash_led_count>=10)
			//if(1)
		{
			flash_led_count=0;

			u32 apb3_rd = APB3_REGR(OOB_APB_SLV, APB3_SLV_REG_LED_CONTROL);

			if(flashled[0] == 0)
			{
				flashled[0] = 1;
				APB3_REGW(OOB_APB_SLV, APB3_SLV_REG_LED_CONTROL, 0xf);
			}
			else
			{
				flashled[0] = 0;
				APB3_REGW(OOB_APB_SLV, APB3_SLV_REG_LED_CONTROL, 0x0);
			}

		}
	}

	if (dmasg_busy(DMASG_BASE, DMASG_CHANNEL1) )
	{

	APB3_REGW(OOB_APB_SLV, APB3_SLV0_REG4_DEBUG, 0x01);
	//	APB3_REGW(OOB_APB_SLV, APB3_SLV0_REG2_STREAM_CTRL, 0x02);
	//	dmasg_interrupt_config(DMASG_BASE, DMASG_CHANNEL1, DMASG_CHANNEL_INTERRUPT_DESCRIPTOR_COMPLETION_MASK);  //Disable dmasg channel interrupt
		dmasg_interrupt_config(DMASG_BASE, DMASG_CHANNEL1, DMASG_CHANNEL_INTERRUPT_LINKED_LIST_UPDATE_MASK);

		//	dmasg_direct_start(DMASG_BASE, DMASG_CHANNEL1,((u32)(FRAME_SIZE*4)), 1);
	//	APB3_REGW(OOB_APB_SLV, APB3_SLV0_REG2_STREAM_CTRL, 0x03);
	//	dmasg_direct_start(DMASG_BASE, DMASG_CHANNEL1,((u32)(FRAME_SIZE*4)), 0);//  dmasg_start(DMASG_BASE, DMASG_CHANNEL1, xDataLength, 0);
	//	uart_writeStr(UART_0, "DMA CH1*\n");

	//	dmasg_direct_start(DMASG_BASE, DMASG_CHANNEL1,((u32)(FRAME_SIZE*4)), 0);//  dmasg_start(DMASG_BASE, DMASG_CHANNEL1, xDataLength, 0);

		descriptors0[ds_index].status  = 0;
		ds_index ++;
		if(ds_index==4)
			ds_index =0;

		APB3_REGW(OOB_APB_SLV, APB3_SLV0_REG4_DEBUG, 0x00);
	//	uart_writeStr(UART_0, "DMA CH1*\n");
	}*/

	//uart_writeStr(UART_0,"INT : Interrupt B\n\r");
}

/********************************* Function **********************************/
//Used on unexpected trap/interrupt codes
void crash(){
	uart_writeStr(UART_0, "\n*** CRASH ***\n");
	while(1);
}

void crash_test(uint32_t value){

	printb(" with value 0x");

	print_hexb(value, 8);
				printb(" \n\r");
	uart_writeStr(UART_0, "\n*** CRASH ***\n");
	while(1);
}

void crash_testB(uint32_t value){

	printb(" with value 0x");

	print_hexb(value, 8);
				printb(" \n\r");
}

void userInterrupt(){
	//struct example_apb3_ctrl_reg cfg={0};
	uint32_t claim;
	//While there is pending interrupts
	while(claim = plic_claim(BSP_PLIC, BSP_PLIC_CPU_0)){
		switch(claim){
		case SYSTEM_PLIC_USER_INTERRUPT_A_INTERRUPT:
			break;
		case SYSTEM_PLIC_USER_INTERRUPT_B_INTERRUPT:
			UserInterruptSDIsr(); break;
		case SYSTEM_PLIC_USER_INTERRUPT_C_INTERRUPT:
			UserInterruptDMAIsr(); break;
		default:
			printb("userInterrupt \n\r");
			crash_test( claim);
			break;
		}
		plic_release(BSP_PLIC, BSP_PLIC_CPU_0, claim); //unmask the claimed interrupt
	}
}

//Called by trap_entry on both exceptions and interrupts events
void trap(){
	int32_t mcause = csr_read(mcause);
	int32_t interrupt = mcause < 0;    //Interrupt if true, exception if false
	int32_t cause     = mcause & 0xF;
	if(interrupt){
		switch(cause){
		case CAUSE_MACHINE_EXTERNAL: userInterrupt(); break;
		default:
			printb("trap interrupt\n\r");
			crash_test( cause);
			break;
		}
	} else {
		printb("NoInt \n\r");
		crash_testB(mcause);
		crash_test( interrupt);

	}
}

void IntcInitialize()
{
	flashled = 0;
	for(int i=0; i<4 ;i++)
	{
		ChannelCount[i] = 0;
	}


	//printb("Start Int Init \n\r");
	//configure PLIC
	plic_set_threshold(BSP_PLIC, BSP_PLIC_CPU_0, 0); //cpu 0 accept all interrupts with priority above 0

	//enable SYSTEM_PLIC_USER_INTERRUPT_A_INTERRUPT rising edge interrupt (SDHC)
	plic_set_enable(BSP_PLIC, BSP_PLIC_CPU_0, SYSTEM_PLIC_USER_INTERRUPT_B_INTERRUPT, 1);
	plic_set_priority(BSP_PLIC, SYSTEM_PLIC_USER_INTERRUPT_B_INTERRUPT, 1);

	//enable SYSTEM_PLIC_USER_INTERRUPT_B_INTERRUPT rising edge interrupt (DMA)
	plic_set_enable(BSP_PLIC, BSP_PLIC_CPU_0, SYSTEM_PLIC_USER_INTERRUPT_C_INTERRUPT, 1);
	plic_set_priority(BSP_PLIC, SYSTEM_PLIC_USER_INTERRUPT_C_INTERRUPT, 2);


	//enable riscV interrupts
	csr_write(mtvec, trap_entry); //Set the machine trap vector (../common/trap.S)
//	csr_set(mie, MIE_MTIE | MIE_MEIE); //Enable machine timer and external interrupts
	csr_set(mie, MIE_MEIE); //Enable machine timer and external interrupts
	csr_write(mstatus, MSTATUS_MPP | MSTATUS_MIE);


}

void IntcSDInitialize(struct mmc *mmc)
{
	dev=mmc->priv;

	//enable User interrupts
	sd_ctrl_write(dev,SDHC_ADDR+REG_NORMAL_INTERRUPT_STATUS1,0x00);		//Clean All Interrupts Status
	sd_ctrl_write(dev,SDHC_ADDR+REG_NORMAL_INTERRUPT_STATUS1,INT_ENABLE);		//Enable All Interrupts Status
	sd_ctrl_write(dev,SDHC_ADDR+REG_NORMAL_INTERRUPT_STATUS1+4,INT_ENABLE);		//Open All Interrupts Signal


}
