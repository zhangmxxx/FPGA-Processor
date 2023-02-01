#include <stdio.h>
#include <cassert>
char rec[130][75];
inline bool check_valid(char c){
  return (c >= '0' && c <= '9') || (c >= 'A' && c <= 'Z');
}

FILE *wfp, *rfp;
int main(){
  wfp = fopen("./char_out.coe", "w");
  assert(wfp != nullptr);
  rfp = fopen("./src.txt", "r");
  assert(rfp != nullptr);

  char ascii = 0;
  for (int i = 0; i < 30; ++i){
    for (int j = 0; j < 70; ++j){
      fscanf(rfp, "%c", &rec[i][j]);
      if (rec[i][j] == '\n') {
        rec[i][j] = ' ';
      }
    }
  }
  for (int i = 30; i < 60; ++i){
    for (int j = 0; j < 70; ++j){
      rec[i][j] = 'A';
    }
  }
  for (int i = 60; i < 128; ++i) {
    for (int j = 0; j < 70; ++j) {
      rec[i][j] = ' ';
    }
  }

  for (int i = 0; i < 70; ++i){
    for (int j = 0; j < 128; ++j){
      fprintf(wfp, "%d\n", rec[j][i]);
    }
  }
}