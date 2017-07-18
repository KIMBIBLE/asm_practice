global _start
_start:
	; socket()
	mov rax, 0x29	; SYS_socket 
	mov rdi, 2		; socket_family = AF_INET
	mov rsi, 1		; socket_type = SOCK_STREAM
	xor rdx, rdx	; protocol = 0(default)

	syscall

	; connect() 
    mov rbp, rax
    mov rax, 0x101010101010101
    push rax
    mov rax, 0x101010101010101 ^ 0x144b7c0d39050002
    xor [rsp], rax

    mov rax, 0x2a
    mov rdi, rbp
    mov rdx, 0x10
    mov rsi, rsp
    syscall

	; read() => read string
	mov rdi, rbp	; sockfd
	mov rax, 0	; SYS_read
	mov rsi, rsp	; buf
	mov rdx, 0x100 	; len

	syscall

	mov rbx, rdi

	; reverse string
	sub rax, 2		; delete \x0a
	mov rcx, rax	; rax = read len
	mov r9, rbx		; r9 = sockfd

	; src buf = rsi
	mov rdi, rsi
	add rdi, rcx

loop:
    cmp rsi, rdi
    jg endloop
    mov cl, [rsi]
    mov ch, [rdi]
    mov [rsi], ch
    mov [rdi], cl
    dec rdi
    inc rsi
    jmp loop

endloop:
	; write() 
	mov rsi, rsp
	mov rdi, r9
	inc rax
	mov rdx, rax
	mov rax, 1

	syscall

	; read() OK message
	mov rax, 0
	mov rsi, rsp
	mov rdx, 0x10

	syscall

	; write()
	mov rdx, rax
	mov rdi, 1
	mov rax, 1

	syscall

	; exit()
	mov rax, 0x3c
	mov rdi, 0
	syscall