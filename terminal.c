#include "terminal.h"
#include "built-in-app.h"

int expr(char *line, bool *success);
static int cmd_help(char *args);
static int cmd_hello(char *args);
static int cmd_time(char *args);
static int cmd_fib(char *args);
static int cmd_echo(char *args);
static int cmd_expr(char *args);

static struct
{
  const char *name;
  const char *description;
  int (*handler)(char *);
} cmd_table[] = {
  {"help", "Print information about supported commands", cmd_help},
  {"hello", "Print Hello world and welcome info", cmd_hello},
  {"time", "Print current time from boot time", cmd_time},
  {"fib", "Calculate fibonaci number", cmd_fib},
  {"echo", "Simplified echo command as Linux version", cmd_echo},
  {"expr", "Simple calculator", cmd_expr}
};
#define NR_CMD ARRLEN(cmd_table)

static int cmd_help(char *arg) {
  /* extract the first argument */
  /* strtok stores the target string, so NULL arg here must follow the original strtok(str) somewhere*/
  //char *arg = strtok(str, " ");
  int i;

  if (arg == NULL)
  {
    /* no argument given */
    for (i = 0; i < NR_CMD; i++)
    {
      printf("%s - %s\n", cmd_table[i].name, cmd_table[i].description);
    }
  }
  else
  {
    for (i = 0; i < NR_CMD; i++)
    {
      if (strcmp(arg, cmd_table[i].name) == 0)
      {
        printf("%s - %s\n", cmd_table[i].name, cmd_table[i].description);
        return 0;
      }
    }
    printf("Unknown command '%s'\n", arg);
  }
  return 0;
}

static int cmd_hello(char *args) {
  printf("Hello, World!\n");
  printf("Welcome to Untitled computer!\n");
  return 0;
}

static int cmd_time(char *args) {
  uint32_t cur_time = get_time();
  uint32_t s = (cur_time / 1000000) % 60;
  uint32_t m = ((cur_time / 1000000) / 60) % 60;
  uint32_t h = ((cur_time / 1000000) / 3600) % 24;
  printf("Time after boot: %dh%dm%ds\n", (int)h, (int)m, (int)s);
  return 0;
}

static int cmd_fib(char *args) {
  if (args == NULL) {
    fib_help();
    return -1;
  }
  printf("Result: %d\n", fib_cal(atoi(args)));
  return 0;
}

static int cmd_echo(char *args) {
  printf("%s\n", args);
  return 0;
}

static int cmd_expr(char *args) {
  bool success = false;
  int ret = expr(args, &success);
  if (!success) {
    printf("Bad expression!\n");
    return -1;
  }
  printf("Result: %d\n", ret);
  return 0;
}

static void shell_prompt() {
  clear_line();
  set_color(0x0f0, 0x000);
  printf("(remu):");
  set_color(0xfff, 0x000);
}

static void exec(char *str) {
  char *str_end = str + strlen(str);
  char cmd[32];
  int len = 0;
  int has_content = 0;
  memset(cmd, 0, sizeof(cmd));

  /* extract cmd */
  while(str < str_end && *str && *str != ' ') {
    cmd[len++] = *str;
    str++;
  }

  /* check existence of commands */
  for (int i = 0; i < strlen(cmd); ++i) {
    if (cmd[i] != ' ') has_content = 1;
  }
  if (!has_content) return;

  /* extract args */
  char *args = str + 1;
  if (args >= str_end) {
    args = NULL;
  }

  /* execute the command */
  int i;
  for (i = 0; i < NR_CMD; i ++) {
    if (strcmp(cmd, cmd_table[i].name) == 0) {
      int res = cmd_table[i].handler(args);
      if (res < 0) return; 
      if (res > 0) printf("Invalid command format!\n");
      break;
    }
  }
  if (i == NR_CMD) { printf("Unknown command '%s'\n", cmd); }
}

static char buf[256]; // stores the command

void shell_run() {
  uint32_t bt = get_time();
  int cursor = 0;
  while(1) {
    shell_prompt();
    memset(buf, 0, sizeof(buf));
    int cur = 0;
    while(1) {
      /* cursor */
      uint32_t ct = get_time();
      if (ct - bt >= 500000) {
        bt = ct;
        cursor = !cursor;
      }
      if (cursor) blink(1);
      else blink(0);

      /* read key */
      char key = get_key();
      if (key == 0) continue;
      if (key == 10) {
        putch(key);
        exec(buf);
        break;
      }
      if (key == 20) {
        putch(key);
        continue;
      }
      if (key == 8) {
        putch(key);
        if (cur) buf[--cur] = 0;
        else buf[cur] = 0;
        continue;
      }
      putch(key);
      buf[cur++] = key;
    }
  }
}