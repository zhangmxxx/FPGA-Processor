#include "sys.h"
#include "key-def.h"
#include "terminal.h"

/* vga */
char *vga_start = (char *) VGA_START;
char *col_start = (char *) COL_START;
int  *line_offset_port = (int *) VGA_LINE_O;
int   v_pos = 0;
int   h_pos = 0;
int   line_offset = 0;
uint32_t  front_color = 0xfff;
uint32_t  back_color  = 0x000;


/* keyboard */
uint32_t *kbd_port = (uint32_t *) KBD_PORT;
uint32_t *kbd_info = (uint32_t *) KBD_INFO;
uint32_t  capslock = 0;

/* clock*/
uint32_t *clk_port = (uint32_t *) CLK_PORT;
uint32_t  boot_time = 0;

/* vga */
void set_color(uint32_t fc, uint32_t bc) {
  front_color = fc;
  back_color  = bc;
}

void draw_ch(char ch, int h, int v) {
  uint32_t color = (front_color << 12) | back_color;
  uint32_t *idx = (uint32_t *)(col_start + (h << 7) + v + line_offset);
  vga_start[(h << 7) + v + line_offset] = ch;
  *idx = color; // 4-byte for one address here. (uint32_t *)++ is not used
}

void vga_init() {
  v_pos = 0;
  h_pos = 0;
  *line_offset_port = 0;
  for (int i = 0; i < VMEM_MAXLINE; ++i) {
    for (int j = 0; j < VGA_MAXCOL; ++j) {
      draw_ch(0, j, i);
    }
  }
}

void blink(int cursor) {
  if (cursor) draw_ch(221, h_pos, v_pos);
  else draw_ch(0, h_pos, v_pos);
}

void putch(char ch) {
  // backspace
  if (ch == 8) {
    draw_ch(0, h_pos, v_pos); // clear cursor if it exists, cur_pos should not contain valid char
    if (h_pos) h_pos--;
    else {
      if (v_pos) {
        v_pos--;
        h_pos = VGA_MAXCOL - 1;
      }
      else {
        if (line_offset) {
          line_offset--;
          *line_offset_port = line_offset;
          h_pos = VGA_MAXCOL - 1;
        }
        else {
          ;
        }
      }
    }
    draw_ch(0, h_pos, v_pos);
    return;
  }

  // enter
  if (ch == 10) {
    draw_ch(0, h_pos, v_pos); // clear cursor if it exists
    if (v_pos + 1 < VGA_MAXLINE) {
      v_pos++;
      h_pos = 0;
    }
    else {
      line_offset++;
      *line_offset_port = line_offset;
      h_pos = 0;
    }
    clear_line();
    return;
  }
  
  // capslock 
  if (ch == 20) {
    capslock = !capslock;
    return;
  }

  draw_ch(ch, h_pos, v_pos);
  h_pos++;
  if (h_pos >= VGA_MAXCOL) {
    if (v_pos + 1 < VGA_MAXLINE) {
      v_pos++;
      h_pos = 0;
    }
    else {
      line_offset++;
      *line_offset_port = line_offset;
      h_pos = 0;
    }
  }
  return;
}

void putstr(char *str) {
  for (char *p = str; *p != 0; ++p) { 
    putch(*p);
  }
}

void clear_line() {
  for (int i = 0; i < VGA_MAXCOL; ++i) {
    draw_ch(0, i, v_pos);
  }
}

/* keyboard */
void kbd_init() {
  capslock = 0;
}

uint8_t get_keycode() {
  uint32_t info = *((uint32_t *)kbd_info);
  int head = (info & HEAD_MASK) >> 5;
  int tail = (info & TAIL_MASK);
  if (head == tail) return (uint8_t)0;
  uint8_t keycode = (uint8_t)(*kbd_port);
  *kbd_port = 311; // write to update head
  return keycode;
}

char get_key() {
  uint8_t keycode = get_keycode();
  if (keycode == 0) return 0;
  switch (capslock) {
    case 0:
      return key_id2ascii[keycode2key_id[keycode]];
    break;
    case 1:
      return key_id2ascii_shift[keycode2key_id[keycode]];
    break;
    default:
      return 0;
  }
}

/* clock */
void timer_init() {
  boot_time = (*clk_port);
}

uint32_t get_time() {
  return (*clk_port) - boot_time;
}
