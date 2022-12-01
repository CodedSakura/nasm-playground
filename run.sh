#!/bin/bash

mkdir -p out


for i in $(find . -name "*.asm"); do
  mkdir -p "out/$(dirname "$i")"
  nasm -f elf64 "$i" -o "out/${i%.asm}.o"
done

exit

ld -m elf_x86_64 $(find out -name "*.o") -o "out/out"

./out/out
