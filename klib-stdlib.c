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

void itoa(unsigned int n, char * buf) {
  if (n == 0) {
    *buf++ = '0';
    *buf = '\0';
    return;
  }
  while(n){
    *buf++ = n % 10 + '0';
    n /= 10;
  }
  *buf = '\0';
}

void xtoa(unsigned int n, char *buf) {
  if (n == 0) {
    *buf++ = '0';
    *buf = '\0';
    return;
  }
  while(n){
    int t = n % 16;
    if (t < 10) {
      *buf++ = t + '0';
    }
    else {
      *buf++ = t - 10 + 'a';
    }
    n /= 16;
  }
  *buf = '\0';
}