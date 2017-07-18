SECTION .data
	star:	db 0x2a
	enter:	db 0x0a

SECTION .text
    global _start
_start:

	mov rax, [rsp]	; argc
	cmp rax, 0x01
	je end
	mov rax, [rsp + 16] ; argv[1][0]
	mov bl, [rax]
	sub rbx, 0x30
	mov r8, rbx		; argv[1][0] - '0'

	cmp r8, 0
	jne stage
	push star
	call print
	pop rax
	push enter
	call print
	pop rax
	call end

;;;;; stage 1 ;;;;;
stage:
	;for(i = 1 ; i <= max; i++)
	mov r14, 1	; i = 1
	for1_start:
		cmp r14, r8
		jg for1_end

		;for(j = 1; j <= i; j++)
		mov r15, 1 ; j = 1
		for2_start:
			cmp r15, r14
			jg for2_end

			push star
			call print
			pop rax

		inc r15
		jmp for2_start
		
		for2_end:
			push enter
			call print
			pop rax
		inc r14
		jmp for1_start

	for1_end:

;;;;; stage 2 ;;;;;
	dec r8

	;for(i = max; i >= 1; i--)
	mov r14, r8	; i = max

	for3_start:
		cmp r14, 0
		jz for3_end

		;for(j = 1; j <= i; j++)
		mov r15, 1 ; j = 1
		for4_start:
			cmp r15, r14
			jg for4_end

			push star
			call print
			pop rax

		inc r15
		jmp for4_start
		for4_end:
			push enter
			call print
			pop rax
		dec r14
		jmp for3_start
	for3_end:


	call end


print:
	push rbp
	mov rbp, rsp
	mov rax, 1 ; write syscall
	mov rdi, 1 ; stdout
	mov rsi, [rbp + 16]
	mov rdx, 1 ; size
	syscall

	leave
	ret

end:
	push rbp
	mov rbp, rsp
	mov rax, 0x3c
	mov rdi, 0
	syscall
	leave
	ret

