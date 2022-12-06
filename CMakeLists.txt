cmake_minimum_required(VERSION 3.24)
project(nasm_playground)

enable_language(ASM_NASM)
set(CMAKE_ASM_NASM_LINK_EXECUTABLE "ld <CMAKE_ASM_NASM_LINK_FLAGS> <LINK_FLAGS> <OBJECTS>  -o <TARGET> <LINK_LIBRARIES>")

file(GLOB_RECURSE sources "*.asm")

add_executable(nasm_playground ${sources})
set_target_properties(nasm_playground PROPERTIES NASM_OBJ_FORMAT "elf64")
