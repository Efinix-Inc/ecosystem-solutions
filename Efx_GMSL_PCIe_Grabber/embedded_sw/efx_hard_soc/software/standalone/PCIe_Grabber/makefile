PROJ_NAME=PCIe_Grabber
STANDALONE = ..
DEBUG=no
DEBUG_OG=no
BENCH=yes

LDSCRIPT ?= ${BSP_PATH}/linker/default.ld
CFLAGS+=-DSMP

SRCS = $(wildcard src/*.c) \
       $(wildcard src/*.cc) \
       $(wildcard src/*.cpp) \
       $(wildcard src/*.S) \
       $(wildcard src/*/*.c) \
       $(wildcard src/*/*/*.c) \
       $(wildcard src/*/*/*/*.c) \
       ${STANDALONE}/common/start.S  \
       ${STANDALONE}/common/trap.S 

       
CFLAGS += -Isrc -Isrc/lib -Isrc/platform -Isrc/platform/interrupt -Isrc/platform/misc \
		-Isrc/platform/driver -Isrc/platform/vision \
		-funroll-loops -mdiv \
		-ffunction-sections \
		-fdata-sections \
		-fno-common \
		-fomit-frame-pointer \
		-ffreestanding \
		-fno-builtin \
		-g \
		 
		
CXXFLAGS +=-std=c++11 \
		-fstrict-aliasing \
		-fno-rtti \
		-fno-exceptions \
		-fno-threadsafe-statics\
		-fmessage-length=0 
				 
include ${STANDALONE}/common/bsp.mk
include ${STANDALONE}/common/riscv64-unknown-elf.mk
include ${STANDALONE}/common/ecnn_standalone.mk
