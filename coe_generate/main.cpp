#include <stdio.h>
#include <cassert>
#include <stdint.h>

uint32_t char_rec[130][75];
uint32_t color_rec[130][75];
inline bool check_valid(char c){
  return (c >= '0' && c <= '9') || (c >= 'A' && c <= 'Z');
}

FILE *char_wfp, *color_wfp, *rfp;
int main(){
  char_wfp = fopen("./char_out.coe", "w");
  assert(char_wfp != nullptr);
  color_wfp = fopen("./color_out.coe", "w");
  assert(color_wfp != nullptr);
  rfp = fopen("./src.txt", "r");
  assert(rfp != nullptr);

  char ascii = 0;
  for (int i = 0; i < 30; ++i){
    for (int j = 0; j < 70; ++j){
      fscanf(rfp, "%c", &char_rec[i][j]);
      if (char_rec[i][j] == '\n') {
        char_rec[i][j] = ' ';
      }
      if (i >= 3 && i <= 8 && j >= 12 && j <= 55) {
        uint32_t front_color = rand() % 0xfff;
        uint32_t back_color  = 0x111;
        uint32_t color_data  = (front_color << 12) | back_color;
        color_rec[i][j] = color_data;
      }
      else if (i >= 21) {
        uint32_t front_color = 0xF0F;
        uint32_t back_color  = 0x111;
        uint32_t color_data  = (front_color << 12) | back_color;
        color_rec[i][j] = color_data;
      }
      else {
        uint32_t front_color = 0xFFF;
        uint32_t back_color  = 0x111;
        uint32_t color_data  = (front_color << 12) | back_color;
        color_rec[i][j] = color_data;
      }
      
    }
  }
  for (int i = 30; i < 128; ++i) {
    for (int j = 0; j < 70; ++j) {
      char_rec[i][j] = ' ';
      uint32_t front_color = 0xFFF;
      uint32_t back_color  = 0x000;
      uint32_t color_data  = (front_color << 12) | back_color;
      color_rec[i][j] = color_data;
    }
  }

  for (int i = 0; i < 70; ++i){
    for (int j = 0; j < 128; ++j){
      fprintf(char_wfp, "%d\n", char_rec[j][i]);
      fprintf(color_wfp, "%x\n", color_rec[j][i]);
    }
  }
}