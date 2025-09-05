.macro enter size
	stmg	%r6, %r15, 48(%r15)
	lay	%r15, -(160+\size)(%r15)
.endm

.macro leave size
	lay	%r15, (160+\size)(%r15)
	lmg	%r6, %r15, 48(%r15)
.endm

.macro ret
	br	%r14
.endm

.macro call func
	brasl	%r14, \func
.endm

.macro print_long
	enter	0
	larl	%r2, pif
	call	printf
	leave	0
.endm

.macro	read_char
	enter	8
	larl	%r2, rcf
	lay	%r3, 167(%r15)
	call	scanf
	lgb	%r2, 167(%r15)
	leave	8
.endm

.data
pif: .asciz "%lld\n\0"
.align 8
rcf: .asciz "%c\0"

.text
.global main

main:
	enter 0

	lgfi %r10, 0 # final answer
	lgfi %r11, 0 # the saved number up to here
loop_start:
	read_char
	lgr %r8, %r2
	cgfi %r8, 10
	je loop_end
	lgr %r12, %r8 # the new digit
	cgfi %r8, 48
	jl not_digit_mode
	cgfi %r8, 57
	jh not_digit_mode
	j last_part
not_digit_mode:
	agr %r10, %r11
	lgfi %r11, 0
	lgfi %r12, 48
last_part:
	msgfi %r11, 10
	agfi %r12, -48
	agr %r11, %r12
	agfi %r7, 1
	j loop_start
loop_end:
	agr %r10, %r11
	lgr %r3, %r10
	print_long

	leave 0
	xgr %r2, %r2
	ret
