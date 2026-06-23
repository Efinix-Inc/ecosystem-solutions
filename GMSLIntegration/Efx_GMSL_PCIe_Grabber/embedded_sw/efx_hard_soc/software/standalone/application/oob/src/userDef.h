////////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2013-2025 Efinix Inc. All rights reserved.
// donut.c by Andy Sloane (@a1k0n)
// https://gist.github.com/a1k0n/8ea6516b4946ab36348fb61703dc3194
////////////////////////////////////////////////////////////////////////////////

#include "soc.h"

#define STACK_PER_HART 	4096
#define HART_COUNT 		4

#ifdef SYSTEM_GPIO_0_IO_CTRL
    #define GPIO0   SYSTEM_GPIO_0_IO_CTRL
#else
    #error "GPIO required in soft logic block .."
#endif
#ifdef SIM
    #define LOOP_UDELAY 100
#else
    #define LOOP_UDELAY 500000
#endif
