# 402106723 402106359

.text
.globl main
main:

	la $s3, array
	li $v0, 5
	syscall
	add $s0, $v0, $zero # first number
	li $v0, 12
	syscall
	li $t6, 43
	sub $t0, $v0, $t6 # 0 or 2
	li $v0, 12
	syscall
	li $v0, 5
	syscall
	add $s1, $v0, $zero # second number
	
	add $t1, $s0, $s1
	sw $t1, 0($s3)
	sub $t1, $s0, $s1
	sw $t1, 8($s3)
	
	add $t0, $t0 $t0
	add $t0, $t0, $t0 # now $t0 has been multiplied by 4
	add $s3, $s3, $t0
	
	li $v0, 1
	lw $a0, 0($s3)
	syscall
	
	li $v0, 10
	syscall

.data
array: .word 0, 0, 0
