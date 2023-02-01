#include <stdio.h>
#include <cassert>
#include <stdint.h>

uint32_t rec[130][75];
inline bool check_valid(char c){
  return (c >= '0' && c <= '9') || (c >= 'A' && c <= 'Z');
}

FILE *wfp, *rfp;
int main(){
  wfp = fopen("./color_out.coe", "w");
  assert(wfp != nullptr);


  char ascii = 0;
  for (int i = 0; i < 128; ++i){
    for (int j = 0; j < 70; ++j){
      uint32_t front_color = rand() % 0xfff;
      uint32_t back_color  = 0x00F;
      uint32_t color_data  = (front_color << 12) | back_color;
      rec[i][j] = color_data;
    }
  }

  for (int i = 0; i < 70; ++i){
    for (int j = 0; j < 128; ++j){
      fprintf(wfp, "%x\n", rec[j][i]);
    }
  }
}