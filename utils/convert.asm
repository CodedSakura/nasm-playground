section .text

global parseInt
; @param rdi - buffer length
; @param rsi - buffer address
; @returns rax - result
; @returns rbx - 1 if error
parseInt:
    xor rax, rax ; result
    xor rbx, rbx ; error
    mov rcx, 1 ; multiplier

    .loop:
        sub rdi, 1
        jc .end

        xor rdx, rdx
        mov dl, [rsi + rdi]
        cmp dl, '0' ; if dl < '0'
        jl .error
        cmp dl, '9' ; if dl > '9'
        jg .error

        sub dl, '0'
        imul rdx, rcx
        add rax, rdx
        imul rcx, 10

        cmp rdi, 0
        je .end
        jmp .loop

    .error:
        mov rbx, 1

    .end:
        ret


global intToString
; @param rax - number
; @returns rdi - buffer length
; @returns rsi - buffer address
; @returns rbx - 1 if error
intToString:
    xor rdi, rdi
    mov rsi, intToStrOut
    add rsi, 255

    .loop:
        add rdi, 1
        sub rsi, 1

        xor rdx, rdx
        mov rbx, 10
        div ebx
        add dl, '0'
        mov [rsi], dl

        cmp rax, 0
        jne .loop

    .end:
        ret

section .bss
intToStrOut resb 256
