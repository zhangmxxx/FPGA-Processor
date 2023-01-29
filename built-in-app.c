#include "built-in-app.h"

static int fib[50];
/* fib*/
void fib_help() {
  printf("Invalid command format, Type fib (number).\n"); 
}

int fib_cal(int n) {
  if (n > 48) {
    //printf("Overflow for int\n");
    return -1;
  }

  fib[0] = 0;
  fib[1] = 1;
  for (int i = 2; i <= n; ++i) {
    fib[i] = fib[i - 1] + fib[i - 2];
  }
  return fib[n];
}