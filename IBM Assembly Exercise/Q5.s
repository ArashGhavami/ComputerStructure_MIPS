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

.macro endl
	enter 0
	larl %r2, endline
	call printf
	leave 0
.endm

.data
	.align 8
	label: .space 104
	.align 8
	rsf: .asciz "%s"
	.align 8
	print_num: .asciz "%d"
	.align 8
	endline: .asciz "\n"
	.align 8
	max_ones: .asciz "max number of consecutive ones: "
	.align 8
	max_zeros: .asciz "max number of consecutive zeros: "
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
	lr %r0, %r2
	lr %r7, %r2
	lgfi %r8, 0 # max
	lgfi %r9, 0 # max by now	
	larl %r11, label
	loop:
	agfi %r7, -1
	lgfi %r6,0
	cr %r6, %r7
	je out
	
	llc %r10, 0(%r11, %r7)	
	lgfi %r13, 48
	cr %r10, %r13
	je zero_sec
	cr %r8, %r9	
	jh set_true
	lr %r8, %r9
	lgfi %r9, 0
	j loop
zero_sec:
	agfi %r9, 1
	j loop
set_true:
	lgfi %r9, 0
	j loop
out:	
	cr %r8, %r9
	jh finish1
	lr %r8, %r9
finish1:
	
	lr %r12, %r0
	enter 0
	larl %r2, max_zeros
	call printf
	leave 0

	enter 0
	lr %r3, %r8
	larl %r2, print_num
	call printf
	leave 0
	endl

	lr %r2, %r12
	lr %r7, %r2
        lgfi %r8, 0 # max
        lgfi %r9, 0 # max by now        
        larl %r11, label
        loop1:
        agfi %r7,-1
        lgfi %r6, -1
        cr %r6, %r7
        je out1
        llc %r10, 0(%r7, %r11) #this line occurs bug
	 
	lgfi %r13, 49
     
	cr %r10, %r13   
	je zero_sec1
        cr %r8, %r9
        jh set_true1
	
        lr %r8, %r9
        lgfi %r9, 0
        j loop1
zero_sec1:
        agfi %r9, 1
        j loop1
set_true1:
	
       lgfi %r9, 0
        j loop1
out1:	
	
        cr %r8, %r9
        jh finish11
        lr %r8, %r9
finish11:
	
        lr %r12, %r2
	enter 0
	larl %r2, max_ones
	call printf
	leave 0
        enter 0
        lr %r3, %r8
        larl %r2, print_num
        call printf
        leave 0
	endl	
end:
	xgr %r2, %r2
	ret