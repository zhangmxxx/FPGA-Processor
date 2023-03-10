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
  kbd_init();
  timer_init();
  menu_run();
  shell_run();
  return 0;
}
