#include "klib.h"
#include "sys.h"
#include <stdarg.h>

#define BUF_SIZE 128

#define OUTPUT_BUF_SIZE 4096

/* *buf++ = x; *buf = '\0'  : 下一次buf写入时覆盖\0, 没有问题*/

static inline int asni_readnum(char **fmt) {
  int ret = 0;
  while (*(*fmt) != ';' && *(*fmt) != 'm') {
    ret *= 10;
    ret += *(*fmt) - '0';
    (*fmt)++; // should stop at `;' or `m'
  }
  return ret;
}

// to support gcc translation of printf(\n) to puts
int puts(const char *str) {
  putstr(str);
  putch('\n');
  return strlen(str);
}

int printf(const char *fmt, ...) {
  va_list args;
  va_start(args, fmt);
  char buf[OUTPUT_BUF_SIZE];
  memset(buf, 0, sizeof(buf));
  vsprintf(buf, fmt, args);
  va_end(args);
  char *p = buf;
  while (*p != '\0') {
    if (*p == '\33') {
      p++; // point to [
      do { p++; asni_handle(asni_readnum(&p)); } while(*p != 'm');
      p++;
    }
    else {
      putch(*p);
      p++;
    }
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
