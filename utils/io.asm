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

    cmp rax, 0
    je .end

    cmp byte [userInput+rax-1], 10
    jne .end

    dec rax

.end:
    mov rdi, rax
    ret

global getFileSize
; i did not find any good explanation on how the stat syscall works, so i hope this works on other linux systems too...
; here's what i found analyzing the return and comparing with the `stat' command (on a simple input file):
; %d qword 38           device number in decimal (st_dev)
; %i qword 2580335      inode number
; ?? qword 1
; %f dword 33188        raw mode in hex ((NOT IN HEX! :P ))
; %u dword 1000         user ID of owner
; %g dword 1000         group ID of owner
; ?? dword 0
; %s qword 3            total size, in bytes
; %o qword 4096         optimal I/O transfer size hint
; %b qword 8            number of blocks allocated (see %B)
; %X qword 1670411424   time of last access, seconds since Epoch
; ?? qword 253193821
; %Y qword 1670411423   time of last data modification, seconds since Epoch
; ?? qword 649860108
; %Z qword 1670411423   time of last status change, seconds since Epoch
; ?? qword 649860108
; total 15 qwords (60 bytes), 16 feels rounder, that's why allocating 16
; @param rsi - filename address
; @returns rax - file size in bytes; error code if error
; @returns rbx - optimal I/O size hint; 0 if error
getFileSize:
    mov rdi, rsi
    mov rsi, statBuf
    mov rax, 4 ; stat
    syscall
    cmp rax, 0
    je .finalize
    xor rbx, rbx
    ret
.finalize:
    mov rax, qword [rsi+6*8]
    mov rbx, qword [rsi+7*8]
    ret

global readFileWhole
; @param rsi - filename address
; @returns rdi - file buffer length
; @returns rsi - file buffer address
; @returns rbx - 0 if fine, 1 if error
readFileWhole:
    call getFileSize
    cmp rax, 0
    jz .error

    ; getFileSize moved filename addr (rsi) to rdi
    push rdi

    mov rdi, rax
    call allocateMemory

    ; save allocated mem len & addr
    mov r9, rdi
    mov r8, rsi

    pop rdi ; *filename
    xor rsi, rsi ; flags = O_RDONLY
    xor rdx, rdx ; mode = none
    mov rax, 2 ; open
    syscall
    cmp rax, 0
    jz .error

    mov rdi, rax
    mov rdx, rbx
    xor r9, r9 ; read in bytes

    .loop:
        ; rdi - file descriptor already
        lea rsi, [r8 + r9] ; *buf
        ; rdx - count = optimal I/O already
        xor rax, rax ; read
        syscall
        cmp rax, 0
        jz .end_loop
        jl .error

        add r9, rax

        cmp rax, rdx ; if rdx bytes read
        je .loop
.end_loop:
    mov rax, 3 ; close
    syscall
    cmp rax, 0
    jl .error

    mov rdi, r9 ; read bytes
    mov rsi, r8 ; buff addr
    xor rbx, rbx
    ret

.error:
    mov rbx, 1
    ret

global allocateMemory
; @param rdi - required buffer length
; @returns rdi - buffer length
; @returns rsi - buffer address
allocateMemory:
    mov rsi, rdi ; length
    xor rdi, rdi ; addr
    mov rdx, 3 ; prot = PROT_READ | PROT_WRITE
    mov r10, 34 ; flags = MAP_PRIVATE | MAP_ANONYMOUS
    xor r8, r8 ; fd
    xor r9, r9 ; offset
    mov rax, 9 ; mmap
    syscall
    cmp rax, 0
    jg .end
    ; error, exiting
    mov rdi, rax
    mov rax, 60 ; exit
    syscall
    ret

    .end:
    mov rsi, rax
    ret

section .bss
userInput   resb 256
statBuf     resq 16
