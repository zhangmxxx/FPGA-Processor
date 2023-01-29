#include "klib.h"
#include "sys.h"
#include <stdarg.h>

#define BUF_SIZE 128

#define OUTPUT_BUF_SIZE 4096

/* *buf++ = x; *buf = '\0'  : 下一次buf写入时覆盖\0, 没有问题*/

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

// to support gcc translation of printf(\n) to puts
int puts(const char *str) {
  putstr(str);
  putch('\n');
}

int printf(const char *fmt, ...) {
  va_list args;
  va_start(args, fmt);
  char buf[OUTPUT_BUF_SIZE];
  memset(buf, 0, sizeof(buf));
  vsprintf(buf, fmt, args);
  va_end(args);
  int len = strlen(buf);
  for (int i = 0; i < len; ++i){
    putch(buf[i]);
  }
  return strlen(buf);
}

int vsprintf(char *out, const char *fmt, va_list args) {
  char *rec = out;
  char buf[BUF_SIZE];
  memset(buf, 0, sizeof(buf));
  while (*fmt != '\0'){
    if (*fmt == '%'){
      fmt++;
      switch(*fmt){
        case 'd': {
          int n = va_arg(args, int);
          if (n < 0){
            *out++ = '-';
            n = -n;
            *out = '\0';
          }
          memset(buf, 0, sizeof(buf));
          itoa(n, buf);
          int len = strlen(buf);
          for (int i = len - 1; i >= 0; --i){
            *out++ = buf[i];
          }
          *out = '\0';
          break;
        }
        case 's': {
          char *str = va_arg(args, char*);
          strcpy(out, str);
          out += strlen(str);
          break;
        }
        case 'c': {
          int c = va_arg(args, int);
          *out++ = c;
          break;
        }
        case 'x': case 'p': {
          int n = va_arg(args, int);
          memset(buf, 0, sizeof(buf));
          xtoa(n, buf);
          int len = strlen(buf);
          for (int i = len - 1; i >= 0; --i){
            *out++ = buf[i];
          }
          *out = '\0';
          break;
        }
      }
    }
    else {
      *out = *fmt;
      out++;
      *out = '\0';
    }
    fmt++;
  }
  return strlen(rec);
}


int sprintf(char *out, const char *fmt, ...) {
  va_list args;
  va_start(args, fmt);
  int t = vsprintf(out, fmt, args);
  va_end(args);
  return t;
}



int snprintf(char *out, size_t n, const char *fmt, ...) {
  va_list args;
  va_start(args, fmt);
  int t = vsnprintf(out, n, fmt, args);
  va_end(args);
  return t;
}

/* return the length of the expanded string*/
/* use buffer to expand fully, than copy it into the out*/
int vsnprintf(char *out, size_t n, const char *fmt, va_list args) {
  char buf[OUTPUT_BUF_SIZE];
  vsprintf(buf, fmt, args);
  strncpy(out, buf, n);
  *out = '\0';
  return strlen(buf);
}
