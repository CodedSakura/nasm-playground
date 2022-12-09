; includes from cmake-build-debug?
%include "../utils/exit.mac"
%include "../utils/io.mac"

extern addFromUserInput

section .text
global _start
_start:
    call addFromUserInput
    exit
