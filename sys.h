#ifndef SYS_H
#define SYS_H

#include <stdint.h>

#define VGA_START    0x00200000
#define VGA_LINE_O   0x00210000
#define KBD_PORT     0x00300000
#define KBD_INFO     0x00310000
#define CLK_PORT     0x00400000


#define VGA_MAXLINE  30
#define LINE_MASK    0x3f
#define VGA_MAXCOL   70
#define TAIL_MASK    0x01f
#define HEAD_MASK    0x3e0

void putstr(char* str);
void putch(char ch);
void blink(int cursor); // to be removed from sys.c
char get_key();
uint32_t get_time();

void vga_init();
void kbd_init();
void timer_init();

#endif

/* def for fpga related port; declaration of basic high-level api*/

