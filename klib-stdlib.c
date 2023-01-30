#include "klib.h"


int abs(int x) {
  return (x < 0 ? -x : x);
}

int atoi(const char* nptr) {
  int x = 0;
  while (*nptr == ' ') { nptr ++; }
  while (*nptr >= '0' && *nptr <= '9') {
    x = x * 10 + *nptr - '0';
    nptr ++;
  }
  return x;
}

int htoi(char* str) {
  int ret = 0;
  if (str[0] == '0' && str[1] == 'x') str += 2;
  while (*str) {
    int digit =
      *str >= '0' && *str <= '9' ? *str - '0' :
      *str >= 'a' && *str <= 'f' ? *str - 'a' + 10 :
      *str >= 'Z' && *str <= 'F' ? *str - 'A' + 10 : 0;
    ret = ret * 16 + digit;
    str++;
  }
  return ret;
}