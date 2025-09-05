#402106359
#402106723

.macro enter size
	stmg	%r6, %r14, 48(%r15)
	lay	%r15, -(160+\size)(%r15)
.endm

.macro leave size
	lay	%r15, (160+\size)(%r15)
	lmg	%r6, %r14, 48(%r15)
.endm

.macro ret
	br	%r14
.endm

.macro call func
	brasl	%r14, \func
.endm

.macro print_quad
	enter	0
	larl	%r2, pif
	call	printf
	leave	0
.endm
.macro printf_yes
	enter 0
	larl %r2, yes_format
	call printf
	leave 0
.endm


.macro printf_no
   	enter 0
        larl %r2, no_format
        call printf
        leave 0
.endm

.macro read_quad
	enter	8
	larl	%r2, rif
	lay	%r3, 160(%r15)
	call	scanf
	lg	%r2, 160(%r15)
	leave	8
.endm

.data
.align 8
rif:	.asciz	"%lld"
.align 8
pif:	.asciz	"%lld"
.align 8
yes_format: .asciz "YES\n"
.align 8
no_format: .asciz "NO\n"
.align 8

.text
.global main
main:
	read_quad
	lr %r6, %r2 # r6 is the counter for outer loop
	lghi %r7, 0 # sum

	lghi %r8, 0 # the best power
outer_loop:
	lghi %r3, 0
	cr %r6, %r3	
	je exit
	
	agfi %r6, -1
	read_quad
	ar %r7, %r2
	
inner_loop:
	agfi %r8,1
	lr %r3, %r8
	lr %r4, %r8
	msgr %r3, %r4
	cr %r3, %r7
	jl inner_loop
	je inner_loop
	agfi %r8, -1
	
	lr %r3, %r8
        lr %r4, %r8
        msgr %r3, %r4
	cr %r3, %r7

	je print_yes
	printf_no
	j outer_loop
print_yes:
	printf_yes
	j outer_loop

exit:
	xgr %r2, %r2
	ret
