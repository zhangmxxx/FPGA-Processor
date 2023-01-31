#include "sys.h"
#include "klib.h"
#include "terminal.h"

char hello[]="Hello World 2022!\n";

int main();

//setup the entry point
void entry()
{
  asm("lui sp, 0x00120"); //set stack to high address of the dmem
  asm("addi sp, sp, -4");
  main();
}

int main()
{
  vga_init();
  kbd_init();
  timer_init();
  led_write(15);
  seg_write(0x1234abcf);
  shell_run();
  return 0;
}
