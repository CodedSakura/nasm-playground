; nasm -f elf64 hello.asm && ld hello.o && ./a.out

global _start

extern print

section .text

; @sideEffect eax = 0
; @sideEffect edi = 0
; @sideEffect rsi = userInput
; @sideEffect edx = 256
; @returns rax - read in length
readUserInput:
    xor eax, eax
    xor edi, edi
    mov rsi, userInput
    mov edx, 256
    syscall

    cmp rax, 256
    je readUserInput_end

    cmp rax, 0
    je readUserInput_end

    cmp byte [userInput+rax-1], '\n'
    jne readUserInput_end

    dec rax

    readUserInput_end:
    ret


_start:
    mov rax, messageLen
    mov rbx, message
    call print
    call readUserInput
    mov rbx, userInput
    call print
    call exit
    ret

exit:
    mov rax, 60 ; system call for exit
    xor rdi, rdi ; exit code 0
    syscall
    ret


section .data
message     db "Input a number: "
messageLen  equ $-message

section .bss
userInput   resb 256
