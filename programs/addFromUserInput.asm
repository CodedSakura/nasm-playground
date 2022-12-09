%include "../utils/io.mac"

extern print
extern readUserInput
extern parseInt
extern intToString
extern readFileWhole

section .text
global addFromUserInput
addFromUserInput:
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
    ret
