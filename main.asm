global _start

extern print
extern readUserInput
extern parseInt
extern intToString

section .text
_start:
    mov rdi, messageLen
    mov rsi, message
    call print

    call readUserInput

    call parseInt
    cmp rbx, 1
    je .fail

    call intToString

    call print
    jmp .end

    .fail:
    mov rdi, badNumLen
    mov rsi, badNumMsg
    call print

    .end:
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

badNumMsg   db "Bad number!", 10
badNumLen   equ $-badNumMsg
