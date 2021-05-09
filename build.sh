#!/bin/sh

as cordic.asm -o cordic.o
gcc main.c cordic.o -O0 -g3 -lm -o cordic_test

