SHELL = /bin/bash

TARGET_MODULE:=pcie_dma

FPU_CFLAGS += -mhard-float
FPU_CFLAGS += -msse -msse2

CFLAGS_edma_misc.o += $(FPU_CFLAGS)

ifneq ($(KERNELRELEASE),)
	$(TARGET_MODULE)-objs := edma_pci.o edma_misc.o edma_core.o edma_cdev.o  cdev_bypass.o cdev_events.o cdev_ctrl.o cdev_sgdma.o edma_thread.o
	obj-m := $(TARGET_MODULE).o
else
	BUILDSYSTEM_DIR:=/lib/modules/$(shell uname -r)/build
	PWD:=$(shell pwd)
all :
	$(MAKE) -C $(BUILDSYSTEM_DIR) M=$(PWD) modules

clean:
	$(MAKE) -C $(BUILDSYSTEM_DIR) M=$(PWD) clean
	@/bin/rm -f *.ko modules.order *.mod.c *.o *.o.ur-safe .*.o.cmd

install: all
	$(MAKE) -C $(BUILDSYSTEM_DIR) M=$(PWD) modules_install
endif

