#402106359
#402106723

.macro ret 

	br %r14
.endm

.macro call func
	brasl %r14, \func
.endm

.macro enter size
	stmg %r6, %r14, 48(%r15)
	lay %r15, -(160+\size)(%r15)
.endm

.macro leave size
	lay	%r15, (160+\size)(%r15)
	lmg	%r6, %r14, 48(%r15)
.endm

.macro scan_string
	enter	0
	larl	%r2, rsf
	larl	%r3, label
	call	scanf
	leave	0
.endm

.data
	.align 8
	label: .space 104
	.align 8
	rsf: .asciz "%s"
	.align 8
	print_num: .asciz "%d"
	.align 8
	printf_no: .asciz "NO\n"
	.align 8
	printf_yes: .asciz "YES\n"
	.align 8
.text
.global main
main:
	
	scan_string
	lgfi %r2,0
	larl %r3, label
	length_finder:
	llc %r4, 0(%r3)	
	lgfi %r7, 0	
	cr %r7, %r4
	je end_length
	agfi %r2, 1
	agfi %r3, 1
	j length_finder
end_length:
	lgfi %r3, 0
	agfi %r2, -1
	larl %r4, label
	loop:
	cr %r3, %r2
	jh print_yes
	llc %r5, 0(%r3, %r4)
	llc %r6, 0(%r2, %r4)
	cr %r5, %r6
	jne print_no
	agfi %r2,-1
	agfi %r3, 1
	j loop
print_yes:
	enter 0
        larl %r2, printf_yes
        call printf
        leave 0
	j end
print_no:
	enter 0
	larl %r2, printf_no
	call printf
	leave 0
end:	
	xgr %r2, %r2
	ret
