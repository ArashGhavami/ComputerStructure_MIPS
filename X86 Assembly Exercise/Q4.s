;402106359
;402106723
section .data
        buffer1: times 128 db 0
        buffer2: times 128 db 0
        scanf_format db "%s",0
        printf_format db "'%s'",0
        equal_str db "equal",10,0
        not_equal_str db "not equal", 10,0
section .text
extern scanf
extern printf
global asm_main
asm_main:
        sub rsp, 8
        mov rdi, scanf_format
        mov rsi, buffer1
        call scanf
        mov rdi, scanf_format
        mov rsi, buffer2
        call scanf

        mov rdi, buffer1
        mov rsi, buffer2
loop:
        mov al, byte[rdi]
        mov bl, byte[rsi]
        test al, al
        jz equal
        cmp al, bl
        jne not_equal
        inc rdi
        inc rsi
        jmp loop
not_equal:
        mov rdi, not_equal_str
        call printf
        jmp end
equal:
        mov rdi, equal_str
        call printf
end:
        add rsp, 8
        ret
