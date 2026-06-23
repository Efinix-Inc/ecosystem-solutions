
build/bootloader.elf:     file format elf32-littleriscv


Disassembly of section .init:

f9000000 <_start>:

_start:
#ifdef USE_GP
.option push
.option norelax
	la gp, __global_pointer$
f9000000:	00001197          	auipc	gp,0x1
f9000004:	c2818193          	addi	gp,gp,-984 # f9000c28 <__global_pointer$>
.global smp_lottery_target
.global smp_lottery_lock
.global smp_slave


  sw x0, smp_lottery_lock, a1
f9000008:	8201a023          	sw	zero,-2016(gp) # f9000448 <smp_lottery_lock>

f900000c <smp_tyranny>:

smp_tyranny:
  csrr a0, mhartid
f900000c:	f1402573          	csrr	a0,mhartid
  beqz a0, init
f9000010:	c515                	beqz	a0,f900003c <init>

f9000012 <smp_slave>:

smp_slave:
	lw a0, smp_lottery_lock
f9000012:	8201a503          	lw	a0,-2016(gp) # f9000448 <smp_lottery_lock>
	beqz a0, smp_slave
f9000016:	dd75                	beqz	a0,f9000012 <smp_slave>

	fence r, r
f9000018:	0220000f          	fence	r,r
f900001c:	0000100f          	fence.i
	//li a1, -1
	//amoadd.w x0, a1,(a0)

	.word(0x100F) //i$ flush
	lw a5, smp_lottery_target
f9000020:	81c1a783          	lw	a5,-2020(gp) # f9000444 <__bss_start>
	li a0, 0
f9000024:	4501                	li	a0,0
	li a1, 0
f9000026:	4581                	li	a1,0
	li a2, 0
f9000028:	4601                	li	a2,0
	jr a5
f900002a:	8782                	jr	a5

f900002c <smp_unlock>:

.global   smp_unlock
.type    smp_unlock,%function
smp_unlock:
	sw a0, smp_lottery_target, a1
f900002c:	80a1ae23          	sw	a0,-2020(gp) # f9000444 <__bss_start>
	fence w, w
f9000030:	0110000f          	fence	w,w
	li a0, 1
f9000034:	4505                	li	a0,1
	sw a0, smp_lottery_lock, a1
f9000036:	82a1a023          	sw	a0,-2016(gp) # f9000448 <smp_lottery_lock>
    ret
f900003a:	8082                	ret

f900003c <init>:
#endif

init:
	la sp, _sp
f900003c:	92818113          	addi	sp,gp,-1752 # f9000550 <_sp>

	/* Load data section */
	la a0, _data_lma
f9000040:	80c18513          	addi	a0,gp,-2036 # f9000434 <_data>
	la a1, _data
f9000044:	80c18593          	addi	a1,gp,-2036 # f9000434 <_data>
	la a2, _edata
f9000048:	81c18613          	addi	a2,gp,-2020 # f9000444 <__bss_start>
	bgeu a1, a2, 2f
f900004c:	00c5fa63          	bgeu	a1,a2,f9000060 <init+0x24>
1:
	lw t0, (a0)
f9000050:	00052283          	lw	t0,0(a0)
	sw t0, (a1)
f9000054:	0055a023          	sw	t0,0(a1)
	addi a0, a0, 4
f9000058:	0511                	addi	a0,a0,4
	addi a1, a1, 4
f900005a:	0591                	addi	a1,a1,4
	bltu a1, a2, 1b
f900005c:	fec5eae3          	bltu	a1,a2,f9000050 <init+0x14>
2:

	/* Clear bss section */
	la a0, __bss_start
f9000060:	81c18513          	addi	a0,gp,-2020 # f9000444 <__bss_start>
	la a1, _end
f9000064:	82818593          	addi	a1,gp,-2008 # f9000450 <_end>
	bgeu a0, a1, 2f
f9000068:	00b57763          	bgeu	a0,a1,f9000076 <init+0x3a>
1:
	sw zero, (a0)
f900006c:	00052023          	sw	zero,0(a0)
	addi a0, a0, 4
f9000070:	0511                	addi	a0,a0,4
	bltu a0, a1, 1b
f9000072:	feb56de3          	bltu	a0,a1,f900006c <init+0x30>
2:

#ifndef NO_LIBC_INIT_ARRAY
	call __libc_init_array
f9000076:	2695                	jal	f90003da <__libc_init_array>
#endif

	call main
f9000078:	2e91                	jal	f90003cc <main>

f900007a <mainDone>:
mainDone:
    j mainDone
f900007a:	a001                	j	f900007a <mainDone>

f900007c <_init>:


	.globl _init
_init:
    ret
f900007c:	8082                	ret

Disassembly of section .text:

f900007e <uart_applyConfig>:
*          value using data length, parity, and stop bit settings from the configuration
*          structure, and writes this value to the UART frame configuration register.
*
******************************************************************************/
    static void uart_applyConfig(u32 reg, Uart_Config *config){
        write_u32(config->clockDivider, reg + UART_CLOCK_DIVIDER);
f900007e:	45dc                	lw	a5,12(a1)
    static inline u32 read_u32(u32 address){
        return *((volatile u32*) address);
    }
    
    static inline void write_u32(u32 data, u32 address){
        *((volatile u32*) address) = data;
f9000080:	c51c                	sw	a5,8(a0)
        write_u32(((config->dataLength-1) << 0) | (config->parity << 8) | (config->stop << 16), reg + UART_FRAME_CONFIG);
f9000082:	419c                	lw	a5,0(a1)
f9000084:	17fd                	addi	a5,a5,-1
f9000086:	41d8                	lw	a4,4(a1)
f9000088:	0722                	slli	a4,a4,0x8
f900008a:	8fd9                	or	a5,a5,a4
f900008c:	4598                	lw	a4,8(a1)
f900008e:	0742                	slli	a4,a4,0x10
f9000090:	8fd9                	or	a5,a5,a4
f9000092:	c55c                	sw	a5,12(a0)
    }
f9000094:	8082                	ret

f9000096 <clint_uDelay>:
*          and the time limit is non-negative, indicating that the delay has
*          not yet elapsed.
*
******************************************************************************/
    static void clint_uDelay(u32 usec, u32 hz, u32 reg){
        u32 mTimePerUsec = hz/1000000;
f9000096:	000f47b7          	lui	a5,0xf4
f900009a:	24078793          	addi	a5,a5,576 # f4240 <__stack_size+0xf4140>
f900009e:	02f5d5b3          	divu	a1,a1,a5
    readReg_u32 (clint_getTimeLow , CLINT_TIME_ADDR)
f90000a2:	67b1                	lui	a5,0xc
f90000a4:	17e1                	addi	a5,a5,-8
f90000a6:	963e                	add	a2,a2,a5
        return *((volatile u32*) address);
f90000a8:	421c                	lw	a5,0(a2)
        u32 limit = clint_getTimeLow(reg) + usec*mTimePerUsec;
f90000aa:	02a58533          	mul	a0,a1,a0
f90000ae:	953e                	add	a0,a0,a5
f90000b0:	421c                	lw	a5,0(a2)
        while((int32_t)(limit-(clint_getTimeLow(reg))) >= 0);
f90000b2:	40f507b3          	sub	a5,a0,a5
f90000b6:	fe07dde3          	bgez	a5,f90000b0 <clint_uDelay+0x1a>
f90000ba:	8082                	ret

f90000bc <bsp_init>:
    *   1. UART baudrate
    *   2. 
    */
////////////////////////////////////////////////////////////////////////////////
    static void bsp_init()
    {
f90000bc:	1101                	addi	sp,sp,-32
f90000be:	ce06                	sw	ra,28(sp)
        Uart_Config uartConfig;
        uartConfig.dataLength   = BITS_8;
f90000c0:	47a1                	li	a5,8
f90000c2:	c03e                	sw	a5,0(sp)
        uartConfig.parity       = NONE;
f90000c4:	c202                	sw	zero,4(sp)
        uartConfig.stop         = ONE;
f90000c6:	c402                	sw	zero,8(sp)
        uartConfig.clockDivider = BSP_CLINT_HZ/(BSP_UART_BAUDRATE*BSP_UART_DATA_LEN)-1;
f90000c8:	0d800793          	li	a5,216
f90000cc:	c63e                	sw	a5,12(sp)
        uart_applyConfig(BSP_UART_TERMINAL, &uartConfig);    
f90000ce:	858a                	mv	a1,sp
f90000d0:	e8010537          	lui	a0,0xe8010
f90000d4:	376d                	jal	f900007e <uart_applyConfig>
    }
f90000d6:	40f2                	lw	ra,28(sp)
f90000d8:	6105                	addi	sp,sp,32
f90000da:	8082                	ret

f90000dc <spi_cmdAvailability>:
f90000dc:	4148                	lw	a0,4(a0)
 * @return The availability of command buffer space (lower 16 bits of SPI buffer)
 *
 ******************************************************************************/
    static u32 spi_cmdAvailability(u32 reg){
        return read_u32(reg + SPI_BUFFER) & 0xFFFF;
    }
f90000de:	0542                	slli	a0,a0,0x10
f90000e0:	8141                	srli	a0,a0,0x10
f90000e2:	8082                	ret

f90000e4 <spi_rspOccupancy>:
f90000e4:	4148                	lw	a0,4(a0)
 * @return The occupancy of response buffer space (upper 16 bits of SPI buffer)
 *
 ******************************************************************************/
    static u32 spi_rspOccupancy(u32 reg){
        return read_u32(reg + SPI_BUFFER) >> 16;
    }
f90000e6:	8141                	srli	a0,a0,0x10
f90000e8:	8082                	ret

f90000ea <spi_write>:
 * @param reg The base address of the SPI register
 *
 * @param data The data to be written
 *
 ******************************************************************************/
    static void spi_write(u32 reg, u8 data){
f90000ea:	1141                	addi	sp,sp,-16
f90000ec:	c606                	sw	ra,12(sp)
f90000ee:	c422                	sw	s0,8(sp)
f90000f0:	c226                	sw	s1,4(sp)
f90000f2:	842a                	mv	s0,a0
f90000f4:	84ae                	mv	s1,a1
        while(spi_cmdAvailability(reg) == 0);
f90000f6:	8522                	mv	a0,s0
f90000f8:	37d5                	jal	f90000dc <spi_cmdAvailability>
f90000fa:	dd75                	beqz	a0,f90000f6 <spi_write+0xc>
        write_u32(data | SPI_CMD_WRITE, reg + SPI_DATA);
f90000fc:	1004e493          	ori	s1,s1,256
        *((volatile u32*) address) = data;
f9000100:	c004                	sw	s1,0(s0)
    }
f9000102:	40b2                	lw	ra,12(sp)
f9000104:	4422                	lw	s0,8(sp)
f9000106:	4492                	lw	s1,4(sp)
f9000108:	0141                	addi	sp,sp,16
f900010a:	8082                	ret

f900010c <spi_read>:
 * @param reg The base address of the SPI register
 *
 * @return The data read from the SPI data register
 *
 ******************************************************************************/   
    static u8 spi_read(u32 reg){
f900010c:	1141                	addi	sp,sp,-16
f900010e:	c606                	sw	ra,12(sp)
f9000110:	c422                	sw	s0,8(sp)
f9000112:	842a                	mv	s0,a0
        while(spi_cmdAvailability(reg) == 0);
f9000114:	8522                	mv	a0,s0
f9000116:	37d9                	jal	f90000dc <spi_cmdAvailability>
f9000118:	dd75                	beqz	a0,f9000114 <spi_read+0x8>
f900011a:	20000793          	li	a5,512
f900011e:	c01c                	sw	a5,0(s0)
        write_u32(SPI_CMD_READ, reg + SPI_DATA);
        while(spi_rspOccupancy(reg) == 0);
f9000120:	8522                	mv	a0,s0
f9000122:	37c9                	jal	f90000e4 <spi_rspOccupancy>
f9000124:	dd75                	beqz	a0,f9000120 <spi_read+0x14>
        return *((volatile u32*) address);
f9000126:	4008                	lw	a0,0(s0)
        return read_u32(reg + SPI_DATA);
    }
f9000128:	0ff57513          	andi	a0,a0,255
f900012c:	40b2                	lw	ra,12(sp)
f900012e:	4422                	lw	s0,8(sp)
f9000130:	0141                	addi	sp,sp,16
f9000132:	8082                	ret

f9000134 <spi_select>:
 *
 * @param reg The base address of the SPI register
 * @param slaveId The ID of the slave device to select
 *
 ******************************************************************************/
    static void spi_select(u32 reg, u32 slaveId){
f9000134:	1141                	addi	sp,sp,-16
f9000136:	c606                	sw	ra,12(sp)
f9000138:	c422                	sw	s0,8(sp)
f900013a:	c226                	sw	s1,4(sp)
f900013c:	842a                	mv	s0,a0
f900013e:	84ae                	mv	s1,a1
        while(spi_cmdAvailability(reg) == 0);
f9000140:	8522                	mv	a0,s0
f9000142:	3f69                	jal	f90000dc <spi_cmdAvailability>
f9000144:	dd75                	beqz	a0,f9000140 <spi_select+0xc>
        write_u32(slaveId | 0x80 | SPI_CMD_SS, reg + SPI_DATA);
f9000146:	6785                	lui	a5,0x1
f9000148:	88078793          	addi	a5,a5,-1920 # 880 <__stack_size+0x780>
f900014c:	8cdd                	or	s1,s1,a5
        *((volatile u32*) address) = data;
f900014e:	c004                	sw	s1,0(s0)
    }
f9000150:	40b2                	lw	ra,12(sp)
f9000152:	4422                	lw	s0,8(sp)
f9000154:	4492                	lw	s1,4(sp)
f9000156:	0141                	addi	sp,sp,16
f9000158:	8082                	ret

f900015a <spi_diselect>:
 *
 * @param reg The base address of the SPI register
 * @param slaveId The ID of the slave device to deselect
 *
 ******************************************************************************/  
    static void spi_diselect(u32 reg, u32 slaveId){
f900015a:	1141                	addi	sp,sp,-16
f900015c:	c606                	sw	ra,12(sp)
f900015e:	c422                	sw	s0,8(sp)
f9000160:	c226                	sw	s1,4(sp)
f9000162:	842a                	mv	s0,a0
f9000164:	84ae                	mv	s1,a1
        while(spi_cmdAvailability(reg) == 0);
f9000166:	8522                	mv	a0,s0
f9000168:	3f95                	jal	f90000dc <spi_cmdAvailability>
f900016a:	dd75                	beqz	a0,f9000166 <spi_diselect+0xc>
        write_u32(slaveId | 0x00 | SPI_CMD_SS, reg + SPI_DATA);
f900016c:	6785                	lui	a5,0x1
f900016e:	80078793          	addi	a5,a5,-2048 # 800 <__stack_size+0x700>
f9000172:	8cdd                	or	s1,s1,a5
f9000174:	c004                	sw	s1,0(s0)
    }
f9000176:	40b2                	lw	ra,12(sp)
f9000178:	4422                	lw	s0,8(sp)
f900017a:	4492                	lw	s1,4(sp)
f900017c:	0141                	addi	sp,sp,16
f900017e:	8082                	ret

f9000180 <spi_applyConfig>:
 * @param reg The base address of the SPI register
 * @param config Pointer to a Spi_Config structure containing the configuration settings
 *
 ******************************************************************************/
    static void spi_applyConfig(u32 reg, Spi_Config *config){
        write_u32((config->cpol << 0) | (config->cpha << 1) | (config->mode << 4), reg + SPI_CONFIG);
f9000180:	419c                	lw	a5,0(a1)
f9000182:	41d8                	lw	a4,4(a1)
f9000184:	0706                	slli	a4,a4,0x1
f9000186:	8fd9                	or	a5,a5,a4
f9000188:	4598                	lw	a4,8(a1)
f900018a:	0712                	slli	a4,a4,0x4
f900018c:	8fd9                	or	a5,a5,a4
f900018e:	c51c                	sw	a5,8(a0)
        write_u32(config->clkDivider, reg + SPI_CLK_DIVIDER);
f9000190:	45dc                	lw	a5,12(a1)
f9000192:	d11c                	sw	a5,32(a0)
        write_u32(config->ssSetup, reg + SPI_SS_SETUP);
f9000194:	499c                	lw	a5,16(a1)
f9000196:	d15c                	sw	a5,36(a0)
        write_u32(config->ssHold, reg + SPI_SS_HOLD);
f9000198:	49dc                	lw	a5,20(a1)
f900019a:	d51c                	sw	a5,40(a0)
        write_u32(config->ssDisable, reg + SPI_SS_DISABLE);
f900019c:	4d9c                	lw	a5,24(a1)
f900019e:	d55c                	sw	a5,44(a0)
    }
f90001a0:	8082                	ret

f90001a2 <spi_waitXferBusy>:
* @brief This function wait for SPI Transfer to complete.
    * 
    * @param reg SPI base address 
*
******************************************************************************/
    static void spi_waitXferBusy(u32 reg){
f90001a2:	1141                	addi	sp,sp,-16
f90001a4:	c606                	sw	ra,12(sp)
f90001a6:	c422                	sw	s0,8(sp)
f90001a8:	842a                	mv	s0,a0

#ifdef SYSTEM_SPI_2_IO_CTRL
    	if(reg == SYSTEM_SPI_2_IO_CTRL) cmdFifo_depth = SYSTEM_SPI_2_IO_PARAMETER_CMD_FIFO_DEPTH;
#endif

    	bsp_uDelay(1);
f90001aa:	f8b00637          	lui	a2,0xf8b00
f90001ae:	0bebc5b7          	lui	a1,0xbebc
f90001b2:	20058593          	addi	a1,a1,512 # bebc200 <__stack_size+0xbebc100>
f90001b6:	4505                	li	a0,1
f90001b8:	3df9                	jal	f9000096 <clint_uDelay>
    	while(spi_cmdAvailability(reg) != cmdFifo_depth);
f90001ba:	8522                	mv	a0,s0
f90001bc:	3705                	jal	f90000dc <spi_cmdAvailability>
f90001be:	10000793          	li	a5,256
f90001c2:	fef51ce3          	bne	a0,a5,f90001ba <spi_waitXferBusy+0x18>
    }
f90001c6:	40b2                	lw	ra,12(sp)
f90001c8:	4422                	lw	s0,8(sp)
f90001ca:	0141                	addi	sp,sp,16
f90001cc:	8082                	ret

f90001ce <spiFlash_select>:
    * @param spi SPI port base address 
    * @param cs 32-bit bitwise setting. Set 1 to enable particular bit. 
*
******************************************************************************/

    static void spiFlash_select(u32 spi, u32 cs){
f90001ce:	1141                	addi	sp,sp,-16
f90001d0:	c606                	sw	ra,12(sp)
        spi_select(spi, cs);
f90001d2:	378d                	jal	f9000134 <spi_select>
    }
f90001d4:	40b2                	lw	ra,12(sp)
f90001d6:	0141                	addi	sp,sp,16
f90001d8:	8082                	ret

f90001da <spiFlash_diselect>:
    * 
    * @param spi SPI port base address 
    * @param cs 32-bit bitwise setting. Set 1 to disable particular bit. 
*
******************************************************************************/
    static void spiFlash_diselect(u32 spi, u32 cs){
f90001da:	1141                	addi	sp,sp,-16
f90001dc:	c606                	sw	ra,12(sp)
        spi_diselect(spi, cs);
f90001de:	3fb5                	jal	f900015a <spi_diselect>
    }
f90001e0:	40b2                	lw	ra,12(sp)
f90001e2:	0141                	addi	sp,sp,16
f90001e4:	8082                	ret

f90001e6 <spiFlash_init_>:
* @brief This function initialize SPI port with default settings
    * 
    * @param spi SPI port base address
*
******************************************************************************/
    static void spiFlash_init_(u32 spi){
f90001e6:	7179                	addi	sp,sp,-48
f90001e8:	d606                	sw	ra,44(sp)
f90001ea:	d422                	sw	s0,40(sp)
f90001ec:	842a                	mv	s0,a0
        Spi_Config spiCfg;
        spiCfg.cpol = 0;
f90001ee:	c202                	sw	zero,4(sp)
        spiCfg.cpha = 0;
f90001f0:	c402                	sw	zero,8(sp)
        spiCfg.mode = 0;
f90001f2:	c602                	sw	zero,12(sp)
        spiCfg.clkDivider = 2;
f90001f4:	4789                	li	a5,2
f90001f6:	c83e                	sw	a5,16(sp)
        spiCfg.ssSetup = 5;
f90001f8:	4715                	li	a4,5
f90001fa:	ca3a                	sw	a4,20(sp)
        spiCfg.ssHold = 2;
f90001fc:	cc3e                	sw	a5,24(sp)
        spiCfg.ssDisable = 7;
f90001fe:	479d                	li	a5,7
f9000200:	ce3e                	sw	a5,28(sp)
        spi_applyConfig(spi, &spiCfg);
f9000202:	004c                	addi	a1,sp,4
f9000204:	3fb5                	jal	f9000180 <spi_applyConfig>
        spi_waitXferBusy(spi); 
f9000206:	8522                	mv	a0,s0
f9000208:	3f69                	jal	f90001a2 <spi_waitXferBusy>
    }
f900020a:	50b2                	lw	ra,44(sp)
f900020c:	5422                	lw	s0,40(sp)
f900020e:	6145                	addi	sp,sp,48
f9000210:	8082                	ret

f9000212 <spiFlash_init>:
    * @param spi SPI port base address
    * @param gpio GPIO port base address 
    * @param cs 32-bit bitwise chip select setting.
*
******************************************************************************/
    static void spiFlash_init(u32 spi, u32 cs){
f9000212:	1141                	addi	sp,sp,-16
f9000214:	c606                	sw	ra,12(sp)
f9000216:	c422                	sw	s0,8(sp)
f9000218:	c226                	sw	s1,4(sp)
f900021a:	842a                	mv	s0,a0
f900021c:	84ae                	mv	s1,a1
        spiFlash_init_(spi);
f900021e:	37e1                	jal	f90001e6 <spiFlash_init_>
        spiFlash_diselect(spi, cs);
f9000220:	85a6                	mv	a1,s1
f9000222:	8522                	mv	a0,s0
f9000224:	3f5d                	jal	f90001da <spiFlash_diselect>
    }
f9000226:	40b2                	lw	ra,12(sp)
f9000228:	4422                	lw	s0,8(sp)
f900022a:	4492                	lw	s1,4(sp)
f900022c:	0141                	addi	sp,sp,16
f900022e:	8082                	ret

f9000230 <spiFlash_wake_>:
*        start communicating with the device.
    * 
    * @param spi SPI port base address
*
******************************************************************************/
    static void spiFlash_wake_(u32 spi){
f9000230:	1141                	addi	sp,sp,-16
f9000232:	c606                	sw	ra,12(sp)
        spi_write(spi, 0xAB);        
f9000234:	0ab00593          	li	a1,171
f9000238:	3d4d                	jal	f90000ea <spi_write>
    }
f900023a:	40b2                	lw	ra,12(sp)
f900023c:	0141                	addi	sp,sp,16
f900023e:	8082                	ret

f9000240 <spiFlash_exit4ByteAddr_>:
    * @param spi SPI port base address
    * @param cs 32-bit bitwise chip select setting
    * @param mid 8-bit SPI Flash Manufacturer ID.
*
******************************************************************************/
    static void spiFlash_exit4ByteAddr_(u32 spi, u32 cs, u8 mid){
f9000240:	1141                	addi	sp,sp,-16
f9000242:	c606                	sw	ra,12(sp)
        switch(mid){
f9000244:	09d00793          	li	a5,157
f9000248:	00f60863          	beq	a2,a5,f9000258 <spiFlash_exit4ByteAddr_+0x18>
            case 0x9D: 
                spi_write(spi, 0x29);
                break; 
            default: 
                spi_write(spi, 0xE9);
f900024c:	0e900593          	li	a1,233
f9000250:	3d69                	jal	f90000ea <spi_write>
                break; 
        }
    }
f9000252:	40b2                	lw	ra,12(sp)
f9000254:	0141                	addi	sp,sp,16
f9000256:	8082                	ret
                spi_write(spi, 0x29);
f9000258:	02900593          	li	a1,41
f900025c:	3579                	jal	f90000ea <spi_write>
                break; 
f900025e:	bfd5                	j	f9000252 <spiFlash_exit4ByteAddr_+0x12>

f9000260 <spiFlash_exit4ByteAddr>:
*
* @param spi SPI port base address
* @param cs 32-bit bitwise chip select setting
*
******************************************************************************/
    static void spiFlash_exit4ByteAddr(u32 spi, u32 cs){
f9000260:	1141                	addi	sp,sp,-16
f9000262:	c606                	sw	ra,12(sp)
f9000264:	c422                	sw	s0,8(sp)
f9000266:	c226                	sw	s1,4(sp)
f9000268:	c04a                	sw	s2,0(sp)
f900026a:	842a                	mv	s0,a0
f900026c:	84ae                	mv	s1,a1
        spiFlash_select(spi,cs);
f900026e:	3785                	jal	f90001ce <spiFlash_select>
        spi_write(spi, READ_MANUFACTURER);
f9000270:	09f00593          	li	a1,159
f9000274:	8522                	mv	a0,s0
f9000276:	3d95                	jal	f90000ea <spi_write>
        u8 mid = spi_read(spi);
f9000278:	8522                	mv	a0,s0
f900027a:	3d49                	jal	f900010c <spi_read>
f900027c:	892a                	mv	s2,a0
        bsp_uDelay(300);
f900027e:	f8b00637          	lui	a2,0xf8b00
f9000282:	0bebc5b7          	lui	a1,0xbebc
f9000286:	20058593          	addi	a1,a1,512 # bebc200 <__stack_size+0xbebc100>
f900028a:	12c00513          	li	a0,300
f900028e:	3521                	jal	f9000096 <clint_uDelay>
        u8 mid = spiFlash_manufacturer_id_(spi, cs); 
        spiFlash_diselect(spi,cs);
f9000290:	85a6                	mv	a1,s1
f9000292:	8522                	mv	a0,s0
f9000294:	3799                	jal	f90001da <spiFlash_diselect>
        spi_waitXferBusy(spi);
f9000296:	8522                	mv	a0,s0
f9000298:	3729                	jal	f90001a2 <spi_waitXferBusy>
        spiFlash_select(spi,cs);
f900029a:	85a6                	mv	a1,s1
f900029c:	8522                	mv	a0,s0
f900029e:	3f05                	jal	f90001ce <spiFlash_select>
        spiFlash_exit4ByteAddr_(spi, cs, mid); 
f90002a0:	864a                	mv	a2,s2
f90002a2:	85a6                	mv	a1,s1
f90002a4:	8522                	mv	a0,s0
f90002a6:	3f69                	jal	f9000240 <spiFlash_exit4ByteAddr_>
        spiFlash_diselect(spi,cs);
f90002a8:	85a6                	mv	a1,s1
f90002aa:	8522                	mv	a0,s0
f90002ac:	373d                	jal	f90001da <spiFlash_diselect>
        spi_waitXferBusy(spi);
f90002ae:	8522                	mv	a0,s0
f90002b0:	3dcd                	jal	f90001a2 <spi_waitXferBusy>
    }
f90002b2:	40b2                	lw	ra,12(sp)
f90002b4:	4422                	lw	s0,8(sp)
f90002b6:	4492                	lw	s1,4(sp)
f90002b8:	4902                	lw	s2,0(sp)
f90002ba:	0141                	addi	sp,sp,16
f90002bc:	8082                	ret

f90002be <spiFlash_wake>:
*
* @param spi SPI port base address
* @param cs 32-bit bitwise chip select setting.
*
******************************************************************************/
    static void spiFlash_wake(u32 spi, u32 cs){
f90002be:	1141                	addi	sp,sp,-16
f90002c0:	c606                	sw	ra,12(sp)
f90002c2:	c422                	sw	s0,8(sp)
f90002c4:	c226                	sw	s1,4(sp)
f90002c6:	842a                	mv	s0,a0
f90002c8:	84ae                	mv	s1,a1
        spiFlash_select(spi,cs);
f90002ca:	3711                	jal	f90001ce <spiFlash_select>
        spiFlash_wake_(spi);
f90002cc:	8522                	mv	a0,s0
f90002ce:	378d                	jal	f9000230 <spiFlash_wake_>
        spiFlash_diselect(spi,cs);
f90002d0:	85a6                	mv	a1,s1
f90002d2:	8522                	mv	a0,s0
f90002d4:	3719                	jal	f90001da <spiFlash_diselect>
        spi_waitXferBusy(spi);
f90002d6:	8522                	mv	a0,s0
f90002d8:	35e9                	jal	f90001a2 <spi_waitXferBusy>
        bsp_uDelay(100); // make sure the Flash fully awake
f90002da:	f8b00637          	lui	a2,0xf8b00
f90002de:	0bebc5b7          	lui	a1,0xbebc
f90002e2:	20058593          	addi	a1,a1,512 # bebc200 <__stack_size+0xbebc100>
f90002e6:	06400513          	li	a0,100
f90002ea:	3375                	jal	f9000096 <clint_uDelay>
    }
f90002ec:	40b2                	lw	ra,12(sp)
f90002ee:	4422                	lw	s0,8(sp)
f90002f0:	4492                	lw	s1,4(sp)
f90002f2:	0141                	addi	sp,sp,16
f90002f4:	8082                	ret

f90002f6 <spiFlash_f2m_>:
    * @param flashAddress The flash address to read the data
    * @param memoryAddress The RAM address to write the data
    * @param size The size of data to copy
*
******************************************************************************/
    static void spiFlash_f2m_(u32 spi, u32 flashAddress, u32 memoryAddress, u32 size){
f90002f6:	1101                	addi	sp,sp,-32
f90002f8:	ce06                	sw	ra,28(sp)
f90002fa:	cc22                	sw	s0,24(sp)
f90002fc:	ca26                	sw	s1,20(sp)
f90002fe:	c84a                	sw	s2,16(sp)
f9000300:	c64e                	sw	s3,12(sp)
f9000302:	892a                	mv	s2,a0
f9000304:	84ae                	mv	s1,a1
f9000306:	8432                	mv	s0,a2
f9000308:	89b6                	mv	s3,a3
        spi_write(spi, 0x0B);
f900030a:	45ad                	li	a1,11
f900030c:	3bf9                	jal	f90000ea <spi_write>
        spi_write(spi, flashAddress >> 16);
f900030e:	0104d593          	srli	a1,s1,0x10
f9000312:	0ff5f593          	andi	a1,a1,255
f9000316:	854a                	mv	a0,s2
f9000318:	3bc9                	jal	f90000ea <spi_write>
        spi_write(spi, flashAddress >>  8);
f900031a:	0084d593          	srli	a1,s1,0x8
f900031e:	0ff5f593          	andi	a1,a1,255
f9000322:	854a                	mv	a0,s2
f9000324:	33d9                	jal	f90000ea <spi_write>
        spi_write(spi, flashAddress >>  0);
f9000326:	0ff4f593          	andi	a1,s1,255
f900032a:	854a                	mv	a0,s2
f900032c:	3b7d                	jal	f90000ea <spi_write>
        spi_write(spi, 0);
f900032e:	4581                	li	a1,0
f9000330:	854a                	mv	a0,s2
f9000332:	3b65                	jal	f90000ea <spi_write>
        uint8_t *ram = (uint8_t *) memoryAddress;
        for(u32 idx = 0;idx < size;idx++){
f9000334:	4481                	li	s1,0
f9000336:	0134f963          	bgeu	s1,s3,f9000348 <spiFlash_f2m_+0x52>
            u8 value = spi_read(spi);
f900033a:	854a                	mv	a0,s2
f900033c:	3bc1                	jal	f900010c <spi_read>
            *ram++ = value;
f900033e:	00a40023          	sb	a0,0(s0)
        for(u32 idx = 0;idx < size;idx++){
f9000342:	0485                	addi	s1,s1,1
            *ram++ = value;
f9000344:	0405                	addi	s0,s0,1
f9000346:	bfc5                	j	f9000336 <spiFlash_f2m_+0x40>
        }
    }
f9000348:	40f2                	lw	ra,28(sp)
f900034a:	4462                	lw	s0,24(sp)
f900034c:	44d2                	lw	s1,20(sp)
f900034e:	4942                	lw	s2,16(sp)
f9000350:	49b2                	lw	s3,12(sp)
f9000352:	6105                	addi	sp,sp,32
f9000354:	8082                	ret

f9000356 <spiFlash_f2m>:
* @param flashAddress The flash address to read the data
* @param memoryAddress The RAM address to write the data
* @param size The size of data to copy
*
******************************************************************************/
    static void spiFlash_f2m(u32 spi, u32 cs, u32 flashAddress, u32 memoryAddress, u32 size){
f9000356:	1101                	addi	sp,sp,-32
f9000358:	ce06                	sw	ra,28(sp)
f900035a:	cc22                	sw	s0,24(sp)
f900035c:	ca26                	sw	s1,20(sp)
f900035e:	c84a                	sw	s2,16(sp)
f9000360:	c64e                	sw	s3,12(sp)
f9000362:	c452                	sw	s4,8(sp)
f9000364:	842a                	mv	s0,a0
f9000366:	84ae                	mv	s1,a1
f9000368:	8932                	mv	s2,a2
f900036a:	89b6                	mv	s3,a3
f900036c:	8a3a                	mv	s4,a4
        spiFlash_select(spi,cs);
f900036e:	3585                	jal	f90001ce <spiFlash_select>
        spiFlash_f2m_(spi, flashAddress, memoryAddress, size);
f9000370:	86d2                	mv	a3,s4
f9000372:	864e                	mv	a2,s3
f9000374:	85ca                	mv	a1,s2
f9000376:	8522                	mv	a0,s0
f9000378:	3fbd                	jal	f90002f6 <spiFlash_f2m_>
        spiFlash_diselect(spi,cs);
f900037a:	85a6                	mv	a1,s1
f900037c:	8522                	mv	a0,s0
f900037e:	3db1                	jal	f90001da <spiFlash_diselect>
    }
f9000380:	40f2                	lw	ra,28(sp)
f9000382:	4462                	lw	s0,24(sp)
f9000384:	44d2                	lw	s1,20(sp)
f9000386:	4942                	lw	s2,16(sp)
f9000388:	49b2                	lw	s3,12(sp)
f900038a:	4a22                	lw	s4,8(sp)
f900038c:	6105                	addi	sp,sp,32
f900038e:	8082                	ret

f9000390 <bspMain>:
#define USER_SOFTWARE_FLASH    0x600000
#define USER_SOFTWARE_SIZE	   0x3F0000

#define SINGLE_SPI 1 //define DUAL_SPI for dual data SPI or QUAD_SPI for quad data SPI

void bspMain() {
f9000390:	1141                	addi	sp,sp,-16
f9000392:	c606                	sw	ra,12(sp)
#ifndef SIM
	spiFlash_init(SPI, SPI_CS);
f9000394:	4581                	li	a1,0
f9000396:	e8030537          	lui	a0,0xe8030
f900039a:	3da5                	jal	f9000212 <spiFlash_init>
	spiFlash_wake(SPI, SPI_CS);
f900039c:	4581                	li	a1,0
f900039e:	e8030537          	lui	a0,0xe8030
f90003a2:	3f31                	jal	f90002be <spiFlash_wake>
	spiFlash_exit4ByteAddr(SPI, SPI_CS);
f90003a4:	4581                	li	a1,0
f90003a6:	e8030537          	lui	a0,0xe8030
f90003aa:	3d5d                	jal	f9000260 <spiFlash_exit4ByteAddr>
#ifdef SINGLE_SPI
	spiFlash_f2m(SPI, SPI_CS, USER_SOFTWARE_FLASH, USER_SOFTWARE_MEMORY, USER_SOFTWARE_SIZE);
f90003ac:	003f0737          	lui	a4,0x3f0
f90003b0:	6685                	lui	a3,0x1
f90003b2:	00600637          	lui	a2,0x600
f90003b6:	4581                	li	a1,0
f90003b8:	e8030537          	lui	a0,0xe8030
f90003bc:	3f69                	jal	f9000356 <spiFlash_f2m>
#endif
#endif

	void (*userMain)() = (void (*)())USER_SOFTWARE_MEMORY;
    #ifdef SMP
        smp_unlock(userMain);
f90003be:	6505                	lui	a0,0x1
f90003c0:	31b5                	jal	f900002c <smp_unlock>
    #endif
	userMain();
f90003c2:	6785                	lui	a5,0x1
f90003c4:	9782                	jalr	a5
}
f90003c6:	40b2                	lw	ra,12(sp)
f90003c8:	0141                	addi	sp,sp,16
f90003ca:	8082                	ret

f90003cc <main>:
******************************************************************************/
#include "type.h"
#include "bsp.h"
#include "bootloaderConfig.h"

void main() {
f90003cc:	1141                	addi	sp,sp,-16
f90003ce:	c606                	sw	ra,12(sp)
    bsp_init();
f90003d0:	31f5                	jal	f90000bc <bsp_init>
    bspMain();
f90003d2:	3f7d                	jal	f9000390 <bspMain>
}
f90003d4:	40b2                	lw	ra,12(sp)
f90003d6:	0141                	addi	sp,sp,16
f90003d8:	8082                	ret

f90003da <__libc_init_array>:
f90003da:	1141                	addi	sp,sp,-16
f90003dc:	c422                	sw	s0,8(sp)
f90003de:	c04a                	sw	s2,0(sp)
f90003e0:	80c18413          	addi	s0,gp,-2036 # f9000434 <_data>
f90003e4:	80c18913          	addi	s2,gp,-2036 # f9000434 <_data>
f90003e8:	40890933          	sub	s2,s2,s0
f90003ec:	c606                	sw	ra,12(sp)
f90003ee:	c226                	sw	s1,4(sp)
f90003f0:	40295913          	srai	s2,s2,0x2
f90003f4:	00090963          	beqz	s2,f9000406 <__libc_init_array+0x2c>
f90003f8:	4481                	li	s1,0
f90003fa:	401c                	lw	a5,0(s0)
f90003fc:	0485                	addi	s1,s1,1
f90003fe:	0411                	addi	s0,s0,4
f9000400:	9782                	jalr	a5
f9000402:	fe991ce3          	bne	s2,s1,f90003fa <__libc_init_array+0x20>
f9000406:	80c18413          	addi	s0,gp,-2036 # f9000434 <_data>
f900040a:	80c18913          	addi	s2,gp,-2036 # f9000434 <_data>
f900040e:	40890933          	sub	s2,s2,s0
f9000412:	40295913          	srai	s2,s2,0x2
f9000416:	00090963          	beqz	s2,f9000428 <__libc_init_array+0x4e>
f900041a:	4481                	li	s1,0
f900041c:	401c                	lw	a5,0(s0)
f900041e:	0485                	addi	s1,s1,1
f9000420:	0411                	addi	s0,s0,4
f9000422:	9782                	jalr	a5
f9000424:	fe991ce3          	bne	s2,s1,f900041c <__libc_init_array+0x42>
f9000428:	40b2                	lw	ra,12(sp)
f900042a:	4422                	lw	s0,8(sp)
f900042c:	4492                	lw	s1,4(sp)
f900042e:	4902                	lw	s2,0(sp)
f9000430:	0141                	addi	sp,sp,16
f9000432:	8082                	ret
