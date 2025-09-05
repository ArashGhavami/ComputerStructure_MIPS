; 402106723 402106359

global asm_main
extern printf
extern scanf

section .data
scanf_format: db "%s", 0
printf_format: db "%s", 10, 0
str: times 128 db 0

section .text
asm_main:
	sub rsp, 8
	mov rdi, scanf_format
	mov rsi, str
	call scanf
	call get_str_len
	mov rdi, 0
	mov rsi, rax
	call func
	add rsp, 8
	ret

get_str_len:
	mov rax, 0
loop_start:
	mov cl, [str + rax]
	cmp cl, 0
	je loop_end
	inc rax
	jmp loop_start
loop_end:
	ret

func: ; func(i, n) permutes str[i, n)
	sub rsp, 40
	cmp rdi, rsi
	jl normal_mode
	mov rdi, printf_format
	mov rsi, str
	call printf
	jmp exit
normal_mode:
	mov r12, rdi
l_start:
	cmp r12, rsi
	je exit
	mov bl, [str + r12]
	mov r13, r12
inner_loop_start:
	cmp r13, rdi
	je inner_loop_end
	mov al, [str + r13 - 1]
	mov [str + r13], al
	dec r13
	jmp inner_loop_start
inner_loop_end:
	mov [str + rdi], bl
	mov [rsp], rdi
	mov [rsp + 8], rsi
	mov [rsp + 16], r12
	inc rdi
	call func
	mov rdi, [rsp]
	mov rsi, [rsp + 8]
	mov r12, [rsp + 16]
	mov bl, [str + rdi]
	mov r13, rdi
inner_loop2_start:
	cmp r13, r12
	je inner_loop2_end
	mov al, [str + r13 + 1]
	mov [str + r13], al
	inc r13
	jmp inner_loop2_start
inner_loop2_end:
	mov [str + r12], bl
	inc r12
	jmp l_start
exit:
	add rsp, 40
	ret
