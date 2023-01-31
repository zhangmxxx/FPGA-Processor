#ifndef SYS_H
#define SYS_H

#include <stdint.h>
#define word_t uint32_t

#define VGA_START    0x00200000
#define VGA_LINE_O   0x00210000
#define COL_START    0x00220000
#define KBD_PORT     0x00300000
#define KBD_INFO     0x00310000
#define CLK_PORT     0x00400000


#define VGA_MAXLINE  30
#define VGA_MAXCOL   70
#define VMEM_MAXLINE 128
#define LINE_MASK    0x3f
#define TAIL_MASK    0x01f
#define HEAD_MASK    0x3e0


#define SYS_BLACK   0x000
#define SYS_RED     0xf00
#define SYS_GREEN   0x0f0
#define SYS_YELLOW  0xff0
#define SYS_BLUE    0x00f
#define SYS_MAGENTA 0xf0f
#define SYS_CYAN    0x0ff
#define SYS_WHITE   0xfff


void putstr(char* str);
void putch(char ch);
void clear_line();        
void blink(int cursor); 
void set_color(uint32_t fc, uint32_t bc);
void asni_handle(int code);
char get_key();
uint32_t get_time();

void vga_init();
void kbd_init();
void timer_init();

#endif

/* def for fpga related port; declaration of basic high-level api*/

