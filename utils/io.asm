global print
global readUserInput

section .text
; @param rdi - buffer length
; @param rsi - buffer address
print:
    mov rdx, rdi
    mov rax, 1 ; system call for write
    mov rdi, 1 ; file handle 1 is stdout
    syscall
    ret

; @returns rdi - buffer length
; @returns rsi - buffer address
readUserInput:
    xor eax, eax ; system call for read
    xor edi, edi ; file handle 0 is stdin
    mov rsi, userInput
    mov edx, 256
    syscall
    mov rsi, userInput

    cmp rax, 256
    je .end

    cmp rax, 0
    je .end

    cmp byte [userInput+rax-1], 10
    jne .end

    dec rax

    .end:
    mov rdi, rax
    ret

section .bss
userInput   resb 256
