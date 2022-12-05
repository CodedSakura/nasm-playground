#!/bin/bash

mkdir -p out

for i in $(find . -name "*.asm"); do
  mkdir -p "out/$(dirname "$i")"
  nasm -g -F dwarf -f elf64 "$i" -o "out/${i%.asm}.o" || exit
#  yasm -g dwarf2 -f elf64 "$i" -o "out/${i%.asm}.o" || exit
done

ld $(find out -name "*.o") -o "out/out"

./out/out
