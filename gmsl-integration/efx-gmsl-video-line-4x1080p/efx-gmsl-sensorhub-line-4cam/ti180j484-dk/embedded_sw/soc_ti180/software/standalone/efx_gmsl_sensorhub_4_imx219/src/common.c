////////////////////////////////////////////////////////////////////////////
//           _____
//          / _______    Copyright (C) 2013-2022 Efinix Inc. All rights reserved.
//         / /       \
//        / /  ..    /
//       / / .'     /
//    __/ /.'      /     Description:
//   __   \       /       common functions
//  /_/ /\ \_____/ /
// ____/  \_______/
//
// ***********************************************************************

#include <stdarg.h>
#include <stdint.h>

#include "bsp.h"

#include "common.h"


/************************** Function File ***************************/
void Reg_Out32(u32 addr,u32 data)
{
    write_u32(data,addr);
}

u32 Reg_In32(u32 addr)
{
    return read_u32(addr);
}

/*

 void bsp_printf_c(int c)
{
    putchar(c);
}

void bsp_printf_s(char *p)
{
    while (*p)
        putchar(*(p++));
}

void bsp_printf_d(int val)
{
    char buffer[32];
    char *p = buffer;
    if (val < 0) {
        bsp_printf_c('-');
        val = -val;
    }
    while (val || p == buffer) {
        *(p++) = '0' + val % 10;
        val = val / 10;
    }
    while (p != buffer)
        bsp_printf_c(*(--p));
}

void bsp_printf_x(int val)
{
	int i,digi=2;

	for(i=0;i<8;i++)
	{
		if((val & (0xFFFFFFF0 <<(4*i))) == 0)
		{
			digi=i+1;
			break;
		}
	}

	print_hex(val,digi);
}


void bsp_printf(const char *format, ...)
{
    int i;
    va_list ap;

    va_start(ap, format);

    for (i = 0; format[i]; i++)
        if (format[i] == '%') {
            while (format[++i]) {
                if (format[i] == 'c') {
                    bsp_printf_c(va_arg(ap,int));
                    break;
                }
                if (format[i] == 's') {
                    bsp_printf_s(va_arg(ap,char*));
                    break;
                }
                if (format[i] == 'd') {
                    bsp_printf_d(va_arg(ap,int));
                    break;
                }
                if (format[i] == 'x') {
					bsp_printf_x(va_arg(ap,int));
					break;
				}
            }
        } else
            bsp_printf_c(format[i]);

    va_end(ap);
}
*/

int assert(int cond){
    if(!cond) {
        uart_writeStr(BSP_UART_TERMINAL, " Assert failure !\n");
        return 1;
        //while(1);
    }
    return 0;
}

int bsp_puts(char *s){
  while (*s) {
    putchar(*s);
    s++;
  }
  putchar('\n');
  return 0;
}

int putchar(int c){
    bsp_putChar(c);
    return c;
}

void print_hex(uint32_t val, uint32_t digits)
{
	for (int i = (4*digits)-4; i >= 0; i -= 4)
		uart_write(BSP_UART_TERMINAL, "0123456789ABCDEF"[(val >> i) % 16]);
}

