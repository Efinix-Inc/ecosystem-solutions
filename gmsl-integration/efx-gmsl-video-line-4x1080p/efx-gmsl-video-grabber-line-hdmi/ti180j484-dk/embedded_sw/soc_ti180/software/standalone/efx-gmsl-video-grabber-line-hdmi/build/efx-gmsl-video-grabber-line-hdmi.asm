
build/efx-gmsl-video-grabber-line-hdmi.elf:     file format elf32-littleriscv


Disassembly of section .init:

00001000 <_start>:

_start:
#ifdef USE_GP
.option push
.option norelax
	la gp, __global_pointer$
    1000:	00052197          	auipc	gp,0x52
    1004:	85018193          	addi	gp,gp,-1968 # 52850 <__global_pointer$>

00001008 <init>:
	sw a0, smp_lottery_lock, a1
    ret
#endif

init:
	la sp, _sp
    1008:	00053117          	auipc	sp,0x53
    100c:	a6810113          	addi	sp,sp,-1432 # 53a70 <__freertos_irq_stack_top>

	/* Load data section */
	la a0, _data_lma
    1010:	00008517          	auipc	a0,0x8
    1014:	a0450513          	addi	a0,a0,-1532 # 8a14 <_data>
	la a1, _data
    1018:	00008597          	auipc	a1,0x8
    101c:	9fc58593          	addi	a1,a1,-1540 # 8a14 <_data>
	la a2, _edata
    1020:	84c18613          	addi	a2,gp,-1972 # 5209c <__bss_start>
	bgeu a1, a2, 2f
    1024:	00c5fc63          	bgeu	a1,a2,103c <init+0x34>
1:
	lw t0, (a0)
    1028:	00052283          	lw	t0,0(a0)
	sw t0, (a1)
    102c:	0055a023          	sw	t0,0(a1)
	addi a0, a0, 4
    1030:	00450513          	addi	a0,a0,4
	addi a1, a1, 4
    1034:	00458593          	addi	a1,a1,4
	bltu a1, a2, 1b
    1038:	fec5e8e3          	bltu	a1,a2,1028 <init+0x20>
2:

	/* Clear bss section */
	la a0, __bss_start
    103c:	84c18513          	addi	a0,gp,-1972 # 5209c <__bss_start>
	la a1, _end
    1040:	22018593          	addi	a1,gp,544 # 52a70 <_end>
	bgeu a0, a1, 2f
    1044:	00b57863          	bgeu	a0,a1,1054 <init+0x4c>
1:
	sw zero, (a0)
    1048:	00052023          	sw	zero,0(a0)
	addi a0, a0, 4
    104c:	00450513          	addi	a0,a0,4
	bltu a0, a1, 1b
    1050:	feb56ce3          	bltu	a0,a1,1048 <init+0x40>
2:

#ifndef NO_LIBC_INIT_ARRAY
	call __libc_init_array
    1054:	010000ef          	jal	ra,1064 <__libc_init_array>
#endif

	call main
    1058:	5f9030ef          	jal	ra,4e50 <main>

0000105c <mainDone>:
mainDone:
    j mainDone
    105c:	0000006f          	j	105c <mainDone>

00001060 <_init>:


	.globl _init
_init:
    ret
    1060:	00008067          	ret

Disassembly of section .text:

00001064 <__libc_init_array>:
    1064:	ff010113          	addi	sp,sp,-16
    1068:	00812423          	sw	s0,8(sp)
    106c:	01212023          	sw	s2,0(sp)
    1070:	00008417          	auipc	s0,0x8
    1074:	9a440413          	addi	s0,s0,-1628 # 8a14 <_data>
    1078:	00008917          	auipc	s2,0x8
    107c:	99c90913          	addi	s2,s2,-1636 # 8a14 <_data>
    1080:	40890933          	sub	s2,s2,s0
    1084:	00112623          	sw	ra,12(sp)
    1088:	00912223          	sw	s1,4(sp)
    108c:	40295913          	srai	s2,s2,0x2
    1090:	00090e63          	beqz	s2,10ac <__libc_init_array+0x48>
    1094:	00000493          	li	s1,0
    1098:	00042783          	lw	a5,0(s0)
    109c:	00148493          	addi	s1,s1,1
    10a0:	00440413          	addi	s0,s0,4
    10a4:	000780e7          	jalr	a5
    10a8:	fe9918e3          	bne	s2,s1,1098 <__libc_init_array+0x34>
    10ac:	00008417          	auipc	s0,0x8
    10b0:	96840413          	addi	s0,s0,-1688 # 8a14 <_data>
    10b4:	00008917          	auipc	s2,0x8
    10b8:	96090913          	addi	s2,s2,-1696 # 8a14 <_data>
    10bc:	40890933          	sub	s2,s2,s0
    10c0:	40295913          	srai	s2,s2,0x2
    10c4:	00090e63          	beqz	s2,10e0 <__libc_init_array+0x7c>
    10c8:	00000493          	li	s1,0
    10cc:	00042783          	lw	a5,0(s0)
    10d0:	00148493          	addi	s1,s1,1
    10d4:	00440413          	addi	s0,s0,4
    10d8:	000780e7          	jalr	a5
    10dc:	fe9918e3          	bne	s2,s1,10cc <__libc_init_array+0x68>
    10e0:	00c12083          	lw	ra,12(sp)
    10e4:	00812403          	lw	s0,8(sp)
    10e8:	00412483          	lw	s1,4(sp)
    10ec:	00012903          	lw	s2,0(sp)
    10f0:	01010113          	addi	sp,sp,16
    10f4:	00008067          	ret

000010f8 <malloc>:
    10f8:	83418793          	addi	a5,gp,-1996 # 52084 <_impure_ptr>
    10fc:	00050593          	mv	a1,a0
    1100:	0007a503          	lw	a0,0(a5)
    1104:	0140006f          	j	1118 <_malloc_r>

00001108 <free>:
    1108:	83418793          	addi	a5,gp,-1996 # 52084 <_impure_ptr>
    110c:	00050593          	mv	a1,a0
    1110:	0007a503          	lw	a0,0(a5)
    1114:	3650006f          	j	1c78 <_free_r>

00001118 <_malloc_r>:
    1118:	fd010113          	addi	sp,sp,-48
    111c:	02912223          	sw	s1,36(sp)
    1120:	03212023          	sw	s2,32(sp)
    1124:	02112623          	sw	ra,44(sp)
    1128:	02812423          	sw	s0,40(sp)
    112c:	01312e23          	sw	s3,28(sp)
    1130:	01412c23          	sw	s4,24(sp)
    1134:	01512a23          	sw	s5,20(sp)
    1138:	01612823          	sw	s6,16(sp)
    113c:	01712623          	sw	s7,12(sp)
    1140:	01812423          	sw	s8,8(sp)
    1144:	01912223          	sw	s9,4(sp)
    1148:	00b58493          	addi	s1,a1,11
    114c:	01600793          	li	a5,22
    1150:	00050913          	mv	s2,a0
    1154:	0697e663          	bltu	a5,s1,11c0 <_malloc_r+0xa8>
    1158:	01000793          	li	a5,16
    115c:	22b7ec63          	bltu	a5,a1,1394 <_malloc_r+0x27c>
    1160:	125000ef          	jal	ra,1a84 <__malloc_lock>
    1164:	01000493          	li	s1,16
    1168:	01800793          	li	a5,24
    116c:	00200613          	li	a2,2
    1170:	00050997          	auipc	s3,0x50
    1174:	6bc98993          	addi	s3,s3,1724 # 5182c <__malloc_av_>
    1178:	00f987b3          	add	a5,s3,a5
    117c:	0047a403          	lw	s0,4(a5)
    1180:	ff878713          	addi	a4,a5,-8
    1184:	26e40063          	beq	s0,a4,13e4 <_malloc_r+0x2cc>
    1188:	00442783          	lw	a5,4(s0)
    118c:	00c42683          	lw	a3,12(s0)
    1190:	00842603          	lw	a2,8(s0)
    1194:	ffc7f793          	andi	a5,a5,-4
    1198:	00f407b3          	add	a5,s0,a5
    119c:	0047a703          	lw	a4,4(a5)
    11a0:	00d62623          	sw	a3,12(a2)
    11a4:	00c6a423          	sw	a2,8(a3)
    11a8:	00176713          	ori	a4,a4,1
    11ac:	00090513          	mv	a0,s2
    11b0:	00e7a223          	sw	a4,4(a5)
    11b4:	0d5000ef          	jal	ra,1a88 <__malloc_unlock>
    11b8:	00840513          	addi	a0,s0,8
    11bc:	1e40006f          	j	13a0 <_malloc_r+0x288>
    11c0:	ff84f493          	andi	s1,s1,-8
    11c4:	1c04c863          	bltz	s1,1394 <_malloc_r+0x27c>
    11c8:	1cb4e663          	bltu	s1,a1,1394 <_malloc_r+0x27c>
    11cc:	0b9000ef          	jal	ra,1a84 <__malloc_lock>
    11d0:	1f700793          	li	a5,503
    11d4:	4a97f463          	bgeu	a5,s1,167c <_malloc_r+0x564>
    11d8:	0094d793          	srli	a5,s1,0x9
    11dc:	1e078c63          	beqz	a5,13d4 <_malloc_r+0x2bc>
    11e0:	00400713          	li	a4,4
    11e4:	42f76863          	bltu	a4,a5,1614 <_malloc_r+0x4fc>
    11e8:	0064d793          	srli	a5,s1,0x6
    11ec:	03978613          	addi	a2,a5,57
    11f0:	03878513          	addi	a0,a5,56
    11f4:	00361693          	slli	a3,a2,0x3
    11f8:	00050997          	auipc	s3,0x50
    11fc:	63498993          	addi	s3,s3,1588 # 5182c <__malloc_av_>
    1200:	00d986b3          	add	a3,s3,a3
    1204:	0046a403          	lw	s0,4(a3)
    1208:	ff868693          	addi	a3,a3,-8
    120c:	02868c63          	beq	a3,s0,1244 <_malloc_r+0x12c>
    1210:	00442783          	lw	a5,4(s0)
    1214:	00f00593          	li	a1,15
    1218:	ffc7f793          	andi	a5,a5,-4
    121c:	40978733          	sub	a4,a5,s1
    1220:	02e5c063          	blt	a1,a4,1240 <_malloc_r+0x128>
    1224:	38075263          	bgez	a4,15a8 <_malloc_r+0x490>
    1228:	00c42403          	lw	s0,12(s0)
    122c:	00868c63          	beq	a3,s0,1244 <_malloc_r+0x12c>
    1230:	00442783          	lw	a5,4(s0)
    1234:	ffc7f793          	andi	a5,a5,-4
    1238:	40978733          	sub	a4,a5,s1
    123c:	fee5d4e3          	bge	a1,a4,1224 <_malloc_r+0x10c>
    1240:	00050613          	mv	a2,a0
    1244:	0109a403          	lw	s0,16(s3)
    1248:	00050817          	auipc	a6,0x50
    124c:	5ec80813          	addi	a6,a6,1516 # 51834 <__malloc_av_+0x8>
    1250:	1b040863          	beq	s0,a6,1400 <_malloc_r+0x2e8>
    1254:	00442583          	lw	a1,4(s0)
    1258:	00f00713          	li	a4,15
    125c:	ffc5f593          	andi	a1,a1,-4
    1260:	409587b3          	sub	a5,a1,s1
    1264:	44f74263          	blt	a4,a5,16a8 <_malloc_r+0x590>
    1268:	00050717          	auipc	a4,0x50
    126c:	5d072c23          	sw	a6,1496(a4) # 51840 <__malloc_av_+0x14>
    1270:	00050717          	auipc	a4,0x50
    1274:	5d072623          	sw	a6,1484(a4) # 5183c <__malloc_av_+0x10>
    1278:	4007d863          	bgez	a5,1688 <_malloc_r+0x570>
    127c:	1ff00793          	li	a5,511
    1280:	32b7ea63          	bltu	a5,a1,15b4 <_malloc_r+0x49c>
    1284:	0035d593          	srli	a1,a1,0x3
    1288:	00158793          	addi	a5,a1,1
    128c:	00379793          	slli	a5,a5,0x3
    1290:	0049a503          	lw	a0,4(s3)
    1294:	00f987b3          	add	a5,s3,a5
    1298:	0007a683          	lw	a3,0(a5)
    129c:	4025d593          	srai	a1,a1,0x2
    12a0:	00100713          	li	a4,1
    12a4:	00b71733          	sll	a4,a4,a1
    12a8:	00a76733          	or	a4,a4,a0
    12ac:	ff878593          	addi	a1,a5,-8
    12b0:	00b42623          	sw	a1,12(s0)
    12b4:	00d42423          	sw	a3,8(s0)
    12b8:	00050597          	auipc	a1,0x50
    12bc:	56e5ac23          	sw	a4,1400(a1) # 51830 <__malloc_av_+0x4>
    12c0:	0087a023          	sw	s0,0(a5)
    12c4:	0086a623          	sw	s0,12(a3)
    12c8:	40265793          	srai	a5,a2,0x2
    12cc:	00100693          	li	a3,1
    12d0:	00f696b3          	sll	a3,a3,a5
    12d4:	14d76063          	bltu	a4,a3,1414 <_malloc_r+0x2fc>
    12d8:	00e6f7b3          	and	a5,a3,a4
    12dc:	02079463          	bnez	a5,1304 <_malloc_r+0x1ec>
    12e0:	00169693          	slli	a3,a3,0x1
    12e4:	ffc67613          	andi	a2,a2,-4
    12e8:	00e6f7b3          	and	a5,a3,a4
    12ec:	00460613          	addi	a2,a2,4
    12f0:	00079a63          	bnez	a5,1304 <_malloc_r+0x1ec>
    12f4:	00169693          	slli	a3,a3,0x1
    12f8:	00e6f7b3          	and	a5,a3,a4
    12fc:	00460613          	addi	a2,a2,4
    1300:	fe078ae3          	beqz	a5,12f4 <_malloc_r+0x1dc>
    1304:	00f00513          	li	a0,15
    1308:	00361893          	slli	a7,a2,0x3
    130c:	011988b3          	add	a7,s3,a7
    1310:	00088593          	mv	a1,a7
    1314:	00060313          	mv	t1,a2
    1318:	00c5a403          	lw	s0,12(a1)
    131c:	00859a63          	bne	a1,s0,1330 <_malloc_r+0x218>
    1320:	3180006f          	j	1638 <_malloc_r+0x520>
    1324:	32075463          	bgez	a4,164c <_malloc_r+0x534>
    1328:	00c42403          	lw	s0,12(s0)
    132c:	30858663          	beq	a1,s0,1638 <_malloc_r+0x520>
    1330:	00442783          	lw	a5,4(s0)
    1334:	ffc7f793          	andi	a5,a5,-4
    1338:	40978733          	sub	a4,a5,s1
    133c:	fee554e3          	bge	a0,a4,1324 <_malloc_r+0x20c>
    1340:	00c42683          	lw	a3,12(s0)
    1344:	00842603          	lw	a2,8(s0)
    1348:	0014e593          	ori	a1,s1,1
    134c:	00b42223          	sw	a1,4(s0)
    1350:	00d62623          	sw	a3,12(a2)
    1354:	00c6a423          	sw	a2,8(a3)
    1358:	009404b3          	add	s1,s0,s1
    135c:	00050697          	auipc	a3,0x50
    1360:	4e96a223          	sw	s1,1252(a3) # 51840 <__malloc_av_+0x14>
    1364:	00050697          	auipc	a3,0x50
    1368:	4c96ac23          	sw	s1,1240(a3) # 5183c <__malloc_av_+0x10>
    136c:	00176693          	ori	a3,a4,1
    1370:	0104a623          	sw	a6,12(s1)
    1374:	0104a423          	sw	a6,8(s1)
    1378:	00d4a223          	sw	a3,4(s1)
    137c:	00f407b3          	add	a5,s0,a5
    1380:	00090513          	mv	a0,s2
    1384:	00e7a023          	sw	a4,0(a5)
    1388:	700000ef          	jal	ra,1a88 <__malloc_unlock>
    138c:	00840513          	addi	a0,s0,8
    1390:	0100006f          	j	13a0 <_malloc_r+0x288>
    1394:	00c00793          	li	a5,12
    1398:	00f92023          	sw	a5,0(s2)
    139c:	00000513          	li	a0,0
    13a0:	02c12083          	lw	ra,44(sp)
    13a4:	02812403          	lw	s0,40(sp)
    13a8:	02412483          	lw	s1,36(sp)
    13ac:	02012903          	lw	s2,32(sp)
    13b0:	01c12983          	lw	s3,28(sp)
    13b4:	01812a03          	lw	s4,24(sp)
    13b8:	01412a83          	lw	s5,20(sp)
    13bc:	01012b03          	lw	s6,16(sp)
    13c0:	00c12b83          	lw	s7,12(sp)
    13c4:	00812c03          	lw	s8,8(sp)
    13c8:	00412c83          	lw	s9,4(sp)
    13cc:	03010113          	addi	sp,sp,48
    13d0:	00008067          	ret
    13d4:	20000693          	li	a3,512
    13d8:	04000613          	li	a2,64
    13dc:	03f00513          	li	a0,63
    13e0:	e19ff06f          	j	11f8 <_malloc_r+0xe0>
    13e4:	00c7a403          	lw	s0,12(a5)
    13e8:	00260613          	addi	a2,a2,2
    13ec:	d8879ee3          	bne	a5,s0,1188 <_malloc_r+0x70>
    13f0:	0109a403          	lw	s0,16(s3)
    13f4:	00050817          	auipc	a6,0x50
    13f8:	44080813          	addi	a6,a6,1088 # 51834 <__malloc_av_+0x8>
    13fc:	e5041ce3          	bne	s0,a6,1254 <_malloc_r+0x13c>
    1400:	0049a703          	lw	a4,4(s3)
    1404:	40265793          	srai	a5,a2,0x2
    1408:	00100693          	li	a3,1
    140c:	00f696b3          	sll	a3,a3,a5
    1410:	ecd774e3          	bgeu	a4,a3,12d8 <_malloc_r+0x1c0>
    1414:	0089a403          	lw	s0,8(s3)
    1418:	00442a83          	lw	s5,4(s0)
    141c:	ffcafb93          	andi	s7,s5,-4
    1420:	009be863          	bltu	s7,s1,1430 <_malloc_r+0x318>
    1424:	409b87b3          	sub	a5,s7,s1
    1428:	00f00713          	li	a4,15
    142c:	14f74863          	blt	a4,a5,157c <_malloc_r+0x464>
    1430:	88c18793          	addi	a5,gp,-1908 # 520dc <__malloc_top_pad>
    1434:	82c18c13          	addi	s8,gp,-2004 # 5207c <__malloc_sbrk_base>
    1438:	0007aa83          	lw	s5,0(a5)
    143c:	000c2703          	lw	a4,0(s8)
    1440:	fff00793          	li	a5,-1
    1444:	01740a33          	add	s4,s0,s7
    1448:	01548ab3          	add	s5,s1,s5
    144c:	34f70663          	beq	a4,a5,1798 <_malloc_r+0x680>
    1450:	000017b7          	lui	a5,0x1
    1454:	00f78793          	addi	a5,a5,15 # 100f <init+0x7>
    1458:	00fa8ab3          	add	s5,s5,a5
    145c:	fffff7b7          	lui	a5,0xfffff
    1460:	00fafab3          	and	s5,s5,a5
    1464:	000a8593          	mv	a1,s5
    1468:	00090513          	mv	a0,s2
    146c:	68c000ef          	jal	ra,1af8 <_sbrk_r>
    1470:	fff00793          	li	a5,-1
    1474:	00050b13          	mv	s6,a0
    1478:	28f50663          	beq	a0,a5,1704 <_malloc_r+0x5ec>
    147c:	29456263          	bltu	a0,s4,1700 <_malloc_r+0x5e8>
    1480:	89418c93          	addi	s9,gp,-1900 # 520e4 <__malloc_current_mallinfo>
    1484:	000ca783          	lw	a5,0(s9)
    1488:	00fa87b3          	add	a5,s5,a5
    148c:	88f1aa23          	sw	a5,-1900(gp) # 520e4 <__malloc_current_mallinfo>
    1490:	00078713          	mv	a4,a5
    1494:	3aaa0663          	beq	s4,a0,1840 <_malloc_r+0x728>
    1498:	000c2683          	lw	a3,0(s8)
    149c:	fff00793          	li	a5,-1
    14a0:	3af68e63          	beq	a3,a5,185c <_malloc_r+0x744>
    14a4:	414b07b3          	sub	a5,s6,s4
    14a8:	00e787b3          	add	a5,a5,a4
    14ac:	88f1aa23          	sw	a5,-1900(gp) # 520e4 <__malloc_current_mallinfo>
    14b0:	007b7c13          	andi	s8,s6,7
    14b4:	300c0663          	beqz	s8,17c0 <_malloc_r+0x6a8>
    14b8:	418b0b33          	sub	s6,s6,s8
    14bc:	000017b7          	lui	a5,0x1
    14c0:	008b0b13          	addi	s6,s6,8
    14c4:	fff78a13          	addi	s4,a5,-1 # fff <CUSTOM2+0xfa4>
    14c8:	015b0ab3          	add	s5,s6,s5
    14cc:	00878793          	addi	a5,a5,8
    14d0:	014af733          	and	a4,s5,s4
    14d4:	418787b3          	sub	a5,a5,s8
    14d8:	40e787b3          	sub	a5,a5,a4
    14dc:	0147fa33          	and	s4,a5,s4
    14e0:	000a0593          	mv	a1,s4
    14e4:	00090513          	mv	a0,s2
    14e8:	610000ef          	jal	ra,1af8 <_sbrk_r>
    14ec:	fff00793          	li	a5,-1
    14f0:	3cf50063          	beq	a0,a5,18b0 <_malloc_r+0x798>
    14f4:	41650533          	sub	a0,a0,s6
    14f8:	01450ab3          	add	s5,a0,s4
    14fc:	000ca783          	lw	a5,0(s9)
    1500:	00050717          	auipc	a4,0x50
    1504:	33672a23          	sw	s6,820(a4) # 51834 <__malloc_av_+0x8>
    1508:	001aea93          	ori	s5,s5,1
    150c:	00fa07b3          	add	a5,s4,a5
    1510:	88f1aa23          	sw	a5,-1900(gp) # 520e4 <__malloc_current_mallinfo>
    1514:	015b2223          	sw	s5,4(s6)
    1518:	35340663          	beq	s0,s3,1864 <_malloc_r+0x74c>
    151c:	00f00613          	li	a2,15
    1520:	35767663          	bgeu	a2,s7,186c <_malloc_r+0x754>
    1524:	00442683          	lw	a3,4(s0)
    1528:	ff4b8713          	addi	a4,s7,-12
    152c:	ff877713          	andi	a4,a4,-8
    1530:	0016f693          	andi	a3,a3,1
    1534:	00e6e6b3          	or	a3,a3,a4
    1538:	00d42223          	sw	a3,4(s0)
    153c:	00500593          	li	a1,5
    1540:	00e406b3          	add	a3,s0,a4
    1544:	00b6a223          	sw	a1,4(a3)
    1548:	00b6a423          	sw	a1,8(a3)
    154c:	36e66c63          	bltu	a2,a4,18c4 <_malloc_r+0x7ac>
    1550:	004b2a83          	lw	s5,4(s6)
    1554:	000b0413          	mv	s0,s6
    1558:	88418713          	addi	a4,gp,-1916 # 520d4 <__malloc_max_sbrked_mem>
    155c:	00072703          	lw	a4,0(a4)
    1560:	00f77463          	bgeu	a4,a5,1568 <_malloc_r+0x450>
    1564:	88f1a223          	sw	a5,-1916(gp) # 520d4 <__malloc_max_sbrked_mem>
    1568:	88818713          	addi	a4,gp,-1912 # 520d8 <__malloc_max_total_mem>
    156c:	00072703          	lw	a4,0(a4)
    1570:	18f77e63          	bgeu	a4,a5,170c <_malloc_r+0x5f4>
    1574:	88f1a423          	sw	a5,-1912(gp) # 520d8 <__malloc_max_total_mem>
    1578:	1940006f          	j	170c <_malloc_r+0x5f4>
    157c:	0014e713          	ori	a4,s1,1
    1580:	00e42223          	sw	a4,4(s0)
    1584:	009404b3          	add	s1,s0,s1
    1588:	00050717          	auipc	a4,0x50
    158c:	2a972623          	sw	s1,684(a4) # 51834 <__malloc_av_+0x8>
    1590:	0017e793          	ori	a5,a5,1
    1594:	00090513          	mv	a0,s2
    1598:	00f4a223          	sw	a5,4(s1)
    159c:	4ec000ef          	jal	ra,1a88 <__malloc_unlock>
    15a0:	00840513          	addi	a0,s0,8
    15a4:	dfdff06f          	j	13a0 <_malloc_r+0x288>
    15a8:	00c42683          	lw	a3,12(s0)
    15ac:	00842603          	lw	a2,8(s0)
    15b0:	be9ff06f          	j	1198 <_malloc_r+0x80>
    15b4:	0095d793          	srli	a5,a1,0x9
    15b8:	00400713          	li	a4,4
    15bc:	12f77863          	bgeu	a4,a5,16ec <_malloc_r+0x5d4>
    15c0:	01400713          	li	a4,20
    15c4:	22f76863          	bltu	a4,a5,17f4 <_malloc_r+0x6dc>
    15c8:	05c78693          	addi	a3,a5,92
    15cc:	05b78713          	addi	a4,a5,91
    15d0:	00369693          	slli	a3,a3,0x3
    15d4:	00d986b3          	add	a3,s3,a3
    15d8:	0006a783          	lw	a5,0(a3)
    15dc:	ff868693          	addi	a3,a3,-8
    15e0:	1cf68063          	beq	a3,a5,17a0 <_malloc_r+0x688>
    15e4:	0047a703          	lw	a4,4(a5)
    15e8:	ffc77713          	andi	a4,a4,-4
    15ec:	00e5f663          	bgeu	a1,a4,15f8 <_malloc_r+0x4e0>
    15f0:	0087a783          	lw	a5,8(a5)
    15f4:	fef698e3          	bne	a3,a5,15e4 <_malloc_r+0x4cc>
    15f8:	00c7a683          	lw	a3,12(a5)
    15fc:	0049a703          	lw	a4,4(s3)
    1600:	00d42623          	sw	a3,12(s0)
    1604:	00f42423          	sw	a5,8(s0)
    1608:	0086a423          	sw	s0,8(a3)
    160c:	0087a623          	sw	s0,12(a5)
    1610:	cb9ff06f          	j	12c8 <_malloc_r+0x1b0>
    1614:	01400713          	li	a4,20
    1618:	10f77c63          	bgeu	a4,a5,1730 <_malloc_r+0x618>
    161c:	05400713          	li	a4,84
    1620:	1ef76863          	bltu	a4,a5,1810 <_malloc_r+0x6f8>
    1624:	00c4d793          	srli	a5,s1,0xc
    1628:	06f78613          	addi	a2,a5,111
    162c:	06e78513          	addi	a0,a5,110
    1630:	00361693          	slli	a3,a2,0x3
    1634:	bc5ff06f          	j	11f8 <_malloc_r+0xe0>
    1638:	00130313          	addi	t1,t1,1
    163c:	00337793          	andi	a5,t1,3
    1640:	00858593          	addi	a1,a1,8
    1644:	cc079ae3          	bnez	a5,1318 <_malloc_r+0x200>
    1648:	1040006f          	j	174c <_malloc_r+0x634>
    164c:	00f407b3          	add	a5,s0,a5
    1650:	0047a703          	lw	a4,4(a5)
    1654:	00c42683          	lw	a3,12(s0)
    1658:	00842603          	lw	a2,8(s0)
    165c:	00176713          	ori	a4,a4,1
    1660:	00e7a223          	sw	a4,4(a5)
    1664:	00d62623          	sw	a3,12(a2)
    1668:	00090513          	mv	a0,s2
    166c:	00c6a423          	sw	a2,8(a3)
    1670:	418000ef          	jal	ra,1a88 <__malloc_unlock>
    1674:	00840513          	addi	a0,s0,8
    1678:	d29ff06f          	j	13a0 <_malloc_r+0x288>
    167c:	0034d613          	srli	a2,s1,0x3
    1680:	00848793          	addi	a5,s1,8
    1684:	aedff06f          	j	1170 <_malloc_r+0x58>
    1688:	00b405b3          	add	a1,s0,a1
    168c:	0045a783          	lw	a5,4(a1)
    1690:	00090513          	mv	a0,s2
    1694:	0017e793          	ori	a5,a5,1
    1698:	00f5a223          	sw	a5,4(a1)
    169c:	3ec000ef          	jal	ra,1a88 <__malloc_unlock>
    16a0:	00840513          	addi	a0,s0,8
    16a4:	cfdff06f          	j	13a0 <_malloc_r+0x288>
    16a8:	0014e713          	ori	a4,s1,1
    16ac:	00e42223          	sw	a4,4(s0)
    16b0:	009404b3          	add	s1,s0,s1
    16b4:	00050717          	auipc	a4,0x50
    16b8:	18972623          	sw	s1,396(a4) # 51840 <__malloc_av_+0x14>
    16bc:	00050717          	auipc	a4,0x50
    16c0:	18972023          	sw	s1,384(a4) # 5183c <__malloc_av_+0x10>
    16c4:	0017e713          	ori	a4,a5,1
    16c8:	0104a623          	sw	a6,12(s1)
    16cc:	0104a423          	sw	a6,8(s1)
    16d0:	00e4a223          	sw	a4,4(s1)
    16d4:	00b405b3          	add	a1,s0,a1
    16d8:	00090513          	mv	a0,s2
    16dc:	00f5a023          	sw	a5,0(a1)
    16e0:	3a8000ef          	jal	ra,1a88 <__malloc_unlock>
    16e4:	00840513          	addi	a0,s0,8
    16e8:	cb9ff06f          	j	13a0 <_malloc_r+0x288>
    16ec:	0065d793          	srli	a5,a1,0x6
    16f0:	03978693          	addi	a3,a5,57
    16f4:	03878713          	addi	a4,a5,56
    16f8:	00369693          	slli	a3,a3,0x3
    16fc:	ed9ff06f          	j	15d4 <_malloc_r+0x4bc>
    1700:	13340663          	beq	s0,s3,182c <_malloc_r+0x714>
    1704:	0089a403          	lw	s0,8(s3)
    1708:	00442a83          	lw	s5,4(s0)
    170c:	ffcafa93          	andi	s5,s5,-4
    1710:	409a87b3          	sub	a5,s5,s1
    1714:	009ae663          	bltu	s5,s1,1720 <_malloc_r+0x608>
    1718:	00f00713          	li	a4,15
    171c:	e6f740e3          	blt	a4,a5,157c <_malloc_r+0x464>
    1720:	00090513          	mv	a0,s2
    1724:	364000ef          	jal	ra,1a88 <__malloc_unlock>
    1728:	00000513          	li	a0,0
    172c:	c75ff06f          	j	13a0 <_malloc_r+0x288>
    1730:	05c78613          	addi	a2,a5,92
    1734:	05b78513          	addi	a0,a5,91
    1738:	00361693          	slli	a3,a2,0x3
    173c:	abdff06f          	j	11f8 <_malloc_r+0xe0>
    1740:	0088a783          	lw	a5,8(a7)
    1744:	fff60613          	addi	a2,a2,-1
    1748:	1d179863          	bne	a5,a7,1918 <_malloc_r+0x800>
    174c:	00367793          	andi	a5,a2,3
    1750:	ff888893          	addi	a7,a7,-8
    1754:	fe0796e3          	bnez	a5,1740 <_malloc_r+0x628>
    1758:	0049a703          	lw	a4,4(s3)
    175c:	fff6c793          	not	a5,a3
    1760:	00e7f7b3          	and	a5,a5,a4
    1764:	00050717          	auipc	a4,0x50
    1768:	0cf72623          	sw	a5,204(a4) # 51830 <__malloc_av_+0x4>
    176c:	00169693          	slli	a3,a3,0x1
    1770:	cad7e2e3          	bltu	a5,a3,1414 <_malloc_r+0x2fc>
    1774:	ca0680e3          	beqz	a3,1414 <_malloc_r+0x2fc>
    1778:	00f6f733          	and	a4,a3,a5
    177c:	00071a63          	bnez	a4,1790 <_malloc_r+0x678>
    1780:	00169693          	slli	a3,a3,0x1
    1784:	00f6f733          	and	a4,a3,a5
    1788:	00430313          	addi	t1,t1,4
    178c:	fe070ae3          	beqz	a4,1780 <_malloc_r+0x668>
    1790:	00030613          	mv	a2,t1
    1794:	b75ff06f          	j	1308 <_malloc_r+0x1f0>
    1798:	010a8a93          	addi	s5,s5,16
    179c:	cc9ff06f          	j	1464 <_malloc_r+0x34c>
    17a0:	0049a503          	lw	a0,4(s3)
    17a4:	40275593          	srai	a1,a4,0x2
    17a8:	00100713          	li	a4,1
    17ac:	00b71733          	sll	a4,a4,a1
    17b0:	00a76733          	or	a4,a4,a0
    17b4:	00050597          	auipc	a1,0x50
    17b8:	06e5ae23          	sw	a4,124(a1) # 51830 <__malloc_av_+0x4>
    17bc:	e45ff06f          	j	1600 <_malloc_r+0x4e8>
    17c0:	000017b7          	lui	a5,0x1
    17c4:	fff78713          	addi	a4,a5,-1 # fff <CUSTOM2+0xfa4>
    17c8:	015b0a33          	add	s4,s6,s5
    17cc:	00ea7a33          	and	s4,s4,a4
    17d0:	414787b3          	sub	a5,a5,s4
    17d4:	00e7fa33          	and	s4,a5,a4
    17d8:	000a0593          	mv	a1,s4
    17dc:	00090513          	mv	a0,s2
    17e0:	318000ef          	jal	ra,1af8 <_sbrk_r>
    17e4:	fff00793          	li	a5,-1
    17e8:	d0f516e3          	bne	a0,a5,14f4 <_malloc_r+0x3dc>
    17ec:	00000a13          	li	s4,0
    17f0:	d0dff06f          	j	14fc <_malloc_r+0x3e4>
    17f4:	05400713          	li	a4,84
    17f8:	08f76063          	bltu	a4,a5,1878 <_malloc_r+0x760>
    17fc:	00c5d793          	srli	a5,a1,0xc
    1800:	06f78693          	addi	a3,a5,111
    1804:	06e78713          	addi	a4,a5,110
    1808:	00369693          	slli	a3,a3,0x3
    180c:	dc9ff06f          	j	15d4 <_malloc_r+0x4bc>
    1810:	15400713          	li	a4,340
    1814:	08f76063          	bltu	a4,a5,1894 <_malloc_r+0x77c>
    1818:	00f4d793          	srli	a5,s1,0xf
    181c:	07878613          	addi	a2,a5,120
    1820:	07778513          	addi	a0,a5,119
    1824:	00361693          	slli	a3,a2,0x3
    1828:	9d1ff06f          	j	11f8 <_malloc_r+0xe0>
    182c:	89418c93          	addi	s9,gp,-1900 # 520e4 <__malloc_current_mallinfo>
    1830:	000ca783          	lw	a5,0(s9)
    1834:	00fa8733          	add	a4,s5,a5
    1838:	88e1aa23          	sw	a4,-1900(gp) # 520e4 <__malloc_current_mallinfo>
    183c:	c5dff06f          	j	1498 <_malloc_r+0x380>
    1840:	014a1693          	slli	a3,s4,0x14
    1844:	c4069ae3          	bnez	a3,1498 <_malloc_r+0x380>
    1848:	0089a403          	lw	s0,8(s3)
    184c:	015b8ab3          	add	s5,s7,s5
    1850:	001aea93          	ori	s5,s5,1
    1854:	01542223          	sw	s5,4(s0)
    1858:	d01ff06f          	j	1558 <_malloc_r+0x440>
    185c:	8361a623          	sw	s6,-2004(gp) # 5207c <__malloc_sbrk_base>
    1860:	c51ff06f          	j	14b0 <_malloc_r+0x398>
    1864:	000b0413          	mv	s0,s6
    1868:	cf1ff06f          	j	1558 <_malloc_r+0x440>
    186c:	00100793          	li	a5,1
    1870:	00fb2223          	sw	a5,4(s6)
    1874:	eadff06f          	j	1720 <_malloc_r+0x608>
    1878:	15400713          	li	a4,340
    187c:	06f76263          	bltu	a4,a5,18e0 <_malloc_r+0x7c8>
    1880:	00f5d793          	srli	a5,a1,0xf
    1884:	07878693          	addi	a3,a5,120
    1888:	07778713          	addi	a4,a5,119
    188c:	00369693          	slli	a3,a3,0x3
    1890:	d45ff06f          	j	15d4 <_malloc_r+0x4bc>
    1894:	55400713          	li	a4,1364
    1898:	06f76263          	bltu	a4,a5,18fc <_malloc_r+0x7e4>
    189c:	0124d793          	srli	a5,s1,0x12
    18a0:	07d78613          	addi	a2,a5,125
    18a4:	07c78513          	addi	a0,a5,124
    18a8:	00361693          	slli	a3,a2,0x3
    18ac:	94dff06f          	j	11f8 <_malloc_r+0xe0>
    18b0:	ff8c0c13          	addi	s8,s8,-8
    18b4:	018a8ab3          	add	s5,s5,s8
    18b8:	416a8ab3          	sub	s5,s5,s6
    18bc:	00000a13          	li	s4,0
    18c0:	c3dff06f          	j	14fc <_malloc_r+0x3e4>
    18c4:	00840593          	addi	a1,s0,8
    18c8:	00090513          	mv	a0,s2
    18cc:	3ac000ef          	jal	ra,1c78 <_free_r>
    18d0:	0089a403          	lw	s0,8(s3)
    18d4:	000ca783          	lw	a5,0(s9)
    18d8:	00442a83          	lw	s5,4(s0)
    18dc:	c7dff06f          	j	1558 <_malloc_r+0x440>
    18e0:	55400713          	li	a4,1364
    18e4:	02f76463          	bltu	a4,a5,190c <_malloc_r+0x7f4>
    18e8:	0125d793          	srli	a5,a1,0x12
    18ec:	07d78693          	addi	a3,a5,125
    18f0:	07c78713          	addi	a4,a5,124
    18f4:	00369693          	slli	a3,a3,0x3
    18f8:	cddff06f          	j	15d4 <_malloc_r+0x4bc>
    18fc:	3f800693          	li	a3,1016
    1900:	07f00613          	li	a2,127
    1904:	07e00513          	li	a0,126
    1908:	8f1ff06f          	j	11f8 <_malloc_r+0xe0>
    190c:	3f800693          	li	a3,1016
    1910:	07e00713          	li	a4,126
    1914:	cc1ff06f          	j	15d4 <_malloc_r+0x4bc>
    1918:	0049a783          	lw	a5,4(s3)
    191c:	e51ff06f          	j	176c <_malloc_r+0x654>

00001920 <memcmp>:
    1920:	00300793          	li	a5,3
    1924:	02c7f863          	bgeu	a5,a2,1954 <memcmp+0x34>
    1928:	00b567b3          	or	a5,a0,a1
    192c:	0037f793          	andi	a5,a5,3
    1930:	00300693          	li	a3,3
    1934:	06079263          	bnez	a5,1998 <memcmp+0x78>
    1938:	00052703          	lw	a4,0(a0)
    193c:	0005a783          	lw	a5,0(a1)
    1940:	04f71c63          	bne	a4,a5,1998 <memcmp+0x78>
    1944:	ffc60613          	addi	a2,a2,-4
    1948:	00450513          	addi	a0,a0,4
    194c:	00458593          	addi	a1,a1,4
    1950:	fec6e4e3          	bltu	a3,a2,1938 <memcmp+0x18>
    1954:	fff60793          	addi	a5,a2,-1
    1958:	02060c63          	beqz	a2,1990 <memcmp+0x70>
    195c:	00054703          	lbu	a4,0(a0)
    1960:	0005c683          	lbu	a3,0(a1)
    1964:	02d71e63          	bne	a4,a3,19a0 <memcmp+0x80>
    1968:	00178713          	addi	a4,a5,1
    196c:	00150793          	addi	a5,a0,1
    1970:	00e50533          	add	a0,a0,a4
    1974:	0140006f          	j	1988 <memcmp+0x68>
    1978:	0007c703          	lbu	a4,0(a5)
    197c:	0005c683          	lbu	a3,0(a1)
    1980:	00178793          	addi	a5,a5,1
    1984:	00d71e63          	bne	a4,a3,19a0 <memcmp+0x80>
    1988:	00158593          	addi	a1,a1,1
    198c:	fea796e3          	bne	a5,a0,1978 <memcmp+0x58>
    1990:	00000513          	li	a0,0
    1994:	00008067          	ret
    1998:	fff60793          	addi	a5,a2,-1
    199c:	fc1ff06f          	j	195c <memcmp+0x3c>
    19a0:	40d70533          	sub	a0,a4,a3
    19a4:	00008067          	ret

000019a8 <memset>:
    19a8:	00f00313          	li	t1,15
    19ac:	00050713          	mv	a4,a0
    19b0:	02c37e63          	bgeu	t1,a2,19ec <memset+0x44>
    19b4:	00f77793          	andi	a5,a4,15
    19b8:	0a079063          	bnez	a5,1a58 <memset+0xb0>
    19bc:	08059263          	bnez	a1,1a40 <memset+0x98>
    19c0:	ff067693          	andi	a3,a2,-16
    19c4:	00f67613          	andi	a2,a2,15
    19c8:	00e686b3          	add	a3,a3,a4
    19cc:	00b72023          	sw	a1,0(a4)
    19d0:	00b72223          	sw	a1,4(a4)
    19d4:	00b72423          	sw	a1,8(a4)
    19d8:	00b72623          	sw	a1,12(a4)
    19dc:	01070713          	addi	a4,a4,16
    19e0:	fed766e3          	bltu	a4,a3,19cc <memset+0x24>
    19e4:	00061463          	bnez	a2,19ec <memset+0x44>
    19e8:	00008067          	ret
    19ec:	40c306b3          	sub	a3,t1,a2
    19f0:	00269693          	slli	a3,a3,0x2
    19f4:	00000297          	auipc	t0,0x0
    19f8:	005686b3          	add	a3,a3,t0
    19fc:	00c68067          	jr	12(a3)
    1a00:	00b70723          	sb	a1,14(a4)
    1a04:	00b706a3          	sb	a1,13(a4)
    1a08:	00b70623          	sb	a1,12(a4)
    1a0c:	00b705a3          	sb	a1,11(a4)
    1a10:	00b70523          	sb	a1,10(a4)
    1a14:	00b704a3          	sb	a1,9(a4)
    1a18:	00b70423          	sb	a1,8(a4)
    1a1c:	00b703a3          	sb	a1,7(a4)
    1a20:	00b70323          	sb	a1,6(a4)
    1a24:	00b702a3          	sb	a1,5(a4)
    1a28:	00b70223          	sb	a1,4(a4)
    1a2c:	00b701a3          	sb	a1,3(a4)
    1a30:	00b70123          	sb	a1,2(a4)
    1a34:	00b700a3          	sb	a1,1(a4)
    1a38:	00b70023          	sb	a1,0(a4)
    1a3c:	00008067          	ret
    1a40:	0ff5f593          	andi	a1,a1,255
    1a44:	00859693          	slli	a3,a1,0x8
    1a48:	00d5e5b3          	or	a1,a1,a3
    1a4c:	01059693          	slli	a3,a1,0x10
    1a50:	00d5e5b3          	or	a1,a1,a3
    1a54:	f6dff06f          	j	19c0 <memset+0x18>
    1a58:	00279693          	slli	a3,a5,0x2
    1a5c:	00000297          	auipc	t0,0x0
    1a60:	005686b3          	add	a3,a3,t0
    1a64:	00008293          	mv	t0,ra
    1a68:	fa0680e7          	jalr	-96(a3)
    1a6c:	00028093          	mv	ra,t0
    1a70:	ff078793          	addi	a5,a5,-16
    1a74:	40f70733          	sub	a4,a4,a5
    1a78:	00f60633          	add	a2,a2,a5
    1a7c:	f6c378e3          	bgeu	t1,a2,19ec <memset+0x44>
    1a80:	f3dff06f          	j	19bc <memset+0x14>

00001a84 <__malloc_lock>:
    1a84:	00008067          	ret

00001a88 <__malloc_unlock>:
    1a88:	00008067          	ret

00001a8c <srand>:
    1a8c:	83418793          	addi	a5,gp,-1996 # 52084 <_impure_ptr>
    1a90:	0007a783          	lw	a5,0(a5)
    1a94:	0aa7a423          	sw	a0,168(a5)
    1a98:	0a07a623          	sw	zero,172(a5)
    1a9c:	00008067          	ret

00001aa0 <rand>:
    1aa0:	83418793          	addi	a5,gp,-1996 # 52084 <_impure_ptr>
    1aa4:	0007a803          	lw	a6,0(a5)
    1aa8:	4c9585b7          	lui	a1,0x4c958
    1aac:	f2d58593          	addi	a1,a1,-211 # 4c957f2d <__freertos_irq_stack_top+0x4c9044bd>
    1ab0:	0a882683          	lw	a3,168(a6)
    1ab4:	0ac82703          	lw	a4,172(a6)
    1ab8:	02b687b3          	mul	a5,a3,a1
    1abc:	00178613          	addi	a2,a5,1
    1ac0:	00f637b3          	sltu	a5,a2,a5
    1ac4:	0ac82423          	sw	a2,168(a6)
    1ac8:	5851f637          	lui	a2,0x5851f
    1acc:	42d60613          	addi	a2,a2,1069 # 5851f42d <__freertos_irq_stack_top+0x584cb9bd>
    1ad0:	02c68633          	mul	a2,a3,a2
    1ad4:	02b70733          	mul	a4,a4,a1
    1ad8:	02b6b6b3          	mulhu	a3,a3,a1
    1adc:	00c70733          	add	a4,a4,a2
    1ae0:	00d70733          	add	a4,a4,a3
    1ae4:	00e787b3          	add	a5,a5,a4
    1ae8:	00179513          	slli	a0,a5,0x1
    1aec:	0af82623          	sw	a5,172(a6)
    1af0:	00155513          	srli	a0,a0,0x1
    1af4:	00008067          	ret

00001af8 <_sbrk_r>:
    1af8:	ff010113          	addi	sp,sp,-16
    1afc:	00812423          	sw	s0,8(sp)
    1b00:	00050413          	mv	s0,a0
    1b04:	00058513          	mv	a0,a1
    1b08:	2001ac23          	sw	zero,536(gp) # 52a68 <errno>
    1b0c:	00112623          	sw	ra,12(sp)
    1b10:	6a9060ef          	jal	ra,89b8 <_sbrk>
    1b14:	fff00793          	li	a5,-1
    1b18:	00f50a63          	beq	a0,a5,1b2c <_sbrk_r+0x34>
    1b1c:	00c12083          	lw	ra,12(sp)
    1b20:	00812403          	lw	s0,8(sp)
    1b24:	01010113          	addi	sp,sp,16
    1b28:	00008067          	ret
    1b2c:	21818793          	addi	a5,gp,536 # 52a68 <errno>
    1b30:	0007a783          	lw	a5,0(a5)
    1b34:	fe0784e3          	beqz	a5,1b1c <_sbrk_r+0x24>
    1b38:	00f42023          	sw	a5,0(s0)
    1b3c:	00c12083          	lw	ra,12(sp)
    1b40:	00812403          	lw	s0,8(sp)
    1b44:	01010113          	addi	sp,sp,16
    1b48:	00008067          	ret

00001b4c <_malloc_trim_r>:
    1b4c:	fe010113          	addi	sp,sp,-32
    1b50:	00812c23          	sw	s0,24(sp)
    1b54:	00912a23          	sw	s1,20(sp)
    1b58:	01212823          	sw	s2,16(sp)
    1b5c:	01312623          	sw	s3,12(sp)
    1b60:	00058413          	mv	s0,a1
    1b64:	00112e23          	sw	ra,28(sp)
    1b68:	00050997          	auipc	s3,0x50
    1b6c:	cc498993          	addi	s3,s3,-828 # 5182c <__malloc_av_>
    1b70:	00050913          	mv	s2,a0
    1b74:	f11ff0ef          	jal	ra,1a84 <__malloc_lock>
    1b78:	0089a683          	lw	a3,8(s3)
    1b7c:	00001737          	lui	a4,0x1
    1b80:	fef70793          	addi	a5,a4,-17 # fef <CUSTOM2+0xf94>
    1b84:	0046a483          	lw	s1,4(a3)
    1b88:	40878433          	sub	s0,a5,s0
    1b8c:	ffc4f493          	andi	s1,s1,-4
    1b90:	00940433          	add	s0,s0,s1
    1b94:	00c45413          	srli	s0,s0,0xc
    1b98:	fff40413          	addi	s0,s0,-1
    1b9c:	00c41413          	slli	s0,s0,0xc
    1ba0:	00e44e63          	blt	s0,a4,1bbc <_malloc_trim_r+0x70>
    1ba4:	00000593          	li	a1,0
    1ba8:	00090513          	mv	a0,s2
    1bac:	f4dff0ef          	jal	ra,1af8 <_sbrk_r>
    1bb0:	0089a783          	lw	a5,8(s3)
    1bb4:	009787b3          	add	a5,a5,s1
    1bb8:	02f50663          	beq	a0,a5,1be4 <_malloc_trim_r+0x98>
    1bbc:	00090513          	mv	a0,s2
    1bc0:	ec9ff0ef          	jal	ra,1a88 <__malloc_unlock>
    1bc4:	01c12083          	lw	ra,28(sp)
    1bc8:	01812403          	lw	s0,24(sp)
    1bcc:	01412483          	lw	s1,20(sp)
    1bd0:	01012903          	lw	s2,16(sp)
    1bd4:	00c12983          	lw	s3,12(sp)
    1bd8:	00000513          	li	a0,0
    1bdc:	02010113          	addi	sp,sp,32
    1be0:	00008067          	ret
    1be4:	408005b3          	neg	a1,s0
    1be8:	00090513          	mv	a0,s2
    1bec:	f0dff0ef          	jal	ra,1af8 <_sbrk_r>
    1bf0:	fff00793          	li	a5,-1
    1bf4:	04f50663          	beq	a0,a5,1c40 <_malloc_trim_r+0xf4>
    1bf8:	89418793          	addi	a5,gp,-1900 # 520e4 <__malloc_current_mallinfo>
    1bfc:	0007a783          	lw	a5,0(a5)
    1c00:	0089a703          	lw	a4,8(s3)
    1c04:	408484b3          	sub	s1,s1,s0
    1c08:	0014e493          	ori	s1,s1,1
    1c0c:	40878433          	sub	s0,a5,s0
    1c10:	00090513          	mv	a0,s2
    1c14:	00972223          	sw	s1,4(a4)
    1c18:	8881aa23          	sw	s0,-1900(gp) # 520e4 <__malloc_current_mallinfo>
    1c1c:	e6dff0ef          	jal	ra,1a88 <__malloc_unlock>
    1c20:	01c12083          	lw	ra,28(sp)
    1c24:	01812403          	lw	s0,24(sp)
    1c28:	01412483          	lw	s1,20(sp)
    1c2c:	01012903          	lw	s2,16(sp)
    1c30:	00c12983          	lw	s3,12(sp)
    1c34:	00100513          	li	a0,1
    1c38:	02010113          	addi	sp,sp,32
    1c3c:	00008067          	ret
    1c40:	00000593          	li	a1,0
    1c44:	00090513          	mv	a0,s2
    1c48:	eb1ff0ef          	jal	ra,1af8 <_sbrk_r>
    1c4c:	0089a703          	lw	a4,8(s3)
    1c50:	00f00693          	li	a3,15
    1c54:	40e507b3          	sub	a5,a0,a4
    1c58:	f6f6d2e3          	bge	a3,a5,1bbc <_malloc_trim_r+0x70>
    1c5c:	82c18693          	addi	a3,gp,-2004 # 5207c <__malloc_sbrk_base>
    1c60:	0006a683          	lw	a3,0(a3)
    1c64:	0017e793          	ori	a5,a5,1
    1c68:	00f72223          	sw	a5,4(a4)
    1c6c:	40d50533          	sub	a0,a0,a3
    1c70:	88a1aa23          	sw	a0,-1900(gp) # 520e4 <__malloc_current_mallinfo>
    1c74:	f49ff06f          	j	1bbc <_malloc_trim_r+0x70>

00001c78 <_free_r>:
    1c78:	12058e63          	beqz	a1,1db4 <_free_r+0x13c>
    1c7c:	ff010113          	addi	sp,sp,-16
    1c80:	00812423          	sw	s0,8(sp)
    1c84:	00912223          	sw	s1,4(sp)
    1c88:	00058413          	mv	s0,a1
    1c8c:	00050493          	mv	s1,a0
    1c90:	00112623          	sw	ra,12(sp)
    1c94:	df1ff0ef          	jal	ra,1a84 <__malloc_lock>
    1c98:	ffc42583          	lw	a1,-4(s0)
    1c9c:	ff840713          	addi	a4,s0,-8
    1ca0:	00050517          	auipc	a0,0x50
    1ca4:	b8c50513          	addi	a0,a0,-1140 # 5182c <__malloc_av_>
    1ca8:	ffe5f793          	andi	a5,a1,-2
    1cac:	00f70633          	add	a2,a4,a5
    1cb0:	00462683          	lw	a3,4(a2)
    1cb4:	00852803          	lw	a6,8(a0)
    1cb8:	ffc6f693          	andi	a3,a3,-4
    1cbc:	1ac80463          	beq	a6,a2,1e64 <_free_r+0x1ec>
    1cc0:	00d62223          	sw	a3,4(a2)
    1cc4:	0015f593          	andi	a1,a1,1
    1cc8:	00d60833          	add	a6,a2,a3
    1ccc:	0a059463          	bnez	a1,1d74 <_free_r+0xfc>
    1cd0:	ff842303          	lw	t1,-8(s0)
    1cd4:	00482583          	lw	a1,4(a6)
    1cd8:	00050897          	auipc	a7,0x50
    1cdc:	b5c88893          	addi	a7,a7,-1188 # 51834 <__malloc_av_+0x8>
    1ce0:	40670733          	sub	a4,a4,t1
    1ce4:	00872803          	lw	a6,8(a4)
    1ce8:	006787b3          	add	a5,a5,t1
    1cec:	0015f593          	andi	a1,a1,1
    1cf0:	15180463          	beq	a6,a7,1e38 <_free_r+0x1c0>
    1cf4:	00c72303          	lw	t1,12(a4)
    1cf8:	00682623          	sw	t1,12(a6)
    1cfc:	01032423          	sw	a6,8(t1)
    1d00:	1e058063          	beqz	a1,1ee0 <_free_r+0x268>
    1d04:	0017e693          	ori	a3,a5,1
    1d08:	00d72223          	sw	a3,4(a4)
    1d0c:	00f62023          	sw	a5,0(a2)
    1d10:	1ff00693          	li	a3,511
    1d14:	0af6ec63          	bltu	a3,a5,1dcc <_free_r+0x154>
    1d18:	0037d793          	srli	a5,a5,0x3
    1d1c:	00178693          	addi	a3,a5,1
    1d20:	00369693          	slli	a3,a3,0x3
    1d24:	00452583          	lw	a1,4(a0)
    1d28:	00d50533          	add	a0,a0,a3
    1d2c:	00052603          	lw	a2,0(a0)
    1d30:	4027d693          	srai	a3,a5,0x2
    1d34:	00100793          	li	a5,1
    1d38:	00d797b3          	sll	a5,a5,a3
    1d3c:	00b7e7b3          	or	a5,a5,a1
    1d40:	ff850693          	addi	a3,a0,-8
    1d44:	00d72623          	sw	a3,12(a4)
    1d48:	00c72423          	sw	a2,8(a4)
    1d4c:	00050697          	auipc	a3,0x50
    1d50:	aef6a223          	sw	a5,-1308(a3) # 51830 <__malloc_av_+0x4>
    1d54:	00e52023          	sw	a4,0(a0)
    1d58:	00e62623          	sw	a4,12(a2)
    1d5c:	00812403          	lw	s0,8(sp)
    1d60:	00c12083          	lw	ra,12(sp)
    1d64:	00048513          	mv	a0,s1
    1d68:	00412483          	lw	s1,4(sp)
    1d6c:	01010113          	addi	sp,sp,16
    1d70:	d19ff06f          	j	1a88 <__malloc_unlock>
    1d74:	00482583          	lw	a1,4(a6)
    1d78:	0015f593          	andi	a1,a1,1
    1d7c:	02059e63          	bnez	a1,1db8 <_free_r+0x140>
    1d80:	00d787b3          	add	a5,a5,a3
    1d84:	00050897          	auipc	a7,0x50
    1d88:	ab088893          	addi	a7,a7,-1360 # 51834 <__malloc_av_+0x8>
    1d8c:	00862683          	lw	a3,8(a2)
    1d90:	0017e813          	ori	a6,a5,1
    1d94:	00f705b3          	add	a1,a4,a5
    1d98:	17168063          	beq	a3,a7,1ef8 <_free_r+0x280>
    1d9c:	00c62603          	lw	a2,12(a2)
    1da0:	00c6a623          	sw	a2,12(a3)
    1da4:	00d62423          	sw	a3,8(a2)
    1da8:	01072223          	sw	a6,4(a4)
    1dac:	00f5a023          	sw	a5,0(a1)
    1db0:	f61ff06f          	j	1d10 <_free_r+0x98>
    1db4:	00008067          	ret
    1db8:	0017e693          	ori	a3,a5,1
    1dbc:	fed42e23          	sw	a3,-4(s0)
    1dc0:	00f62023          	sw	a5,0(a2)
    1dc4:	1ff00693          	li	a3,511
    1dc8:	f4f6f8e3          	bgeu	a3,a5,1d18 <_free_r+0xa0>
    1dcc:	0097d693          	srli	a3,a5,0x9
    1dd0:	00400613          	li	a2,4
    1dd4:	0ed66463          	bltu	a2,a3,1ebc <_free_r+0x244>
    1dd8:	0067d693          	srli	a3,a5,0x6
    1ddc:	03968593          	addi	a1,a3,57
    1de0:	03868613          	addi	a2,a3,56
    1de4:	00359593          	slli	a1,a1,0x3
    1de8:	00b505b3          	add	a1,a0,a1
    1dec:	0005a683          	lw	a3,0(a1)
    1df0:	ff858593          	addi	a1,a1,-8
    1df4:	12d58463          	beq	a1,a3,1f1c <_free_r+0x2a4>
    1df8:	0046a603          	lw	a2,4(a3)
    1dfc:	ffc67613          	andi	a2,a2,-4
    1e00:	00c7f663          	bgeu	a5,a2,1e0c <_free_r+0x194>
    1e04:	0086a683          	lw	a3,8(a3)
    1e08:	fed598e3          	bne	a1,a3,1df8 <_free_r+0x180>
    1e0c:	00c6a583          	lw	a1,12(a3)
    1e10:	00b72623          	sw	a1,12(a4)
    1e14:	00d72423          	sw	a3,8(a4)
    1e18:	00812403          	lw	s0,8(sp)
    1e1c:	00e5a423          	sw	a4,8(a1)
    1e20:	00c12083          	lw	ra,12(sp)
    1e24:	00048513          	mv	a0,s1
    1e28:	00412483          	lw	s1,4(sp)
    1e2c:	00e6a623          	sw	a4,12(a3)
    1e30:	01010113          	addi	sp,sp,16
    1e34:	c55ff06f          	j	1a88 <__malloc_unlock>
    1e38:	14059463          	bnez	a1,1f80 <_free_r+0x308>
    1e3c:	00862583          	lw	a1,8(a2)
    1e40:	00c62603          	lw	a2,12(a2)
    1e44:	00f687b3          	add	a5,a3,a5
    1e48:	0017e693          	ori	a3,a5,1
    1e4c:	00c5a623          	sw	a2,12(a1)
    1e50:	00b62423          	sw	a1,8(a2)
    1e54:	00d72223          	sw	a3,4(a4)
    1e58:	00f70733          	add	a4,a4,a5
    1e5c:	00f72023          	sw	a5,0(a4)
    1e60:	efdff06f          	j	1d5c <_free_r+0xe4>
    1e64:	0015f593          	andi	a1,a1,1
    1e68:	00d787b3          	add	a5,a5,a3
    1e6c:	02059063          	bnez	a1,1e8c <_free_r+0x214>
    1e70:	ff842583          	lw	a1,-8(s0)
    1e74:	40b70733          	sub	a4,a4,a1
    1e78:	00c72683          	lw	a3,12(a4)
    1e7c:	00872603          	lw	a2,8(a4)
    1e80:	00b787b3          	add	a5,a5,a1
    1e84:	00d62623          	sw	a3,12(a2)
    1e88:	00c6a423          	sw	a2,8(a3)
    1e8c:	83018693          	addi	a3,gp,-2000 # 52080 <__malloc_trim_threshold>
    1e90:	0017e613          	ori	a2,a5,1
    1e94:	0006a683          	lw	a3,0(a3)
    1e98:	00c72223          	sw	a2,4(a4)
    1e9c:	00050617          	auipc	a2,0x50
    1ea0:	98e62c23          	sw	a4,-1640(a2) # 51834 <__malloc_av_+0x8>
    1ea4:	ead7ece3          	bltu	a5,a3,1d5c <_free_r+0xe4>
    1ea8:	88c18793          	addi	a5,gp,-1908 # 520dc <__malloc_top_pad>
    1eac:	0007a583          	lw	a1,0(a5)
    1eb0:	00048513          	mv	a0,s1
    1eb4:	c99ff0ef          	jal	ra,1b4c <_malloc_trim_r>
    1eb8:	ea5ff06f          	j	1d5c <_free_r+0xe4>
    1ebc:	01400613          	li	a2,20
    1ec0:	02d67463          	bgeu	a2,a3,1ee8 <_free_r+0x270>
    1ec4:	05400613          	li	a2,84
    1ec8:	06d66a63          	bltu	a2,a3,1f3c <_free_r+0x2c4>
    1ecc:	00c7d693          	srli	a3,a5,0xc
    1ed0:	06f68593          	addi	a1,a3,111
    1ed4:	06e68613          	addi	a2,a3,110
    1ed8:	00359593          	slli	a1,a1,0x3
    1edc:	f0dff06f          	j	1de8 <_free_r+0x170>
    1ee0:	00d787b3          	add	a5,a5,a3
    1ee4:	ea9ff06f          	j	1d8c <_free_r+0x114>
    1ee8:	05c68593          	addi	a1,a3,92
    1eec:	05b68613          	addi	a2,a3,91
    1ef0:	00359593          	slli	a1,a1,0x3
    1ef4:	ef5ff06f          	j	1de8 <_free_r+0x170>
    1ef8:	00050697          	auipc	a3,0x50
    1efc:	94e6a423          	sw	a4,-1720(a3) # 51840 <__malloc_av_+0x14>
    1f00:	00050697          	auipc	a3,0x50
    1f04:	92e6ae23          	sw	a4,-1732(a3) # 5183c <__malloc_av_+0x10>
    1f08:	01172623          	sw	a7,12(a4)
    1f0c:	01172423          	sw	a7,8(a4)
    1f10:	01072223          	sw	a6,4(a4)
    1f14:	00f5a023          	sw	a5,0(a1)
    1f18:	e45ff06f          	j	1d5c <_free_r+0xe4>
    1f1c:	00452503          	lw	a0,4(a0)
    1f20:	00100793          	li	a5,1
    1f24:	40265613          	srai	a2,a2,0x2
    1f28:	00c79633          	sll	a2,a5,a2
    1f2c:	00a66633          	or	a2,a2,a0
    1f30:	00050797          	auipc	a5,0x50
    1f34:	90c7a023          	sw	a2,-1792(a5) # 51830 <__malloc_av_+0x4>
    1f38:	ed9ff06f          	j	1e10 <_free_r+0x198>
    1f3c:	15400613          	li	a2,340
    1f40:	00d66c63          	bltu	a2,a3,1f58 <_free_r+0x2e0>
    1f44:	00f7d693          	srli	a3,a5,0xf
    1f48:	07868593          	addi	a1,a3,120
    1f4c:	07768613          	addi	a2,a3,119
    1f50:	00359593          	slli	a1,a1,0x3
    1f54:	e95ff06f          	j	1de8 <_free_r+0x170>
    1f58:	55400613          	li	a2,1364
    1f5c:	00d66c63          	bltu	a2,a3,1f74 <_free_r+0x2fc>
    1f60:	0127d693          	srli	a3,a5,0x12
    1f64:	07d68593          	addi	a1,a3,125
    1f68:	07c68613          	addi	a2,a3,124
    1f6c:	00359593          	slli	a1,a1,0x3
    1f70:	e79ff06f          	j	1de8 <_free_r+0x170>
    1f74:	3f800593          	li	a1,1016
    1f78:	07e00613          	li	a2,126
    1f7c:	e6dff06f          	j	1de8 <_free_r+0x170>
    1f80:	0017e693          	ori	a3,a5,1
    1f84:	00d72223          	sw	a3,4(a4)
    1f88:	00f62023          	sw	a5,0(a2)
    1f8c:	dd1ff06f          	j	1d5c <_free_r+0xe4>

00001f90 <cleanup_glue>:
    1f90:	ff010113          	addi	sp,sp,-16
    1f94:	00812423          	sw	s0,8(sp)
    1f98:	00058413          	mv	s0,a1
    1f9c:	0005a583          	lw	a1,0(a1)
    1fa0:	00912223          	sw	s1,4(sp)
    1fa4:	00112623          	sw	ra,12(sp)
    1fa8:	00050493          	mv	s1,a0
    1fac:	00058463          	beqz	a1,1fb4 <cleanup_glue+0x24>
    1fb0:	fe1ff0ef          	jal	ra,1f90 <cleanup_glue>
    1fb4:	00040593          	mv	a1,s0
    1fb8:	00812403          	lw	s0,8(sp)
    1fbc:	00c12083          	lw	ra,12(sp)
    1fc0:	00048513          	mv	a0,s1
    1fc4:	00412483          	lw	s1,4(sp)
    1fc8:	01010113          	addi	sp,sp,16
    1fcc:	cadff06f          	j	1c78 <_free_r>

00001fd0 <_reclaim_reent>:
    1fd0:	83418793          	addi	a5,gp,-1996 # 52084 <_impure_ptr>
    1fd4:	0007a783          	lw	a5,0(a5)
    1fd8:	10a78263          	beq	a5,a0,20dc <_reclaim_reent+0x10c>
    1fdc:	04c52703          	lw	a4,76(a0)
    1fe0:	fe010113          	addi	sp,sp,-32
    1fe4:	00912a23          	sw	s1,20(sp)
    1fe8:	00112e23          	sw	ra,28(sp)
    1fec:	00812c23          	sw	s0,24(sp)
    1ff0:	01212823          	sw	s2,16(sp)
    1ff4:	01312623          	sw	s3,12(sp)
    1ff8:	00050493          	mv	s1,a0
    1ffc:	04070263          	beqz	a4,2040 <_reclaim_reent+0x70>
    2000:	00000913          	li	s2,0
    2004:	08000993          	li	s3,128
    2008:	012707b3          	add	a5,a4,s2
    200c:	0007a583          	lw	a1,0(a5)
    2010:	00058e63          	beqz	a1,202c <_reclaim_reent+0x5c>
    2014:	0005a403          	lw	s0,0(a1)
    2018:	00048513          	mv	a0,s1
    201c:	c5dff0ef          	jal	ra,1c78 <_free_r>
    2020:	00040593          	mv	a1,s0
    2024:	fe0418e3          	bnez	s0,2014 <_reclaim_reent+0x44>
    2028:	04c4a703          	lw	a4,76(s1)
    202c:	00490913          	addi	s2,s2,4
    2030:	fd391ce3          	bne	s2,s3,2008 <_reclaim_reent+0x38>
    2034:	00070593          	mv	a1,a4
    2038:	00048513          	mv	a0,s1
    203c:	c3dff0ef          	jal	ra,1c78 <_free_r>
    2040:	0404a583          	lw	a1,64(s1)
    2044:	00058663          	beqz	a1,2050 <_reclaim_reent+0x80>
    2048:	00048513          	mv	a0,s1
    204c:	c2dff0ef          	jal	ra,1c78 <_free_r>
    2050:	1484a583          	lw	a1,328(s1)
    2054:	02058063          	beqz	a1,2074 <_reclaim_reent+0xa4>
    2058:	14c48913          	addi	s2,s1,332
    205c:	01258c63          	beq	a1,s2,2074 <_reclaim_reent+0xa4>
    2060:	0005a403          	lw	s0,0(a1)
    2064:	00048513          	mv	a0,s1
    2068:	c11ff0ef          	jal	ra,1c78 <_free_r>
    206c:	00040593          	mv	a1,s0
    2070:	fe8918e3          	bne	s2,s0,2060 <_reclaim_reent+0x90>
    2074:	0544a583          	lw	a1,84(s1)
    2078:	00058663          	beqz	a1,2084 <_reclaim_reent+0xb4>
    207c:	00048513          	mv	a0,s1
    2080:	bf9ff0ef          	jal	ra,1c78 <_free_r>
    2084:	0384a783          	lw	a5,56(s1)
    2088:	02078c63          	beqz	a5,20c0 <_reclaim_reent+0xf0>
    208c:	03c4a783          	lw	a5,60(s1)
    2090:	00048513          	mv	a0,s1
    2094:	000780e7          	jalr	a5
    2098:	2e04a583          	lw	a1,736(s1)
    209c:	02058263          	beqz	a1,20c0 <_reclaim_reent+0xf0>
    20a0:	01812403          	lw	s0,24(sp)
    20a4:	01c12083          	lw	ra,28(sp)
    20a8:	01012903          	lw	s2,16(sp)
    20ac:	00c12983          	lw	s3,12(sp)
    20b0:	00048513          	mv	a0,s1
    20b4:	01412483          	lw	s1,20(sp)
    20b8:	02010113          	addi	sp,sp,32
    20bc:	ed5ff06f          	j	1f90 <cleanup_glue>
    20c0:	01c12083          	lw	ra,28(sp)
    20c4:	01812403          	lw	s0,24(sp)
    20c8:	01412483          	lw	s1,20(sp)
    20cc:	01012903          	lw	s2,16(sp)
    20d0:	00c12983          	lw	s3,12(sp)
    20d4:	02010113          	addi	sp,sp,32
    20d8:	00008067          	ret
    20dc:	00008067          	ret

000020e0 <clint_uDelay>:
*          and the time limit is non-negative, indicating that the delay has
*          not yet elapsed.
*
******************************************************************************/
    static void clint_uDelay(u32 usec, u32 hz, u32 reg){
        u32 mTimePerUsec = hz/1000000;
    20e0:	000f47b7          	lui	a5,0xf4
    20e4:	24078793          	addi	a5,a5,576 # f4240 <__freertos_irq_stack_top+0xa07d0>
    20e8:	02f5d5b3          	divu	a1,a1,a5
    readReg_u32 (clint_getTimeLow , CLINT_TIME_ADDR)
    20ec:	0000c7b7          	lui	a5,0xc
    20f0:	ff878793          	addi	a5,a5,-8 # bff8 <raw_table4+0x26bc>
    20f4:	00f60633          	add	a2,a2,a5
#include "type.h"
#include "soc.h"


    static inline u32 read_u32(u32 address){
        return *((volatile u32*) address);
    20f8:	00062783          	lw	a5,0(a2)
        u32 limit = clint_getTimeLow(reg) + usec*mTimePerUsec;
    20fc:	02a58533          	mul	a0,a1,a0
    2100:	00f50533          	add	a0,a0,a5
    2104:	00062783          	lw	a5,0(a2)
        while((int32_t)(limit-(clint_getTimeLow(reg))) >= 0);
    2108:	40f507b3          	sub	a5,a0,a5
    210c:	fe07dce3          	bgez	a5,2104 <clint_uDelay+0x24>
    2110:	00008067          	ret

00002114 <sd_ctrl_get_cd>:
}

int sd_ctrl_get_cd(struct mmc *mmc)
{
	return 1;
}
    2114:	00100513          	li	a0,1
    2118:	00008067          	ret

0000211c <sd_ctrl_get_wp>:

int sd_ctrl_get_wp(struct mmc *mmc)
{
	return 0;
}
    211c:	00000513          	li	a0,0
    2120:	00008067          	ret

00002124 <sd_ctrl_write>:
	write_u32(data,dev->base_addr+offset);
    2124:	00052783          	lw	a5,0(a0)
    2128:	00b785b3          	add	a1,a5,a1
    }
    
    static inline void write_u32(u32 data, u32 address){
        *((volatile u32*) address) = data;
    212c:	00c5a023          	sw	a2,0(a1)
}
    2130:	00008067          	ret

00002134 <sd_ctrl_read>:
	return read_u32(dev->base_addr+offset);
    2134:	00052783          	lw	a5,0(a0)
    2138:	00b785b3          	add	a1,a5,a1
        return *((volatile u32*) address);
    213c:	0005a503          	lw	a0,0(a1)
}
    2140:	00008067          	ret

00002144 <sd_ctrl_cmd>:
{
    2144:	fe010113          	addi	sp,sp,-32
    2148:	00112e23          	sw	ra,28(sp)
    214c:	00812c23          	sw	s0,24(sp)
    2150:	00912a23          	sw	s1,20(sp)
    2154:	01212823          	sw	s2,16(sp)
    2158:	01312623          	sw	s3,12(sp)
    215c:	00050913          	mv	s2,a0
    2160:	00058493          	mv	s1,a1
	struct sd_ctrl_dev *dev = mmc->priv;
    2164:	00852403          	lw	s0,8(a0)
	sd_ctrl_write(dev,SDHC_ADDR+REG_ARGUMENT1,cmd->cmdarg);
    2168:	0085a603          	lw	a2,8(a1)
    216c:	10800593          	li	a1,264
    2170:	00040513          	mv	a0,s0
    2174:	fb1ff0ef          	jal	ra,2124 <sd_ctrl_write>
	Value |= (dev->TransModePtr->dma_enable&0x1)<<0;
    2178:	01442683          	lw	a3,20(s0)
    217c:	0006a703          	lw	a4,0(a3)
    2180:	00177713          	andi	a4,a4,1
	Value |= (dev->TransModePtr->block_count_enable&0x1)<<1;
    2184:	0046a783          	lw	a5,4(a3)
    2188:	00179793          	slli	a5,a5,0x1
    218c:	0027f793          	andi	a5,a5,2
    2190:	00f767b3          	or	a5,a4,a5
	Value |= (dev->TransModePtr->auto_cmd_enable&0x3)<<2;
    2194:	0086a703          	lw	a4,8(a3)
    2198:	00271713          	slli	a4,a4,0x2
    219c:	00c77713          	andi	a4,a4,12
    21a0:	00f76733          	or	a4,a4,a5
	Value |= (dev->TransModePtr->data_transfer_direction_select&0x1)<<4;
    21a4:	00c6a783          	lw	a5,12(a3)
    21a8:	00479793          	slli	a5,a5,0x4
    21ac:	0107f793          	andi	a5,a5,16
    21b0:	00e7e733          	or	a4,a5,a4
	Value |= (dev->TransModePtr->multi_or_single_block_select&0x1)<<5;
    21b4:	0106a783          	lw	a5,16(a3)
    21b8:	00579793          	slli	a5,a5,0x5
    21bc:	0207f793          	andi	a5,a5,32
    21c0:	00e7e7b3          	or	a5,a5,a4
	if(cmd->resp_type & MMC_RSP_PRESENT)
    21c4:	0044a703          	lw	a4,4(s1)
    21c8:	00177693          	andi	a3,a4,1
    21cc:	02068a63          	beqz	a3,2200 <sd_ctrl_cmd+0xbc>
			 if(cmd->resp_type & MMC_RSP_BUSY)		Value |= 0x03<<16;
    21d0:	00877693          	andi	a3,a4,8
    21d4:	06068e63          	beqz	a3,2250 <sd_ctrl_cmd+0x10c>
    21d8:	000306b7          	lui	a3,0x30
    21dc:	00d7e7b3          	or	a5,a5,a3
		if(cmd->resp_type & MMC_RSP_CRC)			Value |= 0x01<<19;
    21e0:	00477693          	andi	a3,a4,4
    21e4:	00068663          	beqz	a3,21f0 <sd_ctrl_cmd+0xac>
    21e8:	000806b7          	lui	a3,0x80
    21ec:	00d7e7b3          	or	a5,a5,a3
		if(cmd->resp_type & MMC_RSP_OPCODE)			Value |= 0x01<<20;
    21f0:	01077713          	andi	a4,a4,16
    21f4:	00070663          	beqz	a4,2200 <sd_ctrl_cmd+0xbc>
    21f8:	00100737          	lui	a4,0x100
    21fc:	00e7e7b3          	or	a5,a5,a4
	if(dev->app_cmd)
    2200:	01042703          	lw	a4,16(s0)
    2204:	06070c63          	beqz	a4,227c <sd_ctrl_cmd+0x138>
		if(cmd->cmdidx ==SD_CMD_APP_SEND_SCR)	//ACMD51
    2208:	0004d683          	lhu	a3,0(s1)
    220c:	03300713          	li	a4,51
    2210:	06e68063          	beq	a3,a4,2270 <sd_ctrl_cmd+0x12c>
	Value |= (cmd->cmdidx&0x3f)<<24;
    2214:	0004d983          	lhu	s3,0(s1)
    2218:	01899993          	slli	s3,s3,0x18
    221c:	3f000737          	lui	a4,0x3f000
    2220:	00e9f9b3          	and	s3,s3,a4
    2224:	0137e9b3          	or	s3,a5,s3
    2228:	f81207b7          	lui	a5,0xf8120
    222c:	0087a783          	lw	a5,8(a5) # f8120008 <__freertos_irq_stack_top+0xf80cc598>
	while(read_u32(PROBE_ADDR+0x008)&0x1) {
    2230:	0017f793          	andi	a5,a5,1
    2234:	0c078063          	beqz	a5,22f4 <sd_ctrl_cmd+0x1b0>
		bsp_uDelay(1);
    2238:	f8b00637          	lui	a2,0xf8b00
    223c:	05f5e5b7          	lui	a1,0x5f5e
    2240:	10058593          	addi	a1,a1,256 # 5f5e100 <__freertos_irq_stack_top+0x5f0a690>
    2244:	00100513          	li	a0,1
    2248:	e99ff0ef          	jal	ra,20e0 <clint_uDelay>
    224c:	fddff06f          	j	2228 <sd_ctrl_cmd+0xe4>
		else if(cmd->resp_type & MMC_RSP_136)		Value |= 0x01<<16;
    2250:	00277693          	andi	a3,a4,2
    2254:	00068863          	beqz	a3,2264 <sd_ctrl_cmd+0x120>
    2258:	000106b7          	lui	a3,0x10
    225c:	00d7e7b3          	or	a5,a5,a3
    2260:	f81ff06f          	j	21e0 <sd_ctrl_cmd+0x9c>
		else										Value |= 0x02<<16;
    2264:	000206b7          	lui	a3,0x20
    2268:	00d7e7b3          	or	a5,a5,a3
    226c:	f75ff06f          	j	21e0 <sd_ctrl_cmd+0x9c>
			Value |= 0x1<<21;
    2270:	00200737          	lui	a4,0x200
    2274:	00e7e7b3          	or	a5,a5,a4
    2278:	f9dff06f          	j	2214 <sd_ctrl_cmd+0xd0>
		switch(cmd->cmdidx){
    227c:	0004d703          	lhu	a4,0(s1)
    2280:	ffa70713          	addi	a4,a4,-6 # 1ffffa <__freertos_irq_stack_top+0x1ac58a>
    2284:	01071613          	slli	a2,a4,0x10
    2288:	01065613          	srli	a2,a2,0x10
    228c:	01300693          	li	a3,19
    2290:	f8c6e2e3          	bltu	a3,a2,2214 <sd_ctrl_cmd+0xd0>
    2294:	00261713          	slli	a4,a2,0x2
    2298:	000096b7          	lui	a3,0x9
    229c:	a1868693          	addi	a3,a3,-1512 # 8a18 <_data+0x4>
    22a0:	00d70733          	add	a4,a4,a3
    22a4:	00072703          	lw	a4,0(a4)
    22a8:	00070067          	jr	a4
		case MMC_CMD_SWITCH:				Value |= 0x1<<21; break;	//CMD6
    22ac:	00200737          	lui	a4,0x200
    22b0:	00e7e7b3          	or	a5,a5,a4
    22b4:	f61ff06f          	j	2214 <sd_ctrl_cmd+0xd0>
		case MMC_CMD_READ_SINGLE_BLOCK:		Value |= 0x1<<21; break;	//CMD17
    22b8:	00200737          	lui	a4,0x200
    22bc:	00e7e7b3          	or	a5,a5,a4
    22c0:	f55ff06f          	j	2214 <sd_ctrl_cmd+0xd0>
		case MMC_CMD_READ_MULTIPLE_BLOCK:	Value |= 0x1<<21; break;	//CMD18
    22c4:	00200737          	lui	a4,0x200
    22c8:	00e7e7b3          	or	a5,a5,a4
    22cc:	f49ff06f          	j	2214 <sd_ctrl_cmd+0xd0>
		case MMC_CMD_SEND_TUNING_BLOCK:		Value |= 0x1<<21; break;	//CMD19
    22d0:	00200737          	lui	a4,0x200
    22d4:	00e7e7b3          	or	a5,a5,a4
    22d8:	f3dff06f          	j	2214 <sd_ctrl_cmd+0xd0>
		case MMC_CMD_WRITE_SINGLE_BLOCK:	Value |= 0x1<<21; break;	//CMD24
    22dc:	00200737          	lui	a4,0x200
    22e0:	00e7e7b3          	or	a5,a5,a4
    22e4:	f31ff06f          	j	2214 <sd_ctrl_cmd+0xd0>
		case MMC_CMD_WRITE_MULTIPLE_BLOCK:	Value |= 0x1<<21; break;	//CMD25
    22e8:	00200737          	lui	a4,0x200
    22ec:	00e7e7b3          	or	a5,a5,a4
    22f0:	f25ff06f          	j	2214 <sd_ctrl_cmd+0xd0>
	sd_ctrl_write(dev,SDHC_ADDR+REG_TRANFER_MODE,Value);
    22f4:	00098613          	mv	a2,s3
    22f8:	10c00593          	li	a1,268
    22fc:	00040513          	mv	a0,s0
    2300:	e25ff0ef          	jal	ra,2124 <sd_ctrl_write>
	bsp_uDelay(100);
    2304:	f8b00637          	lui	a2,0xf8b00
    2308:	05f5e5b7          	lui	a1,0x5f5e
    230c:	10058593          	addi	a1,a1,256 # 5f5e100 <__freertos_irq_stack_top+0x5f0a690>
    2310:	06400513          	li	a0,100
    2314:	dcdff0ef          	jal	ra,20e0 <clint_uDelay>
		if(IntPtr.command_complete == 0x1) {
    2318:	bd41a703          	lw	a4,-1068(gp) # 52424 <IntPtr>
    231c:	00100793          	li	a5,1
    2320:	fef71ce3          	bne	a4,a5,2318 <sd_ctrl_cmd+0x1d4>
			IntPtr.command_complete = 0x0;
    2324:	bd418793          	addi	a5,gp,-1068 # 52424 <IntPtr>
    2328:	0007a023          	sw	zero,0(a5)
			if((IntPtr.command_timeout_error == 0x0) && (IntPtr.command_crc_error == 0x0) &&
    232c:	01c7a783          	lw	a5,28(a5)
    2330:	0a079263          	bnez	a5,23d4 <sd_ctrl_cmd+0x290>
    2334:	bd418793          	addi	a5,gp,-1068 # 52424 <IntPtr>
    2338:	0207a783          	lw	a5,32(a5)
    233c:	08079c63          	bnez	a5,23d4 <sd_ctrl_cmd+0x290>
			   (IntPtr.command_end_bit_error == 0x0) && (IntPtr.command_index_error == 0x0))  {
    2340:	bd418793          	addi	a5,gp,-1068 # 52424 <IntPtr>
    2344:	0247a783          	lw	a5,36(a5)
			if((IntPtr.command_timeout_error == 0x0) && (IntPtr.command_crc_error == 0x0) &&
    2348:	08079663          	bnez	a5,23d4 <sd_ctrl_cmd+0x290>
			   (IntPtr.command_end_bit_error == 0x0) && (IntPtr.command_index_error == 0x0))  {
    234c:	bd418793          	addi	a5,gp,-1068 # 52424 <IntPtr>
    2350:	0287a783          	lw	a5,40(a5)
    2354:	08079063          	bnez	a5,23d4 <sd_ctrl_cmd+0x290>
				if((cmd->resp_type&0xf) == 0x0) {//No Response
    2358:	0044a783          	lw	a5,4(s1)
    235c:	00f7f713          	andi	a4,a5,15
    2360:	08070463          	beqz	a4,23e8 <sd_ctrl_cmd+0x2a4>
				} else if(cmd->resp_type & MMC_RSP_136) {//Response Length 136
    2364:	0027f793          	andi	a5,a5,2
    2368:	04078463          	beqz	a5,23b0 <sd_ctrl_cmd+0x26c>
					cmd->response[0] = sd_ctrl_read(dev,SDHC_ADDR+REG_COMMAND_RESP31_0);//cmd_resp[31:0]
    236c:	11000593          	li	a1,272
    2370:	00040513          	mv	a0,s0
    2374:	dc1ff0ef          	jal	ra,2134 <sd_ctrl_read>
    2378:	00a4a623          	sw	a0,12(s1)
					cmd->response[1] = sd_ctrl_read(dev,SDHC_ADDR+REG_COMMAND_RESP63_32);//cmd_resp[63:32]
    237c:	11400593          	li	a1,276
    2380:	00040513          	mv	a0,s0
    2384:	db1ff0ef          	jal	ra,2134 <sd_ctrl_read>
    2388:	00a4a823          	sw	a0,16(s1)
					cmd->response[2] = sd_ctrl_read(dev,SDHC_ADDR+REG_COMMAND_RESP95_64);//cmd_resp[95:64]
    238c:	11800593          	li	a1,280
    2390:	00040513          	mv	a0,s0
    2394:	da1ff0ef          	jal	ra,2134 <sd_ctrl_read>
    2398:	00a4aa23          	sw	a0,20(s1)
					cmd->response[3] = sd_ctrl_read(dev,SDHC_ADDR+REG_COMMAND_RESP127_96);//cmd_resp[127:96]
    239c:	11c00593          	li	a1,284
    23a0:	00040513          	mv	a0,s0
    23a4:	d91ff0ef          	jal	ra,2134 <sd_ctrl_read>
    23a8:	00a4ac23          	sw	a0,24(s1)
    23ac:	03c0006f          	j	23e8 <sd_ctrl_cmd+0x2a4>
					cmd->response[0] = sd_ctrl_read(dev,SDHC_ADDR+REG_COMMAND_RESP31_0);//cmd_resp[31:0]
    23b0:	11000593          	li	a1,272
    23b4:	00040513          	mv	a0,s0
    23b8:	d7dff0ef          	jal	ra,2134 <sd_ctrl_read>
    23bc:	00a4a623          	sw	a0,12(s1)
					cmd->response[1] = sd_ctrl_read(dev,SDHC_ADDR+REG_COMMAND_RESP63_32);//cmd_resp[63:32]
    23c0:	11400593          	li	a1,276
    23c4:	00040513          	mv	a0,s0
    23c8:	d6dff0ef          	jal	ra,2134 <sd_ctrl_read>
    23cc:	00a4a823          	sw	a0,16(s1)
    23d0:	0180006f          	j	23e8 <sd_ctrl_cmd+0x2a4>
				IntPtr.command_timeout_error = 0x0;
    23d4:	bd418793          	addi	a5,gp,-1068 # 52424 <IntPtr>
    23d8:	0007ae23          	sw	zero,28(a5)
				IntPtr.command_crc_error = 0x0;
    23dc:	0207a023          	sw	zero,32(a5)
				IntPtr.command_end_bit_error = 0x0;
    23e0:	0207a223          	sw	zero,36(a5)
				IntPtr.command_index_error = 0x0;
    23e4:	0207a423          	sw	zero,40(a5)
	if(cmd->cmdidx == MMC_CMD_APP_CMD)
    23e8:	0004d703          	lhu	a4,0(s1)
    23ec:	03700793          	li	a5,55
    23f0:	02f70663          	beq	a4,a5,241c <sd_ctrl_cmd+0x2d8>
		dev->app_cmd =0;
    23f4:	00042823          	sw	zero,16(s0)
	mmc->priv = dev;
    23f8:	00892423          	sw	s0,8(s2)
}
    23fc:	00000513          	li	a0,0
    2400:	01c12083          	lw	ra,28(sp)
    2404:	01812403          	lw	s0,24(sp)
    2408:	01412483          	lw	s1,20(sp)
    240c:	01012903          	lw	s2,16(sp)
    2410:	00c12983          	lw	s3,12(sp)
    2414:	02010113          	addi	sp,sp,32
    2418:	00008067          	ret
		dev->app_cmd =1;
    241c:	00100793          	li	a5,1
    2420:	00f42823          	sw	a5,16(s0)
    2424:	fd5ff06f          	j	23f8 <sd_ctrl_cmd+0x2b4>

00002428 <sd_ctrl_creat_Descriptor>:
{
    2428:	fe010113          	addi	sp,sp,-32
    242c:	00112e23          	sw	ra,28(sp)
    2430:	00812c23          	sw	s0,24(sp)
    2434:	00912a23          	sw	s1,20(sp)
    2438:	01212823          	sw	s2,16(sp)
    243c:	01312623          	sw	s3,12(sp)
    2440:	00058913          	mv	s2,a1
    2444:	00060993          	mv	s3,a2
    2448:	00068413          	mv	s0,a3
	struct sd_ctrl_dev *dev = mmc->priv;
    244c:	00852483          	lw	s1,8(a0)
	memset(Descriptor,0,sizeof(Descriptor));
    2450:	10000613          	li	a2,256
    2454:	00000593          	li	a1,0
    2458:	abc18513          	addi	a0,gp,-1348 # 5230c <Descriptor>
    245c:	d4cff0ef          	jal	ra,19a8 <memset>
	memset(DataDescriptor,0,sizeof(DataDescriptor));
    2460:	10000613          	li	a2,256
    2464:	00000593          	li	a1,0
    2468:	9bc18513          	addi	a0,gp,-1604 # 5220c <DataDescriptor>
    246c:	d3cff0ef          	jal	ra,19a8 <memset>
	memset(AttributeDescriptor,0,sizeof(AttributeDescriptor));
    2470:	10000613          	li	a2,256
    2474:	00000593          	li	a1,0
    2478:	00052537          	lui	a0,0x52
    247c:	10c50513          	addi	a0,a0,268 # 5210c <AttributeDescriptor>
    2480:	d28ff0ef          	jal	ra,19a8 <memset>
	lenght = block_size*blocks;
    2484:	03298633          	mul	a2,s3,s2
	line=(lenght/MAX_DESCRIPTOR);
    2488:	01065313          	srli	t1,a2,0x10
	if(lenght%MAX_DESCRIPTOR) line++;
    248c:	01061793          	slli	a5,a2,0x10
    2490:	0107d793          	srli	a5,a5,0x10
    2494:	00078463          	beqz	a5,249c <sd_ctrl_creat_Descriptor+0x74>
    2498:	00130313          	addi	t1,t1,1
	for(n=0;n<line;n++)
    249c:	00000693          	li	a3,0
    24a0:	06c0006f          	j	250c <sd_ctrl_creat_Descriptor+0xe4>
			Value |= (MAX_DESCRIPTOR&0xffff) <<16;
    24a4:	00000593          	li	a1,0
		if(n==(line-1))
    24a8:	fff30793          	addi	a5,t1,-1
    24ac:	06d78a63          	beq	a5,a3,2520 <sd_ctrl_creat_Descriptor+0xf8>
			Value |= 0x21;
    24b0:	0215e593          	ori	a1,a1,33
		DataDescriptor[n]=((u32)Descriptor)+(sizeof(u32)*2*n);
    24b4:	00369793          	slli	a5,a3,0x3
    24b8:	abc18713          	addi	a4,gp,-1348 # 5230c <Descriptor>
    24bc:	00e788b3          	add	a7,a5,a4
    24c0:	00269813          	slli	a6,a3,0x2
    24c4:	9bc18513          	addi	a0,gp,-1604 # 5220c <DataDescriptor>
    24c8:	01050533          	add	a0,a0,a6
    24cc:	01152023          	sw	a7,0(a0)
        *((volatile u32*) address) = data;
    24d0:	00b8a023          	sw	a1,0(a7)
		AttributeDescriptor[n]=((u32)Descriptor)+sizeof(u32)+(sizeof(u32)*2*n);
    24d4:	00470713          	addi	a4,a4,4 # 200004 <__freertos_irq_stack_top+0x1ac594>
    24d8:	00f707b3          	add	a5,a4,a5
    24dc:	00052737          	lui	a4,0x52
    24e0:	10c70713          	addi	a4,a4,268 # 5210c <AttributeDescriptor>
    24e4:	01070733          	add	a4,a4,a6
    24e8:	00f72023          	sw	a5,0(a4)
		addr_location=((u32)src+(n*MAX_DESCRIPTOR)) & 0xFFFFFFFF;
    24ec:	01069713          	slli	a4,a3,0x10
    24f0:	00870733          	add	a4,a4,s0
    24f4:	00e7a023          	sw	a4,0(a5)
		if (lenght > MAX_DESCRIPTOR)
    24f8:	000107b7          	lui	a5,0x10
    24fc:	00c7f663          	bgeu	a5,a2,2508 <sd_ctrl_creat_Descriptor+0xe0>
			lenght = lenght - MAX_DESCRIPTOR;
    2500:	ffff07b7          	lui	a5,0xffff0
    2504:	00f60633          	add	a2,a2,a5
	for(n=0;n<line;n++)
    2508:	00168693          	addi	a3,a3,1
    250c:	0066fe63          	bgeu	a3,t1,2528 <sd_ctrl_creat_Descriptor+0x100>
		if(lenght > MAX_DESCRIPTOR)
    2510:	000107b7          	lui	a5,0x10
    2514:	f8c7e8e3          	bltu	a5,a2,24a4 <sd_ctrl_creat_Descriptor+0x7c>
			Value |= (lenght&0xffff)<<16;
    2518:	01061593          	slli	a1,a2,0x10
    251c:	f8dff06f          	j	24a8 <sd_ctrl_creat_Descriptor+0x80>
			Value |= 0x23;
    2520:	0235e593          	ori	a1,a1,35
    2524:	f91ff06f          	j	24b4 <sd_ctrl_creat_Descriptor+0x8c>
	sd_ctrl_write(dev,SDHC_ADDR+REG_ADMA_SYSTEM_ADDR0,DataDescriptor[0]);//sdhc_reg - adma_system_address[31:0]
    2528:	9bc1a603          	lw	a2,-1604(gp) # 5220c <DataDescriptor>
    252c:	15800593          	li	a1,344
    2530:	00048513          	mv	a0,s1
    2534:	bf1ff0ef          	jal	ra,2124 <sd_ctrl_write>
}
    2538:	00000513          	li	a0,0
    253c:	01c12083          	lw	ra,28(sp)
    2540:	01812403          	lw	s0,24(sp)
    2544:	01412483          	lw	s1,20(sp)
    2548:	01012903          	lw	s2,16(sp)
    254c:	00c12983          	lw	s3,12(sp)
    2550:	02010113          	addi	sp,sp,32
    2554:	00008067          	ret

00002558 <sd_ctrl_data>:
{
    2558:	fe010113          	addi	sp,sp,-32
    255c:	00112e23          	sw	ra,28(sp)
    2560:	00812c23          	sw	s0,24(sp)
    2564:	00912a23          	sw	s1,20(sp)
    2568:	01212823          	sw	s2,16(sp)
    256c:	01312623          	sw	s3,12(sp)
    2570:	01412423          	sw	s4,8(sp)
    2574:	00050413          	mv	s0,a0
    2578:	00058913          	mv	s2,a1
    257c:	00060493          	mv	s1,a2
	struct sd_ctrl_dev *dev =mmc->priv;
    2580:	00852983          	lw	s3,8(a0)
	dev->TransModePtr->dma_enable = 0x0;
    2584:	0149a783          	lw	a5,20(s3)
    2588:	0007a023          	sw	zero,0(a5) # 10000 <raw_table4+0x66c4>
	if(data->blocks == 0x1) {
    258c:	00862703          	lw	a4,8(a2) # f8b00008 <__freertos_irq_stack_top+0xf8aac598>
    2590:	00100793          	li	a5,1
    2594:	06f70663          	beq	a4,a5,2600 <sd_ctrl_data+0xa8>
		dev->TransModePtr->auto_cmd_enable = 0x1;
    2598:	0149a783          	lw	a5,20(s3)
    259c:	00100713          	li	a4,1
    25a0:	00e7a423          	sw	a4,8(a5)
	if(data->flags==MMC_DATA_WRITE)
    25a4:	0044a703          	lw	a4,4(s1)
    25a8:	00200793          	li	a5,2
    25ac:	06f70063          	beq	a4,a5,260c <sd_ctrl_data+0xb4>
		dev->TransModePtr->data_transfer_direction_select = 0x1;
    25b0:	0149a783          	lw	a5,20(s3)
    25b4:	00100713          	li	a4,1
    25b8:	00e7a623          	sw	a4,12(a5)
	mmc->priv = dev;
    25bc:	01342423          	sw	s3,8(s0)
		sd_ctrl_write(dev,SDHC_ADDR+REG_BLOCKSIZE_COUNT,((data->blocks&0xffff)<<16) | data->blocksize);//sdhc_reg - Block Size & Block Count Register
    25c0:	0084a783          	lw	a5,8(s1)
    25c4:	01079793          	slli	a5,a5,0x10
    25c8:	00c4a603          	lw	a2,12(s1)
    25cc:	00c7e633          	or	a2,a5,a2
    25d0:	10400593          	li	a1,260
    25d4:	00098513          	mv	a0,s3
    25d8:	b4dff0ef          	jal	ra,2124 <sd_ctrl_write>
		sd_ctrl_cmd(mmc,cmd);
    25dc:	00090593          	mv	a1,s2
    25e0:	00040513          	mv	a0,s0
    25e4:	b61ff0ef          	jal	ra,2144 <sd_ctrl_cmd>
	if(data->flags==MMC_DATA_WRITE)
    25e8:	0044a703          	lw	a4,4(s1)
    25ec:	00200793          	li	a5,2
    25f0:	0af70c63          	beq	a4,a5,26a8 <sd_ctrl_data+0x150>
		for(int i=0; i<data->blocks; i++) {
    25f4:	00000a13          	li	s4,0
	u32 buf=0,tmp=0;
    25f8:	00000413          	li	s0,0
    25fc:	13c0006f          	j	2738 <sd_ctrl_data+0x1e0>
		dev->TransModePtr->auto_cmd_enable = 0x0;
    2600:	0149a783          	lw	a5,20(s3)
    2604:	0007a423          	sw	zero,8(a5)
    2608:	f9dff06f          	j	25a4 <sd_ctrl_data+0x4c>
		dev->TransModePtr->data_transfer_direction_select = 0x0;
    260c:	0149a783          	lw	a5,20(s3)
    2610:	0007a623          	sw	zero,12(a5)
    2614:	fa9ff06f          	j	25bc <sd_ctrl_data+0x64>
				buf = data->src[tmp++];
    2618:	0004a783          	lw	a5,0(s1)
    261c:	00140693          	addi	a3,s0,1
    2620:	00878733          	add	a4,a5,s0
    2624:	00074703          	lbu	a4,0(a4)
				buf |= data->src[tmp++]<<8;
    2628:	00240613          	addi	a2,s0,2
    262c:	00d786b3          	add	a3,a5,a3
    2630:	0006c683          	lbu	a3,0(a3)
    2634:	00869693          	slli	a3,a3,0x8
    2638:	00d76733          	or	a4,a4,a3
				buf |= data->src[tmp++]<<16;
    263c:	00340693          	addi	a3,s0,3
    2640:	00c78633          	add	a2,a5,a2
    2644:	00064603          	lbu	a2,0(a2)
    2648:	01061613          	slli	a2,a2,0x10
    264c:	00c76733          	or	a4,a4,a2
				buf |= data->src[tmp++]<<24;
    2650:	00d787b3          	add	a5,a5,a3
    2654:	00440413          	addi	s0,s0,4
    2658:	0007c603          	lbu	a2,0(a5)
    265c:	01861613          	slli	a2,a2,0x18
				sd_ctrl_write(dev,SDHC_ADDR+REG_BUFFER_DATA,buf);//sdhc_reg - buffer_data_port Register
    2660:	00c76633          	or	a2,a4,a2
    2664:	12000593          	li	a1,288
    2668:	00098513          	mv	a0,s3
    266c:	ab9ff0ef          	jal	ra,2124 <sd_ctrl_write>
			for(int j=0; j<((data->blocksize)/4); j++) {
    2670:	00190913          	addi	s2,s2,1
    2674:	00c4a783          	lw	a5,12(s1)
    2678:	0027d793          	srli	a5,a5,0x2
    267c:	f8f96ee3          	bltu	s2,a5,2618 <sd_ctrl_data+0xc0>
		for(int i=0; i<(data->blocks); i++) {
    2680:	001a0a13          	addi	s4,s4,1
    2684:	0084a783          	lw	a5,8(s1)
    2688:	0efa7663          	bgeu	s4,a5,2774 <sd_ctrl_data+0x21c>
				if(sd_ctrl_read(dev,SDHC_ADDR+REG_PRESENT_STATE)&0x400) {
    268c:	12400593          	li	a1,292
    2690:	00098513          	mv	a0,s3
    2694:	aa1ff0ef          	jal	ra,2134 <sd_ctrl_read>
    2698:	40057513          	andi	a0,a0,1024
    269c:	fe0508e3          	beqz	a0,268c <sd_ctrl_data+0x134>
			for(int j=0; j<((data->blocksize)/4); j++) {
    26a0:	00000913          	li	s2,0
    26a4:	fd1ff06f          	j	2674 <sd_ctrl_data+0x11c>
		for(int i=0; i<(data->blocks); i++) {
    26a8:	00000a13          	li	s4,0
	u32 buf=0,tmp=0;
    26ac:	00000413          	li	s0,0
    26b0:	fd5ff06f          	j	2684 <sd_ctrl_data+0x12c>
			for(int j=0; j<(BLOCK_SIZE/4); j++) {
    26b4:	00000913          	li	s2,0
    26b8:	07f00793          	li	a5,127
    26bc:	0727cc63          	blt	a5,s2,2734 <sd_ctrl_data+0x1dc>
				buf = sd_ctrl_read(dev,SDHC_ADDR+REG_BUFFER_DATA);
    26c0:	12000593          	li	a1,288
    26c4:	00098513          	mv	a0,s3
    26c8:	a6dff0ef          	jal	ra,2134 <sd_ctrl_read>
				data->dest[tmp++]=buf & 0xFF;
    26cc:	0004a703          	lw	a4,0(s1)
    26d0:	00140693          	addi	a3,s0,1
    26d4:	00870733          	add	a4,a4,s0
    26d8:	00a70023          	sb	a0,0(a4)
				data->dest[tmp++]=(buf>>8) & 0xFF;
    26dc:	00855713          	srli	a4,a0,0x8
    26e0:	0004a783          	lw	a5,0(s1)
    26e4:	00240613          	addi	a2,s0,2
    26e8:	00d787b3          	add	a5,a5,a3
    26ec:	00e78023          	sb	a4,0(a5)
				data->dest[tmp++]=(buf>>16) & 0xFF;
    26f0:	01055693          	srli	a3,a0,0x10
    26f4:	0004a703          	lw	a4,0(s1)
    26f8:	00340793          	addi	a5,s0,3
    26fc:	00c70733          	add	a4,a4,a2
    2700:	00d70023          	sb	a3,0(a4)
				data->dest[tmp++]=(buf>>24) & 0xFF;
    2704:	01855513          	srli	a0,a0,0x18
    2708:	0004a703          	lw	a4,0(s1)
    270c:	00f707b3          	add	a5,a4,a5
    2710:	00440413          	addi	s0,s0,4
    2714:	00a78023          	sb	a0,0(a5)
				bsp_uDelay(1);//Must ensure that the read rate is lower than the SD clock rate.
    2718:	f8b00637          	lui	a2,0xf8b00
    271c:	05f5e5b7          	lui	a1,0x5f5e
    2720:	10058593          	addi	a1,a1,256 # 5f5e100 <__freertos_irq_stack_top+0x5f0a690>
    2724:	00100513          	li	a0,1
    2728:	9b9ff0ef          	jal	ra,20e0 <clint_uDelay>
			for(int j=0; j<(BLOCK_SIZE/4); j++) {
    272c:	00190913          	addi	s2,s2,1
    2730:	f89ff06f          	j	26b8 <sd_ctrl_data+0x160>
		for(int i=0; i<data->blocks; i++) {
    2734:	001a0a13          	addi	s4,s4,1
    2738:	0084a783          	lw	a5,8(s1)
    273c:	02fa7c63          	bgeu	s4,a5,2774 <sd_ctrl_data+0x21c>
				if(sd_ctrl_read(dev,SDHC_ADDR+REG_PRESENT_STATE)&0x800) {
    2740:	12400593          	li	a1,292
    2744:	00098513          	mv	a0,s3
    2748:	9edff0ef          	jal	ra,2134 <sd_ctrl_read>
    274c:	000017b7          	lui	a5,0x1
    2750:	80078793          	addi	a5,a5,-2048 # 800 <CUSTOM2+0x7a5>
    2754:	00f57533          	and	a0,a0,a5
    2758:	f4051ee3          	bnez	a0,26b4 <sd_ctrl_data+0x15c>
				bsp_uDelay(1);
    275c:	f8b00637          	lui	a2,0xf8b00
    2760:	05f5e5b7          	lui	a1,0x5f5e
    2764:	10058593          	addi	a1,a1,256 # 5f5e100 <__freertos_irq_stack_top+0x5f0a690>
    2768:	00100513          	li	a0,1
    276c:	975ff0ef          	jal	ra,20e0 <clint_uDelay>
				if(sd_ctrl_read(dev,SDHC_ADDR+REG_PRESENT_STATE)&0x800) {
    2770:	fd1ff06f          	j	2740 <sd_ctrl_data+0x1e8>
		if(IntPtr.transfer_complete == 0x1) {
    2774:	bd418793          	addi	a5,gp,-1068 # 52424 <IntPtr>
    2778:	0047a703          	lw	a4,4(a5)
    277c:	00100793          	li	a5,1
    2780:	fef71ae3          	bne	a4,a5,2774 <sd_ctrl_data+0x21c>
			IntPtr.transfer_complete = 0x0;
    2784:	bd418793          	addi	a5,gp,-1068 # 52424 <IntPtr>
    2788:	0007a223          	sw	zero,4(a5)
}
    278c:	00000513          	li	a0,0
    2790:	01c12083          	lw	ra,28(sp)
    2794:	01812403          	lw	s0,24(sp)
    2798:	01412483          	lw	s1,20(sp)
    279c:	01012903          	lw	s2,16(sp)
    27a0:	00c12983          	lw	s3,12(sp)
    27a4:	00812a03          	lw	s4,8(sp)
    27a8:	02010113          	addi	sp,sp,32
    27ac:	00008067          	ret

000027b0 <sd_ctrl_check_read_write>:
		 if(cmd->cmdidx== MMC_CMD_READ_SINGLE_BLOCK)	return 1;
    27b0:	00055783          	lhu	a5,0(a0)
    27b4:	01100713          	li	a4,17
    27b8:	02e78663          	beq	a5,a4,27e4 <sd_ctrl_check_read_write+0x34>
	else if(cmd->cmdidx== MMC_CMD_READ_MULTIPLE_BLOCK)	return 1;
    27bc:	01200713          	li	a4,18
    27c0:	02e78663          	beq	a5,a4,27ec <sd_ctrl_check_read_write+0x3c>
	else if(cmd->cmdidx== MMC_CMD_WRITE_SINGLE_BLOCK)	return 1;
    27c4:	01800713          	li	a4,24
    27c8:	02e78663          	beq	a5,a4,27f4 <sd_ctrl_check_read_write+0x44>
	else if(cmd->cmdidx== MMC_CMD_WRITE_MULTIPLE_BLOCK)	return 1;
    27cc:	01900713          	li	a4,25
    27d0:	00e78663          	beq	a5,a4,27dc <sd_ctrl_check_read_write+0x2c>
	else	return 0;
    27d4:	00000513          	li	a0,0
}
    27d8:	00008067          	ret
	else if(cmd->cmdidx== MMC_CMD_WRITE_MULTIPLE_BLOCK)	return 1;
    27dc:	00100513          	li	a0,1
    27e0:	00008067          	ret
		 if(cmd->cmdidx== MMC_CMD_READ_SINGLE_BLOCK)	return 1;
    27e4:	00100513          	li	a0,1
    27e8:	00008067          	ret
	else if(cmd->cmdidx== MMC_CMD_READ_MULTIPLE_BLOCK)	return 1;
    27ec:	00100513          	li	a0,1
    27f0:	00008067          	ret
	else if(cmd->cmdidx== MMC_CMD_WRITE_SINGLE_BLOCK)	return 1;
    27f4:	00100513          	li	a0,1
    27f8:	00008067          	ret

000027fc <sd_ctrl_send_cmd>:
{
    27fc:	ff010113          	addi	sp,sp,-16
    2800:	00112623          	sw	ra,12(sp)
    2804:	00812423          	sw	s0,8(sp)
    2808:	00912223          	sw	s1,4(sp)
    280c:	01212023          	sw	s2,0(sp)
    2810:	00050913          	mv	s2,a0
    2814:	00058413          	mv	s0,a1
    2818:	00060493          	mv	s1,a2
	if(sd_ctrl_check_read_write(cmd))
    281c:	00058513          	mv	a0,a1
    2820:	f91ff0ef          	jal	ra,27b0 <sd_ctrl_check_read_write>
    2824:	02050a63          	beqz	a0,2858 <sd_ctrl_send_cmd+0x5c>
		if(data)
    2828:	00048a63          	beqz	s1,283c <sd_ctrl_send_cmd+0x40>
			sd_ctrl_data(mmc,cmd,data);
    282c:	00048613          	mv	a2,s1
    2830:	00040593          	mv	a1,s0
    2834:	00090513          	mv	a0,s2
    2838:	d21ff0ef          	jal	ra,2558 <sd_ctrl_data>
}
    283c:	00000513          	li	a0,0
    2840:	00c12083          	lw	ra,12(sp)
    2844:	00812403          	lw	s0,8(sp)
    2848:	00412483          	lw	s1,4(sp)
    284c:	00012903          	lw	s2,0(sp)
    2850:	01010113          	addi	sp,sp,16
    2854:	00008067          	ret
		sd_ctrl_cmd(mmc,cmd);
    2858:	00040593          	mv	a1,s0
    285c:	00090513          	mv	a0,s2
    2860:	8e5ff0ef          	jal	ra,2144 <sd_ctrl_cmd>
    2864:	fd9ff06f          	j	283c <sd_ctrl_send_cmd+0x40>

00002868 <sd_ctrl_set_clk>:


int sd_ctrl_set_clk(struct mmc *mmc)
{
    2868:	ff010113          	addi	sp,sp,-16
    286c:	00112623          	sw	ra,12(sp)
    2870:	00050793          	mv	a5,a0
	struct sd_ctrl_dev *dev = mmc->priv;
    2874:	00852503          	lw	a0,8(a0)
	int clk;
	u32 Value;

	if(dev->clk_freq >= mmc->f_max)
    2878:	00452603          	lw	a2,4(a0)
    287c:	0187a703          	lw	a4,24(a5)
    2880:	04e66663          	bltu	a2,a4,28cc <sd_ctrl_set_clk+0x64>
		clk=mmc->f_max;
    2884:	00070613          	mv	a2,a4
	else if(dev->clk_freq <= mmc->f_min)
		clk=mmc->f_min;
	else
		clk = dev->clk_freq;

	mmc->clock = clk;
    2888:	02c7a223          	sw	a2,36(a5)

	if(DEBUG_PRINTF_EN == 1)
		bsp_printf("clk=%d\r\n",clk);

	Value = 100000/clk;
    288c:	000187b7          	lui	a5,0x18
    2890:	6a078793          	addi	a5,a5,1696 # 186a0 <raw_table3+0x7cc>
    2894:	02c7c7b3          	div	a5,a5,a2

	//sys_reg - clk_out_en & clk_out_div
	sd_ctrl_write(dev,0x004,(0x1<<16) | Value);
    2898:	00010637          	lui	a2,0x10
    289c:	00c7e633          	or	a2,a5,a2
    28a0:	00400593          	li	a1,4
    28a4:	881ff0ef          	jal	ra,2124 <sd_ctrl_write>

	if(DEBUG_PRINTF_EN == 1)
		bsp_printf("SDS Clock Division Coefficient %d\r\n", Value);

	bsp_uDelay(10);
    28a8:	f8b00637          	lui	a2,0xf8b00
    28ac:	05f5e5b7          	lui	a1,0x5f5e
    28b0:	10058593          	addi	a1,a1,256 # 5f5e100 <__freertos_irq_stack_top+0x5f0a690>
    28b4:	00a00513          	li	a0,10
    28b8:	829ff0ef          	jal	ra,20e0 <clint_uDelay>

	return 0;
}
    28bc:	00000513          	li	a0,0
    28c0:	00c12083          	lw	ra,12(sp)
    28c4:	01010113          	addi	sp,sp,16
    28c8:	00008067          	ret
	else if(dev->clk_freq <= mmc->f_min)
    28cc:	0147a703          	lw	a4,20(a5)
    28d0:	fac76ce3          	bltu	a4,a2,2888 <sd_ctrl_set_clk+0x20>
		clk=mmc->f_min;
    28d4:	00070613          	mv	a2,a4
    28d8:	fb1ff06f          	j	2888 <sd_ctrl_set_clk+0x20>

000028dc <sd_ctrl_set_bus>:

int sd_ctrl_set_bus(struct mmc *mmc)
{
    28dc:	ff010113          	addi	sp,sp,-16
    28e0:	00112623          	sw	ra,12(sp)
    28e4:	00050793          	mv	a5,a0
	int set_width;
	struct sd_ctrl_dev *dev = mmc->priv;
    28e8:	00852503          	lw	a0,8(a0)

	if(mmc->bus_width >=4)	set_width=2;	//4 bit
    28ec:	0207a703          	lw	a4,32(a5)
    28f0:	00300793          	li	a5,3
    28f4:	02e7f063          	bgeu	a5,a4,2914 <sd_ctrl_set_bus+0x38>
    28f8:	00200613          	li	a2,2
	else					set_width=1;	//1 bit

	sd_ctrl_write(dev,SDHC_ADDR+REG_HOST_CONTORL,set_width);
    28fc:	12800593          	li	a1,296
    2900:	825ff0ef          	jal	ra,2124 <sd_ctrl_write>

	return 0;
}
    2904:	00000513          	li	a0,0
    2908:	00c12083          	lw	ra,12(sp)
    290c:	01010113          	addi	sp,sp,16
    2910:	00008067          	ret
	else					set_width=1;	//1 bit
    2914:	00100613          	li	a2,1
    2918:	fe5ff06f          	j	28fc <sd_ctrl_set_bus+0x20>

0000291c <sd_ctrl_set_ios>:

int sd_ctrl_set_ios(struct mmc *mmc)
{
    291c:	ff010113          	addi	sp,sp,-16
    2920:	00112623          	sw	ra,12(sp)
    2924:	00812423          	sw	s0,8(sp)
    2928:	00050413          	mv	s0,a0
	sd_ctrl_set_clk(mmc);
    292c:	f3dff0ef          	jal	ra,2868 <sd_ctrl_set_clk>
	sd_ctrl_set_bus(mmc);
    2930:	00040513          	mv	a0,s0
    2934:	fa9ff0ef          	jal	ra,28dc <sd_ctrl_set_bus>

	return 0;
}
    2938:	00000513          	li	a0,0
    293c:	00c12083          	lw	ra,12(sp)
    2940:	00812403          	lw	s0,8(sp)
    2944:	01010113          	addi	sp,sp,16
    2948:	00008067          	ret

0000294c <sd_ctrl_init>:

int sd_ctrl_init(struct mmc *mmc)
{
    294c:	ff010113          	addi	sp,sp,-16
    2950:	00112623          	sw	ra,12(sp)
    2954:	00812423          	sw	s0,8(sp)
    2958:	00050413          	mv	s0,a0

	mmc->cfg->ops->getcd(mmc);
    295c:	00052783          	lw	a5,0(a0)
    2960:	0047a783          	lw	a5,4(a5)
    2964:	00c7a783          	lw	a5,12(a5)
    2968:	000780e7          	jalr	a5
	mmc->cfg->ops->getwp(mmc);
    296c:	00042783          	lw	a5,0(s0)
    2970:	0047a783          	lw	a5,4(a5)
    2974:	0107a783          	lw	a5,16(a5)
    2978:	00040513          	mv	a0,s0
    297c:	000780e7          	jalr	a5
	mmc->cfg->ops->set_ios(mmc);
    2980:	00042783          	lw	a5,0(s0)
    2984:	0047a783          	lw	a5,4(a5)
    2988:	0047a783          	lw	a5,4(a5)
    298c:	00040513          	mv	a0,s0
    2990:	000780e7          	jalr	a5

	return 0;
}
    2994:	00000513          	li	a0,0
    2998:	00c12083          	lw	ra,12(sp)
    299c:	00812403          	lw	s0,8(sp)
    29a0:	01010113          	addi	sp,sp,16
    29a4:	00008067          	ret

000029a8 <sd_ctrl_mmc_probe>:


int sd_ctrl_mmc_probe(struct mmc *mmc ,int base_addr)
{
    29a8:	fe010113          	addi	sp,sp,-32
    29ac:	00112e23          	sw	ra,28(sp)
    29b0:	00812c23          	sw	s0,24(sp)
    29b4:	00912a23          	sw	s1,20(sp)
    29b8:	01212823          	sw	s2,16(sp)
    29bc:	01312623          	sw	s3,12(sp)
    29c0:	00050413          	mv	s0,a0
    29c4:	00058993          	mv	s3,a1
	struct sd_ctrl_dev *dev;
	TransModeStruct *ptr;

	dev = malloc(sizeof(struct sd_ctrl_dev));
    29c8:	01800513          	li	a0,24
    29cc:	f2cfe0ef          	jal	ra,10f8 <malloc>
    29d0:	00050493          	mv	s1,a0
	ptr = malloc(sizeof(TransModeStruct));
    29d4:	01400513          	li	a0,20
    29d8:	f20fe0ef          	jal	ra,10f8 <malloc>
    29dc:	00050913          	mv	s2,a0

	memset(dev,0,sizeof(struct sd_ctrl_dev));
    29e0:	00048423          	sb	zero,8(s1)
    29e4:	000484a3          	sb	zero,9(s1)
    29e8:	00048523          	sb	zero,10(s1)
    29ec:	000485a3          	sb	zero,11(s1)
    29f0:	00048623          	sb	zero,12(s1)
    29f4:	000486a3          	sb	zero,13(s1)
    29f8:	00048723          	sb	zero,14(s1)
    29fc:	000487a3          	sb	zero,15(s1)
    2a00:	00048823          	sb	zero,16(s1)
    2a04:	000488a3          	sb	zero,17(s1)
    2a08:	00048923          	sb	zero,18(s1)
    2a0c:	000489a3          	sb	zero,19(s1)
	memset(ptr,0,sizeof(TransModeStruct));
    2a10:	01400613          	li	a2,20
    2a14:	00000593          	li	a1,0
    2a18:	f91fe0ef          	jal	ra,19a8 <memset>

	dev->base_addr = base_addr;
    2a1c:	0134a023          	sw	s3,0(s1)
	dev->clk_freq	= SD_CLK_FREQ;
    2a20:	0000c7b7          	lui	a5,0xc
    2a24:	35078793          	addi	a5,a5,848 # c350 <raw_table4+0x2a14>
    2a28:	00f4a223          	sw	a5,4(s1)
	dev->TransModePtr = ptr;
    2a2c:	0124aa23          	sw	s2,20(s1)

	mmc->priv = dev;
    2a30:	00942423          	sw	s1,8(s0)
	mmc->cfg->name = "efx_sd_contorller";
    2a34:	00042683          	lw	a3,0(s0)
    2a38:	00009737          	lui	a4,0x9
    2a3c:	a6870713          	addi	a4,a4,-1432 # 8a68 <_data+0x54>
    2a40:	00e6a023          	sw	a4,0(a3)
	mmc->cfg->ops->send_cmd = sd_ctrl_send_cmd;
    2a44:	00042703          	lw	a4,0(s0)
    2a48:	00472683          	lw	a3,4(a4)
    2a4c:	00002737          	lui	a4,0x2
    2a50:	7fc70713          	addi	a4,a4,2044 # 27fc <sd_ctrl_send_cmd>
    2a54:	00e6a023          	sw	a4,0(a3)
	mmc->cfg->ops->set_ios = sd_ctrl_set_ios;
    2a58:	00042703          	lw	a4,0(s0)
    2a5c:	00472683          	lw	a3,4(a4)
    2a60:	00003737          	lui	a4,0x3
    2a64:	91c70713          	addi	a4,a4,-1764 # 291c <sd_ctrl_set_ios>
    2a68:	00e6a223          	sw	a4,4(a3)
	mmc->cfg->ops->getcd	= sd_ctrl_get_cd;
    2a6c:	00042703          	lw	a4,0(s0)
    2a70:	00472683          	lw	a3,4(a4)
    2a74:	00002737          	lui	a4,0x2
    2a78:	11470713          	addi	a4,a4,276 # 2114 <sd_ctrl_get_cd>
    2a7c:	00e6a623          	sw	a4,12(a3)
	mmc->cfg->ops->getwp	= sd_ctrl_get_wp;
    2a80:	00042703          	lw	a4,0(s0)
    2a84:	00472683          	lw	a3,4(a4)
    2a88:	00002737          	lui	a4,0x2
    2a8c:	11c70713          	addi	a4,a4,284 # 211c <sd_ctrl_get_wp>
    2a90:	00e6a823          	sw	a4,16(a3)

	mmc->f_max = MAX_CLK_FREQ;
    2a94:	00f42c23          	sw	a5,24(s0)
	mmc->f_min = MAX_CLK_FREQ/4;
    2a98:	000037b7          	lui	a5,0x3
    2a9c:	0d478793          	addi	a5,a5,212 # 30d4 <PiCam_TestPattern+0x14>
    2aa0:	00f42a23          	sw	a5,20(s0)

	mmc->host_caps = MMC_MODE_4BIT;
    2aa4:	200007b7          	lui	a5,0x20000
    2aa8:	02f42623          	sw	a5,44(s0)
	mmc->cfg->b_max = 1024;
    2aac:	00042783          	lw	a5,0(s0)
    2ab0:	40000713          	li	a4,1024
    2ab4:	00e7ac23          	sw	a4,24(a5) # 20000018 <__freertos_irq_stack_top+0x1ffac5a8>
	mmc->bus_width =4;
    2ab8:	00400793          	li	a5,4
    2abc:	02f42023          	sw	a5,32(s0)
	mmc->high_capacity=1;
    2ac0:	00100793          	li	a5,1
    2ac4:	00f42e23          	sw	a5,28(s0)
	mmc->read_bl_len = BLOCK_SIZE;
    2ac8:	20000793          	li	a5,512
    2acc:	06f42623          	sw	a5,108(s0)

	mmc->cfg->voltages = MMC_VDD_32_33 | MMC_VDD_33_34;
    2ad0:	00042783          	lw	a5,0(s0)
    2ad4:	00300737          	lui	a4,0x300
    2ad8:	00e7a623          	sw	a4,12(a5)

	sd_ctrl_init(mmc);
    2adc:	00040513          	mv	a0,s0
    2ae0:	e6dff0ef          	jal	ra,294c <sd_ctrl_init>

	return 0;
}
    2ae4:	00000513          	li	a0,0
    2ae8:	01c12083          	lw	ra,28(sp)
    2aec:	01812403          	lw	s0,24(sp)
    2af0:	01412483          	lw	s1,20(sp)
    2af4:	01012903          	lw	s2,16(sp)
    2af8:	00c12983          	lw	s3,12(sp)
    2afc:	02010113          	addi	sp,sp,32
    2b00:	00008067          	ret

00002b04 <i2c_masterBusy>:
        return *((volatile u32*) address);
    2b04:	04052503          	lw	a0,64(a0)
* @return      Returns 1 if the I2C master is busy, and 0 otherwise.
*
******************************************************************************/
    static int i2c_masterBusy(u32 reg){
        return (read_u32(reg + I2C_MASTER_STATUS) & I2C_MASTER_BUSY) != 0;
    }
    2b08:	00157513          	andi	a0,a0,1
    2b0c:	00008067          	ret

00002b10 <i2c_masterStartBlocking>:
        write_u32(I2C_MASTER_START | I2C_MASTER_START_DROPPED, reg + I2C_MASTER_STATUS);
    2b10:	04050713          	addi	a4,a0,64
        *((volatile u32*) address) = data;
    2b14:	21000793          	li	a5,528
    2b18:	04f52023          	sw	a5,64(a0)
        return *((volatile u32*) address);
    2b1c:	00072783          	lw	a5,0(a4) # 300000 <__freertos_irq_stack_top+0x2ac590>
* @return      None.
*
******************************************************************************/
    static void i2c_masterStartBlocking(u32 reg){
        i2c_masterStart(reg);
        while(i2c_getMasterStatus(reg) & I2C_MASTER_START);
    2b20:	0107f793          	andi	a5,a5,16
    2b24:	fe079ce3          	bnez	a5,2b1c <i2c_masterStartBlocking+0xc>
    }
    2b28:	00008067          	ret

00002b2c <i2c_masterStopWait>:
* @param reg   The base address of the I2C registers.
*
* @return      None.
*
******************************************************************************/
    static void i2c_masterStopWait(u32 reg){
    2b2c:	ff010113          	addi	sp,sp,-16
    2b30:	00112623          	sw	ra,12(sp)
    2b34:	00812423          	sw	s0,8(sp)
    2b38:	00050413          	mv	s0,a0
        while(i2c_masterBusy(reg));
    2b3c:	00040513          	mv	a0,s0
    2b40:	fc5ff0ef          	jal	ra,2b04 <i2c_masterBusy>
    2b44:	fe051ce3          	bnez	a0,2b3c <i2c_masterStopWait+0x10>
    }
    2b48:	00c12083          	lw	ra,12(sp)
    2b4c:	00812403          	lw	s0,8(sp)
    2b50:	01010113          	addi	sp,sp,16
    2b54:	00008067          	ret

00002b58 <i2c_masterStopBlocking>:
* @param reg   The base address of the I2C registers.
*
* @return      None.
*
******************************************************************************/
    static void i2c_masterStopBlocking(u32 reg){
    2b58:	ff010113          	addi	sp,sp,-16
    2b5c:	00112623          	sw	ra,12(sp)
        *((volatile u32*) address) = data;
    2b60:	42000713          	li	a4,1056
    2b64:	04e52023          	sw	a4,64(a0)
        i2c_masterStop(reg);
        i2c_masterStopWait(reg);
    2b68:	fc5ff0ef          	jal	ra,2b2c <i2c_masterStopWait>
    }
    2b6c:	00c12083          	lw	ra,12(sp)
    2b70:	01010113          	addi	sp,sp,16
    2b74:	00008067          	ret

00002b78 <i2c_txAckWait>:
        return *((volatile u32*) address);
    2b78:	00452783          	lw	a5,4(a0)
*
* @return      None.
*
******************************************************************************/
    static void i2c_txAckWait(u32 reg){
        while(read_u32(reg + I2C_TX_ACK) & I2C_TX_VALID);
    2b7c:	1007f793          	andi	a5,a5,256
    2b80:	fe079ce3          	bnez	a5,2b78 <i2c_txAckWait>
    }
    2b84:	00008067          	ret

00002b88 <i2c_txNackBlocking>:
* @param reg   The base address of the I2C registers.
*
* @return      None.
*
******************************************************************************/
    static void i2c_txNackBlocking(u32 reg){
    2b88:	ff010113          	addi	sp,sp,-16
    2b8c:	00112623          	sw	ra,12(sp)
        *((volatile u32*) address) = data;
    2b90:	30100713          	li	a4,769
    2b94:	00e52223          	sw	a4,4(a0)
        i2c_txNack(reg);
        i2c_txAckWait(reg);
    2b98:	fe1ff0ef          	jal	ra,2b78 <i2c_txAckWait>
    }
    2b9c:	00c12083          	lw	ra,12(sp)
    2ba0:	01010113          	addi	sp,sp,16
    2ba4:	00008067          	ret

00002ba8 <i2c_rxData>:
        return *((volatile u32*) address);
    2ba8:	00852503          	lw	a0,8(a0)
*
******************************************************************************/

    static u32 i2c_rxData(u32 reg){
        return read_u32(reg + I2C_RX_DATA) & I2C_RX_VALUE;
    }
    2bac:	0ff57513          	andi	a0,a0,255
    2bb0:	00008067          	ret

00002bb4 <i2c_rxNack>:
    2bb4:	00c52503          	lw	a0,12(a0)
*
* @return      1 if NACK signal is detected, otherwise 0.
*
******************************************************************************/
    static int i2c_rxNack(u32 reg){
        return (read_u32(reg + I2C_RX_ACK) & I2C_RX_VALUE) != 0;
    2bb8:	0ff57513          	andi	a0,a0,255
    }
    2bbc:	00a03533          	snez	a0,a0
    2bc0:	00008067          	ret

00002bc4 <i2c_rxAck>:
    2bc4:	00c52503          	lw	a0,12(a0)
*
* @return      1 if ACK signal is detected, otherwise 0.
*
******************************************************************************/
    static int i2c_rxAck(u32 reg){
        return (read_u32(reg + I2C_RX_ACK) & I2C_RX_VALUE) == 0;
    2bc8:	0ff57513          	andi	a0,a0,255
    }
    2bcc:	00153513          	seqz	a0,a0
    2bd0:	00008067          	ret

00002bd4 <PiCam_WriteRegData>:

#define PiCam_I2C_addr  0x10


int PiCam_WriteRegData(u16 reg,u8 data)
{
    2bd4:	ff010113          	addi	sp,sp,-16
    2bd8:	00112623          	sw	ra,12(sp)
    2bdc:	00812423          	sw	s0,8(sp)
    2be0:	00912223          	sw	s1,4(sp)
    2be4:	00050413          	mv	s0,a0
    2be8:	00058493          	mv	s1,a1
	u8 outdata;

    i2c_masterStartBlocking(I2C_CTRL_MIPI);
    2bec:	f8017537          	lui	a0,0xf8017
    2bf0:	f21ff0ef          	jal	ra,2b10 <i2c_masterStartBlocking>
        *((volatile u32*) address) = data;
    2bf4:	f8017737          	lui	a4,0xf8017
    2bf8:	000017b7          	lui	a5,0x1
    2bfc:	b2078793          	addi	a5,a5,-1248 # b20 <CUSTOM2+0xac5>
    2c00:	00f72023          	sw	a5,0(a4) # f8017000 <__freertos_irq_stack_top+0xf7fc3590>

    i2c_txByte(I2C_CTRL_MIPI, PiCam_I2C_addr<<1);
	i2c_txNackBlocking(I2C_CTRL_MIPI);
    2c04:	f8017537          	lui	a0,0xf8017
    2c08:	f81ff0ef          	jal	ra,2b88 <i2c_txNackBlocking>
	if (assert(i2c_rxAck(I2C_CTRL_MIPI)) ) // Optional check
    2c0c:	f8017537          	lui	a0,0xf8017
    2c10:	fb5ff0ef          	jal	ra,2bc4 <i2c_rxAck>
    2c14:	394020ef          	jal	ra,4fa8 <assert>
    2c18:	02050063          	beqz	a0,2c38 <PiCam_WriteRegData+0x64>
		return 1;
    2c1c:	00100413          	li	s0,1
	if (assert(i2c_rxAck(I2C_CTRL_MIPI)) ) // Optional check
		return 1;
	i2c_masterStopBlocking(I2C_CTRL_MIPI);

	return 0;
}
    2c20:	00040513          	mv	a0,s0
    2c24:	00c12083          	lw	ra,12(sp)
    2c28:	00812403          	lw	s0,8(sp)
    2c2c:	00412483          	lw	s1,4(sp)
    2c30:	01010113          	addi	sp,sp,16
    2c34:	00008067          	ret
	i2c_txByte(I2C_CTRL_MIPI, (reg>>8) & 0xFF);
    2c38:	00845793          	srli	a5,s0,0x8
        write_u32(byte | I2C_TX_VALID | I2C_TX_ENABLE | I2C_TX_DISABLE_ON_DATA_CONFLICT, reg + I2C_TX_DATA);
    2c3c:	00001737          	lui	a4,0x1
    2c40:	b0070713          	addi	a4,a4,-1280 # b00 <CUSTOM2+0xaa5>
    2c44:	00e7e7b3          	or	a5,a5,a4
    2c48:	f8017737          	lui	a4,0xf8017
    2c4c:	00f72023          	sw	a5,0(a4) # f8017000 <__freertos_irq_stack_top+0xf7fc3590>
	i2c_txNackBlocking(I2C_CTRL_MIPI);
    2c50:	f8017537          	lui	a0,0xf8017
    2c54:	f35ff0ef          	jal	ra,2b88 <i2c_txNackBlocking>
	if (assert(i2c_rxAck(I2C_CTRL_MIPI)) ) // Optional check
    2c58:	f8017537          	lui	a0,0xf8017
    2c5c:	f69ff0ef          	jal	ra,2bc4 <i2c_rxAck>
    2c60:	348020ef          	jal	ra,4fa8 <assert>
    2c64:	00050663          	beqz	a0,2c70 <PiCam_WriteRegData+0x9c>
		return 1;
    2c68:	00100413          	li	s0,1
    2c6c:	fb5ff06f          	j	2c20 <PiCam_WriteRegData+0x4c>
	i2c_txByte(I2C_CTRL_MIPI, (reg) & 0xFF);
    2c70:	0ff47413          	andi	s0,s0,255
    2c74:	000017b7          	lui	a5,0x1
    2c78:	b0078793          	addi	a5,a5,-1280 # b00 <CUSTOM2+0xaa5>
    2c7c:	00f46433          	or	s0,s0,a5
    2c80:	f80177b7          	lui	a5,0xf8017
    2c84:	0087a023          	sw	s0,0(a5) # f8017000 <__freertos_irq_stack_top+0xf7fc3590>
	i2c_txNackBlocking(I2C_CTRL_MIPI);
    2c88:	f8017537          	lui	a0,0xf8017
    2c8c:	efdff0ef          	jal	ra,2b88 <i2c_txNackBlocking>
	if (assert(i2c_rxAck(I2C_CTRL_MIPI)) ) // Optional check
    2c90:	f8017537          	lui	a0,0xf8017
    2c94:	f31ff0ef          	jal	ra,2bc4 <i2c_rxAck>
    2c98:	310020ef          	jal	ra,4fa8 <assert>
    2c9c:	00050663          	beqz	a0,2ca8 <PiCam_WriteRegData+0xd4>
		return 1;
    2ca0:	00100413          	li	s0,1
    2ca4:	f7dff06f          	j	2c20 <PiCam_WriteRegData+0x4c>
    2ca8:	000017b7          	lui	a5,0x1
    2cac:	b0078793          	addi	a5,a5,-1280 # b00 <CUSTOM2+0xaa5>
    2cb0:	00f4e4b3          	or	s1,s1,a5
    2cb4:	f80177b7          	lui	a5,0xf8017
    2cb8:	0097a023          	sw	s1,0(a5) # f8017000 <__freertos_irq_stack_top+0xf7fc3590>
	i2c_txNackBlocking(I2C_CTRL_MIPI);
    2cbc:	f8017537          	lui	a0,0xf8017
    2cc0:	ec9ff0ef          	jal	ra,2b88 <i2c_txNackBlocking>
	if (assert(i2c_rxAck(I2C_CTRL_MIPI)) ) // Optional check
    2cc4:	f8017537          	lui	a0,0xf8017
    2cc8:	efdff0ef          	jal	ra,2bc4 <i2c_rxAck>
    2ccc:	2dc020ef          	jal	ra,4fa8 <assert>
    2cd0:	00050413          	mv	s0,a0
    2cd4:	00050663          	beqz	a0,2ce0 <PiCam_WriteRegData+0x10c>
		return 1;
    2cd8:	00100413          	li	s0,1
    2cdc:	f45ff06f          	j	2c20 <PiCam_WriteRegData+0x4c>
	i2c_masterStopBlocking(I2C_CTRL_MIPI);
    2ce0:	f8017537          	lui	a0,0xf8017
    2ce4:	e75ff0ef          	jal	ra,2b58 <i2c_masterStopBlocking>
	return 0;
    2ce8:	f39ff06f          	j	2c20 <PiCam_WriteRegData+0x4c>

00002cec <PiCam_ReadRegData>:

u8 PiCam_ReadRegData(u16 reg)
{
    2cec:	fe010113          	addi	sp,sp,-32
    2cf0:	00112e23          	sw	ra,28(sp)
    2cf4:	00812c23          	sw	s0,24(sp)
    2cf8:	00912a23          	sw	s1,20(sp)
    2cfc:	01212823          	sw	s2,16(sp)
    2d00:	01312623          	sw	s3,12(sp)
    2d04:	00050493          	mv	s1,a0
	u8 outdata;

    i2c_masterStartBlocking(I2C_CTRL_MIPI);
    2d08:	f8017537          	lui	a0,0xf8017
    2d0c:	e05ff0ef          	jal	ra,2b10 <i2c_masterStartBlocking>
    2d10:	f8017937          	lui	s2,0xf8017
    2d14:	00001437          	lui	s0,0x1
    2d18:	b2040793          	addi	a5,s0,-1248 # b20 <CUSTOM2+0xac5>
    2d1c:	00f92023          	sw	a5,0(s2) # f8017000 <__freertos_irq_stack_top+0xf7fc3590>

    i2c_txByte(I2C_CTRL_MIPI, PiCam_I2C_addr<<1);
	i2c_txNackBlocking(I2C_CTRL_MIPI);
    2d20:	f8017537          	lui	a0,0xf8017
    2d24:	e65ff0ef          	jal	ra,2b88 <i2c_txNackBlocking>
	assert(i2c_rxAck(I2C_CTRL_MIPI)); // Optional check
    2d28:	f8017537          	lui	a0,0xf8017
    2d2c:	e99ff0ef          	jal	ra,2bc4 <i2c_rxAck>
    2d30:	278020ef          	jal	ra,4fa8 <assert>

	i2c_txByte(I2C_CTRL_MIPI, (reg>>8) & 0xFF);
    2d34:	0084d793          	srli	a5,s1,0x8
    2d38:	b0040993          	addi	s3,s0,-1280
    2d3c:	0137e7b3          	or	a5,a5,s3
    2d40:	00f92023          	sw	a5,0(s2)
	i2c_txNackBlocking(I2C_CTRL_MIPI);
    2d44:	f8017537          	lui	a0,0xf8017
    2d48:	e41ff0ef          	jal	ra,2b88 <i2c_txNackBlocking>
	assert(i2c_rxAck(I2C_CTRL_MIPI)); // Optional check
    2d4c:	f8017537          	lui	a0,0xf8017
    2d50:	e75ff0ef          	jal	ra,2bc4 <i2c_rxAck>
    2d54:	254020ef          	jal	ra,4fa8 <assert>

	i2c_txByte(I2C_CTRL_MIPI, (reg) & 0xFF);
    2d58:	0ff4f493          	andi	s1,s1,255
    2d5c:	0134e4b3          	or	s1,s1,s3
    2d60:	00992023          	sw	s1,0(s2)
	i2c_txNackBlocking(I2C_CTRL_MIPI);
    2d64:	f8017537          	lui	a0,0xf8017
    2d68:	e21ff0ef          	jal	ra,2b88 <i2c_txNackBlocking>
	assert(i2c_rxAck(I2C_CTRL_MIPI)); // Optional check
    2d6c:	f8017537          	lui	a0,0xf8017
    2d70:	e55ff0ef          	jal	ra,2bc4 <i2c_rxAck>
    2d74:	234020ef          	jal	ra,4fa8 <assert>

	i2c_masterStopBlocking(I2C_CTRL_MIPI);
    2d78:	f8017537          	lui	a0,0xf8017
    2d7c:	dddff0ef          	jal	ra,2b58 <i2c_masterStopBlocking>
	i2c_masterStartBlocking(I2C_CTRL_MIPI);
    2d80:	f8017537          	lui	a0,0xf8017
    2d84:	d8dff0ef          	jal	ra,2b10 <i2c_masterStartBlocking>
    2d88:	b2140793          	addi	a5,s0,-1247
    2d8c:	00f92023          	sw	a5,0(s2)

	i2c_txByte(I2C_CTRL_MIPI, (PiCam_I2C_addr<<1) | 0x01);
	i2c_txNackBlocking(I2C_CTRL_MIPI);
    2d90:	f8017537          	lui	a0,0xf8017
    2d94:	df5ff0ef          	jal	ra,2b88 <i2c_txNackBlocking>
	assert(i2c_rxAck(I2C_CTRL_MIPI)); // Optional check
    2d98:	f8017537          	lui	a0,0xf8017
    2d9c:	e29ff0ef          	jal	ra,2bc4 <i2c_rxAck>
    2da0:	208020ef          	jal	ra,4fa8 <assert>
    2da4:	bff40413          	addi	s0,s0,-1025
    2da8:	00892023          	sw	s0,0(s2)

	i2c_txByte(I2C_CTRL_MIPI, 0xFF);
	i2c_txNackBlocking(I2C_CTRL_MIPI);
    2dac:	f8017537          	lui	a0,0xf8017
    2db0:	dd9ff0ef          	jal	ra,2b88 <i2c_txNackBlocking>
	assert(i2c_rxNack(I2C_CTRL_MIPI)); // Optional check
    2db4:	f8017537          	lui	a0,0xf8017
    2db8:	dfdff0ef          	jal	ra,2bb4 <i2c_rxNack>
    2dbc:	1ec020ef          	jal	ra,4fa8 <assert>
	outdata = i2c_rxData(I2C_CTRL_MIPI);
    2dc0:	f8017537          	lui	a0,0xf8017
    2dc4:	de5ff0ef          	jal	ra,2ba8 <i2c_rxData>
    2dc8:	0ff57413          	andi	s0,a0,255

	i2c_masterStopBlocking(I2C_CTRL_MIPI);
    2dcc:	f8017537          	lui	a0,0xf8017
    2dd0:	d89ff0ef          	jal	ra,2b58 <i2c_masterStopBlocking>

	return outdata;
}
    2dd4:	00040513          	mv	a0,s0
    2dd8:	01c12083          	lw	ra,28(sp)
    2ddc:	01812403          	lw	s0,24(sp)
    2de0:	01412483          	lw	s1,20(sp)
    2de4:	01012903          	lw	s2,16(sp)
    2de8:	00c12983          	lw	s3,12(sp)
    2dec:	02010113          	addi	sp,sp,32
    2df0:	00008067          	ret

00002df4 <AccessCommSeq>:
void AccessCommSeq(void)
{
    2df4:	ff010113          	addi	sp,sp,-16
    2df8:	00112623          	sw	ra,12(sp)
    2dfc:	00812423          	sw	s0,8(sp)
	PiCam_WriteRegData(0x30EB, 0x05);
    2e00:	00500593          	li	a1,5
    2e04:	00003437          	lui	s0,0x3
    2e08:	0eb40513          	addi	a0,s0,235 # 30eb <PiCam_TestPattern+0x2b>
    2e0c:	dc9ff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
	PiCam_WriteRegData(0x30EB, 0x0C);
    2e10:	00c00593          	li	a1,12
    2e14:	0eb40513          	addi	a0,s0,235
    2e18:	dbdff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
	PiCam_WriteRegData(0x300A, 0xFF);
    2e1c:	0ff00593          	li	a1,255
    2e20:	00a40513          	addi	a0,s0,10
    2e24:	db1ff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
	PiCam_WriteRegData(0x300B, 0xFF);
    2e28:	0ff00593          	li	a1,255
    2e2c:	00b40513          	addi	a0,s0,11
    2e30:	da5ff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
	PiCam_WriteRegData(0x30EB, 0x05);
    2e34:	00500593          	li	a1,5
    2e38:	0eb40513          	addi	a0,s0,235
    2e3c:	d99ff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
	PiCam_WriteRegData(0x30EB, 0x09);
    2e40:	00900593          	li	a1,9
    2e44:	0eb40513          	addi	a0,s0,235
    2e48:	d8dff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
}
    2e4c:	00c12083          	lw	ra,12(sp)
    2e50:	00812403          	lw	s0,8(sp)
    2e54:	01010113          	addi	sp,sp,16
    2e58:	00008067          	ret

00002e5c <PiCam_Output_Size>:

void PiCam_Output_Size(u16 X,u16 Y)
{
    2e5c:	ff010113          	addi	sp,sp,-16
    2e60:	00112623          	sw	ra,12(sp)
    2e64:	00812423          	sw	s0,8(sp)
    2e68:	00912223          	sw	s1,4(sp)
    2e6c:	00050493          	mv	s1,a0
    2e70:	00058413          	mv	s0,a1
	PiCam_WriteRegData(x_output_size_A_1	, X>>8);
    2e74:	00855593          	srli	a1,a0,0x8
    2e78:	16c00513          	li	a0,364
    2e7c:	d59ff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
	PiCam_WriteRegData(x_output_size_A_0	, X & 0xFF);
    2e80:	0ff4f593          	andi	a1,s1,255
    2e84:	16d00513          	li	a0,365
    2e88:	d4dff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
	PiCam_WriteRegData(y_output_size_A_1	, Y>>8);
    2e8c:	00845593          	srli	a1,s0,0x8
    2e90:	16e00513          	li	a0,366
    2e94:	d41ff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
	PiCam_WriteRegData(y_output_size_A_0	, Y & 0xFF);
    2e98:	0ff47593          	andi	a1,s0,255
    2e9c:	16f00513          	li	a0,367
    2ea0:	d35ff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
}
    2ea4:	00c12083          	lw	ra,12(sp)
    2ea8:	00812403          	lw	s0,8(sp)
    2eac:	00412483          	lw	s1,4(sp)
    2eb0:	01010113          	addi	sp,sp,16
    2eb4:	00008067          	ret

00002eb8 <PiCam_Output_activePixel>:

void PiCam_Output_activePixel(u16 XStart,u16 XEnd, u16 YStart, u16 YEnd)
{
    2eb8:	fe010113          	addi	sp,sp,-32
    2ebc:	00112e23          	sw	ra,28(sp)
    2ec0:	00812c23          	sw	s0,24(sp)
    2ec4:	00912a23          	sw	s1,20(sp)
    2ec8:	01212823          	sw	s2,16(sp)
    2ecc:	01312623          	sw	s3,12(sp)
    2ed0:	00050993          	mv	s3,a0
    2ed4:	00058913          	mv	s2,a1
    2ed8:	00060493          	mv	s1,a2
    2edc:	00068413          	mv	s0,a3

	//Max Active pixel 3280* 2464--imx219

	PiCam_WriteRegData(X_ADD_STA_A_1	, XStart>>8);
    2ee0:	00855593          	srli	a1,a0,0x8
    2ee4:	16400513          	li	a0,356
    2ee8:	cedff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
	PiCam_WriteRegData(X_ADD_STA_A_0	, XStart&0xFF);
    2eec:	0ff9f593          	andi	a1,s3,255
    2ef0:	16500513          	li	a0,357
    2ef4:	ce1ff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
	PiCam_WriteRegData(X_ADD_END_A_1	, XEnd>>8);
    2ef8:	00895593          	srli	a1,s2,0x8
    2efc:	16600513          	li	a0,358
    2f00:	cd5ff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
	PiCam_WriteRegData(X_ADD_END_A_0	, XEnd&0xFF);
    2f04:	0ff97593          	andi	a1,s2,255
    2f08:	16700513          	li	a0,359
    2f0c:	cc9ff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>

	PiCam_WriteRegData(Y_ADD_STA_A_1	, YStart>>8);
    2f10:	0084d593          	srli	a1,s1,0x8
    2f14:	16800513          	li	a0,360
    2f18:	cbdff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
	PiCam_WriteRegData(Y_ADD_STA_A_0	, YStart&0xFF);
    2f1c:	0ff4f593          	andi	a1,s1,255
    2f20:	16900513          	li	a0,361
    2f24:	cb1ff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
	PiCam_WriteRegData(Y_ADD_END_A_1	, YEnd>>8);
    2f28:	00845593          	srli	a1,s0,0x8
    2f2c:	16a00513          	li	a0,362
    2f30:	ca5ff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
	PiCam_WriteRegData(Y_ADD_END_A_0	, YEnd&0xFF);
    2f34:	0ff47593          	andi	a1,s0,255
    2f38:	16b00513          	li	a0,363
    2f3c:	c99ff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
}
    2f40:	01c12083          	lw	ra,28(sp)
    2f44:	01812403          	lw	s0,24(sp)
    2f48:	01412483          	lw	s1,20(sp)
    2f4c:	01012903          	lw	s2,16(sp)
    2f50:	00c12983          	lw	s3,12(sp)
    2f54:	02010113          	addi	sp,sp,32
    2f58:	00008067          	ret

00002f5c <PiCam_Output_activePixelX>:

void PiCam_Output_activePixelX(u16 XStart,u16 XEnd)
{
    2f5c:	ff010113          	addi	sp,sp,-16
    2f60:	00112623          	sw	ra,12(sp)
    2f64:	00812423          	sw	s0,8(sp)
    2f68:	00912223          	sw	s1,4(sp)
    2f6c:	00050493          	mv	s1,a0
    2f70:	00058413          	mv	s0,a1
	//Max Active pixel 3280* 2464--imx219

	PiCam_WriteRegData(X_ADD_STA_A_1	, XStart>>8);
    2f74:	00855593          	srli	a1,a0,0x8
    2f78:	16400513          	li	a0,356
    2f7c:	c59ff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
	PiCam_WriteRegData(X_ADD_STA_A_0	, XStart&0xFF);
    2f80:	0ff4f593          	andi	a1,s1,255
    2f84:	16500513          	li	a0,357
    2f88:	c4dff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
	PiCam_WriteRegData(X_ADD_END_A_1	, XEnd>>8);
    2f8c:	00845593          	srli	a1,s0,0x8
    2f90:	16600513          	li	a0,358
    2f94:	c41ff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
	PiCam_WriteRegData(X_ADD_END_A_0	, XEnd&0xFF);
    2f98:	0ff47593          	andi	a1,s0,255
    2f9c:	16700513          	li	a0,359
    2fa0:	c35ff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
}
    2fa4:	00c12083          	lw	ra,12(sp)
    2fa8:	00812403          	lw	s0,8(sp)
    2fac:	00412483          	lw	s1,4(sp)
    2fb0:	01010113          	addi	sp,sp,16
    2fb4:	00008067          	ret

00002fb8 <PiCam_Output_activePixelY>:

void PiCam_Output_activePixelY(u16 YStart,u16 YEnd)
{
    2fb8:	ff010113          	addi	sp,sp,-16
    2fbc:	00112623          	sw	ra,12(sp)
    2fc0:	00812423          	sw	s0,8(sp)
    2fc4:	00912223          	sw	s1,4(sp)
    2fc8:	00050493          	mv	s1,a0
    2fcc:	00058413          	mv	s0,a1
	//Max Active pixel 3280* 2464--imx219

	PiCam_WriteRegData(Y_ADD_STA_A_1	, YStart>>8);
    2fd0:	00855593          	srli	a1,a0,0x8
    2fd4:	16800513          	li	a0,360
    2fd8:	bfdff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
	PiCam_WriteRegData(Y_ADD_STA_A_0	, YStart&0xFF);
    2fdc:	0ff4f593          	andi	a1,s1,255
    2fe0:	16900513          	li	a0,361
    2fe4:	bf1ff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
	PiCam_WriteRegData(Y_ADD_END_A_1	, YEnd>>8);
    2fe8:	00845593          	srli	a1,s0,0x8
    2fec:	16a00513          	li	a0,362
    2ff0:	be5ff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
	PiCam_WriteRegData(Y_ADD_END_A_0	, YEnd&0xFF);
    2ff4:	0ff47593          	andi	a1,s0,255
    2ff8:	16b00513          	li	a0,363
    2ffc:	bd9ff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
}
    3000:	00c12083          	lw	ra,12(sp)
    3004:	00812403          	lw	s0,8(sp)
    3008:	00412483          	lw	s1,4(sp)
    300c:	01010113          	addi	sp,sp,16
    3010:	00008067          	ret

00003014 <PiCam_SetBinningMode>:

void PiCam_SetBinningMode(u8 Xmode, u8 Ymode)
{
    3014:	ff010113          	addi	sp,sp,-16
    3018:	00112623          	sw	ra,12(sp)
    301c:	00812423          	sw	s0,8(sp)
    3020:	00058413          	mv	s0,a1
	//0:no-binning
	//1:x2-binning
	//2:x4-binning
	//3:x2 analog (special)

	if(Xmode>=3)	Xmode=3;
    3024:	00200793          	li	a5,2
    3028:	00a7f463          	bgeu	a5,a0,3030 <PiCam_SetBinningMode+0x1c>
    302c:	00300513          	li	a0,3
	if(Ymode>=3)	Ymode=3;
    3030:	00200793          	li	a5,2
    3034:	0087f463          	bgeu	a5,s0,303c <PiCam_SetBinningMode+0x28>
    3038:	00300413          	li	s0,3

	PiCam_WriteRegData(BINNING_MODE_H_A, Xmode);
    303c:	00050593          	mv	a1,a0
    3040:	17400513          	li	a0,372
    3044:	b91ff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
	PiCam_WriteRegData(BINNING_MODE_V_A, Ymode);
    3048:	00040593          	mv	a1,s0
    304c:	17500513          	li	a0,373
    3050:	b85ff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
}
    3054:	00c12083          	lw	ra,12(sp)
    3058:	00812403          	lw	s0,8(sp)
    305c:	01010113          	addi	sp,sp,16
    3060:	00008067          	ret

00003064 <PiCam_Output_ColorBarSize>:

void PiCam_Output_ColorBarSize(u16 X,u16 Y)
{
    3064:	ff010113          	addi	sp,sp,-16
    3068:	00112623          	sw	ra,12(sp)
    306c:	00812423          	sw	s0,8(sp)
    3070:	00912223          	sw	s1,4(sp)
    3074:	00050493          	mv	s1,a0
    3078:	00058413          	mv	s0,a1
	PiCam_WriteRegData(TP_WINDOW_WIDTH_1	, X>>8);
    307c:	00855593          	srli	a1,a0,0x8
    3080:	62400513          	li	a0,1572
    3084:	b51ff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
	PiCam_WriteRegData(TP_WINDOW_WIDTH_0	, X & 0xFF);
    3088:	0ff4f593          	andi	a1,s1,255
    308c:	62500513          	li	a0,1573
    3090:	b45ff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
	PiCam_WriteRegData(TP_WINDOW_HEIGHT_1	, Y>>8);
    3094:	00845593          	srli	a1,s0,0x8
    3098:	62600513          	li	a0,1574
    309c:	b39ff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
	PiCam_WriteRegData(TP_WINDOW_HEIGHT_0	, Y & 0xFF);
    30a0:	0ff47593          	andi	a1,s0,255
    30a4:	62700513          	li	a0,1575
    30a8:	b2dff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
}
    30ac:	00c12083          	lw	ra,12(sp)
    30b0:	00812403          	lw	s0,8(sp)
    30b4:	00412483          	lw	s1,4(sp)
    30b8:	01010113          	addi	sp,sp,16
    30bc:	00008067          	ret

000030c0 <PiCam_TestPattern>:

void PiCam_TestPattern(u8 Enable,u8 mode,u16 X,u16 Y)
{
    30c0:	fe010113          	addi	sp,sp,-32
    30c4:	00112e23          	sw	ra,28(sp)
    30c8:	00812c23          	sw	s0,24(sp)
    30cc:	00912a23          	sw	s1,20(sp)
    30d0:	01212823          	sw	s2,16(sp)
    30d4:	01312623          	sw	s3,12(sp)
    30d8:	00050413          	mv	s0,a0
    30dc:	00058993          	mv	s3,a1
    30e0:	00060493          	mv	s1,a2
    30e4:	00068913          	mv	s2,a3
	//0006h - 16 split inverted color bar
	//0007h - column counter
	//0008h - inverted column counter
	//0009h - PN31

	PiCam_WriteRegData(test_pattern_Ena, 0x00);
    30e8:	00000593          	li	a1,0
    30ec:	60000513          	li	a0,1536
    30f0:	ae5ff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>

	if(Enable==0)	mode=0;
    30f4:	00040463          	beqz	s0,30fc <PiCam_TestPattern+0x3c>
    30f8:	00098413          	mv	s0,s3

	PiCam_WriteRegData(test_pattern_mode, mode);
    30fc:	00040593          	mv	a1,s0
    3100:	60100513          	li	a0,1537
    3104:	ad1ff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>

	PiCam_Output_ColorBarSize(X,Y);
    3108:	00090593          	mv	a1,s2
    310c:	00048513          	mv	a0,s1
    3110:	f55ff0ef          	jal	ra,3064 <PiCam_Output_ColorBarSize>
}
    3114:	01c12083          	lw	ra,28(sp)
    3118:	01812403          	lw	s0,24(sp)
    311c:	01412483          	lw	s1,20(sp)
    3120:	01012903          	lw	s2,16(sp)
    3124:	00c12983          	lw	s3,12(sp)
    3128:	02010113          	addi	sp,sp,32
    312c:	00008067          	ret

00003130 <PiCam_TestPatternColur>:


void PiCam_TestPatternColur (u16 X,u16 Y, u16 r,u16 gr, u16 b, u16 gb)
{
    3130:	fe010113          	addi	sp,sp,-32
    3134:	00112e23          	sw	ra,28(sp)
    3138:	00812c23          	sw	s0,24(sp)
    313c:	00912a23          	sw	s1,20(sp)
    3140:	01212823          	sw	s2,16(sp)
    3144:	01312623          	sw	s3,12(sp)
    3148:	01412423          	sw	s4,8(sp)
    314c:	01512223          	sw	s5,4(sp)
    3150:	00050a13          	mv	s4,a0
    3154:	00058a93          	mv	s5,a1
    3158:	00060993          	mv	s3,a2
    315c:	00068913          	mv	s2,a3
    3160:	00070493          	mv	s1,a4
    3164:	00078413          	mv	s0,a5
	//0006h - 16 split inverted color bar
	//0007h - column counter
	//0008h - inverted column counter
	//0009h - PN31

	PiCam_WriteRegData(test_pattern_Ena, 0x00);
    3168:	00000593          	li	a1,0
    316c:	60000513          	li	a0,1536
    3170:	a65ff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
	PiCam_WriteRegData(test_pattern_mode, 0x01);
    3174:	00100593          	li	a1,1
    3178:	60100513          	li	a0,1537
    317c:	a59ff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>

	PiCam_WriteRegData(TD_R_1, ((u8)((r>>8) & 0x03)));
    3180:	0089d593          	srli	a1,s3,0x8
    3184:	0035f593          	andi	a1,a1,3
    3188:	60200513          	li	a0,1538
    318c:	a49ff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
	PiCam_WriteRegData(TD_R_0, ((u8)(r&0xff)));
    3190:	0ff9f593          	andi	a1,s3,255
    3194:	60300513          	li	a0,1539
    3198:	a3dff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>

	PiCam_WriteRegData(TD_GR_1, (u8)((gr>>8) & 0x03));
    319c:	00895593          	srli	a1,s2,0x8
    31a0:	0035f593          	andi	a1,a1,3
    31a4:	60400513          	li	a0,1540
    31a8:	a2dff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
	PiCam_WriteRegData(TD_GR_0, ((u8)(gr&0xff)));
    31ac:	0ff97593          	andi	a1,s2,255
    31b0:	60500513          	li	a0,1541
    31b4:	a21ff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>

	PiCam_WriteRegData(TD_B_1, ((u8)((b>>8) & 0x03)));
    31b8:	0084d593          	srli	a1,s1,0x8
    31bc:	0035f593          	andi	a1,a1,3
    31c0:	60600513          	li	a0,1542
    31c4:	a11ff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
	PiCam_WriteRegData(TD_B_0, ((u8)(gb&0xff)));
    31c8:	0ff47493          	andi	s1,s0,255
    31cc:	00048593          	mv	a1,s1
    31d0:	60700513          	li	a0,1543
    31d4:	a01ff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>

	PiCam_WriteRegData(TD_GB_1, ((u8)((gb>>8) & 0x03)));
    31d8:	00845593          	srli	a1,s0,0x8
    31dc:	0035f593          	andi	a1,a1,3
    31e0:	60800513          	li	a0,1544
    31e4:	9f1ff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
	PiCam_WriteRegData(TD_GB_0, ((u8)(gb&0xff)));
    31e8:	00048593          	mv	a1,s1
    31ec:	60900513          	li	a0,1545
    31f0:	9e5ff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>

	PiCam_Output_ColorBarSize(X,Y);
    31f4:	000a8593          	mv	a1,s5
    31f8:	000a0513          	mv	a0,s4
    31fc:	e69ff0ef          	jal	ra,3064 <PiCam_Output_ColorBarSize>


}
    3200:	01c12083          	lw	ra,28(sp)
    3204:	01812403          	lw	s0,24(sp)
    3208:	01412483          	lw	s1,20(sp)
    320c:	01012903          	lw	s2,16(sp)
    3210:	00c12983          	lw	s3,12(sp)
    3214:	00812a03          	lw	s4,8(sp)
    3218:	00412a83          	lw	s5,4(sp)
    321c:	02010113          	addi	sp,sp,32
    3220:	00008067          	ret

00003224 <PiCam_Gainfilter>:




int PiCam_Gainfilter(u8 AGain, u16 DGain)
{
    3224:	ff010113          	addi	sp,sp,-16
    3228:	00112623          	sw	ra,12(sp)
    322c:	00812423          	sw	s0,8(sp)
    3230:	00058413          	mv	s0,a1
	if(PiCam_WriteRegData(ANA_GAIN_GLOBAL_A, AGain&0xFF) )
    3234:	00050593          	mv	a1,a0
    3238:	15700513          	li	a0,343
    323c:	999ff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
    3240:	00050c63          	beqz	a0,3258 <PiCam_Gainfilter+0x34>
		return 1;
    3244:	00100513          	li	a0,1
	PiCam_WriteRegData(DIG_GAIN_GLOBAL_A_1, (DGain>>8)&0x0F);
	PiCam_WriteRegData(DIG_GAIN_GLOBAL_A_0, DGain&0xFF);
}
    3248:	00c12083          	lw	ra,12(sp)
    324c:	00812403          	lw	s0,8(sp)
    3250:	01010113          	addi	sp,sp,16
    3254:	00008067          	ret
	PiCam_WriteRegData(DIG_GAIN_GLOBAL_A_1, (DGain>>8)&0x0F);
    3258:	00845593          	srli	a1,s0,0x8
    325c:	00f5f593          	andi	a1,a1,15
    3260:	15800513          	li	a0,344
    3264:	971ff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
	PiCam_WriteRegData(DIG_GAIN_GLOBAL_A_0, DGain&0xFF);
    3268:	0ff47593          	andi	a1,s0,255
    326c:	15900513          	li	a0,345
    3270:	965ff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
}
    3274:	fd5ff06f          	j	3248 <PiCam_Gainfilter+0x24>

00003278 <PiCam_init>:



int PiCam_init(void)
{
    3278:	ff010113          	addi	sp,sp,-16
    327c:	00112623          	sw	ra,12(sp)
    3280:	00812423          	sw	s0,8(sp)
    3284:	00912223          	sw	s1,4(sp)
   if (PiCam_WriteRegData(mode_select, 0x00) )
    3288:	00000593          	li	a1,0
    328c:	10000513          	li	a0,256
    3290:	945ff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
    3294:	02050063          	beqz	a0,32b4 <PiCam_init+0x3c>
	   return 1;
    3298:	00100413          	li	s0,1
     PiCam_WriteRegData(IMG_ORIENTATION_A, 0x00);

     PiCam_WriteRegData(mode_select, 0x01);

   return 0;
}
    329c:	00040513          	mv	a0,s0
    32a0:	00c12083          	lw	ra,12(sp)
    32a4:	00812403          	lw	s0,8(sp)
    32a8:	00412483          	lw	s1,4(sp)
    32ac:	01010113          	addi	sp,sp,16
    32b0:	00008067          	ret
    32b4:	00050413          	mv	s0,a0
   AccessCommSeq();
    32b8:	b3dff0ef          	jal	ra,2df4 <AccessCommSeq>
   PiCam_WriteRegData(CSI_LANE_MODE, 0x01);
    32bc:	00100593          	li	a1,1
    32c0:	11400513          	li	a0,276
    32c4:	911ff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
   PiCam_WriteRegData(DPHY_CTRL, 0x00);
    32c8:	00000593          	li	a1,0
    32cc:	12800513          	li	a0,296
    32d0:	905ff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
   PiCam_WriteRegData(EXCK_FREQ_1, 0x18);
    32d4:	01800593          	li	a1,24
    32d8:	12a00513          	li	a0,298
    32dc:	8f9ff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
   PiCam_WriteRegData(EXCK_FREQ_0, 0x00);
    32e0:	00000593          	li	a1,0
    32e4:	12b00513          	li	a0,299
    32e8:	8edff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
   PiCam_WriteRegData(FRM_LENGTH_A_1, 0x04);
    32ec:	00400593          	li	a1,4
    32f0:	16000513          	li	a0,352
    32f4:	8e1ff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
   PiCam_WriteRegData(FRM_LENGTH_A_0, 0x59);
    32f8:	05900593          	li	a1,89
    32fc:	16100513          	li	a0,353
    3300:	8d5ff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
   PiCam_WriteRegData(LINE_LENGTH_A_1, 0x0D);
    3304:	00d00593          	li	a1,13
    3308:	16200513          	li	a0,354
    330c:	8c9ff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
   PiCam_WriteRegData(LINE_LENGTH_A_0, 0x78);
    3310:	07800593          	li	a1,120
    3314:	16300513          	li	a0,355
    3318:	8bdff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
   PiCam_Output_activePixel(680, 2599, 690, 1771);
    331c:	6eb00693          	li	a3,1771
    3320:	2b200613          	li	a2,690
    3324:	000015b7          	lui	a1,0x1
    3328:	a2758593          	addi	a1,a1,-1497 # a27 <CUSTOM2+0x9cc>
    332c:	2a800513          	li	a0,680
    3330:	b89ff0ef          	jal	ra,2eb8 <PiCam_Output_activePixel>
   PiCam_Output_Size(1920,1080);
    3334:	43800593          	li	a1,1080
    3338:	78000513          	li	a0,1920
    333c:	b21ff0ef          	jal	ra,2e5c <PiCam_Output_Size>
   PiCam_WriteRegData(X_ODD_INC_A, 0x01);
    3340:	00100593          	li	a1,1
    3344:	17000513          	li	a0,368
    3348:	88dff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
   PiCam_WriteRegData(Y_ODD_INC_A, 0x01);
    334c:	00100593          	li	a1,1
    3350:	17100513          	li	a0,369
    3354:	881ff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
   PiCam_SetBinningMode(0, 0);
    3358:	00000593          	li	a1,0
    335c:	00000513          	li	a0,0
    3360:	cb5ff0ef          	jal	ra,3014 <PiCam_SetBinningMode>
   PiCam_WriteRegData(CSI_DATA_FORMAT_A_1, 0x0A);
    3364:	00a00593          	li	a1,10
    3368:	18c00513          	li	a0,396
    336c:	869ff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
   PiCam_WriteRegData(CSI_DATA_FORMAT_A_0, 0x0A);
    3370:	00a00593          	li	a1,10
    3374:	18d00513          	li	a0,397
    3378:	85dff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
   PiCam_WriteRegData(VTPXCK_DIV, 0x05);
    337c:	00500593          	li	a1,5
    3380:	30100513          	li	a0,769
    3384:	851ff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
   PiCam_WriteRegData(VTSYCK_DIV, 0x01);
    3388:	00100593          	li	a1,1
    338c:	30300513          	li	a0,771
    3390:	845ff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
   PiCam_WriteRegData(PREPLLCK_VT_DIV, 0x03);
    3394:	00300593          	li	a1,3
    3398:	30400513          	li	a0,772
    339c:	839ff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
   PiCam_WriteRegData(PREPLLCK_OP_DIV, 0x03);
    33a0:	00300593          	li	a1,3
    33a4:	30500513          	li	a0,773
    33a8:	82dff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
   PiCam_WriteRegData(PLL_VT_MPY_1, 0x00);
    33ac:	00000593          	li	a1,0
    33b0:	30600513          	li	a0,774
    33b4:	821ff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
   PiCam_WriteRegData(PLL_VT_MPY_0, 0x60);//0x70);
    33b8:	06000593          	li	a1,96
    33bc:	30700513          	li	a0,775
    33c0:	815ff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
   PiCam_WriteRegData(OPPXCK_DIV, 0x0A);
    33c4:	00a00593          	li	a1,10
    33c8:	30900513          	li	a0,777
    33cc:	809ff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
   PiCam_WriteRegData(OPSYCK_DIV, 0x01);
    33d0:	00100593          	li	a1,1
    33d4:	30b00513          	li	a0,779
    33d8:	ffcff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
   PiCam_WriteRegData(PLL_OP_MPY_1, 0x00);
    33dc:	00000593          	li	a1,0
    33e0:	30c00513          	li	a0,780
    33e4:	ff0ff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
   PiCam_WriteRegData(PLL_OP_MPY_0, 0x72);
    33e8:	07200593          	li	a1,114
    33ec:	30d00513          	li	a0,781
    33f0:	fe4ff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
   PiCam_WriteRegData(OPPXCK_DIV, 0x0A);
    33f4:	00a00593          	li	a1,10
    33f8:	30900513          	li	a0,777
    33fc:	fd8ff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
   PiCam_WriteRegData(OPSYCK_DIV, 0x01);
    3400:	00100593          	li	a1,1
    3404:	30b00513          	li	a0,779
    3408:	fccff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
   PiCam_WriteRegData(PLL_OP_MPY_1, 0x00);
    340c:	00000593          	li	a1,0
    3410:	30c00513          	li	a0,780
    3414:	fc0ff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
   PiCam_WriteRegData(PLL_OP_MPY_0, 0x72);
    3418:	07200593          	li	a1,114
    341c:	30d00513          	li	a0,781
    3420:	fb4ff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
   PiCam_Gainfilter(0x40, 0x200);
    3424:	20000593          	li	a1,512
    3428:	04000513          	li	a0,64
    342c:	df9ff0ef          	jal	ra,3224 <PiCam_Gainfilter>
   PiCam_WriteRegData(FRM_LENGTH_A_1, 0x06);
    3430:	00600593          	li	a1,6
    3434:	16000513          	li	a0,352
    3438:	f9cff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
   PiCam_WriteRegData(FRM_LENGTH_A_0, 0xe3);
    343c:	0e300593          	li	a1,227
    3440:	16100513          	li	a0,353
    3444:	f90ff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
   PiCam_WriteRegData(LINE_LENGTH_A_1, 0x0D);
    3448:	00d00593          	li	a1,13
    344c:	16200513          	li	a0,354
    3450:	f84ff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
    PiCam_WriteRegData(LINE_LENGTH_A_0, 0x78);
    3454:	07800593          	li	a1,120
    3458:	16300513          	li	a0,355
    345c:	f78ff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
   PiCam_WriteRegData(COARSE_INTEGRATION_TIME_A_1, 0x04);
    3460:	00400593          	li	a1,4
    3464:	15a00513          	li	a0,346
    3468:	f6cff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
     PiCam_WriteRegData(COARSE_INTEGRATION_TIME_A_0, 0x54);
    346c:	05400593          	li	a1,84
    3470:	15b00513          	li	a0,347
    3474:	f60ff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
	 PiCam_WriteRegData(LSC_ENABLE, 0x01);
    3478:	00100593          	li	a1,1
    347c:	19000513          	li	a0,400
    3480:	f54ff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
     PiCam_WriteRegData(LSC_COLOR_MODE, 0x00);
    3484:	00000593          	li	a1,0
    3488:	19100513          	li	a0,401
    348c:	f48ff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
     PiCam_WriteRegData(LSC_TUNING_ENABLE, 0x01);
    3490:	00100593          	li	a1,1
    3494:	19300513          	li	a0,403
    3498:	f3cff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
     PiCam_WriteRegData(LSC_WHITE_BALANCE_RG_1, 0x00);
    349c:	00000593          	li	a1,0
    34a0:	19400513          	li	a0,404
    34a4:	f30ff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
     PiCam_WriteRegData(LSC_WHITE_BALANCE_RG_0, 0x00);
    34a8:	00000593          	li	a1,0
    34ac:	19500513          	li	a0,405
    34b0:	f24ff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
     PiCam_WriteRegData(LSC_TUNING_COEF_R, 0x00);
    34b4:	00000593          	li	a1,0
    34b8:	19800513          	li	a0,408
    34bc:	f18ff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
     PiCam_WriteRegData(LSC_TUNING_COEF_GR, 0xf0);
    34c0:	0f000593          	li	a1,240
    34c4:	19900513          	li	a0,409
    34c8:	f0cff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
     PiCam_WriteRegData(LSC_TUNING_COEF_GB, 0xf0);
    34cc:	0f000593          	li	a1,240
    34d0:	19a00513          	li	a0,410
    34d4:	f00ff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
     PiCam_WriteRegData(LSC_TUNING_COEF_B, 0x00);
    34d8:	00000593          	li	a1,0
    34dc:	19b00513          	li	a0,411
    34e0:	ef4ff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
     PiCam_WriteRegData(gain_r_1, 0x0A);
    34e4:	00a00593          	li	a1,10
    34e8:	19c00513          	li	a0,412
    34ec:	ee8ff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
     PiCam_WriteRegData(gain_r_0, 0x00);
    34f0:	00000593          	li	a1,0
    34f4:	19d00513          	li	a0,413
    34f8:	edcff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
     PiCam_WriteRegData(gain_GR_1, 0x08);
    34fc:	00800593          	li	a1,8
    3500:	19e00513          	li	a0,414
    3504:	ed0ff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
     PiCam_WriteRegData(gain_GR_0, 0x00);
    3508:	00000593          	li	a1,0
    350c:	19f00513          	li	a0,415
    3510:	ec4ff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
     PiCam_WriteRegData(gain_GB_1, 0x08);
    3514:	00800593          	li	a1,8
    3518:	1a000513          	li	a0,416
    351c:	eb8ff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
     PiCam_WriteRegData(gain_GB_0, 0x00);
    3520:	00000593          	li	a1,0
    3524:	1a100513          	li	a0,417
    3528:	eacff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
     PiCam_WriteRegData(gain_B_1, 0x0C);
    352c:	00c00593          	li	a1,12
    3530:	1a200513          	li	a0,418
    3534:	ea0ff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
     PiCam_WriteRegData(gain_B_0, 0x00);
    3538:	00000593          	li	a1,0
    353c:	1a300513          	li	a0,419
    3540:	e94ff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
     PiCam_WriteRegData(gain_BLACKLEVEL_1, 0x00);
    3544:	00000593          	li	a1,0
    3548:	0000d4b7          	lui	s1,0xd
    354c:	1ea48513          	addi	a0,s1,490 # d1ea <raw_table4+0x38ae>
    3550:	e84ff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
     PiCam_WriteRegData(gain_BLACKLEVEL_0, 0x60);
    3554:	06000593          	li	a1,96
    3558:	1eb48513          	addi	a0,s1,491
    355c:	e78ff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
     PiCam_WriteRegData(IMG_ORIENTATION_A, 0x00);
    3560:	00000593          	li	a1,0
    3564:	17200513          	li	a0,370
    3568:	e6cff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
     PiCam_WriteRegData(mode_select, 0x01);
    356c:	00100593          	li	a1,1
    3570:	10000513          	li	a0,256
    3574:	e60ff0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
   return 0;
    3578:	d25ff06f          	j	329c <PiCam_init+0x24>

0000357c <uart_writeAvailability>:
        return *((volatile u32*) address);
    357c:	00452503          	lw	a0,4(a0) # f8017004 <__freertos_irq_stack_top+0xf7fc3594>
*          of available spaces for writing data from bits 23 to 16. It then
*          returns this value after masking with 0xFF.
*
******************************************************************************/
    static u32 uart_writeAvailability(u32 reg){
        return (read_u32(reg + UART_STATUS) >> 16) & 0xFF;
    3580:	01055513          	srli	a0,a0,0x10
    }
    3584:	0ff57513          	andi	a0,a0,255
    3588:	00008067          	ret

0000358c <uart_write>:
* @note    The function waits until there is available space in the UART buffer
*          for writing data. Once space is available, it writes the character
*          data to the UART data register.
*
******************************************************************************/
    static void uart_write(u32 reg, char data){
    358c:	ff010113          	addi	sp,sp,-16
    3590:	00112623          	sw	ra,12(sp)
    3594:	00812423          	sw	s0,8(sp)
    3598:	00912223          	sw	s1,4(sp)
    359c:	00050413          	mv	s0,a0
    35a0:	00058493          	mv	s1,a1
        while(uart_writeAvailability(reg) == 0);
    35a4:	00040513          	mv	a0,s0
    35a8:	fd5ff0ef          	jal	ra,357c <uart_writeAvailability>
    35ac:	fe050ce3          	beqz	a0,35a4 <uart_write+0x18>
        *((volatile u32*) address) = data;
    35b0:	00942023          	sw	s1,0(s0)
        write_u32(data, reg + UART_DATA);
    }
    35b4:	00c12083          	lw	ra,12(sp)
    35b8:	00812403          	lw	s0,8(sp)
    35bc:	00412483          	lw	s1,4(sp)
    35c0:	01010113          	addi	sp,sp,16
    35c4:	00008067          	ret

000035c8 <uart_writeStr>:
*
* @note    The function iterates through each character of the string and writes
*          them one by one to the UART buffer using the uart_write function.
*
******************************************************************************/
    static void uart_writeStr(u32 reg, const char* str){
    35c8:	ff010113          	addi	sp,sp,-16
    35cc:	00112623          	sw	ra,12(sp)
    35d0:	00812423          	sw	s0,8(sp)
    35d4:	00912223          	sw	s1,4(sp)
    35d8:	00050493          	mv	s1,a0
    35dc:	00058413          	mv	s0,a1
        while(*str) uart_write(reg, *str++);
    35e0:	00044583          	lbu	a1,0(s0)
    35e4:	00058a63          	beqz	a1,35f8 <uart_writeStr+0x30>
    35e8:	00140413          	addi	s0,s0,1
    35ec:	00048513          	mv	a0,s1
    35f0:	f9dff0ef          	jal	ra,358c <uart_write>
    35f4:	fedff06f          	j	35e0 <uart_writeStr+0x18>
    }
    35f8:	00c12083          	lw	ra,12(sp)
    35fc:	00812403          	lw	s0,8(sp)
    3600:	00412483          	lw	s1,4(sp)
    3604:	01010113          	addi	sp,sp,16
    3608:	00008067          	ret

0000360c <plic_set_priority>:
*          specified priority value to the calculated address, effectively
*          setting the priority for the specified interrupt gateway in the PLIC.
*
******************************************************************************/
    static void plic_set_priority(u32 plic, u32 gateway, u32 priority){
        write_u32(priority, plic + PLIC_PRIORITY_BASE + gateway*4);
    360c:	00259593          	slli	a1,a1,0x2
    3610:	00a585b3          	add	a1,a1,a0
    3614:	00c5a023          	sw	a2,0(a1)
    }
    3618:	00008067          	ret

0000361c <plic_set_enable>:
*          to the enable register.
*
******************************************************************************/

    static void plic_set_enable(u32 plic, u32 target,u32 gateway, u32 enable){
        u32 word = plic + PLIC_ENABLE_BASE + target * PLIC_ENABLE_PER_HART + (gateway / 32 * 4);
    361c:	00759593          	slli	a1,a1,0x7
    3620:	00a58533          	add	a0,a1,a0
    3624:	00565593          	srli	a1,a2,0x5
    3628:	00259593          	slli	a1,a1,0x2
    362c:	00b50533          	add	a0,a0,a1
    3630:	000025b7          	lui	a1,0x2
    3634:	00b50533          	add	a0,a0,a1
        u32 mask = 1 << (gateway % 32);
    3638:	00100793          	li	a5,1
    363c:	00c797b3          	sll	a5,a5,a2
        if (enable)
    3640:	00068a63          	beqz	a3,3654 <plic_set_enable+0x38>
        return *((volatile u32*) address);
    3644:	00052603          	lw	a2,0(a0)
            write_u32(read_u32(word) | mask, word);
    3648:	00c7e7b3          	or	a5,a5,a2
        *((volatile u32*) address) = data;
    364c:	00f52023          	sw	a5,0(a0)
    3650:	00008067          	ret
        return *((volatile u32*) address);
    3654:	00052603          	lw	a2,0(a0)
        else
            write_u32(read_u32(word) & ~mask, word);
    3658:	fff7c793          	not	a5,a5
    365c:	00c7f7b3          	and	a5,a5,a2
        *((volatile u32*) address) = data;
    3660:	00f52023          	sw	a5,0(a0)
    }
    3664:	00008067          	ret

00003668 <plic_set_threshold>:
*          to the calculated address, effectively setting the threshold for the
*          specified target in the PLIC.
*
******************************************************************************/   
    static void plic_set_threshold(u32 plic, u32 target, u32 threshold){
        write_u32(threshold, plic + PLIC_THRESHOLD_BASE + target*PLIC_CONTEXT_PER_HART);
    3668:	00c59593          	slli	a1,a1,0xc
    366c:	00a585b3          	add	a1,a1,a0
    3670:	00200537          	lui	a0,0x200
    3674:	00a585b3          	add	a1,a1,a0
    3678:	00c5a023          	sw	a2,0(a1) # 2000 <_reclaim_reent+0x30>
    }
    367c:	00008067          	ret

00003680 <plic_claim>:
*          value from the calculated address, effectively claiming an interrupt
*          for the specified target in the PLIC.
*
******************************************************************************/
    static u32 plic_claim(u32 plic, u32 target){
        return read_u32(plic + PLIC_CLAIM_BASE + target*PLIC_CONTEXT_PER_HART);
    3680:	00c59593          	slli	a1,a1,0xc
    3684:	00a585b3          	add	a1,a1,a0
    3688:	00200537          	lui	a0,0x200
    368c:	00450513          	addi	a0,a0,4 # 200004 <__freertos_irq_stack_top+0x1ac594>
    3690:	00a585b3          	add	a1,a1,a0
        return *((volatile u32*) address);
    3694:	0005a503          	lw	a0,0(a1)
    }
    3698:	00008067          	ret

0000369c <plic_release>:
*          to the calculated address, effectively releasing the claimed interrupt
*          for the specified target in the PLIC.
*
******************************************************************************/
    static void plic_release(u32 plic, u32 target, u32 gateway){
        write_u32(gateway,plic + PLIC_CLAIM_BASE + target*PLIC_CONTEXT_PER_HART);
    369c:	00c59593          	slli	a1,a1,0xc
    36a0:	00a585b3          	add	a1,a1,a0
    36a4:	00200537          	lui	a0,0x200
    36a8:	00450513          	addi	a0,a0,4 # 200004 <__freertos_irq_stack_top+0x1ac594>
    36ac:	00a585b3          	add	a1,a1,a0
        *((volatile u32*) address) = data;
    36b0:	00c5a023          	sw	a2,0(a1)
    }
    36b4:	00008067          	ret

000036b8 <dmasg_interrupt_pending_clear>:
* @param mask: Bitmask specifying which interrupts to clear
*
* @note Mask it with 0xFFFFFFFF to clear them all.
*******************************************************************************/
    static void dmasg_interrupt_pending_clear(u32 base, u32 channel, u32 mask){
        u32 ca = dmasg_ca(base, channel);
    36b8:	00759593          	slli	a1,a1,0x7
    36bc:	00a585b3          	add	a1,a1,a0
    36c0:	04c5aa23          	sw	a2,84(a1)
        write_u32(mask, ca+DMASG_CHANNEL_INTERRUPT_PENDING);
    }
    36c4:	00008067          	ret

000036c8 <dmasg_read_channelState>:
	sd_ctrl_write(dev,SDHC_ADDR+REG_NORMAL_INTERRUPT_STATUS1+4,INT_ENABLE);
}

// Check the status of the specified channel.
static u32 dmasg_read_channelState(u32 base, u32 channel , u32 mask){
    u32 ca = dmasg_ca(base, channel);
    36c8:	00759593          	slli	a1,a1,0x7
    36cc:	00a585b3          	add	a1,a1,a0
        return *((volatile u32*) address);
    36d0:	0545a503          	lw	a0,84(a1)
    return read_u32(ca + DMASG_CHANNEL_INTERRUPT_PENDING) & mask;
}
    36d4:	00a67533          	and	a0,a2,a0
    36d8:	00008067          	ret

000036dc <printb>:
void printb(uint8_t * data) {
    36dc:	ff010113          	addi	sp,sp,-16
    36e0:	00112623          	sw	ra,12(sp)
      uart_writeStr(BSP_UART_TERMINAL, data);
    36e4:	00050593          	mv	a1,a0
    36e8:	f8010537          	lui	a0,0xf8010
    36ec:	eddff0ef          	jal	ra,35c8 <uart_writeStr>
    }
    36f0:	00c12083          	lw	ra,12(sp)
    36f4:	01010113          	addi	sp,sp,16
    36f8:	00008067          	ret

000036fc <print_hexb>:
{
    36fc:	ff010113          	addi	sp,sp,-16
    3700:	00112623          	sw	ra,12(sp)
    3704:	00812423          	sw	s0,8(sp)
    3708:	00912223          	sw	s1,4(sp)
    370c:	00050493          	mv	s1,a0
    for (int i = (4*digits)-4; i >= 0; i -= 4)
    3710:	40000437          	lui	s0,0x40000
    3714:	fff40413          	addi	s0,s0,-1 # 3fffffff <__freertos_irq_stack_top+0x3ffac58f>
    3718:	00858433          	add	s0,a1,s0
    371c:	00241413          	slli	s0,s0,0x2
    3720:	02044663          	bltz	s0,374c <print_hexb+0x50>
        uart_write(BSP_UART_TERMINAL, "0123456789ABCDEF"[(val >> i) % 16]);
    3724:	0084d7b3          	srl	a5,s1,s0
    3728:	00f7f713          	andi	a4,a5,15
    372c:	000097b7          	lui	a5,0x9
    3730:	a7c78793          	addi	a5,a5,-1412 # 8a7c <_data+0x68>
    3734:	00e787b3          	add	a5,a5,a4
    3738:	0007c583          	lbu	a1,0(a5)
    373c:	f8010537          	lui	a0,0xf8010
    3740:	e4dff0ef          	jal	ra,358c <uart_write>
    for (int i = (4*digits)-4; i >= 0; i -= 4)
    3744:	ffc40413          	addi	s0,s0,-4
    3748:	fd9ff06f          	j	3720 <print_hexb+0x24>
}
    374c:	00c12083          	lw	ra,12(sp)
    3750:	00812403          	lw	s0,8(sp)
    3754:	00412483          	lw	s1,4(sp)
    3758:	01010113          	addi	sp,sp,16
    375c:	00008067          	ret

00003760 <UserInterruptSDIsr>:
{
    3760:	ff010113          	addi	sp,sp,-16
    3764:	00112623          	sw	ra,12(sp)
    3768:	00812423          	sw	s0,8(sp)
	sd_ctrl_write(dev,SDHC_ADDR+REG_NORMAL_INTERRUPT_STATUS1+4,0x00);
    376c:	00000613          	li	a2,0
    3770:	13800593          	li	a1,312
    3774:	bbc1a503          	lw	a0,-1092(gp) # 5240c <dev>
    3778:	9adfe0ef          	jal	ra,2124 <sd_ctrl_write>
	int_status = sd_ctrl_read(dev,SDHC_ADDR+REG_NORMAL_INTERRUPT_STATUS0);
    377c:	13000593          	li	a1,304
    3780:	bbc1a503          	lw	a0,-1092(gp) # 5240c <dev>
    3784:	9b1fe0ef          	jal	ra,2134 <sd_ctrl_read>
    3788:	00050413          	mv	s0,a0
	if(int_status&INT_COMMAND_COMPLETE) {
    378c:	00157793          	andi	a5,a0,1
    3790:	06079e63          	bnez	a5,380c <UserInterruptSDIsr+0xac>
	if(int_status&INT_TRANSFER_COMPLETE) {
    3794:	00247793          	andi	a5,s0,2
    3798:	08079863          	bnez	a5,3828 <UserInterruptSDIsr+0xc8>
	if(int_status&INT_BLOCK_GAP_EVENT) {
    379c:	00447793          	andi	a5,s0,4
    37a0:	0a079463          	bnez	a5,3848 <UserInterruptSDIsr+0xe8>
	if(int_status&INT_BUFFER_WRITE_READY) {
    37a4:	01047793          	andi	a5,s0,16
    37a8:	0c079063          	bnez	a5,3868 <UserInterruptSDIsr+0x108>
	if(int_status&INT_BUFFER_READ_READY) {
    37ac:	02047793          	andi	a5,s0,32
    37b0:	0c079663          	bnez	a5,387c <UserInterruptSDIsr+0x11c>
	if(int_status&INT_CARD_INSERTION) {
    37b4:	04047793          	andi	a5,s0,64
    37b8:	0c079c63          	bnez	a5,3890 <UserInterruptSDIsr+0x130>
	if(int_status&INT_CARD_REMOVAL) {
    37bc:	08047793          	andi	a5,s0,128
    37c0:	0e079863          	bnez	a5,38b0 <UserInterruptSDIsr+0x150>
	if(int_status&INT_COMMAND_TIMEOUT_ERROR) {
    37c4:	00f41793          	slli	a5,s0,0xf
    37c8:	1007c463          	bltz	a5,38d0 <UserInterruptSDIsr+0x170>
	if(int_status&INT_COMMAND_CRC_ERROR) {
    37cc:	00e41793          	slli	a5,s0,0xe
    37d0:	1207c063          	bltz	a5,38f0 <UserInterruptSDIsr+0x190>
	if(int_status&INT_COMMAND_END_BIT_ERROR) {
    37d4:	00d41793          	slli	a5,s0,0xd
    37d8:	1207cc63          	bltz	a5,3910 <UserInterruptSDIsr+0x1b0>
	if(int_status&INT_COMMAND_INDEX_ERROR) {
    37dc:	00c41793          	slli	a5,s0,0xc
    37e0:	1407c863          	bltz	a5,3930 <UserInterruptSDIsr+0x1d0>
	if(int_status&INT_DATA_CRC_ERROR) {
    37e4:	00a41793          	slli	a5,s0,0xa
    37e8:	1607c463          	bltz	a5,3950 <UserInterruptSDIsr+0x1f0>
	sd_ctrl_write(dev,SDHC_ADDR+REG_NORMAL_INTERRUPT_STATUS1+4,INT_ENABLE);
    37ec:	fcf00613          	li	a2,-49
    37f0:	13800593          	li	a1,312
    37f4:	bbc1a503          	lw	a0,-1092(gp) # 5240c <dev>
    37f8:	92dfe0ef          	jal	ra,2124 <sd_ctrl_write>
}
    37fc:	00c12083          	lw	ra,12(sp)
    3800:	00812403          	lw	s0,8(sp)
    3804:	01010113          	addi	sp,sp,16
    3808:	00008067          	ret
		IntPtr.command_complete = 0x1;
    380c:	00100713          	li	a4,1
    3810:	bce1aa23          	sw	a4,-1068(gp) # 52424 <IntPtr>
		sd_ctrl_write(dev,SDHC_ADDR+REG_NORMAL_INTERRUPT_STATUS0,INT_COMMAND_COMPLETE);
    3814:	00100613          	li	a2,1
    3818:	13000593          	li	a1,304
    381c:	bbc1a503          	lw	a0,-1092(gp) # 5240c <dev>
    3820:	905fe0ef          	jal	ra,2124 <sd_ctrl_write>
		if(DEBUG_PRINTF_EN == 1) {
    3824:	f71ff06f          	j	3794 <UserInterruptSDIsr+0x34>
		IntPtr.transfer_complete = 0x1;
    3828:	bd418793          	addi	a5,gp,-1068 # 52424 <IntPtr>
    382c:	00100713          	li	a4,1
    3830:	00e7a223          	sw	a4,4(a5)
		sd_ctrl_write(dev,SDHC_ADDR+REG_NORMAL_INTERRUPT_STATUS0,INT_TRANSFER_COMPLETE);
    3834:	00200613          	li	a2,2
    3838:	13000593          	li	a1,304
    383c:	bbc1a503          	lw	a0,-1092(gp) # 5240c <dev>
    3840:	8e5fe0ef          	jal	ra,2124 <sd_ctrl_write>
		if(DEBUG_PRINTF_EN == 1) {
    3844:	f59ff06f          	j	379c <UserInterruptSDIsr+0x3c>
		IntPtr.block_gap_event = 0x1;
    3848:	bd418793          	addi	a5,gp,-1068 # 52424 <IntPtr>
    384c:	00100713          	li	a4,1
    3850:	00e7a423          	sw	a4,8(a5)
		sd_ctrl_write(dev,SDHC_ADDR+REG_NORMAL_INTERRUPT_STATUS0,INT_BLOCK_GAP_EVENT);
    3854:	00400613          	li	a2,4
    3858:	13000593          	li	a1,304
    385c:	bbc1a503          	lw	a0,-1092(gp) # 5240c <dev>
    3860:	8c5fe0ef          	jal	ra,2124 <sd_ctrl_write>
		if(DEBUG_PRINTF_EN == 1) {
    3864:	f41ff06f          	j	37a4 <UserInterruptSDIsr+0x44>
		sd_ctrl_write(dev,SDHC_ADDR+REG_NORMAL_INTERRUPT_STATUS0,INT_BUFFER_WRITE_READY);
    3868:	01000613          	li	a2,16
    386c:	13000593          	li	a1,304
    3870:	bbc1a503          	lw	a0,-1092(gp) # 5240c <dev>
    3874:	8b1fe0ef          	jal	ra,2124 <sd_ctrl_write>
		if(DEBUG_PRINTF_EN == 1) {
    3878:	f35ff06f          	j	37ac <UserInterruptSDIsr+0x4c>
		sd_ctrl_write(dev,SDHC_ADDR+REG_NORMAL_INTERRUPT_STATUS0,INT_BUFFER_READ_READY);
    387c:	02000613          	li	a2,32
    3880:	13000593          	li	a1,304
    3884:	bbc1a503          	lw	a0,-1092(gp) # 5240c <dev>
    3888:	89dfe0ef          	jal	ra,2124 <sd_ctrl_write>
		if(DEBUG_PRINTF_EN == 1) {
    388c:	f29ff06f          	j	37b4 <UserInterruptSDIsr+0x54>
		IntPtr.card_insertion = 0x1;
    3890:	bd418793          	addi	a5,gp,-1068 # 52424 <IntPtr>
    3894:	00100713          	li	a4,1
    3898:	00e7aa23          	sw	a4,20(a5)
		sd_ctrl_write(dev,SDHC_ADDR+REG_NORMAL_INTERRUPT_STATUS0,INT_CARD_INSERTION);
    389c:	04000613          	li	a2,64
    38a0:	13000593          	li	a1,304
    38a4:	bbc1a503          	lw	a0,-1092(gp) # 5240c <dev>
    38a8:	87dfe0ef          	jal	ra,2124 <sd_ctrl_write>
		if(DEBUG_PRINTF_EN == 1) {
    38ac:	f11ff06f          	j	37bc <UserInterruptSDIsr+0x5c>
		IntPtr.card_removal = 0x1;
    38b0:	bd418793          	addi	a5,gp,-1068 # 52424 <IntPtr>
    38b4:	00100713          	li	a4,1
    38b8:	00e7ac23          	sw	a4,24(a5)
		sd_ctrl_write(dev,SDHC_ADDR+REG_NORMAL_INTERRUPT_STATUS0,INT_CARD_REMOVAL);
    38bc:	08000613          	li	a2,128
    38c0:	13000593          	li	a1,304
    38c4:	bbc1a503          	lw	a0,-1092(gp) # 5240c <dev>
    38c8:	85dfe0ef          	jal	ra,2124 <sd_ctrl_write>
		if(DEBUG_PRINTF_EN == 1) {
    38cc:	ef9ff06f          	j	37c4 <UserInterruptSDIsr+0x64>
		IntPtr.command_timeout_error = 0x1;
    38d0:	bd418793          	addi	a5,gp,-1068 # 52424 <IntPtr>
    38d4:	00100713          	li	a4,1
    38d8:	00e7ae23          	sw	a4,28(a5)
		sd_ctrl_write(dev,SDHC_ADDR+REG_NORMAL_INTERRUPT_STATUS0,INT_COMMAND_TIMEOUT_ERROR);
    38dc:	00010637          	lui	a2,0x10
    38e0:	13000593          	li	a1,304
    38e4:	bbc1a503          	lw	a0,-1092(gp) # 5240c <dev>
    38e8:	83dfe0ef          	jal	ra,2124 <sd_ctrl_write>
		if(DEBUG_PRINTF_EN == 1) {
    38ec:	ee1ff06f          	j	37cc <UserInterruptSDIsr+0x6c>
		IntPtr.command_crc_error = 0x1;
    38f0:	bd418793          	addi	a5,gp,-1068 # 52424 <IntPtr>
    38f4:	00100713          	li	a4,1
    38f8:	02e7a023          	sw	a4,32(a5)
		sd_ctrl_write(dev,SDHC_ADDR+REG_NORMAL_INTERRUPT_STATUS0,INT_COMMAND_CRC_ERROR);
    38fc:	00020637          	lui	a2,0x20
    3900:	13000593          	li	a1,304
    3904:	bbc1a503          	lw	a0,-1092(gp) # 5240c <dev>
    3908:	81dfe0ef          	jal	ra,2124 <sd_ctrl_write>
		if(DEBUG_PRINTF_EN == 1) {
    390c:	ec9ff06f          	j	37d4 <UserInterruptSDIsr+0x74>
		IntPtr.command_end_bit_error = 0x1;
    3910:	bd418793          	addi	a5,gp,-1068 # 52424 <IntPtr>
    3914:	00100713          	li	a4,1
    3918:	02e7a223          	sw	a4,36(a5)
		sd_ctrl_write(dev,SDHC_ADDR+REG_NORMAL_INTERRUPT_STATUS0,INT_COMMAND_END_BIT_ERROR);
    391c:	00040637          	lui	a2,0x40
    3920:	13000593          	li	a1,304
    3924:	bbc1a503          	lw	a0,-1092(gp) # 5240c <dev>
    3928:	ffcfe0ef          	jal	ra,2124 <sd_ctrl_write>
		if(DEBUG_PRINTF_EN == 1) {
    392c:	eb1ff06f          	j	37dc <UserInterruptSDIsr+0x7c>
		IntPtr.command_index_error = 0x1;
    3930:	bd418793          	addi	a5,gp,-1068 # 52424 <IntPtr>
    3934:	00100713          	li	a4,1
    3938:	02e7a423          	sw	a4,40(a5)
		sd_ctrl_write(dev,SDHC_ADDR+REG_NORMAL_INTERRUPT_STATUS0,INT_COMMAND_INDEX_ERROR);
    393c:	00080637          	lui	a2,0x80
    3940:	13000593          	li	a1,304
    3944:	bbc1a503          	lw	a0,-1092(gp) # 5240c <dev>
    3948:	fdcfe0ef          	jal	ra,2124 <sd_ctrl_write>
		if(DEBUG_PRINTF_EN == 1) {
    394c:	e99ff06f          	j	37e4 <UserInterruptSDIsr+0x84>
		sd_ctrl_write(dev,SDHC_ADDR+REG_NORMAL_INTERRUPT_STATUS0,INT_DATA_CRC_ERROR);
    3950:	00200637          	lui	a2,0x200
    3954:	13000593          	li	a1,304
    3958:	bbc1a503          	lw	a0,-1092(gp) # 5240c <dev>
    395c:	fc8fe0ef          	jal	ra,2124 <sd_ctrl_write>
		if(DEBUG_PRINTF_EN == 1) {
    3960:	e8dff06f          	j	37ec <UserInterruptSDIsr+0x8c>

00003964 <UserInterruptDMAIsr>:



void UserInterruptDMAIsr(){
    3964:	ff010113          	addi	sp,sp,-16
    3968:	00112623          	sw	ra,12(sp)


	if (dmasg_read_channelState(DMASG_BASE, DMASG_CHANNEL0, DMASG_CHANNEL_INTERRUPT_INPUT_PACKET_MASK) )
    396c:	01000613          	li	a2,16
    3970:	00000593          	li	a1,0
    3974:	f8130537          	lui	a0,0xf8130
    3978:	d51ff0ef          	jal	ra,36c8 <dmasg_read_channelState>
    397c:	04051663          	bnez	a0,39c8 <UserInterruptDMAIsr+0x64>
			ChannelCount[0] =0;
			flashled ^= 0x01;
			APB3_REGW(OOB_APB_SLV, APB3_SLV_REG_LED_CONTROL, flashled);
		}
	}
	if (dmasg_read_channelState(DMASG_BASE, DMASG_CHANNEL1, DMASG_CHANNEL_INTERRUPT_INPUT_PACKET_MASK) )
    3980:	01000613          	li	a2,16
    3984:	00100593          	li	a1,1
    3988:	f8130537          	lui	a0,0xf8130
    398c:	d3dff0ef          	jal	ra,36c8 <dmasg_read_channelState>
    3990:	06051e63          	bnez	a0,3a0c <UserInterruptDMAIsr+0xa8>
			ChannelCount[1] =0;
			flashled ^= 0x02;
			APB3_REGW(OOB_APB_SLV, APB3_SLV_REG_LED_CONTROL, flashled);
		}
	}
	if (dmasg_read_channelState(DMASG_BASE, DMASG_CHANNEL2, DMASG_CHANNEL_INTERRUPT_INPUT_PACKET_MASK) )
    3994:	01000613          	li	a2,16
    3998:	00200593          	li	a1,2
    399c:	f8130537          	lui	a0,0xf8130
    39a0:	d29ff0ef          	jal	ra,36c8 <dmasg_read_channelState>
    39a4:	0a051863          	bnez	a0,3a54 <UserInterruptDMAIsr+0xf0>
			ChannelCount[2] =0;
			flashled ^= 0x04;
			APB3_REGW(OOB_APB_SLV, APB3_SLV_REG_LED_CONTROL, flashled);
		}
	}
	if (dmasg_read_channelState(DMASG_BASE, DMASG_CHANNEL3, DMASG_CHANNEL_INTERRUPT_INPUT_PACKET_MASK) )
    39a8:	01000613          	li	a2,16
    39ac:	00300593          	li	a1,3
    39b0:	f8130537          	lui	a0,0xf8130
    39b4:	d15ff0ef          	jal	ra,36c8 <dmasg_read_channelState>
    39b8:	0e051263          	bnez	a0,3a9c <UserInterruptDMAIsr+0x138>
		APB3_REGW(OOB_APB_SLV, APB3_SLV0_REG4_DEBUG, 0x00);
	//	uart_writeStr(UART_0, "DMA CH1*\n");
	}*/

	//uart_writeStr(UART_0,"INT : Interrupt B\n\r");
}
    39bc:	00c12083          	lw	ra,12(sp)
    39c0:	01010113          	addi	sp,sp,16
    39c4:	00008067          	ret
		dmasg_interrupt_pending_clear(DMASG_BASE, DMASG_CHANNEL0, DMASG_CHANNEL_INTERRUPT_INPUT_PACKET_MASK);  //Disable dmasg channel interrupt
    39c8:	01000613          	li	a2,16
    39cc:	00000593          	li	a1,0
    39d0:	f8130537          	lui	a0,0xf8130
    39d4:	ce5ff0ef          	jal	ra,36b8 <dmasg_interrupt_pending_clear>
		ChannelCount[0]++;
    39d8:	bc418713          	addi	a4,gp,-1084 # 52414 <ChannelCount>
    39dc:	00072783          	lw	a5,0(a4)
    39e0:	00178793          	addi	a5,a5,1
    39e4:	00f72023          	sw	a5,0(a4)
		if(ChannelCount[0]>=10)
    39e8:	00900713          	li	a4,9
    39ec:	f8f75ae3          	bge	a4,a5,3980 <UserInterruptDMAIsr+0x1c>
			ChannelCount[0] =0;
    39f0:	bc01a223          	sw	zero,-1084(gp) # 52414 <ChannelCount>
			flashled ^= 0x01;
    39f4:	bc01a783          	lw	a5,-1088(gp) # 52410 <flashled>
    39f8:	0017c793          	xori	a5,a5,1
    39fc:	bcf1a023          	sw	a5,-1088(gp) # 52410 <flashled>
        *((volatile u32*) address) = data;
    3a00:	f8110737          	lui	a4,0xf8110
    3a04:	00f72223          	sw	a5,4(a4) # f8110004 <__freertos_irq_stack_top+0xf80bc594>
    3a08:	f79ff06f          	j	3980 <UserInterruptDMAIsr+0x1c>
		dmasg_interrupt_pending_clear(DMASG_BASE, DMASG_CHANNEL1, DMASG_CHANNEL_INTERRUPT_INPUT_PACKET_MASK);  //Disable dmasg channel interrupt
    3a0c:	01000613          	li	a2,16
    3a10:	00100593          	li	a1,1
    3a14:	f8130537          	lui	a0,0xf8130
    3a18:	ca1ff0ef          	jal	ra,36b8 <dmasg_interrupt_pending_clear>
		ChannelCount[1]++;
    3a1c:	bc418713          	addi	a4,gp,-1084 # 52414 <ChannelCount>
    3a20:	00472783          	lw	a5,4(a4)
    3a24:	00178793          	addi	a5,a5,1
    3a28:	00f72223          	sw	a5,4(a4)
		if(ChannelCount[1]>=10)
    3a2c:	00900713          	li	a4,9
    3a30:	f6f752e3          	bge	a4,a5,3994 <UserInterruptDMAIsr+0x30>
			ChannelCount[1] =0;
    3a34:	bc418793          	addi	a5,gp,-1084 # 52414 <ChannelCount>
    3a38:	0007a223          	sw	zero,4(a5)
			flashled ^= 0x02;
    3a3c:	bc01a783          	lw	a5,-1088(gp) # 52410 <flashled>
    3a40:	0027c793          	xori	a5,a5,2
    3a44:	bcf1a023          	sw	a5,-1088(gp) # 52410 <flashled>
    3a48:	f8110737          	lui	a4,0xf8110
    3a4c:	00f72223          	sw	a5,4(a4) # f8110004 <__freertos_irq_stack_top+0xf80bc594>
    3a50:	f45ff06f          	j	3994 <UserInterruptDMAIsr+0x30>
		dmasg_interrupt_pending_clear(DMASG_BASE, DMASG_CHANNEL2, DMASG_CHANNEL_INTERRUPT_INPUT_PACKET_MASK);  //Disable dmasg channel interrupt
    3a54:	01000613          	li	a2,16
    3a58:	00200593          	li	a1,2
    3a5c:	f8130537          	lui	a0,0xf8130
    3a60:	c59ff0ef          	jal	ra,36b8 <dmasg_interrupt_pending_clear>
		ChannelCount[2]++;
    3a64:	bc418713          	addi	a4,gp,-1084 # 52414 <ChannelCount>
    3a68:	00872783          	lw	a5,8(a4)
    3a6c:	00178793          	addi	a5,a5,1
    3a70:	00f72423          	sw	a5,8(a4)
		if(ChannelCount[2]>=10)
    3a74:	00900713          	li	a4,9
    3a78:	f2f758e3          	bge	a4,a5,39a8 <UserInterruptDMAIsr+0x44>
			ChannelCount[2] =0;
    3a7c:	bc418793          	addi	a5,gp,-1084 # 52414 <ChannelCount>
    3a80:	0007a423          	sw	zero,8(a5)
			flashled ^= 0x04;
    3a84:	bc01a783          	lw	a5,-1088(gp) # 52410 <flashled>
    3a88:	0047c793          	xori	a5,a5,4
    3a8c:	bcf1a023          	sw	a5,-1088(gp) # 52410 <flashled>
    3a90:	f8110737          	lui	a4,0xf8110
    3a94:	00f72223          	sw	a5,4(a4) # f8110004 <__freertos_irq_stack_top+0xf80bc594>
    3a98:	f11ff06f          	j	39a8 <UserInterruptDMAIsr+0x44>
		dmasg_interrupt_pending_clear(DMASG_BASE, DMASG_CHANNEL3, DMASG_CHANNEL_INTERRUPT_INPUT_PACKET_MASK);  //Disable dmasg channel interrupt
    3a9c:	01000613          	li	a2,16
    3aa0:	00300593          	li	a1,3
    3aa4:	f8130537          	lui	a0,0xf8130
    3aa8:	c11ff0ef          	jal	ra,36b8 <dmasg_interrupt_pending_clear>
		ChannelCount[3]++;
    3aac:	bc418713          	addi	a4,gp,-1084 # 52414 <ChannelCount>
    3ab0:	00c72783          	lw	a5,12(a4)
    3ab4:	00178793          	addi	a5,a5,1
    3ab8:	00f72623          	sw	a5,12(a4)
		if(ChannelCount[3]>=10)
    3abc:	00900713          	li	a4,9
    3ac0:	eef75ee3          	bge	a4,a5,39bc <UserInterruptDMAIsr+0x58>
			ChannelCount[3] =0;
    3ac4:	bc418793          	addi	a5,gp,-1084 # 52414 <ChannelCount>
    3ac8:	0007a623          	sw	zero,12(a5)
			flashled ^= 0x08;
    3acc:	bc01a783          	lw	a5,-1088(gp) # 52410 <flashled>
    3ad0:	0087c793          	xori	a5,a5,8
    3ad4:	bcf1a023          	sw	a5,-1088(gp) # 52410 <flashled>
    3ad8:	f8110737          	lui	a4,0xf8110
    3adc:	00f72223          	sw	a5,4(a4) # f8110004 <__freertos_irq_stack_top+0xf80bc594>
}
    3ae0:	eddff06f          	j	39bc <UserInterruptDMAIsr+0x58>

00003ae4 <crash>:

/********************************* Function **********************************/
//Used on unexpected trap/interrupt codes
void crash(){
    3ae4:	ff010113          	addi	sp,sp,-16
    3ae8:	00112623          	sw	ra,12(sp)
	uart_writeStr(UART_0, "\n*** CRASH ***\n");
    3aec:	000095b7          	lui	a1,0x9
    3af0:	a9058593          	addi	a1,a1,-1392 # 8a90 <_data+0x7c>
    3af4:	f8010537          	lui	a0,0xf8010
    3af8:	ad1ff0ef          	jal	ra,35c8 <uart_writeStr>
	while(1);
    3afc:	0000006f          	j	3afc <crash+0x18>

00003b00 <crash_test>:
}

void crash_test(uint32_t value){
    3b00:	ff010113          	addi	sp,sp,-16
    3b04:	00112623          	sw	ra,12(sp)
    3b08:	00812423          	sw	s0,8(sp)
    3b0c:	00050413          	mv	s0,a0

	printb(" with value 0x");
    3b10:	00009537          	lui	a0,0x9
    3b14:	aa050513          	addi	a0,a0,-1376 # 8aa0 <_data+0x8c>
    3b18:	bc5ff0ef          	jal	ra,36dc <printb>

	print_hexb(value, 8);
    3b1c:	00800593          	li	a1,8
    3b20:	00040513          	mv	a0,s0
    3b24:	bd9ff0ef          	jal	ra,36fc <print_hexb>
				printb(" \n\r");
    3b28:	00051537          	lui	a0,0x51
    3b2c:	5d450513          	addi	a0,a0,1492 # 515d4 <raw_table+0xe638>
    3b30:	badff0ef          	jal	ra,36dc <printb>
	uart_writeStr(UART_0, "\n*** CRASH ***\n");
    3b34:	000095b7          	lui	a1,0x9
    3b38:	a9058593          	addi	a1,a1,-1392 # 8a90 <_data+0x7c>
    3b3c:	f8010537          	lui	a0,0xf8010
    3b40:	a89ff0ef          	jal	ra,35c8 <uart_writeStr>
	while(1);
    3b44:	0000006f          	j	3b44 <crash_test+0x44>

00003b48 <crash_testB>:
}

void crash_testB(uint32_t value){
    3b48:	ff010113          	addi	sp,sp,-16
    3b4c:	00112623          	sw	ra,12(sp)
    3b50:	00812423          	sw	s0,8(sp)
    3b54:	00050413          	mv	s0,a0

	printb(" with value 0x");
    3b58:	00009537          	lui	a0,0x9
    3b5c:	aa050513          	addi	a0,a0,-1376 # 8aa0 <_data+0x8c>
    3b60:	b7dff0ef          	jal	ra,36dc <printb>

	print_hexb(value, 8);
    3b64:	00800593          	li	a1,8
    3b68:	00040513          	mv	a0,s0
    3b6c:	b91ff0ef          	jal	ra,36fc <print_hexb>
				printb(" \n\r");
    3b70:	00051537          	lui	a0,0x51
    3b74:	5d450513          	addi	a0,a0,1492 # 515d4 <raw_table+0xe638>
    3b78:	b65ff0ef          	jal	ra,36dc <printb>
}
    3b7c:	00c12083          	lw	ra,12(sp)
    3b80:	00812403          	lw	s0,8(sp)
    3b84:	01010113          	addi	sp,sp,16
    3b88:	00008067          	ret

00003b8c <userInterrupt>:

void userInterrupt(){
    3b8c:	ff010113          	addi	sp,sp,-16
    3b90:	00112623          	sw	ra,12(sp)
    3b94:	00812423          	sw	s0,8(sp)
	//struct example_apb3_ctrl_reg cfg={0};
	uint32_t claim;
	//While there is pending interrupts
	while(claim = plic_claim(BSP_PLIC, BSP_PLIC_CPU_0)){
    3b98:	0180006f          	j	3bb0 <userInterrupt+0x24>
		switch(claim){
		case SYSTEM_PLIC_USER_INTERRUPT_A_INTERRUPT:
			break;
		case SYSTEM_PLIC_USER_INTERRUPT_B_INTERRUPT:
			UserInterruptSDIsr(); break;
    3b9c:	bc5ff0ef          	jal	ra,3760 <UserInterruptSDIsr>
		default:
			printb("userInterrupt \n\r");
			crash_test( claim);
			break;
		}
		plic_release(BSP_PLIC, BSP_PLIC_CPU_0, claim); //unmask the claimed interrupt
    3ba0:	00040613          	mv	a2,s0
    3ba4:	00000593          	li	a1,0
    3ba8:	f8c00537          	lui	a0,0xf8c00
    3bac:	af1ff0ef          	jal	ra,369c <plic_release>
	while(claim = plic_claim(BSP_PLIC, BSP_PLIC_CPU_0)){
    3bb0:	00000593          	li	a1,0
    3bb4:	f8c00537          	lui	a0,0xf8c00
    3bb8:	ac9ff0ef          	jal	ra,3680 <plic_claim>
    3bbc:	00050413          	mv	s0,a0
    3bc0:	02050c63          	beqz	a0,3bf8 <userInterrupt+0x6c>
		switch(claim){
    3bc4:	01100793          	li	a5,17
    3bc8:	fcf40ae3          	beq	s0,a5,3b9c <userInterrupt+0x10>
    3bcc:	01600793          	li	a5,22
    3bd0:	02f40063          	beq	s0,a5,3bf0 <userInterrupt+0x64>
    3bd4:	01000793          	li	a5,16
    3bd8:	fcf404e3          	beq	s0,a5,3ba0 <userInterrupt+0x14>
			printb("userInterrupt \n\r");
    3bdc:	00009537          	lui	a0,0x9
    3be0:	ab050513          	addi	a0,a0,-1360 # 8ab0 <_data+0x9c>
    3be4:	af9ff0ef          	jal	ra,36dc <printb>
			crash_test( claim);
    3be8:	00040513          	mv	a0,s0
    3bec:	f15ff0ef          	jal	ra,3b00 <crash_test>
			UserInterruptDMAIsr(); break;
    3bf0:	d75ff0ef          	jal	ra,3964 <UserInterruptDMAIsr>
    3bf4:	fadff06f          	j	3ba0 <userInterrupt+0x14>
	}
}
    3bf8:	00c12083          	lw	ra,12(sp)
    3bfc:	00812403          	lw	s0,8(sp)
    3c00:	01010113          	addi	sp,sp,16
    3c04:	00008067          	ret

00003c08 <trap>:

//Called by trap_entry on both exceptions and interrupts events
void trap(){
    3c08:	ff010113          	addi	sp,sp,-16
    3c0c:	00112623          	sw	ra,12(sp)
    3c10:	00812423          	sw	s0,8(sp)
    3c14:	00912223          	sw	s1,4(sp)
    3c18:	01212023          	sw	s2,0(sp)
	int32_t mcause = csr_read(mcause);
    3c1c:	34202473          	csrr	s0,mcause
	int32_t interrupt = mcause < 0;    //Interrupt if true, exception if false
	int32_t cause     = mcause & 0xF;
	if(interrupt){
    3c20:	04045063          	bgez	s0,3c60 <trap+0x58>
    3c24:	00f47493          	andi	s1,s0,15
		switch(cause){
    3c28:	00b00793          	li	a5,11
    3c2c:	02f49063          	bne	s1,a5,3c4c <trap+0x44>
		case CAUSE_MACHINE_EXTERNAL: userInterrupt(); break;
    3c30:	f5dff0ef          	jal	ra,3b8c <userInterrupt>
		printb("NoInt \n\r");
		crash_testB(mcause);
		crash_test( interrupt);

	}
}
    3c34:	00c12083          	lw	ra,12(sp)
    3c38:	00812403          	lw	s0,8(sp)
    3c3c:	00412483          	lw	s1,4(sp)
    3c40:	00012903          	lw	s2,0(sp)
    3c44:	01010113          	addi	sp,sp,16
    3c48:	00008067          	ret
			printb("trap interrupt\n\r");
    3c4c:	00009537          	lui	a0,0x9
    3c50:	ac450513          	addi	a0,a0,-1340 # 8ac4 <_data+0xb0>
    3c54:	a89ff0ef          	jal	ra,36dc <printb>
			crash_test( cause);
    3c58:	00048513          	mv	a0,s1
    3c5c:	ea5ff0ef          	jal	ra,3b00 <crash_test>
    3c60:	01f45913          	srli	s2,s0,0x1f
		printb("NoInt \n\r");
    3c64:	00009537          	lui	a0,0x9
    3c68:	ad850513          	addi	a0,a0,-1320 # 8ad8 <_data+0xc4>
    3c6c:	a71ff0ef          	jal	ra,36dc <printb>
		crash_testB(mcause);
    3c70:	00040513          	mv	a0,s0
    3c74:	ed5ff0ef          	jal	ra,3b48 <crash_testB>
		crash_test( interrupt);
    3c78:	00090513          	mv	a0,s2
    3c7c:	e85ff0ef          	jal	ra,3b00 <crash_test>

00003c80 <IntcInitialize>:

void IntcInitialize()
{
    3c80:	ff010113          	addi	sp,sp,-16
    3c84:	00112623          	sw	ra,12(sp)
	flashled = 0;
    3c88:	bc01a023          	sw	zero,-1088(gp) # 52410 <flashled>
	for(int i=0; i<4 ;i++)
    3c8c:	00000713          	li	a4,0
    3c90:	0180006f          	j	3ca8 <IntcInitialize+0x28>
	{
		ChannelCount[i] = 0;
    3c94:	00271693          	slli	a3,a4,0x2
    3c98:	bc418793          	addi	a5,gp,-1084 # 52414 <ChannelCount>
    3c9c:	00d787b3          	add	a5,a5,a3
    3ca0:	0007a023          	sw	zero,0(a5)
	for(int i=0; i<4 ;i++)
    3ca4:	00170713          	addi	a4,a4,1
    3ca8:	00300793          	li	a5,3
    3cac:	fee7d4e3          	bge	a5,a4,3c94 <IntcInitialize+0x14>
	}


	//printb("Start Int Init \n\r");
	//configure PLIC
	plic_set_threshold(BSP_PLIC, BSP_PLIC_CPU_0, 0); //cpu 0 accept all interrupts with priority above 0
    3cb0:	00000613          	li	a2,0
    3cb4:	00000593          	li	a1,0
    3cb8:	f8c00537          	lui	a0,0xf8c00
    3cbc:	9adff0ef          	jal	ra,3668 <plic_set_threshold>

	//enable SYSTEM_PLIC_USER_INTERRUPT_A_INTERRUPT rising edge interrupt (SDHC)
	plic_set_enable(BSP_PLIC, BSP_PLIC_CPU_0, SYSTEM_PLIC_USER_INTERRUPT_B_INTERRUPT, 1);
    3cc0:	00100693          	li	a3,1
    3cc4:	01100613          	li	a2,17
    3cc8:	00000593          	li	a1,0
    3ccc:	f8c00537          	lui	a0,0xf8c00
    3cd0:	94dff0ef          	jal	ra,361c <plic_set_enable>
	plic_set_priority(BSP_PLIC, SYSTEM_PLIC_USER_INTERRUPT_B_INTERRUPT, 1);
    3cd4:	00100613          	li	a2,1
    3cd8:	01100593          	li	a1,17
    3cdc:	f8c00537          	lui	a0,0xf8c00
    3ce0:	92dff0ef          	jal	ra,360c <plic_set_priority>

	//enable SYSTEM_PLIC_USER_INTERRUPT_B_INTERRUPT rising edge interrupt (DMA)
	plic_set_enable(BSP_PLIC, BSP_PLIC_CPU_0, SYSTEM_PLIC_USER_INTERRUPT_C_INTERRUPT, 1);
    3ce4:	00100693          	li	a3,1
    3ce8:	01600613          	li	a2,22
    3cec:	00000593          	li	a1,0
    3cf0:	f8c00537          	lui	a0,0xf8c00
    3cf4:	929ff0ef          	jal	ra,361c <plic_set_enable>
	plic_set_priority(BSP_PLIC, SYSTEM_PLIC_USER_INTERRUPT_C_INTERRUPT, 2);
    3cf8:	00200613          	li	a2,2
    3cfc:	01600593          	li	a1,22
    3d00:	f8c00537          	lui	a0,0xf8c00
    3d04:	909ff0ef          	jal	ra,360c <plic_set_priority>


	//enable riscV interrupts
	csr_write(mtvec, trap_entry); //Set the machine trap vector (../common/trap.S)
    3d08:	000087b7          	lui	a5,0x8
    3d0c:	48878793          	addi	a5,a5,1160 # 8488 <trap_entry>
    3d10:	30579073          	csrw	mtvec,a5
//	csr_set(mie, MIE_MTIE | MIE_MEIE); //Enable machine timer and external interrupts
	csr_set(mie, MIE_MEIE); //Enable machine timer and external interrupts
    3d14:	000017b7          	lui	a5,0x1
    3d18:	80078793          	addi	a5,a5,-2048 # 800 <CUSTOM2+0x7a5>
    3d1c:	3047a073          	csrs	mie,a5
	csr_write(mstatus, MSTATUS_MPP | MSTATUS_MIE);
    3d20:	000027b7          	lui	a5,0x2
    3d24:	80878793          	addi	a5,a5,-2040 # 1808 <_malloc_r+0x6f0>
    3d28:	30079073          	csrw	mstatus,a5


}
    3d2c:	00c12083          	lw	ra,12(sp)
    3d30:	01010113          	addi	sp,sp,16
    3d34:	00008067          	ret

00003d38 <IntcSDInitialize>:

void IntcSDInitialize(struct mmc *mmc)
{
    3d38:	ff010113          	addi	sp,sp,-16
    3d3c:	00112623          	sw	ra,12(sp)
    3d40:	00812423          	sw	s0,8(sp)
	dev=mmc->priv;
    3d44:	00852503          	lw	a0,8(a0) # f8c00008 <__freertos_irq_stack_top+0xf8bac598>
    3d48:	baa1ae23          	sw	a0,-1092(gp) # 5240c <dev>

	//enable User interrupts
	sd_ctrl_write(dev,SDHC_ADDR+REG_NORMAL_INTERRUPT_STATUS1,0x00);		//Clean All Interrupts Status
    3d4c:	00000613          	li	a2,0
    3d50:	13400593          	li	a1,308
    3d54:	bd0fe0ef          	jal	ra,2124 <sd_ctrl_write>
	sd_ctrl_write(dev,SDHC_ADDR+REG_NORMAL_INTERRUPT_STATUS1,INT_ENABLE);		//Enable All Interrupts Status
    3d58:	fcf00613          	li	a2,-49
    3d5c:	13400593          	li	a1,308
    3d60:	bbc1a503          	lw	a0,-1092(gp) # 5240c <dev>
    3d64:	bc0fe0ef          	jal	ra,2124 <sd_ctrl_write>
	sd_ctrl_write(dev,SDHC_ADDR+REG_NORMAL_INTERRUPT_STATUS1+4,INT_ENABLE);		//Open All Interrupts Signal
    3d68:	fcf00613          	li	a2,-49
    3d6c:	13800593          	li	a1,312
    3d70:	bbc1a503          	lw	a0,-1092(gp) # 5240c <dev>
    3d74:	bb0fe0ef          	jal	ra,2124 <sd_ctrl_write>


}
    3d78:	00c12083          	lw	ra,12(sp)
    3d7c:	00812403          	lw	s0,8(sp)
    3d80:	01010113          	addi	sp,sp,16
    3d84:	00008067          	ret

00003d88 <uart_writeAvailability>:
        return *((volatile u32*) address);
    3d88:	00452503          	lw	a0,4(a0)
        return (read_u32(reg + UART_STATUS) >> 16) & 0xFF;
    3d8c:	01055513          	srli	a0,a0,0x10
    }
    3d90:	0ff57513          	andi	a0,a0,255
    3d94:	00008067          	ret

00003d98 <uart_readOccupancy>:
    3d98:	00452503          	lw	a0,4(a0)
    }
    3d9c:	01855513          	srli	a0,a0,0x18
    3da0:	00008067          	ret

00003da4 <uart_write>:
    static void uart_write(u32 reg, char data){
    3da4:	ff010113          	addi	sp,sp,-16
    3da8:	00112623          	sw	ra,12(sp)
    3dac:	00812423          	sw	s0,8(sp)
    3db0:	00912223          	sw	s1,4(sp)
    3db4:	00050413          	mv	s0,a0
    3db8:	00058493          	mv	s1,a1
        while(uart_writeAvailability(reg) == 0);
    3dbc:	00040513          	mv	a0,s0
    3dc0:	fc9ff0ef          	jal	ra,3d88 <uart_writeAvailability>
    3dc4:	fe050ce3          	beqz	a0,3dbc <uart_write+0x18>
        *((volatile u32*) address) = data;
    3dc8:	00942023          	sw	s1,0(s0)
    }
    3dcc:	00c12083          	lw	ra,12(sp)
    3dd0:	00812403          	lw	s0,8(sp)
    3dd4:	00412483          	lw	s1,4(sp)
    3dd8:	01010113          	addi	sp,sp,16
    3ddc:	00008067          	ret

00003de0 <uart_writeStr>:
    static void uart_writeStr(u32 reg, const char* str){
    3de0:	ff010113          	addi	sp,sp,-16
    3de4:	00112623          	sw	ra,12(sp)
    3de8:	00812423          	sw	s0,8(sp)
    3dec:	00912223          	sw	s1,4(sp)
    3df0:	00050493          	mv	s1,a0
    3df4:	00058413          	mv	s0,a1
        while(*str) uart_write(reg, *str++);
    3df8:	00044583          	lbu	a1,0(s0)
    3dfc:	00058a63          	beqz	a1,3e10 <uart_writeStr+0x30>
    3e00:	00140413          	addi	s0,s0,1
    3e04:	00048513          	mv	a0,s1
    3e08:	f9dff0ef          	jal	ra,3da4 <uart_write>
    3e0c:	fedff06f          	j	3df8 <uart_writeStr+0x18>
    }
    3e10:	00c12083          	lw	ra,12(sp)
    3e14:	00812403          	lw	s0,8(sp)
    3e18:	00412483          	lw	s1,4(sp)
    3e1c:	01010113          	addi	sp,sp,16
    3e20:	00008067          	ret

00003e24 <uart_read>:
* @note    The function waits until there is data available in the UART buffer
*          for reading. Once data is available, it reads the character data from
*          the UART data register and returns it.
*
******************************************************************************/
    static char uart_read(u32 reg){
    3e24:	ff010113          	addi	sp,sp,-16
    3e28:	00112623          	sw	ra,12(sp)
    3e2c:	00812423          	sw	s0,8(sp)
    3e30:	00050413          	mv	s0,a0
        while(uart_readOccupancy(reg) == 0);
    3e34:	00040513          	mv	a0,s0
    3e38:	f61ff0ef          	jal	ra,3d98 <uart_readOccupancy>
    3e3c:	fe050ce3          	beqz	a0,3e34 <uart_read+0x10>
        return *((volatile u32*) address);
    3e40:	00042503          	lw	a0,0(s0)
        return read_u32(reg + UART_DATA);
    }
    3e44:	0ff57513          	andi	a0,a0,255
    3e48:	00c12083          	lw	ra,12(sp)
    3e4c:	00812403          	lw	s0,8(sp)
    3e50:	01010113          	addi	sp,sp,16
    3e54:	00008067          	ret

00003e58 <clint_uDelay>:
        u32 mTimePerUsec = hz/1000000;
    3e58:	000f47b7          	lui	a5,0xf4
    3e5c:	24078793          	addi	a5,a5,576 # f4240 <__freertos_irq_stack_top+0xa07d0>
    3e60:	02f5d5b3          	divu	a1,a1,a5
    readReg_u32 (clint_getTimeLow , CLINT_TIME_ADDR)
    3e64:	0000c7b7          	lui	a5,0xc
    3e68:	ff878793          	addi	a5,a5,-8 # bff8 <raw_table4+0x26bc>
    3e6c:	00f60633          	add	a2,a2,a5
    3e70:	00062783          	lw	a5,0(a2) # 200000 <__freertos_irq_stack_top+0x1ac590>
        u32 limit = clint_getTimeLow(reg) + usec*mTimePerUsec;
    3e74:	02a58533          	mul	a0,a1,a0
    3e78:	00f50533          	add	a0,a0,a5
    3e7c:	00062783          	lw	a5,0(a2)
        while((int32_t)(limit-(clint_getTimeLow(reg))) >= 0);
    3e80:	40f507b3          	sub	a5,a0,a5
    3e84:	fe07dce3          	bgez	a5,3e7c <clint_uDelay+0x24>
    3e88:	00008067          	ret

00003e8c <_putchar>:
#include <math.h>
#include <string.h>
#include "bsp.h"

#if (ENABLE_BSP_PRINTF)
    static void _putchar(char character){
    3e8c:	ff010113          	addi	sp,sp,-16
    3e90:	00112623          	sw	ra,12(sp)
        #if (ENABLE_SEMIHOSTING_PRINT == 1)
            sh_writec(character);
        #else
            bsp_putChar(character);
    3e94:	00050593          	mv	a1,a0
    3e98:	f8010537          	lui	a0,0xf8010
    3e9c:	f09ff0ef          	jal	ra,3da4 <uart_write>
        #endif // (ENABLE_SEMIHOSTING_PRINT == 1)
    }
    3ea0:	00c12083          	lw	ra,12(sp)
    3ea4:	01010113          	addi	sp,sp,16
    3ea8:	00008067          	ret

00003eac <_putchar_s>:

    static void _putchar_s(char *p)
    {
    3eac:	ff010113          	addi	sp,sp,-16
    3eb0:	00112623          	sw	ra,12(sp)
    3eb4:	00812423          	sw	s0,8(sp)
    3eb8:	00050413          	mv	s0,a0
    #if (ENABLE_SEMIHOSTING_PRINT == 1)
        sh_write0(p);
    #else
        while (*p)
    3ebc:	00044503          	lbu	a0,0(s0)
    3ec0:	00050863          	beqz	a0,3ed0 <_putchar_s+0x24>
            _putchar(*(p++));
    3ec4:	00140413          	addi	s0,s0,1
    3ec8:	fc5ff0ef          	jal	ra,3e8c <_putchar>
    3ecc:	ff1ff06f          	j	3ebc <_putchar_s+0x10>
    #endif // (ENABLE_SEMIHOSTING_PRINT == 1)
    }
    3ed0:	00c12083          	lw	ra,12(sp)
    3ed4:	00812403          	lw	s0,8(sp)
    3ed8:	01010113          	addi	sp,sp,16
    3edc:	00008067          	ret

00003ee0 <bsp_printHex>:

        static void bsp_printHex(uint32_t val)
    {
    3ee0:	ff010113          	addi	sp,sp,-16
    3ee4:	00112623          	sw	ra,12(sp)
    3ee8:	00812423          	sw	s0,8(sp)
    3eec:	00912223          	sw	s1,4(sp)
    3ef0:	00050493          	mv	s1,a0
        uint32_t digits;
        digits =8;

        for (int i = (4*digits)-4; i >= 0; i -= 4) {
    3ef4:	01c00413          	li	s0,28
    3ef8:	0240006f          	j	3f1c <bsp_printHex+0x3c>
            _putchar("0123456789ABCDEF"[(val >> i) % 16]);
    3efc:	0084d7b3          	srl	a5,s1,s0
    3f00:	00f7f713          	andi	a4,a5,15
    3f04:	000097b7          	lui	a5,0x9
    3f08:	a7c78793          	addi	a5,a5,-1412 # 8a7c <_data+0x68>
    3f0c:	00e787b3          	add	a5,a5,a4
    3f10:	0007c503          	lbu	a0,0(a5)
    3f14:	f79ff0ef          	jal	ra,3e8c <_putchar>
        for (int i = (4*digits)-4; i >= 0; i -= 4) {
    3f18:	ffc40413          	addi	s0,s0,-4
    3f1c:	fe0450e3          	bgez	s0,3efc <bsp_printHex+0x1c>
        }
    }
    3f20:	00c12083          	lw	ra,12(sp)
    3f24:	00812403          	lw	s0,8(sp)
    3f28:	00412483          	lw	s1,4(sp)
    3f2c:	01010113          	addi	sp,sp,16
    3f30:	00008067          	ret

00003f34 <bsp_printHex_lower>:

    static void bsp_printHex_lower(uint32_t val)
    {
    3f34:	ff010113          	addi	sp,sp,-16
    3f38:	00112623          	sw	ra,12(sp)
    3f3c:	00812423          	sw	s0,8(sp)
    3f40:	00912223          	sw	s1,4(sp)
    3f44:	00050493          	mv	s1,a0
        uint32_t digits;
        digits =8;

        for (int i = (4*digits)-4; i >= 0; i -= 4) {
    3f48:	01c00413          	li	s0,28
    3f4c:	0240006f          	j	3f70 <bsp_printHex_lower+0x3c>
            _putchar("0123456789abcdef"[(val >> i) % 16]);
    3f50:	0084d7b3          	srl	a5,s1,s0
    3f54:	00f7f713          	andi	a4,a5,15
    3f58:	000097b7          	lui	a5,0x9
    3f5c:	ae478793          	addi	a5,a5,-1308 # 8ae4 <_data+0xd0>
    3f60:	00e787b3          	add	a5,a5,a4
    3f64:	0007c503          	lbu	a0,0(a5)
    3f68:	f25ff0ef          	jal	ra,3e8c <_putchar>
        for (int i = (4*digits)-4; i >= 0; i -= 4) {
    3f6c:	ffc40413          	addi	s0,s0,-4
    3f70:	fe0450e3          	bgez	s0,3f50 <bsp_printHex_lower+0x1c>

        }
    }
    3f74:	00c12083          	lw	ra,12(sp)
    3f78:	00812403          	lw	s0,8(sp)
    3f7c:	00412483          	lw	s1,4(sp)
    3f80:	01010113          	addi	sp,sp,16
    3f84:	00008067          	ret

00003f88 <bsp_printf_c>:
*
* @param c: The character to be output.
*
******************************************************************************/
    static void bsp_printf_c(int c)
    {
    3f88:	ff010113          	addi	sp,sp,-16
    3f8c:	00112623          	sw	ra,12(sp)
        _putchar(c);
    3f90:	0ff57513          	andi	a0,a0,255
    3f94:	ef9ff0ef          	jal	ra,3e8c <_putchar>
    }
    3f98:	00c12083          	lw	ra,12(sp)
    3f9c:	01010113          	addi	sp,sp,16
    3fa0:	00008067          	ret

00003fa4 <bsp_printf_s>:
*
* @param s: A pointer to the null-terminated string to be output.
*
*******************************************************************************/
    static void bsp_printf_s(char *p)
    {
    3fa4:	ff010113          	addi	sp,sp,-16
    3fa8:	00112623          	sw	ra,12(sp)
        _putchar_s(p);
    3fac:	f01ff0ef          	jal	ra,3eac <_putchar_s>
    }
    3fb0:	00c12083          	lw	ra,12(sp)
    3fb4:	01010113          	addi	sp,sp,16
    3fb8:	00008067          	ret

00003fbc <bsp_printf_d>:
* - Handles negative numbers by printing a '-' sign.
* - Uses the 'bsp_printf_c' function to print each character.
*
******************************************************************************/
    static void bsp_printf_d(int val)
    {
    3fbc:	fd010113          	addi	sp,sp,-48
    3fc0:	02112623          	sw	ra,44(sp)
    3fc4:	02812423          	sw	s0,40(sp)
    3fc8:	02912223          	sw	s1,36(sp)
    3fcc:	00050493          	mv	s1,a0
        char buffer[32];
        char *p = buffer;
        if (val < 0) {
    3fd0:	00054663          	bltz	a0,3fdc <bsp_printf_d+0x20>
    {
    3fd4:	00010413          	mv	s0,sp
    3fd8:	02c0006f          	j	4004 <bsp_printf_d+0x48>
            bsp_printf_c('-');
    3fdc:	02d00513          	li	a0,45
    3fe0:	fa9ff0ef          	jal	ra,3f88 <bsp_printf_c>
            val = -val;
    3fe4:	409004b3          	neg	s1,s1
    3fe8:	fedff06f          	j	3fd4 <bsp_printf_d+0x18>
        }
        while (val || p == buffer) {
            *(p++) = '0' + val % 10;
    3fec:	00a00713          	li	a4,10
    3ff0:	02e4e7b3          	rem	a5,s1,a4
    3ff4:	03078793          	addi	a5,a5,48
    3ff8:	00f40023          	sb	a5,0(s0)
            val = val / 10;
    3ffc:	02e4c4b3          	div	s1,s1,a4
            *(p++) = '0' + val % 10;
    4000:	00140413          	addi	s0,s0,1
        while (val || p == buffer) {
    4004:	fe0494e3          	bnez	s1,3fec <bsp_printf_d+0x30>
    4008:	00010793          	mv	a5,sp
    400c:	fef400e3          	beq	s0,a5,3fec <bsp_printf_d+0x30>
    4010:	0100006f          	j	4020 <bsp_printf_d+0x64>
        }
        while (p != buffer)
            bsp_printf_c(*(--p));
    4014:	fff40413          	addi	s0,s0,-1
    4018:	00044503          	lbu	a0,0(s0)
    401c:	f6dff0ef          	jal	ra,3f88 <bsp_printf_c>
        while (p != buffer)
    4020:	00010793          	mv	a5,sp
    4024:	fef418e3          	bne	s0,a5,4014 <bsp_printf_d+0x58>
    }
    4028:	02c12083          	lw	ra,44(sp)
    402c:	02812403          	lw	s0,40(sp)
    4030:	02412483          	lw	s1,36(sp)
    4034:	03010113          	addi	sp,sp,48
    4038:	00008067          	ret

0000403c <bsp_printf_x>:
* - Calls 'bsp_printHex_lower' to print the hexadecimal representation.
* - Determines the number of leading zeros to be printed based on the value.
*
******************************************************************************/
    static void bsp_printf_x(int val)
    {
    403c:	ff010113          	addi	sp,sp,-16
    4040:	00112623          	sw	ra,12(sp)
        int i,digi=2;

        for(i=0;i<8;i++)
    4044:	00000713          	li	a4,0
    4048:	00700793          	li	a5,7
    404c:	02e7c063          	blt	a5,a4,406c <bsp_printf_x+0x30>
        {
            if((val & (0xFFFFFFF0 <<(4*i))) == 0)
    4050:	00271693          	slli	a3,a4,0x2
    4054:	ff000793          	li	a5,-16
    4058:	00d797b3          	sll	a5,a5,a3
    405c:	00f577b3          	and	a5,a0,a5
    4060:	00078663          	beqz	a5,406c <bsp_printf_x+0x30>
        for(i=0;i<8;i++)
    4064:	00170713          	addi	a4,a4,1
    4068:	fe1ff06f          	j	4048 <bsp_printf_x+0xc>
            {
                digi=i+1;
                break;
            }
        }
        bsp_printHex_lower(val);
    406c:	ec9ff0ef          	jal	ra,3f34 <bsp_printHex_lower>
    }
    4070:	00c12083          	lw	ra,12(sp)
    4074:	01010113          	addi	sp,sp,16
    4078:	00008067          	ret

0000407c <bsp_printf_X>:
* - Calls 'bsp_printHex' to print the uppercase hexadecimal representation.
* - Determines the number of leading zeros to be printed based on the value.
*
******************************************************************************/
    static void bsp_printf_X(int val)
        {
    407c:	ff010113          	addi	sp,sp,-16
    4080:	00112623          	sw	ra,12(sp)
            int i,digi=2;

            for(i=0;i<8;i++)
    4084:	00000713          	li	a4,0
    4088:	00700793          	li	a5,7
    408c:	02e7c063          	blt	a5,a4,40ac <bsp_printf_X+0x30>
            {
                if((val & (0xFFFFFFF0 <<(4*i))) == 0)
    4090:	00271693          	slli	a3,a4,0x2
    4094:	ff000793          	li	a5,-16
    4098:	00d797b3          	sll	a5,a5,a3
    409c:	00f577b3          	and	a5,a0,a5
    40a0:	00078663          	beqz	a5,40ac <bsp_printf_X+0x30>
            for(i=0;i<8;i++)
    40a4:	00170713          	addi	a4,a4,1
    40a8:	fe1ff06f          	j	4088 <bsp_printf_X+0xc>
                {
                    digi=i+1;
                    break;
                }
            }
            bsp_printHex(val);
    40ac:	e35ff0ef          	jal	ra,3ee0 <bsp_printHex>
        }
    40b0:	00c12083          	lw	ra,12(sp)
    40b4:	01010113          	addi	sp,sp,16
    40b8:	00008067          	ret

000040bc <dmasg_interrupt_config>:
        u32 ca = dmasg_ca(base, channel);
    40bc:	00759593          	slli	a1,a1,0x7
    40c0:	00a58533          	add	a0,a1,a0
        *((volatile u32*) address) = data;
    40c4:	fff00793          	li	a5,-1
    40c8:	04f52a23          	sw	a5,84(a0) # f8010054 <__freertos_irq_stack_top+0xf7fbc5e4>
    40cc:	04c52823          	sw	a2,80(a0)
    }
    40d0:	00008067          	ret

000040d4 <dmasg_interrupt_pending_clear>:
        u32 ca = dmasg_ca(base, channel);
    40d4:	00759593          	slli	a1,a1,0x7
    40d8:	00a585b3          	add	a1,a1,a0
    40dc:	04c5aa23          	sw	a2,84(a1)
    }
    40e0:	00008067          	ret

000040e4 <dmasg_priority>:
* @param priority: Priority of the channel
* @param weight: Weight of the channel
*
*******************************************************************************/  
    static void dmasg_priority(u32 base, u32 channel, u32 priority, u32 weight){
        u32 ca = dmasg_ca(base, channel);
    40e4:	00759593          	slli	a1,a1,0x7
    40e8:	00a585b3          	add	a1,a1,a0
        write_u32(priority| weight << 8,  ca+DMASG_CHANNEL_PRIORITY);
    40ec:	00869693          	slli	a3,a3,0x8
    40f0:	00c6e6b3          	or	a3,a3,a2
    40f4:	04d5a223          	sw	a3,68(a1)
    }
    40f8:	00008067          	ret

000040fc <i2c_masterBusy>:
        return *((volatile u32*) address);
    40fc:	04052503          	lw	a0,64(a0)
    }
    4100:	00157513          	andi	a0,a0,1
    4104:	00008067          	ret

00004108 <i2c_masterStartBlocking>:
        write_u32(I2C_MASTER_START | I2C_MASTER_START_DROPPED, reg + I2C_MASTER_STATUS);
    4108:	04050713          	addi	a4,a0,64
        *((volatile u32*) address) = data;
    410c:	21000793          	li	a5,528
    4110:	04f52023          	sw	a5,64(a0)
        return *((volatile u32*) address);
    4114:	00072783          	lw	a5,0(a4)
        while(i2c_getMasterStatus(reg) & I2C_MASTER_START);
    4118:	0107f793          	andi	a5,a5,16
    411c:	fe079ce3          	bnez	a5,4114 <i2c_masterStartBlocking+0xc>
    }
    4120:	00008067          	ret

00004124 <i2c_masterStopWait>:
    static void i2c_masterStopWait(u32 reg){
    4124:	ff010113          	addi	sp,sp,-16
    4128:	00112623          	sw	ra,12(sp)
    412c:	00812423          	sw	s0,8(sp)
    4130:	00050413          	mv	s0,a0
        while(i2c_masterBusy(reg));
    4134:	00040513          	mv	a0,s0
    4138:	fc5ff0ef          	jal	ra,40fc <i2c_masterBusy>
    413c:	fe051ce3          	bnez	a0,4134 <i2c_masterStopWait+0x10>
    }
    4140:	00c12083          	lw	ra,12(sp)
    4144:	00812403          	lw	s0,8(sp)
    4148:	01010113          	addi	sp,sp,16
    414c:	00008067          	ret

00004150 <i2c_masterStopBlocking>:
    static void i2c_masterStopBlocking(u32 reg){
    4150:	ff010113          	addi	sp,sp,-16
    4154:	00112623          	sw	ra,12(sp)
        *((volatile u32*) address) = data;
    4158:	42000713          	li	a4,1056
    415c:	04e52023          	sw	a4,64(a0)
        i2c_masterStopWait(reg);
    4160:	fc5ff0ef          	jal	ra,4124 <i2c_masterStopWait>
    }
    4164:	00c12083          	lw	ra,12(sp)
    4168:	01010113          	addi	sp,sp,16
    416c:	00008067          	ret

00004170 <i2c_txAckWait>:
        return *((volatile u32*) address);
    4170:	00452783          	lw	a5,4(a0)
        while(read_u32(reg + I2C_TX_ACK) & I2C_TX_VALID);
    4174:	1007f793          	andi	a5,a5,256
    4178:	fe079ce3          	bnez	a5,4170 <i2c_txAckWait>
    }
    417c:	00008067          	ret

00004180 <i2c_txNackBlocking>:
    static void i2c_txNackBlocking(u32 reg){
    4180:	ff010113          	addi	sp,sp,-16
    4184:	00112623          	sw	ra,12(sp)
        *((volatile u32*) address) = data;
    4188:	30100713          	li	a4,769
    418c:	00e52223          	sw	a4,4(a0)
        i2c_txAckWait(reg);
    4190:	fe1ff0ef          	jal	ra,4170 <i2c_txAckWait>
    }
    4194:	00c12083          	lw	ra,12(sp)
    4198:	01010113          	addi	sp,sp,16
    419c:	00008067          	ret

000041a0 <i2c_rxData>:
        return *((volatile u32*) address);
    41a0:	00852503          	lw	a0,8(a0)
    }
    41a4:	0ff57513          	andi	a0,a0,255
    41a8:	00008067          	ret

000041ac <i2c_rxNack>:
    41ac:	00c52503          	lw	a0,12(a0)
        return (read_u32(reg + I2C_RX_ACK) & I2C_RX_VALUE) != 0;
    41b0:	0ff57513          	andi	a0,a0,255
    }
    41b4:	00a03533          	snez	a0,a0
    41b8:	00008067          	ret

000041bc <i2c_rxAck>:
    41bc:	00c52503          	lw	a0,12(a0)
        return (read_u32(reg + I2C_RX_ACK) & I2C_RX_VALUE) == 0;
    41c0:	0ff57513          	andi	a0,a0,255
    }
    41c4:	00153513          	seqz	a0,a0
    41c8:	00008067          	ret

000041cc <bsp_printf>:
* - Handles each format specifier by calling the appropriate helper function.
* - If floating-point support is disabled, prints a warning for the 'f' specifier.
*
******************************************************************************/
    static void bsp_printf(const char *format, ...)
    {
    41cc:	fc010113          	addi	sp,sp,-64
    41d0:	00112e23          	sw	ra,28(sp)
    41d4:	00812c23          	sw	s0,24(sp)
    41d8:	00912a23          	sw	s1,20(sp)
    41dc:	00050493          	mv	s1,a0
    41e0:	02b12223          	sw	a1,36(sp)
    41e4:	02c12423          	sw	a2,40(sp)
    41e8:	02d12623          	sw	a3,44(sp)
    41ec:	02e12823          	sw	a4,48(sp)
    41f0:	02f12a23          	sw	a5,52(sp)
    41f4:	03012c23          	sw	a6,56(sp)
    41f8:	03112e23          	sw	a7,60(sp)
        int i;
        va_list ap;

        va_start(ap, format);
    41fc:	02410793          	addi	a5,sp,36
    4200:	00f12623          	sw	a5,12(sp)

        for (i = 0; format[i]; i++)
    4204:	00000413          	li	s0,0
    4208:	01c0006f          	j	4224 <bsp_printf+0x58>
            if (format[i] == '%') {
                while (format[++i]) {
                    if (format[i] == 'c') {
                        bsp_printf_c(va_arg(ap,int));
    420c:	00c12783          	lw	a5,12(sp)
    4210:	00478713          	addi	a4,a5,4
    4214:	00e12623          	sw	a4,12(sp)
    4218:	0007a503          	lw	a0,0(a5)
    421c:	d6dff0ef          	jal	ra,3f88 <bsp_printf_c>
        for (i = 0; format[i]; i++)
    4220:	00140413          	addi	s0,s0,1
    4224:	008487b3          	add	a5,s1,s0
    4228:	0007c503          	lbu	a0,0(a5)
    422c:	0c050263          	beqz	a0,42f0 <bsp_printf+0x124>
            if (format[i] == '%') {
    4230:	02500793          	li	a5,37
    4234:	06f50663          	beq	a0,a5,42a0 <bsp_printf+0xd4>
                        break;
                    }
#endif //#if (ENABLE_FLOATING_POINT_SUPPORT)
                }
            } else
                bsp_printf_c(format[i]);
    4238:	d51ff0ef          	jal	ra,3f88 <bsp_printf_c>
    423c:	fe5ff06f          	j	4220 <bsp_printf+0x54>
                        bsp_printf_s(va_arg(ap,char*));
    4240:	00c12783          	lw	a5,12(sp)
    4244:	00478713          	addi	a4,a5,4
    4248:	00e12623          	sw	a4,12(sp)
    424c:	0007a503          	lw	a0,0(a5)
    4250:	d55ff0ef          	jal	ra,3fa4 <bsp_printf_s>
                        break;
    4254:	fcdff06f          	j	4220 <bsp_printf+0x54>
                        bsp_printf_d(va_arg(ap,int));
    4258:	00c12783          	lw	a5,12(sp)
    425c:	00478713          	addi	a4,a5,4
    4260:	00e12623          	sw	a4,12(sp)
    4264:	0007a503          	lw	a0,0(a5)
    4268:	d55ff0ef          	jal	ra,3fbc <bsp_printf_d>
                        break;
    426c:	fb5ff06f          	j	4220 <bsp_printf+0x54>
                        bsp_printf_X(va_arg(ap,int));
    4270:	00c12783          	lw	a5,12(sp)
    4274:	00478713          	addi	a4,a5,4
    4278:	00e12623          	sw	a4,12(sp)
    427c:	0007a503          	lw	a0,0(a5)
    4280:	dfdff0ef          	jal	ra,407c <bsp_printf_X>
                        break;
    4284:	f9dff06f          	j	4220 <bsp_printf+0x54>
                        bsp_printf_x(va_arg(ap,int));
    4288:	00c12783          	lw	a5,12(sp)
    428c:	00478713          	addi	a4,a5,4
    4290:	00e12623          	sw	a4,12(sp)
    4294:	0007a503          	lw	a0,0(a5)
    4298:	da5ff0ef          	jal	ra,403c <bsp_printf_x>
                        break;
    429c:	f85ff06f          	j	4220 <bsp_printf+0x54>
                while (format[++i]) {
    42a0:	00140413          	addi	s0,s0,1
    42a4:	008487b3          	add	a5,s1,s0
    42a8:	0007c783          	lbu	a5,0(a5)
    42ac:	f6078ae3          	beqz	a5,4220 <bsp_printf+0x54>
                    if (format[i] == 'c') {
    42b0:	06300713          	li	a4,99
    42b4:	f4e78ce3          	beq	a5,a4,420c <bsp_printf+0x40>
                    else if (format[i] == 's') {
    42b8:	07300713          	li	a4,115
    42bc:	f8e782e3          	beq	a5,a4,4240 <bsp_printf+0x74>
                    else if (format[i] == 'd') {
    42c0:	06400713          	li	a4,100
    42c4:	f8e78ae3          	beq	a5,a4,4258 <bsp_printf+0x8c>
                    else if (format[i] == 'X') {
    42c8:	05800713          	li	a4,88
    42cc:	fae782e3          	beq	a5,a4,4270 <bsp_printf+0xa4>
                    else if (format[i] == 'x') {
    42d0:	07800713          	li	a4,120
    42d4:	fae78ae3          	beq	a5,a4,4288 <bsp_printf+0xbc>
                    else if (format[i] == 'f') {
    42d8:	06600713          	li	a4,102
    42dc:	fce792e3          	bne	a5,a4,42a0 <bsp_printf+0xd4>
                        bsp_printf_s("<Floating point printing not enable. Please Enable it at bsp.h first...>");
    42e0:	00009537          	lui	a0,0x9
    42e4:	af850513          	addi	a0,a0,-1288 # 8af8 <_data+0xe4>
    42e8:	cbdff0ef          	jal	ra,3fa4 <bsp_printf_s>
                        break;
    42ec:	f35ff06f          	j	4220 <bsp_printf+0x54>

        va_end(ap);
    }
    42f0:	01c12083          	lw	ra,28(sp)
    42f4:	01812403          	lw	s0,24(sp)
    42f8:	01412483          	lw	s1,20(sp)
    42fc:	04010113          	addi	sp,sp,64
    4300:	00008067          	ret

00004304 <print>:
struct cs_sg_descriptor cs_descriptor_csi_RX[4];


volatile struct dmasg_descriptor input_descriptor[40] __attribute__ ((aligned (64)));

void print(uint8_t * data) {
    4304:	ff010113          	addi	sp,sp,-16
    4308:	00112623          	sw	ra,12(sp)
      uart_writeStr(BSP_UART_TERMINAL, data);
    430c:	00050593          	mv	a1,a0
    4310:	f8010537          	lui	a0,0xf8010
    4314:	acdff0ef          	jal	ra,3de0 <uart_writeStr>
    }
    4318:	00c12083          	lw	ra,12(sp)
    431c:	01010113          	addi	sp,sp,16
    4320:	00008067          	ret

00004324 <I2C_SLV_WriteRegData>:

int I2C_SLV_WriteRegData(u8 reg,u8 data)
{
    4324:	ff010113          	addi	sp,sp,-16
    4328:	00112623          	sw	ra,12(sp)
    432c:	00812423          	sw	s0,8(sp)
    4330:	00912223          	sw	s1,4(sp)
    4334:	00050413          	mv	s0,a0
    4338:	00058493          	mv	s1,a1
	u8 outdata;

    i2c_masterStartBlocking(I2C_CTRL_MIPI);
    433c:	f8017537          	lui	a0,0xf8017
    4340:	dc9ff0ef          	jal	ra,4108 <i2c_masterStartBlocking>
        *((volatile u32*) address) = data;
    4344:	f8017737          	lui	a4,0xf8017
    4348:	000017b7          	lui	a5,0x1
    434c:	b5478793          	addi	a5,a5,-1196 # b54 <CUSTOM2+0xaf9>
    4350:	00f72023          	sw	a5,0(a4) # f8017000 <__freertos_irq_stack_top+0xf7fc3590>

    i2c_txByte(I2C_CTRL_MIPI, I2C_slv_addr<<1);
	i2c_txNackBlocking(I2C_CTRL_MIPI);
    4354:	f8017537          	lui	a0,0xf8017
    4358:	e29ff0ef          	jal	ra,4180 <i2c_txNackBlocking>
	if (assert(i2c_rxAck(I2C_CTRL_MIPI)) ) // Optional check
    435c:	f8017537          	lui	a0,0xf8017
    4360:	e5dff0ef          	jal	ra,41bc <i2c_rxAck>
    4364:	445000ef          	jal	ra,4fa8 <assert>
    4368:	02050063          	beqz	a0,4388 <I2C_SLV_WriteRegData+0x64>
		return 1;
    436c:	00100413          	li	s0,1
	if (assert(i2c_rxAck(I2C_CTRL_MIPI)) ) // Optional check
		return 1;
	i2c_masterStopBlocking(I2C_CTRL_MIPI);

	return 0;
}
    4370:	00040513          	mv	a0,s0
    4374:	00c12083          	lw	ra,12(sp)
    4378:	00812403          	lw	s0,8(sp)
    437c:	00412483          	lw	s1,4(sp)
    4380:	01010113          	addi	sp,sp,16
    4384:	00008067          	ret
        write_u32(byte | I2C_TX_VALID | I2C_TX_ENABLE | I2C_TX_DISABLE_ON_DATA_CONFLICT, reg + I2C_TX_DATA);
    4388:	000017b7          	lui	a5,0x1
    438c:	b0078793          	addi	a5,a5,-1280 # b00 <CUSTOM2+0xaa5>
    4390:	00f46433          	or	s0,s0,a5
    4394:	f80177b7          	lui	a5,0xf8017
    4398:	0087a023          	sw	s0,0(a5) # f8017000 <__freertos_irq_stack_top+0xf7fc3590>
	i2c_txNackBlocking(I2C_CTRL_MIPI);
    439c:	f8017537          	lui	a0,0xf8017
    43a0:	de1ff0ef          	jal	ra,4180 <i2c_txNackBlocking>
	if (assert(i2c_rxAck(I2C_CTRL_MIPI)) ) // Optional check
    43a4:	f8017537          	lui	a0,0xf8017
    43a8:	e15ff0ef          	jal	ra,41bc <i2c_rxAck>
    43ac:	3fd000ef          	jal	ra,4fa8 <assert>
    43b0:	00050663          	beqz	a0,43bc <I2C_SLV_WriteRegData+0x98>
		return 1;
    43b4:	00100413          	li	s0,1
    43b8:	fb9ff06f          	j	4370 <I2C_SLV_WriteRegData+0x4c>
    43bc:	000017b7          	lui	a5,0x1
    43c0:	b0078793          	addi	a5,a5,-1280 # b00 <CUSTOM2+0xaa5>
    43c4:	00f4e4b3          	or	s1,s1,a5
    43c8:	f80177b7          	lui	a5,0xf8017
    43cc:	0097a023          	sw	s1,0(a5) # f8017000 <__freertos_irq_stack_top+0xf7fc3590>
	i2c_txNackBlocking(I2C_CTRL_MIPI);
    43d0:	f8017537          	lui	a0,0xf8017
    43d4:	dadff0ef          	jal	ra,4180 <i2c_txNackBlocking>
	if (assert(i2c_rxAck(I2C_CTRL_MIPI)) ) // Optional check
    43d8:	f8017537          	lui	a0,0xf8017
    43dc:	de1ff0ef          	jal	ra,41bc <i2c_rxAck>
    43e0:	3c9000ef          	jal	ra,4fa8 <assert>
    43e4:	00050413          	mv	s0,a0
    43e8:	00050663          	beqz	a0,43f4 <I2C_SLV_WriteRegData+0xd0>
		return 1;
    43ec:	00100413          	li	s0,1
    43f0:	f81ff06f          	j	4370 <I2C_SLV_WriteRegData+0x4c>
	i2c_masterStopBlocking(I2C_CTRL_MIPI);
    43f4:	f8017537          	lui	a0,0xf8017
    43f8:	d59ff0ef          	jal	ra,4150 <i2c_masterStopBlocking>
	return 0;
    43fc:	f75ff06f          	j	4370 <I2C_SLV_WriteRegData+0x4c>

00004400 <I2C_SLV_ReadRegData>:

u8 I2C_SLV_ReadRegData(u8 reg)
{
    4400:	ff010113          	addi	sp,sp,-16
    4404:	00112623          	sw	ra,12(sp)
    4408:	00812423          	sw	s0,8(sp)
    440c:	00912223          	sw	s1,4(sp)
    4410:	01212023          	sw	s2,0(sp)
    4414:	00050913          	mv	s2,a0
	u8 outdata;

    i2c_masterStartBlocking(I2C_CTRL_MIPI);
    4418:	f8017537          	lui	a0,0xf8017
    441c:	cedff0ef          	jal	ra,4108 <i2c_masterStartBlocking>
    4420:	f80174b7          	lui	s1,0xf8017
    4424:	00001437          	lui	s0,0x1
    4428:	b5440793          	addi	a5,s0,-1196 # b54 <CUSTOM2+0xaf9>
    442c:	00f4a023          	sw	a5,0(s1) # f8017000 <__freertos_irq_stack_top+0xf7fc3590>

    i2c_txByte(I2C_CTRL_MIPI, I2C_slv_addr<<1);
	i2c_txNackBlocking(I2C_CTRL_MIPI);
    4430:	f8017537          	lui	a0,0xf8017
    4434:	d4dff0ef          	jal	ra,4180 <i2c_txNackBlocking>
	assert(i2c_rxAck(I2C_CTRL_MIPI)); // Optional check
    4438:	f8017537          	lui	a0,0xf8017
    443c:	d81ff0ef          	jal	ra,41bc <i2c_rxAck>
    4440:	369000ef          	jal	ra,4fa8 <assert>
    4444:	b0040793          	addi	a5,s0,-1280
    4448:	00f96933          	or	s2,s2,a5
    444c:	0124a023          	sw	s2,0(s1)

	i2c_txByte(I2C_CTRL_MIPI, (reg) & 0xFF);
	i2c_txNackBlocking(I2C_CTRL_MIPI);
    4450:	f8017537          	lui	a0,0xf8017
    4454:	d2dff0ef          	jal	ra,4180 <i2c_txNackBlocking>
	assert(i2c_rxAck(I2C_CTRL_MIPI)); // Optional check
    4458:	f8017537          	lui	a0,0xf8017
    445c:	d61ff0ef          	jal	ra,41bc <i2c_rxAck>
    4460:	349000ef          	jal	ra,4fa8 <assert>

	i2c_masterStopBlocking(I2C_CTRL_MIPI);
    4464:	f8017537          	lui	a0,0xf8017
    4468:	ce9ff0ef          	jal	ra,4150 <i2c_masterStopBlocking>
	i2c_masterStartBlocking(I2C_CTRL_MIPI);
    446c:	f8017537          	lui	a0,0xf8017
    4470:	c99ff0ef          	jal	ra,4108 <i2c_masterStartBlocking>
    4474:	b5540793          	addi	a5,s0,-1195
    4478:	00f4a023          	sw	a5,0(s1)

	i2c_txByte(I2C_CTRL_MIPI, (I2C_slv_addr<<1) | 0x01);
	i2c_txNackBlocking(I2C_CTRL_MIPI);
    447c:	f8017537          	lui	a0,0xf8017
    4480:	d01ff0ef          	jal	ra,4180 <i2c_txNackBlocking>
	assert(i2c_rxAck(I2C_CTRL_MIPI)); // Optional check
    4484:	f8017537          	lui	a0,0xf8017
    4488:	d35ff0ef          	jal	ra,41bc <i2c_rxAck>
    448c:	31d000ef          	jal	ra,4fa8 <assert>
    4490:	bff40413          	addi	s0,s0,-1025
    4494:	0084a023          	sw	s0,0(s1)

	i2c_txByte(I2C_CTRL_MIPI, 0xFF);
	i2c_txNackBlocking(I2C_CTRL_MIPI);
    4498:	f8017537          	lui	a0,0xf8017
    449c:	ce5ff0ef          	jal	ra,4180 <i2c_txNackBlocking>
	assert(i2c_rxNack(I2C_CTRL_MIPI)); // Optional check
    44a0:	f8017537          	lui	a0,0xf8017
    44a4:	d09ff0ef          	jal	ra,41ac <i2c_rxNack>
    44a8:	301000ef          	jal	ra,4fa8 <assert>
	outdata = i2c_rxData(I2C_CTRL_MIPI);
    44ac:	f8017537          	lui	a0,0xf8017
    44b0:	cf1ff0ef          	jal	ra,41a0 <i2c_rxData>
    44b4:	0ff57413          	andi	s0,a0,255

	i2c_masterStopBlocking(I2C_CTRL_MIPI);
    44b8:	f8017537          	lui	a0,0xf8017
    44bc:	c95ff0ef          	jal	ra,4150 <i2c_masterStopBlocking>

	return outdata;
}
    44c0:	00040513          	mv	a0,s0
    44c4:	00c12083          	lw	ra,12(sp)
    44c8:	00812403          	lw	s0,8(sp)
    44cc:	00412483          	lw	s1,4(sp)
    44d0:	00012903          	lw	s2,0(sp)
    44d4:	01010113          	addi	sp,sp,16
    44d8:	00008067          	ret

000044dc <cmd_cam_brightnes>:
#define MASK_SW1	( MASK_ALL & (~0x01) )
#define MASK_SW2	( MASK_ALL & (~0x02) )
#define MASK_SW3	( MASK_ALL & (~0x04) )

void cmd_cam_brightnes(u8 AGain, u16 DGain)
{
    44dc:	ff010113          	addi	sp,sp,-16
    44e0:	00112623          	sw	ra,12(sp)
    44e4:	00812423          	sw	s0,8(sp)
    44e8:	00912223          	sw	s1,4(sp)
    44ec:	01212023          	sw	s2,0(sp)
    44f0:	00050913          	mv	s2,a0
    44f4:	00058493          	mv	s1,a1


	for(int x=0; x<4; x++)
    44f8:	00000413          	li	s0,0
    44fc:	0500006f          	j	454c <cmd_cam_brightnes+0x70>
			if( PiCam_Gainfilter(AGain,DGain) ){
				bsp_printf("Pi Camera %d Brightness Error !\n\r",x );
			}
			else
			{
				bsp_printf("Pi Camera %d Brightness Done !\n\r",x);
    4500:	00040593          	mv	a1,s0
    4504:	00009537          	lui	a0,0x9
    4508:	b6850513          	addi	a0,a0,-1176 # 8b68 <_data+0x154>
    450c:	cc1ff0ef          	jal	ra,41cc <bsp_printf>
				bsp_printf("AGain: 0x%x\n\r",AGain);
    4510:	00090593          	mv	a1,s2
    4514:	00009537          	lui	a0,0x9
    4518:	b8c50513          	addi	a0,a0,-1140 # 8b8c <_data+0x178>
    451c:	cb1ff0ef          	jal	ra,41cc <bsp_printf>
				bsp_printf("DGain: 0x%x\n\r",DGain);
    4520:	00048593          	mv	a1,s1
    4524:	00009537          	lui	a0,0x9
    4528:	b9c50513          	addi	a0,a0,-1124 # 8b9c <_data+0x188>
    452c:	ca1ff0ef          	jal	ra,41cc <bsp_printf>

			}

		}
		bsp_uDelay(200000);
    4530:	f8b00637          	lui	a2,0xf8b00
    4534:	05f5e5b7          	lui	a1,0x5f5e
    4538:	10058593          	addi	a1,a1,256 # 5f5e100 <__freertos_irq_stack_top+0x5f0a690>
    453c:	00031537          	lui	a0,0x31
    4540:	d4050513          	addi	a0,a0,-704 # 30d40 <raw_table2+0xa8d4>
    4544:	915ff0ef          	jal	ra,3e58 <clint_uDelay>
	for(int x=0; x<4; x++)
    4548:	00140413          	addi	s0,s0,1
    454c:	00300793          	li	a5,3
    4550:	0487c263          	blt	a5,s0,4594 <cmd_cam_brightnes+0xb8>
    4554:	f81107b7          	lui	a5,0xf8110
    4558:	0287a823          	sw	s0,48(a5) # f8110030 <__freertos_irq_stack_top+0xf80bc5c0>
		if(camStatus[x]!=0)
    455c:	00241793          	slli	a5,s0,0x2
    4560:	c3018713          	addi	a4,gp,-976 # 52480 <camStatus>
    4564:	00f707b3          	add	a5,a4,a5
    4568:	0007a783          	lw	a5,0(a5)
    456c:	fc0782e3          	beqz	a5,4530 <cmd_cam_brightnes+0x54>
			if( PiCam_Gainfilter(AGain,DGain) ){
    4570:	00048593          	mv	a1,s1
    4574:	00090513          	mv	a0,s2
    4578:	cadfe0ef          	jal	ra,3224 <PiCam_Gainfilter>
    457c:	f80502e3          	beqz	a0,4500 <cmd_cam_brightnes+0x24>
				bsp_printf("Pi Camera %d Brightness Error !\n\r",x );
    4580:	00040593          	mv	a1,s0
    4584:	00009537          	lui	a0,0x9
    4588:	b4450513          	addi	a0,a0,-1212 # 8b44 <_data+0x130>
    458c:	c41ff0ef          	jal	ra,41cc <bsp_printf>
    4590:	fa1ff06f          	j	4530 <cmd_cam_brightnes+0x54>

	}

}
    4594:	00c12083          	lw	ra,12(sp)
    4598:	00812403          	lw	s0,8(sp)
    459c:	00412483          	lw	s1,4(sp)
    45a0:	00012903          	lw	s2,0(sp)
    45a4:	01010113          	addi	sp,sp,16
    45a8:	00008067          	ret

000045ac <cmd_cam_colour_gain>:

void cmd_cam_colour_gain( u16 gain_r, u16 gain_g, u16 gain_b)
{
    45ac:	fe010113          	addi	sp,sp,-32
    45b0:	00112e23          	sw	ra,28(sp)
    45b4:	00812c23          	sw	s0,24(sp)
    45b8:	00912a23          	sw	s1,20(sp)
    45bc:	01212823          	sw	s2,16(sp)
    45c0:	01312623          	sw	s3,12(sp)
    45c4:	01412423          	sw	s4,8(sp)
    45c8:	01512223          	sw	s5,4(sp)
    45cc:	00050493          	mv	s1,a0
    45d0:	00058993          	mv	s3,a1
    45d4:	00060913          	mv	s2,a2

	for(int x=0; x<4; x++)
    45d8:	00000413          	li	s0,0
    45dc:	0bc0006f          	j	4698 <cmd_cam_colour_gain+0xec>
		if(camStatus[x]!=0)
		{

			 if ( PiCam_WriteRegData(gain_r_1, (gain_r/0x100)&0xff) ==0 )
			 {
				 PiCam_WriteRegData(gain_r_0, gain_r&0xff);
    45e0:	0ff4f593          	andi	a1,s1,255
    45e4:	19d00513          	li	a0,413
    45e8:	decfe0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
				 PiCam_WriteRegData(gain_GR_1, (gain_g/0x100)&0xff);
    45ec:	0089da93          	srli	s5,s3,0x8
    45f0:	000a8593          	mv	a1,s5
    45f4:	19e00513          	li	a0,414
    45f8:	ddcfe0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
				 PiCam_WriteRegData(gain_GR_0, gain_g&0xff);
    45fc:	0ff9fa13          	andi	s4,s3,255
    4600:	000a0593          	mv	a1,s4
    4604:	19f00513          	li	a0,415
    4608:	dccfe0ef          	jal	ra,2bd4 <PiCam_WriteRegData>

				 PiCam_WriteRegData(gain_GB_1, (gain_g/0x100)&0xff);
    460c:	000a8593          	mv	a1,s5
    4610:	1a000513          	li	a0,416
    4614:	dc0fe0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
				 PiCam_WriteRegData(gain_GB_0, gain_g&0xff);
    4618:	000a0593          	mv	a1,s4
    461c:	1a100513          	li	a0,417
    4620:	db4fe0ef          	jal	ra,2bd4 <PiCam_WriteRegData>

				 PiCam_WriteRegData(gain_B_1, (gain_b/0x100)&0xff);
    4624:	00895593          	srli	a1,s2,0x8
    4628:	1a200513          	li	a0,418
    462c:	da8fe0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
				 PiCam_WriteRegData(gain_B_0, gain_b&0xff);
    4630:	0ff97593          	andi	a1,s2,255
    4634:	1a300513          	li	a0,419
    4638:	d9cfe0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
				 bsp_printf("Pi Camera %d Colour !\n\r",x);
    463c:	00040593          	mv	a1,s0
    4640:	00009537          	lui	a0,0x9
    4644:	bac50513          	addi	a0,a0,-1108 # 8bac <_data+0x198>
    4648:	b85ff0ef          	jal	ra,41cc <bsp_printf>
				 bsp_printf("Red Gain: 0x%x\n\r",gain_r);
    464c:	00048593          	mv	a1,s1
    4650:	00009537          	lui	a0,0x9
    4654:	bc450513          	addi	a0,a0,-1084 # 8bc4 <_data+0x1b0>
    4658:	b75ff0ef          	jal	ra,41cc <bsp_printf>
				 bsp_printf("Green Gain: 0x%x\n\r",gain_g);
    465c:	00098593          	mv	a1,s3
    4660:	00009537          	lui	a0,0x9
    4664:	bd850513          	addi	a0,a0,-1064 # 8bd8 <_data+0x1c4>
    4668:	b65ff0ef          	jal	ra,41cc <bsp_printf>
				 bsp_printf("Blue Gain: 0x%x\n\r",gain_b);
    466c:	00090593          	mv	a1,s2
    4670:	00009537          	lui	a0,0x9
    4674:	bec50513          	addi	a0,a0,-1044 # 8bec <_data+0x1d8>
    4678:	b55ff0ef          	jal	ra,41cc <bsp_printf>

			 }

		}
		bsp_uDelay(200000);
    467c:	f8b00637          	lui	a2,0xf8b00
    4680:	05f5e5b7          	lui	a1,0x5f5e
    4684:	10058593          	addi	a1,a1,256 # 5f5e100 <__freertos_irq_stack_top+0x5f0a690>
    4688:	00031537          	lui	a0,0x31
    468c:	d4050513          	addi	a0,a0,-704 # 30d40 <raw_table2+0xa8d4>
    4690:	fc8ff0ef          	jal	ra,3e58 <clint_uDelay>
	for(int x=0; x<4; x++)
    4694:	00140413          	addi	s0,s0,1
    4698:	00300793          	li	a5,3
    469c:	0287ca63          	blt	a5,s0,46d0 <cmd_cam_colour_gain+0x124>
    46a0:	f81107b7          	lui	a5,0xf8110
    46a4:	0287a823          	sw	s0,48(a5) # f8110030 <__freertos_irq_stack_top+0xf80bc5c0>
		if(camStatus[x]!=0)
    46a8:	00241793          	slli	a5,s0,0x2
    46ac:	c3018713          	addi	a4,gp,-976 # 52480 <camStatus>
    46b0:	00f707b3          	add	a5,a4,a5
    46b4:	0007a783          	lw	a5,0(a5)
    46b8:	fc0782e3          	beqz	a5,467c <cmd_cam_colour_gain+0xd0>
			 if ( PiCam_WriteRegData(gain_r_1, (gain_r/0x100)&0xff) ==0 )
    46bc:	0084d593          	srli	a1,s1,0x8
    46c0:	19c00513          	li	a0,412
    46c4:	d10fe0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
    46c8:	fa051ae3          	bnez	a0,467c <cmd_cam_colour_gain+0xd0>
    46cc:	f15ff06f          	j	45e0 <cmd_cam_colour_gain+0x34>

	}

}
    46d0:	01c12083          	lw	ra,28(sp)
    46d4:	01812403          	lw	s0,24(sp)
    46d8:	01412483          	lw	s1,20(sp)
    46dc:	01012903          	lw	s2,16(sp)
    46e0:	00c12983          	lw	s3,12(sp)
    46e4:	00812a03          	lw	s4,8(sp)
    46e8:	00412a83          	lw	s5,4(sp)
    46ec:	02010113          	addi	sp,sp,32
    46f0:	00008067          	ret

000046f4 <inital_video_stream>:
{
    46f4:	fe010113          	addi	sp,sp,-32
    46f8:	00112e23          	sw	ra,28(sp)
    46fc:	00812c23          	sw	s0,24(sp)
    4700:	00912a23          	sw	s1,20(sp)
    4704:	01212823          	sw	s2,16(sp)
    4708:	01312623          	sw	s3,12(sp)
    470c:	01412423          	sw	s4,8(sp)
	mipi_i2c_init();
    4710:	525030ef          	jal	ra,8434 <mipi_i2c_init>
        return *((volatile u32*) address);
    4714:	f81107b7          	lui	a5,0xf8110
    4718:	0047a483          	lw	s1,4(a5) # f8110004 <__freertos_irq_stack_top+0xf80bc594>
	apb3_rd &= (~0x07);
    471c:	ff84f493          	andi	s1,s1,-8
	for(int i=0;i<FRAME_SIZE_RX*8; i++)
    4720:	00000713          	li	a4,0
    4724:	003f47b7          	lui	a5,0x3f4
    4728:	7ff78793          	addi	a5,a5,2047 # 3f47ff <__freertos_irq_stack_top+0x3a0d8f>
    472c:	00e7ce63          	blt	a5,a4,4748 <inital_video_stream+0x54>
		mem_framebuffer[i] = 0x00000000;
    4730:	00271693          	slli	a3,a4,0x2
    4734:	050007b7          	lui	a5,0x5000
    4738:	00d787b3          	add	a5,a5,a3
    473c:	0007a023          	sw	zero,0(a5) # 5000000 <__freertos_irq_stack_top+0x4fac590>
	for(int i=0;i<FRAME_SIZE_RX*8; i++)
    4740:	00170713          	addi	a4,a4,1
    4744:	fe1ff06f          	j	4724 <inital_video_stream+0x30>
	framebuffer_ptr[0] =  mem_framebuffer;
    4748:	17018413          	addi	s0,gp,368 # 529c0 <framebuffer_ptr>
    474c:	050007b7          	lui	a5,0x5000
    4750:	00f42023          	sw	a5,0(s0)
	framebuffer_ptr[1] =  mem_framebuffer  +FRAME_SIZE_RX*1;
    4754:	051fa7b7          	lui	a5,0x51fa
    4758:	40078793          	addi	a5,a5,1024 # 51fa400 <__freertos_irq_stack_top+0x51a6990>
    475c:	00f42223          	sw	a5,4(s0)
	framebuffer_ptr[2] =  mem_framebuffer  +FRAME_SIZE_RX*2;
    4760:	053f57b7          	lui	a5,0x53f5
    4764:	80078793          	addi	a5,a5,-2048 # 53f4800 <__freertos_irq_stack_top+0x53a0d90>
    4768:	00f42423          	sw	a5,8(s0)
	framebuffer_ptr[3] =  mem_framebuffer  +FRAME_SIZE_RX*3;
    476c:	055ef7b7          	lui	a5,0x55ef
    4770:	c0078793          	addi	a5,a5,-1024 # 55eec00 <__freertos_irq_stack_top+0x559b190>
    4774:	00f42623          	sw	a5,12(s0)
	bsp_printf("address %x\r\n", framebuffer_ptr[0]);
    4778:	050005b7          	lui	a1,0x5000
    477c:	00009937          	lui	s2,0x9
    4780:	c0090513          	addi	a0,s2,-1024 # 8c00 <_data+0x1ec>
    4784:	a49ff0ef          	jal	ra,41cc <bsp_printf>
	bsp_printf("address %x\r\n", framebuffer_ptr[1]);
    4788:	00442583          	lw	a1,4(s0)
    478c:	c0090513          	addi	a0,s2,-1024
    4790:	a3dff0ef          	jal	ra,41cc <bsp_printf>
	bsp_printf("address %x\r\n", framebuffer_ptr[2]);
    4794:	00842583          	lw	a1,8(s0)
    4798:	c0090513          	addi	a0,s2,-1024
    479c:	a31ff0ef          	jal	ra,41cc <bsp_printf>
	bsp_printf("address %x\r\n", framebuffer_ptr[3]);
    47a0:	00c42583          	lw	a1,12(s0)
    47a4:	c0090513          	addi	a0,s2,-1024
    47a8:	a25ff0ef          	jal	ra,41cc <bsp_printf>
	bsp_printf("address %x\r\n", (u32)descriptors0);
    47ac:	010005b7          	lui	a1,0x1000
    47b0:	c0090513          	addi	a0,s2,-1024
    47b4:	a19ff0ef          	jal	ra,41cc <bsp_printf>
	bsp_printf(" Cameras Initial !\n\r");
    47b8:	00009537          	lui	a0,0x9
    47bc:	c1050513          	addi	a0,a0,-1008 # 8c10 <_data+0x1fc>
    47c0:	a0dff0ef          	jal	ra,41cc <bsp_printf>
	mipi_i2c_init();
    47c4:	471030ef          	jal	ra,8434 <mipi_i2c_init>
        *((volatile u32*) address) = data;
    47c8:	f81107b7          	lui	a5,0xf8110
    47cc:	0207a823          	sw	zero,48(a5) # f8110030 <__freertos_irq_stack_top+0xf80bc5c0>
    47d0:	0207a823          	sw	zero,48(a5)
				bsp_printf("GMSL Initial!\n\r",0 );
    47d4:	00000593          	li	a1,0
    47d8:	00009537          	lui	a0,0x9
    47dc:	c2850513          	addi	a0,a0,-984 # 8c28 <_data+0x214>
    47e0:	9edff0ef          	jal	ra,41cc <bsp_printf>
				if(GMSL_SerDes_init())
    47e4:	28c020ef          	jal	ra,6a70 <GMSL_SerDes_init>
    47e8:	00050e63          	beqz	a0,4804 <inital_video_stream+0x110>
					bsp_printf("GMSL Serilizer and Deserilizer Initial Error!\n\r",0 );
    47ec:	00000593          	li	a1,0
    47f0:	00009537          	lui	a0,0x9
    47f4:	c3850513          	addi	a0,a0,-968 # 8c38 <_data+0x224>
    47f8:	9d5ff0ef          	jal	ra,41cc <bsp_printf>
	for(int i=0;i<FRAME_SIZE_RX*8; i++)
    47fc:	00000413          	li	s0,0
    4800:	04c0006f          	j	484c <inital_video_stream+0x158>
					bsp_printf("GMSL Serilizer and Deserilizer Initial Done!\n\r",0);
    4804:	00000593          	li	a1,0
    4808:	00009537          	lui	a0,0x9
    480c:	c6850513          	addi	a0,a0,-920 # 8c68 <_data+0x254>
    4810:	9bdff0ef          	jal	ra,41cc <bsp_printf>
    4814:	fe9ff06f          	j	47fc <inital_video_stream+0x108>
		camStatus[x] = 0;
    4818:	00241713          	slli	a4,s0,0x2
    481c:	c3018793          	addi	a5,gp,-976 # 52480 <camStatus>
    4820:	00e787b3          	add	a5,a5,a4
    4824:	0007a023          	sw	zero,0(a5)
    4828:	f81107b7          	lui	a5,0xf8110
    482c:	0287a823          	sw	s0,48(a5) # f8110030 <__freertos_irq_stack_top+0xf80bc5c0>
		bsp_uDelay(200000);
    4830:	f8b00637          	lui	a2,0xf8b00
    4834:	05f5e5b7          	lui	a1,0x5f5e
    4838:	10058593          	addi	a1,a1,256 # 5f5e100 <__freertos_irq_stack_top+0x5f0a690>
    483c:	00031537          	lui	a0,0x31
    4840:	d4050513          	addi	a0,a0,-704 # 30d40 <raw_table2+0xa8d4>
    4844:	e14ff0ef          	jal	ra,3e58 <clint_uDelay>
	for(int x=0; x<4; x++)
    4848:	00140413          	addi	s0,s0,1
    484c:	00300793          	li	a5,3
    4850:	fc87d4e3          	bge	a5,s0,4818 <inital_video_stream+0x124>
    4854:	f8110437          	lui	s0,0xf8110
    4858:	00942223          	sw	s1,4(s0) # f8110004 <__freertos_irq_stack_top+0xf80bc594>
	framebuffer_pattern(framebuffer_ptr[0],0,0); //Buffer for Camera RX0
    485c:	17018493          	addi	s1,gp,368 # 529c0 <framebuffer_ptr>
    4860:	00000613          	li	a2,0
    4864:	00000593          	li	a1,0
    4868:	0004a503          	lw	a0,0(s1)
    486c:	301020ef          	jal	ra,736c <framebuffer_pattern>
	framebuffer_pattern(framebuffer_ptr[1],1,1);//Buffer for Camera RX1
    4870:	00100613          	li	a2,1
    4874:	00100593          	li	a1,1
    4878:	0044a503          	lw	a0,4(s1)
    487c:	2f1020ef          	jal	ra,736c <framebuffer_pattern>
	framebuffer_pattern(framebuffer_ptr[2],0,1);//Buffer for Camera RX2
    4880:	00100613          	li	a2,1
    4884:	00000593          	li	a1,0
    4888:	0084a503          	lw	a0,8(s1)
    488c:	2e1020ef          	jal	ra,736c <framebuffer_pattern>
	framebuffer_pattern(framebuffer_ptr[3],1,0);//Buffer for Camera RX3
    4890:	00000613          	li	a2,0
    4894:	00100593          	li	a1,1
    4898:	00c4a503          	lw	a0,12(s1)
    489c:	2d1020ef          	jal	ra,736c <framebuffer_pattern>
	dmasg_priority(DMASG_BASE, DMASG_CHANNEL0, 5, 7);
    48a0:	00700693          	li	a3,7
    48a4:	00500613          	li	a2,5
    48a8:	00000593          	li	a1,0
    48ac:	f8130537          	lui	a0,0xf8130
    48b0:	835ff0ef          	jal	ra,40e4 <dmasg_priority>
	dmasg_priority(DMASG_BASE, DMASG_CHANNEL1, 5, 7);
    48b4:	00700693          	li	a3,7
    48b8:	00500613          	li	a2,5
    48bc:	00100593          	li	a1,1
    48c0:	f8130537          	lui	a0,0xf8130
    48c4:	821ff0ef          	jal	ra,40e4 <dmasg_priority>
	dmasg_priority(DMASG_BASE, DMASG_CHANNEL2, 5, 7);
    48c8:	00700693          	li	a3,7
    48cc:	00500613          	li	a2,5
    48d0:	00200593          	li	a1,2
    48d4:	f8130537          	lui	a0,0xf8130
    48d8:	80dff0ef          	jal	ra,40e4 <dmasg_priority>
	dmasg_priority(DMASG_BASE, DMASG_CHANNEL3, 5, 7);
    48dc:	00700693          	li	a3,7
    48e0:	00500613          	li	a2,5
    48e4:	00300593          	li	a1,3
    48e8:	f8130537          	lui	a0,0xf8130
    48ec:	ff8ff0ef          	jal	ra,40e4 <dmasg_priority>
	dmasg_priority(DMASG_BASE, DMASG_CHANNEL_OVERLAY, 6, 7);
    48f0:	00700693          	li	a3,7
    48f4:	00600613          	li	a2,6
    48f8:	00500593          	li	a1,5
    48fc:	f8130537          	lui	a0,0xf8130
    4900:	fe4ff0ef          	jal	ra,40e4 <dmasg_priority>
	dmasg_priority(DMASG_BASE, DMASG_CHANNEL_HDMI, 7, 7);
    4904:	00700693          	li	a3,7
    4908:	00700613          	li	a2,7
    490c:	00400593          	li	a1,4
    4910:	f8130537          	lui	a0,0xf8130
    4914:	fd0ff0ef          	jal	ra,40e4 <dmasg_priority>
	dmasg_interrupt_config(DMASG_BASE, DMASG_CHANNEL0, DMASG_CHANNEL_INTERRUPT_INPUT_PACKET_MASK);  //Disable dmasg channel interrupt
    4918:	01000613          	li	a2,16
    491c:	00000593          	li	a1,0
    4920:	f8130537          	lui	a0,0xf8130
    4924:	f98ff0ef          	jal	ra,40bc <dmasg_interrupt_config>
	dmasg_interrupt_pending_clear(DMASG_BASE,DMASG_CHANNEL1,0xFFFFFFFF);
    4928:	fff00613          	li	a2,-1
    492c:	00100593          	li	a1,1
    4930:	f8130537          	lui	a0,0xf8130
    4934:	fa0ff0ef          	jal	ra,40d4 <dmasg_interrupt_pending_clear>
	dmasg_interrupt_config(DMASG_BASE, DMASG_CHANNEL1, DMASG_CHANNEL_INTERRUPT_INPUT_PACKET_MASK);  //Disable dmasg channel interrupt
    4938:	01000613          	li	a2,16
    493c:	00100593          	li	a1,1
    4940:	f8130537          	lui	a0,0xf8130
    4944:	f78ff0ef          	jal	ra,40bc <dmasg_interrupt_config>
	dmasg_interrupt_pending_clear(DMASG_BASE,DMASG_CHANNEL2,0xFFFFFFFF);
    4948:	fff00613          	li	a2,-1
    494c:	00200593          	li	a1,2
    4950:	f8130537          	lui	a0,0xf8130
    4954:	f80ff0ef          	jal	ra,40d4 <dmasg_interrupt_pending_clear>
	dmasg_interrupt_config(DMASG_BASE, DMASG_CHANNEL2, DMASG_CHANNEL_INTERRUPT_INPUT_PACKET_MASK);  //Disable dmasg channel interrupt
    4958:	01000613          	li	a2,16
    495c:	00200593          	li	a1,2
    4960:	f8130537          	lui	a0,0xf8130
    4964:	f58ff0ef          	jal	ra,40bc <dmasg_interrupt_config>
	dmasg_interrupt_pending_clear(DMASG_BASE,DMASG_CHANNEL3,0xFFFFFFFF);
    4968:	fff00613          	li	a2,-1
    496c:	00300593          	li	a1,3
    4970:	f8130537          	lui	a0,0xf8130
    4974:	f60ff0ef          	jal	ra,40d4 <dmasg_interrupt_pending_clear>
	dmasg_interrupt_config(DMASG_BASE, DMASG_CHANNEL3, DMASG_CHANNEL_INTERRUPT_INPUT_PACKET_MASK);  //Disable dmasg channel interrupt
    4978:	01000613          	li	a2,16
    497c:	00300593          	li	a1,3
    4980:	f8130537          	lui	a0,0xf8130
    4984:	f38ff0ef          	jal	ra,40bc <dmasg_interrupt_config>
    4988:	02042c23          	sw	zero,56(s0)
    498c:	0007f7b7          	lui	a5,0x7f
    4990:	8ff78793          	addi	a5,a5,-1793 # 7e8ff <__freertos_irq_stack_top+0x2ae8f>
    4994:	04f42223          	sw	a5,68(s0)
    4998:	04f42423          	sw	a5,72(s0)
    499c:	04f42623          	sw	a5,76(s0)
    49a0:	04f42823          	sw	a5,80(s0)
	bsp_uDelay(200000);
    49a4:	f8b00637          	lui	a2,0xf8b00
    49a8:	05f5e937          	lui	s2,0x5f5e
    49ac:	10090593          	addi	a1,s2,256 # 5f5e100 <__freertos_irq_stack_top+0x5f0a690>
    49b0:	00031537          	lui	a0,0x31
    49b4:	d4050513          	addi	a0,a0,-704 # 30d40 <raw_table2+0xa8d4>
    49b8:	ca0ff0ef          	jal	ra,3e58 <clint_uDelay>
	dma_video_in_channel_stop(DMASG_CHANNEL0);
    49bc:	00000513          	li	a0,0
    49c0:	6b5020ef          	jal	ra,7874 <dma_video_in_channel_stop>
	dma_video_in_channel_stop(DMASG_CHANNEL1);
    49c4:	00100513          	li	a0,1
    49c8:	6ad020ef          	jal	ra,7874 <dma_video_in_channel_stop>
	dma_video_in_channel_stop(DMASG_CHANNEL2);
    49cc:	00200513          	li	a0,2
    49d0:	6a5020ef          	jal	ra,7874 <dma_video_in_channel_stop>
	dma_video_in_channel_stop(DMASG_CHANNEL3);
    49d4:	00300513          	li	a0,3
    49d8:	69d020ef          	jal	ra,7874 <dma_video_in_channel_stop>
	lastChannel = DMASG_CHANNEL0;
    49dc:	8001ac23          	sw	zero,-2024(gp) # 52068 <lastChannel>
    49e0:	02042c23          	sw	zero,56(s0)
	bsp_uDelay(400000);
    49e4:	f8b00637          	lui	a2,0xf8b00
    49e8:	10090593          	addi	a1,s2,256
    49ec:	000629b7          	lui	s3,0x62
    49f0:	a8098513          	addi	a0,s3,-1408 # 61a80 <__freertos_irq_stack_top+0xe010>
    49f4:	c64ff0ef          	jal	ra,3e58 <clint_uDelay>
	dma_video_in_channel_execution(framebuffer_ptr[0], 	DMASG_CHANNEL0);
    49f8:	00000593          	li	a1,0
    49fc:	0004a503          	lw	a0,0(s1)
    4a00:	2b9020ef          	jal	ra,74b8 <dma_video_in_channel_execution>
	dma_video_in_channel_execution(framebuffer_ptr[1], 	DMASG_CHANNEL1);
    4a04:	00100593          	li	a1,1
    4a08:	0044a503          	lw	a0,4(s1)
    4a0c:	2ad020ef          	jal	ra,74b8 <dma_video_in_channel_execution>
	dma_video_in_channel_execution(framebuffer_ptr[2], 	DMASG_CHANNEL2);
    4a10:	00200593          	li	a1,2
    4a14:	0084a503          	lw	a0,8(s1)
    4a18:	2a1020ef          	jal	ra,74b8 <dma_video_in_channel_execution>
	dma_video_in_channel_execution(framebuffer_ptr[3],	DMASG_CHANNEL3);
    4a1c:	00300593          	li	a1,3
    4a20:	00c4a503          	lw	a0,12(s1)
    4a24:	295020ef          	jal	ra,74b8 <dma_video_in_channel_execution>
    4a28:	00f00a13          	li	s4,15
    4a2c:	03442c23          	sw	s4,56(s0)
	bsp_uDelay(400000);
    4a30:	f8b00637          	lui	a2,0xf8b00
    4a34:	10090593          	addi	a1,s2,256
    4a38:	a8098513          	addi	a0,s3,-1408
    4a3c:	c1cff0ef          	jal	ra,3e58 <clint_uDelay>
	dma_video_out_scrop_frame(framebuffer_ptr[DMASG_CHANNEL0],0, 0 ,descriptors0 );
    4a40:	010006b7          	lui	a3,0x1000
    4a44:	00000613          	li	a2,0
    4a48:	00000593          	li	a1,0
    4a4c:	0004a503          	lw	a0,0(s1)
    4a50:	059030ef          	jal	ra,82a8 <dma_video_out_scrop_frame>
	bsp_uDelay(400000);
    4a54:	f8b00637          	lui	a2,0xf8b00
    4a58:	10090593          	addi	a1,s2,256
    4a5c:	a8098513          	addi	a0,s3,-1408
    4a60:	bf8ff0ef          	jal	ra,3e58 <clint_uDelay>
    4a64:	02042023          	sw	zero,32(s0)
    4a68:	21c00793          	li	a5,540
    4a6c:	02f42223          	sw	a5,36(s0)
    4a70:	02042423          	sw	zero,40(s0)
    4a74:	78000793          	li	a5,1920
    4a78:	02f42623          	sw	a5,44(s0)
    4a7c:	00100793          	li	a5,1
    4a80:	02f42a23          	sw	a5,52(s0)
    4a84:	03442e23          	sw	s4,60(s0)
	cmd_cam_brightnes((cam_brightness/0x1000)&0xff, cam_brightness&0xfff);
    4a88:	8281a783          	lw	a5,-2008(gp) # 52078 <cam_brightness>
    4a8c:	41f7d513          	srai	a0,a5,0x1f
    4a90:	000015b7          	lui	a1,0x1
    4a94:	fff58593          	addi	a1,a1,-1 # fff <CUSTOM2+0xfa4>
    4a98:	00b57533          	and	a0,a0,a1
    4a9c:	00f50533          	add	a0,a0,a5
    4aa0:	40c55513          	srai	a0,a0,0xc
    4aa4:	01079793          	slli	a5,a5,0x10
    4aa8:	0107d793          	srli	a5,a5,0x10
    4aac:	00b7f5b3          	and	a1,a5,a1
    4ab0:	0ff57513          	andi	a0,a0,255
    4ab4:	a29ff0ef          	jal	ra,44dc <cmd_cam_brightnes>
	cmd_cam_colour_gain(cam_gain_r, cam_gain_g, cam_gain_b);
    4ab8:	81c1d603          	lhu	a2,-2020(gp) # 5206c <cam_gain_b>
    4abc:	8201d583          	lhu	a1,-2016(gp) # 52070 <cam_gain_g>
    4ac0:	8241d503          	lhu	a0,-2012(gp) # 52074 <cam_gain_r>
    4ac4:	ae9ff0ef          	jal	ra,45ac <cmd_cam_colour_gain>
}
    4ac8:	01c12083          	lw	ra,28(sp)
    4acc:	01812403          	lw	s0,24(sp)
    4ad0:	01412483          	lw	s1,20(sp)
    4ad4:	01012903          	lw	s2,16(sp)
    4ad8:	00c12983          	lw	s3,12(sp)
    4adc:	00812a03          	lw	s4,8(sp)
    4ae0:	02010113          	addi	sp,sp,32
    4ae4:	00008067          	ret

00004ae8 <overlay_update>:


void overlay_update(uint32_t type)
{

}
    4ae8:	00008067          	ret

00004aec <cmd_operation>:


void cmd_operation(uint8_t key )
{
    4aec:	ff010113          	addi	sp,sp,-16
    4af0:	00112623          	sw	ra,12(sp)
    4af4:	00812423          	sw	s0,8(sp)
    4af8:	00912223          	sw	s1,4(sp)
	if(key == '1')
    4afc:	03100793          	li	a5,49
    4b00:	04f50463          	beq	a0,a5,4b48 <cmd_operation+0x5c>
     	bsp_uDelay(200000);
       	dma_video_out_scrop_frame(framebuffer_ptr[DMASG_CHANNEL0],0, 0, descriptors0 );
     	APB3_REGW(OOB_APB_SLV, APB3_SLV_REG_STREAM_OUT, 0x05);

	}
	else if (key == '2')
    4b04:	03200793          	li	a5,50
    4b08:	08f50463          	beq	a0,a5,4b90 <cmd_operation+0xa4>
		APB3_REGW(OOB_APB_SLV, APB3_SLV_REG_STREAM_OUT, 0x00);
		bsp_uDelay(200000);
		dma_video_out_scrop_frame(framebuffer_ptr[DMASG_CHANNEL1],0, 0, descriptors0 );
    	APB3_REGW(OOB_APB_SLV, APB3_SLV_REG_STREAM_OUT, 0x05);
	}
	else if (key == '3')
    4b0c:	03300793          	li	a5,51
    4b10:	0cf50863          	beq	a0,a5,4be0 <cmd_operation+0xf4>
		bsp_uDelay(200000);
		dma_video_out_scrop_frame(framebuffer_ptr[DMASG_CHANNEL2],0, 0,descriptors0 );

		APB3_REGW(OOB_APB_SLV, APB3_SLV_REG_STREAM_OUT, 0x05);
	}
	else if (key == '4')
    4b14:	03400793          	li	a5,52
    4b18:	10f50c63          	beq	a0,a5,4c30 <cmd_operation+0x144>
		bsp_uDelay(200000);
		dma_video_out_scrop_frame(framebuffer_ptr[DMASG_CHANNEL3],0, 0, descriptors0 );

		APB3_REGW(OOB_APB_SLV, APB3_SLV_REG_STREAM_OUT, 0x05);
	}
	else if (key == '5')
    4b1c:	03500793          	li	a5,53
    4b20:	16f50063          	beq	a0,a5,4c80 <cmd_operation+0x194>
		dma_video_out_split4_frame(framebuffer_ptr[0], framebuffer_ptr[1], framebuffer_ptr[2], framebuffer_ptr[3], descriptors0 );

		APB3_REGW(OOB_APB_SLV, APB3_SLV_REG_STREAM_OUT, 0x05);

	}
	else if (key == '6')
    4b24:	03600793          	li	a5,54
    4b28:	1af50663          	beq	a0,a5,4cd4 <cmd_operation+0x1e8>
		dma_video_out_split2_frame(framebuffer_ptr[0],framebuffer_ptr[1], descriptors0 );
		APB3_REGW(OOB_APB_SLV, APB3_SLV_REG_STREAM_OUT, 0x05);


	}
	else if (key == '7')
    4b2c:	03700793          	li	a5,55
    4b30:	1ef50663          	beq	a0,a5,4d1c <cmd_operation+0x230>
	}




}
    4b34:	00c12083          	lw	ra,12(sp)
    4b38:	00812403          	lw	s0,8(sp)
    4b3c:	00412483          	lw	s1,4(sp)
    4b40:	01010113          	addi	sp,sp,16
    4b44:	00008067          	ret
		swithCmdPtr = 0;
    4b48:	8801a023          	sw	zero,-1920(gp) # 520d0 <swithCmdPtr>
		dma_video_out_stop();
    4b4c:	565020ef          	jal	ra,78b0 <dma_video_out_stop>
    4b50:	f8110437          	lui	s0,0xf8110
    4b54:	02042e23          	sw	zero,60(s0) # f811003c <__freertos_irq_stack_top+0xf80bc5cc>
     	bsp_uDelay(200000);
    4b58:	f8b00637          	lui	a2,0xf8b00
    4b5c:	05f5e5b7          	lui	a1,0x5f5e
    4b60:	10058593          	addi	a1,a1,256 # 5f5e100 <__freertos_irq_stack_top+0x5f0a690>
    4b64:	00031537          	lui	a0,0x31
    4b68:	d4050513          	addi	a0,a0,-704 # 30d40 <raw_table2+0xa8d4>
    4b6c:	aecff0ef          	jal	ra,3e58 <clint_uDelay>
       	dma_video_out_scrop_frame(framebuffer_ptr[DMASG_CHANNEL0],0, 0, descriptors0 );
    4b70:	010006b7          	lui	a3,0x1000
    4b74:	00000613          	li	a2,0
    4b78:	00000593          	li	a1,0
    4b7c:	1701a503          	lw	a0,368(gp) # 529c0 <framebuffer_ptr>
    4b80:	728030ef          	jal	ra,82a8 <dma_video_out_scrop_frame>
    4b84:	00500793          	li	a5,5
    4b88:	02f42e23          	sw	a5,60(s0)
    4b8c:	fa9ff06f          	j	4b34 <cmd_operation+0x48>
		swithCmdPtr = 1;
    4b90:	00100713          	li	a4,1
    4b94:	88e1a023          	sw	a4,-1920(gp) # 520d0 <swithCmdPtr>
		dma_video_out_stop();
    4b98:	519020ef          	jal	ra,78b0 <dma_video_out_stop>
    4b9c:	f8110437          	lui	s0,0xf8110
    4ba0:	02042e23          	sw	zero,60(s0) # f811003c <__freertos_irq_stack_top+0xf80bc5cc>
		bsp_uDelay(200000);
    4ba4:	f8b00637          	lui	a2,0xf8b00
    4ba8:	05f5e5b7          	lui	a1,0x5f5e
    4bac:	10058593          	addi	a1,a1,256 # 5f5e100 <__freertos_irq_stack_top+0x5f0a690>
    4bb0:	00031537          	lui	a0,0x31
    4bb4:	d4050513          	addi	a0,a0,-704 # 30d40 <raw_table2+0xa8d4>
    4bb8:	aa0ff0ef          	jal	ra,3e58 <clint_uDelay>
		dma_video_out_scrop_frame(framebuffer_ptr[DMASG_CHANNEL1],0, 0, descriptors0 );
    4bbc:	010006b7          	lui	a3,0x1000
    4bc0:	00000613          	li	a2,0
    4bc4:	00000593          	li	a1,0
    4bc8:	17018793          	addi	a5,gp,368 # 529c0 <framebuffer_ptr>
    4bcc:	0047a503          	lw	a0,4(a5)
    4bd0:	6d8030ef          	jal	ra,82a8 <dma_video_out_scrop_frame>
    4bd4:	00500793          	li	a5,5
    4bd8:	02f42e23          	sw	a5,60(s0)
    4bdc:	f59ff06f          	j	4b34 <cmd_operation+0x48>
		swithCmdPtr = 2;
    4be0:	00200713          	li	a4,2
    4be4:	88e1a023          	sw	a4,-1920(gp) # 520d0 <swithCmdPtr>
		dma_video_out_stop();
    4be8:	4c9020ef          	jal	ra,78b0 <dma_video_out_stop>
    4bec:	f8110437          	lui	s0,0xf8110
    4bf0:	02042e23          	sw	zero,60(s0) # f811003c <__freertos_irq_stack_top+0xf80bc5cc>
		bsp_uDelay(200000);
    4bf4:	f8b00637          	lui	a2,0xf8b00
    4bf8:	05f5e5b7          	lui	a1,0x5f5e
    4bfc:	10058593          	addi	a1,a1,256 # 5f5e100 <__freertos_irq_stack_top+0x5f0a690>
    4c00:	00031537          	lui	a0,0x31
    4c04:	d4050513          	addi	a0,a0,-704 # 30d40 <raw_table2+0xa8d4>
    4c08:	a50ff0ef          	jal	ra,3e58 <clint_uDelay>
		dma_video_out_scrop_frame(framebuffer_ptr[DMASG_CHANNEL2],0, 0,descriptors0 );
    4c0c:	010006b7          	lui	a3,0x1000
    4c10:	00000613          	li	a2,0
    4c14:	00000593          	li	a1,0
    4c18:	17018793          	addi	a5,gp,368 # 529c0 <framebuffer_ptr>
    4c1c:	0087a503          	lw	a0,8(a5)
    4c20:	688030ef          	jal	ra,82a8 <dma_video_out_scrop_frame>
    4c24:	00500793          	li	a5,5
    4c28:	02f42e23          	sw	a5,60(s0)
    4c2c:	f09ff06f          	j	4b34 <cmd_operation+0x48>
		swithCmdPtr = 3;
    4c30:	00300713          	li	a4,3
    4c34:	88e1a023          	sw	a4,-1920(gp) # 520d0 <swithCmdPtr>
		dma_video_out_stop();
    4c38:	479020ef          	jal	ra,78b0 <dma_video_out_stop>
    4c3c:	f8110437          	lui	s0,0xf8110
    4c40:	02042e23          	sw	zero,60(s0) # f811003c <__freertos_irq_stack_top+0xf80bc5cc>
		bsp_uDelay(200000);
    4c44:	f8b00637          	lui	a2,0xf8b00
    4c48:	05f5e5b7          	lui	a1,0x5f5e
    4c4c:	10058593          	addi	a1,a1,256 # 5f5e100 <__freertos_irq_stack_top+0x5f0a690>
    4c50:	00031537          	lui	a0,0x31
    4c54:	d4050513          	addi	a0,a0,-704 # 30d40 <raw_table2+0xa8d4>
    4c58:	a00ff0ef          	jal	ra,3e58 <clint_uDelay>
		dma_video_out_scrop_frame(framebuffer_ptr[DMASG_CHANNEL3],0, 0, descriptors0 );
    4c5c:	010006b7          	lui	a3,0x1000
    4c60:	00000613          	li	a2,0
    4c64:	00000593          	li	a1,0
    4c68:	17018793          	addi	a5,gp,368 # 529c0 <framebuffer_ptr>
    4c6c:	00c7a503          	lw	a0,12(a5)
    4c70:	638030ef          	jal	ra,82a8 <dma_video_out_scrop_frame>
    4c74:	00500793          	li	a5,5
    4c78:	02f42e23          	sw	a5,60(s0)
    4c7c:	eb9ff06f          	j	4b34 <cmd_operation+0x48>
		swithCmdPtr = 4;
    4c80:	00400713          	li	a4,4
    4c84:	88e1a023          	sw	a4,-1920(gp) # 520d0 <swithCmdPtr>
		dma_video_out_stop();
    4c88:	429020ef          	jal	ra,78b0 <dma_video_out_stop>
    4c8c:	f8110437          	lui	s0,0xf8110
    4c90:	02042e23          	sw	zero,60(s0) # f811003c <__freertos_irq_stack_top+0xf80bc5cc>
		bsp_uDelay(200000);
    4c94:	f8b00637          	lui	a2,0xf8b00
    4c98:	05f5e5b7          	lui	a1,0x5f5e
    4c9c:	10058593          	addi	a1,a1,256 # 5f5e100 <__freertos_irq_stack_top+0x5f0a690>
    4ca0:	00031537          	lui	a0,0x31
    4ca4:	d4050513          	addi	a0,a0,-704 # 30d40 <raw_table2+0xa8d4>
    4ca8:	9b0ff0ef          	jal	ra,3e58 <clint_uDelay>
		dma_video_out_split4_frame(framebuffer_ptr[0], framebuffer_ptr[1], framebuffer_ptr[2], framebuffer_ptr[3], descriptors0 );
    4cac:	17018793          	addi	a5,gp,368 # 529c0 <framebuffer_ptr>
    4cb0:	01000737          	lui	a4,0x1000
    4cb4:	00c7a683          	lw	a3,12(a5)
    4cb8:	0087a603          	lw	a2,8(a5)
    4cbc:	0047a583          	lw	a1,4(a5)
    4cc0:	0007a503          	lw	a0,0(a5)
    4cc4:	234030ef          	jal	ra,7ef8 <dma_video_out_split4_frame>
    4cc8:	00500793          	li	a5,5
    4ccc:	02f42e23          	sw	a5,60(s0)
    4cd0:	e65ff06f          	j	4b34 <cmd_operation+0x48>
		swithCmdPtr = 5;
    4cd4:	00500493          	li	s1,5
    4cd8:	8891a023          	sw	s1,-1920(gp) # 520d0 <swithCmdPtr>
		dma_video_out_stop();
    4cdc:	3d5020ef          	jal	ra,78b0 <dma_video_out_stop>
    4ce0:	f8110437          	lui	s0,0xf8110
    4ce4:	02042e23          	sw	zero,60(s0) # f811003c <__freertos_irq_stack_top+0xf80bc5cc>
		bsp_uDelay(200000);
    4ce8:	f8b00637          	lui	a2,0xf8b00
    4cec:	05f5e5b7          	lui	a1,0x5f5e
    4cf0:	10058593          	addi	a1,a1,256 # 5f5e100 <__freertos_irq_stack_top+0x5f0a690>
    4cf4:	00031537          	lui	a0,0x31
    4cf8:	d4050513          	addi	a0,a0,-704 # 30d40 <raw_table2+0xa8d4>
    4cfc:	95cff0ef          	jal	ra,3e58 <clint_uDelay>
		dma_video_out_split2_frame(framebuffer_ptr[0],framebuffer_ptr[1], descriptors0 );
    4d00:	17018793          	addi	a5,gp,368 # 529c0 <framebuffer_ptr>
    4d04:	01000637          	lui	a2,0x1000
    4d08:	0047a583          	lw	a1,4(a5)
    4d0c:	0007a503          	lw	a0,0(a5)
    4d10:	7e5020ef          	jal	ra,7cf4 <dma_video_out_split2_frame>
    4d14:	02942e23          	sw	s1,60(s0)
    4d18:	e1dff06f          	j	4b34 <cmd_operation+0x48>
		swithCmdPtr = 6;
    4d1c:	00600713          	li	a4,6
    4d20:	88e1a023          	sw	a4,-1920(gp) # 520d0 <swithCmdPtr>
		dma_video_out_stop();
    4d24:	38d020ef          	jal	ra,78b0 <dma_video_out_stop>
    4d28:	f8110437          	lui	s0,0xf8110
    4d2c:	02042e23          	sw	zero,60(s0) # f811003c <__freertos_irq_stack_top+0xf80bc5cc>
		bsp_uDelay(200000);
    4d30:	f8b00637          	lui	a2,0xf8b00
    4d34:	05f5e5b7          	lui	a1,0x5f5e
    4d38:	10058593          	addi	a1,a1,256 # 5f5e100 <__freertos_irq_stack_top+0x5f0a690>
    4d3c:	00031537          	lui	a0,0x31
    4d40:	d4050513          	addi	a0,a0,-704 # 30d40 <raw_table2+0xa8d4>
    4d44:	914ff0ef          	jal	ra,3e58 <clint_uDelay>
		dma_video_out_split2_frame(framebuffer_ptr[2], framebuffer_ptr[3], descriptors0 );
    4d48:	17018793          	addi	a5,gp,368 # 529c0 <framebuffer_ptr>
    4d4c:	01000637          	lui	a2,0x1000
    4d50:	00c7a583          	lw	a1,12(a5)
    4d54:	0087a503          	lw	a0,8(a5)
    4d58:	79d020ef          	jal	ra,7cf4 <dma_video_out_split2_frame>
    4d5c:	00500793          	li	a5,5
    4d60:	02f42e23          	sw	a5,60(s0)
}
    4d64:	dd1ff06f          	j	4b34 <cmd_operation+0x48>

00004d68 <switch2cmd>:
u32 NextDisplayMode	= 0x01; // next display mode 0: Camera Mode, 1: Colour Pattern Mode, 2:All Black Pattern Mode



void switch2cmd()
{
    4d68:	fe010113          	addi	sp,sp,-32
    4d6c:	00112e23          	sw	ra,28(sp)
	uint8_t command[7] = {'1','2','3','4','5','6','7'};
    4d70:	83818793          	addi	a5,gp,-1992 # 52088 <_impure_ptr+0x4>
    4d74:	0007a703          	lw	a4,0(a5)
    4d78:	00e12423          	sw	a4,8(sp)
    4d7c:	0047d703          	lhu	a4,4(a5)
    4d80:	00e11623          	sh	a4,12(sp)
    4d84:	0067c783          	lbu	a5,6(a5)
    4d88:	00f10723          	sb	a5,14(sp)

	swithCmdPtr++;
    4d8c:	8801a783          	lw	a5,-1920(gp) # 520d0 <swithCmdPtr>
    4d90:	00178793          	addi	a5,a5,1
    4d94:	88f1a023          	sw	a5,-1920(gp) # 520d0 <swithCmdPtr>
	if(swithCmdPtr>=7)
    4d98:	00600713          	li	a4,6
    4d9c:	00f77463          	bgeu	a4,a5,4da4 <switch2cmd+0x3c>
	{
		swithCmdPtr=0;
    4da0:	8801a023          	sw	zero,-1920(gp) # 520d0 <swithCmdPtr>

	}
	cmd_operation(command[swithCmdPtr]);
    4da4:	8801a783          	lw	a5,-1920(gp) # 520d0 <swithCmdPtr>
    4da8:	01010713          	addi	a4,sp,16
    4dac:	00f707b3          	add	a5,a4,a5
    4db0:	ff87c503          	lbu	a0,-8(a5)
    4db4:	d39ff0ef          	jal	ra,4aec <cmd_operation>

}
    4db8:	01c12083          	lw	ra,28(sp)
    4dbc:	02010113          	addi	sp,sp,32
    4dc0:	00008067          	ret

00004dc4 <swtich_event>:
void swtich_event()
{
    4dc4:	ff010113          	addi	sp,sp,-16
    4dc8:	00112623          	sw	ra,12(sp)
    4dcc:	00812423          	sw	s0,8(sp)
        return *((volatile u32*) address);
    4dd0:	f81107b7          	lui	a5,0xf8110
    4dd4:	0147a403          	lw	s0,20(a5) # f8110014 <__freertos_irq_stack_top+0xf80bc5a4>

	u32 rd_apb3 = APB3_REGR(OOB_APB_SLV, APB3_SLV_REG5_SW_IN);
	rd_apb3 &= MASK_ALL;
    4dd8:	00347413          	andi	s0,s0,3


	if(last_switch!=rd_apb3)
    4ddc:	8141a783          	lw	a5,-2028(gp) # 52064 <last_switch>
    4de0:	02878c63          	beq	a5,s0,4e18 <swtich_event+0x54>
    4de4:	f8110737          	lui	a4,0xf8110
    4de8:	00472783          	lw	a5,4(a4) # f8110004 <__freertos_irq_stack_top+0xf80bc594>
	{
		//bsp_printf("Event Switch 0x%x\n\r",rd_apb3);
		u32 apb3_rd = APB3_REGR(OOB_APB_SLV, APB3_SLV0_REG1_LED);
		apb3_rd &= (~0x02);
    4dec:	ffd7f793          	andi	a5,a5,-3
        *((volatile u32*) address) = data;
    4df0:	00f72223          	sw	a5,4(a4)
		APB3_REGW(OOB_APB_SLV, APB3_SLV0_REG1_LED, apb3_rd);


		if(rd_apb3 != MASK_ALL)
    4df4:	00300793          	li	a5,3
    4df8:	00f40863          	beq	s0,a5,4e08 <swtich_event+0x44>
        return *((volatile u32*) address);
    4dfc:	f81107b7          	lui	a5,0xf8110
    4e00:	0147a403          	lw	s0,20(a5) # f8110014 <__freertos_irq_stack_top+0xf80bc5a4>
		{
			rd_apb3 = APB3_REGR(OOB_APB_SLV, APB3_SLV_REG5_SW_IN);
			rd_apb3 &= MASK_ALL;
    4e04:	00347413          	andi	s0,s0,3

		}


		if(rd_apb3==MASK_SW1)
    4e08:	00200793          	li	a5,2
    4e0c:	02f40063          	beq	s0,a5,4e2c <swtich_event+0x68>
		{
			 bsp_printf("Event Switch 0\n\r");

		}
		else if(rd_apb3==MASK_SW2)
    4e10:	00100793          	li	a5,1
    4e14:	02f40463          	beq	s0,a5,4e3c <swtich_event+0x78>
			 bsp_printf("Event Switch 1\n\r");
			 switch2cmd();
		}
	}

	last_switch = rd_apb3;
    4e18:	8081aa23          	sw	s0,-2028(gp) # 52064 <last_switch>



}
    4e1c:	00c12083          	lw	ra,12(sp)
    4e20:	00812403          	lw	s0,8(sp)
    4e24:	01010113          	addi	sp,sp,16
    4e28:	00008067          	ret
			 bsp_printf("Event Switch 0\n\r");
    4e2c:	00009537          	lui	a0,0x9
    4e30:	c9850513          	addi	a0,a0,-872 # 8c98 <_data+0x284>
    4e34:	b98ff0ef          	jal	ra,41cc <bsp_printf>
    4e38:	fe1ff06f          	j	4e18 <swtich_event+0x54>
			 bsp_printf("Event Switch 1\n\r");
    4e3c:	00009537          	lui	a0,0x9
    4e40:	cac50513          	addi	a0,a0,-852 # 8cac <_data+0x298>
    4e44:	b88ff0ef          	jal	ra,41cc <bsp_printf>
			 switch2cmd();
    4e48:	f21ff0ef          	jal	ra,4d68 <switch2cmd>
    4e4c:	fcdff06f          	j	4e18 <swtich_event+0x54>

00004e50 <main>:

void main(){
    4e50:	ff010113          	addi	sp,sp,-16
    4e54:	00112623          	sw	ra,12(sp)
    4e58:	00812423          	sw	s0,8(sp)
	int index=0;

	bsp_printf("************** TI180 OOBTest *******************\r\n");
    4e5c:	00009537          	lui	a0,0x9
    4e60:	cc050513          	addi	a0,a0,-832 # 8cc0 <_data+0x2ac>
    4e64:	b68ff0ef          	jal	ra,41cc <bsp_printf>
	bsp_printf("Version :  %s\r\n", VERSION);
    4e68:	000095b7          	lui	a1,0x9
    4e6c:	cf458593          	addi	a1,a1,-780 # 8cf4 <_data+0x2e0>
    4e70:	00009537          	lui	a0,0x9
    4e74:	cf850513          	addi	a0,a0,-776 # 8cf8 <_data+0x2e4>
    4e78:	b54ff0ef          	jal	ra,41cc <bsp_printf>


	uint8_t key;

	IntcInitialize();
    4e7c:	e05fe0ef          	jal	ra,3c80 <IntcInitialize>
    4e80:	f81107b7          	lui	a5,0xf8110
    4e84:	0407a583          	lw	a1,64(a5) # f8110040 <__freertos_irq_stack_top+0xf80bc5d0>

	u32 HardConfig = APB3_REGR(OOB_APB_SLV, APB3_SLV_REG_HARD_CONFIG);
	bsp_printf("Hardware Configuration Code: 0x%x\n\r",HardConfig);
    4e88:	00009537          	lui	a0,0x9
    4e8c:	d0850513          	addi	a0,a0,-760 # 8d08 <_data+0x2f4>
    4e90:	b3cff0ef          	jal	ra,41cc <bsp_printf>


	inital_video_stream();
    4e94:	861ff0ef          	jal	ra,46f4 <inital_video_stream>
    4e98:	0200006f          	j	4eb8 <main+0x68>

	            cmd_operation(key );


	        }
	        bsp_uDelay(100000);
    4e9c:	f8b00637          	lui	a2,0xf8b00
    4ea0:	05f5e5b7          	lui	a1,0x5f5e
    4ea4:	10058593          	addi	a1,a1,256 # 5f5e100 <__freertos_irq_stack_top+0x5f0a690>
    4ea8:	00018537          	lui	a0,0x18
    4eac:	6a050513          	addi	a0,a0,1696 # 186a0 <raw_table3+0x7cc>
    4eb0:	fa9fe0ef          	jal	ra,3e58 <clint_uDelay>
	        swtich_event();
    4eb4:	f11ff0ef          	jal	ra,4dc4 <swtich_event>
	        if(uart_readOccupancy(BSP_UART_TERMINAL)){
    4eb8:	f8010537          	lui	a0,0xf8010
    4ebc:	eddfe0ef          	jal	ra,3d98 <uart_readOccupancy>
    4ec0:	fc050ee3          	beqz	a0,4e9c <main+0x4c>
	        	key=uart_read(BSP_UART_TERMINAL);
    4ec4:	f8010537          	lui	a0,0xf8010
    4ec8:	f5dfe0ef          	jal	ra,3e24 <uart_read>
    4ecc:	00050413          	mv	s0,a0
	            bsp_putString("echo character:");
    4ed0:	000095b7          	lui	a1,0x9
    4ed4:	d2c58593          	addi	a1,a1,-724 # 8d2c <_data+0x318>
    4ed8:	f8010537          	lui	a0,0xf8010
    4edc:	f05fe0ef          	jal	ra,3de0 <uart_writeStr>
	            bsp_putChar(key);
    4ee0:	00040593          	mv	a1,s0
    4ee4:	f8010537          	lui	a0,0xf8010
    4ee8:	ebdfe0ef          	jal	ra,3da4 <uart_write>
	            bsp_putString("\n\r");
    4eec:	000515b7          	lui	a1,0x51
    4ef0:	5a858593          	addi	a1,a1,1448 # 515a8 <raw_table+0xe60c>
    4ef4:	f8010537          	lui	a0,0xf8010
    4ef8:	ee9fe0ef          	jal	ra,3de0 <uart_writeStr>
	            cmd_operation(key );
    4efc:	00040513          	mv	a0,s0
    4f00:	bedff0ef          	jal	ra,4aec <cmd_operation>
    4f04:	f99ff06f          	j	4e9c <main+0x4c>

00004f08 <uart_writeAvailability>:
    4f08:	00452503          	lw	a0,4(a0) # f8010004 <__freertos_irq_stack_top+0xf7fbc594>
        return (read_u32(reg + UART_STATUS) >> 16) & 0xFF;
    4f0c:	01055513          	srli	a0,a0,0x10
    }
    4f10:	0ff57513          	andi	a0,a0,255
    4f14:	00008067          	ret

00004f18 <uart_write>:
    static void uart_write(u32 reg, char data){
    4f18:	ff010113          	addi	sp,sp,-16
    4f1c:	00112623          	sw	ra,12(sp)
    4f20:	00812423          	sw	s0,8(sp)
    4f24:	00912223          	sw	s1,4(sp)
    4f28:	00050413          	mv	s0,a0
    4f2c:	00058493          	mv	s1,a1
        while(uart_writeAvailability(reg) == 0);
    4f30:	00040513          	mv	a0,s0
    4f34:	fd5ff0ef          	jal	ra,4f08 <uart_writeAvailability>
    4f38:	fe050ce3          	beqz	a0,4f30 <uart_write+0x18>
        *((volatile u32*) address) = data;
    4f3c:	00942023          	sw	s1,0(s0)
    }
    4f40:	00c12083          	lw	ra,12(sp)
    4f44:	00812403          	lw	s0,8(sp)
    4f48:	00412483          	lw	s1,4(sp)
    4f4c:	01010113          	addi	sp,sp,16
    4f50:	00008067          	ret

00004f54 <uart_writeStr>:
    static void uart_writeStr(u32 reg, const char* str){
    4f54:	ff010113          	addi	sp,sp,-16
    4f58:	00112623          	sw	ra,12(sp)
    4f5c:	00812423          	sw	s0,8(sp)
    4f60:	00912223          	sw	s1,4(sp)
    4f64:	00050493          	mv	s1,a0
    4f68:	00058413          	mv	s0,a1
        while(*str) uart_write(reg, *str++);
    4f6c:	00044583          	lbu	a1,0(s0)
    4f70:	00058a63          	beqz	a1,4f84 <uart_writeStr+0x30>
    4f74:	00140413          	addi	s0,s0,1
    4f78:	00048513          	mv	a0,s1
    4f7c:	f9dff0ef          	jal	ra,4f18 <uart_write>
    4f80:	fedff06f          	j	4f6c <uart_writeStr+0x18>
    }
    4f84:	00c12083          	lw	ra,12(sp)
    4f88:	00812403          	lw	s0,8(sp)
    4f8c:	00412483          	lw	s1,4(sp)
    4f90:	01010113          	addi	sp,sp,16
    4f94:	00008067          	ret

00004f98 <Reg_Out32>:
    4f98:	00b52023          	sw	a1,0(a0)

/************************** Function File ***************************/
void Reg_Out32(u32 addr,u32 data)
{
    write_u32(data,addr);
}
    4f9c:	00008067          	ret

00004fa0 <Reg_In32>:
        return *((volatile u32*) address);
    4fa0:	00052503          	lw	a0,0(a0)

u32 Reg_In32(u32 addr)
{
    return read_u32(addr);
}
    4fa4:	00008067          	ret

00004fa8 <assert>:
    va_end(ap);
}
*/

int assert(int cond){
    if(!cond) {
    4fa8:	00050663          	beqz	a0,4fb4 <assert+0xc>
        uart_writeStr(BSP_UART_TERMINAL, " Assert failure !\n");
        return 1;
        //while(1);
    }
    return 0;
    4fac:	00000513          	li	a0,0
}
    4fb0:	00008067          	ret
int assert(int cond){
    4fb4:	ff010113          	addi	sp,sp,-16
    4fb8:	00112623          	sw	ra,12(sp)
        uart_writeStr(BSP_UART_TERMINAL, " Assert failure !\n");
    4fbc:	000095b7          	lui	a1,0x9
    4fc0:	d3c58593          	addi	a1,a1,-708 # 8d3c <_data+0x328>
    4fc4:	f8010537          	lui	a0,0xf8010
    4fc8:	f8dff0ef          	jal	ra,4f54 <uart_writeStr>
        return 1;
    4fcc:	00100513          	li	a0,1
}
    4fd0:	00c12083          	lw	ra,12(sp)
    4fd4:	01010113          	addi	sp,sp,16
    4fd8:	00008067          	ret

00004fdc <putchar>:
  }
  putchar('\n');
  return 0;
}

int putchar(int c){
    4fdc:	ff010113          	addi	sp,sp,-16
    4fe0:	00112623          	sw	ra,12(sp)
    4fe4:	00812423          	sw	s0,8(sp)
    4fe8:	00050413          	mv	s0,a0
    bsp_putChar(c);
    4fec:	0ff57593          	andi	a1,a0,255
    4ff0:	f8010537          	lui	a0,0xf8010
    4ff4:	f25ff0ef          	jal	ra,4f18 <uart_write>
    return c;
}
    4ff8:	00040513          	mv	a0,s0
    4ffc:	00c12083          	lw	ra,12(sp)
    5000:	00812403          	lw	s0,8(sp)
    5004:	01010113          	addi	sp,sp,16
    5008:	00008067          	ret

0000500c <bsp_puts>:
int bsp_puts(char *s){
    500c:	ff010113          	addi	sp,sp,-16
    5010:	00112623          	sw	ra,12(sp)
    5014:	00812423          	sw	s0,8(sp)
    5018:	00050413          	mv	s0,a0
  while (*s) {
    501c:	00044503          	lbu	a0,0(s0)
    5020:	00050863          	beqz	a0,5030 <bsp_puts+0x24>
    putchar(*s);
    5024:	fb9ff0ef          	jal	ra,4fdc <putchar>
    s++;
    5028:	00140413          	addi	s0,s0,1
    502c:	ff1ff06f          	j	501c <bsp_puts+0x10>
  putchar('\n');
    5030:	00a00513          	li	a0,10
    5034:	fa9ff0ef          	jal	ra,4fdc <putchar>
}
    5038:	00000513          	li	a0,0
    503c:	00c12083          	lw	ra,12(sp)
    5040:	00812403          	lw	s0,8(sp)
    5044:	01010113          	addi	sp,sp,16
    5048:	00008067          	ret

0000504c <print_hex>:

void print_hex(uint32_t val, uint32_t digits)
{
    504c:	ff010113          	addi	sp,sp,-16
    5050:	00112623          	sw	ra,12(sp)
    5054:	00812423          	sw	s0,8(sp)
    5058:	00912223          	sw	s1,4(sp)
    505c:	00050493          	mv	s1,a0
	for (int i = (4*digits)-4; i >= 0; i -= 4)
    5060:	40000437          	lui	s0,0x40000
    5064:	fff40413          	addi	s0,s0,-1 # 3fffffff <__freertos_irq_stack_top+0x3ffac58f>
    5068:	00858433          	add	s0,a1,s0
    506c:	00241413          	slli	s0,s0,0x2
    5070:	02044663          	bltz	s0,509c <print_hex+0x50>
		uart_write(BSP_UART_TERMINAL, "0123456789ABCDEF"[(val >> i) % 16]);
    5074:	0084d7b3          	srl	a5,s1,s0
    5078:	00f7f713          	andi	a4,a5,15
    507c:	000097b7          	lui	a5,0x9
    5080:	a7c78793          	addi	a5,a5,-1412 # 8a7c <_data+0x68>
    5084:	00e787b3          	add	a5,a5,a4
    5088:	0007c583          	lbu	a1,0(a5)
    508c:	f8010537          	lui	a0,0xf8010
    5090:	e89ff0ef          	jal	ra,4f18 <uart_write>
	for (int i = (4*digits)-4; i >= 0; i -= 4)
    5094:	ffc40413          	addi	s0,s0,-4
    5098:	fd9ff06f          	j	5070 <print_hex+0x24>
}
    509c:	00c12083          	lw	ra,12(sp)
    50a0:	00812403          	lw	s0,8(sp)
    50a4:	00412483          	lw	s1,4(sp)
    50a8:	01010113          	addi	sp,sp,16
    50ac:	00008067          	ret

000050b0 <uart_writeAvailability>:
    50b0:	00452503          	lw	a0,4(a0) # f8010004 <__freertos_irq_stack_top+0xf7fbc594>
        return (read_u32(reg + UART_STATUS) >> 16) & 0xFF;
    50b4:	01055513          	srli	a0,a0,0x10
    }
    50b8:	0ff57513          	andi	a0,a0,255
    50bc:	00008067          	ret

000050c0 <uart_write>:
    static void uart_write(u32 reg, char data){
    50c0:	ff010113          	addi	sp,sp,-16
    50c4:	00112623          	sw	ra,12(sp)
    50c8:	00812423          	sw	s0,8(sp)
    50cc:	00912223          	sw	s1,4(sp)
    50d0:	00050413          	mv	s0,a0
    50d4:	00058493          	mv	s1,a1
        while(uart_writeAvailability(reg) == 0);
    50d8:	00040513          	mv	a0,s0
    50dc:	fd5ff0ef          	jal	ra,50b0 <uart_writeAvailability>
    50e0:	fe050ce3          	beqz	a0,50d8 <uart_write+0x18>
        *((volatile u32*) address) = data;
    50e4:	00942023          	sw	s1,0(s0)
    }
    50e8:	00c12083          	lw	ra,12(sp)
    50ec:	00812403          	lw	s0,8(sp)
    50f0:	00412483          	lw	s1,4(sp)
    50f4:	01010113          	addi	sp,sp,16
    50f8:	00008067          	ret

000050fc <clint_uDelay>:
        u32 mTimePerUsec = hz/1000000;
    50fc:	000f47b7          	lui	a5,0xf4
    5100:	24078793          	addi	a5,a5,576 # f4240 <__freertos_irq_stack_top+0xa07d0>
    5104:	02f5d5b3          	divu	a1,a1,a5
    readReg_u32 (clint_getTimeLow , CLINT_TIME_ADDR)
    5108:	0000c7b7          	lui	a5,0xc
    510c:	ff878793          	addi	a5,a5,-8 # bff8 <raw_table4+0x26bc>
    5110:	00f60633          	add	a2,a2,a5
        return *((volatile u32*) address);
    5114:	00062783          	lw	a5,0(a2) # f8b00000 <__freertos_irq_stack_top+0xf8aac590>
        u32 limit = clint_getTimeLow(reg) + usec*mTimePerUsec;
    5118:	02a58533          	mul	a0,a1,a0
    511c:	00f50533          	add	a0,a0,a5
    5120:	00062783          	lw	a5,0(a2)
        while((int32_t)(limit-(clint_getTimeLow(reg))) >= 0);
    5124:	40f507b3          	sub	a5,a0,a5
    5128:	fe07dce3          	bgez	a5,5120 <clint_uDelay+0x24>
    512c:	00008067          	ret

00005130 <_putchar>:
    static void _putchar(char character){
    5130:	ff010113          	addi	sp,sp,-16
    5134:	00112623          	sw	ra,12(sp)
            bsp_putChar(character);
    5138:	00050593          	mv	a1,a0
    513c:	f8010537          	lui	a0,0xf8010
    5140:	f81ff0ef          	jal	ra,50c0 <uart_write>
    }
    5144:	00c12083          	lw	ra,12(sp)
    5148:	01010113          	addi	sp,sp,16
    514c:	00008067          	ret

00005150 <_putchar_s>:
    {
    5150:	ff010113          	addi	sp,sp,-16
    5154:	00112623          	sw	ra,12(sp)
    5158:	00812423          	sw	s0,8(sp)
    515c:	00050413          	mv	s0,a0
        while (*p)
    5160:	00044503          	lbu	a0,0(s0)
    5164:	00050863          	beqz	a0,5174 <_putchar_s+0x24>
            _putchar(*(p++));
    5168:	00140413          	addi	s0,s0,1
    516c:	fc5ff0ef          	jal	ra,5130 <_putchar>
    5170:	ff1ff06f          	j	5160 <_putchar_s+0x10>
    }
    5174:	00c12083          	lw	ra,12(sp)
    5178:	00812403          	lw	s0,8(sp)
    517c:	01010113          	addi	sp,sp,16
    5180:	00008067          	ret

00005184 <bsp_printHex>:
    {
    5184:	ff010113          	addi	sp,sp,-16
    5188:	00112623          	sw	ra,12(sp)
    518c:	00812423          	sw	s0,8(sp)
    5190:	00912223          	sw	s1,4(sp)
    5194:	00050493          	mv	s1,a0
        for (int i = (4*digits)-4; i >= 0; i -= 4) {
    5198:	01c00413          	li	s0,28
    519c:	0240006f          	j	51c0 <bsp_printHex+0x3c>
            _putchar("0123456789ABCDEF"[(val >> i) % 16]);
    51a0:	0084d7b3          	srl	a5,s1,s0
    51a4:	00f7f713          	andi	a4,a5,15
    51a8:	000097b7          	lui	a5,0x9
    51ac:	a7c78793          	addi	a5,a5,-1412 # 8a7c <_data+0x68>
    51b0:	00e787b3          	add	a5,a5,a4
    51b4:	0007c503          	lbu	a0,0(a5)
    51b8:	f79ff0ef          	jal	ra,5130 <_putchar>
        for (int i = (4*digits)-4; i >= 0; i -= 4) {
    51bc:	ffc40413          	addi	s0,s0,-4
    51c0:	fe0450e3          	bgez	s0,51a0 <bsp_printHex+0x1c>
    }
    51c4:	00c12083          	lw	ra,12(sp)
    51c8:	00812403          	lw	s0,8(sp)
    51cc:	00412483          	lw	s1,4(sp)
    51d0:	01010113          	addi	sp,sp,16
    51d4:	00008067          	ret

000051d8 <bsp_printHex_lower>:
    {
    51d8:	ff010113          	addi	sp,sp,-16
    51dc:	00112623          	sw	ra,12(sp)
    51e0:	00812423          	sw	s0,8(sp)
    51e4:	00912223          	sw	s1,4(sp)
    51e8:	00050493          	mv	s1,a0
        for (int i = (4*digits)-4; i >= 0; i -= 4) {
    51ec:	01c00413          	li	s0,28
    51f0:	0240006f          	j	5214 <bsp_printHex_lower+0x3c>
            _putchar("0123456789abcdef"[(val >> i) % 16]);
    51f4:	0084d7b3          	srl	a5,s1,s0
    51f8:	00f7f713          	andi	a4,a5,15
    51fc:	000097b7          	lui	a5,0x9
    5200:	ae478793          	addi	a5,a5,-1308 # 8ae4 <_data+0xd0>
    5204:	00e787b3          	add	a5,a5,a4
    5208:	0007c503          	lbu	a0,0(a5)
    520c:	f25ff0ef          	jal	ra,5130 <_putchar>
        for (int i = (4*digits)-4; i >= 0; i -= 4) {
    5210:	ffc40413          	addi	s0,s0,-4
    5214:	fe0450e3          	bgez	s0,51f4 <bsp_printHex_lower+0x1c>
    }
    5218:	00c12083          	lw	ra,12(sp)
    521c:	00812403          	lw	s0,8(sp)
    5220:	00412483          	lw	s1,4(sp)
    5224:	01010113          	addi	sp,sp,16
    5228:	00008067          	ret

0000522c <bsp_printf_c>:
    {
    522c:	ff010113          	addi	sp,sp,-16
    5230:	00112623          	sw	ra,12(sp)
        _putchar(c);
    5234:	0ff57513          	andi	a0,a0,255
    5238:	ef9ff0ef          	jal	ra,5130 <_putchar>
    }
    523c:	00c12083          	lw	ra,12(sp)
    5240:	01010113          	addi	sp,sp,16
    5244:	00008067          	ret

00005248 <bsp_printf_s>:
    {
    5248:	ff010113          	addi	sp,sp,-16
    524c:	00112623          	sw	ra,12(sp)
        _putchar_s(p);
    5250:	f01ff0ef          	jal	ra,5150 <_putchar_s>
    }
    5254:	00c12083          	lw	ra,12(sp)
    5258:	01010113          	addi	sp,sp,16
    525c:	00008067          	ret

00005260 <bsp_printf_d>:
    {
    5260:	fd010113          	addi	sp,sp,-48
    5264:	02112623          	sw	ra,44(sp)
    5268:	02812423          	sw	s0,40(sp)
    526c:	02912223          	sw	s1,36(sp)
    5270:	00050493          	mv	s1,a0
        if (val < 0) {
    5274:	00054663          	bltz	a0,5280 <bsp_printf_d+0x20>
    {
    5278:	00010413          	mv	s0,sp
    527c:	02c0006f          	j	52a8 <bsp_printf_d+0x48>
            bsp_printf_c('-');
    5280:	02d00513          	li	a0,45
    5284:	fa9ff0ef          	jal	ra,522c <bsp_printf_c>
            val = -val;
    5288:	409004b3          	neg	s1,s1
    528c:	fedff06f          	j	5278 <bsp_printf_d+0x18>
            *(p++) = '0' + val % 10;
    5290:	00a00713          	li	a4,10
    5294:	02e4e7b3          	rem	a5,s1,a4
    5298:	03078793          	addi	a5,a5,48
    529c:	00f40023          	sb	a5,0(s0)
            val = val / 10;
    52a0:	02e4c4b3          	div	s1,s1,a4
            *(p++) = '0' + val % 10;
    52a4:	00140413          	addi	s0,s0,1
        while (val || p == buffer) {
    52a8:	fe0494e3          	bnez	s1,5290 <bsp_printf_d+0x30>
    52ac:	00010793          	mv	a5,sp
    52b0:	fef400e3          	beq	s0,a5,5290 <bsp_printf_d+0x30>
    52b4:	0100006f          	j	52c4 <bsp_printf_d+0x64>
            bsp_printf_c(*(--p));
    52b8:	fff40413          	addi	s0,s0,-1
    52bc:	00044503          	lbu	a0,0(s0)
    52c0:	f6dff0ef          	jal	ra,522c <bsp_printf_c>
        while (p != buffer)
    52c4:	00010793          	mv	a5,sp
    52c8:	fef418e3          	bne	s0,a5,52b8 <bsp_printf_d+0x58>
    }
    52cc:	02c12083          	lw	ra,44(sp)
    52d0:	02812403          	lw	s0,40(sp)
    52d4:	02412483          	lw	s1,36(sp)
    52d8:	03010113          	addi	sp,sp,48
    52dc:	00008067          	ret

000052e0 <bsp_printf_x>:
    {
    52e0:	ff010113          	addi	sp,sp,-16
    52e4:	00112623          	sw	ra,12(sp)
        for(i=0;i<8;i++)
    52e8:	00000713          	li	a4,0
    52ec:	00700793          	li	a5,7
    52f0:	02e7c063          	blt	a5,a4,5310 <bsp_printf_x+0x30>
            if((val & (0xFFFFFFF0 <<(4*i))) == 0)
    52f4:	00271693          	slli	a3,a4,0x2
    52f8:	ff000793          	li	a5,-16
    52fc:	00d797b3          	sll	a5,a5,a3
    5300:	00f577b3          	and	a5,a0,a5
    5304:	00078663          	beqz	a5,5310 <bsp_printf_x+0x30>
        for(i=0;i<8;i++)
    5308:	00170713          	addi	a4,a4,1
    530c:	fe1ff06f          	j	52ec <bsp_printf_x+0xc>
        bsp_printHex_lower(val);
    5310:	ec9ff0ef          	jal	ra,51d8 <bsp_printHex_lower>
    }
    5314:	00c12083          	lw	ra,12(sp)
    5318:	01010113          	addi	sp,sp,16
    531c:	00008067          	ret

00005320 <bsp_printf_X>:
        {
    5320:	ff010113          	addi	sp,sp,-16
    5324:	00112623          	sw	ra,12(sp)
            for(i=0;i<8;i++)
    5328:	00000713          	li	a4,0
    532c:	00700793          	li	a5,7
    5330:	02e7c063          	blt	a5,a4,5350 <bsp_printf_X+0x30>
                if((val & (0xFFFFFFF0 <<(4*i))) == 0)
    5334:	00271693          	slli	a3,a4,0x2
    5338:	ff000793          	li	a5,-16
    533c:	00d797b3          	sll	a5,a5,a3
    5340:	00f577b3          	and	a5,a0,a5
    5344:	00078663          	beqz	a5,5350 <bsp_printf_X+0x30>
            for(i=0;i<8;i++)
    5348:	00170713          	addi	a4,a4,1
    534c:	fe1ff06f          	j	532c <bsp_printf_X+0xc>
            bsp_printHex(val);
    5350:	e35ff0ef          	jal	ra,5184 <bsp_printHex>
        }
    5354:	00c12083          	lw	ra,12(sp)
    5358:	01010113          	addi	sp,sp,16
    535c:	00008067          	ret

00005360 <bsp_printf>:
    {
    5360:	fc010113          	addi	sp,sp,-64
    5364:	00112e23          	sw	ra,28(sp)
    5368:	00812c23          	sw	s0,24(sp)
    536c:	00912a23          	sw	s1,20(sp)
    5370:	00050493          	mv	s1,a0
    5374:	02b12223          	sw	a1,36(sp)
    5378:	02c12423          	sw	a2,40(sp)
    537c:	02d12623          	sw	a3,44(sp)
    5380:	02e12823          	sw	a4,48(sp)
    5384:	02f12a23          	sw	a5,52(sp)
    5388:	03012c23          	sw	a6,56(sp)
    538c:	03112e23          	sw	a7,60(sp)
        va_start(ap, format);
    5390:	02410793          	addi	a5,sp,36
    5394:	00f12623          	sw	a5,12(sp)
        for (i = 0; format[i]; i++)
    5398:	00000413          	li	s0,0
    539c:	01c0006f          	j	53b8 <bsp_printf+0x58>
                        bsp_printf_c(va_arg(ap,int));
    53a0:	00c12783          	lw	a5,12(sp)
    53a4:	00478713          	addi	a4,a5,4
    53a8:	00e12623          	sw	a4,12(sp)
    53ac:	0007a503          	lw	a0,0(a5)
    53b0:	e7dff0ef          	jal	ra,522c <bsp_printf_c>
        for (i = 0; format[i]; i++)
    53b4:	00140413          	addi	s0,s0,1
    53b8:	008487b3          	add	a5,s1,s0
    53bc:	0007c503          	lbu	a0,0(a5)
    53c0:	0c050263          	beqz	a0,5484 <bsp_printf+0x124>
            if (format[i] == '%') {
    53c4:	02500793          	li	a5,37
    53c8:	06f50663          	beq	a0,a5,5434 <bsp_printf+0xd4>
                bsp_printf_c(format[i]);
    53cc:	e61ff0ef          	jal	ra,522c <bsp_printf_c>
    53d0:	fe5ff06f          	j	53b4 <bsp_printf+0x54>
                        bsp_printf_s(va_arg(ap,char*));
    53d4:	00c12783          	lw	a5,12(sp)
    53d8:	00478713          	addi	a4,a5,4
    53dc:	00e12623          	sw	a4,12(sp)
    53e0:	0007a503          	lw	a0,0(a5)
    53e4:	e65ff0ef          	jal	ra,5248 <bsp_printf_s>
                        break;
    53e8:	fcdff06f          	j	53b4 <bsp_printf+0x54>
                        bsp_printf_d(va_arg(ap,int));
    53ec:	00c12783          	lw	a5,12(sp)
    53f0:	00478713          	addi	a4,a5,4
    53f4:	00e12623          	sw	a4,12(sp)
    53f8:	0007a503          	lw	a0,0(a5)
    53fc:	e65ff0ef          	jal	ra,5260 <bsp_printf_d>
                        break;
    5400:	fb5ff06f          	j	53b4 <bsp_printf+0x54>
                        bsp_printf_X(va_arg(ap,int));
    5404:	00c12783          	lw	a5,12(sp)
    5408:	00478713          	addi	a4,a5,4
    540c:	00e12623          	sw	a4,12(sp)
    5410:	0007a503          	lw	a0,0(a5)
    5414:	f0dff0ef          	jal	ra,5320 <bsp_printf_X>
                        break;
    5418:	f9dff06f          	j	53b4 <bsp_printf+0x54>
                        bsp_printf_x(va_arg(ap,int));
    541c:	00c12783          	lw	a5,12(sp)
    5420:	00478713          	addi	a4,a5,4
    5424:	00e12623          	sw	a4,12(sp)
    5428:	0007a503          	lw	a0,0(a5)
    542c:	eb5ff0ef          	jal	ra,52e0 <bsp_printf_x>
                        break;
    5430:	f85ff06f          	j	53b4 <bsp_printf+0x54>
                while (format[++i]) {
    5434:	00140413          	addi	s0,s0,1
    5438:	008487b3          	add	a5,s1,s0
    543c:	0007c783          	lbu	a5,0(a5)
    5440:	f6078ae3          	beqz	a5,53b4 <bsp_printf+0x54>
                    if (format[i] == 'c') {
    5444:	06300713          	li	a4,99
    5448:	f4e78ce3          	beq	a5,a4,53a0 <bsp_printf+0x40>
                    else if (format[i] == 's') {
    544c:	07300713          	li	a4,115
    5450:	f8e782e3          	beq	a5,a4,53d4 <bsp_printf+0x74>
                    else if (format[i] == 'd') {
    5454:	06400713          	li	a4,100
    5458:	f8e78ae3          	beq	a5,a4,53ec <bsp_printf+0x8c>
                    else if (format[i] == 'X') {
    545c:	05800713          	li	a4,88
    5460:	fae782e3          	beq	a5,a4,5404 <bsp_printf+0xa4>
                    else if (format[i] == 'x') {
    5464:	07800713          	li	a4,120
    5468:	fae78ae3          	beq	a5,a4,541c <bsp_printf+0xbc>
                    else if (format[i] == 'f') {
    546c:	06600713          	li	a4,102
    5470:	fce792e3          	bne	a5,a4,5434 <bsp_printf+0xd4>
                        bsp_printf_s("<Floating point printing not enable. Please Enable it at bsp.h first...>");
    5474:	00009537          	lui	a0,0x9
    5478:	af850513          	addi	a0,a0,-1288 # 8af8 <_data+0xe4>
    547c:	dcdff0ef          	jal	ra,5248 <bsp_printf_s>
                        break;
    5480:	f35ff06f          	j	53b4 <bsp_printf+0x54>
    }
    5484:	01c12083          	lw	ra,28(sp)
    5488:	01812403          	lw	s0,24(sp)
    548c:	01412483          	lw	s1,20(sp)
    5490:	04010113          	addi	sp,sp,64
    5494:	00008067          	ret

00005498 <sd_send_cmd>:
	70,
	80,
};

void sd_send_cmd(struct mmc *mmc, struct mmc_cmd *cmd, u32 index, u32 resp_type, u32 cmdarg)
{
    5498:	ff010113          	addi	sp,sp,-16
    549c:	00112623          	sw	ra,12(sp)
	struct mmc_ops *ops = mmc->cfg->ops;
    54a0:	00052803          	lw	a6,0(a0)
    54a4:	00482803          	lw	a6,4(a6)
	struct mmc_data *data = NULL;

	cmd->cmdidx = index;
    54a8:	00c59023          	sh	a2,0(a1)
	cmd->resp_type = resp_type;
    54ac:	00d5a223          	sw	a3,4(a1)
	cmd->cmdarg =cmdarg;
    54b0:	00e5a423          	sw	a4,8(a1)

	ops->send_cmd(mmc,cmd,data);
    54b4:	00082783          	lw	a5,0(a6)
    54b8:	00000613          	li	a2,0
    54bc:	000780e7          	jalr	a5
}
    54c0:	00c12083          	lw	ra,12(sp)
    54c4:	01010113          	addi	sp,sp,16
    54c8:	00008067          	ret

000054cc <SD_READ_CSD>:


void SD_READ_CSD(struct mmc *mmc, struct mmc_cmd *cmd)
{
    54cc:	ff010113          	addi	sp,sp,-16
    54d0:	00112623          	sw	ra,12(sp)
    54d4:	00812423          	sw	s0,8(sp)
    54d8:	00912223          	sw	s1,4(sp)
    54dc:	00050413          	mv	s0,a0
    54e0:	00058493          	mv	s1,a1
	sd_send_cmd(mmc,cmd,MMC_CMD_SEND_CSD,MMC_RSP_R2,(mmc->rca<<16));
    54e4:	05c52703          	lw	a4,92(a0)
    54e8:	01071713          	slli	a4,a4,0x10
    54ec:	00700693          	li	a3,7
    54f0:	00900613          	li	a2,9
    54f4:	fa5ff0ef          	jal	ra,5498 <sd_send_cmd>
	mmc->csd[0]= cmd->response[0];
    54f8:	00c4a783          	lw	a5,12(s1)
    54fc:	02f42e23          	sw	a5,60(s0)
	mmc->csd[1]= cmd->response[1];
    5500:	0104a783          	lw	a5,16(s1)
    5504:	04f42023          	sw	a5,64(s0)
	mmc->csd[2]= cmd->response[2];
    5508:	0144a703          	lw	a4,20(s1)
    550c:	04e42223          	sw	a4,68(s0)
	mmc->csd[3]= cmd->response[3];
    5510:	0184a683          	lw	a3,24(s1)
    5514:	04d42423          	sw	a3,72(s0)

	mmc->capacity = (((mmc->csd[1]>>8) &0x3FFFFF)+1)*512;
    5518:	0087d793          	srli	a5,a5,0x8
    551c:	004006b7          	lui	a3,0x400
    5520:	fff68693          	addi	a3,a3,-1 # 3fffff <__freertos_irq_stack_top+0x3ac58f>
    5524:	00d7f7b3          	and	a5,a5,a3
    5528:	00178793          	addi	a5,a5,1
    552c:	00979693          	slli	a3,a5,0x9
	mmc->capacity *=1024;
    5530:	0166d693          	srli	a3,a3,0x16
    5534:	06d42e23          	sw	a3,124(s0)
    5538:	01379793          	slli	a5,a5,0x13
    553c:	06f42c23          	sw	a5,120(s0)
	mmc->tran_speed = multipliers[(mmc->csd[2]>>27) &0x07] * fbase[(mmc->csd[2]>>24) &0x03];
    5540:	01b75793          	srli	a5,a4,0x1b
    5544:	0077f793          	andi	a5,a5,7
    5548:	000096b7          	lui	a3,0x9
    554c:	d5068693          	addi	a3,a3,-688 # 8d50 <multipliers>
    5550:	00279793          	slli	a5,a5,0x2
    5554:	00f687b3          	add	a5,a3,a5
    5558:	0007a783          	lw	a5,0(a5)
    555c:	01875713          	srli	a4,a4,0x18
    5560:	00377713          	andi	a4,a4,3
    5564:	00271713          	slli	a4,a4,0x2
    5568:	00e68733          	add	a4,a3,a4
    556c:	04072703          	lw	a4,64(a4)
    5570:	02e787b3          	mul	a5,a5,a4
    5574:	06f42423          	sw	a5,104(s0)
		bsp_printf("mmc->capacity = %d\r\n",(((mmc->csd[1]>>8) &0x3FFFFF)+1)*512);
		bsp_printf("mmc->tran_speed = %d\r\n",mmc->tran_speed);
	}


}
    5578:	00c12083          	lw	ra,12(sp)
    557c:	00812403          	lw	s0,8(sp)
    5580:	00412483          	lw	s1,4(sp)
    5584:	01010113          	addi	sp,sp,16
    5588:	00008067          	ret

0000558c <SD_CardInitial>:

/************************** Function File ***************************/
u32 SD_CardInitial(struct mmc *mmc, struct mmc_cmd *cmd)
{
    558c:	fe010113          	addi	sp,sp,-32
    5590:	00112e23          	sw	ra,28(sp)
    5594:	00812c23          	sw	s0,24(sp)
    5598:	00912a23          	sw	s1,20(sp)
    559c:	01212823          	sw	s2,16(sp)
    55a0:	01312623          	sw	s3,12(sp)
    55a4:	01412423          	sw	s4,8(sp)
    55a8:	01512223          	sw	s5,4(sp)
    55ac:	00050a13          	mv	s4,a0
    55b0:	00058413          	mv	s0,a1
	u32 Value;
	char busy=0;
	u32 rca=0;
	int wait_busy_count;

    for(int i=0; i<2; i++) {
    55b4:	00000a93          	li	s5,0
	char busy=0;
    55b8:	00000493          	li	s1,0
    for(int i=0; i<2; i++) {
    55bc:	00100793          	li	a5,1
    55c0:	1757ce63          	blt	a5,s5,573c <SD_CardInitial+0x1b0>

    	bsp_printf("Loop: %d\r\n",i);
    55c4:	000a8593          	mv	a1,s5
    55c8:	00009537          	lui	a0,0x9
    55cc:	da050513          	addi	a0,a0,-608 # 8da0 <fbase+0x10>
    55d0:	d91ff0ef          	jal	ra,5360 <bsp_printf>

        Reg_Out32(SDHC_APB_SLV + 0x08,0x00);
    55d4:	00000593          	li	a1,0
    55d8:	f8120937          	lui	s2,0xf8120
    55dc:	00890513          	addi	a0,s2,8 # f8120008 <__freertos_irq_stack_top+0xf80cc598>
    55e0:	9b9ff0ef          	jal	ra,4f98 <Reg_Out32>
        sd_send_cmd(mmc,cmd,MMC_CMD_GO_IDLE_STATE,MMC_RSP_NONE,0);
    55e4:	00000713          	li	a4,0
    55e8:	00000693          	li	a3,0
    55ec:	00000613          	li	a2,0
    55f0:	00040593          	mv	a1,s0
    55f4:	000a0513          	mv	a0,s4
    55f8:	ea1ff0ef          	jal	ra,5498 <sd_send_cmd>
        bsp_uDelay(1000);
    55fc:	f8b00637          	lui	a2,0xf8b00
    5600:	05f5e5b7          	lui	a1,0x5f5e
    5604:	10058593          	addi	a1,a1,256 # 5f5e100 <__freertos_irq_stack_top+0x5f0a690>
    5608:	3e800513          	li	a0,1000
    560c:	af1ff0ef          	jal	ra,50fc <clint_uDelay>

        Reg_Out32(SDHC_APB_SLV + 0x08,0x01);
    5610:	00100593          	li	a1,1
    5614:	00890513          	addi	a0,s2,8
    5618:	981ff0ef          	jal	ra,4f98 <Reg_Out32>
        sd_send_cmd(mmc,cmd,MMC_CMD_SEND_EXT_CSD,MMC_RSP_R7,0x01AA);
    561c:	1aa00713          	li	a4,426
    5620:	01500693          	li	a3,21
    5624:	00800613          	li	a2,8
    5628:	00040593          	mv	a1,s0
    562c:	000a0513          	mv	a0,s4
    5630:	e69ff0ef          	jal	ra,5498 <sd_send_cmd>

        Reg_Out32(SDHC_APB_SLV + 0x08,0x02);
    5634:	00200593          	li	a1,2
    5638:	00890513          	addi	a0,s2,8
    563c:	95dff0ef          	jal	ra,4f98 <Reg_Out32>
        sd_send_cmd(mmc,cmd,MMC_CMD_APP_CMD,MMC_RSP_R1,0);
    5640:	00000713          	li	a4,0
    5644:	01500693          	li	a3,21
    5648:	03700613          	li	a2,55
    564c:	00040593          	mv	a1,s0
    5650:	000a0513          	mv	a0,s4
    5654:	e45ff0ef          	jal	ra,5498 <sd_send_cmd>

		wait_busy_count = 0;
    5658:	00000913          	li	s2,0
        while (busy==0)
    565c:	0a049063          	bnez	s1,56fc <SD_CardInitial+0x170>
                Value = 0;
                Value |= 0x1<<30;//HCS
                Value |= 0x0<<28;//XPC
                Value |= 0x0<<24;//S18R
                Value |= 0x100000;//VDD VOLTAGE
                bsp_uDelay(50000);//delay 50ms
    5660:	f8b00637          	lui	a2,0xf8b00
    5664:	05f5e9b7          	lui	s3,0x5f5e
    5668:	10098593          	addi	a1,s3,256 # 5f5e100 <__freertos_irq_stack_top+0x5f0a690>
    566c:	0000c537          	lui	a0,0xc
    5670:	35050513          	addi	a0,a0,848 # c350 <raw_table4+0x2a14>
    5674:	a89ff0ef          	jal	ra,50fc <clint_uDelay>
                Reg_Out32(SDHC_APB_SLV + 0x08,0x04);
    5678:	00400593          	li	a1,4
    567c:	f81204b7          	lui	s1,0xf8120
    5680:	00848513          	addi	a0,s1,8 # f8120008 <__freertos_irq_stack_top+0xf80cc598>
    5684:	915ff0ef          	jal	ra,4f98 <Reg_Out32>
                sd_send_cmd(mmc,cmd,MMC_CMD_APP_CMD,MMC_RSP_R1,0);
    5688:	00000713          	li	a4,0
    568c:	01500693          	li	a3,21
    5690:	03700613          	li	a2,55
    5694:	00040593          	mv	a1,s0
    5698:	000a0513          	mv	a0,s4
    569c:	dfdff0ef          	jal	ra,5498 <sd_send_cmd>
                Reg_Out32(SDHC_APB_SLV + 0x08,0x05);
    56a0:	00500593          	li	a1,5
    56a4:	00848513          	addi	a0,s1,8
    56a8:	8f1ff0ef          	jal	ra,4f98 <Reg_Out32>
                sd_send_cmd(mmc,cmd,SD_CMD_APP_SEND_OP_COND,MMC_RSP_R3,Value);
    56ac:	40100737          	lui	a4,0x40100
    56b0:	00100693          	li	a3,1
    56b4:	02900613          	li	a2,41
    56b8:	00040593          	mv	a1,s0
    56bc:	000a0513          	mv	a0,s4
    56c0:	dd9ff0ef          	jal	ra,5498 <sd_send_cmd>
                bsp_printf("Respose: 0x%x\r\n",cmd->response[0]);
    56c4:	00c42583          	lw	a1,12(s0)
    56c8:	00009537          	lui	a0,0x9
    56cc:	dac50513          	addi	a0,a0,-596 # 8dac <fbase+0x1c>
    56d0:	c91ff0ef          	jal	ra,5360 <bsp_printf>
                busy = (cmd->response[0]>>31)&0x1;
    56d4:	00c42483          	lw	s1,12(s0)
    56d8:	01f4d493          	srli	s1,s1,0x1f
                bsp_uDelay(1000000);//delay 50ms
    56dc:	f8b00637          	lui	a2,0xf8b00
    56e0:	10098593          	addi	a1,s3,256
    56e4:	000f4537          	lui	a0,0xf4
    56e8:	24050513          	addi	a0,a0,576 # f4240 <__freertos_irq_stack_top+0xa07d0>
    56ec:	a11ff0ef          	jal	ra,50fc <clint_uDelay>
				
			wait_busy_count++;
    56f0:	00190913          	addi	s2,s2,1
			if (wait_busy_count >=10)
    56f4:	00900793          	li	a5,9
    56f8:	f727d2e3          	bge	a5,s2,565c <SD_CardInitial+0xd0>
				break;
			}
        }


        if(busy == 1) {
    56fc:	04049063          	bnez	s1,573c <SD_CardInitial+0x1b0>
            break;
        } else if(i==1) {
    5700:	00100793          	li	a5,1
    5704:	00fa9c63          	bne	s5,a5,571c <SD_CardInitial+0x190>
            bsp_printf("Err : ACMD41 OCR BUSY!\r\n");
    5708:	00009537          	lui	a0,0x9
    570c:	dbc50513          	addi	a0,a0,-580 # 8dbc <fbase+0x2c>
    5710:	c51ff0ef          	jal	ra,5360 <bsp_printf>
            return 1;
    5714:	00100513          	li	a0,1
    5718:	0f40006f          	j	580c <SD_CardInitial+0x280>
        }
        bsp_uDelay(1000000);
    571c:	f8b00637          	lui	a2,0xf8b00
    5720:	05f5e5b7          	lui	a1,0x5f5e
    5724:	10058593          	addi	a1,a1,256 # 5f5e100 <__freertos_irq_stack_top+0x5f0a690>
    5728:	000f4537          	lui	a0,0xf4
    572c:	24050513          	addi	a0,a0,576 # f4240 <__freertos_irq_stack_top+0xa07d0>
    5730:	9cdff0ef          	jal	ra,50fc <clint_uDelay>
    for(int i=0; i<2; i++) {
    5734:	001a8a93          	addi	s5,s5,1
    5738:	e85ff06f          	j	55bc <SD_CardInitial+0x30>
    }

	sd_send_cmd(mmc,cmd,MMC_CMD_ALL_SEND_CID,MMC_RSP_R2,0);
    573c:	00000713          	li	a4,0
    5740:	00700693          	li	a3,7
    5744:	00200613          	li	a2,2
    5748:	00040593          	mv	a1,s0
    574c:	000a0513          	mv	a0,s4
    5750:	d49ff0ef          	jal	ra,5498 <sd_send_cmd>
	mmc->cid[0]=cmd->response[0];
    5754:	00c42783          	lw	a5,12(s0)
    5758:	04fa2623          	sw	a5,76(s4)
	mmc->cid[1]=cmd->response[1];
    575c:	01042783          	lw	a5,16(s0)
    5760:	04fa2823          	sw	a5,80(s4)
	mmc->cid[2]=cmd->response[2];
    5764:	01442783          	lw	a5,20(s0)
    5768:	04fa2a23          	sw	a5,84(s4)
	mmc->cid[3]=cmd->response[3];
    576c:	01842783          	lw	a5,24(s0)
    5770:	04fa2c23          	sw	a5,88(s4)

	sd_send_cmd(mmc,cmd,MMC_CMD_SET_RELATIVE_ADDR,MMC_RSP_R6,0);
    5774:	00000713          	li	a4,0
    5778:	01500693          	li	a3,21
    577c:	00300613          	li	a2,3
    5780:	00040593          	mv	a1,s0
    5784:	000a0513          	mv	a0,s4
    5788:	d11ff0ef          	jal	ra,5498 <sd_send_cmd>

	mmc->rca = (cmd->response[0]&0xffff0000)>>16;
    578c:	00e45783          	lhu	a5,14(s0)
    5790:	04fa2e23          	sw	a5,92(s4)
	SD_READ_CSD(mmc,cmd);
    5794:	00040593          	mv	a1,s0
    5798:	000a0513          	mv	a0,s4
    579c:	d31ff0ef          	jal	ra,54cc <SD_READ_CSD>
	sd_send_cmd(mmc,cmd,MMC_CMD_SELECT_CARD,MMC_RSP_R1b,(mmc->rca<<16));
    57a0:	05ca2703          	lw	a4,92(s4)
    57a4:	01071713          	slli	a4,a4,0x10
    57a8:	01d00693          	li	a3,29
    57ac:	00700613          	li	a2,7
    57b0:	00040593          	mv	a1,s0
    57b4:	000a0513          	mv	a0,s4
    57b8:	ce1ff0ef          	jal	ra,5498 <sd_send_cmd>
	//write_u32(DATA_WIDTH, APB_0+SDHC_ADDR+0x028);//sdhc_reg - Host Control 1

	sd_send_cmd(mmc,cmd,MMC_CMD_APP_CMD,MMC_RSP_R1,(mmc->rca<<16));
    57bc:	05ca2703          	lw	a4,92(s4)
    57c0:	01071713          	slli	a4,a4,0x10
    57c4:	01500693          	li	a3,21
    57c8:	03700613          	li	a2,55
    57cc:	00040593          	mv	a1,s0
    57d0:	000a0513          	mv	a0,s4
    57d4:	cc5ff0ef          	jal	ra,5498 <sd_send_cmd>
	sd_send_cmd(mmc,cmd,SD_CMD_APP_SET_BUS_WIDTH,MMC_RSP_R1,DATA_WIDTH);
    57d8:	00200713          	li	a4,2
    57dc:	01500693          	li	a3,21
    57e0:	00600613          	li	a2,6
    57e4:	00040593          	mv	a1,s0
    57e8:	000a0513          	mv	a0,s4
    57ec:	cadff0ef          	jal	ra,5498 <sd_send_cmd>
	sd_send_cmd(mmc,cmd,MMC_CMD_SET_BLOCKLEN,MMC_RSP_R1,BLOCK_SIZE);
    57f0:	20000713          	li	a4,512
    57f4:	01500693          	li	a3,21
    57f8:	01000613          	li	a2,16
    57fc:	00040593          	mv	a1,s0
    5800:	000a0513          	mv	a0,s4
    5804:	c95ff0ef          	jal	ra,5498 <sd_send_cmd>

	if(DEBUG_PRINTF_EN)
		bsp_printf("SD_CardInitial done\r\n");

	return 0;
    5808:	00000513          	li	a0,0
}
    580c:	01c12083          	lw	ra,28(sp)
    5810:	01812403          	lw	s0,24(sp)
    5814:	01412483          	lw	s1,20(sp)
    5818:	01012903          	lw	s2,16(sp)
    581c:	00c12983          	lw	s3,12(sp)
    5820:	00812a03          	lw	s4,8(sp)
    5824:	00412a83          	lw	s5,4(sp)
    5828:	02010113          	addi	sp,sp,32
    582c:	00008067          	ret

00005830 <SD_EraseBlk>:


void SD_EraseBlk(struct mmc *mmc, struct mmc_cmd *cmd,u32 sd_addr, u32 blk_count)
{
    5830:	fe010113          	addi	sp,sp,-32
    5834:	00112e23          	sw	ra,28(sp)
    5838:	00812c23          	sw	s0,24(sp)
    583c:	00912a23          	sw	s1,20(sp)
    5840:	01212823          	sw	s2,16(sp)
    5844:	01312623          	sw	s3,12(sp)
    5848:	00050493          	mv	s1,a0
    584c:	00058913          	mv	s2,a1
    5850:	00060993          	mv	s3,a2
    5854:	00068413          	mv	s0,a3
	sd_send_cmd(mmc,cmd,SD_CMD_ERASE_WR_BLK_START,MMC_RSP_R1,sd_addr);
    5858:	00060713          	mv	a4,a2
    585c:	01500693          	li	a3,21
    5860:	02000613          	li	a2,32
    5864:	c35ff0ef          	jal	ra,5498 <sd_send_cmd>
	sd_send_cmd(mmc,cmd,SD_CMD_ERASE_WR_BLK_END,MMC_RSP_R1,sd_addr+(blk_count-1)*BLOCK_SIZE);
    5868:	00800737          	lui	a4,0x800
    586c:	fff70713          	addi	a4,a4,-1 # 7fffff <__freertos_irq_stack_top+0x7ac58f>
    5870:	00e40733          	add	a4,s0,a4
    5874:	00971713          	slli	a4,a4,0x9
    5878:	01370733          	add	a4,a4,s3
    587c:	01500693          	li	a3,21
    5880:	02100613          	li	a2,33
    5884:	00090593          	mv	a1,s2
    5888:	00048513          	mv	a0,s1
    588c:	c0dff0ef          	jal	ra,5498 <sd_send_cmd>
	sd_send_cmd(mmc,cmd,MMC_CMD_ERASE,MMC_RSP_R1b,0);
    5890:	00000713          	li	a4,0
    5894:	01d00693          	li	a3,29
    5898:	02600613          	li	a2,38
    589c:	00090593          	mv	a1,s2
    58a0:	00048513          	mv	a0,s1
    58a4:	bf5ff0ef          	jal	ra,5498 <sd_send_cmd>
}
    58a8:	01c12083          	lw	ra,28(sp)
    58ac:	01812403          	lw	s0,24(sp)
    58b0:	01412483          	lw	s1,20(sp)
    58b4:	01012903          	lw	s2,16(sp)
    58b8:	00c12983          	lw	s3,12(sp)
    58bc:	02010113          	addi	sp,sp,32
    58c0:	00008067          	ret

000058c4 <SD_WRITE_BLOCK>:


void SD_WRITE_BLOCK(struct mmc *mmc, u32 addr, void* src, u32 blocks)
{
    58c4:	fe010113          	addi	sp,sp,-32
    58c8:	00112e23          	sw	ra,28(sp)
    58cc:	00812c23          	sw	s0,24(sp)
    58d0:	00912a23          	sw	s1,20(sp)
    58d4:	01212823          	sw	s2,16(sp)
    58d8:	01312623          	sw	s3,12(sp)
    58dc:	01412423          	sw	s4,8(sp)
    58e0:	01512223          	sw	s5,4(sp)
    58e4:	01612023          	sw	s6,0(sp)
    58e8:	00050913          	mv	s2,a0
    58ec:	00058b13          	mv	s6,a1
    58f0:	00060a93          	mv	s5,a2
    58f4:	00068993          	mv	s3,a3
	struct mmc_cmd *cmd;
	struct mmc_data *data;
	struct mmc_ops	*ops = mmc->cfg->ops;
    58f8:	00052783          	lw	a5,0(a0)
    58fc:	0047aa03          	lw	s4,4(a5)

	cmd = malloc(sizeof(struct mmc_cmd));
    5900:	01c00513          	li	a0,28
    5904:	ff4fb0ef          	jal	ra,10f8 <malloc>
    5908:	00050493          	mv	s1,a0
	data = malloc(sizeof(struct mmc_data));
    590c:	01000513          	li	a0,16
    5910:	fe8fb0ef          	jal	ra,10f8 <malloc>
    5914:	00050413          	mv	s0,a0

	memset(cmd,0,sizeof(struct mmc_cmd));
    5918:	01c00613          	li	a2,28
    591c:	00000593          	li	a1,0
    5920:	00048513          	mv	a0,s1
    5924:	884fc0ef          	jal	ra,19a8 <memset>
	memset(data,0,sizeof(struct mmc_data));
    5928:	01000613          	li	a2,16
    592c:	00000593          	li	a1,0
    5930:	00040513          	mv	a0,s0
    5934:	874fc0ef          	jal	ra,19a8 <memset>

	data->blocksize = mmc->read_bl_len;
    5938:	06c92783          	lw	a5,108(s2)
    593c:	00f42623          	sw	a5,12(s0)
	data->blocks = blocks;
    5940:	01342423          	sw	s3,8(s0)

	if(data->blocks == 1)	cmd->cmdidx=MMC_CMD_WRITE_SINGLE_BLOCK;
    5944:	00100793          	li	a5,1
    5948:	06f98863          	beq	s3,a5,59b8 <SD_WRITE_BLOCK+0xf4>
	else					cmd->cmdidx=MMC_CMD_WRITE_MULTIPLE_BLOCK;
    594c:	01900793          	li	a5,25
    5950:	00f49023          	sh	a5,0(s1)

	cmd->cmdarg =addr;
    5954:	0164a423          	sw	s6,8(s1)
	cmd->resp_type=MMC_RSP_R1;
    5958:	01500793          	li	a5,21
    595c:	00f4a223          	sw	a5,4(s1)

	data->src=src;
    5960:	01542023          	sw	s5,0(s0)
	data->flags = MMC_DATA_WRITE;
    5964:	00200793          	li	a5,2
    5968:	00f42223          	sw	a5,4(s0)

	ops->send_cmd(mmc,cmd,data);
    596c:	000a2783          	lw	a5,0(s4)
    5970:	00040613          	mv	a2,s0
    5974:	00048593          	mv	a1,s1
    5978:	00090513          	mv	a0,s2
    597c:	000780e7          	jalr	a5

	free(cmd);
    5980:	00048513          	mv	a0,s1
    5984:	f84fb0ef          	jal	ra,1108 <free>
	free(data);
    5988:	00040513          	mv	a0,s0
    598c:	f7cfb0ef          	jal	ra,1108 <free>

	return;
}
    5990:	01c12083          	lw	ra,28(sp)
    5994:	01812403          	lw	s0,24(sp)
    5998:	01412483          	lw	s1,20(sp)
    599c:	01012903          	lw	s2,16(sp)
    59a0:	00c12983          	lw	s3,12(sp)
    59a4:	00812a03          	lw	s4,8(sp)
    59a8:	00412a83          	lw	s5,4(sp)
    59ac:	00012b03          	lw	s6,0(sp)
    59b0:	02010113          	addi	sp,sp,32
    59b4:	00008067          	ret
	if(data->blocks == 1)	cmd->cmdidx=MMC_CMD_WRITE_SINGLE_BLOCK;
    59b8:	01800793          	li	a5,24
    59bc:	00f49023          	sh	a5,0(s1)
    59c0:	f95ff06f          	j	5954 <SD_WRITE_BLOCK+0x90>

000059c4 <SD_READ_BLOCK>:

void SD_READ_BLOCK(struct mmc *mmc, u32 addr, char* dest, u32 blocks)
{
    59c4:	fe010113          	addi	sp,sp,-32
    59c8:	00112e23          	sw	ra,28(sp)
    59cc:	00812c23          	sw	s0,24(sp)
    59d0:	00912a23          	sw	s1,20(sp)
    59d4:	01212823          	sw	s2,16(sp)
    59d8:	01312623          	sw	s3,12(sp)
    59dc:	01412423          	sw	s4,8(sp)
    59e0:	01512223          	sw	s5,4(sp)
    59e4:	00050913          	mv	s2,a0
    59e8:	00058a93          	mv	s5,a1
    59ec:	00060a13          	mv	s4,a2
    59f0:	00068993          	mv	s3,a3
	struct mmc_cmd *cmd;
	struct mmc_data *data;
	struct mmc_ops	*ops = mmc->cfg->ops;


	cmd = malloc(sizeof(struct mmc_cmd));
    59f4:	01c00513          	li	a0,28
    59f8:	f00fb0ef          	jal	ra,10f8 <malloc>
    59fc:	00050493          	mv	s1,a0
	data = malloc(sizeof(struct mmc_data));
    5a00:	01000513          	li	a0,16
    5a04:	ef4fb0ef          	jal	ra,10f8 <malloc>
    5a08:	00050413          	mv	s0,a0

	memset(cmd,0,sizeof(struct mmc_cmd));
    5a0c:	01c00613          	li	a2,28
    5a10:	00000593          	li	a1,0
    5a14:	00048513          	mv	a0,s1
    5a18:	f91fb0ef          	jal	ra,19a8 <memset>
	memset(data,0,sizeof(struct mmc_data));
    5a1c:	01000613          	li	a2,16
    5a20:	00000593          	li	a1,0
    5a24:	00040513          	mv	a0,s0
    5a28:	f81fb0ef          	jal	ra,19a8 <memset>

	data->blocksize = mmc->read_bl_len;
    5a2c:	06c92783          	lw	a5,108(s2)
    5a30:	00f42623          	sw	a5,12(s0)
	data->blocks = blocks;
    5a34:	01342423          	sw	s3,8(s0)

	if(data->blocks == 1)	cmd->cmdidx=MMC_CMD_READ_SINGLE_BLOCK;
    5a38:	00100793          	li	a5,1
    5a3c:	06f98a63          	beq	s3,a5,5ab0 <SD_READ_BLOCK+0xec>
	else					cmd->cmdidx=MMC_CMD_READ_MULTIPLE_BLOCK;
    5a40:	01200793          	li	a5,18
    5a44:	00f49023          	sh	a5,0(s1)

	cmd->cmdarg =addr;
    5a48:	0154a423          	sw	s5,8(s1)
	cmd->resp_type=MMC_RSP_R1;
    5a4c:	01500793          	li	a5,21
    5a50:	00f4a223          	sw	a5,4(s1)
	data->dest=dest;
    5a54:	01442023          	sw	s4,0(s0)
	data->flags = MMC_DATA_READ;
    5a58:	00100793          	li	a5,1
    5a5c:	00f42223          	sw	a5,4(s0)


	mmc->cfg->ops->send_cmd(mmc,cmd,data);
    5a60:	00092783          	lw	a5,0(s2)
    5a64:	0047a783          	lw	a5,4(a5)
    5a68:	0007a783          	lw	a5,0(a5)
    5a6c:	00040613          	mv	a2,s0
    5a70:	00048593          	mv	a1,s1
    5a74:	00090513          	mv	a0,s2
    5a78:	000780e7          	jalr	a5

	free(cmd);
    5a7c:	00048513          	mv	a0,s1
    5a80:	e88fb0ef          	jal	ra,1108 <free>
	free(data);
    5a84:	00040513          	mv	a0,s0
    5a88:	e80fb0ef          	jal	ra,1108 <free>

	return;
}
    5a8c:	01c12083          	lw	ra,28(sp)
    5a90:	01812403          	lw	s0,24(sp)
    5a94:	01412483          	lw	s1,20(sp)
    5a98:	01012903          	lw	s2,16(sp)
    5a9c:	00c12983          	lw	s3,12(sp)
    5aa0:	00812a03          	lw	s4,8(sp)
    5aa4:	00412a83          	lw	s5,4(sp)
    5aa8:	02010113          	addi	sp,sp,32
    5aac:	00008067          	ret
	if(data->blocks == 1)	cmd->cmdidx=MMC_CMD_READ_SINGLE_BLOCK;
    5ab0:	01100793          	li	a5,17
    5ab4:	00f49023          	sh	a5,0(s1)
    5ab8:	f91ff06f          	j	5a48 <SD_READ_BLOCK+0x84>

00005abc <SD_ReadWriteCompare>:

char SD_ReadWriteCompare(char* wrbuf, char* rdbuf ,u64 wr_start ,u64 wr_end ,u64 rd_start ,u64 rd_end,u32 block_count,u32 current_blk,u32 total_blk)
{
    5abc:	fc010113          	addi	sp,sp,-64
    5ac0:	02112e23          	sw	ra,60(sp)
    5ac4:	02812c23          	sw	s0,56(sp)
    5ac8:	02912a23          	sw	s1,52(sp)
    5acc:	03212823          	sw	s2,48(sp)
    5ad0:	03312623          	sw	s3,44(sp)
    5ad4:	03412423          	sw	s4,40(sp)
    5ad8:	03512223          	sw	s5,36(sp)
    5adc:	03612023          	sw	s6,32(sp)
    5ae0:	01712e23          	sw	s7,28(sp)
    5ae4:	01812c23          	sw	s8,24(sp)
    5ae8:	01912a23          	sw	s9,20(sp)
    5aec:	01a12823          	sw	s10,16(sp)
    5af0:	01b12623          	sw	s11,12(sp)
    5af4:	00050993          	mv	s3,a0
    5af8:	00058a13          	mv	s4,a1
    5afc:	00060d13          	mv	s10,a2
    5b00:	00068c93          	mv	s9,a3
    5b04:	00070913          	mv	s2,a4
    5b08:	00078c13          	mv	s8,a5
    5b0c:	00080b93          	mv	s7,a6
    5b10:	00088b13          	mv	s6,a7
    5b14:	04012483          	lw	s1,64(sp)
    5b18:	04412a83          	lw	s5,68(sp)
    5b1c:	04812d83          	lw	s11,72(sp)
	char err=0;
	u32 m,cmpblk;
	u32 rd_speed,wr_speed;

	if(block_count>MAX_BLK_BUF)	cmpblk=MAX_BLK_BUF;
    5b20:	10000793          	li	a5,256
    5b24:	0db7fa63          	bgeu	a5,s11,5bf8 <SD_ReadWriteCompare+0x13c>
    5b28:	10000413          	li	s0,256
	else						cmpblk=block_count;

	if(memcmp(wrbuf,rdbuf,sizeof(char)*cmpblk*BLOCK_SIZE))
    5b2c:	00941413          	slli	s0,s0,0x9
    5b30:	00040613          	mv	a2,s0
    5b34:	000a0593          	mv	a1,s4
    5b38:	00098513          	mv	a0,s3
    5b3c:	de5fb0ef          	jal	ra,1920 <memcmp>
    5b40:	0c051063          	bnez	a0,5c00 <SD_ReadWriteCompare+0x144>

			}
	}
	else
	{
		wr_speed = ((block_count*BLOCK_SIZE)*1024)/((wr_end-wr_start)/(BSP_MACHINE_TIMER_HZ/1000000));
    5b44:	013d9d93          	slli	s11,s11,0x13
    5b48:	41a90533          	sub	a0,s2,s10
    5b4c:	00a935b3          	sltu	a1,s2,a0
    5b50:	419c0c33          	sub	s8,s8,s9
    5b54:	40bc05b3          	sub	a1,s8,a1
    5b58:	06400613          	li	a2,100
    5b5c:	00000693          	li	a3,0
    5b60:	1b9020ef          	jal	ra,8518 <__udivdi3>
    5b64:	00050613          	mv	a2,a0
    5b68:	00058693          	mv	a3,a1
    5b6c:	000d8513          	mv	a0,s11
    5b70:	00000593          	li	a1,0
    5b74:	1a5020ef          	jal	ra,8518 <__udivdi3>
    5b78:	00050913          	mv	s2,a0
		rd_speed = ((block_count*BLOCK_SIZE)*1024)/((rd_end-rd_start)/(BSP_MACHINE_TIMER_HZ/1000000));
    5b7c:	41748533          	sub	a0,s1,s7
    5b80:	00a4b5b3          	sltu	a1,s1,a0
    5b84:	416a8ab3          	sub	s5,s5,s6
    5b88:	40ba85b3          	sub	a1,s5,a1
    5b8c:	06400613          	li	a2,100
    5b90:	00000693          	li	a3,0
    5b94:	185020ef          	jal	ra,8518 <__udivdi3>
    5b98:	00050613          	mv	a2,a0
    5b9c:	00058693          	mv	a3,a1
    5ba0:	000d8513          	mv	a0,s11
    5ba4:	00000593          	li	a1,0
    5ba8:	171020ef          	jal	ra,8518 <__udivdi3>

		if((current_blk % 1024) ==0)
    5bac:	04c12783          	lw	a5,76(sp)
    5bb0:	3ff7f793          	andi	a5,a5,1023
    5bb4:	0a078263          	beqz	a5,5c58 <SD_ReadWriteCompare+0x19c>
	char err=0;
    5bb8:	00000513          	li	a0,0
			bsp_printf("Tested Block %d/%d          Write s=%d KByte/s   Read s=%d KByte/s           \r",current_blk,total_blk,wr_speed,rd_speed);

	}

	return err;
}
    5bbc:	03c12083          	lw	ra,60(sp)
    5bc0:	03812403          	lw	s0,56(sp)
    5bc4:	03412483          	lw	s1,52(sp)
    5bc8:	03012903          	lw	s2,48(sp)
    5bcc:	02c12983          	lw	s3,44(sp)
    5bd0:	02812a03          	lw	s4,40(sp)
    5bd4:	02412a83          	lw	s5,36(sp)
    5bd8:	02012b03          	lw	s6,32(sp)
    5bdc:	01c12b83          	lw	s7,28(sp)
    5be0:	01812c03          	lw	s8,24(sp)
    5be4:	01412c83          	lw	s9,20(sp)
    5be8:	01012d03          	lw	s10,16(sp)
    5bec:	00c12d83          	lw	s11,12(sp)
    5bf0:	04010113          	addi	sp,sp,64
    5bf4:	00008067          	ret
	else						cmpblk=block_count;
    5bf8:	000d8413          	mv	s0,s11
    5bfc:	f31ff06f          	j	5b2c <SD_ReadWriteCompare+0x70>
		bsp_printf("Tested Block %d/%d\n\r",current_blk,total_blk);
    5c00:	05012603          	lw	a2,80(sp)
    5c04:	04c12583          	lw	a1,76(sp)
    5c08:	00009537          	lui	a0,0x9
    5c0c:	dd850513          	addi	a0,a0,-552 # 8dd8 <fbase+0x48>
    5c10:	f50ff0ef          	jal	ra,5360 <bsp_printf>
			for(m=0;m<(cmpblk*BLOCK_SIZE/4);m++)
    5c14:	00000593          	li	a1,0
    5c18:	00245793          	srli	a5,s0,0x2
    5c1c:	02f5fa63          	bgeu	a1,a5,5c50 <SD_ReadWriteCompare+0x194>
				if(wrbuf[m] != rdbuf[m])
    5c20:	00b987b3          	add	a5,s3,a1
    5c24:	0007c603          	lbu	a2,0(a5)
    5c28:	00ba07b3          	add	a5,s4,a1
    5c2c:	0007c683          	lbu	a3,0(a5)
    5c30:	00d61663          	bne	a2,a3,5c3c <SD_ReadWriteCompare+0x180>
			for(m=0;m<(cmpblk*BLOCK_SIZE/4);m++)
    5c34:	00158593          	addi	a1,a1,1
    5c38:	fe1ff06f          	j	5c18 <SD_ReadWriteCompare+0x15c>
				bsp_printf("compare fail m=%d wr= 0x%x rd=0x%x\n\r",m,wrbuf[m],rdbuf[m]);
    5c3c:	00009537          	lui	a0,0x9
    5c40:	df050513          	addi	a0,a0,-528 # 8df0 <fbase+0x60>
    5c44:	f1cff0ef          	jal	ra,5360 <bsp_printf>
				err=1;
    5c48:	00100513          	li	a0,1
				break;
    5c4c:	f71ff06f          	j	5bbc <SD_ReadWriteCompare+0x100>
	char err=0;
    5c50:	00000513          	li	a0,0
    5c54:	f69ff06f          	j	5bbc <SD_ReadWriteCompare+0x100>
			bsp_printf("Tested Block %d/%d          Write s=%d KByte/s   Read s=%d KByte/s           \r",current_blk,total_blk,wr_speed,rd_speed);
    5c58:	00050713          	mv	a4,a0
    5c5c:	00090693          	mv	a3,s2
    5c60:	05012603          	lw	a2,80(sp)
    5c64:	04c12583          	lw	a1,76(sp)
    5c68:	00009537          	lui	a0,0x9
    5c6c:	e1850513          	addi	a0,a0,-488 # 8e18 <fbase+0x88>
    5c70:	ef0ff0ef          	jal	ra,5360 <bsp_printf>
	char err=0;
    5c74:	00000513          	li	a0,0
    5c78:	f45ff06f          	j	5bbc <SD_ReadWriteCompare+0x100>

00005c7c <SD_InitRandomBuff>:


void SD_InitRandomBuff(char* buf, u32 size)
{
    5c7c:	ff010113          	addi	sp,sp,-16
    5c80:	00112623          	sw	ra,12(sp)
    5c84:	00812423          	sw	s0,8(sp)
    5c88:	00912223          	sw	s1,4(sp)
    5c8c:	01212023          	sw	s2,0(sp)
    5c90:	00050493          	mv	s1,a0
    5c94:	00058913          	mv	s2,a1
	int m;

	for(m=0;m<size;m++)
    5c98:	00000413          	li	s0,0
    5c9c:	01247c63          	bgeu	s0,s2,5cb4 <SD_InitRandomBuff+0x38>
	{
		buf[m] = rand() & 0xFF;
    5ca0:	e01fb0ef          	jal	ra,1aa0 <rand>
    5ca4:	008487b3          	add	a5,s1,s0
    5ca8:	00a78023          	sb	a0,0(a5)
	for(m=0;m<size;m++)
    5cac:	00140413          	addi	s0,s0,1
    5cb0:	fedff06f          	j	5c9c <SD_InitRandomBuff+0x20>
	}

	srand(buf[0]);
    5cb4:	0004c503          	lbu	a0,0(s1)
    5cb8:	dd5fb0ef          	jal	ra,1a8c <srand>
}
    5cbc:	00c12083          	lw	ra,12(sp)
    5cc0:	00812403          	lw	s0,8(sp)
    5cc4:	00412483          	lw	s1,4(sp)
    5cc8:	00012903          	lw	s2,0(sp)
    5ccc:	01010113          	addi	sp,sp,16
    5cd0:	00008067          	ret

00005cd4 <uart_writeAvailability>:
    5cd4:	00452503          	lw	a0,4(a0)
        return (read_u32(reg + UART_STATUS) >> 16) & 0xFF;
    5cd8:	01055513          	srli	a0,a0,0x10
    }
    5cdc:	0ff57513          	andi	a0,a0,255
    5ce0:	00008067          	ret

00005ce4 <uart_write>:
    static void uart_write(u32 reg, char data){
    5ce4:	ff010113          	addi	sp,sp,-16
    5ce8:	00112623          	sw	ra,12(sp)
    5cec:	00812423          	sw	s0,8(sp)
    5cf0:	00912223          	sw	s1,4(sp)
    5cf4:	00050413          	mv	s0,a0
    5cf8:	00058493          	mv	s1,a1
        while(uart_writeAvailability(reg) == 0);
    5cfc:	00040513          	mv	a0,s0
    5d00:	fd5ff0ef          	jal	ra,5cd4 <uart_writeAvailability>
    5d04:	fe050ce3          	beqz	a0,5cfc <uart_write+0x18>
        *((volatile u32*) address) = data;
    5d08:	00942023          	sw	s1,0(s0)
    }
    5d0c:	00c12083          	lw	ra,12(sp)
    5d10:	00812403          	lw	s0,8(sp)
    5d14:	00412483          	lw	s1,4(sp)
    5d18:	01010113          	addi	sp,sp,16
    5d1c:	00008067          	ret

00005d20 <_putchar>:
    static void _putchar(char character){
    5d20:	ff010113          	addi	sp,sp,-16
    5d24:	00112623          	sw	ra,12(sp)
            bsp_putChar(character);
    5d28:	00050593          	mv	a1,a0
    5d2c:	f8010537          	lui	a0,0xf8010
    5d30:	fb5ff0ef          	jal	ra,5ce4 <uart_write>
    }
    5d34:	00c12083          	lw	ra,12(sp)
    5d38:	01010113          	addi	sp,sp,16
    5d3c:	00008067          	ret

00005d40 <_putchar_s>:
    {
    5d40:	ff010113          	addi	sp,sp,-16
    5d44:	00112623          	sw	ra,12(sp)
    5d48:	00812423          	sw	s0,8(sp)
    5d4c:	00050413          	mv	s0,a0
        while (*p)
    5d50:	00044503          	lbu	a0,0(s0)
    5d54:	00050863          	beqz	a0,5d64 <_putchar_s+0x24>
            _putchar(*(p++));
    5d58:	00140413          	addi	s0,s0,1
    5d5c:	fc5ff0ef          	jal	ra,5d20 <_putchar>
    5d60:	ff1ff06f          	j	5d50 <_putchar_s+0x10>
    }
    5d64:	00c12083          	lw	ra,12(sp)
    5d68:	00812403          	lw	s0,8(sp)
    5d6c:	01010113          	addi	sp,sp,16
    5d70:	00008067          	ret

00005d74 <bsp_printHex>:
    {
    5d74:	ff010113          	addi	sp,sp,-16
    5d78:	00112623          	sw	ra,12(sp)
    5d7c:	00812423          	sw	s0,8(sp)
    5d80:	00912223          	sw	s1,4(sp)
    5d84:	00050493          	mv	s1,a0
        for (int i = (4*digits)-4; i >= 0; i -= 4) {
    5d88:	01c00413          	li	s0,28
    5d8c:	0240006f          	j	5db0 <bsp_printHex+0x3c>
            _putchar("0123456789ABCDEF"[(val >> i) % 16]);
    5d90:	0084d7b3          	srl	a5,s1,s0
    5d94:	00f7f713          	andi	a4,a5,15
    5d98:	000097b7          	lui	a5,0x9
    5d9c:	a7c78793          	addi	a5,a5,-1412 # 8a7c <_data+0x68>
    5da0:	00e787b3          	add	a5,a5,a4
    5da4:	0007c503          	lbu	a0,0(a5)
    5da8:	f79ff0ef          	jal	ra,5d20 <_putchar>
        for (int i = (4*digits)-4; i >= 0; i -= 4) {
    5dac:	ffc40413          	addi	s0,s0,-4
    5db0:	fe0450e3          	bgez	s0,5d90 <bsp_printHex+0x1c>
    }
    5db4:	00c12083          	lw	ra,12(sp)
    5db8:	00812403          	lw	s0,8(sp)
    5dbc:	00412483          	lw	s1,4(sp)
    5dc0:	01010113          	addi	sp,sp,16
    5dc4:	00008067          	ret

00005dc8 <bsp_printHex_lower>:
    {
    5dc8:	ff010113          	addi	sp,sp,-16
    5dcc:	00112623          	sw	ra,12(sp)
    5dd0:	00812423          	sw	s0,8(sp)
    5dd4:	00912223          	sw	s1,4(sp)
    5dd8:	00050493          	mv	s1,a0
        for (int i = (4*digits)-4; i >= 0; i -= 4) {
    5ddc:	01c00413          	li	s0,28
    5de0:	0240006f          	j	5e04 <bsp_printHex_lower+0x3c>
            _putchar("0123456789abcdef"[(val >> i) % 16]);
    5de4:	0084d7b3          	srl	a5,s1,s0
    5de8:	00f7f713          	andi	a4,a5,15
    5dec:	000097b7          	lui	a5,0x9
    5df0:	ae478793          	addi	a5,a5,-1308 # 8ae4 <_data+0xd0>
    5df4:	00e787b3          	add	a5,a5,a4
    5df8:	0007c503          	lbu	a0,0(a5)
    5dfc:	f25ff0ef          	jal	ra,5d20 <_putchar>
        for (int i = (4*digits)-4; i >= 0; i -= 4) {
    5e00:	ffc40413          	addi	s0,s0,-4
    5e04:	fe0450e3          	bgez	s0,5de4 <bsp_printHex_lower+0x1c>
    }
    5e08:	00c12083          	lw	ra,12(sp)
    5e0c:	00812403          	lw	s0,8(sp)
    5e10:	00412483          	lw	s1,4(sp)
    5e14:	01010113          	addi	sp,sp,16
    5e18:	00008067          	ret

00005e1c <bsp_printf_c>:
    {
    5e1c:	ff010113          	addi	sp,sp,-16
    5e20:	00112623          	sw	ra,12(sp)
        _putchar(c);
    5e24:	0ff57513          	andi	a0,a0,255
    5e28:	ef9ff0ef          	jal	ra,5d20 <_putchar>
    }
    5e2c:	00c12083          	lw	ra,12(sp)
    5e30:	01010113          	addi	sp,sp,16
    5e34:	00008067          	ret

00005e38 <bsp_printf_s>:
    {
    5e38:	ff010113          	addi	sp,sp,-16
    5e3c:	00112623          	sw	ra,12(sp)
        _putchar_s(p);
    5e40:	f01ff0ef          	jal	ra,5d40 <_putchar_s>
    }
    5e44:	00c12083          	lw	ra,12(sp)
    5e48:	01010113          	addi	sp,sp,16
    5e4c:	00008067          	ret

00005e50 <bsp_printf_d>:
    {
    5e50:	fd010113          	addi	sp,sp,-48
    5e54:	02112623          	sw	ra,44(sp)
    5e58:	02812423          	sw	s0,40(sp)
    5e5c:	02912223          	sw	s1,36(sp)
    5e60:	00050493          	mv	s1,a0
        if (val < 0) {
    5e64:	00054663          	bltz	a0,5e70 <bsp_printf_d+0x20>
    {
    5e68:	00010413          	mv	s0,sp
    5e6c:	02c0006f          	j	5e98 <bsp_printf_d+0x48>
            bsp_printf_c('-');
    5e70:	02d00513          	li	a0,45
    5e74:	fa9ff0ef          	jal	ra,5e1c <bsp_printf_c>
            val = -val;
    5e78:	409004b3          	neg	s1,s1
    5e7c:	fedff06f          	j	5e68 <bsp_printf_d+0x18>
            *(p++) = '0' + val % 10;
    5e80:	00a00713          	li	a4,10
    5e84:	02e4e7b3          	rem	a5,s1,a4
    5e88:	03078793          	addi	a5,a5,48
    5e8c:	00f40023          	sb	a5,0(s0)
            val = val / 10;
    5e90:	02e4c4b3          	div	s1,s1,a4
            *(p++) = '0' + val % 10;
    5e94:	00140413          	addi	s0,s0,1
        while (val || p == buffer) {
    5e98:	fe0494e3          	bnez	s1,5e80 <bsp_printf_d+0x30>
    5e9c:	00010793          	mv	a5,sp
    5ea0:	fef400e3          	beq	s0,a5,5e80 <bsp_printf_d+0x30>
    5ea4:	0100006f          	j	5eb4 <bsp_printf_d+0x64>
            bsp_printf_c(*(--p));
    5ea8:	fff40413          	addi	s0,s0,-1
    5eac:	00044503          	lbu	a0,0(s0)
    5eb0:	f6dff0ef          	jal	ra,5e1c <bsp_printf_c>
        while (p != buffer)
    5eb4:	00010793          	mv	a5,sp
    5eb8:	fef418e3          	bne	s0,a5,5ea8 <bsp_printf_d+0x58>
    }
    5ebc:	02c12083          	lw	ra,44(sp)
    5ec0:	02812403          	lw	s0,40(sp)
    5ec4:	02412483          	lw	s1,36(sp)
    5ec8:	03010113          	addi	sp,sp,48
    5ecc:	00008067          	ret

00005ed0 <bsp_printf_x>:
    {
    5ed0:	ff010113          	addi	sp,sp,-16
    5ed4:	00112623          	sw	ra,12(sp)
        for(i=0;i<8;i++)
    5ed8:	00000713          	li	a4,0
    5edc:	00700793          	li	a5,7
    5ee0:	02e7c063          	blt	a5,a4,5f00 <bsp_printf_x+0x30>
            if((val & (0xFFFFFFF0 <<(4*i))) == 0)
    5ee4:	00271693          	slli	a3,a4,0x2
    5ee8:	ff000793          	li	a5,-16
    5eec:	00d797b3          	sll	a5,a5,a3
    5ef0:	00f577b3          	and	a5,a0,a5
    5ef4:	00078663          	beqz	a5,5f00 <bsp_printf_x+0x30>
        for(i=0;i<8;i++)
    5ef8:	00170713          	addi	a4,a4,1
    5efc:	fe1ff06f          	j	5edc <bsp_printf_x+0xc>
        bsp_printHex_lower(val);
    5f00:	ec9ff0ef          	jal	ra,5dc8 <bsp_printHex_lower>
    }
    5f04:	00c12083          	lw	ra,12(sp)
    5f08:	01010113          	addi	sp,sp,16
    5f0c:	00008067          	ret

00005f10 <bsp_printf_X>:
        {
    5f10:	ff010113          	addi	sp,sp,-16
    5f14:	00112623          	sw	ra,12(sp)
            for(i=0;i<8;i++)
    5f18:	00000713          	li	a4,0
    5f1c:	00700793          	li	a5,7
    5f20:	02e7c063          	blt	a5,a4,5f40 <bsp_printf_X+0x30>
                if((val & (0xFFFFFFF0 <<(4*i))) == 0)
    5f24:	00271693          	slli	a3,a4,0x2
    5f28:	ff000793          	li	a5,-16
    5f2c:	00d797b3          	sll	a5,a5,a3
    5f30:	00f577b3          	and	a5,a0,a5
    5f34:	00078663          	beqz	a5,5f40 <bsp_printf_X+0x30>
            for(i=0;i<8;i++)
    5f38:	00170713          	addi	a4,a4,1
    5f3c:	fe1ff06f          	j	5f1c <bsp_printf_X+0xc>
            bsp_printHex(val);
    5f40:	e35ff0ef          	jal	ra,5d74 <bsp_printHex>
        }
    5f44:	00c12083          	lw	ra,12(sp)
    5f48:	01010113          	addi	sp,sp,16
    5f4c:	00008067          	ret

00005f50 <i2c_masterBusy>:
        return *((volatile u32*) address);
    5f50:	04052503          	lw	a0,64(a0) # f8010040 <__freertos_irq_stack_top+0xf7fbc5d0>
    }
    5f54:	00157513          	andi	a0,a0,1
    5f58:	00008067          	ret

00005f5c <i2c_masterStartBlocking>:
        write_u32(I2C_MASTER_START | I2C_MASTER_START_DROPPED, reg + I2C_MASTER_STATUS);
    5f5c:	04050713          	addi	a4,a0,64
        *((volatile u32*) address) = data;
    5f60:	21000793          	li	a5,528
    5f64:	04f52023          	sw	a5,64(a0)
        return *((volatile u32*) address);
    5f68:	00072783          	lw	a5,0(a4)
        while(i2c_getMasterStatus(reg) & I2C_MASTER_START);
    5f6c:	0107f793          	andi	a5,a5,16
    5f70:	fe079ce3          	bnez	a5,5f68 <i2c_masterStartBlocking+0xc>
    }
    5f74:	00008067          	ret

00005f78 <i2c_masterStopWait>:
    static void i2c_masterStopWait(u32 reg){
    5f78:	ff010113          	addi	sp,sp,-16
    5f7c:	00112623          	sw	ra,12(sp)
    5f80:	00812423          	sw	s0,8(sp)
    5f84:	00050413          	mv	s0,a0
        while(i2c_masterBusy(reg));
    5f88:	00040513          	mv	a0,s0
    5f8c:	fc5ff0ef          	jal	ra,5f50 <i2c_masterBusy>
    5f90:	fe051ce3          	bnez	a0,5f88 <i2c_masterStopWait+0x10>
    }
    5f94:	00c12083          	lw	ra,12(sp)
    5f98:	00812403          	lw	s0,8(sp)
    5f9c:	01010113          	addi	sp,sp,16
    5fa0:	00008067          	ret

00005fa4 <i2c_masterStopBlocking>:
    static void i2c_masterStopBlocking(u32 reg){
    5fa4:	ff010113          	addi	sp,sp,-16
    5fa8:	00112623          	sw	ra,12(sp)
        *((volatile u32*) address) = data;
    5fac:	42000713          	li	a4,1056
    5fb0:	04e52023          	sw	a4,64(a0)
        i2c_masterStopWait(reg);
    5fb4:	fc5ff0ef          	jal	ra,5f78 <i2c_masterStopWait>
    }
    5fb8:	00c12083          	lw	ra,12(sp)
    5fbc:	01010113          	addi	sp,sp,16
    5fc0:	00008067          	ret

00005fc4 <i2c_txAckWait>:
        return *((volatile u32*) address);
    5fc4:	00452783          	lw	a5,4(a0)
        while(read_u32(reg + I2C_TX_ACK) & I2C_TX_VALID);
    5fc8:	1007f793          	andi	a5,a5,256
    5fcc:	fe079ce3          	bnez	a5,5fc4 <i2c_txAckWait>
    }
    5fd0:	00008067          	ret

00005fd4 <i2c_txNackBlocking>:
    static void i2c_txNackBlocking(u32 reg){
    5fd4:	ff010113          	addi	sp,sp,-16
    5fd8:	00112623          	sw	ra,12(sp)
        *((volatile u32*) address) = data;
    5fdc:	30100713          	li	a4,769
    5fe0:	00e52223          	sw	a4,4(a0)
        i2c_txAckWait(reg);
    5fe4:	fe1ff0ef          	jal	ra,5fc4 <i2c_txAckWait>
    }
    5fe8:	00c12083          	lw	ra,12(sp)
    5fec:	01010113          	addi	sp,sp,16
    5ff0:	00008067          	ret

00005ff4 <i2c_rxData>:
        return *((volatile u32*) address);
    5ff4:	00852503          	lw	a0,8(a0)
    }
    5ff8:	0ff57513          	andi	a0,a0,255
    5ffc:	00008067          	ret

00006000 <i2c_rxNack>:
    6000:	00c52503          	lw	a0,12(a0)
        return (read_u32(reg + I2C_RX_ACK) & I2C_RX_VALUE) != 0;
    6004:	0ff57513          	andi	a0,a0,255
    }
    6008:	00a03533          	snez	a0,a0
    600c:	00008067          	ret

00006010 <i2c_rxAck>:
    6010:	00c52503          	lw	a0,12(a0)
        return (read_u32(reg + I2C_RX_ACK) & I2C_RX_VALUE) == 0;
    6014:	0ff57513          	andi	a0,a0,255
    }
    6018:	00153513          	seqz	a0,a0
    601c:	00008067          	ret

00006020 <bsp_printf>:
    {
    6020:	fc010113          	addi	sp,sp,-64
    6024:	00112e23          	sw	ra,28(sp)
    6028:	00812c23          	sw	s0,24(sp)
    602c:	00912a23          	sw	s1,20(sp)
    6030:	00050493          	mv	s1,a0
    6034:	02b12223          	sw	a1,36(sp)
    6038:	02c12423          	sw	a2,40(sp)
    603c:	02d12623          	sw	a3,44(sp)
    6040:	02e12823          	sw	a4,48(sp)
    6044:	02f12a23          	sw	a5,52(sp)
    6048:	03012c23          	sw	a6,56(sp)
    604c:	03112e23          	sw	a7,60(sp)
        va_start(ap, format);
    6050:	02410793          	addi	a5,sp,36
    6054:	00f12623          	sw	a5,12(sp)
        for (i = 0; format[i]; i++)
    6058:	00000413          	li	s0,0
    605c:	01c0006f          	j	6078 <bsp_printf+0x58>
                        bsp_printf_c(va_arg(ap,int));
    6060:	00c12783          	lw	a5,12(sp)
    6064:	00478713          	addi	a4,a5,4
    6068:	00e12623          	sw	a4,12(sp)
    606c:	0007a503          	lw	a0,0(a5)
    6070:	dadff0ef          	jal	ra,5e1c <bsp_printf_c>
        for (i = 0; format[i]; i++)
    6074:	00140413          	addi	s0,s0,1
    6078:	008487b3          	add	a5,s1,s0
    607c:	0007c503          	lbu	a0,0(a5)
    6080:	0c050263          	beqz	a0,6144 <bsp_printf+0x124>
            if (format[i] == '%') {
    6084:	02500793          	li	a5,37
    6088:	06f50663          	beq	a0,a5,60f4 <bsp_printf+0xd4>
                bsp_printf_c(format[i]);
    608c:	d91ff0ef          	jal	ra,5e1c <bsp_printf_c>
    6090:	fe5ff06f          	j	6074 <bsp_printf+0x54>
                        bsp_printf_s(va_arg(ap,char*));
    6094:	00c12783          	lw	a5,12(sp)
    6098:	00478713          	addi	a4,a5,4
    609c:	00e12623          	sw	a4,12(sp)
    60a0:	0007a503          	lw	a0,0(a5)
    60a4:	d95ff0ef          	jal	ra,5e38 <bsp_printf_s>
                        break;
    60a8:	fcdff06f          	j	6074 <bsp_printf+0x54>
                        bsp_printf_d(va_arg(ap,int));
    60ac:	00c12783          	lw	a5,12(sp)
    60b0:	00478713          	addi	a4,a5,4
    60b4:	00e12623          	sw	a4,12(sp)
    60b8:	0007a503          	lw	a0,0(a5)
    60bc:	d95ff0ef          	jal	ra,5e50 <bsp_printf_d>
                        break;
    60c0:	fb5ff06f          	j	6074 <bsp_printf+0x54>
                        bsp_printf_X(va_arg(ap,int));
    60c4:	00c12783          	lw	a5,12(sp)
    60c8:	00478713          	addi	a4,a5,4
    60cc:	00e12623          	sw	a4,12(sp)
    60d0:	0007a503          	lw	a0,0(a5)
    60d4:	e3dff0ef          	jal	ra,5f10 <bsp_printf_X>
                        break;
    60d8:	f9dff06f          	j	6074 <bsp_printf+0x54>
                        bsp_printf_x(va_arg(ap,int));
    60dc:	00c12783          	lw	a5,12(sp)
    60e0:	00478713          	addi	a4,a5,4
    60e4:	00e12623          	sw	a4,12(sp)
    60e8:	0007a503          	lw	a0,0(a5)
    60ec:	de5ff0ef          	jal	ra,5ed0 <bsp_printf_x>
                        break;
    60f0:	f85ff06f          	j	6074 <bsp_printf+0x54>
                while (format[++i]) {
    60f4:	00140413          	addi	s0,s0,1
    60f8:	008487b3          	add	a5,s1,s0
    60fc:	0007c783          	lbu	a5,0(a5)
    6100:	f6078ae3          	beqz	a5,6074 <bsp_printf+0x54>
                    if (format[i] == 'c') {
    6104:	06300713          	li	a4,99
    6108:	f4e78ce3          	beq	a5,a4,6060 <bsp_printf+0x40>
                    else if (format[i] == 's') {
    610c:	07300713          	li	a4,115
    6110:	f8e782e3          	beq	a5,a4,6094 <bsp_printf+0x74>
                    else if (format[i] == 'd') {
    6114:	06400713          	li	a4,100
    6118:	f8e78ae3          	beq	a5,a4,60ac <bsp_printf+0x8c>
                    else if (format[i] == 'X') {
    611c:	05800713          	li	a4,88
    6120:	fae782e3          	beq	a5,a4,60c4 <bsp_printf+0xa4>
                    else if (format[i] == 'x') {
    6124:	07800713          	li	a4,120
    6128:	fae78ae3          	beq	a5,a4,60dc <bsp_printf+0xbc>
                    else if (format[i] == 'f') {
    612c:	06600713          	li	a4,102
    6130:	fce792e3          	bne	a5,a4,60f4 <bsp_printf+0xd4>
                        bsp_printf_s("<Floating point printing not enable. Please Enable it at bsp.h first...>");
    6134:	00009537          	lui	a0,0x9
    6138:	af850513          	addi	a0,a0,-1288 # 8af8 <_data+0xe4>
    613c:	cfdff0ef          	jal	ra,5e38 <bsp_printf_s>
                        break;
    6140:	f35ff06f          	j	6074 <bsp_printf+0x54>
    }
    6144:	01c12083          	lw	ra,28(sp)
    6148:	01812403          	lw	s0,24(sp)
    614c:	01412483          	lw	s1,20(sp)
    6150:	04010113          	addi	sp,sp,64
    6154:	00008067          	ret

00006158 <imx477_WriteRegData>:




int imx477_WriteRegData(u16 reg,u8 data)
{
    6158:	ff010113          	addi	sp,sp,-16
    615c:	00112623          	sw	ra,12(sp)
    6160:	00812423          	sw	s0,8(sp)
    6164:	00912223          	sw	s1,4(sp)
    6168:	00050413          	mv	s0,a0
    616c:	00058493          	mv	s1,a1
	u8 outdata;

    i2c_masterStartBlocking(I2C_CTRL_MIPI);
    6170:	f8017537          	lui	a0,0xf8017
    6174:	de9ff0ef          	jal	ra,5f5c <i2c_masterStartBlocking>
        *((volatile u32*) address) = data;
    6178:	f8017737          	lui	a4,0xf8017
    617c:	000017b7          	lui	a5,0x1
    6180:	b3478793          	addi	a5,a5,-1228 # b34 <CUSTOM2+0xad9>
    6184:	00f72023          	sw	a5,0(a4) # f8017000 <__freertos_irq_stack_top+0xf7fc3590>

    i2c_txByte(I2C_CTRL_MIPI, imx477_I2C_addr<<1);
	i2c_txNackBlocking(I2C_CTRL_MIPI);
    6188:	f8017537          	lui	a0,0xf8017
    618c:	e49ff0ef          	jal	ra,5fd4 <i2c_txNackBlocking>
	if (assert(i2c_rxAck(I2C_CTRL_MIPI)) ) // Optional check
    6190:	f8017537          	lui	a0,0xf8017
    6194:	e7dff0ef          	jal	ra,6010 <i2c_rxAck>
    6198:	e11fe0ef          	jal	ra,4fa8 <assert>
    619c:	02050063          	beqz	a0,61bc <imx477_WriteRegData+0x64>
		return 1;
    61a0:	00100413          	li	s0,1
	if (assert(i2c_rxAck(I2C_CTRL_MIPI)) ) // Optional check
		return 1;
	i2c_masterStopBlocking(I2C_CTRL_MIPI);

	return 0;
}
    61a4:	00040513          	mv	a0,s0
    61a8:	00c12083          	lw	ra,12(sp)
    61ac:	00812403          	lw	s0,8(sp)
    61b0:	00412483          	lw	s1,4(sp)
    61b4:	01010113          	addi	sp,sp,16
    61b8:	00008067          	ret
	i2c_txByte(I2C_CTRL_MIPI, (reg>>8) & 0xFF);
    61bc:	00845793          	srli	a5,s0,0x8
        write_u32(byte | I2C_TX_VALID | I2C_TX_ENABLE | I2C_TX_DISABLE_ON_DATA_CONFLICT, reg + I2C_TX_DATA);
    61c0:	00001737          	lui	a4,0x1
    61c4:	b0070713          	addi	a4,a4,-1280 # b00 <CUSTOM2+0xaa5>
    61c8:	00e7e7b3          	or	a5,a5,a4
    61cc:	f8017737          	lui	a4,0xf8017
    61d0:	00f72023          	sw	a5,0(a4) # f8017000 <__freertos_irq_stack_top+0xf7fc3590>
	i2c_txNackBlocking(I2C_CTRL_MIPI);
    61d4:	f8017537          	lui	a0,0xf8017
    61d8:	dfdff0ef          	jal	ra,5fd4 <i2c_txNackBlocking>
	if (assert(i2c_rxAck(I2C_CTRL_MIPI)) ) // Optional check
    61dc:	f8017537          	lui	a0,0xf8017
    61e0:	e31ff0ef          	jal	ra,6010 <i2c_rxAck>
    61e4:	dc5fe0ef          	jal	ra,4fa8 <assert>
    61e8:	00050663          	beqz	a0,61f4 <imx477_WriteRegData+0x9c>
		return 1;
    61ec:	00100413          	li	s0,1
    61f0:	fb5ff06f          	j	61a4 <imx477_WriteRegData+0x4c>
	i2c_txByte(I2C_CTRL_MIPI, (reg) & 0xFF);
    61f4:	0ff47413          	andi	s0,s0,255
    61f8:	000017b7          	lui	a5,0x1
    61fc:	b0078793          	addi	a5,a5,-1280 # b00 <CUSTOM2+0xaa5>
    6200:	00f46433          	or	s0,s0,a5
    6204:	f80177b7          	lui	a5,0xf8017
    6208:	0087a023          	sw	s0,0(a5) # f8017000 <__freertos_irq_stack_top+0xf7fc3590>
	i2c_txNackBlocking(I2C_CTRL_MIPI);
    620c:	f8017537          	lui	a0,0xf8017
    6210:	dc5ff0ef          	jal	ra,5fd4 <i2c_txNackBlocking>
	if (assert(i2c_rxAck(I2C_CTRL_MIPI)) ) // Optional check
    6214:	f8017537          	lui	a0,0xf8017
    6218:	df9ff0ef          	jal	ra,6010 <i2c_rxAck>
    621c:	d8dfe0ef          	jal	ra,4fa8 <assert>
    6220:	00050663          	beqz	a0,622c <imx477_WriteRegData+0xd4>
		return 1;
    6224:	00100413          	li	s0,1
    6228:	f7dff06f          	j	61a4 <imx477_WriteRegData+0x4c>
    622c:	000017b7          	lui	a5,0x1
    6230:	b0078793          	addi	a5,a5,-1280 # b00 <CUSTOM2+0xaa5>
    6234:	00f4e4b3          	or	s1,s1,a5
    6238:	f80177b7          	lui	a5,0xf8017
    623c:	0097a023          	sw	s1,0(a5) # f8017000 <__freertos_irq_stack_top+0xf7fc3590>
	i2c_txNackBlocking(I2C_CTRL_MIPI);
    6240:	f8017537          	lui	a0,0xf8017
    6244:	d91ff0ef          	jal	ra,5fd4 <i2c_txNackBlocking>
	if (assert(i2c_rxAck(I2C_CTRL_MIPI)) ) // Optional check
    6248:	f8017537          	lui	a0,0xf8017
    624c:	dc5ff0ef          	jal	ra,6010 <i2c_rxAck>
    6250:	d59fe0ef          	jal	ra,4fa8 <assert>
    6254:	00050413          	mv	s0,a0
    6258:	00050663          	beqz	a0,6264 <imx477_WriteRegData+0x10c>
		return 1;
    625c:	00100413          	li	s0,1
    6260:	f45ff06f          	j	61a4 <imx477_WriteRegData+0x4c>
	i2c_masterStopBlocking(I2C_CTRL_MIPI);
    6264:	f8017537          	lui	a0,0xf8017
    6268:	d3dff0ef          	jal	ra,5fa4 <i2c_masterStopBlocking>
	return 0;
    626c:	f39ff06f          	j	61a4 <imx477_WriteRegData+0x4c>

00006270 <imx477_ReadRegData>:

u8 imx477_ReadRegData(u16 reg)
{
    6270:	fe010113          	addi	sp,sp,-32
    6274:	00112e23          	sw	ra,28(sp)
    6278:	00812c23          	sw	s0,24(sp)
    627c:	00912a23          	sw	s1,20(sp)
    6280:	01212823          	sw	s2,16(sp)
    6284:	01312623          	sw	s3,12(sp)
    6288:	00050493          	mv	s1,a0
	u8 outdata;

    i2c_masterStartBlocking(I2C_CTRL_MIPI);
    628c:	f8017537          	lui	a0,0xf8017
    6290:	ccdff0ef          	jal	ra,5f5c <i2c_masterStartBlocking>
    6294:	f8017937          	lui	s2,0xf8017
    6298:	00001437          	lui	s0,0x1
    629c:	b3440793          	addi	a5,s0,-1228 # b34 <CUSTOM2+0xad9>
    62a0:	00f92023          	sw	a5,0(s2) # f8017000 <__freertos_irq_stack_top+0xf7fc3590>

    i2c_txByte(I2C_CTRL_MIPI, imx477_I2C_addr<<1);
	i2c_txNackBlocking(I2C_CTRL_MIPI);
    62a4:	f8017537          	lui	a0,0xf8017
    62a8:	d2dff0ef          	jal	ra,5fd4 <i2c_txNackBlocking>
	assert(i2c_rxAck(I2C_CTRL_MIPI)); // Optional check
    62ac:	f8017537          	lui	a0,0xf8017
    62b0:	d61ff0ef          	jal	ra,6010 <i2c_rxAck>
    62b4:	cf5fe0ef          	jal	ra,4fa8 <assert>

	i2c_txByte(I2C_CTRL_MIPI, (reg>>8) & 0xFF);
    62b8:	0084d793          	srli	a5,s1,0x8
    62bc:	b0040993          	addi	s3,s0,-1280
    62c0:	0137e7b3          	or	a5,a5,s3
    62c4:	00f92023          	sw	a5,0(s2)
	i2c_txNackBlocking(I2C_CTRL_MIPI);
    62c8:	f8017537          	lui	a0,0xf8017
    62cc:	d09ff0ef          	jal	ra,5fd4 <i2c_txNackBlocking>
	assert(i2c_rxAck(I2C_CTRL_MIPI)); // Optional check
    62d0:	f8017537          	lui	a0,0xf8017
    62d4:	d3dff0ef          	jal	ra,6010 <i2c_rxAck>
    62d8:	cd1fe0ef          	jal	ra,4fa8 <assert>

	i2c_txByte(I2C_CTRL_MIPI, (reg) & 0xFF);
    62dc:	0ff4f493          	andi	s1,s1,255
    62e0:	0134e4b3          	or	s1,s1,s3
    62e4:	00992023          	sw	s1,0(s2)
	i2c_txNackBlocking(I2C_CTRL_MIPI);
    62e8:	f8017537          	lui	a0,0xf8017
    62ec:	ce9ff0ef          	jal	ra,5fd4 <i2c_txNackBlocking>
	assert(i2c_rxAck(I2C_CTRL_MIPI)); // Optional check
    62f0:	f8017537          	lui	a0,0xf8017
    62f4:	d1dff0ef          	jal	ra,6010 <i2c_rxAck>
    62f8:	cb1fe0ef          	jal	ra,4fa8 <assert>

	i2c_masterStopBlocking(I2C_CTRL_MIPI);
    62fc:	f8017537          	lui	a0,0xf8017
    6300:	ca5ff0ef          	jal	ra,5fa4 <i2c_masterStopBlocking>
	i2c_masterStartBlocking(I2C_CTRL_MIPI);
    6304:	f8017537          	lui	a0,0xf8017
    6308:	c55ff0ef          	jal	ra,5f5c <i2c_masterStartBlocking>
    630c:	b3540793          	addi	a5,s0,-1227
    6310:	00f92023          	sw	a5,0(s2)

	i2c_txByte(I2C_CTRL_MIPI, (imx477_I2C_addr<<1) | 0x01);
	i2c_txNackBlocking(I2C_CTRL_MIPI);
    6314:	f8017537          	lui	a0,0xf8017
    6318:	cbdff0ef          	jal	ra,5fd4 <i2c_txNackBlocking>
	assert(i2c_rxAck(I2C_CTRL_MIPI)); // Optional check
    631c:	f8017537          	lui	a0,0xf8017
    6320:	cf1ff0ef          	jal	ra,6010 <i2c_rxAck>
    6324:	c85fe0ef          	jal	ra,4fa8 <assert>
    6328:	bff40413          	addi	s0,s0,-1025
    632c:	00892023          	sw	s0,0(s2)

	i2c_txByte(I2C_CTRL_MIPI, 0xFF);
	i2c_txNackBlocking(I2C_CTRL_MIPI);
    6330:	f8017537          	lui	a0,0xf8017
    6334:	ca1ff0ef          	jal	ra,5fd4 <i2c_txNackBlocking>
	assert(i2c_rxNack(I2C_CTRL_MIPI)); // Optional check
    6338:	f8017537          	lui	a0,0xf8017
    633c:	cc5ff0ef          	jal	ra,6000 <i2c_rxNack>
    6340:	c69fe0ef          	jal	ra,4fa8 <assert>
	outdata = i2c_rxData(I2C_CTRL_MIPI);
    6344:	f8017537          	lui	a0,0xf8017
    6348:	cadff0ef          	jal	ra,5ff4 <i2c_rxData>
    634c:	0ff57413          	andi	s0,a0,255

	i2c_masterStopBlocking(I2C_CTRL_MIPI);
    6350:	f8017537          	lui	a0,0xf8017
    6354:	c51ff0ef          	jal	ra,5fa4 <i2c_masterStopBlocking>

	return outdata;
}
    6358:	00040513          	mv	a0,s0
    635c:	01c12083          	lw	ra,28(sp)
    6360:	01812403          	lw	s0,24(sp)
    6364:	01412483          	lw	s1,20(sp)
    6368:	01012903          	lw	s2,16(sp)
    636c:	00c12983          	lw	s3,12(sp)
    6370:	02010113          	addi	sp,sp,32
    6374:	00008067          	ret

00006378 <imx477_WriteRegs>:


int imx477_WriteRegs(const struct imx477_reg *regs,u16 size )
{
    6378:	ff010113          	addi	sp,sp,-16
    637c:	00112623          	sw	ra,12(sp)
    6380:	00812423          	sw	s0,8(sp)
    6384:	00912223          	sw	s1,4(sp)
    6388:	01212023          	sw	s2,0(sp)
    638c:	00050913          	mv	s2,a0
    6390:	00058493          	mv	s1,a1
	bsp_printf("Imx477 Initial Table size :%d  !\n\r",size / (sizeof(struct imx477_reg )) );
    6394:	0025d593          	srli	a1,a1,0x2
    6398:	00009537          	lui	a0,0x9
    639c:	4f850513          	addi	a0,a0,1272 # 94f8 <imx477_mode_1920x1080_60fps+0x1c8>
    63a0:	c81ff0ef          	jal	ra,6020 <bsp_printf>
	for(int x=0; x < size; x++)
    63a4:	00000413          	li	s0,0
    63a8:	02945263          	bge	s0,s1,63cc <imx477_WriteRegs+0x54>
	{


		if(imx477_WriteRegData( regs[x].address, regs[x].val ) )
    63ac:	00241793          	slli	a5,s0,0x2
    63b0:	00f907b3          	add	a5,s2,a5
    63b4:	0027c583          	lbu	a1,2(a5)
    63b8:	0007d503          	lhu	a0,0(a5)
    63bc:	d9dff0ef          	jal	ra,6158 <imx477_WriteRegData>
    63c0:	02051463          	bnez	a0,63e8 <imx477_WriteRegs+0x70>
	for(int x=0; x < size; x++)
    63c4:	00140413          	addi	s0,s0,1
    63c8:	fe1ff06f          	j	63a8 <imx477_WriteRegs+0x30>
			return 1;
		}
	//	bsp_printf("Address :%x Data:  %x !\n\r",regs[x].address, regs[x].val  );

	}
	return 0;
    63cc:	00000513          	li	a0,0
}
    63d0:	00c12083          	lw	ra,12(sp)
    63d4:	00812403          	lw	s0,8(sp)
    63d8:	00412483          	lw	s1,4(sp)
    63dc:	00012903          	lw	s2,0(sp)
    63e0:	01010113          	addi	sp,sp,16
    63e4:	00008067          	ret
			return 1;
    63e8:	00100513          	li	a0,1
    63ec:	fe5ff06f          	j	63d0 <imx477_WriteRegs+0x58>

000063f0 <imx477_init>:



int imx477_init(void)
{
    63f0:	ff010113          	addi	sp,sp,-16
    63f4:	00112623          	sw	ra,12(sp)
   if (imx477_WriteRegData(IMX477_REG_MODE_SELECT, 0x00) )
    63f8:	00000593          	li	a1,0
    63fc:	10000513          	li	a0,256
    6400:	d59ff0ef          	jal	ra,6158 <imx477_WriteRegData>
    6404:	00050a63          	beqz	a0,6418 <imx477_init+0x28>
	   return 1;
    6408:	00100513          	li	a0,1
  /* if (imx477_WriteRegs(dummy_raspiberry, sizeof (dummy_raspiberry )  /sizeof(struct imx477_reg )  ) )
  	   return 2;
*/

   return 0;
}
    640c:	00c12083          	lw	ra,12(sp)
    6410:	01010113          	addi	sp,sp,16
    6414:	00008067          	ret
   if (imx477_WriteRegs(mode_common_regs, sizeof (mode_common_regs )  /sizeof(struct imx477_reg )  ) )
    6418:	13200593          	li	a1,306
    641c:	00009537          	lui	a0,0x9
    6420:	e6850513          	addi	a0,a0,-408 # 8e68 <mode_common_regs>
    6424:	f55ff0ef          	jal	ra,6378 <imx477_WriteRegs>
    6428:	0e051a63          	bnez	a0,651c <imx477_init+0x12c>
  if (imx477_WriteRegs(imx477_mode_1920x1080_60fps, sizeof (imx477_mode_1920x1080_60fps)  /sizeof(struct imx477_reg )) )
    642c:	07200593          	li	a1,114
    6430:	00009537          	lui	a0,0x9
    6434:	e6850513          	addi	a0,a0,-408 # 8e68 <mode_common_regs>
    6438:	4c850513          	addi	a0,a0,1224
    643c:	f3dff0ef          	jal	ra,6378 <imx477_WriteRegs>
    6440:	0e051263          	bnez	a0,6524 <imx477_init+0x134>
   if (imx477_WriteRegData(IMX477_REG_ORIENTATION, 0x02) )
    6444:	00200593          	li	a1,2
    6448:	10100513          	li	a0,257
    644c:	d0dff0ef          	jal	ra,6158 <imx477_WriteRegData>
    6450:	00050663          	beqz	a0,645c <imx477_init+0x6c>
   	   return 1;
    6454:	00100513          	li	a0,1
    6458:	fb5ff06f          	j	640c <imx477_init+0x1c>
   if (imx477_WriteRegData(IMX477_REG_FRAME_LENGTH, 0x09) )
    645c:	00900593          	li	a1,9
    6460:	34000513          	li	a0,832
    6464:	cf5ff0ef          	jal	ra,6158 <imx477_WriteRegData>
    6468:	00050663          	beqz	a0,6474 <imx477_init+0x84>
	   return 1;
    646c:	00100513          	li	a0,1
    6470:	f9dff06f          	j	640c <imx477_init+0x1c>
   if (imx477_WriteRegData(IMX477_REG_FRAME_LENGTH+1, 0x95) )
    6474:	09500593          	li	a1,149
    6478:	34100513          	li	a0,833
    647c:	cddff0ef          	jal	ra,6158 <imx477_WriteRegData>
    6480:	00050663          	beqz	a0,648c <imx477_init+0x9c>
	   return 1;
    6484:	00100513          	li	a0,1
    6488:	f85ff06f          	j	640c <imx477_init+0x1c>
   if (imx477_WriteRegData(IMX477_REG_EXPOSURE, 0x0f) )
    648c:	00f00593          	li	a1,15
    6490:	20200513          	li	a0,514
    6494:	cc5ff0ef          	jal	ra,6158 <imx477_WriteRegData>
    6498:	00050663          	beqz	a0,64a4 <imx477_init+0xb4>
   	   return 1;
    649c:	00100513          	li	a0,1
    64a0:	f6dff06f          	j	640c <imx477_init+0x1c>
   if (imx477_WriteRegData(IMX477_REG_EXPOSURE+1, 0xC6) )
    64a4:	0c600593          	li	a1,198
    64a8:	20300513          	li	a0,515
    64ac:	cadff0ef          	jal	ra,6158 <imx477_WriteRegData>
    64b0:	00050663          	beqz	a0,64bc <imx477_init+0xcc>
   	   return 1;
    64b4:	00100513          	li	a0,1
    64b8:	f55ff06f          	j	640c <imx477_init+0x1c>
   if (imx477_WriteRegData(IMX477_REG_ANALOG_GAIN, 0x03) )
    64bc:	00300593          	li	a1,3
    64c0:	20400513          	li	a0,516
    64c4:	c95ff0ef          	jal	ra,6158 <imx477_WriteRegData>
    64c8:	00050663          	beqz	a0,64d4 <imx477_init+0xe4>
     	   return 1;
    64cc:	00100513          	li	a0,1
    64d0:	f3dff06f          	j	640c <imx477_init+0x1c>
   if (imx477_WriteRegData(IMX477_REG_ANALOG_GAIN+1, 0x00) )
    64d4:	00000593          	li	a1,0
    64d8:	20500513          	li	a0,517
    64dc:	c7dff0ef          	jal	ra,6158 <imx477_WriteRegData>
    64e0:	00050663          	beqz	a0,64ec <imx477_init+0xfc>
     	   return 1;
    64e4:	00100513          	li	a0,1
    64e8:	f25ff06f          	j	640c <imx477_init+0x1c>
   if (imx477_WriteRegData(IMX477_REG_CSI_LANE_MODE, 0x01) )
    64ec:	00100593          	li	a1,1
    64f0:	11400513          	li	a0,276
    64f4:	c65ff0ef          	jal	ra,6158 <imx477_WriteRegData>
    64f8:	00050663          	beqz	a0,6504 <imx477_init+0x114>
   	   return 1;
    64fc:	00100513          	li	a0,1
    6500:	f0dff06f          	j	640c <imx477_init+0x1c>
   if (imx477_WriteRegData(IMX477_REG_MODE_SELECT, 0x01) )
    6504:	00100593          	li	a1,1
    6508:	10000513          	li	a0,256
    650c:	c4dff0ef          	jal	ra,6158 <imx477_WriteRegData>
    6510:	ee050ee3          	beqz	a0,640c <imx477_init+0x1c>
  	   return 1;
    6514:	00100513          	li	a0,1
    6518:	ef5ff06f          	j	640c <imx477_init+0x1c>
	   return 2;
    651c:	00200513          	li	a0,2
    6520:	eedff06f          	j	640c <imx477_init+0x1c>
	   return 3;
    6524:	00300513          	li	a0,3
    6528:	ee5ff06f          	j	640c <imx477_init+0x1c>

0000652c <clint_uDelay>:
        u32 mTimePerUsec = hz/1000000;
    652c:	000f47b7          	lui	a5,0xf4
    6530:	24078793          	addi	a5,a5,576 # f4240 <__freertos_irq_stack_top+0xa07d0>
    6534:	02f5d5b3          	divu	a1,a1,a5
    readReg_u32 (clint_getTimeLow , CLINT_TIME_ADDR)
    6538:	0000c7b7          	lui	a5,0xc
    653c:	ff878793          	addi	a5,a5,-8 # bff8 <raw_table4+0x26bc>
    6540:	00f60633          	add	a2,a2,a5
        return *((volatile u32*) address);
    6544:	00062783          	lw	a5,0(a2) # f8b00000 <__freertos_irq_stack_top+0xf8aac590>
        u32 limit = clint_getTimeLow(reg) + usec*mTimePerUsec;
    6548:	02a58533          	mul	a0,a1,a0
    654c:	00f50533          	add	a0,a0,a5
    6550:	00062783          	lw	a5,0(a2)
        while((int32_t)(limit-(clint_getTimeLow(reg))) >= 0);
    6554:	40f507b3          	sub	a5,a0,a5
    6558:	fe07dce3          	bgez	a5,6550 <clint_uDelay+0x24>
    655c:	00008067          	ret

00006560 <i2c_masterBusy>:
    6560:	04052503          	lw	a0,64(a0)
    }
    6564:	00157513          	andi	a0,a0,1
    6568:	00008067          	ret

0000656c <i2c_masterStartBlocking>:
        write_u32(I2C_MASTER_START | I2C_MASTER_START_DROPPED, reg + I2C_MASTER_STATUS);
    656c:	04050713          	addi	a4,a0,64
        *((volatile u32*) address) = data;
    6570:	21000793          	li	a5,528
    6574:	04f52023          	sw	a5,64(a0)
        return *((volatile u32*) address);
    6578:	00072783          	lw	a5,0(a4)
        while(i2c_getMasterStatus(reg) & I2C_MASTER_START);
    657c:	0107f793          	andi	a5,a5,16
    6580:	fe079ce3          	bnez	a5,6578 <i2c_masterStartBlocking+0xc>
    }
    6584:	00008067          	ret

00006588 <i2c_masterStopWait>:
    static void i2c_masterStopWait(u32 reg){
    6588:	ff010113          	addi	sp,sp,-16
    658c:	00112623          	sw	ra,12(sp)
    6590:	00812423          	sw	s0,8(sp)
    6594:	00050413          	mv	s0,a0
        while(i2c_masterBusy(reg));
    6598:	00040513          	mv	a0,s0
    659c:	fc5ff0ef          	jal	ra,6560 <i2c_masterBusy>
    65a0:	fe051ce3          	bnez	a0,6598 <i2c_masterStopWait+0x10>
    }
    65a4:	00c12083          	lw	ra,12(sp)
    65a8:	00812403          	lw	s0,8(sp)
    65ac:	01010113          	addi	sp,sp,16
    65b0:	00008067          	ret

000065b4 <i2c_masterStopBlocking>:
    static void i2c_masterStopBlocking(u32 reg){
    65b4:	ff010113          	addi	sp,sp,-16
    65b8:	00112623          	sw	ra,12(sp)
        *((volatile u32*) address) = data;
    65bc:	42000713          	li	a4,1056
    65c0:	04e52023          	sw	a4,64(a0)
        i2c_masterStopWait(reg);
    65c4:	fc5ff0ef          	jal	ra,6588 <i2c_masterStopWait>
    }
    65c8:	00c12083          	lw	ra,12(sp)
    65cc:	01010113          	addi	sp,sp,16
    65d0:	00008067          	ret

000065d4 <i2c_txAckWait>:
        return *((volatile u32*) address);
    65d4:	00452783          	lw	a5,4(a0)
        while(read_u32(reg + I2C_TX_ACK) & I2C_TX_VALID);
    65d8:	1007f793          	andi	a5,a5,256
    65dc:	fe079ce3          	bnez	a5,65d4 <i2c_txAckWait>
    }
    65e0:	00008067          	ret

000065e4 <i2c_txNackBlocking>:
    static void i2c_txNackBlocking(u32 reg){
    65e4:	ff010113          	addi	sp,sp,-16
    65e8:	00112623          	sw	ra,12(sp)
        *((volatile u32*) address) = data;
    65ec:	30100713          	li	a4,769
    65f0:	00e52223          	sw	a4,4(a0)
        i2c_txAckWait(reg);
    65f4:	fe1ff0ef          	jal	ra,65d4 <i2c_txAckWait>
    }
    65f8:	00c12083          	lw	ra,12(sp)
    65fc:	01010113          	addi	sp,sp,16
    6600:	00008067          	ret

00006604 <i2c_rxData>:
        return *((volatile u32*) address);
    6604:	00852503          	lw	a0,8(a0)
    }
    6608:	0ff57513          	andi	a0,a0,255
    660c:	00008067          	ret

00006610 <i2c_rxNack>:
    6610:	00c52503          	lw	a0,12(a0)
        return (read_u32(reg + I2C_RX_ACK) & I2C_RX_VALUE) != 0;
    6614:	0ff57513          	andi	a0,a0,255
    }
    6618:	00a03533          	snez	a0,a0
    661c:	00008067          	ret

00006620 <i2c_rxAck>:
    6620:	00c52503          	lw	a0,12(a0)
        return (read_u32(reg + I2C_RX_ACK) & I2C_RX_VALUE) == 0;
    6624:	0ff57513          	andi	a0,a0,255
    }
    6628:	00153513          	seqz	a0,a0
    662c:	00008067          	ret

00006630 <GMSL_Ser_WriteRegData>:




int GMSL_Ser_WriteRegData(u16 reg,u8 data)
{
    6630:	ff010113          	addi	sp,sp,-16
    6634:	00112623          	sw	ra,12(sp)
    6638:	00812423          	sw	s0,8(sp)
    663c:	00912223          	sw	s1,4(sp)
    6640:	00050413          	mv	s0,a0
    6644:	00058493          	mv	s1,a1
	u8 outdata;

    i2c_masterStartBlocking(I2C_CTRL_MIPI);
    6648:	f8017537          	lui	a0,0xf8017
    664c:	f21ff0ef          	jal	ra,656c <i2c_masterStartBlocking>
        *((volatile u32*) address) = data;
    6650:	f8017737          	lui	a4,0xf8017
    6654:	000017b7          	lui	a5,0x1
    6658:	b8078793          	addi	a5,a5,-1152 # b80 <CUSTOM2+0xb25>
    665c:	00f72023          	sw	a5,0(a4) # f8017000 <__freertos_irq_stack_top+0xf7fc3590>

    i2c_txByte(I2C_CTRL_MIPI, GMSL_Ser_I2C_addr<<1);
	i2c_txNackBlocking(I2C_CTRL_MIPI);
    6660:	f8017537          	lui	a0,0xf8017
    6664:	f81ff0ef          	jal	ra,65e4 <i2c_txNackBlocking>
	if (assert(i2c_rxAck(I2C_CTRL_MIPI)) ) // Optional check
    6668:	f8017537          	lui	a0,0xf8017
    666c:	fb5ff0ef          	jal	ra,6620 <i2c_rxAck>
    6670:	939fe0ef          	jal	ra,4fa8 <assert>
    6674:	02050063          	beqz	a0,6694 <GMSL_Ser_WriteRegData+0x64>
		return 1;
    6678:	00100413          	li	s0,1
	if (assert(i2c_rxAck(I2C_CTRL_MIPI)) ) // Optional check
		return 1;
	i2c_masterStopBlocking(I2C_CTRL_MIPI);

	return 0;
}
    667c:	00040513          	mv	a0,s0
    6680:	00c12083          	lw	ra,12(sp)
    6684:	00812403          	lw	s0,8(sp)
    6688:	00412483          	lw	s1,4(sp)
    668c:	01010113          	addi	sp,sp,16
    6690:	00008067          	ret
	i2c_txByte(I2C_CTRL_MIPI, (reg>>8) & 0xFF);
    6694:	00845793          	srli	a5,s0,0x8
        write_u32(byte | I2C_TX_VALID | I2C_TX_ENABLE | I2C_TX_DISABLE_ON_DATA_CONFLICT, reg + I2C_TX_DATA);
    6698:	00001737          	lui	a4,0x1
    669c:	b0070713          	addi	a4,a4,-1280 # b00 <CUSTOM2+0xaa5>
    66a0:	00e7e7b3          	or	a5,a5,a4
    66a4:	f8017737          	lui	a4,0xf8017
    66a8:	00f72023          	sw	a5,0(a4) # f8017000 <__freertos_irq_stack_top+0xf7fc3590>
	i2c_txNackBlocking(I2C_CTRL_MIPI);
    66ac:	f8017537          	lui	a0,0xf8017
    66b0:	f35ff0ef          	jal	ra,65e4 <i2c_txNackBlocking>
	if (assert(i2c_rxAck(I2C_CTRL_MIPI)) ) // Optional check
    66b4:	f8017537          	lui	a0,0xf8017
    66b8:	f69ff0ef          	jal	ra,6620 <i2c_rxAck>
    66bc:	8edfe0ef          	jal	ra,4fa8 <assert>
    66c0:	00050663          	beqz	a0,66cc <GMSL_Ser_WriteRegData+0x9c>
		return 1;
    66c4:	00100413          	li	s0,1
    66c8:	fb5ff06f          	j	667c <GMSL_Ser_WriteRegData+0x4c>
	i2c_txByte(I2C_CTRL_MIPI, (reg) & 0xFF);
    66cc:	0ff47413          	andi	s0,s0,255
    66d0:	000017b7          	lui	a5,0x1
    66d4:	b0078793          	addi	a5,a5,-1280 # b00 <CUSTOM2+0xaa5>
    66d8:	00f46433          	or	s0,s0,a5
    66dc:	f80177b7          	lui	a5,0xf8017
    66e0:	0087a023          	sw	s0,0(a5) # f8017000 <__freertos_irq_stack_top+0xf7fc3590>
	i2c_txNackBlocking(I2C_CTRL_MIPI);
    66e4:	f8017537          	lui	a0,0xf8017
    66e8:	efdff0ef          	jal	ra,65e4 <i2c_txNackBlocking>
	if (assert(i2c_rxAck(I2C_CTRL_MIPI)) ) // Optional check
    66ec:	f8017537          	lui	a0,0xf8017
    66f0:	f31ff0ef          	jal	ra,6620 <i2c_rxAck>
    66f4:	8b5fe0ef          	jal	ra,4fa8 <assert>
    66f8:	00050663          	beqz	a0,6704 <GMSL_Ser_WriteRegData+0xd4>
		return 1;
    66fc:	00100413          	li	s0,1
    6700:	f7dff06f          	j	667c <GMSL_Ser_WriteRegData+0x4c>
    6704:	000017b7          	lui	a5,0x1
    6708:	b0078793          	addi	a5,a5,-1280 # b00 <CUSTOM2+0xaa5>
    670c:	00f4e4b3          	or	s1,s1,a5
    6710:	f80177b7          	lui	a5,0xf8017
    6714:	0097a023          	sw	s1,0(a5) # f8017000 <__freertos_irq_stack_top+0xf7fc3590>
	i2c_txNackBlocking(I2C_CTRL_MIPI);
    6718:	f8017537          	lui	a0,0xf8017
    671c:	ec9ff0ef          	jal	ra,65e4 <i2c_txNackBlocking>
	if (assert(i2c_rxAck(I2C_CTRL_MIPI)) ) // Optional check
    6720:	f8017537          	lui	a0,0xf8017
    6724:	efdff0ef          	jal	ra,6620 <i2c_rxAck>
    6728:	881fe0ef          	jal	ra,4fa8 <assert>
    672c:	00050413          	mv	s0,a0
    6730:	00050663          	beqz	a0,673c <GMSL_Ser_WriteRegData+0x10c>
		return 1;
    6734:	00100413          	li	s0,1
    6738:	f45ff06f          	j	667c <GMSL_Ser_WriteRegData+0x4c>
	i2c_masterStopBlocking(I2C_CTRL_MIPI);
    673c:	f8017537          	lui	a0,0xf8017
    6740:	e75ff0ef          	jal	ra,65b4 <i2c_masterStopBlocking>
	return 0;
    6744:	f39ff06f          	j	667c <GMSL_Ser_WriteRegData+0x4c>

00006748 <GMSL_Des_WriteRegData>:

int GMSL_Des_WriteRegData(u16 reg,u8 data)
{
    6748:	ff010113          	addi	sp,sp,-16
    674c:	00112623          	sw	ra,12(sp)
    6750:	00812423          	sw	s0,8(sp)
    6754:	00912223          	sw	s1,4(sp)
    6758:	00050413          	mv	s0,a0
    675c:	00058493          	mv	s1,a1
	u8 outdata;

    i2c_masterStartBlocking(I2C_CTRL_MIPI);
    6760:	f8017537          	lui	a0,0xf8017
    6764:	e09ff0ef          	jal	ra,656c <i2c_masterStartBlocking>
    6768:	f8017737          	lui	a4,0xf8017
    676c:	000017b7          	lui	a5,0x1
    6770:	b5078793          	addi	a5,a5,-1200 # b50 <CUSTOM2+0xaf5>
    6774:	00f72023          	sw	a5,0(a4) # f8017000 <__freertos_irq_stack_top+0xf7fc3590>

    i2c_txByte(I2C_CTRL_MIPI, GMSl_Des_I2C_addr<<1);
	i2c_txNackBlocking(I2C_CTRL_MIPI);
    6778:	f8017537          	lui	a0,0xf8017
    677c:	e69ff0ef          	jal	ra,65e4 <i2c_txNackBlocking>
	if (assert(i2c_rxAck(I2C_CTRL_MIPI)) ) // Optional check
    6780:	f8017537          	lui	a0,0xf8017
    6784:	e9dff0ef          	jal	ra,6620 <i2c_rxAck>
    6788:	821fe0ef          	jal	ra,4fa8 <assert>
    678c:	02050063          	beqz	a0,67ac <GMSL_Des_WriteRegData+0x64>
		return 1;
    6790:	00100413          	li	s0,1
	if (assert(i2c_rxAck(I2C_CTRL_MIPI)) ) // Optional check
		return 1;
	i2c_masterStopBlocking(I2C_CTRL_MIPI);

	return 0;
}
    6794:	00040513          	mv	a0,s0
    6798:	00c12083          	lw	ra,12(sp)
    679c:	00812403          	lw	s0,8(sp)
    67a0:	00412483          	lw	s1,4(sp)
    67a4:	01010113          	addi	sp,sp,16
    67a8:	00008067          	ret
	i2c_txByte(I2C_CTRL_MIPI, (reg>>8) & 0xFF);
    67ac:	00845793          	srli	a5,s0,0x8
    67b0:	00001737          	lui	a4,0x1
    67b4:	b0070713          	addi	a4,a4,-1280 # b00 <CUSTOM2+0xaa5>
    67b8:	00e7e7b3          	or	a5,a5,a4
    67bc:	f8017737          	lui	a4,0xf8017
    67c0:	00f72023          	sw	a5,0(a4) # f8017000 <__freertos_irq_stack_top+0xf7fc3590>
	i2c_txNackBlocking(I2C_CTRL_MIPI);
    67c4:	f8017537          	lui	a0,0xf8017
    67c8:	e1dff0ef          	jal	ra,65e4 <i2c_txNackBlocking>
	if (assert(i2c_rxAck(I2C_CTRL_MIPI)) ) // Optional check
    67cc:	f8017537          	lui	a0,0xf8017
    67d0:	e51ff0ef          	jal	ra,6620 <i2c_rxAck>
    67d4:	fd4fe0ef          	jal	ra,4fa8 <assert>
    67d8:	00050663          	beqz	a0,67e4 <GMSL_Des_WriteRegData+0x9c>
		return 1;
    67dc:	00100413          	li	s0,1
    67e0:	fb5ff06f          	j	6794 <GMSL_Des_WriteRegData+0x4c>
	i2c_txByte(I2C_CTRL_MIPI, (reg) & 0xFF);
    67e4:	0ff47413          	andi	s0,s0,255
    67e8:	000017b7          	lui	a5,0x1
    67ec:	b0078793          	addi	a5,a5,-1280 # b00 <CUSTOM2+0xaa5>
    67f0:	00f46433          	or	s0,s0,a5
    67f4:	f80177b7          	lui	a5,0xf8017
    67f8:	0087a023          	sw	s0,0(a5) # f8017000 <__freertos_irq_stack_top+0xf7fc3590>
	i2c_txNackBlocking(I2C_CTRL_MIPI);
    67fc:	f8017537          	lui	a0,0xf8017
    6800:	de5ff0ef          	jal	ra,65e4 <i2c_txNackBlocking>
	if (assert(i2c_rxAck(I2C_CTRL_MIPI)) ) // Optional check
    6804:	f8017537          	lui	a0,0xf8017
    6808:	e19ff0ef          	jal	ra,6620 <i2c_rxAck>
    680c:	f9cfe0ef          	jal	ra,4fa8 <assert>
    6810:	00050663          	beqz	a0,681c <GMSL_Des_WriteRegData+0xd4>
		return 1;
    6814:	00100413          	li	s0,1
    6818:	f7dff06f          	j	6794 <GMSL_Des_WriteRegData+0x4c>
    681c:	000017b7          	lui	a5,0x1
    6820:	b0078793          	addi	a5,a5,-1280 # b00 <CUSTOM2+0xaa5>
    6824:	00f4e4b3          	or	s1,s1,a5
    6828:	f80177b7          	lui	a5,0xf8017
    682c:	0097a023          	sw	s1,0(a5) # f8017000 <__freertos_irq_stack_top+0xf7fc3590>
	i2c_txNackBlocking(I2C_CTRL_MIPI);
    6830:	f8017537          	lui	a0,0xf8017
    6834:	db1ff0ef          	jal	ra,65e4 <i2c_txNackBlocking>
	if (assert(i2c_rxAck(I2C_CTRL_MIPI)) ) // Optional check
    6838:	f8017537          	lui	a0,0xf8017
    683c:	de5ff0ef          	jal	ra,6620 <i2c_rxAck>
    6840:	f68fe0ef          	jal	ra,4fa8 <assert>
    6844:	00050413          	mv	s0,a0
    6848:	00050663          	beqz	a0,6854 <GMSL_Des_WriteRegData+0x10c>
		return 1;
    684c:	00100413          	li	s0,1
    6850:	f45ff06f          	j	6794 <GMSL_Des_WriteRegData+0x4c>
	i2c_masterStopBlocking(I2C_CTRL_MIPI);
    6854:	f8017537          	lui	a0,0xf8017
    6858:	d5dff0ef          	jal	ra,65b4 <i2c_masterStopBlocking>
	return 0;
    685c:	f39ff06f          	j	6794 <GMSL_Des_WriteRegData+0x4c>

00006860 <GMSL_Ser_ReadRegData>:


u8  GMSL_Ser_ReadRegData(u16 reg)
{
    6860:	fe010113          	addi	sp,sp,-32
    6864:	00112e23          	sw	ra,28(sp)
    6868:	00812c23          	sw	s0,24(sp)
    686c:	00912a23          	sw	s1,20(sp)
    6870:	01212823          	sw	s2,16(sp)
    6874:	01312623          	sw	s3,12(sp)
    6878:	00050493          	mv	s1,a0
	u8 outdata;

    i2c_masterStartBlocking(I2C_CTRL_MIPI);
    687c:	f8017537          	lui	a0,0xf8017
    6880:	cedff0ef          	jal	ra,656c <i2c_masterStartBlocking>
    6884:	f8017937          	lui	s2,0xf8017
    6888:	00001437          	lui	s0,0x1
    688c:	b8040793          	addi	a5,s0,-1152 # b80 <CUSTOM2+0xb25>
    6890:	00f92023          	sw	a5,0(s2) # f8017000 <__freertos_irq_stack_top+0xf7fc3590>

    i2c_txByte(I2C_CTRL_MIPI, GMSL_Ser_I2C_addr<<1);
	i2c_txNackBlocking(I2C_CTRL_MIPI);
    6894:	f8017537          	lui	a0,0xf8017
    6898:	d4dff0ef          	jal	ra,65e4 <i2c_txNackBlocking>
	assert(i2c_rxAck(I2C_CTRL_MIPI)); // Optional check
    689c:	f8017537          	lui	a0,0xf8017
    68a0:	d81ff0ef          	jal	ra,6620 <i2c_rxAck>
    68a4:	f04fe0ef          	jal	ra,4fa8 <assert>

	i2c_txByte(I2C_CTRL_MIPI, (reg>>8) & 0xFF);
    68a8:	0084d793          	srli	a5,s1,0x8
    68ac:	b0040993          	addi	s3,s0,-1280
    68b0:	0137e7b3          	or	a5,a5,s3
    68b4:	00f92023          	sw	a5,0(s2)
	i2c_txNackBlocking(I2C_CTRL_MIPI);
    68b8:	f8017537          	lui	a0,0xf8017
    68bc:	d29ff0ef          	jal	ra,65e4 <i2c_txNackBlocking>
	assert(i2c_rxAck(I2C_CTRL_MIPI)); // Optional check
    68c0:	f8017537          	lui	a0,0xf8017
    68c4:	d5dff0ef          	jal	ra,6620 <i2c_rxAck>
    68c8:	ee0fe0ef          	jal	ra,4fa8 <assert>

	i2c_txByte(I2C_CTRL_MIPI, (reg) & 0xFF);
    68cc:	0ff4f493          	andi	s1,s1,255
    68d0:	0134e4b3          	or	s1,s1,s3
    68d4:	00992023          	sw	s1,0(s2)
	i2c_txNackBlocking(I2C_CTRL_MIPI);
    68d8:	f8017537          	lui	a0,0xf8017
    68dc:	d09ff0ef          	jal	ra,65e4 <i2c_txNackBlocking>
	assert(i2c_rxAck(I2C_CTRL_MIPI)); // Optional check
    68e0:	f8017537          	lui	a0,0xf8017
    68e4:	d3dff0ef          	jal	ra,6620 <i2c_rxAck>
    68e8:	ec0fe0ef          	jal	ra,4fa8 <assert>

	i2c_masterStopBlocking(I2C_CTRL_MIPI);
    68ec:	f8017537          	lui	a0,0xf8017
    68f0:	cc5ff0ef          	jal	ra,65b4 <i2c_masterStopBlocking>
	i2c_masterStartBlocking(I2C_CTRL_MIPI);
    68f4:	f8017537          	lui	a0,0xf8017
    68f8:	c75ff0ef          	jal	ra,656c <i2c_masterStartBlocking>
    68fc:	b8140793          	addi	a5,s0,-1151
    6900:	00f92023          	sw	a5,0(s2)

	i2c_txByte(I2C_CTRL_MIPI, (GMSL_Ser_I2C_addr<<1) | 0x01);
	i2c_txNackBlocking(I2C_CTRL_MIPI);
    6904:	f8017537          	lui	a0,0xf8017
    6908:	cddff0ef          	jal	ra,65e4 <i2c_txNackBlocking>
	assert(i2c_rxAck(I2C_CTRL_MIPI)); // Optional check
    690c:	f8017537          	lui	a0,0xf8017
    6910:	d11ff0ef          	jal	ra,6620 <i2c_rxAck>
    6914:	e94fe0ef          	jal	ra,4fa8 <assert>
    6918:	bff40413          	addi	s0,s0,-1025
    691c:	00892023          	sw	s0,0(s2)

	i2c_txByte(I2C_CTRL_MIPI, 0xFF);
	i2c_txNackBlocking(I2C_CTRL_MIPI);
    6920:	f8017537          	lui	a0,0xf8017
    6924:	cc1ff0ef          	jal	ra,65e4 <i2c_txNackBlocking>
	assert(i2c_rxNack(I2C_CTRL_MIPI)); // Optional check
    6928:	f8017537          	lui	a0,0xf8017
    692c:	ce5ff0ef          	jal	ra,6610 <i2c_rxNack>
    6930:	e78fe0ef          	jal	ra,4fa8 <assert>
	outdata = i2c_rxData(I2C_CTRL_MIPI);
    6934:	f8017537          	lui	a0,0xf8017
    6938:	ccdff0ef          	jal	ra,6604 <i2c_rxData>
    693c:	0ff57413          	andi	s0,a0,255

	i2c_masterStopBlocking(I2C_CTRL_MIPI);
    6940:	f8017537          	lui	a0,0xf8017
    6944:	c71ff0ef          	jal	ra,65b4 <i2c_masterStopBlocking>

	return outdata;
}
    6948:	00040513          	mv	a0,s0
    694c:	01c12083          	lw	ra,28(sp)
    6950:	01812403          	lw	s0,24(sp)
    6954:	01412483          	lw	s1,20(sp)
    6958:	01012903          	lw	s2,16(sp)
    695c:	00c12983          	lw	s3,12(sp)
    6960:	02010113          	addi	sp,sp,32
    6964:	00008067          	ret

00006968 <GMSL_Des_ReadRegData>:

u8  GMSL_Des_ReadRegData(u16 reg)
{
    6968:	fe010113          	addi	sp,sp,-32
    696c:	00112e23          	sw	ra,28(sp)
    6970:	00812c23          	sw	s0,24(sp)
    6974:	00912a23          	sw	s1,20(sp)
    6978:	01212823          	sw	s2,16(sp)
    697c:	01312623          	sw	s3,12(sp)
    6980:	00050493          	mv	s1,a0
	u8 outdata;

    i2c_masterStartBlocking(I2C_CTRL_MIPI);
    6984:	f8017537          	lui	a0,0xf8017
    6988:	be5ff0ef          	jal	ra,656c <i2c_masterStartBlocking>
    698c:	f8017937          	lui	s2,0xf8017
    6990:	00001437          	lui	s0,0x1
    6994:	b5040793          	addi	a5,s0,-1200 # b50 <CUSTOM2+0xaf5>
    6998:	00f92023          	sw	a5,0(s2) # f8017000 <__freertos_irq_stack_top+0xf7fc3590>

    i2c_txByte(I2C_CTRL_MIPI, GMSl_Des_I2C_addr<<1);
	i2c_txNackBlocking(I2C_CTRL_MIPI);
    699c:	f8017537          	lui	a0,0xf8017
    69a0:	c45ff0ef          	jal	ra,65e4 <i2c_txNackBlocking>
	assert(i2c_rxAck(I2C_CTRL_MIPI)); // Optional check
    69a4:	f8017537          	lui	a0,0xf8017
    69a8:	c79ff0ef          	jal	ra,6620 <i2c_rxAck>
    69ac:	dfcfe0ef          	jal	ra,4fa8 <assert>

	i2c_txByte(I2C_CTRL_MIPI, (reg>>8) & 0xFF);
    69b0:	0084d793          	srli	a5,s1,0x8
    69b4:	b0040993          	addi	s3,s0,-1280
    69b8:	0137e7b3          	or	a5,a5,s3
    69bc:	00f92023          	sw	a5,0(s2)
	i2c_txNackBlocking(I2C_CTRL_MIPI);
    69c0:	f8017537          	lui	a0,0xf8017
    69c4:	c21ff0ef          	jal	ra,65e4 <i2c_txNackBlocking>
	assert(i2c_rxAck(I2C_CTRL_MIPI)); // Optional check
    69c8:	f8017537          	lui	a0,0xf8017
    69cc:	c55ff0ef          	jal	ra,6620 <i2c_rxAck>
    69d0:	dd8fe0ef          	jal	ra,4fa8 <assert>

	i2c_txByte(I2C_CTRL_MIPI, (reg) & 0xFF);
    69d4:	0ff4f493          	andi	s1,s1,255
    69d8:	0134e4b3          	or	s1,s1,s3
    69dc:	00992023          	sw	s1,0(s2)
	i2c_txNackBlocking(I2C_CTRL_MIPI);
    69e0:	f8017537          	lui	a0,0xf8017
    69e4:	c01ff0ef          	jal	ra,65e4 <i2c_txNackBlocking>
	assert(i2c_rxAck(I2C_CTRL_MIPI)); // Optional check
    69e8:	f8017537          	lui	a0,0xf8017
    69ec:	c35ff0ef          	jal	ra,6620 <i2c_rxAck>
    69f0:	db8fe0ef          	jal	ra,4fa8 <assert>

	i2c_masterStopBlocking(I2C_CTRL_MIPI);
    69f4:	f8017537          	lui	a0,0xf8017
    69f8:	bbdff0ef          	jal	ra,65b4 <i2c_masterStopBlocking>
	i2c_masterStartBlocking(I2C_CTRL_MIPI);
    69fc:	f8017537          	lui	a0,0xf8017
    6a00:	b6dff0ef          	jal	ra,656c <i2c_masterStartBlocking>
    6a04:	b5140793          	addi	a5,s0,-1199
    6a08:	00f92023          	sw	a5,0(s2)

	i2c_txByte(I2C_CTRL_MIPI, (GMSl_Des_I2C_addr<<1) | 0x01);
	i2c_txNackBlocking(I2C_CTRL_MIPI);
    6a0c:	f8017537          	lui	a0,0xf8017
    6a10:	bd5ff0ef          	jal	ra,65e4 <i2c_txNackBlocking>
	assert(i2c_rxAck(I2C_CTRL_MIPI)); // Optional check
    6a14:	f8017537          	lui	a0,0xf8017
    6a18:	c09ff0ef          	jal	ra,6620 <i2c_rxAck>
    6a1c:	d8cfe0ef          	jal	ra,4fa8 <assert>
    6a20:	bff40413          	addi	s0,s0,-1025
    6a24:	00892023          	sw	s0,0(s2)

	i2c_txByte(I2C_CTRL_MIPI, 0xFF);
	i2c_txNackBlocking(I2C_CTRL_MIPI);
    6a28:	f8017537          	lui	a0,0xf8017
    6a2c:	bb9ff0ef          	jal	ra,65e4 <i2c_txNackBlocking>
	assert(i2c_rxNack(I2C_CTRL_MIPI)); // Optional check
    6a30:	f8017537          	lui	a0,0xf8017
    6a34:	bddff0ef          	jal	ra,6610 <i2c_rxNack>
    6a38:	d70fe0ef          	jal	ra,4fa8 <assert>
	outdata = i2c_rxData(I2C_CTRL_MIPI);
    6a3c:	f8017537          	lui	a0,0xf8017
    6a40:	bc5ff0ef          	jal	ra,6604 <i2c_rxData>
    6a44:	0ff57413          	andi	s0,a0,255

	i2c_masterStopBlocking(I2C_CTRL_MIPI);
    6a48:	f8017537          	lui	a0,0xf8017
    6a4c:	b69ff0ef          	jal	ra,65b4 <i2c_masterStopBlocking>

	return outdata;
}
    6a50:	00040513          	mv	a0,s0
    6a54:	01c12083          	lw	ra,28(sp)
    6a58:	01812403          	lw	s0,24(sp)
    6a5c:	01412483          	lw	s1,20(sp)
    6a60:	01012903          	lw	s2,16(sp)
    6a64:	00c12983          	lw	s3,12(sp)
    6a68:	02010113          	addi	sp,sp,32
    6a6c:	00008067          	ret

00006a70 <GMSL_SerDes_init>:



int GMSL_SerDes_init(void)
{
    6a70:	ff010113          	addi	sp,sp,-16
    6a74:	00112623          	sw	ra,12(sp)

	// GMSL_Des_WriteRegData(REG_GMSL_DES_MIPI_TX0_TX10, 0x50);      //On Serializer side, Set Mipi CSI-2 Interface to 2Lanes

   if (GMSL_Ser_WriteRegData(REG_GMSL_SER_GPIO_2_A, 0x80) )   //On Serializer side, set Sensor Enable Pin to Low
    6a78:	08000593          	li	a1,128
    6a7c:	2c400513          	li	a0,708
    6a80:	bb1ff0ef          	jal	ra,6630 <GMSL_Ser_WriteRegData>
    6a84:	00050a63          	beqz	a0,6a98 <GMSL_SerDes_init+0x28>
	   return 1;
    6a88:	00100513          	li	a0,1
   if (GMSL_Ser_WriteRegData(REG_GMSL_SER_GPIO_2_A, 0x90) )   //On Serializer side, Set Sensor Enable Pin to High
   	   return 1;


   return 0;
}
    6a8c:	00c12083          	lw	ra,12(sp)
    6a90:	01010113          	addi	sp,sp,16
    6a94:	00008067          	ret
   bsp_uDelay(50000);
    6a98:	f8b00637          	lui	a2,0xf8b00
    6a9c:	05f5e5b7          	lui	a1,0x5f5e
    6aa0:	10058593          	addi	a1,a1,256 # 5f5e100 <__freertos_irq_stack_top+0x5f0a690>
    6aa4:	0000c537          	lui	a0,0xc
    6aa8:	35050513          	addi	a0,a0,848 # c350 <raw_table4+0x2a14>
    6aac:	a81ff0ef          	jal	ra,652c <clint_uDelay>
   GMSL_Ser_WriteRegData(REG_GMSL_SER_MIPI_RX_1, 0x30);      //On Serializer side, Set Mipi CSI-2 Interface to 2Lanes
    6ab0:	03000593          	li	a1,48
    6ab4:	33100513          	li	a0,817
    6ab8:	b79ff0ef          	jal	ra,6630 <GMSL_Ser_WriteRegData>
   GMSL_Des_WriteRegData(REG_GMSL_DES_MIPI_TX0_TX10, 0xD0);      //On Serializer side, Set Mipi CSI-2 Interface to 2Lanes
    6abc:	0d000593          	li	a1,208
    6ac0:	40a00513          	li	a0,1034
    6ac4:	c85ff0ef          	jal	ra,6748 <GMSL_Des_WriteRegData>
   GMSL_Des_WriteRegData(REG_GMSL_DES_MIPI_TX1_TX10, 0xD0);      //On Serializer side, Set Mipi CSI-2 Interface to 2Lanes
    6ac8:	0d000593          	li	a1,208
    6acc:	44a00513          	li	a0,1098
    6ad0:	c79ff0ef          	jal	ra,6748 <GMSL_Des_WriteRegData>
   GMSL_Des_WriteRegData(REG_GMSL_DES_MIPI_TX2_TX10, 0xD0);      //On Serializer side, Set Mipi CSI-2 Interface to 2Lanes
    6ad4:	0d000593          	li	a1,208
    6ad8:	44a00513          	li	a0,1098
    6adc:	c6dff0ef          	jal	ra,6748 <GMSL_Des_WriteRegData>
   GMSL_Des_WriteRegData(REG_GMSL_DES_BACKTOP25, 0x39); 		//Phy1 2500Mbps
    6ae0:	03900593          	li	a1,57
    6ae4:	32000513          	li	a0,800
    6ae8:	c61ff0ef          	jal	ra,6748 <GMSL_Des_WriteRegData>
   GMSL_Des_WriteRegData(REG_GMSL_DES_BACKTOP28, 0x39);         //Phy2 2500Mbps
    6aec:	03900593          	li	a1,57
    6af0:	32300513          	li	a0,803
    6af4:	c55ff0ef          	jal	ra,6748 <GMSL_Des_WriteRegData>
   if (GMSL_Ser_WriteRegData(REG_GMSL_SER_GPIO_2_A, 0x90) )   //On Serializer side, Set Sensor Enable Pin to High
    6af8:	09000593          	li	a1,144
    6afc:	2c400513          	li	a0,708
    6b00:	b31ff0ef          	jal	ra,6630 <GMSL_Ser_WriteRegData>
    6b04:	f80504e3          	beqz	a0,6a8c <GMSL_SerDes_init+0x1c>
   	   return 1;
    6b08:	00100513          	li	a0,1
    6b0c:	f81ff06f          	j	6a8c <GMSL_SerDes_init+0x1c>

00006b10 <uart_writeAvailability>:
        return *((volatile u32*) address);
    6b10:	00452503          	lw	a0,4(a0)
        return (read_u32(reg + UART_STATUS) >> 16) & 0xFF;
    6b14:	01055513          	srli	a0,a0,0x10
    }
    6b18:	0ff57513          	andi	a0,a0,255
    6b1c:	00008067          	ret

00006b20 <uart_write>:
    static void uart_write(u32 reg, char data){
    6b20:	ff010113          	addi	sp,sp,-16
    6b24:	00112623          	sw	ra,12(sp)
    6b28:	00812423          	sw	s0,8(sp)
    6b2c:	00912223          	sw	s1,4(sp)
    6b30:	00050413          	mv	s0,a0
    6b34:	00058493          	mv	s1,a1
        while(uart_writeAvailability(reg) == 0);
    6b38:	00040513          	mv	a0,s0
    6b3c:	fd5ff0ef          	jal	ra,6b10 <uart_writeAvailability>
    6b40:	fe050ce3          	beqz	a0,6b38 <uart_write+0x18>
        *((volatile u32*) address) = data;
    6b44:	00942023          	sw	s1,0(s0)
    }
    6b48:	00c12083          	lw	ra,12(sp)
    6b4c:	00812403          	lw	s0,8(sp)
    6b50:	00412483          	lw	s1,4(sp)
    6b54:	01010113          	addi	sp,sp,16
    6b58:	00008067          	ret

00006b5c <_putchar>:
    static void _putchar(char character){
    6b5c:	ff010113          	addi	sp,sp,-16
    6b60:	00112623          	sw	ra,12(sp)
            bsp_putChar(character);
    6b64:	00050593          	mv	a1,a0
    6b68:	f8010537          	lui	a0,0xf8010
    6b6c:	fb5ff0ef          	jal	ra,6b20 <uart_write>
    }
    6b70:	00c12083          	lw	ra,12(sp)
    6b74:	01010113          	addi	sp,sp,16
    6b78:	00008067          	ret

00006b7c <_putchar_s>:
    {
    6b7c:	ff010113          	addi	sp,sp,-16
    6b80:	00112623          	sw	ra,12(sp)
    6b84:	00812423          	sw	s0,8(sp)
    6b88:	00050413          	mv	s0,a0
        while (*p)
    6b8c:	00044503          	lbu	a0,0(s0)
    6b90:	00050863          	beqz	a0,6ba0 <_putchar_s+0x24>
            _putchar(*(p++));
    6b94:	00140413          	addi	s0,s0,1
    6b98:	fc5ff0ef          	jal	ra,6b5c <_putchar>
    6b9c:	ff1ff06f          	j	6b8c <_putchar_s+0x10>
    }
    6ba0:	00c12083          	lw	ra,12(sp)
    6ba4:	00812403          	lw	s0,8(sp)
    6ba8:	01010113          	addi	sp,sp,16
    6bac:	00008067          	ret

00006bb0 <bsp_printHex>:
    {
    6bb0:	ff010113          	addi	sp,sp,-16
    6bb4:	00112623          	sw	ra,12(sp)
    6bb8:	00812423          	sw	s0,8(sp)
    6bbc:	00912223          	sw	s1,4(sp)
    6bc0:	00050493          	mv	s1,a0
        for (int i = (4*digits)-4; i >= 0; i -= 4) {
    6bc4:	01c00413          	li	s0,28
    6bc8:	0240006f          	j	6bec <bsp_printHex+0x3c>
            _putchar("0123456789ABCDEF"[(val >> i) % 16]);
    6bcc:	0084d7b3          	srl	a5,s1,s0
    6bd0:	00f7f713          	andi	a4,a5,15
    6bd4:	000097b7          	lui	a5,0x9
    6bd8:	a7c78793          	addi	a5,a5,-1412 # 8a7c <_data+0x68>
    6bdc:	00e787b3          	add	a5,a5,a4
    6be0:	0007c503          	lbu	a0,0(a5)
    6be4:	f79ff0ef          	jal	ra,6b5c <_putchar>
        for (int i = (4*digits)-4; i >= 0; i -= 4) {
    6be8:	ffc40413          	addi	s0,s0,-4
    6bec:	fe0450e3          	bgez	s0,6bcc <bsp_printHex+0x1c>
    }
    6bf0:	00c12083          	lw	ra,12(sp)
    6bf4:	00812403          	lw	s0,8(sp)
    6bf8:	00412483          	lw	s1,4(sp)
    6bfc:	01010113          	addi	sp,sp,16
    6c00:	00008067          	ret

00006c04 <bsp_printHex_lower>:
    {
    6c04:	ff010113          	addi	sp,sp,-16
    6c08:	00112623          	sw	ra,12(sp)
    6c0c:	00812423          	sw	s0,8(sp)
    6c10:	00912223          	sw	s1,4(sp)
    6c14:	00050493          	mv	s1,a0
        for (int i = (4*digits)-4; i >= 0; i -= 4) {
    6c18:	01c00413          	li	s0,28
    6c1c:	0240006f          	j	6c40 <bsp_printHex_lower+0x3c>
            _putchar("0123456789abcdef"[(val >> i) % 16]);
    6c20:	0084d7b3          	srl	a5,s1,s0
    6c24:	00f7f713          	andi	a4,a5,15
    6c28:	000097b7          	lui	a5,0x9
    6c2c:	ae478793          	addi	a5,a5,-1308 # 8ae4 <_data+0xd0>
    6c30:	00e787b3          	add	a5,a5,a4
    6c34:	0007c503          	lbu	a0,0(a5)
    6c38:	f25ff0ef          	jal	ra,6b5c <_putchar>
        for (int i = (4*digits)-4; i >= 0; i -= 4) {
    6c3c:	ffc40413          	addi	s0,s0,-4
    6c40:	fe0450e3          	bgez	s0,6c20 <bsp_printHex_lower+0x1c>
    }
    6c44:	00c12083          	lw	ra,12(sp)
    6c48:	00812403          	lw	s0,8(sp)
    6c4c:	00412483          	lw	s1,4(sp)
    6c50:	01010113          	addi	sp,sp,16
    6c54:	00008067          	ret

00006c58 <bsp_printf_c>:
    {
    6c58:	ff010113          	addi	sp,sp,-16
    6c5c:	00112623          	sw	ra,12(sp)
        _putchar(c);
    6c60:	0ff57513          	andi	a0,a0,255
    6c64:	ef9ff0ef          	jal	ra,6b5c <_putchar>
    }
    6c68:	00c12083          	lw	ra,12(sp)
    6c6c:	01010113          	addi	sp,sp,16
    6c70:	00008067          	ret

00006c74 <bsp_printf_s>:
    {
    6c74:	ff010113          	addi	sp,sp,-16
    6c78:	00112623          	sw	ra,12(sp)
        _putchar_s(p);
    6c7c:	f01ff0ef          	jal	ra,6b7c <_putchar_s>
    }
    6c80:	00c12083          	lw	ra,12(sp)
    6c84:	01010113          	addi	sp,sp,16
    6c88:	00008067          	ret

00006c8c <bsp_printf_d>:
    {
    6c8c:	fd010113          	addi	sp,sp,-48
    6c90:	02112623          	sw	ra,44(sp)
    6c94:	02812423          	sw	s0,40(sp)
    6c98:	02912223          	sw	s1,36(sp)
    6c9c:	00050493          	mv	s1,a0
        if (val < 0) {
    6ca0:	00054663          	bltz	a0,6cac <bsp_printf_d+0x20>
    {
    6ca4:	00010413          	mv	s0,sp
    6ca8:	02c0006f          	j	6cd4 <bsp_printf_d+0x48>
            bsp_printf_c('-');
    6cac:	02d00513          	li	a0,45
    6cb0:	fa9ff0ef          	jal	ra,6c58 <bsp_printf_c>
            val = -val;
    6cb4:	409004b3          	neg	s1,s1
    6cb8:	fedff06f          	j	6ca4 <bsp_printf_d+0x18>
            *(p++) = '0' + val % 10;
    6cbc:	00a00713          	li	a4,10
    6cc0:	02e4e7b3          	rem	a5,s1,a4
    6cc4:	03078793          	addi	a5,a5,48
    6cc8:	00f40023          	sb	a5,0(s0)
            val = val / 10;
    6ccc:	02e4c4b3          	div	s1,s1,a4
            *(p++) = '0' + val % 10;
    6cd0:	00140413          	addi	s0,s0,1
        while (val || p == buffer) {
    6cd4:	fe0494e3          	bnez	s1,6cbc <bsp_printf_d+0x30>
    6cd8:	00010793          	mv	a5,sp
    6cdc:	fef400e3          	beq	s0,a5,6cbc <bsp_printf_d+0x30>
    6ce0:	0100006f          	j	6cf0 <bsp_printf_d+0x64>
            bsp_printf_c(*(--p));
    6ce4:	fff40413          	addi	s0,s0,-1
    6ce8:	00044503          	lbu	a0,0(s0)
    6cec:	f6dff0ef          	jal	ra,6c58 <bsp_printf_c>
        while (p != buffer)
    6cf0:	00010793          	mv	a5,sp
    6cf4:	fef418e3          	bne	s0,a5,6ce4 <bsp_printf_d+0x58>
    }
    6cf8:	02c12083          	lw	ra,44(sp)
    6cfc:	02812403          	lw	s0,40(sp)
    6d00:	02412483          	lw	s1,36(sp)
    6d04:	03010113          	addi	sp,sp,48
    6d08:	00008067          	ret

00006d0c <bsp_printf_x>:
    {
    6d0c:	ff010113          	addi	sp,sp,-16
    6d10:	00112623          	sw	ra,12(sp)
        for(i=0;i<8;i++)
    6d14:	00000713          	li	a4,0
    6d18:	00700793          	li	a5,7
    6d1c:	02e7c063          	blt	a5,a4,6d3c <bsp_printf_x+0x30>
            if((val & (0xFFFFFFF0 <<(4*i))) == 0)
    6d20:	00271693          	slli	a3,a4,0x2
    6d24:	ff000793          	li	a5,-16
    6d28:	00d797b3          	sll	a5,a5,a3
    6d2c:	00f577b3          	and	a5,a0,a5
    6d30:	00078663          	beqz	a5,6d3c <bsp_printf_x+0x30>
        for(i=0;i<8;i++)
    6d34:	00170713          	addi	a4,a4,1
    6d38:	fe1ff06f          	j	6d18 <bsp_printf_x+0xc>
        bsp_printHex_lower(val);
    6d3c:	ec9ff0ef          	jal	ra,6c04 <bsp_printHex_lower>
    }
    6d40:	00c12083          	lw	ra,12(sp)
    6d44:	01010113          	addi	sp,sp,16
    6d48:	00008067          	ret

00006d4c <bsp_printf_X>:
        {
    6d4c:	ff010113          	addi	sp,sp,-16
    6d50:	00112623          	sw	ra,12(sp)
            for(i=0;i<8;i++)
    6d54:	00000713          	li	a4,0
    6d58:	00700793          	li	a5,7
    6d5c:	02e7c063          	blt	a5,a4,6d7c <bsp_printf_X+0x30>
                if((val & (0xFFFFFFF0 <<(4*i))) == 0)
    6d60:	00271693          	slli	a3,a4,0x2
    6d64:	ff000793          	li	a5,-16
    6d68:	00d797b3          	sll	a5,a5,a3
    6d6c:	00f577b3          	and	a5,a0,a5
    6d70:	00078663          	beqz	a5,6d7c <bsp_printf_X+0x30>
            for(i=0;i<8;i++)
    6d74:	00170713          	addi	a4,a4,1
    6d78:	fe1ff06f          	j	6d58 <bsp_printf_X+0xc>
            bsp_printHex(val);
    6d7c:	e35ff0ef          	jal	ra,6bb0 <bsp_printHex>
        }
    6d80:	00c12083          	lw	ra,12(sp)
    6d84:	01010113          	addi	sp,sp,16
    6d88:	00008067          	ret

00006d8c <dmasg_input_memory>:
        u32 ca = dmasg_ca(base, channel);
    6d8c:	00759593          	slli	a1,a1,0x7
    6d90:	00a58533          	add	a0,a1,a0
    6d94:	00c52023          	sw	a2,0(a0) # f8010000 <__freertos_irq_stack_top+0xf7fbc590>
        write_u32(DMASG_CHANNEL_INPUT_CONFIG_MEMORY | (byte_per_burst-1 & 0xFFF), ca + DMASG_CHANNEL_INPUT_CONFIG);
    6d98:	fff68693          	addi	a3,a3,-1
    6d9c:	000017b7          	lui	a5,0x1
    6da0:	fff78713          	addi	a4,a5,-1 # fff <CUSTOM2+0xfa4>
    6da4:	00e6f6b3          	and	a3,a3,a4
    6da8:	00f6e6b3          	or	a3,a3,a5
    6dac:	00d52623          	sw	a3,12(a0)
    }
    6db0:	00008067          	ret

00006db4 <dmasg_output_memory>:
        u32 ca = dmasg_ca(base, channel);
    6db4:	00759593          	slli	a1,a1,0x7
    6db8:	00a58533          	add	a0,a1,a0
    6dbc:	00c52823          	sw	a2,16(a0)
        write_u32(DMASG_CHANNEL_OUTPUT_CONFIG_MEMORY | (byte_per_burst-1 & 0xFFF), ca + DMASG_CHANNEL_OUTPUT_CONFIG);
    6dc0:	fff68693          	addi	a3,a3,-1
    6dc4:	000017b7          	lui	a5,0x1
    6dc8:	fff78713          	addi	a4,a5,-1 # fff <CUSTOM2+0xfa4>
    6dcc:	00e6f6b3          	and	a3,a3,a4
    6dd0:	00f6e6b3          	or	a3,a3,a5
    6dd4:	00d52e23          	sw	a3,28(a0)
    }
    6dd8:	00008067          	ret

00006ddc <dmasg_input_stream>:
        u32 ca = dmasg_ca(base, channel);
    6ddc:	00759593          	slli	a1,a1,0x7
    6de0:	00a58533          	add	a0,a1,a0
    6de4:	00c52423          	sw	a2,8(a0)
        write_u32(DMASG_CHANNEL_INPUT_CONFIG_STREAM | (completion_on_packet ? DMASG_CHANNEL_INPUT_CONFIG_COMPLETION_ON_PACKET : 0) | (wait_on_packet ? DMASG_CHANNEL_INPUT_CONFIG_WAIT_ON_PACKET : 0), ca + DMASG_CHANNEL_INPUT_CONFIG);
    6de8:	00070e63          	beqz	a4,6e04 <dmasg_input_stream+0x28>
    6dec:	000027b7          	lui	a5,0x2
    6df0:	00068e63          	beqz	a3,6e0c <dmasg_input_stream+0x30>
    6df4:	00004737          	lui	a4,0x4
    6df8:	00e7e7b3          	or	a5,a5,a4
    6dfc:	00f52623          	sw	a5,12(a0)
    }
    6e00:	00008067          	ret
        write_u32(DMASG_CHANNEL_INPUT_CONFIG_STREAM | (completion_on_packet ? DMASG_CHANNEL_INPUT_CONFIG_COMPLETION_ON_PACKET : 0) | (wait_on_packet ? DMASG_CHANNEL_INPUT_CONFIG_WAIT_ON_PACKET : 0), ca + DMASG_CHANNEL_INPUT_CONFIG);
    6e04:	00000793          	li	a5,0
    6e08:	fe9ff06f          	j	6df0 <dmasg_input_stream+0x14>
    6e0c:	00000713          	li	a4,0
    6e10:	fe9ff06f          	j	6df8 <dmasg_input_stream+0x1c>

00006e14 <dmasg_output_stream>:
        u32 ca = dmasg_ca(base, channel);
    6e14:	00759593          	slli	a1,a1,0x7
    6e18:	00a58533          	add	a0,a1,a0
        write_u32(port << 0 | source << 8 | sink << 16, ca + DMASG_CHANNEL_OUTPUT_STREAM);
    6e1c:	00869693          	slli	a3,a3,0x8
    6e20:	00c6e6b3          	or	a3,a3,a2
    6e24:	01071713          	slli	a4,a4,0x10
    6e28:	00e6e6b3          	or	a3,a3,a4
    6e2c:	00d52c23          	sw	a3,24(a0)
        write_u32(DMASG_CHANNEL_OUTPUT_CONFIG_STREAM | (last ? DMASG_CHANNEL_OUTPUT_CONFIG_LAST : 0), ca + DMASG_CHANNEL_OUTPUT_CONFIG);
    6e30:	00078463          	beqz	a5,6e38 <dmasg_output_stream+0x24>
    6e34:	000027b7          	lui	a5,0x2
    6e38:	00f52e23          	sw	a5,28(a0)
    }
    6e3c:	00008067          	ret

00006e40 <dmasg_direct_start>:
        u32 ca = dmasg_ca(base, channel);
    6e40:	00759593          	slli	a1,a1,0x7
    6e44:	00a58533          	add	a0,a1,a0
        write_u32(bytes-1, ca + DMASG_CHANNEL_DIRECT_BYTES);
    6e48:	fff60613          	addi	a2,a2,-1 # f8afffff <__freertos_irq_stack_top+0xf8aac58f>
    6e4c:	02c52023          	sw	a2,32(a0)
        write_u32(DMASG_CHANNEL_STATUS_DIRECT_START | (self_restart ? DMASG_CHANNEL_STATUS_SELF_RESTART : 0), ca + DMASG_CHANNEL_STATUS);
    6e50:	00068863          	beqz	a3,6e60 <dmasg_direct_start+0x20>
    6e54:	00300793          	li	a5,3
    6e58:	02f52623          	sw	a5,44(a0)
    }
    6e5c:	00008067          	ret
        write_u32(DMASG_CHANNEL_STATUS_DIRECT_START | (self_restart ? DMASG_CHANNEL_STATUS_SELF_RESTART : 0), ca + DMASG_CHANNEL_STATUS);
    6e60:	00100793          	li	a5,1
    6e64:	ff5ff06f          	j	6e58 <dmasg_direct_start+0x18>

00006e68 <dmasg_linked_list_start>:
        u32 ca = dmasg_ca(base, channel);
    6e68:	00759593          	slli	a1,a1,0x7
    6e6c:	00a58533          	add	a0,a1,a0
    6e70:	06c52823          	sw	a2,112(a0)
    6e74:	06052c23          	sw	zero,120(a0)
    6e78:	01000793          	li	a5,16
    6e7c:	02f52623          	sw	a5,44(a0)
    }
    6e80:	00008067          	ret

00006e84 <dmasg_linked_list_sg_start>:
        u32 ca = dmasg_ca(base, channel);
    6e84:	00759593          	slli	a1,a1,0x7
    6e88:	00a58533          	add	a0,a1,a0
    6e8c:	00100793          	li	a5,1
    6e90:	06f52c23          	sw	a5,120(a0)
    6e94:	01000793          	li	a5,16
    6e98:	02f52623          	sw	a5,44(a0)
    }
    6e9c:	00008067          	ret

00006ea0 <dmasg_stop>:
        u32 ca = dmasg_ca(base, channel);
    6ea0:	00759593          	slli	a1,a1,0x7
    6ea4:	00a585b3          	add	a1,a1,a0
    6ea8:	00400793          	li	a5,4
    6eac:	02f5a623          	sw	a5,44(a1)
    }
    6eb0:	00008067          	ret

00006eb4 <dmasg_interrupt_config>:
        u32 ca = dmasg_ca(base, channel);
    6eb4:	00759593          	slli	a1,a1,0x7
    6eb8:	00a58533          	add	a0,a1,a0
    6ebc:	fff00793          	li	a5,-1
    6ec0:	04f52a23          	sw	a5,84(a0)
    6ec4:	04c52823          	sw	a2,80(a0)
    }
    6ec8:	00008067          	ret

00006ecc <dmasg_busy>:
        u32 ca = dmasg_ca(base, channel);
    6ecc:	00759593          	slli	a1,a1,0x7
    6ed0:	00a585b3          	add	a1,a1,a0
        return *((volatile u32*) address);
    6ed4:	02c5a503          	lw	a0,44(a1)
    }
    6ed8:	00157513          	andi	a0,a0,1
    6edc:	00008067          	ret

00006ee0 <i2c_applyConfig>:
        write_u32(config->samplingClockDivider, reg + I2C_SAMPLING_CLOCK_DIVIDER);
    6ee0:	0005a783          	lw	a5,0(a1)
        *((volatile u32*) address) = data;
    6ee4:	02f52423          	sw	a5,40(a0)
        write_u32(config->timeout, reg + I2C_TIMEOUT);
    6ee8:	0045a783          	lw	a5,4(a1)
    6eec:	02f52623          	sw	a5,44(a0)
        write_u32(config->tsuDat, reg + I2C_TSUDAT);
    6ef0:	0085a783          	lw	a5,8(a1)
    6ef4:	02f52823          	sw	a5,48(a0)
        write_u32(config->tLow, reg + I2C_TLOW);
    6ef8:	00c5a783          	lw	a5,12(a1)
    6efc:	04f52823          	sw	a5,80(a0)
        write_u32(config->tHigh, reg + I2C_THIGH);
    6f00:	0105a783          	lw	a5,16(a1)
    6f04:	04f52a23          	sw	a5,84(a0)
        write_u32(config->tBuf, reg + I2C_TBUF);
    6f08:	0145a783          	lw	a5,20(a1)
    6f0c:	04f52c23          	sw	a5,88(a0)
    }
    6f10:	00008067          	ret

00006f14 <bsp_printf>:
    {
    6f14:	fc010113          	addi	sp,sp,-64
    6f18:	00112e23          	sw	ra,28(sp)
    6f1c:	00812c23          	sw	s0,24(sp)
    6f20:	00912a23          	sw	s1,20(sp)
    6f24:	00050493          	mv	s1,a0
    6f28:	02b12223          	sw	a1,36(sp)
    6f2c:	02c12423          	sw	a2,40(sp)
    6f30:	02d12623          	sw	a3,44(sp)
    6f34:	02e12823          	sw	a4,48(sp)
    6f38:	02f12a23          	sw	a5,52(sp)
    6f3c:	03012c23          	sw	a6,56(sp)
    6f40:	03112e23          	sw	a7,60(sp)
        va_start(ap, format);
    6f44:	02410793          	addi	a5,sp,36
    6f48:	00f12623          	sw	a5,12(sp)
        for (i = 0; format[i]; i++)
    6f4c:	00000413          	li	s0,0
    6f50:	01c0006f          	j	6f6c <bsp_printf+0x58>
                        bsp_printf_c(va_arg(ap,int));
    6f54:	00c12783          	lw	a5,12(sp)
    6f58:	00478713          	addi	a4,a5,4 # 2004 <_reclaim_reent+0x34>
    6f5c:	00e12623          	sw	a4,12(sp)
    6f60:	0007a503          	lw	a0,0(a5)
    6f64:	cf5ff0ef          	jal	ra,6c58 <bsp_printf_c>
        for (i = 0; format[i]; i++)
    6f68:	00140413          	addi	s0,s0,1
    6f6c:	008487b3          	add	a5,s1,s0
    6f70:	0007c503          	lbu	a0,0(a5)
    6f74:	0c050263          	beqz	a0,7038 <bsp_printf+0x124>
            if (format[i] == '%') {
    6f78:	02500793          	li	a5,37
    6f7c:	06f50663          	beq	a0,a5,6fe8 <bsp_printf+0xd4>
                bsp_printf_c(format[i]);
    6f80:	cd9ff0ef          	jal	ra,6c58 <bsp_printf_c>
    6f84:	fe5ff06f          	j	6f68 <bsp_printf+0x54>
                        bsp_printf_s(va_arg(ap,char*));
    6f88:	00c12783          	lw	a5,12(sp)
    6f8c:	00478713          	addi	a4,a5,4
    6f90:	00e12623          	sw	a4,12(sp)
    6f94:	0007a503          	lw	a0,0(a5)
    6f98:	cddff0ef          	jal	ra,6c74 <bsp_printf_s>
                        break;
    6f9c:	fcdff06f          	j	6f68 <bsp_printf+0x54>
                        bsp_printf_d(va_arg(ap,int));
    6fa0:	00c12783          	lw	a5,12(sp)
    6fa4:	00478713          	addi	a4,a5,4
    6fa8:	00e12623          	sw	a4,12(sp)
    6fac:	0007a503          	lw	a0,0(a5)
    6fb0:	cddff0ef          	jal	ra,6c8c <bsp_printf_d>
                        break;
    6fb4:	fb5ff06f          	j	6f68 <bsp_printf+0x54>
                        bsp_printf_X(va_arg(ap,int));
    6fb8:	00c12783          	lw	a5,12(sp)
    6fbc:	00478713          	addi	a4,a5,4
    6fc0:	00e12623          	sw	a4,12(sp)
    6fc4:	0007a503          	lw	a0,0(a5)
    6fc8:	d85ff0ef          	jal	ra,6d4c <bsp_printf_X>
                        break;
    6fcc:	f9dff06f          	j	6f68 <bsp_printf+0x54>
                        bsp_printf_x(va_arg(ap,int));
    6fd0:	00c12783          	lw	a5,12(sp)
    6fd4:	00478713          	addi	a4,a5,4
    6fd8:	00e12623          	sw	a4,12(sp)
    6fdc:	0007a503          	lw	a0,0(a5)
    6fe0:	d2dff0ef          	jal	ra,6d0c <bsp_printf_x>
                        break;
    6fe4:	f85ff06f          	j	6f68 <bsp_printf+0x54>
                while (format[++i]) {
    6fe8:	00140413          	addi	s0,s0,1
    6fec:	008487b3          	add	a5,s1,s0
    6ff0:	0007c783          	lbu	a5,0(a5)
    6ff4:	f6078ae3          	beqz	a5,6f68 <bsp_printf+0x54>
                    if (format[i] == 'c') {
    6ff8:	06300713          	li	a4,99
    6ffc:	f4e78ce3          	beq	a5,a4,6f54 <bsp_printf+0x40>
                    else if (format[i] == 's') {
    7000:	07300713          	li	a4,115
    7004:	f8e782e3          	beq	a5,a4,6f88 <bsp_printf+0x74>
                    else if (format[i] == 'd') {
    7008:	06400713          	li	a4,100
    700c:	f8e78ae3          	beq	a5,a4,6fa0 <bsp_printf+0x8c>
                    else if (format[i] == 'X') {
    7010:	05800713          	li	a4,88
    7014:	fae782e3          	beq	a5,a4,6fb8 <bsp_printf+0xa4>
                    else if (format[i] == 'x') {
    7018:	07800713          	li	a4,120
    701c:	fae78ae3          	beq	a5,a4,6fd0 <bsp_printf+0xbc>
                    else if (format[i] == 'f') {
    7020:	06600713          	li	a4,102
    7024:	fce792e3          	bne	a5,a4,6fe8 <bsp_printf+0xd4>
                        bsp_printf_s("<Floating point printing not enable. Please Enable it at bsp.h first...>");
    7028:	00009537          	lui	a0,0x9
    702c:	af850513          	addi	a0,a0,-1288 # 8af8 <_data+0xe4>
    7030:	c45ff0ef          	jal	ra,6c74 <bsp_printf_s>
                        break;
    7034:	f35ff06f          	j	6f68 <bsp_printf+0x54>
    }
    7038:	01c12083          	lw	ra,28(sp)
    703c:	01812403          	lw	s0,24(sp)
    7040:	01412483          	lw	s1,20(sp)
    7044:	04010113          	addi	sp,sp,64
    7048:	00008067          	ret

0000704c <framebuffer_loadTable>:
{
	int j;
	int XCount =0;
	int YCouut =0;
	int lineSize = FRAME_SIZE_RX/FRAME_Y_RX;
	int XPtr1 =start_x /4;
    704c:	0025d313          	srli	t1,a1,0x2
	int XPtr4 =end_x /4;
    7050:	00265e93          	srli	t4,a2,0x2


	int YPtr1 =start_y ;
    7054:	00068813          	mv	a6,a3
	int YPtr4 =end_y ;
    7058:	00070893          	mv	a7,a4


	int tableSize_x = (end_x - start_x)/4;
    705c:	40b60633          	sub	a2,a2,a1
    7060:	00265293          	srli	t0,a2,0x2
	int tableSize_y = (end_y - start_y);
    7064:	40d70fb3          	sub	t6,a4,a3


    const u32 (*raw_table1_ptr)[93];


    switch (TableIndex)
    7068:	00200713          	li	a4,2
    706c:	06e78263          	beq	a5,a4,70d0 <framebuffer_loadTable+0x84>
    7070:	02f77063          	bgeu	a4,a5,7090 <framebuffer_loadTable+0x44>
    7074:	00300713          	li	a4,3
    7078:	06e78263          	beq	a5,a4,70dc <framebuffer_loadTable+0x90>
    707c:	00400713          	li	a4,4
    7080:	04e79263          	bne	a5,a4,70c4 <framebuffer_loadTable+0x78>
    {
    	case 0: raw_table1_ptr = raw_table;		break;
       	case 1: raw_table1_ptr = raw_table1;		break;
       	case 2: raw_table1_ptr = raw_table2;		break;
       	case 3: raw_table1_ptr = raw_table3;		break;
     	case 4: raw_table1_ptr = raw_table4;		break;
    7084:	0000af37          	lui	t5,0xa
    7088:	93cf0f13          	addi	t5,t5,-1732 # 993c <raw_table4>
    708c:	0200006f          	j	70ac <framebuffer_loadTable+0x60>
    switch (TableIndex)
    7090:	00100713          	li	a4,1
    7094:	00e79863          	bne	a5,a4,70a4 <framebuffer_loadTable+0x58>
       	case 1: raw_table1_ptr = raw_table1;		break;
    7098:	00035f37          	lui	t5,0x35
    709c:	a04f0f13          	addi	t5,t5,-1532 # 34a04 <raw_table1>
    70a0:	00c0006f          	j	70ac <framebuffer_loadTable+0x60>
    	case 0: raw_table1_ptr = raw_table;		break;
    70a4:	00043f37          	lui	t5,0x43
    70a8:	f9cf0f13          	addi	t5,t5,-100 # 42f9c <raw_table>
    int tablePtr_y =0;
    70ac:	00000e13          	li	t3,0
	int tablePtr_x =0;
    70b0:	00000593          	li	a1,0
	int YCouut =0;
    70b4:	00000613          	li	a2,0
	int XCount =0;
    70b8:	00000713          	li	a4,0
       	default: raw_table1_ptr = raw_table;		break;

    }
 //   raw_table1_ptr = raw_table;

    for(j=0;j<(FRAME_SIZE_RX*1);j++){
    70bc:	00000693          	li	a3,0
    70c0:	0600006f          	j	7120 <framebuffer_loadTable+0xd4>
    	case 0: raw_table1_ptr = raw_table;		break;
    70c4:	00043f37          	lui	t5,0x43
    70c8:	f9cf0f13          	addi	t5,t5,-100 # 42f9c <raw_table>
    70cc:	fe1ff06f          	j	70ac <framebuffer_loadTable+0x60>
       	case 2: raw_table1_ptr = raw_table2;		break;
    70d0:	00026f37          	lui	t5,0x26
    70d4:	46cf0f13          	addi	t5,t5,1132 # 2646c <raw_table2>
    70d8:	fd5ff06f          	j	70ac <framebuffer_loadTable+0x60>
       	case 3: raw_table1_ptr = raw_table3;		break;
    70dc:	00018f37          	lui	t5,0x18
    70e0:	ed4f0f13          	addi	t5,t5,-300 # 17ed4 <raw_table3>
    70e4:	fc9ff06f          	j	70ac <framebuffer_loadTable+0x60>

    		 XCount ++;
    		 if( XCount == lineSize )
    		 {
    			// bsp_printf("%d\n\r",XCount );
    			 if ( (YCouut >= YPtr1 ) && (YCouut <= YPtr4 ) )
    70e8:	01064663          	blt	a2,a6,70f4 <framebuffer_loadTable+0xa8>
    70ec:	00c8c463          	blt	a7,a2,70f4 <framebuffer_loadTable+0xa8>
    			 {
    				 tablePtr_y++;
    70f0:	001e0e13          	addi	t3,t3,1

    			 }
    			 tablePtr_x =0;

    			 XCount = 0;
    			 YCouut++;
    70f4:	00160613          	addi	a2,a2,1
    			 tablePtr_x =0;
    70f8:	00000593          	li	a1,0
    			 XCount = 0;
    70fc:	00000713          	li	a4,0
    7100:	0800006f          	j	7180 <framebuffer_loadTable+0x134>


		 }
		  }
*/
}
    7104:	00c12403          	lw	s0,12(sp)
    7108:	01010113          	addi	sp,sp,16
    710c:	00008067          	ret
    		 XCount ++;
    7110:	00170713          	addi	a4,a4,1 # 4001 <bsp_printf_d+0x45>
    		 if( XCount == lineSize )
    7114:	1e000793          	li	a5,480
    7118:	08f70a63          	beq	a4,a5,71ac <framebuffer_loadTable+0x160>
    for(j=0;j<(FRAME_SIZE_RX*1);j++){
    711c:	00168693          	addi	a3,a3,1
    7120:	0007f7b7          	lui	a5,0x7f
    7124:	8ff78793          	addi	a5,a5,-1793 # 7e8ff <__freertos_irq_stack_top+0x2ae8f>
    7128:	0ad7c063          	blt	a5,a3,71c8 <framebuffer_loadTable+0x17c>
    	if (  ( (YCouut >= YPtr1 ) && (YCouut <= YPtr4 ) )
    712c:	ff0642e3          	blt	a2,a6,7110 <framebuffer_loadTable+0xc4>
    7130:	fec8c0e3          	blt	a7,a2,7110 <framebuffer_loadTable+0xc4>
    		&&(  (XCount >= XPtr1 ) && (XCount <= XPtr4 ) )
    7134:	fc674ee3          	blt	a4,t1,7110 <framebuffer_loadTable+0xc4>
    7138:	fceecce3          	blt	t4,a4,7110 <framebuffer_loadTable+0xc4>
    		&&( tablePtr_y <=  tableSize_y )
    713c:	fdcfcae3          	blt	t6,t3,7110 <framebuffer_loadTable+0xc4>
			&&( tablePtr_x <=  tableSize_x )
    7140:	fcb2c8e3          	blt	t0,a1,7110 <framebuffer_loadTable+0xc4>
{
    7144:	ff010113          	addi	sp,sp,-16
    7148:	00812623          	sw	s0,12(sp)
    		framebuffer[j] = raw_table1_ptr[tablePtr_y][tablePtr_x];
    714c:	17400793          	li	a5,372
    7150:	02fe07b3          	mul	a5,t3,a5
    7154:	00ff07b3          	add	a5,t5,a5
    7158:	00269393          	slli	t2,a3,0x2
    715c:	007503b3          	add	t2,a0,t2
    7160:	00259413          	slli	s0,a1,0x2
    7164:	008787b3          	add	a5,a5,s0
    7168:	0007a783          	lw	a5,0(a5)
    716c:	00f3a023          	sw	a5,0(t2)
    		tablePtr_x ++;
    7170:	00158593          	addi	a1,a1,1
    		 XCount ++;
    7174:	00170713          	addi	a4,a4,1
    		 if( XCount == lineSize )
    7178:	1e000793          	li	a5,480
    717c:	f6f706e3          	beq	a4,a5,70e8 <framebuffer_loadTable+0x9c>
    for(j=0;j<(FRAME_SIZE_RX*1);j++){
    7180:	00168693          	addi	a3,a3,1
    7184:	0007f7b7          	lui	a5,0x7f
    7188:	8ff78793          	addi	a5,a5,-1793 # 7e8ff <__freertos_irq_stack_top+0x2ae8f>
    718c:	f6d7cce3          	blt	a5,a3,7104 <framebuffer_loadTable+0xb8>
    	if (  ( (YCouut >= YPtr1 ) && (YCouut <= YPtr4 ) )
    7190:	ff0642e3          	blt	a2,a6,7174 <framebuffer_loadTable+0x128>
    7194:	fec8c0e3          	blt	a7,a2,7174 <framebuffer_loadTable+0x128>
    		&&(  (XCount >= XPtr1 ) && (XCount <= XPtr4 ) )
    7198:	fc674ee3          	blt	a4,t1,7174 <framebuffer_loadTable+0x128>
    719c:	fceecce3          	blt	t4,a4,7174 <framebuffer_loadTable+0x128>
    		&&( tablePtr_y <=  tableSize_y )
    71a0:	fdcfcae3          	blt	t6,t3,7174 <framebuffer_loadTable+0x128>
			&&( tablePtr_x <=  tableSize_x )
    71a4:	fcb2c8e3          	blt	t0,a1,7174 <framebuffer_loadTable+0x128>
    71a8:	fa5ff06f          	j	714c <framebuffer_loadTable+0x100>
    			 if ( (YCouut >= YPtr1 ) && (YCouut <= YPtr4 ) )
    71ac:	01064663          	blt	a2,a6,71b8 <framebuffer_loadTable+0x16c>
    71b0:	00c8c463          	blt	a7,a2,71b8 <framebuffer_loadTable+0x16c>
    				 tablePtr_y++;
    71b4:	001e0e13          	addi	t3,t3,1
    			 YCouut++;
    71b8:	00160613          	addi	a2,a2,1
    			 tablePtr_x =0;
    71bc:	00000593          	li	a1,0
    			 XCount = 0;
    71c0:	00000713          	li	a4,0
    71c4:	f59ff06f          	j	711c <framebuffer_loadTable+0xd0>
    71c8:	00008067          	ret

000071cc <framebuffer_overlayFrame>:



void framebuffer_overlayFrame(u32 *framebuffer, u32 start_x, u32 end_x, u32 start_y, u32 end_y, u32 thickness, u32 colourType)
{
    71cc:	f7010113          	addi	sp,sp,-144
    71d0:	08812623          	sw	s0,140(sp)
	//thickness value should be 4 pixel per step.
	const u32 colourIndx[4][8] = {
    71d4:	00009337          	lui	t1,0x9
    71d8:	51c30313          	addi	t1,t1,1308 # 951c <imx477_mode_1920x1080_60fps+0x1ec>
    71dc:	00010e13          	mv	t3,sp
    71e0:	08030293          	addi	t0,t1,128
    71e4:	00032403          	lw	s0,0(t1)
    71e8:	00432f83          	lw	t6,4(t1)
    71ec:	00832f03          	lw	t5,8(t1)
    71f0:	00c32e83          	lw	t4,12(t1)
    71f4:	008e2023          	sw	s0,0(t3)
    71f8:	01fe2223          	sw	t6,4(t3)
    71fc:	01ee2423          	sw	t5,8(t3)
    7200:	01de2623          	sw	t4,12(t3)
    7204:	01030313          	addi	t1,t1,16
    7208:	010e0e13          	addi	t3,t3,16
    720c:	fc531ce3          	bne	t1,t0,71e4 <framebuffer_overlayFrame+0x18>


	int XCount =0;
	int YCouut =0;
	int lineSize = FRAME_SIZE_TX/FRAME_Y_TX;
	int XPtr1 =start_x /4;
    7210:	0025d893          	srli	a7,a1,0x2
	int XPtr2 =start_x /4 + (thickness/4-1);
    7214:	0027d593          	srli	a1,a5,0x2
    7218:	00b88f33          	add	t5,a7,a1
    721c:	ffff0f13          	addi	t5,t5,-1
	int XPtr3 =end_x /4   - (thickness/4-1);
    7220:	00265313          	srli	t1,a2,0x2
    7224:	40b305b3          	sub	a1,t1,a1
    7228:	00158f93          	addi	t6,a1,1
	int XPtr4 =end_x /4;


	int YPtr1 =start_y ;
    722c:	00068e13          	mv	t3,a3
	int YPtr2 =start_y  + thickness;
    7230:	00d783b3          	add	t2,a5,a3
	int YPtr3 =end_y    - thickness;
    7234:	40f702b3          	sub	t0,a4,a5
	int YPtr4 =end_y ;
	int j;

	 for(j=0;j<(FRAME_SIZE_TX*1);j++){
    7238:	00000613          	li	a2,0
	int YCouut =0;
    723c:	00000593          	li	a1,0
	int XCount =0;
    7240:	00000793          	li	a5,0
	 for(j=0;j<(FRAME_SIZE_TX*1);j++){
    7244:	0600006f          	j	72a4 <framebuffer_overlayFrame+0xd8>
				  //solid Colour
			  }
		      else
		      {
		    	  //Frame
		    	  if(colourType != 8)
    7248:	00800693          	li	a3,8
    724c:	08d80463          	beq	a6,a3,72d4 <framebuffer_overlayFrame+0x108>
		    	  {
		    		  framebuffer[j] =  colourIndx[YCouut%4][colourType] | 0x01010101;
    7250:	41f5d693          	srai	a3,a1,0x1f
    7254:	01e6de93          	srli	t4,a3,0x1e
    7258:	01d586b3          	add	a3,a1,t4
    725c:	0036f693          	andi	a3,a3,3
    7260:	41d686b3          	sub	a3,a3,t4
    7264:	00369693          	slli	a3,a3,0x3
    7268:	010686b3          	add	a3,a3,a6
    726c:	00269693          	slli	a3,a3,0x2
    7270:	08010e93          	addi	t4,sp,128
    7274:	00de86b3          	add	a3,t4,a3
    7278:	f806ae83          	lw	t4,-128(a3)
    727c:	00261693          	slli	a3,a2,0x2
    7280:	00d506b3          	add	a3,a0,a3
    7284:	01010437          	lui	s0,0x1010
    7288:	10140413          	addi	s0,s0,257 # 1010101 <__freertos_irq_stack_top+0xfbc691>
    728c:	008eeeb3          	or	t4,t4,s0
    7290:	01d6a023          	sw	t4,0(a3)
		    		  framebuffer[j] = 0x00000000;
		    	  }
		      }
		 }

		 XCount ++;
    7294:	00178793          	addi	a5,a5,1
		 if( XCount == lineSize )
    7298:	1e000693          	li	a3,480
    729c:	04d78463          	beq	a5,a3,72e4 <framebuffer_overlayFrame+0x118>
	 for(j=0;j<(FRAME_SIZE_TX*1);j++){
    72a0:	00160613          	addi	a2,a2,1
    72a4:	0007f6b7          	lui	a3,0x7f
    72a8:	8ff68693          	addi	a3,a3,-1793 # 7e8ff <__freertos_irq_stack_top+0x2ae8f>
    72ac:	04c6c263          	blt	a3,a2,72f0 <framebuffer_overlayFrame+0x124>
		 if(  (XCount >= XPtr1) &&  (XCount <= XPtr4) && (YCouut >= YPtr1) && (YCouut <= YPtr4) )
    72b0:	ff17c2e3          	blt	a5,a7,7294 <framebuffer_overlayFrame+0xc8>
    72b4:	fef340e3          	blt	t1,a5,7294 <framebuffer_overlayFrame+0xc8>
    72b8:	fdc5cee3          	blt	a1,t3,7294 <framebuffer_overlayFrame+0xc8>
    72bc:	fcb74ce3          	blt	a4,a1,7294 <framebuffer_overlayFrame+0xc8>
		      if ( (XCount > XPtr2) &&  (XCount < XPtr3) && (YCouut > YPtr2) && (YCouut < YPtr3) )
    72c0:	f8ff54e3          	bge	t5,a5,7248 <framebuffer_overlayFrame+0x7c>
    72c4:	f9f7d2e3          	bge	a5,t6,7248 <framebuffer_overlayFrame+0x7c>
    72c8:	f8b3d0e3          	bge	t2,a1,7248 <framebuffer_overlayFrame+0x7c>
    72cc:	fc55c4e3          	blt	a1,t0,7294 <framebuffer_overlayFrame+0xc8>
    72d0:	f79ff06f          	j	7248 <framebuffer_overlayFrame+0x7c>
		    		  framebuffer[j] = 0x00000000;
    72d4:	00261693          	slli	a3,a2,0x2
    72d8:	00d506b3          	add	a3,a0,a3
    72dc:	0006a023          	sw	zero,0(a3)
    72e0:	fb5ff06f          	j	7294 <framebuffer_overlayFrame+0xc8>
		 {
			 XCount = 0;
		 	 YCouut++;
    72e4:	00158593          	addi	a1,a1,1
			 XCount = 0;
    72e8:	00000793          	li	a5,0
    72ec:	fb5ff06f          	j	72a0 <framebuffer_overlayFrame+0xd4>
		 }
	 }


}
    72f0:	08c12403          	lw	s0,140(sp)
    72f4:	09010113          	addi	sp,sp,144
    72f8:	00008067          	ret

000072fc <framebuffer_overlayMask>:
void framebuffer_overlayMask(u32 *framebuffer, int index) {

	 u32 j,k,y;
	u32 linesize = FRAME_SIZE_HDMI/4/FRAME_Y_HDMI ;

	for(j=0;j<(FRAME_SIZE_HDMI*1);j++){
    72fc:	00000713          	li	a4,0
    7300:	0007f7b7          	lui	a5,0x7f
    7304:	8ff78793          	addi	a5,a5,-1793 # 7e8ff <__freertos_irq_stack_top+0x2ae8f>
    7308:	00e7ec63          	bltu	a5,a4,7320 <framebuffer_overlayMask+0x24>
					 framebuffer[j] = 0x00000000;
    730c:	00271793          	slli	a5,a4,0x2
    7310:	00f507b3          	add	a5,a0,a5
    7314:	0007a023          	sw	zero,0(a5)
	for(j=0;j<(FRAME_SIZE_HDMI*1);j++){
    7318:	00170713          	addi	a4,a4,1
    731c:	fe5ff06f          	j	7300 <framebuffer_overlayMask+0x4>
		}


		 for(j=0;j<(FRAME_SIZE_HDMI*1);j++){
    7320:	00000793          	li	a5,0
    7324:	0140006f          	j	7338 <framebuffer_overlayMask+0x3c>

			 if ( ((j%linesize) >=0) && ( (j%linesize) < 20 ) )
				 framebuffer[j] = 0xFFFFFFFF;
			 else
				 framebuffer[j] = 0x00000000;
    7328:	00279713          	slli	a4,a5,0x2
    732c:	00e50733          	add	a4,a0,a4
    7330:	00072023          	sw	zero,0(a4)
		 for(j=0;j<(FRAME_SIZE_HDMI*1);j++){
    7334:	00178793          	addi	a5,a5,1
    7338:	0007f737          	lui	a4,0x7f
    733c:	8ff70713          	addi	a4,a4,-1793 # 7e8ff <__freertos_irq_stack_top+0x2ae8f>
    7340:	02f76463          	bltu	a4,a5,7368 <framebuffer_overlayMask+0x6c>
			 if ( ((j%linesize) >=0) && ( (j%linesize) < 20 ) )
    7344:	07800713          	li	a4,120
    7348:	02e7f733          	remu	a4,a5,a4
    734c:	01300693          	li	a3,19
    7350:	fce6ece3          	bltu	a3,a4,7328 <framebuffer_overlayMask+0x2c>
				 framebuffer[j] = 0xFFFFFFFF;
    7354:	00279713          	slli	a4,a5,0x2
    7358:	00e50733          	add	a4,a0,a4
    735c:	fff00693          	li	a3,-1
    7360:	00d72023          	sw	a3,0(a4)
    7364:	fd1ff06f          	j	7334 <framebuffer_overlayMask+0x38>



		 }
}
    7368:	00008067          	ret

0000736c <framebuffer_pattern>:


void framebuffer_pattern(u32 *framebuffer, int index, int orientation) {
    736c:	c8010113          	addi	sp,sp,-896
	u32 outpixel = 0;
	u32 TempPixel1 = 0;
	u32 TempPixel2 = 0;
	u32 TempPixel3 = 0;
	u32 TempPixel4 = 0;
	int startline = index*2;
    7370:	00159593          	slli	a1,a1,0x1
	int endline = startline +2;
    7374:	00258813          	addi	a6,a1,2
	int colourtcount = 0;
	int linecount 	= 0;

	const u32 colourbar[14][16] = {
    7378:	000096b7          	lui	a3,0x9
    737c:	51c68693          	addi	a3,a3,1308 # 951c <imx477_mode_1920x1080_60fps+0x1ec>
    7380:	08068793          	addi	a5,a3,128
    7384:	00010713          	mv	a4,sp
    7388:	40068693          	addi	a3,a3,1024
    738c:	0007ae83          	lw	t4,0(a5)
    7390:	0047ae03          	lw	t3,4(a5)
    7394:	0087a303          	lw	t1,8(a5)
    7398:	00c7a883          	lw	a7,12(a5)
    739c:	01d72023          	sw	t4,0(a4)
    73a0:	01c72223          	sw	t3,4(a4)
    73a4:	00672423          	sw	t1,8(a4)
    73a8:	01172623          	sw	a7,12(a4)
    73ac:	01078793          	addi	a5,a5,16
    73b0:	01070713          	addi	a4,a4,16
    73b4:	fcd79ce3          	bne	a5,a3,738c <framebuffer_pattern+0x20>
	 u32 Temp_Count2 = 0;

	 u32 Temp_Count3 = 0;


	 if (orientation == 0)
    73b8:	06060e63          	beqz	a2,7434 <framebuffer_pattern+0xc8>
	 linecount 	= startline;
    73bc:	00058693          	mv	a3,a1
		 framebuffer[j] = outpixel;
		 }
	}
	else
	{
		 for(j=0;j<(FRAME_SIZE_RX*1);j++){
    73c0:	00000713          	li	a4,0
	 colourtcount = 0;
    73c4:	00000893          	li	a7,0
    73c8:	0ac0006f          	j	7474 <framebuffer_pattern+0x108>
						 linecount =startline;
    73cc:	00058313          	mv	t1,a1
					 colourtcount=0;
    73d0:	00060693          	mv	a3,a2
		 outpixel = colourbar[linecount][colourtcount];
    73d4:	00431793          	slli	a5,t1,0x4
    73d8:	00d787b3          	add	a5,a5,a3
    73dc:	00279793          	slli	a5,a5,0x2
    73e0:	38010893          	addi	a7,sp,896
    73e4:	00f887b3          	add	a5,a7,a5
    73e8:	c807a883          	lw	a7,-896(a5)
		 framebuffer[j] = outpixel;
    73ec:	00271793          	slli	a5,a4,0x2
    73f0:	00f507b3          	add	a5,a0,a5
    73f4:	0117a023          	sw	a7,0(a5)
		 for(j=0;j<(FRAME_SIZE_RX*1);j++){
    73f8:	00170713          	addi	a4,a4,1
    73fc:	0007f7b7          	lui	a5,0x7f
    7400:	8ff78793          	addi	a5,a5,-1793 # 7e8ff <__freertos_irq_stack_top+0x2ae8f>
    7404:	0ae7e663          	bltu	a5,a4,74b0 <framebuffer_pattern+0x144>
		 if(j!=0)
    7408:	fc0706e3          	beqz	a4,73d4 <framebuffer_pattern+0x68>
			 if( (j%(FRAME_X_RX/32)) ==0 ){
    740c:	03c00793          	li	a5,60
    7410:	02f777b3          	remu	a5,a4,a5
    7414:	fc0790e3          	bnez	a5,73d4 <framebuffer_pattern+0x68>
				 colourtcount++;
    7418:	00168693          	addi	a3,a3,1
				 if(colourtcount==8)
    741c:	00800793          	li	a5,8
    7420:	faf69ae3          	bne	a3,a5,73d4 <framebuffer_pattern+0x68>
					 linecount++;
    7424:	00130313          	addi	t1,t1,1
					 if(linecount==(endline)){
    7428:	fa6802e3          	beq	a6,t1,73cc <framebuffer_pattern+0x60>
					 colourtcount=0;
    742c:	00060693          	mv	a3,a2
    7430:	fa5ff06f          	j	73d4 <framebuffer_pattern+0x68>
	 linecount 	= startline;
    7434:	00058313          	mv	t1,a1
	 colourtcount = 0;
    7438:	00060693          	mv	a3,a2
		 for(j=0;j<(FRAME_SIZE_RX*1);j++){
    743c:	00000713          	li	a4,0
    7440:	fbdff06f          	j	73fc <framebuffer_pattern+0x90>
					 if( (j%(FRAME_X_RX/4)) ==0 ){

		//				 bsp_printf("%8x ", j );
						 linecount++;
						 if(linecount==(endline)){
							 linecount =startline;
    7444:	00058693          	mv	a3,a1
    7448:	0500006f          	j	7498 <framebuffer_pattern+0x12c>
					if (j% ((FRAME_X_RX/4)* (FRAME_Y_RX/8) )==0  )
					 colourtcount++;

			         }
			     }
				 outpixel = colourbar[linecount][colourtcount];
    744c:	00469793          	slli	a5,a3,0x4
    7450:	011787b3          	add	a5,a5,a7
    7454:	00279793          	slli	a5,a5,0x2
    7458:	38010613          	addi	a2,sp,896
    745c:	00f607b3          	add	a5,a2,a5
    7460:	c807a603          	lw	a2,-896(a5)
				 framebuffer[j] = outpixel;
    7464:	00271793          	slli	a5,a4,0x2
    7468:	00f507b3          	add	a5,a0,a5
    746c:	00c7a023          	sw	a2,0(a5)
		 for(j=0;j<(FRAME_SIZE_RX*1);j++){
    7470:	00170713          	addi	a4,a4,1
    7474:	0007f7b7          	lui	a5,0x7f
    7478:	8ff78793          	addi	a5,a5,-1793 # 7e8ff <__freertos_irq_stack_top+0x2ae8f>
    747c:	02e7ea63          	bltu	a5,a4,74b0 <framebuffer_pattern+0x144>
				 if(j!=0)
    7480:	fc0706e3          	beqz	a4,744c <framebuffer_pattern+0xe0>
					 if( (j%(FRAME_X_RX/4)) ==0 ){
    7484:	1e000793          	li	a5,480
    7488:	02f777b3          	remu	a5,a4,a5
    748c:	fc0790e3          	bnez	a5,744c <framebuffer_pattern+0xe0>
						 linecount++;
    7490:	00168693          	addi	a3,a3,1
						 if(linecount==(endline)){
    7494:	fad808e3          	beq	a6,a3,7444 <framebuffer_pattern+0xd8>
					if (j% ((FRAME_X_RX/4)* (FRAME_Y_RX/8) )==0  )
    7498:	000107b7          	lui	a5,0x10
    749c:	d2078793          	addi	a5,a5,-736 # fd20 <raw_table4+0x63e4>
    74a0:	02f777b3          	remu	a5,a4,a5
    74a4:	fa0794e3          	bnez	a5,744c <framebuffer_pattern+0xe0>
					 colourtcount++;
    74a8:	00188893          	addi	a7,a7,1
    74ac:	fa1ff06f          	j	744c <framebuffer_pattern+0xe0>
				 }
	}
}
    74b0:	38010113          	addi	sp,sp,896
    74b4:	00008067          	ret

000074b8 <dma_video_in_channel_execution>:


void dma_video_in_channel_execution(u32 *framebuffer, u32 channel)
{
    74b8:	ff010113          	addi	sp,sp,-16
    74bc:	00112623          	sw	ra,12(sp)
    74c0:	00812423          	sw	s0,8(sp)
    74c4:	00912223          	sw	s1,4(sp)
    74c8:	00050493          	mv	s1,a0
    74cc:	00058413          	mv	s0,a1
	if(dmasg_busy(DMASG_BASE, channel))
    74d0:	f8130537          	lui	a0,0xf8130
    74d4:	9f9ff0ef          	jal	ra,6ecc <dmasg_busy>
    74d8:	06051663          	bnez	a0,7544 <dma_video_in_channel_execution+0x8c>
	{
		bsp_printf("stop dma Ch %x \n\r with SG MODE", channel);
		dmasg_stop(DMASG_BASE, channel);

	}
	bsp_printf("Start dma Ch %x \n\r with SG Mode", channel);
    74dc:	00040593          	mv	a1,s0
    74e0:	00051537          	lui	a0,0x51
    74e4:	55450513          	addi	a0,a0,1364 # 51554 <raw_table+0xe5b8>
    74e8:	a2dff0ef          	jal	ra,6f14 <bsp_printf>
	dmasg_output_memory(DMASG_BASE,channel, (u32)framebuffer, (256)); // dmasg_pop_memory (DMASG_BASE, DMASG_CHANNEL0, (u32)pucEthernetBuffer, 64);
    74ec:	10000693          	li	a3,256
    74f0:	00048613          	mv	a2,s1
    74f4:	00040593          	mv	a1,s0
    74f8:	f8130537          	lui	a0,0xf8130
    74fc:	8b9ff0ef          	jal	ra,6db4 <dmasg_output_memory>
	dmasg_input_stream(DMASG_BASE, channel, 0, 0, 0); 				  // dmasg_push_stream(DMASG_BASE, DMASG_CHANNEL0, 0, 0, 0);
    7500:	00000713          	li	a4,0
    7504:	00000693          	li	a3,0
    7508:	00000613          	li	a2,0
    750c:	00040593          	mv	a1,s0
    7510:	f8130537          	lui	a0,0xf8130
    7514:	8c9ff0ef          	jal	ra,6ddc <dmasg_input_stream>
	dmasg_direct_start(DMASG_BASE, channel, ((u32)(FRAME_SIZE_RX*4)), 1);// dmasg_start(DMASG_BASE, DMASG_CHANNEL0, xDataLength, 0);
    7518:	00100693          	li	a3,1
    751c:	001fa637          	lui	a2,0x1fa
    7520:	40060613          	addi	a2,a2,1024 # 1fa400 <__freertos_irq_stack_top+0x1a6990>
    7524:	00040593          	mv	a1,s0
    7528:	f8130537          	lui	a0,0xf8130
    752c:	915ff0ef          	jal	ra,6e40 <dmasg_direct_start>

}
    7530:	00c12083          	lw	ra,12(sp)
    7534:	00812403          	lw	s0,8(sp)
    7538:	00412483          	lw	s1,4(sp)
    753c:	01010113          	addi	sp,sp,16
    7540:	00008067          	ret
		bsp_printf("stop dma Ch %x \n\r with SG MODE", channel);
    7544:	00040593          	mv	a1,s0
    7548:	00051537          	lui	a0,0x51
    754c:	53450513          	addi	a0,a0,1332 # 51534 <raw_table+0xe598>
    7550:	9c5ff0ef          	jal	ra,6f14 <bsp_printf>
		dmasg_stop(DMASG_BASE, channel);
    7554:	00040593          	mv	a1,s0
    7558:	f8130537          	lui	a0,0xf8130
    755c:	945ff0ef          	jal	ra,6ea0 <dmasg_stop>
    7560:	f7dff06f          	j	74dc <dma_video_in_channel_execution+0x24>

00007564 <dma_video_in_channel_SG>:



void dma_video_in_channel_SG(u32 * framebuffer, struct dmasg_descriptor* input_descriptor ,u32 channel)
{
    7564:	ff010113          	addi	sp,sp,-16
    7568:	00112623          	sw	ra,12(sp)
    756c:	00812423          	sw	s0,8(sp)
    7570:	00912223          	sw	s1,4(sp)
    7574:	01212023          	sw	s2,0(sp)
    7578:	00050913          	mv	s2,a0
    757c:	00058493          	mv	s1,a1
    7580:	00060413          	mv	s0,a2
	u32 nFrame = 1;

			u32 FramePtr  = (u32) framebuffer;
    7584:	00050593          	mv	a1,a0

			u32 descriptorPtr = 0;


			descriptorPtr = 0;
			for (int i=0; i<nFrame; i++)
    7588:	00000693          	li	a3,0
			descriptorPtr = 0;
    758c:	00000793          	li	a5,0
			for (int i=0; i<nFrame; i++)
    7590:	0c068263          	beqz	a3,7654 <dma_video_in_channel_SG+0xf0>
				input_descriptor[descriptorPtr].status  = 0;
				descriptorPtr ++;
			}


			input_descriptor[descriptorPtr-1].next    =  (u32)(input_descriptor);
    7594:	08000737          	lui	a4,0x8000
    7598:	fff70713          	addi	a4,a4,-1 # 7ffffff <__freertos_irq_stack_top+0x7fac58f>
    759c:	00e787b3          	add	a5,a5,a4
    75a0:	00579793          	slli	a5,a5,0x5
    75a4:	00f487b3          	add	a5,s1,a5
    75a8:	0097ac23          	sw	s1,24(a5)
    75ac:	0007ae23          	sw	zero,28(a5)

if(dmasg_busy(DMASG_BASE, channel))
    75b0:	00040593          	mv	a1,s0
    75b4:	f8130537          	lui	a0,0xf8130
    75b8:	915ff0ef          	jal	ra,6ecc <dmasg_busy>
    75bc:	0e051263          	bnez	a0,76a0 <dma_video_in_channel_SG+0x13c>
{
	bsp_printf("stop dma Ch %x with SG mode \n\r", channel);
	dmasg_stop(DMASG_BASE, channel);

}
while(dmasg_busy(DMASG_BASE, channel));
    75c0:	00040593          	mv	a1,s0
    75c4:	f8130537          	lui	a0,0xf8130
    75c8:	905ff0ef          	jal	ra,6ecc <dmasg_busy>
    75cc:	fe051ae3          	bnez	a0,75c0 <dma_video_in_channel_SG+0x5c>

bsp_printf("stop dma input (SG) \n\r");
    75d0:	00051537          	lui	a0,0x51
    75d4:	59450513          	addi	a0,a0,1428 # 51594 <raw_table+0xe5f8>
    75d8:	93dff0ef          	jal	ra,6f14 <bsp_printf>
dmasg_stop(DMASG_BASE, channel);
    75dc:	00040593          	mv	a1,s0
    75e0:	f8130537          	lui	a0,0xf8130
    75e4:	8bdff0ef          	jal	ra,6ea0 <dmasg_stop>

//dmasg_interrupt_config(DMASG_BASE, channel, 0);  //Disable dmasg channel interrupt

dmasg_stop(DMASG_BASE, channel);
    75e8:	00040593          	mv	a1,s0
    75ec:	f8130537          	lui	a0,0xf8130
    75f0:	8b1ff0ef          	jal	ra,6ea0 <dmasg_stop>
dmasg_output_memory(DMASG_BASE, channel, ((u32)(framebuffer )) , (256));//dmasg_push_memory(DMASG_BASE, 1, ((u32)pucEthernetBuffer), xDataLength);
    75f4:	10000693          	li	a3,256
    75f8:	00090613          	mv	a2,s2
    75fc:	00040593          	mv	a1,s0
    7600:	f8130537          	lui	a0,0xf8130
    7604:	fb0ff0ef          	jal	ra,6db4 <dmasg_output_memory>
dmasg_input_stream(DMASG_BASE, channel, 0, 0, 0); //dmasg_pop_stream(DMASG_BASE, DMASG_CHANNEL1, 0, 0, 0, 1);
    7608:	00000713          	li	a4,0
    760c:	00000693          	li	a3,0
    7610:	00000613          	li	a2,0
    7614:	00040593          	mv	a1,s0
    7618:	f8130537          	lui	a0,0xf8130
    761c:	fc0ff0ef          	jal	ra,6ddc <dmasg_input_stream>
dmasg_linked_list_start(DMASG_BASE, channel,(u32)input_descriptor  );
    7620:	00048613          	mv	a2,s1
    7624:	00040593          	mv	a1,s0
    7628:	f8130537          	lui	a0,0xf8130
    762c:	83dff0ef          	jal	ra,6e68 <dmasg_linked_list_start>

bsp_printf("Start dma input(SG) \n\r");
    7630:	00051537          	lui	a0,0x51
    7634:	5ac50513          	addi	a0,a0,1452 # 515ac <raw_table+0xe610>
    7638:	8ddff0ef          	jal	ra,6f14 <bsp_printf>


}
    763c:	00c12083          	lw	ra,12(sp)
    7640:	00812403          	lw	s0,8(sp)
    7644:	00412483          	lw	s1,4(sp)
    7648:	00012903          	lw	s2,0(sp)
    764c:	01010113          	addi	sp,sp,16
    7650:	00008067          	ret
				input_descriptor[descriptorPtr].control = (u32)((FRAME_SIZE_RX*4)-1)  | 1 << 30 | DMASG_DESCRIPTOR_CONTROL_NO_COMPLETION;
    7654:	00579713          	slli	a4,a5,0x5
    7658:	00e48733          	add	a4,s1,a4
    765c:	c01fa637          	lui	a2,0xc01fa
    7660:	3ff60613          	addi	a2,a2,1023 # c01fa3ff <__freertos_irq_stack_top+0xc01a698f>
    7664:	00c72223          	sw	a2,4(a4)
				input_descriptor[descriptorPtr].from    = 0;
    7668:	00000813          	li	a6,0
    766c:	00000893          	li	a7,0
    7670:	01072423          	sw	a6,8(a4)
    7674:	01172623          	sw	a7,12(a4)
				input_descriptor[descriptorPtr].to      = (u32)(framebuffer);
    7678:	00b72823          	sw	a1,16(a4)
    767c:	00072a23          	sw	zero,20(a4)
				input_descriptor[descriptorPtr].next    =  (u32)(input_descriptor+descriptorPtr+ 1);
    7680:	00178793          	addi	a5,a5,1
    7684:	00579613          	slli	a2,a5,0x5
    7688:	00c48633          	add	a2,s1,a2
    768c:	00c72c23          	sw	a2,24(a4)
    7690:	00072e23          	sw	zero,28(a4)
				input_descriptor[descriptorPtr].status  = 0;
    7694:	00072023          	sw	zero,0(a4)
			for (int i=0; i<nFrame; i++)
    7698:	00168693          	addi	a3,a3,1
    769c:	ef5ff06f          	j	7590 <dma_video_in_channel_SG+0x2c>
	bsp_printf("stop dma Ch %x with SG mode \n\r", channel);
    76a0:	00040593          	mv	a1,s0
    76a4:	00051537          	lui	a0,0x51
    76a8:	57450513          	addi	a0,a0,1396 # 51574 <raw_table+0xe5d8>
    76ac:	869ff0ef          	jal	ra,6f14 <bsp_printf>
	dmasg_stop(DMASG_BASE, channel);
    76b0:	00040593          	mv	a1,s0
    76b4:	f8130537          	lui	a0,0xf8130
    76b8:	fe8ff0ef          	jal	ra,6ea0 <dmasg_stop>
    76bc:	f05ff06f          	j	75c0 <dma_video_in_channel_SG+0x5c>

000076c0 <dma_video_out_channel_SG>:


void dma_video_out_channel_SG(u32 * framebuffer, struct dmasg_descriptor* output_descriptor ,u32 channel )
{
    76c0:	ff010113          	addi	sp,sp,-16
    76c4:	00112623          	sw	ra,12(sp)
    76c8:	00812423          	sw	s0,8(sp)
    76cc:	00912223          	sw	s1,4(sp)
    76d0:	01212023          	sw	s2,0(sp)
    76d4:	00050913          	mv	s2,a0
    76d8:	00058493          	mv	s1,a1
    76dc:	00060413          	mv	s0,a2

	u32 nFrame = 1;
    u32 FramePtr  = (u32) framebuffer;
    76e0:	00050593          	mv	a1,a0

	u32 descriptorPtr = 0;
	for (int i=0; i<nFrame; i++)
    76e4:	00000693          	li	a3,0
	u32 descriptorPtr = 0;
    76e8:	00000793          	li	a5,0
	for (int i=0; i<nFrame; i++)
    76ec:	0c068e63          	beqz	a3,77c8 <dma_video_out_channel_SG+0x108>
		output_descriptor[descriptorPtr].next    =  (u32)(output_descriptor+descriptorPtr+ 1);
		output_descriptor[descriptorPtr].status  = 0;
		descriptorPtr ++;
	}

	output_descriptor[descriptorPtr-1].next    =  (u32)(output_descriptor);
    76f0:	08000737          	lui	a4,0x8000
    76f4:	fff70713          	addi	a4,a4,-1 # 7ffffff <__freertos_irq_stack_top+0x7fac58f>
    76f8:	00e787b3          	add	a5,a5,a4
    76fc:	00579793          	slli	a5,a5,0x5
    7700:	00f487b3          	add	a5,s1,a5
    7704:	0097ac23          	sw	s1,24(a5)
    7708:	0007ae23          	sw	zero,28(a5)


	if(dmasg_busy(DMASG_BASE, channel))
    770c:	00040593          	mv	a1,s0
    7710:	f8130537          	lui	a0,0xf8130
    7714:	fb8ff0ef          	jal	ra,6ecc <dmasg_busy>
    7718:	0e051e63          	bnez	a0,7814 <dma_video_out_channel_SG+0x154>
	{
		bsp_printf("stop dma out(SG) \n\r");
		dmasg_stop(DMASG_BASE, channel);
	}

	while(dmasg_busy(DMASG_BASE, channel));
    771c:	00040593          	mv	a1,s0
    7720:	f8130537          	lui	a0,0xf8130
    7724:	fa8ff0ef          	jal	ra,6ecc <dmasg_busy>
    7728:	fe051ae3          	bnez	a0,771c <dma_video_out_channel_SG+0x5c>


	bsp_printf("stop dma out(SG) \n\r");
    772c:	00051537          	lui	a0,0x51
    7730:	5c450513          	addi	a0,a0,1476 # 515c4 <raw_table+0xe628>
    7734:	fe0ff0ef          	jal	ra,6f14 <bsp_printf>
	dmasg_stop(DMASG_BASE, channel);
    7738:	00040593          	mv	a1,s0
    773c:	f8130537          	lui	a0,0xf8130
    7740:	f60ff0ef          	jal	ra,6ea0 <dmasg_stop>

	dmasg_interrupt_config(DMASG_BASE, channel, 0);  //Disable dmasg channel interrupt
    7744:	00000613          	li	a2,0
    7748:	00040593          	mv	a1,s0
    774c:	f8130537          	lui	a0,0xf8130
    7750:	f64ff0ef          	jal	ra,6eb4 <dmasg_interrupt_config>

	dmasg_stop(DMASG_BASE, channel);
    7754:	00040593          	mv	a1,s0
    7758:	f8130537          	lui	a0,0xf8130
    775c:	f44ff0ef          	jal	ra,6ea0 <dmasg_stop>
	dmasg_input_memory(DMASG_BASE, channel, ((u32)(framebuffer )) , (2048));//dmasg_push_memory(DMASG_BASE, 1, ((u32)pucEthernetBuffer), xDataLength);
    7760:	000016b7          	lui	a3,0x1
    7764:	80068693          	addi	a3,a3,-2048 # 800 <CUSTOM2+0x7a5>
    7768:	00090613          	mv	a2,s2
    776c:	00040593          	mv	a1,s0
    7770:	f8130537          	lui	a0,0xf8130
    7774:	e18ff0ef          	jal	ra,6d8c <dmasg_input_memory>
	dmasg_output_stream(DMASG_BASE, channel, 0, 0, 0, 1); //dmasg_pop_stream(DMASG_BASE, DMASG_CHANNEL1, 0, 0, 0, 1);
    7778:	00100793          	li	a5,1
    777c:	00000713          	li	a4,0
    7780:	00000693          	li	a3,0
    7784:	00000613          	li	a2,0
    7788:	00040593          	mv	a1,s0
    778c:	f8130537          	lui	a0,0xf8130
    7790:	e84ff0ef          	jal	ra,6e14 <dmasg_output_stream>
	dmasg_linked_list_start(DMASG_BASE, channel,(u32)output_descriptor  );
    7794:	00048613          	mv	a2,s1
    7798:	00040593          	mv	a1,s0
    779c:	f8130537          	lui	a0,0xf8130
    77a0:	ec8ff0ef          	jal	ra,6e68 <dmasg_linked_list_start>

	bsp_printf("Start dma out(SG) \n\r");
    77a4:	00051537          	lui	a0,0x51
    77a8:	5d850513          	addi	a0,a0,1496 # 515d8 <raw_table+0xe63c>
    77ac:	f68ff0ef          	jal	ra,6f14 <bsp_printf>


}
    77b0:	00c12083          	lw	ra,12(sp)
    77b4:	00812403          	lw	s0,8(sp)
    77b8:	00412483          	lw	s1,4(sp)
    77bc:	00012903          	lw	s2,0(sp)
    77c0:	01010113          	addi	sp,sp,16
    77c4:	00008067          	ret
		output_descriptor[descriptorPtr].control = (u32)((FRAME_SIZE_HDMI*4)-1)  | 1 << 30 | DMASG_DESCRIPTOR_CONTROL_NO_COMPLETION;
    77c8:	00579713          	slli	a4,a5,0x5
    77cc:	00e48733          	add	a4,s1,a4
    77d0:	c01fa637          	lui	a2,0xc01fa
    77d4:	3ff60613          	addi	a2,a2,1023 # c01fa3ff <__freertos_irq_stack_top+0xc01a698f>
    77d8:	00c72223          	sw	a2,4(a4)
		output_descriptor[descriptorPtr].from    = (u32)(framebuffer);
    77dc:	00b72423          	sw	a1,8(a4)
    77e0:	00072623          	sw	zero,12(a4)
		output_descriptor[descriptorPtr].to      = 0;
    77e4:	00000813          	li	a6,0
    77e8:	00000893          	li	a7,0
    77ec:	01072823          	sw	a6,16(a4)
    77f0:	01172a23          	sw	a7,20(a4)
		output_descriptor[descriptorPtr].next    =  (u32)(output_descriptor+descriptorPtr+ 1);
    77f4:	00178793          	addi	a5,a5,1
    77f8:	00579613          	slli	a2,a5,0x5
    77fc:	00c48633          	add	a2,s1,a2
    7800:	00c72c23          	sw	a2,24(a4)
    7804:	00072e23          	sw	zero,28(a4)
		output_descriptor[descriptorPtr].status  = 0;
    7808:	00072023          	sw	zero,0(a4)
	for (int i=0; i<nFrame; i++)
    780c:	00168693          	addi	a3,a3,1
    7810:	eddff06f          	j	76ec <dma_video_out_channel_SG+0x2c>
		bsp_printf("stop dma out(SG) \n\r");
    7814:	00051537          	lui	a0,0x51
    7818:	5c450513          	addi	a0,a0,1476 # 515c4 <raw_table+0xe628>
    781c:	ef8ff0ef          	jal	ra,6f14 <bsp_printf>
		dmasg_stop(DMASG_BASE, channel);
    7820:	00040593          	mv	a1,s0
    7824:	f8130537          	lui	a0,0xf8130
    7828:	e78ff0ef          	jal	ra,6ea0 <dmasg_stop>
    782c:	ef1ff06f          	j	771c <dma_video_out_channel_SG+0x5c>

00007830 <dma_video_in_stop>:





void dma_video_in_stop() {
    7830:	ff010113          	addi	sp,sp,-16
    7834:	00112623          	sw	ra,12(sp)

	bsp_printf("stop dma Ch 1in \n\r");
    7838:	00051537          	lui	a0,0x51
    783c:	5f050513          	addi	a0,a0,1520 # 515f0 <raw_table+0xe654>
    7840:	ed4ff0ef          	jal	ra,6f14 <bsp_printf>
	dmasg_stop(DMASG_BASE, DMASG_CHANNEL0);
    7844:	00000593          	li	a1,0
    7848:	f8130537          	lui	a0,0xf8130
    784c:	e54ff0ef          	jal	ra,6ea0 <dmasg_stop>
	bsp_printf("stop dma Ch2 in \n\r");
    7850:	00051537          	lui	a0,0x51
    7854:	60450513          	addi	a0,a0,1540 # 51604 <raw_table+0xe668>
    7858:	ebcff0ef          	jal	ra,6f14 <bsp_printf>
	dmasg_stop(DMASG_BASE, DMASG_CHANNEL2);
    785c:	00200593          	li	a1,2
    7860:	f8130537          	lui	a0,0xf8130
    7864:	e3cff0ef          	jal	ra,6ea0 <dmasg_stop>
	//bsp_printf("stop dma Ch2 in \n\r");
	//dmasg_stop(DMASG_BASE, DMASG_CHANNEL4);
	//bsp_printf("stop dma Ch2 in \n\r");
	//dmasg_stop(DMASG_BASE, DMASG_CHANNEL6);

}
    7868:	00c12083          	lw	ra,12(sp)
    786c:	01010113          	addi	sp,sp,16
    7870:	00008067          	ret

00007874 <dma_video_in_channel_stop>:


void dma_video_in_channel_stop( u32 channel) {
    7874:	ff010113          	addi	sp,sp,-16
    7878:	00112623          	sw	ra,12(sp)
    787c:	00812423          	sw	s0,8(sp)
    7880:	00050413          	mv	s0,a0

	bsp_printf("stop dma Ch %x \n\r", channel);
    7884:	00050593          	mv	a1,a0
    7888:	00051537          	lui	a0,0x51
    788c:	61850513          	addi	a0,a0,1560 # 51618 <raw_table+0xe67c>
    7890:	e84ff0ef          	jal	ra,6f14 <bsp_printf>
	dmasg_stop(DMASG_BASE, channel);
    7894:	00040593          	mv	a1,s0
    7898:	f8130537          	lui	a0,0xf8130
    789c:	e04ff0ef          	jal	ra,6ea0 <dmasg_stop>

}
    78a0:	00c12083          	lw	ra,12(sp)
    78a4:	00812403          	lw	s0,8(sp)
    78a8:	01010113          	addi	sp,sp,16
    78ac:	00008067          	ret

000078b0 <dma_video_out_stop>:




void dma_video_out_stop() {
    78b0:	ff010113          	addi	sp,sp,-16
    78b4:	00112623          	sw	ra,12(sp)

	bsp_printf("stop dma Out \n\r");
    78b8:	00051537          	lui	a0,0x51
    78bc:	62c50513          	addi	a0,a0,1580 # 5162c <raw_table+0xe690>
    78c0:	e54ff0ef          	jal	ra,6f14 <bsp_printf>
	dmasg_stop(DMASG_BASE, DMASG_CHANNEL_HDMI);
    78c4:	00400593          	li	a1,4
    78c8:	f8130537          	lui	a0,0xf8130
    78cc:	dd4ff0ef          	jal	ra,6ea0 <dmasg_stop>
	bsp_printf("Start dma out \n\r");
    78d0:	00051537          	lui	a0,0x51
    78d4:	63c50513          	addi	a0,a0,1596 # 5163c <raw_table+0xe6a0>
    78d8:	e3cff0ef          	jal	ra,6f14 <bsp_printf>

}
    78dc:	00c12083          	lw	ra,12(sp)
    78e0:	01010113          	addi	sp,sp,16
    78e4:	00008067          	ret

000078e8 <dma_video_out_channel_stop>:

void dma_video_out_channel_stop( u32 channel) {
    78e8:	ff010113          	addi	sp,sp,-16
    78ec:	00112623          	sw	ra,12(sp)
    78f0:	00812423          	sw	s0,8(sp)
    78f4:	00050413          	mv	s0,a0

	bsp_printf("stop dma Out \n\r");
    78f8:	00051537          	lui	a0,0x51
    78fc:	62c50513          	addi	a0,a0,1580 # 5162c <raw_table+0xe690>
    7900:	e14ff0ef          	jal	ra,6f14 <bsp_printf>
	dmasg_stop(DMASG_BASE, channel);
    7904:	00040593          	mv	a1,s0
    7908:	f8130537          	lui	a0,0xf8130
    790c:	d94ff0ef          	jal	ra,6ea0 <dmasg_stop>
	bsp_printf("Start dma out \n\r");
    7910:	00051537          	lui	a0,0x51
    7914:	63c50513          	addi	a0,a0,1596 # 5163c <raw_table+0xe6a0>
    7918:	dfcff0ef          	jal	ra,6f14 <bsp_printf>

}
    791c:	00c12083          	lw	ra,12(sp)
    7920:	00812403          	lw	s0,8(sp)
    7924:	01010113          	addi	sp,sp,16
    7928:	00008067          	ret

0000792c <dma_video_in_channel_cs_sg_execution>:


void dma_video_in_channel_cs_sg_execution(struct cs_sg_descriptor* cs_descriptor, u32 nCSDescriptor, u32 channel)
{
    792c:	fe010113          	addi	sp,sp,-32
    7930:	00112e23          	sw	ra,28(sp)
    7934:	00812c23          	sw	s0,24(sp)
    7938:	00912a23          	sw	s1,20(sp)
    793c:	01212823          	sw	s2,16(sp)
    7940:	01312623          	sw	s3,12(sp)
    7944:	00050913          	mv	s2,a0
    7948:	00058493          	mv	s1,a1
    794c:	00060993          	mv	s3,a2

	u32 CS_SG_REGS_ADDR = (channel * 4 * 4)  *4;
    7950:	00661413          	slli	s0,a2,0x6

		bsp_printf("stop dma input \n\r");
    7954:	00051537          	lui	a0,0x51
    7958:	65050513          	addi	a0,a0,1616 # 51650 <raw_table+0xe6b4>
    795c:	db8ff0ef          	jal	ra,6f14 <bsp_printf>

		bsp_printf("Custom SG mode Input init! \n\r");
    7960:	00051537          	lui	a0,0x51
    7964:	66450513          	addi	a0,a0,1636 # 51664 <raw_table+0xe6c8>
    7968:	dacff0ef          	jal	ra,6f14 <bsp_printf>


		for(int i=0; i<nCSDescriptor; i++)
    796c:	00000693          	li	a3,0
    7970:	0496fc63          	bgeu	a3,s1,79c8 <dma_video_in_channel_cs_sg_execution+0x9c>
		{


			APB3_REGW(CS_SG_APB_SLV, CS_SG_REGS_ADDR, cs_descriptor[i].ctrl_word);
    7974:	00469713          	slli	a4,a3,0x4
    7978:	00e90733          	add	a4,s2,a4
    797c:	00072583          	lw	a1,0(a4)
    7980:	f81407b7          	lui	a5,0xf8140
    7984:	00f40633          	add	a2,s0,a5
    7988:	00b62023          	sw	a1,0(a2)
			CS_SG_REGS_ADDR +=4;

			APB3_REGW(CS_SG_APB_SLV, CS_SG_REGS_ADDR, cs_descriptor[i].src_addr);
    798c:	00472583          	lw	a1,4(a4)
    7990:	00478613          	addi	a2,a5,4 # f8140004 <__freertos_irq_stack_top+0xf80ec594>
    7994:	00c40633          	add	a2,s0,a2
    7998:	00b62023          	sw	a1,0(a2)
			CS_SG_REGS_ADDR +=4;

			APB3_REGW(CS_SG_APB_SLV, CS_SG_REGS_ADDR, cs_descriptor[i].dst_addr);
    799c:	00872583          	lw	a1,8(a4)
    79a0:	00878613          	addi	a2,a5,8
    79a4:	00c40633          	add	a2,s0,a2
    79a8:	00b62023          	sw	a1,0(a2)
			CS_SG_REGS_ADDR +=4;

			APB3_REGW(CS_SG_APB_SLV, CS_SG_REGS_ADDR, cs_descriptor[i].nBytes);
    79ac:	00c72703          	lw	a4,12(a4)
    79b0:	00c78793          	addi	a5,a5,12
    79b4:	00f407b3          	add	a5,s0,a5
    79b8:	00e7a023          	sw	a4,0(a5)
			CS_SG_REGS_ADDR +=4;
    79bc:	01040413          	addi	s0,s0,16
		for(int i=0; i<nCSDescriptor; i++)
    79c0:	00168693          	addi	a3,a3,1
    79c4:	fadff06f          	j	7970 <dma_video_in_channel_cs_sg_execution+0x44>

		}
		bsp_printf("Initial CS Register \n\r");
    79c8:	00051537          	lui	a0,0x51
    79cc:	68450513          	addi	a0,a0,1668 # 51684 <raw_table+0xe6e8>
    79d0:	d44ff0ef          	jal	ra,6f14 <bsp_printf>

	if(dmasg_busy(DMASG_BASE, channel))
    79d4:	00098593          	mv	a1,s3
    79d8:	f8130537          	lui	a0,0xf8130
    79dc:	cf0ff0ef          	jal	ra,6ecc <dmasg_busy>
    79e0:	06051a63          	bnez	a0,7a54 <dma_video_in_channel_cs_sg_execution+0x128>
	{
		bsp_printf("stop dma Ch %x \n\r with SG MODE", channel);
		dmasg_stop(DMASG_BASE, channel);

	}
	bsp_printf("Start dma Ch %x \n\r with CS SG Mode", channel);
    79e4:	00098593          	mv	a1,s3
    79e8:	00051537          	lui	a0,0x51
    79ec:	69c50513          	addi	a0,a0,1692 # 5169c <raw_table+0xe700>
    79f0:	d24ff0ef          	jal	ra,6f14 <bsp_printf>
	dmasg_output_memory(DMASG_BASE,channel, 0, 256); // dmasg_pop_memory (DMASG_BASE, DMASG_CHANNEL0, (u32)pucEthernetBuffer, 64);
    79f4:	10000693          	li	a3,256
    79f8:	00000613          	li	a2,0
    79fc:	00098593          	mv	a1,s3
    7a00:	f8130537          	lui	a0,0xf8130
    7a04:	bb0ff0ef          	jal	ra,6db4 <dmasg_output_memory>
	dmasg_input_stream(DMASG_BASE, channel, 0, 1, 0); 				  // dmasg_push_stream(DMASG_BASE, DMASG_CHANNEL0, 0, 0, 0);
    7a08:	00000713          	li	a4,0
    7a0c:	00100693          	li	a3,1
    7a10:	00000613          	li	a2,0
    7a14:	00098593          	mv	a1,s3
    7a18:	f8130537          	lui	a0,0xf8130
    7a1c:	bc0ff0ef          	jal	ra,6ddc <dmasg_input_stream>

	dmasg_linked_list_sg_start(DMASG_BASE, channel);
    7a20:	00098593          	mv	a1,s3
    7a24:	f8130537          	lui	a0,0xf8130
    7a28:	c5cff0ef          	jal	ra,6e84 <dmasg_linked_list_sg_start>
	bsp_printf("Start dma input with cs cg\n\r");
    7a2c:	00051537          	lui	a0,0x51
    7a30:	6c050513          	addi	a0,a0,1728 # 516c0 <raw_table+0xe724>
    7a34:	ce0ff0ef          	jal	ra,6f14 <bsp_printf>

}
    7a38:	01c12083          	lw	ra,28(sp)
    7a3c:	01812403          	lw	s0,24(sp)
    7a40:	01412483          	lw	s1,20(sp)
    7a44:	01012903          	lw	s2,16(sp)
    7a48:	00c12983          	lw	s3,12(sp)
    7a4c:	02010113          	addi	sp,sp,32
    7a50:	00008067          	ret
		bsp_printf("stop dma Ch %x \n\r with SG MODE", channel);
    7a54:	00098593          	mv	a1,s3
    7a58:	00051537          	lui	a0,0x51
    7a5c:	53450513          	addi	a0,a0,1332 # 51534 <raw_table+0xe598>
    7a60:	cb4ff0ef          	jal	ra,6f14 <bsp_printf>
		dmasg_stop(DMASG_BASE, channel);
    7a64:	00098593          	mv	a1,s3
    7a68:	f8130537          	lui	a0,0xf8130
    7a6c:	c34ff0ef          	jal	ra,6ea0 <dmasg_stop>
    7a70:	f75ff06f          	j	79e4 <dma_video_in_channel_cs_sg_execution+0xb8>

00007a74 <dma_video_out_channel_cs_sg_execution>:


void dma_video_out_channel_cs_sg_execution(struct cs_sg_descriptor* cs_descriptor, u32 nCSDescriptor, u32 channel)
{
    7a74:	fe010113          	addi	sp,sp,-32
    7a78:	00112e23          	sw	ra,28(sp)
    7a7c:	00812c23          	sw	s0,24(sp)
    7a80:	00912a23          	sw	s1,20(sp)
    7a84:	01212823          	sw	s2,16(sp)
    7a88:	01312623          	sw	s3,12(sp)
    7a8c:	00050913          	mv	s2,a0
    7a90:	00058493          	mv	s1,a1
    7a94:	00060993          	mv	s3,a2

	u32 CS_SG_REGS_ADDR = (channel * 4 * 4)  *4;
    7a98:	00661413          	slli	s0,a2,0x6

	bsp_printf("stop dma out \n\r");
    7a9c:	00051537          	lui	a0,0x51
    7aa0:	6e050513          	addi	a0,a0,1760 # 516e0 <raw_table+0xe744>
    7aa4:	c70ff0ef          	jal	ra,6f14 <bsp_printf>

	bsp_printf("Custom SG mode output init \n\r");
    7aa8:	00051537          	lui	a0,0x51
    7aac:	6f050513          	addi	a0,a0,1776 # 516f0 <raw_table+0xe754>
    7ab0:	c64ff0ef          	jal	ra,6f14 <bsp_printf>


	for(int i=0; i<nCSDescriptor; i++)
    7ab4:	00000693          	li	a3,0
    7ab8:	0496fc63          	bgeu	a3,s1,7b10 <dma_video_out_channel_cs_sg_execution+0x9c>
	{


		APB3_REGW(CS_SG_APB_SLV, CS_SG_REGS_ADDR, cs_descriptor[i].ctrl_word);
    7abc:	00469713          	slli	a4,a3,0x4
    7ac0:	00e90733          	add	a4,s2,a4
    7ac4:	00072583          	lw	a1,0(a4)
    7ac8:	f81407b7          	lui	a5,0xf8140
    7acc:	00f40633          	add	a2,s0,a5
    7ad0:	00b62023          	sw	a1,0(a2)
		CS_SG_REGS_ADDR +=4;

		APB3_REGW(CS_SG_APB_SLV, CS_SG_REGS_ADDR, cs_descriptor[i].src_addr);
    7ad4:	00472583          	lw	a1,4(a4)
    7ad8:	00478613          	addi	a2,a5,4 # f8140004 <__freertos_irq_stack_top+0xf80ec594>
    7adc:	00c40633          	add	a2,s0,a2
    7ae0:	00b62023          	sw	a1,0(a2)
		CS_SG_REGS_ADDR +=4;

		APB3_REGW(CS_SG_APB_SLV, CS_SG_REGS_ADDR, cs_descriptor[i].dst_addr);
    7ae4:	00872583          	lw	a1,8(a4)
    7ae8:	00878613          	addi	a2,a5,8
    7aec:	00c40633          	add	a2,s0,a2
    7af0:	00b62023          	sw	a1,0(a2)
		CS_SG_REGS_ADDR +=4;

		APB3_REGW(CS_SG_APB_SLV, CS_SG_REGS_ADDR, cs_descriptor[i].nBytes);
    7af4:	00c72703          	lw	a4,12(a4)
    7af8:	00c78793          	addi	a5,a5,12
    7afc:	00f407b3          	add	a5,s0,a5
    7b00:	00e7a023          	sw	a4,0(a5)
		CS_SG_REGS_ADDR +=4;
    7b04:	01040413          	addi	s0,s0,16
	for(int i=0; i<nCSDescriptor; i++)
    7b08:	00168693          	addi	a3,a3,1
    7b0c:	fadff06f          	j	7ab8 <dma_video_out_channel_cs_sg_execution+0x44>

	}
	bsp_printf("Initial CS Register \n\r");
    7b10:	00051537          	lui	a0,0x51
    7b14:	68450513          	addi	a0,a0,1668 # 51684 <raw_table+0xe6e8>
    7b18:	bfcff0ef          	jal	ra,6f14 <bsp_printf>


	bsp_printf("stop dma out \n\r");
    7b1c:	00051537          	lui	a0,0x51
    7b20:	6e050513          	addi	a0,a0,1760 # 516e0 <raw_table+0xe744>
    7b24:	bf0ff0ef          	jal	ra,6f14 <bsp_printf>
	dmasg_stop(DMASG_BASE, channel);
    7b28:	00098593          	mv	a1,s3
    7b2c:	f8130537          	lui	a0,0xf8130
    7b30:	b70ff0ef          	jal	ra,6ea0 <dmasg_stop>

	dmasg_interrupt_config(DMASG_BASE, channel, 0);  //Disable dmasg channel interrupt
    7b34:	00000613          	li	a2,0
    7b38:	00098593          	mv	a1,s3
    7b3c:	f8130537          	lui	a0,0xf8130
    7b40:	b74ff0ef          	jal	ra,6eb4 <dmasg_interrupt_config>

    dmasg_input_memory(DMASG_BASE, channel, 0 , 2048);
    7b44:	000016b7          	lui	a3,0x1
    7b48:	80068693          	addi	a3,a3,-2048 # 800 <CUSTOM2+0x7a5>
    7b4c:	00000613          	li	a2,0
    7b50:	00098593          	mv	a1,s3
    7b54:	f8130537          	lui	a0,0xf8130
    7b58:	a34ff0ef          	jal	ra,6d8c <dmasg_input_memory>
	dmasg_output_stream(DMASG_BASE, channel, 0, 0, 0, 1);
    7b5c:	00100793          	li	a5,1
    7b60:	00000713          	li	a4,0
    7b64:	00000693          	li	a3,0
    7b68:	00000613          	li	a2,0
    7b6c:	00098593          	mv	a1,s3
    7b70:	f8130537          	lui	a0,0xf8130
    7b74:	aa0ff0ef          	jal	ra,6e14 <dmasg_output_stream>

	dmasg_linked_list_sg_start(DMASG_BASE, channel);
    7b78:	00098593          	mv	a1,s3
    7b7c:	f8130537          	lui	a0,0xf8130
    7b80:	b04ff0ef          	jal	ra,6e84 <dmasg_linked_list_sg_start>
	bsp_printf("Start dma out with cs cg\n\r");
    7b84:	00051537          	lui	a0,0x51
    7b88:	71050513          	addi	a0,a0,1808 # 51710 <raw_table+0xe774>
    7b8c:	b88ff0ef          	jal	ra,6f14 <bsp_printf>

}
    7b90:	01c12083          	lw	ra,28(sp)
    7b94:	01812403          	lw	s0,24(sp)
    7b98:	01412483          	lw	s1,20(sp)
    7b9c:	01012903          	lw	s2,16(sp)
    7ba0:	00c12983          	lw	s3,12(sp)
    7ba4:	02010113          	addi	sp,sp,32
    7ba8:	00008067          	ret

00007bac <dma_video_out_channel_execution>:



void dma_video_out_channel_execution(u32 *framebuffer, u32 channel)
{
    7bac:	ff010113          	addi	sp,sp,-16
    7bb0:	00112623          	sw	ra,12(sp)
    7bb4:	00812423          	sw	s0,8(sp)
    7bb8:	00912223          	sw	s1,4(sp)
    7bbc:	00050493          	mv	s1,a0
    7bc0:	00058413          	mv	s0,a1

	bsp_printf("stop dma out \n\r");
    7bc4:	00051537          	lui	a0,0x51
    7bc8:	6e050513          	addi	a0,a0,1760 # 516e0 <raw_table+0xe744>
    7bcc:	b48ff0ef          	jal	ra,6f14 <bsp_printf>
	dmasg_stop(DMASG_BASE, channel);
    7bd0:	00040593          	mv	a1,s0
    7bd4:	f8130537          	lui	a0,0xf8130
    7bd8:	ac8ff0ef          	jal	ra,6ea0 <dmasg_stop>

	dmasg_interrupt_config(DMASG_BASE, channel, 0);  //Disable dmasg channel interrupt
    7bdc:	00000613          	li	a2,0
    7be0:	00040593          	mv	a1,s0
    7be4:	f8130537          	lui	a0,0xf8130
    7be8:	accff0ef          	jal	ra,6eb4 <dmasg_interrupt_config>

    dmasg_input_memory(DMASG_BASE, channel, ((u32)(framebuffer )) , (2048));//dmasg_push_memory(DMASG_BASE, 1, ((u32)pucEthernetBuffer), xDataLength);
    7bec:	000016b7          	lui	a3,0x1
    7bf0:	80068693          	addi	a3,a3,-2048 # 800 <CUSTOM2+0x7a5>
    7bf4:	00048613          	mv	a2,s1
    7bf8:	00040593          	mv	a1,s0
    7bfc:	f8130537          	lui	a0,0xf8130
    7c00:	98cff0ef          	jal	ra,6d8c <dmasg_input_memory>
	dmasg_output_stream(DMASG_BASE, channel, 0, 0, 0, 1); //dmasg_pop_stream(DMASG_BASE, DMASG_CHANNEL1, 0, 0, 0, 1);
    7c04:	00100793          	li	a5,1
    7c08:	00000713          	li	a4,0
    7c0c:	00000693          	li	a3,0
    7c10:	00000613          	li	a2,0
    7c14:	00040593          	mv	a1,s0
    7c18:	f8130537          	lui	a0,0xf8130
    7c1c:	9f8ff0ef          	jal	ra,6e14 <dmasg_output_stream>

	dmasg_direct_start(DMASG_BASE, channel,((u32)(FRAME_SIZE_HDMI*4)), 1);//  dmasg_start(DMASG_BASE, DMASG_CHANNEL1, xDataLength, 0);
    7c20:	00100693          	li	a3,1
    7c24:	001fa637          	lui	a2,0x1fa
    7c28:	40060613          	addi	a2,a2,1024 # 1fa400 <__freertos_irq_stack_top+0x1a6990>
    7c2c:	00040593          	mv	a1,s0
    7c30:	f8130537          	lui	a0,0xf8130
    7c34:	a0cff0ef          	jal	ra,6e40 <dmasg_direct_start>
	bsp_printf("Start dma out \n\r");
    7c38:	00051537          	lui	a0,0x51
    7c3c:	63c50513          	addi	a0,a0,1596 # 5163c <raw_table+0xe6a0>
    7c40:	ad4ff0ef          	jal	ra,6f14 <bsp_printf>

}
    7c44:	00c12083          	lw	ra,12(sp)
    7c48:	00812403          	lw	s0,8(sp)
    7c4c:	00412483          	lw	s1,4(sp)
    7c50:	01010113          	addi	sp,sp,16
    7c54:	00008067          	ret

00007c58 <dma_video_out_execution>:


void dma_video_out_execution(u32 *framebuffer , u32 *framebuffer2 ) {
    7c58:	ff010113          	addi	sp,sp,-16
    7c5c:	00112623          	sw	ra,12(sp)
    7c60:	00812423          	sw	s0,8(sp)
    7c64:	00050413          	mv	s0,a0



	bsp_printf("stop dma out \n\r");
    7c68:	00051537          	lui	a0,0x51
    7c6c:	6e050513          	addi	a0,a0,1760 # 516e0 <raw_table+0xe744>
    7c70:	aa4ff0ef          	jal	ra,6f14 <bsp_printf>
	dmasg_stop(DMASG_BASE, DMASG_CHANNEL_HDMI);
    7c74:	00400593          	li	a1,4
    7c78:	f8130537          	lui	a0,0xf8130
    7c7c:	a24ff0ef          	jal	ra,6ea0 <dmasg_stop>

	dmasg_interrupt_config(DMASG_BASE, DMASG_CHANNEL_HDMI, 0);  //Disable dmasg channel interrupt
    7c80:	00000613          	li	a2,0
    7c84:	00400593          	li	a1,4
    7c88:	f8130537          	lui	a0,0xf8130
    7c8c:	a28ff0ef          	jal	ra,6eb4 <dmasg_interrupt_config>

    dmasg_input_memory(DMASG_BASE, DMASG_CHANNEL_HDMI, ((u32)(framebuffer )) , (256));//dmasg_push_memory(DMASG_BASE, 1, ((u32)pucEthernetBuffer), xDataLength);
    7c90:	10000693          	li	a3,256
    7c94:	00040613          	mv	a2,s0
    7c98:	00400593          	li	a1,4
    7c9c:	f8130537          	lui	a0,0xf8130
    7ca0:	8ecff0ef          	jal	ra,6d8c <dmasg_input_memory>
	dmasg_output_stream(DMASG_BASE, DMASG_CHANNEL_HDMI, 0, 0, 0, 1); //dmasg_pop_stream(DMASG_BASE, DMASG_CHANNEL1, 0, 0, 0, 1);
    7ca4:	00100793          	li	a5,1
    7ca8:	00000713          	li	a4,0
    7cac:	00000693          	li	a3,0
    7cb0:	00000613          	li	a2,0
    7cb4:	00400593          	li	a1,4
    7cb8:	f8130537          	lui	a0,0xf8130
    7cbc:	958ff0ef          	jal	ra,6e14 <dmasg_output_stream>

	dmasg_direct_start(DMASG_BASE, DMASG_CHANNEL_HDMI,((u32)(FRAME_SIZE_HDMI*4)), 1);//  dmasg_start(DMASG_BASE, DMASG_CHANNEL1, xDataLength, 0);
    7cc0:	00100693          	li	a3,1
    7cc4:	001fa637          	lui	a2,0x1fa
    7cc8:	40060613          	addi	a2,a2,1024 # 1fa400 <__freertos_irq_stack_top+0x1a6990>
    7ccc:	00400593          	li	a1,4
    7cd0:	f8130537          	lui	a0,0xf8130
    7cd4:	96cff0ef          	jal	ra,6e40 <dmasg_direct_start>
	bsp_printf("Start dma out \n\r");
    7cd8:	00051537          	lui	a0,0x51
    7cdc:	63c50513          	addi	a0,a0,1596 # 5163c <raw_table+0xe6a0>
    7ce0:	a34ff0ef          	jal	ra,6f14 <bsp_printf>

}
    7ce4:	00c12083          	lw	ra,12(sp)
    7ce8:	00812403          	lw	s0,8(sp)
    7cec:	01010113          	addi	sp,sp,16
    7cf0:	00008067          	ret

00007cf4 <dma_video_out_split2_frame>:


void dma_video_out_split2_frame(u32 * framebuffer1, u32 *framebuffer2,  struct dmasg_descriptor* out_descriptor )
{
    7cf4:	fe010113          	addi	sp,sp,-32
    7cf8:	00112e23          	sw	ra,28(sp)
    7cfc:	00812c23          	sw	s0,24(sp)
    7d00:	00912a23          	sw	s1,20(sp)
    7d04:	00050493          	mv	s1,a0
    7d08:	00060413          	mv	s0,a2
		u32 nDescriptor = FRAME_Y_HDMI * splitX;


		int start_X[2] = {   FRAME_X_RX *1/4, FRAME_X_RX *1/4};
		int start_Y[2] = {   0, 			  0};
		int IndexPtr[4] = {0,0,0,0};
    7d0c:	00012023          	sw	zero,0(sp)
    7d10:	00012223          	sw	zero,4(sp)


		descriptorPtr = 0;
		for (int i=0; i<nDescriptor; i++)
    7d14:	00000613          	li	a2,0
		descriptorPtr = 0;
    7d18:	00000693          	li	a3,0
		for (int i=0; i<nDescriptor; i++)
    7d1c:	0700006f          	j	7d8c <dma_video_out_split2_frame+0x98>
					IndexPtr[0]++;
				}
				else
				{
					//Right
					out_descriptor[descriptorPtr].control = (u32)((FRAME_X_HDMI/splitX)-1)  | 1 << 30 | DMASG_DESCRIPTOR_CONTROL_NO_COMPLETION;
    7d20:	00569793          	slli	a5,a3,0x5
    7d24:	00f407b3          	add	a5,s0,a5
    7d28:	c0000737          	lui	a4,0xc0000
    7d2c:	3bf70713          	addi	a4,a4,959 # c00003bf <__freertos_irq_stack_top+0xbffac94f>
    7d30:	00e7a223          	sw	a4,4(a5)
					out_descriptor[descriptorPtr].from    = (u32)(&framebuffer2[ (start_Y[1] +IndexPtr[1])*(FRAME_X_RX/4)  + start_X[1]/4 ]);
    7d34:	00412503          	lw	a0,4(sp)
    7d38:	00451813          	slli	a6,a0,0x4
    7d3c:	40a80833          	sub	a6,a6,a0
    7d40:	00581713          	slli	a4,a6,0x5
    7d44:	07870713          	addi	a4,a4,120
    7d48:	00271713          	slli	a4,a4,0x2
    7d4c:	00e58733          	add	a4,a1,a4
    7d50:	00e7a423          	sw	a4,8(a5)
    7d54:	0007a623          	sw	zero,12(a5)
					out_descriptor[descriptorPtr].to      = 0;
    7d58:	00000813          	li	a6,0
    7d5c:	00000893          	li	a7,0
    7d60:	0107a823          	sw	a6,16(a5)
    7d64:	0117aa23          	sw	a7,20(a5)
					out_descriptor[descriptorPtr].next    =  (u32)(out_descriptor+descriptorPtr+ 1);
    7d68:	00168693          	addi	a3,a3,1
    7d6c:	00569713          	slli	a4,a3,0x5
    7d70:	00e40733          	add	a4,s0,a4
    7d74:	00e7ac23          	sw	a4,24(a5)
    7d78:	0007ae23          	sw	zero,28(a5)
					out_descriptor[descriptorPtr].status  = 0;
    7d7c:	0007a023          	sw	zero,0(a5)
					descriptorPtr ++;
					IndexPtr[1]++;
    7d80:	00150513          	addi	a0,a0,1
    7d84:	00a12223          	sw	a0,4(sp)
		for (int i=0; i<nDescriptor; i++)
    7d88:	00160613          	addi	a2,a2,1
    7d8c:	000017b7          	lui	a5,0x1
    7d90:	86f78793          	addi	a5,a5,-1937 # 86f <CUSTOM2+0x814>
    7d94:	06c7ec63          	bltu	a5,a2,7e0c <dma_video_out_split2_frame+0x118>
				if((i%2) == 0){
    7d98:	00167793          	andi	a5,a2,1
    7d9c:	f80792e3          	bnez	a5,7d20 <dma_video_out_split2_frame+0x2c>
					out_descriptor[descriptorPtr].control = (u32)((FRAME_X_HDMI/splitX)-1)  | 1 << 30 | DMASG_DESCRIPTOR_CONTROL_NO_COMPLETION;
    7da0:	00569793          	slli	a5,a3,0x5
    7da4:	00f407b3          	add	a5,s0,a5
    7da8:	c0000737          	lui	a4,0xc0000
    7dac:	3bf70713          	addi	a4,a4,959 # c00003bf <__freertos_irq_stack_top+0xbffac94f>
    7db0:	00e7a223          	sw	a4,4(a5)
					out_descriptor[descriptorPtr].from    = (u32)(&framebuffer1[ (start_Y[0] +IndexPtr[0])*(FRAME_X_RX/4)  + start_X[0]/4 ]);
    7db4:	00012503          	lw	a0,0(sp)
    7db8:	00451813          	slli	a6,a0,0x4
    7dbc:	40a80833          	sub	a6,a6,a0
    7dc0:	00581713          	slli	a4,a6,0x5
    7dc4:	07870713          	addi	a4,a4,120
    7dc8:	00271713          	slli	a4,a4,0x2
    7dcc:	00e48733          	add	a4,s1,a4
    7dd0:	00e7a423          	sw	a4,8(a5)
    7dd4:	0007a623          	sw	zero,12(a5)
					out_descriptor[descriptorPtr].to      = 0;
    7dd8:	00000813          	li	a6,0
    7ddc:	00000893          	li	a7,0
    7de0:	0107a823          	sw	a6,16(a5)
    7de4:	0117aa23          	sw	a7,20(a5)
					out_descriptor[descriptorPtr].next    =  (u32)(out_descriptor+descriptorPtr+ 1);
    7de8:	00168693          	addi	a3,a3,1
    7dec:	00569713          	slli	a4,a3,0x5
    7df0:	00e40733          	add	a4,s0,a4
    7df4:	00e7ac23          	sw	a4,24(a5)
    7df8:	0007ae23          	sw	zero,28(a5)
					out_descriptor[descriptorPtr].status  = 0;
    7dfc:	0007a023          	sw	zero,0(a5)
					IndexPtr[0]++;
    7e00:	00150513          	addi	a0,a0,1
    7e04:	00a12023          	sw	a0,0(sp)
    7e08:	f81ff06f          	j	7d88 <dma_video_out_split2_frame+0x94>
			}

		}


		out_descriptor[descriptorPtr-1].next    =  (u32)(out_descriptor);
    7e0c:	080007b7          	lui	a5,0x8000
    7e10:	fff78793          	addi	a5,a5,-1 # 7ffffff <__freertos_irq_stack_top+0x7fac58f>
    7e14:	00f687b3          	add	a5,a3,a5
    7e18:	00579793          	slli	a5,a5,0x5
    7e1c:	00f407b3          	add	a5,s0,a5
    7e20:	0087ac23          	sw	s0,24(a5)
    7e24:	0007ae23          	sw	zero,28(a5)



		if(dmasg_busy(DMASG_BASE, DMASG_CHANNEL_HDMI))
    7e28:	00400593          	li	a1,4
    7e2c:	f8130537          	lui	a0,0xf8130
    7e30:	89cff0ef          	jal	ra,6ecc <dmasg_busy>
    7e34:	0a051463          	bnez	a0,7edc <dma_video_out_split2_frame+0x1e8>
		{
			bsp_printf("stop dma out \n\r");
			dmasg_stop(DMASG_BASE, DMASG_CHANNEL_HDMI);
		}
		while(dmasg_busy(DMASG_BASE, DMASG_CHANNEL_HDMI));
    7e38:	00400593          	li	a1,4
    7e3c:	f8130537          	lui	a0,0xf8130
    7e40:	88cff0ef          	jal	ra,6ecc <dmasg_busy>
    7e44:	fe051ae3          	bnez	a0,7e38 <dma_video_out_split2_frame+0x144>


		bsp_printf("stop dma out \n\r");
    7e48:	00051537          	lui	a0,0x51
    7e4c:	6e050513          	addi	a0,a0,1760 # 516e0 <raw_table+0xe744>
    7e50:	8c4ff0ef          	jal	ra,6f14 <bsp_printf>
		dmasg_stop(DMASG_BASE, DMASG_CHANNEL_HDMI);
    7e54:	00400593          	li	a1,4
    7e58:	f8130537          	lui	a0,0xf8130
    7e5c:	844ff0ef          	jal	ra,6ea0 <dmasg_stop>

		dmasg_interrupt_config(DMASG_BASE, DMASG_CHANNEL_HDMI, 0);  //Disable dmasg channel interrupt
    7e60:	00000613          	li	a2,0
    7e64:	00400593          	li	a1,4
    7e68:	f8130537          	lui	a0,0xf8130
    7e6c:	848ff0ef          	jal	ra,6eb4 <dmasg_interrupt_config>

		dmasg_stop(DMASG_BASE, DMASG_CHANNEL_HDMI);
    7e70:	00400593          	li	a1,4
    7e74:	f8130537          	lui	a0,0xf8130
    7e78:	828ff0ef          	jal	ra,6ea0 <dmasg_stop>
		dmasg_input_memory(DMASG_BASE, DMASG_CHANNEL_HDMI, ((u32)(framebuffer1 )) , (512));//dmasg_push_memory(DMASG_BASE, 1, ((u32)pucEthernetBuffer), xDataLength);
    7e7c:	20000693          	li	a3,512
    7e80:	00048613          	mv	a2,s1
    7e84:	00400593          	li	a1,4
    7e88:	f8130537          	lui	a0,0xf8130
    7e8c:	f01fe0ef          	jal	ra,6d8c <dmasg_input_memory>
		dmasg_output_stream(DMASG_BASE, DMASG_CHANNEL_HDMI, 0, 0, 0, 1); //dmasg_pop_stream(DMASG_BASE, DMASG_CHANNEL1, 0, 0, 0, 1);
    7e90:	00100793          	li	a5,1
    7e94:	00000713          	li	a4,0
    7e98:	00000693          	li	a3,0
    7e9c:	00000613          	li	a2,0
    7ea0:	00400593          	li	a1,4
    7ea4:	f8130537          	lui	a0,0xf8130
    7ea8:	f6dfe0ef          	jal	ra,6e14 <dmasg_output_stream>
		dmasg_linked_list_start(DMASG_BASE, DMASG_CHANNEL_HDMI,(u32)out_descriptor  );
    7eac:	00040613          	mv	a2,s0
    7eb0:	00400593          	li	a1,4
    7eb4:	f8130537          	lui	a0,0xf8130
    7eb8:	fb1fe0ef          	jal	ra,6e68 <dmasg_linked_list_start>

		bsp_printf("Start dma out \n\r");
    7ebc:	00051537          	lui	a0,0x51
    7ec0:	63c50513          	addi	a0,a0,1596 # 5163c <raw_table+0xe6a0>
    7ec4:	850ff0ef          	jal	ra,6f14 <bsp_printf>

}
    7ec8:	01c12083          	lw	ra,28(sp)
    7ecc:	01812403          	lw	s0,24(sp)
    7ed0:	01412483          	lw	s1,20(sp)
    7ed4:	02010113          	addi	sp,sp,32
    7ed8:	00008067          	ret
			bsp_printf("stop dma out \n\r");
    7edc:	00051537          	lui	a0,0x51
    7ee0:	6e050513          	addi	a0,a0,1760 # 516e0 <raw_table+0xe744>
    7ee4:	830ff0ef          	jal	ra,6f14 <bsp_printf>
			dmasg_stop(DMASG_BASE, DMASG_CHANNEL_HDMI);
    7ee8:	00400593          	li	a1,4
    7eec:	f8130537          	lui	a0,0xf8130
    7ef0:	fb1fe0ef          	jal	ra,6ea0 <dmasg_stop>
    7ef4:	f45ff06f          	j	7e38 <dma_video_out_split2_frame+0x144>

00007ef8 <dma_video_out_split4_frame>:


void dma_video_out_split4_frame(u32 * framebuffer1, u32 *framebuffer2, u32 *framebuffer3, u32 *framebuffer4, struct dmasg_descriptor* out_descriptor )
{
    7ef8:	fc010113          	addi	sp,sp,-64
    7efc:	02112e23          	sw	ra,60(sp)
    7f00:	02812c23          	sw	s0,56(sp)
    7f04:	02912a23          	sw	s1,52(sp)
    7f08:	00050493          	mv	s1,a0
    7f0c:	00070413          	mv	s0,a4
		u32 descriptorPtr = 0;

		u32 nDescriptor = FRAME_Y_HDMI * splitX;


		int start_X[4] = {   FRAME_X_RX *1/4, FRAME_X_RX *1/4, FRAME_X_RX *1/4, FRAME_X_RX *1/4 };
    7f10:	000097b7          	lui	a5,0x9
    7f14:	51c78793          	addi	a5,a5,1308 # 951c <imx477_mode_1920x1080_60fps+0x1ec>
    7f18:	4007a883          	lw	a7,1024(a5)
    7f1c:	4047a803          	lw	a6,1028(a5)
    7f20:	4087a503          	lw	a0,1032(a5)
    7f24:	40c7a703          	lw	a4,1036(a5)
    7f28:	03112023          	sw	a7,32(sp)
    7f2c:	03012223          	sw	a6,36(sp)
    7f30:	02a12423          	sw	a0,40(sp)
    7f34:	02e12623          	sw	a4,44(sp)
		int start_Y[4] = {   FRAME_Y_RX *1/4, FRAME_Y_RX *1/4, FRAME_Y_RX *1/4, FRAME_Y_RX *1/4 };
    7f38:	4107a803          	lw	a6,1040(a5)
    7f3c:	4147a503          	lw	a0,1044(a5)
    7f40:	4187a703          	lw	a4,1048(a5)
    7f44:	41c7a783          	lw	a5,1052(a5)
    7f48:	01012823          	sw	a6,16(sp)
    7f4c:	00a12a23          	sw	a0,20(sp)
    7f50:	00e12c23          	sw	a4,24(sp)
    7f54:	00f12e23          	sw	a5,28(sp)
		int IndexPtr[4] = {0,0,0,0};
    7f58:	00012023          	sw	zero,0(sp)
    7f5c:	00012223          	sw	zero,4(sp)
    7f60:	00012423          	sw	zero,8(sp)
    7f64:	00012623          	sw	zero,12(sp)




		descriptorPtr = 0;
		for (int i=0; i<nDescriptor; i++)
    7f68:	00000813          	li	a6,0
		descriptorPtr = 0;
    7f6c:	00000713          	li	a4,0
		for (int i=0; i<nDescriptor; i++)
    7f70:	08c0006f          	j	7ffc <dma_video_out_split4_frame+0x104>
					IndexPtr[0]++;
				}
				else
				{
					//Right
					out_descriptor[descriptorPtr].control = (u32)((FRAME_X_HDMI/splitX)-1)  | 1 << 30 | DMASG_DESCRIPTOR_CONTROL_NO_COMPLETION;
    7f74:	00571793          	slli	a5,a4,0x5
    7f78:	00f407b3          	add	a5,s0,a5
    7f7c:	c0000537          	lui	a0,0xc0000
    7f80:	3bf50513          	addi	a0,a0,959 # c00003bf <__freertos_irq_stack_top+0xbffac94f>
    7f84:	00a7a223          	sw	a0,4(a5)
					out_descriptor[descriptorPtr].from    = (u32)(&framebuffer2[ (start_Y[1] +IndexPtr[1])*(FRAME_X_RX/4)  + start_X[1]/4 ]);
    7f88:	00412303          	lw	t1,4(sp)
    7f8c:	01412883          	lw	a7,20(sp)
    7f90:	00688533          	add	a0,a7,t1
    7f94:	00451893          	slli	a7,a0,0x4
    7f98:	40a888b3          	sub	a7,a7,a0
    7f9c:	00589513          	slli	a0,a7,0x5
    7fa0:	02412e03          	lw	t3,36(sp)
    7fa4:	41fe5893          	srai	a7,t3,0x1f
    7fa8:	0038f893          	andi	a7,a7,3
    7fac:	01c888b3          	add	a7,a7,t3
    7fb0:	4028d893          	srai	a7,a7,0x2
    7fb4:	01150533          	add	a0,a0,a7
    7fb8:	00251513          	slli	a0,a0,0x2
    7fbc:	00a58533          	add	a0,a1,a0
    7fc0:	00a7a423          	sw	a0,8(a5)
    7fc4:	0007a623          	sw	zero,12(a5)
					out_descriptor[descriptorPtr].to      = 0;
    7fc8:	00000e13          	li	t3,0
    7fcc:	00000e93          	li	t4,0
    7fd0:	01c7a823          	sw	t3,16(a5)
    7fd4:	01d7aa23          	sw	t4,20(a5)
					out_descriptor[descriptorPtr].next    =  (u32)(out_descriptor+descriptorPtr+ 1);
    7fd8:	00170713          	addi	a4,a4,1
    7fdc:	00571513          	slli	a0,a4,0x5
    7fe0:	00a40533          	add	a0,s0,a0
    7fe4:	00a7ac23          	sw	a0,24(a5)
    7fe8:	0007ae23          	sw	zero,28(a5)
					out_descriptor[descriptorPtr].status  = 0;
    7fec:	0007a023          	sw	zero,0(a5)
					descriptorPtr ++;
					IndexPtr[1]++;
    7ff0:	00130313          	addi	t1,t1,1
    7ff4:	00612223          	sw	t1,4(sp)
		for (int i=0; i<nDescriptor; i++)
    7ff8:	00180813          	addi	a6,a6,1
    7ffc:	00080793          	mv	a5,a6
    8000:	00001537          	lui	a0,0x1
    8004:	86f50513          	addi	a0,a0,-1937 # 86f <CUSTOM2+0x814>
    8008:	1b056a63          	bltu	a0,a6,81bc <dma_video_out_split4_frame+0x2c4>
			if(i < nDescriptor/splitY)
    800c:	43700513          	li	a0,1079
    8010:	08f56a63          	bltu	a0,a5,80a4 <dma_video_out_split4_frame+0x1ac>
				if((i%2) == 0){
    8014:	0017f793          	andi	a5,a5,1
    8018:	f4079ee3          	bnez	a5,7f74 <dma_video_out_split4_frame+0x7c>
					out_descriptor[descriptorPtr].control = (u32)((FRAME_X_HDMI/splitX)-1)  | 1 << 30 | DMASG_DESCRIPTOR_CONTROL_NO_COMPLETION;
    801c:	00571793          	slli	a5,a4,0x5
    8020:	00f407b3          	add	a5,s0,a5
    8024:	c0000537          	lui	a0,0xc0000
    8028:	3bf50513          	addi	a0,a0,959 # c00003bf <__freertos_irq_stack_top+0xbffac94f>
    802c:	00a7a223          	sw	a0,4(a5)
					out_descriptor[descriptorPtr].from    = (u32)(&framebuffer1[ (start_Y[0] +IndexPtr[0])*(FRAME_X_RX/4)  + start_X[0]/4 ]);
    8030:	00012303          	lw	t1,0(sp)
    8034:	01012883          	lw	a7,16(sp)
    8038:	00688533          	add	a0,a7,t1
    803c:	00451893          	slli	a7,a0,0x4
    8040:	40a888b3          	sub	a7,a7,a0
    8044:	00589513          	slli	a0,a7,0x5
    8048:	02012e03          	lw	t3,32(sp)
    804c:	41fe5893          	srai	a7,t3,0x1f
    8050:	0038f893          	andi	a7,a7,3
    8054:	01c888b3          	add	a7,a7,t3
    8058:	4028d893          	srai	a7,a7,0x2
    805c:	01150533          	add	a0,a0,a7
    8060:	00251513          	slli	a0,a0,0x2
    8064:	00a48533          	add	a0,s1,a0
    8068:	00a7a423          	sw	a0,8(a5)
    806c:	0007a623          	sw	zero,12(a5)
					out_descriptor[descriptorPtr].to      = 0;
    8070:	00000e13          	li	t3,0
    8074:	00000e93          	li	t4,0
    8078:	01c7a823          	sw	t3,16(a5)
    807c:	01d7aa23          	sw	t4,20(a5)
					out_descriptor[descriptorPtr].next    =  (u32)(out_descriptor+descriptorPtr+ 1);
    8080:	00170713          	addi	a4,a4,1
    8084:	00571513          	slli	a0,a4,0x5
    8088:	00a40533          	add	a0,s0,a0
    808c:	00a7ac23          	sw	a0,24(a5)
    8090:	0007ae23          	sw	zero,28(a5)
					out_descriptor[descriptorPtr].status  = 0;
    8094:	0007a023          	sw	zero,0(a5)
					IndexPtr[0]++;
    8098:	00130313          	addi	t1,t1,1
    809c:	00612023          	sw	t1,0(sp)
    80a0:	f59ff06f          	j	7ff8 <dma_video_out_split4_frame+0x100>
			{
				//lower half



				if((i%2) == 0){
    80a4:	0017f793          	andi	a5,a5,1
    80a8:	08079663          	bnez	a5,8134 <dma_video_out_split4_frame+0x23c>
					//Left
					out_descriptor[descriptorPtr].control = (u32)((FRAME_X_HDMI/splitX)-1)  | 1 << 30 | DMASG_DESCRIPTOR_CONTROL_NO_COMPLETION;
    80ac:	00571793          	slli	a5,a4,0x5
    80b0:	00f407b3          	add	a5,s0,a5
    80b4:	c0000537          	lui	a0,0xc0000
    80b8:	3bf50513          	addi	a0,a0,959 # c00003bf <__freertos_irq_stack_top+0xbffac94f>
    80bc:	00a7a223          	sw	a0,4(a5)
					out_descriptor[descriptorPtr].from    = (u32)(&framebuffer3[ (start_Y[2] +IndexPtr[2])*(FRAME_X_RX/4)  + start_X[2]/4 ]);
    80c0:	00812303          	lw	t1,8(sp)
    80c4:	01812883          	lw	a7,24(sp)
    80c8:	00688533          	add	a0,a7,t1
    80cc:	00451893          	slli	a7,a0,0x4
    80d0:	40a888b3          	sub	a7,a7,a0
    80d4:	00589513          	slli	a0,a7,0x5
    80d8:	02812e03          	lw	t3,40(sp)
    80dc:	41fe5893          	srai	a7,t3,0x1f
    80e0:	0038f893          	andi	a7,a7,3
    80e4:	01c888b3          	add	a7,a7,t3
    80e8:	4028d893          	srai	a7,a7,0x2
    80ec:	01150533          	add	a0,a0,a7
    80f0:	00251513          	slli	a0,a0,0x2
    80f4:	00a60533          	add	a0,a2,a0
    80f8:	00a7a423          	sw	a0,8(a5)
    80fc:	0007a623          	sw	zero,12(a5)
					out_descriptor[descriptorPtr].to      = 0;
    8100:	00000e13          	li	t3,0
    8104:	00000e93          	li	t4,0
    8108:	01c7a823          	sw	t3,16(a5)
    810c:	01d7aa23          	sw	t4,20(a5)
					out_descriptor[descriptorPtr].next    =  (u32)(out_descriptor+descriptorPtr+ 1);
    8110:	00170713          	addi	a4,a4,1
    8114:	00571513          	slli	a0,a4,0x5
    8118:	00a40533          	add	a0,s0,a0
    811c:	00a7ac23          	sw	a0,24(a5)
    8120:	0007ae23          	sw	zero,28(a5)
					out_descriptor[descriptorPtr].status  = 0;
    8124:	0007a023          	sw	zero,0(a5)
					descriptorPtr ++;
					IndexPtr[2]++;
    8128:	00130313          	addi	t1,t1,1
    812c:	00612423          	sw	t1,8(sp)
    8130:	ec9ff06f          	j	7ff8 <dma_video_out_split4_frame+0x100>

				}
				else
				{
					//Right
					out_descriptor[descriptorPtr].control = (u32)((FRAME_X_HDMI/splitX)-1)  | 1 << 30 | DMASG_DESCRIPTOR_CONTROL_NO_COMPLETION;
    8134:	00571793          	slli	a5,a4,0x5
    8138:	00f407b3          	add	a5,s0,a5
    813c:	c0000537          	lui	a0,0xc0000
    8140:	3bf50513          	addi	a0,a0,959 # c00003bf <__freertos_irq_stack_top+0xbffac94f>
    8144:	00a7a223          	sw	a0,4(a5)
					out_descriptor[descriptorPtr].from    = (u32)(&framebuffer4[ (start_Y[3] +IndexPtr[3])*(FRAME_X_RX/4)  + start_X[3]/4 ]);
    8148:	00c12303          	lw	t1,12(sp)
    814c:	01c12883          	lw	a7,28(sp)
    8150:	00688533          	add	a0,a7,t1
    8154:	00451893          	slli	a7,a0,0x4
    8158:	40a888b3          	sub	a7,a7,a0
    815c:	00589513          	slli	a0,a7,0x5
    8160:	02c12e03          	lw	t3,44(sp)
    8164:	41fe5893          	srai	a7,t3,0x1f
    8168:	0038f893          	andi	a7,a7,3
    816c:	01c888b3          	add	a7,a7,t3
    8170:	4028d893          	srai	a7,a7,0x2
    8174:	01150533          	add	a0,a0,a7
    8178:	00251513          	slli	a0,a0,0x2
    817c:	00a68533          	add	a0,a3,a0
    8180:	00a7a423          	sw	a0,8(a5)
    8184:	0007a623          	sw	zero,12(a5)
					out_descriptor[descriptorPtr].to      = 0;
    8188:	00000e13          	li	t3,0
    818c:	00000e93          	li	t4,0
    8190:	01c7a823          	sw	t3,16(a5)
    8194:	01d7aa23          	sw	t4,20(a5)
					out_descriptor[descriptorPtr].next    =  (u32)(out_descriptor+descriptorPtr+ 1);
    8198:	00170713          	addi	a4,a4,1
    819c:	00571513          	slli	a0,a4,0x5
    81a0:	00a40533          	add	a0,s0,a0
    81a4:	00a7ac23          	sw	a0,24(a5)
    81a8:	0007ae23          	sw	zero,28(a5)
					out_descriptor[descriptorPtr].status  = 0;
    81ac:	0007a023          	sw	zero,0(a5)
					descriptorPtr ++;
					IndexPtr[3]++;
    81b0:	00130313          	addi	t1,t1,1
    81b4:	00612623          	sw	t1,12(sp)
    81b8:	e41ff06f          	j	7ff8 <dma_video_out_split4_frame+0x100>
			}

		}


		out_descriptor[descriptorPtr-1].next    =  (u32)(out_descriptor);
    81bc:	080007b7          	lui	a5,0x8000
    81c0:	fff78793          	addi	a5,a5,-1 # 7ffffff <__freertos_irq_stack_top+0x7fac58f>
    81c4:	00f707b3          	add	a5,a4,a5
    81c8:	00579793          	slli	a5,a5,0x5
    81cc:	00f407b3          	add	a5,s0,a5
    81d0:	0087ac23          	sw	s0,24(a5)
    81d4:	0007ae23          	sw	zero,28(a5)



		if(dmasg_busy(DMASG_BASE, DMASG_CHANNEL_HDMI))
    81d8:	00400593          	li	a1,4
    81dc:	f8130537          	lui	a0,0xf8130
    81e0:	cedfe0ef          	jal	ra,6ecc <dmasg_busy>
    81e4:	0a051463          	bnez	a0,828c <dma_video_out_split4_frame+0x394>
		{
			bsp_printf("stop dma out \n\r");
			dmasg_stop(DMASG_BASE, DMASG_CHANNEL_HDMI);
		}
		while(dmasg_busy(DMASG_BASE, DMASG_CHANNEL_HDMI));
    81e8:	00400593          	li	a1,4
    81ec:	f8130537          	lui	a0,0xf8130
    81f0:	cddfe0ef          	jal	ra,6ecc <dmasg_busy>
    81f4:	fe051ae3          	bnez	a0,81e8 <dma_video_out_split4_frame+0x2f0>


		bsp_printf("stop dma out \n\r");
    81f8:	00051537          	lui	a0,0x51
    81fc:	6e050513          	addi	a0,a0,1760 # 516e0 <raw_table+0xe744>
    8200:	d15fe0ef          	jal	ra,6f14 <bsp_printf>
		dmasg_stop(DMASG_BASE, DMASG_CHANNEL_HDMI);
    8204:	00400593          	li	a1,4
    8208:	f8130537          	lui	a0,0xf8130
    820c:	c95fe0ef          	jal	ra,6ea0 <dmasg_stop>

		dmasg_interrupt_config(DMASG_BASE, DMASG_CHANNEL_HDMI, 0);  //Disable dmasg channel interrupt
    8210:	00000613          	li	a2,0
    8214:	00400593          	li	a1,4
    8218:	f8130537          	lui	a0,0xf8130
    821c:	c99fe0ef          	jal	ra,6eb4 <dmasg_interrupt_config>

		dmasg_stop(DMASG_BASE, DMASG_CHANNEL_HDMI);
    8220:	00400593          	li	a1,4
    8224:	f8130537          	lui	a0,0xf8130
    8228:	c79fe0ef          	jal	ra,6ea0 <dmasg_stop>
		dmasg_input_memory(DMASG_BASE, DMASG_CHANNEL_HDMI, ((u32)(framebuffer1 )) , (512));//dmasg_push_memory(DMASG_BASE, 1, ((u32)pucEthernetBuffer), xDataLength);
    822c:	20000693          	li	a3,512
    8230:	00048613          	mv	a2,s1
    8234:	00400593          	li	a1,4
    8238:	f8130537          	lui	a0,0xf8130
    823c:	b51fe0ef          	jal	ra,6d8c <dmasg_input_memory>
		dmasg_output_stream(DMASG_BASE, DMASG_CHANNEL_HDMI, 0, 0, 0, 1); //dmasg_pop_stream(DMASG_BASE, DMASG_CHANNEL1, 0, 0, 0, 1);
    8240:	00100793          	li	a5,1
    8244:	00000713          	li	a4,0
    8248:	00000693          	li	a3,0
    824c:	00000613          	li	a2,0
    8250:	00400593          	li	a1,4
    8254:	f8130537          	lui	a0,0xf8130
    8258:	bbdfe0ef          	jal	ra,6e14 <dmasg_output_stream>
		dmasg_linked_list_start(DMASG_BASE, DMASG_CHANNEL_HDMI,(u32)out_descriptor  );
    825c:	00040613          	mv	a2,s0
    8260:	00400593          	li	a1,4
    8264:	f8130537          	lui	a0,0xf8130
    8268:	c01fe0ef          	jal	ra,6e68 <dmasg_linked_list_start>

		bsp_printf("Start dma out \n\r");
    826c:	00051537          	lui	a0,0x51
    8270:	63c50513          	addi	a0,a0,1596 # 5163c <raw_table+0xe6a0>
    8274:	ca1fe0ef          	jal	ra,6f14 <bsp_printf>

}
    8278:	03c12083          	lw	ra,60(sp)
    827c:	03812403          	lw	s0,56(sp)
    8280:	03412483          	lw	s1,52(sp)
    8284:	04010113          	addi	sp,sp,64
    8288:	00008067          	ret
			bsp_printf("stop dma out \n\r");
    828c:	00051537          	lui	a0,0x51
    8290:	6e050513          	addi	a0,a0,1760 # 516e0 <raw_table+0xe744>
    8294:	c81fe0ef          	jal	ra,6f14 <bsp_printf>
			dmasg_stop(DMASG_BASE, DMASG_CHANNEL_HDMI);
    8298:	00400593          	li	a1,4
    829c:	f8130537          	lui	a0,0xf8130
    82a0:	c01fe0ef          	jal	ra,6ea0 <dmasg_stop>
    82a4:	f45ff06f          	j	81e8 <dma_video_out_split4_frame+0x2f0>

000082a8 <dma_video_out_scrop_frame>:

void dma_video_out_scrop_frame(u32 * framebuffer1, int start_x, int start_y, struct dmasg_descriptor* out_descriptor )
{
    82a8:	ff010113          	addi	sp,sp,-16
    82ac:	00112623          	sw	ra,12(sp)
    82b0:	00812423          	sw	s0,8(sp)
    82b4:	00912223          	sw	s1,4(sp)
    82b8:	00050493          	mv	s1,a0
    82bc:	00068413          	mv	s0,a3

			u32 descriptorPtr = 0;


			descriptorPtr = 0;
			for (int i=0; i<FRAME_Y_HDMI; i++)
    82c0:	00000813          	li	a6,0
			descriptorPtr = 0;
    82c4:	00000513          	li	a0,0
			for (int i=0; i<FRAME_Y_HDMI; i++)
    82c8:	43700793          	li	a5,1079
    82cc:	0707ce63          	blt	a5,a6,8348 <dma_video_out_scrop_frame+0xa0>
			{
				out_descriptor[descriptorPtr].control = (u32)((FRAME_X_HDMI)-1)  | 1 << 30 | DMASG_DESCRIPTOR_CONTROL_NO_COMPLETION;
    82d0:	00551793          	slli	a5,a0,0x5
    82d4:	00f407b3          	add	a5,s0,a5
    82d8:	c0000737          	lui	a4,0xc0000
    82dc:	77f70713          	addi	a4,a4,1919 # c000077f <__freertos_irq_stack_top+0xbffacd0f>
    82e0:	00e7a223          	sw	a4,4(a5)
														out_descriptor[descriptorPtr].from    = (u32)(&framebuffer1[ (start_y +i)*(FRAME_X_RX/4)  + start_x/4 ]);
    82e4:	00c80733          	add	a4,a6,a2
    82e8:	00471693          	slli	a3,a4,0x4
    82ec:	40e686b3          	sub	a3,a3,a4
    82f0:	00569713          	slli	a4,a3,0x5
    82f4:	41f5d693          	srai	a3,a1,0x1f
    82f8:	0036f693          	andi	a3,a3,3
    82fc:	00b686b3          	add	a3,a3,a1
    8300:	4026d693          	srai	a3,a3,0x2
    8304:	00d70733          	add	a4,a4,a3
    8308:	00271713          	slli	a4,a4,0x2
    830c:	00e48733          	add	a4,s1,a4
    8310:	00e7a423          	sw	a4,8(a5)
    8314:	0007a623          	sw	zero,12(a5)
														out_descriptor[descriptorPtr].to      = 0;
    8318:	00000693          	li	a3,0
    831c:	00000713          	li	a4,0
    8320:	00d7a823          	sw	a3,16(a5)
    8324:	00e7aa23          	sw	a4,20(a5)
														out_descriptor[descriptorPtr].next    =  (u32)(out_descriptor+descriptorPtr+ 1);
    8328:	00150513          	addi	a0,a0,1 # f8130001 <__freertos_irq_stack_top+0xf80dc591>
    832c:	00551713          	slli	a4,a0,0x5
    8330:	00e40733          	add	a4,s0,a4
    8334:	00e7ac23          	sw	a4,24(a5)
    8338:	0007ae23          	sw	zero,28(a5)
														out_descriptor[descriptorPtr].status  = 0;
    833c:	0007a023          	sw	zero,0(a5)
			for (int i=0; i<FRAME_Y_HDMI; i++)
    8340:	00180813          	addi	a6,a6,1
    8344:	f85ff06f          	j	82c8 <dma_video_out_scrop_frame+0x20>
														descriptorPtr ++;
			}
			out_descriptor[descriptorPtr-1].next    =  (u32)(out_descriptor);
    8348:	080007b7          	lui	a5,0x8000
    834c:	fff78793          	addi	a5,a5,-1 # 7ffffff <__freertos_irq_stack_top+0x7fac58f>
    8350:	00f507b3          	add	a5,a0,a5
    8354:	00579793          	slli	a5,a5,0x5
    8358:	00f407b3          	add	a5,s0,a5
    835c:	0087ac23          	sw	s0,24(a5)
    8360:	0007ae23          	sw	zero,28(a5)



			if(dmasg_busy(DMASG_BASE, DMASG_CHANNEL_HDMI))
    8364:	00400593          	li	a1,4
    8368:	f8130537          	lui	a0,0xf8130
    836c:	b61fe0ef          	jal	ra,6ecc <dmasg_busy>
    8370:	0a051463          	bnez	a0,8418 <dma_video_out_scrop_frame+0x170>
			{
				bsp_printf("stop dma out \n\r");
				dmasg_stop(DMASG_BASE, DMASG_CHANNEL_HDMI);
			}
			while(dmasg_busy(DMASG_BASE, DMASG_CHANNEL_HDMI));
    8374:	00400593          	li	a1,4
    8378:	f8130537          	lui	a0,0xf8130
    837c:	b51fe0ef          	jal	ra,6ecc <dmasg_busy>
    8380:	fe051ae3          	bnez	a0,8374 <dma_video_out_scrop_frame+0xcc>


			bsp_printf("stop dma out \n\r");
    8384:	00051537          	lui	a0,0x51
    8388:	6e050513          	addi	a0,a0,1760 # 516e0 <raw_table+0xe744>
    838c:	b89fe0ef          	jal	ra,6f14 <bsp_printf>
			dmasg_stop(DMASG_BASE, DMASG_CHANNEL_HDMI);
    8390:	00400593          	li	a1,4
    8394:	f8130537          	lui	a0,0xf8130
    8398:	b09fe0ef          	jal	ra,6ea0 <dmasg_stop>

			dmasg_interrupt_config(DMASG_BASE, DMASG_CHANNEL_HDMI, 0);  //Disable dmasg channel interrupt
    839c:	00000613          	li	a2,0
    83a0:	00400593          	li	a1,4
    83a4:	f8130537          	lui	a0,0xf8130
    83a8:	b0dfe0ef          	jal	ra,6eb4 <dmasg_interrupt_config>

			dmasg_stop(DMASG_BASE, DMASG_CHANNEL_HDMI);
    83ac:	00400593          	li	a1,4
    83b0:	f8130537          	lui	a0,0xf8130
    83b4:	aedfe0ef          	jal	ra,6ea0 <dmasg_stop>
			dmasg_input_memory(DMASG_BASE, DMASG_CHANNEL_HDMI, ((u32)(framebuffer1 )) , (512));//dmasg_push_memory(DMASG_BASE, 1, ((u32)pucEthernetBuffer), xDataLength);
    83b8:	20000693          	li	a3,512
    83bc:	00048613          	mv	a2,s1
    83c0:	00400593          	li	a1,4
    83c4:	f8130537          	lui	a0,0xf8130
    83c8:	9c5fe0ef          	jal	ra,6d8c <dmasg_input_memory>
			dmasg_output_stream(DMASG_BASE, DMASG_CHANNEL_HDMI, 0, 0, 0, 1); //dmasg_pop_stream(DMASG_BASE, DMASG_CHANNEL1, 0, 0, 0, 1);
    83cc:	00100793          	li	a5,1
    83d0:	00000713          	li	a4,0
    83d4:	00000693          	li	a3,0
    83d8:	00000613          	li	a2,0
    83dc:	00400593          	li	a1,4
    83e0:	f8130537          	lui	a0,0xf8130
    83e4:	a31fe0ef          	jal	ra,6e14 <dmasg_output_stream>
			dmasg_linked_list_start(DMASG_BASE, DMASG_CHANNEL_HDMI,(u32)out_descriptor  );
    83e8:	00040613          	mv	a2,s0
    83ec:	00400593          	li	a1,4
    83f0:	f8130537          	lui	a0,0xf8130
    83f4:	a75fe0ef          	jal	ra,6e68 <dmasg_linked_list_start>

			bsp_printf("Start dma out \n\r");
    83f8:	00051537          	lui	a0,0x51
    83fc:	63c50513          	addi	a0,a0,1596 # 5163c <raw_table+0xe6a0>
    8400:	b15fe0ef          	jal	ra,6f14 <bsp_printf>

}
    8404:	00c12083          	lw	ra,12(sp)
    8408:	00812403          	lw	s0,8(sp)
    840c:	00412483          	lw	s1,4(sp)
    8410:	01010113          	addi	sp,sp,16
    8414:	00008067          	ret
				bsp_printf("stop dma out \n\r");
    8418:	00051537          	lui	a0,0x51
    841c:	6e050513          	addi	a0,a0,1760 # 516e0 <raw_table+0xe744>
    8420:	af5fe0ef          	jal	ra,6f14 <bsp_printf>
				dmasg_stop(DMASG_BASE, DMASG_CHANNEL_HDMI);
    8424:	00400593          	li	a1,4
    8428:	f8130537          	lui	a0,0xf8130
    842c:	a75fe0ef          	jal	ra,6ea0 <dmasg_stop>
    8430:	f45ff06f          	j	8374 <dma_video_out_scrop_frame+0xcc>

00008434 <mipi_i2c_init>:



void mipi_i2c_init(){
    8434:	fd010113          	addi	sp,sp,-48
    8438:	02112623          	sw	ra,44(sp)
    //I2C init
    I2c_Config i2c_mipi;
    i2c_mipi.samplingClockDivider = 3;
    843c:	00300793          	li	a5,3
    8440:	00f12423          	sw	a5,8(sp)
    i2c_mipi.timeout = I2C_CTRL_HZ/1000;
    8444:	000187b7          	lui	a5,0x18
    8448:	6a078793          	addi	a5,a5,1696 # 186a0 <raw_table3+0x7cc>
    844c:	00f12623          	sw	a5,12(sp)
    i2c_mipi.tsuDat  = I2C_CTRL_HZ/2000000;
    8450:	03200793          	li	a5,50
    8454:	00f12823          	sw	a5,16(sp)

    i2c_mipi.tLow  = I2C_CTRL_HZ/800000;
    8458:	07d00793          	li	a5,125
    845c:	00f12a23          	sw	a5,20(sp)
    i2c_mipi.tHigh = I2C_CTRL_HZ/800000;
    8460:	00f12c23          	sw	a5,24(sp)
    i2c_mipi.tBuf  = I2C_CTRL_HZ/400000;
    8464:	0fa00793          	li	a5,250
    8468:	00f12e23          	sw	a5,28(sp)

    i2c_applyConfig(I2C_CTRL_MIPI, &i2c_mipi);
    846c:	00810593          	addi	a1,sp,8
    8470:	f8017537          	lui	a0,0xf8017
    8474:	a6dfe0ef          	jal	ra,6ee0 <i2c_applyConfig>

}
    8478:	02c12083          	lw	ra,44(sp)
    847c:	03010113          	addi	sp,sp,48
    8480:	00008067          	ret

00008484 <hdmi_i2c_init>:
    i2c_hdmi.tHigh = I2C_CTRL_HZ/800000*2;
    i2c_hdmi.tBuf  = I2C_CTRL_HZ/400000*2;

 //   i2c_applyConfig(I2C_CTRL_HDMI, &i2c_hdmi);

}
    8484:	00008067          	ret

00008488 <trap_entry>:
.global  trap_entry
.align(2) //mtvec require 32 bits allignement
trap_entry:
  addi sp,sp, -16*4
    8488:	fc010113          	addi	sp,sp,-64
  sw x1,   0*4(sp)
    848c:	00112023          	sw	ra,0(sp)
  sw x5,   1*4(sp)
    8490:	00512223          	sw	t0,4(sp)
  sw x6,   2*4(sp)
    8494:	00612423          	sw	t1,8(sp)
  sw x7,   3*4(sp)
    8498:	00712623          	sw	t2,12(sp)
  sw x10,  4*4(sp)
    849c:	00a12823          	sw	a0,16(sp)
  sw x11,  5*4(sp)
    84a0:	00b12a23          	sw	a1,20(sp)
  sw x12,  6*4(sp)
    84a4:	00c12c23          	sw	a2,24(sp)
  sw x13,  7*4(sp)
    84a8:	00d12e23          	sw	a3,28(sp)
  sw x14,  8*4(sp)
    84ac:	02e12023          	sw	a4,32(sp)
  sw x15,  9*4(sp)
    84b0:	02f12223          	sw	a5,36(sp)
  sw x16, 10*4(sp)
    84b4:	03012423          	sw	a6,40(sp)
  sw x17, 11*4(sp)
    84b8:	03112623          	sw	a7,44(sp)
  sw x28, 12*4(sp)
    84bc:	03c12823          	sw	t3,48(sp)
  sw x29, 13*4(sp)
    84c0:	03d12a23          	sw	t4,52(sp)
  sw x30, 14*4(sp)
    84c4:	03e12c23          	sw	t5,56(sp)
  sw x31, 15*4(sp)
    84c8:	03f12e23          	sw	t6,60(sp)
  call trap
    84cc:	f3cfb0ef          	jal	ra,3c08 <trap>
  lw x1 ,  0*4(sp)
    84d0:	00012083          	lw	ra,0(sp)
  lw x5,   1*4(sp)
    84d4:	00412283          	lw	t0,4(sp)
  lw x6,   2*4(sp)
    84d8:	00812303          	lw	t1,8(sp)
  lw x7,   3*4(sp)
    84dc:	00c12383          	lw	t2,12(sp)
  lw x10,  4*4(sp)
    84e0:	01012503          	lw	a0,16(sp)
  lw x11,  5*4(sp)
    84e4:	01412583          	lw	a1,20(sp)
  lw x12,  6*4(sp)
    84e8:	01812603          	lw	a2,24(sp)
  lw x13,  7*4(sp)
    84ec:	01c12683          	lw	a3,28(sp)
  lw x14,  8*4(sp)
    84f0:	02012703          	lw	a4,32(sp)
  lw x15,  9*4(sp)
    84f4:	02412783          	lw	a5,36(sp)
  lw x16, 10*4(sp)
    84f8:	02812803          	lw	a6,40(sp)
  lw x17, 11*4(sp)
    84fc:	02c12883          	lw	a7,44(sp)
  lw x28, 12*4(sp)
    8500:	03012e03          	lw	t3,48(sp)
  lw x29, 13*4(sp)
    8504:	03412e83          	lw	t4,52(sp)
  lw x30, 14*4(sp)
    8508:	03812f03          	lw	t5,56(sp)
  lw x31, 15*4(sp)
    850c:	03c12f83          	lw	t6,60(sp)
  addi sp,sp, 16*4
    8510:	04010113          	addi	sp,sp,64
  mret
    8514:	30200073          	mret

00008518 <__udivdi3>:
    8518:	00068793          	mv	a5,a3
    851c:	00060893          	mv	a7,a2
    8520:	00050313          	mv	t1,a0
    8524:	00058813          	mv	a6,a1
    8528:	1a069663          	bnez	a3,86d4 <__udivdi3+0x1bc>
    852c:	0cc5fc63          	bgeu	a1,a2,8604 <__udivdi3+0xec>
    8530:	00010737          	lui	a4,0x10
    8534:	22e66463          	bltu	a2,a4,875c <__udivdi3+0x244>
    8538:	010007b7          	lui	a5,0x1000
    853c:	40f66a63          	bltu	a2,a5,8950 <__udivdi3+0x438>
    8540:	01865693          	srli	a3,a2,0x18
    8544:	01800793          	li	a5,24
    8548:	00049717          	auipc	a4,0x49
    854c:	1e470713          	addi	a4,a4,484 # 5172c <__clz_tab>
    8550:	00d70733          	add	a4,a4,a3
    8554:	00074703          	lbu	a4,0(a4)
    8558:	00f707b3          	add	a5,a4,a5
    855c:	02000713          	li	a4,32
    8560:	40f70733          	sub	a4,a4,a5
    8564:	00070c63          	beqz	a4,857c <__udivdi3+0x64>
    8568:	00e59833          	sll	a6,a1,a4
    856c:	00f557b3          	srl	a5,a0,a5
    8570:	00e618b3          	sll	a7,a2,a4
    8574:	0107e833          	or	a6,a5,a6
    8578:	00e51333          	sll	t1,a0,a4
    857c:	0108d613          	srli	a2,a7,0x10
    8580:	02c85533          	divu	a0,a6,a2
    8584:	01089693          	slli	a3,a7,0x10
    8588:	0106d693          	srli	a3,a3,0x10
    858c:	01035793          	srli	a5,t1,0x10
    8590:	02c87733          	remu	a4,a6,a2
    8594:	02a685b3          	mul	a1,a3,a0
    8598:	01071713          	slli	a4,a4,0x10
    859c:	00f76833          	or	a6,a4,a5
    85a0:	00b87c63          	bgeu	a6,a1,85b8 <__udivdi3+0xa0>
    85a4:	01180833          	add	a6,a6,a7
    85a8:	fff50793          	addi	a5,a0,-1 # f8016fff <__freertos_irq_stack_top+0xf7fc358f>
    85ac:	01186463          	bltu	a6,a7,85b4 <__udivdi3+0x9c>
    85b0:	3eb86863          	bltu	a6,a1,89a0 <__udivdi3+0x488>
    85b4:	00078513          	mv	a0,a5
    85b8:	40b80833          	sub	a6,a6,a1
    85bc:	02c85733          	divu	a4,a6,a2
    85c0:	01031313          	slli	t1,t1,0x10
    85c4:	01035313          	srli	t1,t1,0x10
    85c8:	02c87833          	remu	a6,a6,a2
    85cc:	02e686b3          	mul	a3,a3,a4
    85d0:	01081813          	slli	a6,a6,0x10
    85d4:	00686833          	or	a6,a6,t1
    85d8:	00d87e63          	bgeu	a6,a3,85f4 <__udivdi3+0xdc>
    85dc:	01088833          	add	a6,a7,a6
    85e0:	fff70793          	addi	a5,a4,-1
    85e4:	01186663          	bltu	a6,a7,85f0 <__udivdi3+0xd8>
    85e8:	ffe70713          	addi	a4,a4,-2
    85ec:	00d86463          	bltu	a6,a3,85f4 <__udivdi3+0xdc>
    85f0:	00078713          	mv	a4,a5
    85f4:	01051513          	slli	a0,a0,0x10
    85f8:	00e56533          	or	a0,a0,a4
    85fc:	00000593          	li	a1,0
    8600:	00008067          	ret
    8604:	00061663          	bnez	a2,8610 <__udivdi3+0xf8>
    8608:	00100713          	li	a4,1
    860c:	02c758b3          	divu	a7,a4,a2
    8610:	00010737          	lui	a4,0x10
    8614:	12e8e863          	bltu	a7,a4,8744 <__udivdi3+0x22c>
    8618:	010007b7          	lui	a5,0x1000
    861c:	34f8e063          	bltu	a7,a5,895c <__udivdi3+0x444>
    8620:	0188d693          	srli	a3,a7,0x18
    8624:	01800793          	li	a5,24
    8628:	00049717          	auipc	a4,0x49
    862c:	10470713          	addi	a4,a4,260 # 5172c <__clz_tab>
    8630:	00d70733          	add	a4,a4,a3
    8634:	00074683          	lbu	a3,0(a4)
    8638:	00f686b3          	add	a3,a3,a5
    863c:	02000793          	li	a5,32
    8640:	40d787b3          	sub	a5,a5,a3
    8644:	12079863          	bnez	a5,8774 <__udivdi3+0x25c>
    8648:	01089e93          	slli	t4,a7,0x10
    864c:	41158733          	sub	a4,a1,a7
    8650:	0108df13          	srli	t5,a7,0x10
    8654:	010ede93          	srli	t4,t4,0x10
    8658:	00100593          	li	a1,1
    865c:	01035793          	srli	a5,t1,0x10
    8660:	03e75533          	divu	a0,a4,t5
    8664:	03e77733          	remu	a4,a4,t5
    8668:	03d506b3          	mul	a3,a0,t4
    866c:	01071713          	slli	a4,a4,0x10
    8670:	00f767b3          	or	a5,a4,a5
    8674:	00d7fc63          	bgeu	a5,a3,868c <__udivdi3+0x174>
    8678:	011787b3          	add	a5,a5,a7
    867c:	fff50713          	addi	a4,a0,-1
    8680:	0117e463          	bltu	a5,a7,8688 <__udivdi3+0x170>
    8684:	32d7e463          	bltu	a5,a3,89ac <__udivdi3+0x494>
    8688:	00070513          	mv	a0,a4
    868c:	40d787b3          	sub	a5,a5,a3
    8690:	03e7d733          	divu	a4,a5,t5
    8694:	01031313          	slli	t1,t1,0x10
    8698:	01035313          	srli	t1,t1,0x10
    869c:	03e7f7b3          	remu	a5,a5,t5
    86a0:	03d70eb3          	mul	t4,a4,t4
    86a4:	01079793          	slli	a5,a5,0x10
    86a8:	0067e7b3          	or	a5,a5,t1
    86ac:	01d7fe63          	bgeu	a5,t4,86c8 <__udivdi3+0x1b0>
    86b0:	00f887b3          	add	a5,a7,a5
    86b4:	fff70693          	addi	a3,a4,-1
    86b8:	0117e663          	bltu	a5,a7,86c4 <__udivdi3+0x1ac>
    86bc:	ffe70713          	addi	a4,a4,-2
    86c0:	01d7e463          	bltu	a5,t4,86c8 <__udivdi3+0x1b0>
    86c4:	00068713          	mv	a4,a3
    86c8:	01051513          	slli	a0,a0,0x10
    86cc:	00e56533          	or	a0,a0,a4
    86d0:	00008067          	ret
    86d4:	04d5e863          	bltu	a1,a3,8724 <__udivdi3+0x20c>
    86d8:	000107b7          	lui	a5,0x10
    86dc:	04f6ea63          	bltu	a3,a5,8730 <__udivdi3+0x218>
    86e0:	010007b7          	lui	a5,0x1000
    86e4:	26f6e063          	bltu	a3,a5,8944 <__udivdi3+0x42c>
    86e8:	0186d713          	srli	a4,a3,0x18
    86ec:	01800813          	li	a6,24
    86f0:	00049797          	auipc	a5,0x49
    86f4:	03c78793          	addi	a5,a5,60 # 5172c <__clz_tab>
    86f8:	00e787b3          	add	a5,a5,a4
    86fc:	0007c703          	lbu	a4,0(a5)
    8700:	02000e13          	li	t3,32
    8704:	01070733          	add	a4,a4,a6
    8708:	40ee0e33          	sub	t3,t3,a4
    870c:	100e1663          	bnez	t3,8818 <__udivdi3+0x300>
    8710:	24b6ec63          	bltu	a3,a1,8968 <__udivdi3+0x450>
    8714:	00c53533          	sltu	a0,a0,a2
    8718:	00154513          	xori	a0,a0,1
    871c:	00000593          	li	a1,0
    8720:	00008067          	ret
    8724:	00000593          	li	a1,0
    8728:	00000513          	li	a0,0
    872c:	00008067          	ret
    8730:	0ff00793          	li	a5,255
    8734:	24d7f063          	bgeu	a5,a3,8974 <__udivdi3+0x45c>
    8738:	0086d713          	srli	a4,a3,0x8
    873c:	00800813          	li	a6,8
    8740:	fb1ff06f          	j	86f0 <__udivdi3+0x1d8>
    8744:	0ff00713          	li	a4,255
    8748:	00088693          	mv	a3,a7
    874c:	ed177ee3          	bgeu	a4,a7,8628 <__udivdi3+0x110>
    8750:	0088d693          	srli	a3,a7,0x8
    8754:	00800793          	li	a5,8
    8758:	ed1ff06f          	j	8628 <__udivdi3+0x110>
    875c:	0ff00713          	li	a4,255
    8760:	00060693          	mv	a3,a2
    8764:	dec772e3          	bgeu	a4,a2,8548 <__udivdi3+0x30>
    8768:	00865693          	srli	a3,a2,0x8
    876c:	00800793          	li	a5,8
    8770:	dd9ff06f          	j	8548 <__udivdi3+0x30>
    8774:	00f898b3          	sll	a7,a7,a5
    8778:	00d5d633          	srl	a2,a1,a3
    877c:	0108df13          	srli	t5,a7,0x10
    8780:	03e65e33          	divu	t3,a2,t5
    8784:	00f59733          	sll	a4,a1,a5
    8788:	00d556b3          	srl	a3,a0,a3
    878c:	00e6e733          	or	a4,a3,a4
    8790:	01089e93          	slli	t4,a7,0x10
    8794:	010ede93          	srli	t4,t4,0x10
    8798:	00f51333          	sll	t1,a0,a5
    879c:	01075593          	srli	a1,a4,0x10
    87a0:	03e676b3          	remu	a3,a2,t5
    87a4:	03ce87b3          	mul	a5,t4,t3
    87a8:	01069693          	slli	a3,a3,0x10
    87ac:	00b6e6b3          	or	a3,a3,a1
    87b0:	00f6fe63          	bgeu	a3,a5,87cc <__udivdi3+0x2b4>
    87b4:	011686b3          	add	a3,a3,a7
    87b8:	fffe0613          	addi	a2,t3,-1
    87bc:	1d16ee63          	bltu	a3,a7,8998 <__udivdi3+0x480>
    87c0:	1cf6fc63          	bgeu	a3,a5,8998 <__udivdi3+0x480>
    87c4:	ffee0e13          	addi	t3,t3,-2
    87c8:	011686b3          	add	a3,a3,a7
    87cc:	40f686b3          	sub	a3,a3,a5
    87d0:	03e6d633          	divu	a2,a3,t5
    87d4:	01071793          	slli	a5,a4,0x10
    87d8:	0107d793          	srli	a5,a5,0x10
    87dc:	03e6f6b3          	remu	a3,a3,t5
    87e0:	02ce8533          	mul	a0,t4,a2
    87e4:	01069713          	slli	a4,a3,0x10
    87e8:	00f76733          	or	a4,a4,a5
    87ec:	00a77e63          	bgeu	a4,a0,8808 <__udivdi3+0x2f0>
    87f0:	01170733          	add	a4,a4,a7
    87f4:	fff60793          	addi	a5,a2,-1
    87f8:	19176863          	bltu	a4,a7,8988 <__udivdi3+0x470>
    87fc:	18a77663          	bgeu	a4,a0,8988 <__udivdi3+0x470>
    8800:	ffe60613          	addi	a2,a2,-2
    8804:	01170733          	add	a4,a4,a7
    8808:	010e1593          	slli	a1,t3,0x10
    880c:	40a70733          	sub	a4,a4,a0
    8810:	00c5e5b3          	or	a1,a1,a2
    8814:	e49ff06f          	j	865c <__udivdi3+0x144>
    8818:	00e657b3          	srl	a5,a2,a4
    881c:	01c696b3          	sll	a3,a3,t3
    8820:	00d7e6b3          	or	a3,a5,a3
    8824:	00e5d333          	srl	t1,a1,a4
    8828:	0106df13          	srli	t5,a3,0x10
    882c:	03e357b3          	divu	a5,t1,t5
    8830:	01069e93          	slli	t4,a3,0x10
    8834:	010ede93          	srli	t4,t4,0x10
    8838:	01c59833          	sll	a6,a1,t3
    883c:	00e55733          	srl	a4,a0,a4
    8840:	01076833          	or	a6,a4,a6
    8844:	01085893          	srli	a7,a6,0x10
    8848:	01c61633          	sll	a2,a2,t3
    884c:	03e37333          	remu	t1,t1,t5
    8850:	02fe85b3          	mul	a1,t4,a5
    8854:	01031313          	slli	t1,t1,0x10
    8858:	011368b3          	or	a7,t1,a7
    885c:	00b8fe63          	bgeu	a7,a1,8878 <__udivdi3+0x360>
    8860:	00d888b3          	add	a7,a7,a3
    8864:	fff78713          	addi	a4,a5,-1
    8868:	12d8e463          	bltu	a7,a3,8990 <__udivdi3+0x478>
    886c:	12b8f263          	bgeu	a7,a1,8990 <__udivdi3+0x478>
    8870:	ffe78793          	addi	a5,a5,-2
    8874:	00d888b3          	add	a7,a7,a3
    8878:	40b888b3          	sub	a7,a7,a1
    887c:	03e8d733          	divu	a4,a7,t5
    8880:	01081813          	slli	a6,a6,0x10
    8884:	01085813          	srli	a6,a6,0x10
    8888:	03e8f8b3          	remu	a7,a7,t5
    888c:	02ee8333          	mul	t1,t4,a4
    8890:	01089893          	slli	a7,a7,0x10
    8894:	0108e5b3          	or	a1,a7,a6
    8898:	0065fe63          	bgeu	a1,t1,88b4 <__udivdi3+0x39c>
    889c:	00d585b3          	add	a1,a1,a3
    88a0:	fff70813          	addi	a6,a4,-1
    88a4:	0cd5ee63          	bltu	a1,a3,8980 <__udivdi3+0x468>
    88a8:	0c65fc63          	bgeu	a1,t1,8980 <__udivdi3+0x468>
    88ac:	ffe70713          	addi	a4,a4,-2
    88b0:	00d585b3          	add	a1,a1,a3
    88b4:	01079793          	slli	a5,a5,0x10
    88b8:	00010f37          	lui	t5,0x10
    88bc:	00e7e7b3          	or	a5,a5,a4
    88c0:	ffff0713          	addi	a4,t5,-1 # ffff <raw_table4+0x66c3>
    88c4:	00e7f6b3          	and	a3,a5,a4
    88c8:	0107d893          	srli	a7,a5,0x10
    88cc:	00e67733          	and	a4,a2,a4
    88d0:	01065613          	srli	a2,a2,0x10
    88d4:	02e68eb3          	mul	t4,a3,a4
    88d8:	406585b3          	sub	a1,a1,t1
    88dc:	02c686b3          	mul	a3,a3,a2
    88e0:	010ed813          	srli	a6,t4,0x10
    88e4:	02e88733          	mul	a4,a7,a4
    88e8:	00e686b3          	add	a3,a3,a4
    88ec:	00d806b3          	add	a3,a6,a3
    88f0:	02c88633          	mul	a2,a7,a2
    88f4:	00e6f463          	bgeu	a3,a4,88fc <__udivdi3+0x3e4>
    88f8:	01e60633          	add	a2,a2,t5
    88fc:	0106d893          	srli	a7,a3,0x10
    8900:	00c88633          	add	a2,a7,a2
    8904:	02c5ea63          	bltu	a1,a2,8938 <__udivdi3+0x420>
    8908:	00c58863          	beq	a1,a2,8918 <__udivdi3+0x400>
    890c:	00078513          	mv	a0,a5
    8910:	00000593          	li	a1,0
    8914:	00008067          	ret
    8918:	00010737          	lui	a4,0x10
    891c:	fff70713          	addi	a4,a4,-1 # ffff <raw_table4+0x66c3>
    8920:	00e6f6b3          	and	a3,a3,a4
    8924:	01069693          	slli	a3,a3,0x10
    8928:	00eefeb3          	and	t4,t4,a4
    892c:	01c51533          	sll	a0,a0,t3
    8930:	01d686b3          	add	a3,a3,t4
    8934:	fcd57ce3          	bgeu	a0,a3,890c <__udivdi3+0x3f4>
    8938:	fff78513          	addi	a0,a5,-1
    893c:	00000593          	li	a1,0
    8940:	00008067          	ret
    8944:	0106d713          	srli	a4,a3,0x10
    8948:	01000813          	li	a6,16
    894c:	da5ff06f          	j	86f0 <__udivdi3+0x1d8>
    8950:	01065693          	srli	a3,a2,0x10
    8954:	01000793          	li	a5,16
    8958:	bf1ff06f          	j	8548 <__udivdi3+0x30>
    895c:	0108d693          	srli	a3,a7,0x10
    8960:	01000793          	li	a5,16
    8964:	cc5ff06f          	j	8628 <__udivdi3+0x110>
    8968:	00000593          	li	a1,0
    896c:	00100513          	li	a0,1
    8970:	00008067          	ret
    8974:	00068713          	mv	a4,a3
    8978:	00000813          	li	a6,0
    897c:	d75ff06f          	j	86f0 <__udivdi3+0x1d8>
    8980:	00080713          	mv	a4,a6
    8984:	f31ff06f          	j	88b4 <__udivdi3+0x39c>
    8988:	00078613          	mv	a2,a5
    898c:	e7dff06f          	j	8808 <__udivdi3+0x2f0>
    8990:	00070793          	mv	a5,a4
    8994:	ee5ff06f          	j	8878 <__udivdi3+0x360>
    8998:	00060e13          	mv	t3,a2
    899c:	e31ff06f          	j	87cc <__udivdi3+0x2b4>
    89a0:	ffe50513          	addi	a0,a0,-2
    89a4:	01180833          	add	a6,a6,a7
    89a8:	c11ff06f          	j	85b8 <__udivdi3+0xa0>
    89ac:	ffe50513          	addi	a0,a0,-2
    89b0:	011787b3          	add	a5,a5,a7
    89b4:	cd9ff06f          	j	868c <__udivdi3+0x174>

000089b8 <_sbrk>:
    89b8:	89018793          	addi	a5,gp,-1904 # 520e0 <heap_end.1518>
    89bc:	0007a783          	lw	a5,0(a5)
    89c0:	00078a63          	beqz	a5,89d4 <_sbrk+0x1c>
    89c4:	00a78533          	add	a0,a5,a0
    89c8:	88a1a823          	sw	a0,-1904(gp) # 520e0 <heap_end.1518>
    89cc:	00078513          	mv	a0,a5
    89d0:	00008067          	ret
    89d4:	22018793          	addi	a5,gp,544 # 52a70 <_end>
    89d8:	00a78533          	add	a0,a5,a0
    89dc:	88a1a823          	sw	a0,-1904(gp) # 520e0 <heap_end.1518>
    89e0:	00078513          	mv	a0,a5
    89e4:	00008067          	ret
