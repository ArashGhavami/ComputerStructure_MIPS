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
	call change_str
	mov r10, rax ; string length
	mov r11, 1 ; max good substring length
	mov r12, 0 ; best start index
	mov r13, 0 ; left_of_interval counter
l1_start:
	cmp r13, r10
	jnb l1_end
	mov r14, r13 ; right_of_interval
	inc r14
l2_start:
	cmp r14, r10
	jnb l2_end
	mov r15, r13
l3_start:
	cmp r15, r14
	jnb l3_end
	mov cl, [str + r14]
	mov bl, [str + r15]
	cmp cl, bl
	je l2_end
	inc r15
	jmp l3_start
l3_end:
	inc r14
	jmp l2_start
l2_end:
	sub r14, r13
	cmp r14, r11
	jl not_better_case
	mov r12, r13
	mov r11, r14
not_better_case:
	inc r13
	jmp l1_start
l1_end:
	mov byte[str + r11 + r12], 0
	mov rdi, printf_format
	lea rsi, [str + r12]
	call printf
	add rsp, 8
	ret

change_str: ; transforms characters to small and returns length
	mov rax, 0
l_start:
	mov bl, [str + rax]
	cmp bl, 0
	je l_end
	cmp bl, 97
	jnb normal
	add bl, 32
	mov [str + rax], bl
normal:
	inc rax
	jmp l_start
l_end:
	ret
