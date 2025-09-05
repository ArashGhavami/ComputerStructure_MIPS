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

.data
arr: .long 1, 2, 3, 4, 5, 6

.text
.global main

main:
	enter 0
	
	larl %r2, arr
	lgfi %r3, 6
	call sum

	leave 0
	ret

sum:
	enter 0

	lgr %r7, %r2
	lgr %r8, %r3
	lgfi %r9, 0 # final answer
loop_start:
	cgfi %r8, 0
	je loop_end
	lgf %r10, 0(%r7)
	agr %r9, %r10
	agfi %r7, 4
	agfi %r8, -1
	j loop_start
loop_end:
	lgr %r2, %r9 

	leave 0
	ret
