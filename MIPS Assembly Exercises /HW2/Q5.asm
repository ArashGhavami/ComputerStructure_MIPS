# 402106723 402106359

.text
.globl main

main:
	la $s0, zarayeb
	li $v0, 5
	syscall
	add $s1, $zero, $v0
	li $t0, 1
	mul $t1, $t0, $s1
	mul $t2, $t1, $s1
	mul $t3, $t2, $s1
	lw $s3, 12($s0)
	lw $t5, 8($s0)
	mul $t5, $t5, $t1
	add $s3, $s3, $t5
	lw $t5, 4($s0)
	mul $t5, $t5, $t2
	add $s3, $s3, $t5
	lw $t5, 0($s0)
	mul $t5, $t5, $t3
	add $s3, $s3, $t5
	li $v0, 1
	add $a0, $zero, $s3
	syscall
	li $v0, 10
	syscall
.data
zarayeb: .word 3, 5, 2, 4 # a, b, c, d
