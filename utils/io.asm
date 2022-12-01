global print

section .text
; @param rax - message length
; @param rbx - message address
; @sideEffect rdx = rax
; @sideEffect rax = 1
print:
    mov rdx, rax
    mov rax, 1 ; system call for write
    mov rdi, 1 ; file handle 1 is stdout
    mov rsi, rbx
    syscall
    ret
