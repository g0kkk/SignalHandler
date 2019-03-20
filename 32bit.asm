%define sys_write 0x04
%define sys_rt_sigaction 0x43
%define sys_pause 0x1d
%define sys_exit 0x01
%define sys_rt_sigreturn 0xad
%define SIGTERM 0x0f
%define SIGINT 0x02
%define SIGSEGV 0xb
%define STDOUT 0x01
%define SA_RESTORER 0x04000000

; Definition of sigaction struct for sys_rt_sigaction
struc sigaction
    .sa_handler  resd 1
    .sa_flags    resd 1
    .sa_restorer resd 1
    .sa_mask     resd 1
endstruc

section .data
    ; Message shown when a int 0x80 fails
    error_msg     db  'int 0x80 error', 0x0a
    error_msg_len equ $ - error_msg
    ; Message shown when SIGTERM is received
    sigterm_msg     db  'SIGTERM received', 0x0a
    sigterm_msg_len equ $ - sigterm_msg

section .bss
    act resb sigaction_size
    val resd 1

section .text
global _start
_start:
    mov dword [act + sigaction.sa_handler], handler
    mov [act + sigaction.sa_flags], DWORD SA_RESTORER
    mov dword [act + sigaction.sa_restorer], restorer

    mov eax, sys_rt_sigaction
    ;mov ebx, SIGINT
    mov ebx, SIGTERM
    mov ecx, act
    xor edx, edx
    int 0x80

    cmp eax, 0
    jne error

    mov eax, sys_pause
    int 0x80

    jmp exit

error:
    mov eax, sys_write
    mov ebx, STDOUT
    mov ecx, error_msg
    mov edx, error_msg_len
    int 0x80

    mov dword [val], 0x01

exit:
    mov eax, sys_exit
    mov ebx, [val]
    int 0x80

handler:
    mov eax, sys_write
    mov ebx, STDOUT
    mov ecx, sigint_msg
    mov edx, sigint_msg_len
    int 0x80
    ret

restorer:
    mov eax, sys_rt_sigreturn
    int 0x80

