# Coe_generator

## Usage
1. Draw the characters in src.txt, limited to 30 * 70; 
2. Run `main.cpp` like any other c++ source file, for example `$g++ -o a.out main.cpp`, `$./a.out`, and you'll get `out.coe`, which can be recognized and used for initialization by Vivado.

## Warnings
Pay attention to extraneous space, for it will be read into the char_mem as well, resulting in error order.

