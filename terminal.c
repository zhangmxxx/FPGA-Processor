#include "terminal.h"
#include "built-in-app.h"


#define ARRLEN(list) (sizeof(list) / sizeof(list[0]))
static int cmd_help(char *args);
static int cmd_hello(char *args);
static int cmd_time(char *args);
static int cmd_fib(char *args);
static int cmd_echo(char *args);

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
  {"echo", "Simplified echo command as Linux version", cmd_echo}
};
#define NR_CMD ARRLEN(cmd_table)

static int cmd_help(char *str) {
  /* extract the first argument */
  /* strtok stores the target string, so NULL arg here must follow the original strtok(str) somewhere*/
  //char *arg = strtok(str, " ");
  char *arg = str;
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
  uint32_t s = cur_time / 1000000;
  uint32_t m = s / 60;
  uint32_t h = m / 60;
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

