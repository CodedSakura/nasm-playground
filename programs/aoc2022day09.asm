%include "../utils/utils.mac"
%include "../utils/io.mac"

; @type position - [ebx << 32, ebx] - [x, y]

section .text
global aoc2022day09
aoc2022day09:
    mov rsi, filename
    callExtern readFileWhole
    cmp rbx, 0
    jne .failRead

    lea rdi, [rsi+rdi]

    %define inputDataBuf rsi
    %define inputDataEnd rdi
    %define vec rbx

.readNext:
    mov dl, byte [inputDataBuf]
    cmp byte [inputDataBuf + 1], byte ' '
    jne .failParse
    add inputDataBuf, 2

    mov rax, -1

.readNextLoop:
    add rax, 1
    cmp byte [inputDataBuf + rax], byte `\n`
    jne .readNextLoop

; parse instruction count
    push rax
    push rdx
    push inputDataEnd

    mov rdi, rax
    callExtern parseInt
    cmp rbx, 0
    jne .failParse

    pop inputDataEnd
    pop rdx
    pop rcx

    lea inputDataBuf, [inputDataBuf+rcx+1]

    call parseInstruction

    call applyInstruction

    cmp inputDataBuf, inputDataEnd
    jl .readNext

    ret

.failRead:
    printText `failed to read file!`
    ret

.failParse:
    printText `failed to parse data!`
    ret

; @param rax - count
; @param rdx - direction
; @returns rbx - @type position
parseInstruction:
    xor vec, vec

    cmp dl, byte 'D'
    je .down
    cmp dl, byte 'U'
    je .up
    cmp dl, byte 'R'
    je .right
    cmp dl, byte 'L'
    je .left

    printText `failed to parse instruction!`
    ret

.down:
    or ebx, eax
    ret

.up:
    neg eax
    or ebx, eax
    ret

.right:
    or ebx, eax
    shl vec, 32
    ret

.left:
    neg eax
    or ebx, eax
    shl vec, 32
    ret

; @param rbx - @type position
; @preserve rsi, rdi
applyInstruction:
    cmp rbx, 0
    je .end
    mov rcx, 4

    cmp ebx, 0
    jne .continue ; y
    shr rbx, 32
    xor rcx, rcx
.continue:
    test ebx, ebx
    mov eax, 1
    jns .loop
    neg eax
.loop:
    add dword [ropes + rcx], eax
    call handleHeadMove
    sub ebx, eax
    cmp ebx, 0
    jne .loop
    ret

.end:
    ret

; @preserve rax, rbx, rcx, rsi, rdi
handleHeadMove:
    xor rdx, rdx
.loop:
    lea r8, [ropes + rdx * 8]
    call handleRopeMove
    add rdx, 1
    cmp rdx, 10
    jl .loop
    ret

; @preserve rax-rdx, rsi, rdi
; @param r8 - head addr
handleRopeMove:
    xor r9, r9
    mov e10, dword [r8   ] ; head x
    mov e11, dword [r8+4 ] ; head y
;    mov e12, dword [r8+8 ] ; tail x
;    mov e13, dword [r8+12] ; tail y

    sub e10, dword [r8+8]

.needsNotMove:
    ret

section .bss
ropes: resq 10 ; 10 * @type position
visited: resq 16384 ; 2**14 * @type position

section .rodata
filename: db "aoc2022day09.txt", 0
