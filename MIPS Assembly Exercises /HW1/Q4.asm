# 402106723 402106359

.text
.globl main
main:

	la $s1, num1
	la $s2, num2
	
	lw $s3, 0($s1) # first number
	lw $s4, 0($s2) # second number
	
	sub $t0, $s3, $s4
	srl $t0, $t0, 31 # ($s3 < $s4) -> 1, ($s3 >= $s4) -> 0
	mul $t4, $t0, $s4
	addi $t5, $zero, 1
	xor $t0, $t0, $t5 # $t0 ^= 1
	mul $t3, $t0, $s3
	add $t3, $t3, $t4 # 1 * max + 0 * min
	
	la $s5, max_value
	sw $t3, 0($s5)
	
	li $v0, 10
	syscall

.data
num1:
	.word 19
num2:
	.word 21
max_value:
	.space 4
