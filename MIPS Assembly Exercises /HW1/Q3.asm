# 402106723 402106359

.text
.globl main
main:

	la $s3, array
	lw $t1, 0($s3)
	lw $t2, 24($s3)
	xor $t0, $t1, $t2
	add $s0, $t0, $zero
	lw $t1, 4($s3)
	lw $t2, 20($s3)
	xor $t0, $t1, $t2
	or $s0, $s0, $t0
	lw $t1, 8($s3)
	lw $t2, 16($s3)
	xor $t0, $t1, $t2
	or $s0, $s0, $t0
	
	srl $t0, $s0, 16
	or $s0, $s0, $t0
	srl $t0, $s0, 8
	or $s0, $s0, $t0
	srl $t0, $s0, 4
	or $s0, $s0, $t0
	srl $t0, $s0, 2
	or $s0, $s0, $t0
	srl $t0, $s0, 1
	or $s0, $s0, $t0
	
	sll $s0, $s0, 31
	srl $s0, $s0, 31
	xori $s0, $s0, 1
	add $a0, $s0, $zero

	li $v0, 10
	syscall

.data
	array: .word 1, 2, 3, 5, 3, 2, 1
	length: .word 7
	one: .word 1
