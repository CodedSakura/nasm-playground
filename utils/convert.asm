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
        jc .checkInputAndEnd

        xor rdx, rdx
        mov dl, [rsi + rdi]
        cmp dl, '0' ; if dl < '0'
        jl .checkSignOrError
        cmp dl, '9' ; if dl > '9'
        jg .checkSignOrError

        sub dl, '0'
        imul rdx, rcx
        add rax, rdx
        imul rcx, 10

        cmp rdi, 0
        je .end
        jmp .loop

    .checkSignOrError:
        cmp dl, '+'
        je .end
        cmp dl, '-'
        jne .error
        neg rax
        jmp .end

    .checkInputAndEnd:
        cmp rcx, 1
        jne .end

    .error:
        mov rbx, 1

    .end:
        ret


global intToString
; @param rax - number
; @returns rdi - buffer length
; @returns rsi - buffer address
intToString:
    xor rdi, rdi
    xor rbx, rbx
    lea rsi, [intToStrOut+255]

    cmp rax, 0
    jg .loop

    .negate:
        neg rax
        mov rbx, 1

    .loop:
        add rdi, 1
        sub rsi, 1

        xor rdx, rdx
        mov rbx, 10
        div rbx
        add dl, '0'
        mov [rsi], dl

        cmp rax, 0
        jne .loop

        ; end of loop
        cmp rbx, 0
        je .end

        add rdi, 1
        sub rsi, 1
        mov [rsi], byte '-'

    .end:
        ret

section .bss
intToStrOut resb 256
