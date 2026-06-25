
#include "type.h"
#include "bsp.h"
#include "dmasg.h"
#include "riscv.h"
#include "plic.h"

#define DMASG_BASE		IO_APB_SLAVE_0_INPUT
#define FRAME_RATE		16
#define BUFFER_SIZE		1024 * 1024
//#define FRAME_RATE		5
//#define BUFFER_SIZE		1280

#define ST32_IN			1	//WRITE
#define ST32_OUT		0	//READ
#define ST8_IN			3	//WRITE
#define ST8_OUT		    2	//READ

//#define mem32 ((volatile uint32_t*)0x10000)
//#define dbSG  ((volatile uint32_t*)0x20000)

volatile struct dmasg_descriptor descriptors0[FRAME_RATE+1]  __attribute__ ((aligned (64)));
volatile struct dmasg_descriptor descriptors1[FRAME_RATE+1]  __attribute__ ((aligned (64)));

#define sb 		((volatile uint32_t*)0x00010000)
#define dbSG 	((volatile uint32_t*)0x04010000)
#define dbSGM	((volatile uint32_t*)0x08010000)
#define dbDM 	((volatile uint32_t*)0x0C010000)
#define dbMM 	((volatile uint32_t*)0x14010000)
#define dbDM8	((volatile uint32_t*)0x10010000)

void trap_entry();
void dmaInterrupt();


uint64_t	timestamp_s,timestamp_e;
float		cycle_process,time_process;
float 		speed;
int			dma_mode=0;

uint64_t	timestamp1_s,timestamp1_e;
float		cycle_process1,time_process1;
float 		speed1;


void crash(){
    bsp_printf("\r\n*** CRASH ***\r\n");
    while(1);
}

void program_circular_descriptor() {
	for (int j=0; j<FRAME_RATE; j=j+1 ) {
       if(j == FRAME_RATE-1) {
    	   descriptors0[j].control = (BUFFER_SIZE*4)-1  | DMASG_DESCRIPTOR_CONTROL_NO_COMPLETION ;
    	   descriptors0[j].from    = 0;
    	   descriptors0[j].to      = (u32)(dbSGM + (j *(BUFFER_SIZE)) );
    	   descriptors0[j].next    = (u32) (descriptors0);
    	   descriptors0[j].status  = 0;
    	   descriptors1[j].control = (BUFFER_SIZE*4)-1  | DMASG_DESCRIPTOR_CONTROL_NO_COMPLETION ;
    	   descriptors1[j].from    = (u32)(sb + (j *(BUFFER_SIZE)));
    	   descriptors1[j].to      = 0;
    	   descriptors1[j].next    = (u32) (descriptors1);
    	   descriptors1[j].status  = 0;
       } else {
        	descriptors0[j].control = (BUFFER_SIZE*4)-1  | DMASG_DESCRIPTOR_CONTROL_NO_COMPLETION ;
        	descriptors0[j].from    = 0;
        	descriptors0[j].to      = (u32)(dbSGM + (j *(BUFFER_SIZE)) );
        	descriptors0[j].next    = (u32) (descriptors0 + (j+1));
        	descriptors0[j].status  = 0;
        	descriptors1[j].control = (BUFFER_SIZE*4)-1  | DMASG_DESCRIPTOR_CONTROL_NO_COMPLETION ;
        	descriptors1[j].from    = (u32)(sb + (j *(BUFFER_SIZE)));
        	descriptors1[j].to      = 0;
        	descriptors1[j].next    = (u32) (descriptors1 + (j+1));
        	descriptors1[j].status  = 0;
       }
	}
}

void program_descriptor() {
	for (int j=0; j<FRAME_RATE+1; j=j+1 ) {
       if(j == FRAME_RATE) {
        	descriptors0[j].status  = DMASG_DESCRIPTOR_STATUS_COMPLETED;
        	descriptors1[j].status  = DMASG_DESCRIPTOR_STATUS_COMPLETED;
       } else {
        	descriptors0[j].control = ((BUFFER_SIZE*4)-1)  | DMASG_DESCRIPTOR_CONTROL_END_OF_PACKET;
        	descriptors0[j].from    = 0;
        	descriptors0[j].to      = (u32)(dbSGM + (j *(BUFFER_SIZE)) );
        	descriptors0[j].next    = (u32) (descriptors0 + (j+1));
        	descriptors0[j].status  = 0;
        	descriptors1[j].control = ((BUFFER_SIZE*4)-1)  | DMASG_DESCRIPTOR_CONTROL_END_OF_PACKET;
        	descriptors1[j].from    = (u32)(sb + (j *(BUFFER_SIZE)));
        	descriptors1[j].to      = 0;
        	descriptors1[j].next    = (u32) (descriptors1 + (j+1));
        	descriptors1[j].status  = 0;
        //}
       }
	}
}

int check_data (uint32_t *ptrData){
    for(u32 k=0;k<BUFFER_SIZE*FRAME_RATE;k++) {
    	if( *(ptrData + k) != 0x1000+k ){
            bsp_printf("data mismatched at pointer location %d\r\n",k);
            bsp_printf("return value=%x and expected value=%x\r\n",*(ptrData+k), 0x1000+k);
            return 1;
        }

    }
    return 0;
}

void dmaInterrupt(){
    uint32_t claim;
    //While there is pending interrupts
    while(claim = plic_claim(BSP_PLIC, BSP_PLIC_CPU_0)){
        switch(claim){
        case SYSTEM_PLIC_USER_INTERRUPT_B_INTERRUPT:
        	dmasg_interrupt_pending_clear(DMASG_BASE,ST32_IN,0xFFFFFFFF);
        	timestamp_e=clint_getTime(BSP_CLINT);
        	cycle_process=(timestamp_e-timestamp_s);
            time_process=cycle_process/SYSTEM_CLINT_HZ;
            speed=(FRAME_RATE*BUFFER_SIZE*4)/time_process;
            bsp_printf("r/w speed: %f MB/s\r\n", speed/(1024*1024));
        	dmasg_interrupt_pending_clear(DMASG_BASE,ST32_IN,0x0);

        	dma_mode+=1;
        	break;
        case SYSTEM_PLIC_USER_INTERRUPT_D_INTERRUPT:
        	dmasg_interrupt_pending_clear(DMASG_BASE,ST8_IN,0xFFFFFFFF);
        	timestamp1_e=clint_getTime(BSP_CLINT);
        	cycle_process1=(timestamp1_e-timestamp1_s);
            time_process1=cycle_process1/SYSTEM_CLINT_HZ;
            speed1=(FRAME_RATE*BUFFER_SIZE*4)/time_process1;
            bsp_printf("r/w speed: %f MB/s\r\n", speed1/(1024*1024));
        	dmasg_interrupt_pending_clear(DMASG_BASE,ST8_IN,0x0);

        	dma_mode+=1;
        	break;
        default: crash(); break;
        }
        //unmask the claimed interrupt
        plic_release(BSP_PLIC, BSP_PLIC_CPU_0, claim);
    }
}

void trap(){
    int32_t mcause = csr_read(mcause);
    int32_t interrupt = mcause < 0;    //Interrupt if true, exception if false
    int32_t cause     = mcause & 0xF;
    if(interrupt){
        switch(cause){
        case CAUSE_MACHINE_EXTERNAL: dmaInterrupt(); break;
        default: crash(); break;
        }
    } else {
        crash();
    }
}

void dmaInit(){
    dmasg_priority(DMASG_BASE, ST32_OUT, 1, 1);
    dmasg_priority(DMASG_BASE, ST32_IN , 1, 1);
    dmasg_priority(DMASG_BASE, ST8_OUT , 0, 0);
    dmasg_priority(DMASG_BASE, ST8_IN  , 0, 0);

    dmasg_interrupt_config(DMASG_BASE,ST32_IN,DMASG_CHANNEL_INTERRUPT_CHANNEL_COMPLETION_MASK);
    dmasg_interrupt_config(DMASG_BASE,ST8_IN,DMASG_CHANNEL_INTERRUPT_CHANNEL_COMPLETION_MASK);
    //configure PLIC
    //cpu 0 accept all interrupts with priority above 0
    plic_set_threshold(BSP_PLIC, BSP_PLIC_CPU_0, 0);
    plic_set_enable(BSP_PLIC, BSP_PLIC_CPU_0, SYSTEM_PLIC_USER_INTERRUPT_B_INTERRUPT, 1);
    plic_set_priority(BSP_PLIC, SYSTEM_PLIC_USER_INTERRUPT_B_INTERRUPT, 1);
    plic_set_enable(BSP_PLIC, BSP_PLIC_CPU_0, SYSTEM_PLIC_USER_INTERRUPT_D_INTERRUPT, 1);
    plic_set_priority(BSP_PLIC, SYSTEM_PLIC_USER_INTERRUPT_D_INTERRUPT, 1);
    //enable interrupts
    //Set the machine trap vector (../common/trap.S)
    csr_write(mtvec, trap_entry);
    //Enable external interrupts
    csr_set(mie, MIE_MEIE);
    csr_write(mstatus, csr_read(mstatus) | MSTATUS_MPP | MSTATUS_MIE);
}

void main() {

	dmaInit();

    bsp_printf("Pre-fill known data to source buffer .. ");
    for(u32 a=0;a<BUFFER_SIZE*FRAME_RATE;a++) {
    	*(sb+a) = 0x1000+a;
    }
    bsp_printf("done\r\n");
/*
	bsp_printf("DMA (8b) in direct transfer mode with self restart .. \r\n");

    dmasg_output_memory (DMASG_BASE, ST8_IN,  (uint32_t)dbDM8, 16);
    dmasg_input_stream(DMASG_BASE, ST8_IN, 0, 1, 0);
    dmasg_direct_start(DMASG_BASE, ST8_IN, BUFFER_SIZE*FRAME_RATE*4, 1);

    dmasg_input_memory (DMASG_BASE, ST8_OUT,  (uint32_t)sb, 16);
    dmasg_output_stream(DMASG_BASE, ST8_OUT, 0, 0, 0, 1);
    dmasg_direct_start(DMASG_BASE, ST8_OUT, BUFFER_SIZE*FRAME_RATE*4, 1);
*/

    bsp_printf("DMA (32b) in memory-to-memory mode .. ");

    dmasg_input_memory (DMASG_BASE, ST32_IN, (uint32_t)sb, 16);
    dmasg_output_memory(DMASG_BASE, ST32_IN, (uint32_t)dbMM, 16);
    timestamp_s = clint_getTime(BSP_CLINT);
    dmasg_direct_start (DMASG_BASE, ST32_IN, BUFFER_SIZE*FRAME_RATE*4, 0);

    while(dma_mode != 1);
    if(check_data((uint32_t *)dbMM)) { bsp_printf("DMA memory-to-memory test fails\r\n"); }
    else {bsp_printf("data check done!\r\n");}

    bsp_printf("DMA (32b) in custom sg linked-list mode .. ");

    dmasg_output_memory (DMASG_BASE, ST32_IN,  0, 16);
    dmasg_input_stream(DMASG_BASE, ST32_IN, 0, 1, 0);
    dmasg_linked_list_sg_start(DMASG_BASE, ST32_IN);

    dmasg_input_memory (DMASG_BASE, ST32_OUT,  0, 16);
    dmasg_output_stream(DMASG_BASE, ST32_OUT, 0, 0, 0, 1);
    timestamp_s = clint_getTime(BSP_CLINT);
    dmasg_linked_list_sg_start(DMASG_BASE, ST32_OUT);
    
    /* polling mode
    while(dmasg_busy(DMASG_BASE, ST32_OUT));
    data_cache_invalidate_all();
    while(dmasg_busy(DMASG_BASE, ST32_IN));
    data_cache_invalidate_all();
    */

    while(dma_mode != 2);
    if(check_data((uint32_t *)dbSG)) { bsp_printf("DMA SG test fails\r\n"); }
    else {bsp_printf("data check done!\r\n");}


    bsp_printf("DMA (32b) in normal sg mode .. ");
    program_descriptor();
    dmasg_output_memory (DMASG_BASE, ST32_IN,  0, 16);
    dmasg_input_stream(DMASG_BASE, ST32_IN, 0, 1, 0);
    dmasg_linked_list_start(DMASG_BASE, ST32_IN, (u32) descriptors0);

    dmasg_input_memory (DMASG_BASE, ST32_OUT,  0, 16);
    dmasg_output_stream(DMASG_BASE, ST32_OUT, 0, 0, 0, 1);
    timestamp_s = clint_getTime(BSP_CLINT);
    dmasg_linked_list_start(DMASG_BASE, ST32_OUT, (u32) descriptors1);

    /* polling mode
    while(dmasg_busy(DMASG_BASE, ST32_OUT));
    data_cache_invalidate_all();
    while(dmasg_busy(DMASG_BASE, ST32_IN));
    data_cache_invalidate_all();
    */

    while(dma_mode != 3);
    if(check_data((uint32_t *)dbSGM)) { bsp_printf("DMA normal sg test fails\r\n"); }
    else {bsp_printf("data check done!\r\n");}


    bsp_printf("DMA (32b) in direct transfer mode .. ");

    dmasg_output_memory (DMASG_BASE, ST32_IN,  (uint32_t)dbDM, 16);
    dmasg_input_stream(DMASG_BASE, ST32_IN, 0, 1, 0);
    dmasg_direct_start(DMASG_BASE, ST32_IN, BUFFER_SIZE*FRAME_RATE*4, 0);

    dmasg_input_memory (DMASG_BASE, ST32_OUT,  (uint32_t)sb, 16);
    dmasg_output_stream(DMASG_BASE, ST32_OUT, 0, 0, 0, 1);
    timestamp_s = clint_getTime(BSP_CLINT);
    dmasg_direct_start(DMASG_BASE, ST32_OUT, BUFFER_SIZE*FRAME_RATE*4, 0);

    /*polling mode
    while(dmasg_busy(DMASG_BASE, ST32_OUT));
    data_cache_invalidate_all();
    while(dmasg_busy(DMASG_BASE, ST32_IN));
    data_cache_invalidate_all();
    */

    while(dma_mode != 4);
	if(check_data((uint32_t *)dbDM)) { bsp_printf("DMA direct mode test fails\r\n"); }
	else {bsp_printf("data check done!\r\n");}

	/*stop channel 3 and 4
	bsp_printf("Stop DMA (8b) operation ..");
	dmasg_stop(DMASG_BASE, ST8_IN);
	dmasg_stop(DMASG_BASE, ST8_OUT);
	*/

	bsp_printf("DMA (8b) in direct transfer mode .. ");

    dmasg_output_memory (DMASG_BASE, ST8_IN,  (uint32_t)dbDM8, 16);
    dmasg_input_stream(DMASG_BASE, ST8_IN, 0, 1, 0);
    dmasg_direct_start(DMASG_BASE, ST8_IN, BUFFER_SIZE*FRAME_RATE*4, 0);

    dmasg_input_memory (DMASG_BASE, ST8_OUT,  (uint32_t)sb, 16);
    dmasg_output_stream(DMASG_BASE, ST8_OUT, 0, 0, 0, 1);
    timestamp1_s = clint_getTime(BSP_CLINT);
    dmasg_direct_start(DMASG_BASE, ST8_OUT, BUFFER_SIZE*FRAME_RATE*4, 0);

    //while(dmasg_busy(DMASG_BASE, ST8_OUT));
    //data_cache_invalidate_all();
    //while(dmasg_busy(DMASG_BASE, ST8_IN));
    //Xdata_cache_invalidate_all();

    while(dma_mode != 5);
    if(check_data((uint32_t *)dbDM8)) { bsp_printf("DMA (8b) direct mode test fails\r\n"); }
    else {bsp_printf("check done!\r\n");}

}

