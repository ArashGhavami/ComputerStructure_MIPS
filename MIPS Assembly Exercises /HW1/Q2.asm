# 402106723 402106359

.text
.globl main
main:
	
	li $v0, 5
	syscall
	move $s0, $v0 # a
	li $v0, 5
	syscall
	move $s1, $v0 # b
	li $v0, 5
	syscall
	move $s2, $v0 # c
	
	mul $t0, $s1, $s1
	mul $t1, $s0, $s2
	sll $t1, $t1, 2
	sub $t0, $t0, $t1 # b^2 - 4ac
	sll $s0, $s0, 1 # 2a
	mul $s1, $s1, -1 # -b
	
	mtc1 $s1, $f0 # -b (for first answer)
	cvt.s.w $f0, $f0
	mtc1 $s1, $f1 # -b (for second answer)
	cvt.s.w $f1, $f1
	mtc1 $t0, $f2 # b^2 - 4ac
	cvt.s.w $f2, $f2
	mtc1 $s0, $f3 # 2a
	cvt.s.w $f3, $f3
	
	sqrt.s $f2, $f2
	add.s $f0, $f0, $f2
	div.s $f0, $f0, $f3 # first answer
	sub.s $f1, $f1, $f2
	div.s $f1, $f1, $f3 # second answer
	
	li $v0, 2
	mov.s $f12, $f0
	syscall
	li $v0, 11
	li $a0, 10
	syscall
	li $v0, 2
	mov.s $f12, $f1
	syscall
	
	li $v0, 10
	syscall
