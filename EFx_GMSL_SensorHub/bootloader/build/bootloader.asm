
build/bootloader.elf:     file format elf32-littleriscv


Disassembly of section .init:

f9000000 <_start>:

_start:
#ifdef USE_GP
.option push
.option norelax
	la gp, __global_pointer$
f9000000:	00001197          	auipc	gp,0x1
f9000004:	f1818193          	addi	gp,gp,-232 # f9000f18 <__global_pointer$>
.global smp_lottery_target
.global smp_lottery_lock
.global smp_slave


  sw x0, smp_lottery_lock, a1
f9000008:	8201a023          	sw	zero,-2016(gp) # f9000738 <smp_lottery_lock>

f900000c <smp_tyranny>:

smp_tyranny:
  csrr a0, mhartid
f900000c:	f1402573          	csrr	a0,mhartid
  beqz a0, init
f9000010:	02050e63          	beqz	a0,f900004c <init>

f9000014 <smp_slave>:

smp_slave:
	lw a0, smp_lottery_lock
f9000014:	8201a503          	lw	a0,-2016(gp) # f9000738 <smp_lottery_lock>
	beqz a0, smp_slave
f9000018:	fe050ee3          	beqz	a0,f9000014 <smp_slave>

	fence r, r
f900001c:	0220000f          	fence	r,r
f9000020:	0000100f          	fence.i
	//li a1, -1
	//amoadd.w x0, a1,(a0)

	.word(0x100F) //i$ flush
	lw a5, smp_lottery_target
f9000024:	81c1a783          	lw	a5,-2020(gp) # f9000734 <__bss_start>
	li a0, 0
f9000028:	00000513          	li	a0,0
	li a1, 0
f900002c:	00000593          	li	a1,0
	li a2, 0
f9000030:	00000613          	li	a2,0
	jr a5
f9000034:	00078067          	jr	a5

f9000038 <smp_unlock>:

.global   smp_unlock
.type    smp_unlock,%function
smp_unlock:
	sw a0, smp_lottery_target, a1
f9000038:	80a1ae23          	sw	a0,-2020(gp) # f9000734 <__bss_start>
	fence w, w
f900003c:	0110000f          	fence	w,w
	li a0, 1
f9000040:	00100513          	li	a0,1
	sw a0, smp_lottery_lock, a1
f9000044:	82a1a023          	sw	a0,-2016(gp) # f9000738 <smp_lottery_lock>
    ret
f9000048:	00008067          	ret

f900004c <init>:
#endif

init:
	la sp, _sp
f900004c:	92818113          	addi	sp,gp,-1752 # f9000840 <_sp>

	/* Load data section */
	la a0, _data_lma
f9000050:	80c18513          	addi	a0,gp,-2036 # f9000724 <_data>
	la a1, _data
f9000054:	80c18593          	addi	a1,gp,-2036 # f9000724 <_data>
	la a2, _edata
f9000058:	81c18613          	addi	a2,gp,-2020 # f9000734 <__bss_start>
	bgeu a1, a2, 2f
f900005c:	00c5fc63          	bgeu	a1,a2,f9000074 <init+0x28>
1:
	lw t0, (a0)
f9000060:	00052283          	lw	t0,0(a0)
	sw t0, (a1)
f9000064:	0055a023          	sw	t0,0(a1)
	addi a0, a0, 4
f9000068:	00450513          	addi	a0,a0,4
	addi a1, a1, 4
f900006c:	00458593          	addi	a1,a1,4
	bltu a1, a2, 1b
f9000070:	fec5e8e3          	bltu	a1,a2,f9000060 <init+0x14>
2:

	/* Clear bss section */
	la a0, __bss_start
f9000074:	81c18513          	addi	a0,gp,-2020 # f9000734 <__bss_start>
	la a1, _end
f9000078:	82818593          	addi	a1,gp,-2008 # f9000740 <_end>
	bgeu a0, a1, 2f
f900007c:	00b57863          	bgeu	a0,a1,f900008c <init+0x40>
1:
	sw zero, (a0)
f9000080:	00052023          	sw	zero,0(a0)
	addi a0, a0, 4
f9000084:	00450513          	addi	a0,a0,4
	bltu a0, a1, 1b
f9000088:	feb56ce3          	bltu	a0,a1,f9000080 <init+0x34>
2:

#ifndef NO_LIBC_INIT_ARRAY
	call __libc_init_array
f900008c:	614000ef          	jal	ra,f90006a0 <__libc_init_array>
#endif

	call main
f9000090:	5f4000ef          	jal	ra,f9000684 <main>

f9000094 <mainDone>:
mainDone:
    j mainDone
f9000094:	0000006f          	j	f9000094 <mainDone>

f9000098 <_init>:


	.globl _init
_init:
    ret
f9000098:	00008067          	ret

Disassembly of section .text:

f900009c <uart_applyConfig>:
*          value using data length, parity, and stop bit settings from the configuration
*          structure, and writes this value to the UART frame configuration register.
*
******************************************************************************/
    static void uart_applyConfig(u32 reg, Uart_Config *config){
        write_u32(config->clockDivider, reg + UART_CLOCK_DIVIDER);
f900009c:	00c5a783          	lw	a5,12(a1)
    static inline u32 read_u32(u32 address){
        return *((volatile u32*) address);
    }
    
    static inline void write_u32(u32 data, u32 address){
        *((volatile u32*) address) = data;
f90000a0:	00f52423          	sw	a5,8(a0)
        write_u32(((config->dataLength-1) << 0) | (config->parity << 8) | (config->stop << 16), reg + UART_FRAME_CONFIG);
f90000a4:	0005a783          	lw	a5,0(a1)
f90000a8:	fff78793          	addi	a5,a5,-1
f90000ac:	0045a703          	lw	a4,4(a1)
f90000b0:	00871713          	slli	a4,a4,0x8
f90000b4:	00e7e7b3          	or	a5,a5,a4
f90000b8:	0085a703          	lw	a4,8(a1)
f90000bc:	01071713          	slli	a4,a4,0x10
f90000c0:	00e7e7b3          	or	a5,a5,a4
f90000c4:	00f52623          	sw	a5,12(a0)
    }
f90000c8:	00008067          	ret

f90000cc <clint_uDelay>:
*          and the time limit is non-negative, indicating that the delay has
*          not yet elapsed.
*
******************************************************************************/
    static void clint_uDelay(u32 usec, u32 hz, u32 reg){
        u32 mTimePerUsec = hz/1000000;
f90000cc:	000f47b7          	lui	a5,0xf4
f90000d0:	24078793          	addi	a5,a5,576 # f4240 <__stack_size+0xf4140>
f90000d4:	02f5d5b3          	divu	a1,a1,a5
    readReg_u32 (clint_getTimeLow , CLINT_TIME_ADDR)
f90000d8:	0000c7b7          	lui	a5,0xc
f90000dc:	ff878793          	addi	a5,a5,-8 # bff8 <__stack_size+0xbef8>
f90000e0:	00f60633          	add	a2,a2,a5
        return *((volatile u32*) address);
f90000e4:	00062783          	lw	a5,0(a2)
        u32 limit = clint_getTimeLow(reg) + usec*mTimePerUsec;
f90000e8:	02a58533          	mul	a0,a1,a0
f90000ec:	00f50533          	add	a0,a0,a5
f90000f0:	00062783          	lw	a5,0(a2)
        while((int32_t)(limit-(clint_getTimeLow(reg))) >= 0);
f90000f4:	40f507b3          	sub	a5,a0,a5
f90000f8:	fe07dce3          	bgez	a5,f90000f0 <clint_uDelay+0x24>
f90000fc:	00008067          	ret

f9000100 <bsp_init>:
    *   1. UART baudrate
    *   2. 
    */
////////////////////////////////////////////////////////////////////////////////
    static void bsp_init()
    {
f9000100:	fe010113          	addi	sp,sp,-32
f9000104:	00112e23          	sw	ra,28(sp)
        Uart_Config uartConfig;
        uartConfig.dataLength   = BITS_8;
f9000108:	00800793          	li	a5,8
f900010c:	00f12023          	sw	a5,0(sp)
        uartConfig.parity       = NONE;
f9000110:	00012223          	sw	zero,4(sp)
        uartConfig.stop         = ONE;
f9000114:	00012423          	sw	zero,8(sp)
        uartConfig.clockDivider = BSP_CLINT_HZ/(BSP_UART_BAUDRATE*BSP_UART_DATA_LEN)-1;
f9000118:	06b00793          	li	a5,107
f900011c:	00f12623          	sw	a5,12(sp)
        uart_applyConfig(BSP_UART_TERMINAL, &uartConfig);    
f9000120:	00010593          	mv	a1,sp
f9000124:	f8010537          	lui	a0,0xf8010
f9000128:	f75ff0ef          	jal	ra,f900009c <uart_applyConfig>
    }
f900012c:	01c12083          	lw	ra,28(sp)
f9000130:	02010113          	addi	sp,sp,32
f9000134:	00008067          	ret

f9000138 <spi_cmdAvailability>:
f9000138:	00452503          	lw	a0,4(a0) # f8010004 <__global_pointer$+0xff00f0ec>
 * @return The availability of command buffer space (lower 16 bits of SPI buffer)
 *
 ******************************************************************************/
    static u32 spi_cmdAvailability(u32 reg){
        return read_u32(reg + SPI_BUFFER) & 0xFFFF;
    }
f900013c:	01051513          	slli	a0,a0,0x10
f9000140:	01055513          	srli	a0,a0,0x10
f9000144:	00008067          	ret

f9000148 <spi_rspOccupancy>:
f9000148:	00452503          	lw	a0,4(a0)
 * @return The occupancy of response buffer space (upper 16 bits of SPI buffer)
 *
 ******************************************************************************/
    static u32 spi_rspOccupancy(u32 reg){
        return read_u32(reg + SPI_BUFFER) >> 16;
    }
f900014c:	01055513          	srli	a0,a0,0x10
f9000150:	00008067          	ret

f9000154 <spi_write>:
 * @param reg The base address of the SPI register
 *
 * @param data The data to be written
 *
 ******************************************************************************/
    static void spi_write(u32 reg, u8 data){
f9000154:	ff010113          	addi	sp,sp,-16
f9000158:	00112623          	sw	ra,12(sp)
f900015c:	00812423          	sw	s0,8(sp)
f9000160:	00912223          	sw	s1,4(sp)
f9000164:	00050413          	mv	s0,a0
f9000168:	00058493          	mv	s1,a1
        while(spi_cmdAvailability(reg) == 0);
f900016c:	00040513          	mv	a0,s0
f9000170:	fc9ff0ef          	jal	ra,f9000138 <spi_cmdAvailability>
f9000174:	fe050ce3          	beqz	a0,f900016c <spi_write+0x18>
        write_u32(data | SPI_CMD_WRITE, reg + SPI_DATA);
f9000178:	1004e493          	ori	s1,s1,256
        *((volatile u32*) address) = data;
f900017c:	00942023          	sw	s1,0(s0)
    }
f9000180:	00c12083          	lw	ra,12(sp)
f9000184:	00812403          	lw	s0,8(sp)
f9000188:	00412483          	lw	s1,4(sp)
f900018c:	01010113          	addi	sp,sp,16
f9000190:	00008067          	ret

f9000194 <spi_read>:
 * @param reg The base address of the SPI register
 *
 * @return The data read from the SPI data register
 *
 ******************************************************************************/   
    static u8 spi_read(u32 reg){
f9000194:	ff010113          	addi	sp,sp,-16
f9000198:	00112623          	sw	ra,12(sp)
f900019c:	00812423          	sw	s0,8(sp)
f90001a0:	00050413          	mv	s0,a0
        while(spi_cmdAvailability(reg) == 0);
f90001a4:	00040513          	mv	a0,s0
f90001a8:	f91ff0ef          	jal	ra,f9000138 <spi_cmdAvailability>
f90001ac:	fe050ce3          	beqz	a0,f90001a4 <spi_read+0x10>
f90001b0:	20000793          	li	a5,512
f90001b4:	00f42023          	sw	a5,0(s0)
        write_u32(SPI_CMD_READ, reg + SPI_DATA);
        while(spi_rspOccupancy(reg) == 0);
f90001b8:	00040513          	mv	a0,s0
f90001bc:	f8dff0ef          	jal	ra,f9000148 <spi_rspOccupancy>
f90001c0:	fe050ce3          	beqz	a0,f90001b8 <spi_read+0x24>
        return *((volatile u32*) address);
f90001c4:	00042503          	lw	a0,0(s0)
        return read_u32(reg + SPI_DATA);
    }
f90001c8:	0ff57513          	andi	a0,a0,255
f90001cc:	00c12083          	lw	ra,12(sp)
f90001d0:	00812403          	lw	s0,8(sp)
f90001d4:	01010113          	addi	sp,sp,16
f90001d8:	00008067          	ret

f90001dc <spi_select>:
 *
 * @param reg The base address of the SPI register
 * @param slaveId The ID of the slave device to select
 *
 ******************************************************************************/
    static void spi_select(u32 reg, u32 slaveId){
f90001dc:	ff010113          	addi	sp,sp,-16
f90001e0:	00112623          	sw	ra,12(sp)
f90001e4:	00812423          	sw	s0,8(sp)
f90001e8:	00912223          	sw	s1,4(sp)
f90001ec:	00050413          	mv	s0,a0
f90001f0:	00058493          	mv	s1,a1
        while(spi_cmdAvailability(reg) == 0);
f90001f4:	00040513          	mv	a0,s0
f90001f8:	f41ff0ef          	jal	ra,f9000138 <spi_cmdAvailability>
f90001fc:	fe050ce3          	beqz	a0,f90001f4 <spi_select+0x18>
        write_u32(slaveId | 0x80 | SPI_CMD_SS, reg + SPI_DATA);
f9000200:	000017b7          	lui	a5,0x1
f9000204:	88078793          	addi	a5,a5,-1920 # 880 <__stack_size+0x780>
f9000208:	00f4e4b3          	or	s1,s1,a5
        *((volatile u32*) address) = data;
f900020c:	00942023          	sw	s1,0(s0)
    }
f9000210:	00c12083          	lw	ra,12(sp)
f9000214:	00812403          	lw	s0,8(sp)
f9000218:	00412483          	lw	s1,4(sp)
f900021c:	01010113          	addi	sp,sp,16
f9000220:	00008067          	ret

f9000224 <spi_diselect>:
 *
 * @param reg The base address of the SPI register
 * @param slaveId The ID of the slave device to deselect
 *
 ******************************************************************************/  
    static void spi_diselect(u32 reg, u32 slaveId){
f9000224:	ff010113          	addi	sp,sp,-16
f9000228:	00112623          	sw	ra,12(sp)
f900022c:	00812423          	sw	s0,8(sp)
f9000230:	00912223          	sw	s1,4(sp)
f9000234:	00050413          	mv	s0,a0
f9000238:	00058493          	mv	s1,a1
        while(spi_cmdAvailability(reg) == 0);
f900023c:	00040513          	mv	a0,s0
f9000240:	ef9ff0ef          	jal	ra,f9000138 <spi_cmdAvailability>
f9000244:	fe050ce3          	beqz	a0,f900023c <spi_diselect+0x18>
        write_u32(slaveId | 0x00 | SPI_CMD_SS, reg + SPI_DATA);
f9000248:	000017b7          	lui	a5,0x1
f900024c:	80078793          	addi	a5,a5,-2048 # 800 <__stack_size+0x700>
f9000250:	00f4e4b3          	or	s1,s1,a5
f9000254:	00942023          	sw	s1,0(s0)
    }
f9000258:	00c12083          	lw	ra,12(sp)
f900025c:	00812403          	lw	s0,8(sp)
f9000260:	00412483          	lw	s1,4(sp)
f9000264:	01010113          	addi	sp,sp,16
f9000268:	00008067          	ret

f900026c <spi_applyConfig>:
 * @param reg The base address of the SPI register
 * @param config Pointer to a Spi_Config structure containing the configuration settings
 *
 ******************************************************************************/
    static void spi_applyConfig(u32 reg, Spi_Config *config){
        write_u32((config->cpol << 0) | (config->cpha << 1) | (config->mode << 4), reg + SPI_CONFIG);
f900026c:	0005a783          	lw	a5,0(a1)
f9000270:	0045a703          	lw	a4,4(a1)
f9000274:	00171713          	slli	a4,a4,0x1
f9000278:	00e7e7b3          	or	a5,a5,a4
f900027c:	0085a703          	lw	a4,8(a1)
f9000280:	00471713          	slli	a4,a4,0x4
f9000284:	00e7e7b3          	or	a5,a5,a4
f9000288:	00f52423          	sw	a5,8(a0)
        write_u32(config->clkDivider, reg + SPI_CLK_DIVIDER);
f900028c:	00c5a783          	lw	a5,12(a1)
f9000290:	02f52023          	sw	a5,32(a0)
        write_u32(config->ssSetup, reg + SPI_SS_SETUP);
f9000294:	0105a783          	lw	a5,16(a1)
f9000298:	02f52223          	sw	a5,36(a0)
        write_u32(config->ssHold, reg + SPI_SS_HOLD);
f900029c:	0145a783          	lw	a5,20(a1)
f90002a0:	02f52423          	sw	a5,40(a0)
        write_u32(config->ssDisable, reg + SPI_SS_DISABLE);
f90002a4:	0185a783          	lw	a5,24(a1)
f90002a8:	02f52623          	sw	a5,44(a0)
    }
f90002ac:	00008067          	ret

f90002b0 <spi_waitXferBusy>:
* @brief This function wait for SPI Transfer to complete.
    * 
    * @param reg SPI base address 
*
******************************************************************************/
    static void spi_waitXferBusy(u32 reg){
f90002b0:	ff010113          	addi	sp,sp,-16
f90002b4:	00112623          	sw	ra,12(sp)
f90002b8:	00812423          	sw	s0,8(sp)
f90002bc:	00050413          	mv	s0,a0

#ifdef SYSTEM_SPI_2_IO_CTRL
    	if(reg == SYSTEM_SPI_2_IO_CTRL) cmdFifo_depth = SYSTEM_SPI_2_IO_PARAMETER_CMD_FIFO_DEPTH;
#endif

    	bsp_uDelay(1);
f90002c0:	f8b00637          	lui	a2,0xf8b00
f90002c4:	05f5e5b7          	lui	a1,0x5f5e
f90002c8:	10058593          	addi	a1,a1,256 # 5f5e100 <__stack_size+0x5f5e000>
f90002cc:	00100513          	li	a0,1
f90002d0:	dfdff0ef          	jal	ra,f90000cc <clint_uDelay>
    	while(spi_cmdAvailability(reg) != cmdFifo_depth);
f90002d4:	00040513          	mv	a0,s0
f90002d8:	e61ff0ef          	jal	ra,f9000138 <spi_cmdAvailability>
f90002dc:	10000793          	li	a5,256
f90002e0:	fef51ae3          	bne	a0,a5,f90002d4 <spi_waitXferBusy+0x24>
    }
f90002e4:	00c12083          	lw	ra,12(sp)
f90002e8:	00812403          	lw	s0,8(sp)
f90002ec:	01010113          	addi	sp,sp,16
f90002f0:	00008067          	ret

f90002f4 <spiFlash_select>:
    * @param spi SPI port base address 
    * @param cs 32-bit bitwise setting. Set 1 to enable particular bit. 
*
******************************************************************************/

    static void spiFlash_select(u32 spi, u32 cs){
f90002f4:	ff010113          	addi	sp,sp,-16
f90002f8:	00112623          	sw	ra,12(sp)
        spi_select(spi, cs);
f90002fc:	ee1ff0ef          	jal	ra,f90001dc <spi_select>
    }
f9000300:	00c12083          	lw	ra,12(sp)
f9000304:	01010113          	addi	sp,sp,16
f9000308:	00008067          	ret

f900030c <spiFlash_diselect>:
    * 
    * @param spi SPI port base address 
    * @param cs 32-bit bitwise setting. Set 1 to disable particular bit. 
*
******************************************************************************/
    static void spiFlash_diselect(u32 spi, u32 cs){
f900030c:	ff010113          	addi	sp,sp,-16
f9000310:	00112623          	sw	ra,12(sp)
        spi_diselect(spi, cs);
f9000314:	f11ff0ef          	jal	ra,f9000224 <spi_diselect>
    }
f9000318:	00c12083          	lw	ra,12(sp)
f900031c:	01010113          	addi	sp,sp,16
f9000320:	00008067          	ret

f9000324 <spiFlash_init_>:
* @brief This function initialize SPI port with default settings
    * 
    * @param spi SPI port base address
*
******************************************************************************/
    static void spiFlash_init_(u32 spi){
f9000324:	fd010113          	addi	sp,sp,-48
f9000328:	02112623          	sw	ra,44(sp)
f900032c:	02812423          	sw	s0,40(sp)
f9000330:	00050413          	mv	s0,a0
        Spi_Config spiCfg;
        spiCfg.cpol = 0;
f9000334:	00012223          	sw	zero,4(sp)
        spiCfg.cpha = 0;
f9000338:	00012423          	sw	zero,8(sp)
        spiCfg.mode = 0;
f900033c:	00012623          	sw	zero,12(sp)
        spiCfg.clkDivider = 2;
f9000340:	00200793          	li	a5,2
f9000344:	00f12823          	sw	a5,16(sp)
        spiCfg.ssSetup = 5;
f9000348:	00500713          	li	a4,5
f900034c:	00e12a23          	sw	a4,20(sp)
        spiCfg.ssHold = 2;
f9000350:	00f12c23          	sw	a5,24(sp)
        spiCfg.ssDisable = 7;
f9000354:	00700793          	li	a5,7
f9000358:	00f12e23          	sw	a5,28(sp)
        spi_applyConfig(spi, &spiCfg);
f900035c:	00410593          	addi	a1,sp,4
f9000360:	f0dff0ef          	jal	ra,f900026c <spi_applyConfig>
        spi_waitXferBusy(spi); 
f9000364:	00040513          	mv	a0,s0
f9000368:	f49ff0ef          	jal	ra,f90002b0 <spi_waitXferBusy>
    }
f900036c:	02c12083          	lw	ra,44(sp)
f9000370:	02812403          	lw	s0,40(sp)
f9000374:	03010113          	addi	sp,sp,48
f9000378:	00008067          	ret

f900037c <spiFlash_init>:
    * @param spi SPI port base address
    * @param gpio GPIO port base address 
    * @param cs 32-bit bitwise chip select setting.
*
******************************************************************************/
    static void spiFlash_init(u32 spi, u32 cs){
f900037c:	ff010113          	addi	sp,sp,-16
f9000380:	00112623          	sw	ra,12(sp)
f9000384:	00812423          	sw	s0,8(sp)
f9000388:	00912223          	sw	s1,4(sp)
f900038c:	00050413          	mv	s0,a0
f9000390:	00058493          	mv	s1,a1
        spiFlash_init_(spi);
f9000394:	f91ff0ef          	jal	ra,f9000324 <spiFlash_init_>
        spiFlash_diselect(spi, cs);
f9000398:	00048593          	mv	a1,s1
f900039c:	00040513          	mv	a0,s0
f90003a0:	f6dff0ef          	jal	ra,f900030c <spiFlash_diselect>
    }
f90003a4:	00c12083          	lw	ra,12(sp)
f90003a8:	00812403          	lw	s0,8(sp)
f90003ac:	00412483          	lw	s1,4(sp)
f90003b0:	01010113          	addi	sp,sp,16
f90003b4:	00008067          	ret

f90003b8 <spiFlash_wake_>:
*        start communicating with the device.
    * 
    * @param spi SPI port base address
*
******************************************************************************/
    static void spiFlash_wake_(u32 spi){
f90003b8:	ff010113          	addi	sp,sp,-16
f90003bc:	00112623          	sw	ra,12(sp)
        spi_write(spi, 0xAB);        
f90003c0:	0ab00593          	li	a1,171
f90003c4:	d91ff0ef          	jal	ra,f9000154 <spi_write>
    }
f90003c8:	00c12083          	lw	ra,12(sp)
f90003cc:	01010113          	addi	sp,sp,16
f90003d0:	00008067          	ret

f90003d4 <spiFlash_exit4ByteAddr_>:
    * @param spi SPI port base address
    * @param cs 32-bit bitwise chip select setting
    * @param mid 8-bit SPI Flash Manufacturer ID.
*
******************************************************************************/
    static void spiFlash_exit4ByteAddr_(u32 spi, u32 cs, u8 mid){
f90003d4:	ff010113          	addi	sp,sp,-16
f90003d8:	00112623          	sw	ra,12(sp)
        switch(mid){
f90003dc:	09d00793          	li	a5,157
f90003e0:	00f60c63          	beq	a2,a5,f90003f8 <spiFlash_exit4ByteAddr_+0x24>
            case 0x9D: 
                spi_write(spi, 0x29);
                break; 
            default: 
                spi_write(spi, 0xE9);
f90003e4:	0e900593          	li	a1,233
f90003e8:	d6dff0ef          	jal	ra,f9000154 <spi_write>
                break; 
        }
    }
f90003ec:	00c12083          	lw	ra,12(sp)
f90003f0:	01010113          	addi	sp,sp,16
f90003f4:	00008067          	ret
                spi_write(spi, 0x29);
f90003f8:	02900593          	li	a1,41
f90003fc:	d59ff0ef          	jal	ra,f9000154 <spi_write>
                break; 
f9000400:	fedff06f          	j	f90003ec <spiFlash_exit4ByteAddr_+0x18>

f9000404 <spiFlash_exit4ByteAddr>:
*
* @param spi SPI port base address
* @param cs 32-bit bitwise chip select setting
*
******************************************************************************/
    static void spiFlash_exit4ByteAddr(u32 spi, u32 cs){
f9000404:	ff010113          	addi	sp,sp,-16
f9000408:	00112623          	sw	ra,12(sp)
f900040c:	00812423          	sw	s0,8(sp)
f9000410:	00912223          	sw	s1,4(sp)
f9000414:	01212023          	sw	s2,0(sp)
f9000418:	00050413          	mv	s0,a0
f900041c:	00058493          	mv	s1,a1
        spiFlash_select(spi,cs);
f9000420:	ed5ff0ef          	jal	ra,f90002f4 <spiFlash_select>
        spi_write(spi, READ_MANUFACTURER);
f9000424:	09f00593          	li	a1,159
f9000428:	00040513          	mv	a0,s0
f900042c:	d29ff0ef          	jal	ra,f9000154 <spi_write>
        u8 mid = spi_read(spi);
f9000430:	00040513          	mv	a0,s0
f9000434:	d61ff0ef          	jal	ra,f9000194 <spi_read>
f9000438:	00050913          	mv	s2,a0
        bsp_uDelay(300);
f900043c:	f8b00637          	lui	a2,0xf8b00
f9000440:	05f5e5b7          	lui	a1,0x5f5e
f9000444:	10058593          	addi	a1,a1,256 # 5f5e100 <__stack_size+0x5f5e000>
f9000448:	12c00513          	li	a0,300
f900044c:	c81ff0ef          	jal	ra,f90000cc <clint_uDelay>
        u8 mid = spiFlash_manufacturer_id_(spi, cs); 
        spiFlash_diselect(spi,cs);
f9000450:	00048593          	mv	a1,s1
f9000454:	00040513          	mv	a0,s0
f9000458:	eb5ff0ef          	jal	ra,f900030c <spiFlash_diselect>
        spi_waitXferBusy(spi);
f900045c:	00040513          	mv	a0,s0
f9000460:	e51ff0ef          	jal	ra,f90002b0 <spi_waitXferBusy>
        spiFlash_select(spi,cs);
f9000464:	00048593          	mv	a1,s1
f9000468:	00040513          	mv	a0,s0
f900046c:	e89ff0ef          	jal	ra,f90002f4 <spiFlash_select>
        spiFlash_exit4ByteAddr_(spi, cs, mid); 
f9000470:	00090613          	mv	a2,s2
f9000474:	00048593          	mv	a1,s1
f9000478:	00040513          	mv	a0,s0
f900047c:	f59ff0ef          	jal	ra,f90003d4 <spiFlash_exit4ByteAddr_>
        spiFlash_diselect(spi,cs);
f9000480:	00048593          	mv	a1,s1
f9000484:	00040513          	mv	a0,s0
f9000488:	e85ff0ef          	jal	ra,f900030c <spiFlash_diselect>
        spi_waitXferBusy(spi);
f900048c:	00040513          	mv	a0,s0
f9000490:	e21ff0ef          	jal	ra,f90002b0 <spi_waitXferBusy>
    }
f9000494:	00c12083          	lw	ra,12(sp)
f9000498:	00812403          	lw	s0,8(sp)
f900049c:	00412483          	lw	s1,4(sp)
f90004a0:	00012903          	lw	s2,0(sp)
f90004a4:	01010113          	addi	sp,sp,16
f90004a8:	00008067          	ret

f90004ac <spiFlash_wake>:
*
* @param spi SPI port base address
* @param cs 32-bit bitwise chip select setting.
*
******************************************************************************/
    static void spiFlash_wake(u32 spi, u32 cs){
f90004ac:	ff010113          	addi	sp,sp,-16
f90004b0:	00112623          	sw	ra,12(sp)
f90004b4:	00812423          	sw	s0,8(sp)
f90004b8:	00912223          	sw	s1,4(sp)
f90004bc:	00050413          	mv	s0,a0
f90004c0:	00058493          	mv	s1,a1
        spiFlash_select(spi,cs);
f90004c4:	e31ff0ef          	jal	ra,f90002f4 <spiFlash_select>
        spiFlash_wake_(spi);
f90004c8:	00040513          	mv	a0,s0
f90004cc:	eedff0ef          	jal	ra,f90003b8 <spiFlash_wake_>
        spiFlash_diselect(spi,cs);
f90004d0:	00048593          	mv	a1,s1
f90004d4:	00040513          	mv	a0,s0
f90004d8:	e35ff0ef          	jal	ra,f900030c <spiFlash_diselect>
        spi_waitXferBusy(spi);
f90004dc:	00040513          	mv	a0,s0
f90004e0:	dd1ff0ef          	jal	ra,f90002b0 <spi_waitXferBusy>
        bsp_uDelay(100); // make sure the Flash fully awake
f90004e4:	f8b00637          	lui	a2,0xf8b00
f90004e8:	05f5e5b7          	lui	a1,0x5f5e
f90004ec:	10058593          	addi	a1,a1,256 # 5f5e100 <__stack_size+0x5f5e000>
f90004f0:	06400513          	li	a0,100
f90004f4:	bd9ff0ef          	jal	ra,f90000cc <clint_uDelay>
    }
f90004f8:	00c12083          	lw	ra,12(sp)
f90004fc:	00812403          	lw	s0,8(sp)
f9000500:	00412483          	lw	s1,4(sp)
f9000504:	01010113          	addi	sp,sp,16
f9000508:	00008067          	ret

f900050c <spiFlash_f2m_>:
    * @param flashAddress The flash address to read the data
    * @param memoryAddress The RAM address to write the data
    * @param size The size of data to copy
*
******************************************************************************/
    static void spiFlash_f2m_(u32 spi, u32 flashAddress, u32 memoryAddress, u32 size){
f900050c:	fe010113          	addi	sp,sp,-32
f9000510:	00112e23          	sw	ra,28(sp)
f9000514:	00812c23          	sw	s0,24(sp)
f9000518:	00912a23          	sw	s1,20(sp)
f900051c:	01212823          	sw	s2,16(sp)
f9000520:	01312623          	sw	s3,12(sp)
f9000524:	00050913          	mv	s2,a0
f9000528:	00058493          	mv	s1,a1
f900052c:	00060413          	mv	s0,a2
f9000530:	00068993          	mv	s3,a3
        spi_write(spi, 0x0B);
f9000534:	00b00593          	li	a1,11
f9000538:	c1dff0ef          	jal	ra,f9000154 <spi_write>
        spi_write(spi, flashAddress >> 16);
f900053c:	0104d593          	srli	a1,s1,0x10
f9000540:	0ff5f593          	andi	a1,a1,255
f9000544:	00090513          	mv	a0,s2
f9000548:	c0dff0ef          	jal	ra,f9000154 <spi_write>
        spi_write(spi, flashAddress >>  8);
f900054c:	0084d593          	srli	a1,s1,0x8
f9000550:	0ff5f593          	andi	a1,a1,255
f9000554:	00090513          	mv	a0,s2
f9000558:	bfdff0ef          	jal	ra,f9000154 <spi_write>
        spi_write(spi, flashAddress >>  0);
f900055c:	0ff4f593          	andi	a1,s1,255
f9000560:	00090513          	mv	a0,s2
f9000564:	bf1ff0ef          	jal	ra,f9000154 <spi_write>
        spi_write(spi, 0);
f9000568:	00000593          	li	a1,0
f900056c:	00090513          	mv	a0,s2
f9000570:	be5ff0ef          	jal	ra,f9000154 <spi_write>
        uint8_t *ram = (uint8_t *) memoryAddress;
        for(u32 idx = 0;idx < size;idx++){
f9000574:	00000493          	li	s1,0
f9000578:	0134fe63          	bgeu	s1,s3,f9000594 <spiFlash_f2m_+0x88>
            u8 value = spi_read(spi);
f900057c:	00090513          	mv	a0,s2
f9000580:	c15ff0ef          	jal	ra,f9000194 <spi_read>
            *ram++ = value;
f9000584:	00a40023          	sb	a0,0(s0)
        for(u32 idx = 0;idx < size;idx++){
f9000588:	00148493          	addi	s1,s1,1
            *ram++ = value;
f900058c:	00140413          	addi	s0,s0,1
f9000590:	fe9ff06f          	j	f9000578 <spiFlash_f2m_+0x6c>
        }
    }
f9000594:	01c12083          	lw	ra,28(sp)
f9000598:	01812403          	lw	s0,24(sp)
f900059c:	01412483          	lw	s1,20(sp)
f90005a0:	01012903          	lw	s2,16(sp)
f90005a4:	00c12983          	lw	s3,12(sp)
f90005a8:	02010113          	addi	sp,sp,32
f90005ac:	00008067          	ret

f90005b0 <spiFlash_f2m>:
* @param flashAddress The flash address to read the data
* @param memoryAddress The RAM address to write the data
* @param size The size of data to copy
*
******************************************************************************/
    static void spiFlash_f2m(u32 spi, u32 cs, u32 flashAddress, u32 memoryAddress, u32 size){
f90005b0:	fe010113          	addi	sp,sp,-32
f90005b4:	00112e23          	sw	ra,28(sp)
f90005b8:	00812c23          	sw	s0,24(sp)
f90005bc:	00912a23          	sw	s1,20(sp)
f90005c0:	01212823          	sw	s2,16(sp)
f90005c4:	01312623          	sw	s3,12(sp)
f90005c8:	01412423          	sw	s4,8(sp)
f90005cc:	00050413          	mv	s0,a0
f90005d0:	00058493          	mv	s1,a1
f90005d4:	00060913          	mv	s2,a2
f90005d8:	00068993          	mv	s3,a3
f90005dc:	00070a13          	mv	s4,a4
        spiFlash_select(spi,cs);
f90005e0:	d15ff0ef          	jal	ra,f90002f4 <spiFlash_select>
        spiFlash_f2m_(spi, flashAddress, memoryAddress, size);
f90005e4:	000a0693          	mv	a3,s4
f90005e8:	00098613          	mv	a2,s3
f90005ec:	00090593          	mv	a1,s2
f90005f0:	00040513          	mv	a0,s0
f90005f4:	f19ff0ef          	jal	ra,f900050c <spiFlash_f2m_>
        spiFlash_diselect(spi,cs);
f90005f8:	00048593          	mv	a1,s1
f90005fc:	00040513          	mv	a0,s0
f9000600:	d0dff0ef          	jal	ra,f900030c <spiFlash_diselect>
    }
f9000604:	01c12083          	lw	ra,28(sp)
f9000608:	01812403          	lw	s0,24(sp)
f900060c:	01412483          	lw	s1,20(sp)
f9000610:	01012903          	lw	s2,16(sp)
f9000614:	00c12983          	lw	s3,12(sp)
f9000618:	00812a03          	lw	s4,8(sp)
f900061c:	02010113          	addi	sp,sp,32
f9000620:	00008067          	ret

f9000624 <bspMain>:
#define USER_SOFTWARE_FLASH  0x00380000
#define USER_SOFTWARE_SIZE	   0x07F000

#define SINGLE_SPI 1 //define DUAL_SPI for dual data SPI or QUAD_SPI for quad data SPI

void bspMain() {
f9000624:	ff010113          	addi	sp,sp,-16
f9000628:	00112623          	sw	ra,12(sp)
#ifndef SIM
	spiFlash_init(SPI, SPI_CS);
f900062c:	00000593          	li	a1,0
f9000630:	f8014537          	lui	a0,0xf8014
f9000634:	d49ff0ef          	jal	ra,f900037c <spiFlash_init>
	spiFlash_wake(SPI, SPI_CS);
f9000638:	00000593          	li	a1,0
f900063c:	f8014537          	lui	a0,0xf8014
f9000640:	e6dff0ef          	jal	ra,f90004ac <spiFlash_wake>
	spiFlash_exit4ByteAddr(SPI, SPI_CS);
f9000644:	00000593          	li	a1,0
f9000648:	f8014537          	lui	a0,0xf8014
f900064c:	db9ff0ef          	jal	ra,f9000404 <spiFlash_exit4ByteAddr>
#ifdef SINGLE_SPI
	spiFlash_f2m(SPI, SPI_CS, USER_SOFTWARE_FLASH, USER_SOFTWARE_MEMORY, USER_SOFTWARE_SIZE);
f9000650:	0007f737          	lui	a4,0x7f
f9000654:	000016b7          	lui	a3,0x1
f9000658:	00380637          	lui	a2,0x380
f900065c:	00000593          	li	a1,0
f9000660:	f8014537          	lui	a0,0xf8014
f9000664:	f4dff0ef          	jal	ra,f90005b0 <spiFlash_f2m>
#endif
#endif

	void (*userMain)() = (void (*)())USER_SOFTWARE_MEMORY;
    #ifdef SMP
        smp_unlock(userMain);
f9000668:	00001537          	lui	a0,0x1
f900066c:	9cdff0ef          	jal	ra,f9000038 <smp_unlock>
    #endif
	userMain();
f9000670:	000017b7          	lui	a5,0x1
f9000674:	000780e7          	jalr	a5 # 1000 <__stack_size+0xf00>
}
f9000678:	00c12083          	lw	ra,12(sp)
f900067c:	01010113          	addi	sp,sp,16
f9000680:	00008067          	ret

f9000684 <main>:
******************************************************************************/
#include "type.h"
#include "bsp.h"
#include "bootloaderConfig.h"

void main() {
f9000684:	ff010113          	addi	sp,sp,-16
f9000688:	00112623          	sw	ra,12(sp)
    bsp_init();
f900068c:	a75ff0ef          	jal	ra,f9000100 <bsp_init>
    bspMain();
f9000690:	f95ff0ef          	jal	ra,f9000624 <bspMain>
}
f9000694:	00c12083          	lw	ra,12(sp)
f9000698:	01010113          	addi	sp,sp,16
f900069c:	00008067          	ret

f90006a0 <__libc_init_array>:
f90006a0:	ff010113          	addi	sp,sp,-16
f90006a4:	00812423          	sw	s0,8(sp)
f90006a8:	01212023          	sw	s2,0(sp)
f90006ac:	80c18413          	addi	s0,gp,-2036 # f9000724 <_data>
f90006b0:	80c18913          	addi	s2,gp,-2036 # f9000724 <_data>
f90006b4:	40890933          	sub	s2,s2,s0
f90006b8:	00112623          	sw	ra,12(sp)
f90006bc:	00912223          	sw	s1,4(sp)
f90006c0:	40295913          	srai	s2,s2,0x2
f90006c4:	00090e63          	beqz	s2,f90006e0 <__libc_init_array+0x40>
f90006c8:	00000493          	li	s1,0
f90006cc:	00042783          	lw	a5,0(s0)
f90006d0:	00148493          	addi	s1,s1,1
f90006d4:	00440413          	addi	s0,s0,4
f90006d8:	000780e7          	jalr	a5
f90006dc:	fe9918e3          	bne	s2,s1,f90006cc <__libc_init_array+0x2c>
f90006e0:	80c18413          	addi	s0,gp,-2036 # f9000724 <_data>
f90006e4:	80c18913          	addi	s2,gp,-2036 # f9000724 <_data>
f90006e8:	40890933          	sub	s2,s2,s0
f90006ec:	40295913          	srai	s2,s2,0x2
f90006f0:	00090e63          	beqz	s2,f900070c <__libc_init_array+0x6c>
f90006f4:	00000493          	li	s1,0
f90006f8:	00042783          	lw	a5,0(s0)
f90006fc:	00148493          	addi	s1,s1,1
f9000700:	00440413          	addi	s0,s0,4
f9000704:	000780e7          	jalr	a5
f9000708:	fe9918e3          	bne	s2,s1,f90006f8 <__libc_init_array+0x58>
f900070c:	00c12083          	lw	ra,12(sp)
f9000710:	00812403          	lw	s0,8(sp)
f9000714:	00412483          	lw	s1,4(sp)
f9000718:	00012903          	lw	s2,0(sp)
f900071c:	01010113          	addi	sp,sp,16
f9000720:	00008067          	ret
