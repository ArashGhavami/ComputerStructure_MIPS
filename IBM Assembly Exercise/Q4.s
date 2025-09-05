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

.macro read_long
	enter	8
	larl	%r2, rif
	lay	%r3, 160(%r15)
	call	scanf
	lg	%r2, 160(%r15)
	leave	8
.endm

.data
rif: .asciz "%lld\0"
.align 8
pif: .asciz "%lld\n\0"

.text
.global main

main:
	enter 0

	read_long
	lgr %r7, %r2
	read_long
	lgr %r8, %r2
	lgfi %r10, 0 # final answer
	lgfi %r11, 1
loop_start:
	cgfi %r8, 0
	je loop_end
	lgr %r9, %r8
	ngr %r9, %r11
	cgfi %r9, 1
	jne last_part
	agr %r10, %r7
last_part:
	srl %r8, 0(%r11)
	sll %r7, 0(%r11)
	j loop_start
loop_end:
	lgr %r3, %r10
	print_long

	leave	0
 	xgr	%r2, %r2
	ret
