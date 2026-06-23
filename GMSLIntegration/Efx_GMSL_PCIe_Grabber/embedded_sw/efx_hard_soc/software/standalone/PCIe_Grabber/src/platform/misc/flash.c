#include "bsp.h"
#include "project.h"
#include "soc.h"
#include "spi.h"
#include "spiFlash.h"

static void spiFlash_enter4ByteAddr_(u32 spi, u32 cs, u8 mid) {
/*  switch (mid) {
  case 0xC2:
    // spi_write(spi, 0xE9);
    break;
  case 0x9D:
    // spi_write(spi, 0x29);
    spi_write(spi, 0xB7);
    break;
  default:
    break;
  }*/

  spi_write(spi, 0xB7);

}



static void spiFlash_enter4ByteAddr(u32 spi, u32 cs) {
  spiFlash_select(spi, cs);
  u8 mid = spiFlash_manufacturer_id_(spi, cs);
  spiFlash_diselect(spi, cs);
  spi_waitXferBusy(spi);
  spiFlash_select(spi, cs);
  spiFlash_enter4ByteAddr_(spi, cs, mid);
  spiFlash_diselect(spi, cs);
  spi_waitXferBusy(spi);
}

void initSPI(u32 spi) {
  spiFlash_init(spi, 0);
  spiFlash_wake(spi, 0);
  // spiFlash_exit4ByteAddr(spi, 0);
  spiFlash_enter4ByteAddr(spi, 0);
}

/// Fork of BSP's `spiFlash_f2m_` to do 4-byte addressing, such that NOR flash
/// addresses beyond 24-bit can be correctly accessed.
void spiFlash_f2m_4B(u32 spi, u32 flashAddress, u32 memoryAddress, u32 size) {
  spi_write(spi, 0x0B);
  // spi_write(spi, 0x0C);
  spi_write(spi, flashAddress >> 24); // Added this line for 4-byte addressing.
  spi_write(spi, flashAddress >> 16);
  spi_write(spi, flashAddress >> 8);
  spi_write(spi, flashAddress >> 0);
  spi_write(spi, 0);
  uint8_t *ram = (uint8_t *)memoryAddress;
  for (u32 idx = 0; idx < size; idx++) {
    u8 value = spi_read(spi);
    *ram++ = value;
  }
}

