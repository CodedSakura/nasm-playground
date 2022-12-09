; includes from cmake-build-debug?
%include "../utils/exit.mac"
%include "../utils/utils.mac"

section .text
global _start
_start:
    callExtern addFromUserInput
    callExtern addFromUserInput
    exit
