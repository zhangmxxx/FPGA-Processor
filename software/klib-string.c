#include "klib.h"
#include <stdint.h>

#if !defined(__ISA_NATIVE__) || defined(__NATIVE_USE_KLIB__)

size_t strlen(const char *s) { //不是\0结尾的ub, 不用管?
  size_t len = 0;
  while(*s != '\0') {
    len++;
    s++;
  }
  return len;
}

char *strcpy(char *dst, const char *src) { 
  char *rec = dst;
  while(*src != '\0'){
    *dst++ = *src++;
  }
  *dst = *src;
  return rec;
}

char *strncpy(char *dst, const char *src, size_t n) {
  char *rec = dst;
  for (size_t i = 0; i < n; ++i){
    *dst = *src;
    dst++;
    src = (*src == '\0') ? src : src + 1;
  }
  return rec;
}

char *strcat(char *dst, const char *src) {
  char *rec = dst;
  while(*dst != '\0'){
    dst++;
  }
  while(*src != '\0'){
    *dst = *src;
    dst++;
    src++;
  }
  *dst = *src;
  return rec;
}

int strcmp(const char *s1, const char *s2) {
  while(*s1 != '\0' && *s2 != '\0'){
    if (*s1 < *s2) return -1;
    if (*s1 > *s2) return 1;
    s1++;
    s2++;
  }
  if (*s1 == '\0'){
    if (*s2 == '\0') return 0;
    else return -1;
  }
  else return 1;
}

int strncmp(const char *s1, const char *s2, size_t n) {
  while(*s1 != '\0' && *s2 != '\0' && n){
    if (*s1 < *s2) return -1;
    if (*s1 > *s2) return 1;
    s1++;
    s2++;
    n--;
  }
  if (n == 0) return 0;
  if (*s1 == '\0'){
    if (*s2 == '\0') return 0;
    else return -1;
  }
  else return 1;
}

void *memset(void *s, int c, size_t n) {
  const unsigned char uc = c;
  unsigned char *iter;
  for (iter = s; n > 0; ++iter, --n){
    *iter = uc;
  }
  return s;
}

void *memmove(void *dst, const void *src, size_t n) {
  unsigned char *p = (unsigned char*)dst;
  unsigned char *q = (unsigned char*)src;
  if (p > q && p < q + n){
    p = p + n - 1;      
    q = q + n - 1;
    while (n--){
      *p-- = *q--;
    }
  }
  else{
    while (n--){
      *p++ = *q++;
    }
  }
  return dst;
}

void *memcpy(void *out, const void *in, size_t n) {
  unsigned char *p = (unsigned char*) out;
  unsigned char *q = (unsigned char*) in;
  while(n--){
    *p++ = *q++;
  }
  return out;
}

int memcmp(const void *s1, const void *s2, size_t n) {
  unsigned char *p = (unsigned char*) s1;
  unsigned char *q = (unsigned char*) s2;
  for(size_t i = 0; i < n; i++){
    if(*p > *q) return 1;
    if(*p < *q) return -1;
    p++; q++;
  }
  return 0;
}

#endif
