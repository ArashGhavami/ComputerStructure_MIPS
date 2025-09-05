section .data
	printf_str db "%s", 10,0
	buffer: times 128 db 0
	printf_format db "%d", 10, 0
	scanf_format db "%d", 0
	scanf_format_str db "%s",0
	cmp_command db "1",0
	swap_command db "2",0
	
	overflow_command db "overflow",0
	exit_command db "exit",0
section .text
extern scanf
extern printf
global main
main:

	push rbp
	mov rbp, rsp
	
	mov rdi, scanf_format_str
	mov rsi, buffer
	call scanf
	
	mov rdi, buffer
	mov rsi, cmp_command
	call compare_str
	cmp rax, 1
	je cmp_c

	mov rdi, buffer
	mov rsi,swap_command
	call compare_str
 	cmp rax, 1
	je swap_c
	
	jmp exit

compare_str:
        mov al, byte[rdi]
        mov bl, byte[rsi]
        test al, al
        jz equal
        cmp al, bl
        jne not_equal
        inc rdi
        inc rsi
        jmp compare_str
not_equal:
        mov rax, 0
        jmp end
equal:
       	mov rax, 1
end:
        ret	


cmp_c:
	mov rdi, scanf_format_str
        mov rsi, buffer
        call scanf
	mov rax, -1
	mov rsi, buffer
	loop_first_inp:
	inc rax
	mov bl, byte[rax + buffer]
	
	test bl, bl
	jz end_loop_first_inp
	
	cmp bl, 95
	je loop_first_inp

	cmp bl, 90
	jng loop_first_inp
	
	mov bl, [rax + buffer]	
	sub bl, 32
	mov [rax + buffer], bl 

	jmp loop_first_inp
	end_loop_first_inp:
	
	jmp exit
swap_c:
	mov rdi, scanf_format_str
        mov rsi, buffer
        call scanf
	
	mov rsi, -1
	length_finder:
	inc rsi
	mov al, byte [rsi +  buffer]
	test al, al
	jnz length_finder
	
	mov rdi, rsi
	shr rsi, 1
	sub rsi, 1	
	mov rdx, 0
	final_loop:
	mov al, [buffer + rdx]
	mov r8, rdi
	sub r8,1
	sub r8,rdx 
	mov bl, [r8 + buffer]
	mov [buffer + rdx], bl
	mov [r8 + buffer], al
	inc rdx
	cmp rdx, rsi
	jne final_loop
	mov al, [buffer + rdx]
        mov r8, rdi
        sub r8,1
        sub r8,rdx
        mov bl, [r8 + buffer]
        mov [buffer + rdx], bl
        mov [r8 + buffer], al
        inc rdx
        cmp rdx, rsi

exit:	
	mov rdi, printf_str
	mov rsi, buffer
	call printf
	xor eax, eax
	leave
	ret