
build/efx-gmsl-video-grabber-hdmi.elf:     file format elf32-littleriscv


Disassembly of section .init:

00001000 <_start>:

_start:
#ifdef USE_GP
.option push
.option norelax
	la gp, __global_pointer$
    1000:	00052197          	auipc	gp,0x52
    1004:	a3018193          	addi	gp,gp,-1488 # 52a30 <__global_pointer$>

00001008 <init>:
	sw a0, smp_lottery_lock, a1
    ret
#endif

init:
	la sp, _sp
    1008:	00053117          	auipc	sp,0x53
    100c:	c2810113          	addi	sp,sp,-984 # 53c30 <__freertos_irq_stack_top>

	/* Load data section */
	la a0, _data_lma
    1010:	00008517          	auipc	a0,0x8
    1014:	a9850513          	addi	a0,a0,-1384 # 8aa8 <_data>
	la a1, _data
    1018:	00008597          	auipc	a1,0x8
    101c:	a9058593          	addi	a1,a1,-1392 # 8aa8 <_data>
	la a2, _edata
    1020:	84818613          	addi	a2,gp,-1976 # 52278 <__bss_start>
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
    103c:	84818513          	addi	a0,gp,-1976 # 52278 <__bss_start>
	la a1, _end
    1040:	20018593          	addi	a1,gp,512 # 52c30 <_end>
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
    1058:	2a0040ef          	jal	ra,52f8 <main>

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
    1074:	a3840413          	addi	s0,s0,-1480 # 8aa8 <_data>
    1078:	00008917          	auipc	s2,0x8
    107c:	a3090913          	addi	s2,s2,-1488 # 8aa8 <_data>
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
    10b0:	9fc40413          	addi	s0,s0,-1540 # 8aa8 <_data>
    10b4:	00008917          	auipc	s2,0x8
    10b8:	9f490913          	addi	s2,s2,-1548 # 8aa8 <_data>
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
    10f8:	83418793          	addi	a5,gp,-1996 # 52264 <_impure_ptr>
    10fc:	00050593          	mv	a1,a0
    1100:	0007a503          	lw	a0,0(a5)
    1104:	0140006f          	j	1118 <_malloc_r>

00001108 <free>:
    1108:	83418793          	addi	a5,gp,-1996 # 52264 <_impure_ptr>
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
    1170:	00051997          	auipc	s3,0x51
    1174:	8a098993          	addi	s3,s3,-1888 # 51a10 <__malloc_av_>
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
    11f8:	00051997          	auipc	s3,0x51
    11fc:	81898993          	addi	s3,s3,-2024 # 51a10 <__malloc_av_>
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
    124c:	7d080813          	addi	a6,a6,2000 # 51a18 <__malloc_av_+0x8>
    1250:	1b040863          	beq	s0,a6,1400 <_malloc_r+0x2e8>
    1254:	00442583          	lw	a1,4(s0)
    1258:	00f00713          	li	a4,15
    125c:	ffc5f593          	andi	a1,a1,-4
    1260:	409587b3          	sub	a5,a1,s1
    1264:	44f74263          	blt	a4,a5,16a8 <_malloc_r+0x590>
    1268:	00050717          	auipc	a4,0x50
    126c:	7b072e23          	sw	a6,1980(a4) # 51a24 <__malloc_av_+0x14>
    1270:	00050717          	auipc	a4,0x50
    1274:	7b072823          	sw	a6,1968(a4) # 51a20 <__malloc_av_+0x10>
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
    12bc:	74e5ae23          	sw	a4,1884(a1) # 51a14 <__malloc_av_+0x4>
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
    1360:	6c96a423          	sw	s1,1736(a3) # 51a24 <__malloc_av_+0x14>
    1364:	00050697          	auipc	a3,0x50
    1368:	6a96ae23          	sw	s1,1724(a3) # 51a20 <__malloc_av_+0x10>
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
    13f8:	62480813          	addi	a6,a6,1572 # 51a18 <__malloc_av_+0x8>
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
    1430:	86c18793          	addi	a5,gp,-1940 # 5229c <__malloc_top_pad>
    1434:	82c18c13          	addi	s8,gp,-2004 # 5225c <__malloc_sbrk_base>
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
    1480:	87418c93          	addi	s9,gp,-1932 # 522a4 <__malloc_current_mallinfo>
    1484:	000ca783          	lw	a5,0(s9)
    1488:	00fa87b3          	add	a5,s5,a5
    148c:	86f1aa23          	sw	a5,-1932(gp) # 522a4 <__malloc_current_mallinfo>
    1490:	00078713          	mv	a4,a5
    1494:	3aaa0663          	beq	s4,a0,1840 <_malloc_r+0x728>
    1498:	000c2683          	lw	a3,0(s8)
    149c:	fff00793          	li	a5,-1
    14a0:	3af68e63          	beq	a3,a5,185c <_malloc_r+0x744>
    14a4:	414b07b3          	sub	a5,s6,s4
    14a8:	00e787b3          	add	a5,a5,a4
    14ac:	86f1aa23          	sw	a5,-1932(gp) # 522a4 <__malloc_current_mallinfo>
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
    1504:	51672c23          	sw	s6,1304(a4) # 51a18 <__malloc_av_+0x8>
    1508:	001aea93          	ori	s5,s5,1
    150c:	00fa07b3          	add	a5,s4,a5
    1510:	86f1aa23          	sw	a5,-1932(gp) # 522a4 <__malloc_current_mallinfo>
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
    1558:	86418713          	addi	a4,gp,-1948 # 52294 <__malloc_max_sbrked_mem>
    155c:	00072703          	lw	a4,0(a4)
    1560:	00f77463          	bgeu	a4,a5,1568 <_malloc_r+0x450>
    1564:	86f1a223          	sw	a5,-1948(gp) # 52294 <__malloc_max_sbrked_mem>
    1568:	86818713          	addi	a4,gp,-1944 # 52298 <__malloc_max_total_mem>
    156c:	00072703          	lw	a4,0(a4)
    1570:	18f77e63          	bgeu	a4,a5,170c <_malloc_r+0x5f4>
    1574:	86f1a423          	sw	a5,-1944(gp) # 52298 <__malloc_max_total_mem>
    1578:	1940006f          	j	170c <_malloc_r+0x5f4>
    157c:	0014e713          	ori	a4,s1,1
    1580:	00e42223          	sw	a4,4(s0)
    1584:	009404b3          	add	s1,s0,s1
    1588:	00050717          	auipc	a4,0x50
    158c:	48972823          	sw	s1,1168(a4) # 51a18 <__malloc_av_+0x8>
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
    16b8:	36972823          	sw	s1,880(a4) # 51a24 <__malloc_av_+0x14>
    16bc:	00050717          	auipc	a4,0x50
    16c0:	36972223          	sw	s1,868(a4) # 51a20 <__malloc_av_+0x10>
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
    1768:	2af72823          	sw	a5,688(a4) # 51a14 <__malloc_av_+0x4>
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
    17b8:	26e5a023          	sw	a4,608(a1) # 51a14 <__malloc_av_+0x4>
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
    182c:	87418c93          	addi	s9,gp,-1932 # 522a4 <__malloc_current_mallinfo>
    1830:	000ca783          	lw	a5,0(s9)
    1834:	00fa8733          	add	a4,s5,a5
    1838:	86e1aa23          	sw	a4,-1932(gp) # 522a4 <__malloc_current_mallinfo>
    183c:	c5dff06f          	j	1498 <_malloc_r+0x380>
    1840:	014a1693          	slli	a3,s4,0x14
    1844:	c4069ae3          	bnez	a3,1498 <_malloc_r+0x380>
    1848:	0089a403          	lw	s0,8(s3)
    184c:	015b8ab3          	add	s5,s7,s5
    1850:	001aea93          	ori	s5,s5,1
    1854:	01542223          	sw	s5,4(s0)
    1858:	d01ff06f          	j	1558 <_malloc_r+0x440>
    185c:	8361a623          	sw	s6,-2004(gp) # 5225c <__malloc_sbrk_base>
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
    1a8c:	83418793          	addi	a5,gp,-1996 # 52264 <_impure_ptr>
    1a90:	0007a783          	lw	a5,0(a5)
    1a94:	0aa7a423          	sw	a0,168(a5)
    1a98:	0a07a623          	sw	zero,172(a5)
    1a9c:	00008067          	ret

00001aa0 <rand>:
    1aa0:	83418793          	addi	a5,gp,-1996 # 52264 <_impure_ptr>
    1aa4:	0007a803          	lw	a6,0(a5)
    1aa8:	4c9585b7          	lui	a1,0x4c958
    1aac:	f2d58593          	addi	a1,a1,-211 # 4c957f2d <__freertos_irq_stack_top+0x4c9042fd>
    1ab0:	0a882683          	lw	a3,168(a6)
    1ab4:	0ac82703          	lw	a4,172(a6)
    1ab8:	02b687b3          	mul	a5,a3,a1
    1abc:	00178613          	addi	a2,a5,1
    1ac0:	00f637b3          	sltu	a5,a2,a5
    1ac4:	0ac82423          	sw	a2,168(a6)
    1ac8:	5851f637          	lui	a2,0x5851f
    1acc:	42d60613          	addi	a2,a2,1069 # 5851f42d <__freertos_irq_stack_top+0x584cb7fd>
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
    1b08:	1e01ac23          	sw	zero,504(gp) # 52c28 <errno>
    1b0c:	00112623          	sw	ra,12(sp)
    1b10:	73d060ef          	jal	ra,8a4c <_sbrk>
    1b14:	fff00793          	li	a5,-1
    1b18:	00f50a63          	beq	a0,a5,1b2c <_sbrk_r+0x34>
    1b1c:	00c12083          	lw	ra,12(sp)
    1b20:	00812403          	lw	s0,8(sp)
    1b24:	01010113          	addi	sp,sp,16
    1b28:	00008067          	ret
    1b2c:	1f818793          	addi	a5,gp,504 # 52c28 <errno>
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
    1b6c:	ea898993          	addi	s3,s3,-344 # 51a10 <__malloc_av_>
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
    1bf8:	87418793          	addi	a5,gp,-1932 # 522a4 <__malloc_current_mallinfo>
    1bfc:	0007a783          	lw	a5,0(a5)
    1c00:	0089a703          	lw	a4,8(s3)
    1c04:	408484b3          	sub	s1,s1,s0
    1c08:	0014e493          	ori	s1,s1,1
    1c0c:	40878433          	sub	s0,a5,s0
    1c10:	00090513          	mv	a0,s2
    1c14:	00972223          	sw	s1,4(a4)
    1c18:	8681aa23          	sw	s0,-1932(gp) # 522a4 <__malloc_current_mallinfo>
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
    1c5c:	82c18693          	addi	a3,gp,-2004 # 5225c <__malloc_sbrk_base>
    1c60:	0006a683          	lw	a3,0(a3)
    1c64:	0017e793          	ori	a5,a5,1
    1c68:	00f72223          	sw	a5,4(a4)
    1c6c:	40d50533          	sub	a0,a0,a3
    1c70:	86a1aa23          	sw	a0,-1932(gp) # 522a4 <__malloc_current_mallinfo>
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
    1ca4:	d7050513          	addi	a0,a0,-656 # 51a10 <__malloc_av_>
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
    1cdc:	d4088893          	addi	a7,a7,-704 # 51a18 <__malloc_av_+0x8>
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
    1d50:	ccf6a423          	sw	a5,-824(a3) # 51a14 <__malloc_av_+0x4>
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
    1d88:	c9488893          	addi	a7,a7,-876 # 51a18 <__malloc_av_+0x8>
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
    1e8c:	83018693          	addi	a3,gp,-2000 # 52260 <__malloc_trim_threshold>
    1e90:	0017e613          	ori	a2,a5,1
    1e94:	0006a683          	lw	a3,0(a3)
    1e98:	00c72223          	sw	a2,4(a4)
    1e9c:	00050617          	auipc	a2,0x50
    1ea0:	b6e62e23          	sw	a4,-1156(a2) # 51a18 <__malloc_av_+0x8>
    1ea4:	ead7ece3          	bltu	a5,a3,1d5c <_free_r+0xe4>
    1ea8:	86c18793          	addi	a5,gp,-1940 # 5229c <__malloc_top_pad>
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
    1efc:	b2e6a623          	sw	a4,-1236(a3) # 51a24 <__malloc_av_+0x14>
    1f00:	00050697          	auipc	a3,0x50
    1f04:	b2e6a023          	sw	a4,-1248(a3) # 51a20 <__malloc_av_+0x10>
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
    1f34:	aec7a223          	sw	a2,-1308(a5) # 51a14 <__malloc_av_+0x4>
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
    1fd0:	83418793          	addi	a5,gp,-1996 # 52264 <_impure_ptr>
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
    20e4:	24078793          	addi	a5,a5,576 # f4240 <__freertos_irq_stack_top+0xa0610>
    20e8:	02f5d5b3          	divu	a1,a1,a5
    readReg_u32 (clint_getTimeLow , CLINT_TIME_ADDR)
    20ec:	0000c7b7          	lui	a5,0xc
    20f0:	ff878793          	addi	a5,a5,-8 # bff8 <raw_table4+0x24d8>
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
    222c:	0087a783          	lw	a5,8(a5) # f8120008 <__freertos_irq_stack_top+0xf80cc3d8>
	while(read_u32(PROBE_ADDR+0x008)&0x1) {
    2230:	0017f793          	andi	a5,a5,1
    2234:	0c078063          	beqz	a5,22f4 <sd_ctrl_cmd+0x1b0>
		bsp_uDelay(1);
    2238:	f8b00637          	lui	a2,0xf8b00
    223c:	05f5e5b7          	lui	a1,0x5f5e
    2240:	10058593          	addi	a1,a1,256 # 5f5e100 <__freertos_irq_stack_top+0x5f0a4d0>
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
    2280:	ffa70713          	addi	a4,a4,-6 # 1ffffa <__freertos_irq_stack_top+0x1ac3ca>
    2284:	01071613          	slli	a2,a4,0x10
    2288:	01065613          	srli	a2,a2,0x10
    228c:	01300693          	li	a3,19
    2290:	f8c6e2e3          	bltu	a3,a2,2214 <sd_ctrl_cmd+0xd0>
    2294:	00261713          	slli	a4,a2,0x2
    2298:	000096b7          	lui	a3,0x9
    229c:	aa868693          	addi	a3,a3,-1368 # 8aa8 <_data>
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
    230c:	10058593          	addi	a1,a1,256 # 5f5e100 <__freertos_irq_stack_top+0x5f0a4d0>
    2310:	06400513          	li	a0,100
    2314:	dcdff0ef          	jal	ra,20e0 <clint_uDelay>
		if(IntPtr.command_complete == 0x1) {
    2318:	bb41a703          	lw	a4,-1100(gp) # 525e4 <IntPtr>
    231c:	00100793          	li	a5,1
    2320:	fef71ce3          	bne	a4,a5,2318 <sd_ctrl_cmd+0x1d4>
			IntPtr.command_complete = 0x0;
    2324:	bb418793          	addi	a5,gp,-1100 # 525e4 <IntPtr>
    2328:	0007a023          	sw	zero,0(a5)
			if((IntPtr.command_timeout_error == 0x0) && (IntPtr.command_crc_error == 0x0) &&
    232c:	01c7a783          	lw	a5,28(a5)
    2330:	0a079263          	bnez	a5,23d4 <sd_ctrl_cmd+0x290>
    2334:	bb418793          	addi	a5,gp,-1100 # 525e4 <IntPtr>
    2338:	0207a783          	lw	a5,32(a5)
    233c:	08079c63          	bnez	a5,23d4 <sd_ctrl_cmd+0x290>
			   (IntPtr.command_end_bit_error == 0x0) && (IntPtr.command_index_error == 0x0))  {
    2340:	bb418793          	addi	a5,gp,-1100 # 525e4 <IntPtr>
    2344:	0247a783          	lw	a5,36(a5)
			if((IntPtr.command_timeout_error == 0x0) && (IntPtr.command_crc_error == 0x0) &&
    2348:	08079663          	bnez	a5,23d4 <sd_ctrl_cmd+0x290>
			   (IntPtr.command_end_bit_error == 0x0) && (IntPtr.command_index_error == 0x0))  {
    234c:	bb418793          	addi	a5,gp,-1100 # 525e4 <IntPtr>
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
    23d4:	bb418793          	addi	a5,gp,-1100 # 525e4 <IntPtr>
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
    2458:	a9c18513          	addi	a0,gp,-1380 # 524cc <Descriptor>
    245c:	d4cff0ef          	jal	ra,19a8 <memset>
	memset(DataDescriptor,0,sizeof(DataDescriptor));
    2460:	10000613          	li	a2,256
    2464:	00000593          	li	a1,0
    2468:	99c18513          	addi	a0,gp,-1636 # 523cc <DataDescriptor>
    246c:	d3cff0ef          	jal	ra,19a8 <memset>
	memset(AttributeDescriptor,0,sizeof(AttributeDescriptor));
    2470:	10000613          	li	a2,256
    2474:	00000593          	li	a1,0
    2478:	00052537          	lui	a0,0x52
    247c:	2cc50513          	addi	a0,a0,716 # 522cc <AttributeDescriptor>
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
    24b8:	a9c18713          	addi	a4,gp,-1380 # 524cc <Descriptor>
    24bc:	00e788b3          	add	a7,a5,a4
    24c0:	00269813          	slli	a6,a3,0x2
    24c4:	99c18513          	addi	a0,gp,-1636 # 523cc <DataDescriptor>
    24c8:	01050533          	add	a0,a0,a6
    24cc:	01152023          	sw	a7,0(a0)
        *((volatile u32*) address) = data;
    24d0:	00b8a023          	sw	a1,0(a7)
		AttributeDescriptor[n]=((u32)Descriptor)+sizeof(u32)+(sizeof(u32)*2*n);
    24d4:	00470713          	addi	a4,a4,4 # 200004 <__freertos_irq_stack_top+0x1ac3d4>
    24d8:	00f707b3          	add	a5,a4,a5
    24dc:	00052737          	lui	a4,0x52
    24e0:	2cc70713          	addi	a4,a4,716 # 522cc <AttributeDescriptor>
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
    2528:	99c1a603          	lw	a2,-1636(gp) # 523cc <DataDescriptor>
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
    2588:	0007a023          	sw	zero,0(a5) # 10000 <raw_table4+0x64e0>
	if(data->blocks == 0x1) {
    258c:	00862703          	lw	a4,8(a2) # f8b00008 <__freertos_irq_stack_top+0xf8aac3d8>
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
    2720:	10058593          	addi	a1,a1,256 # 5f5e100 <__freertos_irq_stack_top+0x5f0a4d0>
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
    2764:	10058593          	addi	a1,a1,256 # 5f5e100 <__freertos_irq_stack_top+0x5f0a4d0>
    2768:	00100513          	li	a0,1
    276c:	975ff0ef          	jal	ra,20e0 <clint_uDelay>
				if(sd_ctrl_read(dev,SDHC_ADDR+REG_PRESENT_STATE)&0x800) {
    2770:	fd1ff06f          	j	2740 <sd_ctrl_data+0x1e8>
		if(IntPtr.transfer_complete == 0x1) {
    2774:	bb418793          	addi	a5,gp,-1100 # 525e4 <IntPtr>
    2778:	0047a703          	lw	a4,4(a5)
    277c:	00100793          	li	a5,1
    2780:	fef71ae3          	bne	a4,a5,2774 <sd_ctrl_data+0x21c>
			IntPtr.transfer_complete = 0x0;
    2784:	bb418793          	addi	a5,gp,-1100 # 525e4 <IntPtr>
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
    2890:	6a078793          	addi	a5,a5,1696 # 186a0 <raw_table3+0x5e8>
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
    28b0:	10058593          	addi	a1,a1,256 # 5f5e100 <__freertos_irq_stack_top+0x5f0a4d0>
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
    2a24:	35078793          	addi	a5,a5,848 # c350 <raw_table4+0x2830>
    2a28:	00f4a223          	sw	a5,4(s1)
	dev->TransModePtr = ptr;
    2a2c:	0124aa23          	sw	s2,20(s1)

	mmc->priv = dev;
    2a30:	00942423          	sw	s1,8(s0)
	mmc->cfg->name = "efx_sd_contorller";
    2a34:	00042683          	lw	a3,0(s0)
    2a38:	00009737          	lui	a4,0x9
    2a3c:	af870713          	addi	a4,a4,-1288 # 8af8 <_data+0x50>
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
    2ab4:	00e7ac23          	sw	a4,24(a5) # 20000018 <__freertos_irq_stack_top+0x1ffac3e8>
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
    2b1c:	00072783          	lw	a5,0(a4) # 300000 <__freertos_irq_stack_top+0x2ac3d0>
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
    2c00:	00f72023          	sw	a5,0(a4) # f8017000 <__freertos_irq_stack_top+0xf7fc33d0>

    i2c_txByte(I2C_CTRL_MIPI, PiCam_I2C_addr<<1);
	i2c_txNackBlocking(I2C_CTRL_MIPI);
    2c04:	f8017537          	lui	a0,0xf8017
    2c08:	f81ff0ef          	jal	ra,2b88 <i2c_txNackBlocking>
	if (assert(i2c_rxAck(I2C_CTRL_MIPI)) ) // Optional check
    2c0c:	f8017537          	lui	a0,0xf8017
    2c10:	fb5ff0ef          	jal	ra,2bc4 <i2c_rxAck>
    2c14:	03d020ef          	jal	ra,5450 <assert>
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
    2c4c:	00f72023          	sw	a5,0(a4) # f8017000 <__freertos_irq_stack_top+0xf7fc33d0>
	i2c_txNackBlocking(I2C_CTRL_MIPI);
    2c50:	f8017537          	lui	a0,0xf8017
    2c54:	f35ff0ef          	jal	ra,2b88 <i2c_txNackBlocking>
	if (assert(i2c_rxAck(I2C_CTRL_MIPI)) ) // Optional check
    2c58:	f8017537          	lui	a0,0xf8017
    2c5c:	f69ff0ef          	jal	ra,2bc4 <i2c_rxAck>
    2c60:	7f0020ef          	jal	ra,5450 <assert>
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
    2c84:	0087a023          	sw	s0,0(a5) # f8017000 <__freertos_irq_stack_top+0xf7fc33d0>
	i2c_txNackBlocking(I2C_CTRL_MIPI);
    2c88:	f8017537          	lui	a0,0xf8017
    2c8c:	efdff0ef          	jal	ra,2b88 <i2c_txNackBlocking>
	if (assert(i2c_rxAck(I2C_CTRL_MIPI)) ) // Optional check
    2c90:	f8017537          	lui	a0,0xf8017
    2c94:	f31ff0ef          	jal	ra,2bc4 <i2c_rxAck>
    2c98:	7b8020ef          	jal	ra,5450 <assert>
    2c9c:	00050663          	beqz	a0,2ca8 <PiCam_WriteRegData+0xd4>
		return 1;
    2ca0:	00100413          	li	s0,1
    2ca4:	f7dff06f          	j	2c20 <PiCam_WriteRegData+0x4c>
    2ca8:	000017b7          	lui	a5,0x1
    2cac:	b0078793          	addi	a5,a5,-1280 # b00 <CUSTOM2+0xaa5>
    2cb0:	00f4e4b3          	or	s1,s1,a5
    2cb4:	f80177b7          	lui	a5,0xf8017
    2cb8:	0097a023          	sw	s1,0(a5) # f8017000 <__freertos_irq_stack_top+0xf7fc33d0>
	i2c_txNackBlocking(I2C_CTRL_MIPI);
    2cbc:	f8017537          	lui	a0,0xf8017
    2cc0:	ec9ff0ef          	jal	ra,2b88 <i2c_txNackBlocking>
	if (assert(i2c_rxAck(I2C_CTRL_MIPI)) ) // Optional check
    2cc4:	f8017537          	lui	a0,0xf8017
    2cc8:	efdff0ef          	jal	ra,2bc4 <i2c_rxAck>
    2ccc:	784020ef          	jal	ra,5450 <assert>
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
    2d1c:	00f92023          	sw	a5,0(s2) # f8017000 <__freertos_irq_stack_top+0xf7fc33d0>

    i2c_txByte(I2C_CTRL_MIPI, PiCam_I2C_addr<<1);
	i2c_txNackBlocking(I2C_CTRL_MIPI);
    2d20:	f8017537          	lui	a0,0xf8017
    2d24:	e65ff0ef          	jal	ra,2b88 <i2c_txNackBlocking>
	assert(i2c_rxAck(I2C_CTRL_MIPI)); // Optional check
    2d28:	f8017537          	lui	a0,0xf8017
    2d2c:	e99ff0ef          	jal	ra,2bc4 <i2c_rxAck>
    2d30:	720020ef          	jal	ra,5450 <assert>

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
    2d54:	6fc020ef          	jal	ra,5450 <assert>

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
    2d74:	6dc020ef          	jal	ra,5450 <assert>

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
    2da0:	6b0020ef          	jal	ra,5450 <assert>
    2da4:	bff40413          	addi	s0,s0,-1025
    2da8:	00892023          	sw	s0,0(s2)

	i2c_txByte(I2C_CTRL_MIPI, 0xFF);
	i2c_txNackBlocking(I2C_CTRL_MIPI);
    2dac:	f8017537          	lui	a0,0xf8017
    2db0:	dd9ff0ef          	jal	ra,2b88 <i2c_txNackBlocking>
	assert(i2c_rxNack(I2C_CTRL_MIPI)); // Optional check
    2db4:	f8017537          	lui	a0,0xf8017
    2db8:	dfdff0ef          	jal	ra,2bb4 <i2c_rxNack>
    2dbc:	694020ef          	jal	ra,5450 <assert>
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
    354c:	1ea48513          	addi	a0,s1,490 # d1ea <raw_table4+0x36ca>
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
    357c:	00452503          	lw	a0,4(a0) # f8017004 <__freertos_irq_stack_top+0xf7fc33d4>
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
    368c:	00450513          	addi	a0,a0,4 # 200004 <__freertos_irq_stack_top+0x1ac3d4>
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
    36a8:	00450513          	addi	a0,a0,4 # 200004 <__freertos_irq_stack_top+0x1ac3d4>
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
    3714:	fff40413          	addi	s0,s0,-1 # 3fffffff <__freertos_irq_stack_top+0x3ffac3cf>
    3718:	00858433          	add	s0,a1,s0
    371c:	00241413          	slli	s0,s0,0x2
    3720:	02044663          	bltz	s0,374c <print_hexb+0x50>
        uart_write(BSP_UART_TERMINAL, "0123456789ABCDEF"[(val >> i) % 16]);
    3724:	0084d7b3          	srl	a5,s1,s0
    3728:	00f7f713          	andi	a4,a5,15
    372c:	000097b7          	lui	a5,0x9
    3730:	b0c78793          	addi	a5,a5,-1268 # 8b0c <_data+0x64>
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
    3774:	b9c1a503          	lw	a0,-1124(gp) # 525cc <dev>
    3778:	9adfe0ef          	jal	ra,2124 <sd_ctrl_write>
	int_status = sd_ctrl_read(dev,SDHC_ADDR+REG_NORMAL_INTERRUPT_STATUS0);
    377c:	13000593          	li	a1,304
    3780:	b9c1a503          	lw	a0,-1124(gp) # 525cc <dev>
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
    37f4:	b9c1a503          	lw	a0,-1124(gp) # 525cc <dev>
    37f8:	92dfe0ef          	jal	ra,2124 <sd_ctrl_write>
}
    37fc:	00c12083          	lw	ra,12(sp)
    3800:	00812403          	lw	s0,8(sp)
    3804:	01010113          	addi	sp,sp,16
    3808:	00008067          	ret
		IntPtr.command_complete = 0x1;
    380c:	00100713          	li	a4,1
    3810:	bae1aa23          	sw	a4,-1100(gp) # 525e4 <IntPtr>
		sd_ctrl_write(dev,SDHC_ADDR+REG_NORMAL_INTERRUPT_STATUS0,INT_COMMAND_COMPLETE);
    3814:	00100613          	li	a2,1
    3818:	13000593          	li	a1,304
    381c:	b9c1a503          	lw	a0,-1124(gp) # 525cc <dev>
    3820:	905fe0ef          	jal	ra,2124 <sd_ctrl_write>
		if(DEBUG_PRINTF_EN == 1) {
    3824:	f71ff06f          	j	3794 <UserInterruptSDIsr+0x34>
		IntPtr.transfer_complete = 0x1;
    3828:	bb418793          	addi	a5,gp,-1100 # 525e4 <IntPtr>
    382c:	00100713          	li	a4,1
    3830:	00e7a223          	sw	a4,4(a5)
		sd_ctrl_write(dev,SDHC_ADDR+REG_NORMAL_INTERRUPT_STATUS0,INT_TRANSFER_COMPLETE);
    3834:	00200613          	li	a2,2
    3838:	13000593          	li	a1,304
    383c:	b9c1a503          	lw	a0,-1124(gp) # 525cc <dev>
    3840:	8e5fe0ef          	jal	ra,2124 <sd_ctrl_write>
		if(DEBUG_PRINTF_EN == 1) {
    3844:	f59ff06f          	j	379c <UserInterruptSDIsr+0x3c>
		IntPtr.block_gap_event = 0x1;
    3848:	bb418793          	addi	a5,gp,-1100 # 525e4 <IntPtr>
    384c:	00100713          	li	a4,1
    3850:	00e7a423          	sw	a4,8(a5)
		sd_ctrl_write(dev,SDHC_ADDR+REG_NORMAL_INTERRUPT_STATUS0,INT_BLOCK_GAP_EVENT);
    3854:	00400613          	li	a2,4
    3858:	13000593          	li	a1,304
    385c:	b9c1a503          	lw	a0,-1124(gp) # 525cc <dev>
    3860:	8c5fe0ef          	jal	ra,2124 <sd_ctrl_write>
		if(DEBUG_PRINTF_EN == 1) {
    3864:	f41ff06f          	j	37a4 <UserInterruptSDIsr+0x44>
		sd_ctrl_write(dev,SDHC_ADDR+REG_NORMAL_INTERRUPT_STATUS0,INT_BUFFER_WRITE_READY);
    3868:	01000613          	li	a2,16
    386c:	13000593          	li	a1,304
    3870:	b9c1a503          	lw	a0,-1124(gp) # 525cc <dev>
    3874:	8b1fe0ef          	jal	ra,2124 <sd_ctrl_write>
		if(DEBUG_PRINTF_EN == 1) {
    3878:	f35ff06f          	j	37ac <UserInterruptSDIsr+0x4c>
		sd_ctrl_write(dev,SDHC_ADDR+REG_NORMAL_INTERRUPT_STATUS0,INT_BUFFER_READ_READY);
    387c:	02000613          	li	a2,32
    3880:	13000593          	li	a1,304
    3884:	b9c1a503          	lw	a0,-1124(gp) # 525cc <dev>
    3888:	89dfe0ef          	jal	ra,2124 <sd_ctrl_write>
		if(DEBUG_PRINTF_EN == 1) {
    388c:	f29ff06f          	j	37b4 <UserInterruptSDIsr+0x54>
		IntPtr.card_insertion = 0x1;
    3890:	bb418793          	addi	a5,gp,-1100 # 525e4 <IntPtr>
    3894:	00100713          	li	a4,1
    3898:	00e7aa23          	sw	a4,20(a5)
		sd_ctrl_write(dev,SDHC_ADDR+REG_NORMAL_INTERRUPT_STATUS0,INT_CARD_INSERTION);
    389c:	04000613          	li	a2,64
    38a0:	13000593          	li	a1,304
    38a4:	b9c1a503          	lw	a0,-1124(gp) # 525cc <dev>
    38a8:	87dfe0ef          	jal	ra,2124 <sd_ctrl_write>
		if(DEBUG_PRINTF_EN == 1) {
    38ac:	f11ff06f          	j	37bc <UserInterruptSDIsr+0x5c>
		IntPtr.card_removal = 0x1;
    38b0:	bb418793          	addi	a5,gp,-1100 # 525e4 <IntPtr>
    38b4:	00100713          	li	a4,1
    38b8:	00e7ac23          	sw	a4,24(a5)
		sd_ctrl_write(dev,SDHC_ADDR+REG_NORMAL_INTERRUPT_STATUS0,INT_CARD_REMOVAL);
    38bc:	08000613          	li	a2,128
    38c0:	13000593          	li	a1,304
    38c4:	b9c1a503          	lw	a0,-1124(gp) # 525cc <dev>
    38c8:	85dfe0ef          	jal	ra,2124 <sd_ctrl_write>
		if(DEBUG_PRINTF_EN == 1) {
    38cc:	ef9ff06f          	j	37c4 <UserInterruptSDIsr+0x64>
		IntPtr.command_timeout_error = 0x1;
    38d0:	bb418793          	addi	a5,gp,-1100 # 525e4 <IntPtr>
    38d4:	00100713          	li	a4,1
    38d8:	00e7ae23          	sw	a4,28(a5)
		sd_ctrl_write(dev,SDHC_ADDR+REG_NORMAL_INTERRUPT_STATUS0,INT_COMMAND_TIMEOUT_ERROR);
    38dc:	00010637          	lui	a2,0x10
    38e0:	13000593          	li	a1,304
    38e4:	b9c1a503          	lw	a0,-1124(gp) # 525cc <dev>
    38e8:	83dfe0ef          	jal	ra,2124 <sd_ctrl_write>
		if(DEBUG_PRINTF_EN == 1) {
    38ec:	ee1ff06f          	j	37cc <UserInterruptSDIsr+0x6c>
		IntPtr.command_crc_error = 0x1;
    38f0:	bb418793          	addi	a5,gp,-1100 # 525e4 <IntPtr>
    38f4:	00100713          	li	a4,1
    38f8:	02e7a023          	sw	a4,32(a5)
		sd_ctrl_write(dev,SDHC_ADDR+REG_NORMAL_INTERRUPT_STATUS0,INT_COMMAND_CRC_ERROR);
    38fc:	00020637          	lui	a2,0x20
    3900:	13000593          	li	a1,304
    3904:	b9c1a503          	lw	a0,-1124(gp) # 525cc <dev>
    3908:	81dfe0ef          	jal	ra,2124 <sd_ctrl_write>
		if(DEBUG_PRINTF_EN == 1) {
    390c:	ec9ff06f          	j	37d4 <UserInterruptSDIsr+0x74>
		IntPtr.command_end_bit_error = 0x1;
    3910:	bb418793          	addi	a5,gp,-1100 # 525e4 <IntPtr>
    3914:	00100713          	li	a4,1
    3918:	02e7a223          	sw	a4,36(a5)
		sd_ctrl_write(dev,SDHC_ADDR+REG_NORMAL_INTERRUPT_STATUS0,INT_COMMAND_END_BIT_ERROR);
    391c:	00040637          	lui	a2,0x40
    3920:	13000593          	li	a1,304
    3924:	b9c1a503          	lw	a0,-1124(gp) # 525cc <dev>
    3928:	ffcfe0ef          	jal	ra,2124 <sd_ctrl_write>
		if(DEBUG_PRINTF_EN == 1) {
    392c:	eb1ff06f          	j	37dc <UserInterruptSDIsr+0x7c>
		IntPtr.command_index_error = 0x1;
    3930:	bb418793          	addi	a5,gp,-1100 # 525e4 <IntPtr>
    3934:	00100713          	li	a4,1
    3938:	02e7a423          	sw	a4,40(a5)
		sd_ctrl_write(dev,SDHC_ADDR+REG_NORMAL_INTERRUPT_STATUS0,INT_COMMAND_INDEX_ERROR);
    393c:	00080637          	lui	a2,0x80
    3940:	13000593          	li	a1,304
    3944:	b9c1a503          	lw	a0,-1124(gp) # 525cc <dev>
    3948:	fdcfe0ef          	jal	ra,2124 <sd_ctrl_write>
		if(DEBUG_PRINTF_EN == 1) {
    394c:	e99ff06f          	j	37e4 <UserInterruptSDIsr+0x84>
		sd_ctrl_write(dev,SDHC_ADDR+REG_NORMAL_INTERRUPT_STATUS0,INT_DATA_CRC_ERROR);
    3950:	00200637          	lui	a2,0x200
    3954:	13000593          	li	a1,304
    3958:	b9c1a503          	lw	a0,-1124(gp) # 525cc <dev>
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
    39d8:	ba418713          	addi	a4,gp,-1116 # 525d4 <ChannelCount>
    39dc:	00072783          	lw	a5,0(a4)
    39e0:	00178793          	addi	a5,a5,1
    39e4:	00f72023          	sw	a5,0(a4)
		if(ChannelCount[0]>=10)
    39e8:	00900713          	li	a4,9
    39ec:	f8f75ae3          	bge	a4,a5,3980 <UserInterruptDMAIsr+0x1c>
			ChannelCount[0] =0;
    39f0:	ba01a223          	sw	zero,-1116(gp) # 525d4 <ChannelCount>
			flashled ^= 0x01;
    39f4:	ba01a783          	lw	a5,-1120(gp) # 525d0 <flashled>
    39f8:	0017c793          	xori	a5,a5,1
    39fc:	baf1a023          	sw	a5,-1120(gp) # 525d0 <flashled>
        *((volatile u32*) address) = data;
    3a00:	f8110737          	lui	a4,0xf8110
    3a04:	00f72223          	sw	a5,4(a4) # f8110004 <__freertos_irq_stack_top+0xf80bc3d4>
    3a08:	f79ff06f          	j	3980 <UserInterruptDMAIsr+0x1c>
		dmasg_interrupt_pending_clear(DMASG_BASE, DMASG_CHANNEL1, DMASG_CHANNEL_INTERRUPT_INPUT_PACKET_MASK);  //Disable dmasg channel interrupt
    3a0c:	01000613          	li	a2,16
    3a10:	00100593          	li	a1,1
    3a14:	f8130537          	lui	a0,0xf8130
    3a18:	ca1ff0ef          	jal	ra,36b8 <dmasg_interrupt_pending_clear>
		ChannelCount[1]++;
    3a1c:	ba418713          	addi	a4,gp,-1116 # 525d4 <ChannelCount>
    3a20:	00472783          	lw	a5,4(a4)
    3a24:	00178793          	addi	a5,a5,1
    3a28:	00f72223          	sw	a5,4(a4)
		if(ChannelCount[1]>=10)
    3a2c:	00900713          	li	a4,9
    3a30:	f6f752e3          	bge	a4,a5,3994 <UserInterruptDMAIsr+0x30>
			ChannelCount[1] =0;
    3a34:	ba418793          	addi	a5,gp,-1116 # 525d4 <ChannelCount>
    3a38:	0007a223          	sw	zero,4(a5)
			flashled ^= 0x02;
    3a3c:	ba01a783          	lw	a5,-1120(gp) # 525d0 <flashled>
    3a40:	0027c793          	xori	a5,a5,2
    3a44:	baf1a023          	sw	a5,-1120(gp) # 525d0 <flashled>
    3a48:	f8110737          	lui	a4,0xf8110
    3a4c:	00f72223          	sw	a5,4(a4) # f8110004 <__freertos_irq_stack_top+0xf80bc3d4>
    3a50:	f45ff06f          	j	3994 <UserInterruptDMAIsr+0x30>
		dmasg_interrupt_pending_clear(DMASG_BASE, DMASG_CHANNEL2, DMASG_CHANNEL_INTERRUPT_INPUT_PACKET_MASK);  //Disable dmasg channel interrupt
    3a54:	01000613          	li	a2,16
    3a58:	00200593          	li	a1,2
    3a5c:	f8130537          	lui	a0,0xf8130
    3a60:	c59ff0ef          	jal	ra,36b8 <dmasg_interrupt_pending_clear>
		ChannelCount[2]++;
    3a64:	ba418713          	addi	a4,gp,-1116 # 525d4 <ChannelCount>
    3a68:	00872783          	lw	a5,8(a4)
    3a6c:	00178793          	addi	a5,a5,1
    3a70:	00f72423          	sw	a5,8(a4)
		if(ChannelCount[2]>=10)
    3a74:	00900713          	li	a4,9
    3a78:	f2f758e3          	bge	a4,a5,39a8 <UserInterruptDMAIsr+0x44>
			ChannelCount[2] =0;
    3a7c:	ba418793          	addi	a5,gp,-1116 # 525d4 <ChannelCount>
    3a80:	0007a423          	sw	zero,8(a5)
			flashled ^= 0x04;
    3a84:	ba01a783          	lw	a5,-1120(gp) # 525d0 <flashled>
    3a88:	0047c793          	xori	a5,a5,4
    3a8c:	baf1a023          	sw	a5,-1120(gp) # 525d0 <flashled>
    3a90:	f8110737          	lui	a4,0xf8110
    3a94:	00f72223          	sw	a5,4(a4) # f8110004 <__freertos_irq_stack_top+0xf80bc3d4>
    3a98:	f11ff06f          	j	39a8 <UserInterruptDMAIsr+0x44>
		dmasg_interrupt_pending_clear(DMASG_BASE, DMASG_CHANNEL3, DMASG_CHANNEL_INTERRUPT_INPUT_PACKET_MASK);  //Disable dmasg channel interrupt
    3a9c:	01000613          	li	a2,16
    3aa0:	00300593          	li	a1,3
    3aa4:	f8130537          	lui	a0,0xf8130
    3aa8:	c11ff0ef          	jal	ra,36b8 <dmasg_interrupt_pending_clear>
		ChannelCount[3]++;
    3aac:	ba418713          	addi	a4,gp,-1116 # 525d4 <ChannelCount>
    3ab0:	00c72783          	lw	a5,12(a4)
    3ab4:	00178793          	addi	a5,a5,1
    3ab8:	00f72623          	sw	a5,12(a4)
		if(ChannelCount[3]>=10)
    3abc:	00900713          	li	a4,9
    3ac0:	eef75ee3          	bge	a4,a5,39bc <UserInterruptDMAIsr+0x58>
			ChannelCount[3] =0;
    3ac4:	ba418793          	addi	a5,gp,-1116 # 525d4 <ChannelCount>
    3ac8:	0007a623          	sw	zero,12(a5)
			flashled ^= 0x08;
    3acc:	ba01a783          	lw	a5,-1120(gp) # 525d0 <flashled>
    3ad0:	0087c793          	xori	a5,a5,8
    3ad4:	baf1a023          	sw	a5,-1120(gp) # 525d0 <flashled>
    3ad8:	f8110737          	lui	a4,0xf8110
    3adc:	00f72223          	sw	a5,4(a4) # f8110004 <__freertos_irq_stack_top+0xf80bc3d4>
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
    3af0:	b2058593          	addi	a1,a1,-1248 # 8b20 <_data+0x78>
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
    3b14:	b3050513          	addi	a0,a0,-1232 # 8b30 <_data+0x88>
    3b18:	bc5ff0ef          	jal	ra,36dc <printb>

	print_hexb(value, 8);
    3b1c:	00800593          	li	a1,8
    3b20:	00040513          	mv	a0,s0
    3b24:	bd9ff0ef          	jal	ra,36fc <print_hexb>
				printb(" \n\r");
    3b28:	00051537          	lui	a0,0x51
    3b2c:	7b850513          	addi	a0,a0,1976 # 517b8 <raw_table+0xe638>
    3b30:	badff0ef          	jal	ra,36dc <printb>
	uart_writeStr(UART_0, "\n*** CRASH ***\n");
    3b34:	000095b7          	lui	a1,0x9
    3b38:	b2058593          	addi	a1,a1,-1248 # 8b20 <_data+0x78>
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
    3b5c:	b3050513          	addi	a0,a0,-1232 # 8b30 <_data+0x88>
    3b60:	b7dff0ef          	jal	ra,36dc <printb>

	print_hexb(value, 8);
    3b64:	00800593          	li	a1,8
    3b68:	00040513          	mv	a0,s0
    3b6c:	b91ff0ef          	jal	ra,36fc <print_hexb>
				printb(" \n\r");
    3b70:	00051537          	lui	a0,0x51
    3b74:	7b850513          	addi	a0,a0,1976 # 517b8 <raw_table+0xe638>
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
    3be0:	b4050513          	addi	a0,a0,-1216 # 8b40 <_data+0x98>
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
    3c50:	b5450513          	addi	a0,a0,-1196 # 8b54 <_data+0xac>
    3c54:	a89ff0ef          	jal	ra,36dc <printb>
			crash_test( cause);
    3c58:	00048513          	mv	a0,s1
    3c5c:	ea5ff0ef          	jal	ra,3b00 <crash_test>
    3c60:	01f45913          	srli	s2,s0,0x1f
		printb("NoInt \n\r");
    3c64:	00009537          	lui	a0,0x9
    3c68:	b6850513          	addi	a0,a0,-1176 # 8b68 <_data+0xc0>
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
    3c88:	ba01a023          	sw	zero,-1120(gp) # 525d0 <flashled>
	for(int i=0; i<4 ;i++)
    3c8c:	00000713          	li	a4,0
    3c90:	0180006f          	j	3ca8 <IntcInitialize+0x28>
	{
		ChannelCount[i] = 0;
    3c94:	00271693          	slli	a3,a4,0x2
    3c98:	ba418793          	addi	a5,gp,-1116 # 525d4 <ChannelCount>
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
    3d0c:	51c78793          	addi	a5,a5,1308 # 851c <trap_entry>
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
    3d44:	00852503          	lw	a0,8(a0) # f8c00008 <__freertos_irq_stack_top+0xf8bac3d8>
    3d48:	b8a1ae23          	sw	a0,-1124(gp) # 525cc <dev>

	//enable User interrupts
	sd_ctrl_write(dev,SDHC_ADDR+REG_NORMAL_INTERRUPT_STATUS1,0x00);		//Clean All Interrupts Status
    3d4c:	00000613          	li	a2,0
    3d50:	13400593          	li	a1,308
    3d54:	bd0fe0ef          	jal	ra,2124 <sd_ctrl_write>
	sd_ctrl_write(dev,SDHC_ADDR+REG_NORMAL_INTERRUPT_STATUS1,INT_ENABLE);		//Enable All Interrupts Status
    3d58:	fcf00613          	li	a2,-49
    3d5c:	13400593          	li	a1,308
    3d60:	b9c1a503          	lw	a0,-1124(gp) # 525cc <dev>
    3d64:	bc0fe0ef          	jal	ra,2124 <sd_ctrl_write>
	sd_ctrl_write(dev,SDHC_ADDR+REG_NORMAL_INTERRUPT_STATUS1+4,INT_ENABLE);		//Open All Interrupts Signal
    3d68:	fcf00613          	li	a2,-49
    3d6c:	13800593          	li	a1,312
    3d70:	b9c1a503          	lw	a0,-1124(gp) # 525cc <dev>
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

00003e58 <clint_getTime>:
    static u64 clint_getTime(u32 p){
    3e58:	00050693          	mv	a3,a0
    readReg_u32 (clint_getTimeHigh, CLINT_TIME_ADDR+4)
    3e5c:	0000c7b7          	lui	a5,0xc
    3e60:	ffc78713          	addi	a4,a5,-4 # bffc <raw_table4+0x24dc>
    3e64:	00e68733          	add	a4,a3,a4
    3e68:	00072583          	lw	a1,0(a4)
    readReg_u32 (clint_getTimeLow , CLINT_TIME_ADDR)
    3e6c:	ff878793          	addi	a5,a5,-8
    3e70:	00f687b3          	add	a5,a3,a5
    3e74:	0007a503          	lw	a0,0(a5)
    3e78:	00072783          	lw	a5,0(a4)
        } while (clint_getTimeHigh(p) != hi);
    3e7c:	feb790e3          	bne	a5,a1,3e5c <clint_getTime+0x4>
    }
    3e80:	00008067          	ret

00003e84 <clint_uDelay>:
        u32 mTimePerUsec = hz/1000000;
    3e84:	000f47b7          	lui	a5,0xf4
    3e88:	24078793          	addi	a5,a5,576 # f4240 <__freertos_irq_stack_top+0xa0610>
    3e8c:	02f5d5b3          	divu	a1,a1,a5
    readReg_u32 (clint_getTimeLow , CLINT_TIME_ADDR)
    3e90:	0000c7b7          	lui	a5,0xc
    3e94:	ff878793          	addi	a5,a5,-8 # bff8 <raw_table4+0x24d8>
    3e98:	00f60633          	add	a2,a2,a5
    3e9c:	00062783          	lw	a5,0(a2) # 200000 <__freertos_irq_stack_top+0x1ac3d0>
        u32 limit = clint_getTimeLow(reg) + usec*mTimePerUsec;
    3ea0:	02a58533          	mul	a0,a1,a0
    3ea4:	00f50533          	add	a0,a0,a5
    3ea8:	00062783          	lw	a5,0(a2)
        while((int32_t)(limit-(clint_getTimeLow(reg))) >= 0);
    3eac:	40f507b3          	sub	a5,a0,a5
    3eb0:	fe07dce3          	bgez	a5,3ea8 <clint_uDelay+0x24>
    3eb4:	00008067          	ret

00003eb8 <_putchar>:
#include <math.h>
#include <string.h>
#include "bsp.h"

#if (ENABLE_BSP_PRINTF)
    static void _putchar(char character){
    3eb8:	ff010113          	addi	sp,sp,-16
    3ebc:	00112623          	sw	ra,12(sp)
        #if (ENABLE_SEMIHOSTING_PRINT == 1)
            sh_writec(character);
        #else
            bsp_putChar(character);
    3ec0:	00050593          	mv	a1,a0
    3ec4:	f8010537          	lui	a0,0xf8010
    3ec8:	eddff0ef          	jal	ra,3da4 <uart_write>
        #endif // (ENABLE_SEMIHOSTING_PRINT == 1)
    }
    3ecc:	00c12083          	lw	ra,12(sp)
    3ed0:	01010113          	addi	sp,sp,16
    3ed4:	00008067          	ret

00003ed8 <_putchar_s>:

    static void _putchar_s(char *p)
    {
    3ed8:	ff010113          	addi	sp,sp,-16
    3edc:	00112623          	sw	ra,12(sp)
    3ee0:	00812423          	sw	s0,8(sp)
    3ee4:	00050413          	mv	s0,a0
    #if (ENABLE_SEMIHOSTING_PRINT == 1)
        sh_write0(p);
    #else
        while (*p)
    3ee8:	00044503          	lbu	a0,0(s0)
    3eec:	00050863          	beqz	a0,3efc <_putchar_s+0x24>
            _putchar(*(p++));
    3ef0:	00140413          	addi	s0,s0,1
    3ef4:	fc5ff0ef          	jal	ra,3eb8 <_putchar>
    3ef8:	ff1ff06f          	j	3ee8 <_putchar_s+0x10>
    #endif // (ENABLE_SEMIHOSTING_PRINT == 1)
    }
    3efc:	00c12083          	lw	ra,12(sp)
    3f00:	00812403          	lw	s0,8(sp)
    3f04:	01010113          	addi	sp,sp,16
    3f08:	00008067          	ret

00003f0c <bsp_printHex>:

        static void bsp_printHex(uint32_t val)
    {
    3f0c:	ff010113          	addi	sp,sp,-16
    3f10:	00112623          	sw	ra,12(sp)
    3f14:	00812423          	sw	s0,8(sp)
    3f18:	00912223          	sw	s1,4(sp)
    3f1c:	00050493          	mv	s1,a0
        uint32_t digits;
        digits =8;

        for (int i = (4*digits)-4; i >= 0; i -= 4) {
    3f20:	01c00413          	li	s0,28
    3f24:	0240006f          	j	3f48 <bsp_printHex+0x3c>
            _putchar("0123456789ABCDEF"[(val >> i) % 16]);
    3f28:	0084d7b3          	srl	a5,s1,s0
    3f2c:	00f7f713          	andi	a4,a5,15
    3f30:	000097b7          	lui	a5,0x9
    3f34:	b0c78793          	addi	a5,a5,-1268 # 8b0c <_data+0x64>
    3f38:	00e787b3          	add	a5,a5,a4
    3f3c:	0007c503          	lbu	a0,0(a5)
    3f40:	f79ff0ef          	jal	ra,3eb8 <_putchar>
        for (int i = (4*digits)-4; i >= 0; i -= 4) {
    3f44:	ffc40413          	addi	s0,s0,-4
    3f48:	fe0450e3          	bgez	s0,3f28 <bsp_printHex+0x1c>
        }
    }
    3f4c:	00c12083          	lw	ra,12(sp)
    3f50:	00812403          	lw	s0,8(sp)
    3f54:	00412483          	lw	s1,4(sp)
    3f58:	01010113          	addi	sp,sp,16
    3f5c:	00008067          	ret

00003f60 <bsp_printHex_lower>:

    static void bsp_printHex_lower(uint32_t val)
    {
    3f60:	ff010113          	addi	sp,sp,-16
    3f64:	00112623          	sw	ra,12(sp)
    3f68:	00812423          	sw	s0,8(sp)
    3f6c:	00912223          	sw	s1,4(sp)
    3f70:	00050493          	mv	s1,a0
        uint32_t digits;
        digits =8;

        for (int i = (4*digits)-4; i >= 0; i -= 4) {
    3f74:	01c00413          	li	s0,28
    3f78:	0240006f          	j	3f9c <bsp_printHex_lower+0x3c>
            _putchar("0123456789abcdef"[(val >> i) % 16]);
    3f7c:	0084d7b3          	srl	a5,s1,s0
    3f80:	00f7f713          	andi	a4,a5,15
    3f84:	000097b7          	lui	a5,0x9
    3f88:	b7478793          	addi	a5,a5,-1164 # 8b74 <_data+0xcc>
    3f8c:	00e787b3          	add	a5,a5,a4
    3f90:	0007c503          	lbu	a0,0(a5)
    3f94:	f25ff0ef          	jal	ra,3eb8 <_putchar>
        for (int i = (4*digits)-4; i >= 0; i -= 4) {
    3f98:	ffc40413          	addi	s0,s0,-4
    3f9c:	fe0450e3          	bgez	s0,3f7c <bsp_printHex_lower+0x1c>

        }
    }
    3fa0:	00c12083          	lw	ra,12(sp)
    3fa4:	00812403          	lw	s0,8(sp)
    3fa8:	00412483          	lw	s1,4(sp)
    3fac:	01010113          	addi	sp,sp,16
    3fb0:	00008067          	ret

00003fb4 <bsp_printf_c>:
*
* @param c: The character to be output.
*
******************************************************************************/
    static void bsp_printf_c(int c)
    {
    3fb4:	ff010113          	addi	sp,sp,-16
    3fb8:	00112623          	sw	ra,12(sp)
        _putchar(c);
    3fbc:	0ff57513          	andi	a0,a0,255
    3fc0:	ef9ff0ef          	jal	ra,3eb8 <_putchar>
    }
    3fc4:	00c12083          	lw	ra,12(sp)
    3fc8:	01010113          	addi	sp,sp,16
    3fcc:	00008067          	ret

00003fd0 <bsp_printf_s>:
*
* @param s: A pointer to the null-terminated string to be output.
*
*******************************************************************************/
    static void bsp_printf_s(char *p)
    {
    3fd0:	ff010113          	addi	sp,sp,-16
    3fd4:	00112623          	sw	ra,12(sp)
        _putchar_s(p);
    3fd8:	f01ff0ef          	jal	ra,3ed8 <_putchar_s>
    }
    3fdc:	00c12083          	lw	ra,12(sp)
    3fe0:	01010113          	addi	sp,sp,16
    3fe4:	00008067          	ret

00003fe8 <bsp_printf_d>:
* - Handles negative numbers by printing a '-' sign.
* - Uses the 'bsp_printf_c' function to print each character.
*
******************************************************************************/
    static void bsp_printf_d(int val)
    {
    3fe8:	fd010113          	addi	sp,sp,-48
    3fec:	02112623          	sw	ra,44(sp)
    3ff0:	02812423          	sw	s0,40(sp)
    3ff4:	02912223          	sw	s1,36(sp)
    3ff8:	00050493          	mv	s1,a0
        char buffer[32];
        char *p = buffer;
        if (val < 0) {
    3ffc:	00054663          	bltz	a0,4008 <bsp_printf_d+0x20>
    {
    4000:	00010413          	mv	s0,sp
    4004:	02c0006f          	j	4030 <bsp_printf_d+0x48>
            bsp_printf_c('-');
    4008:	02d00513          	li	a0,45
    400c:	fa9ff0ef          	jal	ra,3fb4 <bsp_printf_c>
            val = -val;
    4010:	409004b3          	neg	s1,s1
    4014:	fedff06f          	j	4000 <bsp_printf_d+0x18>
        }
        while (val || p == buffer) {
            *(p++) = '0' + val % 10;
    4018:	00a00713          	li	a4,10
    401c:	02e4e7b3          	rem	a5,s1,a4
    4020:	03078793          	addi	a5,a5,48
    4024:	00f40023          	sb	a5,0(s0)
            val = val / 10;
    4028:	02e4c4b3          	div	s1,s1,a4
            *(p++) = '0' + val % 10;
    402c:	00140413          	addi	s0,s0,1
        while (val || p == buffer) {
    4030:	fe0494e3          	bnez	s1,4018 <bsp_printf_d+0x30>
    4034:	00010793          	mv	a5,sp
    4038:	fef400e3          	beq	s0,a5,4018 <bsp_printf_d+0x30>
    403c:	0100006f          	j	404c <bsp_printf_d+0x64>
        }
        while (p != buffer)
            bsp_printf_c(*(--p));
    4040:	fff40413          	addi	s0,s0,-1
    4044:	00044503          	lbu	a0,0(s0)
    4048:	f6dff0ef          	jal	ra,3fb4 <bsp_printf_c>
        while (p != buffer)
    404c:	00010793          	mv	a5,sp
    4050:	fef418e3          	bne	s0,a5,4040 <bsp_printf_d+0x58>
    }
    4054:	02c12083          	lw	ra,44(sp)
    4058:	02812403          	lw	s0,40(sp)
    405c:	02412483          	lw	s1,36(sp)
    4060:	03010113          	addi	sp,sp,48
    4064:	00008067          	ret

00004068 <bsp_printf_x>:
* - Calls 'bsp_printHex_lower' to print the hexadecimal representation.
* - Determines the number of leading zeros to be printed based on the value.
*
******************************************************************************/
    static void bsp_printf_x(int val)
    {
    4068:	ff010113          	addi	sp,sp,-16
    406c:	00112623          	sw	ra,12(sp)
        int i,digi=2;

        for(i=0;i<8;i++)
    4070:	00000713          	li	a4,0
    4074:	00700793          	li	a5,7
    4078:	02e7c063          	blt	a5,a4,4098 <bsp_printf_x+0x30>
        {
            if((val & (0xFFFFFFF0 <<(4*i))) == 0)
    407c:	00271693          	slli	a3,a4,0x2
    4080:	ff000793          	li	a5,-16
    4084:	00d797b3          	sll	a5,a5,a3
    4088:	00f577b3          	and	a5,a0,a5
    408c:	00078663          	beqz	a5,4098 <bsp_printf_x+0x30>
        for(i=0;i<8;i++)
    4090:	00170713          	addi	a4,a4,1
    4094:	fe1ff06f          	j	4074 <bsp_printf_x+0xc>
            {
                digi=i+1;
                break;
            }
        }
        bsp_printHex_lower(val);
    4098:	ec9ff0ef          	jal	ra,3f60 <bsp_printHex_lower>
    }
    409c:	00c12083          	lw	ra,12(sp)
    40a0:	01010113          	addi	sp,sp,16
    40a4:	00008067          	ret

000040a8 <bsp_printf_X>:
* - Calls 'bsp_printHex' to print the uppercase hexadecimal representation.
* - Determines the number of leading zeros to be printed based on the value.
*
******************************************************************************/
    static void bsp_printf_X(int val)
        {
    40a8:	ff010113          	addi	sp,sp,-16
    40ac:	00112623          	sw	ra,12(sp)
            int i,digi=2;

            for(i=0;i<8;i++)
    40b0:	00000713          	li	a4,0
    40b4:	00700793          	li	a5,7
    40b8:	02e7c063          	blt	a5,a4,40d8 <bsp_printf_X+0x30>
            {
                if((val & (0xFFFFFFF0 <<(4*i))) == 0)
    40bc:	00271693          	slli	a3,a4,0x2
    40c0:	ff000793          	li	a5,-16
    40c4:	00d797b3          	sll	a5,a5,a3
    40c8:	00f577b3          	and	a5,a0,a5
    40cc:	00078663          	beqz	a5,40d8 <bsp_printf_X+0x30>
            for(i=0;i<8;i++)
    40d0:	00170713          	addi	a4,a4,1
    40d4:	fe1ff06f          	j	40b4 <bsp_printf_X+0xc>
                {
                    digi=i+1;
                    break;
                }
            }
            bsp_printHex(val);
    40d8:	e35ff0ef          	jal	ra,3f0c <bsp_printHex>
        }
    40dc:	00c12083          	lw	ra,12(sp)
    40e0:	01010113          	addi	sp,sp,16
    40e4:	00008067          	ret

000040e8 <dmasg_interrupt_config>:
        u32 ca = dmasg_ca(base, channel);
    40e8:	00759593          	slli	a1,a1,0x7
    40ec:	00a58533          	add	a0,a1,a0
        *((volatile u32*) address) = data;
    40f0:	fff00793          	li	a5,-1
    40f4:	04f52a23          	sw	a5,84(a0) # f8010054 <__freertos_irq_stack_top+0xf7fbc424>
    40f8:	04c52823          	sw	a2,80(a0)
    }
    40fc:	00008067          	ret

00004100 <dmasg_interrupt_pending_clear>:
        u32 ca = dmasg_ca(base, channel);
    4100:	00759593          	slli	a1,a1,0x7
    4104:	00a585b3          	add	a1,a1,a0
    4108:	04c5aa23          	sw	a2,84(a1)
    }
    410c:	00008067          	ret

00004110 <dmasg_priority>:
* @param priority: Priority of the channel
* @param weight: Weight of the channel
*
*******************************************************************************/  
    static void dmasg_priority(u32 base, u32 channel, u32 priority, u32 weight){
        u32 ca = dmasg_ca(base, channel);
    4110:	00759593          	slli	a1,a1,0x7
    4114:	00a585b3          	add	a1,a1,a0
        write_u32(priority| weight << 8,  ca+DMASG_CHANNEL_PRIORITY);
    4118:	00869693          	slli	a3,a3,0x8
    411c:	00c6e6b3          	or	a3,a3,a2
    4120:	04d5a223          	sw	a3,68(a1)
    }
    4124:	00008067          	ret

00004128 <bsp_printf>:
* - Handles each format specifier by calling the appropriate helper function.
* - If floating-point support is disabled, prints a warning for the 'f' specifier.
*
******************************************************************************/
    static void bsp_printf(const char *format, ...)
    {
    4128:	fc010113          	addi	sp,sp,-64
    412c:	00112e23          	sw	ra,28(sp)
    4130:	00812c23          	sw	s0,24(sp)
    4134:	00912a23          	sw	s1,20(sp)
    4138:	00050493          	mv	s1,a0
    413c:	02b12223          	sw	a1,36(sp)
    4140:	02c12423          	sw	a2,40(sp)
    4144:	02d12623          	sw	a3,44(sp)
    4148:	02e12823          	sw	a4,48(sp)
    414c:	02f12a23          	sw	a5,52(sp)
    4150:	03012c23          	sw	a6,56(sp)
    4154:	03112e23          	sw	a7,60(sp)
        int i;
        va_list ap;

        va_start(ap, format);
    4158:	02410793          	addi	a5,sp,36
    415c:	00f12623          	sw	a5,12(sp)

        for (i = 0; format[i]; i++)
    4160:	00000413          	li	s0,0
    4164:	01c0006f          	j	4180 <bsp_printf+0x58>
            if (format[i] == '%') {
                while (format[++i]) {
                    if (format[i] == 'c') {
                        bsp_printf_c(va_arg(ap,int));
    4168:	00c12783          	lw	a5,12(sp)
    416c:	00478713          	addi	a4,a5,4
    4170:	00e12623          	sw	a4,12(sp)
    4174:	0007a503          	lw	a0,0(a5)
    4178:	e3dff0ef          	jal	ra,3fb4 <bsp_printf_c>
        for (i = 0; format[i]; i++)
    417c:	00140413          	addi	s0,s0,1
    4180:	008487b3          	add	a5,s1,s0
    4184:	0007c503          	lbu	a0,0(a5)
    4188:	0c050263          	beqz	a0,424c <bsp_printf+0x124>
            if (format[i] == '%') {
    418c:	02500793          	li	a5,37
    4190:	06f50663          	beq	a0,a5,41fc <bsp_printf+0xd4>
                        break;
                    }
#endif //#if (ENABLE_FLOATING_POINT_SUPPORT)
                }
            } else
                bsp_printf_c(format[i]);
    4194:	e21ff0ef          	jal	ra,3fb4 <bsp_printf_c>
    4198:	fe5ff06f          	j	417c <bsp_printf+0x54>
                        bsp_printf_s(va_arg(ap,char*));
    419c:	00c12783          	lw	a5,12(sp)
    41a0:	00478713          	addi	a4,a5,4
    41a4:	00e12623          	sw	a4,12(sp)
    41a8:	0007a503          	lw	a0,0(a5)
    41ac:	e25ff0ef          	jal	ra,3fd0 <bsp_printf_s>
                        break;
    41b0:	fcdff06f          	j	417c <bsp_printf+0x54>
                        bsp_printf_d(va_arg(ap,int));
    41b4:	00c12783          	lw	a5,12(sp)
    41b8:	00478713          	addi	a4,a5,4
    41bc:	00e12623          	sw	a4,12(sp)
    41c0:	0007a503          	lw	a0,0(a5)
    41c4:	e25ff0ef          	jal	ra,3fe8 <bsp_printf_d>
                        break;
    41c8:	fb5ff06f          	j	417c <bsp_printf+0x54>
                        bsp_printf_X(va_arg(ap,int));
    41cc:	00c12783          	lw	a5,12(sp)
    41d0:	00478713          	addi	a4,a5,4
    41d4:	00e12623          	sw	a4,12(sp)
    41d8:	0007a503          	lw	a0,0(a5)
    41dc:	ecdff0ef          	jal	ra,40a8 <bsp_printf_X>
                        break;
    41e0:	f9dff06f          	j	417c <bsp_printf+0x54>
                        bsp_printf_x(va_arg(ap,int));
    41e4:	00c12783          	lw	a5,12(sp)
    41e8:	00478713          	addi	a4,a5,4
    41ec:	00e12623          	sw	a4,12(sp)
    41f0:	0007a503          	lw	a0,0(a5)
    41f4:	e75ff0ef          	jal	ra,4068 <bsp_printf_x>
                        break;
    41f8:	f85ff06f          	j	417c <bsp_printf+0x54>
                while (format[++i]) {
    41fc:	00140413          	addi	s0,s0,1
    4200:	008487b3          	add	a5,s1,s0
    4204:	0007c783          	lbu	a5,0(a5)
    4208:	f6078ae3          	beqz	a5,417c <bsp_printf+0x54>
                    if (format[i] == 'c') {
    420c:	06300713          	li	a4,99
    4210:	f4e78ce3          	beq	a5,a4,4168 <bsp_printf+0x40>
                    else if (format[i] == 's') {
    4214:	07300713          	li	a4,115
    4218:	f8e782e3          	beq	a5,a4,419c <bsp_printf+0x74>
                    else if (format[i] == 'd') {
    421c:	06400713          	li	a4,100
    4220:	f8e78ae3          	beq	a5,a4,41b4 <bsp_printf+0x8c>
                    else if (format[i] == 'X') {
    4224:	05800713          	li	a4,88
    4228:	fae782e3          	beq	a5,a4,41cc <bsp_printf+0xa4>
                    else if (format[i] == 'x') {
    422c:	07800713          	li	a4,120
    4230:	fae78ae3          	beq	a5,a4,41e4 <bsp_printf+0xbc>
                    else if (format[i] == 'f') {
    4234:	06600713          	li	a4,102
    4238:	fce792e3          	bne	a5,a4,41fc <bsp_printf+0xd4>
                        bsp_printf_s("<Floating point printing not enable. Please Enable it at bsp.h first...>");
    423c:	00009537          	lui	a0,0x9
    4240:	b8850513          	addi	a0,a0,-1144 # 8b88 <_data+0xe0>
    4244:	d8dff0ef          	jal	ra,3fd0 <bsp_printf_s>
                        break;
    4248:	f35ff06f          	j	417c <bsp_printf+0x54>

        va_end(ap);
    }
    424c:	01c12083          	lw	ra,28(sp)
    4250:	01812403          	lw	s0,24(sp)
    4254:	01412483          	lw	s1,20(sp)
    4258:	04010113          	addi	sp,sp,64
    425c:	00008067          	ret

00004260 <print>:
struct cs_sg_descriptor cs_descriptor_csi_RX[4];


volatile struct dmasg_descriptor input_descriptor[40] __attribute__ ((aligned (64)));

void print(uint8_t * data) {
    4260:	ff010113          	addi	sp,sp,-16
    4264:	00112623          	sw	ra,12(sp)
      uart_writeStr(BSP_UART_TERMINAL, data);
    4268:	00050593          	mv	a1,a0
    426c:	f8010537          	lui	a0,0xf8010
    4270:	b71ff0ef          	jal	ra,3de0 <uart_writeStr>
    }
    4274:	00c12083          	lw	ra,12(sp)
    4278:	01010113          	addi	sp,sp,16
    427c:	00008067          	ret

00004280 <check_sd>:



void check_sd(u32 testtype){
    4280:	fc010113          	addi	sp,sp,-64
    4284:	02112e23          	sw	ra,60(sp)
    4288:	02812c23          	sw	s0,56(sp)
    428c:	02912a23          	sw	s1,52(sp)
    4290:	03212823          	sw	s2,48(sp)
    4294:	03312623          	sw	s3,44(sp)
    4298:	03412423          	sw	s4,40(sp)
    429c:	03512223          	sw	s5,36(sp)
    42a0:	03612023          	sw	s6,32(sp)
    42a4:	00050a93          	mv	s5,a0
	u32 total_block_n,n;
	u32 timer_start,timer_end;
	u32 rd_timer_start,rd_timer_end;
	u32 ts,te;

	bsp_uDelay(1000000);
    42a8:	f8b00637          	lui	a2,0xf8b00
    42ac:	05f5e5b7          	lui	a1,0x5f5e
    42b0:	10058593          	addi	a1,a1,256 # 5f5e100 <__freertos_irq_stack_top+0x5f0a4d0>
    42b4:	000f4537          	lui	a0,0xf4
    42b8:	24050513          	addi	a0,a0,576 # f4240 <__freertos_irq_stack_top+0xa0610>
    42bc:	bc9ff0ef          	jal	ra,3e84 <clint_uDelay>

	mmc=malloc(sizeof(struct mmc));
    42c0:	08000513          	li	a0,128
    42c4:	e35fc0ef          	jal	ra,10f8 <malloc>
    42c8:	00050413          	mv	s0,a0
	cfg=malloc(sizeof(struct mmc_config));
    42cc:	02000513          	li	a0,32
    42d0:	e29fc0ef          	jal	ra,10f8 <malloc>
    42d4:	00050493          	mv	s1,a0
	ops=malloc(sizeof(struct mmc_ops));
    42d8:	01c00513          	li	a0,28
    42dc:	e1dfc0ef          	jal	ra,10f8 <malloc>
    42e0:	00050913          	mv	s2,a0
	cmd=malloc(sizeof(struct mmc_cmd));
    42e4:	01c00513          	li	a0,28
    42e8:	e11fc0ef          	jal	ra,10f8 <malloc>
    42ec:	00050993          	mv	s3,a0
	data=malloc(sizeof(struct mmc_data));
    42f0:	01000513          	li	a0,16
    42f4:	e05fc0ef          	jal	ra,10f8 <malloc>
    42f8:	00050a13          	mv	s4,a0



	bsp_printf("\n\r--- EFX-SD Card Demo ---\n\r");
    42fc:	00009537          	lui	a0,0x9
    4300:	bd450513          	addi	a0,a0,-1068 # 8bd4 <_data+0x12c>
    4304:	e25ff0ef          	jal	ra,4128 <bsp_printf>
	bsp_printf("\r\nInitialize...:");
    4308:	00009537          	lui	a0,0x9
    430c:	bf450513          	addi	a0,a0,-1036 # 8bf4 <_data+0x14c>
    4310:	e19ff0ef          	jal	ra,4128 <bsp_printf>

	//Allocation Struct Space

	memset(mmc, 0, sizeof(struct mmc));
    4314:	07c00613          	li	a2,124
    4318:	00000593          	li	a1,0
    431c:	00440513          	addi	a0,s0,4
    4320:	e88fd0ef          	jal	ra,19a8 <memset>
	memset(cfg, 0, sizeof(struct mmc_config));
    4324:	02000613          	li	a2,32
    4328:	00000593          	li	a1,0
    432c:	00048513          	mv	a0,s1
    4330:	e78fd0ef          	jal	ra,19a8 <memset>
	memset(ops, 0, sizeof(struct mmc_ops));
    4334:	01c00613          	li	a2,28
    4338:	00000593          	li	a1,0
    433c:	00090513          	mv	a0,s2
    4340:	e68fd0ef          	jal	ra,19a8 <memset>
	memset(cmd, 0, sizeof(struct mmc_cmd));
    4344:	01c00613          	li	a2,28
    4348:	00000593          	li	a1,0
    434c:	00098513          	mv	a0,s3
    4350:	e58fd0ef          	jal	ra,19a8 <memset>
	memset(data, 0, sizeof(struct mmc_data));
    4354:	01000613          	li	a2,16
    4358:	00000593          	li	a1,0
    435c:	000a0513          	mv	a0,s4
    4360:	e48fd0ef          	jal	ra,19a8 <memset>
	memset(buf, 0, (sizeof(char)*BLOCK_SIZE*MAX_BLK_BUF));
	memset(rd_buf, 0, (sizeof(char)*BLOCK_SIZE*MAX_BLK_BUF));
    4364:	00020637          	lui	a2,0x20
    4368:	00000593          	li	a1,0
    436c:	02500537          	lui	a0,0x2500
    4370:	e38fd0ef          	jal	ra,19a8 <memset>

	mmc->cfg = cfg;		//pass the pointer after malloc in struct
    4374:	00942023          	sw	s1,0(s0)
	mmc->cfg->ops = ops;//pass the pointer after malloc in struct
    4378:	0124a223          	sw	s2,4(s1)

	sd_ctrl_mmc_probe(mmc,PROBE_ADDR); //init SD Card driver
    437c:	f81205b7          	lui	a1,0xf8120
    4380:	00040513          	mv	a0,s0
    4384:	e24fe0ef          	jal	ra,29a8 <sd_ctrl_mmc_probe>

	//u32 apb3_rd = APB3_REGR(OOB_APB_SLV, APB3_SLV0_REG1_LED);
	//	apb3_rd &= (~0x038);
	//	APB3_REGW(OOB_APB_SLV, APB3_SLV0_REG1_LED, apb3_rd);

	IntcSDInitialize(mmc);	// init interrupt
    4388:	00040513          	mv	a0,s0
    438c:	9adff0ef          	jal	ra,3d38 <IntcSDInitialize>
	if(SD_CardInitial(mmc,cmd))	//init SD Card
    4390:	00098593          	mv	a1,s3
    4394:	00040513          	mv	a0,s0
    4398:	69c010ef          	jal	ra,5a34 <SD_CardInitial>
    439c:	02050663          	beqz	a0,43c8 <check_sd+0x148>


	}


}
    43a0:	03c12083          	lw	ra,60(sp)
    43a4:	03812403          	lw	s0,56(sp)
    43a8:	03412483          	lw	s1,52(sp)
    43ac:	03012903          	lw	s2,48(sp)
    43b0:	02c12983          	lw	s3,44(sp)
    43b4:	02812a03          	lw	s4,40(sp)
    43b8:	02412a83          	lw	s5,36(sp)
    43bc:	02012b03          	lw	s6,32(sp)
    43c0:	04010113          	addi	sp,sp,64
    43c4:	00008067          	ret
    43c8:	00050493          	mv	s1,a0
	bsp_printf("Done\r\n\n");
    43cc:	00009537          	lui	a0,0x9
    43d0:	c0850513          	addi	a0,a0,-1016 # 8c08 <_data+0x160>
    43d4:	d55ff0ef          	jal	ra,4128 <bsp_printf>
	SD_InitRandomBuff(buf,BLOCK_SIZE*MAX_BLK_BUF);	//init write buffer with random data;
    43d8:	000205b7          	lui	a1,0x20
    43dc:	02500537          	lui	a0,0x2500
    43e0:	545010ef          	jal	ra,6124 <SD_InitRandomBuff>
	u32 speed = mmc->tran_speed;
    43e4:	06842a03          	lw	s4,104(s0)
	speed = speed/1000;
    43e8:	3e800793          	li	a5,1000
    43ec:	02fa5a33          	divu	s4,s4,a5
	total_block_n = ((u32)(mmc->capacity/512));
    43f0:	07842783          	lw	a5,120(s0)
    43f4:	07c42903          	lw	s2,124(s0)
    43f8:	01791913          	slli	s2,s2,0x17
    43fc:	0097d793          	srli	a5,a5,0x9
    4400:	00f96933          	or	s2,s2,a5
	bsp_printf("**************START SD Card TEST*******************\r\n");
    4404:	00009537          	lui	a0,0x9
    4408:	c1050513          	addi	a0,a0,-1008 # 8c10 <_data+0x168>
    440c:	d1dff0ef          	jal	ra,4128 <bsp_printf>
	bsp_printf("**SD CLOCK SPEED = %d\r\n",SD_CLK_FREQ);
    4410:	0000c5b7          	lui	a1,0xc
    4414:	35058593          	addi	a1,a1,848 # c350 <raw_table4+0x2830>
    4418:	00009537          	lui	a0,0x9
    441c:	c4850513          	addi	a0,a0,-952 # 8c48 <_data+0x1a0>
    4420:	d09ff0ef          	jal	ra,4128 <bsp_printf>
	bsp_printf("**CARD SPEED = %d kHz\r\n", speed); // mmc->tran_speed/1000);
    4424:	000a0593          	mv	a1,s4
    4428:	00009537          	lui	a0,0x9
    442c:	c6050513          	addi	a0,a0,-928 # 8c60 <_data+0x1b8>
    4430:	cf9ff0ef          	jal	ra,4128 <bsp_printf>
	bsp_printf("**CARD SIZE = %d Mbyte Total BLOCK = %d\r\n",(u32)(mmc->capacity/1024/1024),total_block_n);
    4434:	07842783          	lw	a5,120(s0)
    4438:	07c42583          	lw	a1,124(s0)
    443c:	00c59593          	slli	a1,a1,0xc
    4440:	0147d793          	srli	a5,a5,0x14
    4444:	00090613          	mv	a2,s2
    4448:	00f5e5b3          	or	a1,a1,a5
    444c:	00009537          	lui	a0,0x9
    4450:	c7850513          	addi	a0,a0,-904 # 8c78 <_data+0x1d0>
    4454:	cd5ff0ef          	jal	ra,4128 <bsp_printf>
	bsp_printf("**SD BUS WIDTH = %d\r\n",mmc->bus_width);
    4458:	02042583          	lw	a1,32(s0)
    445c:	00009537          	lui	a0,0x9
    4460:	ca450513          	addi	a0,a0,-860 # 8ca4 <_data+0x1fc>
    4464:	cc5ff0ef          	jal	ra,4128 <bsp_printf>
	bsp_printf("**BLOCK SIZE = %d BUFFER OF BLOCK = %d\r\n",BLOCK_SIZE,MAX_BLK_BUF);
    4468:	10000613          	li	a2,256
    446c:	20000593          	li	a1,512
    4470:	00009537          	lui	a0,0x9
    4474:	cbc50513          	addi	a0,a0,-836 # 8cbc <_data+0x214>
    4478:	cb1ff0ef          	jal	ra,4128 <bsp_printf>
	bsp_printf("**TEST SIZE = %d kbyte\r\n",(BLOCK_SIZE*MAX_BLK_BUF)/1024);
    447c:	08000593          	li	a1,128
    4480:	00009537          	lui	a0,0x9
    4484:	ce850513          	addi	a0,a0,-792 # 8ce8 <_data+0x240>
    4488:	ca1ff0ef          	jal	ra,4128 <bsp_printf>
	bsp_printf("*************************************************\r\n");
    448c:	00009537          	lui	a0,0x9
    4490:	d0450513          	addi	a0,a0,-764 # 8d04 <_data+0x25c>
    4494:	c95ff0ef          	jal	ra,4128 <bsp_printf>
	if (testtype!=0)
    4498:	f00a84e3          	beqz	s5,43a0 <check_sd+0x120>
		bsp_printf("\r\n!!!!Warning ! The following test will over write data on each memory blocks of the SD card !!!!");
    449c:	00009537          	lui	a0,0x9
    44a0:	d3850513          	addi	a0,a0,-712 # 8d38 <_data+0x290>
    44a4:	c85ff0ef          	jal	ra,4128 <bsp_printf>
		bsp_printf("\r\n!!!!it will crash the SD card data ,Push q or Q to quit the test !!!!");
    44a8:	00009537          	lui	a0,0x9
    44ac:	d9c50513          	addi	a0,a0,-612 # 8d9c <_data+0x2f4>
    44b0:	c79ff0ef          	jal	ra,4128 <bsp_printf>
		bsp_printf("\r\nOr you could push Any Key to Continue the test and you could push q or Q to quit the test any time! \r\n\n");
    44b4:	00009537          	lui	a0,0x9
    44b8:	de450513          	addi	a0,a0,-540 # 8de4 <_data+0x33c>
    44bc:	c6dff0ef          	jal	ra,4128 <bsp_printf>
			temp_udata = uart_read(BSP_UART_TERMINAL);
    44c0:	f8010537          	lui	a0,0xf8010
    44c4:	961ff0ef          	jal	ra,3e24 <uart_read>
			if(temp_udata!=0)
    44c8:	fe050ce3          	beqz	a0,44c0 <check_sd+0x240>
		if( (temp_udata!='q') && (temp_udata!='Q') )
    44cc:	07100793          	li	a5,113
    44d0:	00f50663          	beq	a0,a5,44dc <check_sd+0x25c>
    44d4:	05100793          	li	a5,81
    44d8:	00f51a63          	bne	a0,a5,44ec <check_sd+0x26c>
			bsp_printf("\r\nQuit the Memory Blocks Write/Read Access test! \r\n\n");
    44dc:	00009537          	lui	a0,0x9
    44e0:	e9850513          	addi	a0,a0,-360 # 8e98 <_data+0x3f0>
    44e4:	c45ff0ef          	jal	ra,4128 <bsp_printf>
    44e8:	eb9ff06f          	j	43a0 <check_sd+0x120>
			bsp_printf("\r\nStart to Memory Blocks Write/Read Access test! \r\n\n");
    44ec:	00009537          	lui	a0,0x9
    44f0:	e5050513          	addi	a0,a0,-432 # 8e50 <_data+0x3a8>
    44f4:	c35ff0ef          	jal	ra,4128 <bsp_printf>
			for(n=0;n<total_block_n;n+=MAX_BLK_BUF)
    44f8:	0080006f          	j	4500 <check_sd+0x280>
    44fc:	10048493          	addi	s1,s1,256
    4500:	eb24f0e3          	bgeu	s1,s2,43a0 <check_sd+0x120>
						SD_EraseBlk(mmc,cmd,0,MAX_BLK_BUF);	//erase Block
    4504:	10000693          	li	a3,256
    4508:	00000613          	li	a2,0
    450c:	00098593          	mv	a1,s3
    4510:	00040513          	mv	a0,s0
    4514:	7c4010ef          	jal	ra,5cd8 <SD_EraseBlk>
						timer_start=(u32)machineTimer_getTime(BSP_MACHINE_TIMER);	//get write start time
    4518:	f8b00537          	lui	a0,0xf8b00
    451c:	93dff0ef          	jal	ra,3e58 <clint_getTime>
    4520:	00050a13          	mv	s4,a0
						SD_WRITE_BLOCK(mmc,0,buf,MAX_BLK_BUF);						//write block
    4524:	10000693          	li	a3,256
    4528:	02500637          	lui	a2,0x2500
    452c:	00000593          	li	a1,0
    4530:	00040513          	mv	a0,s0
    4534:	039010ef          	jal	ra,5d6c <SD_WRITE_BLOCK>
						timer_end=(u32)machineTimer_getTime(BSP_MACHINE_TIMER);		//get write finish time
    4538:	f8b00537          	lui	a0,0xf8b00
    453c:	91dff0ef          	jal	ra,3e58 <clint_getTime>
    4540:	00050a93          	mv	s5,a0
						rd_timer_start=(u32)machineTimer_getTime(BSP_MACHINE_TIMER);	//get read start time
    4544:	f8b00537          	lui	a0,0xf8b00
    4548:	911ff0ef          	jal	ra,3e58 <clint_getTime>
    454c:	00050b13          	mv	s6,a0
						SD_READ_BLOCK(mmc,0,rd_buf,MAX_BLK_BUF);
    4550:	10000693          	li	a3,256
    4554:	02500637          	lui	a2,0x2500
    4558:	00000593          	li	a1,0
    455c:	00040513          	mv	a0,s0
    4560:	10d010ef          	jal	ra,5e6c <SD_READ_BLOCK>
						rd_timer_end=(u32)machineTimer_getTime(BSP_MACHINE_TIMER);		//get read finish time
    4564:	f8b00537          	lui	a0,0xf8b00
    4568:	8f1ff0ef          	jal	ra,3e58 <clint_getTime>
						SD_ReadWriteCompare(buf,rd_buf,timer_start,timer_end,rd_timer_start,rd_timer_end,MAX_BLK_BUF,n,total_block_n);	//compare 2 buffer with speed calculation
    456c:	01212823          	sw	s2,16(sp)
    4570:	00912623          	sw	s1,12(sp)
    4574:	10000793          	li	a5,256
    4578:	00f12423          	sw	a5,8(sp)
    457c:	00a12023          	sw	a0,0(sp)
    4580:	00012223          	sw	zero,4(sp)
    4584:	000b0813          	mv	a6,s6
    4588:	00000893          	li	a7,0
    458c:	000a8713          	mv	a4,s5
    4590:	00000793          	li	a5,0
    4594:	000a0613          	mv	a2,s4
    4598:	00000693          	li	a3,0
    459c:	025005b7          	lui	a1,0x2500
    45a0:	02500537          	lui	a0,0x2500
    45a4:	1c1010ef          	jal	ra,5f64 <SD_ReadWriteCompare>
						if(uart_readOccupancy(BSP_UART_TERMINAL) != 0)
    45a8:	f8010537          	lui	a0,0xf8010
    45ac:	fecff0ef          	jal	ra,3d98 <uart_readOccupancy>
    45b0:	f40506e3          	beqz	a0,44fc <check_sd+0x27c>
        return *((volatile u32*) address);
    45b4:	f80107b7          	lui	a5,0xf8010
    45b8:	0007aa03          	lw	s4,0(a5) # f8010000 <__freertos_irq_stack_top+0xf7fbc3d0>
								        	temp_udata = read_u32(BSP_UART_TERMINAL + UART_DATA);
    45bc:	0ffa7a13          	andi	s4,s4,255
								  		  bsp_putString("echo character:");
    45c0:	000095b7          	lui	a1,0x9
    45c4:	e8858593          	addi	a1,a1,-376 # 8e88 <_data+0x3e0>
    45c8:	f8010537          	lui	a0,0xf8010
    45cc:	815ff0ef          	jal	ra,3de0 <uart_writeStr>
								  				            bsp_putChar(temp_udata);
    45d0:	000a0593          	mv	a1,s4
    45d4:	f8010537          	lui	a0,0xf8010
    45d8:	fccff0ef          	jal	ra,3da4 <uart_write>
								  				            bsp_putString("\n\r");
    45dc:	000515b7          	lui	a1,0x51
    45e0:	78c58593          	addi	a1,a1,1932 # 5178c <raw_table+0xe60c>
    45e4:	f8010537          	lui	a0,0xf8010
    45e8:	ff8ff0ef          	jal	ra,3de0 <uart_writeStr>
								        	if ( (temp_udata =='q') || (temp_udata =='Q') )
    45ec:	07100793          	li	a5,113
    45f0:	00fa0663          	beq	s4,a5,45fc <check_sd+0x37c>
    45f4:	05100793          	li	a5,81
    45f8:	f0fa12e3          	bne	s4,a5,44fc <check_sd+0x27c>
								        		bsp_printf("\r\nQuit the Memory Blocks Write/Read Access test! \r\n\n");
    45fc:	00009537          	lui	a0,0x9
    4600:	e9850513          	addi	a0,a0,-360 # 8e98 <_data+0x3f0>
    4604:	b25ff0ef          	jal	ra,4128 <bsp_printf>
								        		break;
    4608:	d99ff06f          	j	43a0 <check_sd+0x120>

0000460c <cmd_cam_brightnes>:
#define MASK_SW1	( MASK_ALL & (~0x01) )
#define MASK_SW2	( MASK_ALL & (~0x02) )
#define MASK_SW3	( MASK_ALL & (~0x04) )

void cmd_cam_brightnes(u8 AGain, u16 DGain)
{
    460c:	ff010113          	addi	sp,sp,-16
    4610:	00112623          	sw	ra,12(sp)
    4614:	00812423          	sw	s0,8(sp)
    4618:	00912223          	sw	s1,4(sp)
    461c:	01212023          	sw	s2,0(sp)
    4620:	00050913          	mv	s2,a0
    4624:	00058493          	mv	s1,a1


	for(int x=0; x<4; x++)
    4628:	00000413          	li	s0,0
    462c:	0500006f          	j	467c <cmd_cam_brightnes+0x70>
			if( PiCam_Gainfilter(AGain,DGain) ){
				bsp_printf("Pi Camera %d Brightness Error !\n\r",x );
			}
			else
			{
				bsp_printf("Pi Camera %d Brightness Done !\n\r",x);
    4630:	00040593          	mv	a1,s0
    4634:	00009537          	lui	a0,0x9
    4638:	ef450513          	addi	a0,a0,-268 # 8ef4 <_data+0x44c>
    463c:	aedff0ef          	jal	ra,4128 <bsp_printf>
				bsp_printf("AGain: 0x%x\n\r",AGain);
    4640:	00090593          	mv	a1,s2
    4644:	00009537          	lui	a0,0x9
    4648:	f1850513          	addi	a0,a0,-232 # 8f18 <_data+0x470>
    464c:	addff0ef          	jal	ra,4128 <bsp_printf>
				bsp_printf("DGain: 0x%x\n\r",DGain);
    4650:	00048593          	mv	a1,s1
    4654:	00009537          	lui	a0,0x9
    4658:	f2850513          	addi	a0,a0,-216 # 8f28 <_data+0x480>
    465c:	acdff0ef          	jal	ra,4128 <bsp_printf>

			}

		}
		bsp_uDelay(200000);
    4660:	f8b00637          	lui	a2,0xf8b00
    4664:	05f5e5b7          	lui	a1,0x5f5e
    4668:	10058593          	addi	a1,a1,256 # 5f5e100 <__freertos_irq_stack_top+0x5f0a4d0>
    466c:	00031537          	lui	a0,0x31
    4670:	d4050513          	addi	a0,a0,-704 # 30d40 <raw_table2+0xa6f0>
    4674:	811ff0ef          	jal	ra,3e84 <clint_uDelay>
	for(int x=0; x<4; x++)
    4678:	00140413          	addi	s0,s0,1
    467c:	00300793          	li	a5,3
    4680:	0487c263          	blt	a5,s0,46c4 <cmd_cam_brightnes+0xb8>
        *((volatile u32*) address) = data;
    4684:	f81107b7          	lui	a5,0xf8110
    4688:	0287a823          	sw	s0,48(a5) # f8110030 <__freertos_irq_stack_top+0xf80bc400>
		if(camStatus[x]!=0)
    468c:	00241793          	slli	a5,s0,0x2
    4690:	c1018713          	addi	a4,gp,-1008 # 52640 <camStatus>
    4694:	00f707b3          	add	a5,a4,a5
    4698:	0007a783          	lw	a5,0(a5)
    469c:	fc0782e3          	beqz	a5,4660 <cmd_cam_brightnes+0x54>
			if( PiCam_Gainfilter(AGain,DGain) ){
    46a0:	00048593          	mv	a1,s1
    46a4:	00090513          	mv	a0,s2
    46a8:	b7dfe0ef          	jal	ra,3224 <PiCam_Gainfilter>
    46ac:	f80502e3          	beqz	a0,4630 <cmd_cam_brightnes+0x24>
				bsp_printf("Pi Camera %d Brightness Error !\n\r",x );
    46b0:	00040593          	mv	a1,s0
    46b4:	00009537          	lui	a0,0x9
    46b8:	ed050513          	addi	a0,a0,-304 # 8ed0 <_data+0x428>
    46bc:	a6dff0ef          	jal	ra,4128 <bsp_printf>
    46c0:	fa1ff06f          	j	4660 <cmd_cam_brightnes+0x54>

	}

}
    46c4:	00c12083          	lw	ra,12(sp)
    46c8:	00812403          	lw	s0,8(sp)
    46cc:	00412483          	lw	s1,4(sp)
    46d0:	00012903          	lw	s2,0(sp)
    46d4:	01010113          	addi	sp,sp,16
    46d8:	00008067          	ret

000046dc <cmd_cam_colour_gain>:

void cmd_cam_colour_gain( u16 gain_r, u16 gain_g, u16 gain_b)
{
    46dc:	fe010113          	addi	sp,sp,-32
    46e0:	00112e23          	sw	ra,28(sp)
    46e4:	00812c23          	sw	s0,24(sp)
    46e8:	00912a23          	sw	s1,20(sp)
    46ec:	01212823          	sw	s2,16(sp)
    46f0:	01312623          	sw	s3,12(sp)
    46f4:	01412423          	sw	s4,8(sp)
    46f8:	01512223          	sw	s5,4(sp)
    46fc:	00050493          	mv	s1,a0
    4700:	00058993          	mv	s3,a1
    4704:	00060913          	mv	s2,a2

	for(int x=0; x<4; x++)
    4708:	00000413          	li	s0,0
    470c:	0bc0006f          	j	47c8 <cmd_cam_colour_gain+0xec>
		if(camStatus[x]!=0)
		{

			 if ( PiCam_WriteRegData(gain_r_1, (gain_r/0x100)&0xff) ==0 )
			 {
				 PiCam_WriteRegData(gain_r_0, gain_r&0xff);
    4710:	0ff4f593          	andi	a1,s1,255
    4714:	19d00513          	li	a0,413
    4718:	cbcfe0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
				 PiCam_WriteRegData(gain_GR_1, (gain_g/0x100)&0xff);
    471c:	0089da93          	srli	s5,s3,0x8
    4720:	000a8593          	mv	a1,s5
    4724:	19e00513          	li	a0,414
    4728:	cacfe0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
				 PiCam_WriteRegData(gain_GR_0, gain_g&0xff);
    472c:	0ff9fa13          	andi	s4,s3,255
    4730:	000a0593          	mv	a1,s4
    4734:	19f00513          	li	a0,415
    4738:	c9cfe0ef          	jal	ra,2bd4 <PiCam_WriteRegData>

				 PiCam_WriteRegData(gain_GB_1, (gain_g/0x100)&0xff);
    473c:	000a8593          	mv	a1,s5
    4740:	1a000513          	li	a0,416
    4744:	c90fe0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
				 PiCam_WriteRegData(gain_GB_0, gain_g&0xff);
    4748:	000a0593          	mv	a1,s4
    474c:	1a100513          	li	a0,417
    4750:	c84fe0ef          	jal	ra,2bd4 <PiCam_WriteRegData>

				 PiCam_WriteRegData(gain_B_1, (gain_b/0x100)&0xff);
    4754:	00895593          	srli	a1,s2,0x8
    4758:	1a200513          	li	a0,418
    475c:	c78fe0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
				 PiCam_WriteRegData(gain_B_0, gain_b&0xff);
    4760:	0ff97593          	andi	a1,s2,255
    4764:	1a300513          	li	a0,419
    4768:	c6cfe0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
				 bsp_printf("Pi Camera %d Colour !\n\r",x);
    476c:	00040593          	mv	a1,s0
    4770:	00009537          	lui	a0,0x9
    4774:	f3850513          	addi	a0,a0,-200 # 8f38 <_data+0x490>
    4778:	9b1ff0ef          	jal	ra,4128 <bsp_printf>
				 bsp_printf("Red Gain: 0x%x\n\r",gain_r);
    477c:	00048593          	mv	a1,s1
    4780:	00009537          	lui	a0,0x9
    4784:	f5050513          	addi	a0,a0,-176 # 8f50 <_data+0x4a8>
    4788:	9a1ff0ef          	jal	ra,4128 <bsp_printf>
				 bsp_printf("Green Gain: 0x%x\n\r",gain_g);
    478c:	00098593          	mv	a1,s3
    4790:	00009537          	lui	a0,0x9
    4794:	f6450513          	addi	a0,a0,-156 # 8f64 <_data+0x4bc>
    4798:	991ff0ef          	jal	ra,4128 <bsp_printf>
				 bsp_printf("Blue Gain: 0x%x\n\r",gain_b);
    479c:	00090593          	mv	a1,s2
    47a0:	00009537          	lui	a0,0x9
    47a4:	f7850513          	addi	a0,a0,-136 # 8f78 <_data+0x4d0>
    47a8:	981ff0ef          	jal	ra,4128 <bsp_printf>

			 }

		}
		bsp_uDelay(200000);
    47ac:	f8b00637          	lui	a2,0xf8b00
    47b0:	05f5e5b7          	lui	a1,0x5f5e
    47b4:	10058593          	addi	a1,a1,256 # 5f5e100 <__freertos_irq_stack_top+0x5f0a4d0>
    47b8:	00031537          	lui	a0,0x31
    47bc:	d4050513          	addi	a0,a0,-704 # 30d40 <raw_table2+0xa6f0>
    47c0:	ec4ff0ef          	jal	ra,3e84 <clint_uDelay>
	for(int x=0; x<4; x++)
    47c4:	00140413          	addi	s0,s0,1
    47c8:	00300793          	li	a5,3
    47cc:	0287ca63          	blt	a5,s0,4800 <cmd_cam_colour_gain+0x124>
    47d0:	f81107b7          	lui	a5,0xf8110
    47d4:	0287a823          	sw	s0,48(a5) # f8110030 <__freertos_irq_stack_top+0xf80bc400>
		if(camStatus[x]!=0)
    47d8:	00241793          	slli	a5,s0,0x2
    47dc:	c1018713          	addi	a4,gp,-1008 # 52640 <camStatus>
    47e0:	00f707b3          	add	a5,a4,a5
    47e4:	0007a783          	lw	a5,0(a5)
    47e8:	fc0782e3          	beqz	a5,47ac <cmd_cam_colour_gain+0xd0>
			 if ( PiCam_WriteRegData(gain_r_1, (gain_r/0x100)&0xff) ==0 )
    47ec:	0084d593          	srli	a1,s1,0x8
    47f0:	19c00513          	li	a0,412
    47f4:	be0fe0ef          	jal	ra,2bd4 <PiCam_WriteRegData>
    47f8:	fa051ae3          	bnez	a0,47ac <cmd_cam_colour_gain+0xd0>
    47fc:	f15ff06f          	j	4710 <cmd_cam_colour_gain+0x34>

	}

}
    4800:	01c12083          	lw	ra,28(sp)
    4804:	01812403          	lw	s0,24(sp)
    4808:	01412483          	lw	s1,20(sp)
    480c:	01012903          	lw	s2,16(sp)
    4810:	00c12983          	lw	s3,12(sp)
    4814:	00812a03          	lw	s4,8(sp)
    4818:	00412a83          	lw	s5,4(sp)
    481c:	02010113          	addi	sp,sp,32
    4820:	00008067          	ret

00004824 <inital_video_stream>:
{
    4824:	fe010113          	addi	sp,sp,-32
    4828:	00112e23          	sw	ra,28(sp)
    482c:	00812c23          	sw	s0,24(sp)
    4830:	00912a23          	sw	s1,20(sp)
    4834:	01212823          	sw	s2,16(sp)
    4838:	01312623          	sw	s3,12(sp)
    483c:	01412423          	sw	s4,8(sp)
    4840:	01512223          	sw	s5,4(sp)
    4844:	01612023          	sw	s6,0(sp)
	mipi_i2c_init();
    4848:	481030ef          	jal	ra,84c8 <mipi_i2c_init>
        return *((volatile u32*) address);
    484c:	f81107b7          	lui	a5,0xf8110
    4850:	0047a483          	lw	s1,4(a5) # f8110004 <__freertos_irq_stack_top+0xf80bc3d4>
	apb3_rd &= (~0x07);
    4854:	ff84f493          	andi	s1,s1,-8
	for(int i=0;i<FRAME_SIZE*8; i++)
    4858:	00000713          	li	a4,0
    485c:	003f47b7          	lui	a5,0x3f4
    4860:	7ff78793          	addi	a5,a5,2047 # 3f47ff <__freertos_irq_stack_top+0x3a0bcf>
    4864:	00e7ce63          	blt	a5,a4,4880 <inital_video_stream+0x5c>
		mem_framebuffer[i] = 0x00000000;
    4868:	00271693          	slli	a3,a4,0x2
    486c:	020007b7          	lui	a5,0x2000
    4870:	00d787b3          	add	a5,a5,a3
    4874:	0007a023          	sw	zero,0(a5) # 2000000 <__freertos_irq_stack_top+0x1fac3d0>
	for(int i=0;i<FRAME_SIZE*8; i++)
    4878:	00170713          	addi	a4,a4,1
    487c:	fe1ff06f          	j	485c <inital_video_stream+0x38>
	framebuffer_ptr[0] =  mem_framebuffer;
    4880:	15018793          	addi	a5,gp,336 # 52b80 <framebuffer_ptr>
    4884:	02000737          	lui	a4,0x2000
    4888:	00e7a023          	sw	a4,0(a5)
	framebuffer_ptr[1] =  mem_framebuffer  +FRAME_SIZE*1;
    488c:	021fa737          	lui	a4,0x21fa
    4890:	40070713          	addi	a4,a4,1024 # 21fa400 <__freertos_irq_stack_top+0x21a67d0>
    4894:	00e7a223          	sw	a4,4(a5)
	framebuffer_ptr[2] =  mem_framebuffer  +FRAME_SIZE*2;
    4898:	023f5737          	lui	a4,0x23f5
    489c:	80070713          	addi	a4,a4,-2048 # 23f4800 <__freertos_irq_stack_top+0x23a0bd0>
    48a0:	00e7a423          	sw	a4,8(a5)
	framebuffer_ptr[3] =  mem_framebuffer  +FRAME_SIZE*3;
    48a4:	025ef737          	lui	a4,0x25ef
    48a8:	c0070713          	addi	a4,a4,-1024 # 25eec00 <__freertos_irq_stack_top+0x259afd0>
    48ac:	00e7a623          	sw	a4,12(a5)
	framebuffer_ptr[4] =  mem_framebuffer  +FRAME_SIZE*4;
    48b0:	027e9737          	lui	a4,0x27e9
    48b4:	00e7a823          	sw	a4,16(a5)
	framebuffer_ptr[5] = mem_framebuffer  +FRAME_SIZE*5;
    48b8:	029e3737          	lui	a4,0x29e3
    48bc:	40070713          	addi	a4,a4,1024 # 29e3400 <__freertos_irq_stack_top+0x298f7d0>
    48c0:	00e7aa23          	sw	a4,20(a5)
	framebuffer_ptr[6] = mem_framebuffer  +FRAME_SIZE*6;
    48c4:	02bde737          	lui	a4,0x2bde
    48c8:	80070713          	addi	a4,a4,-2048 # 2bdd800 <__freertos_irq_stack_top+0x2b89bd0>
    48cc:	00e7ac23          	sw	a4,24(a5)
	framebuffer_ptr[7] = mem_framebuffer  +FRAME_SIZE*7;
    48d0:	02dd8737          	lui	a4,0x2dd8
    48d4:	c0070713          	addi	a4,a4,-1024 # 2dd7c00 <__freertos_irq_stack_top+0x2d83fd0>
    48d8:	00e7ae23          	sw	a4,28(a5)
	framebuffer_ptr[8] = mem_framebuffer  +FRAME_SIZE*8;
    48dc:	02fd2737          	lui	a4,0x2fd2
    48e0:	02e7a023          	sw	a4,32(a5)
	framebuffer_ptr[9] = mem_framebuffer  +FRAME_SIZE*9;
    48e4:	031cc737          	lui	a4,0x31cc
    48e8:	40070713          	addi	a4,a4,1024 # 31cc400 <__freertos_irq_stack_top+0x31787d0>
    48ec:	02e7a223          	sw	a4,36(a5)
	bsp_printf(" Cameras Initial !\n\r");
    48f0:	00009537          	lui	a0,0x9
    48f4:	f8c50513          	addi	a0,a0,-116 # 8f8c <_data+0x4e4>
    48f8:	831ff0ef          	jal	ra,4128 <bsp_printf>
	mipi_i2c_init();
    48fc:	3cd030ef          	jal	ra,84c8 <mipi_i2c_init>
	for(int x=0; x<4; x++)
    4900:	00000413          	li	s0,0
    4904:	0580006f          	j	495c <inital_video_stream+0x138>
				bsp_printf("GMSL Serilizer and Deserilizer Initial Done!\n\r",x);
    4908:	00040593          	mv	a1,s0
    490c:	00009537          	lui	a0,0x9
    4910:	fe450513          	addi	a0,a0,-28 # 8fe4 <_data+0x53c>
    4914:	815ff0ef          	jal	ra,4128 <bsp_printf>
    4918:	08c0006f          	j	49a4 <inital_video_stream+0x180>
				camStatus[x] =1;
    491c:	00241793          	slli	a5,s0,0x2
    4920:	c1018713          	addi	a4,gp,-1008 # 52640 <camStatus>
    4924:	00f707b3          	add	a5,a4,a5
    4928:	00100713          	li	a4,1
    492c:	00e7a023          	sw	a4,0(a5)
				bsp_printf("Pi Camera %d Initial Done !\n\r",x);
    4930:	00040593          	mv	a1,s0
    4934:	00009537          	lui	a0,0x9
    4938:	03450513          	addi	a0,a0,52 # 9034 <_data+0x58c>
    493c:	fecff0ef          	jal	ra,4128 <bsp_printf>
		bsp_uDelay(200000);
    4940:	f8b00637          	lui	a2,0xf8b00
    4944:	05f5e5b7          	lui	a1,0x5f5e
    4948:	10058593          	addi	a1,a1,256 # 5f5e100 <__freertos_irq_stack_top+0x5f0a4d0>
    494c:	00031537          	lui	a0,0x31
    4950:	d4050513          	addi	a0,a0,-704 # 30d40 <raw_table2+0xa6f0>
    4954:	d30ff0ef          	jal	ra,3e84 <clint_uDelay>
	for(int x=0; x<4; x++)
    4958:	00140413          	addi	s0,s0,1
    495c:	00300793          	li	a5,3
    4960:	0687c063          	blt	a5,s0,49c0 <inital_video_stream+0x19c>
		camStatus[x] = 0;
    4964:	00241793          	slli	a5,s0,0x2
    4968:	c1018713          	addi	a4,gp,-1008 # 52640 <camStatus>
    496c:	00f707b3          	add	a5,a4,a5
    4970:	0007a023          	sw	zero,0(a5)
        *((volatile u32*) address) = data;
    4974:	f81107b7          	lui	a5,0xf8110
    4978:	0287a823          	sw	s0,48(a5) # f8110030 <__freertos_irq_stack_top+0xf80bc400>
			bsp_printf("GMSL Initial!\n\r",x );
    497c:	00040593          	mv	a1,s0
    4980:	00009537          	lui	a0,0x9
    4984:	fa450513          	addi	a0,a0,-92 # 8fa4 <_data+0x4fc>
    4988:	fa0ff0ef          	jal	ra,4128 <bsp_printf>
			if(GMSL_SerDes_init())
    498c:	58c020ef          	jal	ra,6f18 <GMSL_SerDes_init>
    4990:	f6050ce3          	beqz	a0,4908 <inital_video_stream+0xe4>
				bsp_printf("GMSL Serilizer and Deserilizer Initial Error!\n\r",x );
    4994:	00040593          	mv	a1,s0
    4998:	00009537          	lui	a0,0x9
    499c:	fb450513          	addi	a0,a0,-76 # 8fb4 <_data+0x50c>
    49a0:	f88ff0ef          	jal	ra,4128 <bsp_printf>
			if(PiCam_init()){
    49a4:	8d5fe0ef          	jal	ra,3278 <PiCam_init>
    49a8:	f6050ae3          	beqz	a0,491c <inital_video_stream+0xf8>
					bsp_printf("Pi Camera %d Initial Error !\n\r",x );
    49ac:	00040593          	mv	a1,s0
    49b0:	00009537          	lui	a0,0x9
    49b4:	01450513          	addi	a0,a0,20 # 9014 <_data+0x56c>
    49b8:	f70ff0ef          	jal	ra,4128 <bsp_printf>
    49bc:	f85ff06f          	j	4940 <inital_video_stream+0x11c>
    49c0:	f8110937          	lui	s2,0xf8110
    49c4:	00992223          	sw	s1,4(s2) # f8110004 <__freertos_irq_stack_top+0xf80bc3d4>
	framebuffer_pattern(framebuffer_ptr[0],0,0); //Buffer for Camera RX0
    49c8:	15018413          	addi	s0,gp,336 # 52b80 <framebuffer_ptr>
    49cc:	00000613          	li	a2,0
    49d0:	00000593          	li	a1,0
    49d4:	00042503          	lw	a0,0(s0)
    49d8:	669020ef          	jal	ra,7840 <framebuffer_pattern>
	framebuffer_pattern(framebuffer_ptr[1],1,1);//Buffer for Camera RX1
    49dc:	00100613          	li	a2,1
    49e0:	00100593          	li	a1,1
    49e4:	00442503          	lw	a0,4(s0)
    49e8:	659020ef          	jal	ra,7840 <framebuffer_pattern>
	framebuffer_pattern(framebuffer_ptr[2],0,1);//Buffer for Camera RX2
    49ec:	00100613          	li	a2,1
    49f0:	00000593          	li	a1,0
    49f4:	00842503          	lw	a0,8(s0)
    49f8:	649020ef          	jal	ra,7840 <framebuffer_pattern>
	framebuffer_pattern(framebuffer_ptr[3],1,0);//Buffer for Camera RX3
    49fc:	00000613          	li	a2,0
    4a00:	00100593          	li	a1,1
    4a04:	00c42503          	lw	a0,12(s0)
    4a08:	639020ef          	jal	ra,7840 <framebuffer_pattern>
	framebuffer_pattern(framebuffer_ptr[5],2,0);//Buffer for Camera
    4a0c:	00000613          	li	a2,0
    4a10:	00200593          	li	a1,2
    4a14:	01442503          	lw	a0,20(s0)
    4a18:	629020ef          	jal	ra,7840 <framebuffer_pattern>
	framebuffer_pattern(framebuffer_ptr[6],2,0);//Buffer for Camera RX3
    4a1c:	00000613          	li	a2,0
    4a20:	00200593          	li	a1,2
    4a24:	01842503          	lw	a0,24(s0)
    4a28:	619020ef          	jal	ra,7840 <framebuffer_pattern>
	framebuffer_pattern(framebuffer_ptr[7],2,0);//Buffer for Camera RX3
    4a2c:	00000613          	li	a2,0
    4a30:	00200593          	li	a1,2
    4a34:	01c42503          	lw	a0,28(s0)
    4a38:	609020ef          	jal	ra,7840 <framebuffer_pattern>
	framebuffer_pattern(framebuffer_ptr[8],2,0);//Buffer for Camera RX3
    4a3c:	00000613          	li	a2,0
    4a40:	00200593          	li	a1,2
    4a44:	02042503          	lw	a0,32(s0)
    4a48:	5f9020ef          	jal	ra,7840 <framebuffer_pattern>
	framebuffer_pattern(framebuffer_ptr[9],2,0);//Buffer for Camera RX3
    4a4c:	00000613          	li	a2,0
    4a50:	00200593          	li	a1,2
    4a54:	02442503          	lw	a0,36(s0)
    4a58:	5e9020ef          	jal	ra,7840 <framebuffer_pattern>
	framebuffer_loadTable(framebuffer_ptr[5], start_x, end_x, start_y ,end_y ,0 );
    4a5c:	00000793          	li	a5,0
    4a60:	16600713          	li	a4,358
    4a64:	0c800693          	li	a3,200
    4a68:	23c00613          	li	a2,572
    4a6c:	0c800593          	li	a1,200
    4a70:	01442503          	lw	a0,20(s0)
    4a74:	2ad020ef          	jal	ra,7520 <framebuffer_loadTable>
	framebuffer_loadTable(framebuffer_ptr[6], start_x, end_x, start_y ,end_y, 1 );
    4a78:	00100793          	li	a5,1
    4a7c:	16600713          	li	a4,358
    4a80:	0c800693          	li	a3,200
    4a84:	23c00613          	li	a2,572
    4a88:	0c800593          	li	a1,200
    4a8c:	01842503          	lw	a0,24(s0)
    4a90:	291020ef          	jal	ra,7520 <framebuffer_loadTable>
	framebuffer_loadTable(framebuffer_ptr[7], start_x, end_x, start_y ,end_y, 2 );
    4a94:	00200793          	li	a5,2
    4a98:	16600713          	li	a4,358
    4a9c:	0c800693          	li	a3,200
    4aa0:	23c00613          	li	a2,572
    4aa4:	0c800593          	li	a1,200
    4aa8:	01c42503          	lw	a0,28(s0)
    4aac:	275020ef          	jal	ra,7520 <framebuffer_loadTable>
	framebuffer_loadTable(framebuffer_ptr[8], start_x, end_x, start_y ,end_y, 3 );
    4ab0:	00300793          	li	a5,3
    4ab4:	16600713          	li	a4,358
    4ab8:	0c800693          	li	a3,200
    4abc:	23c00613          	li	a2,572
    4ac0:	0c800593          	li	a1,200
    4ac4:	02042503          	lw	a0,32(s0)
    4ac8:	259020ef          	jal	ra,7520 <framebuffer_loadTable>
	framebuffer_loadTable(framebuffer_ptr[9], start_x, end_x, start_y ,end_y, 4 );
    4acc:	00400793          	li	a5,4
    4ad0:	16600713          	li	a4,358
    4ad4:	0c800693          	li	a3,200
    4ad8:	23c00613          	li	a2,572
    4adc:	0c800593          	li	a1,200
    4ae0:	02442503          	lw	a0,36(s0)
    4ae4:	23d020ef          	jal	ra,7520 <framebuffer_loadTable>
	framebuffer_pattern(framebuffer_ptr[4],3,0);//Buffer for Overlay Mask
    4ae8:	00000613          	li	a2,0
    4aec:	00300593          	li	a1,3
    4af0:	01042503          	lw	a0,16(s0)
    4af4:	54d020ef          	jal	ra,7840 <framebuffer_pattern>
	dmasg_priority(DMASG_BASE, DMASG_CHANNEL0, 5, 7);
    4af8:	00700693          	li	a3,7
    4afc:	00500613          	li	a2,5
    4b00:	00000593          	li	a1,0
    4b04:	f8130537          	lui	a0,0xf8130
    4b08:	e08ff0ef          	jal	ra,4110 <dmasg_priority>
	dmasg_priority(DMASG_BASE, DMASG_CHANNEL1, 5, 7);
    4b0c:	00700693          	li	a3,7
    4b10:	00500613          	li	a2,5
    4b14:	00100593          	li	a1,1
    4b18:	f8130537          	lui	a0,0xf8130
    4b1c:	df4ff0ef          	jal	ra,4110 <dmasg_priority>
	dmasg_priority(DMASG_BASE, DMASG_CHANNEL2, 5, 7);
    4b20:	00700693          	li	a3,7
    4b24:	00500613          	li	a2,5
    4b28:	00200593          	li	a1,2
    4b2c:	f8130537          	lui	a0,0xf8130
    4b30:	de0ff0ef          	jal	ra,4110 <dmasg_priority>
	dmasg_priority(DMASG_BASE, DMASG_CHANNEL3, 5, 7);
    4b34:	00700693          	li	a3,7
    4b38:	00500613          	li	a2,5
    4b3c:	00300593          	li	a1,3
    4b40:	f8130537          	lui	a0,0xf8130
    4b44:	dccff0ef          	jal	ra,4110 <dmasg_priority>
	dmasg_priority(DMASG_BASE, DMASG_CHANNEL_OVERLAY, 6, 7);
    4b48:	00700693          	li	a3,7
    4b4c:	00600613          	li	a2,6
    4b50:	00500593          	li	a1,5
    4b54:	f8130537          	lui	a0,0xf8130
    4b58:	db8ff0ef          	jal	ra,4110 <dmasg_priority>
	dmasg_priority(DMASG_BASE, DMASG_CHANNEL_HDMI, 7, 7);
    4b5c:	00700693          	li	a3,7
    4b60:	00700613          	li	a2,7
    4b64:	00400593          	li	a1,4
    4b68:	f8130537          	lui	a0,0xf8130
    4b6c:	da4ff0ef          	jal	ra,4110 <dmasg_priority>
	dmasg_interrupt_config(DMASG_BASE, DMASG_CHANNEL0, DMASG_CHANNEL_INTERRUPT_INPUT_PACKET_MASK);  //Disable dmasg channel interrupt
    4b70:	01000613          	li	a2,16
    4b74:	00000593          	li	a1,0
    4b78:	f8130537          	lui	a0,0xf8130
    4b7c:	d6cff0ef          	jal	ra,40e8 <dmasg_interrupt_config>
	dmasg_interrupt_pending_clear(DMASG_BASE,DMASG_CHANNEL1,0xFFFFFFFF);
    4b80:	fff00613          	li	a2,-1
    4b84:	00100593          	li	a1,1
    4b88:	f8130537          	lui	a0,0xf8130
    4b8c:	d74ff0ef          	jal	ra,4100 <dmasg_interrupt_pending_clear>
	dmasg_interrupt_config(DMASG_BASE, DMASG_CHANNEL1, DMASG_CHANNEL_INTERRUPT_INPUT_PACKET_MASK);  //Disable dmasg channel interrupt
    4b90:	01000613          	li	a2,16
    4b94:	00100593          	li	a1,1
    4b98:	f8130537          	lui	a0,0xf8130
    4b9c:	d4cff0ef          	jal	ra,40e8 <dmasg_interrupt_config>
	dmasg_interrupt_pending_clear(DMASG_BASE,DMASG_CHANNEL2,0xFFFFFFFF);
    4ba0:	fff00613          	li	a2,-1
    4ba4:	00200593          	li	a1,2
    4ba8:	f8130537          	lui	a0,0xf8130
    4bac:	d54ff0ef          	jal	ra,4100 <dmasg_interrupt_pending_clear>
	dmasg_interrupt_config(DMASG_BASE, DMASG_CHANNEL2, DMASG_CHANNEL_INTERRUPT_INPUT_PACKET_MASK);  //Disable dmasg channel interrupt
    4bb0:	01000613          	li	a2,16
    4bb4:	00200593          	li	a1,2
    4bb8:	f8130537          	lui	a0,0xf8130
    4bbc:	d2cff0ef          	jal	ra,40e8 <dmasg_interrupt_config>
	dmasg_interrupt_pending_clear(DMASG_BASE,DMASG_CHANNEL3,0xFFFFFFFF);
    4bc0:	fff00613          	li	a2,-1
    4bc4:	00300593          	li	a1,3
    4bc8:	f8130537          	lui	a0,0xf8130
    4bcc:	d34ff0ef          	jal	ra,4100 <dmasg_interrupt_pending_clear>
	dmasg_interrupt_config(DMASG_BASE, DMASG_CHANNEL3, DMASG_CHANNEL_INTERRUPT_INPUT_PACKET_MASK);  //Disable dmasg channel interrupt
    4bd0:	01000613          	li	a2,16
    4bd4:	00300593          	li	a1,3
    4bd8:	f8130537          	lui	a0,0xf8130
    4bdc:	d0cff0ef          	jal	ra,40e8 <dmasg_interrupt_config>
    4be0:	02092c23          	sw	zero,56(s2)
	bsp_uDelay(200000);
    4be4:	f8b00637          	lui	a2,0xf8b00
    4be8:	05f5ea37          	lui	s4,0x5f5e
    4bec:	100a0593          	addi	a1,s4,256 # 5f5e100 <__freertos_irq_stack_top+0x5f0a4d0>
    4bf0:	00031537          	lui	a0,0x31
    4bf4:	d4050513          	addi	a0,a0,-704 # 30d40 <raw_table2+0xa6f0>
    4bf8:	a8cff0ef          	jal	ra,3e84 <clint_uDelay>
	dma_video_in_channel_stop(DMASG_CHANNEL0);
    4bfc:	00000513          	li	a0,0
    4c00:	148030ef          	jal	ra,7d48 <dma_video_in_channel_stop>
	dma_video_in_channel_stop(DMASG_CHANNEL1);
    4c04:	00100513          	li	a0,1
    4c08:	140030ef          	jal	ra,7d48 <dma_video_in_channel_stop>
	dma_video_in_channel_stop(DMASG_CHANNEL2);
    4c0c:	00200513          	li	a0,2
    4c10:	138030ef          	jal	ra,7d48 <dma_video_in_channel_stop>
	dma_video_in_channel_stop(DMASG_CHANNEL3);
    4c14:	00300513          	li	a0,3
    4c18:	130030ef          	jal	ra,7d48 <dma_video_in_channel_stop>
	lastChannel = DMASG_CHANNEL0;
    4c1c:	8001ac23          	sw	zero,-2024(gp) # 52248 <lastChannel>
    4c20:	02092c23          	sw	zero,56(s2)
	bsp_uDelay(400000);
    4c24:	f8b00637          	lui	a2,0xf8b00
    4c28:	100a0593          	addi	a1,s4,256
    4c2c:	00062ab7          	lui	s5,0x62
    4c30:	a80a8513          	addi	a0,s5,-1408 # 61a80 <__freertos_irq_stack_top+0xde50>
    4c34:	a50ff0ef          	jal	ra,3e84 <clint_uDelay>
	cs_descriptor_csi_RX[0].ctrl_word = 0x0002;
    4c38:	17818793          	addi	a5,gp,376 # 52ba8 <cs_descriptor_csi_RX>
    4c3c:	00200493          	li	s1,2
    4c40:	0097a023          	sw	s1,0(a5)
	cs_descriptor_csi_RX[0].src_addr =  0;
    4c44:	0007a223          	sw	zero,4(a5)
	cs_descriptor_csi_RX[0].dst_addr = ((u32)(framebuffer_ptr[0] ));
    4c48:	00042703          	lw	a4,0(s0)
    4c4c:	00e7a423          	sw	a4,8(a5)
	cs_descriptor_csi_RX[0].nBytes = (u32)(FRAME_SIZE*4)-1;
    4c50:	001fa9b7          	lui	s3,0x1fa
    4c54:	3ff98713          	addi	a4,s3,1023 # 1fa3ff <__freertos_irq_stack_top+0x1a67cf>
    4c58:	00e7a623          	sw	a4,12(a5)
	cs_descriptor_csi_RX[1].ctrl_word = 0x0002;
    4c5c:	0097a823          	sw	s1,16(a5)
	cs_descriptor_csi_RX[1].src_addr = 0;
    4c60:	0007aa23          	sw	zero,20(a5)
	cs_descriptor_csi_RX[1].dst_addr = ((u32)(framebuffer_ptr[1] ));
    4c64:	00442683          	lw	a3,4(s0)
    4c68:	00d7ac23          	sw	a3,24(a5)
	cs_descriptor_csi_RX[1].nBytes = (u32)(FRAME_SIZE*4)-1;
    4c6c:	00e7ae23          	sw	a4,28(a5)
	cs_descriptor_csi_RX[2].ctrl_word = 0x0002;
    4c70:	0297a023          	sw	s1,32(a5)
	cs_descriptor_csi_RX[2].src_addr = 0;
    4c74:	0207a223          	sw	zero,36(a5)
	cs_descriptor_csi_RX[2].dst_addr = ((u32)(framebuffer_ptr[2] ));
    4c78:	00842683          	lw	a3,8(s0)
    4c7c:	02d7a423          	sw	a3,40(a5)
	cs_descriptor_csi_RX[2].nBytes = (u32)(FRAME_SIZE*4)-1;
    4c80:	02e7a623          	sw	a4,44(a5)
	cs_descriptor_csi_RX[3].ctrl_word = 0x0002;
    4c84:	0297a823          	sw	s1,48(a5)
	cs_descriptor_csi_RX[3].src_addr = 0;
    4c88:	0207aa23          	sw	zero,52(a5)
	cs_descriptor_csi_RX[3].dst_addr = ((u32)(framebuffer_ptr[3] ));
    4c8c:	00c42683          	lw	a3,12(s0)
    4c90:	02d7ac23          	sw	a3,56(a5)
	cs_descriptor_csi_RX[3].nBytes = (u32)(FRAME_SIZE*4)-1;
    4c94:	02e7ae23          	sw	a4,60(a5)
	dma_video_in_channel_cs_sg_execution(cs_descriptor_csi_RX, 4, DMASG_CHANNEL0);
    4c98:	00000613          	li	a2,0
    4c9c:	00400593          	li	a1,4
    4ca0:	17818513          	addi	a0,gp,376 # 52ba8 <cs_descriptor_csi_RX>
    4ca4:	15c030ef          	jal	ra,7e00 <dma_video_in_channel_cs_sg_execution>
	dma_video_in_channel_execution(framebuffer_ptr[1], 	DMASG_CHANNEL1);
    4ca8:	00100593          	li	a1,1
    4cac:	00442503          	lw	a0,4(s0)
    4cb0:	4dd020ef          	jal	ra,798c <dma_video_in_channel_execution>
	dma_video_in_channel_execution(framebuffer_ptr[2], 	DMASG_CHANNEL2);
    4cb4:	00200593          	li	a1,2
    4cb8:	00842503          	lw	a0,8(s0)
    4cbc:	4d1020ef          	jal	ra,798c <dma_video_in_channel_execution>
	dma_video_in_channel_execution(framebuffer_ptr[3],	DMASG_CHANNEL3);
    4cc0:	00300593          	li	a1,3
    4cc4:	00c42503          	lw	a0,12(s0)
    4cc8:	4c5020ef          	jal	ra,798c <dma_video_in_channel_execution>
    4ccc:	00f00b13          	li	s6,15
    4cd0:	03692c23          	sw	s6,56(s2)
	bsp_uDelay(400000);
    4cd4:	f8b00637          	lui	a2,0xf8b00
    4cd8:	100a0593          	addi	a1,s4,256
    4cdc:	a80a8513          	addi	a0,s5,-1408
    4ce0:	9a4ff0ef          	jal	ra,3e84 <clint_uDelay>
	dma_video_out_channel_execution(framebuffer_ptr[0], DMASG_CHANNEL_HDMI);
    4ce4:	00400593          	li	a1,4
    4ce8:	00042503          	lw	a0,0(s0)
    4cec:	394030ef          	jal	ra,8080 <dma_video_out_channel_execution>
	bsp_uDelay(400000);
    4cf0:	f8b00637          	lui	a2,0xf8b00
    4cf4:	100a0593          	addi	a1,s4,256
    4cf8:	a80a8513          	addi	a0,s5,-1408
    4cfc:	988ff0ef          	jal	ra,3e84 <clint_uDelay>
	cs_descriptor_csi_TX[0].ctrl_word = 0x0002;
    4d00:	1b818793          	addi	a5,gp,440 # 52be8 <cs_descriptor_csi_TX>
    4d04:	0097a023          	sw	s1,0(a5)
	cs_descriptor_csi_TX[0].src_addr = ((u32)(framebuffer_ptr[6] ));
    4d08:	01842703          	lw	a4,24(s0)
    4d0c:	00e7a223          	sw	a4,4(a5)
	cs_descriptor_csi_TX[0].dst_addr = 0;
    4d10:	0007a423          	sw	zero,8(a5)
	cs_descriptor_csi_TX[0].nBytes = (u32)(FRAME_SIZE*4);
    4d14:	40098713          	addi	a4,s3,1024
    4d18:	00e7a623          	sw	a4,12(a5)
	cs_descriptor_csi_TX[1].ctrl_word = 0x0002;
    4d1c:	0097a823          	sw	s1,16(a5)
	cs_descriptor_csi_TX[1].src_addr = ((u32)(framebuffer_ptr[7] ));
    4d20:	01c42683          	lw	a3,28(s0)
    4d24:	00d7aa23          	sw	a3,20(a5)
	cs_descriptor_csi_TX[1].dst_addr = 0;
    4d28:	0007ac23          	sw	zero,24(a5)
	cs_descriptor_csi_TX[1].nBytes = (u32)(FRAME_SIZE*4);
    4d2c:	00e7ae23          	sw	a4,28(a5)
	cs_descriptor_csi_TX[2].ctrl_word = 0x0002;
    4d30:	0297a023          	sw	s1,32(a5)
	cs_descriptor_csi_TX[2].src_addr = ((u32)(framebuffer_ptr[8] ));
    4d34:	02042683          	lw	a3,32(s0)
    4d38:	02d7a223          	sw	a3,36(a5)
	cs_descriptor_csi_TX[2].dst_addr = 0;
    4d3c:	0207a423          	sw	zero,40(a5)
	cs_descriptor_csi_TX[2].nBytes = (u32)(FRAME_SIZE*4);
    4d40:	02e7a623          	sw	a4,44(a5)
	cs_descriptor_csi_TX[3].ctrl_word = 0x0002;
    4d44:	0297a823          	sw	s1,48(a5)
	cs_descriptor_csi_TX[3].src_addr = ((u32)(framebuffer_ptr[9] ));
    4d48:	02442683          	lw	a3,36(s0)
    4d4c:	02d7aa23          	sw	a3,52(a5)
	cs_descriptor_csi_TX[3].dst_addr = 0;
    4d50:	0207ac23          	sw	zero,56(a5)
	cs_descriptor_csi_TX[3].nBytes = (u32)(FRAME_SIZE*4);
    4d54:	02e7ae23          	sw	a4,60(a5)
	dma_video_out_channel_cs_sg_execution(cs_descriptor_csi_TX, 4,DMASG_CHANNEL_DUMMY_CSI);
    4d58:	00600613          	li	a2,6
    4d5c:	00400593          	li	a1,4
    4d60:	1b818513          	addi	a0,gp,440 # 52be8 <cs_descriptor_csi_TX>
    4d64:	1e4030ef          	jal	ra,7f48 <dma_video_out_channel_cs_sg_execution>
	bsp_uDelay(400000);
    4d68:	f8b00637          	lui	a2,0xf8b00
    4d6c:	100a0593          	addi	a1,s4,256
    4d70:	a80a8513          	addi	a0,s5,-1408
    4d74:	910ff0ef          	jal	ra,3e84 <clint_uDelay>
	dma_video_out_channel_execution(framebuffer_ptr[4], DMASG_CHANNEL_OVERLAY);
    4d78:	00500593          	li	a1,5
    4d7c:	01042503          	lw	a0,16(s0)
    4d80:	300030ef          	jal	ra,8080 <dma_video_out_channel_execution>
    4d84:	02092023          	sw	zero,32(s2)
    4d88:	21c00793          	li	a5,540
    4d8c:	02f92223          	sw	a5,36(s2)
    4d90:	02092423          	sw	zero,40(s2)
    4d94:	78000793          	li	a5,1920
    4d98:	02f92623          	sw	a5,44(s2)
    4d9c:	00100793          	li	a5,1
    4da0:	02f92a23          	sw	a5,52(s2)
    4da4:	03692e23          	sw	s6,60(s2)
	cmd_cam_brightnes((cam_brightness/0x1000)&0xff, cam_brightness&0xfff);
    4da8:	8281a783          	lw	a5,-2008(gp) # 52258 <cam_brightness>
    4dac:	41f7d513          	srai	a0,a5,0x1f
    4db0:	000015b7          	lui	a1,0x1
    4db4:	fff58593          	addi	a1,a1,-1 # fff <CUSTOM2+0xfa4>
    4db8:	00b57533          	and	a0,a0,a1
    4dbc:	00f50533          	add	a0,a0,a5
    4dc0:	40c55513          	srai	a0,a0,0xc
    4dc4:	01079793          	slli	a5,a5,0x10
    4dc8:	0107d793          	srli	a5,a5,0x10
    4dcc:	00b7f5b3          	and	a1,a5,a1
    4dd0:	0ff57513          	andi	a0,a0,255
    4dd4:	839ff0ef          	jal	ra,460c <cmd_cam_brightnes>
	cmd_cam_colour_gain(cam_gain_r, cam_gain_g, cam_gain_b);
    4dd8:	81c1d603          	lhu	a2,-2020(gp) # 5224c <cam_gain_b>
    4ddc:	8201d583          	lhu	a1,-2016(gp) # 52250 <cam_gain_g>
    4de0:	8241d503          	lhu	a0,-2012(gp) # 52254 <cam_gain_r>
    4de4:	8f9ff0ef          	jal	ra,46dc <cmd_cam_colour_gain>
}
    4de8:	01c12083          	lw	ra,28(sp)
    4dec:	01812403          	lw	s0,24(sp)
    4df0:	01412483          	lw	s1,20(sp)
    4df4:	01012903          	lw	s2,16(sp)
    4df8:	00c12983          	lw	s3,12(sp)
    4dfc:	00812a03          	lw	s4,8(sp)
    4e00:	00412a83          	lw	s5,4(sp)
    4e04:	00012b03          	lw	s6,0(sp)
    4e08:	02010113          	addi	sp,sp,32
    4e0c:	00008067          	ret

00004e10 <overlay_update>:
		}
	}

	last_overlay_type = type;
*/
}
    4e10:	00008067          	ret

00004e14 <cmd_operation>:


void cmd_operation(uint8_t key )
{
    4e14:	ff010113          	addi	sp,sp,-16
    4e18:	00112623          	sw	ra,12(sp)
    4e1c:	00812423          	sw	s0,8(sp)
	if(key == '1')
    4e20:	03100793          	li	a5,49
    4e24:	08f50c63          	beq	a0,a5,4ebc <cmd_operation+0xa8>
     //  	overlay_update(1);
 		dma_video_out_execution( framebuffer_ptr[DMASG_CHANNEL0], framebuffer_ptr[DMASG_CHANNEL0]);
     	APB3_REGW(OOB_APB_SLV, APB3_SLV_REG_STREAM_OUT, 0x05);

	}
	else if (key == '2')
    4e28:	03200793          	li	a5,50
    4e2c:	0cf50e63          	beq	a0,a5,4f08 <cmd_operation+0xf4>
		bsp_uDelay(200000);
    //	overlay_update(2);
     	dma_video_out_execution( framebuffer_ptr[DMASG_CHANNEL1], framebuffer_ptr[DMASG_CHANNEL1]);
    	APB3_REGW(OOB_APB_SLV, APB3_SLV_REG_STREAM_OUT, 0x05);
	}
	else if (key == '3')
    4e30:	03300793          	li	a5,51
    4e34:	10f50e63          	beq	a0,a5,4f50 <cmd_operation+0x13c>
		bsp_uDelay(200000);
	 // 	overlay_update(3);
 		dma_video_out_execution( framebuffer_ptr[DMASG_CHANNEL2], framebuffer_ptr[DMASG_CHANNEL2]);
		APB3_REGW(OOB_APB_SLV, APB3_SLV_REG_STREAM_OUT, 0x05);
	}
	else if (key == '4')
    4e38:	03400793          	li	a5,52
    4e3c:	14f50e63          	beq	a0,a5,4f98 <cmd_operation+0x184>
		APB3_REGW(OOB_APB_SLV, APB3_SLV_REG_STREAM_OUT, 0x00);
		bsp_uDelay(200000);
		dma_video_out_execution( framebuffer_ptr[DMASG_CHANNEL3], framebuffer_ptr[DMASG_CHANNEL3]);
		APB3_REGW(OOB_APB_SLV, APB3_SLV_REG_STREAM_OUT, 0x05);
	}
	else if (key == '5')
    4e40:	03500793          	li	a5,53
    4e44:	18f50e63          	beq	a0,a5,4fe0 <cmd_operation+0x1cc>
		dma_video_out_split4_frame(framebuffer_ptr[0],framebuffer_ptr[1], framebuffer_ptr[2], framebuffer_ptr[3], descriptors0 );
		APB3_REGW(OOB_APB_SLV, APB3_SLV_REG_STREAM_OUT, 0x05);


	}
	else if (key == 'u')
    4e48:	07500793          	li	a5,117
    4e4c:	1ef50463          	beq	a0,a5,5034 <cmd_operation+0x220>
	{
		check_sd(0);
	}
	else if (key == 'v')
    4e50:	07600793          	li	a5,118
    4e54:	1ef50663          	beq	a0,a5,5040 <cmd_operation+0x22c>
	{
		check_sd(1);
	}

	else if (key =='l')
    4e58:	06c00793          	li	a5,108
    4e5c:	1ef50863          	beq	a0,a5,504c <cmd_operation+0x238>
		}
		bsp_printf("cam_brightness: 0x%x\n\r",cam_brightness);
		cmd_cam_brightnes((cam_brightness/0x1000)&0xff, cam_brightness&0xfff);

	}
	else if (key == 'L')
    4e60:	04c00793          	li	a5,76
    4e64:	24f50863          	beq	a0,a5,50b4 <cmd_operation+0x2a0>
		}
		bsp_printf("cam_brightness: 0x%x\n\r",cam_brightness);
		cmd_cam_brightnes((cam_brightness/0x1000)&0xff, cam_brightness&0xfff);

	}
	else if (key =='r')
    4e68:	07200793          	li	a5,114
    4e6c:	2af50263          	beq	a0,a5,5110 <cmd_operation+0x2fc>
			cam_gain_r = GAIN_R_MAX;
		}
		//bsp_printf("cam_gain_r: 0x%x\n\r",cam_gain_r);
		cmd_cam_colour_gain(cam_gain_r, cam_gain_g, cam_gain_b);
	}
	else if (key =='R')
    4e70:	05200793          	li	a5,82
    4e74:	2cf50a63          	beq	a0,a5,5148 <cmd_operation+0x334>
		}
		//bsp_printf("cam_gain_r: 0x%x\n\r",cam_gain_r);
		cmd_cam_colour_gain(cam_gain_r, cam_gain_g, cam_gain_b);
	}

	else if (key =='g')
    4e78:	06700793          	li	a5,103
    4e7c:	2ef50c63          	beq	a0,a5,5174 <cmd_operation+0x360>
		{
			cam_gain_g = GAIN_G_MAX;
		}
		cmd_cam_colour_gain(cam_gain_r, cam_gain_g, cam_gain_b);
	}
	else if (key =='G')
    4e80:	04700793          	li	a5,71
    4e84:	32f50463          	beq	a0,a5,51ac <cmd_operation+0x398>
			cam_gain_g = GAIN_G_MIN;
		}
		cmd_cam_colour_gain(cam_gain_r, cam_gain_g, cam_gain_b);
	}

	else if (key =='b')
    4e88:	06200793          	li	a5,98
    4e8c:	34f50663          	beq	a0,a5,51d8 <cmd_operation+0x3c4>
			{
				cam_gain_b = GAIN_B_MAX;
			}
			cmd_cam_colour_gain(cam_gain_r, cam_gain_g, cam_gain_b);
	}
	else if (key =='B')
    4e90:	04200793          	li	a5,66
    4e94:	06f51263          	bne	a0,a5,4ef8 <cmd_operation+0xe4>
	{
			cam_gain_b -= GAIN_B_STEP;
    4e98:	81c1a783          	lw	a5,-2020(gp) # 5224c <cam_gain_b>
    4e9c:	f8078793          	addi	a5,a5,-128
    4ea0:	80f1ae23          	sw	a5,-2020(gp) # 5224c <cam_gain_b>
			if(cam_gain_b <= GAIN_B_MIN)
    4ea4:	36f05663          	blez	a5,5210 <cmd_operation+0x3fc>
			{
				cam_gain_b = GAIN_B_MIN;
			}
			cmd_cam_colour_gain(cam_gain_r, cam_gain_g, cam_gain_b);
    4ea8:	81c1d603          	lhu	a2,-2020(gp) # 5224c <cam_gain_b>
    4eac:	8201d583          	lhu	a1,-2016(gp) # 52250 <cam_gain_g>
    4eb0:	8241d503          	lhu	a0,-2012(gp) # 52254 <cam_gain_r>
    4eb4:	829ff0ef          	jal	ra,46dc <cmd_cam_colour_gain>
	}

}
    4eb8:	0400006f          	j	4ef8 <cmd_operation+0xe4>
		swithCmdPtr = 0;
    4ebc:	8601a023          	sw	zero,-1952(gp) # 52290 <swithCmdPtr>
		dma_video_out_stop();
    4ec0:	6c5020ef          	jal	ra,7d84 <dma_video_out_stop>
    4ec4:	f8110437          	lui	s0,0xf8110
    4ec8:	02042e23          	sw	zero,60(s0) # f811003c <__freertos_irq_stack_top+0xf80bc40c>
     	bsp_uDelay(200000);
    4ecc:	f8b00637          	lui	a2,0xf8b00
    4ed0:	05f5e5b7          	lui	a1,0x5f5e
    4ed4:	10058593          	addi	a1,a1,256 # 5f5e100 <__freertos_irq_stack_top+0x5f0a4d0>
    4ed8:	00031537          	lui	a0,0x31
    4edc:	d4050513          	addi	a0,a0,-704 # 30d40 <raw_table2+0xa6f0>
    4ee0:	fa5fe0ef          	jal	ra,3e84 <clint_uDelay>
 		dma_video_out_execution( framebuffer_ptr[DMASG_CHANNEL0], framebuffer_ptr[DMASG_CHANNEL0]);
    4ee4:	1501a503          	lw	a0,336(gp) # 52b80 <framebuffer_ptr>
    4ee8:	00050593          	mv	a1,a0
    4eec:	240030ef          	jal	ra,812c <dma_video_out_execution>
    4ef0:	00500793          	li	a5,5
    4ef4:	02f42e23          	sw	a5,60(s0)
}
    4ef8:	00c12083          	lw	ra,12(sp)
    4efc:	00812403          	lw	s0,8(sp)
    4f00:	01010113          	addi	sp,sp,16
    4f04:	00008067          	ret
		swithCmdPtr = 1;
    4f08:	00100713          	li	a4,1
    4f0c:	86e1a023          	sw	a4,-1952(gp) # 52290 <swithCmdPtr>
		dma_video_out_stop();
    4f10:	675020ef          	jal	ra,7d84 <dma_video_out_stop>
    4f14:	f8110437          	lui	s0,0xf8110
    4f18:	02042e23          	sw	zero,60(s0) # f811003c <__freertos_irq_stack_top+0xf80bc40c>
		bsp_uDelay(200000);
    4f1c:	f8b00637          	lui	a2,0xf8b00
    4f20:	05f5e5b7          	lui	a1,0x5f5e
    4f24:	10058593          	addi	a1,a1,256 # 5f5e100 <__freertos_irq_stack_top+0x5f0a4d0>
    4f28:	00031537          	lui	a0,0x31
    4f2c:	d4050513          	addi	a0,a0,-704 # 30d40 <raw_table2+0xa6f0>
    4f30:	f55fe0ef          	jal	ra,3e84 <clint_uDelay>
     	dma_video_out_execution( framebuffer_ptr[DMASG_CHANNEL1], framebuffer_ptr[DMASG_CHANNEL1]);
    4f34:	15018793          	addi	a5,gp,336 # 52b80 <framebuffer_ptr>
    4f38:	0047a503          	lw	a0,4(a5)
    4f3c:	00050593          	mv	a1,a0
    4f40:	1ec030ef          	jal	ra,812c <dma_video_out_execution>
    4f44:	00500793          	li	a5,5
    4f48:	02f42e23          	sw	a5,60(s0)
    4f4c:	fadff06f          	j	4ef8 <cmd_operation+0xe4>
		swithCmdPtr = 2;
    4f50:	00200713          	li	a4,2
    4f54:	86e1a023          	sw	a4,-1952(gp) # 52290 <swithCmdPtr>
		dma_video_out_stop();
    4f58:	62d020ef          	jal	ra,7d84 <dma_video_out_stop>
    4f5c:	f8110437          	lui	s0,0xf8110
    4f60:	02042e23          	sw	zero,60(s0) # f811003c <__freertos_irq_stack_top+0xf80bc40c>
		bsp_uDelay(200000);
    4f64:	f8b00637          	lui	a2,0xf8b00
    4f68:	05f5e5b7          	lui	a1,0x5f5e
    4f6c:	10058593          	addi	a1,a1,256 # 5f5e100 <__freertos_irq_stack_top+0x5f0a4d0>
    4f70:	00031537          	lui	a0,0x31
    4f74:	d4050513          	addi	a0,a0,-704 # 30d40 <raw_table2+0xa6f0>
    4f78:	f0dfe0ef          	jal	ra,3e84 <clint_uDelay>
 		dma_video_out_execution( framebuffer_ptr[DMASG_CHANNEL2], framebuffer_ptr[DMASG_CHANNEL2]);
    4f7c:	15018793          	addi	a5,gp,336 # 52b80 <framebuffer_ptr>
    4f80:	0087a503          	lw	a0,8(a5)
    4f84:	00050593          	mv	a1,a0
    4f88:	1a4030ef          	jal	ra,812c <dma_video_out_execution>
    4f8c:	00500793          	li	a5,5
    4f90:	02f42e23          	sw	a5,60(s0)
    4f94:	f65ff06f          	j	4ef8 <cmd_operation+0xe4>
		swithCmdPtr = 3;
    4f98:	00300713          	li	a4,3
    4f9c:	86e1a023          	sw	a4,-1952(gp) # 52290 <swithCmdPtr>
		dma_video_out_stop();
    4fa0:	5e5020ef          	jal	ra,7d84 <dma_video_out_stop>
    4fa4:	f8110437          	lui	s0,0xf8110
    4fa8:	02042e23          	sw	zero,60(s0) # f811003c <__freertos_irq_stack_top+0xf80bc40c>
		bsp_uDelay(200000);
    4fac:	f8b00637          	lui	a2,0xf8b00
    4fb0:	05f5e5b7          	lui	a1,0x5f5e
    4fb4:	10058593          	addi	a1,a1,256 # 5f5e100 <__freertos_irq_stack_top+0x5f0a4d0>
    4fb8:	00031537          	lui	a0,0x31
    4fbc:	d4050513          	addi	a0,a0,-704 # 30d40 <raw_table2+0xa6f0>
    4fc0:	ec5fe0ef          	jal	ra,3e84 <clint_uDelay>
		dma_video_out_execution( framebuffer_ptr[DMASG_CHANNEL3], framebuffer_ptr[DMASG_CHANNEL3]);
    4fc4:	15018793          	addi	a5,gp,336 # 52b80 <framebuffer_ptr>
    4fc8:	00c7a503          	lw	a0,12(a5)
    4fcc:	00050593          	mv	a1,a0
    4fd0:	15c030ef          	jal	ra,812c <dma_video_out_execution>
    4fd4:	00500793          	li	a5,5
    4fd8:	02f42e23          	sw	a5,60(s0)
    4fdc:	f1dff06f          	j	4ef8 <cmd_operation+0xe4>
		swithCmdPtr = 4;
    4fe0:	00400713          	li	a4,4
    4fe4:	86e1a023          	sw	a4,-1952(gp) # 52290 <swithCmdPtr>
		dma_video_out_stop();
    4fe8:	59d020ef          	jal	ra,7d84 <dma_video_out_stop>
    4fec:	f8110437          	lui	s0,0xf8110
    4ff0:	02042e23          	sw	zero,60(s0) # f811003c <__freertos_irq_stack_top+0xf80bc40c>
		bsp_uDelay(200000);
    4ff4:	f8b00637          	lui	a2,0xf8b00
    4ff8:	05f5e5b7          	lui	a1,0x5f5e
    4ffc:	10058593          	addi	a1,a1,256 # 5f5e100 <__freertos_irq_stack_top+0x5f0a4d0>
    5000:	00031537          	lui	a0,0x31
    5004:	d4050513          	addi	a0,a0,-704 # 30d40 <raw_table2+0xa6f0>
    5008:	e7dfe0ef          	jal	ra,3e84 <clint_uDelay>
		dma_video_out_split4_frame(framebuffer_ptr[0],framebuffer_ptr[1], framebuffer_ptr[2], framebuffer_ptr[3], descriptors0 );
    500c:	15018793          	addi	a5,gp,336 # 52b80 <framebuffer_ptr>
    5010:	0a000737          	lui	a4,0xa000
    5014:	00c7a683          	lw	a3,12(a5)
    5018:	0087a603          	lw	a2,8(a5)
    501c:	0047a583          	lw	a1,4(a5)
    5020:	0007a503          	lw	a0,0(a5)
    5024:	1a4030ef          	jal	ra,81c8 <dma_video_out_split4_frame>
    5028:	00500793          	li	a5,5
    502c:	02f42e23          	sw	a5,60(s0)
    5030:	ec9ff06f          	j	4ef8 <cmd_operation+0xe4>
		check_sd(0);
    5034:	00000513          	li	a0,0
    5038:	a48ff0ef          	jal	ra,4280 <check_sd>
    503c:	ebdff06f          	j	4ef8 <cmd_operation+0xe4>
		check_sd(1);
    5040:	00100513          	li	a0,1
    5044:	a3cff0ef          	jal	ra,4280 <check_sd>
    5048:	eb1ff06f          	j	4ef8 <cmd_operation+0xe4>
		cam_brightness += BRIGHTNESS_STEP;
    504c:	8281a783          	lw	a5,-2008(gp) # 52258 <cam_brightness>
    5050:	20078793          	addi	a5,a5,512
    5054:	82f1a423          	sw	a5,-2008(gp) # 52258 <cam_brightness>
		if(cam_brightness>=BRIGHTNESS_MAX)
    5058:	00100737          	lui	a4,0x100
    505c:	ffe70713          	addi	a4,a4,-2 # ffffe <__freertos_irq_stack_top+0xac3ce>
    5060:	00f75863          	bge	a4,a5,5070 <cmd_operation+0x25c>
			cam_brightness = BRIGHTNESS_MAX;
    5064:	001007b7          	lui	a5,0x100
    5068:	fff78793          	addi	a5,a5,-1 # fffff <__freertos_irq_stack_top+0xac3cf>
    506c:	82f1a423          	sw	a5,-2008(gp) # 52258 <cam_brightness>
		bsp_printf("cam_brightness: 0x%x\n\r",cam_brightness);
    5070:	8281a583          	lw	a1,-2008(gp) # 52258 <cam_brightness>
    5074:	00009537          	lui	a0,0x9
    5078:	05450513          	addi	a0,a0,84 # 9054 <_data+0x5ac>
    507c:	8acff0ef          	jal	ra,4128 <bsp_printf>
		cmd_cam_brightnes((cam_brightness/0x1000)&0xff, cam_brightness&0xfff);
    5080:	8281a783          	lw	a5,-2008(gp) # 52258 <cam_brightness>
    5084:	41f7d513          	srai	a0,a5,0x1f
    5088:	000015b7          	lui	a1,0x1
    508c:	fff58593          	addi	a1,a1,-1 # fff <CUSTOM2+0xfa4>
    5090:	00b57533          	and	a0,a0,a1
    5094:	00f50533          	add	a0,a0,a5
    5098:	40c55513          	srai	a0,a0,0xc
    509c:	01079793          	slli	a5,a5,0x10
    50a0:	0107d793          	srli	a5,a5,0x10
    50a4:	00b7f5b3          	and	a1,a5,a1
    50a8:	0ff57513          	andi	a0,a0,255
    50ac:	d60ff0ef          	jal	ra,460c <cmd_cam_brightnes>
    50b0:	e49ff06f          	j	4ef8 <cmd_operation+0xe4>
		cam_brightness -= BRIGHTNESS_STEP;
    50b4:	8281a783          	lw	a5,-2008(gp) # 52258 <cam_brightness>
    50b8:	e0078793          	addi	a5,a5,-512
    50bc:	82f1a423          	sw	a5,-2008(gp) # 52258 <cam_brightness>
		if(cam_brightness<=BRIGHTNESS_MIN)
    50c0:	20000713          	li	a4,512
    50c4:	00f74463          	blt	a4,a5,50cc <cmd_operation+0x2b8>
			cam_brightness = BRIGHTNESS_MIN;
    50c8:	82e1a423          	sw	a4,-2008(gp) # 52258 <cam_brightness>
		bsp_printf("cam_brightness: 0x%x\n\r",cam_brightness);
    50cc:	8281a583          	lw	a1,-2008(gp) # 52258 <cam_brightness>
    50d0:	00009537          	lui	a0,0x9
    50d4:	05450513          	addi	a0,a0,84 # 9054 <_data+0x5ac>
    50d8:	850ff0ef          	jal	ra,4128 <bsp_printf>
		cmd_cam_brightnes((cam_brightness/0x1000)&0xff, cam_brightness&0xfff);
    50dc:	8281a783          	lw	a5,-2008(gp) # 52258 <cam_brightness>
    50e0:	41f7d513          	srai	a0,a5,0x1f
    50e4:	000015b7          	lui	a1,0x1
    50e8:	fff58593          	addi	a1,a1,-1 # fff <CUSTOM2+0xfa4>
    50ec:	00b57533          	and	a0,a0,a1
    50f0:	00f50533          	add	a0,a0,a5
    50f4:	40c55513          	srai	a0,a0,0xc
    50f8:	01079793          	slli	a5,a5,0x10
    50fc:	0107d793          	srli	a5,a5,0x10
    5100:	00b7f5b3          	and	a1,a5,a1
    5104:	0ff57513          	andi	a0,a0,255
    5108:	d04ff0ef          	jal	ra,460c <cmd_cam_brightnes>
    510c:	dedff06f          	j	4ef8 <cmd_operation+0xe4>
		cam_gain_r += GAIN_R_STEP;
    5110:	8241a783          	lw	a5,-2012(gp) # 52254 <cam_gain_r>
    5114:	08078793          	addi	a5,a5,128
    5118:	82f1a223          	sw	a5,-2012(gp) # 52254 <cam_gain_r>
		if(cam_gain_r>=GAIN_R_MAX)
    511c:	00001737          	lui	a4,0x1
    5120:	ffe70713          	addi	a4,a4,-2 # ffe <CUSTOM2+0xfa3>
    5124:	00f75863          	bge	a4,a5,5134 <cmd_operation+0x320>
			cam_gain_r = GAIN_R_MAX;
    5128:	000017b7          	lui	a5,0x1
    512c:	fff78793          	addi	a5,a5,-1 # fff <CUSTOM2+0xfa4>
    5130:	82f1a223          	sw	a5,-2012(gp) # 52254 <cam_gain_r>
		cmd_cam_colour_gain(cam_gain_r, cam_gain_g, cam_gain_b);
    5134:	81c1d603          	lhu	a2,-2020(gp) # 5224c <cam_gain_b>
    5138:	8201d583          	lhu	a1,-2016(gp) # 52250 <cam_gain_g>
    513c:	8241d503          	lhu	a0,-2012(gp) # 52254 <cam_gain_r>
    5140:	d9cff0ef          	jal	ra,46dc <cmd_cam_colour_gain>
    5144:	db5ff06f          	j	4ef8 <cmd_operation+0xe4>
		cam_gain_r -= GAIN_R_STEP;
    5148:	8241a783          	lw	a5,-2012(gp) # 52254 <cam_gain_r>
    514c:	f8078793          	addi	a5,a5,-128
    5150:	82f1a223          	sw	a5,-2012(gp) # 52254 <cam_gain_r>
		if(cam_gain_r<=GAIN_R_MIN)
    5154:	00f05c63          	blez	a5,516c <cmd_operation+0x358>
		cmd_cam_colour_gain(cam_gain_r, cam_gain_g, cam_gain_b);
    5158:	81c1d603          	lhu	a2,-2020(gp) # 5224c <cam_gain_b>
    515c:	8201d583          	lhu	a1,-2016(gp) # 52250 <cam_gain_g>
    5160:	8241d503          	lhu	a0,-2012(gp) # 52254 <cam_gain_r>
    5164:	d78ff0ef          	jal	ra,46dc <cmd_cam_colour_gain>
    5168:	d91ff06f          	j	4ef8 <cmd_operation+0xe4>
			cam_gain_r = GAIN_R_MIN;
    516c:	8201a223          	sw	zero,-2012(gp) # 52254 <cam_gain_r>
    5170:	fe9ff06f          	j	5158 <cmd_operation+0x344>
		cam_gain_g += GAIN_G_STEP;
    5174:	8201a783          	lw	a5,-2016(gp) # 52250 <cam_gain_g>
    5178:	08078793          	addi	a5,a5,128
    517c:	82f1a023          	sw	a5,-2016(gp) # 52250 <cam_gain_g>
		if(cam_gain_g>=GAIN_G_MAX)
    5180:	00001737          	lui	a4,0x1
    5184:	ffe70713          	addi	a4,a4,-2 # ffe <CUSTOM2+0xfa3>
    5188:	00f75863          	bge	a4,a5,5198 <cmd_operation+0x384>
			cam_gain_g = GAIN_G_MAX;
    518c:	000017b7          	lui	a5,0x1
    5190:	fff78793          	addi	a5,a5,-1 # fff <CUSTOM2+0xfa4>
    5194:	82f1a023          	sw	a5,-2016(gp) # 52250 <cam_gain_g>
		cmd_cam_colour_gain(cam_gain_r, cam_gain_g, cam_gain_b);
    5198:	81c1d603          	lhu	a2,-2020(gp) # 5224c <cam_gain_b>
    519c:	8201d583          	lhu	a1,-2016(gp) # 52250 <cam_gain_g>
    51a0:	8241d503          	lhu	a0,-2012(gp) # 52254 <cam_gain_r>
    51a4:	d38ff0ef          	jal	ra,46dc <cmd_cam_colour_gain>
    51a8:	d51ff06f          	j	4ef8 <cmd_operation+0xe4>
		cam_gain_g -= GAIN_G_STEP;
    51ac:	8201a783          	lw	a5,-2016(gp) # 52250 <cam_gain_g>
    51b0:	f8078793          	addi	a5,a5,-128
    51b4:	82f1a023          	sw	a5,-2016(gp) # 52250 <cam_gain_g>
		if(cam_gain_g<=GAIN_G_MIN)
    51b8:	00f05c63          	blez	a5,51d0 <cmd_operation+0x3bc>
		cmd_cam_colour_gain(cam_gain_r, cam_gain_g, cam_gain_b);
    51bc:	81c1d603          	lhu	a2,-2020(gp) # 5224c <cam_gain_b>
    51c0:	8201d583          	lhu	a1,-2016(gp) # 52250 <cam_gain_g>
    51c4:	8241d503          	lhu	a0,-2012(gp) # 52254 <cam_gain_r>
    51c8:	d14ff0ef          	jal	ra,46dc <cmd_cam_colour_gain>
    51cc:	d2dff06f          	j	4ef8 <cmd_operation+0xe4>
			cam_gain_g = GAIN_G_MIN;
    51d0:	8201a023          	sw	zero,-2016(gp) # 52250 <cam_gain_g>
    51d4:	fe9ff06f          	j	51bc <cmd_operation+0x3a8>
			cam_gain_b += GAIN_B_STEP;
    51d8:	81c1a783          	lw	a5,-2020(gp) # 5224c <cam_gain_b>
    51dc:	08078793          	addi	a5,a5,128
    51e0:	80f1ae23          	sw	a5,-2020(gp) # 5224c <cam_gain_b>
			if(cam_gain_b>=GAIN_B_MAX)
    51e4:	00001737          	lui	a4,0x1
    51e8:	ffe70713          	addi	a4,a4,-2 # ffe <CUSTOM2+0xfa3>
    51ec:	00f75863          	bge	a4,a5,51fc <cmd_operation+0x3e8>
				cam_gain_b = GAIN_B_MAX;
    51f0:	000017b7          	lui	a5,0x1
    51f4:	fff78793          	addi	a5,a5,-1 # fff <CUSTOM2+0xfa4>
    51f8:	80f1ae23          	sw	a5,-2020(gp) # 5224c <cam_gain_b>
			cmd_cam_colour_gain(cam_gain_r, cam_gain_g, cam_gain_b);
    51fc:	81c1d603          	lhu	a2,-2020(gp) # 5224c <cam_gain_b>
    5200:	8201d583          	lhu	a1,-2016(gp) # 52250 <cam_gain_g>
    5204:	8241d503          	lhu	a0,-2012(gp) # 52254 <cam_gain_r>
    5208:	cd4ff0ef          	jal	ra,46dc <cmd_cam_colour_gain>
    520c:	cedff06f          	j	4ef8 <cmd_operation+0xe4>
				cam_gain_b = GAIN_B_MIN;
    5210:	8001ae23          	sw	zero,-2020(gp) # 5224c <cam_gain_b>
    5214:	c95ff06f          	j	4ea8 <cmd_operation+0x94>

00005218 <switch2cmd>:
u32 NextDisplayMode	= 0x01; // next display mode 0: Camera Mode, 1: Colour Pattern Mode, 2:All Black Pattern Mode



void switch2cmd()
{
    5218:	fe010113          	addi	sp,sp,-32
    521c:	00112e23          	sw	ra,28(sp)
	uint8_t command[5] = {'1','2','3','4','5'};
    5220:	83818793          	addi	a5,gp,-1992 # 52268 <_impure_ptr+0x4>
    5224:	0007a703          	lw	a4,0(a5)
    5228:	00e12423          	sw	a4,8(sp)
    522c:	0047c783          	lbu	a5,4(a5)
    5230:	00f10623          	sb	a5,12(sp)

	swithCmdPtr++;
    5234:	8601a783          	lw	a5,-1952(gp) # 52290 <swithCmdPtr>
    5238:	00178793          	addi	a5,a5,1
    523c:	86f1a023          	sw	a5,-1952(gp) # 52290 <swithCmdPtr>
	if(swithCmdPtr>=5)
    5240:	00400713          	li	a4,4
    5244:	00f77463          	bgeu	a4,a5,524c <switch2cmd+0x34>
	{
		swithCmdPtr=0;
    5248:	8601a023          	sw	zero,-1952(gp) # 52290 <swithCmdPtr>

	}
	cmd_operation(command[swithCmdPtr]);
    524c:	8601a783          	lw	a5,-1952(gp) # 52290 <swithCmdPtr>
    5250:	01010713          	addi	a4,sp,16
    5254:	00f707b3          	add	a5,a4,a5
    5258:	ff87c503          	lbu	a0,-8(a5)
    525c:	bb9ff0ef          	jal	ra,4e14 <cmd_operation>

}
    5260:	01c12083          	lw	ra,28(sp)
    5264:	02010113          	addi	sp,sp,32
    5268:	00008067          	ret

0000526c <swtich_event>:
void swtich_event()
{
    526c:	ff010113          	addi	sp,sp,-16
    5270:	00112623          	sw	ra,12(sp)
    5274:	00812423          	sw	s0,8(sp)
        return *((volatile u32*) address);
    5278:	f81107b7          	lui	a5,0xf8110
    527c:	0147a403          	lw	s0,20(a5) # f8110014 <__freertos_irq_stack_top+0xf80bc3e4>

	u32 rd_apb3 = APB3_REGR(OOB_APB_SLV, APB3_SLV_REG5_SW_IN);
	rd_apb3 &= MASK_ALL;
    5280:	00347413          	andi	s0,s0,3


	if(last_switch!=rd_apb3)
    5284:	8141a783          	lw	a5,-2028(gp) # 52244 <last_switch>
    5288:	02878c63          	beq	a5,s0,52c0 <swtich_event+0x54>
    528c:	f8110737          	lui	a4,0xf8110
    5290:	00472783          	lw	a5,4(a4) # f8110004 <__freertos_irq_stack_top+0xf80bc3d4>
	{
		//bsp_printf("Event Switch 0x%x\n\r",rd_apb3);
		u32 apb3_rd = APB3_REGR(OOB_APB_SLV, APB3_SLV0_REG1_LED);
		apb3_rd &= (~0x02);
    5294:	ffd7f793          	andi	a5,a5,-3
        *((volatile u32*) address) = data;
    5298:	00f72223          	sw	a5,4(a4)
		APB3_REGW(OOB_APB_SLV, APB3_SLV0_REG1_LED, apb3_rd);


		if(rd_apb3 != MASK_ALL)
    529c:	00300793          	li	a5,3
    52a0:	00f40863          	beq	s0,a5,52b0 <swtich_event+0x44>
        return *((volatile u32*) address);
    52a4:	f81107b7          	lui	a5,0xf8110
    52a8:	0147a403          	lw	s0,20(a5) # f8110014 <__freertos_irq_stack_top+0xf80bc3e4>
		{
			rd_apb3 = APB3_REGR(OOB_APB_SLV, APB3_SLV_REG5_SW_IN);
			rd_apb3 &= MASK_ALL;
    52ac:	00347413          	andi	s0,s0,3

		}


		if(rd_apb3==MASK_SW1)
    52b0:	00200793          	li	a5,2
    52b4:	02f40063          	beq	s0,a5,52d4 <swtich_event+0x68>
		{
			 bsp_printf("Event Switch 0\n\r");

		}
		else if(rd_apb3==MASK_SW2)
    52b8:	00100793          	li	a5,1
    52bc:	02f40463          	beq	s0,a5,52e4 <swtich_event+0x78>
			 bsp_printf("Event Switch 1\n\r");
			 switch2cmd();
		}
	}

	last_switch = rd_apb3;
    52c0:	8081aa23          	sw	s0,-2028(gp) # 52244 <last_switch>



}
    52c4:	00c12083          	lw	ra,12(sp)
    52c8:	00812403          	lw	s0,8(sp)
    52cc:	01010113          	addi	sp,sp,16
    52d0:	00008067          	ret
			 bsp_printf("Event Switch 0\n\r");
    52d4:	00009537          	lui	a0,0x9
    52d8:	06c50513          	addi	a0,a0,108 # 906c <_data+0x5c4>
    52dc:	e4dfe0ef          	jal	ra,4128 <bsp_printf>
    52e0:	fe1ff06f          	j	52c0 <swtich_event+0x54>
			 bsp_printf("Event Switch 1\n\r");
    52e4:	00009537          	lui	a0,0x9
    52e8:	08050513          	addi	a0,a0,128 # 9080 <_data+0x5d8>
    52ec:	e3dfe0ef          	jal	ra,4128 <bsp_printf>
			 switch2cmd();
    52f0:	f29ff0ef          	jal	ra,5218 <switch2cmd>
    52f4:	fcdff06f          	j	52c0 <swtich_event+0x54>

000052f8 <main>:

void main(){
    52f8:	ff010113          	addi	sp,sp,-16
    52fc:	00112623          	sw	ra,12(sp)
    5300:	00812423          	sw	s0,8(sp)
	int index=0;

	bsp_printf("************** TI180 OOBTest *******************\r\n");
    5304:	00009537          	lui	a0,0x9
    5308:	09450513          	addi	a0,a0,148 # 9094 <_data+0x5ec>
    530c:	e1dfe0ef          	jal	ra,4128 <bsp_printf>
	bsp_printf("Version :  %s\r\n", VERSION);
    5310:	000095b7          	lui	a1,0x9
    5314:	0c858593          	addi	a1,a1,200 # 90c8 <_data+0x620>
    5318:	00009537          	lui	a0,0x9
    531c:	0cc50513          	addi	a0,a0,204 # 90cc <_data+0x624>
    5320:	e09fe0ef          	jal	ra,4128 <bsp_printf>


	uint8_t key;

	IntcInitialize();
    5324:	95dfe0ef          	jal	ra,3c80 <IntcInitialize>
    5328:	f81107b7          	lui	a5,0xf8110
    532c:	0407a583          	lw	a1,64(a5) # f8110040 <__freertos_irq_stack_top+0xf80bc410>

	u32 HardConfig = APB3_REGR(OOB_APB_SLV, APB3_SLV_REG_HARD_CONFIG);
	bsp_printf("Hardware Configuration Code: 0x%x\n\r",HardConfig);
    5330:	00009537          	lui	a0,0x9
    5334:	0dc50513          	addi	a0,a0,220 # 90dc <_data+0x634>
    5338:	df1fe0ef          	jal	ra,4128 <bsp_printf>


	inital_video_stream();
    533c:	ce8ff0ef          	jal	ra,4824 <inital_video_stream>
    5340:	0200006f          	j	5360 <main+0x68>

	            cmd_operation(key );


	        }
	        bsp_uDelay(100000);
    5344:	f8b00637          	lui	a2,0xf8b00
    5348:	05f5e5b7          	lui	a1,0x5f5e
    534c:	10058593          	addi	a1,a1,256 # 5f5e100 <__freertos_irq_stack_top+0x5f0a4d0>
    5350:	00018537          	lui	a0,0x18
    5354:	6a050513          	addi	a0,a0,1696 # 186a0 <raw_table3+0x5e8>
    5358:	b2dfe0ef          	jal	ra,3e84 <clint_uDelay>
	        swtich_event();
    535c:	f11ff0ef          	jal	ra,526c <swtich_event>
	        if(uart_readOccupancy(BSP_UART_TERMINAL)){
    5360:	f8010537          	lui	a0,0xf8010
    5364:	a35fe0ef          	jal	ra,3d98 <uart_readOccupancy>
    5368:	fc050ee3          	beqz	a0,5344 <main+0x4c>
	        	key=uart_read(BSP_UART_TERMINAL);
    536c:	f8010537          	lui	a0,0xf8010
    5370:	ab5fe0ef          	jal	ra,3e24 <uart_read>
    5374:	00050413          	mv	s0,a0
	            bsp_putString("echo character:");
    5378:	000095b7          	lui	a1,0x9
    537c:	e8858593          	addi	a1,a1,-376 # 8e88 <_data+0x3e0>
    5380:	f8010537          	lui	a0,0xf8010
    5384:	a5dfe0ef          	jal	ra,3de0 <uart_writeStr>
	            bsp_putChar(key);
    5388:	00040593          	mv	a1,s0
    538c:	f8010537          	lui	a0,0xf8010
    5390:	a15fe0ef          	jal	ra,3da4 <uart_write>
	            bsp_putString("\n\r");
    5394:	000515b7          	lui	a1,0x51
    5398:	78c58593          	addi	a1,a1,1932 # 5178c <raw_table+0xe60c>
    539c:	f8010537          	lui	a0,0xf8010
    53a0:	a41fe0ef          	jal	ra,3de0 <uart_writeStr>
	            cmd_operation(key );
    53a4:	00040513          	mv	a0,s0
    53a8:	a6dff0ef          	jal	ra,4e14 <cmd_operation>
    53ac:	f99ff06f          	j	5344 <main+0x4c>

000053b0 <uart_writeAvailability>:
    53b0:	00452503          	lw	a0,4(a0) # f8010004 <__freertos_irq_stack_top+0xf7fbc3d4>
        return (read_u32(reg + UART_STATUS) >> 16) & 0xFF;
    53b4:	01055513          	srli	a0,a0,0x10
    }
    53b8:	0ff57513          	andi	a0,a0,255
    53bc:	00008067          	ret

000053c0 <uart_write>:
    static void uart_write(u32 reg, char data){
    53c0:	ff010113          	addi	sp,sp,-16
    53c4:	00112623          	sw	ra,12(sp)
    53c8:	00812423          	sw	s0,8(sp)
    53cc:	00912223          	sw	s1,4(sp)
    53d0:	00050413          	mv	s0,a0
    53d4:	00058493          	mv	s1,a1
        while(uart_writeAvailability(reg) == 0);
    53d8:	00040513          	mv	a0,s0
    53dc:	fd5ff0ef          	jal	ra,53b0 <uart_writeAvailability>
    53e0:	fe050ce3          	beqz	a0,53d8 <uart_write+0x18>
        *((volatile u32*) address) = data;
    53e4:	00942023          	sw	s1,0(s0)
    }
    53e8:	00c12083          	lw	ra,12(sp)
    53ec:	00812403          	lw	s0,8(sp)
    53f0:	00412483          	lw	s1,4(sp)
    53f4:	01010113          	addi	sp,sp,16
    53f8:	00008067          	ret

000053fc <uart_writeStr>:
    static void uart_writeStr(u32 reg, const char* str){
    53fc:	ff010113          	addi	sp,sp,-16
    5400:	00112623          	sw	ra,12(sp)
    5404:	00812423          	sw	s0,8(sp)
    5408:	00912223          	sw	s1,4(sp)
    540c:	00050493          	mv	s1,a0
    5410:	00058413          	mv	s0,a1
        while(*str) uart_write(reg, *str++);
    5414:	00044583          	lbu	a1,0(s0)
    5418:	00058a63          	beqz	a1,542c <uart_writeStr+0x30>
    541c:	00140413          	addi	s0,s0,1
    5420:	00048513          	mv	a0,s1
    5424:	f9dff0ef          	jal	ra,53c0 <uart_write>
    5428:	fedff06f          	j	5414 <uart_writeStr+0x18>
    }
    542c:	00c12083          	lw	ra,12(sp)
    5430:	00812403          	lw	s0,8(sp)
    5434:	00412483          	lw	s1,4(sp)
    5438:	01010113          	addi	sp,sp,16
    543c:	00008067          	ret

00005440 <Reg_Out32>:
    5440:	00b52023          	sw	a1,0(a0)

/************************** Function File ***************************/
void Reg_Out32(u32 addr,u32 data)
{
    write_u32(data,addr);
}
    5444:	00008067          	ret

00005448 <Reg_In32>:
        return *((volatile u32*) address);
    5448:	00052503          	lw	a0,0(a0)

u32 Reg_In32(u32 addr)
{
    return read_u32(addr);
}
    544c:	00008067          	ret

00005450 <assert>:
    va_end(ap);
}
*/

int assert(int cond){
    if(!cond) {
    5450:	00050663          	beqz	a0,545c <assert+0xc>
        uart_writeStr(BSP_UART_TERMINAL, " Assert failure !\n");
        return 1;
        //while(1);
    }
    return 0;
    5454:	00000513          	li	a0,0
}
    5458:	00008067          	ret
int assert(int cond){
    545c:	ff010113          	addi	sp,sp,-16
    5460:	00112623          	sw	ra,12(sp)
        uart_writeStr(BSP_UART_TERMINAL, " Assert failure !\n");
    5464:	000095b7          	lui	a1,0x9
    5468:	10058593          	addi	a1,a1,256 # 9100 <_data+0x658>
    546c:	f8010537          	lui	a0,0xf8010
    5470:	f8dff0ef          	jal	ra,53fc <uart_writeStr>
        return 1;
    5474:	00100513          	li	a0,1
}
    5478:	00c12083          	lw	ra,12(sp)
    547c:	01010113          	addi	sp,sp,16
    5480:	00008067          	ret

00005484 <putchar>:
  }
  putchar('\n');
  return 0;
}

int putchar(int c){
    5484:	ff010113          	addi	sp,sp,-16
    5488:	00112623          	sw	ra,12(sp)
    548c:	00812423          	sw	s0,8(sp)
    5490:	00050413          	mv	s0,a0
    bsp_putChar(c);
    5494:	0ff57593          	andi	a1,a0,255
    5498:	f8010537          	lui	a0,0xf8010
    549c:	f25ff0ef          	jal	ra,53c0 <uart_write>
    return c;
}
    54a0:	00040513          	mv	a0,s0
    54a4:	00c12083          	lw	ra,12(sp)
    54a8:	00812403          	lw	s0,8(sp)
    54ac:	01010113          	addi	sp,sp,16
    54b0:	00008067          	ret

000054b4 <bsp_puts>:
int bsp_puts(char *s){
    54b4:	ff010113          	addi	sp,sp,-16
    54b8:	00112623          	sw	ra,12(sp)
    54bc:	00812423          	sw	s0,8(sp)
    54c0:	00050413          	mv	s0,a0
  while (*s) {
    54c4:	00044503          	lbu	a0,0(s0)
    54c8:	00050863          	beqz	a0,54d8 <bsp_puts+0x24>
    putchar(*s);
    54cc:	fb9ff0ef          	jal	ra,5484 <putchar>
    s++;
    54d0:	00140413          	addi	s0,s0,1
    54d4:	ff1ff06f          	j	54c4 <bsp_puts+0x10>
  putchar('\n');
    54d8:	00a00513          	li	a0,10
    54dc:	fa9ff0ef          	jal	ra,5484 <putchar>
}
    54e0:	00000513          	li	a0,0
    54e4:	00c12083          	lw	ra,12(sp)
    54e8:	00812403          	lw	s0,8(sp)
    54ec:	01010113          	addi	sp,sp,16
    54f0:	00008067          	ret

000054f4 <print_hex>:

void print_hex(uint32_t val, uint32_t digits)
{
    54f4:	ff010113          	addi	sp,sp,-16
    54f8:	00112623          	sw	ra,12(sp)
    54fc:	00812423          	sw	s0,8(sp)
    5500:	00912223          	sw	s1,4(sp)
    5504:	00050493          	mv	s1,a0
	for (int i = (4*digits)-4; i >= 0; i -= 4)
    5508:	40000437          	lui	s0,0x40000
    550c:	fff40413          	addi	s0,s0,-1 # 3fffffff <__freertos_irq_stack_top+0x3ffac3cf>
    5510:	00858433          	add	s0,a1,s0
    5514:	00241413          	slli	s0,s0,0x2
    5518:	02044663          	bltz	s0,5544 <print_hex+0x50>
		uart_write(BSP_UART_TERMINAL, "0123456789ABCDEF"[(val >> i) % 16]);
    551c:	0084d7b3          	srl	a5,s1,s0
    5520:	00f7f713          	andi	a4,a5,15
    5524:	000097b7          	lui	a5,0x9
    5528:	b0c78793          	addi	a5,a5,-1268 # 8b0c <_data+0x64>
    552c:	00e787b3          	add	a5,a5,a4
    5530:	0007c583          	lbu	a1,0(a5)
    5534:	f8010537          	lui	a0,0xf8010
    5538:	e89ff0ef          	jal	ra,53c0 <uart_write>
	for (int i = (4*digits)-4; i >= 0; i -= 4)
    553c:	ffc40413          	addi	s0,s0,-4
    5540:	fd9ff06f          	j	5518 <print_hex+0x24>
}
    5544:	00c12083          	lw	ra,12(sp)
    5548:	00812403          	lw	s0,8(sp)
    554c:	00412483          	lw	s1,4(sp)
    5550:	01010113          	addi	sp,sp,16
    5554:	00008067          	ret

00005558 <uart_writeAvailability>:
    5558:	00452503          	lw	a0,4(a0) # f8010004 <__freertos_irq_stack_top+0xf7fbc3d4>
        return (read_u32(reg + UART_STATUS) >> 16) & 0xFF;
    555c:	01055513          	srli	a0,a0,0x10
    }
    5560:	0ff57513          	andi	a0,a0,255
    5564:	00008067          	ret

00005568 <uart_write>:
    static void uart_write(u32 reg, char data){
    5568:	ff010113          	addi	sp,sp,-16
    556c:	00112623          	sw	ra,12(sp)
    5570:	00812423          	sw	s0,8(sp)
    5574:	00912223          	sw	s1,4(sp)
    5578:	00050413          	mv	s0,a0
    557c:	00058493          	mv	s1,a1
        while(uart_writeAvailability(reg) == 0);
    5580:	00040513          	mv	a0,s0
    5584:	fd5ff0ef          	jal	ra,5558 <uart_writeAvailability>
    5588:	fe050ce3          	beqz	a0,5580 <uart_write+0x18>
        *((volatile u32*) address) = data;
    558c:	00942023          	sw	s1,0(s0)
    }
    5590:	00c12083          	lw	ra,12(sp)
    5594:	00812403          	lw	s0,8(sp)
    5598:	00412483          	lw	s1,4(sp)
    559c:	01010113          	addi	sp,sp,16
    55a0:	00008067          	ret

000055a4 <clint_uDelay>:
        u32 mTimePerUsec = hz/1000000;
    55a4:	000f47b7          	lui	a5,0xf4
    55a8:	24078793          	addi	a5,a5,576 # f4240 <__freertos_irq_stack_top+0xa0610>
    55ac:	02f5d5b3          	divu	a1,a1,a5
    readReg_u32 (clint_getTimeLow , CLINT_TIME_ADDR)
    55b0:	0000c7b7          	lui	a5,0xc
    55b4:	ff878793          	addi	a5,a5,-8 # bff8 <raw_table4+0x24d8>
    55b8:	00f60633          	add	a2,a2,a5
        return *((volatile u32*) address);
    55bc:	00062783          	lw	a5,0(a2) # f8b00000 <__freertos_irq_stack_top+0xf8aac3d0>
        u32 limit = clint_getTimeLow(reg) + usec*mTimePerUsec;
    55c0:	02a58533          	mul	a0,a1,a0
    55c4:	00f50533          	add	a0,a0,a5
    55c8:	00062783          	lw	a5,0(a2)
        while((int32_t)(limit-(clint_getTimeLow(reg))) >= 0);
    55cc:	40f507b3          	sub	a5,a0,a5
    55d0:	fe07dce3          	bgez	a5,55c8 <clint_uDelay+0x24>
    55d4:	00008067          	ret

000055d8 <_putchar>:
    static void _putchar(char character){
    55d8:	ff010113          	addi	sp,sp,-16
    55dc:	00112623          	sw	ra,12(sp)
            bsp_putChar(character);
    55e0:	00050593          	mv	a1,a0
    55e4:	f8010537          	lui	a0,0xf8010
    55e8:	f81ff0ef          	jal	ra,5568 <uart_write>
    }
    55ec:	00c12083          	lw	ra,12(sp)
    55f0:	01010113          	addi	sp,sp,16
    55f4:	00008067          	ret

000055f8 <_putchar_s>:
    {
    55f8:	ff010113          	addi	sp,sp,-16
    55fc:	00112623          	sw	ra,12(sp)
    5600:	00812423          	sw	s0,8(sp)
    5604:	00050413          	mv	s0,a0
        while (*p)
    5608:	00044503          	lbu	a0,0(s0)
    560c:	00050863          	beqz	a0,561c <_putchar_s+0x24>
            _putchar(*(p++));
    5610:	00140413          	addi	s0,s0,1
    5614:	fc5ff0ef          	jal	ra,55d8 <_putchar>
    5618:	ff1ff06f          	j	5608 <_putchar_s+0x10>
    }
    561c:	00c12083          	lw	ra,12(sp)
    5620:	00812403          	lw	s0,8(sp)
    5624:	01010113          	addi	sp,sp,16
    5628:	00008067          	ret

0000562c <bsp_printHex>:
    {
    562c:	ff010113          	addi	sp,sp,-16
    5630:	00112623          	sw	ra,12(sp)
    5634:	00812423          	sw	s0,8(sp)
    5638:	00912223          	sw	s1,4(sp)
    563c:	00050493          	mv	s1,a0
        for (int i = (4*digits)-4; i >= 0; i -= 4) {
    5640:	01c00413          	li	s0,28
    5644:	0240006f          	j	5668 <bsp_printHex+0x3c>
            _putchar("0123456789ABCDEF"[(val >> i) % 16]);
    5648:	0084d7b3          	srl	a5,s1,s0
    564c:	00f7f713          	andi	a4,a5,15
    5650:	000097b7          	lui	a5,0x9
    5654:	b0c78793          	addi	a5,a5,-1268 # 8b0c <_data+0x64>
    5658:	00e787b3          	add	a5,a5,a4
    565c:	0007c503          	lbu	a0,0(a5)
    5660:	f79ff0ef          	jal	ra,55d8 <_putchar>
        for (int i = (4*digits)-4; i >= 0; i -= 4) {
    5664:	ffc40413          	addi	s0,s0,-4
    5668:	fe0450e3          	bgez	s0,5648 <bsp_printHex+0x1c>
    }
    566c:	00c12083          	lw	ra,12(sp)
    5670:	00812403          	lw	s0,8(sp)
    5674:	00412483          	lw	s1,4(sp)
    5678:	01010113          	addi	sp,sp,16
    567c:	00008067          	ret

00005680 <bsp_printHex_lower>:
    {
    5680:	ff010113          	addi	sp,sp,-16
    5684:	00112623          	sw	ra,12(sp)
    5688:	00812423          	sw	s0,8(sp)
    568c:	00912223          	sw	s1,4(sp)
    5690:	00050493          	mv	s1,a0
        for (int i = (4*digits)-4; i >= 0; i -= 4) {
    5694:	01c00413          	li	s0,28
    5698:	0240006f          	j	56bc <bsp_printHex_lower+0x3c>
            _putchar("0123456789abcdef"[(val >> i) % 16]);
    569c:	0084d7b3          	srl	a5,s1,s0
    56a0:	00f7f713          	andi	a4,a5,15
    56a4:	000097b7          	lui	a5,0x9
    56a8:	b7478793          	addi	a5,a5,-1164 # 8b74 <_data+0xcc>
    56ac:	00e787b3          	add	a5,a5,a4
    56b0:	0007c503          	lbu	a0,0(a5)
    56b4:	f25ff0ef          	jal	ra,55d8 <_putchar>
        for (int i = (4*digits)-4; i >= 0; i -= 4) {
    56b8:	ffc40413          	addi	s0,s0,-4
    56bc:	fe0450e3          	bgez	s0,569c <bsp_printHex_lower+0x1c>
    }
    56c0:	00c12083          	lw	ra,12(sp)
    56c4:	00812403          	lw	s0,8(sp)
    56c8:	00412483          	lw	s1,4(sp)
    56cc:	01010113          	addi	sp,sp,16
    56d0:	00008067          	ret

000056d4 <bsp_printf_c>:
    {
    56d4:	ff010113          	addi	sp,sp,-16
    56d8:	00112623          	sw	ra,12(sp)
        _putchar(c);
    56dc:	0ff57513          	andi	a0,a0,255
    56e0:	ef9ff0ef          	jal	ra,55d8 <_putchar>
    }
    56e4:	00c12083          	lw	ra,12(sp)
    56e8:	01010113          	addi	sp,sp,16
    56ec:	00008067          	ret

000056f0 <bsp_printf_s>:
    {
    56f0:	ff010113          	addi	sp,sp,-16
    56f4:	00112623          	sw	ra,12(sp)
        _putchar_s(p);
    56f8:	f01ff0ef          	jal	ra,55f8 <_putchar_s>
    }
    56fc:	00c12083          	lw	ra,12(sp)
    5700:	01010113          	addi	sp,sp,16
    5704:	00008067          	ret

00005708 <bsp_printf_d>:
    {
    5708:	fd010113          	addi	sp,sp,-48
    570c:	02112623          	sw	ra,44(sp)
    5710:	02812423          	sw	s0,40(sp)
    5714:	02912223          	sw	s1,36(sp)
    5718:	00050493          	mv	s1,a0
        if (val < 0) {
    571c:	00054663          	bltz	a0,5728 <bsp_printf_d+0x20>
    {
    5720:	00010413          	mv	s0,sp
    5724:	02c0006f          	j	5750 <bsp_printf_d+0x48>
            bsp_printf_c('-');
    5728:	02d00513          	li	a0,45
    572c:	fa9ff0ef          	jal	ra,56d4 <bsp_printf_c>
            val = -val;
    5730:	409004b3          	neg	s1,s1
    5734:	fedff06f          	j	5720 <bsp_printf_d+0x18>
            *(p++) = '0' + val % 10;
    5738:	00a00713          	li	a4,10
    573c:	02e4e7b3          	rem	a5,s1,a4
    5740:	03078793          	addi	a5,a5,48
    5744:	00f40023          	sb	a5,0(s0)
            val = val / 10;
    5748:	02e4c4b3          	div	s1,s1,a4
            *(p++) = '0' + val % 10;
    574c:	00140413          	addi	s0,s0,1
        while (val || p == buffer) {
    5750:	fe0494e3          	bnez	s1,5738 <bsp_printf_d+0x30>
    5754:	00010793          	mv	a5,sp
    5758:	fef400e3          	beq	s0,a5,5738 <bsp_printf_d+0x30>
    575c:	0100006f          	j	576c <bsp_printf_d+0x64>
            bsp_printf_c(*(--p));
    5760:	fff40413          	addi	s0,s0,-1
    5764:	00044503          	lbu	a0,0(s0)
    5768:	f6dff0ef          	jal	ra,56d4 <bsp_printf_c>
        while (p != buffer)
    576c:	00010793          	mv	a5,sp
    5770:	fef418e3          	bne	s0,a5,5760 <bsp_printf_d+0x58>
    }
    5774:	02c12083          	lw	ra,44(sp)
    5778:	02812403          	lw	s0,40(sp)
    577c:	02412483          	lw	s1,36(sp)
    5780:	03010113          	addi	sp,sp,48
    5784:	00008067          	ret

00005788 <bsp_printf_x>:
    {
    5788:	ff010113          	addi	sp,sp,-16
    578c:	00112623          	sw	ra,12(sp)
        for(i=0;i<8;i++)
    5790:	00000713          	li	a4,0
    5794:	00700793          	li	a5,7
    5798:	02e7c063          	blt	a5,a4,57b8 <bsp_printf_x+0x30>
            if((val & (0xFFFFFFF0 <<(4*i))) == 0)
    579c:	00271693          	slli	a3,a4,0x2
    57a0:	ff000793          	li	a5,-16
    57a4:	00d797b3          	sll	a5,a5,a3
    57a8:	00f577b3          	and	a5,a0,a5
    57ac:	00078663          	beqz	a5,57b8 <bsp_printf_x+0x30>
        for(i=0;i<8;i++)
    57b0:	00170713          	addi	a4,a4,1
    57b4:	fe1ff06f          	j	5794 <bsp_printf_x+0xc>
        bsp_printHex_lower(val);
    57b8:	ec9ff0ef          	jal	ra,5680 <bsp_printHex_lower>
    }
    57bc:	00c12083          	lw	ra,12(sp)
    57c0:	01010113          	addi	sp,sp,16
    57c4:	00008067          	ret

000057c8 <bsp_printf_X>:
        {
    57c8:	ff010113          	addi	sp,sp,-16
    57cc:	00112623          	sw	ra,12(sp)
            for(i=0;i<8;i++)
    57d0:	00000713          	li	a4,0
    57d4:	00700793          	li	a5,7
    57d8:	02e7c063          	blt	a5,a4,57f8 <bsp_printf_X+0x30>
                if((val & (0xFFFFFFF0 <<(4*i))) == 0)
    57dc:	00271693          	slli	a3,a4,0x2
    57e0:	ff000793          	li	a5,-16
    57e4:	00d797b3          	sll	a5,a5,a3
    57e8:	00f577b3          	and	a5,a0,a5
    57ec:	00078663          	beqz	a5,57f8 <bsp_printf_X+0x30>
            for(i=0;i<8;i++)
    57f0:	00170713          	addi	a4,a4,1
    57f4:	fe1ff06f          	j	57d4 <bsp_printf_X+0xc>
            bsp_printHex(val);
    57f8:	e35ff0ef          	jal	ra,562c <bsp_printHex>
        }
    57fc:	00c12083          	lw	ra,12(sp)
    5800:	01010113          	addi	sp,sp,16
    5804:	00008067          	ret

00005808 <bsp_printf>:
    {
    5808:	fc010113          	addi	sp,sp,-64
    580c:	00112e23          	sw	ra,28(sp)
    5810:	00812c23          	sw	s0,24(sp)
    5814:	00912a23          	sw	s1,20(sp)
    5818:	00050493          	mv	s1,a0
    581c:	02b12223          	sw	a1,36(sp)
    5820:	02c12423          	sw	a2,40(sp)
    5824:	02d12623          	sw	a3,44(sp)
    5828:	02e12823          	sw	a4,48(sp)
    582c:	02f12a23          	sw	a5,52(sp)
    5830:	03012c23          	sw	a6,56(sp)
    5834:	03112e23          	sw	a7,60(sp)
        va_start(ap, format);
    5838:	02410793          	addi	a5,sp,36
    583c:	00f12623          	sw	a5,12(sp)
        for (i = 0; format[i]; i++)
    5840:	00000413          	li	s0,0
    5844:	01c0006f          	j	5860 <bsp_printf+0x58>
                        bsp_printf_c(va_arg(ap,int));
    5848:	00c12783          	lw	a5,12(sp)
    584c:	00478713          	addi	a4,a5,4
    5850:	00e12623          	sw	a4,12(sp)
    5854:	0007a503          	lw	a0,0(a5)
    5858:	e7dff0ef          	jal	ra,56d4 <bsp_printf_c>
        for (i = 0; format[i]; i++)
    585c:	00140413          	addi	s0,s0,1
    5860:	008487b3          	add	a5,s1,s0
    5864:	0007c503          	lbu	a0,0(a5)
    5868:	0c050263          	beqz	a0,592c <bsp_printf+0x124>
            if (format[i] == '%') {
    586c:	02500793          	li	a5,37
    5870:	06f50663          	beq	a0,a5,58dc <bsp_printf+0xd4>
                bsp_printf_c(format[i]);
    5874:	e61ff0ef          	jal	ra,56d4 <bsp_printf_c>
    5878:	fe5ff06f          	j	585c <bsp_printf+0x54>
                        bsp_printf_s(va_arg(ap,char*));
    587c:	00c12783          	lw	a5,12(sp)
    5880:	00478713          	addi	a4,a5,4
    5884:	00e12623          	sw	a4,12(sp)
    5888:	0007a503          	lw	a0,0(a5)
    588c:	e65ff0ef          	jal	ra,56f0 <bsp_printf_s>
                        break;
    5890:	fcdff06f          	j	585c <bsp_printf+0x54>
                        bsp_printf_d(va_arg(ap,int));
    5894:	00c12783          	lw	a5,12(sp)
    5898:	00478713          	addi	a4,a5,4
    589c:	00e12623          	sw	a4,12(sp)
    58a0:	0007a503          	lw	a0,0(a5)
    58a4:	e65ff0ef          	jal	ra,5708 <bsp_printf_d>
                        break;
    58a8:	fb5ff06f          	j	585c <bsp_printf+0x54>
                        bsp_printf_X(va_arg(ap,int));
    58ac:	00c12783          	lw	a5,12(sp)
    58b0:	00478713          	addi	a4,a5,4
    58b4:	00e12623          	sw	a4,12(sp)
    58b8:	0007a503          	lw	a0,0(a5)
    58bc:	f0dff0ef          	jal	ra,57c8 <bsp_printf_X>
                        break;
    58c0:	f9dff06f          	j	585c <bsp_printf+0x54>
                        bsp_printf_x(va_arg(ap,int));
    58c4:	00c12783          	lw	a5,12(sp)
    58c8:	00478713          	addi	a4,a5,4
    58cc:	00e12623          	sw	a4,12(sp)
    58d0:	0007a503          	lw	a0,0(a5)
    58d4:	eb5ff0ef          	jal	ra,5788 <bsp_printf_x>
                        break;
    58d8:	f85ff06f          	j	585c <bsp_printf+0x54>
                while (format[++i]) {
    58dc:	00140413          	addi	s0,s0,1
    58e0:	008487b3          	add	a5,s1,s0
    58e4:	0007c783          	lbu	a5,0(a5)
    58e8:	f6078ae3          	beqz	a5,585c <bsp_printf+0x54>
                    if (format[i] == 'c') {
    58ec:	06300713          	li	a4,99
    58f0:	f4e78ce3          	beq	a5,a4,5848 <bsp_printf+0x40>
                    else if (format[i] == 's') {
    58f4:	07300713          	li	a4,115
    58f8:	f8e782e3          	beq	a5,a4,587c <bsp_printf+0x74>
                    else if (format[i] == 'd') {
    58fc:	06400713          	li	a4,100
    5900:	f8e78ae3          	beq	a5,a4,5894 <bsp_printf+0x8c>
                    else if (format[i] == 'X') {
    5904:	05800713          	li	a4,88
    5908:	fae782e3          	beq	a5,a4,58ac <bsp_printf+0xa4>
                    else if (format[i] == 'x') {
    590c:	07800713          	li	a4,120
    5910:	fae78ae3          	beq	a5,a4,58c4 <bsp_printf+0xbc>
                    else if (format[i] == 'f') {
    5914:	06600713          	li	a4,102
    5918:	fce792e3          	bne	a5,a4,58dc <bsp_printf+0xd4>
                        bsp_printf_s("<Floating point printing not enable. Please Enable it at bsp.h first...>");
    591c:	00009537          	lui	a0,0x9
    5920:	b8850513          	addi	a0,a0,-1144 # 8b88 <_data+0xe0>
    5924:	dcdff0ef          	jal	ra,56f0 <bsp_printf_s>
                        break;
    5928:	f35ff06f          	j	585c <bsp_printf+0x54>
    }
    592c:	01c12083          	lw	ra,28(sp)
    5930:	01812403          	lw	s0,24(sp)
    5934:	01412483          	lw	s1,20(sp)
    5938:	04010113          	addi	sp,sp,64
    593c:	00008067          	ret

00005940 <sd_send_cmd>:
	70,
	80,
};

void sd_send_cmd(struct mmc *mmc, struct mmc_cmd *cmd, u32 index, u32 resp_type, u32 cmdarg)
{
    5940:	ff010113          	addi	sp,sp,-16
    5944:	00112623          	sw	ra,12(sp)
	struct mmc_ops *ops = mmc->cfg->ops;
    5948:	00052803          	lw	a6,0(a0)
    594c:	00482803          	lw	a6,4(a6)
	struct mmc_data *data = NULL;

	cmd->cmdidx = index;
    5950:	00c59023          	sh	a2,0(a1)
	cmd->resp_type = resp_type;
    5954:	00d5a223          	sw	a3,4(a1)
	cmd->cmdarg =cmdarg;
    5958:	00e5a423          	sw	a4,8(a1)

	ops->send_cmd(mmc,cmd,data);
    595c:	00082783          	lw	a5,0(a6)
    5960:	00000613          	li	a2,0
    5964:	000780e7          	jalr	a5
}
    5968:	00c12083          	lw	ra,12(sp)
    596c:	01010113          	addi	sp,sp,16
    5970:	00008067          	ret

00005974 <SD_READ_CSD>:


void SD_READ_CSD(struct mmc *mmc, struct mmc_cmd *cmd)
{
    5974:	ff010113          	addi	sp,sp,-16
    5978:	00112623          	sw	ra,12(sp)
    597c:	00812423          	sw	s0,8(sp)
    5980:	00912223          	sw	s1,4(sp)
    5984:	00050413          	mv	s0,a0
    5988:	00058493          	mv	s1,a1
	sd_send_cmd(mmc,cmd,MMC_CMD_SEND_CSD,MMC_RSP_R2,(mmc->rca<<16));
    598c:	05c52703          	lw	a4,92(a0)
    5990:	01071713          	slli	a4,a4,0x10
    5994:	00700693          	li	a3,7
    5998:	00900613          	li	a2,9
    599c:	fa5ff0ef          	jal	ra,5940 <sd_send_cmd>
	mmc->csd[0]= cmd->response[0];
    59a0:	00c4a783          	lw	a5,12(s1)
    59a4:	02f42e23          	sw	a5,60(s0)
	mmc->csd[1]= cmd->response[1];
    59a8:	0104a783          	lw	a5,16(s1)
    59ac:	04f42023          	sw	a5,64(s0)
	mmc->csd[2]= cmd->response[2];
    59b0:	0144a703          	lw	a4,20(s1)
    59b4:	04e42223          	sw	a4,68(s0)
	mmc->csd[3]= cmd->response[3];
    59b8:	0184a683          	lw	a3,24(s1)
    59bc:	04d42423          	sw	a3,72(s0)

	mmc->capacity = (((mmc->csd[1]>>8) &0x3FFFFF)+1)*512;
    59c0:	0087d793          	srli	a5,a5,0x8
    59c4:	004006b7          	lui	a3,0x400
    59c8:	fff68693          	addi	a3,a3,-1 # 3fffff <__freertos_irq_stack_top+0x3ac3cf>
    59cc:	00d7f7b3          	and	a5,a5,a3
    59d0:	00178793          	addi	a5,a5,1
    59d4:	00979693          	slli	a3,a5,0x9
	mmc->capacity *=1024;
    59d8:	0166d693          	srli	a3,a3,0x16
    59dc:	06d42e23          	sw	a3,124(s0)
    59e0:	01379793          	slli	a5,a5,0x13
    59e4:	06f42c23          	sw	a5,120(s0)
	mmc->tran_speed = multipliers[(mmc->csd[2]>>27) &0x07] * fbase[(mmc->csd[2]>>24) &0x03];
    59e8:	01b75793          	srli	a5,a4,0x1b
    59ec:	0077f793          	andi	a5,a5,7
    59f0:	000096b7          	lui	a3,0x9
    59f4:	11468693          	addi	a3,a3,276 # 9114 <multipliers>
    59f8:	00279793          	slli	a5,a5,0x2
    59fc:	00f687b3          	add	a5,a3,a5
    5a00:	0007a783          	lw	a5,0(a5)
    5a04:	01875713          	srli	a4,a4,0x18
    5a08:	00377713          	andi	a4,a4,3
    5a0c:	00271713          	slli	a4,a4,0x2
    5a10:	00e68733          	add	a4,a3,a4
    5a14:	04072703          	lw	a4,64(a4)
    5a18:	02e787b3          	mul	a5,a5,a4
    5a1c:	06f42423          	sw	a5,104(s0)
		bsp_printf("mmc->capacity = %d\r\n",(((mmc->csd[1]>>8) &0x3FFFFF)+1)*512);
		bsp_printf("mmc->tran_speed = %d\r\n",mmc->tran_speed);
	}


}
    5a20:	00c12083          	lw	ra,12(sp)
    5a24:	00812403          	lw	s0,8(sp)
    5a28:	00412483          	lw	s1,4(sp)
    5a2c:	01010113          	addi	sp,sp,16
    5a30:	00008067          	ret

00005a34 <SD_CardInitial>:

/************************** Function File ***************************/
u32 SD_CardInitial(struct mmc *mmc, struct mmc_cmd *cmd)
{
    5a34:	fe010113          	addi	sp,sp,-32
    5a38:	00112e23          	sw	ra,28(sp)
    5a3c:	00812c23          	sw	s0,24(sp)
    5a40:	00912a23          	sw	s1,20(sp)
    5a44:	01212823          	sw	s2,16(sp)
    5a48:	01312623          	sw	s3,12(sp)
    5a4c:	01412423          	sw	s4,8(sp)
    5a50:	01512223          	sw	s5,4(sp)
    5a54:	00050a13          	mv	s4,a0
    5a58:	00058413          	mv	s0,a1
	u32 Value;
	char busy=0;
	u32 rca=0;
	int wait_busy_count;

    for(int i=0; i<2; i++) {
    5a5c:	00000a93          	li	s5,0
	char busy=0;
    5a60:	00000493          	li	s1,0
    for(int i=0; i<2; i++) {
    5a64:	00100793          	li	a5,1
    5a68:	1757ce63          	blt	a5,s5,5be4 <SD_CardInitial+0x1b0>

    	bsp_printf("Loop: %d\r\n",i);
    5a6c:	000a8593          	mv	a1,s5
    5a70:	00009537          	lui	a0,0x9
    5a74:	16450513          	addi	a0,a0,356 # 9164 <fbase+0x10>
    5a78:	d91ff0ef          	jal	ra,5808 <bsp_printf>

        Reg_Out32(SDHC_APB_SLV + 0x08,0x00);
    5a7c:	00000593          	li	a1,0
    5a80:	f8120937          	lui	s2,0xf8120
    5a84:	00890513          	addi	a0,s2,8 # f8120008 <__freertos_irq_stack_top+0xf80cc3d8>
    5a88:	9b9ff0ef          	jal	ra,5440 <Reg_Out32>
        sd_send_cmd(mmc,cmd,MMC_CMD_GO_IDLE_STATE,MMC_RSP_NONE,0);
    5a8c:	00000713          	li	a4,0
    5a90:	00000693          	li	a3,0
    5a94:	00000613          	li	a2,0
    5a98:	00040593          	mv	a1,s0
    5a9c:	000a0513          	mv	a0,s4
    5aa0:	ea1ff0ef          	jal	ra,5940 <sd_send_cmd>
        bsp_uDelay(1000);
    5aa4:	f8b00637          	lui	a2,0xf8b00
    5aa8:	05f5e5b7          	lui	a1,0x5f5e
    5aac:	10058593          	addi	a1,a1,256 # 5f5e100 <__freertos_irq_stack_top+0x5f0a4d0>
    5ab0:	3e800513          	li	a0,1000
    5ab4:	af1ff0ef          	jal	ra,55a4 <clint_uDelay>

        Reg_Out32(SDHC_APB_SLV + 0x08,0x01);
    5ab8:	00100593          	li	a1,1
    5abc:	00890513          	addi	a0,s2,8
    5ac0:	981ff0ef          	jal	ra,5440 <Reg_Out32>
        sd_send_cmd(mmc,cmd,MMC_CMD_SEND_EXT_CSD,MMC_RSP_R7,0x01AA);
    5ac4:	1aa00713          	li	a4,426
    5ac8:	01500693          	li	a3,21
    5acc:	00800613          	li	a2,8
    5ad0:	00040593          	mv	a1,s0
    5ad4:	000a0513          	mv	a0,s4
    5ad8:	e69ff0ef          	jal	ra,5940 <sd_send_cmd>

        Reg_Out32(SDHC_APB_SLV + 0x08,0x02);
    5adc:	00200593          	li	a1,2
    5ae0:	00890513          	addi	a0,s2,8
    5ae4:	95dff0ef          	jal	ra,5440 <Reg_Out32>
        sd_send_cmd(mmc,cmd,MMC_CMD_APP_CMD,MMC_RSP_R1,0);
    5ae8:	00000713          	li	a4,0
    5aec:	01500693          	li	a3,21
    5af0:	03700613          	li	a2,55
    5af4:	00040593          	mv	a1,s0
    5af8:	000a0513          	mv	a0,s4
    5afc:	e45ff0ef          	jal	ra,5940 <sd_send_cmd>

		wait_busy_count = 0;
    5b00:	00000913          	li	s2,0
        while (busy==0)
    5b04:	0a049063          	bnez	s1,5ba4 <SD_CardInitial+0x170>
                Value = 0;
                Value |= 0x1<<30;//HCS
                Value |= 0x0<<28;//XPC
                Value |= 0x0<<24;//S18R
                Value |= 0x100000;//VDD VOLTAGE
                bsp_uDelay(50000);//delay 50ms
    5b08:	f8b00637          	lui	a2,0xf8b00
    5b0c:	05f5e9b7          	lui	s3,0x5f5e
    5b10:	10098593          	addi	a1,s3,256 # 5f5e100 <__freertos_irq_stack_top+0x5f0a4d0>
    5b14:	0000c537          	lui	a0,0xc
    5b18:	35050513          	addi	a0,a0,848 # c350 <raw_table4+0x2830>
    5b1c:	a89ff0ef          	jal	ra,55a4 <clint_uDelay>
                Reg_Out32(SDHC_APB_SLV + 0x08,0x04);
    5b20:	00400593          	li	a1,4
    5b24:	f81204b7          	lui	s1,0xf8120
    5b28:	00848513          	addi	a0,s1,8 # f8120008 <__freertos_irq_stack_top+0xf80cc3d8>
    5b2c:	915ff0ef          	jal	ra,5440 <Reg_Out32>
                sd_send_cmd(mmc,cmd,MMC_CMD_APP_CMD,MMC_RSP_R1,0);
    5b30:	00000713          	li	a4,0
    5b34:	01500693          	li	a3,21
    5b38:	03700613          	li	a2,55
    5b3c:	00040593          	mv	a1,s0
    5b40:	000a0513          	mv	a0,s4
    5b44:	dfdff0ef          	jal	ra,5940 <sd_send_cmd>
                Reg_Out32(SDHC_APB_SLV + 0x08,0x05);
    5b48:	00500593          	li	a1,5
    5b4c:	00848513          	addi	a0,s1,8
    5b50:	8f1ff0ef          	jal	ra,5440 <Reg_Out32>
                sd_send_cmd(mmc,cmd,SD_CMD_APP_SEND_OP_COND,MMC_RSP_R3,Value);
    5b54:	40100737          	lui	a4,0x40100
    5b58:	00100693          	li	a3,1
    5b5c:	02900613          	li	a2,41
    5b60:	00040593          	mv	a1,s0
    5b64:	000a0513          	mv	a0,s4
    5b68:	dd9ff0ef          	jal	ra,5940 <sd_send_cmd>
                bsp_printf("Respose: 0x%x\r\n",cmd->response[0]);
    5b6c:	00c42583          	lw	a1,12(s0)
    5b70:	00009537          	lui	a0,0x9
    5b74:	17050513          	addi	a0,a0,368 # 9170 <fbase+0x1c>
    5b78:	c91ff0ef          	jal	ra,5808 <bsp_printf>
                busy = (cmd->response[0]>>31)&0x1;
    5b7c:	00c42483          	lw	s1,12(s0)
    5b80:	01f4d493          	srli	s1,s1,0x1f
                bsp_uDelay(1000000);//delay 50ms
    5b84:	f8b00637          	lui	a2,0xf8b00
    5b88:	10098593          	addi	a1,s3,256
    5b8c:	000f4537          	lui	a0,0xf4
    5b90:	24050513          	addi	a0,a0,576 # f4240 <__freertos_irq_stack_top+0xa0610>
    5b94:	a11ff0ef          	jal	ra,55a4 <clint_uDelay>
				
			wait_busy_count++;
    5b98:	00190913          	addi	s2,s2,1
			if (wait_busy_count >=10)
    5b9c:	00900793          	li	a5,9
    5ba0:	f727d2e3          	bge	a5,s2,5b04 <SD_CardInitial+0xd0>
				break;
			}
        }


        if(busy == 1) {
    5ba4:	04049063          	bnez	s1,5be4 <SD_CardInitial+0x1b0>
            break;
        } else if(i==1) {
    5ba8:	00100793          	li	a5,1
    5bac:	00fa9c63          	bne	s5,a5,5bc4 <SD_CardInitial+0x190>
            bsp_printf("Err : ACMD41 OCR BUSY!\r\n");
    5bb0:	00009537          	lui	a0,0x9
    5bb4:	18050513          	addi	a0,a0,384 # 9180 <fbase+0x2c>
    5bb8:	c51ff0ef          	jal	ra,5808 <bsp_printf>
            return 1;
    5bbc:	00100513          	li	a0,1
    5bc0:	0f40006f          	j	5cb4 <SD_CardInitial+0x280>
        }
        bsp_uDelay(1000000);
    5bc4:	f8b00637          	lui	a2,0xf8b00
    5bc8:	05f5e5b7          	lui	a1,0x5f5e
    5bcc:	10058593          	addi	a1,a1,256 # 5f5e100 <__freertos_irq_stack_top+0x5f0a4d0>
    5bd0:	000f4537          	lui	a0,0xf4
    5bd4:	24050513          	addi	a0,a0,576 # f4240 <__freertos_irq_stack_top+0xa0610>
    5bd8:	9cdff0ef          	jal	ra,55a4 <clint_uDelay>
    for(int i=0; i<2; i++) {
    5bdc:	001a8a93          	addi	s5,s5,1
    5be0:	e85ff06f          	j	5a64 <SD_CardInitial+0x30>
    }

	sd_send_cmd(mmc,cmd,MMC_CMD_ALL_SEND_CID,MMC_RSP_R2,0);
    5be4:	00000713          	li	a4,0
    5be8:	00700693          	li	a3,7
    5bec:	00200613          	li	a2,2
    5bf0:	00040593          	mv	a1,s0
    5bf4:	000a0513          	mv	a0,s4
    5bf8:	d49ff0ef          	jal	ra,5940 <sd_send_cmd>
	mmc->cid[0]=cmd->response[0];
    5bfc:	00c42783          	lw	a5,12(s0)
    5c00:	04fa2623          	sw	a5,76(s4)
	mmc->cid[1]=cmd->response[1];
    5c04:	01042783          	lw	a5,16(s0)
    5c08:	04fa2823          	sw	a5,80(s4)
	mmc->cid[2]=cmd->response[2];
    5c0c:	01442783          	lw	a5,20(s0)
    5c10:	04fa2a23          	sw	a5,84(s4)
	mmc->cid[3]=cmd->response[3];
    5c14:	01842783          	lw	a5,24(s0)
    5c18:	04fa2c23          	sw	a5,88(s4)

	sd_send_cmd(mmc,cmd,MMC_CMD_SET_RELATIVE_ADDR,MMC_RSP_R6,0);
    5c1c:	00000713          	li	a4,0
    5c20:	01500693          	li	a3,21
    5c24:	00300613          	li	a2,3
    5c28:	00040593          	mv	a1,s0
    5c2c:	000a0513          	mv	a0,s4
    5c30:	d11ff0ef          	jal	ra,5940 <sd_send_cmd>

	mmc->rca = (cmd->response[0]&0xffff0000)>>16;
    5c34:	00e45783          	lhu	a5,14(s0)
    5c38:	04fa2e23          	sw	a5,92(s4)
	SD_READ_CSD(mmc,cmd);
    5c3c:	00040593          	mv	a1,s0
    5c40:	000a0513          	mv	a0,s4
    5c44:	d31ff0ef          	jal	ra,5974 <SD_READ_CSD>
	sd_send_cmd(mmc,cmd,MMC_CMD_SELECT_CARD,MMC_RSP_R1b,(mmc->rca<<16));
    5c48:	05ca2703          	lw	a4,92(s4)
    5c4c:	01071713          	slli	a4,a4,0x10
    5c50:	01d00693          	li	a3,29
    5c54:	00700613          	li	a2,7
    5c58:	00040593          	mv	a1,s0
    5c5c:	000a0513          	mv	a0,s4
    5c60:	ce1ff0ef          	jal	ra,5940 <sd_send_cmd>
	//write_u32(DATA_WIDTH, APB_0+SDHC_ADDR+0x028);//sdhc_reg - Host Control 1

	sd_send_cmd(mmc,cmd,MMC_CMD_APP_CMD,MMC_RSP_R1,(mmc->rca<<16));
    5c64:	05ca2703          	lw	a4,92(s4)
    5c68:	01071713          	slli	a4,a4,0x10
    5c6c:	01500693          	li	a3,21
    5c70:	03700613          	li	a2,55
    5c74:	00040593          	mv	a1,s0
    5c78:	000a0513          	mv	a0,s4
    5c7c:	cc5ff0ef          	jal	ra,5940 <sd_send_cmd>
	sd_send_cmd(mmc,cmd,SD_CMD_APP_SET_BUS_WIDTH,MMC_RSP_R1,DATA_WIDTH);
    5c80:	00200713          	li	a4,2
    5c84:	01500693          	li	a3,21
    5c88:	00600613          	li	a2,6
    5c8c:	00040593          	mv	a1,s0
    5c90:	000a0513          	mv	a0,s4
    5c94:	cadff0ef          	jal	ra,5940 <sd_send_cmd>
	sd_send_cmd(mmc,cmd,MMC_CMD_SET_BLOCKLEN,MMC_RSP_R1,BLOCK_SIZE);
    5c98:	20000713          	li	a4,512
    5c9c:	01500693          	li	a3,21
    5ca0:	01000613          	li	a2,16
    5ca4:	00040593          	mv	a1,s0
    5ca8:	000a0513          	mv	a0,s4
    5cac:	c95ff0ef          	jal	ra,5940 <sd_send_cmd>

	if(DEBUG_PRINTF_EN)
		bsp_printf("SD_CardInitial done\r\n");

	return 0;
    5cb0:	00000513          	li	a0,0
}
    5cb4:	01c12083          	lw	ra,28(sp)
    5cb8:	01812403          	lw	s0,24(sp)
    5cbc:	01412483          	lw	s1,20(sp)
    5cc0:	01012903          	lw	s2,16(sp)
    5cc4:	00c12983          	lw	s3,12(sp)
    5cc8:	00812a03          	lw	s4,8(sp)
    5ccc:	00412a83          	lw	s5,4(sp)
    5cd0:	02010113          	addi	sp,sp,32
    5cd4:	00008067          	ret

00005cd8 <SD_EraseBlk>:


void SD_EraseBlk(struct mmc *mmc, struct mmc_cmd *cmd,u32 sd_addr, u32 blk_count)
{
    5cd8:	fe010113          	addi	sp,sp,-32
    5cdc:	00112e23          	sw	ra,28(sp)
    5ce0:	00812c23          	sw	s0,24(sp)
    5ce4:	00912a23          	sw	s1,20(sp)
    5ce8:	01212823          	sw	s2,16(sp)
    5cec:	01312623          	sw	s3,12(sp)
    5cf0:	00050493          	mv	s1,a0
    5cf4:	00058913          	mv	s2,a1
    5cf8:	00060993          	mv	s3,a2
    5cfc:	00068413          	mv	s0,a3
	sd_send_cmd(mmc,cmd,SD_CMD_ERASE_WR_BLK_START,MMC_RSP_R1,sd_addr);
    5d00:	00060713          	mv	a4,a2
    5d04:	01500693          	li	a3,21
    5d08:	02000613          	li	a2,32
    5d0c:	c35ff0ef          	jal	ra,5940 <sd_send_cmd>
	sd_send_cmd(mmc,cmd,SD_CMD_ERASE_WR_BLK_END,MMC_RSP_R1,sd_addr+(blk_count-1)*BLOCK_SIZE);
    5d10:	00800737          	lui	a4,0x800
    5d14:	fff70713          	addi	a4,a4,-1 # 7fffff <__freertos_irq_stack_top+0x7ac3cf>
    5d18:	00e40733          	add	a4,s0,a4
    5d1c:	00971713          	slli	a4,a4,0x9
    5d20:	01370733          	add	a4,a4,s3
    5d24:	01500693          	li	a3,21
    5d28:	02100613          	li	a2,33
    5d2c:	00090593          	mv	a1,s2
    5d30:	00048513          	mv	a0,s1
    5d34:	c0dff0ef          	jal	ra,5940 <sd_send_cmd>
	sd_send_cmd(mmc,cmd,MMC_CMD_ERASE,MMC_RSP_R1b,0);
    5d38:	00000713          	li	a4,0
    5d3c:	01d00693          	li	a3,29
    5d40:	02600613          	li	a2,38
    5d44:	00090593          	mv	a1,s2
    5d48:	00048513          	mv	a0,s1
    5d4c:	bf5ff0ef          	jal	ra,5940 <sd_send_cmd>
}
    5d50:	01c12083          	lw	ra,28(sp)
    5d54:	01812403          	lw	s0,24(sp)
    5d58:	01412483          	lw	s1,20(sp)
    5d5c:	01012903          	lw	s2,16(sp)
    5d60:	00c12983          	lw	s3,12(sp)
    5d64:	02010113          	addi	sp,sp,32
    5d68:	00008067          	ret

00005d6c <SD_WRITE_BLOCK>:


void SD_WRITE_BLOCK(struct mmc *mmc, u32 addr, void* src, u32 blocks)
{
    5d6c:	fe010113          	addi	sp,sp,-32
    5d70:	00112e23          	sw	ra,28(sp)
    5d74:	00812c23          	sw	s0,24(sp)
    5d78:	00912a23          	sw	s1,20(sp)
    5d7c:	01212823          	sw	s2,16(sp)
    5d80:	01312623          	sw	s3,12(sp)
    5d84:	01412423          	sw	s4,8(sp)
    5d88:	01512223          	sw	s5,4(sp)
    5d8c:	01612023          	sw	s6,0(sp)
    5d90:	00050913          	mv	s2,a0
    5d94:	00058b13          	mv	s6,a1
    5d98:	00060a93          	mv	s5,a2
    5d9c:	00068993          	mv	s3,a3
	struct mmc_cmd *cmd;
	struct mmc_data *data;
	struct mmc_ops	*ops = mmc->cfg->ops;
    5da0:	00052783          	lw	a5,0(a0)
    5da4:	0047aa03          	lw	s4,4(a5)

	cmd = malloc(sizeof(struct mmc_cmd));
    5da8:	01c00513          	li	a0,28
    5dac:	b4cfb0ef          	jal	ra,10f8 <malloc>
    5db0:	00050493          	mv	s1,a0
	data = malloc(sizeof(struct mmc_data));
    5db4:	01000513          	li	a0,16
    5db8:	b40fb0ef          	jal	ra,10f8 <malloc>
    5dbc:	00050413          	mv	s0,a0

	memset(cmd,0,sizeof(struct mmc_cmd));
    5dc0:	01c00613          	li	a2,28
    5dc4:	00000593          	li	a1,0
    5dc8:	00048513          	mv	a0,s1
    5dcc:	bddfb0ef          	jal	ra,19a8 <memset>
	memset(data,0,sizeof(struct mmc_data));
    5dd0:	01000613          	li	a2,16
    5dd4:	00000593          	li	a1,0
    5dd8:	00040513          	mv	a0,s0
    5ddc:	bcdfb0ef          	jal	ra,19a8 <memset>

	data->blocksize = mmc->read_bl_len;
    5de0:	06c92783          	lw	a5,108(s2)
    5de4:	00f42623          	sw	a5,12(s0)
	data->blocks = blocks;
    5de8:	01342423          	sw	s3,8(s0)

	if(data->blocks == 1)	cmd->cmdidx=MMC_CMD_WRITE_SINGLE_BLOCK;
    5dec:	00100793          	li	a5,1
    5df0:	06f98863          	beq	s3,a5,5e60 <SD_WRITE_BLOCK+0xf4>
	else					cmd->cmdidx=MMC_CMD_WRITE_MULTIPLE_BLOCK;
    5df4:	01900793          	li	a5,25
    5df8:	00f49023          	sh	a5,0(s1)

	cmd->cmdarg =addr;
    5dfc:	0164a423          	sw	s6,8(s1)
	cmd->resp_type=MMC_RSP_R1;
    5e00:	01500793          	li	a5,21
    5e04:	00f4a223          	sw	a5,4(s1)

	data->src=src;
    5e08:	01542023          	sw	s5,0(s0)
	data->flags = MMC_DATA_WRITE;
    5e0c:	00200793          	li	a5,2
    5e10:	00f42223          	sw	a5,4(s0)

	ops->send_cmd(mmc,cmd,data);
    5e14:	000a2783          	lw	a5,0(s4)
    5e18:	00040613          	mv	a2,s0
    5e1c:	00048593          	mv	a1,s1
    5e20:	00090513          	mv	a0,s2
    5e24:	000780e7          	jalr	a5

	free(cmd);
    5e28:	00048513          	mv	a0,s1
    5e2c:	adcfb0ef          	jal	ra,1108 <free>
	free(data);
    5e30:	00040513          	mv	a0,s0
    5e34:	ad4fb0ef          	jal	ra,1108 <free>

	return;
}
    5e38:	01c12083          	lw	ra,28(sp)
    5e3c:	01812403          	lw	s0,24(sp)
    5e40:	01412483          	lw	s1,20(sp)
    5e44:	01012903          	lw	s2,16(sp)
    5e48:	00c12983          	lw	s3,12(sp)
    5e4c:	00812a03          	lw	s4,8(sp)
    5e50:	00412a83          	lw	s5,4(sp)
    5e54:	00012b03          	lw	s6,0(sp)
    5e58:	02010113          	addi	sp,sp,32
    5e5c:	00008067          	ret
	if(data->blocks == 1)	cmd->cmdidx=MMC_CMD_WRITE_SINGLE_BLOCK;
    5e60:	01800793          	li	a5,24
    5e64:	00f49023          	sh	a5,0(s1)
    5e68:	f95ff06f          	j	5dfc <SD_WRITE_BLOCK+0x90>

00005e6c <SD_READ_BLOCK>:

void SD_READ_BLOCK(struct mmc *mmc, u32 addr, char* dest, u32 blocks)
{
    5e6c:	fe010113          	addi	sp,sp,-32
    5e70:	00112e23          	sw	ra,28(sp)
    5e74:	00812c23          	sw	s0,24(sp)
    5e78:	00912a23          	sw	s1,20(sp)
    5e7c:	01212823          	sw	s2,16(sp)
    5e80:	01312623          	sw	s3,12(sp)
    5e84:	01412423          	sw	s4,8(sp)
    5e88:	01512223          	sw	s5,4(sp)
    5e8c:	00050913          	mv	s2,a0
    5e90:	00058a93          	mv	s5,a1
    5e94:	00060a13          	mv	s4,a2
    5e98:	00068993          	mv	s3,a3
	struct mmc_cmd *cmd;
	struct mmc_data *data;
	struct mmc_ops	*ops = mmc->cfg->ops;


	cmd = malloc(sizeof(struct mmc_cmd));
    5e9c:	01c00513          	li	a0,28
    5ea0:	a58fb0ef          	jal	ra,10f8 <malloc>
    5ea4:	00050493          	mv	s1,a0
	data = malloc(sizeof(struct mmc_data));
    5ea8:	01000513          	li	a0,16
    5eac:	a4cfb0ef          	jal	ra,10f8 <malloc>
    5eb0:	00050413          	mv	s0,a0

	memset(cmd,0,sizeof(struct mmc_cmd));
    5eb4:	01c00613          	li	a2,28
    5eb8:	00000593          	li	a1,0
    5ebc:	00048513          	mv	a0,s1
    5ec0:	ae9fb0ef          	jal	ra,19a8 <memset>
	memset(data,0,sizeof(struct mmc_data));
    5ec4:	01000613          	li	a2,16
    5ec8:	00000593          	li	a1,0
    5ecc:	00040513          	mv	a0,s0
    5ed0:	ad9fb0ef          	jal	ra,19a8 <memset>

	data->blocksize = mmc->read_bl_len;
    5ed4:	06c92783          	lw	a5,108(s2)
    5ed8:	00f42623          	sw	a5,12(s0)
	data->blocks = blocks;
    5edc:	01342423          	sw	s3,8(s0)

	if(data->blocks == 1)	cmd->cmdidx=MMC_CMD_READ_SINGLE_BLOCK;
    5ee0:	00100793          	li	a5,1
    5ee4:	06f98a63          	beq	s3,a5,5f58 <SD_READ_BLOCK+0xec>
	else					cmd->cmdidx=MMC_CMD_READ_MULTIPLE_BLOCK;
    5ee8:	01200793          	li	a5,18
    5eec:	00f49023          	sh	a5,0(s1)

	cmd->cmdarg =addr;
    5ef0:	0154a423          	sw	s5,8(s1)
	cmd->resp_type=MMC_RSP_R1;
    5ef4:	01500793          	li	a5,21
    5ef8:	00f4a223          	sw	a5,4(s1)
	data->dest=dest;
    5efc:	01442023          	sw	s4,0(s0)
	data->flags = MMC_DATA_READ;
    5f00:	00100793          	li	a5,1
    5f04:	00f42223          	sw	a5,4(s0)


	mmc->cfg->ops->send_cmd(mmc,cmd,data);
    5f08:	00092783          	lw	a5,0(s2)
    5f0c:	0047a783          	lw	a5,4(a5)
    5f10:	0007a783          	lw	a5,0(a5)
    5f14:	00040613          	mv	a2,s0
    5f18:	00048593          	mv	a1,s1
    5f1c:	00090513          	mv	a0,s2
    5f20:	000780e7          	jalr	a5

	free(cmd);
    5f24:	00048513          	mv	a0,s1
    5f28:	9e0fb0ef          	jal	ra,1108 <free>
	free(data);
    5f2c:	00040513          	mv	a0,s0
    5f30:	9d8fb0ef          	jal	ra,1108 <free>

	return;
}
    5f34:	01c12083          	lw	ra,28(sp)
    5f38:	01812403          	lw	s0,24(sp)
    5f3c:	01412483          	lw	s1,20(sp)
    5f40:	01012903          	lw	s2,16(sp)
    5f44:	00c12983          	lw	s3,12(sp)
    5f48:	00812a03          	lw	s4,8(sp)
    5f4c:	00412a83          	lw	s5,4(sp)
    5f50:	02010113          	addi	sp,sp,32
    5f54:	00008067          	ret
	if(data->blocks == 1)	cmd->cmdidx=MMC_CMD_READ_SINGLE_BLOCK;
    5f58:	01100793          	li	a5,17
    5f5c:	00f49023          	sh	a5,0(s1)
    5f60:	f91ff06f          	j	5ef0 <SD_READ_BLOCK+0x84>

00005f64 <SD_ReadWriteCompare>:

char SD_ReadWriteCompare(char* wrbuf, char* rdbuf ,u64 wr_start ,u64 wr_end ,u64 rd_start ,u64 rd_end,u32 block_count,u32 current_blk,u32 total_blk)
{
    5f64:	fc010113          	addi	sp,sp,-64
    5f68:	02112e23          	sw	ra,60(sp)
    5f6c:	02812c23          	sw	s0,56(sp)
    5f70:	02912a23          	sw	s1,52(sp)
    5f74:	03212823          	sw	s2,48(sp)
    5f78:	03312623          	sw	s3,44(sp)
    5f7c:	03412423          	sw	s4,40(sp)
    5f80:	03512223          	sw	s5,36(sp)
    5f84:	03612023          	sw	s6,32(sp)
    5f88:	01712e23          	sw	s7,28(sp)
    5f8c:	01812c23          	sw	s8,24(sp)
    5f90:	01912a23          	sw	s9,20(sp)
    5f94:	01a12823          	sw	s10,16(sp)
    5f98:	01b12623          	sw	s11,12(sp)
    5f9c:	00050993          	mv	s3,a0
    5fa0:	00058a13          	mv	s4,a1
    5fa4:	00060d13          	mv	s10,a2
    5fa8:	00068c93          	mv	s9,a3
    5fac:	00070913          	mv	s2,a4
    5fb0:	00078c13          	mv	s8,a5
    5fb4:	00080b93          	mv	s7,a6
    5fb8:	00088b13          	mv	s6,a7
    5fbc:	04012483          	lw	s1,64(sp)
    5fc0:	04412a83          	lw	s5,68(sp)
    5fc4:	04812d83          	lw	s11,72(sp)
	char err=0;
	u32 m,cmpblk;
	u32 rd_speed,wr_speed;

	if(block_count>MAX_BLK_BUF)	cmpblk=MAX_BLK_BUF;
    5fc8:	10000793          	li	a5,256
    5fcc:	0db7fa63          	bgeu	a5,s11,60a0 <SD_ReadWriteCompare+0x13c>
    5fd0:	10000413          	li	s0,256
	else						cmpblk=block_count;

	if(memcmp(wrbuf,rdbuf,sizeof(char)*cmpblk*BLOCK_SIZE))
    5fd4:	00941413          	slli	s0,s0,0x9
    5fd8:	00040613          	mv	a2,s0
    5fdc:	000a0593          	mv	a1,s4
    5fe0:	00098513          	mv	a0,s3
    5fe4:	93dfb0ef          	jal	ra,1920 <memcmp>
    5fe8:	0c051063          	bnez	a0,60a8 <SD_ReadWriteCompare+0x144>

			}
	}
	else
	{
		wr_speed = ((block_count*BLOCK_SIZE)*1024)/((wr_end-wr_start)/(BSP_MACHINE_TIMER_HZ/1000000));
    5fec:	013d9d93          	slli	s11,s11,0x13
    5ff0:	41a90533          	sub	a0,s2,s10
    5ff4:	00a935b3          	sltu	a1,s2,a0
    5ff8:	419c0c33          	sub	s8,s8,s9
    5ffc:	40bc05b3          	sub	a1,s8,a1
    6000:	06400613          	li	a2,100
    6004:	00000693          	li	a3,0
    6008:	5a4020ef          	jal	ra,85ac <__udivdi3>
    600c:	00050613          	mv	a2,a0
    6010:	00058693          	mv	a3,a1
    6014:	000d8513          	mv	a0,s11
    6018:	00000593          	li	a1,0
    601c:	590020ef          	jal	ra,85ac <__udivdi3>
    6020:	00050913          	mv	s2,a0
		rd_speed = ((block_count*BLOCK_SIZE)*1024)/((rd_end-rd_start)/(BSP_MACHINE_TIMER_HZ/1000000));
    6024:	41748533          	sub	a0,s1,s7
    6028:	00a4b5b3          	sltu	a1,s1,a0
    602c:	416a8ab3          	sub	s5,s5,s6
    6030:	40ba85b3          	sub	a1,s5,a1
    6034:	06400613          	li	a2,100
    6038:	00000693          	li	a3,0
    603c:	570020ef          	jal	ra,85ac <__udivdi3>
    6040:	00050613          	mv	a2,a0
    6044:	00058693          	mv	a3,a1
    6048:	000d8513          	mv	a0,s11
    604c:	00000593          	li	a1,0
    6050:	55c020ef          	jal	ra,85ac <__udivdi3>

		if((current_blk % 1024) ==0)
    6054:	04c12783          	lw	a5,76(sp)
    6058:	3ff7f793          	andi	a5,a5,1023
    605c:	0a078263          	beqz	a5,6100 <SD_ReadWriteCompare+0x19c>
	char err=0;
    6060:	00000513          	li	a0,0
			bsp_printf("Tested Block %d/%d          Write s=%d KByte/s   Read s=%d KByte/s           \r",current_blk,total_blk,wr_speed,rd_speed);

	}

	return err;
}
    6064:	03c12083          	lw	ra,60(sp)
    6068:	03812403          	lw	s0,56(sp)
    606c:	03412483          	lw	s1,52(sp)
    6070:	03012903          	lw	s2,48(sp)
    6074:	02c12983          	lw	s3,44(sp)
    6078:	02812a03          	lw	s4,40(sp)
    607c:	02412a83          	lw	s5,36(sp)
    6080:	02012b03          	lw	s6,32(sp)
    6084:	01c12b83          	lw	s7,28(sp)
    6088:	01812c03          	lw	s8,24(sp)
    608c:	01412c83          	lw	s9,20(sp)
    6090:	01012d03          	lw	s10,16(sp)
    6094:	00c12d83          	lw	s11,12(sp)
    6098:	04010113          	addi	sp,sp,64
    609c:	00008067          	ret
	else						cmpblk=block_count;
    60a0:	000d8413          	mv	s0,s11
    60a4:	f31ff06f          	j	5fd4 <SD_ReadWriteCompare+0x70>
		bsp_printf("Tested Block %d/%d\n\r",current_blk,total_blk);
    60a8:	05012603          	lw	a2,80(sp)
    60ac:	04c12583          	lw	a1,76(sp)
    60b0:	00009537          	lui	a0,0x9
    60b4:	19c50513          	addi	a0,a0,412 # 919c <fbase+0x48>
    60b8:	f50ff0ef          	jal	ra,5808 <bsp_printf>
			for(m=0;m<(cmpblk*BLOCK_SIZE/4);m++)
    60bc:	00000593          	li	a1,0
    60c0:	00245793          	srli	a5,s0,0x2
    60c4:	02f5fa63          	bgeu	a1,a5,60f8 <SD_ReadWriteCompare+0x194>
				if(wrbuf[m] != rdbuf[m])
    60c8:	00b987b3          	add	a5,s3,a1
    60cc:	0007c603          	lbu	a2,0(a5)
    60d0:	00ba07b3          	add	a5,s4,a1
    60d4:	0007c683          	lbu	a3,0(a5)
    60d8:	00d61663          	bne	a2,a3,60e4 <SD_ReadWriteCompare+0x180>
			for(m=0;m<(cmpblk*BLOCK_SIZE/4);m++)
    60dc:	00158593          	addi	a1,a1,1
    60e0:	fe1ff06f          	j	60c0 <SD_ReadWriteCompare+0x15c>
				bsp_printf("compare fail m=%d wr= 0x%x rd=0x%x\n\r",m,wrbuf[m],rdbuf[m]);
    60e4:	00009537          	lui	a0,0x9
    60e8:	1b450513          	addi	a0,a0,436 # 91b4 <fbase+0x60>
    60ec:	f1cff0ef          	jal	ra,5808 <bsp_printf>
				err=1;
    60f0:	00100513          	li	a0,1
				break;
    60f4:	f71ff06f          	j	6064 <SD_ReadWriteCompare+0x100>
	char err=0;
    60f8:	00000513          	li	a0,0
    60fc:	f69ff06f          	j	6064 <SD_ReadWriteCompare+0x100>
			bsp_printf("Tested Block %d/%d          Write s=%d KByte/s   Read s=%d KByte/s           \r",current_blk,total_blk,wr_speed,rd_speed);
    6100:	00050713          	mv	a4,a0
    6104:	00090693          	mv	a3,s2
    6108:	05012603          	lw	a2,80(sp)
    610c:	04c12583          	lw	a1,76(sp)
    6110:	00009537          	lui	a0,0x9
    6114:	1dc50513          	addi	a0,a0,476 # 91dc <fbase+0x88>
    6118:	ef0ff0ef          	jal	ra,5808 <bsp_printf>
	char err=0;
    611c:	00000513          	li	a0,0
    6120:	f45ff06f          	j	6064 <SD_ReadWriteCompare+0x100>

00006124 <SD_InitRandomBuff>:


void SD_InitRandomBuff(char* buf, u32 size)
{
    6124:	ff010113          	addi	sp,sp,-16
    6128:	00112623          	sw	ra,12(sp)
    612c:	00812423          	sw	s0,8(sp)
    6130:	00912223          	sw	s1,4(sp)
    6134:	01212023          	sw	s2,0(sp)
    6138:	00050493          	mv	s1,a0
    613c:	00058913          	mv	s2,a1
	int m;

	for(m=0;m<size;m++)
    6140:	00000413          	li	s0,0
    6144:	01247c63          	bgeu	s0,s2,615c <SD_InitRandomBuff+0x38>
	{
		buf[m] = rand() & 0xFF;
    6148:	959fb0ef          	jal	ra,1aa0 <rand>
    614c:	008487b3          	add	a5,s1,s0
    6150:	00a78023          	sb	a0,0(a5)
	for(m=0;m<size;m++)
    6154:	00140413          	addi	s0,s0,1
    6158:	fedff06f          	j	6144 <SD_InitRandomBuff+0x20>
	}

	srand(buf[0]);
    615c:	0004c503          	lbu	a0,0(s1)
    6160:	92dfb0ef          	jal	ra,1a8c <srand>
}
    6164:	00c12083          	lw	ra,12(sp)
    6168:	00812403          	lw	s0,8(sp)
    616c:	00412483          	lw	s1,4(sp)
    6170:	00012903          	lw	s2,0(sp)
    6174:	01010113          	addi	sp,sp,16
    6178:	00008067          	ret

0000617c <uart_writeAvailability>:
    617c:	00452503          	lw	a0,4(a0)
        return (read_u32(reg + UART_STATUS) >> 16) & 0xFF;
    6180:	01055513          	srli	a0,a0,0x10
    }
    6184:	0ff57513          	andi	a0,a0,255
    6188:	00008067          	ret

0000618c <uart_write>:
    static void uart_write(u32 reg, char data){
    618c:	ff010113          	addi	sp,sp,-16
    6190:	00112623          	sw	ra,12(sp)
    6194:	00812423          	sw	s0,8(sp)
    6198:	00912223          	sw	s1,4(sp)
    619c:	00050413          	mv	s0,a0
    61a0:	00058493          	mv	s1,a1
        while(uart_writeAvailability(reg) == 0);
    61a4:	00040513          	mv	a0,s0
    61a8:	fd5ff0ef          	jal	ra,617c <uart_writeAvailability>
    61ac:	fe050ce3          	beqz	a0,61a4 <uart_write+0x18>
        *((volatile u32*) address) = data;
    61b0:	00942023          	sw	s1,0(s0)
    }
    61b4:	00c12083          	lw	ra,12(sp)
    61b8:	00812403          	lw	s0,8(sp)
    61bc:	00412483          	lw	s1,4(sp)
    61c0:	01010113          	addi	sp,sp,16
    61c4:	00008067          	ret

000061c8 <_putchar>:
    static void _putchar(char character){
    61c8:	ff010113          	addi	sp,sp,-16
    61cc:	00112623          	sw	ra,12(sp)
            bsp_putChar(character);
    61d0:	00050593          	mv	a1,a0
    61d4:	f8010537          	lui	a0,0xf8010
    61d8:	fb5ff0ef          	jal	ra,618c <uart_write>
    }
    61dc:	00c12083          	lw	ra,12(sp)
    61e0:	01010113          	addi	sp,sp,16
    61e4:	00008067          	ret

000061e8 <_putchar_s>:
    {
    61e8:	ff010113          	addi	sp,sp,-16
    61ec:	00112623          	sw	ra,12(sp)
    61f0:	00812423          	sw	s0,8(sp)
    61f4:	00050413          	mv	s0,a0
        while (*p)
    61f8:	00044503          	lbu	a0,0(s0)
    61fc:	00050863          	beqz	a0,620c <_putchar_s+0x24>
            _putchar(*(p++));
    6200:	00140413          	addi	s0,s0,1
    6204:	fc5ff0ef          	jal	ra,61c8 <_putchar>
    6208:	ff1ff06f          	j	61f8 <_putchar_s+0x10>
    }
    620c:	00c12083          	lw	ra,12(sp)
    6210:	00812403          	lw	s0,8(sp)
    6214:	01010113          	addi	sp,sp,16
    6218:	00008067          	ret

0000621c <bsp_printHex>:
    {
    621c:	ff010113          	addi	sp,sp,-16
    6220:	00112623          	sw	ra,12(sp)
    6224:	00812423          	sw	s0,8(sp)
    6228:	00912223          	sw	s1,4(sp)
    622c:	00050493          	mv	s1,a0
        for (int i = (4*digits)-4; i >= 0; i -= 4) {
    6230:	01c00413          	li	s0,28
    6234:	0240006f          	j	6258 <bsp_printHex+0x3c>
            _putchar("0123456789ABCDEF"[(val >> i) % 16]);
    6238:	0084d7b3          	srl	a5,s1,s0
    623c:	00f7f713          	andi	a4,a5,15
    6240:	000097b7          	lui	a5,0x9
    6244:	b0c78793          	addi	a5,a5,-1268 # 8b0c <_data+0x64>
    6248:	00e787b3          	add	a5,a5,a4
    624c:	0007c503          	lbu	a0,0(a5)
    6250:	f79ff0ef          	jal	ra,61c8 <_putchar>
        for (int i = (4*digits)-4; i >= 0; i -= 4) {
    6254:	ffc40413          	addi	s0,s0,-4
    6258:	fe0450e3          	bgez	s0,6238 <bsp_printHex+0x1c>
    }
    625c:	00c12083          	lw	ra,12(sp)
    6260:	00812403          	lw	s0,8(sp)
    6264:	00412483          	lw	s1,4(sp)
    6268:	01010113          	addi	sp,sp,16
    626c:	00008067          	ret

00006270 <bsp_printHex_lower>:
    {
    6270:	ff010113          	addi	sp,sp,-16
    6274:	00112623          	sw	ra,12(sp)
    6278:	00812423          	sw	s0,8(sp)
    627c:	00912223          	sw	s1,4(sp)
    6280:	00050493          	mv	s1,a0
        for (int i = (4*digits)-4; i >= 0; i -= 4) {
    6284:	01c00413          	li	s0,28
    6288:	0240006f          	j	62ac <bsp_printHex_lower+0x3c>
            _putchar("0123456789abcdef"[(val >> i) % 16]);
    628c:	0084d7b3          	srl	a5,s1,s0
    6290:	00f7f713          	andi	a4,a5,15
    6294:	000097b7          	lui	a5,0x9
    6298:	b7478793          	addi	a5,a5,-1164 # 8b74 <_data+0xcc>
    629c:	00e787b3          	add	a5,a5,a4
    62a0:	0007c503          	lbu	a0,0(a5)
    62a4:	f25ff0ef          	jal	ra,61c8 <_putchar>
        for (int i = (4*digits)-4; i >= 0; i -= 4) {
    62a8:	ffc40413          	addi	s0,s0,-4
    62ac:	fe0450e3          	bgez	s0,628c <bsp_printHex_lower+0x1c>
    }
    62b0:	00c12083          	lw	ra,12(sp)
    62b4:	00812403          	lw	s0,8(sp)
    62b8:	00412483          	lw	s1,4(sp)
    62bc:	01010113          	addi	sp,sp,16
    62c0:	00008067          	ret

000062c4 <bsp_printf_c>:
    {
    62c4:	ff010113          	addi	sp,sp,-16
    62c8:	00112623          	sw	ra,12(sp)
        _putchar(c);
    62cc:	0ff57513          	andi	a0,a0,255
    62d0:	ef9ff0ef          	jal	ra,61c8 <_putchar>
    }
    62d4:	00c12083          	lw	ra,12(sp)
    62d8:	01010113          	addi	sp,sp,16
    62dc:	00008067          	ret

000062e0 <bsp_printf_s>:
    {
    62e0:	ff010113          	addi	sp,sp,-16
    62e4:	00112623          	sw	ra,12(sp)
        _putchar_s(p);
    62e8:	f01ff0ef          	jal	ra,61e8 <_putchar_s>
    }
    62ec:	00c12083          	lw	ra,12(sp)
    62f0:	01010113          	addi	sp,sp,16
    62f4:	00008067          	ret

000062f8 <bsp_printf_d>:
    {
    62f8:	fd010113          	addi	sp,sp,-48
    62fc:	02112623          	sw	ra,44(sp)
    6300:	02812423          	sw	s0,40(sp)
    6304:	02912223          	sw	s1,36(sp)
    6308:	00050493          	mv	s1,a0
        if (val < 0) {
    630c:	00054663          	bltz	a0,6318 <bsp_printf_d+0x20>
    {
    6310:	00010413          	mv	s0,sp
    6314:	02c0006f          	j	6340 <bsp_printf_d+0x48>
            bsp_printf_c('-');
    6318:	02d00513          	li	a0,45
    631c:	fa9ff0ef          	jal	ra,62c4 <bsp_printf_c>
            val = -val;
    6320:	409004b3          	neg	s1,s1
    6324:	fedff06f          	j	6310 <bsp_printf_d+0x18>
            *(p++) = '0' + val % 10;
    6328:	00a00713          	li	a4,10
    632c:	02e4e7b3          	rem	a5,s1,a4
    6330:	03078793          	addi	a5,a5,48
    6334:	00f40023          	sb	a5,0(s0)
            val = val / 10;
    6338:	02e4c4b3          	div	s1,s1,a4
            *(p++) = '0' + val % 10;
    633c:	00140413          	addi	s0,s0,1
        while (val || p == buffer) {
    6340:	fe0494e3          	bnez	s1,6328 <bsp_printf_d+0x30>
    6344:	00010793          	mv	a5,sp
    6348:	fef400e3          	beq	s0,a5,6328 <bsp_printf_d+0x30>
    634c:	0100006f          	j	635c <bsp_printf_d+0x64>
            bsp_printf_c(*(--p));
    6350:	fff40413          	addi	s0,s0,-1
    6354:	00044503          	lbu	a0,0(s0)
    6358:	f6dff0ef          	jal	ra,62c4 <bsp_printf_c>
        while (p != buffer)
    635c:	00010793          	mv	a5,sp
    6360:	fef418e3          	bne	s0,a5,6350 <bsp_printf_d+0x58>
    }
    6364:	02c12083          	lw	ra,44(sp)
    6368:	02812403          	lw	s0,40(sp)
    636c:	02412483          	lw	s1,36(sp)
    6370:	03010113          	addi	sp,sp,48
    6374:	00008067          	ret

00006378 <bsp_printf_x>:
    {
    6378:	ff010113          	addi	sp,sp,-16
    637c:	00112623          	sw	ra,12(sp)
        for(i=0;i<8;i++)
    6380:	00000713          	li	a4,0
    6384:	00700793          	li	a5,7
    6388:	02e7c063          	blt	a5,a4,63a8 <bsp_printf_x+0x30>
            if((val & (0xFFFFFFF0 <<(4*i))) == 0)
    638c:	00271693          	slli	a3,a4,0x2
    6390:	ff000793          	li	a5,-16
    6394:	00d797b3          	sll	a5,a5,a3
    6398:	00f577b3          	and	a5,a0,a5
    639c:	00078663          	beqz	a5,63a8 <bsp_printf_x+0x30>
        for(i=0;i<8;i++)
    63a0:	00170713          	addi	a4,a4,1
    63a4:	fe1ff06f          	j	6384 <bsp_printf_x+0xc>
        bsp_printHex_lower(val);
    63a8:	ec9ff0ef          	jal	ra,6270 <bsp_printHex_lower>
    }
    63ac:	00c12083          	lw	ra,12(sp)
    63b0:	01010113          	addi	sp,sp,16
    63b4:	00008067          	ret

000063b8 <bsp_printf_X>:
        {
    63b8:	ff010113          	addi	sp,sp,-16
    63bc:	00112623          	sw	ra,12(sp)
            for(i=0;i<8;i++)
    63c0:	00000713          	li	a4,0
    63c4:	00700793          	li	a5,7
    63c8:	02e7c063          	blt	a5,a4,63e8 <bsp_printf_X+0x30>
                if((val & (0xFFFFFFF0 <<(4*i))) == 0)
    63cc:	00271693          	slli	a3,a4,0x2
    63d0:	ff000793          	li	a5,-16
    63d4:	00d797b3          	sll	a5,a5,a3
    63d8:	00f577b3          	and	a5,a0,a5
    63dc:	00078663          	beqz	a5,63e8 <bsp_printf_X+0x30>
            for(i=0;i<8;i++)
    63e0:	00170713          	addi	a4,a4,1
    63e4:	fe1ff06f          	j	63c4 <bsp_printf_X+0xc>
            bsp_printHex(val);
    63e8:	e35ff0ef          	jal	ra,621c <bsp_printHex>
        }
    63ec:	00c12083          	lw	ra,12(sp)
    63f0:	01010113          	addi	sp,sp,16
    63f4:	00008067          	ret

000063f8 <i2c_masterBusy>:
        return *((volatile u32*) address);
    63f8:	04052503          	lw	a0,64(a0) # f8010040 <__freertos_irq_stack_top+0xf7fbc410>
    }
    63fc:	00157513          	andi	a0,a0,1
    6400:	00008067          	ret

00006404 <i2c_masterStartBlocking>:
        write_u32(I2C_MASTER_START | I2C_MASTER_START_DROPPED, reg + I2C_MASTER_STATUS);
    6404:	04050713          	addi	a4,a0,64
        *((volatile u32*) address) = data;
    6408:	21000793          	li	a5,528
    640c:	04f52023          	sw	a5,64(a0)
        return *((volatile u32*) address);
    6410:	00072783          	lw	a5,0(a4)
        while(i2c_getMasterStatus(reg) & I2C_MASTER_START);
    6414:	0107f793          	andi	a5,a5,16
    6418:	fe079ce3          	bnez	a5,6410 <i2c_masterStartBlocking+0xc>
    }
    641c:	00008067          	ret

00006420 <i2c_masterStopWait>:
    static void i2c_masterStopWait(u32 reg){
    6420:	ff010113          	addi	sp,sp,-16
    6424:	00112623          	sw	ra,12(sp)
    6428:	00812423          	sw	s0,8(sp)
    642c:	00050413          	mv	s0,a0
        while(i2c_masterBusy(reg));
    6430:	00040513          	mv	a0,s0
    6434:	fc5ff0ef          	jal	ra,63f8 <i2c_masterBusy>
    6438:	fe051ce3          	bnez	a0,6430 <i2c_masterStopWait+0x10>
    }
    643c:	00c12083          	lw	ra,12(sp)
    6440:	00812403          	lw	s0,8(sp)
    6444:	01010113          	addi	sp,sp,16
    6448:	00008067          	ret

0000644c <i2c_masterStopBlocking>:
    static void i2c_masterStopBlocking(u32 reg){
    644c:	ff010113          	addi	sp,sp,-16
    6450:	00112623          	sw	ra,12(sp)
        *((volatile u32*) address) = data;
    6454:	42000713          	li	a4,1056
    6458:	04e52023          	sw	a4,64(a0)
        i2c_masterStopWait(reg);
    645c:	fc5ff0ef          	jal	ra,6420 <i2c_masterStopWait>
    }
    6460:	00c12083          	lw	ra,12(sp)
    6464:	01010113          	addi	sp,sp,16
    6468:	00008067          	ret

0000646c <i2c_txAckWait>:
        return *((volatile u32*) address);
    646c:	00452783          	lw	a5,4(a0)
        while(read_u32(reg + I2C_TX_ACK) & I2C_TX_VALID);
    6470:	1007f793          	andi	a5,a5,256
    6474:	fe079ce3          	bnez	a5,646c <i2c_txAckWait>
    }
    6478:	00008067          	ret

0000647c <i2c_txNackBlocking>:
    static void i2c_txNackBlocking(u32 reg){
    647c:	ff010113          	addi	sp,sp,-16
    6480:	00112623          	sw	ra,12(sp)
        *((volatile u32*) address) = data;
    6484:	30100713          	li	a4,769
    6488:	00e52223          	sw	a4,4(a0)
        i2c_txAckWait(reg);
    648c:	fe1ff0ef          	jal	ra,646c <i2c_txAckWait>
    }
    6490:	00c12083          	lw	ra,12(sp)
    6494:	01010113          	addi	sp,sp,16
    6498:	00008067          	ret

0000649c <i2c_rxData>:
        return *((volatile u32*) address);
    649c:	00852503          	lw	a0,8(a0)
    }
    64a0:	0ff57513          	andi	a0,a0,255
    64a4:	00008067          	ret

000064a8 <i2c_rxNack>:
    64a8:	00c52503          	lw	a0,12(a0)
        return (read_u32(reg + I2C_RX_ACK) & I2C_RX_VALUE) != 0;
    64ac:	0ff57513          	andi	a0,a0,255
    }
    64b0:	00a03533          	snez	a0,a0
    64b4:	00008067          	ret

000064b8 <i2c_rxAck>:
    64b8:	00c52503          	lw	a0,12(a0)
        return (read_u32(reg + I2C_RX_ACK) & I2C_RX_VALUE) == 0;
    64bc:	0ff57513          	andi	a0,a0,255
    }
    64c0:	00153513          	seqz	a0,a0
    64c4:	00008067          	ret

000064c8 <bsp_printf>:
    {
    64c8:	fc010113          	addi	sp,sp,-64
    64cc:	00112e23          	sw	ra,28(sp)
    64d0:	00812c23          	sw	s0,24(sp)
    64d4:	00912a23          	sw	s1,20(sp)
    64d8:	00050493          	mv	s1,a0
    64dc:	02b12223          	sw	a1,36(sp)
    64e0:	02c12423          	sw	a2,40(sp)
    64e4:	02d12623          	sw	a3,44(sp)
    64e8:	02e12823          	sw	a4,48(sp)
    64ec:	02f12a23          	sw	a5,52(sp)
    64f0:	03012c23          	sw	a6,56(sp)
    64f4:	03112e23          	sw	a7,60(sp)
        va_start(ap, format);
    64f8:	02410793          	addi	a5,sp,36
    64fc:	00f12623          	sw	a5,12(sp)
        for (i = 0; format[i]; i++)
    6500:	00000413          	li	s0,0
    6504:	01c0006f          	j	6520 <bsp_printf+0x58>
                        bsp_printf_c(va_arg(ap,int));
    6508:	00c12783          	lw	a5,12(sp)
    650c:	00478713          	addi	a4,a5,4
    6510:	00e12623          	sw	a4,12(sp)
    6514:	0007a503          	lw	a0,0(a5)
    6518:	dadff0ef          	jal	ra,62c4 <bsp_printf_c>
        for (i = 0; format[i]; i++)
    651c:	00140413          	addi	s0,s0,1
    6520:	008487b3          	add	a5,s1,s0
    6524:	0007c503          	lbu	a0,0(a5)
    6528:	0c050263          	beqz	a0,65ec <bsp_printf+0x124>
            if (format[i] == '%') {
    652c:	02500793          	li	a5,37
    6530:	06f50663          	beq	a0,a5,659c <bsp_printf+0xd4>
                bsp_printf_c(format[i]);
    6534:	d91ff0ef          	jal	ra,62c4 <bsp_printf_c>
    6538:	fe5ff06f          	j	651c <bsp_printf+0x54>
                        bsp_printf_s(va_arg(ap,char*));
    653c:	00c12783          	lw	a5,12(sp)
    6540:	00478713          	addi	a4,a5,4
    6544:	00e12623          	sw	a4,12(sp)
    6548:	0007a503          	lw	a0,0(a5)
    654c:	d95ff0ef          	jal	ra,62e0 <bsp_printf_s>
                        break;
    6550:	fcdff06f          	j	651c <bsp_printf+0x54>
                        bsp_printf_d(va_arg(ap,int));
    6554:	00c12783          	lw	a5,12(sp)
    6558:	00478713          	addi	a4,a5,4
    655c:	00e12623          	sw	a4,12(sp)
    6560:	0007a503          	lw	a0,0(a5)
    6564:	d95ff0ef          	jal	ra,62f8 <bsp_printf_d>
                        break;
    6568:	fb5ff06f          	j	651c <bsp_printf+0x54>
                        bsp_printf_X(va_arg(ap,int));
    656c:	00c12783          	lw	a5,12(sp)
    6570:	00478713          	addi	a4,a5,4
    6574:	00e12623          	sw	a4,12(sp)
    6578:	0007a503          	lw	a0,0(a5)
    657c:	e3dff0ef          	jal	ra,63b8 <bsp_printf_X>
                        break;
    6580:	f9dff06f          	j	651c <bsp_printf+0x54>
                        bsp_printf_x(va_arg(ap,int));
    6584:	00c12783          	lw	a5,12(sp)
    6588:	00478713          	addi	a4,a5,4
    658c:	00e12623          	sw	a4,12(sp)
    6590:	0007a503          	lw	a0,0(a5)
    6594:	de5ff0ef          	jal	ra,6378 <bsp_printf_x>
                        break;
    6598:	f85ff06f          	j	651c <bsp_printf+0x54>
                while (format[++i]) {
    659c:	00140413          	addi	s0,s0,1
    65a0:	008487b3          	add	a5,s1,s0
    65a4:	0007c783          	lbu	a5,0(a5)
    65a8:	f6078ae3          	beqz	a5,651c <bsp_printf+0x54>
                    if (format[i] == 'c') {
    65ac:	06300713          	li	a4,99
    65b0:	f4e78ce3          	beq	a5,a4,6508 <bsp_printf+0x40>
                    else if (format[i] == 's') {
    65b4:	07300713          	li	a4,115
    65b8:	f8e782e3          	beq	a5,a4,653c <bsp_printf+0x74>
                    else if (format[i] == 'd') {
    65bc:	06400713          	li	a4,100
    65c0:	f8e78ae3          	beq	a5,a4,6554 <bsp_printf+0x8c>
                    else if (format[i] == 'X') {
    65c4:	05800713          	li	a4,88
    65c8:	fae782e3          	beq	a5,a4,656c <bsp_printf+0xa4>
                    else if (format[i] == 'x') {
    65cc:	07800713          	li	a4,120
    65d0:	fae78ae3          	beq	a5,a4,6584 <bsp_printf+0xbc>
                    else if (format[i] == 'f') {
    65d4:	06600713          	li	a4,102
    65d8:	fce792e3          	bne	a5,a4,659c <bsp_printf+0xd4>
                        bsp_printf_s("<Floating point printing not enable. Please Enable it at bsp.h first...>");
    65dc:	00009537          	lui	a0,0x9
    65e0:	b8850513          	addi	a0,a0,-1144 # 8b88 <_data+0xe0>
    65e4:	cfdff0ef          	jal	ra,62e0 <bsp_printf_s>
                        break;
    65e8:	f35ff06f          	j	651c <bsp_printf+0x54>
    }
    65ec:	01c12083          	lw	ra,28(sp)
    65f0:	01812403          	lw	s0,24(sp)
    65f4:	01412483          	lw	s1,20(sp)
    65f8:	04010113          	addi	sp,sp,64
    65fc:	00008067          	ret

00006600 <imx477_WriteRegData>:




int imx477_WriteRegData(u16 reg,u8 data)
{
    6600:	ff010113          	addi	sp,sp,-16
    6604:	00112623          	sw	ra,12(sp)
    6608:	00812423          	sw	s0,8(sp)
    660c:	00912223          	sw	s1,4(sp)
    6610:	00050413          	mv	s0,a0
    6614:	00058493          	mv	s1,a1
	u8 outdata;

    i2c_masterStartBlocking(I2C_CTRL_MIPI);
    6618:	f8017537          	lui	a0,0xf8017
    661c:	de9ff0ef          	jal	ra,6404 <i2c_masterStartBlocking>
        *((volatile u32*) address) = data;
    6620:	f8017737          	lui	a4,0xf8017
    6624:	000017b7          	lui	a5,0x1
    6628:	b3478793          	addi	a5,a5,-1228 # b34 <CUSTOM2+0xad9>
    662c:	00f72023          	sw	a5,0(a4) # f8017000 <__freertos_irq_stack_top+0xf7fc33d0>

    i2c_txByte(I2C_CTRL_MIPI, imx477_I2C_addr<<1);
	i2c_txNackBlocking(I2C_CTRL_MIPI);
    6630:	f8017537          	lui	a0,0xf8017
    6634:	e49ff0ef          	jal	ra,647c <i2c_txNackBlocking>
	if (assert(i2c_rxAck(I2C_CTRL_MIPI)) ) // Optional check
    6638:	f8017537          	lui	a0,0xf8017
    663c:	e7dff0ef          	jal	ra,64b8 <i2c_rxAck>
    6640:	e11fe0ef          	jal	ra,5450 <assert>
    6644:	02050063          	beqz	a0,6664 <imx477_WriteRegData+0x64>
		return 1;
    6648:	00100413          	li	s0,1
	if (assert(i2c_rxAck(I2C_CTRL_MIPI)) ) // Optional check
		return 1;
	i2c_masterStopBlocking(I2C_CTRL_MIPI);

	return 0;
}
    664c:	00040513          	mv	a0,s0
    6650:	00c12083          	lw	ra,12(sp)
    6654:	00812403          	lw	s0,8(sp)
    6658:	00412483          	lw	s1,4(sp)
    665c:	01010113          	addi	sp,sp,16
    6660:	00008067          	ret
	i2c_txByte(I2C_CTRL_MIPI, (reg>>8) & 0xFF);
    6664:	00845793          	srli	a5,s0,0x8
        write_u32(byte | I2C_TX_VALID | I2C_TX_ENABLE | I2C_TX_DISABLE_ON_DATA_CONFLICT, reg + I2C_TX_DATA);
    6668:	00001737          	lui	a4,0x1
    666c:	b0070713          	addi	a4,a4,-1280 # b00 <CUSTOM2+0xaa5>
    6670:	00e7e7b3          	or	a5,a5,a4
    6674:	f8017737          	lui	a4,0xf8017
    6678:	00f72023          	sw	a5,0(a4) # f8017000 <__freertos_irq_stack_top+0xf7fc33d0>
	i2c_txNackBlocking(I2C_CTRL_MIPI);
    667c:	f8017537          	lui	a0,0xf8017
    6680:	dfdff0ef          	jal	ra,647c <i2c_txNackBlocking>
	if (assert(i2c_rxAck(I2C_CTRL_MIPI)) ) // Optional check
    6684:	f8017537          	lui	a0,0xf8017
    6688:	e31ff0ef          	jal	ra,64b8 <i2c_rxAck>
    668c:	dc5fe0ef          	jal	ra,5450 <assert>
    6690:	00050663          	beqz	a0,669c <imx477_WriteRegData+0x9c>
		return 1;
    6694:	00100413          	li	s0,1
    6698:	fb5ff06f          	j	664c <imx477_WriteRegData+0x4c>
	i2c_txByte(I2C_CTRL_MIPI, (reg) & 0xFF);
    669c:	0ff47413          	andi	s0,s0,255
    66a0:	000017b7          	lui	a5,0x1
    66a4:	b0078793          	addi	a5,a5,-1280 # b00 <CUSTOM2+0xaa5>
    66a8:	00f46433          	or	s0,s0,a5
    66ac:	f80177b7          	lui	a5,0xf8017
    66b0:	0087a023          	sw	s0,0(a5) # f8017000 <__freertos_irq_stack_top+0xf7fc33d0>
	i2c_txNackBlocking(I2C_CTRL_MIPI);
    66b4:	f8017537          	lui	a0,0xf8017
    66b8:	dc5ff0ef          	jal	ra,647c <i2c_txNackBlocking>
	if (assert(i2c_rxAck(I2C_CTRL_MIPI)) ) // Optional check
    66bc:	f8017537          	lui	a0,0xf8017
    66c0:	df9ff0ef          	jal	ra,64b8 <i2c_rxAck>
    66c4:	d8dfe0ef          	jal	ra,5450 <assert>
    66c8:	00050663          	beqz	a0,66d4 <imx477_WriteRegData+0xd4>
		return 1;
    66cc:	00100413          	li	s0,1
    66d0:	f7dff06f          	j	664c <imx477_WriteRegData+0x4c>
    66d4:	000017b7          	lui	a5,0x1
    66d8:	b0078793          	addi	a5,a5,-1280 # b00 <CUSTOM2+0xaa5>
    66dc:	00f4e4b3          	or	s1,s1,a5
    66e0:	f80177b7          	lui	a5,0xf8017
    66e4:	0097a023          	sw	s1,0(a5) # f8017000 <__freertos_irq_stack_top+0xf7fc33d0>
	i2c_txNackBlocking(I2C_CTRL_MIPI);
    66e8:	f8017537          	lui	a0,0xf8017
    66ec:	d91ff0ef          	jal	ra,647c <i2c_txNackBlocking>
	if (assert(i2c_rxAck(I2C_CTRL_MIPI)) ) // Optional check
    66f0:	f8017537          	lui	a0,0xf8017
    66f4:	dc5ff0ef          	jal	ra,64b8 <i2c_rxAck>
    66f8:	d59fe0ef          	jal	ra,5450 <assert>
    66fc:	00050413          	mv	s0,a0
    6700:	00050663          	beqz	a0,670c <imx477_WriteRegData+0x10c>
		return 1;
    6704:	00100413          	li	s0,1
    6708:	f45ff06f          	j	664c <imx477_WriteRegData+0x4c>
	i2c_masterStopBlocking(I2C_CTRL_MIPI);
    670c:	f8017537          	lui	a0,0xf8017
    6710:	d3dff0ef          	jal	ra,644c <i2c_masterStopBlocking>
	return 0;
    6714:	f39ff06f          	j	664c <imx477_WriteRegData+0x4c>

00006718 <imx477_ReadRegData>:

u8 imx477_ReadRegData(u16 reg)
{
    6718:	fe010113          	addi	sp,sp,-32
    671c:	00112e23          	sw	ra,28(sp)
    6720:	00812c23          	sw	s0,24(sp)
    6724:	00912a23          	sw	s1,20(sp)
    6728:	01212823          	sw	s2,16(sp)
    672c:	01312623          	sw	s3,12(sp)
    6730:	00050493          	mv	s1,a0
	u8 outdata;

    i2c_masterStartBlocking(I2C_CTRL_MIPI);
    6734:	f8017537          	lui	a0,0xf8017
    6738:	ccdff0ef          	jal	ra,6404 <i2c_masterStartBlocking>
    673c:	f8017937          	lui	s2,0xf8017
    6740:	00001437          	lui	s0,0x1
    6744:	b3440793          	addi	a5,s0,-1228 # b34 <CUSTOM2+0xad9>
    6748:	00f92023          	sw	a5,0(s2) # f8017000 <__freertos_irq_stack_top+0xf7fc33d0>

    i2c_txByte(I2C_CTRL_MIPI, imx477_I2C_addr<<1);
	i2c_txNackBlocking(I2C_CTRL_MIPI);
    674c:	f8017537          	lui	a0,0xf8017
    6750:	d2dff0ef          	jal	ra,647c <i2c_txNackBlocking>
	assert(i2c_rxAck(I2C_CTRL_MIPI)); // Optional check
    6754:	f8017537          	lui	a0,0xf8017
    6758:	d61ff0ef          	jal	ra,64b8 <i2c_rxAck>
    675c:	cf5fe0ef          	jal	ra,5450 <assert>

	i2c_txByte(I2C_CTRL_MIPI, (reg>>8) & 0xFF);
    6760:	0084d793          	srli	a5,s1,0x8
    6764:	b0040993          	addi	s3,s0,-1280
    6768:	0137e7b3          	or	a5,a5,s3
    676c:	00f92023          	sw	a5,0(s2)
	i2c_txNackBlocking(I2C_CTRL_MIPI);
    6770:	f8017537          	lui	a0,0xf8017
    6774:	d09ff0ef          	jal	ra,647c <i2c_txNackBlocking>
	assert(i2c_rxAck(I2C_CTRL_MIPI)); // Optional check
    6778:	f8017537          	lui	a0,0xf8017
    677c:	d3dff0ef          	jal	ra,64b8 <i2c_rxAck>
    6780:	cd1fe0ef          	jal	ra,5450 <assert>

	i2c_txByte(I2C_CTRL_MIPI, (reg) & 0xFF);
    6784:	0ff4f493          	andi	s1,s1,255
    6788:	0134e4b3          	or	s1,s1,s3
    678c:	00992023          	sw	s1,0(s2)
	i2c_txNackBlocking(I2C_CTRL_MIPI);
    6790:	f8017537          	lui	a0,0xf8017
    6794:	ce9ff0ef          	jal	ra,647c <i2c_txNackBlocking>
	assert(i2c_rxAck(I2C_CTRL_MIPI)); // Optional check
    6798:	f8017537          	lui	a0,0xf8017
    679c:	d1dff0ef          	jal	ra,64b8 <i2c_rxAck>
    67a0:	cb1fe0ef          	jal	ra,5450 <assert>

	i2c_masterStopBlocking(I2C_CTRL_MIPI);
    67a4:	f8017537          	lui	a0,0xf8017
    67a8:	ca5ff0ef          	jal	ra,644c <i2c_masterStopBlocking>
	i2c_masterStartBlocking(I2C_CTRL_MIPI);
    67ac:	f8017537          	lui	a0,0xf8017
    67b0:	c55ff0ef          	jal	ra,6404 <i2c_masterStartBlocking>
    67b4:	b3540793          	addi	a5,s0,-1227
    67b8:	00f92023          	sw	a5,0(s2)

	i2c_txByte(I2C_CTRL_MIPI, (imx477_I2C_addr<<1) | 0x01);
	i2c_txNackBlocking(I2C_CTRL_MIPI);
    67bc:	f8017537          	lui	a0,0xf8017
    67c0:	cbdff0ef          	jal	ra,647c <i2c_txNackBlocking>
	assert(i2c_rxAck(I2C_CTRL_MIPI)); // Optional check
    67c4:	f8017537          	lui	a0,0xf8017
    67c8:	cf1ff0ef          	jal	ra,64b8 <i2c_rxAck>
    67cc:	c85fe0ef          	jal	ra,5450 <assert>
    67d0:	bff40413          	addi	s0,s0,-1025
    67d4:	00892023          	sw	s0,0(s2)

	i2c_txByte(I2C_CTRL_MIPI, 0xFF);
	i2c_txNackBlocking(I2C_CTRL_MIPI);
    67d8:	f8017537          	lui	a0,0xf8017
    67dc:	ca1ff0ef          	jal	ra,647c <i2c_txNackBlocking>
	assert(i2c_rxNack(I2C_CTRL_MIPI)); // Optional check
    67e0:	f8017537          	lui	a0,0xf8017
    67e4:	cc5ff0ef          	jal	ra,64a8 <i2c_rxNack>
    67e8:	c69fe0ef          	jal	ra,5450 <assert>
	outdata = i2c_rxData(I2C_CTRL_MIPI);
    67ec:	f8017537          	lui	a0,0xf8017
    67f0:	cadff0ef          	jal	ra,649c <i2c_rxData>
    67f4:	0ff57413          	andi	s0,a0,255

	i2c_masterStopBlocking(I2C_CTRL_MIPI);
    67f8:	f8017537          	lui	a0,0xf8017
    67fc:	c51ff0ef          	jal	ra,644c <i2c_masterStopBlocking>

	return outdata;
}
    6800:	00040513          	mv	a0,s0
    6804:	01c12083          	lw	ra,28(sp)
    6808:	01812403          	lw	s0,24(sp)
    680c:	01412483          	lw	s1,20(sp)
    6810:	01012903          	lw	s2,16(sp)
    6814:	00c12983          	lw	s3,12(sp)
    6818:	02010113          	addi	sp,sp,32
    681c:	00008067          	ret

00006820 <imx477_WriteRegs>:


int imx477_WriteRegs(const struct imx477_reg *regs,u16 size )
{
    6820:	ff010113          	addi	sp,sp,-16
    6824:	00112623          	sw	ra,12(sp)
    6828:	00812423          	sw	s0,8(sp)
    682c:	00912223          	sw	s1,4(sp)
    6830:	01212023          	sw	s2,0(sp)
    6834:	00050913          	mv	s2,a0
    6838:	00058493          	mv	s1,a1
	bsp_printf("Imx477 Initial Table size :%d  !\n\r",size / (sizeof(struct imx477_reg )) );
    683c:	0025d593          	srli	a1,a1,0x2
    6840:	0000a537          	lui	a0,0xa
    6844:	8bc50513          	addi	a0,a0,-1860 # 98bc <imx477_mode_1920x1080_60fps+0x1c8>
    6848:	c81ff0ef          	jal	ra,64c8 <bsp_printf>
	for(int x=0; x < size; x++)
    684c:	00000413          	li	s0,0
    6850:	02945263          	bge	s0,s1,6874 <imx477_WriteRegs+0x54>
	{


		if(imx477_WriteRegData( regs[x].address, regs[x].val ) )
    6854:	00241793          	slli	a5,s0,0x2
    6858:	00f907b3          	add	a5,s2,a5
    685c:	0027c583          	lbu	a1,2(a5)
    6860:	0007d503          	lhu	a0,0(a5)
    6864:	d9dff0ef          	jal	ra,6600 <imx477_WriteRegData>
    6868:	02051463          	bnez	a0,6890 <imx477_WriteRegs+0x70>
	for(int x=0; x < size; x++)
    686c:	00140413          	addi	s0,s0,1
    6870:	fe1ff06f          	j	6850 <imx477_WriteRegs+0x30>
			return 1;
		}
	//	bsp_printf("Address :%x Data:  %x !\n\r",regs[x].address, regs[x].val  );

	}
	return 0;
    6874:	00000513          	li	a0,0
}
    6878:	00c12083          	lw	ra,12(sp)
    687c:	00812403          	lw	s0,8(sp)
    6880:	00412483          	lw	s1,4(sp)
    6884:	00012903          	lw	s2,0(sp)
    6888:	01010113          	addi	sp,sp,16
    688c:	00008067          	ret
			return 1;
    6890:	00100513          	li	a0,1
    6894:	fe5ff06f          	j	6878 <imx477_WriteRegs+0x58>

00006898 <imx477_init>:



int imx477_init(void)
{
    6898:	ff010113          	addi	sp,sp,-16
    689c:	00112623          	sw	ra,12(sp)
   if (imx477_WriteRegData(IMX477_REG_MODE_SELECT, 0x00) )
    68a0:	00000593          	li	a1,0
    68a4:	10000513          	li	a0,256
    68a8:	d59ff0ef          	jal	ra,6600 <imx477_WriteRegData>
    68ac:	00050a63          	beqz	a0,68c0 <imx477_init+0x28>
	   return 1;
    68b0:	00100513          	li	a0,1
  /* if (imx477_WriteRegs(dummy_raspiberry, sizeof (dummy_raspiberry )  /sizeof(struct imx477_reg )  ) )
  	   return 2;
*/

   return 0;
}
    68b4:	00c12083          	lw	ra,12(sp)
    68b8:	01010113          	addi	sp,sp,16
    68bc:	00008067          	ret
   if (imx477_WriteRegs(mode_common_regs, sizeof (mode_common_regs )  /sizeof(struct imx477_reg )  ) )
    68c0:	13200593          	li	a1,306
    68c4:	00009537          	lui	a0,0x9
    68c8:	22c50513          	addi	a0,a0,556 # 922c <mode_common_regs>
    68cc:	f55ff0ef          	jal	ra,6820 <imx477_WriteRegs>
    68d0:	0e051a63          	bnez	a0,69c4 <imx477_init+0x12c>
  if (imx477_WriteRegs(imx477_mode_1920x1080_60fps, sizeof (imx477_mode_1920x1080_60fps)  /sizeof(struct imx477_reg )) )
    68d4:	07200593          	li	a1,114
    68d8:	00009537          	lui	a0,0x9
    68dc:	22c50513          	addi	a0,a0,556 # 922c <mode_common_regs>
    68e0:	4c850513          	addi	a0,a0,1224
    68e4:	f3dff0ef          	jal	ra,6820 <imx477_WriteRegs>
    68e8:	0e051263          	bnez	a0,69cc <imx477_init+0x134>
   if (imx477_WriteRegData(IMX477_REG_ORIENTATION, 0x02) )
    68ec:	00200593          	li	a1,2
    68f0:	10100513          	li	a0,257
    68f4:	d0dff0ef          	jal	ra,6600 <imx477_WriteRegData>
    68f8:	00050663          	beqz	a0,6904 <imx477_init+0x6c>
   	   return 1;
    68fc:	00100513          	li	a0,1
    6900:	fb5ff06f          	j	68b4 <imx477_init+0x1c>
   if (imx477_WriteRegData(IMX477_REG_FRAME_LENGTH, 0x09) )
    6904:	00900593          	li	a1,9
    6908:	34000513          	li	a0,832
    690c:	cf5ff0ef          	jal	ra,6600 <imx477_WriteRegData>
    6910:	00050663          	beqz	a0,691c <imx477_init+0x84>
	   return 1;
    6914:	00100513          	li	a0,1
    6918:	f9dff06f          	j	68b4 <imx477_init+0x1c>
   if (imx477_WriteRegData(IMX477_REG_FRAME_LENGTH+1, 0x95) )
    691c:	09500593          	li	a1,149
    6920:	34100513          	li	a0,833
    6924:	cddff0ef          	jal	ra,6600 <imx477_WriteRegData>
    6928:	00050663          	beqz	a0,6934 <imx477_init+0x9c>
	   return 1;
    692c:	00100513          	li	a0,1
    6930:	f85ff06f          	j	68b4 <imx477_init+0x1c>
   if (imx477_WriteRegData(IMX477_REG_EXPOSURE, 0x0f) )
    6934:	00f00593          	li	a1,15
    6938:	20200513          	li	a0,514
    693c:	cc5ff0ef          	jal	ra,6600 <imx477_WriteRegData>
    6940:	00050663          	beqz	a0,694c <imx477_init+0xb4>
   	   return 1;
    6944:	00100513          	li	a0,1
    6948:	f6dff06f          	j	68b4 <imx477_init+0x1c>
   if (imx477_WriteRegData(IMX477_REG_EXPOSURE+1, 0xC6) )
    694c:	0c600593          	li	a1,198
    6950:	20300513          	li	a0,515
    6954:	cadff0ef          	jal	ra,6600 <imx477_WriteRegData>
    6958:	00050663          	beqz	a0,6964 <imx477_init+0xcc>
   	   return 1;
    695c:	00100513          	li	a0,1
    6960:	f55ff06f          	j	68b4 <imx477_init+0x1c>
   if (imx477_WriteRegData(IMX477_REG_ANALOG_GAIN, 0x03) )
    6964:	00300593          	li	a1,3
    6968:	20400513          	li	a0,516
    696c:	c95ff0ef          	jal	ra,6600 <imx477_WriteRegData>
    6970:	00050663          	beqz	a0,697c <imx477_init+0xe4>
     	   return 1;
    6974:	00100513          	li	a0,1
    6978:	f3dff06f          	j	68b4 <imx477_init+0x1c>
   if (imx477_WriteRegData(IMX477_REG_ANALOG_GAIN+1, 0x00) )
    697c:	00000593          	li	a1,0
    6980:	20500513          	li	a0,517
    6984:	c7dff0ef          	jal	ra,6600 <imx477_WriteRegData>
    6988:	00050663          	beqz	a0,6994 <imx477_init+0xfc>
     	   return 1;
    698c:	00100513          	li	a0,1
    6990:	f25ff06f          	j	68b4 <imx477_init+0x1c>
   if (imx477_WriteRegData(IMX477_REG_CSI_LANE_MODE, 0x01) )
    6994:	00100593          	li	a1,1
    6998:	11400513          	li	a0,276
    699c:	c65ff0ef          	jal	ra,6600 <imx477_WriteRegData>
    69a0:	00050663          	beqz	a0,69ac <imx477_init+0x114>
   	   return 1;
    69a4:	00100513          	li	a0,1
    69a8:	f0dff06f          	j	68b4 <imx477_init+0x1c>
   if (imx477_WriteRegData(IMX477_REG_MODE_SELECT, 0x01) )
    69ac:	00100593          	li	a1,1
    69b0:	10000513          	li	a0,256
    69b4:	c4dff0ef          	jal	ra,6600 <imx477_WriteRegData>
    69b8:	ee050ee3          	beqz	a0,68b4 <imx477_init+0x1c>
  	   return 1;
    69bc:	00100513          	li	a0,1
    69c0:	ef5ff06f          	j	68b4 <imx477_init+0x1c>
	   return 2;
    69c4:	00200513          	li	a0,2
    69c8:	eedff06f          	j	68b4 <imx477_init+0x1c>
	   return 3;
    69cc:	00300513          	li	a0,3
    69d0:	ee5ff06f          	j	68b4 <imx477_init+0x1c>

000069d4 <clint_uDelay>:
        u32 mTimePerUsec = hz/1000000;
    69d4:	000f47b7          	lui	a5,0xf4
    69d8:	24078793          	addi	a5,a5,576 # f4240 <__freertos_irq_stack_top+0xa0610>
    69dc:	02f5d5b3          	divu	a1,a1,a5
    readReg_u32 (clint_getTimeLow , CLINT_TIME_ADDR)
    69e0:	0000c7b7          	lui	a5,0xc
    69e4:	ff878793          	addi	a5,a5,-8 # bff8 <raw_table4+0x24d8>
    69e8:	00f60633          	add	a2,a2,a5
        return *((volatile u32*) address);
    69ec:	00062783          	lw	a5,0(a2) # f8b00000 <__freertos_irq_stack_top+0xf8aac3d0>
        u32 limit = clint_getTimeLow(reg) + usec*mTimePerUsec;
    69f0:	02a58533          	mul	a0,a1,a0
    69f4:	00f50533          	add	a0,a0,a5
    69f8:	00062783          	lw	a5,0(a2)
        while((int32_t)(limit-(clint_getTimeLow(reg))) >= 0);
    69fc:	40f507b3          	sub	a5,a0,a5
    6a00:	fe07dce3          	bgez	a5,69f8 <clint_uDelay+0x24>
    6a04:	00008067          	ret

00006a08 <i2c_masterBusy>:
    6a08:	04052503          	lw	a0,64(a0)
    }
    6a0c:	00157513          	andi	a0,a0,1
    6a10:	00008067          	ret

00006a14 <i2c_masterStartBlocking>:
        write_u32(I2C_MASTER_START | I2C_MASTER_START_DROPPED, reg + I2C_MASTER_STATUS);
    6a14:	04050713          	addi	a4,a0,64
        *((volatile u32*) address) = data;
    6a18:	21000793          	li	a5,528
    6a1c:	04f52023          	sw	a5,64(a0)
        return *((volatile u32*) address);
    6a20:	00072783          	lw	a5,0(a4)
        while(i2c_getMasterStatus(reg) & I2C_MASTER_START);
    6a24:	0107f793          	andi	a5,a5,16
    6a28:	fe079ce3          	bnez	a5,6a20 <i2c_masterStartBlocking+0xc>
    }
    6a2c:	00008067          	ret

00006a30 <i2c_masterStopWait>:
    static void i2c_masterStopWait(u32 reg){
    6a30:	ff010113          	addi	sp,sp,-16
    6a34:	00112623          	sw	ra,12(sp)
    6a38:	00812423          	sw	s0,8(sp)
    6a3c:	00050413          	mv	s0,a0
        while(i2c_masterBusy(reg));
    6a40:	00040513          	mv	a0,s0
    6a44:	fc5ff0ef          	jal	ra,6a08 <i2c_masterBusy>
    6a48:	fe051ce3          	bnez	a0,6a40 <i2c_masterStopWait+0x10>
    }
    6a4c:	00c12083          	lw	ra,12(sp)
    6a50:	00812403          	lw	s0,8(sp)
    6a54:	01010113          	addi	sp,sp,16
    6a58:	00008067          	ret

00006a5c <i2c_masterStopBlocking>:
    static void i2c_masterStopBlocking(u32 reg){
    6a5c:	ff010113          	addi	sp,sp,-16
    6a60:	00112623          	sw	ra,12(sp)
        *((volatile u32*) address) = data;
    6a64:	42000713          	li	a4,1056
    6a68:	04e52023          	sw	a4,64(a0)
        i2c_masterStopWait(reg);
    6a6c:	fc5ff0ef          	jal	ra,6a30 <i2c_masterStopWait>
    }
    6a70:	00c12083          	lw	ra,12(sp)
    6a74:	01010113          	addi	sp,sp,16
    6a78:	00008067          	ret

00006a7c <i2c_txAckWait>:
        return *((volatile u32*) address);
    6a7c:	00452783          	lw	a5,4(a0)
        while(read_u32(reg + I2C_TX_ACK) & I2C_TX_VALID);
    6a80:	1007f793          	andi	a5,a5,256
    6a84:	fe079ce3          	bnez	a5,6a7c <i2c_txAckWait>
    }
    6a88:	00008067          	ret

00006a8c <i2c_txNackBlocking>:
    static void i2c_txNackBlocking(u32 reg){
    6a8c:	ff010113          	addi	sp,sp,-16
    6a90:	00112623          	sw	ra,12(sp)
        *((volatile u32*) address) = data;
    6a94:	30100713          	li	a4,769
    6a98:	00e52223          	sw	a4,4(a0)
        i2c_txAckWait(reg);
    6a9c:	fe1ff0ef          	jal	ra,6a7c <i2c_txAckWait>
    }
    6aa0:	00c12083          	lw	ra,12(sp)
    6aa4:	01010113          	addi	sp,sp,16
    6aa8:	00008067          	ret

00006aac <i2c_rxData>:
        return *((volatile u32*) address);
    6aac:	00852503          	lw	a0,8(a0)
    }
    6ab0:	0ff57513          	andi	a0,a0,255
    6ab4:	00008067          	ret

00006ab8 <i2c_rxNack>:
    6ab8:	00c52503          	lw	a0,12(a0)
        return (read_u32(reg + I2C_RX_ACK) & I2C_RX_VALUE) != 0;
    6abc:	0ff57513          	andi	a0,a0,255
    }
    6ac0:	00a03533          	snez	a0,a0
    6ac4:	00008067          	ret

00006ac8 <i2c_rxAck>:
    6ac8:	00c52503          	lw	a0,12(a0)
        return (read_u32(reg + I2C_RX_ACK) & I2C_RX_VALUE) == 0;
    6acc:	0ff57513          	andi	a0,a0,255
    }
    6ad0:	00153513          	seqz	a0,a0
    6ad4:	00008067          	ret

00006ad8 <GMSL_Ser_WriteRegData>:




int GMSL_Ser_WriteRegData(u16 reg,u8 data)
{
    6ad8:	ff010113          	addi	sp,sp,-16
    6adc:	00112623          	sw	ra,12(sp)
    6ae0:	00812423          	sw	s0,8(sp)
    6ae4:	00912223          	sw	s1,4(sp)
    6ae8:	00050413          	mv	s0,a0
    6aec:	00058493          	mv	s1,a1
	u8 outdata;

    i2c_masterStartBlocking(I2C_CTRL_MIPI);
    6af0:	f8017537          	lui	a0,0xf8017
    6af4:	f21ff0ef          	jal	ra,6a14 <i2c_masterStartBlocking>
        *((volatile u32*) address) = data;
    6af8:	f8017737          	lui	a4,0xf8017
    6afc:	000017b7          	lui	a5,0x1
    6b00:	b8078793          	addi	a5,a5,-1152 # b80 <CUSTOM2+0xb25>
    6b04:	00f72023          	sw	a5,0(a4) # f8017000 <__freertos_irq_stack_top+0xf7fc33d0>

    i2c_txByte(I2C_CTRL_MIPI, GMSL_Ser_I2C_addr<<1);
	i2c_txNackBlocking(I2C_CTRL_MIPI);
    6b08:	f8017537          	lui	a0,0xf8017
    6b0c:	f81ff0ef          	jal	ra,6a8c <i2c_txNackBlocking>
	if (assert(i2c_rxAck(I2C_CTRL_MIPI)) ) // Optional check
    6b10:	f8017537          	lui	a0,0xf8017
    6b14:	fb5ff0ef          	jal	ra,6ac8 <i2c_rxAck>
    6b18:	939fe0ef          	jal	ra,5450 <assert>
    6b1c:	02050063          	beqz	a0,6b3c <GMSL_Ser_WriteRegData+0x64>
		return 1;
    6b20:	00100413          	li	s0,1
	if (assert(i2c_rxAck(I2C_CTRL_MIPI)) ) // Optional check
		return 1;
	i2c_masterStopBlocking(I2C_CTRL_MIPI);

	return 0;
}
    6b24:	00040513          	mv	a0,s0
    6b28:	00c12083          	lw	ra,12(sp)
    6b2c:	00812403          	lw	s0,8(sp)
    6b30:	00412483          	lw	s1,4(sp)
    6b34:	01010113          	addi	sp,sp,16
    6b38:	00008067          	ret
	i2c_txByte(I2C_CTRL_MIPI, (reg>>8) & 0xFF);
    6b3c:	00845793          	srli	a5,s0,0x8
        write_u32(byte | I2C_TX_VALID | I2C_TX_ENABLE | I2C_TX_DISABLE_ON_DATA_CONFLICT, reg + I2C_TX_DATA);
    6b40:	00001737          	lui	a4,0x1
    6b44:	b0070713          	addi	a4,a4,-1280 # b00 <CUSTOM2+0xaa5>
    6b48:	00e7e7b3          	or	a5,a5,a4
    6b4c:	f8017737          	lui	a4,0xf8017
    6b50:	00f72023          	sw	a5,0(a4) # f8017000 <__freertos_irq_stack_top+0xf7fc33d0>
	i2c_txNackBlocking(I2C_CTRL_MIPI);
    6b54:	f8017537          	lui	a0,0xf8017
    6b58:	f35ff0ef          	jal	ra,6a8c <i2c_txNackBlocking>
	if (assert(i2c_rxAck(I2C_CTRL_MIPI)) ) // Optional check
    6b5c:	f8017537          	lui	a0,0xf8017
    6b60:	f69ff0ef          	jal	ra,6ac8 <i2c_rxAck>
    6b64:	8edfe0ef          	jal	ra,5450 <assert>
    6b68:	00050663          	beqz	a0,6b74 <GMSL_Ser_WriteRegData+0x9c>
		return 1;
    6b6c:	00100413          	li	s0,1
    6b70:	fb5ff06f          	j	6b24 <GMSL_Ser_WriteRegData+0x4c>
	i2c_txByte(I2C_CTRL_MIPI, (reg) & 0xFF);
    6b74:	0ff47413          	andi	s0,s0,255
    6b78:	000017b7          	lui	a5,0x1
    6b7c:	b0078793          	addi	a5,a5,-1280 # b00 <CUSTOM2+0xaa5>
    6b80:	00f46433          	or	s0,s0,a5
    6b84:	f80177b7          	lui	a5,0xf8017
    6b88:	0087a023          	sw	s0,0(a5) # f8017000 <__freertos_irq_stack_top+0xf7fc33d0>
	i2c_txNackBlocking(I2C_CTRL_MIPI);
    6b8c:	f8017537          	lui	a0,0xf8017
    6b90:	efdff0ef          	jal	ra,6a8c <i2c_txNackBlocking>
	if (assert(i2c_rxAck(I2C_CTRL_MIPI)) ) // Optional check
    6b94:	f8017537          	lui	a0,0xf8017
    6b98:	f31ff0ef          	jal	ra,6ac8 <i2c_rxAck>
    6b9c:	8b5fe0ef          	jal	ra,5450 <assert>
    6ba0:	00050663          	beqz	a0,6bac <GMSL_Ser_WriteRegData+0xd4>
		return 1;
    6ba4:	00100413          	li	s0,1
    6ba8:	f7dff06f          	j	6b24 <GMSL_Ser_WriteRegData+0x4c>
    6bac:	000017b7          	lui	a5,0x1
    6bb0:	b0078793          	addi	a5,a5,-1280 # b00 <CUSTOM2+0xaa5>
    6bb4:	00f4e4b3          	or	s1,s1,a5
    6bb8:	f80177b7          	lui	a5,0xf8017
    6bbc:	0097a023          	sw	s1,0(a5) # f8017000 <__freertos_irq_stack_top+0xf7fc33d0>
	i2c_txNackBlocking(I2C_CTRL_MIPI);
    6bc0:	f8017537          	lui	a0,0xf8017
    6bc4:	ec9ff0ef          	jal	ra,6a8c <i2c_txNackBlocking>
	if (assert(i2c_rxAck(I2C_CTRL_MIPI)) ) // Optional check
    6bc8:	f8017537          	lui	a0,0xf8017
    6bcc:	efdff0ef          	jal	ra,6ac8 <i2c_rxAck>
    6bd0:	881fe0ef          	jal	ra,5450 <assert>
    6bd4:	00050413          	mv	s0,a0
    6bd8:	00050663          	beqz	a0,6be4 <GMSL_Ser_WriteRegData+0x10c>
		return 1;
    6bdc:	00100413          	li	s0,1
    6be0:	f45ff06f          	j	6b24 <GMSL_Ser_WriteRegData+0x4c>
	i2c_masterStopBlocking(I2C_CTRL_MIPI);
    6be4:	f8017537          	lui	a0,0xf8017
    6be8:	e75ff0ef          	jal	ra,6a5c <i2c_masterStopBlocking>
	return 0;
    6bec:	f39ff06f          	j	6b24 <GMSL_Ser_WriteRegData+0x4c>

00006bf0 <GMSL_Des_WriteRegData>:

int GMSL_Des_WriteRegData(u16 reg,u8 data)
{
    6bf0:	ff010113          	addi	sp,sp,-16
    6bf4:	00112623          	sw	ra,12(sp)
    6bf8:	00812423          	sw	s0,8(sp)
    6bfc:	00912223          	sw	s1,4(sp)
    6c00:	00050413          	mv	s0,a0
    6c04:	00058493          	mv	s1,a1
	u8 outdata;

    i2c_masterStartBlocking(I2C_CTRL_MIPI);
    6c08:	f8017537          	lui	a0,0xf8017
    6c0c:	e09ff0ef          	jal	ra,6a14 <i2c_masterStartBlocking>
    6c10:	f8017737          	lui	a4,0xf8017
    6c14:	000017b7          	lui	a5,0x1
    6c18:	b5078793          	addi	a5,a5,-1200 # b50 <CUSTOM2+0xaf5>
    6c1c:	00f72023          	sw	a5,0(a4) # f8017000 <__freertos_irq_stack_top+0xf7fc33d0>

    i2c_txByte(I2C_CTRL_MIPI, GMSl_Des_I2C_addr<<1);
	i2c_txNackBlocking(I2C_CTRL_MIPI);
    6c20:	f8017537          	lui	a0,0xf8017
    6c24:	e69ff0ef          	jal	ra,6a8c <i2c_txNackBlocking>
	if (assert(i2c_rxAck(I2C_CTRL_MIPI)) ) // Optional check
    6c28:	f8017537          	lui	a0,0xf8017
    6c2c:	e9dff0ef          	jal	ra,6ac8 <i2c_rxAck>
    6c30:	821fe0ef          	jal	ra,5450 <assert>
    6c34:	02050063          	beqz	a0,6c54 <GMSL_Des_WriteRegData+0x64>
		return 1;
    6c38:	00100413          	li	s0,1
	if (assert(i2c_rxAck(I2C_CTRL_MIPI)) ) // Optional check
		return 1;
	i2c_masterStopBlocking(I2C_CTRL_MIPI);

	return 0;
}
    6c3c:	00040513          	mv	a0,s0
    6c40:	00c12083          	lw	ra,12(sp)
    6c44:	00812403          	lw	s0,8(sp)
    6c48:	00412483          	lw	s1,4(sp)
    6c4c:	01010113          	addi	sp,sp,16
    6c50:	00008067          	ret
	i2c_txByte(I2C_CTRL_MIPI, (reg>>8) & 0xFF);
    6c54:	00845793          	srli	a5,s0,0x8
    6c58:	00001737          	lui	a4,0x1
    6c5c:	b0070713          	addi	a4,a4,-1280 # b00 <CUSTOM2+0xaa5>
    6c60:	00e7e7b3          	or	a5,a5,a4
    6c64:	f8017737          	lui	a4,0xf8017
    6c68:	00f72023          	sw	a5,0(a4) # f8017000 <__freertos_irq_stack_top+0xf7fc33d0>
	i2c_txNackBlocking(I2C_CTRL_MIPI);
    6c6c:	f8017537          	lui	a0,0xf8017
    6c70:	e1dff0ef          	jal	ra,6a8c <i2c_txNackBlocking>
	if (assert(i2c_rxAck(I2C_CTRL_MIPI)) ) // Optional check
    6c74:	f8017537          	lui	a0,0xf8017
    6c78:	e51ff0ef          	jal	ra,6ac8 <i2c_rxAck>
    6c7c:	fd4fe0ef          	jal	ra,5450 <assert>
    6c80:	00050663          	beqz	a0,6c8c <GMSL_Des_WriteRegData+0x9c>
		return 1;
    6c84:	00100413          	li	s0,1
    6c88:	fb5ff06f          	j	6c3c <GMSL_Des_WriteRegData+0x4c>
	i2c_txByte(I2C_CTRL_MIPI, (reg) & 0xFF);
    6c8c:	0ff47413          	andi	s0,s0,255
    6c90:	000017b7          	lui	a5,0x1
    6c94:	b0078793          	addi	a5,a5,-1280 # b00 <CUSTOM2+0xaa5>
    6c98:	00f46433          	or	s0,s0,a5
    6c9c:	f80177b7          	lui	a5,0xf8017
    6ca0:	0087a023          	sw	s0,0(a5) # f8017000 <__freertos_irq_stack_top+0xf7fc33d0>
	i2c_txNackBlocking(I2C_CTRL_MIPI);
    6ca4:	f8017537          	lui	a0,0xf8017
    6ca8:	de5ff0ef          	jal	ra,6a8c <i2c_txNackBlocking>
	if (assert(i2c_rxAck(I2C_CTRL_MIPI)) ) // Optional check
    6cac:	f8017537          	lui	a0,0xf8017
    6cb0:	e19ff0ef          	jal	ra,6ac8 <i2c_rxAck>
    6cb4:	f9cfe0ef          	jal	ra,5450 <assert>
    6cb8:	00050663          	beqz	a0,6cc4 <GMSL_Des_WriteRegData+0xd4>
		return 1;
    6cbc:	00100413          	li	s0,1
    6cc0:	f7dff06f          	j	6c3c <GMSL_Des_WriteRegData+0x4c>
    6cc4:	000017b7          	lui	a5,0x1
    6cc8:	b0078793          	addi	a5,a5,-1280 # b00 <CUSTOM2+0xaa5>
    6ccc:	00f4e4b3          	or	s1,s1,a5
    6cd0:	f80177b7          	lui	a5,0xf8017
    6cd4:	0097a023          	sw	s1,0(a5) # f8017000 <__freertos_irq_stack_top+0xf7fc33d0>
	i2c_txNackBlocking(I2C_CTRL_MIPI);
    6cd8:	f8017537          	lui	a0,0xf8017
    6cdc:	db1ff0ef          	jal	ra,6a8c <i2c_txNackBlocking>
	if (assert(i2c_rxAck(I2C_CTRL_MIPI)) ) // Optional check
    6ce0:	f8017537          	lui	a0,0xf8017
    6ce4:	de5ff0ef          	jal	ra,6ac8 <i2c_rxAck>
    6ce8:	f68fe0ef          	jal	ra,5450 <assert>
    6cec:	00050413          	mv	s0,a0
    6cf0:	00050663          	beqz	a0,6cfc <GMSL_Des_WriteRegData+0x10c>
		return 1;
    6cf4:	00100413          	li	s0,1
    6cf8:	f45ff06f          	j	6c3c <GMSL_Des_WriteRegData+0x4c>
	i2c_masterStopBlocking(I2C_CTRL_MIPI);
    6cfc:	f8017537          	lui	a0,0xf8017
    6d00:	d5dff0ef          	jal	ra,6a5c <i2c_masterStopBlocking>
	return 0;
    6d04:	f39ff06f          	j	6c3c <GMSL_Des_WriteRegData+0x4c>

00006d08 <GMSL_Ser_ReadRegData>:


u8  GMSL_Ser_ReadRegData(u16 reg)
{
    6d08:	fe010113          	addi	sp,sp,-32
    6d0c:	00112e23          	sw	ra,28(sp)
    6d10:	00812c23          	sw	s0,24(sp)
    6d14:	00912a23          	sw	s1,20(sp)
    6d18:	01212823          	sw	s2,16(sp)
    6d1c:	01312623          	sw	s3,12(sp)
    6d20:	00050493          	mv	s1,a0
	u8 outdata;

    i2c_masterStartBlocking(I2C_CTRL_MIPI);
    6d24:	f8017537          	lui	a0,0xf8017
    6d28:	cedff0ef          	jal	ra,6a14 <i2c_masterStartBlocking>
    6d2c:	f8017937          	lui	s2,0xf8017
    6d30:	00001437          	lui	s0,0x1
    6d34:	b8040793          	addi	a5,s0,-1152 # b80 <CUSTOM2+0xb25>
    6d38:	00f92023          	sw	a5,0(s2) # f8017000 <__freertos_irq_stack_top+0xf7fc33d0>

    i2c_txByte(I2C_CTRL_MIPI, GMSL_Ser_I2C_addr<<1);
	i2c_txNackBlocking(I2C_CTRL_MIPI);
    6d3c:	f8017537          	lui	a0,0xf8017
    6d40:	d4dff0ef          	jal	ra,6a8c <i2c_txNackBlocking>
	assert(i2c_rxAck(I2C_CTRL_MIPI)); // Optional check
    6d44:	f8017537          	lui	a0,0xf8017
    6d48:	d81ff0ef          	jal	ra,6ac8 <i2c_rxAck>
    6d4c:	f04fe0ef          	jal	ra,5450 <assert>

	i2c_txByte(I2C_CTRL_MIPI, (reg>>8) & 0xFF);
    6d50:	0084d793          	srli	a5,s1,0x8
    6d54:	b0040993          	addi	s3,s0,-1280
    6d58:	0137e7b3          	or	a5,a5,s3
    6d5c:	00f92023          	sw	a5,0(s2)
	i2c_txNackBlocking(I2C_CTRL_MIPI);
    6d60:	f8017537          	lui	a0,0xf8017
    6d64:	d29ff0ef          	jal	ra,6a8c <i2c_txNackBlocking>
	assert(i2c_rxAck(I2C_CTRL_MIPI)); // Optional check
    6d68:	f8017537          	lui	a0,0xf8017
    6d6c:	d5dff0ef          	jal	ra,6ac8 <i2c_rxAck>
    6d70:	ee0fe0ef          	jal	ra,5450 <assert>

	i2c_txByte(I2C_CTRL_MIPI, (reg) & 0xFF);
    6d74:	0ff4f493          	andi	s1,s1,255
    6d78:	0134e4b3          	or	s1,s1,s3
    6d7c:	00992023          	sw	s1,0(s2)
	i2c_txNackBlocking(I2C_CTRL_MIPI);
    6d80:	f8017537          	lui	a0,0xf8017
    6d84:	d09ff0ef          	jal	ra,6a8c <i2c_txNackBlocking>
	assert(i2c_rxAck(I2C_CTRL_MIPI)); // Optional check
    6d88:	f8017537          	lui	a0,0xf8017
    6d8c:	d3dff0ef          	jal	ra,6ac8 <i2c_rxAck>
    6d90:	ec0fe0ef          	jal	ra,5450 <assert>

	i2c_masterStopBlocking(I2C_CTRL_MIPI);
    6d94:	f8017537          	lui	a0,0xf8017
    6d98:	cc5ff0ef          	jal	ra,6a5c <i2c_masterStopBlocking>
	i2c_masterStartBlocking(I2C_CTRL_MIPI);
    6d9c:	f8017537          	lui	a0,0xf8017
    6da0:	c75ff0ef          	jal	ra,6a14 <i2c_masterStartBlocking>
    6da4:	b8140793          	addi	a5,s0,-1151
    6da8:	00f92023          	sw	a5,0(s2)

	i2c_txByte(I2C_CTRL_MIPI, (GMSL_Ser_I2C_addr<<1) | 0x01);
	i2c_txNackBlocking(I2C_CTRL_MIPI);
    6dac:	f8017537          	lui	a0,0xf8017
    6db0:	cddff0ef          	jal	ra,6a8c <i2c_txNackBlocking>
	assert(i2c_rxAck(I2C_CTRL_MIPI)); // Optional check
    6db4:	f8017537          	lui	a0,0xf8017
    6db8:	d11ff0ef          	jal	ra,6ac8 <i2c_rxAck>
    6dbc:	e94fe0ef          	jal	ra,5450 <assert>
    6dc0:	bff40413          	addi	s0,s0,-1025
    6dc4:	00892023          	sw	s0,0(s2)

	i2c_txByte(I2C_CTRL_MIPI, 0xFF);
	i2c_txNackBlocking(I2C_CTRL_MIPI);
    6dc8:	f8017537          	lui	a0,0xf8017
    6dcc:	cc1ff0ef          	jal	ra,6a8c <i2c_txNackBlocking>
	assert(i2c_rxNack(I2C_CTRL_MIPI)); // Optional check
    6dd0:	f8017537          	lui	a0,0xf8017
    6dd4:	ce5ff0ef          	jal	ra,6ab8 <i2c_rxNack>
    6dd8:	e78fe0ef          	jal	ra,5450 <assert>
	outdata = i2c_rxData(I2C_CTRL_MIPI);
    6ddc:	f8017537          	lui	a0,0xf8017
    6de0:	ccdff0ef          	jal	ra,6aac <i2c_rxData>
    6de4:	0ff57413          	andi	s0,a0,255

	i2c_masterStopBlocking(I2C_CTRL_MIPI);
    6de8:	f8017537          	lui	a0,0xf8017
    6dec:	c71ff0ef          	jal	ra,6a5c <i2c_masterStopBlocking>

	return outdata;
}
    6df0:	00040513          	mv	a0,s0
    6df4:	01c12083          	lw	ra,28(sp)
    6df8:	01812403          	lw	s0,24(sp)
    6dfc:	01412483          	lw	s1,20(sp)
    6e00:	01012903          	lw	s2,16(sp)
    6e04:	00c12983          	lw	s3,12(sp)
    6e08:	02010113          	addi	sp,sp,32
    6e0c:	00008067          	ret

00006e10 <GMSL_Des_ReadRegData>:

u8  GMSL_Des_ReadRegData(u16 reg)
{
    6e10:	fe010113          	addi	sp,sp,-32
    6e14:	00112e23          	sw	ra,28(sp)
    6e18:	00812c23          	sw	s0,24(sp)
    6e1c:	00912a23          	sw	s1,20(sp)
    6e20:	01212823          	sw	s2,16(sp)
    6e24:	01312623          	sw	s3,12(sp)
    6e28:	00050493          	mv	s1,a0
	u8 outdata;

    i2c_masterStartBlocking(I2C_CTRL_MIPI);
    6e2c:	f8017537          	lui	a0,0xf8017
    6e30:	be5ff0ef          	jal	ra,6a14 <i2c_masterStartBlocking>
    6e34:	f8017937          	lui	s2,0xf8017
    6e38:	00001437          	lui	s0,0x1
    6e3c:	b5040793          	addi	a5,s0,-1200 # b50 <CUSTOM2+0xaf5>
    6e40:	00f92023          	sw	a5,0(s2) # f8017000 <__freertos_irq_stack_top+0xf7fc33d0>

    i2c_txByte(I2C_CTRL_MIPI, GMSl_Des_I2C_addr<<1);
	i2c_txNackBlocking(I2C_CTRL_MIPI);
    6e44:	f8017537          	lui	a0,0xf8017
    6e48:	c45ff0ef          	jal	ra,6a8c <i2c_txNackBlocking>
	assert(i2c_rxAck(I2C_CTRL_MIPI)); // Optional check
    6e4c:	f8017537          	lui	a0,0xf8017
    6e50:	c79ff0ef          	jal	ra,6ac8 <i2c_rxAck>
    6e54:	dfcfe0ef          	jal	ra,5450 <assert>

	i2c_txByte(I2C_CTRL_MIPI, (reg>>8) & 0xFF);
    6e58:	0084d793          	srli	a5,s1,0x8
    6e5c:	b0040993          	addi	s3,s0,-1280
    6e60:	0137e7b3          	or	a5,a5,s3
    6e64:	00f92023          	sw	a5,0(s2)
	i2c_txNackBlocking(I2C_CTRL_MIPI);
    6e68:	f8017537          	lui	a0,0xf8017
    6e6c:	c21ff0ef          	jal	ra,6a8c <i2c_txNackBlocking>
	assert(i2c_rxAck(I2C_CTRL_MIPI)); // Optional check
    6e70:	f8017537          	lui	a0,0xf8017
    6e74:	c55ff0ef          	jal	ra,6ac8 <i2c_rxAck>
    6e78:	dd8fe0ef          	jal	ra,5450 <assert>

	i2c_txByte(I2C_CTRL_MIPI, (reg) & 0xFF);
    6e7c:	0ff4f493          	andi	s1,s1,255
    6e80:	0134e4b3          	or	s1,s1,s3
    6e84:	00992023          	sw	s1,0(s2)
	i2c_txNackBlocking(I2C_CTRL_MIPI);
    6e88:	f8017537          	lui	a0,0xf8017
    6e8c:	c01ff0ef          	jal	ra,6a8c <i2c_txNackBlocking>
	assert(i2c_rxAck(I2C_CTRL_MIPI)); // Optional check
    6e90:	f8017537          	lui	a0,0xf8017
    6e94:	c35ff0ef          	jal	ra,6ac8 <i2c_rxAck>
    6e98:	db8fe0ef          	jal	ra,5450 <assert>

	i2c_masterStopBlocking(I2C_CTRL_MIPI);
    6e9c:	f8017537          	lui	a0,0xf8017
    6ea0:	bbdff0ef          	jal	ra,6a5c <i2c_masterStopBlocking>
	i2c_masterStartBlocking(I2C_CTRL_MIPI);
    6ea4:	f8017537          	lui	a0,0xf8017
    6ea8:	b6dff0ef          	jal	ra,6a14 <i2c_masterStartBlocking>
    6eac:	b5140793          	addi	a5,s0,-1199
    6eb0:	00f92023          	sw	a5,0(s2)

	i2c_txByte(I2C_CTRL_MIPI, (GMSl_Des_I2C_addr<<1) | 0x01);
	i2c_txNackBlocking(I2C_CTRL_MIPI);
    6eb4:	f8017537          	lui	a0,0xf8017
    6eb8:	bd5ff0ef          	jal	ra,6a8c <i2c_txNackBlocking>
	assert(i2c_rxAck(I2C_CTRL_MIPI)); // Optional check
    6ebc:	f8017537          	lui	a0,0xf8017
    6ec0:	c09ff0ef          	jal	ra,6ac8 <i2c_rxAck>
    6ec4:	d8cfe0ef          	jal	ra,5450 <assert>
    6ec8:	bff40413          	addi	s0,s0,-1025
    6ecc:	00892023          	sw	s0,0(s2)

	i2c_txByte(I2C_CTRL_MIPI, 0xFF);
	i2c_txNackBlocking(I2C_CTRL_MIPI);
    6ed0:	f8017537          	lui	a0,0xf8017
    6ed4:	bb9ff0ef          	jal	ra,6a8c <i2c_txNackBlocking>
	assert(i2c_rxNack(I2C_CTRL_MIPI)); // Optional check
    6ed8:	f8017537          	lui	a0,0xf8017
    6edc:	bddff0ef          	jal	ra,6ab8 <i2c_rxNack>
    6ee0:	d70fe0ef          	jal	ra,5450 <assert>
	outdata = i2c_rxData(I2C_CTRL_MIPI);
    6ee4:	f8017537          	lui	a0,0xf8017
    6ee8:	bc5ff0ef          	jal	ra,6aac <i2c_rxData>
    6eec:	0ff57413          	andi	s0,a0,255

	i2c_masterStopBlocking(I2C_CTRL_MIPI);
    6ef0:	f8017537          	lui	a0,0xf8017
    6ef4:	b69ff0ef          	jal	ra,6a5c <i2c_masterStopBlocking>

	return outdata;
}
    6ef8:	00040513          	mv	a0,s0
    6efc:	01c12083          	lw	ra,28(sp)
    6f00:	01812403          	lw	s0,24(sp)
    6f04:	01412483          	lw	s1,20(sp)
    6f08:	01012903          	lw	s2,16(sp)
    6f0c:	00c12983          	lw	s3,12(sp)
    6f10:	02010113          	addi	sp,sp,32
    6f14:	00008067          	ret

00006f18 <GMSL_SerDes_init>:



int GMSL_SerDes_init(void)
{
    6f18:	ff010113          	addi	sp,sp,-16
    6f1c:	00112623          	sw	ra,12(sp)
    6f20:	00812423          	sw	s0,8(sp)


	// GMSL_Des_WriteRegData(REG_GMSL_DES_MIPI_TX0_TX10, 0x50);      //On Serializer side, Set Mipi CSI-2 Interface to 2Lanes


   if (GMSL_Ser_WriteRegData(REG_GMSL_SER_GPIO_2_A, 0x80) )   //On Serializer side, set Sensor Enable Pin to Low
    6f24:	08000593          	li	a1,128
    6f28:	2c400513          	li	a0,708
    6f2c:	badff0ef          	jal	ra,6ad8 <GMSL_Ser_WriteRegData>
    6f30:	00050e63          	beqz	a0,6f4c <GMSL_SerDes_init+0x34>
	   return 1;
    6f34:	00100413          	li	s0,1


   bsp_uDelay(50000);

   return 0;
}
    6f38:	00040513          	mv	a0,s0
    6f3c:	00c12083          	lw	ra,12(sp)
    6f40:	00812403          	lw	s0,8(sp)
    6f44:	01010113          	addi	sp,sp,16
    6f48:	00008067          	ret
   bsp_uDelay(50000);
    6f4c:	f8b00637          	lui	a2,0xf8b00
    6f50:	05f5e5b7          	lui	a1,0x5f5e
    6f54:	10058593          	addi	a1,a1,256 # 5f5e100 <__freertos_irq_stack_top+0x5f0a4d0>
    6f58:	0000c537          	lui	a0,0xc
    6f5c:	35050513          	addi	a0,a0,848 # c350 <raw_table4+0x2830>
    6f60:	a75ff0ef          	jal	ra,69d4 <clint_uDelay>
  GMSL_Ser_WriteRegData(REG_GMSL_SER_MIPI_RX_1, 0x10);      //On Serializer side, Set Mipi CSI-2 Interface to 2Lanes
    6f64:	01000593          	li	a1,16
    6f68:	33100513          	li	a0,817
    6f6c:	b6dff0ef          	jal	ra,6ad8 <GMSL_Ser_WriteRegData>
   GMSL_Des_WriteRegData(REG_GMSL_DES_MIPI_TX0_TX10, 0x50);      //On Serializer side, Set Mipi CSI-2 Interface to 2Lanes
    6f70:	05000593          	li	a1,80
    6f74:	40a00513          	li	a0,1034
    6f78:	c79ff0ef          	jal	ra,6bf0 <GMSL_Des_WriteRegData>
   GMSL_Des_WriteRegData(REG_GMSL_DES_MIPI_TX1_TX10, 0x50);      //On Serializer side, Set Mipi CSI-2 Interface to 2Lanes
    6f7c:	05000593          	li	a1,80
    6f80:	44a00513          	li	a0,1098
    6f84:	c6dff0ef          	jal	ra,6bf0 <GMSL_Des_WriteRegData>
   GMSL_Des_WriteRegData(REG_GMSL_DES_MIPI_TX2_TX10, 0x50);      //On Serializer side, Set Mipi CSI-2 Interface to 2Lanes
    6f88:	05000593          	li	a1,80
    6f8c:	48a00513          	li	a0,1162
    6f90:	c61ff0ef          	jal	ra,6bf0 <GMSL_Des_WriteRegData>
   GMSL_Des_WriteRegData(REG_GMSL_DES_BACKTOP25, 0x39); 		//Phy1 2500Mbps
    6f94:	03900593          	li	a1,57
    6f98:	32000513          	li	a0,800
    6f9c:	c55ff0ef          	jal	ra,6bf0 <GMSL_Des_WriteRegData>
   GMSL_Des_WriteRegData(REG_GMSL_DES_BACKTOP28, 0x39);         //Phy2 2500Mbps
    6fa0:	03900593          	li	a1,57
    6fa4:	32300513          	li	a0,803
    6fa8:	c49ff0ef          	jal	ra,6bf0 <GMSL_Des_WriteRegData>
   if (GMSL_Ser_WriteRegData(REG_GMSL_SER_GPIO_2_A, 0x90) )   //On Serializer side, Set Sensor Enable Pin to High
    6fac:	09000593          	li	a1,144
    6fb0:	2c400513          	li	a0,708
    6fb4:	b25ff0ef          	jal	ra,6ad8 <GMSL_Ser_WriteRegData>
    6fb8:	00050413          	mv	s0,a0
    6fbc:	00050663          	beqz	a0,6fc8 <GMSL_SerDes_init+0xb0>
   	   return 1;
    6fc0:	00100413          	li	s0,1
    6fc4:	f75ff06f          	j	6f38 <GMSL_SerDes_init+0x20>
   bsp_uDelay(50000);
    6fc8:	f8b00637          	lui	a2,0xf8b00
    6fcc:	05f5e5b7          	lui	a1,0x5f5e
    6fd0:	10058593          	addi	a1,a1,256 # 5f5e100 <__freertos_irq_stack_top+0x5f0a4d0>
    6fd4:	0000c537          	lui	a0,0xc
    6fd8:	35050513          	addi	a0,a0,848 # c350 <raw_table4+0x2830>
    6fdc:	9f9ff0ef          	jal	ra,69d4 <clint_uDelay>
   return 0;
    6fe0:	f59ff06f          	j	6f38 <GMSL_SerDes_init+0x20>

00006fe4 <uart_writeAvailability>:
        return *((volatile u32*) address);
    6fe4:	00452503          	lw	a0,4(a0)
        return (read_u32(reg + UART_STATUS) >> 16) & 0xFF;
    6fe8:	01055513          	srli	a0,a0,0x10
    }
    6fec:	0ff57513          	andi	a0,a0,255
    6ff0:	00008067          	ret

00006ff4 <uart_write>:
    static void uart_write(u32 reg, char data){
    6ff4:	ff010113          	addi	sp,sp,-16
    6ff8:	00112623          	sw	ra,12(sp)
    6ffc:	00812423          	sw	s0,8(sp)
    7000:	00912223          	sw	s1,4(sp)
    7004:	00050413          	mv	s0,a0
    7008:	00058493          	mv	s1,a1
        while(uart_writeAvailability(reg) == 0);
    700c:	00040513          	mv	a0,s0
    7010:	fd5ff0ef          	jal	ra,6fe4 <uart_writeAvailability>
    7014:	fe050ce3          	beqz	a0,700c <uart_write+0x18>
        *((volatile u32*) address) = data;
    7018:	00942023          	sw	s1,0(s0)
    }
    701c:	00c12083          	lw	ra,12(sp)
    7020:	00812403          	lw	s0,8(sp)
    7024:	00412483          	lw	s1,4(sp)
    7028:	01010113          	addi	sp,sp,16
    702c:	00008067          	ret

00007030 <_putchar>:
    static void _putchar(char character){
    7030:	ff010113          	addi	sp,sp,-16
    7034:	00112623          	sw	ra,12(sp)
            bsp_putChar(character);
    7038:	00050593          	mv	a1,a0
    703c:	f8010537          	lui	a0,0xf8010
    7040:	fb5ff0ef          	jal	ra,6ff4 <uart_write>
    }
    7044:	00c12083          	lw	ra,12(sp)
    7048:	01010113          	addi	sp,sp,16
    704c:	00008067          	ret

00007050 <_putchar_s>:
    {
    7050:	ff010113          	addi	sp,sp,-16
    7054:	00112623          	sw	ra,12(sp)
    7058:	00812423          	sw	s0,8(sp)
    705c:	00050413          	mv	s0,a0
        while (*p)
    7060:	00044503          	lbu	a0,0(s0)
    7064:	00050863          	beqz	a0,7074 <_putchar_s+0x24>
            _putchar(*(p++));
    7068:	00140413          	addi	s0,s0,1
    706c:	fc5ff0ef          	jal	ra,7030 <_putchar>
    7070:	ff1ff06f          	j	7060 <_putchar_s+0x10>
    }
    7074:	00c12083          	lw	ra,12(sp)
    7078:	00812403          	lw	s0,8(sp)
    707c:	01010113          	addi	sp,sp,16
    7080:	00008067          	ret

00007084 <bsp_printHex>:
    {
    7084:	ff010113          	addi	sp,sp,-16
    7088:	00112623          	sw	ra,12(sp)
    708c:	00812423          	sw	s0,8(sp)
    7090:	00912223          	sw	s1,4(sp)
    7094:	00050493          	mv	s1,a0
        for (int i = (4*digits)-4; i >= 0; i -= 4) {
    7098:	01c00413          	li	s0,28
    709c:	0240006f          	j	70c0 <bsp_printHex+0x3c>
            _putchar("0123456789ABCDEF"[(val >> i) % 16]);
    70a0:	0084d7b3          	srl	a5,s1,s0
    70a4:	00f7f713          	andi	a4,a5,15
    70a8:	000097b7          	lui	a5,0x9
    70ac:	b0c78793          	addi	a5,a5,-1268 # 8b0c <_data+0x64>
    70b0:	00e787b3          	add	a5,a5,a4
    70b4:	0007c503          	lbu	a0,0(a5)
    70b8:	f79ff0ef          	jal	ra,7030 <_putchar>
        for (int i = (4*digits)-4; i >= 0; i -= 4) {
    70bc:	ffc40413          	addi	s0,s0,-4
    70c0:	fe0450e3          	bgez	s0,70a0 <bsp_printHex+0x1c>
    }
    70c4:	00c12083          	lw	ra,12(sp)
    70c8:	00812403          	lw	s0,8(sp)
    70cc:	00412483          	lw	s1,4(sp)
    70d0:	01010113          	addi	sp,sp,16
    70d4:	00008067          	ret

000070d8 <bsp_printHex_lower>:
    {
    70d8:	ff010113          	addi	sp,sp,-16
    70dc:	00112623          	sw	ra,12(sp)
    70e0:	00812423          	sw	s0,8(sp)
    70e4:	00912223          	sw	s1,4(sp)
    70e8:	00050493          	mv	s1,a0
        for (int i = (4*digits)-4; i >= 0; i -= 4) {
    70ec:	01c00413          	li	s0,28
    70f0:	0240006f          	j	7114 <bsp_printHex_lower+0x3c>
            _putchar("0123456789abcdef"[(val >> i) % 16]);
    70f4:	0084d7b3          	srl	a5,s1,s0
    70f8:	00f7f713          	andi	a4,a5,15
    70fc:	000097b7          	lui	a5,0x9
    7100:	b7478793          	addi	a5,a5,-1164 # 8b74 <_data+0xcc>
    7104:	00e787b3          	add	a5,a5,a4
    7108:	0007c503          	lbu	a0,0(a5)
    710c:	f25ff0ef          	jal	ra,7030 <_putchar>
        for (int i = (4*digits)-4; i >= 0; i -= 4) {
    7110:	ffc40413          	addi	s0,s0,-4
    7114:	fe0450e3          	bgez	s0,70f4 <bsp_printHex_lower+0x1c>
    }
    7118:	00c12083          	lw	ra,12(sp)
    711c:	00812403          	lw	s0,8(sp)
    7120:	00412483          	lw	s1,4(sp)
    7124:	01010113          	addi	sp,sp,16
    7128:	00008067          	ret

0000712c <bsp_printf_c>:
    {
    712c:	ff010113          	addi	sp,sp,-16
    7130:	00112623          	sw	ra,12(sp)
        _putchar(c);
    7134:	0ff57513          	andi	a0,a0,255
    7138:	ef9ff0ef          	jal	ra,7030 <_putchar>
    }
    713c:	00c12083          	lw	ra,12(sp)
    7140:	01010113          	addi	sp,sp,16
    7144:	00008067          	ret

00007148 <bsp_printf_s>:
    {
    7148:	ff010113          	addi	sp,sp,-16
    714c:	00112623          	sw	ra,12(sp)
        _putchar_s(p);
    7150:	f01ff0ef          	jal	ra,7050 <_putchar_s>
    }
    7154:	00c12083          	lw	ra,12(sp)
    7158:	01010113          	addi	sp,sp,16
    715c:	00008067          	ret

00007160 <bsp_printf_d>:
    {
    7160:	fd010113          	addi	sp,sp,-48
    7164:	02112623          	sw	ra,44(sp)
    7168:	02812423          	sw	s0,40(sp)
    716c:	02912223          	sw	s1,36(sp)
    7170:	00050493          	mv	s1,a0
        if (val < 0) {
    7174:	00054663          	bltz	a0,7180 <bsp_printf_d+0x20>
    {
    7178:	00010413          	mv	s0,sp
    717c:	02c0006f          	j	71a8 <bsp_printf_d+0x48>
            bsp_printf_c('-');
    7180:	02d00513          	li	a0,45
    7184:	fa9ff0ef          	jal	ra,712c <bsp_printf_c>
            val = -val;
    7188:	409004b3          	neg	s1,s1
    718c:	fedff06f          	j	7178 <bsp_printf_d+0x18>
            *(p++) = '0' + val % 10;
    7190:	00a00713          	li	a4,10
    7194:	02e4e7b3          	rem	a5,s1,a4
    7198:	03078793          	addi	a5,a5,48
    719c:	00f40023          	sb	a5,0(s0)
            val = val / 10;
    71a0:	02e4c4b3          	div	s1,s1,a4
            *(p++) = '0' + val % 10;
    71a4:	00140413          	addi	s0,s0,1
        while (val || p == buffer) {
    71a8:	fe0494e3          	bnez	s1,7190 <bsp_printf_d+0x30>
    71ac:	00010793          	mv	a5,sp
    71b0:	fef400e3          	beq	s0,a5,7190 <bsp_printf_d+0x30>
    71b4:	0100006f          	j	71c4 <bsp_printf_d+0x64>
            bsp_printf_c(*(--p));
    71b8:	fff40413          	addi	s0,s0,-1
    71bc:	00044503          	lbu	a0,0(s0)
    71c0:	f6dff0ef          	jal	ra,712c <bsp_printf_c>
        while (p != buffer)
    71c4:	00010793          	mv	a5,sp
    71c8:	fef418e3          	bne	s0,a5,71b8 <bsp_printf_d+0x58>
    }
    71cc:	02c12083          	lw	ra,44(sp)
    71d0:	02812403          	lw	s0,40(sp)
    71d4:	02412483          	lw	s1,36(sp)
    71d8:	03010113          	addi	sp,sp,48
    71dc:	00008067          	ret

000071e0 <bsp_printf_x>:
    {
    71e0:	ff010113          	addi	sp,sp,-16
    71e4:	00112623          	sw	ra,12(sp)
        for(i=0;i<8;i++)
    71e8:	00000713          	li	a4,0
    71ec:	00700793          	li	a5,7
    71f0:	02e7c063          	blt	a5,a4,7210 <bsp_printf_x+0x30>
            if((val & (0xFFFFFFF0 <<(4*i))) == 0)
    71f4:	00271693          	slli	a3,a4,0x2
    71f8:	ff000793          	li	a5,-16
    71fc:	00d797b3          	sll	a5,a5,a3
    7200:	00f577b3          	and	a5,a0,a5
    7204:	00078663          	beqz	a5,7210 <bsp_printf_x+0x30>
        for(i=0;i<8;i++)
    7208:	00170713          	addi	a4,a4,1
    720c:	fe1ff06f          	j	71ec <bsp_printf_x+0xc>
        bsp_printHex_lower(val);
    7210:	ec9ff0ef          	jal	ra,70d8 <bsp_printHex_lower>
    }
    7214:	00c12083          	lw	ra,12(sp)
    7218:	01010113          	addi	sp,sp,16
    721c:	00008067          	ret

00007220 <bsp_printf_X>:
        {
    7220:	ff010113          	addi	sp,sp,-16
    7224:	00112623          	sw	ra,12(sp)
            for(i=0;i<8;i++)
    7228:	00000713          	li	a4,0
    722c:	00700793          	li	a5,7
    7230:	02e7c063          	blt	a5,a4,7250 <bsp_printf_X+0x30>
                if((val & (0xFFFFFFF0 <<(4*i))) == 0)
    7234:	00271693          	slli	a3,a4,0x2
    7238:	ff000793          	li	a5,-16
    723c:	00d797b3          	sll	a5,a5,a3
    7240:	00f577b3          	and	a5,a0,a5
    7244:	00078663          	beqz	a5,7250 <bsp_printf_X+0x30>
            for(i=0;i<8;i++)
    7248:	00170713          	addi	a4,a4,1
    724c:	fe1ff06f          	j	722c <bsp_printf_X+0xc>
            bsp_printHex(val);
    7250:	e35ff0ef          	jal	ra,7084 <bsp_printHex>
        }
    7254:	00c12083          	lw	ra,12(sp)
    7258:	01010113          	addi	sp,sp,16
    725c:	00008067          	ret

00007260 <dmasg_input_memory>:
        u32 ca = dmasg_ca(base, channel);
    7260:	00759593          	slli	a1,a1,0x7
    7264:	00a58533          	add	a0,a1,a0
    7268:	00c52023          	sw	a2,0(a0) # f8010000 <__freertos_irq_stack_top+0xf7fbc3d0>
        write_u32(DMASG_CHANNEL_INPUT_CONFIG_MEMORY | (byte_per_burst-1 & 0xFFF), ca + DMASG_CHANNEL_INPUT_CONFIG);
    726c:	fff68693          	addi	a3,a3,-1
    7270:	000017b7          	lui	a5,0x1
    7274:	fff78713          	addi	a4,a5,-1 # fff <CUSTOM2+0xfa4>
    7278:	00e6f6b3          	and	a3,a3,a4
    727c:	00f6e6b3          	or	a3,a3,a5
    7280:	00d52623          	sw	a3,12(a0)
    }
    7284:	00008067          	ret

00007288 <dmasg_output_memory>:
        u32 ca = dmasg_ca(base, channel);
    7288:	00759593          	slli	a1,a1,0x7
    728c:	00a58533          	add	a0,a1,a0
    7290:	00c52823          	sw	a2,16(a0)
        write_u32(DMASG_CHANNEL_OUTPUT_CONFIG_MEMORY | (byte_per_burst-1 & 0xFFF), ca + DMASG_CHANNEL_OUTPUT_CONFIG);
    7294:	fff68693          	addi	a3,a3,-1
    7298:	000017b7          	lui	a5,0x1
    729c:	fff78713          	addi	a4,a5,-1 # fff <CUSTOM2+0xfa4>
    72a0:	00e6f6b3          	and	a3,a3,a4
    72a4:	00f6e6b3          	or	a3,a3,a5
    72a8:	00d52e23          	sw	a3,28(a0)
    }
    72ac:	00008067          	ret

000072b0 <dmasg_input_stream>:
        u32 ca = dmasg_ca(base, channel);
    72b0:	00759593          	slli	a1,a1,0x7
    72b4:	00a58533          	add	a0,a1,a0
    72b8:	00c52423          	sw	a2,8(a0)
        write_u32(DMASG_CHANNEL_INPUT_CONFIG_STREAM | (completion_on_packet ? DMASG_CHANNEL_INPUT_CONFIG_COMPLETION_ON_PACKET : 0) | (wait_on_packet ? DMASG_CHANNEL_INPUT_CONFIG_WAIT_ON_PACKET : 0), ca + DMASG_CHANNEL_INPUT_CONFIG);
    72bc:	00070e63          	beqz	a4,72d8 <dmasg_input_stream+0x28>
    72c0:	000027b7          	lui	a5,0x2
    72c4:	00068e63          	beqz	a3,72e0 <dmasg_input_stream+0x30>
    72c8:	00004737          	lui	a4,0x4
    72cc:	00e7e7b3          	or	a5,a5,a4
    72d0:	00f52623          	sw	a5,12(a0)
    }
    72d4:	00008067          	ret
        write_u32(DMASG_CHANNEL_INPUT_CONFIG_STREAM | (completion_on_packet ? DMASG_CHANNEL_INPUT_CONFIG_COMPLETION_ON_PACKET : 0) | (wait_on_packet ? DMASG_CHANNEL_INPUT_CONFIG_WAIT_ON_PACKET : 0), ca + DMASG_CHANNEL_INPUT_CONFIG);
    72d8:	00000793          	li	a5,0
    72dc:	fe9ff06f          	j	72c4 <dmasg_input_stream+0x14>
    72e0:	00000713          	li	a4,0
    72e4:	fe9ff06f          	j	72cc <dmasg_input_stream+0x1c>

000072e8 <dmasg_output_stream>:
        u32 ca = dmasg_ca(base, channel);
    72e8:	00759593          	slli	a1,a1,0x7
    72ec:	00a58533          	add	a0,a1,a0
        write_u32(port << 0 | source << 8 | sink << 16, ca + DMASG_CHANNEL_OUTPUT_STREAM);
    72f0:	00869693          	slli	a3,a3,0x8
    72f4:	00c6e6b3          	or	a3,a3,a2
    72f8:	01071713          	slli	a4,a4,0x10
    72fc:	00e6e6b3          	or	a3,a3,a4
    7300:	00d52c23          	sw	a3,24(a0)
        write_u32(DMASG_CHANNEL_OUTPUT_CONFIG_STREAM | (last ? DMASG_CHANNEL_OUTPUT_CONFIG_LAST : 0), ca + DMASG_CHANNEL_OUTPUT_CONFIG);
    7304:	00078463          	beqz	a5,730c <dmasg_output_stream+0x24>
    7308:	000027b7          	lui	a5,0x2
    730c:	00f52e23          	sw	a5,28(a0)
    }
    7310:	00008067          	ret

00007314 <dmasg_direct_start>:
        u32 ca = dmasg_ca(base, channel);
    7314:	00759593          	slli	a1,a1,0x7
    7318:	00a58533          	add	a0,a1,a0
        write_u32(bytes-1, ca + DMASG_CHANNEL_DIRECT_BYTES);
    731c:	fff60613          	addi	a2,a2,-1 # f8afffff <__freertos_irq_stack_top+0xf8aac3cf>
    7320:	02c52023          	sw	a2,32(a0)
        write_u32(DMASG_CHANNEL_STATUS_DIRECT_START | (self_restart ? DMASG_CHANNEL_STATUS_SELF_RESTART : 0), ca + DMASG_CHANNEL_STATUS);
    7324:	00068863          	beqz	a3,7334 <dmasg_direct_start+0x20>
    7328:	00300793          	li	a5,3
    732c:	02f52623          	sw	a5,44(a0)
    }
    7330:	00008067          	ret
        write_u32(DMASG_CHANNEL_STATUS_DIRECT_START | (self_restart ? DMASG_CHANNEL_STATUS_SELF_RESTART : 0), ca + DMASG_CHANNEL_STATUS);
    7334:	00100793          	li	a5,1
    7338:	ff5ff06f          	j	732c <dmasg_direct_start+0x18>

0000733c <dmasg_linked_list_start>:
        u32 ca = dmasg_ca(base, channel);
    733c:	00759593          	slli	a1,a1,0x7
    7340:	00a58533          	add	a0,a1,a0
    7344:	06c52823          	sw	a2,112(a0)
    7348:	06052c23          	sw	zero,120(a0)
    734c:	01000793          	li	a5,16
    7350:	02f52623          	sw	a5,44(a0)
    }
    7354:	00008067          	ret

00007358 <dmasg_linked_list_sg_start>:
        u32 ca = dmasg_ca(base, channel);
    7358:	00759593          	slli	a1,a1,0x7
    735c:	00a58533          	add	a0,a1,a0
    7360:	00100793          	li	a5,1
    7364:	06f52c23          	sw	a5,120(a0)
    7368:	01000793          	li	a5,16
    736c:	02f52623          	sw	a5,44(a0)
    }
    7370:	00008067          	ret

00007374 <dmasg_stop>:
        u32 ca = dmasg_ca(base, channel);
    7374:	00759593          	slli	a1,a1,0x7
    7378:	00a585b3          	add	a1,a1,a0
    737c:	00400793          	li	a5,4
    7380:	02f5a623          	sw	a5,44(a1)
    }
    7384:	00008067          	ret

00007388 <dmasg_interrupt_config>:
        u32 ca = dmasg_ca(base, channel);
    7388:	00759593          	slli	a1,a1,0x7
    738c:	00a58533          	add	a0,a1,a0
    7390:	fff00793          	li	a5,-1
    7394:	04f52a23          	sw	a5,84(a0)
    7398:	04c52823          	sw	a2,80(a0)
    }
    739c:	00008067          	ret

000073a0 <dmasg_busy>:
        u32 ca = dmasg_ca(base, channel);
    73a0:	00759593          	slli	a1,a1,0x7
    73a4:	00a585b3          	add	a1,a1,a0
        return *((volatile u32*) address);
    73a8:	02c5a503          	lw	a0,44(a1)
    }
    73ac:	00157513          	andi	a0,a0,1
    73b0:	00008067          	ret

000073b4 <i2c_applyConfig>:
        write_u32(config->samplingClockDivider, reg + I2C_SAMPLING_CLOCK_DIVIDER);
    73b4:	0005a783          	lw	a5,0(a1)
        *((volatile u32*) address) = data;
    73b8:	02f52423          	sw	a5,40(a0)
        write_u32(config->timeout, reg + I2C_TIMEOUT);
    73bc:	0045a783          	lw	a5,4(a1)
    73c0:	02f52623          	sw	a5,44(a0)
        write_u32(config->tsuDat, reg + I2C_TSUDAT);
    73c4:	0085a783          	lw	a5,8(a1)
    73c8:	02f52823          	sw	a5,48(a0)
        write_u32(config->tLow, reg + I2C_TLOW);
    73cc:	00c5a783          	lw	a5,12(a1)
    73d0:	04f52823          	sw	a5,80(a0)
        write_u32(config->tHigh, reg + I2C_THIGH);
    73d4:	0105a783          	lw	a5,16(a1)
    73d8:	04f52a23          	sw	a5,84(a0)
        write_u32(config->tBuf, reg + I2C_TBUF);
    73dc:	0145a783          	lw	a5,20(a1)
    73e0:	04f52c23          	sw	a5,88(a0)
    }
    73e4:	00008067          	ret

000073e8 <bsp_printf>:
    {
    73e8:	fc010113          	addi	sp,sp,-64
    73ec:	00112e23          	sw	ra,28(sp)
    73f0:	00812c23          	sw	s0,24(sp)
    73f4:	00912a23          	sw	s1,20(sp)
    73f8:	00050493          	mv	s1,a0
    73fc:	02b12223          	sw	a1,36(sp)
    7400:	02c12423          	sw	a2,40(sp)
    7404:	02d12623          	sw	a3,44(sp)
    7408:	02e12823          	sw	a4,48(sp)
    740c:	02f12a23          	sw	a5,52(sp)
    7410:	03012c23          	sw	a6,56(sp)
    7414:	03112e23          	sw	a7,60(sp)
        va_start(ap, format);
    7418:	02410793          	addi	a5,sp,36
    741c:	00f12623          	sw	a5,12(sp)
        for (i = 0; format[i]; i++)
    7420:	00000413          	li	s0,0
    7424:	01c0006f          	j	7440 <bsp_printf+0x58>
                        bsp_printf_c(va_arg(ap,int));
    7428:	00c12783          	lw	a5,12(sp)
    742c:	00478713          	addi	a4,a5,4 # 2004 <_reclaim_reent+0x34>
    7430:	00e12623          	sw	a4,12(sp)
    7434:	0007a503          	lw	a0,0(a5)
    7438:	cf5ff0ef          	jal	ra,712c <bsp_printf_c>
        for (i = 0; format[i]; i++)
    743c:	00140413          	addi	s0,s0,1
    7440:	008487b3          	add	a5,s1,s0
    7444:	0007c503          	lbu	a0,0(a5)
    7448:	0c050263          	beqz	a0,750c <bsp_printf+0x124>
            if (format[i] == '%') {
    744c:	02500793          	li	a5,37
    7450:	06f50663          	beq	a0,a5,74bc <bsp_printf+0xd4>
                bsp_printf_c(format[i]);
    7454:	cd9ff0ef          	jal	ra,712c <bsp_printf_c>
    7458:	fe5ff06f          	j	743c <bsp_printf+0x54>
                        bsp_printf_s(va_arg(ap,char*));
    745c:	00c12783          	lw	a5,12(sp)
    7460:	00478713          	addi	a4,a5,4
    7464:	00e12623          	sw	a4,12(sp)
    7468:	0007a503          	lw	a0,0(a5)
    746c:	cddff0ef          	jal	ra,7148 <bsp_printf_s>
                        break;
    7470:	fcdff06f          	j	743c <bsp_printf+0x54>
                        bsp_printf_d(va_arg(ap,int));
    7474:	00c12783          	lw	a5,12(sp)
    7478:	00478713          	addi	a4,a5,4
    747c:	00e12623          	sw	a4,12(sp)
    7480:	0007a503          	lw	a0,0(a5)
    7484:	cddff0ef          	jal	ra,7160 <bsp_printf_d>
                        break;
    7488:	fb5ff06f          	j	743c <bsp_printf+0x54>
                        bsp_printf_X(va_arg(ap,int));
    748c:	00c12783          	lw	a5,12(sp)
    7490:	00478713          	addi	a4,a5,4
    7494:	00e12623          	sw	a4,12(sp)
    7498:	0007a503          	lw	a0,0(a5)
    749c:	d85ff0ef          	jal	ra,7220 <bsp_printf_X>
                        break;
    74a0:	f9dff06f          	j	743c <bsp_printf+0x54>
                        bsp_printf_x(va_arg(ap,int));
    74a4:	00c12783          	lw	a5,12(sp)
    74a8:	00478713          	addi	a4,a5,4
    74ac:	00e12623          	sw	a4,12(sp)
    74b0:	0007a503          	lw	a0,0(a5)
    74b4:	d2dff0ef          	jal	ra,71e0 <bsp_printf_x>
                        break;
    74b8:	f85ff06f          	j	743c <bsp_printf+0x54>
                while (format[++i]) {
    74bc:	00140413          	addi	s0,s0,1
    74c0:	008487b3          	add	a5,s1,s0
    74c4:	0007c783          	lbu	a5,0(a5)
    74c8:	f6078ae3          	beqz	a5,743c <bsp_printf+0x54>
                    if (format[i] == 'c') {
    74cc:	06300713          	li	a4,99
    74d0:	f4e78ce3          	beq	a5,a4,7428 <bsp_printf+0x40>
                    else if (format[i] == 's') {
    74d4:	07300713          	li	a4,115
    74d8:	f8e782e3          	beq	a5,a4,745c <bsp_printf+0x74>
                    else if (format[i] == 'd') {
    74dc:	06400713          	li	a4,100
    74e0:	f8e78ae3          	beq	a5,a4,7474 <bsp_printf+0x8c>
                    else if (format[i] == 'X') {
    74e4:	05800713          	li	a4,88
    74e8:	fae782e3          	beq	a5,a4,748c <bsp_printf+0xa4>
                    else if (format[i] == 'x') {
    74ec:	07800713          	li	a4,120
    74f0:	fae78ae3          	beq	a5,a4,74a4 <bsp_printf+0xbc>
                    else if (format[i] == 'f') {
    74f4:	06600713          	li	a4,102
    74f8:	fce792e3          	bne	a5,a4,74bc <bsp_printf+0xd4>
                        bsp_printf_s("<Floating point printing not enable. Please Enable it at bsp.h first...>");
    74fc:	00009537          	lui	a0,0x9
    7500:	b8850513          	addi	a0,a0,-1144 # 8b88 <_data+0xe0>
    7504:	c45ff0ef          	jal	ra,7148 <bsp_printf_s>
                        break;
    7508:	f35ff06f          	j	743c <bsp_printf+0x54>
    }
    750c:	01c12083          	lw	ra,28(sp)
    7510:	01812403          	lw	s0,24(sp)
    7514:	01412483          	lw	s1,20(sp)
    7518:	04010113          	addi	sp,sp,64
    751c:	00008067          	ret

00007520 <framebuffer_loadTable>:
{
	int j;
	int XCount =0;
	int YCouut =0;
	int lineSize = FRAME_SIZE/1080;
	int XPtr1 =start_x /4;
    7520:	0025d313          	srli	t1,a1,0x2
	int XPtr4 =end_x /4;
    7524:	00265e93          	srli	t4,a2,0x2


	int YPtr1 =start_y ;
    7528:	00068813          	mv	a6,a3
	int YPtr4 =end_y ;
    752c:	00070893          	mv	a7,a4


	int tableSize_x = (end_x - start_x)/4;
    7530:	40b60633          	sub	a2,a2,a1
    7534:	00265293          	srli	t0,a2,0x2
	int tableSize_y = (end_y - start_y);
    7538:	40d70fb3          	sub	t6,a4,a3


    const u32 (*raw_table1_ptr)[93];


    switch (TableIndex)
    753c:	00200713          	li	a4,2
    7540:	06e78263          	beq	a5,a4,75a4 <framebuffer_loadTable+0x84>
    7544:	02f77063          	bgeu	a4,a5,7564 <framebuffer_loadTable+0x44>
    7548:	00300713          	li	a4,3
    754c:	06e78263          	beq	a5,a4,75b0 <framebuffer_loadTable+0x90>
    7550:	00400713          	li	a4,4
    7554:	04e79263          	bne	a5,a4,7598 <framebuffer_loadTable+0x78>
    {
    	case 0: raw_table1_ptr = raw_table;		break;
       	case 1: raw_table1_ptr = raw_table1;		break;
       	case 2: raw_table1_ptr = raw_table2;		break;
       	case 3: raw_table1_ptr = raw_table3;		break;
     	case 4: raw_table1_ptr = raw_table4;		break;
    7558:	0000af37          	lui	t5,0xa
    755c:	b20f0f13          	addi	t5,t5,-1248 # 9b20 <raw_table4>
    7560:	0200006f          	j	7580 <framebuffer_loadTable+0x60>
    switch (TableIndex)
    7564:	00100713          	li	a4,1
    7568:	00e79863          	bne	a5,a4,7578 <framebuffer_loadTable+0x58>
       	case 1: raw_table1_ptr = raw_table1;		break;
    756c:	00035f37          	lui	t5,0x35
    7570:	be8f0f13          	addi	t5,t5,-1048 # 34be8 <raw_table1>
    7574:	00c0006f          	j	7580 <framebuffer_loadTable+0x60>
    	case 0: raw_table1_ptr = raw_table;		break;
    7578:	00043f37          	lui	t5,0x43
    757c:	180f0f13          	addi	t5,t5,384 # 43180 <raw_table>
    int tablePtr_y =0;
    7580:	00000e13          	li	t3,0
	int tablePtr_x =0;
    7584:	00000593          	li	a1,0
	int YCouut =0;
    7588:	00000613          	li	a2,0
	int XCount =0;
    758c:	00000713          	li	a4,0
       	default: raw_table1_ptr = raw_table;		break;

    }
 //   raw_table1_ptr = raw_table;

    for(j=0;j<(FRAME_SIZE*1);j++){
    7590:	00000693          	li	a3,0
    7594:	0600006f          	j	75f4 <framebuffer_loadTable+0xd4>
    	case 0: raw_table1_ptr = raw_table;		break;
    7598:	00043f37          	lui	t5,0x43
    759c:	180f0f13          	addi	t5,t5,384 # 43180 <raw_table>
    75a0:	fe1ff06f          	j	7580 <framebuffer_loadTable+0x60>
       	case 2: raw_table1_ptr = raw_table2;		break;
    75a4:	00026f37          	lui	t5,0x26
    75a8:	650f0f13          	addi	t5,t5,1616 # 26650 <raw_table2>
    75ac:	fd5ff06f          	j	7580 <framebuffer_loadTable+0x60>
       	case 3: raw_table1_ptr = raw_table3;		break;
    75b0:	00018f37          	lui	t5,0x18
    75b4:	0b8f0f13          	addi	t5,t5,184 # 180b8 <raw_table3>
    75b8:	fc9ff06f          	j	7580 <framebuffer_loadTable+0x60>

    		 XCount ++;
    		 if( XCount == lineSize )
    		 {
    			// bsp_printf("%d\n\r",XCount );
    			 if ( (YCouut >= YPtr1 ) && (YCouut <= YPtr4 ) )
    75bc:	01064663          	blt	a2,a6,75c8 <framebuffer_loadTable+0xa8>
    75c0:	00c8c463          	blt	a7,a2,75c8 <framebuffer_loadTable+0xa8>
    			 {
    				 tablePtr_y++;
    75c4:	001e0e13          	addi	t3,t3,1

    			 }
    			 tablePtr_x =0;

    			 XCount = 0;
    			 YCouut++;
    75c8:	00160613          	addi	a2,a2,1
    			 tablePtr_x =0;
    75cc:	00000593          	li	a1,0
    			 XCount = 0;
    75d0:	00000713          	li	a4,0
    75d4:	0800006f          	j	7654 <framebuffer_loadTable+0x134>


		 }
		  }
*/
}
    75d8:	00c12403          	lw	s0,12(sp)
    75dc:	01010113          	addi	sp,sp,16
    75e0:	00008067          	ret
    		 XCount ++;
    75e4:	00170713          	addi	a4,a4,1 # 4001 <bsp_printf_d+0x19>
    		 if( XCount == lineSize )
    75e8:	1e000793          	li	a5,480
    75ec:	08f70a63          	beq	a4,a5,7680 <framebuffer_loadTable+0x160>
    for(j=0;j<(FRAME_SIZE*1);j++){
    75f0:	00168693          	addi	a3,a3,1
    75f4:	0007f7b7          	lui	a5,0x7f
    75f8:	8ff78793          	addi	a5,a5,-1793 # 7e8ff <__freertos_irq_stack_top+0x2accf>
    75fc:	0ad7c063          	blt	a5,a3,769c <framebuffer_loadTable+0x17c>
    	if (  ( (YCouut >= YPtr1 ) && (YCouut <= YPtr4 ) )
    7600:	ff0642e3          	blt	a2,a6,75e4 <framebuffer_loadTable+0xc4>
    7604:	fec8c0e3          	blt	a7,a2,75e4 <framebuffer_loadTable+0xc4>
    		&&(  (XCount >= XPtr1 ) && (XCount <= XPtr4 ) )
    7608:	fc674ee3          	blt	a4,t1,75e4 <framebuffer_loadTable+0xc4>
    760c:	fceecce3          	blt	t4,a4,75e4 <framebuffer_loadTable+0xc4>
    		&&( tablePtr_y <=  tableSize_y )
    7610:	fdcfcae3          	blt	t6,t3,75e4 <framebuffer_loadTable+0xc4>
			&&( tablePtr_x <=  tableSize_x )
    7614:	fcb2c8e3          	blt	t0,a1,75e4 <framebuffer_loadTable+0xc4>
{
    7618:	ff010113          	addi	sp,sp,-16
    761c:	00812623          	sw	s0,12(sp)
    		framebuffer[j] = raw_table1_ptr[tablePtr_y][tablePtr_x];
    7620:	17400793          	li	a5,372
    7624:	02fe07b3          	mul	a5,t3,a5
    7628:	00ff07b3          	add	a5,t5,a5
    762c:	00269393          	slli	t2,a3,0x2
    7630:	007503b3          	add	t2,a0,t2
    7634:	00259413          	slli	s0,a1,0x2
    7638:	008787b3          	add	a5,a5,s0
    763c:	0007a783          	lw	a5,0(a5)
    7640:	00f3a023          	sw	a5,0(t2)
    		tablePtr_x ++;
    7644:	00158593          	addi	a1,a1,1
    		 XCount ++;
    7648:	00170713          	addi	a4,a4,1
    		 if( XCount == lineSize )
    764c:	1e000793          	li	a5,480
    7650:	f6f706e3          	beq	a4,a5,75bc <framebuffer_loadTable+0x9c>
    for(j=0;j<(FRAME_SIZE*1);j++){
    7654:	00168693          	addi	a3,a3,1
    7658:	0007f7b7          	lui	a5,0x7f
    765c:	8ff78793          	addi	a5,a5,-1793 # 7e8ff <__freertos_irq_stack_top+0x2accf>
    7660:	f6d7cce3          	blt	a5,a3,75d8 <framebuffer_loadTable+0xb8>
    	if (  ( (YCouut >= YPtr1 ) && (YCouut <= YPtr4 ) )
    7664:	ff0642e3          	blt	a2,a6,7648 <framebuffer_loadTable+0x128>
    7668:	fec8c0e3          	blt	a7,a2,7648 <framebuffer_loadTable+0x128>
    		&&(  (XCount >= XPtr1 ) && (XCount <= XPtr4 ) )
    766c:	fc674ee3          	blt	a4,t1,7648 <framebuffer_loadTable+0x128>
    7670:	fceecce3          	blt	t4,a4,7648 <framebuffer_loadTable+0x128>
    		&&( tablePtr_y <=  tableSize_y )
    7674:	fdcfcae3          	blt	t6,t3,7648 <framebuffer_loadTable+0x128>
			&&( tablePtr_x <=  tableSize_x )
    7678:	fcb2c8e3          	blt	t0,a1,7648 <framebuffer_loadTable+0x128>
    767c:	fa5ff06f          	j	7620 <framebuffer_loadTable+0x100>
    			 if ( (YCouut >= YPtr1 ) && (YCouut <= YPtr4 ) )
    7680:	01064663          	blt	a2,a6,768c <framebuffer_loadTable+0x16c>
    7684:	00c8c463          	blt	a7,a2,768c <framebuffer_loadTable+0x16c>
    				 tablePtr_y++;
    7688:	001e0e13          	addi	t3,t3,1
    			 YCouut++;
    768c:	00160613          	addi	a2,a2,1
    			 tablePtr_x =0;
    7690:	00000593          	li	a1,0
    			 XCount = 0;
    7694:	00000713          	li	a4,0
    7698:	f59ff06f          	j	75f0 <framebuffer_loadTable+0xd0>
    769c:	00008067          	ret

000076a0 <framebuffer_overlayFrame>:



void framebuffer_overlayFrame(u32 *framebuffer, u32 start_x, u32 end_x, u32 start_y, u32 end_y, u32 thickness, u32 colourType)
{
    76a0:	f7010113          	addi	sp,sp,-144
    76a4:	08812623          	sw	s0,140(sp)
	//thickness value should be 4 pixel per step.
	const u32 colourIndx[4][8] = {
    76a8:	0000a337          	lui	t1,0xa
    76ac:	8e030313          	addi	t1,t1,-1824 # 98e0 <imx477_mode_1920x1080_60fps+0x1ec>
    76b0:	00010e13          	mv	t3,sp
    76b4:	08030293          	addi	t0,t1,128
    76b8:	00032403          	lw	s0,0(t1)
    76bc:	00432f83          	lw	t6,4(t1)
    76c0:	00832f03          	lw	t5,8(t1)
    76c4:	00c32e83          	lw	t4,12(t1)
    76c8:	008e2023          	sw	s0,0(t3)
    76cc:	01fe2223          	sw	t6,4(t3)
    76d0:	01ee2423          	sw	t5,8(t3)
    76d4:	01de2623          	sw	t4,12(t3)
    76d8:	01030313          	addi	t1,t1,16
    76dc:	010e0e13          	addi	t3,t3,16
    76e0:	fc531ce3          	bne	t1,t0,76b8 <framebuffer_overlayFrame+0x18>


	int XCount =0;
	int YCouut =0;
	int lineSize = FRAME_SIZE/1080;
	int XPtr1 =start_x /4;
    76e4:	0025d893          	srli	a7,a1,0x2
	int XPtr2 =start_x /4 + (thickness/4-1);
    76e8:	0027d593          	srli	a1,a5,0x2
    76ec:	00b88f33          	add	t5,a7,a1
    76f0:	ffff0f13          	addi	t5,t5,-1
	int XPtr3 =end_x /4   - (thickness/4-1);
    76f4:	00265313          	srli	t1,a2,0x2
    76f8:	40b305b3          	sub	a1,t1,a1
    76fc:	00158f93          	addi	t6,a1,1
	int XPtr4 =end_x /4;


	int YPtr1 =start_y ;
    7700:	00068e13          	mv	t3,a3
	int YPtr2 =start_y  + thickness;
    7704:	00d783b3          	add	t2,a5,a3
	int YPtr3 =end_y    - thickness;
    7708:	40f702b3          	sub	t0,a4,a5
	int YPtr4 =end_y ;
	int j;

	 for(j=0;j<(FRAME_SIZE*1);j++){
    770c:	00000613          	li	a2,0
	int YCouut =0;
    7710:	00000593          	li	a1,0
	int XCount =0;
    7714:	00000793          	li	a5,0
	 for(j=0;j<(FRAME_SIZE*1);j++){
    7718:	0600006f          	j	7778 <framebuffer_overlayFrame+0xd8>
				  //solid Colour
			  }
		      else
		      {
		    	  //Frame
		    	  if(colourType != 8)
    771c:	00800693          	li	a3,8
    7720:	08d80463          	beq	a6,a3,77a8 <framebuffer_overlayFrame+0x108>
		    	  {
		    		  framebuffer[j] =  colourIndx[YCouut%4][colourType] | 0x01010101;
    7724:	41f5d693          	srai	a3,a1,0x1f
    7728:	01e6de93          	srli	t4,a3,0x1e
    772c:	01d586b3          	add	a3,a1,t4
    7730:	0036f693          	andi	a3,a3,3
    7734:	41d686b3          	sub	a3,a3,t4
    7738:	00369693          	slli	a3,a3,0x3
    773c:	010686b3          	add	a3,a3,a6
    7740:	00269693          	slli	a3,a3,0x2
    7744:	08010e93          	addi	t4,sp,128
    7748:	00de86b3          	add	a3,t4,a3
    774c:	f806ae83          	lw	t4,-128(a3)
    7750:	00261693          	slli	a3,a2,0x2
    7754:	00d506b3          	add	a3,a0,a3
    7758:	01010437          	lui	s0,0x1010
    775c:	10140413          	addi	s0,s0,257 # 1010101 <__freertos_irq_stack_top+0xfbc4d1>
    7760:	008eeeb3          	or	t4,t4,s0
    7764:	01d6a023          	sw	t4,0(a3)
		    		  framebuffer[j] = 0x00000000;
		    	  }
		      }
		 }

		 XCount ++;
    7768:	00178793          	addi	a5,a5,1
		 if( XCount == lineSize )
    776c:	1e000693          	li	a3,480
    7770:	04d78463          	beq	a5,a3,77b8 <framebuffer_overlayFrame+0x118>
	 for(j=0;j<(FRAME_SIZE*1);j++){
    7774:	00160613          	addi	a2,a2,1
    7778:	0007f6b7          	lui	a3,0x7f
    777c:	8ff68693          	addi	a3,a3,-1793 # 7e8ff <__freertos_irq_stack_top+0x2accf>
    7780:	04c6c263          	blt	a3,a2,77c4 <framebuffer_overlayFrame+0x124>
		 if(  (XCount >= XPtr1) &&  (XCount <= XPtr4) && (YCouut >= YPtr1) && (YCouut <= YPtr4) )
    7784:	ff17c2e3          	blt	a5,a7,7768 <framebuffer_overlayFrame+0xc8>
    7788:	fef340e3          	blt	t1,a5,7768 <framebuffer_overlayFrame+0xc8>
    778c:	fdc5cee3          	blt	a1,t3,7768 <framebuffer_overlayFrame+0xc8>
    7790:	fcb74ce3          	blt	a4,a1,7768 <framebuffer_overlayFrame+0xc8>
		      if ( (XCount > XPtr2) &&  (XCount < XPtr3) && (YCouut > YPtr2) && (YCouut < YPtr3) )
    7794:	f8ff54e3          	bge	t5,a5,771c <framebuffer_overlayFrame+0x7c>
    7798:	f9f7d2e3          	bge	a5,t6,771c <framebuffer_overlayFrame+0x7c>
    779c:	f8b3d0e3          	bge	t2,a1,771c <framebuffer_overlayFrame+0x7c>
    77a0:	fc55c4e3          	blt	a1,t0,7768 <framebuffer_overlayFrame+0xc8>
    77a4:	f79ff06f          	j	771c <framebuffer_overlayFrame+0x7c>
		    		  framebuffer[j] = 0x00000000;
    77a8:	00261693          	slli	a3,a2,0x2
    77ac:	00d506b3          	add	a3,a0,a3
    77b0:	0006a023          	sw	zero,0(a3)
    77b4:	fb5ff06f          	j	7768 <framebuffer_overlayFrame+0xc8>
		 {
			 XCount = 0;
		 	 YCouut++;
    77b8:	00158593          	addi	a1,a1,1
			 XCount = 0;
    77bc:	00000793          	li	a5,0
    77c0:	fb5ff06f          	j	7774 <framebuffer_overlayFrame+0xd4>
		 }
	 }


}
    77c4:	08c12403          	lw	s0,140(sp)
    77c8:	09010113          	addi	sp,sp,144
    77cc:	00008067          	ret

000077d0 <framebuffer_overlayMask>:
void framebuffer_overlayMask(u32 *framebuffer, int index) {

	 u32 j,k,y;
	u32 linesize = FRAME_SIZE/4/1080 ;

	for(j=0;j<(FRAME_SIZE*1);j++){
    77d0:	00000713          	li	a4,0
    77d4:	0007f7b7          	lui	a5,0x7f
    77d8:	8ff78793          	addi	a5,a5,-1793 # 7e8ff <__freertos_irq_stack_top+0x2accf>
    77dc:	00e7ec63          	bltu	a5,a4,77f4 <framebuffer_overlayMask+0x24>
					 framebuffer[j] = 0x00000000;
    77e0:	00271793          	slli	a5,a4,0x2
    77e4:	00f507b3          	add	a5,a0,a5
    77e8:	0007a023          	sw	zero,0(a5)
	for(j=0;j<(FRAME_SIZE*1);j++){
    77ec:	00170713          	addi	a4,a4,1
    77f0:	fe5ff06f          	j	77d4 <framebuffer_overlayMask+0x4>
		}


		 for(j=0;j<(FRAME_SIZE*1);j++){
    77f4:	00000793          	li	a5,0
    77f8:	0140006f          	j	780c <framebuffer_overlayMask+0x3c>

			 if ( ((j%linesize) >=0) && ( (j%linesize) < 20 ) )
				 framebuffer[j] = 0xFFFFFFFF;
			 else
				 framebuffer[j] = 0x00000000;
    77fc:	00279713          	slli	a4,a5,0x2
    7800:	00e50733          	add	a4,a0,a4
    7804:	00072023          	sw	zero,0(a4)
		 for(j=0;j<(FRAME_SIZE*1);j++){
    7808:	00178793          	addi	a5,a5,1
    780c:	0007f737          	lui	a4,0x7f
    7810:	8ff70713          	addi	a4,a4,-1793 # 7e8ff <__freertos_irq_stack_top+0x2accf>
    7814:	02f76463          	bltu	a4,a5,783c <framebuffer_overlayMask+0x6c>
			 if ( ((j%linesize) >=0) && ( (j%linesize) < 20 ) )
    7818:	07800713          	li	a4,120
    781c:	02e7f733          	remu	a4,a5,a4
    7820:	01300693          	li	a3,19
    7824:	fce6ece3          	bltu	a3,a4,77fc <framebuffer_overlayMask+0x2c>
				 framebuffer[j] = 0xFFFFFFFF;
    7828:	00279713          	slli	a4,a5,0x2
    782c:	00e50733          	add	a4,a0,a4
    7830:	fff00693          	li	a3,-1
    7834:	00d72023          	sw	a3,0(a4)
    7838:	fd1ff06f          	j	7808 <framebuffer_overlayMask+0x38>



		 }
}
    783c:	00008067          	ret

00007840 <framebuffer_pattern>:


void framebuffer_pattern(u32 *framebuffer, int index, int orientation) {
    7840:	e4010113          	addi	sp,sp,-448
	u32 outpixel = 0;
	u32 TempPixel1 = 0;
	u32 TempPixel2 = 0;
	u32 TempPixel3 = 0;
	u32 TempPixel4 = 0;
	int startline = index*2;
    7844:	00159593          	slli	a1,a1,0x1
	int endline = startline +2;
    7848:	00258813          	addi	a6,a1,2
	int colourtcount = 0;
	int linecount 	= 0;

	const u32 colourbar[14][8] = {
    784c:	0000a6b7          	lui	a3,0xa
    7850:	8e068693          	addi	a3,a3,-1824 # 98e0 <imx477_mode_1920x1080_60fps+0x1ec>
    7854:	08068793          	addi	a5,a3,128
    7858:	00010713          	mv	a4,sp
    785c:	24068693          	addi	a3,a3,576
    7860:	0007ae83          	lw	t4,0(a5)
    7864:	0047ae03          	lw	t3,4(a5)
    7868:	0087a303          	lw	t1,8(a5)
    786c:	00c7a883          	lw	a7,12(a5)
    7870:	01d72023          	sw	t4,0(a4)
    7874:	01c72223          	sw	t3,4(a4)
    7878:	00672423          	sw	t1,8(a4)
    787c:	01172623          	sw	a7,12(a4)
    7880:	01078793          	addi	a5,a5,16
    7884:	01070713          	addi	a4,a4,16
    7888:	fcd79ce3          	bne	a5,a3,7860 <framebuffer_pattern+0x20>
	 u32 Temp_Count2 = 0;

	 u32 Temp_Count3 = 0;


	 if (orientation == 0)
    788c:	06060e63          	beqz	a2,7908 <framebuffer_pattern+0xc8>
	 linecount 	= startline;
    7890:	00058693          	mv	a3,a1
		 framebuffer[j] = outpixel;
		 }
	}
	else
	{
		 for(j=0;j<(FRAME_SIZE*1);j++){
    7894:	00000713          	li	a4,0
	 colourtcount = 0;
    7898:	00000893          	li	a7,0
    789c:	0ac0006f          	j	7948 <framebuffer_pattern+0x108>
						 linecount =startline;
    78a0:	00058313          	mv	t1,a1
					 colourtcount=0;
    78a4:	00060693          	mv	a3,a2
		 outpixel = colourbar[linecount][colourtcount];
    78a8:	00331793          	slli	a5,t1,0x3
    78ac:	00d787b3          	add	a5,a5,a3
    78b0:	00279793          	slli	a5,a5,0x2
    78b4:	1c010893          	addi	a7,sp,448
    78b8:	00f887b3          	add	a5,a7,a5
    78bc:	e407a883          	lw	a7,-448(a5)
		 framebuffer[j] = outpixel;
    78c0:	00271793          	slli	a5,a4,0x2
    78c4:	00f507b3          	add	a5,a0,a5
    78c8:	0117a023          	sw	a7,0(a5)
		 for(j=0;j<(FRAME_SIZE*1);j++){
    78cc:	00170713          	addi	a4,a4,1
    78d0:	0007f7b7          	lui	a5,0x7f
    78d4:	8ff78793          	addi	a5,a5,-1793 # 7e8ff <__freertos_irq_stack_top+0x2accf>
    78d8:	0ae7e663          	bltu	a5,a4,7984 <framebuffer_pattern+0x144>
		 if(j!=0)
    78dc:	fc0706e3          	beqz	a4,78a8 <framebuffer_pattern+0x68>
			 if( (j%(1920/32)) ==0 ){
    78e0:	03c00793          	li	a5,60
    78e4:	02f777b3          	remu	a5,a4,a5
    78e8:	fc0790e3          	bnez	a5,78a8 <framebuffer_pattern+0x68>
				 colourtcount++;
    78ec:	00168693          	addi	a3,a3,1
				 if(colourtcount==8)
    78f0:	00800793          	li	a5,8
    78f4:	faf69ae3          	bne	a3,a5,78a8 <framebuffer_pattern+0x68>
					 linecount++;
    78f8:	00130313          	addi	t1,t1,1
					 if(linecount==(endline)){
    78fc:	fa6802e3          	beq	a6,t1,78a0 <framebuffer_pattern+0x60>
					 colourtcount=0;
    7900:	00060693          	mv	a3,a2
    7904:	fa5ff06f          	j	78a8 <framebuffer_pattern+0x68>
	 linecount 	= startline;
    7908:	00058313          	mv	t1,a1
	 colourtcount = 0;
    790c:	00060693          	mv	a3,a2
		 for(j=0;j<(FRAME_SIZE*1);j++){
    7910:	00000713          	li	a4,0
    7914:	fbdff06f          	j	78d0 <framebuffer_pattern+0x90>
					 if( (j%(1920/4)) ==0 ){

		//				 bsp_printf("%8x ", j );
						 linecount++;
						 if(linecount==(endline)){
							 linecount =startline;
    7918:	00058693          	mv	a3,a1
    791c:	0500006f          	j	796c <framebuffer_pattern+0x12c>
					if (j% ((1920/4)* (1080/8) )==0  )
					 colourtcount++;

			         }
			     }
				 outpixel = colourbar[linecount][colourtcount];
    7920:	00369793          	slli	a5,a3,0x3
    7924:	011787b3          	add	a5,a5,a7
    7928:	00279793          	slli	a5,a5,0x2
    792c:	1c010613          	addi	a2,sp,448
    7930:	00f607b3          	add	a5,a2,a5
    7934:	e407a603          	lw	a2,-448(a5)
				 framebuffer[j] = outpixel;
    7938:	00271793          	slli	a5,a4,0x2
    793c:	00f507b3          	add	a5,a0,a5
    7940:	00c7a023          	sw	a2,0(a5)
		 for(j=0;j<(FRAME_SIZE*1);j++){
    7944:	00170713          	addi	a4,a4,1
    7948:	0007f7b7          	lui	a5,0x7f
    794c:	8ff78793          	addi	a5,a5,-1793 # 7e8ff <__freertos_irq_stack_top+0x2accf>
    7950:	02e7ea63          	bltu	a5,a4,7984 <framebuffer_pattern+0x144>
				 if(j!=0)
    7954:	fc0706e3          	beqz	a4,7920 <framebuffer_pattern+0xe0>
					 if( (j%(1920/4)) ==0 ){
    7958:	1e000793          	li	a5,480
    795c:	02f777b3          	remu	a5,a4,a5
    7960:	fc0790e3          	bnez	a5,7920 <framebuffer_pattern+0xe0>
						 linecount++;
    7964:	00168693          	addi	a3,a3,1
						 if(linecount==(endline)){
    7968:	fad808e3          	beq	a6,a3,7918 <framebuffer_pattern+0xd8>
					if (j% ((1920/4)* (1080/8) )==0  )
    796c:	000107b7          	lui	a5,0x10
    7970:	d2078793          	addi	a5,a5,-736 # fd20 <raw_table4+0x6200>
    7974:	02f777b3          	remu	a5,a4,a5
    7978:	fa0794e3          	bnez	a5,7920 <framebuffer_pattern+0xe0>
					 colourtcount++;
    797c:	00188893          	addi	a7,a7,1
    7980:	fa1ff06f          	j	7920 <framebuffer_pattern+0xe0>
				 }
	}
}
    7984:	1c010113          	addi	sp,sp,448
    7988:	00008067          	ret

0000798c <dma_video_in_channel_execution>:


void dma_video_in_channel_execution(u32 *framebuffer, u32 channel)
{
    798c:	ff010113          	addi	sp,sp,-16
    7990:	00112623          	sw	ra,12(sp)
    7994:	00812423          	sw	s0,8(sp)
    7998:	00912223          	sw	s1,4(sp)
    799c:	00050493          	mv	s1,a0
    79a0:	00058413          	mv	s0,a1
	if(dmasg_busy(DMASG_BASE, channel))
    79a4:	f8130537          	lui	a0,0xf8130
    79a8:	9f9ff0ef          	jal	ra,73a0 <dmasg_busy>
    79ac:	06051663          	bnez	a0,7a18 <dma_video_in_channel_execution+0x8c>
	{
		bsp_printf("stop dma Ch %x \n\r with SG MODE", channel);
		dmasg_stop(DMASG_BASE, channel);

	}
	bsp_printf("Start dma Ch %x \n\r with SG Mode", channel);
    79b0:	00040593          	mv	a1,s0
    79b4:	00051537          	lui	a0,0x51
    79b8:	73850513          	addi	a0,a0,1848 # 51738 <raw_table+0xe5b8>
    79bc:	a2dff0ef          	jal	ra,73e8 <bsp_printf>
	dmasg_output_memory(DMASG_BASE,channel, (u32)framebuffer, (256)); // dmasg_pop_memory (DMASG_BASE, DMASG_CHANNEL0, (u32)pucEthernetBuffer, 64);
    79c0:	10000693          	li	a3,256
    79c4:	00048613          	mv	a2,s1
    79c8:	00040593          	mv	a1,s0
    79cc:	f8130537          	lui	a0,0xf8130
    79d0:	8b9ff0ef          	jal	ra,7288 <dmasg_output_memory>
	dmasg_input_stream(DMASG_BASE, channel, 0, 0, 0); 				  // dmasg_push_stream(DMASG_BASE, DMASG_CHANNEL0, 0, 0, 0);
    79d4:	00000713          	li	a4,0
    79d8:	00000693          	li	a3,0
    79dc:	00000613          	li	a2,0
    79e0:	00040593          	mv	a1,s0
    79e4:	f8130537          	lui	a0,0xf8130
    79e8:	8c9ff0ef          	jal	ra,72b0 <dmasg_input_stream>
	dmasg_direct_start(DMASG_BASE, channel, ((u32)(FRAME_SIZE*4)), 1);// dmasg_start(DMASG_BASE, DMASG_CHANNEL0, xDataLength, 0);
    79ec:	00100693          	li	a3,1
    79f0:	001fa637          	lui	a2,0x1fa
    79f4:	40060613          	addi	a2,a2,1024 # 1fa400 <__freertos_irq_stack_top+0x1a67d0>
    79f8:	00040593          	mv	a1,s0
    79fc:	f8130537          	lui	a0,0xf8130
    7a00:	915ff0ef          	jal	ra,7314 <dmasg_direct_start>

}
    7a04:	00c12083          	lw	ra,12(sp)
    7a08:	00812403          	lw	s0,8(sp)
    7a0c:	00412483          	lw	s1,4(sp)
    7a10:	01010113          	addi	sp,sp,16
    7a14:	00008067          	ret
		bsp_printf("stop dma Ch %x \n\r with SG MODE", channel);
    7a18:	00040593          	mv	a1,s0
    7a1c:	00051537          	lui	a0,0x51
    7a20:	71850513          	addi	a0,a0,1816 # 51718 <raw_table+0xe598>
    7a24:	9c5ff0ef          	jal	ra,73e8 <bsp_printf>
		dmasg_stop(DMASG_BASE, channel);
    7a28:	00040593          	mv	a1,s0
    7a2c:	f8130537          	lui	a0,0xf8130
    7a30:	945ff0ef          	jal	ra,7374 <dmasg_stop>
    7a34:	f7dff06f          	j	79b0 <dma_video_in_channel_execution+0x24>

00007a38 <dma_video_in_channel_SG>:



void dma_video_in_channel_SG(u32 * framebuffer, struct dmasg_descriptor* input_descriptor ,u32 channel)
{
    7a38:	ff010113          	addi	sp,sp,-16
    7a3c:	00112623          	sw	ra,12(sp)
    7a40:	00812423          	sw	s0,8(sp)
    7a44:	00912223          	sw	s1,4(sp)
    7a48:	01212023          	sw	s2,0(sp)
    7a4c:	00050913          	mv	s2,a0
    7a50:	00058493          	mv	s1,a1
    7a54:	00060413          	mv	s0,a2
	u32 nFrame = 1;

			u32 FramePtr  = (u32) framebuffer;
    7a58:	00050593          	mv	a1,a0

			u32 descriptorPtr = 0;


			descriptorPtr = 0;
			for (int i=0; i<nFrame; i++)
    7a5c:	00000693          	li	a3,0
			descriptorPtr = 0;
    7a60:	00000793          	li	a5,0
			for (int i=0; i<nFrame; i++)
    7a64:	0c068263          	beqz	a3,7b28 <dma_video_in_channel_SG+0xf0>
				input_descriptor[descriptorPtr].status  = 0;
				descriptorPtr ++;
			}


			input_descriptor[descriptorPtr-1].next    =  (u32)(input_descriptor);
    7a68:	08000737          	lui	a4,0x8000
    7a6c:	fff70713          	addi	a4,a4,-1 # 7ffffff <__freertos_irq_stack_top+0x7fac3cf>
    7a70:	00e787b3          	add	a5,a5,a4
    7a74:	00579793          	slli	a5,a5,0x5
    7a78:	00f487b3          	add	a5,s1,a5
    7a7c:	0097ac23          	sw	s1,24(a5)
    7a80:	0007ae23          	sw	zero,28(a5)

if(dmasg_busy(DMASG_BASE, channel))
    7a84:	00040593          	mv	a1,s0
    7a88:	f8130537          	lui	a0,0xf8130
    7a8c:	915ff0ef          	jal	ra,73a0 <dmasg_busy>
    7a90:	0e051263          	bnez	a0,7b74 <dma_video_in_channel_SG+0x13c>
{
	bsp_printf("stop dma Ch %x with SG mode \n\r", channel);
	dmasg_stop(DMASG_BASE, channel);

}
while(dmasg_busy(DMASG_BASE, channel));
    7a94:	00040593          	mv	a1,s0
    7a98:	f8130537          	lui	a0,0xf8130
    7a9c:	905ff0ef          	jal	ra,73a0 <dmasg_busy>
    7aa0:	fe051ae3          	bnez	a0,7a94 <dma_video_in_channel_SG+0x5c>

bsp_printf("stop dma input (SG) \n\r");
    7aa4:	00051537          	lui	a0,0x51
    7aa8:	77850513          	addi	a0,a0,1912 # 51778 <raw_table+0xe5f8>
    7aac:	93dff0ef          	jal	ra,73e8 <bsp_printf>
dmasg_stop(DMASG_BASE, channel);
    7ab0:	00040593          	mv	a1,s0
    7ab4:	f8130537          	lui	a0,0xf8130
    7ab8:	8bdff0ef          	jal	ra,7374 <dmasg_stop>

//dmasg_interrupt_config(DMASG_BASE, channel, 0);  //Disable dmasg channel interrupt

dmasg_stop(DMASG_BASE, channel);
    7abc:	00040593          	mv	a1,s0
    7ac0:	f8130537          	lui	a0,0xf8130
    7ac4:	8b1ff0ef          	jal	ra,7374 <dmasg_stop>
dmasg_output_memory(DMASG_BASE, channel, ((u32)(framebuffer )) , (256));//dmasg_push_memory(DMASG_BASE, 1, ((u32)pucEthernetBuffer), xDataLength);
    7ac8:	10000693          	li	a3,256
    7acc:	00090613          	mv	a2,s2
    7ad0:	00040593          	mv	a1,s0
    7ad4:	f8130537          	lui	a0,0xf8130
    7ad8:	fb0ff0ef          	jal	ra,7288 <dmasg_output_memory>
dmasg_input_stream(DMASG_BASE, channel, 0, 0, 0); //dmasg_pop_stream(DMASG_BASE, DMASG_CHANNEL1, 0, 0, 0, 1);
    7adc:	00000713          	li	a4,0
    7ae0:	00000693          	li	a3,0
    7ae4:	00000613          	li	a2,0
    7ae8:	00040593          	mv	a1,s0
    7aec:	f8130537          	lui	a0,0xf8130
    7af0:	fc0ff0ef          	jal	ra,72b0 <dmasg_input_stream>
dmasg_linked_list_start(DMASG_BASE, channel,(u32)input_descriptor  );
    7af4:	00048613          	mv	a2,s1
    7af8:	00040593          	mv	a1,s0
    7afc:	f8130537          	lui	a0,0xf8130
    7b00:	83dff0ef          	jal	ra,733c <dmasg_linked_list_start>

bsp_printf("Start dma input(SG) \n\r");
    7b04:	00051537          	lui	a0,0x51
    7b08:	79050513          	addi	a0,a0,1936 # 51790 <raw_table+0xe610>
    7b0c:	8ddff0ef          	jal	ra,73e8 <bsp_printf>


}
    7b10:	00c12083          	lw	ra,12(sp)
    7b14:	00812403          	lw	s0,8(sp)
    7b18:	00412483          	lw	s1,4(sp)
    7b1c:	00012903          	lw	s2,0(sp)
    7b20:	01010113          	addi	sp,sp,16
    7b24:	00008067          	ret
				input_descriptor[descriptorPtr].control = (u32)((FRAME_SIZE*4)-1)  | 1 << 30 | DMASG_DESCRIPTOR_CONTROL_NO_COMPLETION;
    7b28:	00579713          	slli	a4,a5,0x5
    7b2c:	00e48733          	add	a4,s1,a4
    7b30:	c01fa637          	lui	a2,0xc01fa
    7b34:	3ff60613          	addi	a2,a2,1023 # c01fa3ff <__freertos_irq_stack_top+0xc01a67cf>
    7b38:	00c72223          	sw	a2,4(a4)
				input_descriptor[descriptorPtr].from    = 0;
    7b3c:	00000813          	li	a6,0
    7b40:	00000893          	li	a7,0
    7b44:	01072423          	sw	a6,8(a4)
    7b48:	01172623          	sw	a7,12(a4)
				input_descriptor[descriptorPtr].to      = (u32)(framebuffer);
    7b4c:	00b72823          	sw	a1,16(a4)
    7b50:	00072a23          	sw	zero,20(a4)
				input_descriptor[descriptorPtr].next    =  (u32)(input_descriptor+descriptorPtr+ 1);
    7b54:	00178793          	addi	a5,a5,1
    7b58:	00579613          	slli	a2,a5,0x5
    7b5c:	00c48633          	add	a2,s1,a2
    7b60:	00c72c23          	sw	a2,24(a4)
    7b64:	00072e23          	sw	zero,28(a4)
				input_descriptor[descriptorPtr].status  = 0;
    7b68:	00072023          	sw	zero,0(a4)
			for (int i=0; i<nFrame; i++)
    7b6c:	00168693          	addi	a3,a3,1
    7b70:	ef5ff06f          	j	7a64 <dma_video_in_channel_SG+0x2c>
	bsp_printf("stop dma Ch %x with SG mode \n\r", channel);
    7b74:	00040593          	mv	a1,s0
    7b78:	00051537          	lui	a0,0x51
    7b7c:	75850513          	addi	a0,a0,1880 # 51758 <raw_table+0xe5d8>
    7b80:	869ff0ef          	jal	ra,73e8 <bsp_printf>
	dmasg_stop(DMASG_BASE, channel);
    7b84:	00040593          	mv	a1,s0
    7b88:	f8130537          	lui	a0,0xf8130
    7b8c:	fe8ff0ef          	jal	ra,7374 <dmasg_stop>
    7b90:	f05ff06f          	j	7a94 <dma_video_in_channel_SG+0x5c>

00007b94 <dma_video_out_channel_SG>:


void dma_video_out_channel_SG(u32 * framebuffer, struct dmasg_descriptor* output_descriptor ,u32 channel )
{
    7b94:	ff010113          	addi	sp,sp,-16
    7b98:	00112623          	sw	ra,12(sp)
    7b9c:	00812423          	sw	s0,8(sp)
    7ba0:	00912223          	sw	s1,4(sp)
    7ba4:	01212023          	sw	s2,0(sp)
    7ba8:	00050913          	mv	s2,a0
    7bac:	00058493          	mv	s1,a1
    7bb0:	00060413          	mv	s0,a2

	u32 nFrame = 1;
    u32 FramePtr  = (u32) framebuffer;
    7bb4:	00050593          	mv	a1,a0

	u32 descriptorPtr = 0;
	for (int i=0; i<nFrame; i++)
    7bb8:	00000693          	li	a3,0
	u32 descriptorPtr = 0;
    7bbc:	00000793          	li	a5,0
	for (int i=0; i<nFrame; i++)
    7bc0:	0c068e63          	beqz	a3,7c9c <dma_video_out_channel_SG+0x108>
		output_descriptor[descriptorPtr].next    =  (u32)(output_descriptor+descriptorPtr+ 1);
		output_descriptor[descriptorPtr].status  = 0;
		descriptorPtr ++;
	}

	output_descriptor[descriptorPtr-1].next    =  (u32)(output_descriptor);
    7bc4:	08000737          	lui	a4,0x8000
    7bc8:	fff70713          	addi	a4,a4,-1 # 7ffffff <__freertos_irq_stack_top+0x7fac3cf>
    7bcc:	00e787b3          	add	a5,a5,a4
    7bd0:	00579793          	slli	a5,a5,0x5
    7bd4:	00f487b3          	add	a5,s1,a5
    7bd8:	0097ac23          	sw	s1,24(a5)
    7bdc:	0007ae23          	sw	zero,28(a5)


	if(dmasg_busy(DMASG_BASE, channel))
    7be0:	00040593          	mv	a1,s0
    7be4:	f8130537          	lui	a0,0xf8130
    7be8:	fb8ff0ef          	jal	ra,73a0 <dmasg_busy>
    7bec:	0e051e63          	bnez	a0,7ce8 <dma_video_out_channel_SG+0x154>
	{
		bsp_printf("stop dma out(SG) \n\r");
		dmasg_stop(DMASG_BASE, channel);
	}

	while(dmasg_busy(DMASG_BASE, channel));
    7bf0:	00040593          	mv	a1,s0
    7bf4:	f8130537          	lui	a0,0xf8130
    7bf8:	fa8ff0ef          	jal	ra,73a0 <dmasg_busy>
    7bfc:	fe051ae3          	bnez	a0,7bf0 <dma_video_out_channel_SG+0x5c>


	bsp_printf("stop dma out(SG) \n\r");
    7c00:	00051537          	lui	a0,0x51
    7c04:	7a850513          	addi	a0,a0,1960 # 517a8 <raw_table+0xe628>
    7c08:	fe0ff0ef          	jal	ra,73e8 <bsp_printf>
	dmasg_stop(DMASG_BASE, channel);
    7c0c:	00040593          	mv	a1,s0
    7c10:	f8130537          	lui	a0,0xf8130
    7c14:	f60ff0ef          	jal	ra,7374 <dmasg_stop>

	dmasg_interrupt_config(DMASG_BASE, channel, 0);  //Disable dmasg channel interrupt
    7c18:	00000613          	li	a2,0
    7c1c:	00040593          	mv	a1,s0
    7c20:	f8130537          	lui	a0,0xf8130
    7c24:	f64ff0ef          	jal	ra,7388 <dmasg_interrupt_config>

	dmasg_stop(DMASG_BASE, channel);
    7c28:	00040593          	mv	a1,s0
    7c2c:	f8130537          	lui	a0,0xf8130
    7c30:	f44ff0ef          	jal	ra,7374 <dmasg_stop>
	dmasg_input_memory(DMASG_BASE, channel, ((u32)(framebuffer )) , (2048));//dmasg_push_memory(DMASG_BASE, 1, ((u32)pucEthernetBuffer), xDataLength);
    7c34:	000016b7          	lui	a3,0x1
    7c38:	80068693          	addi	a3,a3,-2048 # 800 <CUSTOM2+0x7a5>
    7c3c:	00090613          	mv	a2,s2
    7c40:	00040593          	mv	a1,s0
    7c44:	f8130537          	lui	a0,0xf8130
    7c48:	e18ff0ef          	jal	ra,7260 <dmasg_input_memory>
	dmasg_output_stream(DMASG_BASE, channel, 0, 0, 0, 1); //dmasg_pop_stream(DMASG_BASE, DMASG_CHANNEL1, 0, 0, 0, 1);
    7c4c:	00100793          	li	a5,1
    7c50:	00000713          	li	a4,0
    7c54:	00000693          	li	a3,0
    7c58:	00000613          	li	a2,0
    7c5c:	00040593          	mv	a1,s0
    7c60:	f8130537          	lui	a0,0xf8130
    7c64:	e84ff0ef          	jal	ra,72e8 <dmasg_output_stream>
	dmasg_linked_list_start(DMASG_BASE, channel,(u32)output_descriptor  );
    7c68:	00048613          	mv	a2,s1
    7c6c:	00040593          	mv	a1,s0
    7c70:	f8130537          	lui	a0,0xf8130
    7c74:	ec8ff0ef          	jal	ra,733c <dmasg_linked_list_start>

	bsp_printf("Start dma out(SG) \n\r");
    7c78:	00051537          	lui	a0,0x51
    7c7c:	7bc50513          	addi	a0,a0,1980 # 517bc <raw_table+0xe63c>
    7c80:	f68ff0ef          	jal	ra,73e8 <bsp_printf>


}
    7c84:	00c12083          	lw	ra,12(sp)
    7c88:	00812403          	lw	s0,8(sp)
    7c8c:	00412483          	lw	s1,4(sp)
    7c90:	00012903          	lw	s2,0(sp)
    7c94:	01010113          	addi	sp,sp,16
    7c98:	00008067          	ret
		output_descriptor[descriptorPtr].control = (u32)((FRAME_SIZE*4)-1)  | 1 << 30 | DMASG_DESCRIPTOR_CONTROL_NO_COMPLETION;
    7c9c:	00579713          	slli	a4,a5,0x5
    7ca0:	00e48733          	add	a4,s1,a4
    7ca4:	c01fa637          	lui	a2,0xc01fa
    7ca8:	3ff60613          	addi	a2,a2,1023 # c01fa3ff <__freertos_irq_stack_top+0xc01a67cf>
    7cac:	00c72223          	sw	a2,4(a4)
		output_descriptor[descriptorPtr].from    = (u32)(framebuffer);
    7cb0:	00b72423          	sw	a1,8(a4)
    7cb4:	00072623          	sw	zero,12(a4)
		output_descriptor[descriptorPtr].to      = 0;
    7cb8:	00000813          	li	a6,0
    7cbc:	00000893          	li	a7,0
    7cc0:	01072823          	sw	a6,16(a4)
    7cc4:	01172a23          	sw	a7,20(a4)
		output_descriptor[descriptorPtr].next    =  (u32)(output_descriptor+descriptorPtr+ 1);
    7cc8:	00178793          	addi	a5,a5,1
    7ccc:	00579613          	slli	a2,a5,0x5
    7cd0:	00c48633          	add	a2,s1,a2
    7cd4:	00c72c23          	sw	a2,24(a4)
    7cd8:	00072e23          	sw	zero,28(a4)
		output_descriptor[descriptorPtr].status  = 0;
    7cdc:	00072023          	sw	zero,0(a4)
	for (int i=0; i<nFrame; i++)
    7ce0:	00168693          	addi	a3,a3,1
    7ce4:	eddff06f          	j	7bc0 <dma_video_out_channel_SG+0x2c>
		bsp_printf("stop dma out(SG) \n\r");
    7ce8:	00051537          	lui	a0,0x51
    7cec:	7a850513          	addi	a0,a0,1960 # 517a8 <raw_table+0xe628>
    7cf0:	ef8ff0ef          	jal	ra,73e8 <bsp_printf>
		dmasg_stop(DMASG_BASE, channel);
    7cf4:	00040593          	mv	a1,s0
    7cf8:	f8130537          	lui	a0,0xf8130
    7cfc:	e78ff0ef          	jal	ra,7374 <dmasg_stop>
    7d00:	ef1ff06f          	j	7bf0 <dma_video_out_channel_SG+0x5c>

00007d04 <dma_video_in_stop>:





void dma_video_in_stop() {
    7d04:	ff010113          	addi	sp,sp,-16
    7d08:	00112623          	sw	ra,12(sp)

	bsp_printf("stop dma Ch 1in \n\r");
    7d0c:	00051537          	lui	a0,0x51
    7d10:	7d450513          	addi	a0,a0,2004 # 517d4 <raw_table+0xe654>
    7d14:	ed4ff0ef          	jal	ra,73e8 <bsp_printf>
	dmasg_stop(DMASG_BASE, DMASG_CHANNEL0);
    7d18:	00000593          	li	a1,0
    7d1c:	f8130537          	lui	a0,0xf8130
    7d20:	e54ff0ef          	jal	ra,7374 <dmasg_stop>
	bsp_printf("stop dma Ch2 in \n\r");
    7d24:	00051537          	lui	a0,0x51
    7d28:	7e850513          	addi	a0,a0,2024 # 517e8 <raw_table+0xe668>
    7d2c:	ebcff0ef          	jal	ra,73e8 <bsp_printf>
	dmasg_stop(DMASG_BASE, DMASG_CHANNEL2);
    7d30:	00200593          	li	a1,2
    7d34:	f8130537          	lui	a0,0xf8130
    7d38:	e3cff0ef          	jal	ra,7374 <dmasg_stop>
	//bsp_printf("stop dma Ch2 in \n\r");
	//dmasg_stop(DMASG_BASE, DMASG_CHANNEL4);
	//bsp_printf("stop dma Ch2 in \n\r");
	//dmasg_stop(DMASG_BASE, DMASG_CHANNEL6);

}
    7d3c:	00c12083          	lw	ra,12(sp)
    7d40:	01010113          	addi	sp,sp,16
    7d44:	00008067          	ret

00007d48 <dma_video_in_channel_stop>:


void dma_video_in_channel_stop( u32 channel) {
    7d48:	ff010113          	addi	sp,sp,-16
    7d4c:	00112623          	sw	ra,12(sp)
    7d50:	00812423          	sw	s0,8(sp)
    7d54:	00050413          	mv	s0,a0

	bsp_printf("stop dma Ch %x \n\r", channel);
    7d58:	00050593          	mv	a1,a0
    7d5c:	00051537          	lui	a0,0x51
    7d60:	7fc50513          	addi	a0,a0,2044 # 517fc <raw_table+0xe67c>
    7d64:	e84ff0ef          	jal	ra,73e8 <bsp_printf>
	dmasg_stop(DMASG_BASE, channel);
    7d68:	00040593          	mv	a1,s0
    7d6c:	f8130537          	lui	a0,0xf8130
    7d70:	e04ff0ef          	jal	ra,7374 <dmasg_stop>

}
    7d74:	00c12083          	lw	ra,12(sp)
    7d78:	00812403          	lw	s0,8(sp)
    7d7c:	01010113          	addi	sp,sp,16
    7d80:	00008067          	ret

00007d84 <dma_video_out_stop>:




void dma_video_out_stop() {
    7d84:	ff010113          	addi	sp,sp,-16
    7d88:	00112623          	sw	ra,12(sp)

	bsp_printf("stop dma Out \n\r");
    7d8c:	00052537          	lui	a0,0x52
    7d90:	81050513          	addi	a0,a0,-2032 # 51810 <raw_table+0xe690>
    7d94:	e54ff0ef          	jal	ra,73e8 <bsp_printf>
	dmasg_stop(DMASG_BASE, DMASG_CHANNEL_HDMI);
    7d98:	00400593          	li	a1,4
    7d9c:	f8130537          	lui	a0,0xf8130
    7da0:	dd4ff0ef          	jal	ra,7374 <dmasg_stop>
	bsp_printf("Start dma out \n\r");
    7da4:	00052537          	lui	a0,0x52
    7da8:	82050513          	addi	a0,a0,-2016 # 51820 <raw_table+0xe6a0>
    7dac:	e3cff0ef          	jal	ra,73e8 <bsp_printf>

}
    7db0:	00c12083          	lw	ra,12(sp)
    7db4:	01010113          	addi	sp,sp,16
    7db8:	00008067          	ret

00007dbc <dma_video_out_channel_stop>:

void dma_video_out_channel_stop( u32 channel) {
    7dbc:	ff010113          	addi	sp,sp,-16
    7dc0:	00112623          	sw	ra,12(sp)
    7dc4:	00812423          	sw	s0,8(sp)
    7dc8:	00050413          	mv	s0,a0

	bsp_printf("stop dma Out \n\r");
    7dcc:	00052537          	lui	a0,0x52
    7dd0:	81050513          	addi	a0,a0,-2032 # 51810 <raw_table+0xe690>
    7dd4:	e14ff0ef          	jal	ra,73e8 <bsp_printf>
	dmasg_stop(DMASG_BASE, channel);
    7dd8:	00040593          	mv	a1,s0
    7ddc:	f8130537          	lui	a0,0xf8130
    7de0:	d94ff0ef          	jal	ra,7374 <dmasg_stop>
	bsp_printf("Start dma out \n\r");
    7de4:	00052537          	lui	a0,0x52
    7de8:	82050513          	addi	a0,a0,-2016 # 51820 <raw_table+0xe6a0>
    7dec:	dfcff0ef          	jal	ra,73e8 <bsp_printf>

}
    7df0:	00c12083          	lw	ra,12(sp)
    7df4:	00812403          	lw	s0,8(sp)
    7df8:	01010113          	addi	sp,sp,16
    7dfc:	00008067          	ret

00007e00 <dma_video_in_channel_cs_sg_execution>:


void dma_video_in_channel_cs_sg_execution(struct cs_sg_descriptor* cs_descriptor, u32 nCSDescriptor, u32 channel)
{
    7e00:	fe010113          	addi	sp,sp,-32
    7e04:	00112e23          	sw	ra,28(sp)
    7e08:	00812c23          	sw	s0,24(sp)
    7e0c:	00912a23          	sw	s1,20(sp)
    7e10:	01212823          	sw	s2,16(sp)
    7e14:	01312623          	sw	s3,12(sp)
    7e18:	00050913          	mv	s2,a0
    7e1c:	00058493          	mv	s1,a1
    7e20:	00060993          	mv	s3,a2

	u32 CS_SG_REGS_ADDR = (channel * 4 * 4)  *4;
    7e24:	00661413          	slli	s0,a2,0x6

		bsp_printf("stop dma input \n\r");
    7e28:	00052537          	lui	a0,0x52
    7e2c:	83450513          	addi	a0,a0,-1996 # 51834 <raw_table+0xe6b4>
    7e30:	db8ff0ef          	jal	ra,73e8 <bsp_printf>

		bsp_printf("Custom SG mode Input init! \n\r");
    7e34:	00052537          	lui	a0,0x52
    7e38:	84850513          	addi	a0,a0,-1976 # 51848 <raw_table+0xe6c8>
    7e3c:	dacff0ef          	jal	ra,73e8 <bsp_printf>


		for(int i=0; i<nCSDescriptor; i++)
    7e40:	00000693          	li	a3,0
    7e44:	0496fc63          	bgeu	a3,s1,7e9c <dma_video_in_channel_cs_sg_execution+0x9c>
		{


			APB3_REGW(CS_SG_APB_SLV, CS_SG_REGS_ADDR, cs_descriptor[i].ctrl_word);
    7e48:	00469713          	slli	a4,a3,0x4
    7e4c:	00e90733          	add	a4,s2,a4
    7e50:	00072583          	lw	a1,0(a4)
    7e54:	f81407b7          	lui	a5,0xf8140
    7e58:	00f40633          	add	a2,s0,a5
    7e5c:	00b62023          	sw	a1,0(a2)
			CS_SG_REGS_ADDR +=4;

			APB3_REGW(CS_SG_APB_SLV, CS_SG_REGS_ADDR, cs_descriptor[i].src_addr);
    7e60:	00472583          	lw	a1,4(a4)
    7e64:	00478613          	addi	a2,a5,4 # f8140004 <__freertos_irq_stack_top+0xf80ec3d4>
    7e68:	00c40633          	add	a2,s0,a2
    7e6c:	00b62023          	sw	a1,0(a2)
			CS_SG_REGS_ADDR +=4;

			APB3_REGW(CS_SG_APB_SLV, CS_SG_REGS_ADDR, cs_descriptor[i].dst_addr);
    7e70:	00872583          	lw	a1,8(a4)
    7e74:	00878613          	addi	a2,a5,8
    7e78:	00c40633          	add	a2,s0,a2
    7e7c:	00b62023          	sw	a1,0(a2)
			CS_SG_REGS_ADDR +=4;

			APB3_REGW(CS_SG_APB_SLV, CS_SG_REGS_ADDR, cs_descriptor[i].nBytes);
    7e80:	00c72703          	lw	a4,12(a4)
    7e84:	00c78793          	addi	a5,a5,12
    7e88:	00f407b3          	add	a5,s0,a5
    7e8c:	00e7a023          	sw	a4,0(a5)
			CS_SG_REGS_ADDR +=4;
    7e90:	01040413          	addi	s0,s0,16
		for(int i=0; i<nCSDescriptor; i++)
    7e94:	00168693          	addi	a3,a3,1
    7e98:	fadff06f          	j	7e44 <dma_video_in_channel_cs_sg_execution+0x44>

		}
		bsp_printf("Initial CS Register \n\r");
    7e9c:	00052537          	lui	a0,0x52
    7ea0:	86850513          	addi	a0,a0,-1944 # 51868 <raw_table+0xe6e8>
    7ea4:	d44ff0ef          	jal	ra,73e8 <bsp_printf>

	if(dmasg_busy(DMASG_BASE, channel))
    7ea8:	00098593          	mv	a1,s3
    7eac:	f8130537          	lui	a0,0xf8130
    7eb0:	cf0ff0ef          	jal	ra,73a0 <dmasg_busy>
    7eb4:	06051a63          	bnez	a0,7f28 <dma_video_in_channel_cs_sg_execution+0x128>
	{
		bsp_printf("stop dma Ch %x \n\r with SG MODE", channel);
		dmasg_stop(DMASG_BASE, channel);

	}
	bsp_printf("Start dma Ch %x \n\r with CS SG Mode", channel);
    7eb8:	00098593          	mv	a1,s3
    7ebc:	00052537          	lui	a0,0x52
    7ec0:	88050513          	addi	a0,a0,-1920 # 51880 <raw_table+0xe700>
    7ec4:	d24ff0ef          	jal	ra,73e8 <bsp_printf>
	dmasg_output_memory(DMASG_BASE,channel, 0, 256); // dmasg_pop_memory (DMASG_BASE, DMASG_CHANNEL0, (u32)pucEthernetBuffer, 64);
    7ec8:	10000693          	li	a3,256
    7ecc:	00000613          	li	a2,0
    7ed0:	00098593          	mv	a1,s3
    7ed4:	f8130537          	lui	a0,0xf8130
    7ed8:	bb0ff0ef          	jal	ra,7288 <dmasg_output_memory>
	dmasg_input_stream(DMASG_BASE, channel, 0, 1, 0); 				  // dmasg_push_stream(DMASG_BASE, DMASG_CHANNEL0, 0, 0, 0);
    7edc:	00000713          	li	a4,0
    7ee0:	00100693          	li	a3,1
    7ee4:	00000613          	li	a2,0
    7ee8:	00098593          	mv	a1,s3
    7eec:	f8130537          	lui	a0,0xf8130
    7ef0:	bc0ff0ef          	jal	ra,72b0 <dmasg_input_stream>

	dmasg_linked_list_sg_start(DMASG_BASE, channel);
    7ef4:	00098593          	mv	a1,s3
    7ef8:	f8130537          	lui	a0,0xf8130
    7efc:	c5cff0ef          	jal	ra,7358 <dmasg_linked_list_sg_start>
	bsp_printf("Start dma input with cs cg\n\r");
    7f00:	00052537          	lui	a0,0x52
    7f04:	8a450513          	addi	a0,a0,-1884 # 518a4 <raw_table+0xe724>
    7f08:	ce0ff0ef          	jal	ra,73e8 <bsp_printf>

}
    7f0c:	01c12083          	lw	ra,28(sp)
    7f10:	01812403          	lw	s0,24(sp)
    7f14:	01412483          	lw	s1,20(sp)
    7f18:	01012903          	lw	s2,16(sp)
    7f1c:	00c12983          	lw	s3,12(sp)
    7f20:	02010113          	addi	sp,sp,32
    7f24:	00008067          	ret
		bsp_printf("stop dma Ch %x \n\r with SG MODE", channel);
    7f28:	00098593          	mv	a1,s3
    7f2c:	00051537          	lui	a0,0x51
    7f30:	71850513          	addi	a0,a0,1816 # 51718 <raw_table+0xe598>
    7f34:	cb4ff0ef          	jal	ra,73e8 <bsp_printf>
		dmasg_stop(DMASG_BASE, channel);
    7f38:	00098593          	mv	a1,s3
    7f3c:	f8130537          	lui	a0,0xf8130
    7f40:	c34ff0ef          	jal	ra,7374 <dmasg_stop>
    7f44:	f75ff06f          	j	7eb8 <dma_video_in_channel_cs_sg_execution+0xb8>

00007f48 <dma_video_out_channel_cs_sg_execution>:


void dma_video_out_channel_cs_sg_execution(struct cs_sg_descriptor* cs_descriptor, u32 nCSDescriptor, u32 channel)
{
    7f48:	fe010113          	addi	sp,sp,-32
    7f4c:	00112e23          	sw	ra,28(sp)
    7f50:	00812c23          	sw	s0,24(sp)
    7f54:	00912a23          	sw	s1,20(sp)
    7f58:	01212823          	sw	s2,16(sp)
    7f5c:	01312623          	sw	s3,12(sp)
    7f60:	00050913          	mv	s2,a0
    7f64:	00058493          	mv	s1,a1
    7f68:	00060993          	mv	s3,a2

	u32 CS_SG_REGS_ADDR = (channel * 4 * 4)  *4;
    7f6c:	00661413          	slli	s0,a2,0x6

	bsp_printf("stop dma out \n\r");
    7f70:	00052537          	lui	a0,0x52
    7f74:	8c450513          	addi	a0,a0,-1852 # 518c4 <raw_table+0xe744>
    7f78:	c70ff0ef          	jal	ra,73e8 <bsp_printf>

	bsp_printf("Custom SG mode output init \n\r");
    7f7c:	00052537          	lui	a0,0x52
    7f80:	8d450513          	addi	a0,a0,-1836 # 518d4 <raw_table+0xe754>
    7f84:	c64ff0ef          	jal	ra,73e8 <bsp_printf>


	for(int i=0; i<nCSDescriptor; i++)
    7f88:	00000693          	li	a3,0
    7f8c:	0496fc63          	bgeu	a3,s1,7fe4 <dma_video_out_channel_cs_sg_execution+0x9c>
	{


		APB3_REGW(CS_SG_APB_SLV, CS_SG_REGS_ADDR, cs_descriptor[i].ctrl_word);
    7f90:	00469713          	slli	a4,a3,0x4
    7f94:	00e90733          	add	a4,s2,a4
    7f98:	00072583          	lw	a1,0(a4)
    7f9c:	f81407b7          	lui	a5,0xf8140
    7fa0:	00f40633          	add	a2,s0,a5
    7fa4:	00b62023          	sw	a1,0(a2)
		CS_SG_REGS_ADDR +=4;

		APB3_REGW(CS_SG_APB_SLV, CS_SG_REGS_ADDR, cs_descriptor[i].src_addr);
    7fa8:	00472583          	lw	a1,4(a4)
    7fac:	00478613          	addi	a2,a5,4 # f8140004 <__freertos_irq_stack_top+0xf80ec3d4>
    7fb0:	00c40633          	add	a2,s0,a2
    7fb4:	00b62023          	sw	a1,0(a2)
		CS_SG_REGS_ADDR +=4;

		APB3_REGW(CS_SG_APB_SLV, CS_SG_REGS_ADDR, cs_descriptor[i].dst_addr);
    7fb8:	00872583          	lw	a1,8(a4)
    7fbc:	00878613          	addi	a2,a5,8
    7fc0:	00c40633          	add	a2,s0,a2
    7fc4:	00b62023          	sw	a1,0(a2)
		CS_SG_REGS_ADDR +=4;

		APB3_REGW(CS_SG_APB_SLV, CS_SG_REGS_ADDR, cs_descriptor[i].nBytes);
    7fc8:	00c72703          	lw	a4,12(a4)
    7fcc:	00c78793          	addi	a5,a5,12
    7fd0:	00f407b3          	add	a5,s0,a5
    7fd4:	00e7a023          	sw	a4,0(a5)
		CS_SG_REGS_ADDR +=4;
    7fd8:	01040413          	addi	s0,s0,16
	for(int i=0; i<nCSDescriptor; i++)
    7fdc:	00168693          	addi	a3,a3,1
    7fe0:	fadff06f          	j	7f8c <dma_video_out_channel_cs_sg_execution+0x44>

	}
	bsp_printf("Initial CS Register \n\r");
    7fe4:	00052537          	lui	a0,0x52
    7fe8:	86850513          	addi	a0,a0,-1944 # 51868 <raw_table+0xe6e8>
    7fec:	bfcff0ef          	jal	ra,73e8 <bsp_printf>


	bsp_printf("stop dma out \n\r");
    7ff0:	00052537          	lui	a0,0x52
    7ff4:	8c450513          	addi	a0,a0,-1852 # 518c4 <raw_table+0xe744>
    7ff8:	bf0ff0ef          	jal	ra,73e8 <bsp_printf>
	dmasg_stop(DMASG_BASE, channel);
    7ffc:	00098593          	mv	a1,s3
    8000:	f8130537          	lui	a0,0xf8130
    8004:	b70ff0ef          	jal	ra,7374 <dmasg_stop>

	dmasg_interrupt_config(DMASG_BASE, channel, 0);  //Disable dmasg channel interrupt
    8008:	00000613          	li	a2,0
    800c:	00098593          	mv	a1,s3
    8010:	f8130537          	lui	a0,0xf8130
    8014:	b74ff0ef          	jal	ra,7388 <dmasg_interrupt_config>

    dmasg_input_memory(DMASG_BASE, channel, 0 , 2048);
    8018:	000016b7          	lui	a3,0x1
    801c:	80068693          	addi	a3,a3,-2048 # 800 <CUSTOM2+0x7a5>
    8020:	00000613          	li	a2,0
    8024:	00098593          	mv	a1,s3
    8028:	f8130537          	lui	a0,0xf8130
    802c:	a34ff0ef          	jal	ra,7260 <dmasg_input_memory>
	dmasg_output_stream(DMASG_BASE, channel, 0, 0, 0, 1);
    8030:	00100793          	li	a5,1
    8034:	00000713          	li	a4,0
    8038:	00000693          	li	a3,0
    803c:	00000613          	li	a2,0
    8040:	00098593          	mv	a1,s3
    8044:	f8130537          	lui	a0,0xf8130
    8048:	aa0ff0ef          	jal	ra,72e8 <dmasg_output_stream>

	dmasg_linked_list_sg_start(DMASG_BASE, channel);
    804c:	00098593          	mv	a1,s3
    8050:	f8130537          	lui	a0,0xf8130
    8054:	b04ff0ef          	jal	ra,7358 <dmasg_linked_list_sg_start>
	bsp_printf("Start dma out with cs cg\n\r");
    8058:	00052537          	lui	a0,0x52
    805c:	8f450513          	addi	a0,a0,-1804 # 518f4 <raw_table+0xe774>
    8060:	b88ff0ef          	jal	ra,73e8 <bsp_printf>

}
    8064:	01c12083          	lw	ra,28(sp)
    8068:	01812403          	lw	s0,24(sp)
    806c:	01412483          	lw	s1,20(sp)
    8070:	01012903          	lw	s2,16(sp)
    8074:	00c12983          	lw	s3,12(sp)
    8078:	02010113          	addi	sp,sp,32
    807c:	00008067          	ret

00008080 <dma_video_out_channel_execution>:



void dma_video_out_channel_execution(u32 *framebuffer, u32 channel)
{
    8080:	ff010113          	addi	sp,sp,-16
    8084:	00112623          	sw	ra,12(sp)
    8088:	00812423          	sw	s0,8(sp)
    808c:	00912223          	sw	s1,4(sp)
    8090:	00050493          	mv	s1,a0
    8094:	00058413          	mv	s0,a1

	bsp_printf("stop dma out \n\r");
    8098:	00052537          	lui	a0,0x52
    809c:	8c450513          	addi	a0,a0,-1852 # 518c4 <raw_table+0xe744>
    80a0:	b48ff0ef          	jal	ra,73e8 <bsp_printf>
	dmasg_stop(DMASG_BASE, channel);
    80a4:	00040593          	mv	a1,s0
    80a8:	f8130537          	lui	a0,0xf8130
    80ac:	ac8ff0ef          	jal	ra,7374 <dmasg_stop>

	dmasg_interrupt_config(DMASG_BASE, channel, 0);  //Disable dmasg channel interrupt
    80b0:	00000613          	li	a2,0
    80b4:	00040593          	mv	a1,s0
    80b8:	f8130537          	lui	a0,0xf8130
    80bc:	accff0ef          	jal	ra,7388 <dmasg_interrupt_config>

    dmasg_input_memory(DMASG_BASE, channel, ((u32)(framebuffer )) , (2048));//dmasg_push_memory(DMASG_BASE, 1, ((u32)pucEthernetBuffer), xDataLength);
    80c0:	000016b7          	lui	a3,0x1
    80c4:	80068693          	addi	a3,a3,-2048 # 800 <CUSTOM2+0x7a5>
    80c8:	00048613          	mv	a2,s1
    80cc:	00040593          	mv	a1,s0
    80d0:	f8130537          	lui	a0,0xf8130
    80d4:	98cff0ef          	jal	ra,7260 <dmasg_input_memory>
	dmasg_output_stream(DMASG_BASE, channel, 0, 0, 0, 1); //dmasg_pop_stream(DMASG_BASE, DMASG_CHANNEL1, 0, 0, 0, 1);
    80d8:	00100793          	li	a5,1
    80dc:	00000713          	li	a4,0
    80e0:	00000693          	li	a3,0
    80e4:	00000613          	li	a2,0
    80e8:	00040593          	mv	a1,s0
    80ec:	f8130537          	lui	a0,0xf8130
    80f0:	9f8ff0ef          	jal	ra,72e8 <dmasg_output_stream>

	dmasg_direct_start(DMASG_BASE, channel,((u32)(FRAME_SIZE*4)), 1);//  dmasg_start(DMASG_BASE, DMASG_CHANNEL1, xDataLength, 0);
    80f4:	00100693          	li	a3,1
    80f8:	001fa637          	lui	a2,0x1fa
    80fc:	40060613          	addi	a2,a2,1024 # 1fa400 <__freertos_irq_stack_top+0x1a67d0>
    8100:	00040593          	mv	a1,s0
    8104:	f8130537          	lui	a0,0xf8130
    8108:	a0cff0ef          	jal	ra,7314 <dmasg_direct_start>
	bsp_printf("Start dma out \n\r");
    810c:	00052537          	lui	a0,0x52
    8110:	82050513          	addi	a0,a0,-2016 # 51820 <raw_table+0xe6a0>
    8114:	ad4ff0ef          	jal	ra,73e8 <bsp_printf>

}
    8118:	00c12083          	lw	ra,12(sp)
    811c:	00812403          	lw	s0,8(sp)
    8120:	00412483          	lw	s1,4(sp)
    8124:	01010113          	addi	sp,sp,16
    8128:	00008067          	ret

0000812c <dma_video_out_execution>:


void dma_video_out_execution(u32 *framebuffer , u32 *framebuffer2 ) {
    812c:	ff010113          	addi	sp,sp,-16
    8130:	00112623          	sw	ra,12(sp)
    8134:	00812423          	sw	s0,8(sp)
    8138:	00050413          	mv	s0,a0



	bsp_printf("stop dma out \n\r");
    813c:	00052537          	lui	a0,0x52
    8140:	8c450513          	addi	a0,a0,-1852 # 518c4 <raw_table+0xe744>
    8144:	aa4ff0ef          	jal	ra,73e8 <bsp_printf>
	dmasg_stop(DMASG_BASE, DMASG_CHANNEL_HDMI);
    8148:	00400593          	li	a1,4
    814c:	f8130537          	lui	a0,0xf8130
    8150:	a24ff0ef          	jal	ra,7374 <dmasg_stop>

	dmasg_interrupt_config(DMASG_BASE, DMASG_CHANNEL_HDMI, 0);  //Disable dmasg channel interrupt
    8154:	00000613          	li	a2,0
    8158:	00400593          	li	a1,4
    815c:	f8130537          	lui	a0,0xf8130
    8160:	a28ff0ef          	jal	ra,7388 <dmasg_interrupt_config>

    dmasg_input_memory(DMASG_BASE, DMASG_CHANNEL_HDMI, ((u32)(framebuffer )) , (256));//dmasg_push_memory(DMASG_BASE, 1, ((u32)pucEthernetBuffer), xDataLength);
    8164:	10000693          	li	a3,256
    8168:	00040613          	mv	a2,s0
    816c:	00400593          	li	a1,4
    8170:	f8130537          	lui	a0,0xf8130
    8174:	8ecff0ef          	jal	ra,7260 <dmasg_input_memory>
	dmasg_output_stream(DMASG_BASE, DMASG_CHANNEL_HDMI, 0, 0, 0, 1); //dmasg_pop_stream(DMASG_BASE, DMASG_CHANNEL1, 0, 0, 0, 1);
    8178:	00100793          	li	a5,1
    817c:	00000713          	li	a4,0
    8180:	00000693          	li	a3,0
    8184:	00000613          	li	a2,0
    8188:	00400593          	li	a1,4
    818c:	f8130537          	lui	a0,0xf8130
    8190:	958ff0ef          	jal	ra,72e8 <dmasg_output_stream>

	dmasg_direct_start(DMASG_BASE, DMASG_CHANNEL_HDMI,((u32)(FRAME_SIZE*4)), 1);//  dmasg_start(DMASG_BASE, DMASG_CHANNEL1, xDataLength, 0);
    8194:	00100693          	li	a3,1
    8198:	001fa637          	lui	a2,0x1fa
    819c:	40060613          	addi	a2,a2,1024 # 1fa400 <__freertos_irq_stack_top+0x1a67d0>
    81a0:	00400593          	li	a1,4
    81a4:	f8130537          	lui	a0,0xf8130
    81a8:	96cff0ef          	jal	ra,7314 <dmasg_direct_start>
	bsp_printf("Start dma out \n\r");
    81ac:	00052537          	lui	a0,0x52
    81b0:	82050513          	addi	a0,a0,-2016 # 51820 <raw_table+0xe6a0>
    81b4:	a34ff0ef          	jal	ra,73e8 <bsp_printf>

}
    81b8:	00c12083          	lw	ra,12(sp)
    81bc:	00812403          	lw	s0,8(sp)
    81c0:	01010113          	addi	sp,sp,16
    81c4:	00008067          	ret

000081c8 <dma_video_out_split4_frame>:




void dma_video_out_split4_frame(u32 * framebuffer1, u32 *framebuffer2, u32 *framebuffer3, u32 *framebuffer4, struct dmasg_descriptor* out_descriptor )
{
    81c8:	ff010113          	addi	sp,sp,-16
    81cc:	00112623          	sw	ra,12(sp)
    81d0:	00812423          	sw	s0,8(sp)
    81d4:	00912223          	sw	s1,4(sp)
    81d8:	00050493          	mv	s1,a0
    81dc:	00070413          	mv	s0,a4

		u32 descriptorPtr = 0;


		descriptorPtr = 0;
		for (int i=0; i<Ratio; i++)
    81e0:	00000713          	li	a4,0
		descriptorPtr = 0;
    81e4:	00000513          	li	a0,0
		for (int i=0; i<Ratio; i++)
    81e8:	0780006f          	j	8260 <dma_video_out_split4_frame+0x98>
					out_descriptor[descriptorPtr].status  = 0;
					descriptorPtr ++;
				}
				else
				{
					out_descriptor[descriptorPtr].control = (u32)((FRAME_SIZE*4/Ratio)-1)  | 1 << 30 | DMASG_DESCRIPTOR_CONTROL_NO_COMPLETION;
    81ec:	00551813          	slli	a6,a0,0x5
    81f0:	01040833          	add	a6,s0,a6
    81f4:	c00007b7          	lui	a5,0xc0000
    81f8:	3bf78793          	addi	a5,a5,959 # c00003bf <__freertos_irq_stack_top+0xbffac78f>
    81fc:	00f82223          	sw	a5,4(a6)
					out_descriptor[descriptorPtr].from    = (u32)(framebuffer2 + ((i/2)*2 *FRAME_SIZE/Ratio) );
    8200:	01f75793          	srli	a5,a4,0x1f
    8204:	00e787b3          	add	a5,a5,a4
    8208:	4017d793          	srai	a5,a5,0x1
    820c:	000fd8b7          	lui	a7,0xfd
    8210:	20088893          	addi	a7,a7,512 # fd200 <__freertos_irq_stack_top+0xa95d0>
    8214:	031787b3          	mul	a5,a5,a7
    8218:	000018b7          	lui	a7,0x1
    821c:	87088893          	addi	a7,a7,-1936 # 870 <CUSTOM2+0x815>
    8220:	0317d7b3          	divu	a5,a5,a7
    8224:	00279793          	slli	a5,a5,0x2
    8228:	00f587b3          	add	a5,a1,a5
    822c:	00f82423          	sw	a5,8(a6)
    8230:	00082623          	sw	zero,12(a6)
					out_descriptor[descriptorPtr].to      = 0;
    8234:	00000313          	li	t1,0
    8238:	00000393          	li	t2,0
    823c:	00682823          	sw	t1,16(a6)
    8240:	00782a23          	sw	t2,20(a6)
					out_descriptor[descriptorPtr].next    =  (u32)(out_descriptor+descriptorPtr+ 1);
    8244:	00150513          	addi	a0,a0,1
    8248:	00551793          	slli	a5,a0,0x5
    824c:	00f407b3          	add	a5,s0,a5
    8250:	00f82c23          	sw	a5,24(a6)
    8254:	00082e23          	sw	zero,28(a6)
					out_descriptor[descriptorPtr].status  = 0;
    8258:	00082023          	sw	zero,0(a6)
		for (int i=0; i<Ratio; i++)
    825c:	00170713          	addi	a4,a4,1
    8260:	00070793          	mv	a5,a4
    8264:	00001837          	lui	a6,0x1
    8268:	86f80813          	addi	a6,a6,-1937 # 86f <CUSTOM2+0x814>
    826c:	16e86863          	bltu	a6,a4,83dc <dma_video_out_split4_frame+0x214>
			if(i < Ratio/2)
    8270:	43700813          	li	a6,1079
    8274:	08f86063          	bltu	a6,a5,82f4 <dma_video_out_split4_frame+0x12c>
				if((i%2) == 0){
    8278:	0017f793          	andi	a5,a5,1
    827c:	f60798e3          	bnez	a5,81ec <dma_video_out_split4_frame+0x24>
					out_descriptor[descriptorPtr].control = (u32)((FRAME_SIZE*4/Ratio)-1)  | 1 << 30 | DMASG_DESCRIPTOR_CONTROL_NO_COMPLETION;
    8280:	00551813          	slli	a6,a0,0x5
    8284:	01040833          	add	a6,s0,a6
    8288:	c00007b7          	lui	a5,0xc0000
    828c:	3bf78793          	addi	a5,a5,959 # c00003bf <__freertos_irq_stack_top+0xbffac78f>
    8290:	00f82223          	sw	a5,4(a6)
					out_descriptor[descriptorPtr].from    = (u32)(framebuffer1 + ( (i/2)*2    *FRAME_SIZE/Ratio) );
    8294:	01f75793          	srli	a5,a4,0x1f
    8298:	00e787b3          	add	a5,a5,a4
    829c:	4017d793          	srai	a5,a5,0x1
    82a0:	000fd8b7          	lui	a7,0xfd
    82a4:	20088893          	addi	a7,a7,512 # fd200 <__freertos_irq_stack_top+0xa95d0>
    82a8:	031787b3          	mul	a5,a5,a7
    82ac:	000018b7          	lui	a7,0x1
    82b0:	87088893          	addi	a7,a7,-1936 # 870 <CUSTOM2+0x815>
    82b4:	0317d7b3          	divu	a5,a5,a7
    82b8:	00279793          	slli	a5,a5,0x2
    82bc:	00f487b3          	add	a5,s1,a5
    82c0:	00f82423          	sw	a5,8(a6)
    82c4:	00082623          	sw	zero,12(a6)
					out_descriptor[descriptorPtr].to      = 0;
    82c8:	00000313          	li	t1,0
    82cc:	00000393          	li	t2,0
    82d0:	00682823          	sw	t1,16(a6)
    82d4:	00782a23          	sw	t2,20(a6)
					out_descriptor[descriptorPtr].next    =  (u32)(out_descriptor+descriptorPtr+ 1);
    82d8:	00150513          	addi	a0,a0,1
    82dc:	00551793          	slli	a5,a0,0x5
    82e0:	00f407b3          	add	a5,s0,a5
    82e4:	00f82c23          	sw	a5,24(a6)
    82e8:	00082e23          	sw	zero,28(a6)
					out_descriptor[descriptorPtr].status  = 0;
    82ec:	00082023          	sw	zero,0(a6)
					descriptorPtr ++;
    82f0:	f6dff06f          	j	825c <dma_video_out_split4_frame+0x94>
					descriptorPtr ++;
				}
			}
			else
			{
				if((i%2) == 0){
    82f4:	0017f813          	andi	a6,a5,1
    82f8:	06081a63          	bnez	a6,836c <dma_video_out_split4_frame+0x1a4>
					out_descriptor[descriptorPtr].control = (u32)((FRAME_SIZE*4/Ratio)-1)  | 1 << 30 | DMASG_DESCRIPTOR_CONTROL_NO_COMPLETION;
    82fc:	00551813          	slli	a6,a0,0x5
    8300:	01040833          	add	a6,s0,a6
    8304:	c00008b7          	lui	a7,0xc0000
    8308:	3bf88893          	addi	a7,a7,959 # c00003bf <__freertos_irq_stack_top+0xbffac78f>
    830c:	01182223          	sw	a7,4(a6)
					out_descriptor[descriptorPtr].from    = (u32)(framebuffer3 + ( ((i-Ratio/2)/2)*2    *FRAME_SIZE/Ratio) );
    8310:	bc878793          	addi	a5,a5,-1080
    8314:	ffe7f793          	andi	a5,a5,-2
    8318:	0007f8b7          	lui	a7,0x7f
    831c:	90088893          	addi	a7,a7,-1792 # 7e900 <__freertos_irq_stack_top+0x2acd0>
    8320:	031787b3          	mul	a5,a5,a7
    8324:	000018b7          	lui	a7,0x1
    8328:	87088893          	addi	a7,a7,-1936 # 870 <CUSTOM2+0x815>
    832c:	0317d7b3          	divu	a5,a5,a7
    8330:	00279793          	slli	a5,a5,0x2
    8334:	00f607b3          	add	a5,a2,a5
    8338:	00f82423          	sw	a5,8(a6)
    833c:	00082623          	sw	zero,12(a6)
					out_descriptor[descriptorPtr].to      = 0;
    8340:	00000313          	li	t1,0
    8344:	00000393          	li	t2,0
    8348:	00682823          	sw	t1,16(a6)
    834c:	00782a23          	sw	t2,20(a6)
					out_descriptor[descriptorPtr].next    =  (u32)(out_descriptor+descriptorPtr+ 1);
    8350:	00150513          	addi	a0,a0,1
    8354:	00551793          	slli	a5,a0,0x5
    8358:	00f407b3          	add	a5,s0,a5
    835c:	00f82c23          	sw	a5,24(a6)
    8360:	00082e23          	sw	zero,28(a6)
					out_descriptor[descriptorPtr].status  = 0;
    8364:	00082023          	sw	zero,0(a6)
					descriptorPtr ++;
    8368:	ef5ff06f          	j	825c <dma_video_out_split4_frame+0x94>
				}
				else
				{
					out_descriptor[descriptorPtr].control = (u32)((FRAME_SIZE*4/Ratio)-1)  | 1 << 30 | DMASG_DESCRIPTOR_CONTROL_NO_COMPLETION;
    836c:	00551813          	slli	a6,a0,0x5
    8370:	01040833          	add	a6,s0,a6
    8374:	c00008b7          	lui	a7,0xc0000
    8378:	3bf88893          	addi	a7,a7,959 # c00003bf <__freertos_irq_stack_top+0xbffac78f>
    837c:	01182223          	sw	a7,4(a6)
					out_descriptor[descriptorPtr].from    = (u32)(framebuffer4 + (((i-Ratio/2)/2)*2 *FRAME_SIZE/Ratio) );
    8380:	bc878793          	addi	a5,a5,-1080
    8384:	ffe7f793          	andi	a5,a5,-2
    8388:	0007f8b7          	lui	a7,0x7f
    838c:	90088893          	addi	a7,a7,-1792 # 7e900 <__freertos_irq_stack_top+0x2acd0>
    8390:	031787b3          	mul	a5,a5,a7
    8394:	000018b7          	lui	a7,0x1
    8398:	87088893          	addi	a7,a7,-1936 # 870 <CUSTOM2+0x815>
    839c:	0317d7b3          	divu	a5,a5,a7
    83a0:	00279793          	slli	a5,a5,0x2
    83a4:	00f687b3          	add	a5,a3,a5
    83a8:	00f82423          	sw	a5,8(a6)
    83ac:	00082623          	sw	zero,12(a6)
					out_descriptor[descriptorPtr].to      = 0;
    83b0:	00000313          	li	t1,0
    83b4:	00000393          	li	t2,0
    83b8:	00682823          	sw	t1,16(a6)
    83bc:	00782a23          	sw	t2,20(a6)
					out_descriptor[descriptorPtr].next    =  (u32)(out_descriptor+descriptorPtr+ 1);
    83c0:	00150513          	addi	a0,a0,1
    83c4:	00551793          	slli	a5,a0,0x5
    83c8:	00f407b3          	add	a5,s0,a5
    83cc:	00f82c23          	sw	a5,24(a6)
    83d0:	00082e23          	sw	zero,28(a6)
					out_descriptor[descriptorPtr].status  = 0;
    83d4:	00082023          	sw	zero,0(a6)
					descriptorPtr ++;
    83d8:	e85ff06f          	j	825c <dma_video_out_split4_frame+0x94>
			}

		}


		out_descriptor[descriptorPtr-1].next    =  (u32)(out_descriptor);
    83dc:	080007b7          	lui	a5,0x8000
    83e0:	fff78793          	addi	a5,a5,-1 # 7ffffff <__freertos_irq_stack_top+0x7fac3cf>
    83e4:	00f507b3          	add	a5,a0,a5
    83e8:	00579793          	slli	a5,a5,0x5
    83ec:	00f407b3          	add	a5,s0,a5
    83f0:	0087ac23          	sw	s0,24(a5)
    83f4:	0007ae23          	sw	zero,28(a5)



		if(dmasg_busy(DMASG_BASE, DMASG_CHANNEL_HDMI))
    83f8:	00400593          	li	a1,4
    83fc:	f8130537          	lui	a0,0xf8130
    8400:	fa1fe0ef          	jal	ra,73a0 <dmasg_busy>
    8404:	0a051463          	bnez	a0,84ac <dma_video_out_split4_frame+0x2e4>
		{
			bsp_printf("stop dma out \n\r");
			dmasg_stop(DMASG_BASE, DMASG_CHANNEL_HDMI);
		}
		while(dmasg_busy(DMASG_BASE, DMASG_CHANNEL_HDMI));
    8408:	00400593          	li	a1,4
    840c:	f8130537          	lui	a0,0xf8130
    8410:	f91fe0ef          	jal	ra,73a0 <dmasg_busy>
    8414:	fe051ae3          	bnez	a0,8408 <dma_video_out_split4_frame+0x240>


		bsp_printf("stop dma out \n\r");
    8418:	00052537          	lui	a0,0x52
    841c:	8c450513          	addi	a0,a0,-1852 # 518c4 <raw_table+0xe744>
    8420:	fc9fe0ef          	jal	ra,73e8 <bsp_printf>
		dmasg_stop(DMASG_BASE, DMASG_CHANNEL_HDMI);
    8424:	00400593          	li	a1,4
    8428:	f8130537          	lui	a0,0xf8130
    842c:	f49fe0ef          	jal	ra,7374 <dmasg_stop>

		dmasg_interrupt_config(DMASG_BASE, DMASG_CHANNEL_HDMI, 0);  //Disable dmasg channel interrupt
    8430:	00000613          	li	a2,0
    8434:	00400593          	li	a1,4
    8438:	f8130537          	lui	a0,0xf8130
    843c:	f4dfe0ef          	jal	ra,7388 <dmasg_interrupt_config>

		dmasg_stop(DMASG_BASE, DMASG_CHANNEL_HDMI);
    8440:	00400593          	li	a1,4
    8444:	f8130537          	lui	a0,0xf8130
    8448:	f2dfe0ef          	jal	ra,7374 <dmasg_stop>
		dmasg_input_memory(DMASG_BASE, DMASG_CHANNEL_HDMI, ((u32)(framebuffer1 )) , (512));//dmasg_push_memory(DMASG_BASE, 1, ((u32)pucEthernetBuffer), xDataLength);
    844c:	20000693          	li	a3,512
    8450:	00048613          	mv	a2,s1
    8454:	00400593          	li	a1,4
    8458:	f8130537          	lui	a0,0xf8130
    845c:	e05fe0ef          	jal	ra,7260 <dmasg_input_memory>
		dmasg_output_stream(DMASG_BASE, DMASG_CHANNEL_HDMI, 0, 0, 0, 1); //dmasg_pop_stream(DMASG_BASE, DMASG_CHANNEL1, 0, 0, 0, 1);
    8460:	00100793          	li	a5,1
    8464:	00000713          	li	a4,0
    8468:	00000693          	li	a3,0
    846c:	00000613          	li	a2,0
    8470:	00400593          	li	a1,4
    8474:	f8130537          	lui	a0,0xf8130
    8478:	e71fe0ef          	jal	ra,72e8 <dmasg_output_stream>
		dmasg_linked_list_start(DMASG_BASE, DMASG_CHANNEL_HDMI,(u32)out_descriptor  );
    847c:	00040613          	mv	a2,s0
    8480:	00400593          	li	a1,4
    8484:	f8130537          	lui	a0,0xf8130
    8488:	eb5fe0ef          	jal	ra,733c <dmasg_linked_list_start>

		bsp_printf("Start dma out \n\r");
    848c:	00052537          	lui	a0,0x52
    8490:	82050513          	addi	a0,a0,-2016 # 51820 <raw_table+0xe6a0>
    8494:	f55fe0ef          	jal	ra,73e8 <bsp_printf>

}
    8498:	00c12083          	lw	ra,12(sp)
    849c:	00812403          	lw	s0,8(sp)
    84a0:	00412483          	lw	s1,4(sp)
    84a4:	01010113          	addi	sp,sp,16
    84a8:	00008067          	ret
			bsp_printf("stop dma out \n\r");
    84ac:	00052537          	lui	a0,0x52
    84b0:	8c450513          	addi	a0,a0,-1852 # 518c4 <raw_table+0xe744>
    84b4:	f35fe0ef          	jal	ra,73e8 <bsp_printf>
			dmasg_stop(DMASG_BASE, DMASG_CHANNEL_HDMI);
    84b8:	00400593          	li	a1,4
    84bc:	f8130537          	lui	a0,0xf8130
    84c0:	eb5fe0ef          	jal	ra,7374 <dmasg_stop>
    84c4:	f45ff06f          	j	8408 <dma_video_out_split4_frame+0x240>

000084c8 <mipi_i2c_init>:





void mipi_i2c_init(){
    84c8:	fd010113          	addi	sp,sp,-48
    84cc:	02112623          	sw	ra,44(sp)
    //I2C init
    I2c_Config i2c_mipi;
    i2c_mipi.samplingClockDivider = 3;
    84d0:	00300793          	li	a5,3
    84d4:	00f12423          	sw	a5,8(sp)
    i2c_mipi.timeout = I2C_CTRL_HZ/1000;
    84d8:	000187b7          	lui	a5,0x18
    84dc:	6a078793          	addi	a5,a5,1696 # 186a0 <raw_table3+0x5e8>
    84e0:	00f12623          	sw	a5,12(sp)
    i2c_mipi.tsuDat  = I2C_CTRL_HZ/2000000;
    84e4:	03200793          	li	a5,50
    84e8:	00f12823          	sw	a5,16(sp)

    i2c_mipi.tLow  = I2C_CTRL_HZ/800000;
    84ec:	07d00793          	li	a5,125
    84f0:	00f12a23          	sw	a5,20(sp)
    i2c_mipi.tHigh = I2C_CTRL_HZ/800000;
    84f4:	00f12c23          	sw	a5,24(sp)
    i2c_mipi.tBuf  = I2C_CTRL_HZ/400000;
    84f8:	0fa00793          	li	a5,250
    84fc:	00f12e23          	sw	a5,28(sp)

    i2c_applyConfig(I2C_CTRL_MIPI, &i2c_mipi);
    8500:	00810593          	addi	a1,sp,8
    8504:	f8017537          	lui	a0,0xf8017
    8508:	eadfe0ef          	jal	ra,73b4 <i2c_applyConfig>

}
    850c:	02c12083          	lw	ra,44(sp)
    8510:	03010113          	addi	sp,sp,48
    8514:	00008067          	ret

00008518 <hdmi_i2c_init>:
    i2c_hdmi.tHigh = I2C_CTRL_HZ/800000*2;
    i2c_hdmi.tBuf  = I2C_CTRL_HZ/400000*2;

 //   i2c_applyConfig(I2C_CTRL_HDMI, &i2c_hdmi);

}
    8518:	00008067          	ret

0000851c <trap_entry>:
.global  trap_entry
.align(2) //mtvec require 32 bits allignement
trap_entry:
  addi sp,sp, -16*4
    851c:	fc010113          	addi	sp,sp,-64
  sw x1,   0*4(sp)
    8520:	00112023          	sw	ra,0(sp)
  sw x5,   1*4(sp)
    8524:	00512223          	sw	t0,4(sp)
  sw x6,   2*4(sp)
    8528:	00612423          	sw	t1,8(sp)
  sw x7,   3*4(sp)
    852c:	00712623          	sw	t2,12(sp)
  sw x10,  4*4(sp)
    8530:	00a12823          	sw	a0,16(sp)
  sw x11,  5*4(sp)
    8534:	00b12a23          	sw	a1,20(sp)
  sw x12,  6*4(sp)
    8538:	00c12c23          	sw	a2,24(sp)
  sw x13,  7*4(sp)
    853c:	00d12e23          	sw	a3,28(sp)
  sw x14,  8*4(sp)
    8540:	02e12023          	sw	a4,32(sp)
  sw x15,  9*4(sp)
    8544:	02f12223          	sw	a5,36(sp)
  sw x16, 10*4(sp)
    8548:	03012423          	sw	a6,40(sp)
  sw x17, 11*4(sp)
    854c:	03112623          	sw	a7,44(sp)
  sw x28, 12*4(sp)
    8550:	03c12823          	sw	t3,48(sp)
  sw x29, 13*4(sp)
    8554:	03d12a23          	sw	t4,52(sp)
  sw x30, 14*4(sp)
    8558:	03e12c23          	sw	t5,56(sp)
  sw x31, 15*4(sp)
    855c:	03f12e23          	sw	t6,60(sp)
  call trap
    8560:	ea8fb0ef          	jal	ra,3c08 <trap>
  lw x1 ,  0*4(sp)
    8564:	00012083          	lw	ra,0(sp)
  lw x5,   1*4(sp)
    8568:	00412283          	lw	t0,4(sp)
  lw x6,   2*4(sp)
    856c:	00812303          	lw	t1,8(sp)
  lw x7,   3*4(sp)
    8570:	00c12383          	lw	t2,12(sp)
  lw x10,  4*4(sp)
    8574:	01012503          	lw	a0,16(sp)
  lw x11,  5*4(sp)
    8578:	01412583          	lw	a1,20(sp)
  lw x12,  6*4(sp)
    857c:	01812603          	lw	a2,24(sp)
  lw x13,  7*4(sp)
    8580:	01c12683          	lw	a3,28(sp)
  lw x14,  8*4(sp)
    8584:	02012703          	lw	a4,32(sp)
  lw x15,  9*4(sp)
    8588:	02412783          	lw	a5,36(sp)
  lw x16, 10*4(sp)
    858c:	02812803          	lw	a6,40(sp)
  lw x17, 11*4(sp)
    8590:	02c12883          	lw	a7,44(sp)
  lw x28, 12*4(sp)
    8594:	03012e03          	lw	t3,48(sp)
  lw x29, 13*4(sp)
    8598:	03412e83          	lw	t4,52(sp)
  lw x30, 14*4(sp)
    859c:	03812f03          	lw	t5,56(sp)
  lw x31, 15*4(sp)
    85a0:	03c12f83          	lw	t6,60(sp)
  addi sp,sp, 16*4
    85a4:	04010113          	addi	sp,sp,64
  mret
    85a8:	30200073          	mret

000085ac <__udivdi3>:
    85ac:	00068793          	mv	a5,a3
    85b0:	00060893          	mv	a7,a2
    85b4:	00050313          	mv	t1,a0
    85b8:	00058813          	mv	a6,a1
    85bc:	1a069663          	bnez	a3,8768 <__udivdi3+0x1bc>
    85c0:	0cc5fc63          	bgeu	a1,a2,8698 <__udivdi3+0xec>
    85c4:	00010737          	lui	a4,0x10
    85c8:	22e66463          	bltu	a2,a4,87f0 <__udivdi3+0x244>
    85cc:	010007b7          	lui	a5,0x1000
    85d0:	40f66a63          	bltu	a2,a5,89e4 <__udivdi3+0x438>
    85d4:	01865693          	srli	a3,a2,0x18
    85d8:	01800793          	li	a5,24
    85dc:	00049717          	auipc	a4,0x49
    85e0:	33470713          	addi	a4,a4,820 # 51910 <__clz_tab>
    85e4:	00d70733          	add	a4,a4,a3
    85e8:	00074703          	lbu	a4,0(a4)
    85ec:	00f707b3          	add	a5,a4,a5
    85f0:	02000713          	li	a4,32
    85f4:	40f70733          	sub	a4,a4,a5
    85f8:	00070c63          	beqz	a4,8610 <__udivdi3+0x64>
    85fc:	00e59833          	sll	a6,a1,a4
    8600:	00f557b3          	srl	a5,a0,a5
    8604:	00e618b3          	sll	a7,a2,a4
    8608:	0107e833          	or	a6,a5,a6
    860c:	00e51333          	sll	t1,a0,a4
    8610:	0108d613          	srli	a2,a7,0x10
    8614:	02c85533          	divu	a0,a6,a2
    8618:	01089693          	slli	a3,a7,0x10
    861c:	0106d693          	srli	a3,a3,0x10
    8620:	01035793          	srli	a5,t1,0x10
    8624:	02c87733          	remu	a4,a6,a2
    8628:	02a685b3          	mul	a1,a3,a0
    862c:	01071713          	slli	a4,a4,0x10
    8630:	00f76833          	or	a6,a4,a5
    8634:	00b87c63          	bgeu	a6,a1,864c <__udivdi3+0xa0>
    8638:	01180833          	add	a6,a6,a7
    863c:	fff50793          	addi	a5,a0,-1 # f8016fff <__freertos_irq_stack_top+0xf7fc33cf>
    8640:	01186463          	bltu	a6,a7,8648 <__udivdi3+0x9c>
    8644:	3eb86863          	bltu	a6,a1,8a34 <__udivdi3+0x488>
    8648:	00078513          	mv	a0,a5
    864c:	40b80833          	sub	a6,a6,a1
    8650:	02c85733          	divu	a4,a6,a2
    8654:	01031313          	slli	t1,t1,0x10
    8658:	01035313          	srli	t1,t1,0x10
    865c:	02c87833          	remu	a6,a6,a2
    8660:	02e686b3          	mul	a3,a3,a4
    8664:	01081813          	slli	a6,a6,0x10
    8668:	00686833          	or	a6,a6,t1
    866c:	00d87e63          	bgeu	a6,a3,8688 <__udivdi3+0xdc>
    8670:	01088833          	add	a6,a7,a6
    8674:	fff70793          	addi	a5,a4,-1
    8678:	01186663          	bltu	a6,a7,8684 <__udivdi3+0xd8>
    867c:	ffe70713          	addi	a4,a4,-2
    8680:	00d86463          	bltu	a6,a3,8688 <__udivdi3+0xdc>
    8684:	00078713          	mv	a4,a5
    8688:	01051513          	slli	a0,a0,0x10
    868c:	00e56533          	or	a0,a0,a4
    8690:	00000593          	li	a1,0
    8694:	00008067          	ret
    8698:	00061663          	bnez	a2,86a4 <__udivdi3+0xf8>
    869c:	00100713          	li	a4,1
    86a0:	02c758b3          	divu	a7,a4,a2
    86a4:	00010737          	lui	a4,0x10
    86a8:	12e8e863          	bltu	a7,a4,87d8 <__udivdi3+0x22c>
    86ac:	010007b7          	lui	a5,0x1000
    86b0:	34f8e063          	bltu	a7,a5,89f0 <__udivdi3+0x444>
    86b4:	0188d693          	srli	a3,a7,0x18
    86b8:	01800793          	li	a5,24
    86bc:	00049717          	auipc	a4,0x49
    86c0:	25470713          	addi	a4,a4,596 # 51910 <__clz_tab>
    86c4:	00d70733          	add	a4,a4,a3
    86c8:	00074683          	lbu	a3,0(a4)
    86cc:	00f686b3          	add	a3,a3,a5
    86d0:	02000793          	li	a5,32
    86d4:	40d787b3          	sub	a5,a5,a3
    86d8:	12079863          	bnez	a5,8808 <__udivdi3+0x25c>
    86dc:	01089e93          	slli	t4,a7,0x10
    86e0:	41158733          	sub	a4,a1,a7
    86e4:	0108df13          	srli	t5,a7,0x10
    86e8:	010ede93          	srli	t4,t4,0x10
    86ec:	00100593          	li	a1,1
    86f0:	01035793          	srli	a5,t1,0x10
    86f4:	03e75533          	divu	a0,a4,t5
    86f8:	03e77733          	remu	a4,a4,t5
    86fc:	03d506b3          	mul	a3,a0,t4
    8700:	01071713          	slli	a4,a4,0x10
    8704:	00f767b3          	or	a5,a4,a5
    8708:	00d7fc63          	bgeu	a5,a3,8720 <__udivdi3+0x174>
    870c:	011787b3          	add	a5,a5,a7
    8710:	fff50713          	addi	a4,a0,-1
    8714:	0117e463          	bltu	a5,a7,871c <__udivdi3+0x170>
    8718:	32d7e463          	bltu	a5,a3,8a40 <__udivdi3+0x494>
    871c:	00070513          	mv	a0,a4
    8720:	40d787b3          	sub	a5,a5,a3
    8724:	03e7d733          	divu	a4,a5,t5
    8728:	01031313          	slli	t1,t1,0x10
    872c:	01035313          	srli	t1,t1,0x10
    8730:	03e7f7b3          	remu	a5,a5,t5
    8734:	03d70eb3          	mul	t4,a4,t4
    8738:	01079793          	slli	a5,a5,0x10
    873c:	0067e7b3          	or	a5,a5,t1
    8740:	01d7fe63          	bgeu	a5,t4,875c <__udivdi3+0x1b0>
    8744:	00f887b3          	add	a5,a7,a5
    8748:	fff70693          	addi	a3,a4,-1
    874c:	0117e663          	bltu	a5,a7,8758 <__udivdi3+0x1ac>
    8750:	ffe70713          	addi	a4,a4,-2
    8754:	01d7e463          	bltu	a5,t4,875c <__udivdi3+0x1b0>
    8758:	00068713          	mv	a4,a3
    875c:	01051513          	slli	a0,a0,0x10
    8760:	00e56533          	or	a0,a0,a4
    8764:	00008067          	ret
    8768:	04d5e863          	bltu	a1,a3,87b8 <__udivdi3+0x20c>
    876c:	000107b7          	lui	a5,0x10
    8770:	04f6ea63          	bltu	a3,a5,87c4 <__udivdi3+0x218>
    8774:	010007b7          	lui	a5,0x1000
    8778:	26f6e063          	bltu	a3,a5,89d8 <__udivdi3+0x42c>
    877c:	0186d713          	srli	a4,a3,0x18
    8780:	01800813          	li	a6,24
    8784:	00049797          	auipc	a5,0x49
    8788:	18c78793          	addi	a5,a5,396 # 51910 <__clz_tab>
    878c:	00e787b3          	add	a5,a5,a4
    8790:	0007c703          	lbu	a4,0(a5)
    8794:	02000e13          	li	t3,32
    8798:	01070733          	add	a4,a4,a6
    879c:	40ee0e33          	sub	t3,t3,a4
    87a0:	100e1663          	bnez	t3,88ac <__udivdi3+0x300>
    87a4:	24b6ec63          	bltu	a3,a1,89fc <__udivdi3+0x450>
    87a8:	00c53533          	sltu	a0,a0,a2
    87ac:	00154513          	xori	a0,a0,1
    87b0:	00000593          	li	a1,0
    87b4:	00008067          	ret
    87b8:	00000593          	li	a1,0
    87bc:	00000513          	li	a0,0
    87c0:	00008067          	ret
    87c4:	0ff00793          	li	a5,255
    87c8:	24d7f063          	bgeu	a5,a3,8a08 <__udivdi3+0x45c>
    87cc:	0086d713          	srli	a4,a3,0x8
    87d0:	00800813          	li	a6,8
    87d4:	fb1ff06f          	j	8784 <__udivdi3+0x1d8>
    87d8:	0ff00713          	li	a4,255
    87dc:	00088693          	mv	a3,a7
    87e0:	ed177ee3          	bgeu	a4,a7,86bc <__udivdi3+0x110>
    87e4:	0088d693          	srli	a3,a7,0x8
    87e8:	00800793          	li	a5,8
    87ec:	ed1ff06f          	j	86bc <__udivdi3+0x110>
    87f0:	0ff00713          	li	a4,255
    87f4:	00060693          	mv	a3,a2
    87f8:	dec772e3          	bgeu	a4,a2,85dc <__udivdi3+0x30>
    87fc:	00865693          	srli	a3,a2,0x8
    8800:	00800793          	li	a5,8
    8804:	dd9ff06f          	j	85dc <__udivdi3+0x30>
    8808:	00f898b3          	sll	a7,a7,a5
    880c:	00d5d633          	srl	a2,a1,a3
    8810:	0108df13          	srli	t5,a7,0x10
    8814:	03e65e33          	divu	t3,a2,t5
    8818:	00f59733          	sll	a4,a1,a5
    881c:	00d556b3          	srl	a3,a0,a3
    8820:	00e6e733          	or	a4,a3,a4
    8824:	01089e93          	slli	t4,a7,0x10
    8828:	010ede93          	srli	t4,t4,0x10
    882c:	00f51333          	sll	t1,a0,a5
    8830:	01075593          	srli	a1,a4,0x10
    8834:	03e676b3          	remu	a3,a2,t5
    8838:	03ce87b3          	mul	a5,t4,t3
    883c:	01069693          	slli	a3,a3,0x10
    8840:	00b6e6b3          	or	a3,a3,a1
    8844:	00f6fe63          	bgeu	a3,a5,8860 <__udivdi3+0x2b4>
    8848:	011686b3          	add	a3,a3,a7
    884c:	fffe0613          	addi	a2,t3,-1
    8850:	1d16ee63          	bltu	a3,a7,8a2c <__udivdi3+0x480>
    8854:	1cf6fc63          	bgeu	a3,a5,8a2c <__udivdi3+0x480>
    8858:	ffee0e13          	addi	t3,t3,-2
    885c:	011686b3          	add	a3,a3,a7
    8860:	40f686b3          	sub	a3,a3,a5
    8864:	03e6d633          	divu	a2,a3,t5
    8868:	01071793          	slli	a5,a4,0x10
    886c:	0107d793          	srli	a5,a5,0x10
    8870:	03e6f6b3          	remu	a3,a3,t5
    8874:	02ce8533          	mul	a0,t4,a2
    8878:	01069713          	slli	a4,a3,0x10
    887c:	00f76733          	or	a4,a4,a5
    8880:	00a77e63          	bgeu	a4,a0,889c <__udivdi3+0x2f0>
    8884:	01170733          	add	a4,a4,a7
    8888:	fff60793          	addi	a5,a2,-1
    888c:	19176863          	bltu	a4,a7,8a1c <__udivdi3+0x470>
    8890:	18a77663          	bgeu	a4,a0,8a1c <__udivdi3+0x470>
    8894:	ffe60613          	addi	a2,a2,-2
    8898:	01170733          	add	a4,a4,a7
    889c:	010e1593          	slli	a1,t3,0x10
    88a0:	40a70733          	sub	a4,a4,a0
    88a4:	00c5e5b3          	or	a1,a1,a2
    88a8:	e49ff06f          	j	86f0 <__udivdi3+0x144>
    88ac:	00e657b3          	srl	a5,a2,a4
    88b0:	01c696b3          	sll	a3,a3,t3
    88b4:	00d7e6b3          	or	a3,a5,a3
    88b8:	00e5d333          	srl	t1,a1,a4
    88bc:	0106df13          	srli	t5,a3,0x10
    88c0:	03e357b3          	divu	a5,t1,t5
    88c4:	01069e93          	slli	t4,a3,0x10
    88c8:	010ede93          	srli	t4,t4,0x10
    88cc:	01c59833          	sll	a6,a1,t3
    88d0:	00e55733          	srl	a4,a0,a4
    88d4:	01076833          	or	a6,a4,a6
    88d8:	01085893          	srli	a7,a6,0x10
    88dc:	01c61633          	sll	a2,a2,t3
    88e0:	03e37333          	remu	t1,t1,t5
    88e4:	02fe85b3          	mul	a1,t4,a5
    88e8:	01031313          	slli	t1,t1,0x10
    88ec:	011368b3          	or	a7,t1,a7
    88f0:	00b8fe63          	bgeu	a7,a1,890c <__udivdi3+0x360>
    88f4:	00d888b3          	add	a7,a7,a3
    88f8:	fff78713          	addi	a4,a5,-1
    88fc:	12d8e463          	bltu	a7,a3,8a24 <__udivdi3+0x478>
    8900:	12b8f263          	bgeu	a7,a1,8a24 <__udivdi3+0x478>
    8904:	ffe78793          	addi	a5,a5,-2
    8908:	00d888b3          	add	a7,a7,a3
    890c:	40b888b3          	sub	a7,a7,a1
    8910:	03e8d733          	divu	a4,a7,t5
    8914:	01081813          	slli	a6,a6,0x10
    8918:	01085813          	srli	a6,a6,0x10
    891c:	03e8f8b3          	remu	a7,a7,t5
    8920:	02ee8333          	mul	t1,t4,a4
    8924:	01089893          	slli	a7,a7,0x10
    8928:	0108e5b3          	or	a1,a7,a6
    892c:	0065fe63          	bgeu	a1,t1,8948 <__udivdi3+0x39c>
    8930:	00d585b3          	add	a1,a1,a3
    8934:	fff70813          	addi	a6,a4,-1
    8938:	0cd5ee63          	bltu	a1,a3,8a14 <__udivdi3+0x468>
    893c:	0c65fc63          	bgeu	a1,t1,8a14 <__udivdi3+0x468>
    8940:	ffe70713          	addi	a4,a4,-2
    8944:	00d585b3          	add	a1,a1,a3
    8948:	01079793          	slli	a5,a5,0x10
    894c:	00010f37          	lui	t5,0x10
    8950:	00e7e7b3          	or	a5,a5,a4
    8954:	ffff0713          	addi	a4,t5,-1 # ffff <raw_table4+0x64df>
    8958:	00e7f6b3          	and	a3,a5,a4
    895c:	0107d893          	srli	a7,a5,0x10
    8960:	00e67733          	and	a4,a2,a4
    8964:	01065613          	srli	a2,a2,0x10
    8968:	02e68eb3          	mul	t4,a3,a4
    896c:	406585b3          	sub	a1,a1,t1
    8970:	02c686b3          	mul	a3,a3,a2
    8974:	010ed813          	srli	a6,t4,0x10
    8978:	02e88733          	mul	a4,a7,a4
    897c:	00e686b3          	add	a3,a3,a4
    8980:	00d806b3          	add	a3,a6,a3
    8984:	02c88633          	mul	a2,a7,a2
    8988:	00e6f463          	bgeu	a3,a4,8990 <__udivdi3+0x3e4>
    898c:	01e60633          	add	a2,a2,t5
    8990:	0106d893          	srli	a7,a3,0x10
    8994:	00c88633          	add	a2,a7,a2
    8998:	02c5ea63          	bltu	a1,a2,89cc <__udivdi3+0x420>
    899c:	00c58863          	beq	a1,a2,89ac <__udivdi3+0x400>
    89a0:	00078513          	mv	a0,a5
    89a4:	00000593          	li	a1,0
    89a8:	00008067          	ret
    89ac:	00010737          	lui	a4,0x10
    89b0:	fff70713          	addi	a4,a4,-1 # ffff <raw_table4+0x64df>
    89b4:	00e6f6b3          	and	a3,a3,a4
    89b8:	01069693          	slli	a3,a3,0x10
    89bc:	00eefeb3          	and	t4,t4,a4
    89c0:	01c51533          	sll	a0,a0,t3
    89c4:	01d686b3          	add	a3,a3,t4
    89c8:	fcd57ce3          	bgeu	a0,a3,89a0 <__udivdi3+0x3f4>
    89cc:	fff78513          	addi	a0,a5,-1
    89d0:	00000593          	li	a1,0
    89d4:	00008067          	ret
    89d8:	0106d713          	srli	a4,a3,0x10
    89dc:	01000813          	li	a6,16
    89e0:	da5ff06f          	j	8784 <__udivdi3+0x1d8>
    89e4:	01065693          	srli	a3,a2,0x10
    89e8:	01000793          	li	a5,16
    89ec:	bf1ff06f          	j	85dc <__udivdi3+0x30>
    89f0:	0108d693          	srli	a3,a7,0x10
    89f4:	01000793          	li	a5,16
    89f8:	cc5ff06f          	j	86bc <__udivdi3+0x110>
    89fc:	00000593          	li	a1,0
    8a00:	00100513          	li	a0,1
    8a04:	00008067          	ret
    8a08:	00068713          	mv	a4,a3
    8a0c:	00000813          	li	a6,0
    8a10:	d75ff06f          	j	8784 <__udivdi3+0x1d8>
    8a14:	00080713          	mv	a4,a6
    8a18:	f31ff06f          	j	8948 <__udivdi3+0x39c>
    8a1c:	00078613          	mv	a2,a5
    8a20:	e7dff06f          	j	889c <__udivdi3+0x2f0>
    8a24:	00070793          	mv	a5,a4
    8a28:	ee5ff06f          	j	890c <__udivdi3+0x360>
    8a2c:	00060e13          	mv	t3,a2
    8a30:	e31ff06f          	j	8860 <__udivdi3+0x2b4>
    8a34:	ffe50513          	addi	a0,a0,-2
    8a38:	01180833          	add	a6,a6,a7
    8a3c:	c11ff06f          	j	864c <__udivdi3+0xa0>
    8a40:	ffe50513          	addi	a0,a0,-2
    8a44:	011787b3          	add	a5,a5,a7
    8a48:	cd9ff06f          	j	8720 <__udivdi3+0x174>

00008a4c <_sbrk>:
    8a4c:	87018793          	addi	a5,gp,-1936 # 522a0 <heap_end.1518>
    8a50:	0007a783          	lw	a5,0(a5)
    8a54:	00078a63          	beqz	a5,8a68 <_sbrk+0x1c>
    8a58:	00a78533          	add	a0,a5,a0
    8a5c:	86a1a823          	sw	a0,-1936(gp) # 522a0 <heap_end.1518>
    8a60:	00078513          	mv	a0,a5
    8a64:	00008067          	ret
    8a68:	20018793          	addi	a5,gp,512 # 52c30 <_end>
    8a6c:	00a78533          	add	a0,a5,a0
    8a70:	86a1a823          	sw	a0,-1936(gp) # 522a0 <heap_end.1518>
    8a74:	00078513          	mv	a0,a5
    8a78:	00008067          	ret
