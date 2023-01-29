#include "sys.h"
#include "klib.h"

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
  int num = 114514;
  printf("%s-%s", hello, hello);
  printf("I love lxt\n");
  printf("%d\n", num);
  uint32_t bt = get_time();
  int cursor = 0;
  while (1){
    uint32_t ct = get_time();
    if (ct - bt >= 500000) {
      bt = ct;
      cursor = !cursor;
    }
    if (cursor) blink(1);
    else blink(0);
    char cur_key = get_key();
    if (cur_key) putch(cur_key);
  }

  return 0;
}
