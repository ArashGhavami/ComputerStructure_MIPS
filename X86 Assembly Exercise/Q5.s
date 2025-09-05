;402106359
;402106723
section .data
        printf_format1 db "number of ones: %d",10, 0
        printf_format2 db "number of zeros: %d", 10, 0
        scanf_format db "%s",0
        printf_format db "%s",10,0
        buffer: times 128 db 0
section .text
extern printf
extern scanf
global asm_main
asm_main:

        sub rsp, 8
        mov rdi, scanf_format
        mov rsi, buffer
        call scanf
        add rsp, 8
        mov rsi ,buffer
        mov rbx, 0
        mov rcx, 0
loop:
        mov al, byte [rsi]
        test al, al
        jz equal
        cmp al, 31h
        je add_one
        inc rcx
        inc rsi
        jmp loop
add_one:
        inc rbx
        inc rsi
        jmp loop
equal:
        sub rsp, 8
        push rcx
        push rbx

        mov rdi, printf_format1
        mov rsi, rbx
        call printf
        mov rdi, printf_format2
        pop rsi
        pop rsi
        call printf


        mov rax, 60
        mov rdi ,0
        syscall
