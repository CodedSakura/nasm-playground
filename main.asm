extern print
extern readUserInput
extern parseInt
extern intToString
extern readFileWhole

%macro printText 1
[section .rodata]
%%msg: db %1
%%len: equ $ - %%msg
__?SECT?__
    mov rdi, %%len
    mov rsi, %%msg
    call print
%endmacro

section .text

global _start
_start:
    mov rsi, filename
    call readFileWhole
    call exit

    printText `Enter 1st number: `

    call readUserInput

    call parseInt
    cmp rbx, 1
    je .fail

    mov r8, rax

    printText `Enter 2nd number: `

    call readUserInput

    call parseInt
    cmp rbx, 1
    je .fail

    add r8, rax

    printText `Sum: `

    mov rax, r8

    call intToString

    call print
    jmp .end

    .fail:
    printText `Bad number!`

    .end:
    call exit
    ret

exit:
    mov rax, 60 ; system call for exit
    xor rdi, rdi ; exit code 0
    syscall
    ret

section .rodata
filename: db "./input.txt"
